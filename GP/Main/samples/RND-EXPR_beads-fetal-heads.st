(*
This code implements a randomly grown symbolic expression:

(((!((((!((IN5 & IN33) | (IN35 | IN14))) & (!(xor(xor(xor(xor(IN9, IN33), IN3), IN49 | IN12), IN43)))) & (IN16 | IN22)) | (IN9 | ((!(!(IN6 | IN26))) | (xor(xor(!(IN23 & true), (IN16 & IN22) | (!(IN20))), IN12)))))) | ((((xor(xor(xor(xor(IN28, (xor(xor(IN2, IN16), IN38)) & (xor(xor(IN24, IN21), IN24))), !(!(IN35))), !(IN31 & IN50)), xor(xor(xor(xor(!(IN26), xor(xor(IN1, IN45), IN39)), xor(xor(IN37, IN8), IN27)), xor(xor(IN1 | IN20, true & IN23), !(IN22))), xor(xor(!(IN39), xor(xor(IN1, IN47), IN27)), IN22 | IN16)))) | ((((!(IN26)) & (IN33 & IN22)) | ((xor(xor(IN45, IN43), IN41)) | (xor(xor(IN40, IN11), IN48)))) & ((xor(xor(IN24 | IN1, xor(xor(false, IN2), IN3)), IN5 | IN44)) | ((IN50 & IN2) | (!(IN49)))))) & (!(IN35))) | (xor(xor(!(!(!((IN50 | IN15) | (IN40 & IN2)))), ((((IN34 & IN30) | (IN45 | IN41)) & ((IN3 | IN38) | IN2)) & ((IN18 | (!(IN19))) | ((IN48 | IN30) & (!(IN7))))) | (!((xor(xor(IN29 | IN29, IN46 & IN22), IN18 | IN11)) & (!(IN49 & IN15))))), (!(xor(xor((!(IN26)) & IN35, (!(IN27)) & (IN23 | IN41)), IN49 | (!(IN47))))) & (!(!(xor(xor(xor(xor(IN8, IN50), IN23), xor(xor(IN6, IN18), IN22)), IN12 | IN7)))))))) & (xor(xor((((((!(xor(xor(IN14, IN6), IN3))) & IN4) | (!((IN14 & IN24) & (xor(xor(IN3, IN21), IN20))))) | ((((!(IN36)) & IN28) | IN2) & IN40)) | (!((IN13 | IN14) | (xor(xor((xor(xor(IN17, IN22), IN30)) & (IN35 | IN35), !(xor(xor(IN46, IN8), true))), !(IN22)))))) | (((!(IN50)) & (xor(xor(((xor(xor(IN26, IN26), IN31)) | (xor(xor(true, IN46), IN46))) | ((IN7 & IN17) & (xor(xor(IN5, IN38), IN21))), !((IN13 | IN22) & (IN16 | IN46))), xor(xor(xor(xor(IN37, IN36), xor(xor(IN2, IN44), IN18)), (IN28 & IN19) & (IN37 | IN20)), (IN24 & IN34) & (IN43 & IN45))))) | (IN39 | (((!(IN12)) | (IN21 | (!(IN38)))) & ((xor(xor(!(IN28), IN35 & IN29), !(IN50))) & ((xor(xor(IN42, IN19), IN47)) | IN42))))), xor(xor(!(xor(xor((((IN45 & IN48) & (xor(xor(IN21, IN32), IN36))) | ((IN20 | IN25) | (!(IN44)))) | (((!(IN28)) & IN15) | ((!(IN43)) | IN44)), xor(xor(xor(xor(IN7 | (xor(xor(IN43, IN3), IN10)), (!(IN1)) & IN48), !(xor(xor(IN34, IN19), IN42))), xor(xor((!(IN46)) | (IN32 & IN3), xor(xor(IN6 | IN20, !(IN29)), false & IN14)), !(!(IN20)))), xor(xor((xor(xor(IN24, IN27), IN37)) & IN26, !(IN33 & IN46)), !(xor(xor(IN7, IN41), IN38))))), xor(xor(!(!(IN26)), IN50), ((IN28 & IN17) & (xor(xor(IN4, IN38), IN9))) | ((IN16 | IN31) & (!(IN32)))))), !((!(!(!(xor(xor(IN9, IN1), IN39))))) & (!(IN1 & (!(xor(xor(IN20, IN38), false))))))), IN17)), xor(xor(xor(xor(((!(IN16 & (IN49 & IN24))) | (xor(xor((xor(xor(IN27, IN22), IN3)) | (xor(xor(false, IN46), IN40)), !(xor(xor(IN42, IN4), IN32))), IN22 & (xor(xor(IN8, IN30), IN3))))) | ((xor(xor(IN27 | (IN38 & IN36), xor(xor(IN24 | IN12, IN1 & IN37), !(IN39))), !(IN50 & IN47))) & (!((xor(xor(IN16, IN8), IN26)) | (IN49 | IN40)))), xor(xor(!(xor(xor(true, xor(xor(true, IN47), IN5 & IN29)), xor(xor(IN7 & IN8, IN19), !(IN23)))), (!(!(!(IN6)))) & IN9), true)), IN29), IN48), IN2)))) | IN11

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
    Out := ((((NOT ((((NOT ((Data[5] AND Data[33]) OR (Data[35] OR Data[14]))) AND (NOT ((((Data[9] XOR Data[33]) XOR Data[3]) XOR (Data[49] OR Data[12])) XOR Data[43]))) AND (Data[16] OR Data[22])) OR (Data[9] OR ((NOT (NOT (Data[6] OR Data[26]))) OR (((NOT (Data[23] AND TRUE)) XOR ((Data[16] AND Data[22]) OR (NOT Data[20]))) XOR Data[12]))))) OR (((((((Data[28] XOR (((Data[2] XOR Data[16]) XOR Data[38]) AND ((Data[24] XOR Data[21]) XOR Data[24]))) XOR (NOT (NOT Data[35]))) XOR (NOT (Data[31] AND Data[50]))) XOR (((((NOT Data[26]) XOR ((Data[1] XOR Data[45]) XOR Data[39])) XOR ((Data[37] XOR Data[8]) XOR Data[27])) XOR (((Data[1] OR Data[20]) XOR (TRUE AND Data[23])) XOR (NOT Data[22]))) XOR (((NOT Data[39]) XOR ((Data[1] XOR Data[47]) XOR Data[27])) XOR (Data[22] OR Data[16])))) OR ((((NOT Data[26]) AND (Data[33] AND Data[22])) OR (((Data[45] XOR Data[43]) XOR Data[41]) OR ((Data[40] XOR Data[11]) XOR Data[48]))) AND ((((Data[24] OR Data[1]) XOR ((FALSE XOR Data[2]) XOR Data[3])) XOR (Data[5] OR Data[44])) OR ((Data[50] AND Data[2]) OR (NOT Data[49]))))) AND (NOT Data[35])) OR (((NOT (NOT (NOT ((Data[50] OR Data[15]) OR (Data[40] AND Data[2]))))) XOR (((((Data[34] AND Data[30]) OR (Data[45] OR Data[41])) AND ((Data[3] OR Data[38]) OR Data[2])) AND ((Data[18] OR (NOT Data[19])) OR ((Data[48] OR Data[30]) AND (NOT Data[7])))) OR (NOT ((((Data[29] OR Data[29]) XOR (Data[46] AND Data[22])) XOR (Data[18] OR Data[11])) AND (NOT (Data[49] AND Data[15])))))) XOR ((NOT ((((NOT Data[26]) AND Data[35]) XOR ((NOT Data[27]) AND (Data[23] OR Data[41]))) XOR (Data[49] OR (NOT Data[47])))) AND (NOT (NOT ((((Data[8] XOR Data[50]) XOR Data[23]) XOR ((Data[6] XOR Data[18]) XOR Data[22])) XOR (Data[12] OR Data[7])))))))) AND ((((((((NOT ((Data[14] XOR Data[6]) XOR Data[3])) AND Data[4]) OR (NOT ((Data[14] AND Data[24]) AND ((Data[3] XOR Data[21]) XOR Data[20])))) OR ((((NOT Data[36]) AND Data[28]) OR Data[2]) AND Data[40])) OR (NOT ((Data[13] OR Data[14]) OR (((((Data[17] XOR Data[22]) XOR Data[30]) AND (Data[35] OR Data[35])) XOR (NOT ((Data[46] XOR Data[8]) XOR TRUE))) XOR (NOT Data[22]))))) OR (((NOT Data[50]) AND ((((((Data[26] XOR Data[26]) XOR Data[31]) OR ((TRUE XOR Data[46]) XOR Data[46])) OR ((Data[7] AND Data[17]) AND ((Data[5] XOR Data[38]) XOR Data[21]))) XOR (NOT ((Data[13] OR Data[22]) AND (Data[16] OR Data[46])))) XOR ((((Data[37] XOR Data[36]) XOR ((Data[2] XOR Data[44]) XOR Data[18])) XOR ((Data[28] AND Data[19]) AND (Data[37] OR Data[20]))) XOR ((Data[24] AND Data[34]) AND (Data[43] AND Data[45]))))) OR (Data[39] OR (((NOT Data[12]) OR (Data[21] OR (NOT Data[38]))) AND ((((NOT Data[28]) XOR (Data[35] AND Data[29])) XOR (NOT Data[50])) AND (((Data[42] XOR Data[19]) XOR Data[47]) OR Data[42])))))) XOR (((NOT ((((((Data[45] AND Data[48]) AND ((Data[21] XOR Data[32]) XOR Data[36])) OR ((Data[20] OR Data[25]) OR (NOT Data[44]))) OR (((NOT Data[28]) AND Data[15]) OR ((NOT Data[43]) OR Data[44]))) XOR (((((Data[7] OR ((Data[43] XOR Data[3]) XOR Data[10])) XOR ((NOT Data[1]) AND Data[48])) XOR (NOT ((Data[34] XOR Data[19]) XOR Data[42]))) XOR ((((NOT Data[46]) OR (Data[32] AND Data[3])) XOR (((Data[6] OR Data[20]) XOR (NOT Data[29])) XOR (FALSE AND Data[14]))) XOR (NOT (NOT Data[20])))) XOR (((((Data[24] XOR Data[27]) XOR Data[37]) AND Data[26]) XOR (NOT (Data[33] AND Data[46]))) XOR (NOT ((Data[7] XOR Data[41]) XOR Data[38]))))) XOR (((NOT (NOT Data[26])) XOR Data[50]) XOR (((Data[28] AND Data[17]) AND ((Data[4] XOR Data[38]) XOR Data[9])) OR ((Data[16] OR Data[31]) AND (NOT Data[32])))))) XOR (NOT ((NOT (NOT (NOT ((Data[9] XOR Data[1]) XOR Data[39])))) AND (NOT (Data[1] AND (NOT ((Data[20] XOR Data[38]) XOR FALSE))))))) XOR Data[17])) XOR (((((((NOT (Data[16] AND (Data[49] AND Data[24]))) OR (((((Data[27] XOR Data[22]) XOR Data[3]) OR ((FALSE XOR Data[46]) XOR Data[40])) XOR (NOT ((Data[42] XOR Data[4]) XOR Data[32]))) XOR (Data[22] AND ((Data[8] XOR Data[30]) XOR Data[3])))) OR ((((Data[27] OR (Data[38] AND Data[36])) XOR (((Data[24] OR Data[12]) XOR (Data[1] AND Data[37])) XOR (NOT Data[39]))) XOR (NOT (Data[50] AND Data[47]))) AND (NOT (((Data[16] XOR Data[8]) XOR Data[26]) OR (Data[49] OR Data[40]))))) XOR (((NOT ((TRUE XOR ((TRUE XOR Data[47]) XOR (Data[5] AND Data[29]))) XOR (((Data[7] AND Data[8]) XOR Data[19]) XOR (NOT Data[23])))) XOR ((NOT (NOT (NOT Data[6]))) AND Data[9])) XOR TRUE)) XOR Data[29]) XOR Data[48]) XOR Data[2]))) OR Data[11]);
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
