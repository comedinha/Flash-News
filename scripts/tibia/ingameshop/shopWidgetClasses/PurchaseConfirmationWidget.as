package tibia.ingameshop.shopWidgetClasses
{
   import shared.controls.EmbeddedDialog;
   import tibia.ingameshop.IngameShopOffer;
   import mx.containers.HBox;
   import mx.controls.CheckBox;
   import mx.controls.Text;
   import tibia.ingameshop.IngameShopWidget;
   
   public class PurchaseConfirmationWidget extends EmbeddedDialog
   {
      
      private static const BUNDLE:String = "IngameShopWidget";
       
      
      private var m_Offer:IngameShopOffer;
      
      private var m_UIShowDialogCheckbox:CheckBox;
      
      public function PurchaseConfirmationWidget(param1:IngameShopOffer)
      {
         super();
         this.m_Offer = param1;
         title = resourceManager.getString(BUNDLE,"TITLE_PURCHASE_CONFIRMATION");
         buttonFlags = EmbeddedDialog.YES | EmbeddedDialog.NO;
         width = IngameShopWidget.EMBEDDED_DIALOG_WIDTH;
         minHeight = 170;
      }
      
      public function hasCheckedDoNotShowDialogAgain() : Boolean
      {
         return this.m_UIShowDialogCheckbox.selected;
      }
      
      override protected function createChildren() : void
      {
         var _loc1_:OfferDisplayBlock = null;
         var _loc2_:HBox = null;
         super.createChildren();
         _loc1_ = new OfferDisplayBlock();
         _loc1_.percentWidth = 100;
         _loc1_.offer = this.m_Offer;
         text = resourceManager.getString(BUNDLE,"LBL_PURCHASE_CONFIRMATION",[this.m_Offer.name]);
         _loc2_ = new HBox();
         _loc2_.percentWidth = 100;
         _loc2_.setStyle("verticalAlign","middle");
         this.m_UIShowDialogCheckbox = new CheckBox();
         this.m_UIShowDialogCheckbox.setStyle("paddingLeft",2);
         _loc2_.addChild(this.m_UIShowDialogCheckbox);
         var _loc3_:Text = new Text();
         _loc3_.percentWidth = 100;
         _loc3_.setStyle("paddingRight",2);
         _loc3_.text = resourceManager.getString(BUNDLE,"LBL_SHOW_CONFIRMATION_DIALOG");
         _loc2_.addChild(_loc3_);
         content.addChild(_loc1_);
         content.addChild(_loc2_);
         content.setStyle("verticalGap",6);
      }
   }
}
