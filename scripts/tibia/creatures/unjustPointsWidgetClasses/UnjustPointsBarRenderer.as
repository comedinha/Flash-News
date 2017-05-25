package tibia.creatures.unjustPointsWidgetClasses
{
   import flash.display.BitmapData;
   import flash.display.Graphics;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import mx.core.BitmapAsset;
   import mx.core.EdgeMetrics;
   import mx.core.IDataRenderer;
   import mx.core.UIComponent;
   import mx.styles.CSSStyleDeclaration;
   import mx.styles.StyleManager;
   import tibia.creatures.CreatureStorage;
   import tibia.creatures.Player;
   
   public class UnjustPointsBarRenderer extends UIComponent implements IDataRenderer
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
      
      protected static const TYPE_NPC:int = 2;
      
      protected static const BLESSING_FIRE_OF_SUNS:int = BLESSING_SPARK_OF_PHOENIX << 1;
      
      protected static const SKILL_STAMINA:int = 17;
      
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
      
      private static var s_Rect:Rectangle = new Rectangle();
      
      protected static const SKILL_HITPOINTS_PERCENT:int = 3;
      
      protected static const STATE_BLEEDING:int = 15;
      
      protected static const PK_PLAYERKILLER:int = 4;
      
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
      
      private static var s_Point:Point = new Point();
      
      protected static const SKILL_CARRYSTRENGTH:int = 7;
      
      protected static const STATE_PZ_ENTERED:int = 14;
      
      protected static const PK_ATTACKER:int = 1;
      
      protected static const STATE_ELECTRIFIED:int = 2;
      
      protected static const SKILL_FIGHTSWORD:int = 11;
      
      protected static const GUILD_WAR_NEUTRAL:int = 3;
      
      protected static const STATE_DROWNING:int = 8;
      
      private static const UNJUST_BAR_GREEN_BITMAP:BitmapData = (new UNJUST_BAR_GREEN() as BitmapAsset).bitmapData;
      
      protected static const BLESSING_HEART_OF_THE_MOUNTAIN:int = BLESSING_EMBRACE_OF_TIBIA << 1;
      
      protected static const SKILL_LIFE_LEECH_AMOUNT:int = 22;
      
      private static const UNJUST_BAR_GREEN:Class = UnjustPointsBarRenderer_UNJUST_BAR_GREEN;
      
      protected static const PARTY_MEMBER_SEXP_OFF:int = 3;
      
      private static const UNJUST_BAR_RED:Class = UnjustPointsBarRenderer_UNJUST_BAR_RED;
      
      public static const SCALE_DAY:uint = 0;
      
      protected static const PROFESSION_MASK_DRUID:int = 1 << PROFESSION_DRUID;
      
      protected static const PARTY_MEMBER_SEXP_INACTIVE_INNOCENT:int = 9;
      
      protected static const GUILD_WAR_ALLY:int = 1;
      
      protected static const PK_NONE:int = 0;
      
      private static const UNJUST_BAR_RED_BITMAP:BitmapData = (new UNJUST_BAR_RED() as BitmapAsset).bitmapData;
      
      protected static const PROFESSION_SORCERER:int = 3;
      
      public static const SCALE_MONTH:uint = 2;
      
      protected static const STATE_SLOW:int = 5;
      
      protected static const PARTY_NONE:int = 0;
      
      protected static const SKILL_CRITICAL_HIT_CHANCE:int = 19;
      
      protected static const SUMMON_OWN:int = 1;
      
      protected static const SKILL_EXPERIENCE_GAIN:int = -2;
      
      protected static const PROFESSION_MASK_NONE:int = 1 << PROFESSION_NONE;
      
      protected static const PROFESSION_MASK_SORCERER:int = 1 << PROFESSION_SORCERER;
      
      protected static const PROFESSION_KNIGHT:int = 1;
      
      protected static const NPC_SPEECH_QUESTTRADER:uint = 4;
      
      protected static const PARTY_LEADER_SEXP_INACTIVE_GUILTY:int = 8;
      
      protected static const BLESSING_WISDOM_OF_SOLITUDE:int = BLESSING_TWIST_OF_FATE << 1;
      
      protected static const PROFESSION_PALADIN:int = 2;
      
      protected static const SKILL_FIGHTAXE:int = 12;
      
      protected static const SKILL_CRITICAL_HIT_DAMAGE:int = 20;
      
      protected static const PARTY_LEADER_SEXP_OFF:int = 4;
      
      private static const UNJUST_BAR_YELLOW_BITMAP:BitmapData = (new UNJUST_BAR_YELLOW() as BitmapAsset).bitmapData;
      
      protected static const SKILL_SOULPOINTS:int = 16;
      
      protected static const BLESSING_EMBRACE_OF_TIBIA:int = BLESSING_SPIRITUAL_SHIELDING << 1;
      
      protected static const STATE_FAST:int = 6;
      
      protected static const BLESSING_TWIST_OF_FATE:int = BLESSING_ADVENTURER << 1;
      
      protected static const SKILL_MANA_LEECH_AMOUNT:int = 24;
      
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
      
      private static const UNJUST_BAR_YELLOW:Class = UnjustPointsBarRenderer_UNJUST_BAR_YELLOW;
      
      private static var s_Trans:Matrix = new Matrix(1,0,0,1);
      
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
      
      protected static const TYPE_PLAYERSUMMON:int = 3;
      
      public static const SCALE_WEEK:uint = 1;
      
      protected static const BLESSING_SPIRITUAL_SHIELDING:int = BLESSING_FIRE_OF_SUNS << 1;
      
      protected static const NPC_SPEECH_NONE:uint = 0;
      
      protected static const PK_MAX_FLASHING_TIME:uint = 5000;
      
      protected static const SKILL_GOSTRENGTH:int = 6;
      
      {
         s_InitialiseStyle();
      }
      
      private var m_BarColor:BitmapData;
      
      private var m_MarkCount:uint = 0;
      
      private var m_Player:Player;
      
      private var m_MaximumValue:Number = 100;
      
      private var m_CurrentValue:Number = 0;
      
      private var m_MinimumValue:Number = 0;
      
      public function UnjustPointsBarRenderer()
      {
         this.m_BarColor = UNJUST_BAR_GREEN_BITMAP;
         super();
      }
      
      private static function s_InitialiseStyle() : void
      {
         var Selector:String = "UnjustPointsBarRenderer";
         var Decl:CSSStyleDeclaration = StyleManager.getStyleDeclaration(Selector);
         if(Decl == null)
         {
            Decl = new CSSStyleDeclaration(Selector);
         }
         Decl.factory = function():void
         {
            this.color = 13684944;
            this.paddingBottom = 2;
            this.paddingLeft = 2;
            this.paddingRight = 2;
            this.paddingTop = 2;
            this.horizontalGap = 2;
            this.verticalGap = 2;
            this.pointbarHeight = 4;
            this.pointbarWidth = 70;
            this.pointbarLeft = 22;
            this.pointbarTop = 2;
         };
         StyleManager.setStyleDeclaration(Selector,Decl,true);
      }
      
      public static function getBarColorForRemainingKills(param1:uint) : BitmapData
      {
         if(param1 > 2)
         {
            return UNJUST_BAR_GREEN_BITMAP;
         }
         if(param1 > 1)
         {
            return UNJUST_BAR_YELLOW_BITMAP;
         }
         return UNJUST_BAR_RED_BITMAP;
      }
      
      public function get maximumValue() : Number
      {
         return this.m_MaximumValue;
      }
      
      public function get minimumValue() : Number
      {
         return this.m_MinimumValue;
      }
      
      public function set minimumValue(param1:Number) : void
      {
         if(param1 != this.m_MinimumValue)
         {
            this.m_MinimumValue = param1;
            this.m_CurrentValue = Math.max(param1,this.m_CurrentValue);
            invalidateDisplayList();
         }
      }
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
      }
      
      public function set marks(param1:uint) : void
      {
         if(param1 != this.m_MarkCount)
         {
            this.m_MarkCount = param1;
            invalidateDisplayList();
         }
      }
      
      public function get marks() : uint
      {
         return this.m_MarkCount;
      }
      
      public function get data() : Object
      {
         return this.m_Player;
      }
      
      private function getNextPkFlag() : int
      {
         switch(this.m_Player.pkFlag)
         {
            case PK_PLAYERKILLER:
            case PK_EXCPLAYERKILLER:
               return PK_EXCPLAYERKILLER;
            default:
               return PK_PLAYERKILLER;
         }
      }
      
      public function set maximumValue(param1:Number) : void
      {
         if(param1 != this.m_MaximumValue)
         {
            this.m_MaximumValue = param1;
            this.m_CurrentValue = Math.min(param1,this.m_CurrentValue);
            invalidateDisplayList();
         }
      }
      
      public function set barColor(param1:BitmapData) : void
      {
         this.m_BarColor = param1;
      }
      
      public function set value(param1:Number) : void
      {
         param1 = Math.max(Math.min(this.maximumValue,param1),this.minimumValue);
         if(param1 != this.m_CurrentValue)
         {
            this.m_CurrentValue = param1;
            invalidateDisplayList();
         }
      }
      
      public function set data(param1:Object) : void
      {
         var _loc2_:Player = param1 as Player;
         if(_loc2_ != null)
         {
            this.m_Player = _loc2_;
            return;
         }
         throw new ArgumentError("UnjustPointsBarRenderer: Invalid type for data");
      }
      
      private function drawCreatureFlag(param1:Graphics, param2:BitmapData, param3:Rectangle, param4:Point) : void
      {
         s_Trans.a = 1;
         s_Trans.d = 1;
         s_Trans.tx = -param3.x + param4.x;
         s_Trans.ty = -param3.y + param4.y;
         param1.beginBitmapFill(param2,s_Trans,false,false);
         param1.drawRect(param4.x,param4.y,param3.width,param3.height);
      }
      
      private function getCurrentPkFlag() : int
      {
         return PK_NONE;
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         var _loc3_:EdgeMetrics = null;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:BitmapData = null;
         var _loc11_:BitmapData = null;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:int = 0;
         var _loc15_:int = 0;
         var _loc16_:int = 0;
         super.updateDisplayList(param1,param2);
         graphics.clear();
         graphics.beginFill(65280,0);
         graphics.drawRect(0,0,param1,param2);
         graphics.endFill();
         if(this.m_Player != null)
         {
            _loc3_ = this.viewMetricsAndPadding;
            _loc4_ = _loc3_.left;
            _loc5_ = _loc3_.top;
            _loc6_ = getStyle("horizontalGap");
            _loc7_ = getStyle("verticalGap");
            _loc8_ = param1 - (_loc4_ + _loc3_.right);
            _loc9_ = param2 - (_loc3_.top + _loc3_.bottom);
            _loc10_ = CreatureStorage.s_GetPKFlag(this.getCurrentPkFlag(),s_Rect);
            s_Point.x = _loc4_;
            s_Point.y = _loc5_;
            this.drawCreatureFlag(graphics,_loc10_,s_Rect,s_Point);
            _loc11_ = CreatureStorage.s_GetPKFlag(this.getNextPkFlag(),s_Rect);
            s_Point.x = _loc8_ - s_Rect.width - _loc3_.right;
            s_Point.y = _loc5_;
            this.drawCreatureFlag(graphics,_loc11_,s_Rect,s_Point);
            s_Rect.x = _loc4_ + getStyle("pointbarLeft");
            s_Rect.y = _loc5_ + getStyle("pointbarTop");
            s_Rect.width = getStyle("pointbarWidth");
            s_Rect.height = getStyle("pointbarHeight");
            _loc12_ = this.maximumValue > 0?Number((this.value - this.minimumValue) / (this.maximumValue - this.minimumValue)):Number(1);
            graphics.beginBitmapFill(this.m_BarColor);
            graphics.drawRect(s_Rect.x,s_Rect.y,Math.max(0,s_Rect.width * _loc12_),s_Rect.height);
            _loc13_ = s_Rect.width / (this.m_MarkCount + 1);
            graphics.beginFill(0,1);
            _loc14_ = 1;
            while(_loc14_ <= this.m_MarkCount)
            {
               _loc15_ = s_Rect.x + _loc14_ * _loc13_ - 1;
               _loc16_ = s_Rect.y;
               graphics.drawRect(_loc15_,_loc16_,1,s_Rect.height);
               _loc14_++;
            }
         }
         graphics.endFill();
      }
      
      public function get value() : Number
      {
         return this.m_CurrentValue;
      }
      
      public function get viewMetricsAndPadding() : EdgeMetrics
      {
         return new EdgeMetrics(getStyle("paddingLeft"),getStyle("paddingTop"),getStyle("paddingRight"),getStyle("paddingBottom"));
      }
   }
}
