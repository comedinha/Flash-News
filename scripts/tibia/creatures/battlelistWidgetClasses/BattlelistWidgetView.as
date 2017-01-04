package tibia.creatures.battlelistWidgetClasses
{
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import mx.collections.IList;
   import mx.containers.HBox;
   import mx.controls.Button;
   import mx.controls.listClasses.IListItemRenderer;
   import mx.core.ScrollPolicy;
   import mx.events.ListEvent;
   import mx.events.PropertyChangeEvent;
   import shared.controls.CustomButton;
   import shared.controls.SmoothList;
   import shared.utility.Vector3D;
   import tibia.appearances.AppearanceInstance;
   import tibia.appearances.AppearanceStorage;
   import tibia.appearances.ObjectInstance;
   import tibia.container.containerViewWidgetClasses.ContainerSlot;
   import tibia.creatures.Creature;
   import tibia.creatures.CreatureStorage;
   import tibia.cursors.CursorHelper;
   import tibia.game.IUseWidget;
   import tibia.help.UIEffectsRetrieveComponentCommandEvent;
   import tibia.input.InputHandler;
   import tibia.input.ModifierKeyEvent;
   import tibia.input.MouseActionHelper;
   import tibia.input.MouseClickBothEvent;
   import tibia.input.mapping.MouseBinding;
   import tibia.network.Communication;
   import tibia.options.OptionsStorage;
   import tibia.sidebar.sideBarWidgetClasses.WidgetView;
   import tibia.§sidebar:ns_sidebar_internal§.widgetCollapsed;
   
   public class BattlelistWidgetView extends WidgetView implements IUseWidget
   {
      
      private static const ACTION_UNSET:int = -1;
      
      private static const MOUSE_BUTTON_LEFT:int = 1;
      
      private static const MOUSE_BUTTON_BOTH:int = 4;
      
      private static const ACTION_USE_OR_OPEN:int = 101;
      
      private static const ACTION_SMARTCLICK:int = 100;
      
      private static const MOUSE_BUTTON_RIGHT:int = 2;
      
      private static const ACTION_LOOK:int = 6;
      
      private static const BUNDLE:String = "BattlelistWidget";
      
      private static const ACTION_TALK:int = 9;
      
      private static const VALID_ACTIONS:Vector.<uint> = Vector.<uint>([ACTION_ATTACK,ACTION_TALK,ACTION_LOOK,ACTION_CONTEXT_MENU]);
      
      private static const ACTION_USE:int = 7;
      
      private static const MOUSE_BUTTON_MIDDLE:int = 3;
      
      private static const ACTION_NONE:int = 0;
      
      private static const ACTION_AUTOWALK:int = 3;
      
      private static const OPPONENT_FILTER_MODES:Array = [{
         "value":CreatureStorage.FILTER_PLAYER,
         "style":"hidePlayerButtonStyle",
         "tip":"TIP_HIDE_PLAYER"
      },{
         "value":CreatureStorage.FILTER_NPC,
         "style":"hideNPCButtonStyle",
         "tip":"TIP_HIDE_NPC"
      },{
         "value":CreatureStorage.FILTER_MONSTER,
         "style":"hideMonsterButtonStyle",
         "tip":"TIP_HIDE_MONSTER"
      },{
         "value":CreatureStorage.FILTER_NON_SKULLED,
         "style":"hideNonSkulledButtonStyle",
         "tip":"TIP_HIDE_NON_SKULLED"
      },{
         "value":CreatureStorage.FILTER_PARTY,
         "style":"hidePartyButtonStyle",
         "tip":"TIP_HIDE_PARTY"
      }];
      
      private static const ACTION_ATTACK:int = 1;
      
      private static const ACTION_OPEN:int = 8;
      
      private static const ACTION_AUTOWALK_HIGHLIGHT:int = 4;
      
      private static const ACTION_CONTEXT_MENU:int = 5;
      
      private static const ACTION_ATTACK_OR_TALK:int = 102;
       
      
      private var m_MouseCursorOverWidget:Boolean = false;
      
      protected var m_Opponents:IList = null;
      
      protected var m_CreatureStorage:CreatureStorage = null;
      
      private var m_CursorHelper:CursorHelper;
      
      private var m_RolloverCreature:Creature = null;
      
      protected var m_UIFilterButtons:Vector.<Button>;
      
      protected var m_UIList:SmoothList = null;
      
      private var m_UncommittedOpponents:Boolean = false;
      
      private var m_UncommittedCreatureStorage:Boolean = false;
      
      private var m_UIConstructed:Boolean = false;
      
      private var m_InvalidFilter:Boolean = false;
      
      public function BattlelistWidgetView()
      {
         this.m_UIFilterButtons = new Vector.<Button>();
         this.m_CursorHelper = new CursorHelper();
         super();
         titleText = resourceManager.getString(BUNDLE,"TITLE");
         verticalScrollPolicy = ScrollPolicy.OFF;
         horizontalScrollPolicy = ScrollPolicy.OFF;
         maxHeight = int.MAX_VALUE;
         addEventListener(MouseEvent.CLICK,this.onItemClick);
         addEventListener(MouseEvent.RIGHT_CLICK,this.onItemClick);
         addEventListener(MouseEvent.MIDDLE_CLICK,this.onItemClick);
         Tibia.s_GetUIEffectsManager().addEventListener(UIEffectsRetrieveComponentCommandEvent.GET_UI_COMPONENT,this.onUIEffectsCommandEvent);
         Tibia.s_GetInputHandler().addEventListener(ModifierKeyEvent.MODIFIER_KEYS_CHANGED,this.onModifierKeyEvent);
      }
      
      public static function s_ClearCreatureCache(param1:String) : void
      {
         if(BattlelistItemRenderer.s_NameCache != null)
         {
            BattlelistItemRenderer.s_NameCache.removeItem(param1);
         }
      }
      
      override function releaseInstance() : void
      {
         var _loc1_:Button = null;
         super.releaseInstance();
         removeEventListener(MouseEvent.CLICK,this.onItemClick);
         removeEventListener(MouseEvent.RIGHT_CLICK,this.onItemClick);
         removeEventListener(MouseEvent.MIDDLE_CLICK,this.onItemClick);
         Tibia.s_GetUIEffectsManager().removeEventListener(UIEffectsRetrieveComponentCommandEvent.GET_UI_COMPONENT,this.onUIEffectsCommandEvent);
         Tibia.s_GetInputHandler().removeEventListener(ModifierKeyEvent.MODIFIER_KEYS_CHANGED,this.onModifierKeyEvent);
         for each(_loc1_ in this.m_UIFilterButtons)
         {
            _loc1_.removeEventListener(MouseEvent.CLICK,this.onFilterModeChange);
         }
         this.m_UIList.removeEventListener(ListEvent.ITEM_ROLL_OVER,this.onItemRollOver);
         this.m_UIList.removeEventListener(ListEvent.ITEM_ROLL_OUT,this.onItemRollOut);
      }
      
      protected function invalidateFilter() : void
      {
         this.m_InvalidFilter = true;
         invalidateProperties();
      }
      
      override protected function commitProperties() : void
      {
         var _loc1_:Button = null;
         super.commitProperties();
         if(this.m_UncommittedCreatureStorage)
         {
            this.m_UncommittedCreatureStorage = false;
         }
         if(this.m_UncommittedOpponents)
         {
            this.m_UIList.dataProvider = this.m_Opponents;
            this.m_UncommittedOpponents = false;
         }
         if(this.m_InvalidFilter)
         {
            for each(_loc1_ in this.m_UIFilterButtons)
            {
               _loc1_.selected = m_Options != null && (m_Options.opponentFilter & int(_loc1_.data)) > 0;
            }
            this.m_InvalidFilter = false;
         }
         if(this.m_RolloverCreature != null)
         {
            this.determineAction(null,false,true);
         }
      }
      
      public function getMultiUseObjectUnderPoint(param1:Point) : Object
      {
         return this.getUseObjectUnderPoint(param1);
      }
      
      override protected function onOptionsChange(param1:PropertyChangeEvent) : void
      {
         super.onOptionsChange(param1);
         if(param1 != null)
         {
            switch(param1.property)
            {
               case "opponentFilter":
               case "*":
                  this.invalidateFilter();
            }
         }
      }
      
      protected function onItemRollOut(param1:ListEvent) : void
      {
         this.m_MouseCursorOverWidget = false;
         this.m_CursorHelper.resetCursor();
         this.m_CreatureStorage.setAim(null);
         this.m_RolloverCreature = null;
      }
      
      override protected function commitOptions() : void
      {
         super.commitOptions();
         this.invalidateFilter();
         if(m_Options != null && BattlelistItemRenderer.s_BattlelistMarksView != null)
         {
            BattlelistItemRenderer.s_InitialiseMarksView(m_Options.statusCreaturePvpFrames);
         }
      }
      
      public function getUseObjectUnderPoint(param1:Point) : Object
      {
         var _loc2_:IList = null;
         var _loc3_:int = 0;
         var _loc4_:AppearanceStorage = null;
         var _loc5_:Creature = null;
         var _loc6_:ObjectInstance = null;
         if(this.m_CreatureStorage != null)
         {
            _loc2_ = this.m_CreatureStorage.opponents;
            _loc3_ = this.m_UIList.pointToItemIndex(param1.x,param1.y);
            _loc4_ = Tibia.s_GetAppearanceStorage();
            if(_loc3_ > -1 && _loc3_ < _loc2_.length)
            {
               _loc5_ = Creature(_loc2_.getItemAt(_loc3_));
               _loc6_ = _loc4_.createObjectInstance(AppearanceInstance.CREATURE,_loc5_.ID);
               return {
                  "object":_loc6_,
                  "absolute":null,
                  "position":-1
               };
            }
         }
         return null;
      }
      
      protected function determineAction(param1:MouseEvent, param2:Boolean = false, param3:Boolean = false) : void
      {
         var _loc11_:IListItemRenderer = null;
         var _loc12_:MouseBinding = null;
         var _loc13_:InputHandler = null;
         var _loc14_:Communication = null;
         if(this.m_MouseCursorOverWidget == false)
         {
            return;
         }
         var _loc4_:Creature = null;
         if(param1 == null)
         {
            _loc4_ = this.m_RolloverCreature;
         }
         else if(!widgetCollapsed && this.m_CreatureStorage != null)
         {
            _loc11_ = this.m_UIList.mouseEventToItemRenderer(param1);
            _loc4_ = _loc11_ != null?Creature(_loc11_.data):null;
         }
         if(_loc4_ == null)
         {
            return;
         }
         var _loc5_:ContainerSlot = null;
         var _loc6_:AppearanceInstance = null;
         var _loc7_:Vector3D = new Vector3D(0,0,0);
         var _loc8_:AppearanceInstance = null;
         var _loc9_:OptionsStorage = Tibia.s_GetOptions();
         var _loc10_:int = ACTION_NONE;
         if(_loc4_ != null)
         {
            _loc12_ = null;
            if(param1 != null)
            {
               if(param1 is MouseClickBothEvent)
               {
                  _loc12_ = _loc9_.mouseMapping.findBindingByMouseEvent(param1);
               }
               else if(param1.type == MouseEvent.CLICK && !param1.altKey && !param1.ctrlKey && !param1.shiftKey)
               {
                  _loc10_ = ACTION_ATTACK_OR_TALK;
               }
               else if(param1.type == MouseEvent.RIGHT_CLICK && !param1.altKey && !param1.ctrlKey && !param1.shiftKey)
               {
                  _loc10_ = ACTION_CONTEXT_MENU;
               }
               else
               {
                  _loc12_ = _loc9_.mouseMapping.findBindingByMouseEvent(param1);
               }
            }
            else
            {
               _loc13_ = Tibia.s_GetInputHandler();
               if(_loc13_.isModifierKeyPressed())
               {
                  _loc12_ = _loc9_.mouseMapping.findBindingForLeftMouseButtonAndPressedModifierKey();
               }
               else
               {
                  _loc10_ = ACTION_ATTACK_OR_TALK;
               }
            }
            if(_loc12_ != null)
            {
               _loc10_ = _loc12_.action;
            }
            _loc10_ = MouseActionHelper.resolveActionForAppearanceOrCreature(_loc10_,_loc4_,VALID_ACTIONS);
         }
         if(param3 && m_Options != null && m_Options.mouseMapping != null && m_Options.mouseMapping.showMouseCursorForAction)
         {
            this.m_CursorHelper.setCursor(MouseActionHelper.actionToMouseCursor(_loc10_));
         }
         if(param2)
         {
            switch(_loc10_)
            {
               case ACTION_NONE:
                  break;
               case ACTION_ATTACK:
                  if(_loc4_ != null)
                  {
                     Tibia.s_GameActionFactory.createToggleAttackTargetAction(_loc4_,true).perform();
                  }
                  break;
               case ACTION_TALK:
                  if(_loc4_ != null)
                  {
                     Tibia.s_GameActionFactory.createGreetAction(_loc4_).perform();
                  }
                  break;
               case ACTION_LOOK:
                  _loc14_ = null;
                  if(_loc4_ != null && (_loc14_ = Tibia.s_GetCommunication()) != null && _loc14_.isGameRunning)
                  {
                     _loc14_.sendCLOOKATCREATURE(_loc4_.ID);
                  }
                  break;
               case ACTION_CONTEXT_MENU:
                  if(param1 != null)
                  {
                     new BattlelistItemContextMenu(m_Options,this.m_CreatureStorage,_loc4_).display(this,param1.stageX,param1.stageY);
                  }
            }
         }
      }
      
      protected function onItemClick(param1:MouseEvent) : void
      {
         this.determineAction(param1,true,false);
      }
      
      private function onModifierKeyEvent(param1:ModifierKeyEvent) : void
      {
         this.determineAction(null,false,true);
      }
      
      protected function onItemRollOver(param1:ListEvent) : void
      {
         var _loc2_:BattlelistItemRenderer = null;
         var _loc3_:Creature = null;
         this.m_MouseCursorOverWidget = true;
         if(param1 != null && param1.itemRenderer != null && !widgetCollapsed && this.m_CreatureStorage != null)
         {
            _loc2_ = BattlelistItemRenderer(param1.itemRenderer);
            if(_loc2_ != null)
            {
               _loc3_ = _loc2_.data as Creature;
               if(_loc3_ != this.m_RolloverCreature)
               {
                  this.m_CreatureStorage.setAim(_loc3_);
                  this.m_RolloverCreature = _loc3_;
                  this.determineAction(null,false,true);
               }
            }
         }
      }
      
      protected function onFilterModeChange(param1:MouseEvent) : void
      {
         var _loc2_:Button = null;
         var _loc3_:int = 0;
         if(param1 != null && !widgetCollapsed && param1.currentTarget is Button && m_Options != null)
         {
            _loc2_ = Button(param1.currentTarget);
            _loc3_ = int(_loc2_.data);
            if(_loc2_.selected)
            {
               m_Options.opponentFilter = m_Options.opponentFilter | _loc3_;
            }
            else
            {
               m_Options.opponentFilter = m_Options.opponentFilter & ~_loc3_;
            }
         }
      }
      
      function set creatureStorage(param1:CreatureStorage) : void
      {
         if(this.m_CreatureStorage != param1)
         {
            this.m_CreatureStorage = param1;
            this.m_UncommittedCreatureStorage = true;
            if(this.m_CreatureStorage != null)
            {
               this.m_Opponents = this.m_CreatureStorage.opponents;
            }
            else
            {
               this.m_Opponents = null;
            }
            this.m_UncommittedOpponents = true;
            invalidateProperties();
         }
      }
      
      function get creatureStorage() : CreatureStorage
      {
         return this.m_CreatureStorage;
      }
      
      override protected function createChildren() : void
      {
         var _loc1_:HBox = null;
         var _loc2_:int = 0;
         var _loc3_:Button = null;
         if(!this.m_UIConstructed)
         {
            super.createChildren();
            _loc1_ = new HBox();
            _loc1_.height = 27;
            _loc1_.minHeight = 27;
            _loc1_.minWidth = NaN;
            _loc1_.percentHeight = NaN;
            _loc1_.percentWidth = 100;
            _loc1_.width = NaN;
            _loc1_.styleName = getStyle("headerBoxStyle");
            _loc2_ = 0;
            while(_loc2_ < OPPONENT_FILTER_MODES.length)
            {
               _loc3_ = new CustomButton();
               _loc3_.data = OPPONENT_FILTER_MODES[_loc2_].value;
               _loc3_.selected = m_Options != null && (m_Options.opponentFilter & OPPONENT_FILTER_MODES[_loc2_].value) > 0;
               _loc3_.styleName = getStyle(OPPONENT_FILTER_MODES[_loc2_].style);
               _loc3_.toggle = true;
               _loc3_.toolTip = resourceManager.getString(BUNDLE,OPPONENT_FILTER_MODES[_loc2_].tip);
               _loc3_.addEventListener(MouseEvent.CLICK,this.onFilterModeChange);
               this.m_UIFilterButtons.push(_loc3_);
               _loc1_.addChild(_loc3_);
               _loc2_++;
            }
            addChild(_loc1_);
            _loc1_ = new HBox();
            _loc1_.percentHeight = 100;
            _loc1_.percentWidth = 100;
            _loc1_.styleName = getStyle("listBoxStyle");
            this.m_UIList = new SmoothList(BattlelistItemRenderer,BattlelistItemRenderer.HEIGHT_HINT);
            this.m_UIList.name = "Battlelist";
            this.m_UIList.defaultItemCount = 3;
            this.m_UIList.followTailPolicy = SmoothList.FOLLOW_TAIL_OFF;
            this.m_UIList.minItemCount = 3;
            this.m_UIList.percentWidth = 100;
            this.m_UIList.percentHeight = 100;
            this.m_UIList.selectable = false;
            this.m_UIList.styleName = getStyle("listStyle");
            this.m_UIList.addEventListener(ListEvent.ITEM_ROLL_OVER,this.onItemRollOver);
            this.m_UIList.addEventListener(ListEvent.ITEM_ROLL_OUT,this.onItemRollOut);
            _loc1_.addChild(this.m_UIList);
            addChild(_loc1_);
            this.m_UIConstructed = true;
         }
      }
      
      private function onUIEffectsCommandEvent(param1:UIEffectsRetrieveComponentCommandEvent) : void
      {
         var _loc2_:Creature = null;
         var _loc3_:uint = 0;
         if(param1.type == UIEffectsRetrieveComponentCommandEvent.GET_UI_COMPONENT && param1.identifier == BattlelistWidgetView)
         {
            this.widgetCollapsed = false;
            _loc2_ = param1.subIdentifier as Creature;
            _loc3_ = 0;
            while(_loc3_ < this.m_Opponents.length)
            {
               if(this.m_Opponents[_loc3_] == _loc2_)
               {
                  param1.resultUIComponent = this.m_UIList.itemIndexToItemRenderer(_loc3_) as BattlelistItemRenderer;
                  break;
               }
               _loc3_++;
            }
         }
      }
   }
}
