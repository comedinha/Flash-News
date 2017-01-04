package mx.skins.halo
{
   import flash.display.DisplayObject;
   import flash.display.GradientType;
   import flash.filters.BlurFilter;
   import flash.utils.describeType;
   import flash.utils.getQualifiedClassName;
   import mx.core.ApplicationGlobals;
   import mx.core.mx_internal;
   import mx.skins.Border;
   import mx.styles.IStyleClient;
   import mx.utils.ColorUtil;
   
   use namespace mx_internal;
   
   public class ActivatorSkin extends Border
   {
      
      private static var cache:Object = {};
      
      private static var acbs:Object = {};
      
      mx_internal static const VERSION:String = "3.6.0.21751";
       
      
      public function ActivatorSkin()
      {
         super();
      }
      
      private static function calcDerivedStyles(param1:uint, param2:uint, param3:uint) : Object
      {
         var _loc5_:Object = null;
         var _loc4_:String = HaloColors.getCacheKey(param1,param2,param3);
         if(!cache[_loc4_])
         {
            _loc5_ = cache[_loc4_] = {};
            HaloColors.addHaloColors(_loc5_,param1,param2,param3);
         }
         return cache[_loc4_];
      }
      
      private static function isApplicationControlBar(param1:Object) : Boolean
      {
         var s:String = null;
         var x:XML = null;
         var parent:Object = param1;
         s = getQualifiedClassName(parent);
         if(acbs[s] == 1)
         {
            return true;
         }
         if(acbs[s] == 0)
         {
            return false;
         }
         if(s == "mx.containers::ApplicationControlBar")
         {
            acbs[s] == 1;
            return true;
         }
         x = describeType(parent);
         var xmllist:XMLList = x.extendsClass.(@type == "mx.containers::ApplicationControlBar");
         if(xmllist.length() == 0)
         {
            acbs[s] = 0;
            return false;
         }
         acbs[s] = 1;
         return true;
      }
      
      private function drawHaloRect(param1:Number, param2:Number) : void
      {
         var _loc9_:Array = null;
         var _loc10_:Array = null;
         var _loc3_:Array = getStyle("fillAlphas");
         var _loc4_:Array = getStyle("fillColors");
         var _loc5_:Array = getStyle("highlightAlphas");
         var _loc6_:uint = getStyle("themeColor");
         var _loc7_:Number = ColorUtil.adjustBrightness2(_loc6_,-25);
         var _loc8_:Object = calcDerivedStyles(_loc6_,_loc4_[0],_loc4_[1]);
         graphics.clear();
         switch(name)
         {
            case "itemUpSkin":
               drawRoundRect(x,y,param1,param2,0,16777215,0);
               break;
            case "itemDownSkin":
               drawRoundRect(x + 1,y + 1,param1 - 2,param2 - 2,0,[_loc8_.fillColorPress1,_loc8_.fillColorPress2],1,verticalGradientMatrix(0,0,param1,param2));
               drawRoundRect(x + 1,y + 1,param1 - 2,param2 - 2 / 2,0,[16777215,16777215],_loc5_,verticalGradientMatrix(0,0,param1 - 2,param2 - 2));
               break;
            case "itemOverSkin":
               if(_loc4_.length > 2)
               {
                  _loc9_ = [_loc4_[2],_loc4_[3]];
               }
               else
               {
                  _loc9_ = [_loc4_[0],_loc4_[1]];
               }
               if(_loc3_.length > 2)
               {
                  _loc10_ = [_loc3_[2],_loc3_[3]];
               }
               else
               {
                  _loc10_ = [_loc3_[0],_loc3_[1]];
               }
               drawRoundRect(x + 1,y + 1,param1 - 2,param2 - 2,0,_loc9_,_loc10_,verticalGradientMatrix(0,0,param1,param2));
               drawRoundRect(x + 1,y + 1,param1 - 2,param2 - 2 / 2,0,[16777215,16777215],_loc5_,verticalGradientMatrix(0,0,param1 - 2,param2 - 2));
         }
         filters = [new BlurFilter(2,0)];
      }
      
      private function drawTranslucentHaloRect(param1:Number, param2:Number) : void
      {
         var _loc9_:Object = null;
         var _loc3_:IStyleClient = parent as IStyleClient;
         while(_loc3_ && !isApplicationControlBar(_loc3_))
         {
            _loc3_ = DisplayObject(_loc3_).parent as IStyleClient;
         }
         if(!_loc3_)
         {
            return;
         }
         var _loc4_:Object = _loc3_.getStyle("fillColor");
         var _loc5_:Object = _loc3_.getStyle("backgroundColor");
         var _loc6_:Number = _loc3_.getStyle("backgroundAlpha");
         var _loc7_:Number = _loc3_.getStyle("cornerRadius");
         var _loc8_:Boolean = _loc3_.getStyle("docked");
         if(_loc5_ == "")
         {
            _loc5_ = null;
         }
         if(_loc8_ && !_loc5_)
         {
            _loc9_ = ApplicationGlobals.application.getStyle("backgroundColor");
            _loc5_ = !!_loc9_?_loc9_:9542041;
         }
         graphics.clear();
         switch(name)
         {
            case "itemUpSkin":
               drawRoundRect(1,1,param1 - 2,param2 - 1,0,0,0);
               filters = [];
               break;
            case "itemOverSkin":
               if(_loc5_)
               {
                  drawRoundRect(1,1,param1 - 2,param2 - 1,0,_loc5_,_loc6_);
               }
               drawRoundRect(1,1,param1 - 2,param2 - 1,0,[_loc4_,_loc4_,_loc4_,_loc4_,_loc4_],[1,0.75,0.6,0.7,0.9],verticalGradientMatrix(0,0,param1,param2),GradientType.LINEAR,[0,95,127,191,255]);
               filters = [new BlurFilter(0,4)];
               break;
            case "itemDownSkin":
               if(_loc5_)
               {
                  drawRoundRect(1,1,param1 - 2,param2 - 1,0,_loc5_,_loc6_);
               }
               drawRoundRect(1,1,param1 - 2,param2 - 1,0,[_loc4_,_loc4_,_loc4_,_loc4_,_loc4_],[0.85,0.6,0.45,0.55,0.75],verticalGradientMatrix(0,0,param1,param2),GradientType.LINEAR,[0,95,127,191,255]);
               filters = [new BlurFilter(0,4)];
         }
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         super.updateDisplayList(param1,param2);
         if(!getStyle("translucent"))
         {
            drawHaloRect(param1,param2);
         }
         else
         {
            drawTranslucentHaloRect(param1,param2);
         }
      }
   }
}
