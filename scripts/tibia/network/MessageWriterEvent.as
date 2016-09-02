package tibia.network
{
   import flash.events.Event;
   
   public class MessageWriterEvent extends Event
   {
      
      public static const FINISHED:String = "FINISHED";
       
      
      protected var m_Message:String = null;
      
      protected var m_Data = null;
      
      public function MessageWriterEvent(param1:String, param2:Boolean = false, param3:Boolean = false, param4:String = null, param5:* = null)
      {
         super(param1,param2,param3);
         this.m_Message = param4;
         this.m_Data = param5;
      }
      
      public function get data() : *
      {
         return this.m_Data;
      }
      
      public function set data(param1:*) : void
      {
         this.m_Data = param1;
      }
      
      public function get message() : String
      {
         return this.m_Message;
      }
      
      override public function clone() : Event
      {
         return new ConnectionEvent(type,bubbles,cancelable,this.message,this.data);
      }
      
      public function set message(param1:String) : void
      {
         this.m_Message = param1;
      }
   }
}
