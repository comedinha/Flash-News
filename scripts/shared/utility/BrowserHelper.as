package shared.utility
{
   import flash.external.ExternalInterface;
   import flash.system.Capabilities;
   
   public class BrowserHelper
   {
      
      public static const INTERNETEXPLORER:int = 3;
      
      public static const UNKNOWN:int = 0;
      
      private static const USERAGENT_REGEXP:Array = [null,/^Mozilla\/[0-9]+.[0-9]+ .* Chrome\/([0-9]+)\.([0-9]+)\.([0-9]+).*$/,/^Mozilla\/[0-9]+.[0-9]+ .* Firefox\/([0-9]+)\.([0-9]+)\.([0-9]+).*$/,/^Mozilla\/[0-9]+.[0-9]+ \(compatible; MSIE ([0-9]+)\.([0-9]+);.*$/,/^Mozilla\/[0-9]+.[0-9]+ .* Safari\/([0-9]+)\.([0-9]+)\.([0-9]+)$/,/^Opera\/([0-9]+)\.([0-9]+) .*$/];
      
      public static const SAFARI:int = 4;
      
      public static const OPERA:int = 5;
      
      public static const FIREFOX:int = 2;
      
      public static const CHROME:int = 1;
       
      
      public function BrowserHelper()
      {
         super();
      }
      
      public static function s_GetBrowserID() : int
      {
         if(!ExternalInterface.available)
         {
            return UNKNOWN;
         }
         var _loc1_:String = ExternalInterface.call("function () { return navigator.userAgent; }") as String;
         if(_loc1_ == null)
         {
            return UNKNOWN;
         }
         if(_loc1_.indexOf("Chrome") > -1)
         {
            return CHROME;
         }
         if(_loc1_.indexOf("Firefox") > -1)
         {
            return FIREFOX;
         }
         if(_loc1_.indexOf("MSIE") > -1)
         {
            return INTERNETEXPLORER;
         }
         if(_loc1_.indexOf("Safari") > -1)
         {
            return SAFARI;
         }
         if(_loc1_.indexOf("Opera") > -1)
         {
            return OPERA;
         }
         return UNKNOWN;
      }
      
      public static function s_CompareBrowserVersion(param1:int = 0, param2:int = 0, param3:int = 0) : int
      {
         var _loc5_:String = null;
         if(!ExternalInterface.available)
         {
            return -1;
         }
         var _loc4_:int = s_GetBrowserID();
         if(_loc4_ == UNKNOWN)
         {
            return -1;
         }
         _loc5_ = ExternalInterface.call("function () { return navigator.userAgent; }") as String;
         var _loc6_:Object = USERAGENT_REGEXP[_loc4_].exec(_loc5_);
         if(_loc6_ == null)
         {
            return -1;
         }
         var _loc7_:Number = parseInt(_loc6_[1] as String);
         var _loc8_:Number = parseInt(_loc6_[2] as String);
         var _loc9_:Number = _loc6_.length == 4?Number(parseInt(_loc6_[3] as String)):Number(0);
         if(isNaN(_loc7_) || _loc7_ < param1)
         {
            return -1;
         }
         if(_loc7_ > param1)
         {
            return 1;
         }
         if(isNaN(_loc8_) || _loc8_ < param2)
         {
            return -1;
         }
         if(_loc8_ > param2)
         {
            return 1;
         }
         if(isNaN(_loc9_) || _loc9_ < param3)
         {
            return -1;
         }
         if(_loc9_ > param3)
         {
            return 1;
         }
         return 0;
      }
      
      public static function s_CompareFlashPlayerVersion(param1:String) : Boolean
      {
         var _loc2_:String = Capabilities.version;
         return _loc2_.indexOf(param1) > -1;
      }
      
      public static function s_GetBrowserString() : String
      {
         var _loc1_:String = null;
         if(ExternalInterface.available)
         {
            _loc1_ = ExternalInterface.call("function () { return navigator.userAgent; }") as String;
         }
         return _loc1_;
      }
   }
}
