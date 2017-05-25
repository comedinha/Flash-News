package tibia.creatures
{
   import flash.display.BitmapData;
   import flash.geom.Rectangle;
   import mx.collections.ArrayCollection;
   import mx.collections.IList;
   import mx.collections.Sort;
   import mx.core.BitmapAsset;
   import mx.events.PropertyChangeEvent;
   import shared.utility.Vector3D;
   import tibia.appearances.AppearanceInstance;
   import tibia.appearances.Marks;
   import tibia.appearances.ObjectInstance;
   import tibia.network.Communication;
   import tibia.options.OptionsStorage;
   
   public class CreatureStorage
   {
      
      protected static const BLESSING_SPARK_OF_PHOENIX:int = BLESSING_WISDOM_OF_SOLITUDE << 1;
      
      protected static const PARTY_LEADER_SEXP_ACTIVE:int = 6;
      
      protected static const PARTY_MAX_FLASHING_TIME:uint = 5000;
      
      protected static const RENDERER_DEFAULT_HEIGHT:Number = MAP_WIDTH * FIELD_SIZE;
      
      protected static const STATE_PZ_BLOCK:int = 13;
      
      protected static const PARTY_MEMBER_SEXP_ACTIVE:int = 5;
      
      protected static const PK_REVENGE:int = 6;
      
      public static const SORT_DISTANCE_ASC:int = 2;
      
      protected static const SKILL_FIGHTCLUB:int = 10;
      
      protected static const NPC_SPEECH_TRAVEL:uint = 5;
      
      protected static const RISKINESS_DANGEROUS:int = 1;
      
      protected static const NUM_PVP_HELPERS_FOR_RISKINESS_DANGEROUS:uint = 5;
      
      private static const MARK_NUM_TOTAL:uint = MARK_TRAPPER + 1;
      
      private static const OPPONENTS_REFRESH:int = 1;
      
      protected static const PK_PARTYMODE:int = 2;
      
      protected static const RISKINESS_NONE:int = 0;
      
      protected static const GUILD_NONE:int = 0;
      
      protected static const FIELD_HEIGHT:int = 24;
      
      public static const FILTER_PLAYER:int = 1;
      
      protected static const PARTY_MEMBER:int = 2;
      
      protected static const STATE_DRUNK:int = 3;
      
      protected static const PARTY_OTHER:int = 11;
      
      protected static const SKILL_EXPERIENCE:int = 0;
      
      protected static const ONSCREEN_MESSAGE_HEIGHT:int = 195;
      
      protected static const TYPE_NPC:int = 2;
      
      protected static const BLESSING_FIRE_OF_SUNS:int = BLESSING_SPARK_OF_PHOENIX << 1;
      
      protected static const SKILL_STAMINA:int = 17;
      
      private static const SPEECH_FLAG_CLASS:Class = CreatureStorage_SPEECH_FLAG_CLASS;
      
      protected static const STATE_NONE:int = -1;
      
      protected static const PARTY_MEMBER_SEXP_INACTIVE_GUILTY:int = 7;
      
      protected static const SKILL_FIGHTSHIELD:int = 8;
      
      protected static const SKILL_MANA_LEECH_CHANCE:int = 23;
      
      protected static const FIELD_SIZE:int = 32;
      
      protected static const SKILL_FIGHTDISTANCE:int = 9;
      
      protected static const PK_EXCPLAYERKILLER:int = 5;
      
      protected static const NUM_CREATURES:int = 1300;
      
      protected static const NUM_TRAPPERS:int = 8;
      
      protected static const SKILL_FED:int = 15;
      
      protected static const SKILL_MAGLEVEL:int = 2;
      
      protected static const SKILL_FISHING:int = 14;
      
      protected static const FIELD_ENTER_POSSIBLE_NO_ANIMATION:uint = 1;
      
      public static const SORT_NAME_DESC:int = 7;
      
      protected static const SKILL_HITPOINTS_PERCENT:int = 3;
      
      public static const SORT_NAME_ASC:int = 6;
      
      protected static const STATE_BLEEDING:int = 15;
      
      protected static const PK_PLAYERKILLER:int = 4;
      
      protected static const GROUND_LAYER:int = 7;
      
      protected static const PROFESSION_MASK_KNIGHT:int = 1 << PROFESSION_KNIGHT;
      
      protected static const STATE_DAZZLED:int = 10;
      
      protected static const SUMMON_OTHERS:int = 2;
      
      protected static const SKILL_NONE:int = -1;
      
      protected static const NPC_SPEECH_TRADER:uint = 2;
      
      protected static const GUILD_MEMBER:int = 4;
      
      protected static const PROFESSION_NONE:int = 0;
      
      protected static const BLESSING_BLOOD_OF_THE_MOUNTAIN:int = BLESSING_HEART_OF_THE_MOUNTAIN << 1;
      
      protected static const MAX_NAME_LENGTH:int = 29;
      
      protected static const PARTY_LEADER:int = 1;
      
      private static const STATE_FLAG_BITMAP:BitmapData = (new STATE_FLAG_CLASS() as BitmapAsset).bitmapData;
      
      public static const STATE_FLAG_SIZE:int = 11;
      
      protected static const SKILL_CARRYSTRENGTH:int = 7;
      
      protected static const STATE_PZ_ENTERED:int = 14;
      
      public static const MARK_AIM:uint = MARK_NUM_COLOURS + 1;
      
      protected static const PK_ATTACKER:int = 1;
      
      protected static const STATE_ELECTRIFIED:int = 2;
      
      protected static const SKILL_FIGHTSWORD:int = 11;
      
      private static const OPPONENTS_NOACTION:int = 0;
      
      public static const FILTER_NON_SKULLED:int = 8;
      
      protected static const GUILD_WAR_NEUTRAL:int = 3;
      
      protected static const STATE_DROWNING:int = 8;
      
      protected static const MAP_MIN_Y:int = 24576;
      
      protected static const MAP_MIN_Z:int = 0;
      
      public static const MARK_AIM_FOLLOW:uint = MARK_NUM_COLOURS + 3;
      
      protected static const MAP_MIN_X:int = 24576;
      
      protected static const BLESSING_HEART_OF_THE_MOUNTAIN:int = BLESSING_EMBRACE_OF_TIBIA << 1;
      
      protected static const SKILL_LIFE_LEECH_AMOUNT:int = 22;
      
      protected static const RENDERER_MIN_WIDTH:Number = Math.round(MAP_WIDTH * 2 / 3 * FIELD_SIZE);
      
      protected static const RENDERER_MIN_HEIGHT:Number = Math.round(MAP_HEIGHT * 2 / 3 * FIELD_SIZE);
      
      protected static const MAP_WIDTH:int = 15;
      
      protected static const PARTY_MEMBER_SEXP_OFF:int = 3;
      
      protected static const PROFESSION_MASK_DRUID:int = 1 << PROFESSION_DRUID;
      
      public static const SORT_KNOWN_SINCE_ASC:int = 0;
      
      protected static const PARTY_MEMBER_SEXP_INACTIVE_INNOCENT:int = 9;
      
      protected static const GUILD_WAR_ALLY:int = 1;
      
      protected static const PK_NONE:int = 0;
      
      protected static const NUM_EFFECTS:int = 200;
      
      protected static const PROFESSION_SORCERER:int = 3;
      
      protected static const STATE_SLOW:int = 5;
      
      protected static const PARTY_NONE:int = 0;
      
      protected static const SKILL_CRITICAL_HIT_CHANCE:int = 19;
      
      protected static const SUMMON_OWN:int = 1;
      
      protected static const FIELD_ENTER_POSSIBLE:uint = 0;
      
      protected static const ONSCREEN_MESSAGE_WIDTH:int = 295;
      
      protected static const SKILL_EXPERIENCE_GAIN:int = -2;
      
      protected static const PROFESSION_MASK_NONE:int = 1 << PROFESSION_NONE;
      
      protected static const FIELD_ENTER_NOT_POSSIBLE:uint = 2;
      
      protected static const PROFESSION_MASK_SORCERER:int = 1 << PROFESSION_SORCERER;
      
      protected static const PROFESSION_KNIGHT:int = 1;
      
      protected static const NPC_SPEECH_QUESTTRADER:uint = 4;
      
      protected static const PARTY_LEADER_SEXP_INACTIVE_GUILTY:int = 8;
      
      public static const MARK_UNMARKED:uint = 0;
      
      protected static const UNDERGROUND_LAYER:int = 2;
      
      protected static const BLESSING_WISDOM_OF_SOLITUDE:int = BLESSING_TWIST_OF_FATE << 1;
      
      public static const FILTER_PARTY:int = 16;
      
      protected static const FIELD_CACHESIZE:int = FIELD_SIZE;
      
      protected static const PROFESSION_PALADIN:int = 2;
      
      protected static const PLAYER_OFFSET_X:int = 8;
      
      protected static const SKILL_FIGHTAXE:int = 12;
      
      protected static const SKILL_CRITICAL_HIT_DAMAGE:int = 20;
      
      protected static const PLAYER_OFFSET_Y:int = 6;
      
      public static const MARK_TRAPPER:uint = MARK_NUM_COLOURS + 6;
      
      protected static const PARTY_LEADER_SEXP_OFF:int = 4;
      
      private static const OPPONENTS_REBUILD:int = 2;
      
      protected static const MAP_MAX_X:int = MAP_MIN_X + (1 << 14 - 1);
      
      protected static const MAP_MAX_Y:int = MAP_MIN_Y + (1 << 14 - 1);
      
      private static const STATE_FLAG_CLASS:Class = CreatureStorage_STATE_FLAG_CLASS;
      
      protected static const MAP_MAX_Z:int = 15;
      
      protected static const SKILL_SOULPOINTS:int = 16;
      
      protected static const NUM_ONSCREEN_MESSAGES:int = 16;
      
      protected static const BLESSING_EMBRACE_OF_TIBIA:int = BLESSING_SPIRITUAL_SHIELDING << 1;
      
      protected static const STATE_FAST:int = 6;
      
      protected static const BLESSING_TWIST_OF_FATE:int = BLESSING_ADVENTURER << 1;
      
      public static const MARK_AIM_ATTACK:uint = MARK_NUM_COLOURS + 2;
      
      protected static const SKILL_MANA_LEECH_AMOUNT:int = 24;
      
      public static const STATE_FLAG_GAP:int = 2;
      
      public static const MARK_FOLLOW:uint = MARK_NUM_COLOURS + 5;
      
      protected static const BLESSING_NONE:int = 0;
      
      public static const FILTER_NPC:int = 2;
      
      protected static const GUILD_OTHER:int = 5;
      
      private static const SPEECH_FLAG_BITMAP:BitmapData = (new SPEECH_FLAG_CLASS() as BitmapAsset).bitmapData;
      
      protected static const TYPE_PLAYER:int = 0;
      
      protected static const SKILL_HITPOINTS:int = 4;
      
      protected static const SKILL_OFFLINETRAINING:int = 18;
      
      protected static const STATE_MANA_SHIELD:int = 4;
      
      protected static const SKILL_MANA:int = 5;
      
      protected static const MAP_HEIGHT:int = 11;
      
      protected static const PROFESSION_MASK_PALADIN:int = 1 << PROFESSION_PALADIN;
      
      protected static const RENDERER_DEFAULT_WIDTH:Number = MAP_WIDTH * FIELD_SIZE;
      
      public static const FILTER_NONE:int = 0;
      
      protected static const STATE_CURSED:int = 11;
      
      protected static const BLESSING_ADVENTURER:int = 1;
      
      protected static const STATE_FREEZING:int = 9;
      
      protected static const PARTY_LEADER_SEXP_INACTIVE_INNOCENT:int = 10;
      
      protected static const NUM_FIELDS:int = MAPSIZE_Z * MAPSIZE_Y * MAPSIZE_X;
      
      protected static const STATE_POISONED:int = 0;
      
      protected static const SKILL_LIFE_LEECH_CHANCE:int = 21;
      
      protected static const TYPE_MONSTER:int = 1;
      
      public static const SORT_DISTANCE_DESC:int = 3;
      
      public static const SORT_KNOWN_SINCE_DESC:int = 1;
      
      private static const MARK_NUM_COLOURS:uint = 216;
      
      protected static const STATE_BURNING:int = 1;
      
      protected static const SKILL_FIGHTFIST:int = 13;
      
      public static const SORT_HITPOINTS_ASC:int = 4;
      
      protected static const PK_AGGRESSOR:int = 3;
      
      protected static const GUILD_WAR_ENEMY:int = 2;
      
      protected static const SKILL_LEVEL:int = 1;
      
      protected static const STATE_STRENGTHENED:int = 12;
      
      protected static const MAPSIZE_Z:int = 8;
      
      protected static const STATE_HUNGRY:int = 31;
      
      protected static const PROFESSION_MASK_ANY:int = PROFESSION_MASK_DRUID | PROFESSION_MASK_KNIGHT | PROFESSION_MASK_PALADIN | PROFESSION_MASK_SORCERER;
      
      protected static const SUMMON_NONE:int = 0;
      
      protected static const MAPSIZE_Y:int = MAP_HEIGHT + 3;
      
      protected static const PROFESSION_DRUID:int = 4;
      
      protected static const STATE_FIGHTING:int = 7;
      
      protected static const NPC_SPEECH_QUEST:uint = 3;
      
      protected static const MAPSIZE_X:int = MAP_WIDTH + 3;
      
      protected static const NPC_SPEECH_NORMAL:uint = 1;
      
      protected static const TYPE_PLAYERSUMMON:int = 3;
      
      public static const SORT_HITPOINTS_DESC:int = 5;
      
      protected static const MAPSIZE_W:int = 10;
      
      public static const SPEECH_FLAG_SIZE:int = 18;
      
      protected static const BLESSING_SPIRITUAL_SHIELDING:int = BLESSING_FIRE_OF_SUNS << 1;
      
      public static const FILTER_MONSTER:int = 4;
      
      protected static const NPC_SPEECH_NONE:uint = 0;
      
      public static const MARK_ATTACK:uint = MARK_NUM_COLOURS + 4;
      
      protected static const PK_MAX_FLASHING_TIME:uint = 5000;
      
      protected static const SKILL_GOSTRENGTH:int = 6;
       
      
      protected var m_OpponentsSort:Sort = null;
      
      protected var m_Player:Player = null;
      
      protected var m_CreatureCount:int = 0;
      
      protected var m_AttackTarget:Creature = null;
      
      protected var m_Options:OptionsStorage = null;
      
      protected var m_OpponentsState:int = 0;
      
      protected var m_Opponents:ArrayCollection = null;
      
      protected var m_Aim:Creature = null;
      
      protected var m_FollowTarget:Creature = null;
      
      protected var m_Trappers:Vector.<Creature> = null;
      
      protected var m_CreatureIndex:int = 0;
      
      protected var m_MaxCreaturesCount:uint = 1300;
      
      protected var m_Creature:Vector.<Creature> = null;
      
      public function CreatureStorage()
      {
         super();
         this.m_Player = new Player();
         this.m_Creature = new Vector.<Creature>();
         this.m_OpponentsSort = new Sort();
         this.m_OpponentsSort.compareFunction = this.opponentComparator;
         this.m_Opponents = new ArrayCollection();
         this.m_Opponents.filterFunction = this.opponentFilter;
         this.m_Opponents.sort = this.m_OpponentsSort;
         this.options = Tibia.s_GetOptions();
         this.m_Trappers = null;
      }
      
      public static function s_GetPKFlag(param1:int, param2:Rectangle) : BitmapData
      {
         if(param1 < PK_NONE || param1 > PK_REVENGE)
         {
            throw new ArgumentError("CreatureStorage.s_GetPKFlag: Invalid flag.");
         }
         param2.x = param1 * STATE_FLAG_SIZE;
         param2.y = STATE_FLAG_SIZE;
         param2.width = STATE_FLAG_SIZE;
         param2.height = STATE_FLAG_SIZE;
         return STATE_FLAG_BITMAP;
      }
      
      public static function s_GetRiskinessFlag(param1:int, param2:Rectangle) : BitmapData
      {
         if(param1 < RISKINESS_NONE || param1 > RISKINESS_DANGEROUS)
         {
            throw new ArgumentError("CreatureStorage.s_GetRiskinessFlag: Invalid flag.");
         }
         param2.x = param1 * STATE_FLAG_SIZE;
         param2.y = 4 * STATE_FLAG_SIZE;
         param2.width = STATE_FLAG_SIZE;
         param2.height = STATE_FLAG_SIZE;
         return STATE_FLAG_BITMAP;
      }
      
      public static function s_GetSummonFlag(param1:int, param2:Rectangle) : BitmapData
      {
         if(param1 < SUMMON_NONE || param1 > SUMMON_OTHERS)
         {
            throw new ArgumentError("CreatureStorage.s_GetSummonFlag: Invalid flag.");
         }
         param2.x = param1 * STATE_FLAG_SIZE;
         param2.y = 3 * STATE_FLAG_SIZE;
         param2.width = STATE_FLAG_SIZE;
         param2.height = STATE_FLAG_SIZE;
         return STATE_FLAG_BITMAP;
      }
      
      public static function s_GetPartyFlag(param1:int, param2:Rectangle) : BitmapData
      {
         if(param1 < PARTY_NONE || param1 > PARTY_OTHER)
         {
            throw new ArgumentError("CreatureStorage.s_GetPartyFlag: Invalid flag.");
         }
         if(param1 == PARTY_LEADER_SEXP_INACTIVE_INNOCENT)
         {
            param1 = PARTY_LEADER_SEXP_INACTIVE_GUILTY;
         }
         if(param1 == PARTY_MEMBER_SEXP_INACTIVE_INNOCENT)
         {
            param1 = PARTY_LEADER_SEXP_INACTIVE_GUILTY;
         }
         if(param1 == PARTY_OTHER)
         {
            param1 = 9;
         }
         param2.x = param1 * STATE_FLAG_SIZE;
         param2.y = 0;
         param2.width = STATE_FLAG_SIZE;
         param2.height = STATE_FLAG_SIZE;
         return STATE_FLAG_BITMAP;
      }
      
      public static function s_GetGuildFlag(param1:int, param2:Rectangle) : BitmapData
      {
         if(param1 < GUILD_NONE || param1 > GUILD_OTHER)
         {
            throw new ArgumentError("CreatureStorage.s_GetGuildFlag: Invalid flag.");
         }
         param2.x = param1 * STATE_FLAG_SIZE;
         param2.y = 2 * STATE_FLAG_SIZE;
         param2.width = STATE_FLAG_SIZE;
         param2.height = STATE_FLAG_SIZE;
         return STATE_FLAG_BITMAP;
      }
      
      public static function s_GetNpcSpeechFlag(param1:uint, param2:Rectangle) : BitmapData
      {
         var _loc3_:uint = 0;
         if(param1 < NPC_SPEECH_NONE || param1 > NPC_SPEECH_TRAVEL)
         {
            throw new ArgumentError("CreatureStorage.s_GetNpcSpeechFlag: Invalid flag.");
         }
         switch(param1)
         {
            case NPC_SPEECH_NORMAL:
               _loc3_ = 1;
               break;
            case NPC_SPEECH_TRADER:
               _loc3_ = 2;
               break;
            case NPC_SPEECH_QUEST:
               _loc3_ = 3;
               break;
            case NPC_SPEECH_TRAVEL:
               _loc3_ = 4;
               break;
            default:
               _loc3_ = 0;
         }
         param2.x = _loc3_ * SPEECH_FLAG_SIZE;
         param2.y = 0;
         param2.width = SPEECH_FLAG_SIZE;
         param2.height = SPEECH_FLAG_SIZE;
         return SPEECH_FLAG_BITMAP;
      }
      
      public function setAim(param1:Creature) : void
      {
         var _loc2_:Creature = null;
         if(this.m_Aim != param1)
         {
            _loc2_ = this.m_Aim;
            this.m_Aim = param1;
            this.updateExtendedMark(_loc2_);
            this.updateExtendedMark(this.m_Aim);
         }
      }
      
      public function getNextAttackTarget(param1:int) : Creature
      {
         param1 = param1 < 0?-1:1;
         var _loc2_:int = this.m_Opponents.length;
         var _loc3_:int = -1;
         var _loc4_:int = 0;
         if(_loc2_ < 1)
         {
            return null;
         }
         if(this.m_AttackTarget != null)
         {
            _loc3_ = this.m_Opponents.getItemIndex(this.m_AttackTarget);
         }
         var _loc5_:Creature = null;
         while(_loc4_++ < _loc2_)
         {
            _loc3_ = _loc3_ + param1;
            if(_loc3_ >= _loc2_)
            {
               _loc3_ = 0;
            }
            if(_loc3_ < 0)
            {
               _loc3_ = _loc2_ - 1;
            }
            _loc5_ = Creature(this.m_Opponents.getItemAt(_loc3_));
            if(_loc5_.type != TYPE_NPC)
            {
               return _loc5_;
            }
         }
         return null;
      }
      
      public function getAim() : Creature
      {
         return this.m_Aim;
      }
      
      public function markAllOpponentsVisible(param1:Boolean) : void
      {
         var _loc2_:int = this.m_Opponents.length;
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            Creature(this.m_Opponents.getItemAt(_loc3_)).visible = param1;
            _loc3_++;
         }
         if(_loc2_ > 0)
         {
            this.invalidateOpponents();
         }
      }
      
      public function replaceCreature(param1:Creature, param2:int = 0) : Creature
      {
         if(param1 == null)
         {
            throw new ArgumentError("CreatureStorage.appendCreature: Invalid creature.");
         }
         if(param2 != 0)
         {
            this.removeCreature(param2);
         }
         if(this.m_CreatureCount >= this.m_MaxCreaturesCount)
         {
            throw new Error("CreatureStorage.appendCreature: No space left to append " + param1.ID);
         }
         var _loc3_:int = 0;
         var _loc4_:* = -1;
         var _loc5_:int = 0;
         var _loc6_:int = this.m_CreatureCount - 1;
         var _loc7_:Creature = null;
         while(_loc5_ <= _loc6_)
         {
            _loc4_ = _loc5_ + _loc6_ >> 1;
            _loc7_ = this.m_Creature[_loc4_];
            if(_loc7_.ID == param1.ID)
            {
               return param1;
            }
            if(_loc7_.ID < param1.ID)
            {
               _loc5_ = _loc4_ + 1;
            }
            else
            {
               _loc6_ = _loc4_ - 1;
            }
         }
         param1.knownSince = ++this.m_CreatureIndex;
         this.m_Creature.splice(_loc5_,0,param1);
         this.m_CreatureCount++;
         this.m_OpponentsState = OPPONENTS_REBUILD;
         return param1;
      }
      
      public function toggleFollowTarget(param1:Creature, param2:Boolean) : void
      {
         if(param1 == this.m_Player)
         {
            throw new ArgumentError("CreatureStorage.toggleFollowTarget: Cannot follow player.");
         }
         var _loc3_:Creature = this.m_FollowTarget;
         if(_loc3_ != param1)
         {
            this.m_FollowTarget = param1;
         }
         else
         {
            this.m_FollowTarget = null;
         }
         var _loc4_:Communication = null;
         if(param2 && (_loc4_ = Tibia.s_GetCommunication()) != null && _loc4_.isGameRunning)
         {
            if(this.m_FollowTarget != null)
            {
               _loc4_.sendCFOLLOW(this.m_FollowTarget.ID);
            }
            else
            {
               _loc4_.sendCFOLLOW(0);
            }
         }
         this.updateExtendedMark(_loc3_);
         this.updateExtendedMark(this.m_FollowTarget);
         var _loc5_:Creature = this.m_AttackTarget;
         if(_loc5_ != null)
         {
            this.m_AttackTarget = null;
            this.updateExtendedMark(_loc5_);
         }
      }
      
      public function getCreatureByName(param1:String) : Creature
      {
         var _loc2_:Creature = null;
         for each(_loc2_ in this.m_Creature)
         {
            if(_loc2_.name == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public function getFollowTarget() : Creature
      {
         return this.m_FollowTarget;
      }
      
      public function getTrappers() : Vector.<Creature>
      {
         return this.m_Trappers;
      }
      
      public function refreshOpponents() : void
      {
         var _loc1_:int = 0;
         switch(this.m_OpponentsState)
         {
            case OPPONENTS_NOACTION:
               break;
            case OPPONENTS_REFRESH:
               this.m_Opponents.refresh();
               break;
            case OPPONENTS_REBUILD:
               this.m_Opponents.disableAutoUpdate();
               this.m_Opponents.filterFunction = null;
               this.m_Opponents.sort = null;
               this.m_Opponents.refresh();
               this.m_Opponents.removeAll();
               _loc1_ = 0;
               while(_loc1_ < this.m_CreatureCount)
               {
                  this.m_Opponents.addItem(this.m_Creature[_loc1_]);
                  _loc1_++;
               }
               this.m_Opponents.filterFunction = this.opponentFilter;
               this.m_Opponents.sort = this.m_OpponentsSort;
               this.m_Opponents.refresh();
               this.m_Opponents.enableAutoUpdate();
         }
         this.m_OpponentsState = OPPONENTS_NOACTION;
      }
      
      protected function opponentComparator(param1:Object, param2:Object, param3:Array = null) : int
      {
         var _loc4_:Creature = null;
         var _loc5_:Creature = null;
         var _loc8_:Vector3D = null;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         _loc4_ = param1 as Creature;
         _loc5_ = param2 as Creature;
         var _loc6_:int = 0;
         var _loc7_:Boolean = true;
         if(_loc4_ != null && _loc5_ != null && this.m_Options != null)
         {
            switch(this.m_Options.opponentSort)
            {
               case SORT_DISTANCE_DESC:
                  _loc7_ = false;
               case SORT_DISTANCE_ASC:
                  _loc8_ = this.m_Player.position;
                  _loc9_ = Math.max(Math.abs(_loc8_.x - _loc4_.position.x),Math.abs(_loc8_.y - _loc4_.position.y));
                  _loc10_ = Math.max(Math.abs(_loc8_.x - _loc5_.position.x),Math.abs(_loc8_.y - _loc5_.position.y));
                  if(_loc9_ < _loc10_)
                  {
                     _loc6_ = -1;
                  }
                  else if(_loc9_ > _loc10_)
                  {
                     _loc6_ = 1;
                  }
                  break;
               case SORT_HITPOINTS_DESC:
                  _loc7_ = false;
               case SORT_HITPOINTS_ASC:
                  if(_loc4_.hitpointsPercent < _loc5_.hitpointsPercent)
                  {
                     _loc6_ = -1;
                  }
                  else if(_loc4_.hitpointsPercent > _loc5_.hitpointsPercent)
                  {
                     _loc6_ = 1;
                  }
                  break;
               case SORT_NAME_DESC:
                  _loc7_ = false;
               case SORT_NAME_ASC:
                  if(_loc4_.name < _loc5_.name)
                  {
                     _loc6_ = -1;
                  }
                  else if(_loc4_.name > _loc5_.name)
                  {
                     _loc6_ = 1;
                  }
                  break;
               case SORT_KNOWN_SINCE_DESC:
                  _loc7_ = false;
               case SORT_KNOWN_SINCE_ASC:
            }
            if(_loc6_ == 0)
            {
               if(_loc4_.knownSince < _loc5_.knownSince)
               {
                  _loc6_ = -1;
               }
               else if(_loc4_.knownSince > _loc5_.knownSince)
               {
                  _loc6_ = 1;
               }
            }
         }
         if(_loc7_)
         {
            return _loc6_;
         }
         return -_loc6_;
      }
      
      public function setFollowTarget(param1:Creature, param2:Boolean) : void
      {
         var _loc5_:Communication = null;
         if(param1 == this.m_Player)
         {
            throw new ArgumentError("CreatureStorage.setFollowTarget: Cannot follow player.");
         }
         var _loc3_:Creature = this.m_FollowTarget;
         if(_loc3_ != param1)
         {
            this.m_FollowTarget = param1;
            _loc5_ = null;
            if(param2 && (_loc5_ = Tibia.s_GetCommunication()) != null && _loc5_.isGameRunning)
            {
               if(this.m_FollowTarget != null)
               {
                  _loc5_.sendCFOLLOW(this.m_FollowTarget.ID);
               }
               else
               {
                  _loc5_.sendCFOLLOW(0);
               }
            }
            this.updateExtendedMark(_loc3_);
            this.updateExtendedMark(this.m_FollowTarget);
         }
         var _loc4_:Creature = this.m_AttackTarget;
         if(_loc4_ != null)
         {
            this.m_AttackTarget = null;
            this.updateExtendedMark(_loc4_);
         }
      }
      
      public function get options() : OptionsStorage
      {
         return this.m_Options;
      }
      
      public function isOpponent(param1:Creature) : Boolean
      {
         return this.opponentFilter(param1,false);
      }
      
      protected function updateExtendedMark(param1:Creature) : void
      {
         var _loc2_:Marks = null;
         var _loc3_:uint = 0;
         if(param1 != null)
         {
            _loc2_ = param1.marks;
            _loc2_.setMark(Marks.MARK_TYPE_CLIENT_MAPWINDOW,Marks.MARK_UNMARKED);
            _loc2_.setMark(Marks.MARK_TYPE_CLIENT_BATTLELIST,Marks.MARK_UNMARKED);
            _loc3_ = Marks.MARK_UNMARKED;
            if(param1 == this.m_Aim && param1 == this.m_AttackTarget)
            {
               _loc2_.setMark(Marks.MARK_TYPE_CLIENT_MAPWINDOW,Marks.MARK_AIM_ATTACK);
               _loc2_.setMark(Marks.MARK_TYPE_CLIENT_BATTLELIST,Marks.MARK_AIM_ATTACK);
            }
            else if(param1 == this.m_Aim && param1 == this.m_FollowTarget)
            {
               _loc2_.setMark(Marks.MARK_TYPE_CLIENT_MAPWINDOW,Marks.MARK_AIM_FOLLOW);
               _loc2_.setMark(Marks.MARK_TYPE_CLIENT_BATTLELIST,Marks.MARK_AIM_FOLLOW);
            }
            else if(param1 == this.m_Aim)
            {
               _loc2_.setMark(Marks.MARK_TYPE_CLIENT_BATTLELIST,Marks.MARK_AIM);
            }
            else if(param1 == this.m_AttackTarget)
            {
               _loc2_.setMark(Marks.MARK_TYPE_CLIENT_MAPWINDOW,Marks.MARK_ATTACK);
               _loc2_.setMark(Marks.MARK_TYPE_CLIENT_BATTLELIST,Marks.MARK_ATTACK);
            }
            else if(param1 == this.m_FollowTarget)
            {
               _loc2_.setMark(Marks.MARK_TYPE_CLIENT_MAPWINDOW,Marks.MARK_FOLLOW);
               _loc2_.setMark(Marks.MARK_TYPE_CLIENT_BATTLELIST,Marks.MARK_FOLLOW);
            }
         }
      }
      
      public function setTrappers(param1:Vector.<Creature>) : void
      {
         var _loc2_:int = 0;
         _loc2_ = this.m_Trappers != null?this.m_Trappers.length:0 - 1;
         while(_loc2_ >= 0)
         {
            if(this.m_Trappers[_loc2_] != null)
            {
               this.m_Trappers[_loc2_].isTrapper = false;
            }
            _loc2_--;
         }
         this.m_Trappers = param1;
         _loc2_ = this.m_Trappers != null?this.m_Trappers.length:0 - 1;
         while(_loc2_ >= 0)
         {
            if(this.m_Trappers[_loc2_] != null)
            {
               this.m_Trappers[_loc2_].isTrapper = true;
            }
            _loc2_--;
         }
      }
      
      public function getCreature(param1:int) : Creature
      {
         var _loc2_:* = 0;
         var _loc3_:int = 0;
         var _loc4_:int = this.m_CreatureCount - 1;
         var _loc5_:Creature = null;
         while(_loc3_ <= _loc4_)
         {
            _loc2_ = _loc3_ + _loc4_ >> 1;
            _loc5_ = this.m_Creature[_loc2_];
            if(_loc5_.ID == param1)
            {
               return _loc5_;
            }
            if(_loc5_.ID < param1)
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
      
      public function get opponents() : IList
      {
         return this.m_Opponents;
      }
      
      public function invalidateOpponents() : void
      {
         if(this.m_OpponentsState < OPPONENTS_REFRESH)
         {
            this.m_OpponentsState = OPPONENTS_REFRESH;
         }
      }
      
      public function set options(param1:OptionsStorage) : void
      {
         if(this.m_Options != param1)
         {
            if(this.m_Options != null)
            {
               this.m_Options.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onOptionsChange);
            }
            this.m_Options = param1;
            if(this.m_Options != null)
            {
               this.m_Options.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onOptionsChange);
            }
            this.invalidateOpponents();
            this.refreshOpponents();
         }
      }
      
      public function markOpponentVisible(param1:*, param2:Boolean) : void
      {
         var _loc3_:Creature = null;
         if(param1 is Creature)
         {
            _loc3_ = Creature(param1);
         }
         else if(param1 is ObjectInstance && ObjectInstance(param1).ID == AppearanceInstance.CREATURE)
         {
            _loc3_ = this.getCreature(ObjectInstance(param1).ID);
         }
         else if(param1 is int)
         {
            _loc3_ = this.getCreature(int(param1));
         }
         else
         {
            throw new ArgumentError("CreatureStorage.hideOpponent: Invalid overload.");
         }
         if(_loc3_ != null)
         {
            _loc3_.visible = param2;
            this.invalidateOpponents();
         }
      }
      
      protected function opponentFilter(param1:Object, param2:Boolean = true) : Boolean
      {
         var _loc3_:Creature = param1 as Creature;
         if(_loc3_ == null || _loc3_ is Player)
         {
            return false;
         }
         if(!_loc3_.visible || _loc3_.hitpointsPercent <= 0)
         {
            return false;
         }
         var _loc4_:Vector3D = _loc3_.position;
         var _loc5_:Vector3D = this.m_Player.position;
         if(_loc4_.z != _loc5_.z || Math.abs(_loc4_.x - _loc5_.x) > MAP_WIDTH / 2 || Math.abs(_loc4_.y - _loc5_.y) > MAP_HEIGHT / 2)
         {
            return false;
         }
         var _loc6_:int = FILTER_NONE;
         if(param2 && this.m_Options != null && (_loc6_ = this.m_Options.opponentFilter) != FILTER_NONE)
         {
            if((_loc6_ & FILTER_PLAYER) > 0 && _loc3_.type == TYPE_PLAYER)
            {
               return false;
            }
            if((_loc6_ & FILTER_NPC) > 0 && _loc3_.type == TYPE_NPC)
            {
               return false;
            }
            if((_loc6_ & FILTER_MONSTER) > 0 && _loc3_.type == TYPE_MONSTER)
            {
               return false;
            }
            if((_loc6_ & FILTER_NON_SKULLED) > 0 && _loc3_.type == TYPE_PLAYER && _loc3_.pkFlag == PK_NONE)
            {
               return false;
            }
            if((_loc6_ & FILTER_PARTY) > 0 && _loc3_.partyFlag != PARTY_NONE)
            {
               return false;
            }
         }
         return true;
      }
      
      public function reset(param1:Boolean = true) : void
      {
         if(param1)
         {
            this.m_Player.reset();
         }
         var _loc2_:int = this.m_Creature.length - 1;
         while(_loc2_ >= 0)
         {
            if(this.m_Creature[_loc2_] != null)
            {
               if(this.m_Creature[_loc2_] != this.m_Player || this.m_Creature[_loc2_] == this.m_Player && param1 == true)
               {
                  this.m_Creature[_loc2_].reset();
                  this.m_Creature[_loc2_] = null;
               }
            }
            _loc2_--;
         }
         this.m_Creature.length = 0;
         this.m_CreatureCount = 0;
         this.m_CreatureIndex = 0;
         if(param1 == false)
         {
            this.replaceCreature(this.m_Player,0);
         }
         this.m_Opponents.removeAll();
         this.m_OpponentsState = OPPONENTS_NOACTION;
         this.m_Aim = null;
         this.m_AttackTarget = null;
         this.m_FollowTarget = null;
         this.m_Trappers = null;
      }
      
      protected function onOptionsChange(param1:PropertyChangeEvent) : void
      {
         switch(param1.property)
         {
            case "opponentSort":
            case "opponentFilter":
            case "*":
               this.invalidateOpponents();
               this.refreshOpponents();
         }
      }
      
      public function removeCreature(param1:int) : void
      {
         var _loc2_:int = -1;
         var _loc3_:* = 0;
         var _loc4_:int = 0;
         var _loc5_:int = this.m_CreatureCount - 1;
         var _loc6_:Creature = null;
         while(_loc4_ <= _loc5_)
         {
            _loc3_ = _loc4_ + _loc5_ >> 1;
            _loc6_ = this.m_Creature[_loc3_];
            if(_loc6_.ID == param1)
            {
               _loc2_ = _loc3_;
               break;
            }
            if(_loc6_.ID < param1)
            {
               _loc4_ = _loc3_ + 1;
            }
            else
            {
               _loc5_ = _loc3_ - 1;
            }
         }
         if(_loc6_ == null || _loc2_ < 0)
         {
            throw new Error("CreatureStorage.removeCreature: Creature " + param1 + " not found.");
         }
         if(_loc6_ == this.m_Player)
         {
            throw new Error("CreatureStorage.removeCreature: Can\'t remove the player.");
         }
         if(_loc6_ == this.m_Aim)
         {
            this.m_Aim = null;
            this.updateExtendedMark(_loc6_);
         }
         if(_loc6_ == this.m_AttackTarget)
         {
            this.m_AttackTarget = null;
            this.updateExtendedMark(_loc6_);
         }
         if(_loc6_ == this.m_FollowTarget)
         {
            this.m_FollowTarget = null;
            this.updateExtendedMark(_loc6_);
         }
         _loc3_ = int(this.m_Trappers != null?this.m_Trappers.length:0 - 1);
         while(_loc3_ >= 0)
         {
            if(_loc6_ == this.m_Trappers[_loc3_])
            {
               this.m_Trappers[_loc3_].isTrapper = false;
               this.m_Trappers[_loc3_] = null;
            }
            _loc3_--;
         }
         _loc6_.reset();
         this.m_Creature.splice(_loc2_,1);
         this.m_CreatureCount--;
         this.m_OpponentsState = OPPONENTS_REBUILD;
      }
      
      public function get player() : Player
      {
         return this.m_Player;
      }
      
      public function getAttackTarget() : Creature
      {
         return this.m_AttackTarget;
      }
      
      public function animate() : void
      {
         var _loc1_:Number = Tibia.s_FrameTibiaTimestamp;
         var _loc2_:int = 0;
         while(_loc2_ < this.m_CreatureCount)
         {
            if(this.m_Creature[_loc2_] != null)
            {
               this.m_Creature[_loc2_].animateMovement(_loc1_);
               this.m_Creature[_loc2_].animateOutfit(_loc1_);
            }
            _loc2_++;
         }
      }
      
      public function toggleAttackTarget(param1:Creature, param2:Boolean) : void
      {
         if(param1 == this.m_Player)
         {
            throw new ArgumentError("CreatureStorage.toggleAttackTarget: Cannot attack player.");
         }
         var _loc3_:Creature = this.m_AttackTarget;
         if(_loc3_ != param1)
         {
            this.m_AttackTarget = param1;
         }
         else
         {
            this.m_AttackTarget = null;
         }
         var _loc4_:Communication = null;
         if(param2 && (_loc4_ = Tibia.s_GetCommunication()) != null && _loc4_.isGameRunning)
         {
            if(this.m_AttackTarget != null)
            {
               _loc4_.sendCATTACK(this.m_AttackTarget.ID);
            }
            else
            {
               _loc4_.sendCATTACK(0);
            }
         }
         this.updateExtendedMark(_loc3_);
         this.updateExtendedMark(this.m_AttackTarget);
         var _loc5_:Creature = this.m_FollowTarget;
         if(this.m_AttackTarget != null && _loc5_ != null)
         {
            this.m_FollowTarget = null;
            this.updateExtendedMark(_loc5_);
         }
      }
      
      public function clearTargets() : void
      {
         var _loc1_:Communication = null;
         if(this.m_AttackTarget != null && this.m_Options != null && this.m_Options.combatAutoChaseOff && this.m_Options.combatChaseMode != OptionsStorage.COMBAT_CHASE_OFF)
         {
            this.m_Options.combatChaseMode = OptionsStorage.COMBAT_CHASE_OFF;
            _loc1_ = Tibia.s_GetCommunication();
            if(_loc1_ != null && _loc1_.isGameRunning)
            {
               _loc1_.sendCSETTACTICS(this.m_Options.combatAttackMode,this.m_Options.combatChaseMode,this.m_Options.combatSecureMode,this.m_Options.combatPVPMode);
            }
         }
         if(this.m_FollowTarget != null)
         {
            this.setFollowTarget(null,true);
         }
      }
      
      public function setAttackTarget(param1:Creature, param2:Boolean) : void
      {
         var _loc5_:Communication = null;
         if(param1 == this.m_Player)
         {
            throw new ArgumentError("CreatureStorage.setAttackTarget: Cannot attack player.");
         }
         var _loc3_:Creature = this.m_AttackTarget;
         if(_loc3_ != param1)
         {
            this.m_AttackTarget = param1;
            _loc5_ = null;
            if(param2 && (_loc5_ = Tibia.s_GetCommunication()) != null && _loc5_.isGameRunning)
            {
               if(this.m_AttackTarget != null)
               {
                  _loc5_.sendCATTACK(this.m_AttackTarget.ID);
               }
               else
               {
                  _loc5_.sendCATTACK(0);
               }
            }
            this.updateExtendedMark(_loc3_);
            this.updateExtendedMark(this.m_AttackTarget);
         }
         var _loc4_:Creature = this.m_FollowTarget;
         if(_loc4_ != null)
         {
            this.m_FollowTarget = null;
            this.updateExtendedMark(_loc4_);
         }
      }
   }
}
