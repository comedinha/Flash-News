package tibia.network
{
   import shared.cryptography.XTEA;
   import shared.cryptography.calculateAdler32Checksum;
   import flash.utils.ByteArray;
   
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
      
      public static const PROTOCOL_VERSION:int = 1100;
      
      protected static const PAYLOADLENGTH_SIZE:int = 2;
      
      protected static const PAYLOADLENGTH_POS:int = PAYLOAD_POS;
      
      protected static const ERR_INVALID_SIZE:int = 1;
      
      protected static const ERR_INVALID_CHECKSUM:int = 2;
      
      protected static const ERR_COULD_NOT_CONNECT:int = 5;
      
      protected static const PACKETLENGTH_POS:int = HEADER_POS;
      
      protected static const ERR_CONNECTION_LOST:int = 6;
      
      protected static const PACKETLENGTH_SIZE:int = 2;
      
      protected static const HEADER_SIZE:int = PACKETLENGTH_SIZE + CHECKSUM_SIZE;
      
      protected static const ERR_INTERNAL:int = 0;
      
      protected static const CHECKSUM_POS:int = PACKETLENGTH_POS + PACKETLENGTH_SIZE;
      
      protected static const PAYLOAD_POS:int = HEADER_POS + HEADER_SIZE;
      
      protected static const CHECKSUM_SIZE:int = 4;
      
      protected static const PAYLOADDATA_POSITION:int = PAYLOADLENGTH_POS + PAYLOADLENGTH_SIZE;
       
      
      private var m_PacketLength:uint = 0;
      
      private var m_PacketBeginOffset:uint = 0;
      
      private var m_PacketReady:Boolean = false;
      
      private var m_PayloadEof:uint = 0;
      
      private var m_PayloadOffset:uint = 0;
      
      private var m_Blocksize:uint = 0;
      
      private var m_HeaderComplete:Boolean = false;
      
      private var m_PacketEof:uint = 0;
      
      private var m_PayloadLength:uint = 0;
      
      private var m_XTEA:XTEA = null;
      
      private var m_MessagesOffset:uint = 0;
      
      private var m_Checksum:uint = 0;
      
      private var m_InputBuffer:ByteArray = null;
      
      public function NetworkPacketReader(param1:ByteArray, param2:uint = 1)
      {
         super();
         this.m_InputBuffer = param1;
         this.m_Blocksize = param2;
      }
      
      public function get isPacketReady() : Boolean
      {
         if(this.m_PacketReady == true)
         {
            return this.m_PacketReady;
         }
         if(this.m_PacketLength == 0)
         {
            if(this.bytesAvailable(PACKETLENGTH_SIZE + CHECKSUM_SIZE))
            {
               this.m_PacketBeginOffset = this.m_InputBuffer.position;
               this.m_PacketLength = this.m_InputBuffer.readUnsignedShort();
               this.m_PacketEof = this.m_InputBuffer.position + this.m_PacketLength;
               this.m_Checksum = this.m_InputBuffer.readUnsignedInt();
               this.m_PayloadOffset = this.m_InputBuffer.position;
            }
         }
         if(this.m_PacketLength != 0 && this.m_Checksum != 0 && this.bytesAvailable(this.m_PacketLength - CHECKSUM_SIZE))
         {
            this.m_PacketReady = true;
            return true;
         }
         return false;
      }
      
      public function set xtea(param1:XTEA) : void
      {
         this.m_XTEA = param1;
      }
      
      public function get containsUnreadMessage() : Boolean
      {
         return this.m_InputBuffer.position < Math.min(this.m_InputBuffer.length,this.m_PayloadEof);
      }
      
      public function get isValidPacket() : Boolean
      {
         var _loc1_:Boolean = true;
         if(this.isPacketReady == false)
         {
            throw new Error("Packet can only be validated if it is complete");
         }
         var _loc2_:uint = this.m_InputBuffer.position;
         var _loc3_:uint = calculateAdler32Checksum(this.m_InputBuffer,this.m_PayloadOffset,this.m_PacketLength - CHECKSUM_SIZE);
         this.m_InputBuffer.position = _loc2_;
         _loc1_ = _loc1_ && _loc3_ == this.m_Checksum;
         if((this.m_PacketLength - CHECKSUM_SIZE) % this.m_Blocksize != 0)
         {
            _loc1_ = false;
         }
         return _loc1_;
      }
      
      private function bytesAvailable(param1:uint) : Boolean
      {
         return this.m_InputBuffer.bytesAvailable >= param1;
      }
      
      public function dispose() : void
      {
         this.m_InputBuffer = null;
         this.m_XTEA = null;
      }
      
      public function get xtea() : XTEA
      {
         return this.m_XTEA;
      }
      
      public function preparePacket() : void
      {
         if(this.isPacketReady)
         {
            if(this.m_XTEA != null)
            {
               this.m_XTEA.decrypt(this.m_InputBuffer,this.m_PayloadOffset,this.m_PacketLength - CHECKSUM_SIZE);
            }
            this.m_InputBuffer.position = this.m_PayloadOffset;
         }
         this.m_PayloadLength = this.m_InputBuffer.readUnsignedShort();
         this.m_PayloadEof = this.m_InputBuffer.position + this.m_PayloadLength;
         this.m_MessagesOffset = this.m_InputBuffer.position;
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
         this.m_Checksum = 0;
         this.m_PacketReady = false;
         this.m_PayloadOffset = 0;
         this.m_PacketBeginOffset = 0;
         this.m_PacketEof = 0;
         this.m_PayloadLength = 0;
         this.m_MessagesOffset = 0;
         this.m_PayloadEof = 0;
      }
   }
}
