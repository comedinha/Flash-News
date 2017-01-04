package tibia.appearances.widgetClasses
{
   import flash.display.BitmapData;
   import flash.geom.Rectangle;
   import flash.utils.Dictionary;
   import shared.utility.BitmapPart;
   import shared.utility.PagedBitmapCache;
   import tibia.appearances.AppearanceType;
   import tibia.appearances.FrameGroup;
   
   public class AsyncSpriteCache implements ISpriteProvider
   {
      
      private static const ENVIRONMENTAL_EFFECTS:Array = [];
      
      public static const FRAME_GROUP_WALKING:uint = 1;
      
      protected static const RENDERER_DEFAULT_HEIGHT:Number = MAP_WIDTH * FIELD_SIZE;
      
      private static const MINIMUM_SPEED_FRAME_DURATION:int = 90 * 8;
      
      protected static const NUM_EFFECTS:int = 200;
      
      protected static const ONSCREEN_MESSAGE_WIDTH:int = 295;
      
      protected static const FIELD_ENTER_POSSIBLE:uint = 0;
      
      public static const PHASE_AUTOMATIC:int = -1;
      
      protected static const FIELD_ENTER_NOT_POSSIBLE:uint = 2;
      
      protected static const APPEARANCE_MISSILE:uint = 3;
      
      protected static const FIELD_HEIGHT:int = 24;
      
      public static const COMPRESSED_IMAGES_CACHE_MEMORY:uint = 4 * 768 * 768 * 15;
      
      protected static const UNDERGROUND_LAYER:int = 2;
      
      protected static const ONSCREEN_MESSAGE_HEIGHT:int = 195;
      
      public static const PHASE_RANDOM:int = 254;
      
      private static const MAXIMUM_SPEED_FRAME_DURATION:int = 35 * 8;
      
      protected static const APPEARANCE_OUTFIT:uint = 1;
      
      protected static const FIELD_CACHESIZE:int = FIELD_SIZE;
      
      protected static const FIELD_SIZE:int = 32;
      
      protected static const FIELD_ENTER_POSSIBLE_NO_ANIMATION:uint = 1;
      
      protected static const PLAYER_OFFSET_X:int = 8;
      
      protected static const PLAYER_OFFSET_Y:int = 6;
      
      public static const SPRITE_CACHE_PAGE_DIMENSION:uint = 512;
      
      protected static const MAP_MAX_X:int = MAP_MIN_X + (1 << 14 - 1);
      
      protected static const MAP_MAX_Y:int = MAP_MIN_Y + (1 << 14 - 1);
      
      protected static const MAP_MAX_Z:int = 15;
      
      protected static const NUM_ONSCREEN_MESSAGES:int = 16;
      
      public static const SPRITE_CACHE_PAGE_COUNT:uint = 5 * 5;
      
      protected static const GROUND_LAYER:int = 7;
      
      protected static const APPEARANCE_OBJECT:uint = 0;
      
      public static const ANIMATION_DELAY_BEFORE_RESET:int = 1000;
      
      protected static const MAP_HEIGHT:int = 11;
      
      protected static const RENDERER_DEFAULT_WIDTH:Number = MAP_WIDTH * FIELD_SIZE;
      
      public static const ANIMATION_ASYNCHRON:int = 0;
      
      public static const PHASE_ASYNCHRONOUS:int = 255;
      
      protected static const NUM_FIELDS:int = MAPSIZE_Z * MAPSIZE_Y * MAPSIZE_X;
      
      private static const MIN_SPEED_DELAY:int = 550;
      
      protected static const MAP_MIN_X:int = 24576;
      
      protected static const MAP_MIN_Y:int = 24576;
      
      protected static const MAP_MIN_Z:int = 0;
      
      protected static const APPEARANCE_EFFECT:uint = 2;
      
      public static const FRAME_GROUP_DEFAULT:uint = FRAME_GROUP_IDLE;
      
      private static const MAX_SPEED_DELAY:int = 100;
      
      protected static const MAPSIZE_W:int = 10;
      
      protected static const MAPSIZE_X:int = MAP_WIDTH + 3;
      
      protected static const MAPSIZE_Y:int = MAP_HEIGHT + 3;
      
      protected static const MAPSIZE_Z:int = 8;
      
      protected static const RENDERER_MIN_WIDTH:Number = Math.round(MAP_WIDTH * 2 / 3 * FIELD_SIZE);
      
      protected static const RENDERER_MIN_HEIGHT:Number = Math.round(MAP_HEIGHT * 2 / 3 * FIELD_SIZE);
      
      protected static const MAP_WIDTH:int = 15;
      
      public static const FRAME_GROUP_IDLE:uint = 0;
      
      public static const ANIMATION_SYNCHRON:int = 1;
       
      
      private var m_AsyncCompressedSpriteProvider:AsyncCompressedSpriteProvider = null;
      
      private var m_TempSpriteInformation:CachedSpriteInformation;
      
      public var m_PagedBitmapCache:PagedBitmapCache = null;
      
      private var m_CacheBitmap:BitmapData = null;
      
      public function AsyncSpriteCache(param1:AsyncCompressedSpriteProvider, param2:Dictionary)
      {
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc7_:uint = 0;
         this.m_TempSpriteInformation = new CachedSpriteInformation();
         super();
         if(param1 == null)
         {
            throw new ArgumentError("AsyncSpriteCache.AsyncSpriteCache: a_AsyncCompressedSpriteProvider must not be null");
         }
         if(param2 == null)
         {
            throw new ArgumentError("AsyncSpriteCache.AsyncSpriteCache: m_CachedSpriteInformations must not be null");
         }
         this.m_AsyncCompressedSpriteProvider = param1;
         _loc3_ = Math.ceil(Math.sqrt(SPRITE_CACHE_PAGE_COUNT));
         _loc4_ = Math.ceil(SPRITE_CACHE_PAGE_COUNT / _loc3_);
         this.m_CacheBitmap = new BitmapData(_loc3_ * SPRITE_CACHE_PAGE_DIMENSION,_loc4_ * SPRITE_CACHE_PAGE_DIMENSION,true,0);
         var _loc5_:Vector.<BitmapPart> = new Vector.<BitmapPart>(_loc3_ * _loc4_,true);
         var _loc6_:uint = 0;
         while(_loc6_ < _loc4_)
         {
            _loc7_ = 0;
            while(_loc7_ < _loc3_)
            {
               _loc5_[_loc6_ * _loc3_ + _loc7_] = new BitmapPart(this.m_CacheBitmap,new Rectangle(_loc7_ * SPRITE_CACHE_PAGE_DIMENSION,_loc6_ * SPRITE_CACHE_PAGE_DIMENSION,SPRITE_CACHE_PAGE_DIMENSION,SPRITE_CACHE_PAGE_DIMENSION));
               _loc7_++;
            }
            _loc6_++;
         }
         this.m_CacheBitmap.lock();
         this.m_PagedBitmapCache = new PagedBitmapCache(_loc5_);
      }
      
      private function cacheSprite(param1:CachedSpriteInformation) : Boolean
      {
         var _loc2_:Boolean = false;
         if(param1.cacheMiss)
         {
            this.m_TempSpriteInformation = this.m_AsyncCompressedSpriteProvider.getSprite(param1.spriteID,this.m_TempSpriteInformation);
            if(this.m_TempSpriteInformation.cacheMiss == false)
            {
               _loc2_ = this.m_PagedBitmapCache.put(param1.spriteID,this.m_TempSpriteInformation);
               this.m_PagedBitmapCache.get(param1.spriteID,param1);
               param1.cacheMiss = false;
               return _loc2_;
            }
         }
         return false;
      }
      
      public function getSprite(param1:uint, param2:CachedSpriteInformation = null, param3:AppearanceType = null) : CachedSpriteInformation
      {
         var _loc4_:CachedSpriteInformation = null;
         if(param2 != null)
         {
            _loc4_ = param2;
         }
         else
         {
            _loc4_ = this.m_TempSpriteInformation;
            this.m_TempSpriteInformation.reset();
         }
         var _loc5_:BitmapPart = this.m_PagedBitmapCache.get(param1,_loc4_);
         if(_loc5_ == null)
         {
            _loc4_.cacheMiss = true;
         }
         else
         {
            _loc4_.cacheMiss = false;
         }
         if(_loc4_.cacheMiss == true)
         {
            this.cacheSprite(_loc4_);
            if(_loc4_.cacheMiss == false)
            {
               if(param3 != null)
               {
                  this.cacheSpritesForAppearanceType(param3,true);
               }
            }
         }
         return _loc4_;
      }
      
      public function get cachedBitmaps() : uint
      {
         return this.m_PagedBitmapCache.cachedBitmaps;
      }
      
      public function get fillFactor() : Number
      {
         return this.m_PagedBitmapCache.fillFactor;
      }
      
      public function get currentBitmapCache() : BitmapPart
      {
         return this.m_PagedBitmapCache.currentBufferCachePage;
      }
      
      public function get invalidBitmapCache() : BitmapPart
      {
         return this.m_PagedBitmapCache.invalidCachePage;
      }
      
      private function cacheSpritesForAppearanceType(param1:AppearanceType, param2:Boolean = false) : void
      {
         var _loc3_:FrameGroup = null;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:CachedSpriteInformation = null;
         if(param1 == null)
         {
            return;
         }
         for each(_loc3_ in param1.FrameGroups)
         {
            _loc4_ = _loc3_.cachedSpriteInformations.length;
            _loc5_ = 0;
            _loc6_ = 0;
            while(_loc6_ < _loc4_)
            {
               _loc7_ = _loc3_.cachedSpriteInformations[_loc6_];
               if(this.cacheSprite(_loc7_))
               {
                  _loc5_++;
               }
               _loc6_++;
            }
         }
      }
   }
}
