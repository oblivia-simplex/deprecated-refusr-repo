(*
This code implements a shuffled multiplexer with 4 control bits.
The control bits are: Data[N1], Data[N4], Data[N3], Data[N6]
The input bits are: Data[N2], Data[N7], Data[N5], Data[N8], Data[N12], Data[N10], Data[N13], Data[N9], Data[N15], Data[N11], Data[N14], Data[N17], Data[N16], Data[N20], Data[N19], Data[N18]

The symbolic expression is:
((((((((((((((((!((((!(IN1)) & (!(IN4))) & (!(IN3))) & (!(IN6)))) | IN2) & ((!(((IN1 & (!(IN4))) & (!(IN3))) & (!(IN6)))) | IN7)) & ((!((((!(IN1)) & IN4) & (!(IN3))) & (!(IN6)))) | IN5)) & ((!(((IN1 & IN4) & (!(IN3))) & (!(IN6)))) | IN8)) & ((!((((!(IN1)) & (!(IN4))) & IN3) & (!(IN6)))) | IN12)) & ((!(((IN1 & (!(IN4))) & IN3) & (!(IN6)))) | IN10)) & ((!((((!(IN1)) & IN4) & IN3) & (!(IN6)))) | IN13)) & ((!(((IN1 & IN4) & IN3) & (!(IN6)))) | IN9)) & ((!((((!(IN1)) & (!(IN4))) & (!(IN3))) & IN6)) | IN15)) & ((!(((IN1 & (!(IN4))) & (!(IN3))) & IN6)) | IN11)) & ((!((((!(IN1)) & IN4) & (!(IN3))) & IN6)) | IN14)) & ((!(((IN1 & IN4) & (!(IN3))) & IN6)) | IN17)) & ((!((((!(IN1)) & (!(IN4))) & IN3) & IN6)) | IN16)) & ((!(((IN1 & (!(IN4))) & IN3) & IN6)) | IN20)) & ((!((((!(IN1)) & IN4) & IN3) & IN6)) | IN19)) & ((!(((IN1 & IN4) & IN3) & IN6)) | IN18)

*)

FUNCTION_BLOCK F_CollectInput
  VAR_IN_OUT
      Data : ARRAY[1..20] OF BOOL;
  END_VAR
  VAR_INPUT
      TICK  : BOOL := 0;
      IN1   : BOOL := 0;
      IN2   : BOOL := 0;
      IN3   : BOOL := 0;
      IN4   : BOOL := 0;
      IN5   : BOOL := 0;
      RESET : BOOL := FALSE;
  END_VAR
  VAR_OUTPUT
      Finished : BOOL;
  END_VAR
  VAR
      j    : USINT := 1;
      tock : BOOL  := 0;
  END_VAR
  IF NOT RESET AND tock = NOT TICK THEN
      Data[j]   := IN1;
      Data[j+1] := IN2;
      Data[j+2] := IN3;
      Data[j+3] := IN4;
      Data[j+4] := IN5;
      j := j + 5;
      tock := TICK;
  ELSE
      j := 1;
      tock := 0;
  END_IF;
  Finished := (j > 20);
END_FUNCTION_BLOCK


PROGRAM Boiler
  VAR
    Data  : ARRAY[1..20] OF BOOL;
    Ready : BOOL;
    CollectInput : F_CollectInput;
  END_VAR
  VAR
    TICK     AT %IX1.0 : BOOL;
    IN1      AT %IX0.3 : BOOL;
    IN2      AT %IX0.4 : BOOL;
    IN3      AT %IX0.5 : BOOL;
    IN4      AT %IX0.6 : BOOL;
    IN5      AT %IX0.7 : BOOL;
    OutReady AT %QX0.0 : BOOL := FALSE;
    FeedNext AT %QX0.1 : BOOL := FALSE;
    Out      AT %QX0.2 : BOOL;
  END_VAR
  CollectInput(TICK:=TICK, IN1:=IN1, IN2:=IN2, IN3:=IN3, IN4:=IN4, IN5:=IN5);
  Ready := CollectInput.Finished;
  FeedNext := 1;
  IF Ready THEN
    Out := (((((((((((((((((NOT ((((NOT Data[1]) AND (NOT Data[4])) AND (NOT Data[3])) AND (NOT Data[6]))) OR Data[2]) AND ((NOT (((Data[1] AND (NOT Data[4])) AND (NOT Data[3])) AND (NOT Data[6]))) OR Data[7])) AND ((NOT ((((NOT Data[1]) AND Data[4]) AND (NOT Data[3])) AND (NOT Data[6]))) OR Data[5])) AND ((NOT (((Data[1] AND Data[4]) AND (NOT Data[3])) AND (NOT Data[6]))) OR Data[8])) AND ((NOT ((((NOT Data[1]) AND (NOT Data[4])) AND Data[3]) AND (NOT Data[6]))) OR Data[12])) AND ((NOT (((Data[1] AND (NOT Data[4])) AND Data[3]) AND (NOT Data[6]))) OR Data[10])) AND ((NOT ((((NOT Data[1]) AND Data[4]) AND Data[3]) AND (NOT Data[6]))) OR Data[13])) AND ((NOT (((Data[1] AND Data[4]) AND Data[3]) AND (NOT Data[6]))) OR Data[9])) AND ((NOT ((((NOT Data[1]) AND (NOT Data[4])) AND (NOT Data[3])) AND Data[6])) OR Data[15])) AND ((NOT (((Data[1] AND (NOT Data[4])) AND (NOT Data[3])) AND Data[6])) OR Data[11])) AND ((NOT ((((NOT Data[1]) AND Data[4]) AND (NOT Data[3])) AND Data[6])) OR Data[14])) AND ((NOT (((Data[1] AND Data[4]) AND (NOT Data[3])) AND Data[6])) OR Data[17])) AND ((NOT ((((NOT Data[1]) AND (NOT Data[4])) AND Data[3]) AND Data[6])) OR Data[16])) AND ((NOT (((Data[1] AND (NOT Data[4])) AND Data[3]) AND Data[6])) OR Data[20])) AND ((NOT ((((NOT Data[1]) AND Data[4]) AND Data[3]) AND Data[6])) OR Data[19])) AND ((NOT (((Data[1] AND Data[4]) AND Data[3]) AND Data[6])) OR Data[18]));
    OutReady := 1;
    CollectInput(RESET:=TRUE);
  END_IF;
END_PROGRAM


CONFIGURATION Config0
  RESOURCE Res0 ON PLC
    TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
    PROGRAM instance0 WITH task0 : Boiler;
  END_RESOURCE
END_CONFIGURATION
