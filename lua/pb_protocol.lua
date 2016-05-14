
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



--------------------------------------------------------------
-- dump树形结构：
--------------------------------------------------------------

--打印pbf
function dumppb(msg)
    if msg == nil or msg.ListFields == nil then
        if dump ~= nil then dump(msg) end
        return
    end
	--require("descriptor") --protobuf宏文件
    local result = {}
    local function _dumppb(pb, idt)
        if type(pb) ~= "table" then
            return "<val> = " .. pb .. ","
        end
        idt = idt .. "   "
        local sidt = idt .. "   "
        for k,v in pb:ListFields() do
            if k.type == 11 then -- TYPE_MESSAGE
                if k.message_type ~= nil and k.message_type.name ~= nil then
                    result[#result + 1] = string.format("%s%s (%s) = {", idt, k.name, k.message_type.name)
                else
                    result[#result + 1] = string.format("%s%s (%s) = {", idt, k.name, type(v))
                end
                if (k.label == 3 or k.label == 1) and v[1] ~= nil then -- LABEL_REPEATED, LABEL_OPTIONAL
                    for _,spb in ipairs(v) do
                        result[#result + 1] = string.format("%s[ %d ] = {", sidt, _)
                        _dumppb(spb, sidt) 
                        result[#result + 1] = string.format("%s},", sidt)
                    end
                elseif k.label == 2 then -- LABEL_REQUIRED
                    _dumppb(v, idt)
                end
                result[#result + 1] = string.format("%s},", idt)
            else
                if (k.label == 3 or k.label == 1) and v[1] ~= nil then -- LABEL_REPEATED, LABEL_OPTIONAL
                    result[#result + 1] = string.format("%s%s = {", idt, k.name)
                    for _,spb in ipairs(v) do
                        result[#result + 1] = string.format("%s[ %d ] = %s,", sidt, _, spb)
                    end
                    result[#result + 1] = string.format("%s},", idt)
                elseif k.label == 2 then -- LABEL_REQUIRED
                    local vtype = type(v)
                    if vtype == "userdata" or vtype == "table" then v = vtype end
                    local str = string.format("%s", k.name)
                    result[#result + 1] = string.format("%s%-17s = %s,", idt, str, v)
                end
                -- --打印基本属性类型 （与上面一段代码重复）
                -- local vtype = "type: " .. k.type
                -- if k.type == 1 or k.type == 2 or k.type == 3 then  -- TYPE_DOUBLE, TYPE_FLOAT, TYPE_INT64
                --     vtype = "number"
                -- elseif k.type == 8 then -- TYPE_BOOL
                --     vtype = "boolean"
                -- elseif k.type == 5 or k.type == 12 or k.type == 13 or k.type == 14 then -- TYPE_INT32, TYPE_BYTES, TYPE_UINT32, TYPE_ENUM
                --     vtype = "int"
                -- elseif k.type == 9 then --TYPE_STRING
                --     vtype = "string"
                -- end
                -- if (k.label == 3 or k.label == 1) and v[1] ~= nil then -- LABEL_REPEATED, LABEL_OPTIONAL
                --     result[#result + 1] = string.format("%s%s = {", idt, k.name)
                --     for _,spb in ipairs(v) do
                --         result[#result + 1] = string.format("%s%s (%s) = {", idt, k.name, vtype)
                --     end
                --     result[#result + 1] = string.format("%s},", idt)
                -- elseif k.label == 2 then -- LABEL_REQUIRED
                --     local str = string.format("%s (%s)", k.name, vtype)
                --     result[#result + 1] = string.format("%s%-27s = %s,", idt, str, v)
                -- end
            end  
        end
    end
    local traceback = string.split(debug.traceback("", 2), "\n")
    print("dumpdp from: " .. string.trim(traceback[3]))
    _dumppb(msg, "- ")
    print ("- <val> = {")
    for i, line in ipairs(result) do
        print(line)
    end
    print ("- }")
end
