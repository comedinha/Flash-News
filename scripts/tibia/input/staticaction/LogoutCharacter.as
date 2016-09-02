package tibia.input.staticaction
{
   public class LogoutCharacter extends StaticAction
   {
       
      
      public function LogoutCharacter(param1:int, param2:String, param3:uint)
      {
         super(param1,param2,param3,false);
      }
      
      override public function perform(param1:Boolean = false) : void
      {
         var _loc2_:Tibia = Tibia.s_GetInstance();
         if(_loc2_ != null)
         {
            _loc2_.logoutCharacter();
         }
      }
   }
}
