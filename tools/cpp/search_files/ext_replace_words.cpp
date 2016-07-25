
//-------------------------------------------
//  拓展 ： 替换文字
//-------------------------------------------

#include<iostream>
#include"ChineseCode.h"
#include<io.h>
#include<Windows.h>
using namespace std;

char szOld[1 << 15];
char szNew[1 << 15];
char szRes[1 << 20];

void replaceWord(const char *inPath, const char *outPath, const char *oldWord, const char *newWord)
{
	//导入
	FILE *fin = fopen(inPath, "rt");
	if (fin == NULL)
	{
		cout << "Error: " << inPath << "打开失败" << endl;
		return;
	}
	//替换
	int iNewLength;
	auto iOldWordLength = strlen(oldWord);
	auto iNewWordLength = strlen(oldWord);
	auto iResLength = 0;
	while (fgets(szOld, 1 << 17, fin))
	{
		char *szLine;
		auto old = strstr(szOld, oldWord);
		if (old && old >= szOld)
		{
			strncpy(szNew, szOld, old - szOld);
			iNewLength = old - szOld;
			szNew[iNewLength] = '\0';
			strcat(szNew, newWord);
			iNewLength += iNewWordLength;
			szNew[iNewLength] = '\0';
			strcat(szNew, old + iOldWordLength);
			iNewLength += strlen(old + iOldWordLength);
			szNew[iNewLength] = '\0';
			szLine = szNew;
		}
		else
		{
			szLine = szOld;
		}
		auto wszBuff = CChineseCode::UTF8ToUnicode(szLine);
		auto szBuf = CChineseCode::UnicodeToANSI(wszBuff);
		auto iLineBufferSize = szBuf.size();
		strncpy(szRes + iResLength, szBuf.c_str(), iLineBufferSize);
		iResLength += iLineBufferSize;
	}
	szRes[iResLength] = '\0';
	fclose(fin);

	//导出
	FILE *fout = fopen(outPath, "w+,ccs=utf-8");
	if (fout == NULL)
	{
		cout << "Error: " << outPath << "写入失败" << endl;
		return;
	}
	auto wOutStr = CChineseCode::ANSIToUnicode(szRes);
	fwrite(wOutStr.c_str(), wOutStr.size() * 2, 1, fout);
	fclose(fout);
}


int main(int argc, char *argv[])
{
	if (argc >= 5)
	{
		replaceWord(argv[1], argv[2], argv[3], argv[4]);
	}
	else if (false)
	{
		char s1[] = "D:\\git\\mslua\\mslua\\res\\ui\\fonts\\font_20.fnt";
		char s2[] = "D:\\git\\mslua\\mslua\\res\\ui\\fonts\\font_20_tmp.txt";
		char s3[] = "font_20_0";
		char s4[] = "font_20";
		replaceWord(s1, s2, s3, s4);
		system("pause");
	}
	return 0;
}
