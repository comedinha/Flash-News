package tibia.input.staticaction
{
   import tibia.options.OptionsStorage;
   
   public class ToggleActionBarsLock extends StaticAction
   {
       
      
      public function ToggleActionBarsLock(param1:int, param2:String, param3:uint)
      {
         super(param1,param2,param3,false);
      }
      
      override public function perform(param1:Boolean = false) : void
      {
         var _loc2_:OptionsStorage = Tibia.s_GetOptions();
         if(_loc2_ != null)
         {
            _loc2_.generalActionBarsLock = !_loc2_.generalActionBarsLock;
         }
      }
   }
}
