(*
This code implements a randomly grown symbolic expression:

!(!(xor(xor(IN7 | ((((!(xor(xor(IN46, IN6 & IN48), IN36 | IN35))) | (!((xor(xor(IN26, IN22), IN45)) | (IN5 | true)))) | (!(((IN23 & IN25) & IN7) | (xor(xor(xor(xor(IN6, IN4), true), xor(xor(IN2, IN20), IN9)), xor(xor(IN4, IN11), IN36)))))) & (!(IN23))), IN8), ((!((((IN36 & IN24) | (IN45 | IN45)) | ((!(IN8)) | (!(IN23)))) & ((xor(xor(xor(xor(IN41, IN42), IN5), xor(xor(IN5, IN3), IN41)), xor(xor(IN20, IN39), true))) & (xor(xor(!(IN12), IN47 & false), IN14 & IN23))))) | (xor(xor((!(IN3)) & (((xor(xor(IN24, IN43), IN28)) | (!(IN10))) & (!(IN22 | IN28))), IN16), (xor(xor(IN1, IN1), (IN16 & true) | (IN40 | IN50))) & (!(IN39 & (IN8 & IN8)))))) | IN3)))

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
    Out := (NOT (NOT (((Data[7] OR ((((NOT ((Data[46] XOR (Data[6] AND Data[48])) XOR (Data[36] OR Data[35]))) OR (NOT (((Data[26] XOR Data[22]) XOR Data[45]) OR (Data[5] OR TRUE)))) OR (NOT (((Data[23] AND Data[25]) AND Data[7]) OR ((((Data[6] XOR Data[4]) XOR TRUE) XOR ((Data[2] XOR Data[20]) XOR Data[9])) XOR ((Data[4] XOR Data[11]) XOR Data[36]))))) AND (NOT Data[23]))) XOR Data[8]) XOR (((NOT ((((Data[36] AND Data[24]) OR (Data[45] OR Data[45])) OR ((NOT Data[8]) OR (NOT Data[23]))) AND (((((Data[41] XOR Data[42]) XOR Data[5]) XOR ((Data[5] XOR Data[3]) XOR Data[41])) XOR ((Data[20] XOR Data[39]) XOR TRUE)) AND (((NOT Data[12]) XOR (Data[47] AND FALSE)) XOR (Data[14] AND Data[23]))))) OR ((((NOT Data[3]) AND ((((Data[24] XOR Data[43]) XOR Data[28]) OR (NOT Data[10])) AND (NOT (Data[22] OR Data[28])))) XOR Data[16]) XOR (((Data[1] XOR Data[1]) XOR ((Data[16] AND TRUE) OR (Data[40] OR Data[50]))) AND (NOT (Data[39] AND (Data[8] AND Data[8])))))) OR Data[3]))));
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
