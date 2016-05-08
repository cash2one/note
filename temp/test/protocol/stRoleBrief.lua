
local stRoleBrief = {
	--int32_t 
	m_iUIN = 0,
	--int32_t //服
	m_iGroupID = 0,
	--int32_t //主角ID
	m_iSirdarID = 0,
	--char //角色名称
	m_szRoleName = "",
	--int64_t //经验值
	m_lExp = 0,	
	--int32_t //VIP积分
	m_iVIP = 0,
	--int32_t //pvp积分
	m_iPVPPoint = 0,
	--int32_t //pvp胜利次数
	m_iPVPWinCount = 0,
	--int32_t //pvp失败次数
	m_iPVPLoseCount = 0,
}

function stRoleBrief:decode(__ba)
	__ba:readShort()
	stRoleBrief.m_iUIN = __ba:readInt()
end


return stRoleBrief