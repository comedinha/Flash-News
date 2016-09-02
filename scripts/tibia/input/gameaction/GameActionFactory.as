package tibia.input.gameaction
{
   import shared.utility.Vector3D;
   import tibia.creatures.Creature;
   import tibia.appearances.ObjectInstance;
   
   public class GameActionFactory
   {
       
      
      public function GameActionFactory()
      {
         super();
      }
      
      public function createUseAction(param1:Vector3D, param2:*, param3:int, param4:int = 0) : UseActionImpl
      {
         return new UseActionImpl(param1,param2,param3,param4);
      }
      
      public function createGreetAction(param1:Creature) : GreetAction
      {
         return new GreetAction(param1);
      }
      
      public function createMoveAction(param1:Vector3D, param2:ObjectInstance, param3:int, param4:Vector3D, param5:int) : MoveActionImpl
      {
         return new MoveActionImpl(param1,param2,param3,param4,param5);
      }
      
      public function createAutowalkAction(param1:int, param2:int, param3:int, param4:Boolean, param5:Boolean) : AutowalkActionImpl
      {
         return new AutowalkActionImpl(param1,param2,param3,param4,param5);
      }
      
      public function createTalkAction(param1:String, param2:Boolean) : TalkActionImpl
      {
         return new TalkActionImpl(param1,param2);
      }
      
      public function createToggleAttackTargetAction(param1:Creature, param2:Boolean) : ToggleAttackTargetActionImpl
      {
         return new ToggleAttackTargetActionImpl(param1,param2);
      }
   }
}
