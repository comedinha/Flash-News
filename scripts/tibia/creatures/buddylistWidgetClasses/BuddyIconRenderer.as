package tibia.creatures.buddylistWidgetClasses
{
   import shared.controls.IconRendererBase;
   import flash.display.BitmapData;
   import flash.display.Bitmap;
   import flash.display.Graphics;
   import flash.geom.Matrix;
   import tibia.creatures.buddylistClasses.BuddyIcon;
   
   public class BuddyIconRenderer extends IconRendererBase
   {
      
      static const ICON_WIDTH:int = 12;
      
      static const ICON_BITMAP:BitmapData = Bitmap(new ICON_BITMAP_CLASS()).bitmapData;
      
      static const ICON_HEIGHT:int = 12;
      
      static const ICON_BITMAP_CLASS:Class = BuddyIconRenderer_ICON_BITMAP_CLASS;
       
      
      public function BuddyIconRenderer()
      {
         super(ICON_WIDTH,ICON_HEIGHT,BuddyIcon.NUM_ICONS);
      }
      
      override protected function drawIcon(param1:Graphics) : void
      {
         if(param1 != null)
         {
            param1.clear();
            param1.beginBitmapFill(ICON_BITMAP,new Matrix(1,0,0,1,-ID * ICON_WIDTH,0),false,false);
            param1.drawRect(0,0,ICON_WIDTH,ICON_HEIGHT);
            param1.endFill();
         }
      }
   }
}
