
--------------------------------------------------------------
--  google protocol buffer 协议
--------------------------------------------------------------

require("server_item_message_body_pb") 

--自定义范例
local msg1 = server_item_message_body_pb.CPbCSRequestCardSkillUpgrade()  
msg1.m_iCardID = 100   
msg1.m_iPropsID = 3001     
dump(msg1)
      
--编码为二进制字符串
local pb_data = msg1:SerializeToString() 
print("create msg1:", msg1.m_iCardID, msg1.m_iPropsID)  
      
--从二进制字符串解析 
local msg2 = server_item_message_body_pb.CPbCSRequestCardSkillUpgrade()
msg2:ParseFromString(pb_data)   
print("parser: msg2", msg2.m_iCardID, msg2.m_iPropsID)
dump(msg2)


--------------------------------------------------------------
--  嵌套测试：
------  需要修复一个bug： 
------  https://github.com/seekagain/protoc-gen-lua/commit/c023f867224cda2a91711d841c2d60391f4487ba#
--------------------------------------------------------------

require("server_gamedb_message_body_pb")
local msg1 = server_gamedb_message_body_pb.CPbMsgNotifyUpdateDailyData()
msg1.m_stDailyUpdateData.m_iUpdateTime = 100
msg1.m_stDailyUpdateData.m_iOnlineAwardTime = 200
msg1.m_stDailyUpdateData.m_iLoginDays = 300
dump(msg1)

local pb_data = msg1:SerializeToString()
local msg2 = server_gamedb_message_body_pb.CPbMsgNotifyUpdateDailyData()
msg2:ParseFromString(pb_data)   
dump(msg2)



--------------------------------------------------------------
-- 其它API：
--------------------------------------------------------------
--message Test {
--    required int32 id = 1;
--    optional string name = 2;
--    repeated int32 ary = 3;
--    message Foo {
--        required int32 fid = 1;
--        required string fname = 2;
--    }
--    repeated Foo foos = 4;
--}

local test = pb.Test()

-- 获得序列化长度
print(test:ByteSize())

-- 内置类型的repeated使用append()
test.ary:append(1)
test.ary:append(2)

-- 复合类型的repeated使用add()
local foo1 = pb.foos:add()
foo1.fid = 1
foo1.fname = "foo1"
local foo2 = pb.foos:add()
foo2.fid = 2
foo2.fname = "foo2"
