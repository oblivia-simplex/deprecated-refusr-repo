(*
This code implements a randomly grown symbolic expression:

(!(!((!((xor(xor((!(IN50 & IN40)) | ((xor(xor(IN25, IN48), IN45)) | (!(IN5))), (xor(xor(!(IN44), IN40 | IN25), !(IN39))) | ((xor(xor(IN39, IN46), IN37)) | (IN1 | IN32))), !(xor(xor(xor(xor(IN6, IN50), IN24), xor(xor(IN17, true), IN37)), xor(xor(true, IN48), IN13))))) & ((IN35 & (!(IN47))) & ((xor(xor(IN23 & IN22, IN2 & IN37), IN6 | true)) | (xor(xor(IN40, IN45 | IN9), IN42 & IN5)))))) | (xor(xor((((xor(xor(xor(xor(IN25, IN3), IN34), xor(xor(IN46, IN17), IN18)), IN23 & IN14)) | ((!(IN46)) & (IN8 | IN2))) & (!((xor(xor(IN25, IN19), IN42)) & (!(IN16))))) & ((xor(xor(xor(xor(true & IN31, !(IN14)), IN7 & IN30), IN21), IN18)) & ((!(IN16 & IN29)) | (!(!(IN28))))), ((xor(xor(xor(xor(IN37 | IN10, !(IN13)), IN30 | true), (xor(xor(IN25, IN7), IN15)) | (IN1 & IN31)), (xor(xor(IN7, IN29), IN14)) | (IN38 & IN27))) & (!((IN20 & IN25) & (xor(xor(IN18, IN13), IN34))))) | IN29), IN38))))) & ((xor(xor(xor(xor(IN2 | (IN37 | (!(xor(xor(IN47, IN31), xor(xor(xor(xor(IN29, IN18), IN30), IN33 | IN32), IN21 | IN40))))), !((!((!(IN43)) & (xor(xor(IN15, IN37), IN16 & IN49)))) & (xor(xor((!(!(IN16))) | (!(IN31 & IN33)), !((IN43 & IN11) & (IN30 | IN6))), !(xor(xor(!(IN9), IN21 & IN34), xor(xor(IN7, true), IN4))))))), ((IN22 | IN45) | (!((xor(xor(IN18, !(IN9)), !(IN13))) & (xor(xor(IN25, !(IN31)), IN20))))) & (xor(xor((((IN37 & IN22) | (IN9 | IN25)) & IN48) & (((IN20 & IN20) & (IN13 | IN8)) & (IN11 & IN7)), (IN3 | ((!(IN40)) & (!(IN33)))) | ((xor(xor(IN15, xor(xor(false, IN49), IN27)), xor(xor(IN36, IN19), IN36))) & (xor(xor(IN24, IN43 & IN35), IN8 & IN10)))), ((xor(xor(false, xor(xor(IN43, IN33), IN12)), IN45 | IN19)) & (xor(xor(IN35 & IN39, !(IN29)), IN4))) & (xor(xor(IN21, (!(IN34)) & (xor(xor(IN7, IN20), IN8))), (IN27 & IN41) & (IN2 | IN24)))))), !(IN41)), xor(xor(false, ((!(IN50 & IN2)) & (IN15 | (((IN18 & IN46) & (false & IN39)) & ((IN36 | IN28) | (!(IN19)))))) | (xor(xor(false & (((IN23 | IN12) | (IN9 & IN49)) & (!(IN26 | IN44))), IN48), IN21 | ((xor(xor(IN35, IN6 | false), IN9 & IN13)) | ((!(IN20)) & (!(IN23))))))), !(!(!(((IN21 & IN20) | (xor(xor(IN35, IN5), IN47))) & (xor(xor(IN4 | IN35, xor(xor(IN40, IN19), IN43)), IN44)))))))) & (!((xor(xor(IN39, IN23), IN3)) | ((xor(xor(IN25, !(IN42)), IN31)) | (xor(xor(((!(IN43 & IN30)) & (IN12 & IN48)) & ((!(IN44)) | IN42), (xor(xor(xor(xor(IN38, IN24 | IN20), IN1), xor(xor(true, IN36 | IN9), IN40 & IN33)), (IN44 & IN41) | (IN44 | IN48))) & true), IN17))))))

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
    Out := ((NOT (NOT ((NOT (((((NOT (Data[50] AND Data[40])) OR (((Data[25] XOR Data[48]) XOR Data[45]) OR (NOT Data[5]))) XOR ((((NOT Data[44]) XOR (Data[40] OR Data[25])) XOR (NOT Data[39])) OR (((Data[39] XOR Data[46]) XOR Data[37]) OR (Data[1] OR Data[32])))) XOR (NOT ((((Data[6] XOR Data[50]) XOR Data[24]) XOR ((Data[17] XOR TRUE) XOR Data[37])) XOR ((TRUE XOR Data[48]) XOR Data[13])))) AND ((Data[35] AND (NOT Data[47])) AND ((((Data[23] AND Data[22]) XOR (Data[2] AND Data[37])) XOR (Data[6] OR TRUE)) OR ((Data[40] XOR (Data[45] OR Data[9])) XOR (Data[42] AND Data[5])))))) OR (((((((((Data[25] XOR Data[3]) XOR Data[34]) XOR ((Data[46] XOR Data[17]) XOR Data[18])) XOR (Data[23] AND Data[14])) OR ((NOT Data[46]) AND (Data[8] OR Data[2]))) AND (NOT (((Data[25] XOR Data[19]) XOR Data[42]) AND (NOT Data[16])))) AND ((((((TRUE AND Data[31]) XOR (NOT Data[14])) XOR (Data[7] AND Data[30])) XOR Data[21]) XOR Data[18]) AND ((NOT (Data[16] AND Data[29])) OR (NOT (NOT Data[28]))))) XOR (((((((Data[37] OR Data[10]) XOR (NOT Data[13])) XOR (Data[30] OR TRUE)) XOR (((Data[25] XOR Data[7]) XOR Data[15]) OR (Data[1] AND Data[31]))) XOR (((Data[7] XOR Data[29]) XOR Data[14]) OR (Data[38] AND Data[27]))) AND (NOT ((Data[20] AND Data[25]) AND ((Data[18] XOR Data[13]) XOR Data[34])))) OR Data[29])) XOR Data[38])))) AND ((((((Data[2] OR (Data[37] OR (NOT ((Data[47] XOR Data[31]) XOR ((((Data[29] XOR Data[18]) XOR Data[30]) XOR (Data[33] OR Data[32])) XOR (Data[21] OR Data[40])))))) XOR (NOT ((NOT ((NOT Data[43]) AND ((Data[15] XOR Data[37]) XOR (Data[16] AND Data[49])))) AND ((((NOT (NOT Data[16])) OR (NOT (Data[31] AND Data[33]))) XOR (NOT ((Data[43] AND Data[11]) AND (Data[30] OR Data[6])))) XOR (NOT (((NOT Data[9]) XOR (Data[21] AND Data[34])) XOR ((Data[7] XOR TRUE) XOR Data[4]))))))) XOR (((Data[22] OR Data[45]) OR (NOT (((Data[18] XOR (NOT Data[9])) XOR (NOT Data[13])) AND ((Data[25] XOR (NOT Data[31])) XOR Data[20])))) AND ((((((Data[37] AND Data[22]) OR (Data[9] OR Data[25])) AND Data[48]) AND (((Data[20] AND Data[20]) AND (Data[13] OR Data[8])) AND (Data[11] AND Data[7]))) XOR ((Data[3] OR ((NOT Data[40]) AND (NOT Data[33]))) OR (((Data[15] XOR ((FALSE XOR Data[49]) XOR Data[27])) XOR ((Data[36] XOR Data[19]) XOR Data[36])) AND ((Data[24] XOR (Data[43] AND Data[35])) XOR (Data[8] AND Data[10]))))) XOR ((((FALSE XOR ((Data[43] XOR Data[33]) XOR Data[12])) XOR (Data[45] OR Data[19])) AND (((Data[35] AND Data[39]) XOR (NOT Data[29])) XOR Data[4])) AND ((Data[21] XOR ((NOT Data[34]) AND ((Data[7] XOR Data[20]) XOR Data[8]))) XOR ((Data[27] AND Data[41]) AND (Data[2] OR Data[24]))))))) XOR (NOT Data[41])) XOR ((FALSE XOR (((NOT (Data[50] AND Data[2])) AND (Data[15] OR (((Data[18] AND Data[46]) AND (FALSE AND Data[39])) AND ((Data[36] OR Data[28]) OR (NOT Data[19]))))) OR (((FALSE AND (((Data[23] OR Data[12]) OR (Data[9] AND Data[49])) AND (NOT (Data[26] OR Data[44])))) XOR Data[48]) XOR (Data[21] OR (((Data[35] XOR (Data[6] OR FALSE)) XOR (Data[9] AND Data[13])) OR ((NOT Data[20]) AND (NOT Data[23]))))))) XOR (NOT (NOT (NOT (((Data[21] AND Data[20]) OR ((Data[35] XOR Data[5]) XOR Data[47])) AND (((Data[4] OR Data[35]) XOR ((Data[40] XOR Data[19]) XOR Data[43])) XOR Data[44]))))))) AND (NOT (((Data[39] XOR Data[23]) XOR Data[3]) OR (((Data[25] XOR (NOT Data[42])) XOR Data[31]) OR (((((NOT (Data[43] AND Data[30])) AND (Data[12] AND Data[48])) AND ((NOT Data[44]) OR Data[42])) XOR (((((Data[38] XOR (Data[24] OR Data[20])) XOR Data[1]) XOR ((TRUE XOR (Data[36] OR Data[9])) XOR (Data[40] AND Data[33]))) XOR ((Data[44] AND Data[41]) OR (Data[44] OR Data[48]))) AND TRUE)) XOR Data[17]))))));
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
