package tibia.ingameshop.shopWidgetClasses
{
   import flash.errors.IllegalOperationError;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import mx.containers.Box;
   import mx.containers.HBox;
   import mx.containers.VBox;
   import mx.containers.ViewStack;
   import mx.controls.Button;
   import mx.controls.Label;
   import mx.core.UIComponent;
   import mx.events.CloseEvent;
   import shared.controls.CustomButton;
   import shared.controls.EmbeddedDialog;
   import tibia.ingameshop.IngameShopEvent;
   import tibia.ingameshop.IngameShopManager;
   import tibia.ingameshop.IngameShopOffer;
   import tibia.ingameshop.IngameShopWidget;
   
   public class MainContentPane extends VBox implements IIngameShopWidgetComponent
   {
      
      private static const VIEW_OFFERS:int = 0;
      
      private static const VIEW_DETAILS:int = 1;
      
      private static const BUNDLE:String = "IngameShopWidget";
      
      private static const VIEW_TRANSACTIONS:int = 2;
       
      
      private var m_UIStack:ViewStack;
      
      private var m_UIOfferDetails:OfferDetails;
      
      private var m_UIDetailsButton:Button;
      
      private var m_UINextTransactionPage:Button;
      
      private var m_UIBetweenButtonsLabel:Label;
      
      private var m_UIOfferList:OfferList;
      
      private var m_UIPreviousTransactionPage:Button;
      
      private var m_UITransactions:TransactionHistory;
      
      private var m_UIBackButton:Button;
      
      private var m_ShopWindow:IngameShopWidget;
      
      private var m_UIBottomButtonBox:HBox;
      
      private var m_UITitle:Label;
      
      private var m_UIBuyButton:Button;
      
      private var m_UIGetCoinsButton:Button;
      
      public function MainContentPane()
      {
         super();
         IngameShopManager.getInstance().addEventListener(IngameShopEvent.PURCHASE_COMPLETED,this.onPurchaseCompleted);
         IngameShopManager.getInstance().addEventListener(IngameShopEvent.ERROR_RECEIVED,this.onErrorReceived);
         IngameShopManager.getInstance().addEventListener(IngameShopEvent.NAME_CHANGE_REQUESTED,this.onNameChangeRequest);
         IngameShopManager.getInstance().addEventListener(IngameShopEvent.CREDIT_BALANCE_CHANGED,this.onCreditBalanceChanged);
      }
      
      public function get detailsList() : OfferDetails
      {
         return this.m_UIOfferDetails;
      }
      
      protected function onBuyClicked(param1:Event) : void
      {
         var _loc2_:PurchaseConfirmationWidget = null;
         if(this.m_UIOfferList.getSelectedOffer() != null)
         {
            if(Tibia.s_GetOptions().generalShopShowBuyConfirmation)
            {
               _loc2_ = new PurchaseConfirmationWidget(this.m_UIOfferList.getSelectedOffer());
               _loc2_.addEventListener(CloseEvent.CLOSE,this.onBuyConfirmationClosed);
               this.m_ShopWindow.embeddedDialog = _loc2_;
            }
            else
            {
               IngameShopManager.getInstance().purchaseRegularOffer(this.m_UIOfferList.getSelectedOffer().offerID);
               this.switchView(VIEW_OFFERS);
            }
         }
      }
      
      protected function onBuyConfirmationClosed(param1:CloseEvent) : void
      {
         this.m_ShopWindow.embeddedDialog.removeEventListener(CloseEvent.CLOSE,this.onBuyConfirmationClosed);
         var _loc2_:PurchaseConfirmationWidget = this.m_ShopWindow.embeddedDialog as PurchaseConfirmationWidget;
         if(_loc2_ != null && param1.detail == EmbeddedDialog.YES)
         {
            IngameShopManager.getInstance().purchaseRegularOffer(this.m_UIOfferList.getSelectedOffer().offerID);
            this.switchView(VIEW_OFFERS);
            Tibia.s_GetOptions().generalShopShowBuyConfirmation = !_loc2_.hasCheckedDoNotShowDialogAgain();
         }
      }
      
      protected function onCreditBalanceChanged(param1:IngameShopEvent) : void
      {
         this.switchBetweenBuyAndGetCoinsButton();
      }
      
      public function get offerList() : OfferList
      {
         return this.m_UIOfferList;
      }
      
      public function dispose() : void
      {
         IngameShopManager.getInstance().removeEventListener(IngameShopEvent.PURCHASE_COMPLETED,this.onPurchaseCompleted);
         IngameShopManager.getInstance().removeEventListener(IngameShopEvent.ERROR_RECEIVED,this.onErrorReceived);
         IngameShopManager.getInstance().removeEventListener(IngameShopEvent.NAME_CHANGE_REQUESTED,this.onNameChangeRequest);
         IngameShopManager.getInstance().removeEventListener(IngameShopEvent.CREDIT_BALANCE_CHANGED,this.onCreditBalanceChanged);
         if(this.m_ShopWindow != null)
         {
            this.m_ShopWindow.sideBar.removeEventListener(IngameShopEvent.CATEGORY_SELECTED,this.onCategorySelected);
            this.m_ShopWindow.sideBar.removeEventListener(IngameShopEvent.HISTORY_CLICKED,this.onHistoryClicked);
         }
         this.m_UIOfferList.removeEventListener(IngameShopEvent.OFFER_ACTIVATED,this.onOfferDoubleClicked);
         this.m_UIOfferList.dispose();
         this.m_UIOfferDetails.dispose();
         this.m_UITransactions.dispose();
         this.m_UIBackButton.removeEventListener(MouseEvent.CLICK,this.onBackClicked);
         this.m_UIDetailsButton.removeEventListener(MouseEvent.CLICK,this.onDetailsClicked);
         this.m_UIBuyButton.removeEventListener(MouseEvent.CLICK,this.onBuyClicked);
         this.m_UIGetCoinsButton.removeEventListener(MouseEvent.CLICK,this.onGetCoinsClick);
         this.m_ShopWindow = null;
      }
      
      protected function onPurchaseCompleted(param1:IngameShopEvent) : void
      {
         var _loc2_:ShopReponseWidget = new ShopReponseWidget(param1.message,param1.errorType);
         this.m_ShopWindow.embeddedDialog = _loc2_;
         this.m_ShopWindow.sideBar.requestOffersForCategory(this.m_ShopWindow.sideBar.getSelectedCategory());
      }
      
      protected function onHistoryClicked(param1:Event) : void
      {
         this.m_UITransactions.refreshTransactionHistory();
         this.switchView(VIEW_TRANSACTIONS);
      }
      
      public function set shopWidget(param1:IngameShopWidget) : void
      {
         if(this.m_ShopWindow != null)
         {
            throw new IllegalOperationError("IngameShopMainContentPane.shopWidget: Attempted to set reference twice");
         }
         this.m_ShopWindow = param1;
         this.m_ShopWindow.sideBar.addEventListener(IngameShopEvent.CATEGORY_SELECTED,this.onCategorySelected);
         this.m_ShopWindow.sideBar.addEventListener(IngameShopEvent.HISTORY_CLICKED,this.onHistoryClicked);
         this.m_UIOfferList.shopWidget = param1;
         this.m_UIOfferDetails.shopWidget = param1;
         this.m_UITransactions.shopWidget = param1;
      }
      
      protected function onCategorySelected(param1:IngameShopEvent) : void
      {
         this.m_UIOfferList.selectedItem = null;
         this.switchView(VIEW_OFFERS);
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this.m_UITitle = new Label();
         this.m_UITitle.text = resourceManager.getString(BUNDLE,"LBL_OFFERS");
         addChild(this.m_UITitle);
         this.m_UIStack = new ViewStack();
         this.m_UIStack.styleName = "ingameShopOfferBox";
         this.m_UIStack.percentWidth = 100;
         this.m_UIStack.height = 323;
         addChild(this.m_UIStack);
         var _loc1_:Box = new VBox();
         _loc1_.percentHeight = _loc1_.percentWidth = 100;
         _loc1_.styleName = "ingameShopNoPadding";
         this.m_UIStack.addChild(_loc1_);
         this.m_UIOfferList = new OfferList();
         this.m_UIOfferList.percentHeight = this.m_UIOfferList.percentWidth = 100;
         this.m_UIOfferList.addEventListener(IngameShopEvent.OFFER_ACTIVATED,this.onOfferDoubleClicked);
         _loc1_.addChild(this.m_UIOfferList);
         this.m_UIOfferDetails = new OfferDetails();
         this.m_UIOfferDetails.percentHeight = this.m_UIOfferDetails.percentWidth = 100;
         this.m_UIStack.addChild(this.m_UIOfferDetails);
         _loc1_ = new VBox();
         _loc1_.percentHeight = _loc1_.percentWidth = 100;
         _loc1_.styleName = "ingameShopNoPadding";
         this.m_UIStack.addChild(_loc1_);
         this.m_UITransactions = new TransactionHistory();
         this.m_UITransactions.percentHeight = this.m_UITransactions.percentWidth = 100;
         _loc1_.addChild(this.m_UITransactions);
         this.m_UIBottomButtonBox = new HBox();
         this.m_UIBottomButtonBox.setStyle("horizontalAlign","right");
         this.m_UIBottomButtonBox.percentWidth = 100;
         this.m_UIBottomButtonBox.setVisible(false);
         addChild(this.m_UIBottomButtonBox);
         this.m_UIPreviousTransactionPage = new Button();
         this.m_UIPreviousTransactionPage.label = resourceManager.getString(BUNDLE,"BTN_HISTORY_PREVIOUS");
         this.m_UIPreviousTransactionPage.width = 75;
         this.m_UIBottomButtonBox.addChild(this.m_UIPreviousTransactionPage);
         var _loc2_:UIComponent = new UIComponent();
         _loc2_.percentWidth = 50;
         _loc2_.visible = false;
         this.m_UIBottomButtonBox.addChild(_loc2_);
         this.m_UIBetweenButtonsLabel = new Label();
         this.m_UIBetweenButtonsLabel.visible = false;
         this.m_UIBottomButtonBox.addChild(this.m_UIBetweenButtonsLabel);
         _loc2_ = new UIComponent();
         _loc2_.percentWidth = 50;
         _loc2_.visible = false;
         this.m_UIBottomButtonBox.addChild(_loc2_);
         this.m_UINextTransactionPage = new Button();
         this.m_UINextTransactionPage.label = resourceManager.getString(BUNDLE,"BTN_HISTORY_NEXT");
         this.m_UINextTransactionPage.width = 75;
         this.m_UIBottomButtonBox.addChild(this.m_UINextTransactionPage);
         this.m_UITransactions.setControlledButtonsAndLabel(this.m_UIPreviousTransactionPage,this.m_UINextTransactionPage,this.m_UIBetweenButtonsLabel);
         this.m_UIBackButton = new Button();
         this.m_UIBackButton.width = 75;
         this.m_UIBackButton.label = resourceManager.getString(BUNDLE,"BTN_BACK");
         this.m_UIBackButton.addEventListener(MouseEvent.CLICK,this.onBackClicked);
         this.m_UIBackButton.setVisible(false);
         this.m_UIBottomButtonBox.addChild(this.m_UIBackButton);
         this.m_UIDetailsButton = new Button();
         this.m_UIDetailsButton.label = resourceManager.getString(BUNDLE,"BTN_DETAILS");
         this.m_UIDetailsButton.width = this.m_UIBackButton.width;
         this.m_UIDetailsButton.addEventListener(MouseEvent.CLICK,this.onDetailsClicked);
         this.m_UIBottomButtonBox.addChild(this.m_UIDetailsButton);
         this.m_UIBuyButton = new CustomButton();
         this.m_UIBuyButton.label = resourceManager.getString(BUNDLE,"BTN_BUY");
         this.m_UIBuyButton.styleName = "buyStyle";
         this.m_UIBuyButton.width = this.m_UIBackButton.width;
         this.m_UIBuyButton.addEventListener(MouseEvent.CLICK,this.onBuyClicked);
         this.m_UIBottomButtonBox.addChild(this.m_UIBuyButton);
         this.m_UIGetCoinsButton = new CustomButton();
         this.m_UIGetCoinsButton.label = resourceManager.getString(BUNDLE,"BTN_GET_COINS");
         this.m_UIGetCoinsButton.styleName = "getCoinsGoldStyle";
         this.m_UIGetCoinsButton.labelPlacement = "left";
         this.m_UIGetCoinsButton.width = this.m_UIBackButton.width;
         this.m_UIGetCoinsButton.addEventListener(MouseEvent.CLICK,this.onGetCoinsClick);
         this.m_UIBottomButtonBox.addChild(this.m_UIGetCoinsButton);
      }
      
      public function switchToOfferSelection() : void
      {
         this.switchView(VIEW_OFFERS);
      }
      
      public function setShowButtonBar(param1:Boolean) : void
      {
         this.m_UIBottomButtonBox.setVisible(param1);
         if(param1)
         {
            this.switchBetweenBuyAndGetCoinsButton();
         }
      }
      
      private function switchBetweenBuyAndGetCoinsButton() : void
      {
         var _loc1_:IngameShopOffer = null;
         if(this.m_UIStack.selectedIndex != VIEW_TRANSACTIONS)
         {
            _loc1_ = this.m_UIOfferList.getSelectedOffer();
            this.m_UIBuyButton.setVisible(_loc1_ != null && IngameShopManager.getInstance().getCreditBalance() >= _loc1_.price);
            this.m_UIBuyButton.includeInLayout = this.m_UIBuyButton.visible;
            this.m_UIBuyButton.enabled = _loc1_ != null && _loc1_.disabled == false;
            this.m_UIGetCoinsButton.setVisible(!this.m_UIBuyButton.visible);
            this.m_UIGetCoinsButton.includeInLayout = this.m_UIGetCoinsButton.visible;
         }
      }
      
      protected function onDetailsClicked(param1:Event) : void
      {
         this.switchView(VIEW_DETAILS);
         var _loc2_:IngameShopEvent = new IngameShopEvent(IngameShopEvent.OFFER_ACTIVATED);
         _loc2_.data = this.m_UIOfferList.getSelectedOffer();
         dispatchEvent(_loc2_);
      }
      
      protected function onNameChangeDialogClosed(param1:CloseEvent) : void
      {
         this.m_ShopWindow.embeddedDialog.removeEventListener(CloseEvent.CLOSE,this.onNameChangeDialogClosed);
         var _loc2_:CharacterNameChangeWidget = this.m_ShopWindow.embeddedDialog as CharacterNameChangeWidget;
         if(param1.detail == EmbeddedDialog.OKAY && _loc2_ != null && _loc2_.desiredName.length > 0)
         {
            IngameShopManager.getInstance().purchaseCharacterNameChange(_loc2_.offerID,_loc2_.desiredName);
            this.switchView(VIEW_OFFERS);
         }
      }
      
      protected function onNameChangeRequest(param1:IngameShopEvent) : void
      {
         var _loc2_:CharacterNameChangeWidget = new CharacterNameChangeWidget(int(param1.data));
         _loc2_.addEventListener(CloseEvent.CLOSE,this.onNameChangeDialogClosed);
         this.m_ShopWindow.embeddedDialog = _loc2_;
      }
      
      protected function onOfferDoubleClicked(param1:IngameShopEvent) : void
      {
         this.switchView(VIEW_DETAILS);
         dispatchEvent(param1);
      }
      
      protected function onBackClicked(param1:Event) : void
      {
         this.switchView(VIEW_OFFERS);
         dispatchEvent(new IngameShopEvent(IngameShopEvent.OFFER_DEACTIVATED));
      }
      
      protected function onErrorReceived(param1:IngameShopEvent) : void
      {
         var _loc2_:ShopReponseWidget = null;
         if(param1.errorType == IngameShopEvent.ERROR_TRANSACTION_HISTORY)
         {
            this.m_UITransactions.displayTransactionHistoryError(param1.message);
         }
         else
         {
            _loc2_ = new ShopReponseWidget(param1.message,param1.errorType);
            this.m_ShopWindow.embeddedDialog = _loc2_;
            this.m_ShopWindow.sideBar.requestOffersForCategory(this.m_ShopWindow.sideBar.getSelectedCategory());
         }
      }
      
      private function switchView(param1:int) : void
      {
         var _loc2_:IngameShopOffer = this.m_UIOfferList.getSelectedOffer();
         if(param1 == VIEW_OFFERS)
         {
            this.m_UITitle.text = resourceManager.getString(BUNDLE,"LBL_OFFERS");
            this.m_UIStack.selectedIndex = VIEW_OFFERS;
            this.m_UIBackButton.setVisible(false);
            this.m_UIBackButton.includeInLayout = false;
            this.m_UIDetailsButton.setVisible(true);
            this.m_UIDetailsButton.includeInLayout = true;
            this.switchBetweenBuyAndGetCoinsButton();
            this.m_UIPreviousTransactionPage.setVisible(false);
            this.m_UIPreviousTransactionPage.includeInLayout = false;
            this.m_UIBetweenButtonsLabel.setVisible(false);
            this.m_UIBetweenButtonsLabel.includeInLayout = false;
            this.m_UINextTransactionPage.setVisible(false);
            this.m_UINextTransactionPage.includeInLayout = false;
            this.m_UIBottomButtonBox.setVisible(this.m_UIOfferList.getSelectedOffer() != null);
         }
         else if(param1 == VIEW_DETAILS)
         {
            this.m_UITitle.text = resourceManager.getString(BUNDLE,"LBL_DETAILS");
            this.m_UIStack.selectedIndex = VIEW_DETAILS;
            this.m_UIBackButton.setVisible(true);
            this.m_UIBackButton.includeInLayout = true;
            this.m_UIDetailsButton.setVisible(false);
            this.m_UIDetailsButton.includeInLayout = false;
            this.switchBetweenBuyAndGetCoinsButton();
            this.m_UIPreviousTransactionPage.setVisible(false);
            this.m_UIPreviousTransactionPage.includeInLayout = false;
            this.m_UIBetweenButtonsLabel.setVisible(false);
            this.m_UIBetweenButtonsLabel.includeInLayout = false;
            this.m_UINextTransactionPage.setVisible(false);
            this.m_UINextTransactionPage.includeInLayout = false;
            this.m_UIBottomButtonBox.setVisible(this.m_UIOfferList.getSelectedOffer() != null);
         }
         else if(param1 == VIEW_TRANSACTIONS)
         {
            this.m_UITitle.text = resourceManager.getString(BUNDLE,"LBL_HISTORY");
            this.m_UIStack.selectedIndex = VIEW_TRANSACTIONS;
            this.m_UIBackButton.setVisible(false);
            this.m_UIBackButton.includeInLayout = false;
            this.m_UIDetailsButton.setVisible(false);
            this.m_UIDetailsButton.includeInLayout = false;
            this.m_UIBuyButton.setVisible(false);
            this.m_UIBuyButton.includeInLayout = false;
            this.m_UIGetCoinsButton.setVisible(false);
            this.m_UIGetCoinsButton.includeInLayout = false;
            this.m_UIPreviousTransactionPage.setVisible(true);
            this.m_UIPreviousTransactionPage.includeInLayout = true;
            this.m_UIBetweenButtonsLabel.setVisible(false);
            this.m_UIBetweenButtonsLabel.includeInLayout = true;
            this.m_UINextTransactionPage.setVisible(true);
            this.m_UINextTransactionPage.includeInLayout = true;
            this.m_UIBottomButtonBox.setVisible(true);
         }
      }
      
      protected function onGetCoinsClick(param1:MouseEvent) : void
      {
         this.m_ShopWindow.showGetCoinsConfirmationDialog();
      }
   }
}
