package mx.resources
{
   import flash.system.ApplicationDomain;
   import mx.core.mx_internal;
   import mx.utils.StringUtil;
   
   use namespace mx_internal;
   
   public class ResourceBundle implements IResourceBundle
   {
      
      mx_internal static const VERSION:String = "3.6.0.21751";
      
      mx_internal static var backupApplicationDomain:ApplicationDomain;
      
      mx_internal static var locale:String;
       
      
      mx_internal var _locale:String;
      
      private var _content:Object;
      
      mx_internal var _bundleName:String;
      
      public function ResourceBundle(param1:String = null, param2:String = null)
      {
         _content = {};
         super();
         mx_internal::_locale = param1;
         mx_internal::_bundleName = param2;
         _content = getContent();
      }
      
      private static function getClassByName(param1:String, param2:ApplicationDomain) : Class
      {
         var _loc3_:Class = null;
         if(param2.hasDefinition(param1))
         {
            _loc3_ = param2.getDefinition(param1) as Class;
         }
         return _loc3_;
      }
      
      public static function getResourceBundle(param1:String, param2:ApplicationDomain = null) : ResourceBundle
      {
         var _loc3_:* = null;
         var _loc4_:Class = null;
         var _loc5_:Object = null;
         var _loc6_:ResourceBundle = null;
         if(!param2)
         {
            param2 = ApplicationDomain.currentDomain;
         }
         _loc3_ = mx_internal::locale + "$" + param1 + "_properties";
         _loc4_ = getClassByName(_loc3_,param2);
         if(!_loc4_)
         {
            _loc3_ = param1 + "_properties";
            _loc4_ = getClassByName(_loc3_,param2);
         }
         if(!_loc4_)
         {
            _loc3_ = param1;
            _loc4_ = getClassByName(_loc3_,param2);
         }
         if(!_loc4_ && mx_internal::backupApplicationDomain)
         {
            _loc3_ = param1 + "_properties";
            _loc4_ = getClassByName(_loc3_,mx_internal::backupApplicationDomain);
            if(!_loc4_)
            {
               _loc3_ = param1;
               _loc4_ = getClassByName(_loc3_,mx_internal::backupApplicationDomain);
            }
         }
         if(_loc4_)
         {
            _loc5_ = new _loc4_();
            if(_loc5_ is ResourceBundle)
            {
               _loc6_ = ResourceBundle(_loc5_);
               return _loc6_;
            }
         }
         throw new Error("Could not find resource bundle " + param1);
      }
      
      protected function getContent() : Object
      {
         return {};
      }
      
      public function getString(param1:String) : String
      {
         return String(_getObject(param1));
      }
      
      public function get content() : Object
      {
         return _content;
      }
      
      public function getBoolean(param1:String, param2:Boolean = true) : Boolean
      {
         var _loc3_:String = _getObject(param1).toLowerCase();
         if(_loc3_ == "false")
         {
            return false;
         }
         if(_loc3_ == "true")
         {
            return true;
         }
         return param2;
      }
      
      public function getStringArray(param1:String) : Array
      {
         var _loc2_:Array = _getObject(param1).split(",");
         var _loc3_:int = _loc2_.length;
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc2_[_loc4_] = StringUtil.trim(_loc2_[_loc4_]);
            _loc4_++;
         }
         return _loc2_;
      }
      
      public function getObject(param1:String) : Object
      {
         return _getObject(param1);
      }
      
      private function _getObject(param1:String) : Object
      {
         var _loc2_:Object = content[param1];
         if(!_loc2_)
         {
            throw new Error("Key " + param1 + " was not found in resource bundle " + bundleName);
         }
         return _loc2_;
      }
      
      public function get locale() : String
      {
         return mx_internal::_locale;
      }
      
      public function get bundleName() : String
      {
         return mx_internal::_bundleName;
      }
      
      public function getNumber(param1:String) : Number
      {
         return Number(_getObject(param1));
      }
   }
}
