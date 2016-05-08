
local CResponseGetRoleInfo = {
 	-- int16_t
	m_nResultID = 0,
	-- stRoleInfo
	m_stInfo = require("app.protocol.stRoleInfo"),
}

function CResponseGetRoleInfo:decode(__ba)
	CResponseGetRoleInfo.m_nResultID = __ba:readShort()
	CResponseGetRoleInfo.m_stInfo.decode(nil, __ba)
end

return CResponseGetRoleInfo