package tibia.chat.chatWidgetClasses
{
   import flash.events.EventDispatcher;
   import mx.events.PropertyChangeEvent;
   import mx.events.PropertyChangeEventKind;
   
   public class NicklistItem extends EventDispatcher
   {
      
      public static const STATE_SUBSCRIBER:uint = 2;
      
      public static const STATE_PENDING:uint = 3;
      
      public static const STATE_UNKNOWN:uint = 0;
      
      public static const STATE_INVITED:uint = 1;
       
      
      private var m_Name:String = null;
      
      private var m_State:uint = 0;
      
      public function NicklistItem(param1:String)
      {
         super();
         this.m_Name = param1;
      }
      
      public function get state() : uint
      {
         return this.m_State;
      }
      
      public function set state(param1:uint) : void
      {
         if(param1 != STATE_UNKNOWN && param1 != STATE_INVITED && param1 != STATE_SUBSCRIBER && param1 != STATE_PENDING)
         {
            throw new ArgumentError("NicklistItem.state (set): Invalid state " + param1);
         }
         this.m_State = param1;
         var _loc2_:PropertyChangeEvent = new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE);
         _loc2_.kind = PropertyChangeEventKind.UPDATE;
         _loc2_.property = "state";
         dispatchEvent(_loc2_);
      }
      
      public function get name() : String
      {
         return this.m_Name;
      }
   }
}
