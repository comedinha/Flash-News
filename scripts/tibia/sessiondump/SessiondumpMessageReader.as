package tibia.sessiondump
{
   import tibia.network.IMessageReader;
   import flash.utils.ByteArray;
   
   public class SessiondumpMessageReader implements IMessageReader
   {
      
      protected static const MESSAGELENGTH_SIZE:int = 2;
      
      protected static const MESSAGE_TYPE_CLIENT_MESSAGE:uint = 99;
      
      protected static const MESSAGE_TYPE_SERVER_MESSAGE:uint = 109;
      
      protected static const MESSAGE_MAGIC_BYTE_SIZE:uint = 1;
       
      
      private var m_MessageBeginIndex:uint = 0;
      
      private var m_MessageEof:uint = 0;
      
      private var m_MessageType:uint = 0;
      
      private var m_InputBuffer:ByteArray = null;
      
      public function SessiondumpMessageReader(param1:ByteArray)
      {
         super();
         this.m_InputBuffer = param1;
      }
      
      public function get messageType() : uint
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         if(this.m_MessageType == 0)
         {
            _loc1_ = this.m_InputBuffer.readUnsignedByte();
            if(_loc1_ != MESSAGE_TYPE_SERVER_MESSAGE && _loc1_ != MESSAGE_TYPE_CLIENT_MESSAGE)
            {
               throw new Error("SessiondumpMessageReader.messageType: Invalid magic byte: " + _loc1_);
            }
            _loc2_ = this.m_InputBuffer.readUnsignedShort();
            this.m_MessageEof = this.m_InputBuffer.position + _loc2_;
            this.m_MessageType = this.m_InputBuffer.readUnsignedByte();
            this.m_MessageBeginIndex = this.m_InputBuffer.position;
         }
         return this.m_MessageType;
      }
      
      public function dispose() : void
      {
         this.m_InputBuffer = null;
      }
      
      public function get inputBuffer() : ByteArray
      {
         return this.m_InputBuffer;
      }
      
      public function finishMessage() : void
      {
         this.m_MessageType = 0;
         this.m_MessageBeginIndex = 0;
         this.m_InputBuffer.position = this.m_MessageEof;
      }
      
      public function get messageWasRead() : Boolean
      {
         return this.m_MessageType == 0 && this.m_InputBuffer.position != this.m_MessageBeginIndex;
      }
   }
}
