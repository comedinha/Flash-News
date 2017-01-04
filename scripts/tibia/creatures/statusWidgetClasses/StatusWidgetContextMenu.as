package tibia.creatures.statusWidgetClasses
{
   import mx.core.IUIComponent;
   import shared.utility.cacheStyleInstance;
   import shared.utility.closure;
   import tibia.creatures.StatusWidget;
   import tibia.game.ContextMenuBase;
   import tibia.game.contextMenuClasses.TextItem;
   import tibia.options.OptionsStorage;
   
   public class StatusWidgetContextMenu extends ContextMenuBase
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
      
      private static const SKILL_OPTIONS:Array = [{
         "value":SKILL_NONE,
         "styleProp":"iconProgressOff"
      },{
         "value":SKILL_LEVEL,
         "styleProp":"iconSkillLevel"
      },{
         "value":SKILL_MAGLEVEL,
         "styleProp":"iconSkillMagLevel"
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
      }];
      
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
      
      private static const STYLE_OPTIONS:Array = [{
         "value":StatusWidget.STATUS_STYLE_DEFAULT,
         "styleProp":"iconStyleDefault"
      },{
         "value":StatusWidget.STATUS_STYLE_COMPACT,
         "styleProp":"iconStyleCompact"
      },{
         "value":StatusWidget.STATUS_STYLE_PARALLEL,
         "styleProp":"iconStyleParallel"
      },{
         "value":StatusWidget.STATUS_STYLE_FAT,
         "styleProp":"iconStyleLarge"
      }];
      
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
         cacheStyleInstance(STYLE_OPTIONS,".statusWidgetIcons");
         cacheStyleInstance(SKILL_OPTIONS,".statusWidgetIcons");
      }
      
      protected var m_Options:OptionsStorage = null;
      
      public function StatusWidgetContextMenu(param1:OptionsStorage)
      {
         super();
         if(param1 == null)
         {
            throw new ArgumentError("StatusWidgetContextMenu.StatusWidgetContextMenu: Invalid options reference.");
         }
         this.m_Options = param1;
      }
      
      override public function display(param1:IUIComponent, param2:Number, param3:Number) : void
      {
         var Label:String = null;
         var a_Owner:IUIComponent = param1;
         var a_StageX:Number = param2;
         var a_StageY:Number = param3;
         var Item:TextItem = null;
         var i:int = 0;
         while(i < STYLE_OPTIONS.length)
         {
            if(STYLE_OPTIONS[i].value !== this.m_Options.statusWidgetStyle)
            {
               Item = createTextItem(resourceManager.getString(BUNDLE,"CTX_SWITCH_STYLE",[StatusWidget.s_GetStyleName(STYLE_OPTIONS[i].value)]),closure(null,function(param1:OptionsStorage, param2:int, param3:*):void
               {
                  if(param1 != null)
                  {
                     param1.statusWidgetStyle = param2;
                  }
               },this.m_Options,STYLE_OPTIONS[i].value));
               Item.icon = STYLE_OPTIONS[i].styleInstance;
            }
            i++;
         }
         createSeparatorItem();
         var j:int = 0;
         while(j < SKILL_OPTIONS.length)
         {
            if(SKILL_OPTIONS[j].value !== this.m_Options.statusWidgetSkill)
            {
               Label = null;
               if(SKILL_OPTIONS[j].value == SKILL_NONE)
               {
                  Label = resourceManager.getString(BUNDLE,"CTX_DISABLE_SKILL");
               }
               else
               {
                  Label = resourceManager.getString(BUNDLE,"CTX_SWITCH_SKILL",[StatusWidget.s_GetSkillName(SKILL_OPTIONS[j].value)]);
               }
               Item = createTextItem(Label,closure(null,function(param1:OptionsStorage, param2:int, param3:*):void
               {
                  if(param1)
                  {
                     param1.statusWidgetSkill = param2;
                  }
               },this.m_Options,SKILL_OPTIONS[j].value));
               Item.icon = SKILL_OPTIONS[j].styleInstance;
            }
            j++;
         }
         super.display(a_Owner,a_StageX,a_StageY);
      }
   }
}
