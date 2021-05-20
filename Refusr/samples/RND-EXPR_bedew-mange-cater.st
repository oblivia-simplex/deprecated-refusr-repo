(*
This code implements a randomly grown symbolic expression:

xor(xor(((IN24 & (!(!(!(!((xor(xor(IN2, IN14), IN42)) & (!(IN8)))))))) | (!(!(!(IN31))))) | (xor(xor(((!((xor(xor((!(IN48)) | IN14, (xor(xor(IN19, IN16), IN34)) | IN30), (IN21 & IN10) & (IN24 | IN42))) & ((!(IN18)) | (xor(xor(IN48 | IN26, IN13 & IN15), xor(xor(IN39, IN12), IN50)))))) | ((!(xor(xor(!(xor(xor(IN49, IN23), IN44)), (!(IN11)) | (IN19 & IN50)), (!(IN17)) | IN32))) | ((xor(xor(IN22, IN12), xor(xor(!(IN35), !(IN5)), true))) | ((xor(xor(IN6 & IN2, IN32 | IN31), !(IN25))) | (!(IN39 & IN31)))))) | ((!(IN36)) | (!((!((IN35 | IN29) | (!(IN6)))) | IN42))), xor(xor(IN30, !(((xor(xor((IN5 & IN7) | IN29, (!(IN3)) | (IN47 & IN30)), IN2 & IN19)) | (((xor(xor(IN31, IN32), IN37)) | IN41) | (!(xor(xor(IN21, IN32), IN43))))) | IN15)), ((xor(xor(xor(xor(xor(xor(IN47, !(IN39)), IN19 & IN23), !(xor(xor(IN27, IN7), IN23))), (!(IN22)) & (!(IN40))), IN48 & ((IN50 | IN19) & (IN47 | IN3))), ((IN32 | IN4) | (IN17 & IN30)) & IN37)) | (!(!(IN50)))) & IN14)), IN41 & ((IN25 | ((((!(IN1)) & (IN14 | IN42)) | IN34) | ((!(xor(xor(IN8, IN37), IN49))) & (xor(xor(IN47, xor(xor(IN47, IN25), IN41)), !(IN37)))))) | ((((xor(xor(IN9, !(IN1)), IN6 & IN49)) | (xor(xor(xor(xor(IN11, false), IN4), IN31 | IN5), IN43 | IN9))) & (!(xor(xor(xor(xor(IN19, true), IN44), xor(xor(IN42, IN30), IN15)), IN18 | IN23)))) | ((xor(xor(!(IN5), (IN19 & IN29) | (IN13 & IN17)), (IN18 & IN44) & (xor(xor(IN31, IN31), IN16)))) | (IN22 | ((IN33 & IN41) | IN2))))))), (!(IN3)) & ((!(xor(xor((xor(xor((!(IN16 | IN16)) | (IN10 | (xor(xor(IN5, IN43), IN37))), !((xor(xor(IN20, IN7), IN23)) & (IN44 & IN19))), !((IN5 | IN25) | (IN31 & IN25)))) | (xor(xor((!(IN49 | IN12)) | ((!(IN37)) & (IN24 | false)), xor(xor(!(IN33 & IN45), !(IN49)), (xor(xor(IN12, IN27), IN49)) & (!(IN16)))), (xor(xor(IN43 & IN19, IN11 | IN50), IN29)) & IN34)), !(IN39)), xor(xor(!(IN35), true & ((!(!(IN2))) | ((xor(xor(IN35, IN32), IN44)) & (xor(xor(IN31, IN31), IN33))))), (!((xor(xor(IN1, IN12), IN49)) & (xor(xor(IN7, IN36), IN22)))) | (((IN49 & IN48) | (IN44 & IN4)) | (xor(xor(IN23 | IN1, xor(xor(IN24, IN20), IN10)), IN14 | IN45))))))) & ((!(IN42)) & IN31))), IN6)

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
    Out := (((((Data[24] AND (NOT (NOT (NOT (NOT (((Data[2] XOR Data[14]) XOR Data[42]) AND (NOT Data[8]))))))) OR (NOT (NOT (NOT Data[31])))) OR (((((NOT (((((NOT Data[48]) OR Data[14]) XOR (((Data[19] XOR Data[16]) XOR Data[34]) OR Data[30])) XOR ((Data[21] AND Data[10]) AND (Data[24] OR Data[42]))) AND ((NOT Data[18]) OR (((Data[48] OR Data[26]) XOR (Data[13] AND Data[15])) XOR ((Data[39] XOR Data[12]) XOR Data[50]))))) OR ((NOT (((NOT ((Data[49] XOR Data[23]) XOR Data[44])) XOR ((NOT Data[11]) OR (Data[19] AND Data[50]))) XOR ((NOT Data[17]) OR Data[32]))) OR (((Data[22] XOR Data[12]) XOR (((NOT Data[35]) XOR (NOT Data[5])) XOR TRUE)) OR ((((Data[6] AND Data[2]) XOR (Data[32] OR Data[31])) XOR (NOT Data[25])) OR (NOT (Data[39] AND Data[31])))))) OR ((NOT Data[36]) OR (NOT ((NOT ((Data[35] OR Data[29]) OR (NOT Data[6]))) OR Data[42])))) XOR ((Data[30] XOR (NOT ((((((Data[5] AND Data[7]) OR Data[29]) XOR ((NOT Data[3]) OR (Data[47] AND Data[30]))) XOR (Data[2] AND Data[19])) OR ((((Data[31] XOR Data[32]) XOR Data[37]) OR Data[41]) OR (NOT ((Data[21] XOR Data[32]) XOR Data[43])))) OR Data[15]))) XOR ((((((((Data[47] XOR (NOT Data[39])) XOR (Data[19] AND Data[23])) XOR (NOT ((Data[27] XOR Data[7]) XOR Data[23]))) XOR ((NOT Data[22]) AND (NOT Data[40]))) XOR (Data[48] AND ((Data[50] OR Data[19]) AND (Data[47] OR Data[3])))) XOR (((Data[32] OR Data[4]) OR (Data[17] AND Data[30])) AND Data[37])) OR (NOT (NOT Data[50]))) AND Data[14]))) XOR (Data[41] AND ((Data[25] OR ((((NOT Data[1]) AND (Data[14] OR Data[42])) OR Data[34]) OR ((NOT ((Data[8] XOR Data[37]) XOR Data[49])) AND ((Data[47] XOR ((Data[47] XOR Data[25]) XOR Data[41])) XOR (NOT Data[37]))))) OR (((((Data[9] XOR (NOT Data[1])) XOR (Data[6] AND Data[49])) OR ((((Data[11] XOR FALSE) XOR Data[4]) XOR (Data[31] OR Data[5])) XOR (Data[43] OR Data[9]))) AND (NOT ((((Data[19] XOR TRUE) XOR Data[44]) XOR ((Data[42] XOR Data[30]) XOR Data[15])) XOR (Data[18] OR Data[23])))) OR ((((NOT Data[5]) XOR ((Data[19] AND Data[29]) OR (Data[13] AND Data[17]))) XOR ((Data[18] AND Data[44]) AND ((Data[31] XOR Data[31]) XOR Data[16]))) OR (Data[22] OR ((Data[33] AND Data[41]) OR Data[2])))))))) XOR ((NOT Data[3]) AND ((NOT (((((((NOT (Data[16] OR Data[16])) OR (Data[10] OR ((Data[5] XOR Data[43]) XOR Data[37]))) XOR (NOT (((Data[20] XOR Data[7]) XOR Data[23]) AND (Data[44] AND Data[19])))) XOR (NOT ((Data[5] OR Data[25]) OR (Data[31] AND Data[25])))) OR ((((NOT (Data[49] OR Data[12])) OR ((NOT Data[37]) AND (Data[24] OR FALSE))) XOR (((NOT (Data[33] AND Data[45])) XOR (NOT Data[49])) XOR (((Data[12] XOR Data[27]) XOR Data[49]) AND (NOT Data[16])))) XOR ((((Data[43] AND Data[19]) XOR (Data[11] OR Data[50])) XOR Data[29]) AND Data[34]))) XOR (NOT Data[39])) XOR (((NOT Data[35]) XOR (TRUE AND ((NOT (NOT Data[2])) OR (((Data[35] XOR Data[32]) XOR Data[44]) AND ((Data[31] XOR Data[31]) XOR Data[33]))))) XOR ((NOT (((Data[1] XOR Data[12]) XOR Data[49]) AND ((Data[7] XOR Data[36]) XOR Data[22]))) OR (((Data[49] AND Data[48]) OR (Data[44] AND Data[4])) OR (((Data[23] OR Data[1]) XOR ((Data[24] XOR Data[20]) XOR Data[10])) XOR (Data[14] OR Data[45]))))))) AND ((NOT Data[42]) AND Data[31])))) XOR Data[6]);
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
