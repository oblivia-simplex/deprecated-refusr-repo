(*
This code implements a randomly grown symbolic expression:

((!((IN27 & (!(((IN20 & (xor(xor(IN19, IN43), IN36))) | (!(xor(xor(IN23, IN22), IN14)))) & (!(IN16))))) | (((!(xor(xor(!(IN30 | IN14), !(IN23 | IN26)), !(xor(xor(IN44, IN12), IN19))))) & (!(IN5))) & IN9))) | ((IN46 & (!(!(IN11)))) & (xor(xor(IN5 & (xor(xor(!(!((IN38 | IN42) & (xor(xor(IN48, IN50), IN13)))), (xor(xor(IN49, IN50 | (!(IN24))), IN31)) | ((IN37 | (IN48 | IN34)) & ((IN35 | IN16) | (IN17 | IN43)))), IN13 | IN10)), (IN33 & ((!(IN17)) & (IN34 & IN48))) | IN32), IN5 & (IN20 | (xor(xor(IN25, IN24 | (IN15 & (!(IN8)))), IN27))))))) | ((!((xor(xor(!(IN27), IN41), xor(xor(xor(xor(IN26, (xor(xor(IN36 | IN34, xor(xor(IN21, IN29), IN42)), IN4)) | ((xor(xor(IN32, IN17), IN42)) & (IN8 & IN26))), (IN38 | (!(IN47))) & ((xor(xor(IN50, IN16), IN26)) & IN16)), (!((IN33 & IN46) | (IN1 | IN18))) & ((xor(xor(IN27 | IN36, IN18 & IN42), xor(xor(IN4, IN42), IN39))) & (IN45 & (xor(xor(IN42, IN15), IN42))))), !((!(xor(xor(IN47, IN15), IN19))) & IN30)))) & (!(xor(xor(IN2, (!(xor(xor(IN41, IN14 | IN24), xor(xor(IN45, IN37), IN19)))) & IN41), IN15 & (!((IN25 | true) & (IN41 | IN32)))))))) | (IN34 & (!((xor(xor(true, !(xor(xor(xor(xor(xor(xor(IN39, IN9), IN41), xor(xor(IN37, IN26), IN31)), xor(xor(IN21, IN3), IN24)), !(IN23 & IN19)), !(!(IN14))))), (((IN22 & false) | (!(IN12))) | (IN38 & (IN4 & IN30))) | ((xor(xor(!(IN27), IN31 & IN36), !(IN19))) & (!(!(IN1)))))) & (!(IN13))))))

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
    Out := (((NOT ((Data[27] AND (NOT (((Data[20] AND ((Data[19] XOR Data[43]) XOR Data[36])) OR (NOT ((Data[23] XOR Data[22]) XOR Data[14]))) AND (NOT Data[16])))) OR (((NOT (((NOT (Data[30] OR Data[14])) XOR (NOT (Data[23] OR Data[26]))) XOR (NOT ((Data[44] XOR Data[12]) XOR Data[19])))) AND (NOT Data[5])) AND Data[9]))) OR ((Data[46] AND (NOT (NOT Data[11]))) AND (((Data[5] AND (((NOT (NOT ((Data[38] OR Data[42]) AND ((Data[48] XOR Data[50]) XOR Data[13])))) XOR (((Data[49] XOR (Data[50] OR (NOT Data[24]))) XOR Data[31]) OR ((Data[37] OR (Data[48] OR Data[34])) AND ((Data[35] OR Data[16]) OR (Data[17] OR Data[43]))))) XOR (Data[13] OR Data[10]))) XOR ((Data[33] AND ((NOT Data[17]) AND (Data[34] AND Data[48]))) OR Data[32])) XOR (Data[5] AND (Data[20] OR ((Data[25] XOR (Data[24] OR (Data[15] AND (NOT Data[8])))) XOR Data[27])))))) OR ((NOT ((((NOT Data[27]) XOR Data[41]) XOR ((((Data[26] XOR ((((Data[36] OR Data[34]) XOR ((Data[21] XOR Data[29]) XOR Data[42])) XOR Data[4]) OR (((Data[32] XOR Data[17]) XOR Data[42]) AND (Data[8] AND Data[26])))) XOR ((Data[38] OR (NOT Data[47])) AND (((Data[50] XOR Data[16]) XOR Data[26]) AND Data[16]))) XOR ((NOT ((Data[33] AND Data[46]) OR (Data[1] OR Data[18]))) AND ((((Data[27] OR Data[36]) XOR (Data[18] AND Data[42])) XOR ((Data[4] XOR Data[42]) XOR Data[39])) AND (Data[45] AND ((Data[42] XOR Data[15]) XOR Data[42]))))) XOR (NOT ((NOT ((Data[47] XOR Data[15]) XOR Data[19])) AND Data[30])))) AND (NOT ((Data[2] XOR ((NOT ((Data[41] XOR (Data[14] OR Data[24])) XOR ((Data[45] XOR Data[37]) XOR Data[19]))) AND Data[41])) XOR (Data[15] AND (NOT ((Data[25] OR TRUE) AND (Data[41] OR Data[32])))))))) OR (Data[34] AND (NOT (((TRUE XOR (NOT ((((((Data[39] XOR Data[9]) XOR Data[41]) XOR ((Data[37] XOR Data[26]) XOR Data[31])) XOR ((Data[21] XOR Data[3]) XOR Data[24])) XOR (NOT (Data[23] AND Data[19]))) XOR (NOT (NOT Data[14]))))) XOR ((((Data[22] AND FALSE) OR (NOT Data[12])) OR (Data[38] AND (Data[4] AND Data[30]))) OR ((((NOT Data[27]) XOR (Data[31] AND Data[36])) XOR (NOT Data[19])) AND (NOT (NOT Data[1]))))) AND (NOT Data[13]))))));
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
