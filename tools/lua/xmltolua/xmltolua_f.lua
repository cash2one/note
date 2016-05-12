function strippath(filename)
    return string.match(filename, ".+[/\\]([^/\\]*%.%w+)$")
end

function stripextension(filename)
    local idx = filename:match(".+()%.%w+$")
    if(idx) then
        return filename:sub(1, idx-1)
    else
    return filename
    end
end

function print_r ( t , arrt)
    local table_string = ""
    local print_r_cache={}
    local function sub_print_r(t, indent, arrt)
        if (print_r_cache[tostring(t)]) then
            --print(indent.."*"..tostring(t))
            table_string = table_string .. indent.."*"..tostring(t)
        else
            print_r_cache[tostring(t)]=true
            if (type(t)=="table") then
                for pos,val in pairs(t) do
                    if (type(val)=="table") then
                        local bIsArr = nil
                        local nextNode = arrt
                        if (type(pos) == "string") then
                            --print(indent.."[".."\""..pos.."\"".."] = ".." {")
                            --table_string = table_string .. indent.."[".."\""..pos.."\"".."] = ".." {" .."\n"
                            table_string = table_string .. indent..pos.." = ".." {" .."\n"
                            if (arrt ~= nil) then 
                                nextNode = arrt[pos]
                                if (nextNode ~= nil) and (val[1] == nil) then
                                    bIsArr = nextNode.isArr 
                                end
                            end
                            if bIsArr ~= nil then  
                                local tempIndent  = indent..string.rep(" ",string.len(pos)+6)
                                table_string = table_string .. tempIndent.." [1] = ".." {".."\n"
                                sub_print_r(val, tempIndent..string.rep(" ",string.len(pos)+4), nextNode)
                                --print(tempIndent..string.rep(" ",string.len(pos)+6).."}")
                                table_string = table_string .. tempIndent..string.rep(" ",string.len(pos)+4).."}"..",\n"
                                table_string = table_string .. indent..string.rep(" ",string.len(pos)+4).."}"..",\n"
                            end
                        elseif(type(pos) == "number") then
                            --print(indent.."["..pos.."] = ".." {")
                            table_string = table_string .. indent.."["..pos.."] = ".."{".."\n"
                        end
                        if bIsArr == nil then  
                            sub_print_r(val,indent..string.rep(" ",string.len(pos)+5), nextNode)
                            --print(indent..string.rep(" ",string.len(pos)+6).."}")
                            table_string = table_string .. indent..string.rep(" ",string.len(pos)+5).."}"..",\n"
                        end
                    --elseif (type(val)=="string") then
                    elseif not string.match(string.sub(val,1,-1),"^%d+$") and not string.match(string.sub(val,1,-1),"^0x")  then
                        if (type(pos)=="string") then
                            --print(indent.."[".."\""..pos.."\""..'] = "'..val..'"')
                            --table_string = table_string .. indent.."[".."\""..pos.."\""..'] = "'..val..'"'..",\n"
                            table_string = table_string .. indent..pos..' = "'..val..'"'..",\n"
                        elseif (type(pos)=="number") then
                            --print(indent.."["..pos..'] = "'..val..'"')
                            table_string = table_string .. indent.."["..pos..'] = "'..val..'"'..",\n"
                        end
                    else
                        --print(indent.."[".."\""..pos.."\"".."] = "..tostring(val))
                        --table_string = table_string .. indent.."[".."\""..pos.."\"".."] = "..val..",\n"
                        table_string = table_string .. indent..pos.." = "..val..",\n"
                    end
                end
            else
                --print(indent..tostring(t))
                table_string = table_string .. indent..tostring(t).."\n"
            end
        end
    end
    if (type(t)=="table") then
        --print(" {")
        table_string = table_string .. " {".."\n"
        sub_print_r(t,"    ", arrt)
        --print("}")
        table_string = table_string .. "}".."\n"
    else
        sub_print_r(t,"    ", arrt)
    end
    --print()
    return table_string
end

local xml = require("xml2lua")

local xml_file = arg[1]

local table_name = stripextension(strippath(xml_file))

local xml_table = xml.loadFile(xml_file,base)

--print(activity_xml_table["map"][1]["drop"][1]["m_iMouseID"])

local format_table = require("xmltolua_format")

local table_string = print_r(xml_table, format_table[table_name]) 

print("local " .. table_name .. " = " .. table_string .. "\n" .. "return " .. table_name)
