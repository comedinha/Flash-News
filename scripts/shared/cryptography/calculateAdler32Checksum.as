package shared.cryptography
{
   import flash.utils.ByteArray;
   
   public function calculateAdler32Checksum(param1:ByteArray, param2:int = 0, param3:int = 0) : uint
   {
      var _loc4_:int = 65521;
      if(param1 == null)
      {
         throw new Error("calculateAdler32Checksum: Invalid input.",2147483647);
      }
      if(param2 >= param1.length)
      {
         throw new Error("calculateAdler32Checksum: Invalid offset.",2147483646);
      }
      var _loc5_:uint = 1;
      var _loc6_:uint = 0;
      var _loc7_:int = 0;
      var _loc8_:int = 0;
      param1.position = param2;
      while(param1.bytesAvailable > 0 && (param3 == 0 || _loc8_ < param3))
      {
         _loc7_ = param1.readUnsignedByte();
         _loc5_ = (_loc5_ + _loc7_) % _loc4_;
         _loc6_ = (_loc6_ + _loc5_) % _loc4_;
         _loc8_++;
      }
      _loc5_ = _loc5_ & 65535;
      _loc6_ = _loc6_ & 65535;
      return _loc6_ << 16 | _loc5_;
   }
}
