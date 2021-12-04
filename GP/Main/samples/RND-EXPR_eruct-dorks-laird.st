(*
This code implements a randomly grown symbolic expression:

(IN21 & (xor(xor(((IN15 | (xor(xor(((xor(xor(IN46, IN46), IN48)) & (IN48 & IN37)) | (xor(xor(IN13 & IN17, IN18 | IN36), IN43)), (!(IN20 & IN16)) & (true & IN10)), xor(xor((IN8 & IN24) & (IN6 | IN40), (IN20 | IN43) & (!(IN22))), IN27 & (IN16 & IN29))))) | (IN7 & IN37)) | ((xor(xor(IN49, IN22), ((!(!(IN10))) & IN12) & (((IN2 | IN15) | (IN30 | IN34)) | (!(IN42 & IN45))))) & ((!(xor(xor(IN33 & IN39, (IN12 & IN13) & (IN8 | IN38)), (!(IN4)) | (!(IN49))))) | (!(!((IN44 | IN30) & IN11))))), xor(xor(((!(xor(xor(IN49 | (IN16 | IN40), (IN21 | IN13) & IN42), !(IN49 & IN21)))) | IN48) | (xor(xor(IN9, (((IN32 | IN17) & (!(IN31))) & ((!(IN28)) & (IN43 | IN29))) & (true & ((xor(xor(false, IN29), IN12)) & (IN14 & IN39)))), !(!(xor(xor(IN17, !(IN48)), IN15 & IN25))))), IN29), (((xor(xor(xor(xor(IN40, IN33 & IN22), IN31 | IN14), IN27), (!(IN9)) & (xor(xor(IN25, IN49), IN10)))) | ((xor(xor(!(IN2), IN1), IN6 & IN12)) | IN35)) | ((xor(xor(IN27, !(!(IN28))), IN33)) & (!((!(IN11)) | (!(IN46)))))) | (xor(xor(IN28, IN39), !(xor(xor(!(IN49), xor(xor(xor(xor(IN46, IN9), IN37), IN36), IN35 | IN27)), xor(xor(IN8 | IN24, IN20 & IN28), IN20))))))), IN25))) & IN46

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
    Out := ((Data[21] AND (((((Data[15] OR ((((((Data[46] XOR Data[46]) XOR Data[48]) AND (Data[48] AND Data[37])) OR (((Data[13] AND Data[17]) XOR (Data[18] OR Data[36])) XOR Data[43])) XOR ((NOT (Data[20] AND Data[16])) AND (TRUE AND Data[10]))) XOR ((((Data[8] AND Data[24]) AND (Data[6] OR Data[40])) XOR ((Data[20] OR Data[43]) AND (NOT Data[22]))) XOR (Data[27] AND (Data[16] AND Data[29]))))) OR (Data[7] AND Data[37])) OR (((Data[49] XOR Data[22]) XOR (((NOT (NOT Data[10])) AND Data[12]) AND (((Data[2] OR Data[15]) OR (Data[30] OR Data[34])) OR (NOT (Data[42] AND Data[45]))))) AND ((NOT (((Data[33] AND Data[39]) XOR ((Data[12] AND Data[13]) AND (Data[8] OR Data[38]))) XOR ((NOT Data[4]) OR (NOT Data[49])))) OR (NOT (NOT ((Data[44] OR Data[30]) AND Data[11])))))) XOR (((((NOT (((Data[49] OR (Data[16] OR Data[40])) XOR ((Data[21] OR Data[13]) AND Data[42])) XOR (NOT (Data[49] AND Data[21])))) OR Data[48]) OR ((Data[9] XOR ((((Data[32] OR Data[17]) AND (NOT Data[31])) AND ((NOT Data[28]) AND (Data[43] OR Data[29]))) AND (TRUE AND (((FALSE XOR Data[29]) XOR Data[12]) AND (Data[14] AND Data[39]))))) XOR (NOT (NOT ((Data[17] XOR (NOT Data[48])) XOR (Data[15] AND Data[25])))))) XOR Data[29]) XOR (((((((Data[40] XOR (Data[33] AND Data[22])) XOR (Data[31] OR Data[14])) XOR Data[27]) XOR ((NOT Data[9]) AND ((Data[25] XOR Data[49]) XOR Data[10]))) OR ((((NOT Data[2]) XOR Data[1]) XOR (Data[6] AND Data[12])) OR Data[35])) OR (((Data[27] XOR (NOT (NOT Data[28]))) XOR Data[33]) AND (NOT ((NOT Data[11]) OR (NOT Data[46]))))) OR ((Data[28] XOR Data[39]) XOR (NOT (((NOT Data[49]) XOR ((((Data[46] XOR Data[9]) XOR Data[37]) XOR Data[36]) XOR (Data[35] OR Data[27]))) XOR (((Data[8] OR Data[24]) XOR (Data[20] AND Data[28])) XOR Data[20]))))))) XOR Data[25])) AND Data[46]);
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
