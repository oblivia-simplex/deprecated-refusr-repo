(*
This code implements a randomly grown symbolic expression:

(((((xor(xor((((IN14 | IN26) & (xor(xor(IN30, IN38), IN29))) | (xor(xor(IN43 | IN33, !(IN21)), IN49 | IN20))) & ((xor(xor(!(IN35), IN36), IN43 | IN5)) & (xor(xor(IN25 | IN20, IN28), !(IN27)))), (!(IN29)) | (!(true | (xor(xor(IN14, IN30), IN3))))), IN13)) | IN18) & ((xor(xor(xor(xor(IN43, !(IN44)), IN27), (!((!(IN48)) | false)) | (((!(IN39)) & (!(IN38))) | ((xor(xor(IN39, IN38), IN15)) & (xor(xor(IN18, IN2), IN41))))), (xor(xor(xor(xor(IN49 & IN31, xor(xor(IN13, IN22), IN6)), IN4 | IN40), (IN3 | IN27) | (!(IN6))), (xor(xor(IN22, IN8), IN42)) & (!(IN42)))) | ((xor(xor(xor(xor(IN12, IN36), IN50), !(IN14)), IN17 & IN37)) & true))) | true)) & (!(xor(xor((xor(xor(xor(xor(xor(xor(IN24 | IN1, IN3), IN17), xor(xor(IN50 | IN18, IN19), xor(xor(IN29, IN28), IN4))), (IN18 | false) | IN25), ((!(IN15)) & (!(IN2))) & IN4), xor(xor(IN33, (IN44 & IN37) & (xor(xor(IN49, IN7), IN25))), IN18))) & ((true & (!(IN11 & IN43))) & (((IN32 & IN13) & (xor(xor(IN12, IN19), false))) & true)), xor(xor((xor(xor((false | IN32) | (!(IN14)), (!(IN12)) & (xor(xor(IN49, IN4), true))), IN34)) | IN15, xor(xor(IN15, ((xor(xor(IN41, IN12), IN20)) | (xor(xor(IN21, IN44), IN18))) & (xor(xor(IN33 & IN12, IN25), xor(xor(IN1, IN19), true)))), xor(xor((IN49 | IN9) & (IN31 & false), !(IN49 | IN19)), (xor(xor(IN13, IN7), IN4)) | (true & IN34)))), xor(xor(xor(xor(IN15, (IN36 & IN11) & (xor(xor(IN46, IN33), IN2))), (xor(xor(IN29, IN36), false)) & (IN24 & IN12)), !(xor(xor(false & IN10, IN15), xor(xor(IN25, IN11), IN19)))), !(!(!(IN22)))))), IN14)))) & ((xor(xor(IN33 & IN5, xor(xor((!(xor(xor(xor(xor(!(IN34), !(IN15)), !(IN35)), !(IN7 | IN43)), xor(xor(!(IN45), IN23 | IN36), IN33 & IN5)))) & IN42, !(IN14)), (!(!(!(xor(xor(IN24, IN40), IN46))))) | IN22)), xor(xor(((((IN14 | IN48) | (xor(xor(IN38, IN48), IN19))) | IN42) | (((xor(xor(IN10, IN38), IN50)) | IN28) & (!(!(IN40))))) & IN30, IN41), ((!((IN11 & IN11) | (xor(xor(IN38, IN32), IN19)))) & ((!(IN44 & IN44)) | ((xor(xor(IN37, IN46), IN40)) & (!(IN19))))) & ((!(xor(xor(IN46, xor(xor(IN39, IN2), IN24)), xor(xor(IN1, IN43), IN50)))) & (((xor(xor(IN25, IN2), IN29)) | (IN34 & IN12)) & ((!(IN2)) & (xor(xor(IN14, IN33), IN13)))))))) & ((((((IN10 | (true | IN33)) & ((xor(xor(IN18, IN28), IN25)) & (!(IN25)))) & ((xor(xor(!(IN36), true | IN1), IN20)) & ((xor(xor(IN26, IN12), IN37)) | (false & IN15)))) & (((xor(xor(xor(xor(IN31, IN27), IN42), IN40 & IN2), IN42 & IN24)) & (xor(xor(IN47 | IN36, !(IN29)), IN2 | IN41))) & IN42)) | (xor(xor(xor(xor(!(!(IN9 & IN36)), !(xor(xor(IN16, IN28), IN32 | true))), ((xor(xor(IN10, IN24), IN46)) | (!(IN45))) & (!(IN37 & IN12))), (xor(xor(xor(xor(xor(xor(IN6, IN13), IN48), IN32 & IN7), xor(xor(IN34, IN19), IN46)), IN47), IN14 & (xor(xor(IN23, IN44), IN42)))) | IN35), (((IN8 & false) & (IN14 & IN20)) & IN19) | IN39))) & IN18))) | ((IN44 & true) & ((xor(xor((!(!(IN2 | ((xor(xor(IN32, IN15), IN7)) | (xor(xor(IN30, IN15), IN20)))))) & IN48, (xor(xor(((!(IN37)) & (!(xor(xor(IN36, IN13), IN21)))) & (IN7 & IN39), (!(IN13)) & (xor(xor(!(!(IN7)), IN34), false | (IN6 & IN16)))), (((IN41 & IN45) & (IN28 | IN39)) | (!(IN15 & IN38))) & (xor(xor(IN36, (IN48 | IN18) & (IN18 & IN20)), (xor(xor(IN47, IN26), IN11)) | (!(IN27)))))) & IN12), IN20)) | (((xor(xor(IN40, xor(xor(((IN7 & IN24) | (xor(xor(IN32, IN26), IN16))) | IN23, xor(xor(IN39 & (IN45 | IN19), xor(xor(xor(xor(IN41, IN17), IN4), xor(xor(IN6, IN46), IN22)), false & IN3)), (xor(xor(IN22, IN17), IN47)) | (!(IN15)))), !((xor(xor(IN25, IN5), IN24)) | (IN3 | IN29)))), (IN3 & (!(IN43))) & IN21)) & ((!(xor(xor((xor(xor(IN32, IN39), IN15)) & (!(IN21)), (IN37 | IN20) & (!(IN31))), xor(xor(IN25, IN28 & IN16), IN4 | IN17)))) & (!((xor(xor(xor(xor(IN31, IN25), IN5), xor(xor(IN1, IN10), IN50)), !(IN18))) | ((!(IN18)) | IN34))))) | (IN33 | ((!(((IN23 & IN13) & (IN3 | IN11)) & ((xor(xor(IN6, IN14), IN29)) | (IN20 | IN44)))) | (!(IN24 | ((xor(xor(IN28, IN29), IN10)) & (!(IN27))))))))))

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
    Out := (((((((((((Data[14] OR Data[26]) AND ((Data[30] XOR Data[38]) XOR Data[29])) OR (((Data[43] OR Data[33]) XOR (NOT Data[21])) XOR (Data[49] OR Data[20]))) AND ((((NOT Data[35]) XOR Data[36]) XOR (Data[43] OR Data[5])) AND (((Data[25] OR Data[20]) XOR Data[28]) XOR (NOT Data[27])))) XOR ((NOT Data[29]) OR (NOT (TRUE OR ((Data[14] XOR Data[30]) XOR Data[3]))))) XOR Data[13]) OR Data[18]) AND (((((Data[43] XOR (NOT Data[44])) XOR Data[27]) XOR ((NOT ((NOT Data[48]) OR FALSE)) OR (((NOT Data[39]) AND (NOT Data[38])) OR (((Data[39] XOR Data[38]) XOR Data[15]) AND ((Data[18] XOR Data[2]) XOR Data[41]))))) XOR ((((((Data[49] AND Data[31]) XOR ((Data[13] XOR Data[22]) XOR Data[6])) XOR (Data[4] OR Data[40])) XOR ((Data[3] OR Data[27]) OR (NOT Data[6]))) XOR (((Data[22] XOR Data[8]) XOR Data[42]) AND (NOT Data[42]))) OR (((((Data[12] XOR Data[36]) XOR Data[50]) XOR (NOT Data[14])) XOR (Data[17] AND Data[37])) AND TRUE))) OR TRUE)) AND (NOT ((((((((((Data[24] OR Data[1]) XOR Data[3]) XOR Data[17]) XOR (((Data[50] OR Data[18]) XOR Data[19]) XOR ((Data[29] XOR Data[28]) XOR Data[4]))) XOR ((Data[18] OR FALSE) OR Data[25])) XOR (((NOT Data[15]) AND (NOT Data[2])) AND Data[4])) XOR ((Data[33] XOR ((Data[44] AND Data[37]) AND ((Data[49] XOR Data[7]) XOR Data[25]))) XOR Data[18])) AND ((TRUE AND (NOT (Data[11] AND Data[43]))) AND (((Data[32] AND Data[13]) AND ((Data[12] XOR Data[19]) XOR FALSE)) AND TRUE))) XOR (((((((FALSE OR Data[32]) OR (NOT Data[14])) XOR ((NOT Data[12]) AND ((Data[49] XOR Data[4]) XOR TRUE))) XOR Data[34]) OR Data[15]) XOR ((Data[15] XOR ((((Data[41] XOR Data[12]) XOR Data[20]) OR ((Data[21] XOR Data[44]) XOR Data[18])) AND (((Data[33] AND Data[12]) XOR Data[25]) XOR ((Data[1] XOR Data[19]) XOR TRUE)))) XOR ((((Data[49] OR Data[9]) AND (Data[31] AND FALSE)) XOR (NOT (Data[49] OR Data[19]))) XOR (((Data[13] XOR Data[7]) XOR Data[4]) OR (TRUE AND Data[34]))))) XOR ((((Data[15] XOR ((Data[36] AND Data[11]) AND ((Data[46] XOR Data[33]) XOR Data[2]))) XOR (((Data[29] XOR Data[36]) XOR FALSE) AND (Data[24] AND Data[12]))) XOR (NOT (((FALSE AND Data[10]) XOR Data[15]) XOR ((Data[25] XOR Data[11]) XOR Data[19])))) XOR (NOT (NOT (NOT Data[22])))))) XOR Data[14]))) AND ((((Data[33] AND Data[5]) XOR ((((NOT (((((NOT Data[34]) XOR (NOT Data[15])) XOR (NOT Data[35])) XOR (NOT (Data[7] OR Data[43]))) XOR (((NOT Data[45]) XOR (Data[23] OR Data[36])) XOR (Data[33] AND Data[5])))) AND Data[42]) XOR (NOT Data[14])) XOR ((NOT (NOT (NOT ((Data[24] XOR Data[40]) XOR Data[46])))) OR Data[22]))) XOR (((((((Data[14] OR Data[48]) OR ((Data[38] XOR Data[48]) XOR Data[19])) OR Data[42]) OR ((((Data[10] XOR Data[38]) XOR Data[50]) OR Data[28]) AND (NOT (NOT Data[40])))) AND Data[30]) XOR Data[41]) XOR (((NOT ((Data[11] AND Data[11]) OR ((Data[38] XOR Data[32]) XOR Data[19]))) AND ((NOT (Data[44] AND Data[44])) OR (((Data[37] XOR Data[46]) XOR Data[40]) AND (NOT Data[19])))) AND ((NOT ((Data[46] XOR ((Data[39] XOR Data[2]) XOR Data[24])) XOR ((Data[1] XOR Data[43]) XOR Data[50]))) AND ((((Data[25] XOR Data[2]) XOR Data[29]) OR (Data[34] AND Data[12])) AND ((NOT Data[2]) AND ((Data[14] XOR Data[33]) XOR Data[13]))))))) AND ((((((Data[10] OR (TRUE OR Data[33])) AND (((Data[18] XOR Data[28]) XOR Data[25]) AND (NOT Data[25]))) AND ((((NOT Data[36]) XOR (TRUE OR Data[1])) XOR Data[20]) AND (((Data[26] XOR Data[12]) XOR Data[37]) OR (FALSE AND Data[15])))) AND ((((((Data[31] XOR Data[27]) XOR Data[42]) XOR (Data[40] AND Data[2])) XOR (Data[42] AND Data[24])) AND (((Data[47] OR Data[36]) XOR (NOT Data[29])) XOR (Data[2] OR Data[41]))) AND Data[42])) OR (((((NOT (NOT (Data[9] AND Data[36]))) XOR (NOT ((Data[16] XOR Data[28]) XOR (Data[32] OR TRUE)))) XOR ((((Data[10] XOR Data[24]) XOR Data[46]) OR (NOT Data[45])) AND (NOT (Data[37] AND Data[12])))) XOR (((((((Data[6] XOR Data[13]) XOR Data[48]) XOR (Data[32] AND Data[7])) XOR ((Data[34] XOR Data[19]) XOR Data[46])) XOR Data[47]) XOR (Data[14] AND ((Data[23] XOR Data[44]) XOR Data[42]))) OR Data[35])) XOR ((((Data[8] AND FALSE) AND (Data[14] AND Data[20])) AND Data[19]) OR Data[39]))) AND Data[18]))) OR ((Data[44] AND TRUE) AND (((((NOT (NOT (Data[2] OR (((Data[32] XOR Data[15]) XOR Data[7]) OR ((Data[30] XOR Data[15]) XOR Data[20]))))) AND Data[48]) XOR ((((((NOT Data[37]) AND (NOT ((Data[36] XOR Data[13]) XOR Data[21]))) AND (Data[7] AND Data[39])) XOR ((NOT Data[13]) AND (((NOT (NOT Data[7])) XOR Data[34]) XOR (FALSE OR (Data[6] AND Data[16]))))) XOR ((((Data[41] AND Data[45]) AND (Data[28] OR Data[39])) OR (NOT (Data[15] AND Data[38]))) AND ((Data[36] XOR ((Data[48] OR Data[18]) AND (Data[18] AND Data[20]))) XOR (((Data[47] XOR Data[26]) XOR Data[11]) OR (NOT Data[27]))))) AND Data[12])) XOR Data[20]) OR ((((Data[40] XOR (((((Data[7] AND Data[24]) OR ((Data[32] XOR Data[26]) XOR Data[16])) OR Data[23]) XOR (((Data[39] AND (Data[45] OR Data[19])) XOR ((((Data[41] XOR Data[17]) XOR Data[4]) XOR ((Data[6] XOR Data[46]) XOR Data[22])) XOR (FALSE AND Data[3]))) XOR (((Data[22] XOR Data[17]) XOR Data[47]) OR (NOT Data[15])))) XOR (NOT (((Data[25] XOR Data[5]) XOR Data[24]) OR (Data[3] OR Data[29]))))) XOR ((Data[3] AND (NOT Data[43])) AND Data[21])) AND ((NOT (((((Data[32] XOR Data[39]) XOR Data[15]) AND (NOT Data[21])) XOR ((Data[37] OR Data[20]) AND (NOT Data[31]))) XOR ((Data[25] XOR (Data[28] AND Data[16])) XOR (Data[4] OR Data[17])))) AND (NOT (((((Data[31] XOR Data[25]) XOR Data[5]) XOR ((Data[1] XOR Data[10]) XOR Data[50])) XOR (NOT Data[18])) OR ((NOT Data[18]) OR Data[34]))))) OR (Data[33] OR ((NOT (((Data[23] AND Data[13]) AND (Data[3] OR Data[11])) AND (((Data[6] XOR Data[14]) XOR Data[29]) OR (Data[20] OR Data[44])))) OR (NOT (Data[24] OR (((Data[28] XOR Data[29]) XOR Data[10]) AND (NOT Data[27]))))))))));
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
