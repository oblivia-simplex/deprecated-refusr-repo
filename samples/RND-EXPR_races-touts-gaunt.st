(*
This code implements a randomly grown symbolic expression:

(xor(xor((IN23 & IN50) | true, !(xor(xor(xor(xor(IN2 & ((xor(xor(IN36, IN7 | IN13), (!(IN18)) & (!(IN35)))) | (xor(xor((IN26 & IN39) & (xor(xor(IN30, IN3), IN8)), xor(xor(xor(xor(IN44, IN21), IN35), IN13 | IN29), xor(xor(IN6, IN46), IN32))), (!(IN27)) | (IN49 | IN27)))), !(IN28 | IN36)), IN31), (xor(xor(xor(xor(xor(xor(xor(xor(xor(xor(IN26, IN14), IN11), xor(xor(IN42, IN50), IN34)), IN29), !(IN42)), IN17), IN33), xor(xor(IN2 & (IN40 & IN9), IN26 & (IN23 | IN38)), IN10)), ((IN23 | (xor(xor(IN49, IN18), IN18))) | (xor(xor(xor(xor(IN10, IN38), IN17), IN31 & IN19), IN50 | IN39))) | (!(xor(xor(!(IN15), xor(xor(IN10, IN30), IN41)), IN17)))), IN41)) & (!(xor(xor(IN23, IN34 & (xor(xor(IN7 | IN19, IN31 & IN35), !(IN42)))), (!(IN36 & IN35)) & ((!(IN6)) & (IN9 | IN17)))))), IN6))), (!(((((!(IN6)) | ((IN19 & IN9) | (IN47 | IN24))) | (((!(IN43)) | (xor(xor(IN29, IN49), IN49))) | IN34)) | IN19) | (xor(xor(!(xor(xor(IN21, !(IN35)), !(!(IN7)))), IN31), (false & ((IN27 | IN44) | IN9)) | (((IN16 | IN28) | (IN33 | IN40)) | (!(IN34))))))) & ((!(IN38 | (IN30 | (xor(xor((xor(xor(IN31, IN2), IN4)) | (IN29 & IN7), !(xor(xor(IN7, false), IN43))), (xor(xor(IN23, IN28), IN27)) & IN20))))) | (((!((xor(xor(IN22, xor(xor(IN45, IN6), IN27)), IN21)) | (IN36 & (IN47 & IN2)))) & ((((IN12 | IN27) & (IN27 & IN26)) & (IN6 | (IN3 & IN10))) & (((IN44 | IN37) | (IN17 | IN19)) | (xor(xor(IN11 & IN29, IN2), !(IN40)))))) & (((((xor(xor(IN50, IN4), IN25)) | (!(IN12))) | (xor(xor(IN13 | IN7, IN10 & IN39), IN47))) | true) | (xor(xor(xor(xor(xor(xor(IN27 | IN11, IN42 & IN28), IN19 | IN24), false), (IN28 | IN32) | (!(IN49))), !(IN50)), (!(xor(xor(IN40, IN5), IN7))) & (!(IN40))))))))) & ((xor(xor(!((!(((!(xor(xor(IN34, IN33), IN17))) | ((IN20 & IN38) & (IN39 & IN6))) & (IN12 & (!(xor(xor(IN9, IN5), IN8)))))) & (xor(xor(xor(xor(IN11, !(xor(xor(IN50 | IN26, !(IN33)), IN14))), IN32), ((!(IN27 | IN20)) & (xor(xor(!(IN38), IN14 | IN18), IN30 & IN44))) & (!((IN45 & IN35) & (IN28 & IN49)))), xor(xor(IN8, (!(xor(xor(IN48, IN20), IN10))) | IN9), (!(!(IN28))) & (xor(xor(IN17 & IN28, !(IN35)), IN9 | IN18)))))), IN41 | (!(xor(xor((!((IN5 & IN1) | (xor(xor(IN50, IN32), IN38)))) & true, xor(xor(xor(xor(!(xor(xor(IN11, IN43), IN38)), xor(xor(xor(xor(IN49, IN30), IN35), IN34 & IN33), IN19 | IN27)), (IN9 & IN18) & (xor(xor(false, IN7), IN40))), (xor(xor(IN15 | IN48, IN45), !(IN47))) | ((!(IN44)) & (!(IN21)))), xor(xor((IN15 | IN44) & (!(IN2)), (IN10 | IN4) | (!(IN14))), false))), IN8)))), IN12)) & (xor(xor(xor(xor((xor(xor(IN28, !(xor(xor(IN36, IN8 & (IN6 | IN28)), xor(xor(xor(xor(IN44, IN8), IN44), IN16 | IN15), IN36 | IN22)))), IN40)) & (xor(xor(xor(xor(IN8, ((IN48 | IN38) | (xor(xor(IN40, IN46), IN32))) | ((xor(xor(IN15, IN16), IN46)) | IN25)), !(!(!(IN17)))), xor(xor(((IN1 | IN16) & (IN2 | IN15)) & (!(IN19)), ((IN42 | IN44) | IN35) & (!(IN48 | IN35))), IN3)), xor(xor(((IN9 & IN26) & (xor(xor(IN1, IN30), IN16))) & (IN9 | (xor(xor(IN4, IN44), IN15))), (!(xor(xor(IN47, IN5), IN41))) & (IN18 | (xor(xor(IN9, IN45), IN23)))), !(IN32)))), ((xor(xor(!(IN27), IN9), (xor(xor(IN16, IN41 | IN36), IN41)) | (xor(xor(IN48, IN22), IN25 & IN36)))) | (!(IN46 & ((xor(xor(IN16, IN48), IN39)) | (xor(xor(IN15, true), IN12)))))) | IN44), IN48 & ((!(!((IN27 & IN33) & (IN33 & IN39)))) | (IN19 & IN41))), !(IN40)), !((xor(xor(xor(xor(xor(xor(xor(xor(IN30 | IN38, xor(xor(IN39, IN19), IN33)), IN40 | IN13), IN44), (!(IN26)) & IN23), ((IN16 | IN48) & IN22) | (IN23 & (IN1 & IN3))), IN8), (!((IN43 & IN11) & IN33)) & IN16), (!((xor(xor(IN47, IN34), IN37)) | (!(IN19)))) | ((!(IN27)) & ((xor(xor(IN3, IN37), IN48)) | IN22)))) | (xor(xor(IN15, !(xor(xor((IN21 | IN6) | (!(IN29)), true), !(IN11 | IN16)))), !(IN21)))))))

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
    Out := (((((Data[23] AND Data[50]) OR TRUE) XOR (NOT (((((Data[2] AND (((Data[36] XOR (Data[7] OR Data[13])) XOR ((NOT Data[18]) AND (NOT Data[35]))) OR ((((Data[26] AND Data[39]) AND ((Data[30] XOR Data[3]) XOR Data[8])) XOR ((((Data[44] XOR Data[21]) XOR Data[35]) XOR (Data[13] OR Data[29])) XOR ((Data[6] XOR Data[46]) XOR Data[32]))) XOR ((NOT Data[27]) OR (Data[49] OR Data[27]))))) XOR (NOT (Data[28] OR Data[36]))) XOR Data[31]) XOR (((((((((((Data[26] XOR Data[14]) XOR Data[11]) XOR ((Data[42] XOR Data[50]) XOR Data[34])) XOR Data[29]) XOR (NOT Data[42])) XOR Data[17]) XOR Data[33]) XOR (((Data[2] AND (Data[40] AND Data[9])) XOR (Data[26] AND (Data[23] OR Data[38]))) XOR Data[10])) XOR (((Data[23] OR ((Data[49] XOR Data[18]) XOR Data[18])) OR ((((Data[10] XOR Data[38]) XOR Data[17]) XOR (Data[31] AND Data[19])) XOR (Data[50] OR Data[39]))) OR (NOT (((NOT Data[15]) XOR ((Data[10] XOR Data[30]) XOR Data[41])) XOR Data[17])))) XOR Data[41]) AND (NOT ((Data[23] XOR (Data[34] AND (((Data[7] OR Data[19]) XOR (Data[31] AND Data[35])) XOR (NOT Data[42])))) XOR ((NOT (Data[36] AND Data[35])) AND ((NOT Data[6]) AND (Data[9] OR Data[17]))))))) XOR Data[6]))) XOR ((NOT (((((NOT Data[6]) OR ((Data[19] AND Data[9]) OR (Data[47] OR Data[24]))) OR (((NOT Data[43]) OR ((Data[29] XOR Data[49]) XOR Data[49])) OR Data[34])) OR Data[19]) OR (((NOT ((Data[21] XOR (NOT Data[35])) XOR (NOT (NOT Data[7])))) XOR Data[31]) XOR ((FALSE AND ((Data[27] OR Data[44]) OR Data[9])) OR (((Data[16] OR Data[28]) OR (Data[33] OR Data[40])) OR (NOT Data[34])))))) AND ((NOT (Data[38] OR (Data[30] OR (((((Data[31] XOR Data[2]) XOR Data[4]) OR (Data[29] AND Data[7])) XOR (NOT ((Data[7] XOR FALSE) XOR Data[43]))) XOR (((Data[23] XOR Data[28]) XOR Data[27]) AND Data[20]))))) OR (((NOT (((Data[22] XOR ((Data[45] XOR Data[6]) XOR Data[27])) XOR Data[21]) OR (Data[36] AND (Data[47] AND Data[2])))) AND ((((Data[12] OR Data[27]) AND (Data[27] AND Data[26])) AND (Data[6] OR (Data[3] AND Data[10]))) AND (((Data[44] OR Data[37]) OR (Data[17] OR Data[19])) OR (((Data[11] AND Data[29]) XOR Data[2]) XOR (NOT Data[40]))))) AND ((((((Data[50] XOR Data[4]) XOR Data[25]) OR (NOT Data[12])) OR (((Data[13] OR Data[7]) XOR (Data[10] AND Data[39])) XOR Data[47])) OR TRUE) OR (((((((Data[27] OR Data[11]) XOR (Data[42] AND Data[28])) XOR (Data[19] OR Data[24])) XOR FALSE) XOR ((Data[28] OR Data[32]) OR (NOT Data[49]))) XOR (NOT Data[50])) XOR ((NOT ((Data[40] XOR Data[5]) XOR Data[7])) AND (NOT Data[40])))))))) AND ((((NOT ((NOT (((NOT ((Data[34] XOR Data[33]) XOR Data[17])) OR ((Data[20] AND Data[38]) AND (Data[39] AND Data[6]))) AND (Data[12] AND (NOT ((Data[9] XOR Data[5]) XOR Data[8]))))) AND ((((Data[11] XOR (NOT (((Data[50] OR Data[26]) XOR (NOT Data[33])) XOR Data[14]))) XOR Data[32]) XOR (((NOT (Data[27] OR Data[20])) AND (((NOT Data[38]) XOR (Data[14] OR Data[18])) XOR (Data[30] AND Data[44]))) AND (NOT ((Data[45] AND Data[35]) AND (Data[28] AND Data[49]))))) XOR ((Data[8] XOR ((NOT ((Data[48] XOR Data[20]) XOR Data[10])) OR Data[9])) XOR ((NOT (NOT Data[28])) AND (((Data[17] AND Data[28]) XOR (NOT Data[35])) XOR (Data[9] OR Data[18]))))))) XOR (Data[41] OR (NOT ((((NOT ((Data[5] AND Data[1]) OR ((Data[50] XOR Data[32]) XOR Data[38]))) AND TRUE) XOR (((((NOT ((Data[11] XOR Data[43]) XOR Data[38])) XOR ((((Data[49] XOR Data[30]) XOR Data[35]) XOR (Data[34] AND Data[33])) XOR (Data[19] OR Data[27]))) XOR ((Data[9] AND Data[18]) AND ((FALSE XOR Data[7]) XOR Data[40]))) XOR ((((Data[15] OR Data[48]) XOR Data[45]) XOR (NOT Data[47])) OR ((NOT Data[44]) AND (NOT Data[21])))) XOR ((((Data[15] OR Data[44]) AND (NOT Data[2])) XOR ((Data[10] OR Data[4]) OR (NOT Data[14]))) XOR FALSE))) XOR Data[8])))) XOR Data[12]) AND (((((((Data[28] XOR (NOT ((Data[36] XOR (Data[8] AND (Data[6] OR Data[28]))) XOR ((((Data[44] XOR Data[8]) XOR Data[44]) XOR (Data[16] OR Data[15])) XOR (Data[36] OR Data[22]))))) XOR Data[40]) AND ((((Data[8] XOR (((Data[48] OR Data[38]) OR ((Data[40] XOR Data[46]) XOR Data[32])) OR (((Data[15] XOR Data[16]) XOR Data[46]) OR Data[25]))) XOR (NOT (NOT (NOT Data[17])))) XOR (((((Data[1] OR Data[16]) AND (Data[2] OR Data[15])) AND (NOT Data[19])) XOR (((Data[42] OR Data[44]) OR Data[35]) AND (NOT (Data[48] OR Data[35])))) XOR Data[3])) XOR (((((Data[9] AND Data[26]) AND ((Data[1] XOR Data[30]) XOR Data[16])) AND (Data[9] OR ((Data[4] XOR Data[44]) XOR Data[15]))) XOR ((NOT ((Data[47] XOR Data[5]) XOR Data[41])) AND (Data[18] OR ((Data[9] XOR Data[45]) XOR Data[23])))) XOR (NOT Data[32])))) XOR (((((NOT Data[27]) XOR Data[9]) XOR (((Data[16] XOR (Data[41] OR Data[36])) XOR Data[41]) OR ((Data[48] XOR Data[22]) XOR (Data[25] AND Data[36])))) OR (NOT (Data[46] AND (((Data[16] XOR Data[48]) XOR Data[39]) OR ((Data[15] XOR TRUE) XOR Data[12]))))) OR Data[44])) XOR (Data[48] AND ((NOT (NOT ((Data[27] AND Data[33]) AND (Data[33] AND Data[39])))) OR (Data[19] AND Data[41])))) XOR (NOT Data[40])) XOR (NOT ((((((((((Data[30] OR Data[38]) XOR ((Data[39] XOR Data[19]) XOR Data[33])) XOR (Data[40] OR Data[13])) XOR Data[44]) XOR ((NOT Data[26]) AND Data[23])) XOR (((Data[16] OR Data[48]) AND Data[22]) OR (Data[23] AND (Data[1] AND Data[3])))) XOR Data[8]) XOR ((NOT ((Data[43] AND Data[11]) AND Data[33])) AND Data[16])) XOR ((NOT (((Data[47] XOR Data[34]) XOR Data[37]) OR (NOT Data[19]))) OR ((NOT Data[27]) AND (((Data[3] XOR Data[37]) XOR Data[48]) OR Data[22])))) OR ((Data[15] XOR (NOT ((((Data[21] OR Data[6]) OR (NOT Data[29])) XOR TRUE) XOR (NOT (Data[11] OR Data[16]))))) XOR (NOT Data[21])))))));
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
