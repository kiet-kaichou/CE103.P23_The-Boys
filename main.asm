/* XUAT KI TU RA NGOAI LCD */
/* CHUONG TRINH SU DUNG TIN HIEU TU SENSOR KY-038 DE HIEN THI TRANG THAI LED LEN LCD */
org 0000h
SENSOR BIT P1.2
RS BIT P3.0
RW BIT P3.1
E BIT P3.2
DBUS EQU P2
START: 
	SETB P1.2
	JB SENSOR, ON
OFF:
	mov R0,#0
    	acall init_lcd
	mov a, #01h
	acall lcd_command
	acall delay_2ms
	mov a, #80h
	acall lcd_command
    	mov dptr,#led_off
	sjmp loop
	
ON:
	mov R0,#0
    	acall init_lcd
	mov a, #01h
	acall lcd_command
	acall delay_2ms
	mov a, #80h
	acall lcd_command
    	mov dptr,#led_on
loop: 	
	clr a
    	movc a,@a+dptr
	cjne A,#0,NHAY
	acall DELAY_1S
	sjmp START
NHAY:   
	acall lcd_write	
	inc R0
	inc dptr
	cjne R0,#16,loop
	mov A,#0C0H
	acall lcd_command
	SJMP loop
THOAT: SJMP $
lcd_write:
	setb rs
	clr rw
	mov dbus,a
	setb e
	clr e
	acall wait_lcd
	ret

lcd_command:
	clr rw
	clr rs
	mov dbus,a
	setb e
	clr e
	acall wait_lcd
	ret
wait_lcd:
	mov r7,#100
	djnz r7,$
	ret
init_lcd: 
	clr rs
	mov a,#38h
	setb e
	clr e
	acall lcd_command
	clr rs
	mov a,#0eh
	setb e
	clr e
	acall lcd_command
	clr rs
	mov a,#06h
	setb e
	clr e
	acall lcd_command
	ret
	
DELAY_1S:
    MOV R3, #5
D1: MOV R2, #200
D2: MOV R1, #250
D3: DJNZ R1, D3
    DJNZ R2, D2
    DJNZ R3, D1
    RET
	
delay_2ms:
    mov R2, #250
D2MS1:
    mov R1, #8
D2MS2:
    djnz R1, D2MS2
    djnz R2, D2MS1
    ret

//table: db 'Hello master',00H
led_on: db 'Status: ON',00H
led_off: db 'Status: OFF',00H
end
