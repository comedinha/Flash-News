package mx.skins.halo
{
   import flash.display.GradientType;
   import flash.display.Graphics;
   import mx.core.mx_internal;
   import mx.skins.Border;
   import mx.styles.StyleManager;
   import mx.utils.ColorUtil;
   
   use namespace mx_internal;
   
   public class ComboBoxArrowSkin extends Border
   {
      
      mx_internal static const VERSION:String = "3.6.0.21751";
      
      private static var cache:Object = {};
       
      
      public function ComboBoxArrowSkin()
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
         }
         return cache[_loc5_];
      }
      
      override public function get measuredWidth() : Number
      {
         return 22;
      }
      
      override public function get measuredHeight() : Number
      {
         return 22;
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         var _loc19_:Array = null;
         var _loc20_:Array = null;
         var _loc21_:Array = null;
         var _loc22_:Array = null;
         var _loc23_:Array = null;
         var _loc24_:Array = null;
         super.updateDisplayList(param1,param2);
         var _loc3_:uint = getStyle("iconColor");
         var _loc4_:uint = getStyle("borderColor");
         var _loc5_:Number = getStyle("cornerRadius");
         var _loc6_:Number = getStyle("dropdownBorderColor");
         var _loc7_:Array = getStyle("fillAlphas");
         var _loc8_:Array = getStyle("fillColors");
         StyleManager.getColorNames(_loc8_);
         var _loc9_:Array = getStyle("highlightAlphas");
         var _loc10_:uint = getStyle("themeColor");
         if(!isNaN(_loc6_))
         {
            _loc4_ = _loc6_;
         }
         var _loc11_:Object = calcDerivedStyles(_loc10_,_loc4_,_loc8_[0],_loc8_[1]);
         var _loc12_:Number = ColorUtil.adjustBrightness2(_loc4_,-50);
         var _loc13_:Number = ColorUtil.adjustBrightness2(_loc10_,-25);
         var _loc14_:Number = Math.max(_loc5_ - 1,0);
         var _loc15_:Object = {
            "tl":0,
            "tr":_loc5_,
            "bl":0,
            "br":_loc5_
         };
         var _loc16_:Object = {
            "tl":0,
            "tr":_loc14_,
            "bl":0,
            "br":_loc14_
         };
         var _loc17_:Boolean = true;
         if(name.indexOf("editable") < 0)
         {
            _loc17_ = false;
            _loc15_.tl = _loc15_.bl = _loc5_;
            _loc16_.tl = _loc16_.bl = _loc14_;
         }
         var _loc18_:Graphics = graphics;
         _loc18_.clear();
         switch(name)
         {
            case "upSkin":
            case "editableUpSkin":
               _loc19_ = [_loc8_[0],_loc8_[1]];
               _loc20_ = [_loc7_[0],_loc7_[1]];
               drawRoundRect(0,0,param1,param2,_loc15_,[_loc4_,_loc12_],1,verticalGradientMatrix(0,0,param1,param2),GradientType.LINEAR,null,{
                  "x":1,
                  "y":1,
                  "w":param1 - 2,
                  "h":param2 - 2,
                  "r":_loc16_
               });
               drawRoundRect(1,1,param1 - 2,param2 - 2,_loc16_,_loc19_,_loc20_,verticalGradientMatrix(1,1,param1 - 2,param2 - 2));
               drawRoundRect(1,1,param1 - 2,(param2 - 2) / 2,{
                  "tl":_loc14_,
                  "tr":_loc14_,
                  "bl":0,
                  "br":0
               },[16777215,16777215],_loc9_,verticalGradientMatrix(1,1,param1 - 2,(param2 - 2) / 2));
               if(!_loc17_)
               {
                  drawRoundRect(param1 - 22,4,1,param2 - 8,0,_loc4_,1);
                  drawRoundRect(param1 - 21,4,1,param2 - 8,0,16777215,0.2);
               }
               break;
            case "overSkin":
            case "editableOverSkin":
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
               drawRoundRect(0,0,param1,param2,_loc15_,[_loc10_,_loc13_],1,verticalGradientMatrix(0,0,param1,param2),GradientType.LINEAR,null,{
                  "x":1,
                  "y":1,
                  "w":param1 - 2,
                  "h":param2 - 2,
                  "r":_loc16_
               });
               drawRoundRect(1,1,param1 - 2,param2 - 2,_loc16_,_loc21_,_loc22_,verticalGradientMatrix(1,1,param1 - 2,param2 - 2));
               drawRoundRect(1,1,param1 - 2,(param2 - 2) / 2,{
                  "tl":_loc14_,
                  "tr":_loc14_,
                  "bl":0,
                  "br":0
               },[16777215,16777215],_loc9_,verticalGradientMatrix(0,0,param1 - 2,(param2 - 2) / 2));
               if(!_loc17_)
               {
                  drawRoundRect(param1 - 22,4,1,param2 - 8,0,_loc11_.themeColDrk2,1);
                  drawRoundRect(param1 - 21,4,1,param2 - 8,0,16777215,0.2);
               }
               break;
            case "downSkin":
            case "editableDownSkin":
               drawRoundRect(0,0,param1,param2,_loc15_,[_loc10_,_loc13_],1,verticalGradientMatrix(0,0,param1,param2));
               drawRoundRect(1,1,param1 - 2,param2 - 2,_loc16_,[_loc11_.fillColorPress1,_loc11_.fillColorPress2],1,verticalGradientMatrix(1,1,param1 - 2,param2 - 2));
               drawRoundRect(1,1,param1 - 2,(param2 - 2) / 2,{
                  "tl":_loc14_,
                  "tr":_loc14_,
                  "bl":0,
                  "br":0
               },[16777215,16777215],_loc9_,verticalGradientMatrix(1,1,param1 - 2,(param2 - 2) / 2));
               if(!_loc17_)
               {
                  drawRoundRect(param1 - 22,4,1,param2 - 8,0,_loc13_,1);
                  drawRoundRect(param1 - 21,4,1,param2 - 8,0,16777215,0.2);
               }
               break;
            case "disabledSkin":
            case "editableDisabledSkin":
               _loc23_ = [_loc8_[0],_loc8_[1]];
               _loc24_ = [Math.max(0,_loc7_[0] - 0.15),Math.max(0,_loc7_[1] - 0.15)];
               drawRoundRect(0,0,param1,param2,_loc15_,[_loc4_,_loc12_],0.5,verticalGradientMatrix(0,0,param1,param2),GradientType.LINEAR,null,{
                  "x":1,
                  "y":1,
                  "w":param1 - 2,
                  "h":param2 - 2,
                  "r":_loc16_
               });
               drawRoundRect(1,1,param1 - 2,param2 - 2,_loc16_,_loc23_,_loc24_,verticalGradientMatrix(0,0,param1 - 2,param2 - 2));
               if(!_loc17_)
               {
                  drawRoundRect(param1 - 22,4,1,param2 - 8,0,10066329,0.5);
               }
               _loc3_ = getStyle("disabledIconColor");
         }
         _loc18_.beginFill(_loc3_);
         _loc18_.moveTo(param1 - 11.5,param2 / 2 + 3);
         _loc18_.lineTo(param1 - 15,param2 / 2 - 2);
         _loc18_.lineTo(param1 - 8,param2 / 2 - 2);
         _loc18_.lineTo(param1 - 11.5,param2 / 2 + 3);
         _loc18_.endFill();
      }
   }
}
