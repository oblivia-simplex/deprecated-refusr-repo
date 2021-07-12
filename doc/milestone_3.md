---
title: milestone report
author: [add your names here]
---


ReMath Milestone 3 Report
=========================


## A PLC Busybox 

Dillo, this is your section. What you had in the slide show is great, just reproduce that in prose and images here, please. 

## An Adaptive Property Testing Library

Anthony, do your thing. Again, the slide show was perfect, just translate that content here. 

## The Cockatrice GP Framework and the REFUSR System (In Progress)


Here's where I'll put my stuff. 


## Geography

<img src="https://i.imgur.com/DKBaDbn.png" width="100%" alt="Geographically constrained tournament delegation weights, on a 2-dimensional toroidal geometry">


![Five samples of tournament batches](https://i.imgur.com/lIHvtIk.jpg)


### 6-bit Multiplexor Experiment

#### Configuration

```
experiment_duration: 1500
preserve_population: true

selection:
  fitness_function: "fit"
  data: "./samples/2-MUX_overs-cohos-orbed_ALL.csv"
  d_fitness: 3
  t_size: 6
  fitness_sharing: true

genotype:
  max_depth: 8
  min_len: 4
  max_len: 500
  inputs_n: 7
  output_regs: [1]
  max_steps: 512
  mutation_rate: 0.1

population:
  size: [12, 12]
  toroidal: true
  locality: 16
  n_elites: 10
  migration_rate: 0.1
  migration_type: "elite"

logging:
  log_every: 1
  save_every: 50

```

#### Target as a Symbolic Expression

```
:((((~(~(D[3]) & ~(D[1])) | D[2]) & (~(D[3] & ~(D[1])) | D[6])) & (~(~(D[3]) & D[1]) | D[4])) & (~(D[3] & D[1]) | D[5]))
```

#### Target as a Structured Text (ST) Program

```
(*
This code implements a shuffled multiplexer with 2 control bits.
The control bits are: Data[3], Data[1]
The input bits are: Data[2], Data[6], Data[4], Data[5]

The symbolic expression is:
(((~(~(D[3]) & ~(D[1])) | D[2]) & (~(D[3] & ~(D[1])) | D[6])) & (~(~(D[3]) & D[1]) | D[4])) & (~(D[3] & D[1]) | D[5])

*)

FUNCTION_BLOCK F_CollectInput
  VAR_IN_OUT
      Data : ARRAY[1..10] OF BOOL;
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
  Finished := (j > 10);
END_FUNCTION_BLOCK


PROGRAM Boiler
  VAR
    Data  : ARRAY[1..10] OF BOOL;
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
    Out := (((((NOT ((NOT D[3]) AND (NOT D[1]))) OR D[2]) AND ((NOT (D[3] AND (NOT D[1]))) OR D[6])) AND ((NOT ((NOT D[3]) AND D[1])) OR D[4])) AND ((NOT (D[3] AND D[1])) OR D[5]));
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
```

#### Target as Truth Table

|D[1]|D[2]|D[3]|D[4]|D[5]|D[6]|OUT|
|----|----|----|----|----|----|---|
|0   |0   |0   |0   |0   |0   |0  |
|1   |0   |0   |0   |0   |0   |0  |
|0   |1   |0   |0   |0   |0   |1  |
|1   |1   |0   |0   |0   |0   |0  |
|0   |0   |1   |0   |0   |0   |0  |
|1   |0   |1   |0   |0   |0   |0  |
|0   |1   |1   |0   |0   |0   |0  |
|1   |1   |1   |0   |0   |0   |0  |
|0   |0   |0   |1   |0   |0   |0  |
|1   |0   |0   |1   |0   |0   |1  |
|0   |1   |0   |1   |0   |0   |1  |
|1   |1   |0   |1   |0   |0   |1  |
|0   |0   |1   |1   |0   |0   |0  |
|1   |0   |1   |1   |0   |0   |0  |
|0   |1   |1   |1   |0   |0   |0  |
|1   |1   |1   |1   |0   |0   |0  |
|0   |0   |0   |0   |1   |0   |0  |
|1   |0   |0   |0   |1   |0   |0  |
|0   |1   |0   |0   |1   |0   |1  |
|1   |1   |0   |0   |1   |0   |0  |
|0   |0   |1   |0   |1   |0   |0  |
|1   |0   |1   |0   |1   |0   |1  |
|0   |1   |1   |0   |1   |0   |0  |
|1   |1   |1   |0   |1   |0   |1  |
|0   |0   |0   |1   |1   |0   |0  |
|1   |0   |0   |1   |1   |0   |1  |
|0   |1   |0   |1   |1   |0   |1  |
|1   |1   |0   |1   |1   |0   |1  |
|0   |0   |1   |1   |1   |0   |0  |
|1   |0   |1   |1   |1   |0   |1  |
|0   |1   |1   |1   |1   |0   |0  |
|1   |1   |1   |1   |1   |0   |1  |
|0   |0   |0   |0   |0   |1   |0  |
|1   |0   |0   |0   |0   |1   |0  |
|0   |1   |0   |0   |0   |1   |1  |
|1   |1   |0   |0   |0   |1   |0  |
|0   |0   |1   |0   |0   |1   |1  |
|1   |0   |1   |0   |0   |1   |0  |
|0   |1   |1   |0   |0   |1   |1  |
|1   |1   |1   |0   |0   |1   |0  |
|0   |0   |0   |1   |0   |1   |0  |
|1   |0   |0   |1   |0   |1   |1  |
|0   |1   |0   |1   |0   |1   |1  |
|1   |1   |0   |1   |0   |1   |1  |
|0   |0   |1   |1   |0   |1   |1  |
|1   |0   |1   |1   |0   |1   |0  |
|0   |1   |1   |1   |0   |1   |1  |
|1   |1   |1   |1   |0   |1   |0  |
|0   |0   |0   |0   |1   |1   |0  |
|1   |0   |0   |0   |1   |1   |0  |
|0   |1   |0   |0   |1   |1   |1  |
|1   |1   |0   |0   |1   |1   |0  |
|0   |0   |1   |0   |1   |1   |1  |
|1   |0   |1   |0   |1   |1   |1  |
|0   |1   |1   |0   |1   |1   |1  |
|1   |1   |1   |0   |1   |1   |1  |
|0   |0   |0   |1   |1   |1   |0  |
|1   |0   |0   |1   |1   |1   |1  |
|0   |1   |0   |1   |1   |1   |1  |
|1   |1   |0   |1   |1   |1   |1  |
|0   |0   |1   |1   |1   |1   |1  |
|1   |0   |1   |1   |1   |1   |1  |
|0   |1   |1   |1   |1   |1   |1  |
|1   |1   |1   |1   |1   |1   |1  |



#### Implicit Fitness Sharing and Interaction Matrices


![Initial interaction matrix (randomly initialized)](https://i.imgur.com/b40TQJ3.png)

![Interaction matrix after 10 seconds](https://i.imgur.com/K6fCt5F.png)

![Interaction matrix after 100 seconds](https://i.imgur.com/BLcpeit.png)

![Interaction matrix after 738 seconds, at end of evolution](https://i.imgur.com/TsyewJO.png)


![Difficulty scores of the problem set over time](https://i.imgur.com/czMuwlw.png)

![](https://i.imgur.com/J337TcB.png)

![](https://i.imgur.com/tROum5I.png)

