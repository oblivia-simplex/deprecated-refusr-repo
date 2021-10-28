(*
This code implements a randomly grown symbolic expression:

(IN29 | (((!(IN27)) | (xor(xor(!(xor(xor(!((!(IN8)) & IN9), xor(xor(xor(xor(xor(xor(IN14, IN9), IN41), xor(xor(IN8, IN28), false)), xor(xor(IN9, IN9), IN2)), !(xor(xor(IN2, IN5), IN41))), (!(IN28)) & (xor(xor(IN12, IN39), IN7)))), IN36)), xor(xor(true, !(((IN30 | IN20) | IN9) & IN3)), xor(xor(false, (!(IN31)) | (xor(xor(IN41 | IN5, IN49 & IN1), !(IN13)))), xor(xor((IN28 | IN50) | (!(IN16)), (xor(xor(IN42, IN4), IN6)) | (xor(xor(IN38, IN42), IN36))), (xor(xor(IN46, IN18), IN35)) & (IN39 & IN11))))), IN39))) & (!(xor(xor(IN22 | ((!(xor(xor(IN21, IN5), IN41 & IN1))) | (xor(xor(xor(xor(IN15 | IN13, IN38 | IN6), !(IN1)), IN29), IN48))), IN18), IN3))))) | (!(!((((IN22 | (xor(xor(!(xor(xor(IN30, false), IN5)), !(IN14 | IN3)), !(IN48)))) | ((((!(IN28)) & (xor(xor(IN29, IN6), IN15))) & ((IN8 & IN49) | IN23)) & (((IN12 & IN1) | (xor(xor(IN43, IN5), IN47))) & ((!(IN33)) | (true | IN20))))) & ((!(IN50 | (!(IN5 | IN30)))) & IN40)) & (xor(xor((xor(xor((xor(xor(xor(xor(IN22, IN30), IN10), IN50), IN23 | IN47)) | (IN1 & (xor(xor(IN46, IN29), IN24))), IN24), ((IN2 & IN18) | (IN26 | IN47)) | ((!(IN19)) & IN35))) | ((IN33 & (!(IN25 | IN20))) | (xor(xor((xor(xor(IN40, IN13), IN19)) & (xor(xor(IN2, IN37), IN10)), (IN49 | IN40) & IN19), (xor(xor(IN25, IN24), IN14)) & (IN22 & IN32)))), (!(!((xor(xor(IN42, IN8), IN1)) & (!(IN42))))) & ((!(IN23 & IN19)) | ((!(IN29 & IN50)) & (!(IN8 & IN35))))), !(xor(xor(xor(xor((IN29 & IN22) & (!(IN14)), (IN32 & IN20) & (xor(xor(IN7, IN24), IN7))), (true & IN45) | (IN31 | IN44)), (xor(xor(!(IN45), IN35 | IN9), IN40 | IN3)) | ((xor(xor(IN5, IN37), IN27)) | (xor(xor(IN25, IN45), IN32)))), (false & (IN9 | IN18)) | (xor(xor(IN8, xor(xor(IN10, IN26), IN25)), !(IN39))))))))))

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
    Out := ((Data[29] OR (((NOT Data[27]) OR (((NOT (((NOT ((NOT Data[8]) AND Data[9])) XOR ((((((Data[14] XOR Data[9]) XOR Data[41]) XOR ((Data[8] XOR Data[28]) XOR FALSE)) XOR ((Data[9] XOR Data[9]) XOR Data[2])) XOR (NOT ((Data[2] XOR Data[5]) XOR Data[41]))) XOR ((NOT Data[28]) AND ((Data[12] XOR Data[39]) XOR Data[7])))) XOR Data[36])) XOR ((TRUE XOR (NOT (((Data[30] OR Data[20]) OR Data[9]) AND Data[3]))) XOR ((FALSE XOR ((NOT Data[31]) OR (((Data[41] OR Data[5]) XOR (Data[49] AND Data[1])) XOR (NOT Data[13])))) XOR ((((Data[28] OR Data[50]) OR (NOT Data[16])) XOR (((Data[42] XOR Data[4]) XOR Data[6]) OR ((Data[38] XOR Data[42]) XOR Data[36]))) XOR (((Data[46] XOR Data[18]) XOR Data[35]) AND (Data[39] AND Data[11])))))) XOR Data[39])) AND (NOT (((Data[22] OR ((NOT ((Data[21] XOR Data[5]) XOR (Data[41] AND Data[1]))) OR (((((Data[15] OR Data[13]) XOR (Data[38] OR Data[6])) XOR (NOT Data[1])) XOR Data[29]) XOR Data[48]))) XOR Data[18]) XOR Data[3])))) OR (NOT (NOT ((((Data[22] OR (((NOT ((Data[30] XOR FALSE) XOR Data[5])) XOR (NOT (Data[14] OR Data[3]))) XOR (NOT Data[48]))) OR ((((NOT Data[28]) AND ((Data[29] XOR Data[6]) XOR Data[15])) AND ((Data[8] AND Data[49]) OR Data[23])) AND (((Data[12] AND Data[1]) OR ((Data[43] XOR Data[5]) XOR Data[47])) AND ((NOT Data[33]) OR (TRUE OR Data[20]))))) AND ((NOT (Data[50] OR (NOT (Data[5] OR Data[30])))) AND Data[40])) AND ((((((((((Data[22] XOR Data[30]) XOR Data[10]) XOR Data[50]) XOR (Data[23] OR Data[47])) OR (Data[1] AND ((Data[46] XOR Data[29]) XOR Data[24]))) XOR Data[24]) XOR (((Data[2] AND Data[18]) OR (Data[26] OR Data[47])) OR ((NOT Data[19]) AND Data[35]))) OR ((Data[33] AND (NOT (Data[25] OR Data[20]))) OR (((((Data[40] XOR Data[13]) XOR Data[19]) AND ((Data[2] XOR Data[37]) XOR Data[10])) XOR ((Data[49] OR Data[40]) AND Data[19])) XOR (((Data[25] XOR Data[24]) XOR Data[14]) AND (Data[22] AND Data[32]))))) XOR ((NOT (NOT (((Data[42] XOR Data[8]) XOR Data[1]) AND (NOT Data[42])))) AND ((NOT (Data[23] AND Data[19])) OR ((NOT (Data[29] AND Data[50])) AND (NOT (Data[8] AND Data[35])))))) XOR (NOT ((((((Data[29] AND Data[22]) AND (NOT Data[14])) XOR ((Data[32] AND Data[20]) AND ((Data[7] XOR Data[24]) XOR Data[7]))) XOR ((TRUE AND Data[45]) OR (Data[31] OR Data[44]))) XOR ((((NOT Data[45]) XOR (Data[35] OR Data[9])) XOR (Data[40] OR Data[3])) OR (((Data[5] XOR Data[37]) XOR Data[27]) OR ((Data[25] XOR Data[45]) XOR Data[32])))) XOR ((FALSE AND (Data[9] OR Data[18])) OR ((Data[8] XOR ((Data[10] XOR Data[26]) XOR Data[25])) XOR (NOT Data[39]))))))))));
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
