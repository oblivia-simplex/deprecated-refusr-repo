(*
This code implements a randomly grown symbolic expression:

(!(IN9 & IN6)) | ((xor(xor(IN42, xor(xor(xor(xor((((xor(xor(IN21 & IN3, !(IN48)), IN25)) & ((IN25 | IN29) & (!(IN34)))) & (!(xor(xor(!(IN8), IN43 | IN34), true & IN3)))) & (IN30 & IN22), true), xor(xor(IN11, IN23), !(IN20))), !(xor(xor(xor(xor((!(IN23 | IN23)) & ((IN7 | IN35) | (xor(xor(IN10, IN11), IN30))), !((IN48 | IN22) | (IN18 & IN41))), !((!(IN24)) & (xor(xor(IN11, IN46), IN30)))), IN3), (xor(xor((IN10 | IN30) & (xor(xor(IN44, IN23), IN34)), (xor(xor(IN49, IN33), IN38)) | (IN23 | IN38)), IN20)) | ((xor(xor(xor(xor(IN34, IN10), IN39), xor(xor(IN18, IN42), IN17)), IN17 | IN30)) | IN44)))), (!(IN36)) & (((xor(xor(xor(xor(IN38 | IN4, IN48 | IN16), IN48), (xor(xor(IN24, IN18), false)) & IN14), (xor(xor(IN35, IN22), IN4)) | (IN6 | IN42))) | IN6) | (xor(xor(!(!(IN47)), (xor(xor(IN25 & IN33, !(IN19)), !(IN43))) | ((IN3 & IN6) | true)), xor(xor(IN44, (IN40 | IN1) & (!(IN46))), IN25)))))), xor(xor((xor(xor(IN14, xor(xor(IN3, (xor(xor(!(IN35), xor(xor(IN29, IN2), IN25)), xor(xor(IN43, IN27), IN1))) & ((IN32 | IN35) & IN17)), true & ((IN45 & IN30) & IN39))), (((xor(xor(IN7, IN43), IN40)) & (IN43 | IN5)) | (!(IN13 | IN2))) & (((!(IN47)) & (IN49 | IN50)) | (IN38 | (!(IN48)))))) & (xor(xor(xor(xor(IN24 | ((!(IN23)) | (IN11 & IN7)), ((IN37 & IN42) | (IN5 | IN11)) | ((IN46 & IN36) | (IN27 & IN27))), xor(xor((IN33 & IN37) & (!(IN46)), IN48 & (IN38 & IN49)), (xor(xor(IN15, IN17), IN33)) | (IN25 | IN34))), !(((xor(xor(IN46, IN21), IN11)) | (xor(xor(IN8, IN34), false))) & (xor(xor(xor(xor(false, IN1), IN37), xor(xor(false, IN23), IN23)), IN44)))), !(((IN39 & IN12) & (xor(xor(IN48, IN2), IN22))) | (xor(xor(IN16, true), !(IN19)))))), (((((IN38 | IN31) & (xor(xor(IN39, IN8), IN24))) | ((IN35 & IN18) | (IN34 & IN3))) | ((xor(xor(IN34 | IN30, xor(xor(IN41, IN33), IN25)), IN36 | IN31)) | ((false & IN29) & (!(IN8))))) & IN10) & (xor(xor(IN16, xor(xor(((IN13 & IN2) | (IN5 & IN25)) | (xor(xor(IN41 | IN38, IN38 | true), !(IN18))), (!(IN30 | IN15)) & (!(IN30 | IN24))), xor(xor(IN3, xor(xor(xor(xor(IN34, IN19), IN22), xor(xor(IN35, IN16), IN26)), !(IN10))), (IN49 & IN6) | (IN49 | IN10)))), IN47))), (((!((!(IN30)) & IN4)) | (!(!(IN42 | IN10)))) | IN50) | (IN11 & ((xor(xor(IN8, (!(IN6)) & (IN1 | IN42)), !(xor(xor(IN9, IN23), IN10)))) | (!((IN26 & IN21) & IN32))))))) | (!(!((!(IN23)) & (((((IN15 | IN15) | (IN14 & false)) & (xor(xor(xor(xor(IN34, IN16), IN27), IN10 & IN45), xor(xor(IN45, IN30), IN11)))) | (IN10 | ((IN7 | IN3) | IN30))) | (xor(xor(xor(xor(xor(xor(IN37, IN41 | IN7), IN44 | IN10), IN8), xor(xor(xor(xor(IN50, IN34), IN27), xor(xor(IN39, IN44), IN36)), xor(xor(IN16, IN37), IN18))), IN47), ((xor(xor(IN10, IN38), IN24)) | (IN22 | IN25)) | (xor(xor(IN41, IN17), IN1 & IN50)))))))))

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
    Out := ((NOT (Data[9] AND Data[6])) OR (((Data[42] XOR ((((((((((Data[21] AND Data[3]) XOR (NOT Data[48])) XOR Data[25]) AND ((Data[25] OR Data[29]) AND (NOT Data[34]))) AND (NOT (((NOT Data[8]) XOR (Data[43] OR Data[34])) XOR (TRUE AND Data[3])))) AND (Data[30] AND Data[22])) XOR TRUE) XOR ((Data[11] XOR Data[23]) XOR (NOT Data[20]))) XOR (NOT ((((((NOT (Data[23] OR Data[23])) AND ((Data[7] OR Data[35]) OR ((Data[10] XOR Data[11]) XOR Data[30]))) XOR (NOT ((Data[48] OR Data[22]) OR (Data[18] AND Data[41])))) XOR (NOT ((NOT Data[24]) AND ((Data[11] XOR Data[46]) XOR Data[30])))) XOR Data[3]) XOR (((((Data[10] OR Data[30]) AND ((Data[44] XOR Data[23]) XOR Data[34])) XOR (((Data[49] XOR Data[33]) XOR Data[38]) OR (Data[23] OR Data[38]))) XOR Data[20]) OR (((((Data[34] XOR Data[10]) XOR Data[39]) XOR ((Data[18] XOR Data[42]) XOR Data[17])) XOR (Data[17] OR Data[30])) OR Data[44]))))) XOR ((NOT Data[36]) AND (((((((Data[38] OR Data[4]) XOR (Data[48] OR Data[16])) XOR Data[48]) XOR (((Data[24] XOR Data[18]) XOR FALSE) AND Data[14])) XOR (((Data[35] XOR Data[22]) XOR Data[4]) OR (Data[6] OR Data[42]))) OR Data[6]) OR (((NOT (NOT Data[47])) XOR ((((Data[25] AND Data[33]) XOR (NOT Data[19])) XOR (NOT Data[43])) OR ((Data[3] AND Data[6]) OR TRUE))) XOR ((Data[44] XOR ((Data[40] OR Data[1]) AND (NOT Data[46]))) XOR Data[25])))))) XOR (((((Data[14] XOR ((Data[3] XOR ((((NOT Data[35]) XOR ((Data[29] XOR Data[2]) XOR Data[25])) XOR ((Data[43] XOR Data[27]) XOR Data[1])) AND ((Data[32] OR Data[35]) AND Data[17]))) XOR (TRUE AND ((Data[45] AND Data[30]) AND Data[39])))) XOR (((((Data[7] XOR Data[43]) XOR Data[40]) AND (Data[43] OR Data[5])) OR (NOT (Data[13] OR Data[2]))) AND (((NOT Data[47]) AND (Data[49] OR Data[50])) OR (Data[38] OR (NOT Data[48]))))) AND (((((Data[24] OR ((NOT Data[23]) OR (Data[11] AND Data[7]))) XOR (((Data[37] AND Data[42]) OR (Data[5] OR Data[11])) OR ((Data[46] AND Data[36]) OR (Data[27] AND Data[27])))) XOR ((((Data[33] AND Data[37]) AND (NOT Data[46])) XOR (Data[48] AND (Data[38] AND Data[49]))) XOR (((Data[15] XOR Data[17]) XOR Data[33]) OR (Data[25] OR Data[34])))) XOR (NOT ((((Data[46] XOR Data[21]) XOR Data[11]) OR ((Data[8] XOR Data[34]) XOR FALSE)) AND ((((FALSE XOR Data[1]) XOR Data[37]) XOR ((FALSE XOR Data[23]) XOR Data[23])) XOR Data[44])))) XOR (NOT (((Data[39] AND Data[12]) AND ((Data[48] XOR Data[2]) XOR Data[22])) OR ((Data[16] XOR TRUE) XOR (NOT Data[19])))))) XOR ((((((Data[38] OR Data[31]) AND ((Data[39] XOR Data[8]) XOR Data[24])) OR ((Data[35] AND Data[18]) OR (Data[34] AND Data[3]))) OR ((((Data[34] OR Data[30]) XOR ((Data[41] XOR Data[33]) XOR Data[25])) XOR (Data[36] OR Data[31])) OR ((FALSE AND Data[29]) AND (NOT Data[8])))) AND Data[10]) AND ((Data[16] XOR (((((Data[13] AND Data[2]) OR (Data[5] AND Data[25])) OR (((Data[41] OR Data[38]) XOR (Data[38] OR TRUE)) XOR (NOT Data[18]))) XOR ((NOT (Data[30] OR Data[15])) AND (NOT (Data[30] OR Data[24])))) XOR ((Data[3] XOR ((((Data[34] XOR Data[19]) XOR Data[22]) XOR ((Data[35] XOR Data[16]) XOR Data[26])) XOR (NOT Data[10]))) XOR ((Data[49] AND Data[6]) OR (Data[49] OR Data[10]))))) XOR Data[47]))) XOR ((((NOT ((NOT Data[30]) AND Data[4])) OR (NOT (NOT (Data[42] OR Data[10])))) OR Data[50]) OR (Data[11] AND (((Data[8] XOR ((NOT Data[6]) AND (Data[1] OR Data[42]))) XOR (NOT ((Data[9] XOR Data[23]) XOR Data[10]))) OR (NOT ((Data[26] AND Data[21]) AND Data[32]))))))) OR (NOT (NOT ((NOT Data[23]) AND (((((Data[15] OR Data[15]) OR (Data[14] AND FALSE)) AND ((((Data[34] XOR Data[16]) XOR Data[27]) XOR (Data[10] AND Data[45])) XOR ((Data[45] XOR Data[30]) XOR Data[11]))) OR (Data[10] OR ((Data[7] OR Data[3]) OR Data[30]))) OR ((((((Data[37] XOR (Data[41] OR Data[7])) XOR (Data[44] OR Data[10])) XOR Data[8]) XOR ((((Data[50] XOR Data[34]) XOR Data[27]) XOR ((Data[39] XOR Data[44]) XOR Data[36])) XOR ((Data[16] XOR Data[37]) XOR Data[18]))) XOR Data[47]) XOR ((((Data[10] XOR Data[38]) XOR Data[24]) OR (Data[22] OR Data[25])) OR ((Data[41] XOR Data[17]) XOR (Data[1] AND Data[50]))))))))));
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
