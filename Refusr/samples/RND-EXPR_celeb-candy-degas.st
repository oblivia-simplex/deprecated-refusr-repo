(*
This code implements a randomly grown symbolic expression:

!(xor(xor(!(!(((IN43 & ((xor(xor(IN28 | IN19, !(IN27)), IN33 | IN34)) & (xor(xor(xor(xor(IN27, IN17), IN17), xor(xor(true, IN6), IN43)), xor(xor(IN12, IN24), IN27))))) | IN22) & ((!(xor(xor(IN48, true), IN11))) | (((!(IN32)) | (!(IN3 | IN3))) | ((!(IN10)) | ((IN29 | IN6) | IN19)))))), xor(xor(xor(xor(IN26, !(IN24)), ((IN50 | ((xor(xor(IN4 & IN32, xor(xor(IN29, IN44), IN1)), IN25 & IN41)) | ((IN17 | IN36) & (xor(xor(IN10, IN2), IN16))))) & ((!(!(IN10))) | (!((!(IN48)) | (IN8 | IN19))))) | (!(!(((IN1 | IN6) | IN48) | (IN15 & IN7))))), ((xor(xor(xor(xor((xor(xor(!(IN39), !(IN1)), IN33 | IN10)) | IN5, xor(xor((IN21 | IN15) & (xor(xor(IN35, IN25), IN41)), (IN18 | IN2) & IN21), (IN2 | IN3) & (!(IN39)))), xor(xor((IN36 | IN33) | (!(IN14)), !(!(IN39))), !(IN16 & IN8))), IN15), (xor(xor(xor(xor(IN6 | IN24, xor(xor(IN49, IN14), IN21)), xor(xor(IN13, IN16), IN43)), !(xor(xor(IN23, IN10), IN19))), xor(xor(IN6 | IN31, xor(xor(IN40, IN38), IN29)), IN43))) & ((IN38 | (!(IN28))) | ((xor(xor(IN33, IN34), IN36)) & IN13)))) | IN42) | (((xor(xor((xor(xor(IN4, xor(xor(IN6, IN6), IN31)), !(IN21))) | (!(xor(xor(IN21, false), IN15))), IN17), ((xor(xor(false, IN5), IN47)) & (xor(xor(IN49, IN19), IN41))) & (xor(xor(!(IN38), IN8 | IN34), IN15 & IN16)))) | IN18) & ((IN38 & (IN28 & IN1)) | (xor(xor((IN10 | (!(IN33))) | IN45, (!(IN6 & IN5)) & ((!(IN3)) | IN19)), xor(xor(xor(xor(!(IN28), IN16 | IN32), IN2 | IN9), (IN39 | IN36) & (!(IN41))), (!(IN26)) | (!(IN47)))))))), xor(xor(!(((((IN14 | false) & IN34) & (IN23 & (IN13 | IN3))) & (((IN45 & IN1) | (xor(xor(IN22, IN35), IN4))) | (IN2 & IN25))) | IN26), xor(xor(xor(xor((IN2 & (xor(xor(xor(xor(IN4, IN28), IN34), IN3 & IN28), IN24 | IN22))) | IN16, (xor(xor(!(IN26 & IN50), !(IN13 | IN37)), !(IN35))) | (((!(IN35)) & IN24) & (!(IN24 & IN12)))), xor(xor(!((!(IN10)) | (IN9 | IN28)), ((IN35 | IN46) & IN4) | (xor(xor(false, xor(xor(IN22, IN24), IN1)), IN22 | IN21))), ((IN29 & IN33) | (xor(xor(false, IN45), IN26))) | IN30)), !(IN19)), xor(xor(false, !((xor(xor(IN22 | IN45, xor(xor(IN12, true), IN19)), IN35 & IN24)) | (!(IN46)))), IN50))), IN39))), xor(xor(IN12 & (xor(xor(!(xor(xor(((xor(xor(IN31, IN35), IN20)) & (!(IN37))) & ((xor(xor(IN15, IN38), IN12)) & (xor(xor(IN19, IN42), IN31))), ((IN9 & IN29) | (!(IN16))) & IN5), ((xor(xor(IN21, IN25), IN21)) | (IN21 | IN17)) & (!(!(IN42))))), xor(xor((xor(xor(IN12, !(xor(xor(IN48, true), IN39))), (IN21 | IN43) | (IN12 | true))) | ((xor(xor(IN31 | IN44, IN18 & IN48), xor(xor(IN11, IN35), IN21))) & (xor(xor(xor(xor(IN25, IN40), IN10), IN13 & true), xor(xor(IN47, IN22), IN21)))), (xor(xor((!(IN36)) & (IN29 & IN15), IN35), IN46)) & (!(IN32))), !(!((!(IN27)) & (!(IN36)))))), (!(((IN1 & IN21) | (!(IN45))) | ((IN23 & IN32) | IN41))) & (xor(xor(xor(xor(IN40, (!(IN32)) & (IN20 | IN20)), xor(xor(xor(xor(IN26, IN20), IN50), IN8 & IN49), IN4 & IN21)), ((xor(xor(IN25, IN6), IN39)) & (IN10 & IN16)) & (xor(xor(IN14 & IN33, IN3 & IN21), IN28 | IN18))), IN13)))), xor(xor(xor(xor(!((!(xor(xor(IN29 & IN49, IN32), xor(xor(IN15, IN21), IN3)))) | (!(IN49 & (xor(xor(IN23, IN40), IN49))))), (xor(xor(((!(IN49)) & (IN28 & IN26)) & IN23, ((IN43 & IN42) | IN39) & (!(IN38 | IN22))), (!(IN17)) & IN50)) & ((xor(xor(xor(xor(xor(xor(IN50, IN5), IN38), xor(xor(IN49, IN32), IN31)), !(IN18)), IN11), (!(IN6)) | IN38)) & IN48)), IN50 & IN22), ((xor(xor(IN31 & true, (!(IN47 & IN18)) | (!(!(IN48)))), (!(!(IN50))) | IN28)) | ((!((IN7 | IN24) | (IN4 | IN44))) | (xor(xor(!(IN9), IN39), (false & IN12) | (IN26 & IN50))))) & IN35), !((!(xor(xor(IN7, (!(IN38)) & (IN38 | IN17)), xor(xor(xor(xor(IN49, IN21), IN35), IN17 & IN21), xor(xor(IN45, IN26), IN29))))) | ((IN36 & (xor(xor(xor(xor(IN11, IN31), IN32), IN46 & IN49), !(IN2)))) & (!(!(IN24))))))), xor(xor(xor(xor(!(IN1 & IN12), (!(xor(xor(xor(xor(!(IN44), IN35), IN41 | IN16), xor(xor(IN39 & IN2, !(IN19)), IN25)), !(IN21)))) | ((((xor(xor(IN27, IN33), false)) & IN29) | ((IN4 & IN18) | (IN2 | IN36))) & IN46)), (IN23 | (!(IN13))) & (!((true & (IN42 & IN20)) | (xor(xor(!(IN12), IN7 | true), IN1 | IN14))))), IN21), !(!(IN29))))))

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
    Out := (NOT (((NOT (NOT (((Data[43] AND ((((Data[28] OR Data[19]) XOR (NOT Data[27])) XOR (Data[33] OR Data[34])) AND ((((Data[27] XOR Data[17]) XOR Data[17]) XOR ((TRUE XOR Data[6]) XOR Data[43])) XOR ((Data[12] XOR Data[24]) XOR Data[27])))) OR Data[22]) AND ((NOT ((Data[48] XOR TRUE) XOR Data[11])) OR (((NOT Data[32]) OR (NOT (Data[3] OR Data[3]))) OR ((NOT Data[10]) OR ((Data[29] OR Data[6]) OR Data[19]))))))) XOR ((((Data[26] XOR (NOT Data[24])) XOR (((Data[50] OR ((((Data[4] AND Data[32]) XOR ((Data[29] XOR Data[44]) XOR Data[1])) XOR (Data[25] AND Data[41])) OR ((Data[17] OR Data[36]) AND ((Data[10] XOR Data[2]) XOR Data[16])))) AND ((NOT (NOT Data[10])) OR (NOT ((NOT Data[48]) OR (Data[8] OR Data[19]))))) OR (NOT (NOT (((Data[1] OR Data[6]) OR Data[48]) OR (Data[15] AND Data[7])))))) XOR ((((((((((NOT Data[39]) XOR (NOT Data[1])) XOR (Data[33] OR Data[10])) OR Data[5]) XOR ((((Data[21] OR Data[15]) AND ((Data[35] XOR Data[25]) XOR Data[41])) XOR ((Data[18] OR Data[2]) AND Data[21])) XOR ((Data[2] OR Data[3]) AND (NOT Data[39])))) XOR ((((Data[36] OR Data[33]) OR (NOT Data[14])) XOR (NOT (NOT Data[39]))) XOR (NOT (Data[16] AND Data[8])))) XOR Data[15]) XOR ((((((Data[6] OR Data[24]) XOR ((Data[49] XOR Data[14]) XOR Data[21])) XOR ((Data[13] XOR Data[16]) XOR Data[43])) XOR (NOT ((Data[23] XOR Data[10]) XOR Data[19]))) XOR (((Data[6] OR Data[31]) XOR ((Data[40] XOR Data[38]) XOR Data[29])) XOR Data[43])) AND ((Data[38] OR (NOT Data[28])) OR (((Data[33] XOR Data[34]) XOR Data[36]) AND Data[13])))) OR Data[42]) OR (((((((Data[4] XOR ((Data[6] XOR Data[6]) XOR Data[31])) XOR (NOT Data[21])) OR (NOT ((Data[21] XOR FALSE) XOR Data[15]))) XOR Data[17]) XOR ((((FALSE XOR Data[5]) XOR Data[47]) AND ((Data[49] XOR Data[19]) XOR Data[41])) AND (((NOT Data[38]) XOR (Data[8] OR Data[34])) XOR (Data[15] AND Data[16])))) OR Data[18]) AND ((Data[38] AND (Data[28] AND Data[1])) OR ((((Data[10] OR (NOT Data[33])) OR Data[45]) XOR ((NOT (Data[6] AND Data[5])) AND ((NOT Data[3]) OR Data[19]))) XOR (((((NOT Data[28]) XOR (Data[16] OR Data[32])) XOR (Data[2] OR Data[9])) XOR ((Data[39] OR Data[36]) AND (NOT Data[41]))) XOR ((NOT Data[26]) OR (NOT Data[47])))))))) XOR (((NOT (((((Data[14] OR FALSE) AND Data[34]) AND (Data[23] AND (Data[13] OR Data[3]))) AND (((Data[45] AND Data[1]) OR ((Data[22] XOR Data[35]) XOR Data[4])) OR (Data[2] AND Data[25]))) OR Data[26])) XOR ((((((Data[2] AND ((((Data[4] XOR Data[28]) XOR Data[34]) XOR (Data[3] AND Data[28])) XOR (Data[24] OR Data[22]))) OR Data[16]) XOR ((((NOT (Data[26] AND Data[50])) XOR (NOT (Data[13] OR Data[37]))) XOR (NOT Data[35])) OR (((NOT Data[35]) AND Data[24]) AND (NOT (Data[24] AND Data[12]))))) XOR (((NOT ((NOT Data[10]) OR (Data[9] OR Data[28]))) XOR (((Data[35] OR Data[46]) AND Data[4]) OR ((FALSE XOR ((Data[22] XOR Data[24]) XOR Data[1])) XOR (Data[22] OR Data[21])))) XOR (((Data[29] AND Data[33]) OR ((FALSE XOR Data[45]) XOR Data[26])) OR Data[30]))) XOR (NOT Data[19])) XOR ((FALSE XOR (NOT ((((Data[22] OR Data[45]) XOR ((Data[12] XOR TRUE) XOR Data[19])) XOR (Data[35] AND Data[24])) OR (NOT Data[46])))) XOR Data[50]))) XOR Data[39]))) XOR (((Data[12] AND (((NOT ((((((Data[31] XOR Data[35]) XOR Data[20]) AND (NOT Data[37])) AND (((Data[15] XOR Data[38]) XOR Data[12]) AND ((Data[19] XOR Data[42]) XOR Data[31]))) XOR (((Data[9] AND Data[29]) OR (NOT Data[16])) AND Data[5])) XOR ((((Data[21] XOR Data[25]) XOR Data[21]) OR (Data[21] OR Data[17])) AND (NOT (NOT Data[42]))))) XOR (((((Data[12] XOR (NOT ((Data[48] XOR TRUE) XOR Data[39]))) XOR ((Data[21] OR Data[43]) OR (Data[12] OR TRUE))) OR ((((Data[31] OR Data[44]) XOR (Data[18] AND Data[48])) XOR ((Data[11] XOR Data[35]) XOR Data[21])) AND ((((Data[25] XOR Data[40]) XOR Data[10]) XOR (Data[13] AND TRUE)) XOR ((Data[47] XOR Data[22]) XOR Data[21])))) XOR (((((NOT Data[36]) AND (Data[29] AND Data[15])) XOR Data[35]) XOR Data[46]) AND (NOT Data[32]))) XOR (NOT (NOT ((NOT Data[27]) AND (NOT Data[36])))))) XOR ((NOT (((Data[1] AND Data[21]) OR (NOT Data[45])) OR ((Data[23] AND Data[32]) OR Data[41]))) AND ((((Data[40] XOR ((NOT Data[32]) AND (Data[20] OR Data[20]))) XOR ((((Data[26] XOR Data[20]) XOR Data[50]) XOR (Data[8] AND Data[49])) XOR (Data[4] AND Data[21]))) XOR ((((Data[25] XOR Data[6]) XOR Data[39]) AND (Data[10] AND Data[16])) AND (((Data[14] AND Data[33]) XOR (Data[3] AND Data[21])) XOR (Data[28] OR Data[18])))) XOR Data[13])))) XOR (((((NOT ((NOT (((Data[29] AND Data[49]) XOR Data[32]) XOR ((Data[15] XOR Data[21]) XOR Data[3]))) OR (NOT (Data[49] AND ((Data[23] XOR Data[40]) XOR Data[49]))))) XOR ((((((NOT Data[49]) AND (Data[28] AND Data[26])) AND Data[23]) XOR (((Data[43] AND Data[42]) OR Data[39]) AND (NOT (Data[38] OR Data[22])))) XOR ((NOT Data[17]) AND Data[50])) AND (((((((Data[50] XOR Data[5]) XOR Data[38]) XOR ((Data[49] XOR Data[32]) XOR Data[31])) XOR (NOT Data[18])) XOR Data[11]) XOR ((NOT Data[6]) OR Data[38])) AND Data[48]))) XOR (Data[50] AND Data[22])) XOR (((((Data[31] AND TRUE) XOR ((NOT (Data[47] AND Data[18])) OR (NOT (NOT Data[48])))) XOR ((NOT (NOT Data[50])) OR Data[28])) OR ((NOT ((Data[7] OR Data[24]) OR (Data[4] OR Data[44]))) OR (((NOT Data[9]) XOR Data[39]) XOR ((FALSE AND Data[12]) OR (Data[26] AND Data[50]))))) AND Data[35])) XOR (NOT ((NOT ((Data[7] XOR ((NOT Data[38]) AND (Data[38] OR Data[17]))) XOR ((((Data[49] XOR Data[21]) XOR Data[35]) XOR (Data[17] AND Data[21])) XOR ((Data[45] XOR Data[26]) XOR Data[29])))) OR ((Data[36] AND ((((Data[11] XOR Data[31]) XOR Data[32]) XOR (Data[46] AND Data[49])) XOR (NOT Data[2]))) AND (NOT (NOT Data[24]))))))) XOR (((((NOT (Data[1] AND Data[12])) XOR ((NOT (((((NOT Data[44]) XOR Data[35]) XOR (Data[41] OR Data[16])) XOR (((Data[39] AND Data[2]) XOR (NOT Data[19])) XOR Data[25])) XOR (NOT Data[21]))) OR (((((Data[27] XOR Data[33]) XOR FALSE) AND Data[29]) OR ((Data[4] AND Data[18]) OR (Data[2] OR Data[36]))) AND Data[46]))) XOR ((Data[23] OR (NOT Data[13])) AND (NOT ((TRUE AND (Data[42] AND Data[20])) OR (((NOT Data[12]) XOR (Data[7] OR TRUE)) XOR (Data[1] OR Data[14])))))) XOR Data[21]) XOR (NOT (NOT Data[29]))))));
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
