#include<iostream>
#include<Windows.h>
using namespace std;

class CChineseCode
{
public:
	static void UTF_8ToUnicode(wchar_t* pOut, char *pText);  // 把UTF-8转换成Unicode  
	static void UnicodeToUTF_8(char* pOut, wchar_t* pText);  //Unicode 转换成UTF-8  
	static void UnicodeToGB2312(char* pOut, wchar_t uData);  // 把Unicode 转换成 GB2312   
	static void Gb2312ToUnicode(wchar_t* pOut, char *gbBuffer);// GB2312 转换成　Unicode  
	static void GB2312ToUTF_8(string& pOut, char *pText, int pLen);//GB2312 转为 UTF-8  
	static void UTF_8ToGB2312(string &pOut, char *pText, int pLen);//UTF-8 转为 GB2312  

	//以上方法【如UTF_8ToGB2312】有错误，有机会的话更正，比如字符串:
	//·东盾牌忍首领跳捧花僵
	//第一个字符无法识别，于是导致后面的字符均读取错误


	//--------------------------------------------------------------------------------------

	static wstring ANSIToUnicode(const string& str);
	static string UnicodeToANSI(const wstring& str);
	static wstring UTF8ToUnicode(const string& str);
	static string UnicodeToUTF8(const wstring& str);
};
