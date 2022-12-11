---
title: 卜东坡算法-2021秋作业2-动态规划
date: 2022-03-02 19:26:58
permalink: /pages/dd3f5b/
categories:
  - 学习
tags:
  - 算法学习
  - 卜东坡-算法设计与分析
  - 动态规划
---
# 2021秋作业2-动态规划
##  1. Money robbing
A robber is planning to rob houses along a street. Each house has a certain amount of money stashed, the only constraint stopping you from robbing each of them is that adjacent houses have security system connected and it will automatically contact the police if two adjacent houses were broken into on the same night. 

1. Given a list of non-negative integers representing the amount of money of each house, determine the maximum amount of money you can rob tonight without alerting the police. 
2. 2. What if all houses are arranged in a circle?

**解法：**

```c++
class Solution {
public:
    int robMaxMoney(vector<int>& a) {
        int start = 0;
        int end = a.size() - 1;
        vector<int> dp(end, 0); //初始化dp全部为0，dp表示前i+1个房子抢劫的最大金钱数
        dp[0] = a[0];
        dp[1] = max(a[0], a[1]);
        for (int i = 2; i <= end; ++i) {
            dp[i] = max(dp[i - 1], dp[i - 2] + a[i]);
        }
        return dp[end];
    }
};
```




##  2. Largest Divisible Subset

Given a set of distinct positive integers, find the largest subset such that every pair (Si , Sj ) of elements in this subset satisfies: Si%Sj = 0 or Sj%Si = 0. 

Please return the largest size of the subset. 

Note: Si%Sj = 0 means that Si is divisible by Sj .

**解法：**

```c++
class Solution {
public:
    int getLargestDivisibleSum(vector<int>& nums) {
       	quickSort(nums); //先使用快速排序对数组从小到大进行排序
        int size = nums.size();
        vector<int> dp(size, 1); //初始化dp全部为1，dp表示前i个数元素最多的可整除子集长度
        for (int i = 2; i <= size; ++i) {
            for (int j = 1; j < i; ++j) {
                if (nums[i] % nums[j] == 0) {
                    dp[i] = max(dp[i], dp[j] + 1);
                }
            }
        }
    }
};
```



##  3. Unique Binary Search Trees

Given n, how many structurally unique BST’s (binary search trees) that store values 1...n?

Explanation: Given n = 3, there are a total of 5 unique BST’s:

```java
class Solution {
public:
    int getBSTSum(const int& n) {
        vector<int> dp(n, 0);
        dp[0] = dp[1] = 1;
        for (int i=2; i <= n; ++i) {
            for (int j=0; j < i; ++j) {
                dp[i] += dp[j] * dp[i - j - 1];
            }
        }
    }
};
```

##  4. Word Break

Given a string S and a dictionary of words, determine if the string S can be segmented into a space-separated sequence of one or more dictionary words. 

Note: Each word in the dictionary may be reused multiple times in the segmentation. You can return TRUE if the string S is empty.



```C++
class Solution {
public:
    bool wordBreak(string s, vector<string>& wordDict) {
        int n = s.size();
        vector<bool> dp(n, false);
        dp[0] = true;
        for (int i = 1; i <= n; ++i) {
            for (auto str: wordDict) {
                int str_len = str.size();
                if (i >= str_len) {
                    dp[i] = (dp[i - str_len] // 表示前 i - str_len个字符是否由wordDict单词组成
                             && s.substr(i - str_len, str_len) == str) // i - str_len到i是否组成一个单词
                            || dp[i]; // dp[i]表示前s的前i个字符是否由wordDict的单词组成，只要找到一个dp[i]满足，则dp[i]就是
                }
            }
        }
        return dp[n];
    }
};
```
##  5. Distinct Sequences 

Given two strings S and T, return the number of distinct subsequences of S which equals T.

A string’s subsequence is a new string formed from the original string by deleting some (can be none) of the characters without disturbing the remaining characters’ relative positions. (i.e., ”ACE” is a subsequence of ”ABCDE” while ”AEC” is not).

**Example 1:**

```
Input: s = "rabbbit", t = "rabbit"
Output: 3
Explanation:
As shown below, there are 3 ways you can generate "rabbit" from S.
rabbbit
rabbbit
rabbbit
```

**Example 2:**

```
Input: s = "babgbag", t = "bag"
Output: 5
Explanation:
As shown below, there are 5 ways you can generate "bag" from S.
babgbag
babgbag
babgbag
babgbag
babgbag
```

```c++
class Solution {
public:
    int numDistinct(string s, string t) {
        int n = s.size();
        int m = t.size();
        vector<vector<int>> dp(n + 1, vector<int>(m + 1, 0));
        for (int i=0; i<=n; ++i)
            dp[i][0] = 1;
        for (int i = 1; i <= n; ++i) {
            for (int j = 1; j <= m; ++j) {
                if (s[i] == t[j]) {
                    dp[i][j] = dp[i - 1][j - 1] + dp[i - 1][j];// 两种情况之和
                } else {
                    dp[i][j] = dp[i - 1][j];// 如果当前字符不相等，则说明s的前i个字符和t的前j个字符的字集个数会 等于 s的前i-1个字符和t的前j个字符的个数
                }
            }
        }
        return dp[n][m];
    }
};
```



##  6. Triangle

Description



Given a triangle array, return the minimum path sum from top to bottom.

For each step, you may move to an adjacent number of the row below. More formally, if you are on index i on the current row, you may move to either index i or index i +1on the next row.



Input



Line1:

The height of the triangle, and 1 &lt;= triangle.height &lt;= 2001<=*t**r**i**a**n**g**l**e*.*h**e**i**g**h**t*<=200.

Line2:

All the elements in the triangle, and split by some spaces(for each element,-10^4<= triangle[i][j] <=10^4). We are sure that the number of the elements satisfy:



Output



Print the minimum path sum from top to bottom.



Sample Input 1 

```
4
2 3 4 6 5 7 4 1 8 3
```

Sample Output 1

```
11
```

Sample Input 2 

```
1
-10
```

Sample Output 2

```
-10
```

Hint

Input:

4

2 3 4 6 5 7 4 1 8 3

Output:

11

Explanation: The triangle looks like:

**2**

**3**4

6**5**7

4**1**83

The minimum path sum from top to bottom is 2 + 3 + 5 + 1 = 11 (bolded above)

```c++
class Solution {
public:
    int miniPathSum(const vector<vector<int>>& triangles)
    {
        int n = triangles.size();
        vector<int> dp(n + 1, 0);
        for (int i=n; i>=1; --i) {
            for (int j=1; j<=i; ++j) {
                dp[j - 1] = min(dp[j - 1], dp[j]) + triangles[i][j]; 
            }
        }
        return dp[0];
    }

};
```

##  7. Maximum Alternating Subsequence Sum

Description

The alternating sum of a 0-indexed array is defined as the sum of the elements at even indices minus the sum of the elements at odd indices.

For example, the alternating sum of [4,2,5,3] is (4 + 5) - (2 + 3) = 4.

Given an array nums, return the maximum alternating sum of any subsequence of nums (after reindexing the elements of the subsequence).

A subsequence of an array is a new array generated from the original array by deleting some elements (possibly none) without changing the remaining elements' relative order.For example, [2,7,4] is a subsequence of [4,2,3,7,2,1,4] (the underlined elements), while [2,4,2] is not.



Input



Anarray.

1 &lt;= nums.length &lt;= 10^51<=*n**u**m**s*.*l**e**n**g**t**h*<=105

1 &lt;= nums[i] &lt;= 10^51<=*n**u**m**s*[*i*]<=105



Output



Maximum alternating sum.



Sample Input 1 

```
5 6 7 8
```

Sample Output 1

```
8
Explanation: It is optimal to choose the subsequence [8] with alternating sum 8.
```

Sample Input 2 

```
6 2 1 2 4 5
```

Sample Output 2

```
10
Explanation: It is optimal to choose the subsequence [6,1,5] with alternating sum (6 + 5) - 1 = 10.
```

Sample Input 3 

```
4 2 5 3
```

Sample Output 3

```
7
Explanation: It is optimal to choose the subsequence [4,2,5] with alternating sum (4 + 5) - 2 = 7.
```



```c++
class Solution {
public:
    int maxAlternatingSum(const vector<int>& nums) {
        int n = nums.size();
        vector<vector<int>> dp(n + 1, 0); // dp[i][0] 表示前i个数组成的子序列末位为偶数的最大交替和，dp[i][1]表示子序列末位为奇数的最大交替和。
        dp[1][1] = nums[0]; // 前i个数末位为奇数的时候最大和
        for (int i=1; i<=n; ++i) {
            dp[i][0] = max(dp[i-1][0], dp[i-1][1] - nums[i-1]);
            dp[i][1] = max(dp[i-1][1], dp[i-1][0] + nums[i-1]); // 前i个数交替和最大末位是奇数的情况，所以要考虑前i-1个数分别为奇和偶的情况。
        }
        return max(dp[n][0], dp[n][1]);
    }
};
```
