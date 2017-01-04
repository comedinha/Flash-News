package tibia.worldmap
{
   import flash.display.BitmapData;
   import flash.geom.Rectangle;
   import shared.utility.Colour;
   import tibia.appearances.AppearanceInstance;
   import tibia.appearances.AppearanceStorage;
   import tibia.appearances.AppearanceType;
   import tibia.appearances.FrameGroup;
   import tibia.appearances.ObjectInstance;
   import tibia.§worldmap:ns_map_internal§.s_CacheBitmap;
   
   public class Field
   {
      
      protected static const RENDERER_DEFAULT_HEIGHT:Number = MAP_WIDTH * FIELD_SIZE;
      
      private static const ACTION_LOOK:int = 6;
      
      protected static const NUM_EFFECTS:int = 200;
      
      private static const ACTION_SMARTCLICK:int = 100;
      
      protected static const PATH_SOUTH:int = 7;
      
      private static const ACTION_TALK:int = 9;
      
      protected static const ONSCREEN_MESSAGE_WIDTH:int = 295;
      
      protected static const MM_SECTOR_SIZE:int = 256;
      
      protected static const FIELD_ENTER_POSSIBLE:uint = 0;
      
      protected static const PATH_ERROR_GO_DOWNSTAIRS:int = -1;
      
      private static const MOUSE_BUTTON_MIDDLE:int = 3;
      
      protected static const PATH_NORTH_WEST:int = 4;
      
      protected static const MM_IE_TIMEOUT:Number = 50;
      
      protected static const MM_IO_TIMEOUT:Number = 500;
      
      protected static const MM_SIDEBAR_ZOOM_MIN:int = -1;
      
      protected static const FIELD_ENTER_NOT_POSSIBLE:uint = 2;
      
      protected static const FIELD_HEIGHT:int = 24;
      
      protected static const MM_COLOUR_DEFAULT:uint = 0;
      
      protected static const PATH_COST_OBSTACLE:int = 255;
      
      protected static const UNDERGROUND_LAYER:int = 2;
      
      protected static const ONSCREEN_MESSAGE_HEIGHT:int = 195;
      
      private static const MOUSE_BUTTON_RIGHT:int = 2;
      
      protected static const MM_SIDEBAR_ZOOM_MAX:int = 2;
      
      private static var s_CacheCount:int = 0;
      
      protected static const FIELD_CACHESIZE:int = FIELD_SIZE;
      
      protected static const PATH_ERROR_UNREACHABLE:int = -4;
      
      protected static const FIELD_SIZE:int = 32;
      
      protected static const FIELD_ENTER_POSSIBLE_NO_ANIMATION:uint = 1;
      
      protected static const PLAYER_OFFSET_X:int = 8;
      
      protected static const PLAYER_OFFSET_Y:int = 6;
      
      protected static const MAP_MAX_X:int = MAP_MIN_X + (1 << 14 - 1);
      
      protected static const MAP_MAX_Y:int = MAP_MIN_Y + (1 << 14 - 1);
      
      protected static const MAP_MAX_Z:int = 15;
      
      protected static const PATH_NORTH:int = 3;
      
      static var s_CacheBitmap:BitmapData = new BitmapData(MAPSIZE_X * FIELD_CACHESIZE,MAPSIZE_Y * MAPSIZE_Z * FIELD_CACHESIZE,true,4278255360);
      
      protected static const NUM_ONSCREEN_MESSAGES:int = 16;
      
      protected static const PATH_MAX_DISTANCE:int = 110;
      
      protected static const MM_SIDEBAR_VIEW_WIDTH:int = 106;
      
      protected static const PATH_NORTH_EAST:int = 2;
      
      protected static const PATH_SOUTH_WEST:int = 6;
      
      protected static const MM_SIDEBAR_VIEW_HEIGHT:int = 106;
      
      private static const ACTION_ATTACK:int = 1;
      
      protected static const GROUND_LAYER:int = 7;
      
      private static const ACTION_CONTEXT_MENU:int = 5;
      
      protected static const PATH_WEST:int = 5;
      
      protected static const MAP_HEIGHT:int = 11;
      
      protected static const PATH_ERROR_INTERNAL:int = -5;
      
      protected static const RENDERER_DEFAULT_WIDTH:Number = MAP_WIDTH * FIELD_SIZE;
      
      protected static const PATH_COST_UNDEFINED:int = 254;
      
      protected static const PATH_EMPTY:int = 0;
      
      protected static const PATH_ERROR_TOO_FAR:int = -3;
      
      private static const ACTION_NONE:int = 0;
      
      protected static const PATH_MATRIX_SIZE:int = 2 * PATH_MAX_DISTANCE + 1;
      
      protected static const MM_STORAGE_MIN_VERSION:int = 1;
      
      protected static const PATH_SOUTH_EAST:int = 8;
      
      protected static const PATH_ERROR_GO_UPSTAIRS:int = -2;
      
      private static const MOUSE_BUTTON_LEFT:int = 1;
      
      protected static const NUM_FIELDS:int = MAPSIZE_Z * MAPSIZE_Y * MAPSIZE_X;
      
      protected static const PATH_COST_MAX:int = 250;
      
      protected static const PATH_MAX_STEPS:int = 128;
      
      protected static const MM_STORAGE_MAX_VERSION:int = 1;
      
      private static const MOUSE_BUTTON_BOTH:int = 4;
      
      protected static const MM_CACHE_SIZE:int = 48;
      
      private static const ACTION_UNSET:int = -1;
      
      protected static const PATH_EXISTS:int = 1;
      
      protected static const MAP_MIN_X:int = 24576;
      
      protected static const MAP_MIN_Y:int = 24576;
      
      protected static const MAP_MIN_Z:int = 0;
      
      private static const ACTION_OPEN:int = 8;
      
      private static const ACTION_USE_OR_OPEN:int = 101;
      
      protected static const RENDERER_MIN_HEIGHT:Number = Math.round(MAP_HEIGHT * 2 / 3 * FIELD_SIZE);
      
      private static const ACTION_ATTACK_OR_TALK:int = 102;
      
      protected static const MAPSIZE_W:int = 10;
      
      protected static const MAPSIZE_X:int = MAP_WIDTH + 3;
      
      protected static const MAPSIZE_Y:int = MAP_HEIGHT + 3;
      
      protected static const MAPSIZE_Z:int = 8;
      
      protected static const MM_SIDEBAR_HIGHLIGHT_DURATION:Number = 10000;
      
      protected static const RENDERER_MIN_WIDTH:Number = Math.round(MAP_WIDTH * 2 / 3 * FIELD_SIZE);
      
      protected static const PATH_EAST:int = 1;
      
      private static const ACTION_AUTOWALK:int = 3;
      
      protected static const MAP_WIDTH:int = 15;
      
      private static const ACTION_USE:int = 7;
      
      protected static const PATH_MATRIX_CENTER:int = PATH_MAX_DISTANCE;
      
      private static const ACTION_AUTOWALK_HIGHLIGHT:int = 4;
      
      {
         s_CacheBitmap.lock();
      }
      
      var m_MiniMapCost:int = 2.147483647E9;
      
      var m_ObjectsRenderer:Vector.<ObjectInstance> = null;
      
      var m_CacheObjectsCount:int = 0;
      
      var m_ObjectsCount:int = 0;
      
      var m_Effects:Vector.<AppearanceInstance> = null;
      
      var m_Environment:ObjectInstance = null;
      
      var m_CacheLyingObject:Boolean = false;
      
      var m_CacheTranslucent:Boolean = false;
      
      var m_CacheObjectsHeight:int = 0;
      
      var m_ObjectsNetwork:Vector.<ObjectInstance> = null;
      
      var m_CacheBitmapDirty:Boolean = false;
      
      var m_MiniMapColour:uint = 0;
      
      var m_CacheRectangle:Rectangle = null;
      
      var m_CacheObjectsDirty:Boolean = false;
      
      var m_EffectsCount:int = 0;
      
      var m_CacheUnsight:Boolean = false;
      
      var m_MiniMapDirty:Boolean = false;
      
      public function Field()
      {
         super();
         s_AllocateCache(this);
         this.m_ObjectsNetwork = new Vector.<ObjectInstance>(MAPSIZE_W,true);
         this.m_ObjectsRenderer = new Vector.<ObjectInstance>(MAPSIZE_W,true);
         this.m_Effects = new Vector.<AppearanceInstance>();
      }
      
      private static function s_AllocateCache(param1:Field) : void
      {
         if(s_CacheCount >= NUM_FIELDS)
         {
            throw new Error("Field.s_AllocateCache: Allocation limit exceeded.");
         }
         var _loc2_:int = s_CacheCount % MAPSIZE_X;
         var _loc3_:int = int(s_CacheCount / MAPSIZE_X);
         param1.m_CacheRectangle = new Rectangle(_loc2_ * FIELD_CACHESIZE,_loc3_ * FIELD_CACHESIZE,FIELD_CACHESIZE,FIELD_CACHESIZE);
         s_CacheCount++;
      }
      
      function getObjectPriority(param1:ObjectInstance) : int
      {
         var _loc2_:AppearanceType = param1.type;
         if(_loc2_.isBank)
         {
            return 0;
         }
         if(_loc2_.isClip)
         {
            return 1;
         }
         if(_loc2_.isBottom)
         {
            return 2;
         }
         if(_loc2_.isTop)
         {
            return 3;
         }
         if(_loc2_.ID == AppearanceInstance.CREATURE)
         {
            return 4;
         }
         return 5;
      }
      
      public function getEffect(param1:int) : AppearanceInstance
      {
         return this.m_Effects[param1];
      }
      
      public function changeObject(param1:ObjectInstance, param2:int) : ObjectInstance
      {
         if(param1 == null)
         {
            return null;
         }
         if(param2 < 0 || param2 >= this.m_ObjectsCount)
         {
            return null;
         }
         var _loc3_:ObjectInstance = this.m_ObjectsNetwork[param2];
         this.m_ObjectsNetwork[param2] = param1;
         this.m_CacheObjectsDirty = true;
         this.m_CacheBitmapDirty = true;
         this.m_MiniMapDirty = true;
         return _loc3_;
      }
      
      public function updateBitmapCache(param1:int, param2:int, param3:int) : void
      {
         var _loc5_:ObjectInstance = null;
         var _loc6_:AppearanceType = null;
         if(!this.m_CacheBitmapDirty)
         {
            return;
         }
         this.m_CacheBitmapDirty = false;
         this.updateObjectsCache();
         this.m_CacheObjectsCount = 0;
         this.m_CacheObjectsHeight = 0;
         this.m_CacheLyingObject = false;
         s_CacheBitmap.fillRect(this.m_CacheRectangle,0);
         var _loc4_:int = this.getTopLookObject();
         while(this.m_CacheObjectsCount < _loc4_)
         {
            _loc5_ = this.m_ObjectsRenderer[this.m_CacheObjectsCount];
            _loc6_ = _loc5_.type;
            if(!_loc6_.isCachable || _loc6_.FrameGroups[FrameGroup.FRAME_GROUP_DEFAULT].exactSize + Math.max(_loc6_.displacementX,_loc6_.displacementY) + this.m_CacheObjectsHeight > FIELD_CACHESIZE)
            {
               break;
            }
            _loc5_.drawTo(s_CacheBitmap,this.m_CacheRectangle.right - this.m_CacheObjectsHeight,this.m_CacheRectangle.bottom - this.m_CacheObjectsHeight,param1,param2,param3);
            this.m_CacheBitmapDirty = this.m_CacheBitmapDirty || _loc5_.cacheDirty;
            this.m_CacheObjectsHeight = Math.min(this.m_CacheObjectsHeight + _loc6_.elevation,FIELD_HEIGHT);
            this.m_CacheLyingObject = this.m_CacheLyingObject || _loc6_.isLyingObject;
            if(this.m_CacheBitmapDirty)
            {
               break;
            }
            this.m_CacheObjectsCount++;
         }
      }
      
      function deleteEffect(param1:int) : void
      {
         if(param1 < 0 || param1 >= this.m_EffectsCount)
         {
            throw new ArgumentError("Field.deleteEffect: Index is out of range: " + param1 + ".");
         }
         this.m_Effects[param1].mapData = -1;
         this.m_Effects[param1] = null;
         this.m_EffectsCount--;
         var _loc2_:int = param1;
         while(_loc2_ < this.m_EffectsCount)
         {
            this.m_Effects[_loc2_] = this.m_Effects[_loc2_ + 1];
            this.m_Effects[_loc2_].mapData = _loc2_;
            _loc2_++;
         }
      }
      
      public function putObject(param1:ObjectInstance, param2:int) : ObjectInstance
      {
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         if(param1 == null)
         {
            return null;
         }
         if(param2 < 0)
         {
            param2 = 0;
            _loc5_ = this.getObjectPriority(param1);
            while(param2 < this.m_ObjectsCount)
            {
               _loc6_ = this.getObjectPriority(this.m_ObjectsNetwork[param2]);
               if(_loc6_ > _loc5_ || _loc6_ == _loc5_ && _loc6_ == 5)
               {
                  break;
               }
               param2++;
            }
            if(param2 >= MAPSIZE_W)
            {
               return param1;
            }
         }
         else if(param2 <= this.m_ObjectsCount || param2 == MAPSIZE_W)
         {
            param2 = Math.min(param2,this.m_ObjectsCount,MAPSIZE_W - 1);
         }
         else
         {
            return null;
         }
         var _loc3_:ObjectInstance = null;
         if(this.m_ObjectsCount >= MAPSIZE_W)
         {
            this.m_ObjectsCount = MAPSIZE_W;
            _loc3_ = this.m_ObjectsNetwork[MAPSIZE_W - 1];
         }
         else
         {
            this.m_ObjectsCount++;
         }
         var _loc4_:int = this.m_ObjectsCount - 1;
         while(_loc4_ > param2)
         {
            this.m_ObjectsNetwork[_loc4_] = this.m_ObjectsNetwork[_loc4_ - 1];
            _loc4_--;
         }
         this.m_ObjectsNetwork[param2] = param1;
         this.m_CacheObjectsDirty = true;
         this.m_CacheBitmapDirty = true;
         this.m_MiniMapDirty = true;
         return _loc3_;
      }
      
      public function getObject(param1:int) : ObjectInstance
      {
         if(param1 == 0 && this.m_ObjectsCount == 0)
         {
            return null;
         }
         if(param1 < 0 || param1 >= this.m_ObjectsCount)
         {
            return null;
         }
         return this.m_ObjectsNetwork[param1];
      }
      
      public function updateObjectsCache() : void
      {
         if(!this.m_CacheObjectsDirty)
         {
            return;
         }
         this.m_CacheObjectsDirty = false;
         var _loc1_:int = 0;
         var _loc2_:int = this.m_ObjectsCount;
         var _loc3_:AppearanceType = null;
         _loc1_ = 0;
         while(_loc1_ < this.m_ObjectsCount && ((_loc3_ = this.m_ObjectsNetwork[_loc1_].type).isBank || _loc3_.isClip || _loc3_.isBottom))
         {
            this.m_ObjectsRenderer[_loc1_] = this.m_ObjectsNetwork[_loc1_];
            _loc1_++;
         }
         while(_loc1_ < this.m_ObjectsCount)
         {
            this.m_ObjectsRenderer[_loc1_] = this.m_ObjectsNetwork[--_loc2_];
            _loc1_++;
         }
         while(_loc1_ < MAPSIZE_W)
         {
            this.m_ObjectsRenderer[_loc1_] = null;
            _loc1_++;
         }
         var _loc4_:ObjectInstance = null;
         var _loc5_:AppearanceType = null;
         this.m_CacheTranslucent = false;
         this.m_CacheUnsight = false;
         _loc1_ = 0;
         while(_loc1_ < this.m_ObjectsCount)
         {
            _loc3_ = this.m_ObjectsNetwork[_loc1_].type;
            this.m_CacheTranslucent = this.m_CacheTranslucent || _loc3_.isTranslucent;
            this.m_CacheUnsight = this.m_CacheUnsight || _loc3_.isUnsight;
            if(_loc3_.isHangable)
            {
               _loc4_ = this.m_ObjectsNetwork[_loc1_];
            }
            else if(_loc3_.isHookEast || _loc3_.isHookSouth)
            {
               _loc5_ = _loc3_;
            }
            _loc1_++;
         }
         if(_loc4_ != null)
         {
            if(_loc5_ != null && _loc5_.isHookEast)
            {
               _loc4_.hang = AppearanceStorage.FLAG_HOOKEAST;
            }
            else if(_loc5_ != null)
            {
               _loc4_.hang = AppearanceStorage.FLAG_HOOKSOUTH;
            }
            else
            {
               _loc4_.hang = 0;
            }
         }
      }
      
      public function getTopLookObject(param1:Object = null) : int
      {
         var _loc5_:AppearanceType = null;
         var _loc2_:int = -1;
         var _loc3_:ObjectInstance = null;
         var _loc4_:int = 0;
         while(_loc4_ < this.m_ObjectsCount)
         {
            _loc5_ = this.m_ObjectsNetwork[_loc4_].type;
            if(!(_loc2_ != -1 && _loc5_.isIgnoreLook))
            {
               _loc2_ = _loc4_;
               _loc3_ = this.m_ObjectsNetwork[_loc4_];
               if(!_loc5_.isBank && !_loc5_.isClip && !_loc5_.isBottom && !_loc5_.isTop)
               {
                  break;
               }
            }
            _loc4_++;
         }
         if(param1 != null)
         {
            param1.position = _loc2_;
            param1.object = _loc3_;
         }
         return _loc2_;
      }
      
      function resetObjects() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < MAPSIZE_W)
         {
            this.m_ObjectsNetwork[_loc1_] = null;
            this.m_ObjectsRenderer[_loc1_] = null;
            _loc1_++;
         }
         this.m_ObjectsCount = 0;
         this.m_CacheObjectsCount = 0;
         this.m_CacheObjectsHeight = 0;
         this.m_CacheLyingObject = false;
         this.m_CacheTranslucent = false;
         this.m_CacheUnsight = false;
         this.m_CacheObjectsDirty = false;
         this.m_CacheBitmapDirty = false;
         this.m_MiniMapColour = MM_COLOUR_DEFAULT;
         this.m_MiniMapCost = PATH_COST_OBSTACLE;
         this.m_MiniMapDirty = false;
      }
      
      public function getTopUseObject(param1:Object = null) : int
      {
         var _loc4_:AppearanceType = null;
         var _loc2_:int = -1;
         var _loc3_:ObjectInstance = null;
         if(this.m_ObjectsCount > 0)
         {
            _loc4_ = null;
            _loc2_ = 0;
            while(_loc2_ < this.m_ObjectsCount - 1)
            {
               _loc4_ = this.m_ObjectsNetwork[_loc2_].type;
               if(_loc4_.isForceUse)
               {
                  break;
               }
               if(!_loc4_.isBank && !_loc4_.isClip && !_loc4_.isBottom && !_loc4_.isTop && _loc4_.ID != AppearanceInstance.CREATURE)
               {
                  break;
               }
               _loc2_++;
            }
            while(_loc2_ > 0 && ((_loc4_ = this.m_ObjectsNetwork[_loc2_].type).ID == AppearanceInstance.CREATURE || _loc4_.isLiquidPool))
            {
               _loc2_--;
            }
            _loc3_ = this.m_ObjectsNetwork[_loc2_];
         }
         if(param1 != null)
         {
            param1.position = _loc2_;
            param1.object = _loc3_;
         }
         return _loc2_;
      }
      
      public function deleteObject(param1:int) : ObjectInstance
      {
         if(param1 < 0 || param1 >= this.m_ObjectsCount)
         {
            return null;
         }
         var _loc2_:ObjectInstance = this.m_ObjectsNetwork[param1];
         this.m_ObjectsCount = Math.max(0,this.m_ObjectsCount - 1);
         while(param1 < this.m_ObjectsCount)
         {
            this.m_ObjectsNetwork[param1] = this.m_ObjectsNetwork[param1 + 1];
            param1++;
         }
         this.m_ObjectsNetwork[this.m_ObjectsCount] = null;
         this.m_CacheObjectsDirty = true;
         this.m_CacheBitmapDirty = true;
         this.m_MiniMapDirty = true;
         return _loc2_;
      }
      
      function appendEffect(param1:AppearanceInstance) : void
      {
         var _loc2_:int = 0;
         if(param1 == null)
         {
            throw new ArgumentError("Field.appendEffect: Invalid effect.");
         }
         if(param1.type != null && param1.type.isTopEffect)
         {
            this.m_Effects.unshift(param1);
            _loc2_ = 0;
            while(_loc2_ < this.m_EffectsCount + 1)
            {
               this.m_Effects[_loc2_].mapData = _loc2_;
               _loc2_++;
            }
         }
         else
         {
            this.m_Effects[this.m_EffectsCount] = param1;
            this.m_Effects[this.m_EffectsCount].mapData = this.m_EffectsCount;
         }
         this.m_EffectsCount++;
      }
      
      public function reset() : void
      {
         this.resetObjects();
         this.resetEffects();
      }
      
      function consistencyCheck() : void
      {
         var _loc2_:ObjectInstance = null;
         var _loc3_:AppearanceType = null;
         var _loc1_:int = 0;
         while(_loc1_ < this.m_ObjectsCount)
         {
            _loc2_ = this.m_ObjectsNetwork[_loc1_];
            if(_loc2_ == null)
            {
               throw new Error("Field.consistencyCheck: null object found at position " + _loc1_ + ".");
            }
            _loc3_ = _loc2_.type;
            if(_loc3_ == null)
            {
               throw new Error("Field.consistencyCheck: Object at position " + _loc1_ + " has no valid type.");
            }
            _loc1_++;
         }
      }
      
      function resetEffects() : void
      {
         var _loc1_:int = this.m_EffectsCount - 1;
         while(_loc1_ >= 0)
         {
            this.m_Effects[_loc1_] = null;
            _loc1_--;
         }
         this.m_Effects.length = 0;
         this.m_EffectsCount = 0;
         this.m_Environment = null;
      }
      
      public function getTopCreatureObject(param1:Object = null) : int
      {
         var _loc3_:ObjectInstance = null;
         var _loc2_:int = this.getTopLookObject(param1);
         if(param1.object != null)
         {
            _loc3_ = param1.object as ObjectInstance;
            if(_loc3_ != null && _loc3_.isCreature)
            {
               return _loc2_;
            }
            param1.object = undefined;
            return -1;
         }
         return -1;
      }
      
      public function getCreatureObjectForCreatureID(param1:int, param2:Object = null) : int
      {
         var _loc4_:AppearanceType = null;
         var _loc3_:int = -1;
         if(param2 != null && param1 != 0)
         {
            param2.position = -1;
            param2.object = null;
            if(this.m_ObjectsCount > 0)
            {
               _loc4_ = null;
               _loc3_ = 1;
               while(_loc3_ < this.m_ObjectsCount)
               {
                  _loc4_ = this.m_ObjectsNetwork[_loc3_].type;
                  if(_loc4_.isCreature)
                  {
                     if(this.m_ObjectsNetwork[_loc3_].data == param1)
                     {
                        if(param2 != null)
                        {
                           param2.position = _loc3_;
                           param2.object = this.m_ObjectsNetwork[_loc3_];
                        }
                        break;
                     }
                  }
                  _loc3_++;
               }
            }
            return -1;
         }
         return -1;
      }
      
      public function getTopMultiUseObject(param1:Object = null) : int
      {
         var _loc4_:AppearanceType = null;
         var _loc2_:int = -1;
         var _loc3_:ObjectInstance = null;
         if(this.m_ObjectsCount > 0)
         {
            _loc4_ = null;
            _loc2_ = 0;
            while(_loc2_ < this.m_ObjectsCount - 1)
            {
               _loc4_ = this.m_ObjectsNetwork[_loc2_].type;
               if(_loc4_.isForceUse)
               {
                  break;
               }
               if(!_loc4_.isBank && !_loc4_.isClip && !_loc4_.isBottom && !_loc4_.isTop)
               {
                  break;
               }
               _loc2_++;
            }
            if(_loc2_ > 0 && !(_loc4_ = this.m_ObjectsNetwork[_loc2_].type).isForceUse && _loc4_.isLiquidPool)
            {
               _loc2_--;
            }
            _loc3_ = this.m_ObjectsNetwork[_loc2_];
         }
         if(param1 != null)
         {
            param1.position = _loc2_;
            param1.object = _loc3_;
         }
         return _loc2_;
      }
      
      public function setEnvironmentalEffect(param1:ObjectInstance) : void
      {
         this.m_Environment = param1;
      }
      
      public function getTopMoveObject(param1:Object = null) : int
      {
         var _loc4_:AppearanceType = null;
         var _loc2_:int = -1;
         var _loc3_:ObjectInstance = null;
         if(this.m_ObjectsCount > 0)
         {
            _loc2_ = 0;
            while(_loc2_ < this.m_ObjectsCount - 1)
            {
               _loc4_ = this.m_ObjectsNetwork[_loc2_].type;
               if(!_loc4_.isBank && !_loc4_.isClip && !_loc4_.isBottom && !_loc4_.isTop && _loc4_.ID != AppearanceInstance.CREATURE)
               {
                  break;
               }
               _loc2_++;
            }
            if(_loc2_ > 0 && this.m_ObjectsNetwork[_loc2_].type.isUnmoveable)
            {
               _loc2_--;
            }
            _loc3_ = this.m_ObjectsNetwork[_loc2_];
         }
         if(param1 != null)
         {
            param1.position = _loc2_;
            param1.object = _loc3_;
         }
         return _loc2_;
      }
      
      public function getEnvironmentalEffect() : ObjectInstance
      {
         return this.m_Environment;
      }
      
      public function updateMiniMap() : void
      {
         var _loc3_:AppearanceType = null;
         if(!this.m_MiniMapDirty)
         {
            return;
         }
         this.m_MiniMapDirty = false;
         this.updateObjectsCache();
         this.m_MiniMapColour = MM_COLOUR_DEFAULT;
         this.m_MiniMapCost = PATH_COST_MAX;
         var _loc1_:Boolean = this.m_ObjectsCount == 0 || !this.m_ObjectsRenderer[0].type.isBank;
         var _loc2_:int = 0;
         while(_loc2_ < this.m_ObjectsCount)
         {
            _loc3_ = this.m_ObjectsRenderer[_loc2_].type;
            if(_loc3_.isBank)
            {
               this.m_MiniMapCost = Math.min(PATH_COST_MAX,_loc3_.waypoints);
            }
            if(_loc3_.isAutomap)
            {
               this.m_MiniMapColour = Colour.s_ARGBFromEightBit(_loc3_.automapColour);
            }
            if(_loc3_.isAvoid || _loc3_.isUnpassable)
            {
               _loc1_ = true;
            }
            _loc2_++;
         }
         if(_loc1_)
         {
            this.m_MiniMapCost = PATH_COST_OBSTACLE;
         }
      }
   }
}
