(*
This code implements a randomly grown symbolic expression:

xor(xor(!((((IN19 | ((!(xor(xor(IN42 | IN9, IN18), IN43))) & (IN45 & (!(xor(xor(IN20, IN7), IN15)))))) | (xor(xor(IN2, (((xor(xor(IN43, IN1), IN41)) | (xor(xor(IN13, IN45), IN31))) & ((IN14 & IN3) | (IN11 | IN19))) | IN16), IN5 | IN40))) & IN38) & (IN44 | (IN29 & IN45))), xor(xor(IN21, IN35 & (!(IN21))), (!(xor(xor(xor(xor((!(IN16 | (xor(xor(IN8, IN25), IN37)))) & IN21, IN12), (!((IN32 & IN11) & (IN26 | IN3))) | (xor(xor(xor(xor(IN18 | IN31, IN48 | IN23), IN26 & IN42), !(IN24)), (IN22 & IN13) & (IN25 | IN12)))), IN16), IN13))) | (((!((((IN13 & IN39) & (!(IN34))) | IN2) | (!(!(xor(xor(IN23, IN32), IN28)))))) | (xor(xor(xor(xor((xor(xor(IN38 & IN21, IN45 | IN35), IN21 & IN26)) | IN1, ((IN23 | IN23) | IN17) & (!(IN20 & IN9))), IN39), !(!(xor(xor(IN26 & IN43, IN40 & IN33), false | IN33)))), IN49))) | IN3))), (!(!(!(IN2 & IN26)))) & (xor(xor((xor(xor((xor(xor(IN27, xor(xor(IN42 & (!(IN35)), (IN3 | IN32) & (IN4 | IN35)), (!(IN32)) & IN47)), (xor(xor(xor(xor(IN13, IN2), IN28), IN9 | IN42), !(IN30))) | ((IN9 | IN14) & (IN44 & IN28)))) & (!(IN21 | ((IN1 | IN41) & (IN6 | IN3)))), !(((!(IN41)) | IN41) & (IN13 | ((IN13 & IN10) & (xor(xor(IN27, IN13), IN7)))))), !(xor(xor(IN18, IN9), (!(IN38 & IN26)) & (xor(xor(IN21 | IN41, xor(xor(IN23, IN37), IN28)), !(IN7))))))) & ((!(xor(xor((IN17 & (!(IN29))) & ((IN22 & IN31) | (xor(xor(IN13, IN47), IN2))), ((!(IN7)) | IN4) | (xor(xor(!(IN19), !(IN19)), IN31))), !((xor(xor(IN8, IN12), false)) & (IN25 | IN21))))) & (IN5 | (xor(xor(xor(xor(xor(xor(xor(xor(IN14, IN16), IN50), IN9), IN44), xor(xor(xor(xor(IN19, IN1), IN13), IN2 & IN36), IN40)), !(IN10 | IN39)), IN20), (IN4 & (!(IN21))) & (IN8 | (IN30 & IN12)))))), (xor(xor((!((xor(xor(IN50 | IN6, IN28 & IN9), IN23)) | (xor(xor(IN41 | IN44, IN7 | IN29), !(IN26))))) | (((xor(xor(IN4, IN43 | IN10), IN17 & IN40)) & ((IN49 & IN39) & (xor(xor(IN18, IN39), IN12)))) & (!(IN11 & (IN26 | IN30)))), IN13), IN2 | ((((xor(xor(IN32, IN41), IN4)) & IN43) & ((IN18 | IN10) | (xor(xor(IN22, IN16), IN42)))) & (IN22 | (xor(xor(IN18 & IN35, IN14), IN20 & IN8)))))) & (((xor(xor(((IN6 & IN44) | (xor(xor(IN11, IN45), true))) | IN11, true), xor(xor((xor(xor(IN8, true), IN25)) & (xor(xor(IN39, IN32), IN11)), !(IN21 | IN28)), IN6))) | ((xor(xor(IN14, (!(IN16)) & (!(IN29))), xor(xor(IN27 | IN23, IN13), xor(xor(IN12, IN25), IN31)))) | (xor(xor(xor(xor(IN11 | IN50, !(IN48)), !(IN48)), IN14), IN27)))) | (!(IN34 & (((IN3 | IN14) | (true & IN17)) & ((xor(xor(IN39, IN50), IN5)) | (IN4 | IN18))))))), IN5)))

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
    Out := (((NOT ((((Data[19] OR ((NOT (((Data[42] OR Data[9]) XOR Data[18]) XOR Data[43])) AND (Data[45] AND (NOT ((Data[20] XOR Data[7]) XOR Data[15]))))) OR ((Data[2] XOR (((((Data[43] XOR Data[1]) XOR Data[41]) OR ((Data[13] XOR Data[45]) XOR Data[31])) AND ((Data[14] AND Data[3]) OR (Data[11] OR Data[19]))) OR Data[16])) XOR (Data[5] OR Data[40]))) AND Data[38]) AND (Data[44] OR (Data[29] AND Data[45])))) XOR ((Data[21] XOR (Data[35] AND (NOT Data[21]))) XOR ((NOT ((((((NOT (Data[16] OR ((Data[8] XOR Data[25]) XOR Data[37]))) AND Data[21]) XOR Data[12]) XOR ((NOT ((Data[32] AND Data[11]) AND (Data[26] OR Data[3]))) OR (((((Data[18] OR Data[31]) XOR (Data[48] OR Data[23])) XOR (Data[26] AND Data[42])) XOR (NOT Data[24])) XOR ((Data[22] AND Data[13]) AND (Data[25] OR Data[12]))))) XOR Data[16]) XOR Data[13])) OR (((NOT ((((Data[13] AND Data[39]) AND (NOT Data[34])) OR Data[2]) OR (NOT (NOT ((Data[23] XOR Data[32]) XOR Data[28]))))) OR ((((((((Data[38] AND Data[21]) XOR (Data[45] OR Data[35])) XOR (Data[21] AND Data[26])) OR Data[1]) XOR (((Data[23] OR Data[23]) OR Data[17]) AND (NOT (Data[20] AND Data[9])))) XOR Data[39]) XOR (NOT (NOT (((Data[26] AND Data[43]) XOR (Data[40] AND Data[33])) XOR (FALSE OR Data[33]))))) XOR Data[49])) OR Data[3])))) XOR ((NOT (NOT (NOT (Data[2] AND Data[26])))) AND ((((((((Data[27] XOR (((Data[42] AND (NOT Data[35])) XOR ((Data[3] OR Data[32]) AND (Data[4] OR Data[35]))) XOR ((NOT Data[32]) AND Data[47]))) XOR (((((Data[13] XOR Data[2]) XOR Data[28]) XOR (Data[9] OR Data[42])) XOR (NOT Data[30])) OR ((Data[9] OR Data[14]) AND (Data[44] AND Data[28])))) AND (NOT (Data[21] OR ((Data[1] OR Data[41]) AND (Data[6] OR Data[3]))))) XOR (NOT (((NOT Data[41]) OR Data[41]) AND (Data[13] OR ((Data[13] AND Data[10]) AND ((Data[27] XOR Data[13]) XOR Data[7])))))) XOR (NOT ((Data[18] XOR Data[9]) XOR ((NOT (Data[38] AND Data[26])) AND (((Data[21] OR Data[41]) XOR ((Data[23] XOR Data[37]) XOR Data[28])) XOR (NOT Data[7])))))) AND ((NOT ((((Data[17] AND (NOT Data[29])) AND ((Data[22] AND Data[31]) OR ((Data[13] XOR Data[47]) XOR Data[2]))) XOR (((NOT Data[7]) OR Data[4]) OR (((NOT Data[19]) XOR (NOT Data[19])) XOR Data[31]))) XOR (NOT (((Data[8] XOR Data[12]) XOR FALSE) AND (Data[25] OR Data[21]))))) AND (Data[5] OR ((((((((Data[14] XOR Data[16]) XOR Data[50]) XOR Data[9]) XOR Data[44]) XOR ((((Data[19] XOR Data[1]) XOR Data[13]) XOR (Data[2] AND Data[36])) XOR Data[40])) XOR (NOT (Data[10] OR Data[39]))) XOR Data[20]) XOR ((Data[4] AND (NOT Data[21])) AND (Data[8] OR (Data[30] AND Data[12]))))))) XOR (((((NOT ((((Data[50] OR Data[6]) XOR (Data[28] AND Data[9])) XOR Data[23]) OR (((Data[41] OR Data[44]) XOR (Data[7] OR Data[29])) XOR (NOT Data[26])))) OR ((((Data[4] XOR (Data[43] OR Data[10])) XOR (Data[17] AND Data[40])) AND ((Data[49] AND Data[39]) AND ((Data[18] XOR Data[39]) XOR Data[12]))) AND (NOT (Data[11] AND (Data[26] OR Data[30]))))) XOR Data[13]) XOR (Data[2] OR (((((Data[32] XOR Data[41]) XOR Data[4]) AND Data[43]) AND ((Data[18] OR Data[10]) OR ((Data[22] XOR Data[16]) XOR Data[42]))) AND (Data[22] OR (((Data[18] AND Data[35]) XOR Data[14]) XOR (Data[20] AND Data[8])))))) AND (((((((Data[6] AND Data[44]) OR ((Data[11] XOR Data[45]) XOR TRUE)) OR Data[11]) XOR TRUE) XOR (((((Data[8] XOR TRUE) XOR Data[25]) AND ((Data[39] XOR Data[32]) XOR Data[11])) XOR (NOT (Data[21] OR Data[28]))) XOR Data[6])) OR (((Data[14] XOR ((NOT Data[16]) AND (NOT Data[29]))) XOR (((Data[27] OR Data[23]) XOR Data[13]) XOR ((Data[12] XOR Data[25]) XOR Data[31]))) OR (((((Data[11] OR Data[50]) XOR (NOT Data[48])) XOR (NOT Data[48])) XOR Data[14]) XOR Data[27]))) OR (NOT (Data[34] AND (((Data[3] OR Data[14]) OR (TRUE AND Data[17])) AND (((Data[39] XOR Data[50]) XOR Data[5]) OR (Data[4] OR Data[18])))))))) XOR Data[5])));
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
