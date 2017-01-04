package tibia.chat.chatWidgetClasses
{
   import flash.events.MouseEvent;
   import mx.events.CollectionEvent;
   import mx.events.CollectionEventKind;
   import mx.events.PropertyChangeEvent;
   import tibia.chat.Channel;
   import tibia.controls.DynamicTabBar;
   import tibia.controls.dynamicTabBarClasses.DynamicTab;
   
   public class ChannelTab extends DynamicTab
   {
       
      
      protected var m_Highlight:Boolean = true;
      
      protected var m_Channel:Channel = null;
      
      private var m_UncommittedChannel:Boolean = false;
      
      private var m_UncomittedHighlight:Boolean = false;
      
      public function ChannelTab()
      {
         super();
         addEventListener(MouseEvent.RIGHT_CLICK,this.onTabClick);
      }
      
      protected function onChannelProperty(param1:PropertyChangeEvent) : void
      {
         if(param1 != null)
         {
            switch(param1.property)
            {
               case "closable":
                  closePolicy = this.m_Channel != null && this.m_Channel.closable?int(DynamicTabBar.CLOSE_SELECTED):int(DynamicTabBar.CLOSE_NEVER);
            }
         }
      }
      
      public function get channel() : Channel
      {
         return this.m_Channel;
      }
      
      protected function onChannelMessage(param1:CollectionEvent) : void
      {
         if(param1 != null && param1.kind == CollectionEventKind.ADD)
         {
            this.highlight = true;
         }
      }
      
      public function set channel(param1:Channel) : void
      {
         if(this.m_Channel != param1)
         {
            if(this.m_Channel != null)
            {
               this.m_Channel.removeEventListener(CollectionEvent.COLLECTION_CHANGE,this.onChannelMessage);
               this.m_Channel.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onChannelProperty);
            }
            this.m_Channel = param1;
            this.m_UncommittedChannel = true;
            invalidateProperties();
            if(this.m_Channel != null)
            {
               this.m_Channel.addEventListener(CollectionEvent.COLLECTION_CHANGE,this.onChannelMessage,false,int.MIN_VALUE,false);
               this.m_Channel.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onChannelProperty,false,int.MIN_VALUE,false);
            }
         }
      }
      
      public function set highlight(param1:Boolean) : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:ChannelEvent = null;
         if(this.m_Highlight != param1)
         {
            _loc2_ = this.m_Highlight;
            this.m_Highlight = param1;
            this.m_UncomittedHighlight = true;
            invalidateProperties();
            _loc3_ = new ChannelEvent(!!param1?ChannelEvent.HIGHLIGHT:ChannelEvent.DEHIGHLIGHT);
            _loc3_.channel = this.m_Channel;
            dispatchEvent(_loc3_);
            if(!_loc3_.cancelable || !_loc3_.isDefaultPrevented())
            {
               this.m_Highlight = param1;
            }
            else
            {
               this.m_Highlight = _loc2_;
            }
         }
      }
      
      override public function styleChanged(param1:String) : void
      {
         switch(param1)
         {
            case "highlightTextColor":
               this.updateTextColor();
               break;
            default:
               super.styleChanged(param1);
         }
      }
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
         if(this.m_UncommittedChannel)
         {
            closePolicy = this.m_Channel != null && this.m_Channel.closable?int(DynamicTabBar.CLOSE_SELECTED):int(DynamicTabBar.CLOSE_NEVER);
            this.highlight = false;
            this.m_UncommittedChannel = false;
         }
         if(this.m_UncomittedHighlight)
         {
            this.updateTextColor();
            this.m_UncomittedHighlight = false;
         }
      }
      
      override protected function updateTextColor() : void
      {
         var _loc1_:* = undefined;
         if(this.m_Highlight)
         {
            _loc1_ = getStyle("highlightTextColor");
            setStyle("color",_loc1_);
            setStyle("errorColor",_loc1_);
            setStyle("textRollOverColor",_loc1_);
            setStyle("textSelectedColor",_loc1_);
         }
         else
         {
            super.updateTextColor();
         }
      }
      
      public function forceHighlight() : void
      {
         this.m_Highlight = true;
         this.m_UncomittedHighlight = true;
         invalidateProperties();
      }
      
      public function get highlight() : Boolean
      {
         return this.m_Highlight;
      }
      
      protected function onTabClick(param1:MouseEvent) : void
      {
         var _loc2_:ChannelEvent = null;
         if(param1 != null)
         {
            _loc2_ = new ChannelEvent(ChannelEvent.TAB_CONTEXT_MENU);
            _loc2_.channel = this.m_Channel;
            dispatchEvent(_loc2_);
         }
      }
   }
}
