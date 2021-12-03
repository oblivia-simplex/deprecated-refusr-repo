(*
This code implements a randomly grown symbolic expression:

xor(xor(((!(xor(xor(xor(xor(IN26 | IN7, (!(!(IN29 | IN2))) | (!(!(xor(xor(IN18, IN45), IN3))))), IN24 & IN5), xor(xor(xor(xor(!(!(IN25 | IN32)), xor(xor(xor(xor(IN6 & IN50, IN30 & IN7), IN6), (xor(xor(IN5, IN21), IN37)) & (xor(xor(IN39, IN13), IN11))), (IN34 | IN37) | (IN45 & IN2))), (IN38 | (IN23 | IN8)) | (xor(xor(true, IN31), IN12))), (xor(xor((xor(xor(IN16, IN6), IN12)) & IN14, IN41), xor(xor(!(IN27), false | IN20), IN3 & IN37))) & (!(IN36))), !(!(IN12)))), ((xor(xor(!(IN44 & IN4), (xor(xor(IN13, IN29), IN19)) & (IN27 & IN50)), IN43 | (IN27 & IN8))) | (IN6 & ((IN16 | IN42) & (IN36 & IN3)))) | (xor(xor(!(xor(xor(xor(xor(IN36, IN40), IN47), xor(xor(IN45, true), IN10)), IN46 & IN11)), !(xor(xor(xor(xor(IN2, IN40), IN47), false), IN37))), IN27 | (xor(xor(IN38 | IN39, false & IN13), IN46))))))) | ((xor(xor(IN36, (xor(xor(xor(xor((xor(xor(IN20, IN32), IN47)) | (IN47 & IN25), IN30), (xor(xor(IN43, IN32), IN26)) & (!(IN35))), !(IN45)), !(!(IN8 & IN11)))) & (IN3 & (!((!(IN48)) | (IN20 | IN48))))), IN4)) | IN37)) | (xor(xor(xor(xor(IN23, true), (((((xor(xor(IN15, IN44), IN34)) & (!(IN23))) | IN47) & (xor(xor((IN2 | IN13) & (IN12 | IN7), xor(xor(IN31 | IN21, !(IN37)), !(IN15))), (IN36 | IN17) | (!(IN23))))) & (!((xor(xor(IN46 | IN33, IN42 & IN36), IN36)) | (IN9 & (IN18 & IN29))))) & (!((xor(xor(IN38, xor(xor(IN29 | IN39, xor(xor(IN4, IN45), IN24)), !(IN20))), xor(xor(IN35, xor(xor(IN10, IN48), IN26)), !(IN32)))) | IN42))), (!(IN20)) | (((IN21 | (((xor(xor(IN49, IN5), IN1)) | (IN18 | IN10)) | (xor(xor(xor(xor(IN45, IN29), IN5), xor(xor(IN44, IN49), IN43)), IN29 | IN10)))) | (IN33 & (!(IN46)))) & (xor(xor(!(xor(xor(IN5 & (IN27 & IN27), IN46), IN47 & (xor(xor(IN32, IN23), IN49)))), IN34), !((!(IN35 & IN46)) & IN41))))), IN20)), IN42), (((IN27 | (!(!((IN21 & (IN33 | IN46)) & IN10)))) & IN17) | ((!(IN14 & IN33)) & IN23)) & (!(IN11)))

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
    Out := (((((NOT (((((Data[26] OR Data[7]) XOR ((NOT (NOT (Data[29] OR Data[2]))) OR (NOT (NOT ((Data[18] XOR Data[45]) XOR Data[3]))))) XOR (Data[24] AND Data[5])) XOR (((((NOT (NOT (Data[25] OR Data[32]))) XOR (((((Data[6] AND Data[50]) XOR (Data[30] AND Data[7])) XOR Data[6]) XOR (((Data[5] XOR Data[21]) XOR Data[37]) AND ((Data[39] XOR Data[13]) XOR Data[11]))) XOR ((Data[34] OR Data[37]) OR (Data[45] AND Data[2])))) XOR ((Data[38] OR (Data[23] OR Data[8])) OR ((TRUE XOR Data[31]) XOR Data[12]))) XOR ((((((Data[16] XOR Data[6]) XOR Data[12]) AND Data[14]) XOR Data[41]) XOR (((NOT Data[27]) XOR (FALSE OR Data[20])) XOR (Data[3] AND Data[37]))) AND (NOT Data[36]))) XOR (NOT (NOT Data[12])))) XOR (((((NOT (Data[44] AND Data[4])) XOR (((Data[13] XOR Data[29]) XOR Data[19]) AND (Data[27] AND Data[50]))) XOR (Data[43] OR (Data[27] AND Data[8]))) OR (Data[6] AND ((Data[16] OR Data[42]) AND (Data[36] AND Data[3])))) OR (((NOT ((((Data[36] XOR Data[40]) XOR Data[47]) XOR ((Data[45] XOR TRUE) XOR Data[10])) XOR (Data[46] AND Data[11]))) XOR (NOT ((((Data[2] XOR Data[40]) XOR Data[47]) XOR FALSE) XOR Data[37]))) XOR (Data[27] OR (((Data[38] OR Data[39]) XOR (FALSE AND Data[13])) XOR Data[46])))))) OR (((Data[36] XOR ((((((((Data[20] XOR Data[32]) XOR Data[47]) OR (Data[47] AND Data[25])) XOR Data[30]) XOR (((Data[43] XOR Data[32]) XOR Data[26]) AND (NOT Data[35]))) XOR (NOT Data[45])) XOR (NOT (NOT (Data[8] AND Data[11])))) AND (Data[3] AND (NOT ((NOT Data[48]) OR (Data[20] OR Data[48])))))) XOR Data[4]) OR Data[37])) OR ((((Data[23] XOR TRUE) XOR (((((((Data[15] XOR Data[44]) XOR Data[34]) AND (NOT Data[23])) OR Data[47]) AND ((((Data[2] OR Data[13]) AND (Data[12] OR Data[7])) XOR (((Data[31] OR Data[21]) XOR (NOT Data[37])) XOR (NOT Data[15]))) XOR ((Data[36] OR Data[17]) OR (NOT Data[23])))) AND (NOT ((((Data[46] OR Data[33]) XOR (Data[42] AND Data[36])) XOR Data[36]) OR (Data[9] AND (Data[18] AND Data[29]))))) AND (NOT (((Data[38] XOR (((Data[29] OR Data[39]) XOR ((Data[4] XOR Data[45]) XOR Data[24])) XOR (NOT Data[20]))) XOR ((Data[35] XOR ((Data[10] XOR Data[48]) XOR Data[26])) XOR (NOT Data[32]))) OR Data[42])))) XOR ((NOT Data[20]) OR (((Data[21] OR ((((Data[49] XOR Data[5]) XOR Data[1]) OR (Data[18] OR Data[10])) OR ((((Data[45] XOR Data[29]) XOR Data[5]) XOR ((Data[44] XOR Data[49]) XOR Data[43])) XOR (Data[29] OR Data[10])))) OR (Data[33] AND (NOT Data[46]))) AND (((NOT (((Data[5] AND (Data[27] AND Data[27])) XOR Data[46]) XOR (Data[47] AND ((Data[32] XOR Data[23]) XOR Data[49])))) XOR Data[34]) XOR (NOT ((NOT (Data[35] AND Data[46])) AND Data[41])))))) XOR Data[20])) XOR Data[42]) XOR ((((Data[27] OR (NOT (NOT ((Data[21] AND (Data[33] OR Data[46])) AND Data[10])))) AND Data[17]) OR ((NOT (Data[14] AND Data[33])) AND Data[23])) AND (NOT Data[11])));
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
