package tibia.sessiondump
{
   import flash.events.EventDispatcher;
   import flash.utils.ByteArray;
   
   public class SessiondumpReader extends EventDispatcher
   {
      
      private static const HEADER_MAGIC_BYTES_SIZE:uint = 3;
      
      private static const HEADER_HEADER_LENGTH_SIZE:uint = 2;
       
      
      private var m_HeaderLength:uint = 0;
      
      private var m_MessageReader:tibia.sessiondump.SessiondumpMessageReader = null;
      
      private var m_HeaderRead:Boolean = false;
      
      private var m_InputBuffer:ByteArray = null;
      
      private var m_PacketReader:tibia.sessiondump.SessiondumpPacketReader = null;
      
      public function SessiondumpReader(param1:ByteArray)
      {
         super();
         this.m_InputBuffer = param1;
      }
      
      public function get isPacketReady() : Boolean
      {
         if(this.m_HeaderRead == false)
         {
            this.readSessiondumpHeader();
         }
         return this.m_HeaderRead && this.m_PacketReader != null && this.m_PacketReader.isPacketReady;
      }
      
      private function readSessiondumpHeader() : void
      {
         var _loc1_:Vector.<uint> = null;
         var _loc2_:uint = 0;
         var _loc3_:SessiondumpEvent = null;
         if(this.m_InputBuffer == null)
         {
            return;
         }
         if(this.m_HeaderRead == false)
         {
            if(this.m_HeaderLength == 0)
            {
               if(this.m_InputBuffer.bytesAvailable >= HEADER_MAGIC_BYTES_SIZE + HEADER_HEADER_LENGTH_SIZE)
               {
                  _loc1_ = new Vector.<uint>();
                  _loc2_ = 0;
                  while(_loc2_ < 3)
                  {
                     _loc1_.push(this.m_InputBuffer.readUnsignedByte());
                     _loc2_++;
                  }
                  if(_loc1_[0] != 100 || _loc1_[1] != 109 || _loc1_[2] != 112)
                  {
                     throw new Error("SessiondumpReader.readSessiondumpHeader: Invalid magic bytes");
                  }
                  this.m_HeaderLength = this.m_InputBuffer.readUnsignedShort();
               }
            }
            if(this.m_HeaderLength > 0 && this.m_InputBuffer.bytesAvailable >= this.m_HeaderLength)
            {
               this.m_InputBuffer.position = this.m_InputBuffer.position + this.m_HeaderLength;
               this.m_PacketReader = new tibia.sessiondump.SessiondumpPacketReader(this.m_InputBuffer);
               this.m_MessageReader = new tibia.sessiondump.SessiondumpMessageReader(this.m_InputBuffer);
               this.m_HeaderRead = true;
               _loc3_ = new SessiondumpEvent(SessiondumpEvent.HEADER_READ);
               dispatchEvent(_loc3_);
            }
         }
      }
      
      public function get messageReader() : tibia.sessiondump.SessiondumpMessageReader
      {
         return this.m_MessageReader;
      }
      
      public function get headerRead() : Boolean
      {
         return this.m_HeaderRead;
      }
      
      public function get packetReader() : tibia.sessiondump.SessiondumpPacketReader
      {
         return this.m_PacketReader;
      }
      
      public function get inputBuffer() : ByteArray
      {
         return this.m_InputBuffer;
      }
      
      public function dispose() : void
      {
         this.m_InputBuffer = null;
      }
   }
}
