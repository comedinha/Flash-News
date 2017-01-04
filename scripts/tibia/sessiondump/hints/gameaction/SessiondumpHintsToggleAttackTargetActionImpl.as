package tibia.sessiondump.hints.gameaction
{
   import shared.utility.StringHelper;
   import tibia.creatures.Creature;
   import tibia.input.gameaction.ToggleAttackTargetActionImpl;
   import tibia.sessiondump.controller.SessiondumpHintActionsController;
   import tibia.sessiondump.hints.condition.HintConditionAttack;
   
   public class SessiondumpHintsToggleAttackTargetActionImpl extends ToggleAttackTargetActionImpl
   {
       
      
      public function SessiondumpHintsToggleAttackTargetActionImpl(param1:Creature, param2:Boolean)
      {
         super(param1,param2);
      }
      
      override public function perform(param1:Boolean = false) : void
      {
         Tibia.s_GetCreatureStorage().toggleAttackTarget(m_Creature,false);
         SessiondumpHintActionsController.getInstance().actionPerformed(this);
      }
      
      public function get creature() : Creature
      {
         return m_Creature;
      }
      
      public function meetsCondition(param1:HintConditionAttack) : Boolean
      {
         return StringHelper.s_EqualsIgnoreCase(param1.creatureName,m_Creature.name);
      }
   }
}
