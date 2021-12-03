(*
This code implements a randomly grown symbolic expression:

((xor(xor(!(IN17), IN3), IN42 & (!(!((!(xor(xor(IN42 & IN8, IN18), IN49))) | (!(IN32))))))) & ((!(!((IN47 | (IN12 & (xor(xor(!(IN9), IN41 & IN17), IN45)))) & (xor(xor(IN6 & (IN23 | (IN31 | IN44)), xor(xor((!(IN32)) & (!(IN23)), IN42 & (IN50 | IN34)), xor(xor(!(IN34), !(IN32)), IN15))), xor(xor(IN33, xor(xor(IN45 & IN5, IN11 & IN16), IN3 | IN4)), !(!(IN15)))))))) & (((xor(xor(((xor(xor(IN50 | IN14, IN46 & IN40), xor(xor(IN3, IN41), IN9))) & (IN22 & IN28)) | (xor(xor(IN41 | (IN26 & IN10), xor(xor(IN42 & IN12, xor(xor(IN32, IN46), IN35)), IN1 & IN11)), xor(xor(xor(xor(IN43, IN19), IN38), IN27 | IN21), !(IN10)))), !(xor(xor((xor(xor(IN7, IN50), IN1)) | IN6, (IN35 & IN3) | (!(IN28))), xor(xor(IN7 & IN16, IN37 | IN33), IN11)))), (!((!(IN25)) | (!(IN41)))) & ((!(IN33 & true)) & (!(!(IN5)))))) & (xor(xor(IN12, !(IN17)), (((!(IN28)) & (xor(xor(IN4, IN22), IN12))) | ((IN4 & IN38) & IN37)) | true))) | IN6))) & (xor(xor(!(IN24), xor(xor(!((xor(xor(IN48 | (!((IN17 & IN14) | IN31)), (xor(xor(true, xor(xor(xor(xor(IN16, IN16), IN17), !(IN23)), IN2)), (!(IN45)) | (xor(xor(IN31, IN48), IN25)))) & (!(xor(xor(IN6, IN41 & IN37), IN38)))), (IN26 | ((IN7 & IN2) | (IN17 | false))) & (xor(xor(IN42 & (IN28 | IN44), (IN16 & IN26) | (IN21 | IN13)), (IN11 & IN4) | (IN48 | IN47))))) & ((!(false & ((xor(xor(IN20, IN8), IN2)) | (IN36 & IN18)))) & IN47)), xor(xor(((false & (xor(xor(xor(xor(IN27 | IN30, xor(xor(IN23, IN27), IN7)), IN21), !(IN50)), (!(IN35)) & (xor(xor(IN21, IN7), IN17))))) | ((((IN9 | IN5) | (xor(xor(IN46, IN31), IN33))) | IN14) | IN32)) | (((!(IN19)) & IN21) & (!((!(IN44 & IN26)) | IN42))), xor(xor(!(IN34), (IN31 | (xor(xor(IN20, IN9), IN30))) | (xor(xor(IN21, xor(xor((IN29 | IN5) | (IN10 & IN14), xor(xor(IN41 & IN34, xor(xor(IN20, IN4), IN29)), IN29 & IN17)), IN39 | (IN7 & IN43))), ((!(IN40)) | IN50) | (!(IN17))))), xor(xor(xor(xor(IN31, IN24), ((IN30 | IN5) & (!(IN48))) | ((xor(xor(IN16, IN13), IN34)) & (!(IN16)))), (xor(xor(IN29 | IN25, xor(xor(xor(xor(IN20, IN40), IN9), IN26 | IN20), IN43 | IN32)), (xor(xor(IN35, IN6), IN33)) | (IN30 | IN7))) & (((true | IN15) | (IN46 | IN5)) | ((xor(xor(IN20, IN39), IN5)) | (IN48 | IN20)))), ((!(IN11 & IN1)) | ((xor(xor(IN5, IN25), IN49)) | (IN3 & IN43))) | (!(xor(xor(IN22, xor(xor(IN40, IN26), IN7)), xor(xor(IN10, IN10), IN44))))))), !(xor(xor(!(xor(xor((!(IN32)) | (xor(xor(IN28, IN4), IN11)), (IN7 | IN49) & (IN19 | IN17)), xor(xor(xor(xor(IN50, IN4), IN7), !(IN25)), !(IN10)))), (xor(xor(IN18 & (IN23 | IN36), xor(xor(IN36 | false, IN31 | IN19), IN15 & IN5)), !(IN41))) | (!(!(xor(xor(IN34, IN8), true))))), IN10 & (((IN39 & IN8) | (xor(xor(IN37, IN1), IN46))) | ((xor(xor(IN21, IN1), IN16)) | (false | IN1))))))), IN25 & (IN31 & (IN20 & IN46)))), IN38 | (!(IN32))))

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
    Out := (((((NOT Data[17]) XOR Data[3]) XOR (Data[42] AND (NOT (NOT ((NOT (((Data[42] AND Data[8]) XOR Data[18]) XOR Data[49])) OR (NOT Data[32])))))) AND ((NOT (NOT ((Data[47] OR (Data[12] AND (((NOT Data[9]) XOR (Data[41] AND Data[17])) XOR Data[45]))) AND (((Data[6] AND (Data[23] OR (Data[31] OR Data[44]))) XOR ((((NOT Data[32]) AND (NOT Data[23])) XOR (Data[42] AND (Data[50] OR Data[34]))) XOR (((NOT Data[34]) XOR (NOT Data[32])) XOR Data[15]))) XOR ((Data[33] XOR (((Data[45] AND Data[5]) XOR (Data[11] AND Data[16])) XOR (Data[3] OR Data[4]))) XOR (NOT (NOT Data[15]))))))) AND (((((((((Data[50] OR Data[14]) XOR (Data[46] AND Data[40])) XOR ((Data[3] XOR Data[41]) XOR Data[9])) AND (Data[22] AND Data[28])) OR (((Data[41] OR (Data[26] AND Data[10])) XOR (((Data[42] AND Data[12]) XOR ((Data[32] XOR Data[46]) XOR Data[35])) XOR (Data[1] AND Data[11]))) XOR ((((Data[43] XOR Data[19]) XOR Data[38]) XOR (Data[27] OR Data[21])) XOR (NOT Data[10])))) XOR (NOT (((((Data[7] XOR Data[50]) XOR Data[1]) OR Data[6]) XOR ((Data[35] AND Data[3]) OR (NOT Data[28]))) XOR (((Data[7] AND Data[16]) XOR (Data[37] OR Data[33])) XOR Data[11])))) XOR ((NOT ((NOT Data[25]) OR (NOT Data[41]))) AND ((NOT (Data[33] AND TRUE)) AND (NOT (NOT Data[5]))))) AND ((Data[12] XOR (NOT Data[17])) XOR ((((NOT Data[28]) AND ((Data[4] XOR Data[22]) XOR Data[12])) OR ((Data[4] AND Data[38]) AND Data[37])) OR TRUE))) OR Data[6]))) AND (((NOT Data[24]) XOR (((NOT ((((Data[48] OR (NOT ((Data[17] AND Data[14]) OR Data[31]))) XOR (((TRUE XOR ((((Data[16] XOR Data[16]) XOR Data[17]) XOR (NOT Data[23])) XOR Data[2])) XOR ((NOT Data[45]) OR ((Data[31] XOR Data[48]) XOR Data[25]))) AND (NOT ((Data[6] XOR (Data[41] AND Data[37])) XOR Data[38])))) XOR ((Data[26] OR ((Data[7] AND Data[2]) OR (Data[17] OR FALSE))) AND (((Data[42] AND (Data[28] OR Data[44])) XOR ((Data[16] AND Data[26]) OR (Data[21] OR Data[13]))) XOR ((Data[11] AND Data[4]) OR (Data[48] OR Data[47]))))) AND ((NOT (FALSE AND (((Data[20] XOR Data[8]) XOR Data[2]) OR (Data[36] AND Data[18])))) AND Data[47]))) XOR (((((FALSE AND (((((Data[27] OR Data[30]) XOR ((Data[23] XOR Data[27]) XOR Data[7])) XOR Data[21]) XOR (NOT Data[50])) XOR ((NOT Data[35]) AND ((Data[21] XOR Data[7]) XOR Data[17])))) OR ((((Data[9] OR Data[5]) OR ((Data[46] XOR Data[31]) XOR Data[33])) OR Data[14]) OR Data[32])) OR (((NOT Data[19]) AND Data[21]) AND (NOT ((NOT (Data[44] AND Data[26])) OR Data[42])))) XOR (((NOT Data[34]) XOR ((Data[31] OR ((Data[20] XOR Data[9]) XOR Data[30])) OR ((Data[21] XOR ((((Data[29] OR Data[5]) OR (Data[10] AND Data[14])) XOR (((Data[41] AND Data[34]) XOR ((Data[20] XOR Data[4]) XOR Data[29])) XOR (Data[29] AND Data[17]))) XOR (Data[39] OR (Data[7] AND Data[43])))) XOR (((NOT Data[40]) OR Data[50]) OR (NOT Data[17]))))) XOR ((((Data[31] XOR Data[24]) XOR (((Data[30] OR Data[5]) AND (NOT Data[48])) OR (((Data[16] XOR Data[13]) XOR Data[34]) AND (NOT Data[16])))) XOR ((((Data[29] OR Data[25]) XOR ((((Data[20] XOR Data[40]) XOR Data[9]) XOR (Data[26] OR Data[20])) XOR (Data[43] OR Data[32]))) XOR (((Data[35] XOR Data[6]) XOR Data[33]) OR (Data[30] OR Data[7]))) AND (((TRUE OR Data[15]) OR (Data[46] OR Data[5])) OR (((Data[20] XOR Data[39]) XOR Data[5]) OR (Data[48] OR Data[20]))))) XOR (((NOT (Data[11] AND Data[1])) OR (((Data[5] XOR Data[25]) XOR Data[49]) OR (Data[3] AND Data[43]))) OR (NOT ((Data[22] XOR ((Data[40] XOR Data[26]) XOR Data[7])) XOR ((Data[10] XOR Data[10]) XOR Data[44]))))))) XOR (NOT (((NOT ((((NOT Data[32]) OR ((Data[28] XOR Data[4]) XOR Data[11])) XOR ((Data[7] OR Data[49]) AND (Data[19] OR Data[17]))) XOR ((((Data[50] XOR Data[4]) XOR Data[7]) XOR (NOT Data[25])) XOR (NOT Data[10])))) XOR ((((Data[18] AND (Data[23] OR Data[36])) XOR (((Data[36] OR FALSE) XOR (Data[31] OR Data[19])) XOR (Data[15] AND Data[5]))) XOR (NOT Data[41])) OR (NOT (NOT ((Data[34] XOR Data[8]) XOR TRUE))))) XOR (Data[10] AND (((Data[39] AND Data[8]) OR ((Data[37] XOR Data[1]) XOR Data[46])) OR (((Data[21] XOR Data[1]) XOR Data[16]) OR (FALSE OR Data[1])))))))) XOR (Data[25] AND (Data[31] AND (Data[20] AND Data[46]))))) XOR (Data[38] OR (NOT Data[32]))));
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
