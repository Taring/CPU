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
    
    freopen("data.in", "r", stdin);
    freopen("data.vlog", "w", stdout);
    
    /*
    int lines = 0;
    for (int i = 0; i < 100; ++i) {
        Write(i + 1, 32);
        printf("\n");
        ++lines;
    }
    */
    char ch[105];
    int lines = 0;
    for (int i = 0; i < 100; ++i) {
        scanf("%s", ch);
        int tmp = 0;
        int length = strlen(ch);
        for (int i = 0; i < length; ++i) {
            int cnt = 0;
            if (ch[i] >= '0' && ch[i] <= '9')
                cnt = ch[i] - '0';
            else
                cnt = ch[i] - 'a' + 10;
            
            tmp = 16 * tmp + cnt;
        }
        Write(tmp, 32);
        printf("\n");
        ++lines;
    }
    
    while (lines < 65536) {
        for (int times = 0; times < 32; ++times)
            printf("0");
        if (lines != 65535)
            printf("\n");
        ++lines;
    }

    return 0;
}