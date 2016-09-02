package tibia.trade.npcTradeWidgetClasses
{
   import tibia.sidebar.sideBarWidgetClasses.WidgetView;
   import mx.styles.CSSStyleDeclaration;
   import mx.styles.StyleManager;
   import tibia.appearances.AppearanceStorage;
   import mx.controls.Label;
   import mx.controls.Button;
   import tibia.creatures.Player;
   import mx.collections.IList;
   import tibia.trade.TradeObjectRef;
   import tibia.appearances.AppearanceType;
   import tibia.container.BodyContainerView;
   import tibia.appearances.ObjectInstance;
   import tibia.§sidebar:ns_sidebar_internal§.options;
   import tibia.trade.NPCTradeWidget;
   import mx.controls.TabBar;
   import mx.containers.HBox;
   import mx.containers.Form;
   import mx.containers.FormItem;
   import mx.events.ItemClickEvent;
   import shared.controls.CustomButton;
   import flash.events.MouseEvent;
   import flash.events.Event;
   import mx.events.PropertyChangeEvent;
   import tibia.container.ContainerStorage;
   import tibia.network.Communication;
   import mx.collections.ICollectionView;
   import mx.core.ScrollPolicy;
   
   public class NPCTradeWidgetView extends WidgetView
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
      
      private static const UI_TRADE_MODE:Array = [{
         "resource":"TRADE_MODE_BUY",
         "mode":MODE_BUY
      },{
         "resource":"TRADE_MODE_SELL",
         "mode":MODE_SELL
      }];
      
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
      
      public static const MODE_SELL:int = 1;
      
      private static const BUNDLE:String = "NPCTradeWidget";
      
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
      
      public static const MODE_BUY:int = 0;
      
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
         s_InitializeStyle();
      }
      
      protected var m_AppearanceStorage:AppearanceStorage = null;
      
      protected var m_UILabelWeight:Label = null;
      
      private var m_UncommittedTradeAmount:Boolean = false;
      
      private var m_UncommittedCategories:Boolean = false;
      
      protected var m_UIObjectLayout:Button = null;
      
      protected var m_Player:Player = null;
      
      private var m_UncommittedTradeMode:Boolean = false;
      
      protected var m_NPCName:String = null;
      
      protected var m_UITradeMode:TabBar = null;
      
      private var m_CachedPlayerCapacity:Number = 0;
      
      private var m_UIConstructed:Boolean = false;
      
      private var m_UncommittedPlayer:Boolean = false;
      
      protected var m_Categories:IList = null;
      
      private var m_InvalidObjectSummary:Boolean = false;
      
      protected var m_ContainerStorage:ContainerStorage = null;
      
      private var m_UncommittedAppearanceStorage:Boolean = false;
      
      protected var m_SellObjects:IList = null;
      
      protected var m_UIObjectSelector:tibia.trade.npcTradeWidgetClasses.ObjectRefSelectorBase = null;
      
      private var m_UncommittedSellObjects:Boolean = false;
      
      protected var m_UIAmountSelector:tibia.trade.npcTradeWidgetClasses.AmountSelector = null;
      
      private var m_UncommittedBuyObjects:Boolean = false;
      
      protected var m_UIObjectSelectorBox:HBox = null;
      
      protected var m_TradeMode:int = 0;
      
      private var m_UncommittedNPCName:Boolean = false;
      
      protected var m_UICategorySelector:tibia.trade.npcTradeWidgetClasses.CategorySelector = null;
      
      protected var m_UILabelCapacity:Label = null;
      
      protected var m_UIButtonCommit:Button = null;
      
      protected var m_TradeObject:TradeObjectRef = null;
      
      protected var m_UILabelBudget:Label = null;
      
      private var m_InvalidObjectAmounts:Boolean = false;
      
      protected var m_BuyObjects:IList = null;
      
      protected var m_TradeAmount:int = 0;
      
      private var m_UncommittedContainerStorage:Boolean = false;
      
      private var m_UncommittedTradeObject:Boolean = false;
      
      protected var m_UILabelPrice:Label = null;
      
      public function NPCTradeWidgetView()
      {
         super();
         horizontalScrollPolicy = ScrollPolicy.OFF;
         verticalScrollPolicy = ScrollPolicy.OFF;
         maxHeight = int.MAX_VALUE;
         titleText = this.getTitleLabel();
      }
      
      private static function s_InitializeStyle() : void
      {
         var Selector:String = ".defaultNPCTradeWidgetViewTabStyle";
         var Decl:CSSStyleDeclaration = StyleManager.getStyleDeclaration(Selector);
         if(Decl == null)
         {
            Decl = new CSSStyleDeclaration();
         }
         Decl.defaultFactory = function():void
         {
            this.paddingLeft = 0;
            this.paddingRight = 0;
            this.textAlign = "center";
         };
         StyleManager.setStyleDeclaration(Selector,Decl,true);
         Selector = "NPCTradeWidgetView";
         Decl = StyleManager.getStyleDeclaration(Selector);
         if(Decl == null)
         {
            Decl = new CSSStyleDeclaration();
         }
         Decl.defaultFactory = function():void
         {
            this.horizontalGap = 0;
            this.verticalGap = 0;
         };
         StyleManager.setStyleDeclaration(Selector,Decl,true);
      }
      
      private function getTradeModeLabel(param1:Object) : String
      {
         if(param1 != null)
         {
            return resourceManager.getString(BUNDLE,param1.resource);
         }
         return null;
      }
      
      function set npcName(param1:String) : void
      {
         if(this.m_NPCName != param1)
         {
            this.m_NPCName = param1;
            this.m_UncommittedNPCName = true;
            invalidateProperties();
         }
      }
      
      function get npcName() : String
      {
         return this.m_NPCName;
      }
      
      function get categories() : IList
      {
         return this.m_Categories;
      }
      
      private function getMaxSellAmount(param1:TradeObjectRef) : uint
      {
         var _loc3_:AppearanceType = null;
         var _loc4_:Boolean = false;
         var _loc5_:Boolean = false;
         var _loc6_:BodyContainerView = null;
         var _loc7_:int = 0;
         var _loc8_:ObjectInstance = null;
         var _loc2_:int = 0;
         if(options != null && this.m_ContainerStorage != null && this.m_AppearanceStorage != null && param1 != null)
         {
            _loc3_ = this.m_AppearanceStorage.getObjectType(param1.ID);
            _loc4_ = _loc3_ != null && _loc3_.isCumulative;
            _loc5_ = _loc3_ != null && _loc3_.isLiquidContainer;
            _loc2_ = this.m_ContainerStorage.getAvailableGoods(param1.ID,param1.data);
            if(_loc2_ > 0 && options.npcTradeSellKeepEquipped)
            {
               _loc6_ = this.m_ContainerStorage.getBodyContainerView();
               _loc7_ = BodyContainerView.FIRST_SLOT;
               while(_loc7_ <= BodyContainerView.LAST_SLOT)
               {
                  _loc8_ = _loc6_.getObject(_loc7_) as ObjectInstance;
                  if(_loc8_ != null && _loc8_.ID == param1.ID && (!_loc5_ || _loc8_.data == param1.data))
                  {
                     _loc2_ = _loc2_ - (!!_loc4_?_loc8_.data:1);
                  }
                  _loc7_++;
               }
            }
         }
         return Math.max(0,Math.min(_loc2_,NPCTradeWidget.TRADE_MAX_AMOUNT));
      }
      
      private function updateObjectSummary() : void
      {
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:uint = 0;
         var _loc9_:Number = NaN;
         var _loc10_:AppearanceStorage = null;
         var _loc11_:AppearanceType = null;
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         var _loc1_:Number = 0;
         if(this.m_ContainerStorage != null)
         {
            _loc1_ = this.m_ContainerStorage.getPlayerMoney();
            this.m_UILabelBudget.text = resourceManager.getString(BUNDLE,"LBL_MONEY_FORMAT",[_loc1_.toFixed(0)]);
         }
         else
         {
            this.m_UILabelBudget.text = null;
         }
         var _loc2_:Number = NaN;
         if(this.m_Player != null)
         {
            _loc2_ = this.m_Player.getSkillValue(SKILL_CARRYSTRENGTH);
            this.m_UILabelCapacity.text = resourceManager.getString(BUNDLE,"LBL_WEIGHT_FORMAT",[(_loc2_ / 100).toFixed(2)]);
         }
         else
         {
            this.m_UILabelCapacity.text = null;
         }
         var _loc3_:* = this.m_TradeMode == MODE_BUY;
         var _loc4_:uint = getStyle("color");
         var _loc5_:uint = getStyle("errorColor");
         if(this.m_TradeObject != null)
         {
            _loc6_ = Math.max(1,this.m_TradeAmount);
            _loc7_ = Math.max(1,this.m_TradeObject.amount);
            _loc8_ = 0;
            _loc9_ = 0;
            if(_loc3_ && (options == null || options.npcTradeBuyWithBackpacks))
            {
               _loc10_ = Tibia.s_GetAppearanceStorage();
               _loc11_ = null;
               _loc12_ = _loc6_;
               if(_loc10_ != null && (_loc11_ = _loc10_.getObjectType(this.m_TradeObject.ID)) != null && _loc11_.isCumulative)
               {
                  _loc12_ = Math.ceil(_loc6_ / 100);
               }
               _loc13_ = Math.ceil(_loc12_ / NPCTradeWidget.TRADE_BACKPACK_CAPACITY);
               _loc8_ = _loc13_ * NPCTradeWidget.TRADE_BACKPACK_PRICE + _loc6_ * this.m_TradeObject.price;
               _loc9_ = _loc13_ * NPCTradeWidget.TRADE_BACKPACK_WEIGHT + _loc6_ * this.m_TradeObject.weight;
            }
            else
            {
               _loc8_ = _loc6_ * this.m_TradeObject.price;
               _loc9_ = _loc6_ * this.m_TradeObject.weight;
            }
            this.m_UIAmountSelector.minimum = 1;
            this.m_UIAmountSelector.maximum = _loc7_;
            this.m_UIAmountSelector.value = _loc6_;
            this.m_UIButtonCommit.enabled = this.m_TradeAmount > 0 && this.m_TradeAmount <= this.m_TradeObject.amount;
            this.m_UIButtonCommit.label = resourceManager.getString(BUNDLE,!!_loc3_?"TRADE_MODE_BUY":"TRADE_MODE_SELL");
            this.m_UILabelPrice.text = resourceManager.getString(BUNDLE,"LBL_MONEY_FORMAT",[_loc8_]);
            this.m_UILabelPrice.setStyle("color",_loc3_ && _loc8_ > _loc1_?_loc5_:_loc4_);
            this.m_UILabelWeight.text = resourceManager.getString(BUNDLE,"LBL_WEIGHT_FORMAT",[(_loc9_ / 100).toFixed(2)]);
            this.m_UILabelWeight.setStyle("color",_loc3_ && _loc9_ > _loc2_?_loc5_:_loc4_);
         }
         else
         {
            this.m_UIAmountSelector.minimum = 1;
            this.m_UIAmountSelector.maximum = 1;
            this.m_UIAmountSelector.value = 1;
            this.m_UIButtonCommit.enabled = false;
            this.m_UIButtonCommit.label = resourceManager.getString(BUNDLE,!!_loc3_?"TRADE_MODE_BUY":"TRADE_MODE_SELL");
            this.m_UILabelPrice.text = null;
            this.m_UILabelPrice.setStyle("color",_loc4_);
            this.m_UILabelWeight.text = null;
            this.m_UILabelWeight.setStyle("color",_loc4_);
         }
      }
      
      function get tradeMode() : int
      {
         return this.m_TradeMode;
      }
      
      override protected function createChildren() : void
      {
         var _loc1_:Boolean = false;
         var _loc2_:HBox = null;
         var _loc3_:Form = null;
         var _loc4_:FormItem = null;
         if(!this.m_UIConstructed)
         {
            super.createChildren();
            this.m_UICategorySelector = new tibia.trade.npcTradeWidgetClasses.CategorySelector();
            this.m_UICategorySelector.dataProvider = this.m_Categories;
            this.m_UICategorySelector.height = NaN;
            this.m_UICategorySelector.includeInLayout = this.m_Categories != null;
            this.m_UICategorySelector.visible = this.m_Categories != null;
            this.m_UICategorySelector.width = unscaledInnerWidth;
            this.m_UICategorySelector.setStyle("horizontalAlign","center");
            addChild(this.m_UICategorySelector);
            this.m_UITradeMode = new TabBar();
            this.m_UITradeMode.dataProvider = UI_TRADE_MODE;
            this.m_UITradeMode.labelFunction = this.getTradeModeLabel;
            this.m_UITradeMode.percentHeight = NaN;
            this.m_UITradeMode.percentWidth = 100;
            this.m_UITradeMode.selectedIndex = this.getTradeModeIndex();
            this.m_UITradeMode.styleName = getStyle("tradeModeTabBarStyle");
            this.m_UITradeMode.addEventListener(ItemClickEvent.ITEM_CLICK,this.onModeChange);
            this.m_UITradeMode.setStyle("tabStyleName",getStyle("tradeModeTabStyle"));
            this.m_UITradeMode.setStyle("tabHeight",getStyle("tradeModeTabHeight"));
            this.m_UITradeMode.setStyle("tabWidth",getStyle("tradeModeTabWidth"));
            _loc1_ = options == null || options.npcTradeLayout == tibia.trade.npcTradeWidgetClasses.ObjectRefSelectorBase.LAYOUT_GRID;
            this.m_UIObjectLayout = new CustomButton();
            this.m_UIObjectLayout.toggle = true;
            this.m_UIObjectLayout.toolTip = resourceManager.getString(BUNDLE,!!_loc1_?"LAYOUT_MODE_GRID":"LAYOUT_MODE_LIST");
            this.m_UIObjectLayout.selected = _loc1_;
            this.m_UIObjectLayout.styleName = getStyle("tradeModeLayoutButtonStyle");
            this.m_UIObjectLayout.addEventListener(MouseEvent.CLICK,this.onLayoutChange);
            _loc2_ = new HBox();
            _loc2_.height = 27;
            _loc2_.percentHeight = NaN;
            _loc2_.percentWidth = 100;
            _loc2_.width = NaN;
            _loc2_.styleName = getStyle("tradeModeBoxStyle");
            _loc2_.addChild(this.m_UITradeMode);
            _loc2_.addChild(this.m_UIObjectLayout);
            addChild(_loc2_);
            this.m_UIObjectSelectorBox = new HBox();
            this.m_UIObjectSelectorBox.percentHeight = 100;
            this.m_UIObjectSelectorBox.percentWidth = 100;
            this.m_UIObjectSelectorBox.styleName = getStyle("objectBoxStyle");
            addChild(this.m_UIObjectSelectorBox);
            this.updateObjectSelector();
            _loc2_ = new HBox();
            _loc2_.percentHeight = NaN;
            _loc2_.percentWidth = 100;
            _loc2_.styleName = getStyle("amountBoxStyle");
            this.m_UIAmountSelector = new tibia.trade.npcTradeWidgetClasses.AmountSelector();
            this.m_UIAmountSelector.minimum = 1;
            this.m_UIAmountSelector.maximum = NPCTradeWidget.TRADE_MAX_AMOUNT;
            this.m_UIAmountSelector.percentHeight = NaN;
            this.m_UIAmountSelector.percentWidth = 100;
            this.m_UIAmountSelector.styleName = getStyle("amountSelectorStyle");
            this.m_UIAmountSelector.addEventListener(Event.CHANGE,this.onAmountChange);
            _loc2_.addChild(this.m_UIAmountSelector);
            addChild(_loc2_);
            _loc2_ = new HBox();
            _loc2_.percentHeight = NaN;
            _loc2_.percentWidth = 100;
            _loc2_.styleName = getStyle("summaryBoxStyle");
            _loc3_ = new Form();
            _loc3_.percentHeight = 100;
            _loc3_.percentWidth = 100;
            _loc3_.styleName = getStyle("summaryFormStyle");
            _loc4_ = new FormItem();
            _loc4_.label = resourceManager.getString(BUNDLE,"LBL_CURRENT_PRICE");
            this.m_UILabelPrice = new Label();
            this.m_UILabelPrice.setStyle("fontWeight","bold");
            _loc4_.addChild(this.m_UILabelPrice);
            _loc3_.addChild(_loc4_);
            _loc4_ = new FormItem();
            _loc4_.label = resourceManager.getString(BUNDLE,"LBL_AVAILABLE_MONEY");
            this.m_UILabelBudget = new Label();
            this.m_UILabelBudget.setStyle("fontWeight","bold");
            _loc4_.addChild(this.m_UILabelBudget);
            _loc3_.addChild(_loc4_);
            _loc4_ = new FormItem();
            _loc4_.label = resourceManager.getString(BUNDLE,"LBL_CURRENT_WEIGHT");
            this.m_UILabelWeight = new Label();
            this.m_UILabelWeight.setStyle("fontWeight","bold");
            _loc4_.addChild(this.m_UILabelWeight);
            _loc3_.addChild(_loc4_);
            _loc4_ = new FormItem();
            _loc4_.label = resourceManager.getString(BUNDLE,"LBL_AVAILABLE_CAPACITY");
            this.m_UILabelCapacity = new Label();
            this.m_UILabelCapacity.setStyle("fontWeight","bold");
            _loc4_.addChild(this.m_UILabelCapacity);
            _loc3_.addChild(_loc4_);
            _loc2_.addChild(_loc3_);
            addChild(_loc2_);
            _loc2_ = new HBox();
            _loc2_.percentHeight = NaN;
            _loc2_.percentWidth = 100;
            _loc2_.styleName = getStyle("commitBoxStyle");
            this.m_UIButtonCommit = new CustomButton();
            this.m_UIButtonCommit.label = resourceManager.getString(BUNDLE,this.m_TradeMode == MODE_BUY?"TRADE_MODE_BUY":"TRADE_MODE_SELL");
            this.m_UIButtonCommit.percentWidth = 100;
            this.m_UIButtonCommit.addEventListener(MouseEvent.CLICK,this.onButtonCommit);
            _loc2_.addChild(this.m_UIButtonCommit);
            addChild(_loc2_);
            this.m_UIConstructed = true;
         }
      }
      
      function set categories(param1:IList) : void
      {
         if(this.m_Categories != param1)
         {
            this.m_Categories = param1;
            this.m_UncommittedCategories = true;
            invalidateProperties();
         }
      }
      
      protected function onObjectChange(param1:Event) : void
      {
         this.tradeObject = this.m_UIObjectSelector.selectedObject;
         this.tradeAmount = this.tradeMode == MODE_SELL && this.tradeObject != null?int(this.tradeObject.amount):1;
      }
      
      override protected function onOptionsChange(param1:PropertyChangeEvent) : void
      {
         super.onOptionsChange(param1);
         if(param1.property == "npcTradeBuyIgnoreCapacity" || param1.property == "npcTradeBuyWithBackpacks" || param1.property == "npcTradeSellKeepEquipped" || param1.property == "*")
         {
            this.invalidateObjectAmounts();
            this.invalidateObjectSummary();
         }
         if(param1.property == "npcTradeLayout" || param1.property == "npcTradeSort" || param1.property == "*")
         {
            this.updateObjectSelector();
         }
      }
      
      function set buyObjects(param1:IList) : void
      {
         if(this.m_BuyObjects != param1)
         {
            this.m_BuyObjects = param1;
            this.m_UncommittedBuyObjects = true;
            this.invalidateObjectAmounts();
            this.invalidateObjectSummary();
            invalidateProperties();
         }
      }
      
      protected function invalidateObjectAmounts() : void
      {
         this.m_InvalidObjectAmounts = true;
         invalidateProperties();
      }
      
      function set tradeMode(param1:int) : void
      {
         if(param1 != MODE_BUY && param1 != MODE_SELL)
         {
            param1 = MODE_BUY;
         }
         if(this.m_TradeMode != param1)
         {
            this.m_TradeMode = param1;
            this.m_UncommittedTradeMode = true;
            this.invalidateObjectSummary();
            invalidateProperties();
         }
      }
      
      override protected function commitOptions() : void
      {
         super.commitOptions();
         this.invalidateObjectAmounts();
         this.invalidateObjectSummary();
      }
      
      function get sellObjects() : IList
      {
         return this.m_SellObjects;
      }
      
      private function updateObjectSelector() : void
      {
         var _loc1_:int = options != null?int(options.npcTradeLayout):int(tibia.trade.npcTradeWidgetClasses.ObjectRefSelectorBase.LAYOUT_LIST);
         var _loc2_:int = options != null?int(options.npcTradeSort):int(tibia.trade.npcTradeWidgetClasses.ObjectRefSelectorBase.SORT_NAME);
         if(this.m_UIObjectSelector != null && this.m_UIObjectSelector.layout != _loc1_)
         {
            this.m_UIObjectSelector.dataProvider = null;
            this.m_UIObjectSelector.removeEventListener(Event.CHANGE,this.onObjectChange);
            this.m_UIObjectSelector = null;
            this.m_UIObjectSelectorBox.removeAllChildren();
         }
         if(this.m_UIObjectSelector == null)
         {
            this.m_UIObjectSelector = tibia.trade.npcTradeWidgetClasses.ObjectRefSelectorBase.s_Create(_loc1_);
            this.m_UIObjectSelector.percentHeight = 100;
            this.m_UIObjectSelector.percentWidth = 100;
            this.m_UIObjectSelector.styleName = getStyle("objectSelectorStyle");
            this.m_UIObjectSelector.addEventListener(Event.CHANGE,this.onObjectChange);
            this.m_UIObjectSelectorBox.removeAllChildren();
            this.m_UIObjectSelectorBox.addChild(this.m_UIObjectSelector);
         }
         this.m_UIObjectSelector.dataProvider = this.tradeMode == MODE_BUY?this.buyObjects:this.sellObjects;
         this.m_UIObjectSelector.sortOrder = _loc2_;
         this.m_UIObjectSelector.tradeMode = this.tradeMode;
      }
      
      protected function onModeChange(param1:ItemClickEvent) : void
      {
         if(param1.item != null)
         {
            this.tradeMode = param1.item.mode;
         }
      }
      
      function set containerStorage(param1:ContainerStorage) : void
      {
         if(this.m_ContainerStorage != param1)
         {
            if(this.m_ContainerStorage != null)
            {
               this.m_ContainerStorage.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onContainerChange);
            }
            this.m_ContainerStorage = param1;
            if(this.m_ContainerStorage != null)
            {
               this.m_ContainerStorage.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onContainerChange);
            }
            this.m_UncommittedContainerStorage = true;
            this.invalidateObjectAmounts();
            this.invalidateObjectSummary();
            invalidateProperties();
         }
      }
      
      function get appearanceStorage() : AppearanceStorage
      {
         return this.m_AppearanceStorage;
      }
      
      private function getTitleLabel() : String
      {
         if(this.m_NPCName != null)
         {
            return resourceManager.getString(BUNDLE,"TITLE_WITH_NAME",[this.m_NPCName]);
         }
         return resourceManager.getString(BUNDLE,"TITLE_NO_NAME");
      }
      
      protected function onPlayerChange(param1:PropertyChangeEvent) : void
      {
         var _loc2_:Number = NaN;
         if(param1.property == "skill" || param1.property == "*")
         {
            _loc2_ = this.m_Player.getSkillValue(SKILL_CARRYSTRENGTH);
            if(this.m_CachedPlayerCapacity != _loc2_)
            {
               this.m_CachedPlayerCapacity = _loc2_;
               this.invalidateObjectAmounts();
               this.invalidateObjectSummary();
            }
         }
      }
      
      protected function onButtonCommit(param1:MouseEvent) : void
      {
         var _loc2_:Communication = null;
         if(options != null && this.tradeObject != null && this.tradeAmount >= 1 && this.tradeAmount <= this.tradeObject.amount && (_loc2_ = Tibia.s_GetCommunication()) != null && _loc2_.isGameRunning)
         {
            if(this.m_TradeMode == MODE_BUY)
            {
               _loc2_.sendCBUYOBJECT(this.tradeObject.ID,this.tradeObject.data,this.tradeAmount,options.npcTradeBuyIgnoreCapacity,options.npcTradeBuyWithBackpacks);
            }
            else
            {
               _loc2_.sendCSELLOBJECT(this.tradeObject.ID,this.tradeObject.data,this.tradeAmount,options.npcTradeSellKeepEquipped);
            }
            this.m_UncommittedTradeObject = true;
            this.m_UncommittedTradeAmount = true;
         }
      }
      
      function set tradeObject(param1:TradeObjectRef) : void
      {
         var _loc4_:int = 0;
         var _loc5_:TradeObjectRef = null;
         var _loc2_:TradeObjectRef = null;
         var _loc3_:IList = this.m_TradeMode == MODE_BUY?this.m_BuyObjects:this.m_SellObjects;
         if(_loc3_ != null)
         {
            _loc4_ = _loc3_.length - 1;
            while(_loc4_ >= 0)
            {
               _loc5_ = TradeObjectRef(_loc3_.getItemAt(_loc4_));
               if(_loc5_.equals(param1))
               {
                  _loc2_ = _loc5_;
                  break;
               }
               _loc4_--;
            }
         }
         if((this.m_TradeObject == null || !this.m_TradeObject.equals(_loc2_)) && (this.m_TradeObject != null || _loc2_ != null))
         {
            this.m_TradeObject = _loc2_;
            this.m_UncommittedTradeObject = true;
            this.invalidateObjectSummary();
            invalidateProperties();
         }
      }
      
      private function updateObjectAmounts() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:int = 0;
         var _loc3_:TradeObjectRef = null;
         var _loc4_:Boolean = false;
         var _loc5_:TradeObjectRef = null;
         if(this.buyObjects != null)
         {
            _loc4_ = false;
            _loc2_ = this.buyObjects.length - 1;
            while(_loc2_ >= 0)
            {
               _loc3_ = TradeObjectRef(this.buyObjects.getItemAt(_loc2_));
               _loc1_ = this.getMaxBuyAmount(_loc3_);
               _loc4_ = _loc4_ || _loc3_.amount != _loc1_;
               _loc3_.amount = _loc1_;
               _loc2_--;
            }
            if(_loc4_ && this.buyObjects is ICollectionView)
            {
               _loc5_ = this.m_UIObjectSelector.selectedObject;
               ICollectionView(this.buyObjects).refresh();
               if(_loc5_ != null)
               {
                  this.m_UIObjectSelector.selectedObject = _loc5_;
               }
            }
         }
         if(this.sellObjects != null)
         {
            _loc4_ = false;
            _loc2_ = this.sellObjects.length - 1;
            while(_loc2_ >= 0)
            {
               _loc3_ = TradeObjectRef(this.sellObjects.getItemAt(_loc2_));
               _loc1_ = this.getMaxSellAmount(_loc3_);
               _loc4_ = _loc4_ || _loc3_.amount != _loc1_;
               _loc3_.amount = _loc1_;
               _loc2_--;
            }
            if(_loc4_ && this.sellObjects is ICollectionView)
            {
               _loc5_ = this.m_UIObjectSelector.selectedObject;
               ICollectionView(this.sellObjects).refresh();
               if(_loc5_ != null && _loc5_.amount == 0)
               {
                  this.tradeObject = null;
                  this.tradeAmount = 0;
               }
            }
         }
      }
      
      protected function onContainerChange(param1:PropertyChangeEvent) : void
      {
         if(param1.property == "bodyItem" || param1.property == "playerGoods" || param1.property == "playerMoney")
         {
            this.invalidateObjectAmounts();
            this.invalidateObjectSummary();
         }
      }
      
      protected function onAmountChange(param1:Event) : void
      {
         this.tradeAmount = this.m_UIAmountSelector.value;
      }
      
      function set tradeAmount(param1:int) : void
      {
         if(this.m_TradeObject != null)
         {
            param1 = Math.max(0,Math.min(param1,this.m_TradeObject.amount));
         }
         else
         {
            param1 = 0;
         }
         if(this.m_TradeAmount != param1)
         {
            this.m_TradeAmount = param1;
            this.m_UncommittedTradeAmount = true;
            this.invalidateObjectSummary();
            invalidateProperties();
         }
      }
      
      function get containerStorage() : ContainerStorage
      {
         return this.m_ContainerStorage;
      }
      
      override function releaseInstance() : void
      {
         super.releaseInstance();
         this.m_UITradeMode.removeEventListener(ItemClickEvent.ITEM_CLICK,this.onModeChange);
         this.m_UIObjectLayout.removeEventListener(MouseEvent.CLICK,this.onLayoutChange);
         this.m_UIAmountSelector.removeEventListener(Event.CHANGE,this.onAmountChange);
         this.m_UIButtonCommit.removeEventListener(MouseEvent.CLICK,this.onButtonCommit);
         this.m_UIObjectSelector.removeEventListener(Event.CHANGE,this.onObjectChange);
      }
      
      function get buyObjects() : IList
      {
         return this.m_BuyObjects;
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
            if(this.m_Player != null)
            {
               this.m_Player.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onPlayerChange);
            }
            this.m_UncommittedPlayer = true;
            this.invalidateObjectAmounts();
            this.invalidateObjectSummary();
            invalidateProperties();
         }
      }
      
      function get tradeObject() : TradeObjectRef
      {
         return this.m_TradeObject;
      }
      
      function set sellObjects(param1:IList) : void
      {
         if(this.m_SellObjects != param1)
         {
            this.m_SellObjects = param1;
            this.m_UncommittedSellObjects = true;
            this.invalidateObjectAmounts();
            this.invalidateObjectSummary();
            invalidateProperties();
         }
      }
      
      override protected function commitProperties() : void
      {
         if(this.m_UncommittedAppearanceStorage)
         {
            this.m_UncommittedAppearanceStorage = false;
         }
         if(this.m_UncommittedContainerStorage)
         {
            this.m_UncommittedContainerStorage = false;
         }
         if(this.m_UncommittedPlayer)
         {
            this.m_UncommittedPlayer = false;
         }
         if(this.m_UncommittedNPCName)
         {
            titleText = this.getTitleLabel();
            this.m_UncommittedNPCName = false;
         }
         if(this.m_UncommittedBuyObjects)
         {
            if(this.m_TradeMode == MODE_BUY)
            {
               this.tradeAmount = 0;
               this.tradeObject = null;
               this.m_UIObjectSelector.dataProvider = this.m_BuyObjects;
            }
            this.m_UncommittedBuyObjects = false;
         }
         if(this.m_UncommittedCategories)
         {
            this.m_UICategorySelector.dataProvider = this.m_Categories;
            this.m_UICategorySelector.includeInLayout = this.m_Categories != null;
            this.m_UICategorySelector.visible = this.m_Categories != null;
            this.m_UncommittedCategories = false;
         }
         if(this.m_UncommittedSellObjects)
         {
            if(this.m_TradeMode != MODE_BUY)
            {
               this.tradeAmount = 0;
               this.tradeObject = null;
               this.m_UIObjectSelector.dataProvider = this.m_SellObjects;
            }
            this.m_UncommittedSellObjects = false;
         }
         if(this.m_UncommittedTradeMode)
         {
            this.tradeAmount = 0;
            this.tradeObject = null;
            this.m_UIObjectSelector.dataProvider = this.tradeMode == MODE_BUY?this.m_BuyObjects:this.m_SellObjects;
            this.m_UIObjectSelector.tradeMode = this.tradeMode;
            this.m_UITradeMode.selectedIndex = this.getTradeModeIndex();
            this.m_UncommittedTradeMode = false;
         }
         if(this.m_InvalidObjectAmounts)
         {
            this.updateObjectAmounts();
            this.tradeAmount = Math.max(1,this.tradeAmount);
            this.m_InvalidObjectAmounts = false;
         }
         if(this.m_InvalidObjectSummary)
         {
            this.updateObjectSummary();
            this.m_InvalidObjectSummary = false;
         }
         if(this.m_UncommittedTradeAmount)
         {
            this.m_UIAmountSelector.value = this.tradeAmount;
            this.m_UncommittedTradeAmount = false;
         }
         if(this.m_UncommittedTradeObject)
         {
            this.m_UIObjectSelector.selectedObject = this.tradeObject;
            this.m_UncommittedTradeObject = false;
         }
         super.commitProperties();
      }
      
      function get tradeAmount() : int
      {
         return this.m_TradeAmount;
      }
      
      function get player() : Player
      {
         return this.m_Player;
      }
      
      private function getTradeModeIndex(param1:int = -1) : int
      {
         if(param1 == -1)
         {
            param1 = this.m_TradeMode;
         }
         if(param1 != MODE_BUY && param1 != MODE_SELL)
         {
            param1 = MODE_BUY;
         }
         var _loc2_:int = UI_TRADE_MODE.length - 1;
         while(_loc2_ >= 0)
         {
            if(UI_TRADE_MODE[_loc2_].mode == param1)
            {
               return _loc2_;
            }
            _loc2_--;
         }
         return 0;
      }
      
      protected function invalidateObjectSummary() : void
      {
         this.m_InvalidObjectSummary = true;
         invalidateProperties();
      }
      
      function set appearanceStorage(param1:AppearanceStorage) : void
      {
         if(this.m_AppearanceStorage != param1)
         {
            this.m_AppearanceStorage = param1;
            this.m_UncommittedAppearanceStorage = true;
            this.invalidateObjectAmounts();
            this.invalidateObjectSummary();
            invalidateProperties();
         }
      }
      
      private function getMaxBuyAmount(param1:TradeObjectRef) : uint
      {
         var _loc4_:AppearanceType = null;
         var _loc5_:Boolean = false;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:uint = 0;
         var _loc9_:uint = 0;
         var _loc10_:Number = NaN;
         var _loc2_:int = 0;
         var _loc3_:int = int.MAX_VALUE;
         if(options != null && this.m_Player != null && this.m_ContainerStorage != null && this.m_AppearanceStorage != null && param1 != null)
         {
            _loc4_ = this.m_AppearanceStorage.getObjectType(param1.ID);
            _loc5_ = _loc4_ != null && _loc4_.isCumulative;
            _loc6_ = this.m_ContainerStorage.getPlayerMoney();
            _loc7_ = this.m_Player.getSkillValue(SKILL_CARRYSTRENGTH);
            if(options.npcTradeBuyWithBackpacks)
            {
               _loc8_ = NPCTradeWidget.TRADE_BACKPACK_CAPACITY * (!!_loc5_?100:1);
               _loc9_ = NPCTradeWidget.TRADE_BACKPACK_PRICE + _loc8_ * param1.price;
               _loc10_ = NPCTradeWidget.TRADE_BACKPACK_WEIGHT + _loc8_ * param1.weight;
               _loc2_ = Math.floor(_loc6_ / _loc9_);
               _loc6_ = _loc6_ - (_loc2_ * _loc9_ + NPCTradeWidget.TRADE_BACKPACK_PRICE);
               _loc2_ = _loc2_ * _loc8_;
               if(_loc6_ > 0)
               {
                  _loc2_ = _loc2_ + Math.floor(_loc6_ / param1.price);
               }
               if(!options.npcTradeBuyIgnoreCapacity)
               {
                  _loc3_ = Math.floor(_loc7_ / _loc10_);
                  _loc7_ = _loc7_ - (_loc3_ * _loc10_ + NPCTradeWidget.TRADE_BACKPACK_WEIGHT);
                  _loc3_ = _loc3_ * _loc8_;
                  if(_loc7_ > 0)
                  {
                     _loc3_ = _loc3_ + Math.floor(_loc7_ / param1.weight);
                  }
               }
            }
            else
            {
               _loc2_ = Math.floor(_loc6_ / param1.price);
               if(!options.npcTradeBuyIgnoreCapacity)
               {
                  _loc3_ = Math.floor(_loc7_ / param1.weight);
               }
            }
         }
         return Math.max(0,Math.min(_loc2_,_loc3_,NPCTradeWidget.TRADE_MAX_AMOUNT));
      }
      
      protected function onLayoutChange(param1:Event) : void
      {
         if(options != null)
         {
            options.npcTradeLayout = options.npcTradeLayout == tibia.trade.npcTradeWidgetClasses.ObjectRefSelectorBase.LAYOUT_GRID?int(tibia.trade.npcTradeWidgetClasses.ObjectRefSelectorBase.LAYOUT_LIST):int(tibia.trade.npcTradeWidgetClasses.ObjectRefSelectorBase.LAYOUT_GRID);
            this.m_UIObjectLayout.toolTip = resourceManager.getString(BUNDLE,options.npcTradeLayout == tibia.trade.npcTradeWidgetClasses.ObjectRefSelectorBase.LAYOUT_GRID?"LAYOUT_MODE_GRID":"LAYOUT_MODE_LIST");
         }
      }
   }
}
