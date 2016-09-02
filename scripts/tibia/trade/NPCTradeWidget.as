package tibia.trade
{
   import tibia.sidebar.Widget;
   import tibia.creatures.Player;
   import tibia.trade.npcTradeWidgetClasses.NPCTradeWidgetView;
   import mx.collections.IList;
   import tibia.appearances.AppearanceStorage;
   import tibia.sidebar.sideBarWidgetClasses.WidgetView;
   import tibia.container.ContainerStorage;
   import tibia.network.Communication;
   
   public class NPCTradeWidget extends Widget
   {
      
      public static const TRADE_BACKPACK_PRICE:int = 20;
      
      public static const CATEGORY_ALL_NAME:String = "All";
      
      public static const TRADE_BACKPACK_WEIGHT:int = 1800;
      
      public static const TRADE_MAX_AMOUNT:int = 100;
      
      public static const CATEGORY_ALL_TYPEDATA:int = 0;
      
      public static const MAX_WARE_NAME_LENGTH:int = 35;
      
      public static const CATEGORY_ALL_TYPEID:int = 2472;
      
      public static const TRADE_BACKPACK_CAPACITY:int = 20;
       
      
      protected var m_AppearanceStorage:AppearanceStorage = null;
      
      protected var m_Categories:IList = null;
      
      protected var m_Player:Player = null;
      
      protected var m_NPCName:String = null;
      
      protected var m_BuyObjects:IList = null;
      
      protected var m_ContainerStorage:ContainerStorage = null;
      
      protected var m_SellObjects:IList = null;
      
      public function NPCTradeWidget()
      {
         super();
      }
      
      override public function releaseViewInstance() : void
      {
         this.appearanceStorage = null;
         this.containerStorage = null;
         options = null;
         this.player = null;
         super.releaseViewInstance();
      }
      
      public function set player(param1:Player) : void
      {
         if(this.m_Player != param1)
         {
            this.m_Player = param1;
            if(m_ViewInstance is NPCTradeWidgetView)
            {
               NPCTradeWidgetView(m_ViewInstance).player = this.m_Player;
            }
         }
      }
      
      public function set sellObjects(param1:IList) : void
      {
         if(this.m_SellObjects != param1)
         {
            this.m_SellObjects = param1;
            if(m_ViewInstance is NPCTradeWidgetView)
            {
               NPCTradeWidgetView(m_ViewInstance).sellObjects = this.m_SellObjects;
            }
         }
      }
      
      public function get npcName() : String
      {
         return this.m_NPCName;
      }
      
      override public function acquireViewInstance(param1:Boolean = true) : WidgetView
      {
         this.appearanceStorage = Tibia.s_GetAppearanceStorage();
         this.containerStorage = Tibia.s_GetContainerStorage();
         options = Tibia.s_GetOptions();
         this.player = Tibia.s_GetPlayer();
         var _loc2_:NPCTradeWidgetView = super.acquireViewInstance(param1) as NPCTradeWidgetView;
         if(_loc2_ != null)
         {
            _loc2_.appearanceStorage = this.m_AppearanceStorage;
            _loc2_.containerStorage = this.m_ContainerStorage;
            _loc2_.options = m_Options;
            _loc2_.player = this.m_Player;
            _loc2_.buyObjects = this.m_BuyObjects;
            _loc2_.sellObjects = this.m_SellObjects;
            _loc2_.categories = this.m_Categories;
         }
         return _loc2_;
      }
      
      public function set buyObjects(param1:IList) : void
      {
         if(this.m_BuyObjects != param1)
         {
            this.m_BuyObjects = param1;
            if(m_ViewInstance is NPCTradeWidgetView)
            {
               NPCTradeWidgetView(m_ViewInstance).buyObjects = this.m_BuyObjects;
            }
         }
      }
      
      public function set npcName(param1:String) : void
      {
         if(this.m_NPCName != param1)
         {
            this.m_NPCName = param1;
            if(m_ViewInstance is NPCTradeWidgetView)
            {
               NPCTradeWidgetView(m_ViewInstance).npcName = this.m_NPCName;
            }
         }
      }
      
      public function get player() : Player
      {
         return this.m_Player;
      }
      
      public function get sellObjects() : IList
      {
         return this.m_SellObjects;
      }
      
      public function get categories() : IList
      {
         return this.m_Categories;
      }
      
      public function set appearanceStorage(param1:AppearanceStorage) : void
      {
         if(this.m_AppearanceStorage != param1)
         {
            this.m_AppearanceStorage = param1;
            if(m_ViewInstance is NPCTradeWidgetView)
            {
               NPCTradeWidgetView(m_ViewInstance).appearanceStorage = this.m_AppearanceStorage;
            }
         }
      }
      
      public function get buyObjects() : IList
      {
         return this.m_BuyObjects;
      }
      
      public function get appearanceStorage() : AppearanceStorage
      {
         return this.m_AppearanceStorage;
      }
      
      public function set categories(param1:IList) : void
      {
         if(this.m_Categories != param1)
         {
            this.m_Categories = param1;
            if(m_ViewInstance is NPCTradeWidgetView)
            {
               NPCTradeWidgetView(m_ViewInstance).categories = this.m_Categories;
            }
         }
      }
      
      public function get containerStorage() : ContainerStorage
      {
         return this.m_ContainerStorage;
      }
      
      public function set containerStorage(param1:ContainerStorage) : void
      {
         if(this.m_ContainerStorage != param1)
         {
            this.m_ContainerStorage = param1;
            if(m_ViewInstance is NPCTradeWidgetView)
            {
               NPCTradeWidgetView(m_ViewInstance).containerStorage = this.m_ContainerStorage;
            }
         }
      }
      
      override public function close(param1:Boolean = false) : void
      {
         var _loc2_:Communication = null;
         super.close(param1);
         if(closed)
         {
            _loc2_ = Tibia.s_GetCommunication();
            if(_loc2_ != null && _loc2_.isGameRunning)
            {
               _loc2_.sendCCLOSENPCTRADE();
            }
         }
      }
   }
}
