package tibia.creatures
{
   import shared.utility.Vector3D;
   import tibia.§creatures:ns_creature_internal§.m_Position;
   import tibia.network.Communication;
   import tibia.worldmap.WorldMapStorage;
   import tibia.chat.MessageMode;
   import mx.events.PropertyChangeEvent;
   import mx.events.PropertyChangeEventKind;
   import tibia.magic.Rune;
   import tibia.magic.Spell;
   import tibia.minimap.MiniMapStorage;
   import tibia.appearances.ObjectInstance;
   
   public class Player extends Creature
   {
      
      protected static const PATH_MATRIX_CENTER:int = PATH_MAX_DISTANCE;
      
      protected static const PATH_MAX_STEPS:int = 128;
      
      protected static const PATH_ERROR_UNREACHABLE:int = -4;
      
      private static var s_v1:Vector3D = new Vector3D();
      
      private static var s_v2:Vector3D = new Vector3D();
      
      protected static const PATH_WEST:int = 5;
      
      protected static const PATH_NORTH:int = 3;
      
      protected static const PATH_EMPTY:int = 0;
      
      protected static const PATH_ERROR_INTERNAL:int = -5;
      
      protected static const PATH_EAST:int = 1;
      
      protected static const PATH_COST_UNDEFINED:int = 254;
      
      protected static const PATH_SOUTH:int = 7;
      
      protected static const PATH_SOUTH_WEST:int = 6;
      
      protected static const PATH_NORTH_WEST:int = 4;
      
      protected static const PATH_MATRIX_SIZE:int = 2 * PATH_MAX_DISTANCE + 1;
      
      protected static const PATH_COST_OBSTACLE:int = 255;
      
      protected static const PATH_MAX_DISTANCE:int = 110;
      
      protected static const PATH_ERROR_GO_UPSTAIRS:int = -2;
      
      protected static const PATH_COST_MAX:int = 250;
      
      protected static const PATH_NORTH_EAST:int = 2;
      
      protected static const PATH_SOUTH_EAST:int = 8;
      
      protected static const PATH_ERROR_GO_DOWNSTAIRS:int = -1;
      
      protected static const PATH_ERROR_TOO_FAR:int = -3;
      
      protected static const PATH_EXISTS:int = 1;
       
      
      protected var m_AutowalkPathDelta:Vector3D;
      
      private var m_StateFlags:uint = 4.294967295E9;
      
      private var m_Profession:int = 0;
      
      protected var m_AutowalkTargetDiagonal:Boolean = false;
      
      protected var m_ExperienceCounter:tibia.creatures.SkillCounter;
      
      protected var m_AutowalkPathAborting:Boolean = false;
      
      private var m_OpenPvPSituations:uint = 0;
      
      private var m_Blessings:uint = 0;
      
      protected var m_AutowalkTarget:Vector3D;
      
      protected var m_ExperienceBonus:Number = 0.0;
      
      protected var m_AutowalkTargetExact:Boolean = false;
      
      private var m_Premium:Boolean = false;
      
      protected var m_AutowalkPathSteps:Array;
      
      private var m_PremiumUntil:uint = 0;
      
      private var m_UnjustPoints:tibia.creatures.UnjustPointsInfo;
      
      private var m_KnownSpells:Array;
      
      public function Player()
      {
         this.m_ExperienceCounter = new tibia.creatures.SkillCounter();
         this.m_AutowalkPathDelta = new Vector3D(0,0,0);
         this.m_AutowalkPathSteps = [];
         this.m_AutowalkTarget = new Vector3D(-1,-1,-1);
         this.m_KnownSpells = [];
         this.m_UnjustPoints = new tibia.creatures.UnjustPointsInfo(0,0,0,0,0,0,0);
         super(0,TYPE_PLAYER,null);
      }
      
      public static function s_GetExperienceForLevel(param1:uint) : Number
      {
         if(param1 >= 81454)
         {
            return NaN;
         }
         return (((param1 - 6) * param1 + 17) * param1 - 12) / 6 * 100;
      }
      
      public function startAutowalk(param1:int, param2:int, param3:int, param4:Boolean, param5:Boolean) : void
      {
         if(param1 == this.m_AutowalkTarget.x && param2 == this.m_AutowalkTarget.y && param3 == this.m_AutowalkTarget.z)
         {
            return;
         }
         if(param1 == m_Position.x + 2 * this.m_AutowalkPathDelta.x && param2 == m_Position.y + 2 * this.m_AutowalkPathDelta.y && param3 == m_Position.z + 2 * this.m_AutowalkPathDelta.z)
         {
            return;
         }
         var _loc6_:Communication = Tibia.s_GetCommunication();
         var _loc7_:WorldMapStorage = Tibia.s_GetWorldMapStorage();
         if(_loc6_ == null || !_loc6_.isGameRunning || _loc7_ == null)
         {
            return;
         }
         this.m_AutowalkTarget.setComponents(-1,-1,-1);
         this.m_AutowalkTargetDiagonal = false;
         this.m_AutowalkTargetExact = false;
         if(_loc7_.isVisible(param1,param2,param3,true))
         {
            s_v1.setComponents(param1,param2,param3);
            _loc7_.toMap(s_v1,s_v1);
            if((s_v1.x != PLAYER_OFFSET_X || s_v1.y != PLAYER_OFFSET_Y) && _loc7_.getEnterPossibleFlag(s_v1.x,s_v1.y,s_v1.z,true) == FIELD_ENTER_NOT_POSSIBLE)
            {
               _loc7_.addOnscreenMessage(MessageMode.MESSAGE_FAILURE,WorldMapStorage.MSG_SORRY_NOT_POSSIBLE);
               return;
            }
         }
         this.m_AutowalkTarget.setComponents(param1,param2,param3);
         this.m_AutowalkTargetDiagonal = param4;
         this.m_AutowalkTargetExact = param5;
         if(this.m_AutowalkPathAborting)
         {
            return;
         }
         if(this.m_AutowalkPathSteps.length == 1)
         {
            return;
         }
         if(this.m_AutowalkPathSteps.length == 0)
         {
            this.startAutowalkInternal();
         }
         else
         {
            _loc6_.sendCSTOP();
            this.m_AutowalkPathAborting = true;
         }
      }
      
      public function get anticipatedPosition() : Vector3D
      {
         return m_Position.add(this.m_AutowalkPathDelta);
      }
      
      public function get level() : uint
      {
         return uint(getSkillValue(SKILL_LEVEL));
      }
      
      public function set profession(param1:int) : void
      {
         var _loc2_:PropertyChangeEvent = null;
         if(param1 != PROFESSION_DRUID && param1 != PROFESSION_KNIGHT && param1 != PROFESSION_PALADIN && param1 != PROFESSION_SORCERER)
         {
            param1 = PROFESSION_NONE;
         }
         if(this.m_Profession != param1)
         {
            this.m_Profession = param1;
            _loc2_ = new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE);
            _loc2_.kind = PropertyChangeEventKind.UPDATE;
            _loc2_.property = "profession";
            dispatchEvent(_loc2_);
         }
      }
      
      public function get profession() : int
      {
         return this.m_Profession;
      }
      
      public function set premiumUntil(param1:uint) : void
      {
         var _loc2_:PropertyChangeEvent = null;
         if(this.m_PremiumUntil != param1)
         {
            this.m_PremiumUntil = param1;
            _loc2_ = new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE);
            _loc2_.kind = PropertyChangeEventKind.UPDATE;
            _loc2_.property = "premiumUntil";
            dispatchEvent(_loc2_);
         }
      }
      
      override public function setSkill(param1:int, param2:Number, param3:Number, param4:Number) : void
      {
         var _loc5_:Number = NaN;
         switch(param1)
         {
            case SKILL_EXPERIENCE:
               _loc5_ = getSkillValue(SKILL_EXPERIENCE);
               if(param2 >= _loc5_)
               {
                  if(_loc5_ > 0)
                  {
                     this.m_ExperienceCounter.addSkillGain(param2 - _loc5_);
                  }
               }
               else
               {
                  this.m_ExperienceCounter.reset();
               }
               super.setSkill(param1,param2,param3,param4);
               break;
            case SKILL_FED:
               super.setSkill(param1,param2,param3,param4);
               this.updateStateFlags();
               break;
            default:
               super.setSkill(param1,param2,param3,param4);
         }
      }
      
      public function set unjustPoints(param1:tibia.creatures.UnjustPointsInfo) : void
      {
         var _loc2_:PropertyChangeEvent = null;
         if(!this.m_UnjustPoints.equals(param1))
         {
            this.m_UnjustPoints = param1;
            _loc2_ = new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE);
            _loc2_.kind = PropertyChangeEventKind.UPDATE;
            _loc2_.property = "unjustPoints";
            dispatchEvent(_loc2_);
         }
      }
      
      public function set blessings(param1:uint) : void
      {
         var _loc2_:PropertyChangeEvent = null;
         if(this.m_Blessings != param1)
         {
            this.m_Blessings = param1;
            _loc2_ = new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE);
            _loc2_.kind = PropertyChangeEventKind.UPDATE;
            _loc2_.property = "blessings";
            dispatchEvent(_loc2_);
         }
      }
      
      public function resetFlags() : void
      {
         setPartyFlag(PARTY_NONE);
         setPKFlag(PK_NONE);
         this.stateFlags = 0;
         guildFlag = GUILD_NONE;
      }
      
      public function get isFighting() : Boolean
      {
         return (this.m_StateFlags & 1 << STATE_FIGHTING) > 0;
      }
      
      public function get manaMax() : Number
      {
         return getSkillBase(SKILL_MANA);
      }
      
      private function updateStateFlags(param1:* = null) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:PropertyChangeEvent = null;
         var _loc2_:uint = 2147483647 & (param1 != null?uint(param1):this.m_StateFlags);
         if(getSkillValue(SKILL_FED) <= getSkillBase(SKILL_FED))
         {
            _loc2_ = _loc2_ | 1 << STATE_HUNGRY;
         }
         if(this.m_StateFlags != _loc2_)
         {
            _loc3_ = this.m_StateFlags;
            this.m_StateFlags = _loc2_;
            _loc4_ = new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE);
            _loc4_.kind = PropertyChangeEventKind.UPDATE;
            _loc4_.property = "stateFlags";
            _loc4_.oldValue = _loc3_;
            _loc4_.newValue = _loc2_;
            dispatchEvent(_loc4_);
         }
      }
      
      public function get levelPercent() : uint
      {
         return uint(getSkillProgress(SKILL_LEVEL));
      }
      
      override public function setSkillValue(param1:int, param2:Number) : void
      {
         var _loc3_:Number = NaN;
         switch(param1)
         {
            case SKILL_EXPERIENCE:
               _loc3_ = getSkillValue(SKILL_EXPERIENCE);
               if(param2 >= _loc3_)
               {
                  if(_loc3_ > 0)
                  {
                     this.m_ExperienceCounter.addSkillGain(param2 - _loc3_);
                  }
               }
               else
               {
                  this.m_ExperienceCounter.reset();
               }
               super.setSkillValue(param1,param2);
               break;
            case SKILL_FED:
               super.setSkillValue(param1,param2);
               this.updateStateFlags();
               break;
            default:
               super.setSkillValue(param1,param2);
         }
      }
      
      public function getRuneUses(param1:Rune) : int
      {
         if(param1 == null || param1.restrictLevel > getSkillValue(SKILL_LEVEL) || param1.restrictMagicLevel > getSkillValue(SKILL_MAGLEVEL) || (param1.restrictProfession & 1 << this.profession) == 0)
         {
            return -1;
         }
         if(param1.castMana <= this.mana)
         {
            return param1.castMana > 0?int(int(this.mana / param1.castMana)):int(int.MAX_VALUE);
         }
         return 0;
      }
      
      public function stopAutowalk(param1:Boolean) : void
      {
         if(param1)
         {
            stopMovementAnimation();
         }
         this.m_AutowalkPathAborting = false;
         this.m_AutowalkPathDelta.setZero();
         this.m_AutowalkPathSteps.length = 0;
         this.m_AutowalkTarget.setComponents(-1,-1,-1);
         this.m_AutowalkTargetDiagonal = false;
         this.m_AutowalkTargetExact = false;
      }
      
      public function set openPvpSituations(param1:uint) : void
      {
         var _loc2_:PropertyChangeEvent = null;
         if(this.m_OpenPvPSituations != param1)
         {
            this.m_OpenPvPSituations = param1;
            _loc2_ = new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE);
            _loc2_.kind = PropertyChangeEventKind.UPDATE;
            _loc2_.property = "openPvpSituations";
            dispatchEvent(_loc2_);
         }
      }
      
      override public function get hitpointsPercent() : Number
      {
         var _loc1_:Number = getSkillBase(SKILL_HITPOINTS);
         if(_loc1_ > 0)
         {
            return getSkillValue(SKILL_HITPOINTS) * 100 / _loc1_;
         }
         return 100;
      }
      
      public function set experienceBonus(param1:Number) : void
      {
         this.m_ExperienceBonus = param1;
      }
      
      public function set premium(param1:Boolean) : void
      {
         this.m_Premium = param1;
         var _loc2_:PropertyChangeEvent = new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE);
         _loc2_.kind = PropertyChangeEventKind.UPDATE;
         _loc2_.property = "premium";
         dispatchEvent(_loc2_);
      }
      
      public function get soulPointPercent() : Number
      {
         var _loc1_:Number = getSkillBase(SKILL_SOULPOINTS);
         if(_loc1_ > 0)
         {
            return getSkillValue(SKILL_SOULPOINTS) * 100 / _loc1_;
         }
         return 100;
      }
      
      public function getSkillGain(param1:int) : Number
      {
         switch(param1)
         {
            case SKILL_EXPERIENCE:
               return this.m_ExperienceCounter.getAverageGain();
            default:
               return NaN;
         }
      }
      
      public function get soulPoints() : Number
      {
         return getSkillValue(SKILL_SOULPOINTS);
      }
      
      override function animateMovement(param1:Number) : void
      {
         super.animateMovement(param1);
         m_AnimationDelta.x = m_AnimationDelta.x + this.m_AutowalkPathDelta.x * FIELD_SIZE;
         m_AnimationDelta.y = m_AnimationDelta.y + this.m_AutowalkPathDelta.y * FIELD_SIZE;
         if(!m_MovementRunning && this.m_AutowalkPathDelta.isZero())
         {
            if(this.m_AutowalkPathSteps.length > 0)
            {
               this.nextAutowalkStep();
            }
            else
            {
               this.startAutowalkInternal();
            }
         }
      }
      
      public function getSpellCasts(param1:Spell) : int
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(param1 == null || !this.isSpellKnown(param1) || param1.restrictLevel > getSkillValue(SKILL_LEVEL) || param1.restrictPremium && !this.premium || (param1.restrictProfession & 1 << this.profession) == 0)
         {
            return -1;
         }
         if(param1.castMana <= this.mana && param1.castSoulPoints <= getSkillValue(SKILL_SOULPOINTS))
         {
            _loc2_ = param1.castMana > 0?int(int(this.mana / param1.castMana)):int(int.MAX_VALUE);
            _loc3_ = param1.castSoulPoints > 0?int(int(this.soulPoints / param1.castSoulPoints)):int(int.MAX_VALUE);
            return Math.min(_loc2_,_loc3_);
         }
         return 0;
      }
      
      public function isSpellKnown(param1:Spell) : Boolean
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = this.knownSpells.length - 1;
         while(_loc3_ <= _loc4_)
         {
            _loc2_ = _loc3_ + _loc4_ >>> 1;
            if(param1.ID < this.knownSpells[_loc2_])
            {
               _loc4_ = _loc2_ - 1;
               continue;
            }
            if(param1.ID > this.knownSpells[_loc2_])
            {
               _loc3_ = _loc2_ + 1;
               continue;
            }
            return true;
         }
         return false;
      }
      
      override public function get mana() : Number
      {
         return getSkillValue(SKILL_MANA);
      }
      
      public function get blessings() : uint
      {
         return this.m_Blessings;
      }
      
      public function get hitpointsMax() : Number
      {
         return getSkillBase(SKILL_HITPOINTS);
      }
      
      public function get unjustPoints() : tibia.creatures.UnjustPointsInfo
      {
         return this.m_UnjustPoints;
      }
      
      override public function startMovementAnimation(param1:int, param2:int, param3:int) : void
      {
         if(param1 != this.m_AutowalkPathDelta.x || param2 != this.m_AutowalkPathDelta.y)
         {
            super.startMovementAnimation(param1,param2,param3);
         }
         this.m_AutowalkPathDelta.setZero();
         if(this.m_AutowalkPathSteps.length > 0)
         {
            this.m_AutowalkPathSteps.shift();
         }
      }
      
      public function get openPvpSituations() : uint
      {
         return this.m_OpenPvPSituations;
      }
      
      public function get premiumUntil() : uint
      {
         if(this.m_PremiumUntil == 0 && this.m_Premium)
         {
            return uint.MAX_VALUE;
         }
         return this.m_PremiumUntil;
      }
      
      public function get premium() : Boolean
      {
         return this.m_Premium;
      }
      
      public function hasBlessing(param1:uint) : Boolean
      {
         if(param1 == BLESSING_NONE)
         {
            return this.blessings == param1;
         }
         return (this.blessings & param1) == param1;
      }
      
      public function get soulPointsMax() : Number
      {
         return getSkillBase(SKILL_SOULPOINTS);
      }
      
      override public function reset() : void
      {
         var _loc1_:int = m_ID;
         super.reset();
         this.resetAutowalk();
         this.resetFlags();
         this.resetSkills();
         m_ID = _loc1_;
         this.m_KnownSpells.length = 0;
         this.m_Premium = false;
         this.m_PremiumUntil = 0;
         this.m_Blessings = BLESSING_NONE;
         this.m_Profession = PROFESSION_NONE;
         m_Type = TYPE_PLAYER;
         var _loc2_:PropertyChangeEvent = new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE);
         _loc2_.kind = PropertyChangeEventKind.UPDATE;
         _loc2_.property = "*";
         dispatchEvent(_loc2_);
      }
      
      private function startAutowalkInternal() : void
      {
         if(m_MovementRunning || this.m_AutowalkPathAborting || !this.m_AutowalkPathDelta.isZero() || this.m_AutowalkTarget.x == -1 && this.m_AutowalkTarget.y == -1 && this.m_AutowalkTarget.z == -1)
         {
            return;
         }
         var _loc1_:Communication = Tibia.s_GetCommunication();
         var _loc2_:MiniMapStorage = Tibia.s_GetMiniMapStorage();
         var _loc3_:WorldMapStorage = Tibia.s_GetWorldMapStorage();
         if(_loc1_ == null || !_loc1_.isGameRunning || _loc2_ == null || _loc3_ == null)
         {
            return;
         }
         this.m_AutowalkPathAborting = false;
         this.m_AutowalkPathDelta.setZero();
         this.m_AutowalkPathSteps.length = 0;
         var _loc4_:int = _loc2_.calculatePath(m_Position.x,m_Position.y,m_Position.z,this.m_AutowalkTarget.x,this.m_AutowalkTarget.y,this.m_AutowalkTarget.z,this.m_AutowalkTargetDiagonal,this.m_AutowalkTargetExact,this.m_AutowalkPathSteps);
         if(_loc3_.isVisible(this.m_AutowalkTarget.x,this.m_AutowalkTarget.y,this.m_AutowalkTarget.z,false))
         {
            this.m_AutowalkTarget.setComponents(-1,-1,-1);
            this.m_AutowalkTargetDiagonal = false;
            this.m_AutowalkTargetExact = false;
         }
         switch(_loc4_)
         {
            case PATH_EMPTY:
               break;
            case PATH_EXISTS:
               _loc1_.sendCGO(this.m_AutowalkPathSteps);
               this.nextAutowalkStep();
               break;
            case PATH_ERROR_GO_DOWNSTAIRS:
               _loc3_.addOnscreenMessage(MessageMode.MESSAGE_FAILURE,WorldMapStorage.MSG_PATH_GO_DOWNSTAIRS);
               break;
            case PATH_ERROR_GO_UPSTAIRS:
               _loc3_.addOnscreenMessage(MessageMode.MESSAGE_FAILURE,WorldMapStorage.MSG_PATH_GO_UPSTAIRS);
               break;
            case PATH_ERROR_TOO_FAR:
               _loc3_.addOnscreenMessage(MessageMode.MESSAGE_FAILURE,WorldMapStorage.MSG_PATH_TOO_FAR);
               break;
            case PATH_ERROR_UNREACHABLE:
               _loc3_.addOnscreenMessage(MessageMode.MESSAGE_FAILURE,WorldMapStorage.MSG_PATH_UNREACHABLE);
               this.stopAutowalk(false);
               break;
            case PATH_ERROR_INTERNAL:
               _loc3_.addOnscreenMessage(MessageMode.MESSAGE_FAILURE,WorldMapStorage.MSG_SORRY_NOT_POSSIBLE);
               this.stopAutowalk(false);
               break;
            default:
               throw new Error("Player.startAutowalkInternal: Unknown path state: " + _loc4_);
         }
      }
      
      public function resetAutowalk() : void
      {
         this.stopAutowalk(true);
         this.abortAutowalk(2);
      }
      
      public function abortAutowalk(param1:int) : void
      {
         m_Direction = param1;
         this.m_AutowalkPathAborting = false;
         this.m_AutowalkPathSteps.length = 0;
         if(!m_MovementRunning || !this.m_AutowalkPathDelta.isZero())
         {
            this.m_AutowalkPathDelta.setZero();
            stopMovementAnimation();
            this.startAutowalkInternal();
         }
      }
      
      public function set knownSpells(param1:Array) : void
      {
         var _loc2_:PropertyChangeEvent = null;
         if(param1 == null)
         {
            param1 = [];
         }
         if(this.m_KnownSpells != param1)
         {
            this.m_KnownSpells = param1.sort(Array.NUMERIC);
            _loc2_ = new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE);
            _loc2_.kind = PropertyChangeEventKind.UPDATE;
            _loc2_.property = "knownSpells";
            dispatchEvent(_loc2_);
         }
      }
      
      public function set stateFlags(param1:uint) : void
      {
         this.updateStateFlags(param1);
      }
      
      public function get experienceBonus() : Number
      {
         return this.m_ExperienceBonus;
      }
      
      public function get knownSpells() : Array
      {
         return this.m_KnownSpells;
      }
      
      override public function resetSkills() : void
      {
         m_Skills = new Vector.<Number>((SKILL_MANA_LEECH_AMOUNT + 1) * 3,true);
         var _loc1_:int = 0;
         while(_loc1_ < m_Skills.length)
         {
            m_Skills[_loc1_ + 0] = 0;
            m_Skills[_loc1_ + 1] = 0;
            m_Skills[_loc1_ + 2] = 0;
            _loc1_ = _loc1_ + 3;
         }
         this.m_ExperienceCounter.reset();
      }
      
      public function get stateFlags() : uint
      {
         return this.m_StateFlags;
      }
      
      private function nextAutowalkStep() : void
      {
         var _loc7_:* = 0;
         var _loc8_:int = 0;
         if(m_MovementRunning || this.m_AutowalkPathAborting || !this.m_AutowalkPathDelta.isZero() || this.m_AutowalkPathSteps.length == 0)
         {
            return;
         }
         var _loc1_:Communication = Tibia.s_GetCommunication();
         var _loc2_:WorldMapStorage = Tibia.s_GetWorldMapStorage();
         if(_loc1_ == null || !_loc1_.isGameRunning || _loc2_ == null)
         {
            return;
         }
         switch(this.m_AutowalkPathSteps[0] & 65535)
         {
            case PATH_EAST:
               this.m_AutowalkPathDelta.x = 1;
               break;
            case PATH_NORTH_EAST:
               this.m_AutowalkPathDelta.x = 1;
               this.m_AutowalkPathDelta.y = -1;
               break;
            case PATH_NORTH:
               this.m_AutowalkPathDelta.y = -1;
               break;
            case PATH_NORTH_WEST:
               this.m_AutowalkPathDelta.x = -1;
               this.m_AutowalkPathDelta.y = -1;
               break;
            case PATH_WEST:
               this.m_AutowalkPathDelta.x = -1;
               break;
            case PATH_SOUTH_WEST:
               this.m_AutowalkPathDelta.x = -1;
               this.m_AutowalkPathDelta.y = 1;
               break;
            case PATH_SOUTH:
               this.m_AutowalkPathDelta.y = 1;
               break;
            case PATH_SOUTH_EAST:
               this.m_AutowalkPathDelta.x = 1;
               this.m_AutowalkPathDelta.y = 1;
               break;
            default:
               throw new Error("Player.nextAutowalkStep: Invalid step(1): " + (this.m_AutowalkPathSteps[0] & 65535));
         }
         _loc2_.toMap(m_Position,s_v1);
         _loc2_.toMap(m_Position,s_v2);
         s_v2.x = s_v2.x + this.m_AutowalkPathDelta.x;
         s_v2.y = s_v2.y + this.m_AutowalkPathDelta.y;
         var _loc3_:ObjectInstance = null;
         if((_loc3_ = _loc2_.getObject(s_v2.x,s_v2.y,s_v2.z,0)) == null || _loc3_.type == null || !_loc3_.type.isBank)
         {
            this.m_AutowalkPathDelta.setZero();
            return;
         }
         var _loc4_:uint = _loc2_.getEnterPossibleFlag(s_v2.x,s_v2.y,s_v2.z,false);
         if(_loc4_ == FIELD_ENTER_NOT_POSSIBLE || _loc2_.getFieldHeight(s_v1.x,s_v1.y,s_v1.z) + 1 < _loc2_.getFieldHeight(s_v2.x,s_v2.y,s_v2.z))
         {
            this.m_AutowalkPathDelta.setZero();
            return;
         }
         if(_loc4_ == FIELD_ENTER_POSSIBLE)
         {
            super.startMovementAnimation(this.m_AutowalkPathDelta.x,this.m_AutowalkPathDelta.y,_loc3_.type.waypoints);
            m_AnimationDelta.x = m_AnimationDelta.x + this.m_AutowalkPathDelta.x * FIELD_SIZE;
            m_AnimationDelta.y = m_AnimationDelta.y + this.m_AutowalkPathDelta.y * FIELD_SIZE;
         }
         else if(_loc4_ == FIELD_ENTER_POSSIBLE_NO_ANIMATION)
         {
            this.m_AutowalkPathDelta.setZero();
         }
         var _loc5_:int = 1;
         var _loc6_:int = this.m_AutowalkPathSteps.length;
         while(_loc5_ < _loc6_)
         {
            _loc7_ = this.m_AutowalkPathSteps[_loc5_] & 65535;
            _loc8_ = (this.m_AutowalkPathSteps[_loc5_] & 4294901760) >>> 16;
            switch(_loc7_)
            {
               case PATH_EAST:
                  s_v2.x = s_v2.x + 1;
                  break;
               case PATH_NORTH_EAST:
                  s_v2.x = s_v2.x + 1;
                  s_v2.y = s_v2.y - 1;
                  break;
               case PATH_NORTH:
                  s_v2.y = s_v2.y - 1;
                  break;
               case PATH_NORTH_WEST:
                  s_v2.x = s_v2.x - 1;
                  s_v2.y = s_v2.y - 1;
                  break;
               case PATH_WEST:
                  s_v2.x = s_v2.x - 1;
                  break;
               case PATH_SOUTH_WEST:
                  s_v2.x = s_v2.x - 1;
                  s_v2.y = s_v2.y + 1;
                  break;
               case PATH_SOUTH:
                  s_v2.y = s_v2.y + 1;
                  break;
               case PATH_SOUTH_EAST:
                  s_v2.x = s_v2.x + 1;
                  s_v2.y = s_v2.y + 1;
                  break;
               default:
                  throw new Error("Player.nextAutowalkStep: Invalid step(2): " + (this.m_AutowalkPathSteps[_loc5_] & 65535));
            }
            if(s_v2.x < 0 || s_v2.x >= MAPSIZE_X || s_v2.y < 0 || s_v2.y >= MAPSIZE_Y)
            {
               break;
            }
            if(_loc2_.getMiniMapCost(s_v2.x,s_v2.y,s_v2.z) > _loc8_)
            {
               _loc1_.sendCSTOP();
               this.m_AutowalkPathAborting = true;
               break;
            }
            _loc5_++;
         }
      }
      
      override public function set type(param1:int) : void
      {
      }
      
      override public function get manaPercent() : Number
      {
         var _loc1_:Number = getSkillBase(SKILL_MANA);
         if(_loc1_ > 0)
         {
            return getSkillValue(SKILL_MANA) * 100 / _loc1_;
         }
         return 100;
      }
   }
}
