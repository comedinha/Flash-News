package tibia.game
{
   import flash.events.Event;
   
   public class SecureWebsiteServiceEvent extends Event
   {
      
      public static const COMPLETE:String = "secureWebsiteServiceComplete";
      
      public static const REQUEST_DATA:String = "secureWebsiteServiceRequestData";
       
      
      private var m_ServiceData:Object = null;
      
      public function SecureWebsiteServiceEvent(param1:String, param2:Boolean = false, param3:Boolean = false, param4:Object = null)
      {
         super(param1,param2,param3);
         this.m_ServiceData = param4;
      }
      
      public function get serviceData() : Object
      {
         return this.m_ServiceData;
      }
   }
}
