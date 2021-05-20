(*
This code implements a randomly grown symbolic expression:

(!(((!(((xor(xor(xor(xor(xor(xor(IN30, IN19), IN50), xor(xor(IN35, IN19), IN44)), IN29), !(IN28 & IN18)), xor(xor(IN26 | IN48, !(IN15)), xor(xor(IN24, IN37), IN46)))) & (!((IN8 & IN3) | (!(IN18))))) | ((((IN9 & IN43) & (IN49 | IN43)) | ((!(IN42)) | (IN47 | false))) | IN2))) | (xor(xor(IN16, IN19 & (xor(xor((IN36 & true) | (!(IN22)), xor(xor((!(IN39)) & (!(IN8)), (IN10 | IN24) | (IN5 | IN4)), (!(IN28)) & (IN24 & false))), ((xor(xor(IN6, IN1), IN15)) & (!(IN20))) | ((xor(xor(IN28, IN49), IN12)) & (xor(xor(IN2, IN46), IN24)))))), (IN19 | IN26) & (!((IN3 & (IN8 & IN41)) & (IN31 & (xor(xor(IN5, IN21), IN6)))))))) & (xor(xor(IN12, !((!(IN28 & (!(!(IN23))))) & ((xor(xor(!(!(IN33)), (xor(xor(IN50, IN35), IN39)) & (IN42 & IN32)), false)) | IN2))), ((xor(xor(!(!(IN42 & IN19)), IN45), ((IN22 | IN23) | IN36) | (xor(xor(IN13, IN48 | IN7), IN24 | IN8)))) | (!(!(xor(xor(IN19 | IN14, IN2), !(IN48)))))) & (xor(xor(IN44, IN17), xor(xor(!(!(!(IN36))), xor(xor(xor(xor(IN26 & IN14, IN25 | IN18), IN37), xor(xor(!(IN33), IN25 & false), xor(xor(IN1, IN12), IN4))), !(!(IN22)))), IN3))))))) | (((IN47 | (xor(xor(xor(xor(IN7, IN44), !(IN46)), (xor(xor(IN9, IN46 & (IN31 | (!(IN4)))), true | (IN46 & (xor(xor(IN2, true), IN27))))) | ((!(IN1)) & (((!(IN46)) & (IN19 | IN18)) | ((xor(xor(IN4, IN5), IN25)) | (xor(xor(IN50, IN13), IN33)))))), !((xor(xor(xor(xor(!(IN42), xor(xor(IN10, IN36), true)), IN5 & IN27), xor(xor(IN27 | IN46, xor(xor(IN31, IN5), IN11)), !(IN29))), (xor(xor(IN28, IN9), IN31)) | (xor(xor(IN37, IN32), IN4)))) & IN2)))) | ((xor(xor(IN20, !(xor(xor((xor(xor(IN17 & IN10, xor(xor(IN1, IN35), IN47)), IN12 & IN2)) & (xor(xor(xor(xor(IN4, IN42), IN35), IN23 | IN3), IN37)), IN24), !(xor(xor(IN40, IN29), !(IN21)))))), (IN12 & (xor(xor(IN13, !(IN48)), !(xor(xor(IN19, IN8), IN13))))) | (!(xor(xor(!(IN5 | IN11), (IN26 | IN26) | (xor(xor(IN10, IN49), IN32))), !(!(IN3))))))) | IN12)) & IN35)

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
    Out := ((NOT (((NOT ((((((((Data[30] XOR Data[19]) XOR Data[50]) XOR ((Data[35] XOR Data[19]) XOR Data[44])) XOR Data[29]) XOR (NOT (Data[28] AND Data[18]))) XOR (((Data[26] OR Data[48]) XOR (NOT Data[15])) XOR ((Data[24] XOR Data[37]) XOR Data[46]))) AND (NOT ((Data[8] AND Data[3]) OR (NOT Data[18])))) OR ((((Data[9] AND Data[43]) AND (Data[49] OR Data[43])) OR ((NOT Data[42]) OR (Data[47] OR FALSE))) OR Data[2]))) OR ((Data[16] XOR (Data[19] AND ((((Data[36] AND TRUE) OR (NOT Data[22])) XOR ((((NOT Data[39]) AND (NOT Data[8])) XOR ((Data[10] OR Data[24]) OR (Data[5] OR Data[4]))) XOR ((NOT Data[28]) AND (Data[24] AND FALSE)))) XOR ((((Data[6] XOR Data[1]) XOR Data[15]) AND (NOT Data[20])) OR (((Data[28] XOR Data[49]) XOR Data[12]) AND ((Data[2] XOR Data[46]) XOR Data[24])))))) XOR ((Data[19] OR Data[26]) AND (NOT ((Data[3] AND (Data[8] AND Data[41])) AND (Data[31] AND ((Data[5] XOR Data[21]) XOR Data[6]))))))) AND ((Data[12] XOR (NOT ((NOT (Data[28] AND (NOT (NOT Data[23])))) AND ((((NOT (NOT Data[33])) XOR (((Data[50] XOR Data[35]) XOR Data[39]) AND (Data[42] AND Data[32]))) XOR FALSE) OR Data[2])))) XOR (((((NOT (NOT (Data[42] AND Data[19]))) XOR Data[45]) XOR (((Data[22] OR Data[23]) OR Data[36]) OR ((Data[13] XOR (Data[48] OR Data[7])) XOR (Data[24] OR Data[8])))) OR (NOT (NOT (((Data[19] OR Data[14]) XOR Data[2]) XOR (NOT Data[48]))))) AND ((Data[44] XOR Data[17]) XOR (((NOT (NOT (NOT Data[36]))) XOR (((((Data[26] AND Data[14]) XOR (Data[25] OR Data[18])) XOR Data[37]) XOR (((NOT Data[33]) XOR (Data[25] AND FALSE)) XOR ((Data[1] XOR Data[12]) XOR Data[4]))) XOR (NOT (NOT Data[22])))) XOR Data[3])))))) OR (((Data[47] OR ((((Data[7] XOR Data[44]) XOR (NOT Data[46])) XOR (((Data[9] XOR (Data[46] AND (Data[31] OR (NOT Data[4])))) XOR (TRUE OR (Data[46] AND ((Data[2] XOR TRUE) XOR Data[27])))) OR ((NOT Data[1]) AND (((NOT Data[46]) AND (Data[19] OR Data[18])) OR (((Data[4] XOR Data[5]) XOR Data[25]) OR ((Data[50] XOR Data[13]) XOR Data[33])))))) XOR (NOT ((((((NOT Data[42]) XOR ((Data[10] XOR Data[36]) XOR TRUE)) XOR (Data[5] AND Data[27])) XOR (((Data[27] OR Data[46]) XOR ((Data[31] XOR Data[5]) XOR Data[11])) XOR (NOT Data[29]))) XOR (((Data[28] XOR Data[9]) XOR Data[31]) OR ((Data[37] XOR Data[32]) XOR Data[4]))) AND Data[2])))) OR (((Data[20] XOR (NOT ((((((Data[17] AND Data[10]) XOR ((Data[1] XOR Data[35]) XOR Data[47])) XOR (Data[12] AND Data[2])) AND ((((Data[4] XOR Data[42]) XOR Data[35]) XOR (Data[23] OR Data[3])) XOR Data[37])) XOR Data[24]) XOR (NOT ((Data[40] XOR Data[29]) XOR (NOT Data[21])))))) XOR ((Data[12] AND ((Data[13] XOR (NOT Data[48])) XOR (NOT ((Data[19] XOR Data[8]) XOR Data[13])))) OR (NOT (((NOT (Data[5] OR Data[11])) XOR ((Data[26] OR Data[26]) OR ((Data[10] XOR Data[49]) XOR Data[32]))) XOR (NOT (NOT Data[3])))))) OR Data[12])) AND Data[35]));
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
