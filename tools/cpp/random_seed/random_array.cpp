
//-------------------------------------------
//  创建一个种子文件
//-------------------------------------------


#include <fstream>
#include <ctime>

void writeSeedList()
{
	short int iRandMod = 20000;
	bool arrMark[20000];
	memset(arrMark, 0 , sizeof(arrMark));
	std::ofstream fout("d://b.txt");
	srand(time(nullptr));
	auto num1 = 0, num2 = 0;
	for (auto i = 0; i < 1000; ++i)
	{
		srand(rand());
		int iNum;
		do
		{
			iNum = ((1LL * rand() * rand() + rand() )% iRandMod);
		} while (arrMark[iNum]);
		arrMark[iNum] = true;
		fout << iNum;
		fout << ",";
		iNum & 1 ? ++num1 : ++num2;
	}
	printf("%d %d\n", num1, num2);
}

int main()
{
	writeSeedList();
	system("pause");
	return 0;
}