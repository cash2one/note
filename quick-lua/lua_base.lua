

--------------------------------------------------------------
--------------------------------------------------------------
--  基础
--------------------------------------------------------------
--------------------------------------------------------------

--  根据变量名称，从“全局table”中获取全局变量
cc = {}
local globalPara = _G["cc"]


--------------------------------------------------------------
--------------------------------------------------------------
--  os方法
--------------------------------------------------------------
--------------------------------------------------------------

--  当前系统时间
local iTime = os.time()





--------------------------------------------------------------
--------------------------------------------------------------
--  math方法
--------------------------------------------------------------
--------------------------------------------------------------

-- 获取table长度
local stSample = {"a","b","c"}
local iSampleSize = table.getn(stSample)




--------------------------------------------------------------
--------------------------------------------------------------
--  math方法
--------------------------------------------------------------
--------------------------------------------------------------

--  设置随机种子
math.randomseed(os.time()) 

--  获取0-1之间的浮点数
local fRand = math.random() 

--  获取1-n之间的整数
local iRand = math.random(n) 

--  获取n-m之间的整数
local iRand = math.random(n,m) 












--未整理


table.concat(table, sep,  start, end)

concat是concatenate(连锁, 连接)的缩写. table.concat()函数列出参数中指定table的数组部分从start位置到end位置的所有元素, 元素间以指定的分隔符(sep)隔开。除了table外, 其他的参数都不是必须的, 分隔符的默认值是空字符, start的默认值是1, end的默认值是数组部分的总长.

sep, start, end这三个参数是顺序读入的, 所以虽然它们都不是必须参数, 但如果要指定靠后的参数, 必须同时指定前面的参数.

> tbl = {"alpha", "beta", "gamma"}
> print(table.concat(tbl, ":"))
alpha:beta:gamma
> print(table.concat(tbl, nil, 1, 2))
alphabeta
> print(table.concat(tbl, "\n", 2, 3))
beta
gamma

table.insert(table, pos, value)

table.insert()函数在table的数组部分指定位置(pos)插入值为value的一个元素. pos参数可选, 默认为数组部分末尾.

> tbl = {"alpha", "beta", "gamma"}
> table.insert(tbl, "delta")
> table.insert(tbl, "epsilon")
> print(table.concat(tbl, ", ")
alpha, beta, gamma, delta, epsilon
> table.insert(tbl, 3, "zeta")
> print(table.concat(tbl, ", ")
alpha, beta, zeta, gamma, delta, epsilon


table.maxn(table)

table.maxn()函数返回指定table中所有正数key值中最大的key值. 如果不存在key值为正数的元素, 则返回0. 此函数不限于table的数组部分.

> tbl = {[1] = "a", [2] = "b", [3] = "c", [26] = "z"}
> print(#tbl)
3               -- 因为26和之前的数字不连续, 所以不算在数组部分内
> print(table.maxn(tbl))
26
> tbl[91.32] = true
> print(table.maxn(tbl))
91.32


table.remove(table, pos)

table.remove()函数删除并返回table数组部分位于pos位置的元素. 其后的元素会被前移. pos参数可选, 默认为table长度, 即从最后一个元素删起.


table.sort(table, comp)

table.sort()函数对给定的table进行升序排序.

> tbl = {"alpha", "beta", "gamma", "delta"}
> table.sort(tbl)
> print(table.concat(tbl, ", "))
alpha, beta, delta, gamma

comp是一个可选的参数, 此参数是一个外部函数, 可以用来自定义sort函数的排序标准.

此函数应满足以下条件: 接受两个参数(依次为a, b), 并返回一个布尔型的值, 当a应该排在b前面时, 返回true, 反之返回false.

例如, 当我们需要降序排序时, 可以这样写:

> sortFunc = function(a, b) return b < a end
> table.sort(tbl, sortFunc)
> print(table.concat(tbl, ", "))
gamma, delta, beta, alpha

用类似的原理还可以写出更加复杂的排序函数. 例如, 有一个table存有工会三名成员的姓名及等级信息:

guild = {}

table.insert(guild, {
　name = "Cladhaire",
　class = "Rogue",
　level = 70,
})

table.insert(guild, {
　name = "Sagart",
　class = "Priest",
　level = 70,
})

table.insert(guild, {
　name = "Mallaithe",
　class = "Warlock",
　level = 40,
})


对这个table进行排序时, 应用以下的规则: 按等级升序排序, 在等级相同时, 按姓名升序排序.

可以写出这样的排序函数:

function sortLevelNameAsc(a, b)
　if a.level == b.level then
　　return a.name < b.name
　else
　　return a.level < b.level
　end
end

测试功能如下:

> table.sort(guild, sortLevelNameAsc)
> for idx, value in ipairs(guild) do print(idx, value.name) end
1, Mallaithe
2, Cladhaire
3, Sagart

table.foreachi(table, function(i, v))
会期望一个从 1（数字 1）开始的连续整数范围，遍历table中的key和value逐对进行function(i, v)操作

t1 = {2, 4, 6, language="Lua", version="5", 8, 10, 12, web="hello lua"};
table.foreachi(t1, function(i, v) print (i, v) end) ; --等价于foreachi(t1, print)

输出结果：
1 2
2 4
3 6
4 8
5 10
6 12

table.foreach(table, function(i, v))
与foreachi不同的是，foreach会对整个表进行迭代

t1 = {2, 4, 6, language="Lua", version="5", 8, 10, 12, web="hello lua"};
table.foreach(t1, function(i, v) print (i, v) end) ;

输出结果：
1 2
2 4
3 6
4 8
5 10
6 12
web hello lua
language Lua
version 5

table.getn(table)
返回table中元素的个数

t1 = {1, 2, 3, 5};
print(getn(t1))
->4

table.setn(table, nSize)
设置table中的元素个数