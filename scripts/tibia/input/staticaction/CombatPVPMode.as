package tibia.input.staticaction
{
   import tibia.options.OptionsStorage;
   import tibia.network.Communication;
   
   public class CombatPVPMode extends StaticAction
   {
       
      
      private var m_PVPMode:uint = 0;
      
      public function CombatPVPMode(param1:int, param2:String, param3:uint, param4:uint)
      {
         super(param1,param2,param3,false);
         if(param4 != OptionsStorage.COMBAT_PVP_MODE_DOVE && param4 != OptionsStorage.COMBAT_PVP_MODE_WHITE_HAND && param4 != OptionsStorage.COMBAT_PVP_MODE_YELLOW_HAND && param4 != OptionsStorage.COMBAT_PVP_MODE_RED_FIST)
         {
            throw new ArgumentError("CombatPVPMode.CombatPVPMode: Invalid pvp mode: " + param4 + ".");
         }
         this.m_PVPMode = param4;
      }
      
      override public function perform(param1:Boolean = false) : void
      {
         var _loc2_:OptionsStorage = Tibia.s_GetOptions();
         if(_loc2_ != null)
         {
            _loc2_.combatPVPMode = this.m_PVPMode;
         }
         var _loc3_:Communication = Tibia.s_GetCommunication();
         if(_loc3_ != null && _loc3_.isGameRunning)
         {
            _loc3_.sendCSETTACTICS(_loc2_.combatAttackMode,_loc2_.combatChaseMode,_loc2_.combatSecureMode,_loc2_.combatPVPMode);
         }
      }
   }
}
