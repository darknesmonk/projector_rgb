
;CodeVisionAVR C Compiler V2.05.0 Professional
;(C) Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATmega8
;Program type             : Application
;Clock frequency          : 4,000000 MHz
;Memory model             : Small
;Optimize for             : Speed
;(s)printf features       : int, width
;(s)scanf features        : int, width
;External RAM size        : 0
;Data Stack size          : 512 byte(s)
;Heap size                : 0 byte(s)
;Promote 'char' to 'int'  : Yes
;'char' is unsigned       : Yes
;8 bit enums              : Yes
;global 'const' stored in FLASH: Yes
;Enhanced core instructions    : On
;Smart register allocation     : On
;Automatic register allocation : On

	#pragma AVRPART ADMIN PART_NAME ATmega8
	#pragma AVRPART MEMORY PROG_FLASH 8192
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1119
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x045F
	.EQU __DSTACK_SIZE=0x0200
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	RCALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMRDW
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X
	.ENDM

	.MACRO __GETD1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X+
	LD   R22,X
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	RCALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _temper=R4

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	RJMP __RESET
	RJMP _ext_int0_isr
	RJMP 0x00
	RJMP _timer1_compb_isr
	RJMP 0x00
	RJMP 0x00
	RJMP _timer1_compa_isr
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00

_num:
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x74
	.DB  0x0,0x0,0x0,0x60,0x0,0x60,0x0,0x0
	.DB  0x7C,0x28,0x7C,0x0,0x0,0x34,0xD6,0x58
	.DB  0x0,0x8,0x60,0x6C,0xC,0x20,0x0,0x78
	.DB  0x54,0x18,0x20,0x0,0x0,0x60,0x0,0x0
	.DB  0x0,0x0,0x38,0x44,0x0,0x0,0x44,0x38
	.DB  0x0,0x0,0x0,0x50,0x20,0x50,0x0,0x0
	.DB  0x10,0x38,0x10,0x0,0x0,0xC,0xC,0x2
	.DB  0x0,0x0,0x10,0x10,0x10,0x0,0x0,0xC
	.DB  0xC,0x0,0x0,0x4,0x8,0x10,0x20,0x40
	.DB  0x0,0x7C,0x44,0x7C,0x0,0x0,0x20,0x7C
	.DB  0x0,0x0,0x0,0x5C,0x54,0x74,0x0,0x0
	.DB  0x54,0x54,0x7C,0x0,0x0,0x70,0x10,0x7C
	.DB  0x0,0x0,0x74,0x54,0x5C,0x0,0x0,0x7C
	.DB  0x14,0x1C,0x0,0x0,0x40,0x40,0x7C,0x0
	.DB  0x0,0x7C,0x54,0x7C,0x0,0x0,0x74,0x54
	.DB  0x7C,0x0,0x0,0x6C,0x6C,0x0,0x0,0x0
	.DB  0x2,0x6C,0x6C,0x0,0x0,0x10,0x28,0x44
	.DB  0x0,0x0,0x28,0x28,0x28,0x0,0x0,0x44
	.DB  0x28,0x10,0x0,0x0,0x20,0x4A,0x30,0x0
	.DB  0x0,0x7C,0x54,0x74,0x0,0x0,0x3C,0x48
	.DB  0x3C,0x0,0x0,0x7C,0x54,0x38,0x0,0x0
	.DB  0x38,0x44,0x44,0x0,0x0,0x7C,0x44,0x38
	.DB  0x0,0x0,0x7C,0x54,0x54,0x0,0x0,0x7C
	.DB  0x50,0x50,0x0,0x0,0x7C,0x54,0x5C,0x0
	.DB  0x0,0x7C,0x10,0x7C,0x0,0x0,0x44,0x7C
	.DB  0x44,0x0,0x0,0x4C,0x44,0x7C,0x40,0x0
	.DB  0x7C,0x10,0x6C,0x0,0x0,0x7C,0x4,0x4
	.DB  0x0,0x7C,0x20,0x10,0x20,0x7C,0x0,0x3C
	.DB  0x40,0x40,0x3C,0x0,0x38,0x44,0x38,0x0
	.DB  0x0,0x7C,0x50,0x70,0x0,0x0,0x7C,0x44
	.DB  0x78,0x2,0x0,0x7C,0x50,0x38,0x4,0x0
	.DB  0x34,0x54,0x58,0x0,0x40,0x40,0x7C,0x40
	.DB  0x40,0x78,0x4,0x4,0x78,0x0,0x0,0x78
	.DB  0x4,0x78,0x0,0x78,0x4,0x78,0x4,0x78
	.DB  0x44,0x28,0x10,0x28,0x44,0x0,0x70,0xC
	.DB  0x70,0x0,0x0,0x4C,0x54,0x64,0x0,0x0
	.DB  0x7C,0x44,0x44,0x0,0x0,0x20,0x10,0x8
	.DB  0x4,0x0,0x44,0x44,0x7C,0x0,0x0,0x20
	.DB  0x40,0x20,0x0,0x4,0x4,0x4,0x4,0x4
	.DB  0x0,0x0,0x0,0x40,0x0,0x0,0x3C,0x48
	.DB  0x3C,0x0,0x0,0x7C,0x54,0x48,0x0,0x0
	.DB  0x7C,0x54,0x38,0x0,0x0,0x7C,0x40,0x60
	.DB  0x0,0xC,0x70,0x50,0x70,0xC,0x0,0x7C
	.DB  0x54,0x54,0x0,0x44,0x28,0x7C,0x28,0x44
	.DB  0x0,0x54,0x54,0x7C,0x0,0x0,0x7C,0x8
	.DB  0x10,0x7C,0x0,0x7C,0x8,0x90,0x7C,0x0
	.DB  0x7C,0x10,0x6C,0x0,0x0,0x3C,0x40,0x7C
	.DB  0x0,0x7C,0x20,0x10,0x20,0x7C,0x0,0x7C
	.DB  0x10,0x7C,0x0,0x0,0x38,0x44,0x38,0x0
	.DB  0x0,0x7C,0x40,0x7C,0x0,0x0,0x7C,0x50
	.DB  0x70,0x0,0x0,0x38,0x44,0x44,0x0,0x40
	.DB  0x40,0x7C,0x40,0x40,0x0,0x74,0x14,0x7C
	.DB  0x0,0x70,0x50,0x7C,0x50,0x70,0x0,0x6C
	.DB  0x10,0x6C,0x0,0x0,0x7C,0x4,0x7C,0x2
	.DB  0x0,0x70,0x10,0x7C,0x0,0x7C,0x4,0x7C
	.DB  0x4,0x7C,0x7C,0x4,0x7C,0x4,0x7E,0x40
	.DB  0x7C,0x14,0x8,0x0,0x7C,0x14,0x8,0x7C
	.DB  0x0,0x0,0x7C,0x14,0x8,0x0,0x0,0x54
	.DB  0x54,0x38,0x0,0x7C,0x10,0x7C,0x44,0x7C
	.DB  0x4,0x28,0x50,0x7C,0x0
_m:
	.DB  0x0,0xFF,0xFF,0xDB,0xDB,0xDB,0xDF,0xDF
	.DB  0x0,0x0,0x0,0x0,0xFF,0xFF,0xC0,0x60
	.DB  0x30,0x18,0x30,0x60,0xC0,0xFF,0xFF,0x0
	.DB  0x0,0x0,0xC0,0xC0,0xC0,0xC0,0xFF,0xFF
	.DB  0xC0,0xC0,0xC0,0xC0,0x0,0x0,0x0,0x0
	.DB  0x0,0xFF,0xFF,0xDB,0xDB,0xDB,0xDF,0xDF
	.DB  0x0,0x0,0x0,0x0,0xFF,0xFF,0xC0,0x60
	.DB  0x30,0x18,0x30,0x60,0xC0,0xFF,0xFF,0x0
	.DB  0x0,0x0,0xC0,0xC0,0xC0,0xC0,0xFF,0xFF
	.DB  0xC0,0xC0,0xC0,0xC0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x18
	.DB  0x24,0x42,0x81,0x81,0x81,0xBD,0x95,0x89
	.DB  0x81,0xBD,0xA1,0x91,0xA1,0xBD,0x81,0xA1
	.DB  0xBD,0xA1,0x81,0x81,0x81,0x81,0x42,0x24
	.DB  0x18,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x18
	.DB  0x24,0x42,0x81,0x81,0x81,0xBD,0x95,0x89
	.DB  0x81,0xBD,0xA1,0x91,0xA1,0xBD,0x81,0xA1
	.DB  0xBD,0xA1,0x81,0x81,0x81,0x81,0x42,0x24
	.DB  0x18,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x8,0x14,0x14
	.DB  0x14,0x22,0x22,0x22,0x22,0x22,0x22,0x22
	.DB  0x22,0x22,0x22,0x22,0x63,0x41,0x41,0x41
	.DB  0x41,0x41,0x41,0x41,0x41,0x41,0x41,0x41
	.DB  0xC1,0x81,0x81,0x81,0x81,0x81,0x81,0x81
	.DB  0x81,0x81,0x81,0x81,0x81,0x81,0xC1,0x41
	.DB  0x41,0x41,0x41,0x41,0x41,0x41,0x41,0x41
	.DB  0x41,0x41,0x63,0x22,0x22,0x22,0x22,0x22
	.DB  0x22,0x22,0x22,0x22,0x22,0x22,0x14,0x14
	.DB  0x14,0x8,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x38,0x44,0x82
	.DB  0x41,0x21,0x41,0x82,0x44,0x38,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x38,0x44,0x82,0x47,0x27,0x47,0x82
	.DB  0x44,0x38,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x38,0x44,0x86
	.DB  0x4F,0x2F,0x4F,0x9E,0x5C,0x38,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x38,0x7C,0xFE,0x7F,0x3F,0x7F,0xFE
	.DB  0x7C,0x38,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0xC1,0x83,0xC1,0x83,0xC1,0x83,0xC1,0x83
	.DB  0xC1,0x83,0xC1,0x83,0xC1,0x83,0xC1,0x83
	.DB  0xC1,0x83,0xC1,0x83,0xC1,0x83,0xC1,0x83
	.DB  0xC1,0x83,0xC1,0x83,0xC1,0x83,0xC1,0x83
	.DB  0xC1,0x83,0xC1,0x83,0xC1,0x83,0xC1,0x83
	.DB  0xC1,0x83,0xC1,0x83,0xC1,0x83,0xC1,0x83
	.DB  0xC1,0x83,0xC1,0x83,0xC1,0x83,0xC1,0x83
	.DB  0xC1,0x83,0xC1,0x83,0xC1,0x83,0xC1,0x83
	.DB  0xC1,0x83,0xC1,0x83,0xC1,0x83,0xC1,0x83
	.DB  0xC1,0x83,0xC1,0x83,0xC1,0x83,0xC1,0x83
	.DB  0x81,0x83,0x81,0x83,0x81,0x83,0x81,0x83
	.DB  0x81,0x83,0x81,0x83,0x81,0x83,0x81,0x83
	.DB  0x81,0x83,0x81,0x83,0x81,0x83,0x81,0x83
	.DB  0x81,0x83,0x81,0x83,0x81,0x83,0x81,0x83
	.DB  0x81,0x83,0x81,0x83,0x81,0x83,0x81,0x83
	.DB  0x81,0x83,0x81,0x83,0x81,0x83,0x81,0x83
	.DB  0x81,0x83,0x81,0x83,0x81,0x83,0x81,0x83
	.DB  0x81,0x83,0x81,0x83,0x81,0x83,0x81,0x83
	.DB  0x81,0x83,0x81,0x83,0x81,0x83,0x81,0x83
	.DB  0x81,0x83,0x81,0x83,0x81,0x83,0x81,0x83
	.DB  0x81,0x82,0x81,0x82,0x81,0x82,0x81,0x82
	.DB  0x81,0x82,0x81,0x82,0x81,0x82,0x81,0x82
	.DB  0x81,0x82,0x81,0x82,0x81,0x82,0x81,0x82
	.DB  0x81,0x82,0x81,0x82,0x81,0x82,0x81,0x82
	.DB  0x81,0x82,0x81,0x82,0x81,0x82,0x81,0x82
	.DB  0x81,0x82,0x81,0x82,0x81,0x82,0x81,0x82
	.DB  0x81,0x82,0x81,0x82,0x81,0x82,0x81,0x82
	.DB  0x81,0x82,0x81,0x82,0x81,0x82,0x81,0x82
	.DB  0x81,0x82,0x81,0x82,0x81,0x82,0x81,0x82
	.DB  0x81,0x82,0x81,0x82,0x81,0x82,0x81,0x82
	.DB  0xC1,0x83,0x83,0x83,0xC1,0x83,0x83,0x83
	.DB  0xC1,0x83,0x83,0x83,0xC1,0x83,0x83,0x83
	.DB  0xC1,0x83,0x83,0x83,0xC1,0x83,0x83,0x83
	.DB  0xC1,0x83,0x83,0x83,0xC1,0x83,0x83,0x83
	.DB  0xC1,0x83,0x83,0x83,0xC1,0x83,0x83,0x83
	.DB  0xC1,0x83,0x83,0x83,0xC1,0x83,0x83,0x83
	.DB  0xC1,0x83,0x83,0x83,0xC1,0x83,0x83,0x83
	.DB  0xC1,0x83,0x83,0x83,0xC1,0x83,0x83,0x83
	.DB  0xC1,0x83,0x83,0x83,0xC1,0x83,0x83,0x83
	.DB  0xC1,0x83,0x83,0x83,0xC1,0x83,0x83,0x83
_conv_delay_G102:
	.DB  0x64,0x0,0xC8,0x0,0x90,0x1,0x20,0x3
_bit_mask_G102:
	.DB  0xF8,0xFF,0xFC,0xFF,0xFE,0xFF,0xFF,0xFF

;REGISTER BIT VARIABLES INITIALIZATION
__REG_BIT_VARS:
	.DW  0x0000

_0x3:
	.DB  0x2C,0x1
_0x4:
	.DB  LOW(_0x0*2),HIGH(_0x0*2),LOW(_0x0*2+7),HIGH(_0x0*2+7),LOW(_0x0*2+15),HIGH(_0x0*2+15),LOW(_0x0*2+21),HIGH(_0x0*2+21)
	.DB  LOW(_0x0*2+28),HIGH(_0x0*2+28),LOW(_0x0*2+32),HIGH(_0x0*2+32),LOW(_0x0*2+37),HIGH(_0x0*2+37),LOW(_0x0*2+42),HIGH(_0x0*2+42)
	.DB  LOW(_0x0*2+50),HIGH(_0x0*2+50),LOW(_0x0*2+59),HIGH(_0x0*2+59),LOW(_0x0*2+67),HIGH(_0x0*2+67),LOW(_0x0*2+74),HIGH(_0x0*2+74)
_0x5:
	.DB  LOW(_0x0*2+82),HIGH(_0x0*2+82),LOW(_0x0*2+94),HIGH(_0x0*2+94),LOW(_0x0*2+102),HIGH(_0x0*2+102),LOW(_0x0*2+108),HIGH(_0x0*2+108)
	.DB  LOW(_0x0*2+116),HIGH(_0x0*2+116),LOW(_0x0*2+124),HIGH(_0x0*2+124),LOW(_0x0*2+132),HIGH(_0x0*2+132)
_0x95:
	.DB  0x0,0x0
_0x0:
	.DB  0xDF,0xED,0xE2,0xE0,0xF0,0xFF,0x0,0xD4
	.DB  0xE5,0xE2,0xF0,0xE0,0xEB,0xFF,0x0,0xCC
	.DB  0xE0,0xF0,0xF2,0xE0,0x0,0xC0,0xEF,0xF0
	.DB  0xE5,0xEB,0xFF,0x0,0xCC,0xE0,0xFF,0x0
	.DB  0xC8,0xFE,0xED,0xFF,0x0,0xC8,0xFE,0xEB
	.DB  0xFF,0x0,0xC0,0xE2,0xE3,0xF3,0xF1,0xF2
	.DB  0xE0,0x0,0xD1,0xE5,0xED,0xF2,0xFF,0xE1
	.DB  0xF0,0xFF,0x0,0xCE,0xEA,0xF2,0xFF,0xE1
	.DB  0xF0,0xFF,0x0,0xCD,0xEE,0xFF,0xE1,0xF0
	.DB  0xFF,0x0,0xC4,0xE5,0xEA,0xE0,0xE1,0xF0
	.DB  0xFF,0x0,0xCF,0xEE,0xED,0xE5,0xE4,0xE5
	.DB  0xEB,0xFC,0xED,0xE8,0xEA,0x0,0xC2,0xF2
	.DB  0xEE,0xF0,0xED,0xE8,0xEA,0x0,0xD1,0xF0
	.DB  0xE5,0xE4,0xE0,0x0,0xD7,0xE5,0xF2,0xE2
	.DB  0xE5,0xF0,0xE3,0x0,0xCF,0xFF,0xF2,0xED
	.DB  0xE8,0xF6,0xE0,0x0,0xD1,0xF3,0xE1,0xE1
	.DB  0xEE,0xF2,0xE0,0x0,0xC2,0xEE,0xF1,0xEA
	.DB  0xF0,0xE5,0xF1,0xE5,0xED,0xFC,0xE5,0x0
	.DB  0xC7,0xE0,0xEF,0xF3,0xF1,0xEA,0x2E,0x2E
	.DB  0x2E,0x0,0xC2,0x20,0xEA,0xEE,0xEC,0xED
	.DB  0xE0,0xF2,0xE5,0x3A,0x0,0x63,0x0,0xC2
	.DB  0xF0,0xE5,0xEC,0xFF,0x3A,0x20,0x20,0x0
	.DB  0x30,0x0,0x20,0x32,0x30,0x0,0x41,0x56
	.DB  0x52,0x20,0x41,0x54,0x4D,0x45,0x47,0x41
	.DB  0x20,0x38,0x0,0xC3,0xC0,0xCE,0xD3,0x20
	.DB  0xD1,0xCF,0xCE,0x20,0xC1,0xCC,0xD2,0x0
	.DB  0xCA,0xD0,0xC5,0xC0,0xD2,0xC8,0xC2,0x0
	.DB  0xC3,0x2E,0x20,0xC1,0xD3,0xC3,0xD3,0xCB
	.DB  0xDC,0xCC,0xC0,0x0,0xC4,0xCB,0xDF,0x20
	.DB  0xCA,0xC0,0xC7,0xC0,0xCD,0xC8,0x0,0x3D
	.DB  0x29,0x20,0x3A,0x29,0x20,0x5E,0x5F,0x5E
	.DB  0x20,0x3B,0x2D,0x29,0x0,0x42,0x4F,0x4F
	.DB  0x4D,0x21,0x21,0x21,0x20,0x3A,0x2D,0x44
	.DB  0x0
_0x2020060:
	.DB  0x1
_0x2020000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  0x02
	.DW  __REG_BIT_VARS*2

	.DW  0x02
	.DW  _counter
	.DW  _0x3*2

	.DW  0x18
	.DW  _month
	.DW  _0x4*2

	.DW  0x0E
	.DW  _week
	.DW  _0x5*2

	.DW  0x0A
	.DW  _0x7E
	.DW  _0x0*2+144

	.DW  0x01
	.DW  _0x7E+10
	.DW  _0x0*2+6

	.DW  0x0B
	.DW  _0x7E+11
	.DW  _0x0*2+154

	.DW  0x02
	.DW  _0x7E+22
	.DW  _0x0*2+165

	.DW  0x09
	.DW  _0x7E+24
	.DW  _0x0*2+167

	.DW  0x02
	.DW  _0x7E+33
	.DW  _0x0*2+163

	.DW  0x02
	.DW  _0x7E+35
	.DW  _0x0*2+176

	.DW  0x02
	.DW  _0x7E+37
	.DW  _0x0*2+174

	.DW  0x04
	.DW  _0x7E+39
	.DW  _0x0*2+178

	.DW  0x0D
	.DW  _0x7E+43
	.DW  _0x0*2+182

	.DW  0x0D
	.DW  _0x7E+56
	.DW  _0x0*2+195

	.DW  0x08
	.DW  _0x7E+69
	.DW  _0x0*2+208

	.DW  0x0C
	.DW  _0x7E+77
	.DW  _0x0*2+216

	.DW  0x0B
	.DW  _0x7E+89
	.DW  _0x0*2+228

	.DW  0x0E
	.DW  _0x7E+100
	.DW  _0x0*2+239

	.DW  0x0C
	.DW  _0x7E+114
	.DW  _0x0*2+253

	.DW  0x02
	.DW  0x04
	.DW  _0x95*2

	.DW  0x01
	.DW  __seed_G101
	.DW  _0x2020060*2

_0xFFFFFFFF:
	.DW  0

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;DISABLE WATCHDOG
	LDI  R31,0x18
	OUT  WDTCR,R31
	OUT  WDTCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	RJMP _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x260

	.CSEG
;#define R(D) { PORTD=D ; PORTC.3=PORTD.2;}
;#define B PORTB
;#define rc PORTC.5
;#define bc PORTC.4
;#define ALL 80
;#define PD2 PIND.2
;#define POWER 12
;#define DISPLAY 15
;#define MINUS 21
;#define PLUS 22
;#define DOWN 17
;#define UP 16
;#define MENU 18
;#define HELP 47
;#define SLEEP 38
;#define MUTE 13
;#define VIDEO 56
;#define TV 63
;#define STD 14
;#include <mega8.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include <delay.h>
;#include <string.h>
;#include <stdlib.h>
;#include <i2c.h>
;#include <1wire.h>
;#include <ds18b20.h>
;    #asm
        .equ __i2c_port=0x15
        .equ __sda_bit=1
        .equ __scl_bit=0
; 0000 001F     #endasm
;#include <ds1307.h>
;#include "fonts.c"
;/*flash unsigned char num[][5]=
;{
;0x00, 0x00, 0x00, 0x00, 0x00,// (space)  32
;0x00, 0x00, 0x5F, 0x00, 0x00,// !        33
;0x00, 0x07, 0x00, 0x07, 0x00,// "        34
;0x14, 0x7F, 0x14, 0x7F, 0x14,// #        35
;0x24, 0x2A, 0x7F, 0x2A, 0x12,// $        36
;0x23, 0x13, 0x08, 0x64, 0x62,// %        37
;0x36, 0x49, 0x55, 0x22, 0x50,// &        38
;0x00, 0x05, 0x03, 0x00, 0x00,// '        39
;0x00, 0x1C, 0x22, 0x41, 0x00,// (        40
;0x00, 0x41, 0x22, 0x1C, 0x00,// )        41
;0x08, 0x2A, 0x1C, 0x2A, 0x08,// *        42
;0x08, 0x08, 0x3E, 0x08, 0x08,// +        43
;0x00, 0x50, 0x30, 0x00, 0x00,// ,        44
;0x08, 0x08, 0x08, 0x08, 0x08,// -        45
;0x00, 0x30, 0x30, 0x00, 0x00,// .        46
;0x20, 0x10, 0x08, 0x04, 0x02,// /        47
;0x3E, 0x51, 0x49, 0x45, 0x3E,// 0        48
;0x00, 0x42, 0x7F, 0x40, 0x00,// 1        49
;0x42, 0x61, 0x51, 0x49, 0x46,// 2        50
;0x21, 0x41, 0x45, 0x4B, 0x31,// 3        51
;0x18, 0x14, 0x12, 0x7F, 0x10,// 4        52
;0x27, 0x45, 0x45, 0x45, 0x39,// 5        53
;0x3C, 0x4A, 0x49, 0x49, 0x30,// 6        54
;0x01, 0x71, 0x09, 0x05, 0x03,// 7        55
;0x36, 0x49, 0x49, 0x49, 0x36,// 8        56
;0x06, 0x49, 0x49, 0x29, 0x1E,// 9        57
;0x00, 0x36, 0x36, 0x00, 0x00,// :        58
;0x00, 0x56, 0x36, 0x00, 0x00,// ;        59
;0x00, 0x08, 0x14, 0x22, 0x41,// <        60
;0x14, 0x14, 0x14, 0x14, 0x14,// =        61
;0x41, 0x22, 0x14, 0x08, 0x00,// >        62
;0x02, 0x01, 0x51, 0x09, 0x06,// ?        63
;0x32, 0x49, 0x79, 0x41, 0x3E,// @        64
;0x7E, 0x11, 0x11, 0x11, 0x7E,// A        65
;0x7F, 0x49, 0x49, 0x49, 0x36,// B        66
;0x3E, 0x41, 0x41, 0x41, 0x22,// C        67
;0x7F, 0x41, 0x41, 0x22, 0x1C,// D        68
;0x7F, 0x49, 0x49, 0x49, 0x41,// E        69
;0x7F, 0x09, 0x09, 0x01, 0x01,// F        70
;0x3E, 0x41, 0x41, 0x51, 0x32,// G        71
;0x7F, 0x08, 0x08, 0x08, 0x7F,// H        72
;0x00, 0x41, 0x7F, 0x41, 0x00,// I        73
;0x20, 0x40, 0x41, 0x3F, 0x01,// J        74
;0x7F, 0x08, 0x14, 0x22, 0x41,// K        75
;0x7F, 0x40, 0x40, 0x40, 0x40,// L        76
;0x7F, 0x02, 0x04, 0x02, 0x7F,// M        77
;0x7F, 0x04, 0x08, 0x10, 0x7F,// N        78
;0x3E, 0x41, 0x41, 0x41, 0x3E,// O        79
;0x7F, 0x09, 0x09, 0x09, 0x06,// P        80
;0x3E, 0x41, 0x51, 0x21, 0x5E,// Q        81
;0x7F, 0x09, 0x19, 0x29, 0x46,// R        82
;0x46, 0x49, 0x49, 0x49, 0x31,// S        83
;0x01, 0x01, 0x7F, 0x01, 0x01,// T        84
;0x3F, 0x40, 0x40, 0x40, 0x3F,// U        85
;0x1F, 0x20, 0x40, 0x20, 0x1F,// V        86
;0x7F, 0x20, 0x18, 0x20, 0x7F,// W        87
;0x63, 0x14, 0x08, 0x14, 0x63,// X        88
;0x03, 0x04, 0x78, 0x04, 0x03,// Y        89
;0x61, 0x51, 0x49, 0x45, 0x43,// Z        90
;0x00, 0x00, 0x7F, 0x41, 0x41,// [        91
;0x02, 0x04, 0x08, 0x10, 0x20,// "\"      92
;0x41, 0x41, 0x7F, 0x00, 0x00,// ]        93
;0x04, 0x02, 0x01, 0x02, 0x04,// ^        94
;0x40, 0x40, 0x40, 0x40, 0x40,// _        95
;0x00, 0x01, 0x02, 0x04, 0x00,// `        96
;0x20, 0x54, 0x54, 0x54, 0x78,// a        97
;0x7F, 0x48, 0x44, 0x44, 0x38,// b        98
;0x38, 0x44, 0x44, 0x44, 0x20,// c        99
;0x38, 0x44, 0x44, 0x48, 0x7F,// d        100
;0x38, 0x54, 0x54, 0x54, 0x18,// e        101
;0x08, 0x7E, 0x09, 0x01, 0x02,// f        102
;0x08, 0x14, 0x54, 0x54, 0x3C,// g        103
;0x7F, 0x08, 0x04, 0x04, 0x78,// h        104
;0x00, 0x44, 0x7D, 0x40, 0x00,// i        105
;0x20, 0x40, 0x44, 0x3D, 0x00,// j        106
;0x00, 0x7F, 0x10, 0x28, 0x44,// k        107
;0x00, 0x41, 0x7F, 0x40, 0x00,// l        108
;0x7C, 0x04, 0x18, 0x04, 0x78,// m        109
;0x7C, 0x08, 0x04, 0x04, 0x78,// n        110
;0x38, 0x44, 0x44, 0x44, 0x38,// o        111
;0x7C, 0x14, 0x14, 0x14, 0x08,// p        112
;0x08, 0x14, 0x14, 0x18, 0x7C,// q        113
;0x7C, 0x08, 0x04, 0x04, 0x08,// r        114
;0x48, 0x54, 0x54, 0x54, 0x20,// s        115
;0x04, 0x3F, 0x44, 0x40, 0x20,// t        116
;0x3C, 0x40, 0x40, 0x20, 0x7C,// u        117
;0x1C, 0x20, 0x40, 0x20, 0x1C,// v        118
;0x3C, 0x40, 0x30, 0x40, 0x3C,// w        119
;0x44, 0x28, 0x10, 0x28, 0x44,// x        120
;0x0C, 0x50, 0x50, 0x50, 0x3C,// y        121
;0x44, 0x64, 0x54, 0x4C, 0x44,// z        122
;0x00, 0x08, 0x36, 0x41, 0x00,// {        123
;0x00, 0x00, 0x7F, 0x00, 0x00,// |        124
;0x00, 0x41, 0x36, 0x08, 0x00,// }        125
;0x00, 0x00, 0x00, 0x00, 0x00,// (space)  126
;0x00, 0x00, 0x00, 0x00, 0x00,// (space)  127
;0x7E, 0x11, 0x11, 0x11, 0x7E,// A        192
;0x7F, 0x45, 0x45, 0x45, 0x39,// Б        193
;0x7F, 0x49, 0x49, 0x49, 0x36,// B        194
;0x7F, 0x01, 0x01, 0x01, 0x03,// Г        195
;0xC0, 0x7E, 0x41, 0x7F, 0xC0,// Д        196
;0x7F, 0x49, 0x49, 0x49, 0x41,// E        197
;119,8,127,8,119,             // Ж        198
;34,73,73,73,54,              // З        199
;127,32,16,8,127,             // И        200
;127,32,19,8,127,             // Й        201
;0x7F, 0x08, 0x14, 0x22, 0x41,// K        202
;64,62,1,1,127,               // Л        203
;0x7F, 0x02, 0x04, 0x02, 0x7F,// M        204
;0x7F, 0x08, 0x08, 0x08, 0x7F,// H        205
;0x3E, 0x41, 0x41, 0x41, 0x3E,// O        206
;127,1,1,1,127,               // П        207
;0x7F, 0x09, 0x09, 0x09, 0x06,// P        208
;0x3E, 0x41, 0x41, 0x41, 0x22,// C        209
;0x01, 0x01, 0x7F, 0x01, 0x01,// T        210
;39,72,72,72,63,              // У        211
;30,33,127,33,30,             // Ф        212
;0x63, 0x14, 0x08, 0x14, 0x63,// X        213
;127,64,64,127,192,           // Ц        214
;15,16,16,16,127,             // Ч        215
;127,64,124,64,127,           // Ш        216
;127,64,124,64,255,           // Щ        217
;1,127,72,72,48,              // Ъ        218
;127,72,48,0,127,             // Ы        219
;127,72,72,72,48,             // Ь        220
;34,73,73,73,62,              // Э        221
;127,8,62,65,62,              // Ю        222
;118,9,9,9,127,               // Я        223
;0x20, 0x54, 0x54, 0x54, 0x78,// a        224
;124, 84, 84, 84, 36,         // б        225
;124, 84, 84, 84, 40,         // в        226
;124, 4, 4, 4, 12,            // г        227
;192, 120, 68, 124, 192,      // д        228
;0x38, 0x54, 0x54, 0x54, 0x18,// e        229
;108, 16, 124, 16, 108,       // ж        230
;40, 68, 84, 84, 40,          // з        231
;124, 32, 16, 8, 124,         // и        232
;124, 33, 18, 8, 124,         // й        233
;124, 16, 16, 40, 68,         // к        234
;64, 56, 4, 4, 124,           // л        235
;124, 8, 16, 8, 124,          // м        236
;124, 16, 16, 16, 124,        // н        237
;0x38, 0x44, 0x44, 0x44, 0x38,// o        238
;124, 4, 4, 4, 124,           // п        239
;0x7C, 0x14, 0x14, 0x14, 0x08,// p        240
;0x38, 0x44, 0x44, 0x44, 0x20,// c        241
;4, 4, 124, 4, 4,             // т        242
;0x0C, 0x50, 0x50, 0x50, 0x3C,// y        243
;24, 36, 124, 36, 24,         // ф        244
;0x44, 0x28, 0x10, 0x28, 0x44,// x        245
;124, 64, 64, 124, 192,       // ц        246
;12, 16, 16, 16, 124,         // ч        247
;124, 64, 120, 64, 124,       // ш        248
;124, 64, 120, 64, 252,       // щ        249
;124, 84, 80, 80, 32,         // ъ        250
;124,80,32,0,124,             // ы        251
;124, 80, 80, 80, 32,         // ь        252
;40, 68, 84, 84, 56,          // э        253
;124, 16, 56, 68, 56,         // ю        254
;72, 52, 20, 20, 124          // я        255
;};
;*/
;flash unsigned char num[][5]=
;{
;{0,0,0,0,0}, //  пробел 32
;{0,0,116,0,0}, // !
;{0,96,0,96,0}, //  "
;{0,124,40,124,0}, // #
;{0,52,214,88,0}, // $
;{8,96,108,12,32}, // %
;{0,120,84,24,32}, // &
;{0,0,96,0,0}, // '
;{0,0,56,68,0}, // (
;{0,68,56,0,0}, //  )
;{0,80,32,80,0}, // *
;{0,16,56,16,0}, //  +
;{0,12,12,2,0}, //  ,
;{0,16,16,16,0}, //  -
;{0,12,12,0,0}, //  .
;{4,8,16,32,64}, //  /  47
;{0,124,68,124,0},    // 0 48
;{0,32,124,0,0},      // 1
;{0,92,84,116,0},    // 2
;{0,84,84,124,0},   //  3
;{0,112,16,124,0},    //  4
;{0,116,84,92,0},  //   5
;{0,124,20,28,0},  //   6
;{0,64,64,124,0}, //    7
;{0,124,84,124,0}, //    8
;{0,116,84,124,0}, //     9
;{0,108,108,0,0}, // :  58
;{0,2,108,108,0}, // ;
;{0,16,40,68,0}, // <
;{0,40,40,40,0}, //  =
;{0,68,40,16,0}, //  >
;{0,32,74,48,0}, //  ?
;{0,124,84,116,0}, //  @  64
;{0,60,72,60,0},// A        65
;{0,124,84,56,0},// B        66
;{0,56,68,68,0},// C        67
;{0,124,68,56,0},// D        68
;{0,124,84,84,0},// E        69
;{0,124,80,80,0},// F        70
;{0,124,84,92,0},// G        71
;{0,124,16,124,0},// H        72
;{0,68,124,68,0},// I        73
;{0,76,68,124,64},// J        74
;{0,124,16,108,0},// K        75
;{0,124,4,4,0},// L        76
;{124,32,16,32,124},// M        77
;{0,60,64,64,60},// N        78
;{0,56,68,56,0},// O        79
;{0,124,80,112,0},// P        80
;{0,124,68,120,2},// Q        81
;{0,124,80,56,4},// R        82
;{0,52,84,88,0},// S        83
;{64,64,124,64,64},// T        84
;{120,4,4,120,0},// U        85
;{0,120,4,120,0},// V        86
;{120,4,120,4,120},// W        87
;{68,40,16,40,68},// X        88
;{0,112,12,112,0},// Y        89
;{0,76,84,100,0},// Z        90
;{0,124,68,68,0},// [        91
;{0,32,16,8,4},// "\"      92
;{0,68,68,124,0},// ]        93
;{0,32,64,32,0},// ^        94
;{4,4,4,4,4},// _        95
;{0,0,0,64,0},// `        96
;{0,60,72,60,0}, //  А 192
;{0,124,84,72,0}, //  Б
;{0,124,84,56,0}, // В
;{0,124,64,96,0}, // Г
;{12,112,80,112,12}, //Д
;{0,124,84,84,0}, // Е
;{68,40,124,40,68}, //Ж
;{0,84,84,124,0}, // З
;{0,124,8,16,124}, // И
;{0,124,8,144,124}, //  Й
;{0,124,16,108,0}, // К
;{0,60,64,124,0}, // Л
;{124,32,16,32,124}, // М
;{0,124,16,124,0}, // Н
;{0,56,68,56,0}, // О
;{0,124,64,124,0}, // П
;{0,124,80,112,0}, // Р
;{0,56,68,68,0}, // С
;{64,64,124,64,64}, // Т
;{0,116,20,124,0}, // У
;{112,80,124,80,112}, // Ф
;{0,108,16,108,0}, // Х
;{0,124,4,124,2}, // Ц
;{0,112,16,124,0}, // Ч
;{124,4,124,4,124}, // Ш
;{124,4,124,4,126}, // Щ
;{64,124,20,8,0}, // Ъ
;{124,20,8,124,0}, // Ы
;{0,124,20,8,0}, // Ь
;{0,84,84,56,0}, //  Э
;{124,16,124,68,124}, // Ю
;{4,40,80,124,0} // Я 223
;
;};
;#include "fon.c"
;flash unsigned char m[][ALL]=
;{
;{0,255,255,219,219,219,223,223,0,0,0,0,255,255,192,96,48,24,48,96,192,255,255,0,0,0,192,192,192,192,255,255,192,192,192,192,0,0,0,0,
;0,255,255,219,219,219,223,223,0,0,0,0,255,255,192,96,48,24,48,96,192,255,255,0,0,0,192,192,192,192,255,255,192,192,192,192,0,0,0,0},  // БМТ  0
;
;{0,0,0,0,0,0,0,24,36,66,129,129,129,189,149,137,129,189,161,145,161,189,129,161,189,161,129,129,129,129,66,36,24,0,0,0,0,0,0,0,
;0,0,0,0,0,0,0,24,36,66,129,129,129,189,149,137,129,189,161,145,161,189,129,161,189,161,129,129,129,129,66,36,24,0,0,0,0,0,0,0}, // БМТ  1
;{0,0,0,0,0,8,20,20,20,34,34,34,34,34,34,34,34,34,34,34,99,65,65,65,65,65
;,65,65,65,65,65,65,193,129,129,129,129,129,129,129,129,129,129,129,
;129,129,193,65,65,65,65,65,65,65,65,65,65,65,99,34,34,34,34,34,34,34,34,34,34,34,20,20,20,8,0,0,0,0,0,0}, // ПУСТОЙ
;{0,0,0,0,0,56,68,130,65,33,65,130,68,56,0,0,0,0,0,0,
;0,0,0,0,0,56,68,130,71,39,71,130,68,56,0,0,0,0,0,0,
;0,0,0,0,0,56,68,134,79,47,79,158,92,56,0,0,0,0,0,0,
;0,0,0,0,0,56,124,254,127,63,127,254,124,56,0,0,0,0,0,0},  //Сердце 3
;{193,131,193,131,193,131,193,131,193,131,193,131,193,131,193,131,193,131,193,131,193,131,193,131,193,131,193,131,193,131,193,131,
;193,131,193,131,193,131,193,131,193,131,193,131,193,131,193,131,193,131,193,131,193,131,193,131,193,131,193,131,193,131,193,131,
;193,131,193,131,193,131,193,131,193,131,193,131,193,131,193,131}, // сплошной 2 квадрат  4
;{129,131,129,131,129,131,129,131,129,131,129,131,129,131,129,131,129,131,129,131,129,131,129,131,129,131,129,131,129,131,129,131,
;129,131,129,131,129,131,129,131,129,131,129,131,129,131,129,131,129,131,129,131,129,131,129,131,129,131,129,131,129,131,129,131,
;129,131,129,131,129,131,129,131,129,131,129,131,129,131,129,131}, // сплошной низ квадрат   5
; {
;129,130,129,130,129,130,129,130,129,130,129,130,129,130,129,130,129,130,129,130,129,130,129,130,129,130,129,130,129,
;130,129,130,129,130,129,130,129,130,129,130,129,130,129,130,129,130,129,130,129,130,129,130,129,130,129,130,129,130,
;129,130,129,130,129,130,129,130,129,130,129,130,129,130,129,130,129,130,129,130,129,130} ,  // вверх сплошной низ шахмат  6
;
;{193,131,131,131,193,131,131,131,193,131,131,131,193,131,131,131,193,131,131,131,193,131,131,131,193,131,131,131
;,193,131,131,131,193,131,131,131,193,131,131,131,193,131,131,131,193,131,131,131,193,131,131,131,193,131,131,131,
;193,131,131,131,193,131,131,131,193,131,131,131,193,131,131,131,193,131,131,131,193,131,131,131} // полушахмат  7
;};
;
;#include "func.c"
;eeprom  unsigned int OCRA,OCRB;
;volatile unsigned int RC5_DATA=0,counter=300;

	.DSEG
;signed int temper=0;
;volatile bit TOOGLE=0, RC_FLAG=0;
;volatile unsigned char step=0, step2=0;
;volatile unsigned char buf[ALL]={NULL},buf2[ALL]={NULL},buffer[ALL]={NULL},digbuf[12]={NULL},i;
;flash unsigned char *month[]={
;"Января","Февраля","Марта","Апреля","Мая","Июня","Июля","Августа","Сентября","Октября","Ноября","Декабря" };
;flash unsigned char *week[]=
;{"Понедельник","Вторник","Среда","Четверг","Пятница","Суббота","Воскресенье"};
;typedef struct{
;    unsigned char sec;
;    unsigned char min;
;    unsigned char hour;
;    unsigned char dow;
;    unsigned char date;
;    unsigned char month;
;    unsigned char year;
;}time; time t;
;void startup();
;void send_num(unsigned char p,unsigned char sym);
;void put_char(unsigned char *s, unsigned char d) ;
;void fillnil(unsigned char *b);
;void test();
;void background(unsigned char bg);
;void _delay_us(unsigned int us);
;void gettime();
; void gettime()
; 0000 0023  {

	.CSEG
_gettime:
;
;  rtc_get_time(&t.hour,&t.min,&t.sec);
	__POINTW1MN _t,2
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1MN _t,1
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(_t)
	LDI  R31,HIGH(_t)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _rtc_get_time
;  rtc_get_date(&t.dow,&t.date,&t.month,&t.year);
	__POINTW1MN _t,3
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1MN _t,4
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1MN _t,5
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1MN _t,6
	ST   -Y,R31
	ST   -Y,R30
	RCALL _rtc_get_date
;
;
; }
	RET
;
;void startup()
;{
_startup:
;// Declare your local variables here
;
;// Input/Output Ports initialization
;// Port B initialization
;// Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
;// State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0
;PORTB=0x00;
	LDI  R30,LOW(0)
	OUT  0x18,R30
;DDRB=0xFF;
	LDI  R30,LOW(255)
	OUT  0x17,R30
;
;// Port C initialization
;// Func6=In Func5=In Func4=In Func3=In Func2=In Func1=Out Func0=Out
;// State6=T State5=T State4=T State3=T State2=T State1=0 State0=0
;PORTC=0x00;
	LDI  R30,LOW(0)
	OUT  0x15,R30
;DDRC=0xFF;
	LDI  R30,LOW(255)
	OUT  0x14,R30
;
;// Port D initialization
;// Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
;// State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0
;PORTD=0x04;
	LDI  R30,LOW(4)
	OUT  0x12,R30
;DDRD=0xFB;
	LDI  R30,LOW(251)
	OUT  0x11,R30
;
;// Timer/Counter 0 initialization
;// Clock source: System Clock
;// Clock value: Timer 0 Stopped
;TCCR0=0x00;
	LDI  R30,LOW(0)
	OUT  0x33,R30
;TCNT0=0x00;
	OUT  0x32,R30
;
;// Timer/Counter 1 initialization
;// Clock source: System Clock
;// Clock value: Timer1 Stopped
;// Mode: Normal top=0xFFFF
;// OC1A output: Discon.
;// OC1B output: Discon.
;// Noise Canceler: Off
;// Input Capture on Falling Edge
;// Timer1 Overflow Interrupt: Off
;// Input Capture Interrupt: Off
;// Compare A Match Interrupt: Off
;// Compare B Match Interrupt: Off
;TCCR1A=0x00;
	OUT  0x2F,R30
;TCCR1B=0x0A;
	LDI  R30,LOW(10)
	OUT  0x2E,R30
;TCNT1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x2D,R30
;TCNT1L=0x00;
	OUT  0x2C,R30
;ICR1H=0x00;
	OUT  0x27,R30
;ICR1L=0x00;
	OUT  0x26,R30
;if  (OCRA<50 || OCRA >510) OCRA=250;
	LDI  R26,LOW(_OCRA)
	LDI  R27,HIGH(_OCRA)
	RCALL __EEPROMRDW
	SBIW R30,50
	BRLO _0x7
	LDI  R26,LOW(_OCRA)
	LDI  R27,HIGH(_OCRA)
	RCALL __EEPROMRDW
	CPI  R30,LOW(0x1FF)
	LDI  R26,HIGH(0x1FF)
	CPC  R31,R26
	BRLO _0x6
_0x7:
	LDI  R26,LOW(_OCRA)
	LDI  R27,HIGH(_OCRA)
	LDI  R30,LOW(250)
	LDI  R31,HIGH(250)
	RCALL __EEPROMWRW
;
;OCR1A=OCRA;
_0x6:
	LDI  R26,LOW(_OCRA)
	LDI  R27,HIGH(_OCRA)
	RCALL __EEPROMRDW
	OUT  0x2A+1,R31
	OUT  0x2A,R30
;OCR1B=OCRB;
	LDI  R26,LOW(_OCRB)
	LDI  R27,HIGH(_OCRB)
	RCALL __EEPROMRDW
	OUT  0x28+1,R31
	OUT  0x28,R30
;OCR1BH=0x00;
	LDI  R30,LOW(0)
	OUT  0x29,R30
;OCR1BL=0x00;
	OUT  0x28,R30
;
;// Timer/Counter 2 initialization
;// Clock source: System Clock
;// Clock value: 125,000 kHz
;// Mode: CTC top=OCR2
;// OC2 output: Disconnected
;ASSR=0x00;
	OUT  0x22,R30
;TCCR2=0x0B;
	LDI  R30,LOW(11)
	OUT  0x25,R30
;TCNT2=0x00;
	LDI  R30,LOW(0)
	OUT  0x24,R30
;if  (OCRB<10 || OCRB >254) OCRB=47;
	LDI  R26,LOW(_OCRB)
	LDI  R27,HIGH(_OCRB)
	RCALL __EEPROMRDW
	SBIW R30,10
	BRLO _0xA
	LDI  R26,LOW(_OCRB)
	LDI  R27,HIGH(_OCRB)
	RCALL __EEPROMRDW
	CPI  R30,LOW(0xFF)
	LDI  R26,HIGH(0xFF)
	CPC  R31,R26
	BRLO _0x9
_0xA:
	LDI  R26,LOW(_OCRB)
	LDI  R27,HIGH(_OCRB)
	LDI  R30,LOW(47)
	LDI  R31,HIGH(47)
	RCALL __EEPROMWRW
;OCR2=OCRB;
_0x9:
	LDI  R26,LOW(_OCRB)
	LDI  R27,HIGH(_OCRB)
	RCALL __EEPROMRDB
	OUT  0x23,R30
;// External Interrupt(s) initialization
;// INT0: Off
;// INT1: Off
;GICR|=0x40;
	IN   R30,0x3B
	ORI  R30,0x40
	OUT  0x3B,R30
;MCUCR=0x02;
	LDI  R30,LOW(2)
	OUT  0x35,R30
;GIFR=0x40;
	LDI  R30,LOW(64)
	OUT  0x3A,R30
;// Timer(s)/Counter(s) Interrupt(s) initialization
;TIMSK=0x90;
	LDI  R30,LOW(144)
	OUT  0x39,R30
;// USART initialization
;// USART disabled
;UCSRB=0x00;
	LDI  R30,LOW(0)
	OUT  0xA,R30
;
;// Analog Comparator initialization
;// Analog Comparator: Off
;// Analog Comparator Input Capture by Timer/Counter 1: Off
;ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
;SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
;
;// ADC initialization
;// ADC disabled
;ADCSRA=0x00;
	OUT  0x6,R30
;
;// SPI initialization
;// SPI disabled
;SPCR=0x00;
	OUT  0xD,R30
;
;// TWI initialization
;// TWI disabled
;TWCR=0x00;
	OUT  0x36,R30
;
;  i2c_init();
	RCALL _i2c_init
;rtc_init(0,1,0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL _rtc_init
; //rtc_set_time(18,50,0);
; //rtc_set_date(3,20,5,15);
;
;
;     w1_init();
	RCALL _w1_init
;
;
;ds18b20_init(0,-30,60,DS18B20_10BIT_RES);
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(226)
	ST   -Y,R30
	LDI  R30,LOW(60)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _ds18b20_init
;ds18b20_temperature(0);
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _ds18b20_temperature
;
;
;
;}
	RET
;  void _delay_us(unsigned int us)
;  {
__delay_us:
;  while(--us) delay_us(1);
;	us -> Y+0
_0xC:
	LD   R30,Y
	LDD  R31,Y+1
	SBIW R30,1
	ST   Y,R30
	STD  Y+1,R31
	BREQ _0xE
	__DELAY_USB 1
	RJMP _0xC
_0xE:
	RJMP _0x20E0004
;  /*
;unsigned char rev (unsigned char source)
;{
;return         ((source & 128)>> 7)
;            |  ((source & 64) >> 5)
;            |  ((source & 32) >> 3)
;            |  ((source & 16) >> 1)
;            |  ((source & 8)  << 1)
;            |  ((source & 4)  << 3)
;            |  ((source & 2)  << 5)
;            |  ((source & 1)  << 7);
;}
;   */
;void send_num(unsigned char p,unsigned char sym)
;{
_send_num:
;unsigned char i;
; if(sym>223) sym-=32;
	ST   -Y,R17
;	p -> Y+2
;	sym -> Y+1
;	i -> R17
	LDD  R26,Y+1
	CPI  R26,LOW(0xE0)
	BRLO _0xF
	LDD  R30,Y+1
	LDI  R31,0
	SBIW R30,32
	STD  Y+1,R30
;
;
;
; if (sym>96 && sym<127) sym-=32; else
_0xF:
	LDD  R26,Y+1
	CPI  R26,LOW(0x61)
	BRLO _0x11
	CPI  R26,LOW(0x7F)
	BRLO _0x12
_0x11:
	RJMP _0x10
_0x12:
	LDD  R30,Y+1
	LDI  R31,0
	SBIW R30,32
	RJMP _0x91
_0x10:
; if (sym>96) sym-=95;
	LDD  R26,Y+1
	CPI  R26,LOW(0x61)
	BRLO _0x14
	LDD  R30,Y+1
	LDI  R31,0
	SUBI R30,LOW(95)
	SBCI R31,HIGH(95)
_0x91:
	STD  Y+1,R30
;// if (sym>127) sym-=64;
;for(i=0; i<5; i++)
_0x14:
	LDI  R17,LOW(0)
_0x16:
	CPI  R17,5
	BRSH _0x17
;{
;//buf[ (p*5) +i ]=rev(num[sym-32][i]);
;buf[ (p*5) +i ]=num[sym-32][i];
	LDD  R26,Y+2
	LDI  R30,LOW(5)
	MUL  R30,R26
	MOVW R30,R0
	MOVW R26,R30
	MOV  R30,R17
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	SUBI R30,LOW(-_buf)
	SBCI R31,HIGH(-_buf)
	MOVW R22,R30
	LDD  R30,Y+1
	LDI  R31,0
	SBIW R30,32
	LDI  R26,LOW(5)
	LDI  R27,HIGH(5)
	RCALL __MULW12U
	SUBI R30,LOW(-_num*2)
	SBCI R31,HIGH(-_num*2)
	MOVW R26,R30
	MOV  R30,R17
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	LPM  R30,Z
	MOVW R26,R22
	ST   X,R30
;delay_ms(1);
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _delay_ms
;}
	SUBI R17,-1
	RJMP _0x16
_0x17:
;}
	LDD  R17,Y+0
	RJMP _0x20E0002
;
;void put_char(unsigned char *s, unsigned char d)
;{
_put_char:
;unsigned char i = 0;
;
;
;fillnil(buf);
	ST   -Y,R17
;	*s -> Y+2
;	d -> Y+1
;	i -> R17
	LDI  R17,0
	LDI  R30,LOW(_buf)
	LDI  R31,HIGH(_buf)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _fillnil
;
;  while(s[i]) {   send_num(i,s[i++]);   if(d) delay_ms(d); }
_0x18:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CLR  R30
	ADD  R26,R17
	ADC  R27,R30
	LD   R30,X
	CPI  R30,0
	BREQ _0x1A
	ST   -Y,R17
	MOV  R30,R17
	SUBI R17,-1
	LDD  R26,Y+3
	LDD  R27,Y+3+1
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	ST   -Y,R30
	RCALL _send_num
	LDD  R30,Y+1
	CPI  R30,0
	BREQ _0x1B
	LDI  R31,0
	ST   -Y,R31
	ST   -Y,R30
	RCALL _delay_ms
_0x1B:
	RJMP _0x18
_0x1A:
;
;}
	LDD  R17,Y+0
	ADIW R28,4
	RET
;void fillnil(unsigned char *b)
;{
_fillnil:
;/*
;unsigned char i;
;for(i=0; i<ALL; i++)
;{
;b[i]=0;
;} */
;
;memset(b,0,ALL);
;	*b -> Y+0
	LD   R30,Y
	LDD  R31,Y+1
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(80)
	LDI  R31,HIGH(80)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _memset
;
;}
	RJMP _0x20E0004
;
;void test()
;{
_test:
;unsigned char i,l=0;
;      rc=0;
	RCALL __SAVELOCR2
;	i -> R17
;	l -> R16
	LDI  R16,0
	CBI  0x15,5
;      for (i=8; i>0; i--) { R(1<<i); delay_ms(100); }
	LDI  R17,LOW(8)
_0x1F:
	CPI  R17,1
	BRLO _0x20
	MOV  R30,R17
	LDI  R26,LOW(1)
	RCALL __LSLB12
	OUT  0x12,R30
	SBIC 0x12,2
	RJMP _0x21
	CBI  0x15,3
	RJMP _0x22
_0x21:
	SBI  0x15,3
_0x22:
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _delay_ms
	SUBI R17,1
	RJMP _0x1F
_0x20:
;      R(0);
	LDI  R30,LOW(0)
	OUT  0x12,R30
	SBIC 0x12,2
	RJMP _0x23
	CBI  0x15,3
	RJMP _0x24
_0x23:
	SBI  0x15,3
_0x24:
;      delay_ms(50);
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _delay_ms
;      for (i=0; i<8; i++) {l= l | 1<<i; R(l); delay_ms(100); }
	LDI  R17,LOW(0)
_0x26:
	CPI  R17,8
	BRSH _0x27
	MOV  R30,R17
	LDI  R26,LOW(1)
	RCALL __LSLB12
	OR   R16,R30
	OUT  0x12,R16
	SBIC 0x12,2
	RJMP _0x28
	CBI  0x15,3
	RJMP _0x29
_0x28:
	SBI  0x15,3
_0x29:
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _delay_ms
	SUBI R17,-1
	RJMP _0x26
_0x27:
;      delay_ms(1000);
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _delay_ms
;
;       bc=0;
	CBI  0x15,4
;        for (i=8; i>0; i--) {B = (1<<i); delay_ms(100); }
	LDI  R17,LOW(8)
_0x2D:
	CPI  R17,1
	BRLO _0x2E
	MOV  R30,R17
	LDI  R26,LOW(1)
	RCALL __LSLB12
	OUT  0x18,R30
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _delay_ms
	SUBI R17,1
	RJMP _0x2D
_0x2E:
;      B=0;
	LDI  R30,LOW(0)
	OUT  0x18,R30
;      delay_ms(50);
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _delay_ms
;      for (i=0; i<8; i++) {B = B | (1<<i); delay_ms(100); }
	LDI  R17,LOW(0)
_0x30:
	CPI  R17,8
	BRSH _0x31
	IN   R1,24
	MOV  R30,R17
	LDI  R26,LOW(1)
	RCALL __LSLB12
	OR   R30,R1
	OUT  0x18,R30
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _delay_ms
	SUBI R17,-1
	RJMP _0x30
_0x31:
;      delay_ms(1000);
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _delay_ms
;}
	RCALL __LOADLOCR2P
	RET
;void delay_s(unsigned char s)
;{
_delay_s:
;while(s--) delay_ms(1000);
;	s -> Y+0
_0x32:
	LD   R30,Y
	SUBI R30,LOW(1)
	ST   Y,R30
	SUBI R30,-LOW(1)
	BREQ _0x34
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _delay_ms
	RJMP _0x32
_0x34:
	ADIW R28,1
	RET
;
;void background(unsigned char bg)
;{
_background:
;unsigned char i;
;for(i=0; i<ALL; i++) buf2[i]=m[bg][i];
	ST   -Y,R17
;	bg -> Y+1
;	i -> R17
	LDI  R17,LOW(0)
_0x36:
	CPI  R17,80
	BRSH _0x37
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_buf2)
	SBCI R31,HIGH(-_buf2)
	MOVW R22,R30
	LDD  R30,Y+1
	LDI  R26,LOW(80)
	MUL  R30,R26
	MOVW R30,R0
	SUBI R30,LOW(-_m*2)
	SBCI R31,HIGH(-_m*2)
	MOVW R26,R30
	MOV  R30,R17
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	LPM  R30,Z
	MOVW R26,R22
	ST   X,R30
	SUBI R17,-1
	RJMP _0x36
_0x37:
	LDD  R17,Y+0
_0x20E0004:
	ADIW R28,2
	RET
;
;void writeocr()
;{
_writeocr:
;if(OCR1A!=OCRA ) OCRA=OCR1A;
	__INWR 0,1,42
	LDI  R26,LOW(_OCRA)
	LDI  R27,HIGH(_OCRA)
	RCALL __EEPROMRDW
	CP   R30,R0
	CPC  R31,R1
	BREQ _0x38
	IN   R30,0x2A
	IN   R31,0x2A+1
	LDI  R26,LOW(_OCRA)
	LDI  R27,HIGH(_OCRA)
	RCALL __EEPROMWRW
;if(OCR2!=OCRB) OCRB=OCR2;
_0x38:
	IN   R0,35
	LDI  R26,LOW(_OCRB)
	LDI  R27,HIGH(_OCRB)
	RCALL __EEPROMRDW
	MOV  R26,R0
	LDI  R27,0
	CP   R30,R26
	CPC  R31,R27
	BREQ _0x39
	IN   R30,0x23
	LDI  R26,LOW(_OCRB)
	LDI  R27,HIGH(_OCRB)
	LDI  R31,0
	RCALL __EEPROMWRW
; }
_0x39:
	RET
;    interrupt [EXT_INT0] void ext_int0_isr(void)
; 0000 0025 {
_ext_int0_isr:
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0026 
; 0000 0027 if(PD2) return;
	SBIS 0x10,2
	RJMP _0x3A
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
; 0000 0028 delay_us(10);
_0x3A:
	__DELAY_USB 13
; 0000 0029 if(PD2) return;
	SBIS 0x10,2
	RJMP _0x3B
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
; 0000 002A GICR&=~0x40;
_0x3B:
	IN   R30,0x3B
	ANDI R30,0xBF
	OUT  0x3B,R30
; 0000 002B //if(!RC_FLAG) {GIFR |= (1 << INTF0); GICR|=0x40;  return;}
; 0000 002C     delay_us(120);
	__DELAY_USB 160
; 0000 002D  RC5_DATA=0;
	LDI  R30,LOW(0)
	STS  _RC5_DATA,R30
	STS  _RC5_DATA+1,R30
; 0000 002E  for(i = 0; i < 13; i++) {
	STS  _i,R30
_0x3D:
	LDS  R26,_i
	CPI  R26,LOW(0xD)
	BRSH _0x3E
; 0000 002F        RC5_DATA <<= 1;
	LDS  R30,_RC5_DATA
	LDS  R31,_RC5_DATA+1
	LSL  R30
	ROL  R31
	STS  _RC5_DATA,R30
	STS  _RC5_DATA+1,R31
; 0000 0030     _delay_us( 438);
	LDI  R30,LOW(438)
	LDI  R31,HIGH(438)
	ST   -Y,R31
	ST   -Y,R30
	RCALL __delay_us
; 0000 0031     if(PD2) { delay_us(10);    if(PD2) { delay_us(10);   if(PD2) {  RC5_DATA++;   }} }
	SBIS 0x10,2
	RJMP _0x3F
	__DELAY_USB 13
	SBIS 0x10,2
	RJMP _0x40
	__DELAY_USB 13
	SBIS 0x10,2
	RJMP _0x41
	LDI  R26,LOW(_RC5_DATA)
	LDI  R27,HIGH(_RC5_DATA)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
_0x41:
_0x40:
; 0000 0032 }
_0x3F:
	LDS  R30,_i
	SUBI R30,-LOW(1)
	STS  _i,R30
	RJMP _0x3D
_0x3E:
; 0000 0033 
; 0000 0034     counter++;
	LDI  R26,LOW(_counter)
	LDI  R27,HIGH(_counter)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
; 0000 0035 
; 0000 0036  if((RC5_DATA & 0b1111111111000000) !=0 )
	LDS  R30,_RC5_DATA
	LDS  R31,_RC5_DATA+1
	ANDI R30,LOW(0xFFC0)
	SBIW R30,0
	BREQ _0x42
; 0000 0037  { GIFR |= (1 << INTF0); GICR|=0x40;  return; }
	RJMP _0x94
; 0000 0038 
; 0000 0039  RC_FLAG=1;
_0x42:
	SET
	BLD  R2,1
; 0000 003A 
; 0000 003B  switch(RC5_DATA)
	LDS  R30,_RC5_DATA
	LDS  R31,_RC5_DATA+1
; 0000 003C  {
; 0000 003D  case 1:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BREQ _0x47
; 0000 003E  case 2:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x48
_0x47:
; 0000 003F   case 3:
	RJMP _0x49
_0x48:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x4A
_0x49:
; 0000 0040    case 4:
	RJMP _0x4B
_0x4A:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x4C
_0x4B:
; 0000 0041     case 5:
	RJMP _0x4D
_0x4C:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x4E
_0x4D:
; 0000 0042      case 6:
	RJMP _0x4F
_0x4E:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x50
_0x4F:
; 0000 0043       case 7:
	RJMP _0x51
_0x50:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x52
_0x51:
; 0000 0044       case 8: background(RC5_DATA-1); break;
	RJMP _0x53
_0x52:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0x54
_0x53:
	LDS  R30,_RC5_DATA
	LDS  R31,_RC5_DATA+1
	SBIW R30,1
	ST   -Y,R30
	RCALL _background
	RJMP _0x45
; 0000 0045       case MINUS: if(OCR1A>50) OCR1A--;  break;
_0x54:
	CPI  R30,LOW(0x15)
	LDI  R26,HIGH(0x15)
	CPC  R31,R26
	BRNE _0x55
	IN   R30,0x2A
	IN   R31,0x2A+1
	SBIW R30,51
	BRLO _0x56
	IN   R30,0x2A
	IN   R31,0x2A+1
	SBIW R30,1
	OUT  0x2A+1,R31
	OUT  0x2A,R30
	ADIW R30,1
_0x56:
	RJMP _0x45
; 0000 0046       case PLUS: if(OCR1A<510) OCR1A++;    break;
_0x55:
	CPI  R30,LOW(0x16)
	LDI  R26,HIGH(0x16)
	CPC  R31,R26
	BRNE _0x57
	IN   R30,0x2A
	IN   R31,0x2A+1
	CPI  R30,LOW(0x1FE)
	LDI  R26,HIGH(0x1FE)
	CPC  R31,R26
	BRSH _0x58
	IN   R30,0x2A
	IN   R31,0x2A+1
	ADIW R30,1
	OUT  0x2A+1,R31
	OUT  0x2A,R30
	SBIW R30,1
_0x58:
	RJMP _0x45
; 0000 0047       case UP: if(OCR2<250) OCR2++;    break;
_0x57:
	CPI  R30,LOW(0x10)
	LDI  R26,HIGH(0x10)
	CPC  R31,R26
	BRNE _0x59
	IN   R30,0x23
	CPI  R30,LOW(0xFA)
	BRSH _0x5A
	IN   R30,0x23
	SUBI R30,-LOW(1)
	OUT  0x23,R30
	SUBI R30,LOW(1)
_0x5A:
	RJMP _0x45
; 0000 0048       case DOWN:   if(OCR2>20) OCR2--;    break;
_0x59:
	CPI  R30,LOW(0x11)
	LDI  R26,HIGH(0x11)
	CPC  R31,R26
	BRNE _0x5B
	IN   R30,0x23
	CPI  R30,LOW(0x15)
	BRLO _0x5C
	IN   R30,0x23
	SUBI R30,LOW(1)
	OUT  0x23,R30
	SUBI R30,-LOW(1)
_0x5C:
	RJMP _0x45
; 0000 0049  case MENU:   break;
_0x5B:
	CPI  R30,LOW(0x12)
	LDI  R26,HIGH(0x12)
	CPC  R31,R26
	BREQ _0x45
; 0000 004A  case POWER: bc=rc^=1; break;
	CPI  R30,LOW(0xC)
	LDI  R26,HIGH(0xC)
	CPC  R31,R26
	BRNE _0x5E
	LDI  R26,0
	SBIC 0x15,5
	LDI  R26,1
	LDI  R30,LOW(1)
	EOR  R30,R26
	BRNE _0x5F
	CBI  0x15,5
	RJMP _0x60
_0x5F:
	SBI  0x15,5
_0x60:
	CPI  R30,0
	BRNE _0x61
	CBI  0x15,4
	RJMP _0x62
_0x61:
	SBI  0x15,4
_0x62:
	RJMP _0x45
; 0000 004B  case DISPLAY: TOOGLE ^=1; break;
_0x5E:
	CPI  R30,LOW(0xF)
	LDI  R26,HIGH(0xF)
	CPC  R31,R26
	BRNE _0x63
	LDI  R26,0
	SBRC R2,0
	LDI  R26,1
	LDI  R30,LOW(1)
	EOR  R30,R26
	RCALL __BSTB1
	BLD  R2,0
	RJMP _0x45
; 0000 004C  case VIDEO: bc^=1; break;
_0x63:
	CPI  R30,LOW(0x38)
	LDI  R26,HIGH(0x38)
	CPC  R31,R26
	BRNE _0x64
	LDI  R26,0
	SBIC 0x15,4
	LDI  R26,1
	LDI  R30,LOW(1)
	EOR  R30,R26
	BRNE _0x65
	CBI  0x15,4
	RJMP _0x66
_0x65:
	SBI  0x15,4
_0x66:
	RJMP _0x45
; 0000 004D  case TV: rc^=1;
_0x64:
	CPI  R30,LOW(0x3F)
	LDI  R26,HIGH(0x3F)
	CPC  R31,R26
	BRNE _0x45
	LDI  R26,0
	SBIC 0x15,5
	LDI  R26,1
	LDI  R30,LOW(1)
	EOR  R30,R26
	BRNE _0x68
	CBI  0x15,5
	RJMP _0x69
_0x68:
	SBI  0x15,5
_0x69:
; 0000 004E  }
_0x45:
; 0000 004F 
; 0000 0050 
; 0000 0051  delay_ms(10);
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _delay_ms
; 0000 0052 
; 0000 0053  GIFR |= (1 << INTF0);
_0x94:
	IN   R30,0x3A
	ORI  R30,0x40
	OUT  0x3A,R30
; 0000 0054  GICR|=0x40;
	IN   R30,0x3B
	ORI  R30,0x40
	OUT  0x3B,R30
; 0000 0055 
; 0000 0056   }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
;interrupt [TIM1_COMPA] void timer1_compa_isr(void)
; 0000 0058 {
_timer1_compa_isr:
	ST   -Y,R26
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0059 
; 0000 005A B=(!TOOGLE)?buf[step2++]:buf2[step2++];
	SBRC R2,0
	RJMP _0x6A
	LDS  R30,_step2
	SUBI R30,-LOW(1)
	STS  _step2,R30
	SUBI R30,LOW(1)
	LDI  R31,0
	SUBI R30,LOW(-_buf)
	SBCI R31,HIGH(-_buf)
	RJMP _0x92
_0x6A:
	LDS  R30,_step2
	SUBI R30,-LOW(1)
	STS  _step2,R30
	SUBI R30,LOW(1)
	LDI  R31,0
	SUBI R30,LOW(-_buf2)
	SBCI R31,HIGH(-_buf2)
_0x92:
	LD   R30,Z
	OUT  0x18,R30
; 0000 005B if (step2>ALL-1) step2=0;
	LDS  R26,_step2
	CPI  R26,LOW(0x50)
	BRLO _0x6D
	LDI  R30,LOW(0)
	STS  _step2,R30
; 0000 005C TCNT1=0;
_0x6D:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	OUT  0x2C+1,R31
	OUT  0x2C,R30
; 0000 005D 
; 0000 005E }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R26,Y+
	RETI
;interrupt [TIM2_COMP] void timer1_compb_isr(void)
; 0000 0060 {
_timer1_compb_isr:
	ST   -Y,R26
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0061 R((TOOGLE)?buf[step++]:buf2[step++]);
	SBRS R2,0
	RJMP _0x6E
	LDS  R30,_step
	SUBI R30,-LOW(1)
	STS  _step,R30
	SUBI R30,LOW(1)
	LDI  R31,0
	SUBI R30,LOW(-_buf)
	SBCI R31,HIGH(-_buf)
	RJMP _0x93
_0x6E:
	LDS  R30,_step
	SUBI R30,-LOW(1)
	STS  _step,R30
	SUBI R30,LOW(1)
	LDI  R31,0
	SUBI R30,LOW(-_buf2)
	SBCI R31,HIGH(-_buf2)
_0x93:
	LD   R30,Z
	OUT  0x12,R30
	SBIC 0x12,2
	RJMP _0x71
	CBI  0x15,3
	RJMP _0x72
_0x71:
	SBI  0x15,3
_0x72:
; 0000 0062 if (step>=ALL-1) step=0;
	LDS  R26,_step
	CPI  R26,LOW(0x4F)
	BRLO _0x73
	LDI  R30,LOW(0)
	STS  _step,R30
; 0000 0063  TCNT2=0;
_0x73:
	LDI  R30,LOW(0)
	OUT  0x24,R30
; 0000 0064 }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R26,Y+
	RETI
;
;
;void main(void)
; 0000 0068 {
_main:
; 0000 0069  unsigned int x=0;
; 0000 006A 
; 0000 006B startup();
;	x -> R16,R17
	__GETWRN 16,17,0
	RCALL _startup
; 0000 006C fillnil(buf);
	LDI  R30,LOW(_buf)
	LDI  R31,HIGH(_buf)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _fillnil
; 0000 006D test();
	RCALL _test
; 0000 006E R(0);
	LDI  R30,LOW(0)
	OUT  0x12,R30
	SBIC 0x12,2
	RJMP _0x74
	CBI  0x15,3
	RJMP _0x75
_0x74:
	SBI  0x15,3
_0x75:
; 0000 006F B=0;
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 0070 bc=rc=0;
	CBI  0x15,5
	CBI  0x15,4
; 0000 0071   delay_ms(2000);
	LDI  R30,LOW(2000)
	LDI  R31,HIGH(2000)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _delay_ms
; 0000 0072 
; 0000 0073  #asm("sei")
	sei
; 0000 0074   R(0); rc=0;
	LDI  R30,LOW(0)
	OUT  0x12,R30
	SBIC 0x12,2
	RJMP _0x7A
	CBI  0x15,3
	RJMP _0x7B
_0x7A:
	SBI  0x15,3
_0x7B:
	CBI  0x15,5
; 0000 0075   put_char("Запуск...",1000);
	__POINTW1MN _0x7E,0
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(232)
	ST   -Y,R30
	RCALL _put_char
; 0000 0076          delay_s(3);
	LDI  R30,LOW(3)
	ST   -Y,R30
	RCALL _delay_s
; 0000 0077          for(x=10; x>0; x--) {   ltoa(  x, digbuf); put_char(digbuf,0); delay_ms(1000);     }
	__GETWRN 16,17,10
_0x80:
	CLR  R0
	CP   R0,R16
	CPC  R0,R17
	BRSH _0x81
	MOVW R30,R16
	CLR  R22
	CLR  R23
	RCALL __PUTPARD1
	LDI  R30,LOW(_digbuf)
	LDI  R31,HIGH(_digbuf)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _ltoa
	LDI  R30,LOW(_digbuf)
	LDI  R31,HIGH(_digbuf)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL _put_char
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _delay_ms
	__SUBWRN 16,17,1
	RJMP _0x80
_0x81:
; 0000 0078             background(6);
	LDI  R30,LOW(6)
	ST   -Y,R30
	RCALL _background
; 0000 0079   put_char("",1000);
	__POINTW1MN _0x7E,10
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(232)
	ST   -Y,R30
	RCALL _put_char
; 0000 007A 
; 0000 007B     while(1)
_0x82:
; 0000 007C      {
; 0000 007D 
; 0000 007E      writeocr();
	RCALL _writeocr
; 0000 007F        while( (temper=ds18b20_temperature(0)) && (temper<-50 || temper>80)) {    delay_ms(5);   }
_0x85:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _ds18b20_temperature
	RCALL __CFD1
	MOVW R4,R30
	SBIW R30,0
	BREQ _0x88
	LDI  R30,LOW(65486)
	LDI  R31,HIGH(65486)
	CP   R4,R30
	CPC  R5,R31
	BRLT _0x89
	LDI  R30,LOW(80)
	LDI  R31,HIGH(80)
	CP   R30,R4
	CPC  R31,R5
	BRGE _0x88
_0x89:
	RJMP _0x8B
_0x88:
	RJMP _0x87
_0x8B:
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _delay_ms
	RJMP _0x85
_0x87:
; 0000 0080 
; 0000 0081          ltoa(  temper, digbuf);
	MOVW R30,R4
	RCALL __CWD1
	RCALL __PUTPARD1
	LDI  R30,LOW(_digbuf)
	LDI  R31,HIGH(_digbuf)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _ltoa
; 0000 0082 
; 0000 0083       fillnil (  buffer );
	LDI  R30,LOW(_buffer)
	LDI  R31,HIGH(_buffer)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _fillnil
; 0000 0084 
; 0000 0085       strcat(buffer,"В комнате:");
	LDI  R30,LOW(_buffer)
	LDI  R31,HIGH(_buffer)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1MN _0x7E,11
	ST   -Y,R31
	ST   -Y,R30
	RCALL _strcat
; 0000 0086       strcat(buffer,digbuf);
	LDI  R30,LOW(_buffer)
	LDI  R31,HIGH(_buffer)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(_digbuf)
	LDI  R31,HIGH(_digbuf)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _strcat
; 0000 0087       strcat(buffer,"c");
	LDI  R30,LOW(_buffer)
	LDI  R31,HIGH(_buffer)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1MN _0x7E,22
	ST   -Y,R31
	ST   -Y,R30
	RCALL _strcat
; 0000 0088        put_char(buffer,1000);
	LDI  R30,LOW(_buffer)
	LDI  R31,HIGH(_buffer)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(232)
	ST   -Y,R30
	RCALL _put_char
; 0000 0089        delay_s(10);
	LDI  R30,LOW(10)
	ST   -Y,R30
	RCALL _delay_s
; 0000 008A        fillnil (  buffer );
	LDI  R30,LOW(_buffer)
	LDI  R31,HIGH(_buffer)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _fillnil
; 0000 008B        gettime() ;
	RCALL _gettime
; 0000 008C         strcpy(buffer,"Время:  ");
	LDI  R30,LOW(_buffer)
	LDI  R31,HIGH(_buffer)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1MN _0x7E,24
	ST   -Y,R31
	ST   -Y,R30
	RCALL _strcpy
; 0000 008D        ltoa(  t.hour, digbuf);
	__GETB1MN _t,2
	LDI  R31,0
	RCALL __CWD1
	RCALL __PUTPARD1
	LDI  R30,LOW(_digbuf)
	LDI  R31,HIGH(_digbuf)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _ltoa
; 0000 008E        strcat(buffer,digbuf);
	LDI  R30,LOW(_buffer)
	LDI  R31,HIGH(_buffer)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(_digbuf)
	LDI  R31,HIGH(_digbuf)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _strcat
; 0000 008F        strcat(buffer,":");
	LDI  R30,LOW(_buffer)
	LDI  R31,HIGH(_buffer)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1MN _0x7E,33
	ST   -Y,R31
	ST   -Y,R30
	RCALL _strcat
; 0000 0090         ltoa(  t.min, digbuf);
	__GETB1MN _t,1
	LDI  R31,0
	RCALL __CWD1
	RCALL __PUTPARD1
	LDI  R30,LOW(_digbuf)
	LDI  R31,HIGH(_digbuf)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _ltoa
; 0000 0091         if(t.min<10) strcat(buffer,"0");
	__GETB2MN _t,1
	CPI  R26,LOW(0xA)
	BRSH _0x8C
	LDI  R30,LOW(_buffer)
	LDI  R31,HIGH(_buffer)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1MN _0x7E,35
	ST   -Y,R31
	ST   -Y,R30
	RCALL _strcat
; 0000 0092        strcat(buffer,digbuf);
_0x8C:
	LDI  R30,LOW(_buffer)
	LDI  R31,HIGH(_buffer)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(_digbuf)
	LDI  R31,HIGH(_digbuf)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _strcat
; 0000 0093         put_char(buffer,1000);
	LDI  R30,LOW(_buffer)
	LDI  R31,HIGH(_buffer)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(232)
	ST   -Y,R30
	RCALL _put_char
; 0000 0094           delay_s(10);
	LDI  R30,LOW(10)
	ST   -Y,R30
	RCALL _delay_s
; 0000 0095         strcpyf(buffer,week[t.dow-1]);
	LDI  R30,LOW(_buffer)
	LDI  R31,HIGH(_buffer)
	ST   -Y,R31
	ST   -Y,R30
	__GETB1MN _t,3
	LDI  R31,0
	SBIW R30,1
	LDI  R26,LOW(_week)
	LDI  R27,HIGH(_week)
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	RCALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	RCALL _strcpyf
; 0000 0096         put_char(buffer,1000);
	LDI  R30,LOW(_buffer)
	LDI  R31,HIGH(_buffer)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(232)
	ST   -Y,R30
	RCALL _put_char
; 0000 0097          delay_s(10);
	LDI  R30,LOW(10)
	ST   -Y,R30
	RCALL _delay_s
; 0000 0098 
; 0000 0099          ltoa(  t.date, digbuf);
	__GETB1MN _t,4
	LDI  R31,0
	RCALL __CWD1
	RCALL __PUTPARD1
	LDI  R30,LOW(_digbuf)
	LDI  R31,HIGH(_digbuf)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _ltoa
; 0000 009A             strcpy(buffer,digbuf);
	LDI  R30,LOW(_buffer)
	LDI  R31,HIGH(_buffer)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(_digbuf)
	LDI  R31,HIGH(_digbuf)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _strcpy
; 0000 009B              strcat(buffer," ");
	LDI  R30,LOW(_buffer)
	LDI  R31,HIGH(_buffer)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1MN _0x7E,37
	ST   -Y,R31
	ST   -Y,R30
	RCALL _strcat
; 0000 009C              strcatf(buffer,month[t.month-1]);
	LDI  R30,LOW(_buffer)
	LDI  R31,HIGH(_buffer)
	ST   -Y,R31
	ST   -Y,R30
	__GETB1MN _t,5
	LDI  R31,0
	SBIW R30,1
	LDI  R26,LOW(_month)
	LDI  R27,HIGH(_month)
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	RCALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	RCALL _strcatf
; 0000 009D              strcat(buffer," 20");
	LDI  R30,LOW(_buffer)
	LDI  R31,HIGH(_buffer)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1MN _0x7E,39
	ST   -Y,R31
	ST   -Y,R30
	RCALL _strcat
; 0000 009E              ltoa(  t.year, digbuf);
	__GETB1MN _t,6
	LDI  R31,0
	RCALL __CWD1
	RCALL __PUTPARD1
	LDI  R30,LOW(_digbuf)
	LDI  R31,HIGH(_digbuf)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _ltoa
; 0000 009F               strcat(buffer,digbuf);
	LDI  R30,LOW(_buffer)
	LDI  R31,HIGH(_buffer)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(_digbuf)
	LDI  R31,HIGH(_digbuf)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _strcat
; 0000 00A0             put_char(buffer,1000);
	LDI  R30,LOW(_buffer)
	LDI  R31,HIGH(_buffer)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(232)
	ST   -Y,R30
	RCALL _put_char
; 0000 00A1        delay_s(10);
	LDI  R30,LOW(10)
	ST   -Y,R30
	RCALL _delay_s
; 0000 00A2        put_char("AVR ATMEGA 8",2000);
	__POINTW1MN _0x7E,43
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(208)
	ST   -Y,R30
	RCALL _put_char
; 0000 00A3            delay_s(10);
	LDI  R30,LOW(10)
	ST   -Y,R30
	RCALL _delay_s
; 0000 00A4             put_char("ГАОУ СПО БМТ",2000);
	__POINTW1MN _0x7E,56
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(208)
	ST   -Y,R30
	RCALL _put_char
; 0000 00A5            delay_s(10);
	LDI  R30,LOW(10)
	ST   -Y,R30
	RCALL _delay_s
; 0000 00A6            put_char("КРЕАТИВ",2000);
	__POINTW1MN _0x7E,69
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(208)
	ST   -Y,R30
	RCALL _put_char
; 0000 00A7            delay_s(10);
	LDI  R30,LOW(10)
	ST   -Y,R30
	RCALL _delay_s
; 0000 00A8            put_char("Г. БУГУЛЬМА",2000);
	__POINTW1MN _0x7E,77
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(208)
	ST   -Y,R30
	RCALL _put_char
; 0000 00A9            delay_s(10);
	LDI  R30,LOW(10)
	ST   -Y,R30
	RCALL _delay_s
; 0000 00AA            put_char("ДЛЯ КАЗАНИ",2000);
	__POINTW1MN _0x7E,89
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(208)
	ST   -Y,R30
	RCALL _put_char
; 0000 00AB            delay_s(10);
	LDI  R30,LOW(10)
	ST   -Y,R30
	RCALL _delay_s
; 0000 00AC                 put_char("=) :) ^_^ ;-)",2000);
	__POINTW1MN _0x7E,100
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(208)
	ST   -Y,R30
	RCALL _put_char
; 0000 00AD            delay_s(10);
	LDI  R30,LOW(10)
	ST   -Y,R30
	RCALL _delay_s
; 0000 00AE     /*   put_char("г. Бавлы",2000);
; 0000 00AF         delay_s(10);
; 0000 00B0           put_char("Саша <3 Света",2000);
; 0000 00B1             delay_s(10);
; 0000 00B2           put_char("=) :) ^_^ ;-)",2000);
; 0000 00B3            delay_s(10);
; 0000 00B4             put_char("Найти работу!",2000);
; 0000 00B5            delay_s(10);
; 0000 00B6            put_char("И квартиру :)",2000);
; 0000 00B7            delay_s(10);
; 0000 00B8            put_char("Зарплата 45000р",2000);
; 0000 00B9            delay_s(10);
; 0000 00BA         */
; 0000 00BB            fillnil (  buffer );
	LDI  R30,LOW(_buffer)
	LDI  R31,HIGH(_buffer)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _fillnil
; 0000 00BC            for(x=100; x>0; x--) {   ltoa(  x, digbuf); put_char(digbuf,0); delay_ms(100);     }
	__GETWRN 16,17,100
_0x8E:
	CLR  R0
	CP   R0,R16
	CPC  R0,R17
	BRSH _0x8F
	MOVW R30,R16
	CLR  R22
	CLR  R23
	RCALL __PUTPARD1
	LDI  R30,LOW(_digbuf)
	LDI  R31,HIGH(_digbuf)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _ltoa
	LDI  R30,LOW(_digbuf)
	LDI  R31,HIGH(_digbuf)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL _put_char
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _delay_ms
	__SUBWRN 16,17,1
	RJMP _0x8E
_0x8F:
; 0000 00BD            put_char("BOOM!!! :-D",5000);
	__POINTW1MN _0x7E,114
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(136)
	ST   -Y,R30
	RCALL _put_char
; 0000 00BE            delay_s(3);
	LDI  R30,LOW(3)
	ST   -Y,R30
	RCALL _delay_s
; 0000 00BF      }
	RJMP _0x82
; 0000 00C0 
; 0000 00C1     /*
; 0000 00C2    while(1) {
; 0000 00C3 
; 0000 00C4      while( (temper=ds18b20_temperature(0)) && (temper<-50 || temper>80)) {    delay_us(400);   }
; 0000 00C5    gettime() ;
; 0000 00C6       fillnil (  buffer );
; 0000 00C7    ltoa(  temper, buffer);
; 0000 00C8 
; 0000 00C9 
; 0000 00CA 
; 0000 00CB 
; 0000 00CC 
; 0000 00CD     put_char( buffer ,1000);
; 0000 00CE    delay_ms(1000);
; 0000 00CF     ltoa(  t.min, buffer);
; 0000 00D0      put_char(buffer,1000);
; 0000 00D1       delay_ms(1000); }
; 0000 00D2 
; 0000 00D3 
; 0000 00D4 
; 0000 00D5     while(1)
; 0000 00D6 
; 0000 00D7     {
; 0000 00D8 
; 0000 00D9 
; 0000 00DA 
; 0000 00DB 
; 0000 00DC 
; 0000 00DD     fillnil (  buffer );
; 0000 00DE   ltoa(  temper, buffer);  *buffer=*strcat("Температура: ",buffer);   put_char(buffer,1000);
; 0000 00DF     delay_s(5);
; 0000 00E0    fillnil (  buffer );
; 0000 00E1 
; 0000 00E2 
; 0000 00E3 
; 0000 00E4   ltoa(  t.hour, buffer);
; 0000 00E5  *buffer=*strcat("Часов: ",buffer);
; 0000 00E6  put_char(buffer,1000);
; 0000 00E7       delay_s(5);
; 0000 00E8        fillnil (  buffer );
; 0000 00E9      ltoa(  t.min, buffer);
; 0000 00EA 
; 0000 00EB      *buffer=*strcat("Минут: ",buffer);
; 0000 00EC  put_char(buffer,1000);
; 0000 00ED       fillnil (  buffer );
; 0000 00EE   delay_s(5);
; 0000 00EF     }
; 0000 00F0 
; 0000 00F1     while(1) {
; 0000 00F2 
; 0000 00F3 
; 0000 00F4     //    ltoa( counter, buffer); put_char(buffer,1);
; 0000 00F5      while(!RC_FLAG);
; 0000 00F6 
; 0000 00F7 
; 0000 00F8 
; 0000 00F9 RC_FLAG=0;
; 0000 00FA 
; 0000 00FB 
; 0000 00FC 
; 0000 00FD   put_char(buffer,1);
; 0000 00FE    delay_ms(1000);
; 0000 00FF 
; 0000 0100    }
; 0000 0101 
; 0000 0102 
; 0000 0103 
; 0000 0104 
; 0000 0105 
; 0000 0106 
; 0000 0107    for(x=100; x!=0; x--) { ltoa(x, buffer); put_char(buffer,1); delay_ms(50); }
; 0000 0108             delay_s(1);
; 0000 0109              rc=0;
; 0000 010A              background(6);
; 0000 010B              put_char("Поехали!",1000);
; 0000 010C                    delay_s(5);
; 0000 010D 
; 0000 010E 
; 0000 010F        put_char("",1000);
; 0000 0110 
; 0000 0111        background(0);
; 0000 0112        delay_s(5);
; 0000 0113         TOOGLE ^=1;
; 0000 0114          delay_s(10);
; 0000 0115           TOOGLE ^=1;
; 0000 0116     background(2);
; 0000 0117            put_char("КНИТУ-КАИ",1000);
; 0000 0118              delay_s(15);
; 0000 0119 
; 0000 011A      background(3);
; 0000 011B   while(1){
; 0000 011C     rc=0;
; 0000 011D 
; 0000 011E           put_char("ГАОУ СПО БМТ",1000);
; 0000 011F            delay_s(10);
; 0000 0120         put_char("САЙТ: bumate.ru",1000);
; 0000 0121          delay_s(10);
; 0000 0122           put_char("Маркин 29471",1000);
; 0000 0123          delay_s(10);
; 0000 0124           put_char("КНИТУ-КАИ 2015",1000);
; 0000 0125          delay_s(10);
; 0000 0126             put_char(":-) :-D =) ^_^",1000);
; 0000 0127          delay_s(10);
; 0000 0128           bg=(bg>6)?3:(bg+1);
; 0000 0129          background(bg);
; 0000 012A          }
; 0000 012B               */
; 0000 012C 
; 0000 012D 
; 0000 012E 
; 0000 012F 
; 0000 0130 
; 0000 0131 
; 0000 0132 
; 0000 0133 }
_0x90:
	RJMP _0x90

	.DSEG
_0x7E:
	.BYTE 0x7E

	.CSEG
_memset:
    ldd  r27,y+1
    ld   r26,y
    adiw r26,0
    breq memset1
    ldd  r31,y+4
    ldd  r30,y+3
    ldd  r22,y+2
memset0:
    st   z+,r22
    sbiw r26,1
    brne memset0
memset1:
    ldd  r30,y+3
    ldd  r31,y+4
	RJMP _0x20E0003
_strcat:
    ld   r30,y+
    ld   r31,y+
    ld   r26,y+
    ld   r27,y+
    movw r24,r26
strcat0:
    ld   r22,x+
    tst  r22
    brne strcat0
    sbiw r26,1
strcat1:
    ld   r22,z+
    st   x+,r22
    tst  r22
    brne strcat1
    movw r30,r24
    ret
_strcatf:
    ld   r30,y+
    ld   r31,y+
    ld   r26,y+
    ld   r27,y+
    movw r24,r26
strcatf0:
    ld   r22,x+
    tst  r22
    brne strcatf0
    sbiw r26,1
strcatf1:
	lpm  r0,z+
    st   x+,r0
    tst  r0
    brne strcatf1
    movw r30,r24
    ret
_strcpy:
    ld   r30,y+
    ld   r31,y+
    ld   r26,y+
    ld   r27,y+
    movw r24,r26
strcpy0:
    ld   r22,z+
    st   x+,r22
    tst  r22
    brne strcpy0
    movw r30,r24
    ret
_strcpyf:
    ld   r30,y+
    ld   r31,y+
    ld   r26,y+
    ld   r27,y+
    movw r24,r26
strcpyf0:
	lpm  r0,z+
    st   x+,r0
    tst  r0
    brne strcpyf0
    movw r30,r24
    ret

	.CSEG
_ltoa:
	SBIW R28,4
	RCALL __SAVELOCR2
	__GETD1N 0x3B9ACA00
	__PUTD1S 2
	LDI  R16,LOW(0)
	LDD  R26,Y+11
	TST  R26
	BRPL _0x2020003
	__GETD1S 8
	RCALL __ANEGD1
	__PUTD1S 8
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADIW R26,1
	STD  Y+6,R26
	STD  Y+6+1,R27
	SBIW R26,1
	LDI  R30,LOW(45)
	ST   X,R30
_0x2020003:
_0x2020005:
	__GETD1S 2
	__GETD2S 8
	RCALL __DIVD21U
	MOV  R17,R30
	CPI  R17,0
	BRNE _0x2020008
	CPI  R16,0
	BRNE _0x2020008
	__GETD2S 2
	__CPD2N 0x1
	BRNE _0x2020007
_0x2020008:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADIW R26,1
	STD  Y+6,R26
	STD  Y+6+1,R27
	SBIW R26,1
	MOV  R30,R17
	SUBI R30,-LOW(48)
	ST   X,R30
	LDI  R16,LOW(1)
_0x2020007:
	__GETD1S 2
	__GETD2S 8
	RCALL __MODD21U
	__PUTD1S 8
	__GETD2S 2
	__GETD1N 0xA
	RCALL __DIVD21U
	__PUTD1S 2
	RCALL __CPD10
	BREQ _0x2020006
	RJMP _0x2020005
_0x2020006:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
	RCALL __LOADLOCR2
	ADIW R28,12
	RET

	.DSEG

	.CSEG

	.CSEG
_ds18b20_select:
	ST   -Y,R17
	RCALL _w1_init
	CPI  R30,0
	BRNE _0x2040003
	LDI  R30,LOW(0)
	LDD  R17,Y+0
	RJMP _0x20E0002
_0x2040003:
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	SBIW R30,0
	BREQ _0x2040004
	LDI  R30,LOW(85)
	ST   -Y,R30
	RCALL _w1_write
	LDI  R17,LOW(0)
_0x2040006:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	ST   -Y,R30
	RCALL _w1_write
	SUBI R17,-LOW(1)
	CPI  R17,8
	BRLO _0x2040006
	RJMP _0x2040008
_0x2040004:
	LDI  R30,LOW(204)
	ST   -Y,R30
	RCALL _w1_write
_0x2040008:
	LDI  R30,LOW(1)
	LDD  R17,Y+0
	RJMP _0x20E0002
_ds18b20_read_spd:
	RCALL __SAVELOCR4
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	ST   -Y,R31
	ST   -Y,R30
	RCALL _ds18b20_select
	CPI  R30,0
	BRNE _0x2040009
	LDI  R30,LOW(0)
	RCALL __LOADLOCR4
	RJMP _0x20E0001
_0x2040009:
	LDI  R30,LOW(190)
	ST   -Y,R30
	RCALL _w1_write
	LDI  R17,LOW(0)
	__POINTWRM 18,19,___ds18b20_scratch_pad
_0x204000B:
	PUSH R19
	PUSH R18
	__ADDWRN 18,19,1
	RCALL _w1_read
	POP  R26
	POP  R27
	ST   X,R30
	SUBI R17,-LOW(1)
	CPI  R17,9
	BRLO _0x204000B
	LDI  R30,LOW(___ds18b20_scratch_pad)
	LDI  R31,HIGH(___ds18b20_scratch_pad)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(9)
	ST   -Y,R30
	RCALL _w1_dow_crc8
	RCALL __LNEGB1
	RCALL __LOADLOCR4
	RJMP _0x20E0001
_ds18b20_temperature:
	ST   -Y,R17
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ST   -Y,R31
	ST   -Y,R30
	RCALL _ds18b20_read_spd
	CPI  R30,0
	BRNE _0x204000D
	__GETD1N 0xC61C3C00
	LDD  R17,Y+0
	RJMP _0x20E0002
_0x204000D:
	__GETB2MN ___ds18b20_scratch_pad,4
	LDI  R27,0
	LDI  R30,LOW(5)
	RCALL __ASRW12
	ANDI R30,LOW(0x3)
	MOV  R17,R30
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ST   -Y,R31
	ST   -Y,R30
	RCALL _ds18b20_select
	CPI  R30,0
	BRNE _0x204000E
	__GETD1N 0xC61C3C00
	LDD  R17,Y+0
	RJMP _0x20E0002
_0x204000E:
	LDI  R30,LOW(68)
	ST   -Y,R30
	RCALL _w1_write
	MOV  R30,R17
	LDI  R26,LOW(_conv_delay_G102*2)
	LDI  R27,HIGH(_conv_delay_G102*2)
	LDI  R31,0
	LSL  R30
	ROL  R31
	ADD  R30,R26
	ADC  R31,R27
	RCALL __GETW1PF
	ST   -Y,R31
	ST   -Y,R30
	RCALL _delay_ms
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ST   -Y,R31
	ST   -Y,R30
	RCALL _ds18b20_read_spd
	CPI  R30,0
	BRNE _0x204000F
	__GETD1N 0xC61C3C00
	LDD  R17,Y+0
	RJMP _0x20E0002
_0x204000F:
	RCALL _w1_init
	MOV  R30,R17
	LDI  R26,LOW(_bit_mask_G102*2)
	LDI  R27,HIGH(_bit_mask_G102*2)
	LDI  R31,0
	LSL  R30
	ROL  R31
	ADD  R30,R26
	ADC  R31,R27
	RCALL __GETW1PF
	LDS  R26,___ds18b20_scratch_pad
	LDS  R27,___ds18b20_scratch_pad+1
	AND  R30,R26
	AND  R31,R27
	RCALL __CWD1
	RCALL __CDF1
	__GETD2N 0x3D800000
	RCALL __MULF12
	LDD  R17,Y+0
	RJMP _0x20E0002
_ds18b20_init:
	LDD  R30,Y+3
	LDD  R31,Y+3+1
	ST   -Y,R31
	ST   -Y,R30
	RCALL _ds18b20_select
	CPI  R30,0
	BRNE _0x2040010
	LDI  R30,LOW(0)
	RJMP _0x20E0003
_0x2040010:
	LD   R30,Y
	SWAP R30
	ANDI R30,0xF0
	LSL  R30
	ORI  R30,LOW(0x1F)
	ST   Y,R30
	LDI  R30,LOW(78)
	ST   -Y,R30
	RCALL _w1_write
	LDD  R30,Y+1
	ST   -Y,R30
	RCALL _w1_write
	LDD  R30,Y+2
	ST   -Y,R30
	RCALL _w1_write
	LD   R30,Y
	ST   -Y,R30
	RCALL _w1_write
	LDD  R30,Y+3
	LDD  R31,Y+3+1
	ST   -Y,R31
	ST   -Y,R30
	RCALL _ds18b20_read_spd
	CPI  R30,0
	BRNE _0x2040011
	LDI  R30,LOW(0)
	RJMP _0x20E0003
_0x2040011:
	__GETB2MN ___ds18b20_scratch_pad,3
	LDD  R30,Y+2
	CP   R30,R26
	BRNE _0x2040013
	__GETB2MN ___ds18b20_scratch_pad,2
	LDD  R30,Y+1
	CP   R30,R26
	BRNE _0x2040013
	__GETB2MN ___ds18b20_scratch_pad,4
	LD   R30,Y
	CP   R30,R26
	BREQ _0x2040012
_0x2040013:
	LDI  R30,LOW(0)
	RJMP _0x20E0003
_0x2040012:
	LDD  R30,Y+3
	LDD  R31,Y+3+1
	ST   -Y,R31
	ST   -Y,R30
	RCALL _ds18b20_select
	CPI  R30,0
	BRNE _0x2040015
	LDI  R30,LOW(0)
	RJMP _0x20E0003
_0x2040015:
	LDI  R30,LOW(72)
	ST   -Y,R30
	RCALL _w1_write
	LDI  R30,LOW(15)
	LDI  R31,HIGH(15)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _delay_ms
	RCALL _w1_init
_0x20E0003:
	ADIW R28,5
	RET

	.CSEG
_rtc_init:
	LDD  R30,Y+2
	ANDI R30,LOW(0x3)
	STD  Y+2,R30
	LDD  R30,Y+1
	CPI  R30,0
	BREQ _0x2060003
	LDD  R30,Y+2
	ORI  R30,0x10
	STD  Y+2,R30
_0x2060003:
	LD   R30,Y
	CPI  R30,0
	BREQ _0x2060004
	LDD  R30,Y+2
	ORI  R30,0x80
	STD  Y+2,R30
_0x2060004:
	RCALL _i2c_start
	LDI  R30,LOW(208)
	ST   -Y,R30
	RCALL _i2c_write
	LDI  R30,LOW(7)
	ST   -Y,R30
	RCALL _i2c_write
	LDD  R30,Y+2
	ST   -Y,R30
	RCALL _i2c_write
	RCALL _i2c_stop
_0x20E0002:
	ADIW R28,3
	RET
_rtc_get_time:
	RCALL _i2c_start
	LDI  R30,LOW(208)
	ST   -Y,R30
	RCALL _i2c_write
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL _i2c_write
	RCALL _i2c_start
	LDI  R30,LOW(209)
	ST   -Y,R30
	RCALL _i2c_write
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _i2c_read
	ST   -Y,R30
	RCALL _bcd2bin
	LD   R26,Y
	LDD  R27,Y+1
	ST   X,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _i2c_read
	ST   -Y,R30
	RCALL _bcd2bin
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ST   X,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL _i2c_read
	ST   -Y,R30
	RCALL _bcd2bin
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	ST   X,R30
	RCALL _i2c_stop
_0x20E0001:
	ADIW R28,6
	RET
_rtc_get_date:
	RCALL _i2c_start
	LDI  R30,LOW(208)
	ST   -Y,R30
	RCALL _i2c_write
	LDI  R30,LOW(3)
	ST   -Y,R30
	RCALL _i2c_write
	RCALL _i2c_start
	LDI  R30,LOW(209)
	ST   -Y,R30
	RCALL _i2c_write
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _i2c_read
	ST   -Y,R30
	RCALL _bcd2bin
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ST   X,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _i2c_read
	ST   -Y,R30
	RCALL _bcd2bin
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	ST   X,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _i2c_read
	ST   -Y,R30
	RCALL _bcd2bin
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ST   X,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL _i2c_read
	ST   -Y,R30
	RCALL _bcd2bin
	LD   R26,Y
	LDD  R27,Y+1
	ST   X,R30
	RCALL _i2c_stop
	ADIW R28,8
	RET

	.CSEG

	.CSEG

	.CSEG
_bcd2bin:
    ld   r30,y
    swap r30
    andi r30,0xf
    mov  r26,r30
    lsl  r26
    lsl  r26
    add  r30,r26
    lsl  r30
    ld   r26,y+
    andi r26,0xf
    add  r30,r26
    ret

	.DSEG
___ds18b20_scratch_pad:
	.BYTE 0x9

	.ESEG
_OCRA:
	.BYTE 0x2
_OCRB:
	.BYTE 0x2

	.DSEG
_RC5_DATA:
	.BYTE 0x2
_counter:
	.BYTE 0x2
_step:
	.BYTE 0x1
_step2:
	.BYTE 0x1
_buf:
	.BYTE 0x50
_buf2:
	.BYTE 0x50
_buffer:
	.BYTE 0x50
_digbuf:
	.BYTE 0xC
_i:
	.BYTE 0x1
_month:
	.BYTE 0x18
_week:
	.BYTE 0xE
_t:
	.BYTE 0x7
__seed_G101:
	.BYTE 0x4

	.CSEG

	.CSEG
	.equ __i2c_dir=__i2c_port-1
	.equ __i2c_pin=__i2c_port-2
_i2c_init:
	cbi  __i2c_port,__scl_bit
	cbi  __i2c_port,__sda_bit
	sbi  __i2c_dir,__scl_bit
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_delay2
_i2c_start:
	cbi  __i2c_dir,__sda_bit
	cbi  __i2c_dir,__scl_bit
	clr  r30
	nop
	sbis __i2c_pin,__sda_bit
	ret
	sbis __i2c_pin,__scl_bit
	ret
	rcall __i2c_delay1
	sbi  __i2c_dir,__sda_bit
	rcall __i2c_delay1
	sbi  __i2c_dir,__scl_bit
	ldi  r30,1
__i2c_delay1:
	ldi  r22,7
	rjmp __i2c_delay2l
_i2c_stop:
	sbi  __i2c_dir,__sda_bit
	sbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
	cbi  __i2c_dir,__sda_bit
__i2c_delay2:
	ldi  r22,13
__i2c_delay2l:
	dec  r22
	brne __i2c_delay2l
	ret
_i2c_read:
	ldi  r23,8
__i2c_read0:
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
__i2c_read3:
	sbis __i2c_pin,__scl_bit
	rjmp __i2c_read3
	rcall __i2c_delay1
	clc
	sbic __i2c_pin,__sda_bit
	sec
	sbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	rol  r30
	dec  r23
	brne __i2c_read0
	ld   r23,y+
	tst  r23
	brne __i2c_read1
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_read2
__i2c_read1:
	sbi  __i2c_dir,__sda_bit
__i2c_read2:
	rcall __i2c_delay1
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	sbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_delay1

_i2c_write:
	ld   r30,y+
	ldi  r23,8
__i2c_write0:
	lsl  r30
	brcc __i2c_write1
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_write2
__i2c_write1:
	sbi  __i2c_dir,__sda_bit
__i2c_write2:
	rcall __i2c_delay2
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
__i2c_write3:
	sbis __i2c_pin,__scl_bit
	rjmp __i2c_write3
	rcall __i2c_delay1
	sbi  __i2c_dir,__scl_bit
	dec  r23
	brne __i2c_write0
	cbi  __i2c_dir,__sda_bit
	rcall __i2c_delay1
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	ldi  r30,1
	sbic __i2c_pin,__sda_bit
	clr  r30
	sbi  __i2c_dir,__scl_bit
	rjmp __i2c_delay1

_delay_ms:
	ld   r30,y+
	ld   r31,y+
	adiw r30,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x3E8
	wdr
	sbiw r30,1
	brne __delay_ms0
__delay_ms1:
	ret

	.equ __w1_port=0x15
	.equ __w1_bit=0x02

_w1_init:
	clr  r30
	cbi  __w1_port,__w1_bit
	sbi  __w1_port-1,__w1_bit
	__DELAY_USW 0x1E0
	cbi  __w1_port-1,__w1_bit
	__DELAY_USB 0x13
	sbis __w1_port-2,__w1_bit
	ret
	__DELAY_USB 0x65
	sbis __w1_port-2,__w1_bit
	ldi  r30,1
	__DELAY_USW 0x186
	ret

__w1_read_bit:
	sbi  __w1_port-1,__w1_bit
	__DELAY_USB 0x3
	cbi  __w1_port-1,__w1_bit
	__DELAY_USB 0xF
	clc
	sbic __w1_port-2,__w1_bit
	sec
	ror  r30
	__DELAY_USB 0x6B
	ret

__w1_write_bit:
	clt
	sbi  __w1_port-1,__w1_bit
	__DELAY_USB 0x3
	sbrc r23,0
	cbi  __w1_port-1,__w1_bit
	__DELAY_USB 0x11
	sbic __w1_port-2,__w1_bit
	rjmp __w1_write_bit0
	sbrs r23,0
	rjmp __w1_write_bit1
	ret
__w1_write_bit0:
	sbrs r23,0
	ret
__w1_write_bit1:
	__DELAY_USB 0x64
	cbi  __w1_port-1,__w1_bit
	__DELAY_USB 0x7
	set
	ret

_w1_read:
	ldi  r22,8
	__w1_read0:
	rcall __w1_read_bit
	dec  r22
	brne __w1_read0
	ret

_w1_write:
	ldi  r22,8
	ld   r23,y+
	clr  r30
__w1_write0:
	rcall __w1_write_bit
	brtc __w1_write1
	ror  r23
	dec  r22
	brne __w1_write0
	inc  r30
__w1_write1:
	ret

_w1_dow_crc8:
	clr  r30
	ld   r24,y
	tst  r24
	breq __w1_dow_crc83
	ldi  r22,0x18
	ldd  r26,y+1
	ldd  r27,y+2
__w1_dow_crc80:
	ldi  r25,8
	ld   r31,x+
__w1_dow_crc81:
	mov  r23,r31
	eor  r23,r30
	ror  r23
	brcc __w1_dow_crc82
	eor  r30,r22
__w1_dow_crc82:
	ror  r30
	lsr  r31
	dec  r25
	brne __w1_dow_crc81
	dec  r24
	brne __w1_dow_crc80
__w1_dow_crc83:
	adiw r28,3
	ret

__ROUND_REPACK:
	TST  R21
	BRPL __REPACK
	CPI  R21,0x80
	BRNE __ROUND_REPACK0
	SBRS R30,0
	RJMP __REPACK
__ROUND_REPACK0:
	ADIW R30,1
	ADC  R22,R25
	ADC  R23,R25
	BRVS __REPACK1

__REPACK:
	LDI  R21,0x80
	EOR  R21,R23
	BRNE __REPACK0
	PUSH R21
	RJMP __ZERORES
__REPACK0:
	CPI  R21,0xFF
	BREQ __REPACK1
	LSL  R22
	LSL  R0
	ROR  R21
	ROR  R22
	MOV  R23,R21
	RET
__REPACK1:
	PUSH R21
	TST  R0
	BRMI __REPACK2
	RJMP __MAXRES
__REPACK2:
	RJMP __MINRES

__UNPACK:
	LDI  R21,0x80
	MOV  R1,R25
	AND  R1,R21
	LSL  R24
	ROL  R25
	EOR  R25,R21
	LSL  R21
	ROR  R24

__UNPACK1:
	LDI  R21,0x80
	MOV  R0,R23
	AND  R0,R21
	LSL  R22
	ROL  R23
	EOR  R23,R21
	LSL  R21
	ROR  R22
	RET

__CFD1U:
	SET
	RJMP __CFD1U0
__CFD1:
	CLT
__CFD1U0:
	PUSH R21
	RCALL __UNPACK1
	CPI  R23,0x80
	BRLO __CFD10
	CPI  R23,0xFF
	BRCC __CFD10
	RJMP __ZERORES
__CFD10:
	LDI  R21,22
	SUB  R21,R23
	BRPL __CFD11
	NEG  R21
	CPI  R21,8
	BRTC __CFD19
	CPI  R21,9
__CFD19:
	BRLO __CFD17
	SER  R30
	SER  R31
	SER  R22
	LDI  R23,0x7F
	BLD  R23,7
	RJMP __CFD15
__CFD17:
	CLR  R23
	TST  R21
	BREQ __CFD15
__CFD18:
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	DEC  R21
	BRNE __CFD18
	RJMP __CFD15
__CFD11:
	CLR  R23
__CFD12:
	CPI  R21,8
	BRLO __CFD13
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R23
	SUBI R21,8
	RJMP __CFD12
__CFD13:
	TST  R21
	BREQ __CFD15
__CFD14:
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	DEC  R21
	BRNE __CFD14
__CFD15:
	TST  R0
	BRPL __CFD16
	RCALL __ANEGD1
__CFD16:
	POP  R21
	RET

__CDF1U:
	SET
	RJMP __CDF1U0
__CDF1:
	CLT
__CDF1U0:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __CDF10
	CLR  R0
	BRTS __CDF11
	TST  R23
	BRPL __CDF11
	COM  R0
	RCALL __ANEGD1
__CDF11:
	MOV  R1,R23
	LDI  R23,30
	TST  R1
__CDF12:
	BRMI __CDF13
	DEC  R23
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R1
	RJMP __CDF12
__CDF13:
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R1
	PUSH R21
	RCALL __REPACK
	POP  R21
__CDF10:
	RET

__ZERORES:
	CLR  R30
	CLR  R31
	CLR  R22
	CLR  R23
	POP  R21
	RET

__MINRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	SER  R23
	POP  R21
	RET

__MAXRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	LDI  R23,0x7F
	POP  R21
	RET

__MULF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BREQ __ZERORES
	CPI  R25,0x80
	BREQ __ZERORES
	EOR  R0,R1
	SEC
	ADC  R23,R25
	BRVC __MULF124
	BRLT __ZERORES
__MULF125:
	TST  R0
	BRMI __MINRES
	RJMP __MAXRES
__MULF124:
	PUSH R0
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R17
	CLR  R18
	CLR  R25
	MUL  R22,R24
	MOVW R20,R0
	MUL  R24,R31
	MOV  R19,R0
	ADD  R20,R1
	ADC  R21,R25
	MUL  R22,R27
	ADD  R19,R0
	ADC  R20,R1
	ADC  R21,R25
	MUL  R24,R30
	RCALL __MULF126
	MUL  R27,R31
	RCALL __MULF126
	MUL  R22,R26
	RCALL __MULF126
	MUL  R27,R30
	RCALL __MULF127
	MUL  R26,R31
	RCALL __MULF127
	MUL  R26,R30
	ADD  R17,R1
	ADC  R18,R25
	ADC  R19,R25
	ADC  R20,R25
	ADC  R21,R25
	MOV  R30,R19
	MOV  R31,R20
	MOV  R22,R21
	MOV  R21,R18
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	POP  R0
	TST  R22
	BRMI __MULF122
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	RJMP __MULF123
__MULF122:
	INC  R23
	BRVS __MULF125
__MULF123:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__MULF127:
	ADD  R17,R0
	ADC  R18,R1
	ADC  R19,R25
	RJMP __MULF128
__MULF126:
	ADD  R18,R0
	ADC  R19,R1
__MULF128:
	ADC  R20,R25
	ADC  R21,R25
	RET

__ANEGD1:
	COM  R31
	COM  R22
	COM  R23
	NEG  R30
	SBCI R31,-1
	SBCI R22,-1
	SBCI R23,-1
	RET

__LSLB12:
	TST  R30
	MOV  R0,R30
	MOV  R30,R26
	BREQ __LSLB12R
__LSLB12L:
	LSL  R30
	DEC  R0
	BRNE __LSLB12L
__LSLB12R:
	RET

__ASRW12:
	TST  R30
	MOV  R0,R30
	MOVW R30,R26
	BREQ __ASRW12R
__ASRW12L:
	ASR  R31
	ROR  R30
	DEC  R0
	BRNE __ASRW12L
__ASRW12R:
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__LNEGB1:
	TST  R30
	LDI  R30,1
	BREQ __LNEGB1F
	CLR  R30
__LNEGB1F:
	RET

__MULW12U:
	MUL  R31,R26
	MOV  R31,R0
	MUL  R30,R27
	ADD  R31,R0
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	RET

__DIVD21U:
	PUSH R19
	PUSH R20
	PUSH R21
	CLR  R0
	CLR  R1
	CLR  R20
	CLR  R21
	LDI  R19,32
__DIVD21U1:
	LSL  R26
	ROL  R27
	ROL  R24
	ROL  R25
	ROL  R0
	ROL  R1
	ROL  R20
	ROL  R21
	SUB  R0,R30
	SBC  R1,R31
	SBC  R20,R22
	SBC  R21,R23
	BRCC __DIVD21U2
	ADD  R0,R30
	ADC  R1,R31
	ADC  R20,R22
	ADC  R21,R23
	RJMP __DIVD21U3
__DIVD21U2:
	SBR  R26,1
__DIVD21U3:
	DEC  R19
	BRNE __DIVD21U1
	MOVW R30,R26
	MOVW R22,R24
	MOVW R26,R0
	MOVW R24,R20
	POP  R21
	POP  R20
	POP  R19
	RET

__MODD21U:
	RCALL __DIVD21U
	MOVW R30,R26
	MOVW R22,R24
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__GETW1PF:
	LPM  R0,Z+
	LPM  R31,Z
	MOV  R30,R0
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

__EEPROMRDW:
	ADIW R26,1
	RCALL __EEPROMRDB
	MOV  R31,R30
	SBIW R26,1

__EEPROMRDB:
	SBIC EECR,EEWE
	RJMP __EEPROMRDB
	PUSH R31
	IN   R31,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R30,EEDR
	OUT  SREG,R31
	POP  R31
	RET

__EEPROMWRW:
	RCALL __EEPROMWRB
	ADIW R26,1
	PUSH R30
	MOV  R30,R31
	RCALL __EEPROMWRB
	POP  R30
	SBIW R26,1
	RET

__EEPROMWRB:
	SBIS EECR,EEWE
	RJMP __EEPROMWRB1
	WDR
	RJMP __EEPROMWRB
__EEPROMWRB1:
	IN   R25,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R24,EEDR
	CP   R30,R24
	BREQ __EEPROMWRB0
	OUT  EEDR,R30
	SBI  EECR,EEMWE
	SBI  EECR,EEWE
__EEPROMWRB0:
	OUT  SREG,R25
	RET

__CPD10:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	RET

__BSTB1:
	CLT
	TST  R30
	BREQ PC+2
	SET
	RET

__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

__LOADLOCR2P:
	LD   R16,Y+
	LD   R17,Y+
	RET

;END OF CODE MARKER
__END_OF_CODE:
