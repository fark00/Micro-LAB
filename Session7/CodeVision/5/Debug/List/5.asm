
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega16
;Program type           : Application
;Clock frequency        : 8.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 256 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: Yes
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega16
	#pragma AVRPART MEMORY PROG_FLASH 16384
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1024
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	#define CALL_SUPPORTED 1

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
	.EQU __DSTACK_SIZE=0x0100
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

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
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
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
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
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	.DEF _rx_wr_index=R5
	.DEF _rx_rd_index=R4
	.DEF _rx_counter=R7
	.DEF _tx_wr_index=R6
	.DEF _tx_rd_index=R9
	.DEF _tx_counter=R8
	.DEF __lcd_x=R11
	.DEF __lcd_y=R10
	.DEF __lcd_maxx=R13

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _usart_rx_isr
	JMP  0x00
	JMP  _usart_tx_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_tbl10_G101:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G101:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

;REGISTER BIT VARIABLES INITIALIZATION
__REG_BIT_VARS:
	.DW  0x0000

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0

_0x0:
	.DB  0x51,0x75,0x65,0x73,0x74,0x69,0x6F,0x6E
	.DB  0x35,0x3A,0x20,0x73,0x74,0x61,0x72,0x74
	.DB  0x2E,0x2E,0x2E,0xD,0x0,0x70,0x61,0x72
	.DB  0x74,0x20,0x32,0x20,0x69,0x73,0x20,0x72
	.DB  0x75,0x6E,0x6E,0x69,0x6E,0x67,0x21,0xD
	.DB  0x0,0x70,0x61,0x72,0x74,0x20,0x32,0x20
	.DB  0x69,0x73,0x20,0x65,0x6E,0x64,0x65,0x64
	.DB  0x21,0xD,0x0,0x70,0x61,0x72,0x74,0x20
	.DB  0x33,0x20,0x69,0x73,0x20,0x72,0x75,0x6E
	.DB  0x6E,0x69,0x6E,0x67,0x21,0xD,0x0,0x70
	.DB  0x61,0x72,0x74,0x20,0x33,0x20,0x69,0x73
	.DB  0x20,0x65,0x6E,0x64,0x65,0x64,0x21,0xD
	.DB  0x0,0x70,0x61,0x72,0x74,0x20,0x34,0x20
	.DB  0x69,0x73,0x20,0x72,0x75,0x6E,0x6E,0x69
	.DB  0x6E,0x67,0x21,0xD,0x0,0x70,0x61,0x72
	.DB  0x74,0x20,0x34,0x20,0x69,0x73,0x20,0x65
	.DB  0x6E,0x64,0x65,0x64,0x21,0xD,0x0,0x51
	.DB  0x75,0x65,0x73,0x74,0x69,0x6F,0x6E,0x35
	.DB  0x3A,0x20,0x65,0x6E,0x64,0x2E,0x2E,0x2E
	.DB  0xD,0x0
_0x40026:
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0
_0x40041:
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0
_0x40000:
	.DB  0xD,0x54,0x78,0x3A,0x0,0xD,0x52,0x78
	.DB  0x3A,0x20,0x44,0x61,0x74,0x61,0x20,0x69
	.DB  0x73,0x20,0x61,0x20,0x69,0x6E,0x74,0x65
	.DB  0x67,0x65,0x72,0x20,0x61,0x6E,0x64,0x20
	.DB  0x31,0x30,0x2A,0x64,0x61,0x74,0x61,0x3D
	.DB  0x0,0x25,0x64,0x0,0xD,0x0,0x4C,0x43
	.DB  0x44,0x20,0x64,0x65,0x6C,0x65,0x74,0x65
	.DB  0x0,0xD,0x4D,0x69,0x63,0x72,0x6F,0x20
	.DB  0x4C,0x61,0x62,0x6F,0x72,0x61,0x74,0x6F
	.DB  0x72,0x79,0xD,0x0,0xD,0x4E,0x6F,0x20
	.DB  0x66,0x75,0x6E,0x63,0x74,0x69,0x6F,0x6E
	.DB  0x20,0x64,0x65,0x66,0x69,0x6E,0x65,0x64
	.DB  0x21,0xD,0x0,0x9,0x4C,0x65,0x6E,0x67
	.DB  0x74,0x68,0x20,0x6F,0x66,0x20,0x66,0x72
	.DB  0x61,0x6D,0x65,0x20,0x6E,0x6F,0x74,0x20
	.DB  0x63,0x6F,0x72,0x72,0x65,0x63,0x74,0xD
	.DB  0x0,0x9,0x46,0x72,0x61,0x6D,0x65,0x20
	.DB  0x6D,0x75,0x73,0x74,0x20,0x62,0x65,0x20
	.DB  0x35,0x20,0x69,0x6E,0x74,0x65,0x67,0x65
	.DB  0x72,0xD,0x0,0x9,0x46,0x72,0x61,0x6D
	.DB  0x65,0x20,0x69,0x73,0x20,0x63,0x6F,0x72
	.DB  0x72,0x65,0x63,0x74,0xD,0x0
_0x2000003:
	.DB  0x80,0xC0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  0x02
	.DW  __REG_BIT_VARS*2

	.DW  0x06
	.DW  0x04
	.DW  __REG_VARS*2

	.DW  0x15
	.DW  _0x14
	.DW  _0x0*2

	.DW  0x14
	.DW  _0x14+21
	.DW  _0x0*2+21

	.DW  0x12
	.DW  _0x14+41
	.DW  _0x0*2+41

	.DW  0x14
	.DW  _0x14+59
	.DW  _0x0*2+59

	.DW  0x12
	.DW  _0x14+79
	.DW  _0x0*2+79

	.DW  0x14
	.DW  _0x14+97
	.DW  _0x0*2+97

	.DW  0x12
	.DW  _0x14+117
	.DW  _0x0*2+117

	.DW  0x13
	.DW  _0x14+135
	.DW  _0x0*2+135

	.DW  0x05
	.DW  _0x4003B
	.DW  _0x40000*2

	.DW  0x24
	.DW  _0x4003B+5
	.DW  _0x40000*2+5

	.DW  0x02
	.DW  _0x4003B+41
	.DW  _0x40000*2+44

	.DW  0x0B
	.DW  _0x4003B+43
	.DW  _0x40000*2+46

	.DW  0x13
	.DW  _0x4003B+54
	.DW  _0x40000*2+57

	.DW  0x17
	.DW  _0x4003B+73
	.DW  _0x40000*2+76

	.DW  0x1E
	.DW  _0x4004E
	.DW  _0x40000*2+99

	.DW  0x1A
	.DW  _0x4004E+30
	.DW  _0x40000*2+129

	.DW  0x13
	.DW  _0x4004E+56
	.DW  _0x40000*2+155

	.DW  0x02
	.DW  __base_y_G100
	.DW  _0x2000003*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

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

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x160

	.CSEG
;/*******************************************************
;This program was created by the
;CodeWizardAVR V3.12 Advanced
;Automatic Program Generator
;© Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project :
;Version :
;Date    : 5/11/2021
;Author  :
;Company :
;Comments:
;
;
;Chip type               : ATmega16
;Program type            : Application
;AVR Core Clock frequency: 8.000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 256
;*******************************************************/
;
;#include <header.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;
;#define DATA_REGISTER_EMPTY (1<<UDRE)
;#define RX_COMPLETE (1<<RXC)
;#define FRAMING_ERROR (1<<FE)
;#define PARITY_ERROR (1<<UPE)
;#define DATA_OVERRUN (1<<DOR)
;
;// USART Receiver buffer
;#define RX_BUFFER_SIZE 8
;char rx_buffer[RX_BUFFER_SIZE];
;
;#if RX_BUFFER_SIZE <= 256
;unsigned char rx_wr_index=0,rx_rd_index=0;
;#else
;unsigned int rx_wr_index=0,rx_rd_index=0;
;#endif
;
;#if RX_BUFFER_SIZE < 256
;unsigned char rx_counter=0;
;#else
;unsigned int rx_counter=0;
;#endif
;
;// This flag is set on USART Receiver buffer overflow
;bit rx_buffer_overflow;
;
;// USART Receiver interrupt service routine
;interrupt [USART_RXC] void usart_rx_isr(void)
; 0000 0035 {

	.CSEG
_usart_rx_isr:
; .FSTART _usart_rx_isr
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0036 char status,data;
; 0000 0037 status=UCSRA;
	ST   -Y,R17
	ST   -Y,R16
;	status -> R17
;	data -> R16
	IN   R17,11
; 0000 0038 data=UDR;
	IN   R16,12
; 0000 0039 if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
	MOV  R30,R17
	ANDI R30,LOW(0x1C)
	BRNE _0x3
; 0000 003A    {
; 0000 003B    rx_buffer[rx_wr_index++]=data;
	MOV  R30,R5
	INC  R5
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer)
	SBCI R31,HIGH(-_rx_buffer)
	ST   Z,R16
; 0000 003C #if RX_BUFFER_SIZE == 256
; 0000 003D    // special case for receiver buffer size=256
; 0000 003E    if (++rx_counter == 0) rx_buffer_overflow=1;
; 0000 003F #else
; 0000 0040    if (rx_wr_index == RX_BUFFER_SIZE) rx_wr_index=0;
	LDI  R30,LOW(8)
	CP   R30,R5
	BRNE _0x4
	CLR  R5
; 0000 0041    if (++rx_counter == RX_BUFFER_SIZE)
_0x4:
	INC  R7
	LDI  R30,LOW(8)
	CP   R30,R7
	BRNE _0x5
; 0000 0042       {
; 0000 0043       rx_counter=0;
	CLR  R7
; 0000 0044       rx_buffer_overflow=1;
	SET
	BLD  R2,0
; 0000 0045       }
; 0000 0046 #endif
; 0000 0047    }
_0x5:
; 0000 0048 }
_0x3:
	LD   R16,Y+
	LD   R17,Y+
	RJMP _0x19
; .FEND
;/*
;#ifndef _DEBUG_TERMINAL_IO_
;// Get a character from the USART Receiver buffer
;#define _ALTERNATE_GETCHAR_
;#pragma used+   */
;char getchar_(void)
; 0000 004F {
_getchar_:
; .FSTART _getchar_
; 0000 0050 char data;
; 0000 0051 while (rx_counter==0);
	ST   -Y,R17
;	data -> R17
_0x6:
	TST  R7
	BREQ _0x6
; 0000 0052 data=rx_buffer[rx_rd_index++];
	MOV  R30,R4
	INC  R4
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer)
	SBCI R31,HIGH(-_rx_buffer)
	LD   R17,Z
; 0000 0053 #if RX_BUFFER_SIZE != 256
; 0000 0054 if (rx_rd_index == RX_BUFFER_SIZE) rx_rd_index=0;
	LDI  R30,LOW(8)
	CP   R30,R4
	BRNE _0x9
	CLR  R4
; 0000 0055 #endif
; 0000 0056 #asm("cli")
_0x9:
	cli
; 0000 0057 --rx_counter;
	DEC  R7
; 0000 0058 #asm("sei")
	sei
; 0000 0059 return data;
	MOV  R30,R17
	LD   R17,Y+
	RET
; 0000 005A }
; .FEND
;
;/*
;#pragma used-
;#endif */
;
;// USART Transmitter buffer
;#define TX_BUFFER_SIZE 8
;char tx_buffer[TX_BUFFER_SIZE];
;
;#if TX_BUFFER_SIZE <= 256
;unsigned char tx_wr_index=0,tx_rd_index=0;
;#else
;unsigned int tx_wr_index=0,tx_rd_index=0;
;#endif
;
;#if TX_BUFFER_SIZE < 256
;unsigned char tx_counter=0;
;#else
;unsigned int tx_counter=0;
;#endif
;
;// USART Transmitter interrupt service routine
;interrupt [USART_TXC] void usart_tx_isr(void)
; 0000 0072 {
_usart_tx_isr:
; .FSTART _usart_tx_isr
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0073 if (tx_counter)
	TST  R8
	BREQ _0xA
; 0000 0074    {
; 0000 0075    --tx_counter;
	DEC  R8
; 0000 0076    UDR=tx_buffer[tx_rd_index++];
	MOV  R30,R9
	INC  R9
	LDI  R31,0
	SUBI R30,LOW(-_tx_buffer)
	SBCI R31,HIGH(-_tx_buffer)
	LD   R30,Z
	OUT  0xC,R30
; 0000 0077 #if TX_BUFFER_SIZE != 256
; 0000 0078    if (tx_rd_index == TX_BUFFER_SIZE) tx_rd_index=0;
	LDI  R30,LOW(8)
	CP   R30,R9
	BRNE _0xB
	CLR  R9
; 0000 0079 #endif
; 0000 007A    }
_0xB:
; 0000 007B }
_0xA:
_0x19:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	RETI
; .FEND
;/*
;#ifndef _DEBUG_TERMINAL_IO_
;// Write a character to the USART Transmitter buffer
;#define _ALTERNATE_PUTCHAR_
;#pragma used+    */
;void putchar_(char c)
; 0000 0082 {
_putchar_:
; .FSTART _putchar_
; 0000 0083 while (tx_counter == TX_BUFFER_SIZE);
	ST   -Y,R26
;	c -> Y+0
_0xC:
	LDI  R30,LOW(8)
	CP   R30,R8
	BREQ _0xC
; 0000 0084 #asm("cli")
	cli
; 0000 0085 if (tx_counter || ((UCSRA & DATA_REGISTER_EMPTY)==0))
	TST  R8
	BRNE _0x10
	SBIC 0xB,5
	RJMP _0xF
_0x10:
; 0000 0086    {
; 0000 0087    tx_buffer[tx_wr_index++]=c;
	MOV  R30,R6
	INC  R6
	LDI  R31,0
	SUBI R30,LOW(-_tx_buffer)
	SBCI R31,HIGH(-_tx_buffer)
	LD   R26,Y
	STD  Z+0,R26
; 0000 0088 #if TX_BUFFER_SIZE != 256
; 0000 0089    if (tx_wr_index == TX_BUFFER_SIZE) tx_wr_index=0;
	LDI  R30,LOW(8)
	CP   R30,R6
	BRNE _0x12
	CLR  R6
; 0000 008A #endif
; 0000 008B    ++tx_counter;
_0x12:
	INC  R8
; 0000 008C    }
; 0000 008D else
	RJMP _0x13
_0xF:
; 0000 008E    UDR=c;
	LD   R30,Y
	OUT  0xC,R30
; 0000 008F #asm("sei")
_0x13:
	sei
	JMP  _0x2080004
; 0000 0090 }
; .FEND
;/*
;#pragma used-
;#endif       */
;
;// Question1
;void routin1(int BAUD, int transmitter_status, int reciever_status);
;
;// Question4
;void routin4(void);
;
;// Standard Input/Output functions
;#include <stdio.h>
;
;void main(void)
; 0000 009F {
_main:
; .FSTART _main
; 0000 00A0 // Declare your local variables here
; 0000 00A1 
; 0000 00A2 // Global enable interrupts
; 0000 00A3 #asm("sei")
	sei
; 0000 00A4     init();
	RCALL _init
; 0000 00A5     routin1(9600,1,1);
	CALL SUBOPT_0x0
	LDI  R26,LOW(1)
	LDI  R27,0
	CALL _routin1
; 0000 00A6     puts("Question5: start...\r");
	__POINTW2MN _0x14,0
	CALL _puts
; 0000 00A7     puts("part 2 is running!\r");
	__POINTW2MN _0x14,21
	CALL _puts
; 0000 00A8     routin2();
	CALL _routin2
; 0000 00A9     routin2();
	CALL _routin2
; 0000 00AA     routin2();
	CALL _routin2
; 0000 00AB     puts("part 2 is ended!\r");
	__POINTW2MN _0x14,41
	CALL _puts
; 0000 00AC     routin1(9600,1,2);
	CALL SUBOPT_0x0
	LDI  R26,LOW(2)
	LDI  R27,0
	CALL _routin1
; 0000 00AD     puts("part 3 is running!\r");
	__POINTW2MN _0x14,59
	CALL _puts
; 0000 00AE     routin3();
	CALL _routin3
; 0000 00AF     routin3();
	CALL _routin3
; 0000 00B0     routin3();
	CALL _routin3
; 0000 00B1     puts("part 3 is ended!\r");
	__POINTW2MN _0x14,79
	CALL _puts
; 0000 00B2     routin1(9600,2,2);
	LDI  R30,LOW(9600)
	LDI  R31,HIGH(9600)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(2)
	LDI  R27,0
	CALL _routin1
; 0000 00B3     puts("part 4 is running!\r");
	__POINTW2MN _0x14,97
	CALL _puts
; 0000 00B4     routin4();
	CALL _routin4
; 0000 00B5     routin4();
	CALL _routin4
; 0000 00B6     routin4();
	CALL _routin4
; 0000 00B7     puts("part 4 is ended!\r");
	__POINTW2MN _0x14,117
	CALL _puts
; 0000 00B8      puts("Question5: end...\r");
	__POINTW2MN _0x14,135
	CALL _puts
; 0000 00B9     while(1){}
_0x15:
	RJMP _0x15
; 0000 00BA }
_0x18:
	RJMP _0x18
; .FEND

	.DSEG
_0x14:
	.BYTE 0x9A
;#include <header.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;
;void init(void){
; 0001 0003 void init(void){

	.CSEG
_init:
; .FSTART _init
; 0001 0004     // Input/Output Ports initialization
; 0001 0005     // Port A initialization
; 0001 0006     // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0001 0007     DDRA=(0<<DDA7) | (0<<DDA6) | (0<<DDA5) | (0<<DDA4) | (0<<DDA3) | (0<<DDA2) | (0<<DDA1) | (0<<DDA0);
	LDI  R30,LOW(0)
	OUT  0x1A,R30
; 0001 0008     // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0001 0009     PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);
	OUT  0x1B,R30
; 0001 000A 
; 0001 000B     // Port B initialization
; 0001 000C     // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0001 000D     DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (0<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
	OUT  0x17,R30
; 0001 000E     // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0001 000F     PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
	OUT  0x18,R30
; 0001 0010 
; 0001 0011     // Port C initialization
; 0001 0012     // Function: Bit7=Out Bit6=Out Bit5=Out Bit4=Out Bit3=Out Bit2=Out Bit1=Out Bit0=Out
; 0001 0013     DDRC=(1<<DDC7) | (1<<DDC6) | (1<<DDC5) | (1<<DDC4) | (1<<DDC3) | (1<<DDC2) | (1<<DDC1) | (1<<DDC0);
	LDI  R30,LOW(255)
	OUT  0x14,R30
; 0001 0014     // State: Bit7=0 Bit6=0 Bit5=0 Bit4=0 Bit3=0 Bit2=0 Bit1=0 Bit0=0
; 0001 0015     PORTC=(0<<PORTC7) | (0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0001 0016 
; 0001 0017     // Port D initialization
; 0001 0018     // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0001 0019     DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
	OUT  0x11,R30
; 0001 001A     // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0001 001B     PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
	OUT  0x12,R30
; 0001 001C 
; 0001 001D     // Timer/Counter 0 initialization
; 0001 001E     // Clock source: System Clock
; 0001 001F     // Clock value: Timer 0 Stopped
; 0001 0020     // Mode: Normal top=0xFF
; 0001 0021     // OC0 output: Disconnected
; 0001 0022     TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (0<<WGM01) | (0<<CS02) | (0<<CS01) | (0<<CS00);
	OUT  0x33,R30
; 0001 0023     TCNT0=0x00;
	OUT  0x32,R30
; 0001 0024     OCR0=0x00;
	OUT  0x3C,R30
; 0001 0025 
; 0001 0026     // Timer/Counter 1 initialization
; 0001 0027     // Clock source: System Clock
; 0001 0028     // Clock value: Timer1 Stopped
; 0001 0029     // Mode: Normal top=0xFFFF
; 0001 002A     // OC1A output: Disconnected
; 0001 002B     // OC1B output: Disconnected
; 0001 002C     // Noise Canceler: Off
; 0001 002D     // Input Capture on Falling Edge
; 0001 002E     // Timer1 Overflow Interrupt: Off
; 0001 002F     // Input Capture Interrupt: Off
; 0001 0030     // Compare A Match Interrupt: Off
; 0001 0031     // Compare B Match Interrupt: Off
; 0001 0032     TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
	OUT  0x2F,R30
; 0001 0033     TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (0<<CS10);
	OUT  0x2E,R30
; 0001 0034     TCNT1H=0x00;
	OUT  0x2D,R30
; 0001 0035     TCNT1L=0x00;
	OUT  0x2C,R30
; 0001 0036     ICR1H=0x00;
	OUT  0x27,R30
; 0001 0037     ICR1L=0x00;
	OUT  0x26,R30
; 0001 0038     OCR1AH=0x00;
	OUT  0x2B,R30
; 0001 0039     OCR1AL=0x00;
	OUT  0x2A,R30
; 0001 003A     OCR1BH=0x00;
	OUT  0x29,R30
; 0001 003B     OCR1BL=0x00;
	OUT  0x28,R30
; 0001 003C 
; 0001 003D     // Timer/Counter 2 initialization
; 0001 003E     // Clock source: System Clock
; 0001 003F     // Clock value: Timer2 Stopped
; 0001 0040     // Mode: Normal top=0xFF
; 0001 0041     // OC2 output: Disconnected
; 0001 0042     ASSR=0<<AS2;
	OUT  0x22,R30
; 0001 0043     TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (0<<CS22) | (0<<CS21) | (0<<CS20);
	OUT  0x25,R30
; 0001 0044     TCNT2=0x00;
	OUT  0x24,R30
; 0001 0045     OCR2=0x00;
	OUT  0x23,R30
; 0001 0046 
; 0001 0047     // Timer(s)/Counter(s) Interrupt(s) initialization
; 0001 0048     TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<OCIE0) | (0<<TOIE0);
	OUT  0x39,R30
; 0001 0049 
; 0001 004A     // External Interrupt(s) initialization
; 0001 004B     // INT0: Off
; 0001 004C     // INT1: Off
; 0001 004D     // INT2: Off
; 0001 004E     MCUCR=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
	OUT  0x35,R30
; 0001 004F     MCUCSR=(0<<ISC2);
	OUT  0x34,R30
; 0001 0050 
; 0001 0051     // USART initialization
; 0001 0052     // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0001 0053     // USART Receiver: On
; 0001 0054     // USART Transmitter: On
; 0001 0055     // USART Mode: Asynchronous
; 0001 0056     // USART Baud Rate: 9600
; 0001 0057     UCSRA=(0<<RXC) | (0<<TXC) | (0<<UDRE) | (0<<FE) | (0<<DOR) | (0<<UPE) | (0<<U2X) | (0<<MPCM);
	OUT  0xB,R30
; 0001 0058     //UCSRB=(1<<RXCIE) | (1<<TXCIE) | (0<<UDRIE) | (1<<RXEN) | (1<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
; 0001 0059     UCSRC=(1<<URSEL) | (0<<UMSEL) | (0<<UPM1) | (0<<UPM0) | (0<<USBS) | (1<<UCSZ1) | (1<<UCSZ0) | (0<<UCPOL);
	LDI  R30,LOW(134)
	OUT  0x20,R30
; 0001 005A     UBRRH=0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0001 005B     UBRRL=0x33;
	LDI  R30,LOW(51)
	OUT  0x9,R30
; 0001 005C 
; 0001 005D     // Analog Comparator initialization
; 0001 005E     // Analog Comparator: Off
; 0001 005F     // The Analog Comparator's positive input is
; 0001 0060     // connected to the AIN0 pin
; 0001 0061     // The Analog Comparator's negative input is
; 0001 0062     // connected to the AIN1 pin
; 0001 0063     ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0001 0064     SFIOR=(0<<ACME);
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0001 0065 
; 0001 0066     // ADC initialization
; 0001 0067     // ADC disabled
; 0001 0068     ADCSRA=(0<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (0<<ADPS1) | (0<<ADPS0);
	OUT  0x6,R30
; 0001 0069 
; 0001 006A     // SPI initialization
; 0001 006B     // SPI disabled
; 0001 006C     SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);
	OUT  0xD,R30
; 0001 006D 
; 0001 006E     // TWI initialization
; 0001 006F     // TWI disabled
; 0001 0070     TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);
	OUT  0x36,R30
; 0001 0071 
; 0001 0072     // Alphanumeric LCD initialization
; 0001 0073     // Connections are specified in the
; 0001 0074     // Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
; 0001 0075     // RS - PORTC Bit 0
; 0001 0076     // RD - PORTC Bit 1
; 0001 0077     // EN - PORTC Bit 2
; 0001 0078     // D4 - PORTC Bit 4
; 0001 0079     // D5 - PORTC Bit 5
; 0001 007A     // D6 - PORTC Bit 6
; 0001 007B     // D7 - PORTC Bit 7
; 0001 007C     // Characters/line: 16
; 0001 007D     lcd_init(16);
	LDI  R26,LOW(16)
	CALL _lcd_init
; 0001 007E 
; 0001 007F }
	RET
; .FEND
;#include <header.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;
;
;void routin1(int BAUD, int transmitter_status, int reciever_status){
; 0002 0004 void routin1(int BAUD, int transmitter_status, int reciever_status){

	.CSEG
_routin1:
; .FSTART _routin1
; 0002 0005     int temp = (1000000/(2*BAUD))-1;
; 0002 0006     int q,r;
; 0002 0007     q = temp/256;
	ST   -Y,R27
	ST   -Y,R26
	CALL __SAVELOCR6
;	BAUD -> Y+10
;	transmitter_status -> Y+8
;	reciever_status -> Y+6
;	temp -> R16,R17
;	q -> R18,R19
;	r -> R20,R21
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	LSL  R30
	ROL  R31
	CALL __CWD1
	__GETD2N 0xF4240
	CALL __DIVD21
	SBIW R30,1
	MOVW R16,R30
	MOVW R26,R16
	LDI  R30,LOW(256)
	LDI  R31,HIGH(256)
	CALL __DIVW21
	MOVW R18,R30
; 0002 0008     r = temp - (q*256);
	MOV  R27,R18
	LDI  R26,LOW(0)
	MOVW R30,R16
	SUB  R30,R26
	SBC  R31,R27
	MOVW R20,R30
; 0002 0009 
; 0002 000A     if(transmitter_status == 0 && reciever_status == 0){
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,0
	BRNE _0x40004
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	SBIW R26,0
	BREQ _0x40005
_0x40004:
	RJMP _0x40003
_0x40005:
; 0002 000B         UCSRB=(0<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (0<<RXEN) | (0<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
	LDI  R30,LOW(0)
	RJMP _0x40054
; 0002 000C     } // tx: off     rx: off
; 0002 000D     else if(transmitter_status == 1 && reciever_status == 0){
_0x40003:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,1
	BRNE _0x40008
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	SBIW R26,0
	BREQ _0x40009
_0x40008:
	RJMP _0x40007
_0x40009:
; 0002 000E         UCSRB=(0<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (0<<RXEN) | (1<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
	LDI  R30,LOW(8)
	RJMP _0x40054
; 0002 000F     } // tx: enable_noneinterrupt       rx: off
; 0002 0010     else if(transmitter_status == 2 && reciever_status == 0){
_0x40007:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,2
	BRNE _0x4000C
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	SBIW R26,0
	BREQ _0x4000D
_0x4000C:
	RJMP _0x4000B
_0x4000D:
; 0002 0011         UCSRB=(0<<RXCIE) | (1<<TXCIE) | (0<<UDRIE) | (0<<RXEN) | (1<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
	LDI  R30,LOW(72)
	RJMP _0x40054
; 0002 0012     } // tx: enable_interrupt       rx: off
; 0002 0013     else if(transmitter_status == 0 && reciever_status == 1){
_0x4000B:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,0
	BRNE _0x40010
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	SBIW R26,1
	BREQ _0x40011
_0x40010:
	RJMP _0x4000F
_0x40011:
; 0002 0014         UCSRB=(0<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (1<<RXEN) | (0<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
	LDI  R30,LOW(16)
	RJMP _0x40054
; 0002 0015     } // tx: off     rx:  enable_noneinterrupt
; 0002 0016     else if(transmitter_status == 1 && reciever_status == 1){
_0x4000F:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,1
	BRNE _0x40014
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	SBIW R26,1
	BREQ _0x40015
_0x40014:
	RJMP _0x40013
_0x40015:
; 0002 0017         UCSRB=(0<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (1<<RXEN) | (1<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
	LDI  R30,LOW(24)
	RJMP _0x40054
; 0002 0018     } // tx: enable_noneinterrupt       rx:  enable_noneinterrupt
; 0002 0019     else if(transmitter_status == 2 && reciever_status == 1){
_0x40013:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,2
	BRNE _0x40018
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	SBIW R26,1
	BREQ _0x40019
_0x40018:
	RJMP _0x40017
_0x40019:
; 0002 001A         UCSRB=(0<<RXCIE) | (1<<TXCIE) | (0<<UDRIE) | (1<<RXEN) | (1<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
	LDI  R30,LOW(88)
	RJMP _0x40054
; 0002 001B     } // tx: enable_interrupt       rx:  enable_noneinterrupt
; 0002 001C     else if(transmitter_status == 0 && reciever_status == 2){
_0x40017:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,0
	BRNE _0x4001C
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	SBIW R26,2
	BREQ _0x4001D
_0x4001C:
	RJMP _0x4001B
_0x4001D:
; 0002 001D         UCSRB=(1<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (1<<RXEN) | (0<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
	LDI  R30,LOW(144)
	RJMP _0x40054
; 0002 001E     } // tx: off     rx:  enable_interrupt
; 0002 001F     else if(transmitter_status == 1 && reciever_status == 2){
_0x4001B:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,1
	BRNE _0x40020
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	SBIW R26,2
	BREQ _0x40021
_0x40020:
	RJMP _0x4001F
_0x40021:
; 0002 0020         UCSRB=(1<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (1<<RXEN) | (1<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
	LDI  R30,LOW(152)
	RJMP _0x40054
; 0002 0021     } // tx: enable_noneinterrupt       rx:  enable_interrupt
; 0002 0022     else if(transmitter_status == 2 && reciever_status == 2){
_0x4001F:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,2
	BRNE _0x40024
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	SBIW R26,2
	BREQ _0x40025
_0x40024:
	RJMP _0x40023
_0x40025:
; 0002 0023         UCSRB=(1<<RXCIE) | (1<<TXCIE) | (0<<UDRIE) | (1<<RXEN) | (1<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
	LDI  R30,LOW(216)
_0x40054:
	OUT  0xA,R30
; 0002 0024     } // tx: enable_interrupt       rx:  enable_interrupt
; 0002 0025     UBRRH = q;
_0x40023:
	OUT  0x20,R18
; 0002 0026     UBRRL = r;
	OUT  0x9,R20
; 0002 0027 }
	CALL __LOADLOCR6
	ADIW R28,12
	RET
; .FEND
;
;void routin2(){
; 0002 0029 void routin2(){
_routin2:
; .FSTART _routin2
; 0002 002A     char str2[100] = "";
; 0002 002B     char temp = '';
; 0002 002C     int n = 0;
; 0002 002D     temp = getchar();
	SBIW R28,63
	SBIW R28,37
	LDI  R24,100
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	LDI  R30,LOW(_0x40026*2)
	LDI  R31,HIGH(_0x40026*2)
	CALL __INITLOCB
	CALL __SAVELOCR4
;	str2 -> Y+4
;	temp -> R17
;	n -> R18,R19
	LDI  R17,0
	__GETWRN 18,19,0
	CALL SUBOPT_0x1
; 0002 002E     putchar(temp);
; 0002 002F     str2[0] = '(';
	LDI  R30,LOW(40)
	STD  Y+4,R30
; 0002 0030     n++;
	__ADDWRN 18,19,1
; 0002 0031     while(temp != '\r'){
_0x40027:
	CPI  R17,13
	BREQ _0x40029
; 0002 0032         str2[n] = temp;
	MOVW R30,R18
	MOVW R26,R28
	ADIW R26,4
	ADD  R30,R26
	ADC  R31,R27
	ST   Z,R17
; 0002 0033         temp = getchar();
	CALL SUBOPT_0x1
; 0002 0034         putchar(temp);
; 0002 0035         n++;
	__ADDWRN 18,19,1
; 0002 0036     }
	RJMP _0x40027
_0x40029:
; 0002 0037     str2[n] = ')';
	MOVW R26,R28
	ADIW R26,4
	ADD  R26,R18
	ADC  R27,R19
	LDI  R30,LOW(41)
	ST   X,R30
; 0002 0038     puts(str2);
	MOVW R26,R28
	ADIW R26,4
	CALL _puts
; 0002 0039     putchar('\r');
	LDI  R26,LOW(13)
	CALL _putchar
; 0002 003A 
; 0002 003B }
	CALL __LOADLOCR4
	ADIW R28,63
	ADIW R28,41
	RET
; .FEND
;
;void routin3(void){
; 0002 003D void routin3(void){
_routin3:
; .FSTART _routin3
; 0002 003E     unsigned char temp='';
; 0002 003F     int a=0;
; 0002 0040     unsigned char str[3]="";
; 0002 0041     temp = getchar_();
	SBIW R28,3
	LDI  R30,LOW(0)
	ST   Y,R30
	STD  Y+1,R30
	STD  Y+2,R30
	CALL __SAVELOCR4
;	temp -> R17
;	a -> R18,R19
;	str -> Y+4
	LDI  R17,0
	__GETWRN 18,19,0
	CALL _getchar_
	MOV  R17,R30
; 0002 0042     switch (temp){
	LDI  R31,0
; 0002 0043         case '0':
	CPI  R30,LOW(0x30)
	LDI  R26,HIGH(0x30)
	CPC  R31,R26
	BRNE _0x4002D
; 0002 0044             a=0;
	__GETWRN 18,19,0
; 0002 0045             break;
	RJMP _0x4002C
; 0002 0046         case '1':
_0x4002D:
	CPI  R30,LOW(0x31)
	LDI  R26,HIGH(0x31)
	CPC  R31,R26
	BRNE _0x4002E
; 0002 0047             a=1;
	__GETWRN 18,19,1
; 0002 0048             break;
	RJMP _0x4002C
; 0002 0049         case '2':
_0x4002E:
	CPI  R30,LOW(0x32)
	LDI  R26,HIGH(0x32)
	CPC  R31,R26
	BRNE _0x4002F
; 0002 004A             a=2;
	__GETWRN 18,19,2
; 0002 004B             break;
	RJMP _0x4002C
; 0002 004C         case '3':
_0x4002F:
	CPI  R30,LOW(0x33)
	LDI  R26,HIGH(0x33)
	CPC  R31,R26
	BRNE _0x40030
; 0002 004D             a=3;
	__GETWRN 18,19,3
; 0002 004E             break;
	RJMP _0x4002C
; 0002 004F         case '4':
_0x40030:
	CPI  R30,LOW(0x34)
	LDI  R26,HIGH(0x34)
	CPC  R31,R26
	BRNE _0x40031
; 0002 0050             a=4;
	__GETWRN 18,19,4
; 0002 0051             break;
	RJMP _0x4002C
; 0002 0052         case '5':
_0x40031:
	CPI  R30,LOW(0x35)
	LDI  R26,HIGH(0x35)
	CPC  R31,R26
	BRNE _0x40032
; 0002 0053             a=5;
	__GETWRN 18,19,5
; 0002 0054             break;
	RJMP _0x4002C
; 0002 0055         case '6':
_0x40032:
	CPI  R30,LOW(0x36)
	LDI  R26,HIGH(0x36)
	CPC  R31,R26
	BRNE _0x40033
; 0002 0056             a=6;
	__GETWRN 18,19,6
; 0002 0057             break;
	RJMP _0x4002C
; 0002 0058         case '7':
_0x40033:
	CPI  R30,LOW(0x37)
	LDI  R26,HIGH(0x37)
	CPC  R31,R26
	BRNE _0x40034
; 0002 0059             a=7;
	__GETWRN 18,19,7
; 0002 005A             break;
	RJMP _0x4002C
; 0002 005B         case '8':
_0x40034:
	CPI  R30,LOW(0x38)
	LDI  R26,HIGH(0x38)
	CPC  R31,R26
	BRNE _0x40035
; 0002 005C             a=8;
	__GETWRN 18,19,8
; 0002 005D             break;
	RJMP _0x4002C
; 0002 005E         case '9':
_0x40035:
	CPI  R30,LOW(0x39)
	LDI  R26,HIGH(0x39)
	CPC  R31,R26
	BRNE _0x40037
; 0002 005F             a=9;
	__GETWRN 18,19,9
; 0002 0060             break;
	RJMP _0x4002C
; 0002 0061         default:
_0x40037:
; 0002 0062             a=100;
	__GETWRN 18,19,100
; 0002 0063     }
_0x4002C:
; 0002 0064     if( a>=0 && a<10){
	TST  R19
	BRMI _0x40039
	__CPWRN 18,19,10
	BRLT _0x4003A
_0x40039:
	RJMP _0x40038
_0x4003A:
; 0002 0065         puts("\rTx:");
	__POINTW2MN _0x4003B,0
	CALL _puts
; 0002 0066         putchar(temp);
	MOV  R26,R17
	CALL _putchar
; 0002 0067         puts("\rRx: Data is a integer and 10*data=");
	__POINTW2MN _0x4003B,5
	CALL _puts
; 0002 0068         a=a*10;
	MOVW R30,R18
	LDI  R26,LOW(10)
	LDI  R27,HIGH(10)
	CALL __MULW12
	MOVW R18,R30
; 0002 0069         sprintf(str, "%d", a);
	MOVW R30,R28
	ADIW R30,4
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x40000,41
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R18
	CALL __CWD1
	CALL __PUTPARD1
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
; 0002 006A         puts(str);
	MOVW R26,R28
	ADIW R26,4
	CALL _puts
; 0002 006B         puts("\r");
	__POINTW2MN _0x4003B,41
	RJMP _0x40055
; 0002 006C      }
; 0002 006D 
; 0002 006E     else if(temp=='D'){
_0x40038:
	CPI  R17,68
	BRNE _0x4003D
; 0002 006F         lcd_puts("LCD delete");
	__POINTW2MN _0x4003B,43
	RCALL _lcd_puts
; 0002 0070     }
; 0002 0071 
; 0002 0072     else if(temp=='H'){
	RJMP _0x4003E
_0x4003D:
	CPI  R17,72
	BRNE _0x4003F
; 0002 0073         puts("\rMicro Laboratory\r");
	__POINTW2MN _0x4003B,54
	RJMP _0x40055
; 0002 0074     }
; 0002 0075 
; 0002 0076     else {
_0x4003F:
; 0002 0077         puts("\rNo function defined!\r");
	__POINTW2MN _0x4003B,73
_0x40055:
	CALL _puts
; 0002 0078     }
_0x4003E:
; 0002 0079 
; 0002 007A }
	CALL __LOADLOCR4
	ADIW R28,7
	RET
; .FEND

	.DSEG
_0x4003B:
	.BYTE 0x60
;
;
;void routin4(void){
; 0002 007D void routin4(void){

	.CSEG
_routin4:
; .FSTART _routin4
; 0002 007E     unsigned char my_data[55]="";
; 0002 007F     unsigned char in4='';
; 0002 0080     int i=0;
; 0002 0081     int a=0;
; 0002 0082     int j=0;
; 0002 0083     in4 = getchar_();
	SBIW R28,57
	LDI  R24,57
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	LDI  R30,LOW(_0x40041*2)
	LDI  R31,HIGH(_0x40041*2)
	CALL __INITLOCB
	CALL __SAVELOCR6
;	my_data -> Y+8
;	in4 -> R17
;	i -> R18,R19
;	a -> R20,R21
;	j -> Y+6
	LDI  R17,0
	__GETWRN 18,19,0
	__GETWRN 20,21,0
	CALL SUBOPT_0x2
; 0002 0084     putchar_(in4);
; 0002 0085     my_data[0]='(';
	LDI  R30,LOW(40)
	STD  Y+8,R30
; 0002 0086     i++;
	__ADDWRN 18,19,1
; 0002 0087     while (in4!='\r'){
_0x40042:
	CPI  R17,13
	BREQ _0x40044
; 0002 0088         my_data[i]=in4;
	MOVW R30,R18
	MOVW R26,R28
	ADIW R26,8
	ADD  R30,R26
	ADC  R31,R27
	ST   Z,R17
; 0002 0089         in4 = getchar_();
	CALL SUBOPT_0x2
; 0002 008A         putchar_(in4);
; 0002 008B         i++;
	__ADDWRN 18,19,1
; 0002 008C     }
	RJMP _0x40042
_0x40044:
; 0002 008D     my_data[i]=')';
	MOVW R26,R28
	ADIW R26,8
	ADD  R26,R18
	ADC  R27,R19
	LDI  R30,LOW(41)
	ST   X,R30
; 0002 008E     for (j=0;my_data[j]!=')';j++){
	LDI  R30,LOW(0)
	STD  Y+6,R30
	STD  Y+6+1,R30
_0x40046:
	CALL SUBOPT_0x3
	CPI  R26,LOW(0x29)
	BREQ _0x40047
; 0002 008F         if((my_data[j]<'0' || my_data[j]>'9')&&my_data[j]!='(')
	CALL SUBOPT_0x3
	CPI  R26,LOW(0x30)
	BRLO _0x40049
	CALL SUBOPT_0x3
	CPI  R26,LOW(0x3A)
	BRLO _0x4004B
_0x40049:
	CALL SUBOPT_0x3
	CPI  R26,LOW(0x28)
	BRNE _0x4004C
_0x4004B:
	RJMP _0x40048
_0x4004C:
; 0002 0090         {
; 0002 0091             a = 100;
	__GETWRN 20,21,100
; 0002 0092             break ;
	RJMP _0x40047
; 0002 0093         }
; 0002 0094     }
_0x40048:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,1
	STD  Y+6,R30
	STD  Y+6+1,R31
	RJMP _0x40046
_0x40047:
; 0002 0095     if(i<6){
	__CPWRN 18,19,6
	BRGE _0x4004D
; 0002 0096         puts("\tLength of frame not correct\r");
	__POINTW2MN _0x4004E,0
	CALL _puts
; 0002 0097     }
; 0002 0098     else if (a>9 || i > 6){
	RJMP _0x4004F
_0x4004D:
	__CPWRN 20,21,10
	BRGE _0x40051
	__CPWRN 18,19,7
	BRLT _0x40050
_0x40051:
; 0002 0099        puts("\tFrame must be 5 integer\r");
	__POINTW2MN _0x4004E,30
	CALL _puts
; 0002 009A     }
; 0002 009B     else {
	RJMP _0x40053
_0x40050:
; 0002 009C         puts("\tFrame is correct\r");
	__POINTW2MN _0x4004E,56
	CALL _puts
; 0002 009D         lcd_init(16);
	LDI  R26,LOW(16)
	RCALL _lcd_init
; 0002 009E         lcd_puts(my_data);
	MOVW R26,R28
	ADIW R26,8
	RCALL _lcd_puts
; 0002 009F     }
_0x40053:
_0x4004F:
; 0002 00A0 }
	CALL __LOADLOCR6
	ADIW R28,63
	RET
; .FEND

	.DSEG
_0x4004E:
	.BYTE 0x4B
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.DSEG

	.CSEG
__lcd_write_nibble_G100:
; .FSTART __lcd_write_nibble_G100
	ST   -Y,R26
	IN   R30,0x15
	ANDI R30,LOW(0xF)
	MOV  R26,R30
	LD   R30,Y
	ANDI R30,LOW(0xF0)
	OR   R30,R26
	OUT  0x15,R30
	__DELAY_USB 13
	SBI  0x15,2
	__DELAY_USB 13
	CBI  0x15,2
	__DELAY_USB 13
	JMP  _0x2080003
; .FEND
__lcd_write_data:
; .FSTART __lcd_write_data
	ST   -Y,R26
	LD   R26,Y
	RCALL __lcd_write_nibble_G100
    ld    r30,y
    swap  r30
    st    y,r30
	LD   R26,Y
	RCALL __lcd_write_nibble_G100
	__DELAY_USB 133
	JMP  _0x2080003
; .FEND
_lcd_gotoxy:
; .FSTART _lcd_gotoxy
	ST   -Y,R26
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G100)
	SBCI R31,HIGH(-__base_y_G100)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R26,R30
	RCALL __lcd_write_data
	LDD  R11,Y+1
	LDD  R10,Y+0
	ADIW R28,2
	RET
; .FEND
_lcd_clear:
; .FSTART _lcd_clear
	LDI  R26,LOW(2)
	CALL SUBOPT_0x4
	LDI  R26,LOW(12)
	RCALL __lcd_write_data
	LDI  R26,LOW(1)
	CALL SUBOPT_0x4
	LDI  R30,LOW(0)
	MOV  R10,R30
	MOV  R11,R30
	RET
; .FEND
_lcd_putchar:
; .FSTART _lcd_putchar
	ST   -Y,R26
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BREQ _0x2000005
	CP   R11,R13
	BRLO _0x2000004
_0x2000005:
	LDI  R30,LOW(0)
	ST   -Y,R30
	INC  R10
	MOV  R26,R10
	RCALL _lcd_gotoxy
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BRNE _0x2000007
	JMP  _0x2080003
_0x2000007:
_0x2000004:
	INC  R11
	SBI  0x15,0
	LD   R26,Y
	RCALL __lcd_write_data
	CBI  0x15,0
	JMP  _0x2080003
; .FEND
_lcd_puts:
; .FSTART _lcd_puts
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
_0x2000008:
	CALL SUBOPT_0x5
	BREQ _0x200000A
	MOV  R26,R17
	RCALL _lcd_putchar
	RJMP _0x2000008
_0x200000A:
	JMP  _0x2080002
; .FEND
_lcd_init:
; .FSTART _lcd_init
	ST   -Y,R26
	IN   R30,0x14
	ORI  R30,LOW(0xF0)
	OUT  0x14,R30
	SBI  0x14,2
	SBI  0x14,0
	SBI  0x14,1
	CBI  0x15,2
	CBI  0x15,0
	CBI  0x15,1
	LDD  R13,Y+0
	LD   R30,Y
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G100,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G100,3
	LDI  R26,LOW(20)
	LDI  R27,0
	CALL _delay_ms
	CALL SUBOPT_0x6
	CALL SUBOPT_0x6
	CALL SUBOPT_0x6
	LDI  R26,LOW(32)
	RCALL __lcd_write_nibble_G100
	__DELAY_USW 200
	LDI  R26,LOW(40)
	RCALL __lcd_write_data
	LDI  R26,LOW(4)
	RCALL __lcd_write_data
	LDI  R26,LOW(133)
	RCALL __lcd_write_data
	LDI  R26,LOW(6)
	RCALL __lcd_write_data
	RCALL _lcd_clear
	JMP  _0x2080003
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
_getchar:
; .FSTART _getchar
getchar0:
     sbis usr,rxc
     rjmp getchar0
     in   r30,udr
	RET
; .FEND
_putchar:
; .FSTART _putchar
	ST   -Y,R26
putchar0:
     sbis usr,udre
     rjmp putchar0
     ld   r30,y
     out  udr,r30
_0x2080004:
_0x2080003:
	ADIW R28,1
	RET
; .FEND
_puts:
; .FSTART _puts
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
_0x2020003:
	CALL SUBOPT_0x5
	BREQ _0x2020005
	MOV  R26,R17
	RCALL _putchar
	RJMP _0x2020003
_0x2020005:
	LDI  R26,LOW(10)
	RCALL _putchar
_0x2080002:
	LDD  R17,Y+0
	ADIW R28,3
	RET
; .FEND
_put_buff_G101:
; .FSTART _put_buff_G101
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	CALL __GETW1P
	SBIW R30,0
	BREQ _0x2020010
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,4
	CALL __GETW1P
	MOVW R16,R30
	SBIW R30,0
	BREQ _0x2020012
	__CPWRN 16,17,2
	BRLO _0x2020013
	MOVW R30,R16
	SBIW R30,1
	MOVW R16,R30
	__PUTW1SNS 2,4
_0x2020012:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	SBIW R30,1
	LDD  R26,Y+4
	STD  Z+0,R26
_0x2020013:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CALL __GETW1P
	TST  R31
	BRMI _0x2020014
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
_0x2020014:
	RJMP _0x2020015
_0x2020010:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	ST   X+,R30
	ST   X,R31
_0x2020015:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,5
	RET
; .FEND
__print_G101:
; .FSTART __print_G101
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,6
	CALL __SAVELOCR6
	LDI  R17,0
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
_0x2020016:
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	ADIW R30,1
	STD  Y+18,R30
	STD  Y+18+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+2
	RJMP _0x2020018
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x202001C
	CPI  R18,37
	BRNE _0x202001D
	LDI  R17,LOW(1)
	RJMP _0x202001E
_0x202001D:
	CALL SUBOPT_0x7
_0x202001E:
	RJMP _0x202001B
_0x202001C:
	CPI  R30,LOW(0x1)
	BRNE _0x202001F
	CPI  R18,37
	BRNE _0x2020020
	CALL SUBOPT_0x7
	RJMP _0x20200CC
_0x2020020:
	LDI  R17,LOW(2)
	LDI  R20,LOW(0)
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x2020021
	LDI  R16,LOW(1)
	RJMP _0x202001B
_0x2020021:
	CPI  R18,43
	BRNE _0x2020022
	LDI  R20,LOW(43)
	RJMP _0x202001B
_0x2020022:
	CPI  R18,32
	BRNE _0x2020023
	LDI  R20,LOW(32)
	RJMP _0x202001B
_0x2020023:
	RJMP _0x2020024
_0x202001F:
	CPI  R30,LOW(0x2)
	BRNE _0x2020025
_0x2020024:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x2020026
	ORI  R16,LOW(128)
	RJMP _0x202001B
_0x2020026:
	RJMP _0x2020027
_0x2020025:
	CPI  R30,LOW(0x3)
	BREQ PC+2
	RJMP _0x202001B
_0x2020027:
	CPI  R18,48
	BRLO _0x202002A
	CPI  R18,58
	BRLO _0x202002B
_0x202002A:
	RJMP _0x2020029
_0x202002B:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x202001B
_0x2020029:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x202002F
	CALL SUBOPT_0x8
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	LDD  R26,Z+4
	ST   -Y,R26
	CALL SUBOPT_0x9
	RJMP _0x2020030
_0x202002F:
	CPI  R30,LOW(0x73)
	BRNE _0x2020032
	CALL SUBOPT_0x8
	CALL SUBOPT_0xA
	CALL _strlen
	MOV  R17,R30
	RJMP _0x2020033
_0x2020032:
	CPI  R30,LOW(0x70)
	BRNE _0x2020035
	CALL SUBOPT_0x8
	CALL SUBOPT_0xA
	CALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x2020033:
	ORI  R16,LOW(2)
	ANDI R16,LOW(127)
	LDI  R19,LOW(0)
	RJMP _0x2020036
_0x2020035:
	CPI  R30,LOW(0x64)
	BREQ _0x2020039
	CPI  R30,LOW(0x69)
	BRNE _0x202003A
_0x2020039:
	ORI  R16,LOW(4)
	RJMP _0x202003B
_0x202003A:
	CPI  R30,LOW(0x75)
	BRNE _0x202003C
_0x202003B:
	LDI  R30,LOW(_tbl10_G101*2)
	LDI  R31,HIGH(_tbl10_G101*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(5)
	RJMP _0x202003D
_0x202003C:
	CPI  R30,LOW(0x58)
	BRNE _0x202003F
	ORI  R16,LOW(8)
	RJMP _0x2020040
_0x202003F:
	CPI  R30,LOW(0x78)
	BREQ PC+2
	RJMP _0x2020071
_0x2020040:
	LDI  R30,LOW(_tbl16_G101*2)
	LDI  R31,HIGH(_tbl16_G101*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(4)
_0x202003D:
	SBRS R16,2
	RJMP _0x2020042
	CALL SUBOPT_0x8
	CALL SUBOPT_0xB
	LDD  R26,Y+11
	TST  R26
	BRPL _0x2020043
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	CALL __ANEGW1
	STD  Y+10,R30
	STD  Y+10+1,R31
	LDI  R20,LOW(45)
_0x2020043:
	CPI  R20,0
	BREQ _0x2020044
	SUBI R17,-LOW(1)
	RJMP _0x2020045
_0x2020044:
	ANDI R16,LOW(251)
_0x2020045:
	RJMP _0x2020046
_0x2020042:
	CALL SUBOPT_0x8
	CALL SUBOPT_0xB
_0x2020046:
_0x2020036:
	SBRC R16,0
	RJMP _0x2020047
_0x2020048:
	CP   R17,R21
	BRSH _0x202004A
	SBRS R16,7
	RJMP _0x202004B
	SBRS R16,2
	RJMP _0x202004C
	ANDI R16,LOW(251)
	MOV  R18,R20
	SUBI R17,LOW(1)
	RJMP _0x202004D
_0x202004C:
	LDI  R18,LOW(48)
_0x202004D:
	RJMP _0x202004E
_0x202004B:
	LDI  R18,LOW(32)
_0x202004E:
	CALL SUBOPT_0x7
	SUBI R21,LOW(1)
	RJMP _0x2020048
_0x202004A:
_0x2020047:
	MOV  R19,R17
	SBRS R16,1
	RJMP _0x202004F
_0x2020050:
	CPI  R19,0
	BREQ _0x2020052
	SBRS R16,3
	RJMP _0x2020053
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LPM  R18,Z+
	STD  Y+6,R30
	STD  Y+6+1,R31
	RJMP _0x2020054
_0x2020053:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LD   R18,X+
	STD  Y+6,R26
	STD  Y+6+1,R27
_0x2020054:
	CALL SUBOPT_0x7
	CPI  R21,0
	BREQ _0x2020055
	SUBI R21,LOW(1)
_0x2020055:
	SUBI R19,LOW(1)
	RJMP _0x2020050
_0x2020052:
	RJMP _0x2020056
_0x202004F:
_0x2020058:
	LDI  R18,LOW(48)
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	CALL __GETW1PF
	STD  Y+8,R30
	STD  Y+8+1,R31
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,2
	STD  Y+6,R30
	STD  Y+6+1,R31
_0x202005A:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CP   R26,R30
	CPC  R27,R31
	BRLO _0x202005C
	SUBI R18,-LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	SUB  R30,R26
	SBC  R31,R27
	STD  Y+10,R30
	STD  Y+10+1,R31
	RJMP _0x202005A
_0x202005C:
	CPI  R18,58
	BRLO _0x202005D
	SBRS R16,3
	RJMP _0x202005E
	SUBI R18,-LOW(7)
	RJMP _0x202005F
_0x202005E:
	SUBI R18,-LOW(39)
_0x202005F:
_0x202005D:
	SBRC R16,4
	RJMP _0x2020061
	CPI  R18,49
	BRSH _0x2020063
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,1
	BRNE _0x2020062
_0x2020063:
	RJMP _0x20200CD
_0x2020062:
	CP   R21,R19
	BRLO _0x2020067
	SBRS R16,0
	RJMP _0x2020068
_0x2020067:
	RJMP _0x2020066
_0x2020068:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x2020069
	LDI  R18,LOW(48)
_0x20200CD:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x202006A
	ANDI R16,LOW(251)
	ST   -Y,R20
	CALL SUBOPT_0x9
	CPI  R21,0
	BREQ _0x202006B
	SUBI R21,LOW(1)
_0x202006B:
_0x202006A:
_0x2020069:
_0x2020061:
	CALL SUBOPT_0x7
	CPI  R21,0
	BREQ _0x202006C
	SUBI R21,LOW(1)
_0x202006C:
_0x2020066:
	SUBI R19,LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,2
	BRLO _0x2020059
	RJMP _0x2020058
_0x2020059:
_0x2020056:
	SBRS R16,0
	RJMP _0x202006D
_0x202006E:
	CPI  R21,0
	BREQ _0x2020070
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	CALL SUBOPT_0x9
	RJMP _0x202006E
_0x2020070:
_0x202006D:
_0x2020071:
_0x2020030:
_0x20200CC:
	LDI  R17,LOW(0)
_0x202001B:
	RJMP _0x2020016
_0x2020018:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	CALL __GETW1P
	CALL __LOADLOCR6
	ADIW R28,20
	RET
; .FEND
_sprintf:
; .FSTART _sprintf
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	CALL __SAVELOCR4
	CALL SUBOPT_0xC
	SBIW R30,0
	BRNE _0x2020072
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x2080001
_0x2020072:
	MOVW R26,R28
	ADIW R26,6
	CALL __ADDW2R15
	MOVW R16,R26
	CALL SUBOPT_0xC
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R30,LOW(0)
	STD  Y+8,R30
	STD  Y+8+1,R30
	MOVW R26,R28
	ADIW R26,10
	CALL __ADDW2R15
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(_put_buff_G101)
	LDI  R31,HIGH(_put_buff_G101)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,10
	RCALL __print_G101
	MOVW R18,R30
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
	MOVW R30,R18
_0x2080001:
	CALL __LOADLOCR4
	ADIW R28,10
	POP  R15
	RET
; .FEND

	.CSEG

	.CSEG
_strlen:
; .FSTART _strlen
	ST   -Y,R27
	ST   -Y,R26
    ld   r26,y+
    ld   r27,y+
    clr  r30
    clr  r31
strlen0:
    ld   r22,x+
    tst  r22
    breq strlen1
    adiw r30,1
    rjmp strlen0
strlen1:
    ret
; .FEND
_strlenf:
; .FSTART _strlenf
	ST   -Y,R27
	ST   -Y,R26
    clr  r26
    clr  r27
    ld   r30,y+
    ld   r31,y+
strlenf0:
	lpm  r0,z+
    tst  r0
    breq strlenf1
    adiw r26,1
    rjmp strlenf0
strlenf1:
    movw r30,r26
    ret
; .FEND

	.DSEG
_rx_buffer:
	.BYTE 0x8
_tx_buffer:
	.BYTE 0x8
__base_y_G100:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x0:
	LDI  R30,LOW(9600)
	LDI  R31,HIGH(9600)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1:
	CALL _getchar
	MOV  R17,R30
	MOV  R26,R17
	JMP  _putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2:
	CALL _getchar_
	MOV  R17,R30
	MOV  R26,R17
	JMP  _putchar_

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x3:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	MOVW R26,R28
	ADIW R26,8
	ADD  R26,R30
	ADC  R27,R31
	LD   R26,X
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4:
	CALL __lcd_write_data
	LDI  R26,LOW(3)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x5:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x6:
	LDI  R26,LOW(48)
	CALL __lcd_write_nibble_G100
	__DELAY_USW 200
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x7:
	ST   -Y,R18
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x8:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x9:
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xA:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xB:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+10,R30
	STD  Y+10+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xC:
	MOVW R26,R28
	ADIW R26,12
	CALL __ADDW2R15
	CALL __GETW1P
	RET


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x7D0
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__ADDW2R15:
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
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

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
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

__MULW12:
	RCALL __CHKSIGNW
	RCALL __MULW12U
	BRTC __MULW121
	RCALL __ANEGW1
__MULW121:
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__DIVW21:
	RCALL __CHKSIGNW
	RCALL __DIVW21U
	BRTC __DIVW211
	RCALL __ANEGW1
__DIVW211:
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

__DIVD21:
	RCALL __CHKSIGND
	RCALL __DIVD21U
	BRTC __DIVD211
	RCALL __ANEGD1
__DIVD211:
	RET

__CHKSIGNW:
	CLT
	SBRS R31,7
	RJMP __CHKSW1
	RCALL __ANEGW1
	SET
__CHKSW1:
	SBRS R27,7
	RJMP __CHKSW2
	COM  R26
	COM  R27
	ADIW R26,1
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
	RET

__CHKSIGND:
	CLT
	SBRS R23,7
	RJMP __CHKSD1
	RCALL __ANEGD1
	SET
__CHKSD1:
	SBRS R25,7
	RJMP __CHKSD2
	CLR  R0
	COM  R26
	COM  R27
	COM  R24
	COM  R25
	ADIW R26,1
	ADC  R24,R0
	ADC  R25,R0
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSD2:
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

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

__INITLOCB:
__INITLOCW:
	ADD  R26,R28
	ADC  R27,R29
__INITLOC0:
	LPM  R0,Z+
	ST   X+,R0
	DEC  R24
	BRNE __INITLOC0
	RET

;END OF CODE MARKER
__END_OF_CODE:
