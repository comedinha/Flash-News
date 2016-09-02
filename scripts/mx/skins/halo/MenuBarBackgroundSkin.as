package mx.skins.halo
{
   import mx.skins.Border;
   import mx.core.mx_internal;
   import mx.core.UIComponent;
   import mx.styles.StyleManager;
   import mx.utils.ColorUtil;
   import flash.display.GradientType;
   import mx.core.EdgeMetrics;
   
   use namespace mx_internal;
   
   public class MenuBarBackgroundSkin extends Border
   {
      
      mx_internal static const VERSION:String = "3.6.0.21751";
      
      private static var cache:Object = {};
       
      
      private var _borderMetrics:EdgeMetrics;
      
      public function MenuBarBackgroundSkin()
      {
         _borderMetrics = new EdgeMetrics(1,1,1,1);
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
      
      override public function get measuredWidth() : Number
      {
         return UIComponent.DEFAULT_MEASURED_MIN_WIDTH;
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         super.updateDisplayList(param1,param2);
         var _loc3_:Boolean = getStyle("bevel");
         var _loc4_:uint = getStyle("borderColor");
         var _loc5_:Number = getStyle("cornerRadius");
         var _loc6_:Array = getStyle("fillAlphas");
         var _loc7_:Array = getStyle("fillColors");
         StyleManager.getColorNames(_loc7_);
         var _loc8_:uint = getStyle("themeColor");
         var _loc9_:Object = calcDerivedStyles(_loc8_,_loc7_[0],_loc7_[1]);
         var _loc10_:Number = ColorUtil.adjustBrightness2(_loc4_,-25);
         var _loc11_:Number = Math.max(0,_loc5_);
         var _loc12_:Number = Math.max(0,_loc5_ - 1);
         var _loc13_:Array = [_loc7_[0],_loc7_[1]];
         var _loc14_:Array = [_loc6_[0],_loc6_[1]];
         graphics.clear();
         drawRoundRect(0,0,param1,param2,_loc11_,[_loc4_,_loc10_],1,verticalGradientMatrix(0,0,param1,param2),GradientType.LINEAR,null,{
            "x":1,
            "y":1,
            "w":param1 - 2,
            "h":param2 - 2,
            "r":_loc12_
         });
         drawRoundRect(1,1,param1 - 2,param2 - 2,_loc12_,_loc13_,_loc14_,verticalGradientMatrix(1,1,param1 - 2,param2 - 2));
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
