
#include "LineTipsHandle.h"
USING_NS_CC;

namespace meishi
{
	BaseLineTipsData::BaseLineTipsData(std::string str, const cocos2d::Vec2& pos)
	{
		if(pos.equals(Vec2::ZERO))
		{
			auto origin = Director::getInstance()->getVisibleOrigin();
			auto size = Director::getInstance()->getVisibleSize();
			m_pos = origin + Vec2(size.width / 2, size.height / 2 - 50);
		}
		else
		{
			m_pos = pos;
		}
		m_str = str;
	}

	//===================================================================

	LineTipsHandle* LineTipsHandle::m_Instance = nullptr;

	LineTipsHandle* LineTipsHandle::getInstance()
	{
		if (nullptr == m_Instance)
		{
			m_Instance = LineTipsHandle::create();
			m_Instance->setPosition(Director::getInstance()->getVisibleOrigin());
			Director::getInstance()->setNotificationNode(m_Instance);
		}
		return m_Instance;
	}

	LineTipsHandle::LineTipsHandle()
	{
		m_bLineTextLock = false;
	}

	LineTipsHandle::~LineTipsHandle()
	{
		m_Instance = nullptr;
	}


	//===================================================================

	void LineTipsHandle::addLineTips(const char *cstr, const cocos2d::Vec2& pos)
	{
		if (cstr == nullptr) return;
		addLineTips(std::string(cstr), pos);
	}

	void LineTipsHandle::addLineTips(const std::string &str, const cocos2d::Vec2& pos)
	{
		m_vtLineTextCacheList.push_back(BaseLineTipsData(str, pos));
		if (!m_bLineTextLock)
		{
			nextLineTips();
		}
	}


	void LineTipsHandle::removeLineTips(cocos2d::Ref* target, cocos2d::Ref* text)
	{
		for (auto current = m_vtLineText.begin(); current != m_vtLineText.end(); ++current)
		{
			if(*current == text)
			{
				(*current)->removeFromParentAndCleanup(true);
				m_vtLineText.erase(current);
				break;
			}
		}
	}

	void LineTipsHandle::nextLineTips()
	{
		if (m_vtLineTextCacheList.size() == 0)
		{
			m_bLineTextLock = false;
			return;
		}
		m_bLineTextLock = true;
		showLineTips();
	}

	void LineTipsHandle::showLineTips()
	{
		auto str = m_vtLineTextCacheList[0];
		m_vtLineTextCacheList.erase(m_vtLineTextCacheList.begin());

		Label* text;
		if (m_vtLineText.size() >= 4)
		{
			text = m_vtLineText[0];
			text->stopAllActions();
			text->setString(str.m_str);
			text->setZOrder(-1);
			text->setZOrder(0);
			text->setOpacity(255);
			m_vtLineText.erase(m_vtLineText.begin());
		}
		else
		{
			text = Label::create(str.m_str, MS_FONT_ARIAL, 30);
			text->setColor(Color3B::GREEN);
			text->enableOutline(Color4B(0x0f, 0x0F, 0x0f, 0x9a), 1);
			text->setAnchorPoint(Vec2::ANCHOR_MIDDLE);
			this->addChild(text);
		}
		m_vtLineText.push_back(text);

		text->setPosition(str.m_pos);
		text->runAction(Sequence::create(
			MoveBy::create(0.2f, Vec2(0, 20)),
			CallFunc::create(CC_CALLBACK_0(LineTipsHandle::nextLineTips, this)),
			MoveBy::create(0.6f, Vec2(0, 70)),
			FadeOut::create(0.8f),
			CallFuncN::create(CC_CALLBACK_1(LineTipsHandle::removeLineTips, this, text)),
			NULL)
			);
		//Spawn::create();
	}
}

#endif
