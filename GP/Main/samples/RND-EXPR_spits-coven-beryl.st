(*
This code implements a randomly grown symbolic expression:

!(!((((!(!((IN26 | (IN14 | IN47)) | ((IN43 & IN29) & (IN9 & IN8))))) | (((!(IN30 & IN26)) | ((xor(xor(IN9 & IN4, xor(xor(IN26, IN10), false)), xor(xor(IN41, IN12), IN33))) | ((xor(xor(IN25, IN41), IN50)) | (IN36 & IN45)))) | (!(xor(xor(IN43, !(IN26 & IN49)), xor(xor(!(IN41), IN20), !(IN35))))))) | (((xor(xor(xor(xor((IN25 & IN40) | (!(IN50)), xor(xor(IN1 | IN36, IN48 & IN11), !(IN9))), xor(xor(xor(xor(IN29, IN24), IN16), IN4), IN32 & IN26)), (!(IN25)) & (IN10 & IN22)), !((!(IN26)) | (!(IN19))))) & (xor(xor(IN41, xor(xor(xor(xor(IN45, IN33), IN10 & IN46), IN37), (!(IN28)) | (!(IN26)))), IN49))) & IN18)) & (xor(xor(((!(xor(xor((IN47 | IN27) | (IN10 | IN23), (!(IN36)) & false), true | (!(IN44))))) | (xor(xor(xor(xor(xor(xor(IN35 & IN39, xor(xor(IN21, IN41), IN43)), !(IN2)), (IN5 & IN41) | (IN29 | false)), (IN8 | IN23) & IN30), (xor(xor(!(IN18), xor(xor(IN36, IN27), IN17)), IN21 | true)) & IN1), (!(IN37 & true)) | ((IN5 & IN1) & IN14)))) & IN7, (!(!(IN35))) | (((xor(xor((IN45 & IN3) | (!(IN10)), (xor(xor(IN8, IN19), IN50)) | (IN35 & IN12)), true | IN46)) | (((IN43 | IN4) | (!(IN20))) & ((IN3 | IN22) & (!(IN41))))) & (xor(xor((xor(xor(xor(xor(IN40, IN44), IN16), IN20), !(IN19))) & IN31, (xor(xor(IN40 & IN6, xor(xor(IN49, IN42), IN24)), !(IN33))) & (xor(xor(!(IN31), xor(xor(IN6, IN28), IN4)), xor(xor(IN15, IN42), IN47)))), (IN18 & (IN12 & IN17)) | (!(IN6 | IN21)))))), (!(xor(xor(IN27, (!(!(IN39))) & (xor(xor(!(IN37), IN42 & IN9), xor(xor(IN17, IN41), IN39)))), xor(xor(IN48, (xor(xor(IN40, IN7), IN9)) & (IN17 & IN6)), IN49)))) & ((!(xor(xor(IN3 & (!(IN18)), !(IN19 | IN43)), !(xor(xor(IN34, IN48), IN28))))) & ((!(xor(xor(IN29 | IN13, !(IN23)), !(IN1)))) & (xor(xor((IN44 | IN32) & (xor(xor(IN34, IN3), IN24)), IN43), (IN25 | IN11) | (xor(xor(IN14, IN26), IN44))))))))))

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
    Out := (NOT (NOT ((((NOT (NOT ((Data[26] OR (Data[14] OR Data[47])) OR ((Data[43] AND Data[29]) AND (Data[9] AND Data[8]))))) OR (((NOT (Data[30] AND Data[26])) OR ((((Data[9] AND Data[4]) XOR ((Data[26] XOR Data[10]) XOR FALSE)) XOR ((Data[41] XOR Data[12]) XOR Data[33])) OR (((Data[25] XOR Data[41]) XOR Data[50]) OR (Data[36] AND Data[45])))) OR (NOT ((Data[43] XOR (NOT (Data[26] AND Data[49]))) XOR (((NOT Data[41]) XOR Data[20]) XOR (NOT Data[35])))))) OR ((((((((Data[25] AND Data[40]) OR (NOT Data[50])) XOR (((Data[1] OR Data[36]) XOR (Data[48] AND Data[11])) XOR (NOT Data[9]))) XOR ((((Data[29] XOR Data[24]) XOR Data[16]) XOR Data[4]) XOR (Data[32] AND Data[26]))) XOR ((NOT Data[25]) AND (Data[10] AND Data[22]))) XOR (NOT ((NOT Data[26]) OR (NOT Data[19])))) AND ((Data[41] XOR ((((Data[45] XOR Data[33]) XOR (Data[10] AND Data[46])) XOR Data[37]) XOR ((NOT Data[28]) OR (NOT Data[26])))) XOR Data[49])) AND Data[18])) AND (((((NOT ((((Data[47] OR Data[27]) OR (Data[10] OR Data[23])) XOR ((NOT Data[36]) AND FALSE)) XOR (TRUE OR (NOT Data[44])))) OR (((((((Data[35] AND Data[39]) XOR ((Data[21] XOR Data[41]) XOR Data[43])) XOR (NOT Data[2])) XOR ((Data[5] AND Data[41]) OR (Data[29] OR FALSE))) XOR ((Data[8] OR Data[23]) AND Data[30])) XOR ((((NOT Data[18]) XOR ((Data[36] XOR Data[27]) XOR Data[17])) XOR (Data[21] OR TRUE)) AND Data[1])) XOR ((NOT (Data[37] AND TRUE)) OR ((Data[5] AND Data[1]) AND Data[14])))) AND Data[7]) XOR ((NOT (NOT Data[35])) OR ((((((Data[45] AND Data[3]) OR (NOT Data[10])) XOR (((Data[8] XOR Data[19]) XOR Data[50]) OR (Data[35] AND Data[12]))) XOR (TRUE OR Data[46])) OR (((Data[43] OR Data[4]) OR (NOT Data[20])) AND ((Data[3] OR Data[22]) AND (NOT Data[41])))) AND (((((((Data[40] XOR Data[44]) XOR Data[16]) XOR Data[20]) XOR (NOT Data[19])) AND Data[31]) XOR ((((Data[40] AND Data[6]) XOR ((Data[49] XOR Data[42]) XOR Data[24])) XOR (NOT Data[33])) AND (((NOT Data[31]) XOR ((Data[6] XOR Data[28]) XOR Data[4])) XOR ((Data[15] XOR Data[42]) XOR Data[47])))) XOR ((Data[18] AND (Data[12] AND Data[17])) OR (NOT (Data[6] OR Data[21]))))))) XOR ((NOT ((Data[27] XOR ((NOT (NOT Data[39])) AND (((NOT Data[37]) XOR (Data[42] AND Data[9])) XOR ((Data[17] XOR Data[41]) XOR Data[39])))) XOR ((Data[48] XOR (((Data[40] XOR Data[7]) XOR Data[9]) AND (Data[17] AND Data[6]))) XOR Data[49]))) AND ((NOT (((Data[3] AND (NOT Data[18])) XOR (NOT (Data[19] OR Data[43]))) XOR (NOT ((Data[34] XOR Data[48]) XOR Data[28])))) AND ((NOT (((Data[29] OR Data[13]) XOR (NOT Data[23])) XOR (NOT Data[1]))) AND ((((Data[44] OR Data[32]) AND ((Data[34] XOR Data[3]) XOR Data[24])) XOR Data[43]) XOR ((Data[25] OR Data[11]) OR ((Data[14] XOR Data[26]) XOR Data[44]))))))))));
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
