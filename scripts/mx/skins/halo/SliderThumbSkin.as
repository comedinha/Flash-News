package mx.skins.halo
{
   import mx.skins.Border;
   import mx.core.mx_internal;
   import mx.utils.ColorUtil;
   import mx.styles.StyleManager;
   import flash.display.Graphics;
   import flash.display.GradientType;
   
   use namespace mx_internal;
   
   public class SliderThumbSkin extends Border
   {
      
      mx_internal static const VERSION:String = "3.6.0.21751";
      
      private static var cache:Object = {};
       
      
      public function SliderThumbSkin()
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
         return 12;
      }
      
      override public function get measuredHeight() : Number
      {
         return 12;
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         var _loc9_:Array = null;
         var _loc10_:Array = null;
         super.updateDisplayList(param1,param2);
         var _loc3_:uint = getStyle("borderColor");
         var _loc4_:Array = getStyle("fillAlphas");
         var _loc5_:Array = getStyle("fillColors");
         StyleManager.getColorNames(_loc5_);
         var _loc6_:uint = getStyle("themeColor");
         var _loc7_:Object = calcDerivedStyles(_loc6_,_loc3_,_loc5_[0],_loc5_[1]);
         var _loc8_:Graphics = graphics;
         _loc8_.clear();
         switch(name)
         {
            case "thumbUpSkin":
               drawThumbState(param1,param2,[_loc3_,_loc7_.borderColorDrk1],[_loc5_[0],_loc5_[1]],[_loc4_[0],_loc4_[1]],true,true);
               break;
            case "thumbOverSkin":
               if(_loc5_.length > 2)
               {
                  _loc9_ = [_loc5_[2],_loc5_[3]];
               }
               else
               {
                  _loc9_ = [_loc5_[0],_loc5_[1]];
               }
               if(_loc4_.length > 2)
               {
                  _loc10_ = [_loc4_[2],_loc4_[3]];
               }
               else
               {
                  _loc10_ = [_loc4_[0],_loc4_[1]];
               }
               drawThumbState(param1,param2,[_loc7_.themeColDrk2,_loc7_.themeColDrk1],_loc9_,_loc10_,true,true);
               break;
            case "thumbDownSkin":
               drawThumbState(param1,param2,[_loc7_.themeColDrk2,_loc7_.themeColDrk1],[_loc7_.fillColorPress1,_loc7_.fillColorPress2],[1,1],true,false);
               break;
            case "thumbDisabledSkin":
               drawThumbState(param1,param2,[_loc3_,_loc7_.borderColorDrk1],[_loc5_[0],_loc5_[1]],[Math.max(0,_loc4_[0] - 0.15),Math.max(0,_loc4_[1] - 0.15)],false,false);
         }
      }
      
      protected function drawThumbState(param1:Number, param2:Number, param3:Array, param4:Array, param5:Array, param6:Boolean, param7:Boolean) : void
      {
         var _loc8_:Graphics = graphics;
         var _loc9_:Boolean = getStyle("invertThumbDirection");
         var _loc10_:Number = !!_loc9_?Number(param2):Number(0);
         var _loc11_:Number = !!_loc9_?Number(param2 - 1):Number(1);
         var _loc12_:Number = !!_loc9_?Number(param2 - 2):Number(2);
         var _loc13_:Number = !!_loc9_?Number(2):Number(param2 - 2);
         var _loc14_:Number = !!_loc9_?Number(1):Number(param2 - 1);
         var _loc15_:Number = !!_loc9_?Number(0):Number(param2);
         if(_loc9_)
         {
            param3 = [param3[1],param3[0]];
            param4 = [param4[1],param4[0]];
            param5 = [param5[1],param5[0]];
         }
         if(param6)
         {
            _loc8_.beginGradientFill(GradientType.LINEAR,[16777215,16777215],[0.6,0.6],[0,255],verticalGradientMatrix(0,0,param1,param2));
            _loc8_.moveTo(param1 / 2,_loc10_);
            _loc8_.curveTo(param1 / 2,_loc10_,param1 / 2 - 2,_loc12_);
            _loc8_.lineTo(0,_loc13_);
            _loc8_.curveTo(0,_loc13_,2,_loc15_);
            _loc8_.lineTo(param1 - 2,_loc15_);
            _loc8_.curveTo(param1 - 2,_loc15_,param1,_loc13_);
            _loc8_.lineTo(param1 / 2 + 2,_loc12_);
            _loc8_.curveTo(param1 / 2 + 2,_loc12_,param1 / 2,_loc10_);
            _loc8_.endFill();
         }
         _loc8_.beginGradientFill(GradientType.LINEAR,param3,[1,1],[0,255],verticalGradientMatrix(0,0,param1,param2));
         _loc8_.moveTo(param1 / 2,_loc10_);
         _loc8_.curveTo(param1 / 2,_loc10_,param1 / 2 - 2,_loc12_);
         _loc8_.lineTo(0,_loc13_);
         _loc8_.curveTo(0,_loc13_,2,_loc15_);
         _loc8_.lineTo(param1 - 2,_loc15_);
         _loc8_.curveTo(param1 - 2,_loc15_,param1,_loc13_);
         _loc8_.lineTo(param1 / 2 + 2,_loc12_);
         _loc8_.curveTo(param1 / 2 + 2,_loc12_,param1 / 2,_loc10_);
         if(param7)
         {
            _loc8_.moveTo(param1 / 2,_loc11_);
            _loc8_.curveTo(param1 / 2,_loc10_,param1 / 2 - 1,_loc12_);
            _loc8_.lineTo(1,_loc14_);
            _loc8_.curveTo(1,_loc14_,1,_loc14_);
            _loc8_.lineTo(param1 - 1,_loc14_);
            _loc8_.curveTo(param1 - 1,_loc14_,param1 - 1,_loc13_);
            _loc8_.lineTo(param1 / 2 + 1,_loc12_);
            _loc8_.curveTo(param1 / 2 + 1,_loc12_,param1 / 2,_loc11_);
            _loc8_.endFill();
         }
         _loc8_.beginGradientFill(GradientType.LINEAR,param4,param5,[0,255],verticalGradientMatrix(0,0,param1,param2));
         _loc8_.moveTo(param1 / 2,_loc11_);
         _loc8_.curveTo(param1 / 2,_loc10_,param1 / 2 - 1,_loc12_);
         _loc8_.lineTo(1,_loc14_);
         _loc8_.curveTo(1,_loc14_,1,_loc14_);
         _loc8_.lineTo(param1 - 1,_loc14_);
         _loc8_.curveTo(param1 - 1,_loc14_,param1 - 1,_loc13_);
         _loc8_.lineTo(param1 / 2 + 1,_loc12_);
         _loc8_.curveTo(param1 / 2 + 1,_loc12_,param1 / 2,_loc11_);
         _loc8_.endFill();
      }
   }
}
