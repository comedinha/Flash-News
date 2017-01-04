package mx.skins.halo
{
   import flash.display.GradientType;
   import flash.display.Graphics;
   import mx.core.mx_internal;
   import mx.skins.Border;
   import mx.styles.StyleManager;
   import mx.utils.ColorUtil;
   
   use namespace mx_internal;
   
   public class RadioButtonIcon extends Border
   {
      
      mx_internal static const VERSION:String = "3.6.0.21751";
      
      private static var cache:Object = {};
       
      
      public function RadioButtonIcon()
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
            _loc6_.borderColorDrk1 = ColorUtil.adjustBrightness2(param2,-60);
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
         var _loc18_:Array = null;
         var _loc19_:Array = null;
         super.updateDisplayList(param1,param2);
         var _loc3_:uint = getStyle("iconColor");
         var _loc4_:uint = getStyle("borderColor");
         var _loc5_:Array = getStyle("fillAlphas");
         var _loc6_:Array = getStyle("fillColors");
         StyleManager.getColorNames(_loc6_);
         var _loc7_:Array = getStyle("highlightAlphas");
         var _loc8_:uint = getStyle("themeColor");
         var _loc9_:Object = calcDerivedStyles(_loc8_,_loc4_,_loc6_[0],_loc6_[1]);
         var _loc10_:Number = ColorUtil.adjustBrightness2(_loc4_,-50);
         var _loc11_:Number = ColorUtil.adjustBrightness2(_loc8_,-25);
         var _loc12_:Number = width / 2;
         var _loc17_:Graphics = graphics;
         _loc17_.clear();
         switch(name)
         {
            case "upIcon":
               _loc13_ = [_loc6_[0],_loc6_[1]];
               _loc14_ = [_loc5_[0],_loc5_[1]];
               _loc17_.beginGradientFill(GradientType.LINEAR,[_loc4_,_loc10_],[100,100],[0,255],verticalGradientMatrix(0,0,param1,param2));
               _loc17_.drawCircle(_loc12_,_loc12_,_loc12_);
               _loc17_.drawCircle(_loc12_,_loc12_,_loc12_ - 1);
               _loc17_.endFill();
               _loc17_.beginGradientFill(GradientType.LINEAR,_loc13_,_loc14_,[0,255],verticalGradientMatrix(1,1,param1 - 2,param2 - 2));
               _loc17_.drawCircle(_loc12_,_loc12_,_loc12_ - 1);
               _loc17_.endFill();
               drawRoundRect(1,1,param1 - 2,(param2 - 2) / 2,{
                  "tl":_loc12_,
                  "tr":_loc12_,
                  "bl":0,
                  "br":0
               },[16777215,16777215],_loc7_,verticalGradientMatrix(0,0,param1 - 2,(param2 - 2) / 2));
               break;
            case "overIcon":
               if(_loc6_.length > 2)
               {
                  _loc18_ = [_loc6_[2],_loc6_[3]];
               }
               else
               {
                  _loc18_ = [_loc6_[0],_loc6_[1]];
               }
               if(_loc5_.length > 2)
               {
                  _loc19_ = [_loc5_[2],_loc5_[3]];
               }
               else
               {
                  _loc19_ = [_loc5_[0],_loc5_[1]];
               }
               _loc17_.beginGradientFill(GradientType.LINEAR,[_loc8_,_loc11_],[100,100],[0,255],verticalGradientMatrix(0,0,param1,param2));
               _loc17_.drawCircle(_loc12_,_loc12_,_loc12_);
               _loc17_.drawCircle(_loc12_,_loc12_,_loc12_ - 1);
               _loc17_.endFill();
               _loc17_.beginGradientFill(GradientType.LINEAR,_loc18_,_loc19_,[0,255],verticalGradientMatrix(1,1,param1 - 2,param2 - 2));
               _loc17_.drawCircle(_loc12_,_loc12_,_loc12_ - 1);
               _loc17_.endFill();
               drawRoundRect(1,1,param1 - 2,(param2 - 2) / 2,{
                  "tl":_loc12_,
                  "tr":_loc12_,
                  "bl":0,
                  "br":0
               },[16777215,16777215],_loc7_,verticalGradientMatrix(0,0,param1 - 2,(param2 - 2) / 2));
               break;
            case "downIcon":
               _loc17_.beginGradientFill(GradientType.LINEAR,[_loc8_,_loc11_],[100,100],[0,255],verticalGradientMatrix(0,0,param1,param2));
               _loc17_.drawCircle(_loc12_,_loc12_,_loc12_);
               _loc17_.endFill();
               _loc17_.beginGradientFill(GradientType.LINEAR,[_loc9_.fillColorPress1,_loc9_.fillColorPress2],[100,100],[0,255],verticalGradientMatrix(1,1,param1 - 2,param2 - 2));
               _loc17_.drawCircle(_loc12_,_loc12_,_loc12_ - 1);
               _loc17_.endFill();
               drawRoundRect(1,1,param1 - 2,(param2 - 2) / 2,{
                  "tl":_loc12_,
                  "tr":_loc12_,
                  "bl":0,
                  "br":0
               },[16777215,16777215],_loc7_,verticalGradientMatrix(0,0,param1 - 2,(param2 - 2) / 2));
               break;
            case "disabledIcon":
               _loc15_ = [_loc6_[0],_loc6_[1]];
               _loc16_ = [Math.max(0,_loc5_[0] - 0.15),Math.max(0,_loc5_[1] - 0.15)];
               _loc17_.beginGradientFill(GradientType.LINEAR,[_loc4_,_loc10_],[0.5,0.5],[0,255],verticalGradientMatrix(0,0,param1,param2));
               _loc17_.drawCircle(_loc12_,_loc12_,_loc12_);
               _loc17_.drawCircle(_loc12_,_loc12_,_loc12_ - 1);
               _loc17_.endFill();
               _loc17_.beginGradientFill(GradientType.LINEAR,_loc15_,_loc16_,[0,255],verticalGradientMatrix(1,1,param1 - 2,param2 - 2));
               _loc17_.drawCircle(_loc12_,_loc12_,_loc12_ - 1);
               _loc17_.endFill();
               break;
            case "selectedUpIcon":
            case "selectedOverIcon":
            case "selectedDownIcon":
               _loc13_ = [_loc6_[0],_loc6_[1]];
               _loc14_ = [_loc5_[0],_loc5_[1]];
               _loc17_.beginGradientFill(GradientType.LINEAR,[_loc4_,_loc10_],[100,100],[0,255],verticalGradientMatrix(0,0,param1,param2));
               _loc17_.drawCircle(_loc12_,_loc12_,_loc12_);
               _loc17_.drawCircle(_loc12_,_loc12_,_loc12_ - 1);
               _loc17_.endFill();
               _loc17_.beginGradientFill(GradientType.LINEAR,_loc13_,_loc14_,[0,255],verticalGradientMatrix(1,1,param1 - 2,param2 - 2));
               _loc17_.drawCircle(_loc12_,_loc12_,_loc12_ - 1);
               _loc17_.endFill();
               drawRoundRect(1,1,param1 - 2,(param2 - 2) / 2,{
                  "tl":_loc12_,
                  "tr":_loc12_,
                  "bl":0,
                  "br":0
               },[16777215,16777215],_loc7_,verticalGradientMatrix(0,0,param1 - 2,(param2 - 2) / 2));
               _loc17_.beginFill(_loc3_);
               _loc17_.drawCircle(_loc12_,_loc12_,2);
               _loc17_.endFill();
               break;
            case "selectedDisabledIcon":
               _loc15_ = [_loc6_[0],_loc6_[1]];
               _loc16_ = [Math.max(0,_loc5_[0] - 0.15),Math.max(0,_loc5_[1] - 0.15)];
               _loc17_.beginGradientFill(GradientType.LINEAR,[_loc4_,_loc10_],[0.5,0.5],[0,255],verticalGradientMatrix(0,0,param1,param2));
               _loc17_.drawCircle(_loc12_,_loc12_,_loc12_);
               _loc17_.drawCircle(_loc12_,_loc12_,_loc12_ - 1);
               _loc17_.endFill();
               _loc17_.beginGradientFill(GradientType.LINEAR,_loc15_,_loc16_,[0,255],verticalGradientMatrix(1,1,param1 - 2,param2 - 2));
               _loc17_.drawCircle(_loc12_,_loc12_,_loc12_ - 1);
               _loc17_.endFill();
               _loc3_ = getStyle("disabledIconColor");
               _loc17_.beginFill(_loc3_);
               _loc17_.drawCircle(_loc12_,_loc12_,2);
               _loc17_.endFill();
         }
      }
   }
}
