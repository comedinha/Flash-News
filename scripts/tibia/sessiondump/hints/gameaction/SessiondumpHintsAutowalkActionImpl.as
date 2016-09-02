package tibia.sessiondump.hints.gameaction
{
   import tibia.input.gameaction.AutowalkActionImpl;
   import tibia.sessiondump.controller.SessiondumpHintActionsController;
   import tibia.sessiondump.hints.condition.HintConditionAutowalk;
   
   public class SessiondumpHintsAutowalkActionImpl extends AutowalkActionImpl
   {
       
      
      public function SessiondumpHintsAutowalkActionImpl(param1:int, param2:int, param3:int, param4:Boolean, param5:Boolean)
      {
         super(param1,param2,param3,param4,param5);
      }
      
      override public function perform(param1:Boolean = false) : void
      {
         SessiondumpHintActionsController.getInstance().actionPerformed(this);
      }
      
      public function meetsCondition(param1:HintConditionAutowalk) : Boolean
      {
         return param1.mapCoordinate.equals(m_Destination);
      }
   }
}
