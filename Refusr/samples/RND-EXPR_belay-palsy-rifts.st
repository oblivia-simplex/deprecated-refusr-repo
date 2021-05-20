(*
This code implements a randomly grown symbolic expression:

xor(xor((IN16 | IN26) & ((((xor(xor(!(xor(xor(IN38 | (!(IN38)), !(!(IN8))), !(xor(xor(IN44, IN37), IN27)))), (((!(IN1)) & (IN27 | IN45)) | (IN40 & (IN38 & IN27))) & IN36), ((!(!(IN43))) | ((xor(xor(IN16, IN18), IN25)) & (IN45 & IN43))) & (((!(IN16)) | (IN31 & IN9)) & (xor(xor(IN8, IN40), IN38 | IN17))))) & (xor(xor(((!(IN27)) & ((!(IN1)) | (IN35 & IN28))) | ((!(!(IN15))) & IN32), (((IN48 & IN5) | (IN10 | true)) | true) | (xor(xor(false, !(xor(xor(IN43, IN3), IN44))), xor(xor(xor(xor(IN49, IN34), IN16), IN12 | IN26), IN6)))), (IN39 & (xor(xor(IN46 & IN10, IN22 | IN11), xor(xor(IN46, IN12), true)))) | IN28))) | (!((xor(xor(xor(xor((IN45 | IN44) | (IN15 | IN13), (!(IN36)) | (IN45 | IN39)), !(IN9 & IN49)), (xor(xor(xor(xor(IN4, IN37), IN21), xor(xor(IN9, IN19), IN3)), IN30 & IN16)) | (!(xor(xor(IN25, IN45), IN33)))), ((IN40 & IN16) | (!(IN39))) | ((xor(xor(IN25, IN35), IN21)) & (IN30 & IN29)))) | (xor(xor(IN16, (!(IN5 & IN15)) | (!(!(IN18)))), IN49))))) & (IN39 | (!(((IN38 & IN11) & (!((!(IN25)) | (!(IN2))))) | IN25)))), IN25), IN6 & ((!(xor(xor(!(xor(xor(xor(xor((xor(xor(IN45, IN32), IN43)) & (IN9 | IN44), false), xor(xor(IN13 | IN25, IN9 & IN14), IN48 | IN42)), !((!(IN11)) & (!(IN27)))), (!(IN25)) | (!(!(IN48))))), (!(IN15)) | (xor(xor(xor(xor((xor(xor(IN48, false), IN4)) & (xor(xor(IN34, IN46), IN33)), !(xor(xor(IN7, IN46), IN31))), xor(xor(!(IN13), false & IN43), xor(xor(IN13, IN36), IN26))), ((false | IN10) | (IN24 | IN15)) & IN38), IN14 | (xor(xor(IN50, xor(xor(IN3, IN1), IN14)), !(IN43)))))), !((xor(xor(!(xor(xor(IN23, false), IN25)), xor(xor(xor(xor(IN21, IN7), IN18), IN32 | IN34), xor(xor(IN28, IN2), IN43))), IN35)) | (((!(IN47)) & (IN50 | IN28)) | (xor(xor(IN45 | IN1, IN16 & IN45), IN29))))))) & (xor(xor(!(xor(xor(xor(xor(IN32, xor(xor(!(IN42 & IN4), IN22), IN42 & (!(IN46)))), xor(xor(IN6, (!(IN37)) | (IN11 & IN40)), (!(IN50)) | (false & IN45))), !((IN20 | (!(IN44))) & IN32)), !(((xor(xor(IN19, IN36), IN22)) | (IN38 & IN45)) & (!(!(IN35)))))), xor(xor(!(IN34), (!(IN3)) | IN50), !((xor(xor((IN16 | IN18) & IN41, xor(xor(IN50, xor(xor(IN2, IN44), IN23)), xor(xor(IN8, IN43), IN19))), xor(xor(IN11 | IN29, !(IN44)), !(IN27)))) | IN45))), (!((!(IN30 | (xor(xor(IN45, IN14), IN20)))) & (xor(xor(!(IN18), (IN13 | false) & (IN8 & IN46)), IN28)))) | IN20))))

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
    Out := ((((Data[16] OR Data[26]) AND ((((((NOT (((Data[38] OR (NOT Data[38])) XOR (NOT (NOT Data[8]))) XOR (NOT ((Data[44] XOR Data[37]) XOR Data[27])))) XOR ((((NOT Data[1]) AND (Data[27] OR Data[45])) OR (Data[40] AND (Data[38] AND Data[27]))) AND Data[36])) XOR (((NOT (NOT Data[43])) OR (((Data[16] XOR Data[18]) XOR Data[25]) AND (Data[45] AND Data[43]))) AND (((NOT Data[16]) OR (Data[31] AND Data[9])) AND ((Data[8] XOR Data[40]) XOR (Data[38] OR Data[17]))))) AND (((((NOT Data[27]) AND ((NOT Data[1]) OR (Data[35] AND Data[28]))) OR ((NOT (NOT Data[15])) AND Data[32])) XOR ((((Data[48] AND Data[5]) OR (Data[10] OR TRUE)) OR TRUE) OR ((FALSE XOR (NOT ((Data[43] XOR Data[3]) XOR Data[44]))) XOR ((((Data[49] XOR Data[34]) XOR Data[16]) XOR (Data[12] OR Data[26])) XOR Data[6])))) XOR ((Data[39] AND (((Data[46] AND Data[10]) XOR (Data[22] OR Data[11])) XOR ((Data[46] XOR Data[12]) XOR TRUE))) OR Data[28]))) OR (NOT (((((((Data[45] OR Data[44]) OR (Data[15] OR Data[13])) XOR ((NOT Data[36]) OR (Data[45] OR Data[39]))) XOR (NOT (Data[9] AND Data[49]))) XOR (((((Data[4] XOR Data[37]) XOR Data[21]) XOR ((Data[9] XOR Data[19]) XOR Data[3])) XOR (Data[30] AND Data[16])) OR (NOT ((Data[25] XOR Data[45]) XOR Data[33])))) XOR (((Data[40] AND Data[16]) OR (NOT Data[39])) OR (((Data[25] XOR Data[35]) XOR Data[21]) AND (Data[30] AND Data[29])))) OR ((Data[16] XOR ((NOT (Data[5] AND Data[15])) OR (NOT (NOT Data[18])))) XOR Data[49])))) AND (Data[39] OR (NOT (((Data[38] AND Data[11]) AND (NOT ((NOT Data[25]) OR (NOT Data[2])))) OR Data[25]))))) XOR Data[25]) XOR (Data[6] AND ((NOT (((NOT (((((((Data[45] XOR Data[32]) XOR Data[43]) AND (Data[9] OR Data[44])) XOR FALSE) XOR (((Data[13] OR Data[25]) XOR (Data[9] AND Data[14])) XOR (Data[48] OR Data[42]))) XOR (NOT ((NOT Data[11]) AND (NOT Data[27])))) XOR ((NOT Data[25]) OR (NOT (NOT Data[48]))))) XOR ((NOT Data[15]) OR (((((((Data[48] XOR FALSE) XOR Data[4]) AND ((Data[34] XOR Data[46]) XOR Data[33])) XOR (NOT ((Data[7] XOR Data[46]) XOR Data[31]))) XOR (((NOT Data[13]) XOR (FALSE AND Data[43])) XOR ((Data[13] XOR Data[36]) XOR Data[26]))) XOR (((FALSE OR Data[10]) OR (Data[24] OR Data[15])) AND Data[38])) XOR (Data[14] OR ((Data[50] XOR ((Data[3] XOR Data[1]) XOR Data[14])) XOR (NOT Data[43])))))) XOR (NOT ((((NOT ((Data[23] XOR FALSE) XOR Data[25])) XOR ((((Data[21] XOR Data[7]) XOR Data[18]) XOR (Data[32] OR Data[34])) XOR ((Data[28] XOR Data[2]) XOR Data[43]))) XOR Data[35]) OR (((NOT Data[47]) AND (Data[50] OR Data[28])) OR (((Data[45] OR Data[1]) XOR (Data[16] AND Data[45])) XOR Data[29])))))) AND (((NOT ((((Data[32] XOR (((NOT (Data[42] AND Data[4])) XOR Data[22]) XOR (Data[42] AND (NOT Data[46])))) XOR ((Data[6] XOR ((NOT Data[37]) OR (Data[11] AND Data[40]))) XOR ((NOT Data[50]) OR (FALSE AND Data[45])))) XOR (NOT ((Data[20] OR (NOT Data[44])) AND Data[32]))) XOR (NOT ((((Data[19] XOR Data[36]) XOR Data[22]) OR (Data[38] AND Data[45])) AND (NOT (NOT Data[35])))))) XOR (((NOT Data[34]) XOR ((NOT Data[3]) OR Data[50])) XOR (NOT (((((Data[16] OR Data[18]) AND Data[41]) XOR ((Data[50] XOR ((Data[2] XOR Data[44]) XOR Data[23])) XOR ((Data[8] XOR Data[43]) XOR Data[19]))) XOR (((Data[11] OR Data[29]) XOR (NOT Data[44])) XOR (NOT Data[27]))) OR Data[45])))) XOR ((NOT ((NOT (Data[30] OR ((Data[45] XOR Data[14]) XOR Data[20]))) AND (((NOT Data[18]) XOR ((Data[13] OR FALSE) AND (Data[8] AND Data[46]))) XOR Data[28]))) OR Data[20])))));
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
