(*
This code implements a randomly grown symbolic expression:

((((!(!(!(xor(xor(IN40 | (xor(xor(IN19, IN3), IN23)), xor(xor(IN26 & IN29, !(IN6)), IN3 & IN48)), xor(xor(IN48 | IN38, !(IN41)), IN9 & IN1)))))) & true) | (xor(xor(!(IN21 & (IN50 | (IN33 & (!(!(IN10)))))), !(IN33)), IN31))) | (!(xor(xor((xor(xor(!(IN26 & (!(!(IN15)))), xor(xor((IN23 | (xor(xor(IN10, IN17), IN38))) | ((IN9 | IN7) | (IN42 & IN18)), (!(IN3)) | (!(IN26 & IN36))), xor(xor(!(IN23), (xor(xor(IN46, IN32), IN13)) | (!(IN45))), IN31))), !(xor(xor(!(xor(xor(IN29, IN29), IN17)), (IN32 | IN36) | (xor(xor(IN34, IN37), true))), xor(xor(IN48 & IN9, xor(xor(IN43, IN49), IN14)), IN2))))) | (!(((xor(xor(!(IN32), xor(xor(IN27, IN24), IN34)), IN7)) & true) | IN46)), !(IN23)), xor(xor(xor(xor((xor(xor((xor(xor(IN42, IN37), IN30)) | IN36, !(IN36)), IN31)) | (!(IN26 | (IN2 | IN28))), (!(IN14)) & (xor(xor((IN45 & IN11) | (xor(xor(IN8, IN48), IN36)), (!(IN36)) & (IN20 & IN4)), !(IN9 & IN11)))), (IN50 | (!(xor(xor(IN12, IN4), IN6)))) | (IN22 & ((IN46 & IN5) & (!(IN41))))), xor(xor(IN41, !(((IN26 & IN16) | (!(IN32))) | ((xor(xor(IN22, IN34), IN14)) & (xor(xor(IN18, IN31), IN36))))), xor(xor((IN8 | (IN9 & IN25)) & (xor(xor(!(IN41), !(IN45)), IN30 & IN43)), (!(IN18 | IN43)) | ((IN39 | IN36) & IN3)), xor(xor(IN44, (xor(xor(IN5, IN21), IN30)) | (xor(xor(IN43, IN17), IN49))), IN30)))), (!(xor(xor(IN44 & (!(IN21)), IN27), (xor(xor(IN34, IN5), IN26)) | (IN38 & IN23)))) | ((!((IN15 | IN19) | (!(IN41)))) & IN20)))))) & (((!((xor(xor(((IN40 & (!(IN13))) | ((!(IN22)) | IN28)) | (xor(xor((IN20 | IN38) & (!(IN15)), !(!(IN14))), true)), (xor(xor(xor(xor(IN5, IN3), IN26 | IN3), xor(xor(true | IN14, !(IN17)), xor(xor(IN17, IN36), IN47))), (xor(xor(IN3, IN48), IN41)) | (IN2 & IN4))) & IN40), ((!(IN6 & IN11)) & (IN26 & (IN27 | IN31))) | (IN49 & (!(xor(xor(IN27, IN28), IN2)))))) | ((xor(xor(!((IN41 | IN16) | (IN35 & IN24)), IN38), xor(xor(!(IN15 & IN10), (IN7 | IN17) | (IN38 & IN35)), xor(xor(IN41 & IN32, IN3 | IN1), !(IN20))))) & (xor(xor((xor(xor(IN6, IN30 | IN35), xor(xor(IN20, IN9), IN29))) & ((IN14 & IN14) & (IN34 | IN49)), IN15), xor(xor(true, !(IN41 & IN2)), (!(IN13)) | (IN24 | true))))))) | IN32) & (xor(xor(IN26, ((((xor(xor(xor(xor(xor(xor(IN9, IN24), IN27), IN45 | IN12), IN10 | IN19), IN7 | (IN12 & IN13)), (!(IN20)) & (!(IN2)))) | (xor(xor((IN20 | IN22) & (IN42 | false), !(IN43 & IN7)), xor(xor(!(IN49), xor(xor(IN31, IN26), IN38)), xor(xor(IN23, IN1), IN3))))) & (((!(IN4 & IN31)) | IN41) & (((xor(xor(IN34, IN47), IN25)) & (xor(xor(IN13, IN11), IN1))) & IN26))) & (!(xor(xor(xor(xor(IN50 & (IN10 | IN31), xor(xor(IN33, xor(xor(IN36, IN43), IN43)), xor(xor(IN21, IN20), IN23))), IN6), ((!(IN48)) | (IN35 & IN49)) & (xor(xor(xor(xor(IN1, IN38), IN48), !(IN17)), IN8 | IN26))), xor(xor((IN23 | IN47) | (xor(xor(IN19, IN38), IN1)), !(IN48)), xor(xor(false, xor(xor(IN31, IN1), IN6)), !(IN34))))))) & (xor(xor(IN9, xor(xor((!((IN29 & IN46) & (!(IN5)))) | IN47, (!((IN45 & IN35) & (!(IN14)))) & IN1), IN14 | (!(IN38)))), xor(xor((!(!(!(IN40)))) & ((xor(xor(!(IN18), IN7), IN17 & IN6)) | (xor(xor(xor(xor(IN12, IN34), IN21), true | IN23), !(IN1)))), !(IN43)), (((IN6 & IN32) | (!(IN11))) & (!(IN24))) & (!(xor(xor(IN36 | IN16, !(IN7)), !(IN30)))))))), (xor(xor(xor(xor((xor(xor(!(IN40 & IN14), xor(xor(!(IN45), xor(xor(IN10, IN14), IN43)), !(IN16))), xor(xor(IN10 | IN17, xor(xor(true, IN13), IN11)), IN4 & IN1))) | IN23, IN43), xor(xor(IN7, !(xor(xor(!(IN30), IN16 | IN10), IN26 | IN18))), !(!(IN42 | IN8)))), ((!(IN46)) & (xor(xor(IN45, xor(xor(!(IN32), xor(xor(IN41, IN14), IN50)), IN22 & IN33)), IN23 & IN27))) & IN4), IN2)) | (!((xor(xor(xor(xor(IN7, xor(xor(IN40, xor(xor(IN42, IN46), IN3)), !(IN41))), (xor(xor(IN5, IN22), IN18)) & (IN47 & IN38)), IN47), IN50)) | ((xor(xor((IN13 & IN49) | (IN6 & IN16), (IN20 & IN30) | (xor(xor(IN22, IN10), IN39))), IN40)) | false))))))

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
    Out := (((((NOT (NOT (NOT (((Data[40] OR ((Data[19] XOR Data[3]) XOR Data[23])) XOR (((Data[26] AND Data[29]) XOR (NOT Data[6])) XOR (Data[3] AND Data[48]))) XOR (((Data[48] OR Data[38]) XOR (NOT Data[41])) XOR (Data[9] AND Data[1])))))) AND TRUE) OR (((NOT (Data[21] AND (Data[50] OR (Data[33] AND (NOT (NOT Data[10])))))) XOR (NOT Data[33])) XOR Data[31])) OR (NOT ((((((NOT (Data[26] AND (NOT (NOT Data[15])))) XOR ((((Data[23] OR ((Data[10] XOR Data[17]) XOR Data[38])) OR ((Data[9] OR Data[7]) OR (Data[42] AND Data[18]))) XOR ((NOT Data[3]) OR (NOT (Data[26] AND Data[36])))) XOR (((NOT Data[23]) XOR (((Data[46] XOR Data[32]) XOR Data[13]) OR (NOT Data[45]))) XOR Data[31]))) XOR (NOT (((NOT ((Data[29] XOR Data[29]) XOR Data[17])) XOR ((Data[32] OR Data[36]) OR ((Data[34] XOR Data[37]) XOR TRUE))) XOR (((Data[48] AND Data[9]) XOR ((Data[43] XOR Data[49]) XOR Data[14])) XOR Data[2])))) OR (NOT (((((NOT Data[32]) XOR ((Data[27] XOR Data[24]) XOR Data[34])) XOR Data[7]) AND TRUE) OR Data[46]))) XOR (NOT Data[23])) XOR ((((((((((Data[42] XOR Data[37]) XOR Data[30]) OR Data[36]) XOR (NOT Data[36])) XOR Data[31]) OR (NOT (Data[26] OR (Data[2] OR Data[28])))) XOR ((NOT Data[14]) AND ((((Data[45] AND Data[11]) OR ((Data[8] XOR Data[48]) XOR Data[36])) XOR ((NOT Data[36]) AND (Data[20] AND Data[4]))) XOR (NOT (Data[9] AND Data[11]))))) XOR ((Data[50] OR (NOT ((Data[12] XOR Data[4]) XOR Data[6]))) OR (Data[22] AND ((Data[46] AND Data[5]) AND (NOT Data[41]))))) XOR ((Data[41] XOR (NOT (((Data[26] AND Data[16]) OR (NOT Data[32])) OR (((Data[22] XOR Data[34]) XOR Data[14]) AND ((Data[18] XOR Data[31]) XOR Data[36]))))) XOR ((((Data[8] OR (Data[9] AND Data[25])) AND (((NOT Data[41]) XOR (NOT Data[45])) XOR (Data[30] AND Data[43]))) XOR ((NOT (Data[18] OR Data[43])) OR ((Data[39] OR Data[36]) AND Data[3]))) XOR ((Data[44] XOR (((Data[5] XOR Data[21]) XOR Data[30]) OR ((Data[43] XOR Data[17]) XOR Data[49]))) XOR Data[30])))) XOR ((NOT (((Data[44] AND (NOT Data[21])) XOR Data[27]) XOR (((Data[34] XOR Data[5]) XOR Data[26]) OR (Data[38] AND Data[23])))) OR ((NOT ((Data[15] OR Data[19]) OR (NOT Data[41]))) AND Data[20])))))) AND (((NOT ((((((Data[40] AND (NOT Data[13])) OR ((NOT Data[22]) OR Data[28])) OR ((((Data[20] OR Data[38]) AND (NOT Data[15])) XOR (NOT (NOT Data[14]))) XOR TRUE)) XOR (((((Data[5] XOR Data[3]) XOR (Data[26] OR Data[3])) XOR (((TRUE OR Data[14]) XOR (NOT Data[17])) XOR ((Data[17] XOR Data[36]) XOR Data[47]))) XOR (((Data[3] XOR Data[48]) XOR Data[41]) OR (Data[2] AND Data[4]))) AND Data[40])) XOR (((NOT (Data[6] AND Data[11])) AND (Data[26] AND (Data[27] OR Data[31]))) OR (Data[49] AND (NOT ((Data[27] XOR Data[28]) XOR Data[2]))))) OR ((((NOT ((Data[41] OR Data[16]) OR (Data[35] AND Data[24]))) XOR Data[38]) XOR (((NOT (Data[15] AND Data[10])) XOR ((Data[7] OR Data[17]) OR (Data[38] AND Data[35]))) XOR (((Data[41] AND Data[32]) XOR (Data[3] OR Data[1])) XOR (NOT Data[20])))) AND (((((Data[6] XOR (Data[30] OR Data[35])) XOR ((Data[20] XOR Data[9]) XOR Data[29])) AND ((Data[14] AND Data[14]) AND (Data[34] OR Data[49]))) XOR Data[15]) XOR ((TRUE XOR (NOT (Data[41] AND Data[2]))) XOR ((NOT Data[13]) OR (Data[24] OR TRUE))))))) OR Data[32]) AND ((Data[26] XOR ((((((((((Data[9] XOR Data[24]) XOR Data[27]) XOR (Data[45] OR Data[12])) XOR (Data[10] OR Data[19])) XOR (Data[7] OR (Data[12] AND Data[13]))) XOR ((NOT Data[20]) AND (NOT Data[2]))) OR ((((Data[20] OR Data[22]) AND (Data[42] OR FALSE)) XOR (NOT (Data[43] AND Data[7]))) XOR (((NOT Data[49]) XOR ((Data[31] XOR Data[26]) XOR Data[38])) XOR ((Data[23] XOR Data[1]) XOR Data[3])))) AND (((NOT (Data[4] AND Data[31])) OR Data[41]) AND ((((Data[34] XOR Data[47]) XOR Data[25]) AND ((Data[13] XOR Data[11]) XOR Data[1])) AND Data[26]))) AND (NOT (((((Data[50] AND (Data[10] OR Data[31])) XOR ((Data[33] XOR ((Data[36] XOR Data[43]) XOR Data[43])) XOR ((Data[21] XOR Data[20]) XOR Data[23]))) XOR Data[6]) XOR (((NOT Data[48]) OR (Data[35] AND Data[49])) AND ((((Data[1] XOR Data[38]) XOR Data[48]) XOR (NOT Data[17])) XOR (Data[8] OR Data[26])))) XOR ((((Data[23] OR Data[47]) OR ((Data[19] XOR Data[38]) XOR Data[1])) XOR (NOT Data[48])) XOR ((FALSE XOR ((Data[31] XOR Data[1]) XOR Data[6])) XOR (NOT Data[34])))))) AND ((Data[9] XOR ((((NOT ((Data[29] AND Data[46]) AND (NOT Data[5]))) OR Data[47]) XOR ((NOT ((Data[45] AND Data[35]) AND (NOT Data[14]))) AND Data[1])) XOR (Data[14] OR (NOT Data[38])))) XOR ((((NOT (NOT (NOT Data[40]))) AND ((((NOT Data[18]) XOR Data[7]) XOR (Data[17] AND Data[6])) OR ((((Data[12] XOR Data[34]) XOR Data[21]) XOR (TRUE OR Data[23])) XOR (NOT Data[1])))) XOR (NOT Data[43])) XOR ((((Data[6] AND Data[32]) OR (NOT Data[11])) AND (NOT Data[24])) AND (NOT (((Data[36] OR Data[16]) XOR (NOT Data[7])) XOR (NOT Data[30])))))))) XOR (((((((((NOT (Data[40] AND Data[14])) XOR (((NOT Data[45]) XOR ((Data[10] XOR Data[14]) XOR Data[43])) XOR (NOT Data[16]))) XOR (((Data[10] OR Data[17]) XOR ((TRUE XOR Data[13]) XOR Data[11])) XOR (Data[4] AND Data[1]))) OR Data[23]) XOR Data[43]) XOR ((Data[7] XOR (NOT (((NOT Data[30]) XOR (Data[16] OR Data[10])) XOR (Data[26] OR Data[18])))) XOR (NOT (NOT (Data[42] OR Data[8]))))) XOR (((NOT Data[46]) AND ((Data[45] XOR (((NOT Data[32]) XOR ((Data[41] XOR Data[14]) XOR Data[50])) XOR (Data[22] AND Data[33]))) XOR (Data[23] AND Data[27]))) AND Data[4])) XOR Data[2]) OR (NOT (((((Data[7] XOR ((Data[40] XOR ((Data[42] XOR Data[46]) XOR Data[3])) XOR (NOT Data[41]))) XOR (((Data[5] XOR Data[22]) XOR Data[18]) AND (Data[47] AND Data[38]))) XOR Data[47]) XOR Data[50]) OR (((((Data[13] AND Data[49]) OR (Data[6] AND Data[16])) XOR ((Data[20] AND Data[30]) OR ((Data[22] XOR Data[10]) XOR Data[39]))) XOR Data[40]) OR FALSE)))))));
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
