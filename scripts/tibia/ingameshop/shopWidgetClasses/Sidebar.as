package tibia.ingameshop.shopWidgetClasses
{
   import mx.containers.VBox;
   import tibia.ingameshop.IngameShopCategory;
   import mx.collections.ArrayCollection;
   import tibia.ingameshop.IngameShopEvent;
   import mx.collections.ListCollectionView;
   import flash.events.MouseEvent;
   import tibia.network.Communication;
   import mx.events.ListEvent;
   import mx.controls.Button;
   import flash.events.Event;
   import mx.events.CloseEvent;
   import mx.controls.List;
   import shared.controls.EmbeddedDialog;
   import tibia.ingameshop.IngameShopManager;
   import mx.controls.Label;
   import mx.containers.HBox;
   import mx.core.ClassFactory;
   import tibia.ingameshop.IngameShopWidget;
   import flash.errors.IllegalOperationError;
   
   public class Sidebar extends VBox implements IIngameShopWidgetComponent
   {
      
      private static const CATEGORY_LINE_HEIGHT:int = 36;
      
      private static const BUNDLE:String = "IngameShopWidget";
      
      private static const MAIN_CATEGORIES_HALF_HEIGHT:int = 189;
      
      private static const MAIN_CATEGORIES_FULL_HEIGHT:int = 321;
       
      
      private var m_UICreditText:tibia.ingameshop.shopWidgetClasses.CoinWidget;
      
      private var m_UIHistory:Button;
      
      private var m_UIGetCoins:Button;
      
      private var m_UISubCategories:List;
      
      private var m_UncommitedSubCategories:Boolean = false;
      
      private var m_UITransferCoinsButton:Button;
      
      private var m_ShopManager:IngameShopManager;
      
      private var m_UISubCategoriesBox:VBox;
      
      private var m_ShopWindow:IngameShopWidget;
      
      private var m_UncommitedCredits:Boolean = false;
      
      private var m_UIMainCategories:List;
      
      private var m_UncommitedMainCategories:Boolean = false;
      
      public function Sidebar()
      {
         super();
         this.m_ShopManager = IngameShopManager.getInstance();
         this.m_ShopManager.addEventListener(IngameShopEvent.CREDIT_BALANCE_CHANGED,this.onCreditBalanceChanged);
      }
      
      private function updateSubCategoriesList() : void
      {
         var Data:Array = null;
         var SelectedCategory:IngameShopCategory = this.m_UIMainCategories.selectedItem as IngameShopCategory;
         if(SelectedCategory != null && SelectedCategory.subCategories.length > 0)
         {
            Data = new Array();
            SelectedCategory.subCategories.forEach(function(param1:IngameShopCategory, param2:int, param3:Vector.<IngameShopCategory>):void
            {
               Data.push(param1);
            });
            this.m_UISubCategories.dataProvider = new ArrayCollection(Data);
            this.m_UIMainCategories.height = MAIN_CATEGORIES_HALF_HEIGHT;
            this.m_UISubCategoriesBox.setVisible(true);
            this.m_UISubCategoriesBox.includeInLayout = true;
         }
         else
         {
            this.m_UISubCategories.dataProvider = null;
            this.m_UIMainCategories.height = MAIN_CATEGORIES_FULL_HEIGHT;
            this.m_UISubCategoriesBox.setVisible(false);
            this.m_UISubCategoriesBox.includeInLayout = false;
         }
      }
      
      public function selectFirstCategory() : void
      {
         var _loc1_:IngameShopCategory = null;
         var _loc2_:IngameShopEvent = null;
         if(this.m_UIMainCategories.dataProvider != null && (this.m_UIMainCategories.dataProvider as ListCollectionView).length > 0)
         {
            _loc1_ = (this.m_UIMainCategories.dataProvider as ListCollectionView).getItemAt(0) as IngameShopCategory;
            this.m_UIMainCategories.selectedItem = _loc1_;
            this.m_UncommitedSubCategories = true;
            invalidateProperties();
            _loc2_ = new IngameShopEvent(IngameShopEvent.CATEGORY_SELECTED);
            _loc2_.data = _loc1_;
            dispatchEvent(_loc2_);
         }
      }
      
      protected function onGetCoinsClick(param1:MouseEvent) : void
      {
         this.m_ShopWindow.showGetCoinsConfirmationDialog();
      }
      
      public function requestOffersForCategory(param1:IngameShopCategory) : void
      {
         var _loc2_:Communication = Tibia.s_GetCommunication();
         if(param1 != null && _loc2_ != null && _loc2_.isGameRunning)
         {
            _loc2_.sendCREQUESTSHOPOFFERS(param1.name);
         }
      }
      
      protected function onCategoryChange(param1:ListEvent) : void
      {
         var _loc2_:IngameShopEvent = null;
         if(this.m_UIMainCategories.selectedIndex == -1)
         {
            this.m_UIMainCategories.selectedIndex = param1.rowIndex;
            param1.preventDefault();
            param1.stopPropagation();
         }
         else
         {
            this.m_UncommitedSubCategories = true;
            invalidateProperties();
            _loc2_ = new IngameShopEvent(IngameShopEvent.CATEGORY_SELECTED);
            _loc2_.data = param1.itemRenderer.data;
            dispatchEvent(_loc2_);
            this.requestOffersForCategory(_loc2_.data as IngameShopCategory);
         }
      }
      
      protected function onTransferCoinsClicked(param1:Event) : void
      {
         var _loc2_:TransferCoinsWidget = new TransferCoinsWidget();
         _loc2_.addEventListener(CloseEvent.CLOSE,this.onTransferCoinsDialogClosed);
         this.m_ShopWindow.embeddedDialog = _loc2_;
      }
      
      protected function onCreditBalanceChanged(param1:IngameShopEvent) : void
      {
         this.m_UncommitedCredits = true;
         invalidateProperties();
      }
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
         if(this.m_UncommitedCredits)
         {
            this.updateCreditBalance();
            this.m_UncommitedCredits = false;
         }
         if(this.m_UncommitedMainCategories)
         {
            this.updateMainCategoriesList();
            this.m_UncommitedMainCategories = false;
         }
         if(this.m_UncommitedSubCategories)
         {
            this.updateSubCategoriesList();
            this.m_UncommitedSubCategories = false;
         }
      }
      
      protected function onHistoryClick(param1:MouseEvent) : void
      {
         var _loc2_:IngameShopEvent = new IngameShopEvent(IngameShopEvent.HISTORY_CLICKED);
         dispatchEvent(_loc2_);
      }
      
      protected function onSubCategoryChange(param1:ListEvent) : void
      {
         var _loc2_:IngameShopEvent = new IngameShopEvent(IngameShopEvent.CATEGORY_SELECTED);
         _loc2_.data = this.m_UISubCategories.selectedItem != null?this.m_UISubCategories.selectedItem:this.m_UIMainCategories.selectedItem;
         dispatchEvent(_loc2_);
         this.requestOffersForCategory(_loc2_.data as IngameShopCategory);
      }
      
      protected function onTransferCoinsDialogClosed(param1:CloseEvent) : void
      {
         this.m_ShopWindow.embeddedDialog.removeEventListener(CloseEvent.CLOSE,this.onTransferCoinsDialogClosed);
         var _loc2_:TransferCoinsWidget = this.m_ShopWindow.embeddedDialog as TransferCoinsWidget;
         if(param1.detail == EmbeddedDialog.OKAY && _loc2_ != null && _loc2_.transferAmount > 0 && _loc2_.transferTargetName.length > 0)
         {
            IngameShopManager.getInstance().transferCredits(_loc2_.transferTargetName,_loc2_.transferAmount);
         }
      }
      
      public function selectCategory(param1:IngameShopCategory) : void
      {
         var _loc2_:IngameShopEvent = null;
         if(param1 != null && this.m_UIMainCategories.dataProvider != null && (this.m_UIMainCategories.dataProvider as ListCollectionView).length > 0 && this.m_UIMainCategories.selectedItem != param1)
         {
            this.m_UIMainCategories.selectedItem = param1;
            this.m_UncommitedSubCategories = true;
            invalidateProperties();
            _loc2_ = new IngameShopEvent(IngameShopEvent.CATEGORY_SELECTED);
            _loc2_.data = param1;
            dispatchEvent(_loc2_);
         }
      }
      
      private function updateCreditBalance() : void
      {
         var _loc1_:Number = this.m_ShopManager.getCreditBalance();
         this.m_UICreditText.coins = _loc1_;
         this.m_UICreditText.coinsAreFinal = this.m_ShopManager.creditsAreFinal();
         var _loc2_:Number = this.m_ShopManager.getConfirmedCreditBalance();
         this.m_UICreditText.toolTip = resourceManager.getString(BUNDLE,_loc2_ == 1?"LBL_CREDITS_TOOLTIP_SINGULAR":"LBL_CREDITS_TOOLTIP_PLURAL",[this.m_ShopManager.getConfirmedCreditBalance().toFixed()]);
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         var _loc1_:VBox = new VBox();
         _loc1_.percentWidth = 100;
         _loc1_.height = 48;
         _loc1_.styleName = "ingameShopCreditBox";
         var _loc2_:Label = new Label();
         _loc2_.text = resourceManager.getString(BUNDLE,"LBL_CREDITS");
         _loc1_.addChild(_loc2_);
         this.m_UICreditText = new tibia.ingameshop.shopWidgetClasses.CoinWidget();
         this.m_UncommitedCredits = true;
         _loc1_.addChild(this.m_UICreditText);
         addChild(_loc1_);
         var _loc3_:HBox = new HBox();
         _loc3_.percentWidth = 100;
         addChild(_loc3_);
         this.m_UIHistory = new Button();
         this.m_UIHistory.label = resourceManager.getString(BUNDLE,"BTN_HISTORY");
         this.m_UIHistory.percentWidth = 50;
         this.m_UIHistory.addEventListener(MouseEvent.CLICK,this.onHistoryClick);
         _loc3_.addChild(this.m_UIHistory);
         this.m_UIGetCoins = new Button();
         this.m_UIGetCoins.label = resourceManager.getString(BUNDLE,"BTN_GET_COINS");
         this.m_UIGetCoins.styleName = "getCoinsStyle";
         this.m_UIGetCoins.labelPlacement = "left";
         this.m_UIGetCoins.percentWidth = 50;
         this.m_UIGetCoins.addEventListener(MouseEvent.CLICK,this.onGetCoinsClick);
         _loc3_.addChild(this.m_UIGetCoins);
         var _loc4_:Label = new Label();
         _loc4_.percentWidth = 100;
         _loc4_.text = resourceManager.getString(BUNDLE,"LBL_CATEGORIES");
         addChild(_loc4_);
         this.m_UIMainCategories = new List();
         this.m_UIMainCategories.percentWidth = 100;
         this.m_UIMainCategories.height = MAIN_CATEGORIES_HALF_HEIGHT;
         this.m_UIMainCategories.rowHeight = CATEGORY_LINE_HEIGHT;
         this.m_UIMainCategories.styleName = "ingameShopCategories";
         this.m_UIMainCategories.variableRowHeight = false;
         this.m_UIMainCategories.itemRenderer = new ClassFactory(CategoryRenderer);
         this.m_UIMainCategories.addEventListener(ListEvent.CHANGE,this.onCategoryChange);
         this.m_UIMainCategories.addEventListener(ListEvent.ITEM_CLICK,this.onCategoryClicked);
         this.m_UncommitedMainCategories = true;
         var _loc5_:VBox = new VBox();
         _loc5_.percentWidth = 100;
         _loc5_.styleName = "ingameShopCategoryBox";
         _loc5_.addChild(this.m_UIMainCategories);
         addChild(_loc5_);
         this.m_UISubCategoriesBox = new VBox();
         this.m_UISubCategoriesBox.percentWidth = 100;
         this.m_UISubCategoriesBox.setStyle("verticalGap",2);
         this.m_UncommitedSubCategories = true;
         var _loc6_:Label = new Label();
         _loc6_.percentWidth = 100;
         _loc6_.text = resourceManager.getString(BUNDLE,"LBL_SUBCATEGORIES");
         this.m_UISubCategoriesBox.addChild(_loc6_);
         this.m_UISubCategories = new List();
         this.m_UISubCategories.percentWidth = 100;
         this.m_UISubCategories.rowHeight = CATEGORY_LINE_HEIGHT;
         this.m_UISubCategories.rowCount = 3;
         this.m_UISubCategories.styleName = "ingameShopCategories";
         this.m_UISubCategories.itemRenderer = new ClassFactory(CategoryRenderer);
         this.m_UISubCategories.addEventListener(ListEvent.CHANGE,this.onSubCategoryChange);
         this.m_UISubCategories.addEventListener(ListEvent.ITEM_CLICK,this.onCategoryClicked);
         var _loc7_:VBox = new VBox();
         _loc7_.percentWidth = 100;
         _loc7_.styleName = "ingameShopCategoryBox";
         _loc7_.addChild(this.m_UISubCategories);
         this.m_UISubCategoriesBox.addChild(_loc7_);
         this.m_UISubCategoriesBox.addChild(_loc7_);
         addChild(this.m_UISubCategoriesBox);
         var _loc8_:HBox = new HBox();
         _loc8_.percentWidth = 100;
         this.m_UITransferCoinsButton = new Button();
         this.m_UITransferCoinsButton.percentWidth = 50;
         this.m_UITransferCoinsButton.toolTip = resourceManager.getString(BUNDLE,"LBL_TRANSFER_COINS_TOOLTIP");
         this.m_UITransferCoinsButton.styleName = "transferCoinsButton";
         this.m_UITransferCoinsButton.addEventListener(MouseEvent.CLICK,this.onTransferCoinsClicked);
         _loc8_.addChild(this.m_UITransferCoinsButton);
         addChild(_loc8_);
      }
      
      public function dispose() : void
      {
         this.m_ShopManager.removeEventListener(IngameShopEvent.CREDIT_BALANCE_CHANGED,this.onCreditBalanceChanged);
         this.m_UIHistory.removeEventListener(MouseEvent.CLICK,this.onHistoryClick);
         this.m_UIGetCoins.removeEventListener(MouseEvent.CLICK,this.onGetCoinsClick);
         this.m_UIMainCategories.removeEventListener(ListEvent.CHANGE,this.onCategoryChange);
         this.m_UIMainCategories.removeEventListener(ListEvent.ITEM_CLICK,this.onCategoryClicked);
         this.m_UISubCategories.removeEventListener(ListEvent.ITEM_CLICK,this.onCategoryClicked);
         this.m_UISubCategories.removeEventListener(ListEvent.CHANGE,this.onSubCategoryChange);
         this.m_UITransferCoinsButton.removeEventListener(MouseEvent.CLICK,this.onTransferCoinsClicked);
         this.m_ShopWindow = null;
      }
      
      private function updateMainCategoriesList() : void
      {
         var Data:Array = null;
         Data = new Array();
         this.m_ShopManager.getRootCategories().forEach(function(param1:IngameShopCategory, param2:int, param3:Vector.<IngameShopCategory>):void
         {
            Data.push(param1);
         });
         this.m_UIMainCategories.dataProvider = new ArrayCollection(Data);
      }
      
      public function getSelectedCategory() : IngameShopCategory
      {
         if(this.m_UISubCategories.selectedIndex > -1)
         {
            return this.m_UISubCategories.selectedItem as IngameShopCategory;
         }
         if(this.m_UIMainCategories.selectedIndex > -1)
         {
            return this.m_UIMainCategories.selectedItem as IngameShopCategory;
         }
         return null;
      }
      
      protected function onCategoryClicked(param1:ListEvent) : void
      {
         if(this.m_ShopWindow != null)
         {
            this.m_ShopWindow.mainView.switchToOfferSelection();
         }
      }
      
      public function set shopWidget(param1:IngameShopWidget) : void
      {
         if(this.m_ShopWindow != null)
         {
            throw new IllegalOperationError("IngameShopOfferList.shopWidget: Attempted to set reference twice");
         }
         this.m_ShopWindow = param1;
      }
   }
}
