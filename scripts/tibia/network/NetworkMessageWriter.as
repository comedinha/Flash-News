package tibia.network
{
   import flash.utils.ByteArray;
   import shared.cryptography.XTEA;
   import shared.cryptography.calculateAdler32Checksum;
   import flash.utils.Endian;
   
   public class NetworkMessageWriter implements IMessageWriter
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
       
      
      private var m_MessageFinishedCallback:Function = null;
      
      private var m_XTEA:XTEA = null;
      
      private var m_MessageBuffer:ByteArray = null;
      
      private var m_OutputBuffer:ByteArray = null;
      
      public function NetworkMessageWriter()
      {
         super();
         this.m_OutputBuffer = new ByteArray();
         this.m_MessageBuffer = new ByteArray();
         this.m_OutputBuffer.endian = Endian.LITTLE_ENDIAN;
         this.m_MessageBuffer.endian = Endian.LITTLE_ENDIAN;
      }
      
      public function registerMessageFinishedCallback(param1:Function) : void
      {
         this.m_MessageFinishedCallback = param1;
      }
      
      public function get outputPacketBuffer() : ByteArray
      {
         return this.m_OutputBuffer;
      }
      
      public function createMessage() : ByteArray
      {
         this.m_MessageBuffer.length = 0;
         this.m_MessageBuffer.position = 0;
         this.m_OutputBuffer.length = 0;
         this.m_OutputBuffer.position = 0;
         return this.m_MessageBuffer;
      }
      
      public function set xtea(param1:XTEA) : void
      {
         this.m_XTEA = param1;
      }
      
      public function finishMessage() : void
      {
         var _loc1_:uint = this.m_MessageBuffer.position;
         this.m_OutputBuffer.length = 0;
         this.m_OutputBuffer.position = 0;
         var _loc2_:uint = CHECKSUM_POS + CHECKSUM_SIZE;
         this.m_OutputBuffer.position = _loc2_;
         var _loc3_:uint = this.m_MessageBuffer.position;
         if(this.m_XTEA != null)
         {
            this.m_OutputBuffer.writeShort(_loc3_);
         }
         this.m_OutputBuffer.writeBytes(this.m_MessageBuffer,0,_loc3_);
         if(this.m_XTEA != null)
         {
            this.m_XTEA.encrypt(this.m_OutputBuffer,_loc2_,this.m_OutputBuffer.length - _loc2_);
         }
         var _loc4_:uint = calculateAdler32Checksum(this.m_OutputBuffer,_loc2_,this.m_OutputBuffer.length - _loc2_);
         this.m_OutputBuffer.position = CHECKSUM_POS;
         this.m_OutputBuffer.writeUnsignedInt(_loc4_);
         this.m_OutputBuffer.position = PACKETLENGTH_POS;
         this.m_OutputBuffer.writeShort(this.m_OutputBuffer.length - PACKETLENGTH_SIZE);
         this.m_OutputBuffer.position = 0;
         if(this.m_MessageFinishedCallback != null)
         {
            this.m_MessageFinishedCallback();
         }
      }
      
      public function get xtea() : XTEA
      {
         return this.m_XTEA;
      }
   }
}
