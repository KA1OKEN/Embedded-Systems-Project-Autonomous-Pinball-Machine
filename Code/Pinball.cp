#line 1 "C:/Users/saleh/Desktop/Pinball/Pinball.c"

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


 TRISB = 0x07;
 TRISD = 0x00;
 Lcd_Init();



 TRISC = 0xFF;
 pwm_init();
 PORTC = 0x00;

 Delay_ms(100);


 previousState1 = PORTB & 0x01;
 previousState2 = (PORTB >> 1) & 0x01;
 previousState3 = (PORTB >> 2) & 0x01;

 highScore = (EEPROM_Read(0x00) << 8) | EEPROM_Read(0x01);
 updateLCD();
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
 unsigned int j;
 do {
 str[i++] = '0' + num % 10;
 num /= 10;
 } while(num);


 for(j = 0; j < i / 2; j++) {
 unsigned char temp = str[j];
 str[j] = str[i - j - 1];
 str[i - j - 1] = temp;
 }


 str[i] = '\0';
}


void updateLCD() {

 unsigned char scoreStr[6];
 unsigned char highScoreStr[6];

 Lcd_Cmd(_LCD_CLEAR);

 intToStr(currentScore, scoreStr);
 intToStr(highScore, highScoreStr);


 Lcd_Out(1, 1, "Score: ");
 Lcd_Out(1, 8, scoreStr);


 Lcd_Out(2, 1, "High Score: ");
 Lcd_Out(2, 13, highScoreStr);
}

void checkSensors() {
 static unsigned char count1 = 0;
 static unsigned char count2 = 0;
 static unsigned char count3 = 0;


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

 EEPROM_Write(0x00, highScore >> 8);
 EEPROM_Write(0x01, highScore & 0xFF);
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


void pwm_init() {
 TRISC = TRISC & 0xF9;


 CCP1CON = 0x0C;


 CCP2CON = 0x0C;

 T2CON = T2CON | 0x07;

 PR2 = 249;
}

void set_servo_position1(int degrees) {
 int pulse_width = (degrees + 90) * 8 + 500;
 CCPR1L = pulse_width >> 2;
 CCP1CON = (CCP1CON & 0xCF) | ((pulse_width & 0x03) << 4);
 Delay_ms(50*4);
}

void set_servo_position2(int degrees) {
 int pulse_width = (degrees + 90) * 8 + 500;
 CCPR2L = pulse_width >> 2;
 CCP2CON = (CCP2CON & 0xCF) | ((pulse_width & 0x03) << 4);
 Delay_ms(50*4);
}



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
