(*
This code implements a randomly grown symbolic expression:

xor(xor(!(xor(xor(((xor(xor(IN28, false), (xor(xor((IN5 | IN20) & IN27, (IN25 & IN12) & (!(IN47))), xor(xor(IN14 | IN16, xor(xor(IN17, IN42), IN9)), IN6 | IN50))) | (!(xor(xor(IN20 & IN18, IN41 & false), !(IN41)))))) & (!(!(xor(xor((IN4 | IN22) | (IN4 & IN4), (!(IN31)) & (!(IN11))), !(!(IN25))))))) | (IN22 | (!((((IN15 | IN11) & (IN10 | IN33)) | ((xor(xor(IN28, IN28), IN26)) & (IN10 & IN11))) | IN27))), !(!((xor(xor((xor(xor(IN4 & IN11, xor(xor(IN28, IN40), IN2)), IN2 | IN17)) & (!(IN16)), xor(xor(IN21 | (IN43 | IN19), xor(xor(IN42, IN25 | IN18), IN25 & IN49)), xor(xor(true, IN35 | true), !(IN36)))), (!(IN6 & IN31)) | (!(IN42 & IN48)))) & (xor(xor(IN22, (!(IN30)) | (xor(xor(!(IN11), !(IN42)), IN1 | IN27))), IN7 | ((IN2 | IN23) | (IN30 | IN49))))))), !(IN20 | (IN16 & ((!((IN39 & IN22) & (!(IN7)))) | (!(xor(xor(IN8 | IN15, IN21 | IN44), !(IN2))))))))), IN28), !(!(IN41 | (!(xor(xor(!(xor(xor(xor(xor(IN34 | IN30, IN36), xor(xor(IN31, IN38), IN14)), xor(xor(IN7 & IN44, IN11 & IN13), IN5 & IN15)), !(IN11 & IN10))), (IN14 | false) | IN29), (!(IN47)) & (!((xor(xor(IN17, IN6), IN4)) | (IN47 | IN10)))))))))

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
    Out := (((NOT ((((((Data[28] XOR FALSE) XOR (((((Data[5] OR Data[20]) AND Data[27]) XOR ((Data[25] AND Data[12]) AND (NOT Data[47]))) XOR (((Data[14] OR Data[16]) XOR ((Data[17] XOR Data[42]) XOR Data[9])) XOR (Data[6] OR Data[50]))) OR (NOT (((Data[20] AND Data[18]) XOR (Data[41] AND FALSE)) XOR (NOT Data[41]))))) AND (NOT (NOT ((((Data[4] OR Data[22]) OR (Data[4] AND Data[4])) XOR ((NOT Data[31]) AND (NOT Data[11]))) XOR (NOT (NOT Data[25])))))) OR (Data[22] OR (NOT ((((Data[15] OR Data[11]) AND (Data[10] OR Data[33])) OR (((Data[28] XOR Data[28]) XOR Data[26]) AND (Data[10] AND Data[11]))) OR Data[27])))) XOR (NOT (NOT (((((((Data[4] AND Data[11]) XOR ((Data[28] XOR Data[40]) XOR Data[2])) XOR (Data[2] OR Data[17])) AND (NOT Data[16])) XOR (((Data[21] OR (Data[43] OR Data[19])) XOR ((Data[42] XOR (Data[25] OR Data[18])) XOR (Data[25] AND Data[49]))) XOR ((TRUE XOR (Data[35] OR TRUE)) XOR (NOT Data[36])))) XOR ((NOT (Data[6] AND Data[31])) OR (NOT (Data[42] AND Data[48])))) AND ((Data[22] XOR ((NOT Data[30]) OR (((NOT Data[11]) XOR (NOT Data[42])) XOR (Data[1] OR Data[27])))) XOR (Data[7] OR ((Data[2] OR Data[23]) OR (Data[30] OR Data[49])))))))) XOR (NOT (Data[20] OR (Data[16] AND ((NOT ((Data[39] AND Data[22]) AND (NOT Data[7]))) OR (NOT (((Data[8] OR Data[15]) XOR (Data[21] OR Data[44])) XOR (NOT Data[2]))))))))) XOR Data[28]) XOR (NOT (NOT (Data[41] OR (NOT (((NOT (((((Data[34] OR Data[30]) XOR Data[36]) XOR ((Data[31] XOR Data[38]) XOR Data[14])) XOR (((Data[7] AND Data[44]) XOR (Data[11] AND Data[13])) XOR (Data[5] AND Data[15]))) XOR (NOT (Data[11] AND Data[10])))) XOR ((Data[14] OR FALSE) OR Data[29])) XOR ((NOT Data[47]) AND (NOT (((Data[17] XOR Data[6]) XOR Data[4]) OR (Data[47] OR Data[10]))))))))));
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
