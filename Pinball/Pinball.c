//lcd and obstacles(ir)
unsigned int currentScore = 0;
unsigned int highScore;
unsigned char previousState1;
unsigned char previousState2;
unsigned char previousState3;
unsigned int temp1;
unsigned int temp2;
unsigned int temp3;
int j = 0;
int k = 0;
unsigned char finalScore[6];

sbit LCD_RS at RD4_bit;
sbit LCD_EN at RD5_bit;
sbit LCD_RW at RD6_bit;
sbit LCD_D4 at RD0_bit;
sbit LCD_D5 at RD1_bit;
sbit LCD_D6 at RD2_bit;
sbit LCD_D7 at RD3_bit;

sbit LCD_RS_Direction at TRISD4_bit;
sbit LCD_EN_Direction at TRISD5_bit;
sbit LCD_RW_Direction at TRISD6_bit;
sbit LCD_D4_Direction at TRISD0_bit;
sbit LCD_D5_Direction at TRISD1_bit;
sbit LCD_D6_Direction at TRISD2_bit;
sbit LCD_D7_Direction at TRISD3_bit;

void updateLCD(void);
void intToStr(unsigned int num, unsigned char* str);
void updateLCD();
void checkSensors();
void GameOver();
void Delay_us(unsigned int microseconds);
void Delay_ms(unsigned int milliseconds);
void pwm_init();
void set_servo_position1(int degrees);
void set_servo_position2(int degrees);
void check_ball();

void main() {
     //init lcd and sensors

     TRISB = 0x07; // Initialize PORTB as inputs for the IR sensors
     TRISD = 0x00;// Initialize PORTD as outputs for the LCD
     Lcd_Init(); // Initialize LCD


     //inti servo
    TRISC = 0xFF; // Set PORTC as input
    pwm_init(); // Initialize PWM module
    PORTC = 0x00; // Clear PORTC

    Delay_ms(100);// Delay to let system stabilize

    // Initialize previous states based on the actual initial sensor readings
    previousState1 = PORTB & 0x01;
    previousState2 = (PORTB >> 1) & 0x01;
    previousState3 = (PORTB >> 2) & 0x01;

    highScore = (EEPROM_Read(0x00) << 8) | EEPROM_Read(0x01);
    updateLCD();// Display initial score
    set_servo_position1(0);
    set_servo_position2(60);
    while(1){
      check_ball();
      checkSensors();
      temp3 = !(PORTC & 0x40);
      if(temp3){
        while(temp3){
           GameOver();
           Delay_ms(1000);
           temp3 = !(PORTC & 0x40);
        }
        currentScore = 0;
      }
      Delay_ms(100);
    }
}

void intToStr(unsigned int num, unsigned char* str) {
    unsigned int i = 0;
    unsigned int j;  // Declare j outside of the loop
    do {
        str[i++] = '0' + num % 10;
        num /= 10;
    } while(num);

    // Reverse the string since the digits are backwards
    for(j = 0; j < i / 2; j++) {  // Use j without declaring it again
        unsigned char temp = str[j];
        str[j] = str[i - j - 1];
        str[i - j - 1] = temp;
    }

    // Null terminate the string
    str[i] = '\0';
}


void updateLCD() {
   // Create buffer to convert score to string
   unsigned char scoreStr[6];
   unsigned char highScoreStr[6];

   Lcd_Cmd(_LCD_CLEAR);
   // Convert scores to string
   intToStr(currentScore, scoreStr);
   intToStr(highScore, highScoreStr);

   // Update current score on LCD
   Lcd_Out(1, 1, "Score: ");
   Lcd_Out(1, 8, scoreStr);  // Adjusted column index

   // Update high score on LCD
   Lcd_Out(2, 1, "High Score: ");
   Lcd_Out(2, 13, highScoreStr);  // Adjusted column index
}

void checkSensors() {
   static unsigned char count1 = 0;
   static unsigned char count2 = 0;
   static unsigned char count3 = 0;

   // Check RB0 and previous state
   if (PORTB & 0x01) {
       if (!previousState1 && ++count1 > 2) {
           currentScore += 10;
           updateLCD();
           previousState1 = 1;
           count1 = 0;
       }
   } else {
       count1 = 0;
       previousState1 = 0;
   }

   // Check RB1 and previous state
   if (PORTB & 0x02) {
       if (!previousState2 && ++count2 > 2) {
           currentScore += 20;
           updateLCD();
           previousState2 = 1;
           count2 = 0;
       }
   } else {
       count2 = 0;
       previousState2 = 0;
   }

   // Check RB2 and previous state
   if (PORTB & 0x04) {
       if (!previousState3 && ++count3 > 2) {
           currentScore += 30;
           updateLCD();
           previousState3 = 1;
           count3 = 0;
       }
   } else {
       count3 = 0;
       previousState3 = 0;
   }

   if (currentScore > highScore) {
      highScore = currentScore;
      // Write the new high score to EEPROM
      EEPROM_Write(0x00, highScore >> 8);  // High byte
      EEPROM_Write(0x01, highScore & 0xFF);  // Low byte
   }

   updateLCD();
}

 void GameOver(){
   Lcd_Cmd(_LCD_CLEAR);

   intToStr(currentScore, finalScore);

   Lcd_Out(1, 4, "GAME OVER!");

   Lcd_Out(2, 2, "Score: ");
   Lcd_Out(2, 9, finalScore);
 }


 void Delay_us(unsigned int microseconds) {
    unsigned int i;

    while (microseconds--) {
        for (i = 0; i < 12; i++) {
            asm nop;
        }
    }
}

void Delay_ms(unsigned int milliseconds) {
    while (milliseconds--) {
        Delay_us(1000);
    }
}

//servo
void pwm_init() {
    TRISC = TRISC & 0xF9; // Set RC2 pin as output

    // Configure CCP1 module for PWM (for servo on RC2)
    CCP1CON = 0x0C; // Set CCP1M3 and CCP1M2 to 1, rest bits remain as they are

    // Configure CCP2 module for PWM (for servo on RC1)
    CCP2CON = 0x0C;

    T2CON = T2CON | 0x07;// Set T2CKPS1, T2CKPS0, and TMR2ON to 1

    PR2 = 249; // Set period register for 50Hz frequency
}

void set_servo_position1(int degrees) {
    int pulse_width = (degrees + 90) * 8 + 500; // Calculate pulse width (500 to 2400)
    CCPR1L = pulse_width >> 2; // Set CCPR1L register
    CCP1CON = (CCP1CON & 0xCF) | ((pulse_width & 0x03) << 4); // Set CCP1CON register
    Delay_ms(50*4); // Delay for the servo to reach the desired position
}

void set_servo_position2(int degrees) {
    int pulse_width = (degrees + 90) * 8 + 500; // Calculate pulse width (500 to 2400)
    CCPR2L = pulse_width >> 2; // Set CCPR2L register
    CCP2CON = (CCP2CON & 0xCF) | ((pulse_width & 0x03) << 4); // Set CCP2CON register
    Delay_ms(50*4); // Delay for the servo to reach the desired position
}

//ir

void check_ball() {
     if(!(PORTC & 0x20)){
        Delay_ms(500);
        for(j = 0 ; j < 2 ; j++){
          set_servo_position1(60);
          checkSensors();
          Delay_us(250);
          set_servo_position1(0);
          checkSensors();
        }
     }

     if(!(PORTC & 0x10)){
        Delay_ms(500);
        for(k = 0 ; k < 2 ; k++){
          set_servo_position2(0);
          checkSensors();
          Delay_us(250);
          set_servo_position2(60);
          checkSensors();
        }
     }
}