(*
This code implements a randomly grown symbolic expression:

(IN32 & (xor(xor((!(IN11 | ((xor(xor(IN13, !(IN3 | IN42)), !(IN34))) & IN11))) | ((!((((IN19 | IN12) & (xor(xor(IN42, IN27), IN13))) & ((!(IN24)) | (!(IN42)))) & (!(IN16)))) & IN2), ((xor(xor((xor(xor((IN17 & IN7) & (xor(xor(IN27, IN22), true)), (xor(xor(true, IN43), IN46)) | IN50), IN7)) & ((xor(xor(IN42, xor(xor(IN25, IN34), IN24)), !(IN12))) & ((IN7 | IN34) & (!(IN30)))), (xor(xor(IN14, !(IN8 | IN22)), (!(IN18)) & IN38)) & (((!(IN1)) | (!(IN7))) & ((IN10 & IN17) | false))), xor(xor(!(IN46), xor(xor((IN29 & IN48) & IN38, (xor(xor(IN11, IN9), IN22)) | (xor(xor(IN45, IN16), IN44))), (!(IN25)) | IN37)), !(xor(xor(!(IN18), xor(xor(IN29, IN45), IN27)), IN36 | IN6))))) & ((!(xor(xor(xor(xor(!(IN42), !(IN45)), xor(xor(IN2, IN30), IN11)), xor(xor(IN13 & false, IN1 & IN37), IN38 | IN33)), xor(xor(xor(xor(IN49, IN40), IN47), IN36), true)))) & ((xor(xor(xor(xor(IN35, !(IN29)), IN30), IN3), IN47 & (xor(xor(IN32, IN25), IN23)))) & (xor(xor((IN20 | IN24) & (!(IN4)), !(IN4)), (IN24 | IN5) & (IN50 | IN29)))))) | IN32), !(IN27)))) | (((!(IN34)) | ((xor(xor(((((xor(xor(IN43, IN35), IN19)) & IN1) | ((IN26 | IN10) | (IN1 & IN49))) & ((IN33 | (IN43 | IN37)) & IN42)) & ((!((IN13 | IN6) & (xor(xor(IN22, IN43), IN26)))) & (((xor(xor(IN48, IN4), IN6)) & IN39) & (!(IN17 & false)))), xor(xor(((!(!(IN12))) | IN38) & (xor(xor((IN42 & IN23) & (IN5 | IN11), xor(xor(IN28 & true, IN15), !(IN24))), (xor(xor(IN14, IN19), IN43)) | (!(IN18)))), (!(xor(xor(IN48, IN46 | IN20), !(IN37)))) | (xor(xor(IN7 | (IN16 & IN40), (xor(xor(IN30, IN26), IN26)) | (false & IN24)), (!(IN29)) & IN23))), IN12 & (!(IN37)))), ((xor(xor(xor(xor(IN5 & IN19, IN23), !(IN27)), IN23), (IN9 | IN49) | (!(IN44)))) & (!(xor(xor(!(IN34), IN4), xor(xor(false, IN6), IN47))))) | (xor(xor(xor(xor(IN10 | (!(IN13)), IN14), !(IN48 & IN32)), xor(xor(IN29, xor(xor(IN46 | IN14, IN18), IN49 & IN49)), false)), IN23 | IN23)))) & (xor(xor((xor(xor(!(xor(xor(xor(xor(IN33, IN36), IN5), IN13 & true), IN35 | IN17)), !((!(IN16)) | (xor(xor(IN3, IN11), true)))), (xor(xor(xor(xor(IN47, IN50), false), IN9 & IN29), xor(xor(IN17, IN40), IN9))) & (xor(xor(xor(xor(IN48, IN21), IN13), IN47 | IN38), IN5 | IN26)))) & IN19, IN40), !(((!(IN22 | IN28)) & ((xor(xor(IN46, IN22), IN38)) & IN20)) & (!((!(IN48)) & (IN46 & IN40)))))))) | ((!(!(IN27))) & (((!(xor(xor(IN11, xor(xor(xor(xor(xor(xor(IN22, IN25), IN30), xor(xor(IN6, IN26), IN21)), !(IN45)), xor(xor(xor(xor(IN38, IN43), IN33), IN38 & IN39), IN26 | IN30)), (IN31 | IN47) & (IN30 & IN35))), ((!(IN9)) | IN41) | ((IN19 | IN40) & (!(IN37)))))) & IN38) | IN19)))

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
    Out := ((Data[32] AND ((((NOT (Data[11] OR (((Data[13] XOR (NOT (Data[3] OR Data[42]))) XOR (NOT Data[34])) AND Data[11]))) OR ((NOT ((((Data[19] OR Data[12]) AND ((Data[42] XOR Data[27]) XOR Data[13])) AND ((NOT Data[24]) OR (NOT Data[42]))) AND (NOT Data[16]))) AND Data[2])) XOR (((((((((Data[17] AND Data[7]) AND ((Data[27] XOR Data[22]) XOR TRUE)) XOR (((TRUE XOR Data[43]) XOR Data[46]) OR Data[50])) XOR Data[7]) AND (((Data[42] XOR ((Data[25] XOR Data[34]) XOR Data[24])) XOR (NOT Data[12])) AND ((Data[7] OR Data[34]) AND (NOT Data[30])))) XOR (((Data[14] XOR (NOT (Data[8] OR Data[22]))) XOR ((NOT Data[18]) AND Data[38])) AND (((NOT Data[1]) OR (NOT Data[7])) AND ((Data[10] AND Data[17]) OR FALSE)))) XOR (((NOT Data[46]) XOR ((((Data[29] AND Data[48]) AND Data[38]) XOR (((Data[11] XOR Data[9]) XOR Data[22]) OR ((Data[45] XOR Data[16]) XOR Data[44]))) XOR ((NOT Data[25]) OR Data[37]))) XOR (NOT (((NOT Data[18]) XOR ((Data[29] XOR Data[45]) XOR Data[27])) XOR (Data[36] OR Data[6]))))) AND ((NOT (((((NOT Data[42]) XOR (NOT Data[45])) XOR ((Data[2] XOR Data[30]) XOR Data[11])) XOR (((Data[13] AND FALSE) XOR (Data[1] AND Data[37])) XOR (Data[38] OR Data[33]))) XOR ((((Data[49] XOR Data[40]) XOR Data[47]) XOR Data[36]) XOR TRUE))) AND (((((Data[35] XOR (NOT Data[29])) XOR Data[30]) XOR Data[3]) XOR (Data[47] AND ((Data[32] XOR Data[25]) XOR Data[23]))) AND ((((Data[20] OR Data[24]) AND (NOT Data[4])) XOR (NOT Data[4])) XOR ((Data[24] OR Data[5]) AND (Data[50] OR Data[29])))))) OR Data[32])) XOR (NOT Data[27]))) OR (((NOT Data[34]) OR (((((((((Data[43] XOR Data[35]) XOR Data[19]) AND Data[1]) OR ((Data[26] OR Data[10]) OR (Data[1] AND Data[49]))) AND ((Data[33] OR (Data[43] OR Data[37])) AND Data[42])) AND ((NOT ((Data[13] OR Data[6]) AND ((Data[22] XOR Data[43]) XOR Data[26]))) AND ((((Data[48] XOR Data[4]) XOR Data[6]) AND Data[39]) AND (NOT (Data[17] AND FALSE))))) XOR (((((NOT (NOT Data[12])) OR Data[38]) AND ((((Data[42] AND Data[23]) AND (Data[5] OR Data[11])) XOR (((Data[28] AND TRUE) XOR Data[15]) XOR (NOT Data[24]))) XOR (((Data[14] XOR Data[19]) XOR Data[43]) OR (NOT Data[18])))) XOR ((NOT ((Data[48] XOR (Data[46] OR Data[20])) XOR (NOT Data[37]))) OR (((Data[7] OR (Data[16] AND Data[40])) XOR (((Data[30] XOR Data[26]) XOR Data[26]) OR (FALSE AND Data[24]))) XOR ((NOT Data[29]) AND Data[23])))) XOR (Data[12] AND (NOT Data[37])))) XOR (((((((Data[5] AND Data[19]) XOR Data[23]) XOR (NOT Data[27])) XOR Data[23]) XOR ((Data[9] OR Data[49]) OR (NOT Data[44]))) AND (NOT (((NOT Data[34]) XOR Data[4]) XOR ((FALSE XOR Data[6]) XOR Data[47])))) OR (((((Data[10] OR (NOT Data[13])) XOR Data[14]) XOR (NOT (Data[48] AND Data[32]))) XOR ((Data[29] XOR (((Data[46] OR Data[14]) XOR Data[18]) XOR (Data[49] AND Data[49]))) XOR FALSE)) XOR (Data[23] OR Data[23])))) AND ((((((NOT ((((Data[33] XOR Data[36]) XOR Data[5]) XOR (Data[13] AND TRUE)) XOR (Data[35] OR Data[17]))) XOR (NOT ((NOT Data[16]) OR ((Data[3] XOR Data[11]) XOR TRUE)))) XOR (((((Data[47] XOR Data[50]) XOR FALSE) XOR (Data[9] AND Data[29])) XOR ((Data[17] XOR Data[40]) XOR Data[9])) AND ((((Data[48] XOR Data[21]) XOR Data[13]) XOR (Data[47] OR Data[38])) XOR (Data[5] OR Data[26])))) AND Data[19]) XOR Data[40]) XOR (NOT (((NOT (Data[22] OR Data[28])) AND (((Data[46] XOR Data[22]) XOR Data[38]) AND Data[20])) AND (NOT ((NOT Data[48]) AND (Data[46] AND Data[40])))))))) OR ((NOT (NOT Data[27])) AND (((NOT ((Data[11] XOR ((((((Data[22] XOR Data[25]) XOR Data[30]) XOR ((Data[6] XOR Data[26]) XOR Data[21])) XOR (NOT Data[45])) XOR ((((Data[38] XOR Data[43]) XOR Data[33]) XOR (Data[38] AND Data[39])) XOR (Data[26] OR Data[30]))) XOR ((Data[31] OR Data[47]) AND (Data[30] AND Data[35])))) XOR (((NOT Data[9]) OR Data[41]) OR ((Data[19] OR Data[40]) AND (NOT Data[37]))))) AND Data[38]) OR Data[19]))));
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
