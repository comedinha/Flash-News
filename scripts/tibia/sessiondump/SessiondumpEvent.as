package tibia.sessiondump
{
   import flash.events.Event;
   
   public class SessiondumpEvent extends Event
   {
      
      public static const TARGET_REACHED:String = "TARGET_REACHED";
      
      public static const HEADER_READ:String = "HEADER_READ";
      
      public static const MESSAGE_AVAILABLE:String = "MESSAGE_AVAILABLE";
      
      public static const PACKET_AVAILABLE:String = "PACKET_AVAILABLE";
      
      public static const MESSAGE_PROCESSED:String = "MESSAGE_PROCESSED";
      
      public static const COMPLETE:String = Event.COMPLETE;
       
      
      protected var m_MessageTimestamp:uint = 0;
      
      protected var m_ProcessMessage:Boolean = true;
      
      protected var m_ClientMessage:Boolean = false;
      
      protected var m_MessageType:uint = 0;
      
      public function SessiondumpEvent(param1:String, param2:Boolean = false, param3:Boolean = false, param4:uint = 0, param5:Boolean = false, param6:uint = 0)
      {
         super(param1,param2,param3);
         this.m_MessageType = param4;
         this.m_ClientMessage = param5;
         this.m_MessageTimestamp = param6;
      }
      
      public function get messageType() : uint
      {
         return this.m_MessageType;
      }
      
      public function get messageTimestamp() : uint
      {
         return this.m_MessageTimestamp;
      }
      
      public function set processMessage(param1:Boolean) : void
      {
         this.m_ProcessMessage = param1;
      }
      
      public function get processMessage() : Boolean
      {
         return this.m_ProcessMessage;
      }
      
      public function get clientMessage() : Boolean
      {
         return this.m_ClientMessage;
      }
      
      override public function clone() : Event
      {
         return new SessiondumpEvent(type,bubbles,cancelable,this.m_MessageType,this.m_ClientMessage,this.m_MessageTimestamp);
      }
   }
}
