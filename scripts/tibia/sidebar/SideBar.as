package tibia.sidebar
{
   import flash.events.EventDispatcher;
   import mx.events.CollectionEvent;
   import mx.events.CollectionEventKind;
   import mx.events.PropertyChangeEvent;
   
   public class SideBar extends EventDispatcher
   {
      
      protected static const OPTIONS_MAX_COMPATIBLE_VERSION:Number = 5;
      
      protected static const OPTIONS_MIN_COMPATIBLE_VERSION:Number = 2;
       
      
      private var m_Visible:Boolean = false;
      
      private var m_WidgetID:Vector.<int> = null;
      
      private var m_FoldHeader:Boolean = false;
      
      private var m_Location:int = -1;
      
      private var m_SideBarSet:SideBarSet = null;
      
      public function SideBar(param1:SideBarSet, param2:int)
      {
         super();
         this.m_SideBarSet = param1;
         this.m_Location = param2;
         this.m_WidgetID = new Vector.<int>();
      }
      
      public function getWidgetInstanceAt(param1:int) : Widget
      {
         return this.m_SideBarSet.getWidgetByID(this.m_WidgetID[param1]);
      }
      
      function addWidget(param1:Widget) : Widget
      {
         return this.addWidgetAt(param1,this.m_WidgetID.length);
      }
      
      public function get sideBarSet() : SideBarSet
      {
         return this.m_SideBarSet;
      }
      
      public function getWidgetIndexByID(param1:int) : int
      {
         var _loc2_:int = this.m_WidgetID.length - 1;
         while(_loc2_ >= 0)
         {
            if(this.m_WidgetID[_loc2_] == param1)
            {
               return _loc2_;
            }
            _loc2_--;
         }
         return -1;
      }
      
      private function set _1669917202foldHeader(param1:Boolean) : void
      {
         if(this.m_FoldHeader != param1)
         {
            this.m_FoldHeader = param1;
         }
      }
      
      public function reset() : void
      {
         this.m_SideBarSet = null;
         this.removeAllWidgets();
      }
      
      private function set _466743410visible(param1:Boolean) : void
      {
         if(this.m_Visible != param1)
         {
            this.m_Visible = param1;
         }
      }
      
      [Bindable(event="propertyChange")]
      public function set foldHeader(param1:Boolean) : void
      {
         var _loc2_:Object = this.foldHeader;
         if(_loc2_ !== param1)
         {
            this._1669917202foldHeader = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"foldHeader",_loc2_,param1));
         }
      }
      
      function addWidgetAt(param1:Widget, param2:int) : Widget
      {
         if(param1 == null)
         {
            return null;
         }
         if(param2 >= 0 && param2 < this.m_WidgetID.length)
         {
            this.m_WidgetID.splice(param2,0,param1.ID);
         }
         else
         {
            param2 = this.m_WidgetID.length;
            this.m_WidgetID.push(param1.ID);
         }
         var _loc3_:CollectionEvent = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE);
         _loc3_.kind = CollectionEventKind.ADD;
         _loc3_.location = param2;
         _loc3_.items = [param1];
         dispatchEvent(_loc3_);
         return param1;
      }
      
      public function getWidgetInstanceIndex(param1:Widget) : int
      {
         if(param1 != null)
         {
            return this.getWidgetIndexByID(param1.ID);
         }
         return -1;
      }
      
      [Bindable(event="propertyChange")]
      public function set visible(param1:Boolean) : void
      {
         var _loc2_:Object = this.visible;
         if(_loc2_ !== param1)
         {
            this._466743410visible = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"visible",_loc2_,param1));
         }
      }
      
      public function get length() : int
      {
         return this.m_WidgetID.length;
      }
      
      public function getWidgetIDAt(param1:int) : int
      {
         return this.m_WidgetID[param1];
      }
      
      function setWidgetIndex(param1:Widget, param2:int) : Widget
      {
         var _loc4_:int = 0;
         var _loc5_:CollectionEvent = null;
         if(param1 == null)
         {
            return null;
         }
         var _loc3_:int = this.getWidgetInstanceIndex(param1);
         if(_loc3_ < 0)
         {
            return null;
         }
         if(param2 < 0 || param2 > this.m_WidgetID.length - 1)
         {
            param2 = this.m_WidgetID.length - 1;
         }
         if(_loc3_ != param2)
         {
            _loc4_ = 0;
            if(_loc3_ > param2)
            {
               _loc4_ = _loc3_;
               while(_loc4_ > param2)
               {
                  this.m_WidgetID[_loc4_] = this.m_WidgetID[_loc4_ - 1];
                  _loc4_--;
               }
            }
            if(_loc3_ < param2)
            {
               _loc4_ = _loc3_;
               while(_loc4_ < param2)
               {
                  this.m_WidgetID[_loc4_] = this.m_WidgetID[_loc4_ + 1];
                  _loc4_++;
               }
            }
            this.m_WidgetID[param2] = param1.ID;
            _loc5_ = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE);
            _loc5_.kind = CollectionEventKind.MOVE;
            _loc5_.oldLocation = _loc3_;
            _loc5_.location = param2;
            _loc5_.items = [param1];
            dispatchEvent(_loc5_);
         }
         return param1;
      }
      
      public function get foldHeader() : Boolean
      {
         return this.m_FoldHeader;
      }
      
      function removeWidget(param1:Widget) : Widget
      {
         return this.removeWidgetAt(this.getWidgetInstanceIndex(param1));
      }
      
      public function get visible() : Boolean
      {
         return this.m_Visible;
      }
      
      public function get location() : int
      {
         return this.m_Location;
      }
      
      function removeAllWidgets() : void
      {
         this.m_WidgetID.length = 0;
         var _loc1_:CollectionEvent = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE);
         _loc1_.kind = CollectionEventKind.RESET;
         dispatchEvent(_loc1_);
      }
      
      function removeWidgetAt(param1:int) : Widget
      {
         var _loc2_:Widget = null;
         var _loc3_:CollectionEvent = null;
         if(param1 >= 0 && param1 < this.m_WidgetID.length)
         {
            _loc2_ = this.m_SideBarSet.getWidgetByID(this.m_WidgetID.splice(param1,1)[0]);
            _loc3_ = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE);
            _loc3_.kind = CollectionEventKind.REMOVE;
            _loc3_.location = param1;
            _loc3_.items = [_loc2_];
            dispatchEvent(_loc3_);
            return _loc2_;
         }
         return null;
      }
   }
}
