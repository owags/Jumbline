#include <iostream>

#include <fstream>
#include <time.h>
using namespace std;

char* Generator(int &);
void Zero_glCheck(int[], int);
void wordSearch(fstream &, char [], int);
void wordSearch(fstream &, const char[], int);

void main ()
	{
	int			genLetSize;
	char*		genLet;
	const char	preLet[7] = { 'N', 'A', 'L', 'S', 'T', 'E', 'I' };
	fstream		dictionary;

	/*	Normally you would simply call the generator and
		send the resultant values to wordSearch () as such:
		
		genLet = Generator (genLetSize);				// generates randowm letters
		wordSearch (dictionary, genLet, genLetSize);	// finds all possible words

		but for this case I wanted to demonstrate a set of 
		letters that would create 200 possible words!
	*/

	genLetSize = 7;
	dictionary.open("textandpadding.txt", fstream::in);
	wordSearch(dictionary, preLet, genLetSize);
	dictionary.close();
	}

char* Generator (int & n)
	{
	int		r;
	char*	letters;
	char	vowels [5] = {'A','E','I','O','U'};
	cout << "How many letters would you like generated? (Max 7): " << endl;
	cin	>> n;
	cout << "Generating " << n << " letters..." << endl;
	letters = new char [7];		//should be n, temporary test
	srand ((unsigned)time(NULL));

	for (int i = 0; i < (n-1); ++i)
		{
		r = (rand () % 26) + 65;
		letters [i] = static_cast<char> (r);
		}

	r = rand () % 5;
	letters [n-1] = vowels [r];

	for (int i = 0; i < n; ++i)
		cout << letters [i];
	cout << endl << endl;
	return letters;
	}

void Zero_glCheck(int a [], int size)
	{
	for (int i = 0; i < size; ++i)
		a[i] = 0;
	}

void wordSearch(fstream & dict, char genLet [], int genLetSize)
	{
	int		wbCount = 0;
	int		strmSize = 7;
	char	wordBank[200][7];
	char*	inpWord = new char[strmSize];		//used for .read
	int*	glCheck = new int[genLetSize]();

	if (dict.is_open())
		{
		bool nextWord;
		bool nextChar;
		char x;
		for (dict.read(inpWord, strmSize); dict.good(); dict.read(inpWord, strmSize))
			{
			nextWord = false;
			x = inpWord[0];
			for (int i = 0; x != ' ' && nextWord == false; x = inpWord[++i])
				{
				nextChar = false;
				for (int j = 0; j < genLetSize && nextChar == false; ++j)
					if (genLet[j] == x && glCheck[j] == 0)
						{
						glCheck[j] = 1;
						nextChar = true;
						}
				if (nextChar == false)
					{
					nextWord = true;
					Zero_glCheck(glCheck, genLetSize);
					}
				}
			if (nextWord == false)
				{
				for (int i = 0; i < strmSize; ++i)
					wordBank[wbCount][i] = inpWord[i];
				++wbCount;
				}
			}
		}
	else
		cout << "Error opening dictionary" << endl;

	for (int i = 0; i < wbCount; ++i)
		{
		for (int j = 0; j < 7; ++j)
			cout << wordBank[i][j];
		cout << endl;
		}
	cout << "Word Bank Count: " << wbCount << endl;

	delete[] genLet;
	delete[] glCheck;
	delete[] inpWord;
	}

void wordSearch(fstream & dict, const char genLet[], int genLetSize)
	{
	int		wbCount = 0;
	int		strmSize = 7;
	char	wordBank[200][7];
	char*	inpWord = new char[strmSize];		//used for .read
	int*	glCheck = new int[genLetSize]();

	if (dict.is_open())
		{
		bool nextWord;
		bool nextChar;
		char x;
		for (dict.read(inpWord, strmSize); dict.good(); dict.read(inpWord, strmSize))
			{
			nextWord = false;
			x = inpWord[0];
			for (int i = 0; x != ' ' && nextWord == false; x = inpWord[++i])
				{
				nextChar = false;
				for (int j = 0; j < genLetSize && nextChar == false; ++j)
				if (genLet[j] == x && glCheck[j] == 0)
					{
					glCheck[j] = 1;
					nextChar = true;
					}
				if (nextChar == false)
					{
					nextWord = true;
					Zero_glCheck(glCheck, genLetSize);
					}
				}
			if (nextWord == false)
				{
				for (int i = 0; i < strmSize; ++i)
					wordBank[wbCount][i] = inpWord[i];
				++wbCount;
				}
			}
		}
	else
		cout << "Error opening dictionary" << endl;

	for (int i = 0; i < wbCount; ++i)
		{
		for (int j = 0; j < 7; ++j)
			cout << wordBank[i][j];
		cout << endl;
		}
	cout << "Word Bank Count: " << wbCount << endl;

	delete[] glCheck;
	delete[] inpWord;
	}