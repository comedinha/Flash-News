package tibia.chat.chatWidgetClasses
{
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import mx.collections.IList;
   import mx.controls.Button;
   import mx.controls.listClasses.IListItemRenderer;
   import mx.core.EdgeMetrics;
   import mx.core.IUIComponent;
   import mx.effects.Effect;
   import mx.effects.Glow;
   import mx.effects.Sequence;
   import shared.controls.SmoothList;
   import tibia.chat.ChannelMessage;
   import tibia.chat.MessageMode;
   
   public class ChannelMessageList extends SmoothList
   {
       
      
      private var m_UnreadEffect:Effect = null;
      
      protected var m_SelectedTextEnd:Point = null;
      
      protected var m_StopScrollingOnLargeBlocks:Boolean = false;
      
      private var m_UncommittedDataProvider:Boolean = false;
      
      protected var m_SelectedTextBegin:Point = null;
      
      protected var m_TextSelectionMode:Boolean = false;
      
      protected var m_LastMarkerLineCount:int = 0;
      
      public function ChannelMessageList()
      {
         super(ChannelMessageRenderer,ChannelMessageRenderer.HEIGHT_HINT);
         selectable = false;
         this.m_TextSelectionMode = false;
         this.m_SelectedTextBegin = new Point();
         this.m_SelectedTextEnd = new Point();
      }
      
      override protected function onMouseUp(param1:Event) : void
      {
         super.onMouseUp(param1);
         if(this.m_TextSelectionMode)
         {
            this.leaveTextSelectionMode(stage.mouseX,stage.mouseY);
         }
      }
      
      override protected function onDragScrollTimer(param1:TimerEvent) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Point = null;
         super.onDragScrollTimer(param1);
         if(this.m_TextSelectionMode)
         {
            _loc2_ = mouseX;
            _loc3_ = Math.max(0,Math.min(mouseY,unscaledHeight));
            _loc4_ = localToGlobal(new Point(_loc2_,_loc3_));
            this.setSelectedTextPoint(_loc4_.x,_loc4_.y,this.m_SelectedTextEnd);
            this.updateSelectedText();
         }
      }
      
      protected function setSelectedTextPoint(param1:Number, param2:Number, param3:Point) : void
      {
         var _loc6_:Point = null;
         if(param1 < 0 || param2 < 0)
         {
            param3.x = -1;
            param3.y = -1;
            return;
         }
         var _loc4_:int = pointToItemIndex(param1,param2);
         var _loc5_:ISelectionProxy = itemIndexToItemRenderer(_loc4_) as ISelectionProxy;
         if(_loc5_ != null && _loc5_ is IUIComponent)
         {
            _loc6_ = (_loc5_ as IUIComponent).globalToLocal(new Point(param1,param2));
            param3.x = _loc4_;
            param3.y = _loc5_.getCharIndexAtPoint(_loc6_.x,_loc6_.y);
         }
      }
      
      override protected function onMouseDown(param1:MouseEvent) : void
      {
         super.onMouseDown(param1);
         var _loc2_:IListItemRenderer = mouseEventToItemRenderer(param1);
         if(_loc2_ != null)
         {
            this.m_TextSelectionMode = true;
            this.setSelectedTextPoint(param1.stageX,param1.stageY,this.m_SelectedTextBegin);
            this.setSelectedTextPoint(-1,-1,this.m_SelectedTextEnd);
            this.updateSelectedText();
         }
      }
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
         if(this.m_UncommittedDataProvider)
         {
            this.m_TextSelectionMode = false;
            this.setSelectedTextRange(-1,-1,-1,-1);
            this.updateSelectedText();
            this.m_UncommittedDataProvider = false;
         }
      }
      
      protected function updateSelectedText() : void
      {
         var _loc6_:int = 0;
         var _loc7_:ISelectionProxy = null;
         var _loc1_:int = -1;
         var _loc2_:int = -1;
         var _loc3_:int = -1;
         var _loc4_:int = -1;
         if(this.m_SelectedTextBegin.x <= this.m_SelectedTextEnd.x)
         {
            _loc1_ = this.m_SelectedTextBegin.x;
            _loc2_ = this.m_SelectedTextBegin.y;
            _loc3_ = this.m_SelectedTextEnd.x;
            _loc4_ = this.m_SelectedTextEnd.y;
            if(_loc1_ == _loc3_)
            {
               _loc2_ = Math.min(this.m_SelectedTextBegin.y,this.m_SelectedTextEnd.y);
               _loc4_ = Math.max(this.m_SelectedTextBegin.y,this.m_SelectedTextEnd.y);
            }
         }
         else
         {
            _loc1_ = this.m_SelectedTextEnd.x;
            _loc2_ = this.m_SelectedTextEnd.y;
            _loc3_ = this.m_SelectedTextBegin.x;
            _loc4_ = this.m_SelectedTextBegin.y;
         }
         if(_loc1_ < 0 || _loc3_ < 0)
         {
            _loc1_ = -1;
            _loc3_ = -1;
         }
         var _loc5_:int = 0;
         while(_loc5_ < m_RendererMap.length)
         {
            _loc6_ = _loc5_ + m_FirstVisibleItem;
            _loc7_ = m_RendererMap[_loc5_] as ISelectionProxy;
            if(_loc7_ != null)
            {
               if(_loc1_ < _loc3_ && _loc6_ == _loc1_)
               {
                  _loc7_.setSelection(_loc2_,_loc7_.getCharCount() + 1);
               }
               else if(_loc1_ < _loc3_ && _loc6_ == _loc3_)
               {
                  _loc7_.setSelection(0,_loc4_);
               }
               else if(_loc1_ < _loc6_ && _loc6_ < _loc3_)
               {
                  _loc7_.selectAll();
               }
               else if(_loc1_ == _loc3_ && _loc6_ == _loc1_)
               {
                  _loc7_.setSelection(_loc2_,_loc4_);
               }
               else
               {
                  _loc7_.clearSelection();
               }
            }
            _loc5_++;
         }
      }
      
      public function clearSelectedText() : void
      {
         this.setSelectedTextRange(-1,-1,-1,-1);
         this.updateSelectedText();
      }
      
      public function selectAllText() : void
      {
         this.setSelectedTextRange(-1,-1,-1,-1);
         var _loc1_:int = dataProvider != null?int(dataProvider.length):0;
         var _loc2_:IListItemRenderer = createItemRenderer();
         if(_loc1_ > 0 && _loc2_ is ISelectionProxy)
         {
            _loc2_.data = dataProvider.getItemAt(_loc1_ - 1);
            this.setSelectedTextRange(0,0,_loc1_ - 1,(_loc2_ as ISelectionProxy).getCharCount() + 1);
         }
         this.updateSelectedText();
      }
      
      public function get stopsScrollingOnLargeBlocks() : Boolean
      {
         return this.m_StopScrollingOnLargeBlocks;
      }
      
      private function startIndicatorForUnreadText() : void
      {
         var _loc1_:Glow = null;
         var _loc2_:Glow = null;
         var _loc3_:Sequence = null;
         var _loc4_:Button = null;
         if(this.m_UnreadEffect == null)
         {
            _loc1_ = new Glow();
            _loc2_ = new Glow();
            _loc1_.alphaFrom = 0;
            _loc1_.alphaTo = 0.3;
            _loc2_.alphaFrom = _loc1_.alphaTo;
            _loc2_.alphaTo = _loc1_.alphaFrom;
            _loc1_.color = _loc2_.color = 15597568;
            _loc1_.blurXFrom = _loc2_.blurXFrom = 100;
            _loc1_.blurXTo = _loc2_.blurXTo = 100;
            _loc1_.blurYFrom = _loc2_.blurYFrom = _loc1_.blurXFrom;
            _loc1_.blurYTo = _loc2_.blurYTo = _loc1_.blurXTo;
            _loc1_.strength = _loc2_.strength = 4;
            _loc1_.duration = _loc2_.duration = 2000;
            _loc1_.inner = _loc2_.inner = true;
            _loc3_ = new Sequence();
            _loc3_.repeatCount = 0;
            _loc3_.addChild(_loc1_);
            _loc3_.addChild(_loc2_);
            this.m_UnreadEffect = _loc3_;
         }
         if(verticalScrollBar != null)
         {
            _loc4_ = verticalScrollBar.getChildAt(verticalScrollBar.numChildren - 1) as Button;
            if(_loc4_ != null)
            {
               this.m_UnreadEffect.end();
               this.m_UnreadEffect.play([_loc4_]);
            }
         }
         if(Tibia.s_GetChatWidget() != null && Tibia.s_GetChatWidget().tabBar != null && Tibia.s_GetChatWidget().tabBar.selectedTab != null)
         {
            Tibia.s_GetChatWidget().tabBar.selectedTab.forceHighlight();
         }
      }
      
      public function getSelectedText() : String
      {
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc8_:int = 0;
         var _loc1_:int = -1;
         var _loc2_:int = -1;
         var _loc3_:int = -1;
         var _loc4_:int = -1;
         if(this.m_SelectedTextBegin.x <= this.m_SelectedTextEnd.x)
         {
            _loc1_ = this.m_SelectedTextBegin.x;
            _loc2_ = this.m_SelectedTextBegin.y;
            _loc3_ = this.m_SelectedTextEnd.x;
            _loc4_ = this.m_SelectedTextEnd.y;
            if(_loc1_ == _loc3_)
            {
               _loc2_ = Math.min(this.m_SelectedTextBegin.y,this.m_SelectedTextEnd.y);
               _loc4_ = Math.max(this.m_SelectedTextBegin.y,this.m_SelectedTextEnd.y);
            }
         }
         else
         {
            _loc1_ = this.m_SelectedTextEnd.x;
            _loc2_ = this.m_SelectedTextEnd.y;
            _loc3_ = this.m_SelectedTextBegin.x;
            _loc4_ = this.m_SelectedTextBegin.y;
         }
         var _loc5_:IListItemRenderer = createItemRenderer();
         if(!(_loc5_ is ISelectionProxy))
         {
            return null;
         }
         if(_loc1_ < 0 || _loc3_ < 0 || _loc5_ == null)
         {
            return "";
         }
         if(_loc1_ == _loc3_)
         {
            _loc5_.data = dataProvider.getItemAt(_loc1_);
            return (_loc5_ as ISelectionProxy).getLabel().substring(_loc2_,_loc4_);
         }
         _loc5_.data = dataProvider.getItemAt(_loc1_);
         _loc6_ = (_loc5_ as ISelectionProxy).getLabel();
         _loc7_ = _loc6_ != null?_loc6_.substr(_loc2_) + "\n":"";
         _loc8_ = _loc1_ + 1;
         while(_loc8_ < _loc3_)
         {
            _loc5_.data = dataProvider.getItemAt(_loc8_);
            _loc6_ = (_loc5_ as ISelectionProxy).getLabel();
            if(_loc6_ != null)
            {
               _loc7_ = _loc7_ + (_loc6_ + "\n");
            }
            _loc8_++;
         }
         _loc5_.data = dataProvider.getItemAt(_loc8_);
         _loc6_ = (_loc5_ as ISelectionProxy).getLabel();
         _loc7_ = _loc7_ + (_loc6_ != null?_loc6_.substring(0,_loc4_):"");
         return _loc7_;
      }
      
      protected function leaveTextSelectionMode(param1:Number, param2:Number) : void
      {
         if(this.m_TextSelectionMode)
         {
            this.m_TextSelectionMode = false;
            this.setSelectedTextPoint(param1,param2,this.m_SelectedTextEnd);
            if(this.m_SelectedTextBegin.x == this.m_SelectedTextEnd.x && this.m_SelectedTextBegin.y == this.m_SelectedTextEnd.y)
            {
               this.m_SelectedTextBegin.x = this.m_SelectedTextBegin.y = -1;
               this.m_SelectedTextEnd.x = this.m_SelectedTextEnd.y = -1;
            }
            this.updateSelectedText();
         }
      }
      
      override public function set dataProvider(param1:IList) : void
      {
         if(super.dataProvider != param1)
         {
            super.dataProvider = param1;
            if(param1 != null)
            {
               this.m_LastMarkerLineCount = param1.length;
            }
            this.stopIndicatorForUnreadText();
            this.m_UncommittedDataProvider = true;
            invalidateProperties();
         }
      }
      
      override protected function onMouseMove(param1:MouseEvent) : void
      {
         super.onMouseMove(param1);
         if(this.m_TextSelectionMode)
         {
            this.setSelectedTextPoint(param1.stageX,param1.stageY,this.m_SelectedTextEnd);
            this.updateSelectedText();
         }
      }
      
      private function stopIndicatorForUnreadText() : void
      {
         if(this.m_UnreadEffect != null && this.m_UnreadEffect.isPlaying)
         {
            this.m_UnreadEffect.end();
         }
         if(Tibia.s_GetChatWidget() != null && Tibia.s_GetChatWidget().tabBar != null && Tibia.s_GetChatWidget().tabBar.selectedTab != null)
         {
            Tibia.s_GetChatWidget().tabBar.selectedTab.highlight = false;
         }
      }
      
      protected function setSelectedTextRange(param1:int, param2:int, param3:int, param4:int) : void
      {
         this.m_SelectedTextBegin.x = param1;
         this.m_SelectedTextBegin.y = param2;
         this.m_SelectedTextEnd.x = param3;
         this.m_SelectedTextEnd.y = param4;
      }
      
      public function set stopsScrollingOnLargeBlocks(param1:Boolean) : void
      {
         this.m_StopScrollingOnLargeBlocks = param1;
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:ChannelMessage = null;
         var _loc7_:EdgeMetrics = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         super.updateDisplayList(param1,param2);
         var _loc3_:int = m_DataProvider != null?int(m_DataProvider.length):0;
         if(!m_FollowTail)
         {
            this.m_LastMarkerLineCount = _loc3_;
         }
         else if(_loc3_ > 0 && this.m_StopScrollingOnLargeBlocks && this.m_LastMarkerLineCount < _loc3_ && m_FollowTail)
         {
            _loc4_ = -1;
            _loc5_ = _loc3_ - 1;
            while(_loc5_ >= 0)
            {
               _loc6_ = m_DataProvider.getItemAt(_loc5_) as ChannelMessage;
               if(_loc6_ != null && _loc6_.mode == MessageMode.MESSAGE_NPC_FROM_START_BLOCK)
               {
                  _loc4_ = _loc5_;
                  break;
               }
               if(_loc6_ != null && _loc6_.mode == MessageMode.MESSAGE_NPC_TO)
               {
                  break;
               }
               _loc5_--;
            }
            if(_loc4_ > -1)
            {
               _loc7_ = viewMetricsAndPadding;
               _loc8_ = param2 - _loc7_.top - _loc7_.bottom;
               _loc9_ = m_ExtentChache.top(_loc4_);
               _loc10_ = m_ExtentChache.bottom(_loc3_ - 1) - _loc9_;
               if(_loc10_ > _loc8_)
               {
                  this.m_LastMarkerLineCount = _loc3_;
                  verticalScrollPosition = _loc9_;
                  m_FollowTail = false;
                  super.updateDisplayList(param1,param2);
                  this.startIndicatorForUnreadText();
                  Tibia.s_GetChatWidget().tabBar.selectedTab.forceHighlight();
               }
            }
         }
         if(m_FollowTail || m_LastVisibleItem == _loc3_ - 1)
         {
            this.stopIndicatorForUnreadText();
         }
         this.updateSelectedText();
      }
   }
}
