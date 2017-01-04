package tibia.input
{
   import flash.display.InteractiveObject;
   import flash.events.MouseEvent;
   
   public class MouseClickBothEvent extends MouseEvent
   {
       
      
      public function MouseClickBothEvent(param1:String, param2:Boolean = true, param3:Boolean = false, param4:Number = NaN, param5:Number = NaN, param6:InteractiveObject = null, param7:Boolean = false, param8:Boolean = false, param9:Boolean = false, param10:Boolean = false, param11:int = 0)
      {
         super(MouseEvent.CLICK,param2,param3,param4,param5,param6,param7,param8,param9,param10,param11);
      }
   }
}
