package tibia.minimap.editMarkWidgetClasses
{
   import shared.controls.IconRendererBase;
   import flash.display.Graphics;
   import flash.geom.Rectangle;
   import flash.display.BitmapData;
   import tibia.minimap.MiniMapStorage;
   import flash.geom.Matrix;
   
   public class MarkIconRenderer extends IconRendererBase
   {
       
      
      public function MarkIconRenderer()
      {
         super(MiniMapStorage.MARK_ICON_SIZE,MiniMapStorage.MARK_ICON_SIZE,MiniMapStorage.MARK_ICON_COUNT - 1);
      }
      
      override protected function drawIcon(param1:Graphics) : void
      {
         var _loc2_:Rectangle = null;
         var _loc3_:BitmapData = null;
         if(param1 != null)
         {
            _loc2_ = new Rectangle();
            _loc3_ = MiniMapStorage.s_GetMarkIcon(ID,false,_loc2_);
            param1.clear();
            param1.beginBitmapFill(_loc3_,new Matrix(1,0,0,1,-_loc2_.x,-_loc2_.y),false,false);
            param1.drawRect(0,0,_loc2_.width,_loc2_.height);
            param1.endFill();
         }
      }
   }
}
