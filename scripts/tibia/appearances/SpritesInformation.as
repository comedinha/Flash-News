package tibia.appearances
{
   import flash.geom.Rectangle;
   import flash.utils.Dictionary;
   import tibia.game.SpritesAsset;
   import tibia.appearances.widgetClasses.CachedSpriteInformation;
   
   public class SpritesInformation
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
       
      
      private var m_SpriteAssetInformations:Vector.<SpriteAssetInformation> = null;
      
      private var m_SpriteCategoryRectangles:Vector.<Rectangle> = null;
      
      private var m_TempRectangle:Rectangle;
      
      private var m_CachedSpriteInformations:Dictionary = null;
      
      public function SpritesInformation(param1:Vector.<SpritesAsset>)
      {
         var _SpritesAsset:SpritesAsset = null;
         var _TempInformation:SpriteAssetInformation = null;
         var _Information:SpriteAssetInformation = null;
         var LastEndSpriteID:uint = 0;
         var SpriteCount:uint = 0;
         var TempSpriteID:uint = 0;
         var a_SpritesAssets:Vector.<SpritesAsset> = param1;
         this.m_TempRectangle = new Rectangle();
         super();
         var i:uint = 0;
         this.m_SpriteAssetInformations = new Vector.<SpriteAssetInformation>();
         for each(_SpritesAsset in a_SpritesAssets)
         {
            _Information = new SpriteAssetInformation();
            _Information.m_FirstSpriteID = _SpritesAsset.firstSpriteID;
            _Information.m_LastSpriteID = _SpritesAsset.lastSpriteID;
            _Information.m_SpriteCategory = _SpritesAsset.spriteType;
            this.m_SpriteAssetInformations.push(_Information);
         }
         if(this.m_SpriteAssetInformations.length > 0)
         {
            this.m_SpriteAssetInformations.sort(function(param1:SpriteAssetInformation, param2:SpriteAssetInformation):int
            {
               if(param1.m_FirstSpriteID < param2.m_FirstSpriteID)
               {
                  return -1;
               }
               if(param1.m_FirstSpriteID > param2.m_FirstSpriteID)
               {
                  return 1;
               }
               return 0;
            });
            LastEndSpriteID = this.m_SpriteAssetInformations[0].m_FirstSpriteID;
            i = 1;
            while(i < this.m_SpriteAssetInformations.length)
            {
               if(this.m_SpriteAssetInformations[i - 1].m_LastSpriteID >= this.m_SpriteAssetInformations[i].m_FirstSpriteID)
               {
                  throw new ArgumentError("SpritesInformation.SpriteAssetsInformation: SpriteID of content have overlapping ranges");
               }
               i++;
            }
         }
         this.m_SpriteCategoryRectangles = new Vector.<Rectangle>(4,true);
         this.m_SpriteCategoryRectangles[0] = new Rectangle(0,0,FIELD_SIZE,FIELD_SIZE);
         this.m_SpriteCategoryRectangles[1] = new Rectangle(0,0,FIELD_SIZE,FIELD_SIZE * 2);
         this.m_SpriteCategoryRectangles[2] = new Rectangle(0,0,FIELD_SIZE * 2,FIELD_SIZE);
         this.m_SpriteCategoryRectangles[3] = new Rectangle(0,0,FIELD_SIZE * 2,FIELD_SIZE * 2);
         this.m_CachedSpriteInformations = new Dictionary();
         for each(_TempInformation in this.m_SpriteAssetInformations)
         {
            SpriteCount = _TempInformation.m_LastSpriteID - _TempInformation.m_FirstSpriteID + 1;
            TempSpriteID = _TempInformation.m_FirstSpriteID;
            while(TempSpriteID <= _TempInformation.m_LastSpriteID)
            {
               this.m_CachedSpriteInformations[TempSpriteID] = new CachedSpriteInformation(TempSpriteID,null,this.m_SpriteCategoryRectangles[_TempInformation.m_SpriteCategory],true,false);
               TempSpriteID++;
            }
         }
      }
      
      private function getSpriteSheetInformationForSpriteID(param1:uint) : SpriteAssetInformation
      {
         var _loc5_:SpriteAssetInformation = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = this.m_SpriteAssetInformations.length - 1;
         while(_loc3_ <= _loc4_)
         {
            _loc2_ = _loc3_ + _loc4_ >>> 1;
            _loc5_ = this.m_SpriteAssetInformations[_loc2_];
            if(param1 >= _loc5_.m_FirstSpriteID && param1 <= _loc5_.m_LastSpriteID)
            {
               return _loc5_;
            }
            if(_loc5_.m_FirstSpriteID < param1)
            {
               _loc3_ = _loc2_ + 1;
            }
            else
            {
               _loc4_ = _loc2_ - 1;
            }
         }
         return null;
      }
      
      public function get cachedSpriteInformations() : Dictionary
      {
         return this.m_CachedSpriteInformations;
      }
      
      public function getSpriteCategory(param1:uint) : uint
      {
         var _loc2_:SpriteAssetInformation = this.getSpriteSheetInformationForSpriteID(param1);
         if(_loc2_ == null)
         {
            throw new ArgumentError("SpritesInformation.getSpriteCategory: Invalid sprite  id " + param1);
         }
         return _loc2_.m_SpriteCategory;
      }
      
      public function getSpriteRectangle(param1:uint, param2:uint, param3:Rectangle = null) : Rectangle
      {
         var _loc4_:SpriteAssetInformation = this.getSpriteSheetInformationForSpriteID(param1);
         if(_loc4_ == null)
         {
            throw new ArgumentError("SpritesInformation.getSpriteRectangle: Invalid sprite  id " + param1);
         }
         if(param3 == null)
         {
            param3 = this.m_TempRectangle;
         }
         this.getSpriteDimensions(param1,param3);
         var _loc5_:uint = param1 - _loc4_.m_FirstSpriteID;
         var _loc6_:uint = param2 / param3.width;
         param3.x = _loc5_ % _loc6_ * param3.width;
         param3.y = uint(_loc5_ / _loc6_) * param3.height;
         return param3;
      }
      
      public function getSpriteDimensions(param1:uint, param2:Rectangle = null) : Rectangle
      {
         var _loc3_:SpriteAssetInformation = this.getSpriteSheetInformationForSpriteID(param1);
         if(_loc3_ == null)
         {
            throw new ArgumentError("SpritesInformation.getSpriteDimensions: Invalid sprite  id " + param1);
         }
         if(param2 != null)
         {
            param2.copyFrom(this.m_SpriteCategoryRectangles[_loc3_.m_SpriteCategory]);
            return param2;
         }
         return this.m_SpriteCategoryRectangles[_loc3_.m_SpriteCategory];
      }
      
      public function getFirstSpriteID(param1:uint) : uint
      {
         var _loc2_:SpriteAssetInformation = this.getSpriteSheetInformationForSpriteID(param1);
         if(_loc2_ == null)
         {
            throw new ArgumentError("SpritesInformation.getFirstSpriteID: Invalid sprite  id " + param1);
         }
         return _loc2_.m_FirstSpriteID;
      }
   }
}

class SpriteAssetInformation
{
    
   
   public var m_SpriteCategory:uint = 0;
   
   public var m_LastSpriteID:uint = 0;
   
   public var m_FirstSpriteID:uint = 0;
   
   function SpriteAssetInformation()
   {
      super();
   }
}
