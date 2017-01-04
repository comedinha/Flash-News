package tibia.sessiondump.controller
{
   import flash.events.EventDispatcher;
   import tibia.input.IActionImpl;
   import tibia.sessiondump.hints.condition.HintConditionAttack;
   import tibia.sessiondump.hints.condition.HintConditionAutowalk;
   import tibia.sessiondump.hints.condition.HintConditionBase;
   import tibia.sessiondump.hints.condition.HintConditionGreet;
   import tibia.sessiondump.hints.condition.HintConditionMove;
   import tibia.sessiondump.hints.condition.HintConditionTalk;
   import tibia.sessiondump.hints.condition.HintConditionUse;
   import tibia.sessiondump.hints.gameaction.SessiondumpHintsAutowalkActionImpl;
   import tibia.sessiondump.hints.gameaction.SessiondumpHintsGreetActionImpl;
   import tibia.sessiondump.hints.gameaction.SessiondumpHintsMoveActionImpl;
   import tibia.sessiondump.hints.gameaction.SessiondumpHintsTalkActionImpl;
   import tibia.sessiondump.hints.gameaction.SessiondumpHintsToggleAttackTargetActionImpl;
   import tibia.sessiondump.hints.gameaction.SessiondumpHintsUseActionImpl;
   
   public class SessiondumpHintActionsController extends EventDispatcher
   {
      
      private static var s_Instance:SessiondumpHintActionsController = null;
       
      
      private var m_CurrentCondition:HintConditionBase = null;
      
      private var m_ConditionCallback:Function = null;
      
      public function SessiondumpHintActionsController()
      {
         super();
      }
      
      public static function getInstance() : SessiondumpHintActionsController
      {
         if(s_Instance == null)
         {
            s_Instance = new SessiondumpHintActionsController();
         }
         return s_Instance;
      }
      
      private function conditionMet() : void
      {
         this.m_ConditionCallback.call();
         this.m_CurrentCondition = null;
         this.m_ConditionCallback = null;
      }
      
      public function get currentCondition() : HintConditionBase
      {
         return this.m_CurrentCondition;
      }
      
      public function actionPerformed(param1:IActionImpl) : void
      {
         var _loc2_:HintConditionAutowalk = null;
         var _loc3_:SessiondumpHintsAutowalkActionImpl = null;
         var _loc4_:HintConditionMove = null;
         var _loc5_:SessiondumpHintsMoveActionImpl = null;
         var _loc6_:HintConditionAttack = null;
         var _loc7_:SessiondumpHintsToggleAttackTargetActionImpl = null;
         var _loc8_:HintConditionGreet = null;
         var _loc9_:SessiondumpHintsGreetActionImpl = null;
         var _loc10_:HintConditionTalk = null;
         var _loc11_:SessiondumpHintsTalkActionImpl = null;
         var _loc12_:HintConditionUse = null;
         var _loc13_:SessiondumpHintsUseActionImpl = null;
         if(param1 is SessiondumpHintsAutowalkActionImpl && this.m_CurrentCondition is HintConditionAutowalk)
         {
            _loc2_ = this.m_CurrentCondition as HintConditionAutowalk;
            _loc3_ = param1 as SessiondumpHintsAutowalkActionImpl;
            if(_loc3_.meetsCondition(_loc2_))
            {
               this.conditionMet();
            }
         }
         else if(param1 is SessiondumpHintsMoveActionImpl && this.m_CurrentCondition is HintConditionMove)
         {
            _loc4_ = this.m_CurrentCondition as HintConditionMove;
            _loc5_ = param1 as SessiondumpHintsMoveActionImpl;
            if(_loc5_.meetsCondition(_loc4_))
            {
               this.conditionMet();
            }
         }
         else if(param1 is SessiondumpHintsToggleAttackTargetActionImpl && this.m_CurrentCondition is HintConditionAttack)
         {
            _loc6_ = this.m_CurrentCondition as HintConditionAttack;
            _loc7_ = param1 as SessiondumpHintsToggleAttackTargetActionImpl;
            if(_loc7_.meetsCondition(_loc6_))
            {
               this.conditionMet();
            }
         }
         else if(param1 is SessiondumpHintsGreetActionImpl && this.m_CurrentCondition is HintConditionGreet)
         {
            _loc8_ = this.m_CurrentCondition as HintConditionGreet;
            _loc9_ = param1 as SessiondumpHintsGreetActionImpl;
            if(_loc9_.meetsCondition(_loc8_))
            {
               this.conditionMet();
            }
         }
         else if(param1 is SessiondumpHintsTalkActionImpl && this.m_CurrentCondition is HintConditionTalk)
         {
            _loc10_ = this.m_CurrentCondition as HintConditionTalk;
            _loc11_ = param1 as SessiondumpHintsTalkActionImpl;
            if(_loc11_.meetsCondition(_loc10_))
            {
               this.conditionMet();
            }
         }
         else if(param1 is SessiondumpHintsUseActionImpl && this.m_CurrentCondition is HintConditionUse)
         {
            _loc12_ = this.m_CurrentCondition as HintConditionUse;
            _loc13_ = param1 as SessiondumpHintsUseActionImpl;
            if(_loc13_.meetsCondition(_loc12_))
            {
               this.conditionMet();
            }
         }
      }
      
      public function registerConditionListener(param1:HintConditionBase, param2:Function) : void
      {
         this.m_CurrentCondition = param1;
         this.m_ConditionCallback = param2;
      }
   }
}
