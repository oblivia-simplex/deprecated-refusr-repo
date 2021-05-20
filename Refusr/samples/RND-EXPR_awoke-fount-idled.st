(*
This code implements a randomly grown symbolic expression:

!(xor(xor(IN7, (xor(xor(IN10 | (xor(xor(IN35 & (((xor(xor(IN23, IN37), IN21)) & (IN38 & IN15)) | (xor(xor(xor(xor(IN32, IN34), IN21), false & IN13), IN2 | IN26))), IN35 & (((xor(xor(IN7, IN2), false)) | (!(IN1))) | (xor(xor(!(IN25), xor(xor(IN45, IN1), IN42)), IN26 | IN16)))), xor(xor((xor(xor(!(IN35), IN47 | IN5), IN39 & IN10)) & ((xor(xor(IN16, IN37), IN23)) | (!(IN48))), !(IN46)), !(!(!(IN21)))))), IN28), false)) & (xor(xor(xor(xor((((xor(xor(xor(xor(IN46, IN37), IN44), IN29 & IN42), IN10 | false)) | (xor(xor(IN38 & false, IN30 & IN3), true))) | (((xor(xor(IN14, IN23), IN50)) & (xor(xor(IN24, IN27), IN22))) | ((xor(xor(IN18, IN21), IN34)) & (true | IN4)))) & (xor(xor((xor(xor(xor(xor(IN29, IN24), true), IN12 & IN14), IN2 | IN19)) & (!(IN30 & IN14)), (IN10 | (!(IN9))) | ((IN42 & IN44) & (IN33 & IN25))), IN5)), IN3 & ((xor(xor((IN36 & IN29) & (IN6 | IN45), xor(xor(!(IN2), !(IN10)), IN20)), IN43)) & (!((IN33 | IN35) | (xor(xor(IN50, IN35), IN48)))))), xor(xor((xor(xor(!(!(IN46)), IN34 | (IN35 | IN49)), (!(IN34)) & (IN10 & IN4))) & (IN15 | IN25), IN22), (xor(xor(xor(xor(IN30, IN12 | IN23), !(IN14)), IN1), (IN4 | IN32) & (!(IN48)))) | (((xor(xor(IN50, true), IN31)) & (xor(xor(IN22, IN32), IN34))) | (xor(xor(IN37, !(IN49)), IN22))))), xor(xor(!(xor(xor(xor(xor((IN48 & IN24) | (xor(xor(IN41, IN39), IN11)), IN14), IN11), IN39 & (!(IN10 | IN49))), IN44)), ((!(!(!(IN50)))) & ((xor(xor(IN35, !(IN50)), IN32 | IN49)) & (xor(xor(IN21 & IN42, true & IN25), IN4 & IN31)))) | (((!(IN21)) | (!(xor(xor(IN1, IN30), IN46)))) & (((IN6 | IN8) & (xor(xor(IN43, IN10), false))) | IN6))), xor(xor((xor(xor((IN34 | IN3) & (!(IN18)), (!(IN14)) & true), xor(xor(xor(xor(IN15, IN7), IN34), !(IN31)), IN20 | IN18))) | (((IN1 | IN1) & (IN5 | IN27)) | IN17), xor(xor((xor(xor(xor(xor(IN32, IN10), IN1), IN35 | IN32), IN8)) & (IN11 & (IN14 | IN16)), !((IN20 & IN44) | (IN6 | IN15))), (xor(xor(IN35 | IN40, !(IN35)), IN3 | IN48)) | (!(IN46)))), (!(IN14)) & IN7))), (xor(xor(!(xor(xor(IN18, xor(xor(IN24 & IN23, !(IN40)), xor(xor(IN27, IN31), IN35))), !(xor(xor(false, IN48), IN6)))), (!((IN23 | IN37) & (IN8 | IN41))) & IN25), IN5 | (((xor(xor(IN41, IN26), IN3)) & (IN46 | IN22)) | ((IN49 & IN45) & (IN42 & IN16))))) | ((((!(IN47)) | true) & (IN30 | ((IN46 & IN30) | (!(IN43))))) | (((xor(xor(IN37, !(IN40)), !(IN4))) | (IN11 & (!(IN40)))) | (xor(xor(xor(xor(IN46 | IN15, IN9 | IN2), !(IN15)), xor(xor(!(IN46), false), IN36 & IN44)), !(!(IN27))))))))), !(IN35 & (xor(xor((xor(xor(xor(xor(!(xor(xor(IN12, IN9), IN31)), (xor(xor(IN35, IN38), IN3)) | (xor(xor(IN47, IN13), IN8))), (IN36 & false) | (IN13 | IN46)), IN19), (IN47 & (IN46 | IN35)) | IN25)) & (xor(xor(xor(xor((IN14 | IN37) | (IN10 | IN3), IN39 & IN30), xor(xor(IN33 & IN5, xor(xor(IN39, IN48), IN16)), !(IN33))), !(IN38)), !(!(IN33 | IN3)))), IN48), IN20)))))

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
    Out := (NOT ((Data[7] XOR ((((Data[10] OR (((Data[35] AND ((((Data[23] XOR Data[37]) XOR Data[21]) AND (Data[38] AND Data[15])) OR ((((Data[32] XOR Data[34]) XOR Data[21]) XOR (FALSE AND Data[13])) XOR (Data[2] OR Data[26])))) XOR (Data[35] AND ((((Data[7] XOR Data[2]) XOR FALSE) OR (NOT Data[1])) OR (((NOT Data[25]) XOR ((Data[45] XOR Data[1]) XOR Data[42])) XOR (Data[26] OR Data[16]))))) XOR ((((((NOT Data[35]) XOR (Data[47] OR Data[5])) XOR (Data[39] AND Data[10])) AND (((Data[16] XOR Data[37]) XOR Data[23]) OR (NOT Data[48]))) XOR (NOT Data[46])) XOR (NOT (NOT (NOT Data[21])))))) XOR Data[28]) XOR FALSE) AND (((((((((((Data[46] XOR Data[37]) XOR Data[44]) XOR (Data[29] AND Data[42])) XOR (Data[10] OR FALSE)) OR (((Data[38] AND FALSE) XOR (Data[30] AND Data[3])) XOR TRUE)) OR ((((Data[14] XOR Data[23]) XOR Data[50]) AND ((Data[24] XOR Data[27]) XOR Data[22])) OR (((Data[18] XOR Data[21]) XOR Data[34]) AND (TRUE OR Data[4])))) AND (((((((Data[29] XOR Data[24]) XOR TRUE) XOR (Data[12] AND Data[14])) XOR (Data[2] OR Data[19])) AND (NOT (Data[30] AND Data[14]))) XOR ((Data[10] OR (NOT Data[9])) OR ((Data[42] AND Data[44]) AND (Data[33] AND Data[25])))) XOR Data[5])) XOR (Data[3] AND (((((Data[36] AND Data[29]) AND (Data[6] OR Data[45])) XOR (((NOT Data[2]) XOR (NOT Data[10])) XOR Data[20])) XOR Data[43]) AND (NOT ((Data[33] OR Data[35]) OR ((Data[50] XOR Data[35]) XOR Data[48])))))) XOR ((((((NOT (NOT Data[46])) XOR (Data[34] OR (Data[35] OR Data[49]))) XOR ((NOT Data[34]) AND (Data[10] AND Data[4]))) AND (Data[15] OR Data[25])) XOR Data[22]) XOR (((((Data[30] XOR (Data[12] OR Data[23])) XOR (NOT Data[14])) XOR Data[1]) XOR ((Data[4] OR Data[32]) AND (NOT Data[48]))) OR ((((Data[50] XOR TRUE) XOR Data[31]) AND ((Data[22] XOR Data[32]) XOR Data[34])) OR ((Data[37] XOR (NOT Data[49])) XOR Data[22]))))) XOR (((NOT ((((((Data[48] AND Data[24]) OR ((Data[41] XOR Data[39]) XOR Data[11])) XOR Data[14]) XOR Data[11]) XOR (Data[39] AND (NOT (Data[10] OR Data[49])))) XOR Data[44])) XOR (((NOT (NOT (NOT Data[50]))) AND (((Data[35] XOR (NOT Data[50])) XOR (Data[32] OR Data[49])) AND (((Data[21] AND Data[42]) XOR (TRUE AND Data[25])) XOR (Data[4] AND Data[31])))) OR (((NOT Data[21]) OR (NOT ((Data[1] XOR Data[30]) XOR Data[46]))) AND (((Data[6] OR Data[8]) AND ((Data[43] XOR Data[10]) XOR FALSE)) OR Data[6])))) XOR (((((((Data[34] OR Data[3]) AND (NOT Data[18])) XOR ((NOT Data[14]) AND TRUE)) XOR ((((Data[15] XOR Data[7]) XOR Data[34]) XOR (NOT Data[31])) XOR (Data[20] OR Data[18]))) OR (((Data[1] OR Data[1]) AND (Data[5] OR Data[27])) OR Data[17])) XOR (((((((Data[32] XOR Data[10]) XOR Data[1]) XOR (Data[35] OR Data[32])) XOR Data[8]) AND (Data[11] AND (Data[14] OR Data[16]))) XOR (NOT ((Data[20] AND Data[44]) OR (Data[6] OR Data[15])))) XOR ((((Data[35] OR Data[40]) XOR (NOT Data[35])) XOR (Data[3] OR Data[48])) OR (NOT Data[46])))) XOR ((NOT Data[14]) AND Data[7])))) XOR ((((NOT ((Data[18] XOR (((Data[24] AND Data[23]) XOR (NOT Data[40])) XOR ((Data[27] XOR Data[31]) XOR Data[35]))) XOR (NOT ((FALSE XOR Data[48]) XOR Data[6])))) XOR ((NOT ((Data[23] OR Data[37]) AND (Data[8] OR Data[41]))) AND Data[25])) XOR (Data[5] OR ((((Data[41] XOR Data[26]) XOR Data[3]) AND (Data[46] OR Data[22])) OR ((Data[49] AND Data[45]) AND (Data[42] AND Data[16]))))) OR ((((NOT Data[47]) OR TRUE) AND (Data[30] OR ((Data[46] AND Data[30]) OR (NOT Data[43])))) OR ((((Data[37] XOR (NOT Data[40])) XOR (NOT Data[4])) OR (Data[11] AND (NOT Data[40]))) OR (((((Data[46] OR Data[15]) XOR (Data[9] OR Data[2])) XOR (NOT Data[15])) XOR (((NOT Data[46]) XOR FALSE) XOR (Data[36] AND Data[44]))) XOR (NOT (NOT Data[27]))))))))) XOR (NOT (Data[35] AND ((((((((NOT ((Data[12] XOR Data[9]) XOR Data[31])) XOR (((Data[35] XOR Data[38]) XOR Data[3]) OR ((Data[47] XOR Data[13]) XOR Data[8]))) XOR ((Data[36] AND FALSE) OR (Data[13] OR Data[46]))) XOR Data[19]) XOR ((Data[47] AND (Data[46] OR Data[35])) OR Data[25])) AND ((((((Data[14] OR Data[37]) OR (Data[10] OR Data[3])) XOR (Data[39] AND Data[30])) XOR (((Data[33] AND Data[5]) XOR ((Data[39] XOR Data[48]) XOR Data[16])) XOR (NOT Data[33]))) XOR (NOT Data[38])) XOR (NOT (NOT (Data[33] OR Data[3]))))) XOR Data[48]) XOR Data[20])))));
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
