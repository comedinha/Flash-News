package tibia.input.staticaction
{
   import shared.utility.Vector3D;
   import tibia.input.gameaction.AutowalkActionImpl;
   import tibia.network.Communication;
   import tibia.creatures.Player;
   
   public class PlayerMove extends StaticAction
   {
      
      public static const SOUTH_WEST:int = 5;
      
      public static const STOP:int = 8;
      
      public static const NORTH:int = 2;
      
      public static const NORTH_WEST:int = 3;
      
      public static const SOUTH:int = 6;
      
      public static const WEST:int = 4;
      
      public static const SOUTH_EAST:int = 7;
      
      public static const NORTH_EAST:int = 1;
      
      public static const EAST:int = 0;
       
      
      protected var m_DeltaX:int = 0;
      
      protected var m_DeltaY:int = 0;
      
      public function PlayerMove(param1:int, param2:String, param3:uint, param4:int)
      {
         super(param1,param2,param3,false);
         switch(param4)
         {
            case EAST:
               this.m_DeltaX = 1;
               this.m_DeltaY = 0;
               break;
            case NORTH_EAST:
               this.m_DeltaX = 1;
               this.m_DeltaY = -1;
               break;
            case NORTH:
               this.m_DeltaX = 0;
               this.m_DeltaY = -1;
               break;
            case NORTH_WEST:
               this.m_DeltaX = -1;
               this.m_DeltaY = -1;
               break;
            case WEST:
               this.m_DeltaX = -1;
               this.m_DeltaY = 0;
               break;
            case SOUTH_WEST:
               this.m_DeltaX = -1;
               this.m_DeltaY = 1;
               break;
            case SOUTH:
               this.m_DeltaX = 0;
               this.m_DeltaY = 1;
               break;
            case SOUTH_EAST:
               this.m_DeltaX = 1;
               this.m_DeltaY = 1;
               break;
            case STOP:
               this.m_DeltaX = 0;
               this.m_DeltaY = 0;
               break;
            default:
               throw new ArgumentError("PlayerMove.PlayerMove: Invalid movement direction: " + param4 + ".");
         }
      }
      
      override public function perform(param1:Boolean = false) : void
      {
         var _loc4_:Vector3D = null;
         var _loc5_:* = false;
         var _loc6_:AutowalkActionImpl = null;
         var _loc2_:Communication = Tibia.s_GetCommunication();
         var _loc3_:Player = Tibia.s_GetPlayer();
         if(_loc2_ != null && _loc2_.isGameRunning && _loc3_ != null)
         {
            if(this.m_DeltaX == 0 && this.m_DeltaY == 0)
            {
               _loc2_.sendCSTOP();
            }
            else
            {
               _loc4_ = _loc3_.anticipatedPosition;
               _loc5_ = Math.abs(this.m_DeltaX) + Math.abs(this.m_DeltaY) > 1;
               _loc6_ = Tibia.s_GameActionFactory.createAutowalkAction(_loc4_.x + this.m_DeltaX,_loc4_.y + this.m_DeltaY,_loc4_.z,_loc5_,true);
               _loc6_.perform();
            }
         }
      }
   }
}
