package tibia.chat.chatWidgetClasses
{
   import mx.collections.ArrayCollection;
   import mx.collections.IList;
   import mx.core.ClassFactory;
   import mx.core.EventPriority;
   import tibia.chat.Channel;
   import tibia.controls.DynamicTabBar;
   import tibia.controls.dynamicTabBarClasses.DynamicTab;
   
   public class ChannelTabBar extends DynamicTabBar
   {
       
      
      private var m_UncomittedSelectedIndex:Boolean = false;
      
      private var m_UncomittedScrollPosition:Boolean = false;
      
      public function ChannelTabBar()
      {
         super();
         addEventListener(ChannelEvent.HIGHLIGHT,this.onChannelHighlight,false,EventPriority.DEFAULT_HANDLER,false);
         addEventListener(ChannelEvent.DEHIGHLIGHT,this.onChannelHighlight,false,EventPriority.DEFAULT_HANDLER,false);
         navItemFactory = new ClassFactory(ChannelTab);
      }
      
      override protected function createNavItem(param1:Object) : DynamicTab
      {
         var _loc2_:ChannelTab = ChannelTab(super.createNavItem(param1));
         _loc2_.channel = param1 as Channel;
         return _loc2_;
      }
      
      private function updateNavItemHighlight(param1:ChannelTab) : void
      {
         if(param1 != null)
         {
            if(param1.highlight && getStyle("navItemHighlightStyle") !== undefined)
            {
               param1.styleName = getStyle("navItemHighlightStyle");
            }
            else
            {
               param1.styleName = getStyle("navItemStyle");
            }
         }
      }
      
      override protected function createDropDownMenu() : IList
      {
         var _loc4_:ChannelTab = null;
         var _loc5_:* = null;
         var _loc1_:IList = new ArrayCollection();
         var _loc2_:int = 0;
         var _loc3_:int = getDataProviderLength();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = ChannelTab(getChildAt(_loc2_));
            _loc5_ = _loc4_.label;
            if(_loc4_.highlight)
            {
               _loc5_ = _loc5_ + "*";
            }
            _loc1_.addItem({"label":_loc5_});
            _loc2_++;
         }
         return _loc1_;
      }
      
      override public function set selectedIndex(param1:int) : void
      {
         if(selectedIndex != param1)
         {
            super.selectedIndex = param1;
            this.m_UncomittedSelectedIndex = true;
            invalidateProperties();
         }
      }
      
      override protected function commitProperties() : void
      {
         var _loc1_:ChannelTab = null;
         super.commitProperties();
         if(this.m_UncomittedScrollPosition)
         {
            callLater(this.updateScrollButtonHighlights);
            this.m_UncomittedScrollPosition = false;
         }
         if(this.m_UncomittedSelectedIndex)
         {
            if(m_SelectedIndex > -1)
            {
               _loc1_ = ChannelTab(getChildAt(m_SelectedIndex));
               _loc1_.highlight = false;
               this.updateNavItemHighlight(_loc1_);
            }
            callLater(this.updateScrollButtonHighlights);
            this.m_UncomittedSelectedIndex = false;
         }
      }
      
      private function isHighlightInRange(param1:int, param2:int) : Boolean
      {
         while(param1 < param2)
         {
            if(ChannelTab(getChildAt(param1)).highlight)
            {
               return true;
            }
            param1++;
         }
         return false;
      }
      
      private function updateScrollButtonHighlights() : void
      {
         if(this.isHighlightInRange(0,getFirstVisibleIndex()) && getStyle("scrollLeftButtonHighlightStyle") !== undefined)
         {
            m_UILeftButton.styleName = getStyle("scrollLeftButtonHighlightStyle");
         }
         else
         {
            m_UILeftButton.styleName = getStyle("scrollLeftButtonStyle");
         }
         if(this.isHighlightInRange(getLastVisibleIndex(),getDataProviderLength()) && getStyle("scrollRightButtonHighlightStyle") !== undefined)
         {
            m_UIRightButton.styleName = getStyle("scrollRightButtonHighlightStyle");
         }
         else
         {
            m_UIRightButton.styleName = getStyle("scrollRightButtonStyle");
         }
      }
      
      protected function onChannelHighlight(param1:ChannelEvent) : void
      {
         var _loc2_:ChannelTab = null;
         var _loc3_:int = 0;
         if(param1 != null && (!param1.cancelable || !param1.isDefaultPrevented()))
         {
            _loc2_ = ChannelTab(param1.target);
            _loc3_ = getChildIndex(_loc2_);
            switch(param1.type)
            {
               case ChannelEvent.DEHIGHLIGHT:
                  this.updateNavItemHighlight(_loc2_);
                  this.updateScrollButtonHighlights();
                  break;
               case ChannelEvent.HIGHLIGHT:
                  if(m_SelectedIndex == _loc3_)
                  {
                     param1.preventDefault();
                  }
                  else
                  {
                     this.updateNavItemHighlight(_loc2_);
                     this.updateScrollButtonHighlights();
                  }
            }
         }
      }
      
      public function get selectedTab() : ChannelTab
      {
         if(selectedIndex > -1)
         {
            return getChildAt(m_SelectedIndex) as ChannelTab;
         }
         return null;
      }
      
      override public function set scrollPosition(param1:int) : void
      {
         if(scrollPosition != param1)
         {
            super.scrollPosition = param1;
            this.m_UncomittedScrollPosition = true;
            invalidateProperties();
         }
      }
      
      override protected function destroyNavItem(param1:int) : DynamicTab
      {
         var _loc2_:ChannelTab = ChannelTab(super.destroyNavItem(param1));
         _loc2_.channel = null;
         return _loc2_;
      }
   }
}
