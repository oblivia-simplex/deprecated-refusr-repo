(*
This code implements a randomly grown symbolic expression:

!((IN16 & IN32) & ((xor(xor(xor(xor(IN24 | IN48, (((xor(xor(xor(xor(IN40, true), IN7), xor(xor(IN27, IN44), IN7)), IN6 | IN4)) & ((IN19 | IN14) & (IN40 & IN35))) & ((xor(xor(xor(xor(IN39, IN34), IN48), IN14), IN40)) | ((xor(xor(IN13, IN28), IN42)) & IN45))) & (!(((IN21 | IN2) & (xor(xor(IN10, IN37), IN37))) & (!(IN11))))), xor(xor(xor(xor(xor(xor(IN7, IN46), !(!(IN6))), !(!(IN40 & IN29))), ((IN46 | IN37) & IN8) & ((IN22 | IN10) & (!(IN45)))), IN18 & (((IN3 & IN7) | IN33) | (xor(xor(!(IN41), IN45), IN34 | IN4)))), (xor(xor(xor(xor(!(IN48), true), IN37), IN21), xor(xor(xor(xor(IN22, IN49), IN18), IN23 & IN36), xor(xor(IN50, IN46), IN46)))) & (!((IN47 & IN2) | (IN33 | IN12))))), !(IN49 | ((((!(IN38)) | (IN39 | IN16)) & ((IN6 | IN42) | IN24)) & (!((!(IN17)) & (true | IN18)))))), IN1)) & ((xor(xor(IN37, xor(xor(!(((IN10 | IN47) & (xor(xor(IN39, IN25), IN32))) & (xor(xor(!(IN11), IN27 | IN31), xor(xor(IN28, IN4), IN40)))), (xor(xor(!(IN50 & IN31), IN44), !(IN17 & IN29))) & ((!(IN47)) | ((!(IN16)) & (!(IN24))))), xor(xor(((!(IN19)) & (xor(xor(IN38, IN13), false))) & (xor(xor(IN15, IN34 | IN14), !(IN33))), xor(xor((xor(xor(IN39, IN24), IN44)) & IN42, (!(IN24)) & (xor(xor(IN23, IN12), IN20))), (xor(xor(false, IN3), IN48)) | (xor(xor(IN8, IN18), IN19)))), !((!(IN28)) | IN33)))), xor(xor(!(!(!(IN26 & false))), IN33), IN30 | ((IN48 | IN35) & (xor(xor(IN11 & IN12, IN29 | IN41), !(IN30))))))) & (xor(xor((IN8 & (!((IN8 | IN46) & IN22))) & (((!(IN29 & IN32)) | ((IN9 | IN45) & (!(IN24)))) | (((!(IN41)) | (xor(xor(IN1, IN37), IN29))) & ((IN13 | IN50) | (IN37 | IN11)))), !((xor(xor((IN17 | IN14) | (xor(xor(IN15, true), IN25)), !(xor(xor(IN2, IN26), IN23))), (IN37 | IN15) | (IN44 | IN22))) | ((xor(xor(xor(xor(IN23, IN31), IN33), IN39 | IN21), IN21)) | (!(!(IN19)))))), (!(((IN24 | false) | (xor(xor(IN17, IN50), IN9))) | (xor(xor(IN39 & IN35, IN19 & IN48), IN37 & IN25)))) | IN46)))))

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
    Out := (NOT ((Data[16] AND Data[32]) AND ((((((Data[24] OR Data[48]) XOR (((((((Data[40] XOR TRUE) XOR Data[7]) XOR ((Data[27] XOR Data[44]) XOR Data[7])) XOR (Data[6] OR Data[4])) AND ((Data[19] OR Data[14]) AND (Data[40] AND Data[35]))) AND (((((Data[39] XOR Data[34]) XOR Data[48]) XOR Data[14]) XOR Data[40]) OR (((Data[13] XOR Data[28]) XOR Data[42]) AND Data[45]))) AND (NOT (((Data[21] OR Data[2]) AND ((Data[10] XOR Data[37]) XOR Data[37])) AND (NOT Data[11]))))) XOR ((((((Data[7] XOR Data[46]) XOR (NOT (NOT Data[6]))) XOR (NOT (NOT (Data[40] AND Data[29])))) XOR (((Data[46] OR Data[37]) AND Data[8]) AND ((Data[22] OR Data[10]) AND (NOT Data[45])))) XOR (Data[18] AND (((Data[3] AND Data[7]) OR Data[33]) OR (((NOT Data[41]) XOR Data[45]) XOR (Data[34] OR Data[4]))))) XOR ((((((NOT Data[48]) XOR TRUE) XOR Data[37]) XOR Data[21]) XOR ((((Data[22] XOR Data[49]) XOR Data[18]) XOR (Data[23] AND Data[36])) XOR ((Data[50] XOR Data[46]) XOR Data[46]))) AND (NOT ((Data[47] AND Data[2]) OR (Data[33] OR Data[12])))))) XOR (NOT (Data[49] OR ((((NOT Data[38]) OR (Data[39] OR Data[16])) AND ((Data[6] OR Data[42]) OR Data[24])) AND (NOT ((NOT Data[17]) AND (TRUE OR Data[18]))))))) XOR Data[1]) AND (((Data[37] XOR (((NOT (((Data[10] OR Data[47]) AND ((Data[39] XOR Data[25]) XOR Data[32])) AND (((NOT Data[11]) XOR (Data[27] OR Data[31])) XOR ((Data[28] XOR Data[4]) XOR Data[40])))) XOR ((((NOT (Data[50] AND Data[31])) XOR Data[44]) XOR (NOT (Data[17] AND Data[29]))) AND ((NOT Data[47]) OR ((NOT Data[16]) AND (NOT Data[24]))))) XOR (((((NOT Data[19]) AND ((Data[38] XOR Data[13]) XOR FALSE)) AND ((Data[15] XOR (Data[34] OR Data[14])) XOR (NOT Data[33]))) XOR (((((Data[39] XOR Data[24]) XOR Data[44]) AND Data[42]) XOR ((NOT Data[24]) AND ((Data[23] XOR Data[12]) XOR Data[20]))) XOR (((FALSE XOR Data[3]) XOR Data[48]) OR ((Data[8] XOR Data[18]) XOR Data[19])))) XOR (NOT ((NOT Data[28]) OR Data[33]))))) XOR (((NOT (NOT (NOT (Data[26] AND FALSE)))) XOR Data[33]) XOR (Data[30] OR ((Data[48] OR Data[35]) AND (((Data[11] AND Data[12]) XOR (Data[29] OR Data[41])) XOR (NOT Data[30])))))) AND ((((Data[8] AND (NOT ((Data[8] OR Data[46]) AND Data[22]))) AND (((NOT (Data[29] AND Data[32])) OR ((Data[9] OR Data[45]) AND (NOT Data[24]))) OR (((NOT Data[41]) OR ((Data[1] XOR Data[37]) XOR Data[29])) AND ((Data[13] OR Data[50]) OR (Data[37] OR Data[11]))))) XOR (NOT (((((Data[17] OR Data[14]) OR ((Data[15] XOR TRUE) XOR Data[25])) XOR (NOT ((Data[2] XOR Data[26]) XOR Data[23]))) XOR ((Data[37] OR Data[15]) OR (Data[44] OR Data[22]))) OR (((((Data[23] XOR Data[31]) XOR Data[33]) XOR (Data[39] OR Data[21])) XOR Data[21]) OR (NOT (NOT Data[19])))))) XOR ((NOT (((Data[24] OR FALSE) OR ((Data[17] XOR Data[50]) XOR Data[9])) OR (((Data[39] AND Data[35]) XOR (Data[19] AND Data[48])) XOR (Data[37] AND Data[25])))) OR Data[46]))))));
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
