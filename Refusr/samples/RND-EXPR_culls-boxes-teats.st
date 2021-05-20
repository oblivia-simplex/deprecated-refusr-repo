(*
This code implements a randomly grown symbolic expression:

xor(xor(xor(xor(!((IN48 | (xor(xor(!(!(IN48)), !(!(xor(xor(IN15 & IN37, IN27 & IN43), xor(xor(IN10, IN50), IN49))))), !((IN7 & (xor(xor(IN34, IN29), IN41))) | ((IN34 & IN45) | (!(IN2))))))) & IN16), IN31), IN38), (IN16 | IN47) & IN28), (((!(IN20)) | ((xor(xor(xor(xor(((IN39 | IN35) | (IN9 & IN43)) & IN46, !((!(IN46)) | (xor(xor(IN5, IN34), IN46)))), (!(IN19 | IN49)) | (!(!(IN22)))), xor(xor(IN13, IN22), ((!(IN35)) & (xor(xor(IN2, IN40), IN38))) & IN43)), IN29)) | (xor(xor(!(!(xor(xor(IN8 | IN20, IN6 | IN40), xor(xor(IN12, IN18), IN33)))), !(((!(IN34)) & IN30) | ((!(IN31)) & (IN36 & IN6)))), (!(IN35)) & true)))) & ((((IN17 | (!(!(IN26 | IN42)))) | (xor(xor(IN44, ((xor(xor(IN13, IN3), IN47)) | (xor(xor(IN10, IN45), IN26))) & (xor(xor(!(IN3), IN34 | true), !(IN45)))), !(IN7 | IN35)))) & ((!(!(xor(xor(IN41 & IN25, xor(xor(IN10, IN9), IN48)), IN39)))) | (xor(xor(((xor(xor(IN22, IN35), IN30)) | (IN30 & IN45)) & ((IN24 | IN15) | IN48), !((xor(xor(IN16, IN5), IN23)) | (!(IN4)))), !((xor(xor(IN38, IN16), IN14)) | IN41))))) | ((IN27 & IN46) & ((xor(xor(!(!(xor(xor(IN29, IN24), IN24))), ((IN29 & IN32) & (IN36 | IN47)) | IN15), !(xor(xor(IN45, IN47 | IN29), xor(false, IN9))))) & (xor(xor(xor(xor((xor(xor(IN29, IN4), IN8)) & (!(IN27)), (xor(xor(IN24, IN23), IN10)) | IN19), (IN35 & IN15) | IN20), IN4 & ((!(IN9)) | (xor(xor(IN12, IN15), IN37)))), !(!(IN3)))))))) & (IN27 | IN9))

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
    Out := (((((NOT ((Data[48] OR (((NOT (NOT Data[48])) XOR (NOT (NOT (((Data[15] AND Data[37]) XOR (Data[27] AND Data[43])) XOR ((Data[10] XOR Data[50]) XOR Data[49]))))) XOR (NOT ((Data[7] AND ((Data[34] XOR Data[29]) XOR Data[41])) OR ((Data[34] AND Data[45]) OR (NOT Data[2])))))) AND Data[16])) XOR Data[31]) XOR Data[38]) XOR ((Data[16] OR Data[47]) AND Data[28])) XOR ((((NOT Data[20]) OR ((((((((Data[39] OR Data[35]) OR (Data[9] AND Data[43])) AND Data[46]) XOR (NOT ((NOT Data[46]) OR ((Data[5] XOR Data[34]) XOR Data[46])))) XOR ((NOT (Data[19] OR Data[49])) OR (NOT (NOT Data[22])))) XOR ((Data[13] XOR Data[22]) XOR (((NOT Data[35]) AND ((Data[2] XOR Data[40]) XOR Data[38])) AND Data[43]))) XOR Data[29]) OR (((NOT (NOT (((Data[8] OR Data[20]) XOR (Data[6] OR Data[40])) XOR ((Data[12] XOR Data[18]) XOR Data[33])))) XOR (NOT (((NOT Data[34]) AND Data[30]) OR ((NOT Data[31]) AND (Data[36] AND Data[6]))))) XOR ((NOT Data[35]) AND TRUE)))) AND ((((Data[17] OR (NOT (NOT (Data[26] OR Data[42])))) OR ((Data[44] XOR ((((Data[13] XOR Data[3]) XOR Data[47]) OR ((Data[10] XOR Data[45]) XOR Data[26])) AND (((NOT Data[3]) XOR (Data[34] OR TRUE)) XOR (NOT Data[45])))) XOR (NOT (Data[7] OR Data[35])))) AND ((NOT (NOT (((Data[41] AND Data[25]) XOR ((Data[10] XOR Data[9]) XOR Data[48])) XOR Data[39]))) OR ((((((Data[22] XOR Data[35]) XOR Data[30]) OR (Data[30] AND Data[45])) AND ((Data[24] OR Data[15]) OR Data[48])) XOR (NOT (((Data[16] XOR Data[5]) XOR Data[23]) OR (NOT Data[4])))) XOR (NOT (((Data[38] XOR Data[16]) XOR Data[14]) OR Data[41]))))) OR ((Data[27] AND Data[46]) AND ((((NOT (NOT ((Data[29] XOR Data[24]) XOR Data[24]))) XOR (((Data[29] AND Data[32]) AND (Data[36] OR Data[47])) OR Data[15])) XOR (NOT ((Data[45] XOR (Data[47] OR Data[29])) XOR (FALSE XOR Data[9])))) AND (((((((Data[29] XOR Data[4]) XOR Data[8]) AND (NOT Data[27])) XOR (((Data[24] XOR Data[23]) XOR Data[10]) OR Data[19])) XOR ((Data[35] AND Data[15]) OR Data[20])) XOR (Data[4] AND ((NOT Data[9]) OR ((Data[12] XOR Data[15]) XOR Data[37])))) XOR (NOT (NOT Data[3]))))))) AND (Data[27] OR Data[9])));
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
