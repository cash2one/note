#include<iostream>
#include"ChineseCode.h"
#include<io.h>
#include <Windows.h>
using namespace std;

bool isDebug = false;

bool dealFile(string path, string file, char *outString, int &outLength)
{
	path += file;
	if (strstr(path.c_str(), ".xml") || strstr(path.c_str(), ".lua") || strstr(path.c_str(), ".csd"))
	{
		char str[1000];
		char msgHead[1000];
		char msgName[1000];
		FILE *fp = fopen((path).c_str(), "rt");
		if (fp == NULL)
		{
			cout << "  ==> 打开失败...";
			return false;
		}
		cout << "  ==> 正在处理...";
		if (isDebug)
		{
			//打印是哪个文件找到的中文
			sprintf(outString + outLength, " \n\n\n");
			outLength += 4;
			sprintf(outString + outLength, "%s", path.c_str());
			outLength += path.size();
			if (path.size() & 1)
			{
				sprintf(outString + outLength, " ");
				outLength += 1;
			}
			sprintf(outString + outLength, " \n");
			outLength += 2;
		}
		
		int iSize;
		char text[3];
		char szStr[1 << 15];
		while (fgets(szStr, 1 << 15, fp))
		{
			auto wszBuff = CChineseCode::UTF8ToUnicode(szStr);
			auto szBuf = CChineseCode::UnicodeToANSI(wszBuff);
			auto iLineBufferSize = szBuf.size();
			for (auto i = 0; i < iLineBufferSize;)
			{
				text[0] = szBuf.at(i++);
				if ((text[0] < 0 || 127 < text[0]) && i < iLineBufferSize)
				{
					text[1] = szBuf.at(i++);
					text[2] = '\0';
					iSize = 2;
					int iIndex = 0;
					while (iIndex + 1 < outLength)
					{
						if (text[0] == outString[iIndex] && text[1] == outString[iIndex + 1])
						{
							break;
						}
						iIndex += 2;
					}
					if (iIndex + 1 >= outLength)
					{
						sprintf(outString + outLength, "%s", text);
						outLength += iSize;
					}
					//printf("%s", text);
				}
				else
				{
					text[1] = '\0';
					iSize = 1;
					//单个字符不处理
				}
			}
		}
		fclose(fp);
		return true;
	}
	return false;
}

void displayFiles(string path, _finddata_t &file, char *outString, int &outLength, string respath = "*.*", string indent = "- ")
{
	if (path.size() > 0)
	{
		auto ch = path[path.size() - 1];
		if (!(ch == '\\' || ch == '/'))
		{
			path += "\\";
		}
	}
	string pt = path + respath;
	const char* p = pt.c_str();
	long lf;
	//查找第1个文件， _findfirst返回的是long型; 
	//long __cdecl _findfirst(const char *, struct _finddata_t *)
	if ((lf = _findfirst(p, &file)) == -1l)
	{
		cout << indent.c_str() << indent.c_str() << "Error: 文件没有找到!" << endl;
	}
	else
	{
		//如果找到下个文件的名字成功的话就返回0,否则返回-1
		//int __cdecl _findnext(long, struct _finddata_t *);
		//cout << indent.c_str() << "文件列表:" << endl;

		while (_findnext(lf, &file) == 0)
		{
			cout << indent.c_str();
			string str(file.name);
			//判断文件类型，然而没什么鸟用
			if (file.attrib == _A_NORMAL) cout << "普通文件: ";
			else if (file.attrib == _A_RDONLY)cout << "只读文件: ";
			else if (file.attrib == _A_HIDDEN)cout << "隐藏文件: ";
			else if (file.attrib == _A_SYSTEM)cout << "系统文件: ";
			else if (file.attrib == _A_SUBDIR)
			{
				if (strcmp(file.name, "..") == 0)
				{
					cout << "当前目录: " << file.name << endl;
				}
				else if (strcmp(file.name, ".svn") == 0)
				{
					cout << "svn目录: " << file.name << endl;
				}
				else
				{
					cout << "子目录: " << file.name << endl;
					//递归遍历子目录
					displayFiles(path + file.name + "\\", file, outString, outLength, respath, indent + "    ");
				}
				continue;
			}
			else
			{
				cout << "存档文件: ";
			}
			cout << file.name;
			dealFile(path, file.name, outString, outLength);
			cout << endl;
		}
	}
	_findclose(lf);
}

void findFiles(string dirFile, string outFile)
{
	//从文件找目录
	FILE *fdir = fopen(dirFile.c_str(), "rt");
	if (fdir == NULL)
	{
		cout << "Error: " << dirFile.c_str() << "打开失败" << endl;
		return;
	}
	//遍历所有目录
	char outString[1 << 17];
	int outLength = 0;
	char szDir[1<<17];
	char arrDir[1 << 8][1 << 9];
	while (fgets(szDir, 200, fdir))
	{
		int iLength = 0, iPos = 0, iIndex = 0;
		//以逗号隔开，若只有1个，则表示目录；若有多个，则表示目录+多个文件（第0个为目录）
		while(1){
			if (szDir[iIndex] == ',' || szDir[iIndex] == '\0' || szDir[iIndex] == '\n' || szDir[iIndex] == '\t')
			{
				if (iPos > 0)
				{
					arrDir[iLength++][iPos] = '\0';
					iPos = 0;
				}
				if (szDir[iIndex] == '\0')
				{
					break;
				}
			}
			else
			{
				arrDir[iLength][iPos++] = szDir[iIndex];
			}
			++iIndex;
		}
		if (iLength == 1)
		{
			cout << "-------------------------------------------------------------" << endl;
			//递归遍历
			_finddata_t file;
			displayFiles(arrDir[0], file, outString, outLength);
		}
		else
		{
			for (auto i = 1; i < iLength; ++i)
			{
				cout << "-------------------------------------------------------------" << endl;
				cout << "- 存档文件: " << arrDir[0] << arrDir[i];
				dealFile(arrDir[0], arrDir[i], outString, outLength);
				cout << endl;
			}
		}
		cout << "-------------------------------------------------------------" << endl;
	}
	outString[outLength] = '\0';

	//写入文件
	FILE *fout;
	bool ansi = false;
	if (ansi)
	{
		//导出为ANSI
		fout = fopen(outFile.c_str(), "w+");
		if (fout == NULL)
		{
			cout << "Error: " << outFile.c_str() << "写入失败" << endl;
			return;
		}
		fwrite(outString, outLength, 1, fout);
	}
	else
	{
		//导出为UTF-8格式
		fout = fopen(outFile.c_str(), "w+,ccs=utf-8");
		if (fout == NULL)
		{
			cout << "Error: " << outFile.c_str() << "写入失败" << endl;
			return;
		}
		//导出为UTF-8格式
		auto wOutStr = CChineseCode::ANSIToUnicode(outString);
		//auto OutStr = CChineseCode::UnicodeToUTF8(wOutStr);
		//fwrite(OutStr.c_str(), OutStr.size(), 1, fout);
		fwrite(wOutStr.c_str(), wOutStr.size() * 2, 1, fout);
	}
	fclose(fout);
}

int main(int argc, char *argv[])
{
	if (argc >= 3)
	{
		if (argc > 3 && strstr(argv[3], "debug") != nullptr)
		{
			isDebug = true;
		}
		//argv[0]是  .\main.exe
		findFiles(argv[1], argv[2]);
	}
	else
	{
		isDebug = true;
		findFiles("dir.txt", "chars.txt");
		system("pause");
	}
	return 0;
}
