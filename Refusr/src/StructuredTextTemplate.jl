module StructuredTextTemplate

PREFIX = raw"""
FUNCTION_BLOCK F_CollectInput
  VAR_IN_OUT
    Data : ARRAY[1..50] OF BOOL;
  END_VAR
  VAR_INPUT
    TICK : BOOL;
    IN1  : BOOL;
    IN2  : BOOL;
    IN3  : BOOL;
    IN4  : BOOL;
    IN5  : BOOL;
  END_VAR
  VAR_OUTPUT
    Finished : BOOL;
  END_VAR
  VAR
    j    : USINT := 1;
    tock : BOOL  := 0;
  END_VAR
  IF tock = NOT TICK THEN
    Data[j]   := IN1;
    Data[j+1] := IN2;
    Data[j+2] := IN3;
    Data[j+3] := IN4;
    Data[j+4] := IN5;
    j := j + 5;
    tock := TICK;
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
    TICK     AT %IX0.0 : BOOL;
    IN1      AT %IX0.1 : BOOL;
    IN2      AT %IX0.2 : BOOL;
    IN3      AT %IX0.3 : BOOL;
    IN4      AT %IX0.4 : BOOL;
    IN5      AT %IX0.5 : BOOL;
    OutReady AT %QX0.0 : BOOL := 0;
    FeedNext AT %QX0.1 : BOOL := 0;
    Out      AT %QX0.2 : BOOL;
  END_VAR
  CollectInput(TICK:=TICK, IN1:=IN1, IN2:=IN2, IN3:=IN3, IN4:=IN4, IN5:=IN5);
  Ready := CollectInput.Finished;
  FeedNext := 1;
  IF Ready THEN
"""

SUFFIX = raw"""
    OutReady := 1;
  END_IF;
END_PROGRAM


CONFIGURATION Config0
  RESOURCE Res0 ON PLC
    TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
    PROGRAM instance0 WITH task0 : Boiler;
  END_RESOURCE
END_CONFIGURATION
"""

function wrap(expr) 
  statement = "    Out := $(expr);\n"
  return PREFIX * statement * SUFFIX
end  


end 
