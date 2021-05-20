(*
This code implements a randomly grown symbolic expression:

(((xor(xor((xor(xor(xor(xor(IN19, (!(IN48 | IN21)) & (!(xor(xor(IN30, IN18), IN5)))), IN21), ((xor(xor(IN23 | IN7, IN44 | IN43), IN28 & IN45)) & ((!(IN4)) | (IN37 | IN4))) | (xor(xor((IN10 | IN19) | (IN27 & IN18), IN45), !(IN41)))), IN21)) & ((((IN36 | false) | ((!(IN22)) | (xor(xor(IN17, IN20), IN45)))) | (((xor(xor(IN40, IN49), IN35)) & (!(IN19))) & (xor(xor(xor(xor(IN32, IN22), IN46), !(IN2)), xor(xor(IN46, IN23), IN28))))) | ((((IN7 & IN47) & (IN5 & IN32)) & ((IN29 | IN13) | (true & IN42))) & ((true & (IN8 & IN29)) & (xor(xor(!(IN46), !(IN24)), xor(xor(IN6, IN16), IN4)))))), (((!(!(IN20 | IN46))) | (!(xor(xor(!(IN16), xor(xor(IN12, IN9), IN4)), IN31 | IN40)))) & IN49) & (xor(xor(IN41, (xor(xor((xor(xor(true, IN18), false)) & (xor(xor(IN10, IN15), IN4)), (!(IN14)) & IN12), (IN43 | IN32) & IN32)) & (IN31 | ((xor(xor(IN22, true), IN17)) | (xor(xor(IN49, IN20), false))))), xor(xor(!(IN45), IN46), IN2 | (xor(xor(IN11, IN2 & IN18), IN43 | IN11)))))), IN11)) | IN13) | (xor(xor(xor(xor((!((!((IN29 | IN7) & (IN48 | IN42))) | IN20)) | (!(IN21)), (xor(xor(xor(xor(xor(xor((xor(xor(IN1, IN10), IN29)) | (IN2 & IN25), xor(xor(xor(xor(IN34, IN6), IN25), IN41 & IN10), IN36 & IN25)), (IN6 & IN20) | (IN47 | IN26)), IN7), !((IN43 & IN25) | (xor(xor(IN44, IN44), IN30)))), IN15 | (IN8 & (xor(xor(xor(xor(IN3, IN16), IN33), IN3 & IN40), !(IN40))))), IN31 & IN19)) & (IN27 & (!(IN47 & (xor(xor(IN5, IN38 & IN40), IN30)))))), xor(xor(((!(!(IN24))) & (xor(xor(IN30, IN2), xor(xor(xor(xor(IN38, true), IN8), IN33 & IN9), xor(xor(IN49, IN40), IN43))))) & (((true & (xor(xor(IN49, IN36), IN7))) | ((!(IN21)) | (IN4 & IN40))) & IN47), ((((IN13 | IN3) & IN30) & (xor(xor(IN3 & IN14, !(IN41)), !(IN22)))) & ((!(IN33 | IN21)) | (!(IN18 & IN42)))) | (xor(xor((xor(xor(!(IN37), IN49 | IN14), IN42)) & (!(IN1 & IN30)), ((!(IN18)) & (xor(xor(IN28, IN28), IN42))) & (IN40 | IN32)), !(IN34 & (xor(xor(IN45, IN21), IN18)))))), xor(xor(!(!(xor(xor(IN48 | IN1, !(IN12)), !(IN27)))), ((xor(xor(IN43 | IN15, IN9 | IN20), xor(xor(IN4, IN4), IN11))) & IN35) & (IN21 | (!(IN13 & IN21)))), ((xor(xor(xor(xor(IN29, IN17), IN6), IN23 | IN2), IN46 | IN28)) & (!(IN42))) | IN9))), xor(xor(IN21, !(!(!(!((xor(xor(IN47, IN29), IN31)) & (IN3 & IN43)))))), (!((xor(xor(!(IN27 | IN39), xor(xor(xor(xor(IN1, IN14), IN16), false | IN8), IN47 | IN1)), xor(xor(IN36 & IN31, !(IN39)), IN44 | IN33))) & ((IN8 | (IN5 | IN34)) & (!(xor(xor(IN12, IN31), IN12)))))) | ((((!(xor(xor(IN45, IN8), IN46))) & IN45) & IN8) | (!(!((IN28 & IN42) & (IN50 | IN35))))))), xor(xor(IN29, !((IN34 | (IN1 | (IN12 & (IN6 | IN15)))) & ((!(!(IN32 & IN18))) & (!(!(IN6 & IN28)))))), ((!(!(IN25))) | (xor(xor(xor(xor(!(IN3 & IN34), xor(xor(IN16 & IN26, !(IN26)), IN17)), (IN33 & IN37) & (!(IN32))), ((IN38 | IN8) & (!(IN19))) | (xor(xor(!(IN29), IN4 | IN21), IN39 & IN36))), (xor(xor(IN41 | IN43, xor(xor(IN32, IN10), IN28)), IN18 & IN1)) | (IN25 & IN34)))) & IN8)))) | IN13

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
    Out := ((((((((((Data[19] XOR ((NOT (Data[48] OR Data[21])) AND (NOT ((Data[30] XOR Data[18]) XOR Data[5])))) XOR Data[21]) XOR (((((Data[23] OR Data[7]) XOR (Data[44] OR Data[43])) XOR (Data[28] AND Data[45])) AND ((NOT Data[4]) OR (Data[37] OR Data[4]))) OR ((((Data[10] OR Data[19]) OR (Data[27] AND Data[18])) XOR Data[45]) XOR (NOT Data[41])))) XOR Data[21]) AND ((((Data[36] OR FALSE) OR ((NOT Data[22]) OR ((Data[17] XOR Data[20]) XOR Data[45]))) OR ((((Data[40] XOR Data[49]) XOR Data[35]) AND (NOT Data[19])) AND ((((Data[32] XOR Data[22]) XOR Data[46]) XOR (NOT Data[2])) XOR ((Data[46] XOR Data[23]) XOR Data[28])))) OR ((((Data[7] AND Data[47]) AND (Data[5] AND Data[32])) AND ((Data[29] OR Data[13]) OR (TRUE AND Data[42]))) AND ((TRUE AND (Data[8] AND Data[29])) AND (((NOT Data[46]) XOR (NOT Data[24])) XOR ((Data[6] XOR Data[16]) XOR Data[4])))))) XOR ((((NOT (NOT (Data[20] OR Data[46]))) OR (NOT (((NOT Data[16]) XOR ((Data[12] XOR Data[9]) XOR Data[4])) XOR (Data[31] OR Data[40])))) AND Data[49]) AND ((Data[41] XOR ((((((TRUE XOR Data[18]) XOR FALSE) AND ((Data[10] XOR Data[15]) XOR Data[4])) XOR ((NOT Data[14]) AND Data[12])) XOR ((Data[43] OR Data[32]) AND Data[32])) AND (Data[31] OR (((Data[22] XOR TRUE) XOR Data[17]) OR ((Data[49] XOR Data[20]) XOR FALSE))))) XOR (((NOT Data[45]) XOR Data[46]) XOR (Data[2] OR ((Data[11] XOR (Data[2] AND Data[18])) XOR (Data[43] OR Data[11]))))))) XOR Data[11]) OR Data[13]) OR ((((((NOT ((NOT ((Data[29] OR Data[7]) AND (Data[48] OR Data[42]))) OR Data[20])) OR (NOT Data[21])) XOR ((((((((((Data[1] XOR Data[10]) XOR Data[29]) OR (Data[2] AND Data[25])) XOR ((((Data[34] XOR Data[6]) XOR Data[25]) XOR (Data[41] AND Data[10])) XOR (Data[36] AND Data[25]))) XOR ((Data[6] AND Data[20]) OR (Data[47] OR Data[26]))) XOR Data[7]) XOR (NOT ((Data[43] AND Data[25]) OR ((Data[44] XOR Data[44]) XOR Data[30])))) XOR (Data[15] OR (Data[8] AND ((((Data[3] XOR Data[16]) XOR Data[33]) XOR (Data[3] AND Data[40])) XOR (NOT Data[40]))))) XOR (Data[31] AND Data[19])) AND (Data[27] AND (NOT (Data[47] AND ((Data[5] XOR (Data[38] AND Data[40])) XOR Data[30])))))) XOR (((((NOT (NOT Data[24])) AND ((Data[30] XOR Data[2]) XOR ((((Data[38] XOR TRUE) XOR Data[8]) XOR (Data[33] AND Data[9])) XOR ((Data[49] XOR Data[40]) XOR Data[43])))) AND (((TRUE AND ((Data[49] XOR Data[36]) XOR Data[7])) OR ((NOT Data[21]) OR (Data[4] AND Data[40]))) AND Data[47])) XOR (((((Data[13] OR Data[3]) AND Data[30]) AND (((Data[3] AND Data[14]) XOR (NOT Data[41])) XOR (NOT Data[22]))) AND ((NOT (Data[33] OR Data[21])) OR (NOT (Data[18] AND Data[42])))) OR ((((((NOT Data[37]) XOR (Data[49] OR Data[14])) XOR Data[42]) AND (NOT (Data[1] AND Data[30]))) XOR (((NOT Data[18]) AND ((Data[28] XOR Data[28]) XOR Data[42])) AND (Data[40] OR Data[32]))) XOR (NOT (Data[34] AND ((Data[45] XOR Data[21]) XOR Data[18])))))) XOR (((NOT (NOT (((Data[48] OR Data[1]) XOR (NOT Data[12])) XOR (NOT Data[27])))) XOR (((((Data[43] OR Data[15]) XOR (Data[9] OR Data[20])) XOR ((Data[4] XOR Data[4]) XOR Data[11])) AND Data[35]) AND (Data[21] OR (NOT (Data[13] AND Data[21]))))) XOR ((((((Data[29] XOR Data[17]) XOR Data[6]) XOR (Data[23] OR Data[2])) XOR (Data[46] OR Data[28])) AND (NOT Data[42])) OR Data[9])))) XOR ((Data[21] XOR (NOT (NOT (NOT (NOT (((Data[47] XOR Data[29]) XOR Data[31]) AND (Data[3] AND Data[43]))))))) XOR ((NOT ((((NOT (Data[27] OR Data[39])) XOR ((((Data[1] XOR Data[14]) XOR Data[16]) XOR (FALSE OR Data[8])) XOR (Data[47] OR Data[1]))) XOR (((Data[36] AND Data[31]) XOR (NOT Data[39])) XOR (Data[44] OR Data[33]))) AND ((Data[8] OR (Data[5] OR Data[34])) AND (NOT ((Data[12] XOR Data[31]) XOR Data[12]))))) OR ((((NOT ((Data[45] XOR Data[8]) XOR Data[46])) AND Data[45]) AND Data[8]) OR (NOT (NOT ((Data[28] AND Data[42]) AND (Data[50] OR Data[35])))))))) XOR ((Data[29] XOR (NOT ((Data[34] OR (Data[1] OR (Data[12] AND (Data[6] OR Data[15])))) AND ((NOT (NOT (Data[32] AND Data[18]))) AND (NOT (NOT (Data[6] AND Data[28]))))))) XOR (((NOT (NOT Data[25])) OR (((((NOT (Data[3] AND Data[34])) XOR (((Data[16] AND Data[26]) XOR (NOT Data[26])) XOR Data[17])) XOR ((Data[33] AND Data[37]) AND (NOT Data[32]))) XOR (((Data[38] OR Data[8]) AND (NOT Data[19])) OR (((NOT Data[29]) XOR (Data[4] OR Data[21])) XOR (Data[39] AND Data[36])))) XOR ((((Data[41] OR Data[43]) XOR ((Data[32] XOR Data[10]) XOR Data[28])) XOR (Data[18] AND Data[1])) OR (Data[25] AND Data[34])))) AND Data[8])))) OR Data[13]);
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
