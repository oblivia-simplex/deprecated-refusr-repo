(*
This code implements a randomly grown symbolic expression:

(xor(xor(xor(xor((((((xor(xor(!(IN12), !(IN17)), xor(xor(IN9, IN18), IN16))) | (!(!(IN37)))) | IN16) & (xor(xor(IN45, (xor(xor(IN41 | IN9, xor(xor(IN35, IN31), IN31)), false & IN31)) | ((xor(xor(IN20, IN44), IN36)) | (IN7 & IN36))), false & IN37))) | IN2) | (IN40 & (xor(xor((xor(xor(xor(xor(IN13, IN26), IN49 | IN33), (xor(xor(IN9, IN4), IN10)) & IN35), (xor(xor(IN38, IN22), IN49)) & (IN26 | IN2))) & (xor(xor((IN21 | IN37) | IN35, xor(xor(xor(xor(IN27, IN35), IN49), IN20), !(IN38))), xor(xor(!(IN24), IN47 & IN9), IN49 & IN17))), (IN2 & ((xor(xor(IN39, true), IN43)) | (!(IN6)))) & (xor(xor(xor(xor(IN32 | IN28, !(IN19)), IN40 | IN22), !(IN3 & IN26)), (IN29 | IN25) | (IN45 & IN27)))), xor(xor((!(IN44)) & IN6, IN29), (!(IN7 & IN11)) | ((false & IN15) | (!(IN19))))))), IN17), xor(xor((IN38 & (IN15 | ((IN27 | (!(IN8))) & (IN23 | (IN11 & IN7))))) | (xor(xor((((xor(xor(IN34, IN2), IN40)) | IN1) | (!(IN9 | IN21))) & (!(xor(xor(IN30 | IN29, xor(xor(IN44, IN42), IN31)), true & IN38))), (IN10 | ((IN10 | IN13) & (IN25 | IN48))) & IN18), xor(xor(!(xor(xor(!(IN15), IN14 & IN49), false)), IN16), IN33))), IN13), xor(xor(!((((!(IN21)) & IN46) | (!(!(IN30)))) | (!((xor(xor(IN29, IN30), IN17)) | (xor(xor(IN48, IN6), IN1))))), xor(xor(!(IN18), (((!(IN34)) & (IN25 | IN49)) & (!(IN46 | IN49))) & (!(xor(xor(xor(xor(IN12, IN43), IN16), IN41), IN17)))), IN11 | (IN5 | false))), ((((!(IN35)) | (xor(xor(IN23, IN39), IN8))) & IN6) & (!(xor(xor(IN21 & IN34, true | IN14), xor(xor(IN23, IN26), IN5))))) & IN28))), !(!(IN4))), (IN38 | (xor(xor(!(IN16 | (IN25 & (!(!(IN31))))), xor(xor(xor(xor((false | (xor(xor(IN33, IN12), IN48))) | ((xor(xor(IN5, IN49), IN14)) & IN11), !((IN49 | IN29) | (IN29 & IN12))), ((IN48 | IN19) | (IN10 | IN4)) | ((!(IN37)) & (IN39 & IN4))), (!((IN33 | true) | (xor(xor(IN26, IN44), IN22)))) | (IN37 | (xor(xor(IN30 | IN33, IN47), !(IN7))))), (!(xor(xor(!(IN21), !(IN11)), !(IN17)))) & IN12)), xor(xor((((!(IN22)) | (IN18 & IN6)) & (xor(xor(xor(xor(IN30, IN18), IN11), IN14 & IN13), IN18 & IN44))) & (xor(xor(IN30 & (IN31 & IN44), xor(xor(xor(xor(IN22, IN16), IN17), xor(xor(IN13, IN42), IN23)), IN38 & IN3)), !(xor(xor(IN41, IN47), IN26)))), IN3), IN12 | IN1)))) & (xor(xor(IN30, !(xor(xor(xor(xor(IN49 & (!(!(IN12))), IN12 & (!(IN13 | IN31))), !((IN21 | IN45) & (IN43 | IN21))), xor(xor(!((IN24 | IN34) | (!(IN1))), ((!(IN44)) & (xor(xor(IN20, IN30), IN17))) | (xor(xor(IN23 & IN49, IN45 & IN25), !(IN34)))), !((!(IN13)) | (xor(xor(IN49, IN15), IN41))))), ((IN4 & (IN19 & IN39)) | ((xor(xor(IN9, IN46), IN40)) & (IN30 & IN45))) & (IN49 | IN13)))), xor(xor(xor(xor(((IN50 & (!(IN24))) & ((IN47 | IN39) & (IN40 & IN24))) & ((xor(xor(IN10 | IN23, IN7 | IN31), IN15 | IN34)) & (IN44 | (!(IN46)))), !(xor(xor(xor(xor(IN29, IN20), IN41 & IN28), IN12), IN27 & (xor(xor(IN42, IN24), IN2))))), IN23), IN11), ((((xor(xor(IN44, IN30), IN46)) | IN35) & IN44) | ((IN45 | (IN7 | IN9)) & IN40)) & IN26))))) | (!((((((xor(xor(IN40, xor(xor(IN25 & IN33, !(IN30)), xor(xor(IN17, IN41), IN29))), IN23)) | (!(xor(xor(xor(xor(IN16, IN49), IN38), IN2 | IN47), IN6 | IN24)))) | IN9) | (!(IN10))) | IN25) & (IN47 | (!(((!(!(IN41 & IN48))) | (IN6 | IN11)) & (((IN12 & IN38) & IN8) | ((xor(xor(IN39 & IN14, IN34 | IN30), xor(xor(IN23, IN46), IN33))) | IN49)))))))

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
    Out := (((((((((((((NOT Data[12]) XOR (NOT Data[17])) XOR ((Data[9] XOR Data[18]) XOR Data[16])) OR (NOT (NOT Data[37]))) OR Data[16]) AND ((Data[45] XOR ((((Data[41] OR Data[9]) XOR ((Data[35] XOR Data[31]) XOR Data[31])) XOR (FALSE AND Data[31])) OR (((Data[20] XOR Data[44]) XOR Data[36]) OR (Data[7] AND Data[36])))) XOR (FALSE AND Data[37]))) OR Data[2]) OR (Data[40] AND (((((((Data[13] XOR Data[26]) XOR (Data[49] OR Data[33])) XOR (((Data[9] XOR Data[4]) XOR Data[10]) AND Data[35])) XOR (((Data[38] XOR Data[22]) XOR Data[49]) AND (Data[26] OR Data[2]))) AND ((((Data[21] OR Data[37]) OR Data[35]) XOR ((((Data[27] XOR Data[35]) XOR Data[49]) XOR Data[20]) XOR (NOT Data[38]))) XOR (((NOT Data[24]) XOR (Data[47] AND Data[9])) XOR (Data[49] AND Data[17])))) XOR ((Data[2] AND (((Data[39] XOR TRUE) XOR Data[43]) OR (NOT Data[6]))) AND (((((Data[32] OR Data[28]) XOR (NOT Data[19])) XOR (Data[40] OR Data[22])) XOR (NOT (Data[3] AND Data[26]))) XOR ((Data[29] OR Data[25]) OR (Data[45] AND Data[27]))))) XOR ((((NOT Data[44]) AND Data[6]) XOR Data[29]) XOR ((NOT (Data[7] AND Data[11])) OR ((FALSE AND Data[15]) OR (NOT Data[19]))))))) XOR Data[17]) XOR ((((Data[38] AND (Data[15] OR ((Data[27] OR (NOT Data[8])) AND (Data[23] OR (Data[11] AND Data[7]))))) OR (((((((Data[34] XOR Data[2]) XOR Data[40]) OR Data[1]) OR (NOT (Data[9] OR Data[21]))) AND (NOT (((Data[30] OR Data[29]) XOR ((Data[44] XOR Data[42]) XOR Data[31])) XOR (TRUE AND Data[38])))) XOR ((Data[10] OR ((Data[10] OR Data[13]) AND (Data[25] OR Data[48]))) AND Data[18])) XOR (((NOT (((NOT Data[15]) XOR (Data[14] AND Data[49])) XOR FALSE)) XOR Data[16]) XOR Data[33]))) XOR Data[13]) XOR (((NOT ((((NOT Data[21]) AND Data[46]) OR (NOT (NOT Data[30]))) OR (NOT (((Data[29] XOR Data[30]) XOR Data[17]) OR ((Data[48] XOR Data[6]) XOR Data[1]))))) XOR (((NOT Data[18]) XOR ((((NOT Data[34]) AND (Data[25] OR Data[49])) AND (NOT (Data[46] OR Data[49]))) AND (NOT ((((Data[12] XOR Data[43]) XOR Data[16]) XOR Data[41]) XOR Data[17])))) XOR (Data[11] OR (Data[5] OR FALSE)))) XOR (((((NOT Data[35]) OR ((Data[23] XOR Data[39]) XOR Data[8])) AND Data[6]) AND (NOT (((Data[21] AND Data[34]) XOR (TRUE OR Data[14])) XOR ((Data[23] XOR Data[26]) XOR Data[5])))) AND Data[28])))) XOR (NOT (NOT Data[4]))) XOR ((Data[38] OR (((NOT (Data[16] OR (Data[25] AND (NOT (NOT Data[31]))))) XOR ((((((FALSE OR ((Data[33] XOR Data[12]) XOR Data[48])) OR (((Data[5] XOR Data[49]) XOR Data[14]) AND Data[11])) XOR (NOT ((Data[49] OR Data[29]) OR (Data[29] AND Data[12])))) XOR (((Data[48] OR Data[19]) OR (Data[10] OR Data[4])) OR ((NOT Data[37]) AND (Data[39] AND Data[4])))) XOR ((NOT ((Data[33] OR TRUE) OR ((Data[26] XOR Data[44]) XOR Data[22]))) OR (Data[37] OR (((Data[30] OR Data[33]) XOR Data[47]) XOR (NOT Data[7]))))) XOR ((NOT (((NOT Data[21]) XOR (NOT Data[11])) XOR (NOT Data[17]))) AND Data[12]))) XOR ((((((NOT Data[22]) OR (Data[18] AND Data[6])) AND ((((Data[30] XOR Data[18]) XOR Data[11]) XOR (Data[14] AND Data[13])) XOR (Data[18] AND Data[44]))) AND (((Data[30] AND (Data[31] AND Data[44])) XOR ((((Data[22] XOR Data[16]) XOR Data[17]) XOR ((Data[13] XOR Data[42]) XOR Data[23])) XOR (Data[38] AND Data[3]))) XOR (NOT ((Data[41] XOR Data[47]) XOR Data[26])))) XOR Data[3]) XOR (Data[12] OR Data[1])))) AND ((Data[30] XOR (NOT (((((Data[49] AND (NOT (NOT Data[12]))) XOR (Data[12] AND (NOT (Data[13] OR Data[31])))) XOR (NOT ((Data[21] OR Data[45]) AND (Data[43] OR Data[21])))) XOR (((NOT ((Data[24] OR Data[34]) OR (NOT Data[1]))) XOR (((NOT Data[44]) AND ((Data[20] XOR Data[30]) XOR Data[17])) OR (((Data[23] AND Data[49]) XOR (Data[45] AND Data[25])) XOR (NOT Data[34])))) XOR (NOT ((NOT Data[13]) OR ((Data[49] XOR Data[15]) XOR Data[41]))))) XOR (((Data[4] AND (Data[19] AND Data[39])) OR (((Data[9] XOR Data[46]) XOR Data[40]) AND (Data[30] AND Data[45]))) AND (Data[49] OR Data[13]))))) XOR (((((((Data[50] AND (NOT Data[24])) AND ((Data[47] OR Data[39]) AND (Data[40] AND Data[24]))) AND ((((Data[10] OR Data[23]) XOR (Data[7] OR Data[31])) XOR (Data[15] OR Data[34])) AND (Data[44] OR (NOT Data[46])))) XOR (NOT ((((Data[29] XOR Data[20]) XOR (Data[41] AND Data[28])) XOR Data[12]) XOR (Data[27] AND ((Data[42] XOR Data[24]) XOR Data[2]))))) XOR Data[23]) XOR Data[11]) XOR ((((((Data[44] XOR Data[30]) XOR Data[46]) OR Data[35]) AND Data[44]) OR ((Data[45] OR (Data[7] OR Data[9])) AND Data[40])) AND Data[26]))))) OR (NOT (((((((Data[40] XOR (((Data[25] AND Data[33]) XOR (NOT Data[30])) XOR ((Data[17] XOR Data[41]) XOR Data[29]))) XOR Data[23]) OR (NOT ((((Data[16] XOR Data[49]) XOR Data[38]) XOR (Data[2] OR Data[47])) XOR (Data[6] OR Data[24])))) OR Data[9]) OR (NOT Data[10])) OR Data[25]) AND (Data[47] OR (NOT (((NOT (NOT (Data[41] AND Data[48]))) OR (Data[6] OR Data[11])) AND (((Data[12] AND Data[38]) AND Data[8]) OR ((((Data[39] AND Data[14]) XOR (Data[34] OR Data[30])) XOR ((Data[23] XOR Data[46]) XOR Data[33])) OR Data[49]))))))));
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
