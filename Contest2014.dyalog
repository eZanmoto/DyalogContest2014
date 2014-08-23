:Namespace Contest2014
⍝ === VARIABLES ===

AboutMe←,⊂'My name is Sean Kelleher and I''m a final year student of Computer Science at UCC in Ireland. I''m a programming language enthusiast - I''ve written small to medium-sized projects in C, Java, Scala, PHP, Python, Go, Haskell, Prolog and I''ve dabbled in LISP, Rust and OCaml. I aim to continue my studies in a PhD in a field relating to programming language theory, if possible.'

FilePath←'C:\Users\sean\Downloads\'

Reaction←,⊂'I enjoyed the competition a lot, and I intend to participate again once I start my PhD. If anything, it may be considered highlighting the main judging criteria of the competition in the Phase II introduction - my initial solutions were primarily terse one-liners, which I spent some time expanding when I was updated that the emphasis is on clarity, not brevity. Other than that I found the problems to be well-explained and straightforward to submit.'


⍝ === End of variables definition ===

⎕IO ⎕ML ⎕WX←1 0 3

:Namespace Problems

 ⎕ML  ←0 ⍝ *** DO NOT change these system variables here, only after the variables definition 

⍝ === VARIABLES ===

lower←'abcdefghijklmnopqrstuvwxyz'

_←⍬
_,←⊂'TREDUCEMOP'
_,←⊂'IRUKIWORPE'
_,←⊂'NXADMNPOEU'
_,←⊂'WAANAPNTRD'
_,←⊂'HYCDSRFAAI'
_,←⊂'DIISIPDTTS'
_,←⊂'DCFSJVOEOE'
_,←⊂'ETUMMOCSRR'
_,←⊂'NFDARTCMEB'
_,←⊂'TJLYYOFAZX'
puzzle←↑_

ranks←'AKQJT98765432'

suits←(⎕ucs 9824 9825 9826 9827)

upper←'ABCDEFGHIJKLMNOPQRSTUVWXYZ'

words←'COMMUTE' 'DFN' 'DYADIC' 'MONADIC' 'OPERATOR' 'REDUCE' 'RESIDUE' 'ROTATE' 'SCAN' 'TRADFN' 'TRANSPOSE'

⎕ex '_'

⍝ === End of variables definition ===

⎕IO ⎕ML ⎕WX←1 0 3

∇ msg←text BookDecrypt enc;apply_mask;word_nums;letter_offs;word_starts
     ⍝ Modified Book Cipher Decryption
     ⍝ text: character vector representing normalised book text to use as the cipher key
     ⍝ enc: character vector representing the encrypted message
     ⍝ msg: character vector representing the original message
     
 apply_mask←{((⍴⍺)⍴⍵)/⍺}
 word_nums←enc apply_mask 1 0
 letter_offs←enc apply_mask 0 1
 word_starts←0,(text=' ')/⍳⍴text
     
     ⍝ Add word positions to letter offsets and use this as an index into text.
 msg←text[word_starts[word_nums]+letter_offs]
∇

∇ enc←text BookEncrypt msg;word_starts;letters
     ⍝ Modified Book Cipher Encryption
     ⍝ text: character vector representing normalised book text to use as the cipher key
     ⍝ msg: character vector representing the original message
     ⍝ enc: character vector representing the encrypted message
     
     ⍝ Position of words in the text
 word_starts←0,(text=' ')/⍳⍴text
     
     ⍝ For each upper-case letter, find the position of that letter in text, and find
     ⍝ all words that begin less than twenty characters away from it, and store each
     ⍝ word/offset pair at that letter's index.
 letters←{{⊃,/⊃((0<y)∧(y<20))/↓(⍳⍴word_starts),⍪y←⍵-word_starts}¨(text=⍵)/⍳⍴text}¨upper
     
     ⍝ For each letter in msg, find the word/offset pairs in letters at that letter's
     ⍝ index, and choose one of these word/offset pairs at random.
 enc←⊃,/{(?⍴y)⊃y←(upper⍳⍵)⊃letters}¨msg
∇

 BuildDictionary←{
     ⍝ build dictionary
     ⍝ ⍵: character vector representing the folder where the dictionary files are located puzzle
     ⍝ returns a vector of vector characters of the words read from the dictionary files
     
     ⍝ Removes words that contain an apostrophe or an uppercase character.
     filter←{(~{∨/⍵∊'''',upper}¨⍵)/⍵}
     
     path←NormPath ⍵
     files←⎕SH'DIR/B ',path ⍝ Assuming Windows platform.
     
     ⍝ For each file in the directory specified by ⍵, remove the trailing newline and
     ⍝ all words that contain an apostrophe or an uppercase character.
     ∪⊃,/{filter ¯1↓⎕SE.UnicodeFile.ReadNestedText path,⍵}¨files
 }

 Count←{
     ⍝ kmer counting
     ⍝ ⍺: character vector genome
     ⍝ ⍵: character vector kmer to look for
     ⍝ returns an integer count of the number of times kmer was found in string
     
     +/⍵⍷⍺
 }

∇ hands←DealHands
     ⍝ lets make a deal
     ⍝ hands: array representing 13 cards dealt to each of 4 players
     
     ⍝ Create a uniform distribution of 52 numbers, assign them a unique suit and
     ⍝ rank based on their 4 and 13 modulus, and split them into four even-sized
     ⍝ vectors.
 hands←(52⍴1,12⍴0)⊂{suits[1+4|⍵],ranks[1+13|⍵]}¨52?52
∇

∇ ed←s EditDistance t
     ⍝ edit distance
     ⍝ s: character vector
     ⍝ t: character vector
     ⍝ ed: "edit distance" to transform s into t
     
     ⍝ Standard levenshtein distance algorithm, with the following differences:
     ⍝ * We only keep track of the current row and the previous row of values, not
     ⍝   the whole table.
     ⍝ * The "table" is reversed along the horizontal axis to make reduction from the
     ⍝   right with / easier.
     ⍝ * For each d[r][c], we precompute min(d[r-1][c-1], d[r-1][c]).
     ⍝
     ⍝ (((⍺≠⌽t)+1↓⍵)⌊1+¯1↓⍵) precomputes min(d[r-1][c-1], d[r-1][c]) for each cell in
     ⍝ the previous row. We increment the first value of the previous row (rightmost
     ⍝ value here, because our "table" is reversed) using 1+⊃⌽⍵ to get the current
     ⍝ row number and append it to the values of the previous row, which will be our
     ⍝ "initial" value to the reduction for the current row. The reduction is then
     ⍝ carried out with {⍵,⍨⍺⌊1+⊃⍵}, which increments the value of the cell to the
     ⍝ right (hence, why we're building the table in reverse) and gets the minimum
     ⍝ distance. This reduction is carried along for every character in s, and once
     ⍝ we have the final row, we extract the last number (leftmost here) using ⊃⊃ to
     ⍝ get the distance.
 ed←⊃⊃{⊃{⍵,⍨⍺⌊1+⊃⍵}/(((⍺≠⌽t)+1↓⍵)⌊1+¯1↓⍵),1+⊃⌽⍵}/(⌽s),⊂⌽0,⍳⍴t
∇

∇ kmers←genome FindClumps(k L t)
     ⍝ clump finding
     ⍝ genome: character vector genome
     ⍝ k: length of the pattern to look for
     ⍝ L: interval within genome to search
     ⍝ t: the number of times the pattern needs to occur within the interval
     ⍝ kmers: vector of character vectors of the kmers found
     
     ⍝ For each L-sized substring of genome, find all k-sized substrings whose Count
     ⍝ within that L-sized substring is greater than or equal to t.
 kmers←∪⊃,/{(t≤⍵∘Count¨y)/y←∪k,/⍵}¨L,/genome
∇

 IsMax←{
     ⍝ Masks largest numbers
     ⍝ ⍵: numeric vector
     ⍝ returns a boolean vector mask of the largest numbers
     
     ⍵=⌈/⍵
 }

 LongestShared←{
     ⍝ longest shared substring
     ⍝ ⍺: character vector
     ⍝ ⍵: character vector
     ⍝ character vector of the longest shared substring in text1 and text2
     
     ⎕ML←3 ⍝ Using IBM `X⊂Y`
     
     ⍝ This solution could have used a similar approach as that used in
     ⍝ `ShortestNonShared`, however, this solution was used for diversity's sake.
     
     ⍝ We use ⍺∘.=⍵ to get an equality matrix between the strings, where (negative)
     ⍝ diagonal sequences of 1's are shared substrings.
     ⍝
     ⍝       A G A C T A
     ⍝     G 0 1 0 0 0 0
     ⍝     A 1 0 1 0 0 1
     ⍝     A 1 0 1 0 0 1
     ⍝     C 0 0 0 1 0 0
     ⍝     T 0 0 0 0 1 0
     ⍝     G 0 1 0 0 0 0
     ⍝
     ⍝ We nest this with a character matrix for later.
     matrices←(⍺∘.=⍵)(⍵⍴⍨(⍴⍺),⍴⍵)
     
     ⍝ We then do an incremental rotate around the first axis on both matrices, with
     ⍝ 0's at the bottom, so that (negative) diagonals are now horizontal.
     ⍝
     ⍝     1 0 0 0 0 0
     ⍝     1 0 0 0 0 0
     ⍝     0 0 0 0 0 1
     ⍝     0 1 0 0 0 1
     ⍝     0 0 0 0 0 0
     ⍝     0 1 1 0 0 0
     ⍝     0 0 1 1 1 0
     ⍝
     ⍝ We now prepend 0's to each row and ravel.
     rotated←{,0,(⍳2⊃⍴⍵)⊖⍵⍪0}¨matrices
     
     ⍝ Note that the character matrix has been transformed in the same way, so we can
     ⍝ partition it (using the IBM definition) using our first matrix, and we get the
     ⍝ original strings those 1's represented.
     ⍝
     ⍝     A  G  GA  ACT
     eq_substrings←∪⊃⊂⌿rotated
     
     ⍝ Finally, we get the longest of these strings, of which there may be many.
     (IsMax⊃,/⍴¨eq_substrings)/eq_substrings
 }

∇ result←dictionary MaxWord tiles;score;tiles_;word;value
     ⍝ word search
     ⍝ dictionary: vector of character vectors representing the words in the dictionary built in Task 1 list character matrix representing the word search puzzle
     ⍝ tiles: character vector representing the letters on Scrabble tiles
     ⍝ result: 2 element vector representing information about the maximum scoring word
     ⍝         element 1: character vector representing the word
     ⍝         element 2: integer representing the score for the word
     
 score←{
          ⍝ Return the tiles `t` and score `s` received from forming word `a` from tiles in `b`
     a b t s←⍵
     0=⍴a:t(s+50×0=⍴b)
     c←(1+h∊b)⊃'?'(h←⊃a)
     c∊b:∇(1↓a)(b/⍨(⍳⍴b)≠b⍳c)(t,c)(s+(1 10 2 4 5 1 2 2/0,(⍳5),8,10)['?eaionrtlsudgbcmpfhvwykjxqz'⍳c])
     '' 0
 }
     
     ⍝ Transform uppercase tiles to lowercase (which is less work than converting
     ⍝ all lowercase words in dictionary to uppercase).
 tiles_←('?',lower)[('?',upper)⍳tiles]
     
     ⍝ Apply score to each word in dictionary and reduce these tile/scores by
     ⍝ keeping the pair with the highest score.
 word value←⊃{(1+(2⊃⍺)<2⊃⍵)⊃⍺ ⍵}/{score(⍵ tiles_'' 0)}¨dictionary
     
     ⍝ Transform the lowercase tiles back to uppercase.
 result←(('?',upper)[('?',lower)⍳word])value
∇

∇ kmers←string MostFrequent k;y
     ⍝ 2014 APL Problem Solving Competition stub function for Bioinformatics Problem 1 - Task 2
     ⍝ most frequent kmers
     ⍝ string: character vector genome
     ⍝ k: length of kmer to look for
     ⍝ kmers: vector of character vectors of the most frequent kmers in string
     
 kmers←(IsMax{+/⍵⍷string}¨y)/y←∪k,/string
∇

∇ path←NormPath path
     ⍝ Normalise a directory path
     ⍝ path: character vector representing the path to normalise
     
 path[(path='/')/⍳⍴path]←'\'
∇

 Normalise←{
     ⍝ Normalize
     ⍝ ⍵: character vector representing the name of the file to read
     ⍝ returns a character vector representing the normalised text
     
     ⍝ Convert all lowercase letters to uppercase and all non-letters to spaces.
     caps←(upper,upper,' ')[(lower,upper)⍳⎕SE.UnicodeFile.ReadText ⍵]
     
     ⍝ Compress the text by removing each space which is the second in a pair of
     ⍝ spaces.
     (1,2{⍲/' '=⍺ ⍵}/caps)/caps
 }

 PlayfairDecrypt←{
     ⍝ Playfair Decryption
     ⍝ ⍺: character matrix representing Playfair square to use as the cipher key
     ⍝ ⍵: character vector representing the encrypted message
     ⍝ returns a character vector representing the original message
     
     ⍝ Split ⍵ into digraphs, and "encrypt" each digraph using a transformation of ⍺.
     ⍝ Playfair encrypting a digraph using a vertically and horizontally flipped
     ⍝ playfair square is the same as decrypting with the original playfair square.
     ⊃,/(⌽⊖⍺)∘PlayfairTrans¨2 SizedChunks ⍵
 }

 PlayfairEncrypt←{
     ⍝ Playfair Encryption
     ⍝ ⍺: character matrix representing Playfair square to use as the cipher key
     ⍝ ⍵: character vector representing the original message
     ⍝ returns a character vector representing the encrypted message
     
     msg←⍵ ⍝ Rename ⍵ so we can assign to it
     msg[(msg='J')/⍳⍴msg]←'I' ⍝ Treat 'J's as 'I's
     
     pad_dup←{
              ⍝ Insert 'X' in front of even-indexed duplicates
         idx←1⍳⍨(0,2=/⍵)∧~2|n←⍳⍴⍵
         idx>⍴⍵:⍵
         z[(z←⍵\⍨1,⍨n≠idx)⍳' ']←'X'
         ∇ z
     }
     
     ⍝ Append ⍺ to ⍵ until ⍵ is of even length
     pad_length←{⍵,⍺↑⍨2|⍴⍵}
     
     ⍝ Preprocess the message
     preproc←'X'pad_length pad_dup'Z'pad_length msg
     
     ⍝ Encrypt each digraph
     ⊃,/⍺∘PlayfairTrans¨2 SizedChunks preproc
 }

 PlayfairSquare←{
     ⍝ Playfair Square
     ⍝ ⍵: character vector representing the cipher key
     ⍝ ⍺: {optional} fill technique indicator
     ⍝ returns a character matrix Playfair Square constructed from the key
     
     ⍺←1
     
     wind←{
              ⍝ "Wind" ⍵ into a spiral shape.
              ⍝ ⍴⍵ should be a number n×n or n(n-1) where n is a positive integer
         ⍺←0 1⍴⍬
         0=⍴⍵:⍺
         (⌽⍉⍺⍪width↑⍵)∇ ⍵↓⍨width←2⊃⍴⍺
     }
     
     ⍝ Remove duplicates, and 'J', from the encryption key.
     letters←'J'~⍨∪⍵,upper
     
     ⍺=1:5 5⍴letters ⍝ Simple row-by-row square
     ⍺=2:⍉5 5⍴letters ⍝ Simple column-by-column square
     ⍺=3:wind letters ⍝ Spiral square
     'Invalid fill technique'
 }

 PlayfairTable←{
     ⍝ Playfair Table
     ⍝ Duplicate of `PlayfairSquare` - `PlayfairTable` is the required function name,
     ⍝ but `PlayfairSquare` is the function skeleton provided in the template file.
     ⍝ ⍵: character vector representing the cipher key
     ⍝ ⍺⍺: {optional} fill technique indicator
     ⍝ returns a character matrix Playfair Square constructed from the key
     
     ⍺←1
     
     wind←{
              ⍝ "Wind" ⍵ into a spiral shape.
              ⍝ ⍴⍵ should be a number n×n or n(n-1) where n is a positive integer
         ⍺←0 1⍴⍬
         0=⍴⍵:⍺
         (⌽⍉⍺⍪width↑⍵)∇ ⍵↓⍨width←2⊃⍴⍺
     }
     
     ⍝ Remove duplicates, and 'J', from the encryption key.
     letters←'J'~⍨∪⍵,upper
     
     ⍺=1:5 5⍴letters ⍝ Simple row-by-row square
     ⍺=2:⍉5 5⍴letters ⍝ Simple column-by-column square
     ⍺=3:wind letters ⍝ Spiral square
     'Invalid fill technique'
 }

 PlayfairTrans←{
     ⍝ Translate a Playfair digraph
     ⍝ ⍺: character matrix representing Playfair square to use as the cipher key
     ⍝ ⍵: character digraph to be translated
     ⍝ returns a character vector with the translation of the digraph relative to the
     ⍝ Playfair square
     
     (r1 c1)(r2 c2)←p←(,⍳⍴⍺)[⍵⍳⍨,⍺] ⍝ extract the indices of the characters in the square
     r1=r2:(1⌽⍺)[p] ⍝ swap columns if the rows are the same
     c1=c2:(1⊖⍺)[p] ⍝ swap rows if the columns are the same
     ⍺[(r1 c2)(r2 c1)] ⍝ swap corners if they're on different rows and columns
 }

∇ sns←text1 ShortestNonShared text2;subtext1;nonshared
     ⍝ shortest non-shared substring
     ⍝ text1: character vector
     ⍝ text2: character vector
     ⍝ sns: character vector of the shortest non-shared substring in text1 and text2
     
 subtext1←∪⊃,/{⍵,/text1}¨⍳⍴text1 ⍝ All possible substrings of text1
 nonshared←({~∨/⍵⍷text2}¨subtext1)/subtext1 ⍝ Remove those that aren't in text2
 sns←({⍵=⌊\⍵}⊃,/⍴¨nonshared)/nonshared ⍝ Keep the longest of these
∇

∇ display←ShowHand hand
     ⍝ what's in you hand
     ⍝ hand: array representing 13 cards dealt to a player
     ⍝ display: 2 column matrix containing
     ⍝          column 1: suit indicator
     ⍝          column 2: a character vector representing the card ranks found in that suit
     
     ⍝ For each suit, take the second character of each card of that suit in a vector
     ⍝ and sort this by rank.
 display←↑{⍵,⊂r[ranks⍋r],'-'↑⍨0=⍴r←2⊃¨(⍵∘∊¨hand)/hand}¨suits
∇

 Simulate←{
     ⍝ simulation stimulation
     ⍝ ⍵: an integer representing the number of deals to simulate
     ⍝ returns a 2 element vector
     ⍝             element 1: a 3 column matrix where
     ⍝                        column 1 contains the high card point values from 0 through 37
     ⍝                        column 2 contains the number of hands that had the corresponding point value
     ⍝                        column 3 contains the percent (expressed as a number between 0 and 1) of the total hands that had the corresponding point value.
     ⍝             element 2: a 2 element vector where
     ⍝                        element 1: the number of deals where either partnership (North-South or East-West) totaled 37 or more combined points
     ⍝                        element 2: the percentage of hands where this occurred
     
     ⍝ Possible points per hand
     pts←¯1+⍳38
     
     accum_hand←{
              ⍝ Deal a hand and accumulate points. Hands are in the order North,
              ⍝ West, East, South, and partnerships are North-South and East-West.
         dists deals←⍵
         hands←⊃∘ValueHand¨DealHands ⍝ Only need the high score from each hand
         dists+←{+/hands=⍵}¨pts ⍝ Number of times certain points were achieved
         deals←(+/deals,37≤+/¨2 SizedChunks 2↑1⌽hands) ⍝ Times partners got 37
         dists deals
     }
     dists deals←(accum_hand⍣⍵)(38⍴0)(0)
     
     ⍝ Convert points and distributions to their expected formats. Redundant brackets
     ⍝ have been left in for clarity.
     num_hands←4×⍵
     ((pts),(dists),⍪(dists÷num_hands))(deals,deals÷num_hands)
 }

 SizedChunks←{
     ⍝ Split vector into ⍺-sized subvectors.
     ⍝ If ⍴⍵ is not a multiple of ⍺, the last subvector will have length less than ⍺.
     ⍝ ⍺: size of subvectors
     ⍝ ⍵: vector to split
     ⍝ returns ⍵ split into ⍺-sized subvectors
     
     ⍵⊂⍨⍺|⍳⍴⍵
 }

∇ Test;expect;dictionary;bor;hands;cipher;square;alphsqr
     ⍝ Tests competition solutions against provided examples and custom checks.
     
 expect←{
     ⎕ML←3 ⍝ Using IBM `∊Y`
     ⍺≢⍵:⎕←'Expected ',(∊⍵),'(',(⍴⍵),'), got ',(∊⍺),'(',(⍴⍺),')'
     ⎕←'PASS'
 }
     
 ('ACAACTATGCATACTATCGGGAACTATCCT'Count'ACTAT')expect 3
 ('CGATATATCCATAG'Count'ATA')expect 3
     
 ('ACGTTGCATGTCGCATGATGCATGAGAGCT'MostFrequent 4)expect('GCAT' 'CATG')
     
 ('CGGACTCGACAGATGTGAAGAAATGTGAAGACTGAGTGAAGAGAAGAGGAAACACGACACGACATTGCGACATAATGTACGAATGTAATGTGCCTATGGC'FindClumps 5 75 4)expect('CGACA' 'GAAGA' 'AATGT')
     
 ('CGCCCGAATCCAGAACGCATTCCCATATTTCGGGACCACTGGCCTCCACGGTACGGACGTCAATCAAATGCCTAGCGGCTTGTGGTTTCTCCTACGCTCC'(3 ApproxMatch)'ATTCTGGA')expect(6 7 26 27 78)
     
 ('AAACTCATC'(3 SharedKmers)'TTTCAAATC')expect((0 4)(4 2)(6 6)(0 0))
     
 ('TCGGTAGATTGCGCCCACTC'LongestShared'AGGGGCTCGCAGTGTAAGAA')expect('CGC' 'AGA' 'GTA' 'CTC' 'TCG')
 ('TCGGTAGATTGCGCCCACT'LongestShared'AGGGGCTCGCAGTGTAAGAA')expect('CGC' 'AGA' 'GTA' 'TCG')
 ('TCGGTAGATTGCGCCCACTC'LongestShared'AGGGGCTCGCAGTGTAAGA')expect('CGC' 'AGA' 'GTA' 'CTC' 'TCG')
 ('AAA'LongestShared'AAA')expect(1⍴⊂'AAA')
     
 ('CCAAGCTGCTAGAGG'ShortestNonShared'CATGCTGGGCTGGCT')expect('CC' 'AA' 'AG' 'TA' 'GA')
     
 ('PLEASANTLY'EditDistance'MEANLY')expect 5
     
 ('KEIVERSON'VigEncrypt'APLISFUNTOUSE')expect'KTTDWWMBGYYAZ'
     
 ('KEIVERSON'VigDecrypt'KTTDWWMBGYYAZ')expect'APLISFUNTOUSE'
     
 bor←Normalise'c:/Contest2014/Data/BillOfRights.txt'
 (70↑bor)expect'THE PREAMBLE TO THE BILL OF RIGHTS CONGRESS OF THE UNITED STATES BEGUN'
     
 cipher←bor BookEncrypt'MYSECRETMESSAGE'
     
 (bor BookDecrypt cipher)expect'MYSECRETMESSAGE'
     
 square←PlayfairSquare'KENNETHIVERSON'
 (square)expect(↑'KENTH' 'IVRSO' 'ABCDF' 'GLMPQ' 'UWXYZ')
     
 alphsqr←5 5⍴upper~'J'
     
 (square PlayfairEncrypt'HELLOWORLD')expect'KNMWQVZVVMCY'
 (alphsqr PlayfairEncrypt'JKOYGT')expect'KFTDIR'
     
 (square PlayfairDecrypt'KNMWQVZVVMCY')expect'HELXLOWORLDX'
 (alphsqr PlayfairDecrypt'KFTDIR')expect'IKOYGT'
     
 (puzzle WordSearch words)expect(↑('COMMUTE'(8 7)'W')('DFN'(9 3)'W')('DYADIC'(6 1)'NE')('MONADIC'(1 8)'SW')('OPERATOR'(1 9)'S')('REDUCE'(1 2)'E')('RESIDUE'(8 10)'N')('ROTATE'(2 8)'S')('SCAN'(6 4)'NW')('TRADFN'(9 6)'W')('TRANSPOSE'(1 1)'SE'))
     
 dictionary←BuildDictionary'c:/Contest2014/Data/Dictionary/'
 (8↑dictionary)expect('afterward' 'among' 'analog' 'apologize' 'behavior' 'catalog' 'center' 'color')
     
 (dictionary MaxWord'OZGYLO?')expect('ZOOL?GY'(1⍴69))
     
 hands←DealHands
 (⍴hands)expect 1⍴4
 (⍴¨hands)expect 4⍴(⊂1⍴13)
 (⍴∪⊃,/hands)expect 1⍴52
     
 (ShowHand'♡3' '♣J' '♠8' '♡T' '♠J' '♣6' '♡9' '♠6' '♣A' '♠2' '♣7' '♠K' '♣5')expect(4 2⍴'♠' 'KJ862' '♡' 'T93' '♢'(1⍴'-')'♣' 'AJ765')
     
 hands←('♠A' '♠Q' '♡Q' '♡J' '♡7' '♢K' '♢J' '♢T' '♢9' '♢7' '♢3' '♣K' '♣9')('♠T' '♠7' '♠5' '♠3' '♡A' '♡5' '♡2' '♢A' '♢Q' '♢5' '♣Q' '♣4' '♣2')('♠9' '♠4' '♡K' '♡8' '♡6' '♡4' '♢8' '♢6' '♢4' '♢2' '♣T' '♣8' '♣3')('♠K' '♠J' '♠8' '♠6' '♠2' '♡T' '♡9' '♡3' '♣A' '♣J' '♣7' '♣6' '♣5')
 (ValueHand¨hands)expect((16 2 ¯2)(12 0 0)(3 0 ¯1)(9 2 0))
     
     ⍝ Simulate
     
 ⎕←'Finished.'
∇

 ValueHand←{
     ⍝ value hand
     ⍝ ⍵: array representing 13 cards dealt to a player
     ⍝ a 3 element integer vector containing
     ⍝          element 1: total high card points
     ⍝          element 2: total distribution points
     ⍝          element 3: total point corrections
     
     s←(ShowHand ⍵)[;2] ⍝ Card ranks in ⍵ split into suits
     r←⊃,/s ⍝ Card ranks s in ⍵
     
     ⍝ Assign the values 4 3 2 1 0 to 'AKQJ' and any other rank, respectively, and
     ⍝ sum these numbers.
     high←⊃+/(⌽¯1+⍳5)['AKQJ'⍳⊃,/r]
     
     ⍝ For each suit, add the number of cards in that suit beyond the fourth.
     dist←{⊃⍵+0⌈¯4+⍴⍺}/s,0
     
     ⍝ A suit is "bad" if it has only a king, or a queen and one other card, or a
     ⍝ jack and two other cards. Returns 1 if the suit is bad and 0 otherwise.
     is_bad_suit←{∨/(⊂⍵){⊃(⍵∊⍺)∧(h⍳⍵)=⍴⍺}¨h←'KQJ'}
     
     ⍝ Sum correctinal points and assign to corr
     corr←(4=a)+(-0=a←⊃+/'A'=r)+-⊃+/is_bad_suit¨s
     
     high dist corr
 }

 VigDecrypt←{
     ⍝ Vigenère Cipher Decryption
     ⍝ ⍺: character vector representing the key to use
     ⍝ ⍵: character vector representing the encrypted message
     ⍝ returns a character vector representing the original message
     
     upper[1+26|(upper⍳⍵)-upper⍳(⍴⍵)⍴⍺]
 }

 VigEncrypt←{
     ⍝ Vigenère Cipher Encryption
     ⍝ ⍺: character vector representing the key to use
     ⍝ ⍵: character vector representing the original message
     ⍝ returns a character vector representing the encrypted message
     
     upper[1+26|(upper⍳⍵)+(upper⍳(⍴⍵)⍴⍺)-2]
 }

∇ result←puzzle WordSearch words;y;transforms;directions;find;indexes
     ⍝ word search
     ⍝ puzzle: character matrix representing the word search puzzle
     ⍝ words: vector of character vectors representing the words to find in the puzzle
     ⍝ result: matrix representing information about the words found in the puzzle (one row per word)
     ⍝         column 1: character vector representing the word found
     ⍝         column 2: 2 element integer vector representing the row and column of the first letter of the word
     ⍝         column 3: character vector representing the "compass direction" in which the word is read
     
     ⍝ Character vectors representing functions for all possible string orientations
     ⍝ in a word search.
 transforms←{'{',⍵,'⍵}'}¨y,'⌽',¨y←'' '⍉' '(⍳2⊃⍴⍵)⊖''-''⍪' '(⌽⍳2⊃⍴⍵)⊖''-''⍪'
     
     ⍝ Character vectors of the functions in transforms
 directions←'E' 'S' 'SE' 'NE' 'W' 'N' 'NW' 'SW'
     
     ⍝ Apply to each word and mix the results
 find←{
     word←⍵
     
     transfind←{
              ⍝ Find word in transformed puzzle.
         p indices←(⍎⍵)¨(puzzle)(⍳⍴puzzle) ⍝ Transform puzzle and puzzle index
         p←(word⍷p) ⍝ Find word in transformed puzzle
         (/⌿),¨(p indices) ⍝ Compress indexes using word location(s)
     }
     positions←⊃¨transfind¨transforms ⍝ Only keep first position of each
     
     ⍝ Get the index of the first direction that we find the word in.
     dir_index←⊃(⊃∘⍴¨positions)/⍳⍴positions
     
     ⍝ Return the word, its position and its direction
     (⍵)(⊃dir_index⊃positions)(dir_index⊃directions)
 }
     
 result←↑find¨words
∇

 ApproxMatch←{
⍝ approximate pattern matching
⍝ ⍺⍺: maximum allowed mismatches
⍝ ⍺: interval within genome to search
⍝ ⍵: interval within genome to search
⍝ returns a vector of offsets representing start positions where pattern is matched

⍝ Compress substring indexes by substrings whose mismatches to ⍵ are less than ⍺⍺.
     indices←¯1+⍳1+(⍴⍺)-⍴⍵
     mismatches←+/¨(⊂⍵)≠(⍴⍵),/⍺
     (mismatches≤⍺⍺)/indices
 }


 SharedKmers←{
⍝ shared kmers
⍝ ⍺⍺: length of the pattern to compare between genome1 and genome2
⍝ ⍺: character vector genome
⍝ ⍵: character vector genome
⍝ returns a vector of 2-element vectors in genome1 and genome2 where shared kmers are found

⍝ Split ⍵ into ⍺⍺-length substrings, and for each of these, find the index at
⍝ which it or its reverse complement exist in ⍺.
     mask←,⌿↓(y,⍪{'CGAT'['GCTA'⍳⌽⍵]}¨y←⍺⍺,/⍺)∘.≡⍺⍺,/⍵

⍝ Filter indexes from all index pairs.
     ¯1+⊃mask,./⊂,⍳¯2+(⍴⍺),⍴⍵
 }


:EndNamespace 
:EndNamespace 