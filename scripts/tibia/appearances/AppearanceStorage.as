package tibia.appearances
{
   import flash.events.ErrorEvent;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.system.System;
   import flash.utils.ByteArray;
   import flash.utils.Dictionary;
   import flash.utils.Endian;
   import loader.asset.IAssetProvider;
   import shared.utility.StringHelper;
   import shared.utility.Vector3D;
   import tibia.appearances.widgetClasses.AsyncCompressedSpriteProvider;
   import tibia.appearances.widgetClasses.AsyncSpriteCache;
   import tibia.market.MarketWidget;
   
   public class AppearanceStorage extends EventDispatcher
   {
      
      protected static const RENDERER_DEFAULT_HEIGHT:Number = MAP_WIDTH * FIELD_SIZE;
      
      public static const FRAME_GROUP_WALKING:uint = 1;
      
      public static const FLAG_LIQUIDPOOL:int = 11;
      
      public static const FLAG_UNMOVE:int = 13;
      
      public static const FLAG_IGNORELOOK:int = 32;
      
      public static const PHASE_AUTOMATIC:int = -1;
      
      private static const MOUSE_BUTTON_RIGHT:int = 2;
      
      protected static const APPEARANCE_MISSILE:uint = 3;
      
      protected static const FIELD_HEIGHT:int = 24;
      
      public static const PHASE_RANDOM:int = 254;
      
      public static const FLAG_FORCEUSE:int = 6;
      
      protected static const ONSCREEN_MESSAGE_HEIGHT:int = 195;
      
      private static const MAXIMUM_SPEED_FRAME_DURATION:int = 35 * 8;
      
      protected static const APPEARANCE_OUTFIT:uint = 1;
      
      public static const FLAG_LYINGOBJECT:int = 27;
      
      public static const FLAG_CLIP:int = 1;
      
      protected static const FIELD_SIZE:int = 32;
      
      protected static const FIELD_ENTER_POSSIBLE_NO_ANIMATION:uint = 1;
      
      public static const FLAG_ANIMATION:int = 16776961;
      
      public static const FLAG_CLOTHES:int = 33;
      
      public static const FLAG_BOTTOM:int = 2;
      
      public static const FLAG_LIGHT:int = 22;
      
      public static const FLAG_UNPASS:int = 12;
      
      private static const MOUSE_BUTTON_LEFT:int = 1;
      
      public static const FLAG_MARKET:int = 34;
      
      private static const ACTION_ATTACK:int = 1;
      
      public static const SPRITE_CACHE_PAGE_COUNT:uint = 5 * 5;
      
      protected static const GROUND_LAYER:int = 7;
      
      public static const FLAG_ANIMATEALWAYS:int = 28;
      
      public static const ANIMATION_DELAY_BEFORE_RESET:int = 1000;
      
      public static const FLAG_WRAPPABLE:int = 36;
      
      public static const FLAG_TOP_EFFECT:int = 38;
      
      public static const FLAG_NOMOVEMENTANIMATION:int = 16;
      
      public static const PHASE_ASYNCHRONOUS:int = 255;
      
      public static const FLAG_UNSIGHT:int = 14;
      
      public static const FLAG_LENSHELP:int = 30;
      
      private static const ACTION_OPEN:int = 8;
      
      private static const MIN_SPEED_DELAY:int = 550;
      
      public static const FLAG_AVOID:int = 15;
      
      public static const FLAG_FULLBANK:int = 31;
      
      protected static const MAP_MIN_X:int = 24576;
      
      protected static const MAP_MIN_Y:int = 24576;
      
      public static const FRAME_GROUP_DEFAULT:uint = FRAME_GROUP_IDLE;
      
      private static const MAX_SPEED_DELAY:int = 100;
      
      protected static const MAP_MIN_Z:int = 0;
      
      public static const FLAG_UNWRAPPABLE:int = 37;
      
      protected static const RENDERER_MIN_HEIGHT:Number = Math.round(MAP_HEIGHT * 2 / 3 * FIELD_SIZE);
      
      protected static const RENDERER_MIN_WIDTH:Number = Math.round(MAP_WIDTH * 2 / 3 * FIELD_SIZE);
      
      protected static const MAP_WIDTH:int = 15;
      
      public static const FLAG_TRANSLUCENT:int = 24;
      
      private static const ENVIRONMENTAL_EFFECTS:Array = [];
      
      private static const ACTION_LOOK:int = 6;
      
      protected static const NUM_EFFECTS:int = 200;
      
      private static const MINIMUM_SPEED_FRAME_DURATION:int = 90 * 8;
      
      public static const FLAG_HOOKEAST:int = 20;
      
      private static const ACTION_TALK:int = 9;
      
      private static const ACTION_SMARTCLICK:int = 100;
      
      protected static const FIELD_ENTER_POSSIBLE:uint = 0;
      
      private static const MOUSE_BUTTON_MIDDLE:int = 3;
      
      public static const FLAG_MULTIUSE:int = 7;
      
      public static const COMPRESSED_IMAGES_CACHE_MEMORY:uint = 4 * 768 * 768 * 15;
      
      protected static const ONSCREEN_MESSAGE_WIDTH:int = 295;
      
      public static const FLAG_USABLE:int = 254;
      
      public static const FLAG_WRITE:int = 8;
      
      public static const FLAG_BANK:int = 0;
      
      protected static const FIELD_ENTER_NOT_POSSIBLE:uint = 2;
      
      protected static const UNDERGROUND_LAYER:int = 2;
      
      protected static const FIELD_CACHESIZE:int = FIELD_SIZE;
      
      public static const FLAG_DEFAULT_ACTION:int = 35;
      
      protected static const PLAYER_OFFSET_X:int = 8;
      
      protected static const PLAYER_OFFSET_Y:int = 6;
      
      public static const SPRITE_CACHE_PAGE_DIMENSION:uint = 512;
      
      public static const FLAG_CONTAINER:int = 4;
      
      public static const FLAG_HOOKSOUTH:int = 19;
      
      protected static const MAP_MAX_Y:int = MAP_MIN_Y + (1 << 14 - 1);
      
      protected static const MAP_MAX_Z:int = 15;
      
      public static const FLAG_HEIGHT:int = 26;
      
      public static const FLAG_HANG:int = 18;
      
      protected static const NUM_ONSCREEN_MESSAGES:int = 16;
      
      public static const FLAG_AUTOMAP:int = 29;
      
      protected static const MAP_MAX_X:int = MAP_MIN_X + (1 << 14 - 1);
      
      private static const ACTION_CONTEXT_MENU:int = 5;
      
      protected static const APPEARANCE_OBJECT:uint = 0;
      
      public static const FLAG_TAKE:int = 17;
      
      protected static const MAP_HEIGHT:int = 11;
      
      public static const FLAG_ROTATE:int = 21;
      
      protected static const RENDERER_DEFAULT_WIDTH:Number = MAP_WIDTH * FIELD_SIZE;
      
      private static const ACTION_NONE:int = 0;
      
      public static const FLAG_CUMULATIVE:int = 5;
      
      public static const ANIMATION_ASYNCHRON:int = 0;
      
      public static const FLAG_WRITEONCE:int = 9;
      
      protected static const NUM_FIELDS:int = MAPSIZE_Z * MAPSIZE_Y * MAPSIZE_X;
      
      private static const MOUSE_BUTTON_BOTH:int = 4;
      
      private static const ACTION_AUTOWALK_HIGHLIGHT:int = 4;
      
      private static const ACTION_UNSET:int = -1;
      
      private static const ACTION_ATTACK_OR_TALK:int = 102;
      
      private static const ACTION_USE_OR_OPEN:int = 101;
      
      public static const FLAG_DONTHIDE:int = 23;
      
      protected static const APPEARANCE_EFFECT:uint = 2;
      
      public static const FLAG_SHIFT:int = 25;
      
      public static const FLAG_LIQUIDCONTAINER:int = 10;
      
      protected static const MAPSIZE_W:int = 10;
      
      protected static const MAPSIZE_X:int = MAP_WIDTH + 3;
      
      protected static const MAPSIZE_Y:int = MAP_HEIGHT + 3;
      
      protected static const MAPSIZE_Z:int = 8;
      
      private static const ACTION_USE:int = 7;
      
      private static const ACTION_AUTOWALK:int = 3;
      
      public static const FLAG_TOP:int = 3;
      
      public static const FRAME_GROUP_IDLE:uint = 0;
      
      public static const ANIMATION_SYNCHRON:int = 1;
       
      
      private var m_OutfitTypes:Vector.<AppearanceType>;
      
      private var m_ObjectTypes:Vector.<AppearanceType>;
      
      public var m_AsyncSpriteCache:AsyncSpriteCache = null;
      
      private var m_AsyncCompressedSpriteProvider:AsyncCompressedSpriteProvider = null;
      
      private var m_MissileTypes:Vector.<AppearanceType>;
      
      private var m_ObjectTypeInfoCache:Vector.<AppearanceTypeInfo>;
      
      private var m_MarketObjectTypes:Array;
      
      private var m_AppearancesContentRevision:int;
      
      private var m_SpritesInformation:SpritesInformation = null;
      
      private var m_EffectTypes:Vector.<AppearanceType>;
      
      public function AppearanceStorage()
      {
         this.m_ObjectTypes = new Vector.<AppearanceType>();
         this.m_OutfitTypes = new Vector.<AppearanceType>();
         this.m_MissileTypes = new Vector.<AppearanceType>();
         this.m_EffectTypes = new Vector.<AppearanceType>();
         this.m_MarketObjectTypes = [];
         this.m_ObjectTypeInfoCache = new Vector.<AppearanceTypeInfo>();
         super();
      }
      
      private function postprocessAppearances() : Boolean
      {
         var CachedSpriteInformations:Dictionary = null;
         var _Type:AppearanceType = null;
         var i:int = 0;
         var j:int = 0;
         _Type = new AppearanceType(AppearanceInstance.CREATURE);
         _Type.isAvoid = true;
         _Type.isCachable = false;
         _Type.FrameGroups[FrameGroup.FRAME_GROUP_DEFAULT] = new FrameGroup();
         this.m_ObjectTypes[AppearanceInstance.CREATURE] = _Type;
         _Type = this.m_ObjectTypes[AppearanceInstance.PURSE];
         _Type.isUnmoveable = true;
         _Type.isTakeable = false;
         var BlueStars:AppearanceType = this.m_EffectTypes[13];
         _Type = new AppearanceType(OutfitInstance.INVISIBLE_OUTFIT_ID);
         var _FrameGroup:FrameGroup = new FrameGroup();
         _Type.FrameGroups[FRAME_GROUP_IDLE] = _Type.FrameGroups[FRAME_GROUP_WALKING] = _FrameGroup;
         _FrameGroup.width = BlueStars.FrameGroups[FRAME_GROUP_DEFAULT].width;
         _FrameGroup.height = BlueStars.FrameGroups[FRAME_GROUP_DEFAULT].height;
         _Type.displacementX = 8;
         _Type.displacementY = 8;
         _FrameGroup.exactSize = FIELD_SIZE;
         _FrameGroup.layers = BlueStars.FrameGroups[FRAME_GROUP_DEFAULT].layers;
         _FrameGroup.patternWidth = BlueStars.FrameGroups[FRAME_GROUP_DEFAULT].patternWidth;
         _FrameGroup.patternHeight = BlueStars.FrameGroups[FRAME_GROUP_DEFAULT].patternHeight;
         _FrameGroup.patternDepth = BlueStars.FrameGroups[FRAME_GROUP_DEFAULT].patternDepth;
         _FrameGroup.phases = BlueStars.FrameGroups[FRAME_GROUP_DEFAULT].phases;
         _FrameGroup.numSprites = _FrameGroup.phases * _FrameGroup.patternWidth;
         _Type.isDisplaced = true;
         _Type.isAnimateAlways = true;
         _FrameGroup.isAnimation = true;
         _Type.isCachable = false;
         _FrameGroup.animator = new AppearanceAnimator(_FrameGroup.phases,0,0,AppearanceAnimator.ANIMATION_SYNCHRON,BlueStars.FrameGroups[FRAME_GROUP_DEFAULT].animator.frameDurations);
         if(BlueStars.FrameGroups[FRAME_GROUP_DEFAULT].spriteIDs.length > 1)
         {
            _FrameGroup.spriteIDs = BlueStars.FrameGroups[FRAME_GROUP_DEFAULT].spriteIDs;
            this.m_OutfitTypes[OutfitInstance.INVISIBLE_OUTFIT_ID] = _Type;
         }
         _Type = new AppearanceType(MarketWidget.REQUEST_OWN_OFFERS);
         _Type.marketCategory = -1;
         _Type.marketShowAs = -1;
         _Type.marketTradeAs = MarketWidget.REQUEST_OWN_OFFERS;
         this.m_MarketObjectTypes.push(_Type);
         _Type = new AppearanceType(MarketWidget.REQUEST_OWN_HISTORY);
         _Type.marketCategory = -1;
         _Type.marketShowAs = -1;
         _Type.marketTradeAs = MarketWidget.REQUEST_OWN_HISTORY;
         this.m_MarketObjectTypes.push(_Type);
         this.m_MarketObjectTypes.sortOn("marketTradeAs",Array.NUMERIC);
         CachedSpriteInformations = this.m_SpritesInformation.cachedSpriteInformations;
         var UpdateAppearanceTypes:Function = function(param1:AppearanceType, param2:int, param3:Vector.<AppearanceType>):void
         {
            var _loc4_:FrameGroup = null;
            var _loc5_:uint = 0;
            var _loc6_:uint = 0;
            if(param1 != null)
            {
               for each(_loc4_ in param1.FrameGroups)
               {
                  if(this == m_OutfitTypes && _loc4_.layers == 2)
                  {
                     _loc4_.spriteProvider = m_AsyncCompressedSpriteProvider;
                  }
                  else
                  {
                     _loc4_.spriteProvider = m_AsyncSpriteCache;
                  }
                  _loc5_ = 0;
                  while(_loc5_ < _loc4_.spriteIDs.length)
                  {
                     _loc4_.cachedSpriteInformations[_loc5_] = CachedSpriteInformations[_loc4_.spriteIDs[_loc5_]];
                     _loc6_ = m_SpritesInformation.getFirstSpriteID(_loc4_.spriteIDs[_loc5_]);
                     if(_loc4_.spritesheetIDs.indexOf(_loc6_) < 0)
                     {
                        _loc4_.spritesheetIDs.push(_loc6_);
                     }
                     _loc5_++;
                  }
               }
            }
         };
         this.m_ObjectTypes.forEach(UpdateAppearanceTypes);
         this.m_OutfitTypes.forEach(UpdateAppearanceTypes,this.m_OutfitTypes);
         this.m_EffectTypes.forEach(UpdateAppearanceTypes);
         this.m_MissileTypes.forEach(UpdateAppearanceTypes);
         return true;
      }
      
      public function setAssetProvider(param1:IAssetProvider) : void
      {
         var _loc4_:Event = null;
         if(param1 == null)
         {
            throw new ArgumentError("AppearanceStorage.setAssetProvider: asset provider must not be null");
         }
         var _loc2_:Boolean = false;
         this.m_SpritesInformation = new SpritesInformation(param1.getSpriteAssets());
         this.m_AsyncCompressedSpriteProvider = new AsyncCompressedSpriteProvider(param1,this.m_SpritesInformation,COMPRESSED_IMAGES_CACHE_MEMORY);
         this.m_AsyncSpriteCache = new AsyncSpriteCache(this.m_AsyncCompressedSpriteProvider,this.m_SpritesInformation.cachedSpriteInformations);
         var _loc3_:AppearancesAsset = param1.getAppearances();
         _loc2_ = _loc3_ == null || !this.loadAppearances(_loc3_.rawBytes);
         this.contentRevision = _loc3_.contentRevision;
         if(this.postprocessAppearances())
         {
            param1.removeAsset(_loc3_);
            System.pauseForGCIfCollectionImminent(0.25);
            _loc4_ = new Event(Event.COMPLETE);
            dispatchEvent(_loc4_);
         }
         else
         {
            this.loadError();
         }
         if(_loc2_)
         {
            this.loadError();
         }
      }
      
      private function loadError() : void
      {
         this.reset();
         var _loc1_:ErrorEvent = new ErrorEvent(ErrorEvent.ERROR);
         dispatchEvent(_loc1_);
      }
      
      private function loadAppearances(param1:ByteArray) : Boolean
      {
         if(param1 == null || param1.bytesAvailable < 12)
         {
            return false;
         }
         var _loc2_:String = param1.endian;
         param1.endian = Endian.LITTLE_ENDIAN;
         this.m_ObjectTypes.length = param1.readUnsignedShort() + 1;
         this.m_OutfitTypes.length = param1.readUnsignedShort() + 1;
         this.m_EffectTypes.length = param1.readUnsignedShort() + 1;
         this.m_MissileTypes.length = param1.readUnsignedShort() + 1;
         var _loc3_:Boolean = true;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         _loc4_ = AppearanceInstance.CREATURE + 1;
         _loc5_ = this.m_ObjectTypes.length;
         while(_loc3_ && _loc4_ < _loc5_)
         {
            _loc3_ = this.readAppearanceType(param1,APPEARANCE_OBJECT,this.m_ObjectTypes,_loc4_);
            _loc4_++;
         }
         _loc4_ = 1;
         _loc5_ = this.m_OutfitTypes.length;
         while(_loc3_ && _loc4_ < _loc5_)
         {
            _loc3_ = this.readAppearanceType(param1,APPEARANCE_OUTFIT,this.m_OutfitTypes,_loc4_);
            _loc4_++;
         }
         _loc4_ = 1;
         _loc5_ = this.m_EffectTypes.length;
         while(_loc3_ && _loc4_ < _loc5_)
         {
            _loc3_ = this.readAppearanceType(param1,APPEARANCE_EFFECT,this.m_EffectTypes,_loc4_);
            _loc4_++;
         }
         _loc4_ = 1;
         _loc5_ = this.m_MissileTypes.length;
         while(_loc3_ && _loc4_ < _loc5_)
         {
            _loc3_ = this.readAppearanceType(param1,APPEARANCE_MISSILE,this.m_MissileTypes,_loc4_);
            _loc4_++;
         }
         _loc3_ = _loc3_ && param1.bytesAvailable == 0;
         param1.endian = _loc2_;
         return _loc3_;
      }
      
      public function reset() : void
      {
         this.m_ObjectTypes.length = 0;
         this.m_OutfitTypes.length = 0;
         this.m_MissileTypes.length = 0;
         this.m_EffectTypes.length = 0;
         this.m_MarketObjectTypes.length = 0;
         this.m_ObjectTypeInfoCache.length = 0;
         this.m_AppearancesContentRevision = 0;
      }
      
      private function setTypeInfo(param1:Vector.<AppearanceTypeInfo>, param2:int, param3:int, param4:String) : void
      {
         var _loc5_:int = 0;
         var _loc6_:int = param1.length - 1;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = -1;
         while(_loc5_ <= _loc6_)
         {
            _loc7_ = (_loc5_ + _loc6_) / 2;
            _loc8_ = AppearanceTypeRef.s_CompareExternal(param1[_loc7_],param2,param3);
            if(_loc8_ < 0)
            {
               _loc5_ = _loc7_ + 1;
               continue;
            }
            if(_loc8_ > 0)
            {
               _loc6_ = _loc7_ - 1;
               continue;
            }
            _loc9_ = _loc7_;
            break;
         }
         if(_loc9_ < 0)
         {
            param1.splice(_loc5_,0,new AppearanceTypeInfo(param2,param3,param4));
         }
         else
         {
            param1[_loc9_].name = param4;
         }
      }
      
      public function createOutfitInstance(param1:int, param2:int, param3:int, param4:int, param5:int, param6:int) : OutfitInstance
      {
         if(param1 >= 1 && param1 < this.m_OutfitTypes.length || param1 == OutfitInstance.INVISIBLE_OUTFIT_ID)
         {
            return new OutfitInstance(param1,this.m_OutfitTypes[param1],param2,param3,param4,param5,param6);
         }
         return null;
      }
      
      public function getObjectType(param1:int) : AppearanceType
      {
         if(param1 >= AppearanceInstance.CREATURE && param1 < this.m_ObjectTypes.length)
         {
            return this.m_ObjectTypes[param1];
         }
         return null;
      }
      
      public function getOutfitType(param1:int) : AppearanceType
      {
         if(param1 >= 1 && param1 < this.m_OutfitTypes.length)
         {
            return this.m_OutfitTypes[param1];
         }
         return null;
      }
      
      public function createTextualEffectInstance(param1:int, param2:int, param3:Number) : TextualEffectInstance
      {
         return new TextualEffectInstance(param1,null,param2,param3);
      }
      
      public function get marketObjectTypes() : Array
      {
         return this.m_MarketObjectTypes;
      }
      
      public function createObjectInstance(param1:int, param2:int) : ObjectInstance
      {
         if(param1 >= AppearanceInstance.CREATURE && param1 < this.m_ObjectTypes.length)
         {
            return new ObjectInstance(param1,this.m_ObjectTypes[param1],param2);
         }
         return null;
      }
      
      public function createEffectInstance(param1:int) : EffectInstance
      {
         if(param1 >= 1 && param1 < this.m_EffectTypes.length)
         {
            return new EffectInstance(param1,this.m_EffectTypes[param1]);
         }
         return null;
      }
      
      public function set contentRevision(param1:int) : void
      {
         this.m_AppearancesContentRevision = param1;
      }
      
      public function setCachedObjectTypeName(param1:int, param2:int, param3:String) : void
      {
         if(param3 == null || param3.length < 1)
         {
            throw new ArgumentError("AppearanceStorage.setCachedObjectTypeName: Invalid name.");
         }
         this.setTypeInfo(this.m_ObjectTypeInfoCache,param1,param2,param3);
      }
      
      public function getMarketObjectType(param1:*) : AppearanceType
      {
         var _loc6_:AppearanceType = null;
         var _loc2_:int = -1;
         if(param1 is AppearanceType && AppearanceType(param1).isMarket)
         {
            _loc2_ = AppearanceType(param1).marketTradeAs;
         }
         else
         {
            _loc2_ = int(param1);
         }
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = this.m_MarketObjectTypes.length - 1;
         while(_loc4_ <= _loc5_)
         {
            _loc3_ = _loc4_ + _loc5_ >>> 1;
            _loc6_ = AppearanceType(this.m_MarketObjectTypes[_loc3_]);
            if(_loc6_.marketTradeAs == _loc2_)
            {
               return _loc6_;
            }
            if(_loc6_.marketTradeAs < _loc2_)
            {
               _loc4_ = _loc3_ + 1;
            }
            else
            {
               _loc5_ = _loc3_ - 1;
            }
         }
         return null;
      }
      
      public function get contentRevision() : int
      {
         return this.m_AppearancesContentRevision;
      }
      
      public function createEnvironmentalEffect(param1:int) : ObjectInstance
      {
         var _loc5_:Object = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = ENVIRONMENTAL_EFFECTS.length - 1;
         var _loc4_:int = 0;
         while(_loc2_ <= _loc3_)
         {
            _loc4_ = (_loc2_ + _loc3_) / 2;
            _loc5_ = ENVIRONMENTAL_EFFECTS[_loc4_];
            if(_loc5_.ID < param1)
            {
               _loc2_ = _loc4_ + 1;
               continue;
            }
            if(_loc5_.ID > param1)
            {
               _loc3_ = _loc4_ - _loc4_;
               continue;
            }
            _loc6_ = _loc5_.appearanceType;
            _loc7_ = !!_loc5_.atmospheric?1:0;
            return new ObjectInstance(_loc6_,this.m_ObjectTypes[_loc6_],_loc7_);
         }
         return null;
      }
      
      private function onLoaderError(param1:Event) : void
      {
         this.loadError();
      }
      
      public function hasOutfitType(param1:int) : Boolean
      {
         return param1 >= 1 && param1 < this.m_OutfitTypes.length;
      }
      
      private function readAppearanceType(param1:ByteArray, param2:uint, param3:Vector.<AppearanceType>, param4:int, param5:int = 0) : Boolean
      {
         var _loc13_:int = 0;
         var _loc14_:uint = 0;
         var _loc15_:FrameGroup = null;
         var _loc16_:Boolean = false;
         var _loc17_:int = 0;
         var _loc18_:int = 0;
         var _loc19_:int = 0;
         var _loc20_:Vector.<FrameDuration> = null;
         var _loc21_:uint = 0;
         var _loc22_:uint = 0;
         var _loc23_:FrameDuration = null;
         var _loc24_:int = 0;
         if(param1 == null || param1.bytesAvailable < 11)
         {
            return false;
         }
         var _loc6_:AppearanceType = new AppearanceType(param4);
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         loop0:
         while(true)
         {
            if(_loc7_ >= 255)
            {
               var _loc9_:Boolean = false;
               var _loc10_:int = 0;
               var _loc11_:uint = param2 == APPEARANCE_OUTFIT?uint(param1.readUnsignedByte()):uint(1);
               var _loc12_:uint = 0;
               while(_loc12_ < _loc11_)
               {
                  _loc14_ = param2 == APPEARANCE_OUTFIT?uint(param1.readUnsignedByte()):uint(0);
                  _loc15_ = new FrameGroup();
                  _loc15_.width = param1.readUnsignedByte();
                  _loc15_.height = param1.readUnsignedByte();
                  if(_loc15_.width > 1 || _loc15_.height > 1)
                  {
                     _loc15_.exactSize = param1.readUnsignedByte();
                  }
                  else
                  {
                     _loc15_.exactSize = FIELD_SIZE;
                  }
                  _loc10_ = Math.max(_loc10_,_loc15_.exactSize);
                  _loc15_.layers = param1.readUnsignedByte();
                  _loc15_.patternWidth = param1.readUnsignedByte();
                  _loc15_.patternHeight = param1.readUnsignedByte();
                  _loc15_.patternDepth = param1.readUnsignedByte();
                  _loc15_.phases = param1.readUnsignedByte();
                  if(_loc15_.phases > 1)
                  {
                     _loc15_.isAnimation = _loc9_ = true;
                     _loc17_ = param1.readUnsignedByte();
                     _loc18_ = param1.readInt();
                     _loc19_ = param1.readByte();
                     _loc20_ = new Vector.<FrameDuration>();
                     _loc8_ = 0;
                     while(_loc8_ < _loc15_.phases)
                     {
                        _loc21_ = param1.readUnsignedInt();
                        _loc22_ = param1.readUnsignedInt();
                        _loc23_ = new FrameDuration(_loc21_,_loc22_);
                        _loc20_.push(_loc23_);
                        _loc8_++;
                     }
                     _loc15_.animator = new AppearanceAnimator(_loc15_.phases,_loc19_,_loc18_,_loc17_,_loc20_);
                  }
                  _loc15_.numSprites = _loc15_.layers * _loc15_.patternWidth * _loc15_.patternHeight * _loc15_.patternDepth * _loc15_.phases;
                  _loc8_ = 0;
                  while(_loc8_ < _loc15_.numSprites)
                  {
                     _loc15_.spriteIDs[_loc8_] = param1.readUnsignedInt();
                     _loc8_++;
                  }
                  _loc16_ = _loc6_.FrameGroups.hasOwnProperty(FrameGroup.FRAME_GROUP_IDLE);
                  if(_loc14_ == FrameGroup.FRAME_GROUP_WALKING && (!_loc16_ || _loc16_ && _loc6_.FrameGroups[FrameGroup.FRAME_GROUP_IDLE].phases == 0))
                  {
                     _loc6_.FrameGroups[FrameGroup.FRAME_GROUP_IDLE] = _loc15_;
                  }
                  _loc6_.FrameGroups[_loc14_] = _loc15_;
                  _loc12_++;
               }
               param3[param4] = _loc6_;
               _loc6_.isCachable = !_loc9_ && !_loc6_.isHangable && !_loc6_.isLight && _loc10_ + Math.max(_loc6_.displacementX,_loc6_.displacementY) <= FIELD_CACHESIZE;
               if(_loc6_.isMarket)
               {
                  _loc24_ = -1;
                  _loc24_ = this.m_MarketObjectTypes.length - 1;
                  while(_loc24_ >= 0)
                  {
                     if(_loc6_.marketTradeAs == AppearanceType(this.m_MarketObjectTypes[_loc24_]).marketTradeAs)
                     {
                        break;
                     }
                     _loc24_--;
                  }
                  if(_loc24_ < 0)
                  {
                     this.m_MarketObjectTypes.push(_loc6_);
                  }
               }
               return true;
            }
            _loc7_ = param1.readUnsignedByte();
            switch(_loc7_)
            {
               case FLAG_BANK:
                  _loc6_.isBank = true;
                  _loc6_.waypoints = param1.readUnsignedShort();
                  continue;
               case FLAG_CLIP:
                  _loc6_.isClip = true;
                  continue;
               case FLAG_BOTTOM:
                  _loc6_.isBottom = true;
                  continue;
               case FLAG_TOP:
                  _loc6_.isTop = true;
                  continue;
               case FLAG_CONTAINER:
                  _loc6_.isContainer = true;
                  continue;
               case FLAG_CUMULATIVE:
                  _loc6_.isCumulative = true;
                  continue;
               case FLAG_USABLE:
                  _loc6_.isUsable = true;
                  continue;
               case FLAG_FORCEUSE:
                  _loc6_.isForceUse = true;
                  continue;
               case FLAG_MULTIUSE:
                  _loc6_.isMultiUse = true;
                  continue;
               case FLAG_WRITE:
                  _loc6_.isWriteable = true;
                  _loc6_.maxTextLength = param1.readUnsignedShort();
                  continue;
               case FLAG_WRITEONCE:
                  _loc6_.isWriteableOnce = true;
                  _loc6_.maxTextLength = param1.readUnsignedShort();
                  continue;
               case FLAG_LIQUIDCONTAINER:
                  _loc6_.isLiquidContainer = true;
                  continue;
               case FLAG_LIQUIDPOOL:
                  _loc6_.isLiquidPool = true;
                  continue;
               case FLAG_UNPASS:
                  _loc6_.isUnpassable = true;
                  continue;
               case FLAG_UNMOVE:
                  _loc6_.isUnmoveable = true;
                  continue;
               case FLAG_UNSIGHT:
                  _loc6_.isUnsight = true;
                  continue;
               case FLAG_AVOID:
                  _loc6_.isAvoid = true;
                  continue;
               case FLAG_NOMOVEMENTANIMATION:
                  _loc6_.preventMovementAnimation = true;
                  continue;
               case FLAG_TAKE:
                  _loc6_.isTakeable = true;
                  continue;
               case FLAG_HANG:
                  _loc6_.isHangable = true;
                  continue;
               case FLAG_HOOKSOUTH:
                  _loc6_.isHookSouth = true;
                  continue;
               case FLAG_HOOKEAST:
                  _loc6_.isHookEast = true;
                  continue;
               case FLAG_ROTATE:
                  _loc6_.isRotateable = true;
                  continue;
               case FLAG_LIGHT:
                  _loc6_.isLight = true;
                  _loc6_.brightness = param1.readUnsignedShort();
                  _loc6_.lightColour = param1.readUnsignedShort();
                  continue;
               case FLAG_DONTHIDE:
                  _loc6_.isDonthide = true;
                  continue;
               case FLAG_TRANSLUCENT:
                  _loc6_.isTranslucent = true;
                  continue;
               case FLAG_SHIFT:
                  _loc6_.isDisplaced = true;
                  _loc6_.displacementX = param1.readUnsignedShort();
                  _loc6_.displacementY = param1.readUnsignedShort();
                  continue;
               case FLAG_HEIGHT:
                  _loc6_.isHeight = true;
                  _loc6_.elevation = param1.readUnsignedShort();
                  continue;
               case FLAG_LYINGOBJECT:
                  _loc6_.isLyingObject = true;
                  continue;
               case FLAG_ANIMATEALWAYS:
                  _loc6_.isAnimateAlways = true;
                  continue;
               case FLAG_AUTOMAP:
                  _loc6_.isAutomap = true;
                  _loc6_.automapColour = param1.readUnsignedShort();
                  continue;
               case FLAG_LENSHELP:
                  _loc6_.isLensHelp = true;
                  _loc6_.lensHelp = param1.readUnsignedShort();
                  continue;
               case FLAG_FULLBANK:
                  _loc6_.isFullBank = true;
                  continue;
               case FLAG_IGNORELOOK:
                  _loc6_.isIgnoreLook = true;
                  continue;
               case FLAG_CLOTHES:
                  _loc6_.isCloth = true;
                  _loc6_.clothSlot = param1.readUnsignedShort();
                  continue;
               case FLAG_WRAPPABLE:
                  _loc6_.isWrappable = true;
                  continue;
               case FLAG_UNWRAPPABLE:
                  _loc6_.isUnwrappable = true;
                  continue;
               case FLAG_DEFAULT_ACTION:
                  _loc6_.isDefaultAction = true;
                  _loc13_ = param1.readUnsignedShort();
                  switch(_loc13_)
                  {
                     case 0:
                        _loc6_.defaultAction = ACTION_NONE;
                        break;
                     case 1:
                        _loc6_.defaultAction = ACTION_LOOK;
                        break;
                     case 2:
                        _loc6_.defaultAction = ACTION_USE;
                        break;
                     case 3:
                        _loc6_.defaultAction = ACTION_OPEN;
                        break;
                     case 4:
                        _loc6_.defaultAction = ACTION_AUTOWALK_HIGHLIGHT;
                  }
                  continue;
               case FLAG_MARKET:
                  _loc6_.isMarket = true;
                  _loc6_.marketCategory = param1.readUnsignedShort();
                  if(!MarketWidget.isValidCategoryID(_loc6_.marketCategory))
                  {
                     throw new Error("AppearanceStorage.readAppearanceType: Invalid market category  " + _loc6_.marketCategory + ".");
                  }
                  _loc6_.marketTradeAs = param1.readUnsignedShort();
                  _loc6_.marketShowAs = param1.readUnsignedShort();
                  _loc6_.marketName = StringHelper.s_ReadLongStringFromByteArray(param1,MarketWidget.DETAIL_NAME_LENGTH);
                  _loc6_.marketNameLowerCase = _loc6_.marketName.toLowerCase();
                  _loc6_.marketRestrictProfession = param1.readUnsignedShort();
                  _loc6_.marketRestrictLevel = param1.readUnsignedShort();
                  continue;
               case FLAG_TOP_EFFECT:
                  _loc6_.isTopEffect = true;
                  continue;
               case 255:
                  continue;
               default:
                  break loop0;
            }
         }
         throw new Error("AppearanceStorage.readAppearanceType: Invalid flag: " + _loc7_ + ".");
      }
      
      public function getCachedObjectTypeName(param1:int, param2:int) : String
      {
         var _loc3_:AppearanceTypeInfo = this.getTypeInfo(this.m_ObjectTypeInfoCache,param1,param2);
         if(_loc3_ != null)
         {
            return _loc3_.name;
         }
         return null;
      }
      
      private function getTypeInfo(param1:Vector.<AppearanceTypeInfo>, param2:int, param3:int) : AppearanceTypeInfo
      {
         var _loc4_:int = 0;
         var _loc5_:int = param1.length - 1;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         while(_loc4_ <= _loc5_)
         {
            _loc6_ = (_loc4_ + _loc5_) / 2;
            _loc7_ = AppearanceTypeRef.s_CompareExternal(param1[_loc6_],param2,param3);
            if(_loc7_ < 0)
            {
               _loc4_ = _loc6_ + 1;
               continue;
            }
            if(_loc7_ > 0)
            {
               _loc5_ = _loc6_ - 1;
               continue;
            }
            return param1[_loc6_];
         }
         return null;
      }
      
      public function createMissileInstance(param1:uint, param2:Vector3D, param3:Vector3D) : MissileInstance
      {
         if(param1 >= 1 && param1 < this.m_MissileTypes.length)
         {
            return new MissileInstance(param1,this.m_MissileTypes[param1],param2,param3);
         }
         return null;
      }
   }
}
