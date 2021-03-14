#include <iostream>

using namespace std;



template <typename T> 
inline T const& Max(T const& a, T const& b) {
	return	a < b ? b : a;
}

int main(int argc, char *argv[]) {

	cout << Max(1, 2) << endl;
	cout << Max(1.1, 2.2) << endl;
	cout << Max("aa", "bb") << endl;

	return 0;
}
