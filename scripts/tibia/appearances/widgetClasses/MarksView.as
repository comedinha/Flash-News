package tibia.appearances.widgetClasses
{
   import flash.display.BitmapData;
   import flash.geom.Rectangle;
   import tibia.appearances.Marks;
   import shared.utility.Colour;
   import mx.core.FlexShape;
   import flash.display.Graphics;
   import flash.display.LineScaleMode;
   import flash.utils.Dictionary;
   import flash.geom.Point;
   
   public class MarksView
   {
      
      protected static const RENDERER_DEFAULT_HEIGHT:Number = MAP_WIDTH * FIELD_SIZE;
      
      public static var s_FrameCache:BitmapData = null;
      
      protected static const NUM_EFFECTS:int = 200;
      
      protected static const MAP_HEIGHT:int = 11;
      
      protected static const RENDERER_DEFAULT_WIDTH:Number = MAP_WIDTH * FIELD_SIZE;
      
      protected static const ONSCREEN_MESSAGE_WIDTH:int = 295;
      
      protected static const FIELD_ENTER_POSSIBLE:uint = 0;
      
      protected static const FIELD_ENTER_NOT_POSSIBLE:uint = 2;
      
      protected static const UNDERGROUND_LAYER:int = 2;
      
      protected static const NUM_FIELDS:int = MAPSIZE_Z * MAPSIZE_Y * MAPSIZE_X;
      
      protected static const FIELD_HEIGHT:int = 24;
      
      private static var s_TempMarkBitmap:BitmapData = null;
      
      protected static const FIELD_CACHESIZE:int = FIELD_SIZE;
      
      protected static const ONSCREEN_MESSAGE_HEIGHT:int = 195;
      
      private static var s_FrameMarks:BitmapData = null;
      
      protected static const MAP_MIN_X:int = 24576;
      
      protected static const MAP_MIN_Y:int = 24576;
      
      protected static const MAP_MIN_Z:int = 0;
      
      protected static const PLAYER_OFFSET_Y:int = 6;
      
      private static var s_FrameCacheRectangles:Vector.<Rectangle> = null;
      
      protected static const FIELD_SIZE:int = 32;
      
      protected static const FIELD_ENTER_POSSIBLE_NO_ANIMATION:uint = 1;
      
      protected static const RENDERER_MIN_HEIGHT:Number = Math.round(MAP_HEIGHT * 2 / 3 * FIELD_SIZE);
      
      protected static const PLAYER_OFFSET_X:int = 8;
      
      protected static const MAPSIZE_W:int = 10;
      
      protected static const MAPSIZE_X:int = MAP_WIDTH + 3;
      
      protected static const MAPSIZE_Y:int = MAP_HEIGHT + 3;
      
      protected static const MAPSIZE_Z:int = 8;
      
      protected static const MAP_MAX_X:int = MAP_MIN_X + (1 << 14 - 1);
      
      protected static const MAP_MAX_Y:int = MAP_MIN_Y + (1 << 14 - 1);
      
      protected static const MAP_MAX_Z:int = 15;
      
      protected static const RENDERER_MIN_WIDTH:Number = Math.round(MAP_WIDTH * 2 / 3 * FIELD_SIZE);
      
      public static var s_NextFrameCacheIndex:uint = 0;
      
      protected static const MAP_WIDTH:int = 15;
      
      public static const MARK_THICKNESS_THIN:uint = 1;
      
      protected static const NUM_ONSCREEN_MESSAGES:int = 16;
      
      private static var s_FrameColors:Vector.<uint> = null;
      
      public static const MARK_THICKNESS_BOLD:uint = 2;
      
      public static const FRAME_SIZES_COUNT:uint = 15;
      
      private static var s_FrameCacheDictionary:Dictionary = null;
      
      protected static const GROUND_LAYER:int = 7;
      
      private static const CACHE_DIMENSION:uint = 10;
      
      {
         s_InitialiseFrameMarks();
      }
      
      private var m_MarksViewInformations:Vector.<MarksViewInformation> = null;
      
      private var m_MarksStartSize:uint = 0;
      
      public function MarksView(param1:uint = 0)
      {
         super();
         if(param1 >= FRAME_SIZES_COUNT)
         {
            throw new Error("MarksView.MarksView: Invalid marks start size.");
         }
         this.m_MarksStartSize = param1;
         this.m_MarksViewInformations = new Vector.<MarksViewInformation>();
      }
      
      private static function s_CreateCacheKey(param1:Vector.<uint>) : String
      {
         if(param1.length % 2 != 0)
         {
            throw new ArgumentError("Marks.s_CreateCacheKey: Invalid Frame Information");
         }
         return param1.join(",");
      }
      
      public static function s_MarkThickness(param1:uint) : uint
      {
         return param1 / FRAME_SIZES_COUNT + 1;
      }
      
      private static function s_InitialiseFrameMarks() : void
      {
         var _loc9_:uint = 0;
         var _loc1_:int = 0;
         s_FrameColors = new Vector.<uint>(Marks.MARK_NUM_TOTAL,true);
         _loc1_ = 0;
         while(_loc1_ < Marks.MARK_NUM_COLOURS)
         {
            s_FrameColors[_loc1_] = Colour.s_RGBFromEightBit(_loc1_);
            _loc1_++;
         }
         s_FrameColors[Marks.MARK_AIM] = 248 << 16 | 248 << 8 | 248;
         s_FrameColors[Marks.MARK_AIM_ATTACK] = 248 << 16 | 164 << 8 | 164;
         s_FrameColors[Marks.MARK_AIM_FOLLOW] = 180 << 16 | 248 << 8 | 180;
         s_FrameColors[Marks.MARK_ATTACK] = 224 << 16 | 64 << 8 | 64;
         s_FrameColors[Marks.MARK_FOLLOW] = 64 << 16 | 224 << 8 | 64;
         var _loc2_:FlexShape = new FlexShape();
         var _loc3_:Graphics = _loc2_.graphics;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         _loc3_.lineStyle(1,4278190080,1,true,LineScaleMode.NONE);
         var _loc7_:uint = 0;
         _loc7_ = 0;
         while(_loc7_ < FRAME_SIZES_COUNT)
         {
            _loc3_.drawRect(_loc7_ * FIELD_SIZE + _loc7_,_loc7_,FIELD_SIZE - _loc7_ * 2 - 1,FIELD_SIZE - _loc7_ * 2 - 1);
            _loc3_.drawRect(_loc7_ * FIELD_SIZE + _loc7_,FIELD_SIZE + _loc7_,FIELD_SIZE - _loc7_ * 2 - 1,FIELD_SIZE - _loc7_ * 2 - 1);
            _loc3_.drawRect(_loc7_ * FIELD_SIZE + _loc7_ + 1,FIELD_SIZE + _loc7_ + 1,FIELD_SIZE - (_loc7_ + 1) * 2 - 1,FIELD_SIZE - (_loc7_ + 1) * 2 - 1);
            _loc7_++;
         }
         s_FrameMarks = new BitmapData(FRAME_SIZES_COUNT * FIELD_SIZE,FIELD_SIZE * 2,true,0);
         s_FrameMarks.draw(_loc2_);
         s_TempMarkBitmap = new BitmapData(FIELD_SIZE,FIELD_SIZE,true,0);
         s_FrameCache = new BitmapData(CACHE_DIMENSION * FIELD_SIZE,CACHE_DIMENSION * FIELD_SIZE,true,16777215);
         s_FrameCacheRectangles = new Vector.<Rectangle>(CACHE_DIMENSION * CACHE_DIMENSION,true);
         var _loc8_:uint = 0;
         while(_loc8_ < CACHE_DIMENSION)
         {
            _loc9_ = 0;
            while(_loc9_ < CACHE_DIMENSION)
            {
               s_FrameCacheRectangles[_loc9_ * CACHE_DIMENSION + _loc8_] = new Rectangle(_loc8_ * FIELD_SIZE,_loc9_ * FIELD_SIZE,FIELD_SIZE,FIELD_SIZE);
               _loc9_++;
            }
            _loc8_++;
         }
         s_FrameCacheDictionary = new Dictionary();
      }
      
      public function addMarkToView(param1:uint, param2:uint) : void
      {
         var _loc4_:MarksViewInformation = null;
         if(param2 != MARK_THICKNESS_THIN && param2 != MARK_THICKNESS_BOLD)
         {
            throw new Error("MarksView.addMarkToView: Invalid marks thickness: " + param2);
         }
         var _loc3_:uint = this.m_MarksStartSize;
         for each(_loc4_ in this.m_MarksViewInformations)
         {
            _loc3_ = _loc3_ + _loc4_.m_MarkThickness;
         }
         if(_loc3_ + param2 > FRAME_SIZES_COUNT)
         {
            throw new Error("MarksView.addMarkToView: Adding this mark will exceed the minimum frame size");
         }
         var _loc5_:MarksViewInformation = new MarksViewInformation();
         _loc5_.m_MarkType = param1;
         _loc5_.m_MarkThickness = param2;
         this.m_MarksViewInformations.push(_loc5_);
      }
      
      public function getMarksBitmap(param1:Marks, param2:Rectangle) : BitmapData
      {
         var _loc6_:MarksViewInformation = null;
         var _loc7_:String = null;
         var _loc8_:Rectangle = null;
         var _loc9_:uint = 0;
         var _loc10_:* = null;
         var _loc11_:uint = 0;
         var _loc12_:uint = 0;
         var _loc3_:Vector.<uint> = new Vector.<uint>();
         var _loc4_:uint = this.m_MarksStartSize;
         var _loc5_:uint = 0;
         for each(_loc6_ in this.m_MarksViewInformations)
         {
            if(param1.isMarkSet(_loc6_.m_MarkType))
            {
               _loc3_.push(_loc4_ + (_loc6_.m_MarkThickness - 1) * FRAME_SIZES_COUNT);
               _loc4_ = _loc4_ + _loc6_.m_MarkThickness;
               _loc3_.push(param1.getMarkColor(_loc6_.m_MarkType));
            }
         }
         _loc7_ = s_CreateCacheKey(_loc3_);
         _loc8_ = null;
         _loc9_ = 0;
         if(s_FrameCacheDictionary.hasOwnProperty(_loc7_))
         {
            _loc9_ = s_FrameCacheDictionary[_loc7_];
            _loc8_ = s_FrameCacheRectangles[_loc9_];
         }
         else
         {
            _loc9_ = s_NextFrameCacheIndex++ % s_FrameCacheRectangles.length;
            for(_loc10_ in s_FrameCacheDictionary)
            {
               if(uint(s_FrameCacheDictionary[_loc10_]) == _loc9_)
               {
                  delete s_FrameCacheDictionary[_loc10_];
                  break;
               }
            }
            _loc8_ = s_FrameCacheRectangles[_loc9_];
            s_FrameCache.fillRect(_loc8_,0);
            _loc5_ = 0;
            while(_loc5_ < _loc3_.length)
            {
               _loc11_ = _loc3_[_loc5_];
               _loc12_ = _loc3_[_loc5_ + 1];
               if(_loc12_ < Marks.MARK_NUM_TOTAL)
               {
                  s_TempMarkBitmap.fillRect(s_TempMarkBitmap.rect,4278190080 | s_FrameColors[_loc12_]);
                  s_FrameCache.copyPixels(s_TempMarkBitmap,s_TempMarkBitmap.rect,_loc8_.topLeft,s_FrameMarks,new Point(_loc11_ % FRAME_SIZES_COUNT * FIELD_SIZE,int(_loc11_ / FRAME_SIZES_COUNT) * FIELD_SIZE),true);
               }
               _loc5_ = _loc5_ + 2;
            }
            s_FrameCacheDictionary[_loc7_] = _loc9_;
         }
         param2.copyFrom(_loc8_);
         return s_FrameCache;
      }
      
      public function get marksStartSize() : uint
      {
         return this.m_MarksStartSize;
      }
   }
}

class MarksViewInformation
{
    
   
   public var m_MarkType:uint = 255;
   
   public var m_MarkThickness:uint = 1;
   
   function MarksViewInformation()
   {
      super();
   }
}
