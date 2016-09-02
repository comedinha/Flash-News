package mx.skins.halo
{
   import mx.skins.ProgrammaticSkin;
   import mx.core.mx_internal;
   import flash.display.Graphics;
   import mx.utils.ColorUtil;
   
   use namespace mx_internal;
   
   public class DataGridColumnDropIndicator extends ProgrammaticSkin
   {
      
      mx_internal static const VERSION:String = "3.6.0.21751";
       
      
      public function DataGridColumnDropIndicator()
      {
         super();
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         super.updateDisplayList(param1,param2);
         var _loc3_:Graphics = graphics;
         _loc3_.clear();
         _loc3_.lineStyle(1,getStyle("rollOverColor"));
         _loc3_.moveTo(0,0);
         _loc3_.lineTo(0,param2);
         _loc3_.lineStyle(1,ColorUtil.adjustBrightness(getStyle("themeColor"),-75));
         _loc3_.moveTo(1,0);
         _loc3_.lineTo(1,param2);
         _loc3_.lineStyle(1,getStyle("rollOverColor"));
         _loc3_.moveTo(2,0);
         _loc3_.lineTo(2,param2);
      }
   }
}
