(*
This code implements a randomly grown symbolic expression:

((((xor(xor((!(!(xor(xor(IN29 | IN28, IN36), IN43 | IN8)))) & ((((xor(xor(IN27, IN14), IN33)) & (xor(xor(IN48, IN39), IN30))) | (IN41 | (xor(xor(false, IN35), IN14)))) & ((xor(xor(IN31, IN4 & IN24), IN26)) & (xor(xor(IN3 & IN41, !(IN32)), IN4 & IN8)))), !(IN48)), ((!(!(IN1 & IN47))) | IN45) | (IN26 & ((true | (xor(xor(IN20, IN1), IN45))) | ((xor(xor(false, IN37), IN14)) | (IN19 & IN30)))))) | IN41) | (xor(xor((IN9 | (xor(xor(!((xor(xor(IN13, false), IN29)) & (IN18 | IN23)), (xor(xor(IN33 | IN25, !(IN41)), xor(xor(IN43, IN27), IN33))) & ((true | IN30) | (IN19 | IN42))), true & (xor(xor(IN38 | IN12, xor(xor(IN10, false), IN5)), IN16 & IN45))))) & IN40, IN44), !(!(!((!(IN8 | IN20)) & IN38)))))) & (xor(xor((!(!(!(!((IN37 & IN4) & (xor(xor(IN34, false), false))))))) | (((!(!((IN48 | IN10) & (IN45 & IN23)))) & ((!(!(!(IN49)))) | true)) & (xor(xor((xor(xor((!(IN33)) | (IN25 | IN11), IN7), IN37)) & ((!(IN24 & IN11)) | (xor(xor(IN27 | IN38, IN13), false))), xor(xor(IN36, IN31), (xor(xor(true, IN42), !(IN15))) | ((IN6 | IN45) | (IN36 | IN4)))), IN11))), !(!(((xor(xor(IN20 | (!(IN38)), xor(xor(IN50 | IN24, IN46 | IN36), !(IN40))), (IN49 | IN28) & (xor(xor(IN1, IN12), IN31)))) | (!(IN18))) & (!(IN21 & ((xor(xor(IN1, IN6), IN21)) & (!(IN41)))))))), true))) & (!((((IN7 | (xor(xor(((xor(xor(IN10, IN19), IN23)) & (xor(xor(IN1, IN21), IN36))) & (!(xor(xor(IN44, IN49), IN18))), IN32), IN47))) & (((IN4 & (!(IN44))) | false) & (!(IN47)))) & (xor(xor(xor(xor(((xor(xor(IN46, IN15 | IN27), IN46 & IN21)) | (xor(xor(xor(xor(IN31, IN24), IN28), xor(xor(IN1, IN25), IN11)), xor(xor(IN4, true), IN19)))) & IN27, IN46), !(((IN19 & IN18) & (!(IN14))) | ((xor(xor(IN2, IN6), IN21)) & IN40))), (xor(xor(xor(xor(xor(xor(!(IN12), IN39 | IN10), !(IN37)), xor(xor(xor(xor(true, IN48), IN48), xor(xor(IN2, IN29), IN49)), IN25 | IN31)), xor(xor(IN42 & IN17, IN30 | IN2), IN43)), xor(xor((IN43 | IN20) | (IN35 | IN17), (!(IN43)) & (xor(xor(IN3, IN36), IN10))), !(IN47 & IN47))), xor(xor(xor(xor(IN11 | IN13, !(IN43)), xor(xor(IN39, IN17), IN39)), xor(xor(xor(xor(IN42, IN45), IN22), !(IN24)), xor(xor(IN29, IN18), IN50))), !(IN43 & IN18)))) & (((!(!(IN42))) & (xor(xor(false, IN15 | IN35), xor(xor(IN5, IN14), IN47)))) & (!(IN32)))), ((xor(xor((xor(xor(IN13, IN12), IN19)) & (IN35 | IN49), xor(xor(xor(xor(IN15, IN39), IN44), IN36), IN12)), xor(xor(!(IN34), IN4 | true), xor(xor(IN30, IN43), IN22)))) & IN18) | ((!((IN26 & IN23) & IN34)) | ((xor(xor(IN3 | IN31, xor(xor(IN34, IN44), IN20)), xor(xor(IN15, IN38), IN47))) & (!(IN22))))))) & (xor(xor((!((xor(xor(xor(xor(!(IN14), !(IN12)), !(IN33)), xor(xor(IN3, xor(xor(IN43, IN21), IN10)), xor(xor(IN38, IN46), IN29))), IN39)) & (((xor(xor(IN17, IN6), IN11)) | (xor(xor(IN32, IN41), IN31))) & (xor(xor(IN39 & IN5, true), !(IN5)))))) | (!(IN33)), xor(xor(IN49 | ((((IN25 & IN33) | (IN12 & IN39)) | ((xor(xor(IN30, IN11), IN41)) | IN22)) | (((!(IN36)) & (false & IN25)) | (xor(xor(IN18 | IN14, IN36), IN7 | IN49)))), !(IN50)), ((!(!(IN28))) & (!(!(IN49 & IN47)))) & IN50)), IN21))))

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
    Out := ((((((((NOT (NOT (((Data[29] OR Data[28]) XOR Data[36]) XOR (Data[43] OR Data[8])))) AND (((((Data[27] XOR Data[14]) XOR Data[33]) AND ((Data[48] XOR Data[39]) XOR Data[30])) OR (Data[41] OR ((FALSE XOR Data[35]) XOR Data[14]))) AND (((Data[31] XOR (Data[4] AND Data[24])) XOR Data[26]) AND (((Data[3] AND Data[41]) XOR (NOT Data[32])) XOR (Data[4] AND Data[8]))))) XOR (NOT Data[48])) XOR (((NOT (NOT (Data[1] AND Data[47]))) OR Data[45]) OR (Data[26] AND ((TRUE OR ((Data[20] XOR Data[1]) XOR Data[45])) OR (((FALSE XOR Data[37]) XOR Data[14]) OR (Data[19] AND Data[30])))))) OR Data[41]) OR ((((Data[9] OR (((NOT (((Data[13] XOR FALSE) XOR Data[29]) AND (Data[18] OR Data[23]))) XOR ((((Data[33] OR Data[25]) XOR (NOT Data[41])) XOR ((Data[43] XOR Data[27]) XOR Data[33])) AND ((TRUE OR Data[30]) OR (Data[19] OR Data[42])))) XOR (TRUE AND (((Data[38] OR Data[12]) XOR ((Data[10] XOR FALSE) XOR Data[5])) XOR (Data[16] AND Data[45]))))) AND Data[40]) XOR Data[44]) XOR (NOT (NOT (NOT ((NOT (Data[8] OR Data[20])) AND Data[38])))))) AND ((((NOT (NOT (NOT (NOT ((Data[37] AND Data[4]) AND ((Data[34] XOR FALSE) XOR FALSE)))))) OR (((NOT (NOT ((Data[48] OR Data[10]) AND (Data[45] AND Data[23])))) AND ((NOT (NOT (NOT Data[49]))) OR TRUE)) AND (((((((NOT Data[33]) OR (Data[25] OR Data[11])) XOR Data[7]) XOR Data[37]) AND ((NOT (Data[24] AND Data[11])) OR (((Data[27] OR Data[38]) XOR Data[13]) XOR FALSE))) XOR ((Data[36] XOR Data[31]) XOR (((TRUE XOR Data[42]) XOR (NOT Data[15])) OR ((Data[6] OR Data[45]) OR (Data[36] OR Data[4]))))) XOR Data[11]))) XOR (NOT (NOT (((((Data[20] OR (NOT Data[38])) XOR (((Data[50] OR Data[24]) XOR (Data[46] OR Data[36])) XOR (NOT Data[40]))) XOR ((Data[49] OR Data[28]) AND ((Data[1] XOR Data[12]) XOR Data[31]))) OR (NOT Data[18])) AND (NOT (Data[21] AND (((Data[1] XOR Data[6]) XOR Data[21]) AND (NOT Data[41])))))))) XOR TRUE)) AND (NOT ((((Data[7] OR ((((((Data[10] XOR Data[19]) XOR Data[23]) AND ((Data[1] XOR Data[21]) XOR Data[36])) AND (NOT ((Data[44] XOR Data[49]) XOR Data[18]))) XOR Data[32]) XOR Data[47])) AND (((Data[4] AND (NOT Data[44])) OR FALSE) AND (NOT Data[47]))) AND ((((((((Data[46] XOR (Data[15] OR Data[27])) XOR (Data[46] AND Data[21])) OR ((((Data[31] XOR Data[24]) XOR Data[28]) XOR ((Data[1] XOR Data[25]) XOR Data[11])) XOR ((Data[4] XOR TRUE) XOR Data[19]))) AND Data[27]) XOR Data[46]) XOR (NOT (((Data[19] AND Data[18]) AND (NOT Data[14])) OR (((Data[2] XOR Data[6]) XOR Data[21]) AND Data[40])))) XOR ((((((((NOT Data[12]) XOR (Data[39] OR Data[10])) XOR (NOT Data[37])) XOR ((((TRUE XOR Data[48]) XOR Data[48]) XOR ((Data[2] XOR Data[29]) XOR Data[49])) XOR (Data[25] OR Data[31]))) XOR (((Data[42] AND Data[17]) XOR (Data[30] OR Data[2])) XOR Data[43])) XOR ((((Data[43] OR Data[20]) OR (Data[35] OR Data[17])) XOR ((NOT Data[43]) AND ((Data[3] XOR Data[36]) XOR Data[10]))) XOR (NOT (Data[47] AND Data[47])))) XOR (((((Data[11] OR Data[13]) XOR (NOT Data[43])) XOR ((Data[39] XOR Data[17]) XOR Data[39])) XOR ((((Data[42] XOR Data[45]) XOR Data[22]) XOR (NOT Data[24])) XOR ((Data[29] XOR Data[18]) XOR Data[50]))) XOR (NOT (Data[43] AND Data[18])))) AND (((NOT (NOT Data[42])) AND ((FALSE XOR (Data[15] OR Data[35])) XOR ((Data[5] XOR Data[14]) XOR Data[47]))) AND (NOT Data[32])))) XOR (((((((Data[13] XOR Data[12]) XOR Data[19]) AND (Data[35] OR Data[49])) XOR ((((Data[15] XOR Data[39]) XOR Data[44]) XOR Data[36]) XOR Data[12])) XOR (((NOT Data[34]) XOR (Data[4] OR TRUE)) XOR ((Data[30] XOR Data[43]) XOR Data[22]))) AND Data[18]) OR ((NOT ((Data[26] AND Data[23]) AND Data[34])) OR ((((Data[3] OR Data[31]) XOR ((Data[34] XOR Data[44]) XOR Data[20])) XOR ((Data[15] XOR Data[38]) XOR Data[47])) AND (NOT Data[22])))))) AND ((((NOT ((((((NOT Data[14]) XOR (NOT Data[12])) XOR (NOT Data[33])) XOR ((Data[3] XOR ((Data[43] XOR Data[21]) XOR Data[10])) XOR ((Data[38] XOR Data[46]) XOR Data[29]))) XOR Data[39]) AND ((((Data[17] XOR Data[6]) XOR Data[11]) OR ((Data[32] XOR Data[41]) XOR Data[31])) AND (((Data[39] AND Data[5]) XOR TRUE) XOR (NOT Data[5]))))) OR (NOT Data[33])) XOR (((Data[49] OR ((((Data[25] AND Data[33]) OR (Data[12] AND Data[39])) OR (((Data[30] XOR Data[11]) XOR Data[41]) OR Data[22])) OR (((NOT Data[36]) AND (FALSE AND Data[25])) OR (((Data[18] OR Data[14]) XOR Data[36]) XOR (Data[7] OR Data[49]))))) XOR (NOT Data[50])) XOR (((NOT (NOT Data[28])) AND (NOT (NOT (Data[49] AND Data[47])))) AND Data[50]))) XOR Data[21]))));
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
