package tibia.cursors
{
   import flash.ui.MouseCursorData;
   import flash.display.BitmapData;
   import flash.display.Bitmap;
   import flash.geom.Point;
   import flash.ui.Mouse;
   
   public class CrosshairCursor
   {
      
      public static const CURSOR_ATTACK_NAME:String = "attack";
      
      public static const CURSOR_RESIZE_VERTICAL_NAME:String = "resizeVertical";
      
      public static const CURSOR_LOOK_NAME:String = "look";
      
      public static const CURSOR_RESIZE_HORIZONTAL_NAME:String = "resizeHorizontal";
      
      public static const CURSOR_NAME:String = CURSOR_CROSSHAIR_NAME;
      
      public static const CURSOR_TALK_NAME:String = "talk";
      
      public static const CURSOR_WALK_NAME:String = "walk";
      
      public static const CURSOR_DEFAULT_REJECT_NAME:String = "defaultReject";
      
      public static const CURSOR_USE_NAME:String = "use";
      
      private static const CURSOR_CLASS:Class = CrosshairCursor_CURSOR_CLASS;
      
      public static const CURSOR_CROSSHAIR_NAME:String = "crosshair";
      
      public static const CURSOR_DEFAULT_NAME:String = "default";
      
      public static const CURSOR_OPEN_NAME:String = "open";
      
      {
         s_RegisterNative();
      }
      
      public function CrosshairCursor()
      {
         super();
      }
      
      private static function s_RegisterNative() : void
      {
         var _loc1_:MouseCursorData = new MouseCursorData();
         _loc1_.data = new Vector.<BitmapData>();
         _loc1_.data[0] = Bitmap(new CURSOR_CLASS()).bitmapData;
         _loc1_.frameRate = 0;
         _loc1_.hotSpot = new Point(10,9);
         Mouse.registerCursor(CURSOR_NAME,_loc1_);
      }
   }
}
