package tibia.trade.npcTradeWidgetClasses
{
   import mx.core.UIComponent;
   import tibia.trade.TradeObjectRef;
   import mx.collections.Sort;
   import mx.collections.ICollectionView;
   import mx.collections.SortField;
   import flash.events.MouseEvent;
   import tibia.options.OptionsStorage;
   import flash.display.DisplayObject;
   import tibia.input.gameaction.InspectNPCTradeActionImpl;
   import mx.collections.IList;
   import flash.events.Event;
   import tibia.appearances.widgetClasses.SkinnedAppearanceRenderer;
   import flash.display.Stage;
   
   public class ObjectRefSelectorBase extends UIComponent
   {
      
      private static const ACTION_UNSET:int = -1;
      
      private static const MOUSE_BUTTON_LEFT:int = 1;
      
      private static const MOUSE_BUTTON_BOTH:int = 4;
      
      private static const ACTION_USE_OR_OPEN:int = 101;
      
      private static const ACTION_SMARTCLICK:int = 100;
      
      private static const MOUSE_BUTTON_RIGHT:int = 2;
      
      public static const SORT_NAME:int = 0;
      
      private static const ACTION_LOOK:int = 6;
      
      public static const LAYOUT_LIST:int = 0;
      
      private static const ACTION_TALK:int = 9;
      
      public static const LAYOUT_GRID:int = 1;
      
      private static const ACTION_USE:int = 7;
      
      private static const MOUSE_BUTTON_MIDDLE:int = 3;
      
      private static const ACTION_NONE:int = 0;
      
      private static const ACTION_AUTOWALK:int = 3;
      
      private static const ACTION_ATTACK:int = 1;
      
      private static const ACTION_OPEN:int = 8;
      
      public static const SORT_PRICE:int = 2;
      
      private static const ACTION_AUTOWALK_HIGHLIGHT:int = 4;
      
      private static const ACTION_CONTEXT_MENU:int = 5;
      
      public static const SORT_WEIGHT:int = 1;
      
      private static const ACTION_ATTACK_OR_TALK:int = 102;
       
      
      protected var m_SelectedIndex:int = -1;
      
      private var m_UncommittedTradeMode:Boolean = false;
      
      protected var m_SortOrder:int = 0;
      
      private var m_UncommittedSelectedIndex:Boolean = false;
      
      private var m_UncommittedDataProvider:Boolean = false;
      
      protected var m_DataProvider:IList = null;
      
      protected var m_TradeMode:int = 0;
      
      private var m_UncommittedSortOrder:Boolean = true;
      
      public function ObjectRefSelectorBase()
      {
         super();
         addEventListener(MouseEvent.CLICK,this.onMouseClick);
         addEventListener(MouseEvent.MIDDLE_CLICK,this.onMouseClick);
         addEventListener(MouseEvent.RIGHT_CLICK,this.onMouseClick);
      }
      
      public static function s_Create(param1:int) : ObjectRefSelectorBase
      {
         switch(param1)
         {
            case LAYOUT_GRID:
               return new GridObjectRefSelector();
            case LAYOUT_LIST:
            default:
               return new ListObjectRefSelector();
         }
      }
      
      public function set tradeMode(param1:int) : void
      {
         if(param1 != NPCTradeWidgetView.MODE_BUY && param1 != NPCTradeWidgetView.MODE_SELL)
         {
            param1 = NPCTradeWidgetView.MODE_BUY;
         }
         if(this.m_TradeMode != param1)
         {
            this.m_TradeMode = param1;
            this.m_UncommittedTradeMode = true;
            this.m_UncommittedSortOrder = true;
            invalidateProperties();
         }
      }
      
      public function get sortOrder() : int
      {
         return this.m_SortOrder;
      }
      
      override protected function commitProperties() : void
      {
         var _loc1_:TradeObjectRef = null;
         var _loc2_:Array = null;
         var _loc3_:Sort = null;
         super.commitProperties();
         if(this.m_UncommittedDataProvider)
         {
            this.selectedIndex = -1;
            this.m_UncommittedDataProvider = false;
         }
         if(this.m_UncommittedSortOrder)
         {
            _loc1_ = this.selectedObject;
            if(this.dataProvider is ICollectionView)
            {
               _loc2_ = [];
               if(this.tradeMode == NPCTradeWidgetView.MODE_SELL)
               {
                  _loc2_.push(new SortField("amount",false,true,true));
               }
               switch(this.sortOrder)
               {
                  case SORT_NAME:
                     break;
                  case SORT_PRICE:
                     _loc2_.push(new SortField("price",false,false,true));
                     break;
                  case SORT_WEIGHT:
                     _loc2_.push(new SortField("weight",false,false,true));
               }
               _loc2_.push(new SortField("name"),new SortField("ID",false,false,true));
               _loc3_ = new Sort();
               _loc3_.fields = _loc2_;
               ICollectionView(this.dataProvider).sort = _loc3_;
               ICollectionView(this.dataProvider).refresh();
            }
            if(this.dataProvider != null)
            {
               this.selectedIndex = this.dataProvider.getItemIndex(_loc1_);
            }
            this.m_UncommittedSortOrder = false;
         }
         if(this.m_UncommittedTradeMode)
         {
            this.selectedIndex = -1;
            this.m_UncommittedTradeMode = false;
         }
         if(this.m_UncommittedSelectedIndex)
         {
            this.m_UncommittedSelectedIndex = false;
         }
      }
      
      public function set sortOrder(param1:int) : void
      {
         if(param1 != SORT_NAME && param1 != SORT_WEIGHT && param1 != SORT_PRICE)
         {
            param1 = SORT_NAME;
         }
         if(this.m_SortOrder != param1)
         {
            this.m_SortOrder = param1;
            this.m_UncommittedSortOrder = true;
            invalidateProperties();
         }
      }
      
      protected function onMouseClick(param1:MouseEvent) : void
      {
         var _loc2_:TradeObjectRef = null;
         var _loc3_:int = 0;
         var _loc4_:OptionsStorage = null;
         if(param1 != null)
         {
            _loc2_ = this.getTradeObjectByDisplayObject(DisplayObject(param1.target));
            _loc3_ = ACTION_UNSET;
            if(param1.type == MouseEvent.CLICK && !param1.altKey && !param1.ctrlKey && !param1.shiftKey)
            {
               if(_loc2_ != null)
               {
                  this.selectedObject = _loc2_;
               }
               _loc3_ = ACTION_NONE;
            }
            else if(param1.altKey)
            {
               _loc3_ = ACTION_NONE;
            }
            else if(param1.ctrlKey)
            {
               _loc3_ = ACTION_CONTEXT_MENU;
            }
            else if(param1.shiftKey)
            {
               _loc3_ = ACTION_LOOK;
            }
            else
            {
               _loc3_ = ACTION_CONTEXT_MENU;
            }
            switch(_loc3_)
            {
               case ACTION_NONE:
                  break;
               case ACTION_LOOK:
                  if(_loc2_ != null)
                  {
                     new InspectNPCTradeActionImpl(_loc2_).perform();
                  }
                  break;
               case ACTION_CONTEXT_MENU:
                  _loc4_ = Tibia.s_GetOptions();
                  if(_loc4_ != null)
                  {
                     new NPCTradeContextMenu(_loc4_,this.m_TradeMode,_loc2_).display(this,param1.stageX,param1.stageY);
                  }
            }
         }
      }
      
      public function get tradeMode() : int
      {
         return this.m_TradeMode;
      }
      
      public function set selectedIndex(param1:int) : void
      {
         var _loc2_:Event = null;
         if(this.dataProvider != null && param1 > -1)
         {
            param1 = Math.max(0,Math.min(param1,this.dataProvider.length - 1));
         }
         else
         {
            param1 = -1;
         }
         if(this.selectedIndex != param1)
         {
            this.m_SelectedIndex = param1;
            this.m_UncommittedSelectedIndex = true;
            invalidateProperties();
            _loc2_ = new Event(Event.CHANGE);
            dispatchEvent(_loc2_);
         }
      }
      
      public function get layout() : int
      {
         throw new Error("ObjectRefSelectorBase.get layout: This method needs to be overridden in a subclass.");
      }
      
      public function set selectedObject(param1:TradeObjectRef) : void
      {
         var _loc2_:int = 0;
         if(this.dataProvider != null && param1 != null)
         {
            _loc2_ = this.dataProvider.length - 1;
            while(_loc2_ >= 0)
            {
               if(TradeObjectRef(this.dataProvider.getItemAt(_loc2_)).equals(param1))
               {
                  this.selectedIndex = _loc2_;
                  return;
               }
               _loc2_--;
            }
         }
         this.selectedIndex = -1;
      }
      
      public function set dataProvider(param1:IList) : void
      {
         if(this.m_DataProvider != param1)
         {
            this.m_DataProvider = param1;
            this.m_UncommittedDataProvider = true;
            this.m_UncommittedSortOrder = true;
            invalidateProperties();
         }
      }
      
      public function get selectedIndex() : int
      {
         return this.m_SelectedIndex;
      }
      
      public function get selectedObject() : TradeObjectRef
      {
         if(this.dataProvider != null && this.selectedIndex > -1 && this.selectedIndex < this.dataProvider.length)
         {
            return TradeObjectRef(this.dataProvider.getItemAt(this.selectedIndex));
         }
         return null;
      }
      
      public function get dataProvider() : IList
      {
         return this.m_DataProvider;
      }
      
      protected function getTradeObjectByDisplayObject(param1:DisplayObject) : TradeObjectRef
      {
         while(param1 != null && !(param1 is Stage))
         {
            if(param1 is ListObjectRefItemRenderer)
            {
               return ListObjectRefItemRenderer(param1).data as TradeObjectRef;
            }
            if(param1 is SkinnedAppearanceRenderer)
            {
               return SkinnedAppearanceRenderer(param1).appearance as TradeObjectRef;
            }
            param1 = DisplayObject(param1.parent);
         }
         return null;
      }
   }
}
