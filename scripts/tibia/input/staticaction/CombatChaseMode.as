package tibia.input.staticaction
{
   import tibia.options.OptionsStorage;
   import tibia.network.Communication;
   
   public class CombatChaseMode extends StaticAction
   {
       
      
      public function CombatChaseMode(param1:int, param2:String, param3:uint)
      {
         super(param1,param2,param3,false);
      }
      
      override public function perform(param1:Boolean = false) : void
      {
         var _loc2_:OptionsStorage = Tibia.s_GetOptions();
         if(_loc2_ != null)
         {
            if(_loc2_.combatChaseMode == OptionsStorage.COMBAT_CHASE_OFF)
            {
               _loc2_.combatChaseMode = OptionsStorage.COMBAT_CHASE_ON;
            }
            else
            {
               _loc2_.combatChaseMode = OptionsStorage.COMBAT_CHASE_OFF;
            }
         }
         var _loc3_:Communication = Tibia.s_GetCommunication();
         if(_loc3_ != null && _loc3_.isGameRunning)
         {
            _loc3_.sendCSETTACTICS(_loc2_.combatAttackMode,_loc2_.combatChaseMode,_loc2_.combatSecureMode,_loc2_.combatPVPMode);
         }
      }
   }
}
