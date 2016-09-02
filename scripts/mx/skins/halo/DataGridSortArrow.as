package mx.skins.halo
{
   import mx.skins.ProgrammaticSkin;
   import mx.core.mx_internal;
   import flash.display.Graphics;
   
   use namespace mx_internal;
   
   public class DataGridSortArrow extends ProgrammaticSkin
   {
      
      mx_internal static const VERSION:String = "3.6.0.21751";
       
      
      public function DataGridSortArrow()
      {
         super();
      }
      
      override public function get measuredWidth() : Number
      {
         return 6;
      }
      
      override public function get measuredHeight() : Number
      {
         return 6;
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         super.updateDisplayList(param1,param2);
         var _loc3_:Graphics = graphics;
         _loc3_.clear();
         _loc3_.beginFill(name == "sortArrowDisabled"?uint(getStyle("disabledIconColor")):uint(getStyle("iconColor")));
         _loc3_.moveTo(0,0);
         _loc3_.lineTo(param1,0);
         _loc3_.lineTo(param1 / 2,param2);
         _loc3_.lineTo(0,0);
         _loc3_.endFill();
      }
   }
}
