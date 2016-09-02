package tibia.container.bodyContainerViewWigdetClasses
{
   import tibia.sidebar.sideBarWidgetClasses.WidgetView;
   import tibia.game.IUseWidget;
   import tibia.game.IMoveWidget;
   import tibia.container.BodyContainerView;
   import flash.text.TextField;
   import flash.events.MouseEvent;
   import tibia.game.ObjectDragImpl;
   import tibia.help.UIEffectsRetrieveComponentCommandEvent;
   import mx.controls.Button;
   import tibia.creatures.Player;
   import mx.controls.Label;
   import flash.events.TimerEvent;
   import tibia.container.containerViewWidgetClasses.ContainerSlot;
   import flash.text.TextFieldAutoSize;
   import flash.filters.GlowFilter;
   import flash.filters.BitmapFilterQuality;
   import mx.containers.HBox;
   import shared.controls.CustomButton;
   import flash.geom.Point;
   import shared.utility.getClassInstanceUnderPoint;
   import shared.utility.Vector3D;
   import mx.events.PropertyChangeEvent;
   import tibia.input.ModifierKeyEvent;
   import tibia.ingameshop.IngameShopManager;
   import tibia.ingameshop.IngameShopEvent;
   import tibia.container.ContainerStorage;
   import tibia.appearances.AppearanceInstance;
   import tibia.input.gameaction.UseActionImpl;
   import flash.text.TextFormat;
   import tibia.cursors.CursorHelper;
   import mx.core.EdgeMetrics;
   import tibia.input.mapping.MouseBinding;
   import tibia.input.MouseActionHelper;
   import tibia.input.gameaction.LookActionImpl;
   import tibia.game.ObjectContextMenu;
   import mx.containers.Box;
   import tibia.§sidebar:ns_sidebar_internal§.widgetClosed;
   import tibia.§sidebar:ns_sidebar_internal§.widgetCollapsed;
   import tibia.ingameshop.IngameShopProduct;
   import build.ObjectDragImplFactory;
   import mx.managers.CursorManagerPriority;
   import mx.core.ScrollPolicy;
   
   public class BodyContainerViewWidgetView extends WidgetView implements IUseWidget, IMoveWidget
   {
      
      private static const WIDGET_COMPONENTS:Array = [{
         "slot":-1,
         "left":123,
         "top":140,
         "width":28,
         "height":11,
         "style":null,
         "blessedStyle":null,
         "tooltip":null
      },{
         "slot":BodyContainerView.HEAD,
         "left":70,
         "top":2,
         "width":NaN,
         "height":NaN,
         "style":"bodySlotHeadStyle",
         "blessedStyle":"bodySlotHeadBlessedStyle",
         "tooltip":null
      },{
         "slot":BodyContainerView.NECK,
         "left":26,
         "top":8,
         "width":NaN,
         "height":NaN,
         "style":"bodySlotNeckStyle",
         "blessedStyle":"bodySlotNeckBlessedStyle",
         "tooltip":null
      },{
         "slot":BodyContainerView.BACK,
         "left":114,
         "top":8,
         "width":NaN,
         "height":NaN,
         "style":"bodySlotBackStyle",
         "blessedStyle":"bodySlotBackBlessedStyle",
         "tooltip":null
      },{
         "slot":BodyContainerView.TORSO,
         "left":70,
         "top":39,
         "width":NaN,
         "height":NaN,
         "style":"bodySlotTorsoStyle",
         "blessedStyle":"bodySlotTorsoBlessedStyle",
         "tooltip":null
      },{
         "slot":BodyContainerView.RIGHT_HAND,
         "left":120,
         "top":53,
         "width":NaN,
         "height":NaN,
         "style":"bodySlotRightHandStyle",
         "blessedStyle":"bodySlotRightHandBlessedStyle",
         "tooltip":null
      },{
         "slot":BodyContainerView.LEFT_HAND,
         "left":19,
         "top":54,
         "width":NaN,
         "height":NaN,
         "style":"bodySlotLeftHandStyle",
         "blessedStyle":"bodySlotLeftHandBlessedStyle",
         "tooltip":null
      },{
         "slot":BodyContainerView.LEGS,
         "left":70,
         "top":77,
         "width":NaN,
         "height":NaN,
         "style":"bodySlotLegsStyle",
         "blessedStyle":"bodySlotLegsBlessedStyle",
         "tooltip":null
      },{
         "slot":BodyContainerView.FEET,
         "left":70,
         "top":115,
         "width":NaN,
         "height":NaN,
         "style":"bodySlotFeetStyle",
         "blessedStyle":"bodySlotFeetBlessedStyle",
         "tooltip":null
      },{
         "slot":BodyContainerView.FINGER,
         "left":26,
         "top":99,
         "width":NaN,
         "height":NaN,
         "style":"bodySlotFingerStyle",
         "blessedStyle":"bodySlotFingerBlessedStyle",
         "tooltip":null
      },{
         "slot":BodyContainerView.HIP,
         "left":114,
         "top":98,
         "width":NaN,
         "height":NaN,
         "style":"bodySlotHipStyle",
         "blessedStyle":"bodySlotHipBlessedStyle",
         "tooltip":null
      },{
         "slot":BodyContainerView.STOREINBOX,
         "left":106,
         "top":0,
         "width":NaN,
         "height":NaN,
         "style":"buttonStoreInboxStyle",
         "blessedStyle":null,
         "tooltip":"TOOLTIP_STOREINBOX"
      },{
         "slot":BodyContainerView.STORE,
         "left":0,
         "top":0,
         "width":NaN,
         "height":NaN,
         "style":"buttonIngameShopStyle",
         "blessedStyle":null,
         "tooltip":"TOOLTIP_STORE"
      },{
         "slot":BodyContainerView.BLESSINGS,
         "left":2,
         "top":1,
         "width":NaN,
         "height":NaN,
         "style":"bodySlotBlessingStyle",
         "blessedStyle":null,
         "tooltip":null
      }];
      
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
      
      private static const MOUSE_BUTTON_RIGHT:int = 2;
      
      protected static const GUILD_NONE:int = 0;
      
      protected static const PARTY_MEMBER:int = 2;
      
      protected static const STATE_DRUNK:int = 3;
      
      protected static const PARTY_OTHER:int = 11;
      
      protected static const SKILL_EXPERIENCE:int = 0;
      
      private static const MOUSE_BUTTON_LEFT:int = 1;
      
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
      
      private static const ACTION_ATTACK:int = 1;
      
      protected static const STATE_BLEEDING:int = 15;
      
      protected static const PK_PLAYERKILLER:int = 4;
      
      protected static const PROFESSION_MASK_KNIGHT:int = 1 << PROFESSION_KNIGHT;
      
      protected static const STATE_DAZZLED:int = 10;
      
      protected static const SUMMON_OTHERS:int = 2;
      
      protected static const SKILL_NONE:int = -1;
      
      protected static const NPC_SPEECH_TRADER:uint = 2;
      
      private static const BUNDLE:String = "BodyContainerViewWidget";
      
      protected static const GUILD_MEMBER:int = 4;
      
      protected static const PROFESSION_NONE:int = 0;
      
      public static const HIGHLIGHT_TIMEOUT:int = 1000 * 60 * 10;
      
      private static const WIDGET_VIEW_HEIGHT:Number = 179;
      
      protected static const MAX_NAME_LENGTH:int = 29;
      
      protected static const PARTY_LEADER:int = 1;
      
      protected static const STATE_PZ_ENTERED:int = 14;
      
      private static const ACTION_OPEN:int = 8;
      
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
      
      private static const ACTION_TALK:int = 9;
      
      protected static const SUMMON_OWN:int = 1;
      
      private static const ACTION_LOOK:int = 6;
      
      protected static const PROFESSION_MASK_NONE:int = 1 << PROFESSION_NONE;
      
      protected static const TYPE_SUMMON_OWN:int = 3;
      
      protected static const PROFESSION_MASK_SORCERER:int = 1 << PROFESSION_SORCERER;
      
      protected static const PROFESSION_KNIGHT:int = 1;
      
      protected static const NPC_SPEECH_QUESTTRADER:uint = 4;
      
      protected static const PARTY_LEADER_SEXP_INACTIVE_GUILTY:int = 8;
      
      private static const CONFIRMATION_TIMEOUT:int = 1000 * 30;
      
      protected static const BLESSING_WISDOM_OF_SOLITUDE:int = BLESSING_FIRE_OF_SUNS << 1;
      
      private static const ACTION_SMARTCLICK:int = 100;
      
      protected static const PROFESSION_PALADIN:int = 2;
      
      protected static const SKILL_FIGHTAXE:int = 12;
      
      protected static const SKILL_CRITICAL_HIT_DAMAGE:int = 20;
      
      private static const MOUSE_BUTTON_MIDDLE:int = 3;
      
      protected static const PARTY_LEADER_SEXP_OFF:int = 4;
      
      protected static const SKILL_SOULPOINTS:int = 16;
      
      protected static const BLESSING_EMBRACE_OF_TIBIA:int = BLESSING_SPIRITUAL_SHIELDING << 1;
      
      protected static const BLESSING_TWIST_OF_FATE:int = BLESSING_SPARK_OF_PHOENIX << 1;
      
      protected static const SKILL_MANA_LEECH_AMOUNT:int = 24;
      
      private static const ACTION_CONTEXT_MENU:int = 5;
      
      protected static const STATE_FAST:int = 6;
      
      private static const VALID_ACTIONS:Vector.<uint> = Vector.<uint>([ACTION_USE,ACTION_OPEN,ACTION_LOOK,ACTION_CONTEXT_MENU]);
      
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
      
      private static const ACTION_NONE:int = 0;
      
      protected static const PARTY_LEADER_SEXP_INACTIVE_INNOCENT:int = 10;
      
      private static const MOUSE_BUTTON_BOTH:int = 4;
      
      protected static const STATE_POISONED:int = 0;
      
      protected static const SKILL_LIFE_LEECH_CHANCE:int = 21;
      
      private static const ACTION_ATTACK_OR_TALK:int = 102;
      
      protected static const TYPE_MONSTER:int = 1;
      
      protected static const STATE_BURNING:int = 1;
      
      protected static const SKILL_FIGHTFIST:int = 13;
      
      private static const ACTION_UNSET:int = -1;
      
      private static const ACTION_AUTOWALK_HIGHLIGHT:int = 4;
      
      protected static const PK_AGGRESSOR:int = 3;
      
      protected static const GUILD_WAR_ENEMY:int = 2;
      
      protected static const SKILL_LEVEL:int = 1;
      
      protected static const STATE_STRENGTHENED:int = 12;
      
      protected static const STATE_HUNGRY:int = 31;
      
      protected static const PROFESSION_MASK_ANY:int = PROFESSION_MASK_DRUID | PROFESSION_MASK_KNIGHT | PROFESSION_MASK_PALADIN | PROFESSION_MASK_SORCERER;
      
      protected static const SUMMON_NONE:int = 0;
      
      private static const ACTION_USE:int = 7;
      
      protected static const PROFESSION_DRUID:int = 4;
      
      protected static const STATE_FIGHTING:int = 7;
      
      private static const ACTION_AUTOWALK:int = 3;
      
      protected static const NPC_SPEECH_QUEST:uint = 3;
      
      protected static const NPC_SPEECH_NORMAL:uint = 1;
      
      private static const ACTION_USE_OR_OPEN:int = 101;
      
      protected static const BLESSING_SPIRITUAL_SHIELDING:int = BLESSING_ADVENTURER << 1;
      
      protected static const NPC_SPEECH_NONE:uint = 0;
      
      protected static const PK_MAX_FLASHING_TIME:uint = 5000;
      
      protected static const SKILL_GOSTRENGTH:int = 6;
       
      
      private var m_UICapacity:TextField = null;
      
      private const m_DragHandler:ObjectDragImpl = ObjectDragImplFactory.s_CreateObjectDragImpl();
      
      private var m_TriggerExpiryTime:int = 0;
      
      private var m_UIOpenStoreCancel:Button = null;
      
      private var m_BodyContainer:BodyContainerView = null;
      
      private var m_Player:Player = null;
      
      private var m_UIOpenStoreConfirmText:Label = null;
      
      private var m_RolloverSlot:ContainerSlot = null;
      
      private var m_UIOpenStore:Button = null;
      
      private var m_UIBlessings:Button = null;
      
      private var m_ConfirmationOpenedTimestamp:uint = 0;
      
      private var m_UIOpenStoreConfirm:Button = null;
      
      private var m_UncommittedPlayer:Boolean = false;
      
      private var m_UIOpenStoreInbox:Button = null;
      
      private var m_CursorHelper:CursorHelper;
      
      private var m_UICapacityTooltipOverlay:Box = null;
      
      private var m_UncommittedBodyContainer:Boolean = false;
      
      private var m_UIStoreButtonsContainer:HBox = null;
      
      public function BodyContainerViewWidgetView()
      {
         this.m_CursorHelper = new CursorHelper(CursorManagerPriority.MEDIUM);
         super();
         horizontalScrollPolicy = ScrollPolicy.OFF;
         verticalScrollPolicy = ScrollPolicy.OFF;
         titleText = resourceManager.getString(BUNDLE,"TITLE");
         Tibia.s_GetInputHandler().addEventListener(ModifierKeyEvent.MODIFIER_KEYS_CHANGED,this.onModifierKeyEvent);
         Tibia.s_GetUIEffectsManager().addEventListener(UIEffectsRetrieveComponentCommandEvent.GET_UI_COMPONENT,this.onUIEffectsCommandEvent);
         Tibia.s_GetSecondaryTimer().addEventListener(TimerEvent.TIMER,this.onSecondaryTimer);
         IngameShopManager.getInstance().addEventListener(IngameShopEvent.CURRENTLY_FEATURED_SERVICE_TYPE_CHANGED,this.onCurrentlyFeaturedServiceTypeChanged);
      }
      
      private function replaceConfirmationWithButton() : void
      {
         this.m_UIOpenStore.addEventListener(MouseEvent.CLICK,this.onIngameShopClick);
         this.m_UIOpenStoreConfirm.removeEventListener(MouseEvent.CLICK,this.onOpenStoreConfirmButtonClick);
         this.m_UIOpenStoreCancel.removeEventListener(MouseEvent.CLICK,this.onOpenStoreConfirmButtonClick);
         this.m_UIStoreButtonsContainer.removeAllChildren();
         this.m_UIStoreButtonsContainer.addChild(this.m_UIOpenStore);
         this.m_UIStoreButtonsContainer.addChild(this.m_UIOpenStoreInbox);
         invalidateDisplayList();
         invalidateSize();
      }
      
      private function onUIEffectsCommandEvent(param1:UIEffectsRetrieveComponentCommandEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:BodySlot = null;
         if(param1.type == UIEffectsRetrieveComponentCommandEvent.GET_UI_COMPONENT && param1.identifier == BodyContainerViewWidgetView)
         {
            this.widgetCollapsed = false;
            _loc2_ = param1.subIdentifier as int;
            if(_loc2_ == -1)
            {
               param1.resultUIComponent = this;
            }
            else
            {
               _loc3_ = 0;
               while(_loc3_ < numChildren)
               {
                  _loc4_ = BodySlot(getChildAt(_loc3_));
                  if(_loc4_.position == _loc2_)
                  {
                     param1.resultUIComponent = _loc4_;
                     break;
                  }
                  _loc3_++;
               }
            }
         }
      }
      
      protected function onSlotRollOver(param1:MouseEvent) : void
      {
         this.m_RolloverSlot = param1.target as BodySlot;
         this.determineAction(param1,false,true);
      }
      
      private function onSlotClick(param1:MouseEvent) : void
      {
         this.determineAction(param1,true,false);
      }
      
      private function startStoreButtonHighlighting(param1:int) : void
      {
         this.m_UIOpenStore.selected = true;
         this.m_TriggerExpiryTime = Tibia.s_GetTibiaTimer() + param1;
      }
      
      protected function onSecondaryTimer(param1:TimerEvent) : void
      {
         var _loc2_:int = Tibia.s_GetTibiaTimer();
         if(this.m_UIOpenStore.selected && this.m_TriggerExpiryTime < _loc2_)
         {
            this.stopStoreButtonHighlighting();
         }
         if(this.m_UIStoreButtonsContainer.contains(this.m_UIStoreButtonsContainer) && this.m_ConfirmationOpenedTimestamp + CONFIRMATION_TIMEOUT < _loc2_)
         {
            this.replaceConfirmationWithButton();
         }
      }
      
      override protected function createChildren() : void
      {
         var _loc2_:BodySlot = null;
         super.createChildren();
         this.m_UICapacity = createInFontContext(TextField) as TextField;
         this.m_UICapacity.autoSize = TextFieldAutoSize.CENTER;
         this.m_UICapacity.defaultTextFormat = this.getCapacityTextFormat();
         this.m_UICapacity.filters = [new GlowFilter(0,1,2,2,4,BitmapFilterQuality.LOW,false,false)];
         this.m_UICapacity.selectable = false;
         this.m_UICapacity.text = this.getCapacityLabel();
         rawChildren.addChild(this.m_UICapacity);
         this.m_UICapacityTooltipOverlay = new HBox();
         this.m_UICapacityTooltipOverlay.toolTip = resourceManager.getString(BUNDLE,"TOOLTIP_CAPACITY");
         rawChildren.addChild(this.m_UICapacityTooltipOverlay);
         this.m_UIStoreButtonsContainer = new HBox();
         this.m_UIStoreButtonsContainer.setStyle("horizontalGap",6);
         this.m_UIOpenStore = new CustomButton();
         if(WIDGET_COMPONENTS[BodyContainerView.STORE].style != null)
         {
            this.m_UIOpenStore.styleName = getStyle(WIDGET_COMPONENTS[BodyContainerView.STORE].style);
         }
         if(WIDGET_COMPONENTS[BodyContainerView.STORE].tooltip != null)
         {
            this.m_UIOpenStore.toolTip = resourceManager.getString(BUNDLE,WIDGET_COMPONENTS[BodyContainerView.STORE].tooltip);
         }
         this.m_UIOpenStore.addEventListener(MouseEvent.CLICK,this.onIngameShopClick);
         this.m_UIOpenStore.label = "Store";
         this.m_UIStoreButtonsContainer.addChild(this.m_UIOpenStore);
         this.m_UIOpenStoreInbox = new CustomButton();
         if(WIDGET_COMPONENTS[BodyContainerView.STOREINBOX].style != null)
         {
            this.m_UIOpenStoreInbox.styleName = getStyle(WIDGET_COMPONENTS[BodyContainerView.STOREINBOX].style);
         }
         if(WIDGET_COMPONENTS[BodyContainerView.STOREINBOX].tooltip != null)
         {
            this.m_UIOpenStoreInbox.toolTip = resourceManager.getString(BUNDLE,WIDGET_COMPONENTS[BodyContainerView.STOREINBOX].tooltip);
         }
         this.m_UIOpenStoreInbox.addEventListener(MouseEvent.CLICK,this.onStoreInboxClick);
         this.m_UIOpenStoreInbox.label = "";
         this.m_UIStoreButtonsContainer.addChild(this.m_UIOpenStoreInbox);
         rawChildren.addChild(this.m_UIStoreButtonsContainer);
         this.m_UIBlessings = new CustomButton();
         if(WIDGET_COMPONENTS[BodyContainerView.BLESSINGS].style != null)
         {
            this.m_UIBlessings.styleName = getStyle(WIDGET_COMPONENTS[BodyContainerView.BLESSINGS].style);
         }
         rawChildren.addChild(this.m_UIBlessings);
         var _loc1_:int = BodyContainerView.FIRST_SLOT;
         while(_loc1_ <= BodyContainerView.LAST_SLOT)
         {
            if(!(_loc1_ == BodyContainerView.STORE || _loc1_ == BodyContainerView.STOREINBOX || _loc1_ == BodyContainerView.BLESSINGS))
            {
               _loc2_ = new BodySlot();
               _loc2_.appearance = null;
               _loc2_.position = _loc1_;
               if(WIDGET_COMPONENTS[_loc1_].style != null)
               {
                  _loc2_.styleName = getStyle(WIDGET_COMPONENTS[_loc1_].style);
               }
               if(WIDGET_COMPONENTS[_loc1_].tooltip != null)
               {
                  _loc2_.toolTip = resourceManager.getString(BUNDLE,WIDGET_COMPONENTS[_loc1_].tooltip);
               }
               _loc2_.addEventListener(MouseEvent.CLICK,this.onSlotClick);
               _loc2_.addEventListener(MouseEvent.RIGHT_CLICK,this.onSlotClick);
               _loc2_.addEventListener(MouseEvent.MIDDLE_CLICK,this.onSlotClick);
               _loc2_.addEventListener(MouseEvent.ROLL_OVER,this.onSlotRollOver);
               _loc2_.addEventListener(MouseEvent.ROLL_OUT,this.onSlotRollOut);
               this.m_DragHandler.addDragComponent(_loc2_);
               addChild(_loc2_);
            }
            _loc1_++;
         }
         this.m_UIOpenStoreConfirmText = new Label();
         this.m_UIOpenStoreConfirmText.text = resourceManager.getString(BUNDLE,"LBL_OPEN_STORE_CONFIRM");
         this.m_UIOpenStoreConfirmText.styleName = "storeConfirmation";
         this.m_UIOpenStoreConfirm = new CustomButton();
         this.m_UIOpenStoreConfirm.label = resourceManager.getString(BUNDLE,"BTN_OPEN_STORE_CONFIRM");
         this.m_UIOpenStoreCancel = new CustomButton();
         this.m_UIOpenStoreCancel.label = resourceManager.getString(BUNDLE,"BTN_OPEN_STORE_CANCEL");
      }
      
      public function getUseObjectUnderPoint(param1:Point) : Object
      {
         var _loc2_:BodySlot = null;
         if(this.bodyContainer != null && (_loc2_ = getClassInstanceUnderPoint(stage,param1,BodySlot)) != null)
         {
            return {
               "object":_loc2_.appearance,
               "absolute":new Vector3D(65535,_loc2_.position,0),
               "position":0
            };
         }
         return null;
      }
      
      private function getCapacityLabel() : String
      {
         var _loc1_:Number = NaN;
         if(this.m_Player != null)
         {
            _loc1_ = this.m_Player.getSkillValue(SKILL_CARRYSTRENGTH);
            return resourceManager.getString(BUNDLE,"LBL_CAPACITY_FORMAT",[Math.round(_loc1_ / 100)]);
         }
         return null;
      }
      
      public function getMoveObjectUnderPoint(param1:Point) : Object
      {
         return this.getUseObjectUnderPoint(param1);
      }
      
      private function onBodyContainerChange(param1:PropertyChangeEvent) : void
      {
         if(param1.property == "objects")
         {
            this.updateSlots();
         }
      }
      
      public function pointToMap(param1:Point) : Vector3D
      {
         return null;
      }
      
      override function releaseInstance() : void
      {
         var _loc2_:BodySlot = null;
         super.releaseInstance();
         var _loc1_:int = 0;
         while(_loc1_ < numChildren)
         {
            _loc2_ = BodySlot(removeChildAt(_loc1_));
            _loc2_.appearance = null;
            _loc2_.removeEventListener(MouseEvent.CLICK,this.onSlotClick);
            _loc2_.removeEventListener(MouseEvent.RIGHT_CLICK,this.onSlotClick);
            _loc2_.removeEventListener(MouseEvent.MIDDLE_CLICK,this.onSlotClick);
            _loc2_.removeEventListener(MouseEvent.ROLL_OVER,this.onSlotRollOver);
            _loc2_.removeEventListener(MouseEvent.ROLL_OUT,this.onSlotRollOut);
            this.m_DragHandler.removeDragComponent(_loc2_);
            _loc1_++;
         }
         this.m_UIOpenStore.removeEventListener(MouseEvent.CLICK,this.onIngameShopClick);
         this.m_UIOpenStoreInbox.removeEventListener(MouseEvent.CLICK,this.onStoreInboxClick);
         Tibia.s_GetInputHandler().removeEventListener(ModifierKeyEvent.MODIFIER_KEYS_CHANGED,this.onModifierKeyEvent);
         Tibia.s_GetUIEffectsManager().removeEventListener(UIEffectsRetrieveComponentCommandEvent.GET_UI_COMPONENT,this.onUIEffectsCommandEvent);
         Tibia.s_GetSecondaryTimer().removeEventListener(TimerEvent.TIMER,this.onSecondaryTimer);
         IngameShopManager.getInstance().removeEventListener(IngameShopEvent.CURRENTLY_FEATURED_SERVICE_TYPE_CHANGED,this.onCurrentlyFeaturedServiceTypeChanged);
      }
      
      private function onStoreInboxClick(param1:MouseEvent) : void
      {
         var _loc5_:Vector3D = null;
         var _loc2_:ContainerStorage = Tibia.s_GetContainerStorage();
         var _loc3_:BodyContainerView = null;
         var _loc4_:AppearanceInstance = null;
         if(_loc2_ != null && (_loc3_ = _loc2_.getBodyContainerView()) != null && (_loc4_ = _loc3_.getObject(BodyContainerView.STOREINBOX)) != null && _loc4_.type != null)
         {
            _loc5_ = new Vector3D(65535,BodyContainerView.STOREINBOX,0);
            Tibia.s_GameActionFactory.createUseAction(_loc5_,_loc4_.ID,0,UseActionImpl.TARGET_AUTO).perform();
         }
      }
      
      private function replaceButtonWithConfirmation() : void
      {
         this.m_UIOpenStore.removeEventListener(MouseEvent.CLICK,this.onIngameShopClick);
         this.m_UIOpenStoreConfirm.addEventListener(MouseEvent.CLICK,this.onOpenStoreConfirmButtonClick);
         this.m_UIOpenStoreCancel.addEventListener(MouseEvent.CLICK,this.onOpenStoreConfirmButtonClick);
         this.m_UIStoreButtonsContainer.removeAllChildren();
         this.m_UIStoreButtonsContainer.addChild(this.m_UIOpenStoreConfirmText);
         this.m_UIStoreButtonsContainer.addChild(this.m_UIOpenStoreConfirm);
         this.m_UIStoreButtonsContainer.addChild(this.m_UIOpenStoreCancel);
         invalidateDisplayList();
         invalidateSize();
         this.m_ConfirmationOpenedTimestamp = Tibia.s_GetTibiaTimer();
      }
      
      override public function styleChanged(param1:String) : void
      {
         switch(param1)
         {
            case "capacityFontColor":
            case "capacityFontFamily":
            case "capacityFontSize":
            case "capacityFontStyle":
            case "capacityFontWeight":
               this.m_UICapacity.defaultTextFormat = this.getCapacityTextFormat();
               invalidateDisplayList();
               break;
            default:
               super.styleChanged(param1);
         }
      }
      
      public function pointToAbsolute(param1:Point) : Vector3D
      {
         var _loc2_:BodySlot = null;
         if(this.bodyContainer != null && (_loc2_ = getClassInstanceUnderPoint(stage,param1,BodySlot)) != null)
         {
            return new Vector3D(65535,_loc2_.position,0);
         }
         return null;
      }
      
      protected function onOpenStoreConfirmButtonClick(param1:MouseEvent) : void
      {
         if(param1 != null && param1.target != null)
         {
            if(param1.target == this.m_UIOpenStoreConfirm)
            {
               IngameShopManager.getInstance().openShopWindow(true,IngameShopManager.getInstance().currentlyFeaturedServiceType);
               this.stopStoreButtonHighlighting();
            }
         }
         this.replaceConfirmationWithButton();
      }
      
      private function getCapacityTextFormat() : TextFormat
      {
         var _loc1_:String = getStyle("capacityFontFamily");
         var _loc2_:Number = getStyle("capacityFontSize");
         var _loc3_:uint = getStyle("capacityFontColor");
         var _loc4_:* = getStyle("capacityFontWeight") === "bold";
         var _loc5_:* = getStyle("capacityFontStyle") === "italic";
         return new TextFormat(_loc1_,_loc2_,_loc3_,_loc4_,_loc5_);
      }
      
      override protected function commitProperties() : void
      {
         if(this.m_UncommittedBodyContainer)
         {
            this.updateSlots();
            this.m_UncommittedBodyContainer = false;
         }
         super.commitProperties();
      }
      
      override protected function measure() : void
      {
         super.measure();
         var _loc1_:EdgeMetrics = viewMetricsAndPadding;
         measuredMinWidth = measuredWidth = _loc1_.left + WIDGET_VIEW_WIDTH + _loc1_.right;
         measuredMinHeight = measuredHeight = _loc1_.top + WIDGET_VIEW_HEIGHT + _loc1_.bottom;
      }
      
      private function stopStoreButtonHighlighting() : void
      {
         this.m_UIOpenStore.selected = false;
      }
      
      function get player() : Player
      {
         return this.m_Player;
      }
      
      protected function onSlotRollOut(param1:MouseEvent) : void
      {
         this.m_RolloverSlot = null;
         this.m_CursorHelper.resetCursor();
      }
      
      function set player(param1:Player) : void
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
      
      private function getBlessingTooltip() : String
      {
         var _loc1_:Vector.<String> = new Vector.<String>();
         if(this.m_Player != null)
         {
            if(this.m_Player.hasBlessing(BLESSING_ADVENTURER))
            {
               _loc1_.push(resourceManager.getString(BUNDLE,"TOOLTIP_BLESSING_ADVENTURER"));
            }
         }
         if(_loc1_.length == 0)
         {
            _loc1_.push(resourceManager.getString(BUNDLE,"TOOLTIP_NO_BLESSINGS"));
         }
         return _loc1_.join("\n");
      }
      
      protected function determineAction(param1:MouseEvent, param2:Boolean = false, param3:Boolean = false) : void
      {
         var _loc10_:Object = null;
         var _loc4_:ContainerSlot = null;
         var _loc5_:AppearanceInstance = null;
         var _loc6_:Vector3D = new Vector3D(0,0,0);
         var _loc7_:AppearanceInstance = null;
         var _loc8_:MouseBinding = null;
         var _loc9_:uint = ACTION_NONE;
         if(m_Options == null)
         {
            return;
         }
         if(param1 != null)
         {
            _loc8_ = m_Options.mouseMapping.findBindingByMouseEvent(param1);
            _loc4_ = param1.target as BodySlot;
         }
         else
         {
            _loc8_ = m_Options.mouseMapping.findBindingForLeftMouseButtonAndPressedModifierKey();
            _loc4_ = this.m_RolloverSlot;
         }
         if(_loc8_ != null)
         {
            _loc9_ = _loc8_.action;
         }
         if(_loc4_ == null)
         {
            return;
         }
         _loc7_ = _loc4_.appearance;
         _loc6_ = new Vector3D(65535,_loc4_.position,0);
         if(_loc7_ != null)
         {
            _loc9_ = MouseActionHelper.resolveActionForAppearanceOrCreature(_loc9_,_loc7_,VALID_ACTIONS);
         }
         else
         {
            _loc9_ = ACTION_NONE;
         }
         if(param3 && m_Options != null && m_Options.mouseMapping != null && m_Options.mouseMapping.showMouseCursorForAction)
         {
            this.m_CursorHelper.setCursor(MouseActionHelper.actionToMouseCursor(_loc9_));
         }
         if(param2)
         {
            switch(_loc9_)
            {
               case ACTION_USE:
               case ACTION_OPEN:
                  Tibia.s_GameActionFactory.createUseAction(_loc6_,_loc7_.type,_loc6_.z,UseActionImpl.TARGET_AUTO).perform();
                  break;
               case ACTION_LOOK:
                  new LookActionImpl(_loc6_,_loc7_.type,_loc6_.z).perform();
                  break;
               case ACTION_CONTEXT_MENU:
                  if(_loc4_.appearance != null)
                  {
                     _loc10_ = {
                        "position":_loc6_.z,
                        "object":_loc7_
                     };
                     new ObjectContextMenu(_loc6_,_loc10_,_loc10_,null).display(this,param1.stageX,param1.stageY);
                  }
                  break;
               case ACTION_NONE:
            }
         }
      }
      
      public function getMultiUseObjectUnderPoint(param1:Point) : Object
      {
         return this.getUseObjectUnderPoint(param1);
      }
      
      private function updateSlots() : void
      {
         var _loc2_:BodySlot = null;
         var _loc1_:int = numChildren - 1;
         while(_loc1_ >= 0)
         {
            _loc2_ = BodySlot(getChildAt(_loc1_));
            if(this.bodyContainer != null)
            {
               _loc2_.appearance = this.bodyContainer.getObject(_loc2_.position);
            }
            else
            {
               _loc2_.appearance = null;
            }
            _loc1_--;
         }
      }
      
      private function onPlayerChange(param1:PropertyChangeEvent) : void
      {
         if(param1.property == "skill" || param1.property == "*")
         {
            this.m_UICapacity.text = this.getCapacityLabel();
            invalidateDisplayList();
         }
         else if(param1.property == "blessings")
         {
            invalidateDisplayList();
         }
      }
      
      private function onModifierKeyEvent(param1:ModifierKeyEvent) : void
      {
         this.determineAction(null,false,true);
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         var _loc7_:BodySlot = null;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         super.updateDisplayList(param1,param2);
         var _loc3_:* = !(widgetClosed || widgetCollapsed);
         var _loc4_:EdgeMetrics = viewMetricsAndPadding;
         this.m_UICapacity.visible = this.m_UICapacityTooltipOverlay.visible = _loc3_;
         this.m_UICapacity.x = this.m_UICapacityTooltipOverlay.x = _loc4_.left + WIDGET_COMPONENTS[0].left;
         this.m_UICapacity.y = this.m_UICapacityTooltipOverlay.y = _loc4_.top + WIDGET_COMPONENTS[0].top - 2;
         this.m_UICapacity.width = this.m_UICapacityTooltipOverlay.width = WIDGET_COMPONENTS[0].width;
         this.m_UICapacity.height = this.m_UICapacityTooltipOverlay.height = WIDGET_COMPONENTS[0].height;
         this.m_UIStoreButtonsContainer.visible = true;
         this.m_UIStoreButtonsContainer.move(_loc4_.left + 8,_loc4_.top + 156);
         this.m_UIStoreButtonsContainer.setActualSize(this.m_UIStoreButtonsContainer.getExplicitOrMeasuredWidth(),this.m_UIStoreButtonsContainer.getExplicitOrMeasuredHeight());
         this.m_UIOpenStore.visible = _loc3_;
         this.m_UIOpenStore.setActualSize(this.m_UIOpenStore.getExplicitOrMeasuredWidth(),this.m_UIOpenStore.getExplicitOrMeasuredHeight());
         this.m_UIOpenStoreInbox.visible = _loc3_;
         this.m_UIOpenStoreInbox.setActualSize(this.m_UIOpenStoreInbox.getExplicitOrMeasuredWidth(),this.m_UIOpenStoreInbox.getExplicitOrMeasuredHeight());
         this.m_UIOpenStoreConfirmText.width = 79;
         var _loc5_:Boolean = this.m_Player != null && !this.m_Player.hasBlessing(BLESSING_NONE);
         this.m_UIBlessings.visible = _loc3_;
         this.m_UIBlessings.enabled = _loc5_;
         this.m_UIBlessings.toolTip = this.getBlessingTooltip();
         this.m_UIBlessings.move(_loc4_.left + WIDGET_COMPONENTS[BodyContainerView.BLESSINGS].left,_loc4_.top + WIDGET_COMPONENTS[BodyContainerView.BLESSINGS].top);
         this.m_UIBlessings.setActualSize(this.m_UIBlessings.getExplicitOrMeasuredWidth(),this.m_UIBlessings.getExplicitOrMeasuredHeight());
         var _loc6_:int = numChildren - 1;
         while(_loc6_ >= 0)
         {
            _loc7_ = BodySlot(getChildAt(_loc6_));
            if(_loc5_ && WIDGET_COMPONENTS[_loc7_.position].blessedStyle != null)
            {
               _loc7_.styleName = getStyle(WIDGET_COMPONENTS[_loc7_.position].blessedStyle);
            }
            else
            {
               _loc7_.styleName = getStyle(WIDGET_COMPONENTS[_loc7_.position].style);
            }
            _loc8_ = WIDGET_COMPONENTS[_loc7_.position].width;
            if(isNaN(_loc8_))
            {
               _loc8_ = _loc7_.getExplicitOrMeasuredWidth();
            }
            _loc9_ = WIDGET_COMPONENTS[_loc7_.position].height;
            if(isNaN(_loc9_))
            {
               _loc9_ = _loc7_.getExplicitOrMeasuredHeight();
            }
            _loc7_.visible = _loc3_;
            _loc7_.move(WIDGET_COMPONENTS[_loc7_.position].left,WIDGET_COMPONENTS[_loc7_.position].top);
            _loc7_.setActualSize(_loc8_,_loc9_);
            _loc6_--;
         }
      }
      
      protected function onCurrentlyFeaturedServiceTypeChanged(param1:IngameShopEvent) : void
      {
         if(IngameShopManager.getInstance().currentlyFeaturedServiceType == IngameShopProduct.SERVICE_TYPE_UNKNOWN)
         {
            this.stopStoreButtonHighlighting();
         }
         else
         {
            this.startStoreButtonHighlighting(HIGHLIGHT_TIMEOUT);
         }
      }
      
      private function onIngameShopClick(param1:MouseEvent) : void
      {
         if(Tibia.s_GetPlayer().isFighting)
         {
            this.replaceButtonWithConfirmation();
         }
         else
         {
            IngameShopManager.getInstance().openShopWindow(true,IngameShopManager.getInstance().currentlyFeaturedServiceType);
            this.stopStoreButtonHighlighting();
         }
      }
      
      function set bodyContainer(param1:BodyContainerView) : void
      {
         if(param1 != this.m_BodyContainer)
         {
            if(this.m_BodyContainer != null)
            {
               this.m_BodyContainer.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onBodyContainerChange);
            }
            this.m_BodyContainer = param1;
            if(this.m_BodyContainer != null)
            {
               this.m_BodyContainer.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onBodyContainerChange);
            }
            this.m_UncommittedBodyContainer = true;
            invalidateDisplayList();
            invalidateProperties();
            invalidateSize();
         }
      }
      
      function get bodyContainer() : BodyContainerView
      {
         return this.m_BodyContainer;
      }
   }
}
