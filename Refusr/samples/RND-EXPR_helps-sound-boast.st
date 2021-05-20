(*
This code implements a randomly grown symbolic expression:

!(xor(xor((xor(xor((IN49 | (xor(xor(!(xor(xor(xor(xor(IN8, IN35), IN20), xor(xor(IN46, IN3), IN36)), !(IN18))), !(IN46)), !(xor(xor(IN45, !(IN41)), IN31 & IN32))))) | ((IN26 & IN5) | ((!((!(IN32)) | (IN35 & IN13))) | (!(!(!(IN14)))))), (!(xor(xor(IN3, IN23), IN36 & (IN21 | IN45)))) | IN1), ((xor(xor(IN5, IN47 & ((!(IN48)) | (IN29 | IN37))), !(IN20))) & (!((xor(xor(IN39 | IN3, IN18 & IN8), !(IN47))) | (IN5 & (xor(xor(IN42, IN8), IN34)))))) | ((!((!(!(IN31))) | ((xor(xor(IN42, IN50), IN50)) & (IN15 & IN15)))) & ((!((IN48 & IN15) & IN8)) & (xor(xor((xor(xor(IN21, IN23), IN32)) | IN33, xor(xor(IN2 & IN1, xor(xor(IN45, IN16), IN27)), IN2 & IN16)), xor(xor(IN50, IN8), !(IN6)))))))) | (!(IN5 | ((xor(xor((IN40 | IN10) | IN42, !(xor(xor(!(IN24), IN2 & IN21), IN41 | IN36))), !(IN19))) | (IN30 | (xor(xor((IN47 & IN33) | (!(IN15)), (!(IN47)) & (IN25 | IN8)), (IN42 & IN6) | (IN37 & IN25))))))), xor(xor(xor(xor(xor(xor((IN5 | ((IN44 & (IN1 & IN11)) & (!(IN26 | IN47)))) & (((!(xor(xor(IN16, IN7), IN43))) | (!(xor(xor(false, IN28), IN46)))) & (xor(xor(!(xor(xor(IN21, IN34), IN39)), !(IN26 | IN34)), (IN1 & IN44) & (xor(xor(IN43, IN1), IN47))))), ((!(!(IN32))) | (!(IN5 & IN31))) & (!(xor(xor((xor(xor(IN30, IN30), IN37)) & (IN13 & IN50), IN42), (xor(xor(IN20, IN44), IN30)) | (IN13 | IN32))))), IN26), (IN16 | ((IN18 & ((IN38 & IN9) & (xor(xor(IN34, IN26), IN40)))) & ((!(IN18)) & ((xor(xor(IN45, true), IN2)) | (!(IN16)))))) | IN35), IN30), ((!(!(xor(xor(xor(xor(IN13 & IN10, xor(xor(false, IN33), IN21)), !(IN8)), xor(xor(!(IN35), IN35), IN33 | IN9)), !(!(IN34)))))) | IN29) | (!(IN21 | ((((xor(xor(IN25, IN33), IN4)) & (!(IN26))) & (!(IN11))) & ((xor(xor(IN43, !(IN3)), false)) | (!(IN22 | IN8))))))), !(IN41))), ((!(((!(xor(xor(IN15 & true, IN6), IN48 & IN46))) | (!(IN44 & (IN19 & IN30)))) & ((!(xor(xor(IN45 & IN3, IN28), IN47 & IN44))) & IN20))) | IN46) | ((xor(xor(IN27, xor(xor(!((IN10 | IN27) | (IN24 | (IN38 | IN33))), IN37 & (IN7 | (xor(xor(!(IN46), xor(xor(IN20, IN42), IN46)), IN10)))), IN15 & (xor(xor((xor(xor(false, IN15), IN41)) | (IN19 & IN28), IN25 | (IN48 | IN14)), !(!(IN38)))))), IN9)) & (xor(xor((!((xor(xor(IN2 | IN41, IN15 & IN50), IN39 | IN34)) | ((xor(xor(IN50, IN15), IN2)) | (!(IN36))))) & IN11, !((!(IN26 & (IN10 & IN45))) & (!(IN19)))), (IN13 & (IN45 | (xor(xor(IN42 | IN30, IN44 & true), !(IN46))))) | (IN19 & ((!(xor(xor(IN26, IN9), IN43))) & ((!(IN29)) | (xor(xor(IN11, IN23), false))))))))))

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
    Out := (NOT (((((((Data[49] OR (((NOT ((((Data[8] XOR Data[35]) XOR Data[20]) XOR ((Data[46] XOR Data[3]) XOR Data[36])) XOR (NOT Data[18]))) XOR (NOT Data[46])) XOR (NOT ((Data[45] XOR (NOT Data[41])) XOR (Data[31] AND Data[32]))))) OR ((Data[26] AND Data[5]) OR ((NOT ((NOT Data[32]) OR (Data[35] AND Data[13]))) OR (NOT (NOT (NOT Data[14])))))) XOR ((NOT ((Data[3] XOR Data[23]) XOR (Data[36] AND (Data[21] OR Data[45])))) OR Data[1])) XOR ((((Data[5] XOR (Data[47] AND ((NOT Data[48]) OR (Data[29] OR Data[37])))) XOR (NOT Data[20])) AND (NOT ((((Data[39] OR Data[3]) XOR (Data[18] AND Data[8])) XOR (NOT Data[47])) OR (Data[5] AND ((Data[42] XOR Data[8]) XOR Data[34]))))) OR ((NOT ((NOT (NOT Data[31])) OR (((Data[42] XOR Data[50]) XOR Data[50]) AND (Data[15] AND Data[15])))) AND ((NOT ((Data[48] AND Data[15]) AND Data[8])) AND (((((Data[21] XOR Data[23]) XOR Data[32]) OR Data[33]) XOR (((Data[2] AND Data[1]) XOR ((Data[45] XOR Data[16]) XOR Data[27])) XOR (Data[2] AND Data[16]))) XOR ((Data[50] XOR Data[8]) XOR (NOT Data[6]))))))) OR (NOT (Data[5] OR (((((Data[40] OR Data[10]) OR Data[42]) XOR (NOT (((NOT Data[24]) XOR (Data[2] AND Data[21])) XOR (Data[41] OR Data[36])))) XOR (NOT Data[19])) OR (Data[30] OR ((((Data[47] AND Data[33]) OR (NOT Data[15])) XOR ((NOT Data[47]) AND (Data[25] OR Data[8]))) XOR ((Data[42] AND Data[6]) OR (Data[37] AND Data[25])))))))) XOR ((((((((Data[5] OR ((Data[44] AND (Data[1] AND Data[11])) AND (NOT (Data[26] OR Data[47])))) AND (((NOT ((Data[16] XOR Data[7]) XOR Data[43])) OR (NOT ((FALSE XOR Data[28]) XOR Data[46]))) AND (((NOT ((Data[21] XOR Data[34]) XOR Data[39])) XOR (NOT (Data[26] OR Data[34]))) XOR ((Data[1] AND Data[44]) AND ((Data[43] XOR Data[1]) XOR Data[47]))))) XOR (((NOT (NOT Data[32])) OR (NOT (Data[5] AND Data[31]))) AND (NOT (((((Data[30] XOR Data[30]) XOR Data[37]) AND (Data[13] AND Data[50])) XOR Data[42]) XOR (((Data[20] XOR Data[44]) XOR Data[30]) OR (Data[13] OR Data[32])))))) XOR Data[26]) XOR ((Data[16] OR ((Data[18] AND ((Data[38] AND Data[9]) AND ((Data[34] XOR Data[26]) XOR Data[40]))) AND ((NOT Data[18]) AND (((Data[45] XOR TRUE) XOR Data[2]) OR (NOT Data[16]))))) OR Data[35])) XOR Data[30]) XOR (((NOT (NOT (((((Data[13] AND Data[10]) XOR ((FALSE XOR Data[33]) XOR Data[21])) XOR (NOT Data[8])) XOR (((NOT Data[35]) XOR Data[35]) XOR (Data[33] OR Data[9]))) XOR (NOT (NOT Data[34]))))) OR Data[29]) OR (NOT (Data[21] OR (((((Data[25] XOR Data[33]) XOR Data[4]) AND (NOT Data[26])) AND (NOT Data[11])) AND (((Data[43] XOR (NOT Data[3])) XOR FALSE) OR (NOT (Data[22] OR Data[8])))))))) XOR (NOT Data[41]))) XOR (((NOT (((NOT (((Data[15] AND TRUE) XOR Data[6]) XOR (Data[48] AND Data[46]))) OR (NOT (Data[44] AND (Data[19] AND Data[30])))) AND ((NOT (((Data[45] AND Data[3]) XOR Data[28]) XOR (Data[47] AND Data[44]))) AND Data[20]))) OR Data[46]) OR (((Data[27] XOR (((NOT ((Data[10] OR Data[27]) OR (Data[24] OR (Data[38] OR Data[33])))) XOR (Data[37] AND (Data[7] OR (((NOT Data[46]) XOR ((Data[20] XOR Data[42]) XOR Data[46])) XOR Data[10])))) XOR (Data[15] AND (((((FALSE XOR Data[15]) XOR Data[41]) OR (Data[19] AND Data[28])) XOR (Data[25] OR (Data[48] OR Data[14]))) XOR (NOT (NOT Data[38])))))) XOR Data[9]) AND ((((NOT ((((Data[2] OR Data[41]) XOR (Data[15] AND Data[50])) XOR (Data[39] OR Data[34])) OR (((Data[50] XOR Data[15]) XOR Data[2]) OR (NOT Data[36])))) AND Data[11]) XOR (NOT ((NOT (Data[26] AND (Data[10] AND Data[45]))) AND (NOT Data[19])))) XOR ((Data[13] AND (Data[45] OR (((Data[42] OR Data[30]) XOR (Data[44] AND TRUE)) XOR (NOT Data[46])))) OR (Data[19] AND ((NOT ((Data[26] XOR Data[9]) XOR Data[43])) AND ((NOT Data[29]) OR ((Data[11] XOR Data[23]) XOR FALSE))))))))));
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
