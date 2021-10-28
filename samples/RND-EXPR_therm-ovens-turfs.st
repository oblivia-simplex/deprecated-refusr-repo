(*
This code implements a randomly grown symbolic expression:

((xor(xor(xor(xor(!(xor(xor(xor(xor(!(IN12), (IN42 & (IN3 & IN46)) & IN26), !((xor(xor(IN40, IN30), IN46)) & (IN40 | IN10))), IN11), xor(xor(false, ((IN1 | IN33) | (IN46 | IN31)) | (xor(xor(IN24 & IN46, IN2 & IN11), IN38 | IN26))), (xor(xor(IN1 | IN47, IN33), !(IN8))) & (!(IN28 | IN8))))), !(((!((!(IN37)) | (!(IN43)))) | (xor(xor(!(IN47), xor(xor(IN24 & IN35, IN23), IN26)), (IN27 | IN29) | (xor(xor(IN33, IN34), IN16))))) & IN12)), IN3 & (xor(xor((((true & IN5) & (xor(xor(IN40, IN17), IN34))) | (xor(xor(IN8 & IN16, xor(xor(IN1, IN19), IN6)), xor(xor(IN34, IN8), IN33)))) & (xor(xor(IN9, IN39), !(IN36 | IN14))), ((!(xor(xor(IN24, IN29), IN3))) | (xor(xor(IN8, !(IN47)), IN26))) | (!(IN12 | (!(IN33))))), IN49))), !(xor(xor(((xor(xor((!(IN24)) & IN39, IN23), xor(xor(!(IN4), IN45 | IN47), !(IN35)))) & (IN13 | (!(IN17 & IN29)))) & IN11, IN7), ((((IN2 & IN42) | (xor(xor(IN8, IN30), IN24))) | ((IN49 | IN18) & (xor(xor(IN22, IN1), false)))) | (((IN35 | IN6) & (IN41 | IN20)) & (xor(xor(!(IN28), IN31 & IN5), IN47 | IN7)))) & ((xor(xor(IN2, IN38 & (IN43 & IN19)), IN34 & (IN50 | IN43))) | (xor(xor(IN23 | (IN22 | IN33), true & (xor(xor(IN8, IN3), IN27))), IN33)))))), !(!(IN8)))) | (!((((xor(xor((!(IN40 & IN39)) | ((!(IN15)) | IN2), xor(xor(xor(xor(xor(xor(IN13, IN11), IN7), IN6 | IN47), !(IN23)), xor(xor(xor(xor(IN28, true), IN6), xor(xor(IN42, IN3), IN24)), xor(xor(IN39, IN15), IN4))), xor(xor(IN12 | IN17, true), false))), xor(xor((!(IN9)) | IN1, (IN7 & IN4) & (IN12 & IN46)), (!(IN50)) | (!(IN5))))) & ((xor(xor(!(IN33), (!(IN10)) & (true | IN13)), xor(xor(IN38 | IN36, !(IN11)), xor(xor(IN41, IN36), IN2)))) & ((IN3 & (!(IN33))) | ((xor(xor(IN11, IN4), IN15)) & (xor(xor(IN16, IN18), IN42)))))) | (((!((!(IN36)) | (IN29 & IN10))) & (xor(xor(!(!(IN29)), (xor(xor(IN46, IN20), IN5)) | (!(IN15))), !(IN19 & IN28)))) & IN22)) & IN36))) & (xor(xor(((xor(xor(((xor(xor(IN5, IN43), IN50)) | (((IN35 & IN44) | (!(IN17))) | IN32)) | (IN40 | ((!(IN24 & IN47)) | (!(IN46)))), ((((xor(xor(IN23, IN46), IN6)) & (IN38 | IN11)) | ((IN21 | IN2) & (IN25 | IN18))) & (IN18 & (xor(xor(IN5 | IN34, IN1 & IN45), !(IN20))))) & (IN42 & (xor(xor(IN28 | (IN29 & IN36), !(xor(xor(IN50, IN42), IN4))), (!(IN8)) & (IN16 | IN12))))), (IN28 & (IN35 & ((IN45 & IN3) & (!(IN4))))) | (xor(xor(!(!(IN4 | IN40)), IN40 | (xor(xor(IN1, IN33 | IN11), xor(xor(IN10, IN45), IN41)))), (!(IN18 & IN3)) | ((!(IN19)) & (IN20 & IN45)))))) | (!((xor(xor(!(xor(xor(IN25 & IN40, true | IN7), IN35 & true)), ((!(IN7)) | (IN10 | IN33)) | ((xor(xor(IN35, IN14), IN3)) & (IN34 & IN38))), ((!(IN27)) & (xor(xor(IN14, IN11), true))) | ((IN15 & IN28) | IN26))) | IN9))) & IN4, (IN30 & (xor(xor(IN2 & (xor(xor(((IN34 | IN5) & IN14) & IN17, !(IN40)), ((IN39 & true) & (IN18 | IN44)) | (!(IN38 & IN6)))), IN40 | IN7), IN35))) | true), xor(xor(IN15, !((((!((IN16 & IN34) | (xor(xor(IN14, IN35), IN24)))) | (xor(xor((!(IN11)) & IN26, !(IN29)), IN50))) | ((xor(xor(IN44, (!(IN6)) & (IN7 & IN43)), (!(IN8)) | (xor(xor(IN26, IN25), IN4)))) | ((!(IN44 | IN8)) | ((IN20 | IN18) | (xor(xor(IN23, IN32), IN47)))))) | ((xor(xor(IN42, IN45), xor(xor((xor(xor(false, IN39), IN6)) & (IN29 & IN4), IN27), !(IN1 | IN9)))) | ((((IN29 | IN21) & (IN19 & IN48)) | (xor(xor(IN16 & IN28, xor(xor(false, IN39), IN23)), IN7 & IN15))) | ((!(xor(xor(IN11, IN24), IN48))) | ((IN39 & IN34) & (IN43 | IN43))))))), (!(xor(xor(xor(xor(xor(xor((IN7 & IN32) & IN47, (!(IN48)) | (IN49 & IN2)), (IN16 & IN30) & (IN46 & true)), !(IN8)), (IN14 & (!(IN41))) | ((!(IN11)) | (IN29 & IN50))), IN20), xor(xor(((IN27 & IN20) & (IN50 & IN49)) | ((!(IN22)) | (xor(xor(IN37, IN14), IN8))), ((IN7 | IN17) | (IN11 | IN13)) & IN19), !(xor(xor(IN36, IN19 & IN33), IN14 & IN27)))))) | ((!((((IN12 & IN13) & IN17) & IN47) & ((!(IN17)) & (xor(xor(!(IN17), !(IN38)), !(IN36)))))) | (xor(xor(xor(xor(!((IN14 & IN50) | (IN22 | IN34)), (xor(xor(IN7, xor(xor(IN13, IN14), IN7)), !(IN10))) & ((IN40 & IN50) & (xor(xor(IN16, IN41), IN34)))), (xor(xor(!(IN2), IN37 | IN21), !(IN50))) & IN34), (xor(xor(!(IN42), (IN28 & IN23) & (IN40 | IN27)), !(IN8 | IN37))) & (IN35 & (!(xor(xor(IN8, IN28), IN16))))), xor(xor(((xor(xor(IN22, IN20), IN42)) | (IN28 & IN9)) | (!(xor(xor(IN37, IN37), IN13))), !(IN45)), IN22 & (!(IN15 | IN39)))))))))

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
    Out := (((((((NOT (((((NOT Data[12]) XOR ((Data[42] AND (Data[3] AND Data[46])) AND Data[26])) XOR (NOT (((Data[40] XOR Data[30]) XOR Data[46]) AND (Data[40] OR Data[10])))) XOR Data[11]) XOR ((FALSE XOR (((Data[1] OR Data[33]) OR (Data[46] OR Data[31])) OR (((Data[24] AND Data[46]) XOR (Data[2] AND Data[11])) XOR (Data[38] OR Data[26])))) XOR ((((Data[1] OR Data[47]) XOR Data[33]) XOR (NOT Data[8])) AND (NOT (Data[28] OR Data[8])))))) XOR (NOT (((NOT ((NOT Data[37]) OR (NOT Data[43]))) OR (((NOT Data[47]) XOR (((Data[24] AND Data[35]) XOR Data[23]) XOR Data[26])) XOR ((Data[27] OR Data[29]) OR ((Data[33] XOR Data[34]) XOR Data[16])))) AND Data[12]))) XOR (Data[3] AND ((((((TRUE AND Data[5]) AND ((Data[40] XOR Data[17]) XOR Data[34])) OR (((Data[8] AND Data[16]) XOR ((Data[1] XOR Data[19]) XOR Data[6])) XOR ((Data[34] XOR Data[8]) XOR Data[33]))) AND ((Data[9] XOR Data[39]) XOR (NOT (Data[36] OR Data[14])))) XOR (((NOT ((Data[24] XOR Data[29]) XOR Data[3])) OR ((Data[8] XOR (NOT Data[47])) XOR Data[26])) OR (NOT (Data[12] OR (NOT Data[33]))))) XOR Data[49]))) XOR (NOT ((((((((NOT Data[24]) AND Data[39]) XOR Data[23]) XOR (((NOT Data[4]) XOR (Data[45] OR Data[47])) XOR (NOT Data[35]))) AND (Data[13] OR (NOT (Data[17] AND Data[29])))) AND Data[11]) XOR Data[7]) XOR (((((Data[2] AND Data[42]) OR ((Data[8] XOR Data[30]) XOR Data[24])) OR ((Data[49] OR Data[18]) AND ((Data[22] XOR Data[1]) XOR FALSE))) OR (((Data[35] OR Data[6]) AND (Data[41] OR Data[20])) AND (((NOT Data[28]) XOR (Data[31] AND Data[5])) XOR (Data[47] OR Data[7])))) AND (((Data[2] XOR (Data[38] AND (Data[43] AND Data[19]))) XOR (Data[34] AND (Data[50] OR Data[43]))) OR (((Data[23] OR (Data[22] OR Data[33])) XOR (TRUE AND ((Data[8] XOR Data[3]) XOR Data[27]))) XOR Data[33])))))) XOR (NOT (NOT Data[8]))) OR (NOT (((((((NOT (Data[40] AND Data[39])) OR ((NOT Data[15]) OR Data[2])) XOR ((((((Data[13] XOR Data[11]) XOR Data[7]) XOR (Data[6] OR Data[47])) XOR (NOT Data[23])) XOR ((((Data[28] XOR TRUE) XOR Data[6]) XOR ((Data[42] XOR Data[3]) XOR Data[24])) XOR ((Data[39] XOR Data[15]) XOR Data[4]))) XOR (((Data[12] OR Data[17]) XOR TRUE) XOR FALSE))) XOR ((((NOT Data[9]) OR Data[1]) XOR ((Data[7] AND Data[4]) AND (Data[12] AND Data[46]))) XOR ((NOT Data[50]) OR (NOT Data[5])))) AND ((((NOT Data[33]) XOR ((NOT Data[10]) AND (TRUE OR Data[13]))) XOR (((Data[38] OR Data[36]) XOR (NOT Data[11])) XOR ((Data[41] XOR Data[36]) XOR Data[2]))) AND ((Data[3] AND (NOT Data[33])) OR (((Data[11] XOR Data[4]) XOR Data[15]) AND ((Data[16] XOR Data[18]) XOR Data[42]))))) OR (((NOT ((NOT Data[36]) OR (Data[29] AND Data[10]))) AND (((NOT (NOT Data[29])) XOR (((Data[46] XOR Data[20]) XOR Data[5]) OR (NOT Data[15]))) XOR (NOT (Data[19] AND Data[28])))) AND Data[22])) AND Data[36]))) AND ((((((((((Data[5] XOR Data[43]) XOR Data[50]) OR (((Data[35] AND Data[44]) OR (NOT Data[17])) OR Data[32])) OR (Data[40] OR ((NOT (Data[24] AND Data[47])) OR (NOT Data[46])))) XOR ((((((Data[23] XOR Data[46]) XOR Data[6]) AND (Data[38] OR Data[11])) OR ((Data[21] OR Data[2]) AND (Data[25] OR Data[18]))) AND (Data[18] AND (((Data[5] OR Data[34]) XOR (Data[1] AND Data[45])) XOR (NOT Data[20])))) AND (Data[42] AND (((Data[28] OR (Data[29] AND Data[36])) XOR (NOT ((Data[50] XOR Data[42]) XOR Data[4]))) XOR ((NOT Data[8]) AND (Data[16] OR Data[12])))))) XOR ((Data[28] AND (Data[35] AND ((Data[45] AND Data[3]) AND (NOT Data[4])))) OR (((NOT (NOT (Data[4] OR Data[40]))) XOR (Data[40] OR ((Data[1] XOR (Data[33] OR Data[11])) XOR ((Data[10] XOR Data[45]) XOR Data[41])))) XOR ((NOT (Data[18] AND Data[3])) OR ((NOT Data[19]) AND (Data[20] AND Data[45])))))) OR (NOT ((((NOT (((Data[25] AND Data[40]) XOR (TRUE OR Data[7])) XOR (Data[35] AND TRUE))) XOR (((NOT Data[7]) OR (Data[10] OR Data[33])) OR (((Data[35] XOR Data[14]) XOR Data[3]) AND (Data[34] AND Data[38])))) XOR (((NOT Data[27]) AND ((Data[14] XOR Data[11]) XOR TRUE)) OR ((Data[15] AND Data[28]) OR Data[26]))) OR Data[9]))) AND Data[4]) XOR ((Data[30] AND (((Data[2] AND (((((Data[34] OR Data[5]) AND Data[14]) AND Data[17]) XOR (NOT Data[40])) XOR (((Data[39] AND TRUE) AND (Data[18] OR Data[44])) OR (NOT (Data[38] AND Data[6]))))) XOR (Data[40] OR Data[7])) XOR Data[35])) OR TRUE)) XOR ((Data[15] XOR (NOT ((((NOT ((Data[16] AND Data[34]) OR ((Data[14] XOR Data[35]) XOR Data[24]))) OR ((((NOT Data[11]) AND Data[26]) XOR (NOT Data[29])) XOR Data[50])) OR (((Data[44] XOR ((NOT Data[6]) AND (Data[7] AND Data[43]))) XOR ((NOT Data[8]) OR ((Data[26] XOR Data[25]) XOR Data[4]))) OR ((NOT (Data[44] OR Data[8])) OR ((Data[20] OR Data[18]) OR ((Data[23] XOR Data[32]) XOR Data[47]))))) OR (((Data[42] XOR Data[45]) XOR (((((FALSE XOR Data[39]) XOR Data[6]) AND (Data[29] AND Data[4])) XOR Data[27]) XOR (NOT (Data[1] OR Data[9])))) OR ((((Data[29] OR Data[21]) AND (Data[19] AND Data[48])) OR (((Data[16] AND Data[28]) XOR ((FALSE XOR Data[39]) XOR Data[23])) XOR (Data[7] AND Data[15]))) OR ((NOT ((Data[11] XOR Data[24]) XOR Data[48])) OR ((Data[39] AND Data[34]) AND (Data[43] OR Data[43])))))))) XOR ((NOT ((((((((Data[7] AND Data[32]) AND Data[47]) XOR ((NOT Data[48]) OR (Data[49] AND Data[2]))) XOR ((Data[16] AND Data[30]) AND (Data[46] AND TRUE))) XOR (NOT Data[8])) XOR ((Data[14] AND (NOT Data[41])) OR ((NOT Data[11]) OR (Data[29] AND Data[50])))) XOR Data[20]) XOR (((((Data[27] AND Data[20]) AND (Data[50] AND Data[49])) OR ((NOT Data[22]) OR ((Data[37] XOR Data[14]) XOR Data[8]))) XOR (((Data[7] OR Data[17]) OR (Data[11] OR Data[13])) AND Data[19])) XOR (NOT ((Data[36] XOR (Data[19] AND Data[33])) XOR (Data[14] AND Data[27])))))) OR ((NOT ((((Data[12] AND Data[13]) AND Data[17]) AND Data[47]) AND ((NOT Data[17]) AND (((NOT Data[17]) XOR (NOT Data[38])) XOR (NOT Data[36]))))) OR (((((NOT ((Data[14] AND Data[50]) OR (Data[22] OR Data[34]))) XOR (((Data[7] XOR ((Data[13] XOR Data[14]) XOR Data[7])) XOR (NOT Data[10])) AND ((Data[40] AND Data[50]) AND ((Data[16] XOR Data[41]) XOR Data[34])))) XOR ((((NOT Data[2]) XOR (Data[37] OR Data[21])) XOR (NOT Data[50])) AND Data[34])) XOR ((((NOT Data[42]) XOR ((Data[28] AND Data[23]) AND (Data[40] OR Data[27]))) XOR (NOT (Data[8] OR Data[37]))) AND (Data[35] AND (NOT ((Data[8] XOR Data[28]) XOR Data[16]))))) XOR ((((((Data[22] XOR Data[20]) XOR Data[42]) OR (Data[28] AND Data[9])) OR (NOT ((Data[37] XOR Data[37]) XOR Data[13]))) XOR (NOT Data[45])) XOR (Data[22] AND (NOT (Data[15] OR Data[39]))))))))));
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
