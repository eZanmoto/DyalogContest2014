:Namespace Contest2016
⍝ === VARIABLES ===

AboutMe←,⊂'My name is Sean Kelleher and I''m a graduate of Computer Science at UCC.'

FilePath←'C:\Users\sean\Downloads\'

Reaction←,⊂'Had lots of fun teasing these out. Machine-learning-based problems could be an interesting topic for a set of APL problems in future years.'


⍝ === End of variables definition ===

(⎕IO ⎕ML ⎕WX)←1 1 3

:Namespace bio
(⎕IO ⎕ML ⎕WX)←1 0 3

∇ r←s1 interleave s2;insert;supstrs;c;supstrs_;supstr;start;idxs;overlaps;betweens;lengths
     ⍝ `s1 interleave s2`
     ⍝ - takes character vectors representing DNA strings as its left and right
     ⍝   arguments
     ⍝ - returns a character vector representing a shortest common supersequence of
     ⍝   the arguments
     
     ⍝ `xs insert y n` returns `xs` with `y` inserted after character `n`.
 insert←{y n←⍵ ⋄ (n↑⍺),y,(n↓⍺)}
     
     ⍝ `supstrs` is a vector of string and position pairs, where further changes to
     ⍝ the string must occur after the position.
 supstrs←⊂s1 0
 :For c :In s2
     supstrs_←⍬
     :For supstr start :In supstrs
         idxs←⍳⍴supstr
     
             ⍝ `overlaps` produces all superstrings where `c` overlaps a character
             ⍝ after `start` in `supstrs`.
         overlaps←,↓(⊂supstr),⍪((supstr=c)∧(idxs>start))/idxs
     
             ⍝ `betweens` produces all superstrings where `c` is inserted after
             ⍝ `start` in `supstrs`.
         betweens←{(supstr insert c ⍵)(⍵+1)}¨start #.util.to⍴supstr
         supstrs_,←overlaps,betweens
     :EndFor
     supstrs←supstrs_
 :EndFor
     
     ⍝ Return the shortest superstring.
 lengths←⊃∘⍴∘⊃¨supstrs
 r←⊃⊃(lengths=⌊/lengths)/supstrs
∇

∇ r←s1 maxMult s2;minkDiff;occurs;mostFreq
     ⍝ `s1 maxMult s2`
     ⍝ - takes vectors of positive real numbers representing multisets as its left
     ⍝   and right arguments
     ⍝ - returns a 2-element vector of
     ⍝   [1] the largest multiplicity of the inputs
     ⍝   [2] the absolute value of the number maximizing the shared masses of the
     ⍝       inputs
     
 minkDiff←,s1∘.-s2
 occurs←+/minkDiff∘.=minkDiff
 mostFreq←occurs=⌈/occurs
 r←⊃↓mostFreq⌿occurs,⍪minkDiff
∇

∇ r←pi reversals sigma;paths;revItvl;incPairs;unexpl;perm;swapIdxs;swaps;isNewSwap;newPaths;path
     ⍝ `pi reversals sigma`
     ⍝ - takes an integer vector left right argument representing pi as described on
 Rosalind.info
     ⍝ - takes an integer vector left argument representing sigma as described on
     ⍝   Rosalind.info
     ⍝ - returns a 2-element vector with elements of
     ⍝   [1] an integer representing the reversal distance between pi and sigma
     ⍝   [2] a vector of 2-element integer vectors representing the collection of
     ⍝       reversals sorting pi into sigma
     
 paths←#.map.empty #.map.put pi ⍬
     
     ⍝ `` returns `vec` with values in the interval [`a`, `b`] reversed.
 revItvl←{a b←⍵ ⋄ ((a-1)↑⍺),(⌽(a-1)↓b↑⍺),b↓⍺}
     
     ⍝ `inc_pairs n` returns all strictly increasing pairs of positive integers less
     ⍝ than `n` (i.e. {x,y | x,y<-Z, 1≤x<y≤n}).
 incPairs←{{(</¨⍵)/⍵},⍳⍵,⍵}
     
 unexpl←,⊂pi
     
     ⍝ This solution uses a plain BFS over the search space of string reversals while
     ⍝ using `paths` to keep track of the set of reversals used to achieve a given
     ⍝ reversal.
 :While 0<⍴unexpl
     perm←⊃unexpl
     :If perm≡sigma
         :Leave
     :EndIf
     swapIdxs←incPairs⍴perm
     swaps←perm∘revItvl¨swapIdxs
     isNewSwap←~swaps∊swaps∩1⌷paths
     path←⊃paths #.map.lookup perm
     newPaths←isNewSwap/⍉swaps,⍪{path,⊂⍵}¨swapIdxs
     paths #.map.put←newPaths
     unexpl←(1↓unexpl),1⌷newPaths
 :EndWhile
     
 path←⊃paths #.map.lookup sigma
 r←(⍴path)path
∇

∇ test;s1;s2
     
 s1←186.07931 287.12699 548.20532 580.18077 681.22845 706.27446 782.27613 968.35544 968.35544
 s2←101.04768 158.06914 202.09536 318.09979 419.14747 463.17369
 1 #.test.expect(s1 maxMult s2)(3 85.03163)
     
 2 #.test.expect(⍴'ACGTC'interleave'ATAT')(⍴'ACGTACT')
 3 #.test.expect(⍴'ATCTGAT'interleave'TGCATA')(⍴'ATGCATGAT')
     
 4 #.test.expect(1 2 3 4 5 6 7 8 9 10 reversals 1 8 9 3 2 7 6 5 4 10)((,2)((4 9)(2 5)))
∇

:EndNamespace 
:Namespace fin
(⎕IO ⎕ML ⎕WX)←1 0 3

∇ r←maturities forward rates;fwdRate;tpVec
     ⍝ `maturities forward rates`
     ⍝ - takes a numeric vector left argument representing a list of maturities
     ⍝   expressed in years; fractional years are allowed (e.g. .25 would correspond
     ⍝   to a 3-month maturity)
     ⍝ - takes a numeric vector right argument representing a list of spot rates
     ⍝ - returns a numeric vector of the computed forward rates
     
     ⍝ `(t1 t2) fwdRate (r1 r2)` returns the forward rate of two consecutive spot
     ⍝ rates (`r1` and `r2`) and their corresponding maturities (`t1` and `t2`).
 fwdRate←{(⍵-.×⍺)÷-/⍺}
     
     ⍝ `tpVec v` transposes a vector `v`, i.e. it returns the vector
     ⍝ `(v11 v21 ... vm1) (v12 v22 ... vm2) ... (v1n v2n ... vmn)`, where
     ⍝ `v≡(v11 v12 ... v1n) (v21 v22 ... v2n) ... (vm1 vm2 ... vmn)`.
 tpVec←{↓⍉↑⍵}
     
 r←fwdRate/¨tpVec 2,/¨(0,maturities)(0,rates)
∇

∇ r←abc pdf value;a;b;c;x;mod
     ⍝ `abc pdf value`
     ⍝ - takes a single numeric right argument
     ⍝ - takes a 3-element numeric vector left argument describing the triangular
     ⍝   distribution (representing a, b, and c respectively)
     ⍝ - returns the value of the probability density function for the triangular
     ⍝   distribution described by the right argument . The value should be between 0 and 1.
     
 a b c←abc
 x←value c
 mod←÷/(1+value>c)⊃(x-a)(b-x)
 r←(2÷(b-a))×mod
∇

∇ r←abc pdf2 values;itvl;cdf
     ⍝ `abc pdf2 values`
     ⍝ - takes either a single numeric right argument or a 2-element numeric vector
     ⍝   representing an observation or a range of observations.
     ⍝ - takes a 3-element numeric vector left argument representing a, b, and c
     ⍝   respectively
     ⍝ - returns the probability (expressed as a number between 0 and 1) that a value
     ⍝   in the right argument will occur in the distribution described by the left
     ⍝   argument
     
     ⍝ `x op itvl ys` returns a binary vector of length `1+⍴ys` that contains a
     ⍝ single `1` at the interval where `ys[i] op x op' ys[i+1]`, where `op'` is the
     ⍝ complement of the binary comparator `op` and `ys` is a monotonic numerical
     ⍝ vector.
     ⍝
     ⍝ Example:
     ⍝
     ⍝           rg,⍪ ≤itvl∘2 4 6 ¨rg←⍳7
     ⍝     ┌─┬───────┐
     ⍝     │1│1 0 0 0│
     ⍝     ├─┼───────┤
     ⍝     │2│1 0 0 0│
     ⍝     ├─┼───────┤
     ⍝     │3│0 1 0 0│
     ⍝     ├─┼───────┤
     ⍝     │4│0 1 0 0│
     ⍝     ├─┼───────┤
     ⍝     │5│0 0 1 0│
     ⍝     ├─┼───────┤
     ⍝     │6│0 0 1 0│
     ⍝     ├─┼───────┤
     ⍝     │7│0 0 0 1│
     ⍝     └─┴───────┘
 itvl←{(X,1)∧(1,~X←⍺ ⍺⍺ ⍵)}
     
 cdf←{
     a b c←⍺
     x←⍵ c
     num denom←(1+⍵>c)⊃(x-a)(b-x)
     r←(num*2)÷denom×b-a
     ⊃(⍵≤itvl a c b)/0 r(1-r)1
 }
     
 r←-/⌽abc∘cdf¨values
∇

∇ r←profit;likelihoods;unitsSold;unitPrice;fixedCosts;genProb;unitCost;likeliVec;trials;climates;results;ranges;rs
     ⍝ `profit`
     ⍝ - returns a 2-column numeric matrix of:
     ⍝   [;1] profit (or loss) in $10,000 increments
     ⍝   [;2] the probability expressed as a percentage to 2 decimal places
     
 likelihoods←10 30 40 20
 unitsSold←1000×50 75 100 125
 unitPrice←13 10 8.5 8
 fixedCosts←125000
     
     ⍝ `genProb n` generates a probability value `x÷n`, where `1≤x≤n`.
 genProb←{(?⍵)÷⍵}
     
     ⍝ `unitCost` generates a value in the range [5, 8] with two points of precision
     ⍝ and most likely value of 7.
 unitCost←{100÷⍨500 800(500 800 700∘pdf2)#.util.binIntSearch(genProb 1000)}
     
     ⍝ The probability of choosing a value `x` where `x∊likelihoods` is
     ⍝ `x÷+/likelihoods`.
 likeliVec←(likelihoods÷10)/⍳⍴likelihoods
     
 trials←?10000⍴10
 climates←(⊃∘likeliVec)¨trials
     
     ⍝ We use `unitCost 0` because `unitCost` is niladic.
 results←{⍵⊃(unitsSold×unitPrice-unitCost 0)-fixedCosts}¨climates
     
     ⍝ `ranges xs` returns a 2-column numeric matrix of
     ⍝ [;1] the ascending range of integers that values of `xs` lie between
     ⍝ [;2] the number of values of `xs` that lie within that range
     ⍝
     ⍝ Example:
     ⍝
     ⍝           ranges 1 1.5 1.75 1.875 2 2.5 3
     ⍝     1 4
     ⍝     2 2
     ⍝     3 1
 ranges←{
     min max←⌊(⌊/⍵)(⌈/⍵)
     range←min #.util.to max
     occurs←⍵∘.{(⍵≤⍺)∧(⍺<⍵+1)}range
     range,⍪+⌿occurs
 }
     
     ⍝ Format the profit ranges.
 r←ranges(results÷10000)
 r←(r[;1]×10000),⍪(#.util.roundDn∘2¨r[;2]÷⍴trials)
     
     ⍝ We remove profits/losses that have 0% chance of occurring after rounding down.
 r←(r[;2]≠0)⌿r
∇

∇ test;maturities;rates;profits
     
 maturities←0.25 0.5 1 2 3 5 7 10 20
 rates←2.51 2.79 2.96 3.29 3.43 3.71 3.92 4.14 4.64
 1 #.test.expect(#.util.roundDn∘4¨maturities forward rates)(2.51 3.07 3.13 3.62 3.71 4.13 4.445 4.6533 5.14)
     
 2 #.test.expect(1 11 3 pdf 3)(0.2)
 3 #.test.expect(1 11 3∘pdf¨⍳11)(0 0.1 0.2 0.175 0.15 0.125 0.1 0.075 0.05 0.025 0)
     
 4 #.test.expect(1 11 3 pdf2 3)(0.2)
 5 #.test.expect(1 11 3 pdf2 2 4)(0.3375)
     
 profits←profit
 6 #.test.expect(1≥+/profits[;2])(1)
 7 #.test.expect(∧/{⍵=⌊⍵}¨100×profits[;2])(1)
 8 #.test.expect(∨/0=profits[;2])(0)
∇

:EndNamespace 
:Namespace gen
(⎕IO ⎕ML ⎕WX)←1 0 3

∇ r←chiSquareTest counts;exp
     ⍝ `chiSquareTest counts`
     ⍝ - takes a right argument of a numeric matrix of counts
     ⍝ - returns the Chi-square test statistic
     
 exp←expected counts
 r←(+/⍣2)exp÷⍨(counts-exp)*2
∇

∇ r←expected counts;rowCounts;colCounts
     ⍝ `expected counts`
     ⍝ - takes a right argument of a numeric matrix of counts
     ⍝ - returns a numeric matrix of expected values
     
 rowCounts←+/counts
 colCounts←+⌿counts
 r←(rowCounts∘.×colCounts)÷+/rowCounts
∇

∇ r←drugs matchDrugs inputs;dists
     ⍝ `drugs matchDrugs inputs`
     ⍝ - takes a right argument representing the list of physician inputs
     ⍝ - takes a left argument representing the list of database drug names
     ⍝ - returns an integer vector where each element is index in the list of drug
     ⍝   names representing the best match for the corresponding element in the list
     ⍝   of inputs.
     
 dists←inputs∘.#.dist.words drugs
 r←⍳/(↓dists),⍪(⌊/dists)
∇

∇ test;board;counts;d;i
     
 board←5 5⍴'∘∘∘∘∘∘∘BB∘RRBB∘∘RR∘∘∘∘∘∘∘'
 1 #.test.expect(winner board)('B')
 board←5 5⍴'∘∘∘∘∘∘∘B∘BRRBB∘∘RR∘∘∘∘∘∘∘'
 2 #.test.expect(winner board)('∘')
 board←5 5⍴'∘RRRR',20⍴'∘'
 3 #.test.expect(winner board)('R')
 board←(1 5⍴'∘∘∘∘∘')⍪(4 5⍴'R∘∘∘∘')
 4 #.test.expect(winner board)('R')
 board←5 5⍴'∘R∘∘∘∘'
 5 #.test.expect(winner board)('R')
     
 counts←2 3⍴3 2 4 8 9 12
 6 #.test.expect(#.util.roundDn∘4¨expected counts)(#.util.roundDn∘4¨2 3⍴2.605263158 2.605263158 3.789473684 8.394736842 8.394736842 12.21052632)
     
 7 #.test.expect((chiSquareTest counts)#.util.roundDn 4)(0.2779519331 #.util.roundDn 4)
     
 d←'ASPIRIN' 'METAMUCIL' 'PENICILLIN'
 i←'PENICILIN' 'ASPIRIN 250MG' 'METAMUSEL' 'ASPRIN'
 8 #.test.expect(d matchDrugs i)(3 1 2 1)
∇

∇ w←winner board;masks;sqWins;hasRow;rowWins;colWins;negDiagRot;diagWins;wins
     ⍝ `winner board`
     ⍝ - takes a right argument of a 5×5 character matrix representing a Teeko board
     ⍝ - if there is a winner, returns the appropriate character for the winner,
     ⍝   otherwise returns the character representing an unoccupied space.
     
     ⍝ We duplicate the board and use one to track 'B's and one to track 'R's.
 masks←'BR'=2⍴⊂board
     
 sqWins←{∨/(1 1 0 0 0 1 1)⍷,⍵}¨masks
 hasRow←{∨/(4⍴1)⍷,0,⍵}
 rowWins←hasRow¨masks
 colWins←hasRow∘⍉¨masks
     
     ⍝ `⍺ negDiagRot ⍵` rotates the matrix `⍵` so that all negative diagonals are
     ⍝ horizontal and separated by `⍺`.
 negDiagRot←{(⍳2⊃⍴⍵)⊖⍵⍪⍺}
     
 diagWins←hasRow∘(0∘negDiagRot)¨masks
     
 wins←⊃∨/sqWins rowWins colWins diagWins
 w←'∘BR'[1+2⊥⌽wins]
∇

:EndNamespace 
:EndNamespace 
