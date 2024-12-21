# Numerical study of refined conjectures of the BSD-type
This Github repository contains the code used in the article "Numerical study of refined conjectures of the BSD-type".

The code is divided into two folder: "Results" and "Code"
## Results folder
This folder contains the results of the numerical study. It contains the following files:
1) A PDF called "Table_conjecture_0_1.pdf" This PDF contains a table of all the elliptic curves that do not satisfy conjecture 0.1.
2) A PDF called "Table_conjecture_2_12.pdf" This PDF contains a table of all the elliptic curves that do not satisfy conjecture 2.12.
3) A file called "check_one_case.sage". This is a sagemath file can be used to test Conjecture 0.1, Conjecture 2.11, and Conjecture 2.12 on a specific elliptic curve (chosen by the user). It is not neccesary that this elliptic curve be in the database created for the article. Because the values of the modular symbols are recalculated. This code can also check if the values given by the 3 implementations for calculating the modular symbols match.
### Table for Conjecture 0.1
This PDF contains a table, in which every entry is pair (E,p) that does not satisfy Conjecture 0.1. The columns, from left to right, have the following information:
1) The LMFDB label of the elliptic curve.
2) The prime p for which the elliptic curve E has split multiplicative reduction and it is the layer of the Mazur-Tate element.
3) The ring R, which is the smallest subring of Q, for which Conjecture 0.1 is well-defined.
4) The order of the torsion of the Q-points of the elliptic curve.
3) The p-adic period of the elliptic curve, with a presicion of only 1 p-adic digits. This gives us the necessary information to calculate ord_p(q_E) and its projection to (Z/pZ)^*.
3) The Tamagawa number i.e. \prod_{p\in \cP} C_p.
4) The order of the Tate-Shafarevich group.
5) The isomorphism class of the torsion of the Q-points of the elliptic curve.
6) The rank of the elliptic curve
7) The sign of the discriminant. When the discriminant is positive the Neron lattice is rectangular, and non-rectangular when the discriminant is negative.
The reason to include more information needed to check Conjecture 0.1 is to see if a possible pattern can be observe. So, we included the information that we considered relevant.

*Important*: the reason to why we did not include the left hand-side and right hand-side of the equations is because instead of checking the conjectures in the Sylow decomposition, we checked the conjectures in (Z/nZ) for a certain n. For a more in detailed explanation see the pdf "Checking_in_R.pdf" in the code folder.

### Table for Conjecture 2.12
This PDF contains a table, in which every entry is pair (E,p) that does not satisfy Conjecture 2.12. The columns, from left to right, have the following information:
1) The LMFDB label of the elliptic curve.
2) The prime p for which the elliptic curve E has split multiplicative reduction and it is the layer of the Mazur-Tate element.
3) The ring R, which is the smallest subring of Q, for which Conjecture 2.12 is well-defined.
4) The order of the torsion of the Q-points of the elliptic curve.
3) The p-adic period of the elliptic curve, with a presicion of only 1 p-adic digits. This gives us the necessary information to calculate ord_p(q_E) and its projection to (Z/pZ)^*.
3) The Tamagawa number i.e. \prod_{p\in \cP} C_p.
4) The order of the Tate-Shafarevich group.
5) The isomorphism class of the torsion of the Q-points of the elliptic curve.
6) The rank of the elliptic curve
7) The sign of the discriminant. When the discriminant is positive the Neron lattice is rectangular, and non-rectangular when the discriminant is negative.
The reason to include more information needed to check Conjecture 2.12 is to see if a possible pattern can be observe. So, we included the information that we considered relevant.

*Important*: the reason to why we did not include the left hand-side and right hand-side of the equations is because instead of checking the conjectures in the Sylow decomposition, we checked the conjectures in (Z/nZ) for a certain n. For a more in detailed explanation see the pdf "Checking_in_R.pdf" in the code folder.

## Code folder
This folder contains all the code used to obtained the results used in the article. It contains the following files:
1) A file called "Create_Database_Raw.py". This is the original file used to create the database. However, it is not advice to used this code. The reason being that it never created for easy understanding. For example, it contains mutiple functions that are not used, the conjectures checked in the code are not the conjectures studied in the article (they are weaker conjectures studied in the author's masters thesis), and other reasons. If the user wants to recreate the database, it is advice to use the file called "Create_Database.py". The reason to keep the original file is for transparency. 
2) A file called "Create_Database.py". This is a clean-up version of the "Create_Database_Raw.py". With this file the user can create the same database created by the authors. It also contains comments for an easier understanding of the code. Note that it is a python file. Nonetheless, it can still be used in SageMath.
3) A file called "Checking_in_R.sage". This code checks for every pair (E,p) in the database if it satisfies Conjecture 0.1, Conjecture 2.11, and Conjecture 2.12.
4) A pdf file called "Explanation_For_R.pdf". The user can find an explnation of how the conjecture was checked when the ring R \ne Z. Specifically, how the authors calculated the projection to the Sylow decomposition.
## Disclaimer
When creating the database we used the "eclib" implementation based on the work of Cremona. Nonetheless, for all the pairs (E,p) that did not satisfy one of the conjectures intented we checked with the other two implementations: One based on the work of Stein-Wuthrich and the second based on the work of Wuthrich. 

We were not able to check for all the pais (E,p) that did not satisfy Conjecture 0.1 or Conjecture 2.12, do to the following reasons:
1) When we check using the implementation based on the work of Wuthrich we got a *RecursionError* with one pair (E,p) that did not satisfy Conjecture 0.1 oand Conjecture 2.12 in SageMath. Nonetheless, this error was presented in only 1 pair (E,p). This pairs was (50056.a1, 6257). In all the other cases when we were able to use this implementation, we did not find any discrapencies with the values given by the "eclib" implementation.
2) When we check using the implementation based on the work of Stein and Wuthrich, the program took to long to output a value. When the conductor was greater than 17612, the program took to long to finish and we got a Unix message saying that the program was *killed* i.e. Unix stopped the program (we do not know exactly why this happened).
Nevertheless, when checking with different implementation, we never got any discrepancy with the values in the database.

## Funding

When creating this database the author was funded by the National Agency of Research and Development (ANID) - Human Capital Subdirectorate's National Masters scholarship 2022 N° 22221372.

## Contact the author
Comments, typos, errores, suggestions, etc. are more than welcome (even encourage).

Unfortunatly, because of bots in the internet, the email will not be written here. However, it can be obtained in the arxiv preprint.