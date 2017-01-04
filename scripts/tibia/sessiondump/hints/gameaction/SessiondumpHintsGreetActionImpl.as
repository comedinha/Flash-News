package tibia.sessiondump.hints.gameaction
{
   import shared.utility.StringHelper;
   import tibia.creatures.Creature;
   import tibia.input.gameaction.GreetAction;
   import tibia.sessiondump.controller.SessiondumpHintActionsController;
   import tibia.sessiondump.hints.condition.HintConditionGreet;
   
   public class SessiondumpHintsGreetActionImpl extends GreetAction
   {
       
      
      public function SessiondumpHintsGreetActionImpl(param1:Creature)
      {
         super(param1);
      }
      
      override public function perform(param1:Boolean = false) : void
      {
         SessiondumpHintActionsController.getInstance().actionPerformed(this);
      }
      
      public function meetsCondition(param1:HintConditionGreet) : Boolean
      {
         return StringHelper.s_EqualsIgnoreCase(param1.creatureName,m_NPC.name);
      }
   }
}
