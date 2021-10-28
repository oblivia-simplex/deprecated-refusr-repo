(*
This code implements a randomly grown symbolic expression:

((xor(xor(IN45 & (!(((xor(xor((IN12 | IN39) & (IN49 & IN44), (xor(xor(IN32, IN2), IN29)) | (!(IN23))), !(IN43))) & ((xor(xor(!(IN34), xor(xor(IN7, IN24), IN32)), IN44 & IN23)) & (!(IN26 | IN12)))) & (xor(xor(true, (!(!(IN14))) | IN32), !((IN3 | IN34) & (xor(xor(true, IN16), IN29))))))), (true & (xor(xor(!(IN12), IN38 & ((!(IN22 & IN30)) & ((IN49 & IN6) & (xor(xor(IN28, IN16), IN47))))), IN30))) | (IN20 | (!(!(xor(xor((xor(xor(IN18, IN11), IN44)) | (IN1 | IN1), !(!(IN21))), xor(xor(!(IN27), IN8 | IN35), IN10 | IN21))))))), (IN35 | (!((!(xor(xor(!(IN11), xor(xor(IN5, IN39), IN18)), IN48 | IN49))) & (xor(xor(!(IN2 & IN40), !(IN47 & IN16)), !(xor(xor(IN48, IN6), IN12))))))) & false)) & IN28) | ((!(((((xor(xor(xor(xor(xor(xor(IN26, IN40), IN46), IN25), IN34 & IN49), (!(IN22)) & (!(IN24))), IN22)) & (((IN44 | IN23) & IN20) & (!(IN14 | IN43)))) | IN43) & ((xor(xor(IN5, (xor(xor(IN37, IN49 & IN28), xor(xor(IN22, IN20), IN30))) | ((!(IN46)) | (IN7 | IN28))), (!(IN11 | IN38)) & IN28)) | (!(IN6)))) | (xor(xor(IN22, !((((xor(xor(IN22, IN46), IN13)) | (xor(xor(IN33, IN13), IN13))) & IN3) & (xor(xor((!(IN19)) & (IN23 & IN43), IN9), !(IN47 | IN16))))), xor(xor(((xor(xor(IN41 | IN8, IN31), IN20 | IN5)) & IN33) & (xor(xor(!(IN34), (IN44 | true) & (IN24 | IN13)), IN19)), !(IN24)), !(IN43)))))) & IN28)

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
    Out := (((((Data[45] AND (NOT ((((((Data[12] OR Data[39]) AND (Data[49] AND Data[44])) XOR (((Data[32] XOR Data[2]) XOR Data[29]) OR (NOT Data[23]))) XOR (NOT Data[43])) AND ((((NOT Data[34]) XOR ((Data[7] XOR Data[24]) XOR Data[32])) XOR (Data[44] AND Data[23])) AND (NOT (Data[26] OR Data[12])))) AND ((TRUE XOR ((NOT (NOT Data[14])) OR Data[32])) XOR (NOT ((Data[3] OR Data[34]) AND ((TRUE XOR Data[16]) XOR Data[29]))))))) XOR ((TRUE AND (((NOT Data[12]) XOR (Data[38] AND ((NOT (Data[22] AND Data[30])) AND ((Data[49] AND Data[6]) AND ((Data[28] XOR Data[16]) XOR Data[47]))))) XOR Data[30])) OR (Data[20] OR (NOT (NOT (((((Data[18] XOR Data[11]) XOR Data[44]) OR (Data[1] OR Data[1])) XOR (NOT (NOT Data[21]))) XOR (((NOT Data[27]) XOR (Data[8] OR Data[35])) XOR (Data[10] OR Data[21])))))))) XOR ((Data[35] OR (NOT ((NOT (((NOT Data[11]) XOR ((Data[5] XOR Data[39]) XOR Data[18])) XOR (Data[48] OR Data[49]))) AND (((NOT (Data[2] AND Data[40])) XOR (NOT (Data[47] AND Data[16]))) XOR (NOT ((Data[48] XOR Data[6]) XOR Data[12])))))) AND FALSE)) AND Data[28]) OR ((NOT ((((((((((Data[26] XOR Data[40]) XOR Data[46]) XOR Data[25]) XOR (Data[34] AND Data[49])) XOR ((NOT Data[22]) AND (NOT Data[24]))) XOR Data[22]) AND (((Data[44] OR Data[23]) AND Data[20]) AND (NOT (Data[14] OR Data[43])))) OR Data[43]) AND (((Data[5] XOR (((Data[37] XOR (Data[49] AND Data[28])) XOR ((Data[22] XOR Data[20]) XOR Data[30])) OR ((NOT Data[46]) OR (Data[7] OR Data[28])))) XOR ((NOT (Data[11] OR Data[38])) AND Data[28])) OR (NOT Data[6]))) OR ((Data[22] XOR (NOT (((((Data[22] XOR Data[46]) XOR Data[13]) OR ((Data[33] XOR Data[13]) XOR Data[13])) AND Data[3]) AND ((((NOT Data[19]) AND (Data[23] AND Data[43])) XOR Data[9]) XOR (NOT (Data[47] OR Data[16])))))) XOR (((((((Data[41] OR Data[8]) XOR Data[31]) XOR (Data[20] OR Data[5])) AND Data[33]) AND (((NOT Data[34]) XOR ((Data[44] OR TRUE) AND (Data[24] OR Data[13]))) XOR Data[19])) XOR (NOT Data[24])) XOR (NOT Data[43]))))) AND Data[28]));
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
