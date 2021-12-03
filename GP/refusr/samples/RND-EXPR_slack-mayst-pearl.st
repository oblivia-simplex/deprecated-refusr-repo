(*
This code implements a randomly grown symbolic expression:

IN17 | (!(!((xor(xor(xor(xor(!(((IN42 | IN28) & IN28) | ((IN44 & IN38) | (xor(xor(IN20, IN19), IN29)))), xor(xor(!(xor(xor(IN18, IN32), IN1)), (xor(xor(!(IN28), IN23 | true), IN21 & IN35)) | (xor(xor(IN18 | IN17, IN20 & IN16), IN40 & IN14))), IN13)), xor(xor(xor(xor(IN41 & (!(IN16)), !(xor(xor(IN22, IN4), IN17))), IN6), ((IN31 & IN41) | (!(IN11))) & IN31), ((xor(xor(IN22, IN44), IN41)) & IN34) | ((xor(xor(IN15, IN11), IN36)) | IN35))), (!(xor(xor((IN11 & IN30) | (IN38 & false), !(xor(xor(IN41, IN7), IN16))), xor(xor(IN30 & IN43, !(IN24)), xor(xor(IN39, IN43), IN41))))) & ((xor(xor(xor(xor(!(IN23), !(IN26)), IN50), xor(xor(!(IN46), !(IN19)), IN3 & IN45)), IN18)) | (xor(xor(xor(xor(IN2 | IN38, IN7 & IN42), IN25), xor(xor(xor(xor(IN45, IN22), IN25), IN39 | IN11), xor(xor(IN39, false), IN22))), !(xor(xor(IN49, IN22), IN35)))))), xor(xor((!((!(IN26)) & (!(IN47)))) & (IN4 | ((IN20 & IN17) & IN25)), IN16), ((xor(xor(!(IN27), IN3), xor(xor(IN14, IN50), IN41))) | IN31) & (xor(xor(!(IN5 & IN37), (!(IN21)) | (xor(xor(IN22, IN34), IN26))), IN36))))) | (IN14 | ((IN6 & (xor(xor(IN41 | (IN46 & IN7), xor(xor(!(IN32), !(IN19)), xor(xor(IN6, IN15), IN15))), (xor(xor(IN7, IN12), IN31)) | IN24))) | (!(IN20)))))))

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
    Out := (Data[17] OR (NOT (NOT ((((((NOT (((Data[42] OR Data[28]) AND Data[28]) OR ((Data[44] AND Data[38]) OR ((Data[20] XOR Data[19]) XOR Data[29])))) XOR (((NOT ((Data[18] XOR Data[32]) XOR Data[1])) XOR ((((NOT Data[28]) XOR (Data[23] OR TRUE)) XOR (Data[21] AND Data[35])) OR (((Data[18] OR Data[17]) XOR (Data[20] AND Data[16])) XOR (Data[40] AND Data[14])))) XOR Data[13])) XOR (((((Data[41] AND (NOT Data[16])) XOR (NOT ((Data[22] XOR Data[4]) XOR Data[17]))) XOR Data[6]) XOR (((Data[31] AND Data[41]) OR (NOT Data[11])) AND Data[31])) XOR ((((Data[22] XOR Data[44]) XOR Data[41]) AND Data[34]) OR (((Data[15] XOR Data[11]) XOR Data[36]) OR Data[35])))) XOR ((NOT ((((Data[11] AND Data[30]) OR (Data[38] AND FALSE)) XOR (NOT ((Data[41] XOR Data[7]) XOR Data[16]))) XOR (((Data[30] AND Data[43]) XOR (NOT Data[24])) XOR ((Data[39] XOR Data[43]) XOR Data[41])))) AND ((((((NOT Data[23]) XOR (NOT Data[26])) XOR Data[50]) XOR (((NOT Data[46]) XOR (NOT Data[19])) XOR (Data[3] AND Data[45]))) XOR Data[18]) OR (((((Data[2] OR Data[38]) XOR (Data[7] AND Data[42])) XOR Data[25]) XOR ((((Data[45] XOR Data[22]) XOR Data[25]) XOR (Data[39] OR Data[11])) XOR ((Data[39] XOR FALSE) XOR Data[22]))) XOR (NOT ((Data[49] XOR Data[22]) XOR Data[35])))))) XOR ((((NOT ((NOT Data[26]) AND (NOT Data[47]))) AND (Data[4] OR ((Data[20] AND Data[17]) AND Data[25]))) XOR Data[16]) XOR (((((NOT Data[27]) XOR Data[3]) XOR ((Data[14] XOR Data[50]) XOR Data[41])) OR Data[31]) AND (((NOT (Data[5] AND Data[37])) XOR ((NOT Data[21]) OR ((Data[22] XOR Data[34]) XOR Data[26]))) XOR Data[36])))) OR (Data[14] OR ((Data[6] AND (((Data[41] OR (Data[46] AND Data[7])) XOR (((NOT Data[32]) XOR (NOT Data[19])) XOR ((Data[6] XOR Data[15]) XOR Data[15]))) XOR (((Data[7] XOR Data[12]) XOR Data[31]) OR Data[24]))) OR (NOT Data[20])))))));
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
