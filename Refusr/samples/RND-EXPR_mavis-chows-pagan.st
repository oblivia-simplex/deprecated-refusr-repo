(*
This code implements a randomly grown symbolic expression:

!(((xor(xor(((!((xor(xor(IN5 & IN31, IN14), xor(xor(IN41, IN34), IN36))) | (xor(xor(IN5 & true, xor(xor(IN20, IN11), IN46)), xor(xor(IN9, IN25), IN28))))) | ((!((IN16 | IN46) | (IN34 | IN14))) & (((!(IN2)) & (IN5 | IN10)) | (xor(xor(xor(xor(IN46, IN24), IN5), IN28), xor(xor(IN22, IN7), IN13)))))) | (!(IN19 | (xor(xor((!(IN12)) | (IN2 & IN50), IN16), (IN45 & IN28) & IN21)))), xor(xor((xor(xor((xor(xor(IN6 & IN27, IN43 | IN5), IN28)) | (!(IN20 | IN22)), (IN35 & (IN50 | IN10)) | (!(IN19 & IN2))), IN7)) & (!(xor(xor((IN40 | IN16) & (xor(xor(IN27, IN8), IN19)), (xor(xor(IN45, IN13), IN13)) | (IN25 | IN3)), xor(xor(!(IN49), IN29 & IN12), IN16)))), ((!(xor(xor(xor(xor(IN33, IN26), IN50), !(IN42)), !(IN30)))) & IN3) & (xor(xor(!(xor(xor(IN2, xor(xor(false, IN16), true)), xor(xor(IN17, IN11), IN10))), IN24), ((IN41 | IN26) & (!(IN44))) & (!(!(IN6)))))), IN30 & IN4)), xor(xor(xor(xor(!((xor(xor(xor(xor(IN31, IN12), IN9), IN26 | IN38), xor(xor(IN20, IN24), IN46))) | ((IN20 & true) & IN13)), (!(IN36)) | (xor(xor(xor(xor(xor(xor(IN2, IN48), IN8), xor(xor(IN24, IN16), IN9)), IN50 & IN17), IN49), (xor(xor(IN31, true), IN31)) | (xor(xor(IN16, IN38), IN3))))), IN32), IN39), xor(xor((IN17 & (xor(xor(IN35, IN17), !(IN22)))) & (!((!(IN41)) | (IN28 | true))), xor(xor(((!(IN13)) & (xor(xor(IN29, IN36), IN8))) | (xor(xor(IN23 | IN37, IN18 | IN30), IN14 & IN24)), IN39), IN35)), (((IN5 | IN5) & (xor(xor(IN38, IN9), IN45))) & (xor(xor(xor(xor(IN14, IN9), IN1), xor(xor(IN3, IN7), IN34)), !(IN5)))) & ((xor(xor(true | IN3, IN49), IN17 | IN7)) | (!(xor(xor(IN29, IN5), IN48)))))))) | ((xor(xor(xor(xor(xor(xor(!((xor(xor(IN22, IN48), IN22)) | (xor(xor(IN2, true), IN15))), !(IN23)), false), !(((!(IN29)) | (IN46 & IN10)) & ((IN43 | IN35) & IN45))), IN5), (((!(IN35 & true)) | IN22) | (IN39 & (xor(xor(!(IN23), !(IN14)), IN5)))) | (false & (((true & IN42) | (xor(xor(IN16, IN12), IN19))) & (xor(xor(IN5 | IN16, !(IN31)), IN13 & IN46))))), xor(xor(((xor(xor(false & IN31, !(IN12)), IN38)) | ((IN12 & IN14) & IN26)) | (IN14 & (xor(xor(IN42 | IN16, IN50 | IN20), IN1 | IN31))), ((xor(xor(IN44 & IN16, IN29 & IN26), IN19)) & (xor(xor(IN17 & IN46, !(IN42)), xor(xor(IN40, IN42), IN9)))) & ((xor(xor(IN16, !(IN41)), IN2 & IN40)) | ((IN36 | IN3) | IN49))), ((xor(xor(IN35 & IN9, IN19 & IN34), IN12 | IN47)) & ((IN45 & IN19) & (!(IN33)))) | (((IN40 | IN32) | (IN2 | true)) & (xor(xor(IN40 & IN15, xor(xor(IN30, IN5), IN35)), IN48 & IN16)))))) & (!((xor(xor(IN16, IN15), !(!(true & IN45)))) & ((((!(IN44)) | (IN16 & IN26)) | IN43) | (((xor(xor(IN42, IN39), IN40)) | (IN42 & IN8)) & (xor(xor(IN37 & IN7, !(IN1)), IN30 | IN24)))))))) | (!(IN24)))

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
    Out := (NOT (((((((NOT ((((Data[5] AND Data[31]) XOR Data[14]) XOR ((Data[41] XOR Data[34]) XOR Data[36])) OR (((Data[5] AND TRUE) XOR ((Data[20] XOR Data[11]) XOR Data[46])) XOR ((Data[9] XOR Data[25]) XOR Data[28])))) OR ((NOT ((Data[16] OR Data[46]) OR (Data[34] OR Data[14]))) AND (((NOT Data[2]) AND (Data[5] OR Data[10])) OR ((((Data[46] XOR Data[24]) XOR Data[5]) XOR Data[28]) XOR ((Data[22] XOR Data[7]) XOR Data[13]))))) OR (NOT (Data[19] OR ((((NOT Data[12]) OR (Data[2] AND Data[50])) XOR Data[16]) XOR ((Data[45] AND Data[28]) AND Data[21]))))) XOR (((((((((Data[6] AND Data[27]) XOR (Data[43] OR Data[5])) XOR Data[28]) OR (NOT (Data[20] OR Data[22]))) XOR ((Data[35] AND (Data[50] OR Data[10])) OR (NOT (Data[19] AND Data[2])))) XOR Data[7]) AND (NOT ((((Data[40] OR Data[16]) AND ((Data[27] XOR Data[8]) XOR Data[19])) XOR (((Data[45] XOR Data[13]) XOR Data[13]) OR (Data[25] OR Data[3]))) XOR (((NOT Data[49]) XOR (Data[29] AND Data[12])) XOR Data[16])))) XOR (((NOT ((((Data[33] XOR Data[26]) XOR Data[50]) XOR (NOT Data[42])) XOR (NOT Data[30]))) AND Data[3]) AND (((NOT ((Data[2] XOR ((FALSE XOR Data[16]) XOR TRUE)) XOR ((Data[17] XOR Data[11]) XOR Data[10]))) XOR Data[24]) XOR (((Data[41] OR Data[26]) AND (NOT Data[44])) AND (NOT (NOT Data[6])))))) XOR (Data[30] AND Data[4]))) XOR (((((NOT (((((Data[31] XOR Data[12]) XOR Data[9]) XOR (Data[26] OR Data[38])) XOR ((Data[20] XOR Data[24]) XOR Data[46])) OR ((Data[20] AND TRUE) AND Data[13]))) XOR ((NOT Data[36]) OR ((((((Data[2] XOR Data[48]) XOR Data[8]) XOR ((Data[24] XOR Data[16]) XOR Data[9])) XOR (Data[50] AND Data[17])) XOR Data[49]) XOR (((Data[31] XOR TRUE) XOR Data[31]) OR ((Data[16] XOR Data[38]) XOR Data[3]))))) XOR Data[32]) XOR Data[39]) XOR ((((Data[17] AND ((Data[35] XOR Data[17]) XOR (NOT Data[22]))) AND (NOT ((NOT Data[41]) OR (Data[28] OR TRUE)))) XOR (((((NOT Data[13]) AND ((Data[29] XOR Data[36]) XOR Data[8])) OR (((Data[23] OR Data[37]) XOR (Data[18] OR Data[30])) XOR (Data[14] AND Data[24]))) XOR Data[39]) XOR Data[35])) XOR ((((Data[5] OR Data[5]) AND ((Data[38] XOR Data[9]) XOR Data[45])) AND ((((Data[14] XOR Data[9]) XOR Data[1]) XOR ((Data[3] XOR Data[7]) XOR Data[34])) XOR (NOT Data[5]))) AND ((((TRUE OR Data[3]) XOR Data[49]) XOR (Data[17] OR Data[7])) OR (NOT ((Data[29] XOR Data[5]) XOR Data[48]))))))) OR ((((((((NOT (((Data[22] XOR Data[48]) XOR Data[22]) OR ((Data[2] XOR TRUE) XOR Data[15]))) XOR (NOT Data[23])) XOR FALSE) XOR (NOT (((NOT Data[29]) OR (Data[46] AND Data[10])) AND ((Data[43] OR Data[35]) AND Data[45])))) XOR Data[5]) XOR ((((NOT (Data[35] AND TRUE)) OR Data[22]) OR (Data[39] AND (((NOT Data[23]) XOR (NOT Data[14])) XOR Data[5]))) OR (FALSE AND (((TRUE AND Data[42]) OR ((Data[16] XOR Data[12]) XOR Data[19])) AND (((Data[5] OR Data[16]) XOR (NOT Data[31])) XOR (Data[13] AND Data[46])))))) XOR (((((((FALSE AND Data[31]) XOR (NOT Data[12])) XOR Data[38]) OR ((Data[12] AND Data[14]) AND Data[26])) OR (Data[14] AND (((Data[42] OR Data[16]) XOR (Data[50] OR Data[20])) XOR (Data[1] OR Data[31])))) XOR (((((Data[44] AND Data[16]) XOR (Data[29] AND Data[26])) XOR Data[19]) AND (((Data[17] AND Data[46]) XOR (NOT Data[42])) XOR ((Data[40] XOR Data[42]) XOR Data[9]))) AND (((Data[16] XOR (NOT Data[41])) XOR (Data[2] AND Data[40])) OR ((Data[36] OR Data[3]) OR Data[49])))) XOR (((((Data[35] AND Data[9]) XOR (Data[19] AND Data[34])) XOR (Data[12] OR Data[47])) AND ((Data[45] AND Data[19]) AND (NOT Data[33]))) OR (((Data[40] OR Data[32]) OR (Data[2] OR TRUE)) AND (((Data[40] AND Data[15]) XOR ((Data[30] XOR Data[5]) XOR Data[35])) XOR (Data[48] AND Data[16])))))) AND (NOT (((Data[16] XOR Data[15]) XOR (NOT (NOT (TRUE AND Data[45])))) AND ((((NOT Data[44]) OR (Data[16] AND Data[26])) OR Data[43]) OR ((((Data[42] XOR Data[39]) XOR Data[40]) OR (Data[42] AND Data[8])) AND (((Data[37] AND Data[7]) XOR (NOT Data[1])) XOR (Data[30] OR Data[24])))))))) OR (NOT Data[24])));
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
