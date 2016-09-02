package tibia.input
{
   import flash.events.KeyboardEvent;
   
   public class ModifierKeyEvent extends KeyboardEvent
   {
      
      public static const MODIFIER_KEYS_CHANGED:String = "modifierKeysChanged";
       
      
      public function ModifierKeyEvent(param1:String, param2:Boolean = true, param3:Boolean = false, param4:uint = 0, param5:uint = 0, param6:uint = 0, param7:Boolean = false, param8:Boolean = false, param9:Boolean = false)
      {
         super(param1,param2,param3,param4,param5,param6,param7,param8,param9);
      }
   }
}
