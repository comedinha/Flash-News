package tibia.creatures
{
   import flash.events.Event;
   import mx.events.PropertyChangeEvent;
   import tibia.creatures.buddylistWidgetClasses.BuddylistWidgetView;
   import tibia.sidebar.Widget;
   import tibia.sidebar.sideBarWidgetClasses.WidgetView;
   
   public class BuddylistWidget extends Widget
   {
      
      public static const SORT_BY_ICON:int = 1;
      
      public static const SORT_BY_NAME:int = 0;
      
      public static const SORT_BY_STATUS:int = 2;
       
      
      private var m_BuddySet:BuddySet = null;
      
      private var m_ShowOffline:Boolean = true;
      
      private var m_SortOrder:int = 0;
      
      public function BuddylistWidget()
      {
         super();
      }
      
      public function set sortOrder(param1:int) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Event = null;
         if(param1 != SORT_BY_ICON && param1 != SORT_BY_NAME && param1 != SORT_BY_STATUS)
         {
            param1 = SORT_BY_NAME;
         }
         if(this.m_SortOrder != param1)
         {
            _loc2_ = this.m_SortOrder;
            this.m_SortOrder = param1;
            _loc3_ = new Event(Widget.EVENT_OPTIONS_CHANGE);
            dispatchEvent(_loc3_);
            if(_loc3_.cancelable && _loc3_.isDefaultPrevented())
            {
               this.m_SortOrder = _loc2_;
            }
            if(m_ViewInstance is BuddylistWidgetView)
            {
               BuddylistWidgetView(m_ViewInstance).sortOrder = this.m_SortOrder;
            }
         }
      }
      
      override public function releaseViewInstance() : void
      {
         options = null;
         super.releaseViewInstance();
      }
      
      public function get buddySet() : BuddySet
      {
         return this.m_BuddySet;
      }
      
      private function updateBuddySet() : void
      {
         if(m_Options != null)
         {
            this.buddySet = m_Options.getBuddySet(BuddySet.DEFAULT_SET);
         }
      }
      
      public function get showOffline() : Boolean
      {
         return this.m_ShowOffline;
      }
      
      override public function unmarshall(param1:XML, param2:int) : void
      {
         super.unmarshall(param1,param2);
         var _loc3_:XMLList = null;
         if((_loc3_ = param1.@showOffline) != null && _loc3_.length() == 1)
         {
            this.showOffline = _loc3_[0].toString() == "true";
         }
         if((_loc3_ = param1.@sortOrder) != null && _loc3_.length() == 1)
         {
            this.sortOrder = int(_loc3_[0].toString());
         }
      }
      
      public function set showOffline(param1:Boolean) : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:Event = null;
         if(this.m_ShowOffline != param1)
         {
            _loc2_ = this.m_ShowOffline;
            this.m_ShowOffline = param1;
            _loc3_ = new Event(Widget.EVENT_OPTIONS_CHANGE);
            dispatchEvent(_loc3_);
            if(_loc3_.cancelable && _loc3_.isDefaultPrevented())
            {
               this.m_ShowOffline = _loc2_;
            }
            if(m_ViewInstance is BuddylistWidgetView)
            {
               BuddylistWidgetView(m_ViewInstance).showOffline = this.m_ShowOffline;
            }
         }
      }
      
      override protected function onOptionsChange(param1:PropertyChangeEvent) : void
      {
         super.onOptionsChange(param1);
         switch(param1.property)
         {
            case "buddySet":
            case "*":
               this.updateBuddySet();
         }
      }
      
      public function get sortOrder() : int
      {
         return this.m_SortOrder;
      }
      
      override public function marshall() : XML
      {
         var _loc1_:XML = super.marshall();
         _loc1_.@showOffline = this.showOffline;
         _loc1_.@sortOrder = this.sortOrder;
         return _loc1_;
      }
      
      override protected function commitOptions() : void
      {
         super.commitOptions();
         this.updateBuddySet();
      }
      
      override public function acquireViewInstance(param1:Boolean = true) : WidgetView
      {
         options = Tibia.s_GetOptions();
         var _loc2_:BuddylistWidgetView = super.acquireViewInstance(param1) as BuddylistWidgetView;
         if(_loc2_ != null)
         {
            _loc2_.buddySet = this.buddySet;
            _loc2_.showOffline = this.showOffline;
            _loc2_.sortOrder = this.sortOrder;
         }
         return _loc2_;
      }
      
      public function set buddySet(param1:BuddySet) : void
      {
         if(this.m_BuddySet != param1)
         {
            this.m_BuddySet = param1;
            if(m_ViewInstance is BuddylistWidgetView)
            {
               BuddylistWidgetView(m_ViewInstance).buddySet = this.m_BuddySet;
            }
         }
      }
   }
}
