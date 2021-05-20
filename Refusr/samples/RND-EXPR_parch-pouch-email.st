(*
This code implements a randomly grown symbolic expression:

(((((false & ((((IN32 | IN11) | (IN6 | IN33)) | (IN37 | (!(IN33)))) | (((IN45 | IN22) | (!(IN44))) | (!(IN47))))) | (!(!(IN28)))) & (xor(xor(IN24, xor(xor(IN3 & (xor(xor((IN19 & IN6) & (xor(xor(IN45, IN48), IN8)), xor(xor(!(IN33), IN26 & IN41), IN48)), xor(xor(xor(xor(IN48, IN4), IN30), IN38 & IN7), IN2 & IN27))), (((!(IN46)) & (IN25 & IN22)) | IN3) & IN14), ((!(xor(xor(IN32, IN14), IN46))) | IN41) & ((!(IN32 | IN6)) & (!(!(IN48)))))), !((((xor(xor(IN18, IN35), IN47)) | IN25) | (xor(xor(IN1 | IN9, IN12 & false), true))) & (xor(xor(IN26 | (IN11 & IN20), IN14), !(IN41))))))) | IN15) | (!(!(IN18)))) | IN14

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
    Out := ((((((FALSE AND ((((Data[32] OR Data[11]) OR (Data[6] OR Data[33])) OR (Data[37] OR (NOT Data[33]))) OR (((Data[45] OR Data[22]) OR (NOT Data[44])) OR (NOT Data[47])))) OR (NOT (NOT Data[28]))) AND ((Data[24] XOR (((Data[3] AND ((((Data[19] AND Data[6]) AND ((Data[45] XOR Data[48]) XOR Data[8])) XOR (((NOT Data[33]) XOR (Data[26] AND Data[41])) XOR Data[48])) XOR ((((Data[48] XOR Data[4]) XOR Data[30]) XOR (Data[38] AND Data[7])) XOR (Data[2] AND Data[27])))) XOR ((((NOT Data[46]) AND (Data[25] AND Data[22])) OR Data[3]) AND Data[14])) XOR (((NOT ((Data[32] XOR Data[14]) XOR Data[46])) OR Data[41]) AND ((NOT (Data[32] OR Data[6])) AND (NOT (NOT Data[48])))))) XOR (NOT (((((Data[18] XOR Data[35]) XOR Data[47]) OR Data[25]) OR (((Data[1] OR Data[9]) XOR (Data[12] AND FALSE)) XOR TRUE)) AND (((Data[26] OR (Data[11] AND Data[20])) XOR Data[14]) XOR (NOT Data[41])))))) OR Data[15]) OR (NOT (NOT Data[18]))) OR Data[14]);
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
