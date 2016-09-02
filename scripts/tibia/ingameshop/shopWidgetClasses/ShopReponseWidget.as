package tibia.ingameshop.shopWidgetClasses
{
   import shared.controls.EmbeddedDialog;
   import tibia.ingameshop.IngameShopOffer;
   import tibia.ingameshop.IngameShopEvent;
   import tibia.ingameshop.IngameShopWidget;
   
   public class ShopReponseWidget extends EmbeddedDialog
   {
      
      private static const BUNDLE:String = "IngameShopWidget";
       
      
      private var m_Offer:IngameShopOffer;
      
      private var m_UncommittedOffer:Boolean;
      
      private var m_ErrorType:int;
      
      private var m_Message:String;
      
      private var m_UIOfferDisplayBox:tibia.ingameshop.shopWidgetClasses.OfferDisplayBlock;
      
      public function ShopReponseWidget(param1:String, param2:int)
      {
         super();
         this.m_ErrorType = param2;
         this.m_Message = param1;
         title = this.getTitleStringByErrorState();
         text = param1;
         buttonFlags = EmbeddedDialog.OKAY;
         width = IngameShopWidget.EMBEDDED_DIALOG_WIDTH;
         minHeight = 175;
         this.m_UncommittedOffer = true;
      }
      
      public function set offer(param1:IngameShopOffer) : void
      {
         this.m_Offer = param1;
         this.m_UncommittedOffer = true;
         invalidateProperties();
      }
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
         if(this.m_UncommittedOffer)
         {
            this.m_UIOfferDisplayBox.offer = this.m_Offer;
            this.m_UIOfferDisplayBox.includeInLayout = this.m_Offer != null;
            this.m_UIOfferDisplayBox.visible = this.m_Offer != null;
            this.m_UncommittedOffer = false;
         }
      }
      
      private function getTitleStringByErrorState() : String
      {
         switch(this.m_ErrorType)
         {
            case IngameShopEvent.ERROR_NO_ERROR:
               return resourceManager.getString(BUNDLE,"TITLE_PURCHASE_SUCCESS");
            case IngameShopEvent.ERROR_INFORMATION:
               return resourceManager.getString(BUNDLE,"TITLE_PURCHASE_INFORMATION");
            default:
               return resourceManager.getString(BUNDLE,"TITLE_PURCHASE_ERROR");
         }
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         if(this.getTextColorStyleNameByErrorState() != null)
         {
            titleBox.setStyle("color",getStyle(this.getTextColorStyleNameByErrorState()));
         }
         this.m_UIOfferDisplayBox = new tibia.ingameshop.shopWidgetClasses.OfferDisplayBlock();
         this.m_UIOfferDisplayBox.percentWidth = 100;
         content.addChildAt(this.m_UIOfferDisplayBox,0);
      }
      
      private function getTextColorStyleNameByErrorState() : String
      {
         switch(this.m_ErrorType)
         {
            case IngameShopEvent.ERROR_NO_ERROR:
               return "successColor";
            case IngameShopEvent.ERROR_PURCHASE_FAILED:
               return "errorColor";
            case IngameShopEvent.ERROR_NETWORK:
               return "errorColor";
            case IngameShopEvent.ERROR_TRANSFER_FAILED:
               return "errorColor";
            case IngameShopEvent.ERROR_INFORMATION:
               return "informationColor";
            case IngameShopEvent.ERROR_TRANSACTION_HISTORY:
            default:
               return null;
         }
      }
   }
}
