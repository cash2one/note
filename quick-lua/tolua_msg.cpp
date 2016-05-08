


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
	//MyClass *o = (MyClass *)tolua_tousertype(L, 1, NULL);
	//if (o) tolua_pushusertype(L, Mtolua_new((CCSize)(o->getSize())), "CCSize");
	//return 1;
	
	//返给Lua值个数
	return 2;
}

//注册函数
lua_register(ls, "cpp_sendTest", cpp_sendTest);
//tolua_function(ls, "cpp_sendTest", cpp_sendTest);










