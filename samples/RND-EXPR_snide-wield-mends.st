(*
This code implements a randomly grown symbolic expression:

xor(xor((IN31 | IN23) | (xor(xor(!(xor(xor(xor(xor(IN48 & ((!(IN3 & IN35)) | IN15), IN6), !(IN33)), xor(xor(IN50, ((xor(xor(xor(xor(IN48, IN27), IN16), IN48 | IN20), !(IN9))) | (xor(xor(IN14, IN12 | IN13), !(IN47)))) & (!((IN40 | IN41) & IN9))), xor(xor(!((IN21 | IN6) & (IN39 & false)), !(!(xor(xor(IN2, IN8), IN35)))), xor(xor(!(xor(xor(IN49, IN28), IN17)), xor(xor(IN12 & IN32, IN39 | IN4), xor(xor(IN33, IN18), IN8))), true & (xor(xor(IN30, false), IN15)))))), (xor(xor((!(IN15 & IN10)) & (!(IN15)), !((IN28 & IN8) & (xor(xor(IN6, IN22), IN29)))), IN47)) & IN31)), IN35), xor(xor((xor(xor((IN15 | (xor(xor(IN2 & IN35, IN1 & IN31), xor(xor(IN28, IN26), IN48)))) | (!((IN39 | IN9) | (xor(xor(IN29, IN24), IN48)))), IN46), (!(xor(xor(!(IN37), IN3 | IN24), false | IN21))) & ((xor(xor(false, IN28), IN48)) & (xor(xor(xor(xor(IN11, IN28), IN41), !(IN11)), xor(xor(IN9, IN16), IN3)))))) & (xor(xor((IN39 | IN36) | true, ((!(IN26)) & (!(IN3 & IN26))) | (!(!(IN11 & IN19)))), false)), (!(((xor(xor(IN12, xor(xor(IN21, IN49), IN43)), IN11 | IN28)) & (!(IN5))) & IN7)) & (xor(xor((!(IN27 | (!(IN26)))) & (((!(IN39)) & (!(IN25))) & (xor(xor(IN17, !(IN38)), IN13 | IN3))), xor(xor(!(IN5), xor(xor((IN49 | IN17) | (IN6 | IN13), (!(IN33)) | (xor(xor(IN23, IN31), IN24))), !(!(IN8)))), IN1)), (!((IN43 | IN50) | IN18)) | IN20))), xor(xor(IN19, xor(xor(IN27 & (!(!(!(IN47)))), IN12 | true), IN18 | (((!(IN36)) | (xor(xor(IN36, IN10), IN14))) | IN45))), !(!((!(xor(xor(IN38, IN5), IN48))) & false)))))), (((!(IN11)) | (xor(xor(IN36 & (!(!(!(xor(xor(IN13, true), IN43))))), (xor(xor(IN11 & (!(IN7 | IN32)), (xor(xor(!(IN29), IN4 | IN20), IN17 & IN24)) | ((IN17 | IN26) | (IN12 & IN3))), xor(xor(xor(xor(!(IN44), IN19), xor(xor(IN47, IN47), IN5)), IN5), xor(xor(!(IN39), IN44 | IN27), IN1 | IN29)))) & (!((!(xor(xor(IN38, IN34), IN37))) & ((xor(xor(IN30, IN33), true)) & (!(IN47)))))), ((xor(xor(!(IN13), !(IN2)), IN28)) & (!(!(!(IN13))))) & (IN45 & (xor(xor(xor(xor(IN15 & IN8, xor(xor(IN26, IN42), IN47)), !(IN41)), IN34), IN1)))))) & IN24) & (((xor(xor(xor(xor((xor(xor((xor(xor(IN35, IN39), IN20)) | (xor(xor(IN36, IN37), IN19)), (IN35 | IN31) & (IN45 | false)), (!(IN17)) & (xor(xor(IN32, IN33), IN23)))) & (((IN1 | IN47) & (xor(xor(IN45, IN27), IN43))) | (!(!(IN49)))), (((xor(xor(IN29, IN1), IN42)) | (IN40 & IN27)) & (!(IN31 | IN23))) & (((IN38 & IN23) & IN15) | ((IN39 | IN42) | (xor(xor(IN34, IN7), IN36))))), IN21), IN9), !(IN40 & ((!(xor(xor(IN11, IN33), IN9))) & IN40)))) | (xor(xor(IN39, !(xor(xor(((IN37 | IN29) & IN23) | ((!(IN41)) | (IN16 | IN19)), IN39), ((IN30 | IN38) & (IN39 & IN44)) | (!(IN50 & IN22))))), xor(xor(IN38 & (xor(xor(IN27, !(xor(xor(IN29, IN17), IN45))), xor(xor(xor(xor(IN16, IN47), IN12), !(IN42)), !(IN38)))), (xor(xor((xor(xor(IN14, IN16), false)) & (xor(xor(IN44, IN10), IN45)), (xor(xor(IN40, IN26), IN21)) & (xor(xor(IN50, IN34), IN46))), xor(xor(xor(xor(IN49, IN33), IN7), IN47 | IN23), xor(xor(IN28, IN1), IN33)))) | (IN45 | (true | (IN30 & IN28)))), IN26 & IN50)))) | (xor(xor(true & IN38, !((xor(xor((xor(xor(IN26, IN49 | IN45), false)) & (IN35 & IN45), xor(xor((IN43 | IN36) | IN17, (IN25 & IN16) & (xor(xor(IN43, IN36), IN41))), IN29)), xor(xor(xor(xor(IN19, xor(xor(IN19, IN45), IN40)), IN44 & IN38), xor(xor(IN10, !(IN33)), false | IN36)), xor(xor(!(IN14), IN47 | IN32), IN25)))) | (false & (xor(xor(!(xor(xor(IN46, IN37), IN43)), (!(IN43)) | (xor(xor(IN25, IN27), IN29))), (IN17 & IN42) | (!(IN40))))))), xor(xor(xor(xor(IN31, !(!((IN5 & IN11) | (IN3 | IN20)))), ((!(xor(xor(IN39, IN16), IN38))) | IN2) & (xor(xor(xor(xor(!(IN11), IN6), xor(xor(true, IN13), IN16)), xor(xor(IN6, xor(xor(IN12, IN19), IN19)), IN26)), (!(IN40)) | (IN14 & IN1)))), !(!(((IN17 | IN1) & (IN31 | IN21)) | (xor(xor(true, IN14 | IN14), IN21 & IN36))))), !(!(IN33))))))), ((!(xor(xor(xor(xor((((IN33 | IN12) | (!(IN10))) & ((IN42 | IN2) & (!(IN49)))) | (((IN33 | IN27) | (IN48 | IN39)) & ((IN47 | IN41) | IN16)), !(xor(xor((IN46 | IN39) & (xor(xor(IN34, IN22), IN21)), IN29), (xor(xor(IN23, IN35), IN18)) & (IN12 | IN50)))), IN44), (xor(xor(!((IN37 | IN49) | (IN50 | IN50)), IN47), !(!(IN29 | IN35)))) & IN47), IN46))) & (IN34 & (!((((!(IN48)) & (xor(xor(IN37 & IN5, !(IN14)), !(IN45)))) | (true | IN43)) & (xor(xor((IN40 & (xor(xor(IN6, IN6), IN20))) | (!(IN47 | IN43)), !(xor(xor(IN43 & IN14, IN46), IN13 & IN23))), (!(!(IN42))) | ((IN36 & IN45) | (IN6 | IN4)))))))) | IN39)

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
    Out := ((((Data[31] OR Data[23]) OR (((NOT (((((Data[48] AND ((NOT (Data[3] AND Data[35])) OR Data[15])) XOR Data[6]) XOR (NOT Data[33])) XOR ((Data[50] XOR ((((((Data[48] XOR Data[27]) XOR Data[16]) XOR (Data[48] OR Data[20])) XOR (NOT Data[9])) OR ((Data[14] XOR (Data[12] OR Data[13])) XOR (NOT Data[47]))) AND (NOT ((Data[40] OR Data[41]) AND Data[9])))) XOR (((NOT ((Data[21] OR Data[6]) AND (Data[39] AND FALSE))) XOR (NOT (NOT ((Data[2] XOR Data[8]) XOR Data[35])))) XOR (((NOT ((Data[49] XOR Data[28]) XOR Data[17])) XOR (((Data[12] AND Data[32]) XOR (Data[39] OR Data[4])) XOR ((Data[33] XOR Data[18]) XOR Data[8]))) XOR (TRUE AND ((Data[30] XOR FALSE) XOR Data[15])))))) XOR (((((NOT (Data[15] AND Data[10])) AND (NOT Data[15])) XOR (NOT ((Data[28] AND Data[8]) AND ((Data[6] XOR Data[22]) XOR Data[29])))) XOR Data[47]) AND Data[31]))) XOR Data[35]) XOR (((((((Data[15] OR (((Data[2] AND Data[35]) XOR (Data[1] AND Data[31])) XOR ((Data[28] XOR Data[26]) XOR Data[48]))) OR (NOT ((Data[39] OR Data[9]) OR ((Data[29] XOR Data[24]) XOR Data[48])))) XOR Data[46]) XOR ((NOT (((NOT Data[37]) XOR (Data[3] OR Data[24])) XOR (FALSE OR Data[21]))) AND (((FALSE XOR Data[28]) XOR Data[48]) AND ((((Data[11] XOR Data[28]) XOR Data[41]) XOR (NOT Data[11])) XOR ((Data[9] XOR Data[16]) XOR Data[3]))))) AND ((((Data[39] OR Data[36]) OR TRUE) XOR (((NOT Data[26]) AND (NOT (Data[3] AND Data[26]))) OR (NOT (NOT (Data[11] AND Data[19]))))) XOR FALSE)) XOR ((NOT ((((Data[12] XOR ((Data[21] XOR Data[49]) XOR Data[43])) XOR (Data[11] OR Data[28])) AND (NOT Data[5])) AND Data[7])) AND ((((NOT (Data[27] OR (NOT Data[26]))) AND (((NOT Data[39]) AND (NOT Data[25])) AND ((Data[17] XOR (NOT Data[38])) XOR (Data[13] OR Data[3])))) XOR (((NOT Data[5]) XOR ((((Data[49] OR Data[17]) OR (Data[6] OR Data[13])) XOR ((NOT Data[33]) OR ((Data[23] XOR Data[31]) XOR Data[24]))) XOR (NOT (NOT Data[8])))) XOR Data[1])) XOR ((NOT ((Data[43] OR Data[50]) OR Data[18])) OR Data[20])))) XOR ((Data[19] XOR (((Data[27] AND (NOT (NOT (NOT Data[47])))) XOR (Data[12] OR TRUE)) XOR (Data[18] OR (((NOT Data[36]) OR ((Data[36] XOR Data[10]) XOR Data[14])) OR Data[45])))) XOR (NOT (NOT ((NOT ((Data[38] XOR Data[5]) XOR Data[48])) AND FALSE))))))) XOR ((((NOT Data[11]) OR (((Data[36] AND (NOT (NOT (NOT ((Data[13] XOR TRUE) XOR Data[43]))))) XOR ((((Data[11] AND (NOT (Data[7] OR Data[32]))) XOR ((((NOT Data[29]) XOR (Data[4] OR Data[20])) XOR (Data[17] AND Data[24])) OR ((Data[17] OR Data[26]) OR (Data[12] AND Data[3])))) XOR (((((NOT Data[44]) XOR Data[19]) XOR ((Data[47] XOR Data[47]) XOR Data[5])) XOR Data[5]) XOR (((NOT Data[39]) XOR (Data[44] OR Data[27])) XOR (Data[1] OR Data[29])))) AND (NOT ((NOT ((Data[38] XOR Data[34]) XOR Data[37])) AND (((Data[30] XOR Data[33]) XOR TRUE) AND (NOT Data[47])))))) XOR (((((NOT Data[13]) XOR (NOT Data[2])) XOR Data[28]) AND (NOT (NOT (NOT Data[13])))) AND (Data[45] AND (((((Data[15] AND Data[8]) XOR ((Data[26] XOR Data[42]) XOR Data[47])) XOR (NOT Data[41])) XOR Data[34]) XOR Data[1]))))) AND Data[24]) AND ((((((((((((Data[35] XOR Data[39]) XOR Data[20]) OR ((Data[36] XOR Data[37]) XOR Data[19])) XOR ((Data[35] OR Data[31]) AND (Data[45] OR FALSE))) XOR ((NOT Data[17]) AND ((Data[32] XOR Data[33]) XOR Data[23]))) AND (((Data[1] OR Data[47]) AND ((Data[45] XOR Data[27]) XOR Data[43])) OR (NOT (NOT Data[49])))) XOR (((((Data[29] XOR Data[1]) XOR Data[42]) OR (Data[40] AND Data[27])) AND (NOT (Data[31] OR Data[23]))) AND (((Data[38] AND Data[23]) AND Data[15]) OR ((Data[39] OR Data[42]) OR ((Data[34] XOR Data[7]) XOR Data[36]))))) XOR Data[21]) XOR Data[9]) XOR (NOT (Data[40] AND ((NOT ((Data[11] XOR Data[33]) XOR Data[9])) AND Data[40])))) OR ((Data[39] XOR (NOT (((((Data[37] OR Data[29]) AND Data[23]) OR ((NOT Data[41]) OR (Data[16] OR Data[19]))) XOR Data[39]) XOR (((Data[30] OR Data[38]) AND (Data[39] AND Data[44])) OR (NOT (Data[50] AND Data[22])))))) XOR (((Data[38] AND ((Data[27] XOR (NOT ((Data[29] XOR Data[17]) XOR Data[45]))) XOR ((((Data[16] XOR Data[47]) XOR Data[12]) XOR (NOT Data[42])) XOR (NOT Data[38])))) XOR ((((((Data[14] XOR Data[16]) XOR FALSE) AND ((Data[44] XOR Data[10]) XOR Data[45])) XOR (((Data[40] XOR Data[26]) XOR Data[21]) AND ((Data[50] XOR Data[34]) XOR Data[46]))) XOR ((((Data[49] XOR Data[33]) XOR Data[7]) XOR (Data[47] OR Data[23])) XOR ((Data[28] XOR Data[1]) XOR Data[33]))) OR (Data[45] OR (TRUE OR (Data[30] AND Data[28]))))) XOR (Data[26] AND Data[50])))) OR (((TRUE AND Data[38]) XOR (NOT ((((((Data[26] XOR (Data[49] OR Data[45])) XOR FALSE) AND (Data[35] AND Data[45])) XOR ((((Data[43] OR Data[36]) OR Data[17]) XOR ((Data[25] AND Data[16]) AND ((Data[43] XOR Data[36]) XOR Data[41]))) XOR Data[29])) XOR ((((Data[19] XOR ((Data[19] XOR Data[45]) XOR Data[40])) XOR (Data[44] AND Data[38])) XOR ((Data[10] XOR (NOT Data[33])) XOR (FALSE OR Data[36]))) XOR (((NOT Data[14]) XOR (Data[47] OR Data[32])) XOR Data[25]))) OR (FALSE AND (((NOT ((Data[46] XOR Data[37]) XOR Data[43])) XOR ((NOT Data[43]) OR ((Data[25] XOR Data[27]) XOR Data[29]))) XOR ((Data[17] AND Data[42]) OR (NOT Data[40]))))))) XOR ((((Data[31] XOR (NOT (NOT ((Data[5] AND Data[11]) OR (Data[3] OR Data[20]))))) XOR (((NOT ((Data[39] XOR Data[16]) XOR Data[38])) OR Data[2]) AND (((((NOT Data[11]) XOR Data[6]) XOR ((TRUE XOR Data[13]) XOR Data[16])) XOR ((Data[6] XOR ((Data[12] XOR Data[19]) XOR Data[19])) XOR Data[26])) XOR ((NOT Data[40]) OR (Data[14] AND Data[1]))))) XOR (NOT (NOT (((Data[17] OR Data[1]) AND (Data[31] OR Data[21])) OR ((TRUE XOR (Data[14] OR Data[14])) XOR (Data[21] AND Data[36])))))) XOR (NOT (NOT Data[33]))))))) XOR (((NOT ((((((((Data[33] OR Data[12]) OR (NOT Data[10])) AND ((Data[42] OR Data[2]) AND (NOT Data[49]))) OR (((Data[33] OR Data[27]) OR (Data[48] OR Data[39])) AND ((Data[47] OR Data[41]) OR Data[16]))) XOR (NOT ((((Data[46] OR Data[39]) AND ((Data[34] XOR Data[22]) XOR Data[21])) XOR Data[29]) XOR (((Data[23] XOR Data[35]) XOR Data[18]) AND (Data[12] OR Data[50]))))) XOR Data[44]) XOR ((((NOT ((Data[37] OR Data[49]) OR (Data[50] OR Data[50]))) XOR Data[47]) XOR (NOT (NOT (Data[29] OR Data[35])))) AND Data[47])) XOR Data[46])) AND (Data[34] AND (NOT ((((NOT Data[48]) AND (((Data[37] AND Data[5]) XOR (NOT Data[14])) XOR (NOT Data[45]))) OR (TRUE OR Data[43])) AND ((((Data[40] AND ((Data[6] XOR Data[6]) XOR Data[20])) OR (NOT (Data[47] OR Data[43]))) XOR (NOT (((Data[43] AND Data[14]) XOR Data[46]) XOR (Data[13] AND Data[23])))) XOR ((NOT (NOT Data[42])) OR ((Data[36] AND Data[45]) OR (Data[6] OR Data[4])))))))) OR Data[39]));
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
