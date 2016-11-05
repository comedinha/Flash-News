package tibia.game
{
   import flash.events.Event;
   
   public class ExtendedTooltipEvent extends Event
   {
      
      public static const HIDE:String = "extendedTooltipHide";
      
      public static const SHOW:String = "extendedTooltipShow";
       
      
      private var m_Tooltip:String = null;
      
      public function ExtendedTooltipEvent(param1:String, param2:Boolean = true, param3:Boolean = false, param4:String = null)
      {
         super(param1,param2,param3);
         this.m_Tooltip = param4;
      }
      
      public function get tooltip() : String
      {
         return this.m_Tooltip;
      }
      
      override public function clone() : Event
      {
         return new GameEvent(type,bubbles,cancelable,this.m_Tooltip);
      }
   }
}
