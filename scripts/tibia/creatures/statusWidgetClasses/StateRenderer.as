package tibia.creatures.statusWidgetClasses
{
   import mx.core.UIComponent;
   import shared.utility.cacheStyleInstance;
   import tibia.creatures.Player;
   import mx.events.PropertyChangeEvent;
   import mx.core.EdgeMetrics;
   import flash.display.DisplayObject;
   
   public class StateRenderer extends UIComponent
   {
      
      protected static const BLESSING_SPARK_OF_PHOENIX:int = BLESSING_WISDOM_OF_SOLITUDE << 1;
      
      protected static const PARTY_LEADER_SEXP_ACTIVE:int = 6;
      
      protected static const PARTY_MAX_FLASHING_TIME:uint = 5000;
      
      protected static const STATE_PZ_BLOCK:int = 13;
      
      protected static const PARTY_MEMBER_SEXP_ACTIVE:int = 5;
      
      protected static const PK_REVENGE:int = 6;
      
      protected static const SKILL_FIGHTCLUB:int = 10;
      
      protected static const NPC_SPEECH_TRAVEL:uint = 5;
      
      protected static const RISKINESS_DANGEROUS:int = 1;
      
      protected static const NUM_PVP_HELPERS_FOR_RISKINESS_DANGEROUS:uint = 5;
      
      protected static const PK_PARTYMODE:int = 2;
      
      protected static const RISKINESS_NONE:int = 0;
      
      protected static const GUILD_NONE:int = 0;
      
      protected static const PARTY_MEMBER:int = 2;
      
      protected static const STATE_DRUNK:int = 3;
      
      protected static const PARTY_OTHER:int = 11;
      
      protected static const SKILL_EXPERIENCE:int = 0;
      
      protected static const TYPE_SUMMON_OTHERS:int = 4;
      
      protected static const BLESSING_FIRE_OF_SUNS:int = BLESSING_EMBRACE_OF_TIBIA << 1;
      
      protected static const SKILL_STAMINA:int = 17;
      
      protected static const TYPE_NPC:int = 2;
      
      protected static const STATE_NONE:int = -1;
      
      protected static const PARTY_MEMBER_SEXP_INACTIVE_GUILTY:int = 7;
      
      protected static const SKILL_FIGHTSHIELD:int = 8;
      
      protected static const SKILL_MANA_LEECH_CHANCE:int = 23;
      
      protected static const SKILL_FIGHTDISTANCE:int = 9;
      
      protected static const PK_EXCPLAYERKILLER:int = 5;
      
      protected static const NUM_CREATURES:int = 1300;
      
      protected static const NUM_TRAPPERS:int = 8;
      
      protected static const SKILL_FED:int = 15;
      
      protected static const SKILL_MAGLEVEL:int = 2;
      
      protected static const SKILL_FISHING:int = 14;
      
      protected static const SKILL_HITPOINTS_PERCENT:int = 3;
      
      protected static const STATE_BLEEDING:int = 15;
      
      protected static const PK_PLAYERKILLER:int = 4;
      
      protected static const PROFESSION_MASK_KNIGHT:int = 1 << PROFESSION_KNIGHT;
      
      protected static const STATE_DAZZLED:int = 10;
      
      protected static const SUMMON_OTHERS:int = 2;
      
      protected static const SKILL_NONE:int = -1;
      
      protected static const NPC_SPEECH_TRADER:uint = 2;
      
      private static const BUNDLE:String = "StatusWidget";
      
      protected static const GUILD_MEMBER:int = 4;
      
      protected static const PROFESSION_NONE:int = 0;
      
      protected static const MAX_NAME_LENGTH:int = 29;
      
      protected static const PARTY_LEADER:int = 1;
      
      protected static const STATE_PZ_ENTERED:int = 14;
      
      protected static const SKILL_CARRYSTRENGTH:int = 7;
      
      protected static const PK_ATTACKER:int = 1;
      
      protected static const STATE_ELECTRIFIED:int = 2;
      
      protected static const SKILL_FIGHTSWORD:int = 11;
      
      protected static const GUILD_WAR_NEUTRAL:int = 3;
      
      protected static const STATE_DROWNING:int = 8;
      
      protected static const SKILL_LIFE_LEECH_AMOUNT:int = 22;
      
      private static const STATE_OPTIONS:Array = [{
         "value":STATE_POISONED,
         "styleProp":"iconStatePoisoned",
         "toolTip":"TIP_STATE_POISONED"
      },{
         "value":STATE_BURNING,
         "styleProp":"iconStateBurning",
         "toolTip":"TIP_STATE_BURNING"
      },{
         "value":STATE_ELECTRIFIED,
         "styleProp":"iconStateElectrified",
         "toolTip":"TIP_STATE_ELECTRIFIED"
      },{
         "value":STATE_DRUNK,
         "styleProp":"iconStateDrunk",
         "toolTip":"TIP_STATE_DRUNK"
      },{
         "value":STATE_MANA_SHIELD,
         "styleProp":"iconStateManaShield",
         "toolTip":"TIP_STATE_MANA_SHIELD"
      },{
         "value":STATE_SLOW,
         "styleProp":"iconStateSlow",
         "toolTip":"TIP_STATE_SLOW"
      },{
         "value":STATE_FAST,
         "styleProp":"iconStateFast",
         "toolTip":"TIP_STATE_FAST"
      },{
         "value":STATE_FIGHTING,
         "styleProp":"iconStateFighting",
         "toolTip":"TIP_STATE_FIGHTING"
      },{
         "value":STATE_DROWNING,
         "styleProp":"iconStateDrowning",
         "toolTip":"TIP_STATE_DROWNING"
      },{
         "value":STATE_FREEZING,
         "styleProp":"iconStateFreezing",
         "toolTip":"TIP_STATE_FREEZING"
      },{
         "value":STATE_DAZZLED,
         "styleProp":"iconStateDazzled",
         "toolTip":"TIP_STATE_DAZZLED"
      },{
         "value":STATE_CURSED,
         "styleProp":"iconStateCursed",
         "toolTip":"TIP_STATE_CURSED"
      },{
         "value":STATE_STRENGTHENED,
         "styleProp":"iconStateStrengthened",
         "toolTip":"TIP_STATE_STRENGTHENED"
      },{
         "value":STATE_PZ_BLOCK,
         "styleProp":"iconStatePZBlock",
         "toolTip":"TIP_STATE_PZ_BLOCK"
      },{
         "value":STATE_PZ_ENTERED,
         "styleProp":"iconStatePZEntered",
         "toolTip":"TIP_STATE_PZ_ENTERED"
      },{
         "value":STATE_BLEEDING,
         "styleProp":"iconStateBleeding",
         "toolTip":"TIP_STATE_BLEEDING"
      },{
         "value":STATE_HUNGRY,
         "styleProp":"iconStateHungry",
         "toolTip":"TIP_STATE_HUNGRY"
      }];
      
      protected static const PARTY_MEMBER_SEXP_OFF:int = 3;
      
      protected static const PROFESSION_MASK_DRUID:int = 1 << PROFESSION_DRUID;
      
      protected static const PARTY_MEMBER_SEXP_INACTIVE_INNOCENT:int = 9;
      
      protected static const GUILD_WAR_ALLY:int = 1;
      
      protected static const PK_NONE:int = 0;
      
      protected static const PROFESSION_SORCERER:int = 3;
      
      protected static const STATE_SLOW:int = 5;
      
      protected static const PARTY_NONE:int = 0;
      
      protected static const SKILL_CRITICAL_HIT_CHANCE:int = 19;
      
      protected static const SUMMON_OWN:int = 1;
      
      protected static const SKILL_EXPERIENCE_GAIN:int = -2;
      
      protected static const PROFESSION_MASK_NONE:int = 1 << PROFESSION_NONE;
      
      protected static const TYPE_SUMMON_OWN:int = 3;
      
      protected static const PROFESSION_MASK_SORCERER:int = 1 << PROFESSION_SORCERER;
      
      protected static const PROFESSION_KNIGHT:int = 1;
      
      protected static const NPC_SPEECH_QUESTTRADER:uint = 4;
      
      protected static const PARTY_LEADER_SEXP_INACTIVE_GUILTY:int = 8;
      
      protected static const BLESSING_WISDOM_OF_SOLITUDE:int = BLESSING_FIRE_OF_SUNS << 1;
      
      protected static const PROFESSION_PALADIN:int = 2;
      
      protected static const SKILL_FIGHTAXE:int = 12;
      
      protected static const SKILL_CRITICAL_HIT_DAMAGE:int = 20;
      
      protected static const PARTY_LEADER_SEXP_OFF:int = 4;
      
      protected static const SKILL_SOULPOINTS:int = 16;
      
      protected static const BLESSING_EMBRACE_OF_TIBIA:int = BLESSING_SPIRITUAL_SHIELDING << 1;
      
      protected static const STATE_FAST:int = 6;
      
      protected static const BLESSING_TWIST_OF_FATE:int = BLESSING_SPARK_OF_PHOENIX << 1;
      
      protected static const SKILL_MANA_LEECH_AMOUNT:int = 24;
      
      private static var s_ChildWidth:Number = NaN;
      
      private static var s_ChildHeight:Number = NaN;
      
      protected static const BLESSING_NONE:int = 0;
      
      protected static const GUILD_OTHER:int = 5;
      
      protected static const TYPE_PLAYER:int = 0;
      
      protected static const SKILL_HITPOINTS:int = 4;
      
      protected static const SKILL_OFFLINETRAINING:int = 18;
      
      protected static const STATE_MANA_SHIELD:int = 4;
      
      protected static const SKILL_MANA:int = 5;
      
      protected static const PROFESSION_MASK_PALADIN:int = 1 << PROFESSION_PALADIN;
      
      protected static const STATE_CURSED:int = 11;
      
      protected static const BLESSING_ADVENTURER:int = 1;
      
      protected static const STATE_FREEZING:int = 9;
      
      protected static const PARTY_LEADER_SEXP_INACTIVE_INNOCENT:int = 10;
      
      protected static const STATE_POISONED:int = 0;
      
      protected static const SKILL_LIFE_LEECH_CHANCE:int = 21;
      
      protected static const TYPE_MONSTER:int = 1;
      
      protected static const STATE_BURNING:int = 1;
      
      protected static const SKILL_FIGHTFIST:int = 13;
      
      protected static const PK_AGGRESSOR:int = 3;
      
      protected static const GUILD_WAR_ENEMY:int = 2;
      
      protected static const SKILL_LEVEL:int = 1;
      
      protected static const STATE_STRENGTHENED:int = 12;
      
      protected static const STATE_HUNGRY:int = 31;
      
      protected static const PROFESSION_MASK_ANY:int = PROFESSION_MASK_DRUID | PROFESSION_MASK_KNIGHT | PROFESSION_MASK_PALADIN | PROFESSION_MASK_SORCERER;
      
      protected static const SUMMON_NONE:int = 0;
      
      protected static const PROFESSION_DRUID:int = 4;
      
      protected static const STATE_FIGHTING:int = 7;
      
      protected static const NPC_SPEECH_QUEST:uint = 3;
      
      protected static const NPC_SPEECH_NORMAL:uint = 1;
      
      protected static const BLESSING_SPIRITUAL_SHIELDING:int = BLESSING_ADVENTURER << 1;
      
      protected static const NPC_SPEECH_NONE:uint = 0;
      
      protected static const PK_MAX_FLASHING_TIME:uint = 5000;
      
      protected static const SKILL_GOSTRENGTH:int = 6;
      
      {
         cacheStyleInstance(STATE_OPTIONS,".statusWidgetIcons");
      }
      
      private var m_UncommittedBitSet:Boolean = true;
      
      private var m_BitSet:uint = 4.294967295E9;
      
      private var m_UncommittedMaxColumns:Boolean = false;
      
      private var m_MaxColumns:int = 2.147483647E9;
      
      private var m_UncommittedMaxRows:Boolean = false;
      
      private var m_MinRows:int = 1;
      
      private var m_ChildColumns:int = 0;
      
      private var m_UncommittedMinColumns:Boolean = false;
      
      private var m_UncommittedCharacter:Boolean = false;
      
      private var m_ChildRows:int = 0;
      
      private var m_MinColumns:int = 1;
      
      private var m_MaxRows:int = 2.147483647E9;
      
      private var m_InvalidedStyle:Boolean = true;
      
      private var m_Character:Player = null;
      
      private var m_UncommittedMinRows:Boolean = false;
      
      public function StateRenderer()
      {
         var _loc1_:Object = null;
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         super();
         if(isNaN(s_ChildWidth) && isNaN(s_ChildHeight))
         {
            s_ChildWidth = 0;
            s_ChildHeight = 0;
            for each(_loc1_ in STATE_OPTIONS)
            {
               if(_loc1_.hasOwnProperty("styleInstance") && _loc1_.styleInstance is DisplayObject)
               {
                  _loc2_ = DisplayObject(_loc1_.styleInstance).width;
                  if(!isNaN(_loc2_))
                  {
                     s_ChildWidth = Math.max(s_ChildWidth,_loc2_);
                  }
                  _loc3_ = DisplayObject(_loc1_.styleInstance).height;
                  if(!isNaN(_loc3_))
                  {
                     s_ChildHeight = Math.max(s_ChildHeight,_loc3_);
                  }
               }
            }
         }
      }
      
      public function get minColumns() : int
      {
         return this.m_MinColumns;
      }
      
      public function get minRows() : int
      {
         return this.m_MinRows;
      }
      
      public function set maxRows(param1:int) : void
      {
         param1 = Math.max(1,param1);
         if(this.m_MaxRows != param1)
         {
            this.m_MaxRows = param1;
            this.m_UncommittedMaxRows = true;
            invalidateDisplayList();
            invalidateProperties();
            invalidateSize();
         }
      }
      
      public function set minRows(param1:int) : void
      {
         param1 = Math.max(1,param1);
         if(this.m_MinRows != param1)
         {
            this.m_MinRows = param1;
            this.m_UncommittedMinRows = true;
            invalidateDisplayList();
            invalidateProperties();
            invalidateSize();
         }
      }
      
      override protected function commitProperties() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Object = null;
         var _loc3_:RotatingShapeWrapper = null;
         super.commitProperties();
         if(this.m_UncommittedCharacter)
         {
            if(this.character != null)
            {
               this.bitSet = this.character.stateFlags;
            }
            else
            {
               this.bitSet = 16777215;
            }
            this.m_UncommittedCharacter = false;
         }
         if(this.m_UncommittedBitSet)
         {
            _loc1_ = numChildren - 1;
            while(_loc1_ >= 0)
            {
               removeChildAt(_loc1_);
               _loc1_--;
            }
            for each(_loc2_ in STATE_OPTIONS)
            {
               if(this.bitSet & 1 << _loc2_.value)
               {
                  _loc3_ = new RotatingShapeWrapper();
                  _loc3_.explicitHeight = s_ChildHeight;
                  _loc3_.explicitWidth = s_ChildWidth;
                  _loc3_.toolTip = resourceManager.getString(BUNDLE,_loc2_.toolTip);
                  _loc3_.addChild(_loc2_.styleInstance);
                  addChild(_loc3_);
               }
            }
            this.m_UncommittedBitSet = false;
         }
         if(this.m_UncommittedMinColumns)
         {
            this.m_UncommittedMinColumns = false;
         }
         if(this.m_UncommittedMaxColumns)
         {
            this.m_UncommittedMaxColumns = false;
         }
         if(this.m_UncommittedMinRows)
         {
            this.m_UncommittedMinRows = false;
         }
         if(this.m_UncommittedMaxRows)
         {
            this.m_UncommittedMaxRows = false;
         }
      }
      
      public function set character(param1:Player) : void
      {
         if(this.m_Character != param1)
         {
            if(this.m_Character != null)
            {
               this.m_Character.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onCharacterChange);
            }
            this.m_Character = param1;
            this.m_UncommittedCharacter = true;
            invalidateDisplayList();
            invalidateProperties();
            invalidateSize();
            if(this.m_Character != null)
            {
               this.m_Character.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onCharacterChange);
            }
         }
      }
      
      protected function get bitSet() : uint
      {
         return this.m_BitSet;
      }
      
      private function onCharacterChange(param1:PropertyChangeEvent) : void
      {
         if(param1.property == "stateFlags" || param1.property == "*")
         {
            this.bitSet = this.character.stateFlags;
         }
      }
      
      override public function styleChanged(param1:String) : void
      {
         super.styleChanged(param1);
         this.m_InvalidedStyle = true;
         invalidateProperties();
      }
      
      override protected function measure() : void
      {
         var _loc3_:EdgeMetrics = null;
         var _loc7_:Number = NaN;
         super.measure();
         this.m_ChildColumns = this.m_MinColumns;
         this.m_ChildRows = this.m_MinRows;
         var _loc1_:int = 0;
         var _loc2_:int = STATE_OPTIONS.length - 1;
         while(_loc2_ >= 0)
         {
            if(this.bitSet & 1 << STATE_OPTIONS[_loc2_].value)
            {
               _loc1_++;
            }
            _loc2_--;
         }
         while(this.m_ChildRows * this.m_ChildColumns < _loc1_)
         {
            if(this.m_ChildColumns < this.m_MaxColumns)
            {
               this.m_ChildColumns++;
               continue;
            }
            if(this.m_ChildRows < this.m_MaxRows)
            {
               this.m_ChildRows++;
               continue;
            }
            break;
         }
         _loc3_ = this.viewMetricsAndPadding;
         var _loc4_:Number = getStyle("horizontalGap");
         var _loc5_:Number = _loc3_.left + _loc3_.right;
         measuredMinWidth = this.m_MinColumns * s_ChildWidth + (this.m_MinColumns - 1) * _loc4_ + _loc5_;
         measuredWidth = Math.max(measuredMinWidth,this.m_ChildColumns * s_ChildWidth + (this.m_ChildColumns - 1) * _loc4_ + _loc5_);
         var _loc6_:Number = getStyle("verticalGap");
         _loc7_ = _loc3_.top + _loc3_.bottom;
         measuredMinHeight = this.m_MinRows * s_ChildHeight + (this.m_MinRows - 1) * _loc6_ + _loc7_;
         measuredHeight = Math.max(measuredMinHeight,this.m_ChildRows * s_ChildHeight + (this.m_ChildRows - 1) * _loc6_ + _loc7_);
      }
      
      public function get maxColumns() : int
      {
         return this.m_MaxColumns;
      }
      
      public function set minColumns(param1:int) : void
      {
         param1 = Math.max(1,param1);
         if(this.m_MinColumns != param1)
         {
            this.m_MinColumns = param1;
            this.m_UncommittedMinColumns = true;
            invalidateDisplayList();
            invalidateProperties();
            invalidateSize();
         }
      }
      
      public function get character() : Player
      {
         return this.m_Character;
      }
      
      protected function set bitSet(param1:uint) : void
      {
         if(this.m_BitSet != param1)
         {
            this.m_BitSet = param1;
            this.m_UncommittedBitSet = true;
            invalidateDisplayList();
            invalidateProperties();
            invalidateSize();
         }
      }
      
      public function get maxRows() : int
      {
         return this.m_MaxRows;
      }
      
      public function set maxColumns(param1:int) : void
      {
         param1 = Math.max(1,param1);
         if(this.m_MaxColumns != param1)
         {
            this.m_MaxColumns = param1;
            this.m_UncommittedMaxColumns = true;
            invalidateDisplayList();
            invalidateProperties();
            invalidateSize();
         }
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         var _loc3_:EdgeMetrics = null;
         var _loc5_:Number = NaN;
         var _loc13_:UIComponent = null;
         var _loc14_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc16_:int = 0;
         var _loc17_:Number = NaN;
         super.updateDisplayList(param1,param2);
         if(this.m_ChildRows == 0 || this.m_ChildColumns == 0)
         {
            return;
         }
         _loc3_ = this.viewMetricsAndPadding;
         var _loc4_:Number = getStyle("horizontalGap");
         _loc5_ = getStyle("verticalGap");
         var _loc6_:Number = this.m_ChildRows * s_ChildHeight + (this.m_ChildRows - 1) * _loc5_;
         var _loc7_:Number = param2 - _loc3_.top - _loc3_.bottom;
         var _loc8_:Number = param1 - _loc3_.left - _loc3_.right;
         var _loc9_:Number = _loc3_.left;
         var _loc10_:Number = _loc3_.top + (_loc7_ - _loc6_) / 2 - s_ChildHeight - _loc5_;
         var _loc11_:int = 0;
         var _loc12_:int = numChildren;
         while(_loc11_ < _loc12_)
         {
            if(_loc11_ % this.m_ChildColumns == 0)
            {
               _loc16_ = Math.min(_loc12_ - _loc11_,this.m_ChildColumns);
               _loc17_ = _loc16_ * s_ChildWidth + (_loc16_ - 1) * _loc4_;
               _loc9_ = _loc3_.left + (_loc8_ - _loc17_) / 2;
               _loc10_ = _loc10_ + (s_ChildHeight + _loc5_);
            }
            _loc13_ = UIComponent(getChildAt(_loc11_));
            _loc14_ = _loc13_.getExplicitOrMeasuredHeight();
            _loc15_ = _loc13_.getExplicitOrMeasuredWidth();
            _loc13_.move(_loc9_ + (s_ChildWidth - _loc15_) / 2,_loc10_ + (s_ChildHeight - _loc14_) / 2);
            _loc13_.setActualSize(_loc15_,_loc14_);
            _loc9_ = _loc9_ + (s_ChildWidth + _loc4_);
            _loc11_++;
         }
      }
      
      public function get borderMetrics() : EdgeMetrics
      {
         return EdgeMetrics.EMPTY;
      }
      
      public function get viewMetricsAndPadding() : EdgeMetrics
      {
         var _loc1_:EdgeMetrics = this.borderMetrics.clone();
         _loc1_.bottom = _loc1_.bottom + getStyle("paddingBottom");
         _loc1_.left = _loc1_.left + getStyle("paddingLeft");
         _loc1_.right = _loc1_.right + getStyle("paddingRight");
         _loc1_.top = _loc1_.top + getStyle("paddingTop");
         return _loc1_;
      }
   }
}

import shared.controls.ShapeWrapper;
import flash.display.DisplayObject;
import flash.geom.Matrix;

class RotatingShapeWrapper extends ShapeWrapper
{
    
   
   function RotatingShapeWrapper()
   {
      super();
   }
   
   override protected function updateDisplayList(param1:Number, param2:Number) : void
   {
      var _loc3_:DisplayObject = null;
      var _loc4_:Matrix = null;
      var _loc5_:Number = NaN;
      var _loc6_:Number = NaN;
      var _loc7_:Number = NaN;
      var _loc8_:Number = NaN;
      super.updateDisplayList(param1,param2);
      if(numChildren > 0)
      {
         _loc3_ = getChildAt(0);
         _loc4_ = transform.concatenatedMatrix;
         _loc5_ = _loc4_.a;
         _loc6_ = _loc4_.b;
         if(_loc5_ == _loc4_.d && Math.abs(_loc5_) <= 1 && _loc6_ == -_loc4_.c && Math.abs(_loc6_) <= 1)
         {
            _loc7_ = _loc3_.width / 2;
            _loc8_ = _loc3_.height / 2;
            _loc3_.transform.matrix = new Matrix(_loc5_,-_loc6_,_loc6_,_loc5_,-_loc7_ * _loc5_ - _loc8_ * _loc6_ + _loc7_,_loc7_ * _loc6_ - _loc8_ * _loc5_ + _loc8_);
         }
      }
   }
}
