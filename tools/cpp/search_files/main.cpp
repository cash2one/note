
//-------------------------------------------
//  遍历所有子目录及子文件夹
//-------------------------------------------

#include<iostream>
#include<io.h>
using namespace std;


void displayFile(_finddata_t &file, string path, string respath = "*.*")
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
		cout << "文件没有找到!\n";
	}
	else
	{
		//如果找到下个文件的名字成功的话就返回0,否则返回-1
		//int __cdecl _findnext(long, struct _finddata_t *);
		cout << "\n文件列表:\n";
		while (_findnext(lf, &file) == 0)
		{
			string str(file.name);
			cout << file.name << endl;
			if (file.attrib == _A_NORMAL) cout << "  普通文件  ";
			else if (file.attrib == _A_RDONLY)cout << "  只读文件  ";
			else if (file.attrib == _A_HIDDEN)cout << "  隐藏文件  ";
			else if (file.attrib == _A_SYSTEM)cout << "  系统文件  ";
			else if (file.attrib == _A_SUBDIR)
			{
				if (strcmp(file.name, "..") == 0)
				{
					cout << "  当前目录  ";
				}
				else if (strcmp(file.name, ".svn") == 0)
				{
					cout << "  svn目录  ";
				}
				else
				{
					cout << "  子目录  ";
					displayFile(file, path + file.name, respath);
				}
			}
			else
			{
				 cout<<"  存档文件  ";
			}
			cout<<endl;
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

