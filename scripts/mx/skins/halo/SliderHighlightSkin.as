package mx.skins.halo
{
   import mx.skins.Border;
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   public class SliderHighlightSkin extends Border
   {
      
      mx_internal static const VERSION:String = "3.6.0.21751";
       
      
      public function SliderHighlightSkin()
      {
         super();
      }
      
      override public function get measuredWidth() : Number
      {
         return 1;
      }
      
      override public function get measuredHeight() : Number
      {
         return 2;
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         super.updateDisplayList(param1,param2);
         var _loc3_:int = getStyle("themeColor");
         graphics.clear();
         drawRoundRect(0,0,param1,1,0,_loc3_,0.7);
         drawRoundRect(0,param2 - 1,param1,1,0,_loc3_,1);
         drawRoundRect(0,param2 - 2,param1,1,0,_loc3_,0.4);
      }
   }
}
