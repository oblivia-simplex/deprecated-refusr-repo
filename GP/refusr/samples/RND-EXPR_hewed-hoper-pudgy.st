(*
This code implements a randomly grown symbolic expression:

((IN43 & IN39) | (!((IN20 & ((IN38 | (!(xor(xor(!(IN25), IN22 | IN24), IN29 | IN3)))) | ((((IN14 | IN14) & (xor(xor(IN1, IN38), IN8))) & (!(IN47 & IN21))) | (IN34 & (xor(xor(xor(xor(IN1, IN18), true), xor(xor(IN14, IN1), IN2)), IN20 | IN27)))))) & ((!(!((xor(xor(!(IN40), !(IN47)), IN24)) | ((IN26 & IN13) | (IN14 | IN31))))) & (!(!(!((!(IN45)) & (!(IN24)))))))))) & ((((xor(xor(IN28, !(IN6)), (xor(xor((xor(xor(true, xor(xor(IN34, IN35), IN30)), IN25 & IN34)) & (IN34 & (!(IN12))), (!(IN38 | IN25)) & IN42), xor(xor(xor(xor(IN20, !(IN31)), IN12), (xor(xor(IN19, IN42), IN21)) & (IN18 & IN20)), (xor(xor(true, IN18), IN13)) & (xor(xor(IN29, IN6), IN10))))) | IN21)) | ((xor(xor(!(((xor(xor(IN4, IN3), IN27)) & IN36) | (IN35 & (!(IN33)))), ((xor(xor(xor(xor(IN12, IN2), IN9), xor(xor(IN39, IN32), IN30)), xor(xor(IN38, IN26), IN25))) | IN26) | (xor(xor((xor(xor(IN37, IN43), IN47)) | IN33, IN1 & (xor(xor(IN11, IN41), IN38))), (IN1 & IN39) | (!(IN13))))), (!(!(!(IN4)))) | (false | ((xor(xor(IN13, IN43), IN36)) | (IN35 | IN32))))) & (IN8 | (!(IN31))))) & (((((xor(xor(xor(xor(IN20, !(IN5)), IN6 | IN30), (IN34 & IN9) | (xor(xor(IN35, IN5), IN16))), xor(xor(IN5, IN3 | IN25), !(IN2)))) & (xor(xor((IN45 | IN10) | (IN49 & IN43), IN20), !(IN2 & IN11)))) | (!((xor(xor(IN17 | IN4, IN25), xor(xor(IN5, IN25), IN16))) & (xor(xor(!(IN43), IN40 & IN25), IN7 | IN48))))) | (IN48 | IN1)) | (!((!((xor(xor(!(IN45), IN8), !(IN21))) | IN34)) | IN9)))) | IN9)

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
    Out := (((Data[43] AND Data[39]) OR (NOT ((Data[20] AND ((Data[38] OR (NOT (((NOT Data[25]) XOR (Data[22] OR Data[24])) XOR (Data[29] OR Data[3])))) OR ((((Data[14] OR Data[14]) AND ((Data[1] XOR Data[38]) XOR Data[8])) AND (NOT (Data[47] AND Data[21]))) OR (Data[34] AND ((((Data[1] XOR Data[18]) XOR TRUE) XOR ((Data[14] XOR Data[1]) XOR Data[2])) XOR (Data[20] OR Data[27])))))) AND ((NOT (NOT ((((NOT Data[40]) XOR (NOT Data[47])) XOR Data[24]) OR ((Data[26] AND Data[13]) OR (Data[14] OR Data[31]))))) AND (NOT (NOT (NOT ((NOT Data[45]) AND (NOT Data[24]))))))))) AND (((((Data[28] XOR (NOT Data[6])) XOR ((((((TRUE XOR ((Data[34] XOR Data[35]) XOR Data[30])) XOR (Data[25] AND Data[34])) AND (Data[34] AND (NOT Data[12]))) XOR ((NOT (Data[38] OR Data[25])) AND Data[42])) XOR ((((Data[20] XOR (NOT Data[31])) XOR Data[12]) XOR (((Data[19] XOR Data[42]) XOR Data[21]) AND (Data[18] AND Data[20]))) XOR (((TRUE XOR Data[18]) XOR Data[13]) AND ((Data[29] XOR Data[6]) XOR Data[10])))) OR Data[21])) OR ((((NOT ((((Data[4] XOR Data[3]) XOR Data[27]) AND Data[36]) OR (Data[35] AND (NOT Data[33])))) XOR ((((((Data[12] XOR Data[2]) XOR Data[9]) XOR ((Data[39] XOR Data[32]) XOR Data[30])) XOR ((Data[38] XOR Data[26]) XOR Data[25])) OR Data[26]) OR (((((Data[37] XOR Data[43]) XOR Data[47]) OR Data[33]) XOR (Data[1] AND ((Data[11] XOR Data[41]) XOR Data[38]))) XOR ((Data[1] AND Data[39]) OR (NOT Data[13]))))) XOR ((NOT (NOT (NOT Data[4]))) OR (FALSE OR (((Data[13] XOR Data[43]) XOR Data[36]) OR (Data[35] OR Data[32]))))) AND (Data[8] OR (NOT Data[31])))) AND ((((((((Data[20] XOR (NOT Data[5])) XOR (Data[6] OR Data[30])) XOR ((Data[34] AND Data[9]) OR ((Data[35] XOR Data[5]) XOR Data[16]))) XOR ((Data[5] XOR (Data[3] OR Data[25])) XOR (NOT Data[2]))) AND ((((Data[45] OR Data[10]) OR (Data[49] AND Data[43])) XOR Data[20]) XOR (NOT (Data[2] AND Data[11])))) OR (NOT ((((Data[17] OR Data[4]) XOR Data[25]) XOR ((Data[5] XOR Data[25]) XOR Data[16])) AND (((NOT Data[43]) XOR (Data[40] AND Data[25])) XOR (Data[7] OR Data[48]))))) OR (Data[48] OR Data[1])) OR (NOT ((NOT ((((NOT Data[45]) XOR Data[8]) XOR (NOT Data[21])) OR Data[34])) OR Data[9])))) OR Data[9]));
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
