(*
This code implements a randomly grown symbolic expression:

((((!(xor(xor(IN37 & (IN27 | ((IN12 & IN24) | (xor(xor(IN9, IN8), IN8)))), (((IN7 & IN10) | (IN4 | IN33)) & IN19) & (xor(xor(!(xor(xor(IN45, IN17), IN10)), !(IN49)), (IN17 & IN40) & (IN49 & IN27)))), (IN29 & (!(xor(xor(IN44, IN27), IN49)))) & IN44))) & (xor(xor((xor(xor(IN25 & ((IN10 | IN28) & IN1), xor(xor(!(!(IN7)), IN13 | (IN39 & IN48)), !(IN32 | IN22))), IN12 & IN3)) & (((!(IN1 & true)) | (IN40 & (!(IN33)))) & ((!(!(IN39))) & ((IN31 | IN24) & IN12))), ((!(IN45)) | ((IN39 | (IN21 | IN31)) | IN2)) | (xor(xor(xor(xor(!(IN20 & IN8), xor(xor(xor(xor(IN3, IN22), IN23), !(IN26)), IN36 & IN23)), !(IN7 | IN30)), (IN12 & (IN40 & IN39)) & (!(IN11 | IN36))), IN48 | IN27))), (!((!(false | IN8)) & ((IN41 & IN46) | (!(IN10))))) & ((!((xor(xor(IN49, IN16), IN2)) | (xor(xor(IN1, IN43), IN14)))) & (!(xor(xor(true & IN26, !(IN43)), xor(xor(IN50, IN38), IN31)))))))) | (((xor(xor(IN15 & (((!(IN16)) & (xor(xor(IN17, IN4), IN20))) & (!(IN23))), (!(xor(xor(false & IN33, xor(xor(IN43, IN26), IN5)), IN34 | IN13))) | (!((xor(xor(IN34, IN42), IN26)) | (!(IN14))))), (((IN10 | IN35) & (IN3 & IN6)) | ((!(IN24)) & (xor(xor(IN26, IN21), IN4)))) | (!(!(IN39 & IN43))))) & (IN6 | ((!(!(xor(xor(IN12, IN16), IN44)))) & IN38))) | (xor(xor(IN25, (xor(xor(xor(xor(!(IN8 & IN48), xor(xor(IN32 | IN43, IN16 | IN16), IN36 | IN46)), xor(xor(IN47, !(IN48)), IN35 | IN43)), xor(xor((IN45 | true) | (!(IN18)), IN13 | (xor(xor(IN5, IN40), IN37))), (!(IN32)) | (!(IN30)))), ((IN6 & IN50) | (IN12 | IN40)) | (xor(xor(!(IN26), xor(xor(IN28, IN10), IN19)), IN30 | IN9)))) & (!(((IN36 & IN40) & (!(IN27))) & (xor(xor(IN36 & true, IN6 | IN2), xor(xor(IN17, IN35), IN35)))))), xor(xor((!(!(IN3 | IN2))) & (!(!(IN13))), IN28), ((!(IN49 & IN49)) | (!(IN7 & IN22))) & (!((IN34 & IN14) & (IN33 | IN12)))))))) & (!(IN3))) & ((!((xor(xor(IN17, !((((IN49 & IN26) | (xor(xor(IN36, IN25), false))) & (xor(xor(IN5 & false, !(IN35)), !(IN50)))) & (!(!(IN6 | IN36))))), !(IN48 & IN8))) & ((xor(xor((!((xor(xor(IN33, IN8), IN42)) | (!(IN38)))) & (xor(xor(!(!(IN31)), xor(xor(IN29, !(IN19)), IN30 & IN32)), xor(xor(IN21, IN19), IN26 | IN33))), (xor(xor((!(IN43)) | (IN50 | IN48), !(!(IN4))), (IN46 | IN17) | (IN30 & IN5))) | ((xor(xor(!(IN13), !(IN13)), xor(xor(IN47, IN28), IN11))) & (xor(xor(!(IN34), IN1 & IN9), IN18 | IN18)))), !(!(!(xor(xor(IN27, IN9), IN50)))))) | (xor(xor(xor(xor(((IN38 | IN16) & (xor(xor(IN41, IN33), IN19))) | (!(xor(xor(IN24, IN1), IN26))), IN22 | ((!(IN32)) | (IN39 & IN2))), ((xor(xor(IN29, IN31), IN5)) & (IN28 | IN27)) & IN20), IN48 & (!((!(IN49)) | (IN30 & IN43)))), IN17 | (((xor(xor(IN21, IN47), IN26)) & (IN28 | false)) | (!(IN31 & false)))))))) & (xor(xor((xor(xor(!((!(!(IN14 & IN46))) & IN35), IN1 | (((!(!(IN20))) & (xor(xor(IN14 & IN29, IN28 & IN20), IN24 & IN18))) & (!(!(IN15 & IN16))))), (xor(xor(((xor(xor(IN14, IN48), IN24)) & (xor(xor(IN5, IN43), IN5))) | ((IN22 | IN46) | (IN44 & IN8)), !((xor(xor(IN50, IN32), IN48)) | (xor(xor(IN28, IN47), IN47)))), (!(xor(xor(IN20, IN39), IN43))) | (!(IN21 & IN17)))) & ((((IN36 | IN24) & (IN9 & IN28)) & IN6) & (true & IN18)))) & ((xor(xor((xor(xor(!(xor(xor(IN44, IN27), IN50)), IN14), IN44)) | (!(!(xor(xor(IN15, IN29), IN24)))), (IN7 & (IN34 | (xor(xor(IN14, IN19), IN41)))) | (((IN10 & IN43) | (IN32 | IN38)) & ((IN5 & IN35) | IN1))), IN43)) | (xor(xor(IN45, xor(xor(true | (!(IN49 | IN18)), IN33 & (!(IN5 & IN13))), IN43)), IN5))), (!((IN23 | ((!(IN45 | IN31)) & IN9)) | (xor(xor(!((IN27 | IN21) & (!(IN26))), !(IN27)), ((IN48 & IN48) & (xor(xor(IN37, IN41), IN13))) & IN49)))) | (((!(((!(IN15)) | (xor(xor(IN1, IN25), IN6))) | IN46)) | IN13) & ((IN18 | (xor(xor(IN14 & (!(IN35)), xor(xor(xor(xor(IN40, IN41), IN23), xor(xor(IN6, IN18), IN22)), IN10)), IN35))) | (!(((IN34 & IN11) & (IN46 & IN43)) & (xor(xor(IN31, IN25 | IN32), xor(xor(IN35, IN11), IN9)))))))), !(((xor(xor(xor(xor(IN39, IN42 | (xor(xor(IN33, IN4), IN29))), IN24 & (!(IN45))), (xor(xor(!(IN11), IN39 & false), IN35)) & ((xor(xor(IN12, IN35), IN44)) & IN30)), xor(xor(IN23, !(!(IN25))), !(IN25 & IN14)))) & (IN24 | ((xor(xor(IN4, !(IN27)), IN28 | IN44)) | (xor(xor(IN44 & IN22, IN44 | IN50), IN44))))) | (!((xor(xor(!(IN23), (xor(xor(IN24, IN35), IN27)) & (IN27 | IN14)), (!(IN37)) & (!(IN27)))) & ((xor(xor(IN24 & IN33, IN3), !(IN16))) & ((IN12 | IN39) & IN25))))))))

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
    Out := (((((NOT (((Data[37] AND (Data[27] OR ((Data[12] AND Data[24]) OR ((Data[9] XOR Data[8]) XOR Data[8])))) XOR ((((Data[7] AND Data[10]) OR (Data[4] OR Data[33])) AND Data[19]) AND (((NOT ((Data[45] XOR Data[17]) XOR Data[10])) XOR (NOT Data[49])) XOR ((Data[17] AND Data[40]) AND (Data[49] AND Data[27]))))) XOR ((Data[29] AND (NOT ((Data[44] XOR Data[27]) XOR Data[49]))) AND Data[44]))) AND ((((((Data[25] AND ((Data[10] OR Data[28]) AND Data[1])) XOR (((NOT (NOT Data[7])) XOR (Data[13] OR (Data[39] AND Data[48]))) XOR (NOT (Data[32] OR Data[22])))) XOR (Data[12] AND Data[3])) AND (((NOT (Data[1] AND TRUE)) OR (Data[40] AND (NOT Data[33]))) AND ((NOT (NOT Data[39])) AND ((Data[31] OR Data[24]) AND Data[12])))) XOR (((NOT Data[45]) OR ((Data[39] OR (Data[21] OR Data[31])) OR Data[2])) OR (((((NOT (Data[20] AND Data[8])) XOR ((((Data[3] XOR Data[22]) XOR Data[23]) XOR (NOT Data[26])) XOR (Data[36] AND Data[23]))) XOR (NOT (Data[7] OR Data[30]))) XOR ((Data[12] AND (Data[40] AND Data[39])) AND (NOT (Data[11] OR Data[36])))) XOR (Data[48] OR Data[27])))) XOR ((NOT ((NOT (FALSE OR Data[8])) AND ((Data[41] AND Data[46]) OR (NOT Data[10])))) AND ((NOT (((Data[49] XOR Data[16]) XOR Data[2]) OR ((Data[1] XOR Data[43]) XOR Data[14]))) AND (NOT (((TRUE AND Data[26]) XOR (NOT Data[43])) XOR ((Data[50] XOR Data[38]) XOR Data[31]))))))) OR (((((Data[15] AND (((NOT Data[16]) AND ((Data[17] XOR Data[4]) XOR Data[20])) AND (NOT Data[23]))) XOR ((NOT (((FALSE AND Data[33]) XOR ((Data[43] XOR Data[26]) XOR Data[5])) XOR (Data[34] OR Data[13]))) OR (NOT (((Data[34] XOR Data[42]) XOR Data[26]) OR (NOT Data[14]))))) XOR ((((Data[10] OR Data[35]) AND (Data[3] AND Data[6])) OR ((NOT Data[24]) AND ((Data[26] XOR Data[21]) XOR Data[4]))) OR (NOT (NOT (Data[39] AND Data[43]))))) AND (Data[6] OR ((NOT (NOT ((Data[12] XOR Data[16]) XOR Data[44]))) AND Data[38]))) OR ((Data[25] XOR ((((((NOT (Data[8] AND Data[48])) XOR (((Data[32] OR Data[43]) XOR (Data[16] OR Data[16])) XOR (Data[36] OR Data[46]))) XOR ((Data[47] XOR (NOT Data[48])) XOR (Data[35] OR Data[43]))) XOR ((((Data[45] OR TRUE) OR (NOT Data[18])) XOR (Data[13] OR ((Data[5] XOR Data[40]) XOR Data[37]))) XOR ((NOT Data[32]) OR (NOT Data[30])))) XOR (((Data[6] AND Data[50]) OR (Data[12] OR Data[40])) OR (((NOT Data[26]) XOR ((Data[28] XOR Data[10]) XOR Data[19])) XOR (Data[30] OR Data[9])))) AND (NOT (((Data[36] AND Data[40]) AND (NOT Data[27])) AND (((Data[36] AND TRUE) XOR (Data[6] OR Data[2])) XOR ((Data[17] XOR Data[35]) XOR Data[35])))))) XOR ((((NOT (NOT (Data[3] OR Data[2]))) AND (NOT (NOT Data[13]))) XOR Data[28]) XOR (((NOT (Data[49] AND Data[49])) OR (NOT (Data[7] AND Data[22]))) AND (NOT ((Data[34] AND Data[14]) AND (Data[33] OR Data[12])))))))) AND (NOT Data[3])) AND ((NOT (((Data[17] XOR (NOT ((((Data[49] AND Data[26]) OR ((Data[36] XOR Data[25]) XOR FALSE)) AND (((Data[5] AND FALSE) XOR (NOT Data[35])) XOR (NOT Data[50]))) AND (NOT (NOT (Data[6] OR Data[36])))))) XOR (NOT (Data[48] AND Data[8]))) AND (((((NOT (((Data[33] XOR Data[8]) XOR Data[42]) OR (NOT Data[38]))) AND (((NOT (NOT Data[31])) XOR ((Data[29] XOR (NOT Data[19])) XOR (Data[30] AND Data[32]))) XOR ((Data[21] XOR Data[19]) XOR (Data[26] OR Data[33])))) XOR (((((NOT Data[43]) OR (Data[50] OR Data[48])) XOR (NOT (NOT Data[4]))) XOR ((Data[46] OR Data[17]) OR (Data[30] AND Data[5]))) OR ((((NOT Data[13]) XOR (NOT Data[13])) XOR ((Data[47] XOR Data[28]) XOR Data[11])) AND (((NOT Data[34]) XOR (Data[1] AND Data[9])) XOR (Data[18] OR Data[18]))))) XOR (NOT (NOT (NOT ((Data[27] XOR Data[9]) XOR Data[50]))))) OR (((((((Data[38] OR Data[16]) AND ((Data[41] XOR Data[33]) XOR Data[19])) OR (NOT ((Data[24] XOR Data[1]) XOR Data[26]))) XOR (Data[22] OR ((NOT Data[32]) OR (Data[39] AND Data[2])))) XOR ((((Data[29] XOR Data[31]) XOR Data[5]) AND (Data[28] OR Data[27])) AND Data[20])) XOR (Data[48] AND (NOT ((NOT Data[49]) OR (Data[30] AND Data[43]))))) XOR (Data[17] OR ((((Data[21] XOR Data[47]) XOR Data[26]) AND (Data[28] OR FALSE)) OR (NOT (Data[31] AND FALSE)))))))) AND ((((((NOT ((NOT (NOT (Data[14] AND Data[46]))) AND Data[35])) XOR (Data[1] OR (((NOT (NOT Data[20])) AND (((Data[14] AND Data[29]) XOR (Data[28] AND Data[20])) XOR (Data[24] AND Data[18]))) AND (NOT (NOT (Data[15] AND Data[16])))))) XOR (((((((Data[14] XOR Data[48]) XOR Data[24]) AND ((Data[5] XOR Data[43]) XOR Data[5])) OR ((Data[22] OR Data[46]) OR (Data[44] AND Data[8]))) XOR (NOT (((Data[50] XOR Data[32]) XOR Data[48]) OR ((Data[28] XOR Data[47]) XOR Data[47])))) XOR ((NOT ((Data[20] XOR Data[39]) XOR Data[43])) OR (NOT (Data[21] AND Data[17])))) AND ((((Data[36] OR Data[24]) AND (Data[9] AND Data[28])) AND Data[6]) AND (TRUE AND Data[18])))) AND (((((((NOT ((Data[44] XOR Data[27]) XOR Data[50])) XOR Data[14]) XOR Data[44]) OR (NOT (NOT ((Data[15] XOR Data[29]) XOR Data[24])))) XOR ((Data[7] AND (Data[34] OR ((Data[14] XOR Data[19]) XOR Data[41]))) OR (((Data[10] AND Data[43]) OR (Data[32] OR Data[38])) AND ((Data[5] AND Data[35]) OR Data[1])))) XOR Data[43]) OR ((Data[45] XOR (((TRUE OR (NOT (Data[49] OR Data[18]))) XOR (Data[33] AND (NOT (Data[5] AND Data[13])))) XOR Data[43])) XOR Data[5]))) XOR ((NOT ((Data[23] OR ((NOT (Data[45] OR Data[31])) AND Data[9])) OR (((NOT ((Data[27] OR Data[21]) AND (NOT Data[26]))) XOR (NOT Data[27])) XOR (((Data[48] AND Data[48]) AND ((Data[37] XOR Data[41]) XOR Data[13])) AND Data[49])))) OR (((NOT (((NOT Data[15]) OR ((Data[1] XOR Data[25]) XOR Data[6])) OR Data[46])) OR Data[13]) AND ((Data[18] OR (((Data[14] AND (NOT Data[35])) XOR ((((Data[40] XOR Data[41]) XOR Data[23]) XOR ((Data[6] XOR Data[18]) XOR Data[22])) XOR Data[10])) XOR Data[35])) OR (NOT (((Data[34] AND Data[11]) AND (Data[46] AND Data[43])) AND ((Data[31] XOR (Data[25] OR Data[32])) XOR ((Data[35] XOR Data[11]) XOR Data[9])))))))) XOR (NOT ((((((Data[39] XOR (Data[42] OR ((Data[33] XOR Data[4]) XOR Data[29]))) XOR (Data[24] AND (NOT Data[45]))) XOR ((((NOT Data[11]) XOR (Data[39] AND FALSE)) XOR Data[35]) AND (((Data[12] XOR Data[35]) XOR Data[44]) AND Data[30]))) XOR ((Data[23] XOR (NOT (NOT Data[25]))) XOR (NOT (Data[25] AND Data[14])))) AND (Data[24] OR (((Data[4] XOR (NOT Data[27])) XOR (Data[28] OR Data[44])) OR (((Data[44] AND Data[22]) XOR (Data[44] OR Data[50])) XOR Data[44])))) OR (NOT ((((NOT Data[23]) XOR (((Data[24] XOR Data[35]) XOR Data[27]) AND (Data[27] OR Data[14]))) XOR ((NOT Data[37]) AND (NOT Data[27]))) AND ((((Data[24] AND Data[33]) XOR Data[3]) XOR (NOT Data[16])) AND ((Data[12] OR Data[39]) AND Data[25])))))))));
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
