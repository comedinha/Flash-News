package shared.utility
{
   public function nextPowerOfTwo(param1:uint) : uint
   {
      param1--;
      param1 = param1 | param1 >> 1;
      param1 = param1 | param1 >> 2;
      param1 = param1 | param1 >> 4;
      param1 = param1 | param1 >> 8;
      param1 = param1 | param1 >> 16;
      param1++;
      return param1;
   }
}
