(*
This code implements a randomly grown symbolic expression:

IN23 | ((xor(xor(((!((!(!(xor(xor(IN3, IN39), IN23)))) & (xor(xor((IN37 & IN30) | IN33, IN16 | (IN49 | IN9)), xor(xor(IN13 | IN6, !(IN46)), !(IN11)))))) | (!(!(((xor(xor(IN20, IN44), IN17)) & IN43) | (true & IN41))))) | ((!(IN3)) | (!(IN43))), IN3), IN29 & ((xor(xor(xor(xor(IN47, xor(xor((IN37 & IN14) & (!(IN4)), IN41), (IN33 | IN20) | (!(IN39)))), (!(!(IN2))) & (xor(xor(IN38, xor(xor(IN22, IN35), IN46)), IN40))), (!(IN48)) | (xor(xor(IN26 | (true & IN3), !(IN27 & IN36)), IN46))), (IN43 & IN46) | (IN45 | (IN1 | (IN35 | IN6))))) & (xor(xor(!(IN30 | (xor(xor(IN6 | IN23, xor(xor(IN5, IN13), IN16)), IN28 & IN47))), xor(xor((xor(xor(!(IN7), IN8 & IN25), !(IN37))) & (xor(xor(IN3 | IN16, xor(xor(IN15, IN12), IN36)), IN31 | IN30)), IN45 & (xor(xor(IN23 & IN2, IN19 & IN20), IN29))), xor(xor(xor(xor(IN30, !(IN36)), IN6 | IN24), !(IN23 & IN40)), !(IN21)))), xor(xor(!(IN21 | (IN47 | IN1)), ((!(IN40)) & (!(IN48))) & (!(IN16 & IN43))), xor(xor((xor(xor(IN3, IN26), IN3)) | (IN48 | IN43), !(IN41 & IN41)), !(IN38 | IN9)))))))) | (xor(xor(!(!((xor(xor((xor(xor(IN22 & IN18, IN40 & IN17), xor(xor(IN4, IN35), IN12))) | ((IN7 & IN12) | (!(IN34))), ((!(IN3)) | (IN30 | true)) & (!(!(IN33)))), ((IN25 | IN5) & (xor(xor(IN8, IN3), IN47))) & (xor(xor(IN42 | IN9, IN1 | IN39), IN47 | IN50)))) | (!(IN46)))), IN41 | ((!(!(IN12))) & (xor(xor(!((!(!(IN39))) | (xor(xor(xor(xor(IN26, IN22), IN46), xor(xor(IN12, IN37), IN36)), !(IN5)))), ((false & (IN42 | false)) | (!(!(IN14)))) | (xor(xor((IN26 | IN15) & (IN18 | IN11), !(xor(xor(IN49, IN9), IN43))), xor(xor(IN1 & IN37, xor(xor(IN17, IN14), true)), xor(xor(IN25, IN9), IN12))))), !(xor(xor((!(IN15)) | (!(IN2)), IN36), !(IN45 | IN43))))))), (!((((!(xor(xor(IN10, IN25), IN1))) | IN35) | (xor(xor((!(IN20)) & IN36, (IN18 & IN18) & (IN18 & IN20)), IN4 | false))) & ((xor(xor(xor(xor(xor(xor(IN49, IN15), IN11), IN45 & IN14), IN50 & IN46), (true & IN9) | (xor(xor(IN32, IN36), IN25))), (xor(xor(IN28, IN34), IN46)) | (IN49 | IN18))) & ((xor(xor(xor(xor(IN19, IN37), IN17), IN2), IN26 & IN16)) & ((!(IN32)) & IN19))))) & (!(IN35)))))

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
    Out := (Data[23] OR ((((((NOT ((NOT (NOT ((Data[3] XOR Data[39]) XOR Data[23]))) AND ((((Data[37] AND Data[30]) OR Data[33]) XOR (Data[16] OR (Data[49] OR Data[9]))) XOR (((Data[13] OR Data[6]) XOR (NOT Data[46])) XOR (NOT Data[11]))))) OR (NOT (NOT ((((Data[20] XOR Data[44]) XOR Data[17]) AND Data[43]) OR (TRUE AND Data[41]))))) OR ((NOT Data[3]) OR (NOT Data[43]))) XOR Data[3]) XOR (Data[29] AND (((((Data[47] XOR ((((Data[37] AND Data[14]) AND (NOT Data[4])) XOR Data[41]) XOR ((Data[33] OR Data[20]) OR (NOT Data[39])))) XOR ((NOT (NOT Data[2])) AND ((Data[38] XOR ((Data[22] XOR Data[35]) XOR Data[46])) XOR Data[40]))) XOR ((NOT Data[48]) OR (((Data[26] OR (TRUE AND Data[3])) XOR (NOT (Data[27] AND Data[36]))) XOR Data[46]))) XOR ((Data[43] AND Data[46]) OR (Data[45] OR (Data[1] OR (Data[35] OR Data[6]))))) AND (((NOT (Data[30] OR (((Data[6] OR Data[23]) XOR ((Data[5] XOR Data[13]) XOR Data[16])) XOR (Data[28] AND Data[47])))) XOR ((((((NOT Data[7]) XOR (Data[8] AND Data[25])) XOR (NOT Data[37])) AND (((Data[3] OR Data[16]) XOR ((Data[15] XOR Data[12]) XOR Data[36])) XOR (Data[31] OR Data[30]))) XOR (Data[45] AND (((Data[23] AND Data[2]) XOR (Data[19] AND Data[20])) XOR Data[29]))) XOR ((((Data[30] XOR (NOT Data[36])) XOR (Data[6] OR Data[24])) XOR (NOT (Data[23] AND Data[40]))) XOR (NOT Data[21])))) XOR (((NOT (Data[21] OR (Data[47] OR Data[1]))) XOR (((NOT Data[40]) AND (NOT Data[48])) AND (NOT (Data[16] AND Data[43])))) XOR (((((Data[3] XOR Data[26]) XOR Data[3]) OR (Data[48] OR Data[43])) XOR (NOT (Data[41] AND Data[41]))) XOR (NOT (Data[38] OR Data[9])))))))) OR (((NOT (NOT (((((((Data[22] AND Data[18]) XOR (Data[40] AND Data[17])) XOR ((Data[4] XOR Data[35]) XOR Data[12])) OR ((Data[7] AND Data[12]) OR (NOT Data[34]))) XOR (((NOT Data[3]) OR (Data[30] OR TRUE)) AND (NOT (NOT Data[33])))) XOR (((Data[25] OR Data[5]) AND ((Data[8] XOR Data[3]) XOR Data[47])) AND (((Data[42] OR Data[9]) XOR (Data[1] OR Data[39])) XOR (Data[47] OR Data[50])))) OR (NOT Data[46])))) XOR (Data[41] OR ((NOT (NOT Data[12])) AND (((NOT ((NOT (NOT Data[39])) OR ((((Data[26] XOR Data[22]) XOR Data[46]) XOR ((Data[12] XOR Data[37]) XOR Data[36])) XOR (NOT Data[5])))) XOR (((FALSE AND (Data[42] OR FALSE)) OR (NOT (NOT Data[14]))) OR ((((Data[26] OR Data[15]) AND (Data[18] OR Data[11])) XOR (NOT ((Data[49] XOR Data[9]) XOR Data[43]))) XOR (((Data[1] AND Data[37]) XOR ((Data[17] XOR Data[14]) XOR TRUE)) XOR ((Data[25] XOR Data[9]) XOR Data[12]))))) XOR (NOT ((((NOT Data[15]) OR (NOT Data[2])) XOR Data[36]) XOR (NOT (Data[45] OR Data[43])))))))) XOR ((NOT ((((NOT ((Data[10] XOR Data[25]) XOR Data[1])) OR Data[35]) OR ((((NOT Data[20]) AND Data[36]) XOR ((Data[18] AND Data[18]) AND (Data[18] AND Data[20]))) XOR (Data[4] OR FALSE))) AND (((((((Data[49] XOR Data[15]) XOR Data[11]) XOR (Data[45] AND Data[14])) XOR (Data[50] AND Data[46])) XOR ((TRUE AND Data[9]) OR ((Data[32] XOR Data[36]) XOR Data[25]))) XOR (((Data[28] XOR Data[34]) XOR Data[46]) OR (Data[49] OR Data[18]))) AND (((((Data[19] XOR Data[37]) XOR Data[17]) XOR Data[2]) XOR (Data[26] AND Data[16])) AND ((NOT Data[32]) AND Data[19]))))) AND (NOT Data[35])))));
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
