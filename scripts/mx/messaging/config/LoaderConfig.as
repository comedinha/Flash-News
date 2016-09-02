package mx.messaging.config
{
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   public class LoaderConfig
   {
      
      mx_internal static var _parameters:Object;
      
      mx_internal static var _swfVersion:uint;
      
      mx_internal static var _url:String = null;
      
      mx_internal static const VERSION:String = "3.6.0.21751";
       
      
      public function LoaderConfig()
      {
         super();
      }
      
      public static function get parameters() : Object
      {
         return _parameters;
      }
      
      public static function get url() : String
      {
         return _url;
      }
      
      public static function get swfVersion() : uint
      {
         return _swfVersion;
      }
   }
}
