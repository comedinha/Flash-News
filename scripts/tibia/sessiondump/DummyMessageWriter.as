package tibia.sessiondump
{
   import flash.utils.ByteArray;
   import tibia.network.IMessageWriter;
   
   public class DummyMessageWriter implements IMessageWriter
   {
      
      protected static const CONNECTION_STATE_GAME:int = 4;
      
      protected static const ERR_INVALID_MESSAGE:int = 3;
      
      protected static const CONNECTION_STATE_PENDING:int = 3;
      
      protected static const HEADER_POS:int = 0;
      
      protected static const CONNECTION_STATE_DISCONNECTED:int = 0;
      
      protected static const CONNECTION_STATE_CONNECTING_STAGE1:int = 1;
      
      protected static const CONNECTION_STATE_CONNECTING_STAGE2:int = 2;
      
      protected static const ERR_INVALID_STATE:int = 4;
      
      public static const PROTOCOL_VERSION:int = 1130;
      
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
       
      
      private var m_DummyBuffer:ByteArray = null;
      
      public function DummyMessageWriter()
      {
         super();
         this.m_DummyBuffer = new ByteArray();
      }
      
      public function finishMessage() : void
      {
         this.m_DummyBuffer.length = 0;
         this.m_DummyBuffer.position = 0;
      }
      
      public function get outputPacketBuffer() : ByteArray
      {
         return this.m_DummyBuffer;
      }
      
      public function createMessage() : ByteArray
      {
         this.m_DummyBuffer.length = 0;
         this.m_DummyBuffer.position = 0;
         return this.m_DummyBuffer;
      }
   }
}
