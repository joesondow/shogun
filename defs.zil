"DEFS for
				 SHOGUN
	(c) Copyright 1988 Infocom, Inc. All Rights Reserved."

;"see if we can save some space"

<CHRSET 0 "abcdefghiklmnoprstuwyT.,\"">
<CHRSET 1 "jqvxzABCEGHIJLMNOPRSWY?!'-">
<CHRSET 2 "DFKQUVXZ123[]:;=*()#}>/	">

<INCLUDE "SYMBOLS">

<COMPILATION-FLAG P-DEBUGGING-PARSER T>

<TELL-TOKENS (CRLF CR)		<CRLF>
	     (NUM N) *		<PRINTN .X>
	     (CHAR CHR C) *	<PRINTC .X>
	     G *:STRING		<PRINT .X>
	     D ,PRSO		<DPRINT-PRSO>
	     D ,PRSI		<DPRINT-PRSI>	
	     D *		<DPRINT .X>
	     CD ,PRSO		<CDPRINT-PRSO>
	     CD ,PRSI		<CDPRINT-PRSI>
	     CD *		<CDPRINT .X>
	     THE ,PRSO		<THE-PRINT-PRSO>
	     THE ,PRSI		<THE-PRINT-PRSI>
	     THE *		<THE-PRINT .X>
	     CTHE ,PRSO		<CTHE-PRINT-PRSO>
	     CTHE ,PRSI		<CTHE-PRINT-PRSI>
	     CTHE *		<CTHE-PRINT .X>
	     (A AN) ,PRSO	<PRINTA-PRSO>
	     (A AN) ,PRSI	<PRINTA-PRSI>
	     (A AN) *		<PRINTA .X>
	     (CA CAN) ,PRSO	<CPRINTA-PRSO>
	     (CA CAN) ,PRSI	<CPRINTA-PRSI>
	     (CA CAN) *		<CPRINTA .X>
	     I *:STRING		<PRINTUNDER .X>
	     HIM/HER *		<PRINT-HIM/HER .X>
	     CHE/SHE *		<CPRINT-HE/SHE .X>
	     HE/SHE *		<PRINT-HE/SHE .X>
	     HIS/HER *		<PRINT-HIS/HER .X>
	     IS/ARE *		<PRINT-IS/ARE .X>
	     S *		<PRINT-PLURAL .X>>

<REPLACE-DEFINITION	BUZZER-WORD?
	<ROUTINE BUZZER-WORD? (WD PTR) <>>>

<REPLACE-DEFINITION	DIR-VERB-PRSI?
	<ROUTINE DIR-VERB-PRSI? (NP) <>>>

<DELAY-DEFINITION	GAME-VERB?>	;"to replace parser's versions"

<BLOCK (<ROOT>)>
TELL-CTHE
TELL-THE
THINGS
<ENDBLOCK>

<REPLACE-DEFINITION	TELL-THE
	<DEFMAC TELL-THE ("ARGS" X) <FORM THE-PRINT !.X>>>

<REPLACE-DEFINITION	TELL-CTHE
	<DEFMAC TELL-CTHE ("ARGS" X) <FORM CTHE-PRINT !.X>>>

<REPLACE-DEFINITION	OWNERS
			<CONSTANT OWNERS
				  <TABLE (PURE LENGTH)
					 BLACKTHORNE
					 CHOPSTICKS
					 CITY
					 CREWMEN
					 CROWD
					 GALLEY
					 GOD
					 GRUEL
					 GYOKO
					 ISHIDO
					 KIRITSUBO
					 LG-ERASMUS
					 LIZARD
					 MAPLE-GLADE
					 MARIKO
					 MATES
					 MURA
					 OMI
					 PARCHMENT
					 REEF
					 SEARCH-PARTY
					 SEBASTIO
					 SIGN-OF-CROSS
					 SPILLBERGEN
					 STRAIT-OF-MAGELLAN
					 TORANAGA
					 VINCK
					 YABU
					 YOSHINAKA>>>

<DELAY-DEFINITION	READ-INPUT>
<REPLACE-DEFINITION	PERSONBIT <CONSTANT PERSONBIT PERSON>>
<REPLACE-DEFINITION	NARTICLEBIT <CONSTANT NARTICLEBIT NOTHEBIT>>
<REPLACE-DEFINITION	REFRESH
			<ROUTINE V-$REFRESH ()
				 <SETG SHERE <>>
				 <COND (<NOT <EQUAL? ,P-CAN-UNDO 2>>
					<REPAINT-DISPLAY>)
				       (<EQUAL? ,P-CAN-UNDO 2>
					<NORMAL-COLOR>
					<SCREEN ,S-FULL>
					<NORMAL-COLOR>
					<SCREEN 0>
					<RESET-MARGIN>
					<CLEAR 0>
					<UPDATE-STATUS-LINE>
					<COND (<EQUAL? ,HERE ,MAZE>
					       <DISPLAY-MAZE>)>
					<COND (<QUEUED? I-SETUP-ANSWER>
					       <I-SETUP-ANSWER>
					       ;"interrupts won't run")>
					<TELL "[UNDO done.]" CR>)>>>
<REPLACE-DEFINITION	ROOMSBIT
			<CONSTANT ROOMSBIT RLANDBIT>>
<REPLACE-DEFINITION	SETUP-ORPHAN-NP
			<CONSTANT SETUP-ORPHAN-NP 0>>
<DELAY-DEFINITION	STATUS-LINE>
<DELAY-DEFINITION	YES?>

<COMPILATION-FLAG P-PS-COMMA T>
<TERMINALS (VERB 6) (NOUN 4) (ADJ 5)
	   ;ADV QUANT MISCWORD
	   (DIR 1) TOBE QWORD CANDO COMMA
	   (PARTICLE 3) (PREP 2) ;"keep these two in order! -- SWG"
	   ASKWORD
	   COMMA APOSTR OFWORD ARTICLE QUOTE>


<PROPDEF DIRECTIONS <>		;"direction defs for 'rooms-first'"
	 (DIR TO R:ROOM =
	  (UEXIT 1)	;444	#SEMI "UNCONDITIONAL EXIT"
	  (REXIT <ROOM .R>)	#SEMI "TO ROOM")
	 (DIR S:STRING =
	  (NEXIT 2)	;99	#SEMI "IMPOSSIBLE EXIT"
	  (NEXITSTR <STRING .S>) #SEMI "FAILURE MESSAGE")
	 (DIR SORRY S:STRING =
	  (NEXIT 2)		#SEMI "IMPOSSIBLE EXIT"
	  (NEXITSTR <STRING .S>) #SEMI "FAILURE MESSAGE")
	 (DIR PER F:FCN =
	  (FEXIT 3)	;53	#SEMI "CONDITIONAL EXIT"
	  (FEXITFCN <WORD .F>)	#SEMI "PER FUNCTION"
	  <BYTE 0>)
	 (DIR TO R:ROOM IF F:GLOBAL "OPT" ELSE S:STRING =
	  (CEXIT 4)	;7	#SEMI "CONDITIONAL EXIT"
	  (REXIT <ROOM .R>)	#SEMI "TO ROOM"
	  (CEXITFLAG <GLOBAL .F>) #SEMI "IF FLAG IS TRUE"
	  (CEXITSTR <STRING .S>) #SEMI "FAILURE MESSAGE")
	 (DIR TO R:ROOM IF O:OBJECT IS OPEN "OPT" ELSE S:STRING =
	  (DEXIT 5)	;15	#SEMI "CONDITIONAL EXIT"
	  (DEXITOBJ <OBJECT .O>) #SEMI "IF DOOR IS OPEN"
	  (DEXITSTR <STRING .S>) #SEMI "FAILURE MESSAGE"
	  (DEXITRM <ROOM .R>)	#SEMI "TO ROOM")>

<DIRECTIONS NORTH NE EAST SE SOUTH SW WEST NW
	    UP DOWN IN OUT FORE AFT PORT STARBOARD>

<SETG L-SEARCH-PATH (["P" ""] !,L-SEARCH-PATH)>

<REPLACE-DEFINITION WINNER-SAYS-WHICH?
	 <ROUTINE WINNER-SAYS-WHICH? (NP)
		  <RFATAL>>>

<REPLACE-DEFINITION INVALID-OBJECT?
<ROUTINE INVALID-OBJECT? (OBJ)
	 <COND (<NOT <LOC .OBJ>> <RTRUE>)
	       (<AND <NOT <IN? .OBJ ,GLOBAL-OBJECTS>>
		     <NOT <IN? .OBJ ,GENERIC-OBJECTS>>
		     <NOT <IN-SCENE? .OBJ>>>
		<RTRUE>)
	       (ELSE <RFALSE>)>>>

<REPLACE-DEFINITION VERB-ALL-TEST
<DEFINE VERB-ALL-TEST (O I "AUX" L)	;"O=PRSO I=PRSI"
 <SET L <LOC .O>>
 <COND (<EQUAL? ,PRSA ,V?DROP ,V?GIVE>
	<COND (<AND <EQUAL? .L ,WINNER>
		    <NOT <FSET? .L ,WEARBIT>>>
	       <RTRUE>)
	      (T <RFALSE>)>)
       (<EQUAL? ,PRSA ,V?PUT>
	<COND (<EQUAL? .O .I>
	       <RFALSE>)
	      (<NOT <IN? .O .I>>
	       <RTRUE>)
	      (T <RFALSE>)>)
       (<EQUAL? ,PRSA ,V?TAKE>
	<COND (<FSET? .O ,DONT-ALL> <RFALSE>)
	      (<FSET? .O ,WEARBIT> <RFALSE>)
	      (<AND <NOT <FSET? .O ,TAKEBIT>>
		    <NOT <FSET? .O ,TRYTAKEBIT>>>
	       <RFALSE>)>
	<COND (<NOT <ZERO? .I>>
	       <COND (<NOT <EQUAL? .L .I>>
		      <RFALSE>)>)
	      (<EQUAL? .L ;,WINNER ,HERE>
	       <RTRUE>)>
	<COND (<OR <FSET? .L ,PERSONBIT>
		   <FSET? .L ,SURFACEBIT>>
	       <RTRUE>)
	      (<AND <FSET? .L ,CONTBIT>
		    <FSET? .L ,OPENBIT>>
	       <RTRUE>)
	      (T <RFALSE>)>)
       (<AND <EQUAL? ,PRSA ,V?WEAR>
	     <NOT <FSET? .O ,WEARABLE>>>
	<RFALSE>)
       (<NOT <ZERO? .I>>
	<COND (<NOT <EQUAL? .O .I>>
	       <RTRUE>)
	      (T <RFALSE>)>)
       (T <RTRUE>)>>>

<REPLACE-DEFINITION SPECIAL-CONTRACTION?
 <VOC "FO">
 <VOC "C">
 <VOC "FOC">
 <VOC "SLE">
 <ROUTINE SPECIAL-CONTRACTION? (PTR)
	<COND (<AND <EQUAL? <ZGET .PTR 0> ,W?FO>
		    <EQUAL? <ZGET .PTR ,P-LEXELEN> ,W?APOSTROPHE>
		    <EQUAL? <ZGET .PTR <* 2 ,P-LEXELEN>> ,W?C>>
	       ,W?FOC)
	      (<AND <EQUAL? <ZGET .PTR 0> ,W?FOC>
		    <EQUAL? <ZGET .PTR ,P-LEXELEN> ,W?APOSTROPHE>
		    <EQUAL? <ZGET .PTR <* 2 ,P-LEXELEN>> ,W?SLE>>
	       ,W?FOCSLE)>>>

<REPLACE-DEFINITION SPEAKING-VERB?
 <DEFINE SPEAKING-VERB? ("OPT" (A ,PRSA) ;(PER 0))
 <COND (<EQUAL? .A ,V?ANSWER ,V?ASK-ABOUT ,V?ASK-FOR ,V?CURSE ,V?HELLO
		,V?NO ,V?REPLY ,V?SAY ,V?SPEAK ,V?TELL ,V?TELL-ABOUT
		,V?THANK ,V?THOU ,V?YELL ,V?YELL-AT ,V?YES>
	<COND (T ;<EQUAL? .PER 0 ,PRSO>
	       <RTRUE>)>)>>>

<REPLACE-DEFINITION CAPITAL-NOUN?
	<ROUTINE CAPITAL-NOUN? (WD)
		 <EQUAL? .WD 
,W?ACHIKO
,W?AKABO
,W?ALVITO
,W?BACCUS
,W?BLACKTHORNE
,W?BROWN
,W?BROWNS
,W?BUNTARO
,W?CAPTAIN
,W?CAPTAIN-GENERAL
,W?CHIMMOKO
,W?CROOCQ
,W?DANZENJI
,W?DOMINGO
,W?ENGLAND
,W?ERASMUS
,W?ETSU
,W?GINSEL
,W?GONZALEZ
,W?GORODA
,W?GRAY
,W?GRAYS
,W?GYOKO
,W?HENDRIK
,W?HIRO-MATSU
,W?HOLLAND
,W?I
,W?ISHIDO
,W?JAN
,W?JOHANN
,W?JOHN
,W?KASIGI
,W?KAZUNARI
,W?KIKU
,W?KIRI
,W?KIRITSUBO
,W?KIYAMA
,W?KOJIMA
,W?KWAMPAKU
,W?MAETSUKKER
,W?MARIKO
,W?MARTIN
,W?MAXIMILIAN
,W?MURA
,W?NAKAMURA
,W?NEKK
,W?OCHIBA
,W?OMI
,W?ONNA
,W?PAULUS
,W?PIETERZOON
,W?POPE,W?RODRIGUES
,W?ROPER
,W?SAIGAWA
,W?SALAMON
,W?SAZUKO
,W?SEBASTIO
,W?SHOGUN
,W?SONK
,W?SPECZ
,W?SPILLBERGEN
,W?SUMIYORI
,W?TAIKO
,W?TODA
,W?TORANAGA
,W?VASCO
,W?VINCK
,W?YABU
,W?YAEMON
,W?YAMAZAKI
,W?YOSHI
,W?YOSHINAKA
,W?ZATAKI
 >>>

<REPLACE-DEFINITION SOFT-KEY-DEFINITIONS
	<SOFT-KEYS
	 ,UP-ARROW "n"
	 ,DOWN-ARROW "s"
	 ,LEFT-ARROW "w"
	 ,RIGHT-ARROW "e"
	 ;"vt100 keypad keys"
	 ,F1 "examine " 
	 ,F2 "take "
	 ,F3 "wear "
	 ,F4 "bow to "
	 ,F5 "turn wheel to "
	 ,F6 "inventory"
	 ,F7 "nw"
	 ,F8 "ne"
	 ,F9 "se"
	 ,F10 "sw"
	 -1 0
	 -1 <TABLE "Save Definition File" SOFT-SAVE-DEFS>
	 -1 <TABLE "Restore Definition File" SOFT-RESTORE-DEFS>
	 -1 <TABLE "Reset Defaults" SOFT-RESET-DEFAULTS>
	 -1 <TABLE "Exit" SOFT-EXIT>>>
