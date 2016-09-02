package tibia.appearances.widgetClasses
{
   import loader.asset.AssetProviderEvent;
   import flash.geom.Rectangle;
   import tibia.game.SpritesAsset;
   import flash.utils.Dictionary;
   import loader.asset.IAssetProvider;
   import tibia.appearances.SpritesInformation;
   import shared.utility.AsyncCompressedImageCache;
   import tibia.appearances.AppearanceType;
   import flash.display.BitmapData;
   import shared.utility.AsyncCompressedImageCacheEvent;
   
   public class AsyncCompressedSpriteProvider implements ISpriteProvider
   {
      
      protected static const RENDERER_DEFAULT_HEIGHT:Number = MAP_WIDTH * FIELD_SIZE;
      
      protected static const NUM_EFFECTS:int = 200;
      
      protected static const MAP_HEIGHT:int = 11;
      
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
       
      
      private var m_TempSpriteInformation:tibia.appearances.widgetClasses.CachedSpriteInformation = null;
      
      private var m_TempRectangle:Rectangle;
      
      private var m_SpriteAssetKeys:Dictionary = null;
      
      private var m_AssetProvider:IAssetProvider = null;
      
      private var m_SpritesInformation:SpritesInformation = null;
      
      private var m_AsyncCompressedImageCache:AsyncCompressedImageCache = null;
      
      public function AsyncCompressedSpriteProvider(param1:IAssetProvider, param2:SpritesInformation, param3:uint)
      {
         var _loc5_:SpritesAsset = null;
         this.m_TempRectangle = new Rectangle();
         super();
         if(param1 == null)
         {
            throw new ArgumentError("AsyncCompressedSpriteProvider.AsyncCompressedSpriteProvider: asset provider must not be null");
         }
         this.m_AssetProvider = param1;
         if(param2 == null)
         {
            throw new ArgumentError("AsyncCompressedSpriteProvider.AsyncCompressedSpriteProvider: sprites information must not be null");
         }
         this.m_SpritesInformation = param2;
         this.m_AsyncCompressedImageCache = new AsyncCompressedImageCache(param3);
         this.m_AsyncCompressedImageCache.addEventListener(AsyncCompressedImageCacheEvent.UNCOMPRESS,this.onAsyncCompressedImageCacheUncompressed);
         this.m_TempSpriteInformation = new tibia.appearances.widgetClasses.CachedSpriteInformation();
         var _loc4_:Vector.<SpritesAsset> = this.m_AssetProvider.getSpriteAssets();
         this.m_SpriteAssetKeys = new Dictionary();
         for each(_loc5_ in _loc4_)
         {
            this.m_SpriteAssetKeys[_loc5_.firstSpriteID] = _loc5_.uniqueKey;
            if(_loc5_.loaded)
            {
               this.m_AsyncCompressedImageCache.addCompressedImage(_loc5_.firstSpriteID,_loc5_.rawBytes);
               this.m_AssetProvider.removeAsset(_loc5_);
            }
         }
         if(param1.loadingFinished == false)
         {
            this.m_AssetProvider.addEventListener(AssetProviderEvent.ASSET_LOADED,this.onAssetProviderAssetLoaded);
            this.m_AssetProvider.addEventListener(AssetProviderEvent.ALL_ASSETS_LOADED,this.onAssetProviderAllAssetsLoaded);
         }
         else
         {
            this.m_AssetProvider = null;
         }
      }
      
      private function onAssetProviderAllAssetsLoaded(param1:AssetProviderEvent) : void
      {
         this.m_AssetProvider.removeEventListener(AssetProviderEvent.ASSET_LOADED,this.onAssetProviderAssetLoaded);
         this.m_AssetProvider.removeEventListener(AssetProviderEvent.ALL_ASSETS_LOADED,this.onAssetProviderAllAssetsLoaded);
         this.m_AssetProvider = null;
      }
      
      private function onAssetProviderAssetLoaded(param1:AssetProviderEvent) : void
      {
         var _loc2_:SpritesAsset = param1.asset as SpritesAsset;
         if(_loc2_ != null)
         {
            if(_loc2_.loaded && _loc2_.optional == false)
            {
               this.m_AsyncCompressedImageCache.addCompressedImage(_loc2_.firstSpriteID,_loc2_.rawBytes);
               this.m_AssetProvider.removeAsset(_loc2_);
            }
         }
      }
      
      public function getSprite(param1:uint, param2:tibia.appearances.widgetClasses.CachedSpriteInformation = null, param3:AppearanceType = null) : tibia.appearances.widgetClasses.CachedSpriteInformation
      {
         var _loc4_:tibia.appearances.widgetClasses.CachedSpriteInformation = null;
         if(param2 != null)
         {
            _loc4_ = param2;
         }
         else
         {
            _loc4_ = this.m_TempSpriteInformation;
            this.m_TempSpriteInformation.reset();
         }
         var _loc5_:BitmapData = null;
         var _loc6_:uint = this.m_SpritesInformation.getFirstSpriteID(param1);
         _loc5_ = this.m_AsyncCompressedImageCache.getUncompressedImage(_loc6_);
         if(_loc5_ == null)
         {
            if(this.m_AssetProvider != null)
            {
               this.m_AssetProvider.pushAssetForwardInLoadingQueueByKey(this.m_SpriteAssetKeys[_loc6_]);
            }
            _loc4_.cacheMiss = true;
         }
         else
         {
            this.m_SpritesInformation.getSpriteRectangle(param1,_loc5_.width,this.m_TempRectangle);
            _loc4_.setCachedSpriteInformationTo(param1,_loc5_,this.m_TempRectangle,false);
         }
         return _loc4_;
      }
      
      private function onAsyncCompressedImageCacheUncompressed(param1:AsyncCompressedImageCacheEvent) : void
      {
      }
   }
}
