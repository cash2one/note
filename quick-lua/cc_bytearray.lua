
--------------------------------------------------------------
--  ByteArray 解析协议
--------------------------------------------------------------

-- 直接使用 lpack 库生成一个字节流
local __pack = string.pack("<bihP2", 0x59, 11, 1101, "", "中文")

-- 创建一个ByteArray
local __ba = require("framework.cc.utils.ByteArray").new("ENDIAN_BIG")

-- ByteArray 允许直接写入 lpack 生成的字节流
__ba:writeBuf(__pack)

-- 不要忘了，lua数组是1基的。而且函数名称比 position 短
__ba:setPos(1)

-- 这个用法和AS3相同了，只是有些函数名称被我改掉了
print("ba.len:", __ba:getLen())
print("ba.readByte:", __ba:readByte())   -- int_8
print("ba.readShort:", __ba:readShort())    --int_16
print("ba.readInt:", __ba:readInt()) --int_32
print("ba.readDouble:", __ba:readDouble())
print("ba.readFloat:", __ba:readFloat())
print("ba.readString:", __ba:readStringUShort())
print("ba.readBool:", __ba:readBool()) 
print("ba.available:", __ba:getAvailable())
-- 自带的toString方法可以以10进制、16进制、8进制打印
print("ba.toString(16):", __ba:toString(16))


--------------------------------------------------------------
--  ByteArray 编码协议
--------------------------------------------------------------

-- 创建一个新的ByteArray
local __ba2 = require("framework.cc.utils.ByteArray").new("ENDIAN_BIG")

-- 和AS3的用法相同，还支持链式调用
__ba2:writeByte(0x59)
    :writeInt(11)
    :writeShort(1101)
-- 写入空字符串
__ba2:writeStringUShort("")
-- 写入中文（UTF8）字符串
__ba2:writeStringUShort("中文")

-- 十进制输出
print("ba2.toString(10):", __ba2:toString(10))

