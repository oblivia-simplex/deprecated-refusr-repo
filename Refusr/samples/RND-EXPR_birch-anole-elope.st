(*
This code implements a randomly grown symbolic expression:

(xor(xor(!(!(xor(xor(xor(xor((IN6 | ((IN4 & IN40) | true)) | IN7, xor(xor(!(IN4), IN38 & IN9), xor(xor(!(!(IN39)), !(IN9)), (IN20 & IN48) & IN8))), xor(xor(IN49, IN49), xor(xor((xor(xor(IN3, true), IN17)) & (xor(xor(IN50, IN27), IN18)), IN17 | IN24), (xor(xor(IN5, IN32), IN45)) & (xor(xor(IN23, IN35), IN16))))), (IN48 & (IN1 | ((true | IN6) | IN50))) & IN23), true))), !(!(IN36 | (IN23 | (!(!(xor(xor(!(IN21), IN9 & IN45), IN50 & IN23)))))))), xor(xor(!((!(!(xor(xor(!(xor(xor(IN14, IN48), IN22)), !(IN31 | IN8)), IN42 | (false | IN43))))) & IN24), !(xor(xor(xor(xor(IN6 & (((!(IN33)) | (!(IN34))) | ((IN28 | false) | IN6)), IN4), ((xor(xor(true, IN2 & IN24), !(IN40))) & (IN33 & (xor(xor(IN16, IN17), IN30)))) & ((!(IN9)) | IN10)), IN19 & (xor(xor(IN43, (xor(xor(!(IN20), IN23 & IN40), IN4 | IN34)) | ((!(IN3)) & (IN28 | IN13))), ((IN38 & IN26) & (IN23 & IN41)) | ((IN47 | IN39) & (xor(xor(IN28, IN31), IN9)))))), IN24 | (xor(xor(((IN44 | IN34) & (!(IN15))) | (IN8 | IN30), !(IN24)), !(xor(xor(IN1 | IN15, IN37 & IN22), IN34))))))), (!(!(IN3))) | ((!((!(!(IN41 & IN5))) | (((IN15 & IN30) | (!(IN41))) & (!(xor(xor(IN45, IN23), IN49)))))) | (!((IN15 & (xor(xor(IN33, IN35 | IN31), IN17 | IN11))) & ((!(IN48)) & ((!(IN43)) & (IN5 | IN43))))))))) | ((xor(xor(xor(xor(!(IN1), IN16 | IN9), !(IN31)), IN3), (((xor(xor(!(xor(xor(xor(xor(IN26, IN1), IN8), IN16 | IN23), IN27)), xor(xor(IN48 & (xor(xor(IN25, IN21), IN45)), IN24), !(IN37 & IN25))), ((IN34 & IN27) | IN11) | (xor(xor(IN48, xor(xor(IN50, IN12), IN35)), !(IN24))))) & (IN20 | (((xor(xor(IN43, IN17), IN24)) | (!(IN15))) & IN18))) & (IN17 & (!(IN41)))) | (!(xor(xor((IN39 | (xor(xor(!(IN19), IN39 & IN47), xor(xor(IN18, IN45), IN1)))) | (xor(xor((false & IN8) & (IN7 & IN19), !(IN39 & IN17)), !(!(IN44)))), (((IN4 | IN27) | IN8) & (!(!(IN38)))) | (IN48 | (xor(xor(!(IN18), xor(xor(IN18, IN41), IN36)), IN42 | IN14)))), IN21))))) & ((!(!(IN1))) & (!((xor(xor(xor(xor(xor(xor((IN38 | IN1) | (IN13 & IN33), (!(IN17)) & (IN12 & IN16)), (!(IN39)) | (!(IN41))), (!(IN43 | IN4)) & (xor(xor(xor(xor(IN2, IN6), IN8), xor(xor(IN33, IN43), IN22)), true & IN25))), IN41 | ((IN43 | IN46) & (IN10 & IN14))), (!(!(IN42 & IN34))) | IN29), !(((!(IN49)) & (IN33 & IN20)) | (xor(xor(IN1, IN19 | IN21), IN12))))) | ((xor(xor(!((!(IN32)) & (!(IN44))), IN21 & (xor(xor(IN35 | IN42, xor(xor(IN34, IN17), IN1)), IN49 & IN37))), ((!(IN15)) & IN30) & (xor(xor(false, IN37 & IN31), IN42)))) & ((((!(IN36)) & IN22) & (xor(xor(IN48, IN37 & IN48), IN13))) | (xor(xor(IN8 & IN42, IN40), false))))))))

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
    Out := ((((NOT (NOT ((((((Data[6] OR ((Data[4] AND Data[40]) OR TRUE)) OR Data[7]) XOR (((NOT Data[4]) XOR (Data[38] AND Data[9])) XOR (((NOT (NOT Data[39])) XOR (NOT Data[9])) XOR ((Data[20] AND Data[48]) AND Data[8])))) XOR ((Data[49] XOR Data[49]) XOR (((((Data[3] XOR TRUE) XOR Data[17]) AND ((Data[50] XOR Data[27]) XOR Data[18])) XOR (Data[17] OR Data[24])) XOR (((Data[5] XOR Data[32]) XOR Data[45]) AND ((Data[23] XOR Data[35]) XOR Data[16]))))) XOR ((Data[48] AND (Data[1] OR ((TRUE OR Data[6]) OR Data[50]))) AND Data[23])) XOR TRUE))) XOR (NOT (NOT (Data[36] OR (Data[23] OR (NOT (NOT (((NOT Data[21]) XOR (Data[9] AND Data[45])) XOR (Data[50] AND Data[23]))))))))) XOR (((NOT ((NOT (NOT (((NOT ((Data[14] XOR Data[48]) XOR Data[22])) XOR (NOT (Data[31] OR Data[8]))) XOR (Data[42] OR (FALSE OR Data[43]))))) AND Data[24])) XOR (NOT (((((Data[6] AND (((NOT Data[33]) OR (NOT Data[34])) OR ((Data[28] OR FALSE) OR Data[6]))) XOR Data[4]) XOR ((((TRUE XOR (Data[2] AND Data[24])) XOR (NOT Data[40])) AND (Data[33] AND ((Data[16] XOR Data[17]) XOR Data[30]))) AND ((NOT Data[9]) OR Data[10]))) XOR (Data[19] AND ((Data[43] XOR ((((NOT Data[20]) XOR (Data[23] AND Data[40])) XOR (Data[4] OR Data[34])) OR ((NOT Data[3]) AND (Data[28] OR Data[13])))) XOR (((Data[38] AND Data[26]) AND (Data[23] AND Data[41])) OR ((Data[47] OR Data[39]) AND ((Data[28] XOR Data[31]) XOR Data[9])))))) XOR (Data[24] OR (((((Data[44] OR Data[34]) AND (NOT Data[15])) OR (Data[8] OR Data[30])) XOR (NOT Data[24])) XOR (NOT (((Data[1] OR Data[15]) XOR (Data[37] AND Data[22])) XOR Data[34]))))))) XOR ((NOT (NOT Data[3])) OR ((NOT ((NOT (NOT (Data[41] AND Data[5]))) OR (((Data[15] AND Data[30]) OR (NOT Data[41])) AND (NOT ((Data[45] XOR Data[23]) XOR Data[49]))))) OR (NOT ((Data[15] AND ((Data[33] XOR (Data[35] OR Data[31])) XOR (Data[17] OR Data[11]))) AND ((NOT Data[48]) AND ((NOT Data[43]) AND (Data[5] OR Data[43]))))))))) OR ((((((NOT Data[1]) XOR (Data[16] OR Data[9])) XOR (NOT Data[31])) XOR Data[3]) XOR ((((((NOT ((((Data[26] XOR Data[1]) XOR Data[8]) XOR (Data[16] OR Data[23])) XOR Data[27])) XOR (((Data[48] AND ((Data[25] XOR Data[21]) XOR Data[45])) XOR Data[24]) XOR (NOT (Data[37] AND Data[25])))) XOR (((Data[34] AND Data[27]) OR Data[11]) OR ((Data[48] XOR ((Data[50] XOR Data[12]) XOR Data[35])) XOR (NOT Data[24])))) AND (Data[20] OR ((((Data[43] XOR Data[17]) XOR Data[24]) OR (NOT Data[15])) AND Data[18]))) AND (Data[17] AND (NOT Data[41]))) OR (NOT ((((Data[39] OR (((NOT Data[19]) XOR (Data[39] AND Data[47])) XOR ((Data[18] XOR Data[45]) XOR Data[1]))) OR ((((FALSE AND Data[8]) AND (Data[7] AND Data[19])) XOR (NOT (Data[39] AND Data[17]))) XOR (NOT (NOT Data[44])))) XOR ((((Data[4] OR Data[27]) OR Data[8]) AND (NOT (NOT Data[38]))) OR (Data[48] OR (((NOT Data[18]) XOR ((Data[18] XOR Data[41]) XOR Data[36])) XOR (Data[42] OR Data[14]))))) XOR Data[21])))) AND ((NOT (NOT Data[1])) AND (NOT (((((((((Data[38] OR Data[1]) OR (Data[13] AND Data[33])) XOR ((NOT Data[17]) AND (Data[12] AND Data[16]))) XOR ((NOT Data[39]) OR (NOT Data[41]))) XOR ((NOT (Data[43] OR Data[4])) AND ((((Data[2] XOR Data[6]) XOR Data[8]) XOR ((Data[33] XOR Data[43]) XOR Data[22])) XOR (TRUE AND Data[25])))) XOR (Data[41] OR ((Data[43] OR Data[46]) AND (Data[10] AND Data[14])))) XOR ((NOT (NOT (Data[42] AND Data[34]))) OR Data[29])) XOR (NOT (((NOT Data[49]) AND (Data[33] AND Data[20])) OR ((Data[1] XOR (Data[19] OR Data[21])) XOR Data[12])))) OR ((((NOT ((NOT Data[32]) AND (NOT Data[44]))) XOR (Data[21] AND (((Data[35] OR Data[42]) XOR ((Data[34] XOR Data[17]) XOR Data[1])) XOR (Data[49] AND Data[37])))) XOR (((NOT Data[15]) AND Data[30]) AND ((FALSE XOR (Data[37] AND Data[31])) XOR Data[42]))) AND ((((NOT Data[36]) AND Data[22]) AND ((Data[48] XOR (Data[37] AND Data[48])) XOR Data[13])) OR (((Data[8] AND Data[42]) XOR Data[40]) XOR FALSE))))))));
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
