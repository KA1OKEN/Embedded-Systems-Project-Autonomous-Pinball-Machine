
_main:

;Pinball.c,42 :: 		void main() {
;Pinball.c,45 :: 		TRISB = 0x07; // Initialize PORTB as inputs for the IR sensors
	MOVLW      7
	MOVWF      TRISB+0
;Pinball.c,46 :: 		TRISD = 0x00;// Initialize PORTD as outputs for the LCD
	CLRF       TRISD+0
;Pinball.c,47 :: 		Lcd_Init(); // Initialize LCD
	CALL       _Lcd_Init+0
;Pinball.c,51 :: 		TRISC = 0xFF; // Set PORTC as input
	MOVLW      255
	MOVWF      TRISC+0
;Pinball.c,52 :: 		pwm_init(); // Initialize PWM module
	CALL       _pwm_init+0
;Pinball.c,53 :: 		PORTC = 0x00; // Clear PORTC
	CLRF       PORTC+0
;Pinball.c,55 :: 		Delay_ms(100);// Delay to let system stabilize
	MOVLW      2
	MOVWF      R11+0
	MOVLW      4
	MOVWF      R12+0
	MOVLW      186
	MOVWF      R13+0
L_main0:
	DECFSZ     R13+0, 1
	GOTO       L_main0
	DECFSZ     R12+0, 1
	GOTO       L_main0
	DECFSZ     R11+0, 1
	GOTO       L_main0
	NOP
;Pinball.c,58 :: 		previousState1 = PORTB & 0x01;
	MOVLW      1
	ANDWF      PORTB+0, 0
	MOVWF      _previousState1+0
;Pinball.c,59 :: 		previousState2 = (PORTB >> 1) & 0x01;
	MOVF       PORTB+0, 0
	MOVWF      _previousState2+0
	RRF        _previousState2+0, 1
	BCF        _previousState2+0, 7
	MOVLW      1
	ANDWF      _previousState2+0, 1
;Pinball.c,60 :: 		previousState3 = (PORTB >> 2) & 0x01;
	MOVF       PORTB+0, 0
	MOVWF      _previousState3+0
	RRF        _previousState3+0, 1
	BCF        _previousState3+0, 7
	RRF        _previousState3+0, 1
	BCF        _previousState3+0, 7
	MOVLW      1
	ANDWF      _previousState3+0, 1
;Pinball.c,62 :: 		highScore = (EEPROM_Read(0x00) << 8) | EEPROM_Read(0x01);
	CLRF       FARG_EEPROM_Read_Address+0
	CALL       _EEPROM_Read+0
	MOVF       R0+0, 0
	MOVWF      FLOC__main+1
	CLRF       FLOC__main+0
	MOVLW      1
	MOVWF      FARG_EEPROM_Read_Address+0
	CALL       _EEPROM_Read+0
	MOVF       R0+0, 0
	IORWF      FLOC__main+0, 0
	MOVWF      _highScore+0
	MOVF       FLOC__main+1, 0
	MOVWF      _highScore+1
	MOVLW      0
	IORWF      _highScore+1, 1
;Pinball.c,63 :: 		updateLCD();// Display initial score
	CALL       _updateLCD+0
;Pinball.c,64 :: 		set_servo_position1(0);
	CLRF       FARG_set_servo_position1_degrees+0
	CLRF       FARG_set_servo_position1_degrees+1
	CALL       _set_servo_position1+0
;Pinball.c,65 :: 		set_servo_position2(60);
	MOVLW      60
	MOVWF      FARG_set_servo_position2_degrees+0
	MOVLW      0
	MOVWF      FARG_set_servo_position2_degrees+1
	CALL       _set_servo_position2+0
;Pinball.c,66 :: 		while(1){
L_main1:
;Pinball.c,67 :: 		check_ball();
	CALL       _check_ball+0
;Pinball.c,68 :: 		checkSensors();
	CALL       _checkSensors+0
;Pinball.c,69 :: 		temp3 = !(PORTC & 0x40);
	MOVLW      64
	ANDWF      PORTC+0, 0
	MOVWF      _temp3+0
	CLRF       _temp3+1
	MOVLW      0
	ANDWF      _temp3+1, 1
	MOVF       _temp3+0, 0
	MOVLW      1
	BTFSS      STATUS+0, 2
	MOVLW      0
	MOVWF      _temp3+0
	MOVWF      _temp3+1
	MOVLW      0
	MOVWF      _temp3+1
;Pinball.c,70 :: 		if(temp3){
	MOVF       _temp3+0, 0
	IORWF      _temp3+1, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main3
;Pinball.c,71 :: 		while(temp3){
L_main4:
	MOVF       _temp3+0, 0
	IORWF      _temp3+1, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main5
;Pinball.c,72 :: 		GameOver();
	CALL       _GameOver+0
;Pinball.c,73 :: 		Delay_ms(1000);
	MOVLW      11
	MOVWF      R11+0
	MOVLW      38
	MOVWF      R12+0
	MOVLW      93
	MOVWF      R13+0
L_main6:
	DECFSZ     R13+0, 1
	GOTO       L_main6
	DECFSZ     R12+0, 1
	GOTO       L_main6
	DECFSZ     R11+0, 1
	GOTO       L_main6
	NOP
	NOP
;Pinball.c,74 :: 		temp3 = !(PORTC & 0x40);
	MOVLW      64
	ANDWF      PORTC+0, 0
	MOVWF      _temp3+0
	CLRF       _temp3+1
	MOVLW      0
	ANDWF      _temp3+1, 1
	MOVF       _temp3+0, 0
	MOVLW      1
	BTFSS      STATUS+0, 2
	MOVLW      0
	MOVWF      _temp3+0
	MOVWF      _temp3+1
	MOVLW      0
	MOVWF      _temp3+1
;Pinball.c,75 :: 		}
	GOTO       L_main4
L_main5:
;Pinball.c,76 :: 		currentScore = 0;
	CLRF       _currentScore+0
	CLRF       _currentScore+1
;Pinball.c,77 :: 		}
L_main3:
;Pinball.c,78 :: 		Delay_ms(100);
	MOVLW      2
	MOVWF      R11+0
	MOVLW      4
	MOVWF      R12+0
	MOVLW      186
	MOVWF      R13+0
L_main7:
	DECFSZ     R13+0, 1
	GOTO       L_main7
	DECFSZ     R12+0, 1
	GOTO       L_main7
	DECFSZ     R11+0, 1
	GOTO       L_main7
	NOP
;Pinball.c,79 :: 		}
	GOTO       L_main1
;Pinball.c,80 :: 		}
L_end_main:
	GOTO       $+0
; end of _main

_intToStr:

;Pinball.c,82 :: 		void intToStr(unsigned int num, unsigned char* str) {
;Pinball.c,83 :: 		unsigned int i = 0;
	CLRF       intToStr_i_L0+0
	CLRF       intToStr_i_L0+1
;Pinball.c,85 :: 		do {
L_intToStr8:
;Pinball.c,86 :: 		str[i++] = '0' + num % 10;
	MOVF       intToStr_i_L0+0, 0
	ADDWF      FARG_intToStr_str+0, 0
	MOVWF      FLOC__intToStr+0
	MOVLW      10
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVF       FARG_intToStr_num+0, 0
	MOVWF      R0+0
	MOVF       FARG_intToStr_num+1, 0
	MOVWF      R0+1
	CALL       _Div_16X16_U+0
	MOVF       R8+0, 0
	MOVWF      R0+0
	MOVF       R8+1, 0
	MOVWF      R0+1
	MOVLW      48
	ADDWF      R0+0, 1
	MOVF       FLOC__intToStr+0, 0
	MOVWF      FSR
	MOVF       R0+0, 0
	MOVWF      INDF+0
	INCF       intToStr_i_L0+0, 1
	BTFSC      STATUS+0, 2
	INCF       intToStr_i_L0+1, 1
;Pinball.c,87 :: 		num /= 10;
	MOVLW      10
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVF       FARG_intToStr_num+0, 0
	MOVWF      R0+0
	MOVF       FARG_intToStr_num+1, 0
	MOVWF      R0+1
	CALL       _Div_16X16_U+0
	MOVF       R0+0, 0
	MOVWF      FARG_intToStr_num+0
	MOVF       R0+1, 0
	MOVWF      FARG_intToStr_num+1
;Pinball.c,88 :: 		} while(num);
	MOVF       R0+0, 0
	IORWF      R0+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L_intToStr8
;Pinball.c,91 :: 		for(j = 0; j < i / 2; j++) {  // Use j without declaring it again
	CLRF       intToStr_j_L0+0
	CLRF       intToStr_j_L0+1
L_intToStr11:
	MOVF       intToStr_i_L0+0, 0
	MOVWF      R1+0
	MOVF       intToStr_i_L0+1, 0
	MOVWF      R1+1
	RRF        R1+1, 1
	RRF        R1+0, 1
	BCF        R1+1, 7
	MOVF       R1+1, 0
	SUBWF      intToStr_j_L0+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__intToStr57
	MOVF       R1+0, 0
	SUBWF      intToStr_j_L0+0, 0
L__intToStr57:
	BTFSC      STATUS+0, 0
	GOTO       L_intToStr12
;Pinball.c,92 :: 		unsigned char temp = str[j];
	MOVF       intToStr_j_L0+0, 0
	ADDWF      FARG_intToStr_str+0, 0
	MOVWF      R2+0
	MOVF       R2+0, 0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      intToStr_temp_L1+0
;Pinball.c,93 :: 		str[j] = str[i - j - 1];
	MOVF       intToStr_j_L0+0, 0
	SUBWF      intToStr_i_L0+0, 0
	MOVWF      R0+0
	MOVF       intToStr_j_L0+1, 0
	BTFSS      STATUS+0, 0
	ADDLW      1
	SUBWF      intToStr_i_L0+1, 0
	MOVWF      R0+1
	MOVLW      1
	SUBWF      R0+0, 1
	BTFSS      STATUS+0, 0
	DECF       R0+1, 1
	MOVF       R0+0, 0
	ADDWF      FARG_intToStr_str+0, 0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      R0+0
	MOVF       R2+0, 0
	MOVWF      FSR
	MOVF       R0+0, 0
	MOVWF      INDF+0
;Pinball.c,94 :: 		str[i - j - 1] = temp;
	MOVF       intToStr_j_L0+0, 0
	SUBWF      intToStr_i_L0+0, 0
	MOVWF      R0+0
	MOVF       intToStr_j_L0+1, 0
	BTFSS      STATUS+0, 0
	ADDLW      1
	SUBWF      intToStr_i_L0+1, 0
	MOVWF      R0+1
	MOVLW      1
	SUBWF      R0+0, 1
	BTFSS      STATUS+0, 0
	DECF       R0+1, 1
	MOVF       R0+0, 0
	ADDWF      FARG_intToStr_str+0, 0
	MOVWF      FSR
	MOVF       intToStr_temp_L1+0, 0
	MOVWF      INDF+0
;Pinball.c,91 :: 		for(j = 0; j < i / 2; j++) {  // Use j without declaring it again
	INCF       intToStr_j_L0+0, 1
	BTFSC      STATUS+0, 2
	INCF       intToStr_j_L0+1, 1
;Pinball.c,95 :: 		}
	GOTO       L_intToStr11
L_intToStr12:
;Pinball.c,98 :: 		str[i] = '\0';
	MOVF       intToStr_i_L0+0, 0
	ADDWF      FARG_intToStr_str+0, 0
	MOVWF      FSR
	CLRF       INDF+0
;Pinball.c,99 :: 		}
L_end_intToStr:
	RETURN
; end of _intToStr

_updateLCD:

;Pinball.c,102 :: 		void updateLCD() {
;Pinball.c,107 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;Pinball.c,109 :: 		intToStr(currentScore, scoreStr);
	MOVF       _currentScore+0, 0
	MOVWF      FARG_intToStr_num+0
	MOVF       _currentScore+1, 0
	MOVWF      FARG_intToStr_num+1
	MOVLW      updateLCD_scoreStr_L0+0
	MOVWF      FARG_intToStr_str+0
	CALL       _intToStr+0
;Pinball.c,110 :: 		intToStr(highScore, highScoreStr);
	MOVF       _highScore+0, 0
	MOVWF      FARG_intToStr_num+0
	MOVF       _highScore+1, 0
	MOVWF      FARG_intToStr_num+1
	MOVLW      updateLCD_highScoreStr_L0+0
	MOVWF      FARG_intToStr_str+0
	CALL       _intToStr+0
;Pinball.c,113 :: 		Lcd_Out(1, 1, "Score: ");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr1_Pinball+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Pinball.c,114 :: 		Lcd_Out(1, 8, scoreStr);  // Adjusted column index
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      8
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      updateLCD_scoreStr_L0+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Pinball.c,117 :: 		Lcd_Out(2, 1, "High Score: ");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr2_Pinball+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Pinball.c,118 :: 		Lcd_Out(2, 13, highScoreStr);  // Adjusted column index
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      13
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      updateLCD_highScoreStr_L0+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Pinball.c,119 :: 		}
L_end_updateLCD:
	RETURN
; end of _updateLCD

_checkSensors:

;Pinball.c,121 :: 		void checkSensors() {
;Pinball.c,127 :: 		if (PORTB & 0x01) {
	BTFSS      PORTB+0, 0
	GOTO       L_checkSensors14
;Pinball.c,128 :: 		if (!previousState1 && ++count1 > 2) {
	MOVF       _previousState1+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L_checkSensors17
	INCF       checkSensors_count1_L0+0, 1
	MOVF       checkSensors_count1_L0+0, 0
	SUBLW      2
	BTFSC      STATUS+0, 0
	GOTO       L_checkSensors17
L__checkSensors54:
;Pinball.c,129 :: 		currentScore += 10;
	MOVLW      10
	ADDWF      _currentScore+0, 1
	BTFSC      STATUS+0, 0
	INCF       _currentScore+1, 1
;Pinball.c,130 :: 		updateLCD();
	CALL       _updateLCD+0
;Pinball.c,131 :: 		previousState1 = 1;
	MOVLW      1
	MOVWF      _previousState1+0
;Pinball.c,132 :: 		count1 = 0;
	CLRF       checkSensors_count1_L0+0
;Pinball.c,133 :: 		}
L_checkSensors17:
;Pinball.c,134 :: 		} else {
	GOTO       L_checkSensors18
L_checkSensors14:
;Pinball.c,135 :: 		count1 = 0;
	CLRF       checkSensors_count1_L0+0
;Pinball.c,136 :: 		previousState1 = 0;
	CLRF       _previousState1+0
;Pinball.c,137 :: 		}
L_checkSensors18:
;Pinball.c,140 :: 		if (PORTB & 0x02) {
	BTFSS      PORTB+0, 1
	GOTO       L_checkSensors19
;Pinball.c,141 :: 		if (!previousState2 && ++count2 > 2) {
	MOVF       _previousState2+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L_checkSensors22
	INCF       checkSensors_count2_L0+0, 1
	MOVF       checkSensors_count2_L0+0, 0
	SUBLW      2
	BTFSC      STATUS+0, 0
	GOTO       L_checkSensors22
L__checkSensors53:
;Pinball.c,142 :: 		currentScore += 20;
	MOVLW      20
	ADDWF      _currentScore+0, 1
	BTFSC      STATUS+0, 0
	INCF       _currentScore+1, 1
;Pinball.c,143 :: 		updateLCD();
	CALL       _updateLCD+0
;Pinball.c,144 :: 		previousState2 = 1;
	MOVLW      1
	MOVWF      _previousState2+0
;Pinball.c,145 :: 		count2 = 0;
	CLRF       checkSensors_count2_L0+0
;Pinball.c,146 :: 		}
L_checkSensors22:
;Pinball.c,147 :: 		} else {
	GOTO       L_checkSensors23
L_checkSensors19:
;Pinball.c,148 :: 		count2 = 0;
	CLRF       checkSensors_count2_L0+0
;Pinball.c,149 :: 		previousState2 = 0;
	CLRF       _previousState2+0
;Pinball.c,150 :: 		}
L_checkSensors23:
;Pinball.c,153 :: 		if (PORTB & 0x04) {
	BTFSS      PORTB+0, 2
	GOTO       L_checkSensors24
;Pinball.c,154 :: 		if (!previousState3 && ++count3 > 2) {
	MOVF       _previousState3+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L_checkSensors27
	INCF       checkSensors_count3_L0+0, 1
	MOVF       checkSensors_count3_L0+0, 0
	SUBLW      2
	BTFSC      STATUS+0, 0
	GOTO       L_checkSensors27
L__checkSensors52:
;Pinball.c,155 :: 		currentScore += 30;
	MOVLW      30
	ADDWF      _currentScore+0, 1
	BTFSC      STATUS+0, 0
	INCF       _currentScore+1, 1
;Pinball.c,156 :: 		updateLCD();
	CALL       _updateLCD+0
;Pinball.c,157 :: 		previousState3 = 1;
	MOVLW      1
	MOVWF      _previousState3+0
;Pinball.c,158 :: 		count3 = 0;
	CLRF       checkSensors_count3_L0+0
;Pinball.c,159 :: 		}
L_checkSensors27:
;Pinball.c,160 :: 		} else {
	GOTO       L_checkSensors28
L_checkSensors24:
;Pinball.c,161 :: 		count3 = 0;
	CLRF       checkSensors_count3_L0+0
;Pinball.c,162 :: 		previousState3 = 0;
	CLRF       _previousState3+0
;Pinball.c,163 :: 		}
L_checkSensors28:
;Pinball.c,165 :: 		if (currentScore > highScore) {
	MOVF       _currentScore+1, 0
	SUBWF      _highScore+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__checkSensors60
	MOVF       _currentScore+0, 0
	SUBWF      _highScore+0, 0
L__checkSensors60:
	BTFSC      STATUS+0, 0
	GOTO       L_checkSensors29
;Pinball.c,166 :: 		highScore = currentScore;
	MOVF       _currentScore+0, 0
	MOVWF      _highScore+0
	MOVF       _currentScore+1, 0
	MOVWF      _highScore+1
;Pinball.c,168 :: 		EEPROM_Write(0x00, highScore >> 8);  // High byte
	CLRF       FARG_EEPROM_Write_Address+0
	MOVF       _currentScore+1, 0
	MOVWF      R0+0
	CLRF       R0+1
	MOVF       R0+0, 0
	MOVWF      FARG_EEPROM_Write_data_+0
	CALL       _EEPROM_Write+0
;Pinball.c,169 :: 		EEPROM_Write(0x01, highScore & 0xFF);  // Low byte
	MOVLW      1
	MOVWF      FARG_EEPROM_Write_Address+0
	MOVLW      255
	ANDWF      _highScore+0, 0
	MOVWF      FARG_EEPROM_Write_data_+0
	CALL       _EEPROM_Write+0
;Pinball.c,170 :: 		}
L_checkSensors29:
;Pinball.c,172 :: 		updateLCD();
	CALL       _updateLCD+0
;Pinball.c,173 :: 		}
L_end_checkSensors:
	RETURN
; end of _checkSensors

_GameOver:

;Pinball.c,175 :: 		void GameOver(){
;Pinball.c,176 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;Pinball.c,178 :: 		intToStr(currentScore, finalScore);
	MOVF       _currentScore+0, 0
	MOVWF      FARG_intToStr_num+0
	MOVF       _currentScore+1, 0
	MOVWF      FARG_intToStr_num+1
	MOVLW      _finalScore+0
	MOVWF      FARG_intToStr_str+0
	CALL       _intToStr+0
;Pinball.c,180 :: 		Lcd_Out(1, 4, "GAME OVER!");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      4
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr3_Pinball+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Pinball.c,182 :: 		Lcd_Out(2, 2, "Score: ");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      2
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr4_Pinball+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Pinball.c,183 :: 		Lcd_Out(2, 9, finalScore);
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      9
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      _finalScore+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Pinball.c,184 :: 		}
L_end_GameOver:
	RETURN
; end of _GameOver

_Delay_us:

;Pinball.c,187 :: 		void Delay_us(unsigned int microseconds) {
;Pinball.c,190 :: 		while (microseconds--) {
L_Delay_us30:
	MOVF       FARG_Delay_us_microseconds+0, 0
	MOVWF      R0+0
	MOVF       FARG_Delay_us_microseconds+1, 0
	MOVWF      R0+1
	MOVLW      1
	SUBWF      FARG_Delay_us_microseconds+0, 1
	BTFSS      STATUS+0, 0
	DECF       FARG_Delay_us_microseconds+1, 1
	MOVF       R0+0, 0
	IORWF      R0+1, 0
	BTFSC      STATUS+0, 2
	GOTO       L_Delay_us31
;Pinball.c,191 :: 		for (i = 0; i < 12; i++) {
	CLRF       R2+0
	CLRF       R2+1
L_Delay_us32:
	MOVLW      0
	SUBWF      R2+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Delay_us63
	MOVLW      12
	SUBWF      R2+0, 0
L__Delay_us63:
	BTFSC      STATUS+0, 0
	GOTO       L_Delay_us33
;Pinball.c,192 :: 		asm nop;
	NOP
;Pinball.c,191 :: 		for (i = 0; i < 12; i++) {
	INCF       R2+0, 1
	BTFSC      STATUS+0, 2
	INCF       R2+1, 1
;Pinball.c,193 :: 		}
	GOTO       L_Delay_us32
L_Delay_us33:
;Pinball.c,194 :: 		}
	GOTO       L_Delay_us30
L_Delay_us31:
;Pinball.c,195 :: 		}
L_end_Delay_us:
	RETURN
; end of _Delay_us

_Delay_ms:

;Pinball.c,197 :: 		void Delay_ms(unsigned int milliseconds) {
;Pinball.c,198 :: 		while (milliseconds--) {
L_Delay_ms35:
	MOVF       FARG_Delay_ms_milliseconds+0, 0
	MOVWF      R0+0
	MOVF       FARG_Delay_ms_milliseconds+1, 0
	MOVWF      R0+1
	MOVLW      1
	SUBWF      FARG_Delay_ms_milliseconds+0, 1
	BTFSS      STATUS+0, 0
	DECF       FARG_Delay_ms_milliseconds+1, 1
	MOVF       R0+0, 0
	IORWF      R0+1, 0
	BTFSC      STATUS+0, 2
	GOTO       L_Delay_ms36
;Pinball.c,199 :: 		Delay_us(1000);
	MOVLW      3
	MOVWF      R12+0
	MOVLW      151
	MOVWF      R13+0
L_Delay_ms37:
	DECFSZ     R13+0, 1
	GOTO       L_Delay_ms37
	DECFSZ     R12+0, 1
	GOTO       L_Delay_ms37
	NOP
	NOP
;Pinball.c,200 :: 		}
	GOTO       L_Delay_ms35
L_Delay_ms36:
;Pinball.c,201 :: 		}
L_end_Delay_ms:
	RETURN
; end of _Delay_ms

_pwm_init:

;Pinball.c,204 :: 		void pwm_init() {
;Pinball.c,205 :: 		TRISC = TRISC & 0xF9; // Set RC2 pin as output
	MOVLW      249
	ANDWF      TRISC+0, 1
;Pinball.c,208 :: 		CCP1CON = 0x0C; // Set CCP1M3 and CCP1M2 to 1, rest bits remain as they are
	MOVLW      12
	MOVWF      CCP1CON+0
;Pinball.c,211 :: 		CCP2CON = 0x0C;
	MOVLW      12
	MOVWF      CCP2CON+0
;Pinball.c,213 :: 		T2CON = T2CON | 0x07;// Set T2CKPS1, T2CKPS0, and TMR2ON to 1
	MOVLW      7
	IORWF      T2CON+0, 1
;Pinball.c,215 :: 		PR2 = 249; // Set period register for 50Hz frequency
	MOVLW      249
	MOVWF      PR2+0
;Pinball.c,216 :: 		}
L_end_pwm_init:
	RETURN
; end of _pwm_init

_set_servo_position1:

;Pinball.c,218 :: 		void set_servo_position1(int degrees) {
;Pinball.c,219 :: 		int pulse_width = (degrees + 90) * 8 + 500; // Calculate pulse width (500 to 2400)
	MOVLW      90
	ADDWF      FARG_set_servo_position1_degrees+0, 0
	MOVWF      R3+0
	MOVF       FARG_set_servo_position1_degrees+1, 0
	BTFSC      STATUS+0, 0
	ADDLW      1
	MOVWF      R3+1
	MOVLW      3
	MOVWF      R2+0
	MOVF       R3+0, 0
	MOVWF      R0+0
	MOVF       R3+1, 0
	MOVWF      R0+1
	MOVF       R2+0, 0
L__set_servo_position167:
	BTFSC      STATUS+0, 2
	GOTO       L__set_servo_position168
	RLF        R0+0, 1
	RLF        R0+1, 1
	BCF        R0+0, 0
	ADDLW      255
	GOTO       L__set_servo_position167
L__set_servo_position168:
	MOVLW      244
	ADDWF      R0+0, 0
	MOVWF      R3+0
	MOVF       R0+1, 0
	BTFSC      STATUS+0, 0
	ADDLW      1
	ADDLW      1
	MOVWF      R3+1
;Pinball.c,220 :: 		CCPR1L = pulse_width >> 2; // Set CCPR1L register
	MOVF       R3+0, 0
	MOVWF      R0+0
	MOVF       R3+1, 0
	MOVWF      R0+1
	RRF        R0+1, 1
	RRF        R0+0, 1
	BCF        R0+1, 7
	BTFSC      R0+1, 6
	BSF        R0+1, 7
	RRF        R0+1, 1
	RRF        R0+0, 1
	BCF        R0+1, 7
	BTFSC      R0+1, 6
	BSF        R0+1, 7
	MOVF       R0+0, 0
	MOVWF      CCPR1L+0
;Pinball.c,221 :: 		CCP1CON = (CCP1CON & 0xCF) | ((pulse_width & 0x03) << 4); // Set CCP1CON register
	MOVLW      207
	ANDWF      CCP1CON+0, 0
	MOVWF      R5+0
	MOVLW      3
	ANDWF      R3+0, 0
	MOVWF      R2+0
	MOVF       R2+0, 0
	MOVWF      R0+0
	RLF        R0+0, 1
	BCF        R0+0, 0
	RLF        R0+0, 1
	BCF        R0+0, 0
	RLF        R0+0, 1
	BCF        R0+0, 0
	RLF        R0+0, 1
	BCF        R0+0, 0
	MOVF       R0+0, 0
	IORWF      R5+0, 0
	MOVWF      CCP1CON+0
;Pinball.c,222 :: 		Delay_ms(50*4); // Delay for the servo to reach the desired position
	MOVLW      3
	MOVWF      R11+0
	MOVLW      8
	MOVWF      R12+0
	MOVLW      119
	MOVWF      R13+0
L_set_servo_position138:
	DECFSZ     R13+0, 1
	GOTO       L_set_servo_position138
	DECFSZ     R12+0, 1
	GOTO       L_set_servo_position138
	DECFSZ     R11+0, 1
	GOTO       L_set_servo_position138
;Pinball.c,223 :: 		}
L_end_set_servo_position1:
	RETURN
; end of _set_servo_position1

_set_servo_position2:

;Pinball.c,225 :: 		void set_servo_position2(int degrees) {
;Pinball.c,226 :: 		int pulse_width = (degrees + 90) * 8 + 500; // Calculate pulse width (500 to 2400)
	MOVLW      90
	ADDWF      FARG_set_servo_position2_degrees+0, 0
	MOVWF      R3+0
	MOVF       FARG_set_servo_position2_degrees+1, 0
	BTFSC      STATUS+0, 0
	ADDLW      1
	MOVWF      R3+1
	MOVLW      3
	MOVWF      R2+0
	MOVF       R3+0, 0
	MOVWF      R0+0
	MOVF       R3+1, 0
	MOVWF      R0+1
	MOVF       R2+0, 0
L__set_servo_position270:
	BTFSC      STATUS+0, 2
	GOTO       L__set_servo_position271
	RLF        R0+0, 1
	RLF        R0+1, 1
	BCF        R0+0, 0
	ADDLW      255
	GOTO       L__set_servo_position270
L__set_servo_position271:
	MOVLW      244
	ADDWF      R0+0, 0
	MOVWF      R3+0
	MOVF       R0+1, 0
	BTFSC      STATUS+0, 0
	ADDLW      1
	ADDLW      1
	MOVWF      R3+1
;Pinball.c,227 :: 		CCPR2L = pulse_width >> 2; // Set CCPR2L register
	MOVF       R3+0, 0
	MOVWF      R0+0
	MOVF       R3+1, 0
	MOVWF      R0+1
	RRF        R0+1, 1
	RRF        R0+0, 1
	BCF        R0+1, 7
	BTFSC      R0+1, 6
	BSF        R0+1, 7
	RRF        R0+1, 1
	RRF        R0+0, 1
	BCF        R0+1, 7
	BTFSC      R0+1, 6
	BSF        R0+1, 7
	MOVF       R0+0, 0
	MOVWF      CCPR2L+0
;Pinball.c,228 :: 		CCP2CON = (CCP2CON & 0xCF) | ((pulse_width & 0x03) << 4); // Set CCP2CON register
	MOVLW      207
	ANDWF      CCP2CON+0, 0
	MOVWF      R5+0
	MOVLW      3
	ANDWF      R3+0, 0
	MOVWF      R2+0
	MOVF       R2+0, 0
	MOVWF      R0+0
	RLF        R0+0, 1
	BCF        R0+0, 0
	RLF        R0+0, 1
	BCF        R0+0, 0
	RLF        R0+0, 1
	BCF        R0+0, 0
	RLF        R0+0, 1
	BCF        R0+0, 0
	MOVF       R0+0, 0
	IORWF      R5+0, 0
	MOVWF      CCP2CON+0
;Pinball.c,229 :: 		Delay_ms(50*4); // Delay for the servo to reach the desired position
	MOVLW      3
	MOVWF      R11+0
	MOVLW      8
	MOVWF      R12+0
	MOVLW      119
	MOVWF      R13+0
L_set_servo_position239:
	DECFSZ     R13+0, 1
	GOTO       L_set_servo_position239
	DECFSZ     R12+0, 1
	GOTO       L_set_servo_position239
	DECFSZ     R11+0, 1
	GOTO       L_set_servo_position239
;Pinball.c,230 :: 		}
L_end_set_servo_position2:
	RETURN
; end of _set_servo_position2

_check_ball:

;Pinball.c,234 :: 		void check_ball() {
;Pinball.c,235 :: 		if(!(PORTC & 0x20)){
	BTFSC      PORTC+0, 5
	GOTO       L_check_ball40
;Pinball.c,236 :: 		Delay_ms(500);
	MOVLW      6
	MOVWF      R11+0
	MOVLW      19
	MOVWF      R12+0
	MOVLW      173
	MOVWF      R13+0
L_check_ball41:
	DECFSZ     R13+0, 1
	GOTO       L_check_ball41
	DECFSZ     R12+0, 1
	GOTO       L_check_ball41
	DECFSZ     R11+0, 1
	GOTO       L_check_ball41
	NOP
	NOP
;Pinball.c,237 :: 		for(j = 0 ; j < 2 ; j++){
	CLRF       _j+0
	CLRF       _j+1
L_check_ball42:
	MOVLW      128
	XORWF      _j+1, 0
	MOVWF      R0+0
	MOVLW      128
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__check_ball73
	MOVLW      2
	SUBWF      _j+0, 0
L__check_ball73:
	BTFSC      STATUS+0, 0
	GOTO       L_check_ball43
;Pinball.c,238 :: 		set_servo_position1(60);
	MOVLW      60
	MOVWF      FARG_set_servo_position1_degrees+0
	MOVLW      0
	MOVWF      FARG_set_servo_position1_degrees+1
	CALL       _set_servo_position1+0
;Pinball.c,239 :: 		checkSensors();
	CALL       _checkSensors+0
;Pinball.c,240 :: 		Delay_us(250);
	MOVLW      166
	MOVWF      R13+0
L_check_ball45:
	DECFSZ     R13+0, 1
	GOTO       L_check_ball45
	NOP
;Pinball.c,241 :: 		set_servo_position1(0);
	CLRF       FARG_set_servo_position1_degrees+0
	CLRF       FARG_set_servo_position1_degrees+1
	CALL       _set_servo_position1+0
;Pinball.c,242 :: 		checkSensors();
	CALL       _checkSensors+0
;Pinball.c,237 :: 		for(j = 0 ; j < 2 ; j++){
	INCF       _j+0, 1
	BTFSC      STATUS+0, 2
	INCF       _j+1, 1
;Pinball.c,243 :: 		}
	GOTO       L_check_ball42
L_check_ball43:
;Pinball.c,244 :: 		}
L_check_ball40:
;Pinball.c,246 :: 		if(!(PORTC & 0x10)){
	BTFSC      PORTC+0, 4
	GOTO       L_check_ball46
;Pinball.c,247 :: 		Delay_ms(500);
	MOVLW      6
	MOVWF      R11+0
	MOVLW      19
	MOVWF      R12+0
	MOVLW      173
	MOVWF      R13+0
L_check_ball47:
	DECFSZ     R13+0, 1
	GOTO       L_check_ball47
	DECFSZ     R12+0, 1
	GOTO       L_check_ball47
	DECFSZ     R11+0, 1
	GOTO       L_check_ball47
	NOP
	NOP
;Pinball.c,248 :: 		for(k = 0 ; k < 2 ; k++){
	CLRF       _k+0
	CLRF       _k+1
L_check_ball48:
	MOVLW      128
	XORWF      _k+1, 0
	MOVWF      R0+0
	MOVLW      128
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__check_ball74
	MOVLW      2
	SUBWF      _k+0, 0
L__check_ball74:
	BTFSC      STATUS+0, 0
	GOTO       L_check_ball49
;Pinball.c,249 :: 		set_servo_position2(0);
	CLRF       FARG_set_servo_position2_degrees+0
	CLRF       FARG_set_servo_position2_degrees+1
	CALL       _set_servo_position2+0
;Pinball.c,250 :: 		checkSensors();
	CALL       _checkSensors+0
;Pinball.c,251 :: 		Delay_us(250);
	MOVLW      166
	MOVWF      R13+0
L_check_ball51:
	DECFSZ     R13+0, 1
	GOTO       L_check_ball51
	NOP
;Pinball.c,252 :: 		set_servo_position2(60);
	MOVLW      60
	MOVWF      FARG_set_servo_position2_degrees+0
	MOVLW      0
	MOVWF      FARG_set_servo_position2_degrees+1
	CALL       _set_servo_position2+0
;Pinball.c,253 :: 		checkSensors();
	CALL       _checkSensors+0
;Pinball.c,248 :: 		for(k = 0 ; k < 2 ; k++){
	INCF       _k+0, 1
	BTFSC      STATUS+0, 2
	INCF       _k+1, 1
;Pinball.c,254 :: 		}
	GOTO       L_check_ball48
L_check_ball49:
;Pinball.c,255 :: 		}
L_check_ball46:
;Pinball.c,256 :: 		}
L_end_check_ball:
	RETURN
; end of _check_ball
