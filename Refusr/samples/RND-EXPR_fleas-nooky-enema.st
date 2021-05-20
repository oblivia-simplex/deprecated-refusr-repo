(*
This code implements a randomly grown symbolic expression:

!((!(IN47 & (!(IN17 | ((((!(IN4)) & (IN14 | IN5)) | (IN32 & (xor(xor(IN6, IN2), IN30)))) | (((xor(xor(IN35, IN6), IN22)) & (IN2 & IN10)) & ((xor(xor(IN5, IN30), IN41)) | (xor(xor(IN25, IN3), IN21))))))))) | (((xor(xor(IN27 & (!(!(IN12 | IN44))), IN27), !(xor(xor(IN48 | (!(false & IN37)), xor(xor((xor(xor(IN27, IN45), IN24)) | (IN16 & IN23), !(IN15)), IN13)), IN9 | (!(!(IN47))))))) & (xor(xor((!(xor(xor(!(IN21), !(IN16)), IN31))) & ((!((!(IN8)) | (IN35 & IN25))) | ((xor(xor(xor(xor(IN48, IN19), IN9), IN8 & IN35), IN45 | IN30)) & ((IN36 | IN34) | (IN29 & IN1)))), !((!((IN24 | IN8) | (xor(xor(IN14, IN34), IN43)))) | ((!(IN24)) & ((IN15 & IN6) | (!(IN20)))))), IN27))) | (xor(xor(IN5, ((((!(xor(xor(IN39, IN37), IN36))) | (xor(xor(xor(xor(IN47, IN13), IN15), IN32 & IN23), !(IN14)))) | (((!(IN26)) | (!(IN36))) | ((IN6 | IN24) & (!(IN33))))) & ((!(xor(xor(IN20 & IN40, xor(xor(IN40, IN32), IN35)), IN5))) | IN22)) & IN40), !(xor(xor(IN49, IN31 & (xor(xor(IN23, xor(xor(xor(xor(IN12, IN22), IN32), IN48), false & IN1)), (IN11 | IN17) | (IN43 | IN11)))), ((xor(xor(xor(xor(IN17, IN20), IN17), IN10 | IN2), IN32 | IN34)) & (!(!(IN34)))) & (((!(IN34)) | (true & IN39)) & ((IN5 | IN6) | (IN44 | IN35)))))))))

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
    Out := (NOT ((NOT (Data[47] AND (NOT (Data[17] OR ((((NOT Data[4]) AND (Data[14] OR Data[5])) OR (Data[32] AND ((Data[6] XOR Data[2]) XOR Data[30]))) OR ((((Data[35] XOR Data[6]) XOR Data[22]) AND (Data[2] AND Data[10])) AND (((Data[5] XOR Data[30]) XOR Data[41]) OR ((Data[25] XOR Data[3]) XOR Data[21])))))))) OR (((((Data[27] AND (NOT (NOT (Data[12] OR Data[44])))) XOR Data[27]) XOR (NOT (((Data[48] OR (NOT (FALSE AND Data[37]))) XOR (((((Data[27] XOR Data[45]) XOR Data[24]) OR (Data[16] AND Data[23])) XOR (NOT Data[15])) XOR Data[13])) XOR (Data[9] OR (NOT (NOT Data[47])))))) AND ((((NOT (((NOT Data[21]) XOR (NOT Data[16])) XOR Data[31])) AND ((NOT ((NOT Data[8]) OR (Data[35] AND Data[25]))) OR (((((Data[48] XOR Data[19]) XOR Data[9]) XOR (Data[8] AND Data[35])) XOR (Data[45] OR Data[30])) AND ((Data[36] OR Data[34]) OR (Data[29] AND Data[1]))))) XOR (NOT ((NOT ((Data[24] OR Data[8]) OR ((Data[14] XOR Data[34]) XOR Data[43]))) OR ((NOT Data[24]) AND ((Data[15] AND Data[6]) OR (NOT Data[20])))))) XOR Data[27])) OR ((Data[5] XOR (((((NOT ((Data[39] XOR Data[37]) XOR Data[36])) OR ((((Data[47] XOR Data[13]) XOR Data[15]) XOR (Data[32] AND Data[23])) XOR (NOT Data[14]))) OR (((NOT Data[26]) OR (NOT Data[36])) OR ((Data[6] OR Data[24]) AND (NOT Data[33])))) AND ((NOT (((Data[20] AND Data[40]) XOR ((Data[40] XOR Data[32]) XOR Data[35])) XOR Data[5])) OR Data[22])) AND Data[40])) XOR (NOT ((Data[49] XOR (Data[31] AND ((Data[23] XOR ((((Data[12] XOR Data[22]) XOR Data[32]) XOR Data[48]) XOR (FALSE AND Data[1]))) XOR ((Data[11] OR Data[17]) OR (Data[43] OR Data[11]))))) XOR ((((((Data[17] XOR Data[20]) XOR Data[17]) XOR (Data[10] OR Data[2])) XOR (Data[32] OR Data[34])) AND (NOT (NOT Data[34]))) AND (((NOT Data[34]) OR (TRUE AND Data[39])) AND ((Data[5] OR Data[6]) OR (Data[44] OR Data[35]))))))))));
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
