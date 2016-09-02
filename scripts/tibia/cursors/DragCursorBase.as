package tibia.cursors
{
   import flash.ui.MouseCursorData;
   import flash.display.BitmapData;
   import flash.display.Bitmap;
   import flash.geom.Point;
   import flash.ui.Mouse;
   import mx.managers.dragClasses.DragProxy;
   import mx.managers.DragManager;
   import mx.core.mx_internal;
   
   public class DragCursorBase
   {
      
      public static const CURSOR_RESIZE_VERTICAL_NAME:String = "resizeVertical";
      
      public static const CURSOR_LOOK_NAME:String = "look";
      
      public static const CURSOR_RESIZE_HORIZONTAL_NAME:String = "resizeHorizontal";
      
      private static const CROSSHAIR_MOVE_CLASS:Class = DragCursorBase_CROSSHAIR_MOVE_CLASS;
      
      protected static const DRAG_TYPE_CHANNEL:String = "channel";
      
      private static const DEFAULT_MOVE_CLASS:Class = DragCursorBase_DEFAULT_MOVE_CLASS;
      
      protected static const DRAG_TYPE_ACTION:String = "action";
      
      public static const CURSOR_ATTACK_NAME:String = "attack";
      
      public static const CURSOR_TALK_NAME:String = "talk";
      
      private static const DEFAULT_REJECT_CLASS:Class = DragCursorBase_DEFAULT_REJECT_CLASS;
      
      protected static const DRAG_TYPE_STATUSWIDGET:String = "statusWidget";
      
      protected static const DRAG_TYPE_OBJECT:String = "object";
      
      public static const CURSOR_WALK_NAME:String = "walk";
      
      protected static const DRAG_OPACITY:Number = 0.75;
      
      public static const CURSOR_DEFAULT_REJECT_NAME:String = "defaultReject";
      
      public static const CURSOR_USE_NAME:String = "use";
      
      private static const CROSSHAIR_REJECT_CLASS:Class = DragCursorBase_CROSSHAIR_REJECT_CLASS;
      
      public static const CURSOR_CROSSHAIR_NAME:String = "crosshair";
      
      public static const CURSOR_DEFAULT_NAME:String = "default";
      
      protected static const DRAG_TYPE_SPELL:String = "spell";
      
      protected static const DRAG_TYPE_WIDGETBASE:String = "widgetBase";
      
      public static const CURSOR_OPEN_NAME:String = "open";
      
      {
         s_RegisterNative();
      }
      
      public function DragCursorBase()
      {
         super();
      }
      
      private static function s_RegisterNative() : void
      {
         var _loc1_:MouseCursorData = null;
         _loc1_ = new MouseCursorData();
         _loc1_.data = new Vector.<BitmapData>();
         _loc1_.data[0] = Bitmap(new DEFAULT_MOVE_CLASS()).bitmapData;
         _loc1_.frameRate = 0;
         _loc1_.hotSpot = new Point(1,0);
         Mouse.registerCursor("dragDefaultMove",_loc1_);
         _loc1_ = new MouseCursorData();
         _loc1_.data = new Vector.<BitmapData>();
         _loc1_.data[0] = Bitmap(new DEFAULT_REJECT_CLASS()).bitmapData;
         _loc1_.frameRate = 0;
         _loc1_.hotSpot = new Point(1,0);
         Mouse.registerCursor("dragDefaultReject",_loc1_);
         _loc1_ = new MouseCursorData();
         _loc1_.data = new Vector.<BitmapData>();
         _loc1_.data[0] = Bitmap(new CROSSHAIR_MOVE_CLASS()).bitmapData;
         _loc1_.frameRate = 0;
         _loc1_.hotSpot = new Point(10,9);
         Mouse.registerCursor("dragCrosshairMove",_loc1_);
         _loc1_ = new MouseCursorData();
         _loc1_.data = new Vector.<BitmapData>();
         _loc1_.data[0] = Bitmap(new CROSSHAIR_REJECT_CLASS()).bitmapData;
         _loc1_.frameRate = 0;
         _loc1_.hotSpot = new Point(10,9);
         Mouse.registerCursor("dragCrosshairReject",_loc1_);
      }
      
      public static function get CURSOR_NAME() : String
      {
         var _loc1_:DragProxy = null;
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc4_:String = null;
         if(DragManager.isDragging)
         {
            _loc1_ = DragManager.mx_internal::dragProxy;
            _loc2_ = null;
            _loc3_ = _loc1_.dragSource != null && _loc1_.dragSource.hasFormat("dragType")?_loc1_.dragSource.dataForFormat("dragType") as String:null;
            switch(_loc3_)
            {
               case DRAG_TYPE_OBJECT:
               case DRAG_TYPE_ACTION:
                  _loc2_ = "Crosshair";
                  break;
               default:
                  _loc2_ = "Default";
            }
            _loc4_ = null;
            switch(_loc1_.action)
            {
               case DragManager.COPY:
               case DragManager.LINK:
               case DragManager.MOVE:
                  _loc4_ = "Move";
                  break;
               case DragManager.NONE:
                  _loc4_ = "Reject";
                  break;
               default:
                  _loc4_ = "Reject";
            }
            return "drag" + _loc2_ + _loc4_;
         }
         return "auto";
      }
   }
}
