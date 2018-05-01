#define RES_CORRENTE 0.1
#define RES_RESISTENCIA 10
#define PINO_TEN 4                                              //Channel 4 - RA5
#define PINO_COR 12                                              //Channel 12 - RB0
#define PINO_RES 10                                              //Channel 10 - RB1
#define PINO_TEMP 5                                             //Channel 5 - RE0
#define conv 0.004887

sbit LCD_RS at RD0_bit;                                         // Lcd pinout settings
sbit LCD_EN at RD1_bit;
sbit LCD_D7 at RD5_bit;
sbit LCD_D6 at RD4_bit;
sbit LCD_D5 at RD3_bit;
sbit LCD_D4 at RD2_bit;

sbit LCD_RS_Direction at TRISD0_bit;                            // Pin direction
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
    
    ANSEL = 0b00110000;                                                //1 pino como analógico
    ANSELH = 0b00010100;                                               //0 pino como digital
    
    TRISA = 0b00100000;                                                //entradas adc  (0-output / 1-input)
    TRISB = 0b00000011;
    TRISE = 0b00000001;

    ADC_Init();
    Lcd_Init();
    Lcd_Cmd(_LCD_CURSOR_OFF);                                    //cursor desligado

    Lcd_Out(1,1,"V=");
    Lcd_Out(2,1,"R=");
    Lcd_Out(2,9,"T=");
    
    while(1){

    //Tensão
    valor = ADC_Read(PINO_TEN);
    retornar = valor*conv;
    FloatToStr(retornar,texto);
    for(i=0;i<4;i++){
    escrever[i] = texto[i];
    }
    if (retornar<1) {
    escrever[3] = escrever[2];
    escrever[2] = escrever[0];
    escrever[0] = '0';
    }
    Lcd_Out(1,3,escrever);
    Lcd_Out(1,7,"V");
    
   //Corrente
    Lcd_Out(1,9,"I=");
    valor = ADC_Read(PINO_COR);
    retornar = ((valor*conv)+0.055)*1000;
    FloatToStr(retornar,texto);
    for(i=0;i<4;i++){
    escrever[i] = texto[i];
    }
    if(escrever[3]=='.') {
    escrever[3]= ' ';
    }
    Lcd_Out(1,11,escrever);
    Lcd_Out(1,15,"mA");
    

    //Resistência
    valor = ADC_Read(PINO_RES);
    retornar = (valor*conv*5.4)/RES_RESISTENCIA;
    retornar = (5/retornar) - RES_RESISTENCIA;
    FloatToStr(retornar,texto);
    for(i=0;i<3;i++){
    escrever[i] = texto[i];
    }
    if(escrever[2]=='.') {
    escrever[2]= ' ';
    }
    Lcd_Out(2,3,escrever);
    Lcd_Out(2,6," ô ");

    //Temperatura
    valor = ADC_Read(PINO_TEMP);
    retornar = conv*valor*100;
    FloatToStr(retornar,texto);
    for(i=0;i<2;i++){
    escrever[i] = texto[i];
    }
    Lcd_Out(2,11,escrever);
    Lcd_Out(2,13," C");

    Delay_ms(500);
    }

}