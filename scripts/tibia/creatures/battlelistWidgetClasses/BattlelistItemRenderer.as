package tibia.creatures.battlelistWidgetClasses
{
   import flash.display.BitmapData;
   import flash.display.Graphics;
   import flash.events.TimerEvent;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import mx.controls.listClasses.IListItemRenderer;
   import mx.core.EdgeMetrics;
   import mx.core.EventPriority;
   import mx.core.IDataRenderer;
   import mx.core.UIComponent;
   import mx.events.PropertyChangeEvent;
   import mx.styles.CSSStyleDeclaration;
   import mx.styles.StyleManager;
   import shared.utility.Colour;
   import shared.utility.TextFieldCache;
   import tibia.appearances.AppearanceInstance;
   import tibia.appearances.FrameGroup;
   import tibia.appearances.Marks;
   import tibia.appearances.OutfitInstance;
   import tibia.appearances.widgetClasses.CachedSpriteInformation;
   import tibia.appearances.widgetClasses.MarksView;
   import tibia.creatures.Creature;
   import tibia.creatures.CreatureStorage;
   import tibia.§creatures:ns_creature_internal§.s_BattlelistMarksView;
   import tibia.§creatures:ns_creature_internal§.s_InitialiseMarksView;
   import tibia.§creatures:ns_creature_internal§.s_NameCache;
   import tibia.§creatures:ns_creature_internal§.s_Point;
   import tibia.§creatures:ns_creature_internal§.s_Rect;
   import tibia.§creatures:ns_creature_internal§.s_Trans;
   
   public class BattlelistItemRenderer extends UIComponent implements IListItemRenderer, IDataRenderer
   {
      
      protected static const BLESSING_SPARK_OF_PHOENIX:int = BLESSING_WISDOM_OF_SOLITUDE << 1;
      
      protected static const PARTY_LEADER_SEXP_ACTIVE:int = 6;
      
      protected static const PARTY_MAX_FLASHING_TIME:uint = 5000;
      
      public static const CREATURE_ICON_SIZE:int = 24;
      
      protected static const RENDERER_DEFAULT_HEIGHT:Number = MAP_WIDTH * FIELD_SIZE;
      
      protected static const STATE_PZ_BLOCK:int = 13;
      
      protected static const PARTY_MEMBER_SEXP_ACTIVE:int = 5;
      
      protected static const PK_REVENGE:int = 6;
      
      private static const s_TempHealthColor:Colour = new Colour(0,0,0);
      
      protected static const SKILL_FIGHTCLUB:int = 10;
      
      protected static const NPC_SPEECH_TRAVEL:uint = 5;
      
      protected static const RISKINESS_DANGEROUS:int = 1;
      
      protected static const NUM_PVP_HELPERS_FOR_RISKINESS_DANGEROUS:uint = 5;
      
      protected static const PK_PARTYMODE:int = 2;
      
      protected static const RISKINESS_NONE:int = 0;
      
      protected static const GUILD_NONE:int = 0;
      
      protected static const FIELD_HEIGHT:int = 24;
      
      protected static const PARTY_MEMBER:int = 2;
      
      protected static const STATE_DRUNK:int = 3;
      
      protected static const PARTY_OTHER:int = 11;
      
      protected static const SKILL_EXPERIENCE:int = 0;
      
      protected static const ONSCREEN_MESSAGE_HEIGHT:int = 195;
      
      protected static const TYPE_NPC:int = 2;
      
      protected static const BLESSING_FIRE_OF_SUNS:int = BLESSING_SPARK_OF_PHOENIX << 1;
      
      protected static const SKILL_STAMINA:int = 17;
      
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
      
      static var s_Rect:Rectangle = new Rectangle();
      
      protected static const FIELD_ENTER_POSSIBLE_NO_ANIMATION:uint = 1;
      
      protected static const SKILL_HITPOINTS_PERCENT:int = 3;
      
      protected static const STATE_BLEEDING:int = 15;
      
      protected static const PK_PLAYERKILLER:int = 4;
      
      protected static const GROUND_LAYER:int = 7;
      
      protected static const PROFESSION_MASK_KNIGHT:int = 1 << PROFESSION_KNIGHT;
      
      protected static const STATE_DAZZLED:int = 10;
      
      protected static const SUMMON_OTHERS:int = 2;
      
      protected static const SKILL_NONE:int = -1;
      
      static var s_BattlelistMarksView:MarksView = null;
      
      protected static const NPC_SPEECH_TRADER:uint = 2;
      
      protected static const GUILD_MEMBER:int = 4;
      
      protected static const PROFESSION_NONE:int = 0;
      
      protected static const BLESSING_BLOOD_OF_THE_MOUNTAIN:int = BLESSING_HEART_OF_THE_MOUNTAIN << 1;
      
      protected static const MAX_NAME_LENGTH:int = 29;
      
      protected static const PARTY_LEADER:int = 1;
      
      static var s_Point:Point = new Point();
      
      public static const HEIGHT_HINT:int = 28;
      
      protected static const SKILL_CARRYSTRENGTH:int = 7;
      
      protected static const STATE_PZ_ENTERED:int = 14;
      
      protected static const PK_ATTACKER:int = 1;
      
      protected static const STATE_ELECTRIFIED:int = 2;
      
      protected static const SKILL_FIGHTSWORD:int = 11;
      
      protected static const GUILD_WAR_NEUTRAL:int = 3;
      
      protected static const STATE_DROWNING:int = 8;
      
      protected static const MAP_MIN_Y:int = 24576;
      
      protected static const MAP_MIN_Z:int = 0;
      
      static var s_NameCache:TextFieldCache = new TextFieldCache(192,TextFieldCache.DEFAULT_HEIGHT,NUM_CREATURES,true);
      
      protected static const MAP_MIN_X:int = 24576;
      
      protected static const BLESSING_HEART_OF_THE_MOUNTAIN:int = BLESSING_EMBRACE_OF_TIBIA << 1;
      
      protected static const SKILL_LIFE_LEECH_AMOUNT:int = 22;
      
      protected static const RENDERER_MIN_WIDTH:Number = Math.round(MAP_WIDTH * 2 / 3 * FIELD_SIZE);
      
      protected static const RENDERER_MIN_HEIGHT:Number = Math.round(MAP_HEIGHT * 2 / 3 * FIELD_SIZE);
      
      protected static const MAP_WIDTH:int = 15;
      
      protected static const PARTY_MEMBER_SEXP_OFF:int = 3;
      
      private static var s_ZeroPoint:Point = new Point(0,0);
      
      protected static const PROFESSION_MASK_DRUID:int = 1 << PROFESSION_DRUID;
      
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
      
      protected static const UNDERGROUND_LAYER:int = 2;
      
      protected static const BLESSING_WISDOM_OF_SOLITUDE:int = BLESSING_TWIST_OF_FATE << 1;
      
      protected static const FIELD_CACHESIZE:int = FIELD_SIZE;
      
      protected static const PROFESSION_PALADIN:int = 2;
      
      protected static const PLAYER_OFFSET_X:int = 8;
      
      protected static const SKILL_FIGHTAXE:int = 12;
      
      protected static const SKILL_CRITICAL_HIT_DAMAGE:int = 20;
      
      protected static const PLAYER_OFFSET_Y:int = 6;
      
      protected static const PARTY_LEADER_SEXP_OFF:int = 4;
      
      protected static const MAP_MAX_X:int = MAP_MIN_X + (1 << 14 - 1);
      
      protected static const MAP_MAX_Y:int = MAP_MIN_Y + (1 << 14 - 1);
      
      protected static const MAP_MAX_Z:int = 15;
      
      protected static const SKILL_SOULPOINTS:int = 16;
      
      protected static const NUM_ONSCREEN_MESSAGES:int = 16;
      
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
      
      protected static const MAP_HEIGHT:int = 11;
      
      protected static const PROFESSION_MASK_PALADIN:int = 1 << PROFESSION_PALADIN;
      
      protected static const RENDERER_DEFAULT_WIDTH:Number = MAP_WIDTH * FIELD_SIZE;
      
      protected static const STATE_CURSED:int = 11;
      
      protected static const BLESSING_ADVENTURER:int = 1;
      
      protected static const STATE_FREEZING:int = 9;
      
      protected static const PARTY_LEADER_SEXP_INACTIVE_INNOCENT:int = 10;
      
      protected static const NUM_FIELDS:int = MAPSIZE_Z * MAPSIZE_Y * MAPSIZE_X;
      
      protected static const STATE_POISONED:int = 0;
      
      protected static const SKILL_LIFE_LEECH_CHANCE:int = 21;
      
      protected static const TYPE_MONSTER:int = 1;
      
      static var s_Trans:Matrix = new Matrix(1,0,0,1);
      
      protected static const STATE_BURNING:int = 1;
      
      protected static const SKILL_FIGHTFIST:int = 13;
      
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
      
      protected static const MAPSIZE_W:int = 10;
      
      protected static const BLESSING_SPIRITUAL_SHIELDING:int = BLESSING_FIRE_OF_SUNS << 1;
      
      protected static const NPC_SPEECH_NONE:uint = 0;
      
      protected static const PK_MAX_FLASHING_TIME:uint = 5000;
      
      protected static const SKILL_GOSTRENGTH:int = 6;
      
      {
         s_InitialiseStyle();
         s_InitialiseMarksView(true);
      }
      
      private var m_InvalidHaveTimer:Boolean = false;
      
      protected var m_HaveTimer:Boolean = false;
      
      private var m_LocalAppearanceBitmapCache:BitmapData = null;
      
      protected var m_Data:Creature = null;
      
      private var m_UncommittedData:Boolean = false;
      
      public function BattlelistItemRenderer()
      {
         super();
      }
      
      static function s_InitialiseMarksView(param1:Boolean) : void
      {
         s_BattlelistMarksView = new MarksView(4);
         s_BattlelistMarksView.addMarkToView(Marks.MARK_TYPE_CLIENT_BATTLELIST,MarksView.MARK_THICKNESS_THIN);
         if(param1)
         {
            s_BattlelistMarksView.addMarkToView(Marks.MARK_TYPE_PERMANENT,MarksView.MARK_THICKNESS_THIN);
         }
      }
      
      private static function s_InitialiseStyle() : void
      {
         var Selector:String = "BattlelistItemRenderer";
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
            this.healthbarHeight = 5;
            this.healthbarWidth = 50;
         };
         StyleManager.setStyleDeclaration(Selector,Decl,true);
      }
      
      override protected function commitProperties() : void
      {
         var _loc1_:Boolean = false;
         if(this.m_UncommittedData)
         {
            toolTip = this.m_Data != null?this.m_Data.name:null;
            this.m_UncommittedData = false;
         }
         if(this.m_InvalidHaveTimer)
         {
            _loc1_ = this.m_Data != null && (this.m_Data.partyFlag != PARTY_NONE || this.m_Data.pkFlag != PK_NONE || this.m_Data.guildFlag != GUILD_NONE || this.m_Data.riskinessFlag != RISKINESS_NONE || this.m_Data.summonFlag != SUMMON_NONE);
            if(_loc1_ && !this.m_HaveTimer)
            {
               Tibia.s_GetSecondaryTimer().addEventListener(TimerEvent.TIMER,this.onTimer);
            }
            else if(!_loc1_ && this.m_HaveTimer)
            {
               Tibia.s_GetSecondaryTimer().removeEventListener(TimerEvent.TIMER,this.onTimer);
            }
            this.m_HaveTimer = _loc1_;
            this.m_InvalidHaveTimer = false;
         }
         super.commitProperties();
      }
      
      protected function invalidateTimer() : void
      {
         this.m_InvalidHaveTimer = true;
         invalidateProperties();
      }
      
      override public function styleChanged(param1:String) : void
      {
         if(param1 == "healthbarHeight" || param1 == "healthbarWidth")
         {
            invalidateSize();
         }
         else
         {
            super.styleChanged(param1);
         }
      }
      
      public function set data(param1:Object) : void
      {
         if(param1 == this.m_Data)
         {
            return;
         }
         if(this.m_Data != null)
         {
            this.m_Data.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onDataChange);
         }
         this.m_Data = param1 as Creature;
         this.m_UncommittedData = true;
         invalidateDisplayList();
         invalidateProperties();
         this.invalidateTimer();
         if(this.m_Data != null)
         {
            this.m_Data.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onDataChange,false,EventPriority.DEFAULT,true);
         }
      }
      
      override protected function measure() : void
      {
         var _loc3_:Number = NaN;
         super.measure();
         var _loc1_:EdgeMetrics = this.viewMetricsAndPadding;
         var _loc2_:Number = CREATURE_ICON_SIZE + getStyle("horizontalGap") + Math.max(CreatureStorage.STATE_FLAG_SIZE,s_NameCache.slotWidth,getStyle("healthbarWidth"));
         _loc3_ = Math.max(CREATURE_ICON_SIZE,Math.max(CreatureStorage.STATE_FLAG_SIZE,s_NameCache.slotHeight) + getStyle("verticalGap") + getStyle("healthbarHeight"));
         measuredMinWidth = measuredWidth = _loc1_.left + _loc2_ + _loc1_.right;
         measuredMinHeight = measuredHeight = _loc1_.top + _loc3_ + _loc1_.bottom;
      }
      
      private function onTimer(param1:TimerEvent) : void
      {
         if(param1 != null)
         {
            invalidateDisplayList();
         }
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
      
      public function get data() : Object
      {
         return this.m_Data;
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
         var _loc11_:AppearanceInstance = null;
         var _loc12_:CachedSpriteInformation = null;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc15_:uint = 0;
         var _loc16_:Rectangle = null;
         var _loc17_:Number = NaN;
         var _loc18_:Number = NaN;
         var _loc19_:Number = NaN;
         var _loc20_:Number = NaN;
         var _loc21_:Number = NaN;
         var _loc22_:Number = NaN;
         super.updateDisplayList(param1,param2);
         graphics.clear();
         graphics.beginFill(65280,0);
         graphics.drawRect(0,0,param1,param2);
         graphics.endFill();
         if(this.m_Data != null)
         {
            _loc3_ = this.viewMetricsAndPadding;
            _loc4_ = _loc3_.left;
            _loc5_ = _loc3_.top;
            _loc6_ = getStyle("horizontalGap");
            _loc7_ = getStyle("verticalGap");
            _loc8_ = param1 - _loc4_ - _loc3_.right;
            _loc9_ = param2 - _loc3_.top - _loc3_.bottom;
            _loc10_ = null;
            if(this.m_Data.marks.areAnyMarksSet(Vector.<uint>([Marks.MARK_TYPE_CLIENT_BATTLELIST,Marks.MARK_TYPE_PERMANENT])))
            {
               _loc10_ = s_BattlelistMarksView.getMarksBitmap(this.m_Data.marks,s_Rect);
               s_Trans.a = 1;
               s_Trans.d = 1;
               s_Trans.tx = -(s_Rect.x + (s_Rect.width - CREATURE_ICON_SIZE) / 2) + _loc4_;
               s_Trans.ty = -(s_Rect.y + (s_Rect.height - CREATURE_ICON_SIZE) / 2) + _loc5_;
               graphics.beginBitmapFill(_loc10_,s_Trans,false,false);
               graphics.drawRect(_loc4_,_loc5_,CREATURE_ICON_SIZE,CREATURE_ICON_SIZE);
            }
            _loc11_ = this.m_Data.outfit;
            _loc12_ = null;
            if(_loc11_ != null && _loc11_.ID != OutfitInstance.INVISIBLE_OUTFIT_ID && _loc11_.type != null && (_loc12_ = _loc11_.getSprite(0,2,0,0)) != null)
            {
               if(_loc12_.cacheMiss)
               {
                  this.invalidateTimer();
               }
               if(this.m_LocalAppearanceBitmapCache == null || this.m_LocalAppearanceBitmapCache.width < _loc12_.rectangle.width || this.m_LocalAppearanceBitmapCache.height < _loc12_.rectangle.height)
               {
                  this.m_LocalAppearanceBitmapCache = new BitmapData(_loc12_.rectangle.width,_loc12_.rectangle.height);
               }
               this.m_LocalAppearanceBitmapCache.copyPixels(_loc12_.bitmapData,_loc12_.rectangle,s_ZeroPoint);
               s_Rect.setTo(0,0,_loc12_.rectangle.width,_loc12_.rectangle.height);
               _loc10_ = this.m_LocalAppearanceBitmapCache;
               _loc19_ = _loc11_.type.FrameGroups[FrameGroup.FRAME_GROUP_DEFAULT].exactSize;
               _loc20_ = Math.min(Math.ceil(Math.sqrt(_loc19_) * CREATURE_ICON_SIZE / Math.sqrt(2 * FIELD_SIZE)),CREATURE_ICON_SIZE);
               _loc21_ = _loc20_ / _loc19_;
               _loc22_ = CREATURE_ICON_SIZE - _loc20_;
               s_Trans.a = _loc21_;
               s_Trans.d = _loc21_;
               s_Trans.tx = (-s_Rect.right + _loc19_) * _loc21_ + _loc4_ + _loc22_;
               s_Trans.ty = (-s_Rect.bottom + _loc19_) * _loc21_ + _loc5_ + _loc22_;
               graphics.beginBitmapFill(_loc10_,s_Trans,false,false);
               graphics.drawRect(_loc4_ + _loc22_,_loc5_ + _loc22_,_loc20_,_loc20_);
               graphics.endFill();
            }
            _loc4_ = _loc4_ + (CREATURE_ICON_SIZE + _loc6_);
            _loc8_ = param1 - _loc4_ - _loc3_.right;
            _loc13_ = Math.floor(_loc8_);
            _loc14_ = Math.max(CreatureStorage.STATE_FLAG_SIZE,s_NameCache.slotHeight - 4);
            if(this.m_Data.isHuman && this.m_Data.pkFlag > PK_NONE)
            {
               _loc13_ = _loc13_ - CreatureStorage.STATE_FLAG_SIZE;
               _loc10_ = CreatureStorage.s_GetPKFlag(this.m_Data.pkFlag,s_Rect);
               s_Point.setTo(_loc4_ + _loc13_,_loc5_ + (_loc14_ - CreatureStorage.STATE_FLAG_SIZE) / 2);
               this.drawCreatureFlag(graphics,_loc10_,s_Rect,s_Point);
               _loc13_ = _loc13_ - _loc6_;
            }
            if(this.m_Data.isHuman && this.m_Data.partyFlag > PARTY_NONE)
            {
               _loc13_ = _loc13_ - CreatureStorage.STATE_FLAG_SIZE;
               _loc10_ = CreatureStorage.s_GetPartyFlag(this.m_Data.partyFlag,s_Rect);
               s_Point.setTo(_loc4_ + _loc13_,_loc5_ + (_loc14_ - CreatureStorage.STATE_FLAG_SIZE) / 2);
               this.drawCreatureFlag(graphics,_loc10_,s_Rect,s_Point);
               _loc13_ = _loc13_ - _loc6_;
            }
            if(this.m_Data.isHuman && this.m_Data.guildFlag > GUILD_NONE)
            {
               _loc13_ = _loc13_ - CreatureStorage.STATE_FLAG_SIZE;
               _loc10_ = CreatureStorage.s_GetGuildFlag(this.m_Data.guildFlag,s_Rect);
               s_Point.setTo(_loc4_ + _loc13_,_loc5_ + (_loc14_ - CreatureStorage.STATE_FLAG_SIZE) / 2);
               this.drawCreatureFlag(graphics,_loc10_,s_Rect,s_Point);
               _loc13_ = _loc13_ - _loc6_;
            }
            if(this.m_Data.isHuman && this.m_Data.riskinessFlag > RISKINESS_NONE)
            {
               _loc13_ = _loc13_ - CreatureStorage.STATE_FLAG_SIZE;
               _loc10_ = CreatureStorage.s_GetRiskinessFlag(this.m_Data.riskinessFlag,s_Rect);
               s_Point.setTo(_loc4_ + _loc13_,_loc5_ + (_loc14_ - CreatureStorage.STATE_FLAG_SIZE) / 2);
               this.drawCreatureFlag(graphics,_loc10_,s_Rect,s_Point);
               _loc13_ = _loc13_ - _loc6_;
            }
            if(this.m_Data.isSummon && this.m_Data.summonFlag > SUMMON_NONE)
            {
               _loc13_ = _loc13_ - CreatureStorage.STATE_FLAG_SIZE;
               _loc10_ = CreatureStorage.s_GetSummonFlag(this.m_Data.summonFlag,s_Rect);
               s_Point.setTo(_loc4_ + _loc13_,_loc5_ + (_loc14_ - CreatureStorage.STATE_FLAG_SIZE) / 2);
               this.drawCreatureFlag(graphics,_loc10_,s_Rect,s_Point);
               _loc13_ = _loc13_ - _loc6_;
            }
            _loc15_ = 0;
            switch(this.m_Data.marks.getMarkColor(Marks.MARK_TYPE_CLIENT_BATTLELIST))
            {
               case Marks.MARK_AIM:
                  _loc15_ = 16777215;
                  break;
               case Marks.MARK_AIM_ATTACK:
               case Marks.MARK_ATTACK:
                  _loc15_ = 16711680;
                  break;
               case Marks.MARK_AIM_FOLLOW:
               case Marks.MARK_FOLLOW:
                  _loc15_ = 65280;
                  break;
               default:
                  _loc15_ = getStyle("color");
            }
            _loc16_ = s_NameCache.getItem(this.m_Data.name + String(_loc15_) + String(_loc13_),this.m_Data.name,_loc15_,_loc13_);
            if(_loc16_ != null)
            {
               s_Trans.a = 1;
               s_Trans.d = 1;
               s_Trans.tx = -_loc16_.x + _loc4_;
               s_Trans.ty = -_loc16_.y + _loc5_ + (_loc14_ - (s_NameCache.slotHeight - 4)) / 2 - 2;
               graphics.beginBitmapFill(s_NameCache,s_Trans,false,false);
               graphics.drawRect(_loc4_,_loc5_ + (_loc14_ - (s_NameCache.slotHeight - 4)) / 2 - 2,_loc13_,s_NameCache.slotHeight);
            }
            _loc17_ = (_loc8_ - 2) * this.m_Data.hitpointsPercent / 100;
            _loc18_ = getStyle("healthbarHeight");
            graphics.beginFill(0,1);
            graphics.drawRect(_loc4_,param2 - _loc3_.bottom - _loc18_,_loc8_,_loc18_);
            s_TempHealthColor.ARGB = Creature.s_GetHealthColourARGB(this.m_Data.hitpointsPercent);
            graphics.beginFill(s_TempHealthColor.RGB,1);
            graphics.drawRect(_loc4_ + 1,param2 - _loc3_.bottom - _loc18_ + 1,_loc17_,_loc18_ - 2);
         }
         graphics.endFill();
      }
      
      public function get viewMetricsAndPadding() : EdgeMetrics
      {
         return new EdgeMetrics(getStyle("paddingLeft"),getStyle("paddingTop"),getStyle("paddingRight"),getStyle("paddingBottom"));
      }
      
      private function onDataChange(param1:PropertyChangeEvent) : void
      {
         if(param1.property == "partyFlag" || param1.property == "pkFlag" || param1.property == "guildFlag")
         {
            invalidateDisplayList();
            this.invalidateTimer();
         }
         else if(param1.property == "name" || param1.property == "outfit" || param1.property == "marks")
         {
            invalidateDisplayList();
         }
      }
   }
}
