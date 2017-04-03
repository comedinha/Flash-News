package tibia.network
{
   import mx.resources.ResourceManager;
   
   public class FailedConnectionRescheduler
   {
      
      private static const BUNDLE:String = "Connection";
      
      private static const MAXIMUM_ATTEMPTED_RETRIES:int = 10;
       
      
      private var m_AttemptedReconnects:int = 0;
      
      public function FailedConnectionRescheduler()
      {
         super();
      }
      
      private function getReconnectionDelayForAttempt(param1:int) : int
      {
         if(param1 == 1)
         {
            return 1;
         }
         if(param1 == 2)
         {
            return 500;
         }
         if(param1 == 3)
         {
            return 1000;
         }
         if(param1 == 4)
         {
            return 2000;
         }
         if(param1 == 5)
         {
            return 4000;
         }
         return 5000;
      }
      
      private function getDisplayMessageForReconnect() : String
      {
         return ResourceManager.getInstance().getString(BUNDLE,"MSG_CONNECT_FAILED_RECONNECT",[this.m_AttemptedReconnects]);
      }
      
      public function buildEventForReconnectionAndIncreaseRetries() : ConnectionEvent
      {
         this.m_AttemptedReconnects++;
         var _loc1_:ConnectionEvent = new ConnectionEvent(ConnectionEvent.LOGINWAIT);
         _loc1_.message = this.getDisplayMessageForReconnect();
         _loc1_.data = this.getReconnectionDelayForAttempt(this.m_AttemptedReconnects);
         return _loc1_;
      }
      
      public function shouldAttemptReconnect() : Boolean
      {
         var _loc1_:IServerConnection = Tibia.s_GetConnection();
         return (_loc1_ == null || _loc1_ is Connection) && this.m_AttemptedReconnects < MAXIMUM_ATTEMPTED_RETRIES - 1;
      }
      
      public function reset() : void
      {
         this.m_AttemptedReconnects = 0;
      }
   }
}
