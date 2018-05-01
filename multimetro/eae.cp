#line 1 "C:/Users/Pedro Lima/Desktop/Nova pasta/eae.c"








sbit LCD_RS at RD0_bit;
sbit LCD_EN at RD1_bit;
sbit LCD_D7 at RD5_bit;
sbit LCD_D6 at RD4_bit;
sbit LCD_D5 at RD3_bit;
sbit LCD_D4 at RD2_bit;

sbit LCD_RS_Direction at TRISD0_bit;
sbit LCD_EN_Direction at TRISD1_bit;
sbit LCD_D7_Direction at TRISD5_bit;
sbit LCD_D6_Direction at TRISD4_bit;
sbit LCD_D5_Direction at TRISD3_bit;
sbit LCD_D4_Direction at TRISD2_bit;


 unsigned int valor=0;
 float retornar;

void main() {

 int i;
 char texto[40];
 char escrever[4];

 ANSEL = 0b00110000;
 ANSELH = 0b00010100;

 TRISA = 0b00100000;
 TRISB = 0b00000011;
 TRISE = 0b00000001;

 ADC_Init();
 Lcd_Init();
 Lcd_Cmd(_LCD_CURSOR_OFF);

 Lcd_Out(1,1,"V=");
 Lcd_Out(2,1,"R=");
 Lcd_Out(2,9,"T=");

 while(1){
#line 81 "C:/Users/Pedro Lima/Desktop/Nova pasta/eae.c"
 valor = ADC_Read( 10 );
 retornar = (valor* 0.004887 *5.4)/ 10 ;
 retornar = (5/retornar) -  10 ;
 FloatToStr(retornar,texto);
 for(i=0;i<3;i++){
 escrever[i] = texto[i];
 }
 if(escrever[2]=='.') {
 escrever[2]= ' ';
 }
 Lcd_Out(2,3,escrever);
 Lcd_Out(2,6," ô ");


 valor = ADC_Read( 5 );
 retornar =  0.004887 *valor*100;
 FloatToStr(retornar,texto);
 for(i=0;i<2;i++){
 escrever[i] = texto[i];
 }
 Lcd_Out(2,11,escrever);
 Lcd_Out(2,13," C");

 Delay_ms(500);
 }

}
