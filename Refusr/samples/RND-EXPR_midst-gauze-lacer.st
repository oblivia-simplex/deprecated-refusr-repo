(*
This code implements a randomly grown symbolic expression:

(!(xor(xor(xor(xor(IN4, IN14), IN32 & ((xor(xor(true, IN23), ((!(IN31)) & (IN21 & IN2)) & IN4)) | IN15)), ((!((xor(xor(IN10, !(IN22 | false)), (xor(xor(IN19, false), IN39)) | (xor(xor(IN50, IN43), IN25)))) | (xor(xor((IN43 | IN12) & (IN48 | IN12), (false & IN12) & IN36), xor(xor(xor(xor(IN8, IN14), IN49), xor(xor(IN10, IN6), IN8)), IN40 & false))))) & (IN23 | ((((IN13 & IN26) | (!(IN33))) | ((!(IN41)) | (IN5 | IN16))) & (!(!(IN32 & IN47)))))) | ((IN24 & (!(!((!(IN20)) | (xor(xor(IN18, IN25), IN29)))))) & IN36)), xor(xor(!(IN39), (((xor(xor(xor(xor(IN11 | IN50, xor(xor(IN49, IN22), IN6)), !(IN21)), !(IN26 | IN40)), (!(IN40)) | IN15)) | (!((IN42 & IN6) & IN14))) & (IN19 & (((IN11 | IN42) | (!(IN36))) & ((IN31 & IN38) & (IN4 & IN20))))) | (((xor(xor((IN39 | IN6) & IN28, (IN43 | IN26) & (IN20 & IN5)), IN25 & (!(IN7)))) | IN34) & ((xor(xor(IN44, !(IN42 | IN15)), xor(xor(IN13 & IN35, IN38 & IN49), IN3 & IN47))) | (!(IN32))))), (!((!(IN45 | (xor(xor(IN25, IN17), IN7)))) | (!((xor(xor(IN6, IN12), IN22)) | (IN27 & IN49))))) & IN20)))) | ((!(IN6)) | (xor(xor((((xor(xor(((xor(xor(IN20, IN3), IN24)) & (!(IN29))) & (xor(xor(IN48 & IN19, xor(xor(IN39, IN26), IN12)), IN20 | IN33)), (IN29 & (xor(xor(IN21, IN47), IN10))) & (!(xor(xor(IN23, IN10), IN45)))), ((!(IN5)) | (!(IN35))) | (!(IN17 | IN44)))) | IN18) | (IN21 & (!(IN4 & IN41)))) & IN42, xor(xor((xor(xor(!(((xor(xor(IN4, IN15), IN42)) | (IN8 | IN5)) | (!(IN25 | IN47))), ((!(xor(xor(IN49, IN22), IN5))) & (xor(xor(IN48, !(IN44)), IN8))) | ((xor(xor(IN24 | IN31, IN42 & IN43), xor(xor(IN47, IN50), IN41))) & (IN25 & (IN20 & IN48)))), xor(xor(((true | IN6) & (!(IN30))) | ((xor(xor(IN15, IN30), IN12)) & (true | IN37)), IN3), xor(xor(xor(xor(false, IN32 & IN50), IN17 | IN37), (IN27 & IN27) & (IN18 | IN25)), IN40 | (IN12 & IN33))))) | (((IN36 & ((IN1 & IN8) | (IN17 | IN48))) | (!(xor(xor(IN32 & IN41, xor(xor(IN28, IN7), IN46)), IN14)))) | IN3), !(((xor(xor(xor(xor(!(IN9), IN40 & IN45), IN33), !(IN39)), IN43)) | ((xor(xor(IN48, IN34 | IN14), IN49 & IN3)) & (IN24 | (IN2 & true)))) | ((xor(xor(IN47, !(IN38)), !(IN13 | IN17))) | (!((xor(xor(IN20, IN32), IN40)) | (!(IN19))))))), (((IN22 | ((IN31 | IN11) & (xor(xor(IN35, false), IN47)))) & (((!(IN22)) & (xor(xor(IN2, IN33), IN45))) & (xor(xor(xor(xor(true, IN46), IN10), IN14 & IN41), IN5 & IN8)))) | (xor(xor(!(IN45), xor(xor(IN49, xor(xor(!(IN36), xor(xor(IN9, IN23), IN26)), IN29 & IN47)), (xor(xor(IN30, IN40), IN49)) & (IN15 & IN42))), (!(IN22 | IN25)) | ((!(IN8)) | (!(IN42)))))) & IN39)), (IN8 | (((((!(IN5)) & (IN44 & IN27)) | ((!(IN43)) | (IN42 & IN17))) & ((xor(xor(IN20 & IN46, IN36), !(IN6))) | ((xor(xor(IN45, false), IN40)) | (!(IN24))))) | (!(((IN13 | IN49) | (true & IN16)) & IN3)))) & ((!(!((!(IN16 & IN1)) | (xor(xor(IN33, xor(xor(IN6, IN28), IN2)), xor(xor(IN31, IN19), IN26)))))) & (IN40 | false)))))

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
    Out := ((NOT ((((Data[4] XOR Data[14]) XOR (Data[32] AND (((TRUE XOR Data[23]) XOR (((NOT Data[31]) AND (Data[21] AND Data[2])) AND Data[4])) OR Data[15]))) XOR (((NOT (((Data[10] XOR (NOT (Data[22] OR FALSE))) XOR (((Data[19] XOR FALSE) XOR Data[39]) OR ((Data[50] XOR Data[43]) XOR Data[25]))) OR ((((Data[43] OR Data[12]) AND (Data[48] OR Data[12])) XOR ((FALSE AND Data[12]) AND Data[36])) XOR ((((Data[8] XOR Data[14]) XOR Data[49]) XOR ((Data[10] XOR Data[6]) XOR Data[8])) XOR (Data[40] AND FALSE))))) AND (Data[23] OR ((((Data[13] AND Data[26]) OR (NOT Data[33])) OR ((NOT Data[41]) OR (Data[5] OR Data[16]))) AND (NOT (NOT (Data[32] AND Data[47])))))) OR ((Data[24] AND (NOT (NOT ((NOT Data[20]) OR ((Data[18] XOR Data[25]) XOR Data[29]))))) AND Data[36]))) XOR (((NOT Data[39]) XOR ((((((((Data[11] OR Data[50]) XOR ((Data[49] XOR Data[22]) XOR Data[6])) XOR (NOT Data[21])) XOR (NOT (Data[26] OR Data[40]))) XOR ((NOT Data[40]) OR Data[15])) OR (NOT ((Data[42] AND Data[6]) AND Data[14]))) AND (Data[19] AND (((Data[11] OR Data[42]) OR (NOT Data[36])) AND ((Data[31] AND Data[38]) AND (Data[4] AND Data[20]))))) OR ((((((Data[39] OR Data[6]) AND Data[28]) XOR ((Data[43] OR Data[26]) AND (Data[20] AND Data[5]))) XOR (Data[25] AND (NOT Data[7]))) OR Data[34]) AND (((Data[44] XOR (NOT (Data[42] OR Data[15]))) XOR (((Data[13] AND Data[35]) XOR (Data[38] AND Data[49])) XOR (Data[3] AND Data[47]))) OR (NOT Data[32]))))) XOR ((NOT ((NOT (Data[45] OR ((Data[25] XOR Data[17]) XOR Data[7]))) OR (NOT (((Data[6] XOR Data[12]) XOR Data[22]) OR (Data[27] AND Data[49]))))) AND Data[20])))) OR ((NOT Data[6]) OR (((((((((((Data[20] XOR Data[3]) XOR Data[24]) AND (NOT Data[29])) AND (((Data[48] AND Data[19]) XOR ((Data[39] XOR Data[26]) XOR Data[12])) XOR (Data[20] OR Data[33]))) XOR ((Data[29] AND ((Data[21] XOR Data[47]) XOR Data[10])) AND (NOT ((Data[23] XOR Data[10]) XOR Data[45])))) XOR (((NOT Data[5]) OR (NOT Data[35])) OR (NOT (Data[17] OR Data[44])))) OR Data[18]) OR (Data[21] AND (NOT (Data[4] AND Data[41])))) AND Data[42]) XOR ((((((NOT ((((Data[4] XOR Data[15]) XOR Data[42]) OR (Data[8] OR Data[5])) OR (NOT (Data[25] OR Data[47])))) XOR (((NOT ((Data[49] XOR Data[22]) XOR Data[5])) AND ((Data[48] XOR (NOT Data[44])) XOR Data[8])) OR ((((Data[24] OR Data[31]) XOR (Data[42] AND Data[43])) XOR ((Data[47] XOR Data[50]) XOR Data[41])) AND (Data[25] AND (Data[20] AND Data[48]))))) XOR (((((TRUE OR Data[6]) AND (NOT Data[30])) OR (((Data[15] XOR Data[30]) XOR Data[12]) AND (TRUE OR Data[37]))) XOR Data[3]) XOR ((((FALSE XOR (Data[32] AND Data[50])) XOR (Data[17] OR Data[37])) XOR ((Data[27] AND Data[27]) AND (Data[18] OR Data[25]))) XOR (Data[40] OR (Data[12] AND Data[33]))))) OR (((Data[36] AND ((Data[1] AND Data[8]) OR (Data[17] OR Data[48]))) OR (NOT (((Data[32] AND Data[41]) XOR ((Data[28] XOR Data[7]) XOR Data[46])) XOR Data[14]))) OR Data[3])) XOR (NOT (((((((NOT Data[9]) XOR (Data[40] AND Data[45])) XOR Data[33]) XOR (NOT Data[39])) XOR Data[43]) OR (((Data[48] XOR (Data[34] OR Data[14])) XOR (Data[49] AND Data[3])) AND (Data[24] OR (Data[2] AND TRUE)))) OR (((Data[47] XOR (NOT Data[38])) XOR (NOT (Data[13] OR Data[17]))) OR (NOT (((Data[20] XOR Data[32]) XOR Data[40]) OR (NOT Data[19]))))))) XOR ((((Data[22] OR ((Data[31] OR Data[11]) AND ((Data[35] XOR FALSE) XOR Data[47]))) AND (((NOT Data[22]) AND ((Data[2] XOR Data[33]) XOR Data[45])) AND ((((TRUE XOR Data[46]) XOR Data[10]) XOR (Data[14] AND Data[41])) XOR (Data[5] AND Data[8])))) OR (((NOT Data[45]) XOR ((Data[49] XOR (((NOT Data[36]) XOR ((Data[9] XOR Data[23]) XOR Data[26])) XOR (Data[29] AND Data[47]))) XOR (((Data[30] XOR Data[40]) XOR Data[49]) AND (Data[15] AND Data[42])))) XOR ((NOT (Data[22] OR Data[25])) OR ((NOT Data[8]) OR (NOT Data[42]))))) AND Data[39]))) XOR ((Data[8] OR (((((NOT Data[5]) AND (Data[44] AND Data[27])) OR ((NOT Data[43]) OR (Data[42] AND Data[17]))) AND ((((Data[20] AND Data[46]) XOR Data[36]) XOR (NOT Data[6])) OR (((Data[45] XOR FALSE) XOR Data[40]) OR (NOT Data[24])))) OR (NOT (((Data[13] OR Data[49]) OR (TRUE AND Data[16])) AND Data[3])))) AND ((NOT (NOT ((NOT (Data[16] AND Data[1])) OR ((Data[33] XOR ((Data[6] XOR Data[28]) XOR Data[2])) XOR ((Data[31] XOR Data[19]) XOR Data[26]))))) AND (Data[40] OR FALSE))))));
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
