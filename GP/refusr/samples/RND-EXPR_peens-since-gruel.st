(*
This code implements a randomly grown symbolic expression:

xor(xor((!((((xor(xor(!(!(IN12 | IN12)), ((!(IN40)) | (IN7 & IN31)) | ((xor(xor(IN21, IN32), IN47)) & (IN27 | IN45))), !(!(!(IN26))))) | (xor(xor(IN6, ((IN4 & IN11) & (!(IN29))) | (!(!(IN9)))), (xor(xor(!(IN21), xor(xor(IN43, IN19), IN28)), IN32)) | true))) | (IN48 & ((((xor(xor(IN43, IN49), IN37)) | (xor(xor(IN48, IN12), IN29))) & (xor(xor(IN30, IN33 & IN29), IN3 & IN38))) & (IN36 & ((IN7 | IN5) & (!(IN22))))))) & IN15)) | IN23, IN44 | (!((IN10 & (xor(xor((!(!(IN9 & IN23))) & ((xor(xor(IN38 & IN15, xor(xor(IN1, IN44), IN41)), IN34)) | IN3), ((xor(xor(IN3 | IN10, xor(xor(IN26, IN48), IN11)), IN31 | IN9)) | (!(xor(xor(IN26, IN44), IN22)))) | IN7), (xor(xor(IN12, IN34), IN9 | IN19)) | IN37))) | (IN3 | IN16)))), xor(xor(true, IN41), xor(xor(xor(xor(IN27, ((xor(xor(!(IN6), xor(xor((xor(xor(IN12, IN43), IN35)) | (!(IN36)), xor(xor(IN34 | IN25, IN43 & IN12), !(IN16))), !(!(IN18)))), ((IN13 & IN1) | (IN4 | IN50)) & (!(xor(xor(IN12, IN13), IN23))))) & IN41) & (xor(xor((!((false | IN10) & (IN48 & IN31))) | (xor(xor(IN17, xor(xor(xor(xor(IN18, IN49), IN19), IN9), IN31)), (xor(xor(IN49, IN1), IN9)) & (xor(xor(IN9, IN31), IN42)))), ((IN4 | IN47) | IN2) | IN34), xor(xor(xor(xor((IN42 | IN4) | (IN12 | IN20), (!(IN8)) & (IN46 | IN24)), (IN8 | IN39) & true), (!(xor(xor(IN8, IN8), IN3))) & ((!(IN26)) & (IN31 | IN41))), !(IN32))))), !(((xor(xor((IN26 & IN24) | (IN3 | IN6), true & (true | IN44)), (xor(xor(IN36, IN8), IN39)) & (IN11 | IN3))) & ((!(IN10 | false)) & (xor(xor(IN22 & IN30, IN26), !(IN32))))) & IN8)), IN19), IN3 | ((((IN50 & (!(xor(xor(IN20, IN50), IN50)))) | ((xor(xor(IN41 | IN41, IN29 & IN48), IN9 & IN21)) | (xor(xor(xor(xor(IN11, IN46), IN46), IN5), !(IN50))))) | (!(xor(xor((IN11 & IN23) | (IN34 & IN20), (!(IN8)) & (xor(xor(IN37, true), IN12))), !(IN50 & IN14))))) | IN34))))

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
    Out := ((((NOT ((((((NOT (NOT (Data[12] OR Data[12]))) XOR (((NOT Data[40]) OR (Data[7] AND Data[31])) OR (((Data[21] XOR Data[32]) XOR Data[47]) AND (Data[27] OR Data[45])))) XOR (NOT (NOT (NOT Data[26])))) OR ((Data[6] XOR (((Data[4] AND Data[11]) AND (NOT Data[29])) OR (NOT (NOT Data[9])))) XOR ((((NOT Data[21]) XOR ((Data[43] XOR Data[19]) XOR Data[28])) XOR Data[32]) OR TRUE))) OR (Data[48] AND (((((Data[43] XOR Data[49]) XOR Data[37]) OR ((Data[48] XOR Data[12]) XOR Data[29])) AND ((Data[30] XOR (Data[33] AND Data[29])) XOR (Data[3] AND Data[38]))) AND (Data[36] AND ((Data[7] OR Data[5]) AND (NOT Data[22])))))) AND Data[15])) OR Data[23]) XOR (Data[44] OR (NOT ((Data[10] AND ((((NOT (NOT (Data[9] AND Data[23]))) AND ((((Data[38] AND Data[15]) XOR ((Data[1] XOR Data[44]) XOR Data[41])) XOR Data[34]) OR Data[3])) XOR (((((Data[3] OR Data[10]) XOR ((Data[26] XOR Data[48]) XOR Data[11])) XOR (Data[31] OR Data[9])) OR (NOT ((Data[26] XOR Data[44]) XOR Data[22]))) OR Data[7])) XOR (((Data[12] XOR Data[34]) XOR (Data[9] OR Data[19])) OR Data[37]))) OR (Data[3] OR Data[16]))))) XOR ((TRUE XOR Data[41]) XOR ((((Data[27] XOR (((((NOT Data[6]) XOR (((((Data[12] XOR Data[43]) XOR Data[35]) OR (NOT Data[36])) XOR (((Data[34] OR Data[25]) XOR (Data[43] AND Data[12])) XOR (NOT Data[16]))) XOR (NOT (NOT Data[18])))) XOR (((Data[13] AND Data[1]) OR (Data[4] OR Data[50])) AND (NOT ((Data[12] XOR Data[13]) XOR Data[23])))) AND Data[41]) AND ((((NOT ((FALSE OR Data[10]) AND (Data[48] AND Data[31]))) OR ((Data[17] XOR ((((Data[18] XOR Data[49]) XOR Data[19]) XOR Data[9]) XOR Data[31])) XOR (((Data[49] XOR Data[1]) XOR Data[9]) AND ((Data[9] XOR Data[31]) XOR Data[42])))) XOR (((Data[4] OR Data[47]) OR Data[2]) OR Data[34])) XOR ((((((Data[42] OR Data[4]) OR (Data[12] OR Data[20])) XOR ((NOT Data[8]) AND (Data[46] OR Data[24]))) XOR ((Data[8] OR Data[39]) AND TRUE)) XOR ((NOT ((Data[8] XOR Data[8]) XOR Data[3])) AND ((NOT Data[26]) AND (Data[31] OR Data[41])))) XOR (NOT Data[32]))))) XOR (NOT ((((((Data[26] AND Data[24]) OR (Data[3] OR Data[6])) XOR (TRUE AND (TRUE OR Data[44]))) XOR (((Data[36] XOR Data[8]) XOR Data[39]) AND (Data[11] OR Data[3]))) AND ((NOT (Data[10] OR FALSE)) AND (((Data[22] AND Data[30]) XOR Data[26]) XOR (NOT Data[32])))) AND Data[8]))) XOR Data[19]) XOR (Data[3] OR ((((Data[50] AND (NOT ((Data[20] XOR Data[50]) XOR Data[50]))) OR ((((Data[41] OR Data[41]) XOR (Data[29] AND Data[48])) XOR (Data[9] AND Data[21])) OR ((((Data[11] XOR Data[46]) XOR Data[46]) XOR Data[5]) XOR (NOT Data[50])))) OR (NOT ((((Data[11] AND Data[23]) OR (Data[34] AND Data[20])) XOR ((NOT Data[8]) AND ((Data[37] XOR TRUE) XOR Data[12]))) XOR (NOT (Data[50] AND Data[14]))))) OR Data[34])))));
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
