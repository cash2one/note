
--加载XML文件  -- （cocos中不建议使用，找不到文件时会错。 改用XMLMgr.load()，用FileUtil封装）
xfile = xml.load(filename)

--保存XML文件  -- （cocos中不建议使用。 改用XMLMgr.save()，用FileUtil封装）
xfile:save(filename)


--设置文件编码类型
xml.registerCode(decoded,encoded)

--解析XML字符串
xfile = xml.eval(xmlstring)

--创建一个新的XML对象
xfile = xml.new("root")

--添加一个子节点
child = xfile:append("child")

--设置或返回一个XML对象
child = xfile:tag(var, tag)

--以字符串形式返回XML
xml:str()   -- (indent = 空格数量, tag = 自定义首个节点名称)

--查找子节点
xml:find("child", attributeKey, attributeValue)



