package
{
   import mx.resources.ResourceBundle;
   
   public class en_US$SafeTradeWidget_properties extends ResourceBundle
   {
       
      
      public function en_US$SafeTradeWidget_properties()
      {
         super("en_US","SafeTradeWidget");
      }
      
      override protected function getContent() : Object
      {
         var _loc1_:Object = {
            "FOOTER_CANCEL_LABEL":"Cancel",
            "FOOTER_WAIT_FOR_ACCEPT_TEXT":"Please wait for\nyour partner to finish",
            "FOOTER_REJECT_LABEL":"Reject",
            "FOOTER_WAIT_FOR_OFFER_TEXT":"Please wait for a\ncounteroffer",
            "TITLE":"Trade",
            "FOOTER_ACCEPT_LABEL":"Accept",
            "MSG_INVALID_PARTNER":"Select a player to trade with.",
            "FOOTER_CANCEL_TOOLTIP":"Cancel offer",
            "FOOTER_REJECT_TOOLTIP":"Reject offer",
            "FOOTER_ACCEPT_TOOLTIP":"Accept offer"
         };
         return _loc1_;
      }
   }
}
