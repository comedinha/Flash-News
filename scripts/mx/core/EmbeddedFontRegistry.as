package mx.core
{
   import flash.text.FontStyle;
   import flash.utils.Dictionary;
   
   use namespace mx_internal;
   
   public class EmbeddedFontRegistry implements mx.core.IEmbeddedFontRegistry
   {
      
      private static var fonts:Object = {};
      
      private static var instance:mx.core.IEmbeddedFontRegistry;
      
      mx_internal static const VERSION:String = "3.6.0.21751";
       
      
      public function EmbeddedFontRegistry()
      {
         super();
      }
      
      public static function registerFonts(param1:Object, param2:IFlexModuleFactory) : void
      {
         var _loc4_:* = null;
         var _loc5_:Object = null;
         var _loc6_:* = null;
         var _loc7_:Boolean = false;
         var _loc8_:Boolean = false;
         var _loc3_:mx.core.IEmbeddedFontRegistry = IEmbeddedFontRegistry(Singleton.getInstance("mx.core::IEmbeddedFontRegistry"));
         for(_loc4_ in param1)
         {
            _loc5_ = param1[_loc4_];
            for(_loc6_ in _loc5_)
            {
               if(_loc5_[_loc6_] != false)
               {
                  if(_loc6_ == "regular")
                  {
                     _loc7_ = false;
                     _loc8_ = false;
                  }
                  else if(_loc6_ == "boldItalic")
                  {
                     _loc7_ = true;
                     _loc8_ = true;
                  }
                  else if(_loc6_ == "bold")
                  {
                     _loc7_ = true;
                     _loc8_ = false;
                  }
                  else if(_loc6_ == "italic")
                  {
                     _loc7_ = false;
                     _loc8_ = true;
                  }
                  _loc3_.registerFont(new EmbeddedFont(String(_loc4_),_loc7_,_loc8_),param2);
               }
            }
         }
      }
      
      public static function getInstance() : mx.core.IEmbeddedFontRegistry
      {
         if(!instance)
         {
            instance = new EmbeddedFontRegistry();
         }
         return instance;
      }
      
      public static function getFontStyle(param1:Boolean, param2:Boolean) : String
      {
         var _loc3_:String = FontStyle.REGULAR;
         if(param1 && param2)
         {
            _loc3_ = FontStyle.BOLD_ITALIC;
         }
         else if(param1)
         {
            _loc3_ = FontStyle.BOLD;
         }
         else if(param2)
         {
            _loc3_ = FontStyle.ITALIC;
         }
         return _loc3_;
      }
      
      private static function createFontKey(param1:EmbeddedFont) : String
      {
         return param1.fontName + param1.fontStyle;
      }
      
      private static function createEmbeddedFont(param1:String) : EmbeddedFont
      {
         var _loc2_:String = null;
         var _loc3_:Boolean = false;
         var _loc4_:Boolean = false;
         var _loc5_:int = endsWith(param1,FontStyle.REGULAR);
         if(_loc5_ > 0)
         {
            _loc2_ = param1.substring(0,_loc5_);
            return new EmbeddedFont(_loc2_,false,false);
         }
         _loc5_ = endsWith(param1,FontStyle.BOLD);
         if(_loc5_ > 0)
         {
            _loc2_ = param1.substring(0,_loc5_);
            return new EmbeddedFont(_loc2_,true,false);
         }
         _loc5_ = endsWith(param1,FontStyle.BOLD_ITALIC);
         if(_loc5_ > 0)
         {
            _loc2_ = param1.substring(0,_loc5_);
            return new EmbeddedFont(_loc2_,true,true);
         }
         _loc5_ = endsWith(param1,FontStyle.ITALIC);
         if(_loc5_ > 0)
         {
            _loc2_ = param1.substring(0,_loc5_);
            return new EmbeddedFont(_loc2_,false,true);
         }
         return new EmbeddedFont("",false,false);
      }
      
      private static function endsWith(param1:String, param2:String) : int
      {
         var _loc3_:int = param1.lastIndexOf(param2);
         if(_loc3_ > 0 && _loc3_ + param2.length == param1.length)
         {
            return _loc3_;
         }
         return -1;
      }
      
      public function getAssociatedModuleFactory(param1:EmbeddedFont, param2:IFlexModuleFactory) : IFlexModuleFactory
      {
         var _loc4_:int = 0;
         var _loc5_:* = null;
         var _loc3_:Dictionary = fonts[createFontKey(param1)];
         if(_loc3_)
         {
            _loc4_ = _loc3_[param2];
            if(_loc4_)
            {
               return param2;
            }
            for(_loc5_ in _loc3_)
            {
               return _loc5_ as IFlexModuleFactory;
            }
         }
         return null;
      }
      
      public function deregisterFont(param1:EmbeddedFont, param2:IFlexModuleFactory) : void
      {
         var _loc5_:int = 0;
         var _loc6_:* = null;
         var _loc3_:String = createFontKey(param1);
         var _loc4_:Dictionary = fonts[_loc3_];
         if(_loc4_ != null)
         {
            delete _loc4_[param2];
            _loc5_ = 0;
            for(_loc6_ in _loc4_)
            {
               _loc5_++;
            }
            if(_loc5_ == 0)
            {
               delete fonts[_loc3_];
            }
         }
      }
      
      public function getFonts() : Array
      {
         var _loc2_:* = null;
         var _loc1_:Array = [];
         for(_loc2_ in fonts)
         {
            _loc1_.push(createEmbeddedFont(_loc2_));
         }
         return _loc1_;
      }
      
      public function registerFont(param1:EmbeddedFont, param2:IFlexModuleFactory) : void
      {
         var _loc3_:String = createFontKey(param1);
         var _loc4_:Dictionary = fonts[_loc3_];
         if(!_loc4_)
         {
            _loc4_ = new Dictionary(true);
            fonts[_loc3_] = _loc4_;
         }
         _loc4_[param2] = 1;
      }
   }
}
