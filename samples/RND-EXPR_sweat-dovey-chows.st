(*
This code implements a randomly grown symbolic expression:

((((xor(xor(xor(xor(IN9, (IN28 | ((IN18 & IN41) & (!(IN11)))) & (!(!(IN14)))), !(IN42)), !((((!(IN37)) & (IN26 | IN33)) & (xor(xor(IN4, IN35 & IN47), IN26 | IN39))) | ((IN25 | (IN13 | IN10)) & (xor(xor(IN17 | IN24, !(IN3)), xor(xor(IN34, IN24), IN19)))))), IN14 & ((xor(xor(!(IN18 | IN24), !(!(IN12))), xor(xor(IN7 & IN41, IN16 & IN28), IN5))) & IN6))) | ((IN28 & ((xor(xor(!(!(IN13)), (IN47 | IN47) & (!(IN5))), IN48)) | (xor(xor(IN36 | (IN14 & IN16), IN29), IN5)))) & (((xor(xor(!(xor(xor(IN29, IN44), IN41)), (xor(xor(IN30, IN31), IN19)) | (!(IN1))), xor(xor(IN16 | IN45, xor(xor(IN46, IN31), IN41)), IN28 & IN20))) & (xor(xor(IN48, (!(IN28)) | (IN35 | IN45)), (!(IN16)) | (IN9 | IN38)))) | IN35))) & (!(!(IN31)))) & IN7) & (((IN11 & ((xor(xor(((xor(xor(xor(xor(IN46, IN2), IN34), xor(xor(IN1, IN46), IN5)), !(IN30))) & ((IN17 & IN13) & IN29)) | (xor(xor(IN22, IN14), (!(IN41)) & (IN33 & IN43))), !(!(xor(xor(!(IN29), !(IN14)), !(IN31))))), IN28)) & (xor(xor(IN11, (xor(xor(IN14, IN24), IN25 & (IN39 | true))) | (!(xor(xor(xor(xor(IN29, IN10), IN23), IN22 | IN34), xor(xor(IN48, IN33), IN32))))), (!(!(IN1 | IN36))) & (IN20 | IN14))))) & ((xor(xor((xor(xor(xor(xor(xor(xor(IN11, !(IN21)), xor(xor(IN38, true), true)), IN28 | (IN3 | IN25)), xor(xor(IN21 & IN47, IN6 & IN6), IN30 & IN17)), IN27), (xor(xor(!(IN15), xor(xor(IN3, IN36), IN50)), xor(xor(IN19, IN43), IN5))) & IN5)) | IN37, (IN8 | (xor(xor(!(IN50 & IN50), IN13 | (IN19 & IN12)), (IN30 | IN41) | IN46))) & (!(xor(xor((!(IN27)) & (IN11 & IN13), IN20), (IN48 | IN22) | IN6)))), (IN13 | (!(xor(xor(!(IN22), xor(xor(IN33, IN14), IN48)), IN5 | IN41)))) & (xor(xor(!(!(IN3)), (xor(xor(xor(xor(IN31, IN46), IN41), IN49 & IN30), true)) & (xor(xor(true, IN20 & IN41), !(IN13)))), xor(xor((!(IN5)) | (IN14 & IN28), xor(xor(xor(xor(IN6, IN45), IN46), xor(xor(IN30, IN20), IN4)), xor(xor(IN49, IN9), IN19))), (IN19 | IN2) | IN43))))) & (!(IN38)))) | IN48)

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
    Out := ((((((((Data[9] XOR ((Data[28] OR ((Data[18] AND Data[41]) AND (NOT Data[11]))) AND (NOT (NOT Data[14])))) XOR (NOT Data[42])) XOR (NOT ((((NOT Data[37]) AND (Data[26] OR Data[33])) AND ((Data[4] XOR (Data[35] AND Data[47])) XOR (Data[26] OR Data[39]))) OR ((Data[25] OR (Data[13] OR Data[10])) AND (((Data[17] OR Data[24]) XOR (NOT Data[3])) XOR ((Data[34] XOR Data[24]) XOR Data[19])))))) XOR (Data[14] AND ((((NOT (Data[18] OR Data[24])) XOR (NOT (NOT Data[12]))) XOR (((Data[7] AND Data[41]) XOR (Data[16] AND Data[28])) XOR Data[5])) AND Data[6]))) OR ((Data[28] AND ((((NOT (NOT Data[13])) XOR ((Data[47] OR Data[47]) AND (NOT Data[5]))) XOR Data[48]) OR (((Data[36] OR (Data[14] AND Data[16])) XOR Data[29]) XOR Data[5]))) AND (((((NOT ((Data[29] XOR Data[44]) XOR Data[41])) XOR (((Data[30] XOR Data[31]) XOR Data[19]) OR (NOT Data[1]))) XOR (((Data[16] OR Data[45]) XOR ((Data[46] XOR Data[31]) XOR Data[41])) XOR (Data[28] AND Data[20]))) AND ((Data[48] XOR ((NOT Data[28]) OR (Data[35] OR Data[45]))) XOR ((NOT Data[16]) OR (Data[9] OR Data[38])))) OR Data[35]))) AND (NOT (NOT Data[31]))) AND Data[7]) AND (((Data[11] AND (((((((((Data[46] XOR Data[2]) XOR Data[34]) XOR ((Data[1] XOR Data[46]) XOR Data[5])) XOR (NOT Data[30])) AND ((Data[17] AND Data[13]) AND Data[29])) OR ((Data[22] XOR Data[14]) XOR ((NOT Data[41]) AND (Data[33] AND Data[43])))) XOR (NOT (NOT (((NOT Data[29]) XOR (NOT Data[14])) XOR (NOT Data[31]))))) XOR Data[28]) AND ((Data[11] XOR (((Data[14] XOR Data[24]) XOR (Data[25] AND (Data[39] OR TRUE))) OR (NOT ((((Data[29] XOR Data[10]) XOR Data[23]) XOR (Data[22] OR Data[34])) XOR ((Data[48] XOR Data[33]) XOR Data[32]))))) XOR ((NOT (NOT (Data[1] OR Data[36]))) AND (Data[20] OR Data[14]))))) AND ((((((((((Data[11] XOR (NOT Data[21])) XOR ((Data[38] XOR TRUE) XOR TRUE)) XOR (Data[28] OR (Data[3] OR Data[25]))) XOR (((Data[21] AND Data[47]) XOR (Data[6] AND Data[6])) XOR (Data[30] AND Data[17]))) XOR Data[27]) XOR ((((NOT Data[15]) XOR ((Data[3] XOR Data[36]) XOR Data[50])) XOR ((Data[19] XOR Data[43]) XOR Data[5])) AND Data[5])) OR Data[37]) XOR ((Data[8] OR (((NOT (Data[50] AND Data[50])) XOR (Data[13] OR (Data[19] AND Data[12]))) XOR ((Data[30] OR Data[41]) OR Data[46]))) AND (NOT ((((NOT Data[27]) AND (Data[11] AND Data[13])) XOR Data[20]) XOR ((Data[48] OR Data[22]) OR Data[6]))))) XOR ((Data[13] OR (NOT (((NOT Data[22]) XOR ((Data[33] XOR Data[14]) XOR Data[48])) XOR (Data[5] OR Data[41])))) AND (((NOT (NOT Data[3])) XOR (((((Data[31] XOR Data[46]) XOR Data[41]) XOR (Data[49] AND Data[30])) XOR TRUE) AND ((TRUE XOR (Data[20] AND Data[41])) XOR (NOT Data[13])))) XOR ((((NOT Data[5]) OR (Data[14] AND Data[28])) XOR ((((Data[6] XOR Data[45]) XOR Data[46]) XOR ((Data[30] XOR Data[20]) XOR Data[4])) XOR ((Data[49] XOR Data[9]) XOR Data[19]))) XOR ((Data[19] OR Data[2]) OR Data[43]))))) AND (NOT Data[38]))) OR Data[48]));
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
