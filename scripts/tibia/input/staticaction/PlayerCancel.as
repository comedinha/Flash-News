package tibia.input.staticaction
{
   import tibia.creatures.CreatureStorage;
   import tibia.creatures.Player;
   import tibia.network.Communication;
   
   public class PlayerCancel extends StaticAction
   {
       
      
      public function PlayerCancel(param1:int, param2:String, param3:uint)
      {
         super(param1,param2,param3,false);
      }
      
      override public function perform(param1:Boolean = false) : void
      {
         var _loc2_:Communication = Tibia.s_GetCommunication();
         var _loc3_:CreatureStorage = Tibia.s_GetCreatureStorage();
         var _loc4_:Player = Tibia.s_GetPlayer();
         if(_loc2_ != null && _loc2_.isGameRunning && _loc3_ != null && _loc4_ != null)
         {
            _loc4_.stopAutowalk(false);
            _loc3_.setAttackTarget(null,false);
            _loc2_.sendCCANCEL();
         }
      }
   }
}
