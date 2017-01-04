package mx.skins.halo
{
   import flash.display.GradientType;
   import flash.display.Graphics;
   import mx.core.mx_internal;
   import mx.skins.Border;
   import mx.styles.StyleManager;
   import mx.utils.ColorUtil;
   
   use namespace mx_internal;
   
   public class CheckBoxIcon extends Border
   {
      
      mx_internal static const VERSION:String = "3.6.0.21751";
      
      private static var cache:Object = {};
       
      
      public function CheckBoxIcon()
      {
         super();
      }
      
      private static function calcDerivedStyles(param1:uint, param2:uint, param3:uint, param4:uint) : Object
      {
         var _loc6_:Object = null;
         var _loc5_:String = HaloColors.getCacheKey(param1,param2,param3,param4);
         if(!cache[_loc5_])
         {
            _loc6_ = cache[_loc5_] = {};
            HaloColors.addHaloColors(_loc6_,param1,param3,param4);
            _loc6_.borderColorDrk1 = ColorUtil.adjustBrightness2(param2,-50);
         }
         return cache[_loc5_];
      }
      
      override public function get measuredWidth() : Number
      {
         return 14;
      }
      
      override public function get measuredHeight() : Number
      {
         return 14;
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         var _loc13_:Array = null;
         var _loc14_:Array = null;
         var _loc15_:Array = null;
         var _loc16_:Array = null;
         var _loc17_:Array = null;
         var _loc18_:Array = null;
         super.updateDisplayList(param1,param2);
         var _loc3_:uint = getStyle("borderColor");
         var _loc4_:uint = getStyle("iconColor");
         var _loc5_:Array = getStyle("fillAlphas");
         var _loc6_:Array = getStyle("fillColors");
         StyleManager.getColorNames(_loc6_);
         var _loc7_:Array = getStyle("highlightAlphas");
         var _loc8_:uint = getStyle("themeColor");
         var _loc9_:Object = calcDerivedStyles(_loc8_,_loc3_,_loc6_[0],_loc6_[1]);
         var _loc10_:Number = ColorUtil.adjustBrightness2(_loc3_,-50);
         var _loc11_:Number = ColorUtil.adjustBrightness2(_loc8_,-25);
         var _loc12_:Boolean = false;
         var _loc19_:Graphics = graphics;
         _loc19_.clear();
         switch(name)
         {
            case "upIcon":
               _loc13_ = [_loc6_[0],_loc6_[1]];
               _loc14_ = [_loc5_[0],_loc5_[1]];
               drawRoundRect(0,0,param1,param2,0,[_loc3_,_loc10_],1,verticalGradientMatrix(0,0,param1,param2),GradientType.LINEAR,null,{
                  "x":1,
                  "y":1,
                  "w":param1 - 2,
                  "h":param2 - 2,
                  "r":0
               });
               drawRoundRect(1,1,param1 - 2,param2 - 2,0,_loc13_,_loc14_,verticalGradientMatrix(1,1,param1 - 2,param2 - 2));
               drawRoundRect(1,1,param1 - 2,(param2 - 2) / 2,0,[16777215,16777215],_loc7_,verticalGradientMatrix(1,1,param1 - 2,(param2 - 2) / 2));
               break;
            case "overIcon":
               if(_loc6_.length > 2)
               {
                  _loc15_ = [_loc6_[2],_loc6_[3]];
               }
               else
               {
                  _loc15_ = [_loc6_[0],_loc6_[1]];
               }
               if(_loc5_.length > 2)
               {
                  _loc16_ = [_loc5_[2],_loc5_[3]];
               }
               else
               {
                  _loc16_ = [_loc5_[0],_loc5_[1]];
               }
               drawRoundRect(0,0,param1,param2,0,[_loc8_,_loc11_],1,verticalGradientMatrix(0,0,param1,param2),GradientType.LINEAR,null,{
                  "x":1,
                  "y":1,
                  "w":param1 - 2,
                  "h":param2 - 2,
                  "r":0
               });
               drawRoundRect(1,1,param1 - 2,param2 - 2,0,_loc15_,_loc16_,verticalGradientMatrix(1,1,param1 - 2,param2 - 2));
               drawRoundRect(1,1,param1 - 2,(param2 - 2) / 2,0,[16777215,16777215],_loc7_,verticalGradientMatrix(1,1,param1 - 2,(param2 - 2) / 2));
               break;
            case "downIcon":
               drawRoundRect(0,0,param1,param2,0,[_loc8_,_loc11_],1,verticalGradientMatrix(0,0,param1,param2));
               drawRoundRect(1,1,param1 - 2,param2 - 2,0,[_loc9_.fillColorPress1,_loc9_.fillColorPress2],1,verticalGradientMatrix(1,1,param1 - 2,param2 - 2));
               drawRoundRect(1,1,param1 - 2,(param2 - 2) / 2,0,[16777215,16777215],_loc7_,verticalGradientMatrix(1,1,param1 - 2,(param2 - 2) / 2));
               break;
            case "disabledIcon":
               _loc17_ = [_loc6_[0],_loc6_[1]];
               _loc18_ = [Math.max(0,_loc5_[0] - 0.15),Math.max(0,_loc5_[1] - 0.15)];
               drawRoundRect(0,0,param1,param2,0,[_loc3_,_loc10_],0.5,verticalGradientMatrix(0,0,param1,param2),GradientType.LINEAR,null,{
                  "x":1,
                  "y":1,
                  "w":param1 - 2,
                  "h":param2 - 2,
                  "r":0
               });
               drawRoundRect(1,1,param1 - 2,param2 - 2,0,_loc17_,_loc18_,verticalGradientMatrix(1,1,param1 - 2,param2 - 2));
               break;
            case "selectedUpIcon":
               _loc12_ = true;
               _loc13_ = [_loc6_[0],_loc6_[1]];
               _loc14_ = [_loc5_[0],_loc5_[1]];
               drawRoundRect(0,0,param1,param2,0,[_loc3_,_loc10_],1,verticalGradientMatrix(0,0,param1,param2),GradientType.LINEAR,null,{
                  "x":1,
                  "y":1,
                  "w":param1 - 2,
                  "h":param2 - 2,
                  "r":0
               });
               drawRoundRect(1,1,param1 - 2,param2 - 2,0,_loc13_,_loc14_,verticalGradientMatrix(1,1,param1 - 2,param2 - 2));
               drawRoundRect(1,1,param1 - 2,(param2 - 2) / 2,0,[16777215,16777215],_loc7_,verticalGradientMatrix(1,1,param1 - 2,(param2 - 2) / 2));
               break;
            case "selectedOverIcon":
               _loc12_ = true;
               if(_loc6_.length > 2)
               {
                  _loc15_ = [_loc6_[2],_loc6_[3]];
               }
               else
               {
                  _loc15_ = [_loc6_[0],_loc6_[1]];
               }
               if(_loc5_.length > 2)
               {
                  _loc16_ = [_loc5_[2],_loc5_[3]];
               }
               else
               {
                  _loc16_ = [_loc5_[0],_loc5_[1]];
               }
               drawRoundRect(0,0,param1,param2,0,[_loc8_,_loc11_],1,verticalGradientMatrix(0,0,param1,param2),GradientType.LINEAR,null,{
                  "x":1,
                  "y":1,
                  "w":param1 - 2,
                  "h":param2 - 2,
                  "r":0
               });
               drawRoundRect(1,1,param1 - 2,param2 - 2,0,_loc15_,_loc16_,verticalGradientMatrix(1,1,param1 - 2,param2 - 2));
               drawRoundRect(1,1,param1 - 2,(param2 - 2) / 2,0,[16777215,16777215],_loc7_,verticalGradientMatrix(1,1,param1 - 2,(param2 - 2) / 2));
               break;
            case "selectedDownIcon":
               _loc12_ = true;
               drawRoundRect(0,0,param1,param2,0,[_loc8_,_loc11_],1,verticalGradientMatrix(0,0,param1,param2));
               drawRoundRect(1,1,param1 - 2,param2 - 2,0,[_loc9_.fillColorPress1,_loc9_.fillColorPress2],1,verticalGradientMatrix(1,1,param1 - 2,param2 - 2));
               drawRoundRect(1,1,param1 - 2,(param2 - 2) / 2,0,[16777215,16777215],_loc7_,verticalGradientMatrix(1,1,param1 - 2,(param2 - 2) / 2));
               break;
            case "selectedDisabledIcon":
               _loc12_ = true;
               _loc4_ = getStyle("disabledIconColor");
               _loc17_ = [_loc6_[0],_loc6_[1]];
               _loc18_ = [Math.max(0,_loc5_[0] - 0.15),Math.max(0,_loc5_[1] - 0.15)];
               drawRoundRect(0,0,param1,param2,0,[_loc3_,_loc10_],0.5,verticalGradientMatrix(0,0,param1,param2),GradientType.LINEAR,null,{
                  "x":1,
                  "y":1,
                  "w":param1 - 2,
                  "h":param2 - 2,
                  "r":0
               });
               drawRoundRect(1,1,param1 - 2,param2 - 2,0,_loc17_,_loc18_,verticalGradientMatrix(1,1,param1 - 2,param2 - 2));
         }
         if(_loc12_)
         {
            _loc19_.beginFill(_loc4_);
            _loc19_.moveTo(3,5);
            _loc19_.lineTo(5,10);
            _loc19_.lineTo(7,10);
            _loc19_.lineTo(12,2);
            _loc19_.lineTo(13,1);
            _loc19_.lineTo(11,1);
            _loc19_.lineTo(6.5,7);
            _loc19_.lineTo(5,5);
            _loc19_.lineTo(3,5);
            _loc19_.endFill();
         }
      }
   }
}
