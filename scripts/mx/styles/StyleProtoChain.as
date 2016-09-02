package mx.styles
{
   import mx.core.mx_internal;
   import flash.display.DisplayObject;
   import mx.core.UIComponent;
   import mx.core.IUITextField;
   
   use namespace mx_internal;
   
   public class StyleProtoChain
   {
      
      mx_internal static const VERSION:String = "3.6.0.21751";
       
      
      public function StyleProtoChain()
      {
         super();
      }
      
      public static function initProtoChainForUIComponentStyleName(param1:IStyleClient) : void
      {
         var _loc9_:CSSStyleDeclaration = null;
         var _loc2_:IStyleClient = IStyleClient(param1.styleName);
         var _loc3_:DisplayObject = param1 as DisplayObject;
         var _loc4_:Object = _loc2_.nonInheritingStyles;
         if(!_loc4_ || _loc4_ == UIComponent.STYLE_UNINITIALIZED)
         {
            _loc4_ = StyleManager.stylesRoot;
            if(_loc4_.effects)
            {
               param1.registerEffects(_loc4_.effects);
            }
         }
         var _loc5_:Object = _loc2_.inheritingStyles;
         if(!_loc5_ || _loc5_ == UIComponent.STYLE_UNINITIALIZED)
         {
            _loc5_ = StyleManager.stylesRoot;
         }
         var _loc6_:Array = param1.getClassStyleDeclarations();
         var _loc7_:int = _loc6_.length;
         if(_loc2_ is StyleProxy)
         {
            if(_loc7_ == 0)
            {
               _loc4_ = addProperties(_loc4_,_loc2_,false);
            }
            _loc3_ = StyleProxy(_loc2_).source as DisplayObject;
         }
         var _loc8_:int = 0;
         while(_loc8_ < _loc7_)
         {
            _loc9_ = _loc6_[_loc8_];
            _loc5_ = _loc9_.addStyleToProtoChain(_loc5_,_loc3_);
            _loc5_ = addProperties(_loc5_,_loc2_,true);
            _loc4_ = _loc9_.addStyleToProtoChain(_loc4_,_loc3_);
            _loc4_ = addProperties(_loc4_,_loc2_,false);
            if(_loc9_.effects)
            {
               param1.registerEffects(_loc9_.effects);
            }
            _loc8_++;
         }
         param1.inheritingStyles = !!param1.styleDeclaration?param1.styleDeclaration.addStyleToProtoChain(_loc5_,_loc3_):_loc5_;
         param1.nonInheritingStyles = !!param1.styleDeclaration?param1.styleDeclaration.addStyleToProtoChain(_loc4_,_loc3_):_loc4_;
      }
      
      private static function addProperties(param1:Object, param2:IStyleClient, param3:Boolean) : Object
      {
         var _loc11_:CSSStyleDeclaration = null;
         var _loc12_:CSSStyleDeclaration = null;
         var _loc4_:Object = param2 is StyleProxy && !param3?StyleProxy(param2).filterMap:null;
         var _loc5_:IStyleClient = param2;
         while(_loc5_ is StyleProxy)
         {
            _loc5_ = StyleProxy(_loc5_).source;
         }
         var _loc6_:DisplayObject = _loc5_ as DisplayObject;
         var _loc7_:Array = param2.getClassStyleDeclarations();
         var _loc8_:int = _loc7_.length;
         var _loc9_:int = 0;
         while(_loc9_ < _loc8_)
         {
            _loc11_ = _loc7_[_loc9_];
            param1 = _loc11_.addStyleToProtoChain(param1,_loc6_,_loc4_);
            if(_loc11_.effects)
            {
               param2.registerEffects(_loc11_.effects);
            }
            _loc9_++;
         }
         var _loc10_:Object = param2.styleName;
         if(_loc10_)
         {
            if(typeof _loc10_ == "object")
            {
               if(_loc10_ is CSSStyleDeclaration)
               {
                  _loc12_ = CSSStyleDeclaration(_loc10_);
               }
               else
               {
                  param1 = addProperties(param1,IStyleClient(_loc10_),param3);
               }
            }
            else
            {
               _loc12_ = StyleManager.getStyleDeclaration("." + _loc10_);
            }
            if(_loc12_)
            {
               param1 = _loc12_.addStyleToProtoChain(param1,_loc6_,_loc4_);
               if(_loc12_.effects)
               {
                  param2.registerEffects(_loc12_.effects);
               }
            }
         }
         if(param2.styleDeclaration)
         {
            param1 = param2.styleDeclaration.addStyleToProtoChain(param1,_loc6_,_loc4_);
         }
         return param1;
      }
      
      public static function initTextField(param1:IUITextField) : void
      {
         var _loc3_:CSSStyleDeclaration = null;
         var _loc2_:Object = param1.styleName;
         if(_loc2_)
         {
            if(typeof _loc2_ == "object")
            {
               if(_loc2_ is CSSStyleDeclaration)
               {
                  _loc3_ = CSSStyleDeclaration(_loc2_);
               }
               else
               {
                  if(_loc2_ is StyleProxy)
                  {
                     param1.inheritingStyles = IStyleClient(_loc2_).inheritingStyles;
                     param1.nonInheritingStyles = addProperties(StyleManager.stylesRoot,IStyleClient(_loc2_),false);
                     return;
                  }
                  param1.inheritingStyles = IStyleClient(_loc2_).inheritingStyles;
                  param1.nonInheritingStyles = IStyleClient(_loc2_).nonInheritingStyles;
                  return;
               }
            }
            else
            {
               _loc3_ = StyleManager.getStyleDeclaration("." + _loc2_);
            }
         }
         var _loc4_:Object = IStyleClient(param1.parent).inheritingStyles;
         var _loc5_:Object = StyleManager.stylesRoot;
         if(!_loc4_)
         {
            _loc4_ = StyleManager.stylesRoot;
         }
         if(_loc3_)
         {
            _loc4_ = _loc3_.addStyleToProtoChain(_loc4_,DisplayObject(param1));
            _loc5_ = _loc3_.addStyleToProtoChain(_loc5_,DisplayObject(param1));
         }
         param1.inheritingStyles = _loc4_;
         param1.nonInheritingStyles = _loc5_;
      }
   }
}
