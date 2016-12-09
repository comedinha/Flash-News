package tibia.prey
{
   import tibia.game.PopUpBase;
   import mx.resources.IResourceManager;
   import tibia.game.MessageWidget;
   import mx.resources.ResourceManager;
   import mx.events.PropertyChangeEvent;
   import tibia.prey.preyWidgetClasses.PreyView;
   import tibia.creatures.Player;
   import shared.utility.i18n.i18nFormatNumber;
   import tibia.controls.TibiaCurrencyView;
   import flash.events.MouseEvent;
   import tibia.ingameshop.IngameShopManager;
   import tibia.ingameshop.IngameShopProduct;
   import shared.controls.EmbeddedDialog;
   import mx.containers.HBox;
   import mx.controls.Button;
   import shared.controls.CustomButton;
   import tibia.network.Communication;
   
   public class PreyWidget extends PopUpBase
   {
      
      private static var s_CurrentInstance:tibia.prey.PreyWidget = null;
      
      private static const BUNDLE:String = "PreyWidget";
       
      
      private var m_UIConstructed:Boolean = false;
      
      private var m_UIPreyViews:Vector.<PreyView> = null;
      
      private var m_UIBonusRerollBalance:TibiaCurrencyView = null;
      
      private var m_UncommittedResources:Boolean = false;
      
      private var m_UIGoldBalance:TibiaCurrencyView = null;
      
      public function PreyWidget()
      {
         super();
         width = 689;
         height = 515;
         title = resourceManager.getString(BUNDLE,"TITLE");
         buttonFlags = PopUpBase.BUTTON_CLOSE;
         keyboardFlags = PopUpBase.KEY_ESCAPE;
         stretchEmbeddedDialog = true;
      }
      
      public static function s_GetCurrentInstance() : tibia.prey.PreyWidget
      {
         return s_CurrentInstance;
      }
      
      public static function s_ShowIfAppropriate() : void
      {
         var _loc1_:IResourceManager = null;
         var _loc2_:MessageWidget = null;
         if(Tibia.s_GetPlayer().hasReachedMain)
         {
            new tibia.prey.PreyWidget().show();
         }
         else
         {
            _loc1_ = ResourceManager.getInstance();
            if(_loc1_ == null)
            {
               return;
            }
            _loc2_ = new MessageWidget();
            _loc2_.title = _loc1_.getString(BUNDLE,"NOT_AVAILABLE_TITLE");
            _loc2_.message = _loc1_.getString(BUNDLE,"NOT_AVAILABLE_TEXT");
            _loc2_.buttonFlags = PopUpBase.BUTTON_OKAY;
            _loc2_.keyboardFlags = PopUpBase.KEY_ESCAPE | PopUpBase.KEY_ENTER;
            _loc2_.show();
         }
      }
      
      protected function onPreyManagerDataChanged(param1:PropertyChangeEvent) : void
      {
         if(param1.property == "*" || param1.property == "bonusRerollAmount")
         {
            this.m_UncommittedResources = true;
            invalidateProperties();
         }
      }
      
      override public function hide(param1:Boolean = false) : void
      {
         var _loc2_:PreyView = null;
         super.hide(param1);
         for each(_loc2_ in this.m_UIPreyViews)
         {
            _loc2_.dispose();
         }
         Tibia.s_GetPlayer().removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onPlayerDataChanged);
         PreyManager.getInstance().removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onPreyManagerDataChanged);
         s_CurrentInstance = null;
      }
      
      override protected function commitProperties() : void
      {
         var _loc1_:Player = null;
         super.commitProperties();
         if(this.m_UncommittedResources)
         {
            _loc1_ = Tibia.s_GetPlayer();
            this.m_UIGoldBalance.currentCurrency = _loc1_.bankGoldBalance + _loc1_.inventoryGoldBalance;
            this.m_UIGoldBalance.toolTip = resourceManager.getString(BUNDLE,"TOOLTIP_RESOURCES_GOLD",[i18nFormatNumber(_loc1_.inventoryGoldBalance),i18nFormatNumber(_loc1_.bankGoldBalance)]);
            this.m_UIBonusRerollBalance.currentCurrency = PreyManager.getInstance().bonusRerollAmount;
            this.m_UncommittedResources = false;
         }
      }
      
      protected function onPlayerDataChanged(param1:PropertyChangeEvent) : void
      {
         if(param1.property == "*" || param1.property == "bankGoldBalance" || param1.property == "inventoryGoldBalance")
         {
            this.m_UncommittedResources = true;
            invalidateProperties();
         }
      }
      
      protected function onBonusRerollPurchaseRequested(param1:MouseEvent) : void
      {
         IngameShopManager.getInstance().openShopWindow(true,IngameShopProduct.SERVICE_TYPE_PREY);
      }
      
      public function showMessageDialog(param1:String) : void
      {
         var _loc2_:EmbeddedDialog = null;
         _loc2_ = new EmbeddedDialog();
         _loc2_.title = resourceManager.getString(BUNDLE,"PREY_TITLE");
         _loc2_.text = param1;
         _loc2_.buttonFlags = EmbeddedDialog.OKAY;
         embeddedDialog = _loc2_;
      }
      
      override protected function createChildren() : void
      {
         var _loc1_:HBox = null;
         var _loc2_:PreyData = null;
         var _loc3_:HBox = null;
         var _loc4_:Button = null;
         var _loc5_:PreyView = null;
         if(!this.m_UIConstructed)
         {
            super.createChildren();
            _loc1_ = new HBox();
            _loc1_.percentWidth = 100;
            addChild(_loc1_);
            this.m_UIPreyViews = new Vector.<PreyView>();
            for each(_loc2_ in PreyManager.getInstance().preys)
            {
               _loc5_ = new PreyView(this);
               _loc5_.data = _loc2_;
               this.m_UIPreyViews.push(_loc5_);
               _loc1_.addChild(_loc5_);
            }
            _loc3_ = new HBox();
            _loc3_.percentWidth = 100;
            addChild(_loc3_);
            this.m_UIGoldBalance = new TibiaCurrencyView();
            this.m_UIGoldBalance.currencyIcon = TibiaCurrencyView.CURRENCY_ICON_GOLD_COIN;
            this.m_UIGoldBalance.width = 125;
            _loc3_.addChild(this.m_UIGoldBalance);
            this.m_UIBonusRerollBalance = new TibiaCurrencyView();
            this.m_UIBonusRerollBalance.currencyIcon = TibiaCurrencyView.CURRENCY_ICON_BONUS_REROLL;
            this.m_UIBonusRerollBalance.width = 50;
            _loc3_.addChild(this.m_UIBonusRerollBalance);
            _loc4_ = new CustomButton();
            _loc4_.styleName = "purchaseBonusRerollsButton";
            _loc4_.toolTip = resourceManager.getString(BUNDLE,"TOOLTIP_PURCHASE_BONUSREROLLS");
            _loc4_.width = 30;
            _loc4_.addEventListener(MouseEvent.CLICK,this.onBonusRerollPurchaseRequested);
            _loc3_.addChild(_loc4_);
            Tibia.s_GetPlayer().addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onPlayerDataChanged);
            PreyManager.getInstance().addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onPreyManagerDataChanged);
            this.m_UIConstructed = true;
         }
      }
      
      override public function show() : void
      {
         super.show();
         s_CurrentInstance = this;
         var _loc1_:Communication = Tibia.s_GetCommunication();
         if(_loc1_ != null)
         {
            _loc1_.sendCREQUESTRESOURCEBALANCE(Communication.RESOURCETYPE_BANK_GOLD);
            _loc1_.sendCREQUESTRESOURCEBALANCE(Communication.RESOURCETYPE_INVENTORY_GOLD);
            _loc1_.sendCREQUESTRESOURCEBALANCE(Communication.RESOURCETYPE_PREY_BONUS_REROLLS);
         }
         this.m_UncommittedResources = true;
         invalidateProperties();
      }
   }
}
