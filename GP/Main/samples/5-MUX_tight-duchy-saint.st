(*
This code implements a shuffled multiplexer with 5 control bits.
The control bits are: Data[N21], Data[N20], Data[N2], Data[N1], Data[N3]
The input bits are: Data[N4], Data[N5], Data[N6], Data[N24], Data[N23], Data[N8], Data[N9], Data[N7], Data[N22], Data[N25], Data[N10], Data[N11], Data[N17], Data[N28], Data[N12], Data[N26], Data[N14], Data[N15], Data[N13], Data[N30], Data[N16], Data[N29], Data[N18], Data[N19], Data[N27], Data[N34], Data[N31], Data[N32], Data[N33], Data[N36], Data[N35], Data[N37]

The symbolic expression is:
((((((((((((((((((((((((((((((((!(((((!(IN21)) & (!(IN20))) & (!(IN2))) & (!(IN1))) & (!(IN3)))) | IN4) & ((!((((IN21 & (!(IN20))) & (!(IN2))) & (!(IN1))) & (!(IN3)))) | IN5)) & ((!(((((!(IN21)) & IN20) & (!(IN2))) & (!(IN1))) & (!(IN3)))) | IN6)) & ((!((((IN21 & IN20) & (!(IN2))) & (!(IN1))) & (!(IN3)))) | IN24)) & ((!(((((!(IN21)) & (!(IN20))) & IN2) & (!(IN1))) & (!(IN3)))) | IN23)) & ((!((((IN21 & (!(IN20))) & IN2) & (!(IN1))) & (!(IN3)))) | IN8)) & ((!(((((!(IN21)) & IN20) & IN2) & (!(IN1))) & (!(IN3)))) | IN9)) & ((!((((IN21 & IN20) & IN2) & (!(IN1))) & (!(IN3)))) | IN7)) & ((!(((((!(IN21)) & (!(IN20))) & (!(IN2))) & IN1) & (!(IN3)))) | IN22)) & ((!((((IN21 & (!(IN20))) & (!(IN2))) & IN1) & (!(IN3)))) | IN25)) & ((!(((((!(IN21)) & IN20) & (!(IN2))) & IN1) & (!(IN3)))) | IN10)) & ((!((((IN21 & IN20) & (!(IN2))) & IN1) & (!(IN3)))) | IN11)) & ((!(((((!(IN21)) & (!(IN20))) & IN2) & IN1) & (!(IN3)))) | IN17)) & ((!((((IN21 & (!(IN20))) & IN2) & IN1) & (!(IN3)))) | IN28)) & ((!(((((!(IN21)) & IN20) & IN2) & IN1) & (!(IN3)))) | IN12)) & ((!((((IN21 & IN20) & IN2) & IN1) & (!(IN3)))) | IN26)) & ((!(((((!(IN21)) & (!(IN20))) & (!(IN2))) & (!(IN1))) & IN3)) | IN14)) & ((!((((IN21 & (!(IN20))) & (!(IN2))) & (!(IN1))) & IN3)) | IN15)) & ((!(((((!(IN21)) & IN20) & (!(IN2))) & (!(IN1))) & IN3)) | IN13)) & ((!((((IN21 & IN20) & (!(IN2))) & (!(IN1))) & IN3)) | IN30)) & ((!(((((!(IN21)) & (!(IN20))) & IN2) & (!(IN1))) & IN3)) | IN16)) & ((!((((IN21 & (!(IN20))) & IN2) & (!(IN1))) & IN3)) | IN29)) & ((!(((((!(IN21)) & IN20) & IN2) & (!(IN1))) & IN3)) | IN18)) & ((!((((IN21 & IN20) & IN2) & (!(IN1))) & IN3)) | IN19)) & ((!(((((!(IN21)) & (!(IN20))) & (!(IN2))) & IN1) & IN3)) | IN27)) & ((!((((IN21 & (!(IN20))) & (!(IN2))) & IN1) & IN3)) | IN34)) & ((!(((((!(IN21)) & IN20) & (!(IN2))) & IN1) & IN3)) | IN31)) & ((!((((IN21 & IN20) & (!(IN2))) & IN1) & IN3)) | IN32)) & ((!(((((!(IN21)) & (!(IN20))) & IN2) & IN1) & IN3)) | IN33)) & ((!((((IN21 & (!(IN20))) & IN2) & IN1) & IN3)) | IN36)) & ((!(((((!(IN21)) & IN20) & IN2) & IN1) & IN3)) | IN35)) & ((!((((IN21 & IN20) & IN2) & IN1) & IN3)) | IN37)

*)

FUNCTION_BLOCK F_CollectInput
  VAR_IN_OUT
      Data : ARRAY[1..40] OF BOOL;
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
  Finished := (j > 40);
END_FUNCTION_BLOCK


PROGRAM Boiler
  VAR
    Data  : ARRAY[1..40] OF BOOL;
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
    Out := (((((((((((((((((((((((((((((((((NOT (((((NOT Data[21]) AND (NOT Data[20])) AND (NOT Data[2])) AND (NOT Data[1])) AND (NOT Data[3]))) OR Data[4]) AND ((NOT ((((Data[21] AND (NOT Data[20])) AND (NOT Data[2])) AND (NOT Data[1])) AND (NOT Data[3]))) OR Data[5])) AND ((NOT (((((NOT Data[21]) AND Data[20]) AND (NOT Data[2])) AND (NOT Data[1])) AND (NOT Data[3]))) OR Data[6])) AND ((NOT ((((Data[21] AND Data[20]) AND (NOT Data[2])) AND (NOT Data[1])) AND (NOT Data[3]))) OR Data[24])) AND ((NOT (((((NOT Data[21]) AND (NOT Data[20])) AND Data[2]) AND (NOT Data[1])) AND (NOT Data[3]))) OR Data[23])) AND ((NOT ((((Data[21] AND (NOT Data[20])) AND Data[2]) AND (NOT Data[1])) AND (NOT Data[3]))) OR Data[8])) AND ((NOT (((((NOT Data[21]) AND Data[20]) AND Data[2]) AND (NOT Data[1])) AND (NOT Data[3]))) OR Data[9])) AND ((NOT ((((Data[21] AND Data[20]) AND Data[2]) AND (NOT Data[1])) AND (NOT Data[3]))) OR Data[7])) AND ((NOT (((((NOT Data[21]) AND (NOT Data[20])) AND (NOT Data[2])) AND Data[1]) AND (NOT Data[3]))) OR Data[22])) AND ((NOT ((((Data[21] AND (NOT Data[20])) AND (NOT Data[2])) AND Data[1]) AND (NOT Data[3]))) OR Data[25])) AND ((NOT (((((NOT Data[21]) AND Data[20]) AND (NOT Data[2])) AND Data[1]) AND (NOT Data[3]))) OR Data[10])) AND ((NOT ((((Data[21] AND Data[20]) AND (NOT Data[2])) AND Data[1]) AND (NOT Data[3]))) OR Data[11])) AND ((NOT (((((NOT Data[21]) AND (NOT Data[20])) AND Data[2]) AND Data[1]) AND (NOT Data[3]))) OR Data[17])) AND ((NOT ((((Data[21] AND (NOT Data[20])) AND Data[2]) AND Data[1]) AND (NOT Data[3]))) OR Data[28])) AND ((NOT (((((NOT Data[21]) AND Data[20]) AND Data[2]) AND Data[1]) AND (NOT Data[3]))) OR Data[12])) AND ((NOT ((((Data[21] AND Data[20]) AND Data[2]) AND Data[1]) AND (NOT Data[3]))) OR Data[26])) AND ((NOT (((((NOT Data[21]) AND (NOT Data[20])) AND (NOT Data[2])) AND (NOT Data[1])) AND Data[3])) OR Data[14])) AND ((NOT ((((Data[21] AND (NOT Data[20])) AND (NOT Data[2])) AND (NOT Data[1])) AND Data[3])) OR Data[15])) AND ((NOT (((((NOT Data[21]) AND Data[20]) AND (NOT Data[2])) AND (NOT Data[1])) AND Data[3])) OR Data[13])) AND ((NOT ((((Data[21] AND Data[20]) AND (NOT Data[2])) AND (NOT Data[1])) AND Data[3])) OR Data[30])) AND ((NOT (((((NOT Data[21]) AND (NOT Data[20])) AND Data[2]) AND (NOT Data[1])) AND Data[3])) OR Data[16])) AND ((NOT ((((Data[21] AND (NOT Data[20])) AND Data[2]) AND (NOT Data[1])) AND Data[3])) OR Data[29])) AND ((NOT (((((NOT Data[21]) AND Data[20]) AND Data[2]) AND (NOT Data[1])) AND Data[3])) OR Data[18])) AND ((NOT ((((Data[21] AND Data[20]) AND Data[2]) AND (NOT Data[1])) AND Data[3])) OR Data[19])) AND ((NOT (((((NOT Data[21]) AND (NOT Data[20])) AND (NOT Data[2])) AND Data[1]) AND Data[3])) OR Data[27])) AND ((NOT ((((Data[21] AND (NOT Data[20])) AND (NOT Data[2])) AND Data[1]) AND Data[3])) OR Data[34])) AND ((NOT (((((NOT Data[21]) AND Data[20]) AND (NOT Data[2])) AND Data[1]) AND Data[3])) OR Data[31])) AND ((NOT ((((Data[21] AND Data[20]) AND (NOT Data[2])) AND Data[1]) AND Data[3])) OR Data[32])) AND ((NOT (((((NOT Data[21]) AND (NOT Data[20])) AND Data[2]) AND Data[1]) AND Data[3])) OR Data[33])) AND ((NOT ((((Data[21] AND (NOT Data[20])) AND Data[2]) AND Data[1]) AND Data[3])) OR Data[36])) AND ((NOT (((((NOT Data[21]) AND Data[20]) AND Data[2]) AND Data[1]) AND Data[3])) OR Data[35])) AND ((NOT ((((Data[21] AND Data[20]) AND Data[2]) AND Data[1]) AND Data[3])) OR Data[37]));
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
