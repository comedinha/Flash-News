package tibia.input.gameaction
{
   import shared.utility.Vector3D;
   import tibia.chat.MessageStorage;
   import tibia.chat.MessageMode;
   import tibia.worldmap.WorldMapStorage;
   import tibia.creatures.Creature;
   import tibia.chat.ChatStorage;
   
   public class GreetAction extends TalkActionImpl
   {
      
      private static const GREET_TEXT:String = "Hi";
       
      
      protected var m_NPC:Creature = null;
      
      public function GreetAction(param1:Creature)
      {
         super(GREET_TEXT,true,ChatStorage.LOCAL_CHANNEL_ID);
         if(param1 == null)
         {
            throw new ArgumentError("GreetAction.GreetAction: NPC must not be null.");
         }
         if(!param1.isNPC)
         {
            throw new ArgumentError("GreetAction.GreetAction: Creature is not an NPC.");
         }
         this.m_NPC = param1;
      }
      
      private function get isNpcInReach() : Boolean
      {
         var _loc1_:Vector3D = Tibia.s_GetPlayer().position;
         var _loc2_:Vector3D = this.m_NPC.position;
         if(_loc1_.z == _loc2_.z && Math.abs(_loc1_.x - _loc2_.x) <= MessageStorage.MAX_NPC_DISTANCE && Math.abs(_loc1_.y - _loc2_.y) <= MessageStorage.MAX_NPC_DISTANCE)
         {
            return true;
         }
         return false;
      }
      
      override public function perform(param1:Boolean = false) : void
      {
         if(!this.isNpcInReach)
         {
            Tibia.s_GetWorldMapStorage().addOnscreenMessage(MessageMode.MESSAGE_FAILURE,WorldMapStorage.MSG_NPC_TOO_FAR);
         }
         else
         {
            super.perform(param1);
         }
      }
   }
}
