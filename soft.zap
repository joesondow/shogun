
	.SEGMENT "0"


	.FUNCT	SLIDE-SHOW-HANDLER:ANY:0:0
	SET	'DEMO-VERSION?,1
	RTRUE	


	.FUNCT	READ-DEMO:ANY:1:2,ARG1,ARG2,CHR
	SET	'DEMO-VERSION?,-1
	READ	ARG1,ARG2,DEMO-TIMEOUT,SLIDE-SHOW-HANDLER >CHR
	EQUAL?	DEMO-VERSION?,1 \?CCL3
	CALL1	END-DEMO
	RSTACK	
?CCL3:	WINPUT	S-TEXT,15,-999
	RETURN	CHR


	.FUNCT	INPUT-DEMO:ANY:1:1,ARG,CHR
	SET	'DEMO-VERSION?,-1
	INPUT	ARG,DEMO-TIMEOUT,SLIDE-SHOW-HANDLER >CHR
	EQUAL?	DEMO-VERSION?,1 \?CCL3
	CALL1	END-DEMO
	RSTACK	
?CCL3:	WINPUT	S-TEXT,15,-999
	RETURN	CHR


	.FUNCT	READ-INPUT:ANY:0:0,TRM,TMP,FDEF,?TMP1
	PRINTC	62
	PUTB	P-INBUF,1,0
?PRG1:	ZERO?	DEMO-VERSION? /?CCL5
	CALL2	READ-DEMO,P-INBUF >TRM
	JUMP	?CND3
?CCL5:	READ	P-INBUF,FALSE-VALUE >TRM
?CND3:	CALL2	CONVERT-KEYS,TRM >TRM
	EQUAL?	TRM,13,10 /?REP2
	EQUAL?	TRM,CLICK1,CLICK2 \?CCL10
	CALL2	MOUSE-INPUT,TRM
	ZERO?	STACK \?REP2
	SOUND	S-BEEP
	JUMP	?PRG1
?CCL10:	ADD	FKEYS,2 >?TMP1
	GET	FKEYS,0
	INTBL?	TRM,?TMP1,STACK >TMP \?CCL15
	GET	TMP,1 >FDEF
	ZERO?	FDEF /?CCL15
	GETB	FDEF,1
	ZERO?	STACK /?CCL15
	ADD	1,FDEF
	CALL	ADD-TO-INPUT,STACK,TRM >TRM
	EQUAL?	TRM,13,10 /?REP2
	JUMP	?PRG1
?CCL15:	SOUND	S-BEEP
	JUMP	?PRG1
?REP2:	ICALL1	SCRIPT-INBUF
	LEX	P-INBUF,P-LEXV
	RTRUE	


	.FUNCT	CONVERT-KEYS:ANY:1:1,TRM
	EQUAL?	TRM,PAD0 \?CCL3
	SET	'TRM,F10
	RETURN	TRM
?CCL3:	LESS?	TRM,PAD1 /?CND1
	GRTR?	TRM,PAD9 /?CND1
	SUB	TRM,PAD1
	ADD	F1,STACK >TRM
?CND1:	RETURN	TRM


	.FUNCT	MOUSE-INPUT:ANY:1:1,TRM
	GET	0,27
	GET	STACK,1 >MOUSE-LOC-X
	GET	0,27
	GET	STACK,2 >MOUSE-LOC-Y
	GETP	HERE,P?MOUSE
	CALL	STACK,TRM
	RSTACK	


	.FUNCT	ADD-TO-INPUT:ANY:2:2,FDEF,TRM,M,N,TMP,?TMP1
	GETB	FDEF,0 >M
	GETB	P-INBUF,1 >N
	GETB	FDEF,M
	EQUAL?	STACK,13,10 \?CND1
	SET	'TRM,13
	DEC	'M
?CND1:	ADD	N,2
	ADD	P-INBUF,STACK >TMP
	ADD	M,N >?TMP1
	GETB	P-INBUF,0
	SUB	STACK,1
	LESS?	?TMP1,STACK /?CND3
	SOUND	1
	GETB	P-INBUF,0
	SUB	STACK,N
	SUB	STACK,2 >M
?CND3:	INC	'FDEF
	COPYT	FDEF,TMP,M
	PUTB	TMP,M,0
	WINATTR	-3,A-SCRIPT,O-CLEAR
	PRINTT	FDEF,M
	ADD	N,M
	PUTB	P-INBUF,1,STACK
	EQUAL?	TRM,13,10 \?CND5
	CRLF	
?CND5:	WINATTR	-3,A-SCRIPT,O-SET
	RETURN	TRM


	.FUNCT	SCRIPT-INBUF:ANY:0:0,BUF,CNT,N,CHR
	GETB	P-INBUF,1 >N
	DIROUT	D-SCREEN-OFF
	ADD	1,P-INBUF >BUF
?PRG1:	IGRTR?	'CNT,N /?REP2
	GETB	BUF,CNT >CHR
	LESS?	CHR,97 /?CCL8
	GRTR?	CHR,122 /?CCL8
	SUB	CHR,32
	PRINTC	STACK
	JUMP	?PRG1
?CCL8:	PRINTC	CHR
	JUMP	?PRG1
?REP2:	CRLF	
	DIROUT	D-SCREEN-ON
	RTRUE	


	.FUNCT	YES?:ANY:0:0,TMP
?PRG1:	PRINTI	"?
(Y is affirmative): >"
	ZERO?	DEMO-VERSION? /?CCL5
	CALL2	INPUT-DEMO,1
	JUMP	?CND3
?CCL5:	INPUT	1
?CND3:	CALL2	CONVERT-KEYS,STACK >TMP
	EQUAL?	TMP,13,10 /?CND6
	CRLF	
?CND6:	EQUAL?	TMP,89,121,CLICK1 /TRUE
	EQUAL?	TMP,CLICK2 /TRUE
	EQUAL?	TMP,78,110 \?PRG1
	RFALSE	


	.FUNCT	PRINT-CENTER-TABLE:ANY:0:1,TMAX,L,?TMP1
	DIROUT	D-TABLE-OFF
	GET	0,24 >L
	ZERO?	TMAX /?CND1
	WINGET	-3,WYPOS >?TMP1
	WINGET	-3,WWIDE
	SUB	STACK,TMAX
	DIV	STACK,2
	ADD	STACK,1
	CURSET	?TMP1,STACK
	ICALL2	XERASE,TMAX
?CND1:	WINGET	-3,WYPOS >?TMP1
	WINGET	-3,WWIDE
	SUB	STACK,L
	DIV	STACK,2
	ADD	STACK,1
	CURSET	?TMP1,STACK
	GET	DIROUT-TABLE,0
	PRINTT	DIROUT-TABLE+2,STACK
	RTRUE	


	.FUNCT	XERASE:ANY:1:1,N,X,L,OX,OY,?TMP1
	EQUAL?	MACHINE,AMIGA \?CCL3
	ZERO?	SPACE-WIDTH \?CND4
	DIROUT	D-TABLE-ON,DIROUT-TABLE
	PRINTC	32
	DIROUT	D-TABLE-OFF
	GET	0,24 >SPACE-WIDTH
?CND4:	EQUAL?	N,1 \?CND6
	WINGET	-3,WWIDE >?TMP1
	WINGET	-3,WXPOS
	SUB	?TMP1,STACK
	SUB	STACK,1 >N
?CND6:	MOD	N,SPACE-WIDTH >X
	DIV	N,SPACE-WIDTH >N
	ZERO?	X /?CND8
	INC	'N
?CND8:	GETB	SPACE-TABLE,0 >L
	WINGET	-3,WXPOS >OX
	WINGET	-3,WYPOS >OY
?PRG10:	LESS?	N,L \?CCL14
	ICALL	PRINT-TABLE,SPACE-TABLE,N
	CURSET	OY,OX
	RTRUE	
?CCL14:	SUB	N,L >N
	ICALL	PRINT-TABLE,SPACE-TABLE,L
	JUMP	?PRG10
?CCL3:	ERASE	N
	RTRUE	


	.FUNCT	INVERSE-COLOR:ANY:0:0
	EQUAL?	MACHINE,AMIGA \?CCL3
	HLIGHT	H-INVERSE
	RTRUE	
?CCL3:	COLOR	BG-COLOR,FG-COLOR
	RTRUE	


	.FUNCT	NORMAL-COLOR:ANY:0:0
	EQUAL?	MACHINE,AMIGA \?CND1
	HLIGHT	H-NORMAL
?CND1:	COLOR	FG-COLOR,BG-COLOR
	RTRUE	


	.FUNCT	TYPE-ANY-KEY:ANY:0:0,KEY
	WINATTR	-3,A-SCRIPT,O-CLEAR
	PRINTI	"[Type any key to continue]"
	ZERO?	DEMO-VERSION? /?CCL3
	CALL2	INPUT-DEMO,1 >KEY
	JUMP	?CND1
?CCL3:	INPUT	1 >KEY
?CND1:	WINATTR	-3,A-SCRIPT,O-SET
	RETURN	KEY

	.ENDSEG

	.SEGMENT "SOFT-KEYS"


	.FUNCT	V-DEFINE:ANY:0:0,LINE,LINMAX,CHR,TMP,NLINE,FKEY,FDEF,LEFT,?TMP1
	EQUAL?	MACHINE,APPLE-2E,APPLE-2C,APPLE-2GS \?CND1
	PICINF	P-SOFT-KEY-SEG,YX-TBL /?CND1
?CND1:	ZERO?	DONE-DEFINE? \?CND4
	PRINTI	"Use the up-arrow and down-arrow keys"
	GET	0,8
	BTST	STACK,32 \?CND6
	PRINTI	" or mouse"
?CND6:	PRINTI	" to move to the function key or operation you want. Double-click or carriage-return to perform operations."
	CRLF	
	ICALL1	TYPE-ANY-KEY
	ZERO?	DONE-DEFINE? \?CND4
	CALL1	MAX-SOFT-CMD >DONE-DEFINE?
?CND4:	CLEAR	-1
	MUL	4,LINE
	ADD	2,STACK
	ADD	FKEYS,STACK >FKEY
	GET	FKEY,1 >FDEF
	GETB	0,33 >?TMP1
	GETB	FDEF,0
	SUB	?TMP1,STACK
	DIV	STACK,2 >LEFT
	GET	FKEYS,0
	DIV	STACK,2 >LINMAX
	SCREEN	SOFT-WINDOW
	FONT	4
	WINGET	SOFT-WINDOW,WFSIZE >TMP
	BAND	TMP,255 >MONO-X
	GETB	0,32
	SUB	STACK,LINMAX
	DIV	STACK,2
	MUL	FONT-Y,STACK >?TMP1
	MUL	MONO-X,LEFT
	WINPOS	SOFT-WINDOW,?TMP1,STACK
	ADD	LINMAX,1
	MUL	FONT-Y,STACK >?TMP1
	ADD	FKEY-MAX-LEN,4
	MUL	MONO-X,STACK
	ADD	1,STACK
	WINSIZE	SOFT-WINDOW,?TMP1,STACK
	ICALL2	DISPLAY-SOFTS,LINE
	ICALL	DISPLAY-SOFT,FKEY,LINE,FALSE-VALUE
?PRG10:	ZERO?	DEMO-VERSION? /?CCL14
	CALL2	INPUT-DEMO,1
	JUMP	?CND12
?CCL14:	INPUT	1
?CND12:	CALL2	CONVERT-KEYS,STACK >CHR
	SET	'NLINE,LINE
	EQUAL?	CHR,CLICK1,CLICK2 \?CND15
	CALL2	IN-WINDOW?,SOFT-WINDOW >TMP
	ZERO?	TMP /?CND15
	GRTR?	TMP,1 \?CND15
	SUB	TMP,2 >NLINE
	EQUAL?	LINE,NLINE /?CND20
	MUL	2,NLINE
	ADD	2,STACK
	GET	FKEYS,STACK
	ZERO?	STACK \?CCL24
	SET	'NLINE,LINE
	SOUND	S-BEEP
	JUMP	?CND20
?CCL24:	ICALL	DISPLAY-SOFT,FKEY,LINE,TRUE-VALUE
	MUL	4,NLINE
	ADD	2,STACK
	ADD	FKEYS,STACK
	ICALL	DISPLAY-SOFT,STACK,NLINE,FALSE-VALUE
	SET	'LINE,NLINE
	MUL	4,LINE
	ADD	2,STACK
	ADD	FKEYS,STACK >FKEY
	GET	FKEY,1 >FDEF
?CND20:	EQUAL?	CHR,CLICK2 \?CND15
	GET	FKEY,0
	LESS?	STACK,0 \?CND15
	SET	'CHR,13
?CND15:	EQUAL?	CHR,CLICK1,CLICK2 /?CND29
	EQUAL?	CHR,13 \?CCL32
	GET	FKEY,0
	LESS?	STACK,0 \?CCL32
	SET	'NLINE,0
	GET	FDEF,1
	CALL	STACK
	ZERO?	STACK \?REP11
	SUB	LINMAX,1 >NLINE
	ICALL2	DISPLAY-SOFTS,LINE
	JUMP	?CND29
?CCL32:	EQUAL?	CHR,DOWN-ARROW,13 \?CCL39
	INC	'NLINE
	LESS?	NLINE,LINMAX \?CCL42
	MUL	2,NLINE
	ADD	2,STACK
	GET	FKEYS,STACK
	ZERO?	STACK \?CND29
	INC	'NLINE
	JUMP	?CND29
?CCL42:	SET	'NLINE,0
	JUMP	?CND29
?CCL39:	EQUAL?	CHR,UP-ARROW \?CCL46
	DLESS?	'NLINE,0 /?CCL49
	MUL	2,NLINE
	ADD	2,STACK
	GET	FKEYS,STACK
	ZERO?	STACK \?CND29
	DEC	'NLINE
	JUMP	?CND29
?CCL49:	SUB	LINMAX,1 >NLINE
	JUMP	?CND29
?CCL46:	ADD	FKEYS,2 >?TMP1
	GET	FKEYS,0
	INTBL?	CHR,?TMP1,STACK >TMP \?CCL53
	SUB	TMP,FKEYS
	DIV	STACK,4 >NLINE
	JUMP	?CND29
?CCL53:	GET	FKEY,0
	GRTR?	STACK,0 \?CCL55
	EQUAL?	CHR,8,127 \?CCL58
	GETB	FDEF,1 >TMP
	ZERO?	TMP /?CCL61
	DEC	'TMP
	PUTB	FDEF,1,TMP
	ADD	TMP,2
	PUTB	FDEF,STACK,32
	ADD	LINE,1
	MUL	STACK,FONT-Y
	ADD	1,STACK >?TMP1
	ADD	TMP,4
	MUL	STACK,MONO-X
	ADD	1,STACK
	CURSET	?TMP1,STACK
	ICALL2	XERASE,1
	JUMP	?CND29
?CCL61:	SOUND	S-BEEP
	JUMP	?CND29
?CCL58:	LESS?	CHR,32 /?CCL63
	LESS?	CHR,127 \?CCL63
	GETB	FDEF,1 >TMP
	GETB	FDEF,0
	EQUAL?	TMP,STACK \?CCL68
	SOUND	S-BEEP
	JUMP	?CND29
?CCL68:	ADD	FDEF,2 >?TMP1
	GETB	FDEF,1
	INTBL?	13,?TMP1,STACK,1 >LEFT \?CCL70
	SOUND	S-BEEP
	JUMP	?CND29
?CCL70:	EQUAL?	CHR,124,33 \?CND71
	SET	'CHR,13
?CND71:	ADD	TMP,1
	PUTB	FDEF,1,STACK
	LESS?	CHR,65 /?CND73
	GRTR?	CHR,90 /?CND73
	ADD	CHR,32 >CHR
?CND73:	ADD	TMP,2
	PUTB	FDEF,STACK,CHR
	EQUAL?	CHR,13 \?CCL79
	PRINTC	124
	JUMP	?CND29
?CCL79:	PRINTC	CHR
	JUMP	?CND29
?CCL63:	SOUND	S-BEEP
	JUMP	?CND29
?CCL55:	SOUND	S-BEEP
?CND29:	EQUAL?	LINE,NLINE /?PRG10
	ICALL	DISPLAY-SOFT,FKEY,LINE,TRUE-VALUE
	MUL	4,NLINE
	ADD	2,STACK
	ADD	FKEYS,STACK
	ICALL	DISPLAY-SOFT,STACK,NLINE,FALSE-VALUE
	SET	'LINE,NLINE
	MUL	4,LINE
	ADD	2,STACK
	ADD	FKEYS,STACK >FKEY
	GET	FKEY,1 >FDEF
	JUMP	?PRG10
?REP11:	FONT	1
	SCREEN	S-TEXT
	CLEAR	S-TEXT
	CALL1	V-$REFRESH
	RSTACK	


	.FUNCT	IN-WINDOW?:ANY:1:1,W,X,Y,TOP,LEFT
	GET	0,27
	GET	STACK,2 >Y
	GET	0,27
	GET	STACK,1 >X
	WINGET	W,WTOP >TOP
	LESS?	Y,TOP /FALSE
	WINGET	W,WLEFT >LEFT
	LESS?	X,LEFT /FALSE
	SUB	Y,TOP >Y
	SUB	X,LEFT >X
	WINGET	W,WHIGH
	GRTR?	Y,STACK /FALSE
	WINGET	W,WWIDE
	GRTR?	X,STACK /FALSE
	DIV	Y,FONT-Y
	ADD	1,STACK >Y
	RETURN	Y


	.FUNCT	MAX-SOFT-CMD:ANY:0:0,L,FKEY,CNT,TMAX,FDEF
	GET	FKEYS,0 >L
	DIV	L,2 >L
	ADD	FKEYS,2 >FKEY
?PRG1:	LESS?	CNT,L /?CTR4
	RETURN	TMAX
?CTR4:	GET	FKEY,0
	LESS?	STACK,0 \?CND6
	GET	FKEY,1 >FDEF
	ZERO?	FDEF /?CND6
	DIROUT	D-TABLE-ON,DIROUT-TABLE
	PRINTI	"  "
	GET	FDEF,0
	PRINT	STACK
	PRINTI	"  "
	DIROUT	D-TABLE-OFF
	GET	0,24
	GRTR?	STACK,TMAX \?CND6
	GET	0,24 >TMAX
?CND6:	ADD	FKEY,4 >FKEY
	INC	'CNT
	JUMP	?PRG1


	.FUNCT	DISPLAY-SOFTS:ANY:1:1,LINE,L,F,N,FKEY,CNT
	GET	FKEYS,0 >L
	DIV	L,2 >L
	SCREEN	SOFT-WINDOW
	CURSET	1,1
	DIROUT	D-TABLE-ON,DIROUT-TABLE
	FONT	1
	PRINTI	"Function Keys"
	ICALL1	PRINT-CENTER-TABLE
	FONT	4
	ADD	FKEYS,2 >FKEY
?PRG1:	LESS?	CNT,L \TRUE
	EQUAL?	CNT,LINE \?CCL8
	PUSH	FALSE-VALUE
	JUMP	?CND6
?CCL8:	PUSH	TRUE-VALUE
?CND6:	ICALL	DISPLAY-SOFT,FKEY,CNT,STACK
	ADD	FKEY,4 >FKEY
	INC	'CNT
	JUMP	?PRG1


	.FUNCT	DISPLAY-SOFT:ANY:3:3,FKEY,CNT,INV?,FDEF,S,N,M,TMP,Y,X,?TMP1
	GET	FKEY,1 >FDEF
	ADD	CNT,2 >Y
	GET	FKEY,0
	LESS?	STACK,0 \?CCL3
	GET	FKEY,1
	ZERO?	STACK /?CND1
	ICALL	CCURSET,Y,1
	ZERO?	INV? /?CND6
	ICALL1	INVERSE-COLOR
?CND6:	FONT	1
	DIROUT	D-TABLE-ON,DIROUT-TABLE
	GET	FDEF,0
	PRINT	STACK
	ICALL2	PRINT-CENTER-TABLE,DONE-DEFINE?
	FONT	4
	JUMP	?CND1
?CCL3:	GETB	FDEF,0 >S
	GETB	FDEF,1 >N
	ICALL	CCURSET,Y,1
	GET	FKEY,0 >?TMP1
	GET	FNAMES,0
	INTBL?	?TMP1,FNAMES+2,STACK >TMP \?CND8
	ZERO?	INV? /?CCL12
	ICALL1	NORMAL-COLOR
	JUMP	?CND10
?CCL12:	ICALL1	INVERSE-COLOR
?CND10:	GET	TMP,1
	PRINT	STACK
	ICALL1	NORMAL-COLOR
	PRINTC	32
	ZERO?	INV? /?CCL15
	ICALL1	INVERSE-COLOR
	JUMP	?CND8
?CCL15:	ICALL1	NORMAL-COLOR
?CND8:	ADD	FDEF,2 >FDEF
	ZERO?	N /?CND16
	SUB	N,1 >M
	GETB	FDEF,M
	EQUAL?	STACK,13 \?CND16
	PRINTT	FDEF,M
	PRINTC	124
	ADD	FDEF,N >FDEF
	SUB	S,N >S
?CND16:	PRINTT	FDEF,S
	ICALL2	XERASE,1
	ZERO?	INV? \?CND1
	SUB	Y,1
	MUL	STACK,FONT-Y
	ADD	1,STACK >?TMP1
	ADD	N,4
	MUL	STACK,MONO-X
	ADD	1,STACK
	CURSET	?TMP1,STACK
?CND1:	CALL1	NORMAL-COLOR
	RSTACK	


	.FUNCT	SOFT-RESET-DEFAULTS:ANY:0:0,K,L,KEYS,DEF,KL,TMP,?TMP1
	GET	FKEYS,0 >KL
	SET	'DEF,DEFAULT-FKEYS
?PRG1:	GETB	DEF,0 >K
	ZERO?	K /FALSE
	INC	'DEF
	GETB	DEF,0
	ADD	1,STACK >L
	ADD	FKEYS,2
	INTBL?	K,STACK,KL >KEYS \?CND5
	GET	KEYS,1 >KEYS
	ADD	1,KEYS >TMP
	PUTB	TMP,0,32
	ADD	1,TMP >?TMP1
	GETB	KEYS,0
	SUB	0,STACK
	COPYT	TMP,?TMP1,STACK
	ADD	1,KEYS
	COPYT	DEF,STACK,L
?CND5:	ADD	DEF,L >DEF
	JUMP	?PRG1


	.FUNCT	SOFT-SAVE-DEFS:ANY:0:0
	CLEAR	S-TEXT
	SCREEN	S-TEXT
	SAVE	FKEY-TBL,FKEYS-STRTABLE-LEN,DEFS-NAME
	ZERO?	STACK \?CND1
	PRINTI	"Failed."
?CND1:	CLEAR	S-TEXT
	SCREEN	SOFT-WINDOW
	RFALSE	


	.FUNCT	SOFT-RESTORE-DEFS:ANY:0:0
	CLEAR	S-TEXT
	SCREEN	S-TEXT
	RESTORE	FKEY-TBL,FKEYS-STRTABLE-LEN,DEFS-NAME
	ZERO?	STACK \?CND1
	PRINTI	"Failed."
?CND1:	CLEAR	S-TEXT
	SCREEN	SOFT-WINDOW
	RFALSE	


	.FUNCT	SOFT-EXIT:ANY:0:0
	RTRUE	

	.ENDSEG

	.ENDI
