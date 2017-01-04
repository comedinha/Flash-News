package tibia.worldmap.widgetClasses
{
   import flash.display.BitmapData;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import tibia.appearances.AppearanceInstance;
   import tibia.appearances.AppearanceType;
   import tibia.appearances.FrameGroup;
   import tibia.creatures.Creature;
   
   public class ObjectCursor extends TileCursor
   {
      
      protected static const RENDERER_DEFAULT_HEIGHT:Number = MAP_WIDTH * FIELD_SIZE;
      
      protected static const NUM_EFFECTS:int = 200;
      
      protected static const MAP_HEIGHT:int = 11;
      
      protected static const s_TempPoint2:Point = new Point(0,0);
      
      protected static const RENDERER_DEFAULT_WIDTH:Number = MAP_WIDTH * FIELD_SIZE;
      
      protected static const ONSCREEN_MESSAGE_WIDTH:int = 295;
      
      protected static const FIELD_ENTER_POSSIBLE:uint = 0;
      
      protected static const FIELD_ENTER_NOT_POSSIBLE:uint = 2;
      
      protected static const UNDERGROUND_LAYER:int = 2;
      
      protected static const NUM_FIELDS:int = MAPSIZE_Z * MAPSIZE_Y * MAPSIZE_X;
      
      protected static const FIELD_HEIGHT:int = 24;
      
      protected static const FIELD_CACHESIZE:int = FIELD_SIZE;
      
      protected static const ONSCREEN_MESSAGE_HEIGHT:int = 195;
      
      protected static const MAP_MIN_X:int = 24576;
      
      protected static const MAP_MIN_Y:int = 24576;
      
      protected static const MAP_MIN_Z:int = 0;
      
      protected static const PLAYER_OFFSET_Y:int = 6;
      
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
      
      protected static const MAP_WIDTH:int = 15;
      
      protected static const NUM_ONSCREEN_MESSAGES:int = 16;
      
      protected static const GROUND_LAYER:int = 7;
       
      
      private var m_MaskRect:Rectangle;
      
      private var m_MaskBitmapData:BitmapData = null;
      
      public function ObjectCursor()
      {
         this.m_MaskRect = new Rectangle(0,0,0,0);
         super();
      }
      
      public static function createFromColor(param1:uint, param2:Number, param3:Number, param4:int, param5:Number, param6:Number) : ObjectCursor
      {
         var _loc11_:Number = NaN;
         var _loc12_:uint = 0;
         if(param2 < 0 || param3 > 1)
         {
            throw new ArgumentError("ObjectCursor.createFromColor: Invalid minimum opacity.");
         }
         if(param3 < 0 || param3 > 1)
         {
            throw new ArgumentError("ObjectCursor.createFromColor: Invalid maximum opacity.");
         }
         if(param2 > param3)
         {
            throw new ArgumentError("ObjectCursor.createFromColor: Minimum opacity must not exceed maximum opacity.");
         }
         if(param4 < 1)
         {
            throw new ArgumentError("ObjectCursor.createFromColor: Invalid frame count.");
         }
         if(param5 < 1)
         {
            throw new ArgumentError("ObjectCursor.createFromColor: Invalid frame size.");
         }
         if(param6 < 0)
         {
            throw new ArgumentError("ObjectCursor.createFromColor: Invalid frame duration.");
         }
         var _loc7_:BitmapData = new BitmapData(param4 * param5,param5);
         var _loc8_:int = int(param4 / 2);
         var _loc9_:int = 0;
         while(_loc9_ < param4)
         {
            _loc11_ = 0;
            if(_loc9_ < _loc8_)
            {
               _loc11_ = 1 - _loc9_ / _loc8_;
            }
            else if(_loc9_ > param4 - _loc8_)
            {
               _loc11_ = (_loc9_ - (param4 - _loc8_)) / _loc8_;
            }
            _loc11_ = _loc11_ * param3 + (1 - _loc11_) * param2;
            _loc11_ = _loc11_ * 255;
            _loc12_ = uint(_loc11_) << 24 | param1 & 16777215;
            s_TempRect.setTo(_loc9_ * param5,0,param5,param5);
            _loc7_.fillRect(s_TempRect,_loc12_);
            _loc9_++;
         }
         var _loc10_:ObjectCursor = new ObjectCursor();
         _loc10_.bitmapData = _loc7_;
         _loc10_.frameDuration = param6;
         return _loc10_;
      }
      
      public function get maskBitmapData() : BitmapData
      {
         return this.m_MaskBitmapData;
      }
      
      public function copyMaskFromCreature(param1:Creature) : void
      {
         s_TempPoint.setTo(0,0);
         this.m_MaskRect.setTo(0,0,0,0);
         var _loc2_:AppearanceType = null;
         if(param1.outfit != null && (_loc2_ = param1.outfit.type) != null)
         {
            this.m_MaskRect.width = Math.max(this.m_MaskRect.width,_loc2_.FrameGroups[FrameGroup.FRAME_GROUP_DEFAULT].width * FIELD_SIZE + _loc2_.displacementX);
            this.m_MaskRect.height = Math.max(this.m_MaskRect.height,_loc2_.FrameGroups[FrameGroup.FRAME_GROUP_DEFAULT].height * FIELD_SIZE + _loc2_.displacementY);
            s_TempPoint.setTo(_loc2_.displacementX,_loc2_.displacementY);
         }
         if(param1.mountOutfit != null && (_loc2_ = param1.mountOutfit.type) != null)
         {
            this.m_MaskRect.width = Math.max(this.m_MaskRect.width,_loc2_.FrameGroups[FrameGroup.FRAME_GROUP_DEFAULT].width * FIELD_SIZE + _loc2_.displacementX) + s_TempPoint.x;
            this.m_MaskRect.height = Math.max(this.m_MaskRect.height,_loc2_.FrameGroups[FrameGroup.FRAME_GROUP_DEFAULT].height * FIELD_SIZE + _loc2_.displacementY) + s_TempPoint.y;
         }
         if(this.m_MaskBitmapData == null || this.m_MaskBitmapData.width < this.m_MaskRect.width || this.m_MaskBitmapData.height < this.m_MaskRect.height)
         {
            this.m_MaskBitmapData = new BitmapData(this.m_MaskRect.width,this.m_MaskRect.height,true,0);
         }
         else
         {
            this.m_MaskBitmapData.fillRect(this.m_MaskRect,0);
         }
         if(param1.mountOutfit != null)
         {
            param1.mountOutfit.drawTo(this.m_MaskBitmapData,this.m_MaskRect.width - s_TempPoint.x,this.m_MaskRect.height - s_TempPoint.y,param1.direction,0,0);
         }
         if(param1.outfit != null)
         {
            param1.outfit.drawTo(this.m_MaskBitmapData,this.m_MaskRect.width,this.m_MaskRect.height,param1.direction,0,param1.mountOutfit != null?1:0);
         }
      }
      
      public function copyMaskFromAppearance(param1:AppearanceInstance, param2:int = -1, param3:int = -1, param4:int = -1) : void
      {
         var _loc5_:AppearanceType = param1.type;
         this.m_MaskRect.setTo(0,0,_loc5_.FrameGroups[FrameGroup.FRAME_GROUP_DEFAULT].width * FIELD_SIZE + _loc5_.displacementX,_loc5_.FrameGroups[FrameGroup.FRAME_GROUP_DEFAULT].height * FIELD_SIZE + _loc5_.displacementY);
         if(this.m_MaskBitmapData == null || this.m_MaskBitmapData.width < this.m_MaskRect.width || this.m_MaskBitmapData.height < this.m_MaskRect.height)
         {
            this.m_MaskBitmapData = new BitmapData(this.m_MaskRect.width,this.m_MaskRect.height,true,0);
         }
         else
         {
            this.m_MaskBitmapData.fillRect(this.m_MaskRect,0);
         }
         param1.drawTo(this.m_MaskBitmapData,this.m_MaskRect.width,this.m_MaskRect.height,param2,param3,param4);
      }
      
      public function set maskBitmapData(param1:BitmapData) : void
      {
         if(this.m_MaskBitmapData != param1)
         {
            this.m_MaskBitmapData = param1;
            if(this.m_MaskBitmapData != null)
            {
               this.m_MaskRect.setTo(0,0,this.m_MaskBitmapData.width,this.m_MaskBitmapData.height);
            }
            else
            {
               this.m_MaskRect.setTo(0,0,0,0);
            }
         }
      }
      
      public function clearMask() : void
      {
         if(this.m_MaskBitmapData != null)
         {
            this.m_MaskBitmapData.fillRect(this.m_MaskRect,0);
         }
      }
      
      public function copyMaskFromBitmap(param1:BitmapData, param2:Rectangle) : void
      {
         this.m_MaskRect.setTo(0,0,param2.width,param2.height);
         if(this.m_MaskBitmapData == null || this.m_MaskBitmapData.width < this.m_MaskRect.width || this.m_MaskBitmapData.height < this.m_MaskRect.height)
         {
            this.m_MaskBitmapData = new BitmapData(this.m_MaskRect.width,this.m_MaskRect.height,true,0);
         }
         else
         {
            this.m_MaskBitmapData.fillRect(this.m_MaskRect,0);
         }
         this.m_MaskBitmapData.copyPixels(param1,this.m_MaskRect,s_TempPoint2);
      }
      
      override public function drawTo(param1:BitmapData, param2:Number, param3:Number, param4:Number = NaN) : void
      {
         commitProperties();
         s_TempRect.setTo((getFrameIndex(param4) + 1) * m_CachedFrameSize.width - this.m_MaskRect.width,m_CachedFrameSize.height - this.m_MaskRect.height,this.m_MaskRect.width,this.m_MaskRect.height);
         s_TempPoint.setTo(param2 - this.m_MaskRect.width,param3 - this.m_MaskRect.height);
         param1.copyPixels(m_CachedBitmapData,s_TempRect,s_TempPoint,this.m_MaskBitmapData,s_TempPoint2,true);
      }
   }
}
