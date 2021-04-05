
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

_0x60003:
	.DB  0x3F,0x6,0x5B,0x4F,0x66,0x6D,0x7D,0x7
	.DB  0x7F,0x6F
_0x80003:
	.DB  0x3F,0x6,0x5B,0x4F,0x66,0x6D,0x7D,0x7
	.DB  0x7F,0x6F

__GLOBAL_INI_TBL:
	.DW  0x0A
	.DW  _array2
	.DW  _0x60003*2

	.DW  0x0A
	.DW  _array
	.DW  _0x80003*2

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
;void func1(char num, char port, int ms_delay){
; 0000 0003 void func1(char num, char port, int ms_delay){

	.CSEG
_func1:
; .FSTART _func1
; 0000 0004     char i;
; 0000 0005     switch(port){
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
;	num -> Y+4
;	port -> Y+3
;	ms_delay -> Y+1
;	i -> R17
	LDD  R30,Y+3
	CALL SUBOPT_0x0
; 0000 0006         case portA:
	BRNE _0x6
; 0000 0007             DDRA = 0xFF;
	LDI  R30,LOW(255)
	OUT  0x1A,R30
; 0000 0008             break;
	RJMP _0x5
; 0000 0009         case portB:
_0x6:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BREQ _0xE
; 0000 000A             DDRB = 0xFF;
; 0000 000B             break;
; 0000 000C         case portC:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x8
; 0000 000D             DDRC = 0xFF;
	LDI  R30,LOW(255)
	OUT  0x14,R30
; 0000 000E             break;
	RJMP _0x5
; 0000 000F         case portD:
_0x8:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0xA
; 0000 0010             DDRD = 0xFF;
	LDI  R30,LOW(255)
	OUT  0x11,R30
; 0000 0011             break;
	RJMP _0x5
; 0000 0012         default:
_0xA:
; 0000 0013             DDRB = 0xFF;
_0xE:
	LDI  R30,LOW(255)
	OUT  0x17,R30
; 0000 0014     }
_0x5:
; 0000 0015     for(i = 0; i < num; i++){
	LDI  R17,LOW(0)
_0xC:
	LDD  R30,Y+4
	CP   R17,R30
	BRSH _0xD
; 0000 0016                     PORTB = 0xFF;
	LDI  R30,LOW(255)
	OUT  0x18,R30
; 0000 0017                     delay_ms(ms_delay);
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	CALL _delay_ms
; 0000 0018                     PORTB = 0x00;
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 0019                     delay_ms(ms_delay);
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	CALL _delay_ms
; 0000 001A     }
	SUBI R17,-1
	RJMP _0xC
_0xD:
; 0000 001B     return;
	LDD  R17,Y+0
	JMP  _0x2000002
; 0000 001C }
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
;void func2(char startpos, int ms_duration){
; 0001 0003 void func2(char startpos, int ms_duration){

	.CSEG
_func2:
; .FSTART _func2
; 0001 0004     int counter;
; 0001 0005     DDRB = 0xFF;
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
;	startpos -> Y+4
;	ms_duration -> Y+2
;	counter -> R16,R17
	LDI  R30,LOW(255)
	OUT  0x17,R30
; 0001 0006     switch(startpos){
	LDD  R30,Y+4
	CALL SUBOPT_0x0
; 0001 0007         case 1:
	BRNE _0x20006
; 0001 0008             PORTB = 0x01;
	LDI  R30,LOW(1)
	RJMP _0x20013
; 0001 0009             break;
; 0001 000A          case 2:
_0x20006:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x20007
; 0001 000B             PORTB = 0x02;
	LDI  R30,LOW(2)
	RJMP _0x20013
; 0001 000C             break;
; 0001 000D         case 3:
_0x20007:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x20008
; 0001 000E             PORTB = 0x04;
	LDI  R30,LOW(4)
	RJMP _0x20013
; 0001 000F             break;
; 0001 0010         case 4:
_0x20008:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x20009
; 0001 0011             PORTB = 0x08;
	LDI  R30,LOW(8)
	RJMP _0x20013
; 0001 0012             break;
; 0001 0013          case 5:
_0x20009:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x2000A
; 0001 0014             PORTB = 0x10;
	LDI  R30,LOW(16)
	RJMP _0x20013
; 0001 0015             break;
; 0001 0016          case 6:
_0x2000A:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x2000B
; 0001 0017             PORTB = 0x20;
	LDI  R30,LOW(32)
	RJMP _0x20013
; 0001 0018             break;
; 0001 0019         case 7:
_0x2000B:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x2000C
; 0001 001A             PORTB = 0x40;
	LDI  R30,LOW(64)
	RJMP _0x20013
; 0001 001B             break;
; 0001 001C         case 8:
_0x2000C:
; 0001 001D             PORTB = 0x80;
; 0001 001E             break;
; 0001 001F          default:
; 0001 0020             PORTB = 0x80;
_0x20014:
	LDI  R30,LOW(128)
_0x20013:
	OUT  0x18,R30
; 0001 0021     }
; 0001 0022     counter = 0;
	__GETWRN 16,17,0
; 0001 0023     while(counter != ms_duration){
_0x2000F:
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	CP   R30,R16
	CPC  R31,R17
	BREQ _0x20011
; 0001 0024               if(PORTB == 0x00)
	IN   R30,0x18
	CPI  R30,0
	BRNE _0x20012
; 0001 0025                 PORTB =  0x80;
	LDI  R30,LOW(128)
	OUT  0x18,R30
; 0001 0026               delay_ms(100);
_0x20012:
	LDI  R26,LOW(100)
	LDI  R27,0
	CALL _delay_ms
; 0001 0027               counter += 100;
	__ADDWRN 16,17,100
; 0001 0028               PORTB = PORTB>>1;
	IN   R30,0x18
	LDI  R31,0
	ASR  R31
	ROR  R30
	OUT  0x18,R30
; 0001 0029     }
	RJMP _0x2000F
_0x20011:
; 0001 002A     return;
	JMP  _0x2000001
; 0001 002B }
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
;void func3(char inport, char outport){
; 0002 0003 void func3(char inport, char outport){

	.CSEG
_func3:
; .FSTART _func3
; 0002 0004     char selectin;
; 0002 0005     switch(inport){
	ST   -Y,R26
	ST   -Y,R17
;	inport -> Y+2
;	outport -> Y+1
;	selectin -> R17
	LDD  R30,Y+2
	CALL SUBOPT_0x0
; 0002 0006         case portA:
	BREQ _0x40013
; 0002 0007             DDRA = 0x00;
; 0002 0008             selectin = PINA;
; 0002 0009             break;
; 0002 000A         case portB:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x40007
; 0002 000B             DDRB = 0x00;
	LDI  R30,LOW(0)
	OUT  0x17,R30
; 0002 000C             selectin = PINB;
	IN   R17,22
; 0002 000D             break;
	RJMP _0x40005
; 0002 000E         case portC:
_0x40007:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x40008
; 0002 000F             DDRC = 0x00;
	LDI  R30,LOW(0)
	OUT  0x14,R30
; 0002 0010             selectin = PINC;
	IN   R17,19
; 0002 0011             break;
	RJMP _0x40005
; 0002 0012         case portD:
_0x40008:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x4000A
; 0002 0013             DDRD = 0x00;
	LDI  R30,LOW(0)
	OUT  0x11,R30
; 0002 0014             selectin = PIND;
	IN   R17,16
; 0002 0015             break;
	RJMP _0x40005
; 0002 0016          default:
_0x4000A:
; 0002 0017             DDRA = 0x00;
_0x40013:
	LDI  R30,LOW(0)
	OUT  0x1A,R30
; 0002 0018             selectin = PINA;
	IN   R17,25
; 0002 0019     }
_0x40005:
; 0002 001A     switch(outport){
	LDD  R30,Y+1
	CALL SUBOPT_0x0
; 0002 001B         case portA:
	BRNE _0x4000E
; 0002 001C             DDRA = 0xFF;
	LDI  R30,LOW(255)
	OUT  0x1A,R30
; 0002 001D             PORTA = selectin;
	OUT  0x1B,R17
; 0002 001E             break;
	RJMP _0x4000D
; 0002 001F         case portB:
_0x4000E:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BREQ _0x40014
; 0002 0020             DDRB = 0xFF;
; 0002 0021             PORTB = selectin;
; 0002 0022             break;
; 0002 0023         case portC:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x40010
; 0002 0024             DDRC = 0xFF;
	LDI  R30,LOW(255)
	OUT  0x14,R30
; 0002 0025             PORTC = selectin;
	OUT  0x15,R17
; 0002 0026             break;
	RJMP _0x4000D
; 0002 0027         case portD:
_0x40010:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x40012
; 0002 0028             DDRD = 0xFF;
	LDI  R30,LOW(255)
	OUT  0x11,R30
; 0002 0029             PORTD = selectin;
	OUT  0x12,R17
; 0002 002A             break;
	RJMP _0x4000D
; 0002 002B          default:
_0x40012:
; 0002 002C             DDRB = 0xFF;
_0x40014:
	LDI  R30,LOW(255)
	OUT  0x17,R30
; 0002 002D             PORTB = selectin;
	OUT  0x18,R17
; 0002 002E     }
_0x4000D:
; 0002 002F }
	LDD  R17,Y+0
	ADIW R28,3
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
;char array2[]={0x3F,0x06,0x5B,0x4F,0x66,0x6D,0x7D,0x07,0x7F,0x6F};

	.DSEG
;
;void func4(char direction, char concurrent, char which){
; 0003 0005 void func4(char direction, char concurrent, char which){

	.CSEG
_func4:
; .FSTART _func4
; 0003 0006     int i;
; 0003 0007     DDRC = 0xFF;
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
;	direction -> Y+4
;	concurrent -> Y+3
;	which -> Y+2
;	i -> R16,R17
	LDI  R30,LOW(255)
	OUT  0x14,R30
; 0003 0008     if(concurrent == True)
	LDD  R26,Y+3
	CPI  R26,LOW(0x1)
	BREQ _0x60020
; 0003 0009         DDRD = 0x0F;
; 0003 000A     else if(concurrent == False){
	LDD  R30,Y+3
	CPI  R30,0
	BRNE _0x60006
; 0003 000B         switch(which){
	LDD  R30,Y+2
	CALL SUBOPT_0x0
; 0003 000C             case 1:
	BRNE _0x6000A
; 0003 000D                 DDRD.1 = 1;
	SBI  0x11,1
; 0003 000E                 break;
	RJMP _0x60009
; 0003 000F              case 2:
_0x6000A:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x6000D
; 0003 0010                 DDRD.2 = 1;
	SBI  0x11,2
; 0003 0011                 break;
	RJMP _0x60009
; 0003 0012             case 3:
_0x6000D:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x60010
; 0003 0013                 DDRD.3 = 1;
	SBI  0x11,3
; 0003 0014                 break;
	RJMP _0x60009
; 0003 0015             case 4:
_0x60010:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x60016
; 0003 0016                 DDRD.4 = 1;
	SBI  0x11,4
; 0003 0017                 break;
	RJMP _0x60009
; 0003 0018             default:
_0x60016:
; 0003 0019                 DDRD = 0x0F;
_0x60020:
	LDI  R30,LOW(15)
	OUT  0x11,R30
; 0003 001A         }
_0x60009:
; 0003 001B     }
; 0003 001C     if(direction == inc) {
_0x60006:
	LDD  R26,Y+4
	CPI  R26,LOW(0x1)
	BRNE _0x60017
; 0003 001D         i = 0;
	__GETWRN 16,17,0
; 0003 001E         while(i != 10){
_0x60018:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CP   R30,R16
	CPC  R31,R17
	BREQ _0x6001A
; 0003 001F             PORTC = array2[i];
	CALL SUBOPT_0x1
; 0003 0020             delay_ms(500);
; 0003 0021             i++;
	__ADDWRN 16,17,1
; 0003 0022         }
	RJMP _0x60018
_0x6001A:
; 0003 0023     }
; 0003 0024     else if(direction == dec) {
	RJMP _0x6001B
_0x60017:
	LDD  R30,Y+4
	CPI  R30,0
	BRNE _0x6001C
; 0003 0025         i = 9;
	__GETWRN 16,17,9
; 0003 0026         while(i != -1){
_0x6001D:
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	CP   R30,R16
	CPC  R31,R17
	BREQ _0x6001F
; 0003 0027             PORTC = array2[i];
	CALL SUBOPT_0x1
; 0003 0028             delay_ms(500);
; 0003 0029             i--;
	__SUBWRN 16,17,1
; 0003 002A         }
	RJMP _0x6001D
_0x6001F:
; 0003 002B     }
; 0003 002C }
_0x6001C:
_0x6001B:
_0x2000001:
	LDD  R17,Y+1
	LDD  R16,Y+0
_0x2000002:
	ADIW R28,5
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
;char array[]={0x3F,0x06,0x5B,0x4F,0x66,0x6D,0x7D,0x07,0x7F,0x6F};

	.DSEG
;
;void func5(char step){
; 0004 0005 void func5(char step){

	.CSEG
_func5:
; .FSTART _func5
; 0004 0006 unsigned int i = 0;
; 0004 0007     unsigned int number=0;
; 0004 0008     unsigned int temp = 0;
; 0004 0009     unsigned int sadghan=0;
; 0004 000A     unsigned int dahghan=0;
; 0004 000B     unsigned int yekan=0;
; 0004 000C     unsigned int decimal=0;
; 0004 000D     DDRA=0x00;
	ST   -Y,R26
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
	CALL __SAVELOCR6
;	step -> Y+14
;	i -> R16,R17
;	number -> R18,R19
;	temp -> R20,R21
;	sadghan -> Y+12
;	dahghan -> Y+10
;	yekan -> Y+8
;	decimal -> Y+6
	__GETWRN 16,17,0
	__GETWRN 18,19,0
	__GETWRN 20,21,0
	OUT  0x1A,R30
; 0004 000E     DDRC=0xFF;
	LDI  R30,LOW(255)
	OUT  0x14,R30
; 0004 000F     DDRD=0x00;
	LDI  R30,LOW(0)
	OUT  0x11,R30
; 0004 0010     number= PINA;
	IN   R18,25
	CLR  R19
; 0004 0011     temp = number * 10;
	__MULBNWRU 18,19,10
	MOVW R20,R30
; 0004 0012     while(number > 0){
_0x80004:
	CLR  R0
	CP   R0,R18
	CPC  R0,R19
	BRLO PC+2
	RJMP _0x80006
; 0004 0013         number = temp;
	MOVW R18,R20
; 0004 0014         if(number >= 1000){
	__CPWRN 18,19,1000
	BRLO _0x80007
; 0004 0015             decimal = number % 10;
	CALL SUBOPT_0x2
	CALL SUBOPT_0x3
; 0004 0016             number = number / 10;
; 0004 0017             yekan = number % 10;
	CALL SUBOPT_0x4
; 0004 0018             number = number / 10;
; 0004 0019             dahghan = number % 10;
	STD  Y+10,R30
	STD  Y+10+1,R31
; 0004 001A             number = number / 10;
	MOVW R26,R18
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21U
	MOVW R18,R30
; 0004 001B             sadghan = number % 10;
	CALL SUBOPT_0x2
	STD  Y+12,R30
	STD  Y+12+1,R31
; 0004 001C         }
; 0004 001D         else if(number >=100) {
	RJMP _0x80008
_0x80007:
	__CPWRN 18,19,100
	BRLO _0x80009
; 0004 001E             decimal = number % 10;
	CALL SUBOPT_0x2
	CALL SUBOPT_0x3
; 0004 001F             number = number / 10;
; 0004 0020             yekan = number % 10;
	CALL SUBOPT_0x4
; 0004 0021             number = number / 10;
; 0004 0022             dahghan = number % 10;
	STD  Y+10,R30
	STD  Y+10+1,R31
; 0004 0023             sadghan = 0;
	RJMP _0x80022
; 0004 0024         }
; 0004 0025         else if(number >= 10){
_0x80009:
	__CPWRN 18,19,10
	BRLO _0x8000B
; 0004 0026             decimal = number % 10;
	CALL SUBOPT_0x2
	CALL SUBOPT_0x3
; 0004 0027             number = number / 10;
; 0004 0028             yekan = number % 10;
	STD  Y+8,R30
	STD  Y+8+1,R31
; 0004 0029             dahghan = 0;
	RJMP _0x80023
; 0004 002A             sadghan = 0;
; 0004 002B         }
; 0004 002C         else{
_0x8000B:
; 0004 002D             decimal = number % 10;
	CALL SUBOPT_0x2
	STD  Y+6,R30
	STD  Y+6+1,R31
; 0004 002E             yekan = 0;
	LDI  R30,LOW(0)
	STD  Y+8,R30
	STD  Y+8+1,R30
; 0004 002F             dahghan = 0;
_0x80023:
	LDI  R30,LOW(0)
	STD  Y+10,R30
	STD  Y+10+1,R30
; 0004 0030             sadghan = 0;
_0x80022:
	LDI  R30,LOW(0)
	STD  Y+12,R30
	STD  Y+12+1,R30
; 0004 0031 
; 0004 0032         }
_0x80008:
; 0004 0033         for(i = 0; i < 25; i = i + 1)
	__GETWRN 16,17,0
_0x8000E:
	__CPWRN 16,17,25
	BRSH _0x8000F
; 0004 0034         {
; 0004 0035             DDRD.3 = 1;
	SBI  0x11,3
; 0004 0036             PORTC = array[decimal];
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	CALL SUBOPT_0x5
; 0004 0037             delay_ms(1);
; 0004 0038 
; 0004 0039             DDRD.3 = 0;
	CBI  0x11,3
; 0004 003A             DDRD.2 = 1;
	SBI  0x11,2
; 0004 003B             PORTC = array[yekan] + 0b10000000;
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	SUBI R30,LOW(-_array)
	SBCI R31,HIGH(-_array)
	LD   R30,Z
	SUBI R30,-LOW(128)
	OUT  0x15,R30
; 0004 003C             delay_ms(1);
	LDI  R26,LOW(1)
	LDI  R27,0
	CALL _delay_ms
; 0004 003D 
; 0004 003E             DDRD.2 = 0;
	CBI  0x11,2
; 0004 003F             DDRD.1 = 1;
	SBI  0x11,1
; 0004 0040             PORTC = array[dahghan];
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	CALL SUBOPT_0x5
; 0004 0041             delay_ms(1);
; 0004 0042 
; 0004 0043             DDRD.1 = 0;
	CBI  0x11,1
; 0004 0044             DDRD.0 = 1;
	SBI  0x11,0
; 0004 0045             PORTC = array[sadghan];
	LDD  R30,Y+12
	LDD  R31,Y+12+1
	CALL SUBOPT_0x5
; 0004 0046             delay_ms(1);
; 0004 0047             DDRD.0 = 0;
	CBI  0x11,0
; 0004 0048         }
	__ADDWRN 16,17,1
	RJMP _0x8000E
_0x8000F:
; 0004 0049 
; 0004 004A         DDRD.0 = 0;
	CBI  0x11,0
; 0004 004B         temp = temp - step;
	LDD  R26,Y+14
	CLR  R27
	__SUBWRR 20,21,26,27
; 0004 004C     }
	RJMP _0x80004
_0x80006:
; 0004 004D }
	CALL __LOADLOCR6
	ADIW R28,15
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
;void func6(){
; 0005 0003 void func6(){

	.CSEG
_func6:
; .FSTART _func6
; 0005 0004     func1(6, 2, 500);
	LDI  R30,LOW(6)
	ST   -Y,R30
	LDI  R30,LOW(2)
	ST   -Y,R30
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	CALL _func1
; 0005 0005     func2(3,10000);
	LDI  R30,LOW(3)
	ST   -Y,R30
	LDI  R26,LOW(10000)
	LDI  R27,HIGH(10000)
	CALL _func2
; 0005 0006     func3(portA, portB);
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R26,LOW(2)
	CALL _func3
; 0005 0007     func4(dec,False,2);
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	LDI  R26,LOW(2)
	CALL _func4
; 0005 0008     func5(3);
	LDI  R26,LOW(3)
	RCALL _func5
; 0005 0009 }
	RET
; .FEND
;/*
; * Lab_2_Qst6.c
; *
; * Created: 3/8/2021 12:55:32 AM
; * Author: farkoo
; */
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
;
;void main(void)
; 0006 000C {

	.CSEG
_main:
; .FSTART _main
; 0006 000D     func6();
	RCALL _func6
; 0006 000E while (1)
_0xC0003:
; 0006 000F     {
; 0006 0010     // Please write your application code here
; 0006 0011 
; 0006 0012     }
	RJMP _0xC0003
; 0006 0013 }
_0xC0006:
	RJMP _0xC0006
; .FEND

	.DSEG
_array2:
	.BYTE 0xA
_array:
	.BYTE 0xA

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x0:
	LDI  R31,0
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1:
	LDI  R26,LOW(_array2)
	LDI  R27,HIGH(_array2)
	ADD  R26,R16
	ADC  R27,R17
	LD   R30,X
	OUT  0x15,R30
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:24 WORDS
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x5:
	SUBI R30,LOW(-_array)
	SBCI R31,HIGH(-_array)
	LD   R30,Z
	OUT  0x15,R30
	LDI  R26,LOW(1)
	LDI  R27,0
	JMP  _delay_ms


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

;END OF CODE MARKER
__END_OF_CODE:
