package tibia.creatures.unjustPointsWidgetClasses
{
   import tibia.sidebar.sideBarWidgetClasses.WidgetView;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.display.BitmapData;
   import flash.display.Bitmap;
   import mx.controls.Image;
   import mx.controls.Label;
   import tibia.creatures.CreatureStorage;
   import shared.utility.StringHelper;
   import mx.utils.StringUtil;
   import tibia.creatures.UnjustPointsInfo;
   import tibia.creatures.Player;
   import mx.containers.HBox;
   import mx.core.EdgeMetrics;
   import mx.events.PropertyChangeEvent;
   import tibia.§sidebar:ns_sidebar_internal§.widgetClosed;
   import tibia.§sidebar:ns_sidebar_internal§.widgetCollapsed;
   import mx.core.ScrollPolicy;
   
   public class UnjustPointsWidgetView extends WidgetView
   {
      
      protected static const BLESSING_SPARK_OF_PHOENIX:int = BLESSING_WISDOM_OF_SOLITUDE << 1;
      
      protected static const PARTY_LEADER_SEXP_ACTIVE:int = 6;
      
      protected static const PARTY_MAX_FLASHING_TIME:uint = 5000;
      
      protected static const STATE_PZ_BLOCK:int = 13;
      
      protected static const PARTY_MEMBER_SEXP_ACTIVE:int = 5;
      
      private static const SKULL_DISPLAY_POINT:Point = new Point(8,25);
      
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
      
      private static const OPEN_SITUATIONS_POINT:Point = new Point(3,10);
      
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
      
      private static const WIDGET_VIEW_WIDTH:Number = 176;
      
      protected static const SKILL_HITPOINTS_PERCENT:int = 3;
      
      protected static const STATE_BLEEDING:int = 15;
      
      protected static const PK_PLAYERKILLER:int = 4;
      
      protected static const PROFESSION_MASK_KNIGHT:int = 1 << PROFESSION_KNIGHT;
      
      protected static const STATE_DAZZLED:int = 10;
      
      protected static const SUMMON_OTHERS:int = 2;
      
      protected static const SKILL_NONE:int = -1;
      
      protected static const NPC_SPEECH_TRADER:uint = 2;
      
      private static const BUNDLE:String = "UnjustPointsWidget";
      
      protected static const GUILD_MEMBER:int = 4;
      
      protected static const PROFESSION_NONE:int = 0;
      
      private static const WIDGET_VIEW_HEIGHT:Number = 52;
      
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
       
      
      private var m_UIOpenSituationLabel:Label;
      
      private var m_Player:Player = null;
      
      private var m_UncommitedSkullDisplay:Boolean = false;
      
      private var m_UIConstructed:Boolean = false;
      
      private var m_UncommitedUnjustPointsUpdate:Boolean = false;
      
      private var m_UISkullBox:HBox;
      
      private var m_BarRenderers:Array;
      
      private var m_UncommitedOpenPvpSituations:Boolean = false;
      
      public function UnjustPointsWidgetView()
      {
         this.m_BarRenderers = [{
            "mode":UnjustPointsBarRenderer.SCALE_DAY,
            "toolTip":"TOOLTIP_UNJUST_POINTS_24H",
            "marks":0,
            "left":57,
            "top":2,
            "width":121,
            "height":15,
            "renderer":null
         },{
            "mode":UnjustPointsBarRenderer.SCALE_WEEK,
            "toolTip":"TOOLTIP_UNJUST_POINTS_7D",
            "marks":0,
            "left":57,
            "top":19,
            "width":121,
            "height":15,
            "renderer":null
         },{
            "mode":UnjustPointsBarRenderer.SCALE_MONTH,
            "toolTip":"TOOLTIP_UNJUST_POINTS_30D",
            "marks":0,
            "left":57,
            "top":36,
            "width":121,
            "height":15,
            "renderer":null
         }];
         super();
         titleText = resourceManager.getString(BUNDLE,"TITLE");
         verticalScrollPolicy = ScrollPolicy.OFF;
         horizontalScrollPolicy = ScrollPolicy.OFF;
         this.m_Player = Tibia.s_GetCreatureStorage().player;
         if(this.m_Player != null)
         {
            this.m_Player.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onPlayerPropertyChange);
            return;
         }
         throw new Error("UnjustPointsWidgetView: Player is null");
      }
      
      private function createSkullDisplay() : void
      {
         var _loc1_:Rectangle = null;
         var _loc2_:BitmapData = null;
         var _loc3_:BitmapData = null;
         var _loc4_:Bitmap = null;
         var _loc5_:Image = null;
         var _loc6_:Label = null;
         var _loc7_:String = null;
         this.m_UISkullBox.removeAllChildren();
         if(this.m_Player.pkFlag == PK_PLAYERKILLER || this.m_Player.pkFlag == PK_EXCPLAYERKILLER)
         {
            _loc1_ = new Rectangle();
            _loc2_ = CreatureStorage.s_GetPKFlag(this.m_Player.pkFlag,_loc1_);
            _loc3_ = new BitmapData(_loc1_.width,_loc1_.height);
            _loc3_.copyPixels(_loc2_,_loc1_,new Point(0,0));
            _loc4_ = new Bitmap(_loc3_);
            _loc5_ = new Image();
            _loc5_.source = _loc4_;
            _loc5_.toolTip = resourceManager.getString(BUNDLE,"TOOLTIP_REMAINING_SKULLS");
            _loc6_ = new Label();
            _loc7_ = StringHelper.s_PadWithChars(new String(this.m_Player.unjustPoints.skullDuration),"  ");
            _loc6_.text = StringUtil.substitute(resourceManager.getString(BUNDLE,"LABEL_REMAINING_SKULLS"),_loc7_);
            _loc6_.toolTip = resourceManager.getString(BUNDLE,"TOOLTIP_REMAINING_SKULLS");
            this.m_UISkullBox.addChild(_loc5_);
            this.m_UISkullBox.addChild(_loc6_);
         }
      }
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
         if(this.m_UncommitedSkullDisplay)
         {
            this.createSkullDisplay();
            this.m_UncommitedSkullDisplay = false;
         }
         if(this.m_UncommitedOpenPvpSituations)
         {
            this.updateOpenPvPSituations();
            this.m_UncommitedOpenPvpSituations = false;
         }
         if(this.m_UncommitedUnjustPointsUpdate)
         {
            this.updateBarValues(this.m_Player.unjustPoints);
            this.m_UncommitedUnjustPointsUpdate = false;
         }
      }
      
      private function updateBarValues(param1:UnjustPointsInfo) : void
      {
         if(this.m_BarRenderers[0] != null)
         {
            this.m_BarRenderers[0].renderer.value = param1.progressDay;
            this.m_BarRenderers[0].renderer.barColor = UnjustPointsBarRenderer.getBarColorForRemainingKills(param1.killsRemainingDay);
            this.m_BarRenderers[0].renderer.toolTip = StringUtil.substitute(resourceManager.getString(BUNDLE,this.m_BarRenderers[0].toolTip),param1.killsRemainingDay,param1.killsRemainingDay != 1?"s":"");
         }
         if(this.m_BarRenderers[1] != null)
         {
            this.m_BarRenderers[1].renderer.value = param1.progressWeek;
            this.m_BarRenderers[1].renderer.barColor = UnjustPointsBarRenderer.getBarColorForRemainingKills(param1.killsRemainingWeek);
            this.m_BarRenderers[1].renderer.toolTip = StringUtil.substitute(resourceManager.getString(BUNDLE,this.m_BarRenderers[1].toolTip),param1.killsRemainingWeek,param1.killsRemainingWeek != 1?"s":"");
         }
         if(this.m_BarRenderers[2] != null)
         {
            this.m_BarRenderers[2].renderer.value = param1.progressMonth;
            this.m_BarRenderers[2].renderer.barColor = UnjustPointsBarRenderer.getBarColorForRemainingKills(param1.killsRemainingMonth);
            this.m_BarRenderers[2].renderer.toolTip = StringUtil.substitute(resourceManager.getString(BUNDLE,this.m_BarRenderers[2].toolTip),param1.killsRemainingMonth,param1.killsRemainingMonth != 1?"s":"");
         }
      }
      
      override protected function createChildren() : void
      {
         if(!this.m_UIConstructed)
         {
            super.createChildren();
            this.m_UISkullBox = new HBox();
            this.m_UISkullBox.setStyle("verticalAlign","middle");
            this.createProgressBars();
            this.m_UIConstructed = true;
         }
      }
      
      override protected function measure() : void
      {
         var _loc1_:EdgeMetrics = null;
         super.measure();
         _loc1_ = viewMetricsAndPadding;
         measuredMinWidth = measuredWidth = _loc1_.left + WIDGET_VIEW_WIDTH + _loc1_.right;
         measuredMinHeight = measuredHeight = _loc1_.top + WIDGET_VIEW_HEIGHT + _loc1_.bottom;
      }
      
      private function onPlayerPropertyChange(param1:PropertyChangeEvent) : void
      {
         if(param1.property == "pkFlag")
         {
            this.m_UncommitedSkullDisplay = true;
            invalidateProperties();
         }
         else if(param1.property == "openPvpSituations")
         {
            this.m_UncommitedOpenPvpSituations = true;
            invalidateProperties();
         }
         else if(param1.property == "unjustPoints")
         {
            this.m_UncommitedUnjustPointsUpdate = true;
            this.m_UncommitedSkullDisplay = true;
            invalidateProperties();
         }
      }
      
      private function createProgressBars() : void
      {
         var _loc3_:UnjustPointsBarRenderer = null;
         var _loc1_:EdgeMetrics = viewMetricsAndPadding;
         this.m_UIOpenSituationLabel = new Label();
         this.m_UIOpenSituationLabel.toolTip = resourceManager.getString(BUNDLE,"TOOLTIP_OPEN_SITUATIONS");
         this.updateOpenPvPSituations();
         rawChildren.addChild(this.m_UIOpenSituationLabel);
         this.m_UIOpenSituationLabel.visible = true;
         this.m_UIOpenSituationLabel.move(_loc1_.left + OPEN_SITUATIONS_POINT.x,_loc1_.top + OPEN_SITUATIONS_POINT.y);
         this.m_UIOpenSituationLabel.setActualSize(100,15);
         rawChildren.addChild(this.m_UISkullBox);
         this.m_UISkullBox.visible = true;
         this.m_UISkullBox.move(_loc1_.left + SKULL_DISPLAY_POINT.x,_loc1_.top + SKULL_DISPLAY_POINT.y);
         this.m_UISkullBox.setActualSize(100,15);
         this.createSkullDisplay();
         var _loc2_:int = 0;
         while(_loc2_ < this.m_BarRenderers.length)
         {
            _loc3_ = new UnjustPointsBarRenderer();
            _loc3_.marks = this.m_BarRenderers[_loc2_].marks;
            _loc3_.data = this.m_Player;
            this.m_BarRenderers[_loc2_].renderer = _loc3_;
            rawChildren.addChild(_loc3_);
            _loc3_.visible = true;
            _loc3_.move(_loc1_.left + this.m_BarRenderers[_loc2_].left,_loc1_.top + this.m_BarRenderers[_loc2_].top);
            _loc3_.setActualSize(this.m_BarRenderers[_loc2_].width,this.m_BarRenderers[_loc2_].height);
            _loc2_++;
         }
         this.updateBarValues(this.m_Player.unjustPoints);
      }
      
      private function updateOpenPvPSituations() : void
      {
         var _loc1_:String = StringHelper.s_PadWithChars(new String(this.m_Player.openPvpSituations),"  ");
         this.m_UIOpenSituationLabel.text = StringUtil.substitute(resourceManager.getString(BUNDLE,"LABEL_OPEN_SITUATIONS"),_loc1_);
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         super.updateDisplayList(param1,param2);
         var _loc3_:* = !(widgetClosed || widgetCollapsed);
         this.m_UIOpenSituationLabel.visible = _loc3_;
         this.m_UISkullBox.visible = _loc3_;
         var _loc4_:int = 0;
         while(_loc4_ < this.m_BarRenderers.length)
         {
            if(this.m_BarRenderers[_loc4_].renderer != null)
            {
               this.m_BarRenderers[_loc4_].renderer.visible = _loc3_;
            }
            _loc4_++;
         }
      }
      
      override function releaseInstance() : void
      {
         super.releaseInstance();
         if(this.m_Player != null)
         {
            this.m_Player.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onPlayerPropertyChange);
         }
      }
   }
}
