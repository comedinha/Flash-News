package tibia.input.staticaction
{
   import tibia.network.Communication;
   
   public class PlayerTurn extends StaticAction
   {
      
      public static const SOUTH:int = 3;
      
      public static const NORTH:int = 1;
      
      public static const EAST:int = 0;
      
      public static const WEST:int = 2;
       
      
      protected var m_Direction:int = -1;
      
      public function PlayerTurn(param1:int, param2:String, param3:uint, param4:int)
      {
         super(param1,param2,param3,false);
         if(param4 < EAST || param4 > SOUTH)
         {
            throw new ArgumentError("PlayerTurn.PlayerTurn: Invalid direction: " + param4);
         }
         this.m_Direction = param4;
      }
      
      override public function perform(param1:Boolean = false) : void
      {
         var _loc2_:Communication = Tibia.s_GetCommunication();
         if(_loc2_ != null && _loc2_.isGameRunning)
         {
            switch(this.m_Direction)
            {
               case EAST:
                  _loc2_.sendCROTATEEAST();
                  break;
               case NORTH:
                  _loc2_.sendCROTATENORTH();
                  break;
               case WEST:
                  _loc2_.sendCROTATEWEST();
                  break;
               case SOUTH:
                  _loc2_.sendCROTATESOUTH();
            }
         }
      }
   }
}
