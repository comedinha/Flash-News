package tibia.input.staticaction
{
   import tibia.options.OptionsStorage;
   import tibia.input.MappingSet;
   
   public class ToggleMappingMode extends StaticAction
   {
       
      
      public function ToggleMappingMode(param1:int, param2:String, param3:uint)
      {
         super(param1,param2,param3,false);
      }
      
      override public function perform(param1:Boolean = false) : void
      {
         var _loc2_:OptionsStorage = Tibia.s_GetOptions();
         if(_loc2_ != null)
         {
            if(_loc2_.generalInputSetMode == MappingSet.CHAT_MODE_OFF)
            {
               _loc2_.generalInputSetMode = MappingSet.CHAT_MODE_ON;
            }
            else
            {
               _loc2_.generalInputSetMode = MappingSet.CHAT_MODE_OFF;
            }
         }
      }
   }
}
