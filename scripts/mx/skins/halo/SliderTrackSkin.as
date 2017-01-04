package mx.skins.halo
{
   import flash.display.GradientType;
   import mx.core.mx_internal;
   import mx.skins.Border;
   import mx.styles.StyleManager;
   import mx.utils.ColorUtil;
   
   use namespace mx_internal;
   
   public class SliderTrackSkin extends Border
   {
      
      mx_internal static const VERSION:String = "3.6.0.21751";
       
      
      public function SliderTrackSkin()
      {
         super();
      }
      
      override public function get measuredWidth() : Number
      {
         return 200;
      }
      
      override public function get measuredHeight() : Number
      {
         return 4;
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         super.updateDisplayList(param1,param2);
         var _loc3_:Number = getStyle("borderColor");
         var _loc4_:Array = getStyle("fillAlphas");
         var _loc5_:Array = getStyle("trackColors") as Array;
         StyleManager.getColorNames(_loc5_);
         var _loc6_:Number = ColorUtil.adjustBrightness2(_loc3_,-50);
         graphics.clear();
         drawRoundRect(0,0,param1,param2,0,0,0);
         drawRoundRect(1,0,param1,param2 - 1,1.5,_loc6_,1,null,GradientType.LINEAR,null,{
            "x":2,
            "y":1,
            "w":param1 - 2,
            "h":1,
            "r":0
         });
         drawRoundRect(2,1,param1 - 2,param2 - 2,1,_loc3_,1,null,GradientType.LINEAR,null,{
            "x":2,
            "y":1,
            "w":param1 - 2,
            "h":1,
            "r":0
         });
         drawRoundRect(2,1,param1 - 2,1,0,_loc5_,Math.max(_loc4_[1] - 0.3,0),horizontalGradientMatrix(2,1,param1 - 2,1));
      }
   }
}
