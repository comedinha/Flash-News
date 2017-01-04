package tibia.creatures.buddylistWidgetClasses
{
   import flash.events.MouseEvent;
   import flash.utils.Dictionary;
   import mx.collections.ICollectionView;
   import mx.collections.IList;
   import mx.collections.ListCollectionView;
   import mx.collections.Sort;
   import mx.containers.HBox;
   import mx.controls.listClasses.IListItemRenderer;
   import mx.core.ScrollPolicy;
   import shared.controls.SmoothList;
   import tibia.creatures.BuddySet;
   import tibia.creatures.BuddylistWidget;
   import tibia.creatures.buddylistClasses.Buddy;
   import tibia.input.gameaction.PrivateChatActionImpl;
   import tibia.sidebar.sideBarWidgetClasses.WidgetView;
   
   public class BuddylistWidgetView extends WidgetView
   {
      
      private static const BUNDLE:String = "BuddylistWidget";
      
      private static const s_StatusSortOrder:Dictionary = new Dictionary();
      
      {
         s_StatusSortOrder[Buddy.STATUS_ONLINE] = 1;
         s_StatusSortOrder[Buddy.STATUS_PENDING] = 2;
         s_StatusSortOrder[Buddy.STATUS_OFFLINE] = 3;
      }
      
      private var m_UncommittedShowOffline:Boolean = false;
      
      private var m_SortOrder:int;
      
      private var m_UIList:SmoothList = null;
      
      private var m_UncommittedBuddySet:Boolean = false;
      
      private var m_BuddySet:BuddySet = null;
      
      private var m_ShowOffline:Boolean = true;
      
      private var m_BuddiesView:IList = null;
      
      private var m_UncommittedSortOrder:Boolean = false;
      
      public function BuddylistWidgetView()
      {
         this.m_SortOrder = BuddylistWidget.SORT_BY_NAME;
         super();
         titleText = resourceManager.getString(BUNDLE,"TITLE");
         verticalScrollPolicy = ScrollPolicy.OFF;
         horizontalScrollPolicy = ScrollPolicy.OFF;
         maxHeight = int.MAX_VALUE;
         addEventListener(MouseEvent.RIGHT_CLICK,this.onBuddiesClick);
         addEventListener(MouseEvent.DOUBLE_CLICK,this.onBuddiesClick);
      }
      
      override function releaseInstance() : void
      {
         super.releaseInstance();
         removeEventListener(MouseEvent.DOUBLE_CLICK,this.onBuddiesClick);
         removeEventListener(MouseEvent.RIGHT_CLICK,this.onBuddiesClick);
      }
      
      override protected function commitProperties() : void
      {
         var _loc1_:Sort = null;
         super.commitProperties();
         if(this.m_UncommittedBuddySet)
         {
            if(this.buddySet != null)
            {
               this.m_BuddiesView = new ListCollectionView(this.buddySet.buddies);
               if(this.m_BuddiesView is ICollectionView)
               {
                  ICollectionView(this.m_BuddiesView).filterFunction = this.buddyFilter;
                  _loc1_ = new Sort();
                  _loc1_.compareFunction = this.buddyComparator;
                  ICollectionView(this.m_BuddiesView).sort = _loc1_;
               }
            }
            else
            {
               this.m_BuddiesView = null;
            }
            this.m_UIList.dataProvider = this.m_BuddiesView;
            this.m_UncommittedBuddySet = false;
         }
         if(this.m_UncommittedShowOffline || this.m_UncommittedSortOrder)
         {
            if(this.m_BuddiesView is ICollectionView)
            {
               ICollectionView(this.m_BuddiesView).refresh();
            }
            this.m_UncommittedShowOffline = false;
            this.m_UncommittedSortOrder = false;
         }
      }
      
      function get buddySet() : BuddySet
      {
         return this.m_BuddySet;
      }
      
      function set showOffline(param1:Boolean) : void
      {
         if(this.m_ShowOffline != param1)
         {
            this.m_ShowOffline = param1;
            this.m_UncommittedShowOffline = true;
            invalidateProperties();
         }
      }
      
      function get sortOrder() : int
      {
         return this.m_SortOrder;
      }
      
      private function onBuddiesClick(param1:MouseEvent) : void
      {
         var _loc2_:Buddy = null;
         var _loc3_:IListItemRenderer = null;
         if(this.buddySet != null)
         {
            _loc2_ = null;
            _loc3_ = this.m_UIList.mouseEventToItemRenderer(param1);
            if(_loc3_ != null)
            {
               _loc2_ = _loc3_.data as Buddy;
            }
            if(param1.type == MouseEvent.DOUBLE_CLICK)
            {
               if(_loc2_ != null)
               {
                  new PrivateChatActionImpl(PrivateChatActionImpl.OPEN_MESSAGE_CHANNEL,PrivateChatActionImpl.CHAT_CHANNEL_NO_CHANNEL,_loc2_.name).perform();
               }
            }
            else if(param1.type == MouseEvent.RIGHT_CLICK)
            {
               new BuddylistItemContextMenu(this.buddySet,_loc2_).display(this,stage.mouseX,stage.mouseY);
            }
         }
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this.m_UIList = new SmoothList(BuddylistItemRenderer,BuddylistItemRenderer.HEIGHT_HINT);
         this.m_UIList.name = "Buddylist";
         this.m_UIList.defaultItemCount = 3;
         this.m_UIList.doubleClickEnabled = true;
         this.m_UIList.followTailPolicy = SmoothList.FOLLOW_TAIL_OFF;
         this.m_UIList.minItemCount = 3;
         this.m_UIList.percentWidth = 100;
         this.m_UIList.percentHeight = 100;
         this.m_UIList.selectable = false;
         this.m_UIList.styleName = getStyle("listStyle");
         var _loc1_:HBox = new HBox();
         _loc1_.percentHeight = 100;
         _loc1_.percentWidth = 100;
         _loc1_.styleName = getStyle("listBoxStyle");
         _loc1_.addChild(this.m_UIList);
         addChild(_loc1_);
      }
      
      function set sortOrder(param1:int) : void
      {
         if(this.m_SortOrder != param1)
         {
            this.m_SortOrder = param1;
            this.m_UncommittedSortOrder = true;
            invalidateProperties();
         }
      }
      
      protected function buddyFilter(param1:Object) : Boolean
      {
         var _loc2_:Buddy = param1 as Buddy;
         return _loc2_ != null && (this.showOffline || _loc2_.status != Buddy.STATUS_OFFLINE);
      }
      
      function get showOffline() : Boolean
      {
         return this.m_ShowOffline;
      }
      
      function set buddySet(param1:BuddySet) : void
      {
         if(this.m_BuddySet != param1)
         {
            this.m_BuddySet = param1;
            this.m_UncommittedBuddySet = true;
            this.m_UncommittedShowOffline = true;
            this.m_UncommittedSortOrder = true;
            invalidateProperties();
         }
      }
      
      protected function buddyComparator(param1:Object, param2:Object, param3:Array = null) : int
      {
         var _loc7_:String = null;
         var _loc8_:String = null;
         var _loc4_:Buddy = param1 as Buddy;
         var _loc5_:Buddy = param2 as Buddy;
         var _loc6_:int = 0;
         if(_loc4_ != null && _loc5_ != null)
         {
            switch(this.sortOrder)
            {
               case BuddylistWidget.SORT_BY_NAME:
                  break;
               case BuddylistWidget.SORT_BY_ICON:
                  if(_loc4_.icon < _loc5_.icon)
                  {
                     _loc6_ = -1;
                  }
                  else if(_loc4_.icon > _loc5_.icon)
                  {
                     _loc6_ = 1;
                  }
                  break;
               case BuddylistWidget.SORT_BY_STATUS:
                  if(s_StatusSortOrder[_loc4_.status] < s_StatusSortOrder[_loc5_.status])
                  {
                     _loc6_ = -1;
                  }
                  else if(s_StatusSortOrder[_loc4_.status] > s_StatusSortOrder[_loc5_.status])
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
         }
         return _loc6_;
      }
   }
}
