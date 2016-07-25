
//-------------------------------------------
//  遍历所有子目录及子文件夹
//-------------------------------------------

#include<iostream>
#include<io.h>
using namespace std;


void displayFile(_finddata_t &file, string path, string respath = "*.*", string indent = "- ")
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
					displayFile(file, path + file.name, respath, indent + "    ");
				}
				//目录不进行后续处理，直接continue
				continue;
			}
			else
			{
				cout << "存档文件: ";
			}
			cout << file.name;
			//在这里进行文件后续处理
			cout << endl;
		}
	}
	_findclose(lf);
}

void findFile(string path)
{
	_finddata_t file;
	//递归遍历
	displayFile(file, path);
}

int main()
{
	findFile("D:\\git\\mslua\\mslua\\tools\\pbfiles\\");
	system("pause");
	return 0;
}

