# We will use the same notation as in the article.

def TestConjectures(E_coefficients, prime, values_mod_symb):
	# If this value is False, then the results will be done with respect to the original statments i.e. Conjecture 0.1, Conjecture 2.11, and Conjecture 2.12. If this value is set to True, then it will check Conjecture 3.3, Conjecture 2.11, and Conjecture 3.5 i.e. allways considering the torsion to be invertible in R
	modified_conjecture = False

	# In this file the results will be written in the following way:
	# Lmfdb = This is the label that LMDFB assign to the elliptic curve (note that this may disagree with Cremona's convention).
	# prime = The layer of the Mazur-Tate element.
	# C_4 = 1 if the elliptic curve satisfies Conjecture 2.12, -1 if the conjecture does apply to Conjecture 2.12 and 0 if the elliptic curve does not satisfy Conjecture 2.12.
	# C_5 = The same as C_4 but with respect to Conjecture 2.11
	# C_6 = The same as in C_4 but with respect to Conjecture 0.1
	# Recall that each conjecture has a ring R associated to it, which is the smallest ring such that the conjectures are all way defined. Note that this ring has the form Z[1/N]. So:
	# N_4 = Is the number such that R = Z[1/N] for conjecture 2.12 
	# N_5 = Is the number such that R = Z[1/N] for conjecture 2.11
	# N_6 = Is the number such that R = Z[1/N] for conjecture 0.1
	# Each line of Results.txt has the following structure:
	# Lmfdb prime [C_4,N_4] [C_5,N_5] [C_6,N_6]
	results_file = open('./Results.txt', 'a')

	E_Sage = EllipticCurve(E_coefficients)
	# Originally the databse was created for primes such that E has multiplicative reduction. Because, the conjectures studied only apply for split multiplicative reduction, we have to make sure that E does not has non-split multiplicative reduction.
	if not E_Sage.has_split_multiplicative_reduction(prime):
		return None

    # When p = 2 or p = 3 then G_M = \{e\}. So the conjectures hold trivially.
	if prime == 2 or prime == 3:
		return None
	
	# The following line makes it easier to recover certain algebraic numbers attached to E.
	E_Cremona = CremonaDatabase().data_from_coefficients(E_coefficients)
	
	# Define all the values needed to check the conjectures, they are, in order:
	# 1) ord_p(q_p)
	# 2) b_0 = The first non-zero value in the p-adic expansion of q_E i.e. q_E = b_0p^{ord_p(q_E)} + terms of higher order. In other words, the projection of q_E into (\bZ/p\bZ)*.
	# 3) rank_{\bZ}(E(\bQ))
	# 4) \prod_{p prime} [E(\bQ_p):E(\bQ_p)^0] i.e. the Tamagawa number
	# 5) #E(\bQ)_{tor}  
	# 6) #Sha(E/\bQ); This number is a float, so it can have the form 1.000000. Thus it is neccesary to convert it into an integer. The reason why it is a float is because sagemath uses the strong BSD conjecture to calculate \Sha. So it is an approximation (For more infomation see https://www.lmfdb.org/EllipticCurve/Q/Reliability)

	ord_period = E_Sage.j_invariant().denominator().valuation(prime)
	torsion_period = Integer(E_Sage.tate_curve(prime).parameter().unit_part().expansion()[0]) 
	r_E = E_Cremona['rank']
	C_E = E_Cremona['db_extra'][0]
	tau_E = E_Cremona['torsion_order']
	sha_E = Integer(E_Cremona['db_extra'][-1])


	# See the pdf sagemath_implementation.pdf in the github repository for the explanation of exp_grp. Note that there are other ways as to implement this number. But, because it doesn't take a lot of time to check the conjecture and it only has to be done once, we do not consider that a faster implementation is needed. Nevertheless, there are better ways to calculate exp_grp, which may make checking the conjectures faster.
	exp_grp = 17

	# When the discriminant is negative, then sagemath uses the smallest real period. This differs from the convention of Mazur and Tate, because they consider half the smallest real period. When the rank of the elliptic curve is zero, then the scalar can be verified with equation (3.1.3) of [MT87].
	scalar = 1
	if E_Sage.discriminant() < 0:
		scalar = 2

	# This are the values that determine if the conjecture hold, doesn't hold, or the conjectures does not apply for Conjecture 2.12, Conjecture 2.11, and Conjecture 0.1.
	C_4 = 1
	C_5 = 1 
	C_6 = 1 

	# Temporal variables
	D_4 = 1
	D_5 = 1
	D_6 = 1

	leftside = 1
	rightside = 1

	# This list is used to determine the necessary values needed for the conjecture to be well defined.
	denominators = []

	# Conjecture 2.12 or Conjecture 3.5 (depending on the value of modified_conjecture)

	if r_E > 0:

		# This loop is used to determine the denominators of the modular symbols.
		for a in range(1, (prime-1)//2 + 1):
			denominators.append((values_mod_symb[a-1]*scalar).denominator())

		if modified_conjecture == True:
			denominators.append(tau_E)

		# This is the number that has to be invertible for the conjectures to make sense
		D = lcm(denominators)
		D_4 = prod(prime_divisors(D))
		# This calculates the left hand-side of the conjecture 2.12 or Conjecture 3.5 (depending on the value of modified_conjecture)
		for a in range(1 , (prime-1)//2 + 1):
			leftside *= a**(2 * D * (values_mod_symb[a-1]*scalar)) % prime

		# Check sagemath_implementation.pdf, In particular remark X for the explanation of this loop
		for _ in range(exp_grp):
			leftside = leftside ** D % prime

		# This checks if the conjecture holds or not
		if leftside != 1:
			C_4 = 0 

	# Conjecture 2.12 or Conjecture 3.5 (depending on the value of modified_conjecture) doesn't apply to this elliptic curve.
	else:
		C_4 = -1
	
	# We have to reset the values of the left hand-side and right hand-side.
	leftside = 1
	rightside = 1
	
	# Conjecture 2.11
	if r_E == 0:
		
		# This loop is used to determine the denominators of the modular symbols.
		for a in range(1, ((prime-1)//2) + 1):
			denominators.append((values_mod_symb[a-1]* scalar).denominator())
		
		# This is the number that has to be invertible for the conjectures to make sense
		D = lcm(lcm(denominators),tau_E^2)
		D_5 = prod(prime_divisors(D))

		# This calculates the left hand-side of Conjecture 2.11.
		for a in range(1 , ((prime-1)//2) + 1):
			leftside = leftside * a**(2 * D * (values_mod_symb[a-1]*scalar)) % prime
		
		# This calculates the right hand-side of Conjecture 2.11.
		rightside = torsion_period**((2 * D * C_E * sha_E)//(tau_E^2 * ord_period)) % prime

		# Check sagemath_implementation.pdf, In particular remark X for the explanation of this loop
		for _ in range(exp_grp):
			leftside = leftside ** D % prime
			rightside = rightside ** D % prime

		# This checks if the conjecture holds or not
		if leftside % prime != rightside % prime:
			C_5 = 0
			print('there is a problem')

	# Conjecture 2.11 doesn't apply to this elliptic curve.
	else:
		C_5 = -1

	leftside = 1
	rightside = 1

	# Conjecture 0.1 or Conjecture 3.3 (depending on the value of modified_conjecture)
	if True:

		# This loop is used to determine the denominators of the modular symbols.
		for a in range(1, ((prime-1)//2) + 1):
			denominators.append((values_mod_symb[a-1]* scalar).denominator())

		if modified_conjecture == True:
			denominators.append(tau_E)

		# This is the number that has to be invertible for the conjectures to make sense
		D = lcm(lcm(denominators), (values_mod_symb[-1]/(2*ord_period)).denominator())
		D_6 = prod(prime_divisors(D))

		# This calculates the left hand-side of Conjecture 2.11.
		for a in range(1,(prime-1)//2 + 1):
			leftside *= a**(2 * D * (values_mod_symb[a-1]*scalar)) % prime
		rightside = torsion_period**((D * values_mod_symb[-1] * scalar)//(ord_period)) % prime

		# Check sagemath_implementation.pdf, In particular Remark 0.1 for the explanation of this loop
		for _ in range(exp_grp):
			leftside = leftside ** D % prime
			rightside = rightside ** D % prime

		# This checks if the conjecture holds or not
		if leftside != rightside:
			C_6 = 0 

	# We save all the information to the file Results.txt
	results_file.write(f'{E_Sage.label()} {prime} [{C_4},{D_4}] [{C_5},{D_5}] [{C_6},{D_6}]\n')
	results_file.close()


if '__main__' == __name__:
	# This is to make sure that the file "Results.txt" is an empty file.
	file = open('Results.txt', 'w')
	file.close()
	# This is to parse the modular symbols calculated and saved i.e. the database
	for i in ['00000-09999', '10000-19999', '20000-29999','30000-39999','40000-49999','50000-59999','60000-69999','70000-79999','80000-89999','90000-99999']:
		
		ModularSymbolsfile = eval(open(f'./ModularSymbolsReady/{i}.txt', 'r').readlines()[0])

		for key in ModularSymbolsfile.keys():
			
			for prime in ModularSymbolsfile[key].keys():
				
				E_coeff = eval(key)
				p = Integer(prime)
				str_list_values = ModularSymbolsfile[key][prime]
				list_values = [Rational(x) for x in str_list_values[1:-1].split(',')]
				
				TestConjectures(E_coeff, p, list_values)


