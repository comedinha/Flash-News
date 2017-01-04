package shared.utility
{
   public class Colour
   {
      
      private static const s_TempColor:Colour = new Colour(0,0,0);
      
      public static const HSI_SI_VALUES:int = 7;
      
      public static const HSI_H_STEPS:int = 19;
       
      
      protected var m_Blue:uint = 0;
      
      protected var m_Green:uint = 0;
      
      protected var m_Red:uint = 0;
      
      protected var m_Alpha:uint = 0;
      
      public function Colour(param1:uint = 0, param2:uint = 0, param3:uint = 0, param4:uint = 255)
      {
         super();
         this.red = param1;
         this.green = param2;
         this.blue = param3;
         this.alpha = param4;
      }
      
      public static function s_ARGBFromEightBit(param1:uint) : uint
      {
         s_TempColor.eightBit = param1;
         return s_TempColor.ARGB;
      }
      
      public static function s_EightBitFromARGB(param1:uint) : uint
      {
         s_TempColor.ARGB = param1;
         return s_TempColor.eightBit;
      }
      
      public static function s_FromHSI(param1:int) : Colour
      {
         var _loc2_:Colour = new Colour(0,0,0);
         _loc2_.HSI = param1;
         return _loc2_;
      }
      
      public static function s_RGBFromEightBit(param1:uint) : uint
      {
         s_TempColor.eightBit = param1;
         return s_TempColor.RGB;
      }
      
      public static function s_FromARGB(param1:uint) : Colour
      {
         var _loc2_:uint = param1 >> 24 & 255;
         var _loc3_:uint = param1 >> 16 & 255;
         var _loc4_:uint = param1 >> 8 & 255;
         var _loc5_:uint = param1 & 255;
         return new Colour(_loc3_,_loc4_,_loc5_,_loc2_);
      }
      
      public static function s_FromEightBit(param1:int) : Colour
      {
         var _loc2_:Colour = new Colour(0,0,0);
         _loc2_.eightBit = param1;
         return _loc2_;
      }
      
      public static function s_ARGBFromHSI(param1:int) : uint
      {
         s_TempColor.HSI = param1;
         return s_TempColor.ARGB;
      }
      
      public function set alphaFloat(param1:Number) : void
      {
         if(param1 < 0 || param1 > 1)
         {
            throw new ArgumentError("Colour.set alphaFloat: Invalid value: " + param1);
         }
         this.m_Alpha = param1 * 255;
      }
      
      public function get green() : uint
      {
         return this.m_Green & 255;
      }
      
      public function set blueFloat(param1:Number) : void
      {
         if(param1 < 0 || param1 > 1)
         {
            throw new ArgumentError("Colour.set blueFloat: Invalid value: " + param1);
         }
         this.m_Blue = param1 * 255;
      }
      
      public function get eightBit() : uint
      {
         return this.red / 51 * 36 + this.green / 51 * 6 + this.blue / 51;
      }
      
      public function set green(param1:uint) : void
      {
         if(param1 < 0 || param1 > 255)
         {
            throw new ArgumentError("Colour.set green: Invalid value: " + param1);
         }
         this.m_Green = param1;
      }
      
      public function div(param1:int, param2:Boolean = true) : Colour
      {
         if(param1 == 0)
         {
            throw new ArgumentError("Colour.divide: Division by 0.");
         }
         var _loc3_:int = this.m_Red / param1;
         if(_loc3_ < 0)
         {
            _loc3_ = 0;
         }
         if(_loc3_ > 255)
         {
            _loc3_ = 255;
         }
         var _loc4_:int = this.m_Green / param1;
         if(_loc4_ < 0)
         {
            _loc4_ = 0;
         }
         if(_loc4_ > 255)
         {
            _loc4_ = 255;
         }
         var _loc5_:int = this.m_Blue / param1;
         if(_loc5_ < 0)
         {
            _loc5_ = 0;
         }
         if(_loc5_ > 255)
         {
            _loc5_ = 255;
         }
         var _loc6_:int = this.m_Alpha;
         if(param2)
         {
            _loc6_ = this.m_Alpha / param1;
            if(_loc6_ < 0)
            {
               _loc6_ = 0;
            }
            if(_loc6_ > 255)
            {
               _loc6_ = 255;
            }
         }
         return new Colour(_loc3_,_loc4_,_loc5_,_loc6_);
      }
      
      public function get redFloat() : Number
      {
         return this.m_Red / 255;
      }
      
      public function set brightness(param1:Number) : void
      {
         if(param1 < 0 || param1 > 1)
         {
            throw new ArgumentError("Colour.set alphaFloat: Invalid value: " + param1);
         }
         var _loc2_:uint = param1 * 255;
         this.setChannels(_loc2_,_loc2_,_loc2_);
      }
      
      public function get red() : uint
      {
         return this.m_Red & 255;
      }
      
      public function setChannels(param1:uint, param2:uint, param3:uint, param4:uint = 255, param5:Boolean = false) : void
      {
         if(param5)
         {
            this.ARGB = param4 << 24 | param1 << 16 | param2 << 8 | param3;
         }
         else
         {
            this.ARGB = this.clipChannel(param4) << 24 | this.clipChannel(param1) << 16 | this.clipChannel(param2) << 8 | this.clipChannel(param3);
         }
      }
      
      public function get ARGB() : uint
      {
         return this.m_Alpha << 24 | this.m_Red << 16 | this.m_Green << 8 | this.m_Blue;
      }
      
      public function set alpha(param1:uint) : void
      {
         if(param1 < 0 || param1 > 255)
         {
            throw new ArgumentError("Colour.set alpha: Invalid value: " + param1);
         }
         this.m_Alpha = param1;
      }
      
      public function set redFloat(param1:Number) : void
      {
         if(param1 < 0 || param1 > 1)
         {
            throw new ArgumentError("Colour.set redFloat: Invalid value: " + param1);
         }
         this.m_Red = param1 * 255;
      }
      
      public function get greenFloat() : Number
      {
         return this.m_Green / 255;
      }
      
      public function get blue() : uint
      {
         return this.m_Blue & 255;
      }
      
      public function mul(param1:int, param2:Boolean = true) : Colour
      {
         var _loc3_:Colour = new Colour(0,0,0);
         _loc3_.ARGB = this.ARGB;
         _loc3_.mulToSelf(param1,param2);
         return _loc3_;
      }
      
      public function get alpha() : uint
      {
         return this.m_Alpha & 255;
      }
      
      public function get brightness() : Number
      {
         return (this.m_Red + this.m_Green + this.m_Blue) / (3 * 255);
      }
      
      public function add(param1:Colour, param2:Boolean = true) : Colour
      {
         var _loc3_:Colour = new Colour(0,0,0);
         _loc3_.ARGB = this.ARGB;
         _loc3_.addToSelf(param1,param2);
         return _loc3_;
      }
      
      public function mulToSelf(param1:int, param2:Boolean = true) : void
      {
         var _loc3_:int = this.m_Red * param1;
         var _loc4_:int = this.m_Green * param1;
         var _loc5_:int = this.m_Blue * param1;
         var _loc6_:int = this.m_Alpha;
         if(param2)
         {
            _loc6_ = this.m_Alpha * param1;
         }
         this.setChannels(_loc3_,_loc4_,_loc5_,_loc6_,true);
      }
      
      public function get alphaFloat() : Number
      {
         return this.m_Alpha / 255;
      }
      
      public function addToSelf(param1:Colour, param2:Boolean = true) : void
      {
         var _loc3_:int = this.m_Red + param1.m_Red;
         var _loc4_:int = this.m_Green + param1.m_Green;
         var _loc5_:int = this.m_Blue + param1.m_Blue;
         var _loc6_:int = this.m_Alpha;
         if(param2)
         {
            _loc6_ = this.m_Alpha + param1.m_Alpha;
         }
         this.setChannels(_loc3_,_loc4_,_loc5_,_loc6_,true);
      }
      
      public function set red(param1:uint) : void
      {
         if(param1 < 0 || param1 > 255)
         {
            throw new ArgumentError("Colour.set red: Invalid value: " + param1);
         }
         this.m_Red = param1;
      }
      
      protected function clipChannel(param1:int) : uint
      {
         if(param1 < 0)
         {
            param1 = 0;
         }
         if(param1 > 255)
         {
            param1 = 255;
         }
         return param1;
      }
      
      public function get RGB() : uint
      {
         return this.m_Red << 16 | this.m_Green << 8 | this.m_Blue;
      }
      
      public function divFloat(param1:Number, param2:Boolean = true) : Colour
      {
         if(param1 == 0)
         {
            throw new ArgumentError("Colour.divideFloat: Invalid colour.");
         }
         var _loc3_:int = int(this.m_Red / param1 + 0.5);
         if(_loc3_ < 0)
         {
            _loc3_ = 0;
         }
         if(_loc3_ > 255)
         {
            _loc3_ = 255;
         }
         var _loc4_:int = int(this.m_Green / param1 + 0.5);
         if(_loc4_ < 0)
         {
            _loc4_ = 0;
         }
         if(_loc4_ > 255)
         {
            _loc4_ = 255;
         }
         var _loc5_:int = int(this.m_Blue / param1 + 0.5);
         if(_loc5_ < 0)
         {
            _loc5_ = 0;
         }
         if(_loc5_ > 255)
         {
            _loc5_ = 255;
         }
         var _loc6_:int = this.m_Alpha;
         if(param2)
         {
            _loc6_ = int(this.m_Alpha / param1 + 0.5);
            if(_loc6_ < 0)
            {
               _loc6_ = 0;
            }
            if(_loc6_ > 255)
            {
               _loc6_ = 255;
            }
         }
         return new Colour(_loc3_,_loc4_,_loc5_,_loc6_);
      }
      
      public function get blueFloat() : Number
      {
         return this.m_Blue / 255;
      }
      
      public function set greenFloat(param1:Number) : void
      {
         if(param1 < 0 || param1 > 1)
         {
            throw new ArgumentError("Colour.set greenFloat: Invalid value: " + param1);
         }
         this.m_Green = param1 * 255;
      }
      
      public function set blue(param1:uint) : void
      {
         if(param1 < 0 || param1 > 255)
         {
            throw new ArgumentError("Colour.set blue: Invalid value: " + param1);
         }
         this.m_Blue = param1;
      }
      
      public function set HSI(param1:int) : void
      {
         var _loc8_:int = 0;
         if(param1 >= HSI_H_STEPS * HSI_SI_VALUES)
         {
            param1 = 0;
         }
         var _loc2_:Number = 0;
         var _loc3_:Number = 0;
         var _loc4_:Number = 0;
         if(param1 % HSI_H_STEPS == 0)
         {
            _loc2_ = 0;
            _loc3_ = 0;
            _loc4_ = 1 - param1 / HSI_H_STEPS / HSI_SI_VALUES;
         }
         else
         {
            _loc2_ = param1 % HSI_H_STEPS * (1 / 18);
            _loc3_ = 1;
            _loc4_ = 1;
            switch(int(param1 / HSI_H_STEPS))
            {
               case 0:
                  _loc3_ = 0.25;
                  _loc4_ = 1;
                  break;
               case 1:
                  _loc3_ = 0.25;
                  _loc4_ = 0.75;
                  break;
               case 2:
                  _loc3_ = 0.5;
                  _loc4_ = 0.75;
                  break;
               case 3:
                  _loc3_ = 0.667;
                  _loc4_ = 0.75;
                  break;
               case 4:
                  _loc3_ = 1;
                  _loc4_ = 1;
                  break;
               case 5:
                  _loc3_ = 1;
                  _loc4_ = 0.75;
                  break;
               case 6:
                  _loc3_ = 1;
                  _loc4_ = 0.5;
            }
         }
         if(_loc4_ == 0)
         {
            this.setChannels(0,0,0);
         }
         if(_loc3_ == 0)
         {
            _loc8_ = int(_loc4_ * 255);
            this.setChannels(_loc8_,_loc8_,_loc8_);
         }
         var _loc5_:Number = 0;
         var _loc6_:Number = 0;
         var _loc7_:Number = 0;
         if(_loc2_ < 1 / 6)
         {
            _loc5_ = _loc4_;
            _loc7_ = _loc4_ * (1 - _loc3_);
            _loc6_ = _loc7_ + (_loc4_ - _loc7_) * 6 * _loc2_;
         }
         else if(_loc2_ < 2 / 6)
         {
            _loc6_ = _loc4_;
            _loc7_ = _loc4_ * (1 - _loc3_);
            _loc5_ = _loc6_ - (_loc4_ - _loc7_) * (6 * _loc2_ - 1);
         }
         else if(_loc2_ < 3 / 6)
         {
            _loc6_ = _loc4_;
            _loc5_ = _loc4_ * (1 - _loc3_);
            _loc7_ = _loc5_ + (_loc4_ - _loc5_) * (6 * _loc2_ - 2);
         }
         else if(_loc2_ < 4 / 6)
         {
            _loc7_ = _loc4_;
            _loc5_ = _loc4_ * (1 - _loc3_);
            _loc6_ = _loc7_ - (_loc4_ - _loc5_) * (6 * _loc2_ - 3);
         }
         else if(_loc2_ < 5 / 6)
         {
            _loc7_ = _loc4_;
            _loc6_ = _loc4_ * (1 - _loc3_);
            _loc5_ = _loc6_ + (_loc4_ - _loc6_) * (6 * _loc2_ - 4);
         }
         else
         {
            _loc5_ = _loc4_;
            _loc6_ = _loc4_ * (1 - _loc3_);
            _loc7_ = _loc5_ - (_loc4_ - _loc6_) * (6 * _loc2_ - 5);
         }
         this.setChannels(int(_loc5_ * 255),int(_loc6_ * 255),int(_loc7_ * 255));
      }
      
      public function mulFloat(param1:Number, param2:Boolean = true) : Colour
      {
         var _loc3_:Colour = new Colour(0,0,0);
         _loc3_.ARGB = this.ARGB;
         _loc3_.mulFloatToSelf(param1,param2);
         return _loc3_;
      }
      
      public function set ARGB(param1:uint) : void
      {
         this.m_Alpha = param1 >> 24 & 255;
         this.m_Red = param1 >> 16 & 255;
         this.m_Green = param1 >> 8 & 255;
         this.m_Blue = param1 & 255;
      }
      
      public function toString() : String
      {
         return (this.m_Red << 24 | this.m_Green << 16 | this.m_Blue << 8 | this.m_Alpha).toString();
      }
      
      public function set eightBit(param1:uint) : void
      {
         if(param1 < 0 || param1 >= 216)
         {
            this.setChannels(0,0,0);
         }
         var _loc2_:int = int(param1 / 36) % 6 * 51;
         var _loc3_:int = int(param1 / 6) % 6 * 51;
         var _loc4_:int = param1 % 6 * 51;
         this.setChannels(_loc2_,_loc3_,_loc4_);
      }
      
      public function mulFloatToSelf(param1:Number, param2:Boolean = true) : void
      {
         var _loc3_:int = this.clipChannel(int(this.m_Red * param1 + 0.5));
         var _loc4_:int = this.clipChannel(int(this.m_Green * param1 + 0.5));
         var _loc5_:int = this.clipChannel(int(this.m_Blue * param1 + 0.5));
         var _loc6_:int = this.m_Alpha;
         if(param2)
         {
            _loc6_ = this.clipChannel(int(this.m_Alpha * param1 + 0.5));
         }
         this.setChannels(_loc3_,_loc4_,_loc5_,_loc6_);
      }
   }
}
