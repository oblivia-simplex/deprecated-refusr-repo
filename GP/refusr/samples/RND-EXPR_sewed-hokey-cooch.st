(*
This code implements a randomly grown symbolic expression:

!(((!(IN1)) | (xor(xor(!(IN4 | (!(xor(xor((!(IN21)) | (IN10 | IN34), (IN32 & IN39) & (xor(xor(IN33, IN21), IN30))), !(IN10 & IN16))))), !(!(!(xor(xor(IN12 & (!(IN27)), xor(xor(IN33 | IN30, IN41 & IN39), !(IN28))), IN32))))), xor(xor(!(!(IN49)), xor(xor((((IN3 & IN10) | (IN5 & IN27)) | IN6) & (IN43 | (xor(xor(IN8 | IN6, IN18 | IN20), IN22))), ((xor(xor(!(IN49), xor(xor(IN25, IN15), IN10)), xor(xor(IN36, IN47), IN50))) & false) | (!(xor(xor(!(IN13), IN25), xor(xor(IN8, IN43), IN45))))), IN44)), !(xor(xor(xor(xor((IN50 | IN36) | IN39, IN13), IN21), IN46 & IN31), IN9)))))) & (xor(xor(!((!(IN49)) | (xor(xor(!(IN31), IN49), (xor(xor(IN13, (xor(xor(IN6, IN49), IN32)) & (xor(xor(IN30, IN18), IN32))), IN42 | (IN13 | IN3))) & IN32))), ((!(xor(xor(xor(xor(IN31, IN16 | (!(IN20))), (true | IN11) | (IN30 & IN6)), ((xor(xor(IN5, IN18), IN47)) | (xor(xor(IN35, IN32), IN7))) & (!(IN35 | IN25))), (xor(xor(IN45 | IN27, !(IN16)), IN28 & IN24)) & ((IN12 | IN15) | (!(IN26)))))) & (!(IN14 & (((IN50 | IN36) & (!(IN18))) | (xor(xor(false, IN20 | IN26), IN25 | IN46)))))) & (!(IN16))), !((xor(xor((xor(xor((xor(xor(IN18, IN5), IN4)) & (IN10 | IN28), (IN14 | IN50) & (xor(xor(IN31, IN38), IN9))), (IN6 | IN10) | (IN46 | IN30))) | IN8, xor(xor((IN26 & (xor(xor(IN38, IN2), IN26))) & IN24, xor(xor(IN39, (xor(xor(IN4, IN26), IN46)) & (IN21 | IN23)), (IN46 | IN28) & (IN43 & IN9))), IN47)), (!((xor(xor(IN32, IN28), IN18)) & (IN11 & IN35))) & (((xor(xor(IN50, false), IN45)) & IN3) | (xor(xor(IN8, IN14 & IN13), IN48))))) | (((!(IN19)) | (IN26 & (!(!(IN22))))) & IN12)))))

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
    Out := (NOT (((NOT Data[1]) OR (((NOT (Data[4] OR (NOT ((((NOT Data[21]) OR (Data[10] OR Data[34])) XOR ((Data[32] AND Data[39]) AND ((Data[33] XOR Data[21]) XOR Data[30]))) XOR (NOT (Data[10] AND Data[16])))))) XOR (NOT (NOT (NOT (((Data[12] AND (NOT Data[27])) XOR (((Data[33] OR Data[30]) XOR (Data[41] AND Data[39])) XOR (NOT Data[28]))) XOR Data[32]))))) XOR (((NOT (NOT Data[49])) XOR ((((((Data[3] AND Data[10]) OR (Data[5] AND Data[27])) OR Data[6]) AND (Data[43] OR (((Data[8] OR Data[6]) XOR (Data[18] OR Data[20])) XOR Data[22]))) XOR (((((NOT Data[49]) XOR ((Data[25] XOR Data[15]) XOR Data[10])) XOR ((Data[36] XOR Data[47]) XOR Data[50])) AND FALSE) OR (NOT (((NOT Data[13]) XOR Data[25]) XOR ((Data[8] XOR Data[43]) XOR Data[45]))))) XOR Data[44])) XOR (NOT ((((((Data[50] OR Data[36]) OR Data[39]) XOR Data[13]) XOR Data[21]) XOR (Data[46] AND Data[31])) XOR Data[9]))))) AND (((NOT ((NOT Data[49]) OR (((NOT Data[31]) XOR Data[49]) XOR (((Data[13] XOR (((Data[6] XOR Data[49]) XOR Data[32]) AND ((Data[30] XOR Data[18]) XOR Data[32]))) XOR (Data[42] OR (Data[13] OR Data[3]))) AND Data[32])))) XOR (((NOT ((((Data[31] XOR (Data[16] OR (NOT Data[20]))) XOR ((TRUE OR Data[11]) OR (Data[30] AND Data[6]))) XOR ((((Data[5] XOR Data[18]) XOR Data[47]) OR ((Data[35] XOR Data[32]) XOR Data[7])) AND (NOT (Data[35] OR Data[25])))) XOR ((((Data[45] OR Data[27]) XOR (NOT Data[16])) XOR (Data[28] AND Data[24])) AND ((Data[12] OR Data[15]) OR (NOT Data[26]))))) AND (NOT (Data[14] AND (((Data[50] OR Data[36]) AND (NOT Data[18])) OR ((FALSE XOR (Data[20] OR Data[26])) XOR (Data[25] OR Data[46])))))) AND (NOT Data[16]))) XOR (NOT (((((((((Data[18] XOR Data[5]) XOR Data[4]) AND (Data[10] OR Data[28])) XOR ((Data[14] OR Data[50]) AND ((Data[31] XOR Data[38]) XOR Data[9]))) XOR ((Data[6] OR Data[10]) OR (Data[46] OR Data[30]))) OR Data[8]) XOR ((((Data[26] AND ((Data[38] XOR Data[2]) XOR Data[26])) AND Data[24]) XOR ((Data[39] XOR (((Data[4] XOR Data[26]) XOR Data[46]) AND (Data[21] OR Data[23]))) XOR ((Data[46] OR Data[28]) AND (Data[43] AND Data[9])))) XOR Data[47])) XOR ((NOT (((Data[32] XOR Data[28]) XOR Data[18]) AND (Data[11] AND Data[35]))) AND ((((Data[50] XOR FALSE) XOR Data[45]) AND Data[3]) OR ((Data[8] XOR (Data[14] AND Data[13])) XOR Data[48])))) OR (((NOT Data[19]) OR (Data[26] AND (NOT (NOT Data[22])))) AND Data[12]))))));
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
