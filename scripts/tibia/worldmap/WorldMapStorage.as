package tibia.worldmap
{
   import mx.resources.ResourceManager;
   import tibia.appearances.ObjectInstance;
   import tibia.appearances.AppearanceInstance;
   import shared.utility.Colour;
   import shared.utility.Vector3D;
   import tibia.options.OptionsStorage;
   import tibia.appearances.AppearanceStorage;
   import tibia.appearances.TextualEffectInstance;
   import tibia.chat.MessageMode;
   import tibia.chat.MessageFilterSet;
   import tibia.chat.NameFilterSet;
   import tibia.creatures.Creature;
   import tibia.creatures.CreatureStorage;
   import tibia.appearances.MissileInstance;
   
   public class WorldMapStorage
   {
      
      public static const ONSCREEN_TARGET_BOX_BOTTOM:int = 0;
      
      protected static const RENDERER_DEFAULT_HEIGHT:Number = MAP_WIDTH * FIELD_SIZE;
      
      public static const ONSCREEN_TARGET_EFFECT_COORDINATE:int = 5;
      
      public static const ONSCREEN_TARGET_BOX_HIGH:int = 2;
      
      protected static const NUM_EFFECTS:int = 200;
      
      protected static const MAP_HEIGHT:int = 11;
      
      private static const BUNDLE:String = "WorldMapStorage";
      
      protected static const RENDERER_DEFAULT_WIDTH:Number = MAP_WIDTH * FIELD_SIZE;
      
      protected static const ONSCREEN_MESSAGE_WIDTH:int = 295;
      
      protected static const FIELD_ENTER_POSSIBLE:uint = 0;
      
      public static const MSG_NPC_TOO_FAR:String = ResourceManager.getInstance().getString(BUNDLE,"MSG_NPC_TOO_FAR");
      
      public static const ONSCREEN_TARGET_BOX_LOW:int = 1;
      
      public static const MSG_PATH_GO_DOWNSTAIRS:String = ResourceManager.getInstance().getString(BUNDLE,"MSG_PATH_GO_DOWNSTAIRS");
      
      protected static const OBJECT_UPDATE_INTERVAL:int = 40;
      
      protected static const FIELD_ENTER_NOT_POSSIBLE:uint = 2;
      
      public static const ONSCREEN_TARGET_NONE:int = -1;
      
      public static const MSG_PATH_GO_UPSTAIRS:String = ResourceManager.getInstance().getString(BUNDLE,"MSG_PATH_GO_UPSTAIRS");
      
      protected static const UNDERGROUND_LAYER:int = 2;
      
      protected static const NUM_FIELDS:int = MAPSIZE_Z * MAPSIZE_Y * MAPSIZE_X;
      
      protected static const FIELD_HEIGHT:int = 24;
      
      protected static const FIELD_CACHESIZE:int = FIELD_SIZE;
      
      public static const MSG_PATH_UNREACHABLE:String = ResourceManager.getInstance().getString(BUNDLE,"MSG_PATH_UNREACHABLE");
      
      protected static const ONSCREEN_MESSAGE_HEIGHT:int = 195;
      
      protected static const AMBIENT_UPDATE_INTERVAL:int = 1000;
      
      protected static const MAP_MIN_X:int = 24576;
      
      protected static const MAP_MIN_Y:int = 24576;
      
      protected static const MAP_MIN_Z:int = 0;
      
      protected static const PLAYER_OFFSET_Y:int = 6;
      
      protected static const FIELD_SIZE:int = 32;
      
      protected static const FIELD_ENTER_POSSIBLE_NO_ANIMATION:uint = 1;
      
      protected static const RENDERER_MIN_HEIGHT:Number = Math.round(MAP_HEIGHT * 2 / 3 * FIELD_SIZE);
      
      protected static const PLAYER_OFFSET_X:int = 8;
      
      public static const ONSCREEN_TARGET_BOX_TOP:int = 3;
      
      protected static const MAPSIZE_W:int = 10;
      
      protected static const MAPSIZE_X:int = MAP_WIDTH + 3;
      
      protected static const MAPSIZE_Y:int = MAP_HEIGHT + 3;
      
      protected static const MAPSIZE_Z:int = 8;
      
      protected static const MAP_MAX_X:int = MAP_MIN_X + (1 << 14 - 1);
      
      protected static const MAP_MAX_Y:int = MAP_MIN_Y + (1 << 14 - 1);
      
      protected static const MAP_MAX_Z:int = 15;
      
      protected static const RENDERER_MIN_WIDTH:Number = Math.round(MAP_WIDTH * 2 / 3 * FIELD_SIZE);
      
      public static const ONSCREEN_TARGET_BOX_COORDINATE:int = 4;
      
      protected static const MAP_WIDTH:int = 15;
      
      protected static const NUM_ONSCREEN_MESSAGES:int = 16;
      
      public static const MSG_SORRY_NOT_POSSIBLE:String = ResourceManager.getInstance().getString(BUNDLE,"MSG_SORRY_NOT_POSSIBLE");
      
      public static const MSG_PATH_TOO_FAR:String = ResourceManager.getInstance().getString(BUNDLE,"MSG_PATH_TOO_FAR");
      
      protected static const GROUND_LAYER:int = 7;
       
      
      var m_AmbientTargetColour:Colour = null;
      
      var m_AmbientTargetBrightness:int = 0;
      
      var m_CacheObjectsCount:Vector.<int>;
      
      var m_EffectCount:int = 0;
      
      var m_Field:Vector.<tibia.worldmap.Field>;
      
      var m_MessageBoxes:Vector.<tibia.worldmap.OnscreenMessageBox>;
      
      var m_AmbientCurrentColour:Colour = null;
      
      var m_AmbientCurrentBrightness:int = 0;
      
      protected var m_Options:OptionsStorage = null;
      
      var m_Effect:Vector.<AppearanceInstance>;
      
      protected var m_CacheValid:Boolean = false;
      
      private const m_LayerBrightnessInfos:Vector.<Vector.<Boolean>> = new Vector.<Vector.<Boolean>>(MAPSIZE_Z,false);
      
      var m_Position:Vector3D = null;
      
      var m_Origin:Vector3D = null;
      
      protected var m_AmbientNextUpdate:Number = 0;
      
      protected var m_ObjectNextUpdate:Number = 0;
      
      var m_LayoutOnscreenMessages:Boolean = false;
      
      var m_PlayerZPlane:int = 0;
      
      protected var m_HelperCoordinate:Vector3D;
      
      var m_CacheFullbank:Boolean = false;
      
      public function WorldMapStorage()
      {
         this.m_Field = new Vector.<tibia.worldmap.Field>(NUM_FIELDS,true);
         this.m_Effect = new Vector.<AppearanceInstance>(NUM_EFFECTS,true);
         this.m_MessageBoxes = new Vector.<tibia.worldmap.OnscreenMessageBox>();
         this.m_CacheObjectsCount = new Vector.<int>(MAPSIZE_Z);
         this.m_HelperCoordinate = new Vector3D();
         super();
         this.m_Position = new Vector3D(0,0,0);
         this.m_PlayerZPlane = 0;
         this.m_Origin = new Vector3D(0,0,0);
         var _loc1_:int = 0;
         while(_loc1_ < NUM_FIELDS)
         {
            this.m_Field[_loc1_] = new tibia.worldmap.Field();
            _loc1_++;
         }
         this.m_EffectCount = 0;
         this.m_MessageBoxes[ONSCREEN_TARGET_BOX_BOTTOM] = new tibia.worldmap.OnscreenMessageBox(null,null,0,MessageMode.MESSAGE_NONE,1);
         this.m_MessageBoxes[ONSCREEN_TARGET_BOX_LOW] = new tibia.worldmap.OnscreenMessageBox(null,null,0,MessageMode.MESSAGE_NONE,NUM_ONSCREEN_MESSAGES);
         this.m_MessageBoxes[ONSCREEN_TARGET_BOX_HIGH] = new tibia.worldmap.OnscreenMessageBox(null,null,0,MessageMode.MESSAGE_NONE,1);
         this.m_MessageBoxes[ONSCREEN_TARGET_BOX_TOP] = new tibia.worldmap.OnscreenMessageBox(null,null,0,MessageMode.MESSAGE_NONE,NUM_ONSCREEN_MESSAGES);
         this.m_AmbientCurrentColour = new Colour(0,0,0);
         this.m_AmbientCurrentBrightness = -1;
         this.m_AmbientTargetColour = new Colour(0,0,0);
         this.m_AmbientTargetBrightness = -1;
         var _loc2_:int = 0;
         while(_loc2_ < MAPSIZE_Z)
         {
            this.m_CacheObjectsCount[_loc2_] = 0;
            _loc2_++;
         }
         this.m_CacheFullbank = false;
         this.m_CacheValid = false;
         this.m_AmbientNextUpdate = 0;
         this.m_ObjectNextUpdate = 0;
         var _loc3_:uint = 0;
         while(_loc3_ < MAPSIZE_Z)
         {
            this.m_LayerBrightnessInfos[_loc3_] = new Vector.<Boolean>(MAPSIZE_X * MAPSIZE_Y,false);
            _loc3_++;
         }
      }
      
      public function appendObject(param1:int, param2:int, param3:int, param4:ObjectInstance) : ObjectInstance
      {
         var _loc5_:ObjectInstance = this.m_Field[this.toIndexInternal(param1,param2,param3)].putObject(param4,MAPSIZE_W);
         if(_loc5_ != null && _loc5_.ID == AppearanceInstance.CREATURE)
         {
            Tibia.s_GetCreatureStorage().markOpponentVisible(_loc5_.data,false);
         }
         if(_loc5_ == null)
         {
            this.m_CacheObjectsCount[(this.m_Origin.z + param3) % MAPSIZE_Z]++;
         }
         if(param4.type.isFullBank)
         {
            this.m_CacheFullbank = false;
         }
         return _loc5_;
      }
      
      public function getMiniMapColour(param1:int, param2:int, param3:int) : uint
      {
         return this.m_Field[this.toIndexInternal(param1,param2,param3)].m_MiniMapColour;
      }
      
      public function getObjectPerLayer(param1:int) : int
      {
         if(param1 < 0 || param1 >= MAPSIZE_Z)
         {
            throw new ArgumentError("WorldMapStorage.getObjectPerLayer: Z=" + param1 + " is out of range.");
         }
         return this.m_CacheObjectsCount[(this.m_Origin.z + param1) % MAPSIZE_Z];
      }
      
      public function getEnvironmentalEffect(param1:int, param2:int, param3:int) : ObjectInstance
      {
         return this.m_Field[this.toIndexInternal(param1,param2,param3)].getEnvironmentalEffect();
      }
      
      public function toAbsolute(param1:Vector3D, param2:Vector3D = null) : Vector3D
      {
         if(param1.x < 0 || param1.x >= MAPSIZE_X || param1.y < 0 || param1.y >= MAPSIZE_Y || param1.z < 0 || param1.z >= MAPSIZE_Z)
         {
            throw new ArgumentError("WorldMapStorage.toAbsolute: Invalid co-ordinate: " + param1 + ".");
         }
         var _loc3_:int = param1.z - this.m_PlayerZPlane;
         if(param2 == null)
         {
            return new Vector3D(param1.x + (this.m_Position.x - PLAYER_OFFSET_X) + _loc3_,param1.y + (this.m_Position.y - PLAYER_OFFSET_Y) + _loc3_,this.m_Position.z - _loc3_);
         }
         param2.x = param1.x + (this.m_Position.x - PLAYER_OFFSET_X) + _loc3_;
         param2.y = param1.y + (this.m_Position.y - PLAYER_OFFSET_Y) + _loc3_;
         param2.z = this.m_Position.z - _loc3_;
         return param2;
      }
      
      public function updateMiniMap(param1:int, param2:int, param3:int) : void
      {
         this.m_Field[this.toIndexInternal(param1,param2,param3)].updateMiniMap();
      }
      
      public function getFieldHeight(param1:int, param2:int, param3:int) : int
      {
         var _loc7_:ObjectInstance = null;
         var _loc4_:tibia.worldmap.Field = this.m_Field[this.toIndexInternal(param1,param2,param3)];
         var _loc5_:int = 0;
         var _loc6_:int = _loc4_.m_ObjectsCount - 1;
         while(_loc6_ >= 0)
         {
            _loc7_ = _loc4_.m_ObjectsNetwork[_loc6_];
            if(_loc7_.type.isHeight)
            {
               _loc5_++;
            }
            _loc6_--;
         }
         return _loc5_;
      }
      
      public function getPositionZ() : int
      {
         return this.m_Position.z;
      }
      
      public function resetMap() : void
      {
         this.m_Position.setZero();
         this.m_PlayerZPlane = 0;
         this.m_Origin.setZero();
         var _loc1_:int = 0;
         while(_loc1_ < NUM_FIELDS)
         {
            this.m_Field[_loc1_].reset();
            _loc1_++;
         }
         var _loc2_:int = 0;
         while(_loc2_ < NUM_EFFECTS)
         {
            this.m_Effect[_loc2_] = null;
            _loc2_++;
         }
         this.m_EffectCount = 0;
         var _loc3_:int = 0;
         while(_loc3_ < MAPSIZE_Z)
         {
            this.m_CacheObjectsCount[_loc3_] = 0;
            _loc3_++;
         }
         this.m_CacheFullbank = false;
         this.m_CacheValid = false;
         this.m_AmbientNextUpdate = 0;
         this.m_ObjectNextUpdate = 0;
      }
      
      public function get options() : OptionsStorage
      {
         return this.m_Options;
      }
      
      public function getTopLookObject(param1:int, param2:int, param3:int, param4:Object = null) : int
      {
         return this.m_Field[this.toIndexInternal(param1,param2,param3)].getTopLookObject(param4);
      }
      
      public function refreshFields() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         _loc3_ = 0;
         while(_loc3_ < MAPSIZE_Z)
         {
            if(this.getObjectPerLayer(_loc3_) > 0)
            {
               this.m_HelperCoordinate.setComponents(0,0,_loc3_);
               this.toAbsolute(this.m_HelperCoordinate,this.m_HelperCoordinate);
               _loc1_ = 0;
               while(_loc1_ < MAPSIZE_X)
               {
                  _loc2_ = 0;
                  while(_loc2_ < MAPSIZE_Y)
                  {
                     this.m_Field[this.toIndexInternal(_loc1_,_loc2_,_loc3_)].updateBitmapCache(this.m_HelperCoordinate.x + _loc1_,this.m_HelperCoordinate.y + _loc2_,this.m_HelperCoordinate.z);
                     _loc2_++;
                  }
                  _loc1_++;
               }
            }
            _loc3_++;
         }
      }
      
      public function addOnscreenMessage(... rest) : tibia.worldmap.OnscreenMessageBox
      {
         var _loc14_:tibia.worldmap.OnscreenMessageBox = null;
         var _loc15_:OnscreenMessage = null;
         var _loc16_:Boolean = false;
         var _loc17_:int = 0;
         var _loc18_:String = null;
         var _loc19_:OnscreenMessage = null;
         var _loc20_:AppearanceStorage = null;
         var _loc21_:TextualEffectInstance = null;
         var _loc2_:Vector3D = null;
         var _loc3_:int = -1;
         var _loc4_:String = null;
         var _loc5_:int = 0;
         var _loc6_:int = MessageMode.MESSAGE_NONE;
         var _loc7_:String = null;
         var _loc8_:Number = NaN;
         var _loc9_:uint = uint.MAX_VALUE;
         if(rest.length == 2)
         {
            _loc6_ = int(rest[0]);
            _loc7_ = rest[1] as String;
         }
         else if(rest.length == 6)
         {
            _loc2_ = rest[0] as Vector3D;
            _loc3_ = int(rest[1]);
            _loc4_ = rest[2] as String;
            _loc5_ = int(rest[3]);
            _loc6_ = int(rest[4]);
            _loc7_ = rest[5] as String;
         }
         else if(rest.length == 7)
         {
            _loc2_ = rest[0] as Vector3D;
            _loc3_ = int(rest[1]);
            _loc4_ = rest[2] as String;
            _loc5_ = int(rest[3]);
            _loc6_ = int(rest[4]);
            _loc8_ = rest[5] as Number;
            _loc9_ = int(rest[6]);
         }
         else
         {
            throw new ArgumentError("WorldMapStorage.addOnscreenMessage: Illegal overload.");
         }
         var _loc10_:MessageFilterSet = null;
         var _loc11_:MessageMode = null;
         var _loc12_:NameFilterSet = null;
         var _loc13_:int = ONSCREEN_TARGET_NONE;
         if(this.m_Options != null && (_loc10_ = this.m_Options.getMessageFilterSet(MessageFilterSet.DEFAULT_SET)) != null && (_loc11_ = _loc10_.getMessageMode(_loc6_)) != null && _loc11_.showOnscreenMessage && (_loc13_ = _loc11_.onscreenTarget) != ONSCREEN_TARGET_NONE && (_loc12_ = this.m_Options.getNameFilterSet(NameFilterSet.DEFAULT_SET)) != null && (_loc11_.ignoreNameFilter || _loc12_.acceptMessage(_loc6_,_loc4_,_loc7_)))
         {
            if(_loc13_ == ONSCREEN_TARGET_BOX_COORDINATE || _loc13_ == ONSCREEN_TARGET_BOX_TOP || _loc13_ == ONSCREEN_TARGET_BOX_HIGH || _loc13_ == ONSCREEN_TARGET_BOX_LOW || _loc13_ == ONSCREEN_TARGET_BOX_BOTTOM)
            {
               _loc14_ = null;
               if(_loc13_ == ONSCREEN_TARGET_BOX_COORDINATE)
               {
                  if(_loc2_ == null)
                  {
                     throw new Error("WorldMapStorage.addOnscreenMessage: Missing co-ordinate.");
                  }
                  _loc16_ = true;
                  _loc17_ = ONSCREEN_TARGET_BOX_COORDINATE;
                  while(_loc17_ < this.m_MessageBoxes.length)
                  {
                     if(this.m_MessageBoxes[_loc17_].position == null || this.m_MessageBoxes[_loc17_].position.equals(_loc2_))
                     {
                        if(this.m_MessageBoxes[_loc17_].speaker == _loc4_ && this.m_MessageBoxes[_loc17_].mode == _loc6_)
                        {
                           _loc14_ = this.m_MessageBoxes[_loc17_];
                           break;
                        }
                        _loc16_ = false;
                     }
                     _loc17_++;
                  }
                  if(_loc14_ == null)
                  {
                     _loc14_ = new tibia.worldmap.OnscreenMessageBox(_loc2_,_loc4_,_loc5_,_loc6_,NUM_ONSCREEN_MESSAGES);
                     _loc14_.visible = _loc16_;
                     _loc18_ = _loc11_.getOnscreenMessageHeader(_loc4_,_loc5_);
                     if(_loc18_ != null)
                     {
                        _loc19_ = new OnscreenMessage(-1,_loc4_,_loc5_,_loc6_,_loc18_);
                        _loc19_.formatMessage(null,_loc11_.textARGB,_loc11_.highlightARGB);
                        _loc19_.TTL = Number.POSITIVE_INFINITY;
                        _loc14_.appendMessage(_loc19_);
                     }
                     this.m_MessageBoxes.push(_loc14_);
                  }
               }
               else
               {
                  _loc14_ = this.m_MessageBoxes[_loc13_];
               }
               _loc15_ = new OnscreenMessage(_loc3_,_loc4_,_loc5_,_loc6_,_loc7_);
               _loc15_.formatMessage(_loc11_.getOnscreenMessagePrefix(_loc4_,_loc5_),_loc11_.textARGB,_loc11_.highlightARGB);
               _loc14_.appendMessage(_loc15_);
               this.invalidateOnscreenMessages();
               return _loc14_;
            }
            if(_loc13_ == ONSCREEN_TARGET_EFFECT_COORDINATE)
            {
               if(_loc2_ == null)
               {
                  throw new Error("WorldMapStorage.addOnscreenMessage: Missing co-ordinate.");
               }
               _loc20_ = null;
               if(_loc8_ > 0 && (_loc20_ = Tibia.s_GetAppearanceStorage()) != null)
               {
                  _loc21_ = _loc20_.createTextualEffectInstance(-1,_loc9_,_loc8_);
                  this.appendEffect(_loc2_.x,_loc2_.y,_loc2_.z,_loc21_);
               }
            }
         }
         return null;
      }
      
      private function deleteEffect(param1:int) : void
      {
         if(param1 < 0 || param1 >= this.m_EffectCount)
         {
            throw new RangeError("WorldMapStorage.deleteEffect: Invalid index: " + param1);
         }
         var _loc2_:AppearanceInstance = this.m_Effect[param1];
         if(_loc2_.mapField != -1)
         {
            this.m_Field[_loc2_.mapField].deleteEffect(_loc2_.mapData);
         }
         _loc2_.mapData = -1;
         _loc2_.mapField = -1;
         this.m_EffectCount--;
         if(param1 < this.m_EffectCount)
         {
            this.m_Effect[param1] = this.m_Effect[this.m_EffectCount];
         }
         this.m_Effect[this.m_EffectCount] = null;
      }
      
      public function changeObject(param1:int, param2:int, param3:int, param4:int, param5:ObjectInstance) : ObjectInstance
      {
         var _loc6_:ObjectInstance = this.m_Field[this.toIndexInternal(param1,param2,param3)].changeObject(param5,param4);
         if(_loc6_ != null && _loc6_.ID == AppearanceInstance.CREATURE && param5 != null && param5.ID == AppearanceInstance.CREATURE && _loc6_.data != param5.data)
         {
            Tibia.s_GetCreatureStorage().markOpponentVisible(_loc6_.data,false);
         }
         if(_loc6_ != null && _loc6_.type.isFullBank || param5.type.isFullBank)
         {
            this.m_CacheFullbank = false;
         }
         return _loc6_;
      }
      
      public function expireOldestMessage() : void
      {
         var _loc4_:Number = NaN;
         var _loc5_:int = 0;
         var _loc1_:Number = Number.POSITIVE_INFINITY;
         var _loc2_:int = -1;
         var _loc3_:int = this.m_MessageBoxes.length - 1;
         while(_loc3_ >= 0)
         {
            _loc4_ = this.m_MessageBoxes[_loc3_].minExpirationTime;
            if(_loc4_ < _loc1_)
            {
               _loc1_ = _loc4_;
               _loc2_ = _loc3_;
            }
            _loc3_--;
         }
         if(_loc2_ > -1)
         {
            _loc5_ = this.m_MessageBoxes[_loc2_].expireOldestMessage();
            if(_loc5_ > 0)
            {
               this.m_LayoutOnscreenMessages = true;
            }
            if(this.m_MessageBoxes[_loc2_].empty && _loc2_ >= ONSCREEN_TARGET_BOX_COORDINATE)
            {
               this.m_MessageBoxes[_loc2_].removeMessages();
               this.m_MessageBoxes.splice(_loc2_,1);
               this.m_LayoutOnscreenMessages = true;
            }
         }
      }
      
      private function toIndexInternal(param1:int, param2:int, param3:int) : int
      {
         if(param1 < 0 || param1 >= MAPSIZE_X || param2 < 0 || param2 >= MAPSIZE_Y || param3 < 0 || param3 >= MAPSIZE_Z)
         {
            throw new ArgumentError("WorldMapStorage.toIndexInternal: Input co-oridnate (" + param1 + ", " + param2 + ", " + param3 + ") is out of range.");
         }
         return ((param3 + this.m_Origin.z) % MAPSIZE_Z * MAPSIZE_X + (param1 + this.m_Origin.x) % MAPSIZE_X) * MAPSIZE_Y + (param2 + this.m_Origin.y) % MAPSIZE_Y;
      }
      
      public function getPosition(param1:Vector3D = null) : Vector3D
      {
         if(param1 == null)
         {
            return this.m_Position.clone();
         }
         param1.setComponents(this.m_Position.x,this.m_Position.y,this.m_Position.z);
         return param1;
      }
      
      public function setPosition(param1:int, param2:int, param3:int) : void
      {
         this.m_Position.x = param1;
         this.m_Position.y = param2;
         this.m_Position.z = param3;
         this.m_PlayerZPlane = param3 <= GROUND_LAYER?int(MAPSIZE_Z - 1 - param3):int(UNDERGROUND_LAYER);
      }
      
      public function getCreatureObjectForCreature(param1:Creature, param2:Object = null) : int
      {
         var _loc3_:Vector3D = null;
         if(param1 != null)
         {
            _loc3_ = this.toMap(param1.position);
            return this.m_Field[this.toIndexInternal(_loc3_.x,_loc3_.y,_loc3_.z)].getCreatureObjectForCreatureID(param1.ID,param2);
         }
         return -1;
      }
      
      public function getObject(param1:int, param2:int, param3:int, param4:int) : ObjectInstance
      {
         return this.m_Field[this.toIndexInternal(param1,param2,param3)].getObject(param4);
      }
      
      public function getLightBlockingTilesForZLayer(param1:uint) : Vector.<Boolean>
      {
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:tibia.worldmap.Field = null;
         var _loc8_:ObjectInstance = null;
         if(param1 < 0 || param1 >= MAPSIZE_Z)
         {
            throw new ArgumentError("WorldMapStorage.toIndexInternal: Input Z co-oridnate (" + param1 + ") is out of range.");
         }
         var _loc2_:Vector.<Boolean> = this.m_LayerBrightnessInfos[param1];
         var _loc3_:uint = 0;
         while(_loc3_ < MAPSIZE_Y)
         {
            _loc4_ = 0;
            while(_loc4_ < MAPSIZE_X)
            {
               _loc5_ = ((param1 + this.m_Origin.z) % MAPSIZE_Z * MAPSIZE_X + (_loc4_ + this.m_Origin.x) % MAPSIZE_X) * MAPSIZE_Y + (_loc3_ + this.m_Origin.y) % MAPSIZE_Y;
               _loc6_ = _loc3_ * MAPSIZE_X + _loc4_;
               _loc7_ = this.m_Field[_loc5_];
               _loc8_ = _loc7_.getObject(0);
               if(_loc8_ == null || !_loc8_.m_Type.isBank)
               {
                  _loc2_[_loc6_] = true;
               }
               else
               {
                  _loc2_[_loc6_] = false;
               }
               _loc4_++;
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function toMapClosest(param1:Vector3D, param2:Vector3D = null) : Vector3D
      {
         var _loc3_:int = 0;
         _loc3_ = this.m_Position.z - param1.z;
         var _loc4_:int = Math.max(0,Math.min(param1.x - (this.m_Position.x - PLAYER_OFFSET_X) - _loc3_,MAPSIZE_X - 1));
         var _loc5_:int = Math.max(0,Math.min(param1.y - (this.m_Position.y - PLAYER_OFFSET_Y) - _loc3_,MAPSIZE_Y - 1));
         var _loc6_:int = Math.max(0,Math.min(this.m_PlayerZPlane + _loc3_,MAPSIZE_Z - 1));
         if(param2 == null)
         {
            return new Vector3D(_loc4_,_loc5_,_loc6_);
         }
         param2.x = _loc4_;
         param2.y = _loc5_;
         param2.z = _loc6_;
         return param2;
      }
      
      public function set options(param1:OptionsStorage) : void
      {
         this.m_Options = param1;
      }
      
      public function putObject(param1:int, param2:int, param3:int, param4:ObjectInstance) : ObjectInstance
      {
         var _loc5_:ObjectInstance = this.m_Field[this.toIndexInternal(param1,param2,param3)].putObject(param4,-1);
         if(_loc5_ != null && _loc5_.ID == AppearanceInstance.CREATURE)
         {
            Tibia.s_GetCreatureStorage().markOpponentVisible(_loc5_.data,false);
         }
         if(_loc5_ == null)
         {
            this.m_CacheObjectsCount[(this.m_Origin.z + param3) % MAPSIZE_Z]++;
         }
         if(_loc5_ != null && _loc5_.type.isFullBank || param4.type.isFullBank)
         {
            this.m_CacheFullbank = false;
         }
         return _loc5_;
      }
      
      public function getEnterPossibleFlag(param1:int, param2:int, param3:int, param4:Boolean) : uint
      {
         var _loc8_:ObjectInstance = null;
         var _loc5_:tibia.worldmap.Field = this.m_Field[this.toIndexInternal(param1,param2,param3)];
         if(param4 && param1 < MAPSIZE_X - 1 && param2 < MAPSIZE_Y - 1 && param3 > 0 && _loc5_.m_ObjectsCount > 0 && !_loc5_.m_ObjectsNetwork[0].type.isBank && this.getFieldHeight(param1 + 1,param2 + 1,param3 - 1) > 2)
         {
            return FIELD_ENTER_POSSIBLE;
         }
         if(param4 && this.getFieldHeight(PLAYER_OFFSET_X,PLAYER_OFFSET_Y,this.m_PlayerZPlane) > 2)
         {
            return FIELD_ENTER_POSSIBLE;
         }
         var _loc6_:Creature = null;
         var _loc7_:int = 0;
         while(_loc7_ < _loc5_.m_ObjectsCount)
         {
            _loc8_ = _loc5_.m_ObjectsNetwork[_loc7_];
            if(_loc8_.ID == AppearanceInstance.CREATURE && _loc6_ == null)
            {
               _loc6_ = Tibia.s_GetCreatureStorage().getCreature(_loc8_.data);
               if(!_loc6_.isTrapper && _loc6_.isUnpassable)
               {
                  return !!_loc6_.isHuman?uint(FIELD_ENTER_POSSIBLE_NO_ANIMATION):uint(FIELD_ENTER_NOT_POSSIBLE);
               }
            }
            else
            {
               if(_loc8_.type.isUnpassable)
               {
                  return FIELD_ENTER_NOT_POSSIBLE;
               }
               if(_loc8_.type.preventMovementAnimation)
               {
                  return FIELD_ENTER_POSSIBLE_NO_ANIMATION;
               }
            }
            _loc7_++;
         }
         return FIELD_ENTER_POSSIBLE;
      }
      
      private function moveEffect(param1:int, param2:int, param3:int, param4:int) : void
      {
         if(param4 < 0 || param4 >= this.m_EffectCount)
         {
            throw new RangeError("WorldMapStorage.moveEffect: Invalid effect index: " + param4);
         }
         var _loc5_:Vector3D = this.toMapInternal(new Vector3D(param1,param2,param3));
         var _loc6_:int = -1;
         if(_loc5_ != null)
         {
            _loc6_ = this.toIndexInternal(_loc5_.x,_loc5_.y,_loc5_.z);
         }
         var _loc7_:AppearanceInstance = this.m_Effect[param4];
         if(_loc7_.mapField == _loc6_)
         {
            return;
         }
         if(_loc7_.mapField > -1)
         {
            this.m_Field[_loc7_.mapField].deleteEffect(_loc7_.mapData);
            _loc7_.mapData = 0;
            _loc7_.mapField = -1;
         }
         if(_loc6_ > -1)
         {
            _loc7_.mapData = 0;
            _loc7_.mapField = _loc6_;
            this.m_Field[_loc6_].appendEffect(_loc7_);
         }
      }
      
      private function toMapInternal(param1:Vector3D, param2:Vector3D = null) : Vector3D
      {
         var _loc3_:int = 0;
         if(param1 == null)
         {
            return null;
         }
         _loc3_ = this.m_Position.z - param1.z;
         var _loc4_:int = param1.x - (this.m_Position.x - PLAYER_OFFSET_X) - _loc3_;
         var _loc5_:int = param1.y - (this.m_Position.y - PLAYER_OFFSET_Y) - _loc3_;
         var _loc6_:int = this.m_PlayerZPlane + _loc3_;
         if(_loc4_ < 0 || _loc4_ >= MAPSIZE_X || _loc5_ < 0 || _loc5_ >= MAPSIZE_Y || _loc6_ < 0 || _loc6_ >= MAPSIZE_Z)
         {
            return null;
         }
         if(param2 == null)
         {
            return new Vector3D(_loc4_,_loc5_,_loc6_);
         }
         param2.x = _loc4_;
         param2.y = _loc5_;
         param2.z = _loc6_;
         return param2;
      }
      
      public function getTopUseObject(param1:int, param2:int, param3:int, param4:Object = null) : int
      {
         return this.m_Field[this.toIndexInternal(param1,param2,param3)].getTopUseObject(param4);
      }
      
      public function deleteObject(param1:int, param2:int, param3:int, param4:int) : ObjectInstance
      {
         var _loc5_:ObjectInstance = this.m_Field[this.toIndexInternal(param1,param2,param3)].deleteObject(param4);
         if(_loc5_ != null && _loc5_.ID == AppearanceInstance.CREATURE)
         {
            Tibia.s_GetCreatureStorage().markOpponentVisible(_loc5_.data,false);
         }
         if(_loc5_ != null)
         {
            this.m_CacheObjectsCount[(this.m_Origin.z + param3) % MAPSIZE_Z]--;
         }
         if(_loc5_ != null && _loc5_.type.isFullBank)
         {
            this.m_CacheFullbank = false;
         }
         return _loc5_;
      }
      
      public function getField(param1:int, param2:int, param3:int) : tibia.worldmap.Field
      {
         return this.m_Field[this.toIndexInternal(param1,param2,param3)];
      }
      
      public function getAmbientColour() : Colour
      {
         return this.m_AmbientCurrentColour;
      }
      
      public function reset() : void
      {
         this.resetMap();
         this.resetOnscreenMessages();
      }
      
      public function invalidateOnscreenMessages() : void
      {
         this.m_LayoutOnscreenMessages = true;
      }
      
      public function getAmbientBrightness() : int
      {
         return this.m_AmbientCurrentBrightness;
      }
      
      public function getMiniMapCost(param1:int, param2:int, param3:int) : int
      {
         return this.m_Field[this.toIndexInternal(param1,param2,param3)].m_MiniMapCost;
      }
      
      public function scrollMap(param1:int, param2:int, param3:int = 0) : void
      {
         if(param1 < -MAPSIZE_X || param1 > MAPSIZE_X)
         {
            throw new ArgumentError("WorldMapStorage.scrollMap: X=" + param1 + " is out of range.");
         }
         if(param2 < -MAPSIZE_Y || param2 > MAPSIZE_Y)
         {
            throw new ArgumentError("WorldMapStorage.scrollMap: Y=" + param2 + " is out of range.");
         }
         if(param3 < -MAPSIZE_Z || param3 > MAPSIZE_Z)
         {
            throw new ArgumentError("WorldMapStorage.scrollMap: Z=" + param3 + " is out of range.");
         }
         if(param1 * param2 + param2 * param3 + param1 * param3 != 0)
         {
            throw new ArgumentError("WorldMapStorage.scrollMap: Only one of the agruments  may be != 0.");
         }
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         if(param1 != 0)
         {
            _loc4_ = 0;
            _loc5_ = -param1;
            if(param1 > 0)
            {
               _loc4_ = MAPSIZE_X - param1;
               _loc5_ = MAPSIZE_X;
            }
            _loc6_ = _loc4_;
            while(_loc6_ < _loc5_)
            {
               _loc7_ = 0;
               while(_loc7_ < MAPSIZE_Y)
               {
                  _loc8_ = 0;
                  while(_loc8_ < MAPSIZE_Z)
                  {
                     this.resetField(_loc6_,_loc7_,_loc8_);
                     _loc8_++;
                  }
                  _loc7_++;
               }
               _loc6_++;
            }
            this.m_Origin.x = this.m_Origin.x - param1;
            if(this.m_Origin.x < 0)
            {
               this.m_Origin.x = this.m_Origin.x + MAPSIZE_X;
            }
            this.m_Origin.x = this.m_Origin.x % MAPSIZE_X;
         }
         if(param2 != 0)
         {
            _loc4_ = 0;
            _loc5_ = -param2;
            if(param2 > 0)
            {
               _loc4_ = MAPSIZE_Y - param2;
               _loc5_ = MAPSIZE_Y;
            }
            _loc6_ = 0;
            while(_loc6_ < MAPSIZE_X)
            {
               _loc7_ = _loc4_;
               while(_loc7_ < _loc5_)
               {
                  _loc8_ = 0;
                  while(_loc8_ < MAPSIZE_Z)
                  {
                     this.resetField(_loc6_,_loc7_,_loc8_);
                     _loc8_++;
                  }
                  _loc7_++;
               }
               _loc6_++;
            }
            this.m_Origin.y = this.m_Origin.y - param2;
            if(this.m_Origin.y < 0)
            {
               this.m_Origin.y = this.m_Origin.y + MAPSIZE_Y;
            }
            this.m_Origin.y = this.m_Origin.y % MAPSIZE_Y;
         }
         if(param3 != 0)
         {
            _loc4_ = 0;
            _loc5_ = -param3;
            if(param3 > 0)
            {
               _loc4_ = MAPSIZE_Z - param3;
               _loc5_ = MAPSIZE_Z;
            }
            _loc6_ = 0;
            while(_loc6_ < MAPSIZE_X)
            {
               _loc7_ = 0;
               while(_loc7_ < MAPSIZE_Y)
               {
                  _loc8_ = _loc4_;
                  while(_loc8_ < _loc5_)
                  {
                     this.resetField(_loc6_,_loc7_,_loc8_);
                     _loc8_++;
                  }
                  _loc7_++;
               }
               _loc6_++;
            }
            this.m_Origin.z = this.m_Origin.z - param3;
            if(this.m_Origin.z < 0)
            {
               this.m_Origin.z = this.m_Origin.z + MAPSIZE_Z;
            }
            this.m_Origin.z = this.m_Origin.z % MAPSIZE_Z;
            if(param3 > 0)
            {
               _loc6_ = 0;
               while(_loc6_ < MAPSIZE_X)
               {
                  _loc7_ = 0;
                  while(_loc7_ < MAPSIZE_Y)
                  {
                     _loc8_ = MAPSIZE_Z - UNDERGROUND_LAYER - 1;
                     while(_loc8_ < MAPSIZE_Z)
                     {
                        this.resetField(_loc6_,_loc7_,_loc8_);
                        _loc8_++;
                     }
                     _loc7_++;
                  }
                  _loc6_++;
               }
            }
         }
      }
      
      public function getTopCreatureObject(param1:int, param2:int, param3:int, param4:Object = null) : int
      {
         return this.m_Field[this.toIndexInternal(param1,param2,param3)].getTopCreatureObject(param4);
      }
      
      public function isTranslucent(param1:int, param2:int, param3:int) : Boolean
      {
         return this.m_Field[this.toIndexInternal(param1,param2,param3)].m_CacheTranslucent;
      }
      
      public function setAmbientLight(param1:Colour, param2:int) : void
      {
         if(param1 == null)
         {
            throw new ArgumentError("WorldMapStorage.setAmbientLight: Invalid colour value.");
         }
         var _loc3_:* = this.m_AmbientTargetBrightness < 0;
         this.m_AmbientTargetColour = param1;
         this.m_AmbientTargetBrightness = param2;
         if(_loc3_)
         {
            this.m_AmbientCurrentColour = this.m_AmbientTargetColour;
            this.m_AmbientCurrentBrightness = this.m_AmbientTargetBrightness;
         }
      }
      
      public function toMap(param1:Vector3D, param2:Vector3D = null) : Vector3D
      {
         if(param1 == null)
         {
            throw new ArgumentError("WorldMapStorage.toMap: Input co-ordinate is null.");
         }
         var _loc3_:Vector3D = this.toMapInternal(param1,param2);
         if(_loc3_ == null)
         {
            throw new ArgumentError("WorldMapStorage.toMap: Input co-ordinate " + param1 + " is out of range.");
         }
         return _loc3_;
      }
      
      public function appendEffect(param1:int, param2:int, param3:int, param4:AppearanceInstance) : void
      {
         var _loc8_:int = 0;
         var _loc9_:AppearanceInstance = null;
         var _loc5_:Vector3D = this.toMapInternal(new Vector3D(param1,param2,param3));
         var _loc6_:int = -1;
         var _loc7_:tibia.worldmap.Field = null;
         if(_loc5_ != null)
         {
            _loc6_ = this.toIndexInternal(_loc5_.x,_loc5_.y,_loc5_.z);
            _loc7_ = this.m_Field[_loc6_];
         }
         if(_loc7_ != null && param4 is TextualEffectInstance)
         {
            _loc8_ = _loc7_.m_EffectsCount - 1;
            while(_loc8_ >= 0)
            {
               _loc9_ = _loc7_.m_Effects[_loc8_];
               if(_loc9_ is TextualEffectInstance && TextualEffectInstance(_loc9_).merge(param4))
               {
                  return;
               }
               _loc8_--;
            }
         }
         if(this.m_EffectCount < NUM_EFFECTS)
         {
            param4.mapField = _loc6_;
            param4.mapData = 0;
            if(_loc7_ != null)
            {
               _loc7_.appendEffect(param4);
            }
            this.m_Effect[this.m_EffectCount] = param4;
            this.m_EffectCount++;
         }
      }
      
      public function insertObject(param1:int, param2:int, param3:int, param4:int, param5:ObjectInstance) : ObjectInstance
      {
         var _loc6_:ObjectInstance = this.m_Field[this.toIndexInternal(param1,param2,param3)].putObject(param5,param4);
         if(_loc6_ != null && _loc6_.ID == AppearanceInstance.CREATURE)
         {
            Tibia.s_GetCreatureStorage().markOpponentVisible(_loc6_.data,false);
         }
         if(_loc6_ == null)
         {
            this.m_CacheObjectsCount[(this.m_Origin.z + param3) % MAPSIZE_Z]++;
         }
         if(_loc6_ != null && _loc6_.type.isFullBank || param5.type.isFullBank)
         {
            this.m_CacheFullbank = false;
         }
         return _loc6_;
      }
      
      public function isVisible(param1:int, param2:int, param3:int, param4:Boolean) : Boolean
      {
         var _loc5_:Vector3D = new Vector3D(param1,param2,param3);
         _loc5_ = this.toMapInternal(_loc5_,_loc5_);
         return _loc5_ != null && (param4 || this.m_Position.z == param3);
      }
      
      public function resetField(param1:int, param2:int, param3:int, param4:Boolean = true, param5:Boolean = true) : void
      {
         var _loc8_:CreatureStorage = null;
         var _loc9_:int = 0;
         var _loc10_:ObjectInstance = null;
         var _loc11_:int = 0;
         var _loc6_:int = this.toIndexInternal(param1,param2,param3);
         var _loc7_:tibia.worldmap.Field = this.m_Field[_loc6_];
         this.m_CacheObjectsCount[(this.m_Origin.z + param3) % MAPSIZE_Z] = this.m_CacheObjectsCount[(this.m_Origin.z + param3) % MAPSIZE_Z] - _loc7_.m_ObjectsCount;
         this.m_CacheFullbank = false;
         if(param4)
         {
            _loc8_ = Tibia.s_GetCreatureStorage();
            _loc9_ = _loc7_.m_ObjectsCount - 1;
            while(_loc9_ >= 0)
            {
               _loc10_ = _loc7_.m_ObjectsNetwork[_loc9_];
               if(_loc10_.ID == AppearanceInstance.CREATURE)
               {
                  _loc8_.markOpponentVisible(_loc10_.data,false);
               }
               _loc9_--;
            }
         }
         _loc7_.resetObjects();
         if(param5)
         {
            _loc11_ = this.m_EffectCount - 1;
            while(_loc11_ >= 0)
            {
               if(this.m_Effect[_loc11_].mapField == _loc6_)
               {
                  this.deleteEffect(_loc11_);
               }
               _loc11_--;
            }
            _loc7_.resetEffects();
         }
      }
      
      public function getTopMultiUseObject(param1:int, param2:int, param3:int, param4:Object = null) : int
      {
         return this.m_Field[this.toIndexInternal(param1,param2,param3)].getTopMultiUseObject(param4);
      }
      
      public function getTopMoveObject(param1:int, param2:int, param3:int, param4:Object = null) : int
      {
         return this.m_Field[this.toIndexInternal(param1,param2,param3)].getTopMoveObject(param4);
      }
      
      public function setEnvironmentalEffect(param1:int, param2:int, param3:int, param4:ObjectInstance) : void
      {
         this.m_Field[this.toIndexInternal(param1,param2,param3)].setEnvironmentalEffect(param4);
      }
      
      public function animate() : void
      {
         var _loc4_:AppearanceInstance = null;
         var _loc5_:Vector3D = null;
         var _loc6_:tibia.worldmap.Field = null;
         var _loc7_:int = 0;
         var _loc1_:Number = Tibia.s_FrameTibiaTimestamp;
         if(_loc1_ < this.m_ObjectNextUpdate)
         {
            return;
         }
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         _loc2_ = this.m_EffectCount - 1;
         while(_loc2_ >= 0)
         {
            _loc4_ = this.m_Effect[_loc2_];
            if(!_loc4_.animate(_loc1_))
            {
               this.deleteEffect(_loc2_);
            }
            else if(_loc4_ is MissileInstance)
            {
               _loc5_ = (_loc4_ as MissileInstance).position;
               this.moveEffect(_loc5_.x,_loc5_.y,_loc5_.z,_loc2_);
            }
            _loc2_--;
         }
         _loc2_ = NUM_FIELDS - 1;
         while(_loc2_ >= 0)
         {
            _loc6_ = this.m_Field[_loc2_];
            _loc3_ = _loc6_.m_ObjectsCount - 1;
            while(_loc3_ >= 0)
            {
               _loc6_.m_ObjectsNetwork[_loc3_].animate(_loc1_);
               _loc3_--;
            }
            if(_loc6_.m_Environment != null)
            {
               _loc6_.m_Environment.animate(_loc1_);
            }
            _loc2_--;
         }
         _loc2_ = this.m_MessageBoxes.length - 1;
         while(_loc2_ >= 0)
         {
            _loc7_ = this.m_MessageBoxes[_loc2_].expireMessages(_loc1_);
            if(_loc7_ > 0)
            {
               this.m_LayoutOnscreenMessages = true;
            }
            if(this.m_MessageBoxes[_loc2_].empty && _loc2_ >= ONSCREEN_TARGET_BOX_COORDINATE)
            {
               _loc3_ = _loc2_ + 1;
               while(_loc3_ < this.m_MessageBoxes.length)
               {
                  if(this.m_MessageBoxes[_loc3_].position == null || this.m_MessageBoxes[_loc3_].position.equals(this.m_MessageBoxes[_loc2_].position))
                  {
                     this.m_MessageBoxes[_loc3_].visible = true;
                     break;
                  }
                  _loc3_++;
               }
               this.m_MessageBoxes[_loc2_].removeMessages();
               this.m_MessageBoxes.splice(_loc2_,1);
               this.m_LayoutOnscreenMessages = true;
            }
            _loc2_--;
         }
         if(_loc1_ >= this.m_AmbientNextUpdate)
         {
            if(this.m_AmbientCurrentColour.red < this.m_AmbientTargetColour.red)
            {
               this.m_AmbientCurrentColour.red++;
            }
            if(this.m_AmbientCurrentColour.red > this.m_AmbientTargetColour.red)
            {
               this.m_AmbientCurrentColour.red--;
            }
            if(this.m_AmbientCurrentColour.green < this.m_AmbientTargetColour.green)
            {
               this.m_AmbientCurrentColour.green++;
            }
            if(this.m_AmbientCurrentColour.green > this.m_AmbientTargetColour.green)
            {
               this.m_AmbientCurrentColour.green--;
            }
            if(this.m_AmbientCurrentColour.blue < this.m_AmbientTargetColour.blue)
            {
               this.m_AmbientCurrentColour.blue++;
            }
            if(this.m_AmbientCurrentColour.blue > this.m_AmbientTargetColour.blue)
            {
               this.m_AmbientCurrentColour.blue--;
            }
            if(this.m_AmbientCurrentBrightness < this.m_AmbientTargetBrightness)
            {
               this.m_AmbientCurrentBrightness++;
            }
            if(this.m_AmbientCurrentBrightness > this.m_AmbientTargetBrightness)
            {
               this.m_AmbientCurrentBrightness--;
            }
            this.m_AmbientNextUpdate = _loc1_ + AMBIENT_UPDATE_INTERVAL;
         }
         this.m_ObjectNextUpdate = _loc1_ + OBJECT_UPDATE_INTERVAL;
      }
      
      public function isLookPossible(param1:int, param2:int, param3:int) : Boolean
      {
         return !this.m_Field[this.toIndexInternal(param1,param2,param3)].m_CacheUnsight;
      }
      
      public function get valid() : Boolean
      {
         return this.m_CacheValid;
      }
      
      public function resetOnscreenMessages(param1:Boolean = true) : void
      {
         var _loc2_:int = this.m_MessageBoxes.length - 1;
         while(_loc2_ >= ONSCREEN_TARGET_BOX_COORDINATE)
         {
            this.m_MessageBoxes[_loc2_].removeMessages();
            this.m_MessageBoxes[_loc2_] = null;
            _loc2_--;
         }
         var _loc3_:int = ONSCREEN_TARGET_BOX_COORDINATE - 1;
         while(param1 && _loc3_ >= 0)
         {
            this.m_MessageBoxes[_loc3_].removeMessages();
            _loc3_--;
         }
         this.m_MessageBoxes.length = ONSCREEN_TARGET_BOX_COORDINATE;
         this.m_LayoutOnscreenMessages = true;
      }
      
      public function set valid(param1:Boolean) : void
      {
         this.m_CacheValid = param1;
      }
   }
}
