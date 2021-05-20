(*
This code implements a randomly grown symbolic expression:

xor(xor(true, xor(xor(IN39, (IN10 | (((xor(xor((!(IN45 | IN10)) | (xor(xor(IN33, IN25), xor(xor(IN10, IN32), IN30))), true & IN23), ((IN2 | IN2) & (xor(xor(IN34, IN12), IN29))) | ((IN49 | IN18) & (!(IN31))))) & ((((IN11 | IN46) & (IN6 & IN34)) | (!(IN49 | IN9))) | IN24)) | IN19)) | (xor(xor((xor(xor(!(!(!(!(IN24)))), IN24), (IN47 | (!(IN23))) | ((xor(xor(IN22, IN43 & IN35), !(IN43))) & IN24))) | ((xor(xor(IN7 | (!(IN47 & IN26)), !(!(IN40))), !((xor(xor(IN29, IN40), IN14)) & (xor(xor(IN41, IN9), IN5))))) | ((xor(xor(xor(xor(IN29 | IN41, IN41 | IN39), xor(xor(IN34, IN15), IN12)), xor(xor(xor(xor(IN14, IN40), IN45), !(IN43)), IN47 | IN20)), (xor(xor(IN32, IN12), IN48)) | (xor(xor(IN7, IN6), IN12)))) | ((xor(xor(false | IN50, IN3 | IN49), xor(xor(IN48, IN10), IN47))) | ((xor(xor(IN1, IN39), IN16)) | (!(IN23)))))), xor(xor(!((((xor(xor(IN1, IN3), IN11)) | (IN48 & IN36)) | ((IN44 | IN11) & (IN23 & IN15))) | ((!(IN6 & false)) | (!(IN22 & IN2)))), IN8), ((((!(IN41)) & (IN48 & IN48)) | (xor(xor(xor(xor(IN10, IN25), IN34), xor(xor(IN36, true), IN11)), IN40 & IN26))) & (!(IN46))) | (xor(xor(!(!(IN5)), IN2), xor(xor(xor(xor(xor(xor(IN7, IN26), IN48), IN40), IN50), IN7), (IN14 | IN3) & (!(IN25))))))), IN6))), IN17)), (!(IN46 | IN27)) | ((xor(xor(xor(xor((xor(xor(!((IN17 & IN1) & (IN39 | IN43)), IN36), IN6)) & (!(IN10 | (IN12 | (xor(xor(IN14, IN1), IN33))))), xor(xor(xor(xor(!((IN45 & IN11) & IN26), IN46), xor(xor(IN4 & (IN25 & IN13), (!(IN13)) & (xor(xor(IN3, IN35), IN38))), xor(xor(IN8, xor(xor(IN28, IN15), IN7)), !(IN39)))), xor(xor(IN29 & ((!(IN29)) | (IN42 | IN32)), !(IN36)), (IN43 | (IN27 | IN37)) | ((IN4 | IN3) & (xor(xor(IN30, IN14), IN13))))), xor(xor(xor(xor(IN17, IN48), IN45), IN2), ((IN23 & IN16) & false) | (xor(xor(IN14, IN25 | IN47), xor(xor(IN50, IN26), IN42)))))), !(!(xor(xor((IN16 & false) | (IN22 & IN30), (IN12 & true) & (!(IN32))), (IN5 | IN37) | IN45)))), xor(xor(IN36, (xor(xor(!(!(!(IN7))), !(IN33)), !(xor(xor(IN24 & IN22, IN27 | IN13), true & IN24)))) | ((((!(IN50)) & IN15) & (xor(xor(xor(xor(IN37, IN21), IN23), !(IN49)), !(IN31)))) | (xor(xor(IN7 & (!(IN31)), IN28), (IN47 | IN33) & IN3)))), ((!(xor(xor(xor(xor(IN23, IN29), IN9), !(IN29)), IN44))) | (((!(IN8)) | IN50) & ((IN7 | IN10) | (IN30 & IN33)))) | (xor(xor(((IN44 | IN39) | (IN50 & IN42)) & (xor(xor(IN10 & IN47, IN19), IN34 | IN26)), xor(xor(IN19, !(IN15 & IN12)), !(!(IN7)))), !((xor(xor(IN41, IN13), IN29)) & IN2))))), IN44)) | (xor(xor(IN20 & (IN42 | ((!((IN24 | IN45) | (IN37 | IN7))) & ((xor(xor(IN2 | false, xor(xor(IN49, IN27), IN44)), IN31)) | IN16))), IN39 | (!(xor(xor(IN10, ((IN50 | IN21) | (IN23 | IN29)) & ((IN32 & IN12) & (IN43 & IN21))), xor(xor(xor(xor(IN50 | false, xor(xor(IN45, IN30), IN29)), IN27 & IN7), !(IN42 | IN35)), (IN18 & IN8) | (IN11 | IN5)))))), xor(xor(((!(!(!(IN24)))) | IN42) | IN35, xor(xor((!((xor(xor(IN11, IN48), true)) | (IN3 | IN48))) & ((IN19 & (IN49 | IN38)) | (xor(xor(!(IN35), !(IN20)), IN2 | IN33))), IN14), ((!(!(IN36))) | (true & (xor(xor(IN36, IN34), IN35)))) & (((IN28 & IN27) & (IN6 & IN47)) | (IN30 | (IN43 & IN16))))), xor(xor((IN20 & ((IN10 | IN10) & IN47)) | IN16, ((xor(xor(IN8 | IN1, IN43), !(IN7))) & ((xor(xor(IN8, IN28), IN43)) | IN9)) & IN14), ((!(!(IN47))) | ((!(IN50)) & (IN27 & IN46))) & (xor(xor((IN14 & IN40) | (IN17 | IN2), xor(xor(IN20 | IN31, IN28 & IN19), IN50 & IN40)), (IN4 | IN35) & (xor(xor(IN40, IN16), IN32))))))))))

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
    Out := ((TRUE XOR ((Data[39] XOR ((Data[10] OR ((((((NOT (Data[45] OR Data[10])) OR ((Data[33] XOR Data[25]) XOR ((Data[10] XOR Data[32]) XOR Data[30]))) XOR (TRUE AND Data[23])) XOR (((Data[2] OR Data[2]) AND ((Data[34] XOR Data[12]) XOR Data[29])) OR ((Data[49] OR Data[18]) AND (NOT Data[31])))) AND ((((Data[11] OR Data[46]) AND (Data[6] AND Data[34])) OR (NOT (Data[49] OR Data[9]))) OR Data[24])) OR Data[19])) OR ((((((NOT (NOT (NOT (NOT Data[24])))) XOR Data[24]) XOR ((Data[47] OR (NOT Data[23])) OR (((Data[22] XOR (Data[43] AND Data[35])) XOR (NOT Data[43])) AND Data[24]))) OR ((((Data[7] OR (NOT (Data[47] AND Data[26]))) XOR (NOT (NOT Data[40]))) XOR (NOT (((Data[29] XOR Data[40]) XOR Data[14]) AND ((Data[41] XOR Data[9]) XOR Data[5])))) OR ((((((Data[29] OR Data[41]) XOR (Data[41] OR Data[39])) XOR ((Data[34] XOR Data[15]) XOR Data[12])) XOR ((((Data[14] XOR Data[40]) XOR Data[45]) XOR (NOT Data[43])) XOR (Data[47] OR Data[20]))) XOR (((Data[32] XOR Data[12]) XOR Data[48]) OR ((Data[7] XOR Data[6]) XOR Data[12]))) OR ((((FALSE OR Data[50]) XOR (Data[3] OR Data[49])) XOR ((Data[48] XOR Data[10]) XOR Data[47])) OR (((Data[1] XOR Data[39]) XOR Data[16]) OR (NOT Data[23])))))) XOR (((NOT (((((Data[1] XOR Data[3]) XOR Data[11]) OR (Data[48] AND Data[36])) OR ((Data[44] OR Data[11]) AND (Data[23] AND Data[15]))) OR ((NOT (Data[6] AND FALSE)) OR (NOT (Data[22] AND Data[2]))))) XOR Data[8]) XOR (((((NOT Data[41]) AND (Data[48] AND Data[48])) OR ((((Data[10] XOR Data[25]) XOR Data[34]) XOR ((Data[36] XOR TRUE) XOR Data[11])) XOR (Data[40] AND Data[26]))) AND (NOT Data[46])) OR (((NOT (NOT Data[5])) XOR Data[2]) XOR ((((((Data[7] XOR Data[26]) XOR Data[48]) XOR Data[40]) XOR Data[50]) XOR Data[7]) XOR ((Data[14] OR Data[3]) AND (NOT Data[25]))))))) XOR Data[6]))) XOR Data[17])) XOR ((NOT (Data[46] OR Data[27])) OR (((((((((NOT ((Data[17] AND Data[1]) AND (Data[39] OR Data[43]))) XOR Data[36]) XOR Data[6]) AND (NOT (Data[10] OR (Data[12] OR ((Data[14] XOR Data[1]) XOR Data[33]))))) XOR (((((NOT ((Data[45] AND Data[11]) AND Data[26])) XOR Data[46]) XOR (((Data[4] AND (Data[25] AND Data[13])) XOR ((NOT Data[13]) AND ((Data[3] XOR Data[35]) XOR Data[38]))) XOR ((Data[8] XOR ((Data[28] XOR Data[15]) XOR Data[7])) XOR (NOT Data[39])))) XOR (((Data[29] AND ((NOT Data[29]) OR (Data[42] OR Data[32]))) XOR (NOT Data[36])) XOR ((Data[43] OR (Data[27] OR Data[37])) OR ((Data[4] OR Data[3]) AND ((Data[30] XOR Data[14]) XOR Data[13]))))) XOR ((((Data[17] XOR Data[48]) XOR Data[45]) XOR Data[2]) XOR (((Data[23] AND Data[16]) AND FALSE) OR ((Data[14] XOR (Data[25] OR Data[47])) XOR ((Data[50] XOR Data[26]) XOR Data[42])))))) XOR (NOT (NOT ((((Data[16] AND FALSE) OR (Data[22] AND Data[30])) XOR ((Data[12] AND TRUE) AND (NOT Data[32]))) XOR ((Data[5] OR Data[37]) OR Data[45]))))) XOR ((Data[36] XOR ((((NOT (NOT (NOT Data[7]))) XOR (NOT Data[33])) XOR (NOT (((Data[24] AND Data[22]) XOR (Data[27] OR Data[13])) XOR (TRUE AND Data[24])))) OR ((((NOT Data[50]) AND Data[15]) AND ((((Data[37] XOR Data[21]) XOR Data[23]) XOR (NOT Data[49])) XOR (NOT Data[31]))) OR (((Data[7] AND (NOT Data[31])) XOR Data[28]) XOR ((Data[47] OR Data[33]) AND Data[3]))))) XOR (((NOT ((((Data[23] XOR Data[29]) XOR Data[9]) XOR (NOT Data[29])) XOR Data[44])) OR (((NOT Data[8]) OR Data[50]) AND ((Data[7] OR Data[10]) OR (Data[30] AND Data[33])))) OR (((((Data[44] OR Data[39]) OR (Data[50] AND Data[42])) AND (((Data[10] AND Data[47]) XOR Data[19]) XOR (Data[34] OR Data[26]))) XOR ((Data[19] XOR (NOT (Data[15] AND Data[12]))) XOR (NOT (NOT Data[7])))) XOR (NOT (((Data[41] XOR Data[13]) XOR Data[29]) AND Data[2])))))) XOR Data[44]) OR (((Data[20] AND (Data[42] OR ((NOT ((Data[24] OR Data[45]) OR (Data[37] OR Data[7]))) AND ((((Data[2] OR FALSE) XOR ((Data[49] XOR Data[27]) XOR Data[44])) XOR Data[31]) OR Data[16])))) XOR (Data[39] OR (NOT ((Data[10] XOR (((Data[50] OR Data[21]) OR (Data[23] OR Data[29])) AND ((Data[32] AND Data[12]) AND (Data[43] AND Data[21])))) XOR (((((Data[50] OR FALSE) XOR ((Data[45] XOR Data[30]) XOR Data[29])) XOR (Data[27] AND Data[7])) XOR (NOT (Data[42] OR Data[35]))) XOR ((Data[18] AND Data[8]) OR (Data[11] OR Data[5]))))))) XOR (((((NOT (NOT (NOT Data[24]))) OR Data[42]) OR Data[35]) XOR ((((NOT (((Data[11] XOR Data[48]) XOR TRUE) OR (Data[3] OR Data[48]))) AND ((Data[19] AND (Data[49] OR Data[38])) OR (((NOT Data[35]) XOR (NOT Data[20])) XOR (Data[2] OR Data[33])))) XOR Data[14]) XOR (((NOT (NOT Data[36])) OR (TRUE AND ((Data[36] XOR Data[34]) XOR Data[35]))) AND (((Data[28] AND Data[27]) AND (Data[6] AND Data[47])) OR (Data[30] OR (Data[43] AND Data[16])))))) XOR ((((Data[20] AND ((Data[10] OR Data[10]) AND Data[47])) OR Data[16]) XOR (((((Data[8] OR Data[1]) XOR Data[43]) XOR (NOT Data[7])) AND (((Data[8] XOR Data[28]) XOR Data[43]) OR Data[9])) AND Data[14])) XOR (((NOT (NOT Data[47])) OR ((NOT Data[50]) AND (Data[27] AND Data[46]))) AND ((((Data[14] AND Data[40]) OR (Data[17] OR Data[2])) XOR (((Data[20] OR Data[31]) XOR (Data[28] AND Data[19])) XOR (Data[50] AND Data[40]))) XOR ((Data[4] OR Data[35]) AND ((Data[40] XOR Data[16]) XOR Data[32]))))))))));
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
