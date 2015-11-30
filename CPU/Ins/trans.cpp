#include <cstdio>
#include <cstdlib>
#include <iostream>
#include <algorithm>
#include <cstring>
#include <cmath>
#include <stack>
using namespace std;

char str[1005];
int addr;

inline void Write(int x, int y) {
	
	stack<int> S;
	while (!S.empty())
		S.pop();
	while (x) {
		S.push(x % 2);
		x /= 2;
	}
	int tmp = y - S.size();
	if (tmp < 0)
		printf("Error 2\n");
	while (tmp--)
		printf("0");
	while (!S.empty()) {
		printf("%d", S.top());
		S.pop();
	}

}

int main() {

	freopen("plus.s", "r", stdin);
	freopen("Ins.vlog", "w", stdout);

	int lines = 0;
	while (gets(str)) {

		int op_code = -1;
		if (str[0] == 'a' && str[1] == 'd' && str[2] == 'd' && str[3] == ' ') {
			op_code = 1;
		} else if (str[0] == 's' && str[1] == 'u' && str[2] == 'b' && str[3] == ' ') {
			op_code = 2;
		} else if (str[0] == 'm' && str[1] == 'u' && str[2] == 'l' && str[3] == ' ') {
			op_code = 3;
		} else if (str[0] == 'a' && str[1] == 'd' && str[2] == 'd' && str[3] == 'i') {
			op_code = 4;
		} else if (str[0] == 's' && str[1] == 'u' && str[2] == 'b' && str[3] == 'i') {
			op_code = 5;
		} else if (str[0] == 'm' && str[1] == 'u' && str[2] == 'l' && str[3] == 'i') {
			op_code = 6;
		} else if (str[0] == 's' && str[1] == 'l' && str[2] == 'l' && str[3] == 'i') {
			op_code = 7;
		} else if (str[0] == 'l' && str[1] == 'w') {
			op_code = 8;
		} else if (str[0] == 's' && str[1] == 'w') {
			op_code = 9;
		} else if (str[0] == 'j') {
			op_code = 10;
		} else if (str[0] == 'b' && str[1] == 'l' && str[2] == 't' && str[3] == 'z') {
			op_code = 13;
		} else if (str[0] == 'b' && str[1] == 'g' && str[2] == 'e' && str[3] == 'z') {
			op_code = 14;
		}
		if (op_code == -1) {
			if (str[0] == 'l') {
				addr = lines;
				continue;
			}
			//printf("ERROR\n");
		}
		
		Write(op_code, 4);
		if (op_code >= 1 && op_code <= 3) {
			int l = 0;
			for (int i = 0; i < 3; ++i) {
				while(str[l] != '$' && l != '#') ++l;
				int x = 0;
				for (++l; '0' <= str[l] && str[l] <= '9'; ++l)
					x = 10 * x + str[l] - '0';
				Write(x, 5);
			}
			Write(0, 13);
		} else if (op_code >= 4 && op_code <= 7) {
			int l = 0;
			for (int i = 0; i < 2; ++i) {
				while(str[l] != '$' && l != '#') ++l;
				int x = 0;
				for (++l; '0' <= str[l] && str[l] <= '9'; ++l)
					x = 10 * x + str[l] - '0';
				Write(x, 5);
			}
			int x = 0;
			while (str[l] < '0' || str[l] > '9') ++l;
			while ( '0' <= str[l] && str[l] <= '9')
				x = 10 * x + str[l] - '0', ++l;
			Write(x, 18);
		} else if (op_code == 8 || op_code == 9) {
			int l = 0;
			while(str[l] != '$' && l != '#') ++l;
			int x = 0;
			for (++l; '0' <= str[l] && str[l] <= '9'; ++l)
				x = 10 * x + str[l] - '0';
			Write(x, 5);

			int y = 0;
			while (str[l] < '0' || str[l] > '9') ++l;
			while ( '0' <= str[l] && str[l] <= '9')
				y = 10 * y + str[l] - '0', ++l;

			x = 0;
            while(str[l] != '$' && l != '#') ++l;
			for (++l; '0' <= str[l] && str[l] <= '9'; ++l)
				x = 10 * x + str[l] - '0';
			Write(x, 5);
			Write(y, 18);

		} else if (op_code > 10 && op_code <= 14) {
			int x = 0, l = 0;
            while (str[l] != '$' && l != '#') ++l;
			for (++l; '0' <= str[l] && str[l] <= '9'; ++l)
				x = 10 * x + str[l] - '0';
			Write(x, 5);
			Write(addr * 4, 23);
		}
		printf("\n");
		++lines;
	}
/*
    for (int i = 12; i; --i) {
        for (int times = 0; times < 32; ++times)
            printf("0");
        printf("\n");
        ++lines;
    }
*/
    for (int times = 0; times < 32; ++times)
        printf("1");
    printf("\n");
    ++lines;
    

	while (lines < 4096) {
		for (int times = 0; times < 32; ++times)
			printf("0");
		if (lines != 4095)
			printf("\n");
		++lines;
	}

	return 0;
}