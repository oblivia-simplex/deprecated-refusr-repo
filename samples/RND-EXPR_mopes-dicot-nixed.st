(*
This code implements a randomly grown symbolic expression:

IN18 | (((xor(xor(xor(xor(IN17 | (xor(xor(IN20 | IN31, !((IN23 | IN3) | (!(IN14)))), xor(xor((!(IN35)) | (!(IN43)), IN8), !(IN28 | IN33)))), false), IN38 & IN24), ((IN39 | (((IN32 | true) | (!(IN47))) | ((xor(xor(IN25, IN42), IN28)) | (IN42 | IN24)))) & ((((xor(xor(IN38, IN18), IN2)) | (IN4 & IN11)) | ((!(IN45)) & (IN8 | IN28))) | (!((!(IN50)) & IN24)))) & (xor(xor(IN18, ((xor(xor(IN35 & IN33, false & IN2), !(IN32))) & (!(IN19 & IN38))) & ((!(xor(xor(IN7, IN2), IN18))) & ((xor(xor(IN48, IN26), false)) & (xor(xor(IN46, IN38), IN13))))), xor(xor(xor(xor(IN13 | (xor(xor(IN37, IN12), IN43)), IN36), xor(xor(IN17 | true, IN49), IN2)), (!(IN33 & IN19)) & IN43), IN7)))), xor(xor(xor(xor(xor(xor(((xor(xor(IN14, IN2), IN34)) & (xor(xor(IN43, IN41), IN11))) | ((IN34 & IN13) | (IN14 & IN33)), !(xor(xor(!(IN26), !(IN28)), !(IN43)))), (xor(xor(IN30, xor(xor(IN38, IN10), IN28)), xor(xor(IN36, IN49), IN11))) | IN9), xor(xor(xor(xor(!(xor(xor(IN48, IN48), IN47)), (!(IN23)) | (IN30 | IN42)), xor(xor(IN21 & IN37, IN19), IN31)), (!(IN28)) | IN38), xor(xor(IN31, !(!(IN19))), IN45))), (xor(xor(IN19, IN15), xor(xor(xor(xor(IN5, IN27), IN1), false), !(IN13)))) & (IN14 & (xor(xor(IN13 & IN11, IN1), xor(xor(true, IN33), IN46))))), IN37), IN6))) | (!(xor(xor((!(((IN13 | IN14) & IN11) | (xor(xor(IN46 & IN42, xor(xor(IN32, IN1), IN3)), !(IN7))))) & IN26, IN17 | IN13), (!(((!(IN34)) & (true & IN40)) & ((xor(xor(IN3, IN6), IN24)) & IN30))) & (((IN21 & (IN16 & IN37)) | (xor(xor(xor(xor(IN47, IN22), IN46), !(IN28)), IN6 | IN26))) | (((xor(xor(IN10, IN47), IN41)) & IN19) | ((!(IN12)) | (!(IN20))))))))) & IN32)

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
    Out := (Data[18] OR (((((((Data[17] OR (((Data[20] OR Data[31]) XOR (NOT ((Data[23] OR Data[3]) OR (NOT Data[14])))) XOR ((((NOT Data[35]) OR (NOT Data[43])) XOR Data[8]) XOR (NOT (Data[28] OR Data[33]))))) XOR FALSE) XOR (Data[38] AND Data[24])) XOR (((Data[39] OR (((Data[32] OR TRUE) OR (NOT Data[47])) OR (((Data[25] XOR Data[42]) XOR Data[28]) OR (Data[42] OR Data[24])))) AND (((((Data[38] XOR Data[18]) XOR Data[2]) OR (Data[4] AND Data[11])) OR ((NOT Data[45]) AND (Data[8] OR Data[28]))) OR (NOT ((NOT Data[50]) AND Data[24])))) AND ((Data[18] XOR (((((Data[35] AND Data[33]) XOR (FALSE AND Data[2])) XOR (NOT Data[32])) AND (NOT (Data[19] AND Data[38]))) AND ((NOT ((Data[7] XOR Data[2]) XOR Data[18])) AND (((Data[48] XOR Data[26]) XOR FALSE) AND ((Data[46] XOR Data[38]) XOR Data[13]))))) XOR (((((Data[13] OR ((Data[37] XOR Data[12]) XOR Data[43])) XOR Data[36]) XOR (((Data[17] OR TRUE) XOR Data[49]) XOR Data[2])) XOR ((NOT (Data[33] AND Data[19])) AND Data[43])) XOR Data[7])))) XOR ((((((((((Data[14] XOR Data[2]) XOR Data[34]) AND ((Data[43] XOR Data[41]) XOR Data[11])) OR ((Data[34] AND Data[13]) OR (Data[14] AND Data[33]))) XOR (NOT (((NOT Data[26]) XOR (NOT Data[28])) XOR (NOT Data[43])))) XOR (((Data[30] XOR ((Data[38] XOR Data[10]) XOR Data[28])) XOR ((Data[36] XOR Data[49]) XOR Data[11])) OR Data[9])) XOR (((((NOT ((Data[48] XOR Data[48]) XOR Data[47])) XOR ((NOT Data[23]) OR (Data[30] OR Data[42]))) XOR (((Data[21] AND Data[37]) XOR Data[19]) XOR Data[31])) XOR ((NOT Data[28]) OR Data[38])) XOR ((Data[31] XOR (NOT (NOT Data[19]))) XOR Data[45]))) XOR (((Data[19] XOR Data[15]) XOR ((((Data[5] XOR Data[27]) XOR Data[1]) XOR FALSE) XOR (NOT Data[13]))) AND (Data[14] AND (((Data[13] AND Data[11]) XOR Data[1]) XOR ((TRUE XOR Data[33]) XOR Data[46]))))) XOR Data[37]) XOR Data[6])) OR (NOT ((((NOT (((Data[13] OR Data[14]) AND Data[11]) OR (((Data[46] AND Data[42]) XOR ((Data[32] XOR Data[1]) XOR Data[3])) XOR (NOT Data[7])))) AND Data[26]) XOR (Data[17] OR Data[13])) XOR ((NOT (((NOT Data[34]) AND (TRUE AND Data[40])) AND (((Data[3] XOR Data[6]) XOR Data[24]) AND Data[30]))) AND (((Data[21] AND (Data[16] AND Data[37])) OR ((((Data[47] XOR Data[22]) XOR Data[46]) XOR (NOT Data[28])) XOR (Data[6] OR Data[26]))) OR ((((Data[10] XOR Data[47]) XOR Data[41]) AND Data[19]) OR ((NOT Data[12]) OR (NOT Data[20])))))))) AND Data[32]));
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
