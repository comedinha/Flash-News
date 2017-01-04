package tibia.sessiondump.hints.gameaction
{
   import shared.utility.StringHelper;
   import tibia.input.gameaction.TalkActionImpl;
   import tibia.sessiondump.controller.SessiondumpHintActionsController;
   import tibia.sessiondump.hints.condition.HintConditionTalk;
   
   public class SessiondumpHintsTalkActionImpl extends TalkActionImpl
   {
       
      
      public function SessiondumpHintsTalkActionImpl(param1:String, param2:Boolean, param3:int = -1)
      {
         super(param1,param2,param3);
      }
      
      override public function perform(param1:Boolean = false) : void
      {
         super.perform(param1);
         SessiondumpHintActionsController.getInstance().actionPerformed(this);
      }
      
      public function meetsCondition(param1:HintConditionTalk) : Boolean
      {
         return StringHelper.s_EqualsIgnoreCase(param1.text,m_Text);
      }
   }
}
