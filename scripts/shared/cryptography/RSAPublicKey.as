package shared.cryptography
{
   import flash.utils.ByteArray;
   
   public class RSAPublicKey
   {
      
      private static const PUBLIC_MODULUS:String = "1091201329673994292788609605089955415282375029027981291234687579" + "3726629149257644633073969600111060390723088861007265581882535850" + "34290575928276294364131085660290936282126359538366865626758497206" + "20786279431090218017681061521755056710823876476444260558147179707" + "119674283982419152118103759076030616683978566631413";
      
      private static const PUBLIC_EXPONENT:uint = 65537;
      
      public static const BLOCKSIZE:uint = 128;
       
      
      private var m_Exponent:shared.cryptography.BigInt;
      
      private var m_Modulus:shared.cryptography.BigInt;
      
      private var m_PRNG:shared.cryptography.Random;
      
      public function RSAPublicKey()
      {
         this.m_Exponent = new shared.cryptography.BigInt(PUBLIC_EXPONENT);
         this.m_Modulus = shared.cryptography.BigInt.s_FromString(PUBLIC_MODULUS,10);
         this.m_PRNG = new shared.cryptography.Random();
         super();
      }
      
      public function encrypt(param1:ByteArray, param2:uint = 0, param3:uint = 2147483647) : uint
      {
         var _loc6_:shared.cryptography.BigInt = null;
         var _loc7_:shared.cryptography.BigInt = null;
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
            _loc6_ = shared.cryptography.BigInt.s_FromByteArray(param1,_loc5_,BLOCKSIZE);
            _loc7_ = shared.cryptography.BigInt.s_ImplModExp(_loc6_,this.m_Exponent,this.m_Modulus);
            _loc7_.toByteArray(param1,_loc5_,BLOCKSIZE);
            _loc5_ = _loc5_ + BLOCKSIZE;
         }
         return param3;
      }
   }
}
