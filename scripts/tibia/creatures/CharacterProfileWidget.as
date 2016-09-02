package tibia.creatures
{
   import tibia.game.PopUpBase;
   import mx.controls.Label;
   import mx.events.PropertyChangeEvent;
   import mx.containers.HBox;
   import mx.containers.Form;
   import mx.containers.FormItem;
   
   public class CharacterProfileWidget extends PopUpBase
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
      
      public static const BUNDLE:String = "CharacterProfileWidget";
      
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
       
      
      private var m_UISkills:Array;
      
      private var m_UIProfession:Label = null;
      
      private var m_UIName:Label = null;
      
      private var m_UncommittedPlayer:Boolean = false;
      
      private var m_Player:tibia.creatures.Player = null;
      
      public function CharacterProfileWidget()
      {
         this.m_UISkills = [{
            "skill":SKILL_LEVEL,
            "label":"FORM_ITEM_LEVEL",
            "renderer":null,
            "leftSide":true
         },{
            "skill":SKILL_EXPERIENCE,
            "label":"FORM_ITEM_EXPERIENCE",
            "renderer":null,
            "leftSide":true
         },{
            "skill":SKILL_EXPERIENCE_GAIN,
            "label":"FORM_ITEM_EXPERIENCEGAIN",
            "renderer":null,
            "leftSide":true
         },{
            "skill":SKILL_HITPOINTS,
            "label":"FORM_ITEM_HITPOINTS",
            "renderer":null,
            "leftSide":true
         },{
            "skill":SKILL_MANA,
            "label":"FORM_ITEM_MANA",
            "renderer":null,
            "leftSide":true
         },{
            "skill":SKILL_CARRYSTRENGTH,
            "label":"FORM_ITEM_CARRYSTRENGTH",
            "renderer":null,
            "leftSide":true
         },{
            "skill":SKILL_SOULPOINTS,
            "label":"FORM_ITEM_SOULPOINTS",
            "renderer":null,
            "leftSide":true
         },{
            "skill":SKILL_STAMINA,
            "label":"FORM_ITEM_STAMINA",
            "renderer":null,
            "leftSide":true
         },{
            "skill":SKILL_OFFLINETRAINING,
            "label":"FORM_ITEM_OFFLINETRAINING",
            "renderer":null,
            "leftSide":true
         },{
            "skill":SKILL_GOSTRENGTH,
            "label":"FORM_ITEM_GOSTRENGTH",
            "renderer":null,
            "leftSide":true
         },{
            "skill":SKILL_FED,
            "label":"FORM_ITEM_FED",
            "renderer":null,
            "leftSide":true
         },{
            "skill":SKILL_MAGLEVEL,
            "label":"FORM_ITEM_MAGLEVEL",
            "renderer":null,
            "leftSide":false
         },{
            "skill":SKILL_FIGHTFIST,
            "label":"FORM_ITEM_FIGHTFIST",
            "renderer":null,
            "leftSide":false
         },{
            "skill":SKILL_FIGHTAXE,
            "label":"FORM_ITEM_FIGHTAXE",
            "renderer":null,
            "leftSide":false
         },{
            "skill":SKILL_FIGHTCLUB,
            "label":"FORM_ITEM_FIGHTCLUB",
            "renderer":null,
            "leftSide":false
         },{
            "skill":SKILL_FIGHTSWORD,
            "label":"FORM_ITEM_FIGHTSWORD",
            "renderer":null,
            "leftSide":false
         },{
            "skill":SKILL_FIGHTDISTANCE,
            "label":"FORM_ITEM_FIGHTDISTANCE",
            "renderer":null,
            "leftSide":false
         },{
            "skill":SKILL_FIGHTSHIELD,
            "label":"FORM_ITEM_FIGHTSHIELD",
            "renderer":null,
            "leftSide":false
         },{
            "skill":SKILL_FISHING,
            "label":"FORM_ITEM_FISHING",
            "renderer":null,
            "leftSide":false
         },{
            "skill":SKILL_CRITICAL_HIT_CHANCE,
            "label":"FORM_ITEM_CRITICAL_HIT_CHANCE",
            "renderer":null,
            "leftSide":false
         },{
            "skill":SKILL_CRITICAL_HIT_DAMAGE,
            "label":"FORM_ITEM_CRITICAL_HIT_DAMAGE",
            "renderer":null,
            "leftSide":false
         },{
            "skill":SKILL_LIFE_LEECH_CHANCE,
            "label":"FORM_ITEM_LIFE_LEECH_CHANCE",
            "renderer":null,
            "leftSide":false
         },{
            "skill":SKILL_LIFE_LEECH_AMOUNT,
            "label":"FORM_ITEM_LIFE_LEECH_AMOUNT",
            "renderer":null,
            "leftSide":false
         },{
            "skill":SKILL_MANA_LEECH_CHANCE,
            "label":"FORM_ITEM_MANA_LEECH_CHANCE",
            "renderer":null,
            "leftSide":false
         },{
            "skill":SKILL_MANA_LEECH_AMOUNT,
            "label":"FORM_ITEM_MANA_LEECH_AMOUNT",
            "renderer":null,
            "leftSide":false
         }];
         super();
         buttonFlags = PopUpBase.BUTTON_CLOSE;
         keyboardFlags = PopUpBase.KEY_ESCAPE;
         title = resourceManager.getString(BUNDLE,"TITLE");
         width = 570;
         this.player = Tibia.s_GetPlayer();
      }
      
      public function get player() : tibia.creatures.Player
      {
         return this.m_Player;
      }
      
      private function updateSkills() : void
      {
         var _loc2_:Object = null;
         var _loc1_:Label = null;
         for each(_loc2_ in this.m_UISkills)
         {
            if((_loc1_ = _loc2_.renderer as Label) != null)
            {
               if(_loc2_.skill != SKILL_EXPERIENCE_GAIN)
               {
                  _loc1_.htmlText = this.formatSkill(this.m_Player,_loc2_.skill);
               }
               else
               {
                  _loc1_.htmlText = (this.m_Player.experienceGainInfo.computeXpGainModifier() * 100).toFixed(0) + "%";
               }
            }
         }
      }
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
         if(this.m_UncommittedPlayer)
         {
            if(this.player != null)
            {
               this.m_UIName.htmlText = this.player.name;
               this.m_UIProfession.htmlText = this.formatProfession(this.player.profession);
            }
            else
            {
               this.m_UIName.htmlText = null;
               this.m_UIProfession.htmlText = null;
            }
            this.updateSkills();
            this.m_UncommittedPlayer = false;
         }
      }
      
      public function set player(param1:tibia.creatures.Player) : void
      {
         if(this.m_Player != param1)
         {
            if(this.m_Player != null)
            {
               this.m_Player.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onPlayerChange);
            }
            this.m_Player = param1;
            this.m_UncommittedPlayer = true;
            invalidateProperties();
            if(this.m_Player != null)
            {
               this.m_Player.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onPlayerChange);
            }
         }
      }
      
      private function formatProfession(param1:int) : String
      {
         var _loc2_:String = null;
         switch(param1)
         {
            case PROFESSION_DRUID:
               _loc2_ = "FORM_LABEL_PROFESSION_DRUID";
               break;
            case PROFESSION_KNIGHT:
               _loc2_ = "FORM_LABEL_PROFESSION_KNIGHT";
               break;
            case PROFESSION_PALADIN:
               _loc2_ = "FORM_LABEL_PROFESSION_PALADIN";
               break;
            case PROFESSION_SORCERER:
               _loc2_ = "FORM_LABEL_PROFESSION_SORCERER";
               break;
            case PROFESSION_NONE:
               _loc2_ = "FORM_LABEL_PROFESSION_NONE";
               break;
            default:
               return null;
         }
         return resourceManager.getString(BUNDLE,_loc2_);
      }
      
      private function onPlayerChange(param1:PropertyChangeEvent) : void
      {
         if(param1.property == "name")
         {
            this.m_UIName.htmlText = this.player.name;
         }
         else if(param1.property == "skill" || param1.property == "xpGain")
         {
            this.updateSkills();
         }
         else if(param1.property == "profession")
         {
            this.m_UIProfession.htmlText = this.formatProfession(this.player.profession);
         }
      }
      
      override protected function createChildren() : void
      {
         var _loc5_:Object = null;
         super.createChildren();
         var _loc1_:HBox = new HBox();
         _loc1_.percentHeight = 100;
         _loc1_.percentWidth = 100;
         _loc1_.setStyle("horizontalGap",2);
         addChild(_loc1_);
         var _loc2_:Form = new Form();
         _loc2_.percentHeight = 100;
         _loc2_.percentWidth = 50;
         var _loc3_:Form = new Form();
         _loc3_.percentHeight = 100;
         _loc3_.percentWidth = 50;
         this.m_UIName = new Label();
         this.m_UIName.setStyle("fontWeight","bold");
         var _loc4_:FormItem = new FormItem();
         _loc4_.label = resourceManager.getString(BUNDLE,"FORM_ITEM_NAME");
         _loc4_.addChild(this.m_UIName);
         _loc2_.addChild(_loc4_);
         this.m_UIProfession = new Label();
         this.m_UIProfession.setStyle("fontWeight","bold");
         _loc4_ = new FormItem();
         _loc4_.label = resourceManager.getString(BUNDLE,"FORM_ITEM_PROFESSION");
         _loc4_.addChild(this.m_UIProfession);
         _loc2_.addChild(_loc4_);
         for each(_loc5_ in this.m_UISkills)
         {
            if(_loc5_.renderer == null)
            {
               _loc5_.renderer = new Label();
               _loc5_.renderer.data = _loc5_.skill;
               _loc5_.renderer.setStyle("fontWeight","bold");
               _loc4_ = new FormItem();
               _loc4_.label = resourceManager.getString(BUNDLE,_loc5_.label);
               _loc4_.addChild(_loc5_.renderer);
               if(_loc5_.leftSide)
               {
                  _loc2_.addChild(_loc4_);
               }
               else
               {
                  _loc3_.addChild(_loc4_);
               }
            }
         }
         _loc1_.addChild(_loc2_);
         _loc1_.addChild(_loc3_);
      }
      
      private function formatSkill(param1:tibia.creatures.Player, param2:int) : String
      {
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         if(param1 != null)
         {
            _loc3_ = param1.getSkillValue(param2);
            _loc4_ = param1.getSkillBase(param2);
            _loc5_ = 0;
            _loc6_ = param1.getSkillProgress(param2);
            if(param2 == SKILL_STAMINA || param2 == SKILL_OFFLINETRAINING)
            {
               _loc3_ = Math.round(Math.max(0,_loc3_ - _loc4_) / (60 * 1000));
               return String("0" + Math.floor(_loc3_ / 60)).substr(-2) + ":" + String("0" + Math.floor(_loc3_ % 60)).substr(-2) + ":00";
            }
            if(param2 == SKILL_FED)
            {
               _loc3_ = Math.round(Math.max(0,_loc3_ - _loc4_) / 1000);
               return "00:" + String("0" + Math.floor(_loc3_ / 60)).substr(-2) + ":" + String("0" + Math.floor(_loc3_ % 60)).substr(-2);
            }
            if(param2 == SKILL_HITPOINTS || param2 == SKILL_MANA)
            {
               return String(_loc3_) + "/" + String(_loc4_);
            }
            if(param2 == SKILL_CARRYSTRENGTH)
            {
               return (_loc3_ / 100).toFixed(2) + "/" + (_loc4_ / 100).toFixed(2);
            }
            if(param2 == SKILL_EXPERIENCE || param2 == SKILL_LEVEL || param2 == SKILL_SOULPOINTS)
            {
               return String(_loc3_);
            }
            if(param2 == SKILL_CRITICAL_HIT_CHANCE || param2 == SKILL_CRITICAL_HIT_DAMAGE || param2 == SKILL_LIFE_LEECH_CHANCE || param2 == SKILL_LIFE_LEECH_AMOUNT || param2 == SKILL_MANA_LEECH_CHANCE || param2 == SKILL_MANA_LEECH_AMOUNT)
            {
               _loc5_ = _loc3_ - _loc4_;
               return String(_loc5_) + "%";
            }
            _loc5_ = _loc3_ - _loc4_;
            return String(_loc4_) + (_loc5_ >= 0?" +":" ") + String(_loc5_);
         }
         return null;
      }
   }
}
