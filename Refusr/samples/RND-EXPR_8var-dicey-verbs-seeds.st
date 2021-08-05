FUNCTION_BLOCK F_CollectInput
  VAR_IN_OUT
      Data : ARRAY[1..10] OF BOOL;
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
  Finished := (j > 10);
END_FUNCTION_BLOCK


PROGRAM Boiler
  VAR
    Data  : ARRAY[1..10] OF BOOL;
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
    Out := ((NOT ((((NOT D[3]) OR ((NOT (NOT D[4])) AND D[8])) OR TRUE) AND ((NOT D[4]) AND ((((NOT ((D[4] OR ((NOT (NOT D[6])) OR ((D[8] OR D[2]) AND (NOT D[2])))) AND (((TRUE OR (TRUE OR FALSE)) OR ((D[5] AND D[5]) OR (TRUE AND D[1]))) AND ((NOT (NOT D[8])) AND ((D[2] AND D[2]) OR (D[2] OR FALSE)))))) AND (NOT (((((NOT D[4]) OR (NOT D[7])) AND ((NOT D[2]) OR (NOT D[2]))) AND TRUE) AND TRUE))) AND (((NOT ((D[2] AND (D[6] OR (D[3] AND D[8]))) AND (NOT D[6]))) AND ((NOT D[8]) OR (D[8] AND (NOT (NOT (D[8] AND D[2])))))) AND ((((NOT ((D[5] OR D[8]) AND (D[6] OR D[3]))) OR (((NOT D[8]) OR D[5]) AND ((D[3] AND D[3]) OR (NOT D[2])))) OR (NOT D[2])) OR (((((D[7] OR D[6]) AND (NOT D[1])) AND ((NOT D[6]) AND (D[3] AND D[6]))) AND (((TRUE OR D[8]) AND (D[4] AND D[6])) OR ((D[7] OR D[1]) AND (D[6] AND D[7])))) OR (NOT ((D[2] OR (D[4] OR FALSE)) OR ((NOT D[3]) OR (TRUE AND D[7])))))))) OR ((NOT ((D[1] OR (((NOT (D[2] OR D[6])) OR D[7]) AND ((NOT (D[8] OR D[4])) OR ((NOT D[7]) OR (D[5] AND D[1]))))) OR D[5])) OR (((NOT ((((TRUE OR TRUE) OR D[5]) AND (D[3] AND (NOT D[4]))) AND (((D[1] AND D[1]) AND (D[6] OR D[1])) AND ((D[7] AND D[2]) OR (D[8] AND FALSE))))) OR ((NOT ((NOT (D[4] AND D[2])) AND (NOT (NOT D[4])))) AND ((NOT ((D[2] AND D[8]) AND (D[6] AND D[4]))) OR D[2]))) AND ((((D[6] OR (NOT (D[6] AND D[3]))) AND (((NOT D[3]) OR D[7]) OR ((D[6] OR D[6]) AND (NOT D[5])))) AND TRUE) OR (((NOT D[7]) OR FALSE) OR (NOT ((NOT (D[8] OR D[4])) AND (NOT (D[4] OR FALSE)))))))))))) OR D[7]);
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
