
local stRoleInfo = {
 	--//简要信息，公众可见
	m_stRoleBrief = require("app.protocol.stRoleBrief"),
	--int32_t //钱
	m_iMoney = 0,
	--int32_t //游戏币
	m_iCoin = 0,		
	--int32_t //普通副本进度
	m_iCheese = 0,	
	--int16_t //精英副本数
	m_nCopyChapter = 0,		
	--int16_t 
	m_nCopyChapterIndex = 0,
	--int16_t 
	m_nEliteCopyCount = 0,
	--stCopyStatus [] //精英副本进度状态
	m_astEliteCopyStatus = {},
	--int16_t //副本星级
	m_nGameCopyStarCount = 0,
	--stGameCopyStar []
	m_astGameCopyStar = {},
	--int64_t 
	m_alEquipUID = {},
	--int16_t 
	m_nCardSkillCount = 0,
	--stCardSkill []
	m_astCardSkill = {},
	--int32_t //双倍经验过期时间
	m_iDoubleExpTime = 0,
	--int32_t //双倍掉落过期时间
	m_iDoubleDropTime = 0,
}

function stRoleInfo:decode(__ba)
	__ba:readShort()
	stRoleInfo.m_stRoleBrief.decode(nil, __ba)
end

return stRoleInfo