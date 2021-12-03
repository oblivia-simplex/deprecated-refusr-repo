(*
This code implements a randomly grown symbolic expression:

((!(!(IN13))) | (!(!(xor(xor(xor(xor(!(IN4 & ((IN19 & true) | (xor(xor(IN42, IN41), IN4)))), xor(xor(!(!(xor(xor(IN31, IN24), IN23))), (xor(xor(xor(xor(IN40, IN28), IN17), IN9), IN39)) & ((IN33 | IN34) & (!(IN20)))), IN44 & ((!(IN32)) & (IN26 & IN44)))), xor(xor(IN11, (IN4 | false) | false), ((xor(xor(IN44, IN24), IN26)) & (!(IN28))) & IN45)), !(xor(xor((xor(xor(IN21, !(IN47)), !(IN8))) | IN40, !(IN1)), xor(xor((IN32 | IN42) & (IN31 & IN45), IN8), xor(xor(false, xor(xor(IN4, IN21), IN1)), !(IN31)))))), xor(xor((!(!(IN26))) | (xor(xor((!(IN37)) | (xor(xor(IN35, IN29), IN14)), (xor(xor(IN20, IN22), IN21)) | (!(IN10))), (!(IN20)) | (IN1 | IN15))), IN15), (((IN24 | IN17) | (xor(xor(IN22, IN33), IN18))) | ((IN15 & IN22) & (IN11 | IN43))) & (!(IN38 | (IN40 & IN44))))))))) & (xor(xor(!((IN45 & (xor(xor(IN43, IN12), true))) & IN23), IN18), xor(xor((((IN22 & (!((IN10 & IN48) & (IN31 & IN35)))) | IN8) & (xor(xor(xor(xor(false, ((IN39 | IN45) | false) & ((IN3 | IN15) & (xor(xor(IN34, IN30), IN33)))), (xor(xor(IN7, IN31 | IN42), IN12 | IN2)) | ((IN4 | IN5) & (IN39 | IN13))), !(IN21 | ((IN20 | IN40) | (IN24 & IN19)))), !(!(xor(xor(IN19, xor(xor(IN37, IN33), IN8)), IN39)))))) | (!(IN35)), !(IN11)), IN45)))

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
    Out := (((NOT (NOT Data[13])) OR (NOT (NOT (((((NOT (Data[4] AND ((Data[19] AND TRUE) OR ((Data[42] XOR Data[41]) XOR Data[4])))) XOR (((NOT (NOT ((Data[31] XOR Data[24]) XOR Data[23]))) XOR (((((Data[40] XOR Data[28]) XOR Data[17]) XOR Data[9]) XOR Data[39]) AND ((Data[33] OR Data[34]) AND (NOT Data[20])))) XOR (Data[44] AND ((NOT Data[32]) AND (Data[26] AND Data[44]))))) XOR ((Data[11] XOR ((Data[4] OR FALSE) OR FALSE)) XOR ((((Data[44] XOR Data[24]) XOR Data[26]) AND (NOT Data[28])) AND Data[45]))) XOR (NOT (((((Data[21] XOR (NOT Data[47])) XOR (NOT Data[8])) OR Data[40]) XOR (NOT Data[1])) XOR ((((Data[32] OR Data[42]) AND (Data[31] AND Data[45])) XOR Data[8]) XOR ((FALSE XOR ((Data[4] XOR Data[21]) XOR Data[1])) XOR (NOT Data[31])))))) XOR ((((NOT (NOT Data[26])) OR ((((NOT Data[37]) OR ((Data[35] XOR Data[29]) XOR Data[14])) XOR (((Data[20] XOR Data[22]) XOR Data[21]) OR (NOT Data[10]))) XOR ((NOT Data[20]) OR (Data[1] OR Data[15])))) XOR Data[15]) XOR ((((Data[24] OR Data[17]) OR ((Data[22] XOR Data[33]) XOR Data[18])) OR ((Data[15] AND Data[22]) AND (Data[11] OR Data[43]))) AND (NOT (Data[38] OR (Data[40] AND Data[44]))))))))) AND (((NOT ((Data[45] AND ((Data[43] XOR Data[12]) XOR TRUE)) AND Data[23])) XOR Data[18]) XOR ((((((Data[22] AND (NOT ((Data[10] AND Data[48]) AND (Data[31] AND Data[35])))) OR Data[8]) AND ((((FALSE XOR (((Data[39] OR Data[45]) OR FALSE) AND ((Data[3] OR Data[15]) AND ((Data[34] XOR Data[30]) XOR Data[33])))) XOR (((Data[7] XOR (Data[31] OR Data[42])) XOR (Data[12] OR Data[2])) OR ((Data[4] OR Data[5]) AND (Data[39] OR Data[13])))) XOR (NOT (Data[21] OR ((Data[20] OR Data[40]) OR (Data[24] AND Data[19]))))) XOR (NOT (NOT ((Data[19] XOR ((Data[37] XOR Data[33]) XOR Data[8])) XOR Data[39]))))) OR (NOT Data[35])) XOR (NOT Data[11])) XOR Data[45])));
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
