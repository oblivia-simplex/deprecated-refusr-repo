(*
This code implements a randomly grown symbolic expression:

((!(!(IN21 & (xor(xor(false, !(!((xor(xor(false, IN2), IN25)) | (!(IN9))))), ((IN33 & (xor(xor(IN17, IN40), IN11))) & (xor(xor(xor(xor(IN20, IN38), IN8), IN28 & IN33), IN19 & IN13))) & IN13))))) & IN25) & ((!((xor(xor(IN28, xor(xor((!(!(IN8 | IN21))) | ((!(IN47 | IN48)) | (!(IN15))), (!(IN9)) | ((xor(xor(IN49 & IN47, IN49 & IN24), IN46 | IN22)) | (!(IN28)))), !(((IN34 & IN44) & IN48) & IN26))), !(xor(xor(!((xor(xor(IN22, IN48), IN19)) | IN13), IN46), !((xor(xor(IN22, IN42), IN14)) | IN16))))) & ((((xor(xor((false | IN22) & (IN6 & IN36), (!(IN36)) & (IN1 & IN42)), IN21 & IN2)) | IN42) | IN48) | (!(IN36))))) & (IN15 | ((xor(xor(!(!(xor(xor((IN30 | IN11) | (IN43 & IN31), IN43 & (IN50 | IN12)), (IN13 & IN46) | (IN47 & IN18)))), ((IN47 | ((!(IN45)) & IN30)) & (xor(xor(xor(xor(IN6, IN1 & IN6), IN47), xor(xor(IN1 | IN29, IN33), false)), IN35))) | (xor(xor(((!(IN21)) | (!(IN25))) & (IN46 & (IN9 | IN19)), xor(xor(!(IN12 | IN11), xor(xor(IN8 & IN17, IN35 & IN20), xor(xor(IN38, IN14), IN18))), IN36 | (IN49 | IN43))), xor(xor((IN5 & IN20) & (xor(xor(IN20, IN17), IN15)), (xor(xor(IN2, IN24), IN37)) & IN6), IN18 & (IN41 | IN4))))), !(xor(xor(IN3, IN35), (xor(xor(IN29 & IN48, xor(xor(IN41, IN30), IN24)), IN15 | IN43)) | ((!(IN29)) | (false | IN42)))))) & (!(!(IN21 | (((!(IN38)) | (IN48 | IN49)) | IN16)))))))

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
    Out := (((NOT (NOT (Data[21] AND ((FALSE XOR (NOT (NOT (((FALSE XOR Data[2]) XOR Data[25]) OR (NOT Data[9]))))) XOR (((Data[33] AND ((Data[17] XOR Data[40]) XOR Data[11])) AND ((((Data[20] XOR Data[38]) XOR Data[8]) XOR (Data[28] AND Data[33])) XOR (Data[19] AND Data[13]))) AND Data[13]))))) AND Data[25]) AND ((NOT (((Data[28] XOR ((((NOT (NOT (Data[8] OR Data[21]))) OR ((NOT (Data[47] OR Data[48])) OR (NOT Data[15]))) XOR ((NOT Data[9]) OR ((((Data[49] AND Data[47]) XOR (Data[49] AND Data[24])) XOR (Data[46] OR Data[22])) OR (NOT Data[28])))) XOR (NOT (((Data[34] AND Data[44]) AND Data[48]) AND Data[26])))) XOR (NOT (((NOT (((Data[22] XOR Data[48]) XOR Data[19]) OR Data[13])) XOR Data[46]) XOR (NOT (((Data[22] XOR Data[42]) XOR Data[14]) OR Data[16]))))) AND (((((((FALSE OR Data[22]) AND (Data[6] AND Data[36])) XOR ((NOT Data[36]) AND (Data[1] AND Data[42]))) XOR (Data[21] AND Data[2])) OR Data[42]) OR Data[48]) OR (NOT Data[36])))) AND (Data[15] OR ((((NOT (NOT ((((Data[30] OR Data[11]) OR (Data[43] AND Data[31])) XOR (Data[43] AND (Data[50] OR Data[12]))) XOR ((Data[13] AND Data[46]) OR (Data[47] AND Data[18]))))) XOR (((Data[47] OR ((NOT Data[45]) AND Data[30])) AND ((((Data[6] XOR (Data[1] AND Data[6])) XOR Data[47]) XOR (((Data[1] OR Data[29]) XOR Data[33]) XOR FALSE)) XOR Data[35])) OR (((((NOT Data[21]) OR (NOT Data[25])) AND (Data[46] AND (Data[9] OR Data[19]))) XOR (((NOT (Data[12] OR Data[11])) XOR (((Data[8] AND Data[17]) XOR (Data[35] AND Data[20])) XOR ((Data[38] XOR Data[14]) XOR Data[18]))) XOR (Data[36] OR (Data[49] OR Data[43])))) XOR ((((Data[5] AND Data[20]) AND ((Data[20] XOR Data[17]) XOR Data[15])) XOR (((Data[2] XOR Data[24]) XOR Data[37]) AND Data[6])) XOR (Data[18] AND (Data[41] OR Data[4])))))) XOR (NOT ((Data[3] XOR Data[35]) XOR ((((Data[29] AND Data[48]) XOR ((Data[41] XOR Data[30]) XOR Data[24])) XOR (Data[15] OR Data[43])) OR ((NOT Data[29]) OR (FALSE OR Data[42])))))) AND (NOT (NOT (Data[21] OR (((NOT Data[38]) OR (Data[48] OR Data[49])) OR Data[16]))))))));
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
