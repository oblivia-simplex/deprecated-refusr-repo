(*
This code implements a randomly grown symbolic expression:

IN41 & (((!(xor(xor(true | (IN11 & (xor(xor(xor(xor(!(IN18), IN9 | IN2), IN35 | IN48), IN33), !(IN37 & IN42)))), IN23), (!(xor(xor(IN46, xor(xor(xor(xor(IN24, IN10), IN35), IN18 & IN26), IN24)), IN6))) | (!(IN40))))) | (xor(xor((!(IN24)) & (!(IN30)), !(IN4)), !(((!((IN48 & IN1) & IN29)) | (IN43 | ((IN3 | IN24) & IN26))) | (xor(xor(IN11, ((false | IN12) & (IN18 | IN46)) | (IN29 & (!(IN39)))), IN11)))))) | (!(xor(xor(IN36, IN25 | (xor(xor(false | ((xor(xor(xor(xor(IN34, IN44), IN45), IN23), IN13)) | (xor(xor(!(IN4), false | IN22), IN35 | IN35))), IN41 | (xor(xor(IN23, !(!(IN30))), IN40))), xor(xor(((IN7 | IN13) & (IN16 | IN46)) & IN24, ((IN45 | IN32) | (IN5 & IN30)) | (xor(xor(IN5, IN28), IN29 & IN13))), ((!(IN17)) | IN50) & IN28)))), !(IN45)))))

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
    Out := (Data[41] AND (((NOT (((TRUE OR (Data[11] AND (((((NOT Data[18]) XOR (Data[9] OR Data[2])) XOR (Data[35] OR Data[48])) XOR Data[33]) XOR (NOT (Data[37] AND Data[42]))))) XOR Data[23]) XOR ((NOT ((Data[46] XOR ((((Data[24] XOR Data[10]) XOR Data[35]) XOR (Data[18] AND Data[26])) XOR Data[24])) XOR Data[6])) OR (NOT Data[40])))) OR ((((NOT Data[24]) AND (NOT Data[30])) XOR (NOT Data[4])) XOR (NOT (((NOT ((Data[48] AND Data[1]) AND Data[29])) OR (Data[43] OR ((Data[3] OR Data[24]) AND Data[26]))) OR ((Data[11] XOR (((FALSE OR Data[12]) AND (Data[18] OR Data[46])) OR (Data[29] AND (NOT Data[39])))) XOR Data[11]))))) OR (NOT ((Data[36] XOR (Data[25] OR (((FALSE OR (((((Data[34] XOR Data[44]) XOR Data[45]) XOR Data[23]) XOR Data[13]) OR (((NOT Data[4]) XOR (FALSE OR Data[22])) XOR (Data[35] OR Data[35])))) XOR (Data[41] OR ((Data[23] XOR (NOT (NOT Data[30]))) XOR Data[40]))) XOR (((((Data[7] OR Data[13]) AND (Data[16] OR Data[46])) AND Data[24]) XOR (((Data[45] OR Data[32]) OR (Data[5] AND Data[30])) OR ((Data[5] XOR Data[28]) XOR (Data[29] AND Data[13])))) XOR (((NOT Data[17]) OR Data[50]) AND Data[28]))))) XOR (NOT Data[45])))));
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
