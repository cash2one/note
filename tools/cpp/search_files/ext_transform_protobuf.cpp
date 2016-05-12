
//-------------------------------------------
//  拓展 ： 提取所有protobuf函数
//-------------------------------------------


#include<iostream>
#include<fstream>
#include<io.h>
using namespace std;


bool dealFile(string path, string file, FILE *fout)
{
	path += file;
	if (strstr(path.c_str(), ".proto"))
	{
		file = file.substr(0, file.size() - 6);
		FILE *fp;
		char str[1000];
		char msgHead[1000];
		char msgName[1000];
		fp = fopen((path).c_str(), "rt");
		if (fp == NULL)
		{
			cout << "==> 文件打开失败" << endl;
			return false;
		}
		while (fgets(str, 1000, fp))  //读取一行，并判断文件是否结束
		{
			if (strstr(str, "message") >= 0)
			{
				sscanf(str, "%s %s", msgHead, msgName);
				if (strcmp(msgHead, "message") == 0)
				{
					string msgBody = "[\"" + string(msgName) + "\"]";
					fprintf(fout, "%-40s = \"%s\", \n", msgBody.c_str(), file.c_str());
				}
			}
		}
		fprintf(fout, "\n");
		fclose(fp);
		return true;
	}
	return false;
}

void displayFiles(string path, _finddata_t &file, FILE *fout, string respath = "*.*")
{
	string pt = path + respath;
	const char* p = pt.c_str();
	long lf;
	//查找第1个文件， _findfirst返回的是long型; 
	//long __cdecl _findfirst(const char *, struct _finddata_t *)
	if ((lf = _findfirst(p, &file)) == -1l)
	{
		cout << "文件没有找到!" << endl << endl;
	}
	else
	{
		//如果找到下个文件的名字成功的话就返回0,否则返回-1
		//int __cdecl _findnext(long, struct _finddata_t *);
		cout << "\n文件列表:" << endl << endl;

		while (_findnext(lf, &file) == 0)
		{
			string str(file.name);
			//判断文件类型，然而没什么鸟用
			if (file.attrib == _A_NORMAL) cout << "  普通文件:  ";
			else if (file.attrib == _A_RDONLY)cout << "  只读文件:  ";
			else if (file.attrib == _A_HIDDEN)cout << "  隐藏文件:  ";
			else if (file.attrib == _A_SYSTEM)cout << "  系统文件：  ";
			else if (file.attrib == _A_SUBDIR)
			{
				if (strcmp(file.name, "..") == 0)
				{
					cout << "  当前目录：  ";
				}
				else if (strcmp(file.name, ".svn") == 0)
				{
					cout << "  svn目录:  ";
				}
				else
				{
					cout << "  子目录：  ";
					//递归遍历子目录
					displayFiles(path + file.name + "\\", file, fout, respath);
				}
			}
			else
			{
				cout << "  存档文件：  ";
			}
			cout << file.name << endl << endl;


			//处理文件
			if (dealFile(path, file.name, fout))
			{
				cout << "  ==> 正在处理..." << endl << endl;
			}
		}
	}
	_findclose(lf);
}

void findFiles(string path)
{
	if (path.size() > 0)
	{
		auto ch = path[path.size() - 1];
		if (!(ch == '\\' || ch == '/'))
		{
			path += "\\";
		}
	}
	//写入目录
	string outFile = path + "auto_pb.txt";
	FILE *fout;
	fout = fopen(outFile.c_str(), "w+");
	if (fout == NULL)
	{
		cout << "文件写入失败" << endl << endl;
		return;
	}
	//查询目录
	_finddata_t file;
	//递归遍历
	displayFiles(path, file, fout);
	//关闭文件
	fclose(fout);
}

int main()
{
	findFiles(".");
	system("pause");
	return 0;
}
