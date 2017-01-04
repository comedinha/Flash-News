package tibia.chat
{
   import shared.utility.Vector3D;
   
   public class MessageStorage
   {
      
      protected static const MESSAGE_BASE_DELAY:uint = 1000;
      
      public static const MAX_NPC_DISTANCE:uint = 3;
       
      
      protected var m_CurrentBlock:MessageBlock = null;
      
      public function MessageStorage()
      {
         super();
      }
      
      public static function s_GetTalkDelay(param1:String) : uint
      {
         return MESSAGE_BASE_DELAY + (4000 * param1.length / 256 + 3000);
      }
      
      public function startMessageBlock(param1:String, param2:Vector3D, param3:String) : MessageBlock
      {
         if(param1 == null)
         {
            throw new ArgumentError("MessageStorage.startMessageBlock: speaker is null.");
         }
         if(this.getMessageBlock(param1) != null)
         {
            this.m_CurrentBlock.dispose(true);
         }
         if(this.m_CurrentBlock != null)
         {
            this.m_CurrentBlock.dispose(false);
         }
         this.m_CurrentBlock = new MessageBlock(param1,param2);
         this.m_CurrentBlock.addText(param3);
         return this.m_CurrentBlock;
      }
      
      public function addTextToBlock(param1:String, param2:String) : void
      {
         var _loc3_:MessageBlock = this.getMessageBlock(param1);
         if(_loc3_ != null)
         {
            _loc3_.addText(param2);
         }
      }
      
      public function getMessageBlock(param1:String) : MessageBlock
      {
         if(param1 == null)
         {
            throw new ArgumentError("MessageStorage:getMessageBlock: speaker is null.");
         }
         if(this.m_CurrentBlock != null && this.m_CurrentBlock.speaker == param1)
         {
            return this.m_CurrentBlock;
         }
         return null;
      }
   }
}
