package mx.skins.halo
{
   import flash.display.DisplayObjectContainer;
   import flash.display.GradientType;
   import flash.utils.describeType;
   import flash.utils.getQualifiedClassName;
   import mx.core.EdgeMetrics;
   import mx.core.UIComponent;
   import mx.core.mx_internal;
   import mx.skins.Border;
   import mx.styles.IStyleClient;
   import mx.styles.StyleManager;
   import mx.utils.ColorUtil;
   
   use namespace mx_internal;
   
   public class TabSkin extends Border
   {
      
      private static var cache:Object = {};
      
      private static var tabnavs:Object = {};
      
      mx_internal static const VERSION:String = "3.6.0.21751";
       
      
      private var _borderMetrics:EdgeMetrics;
      
      public function TabSkin()
      {
         _borderMetrics = new EdgeMetrics(1,1,1,1);
         super();
      }
      
      private static function calcDerivedStyles(param1:uint, param2:uint, param3:uint, param4:uint, param5:uint, param6:uint) : Object
      {
         var _loc8_:Object = null;
         var _loc7_:String = HaloColors.getCacheKey(param1,param2,param3,param4,param5,param6);
         if(!cache[_loc7_])
         {
            _loc8_ = cache[_loc7_] = {};
            HaloColors.addHaloColors(_loc8_,param1,param5,param6);
            _loc8_.borderColorDrk1 = ColorUtil.adjustBrightness2(param2,10);
            _loc8_.falseFillColorBright1 = ColorUtil.adjustBrightness(param3,15);
            _loc8_.falseFillColorBright2 = ColorUtil.adjustBrightness(param4,15);
         }
         return cache[_loc7_];
      }
      
      private static function isTabNavigator(param1:Object) : Boolean
      {
         var s:String = null;
         var x:XML = null;
         var parent:Object = param1;
         s = getQualifiedClassName(parent);
         if(tabnavs[s] == 1)
         {
            return true;
         }
         if(tabnavs[s] == 0)
         {
            return false;
         }
         if(s == "mx.containers::TabNavigator")
         {
            tabnavs[s] == 1;
            return true;
         }
         x = describeType(parent);
         var xmllist:XMLList = x.extendsClass.(@type == "mx.containers::TabNavigator");
         if(xmllist.length() == 0)
         {
            tabnavs[s] = 0;
            return false;
         }
         tabnavs[s] = 1;
         return true;
      }
      
      override public function get measuredWidth() : Number
      {
         return UIComponent.DEFAULT_MEASURED_MIN_WIDTH;
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         var _loc19_:Array = null;
         var _loc20_:Array = null;
         var _loc21_:Array = null;
         var _loc22_:Array = null;
         var _loc23_:Array = null;
         var _loc24_:Array = null;
         var _loc25_:DisplayObjectContainer = null;
         super.updateDisplayList(param1,param2);
         var _loc3_:Number = getStyle("backgroundAlpha");
         var _loc4_:Number = getStyle("backgroundColor");
         var _loc5_:uint = getStyle("borderColor");
         var _loc6_:Number = getStyle("cornerRadius");
         var _loc7_:Array = getStyle("fillAlphas");
         var _loc8_:Array = getStyle("fillColors");
         StyleManager.getColorNames(_loc8_);
         var _loc9_:Array = getStyle("highlightAlphas");
         var _loc10_:uint = getStyle("themeColor");
         var _loc11_:Array = [];
         _loc11_[0] = ColorUtil.adjustBrightness2(_loc8_[0],-5);
         _loc11_[1] = ColorUtil.adjustBrightness2(_loc8_[1],-5);
         var _loc12_:Object = calcDerivedStyles(_loc10_,_loc5_,_loc11_[0],_loc11_[1],_loc8_[0],_loc8_[1]);
         var _loc13_:Boolean = parent != null && parent.parent != null && parent.parent.parent != null && isTabNavigator(parent.parent.parent);
         var _loc14_:Number = 1;
         if(_loc13_)
         {
            _loc14_ = Object(parent.parent.parent).borderMetrics.top;
         }
         var _loc15_:Boolean = _loc13_ && IStyleClient(parent.parent.parent).getStyle("borderStyle") != "none" && _loc14_ >= 0;
         var _loc16_:Number = Math.max(_loc6_ - 2,0);
         var _loc17_:Object = {
            "tl":_loc6_,
            "tr":_loc6_,
            "bl":0,
            "br":0
         };
         var _loc18_:Object = {
            "tl":_loc16_,
            "tr":_loc16_,
            "bl":0,
            "br":0
         };
         graphics.clear();
         switch(name)
         {
            case "upSkin":
               _loc19_ = [_loc11_[0],_loc11_[1]];
               _loc20_ = [_loc7_[0],_loc7_[1]];
               drawRoundRect(0,0,param1,param2 - 1,_loc17_,[_loc12_.borderColorDrk1,_loc5_],1,verticalGradientMatrix(0,0,param1,param2),GradientType.LINEAR,null,{
                  "x":1,
                  "y":1,
                  "w":param1 - 2,
                  "h":param2 - 2,
                  "r":_loc18_
               });
               drawRoundRect(1,1,param1 - 2,param2 - 2,_loc18_,_loc19_,_loc20_,verticalGradientMatrix(0,2,param1 - 2,param2 - 6));
               drawRoundRect(1,1,param1 - 2,(param2 - 2) / 2,_loc18_,[16777215,16777215],_loc9_,verticalGradientMatrix(1,1,param1 - 2,(param2 - 2) / 2));
               if(_loc15_)
               {
                  drawRoundRect(0,param2 - _loc14_,param1,_loc14_,0,_loc5_,_loc7_[1]);
               }
               drawRoundRect(0,param2 - 2,param1,1,0,0,0.09);
               drawRoundRect(0,param2 - 3,param1,1,0,0,0.03);
               break;
            case "overSkin":
               if(_loc8_.length > 2)
               {
                  _loc21_ = [_loc8_[2],_loc8_[3]];
               }
               else
               {
                  _loc21_ = [_loc8_[0],_loc8_[1]];
               }
               if(_loc7_.length > 2)
               {
                  _loc22_ = [_loc7_[2],_loc7_[3]];
               }
               else
               {
                  _loc22_ = [_loc7_[0],_loc7_[1]];
               }
               drawRoundRect(0,0,param1,param2 - 1,_loc17_,[_loc10_,_loc12_.themeColDrk2],1,verticalGradientMatrix(0,0,param1,param2 - 6),GradientType.LINEAR,null,{
                  "x":1,
                  "y":1,
                  "w":param1 - 2,
                  "h":param2 - 2,
                  "r":_loc18_
               });
               drawRoundRect(1,1,param1 - 2,param2 - 2,_loc18_,[_loc12_.falseFillColorBright1,_loc12_.falseFillColorBright2],_loc22_,verticalGradientMatrix(2,2,param1 - 2,param2 - 2));
               drawRoundRect(1,1,param1 - 2,(param2 - 2) / 2,_loc18_,[16777215,16777215],_loc9_,verticalGradientMatrix(1,1,param1 - 2,(param2 - 2) / 2));
               if(_loc15_)
               {
                  drawRoundRect(0,param2 - _loc14_,param1,_loc14_,0,_loc5_,_loc7_[1]);
               }
               drawRoundRect(0,param2 - 2,param1,1,0,0,0.09);
               drawRoundRect(0,param2 - 3,param1,1,0,0,0.03);
               break;
            case "disabledSkin":
               _loc23_ = [_loc8_[0],_loc8_[1]];
               _loc24_ = [Math.max(0,_loc7_[0] - 0.15),Math.max(0,_loc7_[1] - 0.15)];
               drawRoundRect(0,0,param1,param2 - 1,_loc17_,[_loc12_.borderColorDrk1,_loc5_],0.5,verticalGradientMatrix(0,0,param1,param2 - 6));
               drawRoundRect(1,1,param1 - 2,param2 - 2,_loc18_,_loc23_,_loc24_,verticalGradientMatrix(0,2,param1 - 2,param2 - 2));
               if(_loc15_)
               {
                  drawRoundRect(0,param2 - _loc14_,param1,_loc14_,0,_loc5_,_loc7_[1]);
               }
               drawRoundRect(0,param2 - 2,param1,1,0,0,0.09);
               drawRoundRect(0,param2 - 3,param1,1,0,0,0.03);
               break;
            case "downSkin":
            case "selectedUpSkin":
            case "selectedDownSkin":
            case "selectedOverSkin":
            case "selectedDisabledSkin":
               if(isNaN(_loc4_))
               {
                  _loc25_ = parent;
                  while(_loc25_)
                  {
                     if(_loc25_ is IStyleClient)
                     {
                        _loc4_ = IStyleClient(_loc25_).getStyle("backgroundColor");
                     }
                     if(!isNaN(_loc4_))
                     {
                        break;
                     }
                     _loc25_ = _loc25_.parent;
                  }
                  if(isNaN(_loc4_))
                  {
                     _loc4_ = 16777215;
                  }
               }
               drawRoundRect(0,0,param1,param2 - 1,_loc17_,[_loc12_.borderColorDrk1,_loc5_],1,verticalGradientMatrix(0,0,param1,param2 - 2),GradientType.LINEAR,null,{
                  "x":1,
                  "y":1,
                  "w":param1 - 2,
                  "h":param2 - 2,
                  "r":_loc18_
               });
               drawRoundRect(1,1,param1 - 2,param2 - 2,_loc18_,_loc4_,_loc3_);
               if(_loc15_)
               {
                  drawRoundRect(1,param2 - _loc14_,param1 - 2,_loc14_,0,_loc4_,_loc3_);
               }
         }
      }
      
      override public function get measuredHeight() : Number
      {
         return UIComponent.DEFAULT_MEASURED_MIN_HEIGHT;
      }
      
      override public function get borderMetrics() : EdgeMetrics
      {
         return _borderMetrics;
      }
   }
}
