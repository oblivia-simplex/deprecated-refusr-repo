(*
This code implements a randomly grown symbolic expression:

((!(xor(xor(xor(xor(IN36, (!((!(xor(xor(IN22, IN23), IN42))) & (!(IN43 & IN13)))) & IN27), IN22), !(!((xor(xor(xor(xor(xor(xor(IN41, IN40), IN6), IN18 | IN25), xor(xor(IN48, IN48), IN11)), !(IN30 & IN33)), (!(IN46)) | (xor(xor(IN33, IN43), IN34)))) | (((IN2 | IN35) & (IN31 & IN45)) & ((IN24 & IN42) | (IN23 & IN28)))))), (IN14 | IN11) & (xor(xor((!(IN19)) & (!((IN6 & IN28) | IN32)), (!(!(IN33 | IN45))) & (((xor(xor(IN46, IN13), IN17)) & (!(IN24))) | (!(IN36 | IN10)))), xor(xor(IN11, IN45 | ((xor(xor(IN34, IN31), IN18)) & (!(IN24)))), !(!(!(IN48))))))))) | (xor(xor(xor(xor(xor(xor(IN27, IN7), IN45), IN36), IN7 | ((xor(xor(((IN17 & IN37) | (IN41 | IN20)) & (!(xor(xor(IN28, IN28), IN43))), IN41 & ((IN50 | IN20) | (IN16 & IN43))), (xor(xor(IN30, IN46), IN5 & IN10)) & ((!(IN22)) & (xor(xor(IN9, true), IN2))))) | (!(xor(xor(xor(xor(!(IN44), !(IN39)), !(IN14)), (!(IN21)) | (!(IN50))), xor(xor(xor(xor(IN6, IN4), IN36), IN25 & IN10), !(IN34))))))), IN29), (!(IN30)) & IN6))) & IN10

*)

FUNCTION_BLOCK F_CollectInput
  VAR_IN_OUT
      Data : ARRAY[1..50] OF BOOL;
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
  Finished := (j > 50);
END_FUNCTION_BLOCK


PROGRAM Boiler
  VAR
    Data  : ARRAY[1..50] OF BOOL;
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
    Out := (((NOT ((((Data[36] XOR ((NOT ((NOT ((Data[22] XOR Data[23]) XOR Data[42])) AND (NOT (Data[43] AND Data[13])))) AND Data[27])) XOR Data[22]) XOR (NOT (NOT (((((((Data[41] XOR Data[40]) XOR Data[6]) XOR (Data[18] OR Data[25])) XOR ((Data[48] XOR Data[48]) XOR Data[11])) XOR (NOT (Data[30] AND Data[33]))) XOR ((NOT Data[46]) OR ((Data[33] XOR Data[43]) XOR Data[34]))) OR (((Data[2] OR Data[35]) AND (Data[31] AND Data[45])) AND ((Data[24] AND Data[42]) OR (Data[23] AND Data[28]))))))) XOR ((Data[14] OR Data[11]) AND ((((NOT Data[19]) AND (NOT ((Data[6] AND Data[28]) OR Data[32]))) XOR ((NOT (NOT (Data[33] OR Data[45]))) AND ((((Data[46] XOR Data[13]) XOR Data[17]) AND (NOT Data[24])) OR (NOT (Data[36] OR Data[10]))))) XOR ((Data[11] XOR (Data[45] OR (((Data[34] XOR Data[31]) XOR Data[18]) AND (NOT Data[24])))) XOR (NOT (NOT (NOT Data[48])))))))) OR ((((((Data[27] XOR Data[7]) XOR Data[45]) XOR Data[36]) XOR (Data[7] OR ((((((Data[17] AND Data[37]) OR (Data[41] OR Data[20])) AND (NOT ((Data[28] XOR Data[28]) XOR Data[43]))) XOR (Data[41] AND ((Data[50] OR Data[20]) OR (Data[16] AND Data[43])))) XOR (((Data[30] XOR Data[46]) XOR (Data[5] AND Data[10])) AND ((NOT Data[22]) AND ((Data[9] XOR TRUE) XOR Data[2])))) OR (NOT (((((NOT Data[44]) XOR (NOT Data[39])) XOR (NOT Data[14])) XOR ((NOT Data[21]) OR (NOT Data[50]))) XOR ((((Data[6] XOR Data[4]) XOR Data[36]) XOR (Data[25] AND Data[10])) XOR (NOT Data[34]))))))) XOR Data[29]) XOR ((NOT Data[30]) AND Data[6]))) AND Data[10]);
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
