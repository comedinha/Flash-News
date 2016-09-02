package mx.skins.halo
{
   import mx.skins.ProgrammaticSkin;
   import mx.core.mx_internal;
   import flash.display.Graphics;
   import mx.styles.StyleManager;
   import flash.geom.Matrix;
   import flash.display.GradientType;
   
   use namespace mx_internal;
   
   public class DataGridHeaderBackgroundSkin extends ProgrammaticSkin
   {
      
      mx_internal static const VERSION:String = "3.6.0.21751";
       
      
      public function DataGridHeaderBackgroundSkin()
      {
         super();
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         var _loc3_:Graphics = graphics;
         _loc3_.clear();
         var _loc4_:Array = getStyle("headerColors");
         StyleManager.getColorNames(_loc4_);
         var _loc5_:Matrix = new Matrix();
         _loc5_.createGradientBox(param1,param2 + 1,Math.PI / 2,0,0);
         _loc4_ = [_loc4_[0],_loc4_[0],_loc4_[1]];
         var _loc6_:Array = [0,60,255];
         var _loc7_:Array = [1,1,1];
         _loc3_.beginGradientFill(GradientType.LINEAR,_loc4_,_loc7_,_loc6_,_loc5_);
         _loc3_.lineStyle(0,0,0);
         _loc3_.moveTo(0,0);
         _loc3_.lineTo(param1,0);
         _loc3_.lineTo(param1,param2 - 0.5);
         _loc3_.lineStyle(0,getStyle("borderColor"),100);
         _loc3_.lineTo(0,param2 - 0.5);
         _loc3_.lineStyle(0,0,0);
         _loc3_.endFill();
      }
   }
}
