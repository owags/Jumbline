#include <iostream>
using namespace std;

#include <time.h>

#pragma warning ( disable : 4244 )

void main ()
	{
	int		n;
	int		r;
	char *	letters;
	
	cout << "How many letters would you like generated? (Max 7): " << endl;
	cin >> n;

	cout << "Generating " << n << " letters..." << endl;
	
	letters = new char [n];
	srand ((unsigned)time(NULL));

	for (int i = 0; i < n; ++i)
		{
		r = (rand () % 26) + 65;
		letters [i] = static_cast<char> (r);
		}

	for (int i = 0; i < n; ++i)
		cout << "\t" << letters [i];

	delete [] letters;
	}

char* Generator ()
	{
	int		n;
	int		r;
	char *	letters;
	char vowels [5] = {'A','E','I','O','U'};
	
	cout << "How many letters would you like generated? (Max 7): " << endl;
	cin >> n;

	cout << "Generating " << n << " letters..." << endl;
	
	letters = new char [n];
	srand ((unsigned)time(NULL));

	for (int i = 0; i < (n-1); ++i)
		{
		r = (rand () % 26) + 65;
		letters [i] = static_cast<char> (r);
		}

	r = rand () % 5;
	letters [n] = vowels [r];

	for (int i = 0; i < n; ++i)
		cout << "\t" << letters [i];
	return letters;
	}