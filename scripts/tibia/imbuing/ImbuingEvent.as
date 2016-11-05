package tibia.imbuing
{
   import flash.events.Event;
   
   public class ImbuingEvent extends Event
   {
      
      public static const IMBUEMENT_SLOT_SELECTED:String = "imbuementSlotSelected";
      
      public static const IMBUEMENT_DATA_CHANGED:String = "imbuementDataChanged";
       
      
      private var m_Message:String = null;
      
      private var m_Data:Object = null;
      
      public function ImbuingEvent(param1:String, param2:Boolean = false, param3:Boolean = false)
      {
         super(param1,param2,param3);
      }
      
      public function get data() : Object
      {
         return this.m_Data;
      }
      
      public function set data(param1:Object) : void
      {
         this.m_Data = param1;
      }
      
      public function get message() : String
      {
         return this.m_Message;
      }
      
      override public function clone() : Event
      {
         var _loc1_:ImbuingEvent = new ImbuingEvent(type,bubbles,cancelable);
         _loc1_.m_Message = this.m_Message;
         _loc1_.m_Data = this.m_Data;
         return _loc1_;
      }
      
      public function set message(param1:String) : void
      {
         this.m_Message = param1;
      }
   }
}
