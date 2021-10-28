(*
This code implements a randomly grown symbolic expression:

(xor(xor(!(IN49), IN20), !(!((!(!(IN20))) | ((!(((IN1 | IN21) & (xor(xor(IN13, IN2), IN39))) & (!(IN34 | IN7)))) & (!(!(xor(xor(IN4 & IN42, xor(xor(IN12, IN33), IN1)), !(IN24)))))))))) | (xor(xor(xor(xor(xor(xor(((xor(xor(!(!(IN2 & IN8)), ((IN41 & IN1) & (IN10 | IN13)) & IN47), !((xor(xor(IN42, IN37), IN36)) & IN20))) & true) | IN48, IN37), (!((!((xor(xor(IN26, IN18), IN46)) | (IN49 & IN34))) | (((xor(xor(IN3, IN49), IN16)) | (!(IN33))) | IN21))) & (xor(xor((!(xor(xor(false | IN24, !(IN1)), xor(xor(IN46, IN37), IN21)))) & (!(IN49)), IN13), !(xor(xor((IN41 | IN32) | IN21, (xor(xor(IN18, IN1), IN35)) | (xor(xor(IN21, IN7), IN35))), (!(IN41)) & (IN27 & IN20)))))), (((((IN50 & (xor(xor(IN19, IN26), IN19))) & ((!(IN47)) & (xor(xor(IN48, IN2), IN5)))) & ((xor(xor(IN45 & IN7, IN16 | IN6), IN37)) & ((!(IN35)) | (!(IN34))))) & (IN30 & ((!(IN5 | IN39)) & IN24))) & ((xor(xor(false, xor(xor(IN9, (IN26 | IN23) | (IN11 | IN43)), !(xor(xor(IN43, IN8), IN5)))), xor(xor(IN14, !(IN40 & IN5)), (IN6 | IN9) & (!(IN19))))) | (!(!((IN32 | IN42) | (!(IN2))))))) | (!((!(xor(xor(xor(xor(IN8 & IN44, !(IN27)), IN30 & IN14), xor(xor(xor(xor(true, IN38), IN6), IN42 & IN45), IN38 | IN48)), xor(xor(IN40, !(IN38)), IN43 | IN46)))) & (xor(xor(!(IN3), xor(xor(false & (IN3 & IN19), IN18), !(IN9 & IN41))), ((IN34 | IN41) & IN25) | (IN17 & (xor(xor(IN11, IN5), IN40)))))))), ((!(xor(xor(IN12, !(!(IN45 | IN38))), (xor(xor(IN8 & IN43, IN16 | IN4), IN18)) & ((xor(xor(IN2, IN13), IN22)) & IN38)))) & ((xor(xor(((xor(xor(IN34, IN30), IN44)) & (IN45 | IN14)) | IN49, (xor(xor(xor(xor(IN16, IN35), IN22), IN36 | IN17), xor(xor(IN26, IN21), IN2))) & (xor(xor(!(IN2), IN48), xor(xor(false, IN38), IN6)))), (!(IN21 & true)) & ((!(IN24)) & IN36))) & ((!(xor(xor(!(IN42), IN29 | IN47), IN31 & IN8))) & ((xor(xor(xor(xor(IN26, IN10), IN18), IN10 | IN2), IN38 & IN29)) & IN25)))) | IN7), ((xor(xor((!((!(!(IN41))) | IN27)) & ((((!(IN9)) & IN6) & (IN27 | IN6)) & (xor(xor(IN40, IN44), IN44))), IN47 & IN33), (IN42 & (((IN4 & IN43) & (IN21 & IN33)) | ((!(IN14)) | (xor(xor(IN12, IN35), IN7))))) | (xor(xor(!(IN20 & (IN21 & IN14)), xor(xor(!(IN47), !(IN35 | IN50)), xor(xor(IN12 & IN50, IN5 | IN12), IN33 | IN20))), !(xor(xor(!(IN8), IN6), !(IN23))))))) | (((IN44 | (!((IN1 | IN25) | (!(IN27))))) & ((((xor(xor(IN14, IN9), IN13)) | (xor(xor(IN36, IN37), IN40))) & (xor(xor(IN23, IN49 | IN3), IN37))) | (IN25 & ((IN1 | IN28) | (!(IN25)))))) & (!(((xor(xor(IN26 & false, xor(xor(IN13, IN29), IN15)), !(IN29))) & ((IN41 & IN7) & (IN36 & IN7))) & ((xor(xor(IN8 & IN8, IN29 & IN13), IN9 | IN26)) & (xor(xor(IN22 | IN40, IN37 | IN31), IN25 & IN44))))))) | ((!(xor(xor(!(IN43), (((!(IN44)) & (xor(xor(IN38, IN39), IN24))) & ((xor(xor(IN15, IN31), IN17)) | (xor(xor(IN44, IN39), IN24)))) | (!(IN23 | (xor(xor(IN46, IN33), IN26))))), IN49 & IN14))) | IN13)), xor(xor((((xor(xor(IN45 | (!(IN34)), !((IN22 & IN36) & (xor(xor(IN10, IN13), IN8)))), ((xor(xor(IN2, IN43), IN23)) | (xor(xor(IN41, IN20), IN3))) | (!(IN42)))) | (xor(xor(!(IN22 & (IN15 | IN36)), ((IN20 | IN29) | (IN13 & IN26)) & (!(IN2 | IN1))), !(xor(xor(IN45 | IN20, xor(xor(IN16, IN44), IN14)), IN16 | IN7))))) | ((((!(IN8)) & (IN24 & (!(IN17)))) & (((IN44 & IN23) | (IN30 | IN28)) & true)) & ((!((IN36 & IN33) | (xor(xor(IN1, IN44), IN38)))) | (IN32 & ((xor(xor(IN23, IN29), IN27)) | (!(IN49))))))) & (((xor(xor(xor(xor(!(IN9), IN1), (!(IN43)) & (xor(xor(IN14, IN27), IN30))), !(IN16)), (xor(xor(IN33 & IN28, IN19), IN24 & IN23)) & ((!(IN23)) & (IN42 & IN5)))) | ((!(xor(xor(xor(xor(IN17, IN45), IN41), !(IN5)), IN45 | IN7))) & (xor(xor(!(IN43 & IN44), !(IN1)), !(xor(xor(IN41, IN28), IN40)))))) | ((IN38 & ((!(xor(xor(IN21, IN30), IN38))) | ((IN8 & IN28) & (IN1 & true)))) | (IN39 & IN32))), (xor(xor((xor(xor(!(xor(xor(IN32 | IN37, xor(xor(IN13, IN49), IN42)), IN46)), IN13), !(!(IN50 | IN35)))) | (!(xor(xor((IN21 & IN6) & (xor(xor(IN36, IN3), IN26)), !(IN23)), (xor(xor(IN42, IN9), IN40)) & (!(IN28))))), ((!(xor(xor(IN11 & IN7, IN50), xor(xor(IN8, IN21), IN15)))) & ((xor(xor(xor(xor(IN1, IN47), IN39), xor(xor(IN32, IN41), IN50)), IN20 | IN22)) | (xor(xor(xor(xor(IN15, IN20), IN33), IN14 | IN22), IN44)))) | (((xor(xor(IN33 & IN32, IN31 & IN4), xor(xor(IN10, IN18), IN10))) & (xor(xor(!(IN46), IN38 & IN43), xor(xor(IN12, IN26), IN5)))) & IN45)), ((xor(xor((IN10 | IN16) & (xor(xor(IN43, IN14), IN48)), (xor(true, IN25)) & IN37), !(IN41 | IN29))) | (xor(xor(xor(xor(xor(xor(IN18, true), IN5), xor(xor(IN42, IN7), IN3)), !(IN8)), IN37 | (xor(xor(IN40, IN9), IN47))), !(!(IN20))))) | IN33)) | ((!(((!(IN17 & IN5)) | (IN19 | (IN21 | IN31))) & (xor(xor(IN5, !(IN19)), false)))) | IN30)), !(xor(xor((xor(xor(!(!(!(IN11))), !((IN10 & IN1) & (IN4 & IN26))), (xor(xor(IN23, !(IN47)), !(IN46))) & ((IN17 | IN33) & (IN17 | IN42)))) | (xor(xor((IN14 | IN14) & ((IN50 | IN39) | (xor(xor(IN5, IN13), IN31))), IN18), ((IN30 | IN1) | (IN17 | IN4)) | IN17)), !((xor(xor((!(IN39)) & IN28, (IN26 & IN24) | IN5), (!(IN5)) & (IN29 | IN47))) | IN17)), IN31 | ((((IN30 | IN37) | (IN49 & IN2)) & IN20) & ((!(!(IN46))) | true)))))))

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
    Out := ((((NOT Data[49]) XOR Data[20]) XOR (NOT (NOT ((NOT (NOT Data[20])) OR ((NOT (((Data[1] OR Data[21]) AND ((Data[13] XOR Data[2]) XOR Data[39])) AND (NOT (Data[34] OR Data[7])))) AND (NOT (NOT (((Data[4] AND Data[42]) XOR ((Data[12] XOR Data[33]) XOR Data[1])) XOR (NOT Data[24]))))))))) OR (((((((((((NOT (NOT (Data[2] AND Data[8]))) XOR (((Data[41] AND Data[1]) AND (Data[10] OR Data[13])) AND Data[47])) XOR (NOT (((Data[42] XOR Data[37]) XOR Data[36]) AND Data[20]))) AND TRUE) OR Data[48]) XOR Data[37]) XOR ((NOT ((NOT (((Data[26] XOR Data[18]) XOR Data[46]) OR (Data[49] AND Data[34]))) OR ((((Data[3] XOR Data[49]) XOR Data[16]) OR (NOT Data[33])) OR Data[21]))) AND ((((NOT (((FALSE OR Data[24]) XOR (NOT Data[1])) XOR ((Data[46] XOR Data[37]) XOR Data[21]))) AND (NOT Data[49])) XOR Data[13]) XOR (NOT ((((Data[41] OR Data[32]) OR Data[21]) XOR (((Data[18] XOR Data[1]) XOR Data[35]) OR ((Data[21] XOR Data[7]) XOR Data[35]))) XOR ((NOT Data[41]) AND (Data[27] AND Data[20]))))))) XOR ((((((Data[50] AND ((Data[19] XOR Data[26]) XOR Data[19])) AND ((NOT Data[47]) AND ((Data[48] XOR Data[2]) XOR Data[5]))) AND ((((Data[45] AND Data[7]) XOR (Data[16] OR Data[6])) XOR Data[37]) AND ((NOT Data[35]) OR (NOT Data[34])))) AND (Data[30] AND ((NOT (Data[5] OR Data[39])) AND Data[24]))) AND (((FALSE XOR ((Data[9] XOR ((Data[26] OR Data[23]) OR (Data[11] OR Data[43]))) XOR (NOT ((Data[43] XOR Data[8]) XOR Data[5])))) XOR ((Data[14] XOR (NOT (Data[40] AND Data[5]))) XOR ((Data[6] OR Data[9]) AND (NOT Data[19])))) OR (NOT (NOT ((Data[32] OR Data[42]) OR (NOT Data[2])))))) OR (NOT ((NOT (((((Data[8] AND Data[44]) XOR (NOT Data[27])) XOR (Data[30] AND Data[14])) XOR ((((TRUE XOR Data[38]) XOR Data[6]) XOR (Data[42] AND Data[45])) XOR (Data[38] OR Data[48]))) XOR ((Data[40] XOR (NOT Data[38])) XOR (Data[43] OR Data[46])))) AND (((NOT Data[3]) XOR (((FALSE AND (Data[3] AND Data[19])) XOR Data[18]) XOR (NOT (Data[9] AND Data[41])))) XOR (((Data[34] OR Data[41]) AND Data[25]) OR (Data[17] AND ((Data[11] XOR Data[5]) XOR Data[40])))))))) XOR (((NOT ((Data[12] XOR (NOT (NOT (Data[45] OR Data[38])))) XOR ((((Data[8] AND Data[43]) XOR (Data[16] OR Data[4])) XOR Data[18]) AND (((Data[2] XOR Data[13]) XOR Data[22]) AND Data[38])))) AND (((((((Data[34] XOR Data[30]) XOR Data[44]) AND (Data[45] OR Data[14])) OR Data[49]) XOR (((((Data[16] XOR Data[35]) XOR Data[22]) XOR (Data[36] OR Data[17])) XOR ((Data[26] XOR Data[21]) XOR Data[2])) AND (((NOT Data[2]) XOR Data[48]) XOR ((FALSE XOR Data[38]) XOR Data[6])))) XOR ((NOT (Data[21] AND TRUE)) AND ((NOT Data[24]) AND Data[36]))) AND ((NOT (((NOT Data[42]) XOR (Data[29] OR Data[47])) XOR (Data[31] AND Data[8]))) AND (((((Data[26] XOR Data[10]) XOR Data[18]) XOR (Data[10] OR Data[2])) XOR (Data[38] AND Data[29])) AND Data[25])))) OR Data[7])) XOR ((((((NOT ((NOT (NOT Data[41])) OR Data[27])) AND ((((NOT Data[9]) AND Data[6]) AND (Data[27] OR Data[6])) AND ((Data[40] XOR Data[44]) XOR Data[44]))) XOR (Data[47] AND Data[33])) XOR ((Data[42] AND (((Data[4] AND Data[43]) AND (Data[21] AND Data[33])) OR ((NOT Data[14]) OR ((Data[12] XOR Data[35]) XOR Data[7])))) OR (((NOT (Data[20] AND (Data[21] AND Data[14]))) XOR (((NOT Data[47]) XOR (NOT (Data[35] OR Data[50]))) XOR (((Data[12] AND Data[50]) XOR (Data[5] OR Data[12])) XOR (Data[33] OR Data[20])))) XOR (NOT (((NOT Data[8]) XOR Data[6]) XOR (NOT Data[23])))))) OR (((Data[44] OR (NOT ((Data[1] OR Data[25]) OR (NOT Data[27])))) AND (((((Data[14] XOR Data[9]) XOR Data[13]) OR ((Data[36] XOR Data[37]) XOR Data[40])) AND ((Data[23] XOR (Data[49] OR Data[3])) XOR Data[37])) OR (Data[25] AND ((Data[1] OR Data[28]) OR (NOT Data[25]))))) AND (NOT (((((Data[26] AND FALSE) XOR ((Data[13] XOR Data[29]) XOR Data[15])) XOR (NOT Data[29])) AND ((Data[41] AND Data[7]) AND (Data[36] AND Data[7]))) AND ((((Data[8] AND Data[8]) XOR (Data[29] AND Data[13])) XOR (Data[9] OR Data[26])) AND (((Data[22] OR Data[40]) XOR (Data[37] OR Data[31])) XOR (Data[25] AND Data[44]))))))) OR ((NOT (((NOT Data[43]) XOR ((((NOT Data[44]) AND ((Data[38] XOR Data[39]) XOR Data[24])) AND (((Data[15] XOR Data[31]) XOR Data[17]) OR ((Data[44] XOR Data[39]) XOR Data[24]))) OR (NOT (Data[23] OR ((Data[46] XOR Data[33]) XOR Data[26]))))) XOR (Data[49] AND Data[14]))) OR Data[13]))) XOR ((((((((Data[45] OR (NOT Data[34])) XOR (NOT ((Data[22] AND Data[36]) AND ((Data[10] XOR Data[13]) XOR Data[8])))) XOR ((((Data[2] XOR Data[43]) XOR Data[23]) OR ((Data[41] XOR Data[20]) XOR Data[3])) OR (NOT Data[42]))) OR (((NOT (Data[22] AND (Data[15] OR Data[36]))) XOR (((Data[20] OR Data[29]) OR (Data[13] AND Data[26])) AND (NOT (Data[2] OR Data[1])))) XOR (NOT (((Data[45] OR Data[20]) XOR ((Data[16] XOR Data[44]) XOR Data[14])) XOR (Data[16] OR Data[7]))))) OR ((((NOT Data[8]) AND (Data[24] AND (NOT Data[17]))) AND (((Data[44] AND Data[23]) OR (Data[30] OR Data[28])) AND TRUE)) AND ((NOT ((Data[36] AND Data[33]) OR ((Data[1] XOR Data[44]) XOR Data[38]))) OR (Data[32] AND (((Data[23] XOR Data[29]) XOR Data[27]) OR (NOT Data[49])))))) AND (((((((NOT Data[9]) XOR Data[1]) XOR ((NOT Data[43]) AND ((Data[14] XOR Data[27]) XOR Data[30]))) XOR (NOT Data[16])) XOR ((((Data[33] AND Data[28]) XOR Data[19]) XOR (Data[24] AND Data[23])) AND ((NOT Data[23]) AND (Data[42] AND Data[5])))) OR ((NOT ((((Data[17] XOR Data[45]) XOR Data[41]) XOR (NOT Data[5])) XOR (Data[45] OR Data[7]))) AND (((NOT (Data[43] AND Data[44])) XOR (NOT Data[1])) XOR (NOT ((Data[41] XOR Data[28]) XOR Data[40]))))) OR ((Data[38] AND ((NOT ((Data[21] XOR Data[30]) XOR Data[38])) OR ((Data[8] AND Data[28]) AND (Data[1] AND TRUE)))) OR (Data[39] AND Data[32])))) XOR (((((((NOT (((Data[32] OR Data[37]) XOR ((Data[13] XOR Data[49]) XOR Data[42])) XOR Data[46])) XOR Data[13]) XOR (NOT (NOT (Data[50] OR Data[35])))) OR (NOT ((((Data[21] AND Data[6]) AND ((Data[36] XOR Data[3]) XOR Data[26])) XOR (NOT Data[23])) XOR (((Data[42] XOR Data[9]) XOR Data[40]) AND (NOT Data[28]))))) XOR (((NOT (((Data[11] AND Data[7]) XOR Data[50]) XOR ((Data[8] XOR Data[21]) XOR Data[15]))) AND (((((Data[1] XOR Data[47]) XOR Data[39]) XOR ((Data[32] XOR Data[41]) XOR Data[50])) XOR (Data[20] OR Data[22])) OR ((((Data[15] XOR Data[20]) XOR Data[33]) XOR (Data[14] OR Data[22])) XOR Data[44]))) OR (((((Data[33] AND Data[32]) XOR (Data[31] AND Data[4])) XOR ((Data[10] XOR Data[18]) XOR Data[10])) AND (((NOT Data[46]) XOR (Data[38] AND Data[43])) XOR ((Data[12] XOR Data[26]) XOR Data[5]))) AND Data[45]))) XOR ((((((Data[10] OR Data[16]) AND ((Data[43] XOR Data[14]) XOR Data[48])) XOR ((TRUE XOR Data[25]) AND Data[37])) XOR (NOT (Data[41] OR Data[29]))) OR ((((((Data[18] XOR TRUE) XOR Data[5]) XOR ((Data[42] XOR Data[7]) XOR Data[3])) XOR (NOT Data[8])) XOR (Data[37] OR ((Data[40] XOR Data[9]) XOR Data[47]))) XOR (NOT (NOT Data[20])))) OR Data[33])) OR ((NOT (((NOT (Data[17] AND Data[5])) OR (Data[19] OR (Data[21] OR Data[31]))) AND ((Data[5] XOR (NOT Data[19])) XOR FALSE))) OR Data[30]))) XOR (NOT ((((((NOT (NOT (NOT Data[11]))) XOR (NOT ((Data[10] AND Data[1]) AND (Data[4] AND Data[26])))) XOR (((Data[23] XOR (NOT Data[47])) XOR (NOT Data[46])) AND ((Data[17] OR Data[33]) AND (Data[17] OR Data[42])))) OR ((((Data[14] OR Data[14]) AND ((Data[50] OR Data[39]) OR ((Data[5] XOR Data[13]) XOR Data[31]))) XOR Data[18]) XOR (((Data[30] OR Data[1]) OR (Data[17] OR Data[4])) OR Data[17]))) XOR (NOT (((((NOT Data[39]) AND Data[28]) XOR ((Data[26] AND Data[24]) OR Data[5])) XOR ((NOT Data[5]) AND (Data[29] OR Data[47]))) OR Data[17]))) XOR (Data[31] OR ((((Data[30] OR Data[37]) OR (Data[49] AND Data[2])) AND Data[20]) AND ((NOT (NOT Data[46])) OR TRUE))))))));
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
