(*
This code implements a randomly grown symbolic expression:

xor(xor(!(IN14 & (!(!((xor(xor((!(!(IN25))) & ((IN4 | IN27) | IN40), xor(xor(IN45 & IN48, (!(IN36)) | (IN1 & IN33)), !(IN44 | IN43))), IN46 & (xor(xor(IN48 & IN29, IN17 | IN44), IN28 | IN22)))) & ((!((xor(xor(IN22, IN13), IN2)) & (!(IN31)))) | (((IN5 & IN48) & (IN32 & IN20)) & IN29)))))), IN21), xor(xor(xor(xor((xor(xor(!(IN39), (!(!((IN25 | IN46) & (IN25 | IN14)))) | (xor(xor(!(!(!(IN30))), (xor(xor(IN38, !(IN19)), IN16 | IN30)) & IN29), !(!(xor(xor(IN5, IN9), IN17)))))), (!(((xor(xor(IN7, IN10), IN15)) & (xor(xor(IN4, IN7), IN17))) & IN18)) & ((xor(xor(!(IN22 & IN36), (xor(xor(IN49, IN28), IN3)) | IN28), (xor(xor(IN39, IN28), IN36)) | (!(IN29)))) & ((!(IN7 & IN50)) | (!(IN17)))))) | (!(!(IN12))), xor(xor(!((!(IN49)) | (IN2 & IN28)), xor(xor(!((!(IN1)) | IN23), (!(IN2)) & (xor(xor(IN9 & ((IN25 & IN20) | (IN2 & IN27)), IN4), true))), !(((!(xor(xor(IN11, true), IN27))) & (!(IN37 & IN28))) & IN40))), IN11 & IN26)), IN12), xor(xor(IN29, (xor(xor((((xor(xor(IN12 & IN20, !(IN37)), false)) | (!(IN37 & false))) | IN28) | (((xor(xor(IN40 & IN41, IN1), IN37 | IN4)) | ((IN6 | IN48) | (!(IN5)))) & ((xor(xor(!(IN20), !(IN50)), IN37 | IN27)) & (!(!(IN36))))), !(!((xor(xor(!(IN45), !(IN8)), xor(xor(IN35, IN43), IN32))) & ((IN18 & IN14) & (IN17 | IN28))))), (xor(xor(IN50, IN29 | (xor(xor(IN42 | IN32, IN48), IN46 & true))), ((xor(xor(IN8, IN46), IN1)) & (!(IN46))) | (IN49 | IN7))) | (IN2 | ((!(xor(xor(IN8, IN10), IN30))) & (!(xor(xor(IN16, IN30), IN7))))))) & ((((IN4 | ((!(IN38)) | (IN3 | IN19))) | (xor(xor(!(IN46), IN39 & (!(IN35))), xor(xor(xor(xor(IN48, IN12), IN21), !(IN12)), IN41 & IN29)))) | (xor(xor(IN10 | ((!(IN12)) & (IN42 | IN3)), !((IN48 & IN34) | (IN19 | IN22))), xor(xor((!(IN8)) | (IN20 & IN39), IN28 & (IN28 & IN16)), !(xor(xor(IN21, IN12), IN7)))))) | (!(!((IN48 | (!(IN44))) | ((!(IN5)) & (IN49 | IN7))))))), IN2)), !(!((!(xor(xor(((IN13 & IN33) & IN43) | true, (xor(xor(false, IN14 | IN8), IN25 & IN46)) | ((IN46 | IN7) & (IN45 & IN20))), false | ((IN8 & IN27) | (xor(xor(IN24, IN7), IN32)))))) & (xor(xor(xor(xor(IN14, IN39 | (xor(xor(IN37 & IN41, xor(xor(IN39, IN24), IN26)), IN24))), xor(xor(xor(xor(xor(xor(IN49, IN15), IN29), IN7), IN14 & IN13), !(xor(xor(IN28, IN50), IN33))), !(IN27 & IN46))), IN29), (IN13 & IN8) & IN16))))))

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
    Out := (((NOT (Data[14] AND (NOT (NOT (((((NOT (NOT Data[25])) AND ((Data[4] OR Data[27]) OR Data[40])) XOR (((Data[45] AND Data[48]) XOR ((NOT Data[36]) OR (Data[1] AND Data[33]))) XOR (NOT (Data[44] OR Data[43])))) XOR (Data[46] AND (((Data[48] AND Data[29]) XOR (Data[17] OR Data[44])) XOR (Data[28] OR Data[22])))) AND ((NOT (((Data[22] XOR Data[13]) XOR Data[2]) AND (NOT Data[31]))) OR (((Data[5] AND Data[48]) AND (Data[32] AND Data[20])) AND Data[29]))))))) XOR Data[21]) XOR ((((((((NOT Data[39]) XOR ((NOT (NOT ((Data[25] OR Data[46]) AND (Data[25] OR Data[14])))) OR (((NOT (NOT (NOT Data[30]))) XOR (((Data[38] XOR (NOT Data[19])) XOR (Data[16] OR Data[30])) AND Data[29])) XOR (NOT (NOT ((Data[5] XOR Data[9]) XOR Data[17])))))) XOR ((NOT ((((Data[7] XOR Data[10]) XOR Data[15]) AND ((Data[4] XOR Data[7]) XOR Data[17])) AND Data[18])) AND ((((NOT (Data[22] AND Data[36])) XOR (((Data[49] XOR Data[28]) XOR Data[3]) OR Data[28])) XOR (((Data[39] XOR Data[28]) XOR Data[36]) OR (NOT Data[29]))) AND ((NOT (Data[7] AND Data[50])) OR (NOT Data[17]))))) OR (NOT (NOT Data[12]))) XOR (((NOT ((NOT Data[49]) OR (Data[2] AND Data[28]))) XOR (((NOT ((NOT Data[1]) OR Data[23])) XOR ((NOT Data[2]) AND (((Data[9] AND ((Data[25] AND Data[20]) OR (Data[2] AND Data[27]))) XOR Data[4]) XOR TRUE))) XOR (NOT (((NOT ((Data[11] XOR TRUE) XOR Data[27])) AND (NOT (Data[37] AND Data[28]))) AND Data[40])))) XOR (Data[11] AND Data[26]))) XOR Data[12]) XOR ((Data[29] XOR (((((((((Data[12] AND Data[20]) XOR (NOT Data[37])) XOR FALSE) OR (NOT (Data[37] AND FALSE))) OR Data[28]) OR (((((Data[40] AND Data[41]) XOR Data[1]) XOR (Data[37] OR Data[4])) OR ((Data[6] OR Data[48]) OR (NOT Data[5]))) AND ((((NOT Data[20]) XOR (NOT Data[50])) XOR (Data[37] OR Data[27])) AND (NOT (NOT Data[36]))))) XOR (NOT (NOT ((((NOT Data[45]) XOR (NOT Data[8])) XOR ((Data[35] XOR Data[43]) XOR Data[32])) AND ((Data[18] AND Data[14]) AND (Data[17] OR Data[28])))))) XOR (((Data[50] XOR (Data[29] OR (((Data[42] OR Data[32]) XOR Data[48]) XOR (Data[46] AND TRUE)))) XOR ((((Data[8] XOR Data[46]) XOR Data[1]) AND (NOT Data[46])) OR (Data[49] OR Data[7]))) OR (Data[2] OR ((NOT ((Data[8] XOR Data[10]) XOR Data[30])) AND (NOT ((Data[16] XOR Data[30]) XOR Data[7])))))) AND ((((Data[4] OR ((NOT Data[38]) OR (Data[3] OR Data[19]))) OR (((NOT Data[46]) XOR (Data[39] AND (NOT Data[35]))) XOR ((((Data[48] XOR Data[12]) XOR Data[21]) XOR (NOT Data[12])) XOR (Data[41] AND Data[29])))) OR (((Data[10] OR ((NOT Data[12]) AND (Data[42] OR Data[3]))) XOR (NOT ((Data[48] AND Data[34]) OR (Data[19] OR Data[22])))) XOR ((((NOT Data[8]) OR (Data[20] AND Data[39])) XOR (Data[28] AND (Data[28] AND Data[16]))) XOR (NOT ((Data[21] XOR Data[12]) XOR Data[7]))))) OR (NOT (NOT ((Data[48] OR (NOT Data[44])) OR ((NOT Data[5]) AND (Data[49] OR Data[7])))))))) XOR Data[2])) XOR (NOT (NOT ((NOT (((((Data[13] AND Data[33]) AND Data[43]) OR TRUE) XOR (((FALSE XOR (Data[14] OR Data[8])) XOR (Data[25] AND Data[46])) OR ((Data[46] OR Data[7]) AND (Data[45] AND Data[20])))) XOR (FALSE OR ((Data[8] AND Data[27]) OR ((Data[24] XOR Data[7]) XOR Data[32]))))) AND ((((Data[14] XOR (Data[39] OR (((Data[37] AND Data[41]) XOR ((Data[39] XOR Data[24]) XOR Data[26])) XOR Data[24]))) XOR ((((((Data[49] XOR Data[15]) XOR Data[29]) XOR Data[7]) XOR (Data[14] AND Data[13])) XOR (NOT ((Data[28] XOR Data[50]) XOR Data[33]))) XOR (NOT (Data[27] AND Data[46])))) XOR Data[29]) XOR ((Data[13] AND Data[8]) AND Data[16])))))));
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
