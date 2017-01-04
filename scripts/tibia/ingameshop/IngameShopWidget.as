package tibia.ingameshop
{
   import mx.containers.HBox;
   import mx.containers.VBox;
   import mx.events.CloseEvent;
   import shared.controls.EmbeddedDialog;
   import tibia.game.PopUpBase;
   import tibia.ingameshop.shopWidgetClasses.Header;
   import tibia.ingameshop.shopWidgetClasses.MainContentPane;
   import tibia.ingameshop.shopWidgetClasses.OfferList;
   import tibia.ingameshop.shopWidgetClasses.Sidebar;
   import tibia.premium.PremiumManager;
   
   public class IngameShopWidget extends PopUpBase
   {
      
      private static var s_CurrentInstance:IngameShopWidget = null;
      
      private static const BUNDLE:String = "IngameShopWidget";
      
      public static const EMBEDDED_DIALOG_WIDTH:int = 380;
       
      
      private var m_UIMainView:MainContentPane;
      
      private var m_UIHeader:Header;
      
      private var m_UISidebar:Sidebar;
      
      public function IngameShopWidget()
      {
         super();
         height = 512;
         width = 700;
         title = resourceManager.getString(BUNDLE,"TITLE");
         buttonFlags = PopUpBase.BUTTON_CLOSE;
         keyboardFlags = PopUpBase.KEY_ESCAPE;
         stretchEmbeddedDialog = false;
      }
      
      public static function s_GetCurrentInstance() : IngameShopWidget
      {
         return s_CurrentInstance;
      }
      
      public function get offerList() : OfferList
      {
         return this.m_UIMainView.offerList;
      }
      
      override public function hide(param1:Boolean = false) : void
      {
         super.hide(param1);
         this.m_UISidebar.removeEventListener(IngameShopEvent.CATEGORY_SELECTED,this.onCategorySelected);
         this.m_UISidebar.removeEventListener(IngameShopEvent.HISTORY_CLICKED,this.onHistoryClicked);
         this.m_UIMainView.removeEventListener(IngameShopEvent.OFFER_ACTIVATED,this.onOfferDetails);
         this.m_UIMainView.removeEventListener(IngameShopEvent.OFFER_DEACTIVATED,this.onOfferDetailsClosed);
         this.m_UIHeader.dispose();
         this.m_UIMainView.dispose();
         this.m_UISidebar.dispose();
         s_CurrentInstance = null;
      }
      
      public function get shopHeader() : Header
      {
         return this.m_UIHeader;
      }
      
      protected function onOfferDetails(param1:IngameShopEvent) : void
      {
         this.m_UIHeader.data = param1.data;
      }
      
      public function showGetCoinsConfirmationDialog() : void
      {
         var _loc1_:EmbeddedDialog = null;
         _loc1_ = new EmbeddedDialog();
         _loc1_.width = IngameShopWidget.EMBEDDED_DIALOG_WIDTH;
         _loc1_.title = resourceManager.getString(BUNDLE,"TITLE_GET_COINS");
         _loc1_.text = resourceManager.getString(BUNDLE,"LBL_GET_COINS");
         _loc1_.buttonFlags = EmbeddedDialog.YES | EmbeddedDialog.NO;
         _loc1_.addEventListener(CloseEvent.CLOSE,this.onGetCoinsConfirmationClick);
         _loc1_.styleName = "getCoinConfirmation";
         embeddedDialog = _loc1_;
      }
      
      protected function onGetCoinsConfirmationClick(param1:CloseEvent) : void
      {
         embeddedDialog.removeEventListener(CloseEvent.CLOSE,this.onGetCoinsConfirmationClick);
         if(param1.detail == EmbeddedDialog.YES)
         {
            Tibia.s_GetPremiumManager().goToPaymentWebsite(PremiumManager.PREMIUM_BUTTON_SHOP);
         }
      }
      
      protected function onOfferDetailsClosed(param1:IngameShopEvent) : void
      {
         this.m_UIHeader.data = this.m_UISidebar.getSelectedCategory();
      }
      
      protected function onHistoryClicked(param1:IngameShopEvent) : void
      {
         this.m_UIHeader.setStaticHeader(Header.STATIC_HEADER_TRANSACTION_HISTORY);
      }
      
      protected function onCategorySelected(param1:IngameShopEvent) : void
      {
         this.m_UIHeader.data = param1.data;
         this.m_UIMainView.offerList.data = param1.data;
      }
      
      public function selectCategory(param1:IngameShopCategory) : void
      {
         this.m_UISidebar.selectCategory(param1);
      }
      
      override protected function createChildren() : void
      {
         var _loc1_:HBox = null;
         super.createChildren();
         _loc1_ = new HBox();
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.setStyle("horizontalGap",4);
         addChild(_loc1_);
         this.m_UISidebar = new Sidebar();
         this.m_UISidebar.percentHeight = 100;
         this.m_UISidebar.width = 185;
         _loc1_.addChild(this.m_UISidebar);
         var _loc2_:VBox = new VBox();
         _loc2_.percentWidth = 100;
         _loc2_.percentHeight = 100;
         _loc2_.setStyle("verticalGap",2);
         _loc1_.addChild(_loc2_);
         this.m_UIHeader = new Header();
         this.m_UIHeader.percentWidth = 100;
         this.m_UIHeader.height = 71;
         _loc2_.addChild(this.m_UIHeader);
         this.m_UIMainView = new MainContentPane();
         this.m_UIMainView.percentWidth = 100;
         _loc2_.addChild(this.m_UIMainView);
         this.m_UISidebar.shopWidget = this;
         this.m_UIHeader.shopWidget = this;
         this.m_UIMainView.shopWidget = this;
         this.m_UISidebar.addEventListener(IngameShopEvent.CATEGORY_SELECTED,this.onCategorySelected);
         this.m_UISidebar.addEventListener(IngameShopEvent.HISTORY_CLICKED,this.onHistoryClicked);
         this.m_UIMainView.addEventListener(IngameShopEvent.OFFER_ACTIVATED,this.onOfferDetails);
         this.m_UIMainView.addEventListener(IngameShopEvent.OFFER_DEACTIVATED,this.onOfferDetailsClosed);
      }
      
      public function get sideBar() : Sidebar
      {
         return this.m_UISidebar;
      }
      
      override public function show() : void
      {
         super.show();
         this.m_UISidebar.selectFirstCategory();
         s_CurrentInstance = this;
      }
      
      public function get mainView() : MainContentPane
      {
         return this.m_UIMainView;
      }
   }
}
