package tibia.sessiondump.hints.gameaction
{
   import shared.utility.Vector3D;
   import tibia.appearances.ObjectInstance;
   import tibia.input.gameaction.MoveActionImpl;
   import tibia.sessiondump.controller.SessiondumpHintActionsController;
   import tibia.sessiondump.hints.condition.HintConditionMove;
   
   public class SessiondumpHintsMoveActionImpl extends MoveActionImpl
   {
       
      
      public function SessiondumpHintsMoveActionImpl(param1:Vector3D, param2:ObjectInstance, param3:int, param4:Vector3D, param5:int)
      {
         super(param1,param2,param3,param4,param5);
      }
      
      override public function perform(param1:Boolean = false) : void
      {
         SessiondumpHintActionsController.getInstance().actionPerformed(this);
      }
      
      public function meetsCondition(param1:HintConditionMove) : Boolean
      {
         return m_SourceAbsolute.equals(param1.sourcePosition) && m_ObjectType.ID == param1.objectTypeID && m_MoveAmount == param1.objectAmount && m_DestAbsolute.equals(param1.destinationPosition);
      }
   }
}
