;*************************************************************************************************************************************************************
;AUTORES:PEDRO VITOR SOARES GOMES DE LIMA																DATA:16/05/2016
;		 ANA CAROLINNA DE SOUSA TAVARES
;		 RENE LUIS PEREIRA FRAGOSO DE SOUSA
;
;PIC16F887
;
;RELÓGIO DIGITAL E CRONÔMETRO
;*************************************************************************************************************************************************************	

	PROCESSOR       16F887A
	RADIX           DEC

#INCLUDE <p16F887.inc>

;*************************************************************************************************************************************************************
; 															  VETOR DE RESET
;*************************************************************************************************************************************************************
	org 0X00				;ENDEREÇO INICIAL DE PROCESSAMENTO
	goto inicio

;*************************************************************************************************************************************************************
; 															  
;*************************************************************************************************************************************************************
	org	0X04				;ENDEREÇO INICIAL DAS INTERRUPÇÕES	
	goto break				
	
;*************************************************************************************************************************************************************
; 															     VARIÁVEIS
;*************************************************************************************************************************************************************
	org	20H
temp	res 2				;RESERVA QUANTIDADE DE BYTES PARA A VARIAVEL		
dig1	res	1				;PARTE BAIXA DOS SEGUNDOS		
dig2	res 1				;PARTE ALTA DOS SEGUNDOS
dig3	res 1				;PARTE BAIXA DOS MINUTOS
dig4	res 1				;PARTE ALTA DOS MINUTOS
dig5	res 1				;PARTE BAIXA DAS HORAS
dig6	res 1				;PARTE ALTA DAS HORAS
c1		res 1				;PARTE BAIXA DOS CENTESIMOS
c2		res 1				;PARTE ALTA DOS CENTESIMOS
c3		res	1				;PARTE BAIXA DOS SEGUNDOS
c4		res 1				;PARTE ALTA DOS SEGUNDOS
temp_w	res 1				
temp_s	res	1
aux1	res	1		

;*************************************************************************************************************************************************************
; 															     ENTRADAS
;*************************************************************************************************************************************************************		
#define	botaomudar		PORTA,0		;BOTÃO PARA SELECIONAR ENTRE RELOGIO/CRONOMETRO
#define	botaoiniciacro	PORTA,1		;BOTÃO PARA INICIAR/PARAR CONTAGEM DO CRONOMETRO

;*************************************************************************************************************************************************************
; 															  INICIO DO PROGRAMA
;*************************************************************************************************************************************************************
inicio
	banksel	TRISA
	movlw	00001111b	
	movwf	TRISA			;DEFINE ENTRADAS E SAÍDAS (0 - SAÍDA E 1 - ENTRADA)
	movlw	00000000b
	movwf	TRISB			
	movwf	TRISD			
	bsf		PIE1,TMR1IE		;CONFIGURAÇÃO DAS INTERRUPÇÕES
	banksel	PORTA

	clrf	PORTA 			;ZERA TODAS AS SAÍDAS DO PORTA
	clrf	PORTB			;ZERA TODAS AS SAÍDAS DO PORTB
	clrf	PORTD			;ZERA TODAS AS SAÍDAS DO PORTD
	clrf	dig1			;ZERA VARIAVEIS
	clrf	dig2			
	clrf	dig3			
	clrf	dig4			
	clrf	dig5			
	clrf	dig6			
	clrf	c1			
	clrf	c2
	clrf	c3
	clrf	c4
	clrf	aux1
			
	movlw	000001b			;CLOCK INTERNO(FOSC/4) E PRESCALER 1:1
	movwf	T1CON			;CONFIGURAÇÃO 'TIMER1 CONTROL REGISTER'
	bsf		INTCON,GIE		;HABILITA INTERRUPÇÃO GLOBAL
	bsf		INTCON,PEIE		;HABILITA INTERRUPÇAO DE PERIFÉRICOS

	movlw	55296/256		;INTERRUPÇÃO A CADA 10ms	
	movwf	TMR1H			 
	movlw	55296%256
	movwf	TMR1L			

	bsf		PORTB,0			;SETA BIT0 DO REGISTRADOR PORTB

	banksel	ANSEL			;I/O ANALÓGICAS COMO DIGITAIS
	clrf	ANSEL
	clrf	ANSELH
	banksel	PORTA	
	
	goto	loop

;*************************************************************************************************************************************************************
; 																ROTINA PRINCIPAL
;*************************************************************************************************************************************************************
loop

	movlw	HIGH dec_lcd
	movwf	PCLATH

    btfsc   botaomudar			;SE botaomudar PRESSIONADO, VAI PARA cronometro
    goto    cronometro

	;MULTIPLEXAÇÃO DOS DISPLAYS NO RELOGIO
	btfsc	PORTB,0	
	movf	dig3,w

	btfsc	PORTB,1
	movf	dig4,w
   
	btfsc	PORTB,2
	movf	dig5,w

	btfsc	PORTB,3
	movf	dig6,w

    goto    pula

;*************************************************************************************************************************************************************
; 														ATIVAR MODO CRONOMETRO				  	
;*************************************************************************************************************************************************************
cronometro
	
	;MULTIPLEXAÇÃO DOS DISPLAYS NO CRONOMETRO
	btfsc	PORTB,0
	movf	c1,w

	btfsc	PORTB,1
	movf	c2,w
   
	btfsc	PORTB,2
	movf	c3,w

	btfsc	PORTB,3
	movf	c4,w

    goto    pula

;*************************************************************************************************************************************************************
; 															FIM DA ROTINA PRINCIPAL		  	
;*************************************************************************************************************************************************************
pula

	call	dec_lcd				;CHAMA dec_lcd
	clrf	PCLATH
	movwf	PORTD				;VALOR DE W, DO dec_lcd, PARA PORTD

	call	delay

	btfss	PORTB,3				;GARANTE QUE NENHUM LIXO VA PARA O BIT0 DE PORTB 
	goto	$+4
	movlw	1
	movwf	PORTB
	goto	loop
	clrc
	
	rlf		PORTB,f	
	goto 	loop

;*************************************************************************************************************************************************************
; 																INTERRUPÇÃO
;*************************************************************************************************************************************************************
break
	;SALVAR CONTEXTO
	movwf	temp_w			
	swapf	STATUS,w		
	movwf	temp_s	
		
	;ZERA FLAG DA INTERRUPÇÃO
	bcf		PIR1,TMR1IF			

	;CONFIGURA CLOCK
	movlw	55296/256		;INTERRUPÇÃO A CADA 10ms
	movwf	TMR1H			;VALOR DE TMR1H PARA 55296/256
	movlw	55296%256
	movwf	TMR1L			;VALOR DE TMR1H PARA 55296%256

 	incf	aux1,f
	movf	aux1,w
	xorlw	100   			;SE 1s(100*0,01) ENTRA NA INTERRUPÇÃO DO RELOGIO
	btfss	STATUS,Z		
    goto    cronometro_int 
    clrf    aux1  

;*************************************************************************************************************************************************************
; 															INTERRUPÇÃO/RELÓGIO			  
;*************************************************************************************************************************************************************
relogio

	incf	dig1,f				;INCREMENTA dig1
	movf	dig1,w			
	xorlw	10				
	btfss	STATUS,Z		
	goto	$+3
	clrf	dig1			
	incf	dig2,f				;INCREMENTA dig2

	movf	dig2,w			
	xorlw	6				
	btfss	STATUS,Z		
	goto    $+3
	clrf	dig2			
	incf	dig3,f				;INCREMENTA dig3
	
	movf	dig3,w			
	xorlw	10				
	btfss   STATUS,Z		
	goto	$+3
	clrf	dig3			
	incf	dig4,f				;INCREMENTA dig4
	
	movf	dig4,w			
	xorlw	6				
	btfss	STATUS,Z		
	goto	$+3
	clrf	dig4			
	incf	dig5,f				;INCREMENTA dig5
	
	movf	dig5,w			 
	xorlw	10				
	btfss	STATUS,Z		
	goto	$+3
	clrf	dig5			
	incf	dig6,f				;INCREMENTA dig6
	
	movf	dig5,w
	xorlw	4
	btfss	STATUS,Z    
    goto    $+7
    movf	dig6,w
	xorlw	2
	btfss	STATUS,Z			;TESTA SE CHEGOU EM 24 HORAS
	goto    cronometro_int
    clrf	dig5
	clrf	dig6				 

;*************************************************************************************************************************************************************
; 															INTERRUPÇÃO/CRONOMETRO			  	
;*************************************************************************************************************************************************************
cronometro_int

	btfsc   botaomudar			;TESTA botaomudar
    btfss   botaoiniciacro		;TESTA botaoiniciacro
    goto    sair
    
    incf	c1,f				;INCREMENTA c1
	movf	c1,w
	xorlw	10
	btfss	STATUS,Z
	goto	$+3
	clrf	c1
	incf	c2,f				;INCREMENTA c2

	movf	c2,w
	xorlw	10
	btfss	STATUS,Z
	goto	$+3
	clrf	c2
	incf	c3,f				;INCREMENTA c3

	movf	c3,w
	xorlw	10
	btfss	STATUS,Z
	goto	$+3
	clrf	c3
	incf	c4,f				;INCREMENTA c4

	movf	c4,w
	xorlw	6
	btfsc	STATUS,Z
	clrf	c4

;*************************************************************************************************************************************************************
; 																FIM DA INTERRUPÇÃO	  		
;*************************************************************************************************************************************************************
sair
	
	;RESTAURAR CONTEXTO
	swapf	temp_s,w		
	movwf	STATUS			
	swapf	temp_w,f		
	swapf	temp_w,w		

	retfie	
	
;*************************************************************************************************************************************************************
; 																SUBROTINA DELAY	
;*************************************************************************************************************************************************************
delay
	movlw	100%256				;DELAY DE APROXIMADAMENTE 1ms
	movwf	temp+1			
	movlw	100/256+1		
	movwf	temp			
	nop						
	nop
	nop
	nop
	nop
	decf	temp+1,f		
	btfsc	STATUS,Z		
	decfsz	temp,f			
	goto	$ - 8			
	return			

;*************************************************************************************************************************************************************
; 																  SUBROTINA DEC_LCD	
;*************************************************************************************************************************************************************
	org 	200h
dec_lcd
	addwf	PCL,f			
	retlw	11000000b		; 0			
	retlw	11111001b		; 1
	retlw	10100100b		; 2
	retlw	10110000b		; 3
	retlw	10011001b		; 4
	retlw	10010010b		; 5
	retlw	10000011b		; 6
	retlw	11111000b		; 7
	retlw	10000000b		; 8
	retlw	10011000b		; 9
	retlw	11000000b		; 0
							;RETORNA PARA W O VALOR CORRESPONDENTE

	end