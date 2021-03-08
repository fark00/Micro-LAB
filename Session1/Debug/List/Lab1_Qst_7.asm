
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
;Global 'const' stored in FLASH: No
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

_0x3:
	.DB  0x3F,0x6,0x5B,0x4F,0x66,0x6D,0x7D,0x7
	.DB  0x7F,0x6F
_0x30:
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0

__GLOBAL_INI_TBL:
	.DW  0x0A
	.DW  _array
	.DW  _0x3*2

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
;/*
; * Lab1_Qst_7.c
; *
; * Created: 3/1/2021 12:30:51 PM
; * Author: farkoo
; */
;
;#include <io.h>
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
;#include <delay.h>
;
;char array[]={0x3F,0x06,0x5B,0x4F,0x66,0x6D,0x7D,0x07,0x7F,0x6F};

	.DSEG
;
;void func1();
;void func2();
;void func3();
;void func4();
;void func5();
;void func6();
;
;void main(void)
; 0000 0015 {

	.CSEG
_main:
; .FSTART _main
; 0000 0016     func1();
	RCALL _func1
; 0000 0017     func2();
	RCALL _func2
; 0000 0018     func4();
	RCALL _func4
; 0000 0019     while (1){
_0x4:
; 0000 001A         func3();
	RCALL _func3
; 0000 001B         func5();
	RCALL _func5
; 0000 001C         func6();
	RCALL _func6
; 0000 001D     }
	RJMP _0x4
; 0000 001E }
_0x7:
	RJMP _0x7
; .FEND
;
;void func1(){
; 0000 0020 void func1(){
_func1:
; .FSTART _func1
; 0000 0021     char i;
; 0000 0022     DDRB = 0xFF;
	ST   -Y,R17
;	i -> R17
	LDI  R30,LOW(255)
	OUT  0x17,R30
; 0000 0023     for(i = 0; i < 4; i++){
	LDI  R17,LOW(0)
_0x9:
	CPI  R17,4
	BRSH _0xA
; 0000 0024                     PORTB = 0xFF;
	LDI  R30,LOW(255)
	OUT  0x18,R30
; 0000 0025                     delay_ms(500);
	RCALL SUBOPT_0x0
; 0000 0026                     PORTB = 0x00;
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 0027                     delay_ms(500);
	RCALL SUBOPT_0x0
; 0000 0028     }
	SUBI R17,-1
	RJMP _0x9
_0xA:
; 0000 0029     return;
	LD   R17,Y+
	RET
; 0000 002A }
; .FEND
;void func2(){
; 0000 002B void func2(){
_func2:
; .FSTART _func2
; 0000 002C     int counter;
; 0000 002D     DDRB = 0xFF;
	ST   -Y,R17
	ST   -Y,R16
;	counter -> R16,R17
	LDI  R30,LOW(255)
	OUT  0x17,R30
; 0000 002E     PORTB = 0x80;
	LDI  R30,LOW(128)
	OUT  0x18,R30
; 0000 002F     counter = 0;
	__GETWRN 16,17,0
; 0000 0030     while(counter != 3000){
_0xB:
	LDI  R30,LOW(3000)
	LDI  R31,HIGH(3000)
	CP   R30,R16
	CPC  R31,R17
	BREQ _0xD
; 0000 0031               PORTB = PORTB>>1;
	IN   R30,0x18
	LDI  R31,0
	ASR  R31
	ROR  R30
	OUT  0x18,R30
; 0000 0032               if(PORTB == 0x00)
	IN   R30,0x18
	CPI  R30,0
	BRNE _0xE
; 0000 0033                 PORTB =  0x80;
	LDI  R30,LOW(128)
	OUT  0x18,R30
; 0000 0034               delay_ms(50);
_0xE:
	LDI  R26,LOW(50)
	LDI  R27,0
	CALL _delay_ms
; 0000 0035               counter += 50;
	__ADDWRN 16,17,50
; 0000 0036     }
	RJMP _0xB
_0xD:
; 0000 0037     return;
	RJMP _0x2000001
; 0000 0038 }
; .FEND
;void func3(){
; 0000 0039 void func3(){
_func3:
; .FSTART _func3
; 0000 003A     DDRA = 0x00;
	LDI  R30,LOW(0)
	OUT  0x1A,R30
; 0000 003B     DDRB = 0xFF;
	LDI  R30,LOW(255)
	OUT  0x17,R30
; 0000 003C     PORTB = PINA;
	IN   R30,0x19
	OUT  0x18,R30
; 0000 003D     return;
	RET
; 0000 003E }
; .FEND
;void func4(){
; 0000 003F void func4(){
_func4:
; .FSTART _func4
; 0000 0040     int i = 9;
; 0000 0041     DDRC = 0xFF;
	ST   -Y,R17
	ST   -Y,R16
;	i -> R16,R17
	__GETWRN 16,17,9
	LDI  R30,LOW(255)
	OUT  0x14,R30
; 0000 0042     DDRD = 0x0F;
	LDI  R30,LOW(15)
	OUT  0x11,R30
; 0000 0043     PORTD = 0x00;
	LDI  R30,LOW(0)
	OUT  0x12,R30
; 0000 0044      while(i !=-1){
_0xF:
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	CP   R30,R16
	CPC  R31,R17
	BREQ _0x11
; 0000 0045         PORTC = array[i];
	LDI  R26,LOW(_array)
	LDI  R27,HIGH(_array)
	ADD  R26,R16
	ADC  R27,R17
	LD   R30,X
	OUT  0x15,R30
; 0000 0046         delay_ms(500);
	RCALL SUBOPT_0x0
; 0000 0047         i--;
	__SUBWRN 16,17,1
; 0000 0048 
; 0000 0049     }
	RJMP _0xF
_0x11:
; 0000 004A }
_0x2000001:
	LD   R16,Y+
	LD   R17,Y+
	RET
; .FEND
;void func5(){
; 0000 004B void func5(){
_func5:
; .FSTART _func5
; 0000 004C     unsigned int i = 0;
; 0000 004D     unsigned int number=0;
; 0000 004E     unsigned int temp = 0;
; 0000 004F     unsigned int sadghan=0;
; 0000 0050     unsigned int dahghan=0;
; 0000 0051     unsigned int yekan=0;
; 0000 0052     unsigned int decimal=0;
; 0000 0053     DDRA=0x00;
	SBIW R28,8
	LDI  R30,LOW(0)
	ST   Y,R30
	STD  Y+1,R30
	STD  Y+2,R30
	STD  Y+3,R30
	STD  Y+4,R30
	STD  Y+5,R30
	STD  Y+6,R30
	STD  Y+7,R30
	RCALL SUBOPT_0x1
;	i -> R16,R17
;	number -> R18,R19
;	temp -> R20,R21
;	sadghan -> Y+12
;	dahghan -> Y+10
;	yekan -> Y+8
;	decimal -> Y+6
; 0000 0054     DDRC=0xFF;
; 0000 0055     DDRD=0x00;
; 0000 0056     number= PINA;
; 0000 0057     temp = number * 10;
; 0000 0058     while(number > 0){
_0x12:
	CLR  R0
	CP   R0,R18
	CPC  R0,R19
	BRLO PC+2
	RJMP _0x14
; 0000 0059         number = temp;
	MOVW R18,R20
; 0000 005A         if(number >= 1000){
	__CPWRN 18,19,1000
	BRLO _0x15
; 0000 005B             decimal = number % 10;
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0x3
; 0000 005C             number = number / 10;
; 0000 005D             yekan = number % 10;
	RCALL SUBOPT_0x4
; 0000 005E             number = number / 10;
; 0000 005F             dahghan = number % 10;
	STD  Y+10,R30
	STD  Y+10+1,R31
; 0000 0060             number = number / 10;
	RCALL SUBOPT_0x5
; 0000 0061             sadghan = number % 10;
	STD  Y+12,R30
	STD  Y+12+1,R31
; 0000 0062         }
; 0000 0063         else if(number >=100) {
	RJMP _0x16
_0x15:
	__CPWRN 18,19,100
	BRLO _0x17
; 0000 0064             decimal = number % 10;
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0x3
; 0000 0065             number = number / 10;
; 0000 0066             yekan = number % 10;
	RCALL SUBOPT_0x4
; 0000 0067             number = number / 10;
; 0000 0068             dahghan = number % 10;
	STD  Y+10,R30
	STD  Y+10+1,R31
; 0000 0069             sadghan = 0;
	RJMP _0x53
; 0000 006A         }
; 0000 006B         else if(number >= 10){
_0x17:
	__CPWRN 18,19,10
	BRLO _0x19
; 0000 006C             decimal = number % 10;
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0x3
; 0000 006D             number = number / 10;
; 0000 006E             yekan = number % 10;
	STD  Y+8,R30
	STD  Y+8+1,R31
; 0000 006F             dahghan = 0;
	RJMP _0x54
; 0000 0070             sadghan = 0;
; 0000 0071         }
; 0000 0072         else{
_0x19:
; 0000 0073             decimal = number % 10;
	RCALL SUBOPT_0x2
	STD  Y+6,R30
	STD  Y+6+1,R31
; 0000 0074             yekan = 0;
	LDI  R30,LOW(0)
	STD  Y+8,R30
	STD  Y+8+1,R30
; 0000 0075             dahghan = 0;
_0x54:
	LDI  R30,LOW(0)
	STD  Y+10,R30
	STD  Y+10+1,R30
; 0000 0076             sadghan = 0;
_0x53:
	LDI  R30,LOW(0)
	STD  Y+12,R30
	STD  Y+12+1,R30
; 0000 0077 
; 0000 0078         }
_0x16:
; 0000 0079         for(i = 0; i < 25; i = i + 1)
	__GETWRN 16,17,0
_0x1C:
	__CPWRN 16,17,25
	BRSH _0x1D
; 0000 007A         {
; 0000 007B             DDRD.3 = 1;
	SBI  0x11,3
; 0000 007C             PORTC = array[decimal];
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	RCALL SUBOPT_0x6
; 0000 007D             delay_ms(1);
; 0000 007E 
; 0000 007F             DDRD.3 = 0;
	CBI  0x11,3
; 0000 0080             DDRD.2 = 1;
	SBI  0x11,2
; 0000 0081             PORTC = array[yekan] + 0b10000000;
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	RCALL SUBOPT_0x7
; 0000 0082             delay_ms(1);
; 0000 0083 
; 0000 0084             DDRD.2 = 0;
; 0000 0085             DDRD.1 = 1;
; 0000 0086             PORTC = array[dahghan];
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	RCALL SUBOPT_0x6
; 0000 0087             delay_ms(1);
; 0000 0088 
; 0000 0089             DDRD.1 = 0;
	CBI  0x11,1
; 0000 008A             DDRD.0 = 1;
	SBI  0x11,0
; 0000 008B             PORTC = array[sadghan];
	LDD  R30,Y+12
	LDD  R31,Y+12+1
	RCALL SUBOPT_0x6
; 0000 008C             delay_ms(1);
; 0000 008D             DDRD.0 = 0;
	CBI  0x11,0
; 0000 008E         }
	__ADDWRN 16,17,1
	RJMP _0x1C
_0x1D:
; 0000 008F 
; 0000 0090         DDRD.0 = 0;
	CBI  0x11,0
; 0000 0091         temp = temp - 2;
	__SUBWRN 20,21,2
; 0000 0092     }
	RJMP _0x12
_0x14:
; 0000 0093 
; 0000 0094 }
	CALL __LOADLOCR6
	ADIW R28,14
	RET
; .FEND
;void func6(){
; 0000 0095 void func6(){
_func6:
; .FSTART _func6
; 0000 0096     unsigned int i = 0;
; 0000 0097     unsigned int number=0;
; 0000 0098     unsigned int temp = 0;
; 0000 0099     unsigned int sadghan=0;
; 0000 009A     unsigned int dahghan=0;
; 0000 009B     unsigned int yekan=0;
; 0000 009C     unsigned int decimal=0;
; 0000 009D 
; 0000 009E     unsigned int sadghan_tmp=0;
; 0000 009F     unsigned int dahghan_tmp=0;
; 0000 00A0     unsigned int yekan_tmp=0;
; 0000 00A1     unsigned int decimal_tmp=0;
; 0000 00A2     unsigned int number_tmp = 0;
; 0000 00A3 
; 0000 00A4     DDRA=0x00;
	SBIW R28,18
	LDI  R24,18
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	LDI  R30,LOW(_0x30*2)
	LDI  R31,HIGH(_0x30*2)
	CALL __INITLOCB
	RCALL SUBOPT_0x1
;	i -> R16,R17
;	number -> R18,R19
;	temp -> R20,R21
;	sadghan -> Y+22
;	dahghan -> Y+20
;	yekan -> Y+18
;	decimal -> Y+16
;	sadghan_tmp -> Y+14
;	dahghan_tmp -> Y+12
;	yekan_tmp -> Y+10
;	decimal_tmp -> Y+8
;	number_tmp -> Y+6
; 0000 00A5     DDRC=0xFF;
; 0000 00A6     DDRD=0x00;
; 0000 00A7     number= PINA;
; 0000 00A8     temp = number * 10;
; 0000 00A9 
; 0000 00AA     number_tmp = temp;
	__PUTWSR 20,21,6
; 0000 00AB     decimal_tmp = number_tmp % 10;
	RCALL SUBOPT_0x8
	CALL __MODW21U
	STD  Y+8,R30
	STD  Y+8+1,R31
; 0000 00AC     number_tmp = number_tmp / 10;
	RCALL SUBOPT_0x8
	RCALL SUBOPT_0x9
; 0000 00AD     yekan_tmp = number_tmp % 10;
	CALL __MODW21U
	STD  Y+10,R30
	STD  Y+10+1,R31
; 0000 00AE     number_tmp = number_tmp / 10;
	RCALL SUBOPT_0x8
	RCALL SUBOPT_0x9
; 0000 00AF     dahghan_tmp = number_tmp % 10;
	CALL __MODW21U
	STD  Y+12,R30
	STD  Y+12+1,R31
; 0000 00B0     number_tmp = number_tmp / 10;
	RCALL SUBOPT_0x8
	RCALL SUBOPT_0x9
; 0000 00B1     sadghan_tmp = number_tmp % 10;
	CALL __MODW21U
	STD  Y+14,R30
	STD  Y+14+1,R31
; 0000 00B2 
; 0000 00B3     while(number > 0){
_0x31:
	CLR  R0
	CP   R0,R18
	CPC  R0,R19
	BRLO PC+2
	RJMP _0x33
; 0000 00B4         number = temp;
	MOVW R18,R20
; 0000 00B5         if(number >= 1000){
	__CPWRN 18,19,1000
	BRLO _0x34
; 0000 00B6             decimal = number % 10;
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0xA
; 0000 00B7             number = number / 10;
; 0000 00B8             yekan = number % 10;
	STD  Y+18,R30
	STD  Y+18+1,R31
; 0000 00B9             number = number / 10;
	RCALL SUBOPT_0x5
; 0000 00BA             dahghan = number % 10;
	STD  Y+20,R30
	STD  Y+20+1,R31
; 0000 00BB             number = number / 10;
	RCALL SUBOPT_0x5
; 0000 00BC             sadghan = number % 10;
	STD  Y+22,R30
	STD  Y+22+1,R31
; 0000 00BD         }
; 0000 00BE         else if(number >=100) {
	RJMP _0x35
_0x34:
	__CPWRN 18,19,100
	BRLO _0x36
; 0000 00BF             decimal = number % 10;
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0xA
; 0000 00C0             number = number / 10;
; 0000 00C1             yekan = number % 10;
	STD  Y+18,R30
	STD  Y+18+1,R31
; 0000 00C2             number = number / 10;
	RCALL SUBOPT_0x5
; 0000 00C3             dahghan = number % 10;
	STD  Y+20,R30
	STD  Y+20+1,R31
; 0000 00C4             sadghan = 0;
	RJMP _0x55
; 0000 00C5         }
; 0000 00C6         else if(number >= 10){
_0x36:
	__CPWRN 18,19,10
	BRLO _0x38
; 0000 00C7             decimal = number % 10;
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0xA
; 0000 00C8             number = number / 10;
; 0000 00C9             yekan = number % 10;
	STD  Y+18,R30
	STD  Y+18+1,R31
; 0000 00CA             dahghan = 0;
	RJMP _0x56
; 0000 00CB             sadghan = 0;
; 0000 00CC         }
; 0000 00CD         else{
_0x38:
; 0000 00CE             decimal = number % 10;
	RCALL SUBOPT_0x2
	STD  Y+16,R30
	STD  Y+16+1,R31
; 0000 00CF             yekan = 0;
	LDI  R30,LOW(0)
	STD  Y+18,R30
	STD  Y+18+1,R30
; 0000 00D0             dahghan = 0;
_0x56:
	LDI  R30,LOW(0)
	STD  Y+20,R30
	STD  Y+20+1,R30
; 0000 00D1             sadghan = 0;
_0x55:
	LDI  R30,LOW(0)
	STD  Y+22,R30
	STD  Y+22+1,R30
; 0000 00D2 
; 0000 00D3         }
_0x35:
; 0000 00D4 
; 0000 00D5         for(i = 0; i < 25; i = i + 1)
	__GETWRN 16,17,0
_0x3B:
	__CPWRN 16,17,25
	BRSH _0x3C
; 0000 00D6         {
; 0000 00D7             DDRD.3 = 1;
	SBI  0x11,3
; 0000 00D8             PORTC = array[decimal];
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	RCALL SUBOPT_0x6
; 0000 00D9             delay_ms(1);
; 0000 00DA 
; 0000 00DB             DDRD.3 = 0;
	CBI  0x11,3
; 0000 00DC             DDRD.2 = 1;
	SBI  0x11,2
; 0000 00DD             PORTC = array[yekan] + 0b10000000;
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	RCALL SUBOPT_0x7
; 0000 00DE             delay_ms(1);
; 0000 00DF 
; 0000 00E0             DDRD.2 = 0;
; 0000 00E1             DDRD.1 = 1;
; 0000 00E2             PORTC = array[dahghan];
	LDD  R30,Y+20
	LDD  R31,Y+20+1
	RCALL SUBOPT_0x6
; 0000 00E3             delay_ms(1);
; 0000 00E4 
; 0000 00E5             DDRD.1 = 0;
	CBI  0x11,1
; 0000 00E6             DDRD.0 = 1;
	SBI  0x11,0
; 0000 00E7             PORTC = array[sadghan];
	LDD  R30,Y+22
	LDD  R31,Y+22+1
	RCALL SUBOPT_0x6
; 0000 00E8             delay_ms(1);
; 0000 00E9             DDRD.0 = 0;
	CBI  0x11,0
; 0000 00EA         }
	__ADDWRN 16,17,1
	RJMP _0x3B
_0x3C:
; 0000 00EB 
; 0000 00EC         DDRD.0 = 0;
	CBI  0x11,0
; 0000 00ED         temp = temp - 2;
	__SUBWRN 20,21,2
; 0000 00EE 
; 0000 00EF         if(PIND.7 == 0)
	SBIC 0x10,7
	RJMP _0x4F
; 0000 00F0         {
; 0000 00F1             temp = sadghan_tmp * 1000 + dahghan * 100 + yekan * 10 + decimal - 2;
	RCALL SUBOPT_0xB
	RCALL SUBOPT_0xC
; 0000 00F2         }
; 0000 00F3         if(PIND.6 == 0)
_0x4F:
	SBIC 0x10,6
	RJMP _0x50
; 0000 00F4         {
; 0000 00F5             temp = sadghan * 1000 + dahghan_tmp * 100 + yekan * 10 + decimal - 2;
	LDD  R30,Y+22
	LDD  R31,Y+22+1
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	CALL __MULW12U
	__PUTW1R 23,24
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LDI  R30,LOW(100)
	CALL __MULB1W2U
	__ADDWRR 23,24,30,31
	RCALL SUBOPT_0xC
; 0000 00F6         }
; 0000 00F7         if(PIND.5 == 0)
_0x50:
	SBIC 0x10,5
	RJMP _0x51
; 0000 00F8         {
; 0000 00F9             temp = sadghan_tmp * 1000 + dahghan * 100 + yekan_tmp * 10 + decimal - 2;
	RCALL SUBOPT_0xB
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	LDI  R30,LOW(10)
	CALL __MULB1W2U
	ADD  R30,R23
	ADC  R31,R24
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADD  R26,R30
	ADC  R27,R31
	SBIW R26,2
	MOVW R20,R26
; 0000 00FA         }
; 0000 00FB         if(PIND.4 == 0)
_0x51:
	SBIC 0x10,4
	RJMP _0x52
; 0000 00FC         {
; 0000 00FD             temp = sadghan_tmp * 1000 + dahghan * 100 + yekan * 10 + decimal_tmp;
	RCALL SUBOPT_0xB
	LDD  R26,Y+18
	LDD  R27,Y+18+1
	LDI  R30,LOW(10)
	CALL __MULB1W2U
	ADD  R30,R23
	ADC  R31,R24
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	ADD  R30,R26
	ADC  R31,R27
	MOVW R20,R30
; 0000 00FE         }
; 0000 00FF     }
_0x52:
	RJMP _0x31
_0x33:
; 0000 0100 
; 0000 0101 }
	CALL __LOADLOCR6
	ADIW R28,24
	RET
; .FEND

	.DSEG
_array:
	.BYTE 0xA

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x0:
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x1:
	CALL __SAVELOCR6
	__GETWRN 16,17,0
	__GETWRN 18,19,0
	__GETWRN 20,21,0
	LDI  R30,LOW(0)
	OUT  0x1A,R30
	LDI  R30,LOW(255)
	OUT  0x14,R30
	LDI  R30,LOW(0)
	OUT  0x11,R30
	IN   R18,25
	CLR  R19
	__MULBNWRU 18,19,10
	MOVW R20,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 20 TIMES, CODE SIZE REDUCTION:54 WORDS
SUBOPT_0x2:
	MOVW R26,R18
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21U
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x3:
	STD  Y+6,R30
	STD  Y+6+1,R31
	MOVW R26,R18
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21U
	MOVW R18,R30
	RJMP SUBOPT_0x2

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x4:
	STD  Y+8,R30
	STD  Y+8+1,R31
	MOVW R26,R18
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21U
	MOVW R18,R30
	RJMP SUBOPT_0x2

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x5:
	MOVW R26,R18
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21U
	MOVW R18,R30
	RJMP SUBOPT_0x2

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0x6:
	SUBI R30,LOW(-_array)
	SBCI R31,HIGH(-_array)
	LD   R30,Z
	OUT  0x15,R30
	LDI  R26,LOW(1)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x7:
	SUBI R30,LOW(-_array)
	SBCI R31,HIGH(-_array)
	LD   R30,Z
	SUBI R30,-LOW(128)
	OUT  0x15,R30
	LDI  R26,LOW(1)
	LDI  R27,0
	CALL _delay_ms
	CBI  0x11,2
	SBI  0x11,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x8:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x9:
	CALL __DIVW21U
	STD  Y+6,R30
	STD  Y+6+1,R31
	RJMP SUBOPT_0x8

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xA:
	STD  Y+16,R30
	STD  Y+16+1,R31
	RJMP SUBOPT_0x5

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:23 WORDS
SUBOPT_0xB:
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	CALL __MULW12U
	__PUTW1R 23,24
	LDD  R26,Y+20
	LDD  R27,Y+20+1
	LDI  R30,LOW(100)
	CALL __MULB1W2U
	__ADDWRR 23,24,30,31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0xC:
	LDD  R26,Y+18
	LDD  R27,Y+18+1
	LDI  R30,LOW(10)
	CALL __MULB1W2U
	ADD  R30,R23
	ADC  R31,R24
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADD  R26,R30
	ADC  R27,R31
	SBIW R26,2
	MOVW R20,R26
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

__MULW12U:
	MUL  R31,R26
	MOV  R31,R0
	MUL  R30,R27
	ADD  R31,R0
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	RET

__MULB1W2U:
	MOV  R22,R30
	MUL  R22,R26
	MOVW R30,R0
	MUL  R22,R27
	ADD  R31,R0
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

__MODW21U:
	RCALL __DIVW21U
	MOVW R30,R26
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
