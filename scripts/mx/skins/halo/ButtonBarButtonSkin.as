package mx.skins.halo
{
   import flash.display.GradientType;
   import flash.utils.describeType;
   import flash.utils.getQualifiedClassName;
   import mx.containers.BoxDirection;
   import mx.core.IButton;
   import mx.core.UIComponent;
   import mx.core.mx_internal;
   import mx.skins.Border;
   import mx.styles.StyleManager;
   import mx.utils.ColorUtil;
   
   use namespace mx_internal;
   
   public class ButtonBarButtonSkin extends Border
   {
      
      private static var bbars:Object = {};
      
      private static var cache:Object = {};
      
      mx_internal static const VERSION:String = "3.6.0.21751";
       
      
      public function ButtonBarButtonSkin()
      {
         super();
      }
      
      private static function isButtonBar(param1:Object) : Boolean
      {
         var s:String = null;
         var x:XML = null;
         var parent:Object = param1;
         s = getQualifiedClassName(parent);
         if(bbars[s] == 1)
         {
            return true;
         }
         if(bbars[s] == 0)
         {
            return false;
         }
         if(s == "mx.controls::ButtonBar")
         {
            bbars[s] == 1;
            return true;
         }
         x = describeType(parent);
         var xmllist:XMLList = x.extendsClass.(@type == "mx.controls::ButtonBar");
         if(xmllist.length() == 0)
         {
            bbars[s] = 0;
            return false;
         }
         bbars[s] = 1;
         return true;
      }
      
      private static function calcDerivedStyles(param1:uint, param2:uint, param3:uint) : Object
      {
         var _loc5_:Object = null;
         var _loc4_:String = HaloColors.getCacheKey(param1,param2,param3);
         if(!cache[_loc4_])
         {
            _loc5_ = cache[_loc4_] = {};
            HaloColors.addHaloColors(_loc5_,param1,param2,param3);
            _loc5_.innerEdgeColor1 = ColorUtil.adjustBrightness2(param2,-10);
            _loc5_.innerEdgeColor2 = ColorUtil.adjustBrightness2(param3,-25);
         }
         return cache[_loc4_];
      }
      
      override public function get measuredWidth() : Number
      {
         return UIComponent.DEFAULT_MEASURED_MIN_WIDTH;
      }
      
      override public function get measuredHeight() : Number
      {
         return UIComponent.DEFAULT_MEASURED_MIN_HEIGHT;
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         var _loc13_:Number = NaN;
         var _loc22_:int = 0;
         var _loc23_:Array = null;
         var _loc24_:Array = null;
         var _loc25_:Array = null;
         var _loc26_:Array = null;
         var _loc27_:Array = null;
         var _loc28_:Array = null;
         super.updateDisplayList(param1,param2);
         var _loc3_:uint = getStyle("borderColor");
         var _loc4_:Number = getStyle("cornerRadius");
         var _loc5_:Array = getStyle("fillAlphas");
         var _loc6_:Array = getStyle("fillColors");
         StyleManager.getColorNames(_loc6_);
         var _loc7_:Array = getStyle("highlightAlphas");
         var _loc8_:uint = getStyle("themeColor");
         var _loc9_:Object = calcDerivedStyles(_loc8_,_loc6_[0],_loc6_[1]);
         var _loc10_:Number = ColorUtil.adjustBrightness2(_loc3_,-50);
         var _loc11_:Number = ColorUtil.adjustBrightness2(_loc8_,-25);
         var _loc12_:Boolean = false;
         if(parent is IButton)
         {
            _loc12_ = (parent as IButton).emphasized;
         }
         var _loc14_:Object = parent && parent.parent && isButtonBar(parent.parent)?parent.parent:null;
         var _loc15_:Boolean = true;
         var _loc16_:int = 0;
         if(_loc14_)
         {
            if(_loc14_.direction == BoxDirection.VERTICAL)
            {
               _loc15_ = false;
            }
            _loc22_ = _loc14_.getChildIndex(parent);
            _loc16_ = _loc22_ == 0?-1:_loc22_ == _loc14_.numChildren - 1?1:0;
         }
         var _loc17_:Object = getCornerRadius(_loc16_,_loc15_,_loc4_);
         var _loc18_:Object = getCornerRadius(_loc16_,_loc15_,_loc4_);
         var _loc19_:Object = getCornerRadius(_loc16_,_loc15_,_loc4_ - 1);
         var _loc20_:Object = getCornerRadius(_loc16_,_loc15_,_loc4_ - 2);
         var _loc21_:Object = getCornerRadius(_loc16_,_loc15_,_loc4_ - 3);
         graphics.clear();
         switch(name)
         {
            case "selectedUpSkin":
            case "selectedOverSkin":
               drawRoundRect(0,0,param1,param2,_loc18_,[_loc8_,_loc11_],1,verticalGradientMatrix(0,0,param1,param2),GradientType.LINEAR,null,{
                  "x":2,
                  "y":2,
                  "w":param1 - 4,
                  "h":param2 - 4,
                  "r":_loc20_
               });
               drawRoundRect(1,1,param1 - 2,param2 - 2,_loc19_,[_loc6_[1],_loc6_[1]],[_loc5_[0],_loc5_[1]],verticalGradientMatrix(0,0,param1 - 2,param2 - 2));
               break;
            case "upSkin":
               _loc23_ = [_loc6_[0],_loc6_[1]];
               _loc24_ = [_loc5_[0],_loc5_[1]];
               if(_loc12_)
               {
                  drawRoundRect(0,0,param1,param2,_loc18_,[_loc8_,_loc11_],1,verticalGradientMatrix(0,0,param1,param2),GradientType.LINEAR,null,{
                     "x":2,
                     "y":2,
                     "w":param1 - 4,
                     "h":param2 - 4,
                     "r":_loc20_
                  });
                  drawRoundRect(2,2,param1 - 4,param2 - 4,_loc20_,_loc23_,_loc24_,verticalGradientMatrix(1,1,param1 - 2,param2 - 2));
                  if(!(_loc17_ is Number))
                  {
                     _loc17_.bl = _loc17_.br = 0;
                  }
                  drawRoundRect(2,2,param1 - 4,(param2 - 4) / 2,_loc17_,[16777215,16777215],_loc7_,verticalGradientMatrix(2,2,param1 - 2,(param2 - 4) / 2));
               }
               else
               {
                  drawRoundRect(0,0,param1,param2,_loc18_,[_loc3_,_loc10_],1,verticalGradientMatrix(0,0,param1,param2),GradientType.LINEAR,null,{
                     "x":1,
                     "y":1,
                     "w":param1 - 2,
                     "h":param2 - 2,
                     "r":_loc19_
                  });
                  drawRoundRect(1,1,param1 - 2,param2 - 2,_loc19_,_loc23_,_loc24_,verticalGradientMatrix(1,1,param1 - 2,param2 - 2));
                  if(!(_loc17_ is Number))
                  {
                     _loc17_.bl = _loc17_.br = 0;
                  }
                  drawRoundRect(1,1,param1 - 2,(param2 - 2) / 2,_loc17_,[16777215,16777215],_loc7_,verticalGradientMatrix(1,1,param1 - 2,(param2 - 2) / 2));
               }
               break;
            case "overSkin":
               if(_loc6_.length > 2)
               {
                  _loc25_ = [_loc6_[2],_loc6_[3]];
               }
               else
               {
                  _loc25_ = [_loc6_[0],_loc6_[1]];
               }
               if(_loc5_.length > 2)
               {
                  _loc26_ = [_loc5_[2],_loc5_[3]];
               }
               else
               {
                  _loc26_ = [_loc5_[0],_loc5_[1]];
               }
               drawRoundRect(0,0,param1,param2,_loc18_,[_loc8_,_loc9_.themeColDrk1],1,verticalGradientMatrix(0,0,param1,param2),GradientType.LINEAR,null,{
                  "x":1,
                  "y":1,
                  "w":param1 - 2,
                  "h":param2 - 2,
                  "r":_loc19_
               });
               drawRoundRect(1,1,param1 - 2,param2 - 2,_loc19_,_loc25_,_loc26_,verticalGradientMatrix(0,0,param1 - 2,param2 - 2));
               if(!(_loc17_ is Number))
               {
                  _loc17_.bl = _loc17_.br = 0;
               }
               drawRoundRect(1,1,param1 - 2,(param2 - 2) / 2,_loc17_,[16777215,16777215],_loc7_,verticalGradientMatrix(1,1,param1 - 2,(param2 - 2) / 2));
               break;
            case "downSkin":
            case "selectedDownSkin":
               drawRoundRect(0,0,param1,param2,_loc18_,[_loc8_,_loc9_.themeColDrk1],1,verticalGradientMatrix(0,0,param1,param2));
               drawRoundRect(1,1,param1 - 2,param2 - 2,_loc19_,[_loc9_.fillColorPress1,_loc9_.fillColorPress2],1,verticalGradientMatrix(0,0,param1 - 2,param2 - 2));
               if(!(_loc17_ is Number))
               {
                  _loc17_.bl = _loc17_.br = 0;
               }
               drawRoundRect(1,1,param1 - 2,(param2 - 2) / 2,_loc17_,[16777215,16777215],_loc7_,verticalGradientMatrix(1,1,param1 - 2,(param2 - 2) / 2));
               break;
            case "disabledSkin":
            case "selectedDisabledSkin":
               _loc27_ = [_loc6_[0],_loc6_[1]];
               _loc28_ = [Math.max(0,_loc5_[0] - 0.15),Math.max(0,_loc5_[1] - 0.15)];
               drawRoundRect(0,0,param1,param2,_loc18_,[_loc3_,_loc10_],0.5,verticalGradientMatrix(0,0,param1,param2),GradientType.LINEAR,null,{
                  "x":1,
                  "y":1,
                  "w":param1 - 2,
                  "h":param2 - 2,
                  "r":_loc19_
               });
               drawRoundRect(1,1,param1 - 2,param2 - 2,_loc19_,_loc27_,_loc28_,verticalGradientMatrix(0,0,param1 - 2,param2 - 2));
         }
      }
      
      private function getCornerRadius(param1:int, param2:Boolean, param3:Number) : Object
      {
         if(param1 == 0)
         {
            return 0;
         }
         param3 = Math.max(0,param3);
         if(param2)
         {
            if(param1 == -1)
            {
               return {
                  "tl":param3,
                  "tr":0,
                  "bl":param3,
                  "br":0
               };
            }
            return {
               "tl":0,
               "tr":param3,
               "bl":0,
               "br":param3
            };
         }
         if(param1 == -1)
         {
            return {
               "tl":param3,
               "tr":param3,
               "bl":0,
               "br":0
            };
         }
         return {
            "tl":0,
            "tr":0,
            "bl":param3,
            "br":param3
         };
      }
   }
}
