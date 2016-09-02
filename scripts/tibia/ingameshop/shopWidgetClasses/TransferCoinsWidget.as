package tibia.ingameshop.shopWidgetClasses
{
   import shared.controls.EmbeddedDialog;
   import mx.controls.TextInput;
   import mx.events.SliderEvent;
   import tibia.ingameshop.IngameShopManager;
   import mx.containers.GridRow;
   import mx.containers.Grid;
   import mx.containers.GridItem;
   import mx.controls.Label;
   import tibia.creatures.Creature;
   import mx.containers.HBox;
   import tibia.controls.CustomSlider;
   import tibia.ingameshop.IngameShopWidget;
   
   public class TransferCoinsWidget extends EmbeddedDialog
   {
      
      private static const BUNDLE:String = "IngameShopWidget";
       
      
      private var m_UncommittedCoinsValue:Boolean = true;
      
      private var m_UITargetName:TextInput;
      
      private var m_UICoinText:tibia.ingameshop.shopWidgetClasses.CoinWidget;
      
      private var m_UIAmountSlider:CustomSlider;
      
      public function TransferCoinsWidget()
      {
         super();
         title = resourceManager.getString(BUNDLE,"TITLE_TRANSFER_COINS");
         buttonFlags = EmbeddedDialog.OKAY | EmbeddedDialog.CANCEL;
         width = IngameShopWidget.EMBEDDED_DIALOG_WIDTH;
      }
      
      public function get transferAmount() : Number
      {
         return this.m_UIAmountSlider.value;
      }
      
      public function get transferTargetName() : String
      {
         return this.m_UITargetName.text;
      }
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
         if(this.m_UncommittedCoinsValue)
         {
            this.m_UICoinText.coins = this.m_UIAmountSlider.value;
            this.m_UncommittedCoinsValue = false;
         }
      }
      
      protected function onCoinsSliderChanged(param1:SliderEvent) : void
      {
         this.m_UICoinText.coins = param1.value;
      }
      
      override public function setFocus() : void
      {
         super.setFocus();
         this.m_UITargetName.setFocus();
      }
      
      private function getMaximumTransferableCoins() : Number
      {
         var _loc1_:Number = IngameShopManager.getInstance().getConfirmedCreditBalance();
         var _loc2_:Number = IngameShopManager.getInstance().getCreditPackageSize();
         return _loc1_ - _loc1_ % _loc2_;
      }
      
      override protected function createChildren() : void
      {
         var _loc3_:GridRow = null;
         super.createChildren();
         text = resourceManager.getString(BUNDLE,"LBL_TRANSFER_COINS");
         var _loc1_:Grid = new Grid();
         _loc1_.percentWidth = 100;
         content.addChild(_loc1_);
         var _loc2_:GridRow = new GridRow();
         _loc2_.percentWidth = 100;
         _loc1_.addChild(_loc2_);
         _loc3_ = new GridRow();
         _loc3_.percentWidth = 100;
         _loc1_.addChild(_loc3_);
         var _loc4_:GridRow = new GridRow();
         _loc4_.percentWidth = 100;
         _loc1_.addChild(_loc4_);
         var _loc5_:GridItem = new GridItem();
         var _loc6_:Label = new Label();
         _loc6_.text = resourceManager.getString(BUNDLE,"LBL_TRANSFER_TARGET");
         _loc5_.addChild(_loc6_);
         _loc2_.addChild(_loc5_);
         _loc5_ = new GridItem();
         _loc5_.percentWidth = 100;
         this.m_UITargetName = new TextInput();
         this.m_UITargetName.percentWidth = 100;
         this.m_UITargetName.maxChars = Creature.MAX_NAME_LENGHT;
         _loc5_.addChild(this.m_UITargetName);
         _loc2_.addChild(_loc5_);
         _loc5_ = new GridItem();
         var _loc7_:Label = new Label();
         _loc7_.text = resourceManager.getString(BUNDLE,"LBL_TRANSFER_AMOUNT");
         _loc5_.addChild(_loc7_);
         _loc3_.addChild(_loc5_);
         _loc5_ = new GridItem();
         _loc5_.percentWidth = 100;
         var _loc8_:HBox = new HBox();
         _loc8_.percentWidth = 100;
         this.m_UIAmountSlider = new CustomSlider();
         this.m_UIAmountSlider.percentWidth = 100;
         var _loc9_:Number = IngameShopManager.getInstance().getCreditPackageSize();
         this.m_UIAmountSlider.value = Math.min(_loc9_,this.getMaximumTransferableCoins());
         this.m_UIAmountSlider.minimum = this.m_UIAmountSlider.value;
         this.m_UIAmountSlider.maximum = this.getMaximumTransferableCoins();
         this.m_UIAmountSlider.snapInterval = _loc9_;
         this.m_UIAmountSlider.trackClickAmount = _loc9_;
         this.m_UIAmountSlider.showDataTip = false;
         this.m_UIAmountSlider.addEventListener(SliderEvent.CHANGE,this.onCoinsSliderChanged);
         this.m_UIAmountSlider.addEventListener(SliderEvent.THUMB_DRAG,this.onCoinsSliderChanged);
         _loc8_.addChild(this.m_UIAmountSlider);
         this.m_UICoinText = new tibia.ingameshop.shopWidgetClasses.CoinWidget();
         this.m_UICoinText.minWidth = 60;
         _loc8_.addChild(this.m_UICoinText);
         _loc5_.addChild(_loc8_);
         _loc3_.addChild(_loc5_);
         _loc5_ = new GridItem();
         var _loc10_:Label = new Label();
         _loc10_.text = resourceManager.getString(BUNDLE,"LBL_TRANSFER_BALANCE");
         _loc5_.addChild(_loc10_);
         _loc4_.addChild(_loc5_);
         _loc5_ = new GridItem();
         _loc5_.percentWidth = 100;
         var _loc11_:tibia.ingameshop.shopWidgetClasses.CoinWidget = new tibia.ingameshop.shopWidgetClasses.CoinWidget();
         _loc11_.coins = this.getMaximumTransferableCoins();
         _loc5_.addChild(_loc11_);
         _loc4_.addChild(_loc5_);
      }
   }
}
