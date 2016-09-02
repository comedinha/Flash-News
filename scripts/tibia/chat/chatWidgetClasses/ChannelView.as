package tibia.chat.chatWidgetClasses
{
   import shared.controls.CustomDividedBox;
   import flash.utils.Dictionary;
   import tibia.chat.Channel;
   import shared.controls.SmoothList;
   import mx.collections.Sort;
   import mx.collections.ListCollectionView;
   import tibia.chat.ChatStorage;
   import mx.collections.ICollectionView;
   import flash.events.MouseEvent;
   import mx.controls.listClasses.IListItemRenderer;
   import mx.collections.IList;
   import tibia.chat.ChannelMessage;
   import mx.containers.BoxDirection;
   
   public class ChannelView extends CustomDividedBox
   {
      
      private static const s_StateSortOrder:Dictionary = new Dictionary();
      
      {
         s_StateSortOrder[NicklistItem.STATE_SUBSCRIBER] = 1;
         s_StateSortOrder[NicklistItem.STATE_INVITED] = 2;
         s_StateSortOrder[NicklistItem.STATE_PENDING] = 3;
      }
      
      protected var m_UINicklist:SmoothList = null;
      
      private var m_UIConstructed:Boolean = false;
      
      protected var m_Channel:Channel = null;
      
      private var m_UncommittedChannel:Boolean = false;
      
      protected var m_UIChannel:tibia.chat.chatWidgetClasses.ChannelMessageList = null;
      
      protected var m_UINicklistItemView:IList = null;
      
      public function ChannelView()
      {
         super();
         direction = BoxDirection.HORIZONTAL;
      }
      
      public function get channel() : Channel
      {
         return this.m_Channel;
      }
      
      public function selectAll() : void
      {
         if(this.m_UIChannel != null)
         {
            this.m_UIChannel.selectAllText();
         }
      }
      
      public function set channel(param1:Channel) : void
      {
         if(this.m_Channel != param1)
         {
            this.m_Channel = param1;
            this.m_UncommittedChannel = true;
            invalidateProperties();
         }
      }
      
      override protected function commitProperties() : void
      {
         var _loc1_:Boolean = false;
         var _loc2_:Sort = null;
         if(this.m_UncommittedChannel)
         {
            _loc1_ = false;
            if(this.m_Channel != null)
            {
               this.m_UINicklistItemView = new ListCollectionView(this.m_Channel.nicklistItems);
               this.m_UIChannel.stopsScrollingOnLargeBlocks = this.m_Channel.ID == ChatStorage.NPC_CHANNEL_ID;
               this.m_UIChannel.dataProvider = this.m_Channel.messages;
               this.m_UINicklist.dataProvider = this.m_UINicklistItemView;
               if(this.m_UINicklistItemView is ICollectionView)
               {
                  ICollectionView(this.m_UINicklistItemView).filterFunction = this.nicklistItemFilter;
                  ICollectionView(this.m_UINicklistItemView).refresh();
                  _loc2_ = new Sort();
                  _loc2_.compareFunction = this.nicklistItemComparator;
                  ICollectionView(this.m_UINicklistItemView).sort = _loc2_;
               }
               _loc1_ = this.m_Channel.showNicklist;
            }
            else
            {
               this.m_UIChannel.dataProvider = null;
               this.m_UINicklist.dataProvider = null;
               _loc1_ = false;
            }
            if(_loc1_)
            {
               if(!contains(this.m_UINicklist))
               {
                  addChild(this.m_UINicklist);
               }
            }
            else if(contains(this.m_UINicklist))
            {
               removeChild(this.m_UINicklist);
            }
            this.m_UncommittedChannel = false;
         }
         super.commitProperties();
      }
      
      protected function nicklistItemFilter(param1:Object) : Boolean
      {
         var _loc2_:NicklistItem = param1 as NicklistItem;
         return _loc2_ != null && _loc2_.state != NicklistItem.STATE_UNKNOWN;
      }
      
      public function getSelectedText() : String
      {
         if(this.m_UIChannel != null)
         {
            return this.m_UIChannel.getSelectedText();
         }
         return null;
      }
      
      protected function onMessageClick(param1:MouseEvent) : void
      {
         var _loc2_:IListItemRenderer = null;
         var _loc3_:int = 0;
         var _loc4_:IList = null;
         var _loc5_:ChannelMessage = null;
         var _loc6_:ChannelEvent = null;
         if(param1 != null && this.m_Channel != null)
         {
            _loc2_ = this.m_UIChannel.mouseEventToItemRenderer(param1);
            _loc3_ = _loc2_ != null?int(this.m_UIChannel.itemRendererToIndex(_loc2_)):0;
            _loc4_ = this.m_Channel.messages;
            _loc3_ = Math.min(Math.max(0,_loc3_),_loc4_.length - 1);
            if(_loc3_ > -1)
            {
               _loc5_ = ChannelMessage(_loc4_.getItemAt(_loc3_));
               _loc6_ = new ChannelEvent(ChannelEvent.VIEW_CONTEXT_MENU);
               _loc6_.channel = this.m_Channel;
               _loc6_.message = _loc5_;
               _loc6_.name = _loc5_.speaker;
               dispatchEvent(_loc6_);
            }
         }
      }
      
      protected function onNicklistItemClick(param1:MouseEvent) : void
      {
         var _loc2_:IListItemRenderer = null;
         var _loc3_:NicklistItem = null;
         var _loc4_:ChannelEvent = null;
         if(param1 != null && this.m_Channel != null && this.m_Channel.showNicklist)
         {
            _loc2_ = this.m_UINicklist.mouseEventToItemRenderer(param1);
            _loc3_ = _loc2_ != null?_loc2_.data as NicklistItem:null;
            if(_loc3_ != null)
            {
               _loc4_ = new ChannelEvent(ChannelEvent.NICKLIST_CONTEXT_MENU);
               _loc4_.channel = this.m_Channel;
               _loc4_.message = null;
               _loc4_.name = _loc3_.name;
               dispatchEvent(_loc4_);
            }
         }
      }
      
      override protected function measure() : void
      {
         super.measure();
         minHeight = this.m_UIChannel.minHeight + viewMetricsAndPadding.top + viewMetricsAndPadding.bottom;
      }
      
      public function clearSelection() : void
      {
         if(this.m_UIChannel != null)
         {
            this.m_UIChannel.clearSelectedText();
         }
      }
      
      protected function nicklistItemComparator(param1:Object, param2:Object, param3:Array = null) : int
      {
         var _loc7_:String = null;
         var _loc8_:String = null;
         var _loc4_:NicklistItem = param1 as NicklistItem;
         var _loc5_:NicklistItem = param2 as NicklistItem;
         var _loc6_:int = 0;
         if(_loc4_ != null && _loc5_ != null)
         {
            if(s_StateSortOrder[_loc4_.state] < s_StateSortOrder[_loc5_.state])
            {
               _loc6_ = -1;
            }
            else if(s_StateSortOrder[_loc4_.state] > s_StateSortOrder[_loc5_.state])
            {
               _loc6_ = 1;
            }
         }
         if(_loc6_ == 0)
         {
            _loc7_ = _loc4_.name;
            if(_loc7_ != null)
            {
               _loc7_ = _loc7_.toLowerCase();
            }
            _loc8_ = _loc5_.name;
            if(_loc8_ != null)
            {
               _loc8_ = _loc8_.toLowerCase();
            }
            if(_loc7_ < _loc8_)
            {
               _loc6_ = -1;
            }
            else if(_loc7_ > _loc8_)
            {
               _loc6_ = 1;
            }
         }
         return _loc6_;
      }
      
      override protected function createChildren() : void
      {
         if(!this.m_UIConstructed)
         {
            super.createChildren();
            this.m_UIChannel = new tibia.chat.chatWidgetClasses.ChannelMessageList();
            this.m_UIChannel.name = "ChannelMessageList";
            this.m_UIChannel.dataProvider = null;
            this.m_UIChannel.followTailPolicy = SmoothList.FOLLOW_TAIL_AUTO;
            this.m_UIChannel.minItemCount = 3;
            this.m_UIChannel.percentHeight = 100;
            this.m_UIChannel.percentWidth = 100;
            this.m_UIChannel.styleName = getStyle("messagesStyle");
            this.m_UIChannel.addEventListener(MouseEvent.RIGHT_CLICK,this.onMessageClick);
            addChild(this.m_UIChannel);
            this.m_UINicklist = new SmoothList(NicklistItemRenderer,NicklistItemRenderer.HEIGHT_HINT);
            this.m_UINicklist.name = "ChannelNicklist";
            this.m_UINicklist.dataProvider = null;
            this.m_UINicklist.followTailPolicy = SmoothList.FOLLOW_TAIL_OFF;
            this.m_UINicklist.maxWidth = 128;
            this.m_UINicklist.minWidth = 64;
            this.m_UINicklist.percentHeight = 100;
            this.m_UINicklist.percentWidth = 100;
            this.m_UINicklist.selectable = false;
            this.m_UINicklist.styleName = getStyle("nicklistStyle");
            this.m_UINicklist.addEventListener(MouseEvent.RIGHT_CLICK,this.onNicklistItemClick);
            this.m_UIConstructed = true;
         }
      }
   }
}
