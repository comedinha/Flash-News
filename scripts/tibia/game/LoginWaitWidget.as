package tibia.game
{
   public class LoginWaitWidget extends TimeoutWaitWidget
   {
      
      private static const BUNDLE:String = "Tibia";
       
      
      public function LoginWaitWidget()
      {
         super();
         title = resourceManager.getString(BUNDLE,"DLG_LOGINWAIT_TITLE");
      }
      
      override protected function updateMessage() : void
      {
         var _loc1_:Number = remainingTime;
         m_UIMessage.htmlText = resourceManager.getString(BUNDLE,"DLG_LOGINWAIT_TEXT",[message,getTimeString(_loc1_)]);
      }
   }
}
