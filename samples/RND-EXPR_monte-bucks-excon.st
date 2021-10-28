(*
This code implements a randomly grown symbolic expression:

IN34 & (((!(xor(xor(xor(xor(!(xor(xor(xor(xor(!(IN20), IN18), IN25), xor(xor(IN31 & IN24, IN21), !(IN25))), IN15)), !((xor(xor(IN46, IN23 | IN21), IN33 & IN48)) | (!(!(IN41))))), false | ((!(xor(xor(IN9, IN42), IN20))) & ((!(IN2)) | (IN13 | IN5)))), (IN5 | (xor(xor(xor(xor(xor(xor(IN50, false), IN48), !(IN16)), IN17 | IN4), IN27 & (IN16 | IN48)), (xor(xor(IN32, IN19), IN13)) & (IN3 | IN8)))) | (xor(xor(!((IN41 | IN14) & (!(IN7))), xor(xor(IN3, xor(xor(!(IN42), IN14), xor(xor(IN14, IN43), IN36))), xor(xor(IN39 & IN38, IN34 | IN41), IN9 & IN13))), !(!(!(IN28)))))), ((((xor(xor(false, IN39), IN18)) | (!(IN29))) & ((!(IN19)) & (!(IN13)))) | ((xor(xor(IN15, IN25 & IN5), false)) & ((xor(xor(IN32, IN20), IN50)) & (IN20 | IN41)))) | IN1))) | IN17) & (!(!(xor(xor((IN32 | (!(IN6 | (IN25 & IN4)))) & (((!(IN1)) & ((IN48 | IN37) | (!(IN28)))) | IN15), (!(xor(xor((IN13 | IN6) & (xor(xor(IN47, IN40), IN40)), IN17), IN5))) & ((xor(xor(!(IN7), xor(xor(IN50 & IN36, xor(xor(IN10, IN50), IN12)), IN4)), xor(xor(xor(xor(IN29, IN26), IN30), IN40 | IN2), xor(xor(IN27, IN25), IN42)))) & IN42)), IN16 | (!(xor(xor(!(IN16 | IN22), IN30), xor(xor(IN42 & IN47, IN40 | IN37), IN19 & IN32)))))))))

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
    Out := (Data[34] AND (((NOT (((((NOT (((((NOT Data[20]) XOR Data[18]) XOR Data[25]) XOR (((Data[31] AND Data[24]) XOR Data[21]) XOR (NOT Data[25]))) XOR Data[15])) XOR (NOT (((Data[46] XOR (Data[23] OR Data[21])) XOR (Data[33] AND Data[48])) OR (NOT (NOT Data[41]))))) XOR (FALSE OR ((NOT ((Data[9] XOR Data[42]) XOR Data[20])) AND ((NOT Data[2]) OR (Data[13] OR Data[5]))))) XOR ((Data[5] OR ((((((Data[50] XOR FALSE) XOR Data[48]) XOR (NOT Data[16])) XOR (Data[17] OR Data[4])) XOR (Data[27] AND (Data[16] OR Data[48]))) XOR (((Data[32] XOR Data[19]) XOR Data[13]) AND (Data[3] OR Data[8])))) OR (((NOT ((Data[41] OR Data[14]) AND (NOT Data[7]))) XOR ((Data[3] XOR (((NOT Data[42]) XOR Data[14]) XOR ((Data[14] XOR Data[43]) XOR Data[36]))) XOR (((Data[39] AND Data[38]) XOR (Data[34] OR Data[41])) XOR (Data[9] AND Data[13])))) XOR (NOT (NOT (NOT Data[28])))))) XOR ((((((FALSE XOR Data[39]) XOR Data[18]) OR (NOT Data[29])) AND ((NOT Data[19]) AND (NOT Data[13]))) OR (((Data[15] XOR (Data[25] AND Data[5])) XOR FALSE) AND (((Data[32] XOR Data[20]) XOR Data[50]) AND (Data[20] OR Data[41])))) OR Data[1]))) OR Data[17]) AND (NOT (NOT ((((Data[32] OR (NOT (Data[6] OR (Data[25] AND Data[4])))) AND (((NOT Data[1]) AND ((Data[48] OR Data[37]) OR (NOT Data[28]))) OR Data[15])) XOR ((NOT ((((Data[13] OR Data[6]) AND ((Data[47] XOR Data[40]) XOR Data[40])) XOR Data[17]) XOR Data[5])) AND ((((NOT Data[7]) XOR (((Data[50] AND Data[36]) XOR ((Data[10] XOR Data[50]) XOR Data[12])) XOR Data[4])) XOR ((((Data[29] XOR Data[26]) XOR Data[30]) XOR (Data[40] OR Data[2])) XOR ((Data[27] XOR Data[25]) XOR Data[42]))) AND Data[42]))) XOR (Data[16] OR (NOT (((NOT (Data[16] OR Data[22])) XOR Data[30]) XOR (((Data[42] AND Data[47]) XOR (Data[40] OR Data[37])) XOR (Data[19] AND Data[32]))))))))));
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
