

//--------------------------------------------------------------
//-- 基本Lua栈操作
//--------------------------------------------------------------

//往栈里面压入一个值
void lua_pushnil      (lua_State *L);
void lua_pushboolean  (lua_State *L, int bool);
void lua_pushnumber   (lua_State *L, lua_Number n);
void lua_pushinteger  (lua_State *L, lua_Integer n);
void lua_pushunsigned (lua_State *L, lua_Unsigned n);
void lua_pushlstring  (lua_State *L, const char *s, size_t len);
void lua_pushstring   (lua_State *L, const char *s);


//查询栈里面的元素（这里面的*可以是boolean,nil,string,function等等）
int lua_is* (lua_State * L, int index)

//获取栈内给定位置的元素值（这里面的xxx可以是nil, boolean, string, integer等等）
xxx lua_toXXX ( lua_State * L , int index ) ;

//取得栈中元素个数
int lua_gettop (lua_State *L);

//设置栈的大小为一个指定的值，而lua_settop(L,0)会把当前栈清空
//如果指定的index大于之前栈的大小，那么空余的空间会被nil填充
//如果index小于之前的栈中元素个数，则多余的元素会被丢弃
void lua_settop (lua_State *L, int index);

//把栈中index所在位置的元素压入栈
void lua_pushvalue (lua_State *L, int index);

//移除栈中index所在位置的元素
void lua_remove (lua_State *L, int index);

//在栈的顶部的元素移动至index处
void lua_insert (lua_State *L, int index);

//从栈顶弹出一个值，并把它设置到给定的index处
void lua_replace (lua_State *L, int index);

//把fromidx处的元素copy一份插入到toidx，这操作不会修改fromidx处的元素
void lua_copy (lua_State *L, int fromidx, int toidx);


lua_pop(L, 1);

//创建table，并且添加元素
lua_newtable(L);
// index
for (int i = 1; i <= 10; ++i)
{
	lua_pushstring(L, value);
	lua_rawseti(L, -2, i);
}
// key
for (int i = 1; i <= 10; ++i)
{
	lua_pushstring(L, szKey);
	lua_pushstring(L, value);
	lua_rawset(L, -3);
}
//另一种方式添加table元素
lua_pushstring(L, szResource);
lua_setfield(L, -2, szKey);

//下面这个还不清楚
//lua_settable(L, -2)


//--------------------------------------------------------------
//-- cpp直接调用lua的全局函数
//--------------------------------------------------------------

void LuaMsgMgr::sendServerMsgCppToLua(int iMsgID, const char *szMsg, const int &iLength)
{
	auto stack = LuaEngine::defaultEngine()->getLuaStack();
	auto ls = stack->getLuaState();
	if (ls)
	{
		lua_getglobal(ls, "lua_receiveServerMsg");
		lua_pushinteger(ls, iMsgID);
		lua_pushlstring(ls, szMsg, iLength);
		lua_pushinteger(ls, iLength);
		lua_call(ls, 2, 0);
		// 若是cocos2d引擎，可以使用下面这个函数代替lua_call，使得报错时可以显示堆栈
		// stack->executeFunction(3);
	}
}



//--------------------------------------------------------------
//-- 注册cpp函数到lua全局变量中，可在lua直接调用此函数
//--------------------------------------------------------------

//以下是由lua调用
int cpp_sendTest(lua_State* L)
{
	//函数参数（L， 获取第i个参数）
	auto luaNum = lua_tointeger(L, 1);
	auto luaStr = lua_tostring(L, 2);

	//返给Lua的值
	lua_pushnumber(L, 321);
	lua_pushstring(L, "Himi");

	//传递自定义函数
	//MyClass *o = (MyClass *)tolua_tousertype(L, 1, NULL); --未测试
	//if (o) tolua_pushusertype(L, Mtolua_new((CCSize)(o->getSize())), "CCSize"); --未测试
	//tolua_pushusertype(L, scene, "cc.Scene");  --测试成功
	//return 1;
	
	//返给Lua值个数
	return 2;
}

//注册全局的函数
lua_register(ls, "cpp_test", cpp_test);
//tolua_function(ls, "cpp_test", cpp_test);


//也可以新建一个全局的table，将函数作为table的成员
lua_newtable(ls);
lua_pushcfunction(ls, cpp_test);
lua_setfield(ls, -2, "cpp_test");
lua_setglobal(ls, "mscpp");


//--------------------------------------------------------------
//-- 读取table的值
//--------------------------------------------------------------

/*
local s = {
	a = "2",
	b = "sd",
	c = "asd",
	d = {
		e = "3",
		f = "cc",
		g = "eee",
	}
}
cpp_testFunction(s);
*/
void printIndexValue(lua_State *L, int index)
{
	auto t = lua_type(L, index);
	switch (t)
	{
	case LUA_TSTRING:	CCLOG("'%s' ", lua_tostring(L, index)); break;
	case LUA_TBOOLEAN:	CCLOG(lua_toboolean(L, index) ? "true " : "false "); break;
	case LUA_TNUMBER:	CCLOG("%f ", lua_tonumber(L, index)); break;
		//case LUA_TTABLE:	CCLOG()
	default:			CCLOG("%s ", lua_typename(L, index));
	}
}

void selectTable(lua_State *L, const char* szItemName)
{
	lua_pushstring(L, szItemName);
	lua_gettable(L, -2);
}

void unSelectTable(lua_State *L)
{
	lua_remove(L, -1);
}

void readFromItem(lua_State *L, const char* szItemName)
{
	lua_pushstring(L, szItemName);
	lua_gettable(L, -2);
	printIndexValue(L, -1);
	lua_remove(L, -1);
}

void readFromIndex(lua_State *L, int index)
{
	lua_rawgeti(L, -1, index);
	printIndexValue(L, -1);
	lua_remove(L, -1);
}


int cpp_testFunction(lua_State *L)
{
	readFromItem(L, "a");
	readFromItem(L, "b");
	readFromItem(L, "c");
	selectTable(L, "d");
	readFromItem(L, "e");
	readFromItem(L, "f");
	readFromItem(L, "g");
	readFromItem(L, "k");
	unSelectTable(L);
	return 0;
}




//--------------------------------------------------------------
//-- 遍历table
//---- 测试失败
//--------------------------------------------------------------

/*
lua文件 
user = {
        ["name"] = "zhangsan",
        ["age"] = "22",
        ["friend"] = {
                [1] = {
                    ["name"] = "小丽",
                    ["sex"] = "女",
                    ["age"] = "20",
                },
                [2] = {
                    ["name"] = "小罗",
                    ["sex"] = "男",
                    ["age"] = "20",
                },
            },
        }
*/

bool popTable(lua_State* L, int space)
{
	auto idx = lua_gettop(L);
	try{
		lua_pushnil(L);
		while (lua_next(L, idx) != 0){
			int keyType = lua_type(L, -2);
			if (keyType == LUA_TNUMBER)			CCLOG("Key: %f", lua_tonumber(L, -2));
			else if (keyType == LUA_TSTRING)	CCLOG("Key: %s", lua_tostring(L, -2));
			else
			{
				CCLOG("Invalid key type: %d", keyType);
				return false;
			}
			auto valueType = lua_type(L, -1);
			switch (valueType){
			case LUA_TNIL:		CCLOG("Value: nil", keyType); break;
			case LUA_TBOOLEAN:	CCLOG("Value: %s", lua_toboolean(L, -1) ? "true" : "false"); break;
			case LUA_TNUMBER:	CCLOG("Value: %f", lua_tonumber(L, -1)); break;
			case LUA_TSTRING:	CCLOG("Value: %s", lua_tostring(L, -1)); break;
			case LUA_TTABLE:
			{
							   CCLOG("====sub table %d===", space);
							   if (!popTable(L, space + 1))
							   {
								   CCLOG("popTable error in  popTable,error occured");
								   return false;
							   }
			}break;
			default:
			{
					   CCLOG("Invalid value type: %d", valueType);
					   return false;
			}
			}
			lua_pop(L, 1);
		}
	}
	catch (const char* s){
		CCLOG("%s", s);
		lua_pop(L, 1);
		return false;
	}
	catch (std::exception& e){
		CCLOG("%s", e.what());
		lua_pop(L, 1);
		return false;
	}
	catch (...){
		CCLOG("%s", lua_tostring(L, -1));
		lua_pop(L, 1);
		return false;
	}
	return true;
}

bool dumpTable(lua_State *L)
{
	auto type = lua_type(L, 1);
	if (type == LUA_TTABLE)
	{
		if (popTable(L, 0))
		{
			CCLOG("Success");
			return true;
		}
		CCLOG("Error");
		return false;
	}
	CCLOG("Error: not a table");
	return false;
}






//-----------未整理1

//ReadLuaTable.lua
//luat_Test1={a=123, b=456, c=789}
//luat_Test2={123, 456, 789}



#include <lua.hpp>

static void ReadTableFromItem(lua_State *L, const char* lpszTableName, const char* lpszTableItem)
{
    lua_getglobal(L, lpszTableName);
    
    lua_pushstring(L, lpszTableItem);
    lua_gettable(L, -2);
    printf("%s.%s=%d\n", lpszTableName, lpszTableItem, (int)lua_tonumber(L, -1));
    lua_pop(L, 2);
}

static void ReadTableFromIndex(lua_State *L, const char* lpszTableName, int index)
{
    lua_getglobal(L, lpszTableName);
    lua_rawgeti(L, -1, index);
    printf("%s[%d]=%d\n", lpszTableName, index, (int)lua_tonumber(L, -1));
    lua_pop(L, 2);
}

static void EnumTableItem(lua_State *L, const char* lpszTableName)
{
    lua_getglobal(L, lpszTableName);
    int it = lua_gettop(L);
    lua_pushnil(L);
    printf("Enum %s:", lpszTableName);
    while(lua_next(L, it))
    {
        printf("  %d", (int)lua_tonumber(L, -1));
        lua_pop(L, 1);
    }
    printf("\n");
    lua_pop(L, 1);
}

int main (int argc, char* argv[])
{
    lua_State *L = lua_open();
    luaopen_base(L);
    
    luaL_dofile(L, "LuaTable.lua");
    ReadTableFromItem(L, "luat_Test1", "a");  // 等价与lua代码：print(luat_Test1.a)
    ReadTableFromItem(L, "luat_Test1", "b");
    ReadTableFromItem(L, "luat_Test1", "c");
    EnumTableItem(L, "luat_Test1");    // 枚举Table
    
    ReadTableFromIndex(L, "luat_Test2", 1);  // 等价与lua代码：print(luat_Test1[1])
    ReadTableFromIndex(L, "luat_Test2", 2);
    ReadTableFromIndex(L, "luat_Test2", 3);
    EnumTableItem(L, "luat_Test2");
    lua_close(L);
    return 0;
}







//-----------未整理


//从Lua里面取得me这个table，并压入栈
lua_getglobal(L, "me");
if (!lua_istable(L, -1)) {
    CCLOG("error! me is not a table");
}
//往栈里面压入一个key:name
lua_pushstring(L, "name");
//取得-2位置的table，然后把栈顶元素弹出，取出table[name]的值并压入栈
lua_gettable(L, -2);
//输出栈顶的name
CCLOG("name = %s", lua_tostring(L, -1));
stackDump(L);
//把栈顶元素弹出去
lua_pop(L, 1);
//压入另一个key:age
lua_pushstring(L, "age");
//取出-2位置的table,把table[age]的值压入栈
lua_gettable(L, -2);
stackDump(L);
CCLOG("age = %td", lua_tointeger(L, -1));



Lua5.1还引入了一个新方法：

lua_getfield(L, -1, "age");


它可以取代

//压入另一个key:age
lua_pushstring(L, "age");
//取出-2位置的table,把table[age]的值压入栈
lua_gettable(L, -2);



//-----------未整理

	void dumpLuaTable(lua_State *L)
	{
		CCLOG("{");
		auto top = lua_gettop(L);
		for (auto i = 1; i <= top; ++i) {
			auto t = lua_type(L, i);
			switch (t)
			{
			case LUA_TSTRING:	CCLOG("'%s' ", lua_tostring(L, i)); break;
			case LUA_TBOOLEAN:	CCLOG(lua_toboolean(L, i) ? "true " : "false "); break;
			case LUA_TNUMBER:	CCLOG("%f ", lua_tonumber(L, i)); break;
			//case LUA_TTABLE:	CCLOG()
			default:			CCLOG("%s ", lua_typename(L, t));
			}
		}
		CCLOG("}");
	}


//luat_Test1={a=123, b=456, c=789}
//luat_Test2={123, 456, 789}


static void WriteTableFromKey(lua_State *L, const char* lpszTableName, const char* lpszTableItem, int nVal)
{
	lua_getglobal(L, lpszTableName);
	lua_pushnumber(L, nVal);
	lua_setfield(L, -2, lpszTableItem);
	lua_pop(L, 1);
}

static void WriteTableFromIndex(lua_State *L, const char* lpszTableName, int index, int nVal)
{
	lua_getglobal(L, lpszTableName);
	lua_pushnumber(L, nVal);
	lua_rawseti(L, -2, index);
	lua_pop(L, 1);
}

static void ReadTableFromKey(lua_State *L, const char* lpszTableName, const char* lpszTableItem)
{
	lua_getglobal(L, lpszTableName);

	lua_pushstring(L, lpszTableItem);
	lua_gettable(L, -2);
	printf("%s.%s=%d\n", lpszTableName, lpszTableItem, (int)lua_tonumber(L, -1));
	lua_pop(L, 2);
}

static void ReadTableFromIndex(lua_State *L, const char* lpszTableName, int index)
{
	lua_getglobal(L, lpszTableName);
	lua_rawgeti(L, -1, index);
	printf("%s[%d]=%d\n", lpszTableName, index, (int)lua_tonumber(L, -1));
	lua_pop(L, 2);
}

int main(int argc, char* argv[])
{
	lua_State *L = lua_open();
	luaopen_base(L);

	luaL_dofile(L, "WriteLuaTable.lua");

	ReadTableFromKey(L, "luat_Test1", "a");
	ReadTableFromKey(L, "luat_Test1", "b");
	ReadTableFromKey(L, "luat_Test1", "c");
	puts("\n");
	WriteTableFromKey(L, "luat_Test1", "a", 147); // luat_Test1['a'] = 147
	WriteTableFromKey(L, "luat_Test1", "b", 258); // luat_Test1['b'] = 258
	WriteTableFromKey(L, "luat_Test1", "c", 369); // luat_Test1['c'] = 369
	WriteTableFromKey(L, "luat_Test1", "d", 159); // luat_Test1['d'] = 159
	ReadTableFromKey(L, "luat_Test1", "a");
	ReadTableFromKey(L, "luat_Test1", "b");
	ReadTableFromKey(L, "luat_Test1", "c");
	ReadTableFromKey(L, "luat_Test1", "d");
	puts("\n--------------------------");
	ReadTableFromIndex(L, "luat_Test2", 1);
	ReadTableFromIndex(L, "luat_Test2", 2);
	ReadTableFromIndex(L, "luat_Test2", 3);
	puts("\n");
	WriteTableFromIndex(L, "luat_Test2", 1, 147); // luat_Test2[1] = 147
	WriteTableFromIndex(L, "luat_Test2", 2, 258); // luat_Test2[2] = 258
	WriteTableFromIndex(L, "luat_Test2", 3, 369); // luat_Test2[3] = 369
	WriteTableFromIndex(L, "luat_Test2", 4, 159); // luat_Test2[4] = 159
	ReadTableFromIndex(L, "luat_Test2", 1);
	ReadTableFromIndex(L, "luat_Test2", 2);
	ReadTableFromIndex(L, "luat_Test2", 3);
	ReadTableFromIndex(L, "luat_Test2", 4);
	lua_close(L);
	return 0;
}
