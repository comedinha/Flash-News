package tibia.input.staticaction
{
   import tibia.options.OptionsStorage;
   import tibia.network.Communication;
   
   public class CombatAttackMode extends StaticAction
   {
       
      
      private var m_AttackMode:int = 2;
      
      public function CombatAttackMode(param1:int, param2:String, param3:uint, param4:int)
      {
         super(param1,param2,param3,false);
         if(param4 != OptionsStorage.COMBAT_ATTACK_BALANCED && param4 != OptionsStorage.COMBAT_ATTACK_DEFENSIVE && param4 != OptionsStorage.COMBAT_ATTACK_OFFENSIVE)
         {
            throw new ArgumentError("CombatAttackMode.CombatAttackMode: Invalid attack mode: " + param4 + ".");
         }
         this.m_AttackMode = param4;
      }
      
      override public function perform(param1:Boolean = false) : void
      {
         var _loc2_:OptionsStorage = Tibia.s_GetOptions();
         if(_loc2_ != null)
         {
            _loc2_.combatAttackMode = this.m_AttackMode;
         }
         var _loc3_:Communication = Tibia.s_GetCommunication();
         if(_loc3_ != null && _loc3_.isGameRunning)
         {
            _loc3_.sendCSETTACTICS(_loc2_.combatAttackMode,_loc2_.combatChaseMode,_loc2_.combatSecureMode,_loc2_.combatPVPMode);
         }
      }
   }
}
