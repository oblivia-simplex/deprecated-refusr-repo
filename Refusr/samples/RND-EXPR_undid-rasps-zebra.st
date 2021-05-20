(*
This code implements a randomly grown symbolic expression:

(!(IN26)) & (xor(xor(!(IN23), !(!((((xor(xor((!(IN29)) | (!(IN21)), xor(xor(xor(xor(true, IN46), IN14), !(IN7)), !(IN19))), !(IN12))) & ((!(!(IN9))) | IN10)) | (!(IN29 & IN6))) & ((xor(xor(IN34, IN46), !((IN47 | IN39) & (xor(xor(IN48, IN16), IN35))))) | (xor(xor(xor(xor(xor(xor(IN18, !(IN46)), IN4), false & (!(IN20))), !(!(IN26))), false), IN34 | (xor(xor(xor(xor(IN48, IN50), IN49), !(IN38)), IN45 & IN13)))))))), (xor(xor((!((!(xor(xor(false, !(IN30)), IN27))) | (xor(xor(xor(xor(IN25 & IN4, IN3 | IN3), IN47 & IN26), !(IN25 & IN25)), !(!(IN24)))))) | (((!(IN21 | (IN5 & IN39))) & ((xor(xor(IN3 & IN24, IN49 & IN44), IN24 & IN39)) | ((IN21 | IN27) & IN42))) & (xor(xor(((!(IN46)) & (xor(xor(IN42, IN44), IN38))) & false, xor(xor(xor(xor(IN38 & false, IN32), !(IN21)), (xor(xor(IN22, IN10), IN42)) & (false | IN15)), IN12)), xor(xor(IN22 | (IN41 | IN39), (IN23 | IN41) & (IN23 & IN21)), (!(IN22)) | (xor(xor(IN47, IN35), IN37)))))), xor(xor(!((((IN13 & IN38) | (!(IN21))) | IN42) | (((IN34 & IN31) | (IN6 & IN28)) | ((IN45 & IN33) | IN42))), xor(xor(IN1, (((IN32 & IN43) & (IN10 | IN49)) & (xor(xor(xor(xor(IN42, IN8), IN40), IN12 | IN31), IN25 & IN30))) | IN13), xor(xor(xor(xor(false & (IN14 & IN9), !(IN3)), IN39 & (IN11 & IN35)), IN27 | (!(IN6 | IN39))), !(xor(xor(!(IN37), xor(xor(IN1, IN13), IN25)), xor(xor(IN22, false), IN17)))))), IN31 | (xor(xor(((!(IN11)) & (xor(xor(IN10, IN29), IN38))) | ((IN20 & IN29) | (!(IN22))), IN19), xor(xor((IN1 | IN39) | IN22, (!(IN7)) & (IN26 | IN10)), IN12))))), !(xor(xor(!(IN9), ((IN38 & (!(IN35))) & (!(IN32 | IN20))) & (xor(xor(true, xor(xor(IN35, IN33 | IN35), IN10 | IN17)), IN42 & (xor(xor(IN28, IN5), IN11))))), IN27 & (IN1 | ((!(IN45)) & (IN8 & IN17))))))) | (!(!(IN22)))))

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
    Out := ((NOT Data[26]) AND (((NOT Data[23]) XOR (NOT (NOT (((((((NOT Data[29]) OR (NOT Data[21])) XOR ((((TRUE XOR Data[46]) XOR Data[14]) XOR (NOT Data[7])) XOR (NOT Data[19]))) XOR (NOT Data[12])) AND ((NOT (NOT Data[9])) OR Data[10])) OR (NOT (Data[29] AND Data[6]))) AND (((Data[34] XOR Data[46]) XOR (NOT ((Data[47] OR Data[39]) AND ((Data[48] XOR Data[16]) XOR Data[35])))) OR ((((((Data[18] XOR (NOT Data[46])) XOR Data[4]) XOR (FALSE AND (NOT Data[20]))) XOR (NOT (NOT Data[26]))) XOR FALSE) XOR (Data[34] OR ((((Data[48] XOR Data[50]) XOR Data[49]) XOR (NOT Data[38])) XOR (Data[45] AND Data[13]))))))))) XOR (((((NOT ((NOT ((FALSE XOR (NOT Data[30])) XOR Data[27])) OR (((((Data[25] AND Data[4]) XOR (Data[3] OR Data[3])) XOR (Data[47] AND Data[26])) XOR (NOT (Data[25] AND Data[25]))) XOR (NOT (NOT Data[24]))))) OR (((NOT (Data[21] OR (Data[5] AND Data[39]))) AND ((((Data[3] AND Data[24]) XOR (Data[49] AND Data[44])) XOR (Data[24] AND Data[39])) OR ((Data[21] OR Data[27]) AND Data[42]))) AND (((((NOT Data[46]) AND ((Data[42] XOR Data[44]) XOR Data[38])) AND FALSE) XOR (((((Data[38] AND FALSE) XOR Data[32]) XOR (NOT Data[21])) XOR (((Data[22] XOR Data[10]) XOR Data[42]) AND (FALSE OR Data[15]))) XOR Data[12])) XOR (((Data[22] OR (Data[41] OR Data[39])) XOR ((Data[23] OR Data[41]) AND (Data[23] AND Data[21]))) XOR ((NOT Data[22]) OR ((Data[47] XOR Data[35]) XOR Data[37])))))) XOR (((NOT ((((Data[13] AND Data[38]) OR (NOT Data[21])) OR Data[42]) OR (((Data[34] AND Data[31]) OR (Data[6] AND Data[28])) OR ((Data[45] AND Data[33]) OR Data[42])))) XOR ((Data[1] XOR ((((Data[32] AND Data[43]) AND (Data[10] OR Data[49])) AND ((((Data[42] XOR Data[8]) XOR Data[40]) XOR (Data[12] OR Data[31])) XOR (Data[25] AND Data[30]))) OR Data[13])) XOR (((((FALSE AND (Data[14] AND Data[9])) XOR (NOT Data[3])) XOR (Data[39] AND (Data[11] AND Data[35]))) XOR (Data[27] OR (NOT (Data[6] OR Data[39])))) XOR (NOT (((NOT Data[37]) XOR ((Data[1] XOR Data[13]) XOR Data[25])) XOR ((Data[22] XOR FALSE) XOR Data[17])))))) XOR (Data[31] OR (((((NOT Data[11]) AND ((Data[10] XOR Data[29]) XOR Data[38])) OR ((Data[20] AND Data[29]) OR (NOT Data[22]))) XOR Data[19]) XOR ((((Data[1] OR Data[39]) OR Data[22]) XOR ((NOT Data[7]) AND (Data[26] OR Data[10]))) XOR Data[12]))))) XOR (NOT (((NOT Data[9]) XOR (((Data[38] AND (NOT Data[35])) AND (NOT (Data[32] OR Data[20]))) AND ((TRUE XOR ((Data[35] XOR (Data[33] OR Data[35])) XOR (Data[10] OR Data[17]))) XOR (Data[42] AND ((Data[28] XOR Data[5]) XOR Data[11]))))) XOR (Data[27] AND (Data[1] OR ((NOT Data[45]) AND (Data[8] AND Data[17]))))))) OR (NOT (NOT Data[22])))));
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
