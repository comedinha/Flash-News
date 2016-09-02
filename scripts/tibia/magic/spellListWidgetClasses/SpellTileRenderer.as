package tibia.magic.spellListWidgetClasses
{
   import mx.containers.HBox;
   import tibia.creatures.Player;
   import mx.events.PropertyChangeEvent;
   import mx.core.EventPriority;
   import tibia.magic.Spell;
   import mx.controls.listClasses.ListBase;
   import flash.display.DisplayObjectContainer;
   import mx.events.ListEvent;
   import flash.events.Event;
   import mx.core.DragSource;
   import flash.events.MouseEvent;
   import mx.events.SandboxMouseEvent;
   import mx.managers.DragManager;
   
   public class SpellTileRenderer extends HBox
   {
      
      protected static const BLESSING_SPARK_OF_PHOENIX:int = BLESSING_WISDOM_OF_SOLITUDE << 1;
      
      protected static const PARTY_LEADER_SEXP_ACTIVE:int = 6;
      
      protected static const PARTY_MAX_FLASHING_TIME:uint = 5000;
      
      protected static const DRAG_TYPE_CHANNEL:String = "channel";
      
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
      
      protected static const DRAG_TYPE_WIDGETBASE:String = "widgetBase";
      
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
      
      protected static const DRAG_TYPE_ACTION:String = "action";
      
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
      
      protected static const DRAG_TYPE_STATUSWIDGET:String = "statusWidget";
      
      protected static const PARTY_LEADER_SEXP_OFF:int = 4;
      
      protected static const DRAG_TYPE_OBJECT:String = "object";
      
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
      
      protected static const DRAG_TYPE_SPELL:String = "spell";
      
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
      
      protected static const DRAG_OPACITY:Number = 0.75;
      
      protected static const BLESSING_SPIRITUAL_SHIELDING:int = BLESSING_ADVENTURER << 1;
      
      protected static const NPC_SPEECH_NONE:uint = 0;
      
      protected static const PK_MAX_FLASHING_TIME:uint = 5000;
      
      protected static const SKILL_GOSTRENGTH:int = 6;
       
      
      private var m_UncommittedSelected:Boolean = false;
      
      private var m_Selected:Boolean = false;
      
      private var m_UncommittedPlayer:Boolean = false;
      
      private var m_Player:Player = null;
      
      private var m_Available:Boolean = true;
      
      private var m_UncommittedSpell:Boolean = false;
      
      private var m_UIConstructed:Boolean = false;
      
      private var m_Spell:Spell = null;
      
      private var m_UncommittedAvailable:Boolean = false;
      
      private var m_UISpellIcon:tibia.magic.spellListWidgetClasses.SpellIconRenderer = null;
      
      public function SpellTileRenderer()
      {
         super();
         addEventListener(MouseEvent.MOUSE_DOWN,this.onDragControl);
      }
      
      public function set player(param1:Player) : void
      {
         if(this.m_Player != param1)
         {
            if(this.m_Player != null)
            {
               this.m_Player.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onPlayerPropertyChange);
            }
            this.m_Player = param1;
            if(this.m_Player != null)
            {
               this.m_Player.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onPlayerPropertyChange,false,EventPriority.DEFAULT,true);
            }
            this.m_UncommittedPlayer = true;
            invalidateProperties();
            this.available = this.m_Player != null && this.spell != null && this.m_Player.getSpellCasts(this.spell) > -1;
         }
      }
      
      public function set selected(param1:Boolean) : void
      {
         if(this.m_Selected != param1)
         {
            this.m_Selected = param1;
            this.m_UncommittedSelected = true;
            invalidateProperties();
         }
      }
      
      protected function get available() : Boolean
      {
         return this.m_Available;
      }
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
         if(this.m_UncommittedAvailable)
         {
            this.m_UISpellIcon.available = this.available;
            this.m_UncommittedAvailable = false;
         }
         if(this.m_UncommittedPlayer)
         {
            this.m_UncommittedPlayer = false;
         }
         if(this.m_UncommittedSelected)
         {
            this.m_UISpellIcon.selected = this.selected;
            this.m_UncommittedSelected = false;
         }
         if(this.m_UncommittedSpell)
         {
            this.m_UISpellIcon.spell = this.spell;
            this.m_UncommittedSpell = false;
         }
      }
      
      protected function set spell(param1:Spell) : void
      {
         if(this.m_Spell != param1)
         {
            this.m_Spell = param1;
            this.m_UncommittedSpell = true;
            invalidateProperties();
            this.available = this.player != null && this.spell != null && this.player.getSpellCasts(this.spell) > -1;
            this.selected = owner is ListBase && ListBase(owner).selectedItem == data;
         }
      }
      
      protected function set available(param1:Boolean) : void
      {
         if(this.m_Available != param1)
         {
            this.m_Available = param1;
            this.m_UncommittedAvailable = true;
            invalidateProperties();
         }
      }
      
      override public function set data(param1:Object) : void
      {
         if(super.data != param1)
         {
            super.data = param1;
            this.spell = param1 as Spell;
         }
      }
      
      public function get player() : Player
      {
         return this.m_Player;
      }
      
      public function get selected() : Boolean
      {
         return this.m_Selected;
      }
      
      private function onPlayerPropertyChange(param1:PropertyChangeEvent) : void
      {
         if(param1.property == "knownSpells" || param1.property == "premium" || param1.property == "profession" || param1.property == "skill" || param1.property == "*")
         {
            this.available = this.player != null && this.spell != null && this.player.getSpellCasts(this.spell) > -1;
         }
      }
      
      protected function get spell() : Spell
      {
         return this.m_Spell;
      }
      
      override protected function createChildren() : void
      {
         if(!this.m_UIConstructed)
         {
            super.createChildren();
            this.m_UISpellIcon = new tibia.magic.spellListWidgetClasses.SpellIconRenderer();
            this.m_UISpellIcon.styleName = "spellListWidgetSpellIconRenderer";
            addChild(this.m_UISpellIcon);
            this.m_UIConstructed = true;
         }
      }
      
      override public function set owner(param1:DisplayObjectContainer) : void
      {
         if(owner != param1)
         {
            if(owner is ListBase)
            {
               owner.removeEventListener(ListEvent.CHANGE,this.onListSelectionChange);
            }
            super.owner = param1;
            if(owner is ListBase)
            {
               owner.addEventListener(ListEvent.CHANGE,this.onListSelectionChange,false,EventPriority.DEFAULT,true);
            }
         }
      }
      
      private function onDragControl(param1:Event) : void
      {
         var _loc2_:DragSource = null;
         var _loc3_:tibia.magic.spellListWidgetClasses.SpellIconRenderer = null;
         if(this.spell == null)
         {
            return;
         }
         switch(param1.type)
         {
            case MouseEvent.MOUSE_DOWN:
               addEventListener(MouseEvent.MOUSE_MOVE,this.onDragControl);
               addEventListener(MouseEvent.MOUSE_UP,this.onDragControl);
               systemManager.getSandboxRoot().addEventListener(SandboxMouseEvent.MOUSE_UP_SOMEWHERE,this.onDragControl);
               break;
            case MouseEvent.MOUSE_MOVE:
               _loc2_ = new DragSource();
               _loc2_.addData(DRAG_TYPE_SPELL,"dragType");
               _loc2_.addData(this.spell,"dragSpell");
               _loc3_ = new tibia.magic.spellListWidgetClasses.SpellIconRenderer();
               _loc3_.spell = this.spell;
               _loc3_.available = true;
               _loc3_.selected = false;
               DragManager.doDrag(this,_loc2_,MouseEvent(param1),_loc3_,-this.m_UISpellIcon.mouseX,-this.m_UISpellIcon.mouseY,DRAG_OPACITY);
            case MouseEvent.MOUSE_UP:
            case SandboxMouseEvent.MOUSE_UP_SOMEWHERE:
            default:
               removeEventListener(MouseEvent.MOUSE_MOVE,this.onDragControl);
               removeEventListener(MouseEvent.MOUSE_UP,this.onDragControl);
               systemManager.getSandboxRoot().removeEventListener(SandboxMouseEvent.MOUSE_UP_SOMEWHERE,this.onDragControl);
         }
      }
      
      private function onListSelectionChange(param1:ListEvent) : void
      {
         this.selected = param1.itemRenderer != null && param1.itemRenderer.data == data;
      }
   }
}
