package tibia.game
{
   public class ConnectionLostWidget extends TimeoutWaitWidget
   {
      
      private static const BUNDLE:String = "Tibia";
       
      
      public function ConnectionLostWidget()
      {
         super();
         message = resourceManager.getString(BUNDLE,"DLG_CONNECTION_LOST_MESSAGE");
         title = resourceManager.getString(BUNDLE,"DLG_CONNECTION_LOST_TITLE");
      }
      
      override protected function updateMessage() : void
      {
         var _loc1_:Number = remainingTime;
         m_UIMessage.htmlText = resourceManager.getString(BUNDLE,"DLG_CONNECTION_LOST_TEXT",[message,getTimeString(_loc1_)]);
      }
   }
}
