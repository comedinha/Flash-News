package tibia.container
{
   import flash.events.EventDispatcher;
   import shared.utility.Vector3D;
   import tibia.game.Delay;
   import tibia.appearances.AppearanceTypeRef;
   import tibia.options.OptionsStorage;
   import tibia.sidebar.SideBarSet;
   import mx.events.PropertyChangeEvent;
   import mx.events.PropertyChangeEventKind;
   import tibia.appearances.ObjectInstance;
   import tibia.sidebar.Widget;
   
   public class ContainerStorage extends EventDispatcher
   {
      
      public static const MAX_CONTAINER_VIEWS:int = 16;
      
      public static const MIN_MULTI_USE_DELAY:int = 1000;
      
      public static const INVENTORY_ANY:Vector3D = new Vector3D(65535,0,0);
      
      public static const MIN_USE_DELAY:int = 100;
      
      public static const MAX_NAME_LENGTH:int = 30;
       
      
      protected var m_MultiuseDelay:Delay = null;
      
      protected var m_PlayerInventory:Vector.<tibia.container.InventoryTypeInfo> = null;
      
      protected var m_PlayerGoods:Vector.<tibia.container.InventoryTypeInfo> = null;
      
      protected var m_BodyContainerView:tibia.container.BodyContainerView = null;
      
      protected var m_PlayerMoney:Number = 0;
      
      protected var m_ContainerViews:Vector.<tibia.container.ContainerView> = null;
      
      protected var m_ContainerViewWidgets:Vector.<int> = null;
      
      public function ContainerStorage()
      {
         super();
         this.m_BodyContainerView = new tibia.container.BodyContainerView();
         this.m_BodyContainerView.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onBodyContainerChange);
         this.m_MultiuseDelay = new Delay(0,0);
         this.m_ContainerViews = new Vector.<tibia.container.ContainerView>(MAX_CONTAINER_VIEWS,true);
         this.m_ContainerViewWidgets = new Vector.<int>(MAX_CONTAINER_VIEWS,true);
         var _loc1_:int = 0;
         while(_loc1_ < MAX_CONTAINER_VIEWS)
         {
            this.m_ContainerViewWidgets[_loc1_] = -1;
            _loc1_++;
         }
         this.m_PlayerInventory = new Vector.<tibia.container.InventoryTypeInfo>();
         this.reset();
      }
      
      public function getPlayerInventory() : Vector.<tibia.container.InventoryTypeInfo>
      {
         return this.m_PlayerInventory;
      }
      
      public function getAvailableGoods(param1:int, param2:int) : int
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         if(this.m_PlayerGoods != null)
         {
            _loc3_ = 0;
            _loc4_ = this.m_PlayerGoods.length - 1;
            _loc5_ = 0;
            _loc6_ = 0;
            while(_loc3_ <= _loc4_)
            {
               _loc5_ = _loc3_ + _loc4_ >>> 1;
               _loc6_ = AppearanceTypeRef.s_CompareExternal(this.m_PlayerGoods[_loc5_],param1,param2);
               if(_loc6_ < 0)
               {
                  _loc3_ = _loc5_ + 1;
                  continue;
               }
               if(_loc6_ > 0)
               {
                  _loc4_ = _loc5_ - 1;
                  continue;
               }
               return this.m_PlayerGoods[_loc5_].count;
            }
         }
         return 0;
      }
      
      public function getBodyContainerView() : tibia.container.BodyContainerView
      {
         return this.m_BodyContainerView;
      }
      
      public function reset() : void
      {
         this.m_BodyContainerView.reset();
         var _loc1_:int = 0;
         while(_loc1_ < MAX_CONTAINER_VIEWS)
         {
            if(this.m_ContainerViews[_loc1_] != null)
            {
               this.m_ContainerViews[_loc1_].removeAll();
               this.m_ContainerViews[_loc1_] = null;
            }
            _loc1_++;
         }
         var _loc2_:OptionsStorage = Tibia.s_GetOptions();
         var _loc3_:SideBarSet = null;
         if(_loc2_ != null)
         {
            _loc3_ = _loc2_.getSideBarSet(SideBarSet.DEFAULT_SET);
         }
         var _loc4_:int = 0;
         while(_loc4_ < MAX_CONTAINER_VIEWS)
         {
            if(this.m_ContainerViewWidgets[_loc4_] > -1 && _loc3_ != null)
            {
               _loc3_.hideWidgetByID(this.m_ContainerViewWidgets[_loc4_]);
            }
            this.m_ContainerViewWidgets[_loc4_] = -1;
            _loc4_++;
         }
         this.m_MultiuseDelay = new Delay(0,0);
         this.m_PlayerMoney = 0;
         this.m_PlayerGoods = null;
         this.m_PlayerInventory.length = 0;
      }
      
      public function getContainerView(param1:int) : tibia.container.ContainerView
      {
         if(param1 < 0 || param1 >= MAX_CONTAINER_VIEWS)
         {
            throw new RangeError("ContainerStorage.getOpenContainer: Invalid container number: " + param1);
         }
         return this.m_ContainerViews[param1];
      }
      
      public function setMultiUseDelay(param1:Number) : void
      {
         this.m_MultiuseDelay.start = Tibia.s_FrameTibiaTimestamp;
         this.m_MultiuseDelay.end = Tibia.s_FrameTibiaTimestamp + param1;
      }
      
      public function getAvailableInventory(param1:int, param2:int) : int
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         if(this.m_PlayerInventory != null)
         {
            _loc3_ = 0;
            _loc4_ = this.m_PlayerInventory.length - 1;
            _loc5_ = 0;
            _loc6_ = 0;
            while(_loc3_ <= _loc4_)
            {
               _loc5_ = _loc3_ + _loc4_ >>> 1;
               _loc6_ = AppearanceTypeRef.s_CompareExternal(this.m_PlayerInventory[_loc5_],param1,param2);
               if(_loc6_ < 0)
               {
                  _loc3_ = _loc5_ + 1;
                  continue;
               }
               if(_loc6_ > 0)
               {
                  _loc4_ = _loc5_ - 1;
                  continue;
               }
               return this.m_PlayerInventory[_loc5_].count;
            }
         }
         return 0;
      }
      
      public function setPlayerMoney(param1:Number) : void
      {
         var _loc2_:PropertyChangeEvent = null;
         if(this.m_PlayerMoney != param1)
         {
            this.m_PlayerMoney = param1;
            _loc2_ = new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE);
            _loc2_.kind = PropertyChangeEventKind.UPDATE;
            _loc2_.property = "playerMoney";
            dispatchEvent(_loc2_);
         }
      }
      
      public function getMultiUseDelay() : Delay
      {
         return this.m_MultiuseDelay.clone();
      }
      
      public function getFreeContainerViewID() : int
      {
         var _loc1_:int = 0;
         while(_loc1_ < MAX_CONTAINER_VIEWS)
         {
            if(this.m_ContainerViews[_loc1_] == null)
            {
               return _loc1_;
            }
            _loc1_++;
         }
         return MAX_CONTAINER_VIEWS - _loc1_;
      }
      
      public function getPlayerMoney() : Number
      {
         return this.m_PlayerMoney;
      }
      
      public function createContainerView(param1:int, param2:ObjectInstance, param3:String, param4:Boolean, param5:Boolean, param6:Boolean, param7:int, param8:int, param9:int) : tibia.container.ContainerView
      {
         var _loc13_:ContainerViewWidget = null;
         if(param1 < 0 || param1 >= MAX_CONTAINER_VIEWS)
         {
            throw new RangeError("ContainerStorage.setOpenContainer: Invalid container number: " + param1);
         }
         var _loc10_:tibia.container.ContainerView = new tibia.container.ContainerView(param1,param2,param3,param4,param5,param6,param7,param8,param9);
         this.m_ContainerViews[param1] = _loc10_;
         var _loc11_:OptionsStorage = Tibia.s_GetOptions();
         var _loc12_:SideBarSet = null;
         if(_loc11_ != null && (_loc12_ = _loc11_.getSideBarSet(SideBarSet.DEFAULT_SET)) != null)
         {
            _loc13_ = null;
            if(this.m_ContainerViewWidgets[param1] > -1)
            {
               _loc13_ = _loc12_.getWidgetByID(this.m_ContainerViewWidgets[param1]) as ContainerViewWidget;
            }
            if(_loc13_ == null)
            {
               _loc13_ = ContainerViewWidget(_loc12_.showWidgetType(Widget.TYPE_CONTAINER,-1,-1));
            }
            _loc13_.container = _loc10_;
            this.m_ContainerViewWidgets[param1] = _loc13_.ID;
         }
         return _loc10_;
      }
      
      public function closeContainerView(param1:int) : void
      {
         if(param1 < 0 || param1 >= MAX_CONTAINER_VIEWS)
         {
            throw new RangeError("ContainerStorage.closeContainerView: Invalid container number: " + param1);
         }
         this.m_ContainerViews[param1] = null;
         var _loc2_:OptionsStorage = Tibia.s_GetOptions();
         var _loc3_:SideBarSet = null;
         if(this.m_ContainerViewWidgets[param1] > -1)
         {
            if(_loc2_ != null && (_loc3_ = _loc2_.getSideBarSet(SideBarSet.DEFAULT_SET)) != null)
            {
               _loc3_.hideWidgetByID(this.m_ContainerViewWidgets[param1]);
            }
            this.m_ContainerViewWidgets[param1] = -1;
         }
      }
      
      protected function onBodyContainerChange(param1:PropertyChangeEvent) : void
      {
         var _loc2_:PropertyChangeEvent = null;
         if((!param1.cancelable || !param1.isDefaultPrevented()) && param1.property == "objects")
         {
            _loc2_ = new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE);
            _loc2_.kind = PropertyChangeEventKind.UPDATE;
            _loc2_.property = "bodyItem";
            _loc2_.source = param1.currentTarget;
            dispatchEvent(_loc2_);
         }
      }
      
      public function setPlayerInventory(param1:Vector.<tibia.container.InventoryTypeInfo>) : void
      {
         var _loc2_:PropertyChangeEvent = null;
         if(param1 == null)
         {
            throw new ArgumentError("ContainerStorage.setPlayerInventory: Invalid inventory.");
         }
         if(this.m_PlayerInventory != param1)
         {
            this.m_PlayerInventory = param1;
            _loc2_ = new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE);
            _loc2_.kind = PropertyChangeEventKind.UPDATE;
            _loc2_.property = "playerInventory";
            dispatchEvent(_loc2_);
         }
      }
      
      public function setPlayerGoods(param1:Vector.<tibia.container.InventoryTypeInfo>) : void
      {
         var _loc2_:PropertyChangeEvent = null;
         if(param1 == null)
         {
            throw new ArgumentError("ContainerStorage.setPlayerGoods: Invalid goods.");
         }
         if(this.m_PlayerGoods != param1)
         {
            this.m_PlayerGoods = param1;
            _loc2_ = new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE);
            _loc2_.kind = PropertyChangeEventKind.UPDATE;
            _loc2_.property = "playerGoods";
            dispatchEvent(_loc2_);
         }
      }
      
      public function getPlayerGoods() : Vector.<tibia.container.InventoryTypeInfo>
      {
         return this.m_PlayerGoods;
      }
   }
}
