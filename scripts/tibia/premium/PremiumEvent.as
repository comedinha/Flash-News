package tibia.premium
{
   import flash.events.Event;
   
   public class PremiumEvent extends Event
   {
      
      public static const TRIGGER:String = "PREMIUMTRIGGER";
      
      public static const HIGHLIGHT:String = "PREMIUMHIGHLIGHT";
       
      
      protected var m_HighlightExpiry:int = 0;
      
      protected var m_Messages:Vector.<PremiumMessage> = null;
      
      public function PremiumEvent(param1:String, param2:Boolean = false, param3:Boolean = false, param4:Vector.<PremiumMessage> = null, param5:int = 0)
      {
         super(param1,param2,param3);
         this.m_Messages = param4;
         this.m_HighlightExpiry = param5;
      }
      
      public function get highlight() : Boolean
      {
         return true;
      }
      
      public function get highlightExpiry() : int
      {
         return this.m_HighlightExpiry;
      }
      
      public function set messages(param1:Vector.<PremiumMessage>) : void
      {
         this.m_Messages = param1;
      }
      
      public function get messages() : Vector.<PremiumMessage>
      {
         return this.m_Messages;
      }
      
      public function set highlightExpiry(param1:int) : void
      {
         this.m_HighlightExpiry = param1;
      }
      
      override public function clone() : Event
      {
         return new PremiumEvent(type,bubbles,cancelable,this.messages,this.highlightExpiry);
      }
   }
}
