package shared.cryptography
{
   import flash.utils.ByteArray;
   
   public class BigInt
   {
       
      
      private var m_Digits:Vector.<uint>;
      
      private var m_Positive:Boolean = true;
      
      public function BigInt(param1:uint = 0)
      {
         this.m_Digits = new Vector.<uint>();
         super();
         this.m_Digits[0] = param1;
         this.m_Positive = true;
      }
      
      static function s_ImplSub(param1:BigInt, param2:BigInt, param3:Boolean) : void
      {
         var _loc4_:BigInt = null;
         var _loc5_:BigInt = null;
         var _loc6_:Boolean = false;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         var _loc9_:uint = 0;
         var _loc10_:uint = 0;
         var _loc11_:uint = 0;
         var _loc12_:uint = 0;
         var _loc13_:uint = 0;
         if(param3 || param1.m_Positive == param2.m_Positive)
         {
            _loc4_ = param1;
            _loc5_ = param2;
            _loc6_ = false;
            if(!param3 && param1.compareAbsolute(param2) < 0)
            {
               _loc4_ = param2.clone();
               _loc5_ = param1;
               _loc6_ = true;
            }
            _loc7_ = _loc4_.m_Digits.length;
            _loc8_ = _loc5_.m_Digits.length;
            _loc9_ = 0;
            _loc10_ = 0;
            _loc11_ = 0;
            while(_loc9_ > 0 || _loc11_ < _loc8_)
            {
               _loc12_ = _loc11_ < _loc7_?uint(_loc4_.m_Digits[_loc11_]):uint(0);
               _loc13_ = _loc11_ < _loc8_?uint(_loc5_.m_Digits[_loc11_]):uint(0);
               _loc10_ = _loc12_ - _loc9_;
               _loc9_ = 0;
               if(_loc10_ > _loc12_)
               {
                  _loc9_++;
               }
               if(_loc13_ > _loc10_)
               {
                  _loc9_++;
               }
               _loc4_.m_Digits[_loc11_++] = _loc10_ - _loc13_;
            }
            param1.assign(_loc4_);
            if(_loc6_)
            {
               param1.m_Positive = !param1.m_Positive;
            }
            param1.normalize();
         }
         else
         {
            s_ImplAdd(param1,param2,true);
         }
      }
      
      static function s_ImplDiv(param1:BigInt, param2:BigInt, param3:BigInt, param4:BigInt) : void
      {
         var _loc5_:BigInt = null;
         var _loc6_:BigInt = null;
         if(param2.isZero)
         {
            throw new Error("BigInt.s_ImplDiv: Dividsion by zero.");
         }
         _loc5_ = param2.clone();
         _loc6_ = param1.clone();
         var _loc7_:int = _loc6_.bitLength - _loc5_.bitLength;
         if(_loc7_ > 0)
         {
            _loc5_.shiftLeftFar(_loc7_,0);
         }
         var _loc8_:uint = 0;
         if(param3 != null)
         {
            param3.setZero();
            param3.m_Positive = param1.m_Positive && param2.m_Positive || !param1.m_Positive && !param2.m_Positive;
         }
         while(_loc7_ >= 0)
         {
            _loc8_ = 0;
            if(_loc5_.compareAbsolute(_loc6_) <= 0)
            {
               s_ImplSub(_loc6_,_loc5_,true);
               _loc8_ = 1;
            }
            if(param3 != null)
            {
               param3.shiftLeft(1,_loc8_);
            }
            _loc5_.shiftRight(1,0);
            _loc7_--;
         }
         if(param4 != null)
         {
            param4.assign(_loc6_);
         }
         if(param3 != null)
         {
            param3.normalize();
         }
      }
      
      static function s_ImplModExp(param1:BigInt, param2:BigInt, param3:BigInt) : BigInt
      {
         var _loc4_:BigInt = param1.clone();
         var _loc5_:BigInt = param1.clone();
         var _loc6_:uint = param2.bitLength - 1;
         while(_loc6_ > 0)
         {
            s_ImplMul(_loc4_,_loc4_);
            s_ImplDiv(_loc4_,param3,null,_loc4_);
            if(param2.testBit(_loc6_ - 1))
            {
               s_ImplMul(_loc5_,_loc4_);
               s_ImplDiv(_loc5_,param3,null,_loc5_);
            }
            _loc6_--;
         }
         return _loc5_;
      }
      
      static function s_ImplMul(param1:BigInt, param2:BigInt) : void
      {
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         var _loc9_:uint = 0;
         var _loc10_:uint = 0;
         var _loc11_:uint = 0;
         var _loc12_:uint = 0;
         var _loc13_:uint = 0;
         var _loc14_:uint = 0;
         var _loc15_:uint = 0;
         var _loc16_:uint = 0;
         var _loc3_:uint = param1.m_Digits.length;
         var _loc4_:uint = param2.m_Digits.length;
         var _loc5_:BigInt = new BigInt();
         _loc5_.reserve(param1.bitLength + param2.bitLength);
         var _loc6_:uint = 0;
         while(_loc6_ < _loc4_)
         {
            _loc7_ = param2.m_Digits[_loc6_] >>> 16;
            _loc8_ = param2.m_Digits[_loc6_] & 65535;
            if(!(_loc7_ == 0 && _loc8_ == 0))
            {
               _loc9_ = 0;
               _loc10_ = 0;
               _loc11_ = 0;
               _loc12_ = 0;
               _loc13_ = 0;
               _loc14_ = 0;
               while(_loc14_ < _loc3_)
               {
                  _loc15_ = param1.m_Digits[_loc14_] >>> 16;
                  _loc16_ = param1.m_Digits[_loc14_] & 65535;
                  _loc10_ = _loc7_ * _loc15_;
                  _loc11_ = _loc8_ * _loc16_;
                  if(_loc9_ > uint.MAX_VALUE - _loc11_)
                  {
                     _loc10_++;
                  }
                  _loc11_ = _loc11_ + _loc9_;
                  _loc12_ = _loc7_ * _loc16_;
                  _loc10_ = _loc10_ + (_loc12_ >>> 16);
                  _loc12_ = _loc12_ << 16;
                  if(_loc12_ > uint.MAX_VALUE - _loc11_)
                  {
                     _loc10_++;
                  }
                  _loc11_ = _loc11_ + _loc12_;
                  _loc13_ = _loc8_ * _loc15_;
                  _loc10_ = _loc10_ + (_loc13_ >>> 16);
                  _loc13_ = _loc13_ << 16;
                  if(_loc13_ > uint.MAX_VALUE - _loc11_)
                  {
                     _loc10_++;
                  }
                  _loc11_ = _loc11_ + _loc13_;
                  if(_loc5_.m_Digits[_loc6_ + _loc14_] > uint.MAX_VALUE - _loc11_)
                  {
                     _loc10_++;
                  }
                  _loc5_.m_Digits[_loc6_ + _loc14_] = _loc5_.m_Digits[_loc6_ + _loc14_] + _loc11_;
                  _loc9_ = _loc10_;
                  _loc14_++;
               }
               _loc5_.m_Digits[_loc6_ + _loc3_] = _loc9_;
            }
            _loc6_++;
         }
         param1.assign(_loc5_);
         param1.m_Positive = param1.m_Positive && param2.m_Positive || !param1.m_Positive && !param2.m_Positive;
      }
      
      public static function s_FromByteArray(param1:ByteArray, param2:int = -1, param3:int = 2147483647) : BigInt
      {
         var _loc4_:BigInt = new BigInt();
         if(param2 > -1)
         {
            param1.position = param2;
         }
         var _loc5_:uint = 0;
         while(param1.bytesAvailable > 0 && _loc5_++ < param3)
         {
            _loc4_.shiftLeft(8,param1.readUnsignedByte());
         }
         _loc4_.normalize();
         return _loc4_;
      }
      
      static function s_ImplAdd(param1:BigInt, param2:BigInt, param3:Boolean) : void
      {
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         var _loc9_:uint = 0;
         var _loc10_:uint = 0;
         var _loc11_:BigInt = null;
         if(param3 || param1.m_Positive == param2.m_Positive)
         {
            _loc4_ = param1.m_Digits.length;
            _loc5_ = param2.m_Digits.length;
            _loc6_ = 0;
            _loc7_ = 0;
            _loc8_ = 0;
            while(_loc6_ > 0 || _loc8_ < _loc5_)
            {
               _loc9_ = _loc8_ < _loc4_?uint(param1.m_Digits[_loc8_]):uint(0);
               _loc10_ = _loc8_ < _loc5_?uint(param2.m_Digits[_loc8_]):uint(0);
               _loc7_ = _loc9_ + _loc6_;
               _loc6_ = 0;
               if(_loc7_ < _loc9_)
               {
                  _loc6_++;
               }
               if(_loc10_ > uint.MAX_VALUE - _loc7_)
               {
                  _loc6_++;
               }
               param1.m_Digits[_loc8_++] = _loc7_ + _loc10_;
            }
         }
         else if(param1.compareAbsolute(param2) >= 0)
         {
            s_ImplSub(param1,param2,true);
         }
         else
         {
            _loc11_ = param2.clone();
            s_ImplSub(_loc11_,param1,true);
            param1.assign(_loc11_);
         }
      }
      
      public static function s_FromString(param1:String, param2:uint) : BigInt
      {
         var _loc5_:uint = 0;
         var _loc6_:BigInt = null;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         param1 = param1.toLowerCase();
         if(param2 != 2 && param2 != 10 && param2 != 16)
         {
            throw new Error("BigInt.s_FromString: Invalid base.");
         }
         var _loc3_:BigInt = new BigInt();
         var _loc4_:uint = 0;
         if(_loc4_ < param1.length)
         {
            if(param1.substr(_loc4_,1) == "-")
            {
               _loc3_.m_Positive = false;
               _loc4_++;
            }
         }
         if(param2 == 2)
         {
            while(_loc4_ < param1.length)
            {
               _loc5_ = parseInt(param1.substr(_loc4_,1),2);
               _loc3_.shiftLeft(1,_loc5_);
               _loc4_++;
            }
         }
         else if(param2 == 10)
         {
            _loc6_ = new BigInt(10);
            while(_loc4_ < param1.length)
            {
               _loc7_ = parseInt(param1.substr(_loc4_,1),10);
               s_ImplMul(_loc3_,_loc6_);
               s_ImplAdd(_loc3_,new BigInt(_loc7_),false);
               _loc4_++;
            }
         }
         else if(param2 == 16)
         {
            while(_loc4_ < param1.length)
            {
               _loc8_ = parseInt(param1.substr(_loc4_,1),16);
               _loc3_.shiftLeft(4,_loc8_);
               _loc4_++;
            }
         }
         _loc3_.normalize();
         return _loc3_;
      }
      
      public function sub(param1:BigInt) : BigInt
      {
         var _loc2_:BigInt = this.clone();
         s_ImplSub(_loc2_,param1,false);
         return _loc2_;
      }
      
      public function mod(param1:BigInt) : BigInt
      {
         var _loc2_:BigInt = new BigInt();
         s_ImplDiv(this,param1,null,_loc2_);
         return _loc2_;
      }
      
      public function compareAbsolute(param1:BigInt) : int
      {
         var _loc4_:int = 0;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc2_:uint = this.m_Digits.length;
         var _loc3_:uint = param1.m_Digits.length;
         if(_loc2_ > _loc3_)
         {
            return 1;
         }
         if(_loc2_ < _loc3_)
         {
            return -1;
         }
         _loc4_ = _loc2_ - 1;
         while(_loc4_ >= 0)
         {
            _loc5_ = this.m_Digits[_loc4_];
            _loc6_ = param1.m_Digits[_loc4_];
            if(_loc5_ > _loc6_)
            {
               return 1;
            }
            if(_loc5_ < _loc6_)
            {
               return -1;
            }
            _loc4_--;
         }
         return 0;
      }
      
      public function mul(param1:BigInt) : BigInt
      {
         var _loc2_:BigInt = this.clone();
         s_ImplMul(_loc2_,param1);
         return _loc2_;
      }
      
      private function normalize() : void
      {
         var _loc1_:int = this.m_Digits.length;
         while(_loc1_ > 1 && this.m_Digits[_loc1_ - 1] == 0)
         {
            _loc1_--;
         }
         this.m_Digits.length = _loc1_;
         if(_loc1_ == 1 && this.m_Digits[0] == 0)
         {
            this.m_Positive = true;
         }
      }
      
      public function div(param1:BigInt) : BigInt
      {
         var _loc2_:BigInt = new BigInt();
         s_ImplDiv(this,param1,_loc2_,null);
         return _loc2_;
      }
      
      public function get bitLength() : uint
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = this.m_Digits[this.m_Digits.length - 1];
         var _loc3_:uint = 32;
         while(_loc3_ > 0)
         {
            if((_loc2_ & 2147483648) != 0)
            {
               _loc1_ = _loc3_;
               break;
            }
            _loc2_ = _loc2_ << 1;
            _loc3_--;
         }
         _loc1_ = _loc1_ + (this.m_Digits.length - 1 << 5);
         return _loc1_;
      }
      
      private function testBit(param1:uint) : Boolean
      {
         var _loc2_:uint = param1 >>> 5;
         if(_loc2_ < this.m_Digits.length)
         {
            return 0 != (this.m_Digits[_loc2_] & 1 << (param1 & 31));
         }
         return false;
      }
      
      public function clone() : BigInt
      {
         var _loc1_:BigInt = new BigInt();
         _loc1_.assign(this);
         return _loc1_;
      }
      
      public function add(param1:BigInt) : BigInt
      {
         var _loc2_:BigInt = this.clone();
         s_ImplAdd(_loc2_,param1,false);
         return _loc2_;
      }
      
      public function compare(param1:BigInt) : int
      {
         if(this.m_Positive && !param1.m_Positive)
         {
            return 1;
         }
         if(!this.m_Positive && param1.m_Positive)
         {
            return -1;
         }
         if(this.m_Positive)
         {
            return 1 * this.compareAbsolute(param1);
         }
         return -1 * this.compareAbsolute(param1);
      }
      
      private function shiftLeft(param1:uint, param2:uint) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:int = 0;
         if(param1 > 31)
         {
            throw new Error("BigInteger.shiftLeft: Shift distance is invalid.");
         }
         if(param1 > 0)
         {
            _loc3_ = 32 - param1;
            _loc4_ = param2;
            _loc5_ = 0;
            _loc6_ = this.m_Digits.length;
            _loc7_ = 0;
            while(_loc7_ < _loc6_)
            {
               _loc5_ = this.m_Digits[_loc7_] >>> _loc3_;
               this.m_Digits[_loc7_] = this.m_Digits[_loc7_] << param1 | _loc4_;
               _loc4_ = _loc5_;
               _loc7_++;
            }
            this.m_Digits[_loc8_] = _loc4_;
            if(_loc6_ > 1 && this.m_Digits[_loc6_ - 1] == 0)
            {
               this.m_Digits.length--;
               _loc6_--;
            }
            if(_loc6_ == 1 && this.m_Digits[0] == 0)
            {
               this.m_Positive = true;
            }
         }
      }
      
      public function setZero() : void
      {
         this.m_Digits[0] = 0;
         this.m_Digits.length = 1;
         this.m_Positive = true;
      }
      
      public function toString(param1:int) : String
      {
         var _loc4_:uint = 0;
         var _loc5_:BigInt = null;
         var _loc6_:BigInt = null;
         var _loc7_:uint = 0;
         if(param1 != 2 && param1 != 10 && param1 != 16)
         {
            throw new Error("BigInt.toString: Invalid base.");
         }
         var _loc2_:BigInt = this.clone();
         var _loc3_:Vector.<String> = new Vector.<String>();
         if(param1 == 2)
         {
            do
            {
               _loc4_ = _loc2_.shiftRight(1,0) >>> 31;
               _loc3_.push(_loc4_.toString());
            }
            while(!_loc2_.isZero);
            
         }
         else if(param1 == 10)
         {
            _loc5_ = new BigInt(10);
            _loc6_ = new BigInt();
            do
            {
               s_ImplDiv(_loc2_,_loc5_,_loc2_,_loc6_);
               _loc3_.push(_loc6_.m_Digits[0].toString());
            }
            while(!_loc2_.isZero);
            
         }
         else if(param1 == 16)
         {
            do
            {
               _loc7_ = _loc2_.shiftRight(4,0) >>> 28;
               _loc3_.push(_loc7_.toString(16));
            }
            while(!_loc2_.isZero);
            
         }
         if(!_loc2_.m_Positive)
         {
            _loc3_.push("-");
         }
         return _loc3_.reverse().join("");
      }
      
      private function shiftLeftFar(param1:uint, param2:uint) : void
      {
         var _loc3_:uint = param1 >>> 5;
         var _loc4_:uint = 0;
         while(_loc4_ < _loc3_)
         {
            this.m_Digits.splice(0,0,param2);
            param2 = 0;
            _loc4_++;
         }
         this.shiftLeft(param1 & 31,param2);
      }
      
      public function assign(param1:BigInt) : void
      {
         if(this == param1)
         {
            return;
         }
         var _loc2_:int = param1.m_Digits.length;
         var _loc3_:uint = 0;
         while(_loc3_ < _loc2_)
         {
            this.m_Digits[_loc3_] = param1.m_Digits[_loc3_];
            _loc3_++;
         }
         this.m_Digits.length = _loc2_;
         this.m_Positive = param1.m_Positive;
         this.normalize();
      }
      
      public function get isZero() : Boolean
      {
         return this.m_Digits.length == 1 && this.m_Digits[0] == 0;
      }
      
      public function toByteArray(param1:ByteArray, param2:int = -1, param3:int = -1) : uint
      {
         if(!this.m_Positive)
         {
            throw new Error("BigInt.toByteArray: Cannot write negative numbers.");
         }
         if(param2 > -1)
         {
            param1.position = param2;
         }
         if(param3 < 0)
         {
            param3 = (this.bitLength + 7) / 8;
         }
         var _loc4_:int = param3 - 1;
         while(_loc4_ >= 0)
         {
            param1.writeByte(this.getByte(_loc4_));
            _loc4_--;
         }
         return param3;
      }
      
      private function shiftRight(param1:uint, param2:uint) : uint
      {
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:int = 0;
         if(param1 > 0)
         {
            _loc3_ = 32 - param1;
            _loc4_ = param2;
            _loc5_ = 0;
            _loc6_ = this.m_Digits.length;
            _loc7_ = _loc6_ - 1;
            while(_loc7_ >= 0)
            {
               _loc5_ = this.m_Digits[_loc7_] << _loc3_;
               this.m_Digits[_loc7_] = this.m_Digits[_loc7_] >>> param1 | _loc4_;
               _loc4_ = _loc5_;
               _loc7_--;
            }
            if(_loc6_ > 1 && this.m_Digits[_loc6_ - 1] == 0)
            {
               this.m_Digits.length--;
               _loc6_--;
            }
            if(_loc6_ == 1 && this.m_Digits[0] == 0)
            {
               this.m_Positive = true;
            }
            return _loc4_;
         }
         return 0;
      }
      
      private function reserve(param1:uint) : void
      {
         var _loc2_:uint = (param1 + 31) / 32;
         while(this.m_Digits.length < _loc2_)
         {
            this.m_Digits.push(0);
         }
      }
      
      private function getByte(param1:uint) : uint
      {
         var _loc2_:uint = param1 >>> 2;
         if(_loc2_ < this.m_Digits.length)
         {
            return 255 & this.m_Digits[_loc2_] >>> ((param1 & 3) << 3);
         }
         return 4294967040;
      }
   }
}
