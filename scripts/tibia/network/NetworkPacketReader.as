package tibia.network
{
   import flash.utils.ByteArray;
   import shared.cryptography.XTEA;
   
   public class NetworkPacketReader
   {
      
      protected static const CONNECTION_STATE_GAME:int = 4;
      
      protected static const ERR_INVALID_MESSAGE:int = 3;
      
      protected static const CONNECTION_STATE_PENDING:int = 3;
      
      protected static const HEADER_POS:int = 0;
      
      protected static const CONNECTION_STATE_DISCONNECTED:int = 0;
      
      protected static const CONNECTION_STATE_CONNECTING_STAGE1:int = 1;
      
      protected static const CONNECTION_STATE_CONNECTING_STAGE2:int = 2;
      
      protected static const ERR_INVALID_STATE:int = 4;
      
      public static const PROTOCOL_VERSION:int = 1120;
      
      protected static const PAYLOADLENGTH_SIZE:int = 2;
      
      protected static const PAYLOADLENGTH_POS:int = PAYLOAD_POS;
      
      protected static const ERR_INVALID_SIZE:int = 1;
      
      protected static const ERR_INVALID_CHECKSUM:int = 2;
      
      protected static const ERR_COULD_NOT_CONNECT:int = 5;
      
      protected static const PACKETLENGTH_POS:int = HEADER_POS;
      
      protected static const ERR_CONNECTION_LOST:int = 6;
      
      protected static const PAYLOADDATA_POSITION:int = PAYLOADLENGTH_POS + PAYLOADLENGTH_SIZE;
      
      protected static const PACKETLENGTH_SIZE:int = 2;
      
      protected static const HEADER_SIZE:int = PACKETLENGTH_SIZE + SEQUENCE_NUMBER_SIZE;
      
      protected static const ERR_INTERNAL:int = 0;
      
      protected static const SEQUENCE_NUMBER_SIZE:int = 4;
      
      protected static const PAYLOAD_POS:int = HEADER_POS + HEADER_SIZE;
      
      protected static const SEQUENCE_NUMBER_POS:int = PACKETLENGTH_POS + PACKETLENGTH_SIZE;
       
      
      private var m_PacketLength:uint = 0;
      
      private var m_PacketReady:Boolean = false;
      
      private var m_PayloadEof:uint = 0;
      
      private var m_InputBuffer:ByteArray = null;
      
      private var m_PayloadOffset:uint = 0;
      
      private var m_Blocksize:uint = 0;
      
      private var m_PacketEof:uint = 0;
      
      private var m_HeaderComplete:Boolean = false;
      
      private var m_PayloadLength:uint = 0;
      
      private var m_XTEA:XTEA = null;
      
      private var m_IsCompressed:Boolean = false;
      
      public function NetworkPacketReader(param1:ByteArray, param2:uint = 1)
      {
         super();
         this.m_InputBuffer = param1;
         this.m_Blocksize = param2;
      }
      
      public function get xtea() : XTEA
      {
         return this.m_XTEA;
      }
      
      public function get isValidPacket() : Boolean
      {
         var _loc1_:Boolean = true;
         if(this.isPacketReady == false)
         {
            throw new Error("Packet can only be validated if it is complete");
         }
         if((this.m_PacketLength - SEQUENCE_NUMBER_SIZE) % this.m_Blocksize != 0)
         {
            _loc1_ = false;
         }
         return _loc1_;
      }
      
      public function dispose() : void
      {
         this.m_InputBuffer = null;
         this.m_XTEA = null;
      }
      
      private function bytesAvailable(param1:uint) : Boolean
      {
         return this.m_InputBuffer.bytesAvailable >= param1;
      }
      
      public function preparePacket() : void
      {
         var _loc1_:ByteArray = null;
         var _loc2_:ByteArray = null;
         var _loc3_:uint = 0;
         if(this.isPacketReady)
         {
            if(this.m_XTEA != null)
            {
               this.m_XTEA.decrypt(this.m_InputBuffer,this.m_PayloadOffset,this.m_PacketLength - SEQUENCE_NUMBER_SIZE);
            }
            this.m_InputBuffer.position = this.m_PayloadOffset;
         }
         this.m_PayloadLength = this.m_InputBuffer.readUnsignedShort();
         this.m_PayloadEof = this.m_InputBuffer.position + this.m_PayloadLength;
         if(this.m_IsCompressed)
         {
            _loc1_ = new ByteArray();
            _loc2_ = new ByteArray();
            _loc3_ = this.m_InputBuffer.position;
            this.m_InputBuffer.readBytes(_loc1_,0,this.m_PayloadLength);
            this.m_InputBuffer.position = this.m_PacketEof;
            this.m_InputBuffer.readBytes(_loc2_,0,0);
            _loc1_.inflate();
            this.m_InputBuffer.position = _loc3_;
            this.m_InputBuffer.writeBytes(_loc1_,0);
            this.m_InputBuffer.writeBytes(_loc2_,0);
            this.m_InputBuffer.length = this.m_InputBuffer.position;
            this.m_PayloadLength = _loc1_.length;
            this.m_PayloadEof = _loc3_ + this.m_PayloadLength;
            this.m_PacketEof = this.m_PayloadEof;
            this.m_InputBuffer.position = _loc3_;
         }
      }
      
      public function set xtea(param1:XTEA) : void
      {
         this.m_XTEA = param1;
      }
      
      public function get isPacketReady() : Boolean
      {
         var _loc1_:uint = 0;
         if(this.m_PacketReady == true)
         {
            return this.m_PacketReady;
         }
         if(this.m_PacketLength == 0)
         {
            if(this.bytesAvailable(PACKETLENGTH_SIZE + SEQUENCE_NUMBER_SIZE))
            {
               this.m_PacketLength = this.m_InputBuffer.readUnsignedShort();
               this.m_PacketEof = this.m_InputBuffer.position + this.m_PacketLength;
               _loc1_ = this.m_InputBuffer.readUnsignedInt();
               if((_loc1_ & 1 << 31) != 0)
               {
                  this.m_IsCompressed = true;
               }
               this.m_PayloadOffset = this.m_InputBuffer.position;
            }
         }
         if(this.m_PacketLength != 0 && this.bytesAvailable(this.m_PacketLength - SEQUENCE_NUMBER_SIZE))
         {
            this.m_PacketReady = true;
            return true;
         }
         return false;
      }
      
      public function get containsUnreadMessage() : Boolean
      {
         return this.m_InputBuffer.position < Math.min(this.m_InputBuffer.length,this.m_PayloadEof);
      }
      
      public function finishPacket() : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc1_:int = 0;
         if(this.m_InputBuffer.length > this.m_PacketEof)
         {
            _loc1_ = this.m_InputBuffer.length - this.m_PacketEof;
            _loc2_ = this.m_PacketEof;
            _loc3_ = 0;
            while(_loc3_ < _loc1_)
            {
               this.m_InputBuffer[_loc3_++] = this.m_InputBuffer[_loc2_++];
            }
         }
         this.m_InputBuffer.length = _loc1_;
         this.m_InputBuffer.position = 0;
         this.m_HeaderComplete = false;
         this.m_PacketLength = 0;
         this.m_IsCompressed = false;
         this.m_PacketReady = false;
         this.m_PayloadOffset = 0;
         this.m_PacketEof = 0;
         this.m_PayloadLength = 0;
         this.m_PayloadEof = 0;
      }
   }
}
