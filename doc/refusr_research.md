# General drafts and notes

## The main idea

The stated objective of this project is to discover an automated means of reverse engineering the abstract specifications of mathematical functions, or structures, from particular concrete implementations – and in particular, from their implementations in source code, compiled binary code, and cyberphysical systems. And to use the techniques of machine learning to do so.

### Symbolic Regression

Our initial observation is that this problem, in its most general terms, closely resembles that of *symbolic regression*. Symbolic regression is a generic machine learning technique for discovering *functions*, or mathematical expressions, that best fit a set of datapoints. The mechanism that generates those datapoints – the function that we imagine we are approximating when we perform symbolic regression – remains, in this case, a black box. There's no reason why we cannot proceed, on a first pass, in the same fashion when it comes to recovering formally specified functions from their concrete implementations. So long as we indeed possess the implementation, we can execute it so as to generate as many datapoints as we like – and we can do this without "opening the box" and revealing the mechanism itself. Already, we have everything we need in order to tackle the problem as a type of symbolic regression.

### Opening the Black Box

But to do so obviously leaves something on the table. There is no reason, after all, why we *must* keep the mechanism concealed. Why not open the black box, and avail ourselves of whatever information we can find there, and use it to constrain and guide our symbolic regression?

It appears that we have at least three, potentially quite rich sources of information to draw on, for this purpose:

1.  the <span class="underline">static binary analysis</span> of the implementation
2.  the <span class="underline">dynamic analysis</span> of the implementation
3.  the probabilistic <span class="underline">property testing</span> of the boolean function, which we are free to probe with whichever inputs we choose

One of our first technical objectives will be to set up a system for performing these queries, and devising a domain specific language for expressing the properties that these techniques allow us to infer. These property expressions can then be used to constrain the evolutionary search for function specifications adequate to the implementation in question.

#### Static Binary Analysis

#### Dynamic Binary Analysis

#### Probabilistic Property Testing

Since we have at our disposal not merely a subset of the target function's graph, but the implementation itself, we can employ this implementation as an "oracle" of sorts: we can feed it any input we like and record its output.

This is all that we need to make use of the technique of *probabilistic property testing*.

  - cite Rubinfeld, Eric Blais

### Constrained Symbolic Regression (CDGP/LGGA)

### Encoding Genomes in Latent Space

# CDGP and LGGA

## Iwo Błądek and Krzysztof Krawiec, "Solving Symbolic Regression Problems with Formal Constraints"

``` bibtex
@inproceedings{bladek2019symbolic
author = {B\l{}\k{a}dek, Iwo and Krawiec, Krzysztof},
title = {Solving Symbolic Regression Problems with Formal Constraints},
year = {2019},
isbn = {9781450361118},
publisher = {Association for Computing Machinery},
address = {New York, NY, USA},
url = {https://doi.org/10.1145/3321707.3321743},
doi = {10.1145/3321707.3321743},
abstract = {In many applications of symbolic regression, domain knowledge constrains the space of admissible models by requiring them to have certain properties, like monotonicity, convexity, or symmetry. As only a handful of variants of genetic programming methods proposed to date can take such properties into account, we introduce a principled approach capable of synthesizing models that simultaneously match the provided training data (tests) and meet user-specified formal properties. To this end, we formalize the task of symbolic regression with formal constraints and present a range of formal properties that are common in practice. We also conduct a comparative experiment that confirms the feasibility of the proposed approach on a suite of realistic symbolic regression benchmarks extended with various formal properties. The study is summarized with discussion of results, properties of the method, and implications for symbolic regression.},
booktitle = {Proceedings of the Genetic and Evolutionary Computation Conference},
pages = {977–984},
numpages = {8},
keywords = {constraints, generalization, symbolic regression, formal verification, genetic programming},
location = {Prague, Czech Republic},
series = {GECCO '19}
}
```

## Dhananjay Ashok et al, "Logic Guided Genetic Algorithms"

The technique described here sounds strikingly similar to CDGP, as outlined above. There may be a few minor differences, but they don't leap immediately to mind.

``` bibtex
@misc{ashok2020logic,
  title={Logic Guided Genetic Algorithms}, 
  author={Dhananjay Ashok and Joseph Scott and Sebastian Wetzel and Maysum Panju and Vijay Ganesh},
  year={2020},
  eprint={2010.11328},
  archivePrefix={arXiv},
  primaryClass={cs.NE}
}
```

# Analysis of Boolean Functions

## Notes on the Harmonic Analysis of Boolean Functions

``` bibtex
@misc{hatami2014harmonic
title={COMP760: Harmonic Analysis of Boolean Functions},
author={Hamed Hatami},
year={2014},
}
```

### Property testing

> Blum, Luby, and Rubinfeld \[BLR90\] made a beautiful observation that given a function \(f: Z_2^n \rightarrow Z_2\), it is possible to inquire the value of \(f\) on a few random points, and accordingly probabilistically distinguish between the case that \(f\) is a linear function and the case that \(f\) has to be modified on at least \(\epsilon > 0\) fraction of points to become a linear function. Inspired by this observation, Rubinfeld and Sudan \[RS93\] defined the concept of property testing which is now a major area of research in theoretical computer science. Roughly speaking to test a function for a property means to examine the value of the function on a few random points, and accordingly (probabilistically) distinguish between the case that the function has the property and the case that it is not too close to any function with that property. Interestingly and to some extent surprisingly tehse tests exist for various basic properties. The first substantial investigation of property testing occurred in Goldreich, Goldwasser, and Ron \[GGR98\] who showed that several natural combinatorial properties are testable. Since then there has been a significant amount of research on classifying the testable properties in combinatorial and algebraic settings.

#### look up these references

#### develop a julia library that performs these tests, and a DSL for representing these properties in such a way as to be useful to CGDP

## *Property Testing of Boolean Functions*, by Jinyu Xie

``` bibtex
@phdthesis{xie2018thesis
  author       = {Jinyu Xie}, 
                  title        = {Property Testing of Boolean Functions},
                  school       = {Columbia},
                  year         = 2018,
                  month        = 6,
                  note         = {
      The field of property testing has been studied for decades, and Boolean functions are among the most classical subjects to study in this area.

      In this thesis we consider the property testing of Boolean functions: distinguishing whether an unknown Boolean function has some certain property (or equivalently, belongs to a certain class of functions), or is far from having this property. We study this problem under both the standard setting, where the distance between functions is measured with respect to the uniform distribution, as well as the distribution-free setting, where the distance is measured with respect to a fixed but unknown distribution.

      We obtain both new upper bounds and lower bounds for the query complexity of testing various properties of Boolean functions:
      - Under the standard model of property testing, we prove a lower bound of \Omega(n^{1/3}) for the query complexity of any adaptive algorithm that tests whether an n-variable Boolean function is monotone, improving the previous best lower bound of \Omega(n^{1/4}) by Belov and Blais in 2015. We also prove a lower bound of \Omega(n^{2/3}) for adaptive algorithms, and a lower bound of \Omega(n) for non-adaptive algorithms with one-sided errors that test unateness, a natural generalization of monotonicity. The latter lower bound matches the previous upper bound proved by Chakrabarty and Seshadhri in 2016, up to poly-logarithmic factors of n.

      - We also study the distribution-free testing of k-juntas, where a function is a k-junta if it depends on at most k out of its n input variables. The standard property testing of k-juntas under the uniform distribution has been well understood: it has been shown that, for adaptive testing of k-juntas the optimal query complexity is \Theta(k); and for non-adaptive testing of k-juntas it is \Theta(k^{3/2}). Both bounds are tight up to poly-logarithmic factors of k. However, this problem is far from clear under the more general setting of distribution-free testing. Previous results only imply an O(2^k)-query algorithm for distribution-free testing of k-juntas, and besides lower bounds under the uniform distribution setting that naturally extend to this more general setting, no other results were known from the lower bound side. We significantly improve these results with an O(k^2)-query adaptive distribution-free tester for k-juntas, as well as an exponential lower bound of \Omega(2^{k/3}) for the query complexity of non-adaptive distribution-free testers for this problem. These results illustrate the hardness of distribution-free testing and also the significant role of adaptivity under this setting.

      The field of property testing has been studied for decades, and Boolean functions are among the most classical subjects to study in this area.

      In this thesis we consider the property testing of Boolean functions: distinguishing whether an unknown Boolean function has some certain property (or equivalently, belongs to a certain class of functions), or is far from having this property. We study this problem under both the standard setting, where the distance between functions is measured with respect to the uniform distribution, as well as the distribution-free setting, where the distance is measured with respect to a fixed but unknown distribution.

      We obtain both new upper bounds and lower bounds for the query complexity of testing various properties of Boolean functions:
      - Under the standard model of property testing, we prove a lower bound of \Omega(n^{1/3}) for the query complexity of any adaptive algorithm that tests whether an n-variable Boolean function is monotone, improving the previous best lower bound of \Omega(n^{1/4}) by Belov and Blais in 2015. We also prove a lower bound of \Omega(n^{2/3}) for adaptive algorithms, and a lower bound of \Omega(n) for non-adaptive algorithms with one-sided errors that test unateness, a natural generalization of monotonicity. The latter lower bound matches the previous upper bound proved by Chakrabarty and Seshadhri in 2016, up to poly-logarithmic factors of n.

      - We also study the distribution-free testing of k-juntas, where a function is a k-junta if it depends on at most k out of its n input variables. The standard property testing of k-juntas under the uniform distribution has been well understood: it has been shown that, for adaptive testing of k-juntas the optimal query complexity is \Theta(k); and for non-adaptive testing of k-juntas it is \Theta(k^{3/2}). Both bounds are tight up to poly-logarithmic factors of k. However, this problem is far from clear under the more general setting of distribution-free testing. Previous results only imply an O(2^k)-query algorithm for distribution-free testing of k-juntas, and besides lower bounds under the uniform distribution setting that naturally extend to this more general setting, no other results were known from the lower bound side. We significantly improve these results with an O(k^2)-query adaptive distribution-free tester for k-juntas, as well as an exponential lower bound of \Omega(2^{k/3}) for the query complexity of non-adaptive distribution-free testers for this problem. These results illustrate the hardness of distribution-free testing and also the significant role of adaptivity under this setting.

      - In the end we also study distribution-free testing of other basic Boolean functions. Under the distribution-free setting, a lower bound of \Omega(n^{1/5}) was proved for testing of conjunctions, decision lists, and linear threshold functions by Glasner and Servedio in 2009, and an O(n^{1/3})-query algorithm for testing monotone conjunctions was shown by Dolev and Ron in 2011. Building on techniques developed in these two papers, we improve these lower bounds to \Omega(n^{1/3}), and specifically for the class of conjunctions we present an adaptive algorithm with query complexity O(n^{1/3}). Our lower and upper bounds are tight for testing conjunctions, up to poly-logarithmic factors of n.
      - In the end we also study distribution-free testing of other basic Boolean functions. Under the distribution-free setting, a lower bound of \Omega(n^{1/5}) was proved for testing of conjunctions, decision lists, and linear threshold functions by Glasner and Servedio in 2009, and an O(n^{1/3})-query algorithm for testing monotone conjunctions was shown by Dolev and Ron in 2011. Building on techniques developed in these two papers, we improve these lower bounds to \Omega(n^{1/3}), and specifically for the class of conjunctions we present an adaptive algorithm with query complexity O(n^{1/3}). Our lower and upper bounds are tight for testing conjunctions, up to poly-logarithmic factors of n.

                }
  }
```

### Abstract

The field of property testing has been studied for decades, and Boolean functions are among the most classical subjects to study in this area.

In this thesis we consider the property testing of Boolean functions: distinguishing whether an unknown Boolean function has some certain property (or equivalently, belongs to a certain class of functions), or is far from having this property. We study this problem under both the standard setting, where the distance between functions is measured with respect to the uniform distribution, as well as the distribution-free setting, where the distance is measured with respect to a fixed but unknown distribution.

We obtain both new upper bounds and lower bounds for the query complexity of testing various properties of Boolean functions:

  - Under the standard model of property testing, we prove a lower bound of *Ω*(n<sup>1/3</sup>) for the query complexity of any adaptive algorithm that tests whether an n-variable Boolean function is monotone, improving the previous best lower bound of *Ω*(n<sup>1/4</sup>) by Belov and Blais in 2015. We also prove a lower bound of *Ω*(n<sup>2/3</sup>) for adaptive algorithms, and a lower bound of *Ω*(n) for non-adaptive algorithms with one-sided errors that test unateness, a natural generalization of monotonicity. The latter lower bound matches the previous upper bound proved by Chakrabarty and Seshadhri in 2016, up to poly-logarithmic factors of n.

  - We also study the distribution-free testing of k-juntas, where a function is a k-junta if it depends on at most k out of its n input variables. The standard property testing of k-juntas under the uniform distribution has been well understood: it has been shown that, for adaptive testing of k-juntas the optimal query complexity is *Θ*(k); and for non-adaptive testing of k-juntas it is *Θ*(k<sup>3/2</sup>). Both bounds are tight up to poly-logarithmic factors of k. However, this problem is far from clear under the more general setting of distribution-free testing. Previous results only imply an O(2<sup>k</sup>)-query algorithm for distribution-free testing of k-juntas, and besides lower bounds under the uniform distribution setting that naturally extend to this more general setting, no other results were known from the lower bound side. We significantly improve these results with an O(k<sup>2</sup>)-query adaptive distribution-free tester for k-juntas, as well as an exponential lower bound of *Ω*(2<sup>k/3</sup>) for the query complexity of non-adaptive distribution-free testers for this problem. These results illustrate the hardness of distribution-free testing and also the significant role of adaptivity under this setting.

  - In the end we also study distribution-free testing of other basic Boolean functions. Under the distribution-free setting, a lower bound of *Ω*(n<sup>1/5</sup>) was proved for testing of conjunctions, decision lists, and linear threshold functions by Glasner and Servedio in 2009, and an O(n<sup>1/3</sup>)-query algorithm for testing monotone conjunctions was shown by Dolev and Ron in 2011. Building on techniques developed in these two papers, we improve these lower bounds to *Ω*(n<sup>1/3</sup>), and specifically for the class of conjunctions we present an adaptive algorithm with query complexity O(n<sup>1/3</sup>). Our lower and upper bounds are tight for testing conjunctions, up to poly-logarithmic factors of n.

## *Monotonicity Testing* by Sofya Raskhodnikova

``` bibtex
           @phdthesis{raskhodnikova1999,
                        author = {Jinyu Xie}, 
                       title        = {Monotonicity Testing},
                                        school       = {MIT},
                                        year         = 1999,
                                        month        = 5,
                                        note         = {
               We present improved algorithms for testing monotonicity of functions. Namely, given the absility to query an unknown function $f: \Sigma^n \into \Xi$, where $\Sigma$ and $\Xi$ are finite ordered sets, the test always accepts a monotone $f$ and rejects $f$ with high probability if it is $\epsilon$-far from being monotone (i.e., if every monotone function differs from $f$ on more than an $\epsilon$ fraction of the domain). For any $\epsilon > 0$, the query complexity of the test is $O((n/\epsilon) \cdot log |\Sigma| \cdot log |\Xi|)$. The previous best known bound was $O((n^2/\epsilon) \cdot |\Sigma|^2 \cdot |\Xi|)$.

          We also present an alternative test for the boolean range $\Xi = \{0,1\}$ whose query complexity is independent of alphabet size $|\Sigma|$.
     }
}


```

## *Testing Properties of Boolean Functions*, by Eric Blais

``` bibtex

@phdthesis{blais2012thesis,
title = {Testing properties of Boolean functions},
author = {Eric Blais},
school= {Canegie Mellon},
year = {2012},
month = 1}
```
