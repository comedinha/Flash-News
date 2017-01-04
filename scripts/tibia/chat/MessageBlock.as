package tibia.chat
{
   import flash.events.TimerEvent;
   import shared.utility.Vector3D;
   import tibia.creatures.Creature;
   import tibia.worldmap.OnscreenMessageBox;
   
   public class MessageBlock
   {
       
      
      protected var m_Position:Vector3D = null;
      
      protected var m_TextPieces:Vector.<String>;
      
      protected var m_TimerEventRegistered:Boolean = false;
      
      protected var m_MinTimeForNextOnscreenMessage:uint = 0;
      
      protected var m_Speaker:String = null;
      
      protected var m_LastOnscreenBox:OnscreenMessageBox = null;
      
      protected var m_NextOnscreenMessageIndex:uint = 0;
      
      public function MessageBlock(param1:String, param2:Vector3D)
      {
         this.m_TextPieces = new Vector.<String>();
         super();
         if(param1 == null)
         {
            throw new ArgumentError("MessageBlock: speaker is null.");
         }
         if(param2 == null)
         {
            throw new ArgumentError("MessageBlock: display position is null.");
         }
         this.m_Speaker = param1;
         this.m_Position = param2;
      }
      
      public function dispose(param1:Boolean = true) : void
      {
         if(this.m_TimerEventRegistered)
         {
            Tibia.s_GetSecondaryTimer().removeEventListener(TimerEvent.TIMER,this.onSecondaryTimer);
            this.m_TimerEventRegistered = false;
         }
         if(param1 && this.m_LastOnscreenBox != null)
         {
            this.m_LastOnscreenBox.removeMessages();
            Tibia.s_GetWorldMapStorage().invalidateOnscreenMessages();
         }
      }
      
      public function get posititon() : Vector3D
      {
         return this.m_Position;
      }
      
      protected function showNextOnscreenMessage() : void
      {
         if(this.m_NextOnscreenMessageIndex < this.m_TextPieces.length)
         {
            if(this.isNpcInReach())
            {
               this.m_LastOnscreenBox = Tibia.s_GetWorldMapStorage().addOnscreenMessage(this.m_Position,0,this.m_Speaker,0,MessageMode.MESSAGE_NPC_FROM,this.m_TextPieces[this.m_NextOnscreenMessageIndex]);
               this.m_MinTimeForNextOnscreenMessage = Tibia.s_GetTibiaTimer() + MessageStorage.s_GetTalkDelay(this.m_TextPieces[this.m_NextOnscreenMessageIndex]);
               this.m_NextOnscreenMessageIndex++;
            }
            else
            {
               this.m_NextOnscreenMessageIndex = this.m_TextPieces.length;
            }
         }
      }
      
      public function addText(param1:String) : void
      {
         if(param1 == null)
         {
            throw new ArgumentError("MessageBlock.addText: text is null.");
         }
         this.m_TextPieces.push(param1);
         var _loc2_:int = this.m_NextOnscreenMessageIndex == 0?int(MessageMode.MESSAGE_NPC_FROM_START_BLOCK):int(MessageMode.MESSAGE_NPC_FROM);
         Tibia.s_GetChatStorage().addChannelMessage(ChatStorage.NPC_CHANNEL_ID,0,this.m_Speaker,0,_loc2_,param1);
         if(this.m_NextOnscreenMessageIndex == 0 || this.m_NextOnscreenMessageIndex > 0 && Tibia.s_GetTibiaTimer() > this.m_MinTimeForNextOnscreenMessage)
         {
            this.showNextOnscreenMessage();
         }
         else if(!this.m_TimerEventRegistered)
         {
            Tibia.s_GetSecondaryTimer().addEventListener(TimerEvent.TIMER,this.onSecondaryTimer);
            this.m_TimerEventRegistered = true;
         }
      }
      
      private function onSecondaryTimer(param1:TimerEvent) : void
      {
         if(this.m_NextOnscreenMessageIndex < this.m_TextPieces.length && this.isNpcInReach())
         {
            if(Tibia.s_GetTibiaTimer() > this.m_MinTimeForNextOnscreenMessage)
            {
               this.showNextOnscreenMessage();
            }
         }
         else
         {
            Tibia.s_GetSecondaryTimer().removeEventListener(TimerEvent.TIMER,this.onSecondaryTimer);
            this.m_TimerEventRegistered = false;
         }
      }
      
      private function isNpcInReach() : Boolean
      {
         var _loc2_:Vector3D = null;
         var _loc3_:Vector3D = null;
         var _loc1_:Creature = Tibia.s_GetCreatureStorage().getCreatureByName(this.m_Speaker);
         if(_loc1_ != null)
         {
            _loc2_ = Tibia.s_GetPlayer().position;
            _loc3_ = _loc1_.position;
            if(_loc2_.z == _loc3_.z && Math.abs(_loc2_.x - _loc3_.x) <= MessageStorage.MAX_NPC_DISTANCE && Math.abs(_loc2_.y - _loc3_.y) <= MessageStorage.MAX_NPC_DISTANCE)
            {
               return true;
            }
            return false;
         }
         return false;
      }
      
      public function get speaker() : String
      {
         return this.m_Speaker;
      }
   }
}
