(*
This code implements a randomly grown symbolic expression:

xor(xor(xor(xor(!(xor(xor(IN45, xor(xor((((xor(xor(IN19 & IN49, IN3 & IN10), !(IN13))) | IN18) & (IN2 | ((xor(xor(IN32, IN39), IN18)) | IN26))) | (!(((IN23 & IN4) & (!(IN25))) & (xor(xor(!(IN15), xor(xor(IN16, IN30), IN44)), xor(xor(IN26, true), IN50))))), !(((!(xor(xor(IN16, IN38), IN11))) | (IN17 | (!(IN22)))) | (!(!(!(IN31)))))), (((!(IN2)) & (!(IN49 | IN20))) & (xor(xor(IN27 & (xor(xor(IN47, IN2), true)), (IN21 | IN9) | IN35), IN15 | (!(IN16))))) & ((!(!(!(IN17)))) | (!(xor(xor(IN48, IN15 & IN19), xor(xor(IN13, IN36), IN25))))))), xor(xor(IN14 & (xor(xor(xor(xor((IN38 & IN38) & (IN45 | IN6), (IN12 & IN4) | (IN47 | IN26)), xor(xor(xor(xor(IN2, IN1), IN42), IN41 | IN2), IN43 | IN10)), (!(IN24 | IN39)) & (xor(xor(IN35 | IN36, xor(xor(IN4, IN46), IN47)), IN50))), (!(xor(xor(IN28, IN30), IN39))) & ((xor(xor(IN49, false), IN31)) & (IN28 | IN47)))), IN15), !(IN1 | ((xor(xor(!(IN18), IN14 & IN27), !(IN36))) | IN6))))), IN2 & (IN1 | (xor(xor((!((!(IN15)) & IN33)) | ((xor(xor(!(IN47 & IN44), !(IN7 | IN29)), IN11)) | IN29), !(xor(xor((!(IN12 & IN39)) | false, (!(xor(xor(IN31, IN8), IN12))) & (!(xor(xor(IN28, IN6), IN10)))), (!(IN24 & IN26)) & IN19))), (IN13 & (!(xor(xor(IN49 | IN17, xor(xor(IN33, IN42), IN4)), !(IN24))))) | (xor(xor(xor(xor((!(IN50)) | (xor(xor(IN3, IN9), IN8)), IN37), IN19 | (xor(xor(IN12, IN20), IN44))), (IN33 & (IN26 & IN37)) & false), xor(xor((IN32 | IN14) & (IN48 | IN15), !(IN4)), !(IN3 | IN8)))))))), xor(xor(!((!(IN34)) | (((xor(xor((!(IN25)) & (!(IN43)), (IN23 | IN23) | (IN42 & IN28)), xor(xor(!(IN5), IN21 | IN11), IN50 & IN21))) & ((xor(xor(IN37, !(IN2)), !(IN8))) | (!(false & IN28)))) & (IN29 & (!((xor(xor(IN20, IN26), IN43)) & (!(IN5))))))), true), !((!(xor(xor(!(!(IN28 & IN27)), (xor(xor(!(IN2), xor(xor(IN41, IN6), IN50)), IN12 | IN21)) & (!(IN3 | IN13))), IN49))) | (!(IN18))))), (xor(xor(((((xor(xor(IN22, xor(xor(xor(xor(IN37, IN31), IN43), IN27 & IN11), !(IN25))), (!(IN40)) | (!(IN2)))) | IN7) | (!((!(!(IN44))) & (!(IN8 & IN24))))) & (!(xor(xor(!((IN26 & IN1) & IN16), (xor(xor(IN41 & IN1, IN32 & IN4), !(IN18))) & (!(xor(xor(IN44, IN21), IN15)))), (IN23 | (!(IN34))) | ((!(IN17)) & (IN46 & IN20)))))) | (IN41 | ((!((!(IN2 & IN40)) | (xor(xor(IN46 | IN27, IN36 | IN6), IN32 | IN27)))) & (IN45 & IN16))), (xor(xor(!(xor(xor(xor(xor((IN20 | IN41) & (xor(xor(IN5, IN20), IN39)), xor(xor(xor(xor(IN37, IN31), IN10), IN16 | IN46), IN23)), !(IN17)), IN24), ((xor(xor(IN17, IN3), IN42)) & (xor(xor(false, IN16), IN39))) | (xor(xor(IN3 & IN19, xor(xor(IN41, IN14), IN47)), IN34)))), IN24 | (!(IN14))), !(!(xor(xor(xor(xor(IN14 | IN36, xor(xor(IN23, IN17), IN46)), xor(xor(IN43, IN17), IN26)), (IN46 | IN37) & IN46), (xor(xor(IN8, IN26), IN43)) | (xor(xor(IN40, IN26), IN13))))))) & (xor(xor(IN19, IN10), IN40))), xor(xor(xor(xor((!(xor(xor((!(IN23)) & (!(IN4)), (xor(xor(IN26, IN41), IN36)) & (!(IN40))), (IN30 & IN42) & (IN34 | IN28)))) | (((!(IN26 & IN27)) & IN21) | IN10), IN31), IN33), IN45), ((!(IN15)) | ((IN11 & (!(IN41))) | ((xor(xor(IN38 & IN2, xor(xor(IN15, IN9), false)), !(IN31))) & ((IN3 | IN41) | (IN37 | IN31))))) & (!((((IN22 & IN49) & (xor(xor(IN49, IN14), IN33))) & (!(IN19 & IN10))) & IN43))))) & (!(IN50))), !((xor(xor(xor(xor(((xor(xor((IN29 | true) | IN10, xor(xor(xor(xor(IN46, IN7), IN5), IN26 & IN16), IN12)), (!(IN43)) | true)) | IN5) | (xor(xor(xor(xor((IN6 & IN18) & (IN49 & IN8), IN5 | (IN39 & IN35)), !(!(IN46))), ((xor(xor(IN10, IN40), IN6)) | (!(IN21))) & ((xor(xor(IN34, IN25), IN41)) & IN41)), IN33 | ((IN36 | true) & (IN12 & IN4)))), xor(xor(((xor(xor(IN12 | IN37, IN19), xor(xor(IN48, IN36), IN11))) | (xor(xor(IN34 | IN24, xor(xor(IN43, IN29), IN46)), xor(xor(IN9, IN7), IN3)))) | (((!(IN46)) & (xor(xor(IN41, IN21), IN12))) & IN43), IN15 | (!((!(IN15)) | (!(IN27))))), IN50)), (IN45 & (xor(xor(!(IN1), IN10), (!(IN12)) & (!(IN15))))) & (!(!(!(xor(xor(IN34, IN4), IN32)))))), (!((!(!(!(IN19)))) | (((xor(xor(IN49, IN25), IN23)) | (IN41 | IN31)) | (IN18 | (xor(xor(IN6, IN49), IN46)))))) | ((xor(xor(IN25, (!(IN6 | IN43)) | ((IN36 & IN19) & true)), false | IN41)) | IN37)), (!(((IN45 | (xor(xor(IN26, IN35), IN22))) | (xor(xor(IN20 & IN12, IN41 | IN12), IN20))) & (((IN38 & IN32) & (IN28 | IN14)) & (!(IN49 & IN15))))) | ((!((xor(xor(true & IN12, xor(xor(IN3, IN2), IN3)), IN20)) & (xor(xor(IN31, IN49), xor(xor(true, IN45), IN9))))) | (xor(xor((xor(xor(IN34 | IN2, IN13), xor(xor(IN34, IN10), IN43))) & IN49, ((xor(xor(IN4, IN7), IN45)) & IN6) | IN12), !(IN49 & (IN37 & IN8))))))) & (xor(xor(IN27, ((xor(xor(xor(xor((!(IN33)) | IN34, xor(xor(IN43 & IN37, xor(xor(IN25, IN31), IN29)), !(IN35))), (!(IN44)) | (IN36 | IN18)), IN10), !(IN23))) | ((xor(xor(!(IN13), IN36 | (true | IN25)), !(IN23 | IN16))) & (!(IN30)))) | (((xor(xor((IN43 & IN35) & IN36, !(!(IN2))), (!(IN13)) | IN30)) | ((!(IN2 | IN30)) & (xor(xor(xor(xor(IN3, IN17), IN29), IN45 | IN8), xor(xor(IN13, IN49), IN16))))) & ((xor(xor(xor(xor(IN28, IN25 | true), IN27), xor(xor(!(IN33), IN45 & IN24), !(IN6))), IN47)) | (!((xor(xor(IN6, IN25), IN24)) | (IN44 | IN22)))))), !(((xor(xor((false & IN49) & (xor(xor(IN16, IN18), IN50)), (!(IN23)) & (xor(xor(IN34, IN20), IN44))), (IN8 | IN3) & (!(IN32)))) | ((xor(xor(!(IN44), true & IN49), IN49)) | (IN15 | (xor(xor(IN5, IN32), IN2))))) & ((xor(xor(IN13 | (xor(xor(IN13, IN1), IN44)), (xor(xor(IN43, IN28), IN15)) | (xor(xor(IN21, IN37), IN45))), !(IN34 & IN2))) | (((IN34 & IN32) | IN29) & (!(xor(xor(IN18, IN4), IN40))))))))))

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
    Out := (((((NOT ((Data[45] XOR ((((((((Data[19] AND Data[49]) XOR (Data[3] AND Data[10])) XOR (NOT Data[13])) OR Data[18]) AND (Data[2] OR (((Data[32] XOR Data[39]) XOR Data[18]) OR Data[26]))) OR (NOT (((Data[23] AND Data[4]) AND (NOT Data[25])) AND (((NOT Data[15]) XOR ((Data[16] XOR Data[30]) XOR Data[44])) XOR ((Data[26] XOR TRUE) XOR Data[50]))))) XOR (NOT (((NOT ((Data[16] XOR Data[38]) XOR Data[11])) OR (Data[17] OR (NOT Data[22]))) OR (NOT (NOT (NOT Data[31])))))) XOR ((((NOT Data[2]) AND (NOT (Data[49] OR Data[20]))) AND (((Data[27] AND ((Data[47] XOR Data[2]) XOR TRUE)) XOR ((Data[21] OR Data[9]) OR Data[35])) XOR (Data[15] OR (NOT Data[16])))) AND ((NOT (NOT (NOT Data[17]))) OR (NOT ((Data[48] XOR (Data[15] AND Data[19])) XOR ((Data[13] XOR Data[36]) XOR Data[25]))))))) XOR (((Data[14] AND ((((((Data[38] AND Data[38]) AND (Data[45] OR Data[6])) XOR ((Data[12] AND Data[4]) OR (Data[47] OR Data[26]))) XOR ((((Data[2] XOR Data[1]) XOR Data[42]) XOR (Data[41] OR Data[2])) XOR (Data[43] OR Data[10]))) XOR ((NOT (Data[24] OR Data[39])) AND (((Data[35] OR Data[36]) XOR ((Data[4] XOR Data[46]) XOR Data[47])) XOR Data[50]))) XOR ((NOT ((Data[28] XOR Data[30]) XOR Data[39])) AND (((Data[49] XOR FALSE) XOR Data[31]) AND (Data[28] OR Data[47]))))) XOR Data[15]) XOR (NOT (Data[1] OR ((((NOT Data[18]) XOR (Data[14] AND Data[27])) XOR (NOT Data[36])) OR Data[6])))))) XOR (Data[2] AND (Data[1] OR ((((NOT ((NOT Data[15]) AND Data[33])) OR ((((NOT (Data[47] AND Data[44])) XOR (NOT (Data[7] OR Data[29]))) XOR Data[11]) OR Data[29])) XOR (NOT ((((NOT (Data[12] AND Data[39])) OR FALSE) XOR ((NOT ((Data[31] XOR Data[8]) XOR Data[12])) AND (NOT ((Data[28] XOR Data[6]) XOR Data[10])))) XOR ((NOT (Data[24] AND Data[26])) AND Data[19])))) XOR ((Data[13] AND (NOT (((Data[49] OR Data[17]) XOR ((Data[33] XOR Data[42]) XOR Data[4])) XOR (NOT Data[24])))) OR ((((((NOT Data[50]) OR ((Data[3] XOR Data[9]) XOR Data[8])) XOR Data[37]) XOR (Data[19] OR ((Data[12] XOR Data[20]) XOR Data[44]))) XOR ((Data[33] AND (Data[26] AND Data[37])) AND FALSE)) XOR ((((Data[32] OR Data[14]) AND (Data[48] OR Data[15])) XOR (NOT Data[4])) XOR (NOT (Data[3] OR Data[8]))))))))) XOR (((NOT ((NOT Data[34]) OR ((((((NOT Data[25]) AND (NOT Data[43])) XOR ((Data[23] OR Data[23]) OR (Data[42] AND Data[28]))) XOR (((NOT Data[5]) XOR (Data[21] OR Data[11])) XOR (Data[50] AND Data[21]))) AND (((Data[37] XOR (NOT Data[2])) XOR (NOT Data[8])) OR (NOT (FALSE AND Data[28])))) AND (Data[29] AND (NOT (((Data[20] XOR Data[26]) XOR Data[43]) AND (NOT Data[5]))))))) XOR TRUE) XOR (NOT ((NOT (((NOT (NOT (Data[28] AND Data[27]))) XOR ((((NOT Data[2]) XOR ((Data[41] XOR Data[6]) XOR Data[50])) XOR (Data[12] OR Data[21])) AND (NOT (Data[3] OR Data[13])))) XOR Data[49])) OR (NOT Data[18]))))) XOR (((((((((Data[22] XOR ((((Data[37] XOR Data[31]) XOR Data[43]) XOR (Data[27] AND Data[11])) XOR (NOT Data[25]))) XOR ((NOT Data[40]) OR (NOT Data[2]))) OR Data[7]) OR (NOT ((NOT (NOT Data[44])) AND (NOT (Data[8] AND Data[24]))))) AND (NOT (((NOT ((Data[26] AND Data[1]) AND Data[16])) XOR ((((Data[41] AND Data[1]) XOR (Data[32] AND Data[4])) XOR (NOT Data[18])) AND (NOT ((Data[44] XOR Data[21]) XOR Data[15])))) XOR ((Data[23] OR (NOT Data[34])) OR ((NOT Data[17]) AND (Data[46] AND Data[20])))))) OR (Data[41] OR ((NOT ((NOT (Data[2] AND Data[40])) OR (((Data[46] OR Data[27]) XOR (Data[36] OR Data[6])) XOR (Data[32] OR Data[27])))) AND (Data[45] AND Data[16])))) XOR ((((NOT ((((((Data[20] OR Data[41]) AND ((Data[5] XOR Data[20]) XOR Data[39])) XOR ((((Data[37] XOR Data[31]) XOR Data[10]) XOR (Data[16] OR Data[46])) XOR Data[23])) XOR (NOT Data[17])) XOR Data[24]) XOR ((((Data[17] XOR Data[3]) XOR Data[42]) AND ((FALSE XOR Data[16]) XOR Data[39])) OR (((Data[3] AND Data[19]) XOR ((Data[41] XOR Data[14]) XOR Data[47])) XOR Data[34])))) XOR (Data[24] OR (NOT Data[14]))) XOR (NOT (NOT (((((Data[14] OR Data[36]) XOR ((Data[23] XOR Data[17]) XOR Data[46])) XOR ((Data[43] XOR Data[17]) XOR Data[26])) XOR ((Data[46] OR Data[37]) AND Data[46])) XOR (((Data[8] XOR Data[26]) XOR Data[43]) OR ((Data[40] XOR Data[26]) XOR Data[13])))))) AND ((Data[19] XOR Data[10]) XOR Data[40]))) XOR ((((((NOT ((((NOT Data[23]) AND (NOT Data[4])) XOR (((Data[26] XOR Data[41]) XOR Data[36]) AND (NOT Data[40]))) XOR ((Data[30] AND Data[42]) AND (Data[34] OR Data[28])))) OR (((NOT (Data[26] AND Data[27])) AND Data[21]) OR Data[10])) XOR Data[31]) XOR Data[33]) XOR Data[45]) XOR (((NOT Data[15]) OR ((Data[11] AND (NOT Data[41])) OR ((((Data[38] AND Data[2]) XOR ((Data[15] XOR Data[9]) XOR FALSE)) XOR (NOT Data[31])) AND ((Data[3] OR Data[41]) OR (Data[37] OR Data[31]))))) AND (NOT ((((Data[22] AND Data[49]) AND ((Data[49] XOR Data[14]) XOR Data[33])) AND (NOT (Data[19] AND Data[10]))) AND Data[43]))))) AND (NOT Data[50]))) XOR (NOT (((((((((((Data[29] OR TRUE) OR Data[10]) XOR ((((Data[46] XOR Data[7]) XOR Data[5]) XOR (Data[26] AND Data[16])) XOR Data[12])) XOR ((NOT Data[43]) OR TRUE)) OR Data[5]) OR ((((((Data[6] AND Data[18]) AND (Data[49] AND Data[8])) XOR (Data[5] OR (Data[39] AND Data[35]))) XOR (NOT (NOT Data[46]))) XOR ((((Data[10] XOR Data[40]) XOR Data[6]) OR (NOT Data[21])) AND (((Data[34] XOR Data[25]) XOR Data[41]) AND Data[41]))) XOR (Data[33] OR ((Data[36] OR TRUE) AND (Data[12] AND Data[4]))))) XOR (((((((Data[12] OR Data[37]) XOR Data[19]) XOR ((Data[48] XOR Data[36]) XOR Data[11])) OR (((Data[34] OR Data[24]) XOR ((Data[43] XOR Data[29]) XOR Data[46])) XOR ((Data[9] XOR Data[7]) XOR Data[3]))) OR (((NOT Data[46]) AND ((Data[41] XOR Data[21]) XOR Data[12])) AND Data[43])) XOR (Data[15] OR (NOT ((NOT Data[15]) OR (NOT Data[27]))))) XOR Data[50])) XOR ((Data[45] AND (((NOT Data[1]) XOR Data[10]) XOR ((NOT Data[12]) AND (NOT Data[15])))) AND (NOT (NOT (NOT ((Data[34] XOR Data[4]) XOR Data[32])))))) XOR ((NOT ((NOT (NOT (NOT Data[19]))) OR ((((Data[49] XOR Data[25]) XOR Data[23]) OR (Data[41] OR Data[31])) OR (Data[18] OR ((Data[6] XOR Data[49]) XOR Data[46]))))) OR (((Data[25] XOR ((NOT (Data[6] OR Data[43])) OR ((Data[36] AND Data[19]) AND TRUE))) XOR (FALSE OR Data[41])) OR Data[37]))) XOR ((NOT (((Data[45] OR ((Data[26] XOR Data[35]) XOR Data[22])) OR (((Data[20] AND Data[12]) XOR (Data[41] OR Data[12])) XOR Data[20])) AND (((Data[38] AND Data[32]) AND (Data[28] OR Data[14])) AND (NOT (Data[49] AND Data[15]))))) OR ((NOT ((((TRUE AND Data[12]) XOR ((Data[3] XOR Data[2]) XOR Data[3])) XOR Data[20]) AND ((Data[31] XOR Data[49]) XOR ((TRUE XOR Data[45]) XOR Data[9])))) OR ((((((Data[34] OR Data[2]) XOR Data[13]) XOR ((Data[34] XOR Data[10]) XOR Data[43])) AND Data[49]) XOR ((((Data[4] XOR Data[7]) XOR Data[45]) AND Data[6]) OR Data[12])) XOR (NOT (Data[49] AND (Data[37] AND Data[8]))))))) AND ((Data[27] XOR ((((((((NOT Data[33]) OR Data[34]) XOR (((Data[43] AND Data[37]) XOR ((Data[25] XOR Data[31]) XOR Data[29])) XOR (NOT Data[35]))) XOR ((NOT Data[44]) OR (Data[36] OR Data[18]))) XOR Data[10]) XOR (NOT Data[23])) OR ((((NOT Data[13]) XOR (Data[36] OR (TRUE OR Data[25]))) XOR (NOT (Data[23] OR Data[16]))) AND (NOT Data[30]))) OR ((((((Data[43] AND Data[35]) AND Data[36]) XOR (NOT (NOT Data[2]))) XOR ((NOT Data[13]) OR Data[30])) OR ((NOT (Data[2] OR Data[30])) AND ((((Data[3] XOR Data[17]) XOR Data[29]) XOR (Data[45] OR Data[8])) XOR ((Data[13] XOR Data[49]) XOR Data[16])))) AND (((((Data[28] XOR (Data[25] OR TRUE)) XOR Data[27]) XOR (((NOT Data[33]) XOR (Data[45] AND Data[24])) XOR (NOT Data[6]))) XOR Data[47]) OR (NOT (((Data[6] XOR Data[25]) XOR Data[24]) OR (Data[44] OR Data[22]))))))) XOR (NOT ((((((FALSE AND Data[49]) AND ((Data[16] XOR Data[18]) XOR Data[50])) XOR ((NOT Data[23]) AND ((Data[34] XOR Data[20]) XOR Data[44]))) XOR ((Data[8] OR Data[3]) AND (NOT Data[32]))) OR ((((NOT Data[44]) XOR (TRUE AND Data[49])) XOR Data[49]) OR (Data[15] OR ((Data[5] XOR Data[32]) XOR Data[2])))) AND ((((Data[13] OR ((Data[13] XOR Data[1]) XOR Data[44])) XOR (((Data[43] XOR Data[28]) XOR Data[15]) OR ((Data[21] XOR Data[37]) XOR Data[45]))) XOR (NOT (Data[34] AND Data[2]))) OR (((Data[34] AND Data[32]) OR Data[29]) AND (NOT ((Data[18] XOR Data[4]) XOR Data[40]))))))))));
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
