
#ifndef __MS_LINE_TIPS_HANDEL__
#define __MS_LINE_TIPS_HANDEL__

#include <cocos2d.h>

namespace meishi
{
	struct BaseLineTipsData
	{
		BaseLineTipsData(std::string str, const cocos2d::Vec2& pos);
		std::string m_str;
		cocos2d::Vec2 m_pos;
	};

	class LineTipsHandle : public cocos2d::Layer
	{
	public:
		CREATE_FUNC(LineTipsHandle);
		static LineTipsHandle* getInstance();
		//添加单行浮动
		void addLineTips(const std::string &str, const cocos2d::Vec2& pos = cocos2d::Vec2::ZERO);
		void addLineTips(const char *str, const cocos2d::Vec2& pos = cocos2d::Vec2::ZERO);
	private:
		static LineTipsHandle* m_Instance;
		LineTipsHandle();
		~LineTipsHandle();

		std::vector<cocos2d::Label*> m_vtLineText;
		std::vector<BaseLineTipsData> m_vtLineTextCacheList;
		bool m_bLineTextLock;
		void showLineTips();
		void nextLineTips();
		void removeLineTips(cocos2d::Ref* target, cocos2d::Ref* text);
	};
};

#endif // __MS_LINE_TIPS_HANDEL__
#endif

