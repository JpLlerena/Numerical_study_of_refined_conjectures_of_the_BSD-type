import os
from multiprocessing import Pool

file_names = ['00000-09999', '10000-19999', '20000-29999','30000-39999','40000-49999','50000-59999','60000-69999','70000-79999','80000-89999','90000-99999']



def MultiprocessingModularSymbols(index):
	
	range_conductor = file_names[index]
	
	if not os.path.exists('./Temporal_Data/to_calculate_{}.txt'.format(range_conductor)):
		return None
	
	data_to_calculate = open('./Temporal_Data/to_calculate_{}.txt'.format(range_conductor), 'r')

	unsorted_values_file = open('./Temporal_Data/unsorted_values_{}'.format(range_conductor), 'w')
	
	for line in data_to_calculate.readlines():
		lines = line.split(';')
		values_modular_symbols = []
		equation = eval(lines[0])
		E = EllipticCurve(equation)
		ModularSymbol = E.modular_symbol(+1, implementation='eclib')
		prime = eval(lines[1])
		for a in range(1, prime):
			values_modular_symbols.append(ModularSymbol(a/prime))
		values_modular_symbols.append(ModularSymbol(0))
		
		unsorted_values_file.write(str(values_modular_symbols)+';'+line)
		unsorted_values_file.close()
		unsorted_values_file = open('./Temporal_Data/unsorted_values_{}'.format(range_conductor), 'a')


def clean_data():
	for nameFile in file_names:
		
		if not os.path.exists('./ModularSymbolsReady/{}.txt'.format(nameFile)):
			database = {}
		else:
			database = eval(open('./ModularSymbolsReady/{}.txt'.format(nameFile), 'r').readlines()[0])

		if not os.path.exists('./Temporal_Data/unsorted_values_{}'.format(nameFile)):
			continue
		add_to_database = open('./Temporal_Data/unsorted_values_{}'.format(nameFile), 'r')
		
		for line in add_to_database.readlines():
			lines = line[:-1].split(';')
			if lines[1] in database:
				database[lines[1]][lines[2]] = lines[0]
			else:
				database[lines[1]] = {lines[2]:lines[0]}
		
		clean_database = open('./ModularSymbolsReady/{}.txt'.format(nameFile), 'w')
		clean_database.write(str(database))
		clean_database.close()

	return None


def create_all_possible_pairs():
	
	for file_name in file_names:
		list_elliptic_curves_cremona = open('./Cremona_database/allbsd.{}'.format(file_name), 'r').readlines()
		if os.path.exists('./Temporal_Data/all_pairs_{}.txt'.format(file_name)):
			continue
		
		Output = open('./Temporal_Data/all_pairs_{}.txt'.format(file_name), 'w')
		
		for line in list_elliptic_curves_cremona:
			split_lines = line.split(' ')
			Eliptic = EllipticCurve(eval(split_lines[3]))
			for prime in list(factor(eval(split_lines[0]))):
				if not Eliptic.has_split_multiplicative_reduction(prime[0]):
					continue
				Output.write(str(split_lines[3]) + ';' +  str(prime[0]) + '\n')
		
		Output.close()


if __name__ == '__main__':
	
	if not os.path.exists('./Temporal_Data/'):
		os.mkdir('./Temporal_Data/')
	if not os.path.exists('./ModularSymbolsReady/'):
		os.mkdir('./ModularSymbolsReady/')

	print("Creating all the pairs (E,p)")
	create_all_possible_pairs()
	print("Organizing the database if it their is unsorted data")
	clean_data()

	for file_name in file_names:
		if not os.path.exists('./ModularSymbolsReady/{}.txt'.format(file_name)):
			dictionary_pairs = {}
		else:
			dictionary_pairs =  eval(open('./ModularSymbolsReady/{}.txt'.format(file_name), 'r').readlines()[0])
		
		new_values = []
		file_to_calculate = open('./Temporal_Data/to_calculate_{}.txt'.format(file_name), 'w')
		all_pairs = open('./Temporal_Data/all_pairs_{}.txt'.format(file_name), 'r')
		for line in all_pairs.readlines():
			lines = line[:-1].split(';')
			if not lines[0] in dictionary_pairs.keys():
				new_values.append(line)
			elif not lines[1] in dictionary_pairs[lines[0]]:
				new_values.append(line)
		if len(new_values) > 0:
			for new_value in new_values:
				file_to_calculate.write(new_value)
		file_to_calculate.close()

	number_of_files = range(len(file_names))

	cpu_number = 1

	p = Pool(processes = cpu_number)

	print("Starting to calculate the database")

	resuls = p.map(MultiprocessingModularSymbols, number_of_files)

	p.close()
	p.join()
