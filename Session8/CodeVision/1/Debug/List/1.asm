
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
	.DB  0xFF,0x0,0xFF,0x0,0xFF,0x0,0x0,0x0
	.DB  0xF6,0x0,0xF6,0x0,0xF6,0x0,0xFF,0x0
	.DB  0xFF,0x0,0xFF,0x0,0xFF,0x0,0x0,0x0
	.DB  0xE7,0x0,0xDB,0x0,0xBD,0x0,0x7E,0x0
	.DB  0xFF,0x0,0xFF,0x0,0xFF,0x0,0xFF,0x0
	.DB  0xFF,0x0,0xFF,0x0,0x0,0x0,0xF6,0x0
	.DB  0xF6,0x0,0xF6,0x0,0xFF,0x0,0xFF,0x0
	.DB  0xFF,0x0,0xFF,0x0,0x0,0x0,0xE7,0x0
	.DB  0xDB,0x0,0xBD,0x0,0x7E,0x0,0xFF,0x0
	.DB  0xFF,0x0,0xFF,0x0,0xFF,0x0,0xFF,0x0
	.DB  0xFF,0x0,0x0,0x0,0xF6,0x0,0xF6,0x0
	.DB  0xF6,0x0,0xFF,0x0,0xFF,0x0,0xFF,0x0
	.DB  0xFF,0x0,0x0,0x0,0xE7,0x0,0xDB,0x0
	.DB  0xBD,0x0,0x7E,0x0,0x7E,0x0,0xFF,0x0
	.DB  0xFF,0x0,0xFF,0x0,0xFF,0x0,0xFF,0x0
	.DB  0x0,0x0,0xF6,0x0,0xF6,0x0,0xF6,0x0
	.DB  0xFF,0x0,0xFF,0x0,0xFF,0x0,0xFF,0x0
	.DB  0x0,0x0,0xE7,0x0,0xDB,0x0,0xBD,0x0
	.DB  0xBD,0x0,0x7E,0x0,0xFF,0x0,0xFF,0x0
	.DB  0xFF,0x0,0xFF,0x0,0xFF,0x0,0x0,0x0
	.DB  0xF6,0x0,0xF6,0x0,0xF6,0x0,0xFF,0x0
	.DB  0xFF,0x0,0xFF,0x0,0xFF,0x0,0x0,0x0
	.DB  0xE7,0x0,0xDB,0x0,0xDB,0x0,0xBD,0x0
	.DB  0x7E,0x0,0xFF,0x0,0xFF,0x0,0xFF,0x0
	.DB  0xFF,0x0,0xFF,0x0,0x0,0x0,0xF6,0x0
	.DB  0xF6,0x0,0xF6,0x0,0xFF,0x0,0xFF,0x0
	.DB  0xFF,0x0,0xFF,0x0,0x0,0x0,0xE7,0x0
	.DB  0xE7,0x0,0xDB,0x0,0xBD,0x0,0x7E,0x0
	.DB  0xFF,0x0,0xFF,0x0,0xFF,0x0,0xFF,0x0
	.DB  0xFF,0x0,0x0,0x0,0xF6,0x0,0xF6,0x0
	.DB  0xF6,0x0,0xFF,0x0,0xFF,0x0,0xFF,0x0
	.DB  0xFF,0x0,0x0,0x0,0x0,0x0,0xE7,0x0
	.DB  0xDB,0x0,0xBD,0x0,0x7E,0x0,0xFF,0x0
	.DB  0xFF,0x0,0xFF,0x0,0xFF,0x0,0xFF,0x0
	.DB  0x0,0x0,0xF6,0x0,0xF6,0x0,0xF6,0x0
	.DB  0xFF,0x0,0xFF,0x0,0xFF,0x0,0xFF,0x0
	.DB  0xFF,0x0,0x0,0x0,0xE7,0x0,0xDB,0x0
	.DB  0xBD,0x0,0x7E,0x0,0xFF,0x0,0xFF,0x0
	.DB  0xFF,0x0,0xFF,0x0,0xFF,0x0,0x0,0x0
	.DB  0xF6,0x0,0xF6,0x0,0xF6,0x0,0xFF,0x0
	.DB  0xFF,0x0,0xFF,0x0,0xFF,0x0,0xFF,0x0
	.DB  0x0,0x0,0xE7,0x0,0xDB,0x0,0xBD,0x0
	.DB  0x7E,0x0,0xFF,0x0,0xFF,0x0,0xFF,0x0
	.DB  0xFF,0x0,0xFF,0x0,0x0,0x0,0xF6,0x0
	.DB  0xF6,0x0,0xF6,0x0,0xFF,0x0,0xFF,0x0
	.DB  0xFF,0x0,0xFF,0x0,0xFF,0x0,0x0,0x0
	.DB  0xE7,0x0,0xDB,0x0,0xBD,0x0,0x7E,0x0
	.DB  0xFF,0x0,0xFF,0x0,0xFF,0x0,0xFF,0x0
	.DB  0xFF,0x0,0x0,0x0,0xF6,0x0,0xF6,0x0
	.DB  0xF6,0x0,0xFF,0x0,0xFF,0x0,0xFF,0x0
	.DB  0xFF,0x0,0xFF,0x0,0x0,0x0,0xE7,0x0
	.DB  0xDB,0x0,0xBD,0x0,0x7E,0x0,0xFF,0x0
	.DB  0xFF,0x0,0xFF,0x0,0xFF,0x0,0xFF,0x0
	.DB  0x0,0x0,0xF6,0x0,0xF6,0x0,0xF6,0x0
	.DB  0xF6,0x0,0xFF,0x0,0xFF,0x0,0xFF,0x0
	.DB  0xFF,0x0,0x0,0x0,0xE7,0x0,0xDB,0x0
	.DB  0xBD,0x0,0x7E,0x0,0xFF,0x0,0xFF,0x0
	.DB  0xFF,0x0,0xFF,0x0,0xFF,0x0,0x0,0x0
	.DB  0xF6,0x0,0xF6,0x0,0xF6,0x0,0xF6,0x0
	.DB  0xFF,0x0,0xFF,0x0,0xFF,0x0,0xFF,0x0
	.DB  0x0,0x0,0xE7,0x0,0xDB,0x0,0xBD,0x0
	.DB  0x7E,0x0,0xFF,0x0,0xFF,0x0,0xFF,0x0
	.DB  0xFF,0x0,0xFF,0x0,0x0,0x0,0xF6,0x0
	.DB  0xF6,0x0,0xF6,0x0,0xF6,0x0,0xFF,0x0
	.DB  0xFF,0x0,0xFF,0x0,0xFF,0x0,0x0,0x0
	.DB  0xE7,0x0,0xDB,0x0,0xBD,0x0,0x7E,0x0
	.DB  0xFF,0x0,0xFF,0x0,0xFF,0x0,0xFF,0x0
	.DB  0xFF,0x0,0x0,0x0,0x0,0x0,0xF6,0x0
	.DB  0xF6,0x0,0xF6,0x0,0xFF,0x0,0xFF,0x0
	.DB  0xFF,0x0,0xFF,0x0,0x0,0x0,0xE7,0x0
	.DB  0xDB,0x0,0xBD,0x0,0x7E,0x0,0xFF,0x0
	.DB  0xFF,0x0,0xFF,0x0,0xFF,0x0,0xFF,0x0
	.DB  0xFF,0x0,0x0,0x0,0xF6,0x0,0xF6,0x0
	.DB  0xF6,0x0,0xFF,0x0,0xFF,0x0,0xFF,0x0
	.DB  0xFF,0x0,0x0,0x0,0xE7,0x0,0xDB,0x0
	.DB  0xBD,0x0,0x7E,0x0,0xFF,0x0,0xFF,0x0
	.DB  0xFF,0x0,0xFF
_0x2040060:
	.DB  0x1
_0x2040000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x263
	.DW  _FK
	.DW  _0x3*2

	.DW  0x01
	.DW  __seed_G102
	.DW  _0x2040060*2

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
;Date    : 5/26/2021
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
;#include <mega16.h>
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
;#include <font5x7.h>
;#include <math.h>
;
;// Graphic Display functions
;
;
;// Declare your global variables here
;const unsigned short FK[] = {
;        0xFF, 0xFF, 0xFF, 0x00, 0xF6, 0xF6, 0xF6, 0xFF, 0xFF, 0xFF, 0xFF, 0x00, 0xE7, 0xDB, 0xBD, 0x7E, 0xFF, 0xFF, // C ...
;        0xFF, 0xFF, 0xFF, 0xFF, 0x00, 0xF6, 0xF6, 0xF6, 0xFF, 0xFF, 0xFF, 0xFF, 0x00, 0xE7, 0xDB, 0xBD, 0x7E, 0xFF,  //  ...
;        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x00, 0xF6, 0xF6, 0xF6, 0xFF, 0xFF, 0xFF, 0xFF, 0x00, 0xE7, 0xDB, 0xBD, 0x7E,  //  ...
;        0x7E, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x00, 0xF6, 0xF6, 0xF6, 0xFF, 0xFF, 0xFF, 0xFF, 0x00, 0xE7, 0xDB, 0xBD,  //  ...
;        0xBD, 0x7E, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x00, 0xF6, 0xF6, 0xF6, 0xFF, 0xFF, 0xFF, 0xFF, 0x00, 0xE7, 0xDB,  //  ...
;        0xDB, 0xBD, 0x7E, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x00, 0xF6, 0xF6, 0xF6, 0xFF, 0xFF, 0xFF, 0xFF, 0x00, 0xE7,  //  ...
;        0xE7, 0xDB, 0xBD, 0x7E, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x00, 0xF6, 0xF6, 0xF6, 0xFF, 0xFF, 0xFF, 0xFF, 0x00,  //  ...
;        0x00, 0xE7, 0xDB, 0xBD, 0x7E, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x00, 0xF6, 0xF6, 0xF6, 0xFF, 0xFF, 0xFF, 0xFF,  //  ...
;        0xFF, 0x00, 0xE7, 0xDB, 0xBD, 0x7E, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x00, 0xF6, 0xF6, 0xF6, 0xFF, 0xFF, 0xFF,  //  ...
;        0xFF, 0xFF, 0x00, 0xE7, 0xDB, 0xBD, 0x7E, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x00, 0xF6, 0xF6, 0xF6, 0xFF, 0xFF,  //  ...
;        0xFF, 0xFF, 0xFF, 0x00, 0xE7, 0xDB, 0xBD, 0x7E, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x00, 0xF6, 0xF6, 0xF6, 0xFF,  //  ...
;        0xFF, 0xFF, 0xFF, 0xFF, 0x00, 0xE7, 0xDB, 0xBD, 0x7E, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x00, 0xF6, 0xF6, 0xF6,  //  ...
;        0xF6, 0xFF, 0xFF, 0xFF, 0xFF, 0x00, 0xE7, 0xDB, 0xBD, 0x7E, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x00, 0xF6, 0xF6,  //  ...
;        0xF6, 0xF6, 0xFF, 0xFF, 0xFF, 0xFF, 0x00, 0xE7, 0xDB, 0xBD, 0x7E, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x00, 0xF6,  //  ...
;        0xF6, 0xF6, 0xF6, 0xFF, 0xFF, 0xFF, 0xFF, 0x00, 0xE7, 0xDB, 0xBD, 0x7E, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x00,  //  ...
;        0x00, 0xF6, 0xF6, 0xF6, 0xFF, 0xFF, 0xFF, 0xFF, 0x00, 0xE7, 0xDB, 0xBD, 0x7E, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,  //  ...
;        0xFF, 0x00, 0xF6, 0xF6, 0xF6, 0xFF, 0xFF, 0xFF, 0xFF, 0x00, 0xE7, 0xDB, 0xBD, 0x7E, 0xFF, 0xFF, 0xFF, 0xFF   //  ...
;        };

	.DSEG
;
;
;   void question1(){
; 0000 0035 void question1(){

	.CSEG
_question1:
; .FSTART _question1
; 0000 0036     int k,j;
; 0000 0037     int r = 0;
; 0000 0038     int c = 0;
; 0000 0039     int max_column = 8;
; 0000 003A     int min_column = 0;
; 0000 003B     int i=0;
; 0000 003C     while(1){
	SBIW R28,8
	LDI  R30,LOW(0)
	ST   Y,R30
	STD  Y+1,R30
	STD  Y+2,R30
	STD  Y+3,R30
	LDI  R30,LOW(8)
	STD  Y+4,R30
	LDI  R30,LOW(0)
	STD  Y+5,R30
	STD  Y+6,R30
	STD  Y+7,R30
	CALL __SAVELOCR6
;	k -> R16,R17
;	j -> R18,R19
;	r -> R20,R21
;	c -> Y+12
;	max_column -> Y+10
;	min_column -> Y+8
;	i -> Y+6
	__GETWRN 20,21,0
_0x4:
; 0000 003D         for(i=0;i<150;i++){
	LDI  R30,LOW(0)
	STD  Y+6,R30
	STD  Y+6+1,R30
_0x8:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CPI  R26,LOW(0x96)
	LDI  R30,HIGH(0x96)
	CPC  R27,R30
	BRLT PC+2
	RJMP _0x9
; 0000 003E                 PORTD = 0x80;
	LDI  R30,LOW(128)
	OUT  0x12,R30
; 0000 003F                 PORTB = FK[r];
	MOVW R30,R20
	LDI  R26,LOW(_FK)
	LDI  R27,HIGH(_FK)
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	CALL SUBOPT_0x0
; 0000 0040                 PORTA = 1<<c;
; 0000 0041 
; 0000 0042                 for(k = 0; k < 100; k++)
	__GETWRN 16,17,0
_0xB:
	__CPWRN 16,17,100
	BRGE _0xC
; 0000 0043                 {
; 0000 0044                     for(j = 0; j < 10; j++)
	__GETWRN 18,19,0
_0xE:
	__CPWRN 18,19,10
	BRGE _0xF
; 0000 0045                         ;
	__ADDWRN 18,19,1
	RJMP _0xE
_0xF:
; 0000 0046                 }
	__ADDWRN 16,17,1
	RJMP _0xB
_0xC:
; 0000 0047 
; 0000 0048                 PORTD = 0x00;
	LDI  R30,LOW(0)
	OUT  0x12,R30
; 0000 0049                 PORTB = FK[r+8];
	MOVW R26,R20
	LSL  R26
	ROL  R27
	__ADDW2MN _FK,16
	CALL SUBOPT_0x0
; 0000 004A                 PORTA = 1<<c;
; 0000 004B 
; 0000 004C                 r++;
	__ADDWRN 20,21,1
; 0000 004D                 if (r == max_column)
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	CP   R30,R20
	CPC  R31,R21
	BRNE _0x10
; 0000 004E                 {
; 0000 004F                     r = min_column;
	__GETWRS 20,21,8
; 0000 0050                 }
; 0000 0051                 c = (c+1)%8;
_0x10:
	LDD  R30,Y+12
	LDD  R31,Y+12+1
	ADIW R30,1
	LDI  R26,LOW(7)
	LDI  R27,HIGH(7)
	CALL __MANDW12
	STD  Y+12,R30
	STD  Y+12+1,R31
; 0000 0052                 for(k = 0; k < 100; k++)
	__GETWRN 16,17,0
_0x12:
	__CPWRN 16,17,100
	BRGE _0x13
; 0000 0053                 {
; 0000 0054                     for(j = 0; j < 10; j++)
	__GETWRN 18,19,0
_0x15:
	__CPWRN 18,19,10
	BRGE _0x16
; 0000 0055                         ;
	__ADDWRN 18,19,1
	RJMP _0x15
_0x16:
; 0000 0056                 }
	__ADDWRN 16,17,1
	RJMP _0x12
_0x13:
; 0000 0057 
; 0000 0058           }
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,1
	STD  Y+6,R30
	STD  Y+6+1,R31
	RJMP _0x8
_0x9:
; 0000 0059 
; 0000 005A           if (max_column == 248)
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CPI  R26,LOW(0xF8)
	LDI  R30,HIGH(0xF8)
	CPC  R27,R30
	BRNE _0x17
; 0000 005B           {
; 0000 005C             max_column = 8;
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	STD  Y+10,R30
	STD  Y+10+1,R31
; 0000 005D             min_column = 0;
	LDI  R30,LOW(0)
	STD  Y+8,R30
	STD  Y+8+1,R30
; 0000 005E             r=0;
	__GETWRN 20,21,0
; 0000 005F             c=0;
	STD  Y+12,R30
	STD  Y+12+1,R30
; 0000 0060           }
; 0000 0061 
; 0000 0062           else
	RJMP _0x18
_0x17:
; 0000 0063           {
; 0000 0064              max_column =  max_column + 16;
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	ADIW R30,16
	STD  Y+10,R30
	STD  Y+10+1,R31
; 0000 0065              min_column = min_column + 16;
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ADIW R30,16
	STD  Y+8,R30
	STD  Y+8+1,R31
; 0000 0066           }
_0x18:
; 0000 0067 
; 0000 0068     }
	RJMP _0x4
; 0000 0069 }
; .FEND
;void main(void)
; 0000 006B {
_main:
; .FSTART _main
; 0000 006C     question1();
	RCALL _question1
; 0000 006D }
_0x19:
	RJMP _0x19
; .FEND

	.CSEG

	.CSEG

	.DSEG

	.CSEG

	.CSEG

	.CSEG

	.DSEG
_FK:
	.BYTE 0x264
__seed_G102:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x0:
	LD   R30,X
	OUT  0x18,R30
	LDD  R30,Y+12
	LDI  R26,LOW(1)
	CALL __LSLB12
	OUT  0x1B,R30
	RET


	.CSEG
__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
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

__MANDW12:
	CLT
	SBRS R31,7
	RJMP __MANDW121
	RCALL __ANEGW1
	SET
__MANDW121:
	AND  R30,R26
	AND  R31,R27
	BRTC __MANDW122
	RCALL __ANEGW1
__MANDW122:
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
