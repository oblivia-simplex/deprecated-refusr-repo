(*
This code implements a randomly grown symbolic expression:

IN3 | (xor(xor(IN43 | ((xor(xor(!(((xor(xor(IN13, IN9 | false), xor(xor(IN25, IN14), IN11))) | (xor(xor(xor(xor(IN36, IN12), IN39), IN13 & IN34), IN47))) | (xor(xor(IN5, (IN1 & IN27) | (!(IN46))), !(!(IN21))))), IN37), xor(xor(!(!(IN1)), !((xor(xor(IN30, false), xor(xor(IN49, IN30), IN25))) & (!(xor(xor(IN21, IN32), IN27))))), (xor(xor(!(xor(xor(IN12, IN39), IN41)), (IN22 & IN36) & (IN27 | IN16)), IN15)) | (!((IN24 | IN40) | (!(IN45))))))) & (xor(xor(!((!((false | IN41) & (!(IN49)))) | (((IN6 & IN32) & IN14) & (!(IN27 & IN33)))), xor(xor(xor(xor(IN38, (!(IN43 & IN26)) & ((IN34 & IN40) & (IN5 & IN12))), !(xor(xor(xor(xor(IN8, IN19), IN14), IN15 & IN11), IN30 & IN31))), ((xor(xor(IN24, IN1 | IN19), true | IN1)) & IN27) & ((IN25 | (IN21 | IN15)) & (IN13 & (IN19 & IN30)))), (((IN33 & true) | (IN35 | IN7)) & (xor(xor(true | IN16, IN48), IN43 & IN22))) & ((!(xor(xor(IN38, IN35), IN42))) & (!(IN39))))), xor(xor(IN6, (xor(xor(xor(xor(xor(xor(IN6, IN45), IN26), !(IN35)), IN32 | IN15), (!(IN15)) & (IN36 | IN34)), (xor(xor(IN47, IN47), IN44)) & (!(IN14)))) & (((IN13 & IN4) | (IN1 | IN38)) | ((IN46 & IN11) & (IN32 | IN24)))), IN18)))), !(xor(xor(!(!(xor(xor(IN1, !((xor(xor(IN33, IN25), IN4)) & (IN40 | IN38))), xor(xor(IN12, xor(xor(xor(xor(IN24, IN3), IN41), !(IN13)), IN50 & IN19)), (xor(xor(IN37, IN25), IN21)) | IN4)))), !(IN23)), (!((!((!(IN20)) & (IN23 & IN14))) | (IN43 | (xor(xor(IN27 & IN10, IN34), xor(xor(IN31, IN6), IN4)))))) | ((((!(IN27 | IN41)) | ((IN12 | IN28) | IN22)) & IN29) & (IN50 & (IN1 | ((xor(xor(IN49, IN28), IN4)) | (IN33 & IN4)))))))), (!((xor(xor((!(xor(xor(!(IN27), xor(xor(IN4, IN6), IN33)), IN31 & true))) | (!((xor(xor(IN40, IN39), IN27)) & (IN13 & IN12))), (((IN25 & IN4) & (!(IN17))) & (xor(xor(true | IN33, IN38), IN16))) & (xor(xor(IN44, !(xor(xor(IN27, IN40), IN11))), xor(xor(IN36 & IN37, IN15 | IN33), IN21)))), IN17 | (IN33 | ((IN2 & IN1) | IN33)))) & (((((IN33 & false) | (IN37 | IN18)) | (!(IN28))) & (xor(xor((IN38 | IN8) | (!(IN12)), !(IN1 | IN1)), IN30))) | (xor(xor((xor(xor(IN47 & IN24, IN47 & IN36), IN9)) & (!(IN31 & IN18)), xor(xor((!(IN49)) & IN4, (IN44 & IN19) | (IN26 | IN18)), !(!(IN34)))), !(IN32 & (IN33 | IN47))))))) | ((xor(xor(IN13, (!(true | (xor(xor(!(IN35), IN15 | IN4), xor(xor(IN35, IN27), IN15))))) & ((xor(xor(!(IN18 & IN31), IN22 | (IN7 & IN11)), !(xor(xor(IN37, IN45), IN24)))) & IN23)), IN35)) & IN5)))

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
    Out := (Data[3] OR (((Data[43] OR ((((NOT ((((Data[13] XOR (Data[9] OR FALSE)) XOR ((Data[25] XOR Data[14]) XOR Data[11])) OR ((((Data[36] XOR Data[12]) XOR Data[39]) XOR (Data[13] AND Data[34])) XOR Data[47])) OR ((Data[5] XOR ((Data[1] AND Data[27]) OR (NOT Data[46]))) XOR (NOT (NOT Data[21]))))) XOR Data[37]) XOR (((NOT (NOT Data[1])) XOR (NOT (((Data[30] XOR FALSE) XOR ((Data[49] XOR Data[30]) XOR Data[25])) AND (NOT ((Data[21] XOR Data[32]) XOR Data[27]))))) XOR ((((NOT ((Data[12] XOR Data[39]) XOR Data[41])) XOR ((Data[22] AND Data[36]) AND (Data[27] OR Data[16]))) XOR Data[15]) OR (NOT ((Data[24] OR Data[40]) OR (NOT Data[45])))))) AND (((NOT ((NOT ((FALSE OR Data[41]) AND (NOT Data[49]))) OR (((Data[6] AND Data[32]) AND Data[14]) AND (NOT (Data[27] AND Data[33]))))) XOR ((((Data[38] XOR ((NOT (Data[43] AND Data[26])) AND ((Data[34] AND Data[40]) AND (Data[5] AND Data[12])))) XOR (NOT ((((Data[8] XOR Data[19]) XOR Data[14]) XOR (Data[15] AND Data[11])) XOR (Data[30] AND Data[31])))) XOR ((((Data[24] XOR (Data[1] OR Data[19])) XOR (TRUE OR Data[1])) AND Data[27]) AND ((Data[25] OR (Data[21] OR Data[15])) AND (Data[13] AND (Data[19] AND Data[30]))))) XOR ((((Data[33] AND TRUE) OR (Data[35] OR Data[7])) AND (((TRUE OR Data[16]) XOR Data[48]) XOR (Data[43] AND Data[22]))) AND ((NOT ((Data[38] XOR Data[35]) XOR Data[42])) AND (NOT Data[39]))))) XOR ((Data[6] XOR (((((((Data[6] XOR Data[45]) XOR Data[26]) XOR (NOT Data[35])) XOR (Data[32] OR Data[15])) XOR ((NOT Data[15]) AND (Data[36] OR Data[34]))) XOR (((Data[47] XOR Data[47]) XOR Data[44]) AND (NOT Data[14]))) AND (((Data[13] AND Data[4]) OR (Data[1] OR Data[38])) OR ((Data[46] AND Data[11]) AND (Data[32] OR Data[24]))))) XOR Data[18])))) XOR (NOT (((NOT (NOT ((Data[1] XOR (NOT (((Data[33] XOR Data[25]) XOR Data[4]) AND (Data[40] OR Data[38])))) XOR ((Data[12] XOR ((((Data[24] XOR Data[3]) XOR Data[41]) XOR (NOT Data[13])) XOR (Data[50] AND Data[19]))) XOR (((Data[37] XOR Data[25]) XOR Data[21]) OR Data[4]))))) XOR (NOT Data[23])) XOR ((NOT ((NOT ((NOT Data[20]) AND (Data[23] AND Data[14]))) OR (Data[43] OR (((Data[27] AND Data[10]) XOR Data[34]) XOR ((Data[31] XOR Data[6]) XOR Data[4]))))) OR ((((NOT (Data[27] OR Data[41])) OR ((Data[12] OR Data[28]) OR Data[22])) AND Data[29]) AND (Data[50] AND (Data[1] OR (((Data[49] XOR Data[28]) XOR Data[4]) OR (Data[33] AND Data[4]))))))))) XOR ((NOT (((((NOT (((NOT Data[27]) XOR ((Data[4] XOR Data[6]) XOR Data[33])) XOR (Data[31] AND TRUE))) OR (NOT (((Data[40] XOR Data[39]) XOR Data[27]) AND (Data[13] AND Data[12])))) XOR ((((Data[25] AND Data[4]) AND (NOT Data[17])) AND (((TRUE OR Data[33]) XOR Data[38]) XOR Data[16])) AND ((Data[44] XOR (NOT ((Data[27] XOR Data[40]) XOR Data[11]))) XOR (((Data[36] AND Data[37]) XOR (Data[15] OR Data[33])) XOR Data[21])))) XOR (Data[17] OR (Data[33] OR ((Data[2] AND Data[1]) OR Data[33])))) AND (((((Data[33] AND FALSE) OR (Data[37] OR Data[18])) OR (NOT Data[28])) AND ((((Data[38] OR Data[8]) OR (NOT Data[12])) XOR (NOT (Data[1] OR Data[1]))) XOR Data[30])) OR ((((((Data[47] AND Data[24]) XOR (Data[47] AND Data[36])) XOR Data[9]) AND (NOT (Data[31] AND Data[18]))) XOR ((((NOT Data[49]) AND Data[4]) XOR ((Data[44] AND Data[19]) OR (Data[26] OR Data[18]))) XOR (NOT (NOT Data[34])))) XOR (NOT (Data[32] AND (Data[33] OR Data[47]))))))) OR (((Data[13] XOR ((NOT (TRUE OR (((NOT Data[35]) XOR (Data[15] OR Data[4])) XOR ((Data[35] XOR Data[27]) XOR Data[15])))) AND ((((NOT (Data[18] AND Data[31])) XOR (Data[22] OR (Data[7] AND Data[11]))) XOR (NOT ((Data[37] XOR Data[45]) XOR Data[24]))) AND Data[23]))) XOR Data[35]) AND Data[5]))));
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
