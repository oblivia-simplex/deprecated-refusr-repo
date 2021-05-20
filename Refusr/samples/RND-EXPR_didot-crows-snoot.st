(*
This code implements a randomly grown symbolic expression:

((((xor(xor(IN5, xor(xor(xor(xor(((IN48 & IN29) | (IN9 | IN16)) & ((!(IN32)) & (xor(xor(IN31, IN7), IN31))), IN21 & (!(!(IN38)))), IN40 & ((IN8 & IN7) & (!(IN26)))), !(xor(xor(!(!(IN18)), xor(xor(IN2 & IN4, xor(xor(IN20, IN39), IN3)), IN20)), !(xor(xor(IN38, IN20), IN30))))), xor(xor(!(IN10), xor(xor(IN9, (!(IN6)) & (true & IN13)), xor(xor(xor(xor(IN27, IN43), false), xor(xor(IN49, IN1), IN26)), !(IN6)))), (!(!(IN27))) | (IN47 & (IN34 & IN35))))), (xor(xor(IN44, (!(!(IN15))) & (xor(xor(IN27 & IN46, IN40 & IN32), !(IN14)))), xor(xor(!(IN46 & IN21), !(!(IN46))), (xor(xor(IN25, IN12), IN13)) | (!(IN50))))) | (IN20 | ((!(xor(xor(IN22, IN46), IN28))) | (!(IN24)))))) & (((((IN24 & (!(IN48))) & (!(IN22))) | (!(!(!(IN24))))) | ((xor(xor((!(IN2)) | (!(IN5)), IN46), xor(xor(IN45 & IN25, IN43), IN43))) & (xor(xor(xor(xor(IN7, !(IN33)), xor(xor(IN3, IN5), IN17)), xor(xor(IN39 & IN18, !(IN8)), IN15 & IN24)), (!(IN38)) | (IN9 | IN17))))) & (xor(xor(IN20 & (xor(xor((IN35 | IN47) & (xor(xor(IN46, IN9), IN16)), IN17), xor(xor(!(IN14), IN31), !(IN44)))), xor(xor((xor(xor(xor(xor(IN38, IN15), IN25), IN36 & IN30), IN7 & IN34)) | (!(xor(xor(IN31, IN21), IN10))), !(xor(xor(xor(xor(IN47, IN11), IN2), IN25 | IN46), IN10))), IN21)), IN45)))) | (xor(xor(IN46 & (IN16 | (!((IN31 & (!(IN12))) & (!(IN31 & IN34))))), IN43 | ((!((!(IN7 | IN36)) | IN29)) & (!((xor(xor(!(IN39), IN7), xor(xor(IN2, IN38), IN16))) | (xor(xor(IN21 & IN38, IN39 | IN14), IN28 & IN3)))))), !(!(!(IN5 | (!(IN5 & IN46)))))))) & IN50) & IN18

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
    Out := ((((((Data[5] XOR (((((((Data[48] AND Data[29]) OR (Data[9] OR Data[16])) AND ((NOT Data[32]) AND ((Data[31] XOR Data[7]) XOR Data[31]))) XOR (Data[21] AND (NOT (NOT Data[38])))) XOR (Data[40] AND ((Data[8] AND Data[7]) AND (NOT Data[26])))) XOR (NOT (((NOT (NOT Data[18])) XOR (((Data[2] AND Data[4]) XOR ((Data[20] XOR Data[39]) XOR Data[3])) XOR Data[20])) XOR (NOT ((Data[38] XOR Data[20]) XOR Data[30]))))) XOR (((NOT Data[10]) XOR ((Data[9] XOR ((NOT Data[6]) AND (TRUE AND Data[13]))) XOR ((((Data[27] XOR Data[43]) XOR FALSE) XOR ((Data[49] XOR Data[1]) XOR Data[26])) XOR (NOT Data[6])))) XOR ((NOT (NOT Data[27])) OR (Data[47] AND (Data[34] AND Data[35])))))) XOR (((Data[44] XOR ((NOT (NOT Data[15])) AND (((Data[27] AND Data[46]) XOR (Data[40] AND Data[32])) XOR (NOT Data[14])))) XOR (((NOT (Data[46] AND Data[21])) XOR (NOT (NOT Data[46]))) XOR (((Data[25] XOR Data[12]) XOR Data[13]) OR (NOT Data[50])))) OR (Data[20] OR ((NOT ((Data[22] XOR Data[46]) XOR Data[28])) OR (NOT Data[24]))))) AND (((((Data[24] AND (NOT Data[48])) AND (NOT Data[22])) OR (NOT (NOT (NOT Data[24])))) OR (((((NOT Data[2]) OR (NOT Data[5])) XOR Data[46]) XOR (((Data[45] AND Data[25]) XOR Data[43]) XOR Data[43])) AND ((((Data[7] XOR (NOT Data[33])) XOR ((Data[3] XOR Data[5]) XOR Data[17])) XOR (((Data[39] AND Data[18]) XOR (NOT Data[8])) XOR (Data[15] AND Data[24]))) XOR ((NOT Data[38]) OR (Data[9] OR Data[17]))))) AND (((Data[20] AND ((((Data[35] OR Data[47]) AND ((Data[46] XOR Data[9]) XOR Data[16])) XOR Data[17]) XOR (((NOT Data[14]) XOR Data[31]) XOR (NOT Data[44])))) XOR (((((((Data[38] XOR Data[15]) XOR Data[25]) XOR (Data[36] AND Data[30])) XOR (Data[7] AND Data[34])) OR (NOT ((Data[31] XOR Data[21]) XOR Data[10]))) XOR (NOT ((((Data[47] XOR Data[11]) XOR Data[2]) XOR (Data[25] OR Data[46])) XOR Data[10]))) XOR Data[21])) XOR Data[45]))) OR (((Data[46] AND (Data[16] OR (NOT ((Data[31] AND (NOT Data[12])) AND (NOT (Data[31] AND Data[34])))))) XOR (Data[43] OR ((NOT ((NOT (Data[7] OR Data[36])) OR Data[29])) AND (NOT ((((NOT Data[39]) XOR Data[7]) XOR ((Data[2] XOR Data[38]) XOR Data[16])) OR (((Data[21] AND Data[38]) XOR (Data[39] OR Data[14])) XOR (Data[28] AND Data[3]))))))) XOR (NOT (NOT (NOT (Data[5] OR (NOT (Data[5] AND Data[46])))))))) AND Data[50]) AND Data[18]);
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
