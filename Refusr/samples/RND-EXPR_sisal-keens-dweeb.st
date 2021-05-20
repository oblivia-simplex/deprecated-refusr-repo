(*
This code implements a randomly grown symbolic expression:

((IN8 & (xor(xor(xor(xor(((!(xor(xor(IN20 & IN27, IN16 & IN35), !(IN38)))) | (xor(xor(IN48, (xor(xor(IN13, IN11), IN50)) | (xor(xor(IN27, IN2), IN19))), xor(xor(IN10, xor(xor(IN3, IN44), IN33)), !(IN13))))) & ((((!(IN49)) | IN45) | ((xor(xor(IN37, IN11), IN42)) & (!(IN15)))) | ((IN38 & (false | IN44)) | ((xor(xor(IN48, IN7), IN31)) & (!(IN5))))), IN48), !((!(IN46)) | ((!(!(IN4))) | (!(IN23 | IN49))))), (!(xor(xor((IN49 & (!(IN6))) & IN43, xor(xor(IN45, !(IN11 & IN3)), (xor(xor(IN10, IN26), IN11)) & (IN38 & IN47))), IN10))) & ((xor(xor(xor(xor(xor(xor(IN44 | IN8, IN37), xor(xor(true, IN3), IN6)), !(IN43 & IN23)), IN6), (!(IN23 & IN33)) & (!(IN39 | IN20))), xor(xor((!(IN21)) & (IN28 | IN37), !(IN33 | IN4)), IN40))) | (!(((!(IN41)) & IN50) & ((xor(xor(IN17, IN41), IN2)) & (IN10 & IN29)))))), xor(xor(IN13, (xor(xor(!(xor(xor(!(IN25), IN30 & IN3), !(IN26))), xor(xor((IN34 | IN33) | (!(IN36)), !(IN43 | IN2)), xor(xor(IN10 & IN46, !(IN22)), xor(xor(IN44, IN37), IN16)))), xor(xor((xor(xor(IN36, IN11), IN27)) | (IN13 | IN50), (IN42 & IN34) & (IN5 & IN43)), xor(xor(IN35, !(IN35)), xor(xor(IN1, IN26), IN25))))) | (xor(xor(!(IN39), xor(xor(!(IN45 | IN21), (IN44 & IN4) & (IN15 & IN10)), !(xor(xor(IN22, IN31), IN43)))), xor(xor((xor(xor(IN15, IN44), IN15)) & (IN25 | IN26), xor(xor(IN20 & IN21, IN14 & IN13), !(IN20))), (IN50 | IN32) | (IN7 & IN7))))), (xor(xor(!((IN16 & IN46) & (xor(xor(IN50, IN17), IN23))), IN22 & ((!(IN22)) | true)), (!(xor(xor(IN30, IN23), IN12))) | (xor(xor(IN27 | IN25, xor(xor(IN32, IN20), IN47)), xor(xor(IN49, IN34), false))))) | (xor(xor(IN28, ((xor(xor(IN22, IN8), IN38)) | IN20) | (!(IN17 & IN39))), ((xor(xor(IN8, IN50), IN25)) & (IN25 & IN41)) | IN40)))))) | IN43) | (!(!(xor(xor(xor(xor(!(!(!((!(IN47)) | (xor(xor(IN48, IN32), IN40))))), xor(xor(xor(xor(IN26 & (IN36 & (IN50 | IN12)), ((IN19 & IN10) & IN42) | (xor(xor(xor(xor(IN48, IN40), IN26), IN37 & false), IN26 | IN44))), (IN23 | (IN47 | IN39)) & (xor(xor(IN31 | IN24, IN26 & IN6), !(IN11)))), !(IN22)), !(IN4))), IN18 | IN18), xor(xor(IN50, (xor(xor(xor(xor(xor(xor(IN38, IN39 | IN10), xor(xor(IN36, IN16), IN5)), !(IN43)), (xor(xor(IN43, IN20), IN44)) & (!(IN24))), ((xor(xor(IN27, IN1), IN9)) | (xor(xor(IN4, IN24), IN13))) & IN12), ((IN29 | IN47) | (!(IN32))) | IN1)) | (xor(xor(((IN41 | IN14) & (IN15 & IN9)) & IN9, (!(IN23)) | (xor(xor(IN13 | IN38, IN13), xor(xor(IN36, IN48), IN31)))), xor(xor((IN7 | IN11) | (!(IN34)), (!(IN34)) | (IN43 & IN1)), (IN49 | IN16) | (!(IN49)))))), xor(xor((((false | IN17) | (xor(xor(IN3, IN13), IN3))) | (!(IN16 & true))) | (IN1 | IN25), ((!(IN50)) & (!(IN36 & IN1))) | (!(!(xor(xor(IN48, IN46), IN35))))), xor(xor(IN19 & ((IN28 & IN49) & (IN43 | IN40)), IN14), (!(IN38 | IN6)) & IN50)))), IN48 & (xor(xor(((!(IN41)) | ((xor(xor(IN14, IN38), IN48)) & IN50)) & ((xor(xor(IN11, IN18 & IN7), IN7 | IN20)) | (IN8 & (xor(xor(IN8, IN23), IN20)))), xor(xor((xor(xor(IN26 & IN21, IN4 | IN14), xor(xor(IN31, false), IN18))) & (xor(xor(IN37, IN14 & IN47), xor(xor(IN14, IN8), IN37))), !((xor(xor(IN3, IN24), IN28)) & IN29)), (IN27 | (!(IN44))) & IN22)), (!(IN29)) | (!((!(IN36)) | (IN23 | IN34)))))))))

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
    Out := (((Data[8] AND (((((((NOT (((Data[20] AND Data[27]) XOR (Data[16] AND Data[35])) XOR (NOT Data[38]))) OR ((Data[48] XOR (((Data[13] XOR Data[11]) XOR Data[50]) OR ((Data[27] XOR Data[2]) XOR Data[19]))) XOR ((Data[10] XOR ((Data[3] XOR Data[44]) XOR Data[33])) XOR (NOT Data[13])))) AND ((((NOT Data[49]) OR Data[45]) OR (((Data[37] XOR Data[11]) XOR Data[42]) AND (NOT Data[15]))) OR ((Data[38] AND (FALSE OR Data[44])) OR (((Data[48] XOR Data[7]) XOR Data[31]) AND (NOT Data[5]))))) XOR Data[48]) XOR (NOT ((NOT Data[46]) OR ((NOT (NOT Data[4])) OR (NOT (Data[23] OR Data[49])))))) XOR ((NOT ((((Data[49] AND (NOT Data[6])) AND Data[43]) XOR ((Data[45] XOR (NOT (Data[11] AND Data[3]))) XOR (((Data[10] XOR Data[26]) XOR Data[11]) AND (Data[38] AND Data[47])))) XOR Data[10])) AND ((((((((Data[44] OR Data[8]) XOR Data[37]) XOR ((TRUE XOR Data[3]) XOR Data[6])) XOR (NOT (Data[43] AND Data[23]))) XOR Data[6]) XOR ((NOT (Data[23] AND Data[33])) AND (NOT (Data[39] OR Data[20])))) XOR ((((NOT Data[21]) AND (Data[28] OR Data[37])) XOR (NOT (Data[33] OR Data[4]))) XOR Data[40])) OR (NOT (((NOT Data[41]) AND Data[50]) AND (((Data[17] XOR Data[41]) XOR Data[2]) AND (Data[10] AND Data[29]))))))) XOR ((Data[13] XOR ((((NOT (((NOT Data[25]) XOR (Data[30] AND Data[3])) XOR (NOT Data[26]))) XOR ((((Data[34] OR Data[33]) OR (NOT Data[36])) XOR (NOT (Data[43] OR Data[2]))) XOR (((Data[10] AND Data[46]) XOR (NOT Data[22])) XOR ((Data[44] XOR Data[37]) XOR Data[16])))) XOR (((((Data[36] XOR Data[11]) XOR Data[27]) OR (Data[13] OR Data[50])) XOR ((Data[42] AND Data[34]) AND (Data[5] AND Data[43]))) XOR ((Data[35] XOR (NOT Data[35])) XOR ((Data[1] XOR Data[26]) XOR Data[25])))) OR (((NOT Data[39]) XOR (((NOT (Data[45] OR Data[21])) XOR ((Data[44] AND Data[4]) AND (Data[15] AND Data[10]))) XOR (NOT ((Data[22] XOR Data[31]) XOR Data[43])))) XOR (((((Data[15] XOR Data[44]) XOR Data[15]) AND (Data[25] OR Data[26])) XOR (((Data[20] AND Data[21]) XOR (Data[14] AND Data[13])) XOR (NOT Data[20]))) XOR ((Data[50] OR Data[32]) OR (Data[7] AND Data[7])))))) XOR ((((NOT ((Data[16] AND Data[46]) AND ((Data[50] XOR Data[17]) XOR Data[23]))) XOR (Data[22] AND ((NOT Data[22]) OR TRUE))) XOR ((NOT ((Data[30] XOR Data[23]) XOR Data[12])) OR (((Data[27] OR Data[25]) XOR ((Data[32] XOR Data[20]) XOR Data[47])) XOR ((Data[49] XOR Data[34]) XOR FALSE)))) OR ((Data[28] XOR ((((Data[22] XOR Data[8]) XOR Data[38]) OR Data[20]) OR (NOT (Data[17] AND Data[39])))) XOR ((((Data[8] XOR Data[50]) XOR Data[25]) AND (Data[25] AND Data[41])) OR Data[40])))))) OR Data[43]) OR (NOT (NOT (((((NOT (NOT (NOT ((NOT Data[47]) OR ((Data[48] XOR Data[32]) XOR Data[40]))))) XOR (((((Data[26] AND (Data[36] AND (Data[50] OR Data[12]))) XOR (((Data[19] AND Data[10]) AND Data[42]) OR ((((Data[48] XOR Data[40]) XOR Data[26]) XOR (Data[37] AND FALSE)) XOR (Data[26] OR Data[44])))) XOR ((Data[23] OR (Data[47] OR Data[39])) AND (((Data[31] OR Data[24]) XOR (Data[26] AND Data[6])) XOR (NOT Data[11])))) XOR (NOT Data[22])) XOR (NOT Data[4]))) XOR (Data[18] OR Data[18])) XOR ((Data[50] XOR (((((((Data[38] XOR (Data[39] OR Data[10])) XOR ((Data[36] XOR Data[16]) XOR Data[5])) XOR (NOT Data[43])) XOR (((Data[43] XOR Data[20]) XOR Data[44]) AND (NOT Data[24]))) XOR ((((Data[27] XOR Data[1]) XOR Data[9]) OR ((Data[4] XOR Data[24]) XOR Data[13])) AND Data[12])) XOR (((Data[29] OR Data[47]) OR (NOT Data[32])) OR Data[1])) OR (((((Data[41] OR Data[14]) AND (Data[15] AND Data[9])) AND Data[9]) XOR ((NOT Data[23]) OR (((Data[13] OR Data[38]) XOR Data[13]) XOR ((Data[36] XOR Data[48]) XOR Data[31])))) XOR ((((Data[7] OR Data[11]) OR (NOT Data[34])) XOR ((NOT Data[34]) OR (Data[43] AND Data[1]))) XOR ((Data[49] OR Data[16]) OR (NOT Data[49])))))) XOR ((((((FALSE OR Data[17]) OR ((Data[3] XOR Data[13]) XOR Data[3])) OR (NOT (Data[16] AND TRUE))) OR (Data[1] OR Data[25])) XOR (((NOT Data[50]) AND (NOT (Data[36] AND Data[1]))) OR (NOT (NOT ((Data[48] XOR Data[46]) XOR Data[35]))))) XOR (((Data[19] AND ((Data[28] AND Data[49]) AND (Data[43] OR Data[40]))) XOR Data[14]) XOR ((NOT (Data[38] OR Data[6])) AND Data[50]))))) XOR (Data[48] AND (((((NOT Data[41]) OR (((Data[14] XOR Data[38]) XOR Data[48]) AND Data[50])) AND (((Data[11] XOR (Data[18] AND Data[7])) XOR (Data[7] OR Data[20])) OR (Data[8] AND ((Data[8] XOR Data[23]) XOR Data[20])))) XOR ((((((Data[26] AND Data[21]) XOR (Data[4] OR Data[14])) XOR ((Data[31] XOR FALSE) XOR Data[18])) AND ((Data[37] XOR (Data[14] AND Data[47])) XOR ((Data[14] XOR Data[8]) XOR Data[37]))) XOR (NOT (((Data[3] XOR Data[24]) XOR Data[28]) AND Data[29]))) XOR ((Data[27] OR (NOT Data[44])) AND Data[22]))) XOR ((NOT Data[29]) OR (NOT ((NOT Data[36]) OR (Data[23] OR Data[34]))))))))));
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
