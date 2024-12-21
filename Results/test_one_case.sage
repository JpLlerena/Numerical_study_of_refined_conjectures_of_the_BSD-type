
# Is this is set to true and the elliptic curve does not satisfy one of the 3 conjectures then the values will be verified with all 3 implementation 'eclib', 'sagemath', 'numerical approximation'. This can make checking the conjecture significantly slower.
verify_modular_symbols_values = False

E_label = '126.b1'
prime = 7


E_Sage = EllipticCurve(E_label)
mod_space = E_Sage.modular_symbol(+1)
if not E_Sage.has_split_multiplicative_reduction(prime):
	print(f"The elliptic curve doesn't have split multiplicative reduction at {prime}")

E_Cremona = CremonaDatabase().data_from_coefficients(E_Sage.a_invariants())

ord_period = E_Sage.j_invariant().denominator().valuation(prime)
torsion_period = Integer(E_Sage.tate_curve(prime).parameter().unit_part().expansion()[0]) 
r_E = E_Cremona['rank']
C_E = E_Cremona['db_extra'][0]
tau_E = E_Cremona['torsion_order']
sha_E = Integer(E_Cremona['db_extra'][-1])

exp_grp = 17

scalar = 1
if E_Sage.discriminant() < 0:
	scalar = 2


C_5 = 1 
C_6 = 1 
C_4 = 1

leftside = 1
rightside = 1

denominators = []

# Conjecture 4

if r_E != 0:

	for a in range(1, (prime-1)//2 + 1):
		denominators.append((mod_space(a/prime)*scalar).denominator())
	D = lcm(denominators)

	for a in range(1 , (prime-1)//2 + 1):
		leftside *= a**(2 * D * (mod_space(a/prime)*scalar)) % prime

	for _ in range(exp_grp):
		leftside = leftside ** D % prime
		rightside = rightside ** D % prime

	if leftside != 1:
		C_4 = 0 

# Conjecture 5

leftside = 1
rightside = 1

if r_E == 0 :
	
	for a in range(1, ((prime-1)//2) + 1):
		denominators.append((mod_space(a/prime)* scalar).denominator())
	
	D = lcm(lcm(denominators),tau_E^2)
	 
	for a in range(1 , ((prime-1)//2) + 1):
		leftside = leftside * a**(2 * D * (mod_space(a/prime)*scalar)) % prime
	rightside = torsion_period**((2 * D * C_E * sha_E)//(tau_E^2 * ord_period)) % prime


	for _ in range(exp_grp):
		leftside = leftside ** D % prime
		rightside = rightside ** D % prime

	if leftside % prime != rightside % prime:
		C_5 = 0
		print('there is a problem')
else:
	C_5 = -1
# Conjecture 6

for a in range(prime):
	denominators.append(scalar * mod_space(a/prime).denominator())

D = lcm(lcm(denominators), (mod_space(0)/(2*ord_period)).denominator())

for a in range(1,(prime-1)//2 + 1):
	leftside *= a**(2* D * (mod_space(a/prime)*scalar)) % prime
rightside = torsion_period**((D * mod_space(0) * scalar)//(ord_period)) % prime


for _ in range(exp_grp):
	leftside = leftside ** D % prime
	rightside = rightside ** D % prime

if leftside != rightside:
	C_6 = 0 

if (C_4 == 0 or C_5 == 0 or C_6 == 0) and verify_modular_symbols_values:
	sagemath_implementation = E.modular_symbol(+1, implementation='sage')
	eclib_implementation = E.modular_symbol(+1, implementation='eclib')
	numerical_implementation = E.modular_symbol(+1, implementation='num')

	for a in range(prime):
		sagemath_implementation_list.append(sagemath_implementation(Rational(a/prime)))
		eclib_implementation_list.append(eclib_implementation(Rational(a/prime)))
		numerical_implementation_list.append(numerical_implementation(Rational(a/prime)))

	if sagemath_implementation_list == eclib_implementation_list and eclib_implementation_list == numerical_implementation_list:
		print('All implementation give the same values')
	else:
		print('One of the implementation gives a different value')

print([C_4, C_5, C_6])
