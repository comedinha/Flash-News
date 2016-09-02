package tibia.input.staticaction
{
   import tibia.input.gameaction.SendBugReportActionImpl;
   
   public class SendBugReport extends StaticAction
   {
       
      
      public function SendBugReport(param1:int, param2:String, param3:uint)
      {
         super(param1,param2,param3,false);
      }
      
      override public function perform(param1:Boolean = false) : void
      {
         new SendBugReportActionImpl().perform(param1);
      }
   }
}
