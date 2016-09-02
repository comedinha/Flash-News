package tibia.cursors
{
   import flash.display.BitmapData;
   import flash.geom.Rectangle;
   import flash.ui.MouseCursorData;
   import flash.display.Bitmap;
   import flash.geom.Point;
   import flash.ui.Mouse;
   
   public class WalkCursor
   {
      
      public static const CURSOR_ATTACK_NAME:String = "attack";
      
      public static const CURSOR_RESIZE_VERTICAL_NAME:String = "resizeVertical";
      
      public static const CURSOR_LOOK_NAME:String = "look";
      
      public static const CURSOR_RESIZE_HORIZONTAL_NAME:String = "resizeHorizontal";
      
      public static const CURSOR_NAME:String = CURSOR_WALK_NAME;
      
      public static const CURSOR_TALK_NAME:String = "talk";
      
      public static const CURSOR_WALK_NAME:String = "walk";
      
      public static const CURSOR_DEFAULT_REJECT_NAME:String = "defaultReject";
      
      public static const CURSOR_USE_NAME:String = "use";
      
      private static const CURSOR_CLASS:Class = WalkCursor_CURSOR_CLASS;
      
      public static const CURSOR_CROSSHAIR_NAME:String = "crosshair";
      
      public static const CURSOR_DEFAULT_NAME:String = "default";
      
      public static const CURSOR_OPEN_NAME:String = "open";
      
      {
         s_RegisterNative();
      }
      
      public function WalkCursor()
      {
         super();
      }
      
      private static function s_RegisterNative() : void
      {
         var _loc4_:BitmapData = null;
         var _loc5_:Rectangle = null;
         var _loc1_:MouseCursorData = new MouseCursorData();
         var _loc2_:BitmapData = Bitmap(new CURSOR_CLASS()).bitmapData;
         _loc1_.data = new Vector.<BitmapData>();
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.width / 32)
         {
            _loc4_ = new BitmapData(32,32,true);
            _loc5_ = new Rectangle(_loc3_ * 32,0,32,32);
            _loc4_.copyPixels(_loc2_,_loc5_,new Point(0,0));
            _loc1_.data[_loc3_] = _loc4_;
            _loc3_++;
         }
         _loc1_.frameRate = 10;
         _loc1_.hotSpot = new Point(1,0);
         Mouse.registerCursor(CURSOR_NAME,_loc1_);
      }
   }
}
