package shared.cryptography
{
   import flash.crypto.generateRandomBytes;
   import flash.utils.ByteArray;
   import flash.utils.getTimer;
   
   public class Random
   {
      
      private static var s_PoolWritePosition:uint = 0;
      
      private static const POOL_SIZE:int = 1024;
      
      private static var s_PoolReadPosition:uint = 0;
      
      private static var s_PoolData:Vector.<uint> = new Vector.<uint>(POOL_SIZE,true);
      
      private static const STATE_SIZE:int = 256;
      
      {
         s_PoolInitialize();
      }
      
      private var m_StateA:uint = 0;
      
      private var m_StateB:uint = 0;
      
      private var m_StateC:uint = 0;
      
      private var m_StateM:Vector.<uint>;
      
      private var m_Output:Vector.<uint>;
      
      private var m_OutputPosition:uint = 256;
      
      public function Random()
      {
         this.m_Output = new Vector.<uint>(STATE_SIZE,true);
         this.m_StateM = new Vector.<uint>(STATE_SIZE,true);
         super();
         this.randomInit();
      }
      
      private static function s_PoolGetUnsignedInt() : uint
      {
         return s_PoolData[s_PoolReadPosition++ % POOL_SIZE];
      }
      
      private static function s_Mix(param1:Vector.<uint>) : void
      {
         param1[0] = param1[0] ^ param1[1] << 11;
         param1[3] = param1[3] + param1[0];
         param1[1] = param1[1] + param1[2];
         param1[1] = param1[1] ^ param1[2] >>> 2;
         param1[4] = param1[4] + param1[1];
         param1[2] = param1[2] + param1[3];
         param1[2] = param1[2] ^ param1[3] << 8;
         param1[5] = param1[5] + param1[2];
         param1[3] = param1[3] + param1[4];
         param1[3] = param1[3] ^ param1[4] >>> 16;
         param1[6] = param1[6] + param1[3];
         param1[4] = param1[4] + param1[5];
         param1[4] = param1[4] ^ param1[5] << 10;
         param1[7] = param1[7] + param1[4];
         param1[5] = param1[5] + param1[6];
         param1[5] = param1[5] ^ param1[6] >>> 4;
         param1[0] = param1[0] + param1[5];
         param1[6] = param1[6] + param1[7];
         param1[6] = param1[6] ^ param1[7] << 8;
         param1[1] = param1[1] + param1[6];
         param1[7] = param1[7] + param1[0];
         param1[7] = param1[7] ^ param1[0] >>> 9;
         param1[2] = param1[2] + param1[7];
         param1[0] = param1[0] + param1[1];
      }
      
      public static function s_PoolPutUnsignedInt(param1:uint) : void
      {
         s_PoolData[s_PoolWritePosition++ % POOL_SIZE] = param1;
      }
      
      private static function s_PoolInitialize() : void
      {
         var i:int = 0;
         var Buffer:ByteArray = null;
         i = 0;
         var _loc2_:* = i++;
         s_PoolData[_loc2_] = new Date().time;
         var _loc3_:* = i++;
         s_PoolData[_loc3_] = getTimer();
         try
         {
            while(i < POOL_SIZE)
            {
               Buffer = generateRandomBytes(1024);
               while(i < POOL_SIZE && Buffer.bytesAvailable >= 4)
               {
                  s_PoolData[i++] = Buffer.readUnsignedInt();
               }
            }
            return;
         }
         catch(e:*)
         {
            while(i < POOL_SIZE)
            {
               s_PoolData[i++] = uint(Math.random());
            }
            return;
         }
      }
      
      private function randomInit() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Vector.<uint> = new Vector.<uint>(8,true);
         _loc1_ = 0;
         while(_loc1_ < 8)
         {
            _loc3_[_loc1_] = 2654435769;
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < 4)
         {
            s_Mix(_loc3_);
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < STATE_SIZE)
         {
            _loc2_ = 0;
            while(_loc2_ < 8)
            {
               _loc3_[_loc2_] = _loc3_[_loc2_] + s_PoolGetUnsignedInt();
               _loc2_++;
            }
            s_Mix(_loc3_);
            _loc2_ = 0;
            while(_loc2_ < 8)
            {
               this.m_StateM[_loc1_ + _loc2_] = _loc3_[_loc2_];
               _loc2_++;
            }
            _loc1_ = _loc1_ + 8;
         }
         _loc1_ = 0;
         while(_loc1_ < STATE_SIZE)
         {
            _loc2_ = 0;
            while(_loc2_ < 8)
            {
               _loc3_[_loc2_] = _loc3_[_loc2_] + this.m_StateM[_loc1_ + _loc2_];
               _loc2_++;
            }
            s_Mix(_loc3_);
            _loc2_ = 0;
            while(_loc2_ < 8)
            {
               this.m_StateM[_loc1_ + _loc2_] = _loc3_[_loc2_];
               _loc2_++;
            }
            _loc1_ = _loc1_ + 8;
         }
         this.randomUpdate();
      }
      
      private function randomUpdate() : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         this.m_StateC = this.m_StateC + 1;
         this.m_StateB = this.m_StateB + this.m_StateC;
         var _loc1_:int = 0;
         while(_loc1_ < STATE_SIZE)
         {
            switch(_loc1_ % 4)
            {
               case 0:
                  this.m_StateA = this.m_StateA ^ this.m_StateA << 13;
                  break;
               case 1:
                  this.m_StateA = this.m_StateA ^ this.m_StateA >>> 6;
                  break;
               case 2:
                  this.m_StateA = this.m_StateA ^ this.m_StateA << 2;
                  break;
               case 3:
                  this.m_StateA = this.m_StateA ^ this.m_StateA >>> 16;
            }
            _loc2_ = this.m_StateM[_loc1_];
            this.m_StateA = this.m_StateM[(_loc1_ + 128) % STATE_SIZE] + this.m_StateA;
            this.m_StateM[_loc1_] = this.m_StateM[(_loc2_ >>> 2) % STATE_SIZE] + this.m_StateA + this.m_StateB;
            _loc3_ = this.m_StateM[_loc1_];
            this.m_Output[_loc1_] = this.m_StateM[(_loc3_ >>> 10) % STATE_SIZE] + _loc2_;
            this.m_StateB = this.m_Output[_loc1_];
            _loc1_++;
         }
         this.m_OutputPosition = 0;
      }
      
      public function getUnsignedInt() : uint
      {
         if(this.m_OutputPosition >= STATE_SIZE)
         {
            this.randomUpdate();
         }
         return this.m_Output[this.m_OutputPosition++];
      }
      
      public function getBytes(param1:ByteArray, param2:uint) : void
      {
         var _loc6_:uint = 0;
         var _loc3_:uint = param2 >>> 2;
         var _loc4_:uint = param2 % 4;
         var _loc5_:uint = _loc3_;
         while(_loc5_ > 0)
         {
            if(this.m_OutputPosition >= STATE_SIZE)
            {
               this.randomUpdate();
            }
            param1.writeUnsignedInt(this.m_Output[this.m_OutputPosition++]);
            _loc5_--;
         }
         if(_loc4_ > 0)
         {
            if(this.m_OutputPosition >= STATE_SIZE)
            {
               this.randomUpdate();
            }
            _loc6_ = this.m_Output[this.m_OutputPosition++];
            switch(_loc4_)
            {
               case 3:
                  param1.writeByte(_loc6_ & 65535);
                  _loc6_ = _loc6_ >>> 8;
               case 2:
                  param1.writeByte(_loc6_ & 65535);
                  _loc6_ = _loc6_ >>> 8;
               case 1:
                  param1.writeByte(_loc6_ & 65535);
               default:
                  param1.writeByte(_loc6_ & 65535);
            }
         }
      }
   }
}
