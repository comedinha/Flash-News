package tibia.network
{
   import flash.events.Event;
   
   public class ConnectionEvent extends Event
   {
      
      public static const LOGINADVICE:String = "LOGINADVICE";
      
      public static const LOGINWAIT:String = "LOGINWAIT";
      
      public static const PACKET_RECEIVED:String = "PACKET_RECEIVED";
      
      public static const CONNECTION_RECOVERED:String = "CONNECTION_RECOVERED";
      
      public static const CREATED:String = "CREATED";
      
      public static const DEATH_REGULAR:int = 0;
      
      public static const DEATH_BLESSED:int = 2;
      
      public static const DEATH_NOPENALTY:int = 3;
      
      public static const DEATH_UNFAIR:int = 1;
      
      public static const CONNECTION_LOST:String = "CONNECTION_LOST";
      
      public static const ERROR:String = "ERROR";
      
      public static const DEAD:String = "DEAD";
      
      public static const GAME:String = "GAME";
      
      public static const PENDING:String = "PENDING";
      
      public static const CONNECTING:String = "CONNECTING";
      
      public static const DISCONNECTED:String = "DISCONNECTED";
      
      public static const LOGINERROR:String = "LOGINERROR";
       
      
      protected var m_ErrorType:int = -1;
      
      protected var m_Message:String = null;
      
      protected var m_Data = null;
      
      public function ConnectionEvent(param1:String, param2:Boolean = false, param3:Boolean = false, param4:String = null, param5:* = null, param6:int = -1)
      {
         super(param1,param2,param3);
         this.m_Message = param4;
         this.m_Data = param5;
         this.m_ErrorType = param6;
      }
      
      public function get errorType() : int
      {
         return this.m_ErrorType;
      }
      
      public function set errorType(param1:int) : void
      {
         this.m_ErrorType = param1;
      }
      
      public function get message() : String
      {
         return this.m_Message;
      }
      
      public function get data() : *
      {
         return this.m_Data;
      }
      
      public function set message(param1:String) : void
      {
         this.m_Message = param1;
      }
      
      public function set data(param1:*) : void
      {
         this.m_Data = param1;
      }
      
      override public function clone() : Event
      {
         return new ConnectionEvent(type,bubbles,cancelable,this.message,this.data,this.errorType);
      }
   }
}
