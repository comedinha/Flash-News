package tibia.sidebar
{
   import flash.events.EventDispatcher;
   import tibia.creatures.BattlelistWidget;
   import tibia.creatures.BuddylistWidget;
   import tibia.container.ContainerViewWidget;
   import tibia.container.BodyContainerViewWidget;
   import tibia.minimap.MiniMapWidget;
   import tibia.trade.NPCTradeWidget;
   import tibia.trade.SafeTradeWidget;
   import tibia.magic.SpellListWidget;
   import tibia.premium.PremiumWidget;
   import tibia.creatures.UnjustPointsWidget;
   import tibia.prey.PreySidebarWidget;
   import tibia.creatures.battlelistWidgetClasses.BattlelistWidgetView;
   import tibia.creatures.buddylistWidgetClasses.BuddylistWidgetView;
   import tibia.container.containerViewWidgetClasses.ContainerViewWidgetView;
   import tibia.sidebar.sideBarWidgetClasses.GeneralButtonsWidgetView;
   import tibia.container.bodyContainerViewWigdetClasses.BodyContainerViewWidgetView;
   import tibia.minimap.miniMapWidgetClasses.MiniMapWidgetView;
   import tibia.sidebar.sideBarWidgetClasses.CombatControlWidgetView;
   import tibia.trade.npcTradeWidgetClasses.NPCTradeWidgetView;
   import tibia.trade.safeTradeWidgetClasses.SafeTradeWidgetView;
   import tibia.magic.spellListWidgetClasses.SpellListWidgetView;
   import tibia.premium.premiumWidgetClasses.PremiumWidgetView;
   import tibia.creatures.unjustPointsWidgetClasses.UnjustPointsWidgetView;
   import tibia.prey.preyWidgetClasses.PreySidebarView;
   import tibia.options.OptionsStorage;
   import tibia.sidebar.sideBarWidgetClasses.WidgetView;
   import mx.events.PropertyChangeEvent;
   import flash.events.Event;
   
   public class Widget extends EventDispatcher
   {
      
      public static const TYPE_MINIMAP:int = 5;
      
      public static const TYPE_COMBATCONTROL:int = 6;
      
      public static const TYPE_GENERALBUTTONS:int = 3;
      
      public static const TYPE_BODY:int = 4;
      
      protected static const OPTIONS_MAX_COMPATIBLE_VERSION:Number = 5;
      
      public static const TYPES_BEYONDLAST:int = 13;
      
      public static const TYPE_UNJUSTPOINTS:int = 11;
      
      public static const EVENT_CLOSE:String = "close";
      
      public static const TYPE_NPCTRADE:int = 7;
      
      public static const TYPE_SAFETRADE:int = 8;
      
      protected static const OPTIONS_MIN_COMPATIBLE_VERSION:Number = 2;
      
      public static const TYPE_CONTAINER:int = 2;
      
      private static const TYPE_DATA:Array = [{
         "type":TYPE_BATTLELIST,
         "unique":true,
         "restorable":true,
         "closable":true,
         "collapsible":true,
         "resizable":true,
         "viewClass":BattlelistWidgetView
      },{
         "type":TYPE_BUDDYLIST,
         "unique":true,
         "restorable":true,
         "closable":true,
         "collapsible":true,
         "resizable":true,
         "viewClass":BuddylistWidgetView
      },{
         "type":TYPE_CONTAINER,
         "unique":false,
         "restorable":false,
         "closable":true,
         "collapsible":true,
         "resizable":true,
         "viewClass":ContainerViewWidgetView
      },{
         "type":TYPE_GENERALBUTTONS,
         "unique":true,
         "restorable":true,
         "closable":true,
         "collapsible":true,
         "resizable":false,
         "viewClass":GeneralButtonsWidgetView
      },{
         "type":TYPE_BODY,
         "unique":true,
         "restorable":true,
         "closable":true,
         "collapsible":true,
         "resizable":false,
         "viewClass":BodyContainerViewWidgetView
      },{
         "type":TYPE_MINIMAP,
         "unique":true,
         "restorable":true,
         "closable":true,
         "collapsible":true,
         "resizable":false,
         "viewClass":MiniMapWidgetView
      },{
         "type":TYPE_COMBATCONTROL,
         "unique":true,
         "restorable":true,
         "closable":true,
         "collapsible":true,
         "resizable":false,
         "viewClass":CombatControlWidgetView
      },{
         "type":TYPE_NPCTRADE,
         "unique":false,
         "restorable":false,
         "closable":true,
         "collapsible":true,
         "resizable":true,
         "viewClass":NPCTradeWidgetView
      },{
         "type":TYPE_SAFETRADE,
         "unique":false,
         "restorable":false,
         "closable":true,
         "collapsible":true,
         "resizable":true,
         "viewClass":SafeTradeWidgetView
      },{
         "type":TYPE_SPELLLIST,
         "unique":true,
         "restorable":true,
         "closable":true,
         "collapsible":true,
         "resizable":true,
         "viewClass":SpellListWidgetView
      },{
         "type":TYPE_PREMIUM,
         "unique":true,
         "restorable":false,
         "closable":false,
         "collapsible":true,
         "resizable":false,
         "viewClass":PremiumWidgetView
      },{
         "type":TYPE_UNJUSTPOINTS,
         "unique":true,
         "restorable":true,
         "closable":true,
         "collapsible":true,
         "resizable":false,
         "viewClass":UnjustPointsWidgetView
      },{
         "type":TYPE_PREY,
         "unique":true,
         "restorable":true,
         "closable":true,
         "collapsible":true,
         "resizable":false,
         "viewClass":PreySidebarView
      }];
      
      public static const TYPE_SPELLLIST:int = 9;
      
      public static const EVENT_OPTIONS_CHANGE:String = "optionsChange";
      
      public static const TYPE_PREY:int = 12;
      
      public static const TYPE_PREMIUM:int = 10;
      
      public static const TYPE_BATTLELIST:int = 0;
      
      public static const TYPE_BUDDYLIST:int = 1;
       
      
      protected var m_ViewInstance:WidgetView = null;
      
      protected var m_Height:Number = NaN;
      
      protected var m_Closed:Boolean = true;
      
      protected var m_Collapsed:Boolean = false;
      
      protected var m_ID:int = -1;
      
      protected var m_Type:int = -1;
      
      protected var m_Options:OptionsStorage = null;
      
      public function Widget()
      {
         super();
      }
      
      public static function s_GetRestorable(param1:int) : int
      {
         if(!Widget.s_CheckType(param1))
         {
            throw new ArgumentError("Widget.s_GetLimit: Invalid type.");
         }
         return TYPE_DATA[param1].restorable;
      }
      
      static function s_CreateInstance(param1:int, param2:int) : Widget
      {
         if(!Widget.s_CheckType(param1))
         {
            throw new ArgumentError("Widget.s_CreateInstance: Invalid type.");
         }
         var _loc3_:Widget = null;
         switch(param1)
         {
            case TYPE_BATTLELIST:
               _loc3_ = new BattlelistWidget();
               break;
            case TYPE_BUDDYLIST:
               _loc3_ = new BuddylistWidget();
               break;
            case TYPE_CONTAINER:
               _loc3_ = new ContainerViewWidget();
               break;
            case TYPE_GENERALBUTTONS:
               _loc3_ = new Widget();
               break;
            case TYPE_BODY:
               _loc3_ = new BodyContainerViewWidget();
               break;
            case TYPE_MINIMAP:
               _loc3_ = new MiniMapWidget();
               break;
            case TYPE_COMBATCONTROL:
               _loc3_ = new CombatControlWidget();
               break;
            case TYPE_NPCTRADE:
               _loc3_ = new NPCTradeWidget();
               break;
            case TYPE_SAFETRADE:
               _loc3_ = new SafeTradeWidget();
               break;
            case TYPE_SPELLLIST:
               _loc3_ = new SpellListWidget();
               break;
            case TYPE_PREMIUM:
               _loc3_ = new PremiumWidget();
               break;
            case TYPE_UNJUSTPOINTS:
               _loc3_ = new UnjustPointsWidget();
               break;
            case TYPE_PREY:
               _loc3_ = new PreySidebarWidget();
         }
         _loc3_.initialise(param1,param2);
         return _loc3_;
      }
      
      public static function s_CheckType(param1:int) : Boolean
      {
         var _loc2_:int = 0;
         while(_loc2_ < TYPE_DATA.length)
         {
            if(TYPE_DATA[_loc2_].type == param1)
            {
               return true;
            }
            _loc2_++;
         }
         return false;
      }
      
      public static function s_GetUnique(param1:int) : Boolean
      {
         if(!Widget.s_CheckType(param1))
         {
            throw new ArgumentError("Widget.s_GetLimit: Invalid type.");
         }
         return TYPE_DATA[param1].unique;
      }
      
      public static function s_Unmarshall(param1:XML, param2:int) : Widget
      {
         if(param1 == null || param1.localName() != "widget" || param2 < OPTIONS_MIN_COMPATIBLE_VERSION || param2 > OPTIONS_MAX_COMPATIBLE_VERSION)
         {
            throw new Error("Widget.s_Unmarshall: Invalid input.");
         }
         var _loc3_:XMLList = null;
         if((_loc3_ = param1.@type) == null || _loc3_.length() != 1)
         {
            throw new Error("Widget.s_Unmarshall: Missing attribute \"type\".");
         }
         var _loc4_:int = parseInt(_loc3_[0].toString());
         if(!s_CheckType(_loc4_))
         {
            throw new Error("Widget.s_Unmarshall: Invalid type: " + _loc4_);
         }
         if((_loc3_ = param1.@id) == null || _loc3_.length() != 1)
         {
            throw new Error("Widget.s_Unmarshall: Missing attribute \"id\".");
         }
         var _loc5_:int = parseInt(_loc3_[0].toString());
         var _loc6_:Widget = s_CreateInstance(_loc4_,_loc5_);
         _loc6_.unmarshall(param1,param2);
         return _loc6_;
      }
      
      public function get options() : OptionsStorage
      {
         return this.m_Options;
      }
      
      public function releaseViewInstance() : void
      {
         if(this.m_ViewInstance is WidgetView)
         {
            this.m_ViewInstance.options = null;
            this.m_ViewInstance.widgetInstance = null;
            this.m_ViewInstance.widgetClosable = false;
            this.m_ViewInstance.widgetClosed = false;
            this.m_ViewInstance.widgetCollapsed = false;
            this.m_ViewInstance.widgetCollapsible = false;
            this.m_ViewInstance.widgetHeight = NaN;
            this.m_ViewInstance.widgetResizable = false;
            this.m_ViewInstance.releaseInstance();
            this.m_ViewInstance = null;
         }
      }
      
      public function set options(param1:OptionsStorage) : void
      {
         if(this.m_Options != param1)
         {
            if(this.m_Options != null)
            {
               this.m_Options.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onOptionsChange);
            }
            this.m_Options = param1;
            if(this.m_Options != null)
            {
               this.m_Options.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onOptionsChange);
            }
            this.commitOptions();
            if(this.m_ViewInstance != null)
            {
               this.m_ViewInstance.options = this.m_Options;
            }
         }
      }
      
      protected function commitOptions() : void
      {
      }
      
      public function get draggable() : Boolean
      {
         return true;
      }
      
      public function set height(param1:Number) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Event = null;
         if(this.m_Height != param1)
         {
            _loc2_ = this.m_Height;
            this.m_Height = param1;
            _loc3_ = new Event(EVENT_OPTIONS_CHANGE,false,true);
            dispatchEvent(_loc3_);
            if(_loc3_.cancelable && _loc3_.isDefaultPrevented())
            {
               this.m_Height = _loc2_;
            }
            if(this.m_ViewInstance != null)
            {
               this.m_ViewInstance.widgetHeight = this.m_Height;
            }
         }
      }
      
      protected function onOptionsChange(param1:PropertyChangeEvent) : void
      {
      }
      
      public function acquireViewInstance(param1:Boolean = true) : WidgetView
      {
         if(param1 && this.m_ViewInstance == null)
         {
            this.m_ViewInstance = WidgetView(new TYPE_DATA[this.m_Type].viewClass());
         }
         if(this.m_ViewInstance != null)
         {
            this.m_Closed = false;
            this.m_ViewInstance.options = this.options;
            this.m_ViewInstance.widgetClosable = this.closable;
            this.m_ViewInstance.widgetClosed = false;
            this.m_ViewInstance.widgetCollapsed = this.collapsed;
            this.m_ViewInstance.widgetCollapsible = this.collapsible;
            this.m_ViewInstance.widgetHeight = this.height;
            this.m_ViewInstance.widgetInstance = this;
            this.m_ViewInstance.widgetResizable = this.resizable;
         }
         return this.m_ViewInstance;
      }
      
      public function get collapsible() : Boolean
      {
         return TYPE_DATA[this.m_Type].collapsible;
      }
      
      public function marshall() : XML
      {
         var _loc1_:XML = <widget id="{this.m_ID}" type="{this.m_Type}" collapsed="{this.m_Collapsed}"/>;
         if(!isNaN(this.m_Height))
         {
            _loc1_.@height = this.m_Height;
         }
         return _loc1_;
      }
      
      public function get collapsed() : Boolean
      {
         return this.m_Collapsed;
      }
      
      public function get ID() : int
      {
         return this.m_ID;
      }
      
      public function get closable() : Boolean
      {
         return TYPE_DATA[this.m_Type].closable;
      }
      
      public function get resizable() : Boolean
      {
         return TYPE_DATA[this.m_Type].resizable;
      }
      
      public function get closed() : Boolean
      {
         return this.m_Closed;
      }
      
      public function set collapsed(param1:Boolean) : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:Event = null;
         if(this.m_Collapsed != param1)
         {
            _loc2_ = this.m_Collapsed;
            this.m_Collapsed = param1;
            _loc3_ = new Event(EVENT_OPTIONS_CHANGE,false,true);
            dispatchEvent(_loc3_);
            if(_loc3_.cancelable && _loc3_.isDefaultPrevented())
            {
               this.m_Collapsed = _loc2_;
            }
            if(this.m_ViewInstance != null)
            {
               this.m_ViewInstance.widgetCollapsed = this.m_Collapsed;
            }
         }
      }
      
      public function get height() : Number
      {
         return this.m_Height;
      }
      
      private function initialise(param1:int, param2:int) : void
      {
         if(this.m_ID > -1)
         {
            throw new Error("Widget.initialise: Widget is already initialised.");
         }
         if(!Widget.s_CheckType(param1))
         {
            throw new ArgumentError("Widget.initialise: Invalid type.");
         }
         this.m_Type = param1;
         this.m_ID = param2;
         this.m_Collapsed = false;
         this.m_Height = NaN;
         this.m_ViewInstance = null;
      }
      
      public function close(param1:Boolean = false) : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:Event = null;
         if(param1 || this.closable && !this.m_Closed)
         {
            _loc2_ = this.m_Closed;
            this.m_Closed = true;
            _loc3_ = new Event(EVENT_CLOSE,false,true);
            dispatchEvent(_loc3_);
            if(_loc3_.cancelable && _loc3_.isDefaultPrevented())
            {
               this.m_Closed = _loc2_;
            }
            if(this.m_ViewInstance != null)
            {
               this.m_ViewInstance.widgetClosed = this.m_Closed;
            }
         }
      }
      
      public function get type() : int
      {
         return this.m_Type;
      }
      
      public function unmarshall(param1:XML, param2:int) : void
      {
         if(param1 == null || param1.localName() != "widget" || param2 < OPTIONS_MIN_COMPATIBLE_VERSION || param2 > OPTIONS_MAX_COMPATIBLE_VERSION)
         {
            throw new Error("Widget.unmarshall: Invalid input.");
         }
         var _loc3_:XMLList = null;
         if(this.collapsible && (_loc3_ = param1.@collapsed) != null && _loc3_.length() == 1)
         {
            this.collapsed = _loc3_[0].toString() == "true";
         }
         if(this.resizable && (_loc3_ = param1.@height) != null && _loc3_.length() == 1)
         {
            this.height = parseFloat(_loc3_[0].toString());
         }
      }
   }
}
