(*
This code implements a randomly grown symbolic expression:

!(((IN8 & (((xor(xor((xor(xor(IN35 & IN19, !(IN2)), IN2)) & ((xor(xor(IN30, IN50), IN41)) | (!(IN35))), ((IN30 & IN28) & (xor(xor(IN2, IN28), IN4))) & (xor(xor(IN18 | IN27, IN9 & IN35), IN12 & IN6))), xor(xor((IN10 & IN14) & (xor(xor(IN6, IN1), IN48)), xor(xor(IN9, IN41 | IN49), false | IN34)), IN31))) & (!(((false | IN35) & IN15) & IN20))) & (xor(xor(IN9, xor(xor(!(IN25), (IN23 & (IN11 | IN39)) | ((IN39 | IN5) | (!(IN26)))), !(!(!(IN38))))), (!(IN1 | (!(IN31)))) | ((IN14 & IN30) & IN6))))) & (!(xor(xor((xor(xor(((!(IN39)) & (true | IN46)) & ((xor(xor(IN13, IN48), IN49)) | (!(IN43))), IN15), !(xor(xor(IN8 & IN6, xor(xor(IN35, IN42), IN13)), IN48 & IN45)))) & (IN17 & (IN26 | (xor(xor(IN39 & false, IN49), !(IN38))))), xor(xor(xor(xor(!(!(!(IN32))), xor(xor(!(xor(xor(IN41, IN2), IN48)), (IN35 & IN6) | (IN29 & IN32)), xor(xor(!(IN22), xor(xor(IN40, IN4), IN36)), IN23 & IN44))), ((IN35 | IN43) | (!(IN38))) | (!(IN26 | IN25))), !((!(IN33 | IN33)) & (xor(xor(xor(xor(IN25, IN3), IN39), IN40), IN26 | IN49)))), IN9)), IN26)))) | ((!((xor(xor(xor(xor(xor(xor((IN27 & IN28) | (IN45 & IN6), (IN25 & IN38) | (IN23 & IN23)), IN48 & (IN40 | IN29)), xor(xor((xor(xor(IN25, IN11), IN33)) & IN36, !(IN40)), xor(xor(IN47 | IN47, !(IN48)), IN30))), IN3), !((IN42 | IN22) & ((IN13 | IN19) & (!(IN22))))), xor(xor(!(IN41 | (IN38 | IN29)), xor(xor(!(IN6 & IN31), IN28), !(xor(xor(IN41, IN32), IN12)))), ((!(IN22)) | (!(IN2))) & (!(IN40 | false))))) | (xor(xor(xor(xor(((IN47 & IN7) & (!(IN19))) & IN3, (!(IN5 & true)) | (!(IN21 & IN16))), ((!(IN12)) & (xor(xor(IN36, IN38), IN43))) & (!(!(IN1)))), IN13), IN11)))) & (!(!((xor(xor(((!(IN5)) & IN1) & IN43, (IN35 & IN17) | IN39), IN32)) & (!(xor(xor(!(!(IN39)), IN13), xor(xor(!(IN20), IN2 & IN50), xor(xor(IN14, IN3), IN25))))))))))

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
    Out := (NOT (((Data[8] AND ((((((((Data[35] AND Data[19]) XOR (NOT Data[2])) XOR Data[2]) AND (((Data[30] XOR Data[50]) XOR Data[41]) OR (NOT Data[35]))) XOR (((Data[30] AND Data[28]) AND ((Data[2] XOR Data[28]) XOR Data[4])) AND (((Data[18] OR Data[27]) XOR (Data[9] AND Data[35])) XOR (Data[12] AND Data[6])))) XOR ((((Data[10] AND Data[14]) AND ((Data[6] XOR Data[1]) XOR Data[48])) XOR ((Data[9] XOR (Data[41] OR Data[49])) XOR (FALSE OR Data[34]))) XOR Data[31])) AND (NOT (((FALSE OR Data[35]) AND Data[15]) AND Data[20]))) AND ((Data[9] XOR (((NOT Data[25]) XOR ((Data[23] AND (Data[11] OR Data[39])) OR ((Data[39] OR Data[5]) OR (NOT Data[26])))) XOR (NOT (NOT (NOT Data[38]))))) XOR ((NOT (Data[1] OR (NOT Data[31]))) OR ((Data[14] AND Data[30]) AND Data[6]))))) AND (NOT ((((((((NOT Data[39]) AND (TRUE OR Data[46])) AND (((Data[13] XOR Data[48]) XOR Data[49]) OR (NOT Data[43]))) XOR Data[15]) XOR (NOT (((Data[8] AND Data[6]) XOR ((Data[35] XOR Data[42]) XOR Data[13])) XOR (Data[48] AND Data[45])))) AND (Data[17] AND (Data[26] OR (((Data[39] AND FALSE) XOR Data[49]) XOR (NOT Data[38]))))) XOR (((((NOT (NOT (NOT Data[32]))) XOR (((NOT ((Data[41] XOR Data[2]) XOR Data[48])) XOR ((Data[35] AND Data[6]) OR (Data[29] AND Data[32]))) XOR (((NOT Data[22]) XOR ((Data[40] XOR Data[4]) XOR Data[36])) XOR (Data[23] AND Data[44])))) XOR (((Data[35] OR Data[43]) OR (NOT Data[38])) OR (NOT (Data[26] OR Data[25])))) XOR (NOT ((NOT (Data[33] OR Data[33])) AND ((((Data[25] XOR Data[3]) XOR Data[39]) XOR Data[40]) XOR (Data[26] OR Data[49]))))) XOR Data[9])) XOR Data[26]))) OR ((NOT (((((((((Data[27] AND Data[28]) OR (Data[45] AND Data[6])) XOR ((Data[25] AND Data[38]) OR (Data[23] AND Data[23]))) XOR (Data[48] AND (Data[40] OR Data[29]))) XOR (((((Data[25] XOR Data[11]) XOR Data[33]) AND Data[36]) XOR (NOT Data[40])) XOR (((Data[47] OR Data[47]) XOR (NOT Data[48])) XOR Data[30]))) XOR Data[3]) XOR (NOT ((Data[42] OR Data[22]) AND ((Data[13] OR Data[19]) AND (NOT Data[22]))))) XOR (((NOT (Data[41] OR (Data[38] OR Data[29]))) XOR (((NOT (Data[6] AND Data[31])) XOR Data[28]) XOR (NOT ((Data[41] XOR Data[32]) XOR Data[12])))) XOR (((NOT Data[22]) OR (NOT Data[2])) AND (NOT (Data[40] OR FALSE))))) OR (((((((Data[47] AND Data[7]) AND (NOT Data[19])) AND Data[3]) XOR ((NOT (Data[5] AND TRUE)) OR (NOT (Data[21] AND Data[16])))) XOR (((NOT Data[12]) AND ((Data[36] XOR Data[38]) XOR Data[43])) AND (NOT (NOT Data[1])))) XOR Data[13]) XOR Data[11]))) AND (NOT (NOT ((((((NOT Data[5]) AND Data[1]) AND Data[43]) XOR ((Data[35] AND Data[17]) OR Data[39])) XOR Data[32]) AND (NOT (((NOT (NOT Data[39])) XOR Data[13]) XOR (((NOT Data[20]) XOR (Data[2] AND Data[50])) XOR ((Data[14] XOR Data[3]) XOR Data[25]))))))))));
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
