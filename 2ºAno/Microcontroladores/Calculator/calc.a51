#include <at89c51xd2.inc>

CSEG AT 0H
	
JMP SETUP

STATE DATA 30H
NEXT_STATE DATA 31H
K_LOAD EQU P3.3
K_SET EQU P3.5
DSS EQU P1
RES EQU P0
OP2 EQU P2
S_READY EQU 0H
S_SELECT EQU 1H
S_OP2 EQU 2H
S_PROCESS EQU 3H

TABLE:
	DB 05H, 0A4H, 03CH, 0C4H

SETUP:
	SETB K_LOAD
	SETB K_SET
	;MOV STATE, #S_READY
	MOV NEXT_STATE, #S_READY
	
MAIN:
	JB K_LOAD, $
	JNB K_LOAD, $		;Mantem-se aqui caso load nao seja pressionado.
	MOV A, NEXT_STATE
	INC A
	MOV DPTR, #JUMP_TABLE
	RL A
	JMP @A+DPTR
		
PRINT_STATE:
	MOV DPTR, #TABLE
	MOVC A, @A+DPTR 
	MOV P1, A
	RET
JUMP_TABLE:
	AJMP STATE_READY
	AJMP STATE_SELECT
	AJMP STATE_OP2
	AJMP STATE_PROCESS
	
STATE_READY:
	MOV A, #S_READY
	CALL PRINT_STATE
	MOV NEXT_STATE, #S_SELECT
	JMP MAIN

STATE_SELECT:
	MOV A, #S_SELECT
	CALL PRINT_STATE
	MOV NEXT_STATE, #S_OP2
	JMP MAIN
	
STATE_OP2:
	MOV A, #S_OP2
	CALL PRINT_STATE
	MOV NEXT_STATE, #S_PROCESS
	JMP MAIN
	
STATE_PROCESS:
	MOV A, #S_PROCESS
	CALL PRINT_STATE
	MOV NEXT_STATE, #S_READY
	JMP MAIN
END