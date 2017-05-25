package tibia.creatures.statusWidgetClasses
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.events.MouseEvent;
   import flash.filters.BitmapFilterQuality;
   import flash.filters.GlowFilter;
   import flash.geom.Matrix;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import mx.containers.HBox;
   import mx.core.IInvalidating;
   import mx.core.IToolTip;
   import mx.events.PropertyChangeEvent;
   import mx.events.ToolTipEvent;
   import mx.styles.CSSStyleDeclaration;
   import mx.styles.StyleManager;
   import shared.controls.CustomButton;
   import shared.controls.ShapeWrapper;
   import shared.utility.StringHelper;
   import shared.utility.cacheStyleInstance;
   import tibia.creatures.Player;
   import tibia.creatures.StatusWidget;
   import tibia.ingameshop.IngameShopManager;
   import tibia.ingameshop.IngameShopProduct;
   
   public class SkillProgressBar extends HBox
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
      
      protected static const SKILL_HITPOINTS_PERCENT:int = 3;
      
      protected static const STATE_BLEEDING:int = 15;
      
      protected static const PK_PLAYERKILLER:int = 4;
      
      protected static const PROFESSION_MASK_KNIGHT:int = 1 << PROFESSION_KNIGHT;
      
      private static const SKILL_OPTIONS:Array = [{
         "value":SKILL_CARRYSTRENGTH,
         "styleProp":null
      },{
         "value":SKILL_EXPERIENCE,
         "styleProp":null
      },{
         "value":SKILL_FED,
         "styleProp":null
      },{
         "value":SKILL_FIGHTAXE,
         "styleProp":"iconSkillFightAxe"
      },{
         "value":SKILL_FIGHTCLUB,
         "styleProp":"iconSkillFightClub"
      },{
         "value":SKILL_FIGHTDISTANCE,
         "styleProp":"iconSkillFightDistance"
      },{
         "value":SKILL_FIGHTFIST,
         "styleProp":"iconSkillFightFist"
      },{
         "value":SKILL_FIGHTSHIELD,
         "styleProp":"iconSkillFightShield"
      },{
         "value":SKILL_FIGHTSWORD,
         "styleProp":"iconSkillFightSword"
      },{
         "value":SKILL_FISHING,
         "styleProp":"iconSkillFishing"
      },{
         "value":SKILL_GOSTRENGTH,
         "styleProp":null
      },{
         "value":SKILL_HITPOINTS,
         "styleProp":null
      },{
         "value":SKILL_LEVEL,
         "styleProp":"iconSkillLevel"
      },{
         "value":SKILL_MAGLEVEL,
         "styleProp":"iconSkillMagLevel"
      },{
         "value":SKILL_MANA,
         "styleProp":null
      },{
         "value":SKILL_NONE,
         "styleProp":null
      },{
         "value":SKILL_OFFLINETRAINING,
         "styleProp":null
      },{
         "value":SKILL_SOULPOINTS,
         "styleProp":null
      },{
         "value":SKILL_STAMINA,
         "styleProp":null
      }];
      
      protected static const STATE_DAZZLED:int = 10;
      
      protected static const SUMMON_OTHERS:int = 2;
      
      protected static const SKILL_NONE:int = -1;
      
      protected static const NPC_SPEECH_TRADER:uint = 2;
      
      private static const BUNDLE:String = "StatusWidget";
      
      protected static const GUILD_MEMBER:int = 4;
      
      protected static const PROFESSION_NONE:int = 0;
      
      protected static const BLESSING_BLOOD_OF_THE_MOUNTAIN:int = BLESSING_HEART_OF_THE_MOUNTAIN << 1;
      
      protected static const MAX_NAME_LENGTH:int = 29;
      
      protected static const PARTY_LEADER:int = 1;
      
      protected static const SKILL_CARRYSTRENGTH:int = 7;
      
      protected static const STATE_PZ_ENTERED:int = 14;
      
      protected static const PK_ATTACKER:int = 1;
      
      protected static const STATE_ELECTRIFIED:int = 2;
      
      protected static const SKILL_FIGHTSWORD:int = 11;
      
      protected static const GUILD_WAR_NEUTRAL:int = 3;
      
      protected static const STATE_DROWNING:int = 8;
      
      protected static const BLESSING_HEART_OF_THE_MOUNTAIN:int = BLESSING_EMBRACE_OF_TIBIA << 1;
      
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
      
      protected static const PROFESSION_MASK_SORCERER:int = 1 << PROFESSION_SORCERER;
      
      protected static const PROFESSION_KNIGHT:int = 1;
      
      protected static const NPC_SPEECH_QUESTTRADER:uint = 4;
      
      protected static const PARTY_LEADER_SEXP_INACTIVE_GUILTY:int = 8;
      
      protected static const BLESSING_WISDOM_OF_SOLITUDE:int = BLESSING_TWIST_OF_FATE << 1;
      
      protected static const PROFESSION_PALADIN:int = 2;
      
      protected static const SKILL_FIGHTAXE:int = 12;
      
      protected static const SKILL_CRITICAL_HIT_DAMAGE:int = 20;
      
      protected static const PARTY_LEADER_SEXP_OFF:int = 4;
      
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
      
      protected static const BLESSING_SPIRITUAL_SHIELDING:int = BLESSING_FIRE_OF_SUNS << 1;
      
      protected static const NPC_SPEECH_NONE:uint = 0;
      
      protected static const PK_MAX_FLASHING_TIME:uint = 5000;
      
      protected static const SKILL_GOSTRENGTH:int = 6;
      
      {
         cacheStyleInstance(SKILL_OPTIONS,".statusWidgetIcons");
      }
      
      private var m_UncommittedSkill:Boolean = true;
      
      private var m_UILabelWrapper:ShapeWrapper = null;
      
      private var m_TextStyle:CSSStyleDeclaration = null;
      
      private var m_UncommittedSkillLabel:Boolean = false;
      
      private var m_SkillLabel:String = null;
      
      private var m_UncommittedCharacter:Boolean = false;
      
      private var m_TextField:TextField = null;
      
      private var m_Skill:int = -1;
      
      private var m_UIProgress:BitmapProgressBar = null;
      
      private var m_UILabel:Bitmap = null;
      
      private var m_Character:Player = null;
      
      private var m_UIBuyXpBoostButton:CustomButton = null;
      
      private var m_UIIcon:ShapeWrapper = null;
      
      public function SkillProgressBar()
      {
         super();
         toolTip = "toolTip";
         addEventListener(ToolTipEvent.TOOL_TIP_SHOW,this.onToolTip);
      }
      
      private function onToolTip(param1:ToolTipEvent) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:IToolTip = null;
         var _loc8_:int = 0;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         if(this.skill != SKILL_NONE && this.character != null)
         {
            _loc2_ = NaN;
            _loc3_ = NaN;
            _loc4_ = NaN;
            _loc5_ = null;
            _loc6_ = StatusWidget.s_GetSkillName(this.skill);
            _loc2_ = this.character.getSkillValue(this.skill);
            if(this.skill == SKILL_LEVEL)
            {
               _loc3_ = this.character.getSkillGain(SKILL_EXPERIENCE);
               _loc4_ = Player.s_GetExperienceForLevel(this.character.level + 1) - this.character.getSkillValue(SKILL_EXPERIENCE);
               _loc5_ = resourceManager.getString(BUNDLE,"TIP_SKILL_UNIT_EXPERIENCE");
            }
            else
            {
               _loc3_ = this.character.getSkillGain(this.skill);
               _loc4_ = 100 - this.character.getSkillProgress(this.skill);
               _loc5_ = resourceManager.getString(BUNDLE,"TIP_SKILL_UNIT_DEFAULT");
            }
            _loc4_ = Math.max(0,_loc4_);
            _loc7_ = param1.toolTip;
            if(_loc3_ > 0)
            {
               _loc9_ = Math.floor(_loc4_ * 60 / _loc3_);
               _loc10_ = Math.floor(_loc9_ / 60);
               _loc9_ = _loc9_ - _loc10_ * 60;
               _loc7_.text = resourceManager.getString(BUNDLE,"TIP_SKILL_TEXT_EXTENDED",[_loc6_,_loc2_,_loc4_,_loc5_,_loc3_,_loc10_,_loc9_]);
            }
            else
            {
               _loc7_.text = resourceManager.getString(BUNDLE,"TIP_SKILL_TEXT_SIMPLE",[_loc6_,_loc2_,_loc4_,_loc5_]);
            }
            _loc8_ = this.character.experienceGainInfo.computeXpGainModifier() * 100;
            if(this.skill == SKILL_LEVEL)
            {
               _loc7_.text = _loc7_.text + ("\n" + this.generateExperienceGainTooltip());
            }
            if(_loc7_ is IInvalidating)
            {
               IInvalidating(_loc7_).validateNow();
               _loc11_ = _loc7_.getExplicitOrMeasuredWidth();
               _loc12_ = _loc7_.getExplicitOrMeasuredHeight();
               _loc13_ = Math.max(0,Math.min(_loc7_.x,stage.stageWidth - _loc11_));
               _loc14_ = Math.max(0,Math.min(_loc7_.y,stage.stageHeight - _loc12_));
               _loc7_.move(_loc13_,_loc14_);
               _loc7_.setActualSize(_loc11_,_loc12_);
            }
         }
         else
         {
            param1.preventDefault();
            param1.stopImmediatePropagation();
         }
      }
      
      public function locationChanged(param1:int) : void
      {
         if(param1 == StatusWidget.LOCATION_LEFT || param1 == StatusWidget.LOCATION_RIGHT)
         {
            this.m_UIBuyXpBoostButton.label = "";
         }
         else
         {
            this.m_UIBuyXpBoostButton.label = resourceManager.getString(BUNDLE,"BTN_XPGAIN_BUY");
         }
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this.m_UIIcon = new ShapeWrapper();
         this.m_UIIcon.styleName = getStyle("iconStyleName");
         addChild(this.m_UIIcon);
         this.m_UILabel = new Bitmap();
         this.m_UILabelWrapper = new ShapeWrapper();
         this.m_UILabelWrapper.addChild(this.m_UILabel);
         addChild(this.m_UILabelWrapper);
         this.m_UIProgress = new BitmapProgressBar();
         this.m_UIProgress.labelEnabled = false;
         this.m_UIProgress.labelFormat = "{1}%";
         this.m_UIProgress.percentWidth = 100;
         this.m_UIProgress.styleName = getStyle("progressBarStyleName");
         this.m_UIProgress.tickValues = [25,50,75];
         addChild(this.m_UIProgress);
         this.m_UIBuyXpBoostButton = new CustomButton();
         this.m_UIBuyXpBoostButton.label = resourceManager.getString(BUNDLE,"BTN_XPGAIN_BUY");
         this.m_UIBuyXpBoostButton.labelPlacement = "right";
         this.m_UIBuyXpBoostButton.styleName = "buttonDialogOpenStoreButton";
         this.m_UIBuyXpBoostButton.toolTip = resourceManager.getString(BUNDLE,"TIP_XPGAIN_BUY_BUTTON");
         this.m_UIBuyXpBoostButton.addEventListener(MouseEvent.CLICK,this.onBuyXpBoostClicked);
         addChild(this.m_UIBuyXpBoostButton);
      }
      
      private function updateSkillLabel(param1:String) : void
      {
         var _loc5_:CSSStyleDeclaration = null;
         var _loc6_:Matrix = null;
         var _loc2_:Number = 33;
         var _loc3_:Number = 10;
         if(param1 != null)
         {
            if(this.m_TextField == null)
            {
               this.m_TextField = createInFontContext(TextField) as TextField;
               this.m_TextField.autoSize = TextFieldAutoSize.LEFT;
               this.m_TextField.filters = [new GlowFilter(0,1,2,2,4,BitmapFilterQuality.LOW,false,false)];
            }
            _loc5_ = StyleManager.getStyleDeclaration(getStyle("labelStyleName"));
            if(this.m_TextStyle != _loc5_)
            {
               this.m_TextStyle = _loc5_;
            }
            if(this.m_TextStyle != null)
            {
               this.m_TextField.defaultTextFormat = new TextFormat(this.m_TextStyle.getStyle("fontFamily"),this.m_TextStyle.getStyle("fontSize"),this.m_TextStyle.getStyle("fontColor"),this.m_TextStyle.getStyle("fontWeight") == "bold",this.m_TextStyle.getStyle("fontStyle") == "italic");
            }
            this.m_TextField.text = param1;
            _loc2_ = Math.max(33,Math.min(this.m_TextField.textWidth,66));
            _loc3_ = this.m_TextField.textHeight;
         }
         var _loc4_:BitmapData = this.m_UILabel.bitmapData;
         if(_loc4_ == null || _loc4_.width != _loc2_ || _loc4_.height != _loc3_)
         {
            _loc4_ = new BitmapData(_loc2_,_loc3_,true,65280);
            _loc4_.lock();
            this.m_UILabel.bitmapData = _loc4_;
            this.m_UILabelWrapper.invalidateSize();
         }
         else
         {
            _loc4_.lock();
            _loc4_.fillRect(new Rectangle(0,0,_loc4_.width,_loc4_.height),65280);
         }
         if(param1 != null)
         {
            _loc6_ = new Matrix(1,0,0,1,(_loc4_.width - this.m_TextField.textWidth) / 2 - 2,-2);
            _loc4_.draw(this.m_TextField,_loc6_);
         }
         _loc4_.unlock();
      }
      
      private function onXpBoostAvailabilityChange(param1:PropertyChangeEvent) : void
      {
         if(param1.property == "storeXpBoost")
         {
            this.updateBuyXpButtonEnabledState();
         }
      }
      
      public function get skill() : int
      {
         return this.m_Skill;
      }
      
      private function updateBuyXpButtonEnabledState() : void
      {
         if(this.m_Character != null)
         {
            this.m_UIBuyXpBoostButton.enabled = this.m_Character.experienceGainInfo.canCurrentlyBuyXpBoost && this.m_Character.experienceGainInfo.remaingStoreXpBoostSeconds == 0;
         }
         else
         {
            this.m_UIBuyXpBoostButton.enabled = false;
         }
      }
      
      public function set character(param1:Player) : void
      {
         if(this.m_Character != param1)
         {
            if(this.m_Character != null)
            {
               this.m_Character.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onCharacterChange);
               this.m_Character.experienceGainInfo.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onXpBoostAvailabilityChange);
            }
            this.m_Character = param1;
            this.m_UncommittedCharacter = true;
            invalidateProperties();
            if(this.m_Character != null)
            {
               this.m_Character.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onCharacterChange);
               this.m_Character.experienceGainInfo.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onXpBoostAvailabilityChange);
            }
         }
      }
      
      private function onCharacterChange(param1:PropertyChangeEvent) : void
      {
         if((param1.property == "skill" || param1.property == "xpGain" || param1.property == "*") && this.skill != SKILL_NONE)
         {
            this.skillLabel = String(this.character.getSkillValue(this.skill));
            this.m_UIProgress.value = this.character.getSkillProgress(this.skill);
            this.updateExperienceBarStyle();
         }
      }
      
      private function generateExperienceGainTooltip() : String
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc1_:String = resourceManager.getString(BUNDLE,"TIP_XPGAIN_BASE",[Math.floor(this.m_Character.experienceGainInfo.computeXpGainModifier() * 100).toFixed(0),Math.floor(this.m_Character.experienceGainInfo.baseXpGain * 100 + 0.5).toFixed(0)]);
         if(this.m_Character.experienceGainInfo.grindingAddend > 0)
         {
            _loc1_ = _loc1_ + resourceManager.getString(BUNDLE,"TIP_XPGAIN_GRINDING",[Math.floor(this.m_Character.experienceGainInfo.grindingAddend * 100 + 0.5).toFixed(0)]);
         }
         if(this.m_Character.experienceGainInfo.remaingStoreXpBoostSeconds > 0)
         {
            _loc2_ = this.m_Character.experienceGainInfo.remaingStoreXpBoostSeconds % 60;
            _loc3_ = this.m_Character.experienceGainInfo.remaingStoreXpBoostSeconds;
            if(_loc2_ > 0)
            {
               _loc3_ = _loc3_ + (60 - _loc2_);
            }
            if(this.m_Character.experienceGainInfo.storeBoostAddend > 0)
            {
               _loc1_ = _loc1_ + resourceManager.getString(BUNDLE,"TIP_XPGAIN_XPBOOST",[(this.m_Character.experienceGainInfo.storeBoostAddend * 100).toFixed(0),StringHelper.s_MillisecondsToTimeString(_loc3_ * 1000,false,true).substring(0,5)]);
            }
            else
            {
               _loc1_ = _loc1_ + resourceManager.getString(BUNDLE,"TIP_XPGAIN_XPBOOST_PAUSED",[Math.floor(this.m_Character.experienceGainInfo.storeBoostAddend * 100 + 0.5).toFixed(0)]);
            }
         }
         if(this.m_Character.experienceGainInfo.voucherAddend > 0)
         {
            _loc1_ = _loc1_ + resourceManager.getString(BUNDLE,"TIP_XPGAIN_VOUCHER",[Math.floor(this.m_Character.experienceGainInfo.voucherAddend * 100 + 0.5).toFixed(0)]);
         }
         if(this.m_Character.experienceGainInfo.huntingBoostFactor > 1)
         {
            _loc4_ = this.m_Character.getSkillValue(SKILL_STAMINA);
            _loc5_ = Math.max(0,Math.max(0,this.m_Character.getSkillValue(SKILL_STAMINA) - this.m_Character.getSkillBase(SKILL_STAMINA)) - 40 * 60 * 60 * 1000);
            _loc1_ = _loc1_ + resourceManager.getString(BUNDLE,"TIP_XPGAIN_HUNTINGBONUS",[this.m_Character.experienceGainInfo.huntingBoostFactor.toFixed(1),StringHelper.s_MillisecondsToTimeString(_loc5_,false,true).substring(0,5)]);
         }
         else if(this.m_Character.experienceGainInfo.huntingBoostFactor < 1)
         {
            _loc1_ = _loc1_ + resourceManager.getString(BUNDLE,"TIP_XPGAIN_HUNTINGMALUS",[this.m_Character.experienceGainInfo.huntingBoostFactor.toFixed(1)]);
         }
         return _loc1_;
      }
      
      protected function set skillLabel(param1:String) : void
      {
         if(this.m_SkillLabel != param1)
         {
            this.m_SkillLabel = param1;
            this.m_UncommittedSkillLabel = true;
            invalidateProperties();
         }
      }
      
      private function updateExperienceBarStyle() : void
      {
         if(this.m_UIProgress != null)
         {
            if(this.skill == SKILL_LEVEL)
            {
               if(this.m_Character != null && this.m_Character.experienceGainInfo.computeXpGainModifier() > 1)
               {
                  this.m_UIProgress.styleName = getStyle("progressBarBonusStyleName");
               }
               else if(this.m_Character != null && this.m_Character.experienceGainInfo.computeXpGainModifier() == 0)
               {
                  this.m_UIProgress.styleName = getStyle("progressBarZeroStyleName");
               }
               else if(this.m_Character != null && this.m_Character.experienceGainInfo.computeXpGainModifier() < 1)
               {
                  this.m_UIProgress.styleName = getStyle("progressBarMalusStyleName");
               }
               else
               {
                  this.m_UIProgress.styleName = getStyle("progressBarStyleName");
               }
            }
            else
            {
               this.m_UIProgress.styleName = getStyle("progressBarStyleName");
            }
         }
      }
      
      public function get progressDirection() : String
      {
         return this.m_UIProgress != null?this.m_UIProgress.direction:null;
      }
      
      public function set skill(param1:int) : void
      {
         var _loc3_:Object = null;
         var _loc2_:int = SKILL_NONE;
         for each(_loc3_ in SKILL_OPTIONS)
         {
            if(_loc3_.value === param1 && _loc3_.styleProp != null)
            {
               _loc2_ = param1;
               break;
            }
         }
         if(this.m_Skill != _loc2_)
         {
            this.m_Skill = _loc2_;
            this.m_UncommittedSkill = true;
            invalidateProperties();
         }
      }
      
      protected function get skillLabel() : String
      {
         return this.m_SkillLabel;
      }
      
      public function get character() : Player
      {
         return this.m_Character;
      }
      
      public function set progressDirection(param1:String) : void
      {
         if(this.m_UIProgress != null)
         {
            this.m_UIProgress.direction = param1;
         }
      }
      
      override protected function commitProperties() : void
      {
         var _loc1_:Object = null;
         super.commitProperties();
         if(this.m_UncommittedCharacter)
         {
            if(this.character != null && this.skill != SKILL_NONE)
            {
               this.skillLabel = String(this.character.getSkillValue(this.skill));
               this.m_UIProgress.value = this.character.getSkillProgress(this.skill);
            }
            this.updateBuyXpButtonEnabledState();
            this.m_UncommittedCharacter = false;
         }
         if(this.m_UncommittedSkill)
         {
            this.m_UIIcon.removeChildren();
            for each(_loc1_ in SKILL_OPTIONS)
            {
               if(_loc1_.value === this.skill && _loc1_.styleInstance is DisplayObject)
               {
                  this.m_UIIcon.addChild(_loc1_.styleInstance);
                  break;
               }
            }
            if(this.character != null && this.skill != SKILL_NONE)
            {
               includeInLayout = true;
               this.skillLabel = String(this.character.getSkillValue(this.skill));
               visible = true;
               this.m_UIProgress.value = this.character.getSkillProgress(this.skill);
            }
            else
            {
               includeInLayout = false;
               visible = false;
            }
            this.updateExperienceBarStyle();
            this.updateBuyXpButtonEnabledState();
            this.m_UncommittedSkill = false;
         }
         if(this.m_UncommittedSkillLabel)
         {
            this.updateSkillLabel(this.skillLabel);
            this.m_UncommittedSkillLabel = false;
         }
      }
      
      private function onBuyXpBoostClicked(param1:MouseEvent) : void
      {
         IngameShopManager.getInstance().openShopWindow(true,IngameShopProduct.SERVICE_TYPE_XPBOOST);
      }
      
      override public function set styleName(param1:Object) : void
      {
         super.styleName = param1;
         if(this.m_UIIcon != null)
         {
            this.m_UIIcon.styleName = getStyle("iconStyleName");
         }
         this.updateExperienceBarStyle();
         this.m_UncommittedSkillLabel = true;
         invalidateProperties();
      }
   }
}
