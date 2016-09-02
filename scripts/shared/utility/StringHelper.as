package shared.utility
{
   import flash.utils.ByteArray;
   
   public class StringHelper
   {
      
      public static const STRING_SERIALISATION_CHARSET:String = "iso-8859-1";
       
      
      public function StringHelper()
      {
         super();
      }
      
      public static function s_WriteToByteArray(param1:ByteArray, param2:String, param3:int = 2147483647) : void
      {
         if(param2.length > param3)
         {
            throw new Error("StringHelper.s_WriteToByteArray: Invalid string: \"" + param2 + "\".");
         }
         var _loc4_:int = param2.length;
         if(_loc4_ > 65535)
         {
            param1.writeShort(65535);
            param1.writeInt(_loc4_);
         }
         else
         {
            param1.writeShort(_loc4_);
         }
         param1.writeMultiByte(param2,STRING_SERIALISATION_CHARSET);
      }
      
      public static function s_StripTags(param1:String) : String
      {
         if(param1 != null)
         {
            param1 = param1.replace(/<[^>]*>/g,"");
         }
         return param1;
      }
      
      public static function s_MillisecondsToTimeString(param1:uint, param2:Boolean = true, param3:Boolean = false) : String
      {
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         _loc4_ = param1 / 1000;
         _loc5_ = _loc4_ / 60;
         var _loc6_:uint = _loc5_ / 60;
         var _loc7_:String = !!param3?s_PadWithChars(String(_loc6_),"00"):String(_loc6_);
         var _loc8_:String = "";
         _loc8_ = _loc7_ + ":" + s_PadWithChars(String(_loc5_ % 60),"00") + ":" + s_PadWithChars(String(_loc4_ % 60),"00");
         if(param2)
         {
            _loc8_ = _loc8_ + ("." + s_PadWithChars(String(param1 % 1000),"000"));
         }
         return _loc8_;
      }
      
      public static function s_StripNewline(param1:String) : String
      {
         if(param1 != null)
         {
            param1 = param1.replace(/(\r\n|\n\r|\r)/g,"");
         }
         return param1;
      }
      
      public static function s_TrimFront(param1:String) : String
      {
         if(param1 != null)
         {
            param1 = param1.replace(/^\s+/,"");
         }
         return param1;
      }
      
      public static function s_RemoveHilight(param1:String) : String
      {
         if(param1 != null)
         {
            param1 = param1.replace(/[{}]/g,"");
         }
         return param1;
      }
      
      public static function s_EqualsIgnoreCase(param1:String, param2:String) : Boolean
      {
         if(param1 == null || param2 == null)
         {
            return param1 == param2;
         }
         return param1.toUpperCase() == param2.toUpperCase();
      }
      
      public static function s_Trim(param1:String) : String
      {
         if(param1 != null)
         {
            param1 = param1.replace(/(^\s+|\s+$)/g,"");
         }
         return param1;
      }
      
      public static function s_HilightToHTML(param1:String, param2:uint) : String
      {
         var _loc3_:String = null;
         var _loc4_:RegExp = null;
         var _loc5_:int = 0;
         var _loc6_:Object = null;
         var _loc7_:String = null;
         if(param1 != null)
         {
            _loc3_ = "";
            _loc4_ = /\{[^}]+\}(?:\s+\{[^}]+\})*/g;
            _loc5_ = 0;
            _loc6_ = null;
            while((_loc6_ = _loc4_.exec(param1)) != null)
            {
               _loc7_ = (_loc6_[0] as String).replace(/[{}]/g,"");
               _loc3_ = _loc3_ + (param1.substring(_loc5_,_loc6_.index) + "<font color=\"#" + (param2 & 16777215).toString(16) + "\">" + "<a href=\"event:" + _loc7_ + "\">" + _loc7_ + "</a>" + "</font>");
               _loc5_ = _loc6_.index + (_loc6_[0] as String).length;
            }
            return _loc3_ + param1.substring(_loc5_);
         }
         return null;
      }
      
      public static function s_PadWithChars(param1:String, param2:String) : String
      {
         if(param1.length < param2.length)
         {
            param1 = param2.substring(0,param2.length - param1.length) + param1;
         }
         return param1;
      }
      
      public static function s_ReadPositiveInt(param1:String, param2:int = -1, param3:int = -1) : int
      {
         var _loc4_:int = 0;
         if(param1 != null && param1.match(/^[0-9]+$/) != null)
         {
            _loc4_ = int(param1);
            if((param2 == -1 || _loc4_ >= param2) && (param3 == -1 || _loc4_ <= param3))
            {
               return _loc4_;
            }
         }
         return -1;
      }
      
      public static function s_TrimBack(param1:String) : String
      {
         if(param1 != null)
         {
            param1 = param1.replace(/\s+$/,"");
         }
         return param1;
      }
      
      public static function s_IsWhitsepace(param1:String) : Boolean
      {
         return param1.match(/^\s+$/) != null;
      }
      
      public static function s_ReadLongStringFromByteArray(param1:ByteArray, param2:int = 2147483647) : String
      {
         if(param1.bytesAvailable < 2)
         {
            throw new Error("StringHelper.s_ReadLongStringFromByteArray: Not enough data(1).");
         }
         var _loc3_:int = param1.readUnsignedShort();
         if(param1.bytesAvailable < _loc3_)
         {
            throw new Error("StringHelper.s_ReadLongStringFromByteArray: Not enough data(2).");
         }
         var _loc4_:String = param1.readMultiByte(_loc3_,STRING_SERIALISATION_CHARSET);
         return _loc4_.substr(0,param2);
      }
      
      public static function s_HTMLSpecialChars(param1:String) : String
      {
         if(param1 != null)
         {
            param1 = param1.replace(/&/g,"&amp;").replace(/</g,"&lt;").replace(/>/g,"&gt;").replace(/"/g,"&quot;").replace(/'/g,"&apos;");
         }
         return param1;
      }
      
      public static function s_ReadShortStringFromByteArray(param1:ByteArray, param2:uint = 255) : String
      {
         if(param1.bytesAvailable < 1)
         {
            throw new Error("StringHelper.s_ReadShortStringFromByteArray: Not enough data(1).");
         }
         var _loc3_:int = param1.readUnsignedByte();
         if(param1.bytesAvailable < _loc3_)
         {
            throw new Error("StringHelper.s_ReadShortStringFromByteArray: Not enough data(2).");
         }
         var _loc4_:String = param1.readMultiByte(_loc3_,STRING_SERIALISATION_CHARSET);
         return _loc4_.substr(0,param2);
      }
      
      public static function s_CleanNewline(param1:String) : String
      {
         if(param1 != null)
         {
            param1 = param1.replace(/(\r\n|\n\r|\r)/g,"\n");
         }
         return param1;
      }
      
      public static function s_Capitalise(param1:String) : String
      {
         var a_String:String = param1;
         var ToUpperCase:Function = function():String
         {
            return String(arguments[0]).toUpperCase();
         };
         return a_String.replace(/\b(.)/g,ToUpperCase);
      }
   }
}
