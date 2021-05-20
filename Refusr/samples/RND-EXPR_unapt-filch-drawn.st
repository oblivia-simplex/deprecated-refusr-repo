(*
This code implements a randomly grown symbolic expression:

(!(((xor(xor(((xor(xor((xor(xor(IN31, IN18), IN21)) & (IN50 & IN24), IN29), xor(xor(IN25, IN42 | IN8), !(IN3)))) & IN26) & IN17, xor(xor((!((xor(xor(IN20, IN38), IN31)) | (xor(xor(IN29, IN48), IN28)))) | (!((!(IN37)) | (IN38 & IN28))), xor(xor(xor(xor((xor(xor(IN30, IN11), IN47)) & (IN32 | IN44), IN25), (xor(xor(IN31, IN27), IN19)) | (xor(xor(IN40, IN1), IN7))), xor(xor((IN42 | IN13) & IN35, IN34), IN17)), IN21)), xor(xor(IN8, !(IN18)), (IN32 | (xor(xor(IN10, IN41), IN41))) | ((!(IN50)) & (IN29 & true))))), IN27)) | ((xor(xor(!((xor(xor(IN22 | IN34, !(IN37)), xor(xor(IN11, IN3), IN46))) & ((!(IN45)) & (IN17 | IN31))), (xor(xor(IN6, xor(xor(IN43 & IN8, IN41 | IN39), xor(xor(IN17, IN48), IN34))), !(IN3 & IN25))) | (!((IN48 | IN11) & (IN44 & IN29)))), (xor(xor(IN34, IN28), IN1)) | ((xor(xor(IN10 | IN34, IN26 & IN10), xor(xor(IN27, IN4), IN46))) & true))) & (xor(xor(IN9 | (((!(IN18)) | (IN7 | IN8)) | (xor(xor(IN40 & IN19, IN19), IN7 | IN35))), xor(xor(IN17 | (xor(xor(IN9 | IN10, IN25 | IN22), IN44 & IN10)), !(IN31)), ((xor(xor(IN43, IN15), IN11)) & (IN26 & IN1)) & (!(!(IN17))))), IN36)))) & ((xor(xor(!(xor(xor((xor(xor(IN32 | IN14, IN28), IN24 | IN36)) & ((!(IN49)) & IN22), ((!(IN46)) | (xor(xor(IN24, IN40), IN38))) & (xor(xor(IN3, !(IN41)), IN31))), IN18 & ((xor(xor(IN34, IN9), IN47)) & IN21))), !(xor(xor(((xor(xor(IN16, false), IN31)) | (IN27 & IN33)) & ((IN22 & IN17) & IN46), xor(xor(!(IN36 | IN48), !(IN9)), (!(IN16)) | IN39)), (xor(xor(IN14 & IN26, !(IN31)), !(IN12))) | ((IN9 | IN16) | (IN37 & IN9))))), ((xor(xor(xor(xor(IN11, IN9 & IN18), xor(xor(IN9, IN14), IN5)), (IN32 & IN47) & (xor(xor(IN18, IN46), IN41))), (xor(xor(IN45, IN26), IN7)) & (xor(xor(IN40, IN29), IN50)))) & (!(IN37 & (IN48 & IN30)))) | ((!((!(IN43)) & (IN30 | IN26))) | ((!(IN22 & IN10)) & ((xor(xor(IN22, IN47), IN12)) | IN24))))) & (xor(xor(IN49, (!(!(xor(xor(IN8 & IN39, xor(xor(IN12, IN8), IN5)), IN14 & IN35)))) & (((!(IN16 | IN46)) | IN18) | IN36)), !((xor(xor((xor(xor(IN23, IN13), IN21)) & (!(IN19)), (!(IN36)) & (IN14 & IN28)), (xor(xor(true, IN35), IN6)) & (IN19 & IN14))) | (xor(xor((xor(xor(IN22, IN43), IN42)) | (!(IN39)), IN43), (IN8 & IN30) | IN2)))))))) | (!((xor(xor(((!(xor(xor((IN27 & IN6) | (IN50 | IN7), false), xor(xor(!(IN35), IN6 | IN35), IN48 | IN2)))) & (!(!((IN2 | IN21) & (IN26 & IN21))))) & (!(!(!(IN29)))), IN19 | IN3), !((xor(xor(!((IN49 & true) | (IN42 | IN48)), (!(xor(xor(IN44, IN22), IN44))) & (!(IN9 & IN13))), IN1)) | (((xor(xor(IN11, xor(xor(IN23, IN30), IN25)), IN39 & IN10)) & (!(!(IN33)))) | (((!(IN24)) | (!(IN39))) | true))))) | ((!((xor(xor((!(!(IN14))) | IN12, !((!(IN1)) & (!(IN37)))), xor(xor(xor(xor(IN4, IN1 & IN46), IN26), xor(xor(true, IN13 | IN15), IN21 & IN49)), !(IN41 & IN44)))) | ((!(false | (IN2 & IN14))) & (((IN15 & IN28) | (xor(xor(IN6, IN46), IN18))) & (xor(xor(IN5 | IN17, xor(xor(IN11, IN36), IN45)), IN43)))))) | (xor(xor(IN37, !(xor(xor((IN33 & IN26) & (xor(xor(xor(xor(IN24, IN11), IN28), !(IN46)), IN24 & IN37)), IN2), xor(xor(!(IN50), (xor(xor(IN43, IN46), IN48)) & (IN11 & IN26)), (!(IN45)) & (!(IN37)))))), (xor(xor(IN37, (xor(xor(IN2 | IN8, IN15), IN33 & IN32)) | (!(IN23 | false))), (!(IN15 | IN3)) & (xor(xor(IN22, IN46), !(IN26))))) & (IN43 | IN25))))))

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
    Out := ((NOT (((((((((((Data[31] XOR Data[18]) XOR Data[21]) AND (Data[50] AND Data[24])) XOR Data[29]) XOR ((Data[25] XOR (Data[42] OR Data[8])) XOR (NOT Data[3]))) AND Data[26]) AND Data[17]) XOR ((((NOT (((Data[20] XOR Data[38]) XOR Data[31]) OR ((Data[29] XOR Data[48]) XOR Data[28]))) OR (NOT ((NOT Data[37]) OR (Data[38] AND Data[28])))) XOR (((((((Data[30] XOR Data[11]) XOR Data[47]) AND (Data[32] OR Data[44])) XOR Data[25]) XOR (((Data[31] XOR Data[27]) XOR Data[19]) OR ((Data[40] XOR Data[1]) XOR Data[7]))) XOR ((((Data[42] OR Data[13]) AND Data[35]) XOR Data[34]) XOR Data[17])) XOR Data[21])) XOR ((Data[8] XOR (NOT Data[18])) XOR ((Data[32] OR ((Data[10] XOR Data[41]) XOR Data[41])) OR ((NOT Data[50]) AND (Data[29] AND TRUE)))))) XOR Data[27]) OR ((((NOT ((((Data[22] OR Data[34]) XOR (NOT Data[37])) XOR ((Data[11] XOR Data[3]) XOR Data[46])) AND ((NOT Data[45]) AND (Data[17] OR Data[31])))) XOR (((Data[6] XOR (((Data[43] AND Data[8]) XOR (Data[41] OR Data[39])) XOR ((Data[17] XOR Data[48]) XOR Data[34]))) XOR (NOT (Data[3] AND Data[25]))) OR (NOT ((Data[48] OR Data[11]) AND (Data[44] AND Data[29]))))) XOR (((Data[34] XOR Data[28]) XOR Data[1]) OR ((((Data[10] OR Data[34]) XOR (Data[26] AND Data[10])) XOR ((Data[27] XOR Data[4]) XOR Data[46])) AND TRUE))) AND (((Data[9] OR (((NOT Data[18]) OR (Data[7] OR Data[8])) OR (((Data[40] AND Data[19]) XOR Data[19]) XOR (Data[7] OR Data[35])))) XOR (((Data[17] OR (((Data[9] OR Data[10]) XOR (Data[25] OR Data[22])) XOR (Data[44] AND Data[10]))) XOR (NOT Data[31])) XOR ((((Data[43] XOR Data[15]) XOR Data[11]) AND (Data[26] AND Data[1])) AND (NOT (NOT Data[17]))))) XOR Data[36]))) AND ((((NOT ((((((Data[32] OR Data[14]) XOR Data[28]) XOR (Data[24] OR Data[36])) AND ((NOT Data[49]) AND Data[22])) XOR (((NOT Data[46]) OR ((Data[24] XOR Data[40]) XOR Data[38])) AND ((Data[3] XOR (NOT Data[41])) XOR Data[31]))) XOR (Data[18] AND (((Data[34] XOR Data[9]) XOR Data[47]) AND Data[21])))) XOR (NOT ((((((Data[16] XOR FALSE) XOR Data[31]) OR (Data[27] AND Data[33])) AND ((Data[22] AND Data[17]) AND Data[46])) XOR (((NOT (Data[36] OR Data[48])) XOR (NOT Data[9])) XOR ((NOT Data[16]) OR Data[39]))) XOR ((((Data[14] AND Data[26]) XOR (NOT Data[31])) XOR (NOT Data[12])) OR ((Data[9] OR Data[16]) OR (Data[37] AND Data[9])))))) XOR ((((((Data[11] XOR (Data[9] AND Data[18])) XOR ((Data[9] XOR Data[14]) XOR Data[5])) XOR ((Data[32] AND Data[47]) AND ((Data[18] XOR Data[46]) XOR Data[41]))) XOR (((Data[45] XOR Data[26]) XOR Data[7]) AND ((Data[40] XOR Data[29]) XOR Data[50]))) AND (NOT (Data[37] AND (Data[48] AND Data[30])))) OR ((NOT ((NOT Data[43]) AND (Data[30] OR Data[26]))) OR ((NOT (Data[22] AND Data[10])) AND (((Data[22] XOR Data[47]) XOR Data[12]) OR Data[24]))))) AND ((Data[49] XOR ((NOT (NOT (((Data[8] AND Data[39]) XOR ((Data[12] XOR Data[8]) XOR Data[5])) XOR (Data[14] AND Data[35])))) AND (((NOT (Data[16] OR Data[46])) OR Data[18]) OR Data[36]))) XOR (NOT ((((((Data[23] XOR Data[13]) XOR Data[21]) AND (NOT Data[19])) XOR ((NOT Data[36]) AND (Data[14] AND Data[28]))) XOR (((TRUE XOR Data[35]) XOR Data[6]) AND (Data[19] AND Data[14]))) OR (((((Data[22] XOR Data[43]) XOR Data[42]) OR (NOT Data[39])) XOR Data[43]) XOR ((Data[8] AND Data[30]) OR Data[2])))))))) OR (NOT ((((((NOT ((((Data[27] AND Data[6]) OR (Data[50] OR Data[7])) XOR FALSE) XOR (((NOT Data[35]) XOR (Data[6] OR Data[35])) XOR (Data[48] OR Data[2])))) AND (NOT (NOT ((Data[2] OR Data[21]) AND (Data[26] AND Data[21]))))) AND (NOT (NOT (NOT Data[29])))) XOR (Data[19] OR Data[3])) XOR (NOT ((((NOT ((Data[49] AND TRUE) OR (Data[42] OR Data[48]))) XOR ((NOT ((Data[44] XOR Data[22]) XOR Data[44])) AND (NOT (Data[9] AND Data[13])))) XOR Data[1]) OR ((((Data[11] XOR ((Data[23] XOR Data[30]) XOR Data[25])) XOR (Data[39] AND Data[10])) AND (NOT (NOT Data[33]))) OR (((NOT Data[24]) OR (NOT Data[39])) OR TRUE))))) OR ((NOT (((((NOT (NOT Data[14])) OR Data[12]) XOR (NOT ((NOT Data[1]) AND (NOT Data[37])))) XOR ((((Data[4] XOR (Data[1] AND Data[46])) XOR Data[26]) XOR ((TRUE XOR (Data[13] OR Data[15])) XOR (Data[21] AND Data[49]))) XOR (NOT (Data[41] AND Data[44])))) OR ((NOT (FALSE OR (Data[2] AND Data[14]))) AND (((Data[15] AND Data[28]) OR ((Data[6] XOR Data[46]) XOR Data[18])) AND (((Data[5] OR Data[17]) XOR ((Data[11] XOR Data[36]) XOR Data[45])) XOR Data[43]))))) OR ((Data[37] XOR (NOT ((((Data[33] AND Data[26]) AND ((((Data[24] XOR Data[11]) XOR Data[28]) XOR (NOT Data[46])) XOR (Data[24] AND Data[37]))) XOR Data[2]) XOR (((NOT Data[50]) XOR (((Data[43] XOR Data[46]) XOR Data[48]) AND (Data[11] AND Data[26]))) XOR ((NOT Data[45]) AND (NOT Data[37])))))) XOR (((Data[37] XOR ((((Data[2] OR Data[8]) XOR Data[15]) XOR (Data[33] AND Data[32])) OR (NOT (Data[23] OR FALSE)))) XOR ((NOT (Data[15] OR Data[3])) AND ((Data[22] XOR Data[46]) XOR (NOT Data[26])))) AND (Data[43] OR Data[25])))))));
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
