package shared.cryptography
{
   import flash.utils.ByteArray;
   
   public class XTEA
   {
      
      private static const ROUNDS:uint = 32;
      
      private static const DELTA:uint = 2654435769;
      
      public static const BLOCKSIZE:uint = 8;
       
      
      private var m_Key:Array = null;
      
      private var m_PRNG:Random = null;
      
      public function XTEA()
      {
         super();
         this.m_PRNG = new Random();
         this.generateKey();
      }
      
      public function writeKey(param1:ByteArray) : void
      {
         param1.writeUnsignedInt(this.m_Key[0]);
         param1.writeUnsignedInt(this.m_Key[1]);
         param1.writeUnsignedInt(this.m_Key[2]);
         param1.writeUnsignedInt(this.m_Key[3]);
      }
      
      public function encrypt(param1:ByteArray, param2:uint = 0, param3:uint = 2147483647) : uint
      {
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         var _loc9_:int = 0;
         param3 = Math.min(param3,param1.length - param2);
         param1.position = param2 + param3;
         var _loc4_:uint = Math.floor((param3 + BLOCKSIZE - 1) / BLOCKSIZE) * BLOCKSIZE;
         if(_loc4_ > param3)
         {
            this.m_PRNG.getBytes(param1,_loc4_ - param3);
            param3 = _loc4_;
         }
         var _loc5_:int = param2;
         while(_loc5_ < param2 + param3)
         {
            param1.position = _loc5_;
            _loc6_ = param1.readUnsignedInt();
            _loc7_ = param1.readUnsignedInt();
            _loc8_ = 0;
            _loc9_ = ROUNDS;
            while(_loc9_ > 0)
            {
               _loc6_ = _loc6_ + ((_loc7_ << 4 ^ _loc7_ >>> 5) + _loc7_ ^ _loc8_ + this.m_Key[_loc8_ & 3]);
               _loc8_ = _loc8_ + DELTA;
               _loc7_ = _loc7_ + ((_loc6_ << 4 ^ _loc6_ >>> 5) + _loc6_ ^ _loc8_ + this.m_Key[_loc8_ >>> 11 & 3]);
               _loc9_--;
            }
            param1.position = param1.position - BLOCKSIZE;
            param1.writeUnsignedInt(_loc6_);
            param1.writeUnsignedInt(_loc7_);
            _loc5_ = _loc5_ + BLOCKSIZE;
         }
         return param3;
      }
      
      public function generateKey() : void
      {
         this.m_Key = [this.m_PRNG.getUnsignedInt(),this.m_PRNG.getUnsignedInt(),this.m_PRNG.getUnsignedInt(),this.m_PRNG.getUnsignedInt()];
      }
      
      public function decrypt(param1:ByteArray, param2:uint = 0, param3:uint = 2147483647) : uint
      {
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc8_:int = 0;
         param3 = Math.min(param3,param1.length - param2);
         param3 = param3 - param3 % BLOCKSIZE;
         var _loc4_:int = param2;
         while(_loc4_ < param2 + param3)
         {
            param1.position = _loc4_;
            _loc5_ = param1.readUnsignedInt();
            _loc6_ = param1.readUnsignedInt();
            _loc7_ = DELTA * ROUNDS;
            _loc8_ = ROUNDS;
            while(_loc8_ > 0)
            {
               _loc6_ = _loc6_ - ((_loc5_ << 4 ^ _loc5_ >>> 5) + _loc5_ ^ _loc7_ + this.m_Key[_loc7_ >>> 11 & 3]);
               _loc7_ = _loc7_ - DELTA;
               _loc5_ = _loc5_ - ((_loc6_ << 4 ^ _loc6_ >>> 5) + _loc6_ ^ _loc7_ + this.m_Key[_loc7_ & 3]);
               _loc8_--;
            }
            param1.position = param1.position - BLOCKSIZE;
            param1.writeUnsignedInt(_loc5_);
            param1.writeUnsignedInt(_loc6_);
            _loc4_ = _loc4_ + BLOCKSIZE;
         }
         return param3;
      }
   }
}
