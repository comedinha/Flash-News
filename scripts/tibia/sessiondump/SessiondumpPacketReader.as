package tibia.sessiondump
{
   import flash.utils.ByteArray;
   
   public class SessiondumpPacketReader
   {
      
      public static const PACKET_TYPE_CLIENT_MESSAGE:uint = 2;
      
      protected static const PACKET_TIMESTAMP_SIZE:uint = 4;
      
      protected static const PACKETLENGTH_SIZE:int = 2;
      
      protected static const PACKET_MAGIC_BYTE_SIZE:uint = 1;
      
      protected static const PACKET_TYPE_SIZE:uint = 1;
      
      protected static const PACKET_MAGIC_BYTE:uint = 112;
      
      public static const PACKET_TYPE_SERVER_MESSAGE:uint = 1;
       
      
      private var m_PacketLength:uint = 0;
      
      private var m_PacketReady:Boolean = false;
      
      private var m_CurrentPacketID:uint = 0;
      
      private var m_PayloadOffset:uint = 0;
      
      private var m_PacketType:uint = 0;
      
      private var m_HeaderComplete:Boolean = false;
      
      private var m_PacketEof:uint = 0;
      
      private var m_SkipClientPackets:Boolean = true;
      
      private var m_InputBuffer:ByteArray = null;
      
      private var m_PacketTimestamp:uint = 0;
      
      public function SessiondumpPacketReader(param1:ByteArray)
      {
         super();
         this.m_InputBuffer = param1;
      }
      
      public function set skipClientPackets(param1:Boolean) : void
      {
         this.m_SkipClientPackets = param1;
      }
      
      public function get currentPacketID() : uint
      {
         return this.m_CurrentPacketID;
      }
      
      public function dispose() : void
      {
         this.m_InputBuffer = null;
      }
      
      public function get skipClientPackets() : Boolean
      {
         return this.m_SkipClientPackets;
      }
      
      private function bytesAvailable(param1:uint) : Boolean
      {
         return this.m_InputBuffer.bytesAvailable >= param1;
      }
      
      public function get packetTimestamp() : uint
      {
         return this.m_PacketTimestamp;
      }
      
      public function get isPacketReady() : Boolean
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         if(this.m_PacketReady == true)
         {
            return this.m_PacketReady;
         }
         while(true)
         {
            _loc1_ = false;
            if(this.m_PacketLength == 0)
            {
               if(this.bytesAvailable(PACKET_MAGIC_BYTE_SIZE + PACKETLENGTH_SIZE + PACKET_TYPE_SIZE + PACKET_TIMESTAMP_SIZE))
               {
                  _loc2_ = this.m_InputBuffer.readUnsignedByte();
                  if(_loc2_ != PACKET_MAGIC_BYTE)
                  {
                     break;
                  }
                  this.m_PacketLength = this.m_InputBuffer.readUnsignedShort();
                  this.m_PacketEof = this.m_InputBuffer.position + this.m_PacketLength;
                  this.m_PacketType = this.m_InputBuffer.readUnsignedByte();
                  if(this.m_PacketType != PACKET_TYPE_SERVER_MESSAGE && this.m_PacketType != PACKET_TYPE_CLIENT_MESSAGE)
                  {
                     throw new Error("SessiondumpPacketReader.isPacketReady: invalid packet type: " + this.m_PacketType);
                  }
                  this.m_PacketTimestamp = this.m_InputBuffer.readUnsignedInt();
                  this.m_HeaderComplete = true;
                  if(this.m_SkipClientPackets && this.m_PacketType == PACKET_TYPE_CLIENT_MESSAGE)
                  {
                     this.m_InputBuffer.position = this.m_PacketEof;
                     this.finishPacket();
                     _loc1_ = true;
                  }
               }
            }
            if(this.m_HeaderComplete && this.bytesAvailable(this.m_PacketLength - 5))
            {
               this.m_PacketReady = true;
               return true;
            }
            if(_loc1_ != true)
            {
               return false;
            }
         }
         throw new Error("SessiondumpPacketReader.isPacketReady: Invalid magic byte");
      }
      
      public function get containsUnreadMessage() : Boolean
      {
         return this.m_InputBuffer.position < Math.min(this.m_InputBuffer.length,this.m_PacketEof);
      }
      
      public function finishPacket() : void
      {
         this.m_HeaderComplete = false;
         this.m_PacketLength = 0;
         this.m_PacketReady = false;
         this.m_PayloadOffset = 0;
         this.m_PacketEof = 0;
         this.m_PacketType == PACKET_TYPE_SERVER_MESSAGE;
         this.m_CurrentPacketID++;
      }
      
      public function get isClientPacket() : Boolean
      {
         return this.m_PacketType == PACKET_TYPE_CLIENT_MESSAGE;
      }
   }
}
