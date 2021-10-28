(*
This code implements a randomly grown symbolic expression:

xor(xor(!(xor(xor(IN32, (!(!((IN49 | (!(IN19))) & (!(IN28 & (xor(xor(IN18, IN20), IN24))))))) & ((xor(xor(IN13, IN1), !(xor(xor(xor(xor(!(IN32), IN20 & IN18), IN50 & IN1), (IN10 & IN17) & (IN11 & IN39)), true & IN1)))) | (xor(xor((!(IN35)) | IN42, !(IN44 | ((!(IN28)) | IN34))), (!((xor(xor(IN28, IN8), IN8)) & IN14)) | (!(xor(xor(xor(xor(IN16, IN9), IN43), xor(xor(IN30, IN9), IN40)), IN50 | IN28))))))), xor(xor((xor(xor(!(((!(IN18)) & (!(IN40))) & (IN28 & (!(IN19)))), IN7), (!((xor(xor(IN34, IN23), IN2)) & (xor(xor(IN27, IN44), IN31)))) | (!(xor(xor(!(IN25), IN8 & IN22), IN9))))) & (xor(xor(IN3, (!(IN42)) & (xor(xor(xor(xor(IN29 & IN50, IN38 | IN40), !(IN36)), IN40), (!(IN24)) & false))), (((!(IN11)) | (!(IN14))) | ((!(IN10)) | (IN36 & IN47))) | IN15)), (!(!(IN45))) & (xor(xor(IN31 | true, IN38), xor(xor(IN43, xor(xor(IN1, (IN12 & IN45) | (IN48 | IN6)), xor(xor(xor(xor(IN28, IN15), IN16), IN6), !(IN49)))), IN13 | ((xor(xor(IN45, IN5), IN32)) & (xor(xor(IN49, IN26), IN28))))))), !((!(IN43)) | (IN45 | (IN20 & (!(xor(xor(IN16, IN7), IN9))))))))), xor(xor((IN15 & ((!(xor(xor(!(xor(xor(IN18 | IN27, xor(xor(IN38, IN31), IN37)), !(IN3))), IN8 & (!(IN28 | IN17))), (xor(xor(IN17 | IN48, xor(xor(IN42, true), true)), IN31 | IN45)) | (IN25 | (!(IN12)))))) | ((!((xor(xor(!(IN16), IN16), xor(xor(IN32, IN22), IN35))) | IN22)) & ((!(xor(xor(IN8, xor(xor(IN18, IN44), IN32)), IN10 | IN3))) & (IN48 & (IN40 | (IN42 & IN27))))))) & IN10, ((!(!(xor(xor(IN3, IN47), (!(IN36 & IN49)) | ((xor(xor(IN42, IN21), IN34)) | (xor(xor(IN24, IN27), IN13))))))) | ((!(IN3)) & IN11)) & (!(((xor(xor(IN31 & IN15, ((!(IN49)) & (xor(xor(IN42, IN39), IN29))) & IN5), (IN7 | (IN32 | IN49)) & ((!(IN32)) | IN44))) & (!(!(!(IN47 & IN34))))) | (((true | (xor(xor(!(IN5), IN9 | IN38), !(IN46)))) | (!((IN37 | IN29) | (IN12 & IN37)))) | IN9)))), !((xor(xor(xor(xor(!(IN20), IN29 | IN30), (xor(xor(IN2, (IN21 & IN3) | (IN13 | IN7)), IN28)) | (xor(xor(IN44, IN21), (!(IN49)) & (!(IN44))))), xor(xor(xor(xor(xor(xor((!(IN48)) & (xor(xor(IN4, IN4), IN39)), (IN31 & IN45) & (IN44 | IN11)), IN5), IN42 & IN13), xor(xor(IN42, (xor(xor(IN14, IN11), IN43)) & IN1), true & (!(IN29)))), !(IN20)), true | (((xor(xor(IN15, IN17), IN17)) | IN20) | (!(!(IN29)))))), (!(IN1 | (xor(xor(IN14 & IN10, !(IN14)), IN21 & IN34)))) & IN17)) | ((IN1 & (xor(xor((!(IN2 & IN15)) | IN22, (!(IN21)) | (IN15 & IN29)), !(xor(xor(IN40, IN7 & IN9), IN31))))) & (((((IN44 & IN35) & (!(IN27))) | IN14) & (IN31 | ((!(IN25)) | (!(IN45))))) | (IN34 | (!((IN22 | IN16) & IN33)))))))), !(IN31 & ((!(xor(xor(((xor(xor(IN2 & IN9, IN28 & IN31), !(IN12))) | ((IN37 | IN35) | IN39)) | ((xor(xor(IN39 & IN49, IN2), IN26 | IN19)) | IN2), xor(xor((IN41 & (!(IN16))) & (xor(xor(!(IN33), IN12 & IN24), IN29 & IN35)), ((IN50 | IN17) & (IN41 & IN40)) | IN5), xor(xor(true, xor(xor(!(IN50), xor(xor(IN37, IN38), IN12)), !(IN47))), !(IN11 | IN42)))), IN42 | IN28))) | ((IN38 & IN43) & IN36))))

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
    Out := (((NOT ((Data[32] XOR ((NOT (NOT ((Data[49] OR (NOT Data[19])) AND (NOT (Data[28] AND ((Data[18] XOR Data[20]) XOR Data[24])))))) AND (((Data[13] XOR Data[1]) XOR (NOT (((((NOT Data[32]) XOR (Data[20] AND Data[18])) XOR (Data[50] AND Data[1])) XOR ((Data[10] AND Data[17]) AND (Data[11] AND Data[39]))) XOR (TRUE AND Data[1])))) OR ((((NOT Data[35]) OR Data[42]) XOR (NOT (Data[44] OR ((NOT Data[28]) OR Data[34])))) XOR ((NOT (((Data[28] XOR Data[8]) XOR Data[8]) AND Data[14])) OR (NOT ((((Data[16] XOR Data[9]) XOR Data[43]) XOR ((Data[30] XOR Data[9]) XOR Data[40])) XOR (Data[50] OR Data[28])))))))) XOR ((((((NOT (((NOT Data[18]) AND (NOT Data[40])) AND (Data[28] AND (NOT Data[19])))) XOR Data[7]) XOR ((NOT (((Data[34] XOR Data[23]) XOR Data[2]) AND ((Data[27] XOR Data[44]) XOR Data[31]))) OR (NOT (((NOT Data[25]) XOR (Data[8] AND Data[22])) XOR Data[9])))) AND ((Data[3] XOR ((NOT Data[42]) AND (((((Data[29] AND Data[50]) XOR (Data[38] OR Data[40])) XOR (NOT Data[36])) XOR Data[40]) XOR ((NOT Data[24]) AND FALSE)))) XOR ((((NOT Data[11]) OR (NOT Data[14])) OR ((NOT Data[10]) OR (Data[36] AND Data[47]))) OR Data[15]))) XOR ((NOT (NOT Data[45])) AND (((Data[31] OR TRUE) XOR Data[38]) XOR ((Data[43] XOR ((Data[1] XOR ((Data[12] AND Data[45]) OR (Data[48] OR Data[6]))) XOR ((((Data[28] XOR Data[15]) XOR Data[16]) XOR Data[6]) XOR (NOT Data[49])))) XOR (Data[13] OR (((Data[45] XOR Data[5]) XOR Data[32]) AND ((Data[49] XOR Data[26]) XOR Data[28]))))))) XOR (NOT ((NOT Data[43]) OR (Data[45] OR (Data[20] AND (NOT ((Data[16] XOR Data[7]) XOR Data[9]))))))))) XOR ((((Data[15] AND ((NOT (((NOT (((Data[18] OR Data[27]) XOR ((Data[38] XOR Data[31]) XOR Data[37])) XOR (NOT Data[3]))) XOR (Data[8] AND (NOT (Data[28] OR Data[17])))) XOR ((((Data[17] OR Data[48]) XOR ((Data[42] XOR TRUE) XOR TRUE)) XOR (Data[31] OR Data[45])) OR (Data[25] OR (NOT Data[12]))))) OR ((NOT ((((NOT Data[16]) XOR Data[16]) XOR ((Data[32] XOR Data[22]) XOR Data[35])) OR Data[22])) AND ((NOT ((Data[8] XOR ((Data[18] XOR Data[44]) XOR Data[32])) XOR (Data[10] OR Data[3]))) AND (Data[48] AND (Data[40] OR (Data[42] AND Data[27]))))))) AND Data[10]) XOR (((NOT (NOT ((Data[3] XOR Data[47]) XOR ((NOT (Data[36] AND Data[49])) OR (((Data[42] XOR Data[21]) XOR Data[34]) OR ((Data[24] XOR Data[27]) XOR Data[13])))))) OR ((NOT Data[3]) AND Data[11])) AND (NOT (((((Data[31] AND Data[15]) XOR (((NOT Data[49]) AND ((Data[42] XOR Data[39]) XOR Data[29])) AND Data[5])) XOR ((Data[7] OR (Data[32] OR Data[49])) AND ((NOT Data[32]) OR Data[44]))) AND (NOT (NOT (NOT (Data[47] AND Data[34]))))) OR (((TRUE OR (((NOT Data[5]) XOR (Data[9] OR Data[38])) XOR (NOT Data[46]))) OR (NOT ((Data[37] OR Data[29]) OR (Data[12] AND Data[37])))) OR Data[9]))))) XOR (NOT ((((((NOT Data[20]) XOR (Data[29] OR Data[30])) XOR (((Data[2] XOR ((Data[21] AND Data[3]) OR (Data[13] OR Data[7]))) XOR Data[28]) OR ((Data[44] XOR Data[21]) XOR ((NOT Data[49]) AND (NOT Data[44]))))) XOR ((((((((NOT Data[48]) AND ((Data[4] XOR Data[4]) XOR Data[39])) XOR ((Data[31] AND Data[45]) AND (Data[44] OR Data[11]))) XOR Data[5]) XOR (Data[42] AND Data[13])) XOR ((Data[42] XOR (((Data[14] XOR Data[11]) XOR Data[43]) AND Data[1])) XOR (TRUE AND (NOT Data[29])))) XOR (NOT Data[20])) XOR (TRUE OR ((((Data[15] XOR Data[17]) XOR Data[17]) OR Data[20]) OR (NOT (NOT Data[29])))))) XOR ((NOT (Data[1] OR (((Data[14] AND Data[10]) XOR (NOT Data[14])) XOR (Data[21] AND Data[34])))) AND Data[17])) OR ((Data[1] AND ((((NOT (Data[2] AND Data[15])) OR Data[22]) XOR ((NOT Data[21]) OR (Data[15] AND Data[29]))) XOR (NOT ((Data[40] XOR (Data[7] AND Data[9])) XOR Data[31])))) AND (((((Data[44] AND Data[35]) AND (NOT Data[27])) OR Data[14]) AND (Data[31] OR ((NOT Data[25]) OR (NOT Data[45])))) OR (Data[34] OR (NOT ((Data[22] OR Data[16]) AND Data[33]))))))))) XOR (NOT (Data[31] AND ((NOT (((((((Data[2] AND Data[9]) XOR (Data[28] AND Data[31])) XOR (NOT Data[12])) OR ((Data[37] OR Data[35]) OR Data[39])) OR ((((Data[39] AND Data[49]) XOR Data[2]) XOR (Data[26] OR Data[19])) OR Data[2])) XOR ((((Data[41] AND (NOT Data[16])) AND (((NOT Data[33]) XOR (Data[12] AND Data[24])) XOR (Data[29] AND Data[35]))) XOR (((Data[50] OR Data[17]) AND (Data[41] AND Data[40])) OR Data[5])) XOR ((TRUE XOR (((NOT Data[50]) XOR ((Data[37] XOR Data[38]) XOR Data[12])) XOR (NOT Data[47]))) XOR (NOT (Data[11] OR Data[42]))))) XOR (Data[42] OR Data[28]))) OR ((Data[38] AND Data[43]) AND Data[36])))));
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
