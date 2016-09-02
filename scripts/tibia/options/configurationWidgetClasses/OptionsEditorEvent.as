package tibia.options.configurationWidgetClasses
{
   import flash.events.Event;
   
   public class OptionsEditorEvent extends Event
   {
      
      public static const VALUE_CHANGE:String = "valueChange";
       
      
      public function OptionsEditorEvent(param1:String, param2:Boolean = true, param3:Boolean = false)
      {
         super(param1,param2,param3);
      }
      
      override public function clone() : Event
      {
         return new OptionsEditorEvent(type,bubbles,cancelable);
      }
   }
}
