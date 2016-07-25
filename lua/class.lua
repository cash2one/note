

--------------------------------------------------------------
--------------------------------------------------------------
--  lua面向对象测试
--------------------------------------------------------------
--------------------------------------------------------------


--------------------------------------------------------------
-- 方法调用规则
--------------------------------------------------------------

local saa = {
	x = 0, 
	y = 0
}
local sbb = {
	x = 0, 
	y = 0
}
function saa:init()
	x = 0
	y = 0
end

--------------------------------------
-- 使用:连接符，使用:调用
-- 传入2个参数，获得2个参数
-- 可以使用self
function saa:f1(xx, yy)
	self.x = xx
	saa.y = yy
end
saa:init()
saa:f1(1, 2)
dump(saa)     --结果为1，2

--------------------------------------
-- 使用:连接符，使用.调用
-- 传入3个参数，获得2个参数
-- 传入的第1个参数将作为self
function saa:f2(xx, yy)  
	self.x = xx  -- 当传入的第1个参数为nil时报错
	saa.y = yy
end
saa:init()
saa.f2(sbb, 3, 4) 
dump(saa)     --结果为0，4
dump(sbb)     --结果为3，0

--------------------------------------
-- 使用.连接符， 使用.调用
-- 传入2个参数，获得2个参数
-- 无法使用self
function saa.f3(xx, yy)  
	saa.x = xx
	saa.y = yy
end
saa:init()
saa.f3(5, 6)
dump(saa)     --结果为5，6

--------------------------------------
-- 使用.连接符， 使用:调用
-- 传入2个参数，获得3个参数
-- 获得的第1个参数为调用者本身，可当作self使用
function saa.f4(self, xx, yy)
	self.x = xx
	saa.y = yy
end
saa:init()
saa:f4(7, 8)
dump(saa)     --结果为7，8



--------------------------------------------------------------
-- 类的继承和派生
--------------------------------------------------------------


local Str = {
	str="ss ww",
	num=0
}  

function Str:new(s)  
    s = s or {}  
    --为对象绑定metatable为Str  
    setmetatable(s, {__index=self})  
    return s  
end  
      
function Str:count()  
	-- 计算单词数量
    for w in string.gmatch(self.str, "%w+")  do  
        self.num = self.num + 1  
    end  
end

function Str:initCount()
	-- 函数重载测试
    self.num = 80
end

function Str:getSelf()
	--被Driver继承后返回的是Driver的self
    return self
end
  
--这就相当于是继承下来,之后调用Driver的函数时,self都是Driver  
local Driver = Str:new() 

function Driver:initCount()  
	-- 直接新建一个num成员在Driver表中， 而Str表中的num仍然存在
	-- 重写Str表中的initCount()方法
    self.num = 40
end  

function Driver:print()  
    print(string.format("Driver print: str = '%s' , num = '%d'", self.str, self.num))  
end  

local obj1 = Str:new()    
obj1.str = "a,b,c,213 h w = af da"
obj1:count()  
print(string.format("obj1: str = '%s' , num = '%d'", obj1.str, obj1.num))  
  
--obj1的成员数据不会影响后续对象,也不会影响Str的数据变动  
local obj2 = Str:new()  
print(string.format("obj2: str = '%s' , num = '%d'", obj2.str, obj2.num))  
print(string.format("Str: str = '%s' , num = '%d'", Str.str, Str.num))  
  
--从Driver创建对象,相当于派生类  
local obj3 = Driver:new({msg = "obj3 base is driver"})  
obj3:initCount()  
obj3:print()
--dump(obj3)
--dump(obj3:getSelf())  --子类的self
--dump(obj3.super:getSelf())  --父类的self
print(string.format("obj3: str = '%s' , num = '%d' , msg = '%s'",obj3.str, obj3.num, obj3.msg))  

--从obj1创建对象 
local obj4 = obj1:new({name = "obj3 base is driver"})  
print(string.format("obj4: str = '%s' , num = '%d'", obj4.str, obj4.num))  




