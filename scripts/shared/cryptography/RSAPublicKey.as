package shared.cryptography
{
   import flash.utils.ByteArray;
   
   public class RSAPublicKey
   {
      
      private static const PUBLIC_MODULUS:String = "1321277432058722840622950990822933849527763264961655079678763618" + "4334395343554449668205332383339435179772895415509701210392836078" + "6959821132214473291575712138800495033169914814069637740318278150" + "2907336840325241747827401343576296990629870233111328210165697754" + "88792221429527047321331896351555606801473202394175817";
      
      private static const PUBLIC_EXPONENT:uint = 65537;
      
      public static const BLOCKSIZE:uint = 128;
       
      
      private var m_Exponent:BigInt;
      
      private var m_Modulus:BigInt;
      
      private var m_PRNG:Random;
      
      public function RSAPublicKey()
      {
         this.m_Exponent = new BigInt(PUBLIC_EXPONENT);
         this.m_Modulus = BigInt.s_FromString(PUBLIC_MODULUS,10);
         this.m_PRNG = new Random();
         super();
      }
      
      public function encrypt(param1:ByteArray, param2:uint = 0, param3:uint = 2147483647) : uint
      {
         var _loc6_:BigInt = null;
         var _loc7_:BigInt = null;
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
            _loc6_ = BigInt.s_FromByteArray(param1,_loc5_,BLOCKSIZE);
            _loc7_ = BigInt.s_ImplModExp(_loc6_,this.m_Exponent,this.m_Modulus);
            _loc7_.toByteArray(param1,_loc5_,BLOCKSIZE);
            _loc5_ = _loc5_ + BLOCKSIZE;
         }
         return param3;
      }
   }
}
