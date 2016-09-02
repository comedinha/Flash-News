package tibia.market.marketWidgetClasses
{
   import shared.controls.EmbeddedDialog;
   import tibia.market.Offer;
   
   public class CancelOfferDialog extends EmbeddedDialog
   {
      
      private static const BUNDLE:String = "MarketWidget";
       
      
      private var m_Offer:Offer = null;
      
      private var m_UncommittedOffer:Boolean = false;
      
      public function CancelOfferDialog()
      {
         super();
         buttonFlags = EmbeddedDialog.YES | EmbeddedDialog.NO;
         title = resourceManager.getString(BUNDLE,"MARKET_DIALOG_GENERIC_TITLE");
         text = resourceManager.getString(BUNDLE,"MARKET_DIALOG_CANCEL_TEXT");
      }
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
         if(this.m_UncommittedOffer)
         {
            this.m_UncommittedOffer = false;
         }
      }
      
      public function set offer(param1:Offer) : void
      {
         if(this.m_Offer != param1)
         {
            this.m_Offer = param1;
            this.m_UncommittedOffer = true;
            invalidateProperties();
         }
      }
      
      public function get offer() : Offer
      {
         return this.m_Offer;
      }
   }
}
