
_main:

;eae.c,27 :: 		void main() {
;eae.c,33 :: 		ANSEL = 0b00110000;                                                //1 pino como analógico
	MOVLW      48
	MOVWF      ANSEL+0
;eae.c,34 :: 		ANSELH = 0b00010100;                                               //0 pino como digital
	MOVLW      20
	MOVWF      ANSELH+0
;eae.c,36 :: 		TRISA = 0b00100000;                                                //entradas adc  (0-output / 1-input)
	MOVLW      32
	MOVWF      TRISA+0
;eae.c,37 :: 		TRISB = 0b00000011;
	MOVLW      3
	MOVWF      TRISB+0
;eae.c,38 :: 		TRISE = 0b00000001;
	MOVLW      1
	MOVWF      TRISE+0
;eae.c,40 :: 		ADC_Init();
	CALL       _ADC_Init+0
;eae.c,41 :: 		Lcd_Init();
	CALL       _Lcd_Init+0
;eae.c,42 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);                                    //cursor desligado
	MOVLW      12
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;eae.c,44 :: 		Lcd_Out(1,1,"V=");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr1_eae+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;eae.c,45 :: 		Lcd_Out(2,1,"R=");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr2_eae+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;eae.c,46 :: 		Lcd_Out(2,9,"T=");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      9
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr3_eae+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;eae.c,48 :: 		while(1){
L_main0:
;eae.c,81 :: 		valor = ADC_Read(PINO_RES);
	MOVLW      10
	MOVWF      FARG_ADC_Read_channel+0
	CALL       _ADC_Read+0
	MOVF       R0+0, 0
	MOVWF      _valor+0
	MOVF       R0+1, 0
	MOVWF      _valor+1
;eae.c,82 :: 		retornar = (valor*conv*5.4)/RES_RESISTENCIA;
	CALL       _word2double+0
	MOVLW      33
	MOVWF      R4+0
	MOVLW      35
	MOVWF      R4+1
	MOVLW      32
	MOVWF      R4+2
	MOVLW      119
	MOVWF      R4+3
	CALL       _Mul_32x32_FP+0
	MOVLW      205
	MOVWF      R4+0
	MOVLW      204
	MOVWF      R4+1
	MOVLW      44
	MOVWF      R4+2
	MOVLW      129
	MOVWF      R4+3
	CALL       _Mul_32x32_FP+0
	MOVLW      0
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVLW      32
	MOVWF      R4+2
	MOVLW      130
	MOVWF      R4+3
	CALL       _Div_32x32_FP+0
	MOVF       R0+0, 0
	MOVWF      _retornar+0
	MOVF       R0+1, 0
	MOVWF      _retornar+1
	MOVF       R0+2, 0
	MOVWF      _retornar+2
	MOVF       R0+3, 0
	MOVWF      _retornar+3
;eae.c,83 :: 		retornar = (5/retornar) - RES_RESISTENCIA;
	MOVF       R0+0, 0
	MOVWF      R4+0
	MOVF       R0+1, 0
	MOVWF      R4+1
	MOVF       R0+2, 0
	MOVWF      R4+2
	MOVF       R0+3, 0
	MOVWF      R4+3
	MOVLW      0
	MOVWF      R0+0
	MOVLW      0
	MOVWF      R0+1
	MOVLW      32
	MOVWF      R0+2
	MOVLW      129
	MOVWF      R0+3
	CALL       _Div_32x32_FP+0
	MOVLW      0
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVLW      32
	MOVWF      R4+2
	MOVLW      130
	MOVWF      R4+3
	CALL       _Sub_32x32_FP+0
	MOVF       R0+0, 0
	MOVWF      _retornar+0
	MOVF       R0+1, 0
	MOVWF      _retornar+1
	MOVF       R0+2, 0
	MOVWF      _retornar+2
	MOVF       R0+3, 0
	MOVWF      _retornar+3
;eae.c,84 :: 		FloatToStr(retornar,texto);
	MOVF       R0+0, 0
	MOVWF      FARG_FloatToStr_fnum+0
	MOVF       R0+1, 0
	MOVWF      FARG_FloatToStr_fnum+1
	MOVF       R0+2, 0
	MOVWF      FARG_FloatToStr_fnum+2
	MOVF       R0+3, 0
	MOVWF      FARG_FloatToStr_fnum+3
	MOVLW      main_texto_L0+0
	MOVWF      FARG_FloatToStr_str+0
	CALL       _FloatToStr+0
;eae.c,85 :: 		for(i=0;i<3;i++){
	CLRF       main_i_L0+0
	CLRF       main_i_L0+1
L_main2:
	MOVLW      128
	XORWF      main_i_L0+1, 0
	MOVWF      R0+0
	MOVLW      128
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main11
	MOVLW      3
	SUBWF      main_i_L0+0, 0
L__main11:
	BTFSC      STATUS+0, 0
	GOTO       L_main3
;eae.c,86 :: 		escrever[i] = texto[i];
	MOVF       main_i_L0+0, 0
	ADDLW      main_escrever_L0+0
	MOVWF      R1+0
	MOVF       main_i_L0+0, 0
	ADDLW      main_texto_L0+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      R0+0
	MOVF       R1+0, 0
	MOVWF      FSR
	MOVF       R0+0, 0
	MOVWF      INDF+0
;eae.c,85 :: 		for(i=0;i<3;i++){
	INCF       main_i_L0+0, 1
	BTFSC      STATUS+0, 2
	INCF       main_i_L0+1, 1
;eae.c,87 :: 		}
	GOTO       L_main2
L_main3:
;eae.c,88 :: 		if(escrever[2]=='.') {
	MOVF       main_escrever_L0+2, 0
	XORLW      46
	BTFSS      STATUS+0, 2
	GOTO       L_main5
;eae.c,89 :: 		escrever[2]= ' ';
	MOVLW      32
	MOVWF      main_escrever_L0+2
;eae.c,90 :: 		}
L_main5:
;eae.c,91 :: 		Lcd_Out(2,3,escrever);
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      3
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      main_escrever_L0+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;eae.c,92 :: 		Lcd_Out(2,6," ô ");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      6
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr4_eae+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;eae.c,95 :: 		valor = ADC_Read(PINO_TEMP);
	MOVLW      5
	MOVWF      FARG_ADC_Read_channel+0
	CALL       _ADC_Read+0
	MOVF       R0+0, 0
	MOVWF      _valor+0
	MOVF       R0+1, 0
	MOVWF      _valor+1
;eae.c,96 :: 		retornar = conv*valor*100;
	CALL       _word2double+0
	MOVLW      33
	MOVWF      R4+0
	MOVLW      35
	MOVWF      R4+1
	MOVLW      32
	MOVWF      R4+2
	MOVLW      119
	MOVWF      R4+3
	CALL       _Mul_32x32_FP+0
	MOVLW      0
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVLW      72
	MOVWF      R4+2
	MOVLW      133
	MOVWF      R4+3
	CALL       _Mul_32x32_FP+0
	MOVF       R0+0, 0
	MOVWF      _retornar+0
	MOVF       R0+1, 0
	MOVWF      _retornar+1
	MOVF       R0+2, 0
	MOVWF      _retornar+2
	MOVF       R0+3, 0
	MOVWF      _retornar+3
;eae.c,97 :: 		FloatToStr(retornar,texto);
	MOVF       R0+0, 0
	MOVWF      FARG_FloatToStr_fnum+0
	MOVF       R0+1, 0
	MOVWF      FARG_FloatToStr_fnum+1
	MOVF       R0+2, 0
	MOVWF      FARG_FloatToStr_fnum+2
	MOVF       R0+3, 0
	MOVWF      FARG_FloatToStr_fnum+3
	MOVLW      main_texto_L0+0
	MOVWF      FARG_FloatToStr_str+0
	CALL       _FloatToStr+0
;eae.c,98 :: 		for(i=0;i<2;i++){
	CLRF       main_i_L0+0
	CLRF       main_i_L0+1
L_main6:
	MOVLW      128
	XORWF      main_i_L0+1, 0
	MOVWF      R0+0
	MOVLW      128
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main12
	MOVLW      2
	SUBWF      main_i_L0+0, 0
L__main12:
	BTFSC      STATUS+0, 0
	GOTO       L_main7
;eae.c,99 :: 		escrever[i] = texto[i];
	MOVF       main_i_L0+0, 0
	ADDLW      main_escrever_L0+0
	MOVWF      R1+0
	MOVF       main_i_L0+0, 0
	ADDLW      main_texto_L0+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      R0+0
	MOVF       R1+0, 0
	MOVWF      FSR
	MOVF       R0+0, 0
	MOVWF      INDF+0
;eae.c,98 :: 		for(i=0;i<2;i++){
	INCF       main_i_L0+0, 1
	BTFSC      STATUS+0, 2
	INCF       main_i_L0+1, 1
;eae.c,100 :: 		}
	GOTO       L_main6
L_main7:
;eae.c,101 :: 		Lcd_Out(2,11,escrever);
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      11
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      main_escrever_L0+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;eae.c,102 :: 		Lcd_Out(2,13," C");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      13
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr5_eae+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;eae.c,104 :: 		Delay_ms(500);
	MOVLW      3
	MOVWF      R11+0
	MOVLW      138
	MOVWF      R12+0
	MOVLW      85
	MOVWF      R13+0
L_main9:
	DECFSZ     R13+0, 1
	GOTO       L_main9
	DECFSZ     R12+0, 1
	GOTO       L_main9
	DECFSZ     R11+0, 1
	GOTO       L_main9
	NOP
	NOP
;eae.c,105 :: 		}
	GOTO       L_main0
;eae.c,107 :: 		}
L_end_main:
	GOTO       $+0
; end of _main
