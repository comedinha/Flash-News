package tibia.sidebar
{
   import flash.events.EventDispatcher;
   import flash.events.Event;
   import mx.events.PropertyChangeEvent;
   import mx.events.PropertyChangeEventKind;
   import mx.events.CollectionEvent;
   import mx.core.EventPriority;
   
   public class SideBarSet extends EventDispatcher
   {
      
      public static const DEFAULT_SET:int = 0;
      
      public static const NUM_LOCATIONS:int = 4;
      
      protected static const OPTIONS_MAX_COMPATIBLE_VERSION:Number = 5;
      
      public static const NUM_SETS:int = 1;
      
      public static const LOCATION_A:int = 2;
      
      public static const LOCATION_B:int = 0;
      
      public static const LOCATION_C:int = 1;
      
      public static const LOCATION_D:int = 3;
      
      protected static const OPTIONS_MIN_COMPATIBLE_VERSION:Number = 2;
       
      
      protected var m_DefaultLocations:Vector.<int> = null;
      
      protected var m_SideBars:Vector.<tibia.sidebar.SideBar> = null;
      
      protected var m_ID:int = -1;
      
      private var m_PoolFreeID:int = 0;
      
      protected var m_Widgets:Vector.<tibia.sidebar.Widget> = null;
      
      public function SideBarSet(param1:int)
      {
         super();
         this.m_ID = param1;
         this.m_DefaultLocations = new Vector.<int>(tibia.sidebar.Widget.TYPES_BEYONDLAST,true);
         var _loc2_:int = 0;
         _loc2_ = this.m_DefaultLocations.length - 1;
         while(_loc2_ >= 0)
         {
            this.m_DefaultLocations[_loc2_] = SideBarSet.LOCATION_C;
            _loc2_--;
         }
         this.m_SideBars = new Vector.<tibia.sidebar.SideBar>(SideBarSet.NUM_LOCATIONS,true);
         _loc2_ = this.m_SideBars.length - 1;
         while(_loc2_ >= 0)
         {
            this.m_SideBars[_loc2_] = new tibia.sidebar.SideBar(this,_loc2_);
            this.m_SideBars[_loc2_].addEventListener(CollectionEvent.COLLECTION_CHANGE,this.onSideBarEvent,false,EventPriority.DEFAULT_HANDLER,false);
            this.m_SideBars[_loc2_].addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onSideBarEvent,false,EventPriority.DEFAULT_HANDLER,false);
            _loc2_--;
         }
         this.m_Widgets = new Vector.<tibia.sidebar.Widget>();
      }
      
      public static function s_CheckLocation(param1:int) : Boolean
      {
         return param1 == SideBarSet.LOCATION_A || param1 == SideBarSet.LOCATION_B || param1 == SideBarSet.LOCATION_C || param1 == SideBarSet.LOCATION_D;
      }
      
      public static function s_Unmarshall(param1:XML, param2:Number) : SideBarSet
      {
         var _loc4_:int = 0;
         var _loc6_:XML = null;
         var _loc7_:XML = null;
         var _loc8_:Array = null;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:XML = null;
         var _loc12_:tibia.sidebar.Widget = null;
         var _loc13_:int = 0;
         var _loc14_:XML = null;
         var _loc15_:int = 0;
         if(param1 == null || param1.localName() != "sidebarset" || param2 < OPTIONS_MIN_COMPATIBLE_VERSION || param2 > OPTIONS_MAX_COMPATIBLE_VERSION)
         {
            throw new Error("SideBarSet.s_Unmarshall: Invalid input.");
         }
         var _loc3_:XMLList = null;
         if((_loc3_ = param1.@id) == null || _loc3_.length() != 1)
         {
            return null;
         }
         _loc4_ = parseInt(_loc3_[0].toString());
         var _loc5_:SideBarSet = new SideBarSet(_loc4_);
         if((_loc3_ = param1.@defaultLocation) != null && _loc3_.length() == 1)
         {
            _loc8_ = _loc3_[0].toString().split(",");
            _loc9_ = _loc8_.length - 1;
            while(_loc9_ >= 0)
            {
               _loc10_ = parseInt(_loc8_[_loc9_]);
               if(tibia.sidebar.Widget.s_CheckType(_loc9_) && SideBarSet.s_CheckLocation(_loc10_))
               {
                  _loc5_.setDefaultLocation(_loc9_,_loc10_);
               }
               _loc9_--;
            }
         }
         for each(_loc6_ in param1.elements("widgetset"))
         {
            for each(_loc11_ in _loc6_.elements("widget"))
            {
               _loc12_ = tibia.sidebar.Widget.s_Unmarshall(_loc11_,param2);
               if(_loc12_ != null)
               {
                  _loc5_.poolAddWidget(_loc12_);
               }
            }
         }
         for each(_loc7_ in param1.elements("sidebar"))
         {
            if(!((_loc3_ = _loc7_.@location) == null || _loc3_.length() != 1))
            {
               _loc13_ = parseInt(_loc3_[0].toString());
               if(SideBarSet.s_CheckLocation(_loc13_))
               {
                  if((_loc3_ = _loc7_.@visible) != null && _loc3_.length() == 1)
                  {
                     _loc5_.getSideBar(_loc13_).visible = _loc3_[0].toString() == "true";
                  }
                  if((_loc3_ = _loc7_.@foldHeader) != null && _loc3_.length() == 1)
                  {
                     _loc5_.getSideBar(_loc13_).foldHeader = _loc3_[0].toString() == "true";
                  }
                  for each(_loc14_ in _loc7_.elements("widgetref"))
                  {
                     if(!((_loc3_ = _loc14_.@id) == null || _loc3_.length() != 1))
                     {
                        _loc15_ = parseInt(_loc3_[0].toString());
                        if(_loc5_.poolGetWidget(_loc15_) != null)
                        {
                           _loc5_.showWidgetByID(_loc15_,_loc13_,-1);
                        }
                     }
                  }
               }
            }
         }
         return _loc5_;
      }
      
      public function getWidgetLength() : int
      {
         return this.m_Widgets.length;
      }
      
      public function showWidgetByID(param1:int, param2:int, param3:int) : tibia.sidebar.Widget
      {
         var _loc5_:Boolean = false;
         var _loc6_:Boolean = false;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         if(!SideBarSet.s_CheckLocation(param2))
         {
            return null;
         }
         var _loc4_:tibia.sidebar.Widget = this.poolGetWidget(param1);
         if(_loc4_ != null)
         {
            _loc5_ = false;
            _loc6_ = true;
            _loc7_ = this.m_SideBars.length - 1;
            while(_loc6_ && _loc7_ >= 0)
            {
               _loc8_ = this.m_SideBars[_loc7_].length - 1;
               while(_loc6_ && _loc8_ >= 0)
               {
                  if(this.m_SideBars[_loc7_].getWidgetIDAt(_loc8_) == _loc4_.ID)
                  {
                     if(_loc7_ == param2)
                     {
                        _loc5_ = true;
                     }
                     else
                     {
                        this.m_SideBars[_loc7_].removeWidgetAt(_loc8_);
                        _loc5_ = false;
                     }
                     _loc6_ = false;
                  }
                  _loc8_--;
               }
               _loc7_--;
            }
            if(tibia.sidebar.Widget.s_GetUnique(_loc4_.type))
            {
               this.setDefaultLocation(_loc4_.type,param2);
            }
            if(_loc5_)
            {
               this.m_SideBars[param2].setWidgetIndex(_loc4_,param3);
            }
            else
            {
               this.m_SideBars[param2].addWidgetAt(_loc4_,param3);
            }
         }
         return _loc4_;
      }
      
      private function poolFreeID() : int
      {
         if(this.m_Widgets.length >= int.MAX_VALUE)
         {
            return -1;
         }
         while(this.poolGetIndex(this.m_PoolFreeID) >= 0)
         {
            if(this.m_PoolFreeID < int.MAX_VALUE)
            {
               this.m_PoolFreeID++;
            }
            else
            {
               this.m_PoolFreeID = 0;
            }
         }
         return this.m_PoolFreeID;
      }
      
      protected function onSideBarEvent(param1:Event) : void
      {
         var _loc2_:PropertyChangeEvent = null;
         if(param1 != null && (!param1.cancelable || !param1.isDefaultPrevented()))
         {
            switch(param1.type)
            {
               case CollectionEvent.COLLECTION_CHANGE:
               case PropertyChangeEvent.PROPERTY_CHANGE:
                  _loc2_ = new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE);
                  _loc2_.kind = PropertyChangeEventKind.UPDATE;
                  _loc2_.property = "sideBarInstanceOptions";
                  _loc2_.source = param1.currentTarget;
                  dispatchEvent(_loc2_);
            }
         }
      }
      
      public function initialiseDefaultWidgets() : void
      {
         var _loc1_:int = this.m_DefaultLocations.length - 1;
         while(_loc1_ >= 0)
         {
            this.m_DefaultLocations[_loc1_] = SideBarSet.LOCATION_C;
            _loc1_--;
         }
         this.getSideBar(LOCATION_C).visible = true;
         this.showWidgetType(tibia.sidebar.Widget.TYPE_GENERALBUTTONS,LOCATION_C,-1);
         this.showWidgetType(tibia.sidebar.Widget.TYPE_MINIMAP,LOCATION_C,-1);
      }
      
      public function getSideBar(param1:int) : tibia.sidebar.SideBar
      {
         if(!SideBarSet.s_CheckLocation(param1))
         {
            return null;
         }
         return this.m_SideBars[param1];
      }
      
      public function hideWidgetType(param1:int, param2:int) : void
      {
         var _loc4_:int = 0;
         var _loc5_:tibia.sidebar.Widget = null;
         if(!tibia.sidebar.Widget.s_CheckType(param1))
         {
            return;
         }
         if(param2 > -1 && !SideBarSet.s_CheckLocation(param2))
         {
            return;
         }
         var _loc3_:int = this.m_SideBars.length - 1;
         while(_loc3_ >= 0)
         {
            _loc4_ = this.m_SideBars[_loc3_].length - 1;
            while((param2 < 0 || param2 == _loc3_) && _loc4_ >= 0)
            {
               _loc5_ = this.m_SideBars[_loc3_].getWidgetInstanceAt(_loc4_);
               if(_loc5_.type == param1)
               {
                  _loc5_.releaseViewInstance();
                  this.m_SideBars[_loc3_].removeWidgetAt(_loc4_);
                  if(!tibia.sidebar.Widget.s_GetUnique(_loc5_.type) || !tibia.sidebar.Widget.s_GetRestorable(_loc5_.type))
                  {
                     this.poolRemoveWidget(_loc5_.ID);
                  }
               }
               _loc4_--;
            }
            _loc3_--;
         }
      }
      
      private function poolAddWidget(param1:tibia.sidebar.Widget) : tibia.sidebar.Widget
      {
         var _loc2_:int = 0;
         if(param1 == null)
         {
            return null;
         }
         if(tibia.sidebar.Widget.s_GetUnique(param1.type))
         {
            _loc2_ = this.m_Widgets.length - 1;
            while(_loc2_ >= 0)
            {
               if(this.m_Widgets[_loc2_].type == param1.type)
               {
                  return null;
               }
               _loc2_--;
            }
         }
         _loc2_ = this.poolGetIndex(param1.ID);
         if(_loc2_ > -1)
         {
            return null;
         }
         this.m_Widgets.splice(-_loc2_ - 1,0,param1);
         param1.addEventListener(tibia.sidebar.Widget.EVENT_CLOSE,this.onWidgetEvent,false,EventPriority.DEFAULT_HANDLER,false);
         param1.addEventListener(tibia.sidebar.Widget.EVENT_OPTIONS_CHANGE,this.onWidgetEvent,false,EventPriority.DEFAULT_HANDLER,false);
         return param1;
      }
      
      public function getWidgetByType(param1:int) : tibia.sidebar.Widget
      {
         if(!tibia.sidebar.Widget.s_CheckType(param1))
         {
            return null;
         }
         var _loc2_:int = this.m_Widgets.length - 1;
         while(_loc2_ >= 0)
         {
            if(this.m_Widgets[_loc2_].type == param1)
            {
               return this.m_Widgets[_loc2_];
            }
            _loc2_--;
         }
         return null;
      }
      
      public function getWidgetByID(param1:int) : tibia.sidebar.Widget
      {
         return this.poolGetWidget(param1);
      }
      
      public function countWidgetType(param1:int, param2:int) : int
      {
         var _loc5_:tibia.sidebar.SideBar = null;
         var _loc6_:int = 0;
         var _loc7_:tibia.sidebar.Widget = null;
         if(!tibia.sidebar.Widget.s_CheckType(param1))
         {
            return 0;
         }
         if(param2 > -1 && !SideBarSet.s_CheckLocation(param2))
         {
            return 0;
         }
         var _loc3_:int = 0;
         var _loc4_:int = this.m_SideBars.length - 1;
         while(_loc4_ >= 0)
         {
            if(param2 < 0 || param2 == _loc4_)
            {
               _loc5_ = this.m_SideBars[_loc4_];
               _loc6_ = _loc5_.length - 1;
               while(_loc6_ >= 0)
               {
                  _loc7_ = _loc5_.getWidgetInstanceAt(_loc6_);
                  if(_loc7_.type == param1)
                  {
                     _loc3_++;
                  }
                  _loc6_--;
               }
            }
            _loc4_--;
         }
         return _loc3_;
      }
      
      public function marshall() : XML
      {
         var _loc1_:XML = <sidebarset id="{this.m_ID}" defaultLocation="{this.m_DefaultLocations.join(",")}"/>;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:XML = <widgetset/>;
         _loc2_ = 0;
         _loc4_ = this.m_Widgets.length;
         while(_loc2_ < _loc4_)
         {
            if(tibia.sidebar.Widget.s_GetRestorable(this.m_Widgets[_loc2_].type))
            {
               _loc6_.appendChild(this.m_Widgets[_loc2_].marshall());
            }
            _loc2_++;
         }
         _loc1_.appendChild(_loc6_);
         var _loc7_:XML = null;
         var _loc8_:int = 0;
         _loc2_ = 0;
         _loc4_ = this.m_SideBars.length;
         while(_loc2_ < _loc4_)
         {
            _loc7_ = <sidebar foldHeader="{this.m_SideBars[_loc2_].foldHeader}" location="{this.m_SideBars[_loc2_].location}" visible="{this.m_SideBars[_loc2_].visible}"/>;
            _loc3_ = 0;
            _loc5_ = this.m_SideBars[_loc2_].length;
            while(_loc3_ < _loc5_)
            {
               _loc8_ = this.m_SideBars[_loc2_].getWidgetIDAt(_loc3_);
               if(tibia.sidebar.Widget.s_GetRestorable(this.poolGetWidget(_loc8_).type))
               {
                  _loc7_.appendChild(<widgetref id="{_loc8_}"/>);
               }
               _loc3_++;
            }
            _loc1_.appendChild(_loc7_);
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function getSideBarLength() : int
      {
         return this.m_SideBars.length;
      }
      
      public function setDefaultLocation(param1:int, param2:int) : void
      {
         var _loc3_:PropertyChangeEvent = null;
         if(!tibia.sidebar.Widget.s_CheckType(param1))
         {
            return;
         }
         if(!SideBarSet.s_CheckLocation(param2))
         {
            return;
         }
         if(this.m_DefaultLocations[param1] != param2)
         {
            this.m_DefaultLocations[param1] = param2;
            _loc3_ = new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE);
            _loc3_.property = "defaultLocation";
            _loc3_.kind = PropertyChangeEventKind.UPDATE;
            dispatchEvent(_loc3_);
            if(param1 == tibia.sidebar.Widget.TYPE_NPCTRADE)
            {
               this.setDefaultLocation(tibia.sidebar.Widget.TYPE_SAFETRADE,param2);
            }
            if(param1 == tibia.sidebar.Widget.TYPE_SAFETRADE)
            {
               this.setDefaultLocation(tibia.sidebar.Widget.TYPE_NPCTRADE,param2);
            }
         }
      }
      
      protected function onWidgetEvent(param1:Event) : void
      {
         var _loc2_:tibia.sidebar.Widget = null;
         var _loc3_:PropertyChangeEvent = null;
         if(param1 != null && (!param1.cancelable || !param1.isDefaultPrevented()))
         {
            _loc2_ = Widget(param1.currentTarget);
            switch(param1.type)
            {
               case tibia.sidebar.Widget.EVENT_CLOSE:
                  this.hideWidgetByID(_loc2_.ID);
                  break;
               case tibia.sidebar.Widget.EVENT_OPTIONS_CHANGE:
                  if(tibia.sidebar.Widget.s_GetUnique(_loc2_.type) && tibia.sidebar.Widget.s_GetRestorable(_loc2_.type))
                  {
                     _loc3_ = new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE);
                     _loc3_.kind = PropertyChangeEventKind.UPDATE;
                     _loc3_.property = "widgetInstanceOptions";
                     _loc3_.source = _loc2_;
                     dispatchEvent(_loc3_);
                  }
                  break;
               default:
                  dispatchEvent(param1);
            }
         }
      }
      
      private function poolGetIndex(param1:int) : int
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = this.m_Widgets.length - 1;
         while(_loc3_ <= _loc4_)
         {
            _loc2_ = _loc3_ + _loc4_ >>> 1;
            if(this.m_Widgets[_loc2_].ID < param1)
            {
               _loc3_ = _loc2_ + 1;
               continue;
            }
            if(this.m_Widgets[_loc2_].ID > param1)
            {
               _loc4_ = _loc2_ - 1;
               continue;
            }
            return _loc2_;
         }
         return -_loc3_ - 1;
      }
      
      public function closeVolatileWidgets() : void
      {
         var _loc2_:tibia.sidebar.Widget = null;
         var _loc1_:int = this.m_Widgets.length - 1;
         while(_loc1_ >= 0)
         {
            _loc2_ = this.m_Widgets[_loc1_];
            if(_loc2_ != null && (!tibia.sidebar.Widget.s_GetUnique(_loc2_.type) || !tibia.sidebar.Widget.s_GetRestorable(_loc2_.type)))
            {
               this.hideWidgetByID(_loc2_.ID);
            }
            _loc1_--;
         }
      }
      
      public function insertOrphanWidget(param1:tibia.sidebar.Widget, param2:int, param3:int) : void
      {
         if(param1 == null)
         {
            return;
         }
         this.poolAddWidget(param1);
         this.showWidgetByID(param1.ID,param2,param3);
      }
      
      public function getDefaultLocation(param1:int) : int
      {
         return this.m_DefaultLocations[param1];
      }
      
      public function get ID() : int
      {
         return this.m_ID;
      }
      
      private function poolRemoveWidget(param1:int) : tibia.sidebar.Widget
      {
         var _loc2_:tibia.sidebar.Widget = null;
         var _loc3_:int = this.poolGetIndex(param1);
         if(_loc3_ > -1)
         {
            _loc2_ = this.m_Widgets.splice(_loc3_,1)[0];
            _loc2_.removeEventListener(tibia.sidebar.Widget.EVENT_CLOSE,this.onWidgetEvent);
            _loc2_.removeEventListener(tibia.sidebar.Widget.EVENT_OPTIONS_CHANGE,this.onWidgetEvent);
         }
         if(_loc2_ != null)
         {
            _loc2_.options = null;
            _loc2_.releaseViewInstance();
         }
         return _loc2_;
      }
      
      public function hideAllWidgets() : void
      {
         var _loc1_:int = this.m_Widgets.length - 1;
         while(_loc1_ >= 0)
         {
            if(this.m_Widgets[_loc1_] != null)
            {
               this.hideWidgetByID(this.m_Widgets[_loc1_].ID);
            }
            _loc1_--;
         }
      }
      
      public function hideWidgetByID(param1:int) : void
      {
         var _loc3_:int = 0;
         var _loc4_:tibia.sidebar.Widget = null;
         var _loc2_:int = this.m_SideBars.length - 1;
         while(_loc2_ >= 0)
         {
            _loc3_ = this.m_SideBars[_loc2_].length - 1;
            while(_loc3_ >= 0)
            {
               _loc4_ = this.m_SideBars[_loc2_].getWidgetInstanceAt(_loc3_);
               if(_loc4_.ID == param1)
               {
                  _loc4_.releaseViewInstance();
                  this.m_SideBars[_loc2_].removeWidgetAt(_loc3_);
                  if(!tibia.sidebar.Widget.s_GetUnique(_loc4_.type) || !tibia.sidebar.Widget.s_GetRestorable(_loc4_.type))
                  {
                     this.poolRemoveWidget(param1);
                  }
                  return;
               }
               _loc3_--;
            }
            _loc2_--;
         }
      }
      
      public function showWidgetType(param1:int, param2:int, param3:int) : tibia.sidebar.Widget
      {
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:* = false;
         if(!tibia.sidebar.Widget.s_CheckType(param1))
         {
            return null;
         }
         if(param2 < 0)
         {
            param2 = this.getDefaultLocation(param1);
         }
         if(!SideBarSet.s_CheckLocation(param2))
         {
            return null;
         }
         var _loc4_:tibia.sidebar.Widget = null;
         var _loc5_:Boolean = false;
         if(tibia.sidebar.Widget.s_GetUnique(param1))
         {
            _loc6_ = 0;
            _loc7_ = 0;
            _loc6_ = this.m_Widgets.length - 1;
            while(_loc6_ >= 0)
            {
               if(this.m_Widgets[_loc6_].type == param1)
               {
                  _loc4_ = this.m_Widgets[_loc6_];
                  break;
               }
               _loc6_--;
            }
            _loc8_ = _loc4_ != null;
            _loc6_ = this.m_SideBars.length - 1;
            while(_loc8_ && _loc6_ >= 0)
            {
               _loc7_ = this.m_SideBars[_loc6_].length - 1;
               while(_loc8_ && _loc7_ >= 0)
               {
                  if(this.m_SideBars[_loc6_].getWidgetIDAt(_loc7_) == _loc4_.ID)
                  {
                     if(_loc6_ == param2)
                     {
                        _loc5_ = true;
                     }
                     else
                     {
                        this.m_SideBars[_loc6_].removeWidgetAt(_loc7_);
                        _loc5_ = false;
                     }
                     _loc8_ = false;
                  }
                  _loc7_--;
               }
               _loc6_--;
            }
            this.setDefaultLocation(param1,param2);
         }
         if(_loc4_ == null)
         {
            _loc4_ = this.poolAddWidget(tibia.sidebar.Widget.s_CreateInstance(param1,this.poolFreeID()));
         }
         if(_loc5_)
         {
            return this.m_SideBars[param2].setWidgetIndex(_loc4_,param3);
         }
         return this.m_SideBars[param2].addWidgetAt(_loc4_,param3);
      }
      
      private function poolGetWidget(param1:int) : tibia.sidebar.Widget
      {
         var _loc2_:int = this.poolGetIndex(param1);
         if(_loc2_ > -1)
         {
            return this.m_Widgets[_loc2_];
         }
         return null;
      }
   }
}
