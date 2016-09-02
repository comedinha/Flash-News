package tibia.sidebar.sideBarWidgetClasses
{
   import mx.controls.Button;
   import tibia.creatures.Player;
   import flash.events.MouseEvent;
   import tibia.network.Communication;
   import tibia.§sidebar:ns_sidebar_internal§.options;
   import tibia.options.OptionsStorage;
   import tibia.input.staticaction.StaticActionList;
   import shared.controls.CustomButton;
   import mx.core.EventPriority;
   import mx.events.PropertyChangeEvent;
   import mx.core.EdgeMetrics;
   import mx.core.UIComponent;
   import mx.containers.BoxDirection;
   import mx.core.ScrollPolicy;
   
   public class CombatControlWidgetView extends WidgetView
   {
      
      private static const BUNDLE:String = "CombatControlWidget";
      
      private static const WIDGET_VIEW_WIDTH:Number = 176;
      
      private static const WIDGET_COMPONENT_POSITIONS:Array = [{
         "left":8,
         "top":6,
         "width":NaN,
         "height":NaN
      },{
         "left":31,
         "top":6,
         "width":NaN,
         "height":NaN
      },{
         "left":54,
         "top":6,
         "width":NaN,
         "height":NaN
      },{
         "left":8,
         "top":29,
         "width":NaN,
         "height":NaN
      },{
         "left":31,
         "top":29,
         "width":NaN,
         "height":NaN
      },{
         "left":54,
         "top":29,
         "width":NaN,
         "height":NaN
      },{
         "left":82,
         "top":11,
         "width":NaN,
         "height":NaN
      },{
         "left":18,
         "top":53,
         "width":NaN,
         "height":NaN
      },{
         "left":41,
         "top":53,
         "width":NaN,
         "height":NaN
      },{
         "left":64,
         "top":53,
         "width":NaN,
         "height":NaN
      },{
         "left":87,
         "top":53,
         "width":NaN,
         "height":NaN
      },{
         "left":134,
         "top":10,
         "width":NaN,
         "height":NaN
      }];
      
      private static const WIDGET_STYLE_EXPANDED:String = "expandedView";
      
      private static const WIDGET_VIEW_HEIGHT_EXPANDED:Number = 78;
      
      private static const WIDGET_EXPANDED_OFFSET_TOP:Number = 12;
      
      private static const WIDGET_VIEW_HEIGHT_COLLAPSED:Number = 55;
       
      
      protected var m_UIButtonMount:Button = null;
      
      protected var m_UIButtonExpertMode:Button = null;
      
      protected var m_UIButtonDove:Button = null;
      
      protected var m_Player:Player = null;
      
      protected var m_UIButtonStop:Button = null;
      
      protected var m_UIButtonYellowHand:Button = null;
      
      private var m_UncommittedPVPMode:Boolean = false;
      
      protected var m_ExpertMode:Boolean = false;
      
      private var m_UncommittedChaseMode:Boolean = true;
      
      protected var m_UIButtonBalanced:Button = null;
      
      protected var m_UIButtonWhiteHand:Button = null;
      
      private var m_UncommittedSecureMode:Boolean = true;
      
      protected var m_ChaseMode:int = 0;
      
      protected var m_AttackMode:int = 1;
      
      protected var m_UIButtonOffensive:Button = null;
      
      private var m_UncommittedMountMode:Boolean = true;
      
      private var m_UncommittedPlayer:Boolean = false;
      
      protected var m_UIButtonSecureMode:Button = null;
      
      protected var m_UIButtonDefensive:Button = null;
      
      protected var m_UIButtonChase:Button = null;
      
      private var m_UncommittedExpertMode:Boolean = true;
      
      protected var m_MountMode:Boolean = false;
      
      protected var m_SecureMode:int = 0;
      
      protected var m_PVPMode:uint = 1;
      
      private var m_UncommittedAttackMode:Boolean = true;
      
      protected var m_UIButtonRedFist:Button = null;
      
      public function CombatControlWidgetView()
      {
         super();
         titleText = resourceManager.getString(BUNDLE,"TITLE");
         direction = BoxDirection.HORIZONTAL;
         horizontalScrollPolicy = ScrollPolicy.OFF;
         verticalScrollPolicy = ScrollPolicy.OFF;
      }
      
      function get attackMode() : int
      {
         return this.m_AttackMode;
      }
      
      function get expertMode() : Boolean
      {
         return this.m_ExpertMode;
      }
      
      private function onButtonClick(param1:MouseEvent) : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:Communication = null;
         if(options != null)
         {
            param1.preventDefault();
            param1.stopImmediatePropagation();
            _loc2_ = false;
            if(param1.currentTarget == this.m_UIButtonOffensive)
            {
               options.combatAttackMode = OptionsStorage.COMBAT_ATTACK_OFFENSIVE;
               _loc2_ = true;
            }
            else if(param1.currentTarget == this.m_UIButtonBalanced)
            {
               options.combatAttackMode = OptionsStorage.COMBAT_ATTACK_BALANCED;
               _loc2_ = true;
            }
            else if(param1.currentTarget == this.m_UIButtonDefensive)
            {
               options.combatAttackMode = OptionsStorage.COMBAT_ATTACK_DEFENSIVE;
               _loc2_ = true;
            }
            else if(param1.currentTarget == this.m_UIButtonChase)
            {
               options.combatChaseMode = options.combatChaseMode == OptionsStorage.COMBAT_CHASE_ON?int(OptionsStorage.COMBAT_CHASE_OFF):int(OptionsStorage.COMBAT_CHASE_ON);
               _loc2_ = true;
            }
            else if(param1.currentTarget == this.m_UIButtonMount)
            {
               StaticActionList.PLAYER_MOUNT.perform();
            }
            else if(param1.currentTarget == this.m_UIButtonDove)
            {
               options.combatPVPMode = OptionsStorage.COMBAT_PVP_MODE_DOVE;
               _loc2_ = true;
            }
            else if(param1.currentTarget == this.m_UIButtonWhiteHand)
            {
               options.combatPVPMode = OptionsStorage.COMBAT_PVP_MODE_WHITE_HAND;
               _loc2_ = true;
            }
            else if(param1.currentTarget == this.m_UIButtonYellowHand)
            {
               options.combatPVPMode = OptionsStorage.COMBAT_PVP_MODE_YELLOW_HAND;
               _loc2_ = true;
            }
            else if(param1.currentTarget == this.m_UIButtonRedFist)
            {
               options.combatPVPMode = OptionsStorage.COMBAT_PVP_MODE_RED_FIST;
               _loc2_ = true;
            }
            else if(param1.currentTarget == this.m_UIButtonSecureMode)
            {
               options.combatSecureMode = options.combatSecureMode == OptionsStorage.COMBAT_SECURE_ON?int(OptionsStorage.COMBAT_SECURE_OFF):int(OptionsStorage.COMBAT_SECURE_ON);
               _loc2_ = true;
            }
            else if(param1.currentTarget == this.m_UIButtonStop)
            {
               StaticActionList.PLAYER_CANCEL.perform();
            }
            else if(param1.currentTarget == this.m_UIButtonExpertMode && this.m_UIButtonExpertMode.enabled)
            {
               this.expertMode = !this.expertMode;
               if(!this.expertMode)
               {
                  options.combatPVPMode = OptionsStorage.COMBAT_PVP_MODE_DOVE;
                  _loc2_ = true;
               }
            }
            _loc3_ = null;
            if(_loc2_ && (_loc3_ = Tibia.s_GetCommunication()) != null && _loc3_.isGameRunning)
            {
               _loc3_.sendCSETTACTICS(m_Options.combatAttackMode,m_Options.combatChaseMode,m_Options.combatSecureMode,m_Options.combatPVPMode);
            }
         }
      }
      
      function set attackMode(param1:int) : void
      {
         if(this.m_AttackMode != param1)
         {
            this.m_AttackMode = param1;
            this.m_UncommittedAttackMode = true;
            invalidateProperties();
         }
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this.m_UIButtonChase = new CustomButton();
         this.m_UIButtonChase.selected = this.chaseMode == OptionsStorage.COMBAT_CHASE_ON;
         this.m_UIButtonChase.styleName = getStyle("buttonChaseStyle");
         this.m_UIButtonChase.toggle = true;
         this.m_UIButtonChase.toolTip = resourceManager.getString(BUNDLE,"TIP_CHASE");
         this.m_UIButtonChase.addEventListener(MouseEvent.CLICK,this.onButtonClick,false,EventPriority.DEFAULT + 1,false);
         addChild(this.m_UIButtonChase);
         this.m_UIButtonMount = new CustomButton();
         this.m_UIButtonMount.selected = this.mountMode;
         this.m_UIButtonMount.styleName = getStyle("buttonMountStyle");
         this.m_UIButtonMount.toggle = true;
         this.m_UIButtonMount.toolTip = resourceManager.getString(BUNDLE,"TIP_MOUNT");
         this.m_UIButtonMount.addEventListener(MouseEvent.CLICK,this.onButtonClick,false,EventPriority.DEFAULT + 1,false);
         addChild(this.m_UIButtonMount);
         this.m_UIButtonExpertMode = new CustomButton();
         this.m_UIButtonExpertMode.styleName = getStyle("buttonExpertModeStyle");
         this.m_UIButtonExpertMode.toggle = true;
         this.m_UIButtonExpertMode.toolTip = resourceManager.getString(BUNDLE,"TIP_EXPERT_MODE");
         this.m_UIButtonExpertMode.addEventListener(MouseEvent.CLICK,this.onButtonClick,false,EventPriority.DEFAULT + 1,false);
         this.m_UIButtonExpertMode.enabled = m_Options.uiHints.expertModeButtonEnabled;
         addChild(this.m_UIButtonExpertMode);
         this.m_UIButtonOffensive = new CustomButton();
         this.m_UIButtonOffensive.selected = this.attackMode == OptionsStorage.COMBAT_ATTACK_OFFENSIVE;
         this.m_UIButtonOffensive.styleName = getStyle("buttonOffensiveStyle");
         this.m_UIButtonOffensive.toggle = true;
         this.m_UIButtonOffensive.toolTip = resourceManager.getString(BUNDLE,"TIP_ATTACK_OFFENSIVE");
         this.m_UIButtonOffensive.addEventListener(MouseEvent.CLICK,this.onButtonClick,false,EventPriority.DEFAULT + 1,false);
         addChild(this.m_UIButtonOffensive);
         this.m_UIButtonBalanced = new CustomButton();
         this.m_UIButtonBalanced.selected = this.attackMode == OptionsStorage.COMBAT_ATTACK_BALANCED;
         this.m_UIButtonBalanced.styleName = getStyle("buttonBalancedStyle");
         this.m_UIButtonBalanced.toggle = true;
         this.m_UIButtonBalanced.toolTip = resourceManager.getString(BUNDLE,"TIP_ATTACK_BALANCED");
         this.m_UIButtonBalanced.addEventListener(MouseEvent.CLICK,this.onButtonClick,false,EventPriority.DEFAULT + 1,false);
         addChild(this.m_UIButtonBalanced);
         this.m_UIButtonDefensive = new CustomButton();
         this.m_UIButtonDefensive.selected = this.attackMode == OptionsStorage.COMBAT_ATTACK_DEFENSIVE;
         this.m_UIButtonDefensive.styleName = getStyle("buttonDefensiveStyle");
         this.m_UIButtonDefensive.toggle = true;
         this.m_UIButtonDefensive.toolTip = resourceManager.getString(BUNDLE,"TIP_ATTACK_DEFENSIVE");
         this.m_UIButtonDefensive.addEventListener(MouseEvent.CLICK,this.onButtonClick,false,EventPriority.DEFAULT + 1,false);
         addChild(this.m_UIButtonDefensive);
         this.m_UIButtonSecureMode = new CustomButton();
         this.m_UIButtonSecureMode.selected = this.secureMode == OptionsStorage.COMBAT_SECURE_ON;
         this.m_UIButtonSecureMode.styleName = getStyle("buttonSecureStyle");
         this.m_UIButtonSecureMode.toggle = true;
         this.m_UIButtonSecureMode.toolTip = resourceManager.getString(BUNDLE,"TIP_SECURE");
         this.m_UIButtonSecureMode.addEventListener(MouseEvent.CLICK,this.onButtonClick,false,EventPriority.DEFAULT + 1,false);
         addChild(this.m_UIButtonSecureMode);
         this.m_UIButtonDove = new CustomButton();
         this.m_UIButtonDove.selected = this.m_PVPMode == OptionsStorage.COMBAT_PVP_MODE_DOVE;
         this.m_UIButtonDove.styleName = getStyle("buttonDoveStyle");
         this.m_UIButtonDove.toggle = true;
         this.m_UIButtonDove.toolTip = resourceManager.getString(BUNDLE,"TIP_PVP_MODE_DOVE");
         this.m_UIButtonDove.addEventListener(MouseEvent.CLICK,this.onButtonClick,false,EventPriority.DEFAULT + 1,false);
         addChild(this.m_UIButtonDove);
         this.m_UIButtonWhiteHand = new CustomButton();
         this.m_UIButtonWhiteHand.selected = this.m_PVPMode == OptionsStorage.COMBAT_PVP_MODE_WHITE_HAND;
         this.m_UIButtonWhiteHand.styleName = getStyle("buttonWhiteHandStyle");
         this.m_UIButtonWhiteHand.toggle = true;
         this.m_UIButtonWhiteHand.toolTip = resourceManager.getString(BUNDLE,"TIP_PVP_MODE_WHITE_HAND");
         this.m_UIButtonWhiteHand.addEventListener(MouseEvent.CLICK,this.onButtonClick,false,EventPriority.DEFAULT + 1,false);
         addChild(this.m_UIButtonWhiteHand);
         this.m_UIButtonYellowHand = new CustomButton();
         this.m_UIButtonYellowHand.selected = this.m_PVPMode == OptionsStorage.COMBAT_PVP_MODE_YELLOW_HAND;
         this.m_UIButtonYellowHand.styleName = getStyle("buttonYellowHandStyle");
         this.m_UIButtonYellowHand.toggle = true;
         this.m_UIButtonYellowHand.toolTip = resourceManager.getString(BUNDLE,"TIP_PVP_MODE_YELLOW_HAND");
         this.m_UIButtonYellowHand.addEventListener(MouseEvent.CLICK,this.onButtonClick,false,EventPriority.DEFAULT + 1,false);
         addChild(this.m_UIButtonYellowHand);
         this.m_UIButtonRedFist = new CustomButton();
         this.m_UIButtonRedFist.selected = this.m_PVPMode == OptionsStorage.COMBAT_PVP_MODE_RED_FIST;
         this.m_UIButtonRedFist.styleName = getStyle("buttonRedFistStyle");
         this.m_UIButtonRedFist.toggle = true;
         this.m_UIButtonRedFist.toolTip = resourceManager.getString(BUNDLE,"TIP_PVP_MODE_RED_FIST");
         this.m_UIButtonRedFist.addEventListener(MouseEvent.CLICK,this.onButtonClick,false,EventPriority.DEFAULT + 1,false);
         addChild(this.m_UIButtonRedFist);
         this.m_UIButtonStop = new CustomButton();
         this.m_UIButtonStop.styleName = getStyle("buttonStopStyle");
         this.m_UIButtonStop.toolTip = resourceManager.getString(BUNDLE,"TIP_STOP");
         this.m_UIButtonStop.addEventListener(MouseEvent.CLICK,this.onButtonClick);
         addChild(this.m_UIButtonStop);
      }
      
      function get chaseMode() : int
      {
         return this.m_ChaseMode;
      }
      
      function get secureMode() : int
      {
         return this.m_SecureMode;
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
      
      override function releaseInstance() : void
      {
         super.releaseInstance();
         this.m_UIButtonBalanced.removeEventListener(MouseEvent.CLICK,this.onButtonClick);
         this.m_UIButtonChase.removeEventListener(MouseEvent.CLICK,this.onButtonClick);
         this.m_UIButtonDefensive.removeEventListener(MouseEvent.CLICK,this.onButtonClick);
         this.m_UIButtonMount.removeEventListener(MouseEvent.CLICK,this.onButtonClick);
         this.m_UIButtonOffensive.removeEventListener(MouseEvent.CLICK,this.onButtonClick);
         this.m_UIButtonSecureMode.removeEventListener(MouseEvent.CLICK,this.onButtonClick);
         this.m_UIButtonStop.removeEventListener(MouseEvent.CLICK,this.onButtonClick);
         this.m_UIButtonDove.removeEventListener(MouseEvent.CLICK,this.onButtonClick);
         this.m_UIButtonWhiteHand.removeEventListener(MouseEvent.CLICK,this.onButtonClick);
         this.m_UIButtonYellowHand.removeEventListener(MouseEvent.CLICK,this.onButtonClick);
         this.m_UIButtonRedFist.removeEventListener(MouseEvent.CLICK,this.onButtonClick);
         this.m_UIButtonExpertMode.removeEventListener(MouseEvent.CLICK,this.onButtonClick);
      }
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
         if(this.m_UncommittedPlayer)
         {
            this.mountMode = this.m_Player != null && this.m_Player.mountOutfit != null;
            this.m_UncommittedPlayer = false;
         }
         if(this.m_UncommittedAttackMode)
         {
            this.m_UIButtonOffensive.selected = this.attackMode == OptionsStorage.COMBAT_ATTACK_OFFENSIVE;
            this.m_UIButtonBalanced.selected = this.attackMode == OptionsStorage.COMBAT_ATTACK_BALANCED;
            this.m_UIButtonDefensive.selected = this.attackMode == OptionsStorage.COMBAT_ATTACK_DEFENSIVE;
            this.m_UncommittedAttackMode = false;
         }
         if(this.m_UncommittedChaseMode)
         {
            this.m_UIButtonChase.selected = this.chaseMode == OptionsStorage.COMBAT_CHASE_ON;
            this.m_UncommittedChaseMode = false;
         }
         if(this.m_UncommittedMountMode)
         {
            this.m_UIButtonMount.selected = this.mountMode;
            this.m_UncommittedMountMode = false;
         }
         if(this.m_UncommittedSecureMode)
         {
            this.m_UIButtonSecureMode.selected = this.secureMode == OptionsStorage.COMBAT_SECURE_OFF;
            this.m_UIButtonSecureMode.toolTip = this.secureMode == OptionsStorage.COMBAT_SECURE_OFF?resourceManager.getString(BUNDLE,"TIP_SECURE_OFF"):resourceManager.getString(BUNDLE,"TIP_SECURE_ON");
            this.m_UncommittedSecureMode = false;
         }
         if(this.m_UncommittedPVPMode)
         {
            this.m_UIButtonDove.selected = this.m_PVPMode == OptionsStorage.COMBAT_PVP_MODE_DOVE;
            this.m_UIButtonWhiteHand.selected = this.m_PVPMode == OptionsStorage.COMBAT_PVP_MODE_WHITE_HAND;
            this.m_UIButtonYellowHand.selected = this.m_PVPMode == OptionsStorage.COMBAT_PVP_MODE_YELLOW_HAND;
            this.m_UIButtonRedFist.selected = this.m_PVPMode == OptionsStorage.COMBAT_PVP_MODE_RED_FIST;
            this.m_UncommittedPVPMode = false;
         }
         if(this.m_UncommittedExpertMode)
         {
            this.m_UIButtonExpertMode.selected = m_Options != null && m_Options.uiHints.expertModeButtonEnabled && this.m_ExpertMode;
            styleName = !!this.m_ExpertMode?WIDGET_STYLE_EXPANDED:"";
            invalidateSize();
            invalidateDisplayList();
            this.m_UncommittedExpertMode = false;
         }
      }
      
      function set mountMode(param1:Boolean) : void
      {
         if(this.m_MountMode != param1)
         {
            this.m_MountMode = param1;
            this.m_UncommittedMountMode = true;
            invalidateProperties();
         }
      }
      
      function set pvpMode(param1:uint) : void
      {
         if(this.m_PVPMode != param1)
         {
            this.m_PVPMode = param1;
            this.m_UncommittedPVPMode = true;
            invalidateProperties();
         }
      }
      
      function get mountMode() : Boolean
      {
         return this.m_MountMode;
      }
      
      function get player() : Player
      {
         return this.m_Player;
      }
      
      function set chaseMode(param1:int) : void
      {
         if(this.m_ChaseMode != param1)
         {
            this.m_ChaseMode = param1;
            this.m_UncommittedChaseMode = true;
            invalidateProperties();
         }
      }
      
      override protected function measure() : void
      {
         super.measure();
         var _loc1_:EdgeMetrics = viewMetricsAndPadding;
         measuredMinWidth = measuredWidth = _loc1_.left + WIDGET_VIEW_WIDTH + _loc1_.right;
         measuredMinHeight = measuredHeight = _loc1_.top + (!!this.m_ExpertMode?WIDGET_VIEW_HEIGHT_EXPANDED:WIDGET_VIEW_HEIGHT_COLLAPSED) + _loc1_.bottom;
      }
      
      override protected function commitOptions() : void
      {
         super.commitOptions();
         if(options != null)
         {
            this.attackMode = options.combatAttackMode;
            this.chaseMode = options.combatChaseMode;
            this.secureMode = options.combatSecureMode;
            this.pvpMode = options.combatPVPMode;
         }
         else
         {
            this.attackMode = OptionsStorage.COMBAT_ATTACK_OFFENSIVE;
            this.chaseMode = OptionsStorage.COMBAT_CHASE_OFF;
            this.secureMode = OptionsStorage.COMBAT_SECURE_ON;
            this.pvpMode = OptionsStorage.COMBAT_PVP_MODE_DOVE;
         }
      }
      
      function set expertMode(param1:Boolean) : void
      {
         if(this.m_ExpertMode != param1)
         {
            this.m_ExpertMode = param1;
            this.m_UncommittedExpertMode = true;
            invalidateProperties();
         }
      }
      
      function get pvpMode() : uint
      {
         return this.m_PVPMode;
      }
      
      private function onPlayerChange(param1:PropertyChangeEvent) : void
      {
         if(param1.property == "*" || param1.property == "mountOutfit")
         {
            this.mountMode = this.m_Player.mountOutfit != null;
         }
      }
      
      override protected function onOptionsChange(param1:PropertyChangeEvent) : void
      {
         super.onOptionsChange(param1);
         if(param1.property == "*" || param1.property == "combatAttackMode")
         {
            this.attackMode = m_Options.combatAttackMode;
         }
         if(param1.property == "*" || param1.property == "combatChaseMode")
         {
            this.chaseMode = m_Options.combatChaseMode;
         }
         if(param1.property == "*" || param1.property == "combatSecureMode")
         {
            this.secureMode = m_Options.combatSecureMode;
         }
         if(param1.property == "*" || param1.property == "combatPVPMode")
         {
            this.pvpMode = m_Options.combatPVPMode;
         }
         if(param1.property == "*" || param1.property == "uiHints")
         {
            this.m_UIButtonExpertMode.enabled = m_Options.uiHints.expertModeButtonEnabled;
            if(!m_Options.uiHints.expertModeButtonEnabled)
            {
               this.expertMode = false;
            }
         }
      }
      
      function set secureMode(param1:int) : void
      {
         if(this.m_SecureMode != param1)
         {
            this.m_SecureMode = param1;
            this.m_UncommittedSecureMode = true;
            invalidateProperties();
         }
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         var _loc4_:UIComponent = null;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         super.updateDisplayList(param1,param2);
         var _loc3_:int = 0;
         while(_loc3_ < WIDGET_COMPONENT_POSITIONS.length)
         {
            _loc4_ = UIComponent(getChildAt(_loc3_));
            _loc5_ = !isNaN(WIDGET_COMPONENT_POSITIONS[_loc3_].height)?Number(WIDGET_COMPONENT_POSITIONS[_loc3_].height):Number(_loc4_.getExplicitOrMeasuredHeight());
            _loc6_ = !isNaN(WIDGET_COMPONENT_POSITIONS[_loc3_].width)?Number(WIDGET_COMPONENT_POSITIONS[_loc3_].width):Number(_loc4_.getExplicitOrMeasuredWidth());
            _loc7_ = WIDGET_COMPONENT_POSITIONS[_loc3_].top;
            if(this.m_ExpertMode && _loc4_ == this.m_UIButtonStop)
            {
               _loc7_ = _loc7_ + WIDGET_EXPANDED_OFFSET_TOP;
            }
            else if(!this.m_ExpertMode && (_loc4_ == this.m_UIButtonDove || _loc4_ == this.m_UIButtonWhiteHand || _loc4_ == this.m_UIButtonYellowHand || _loc4_ == this.m_UIButtonRedFist))
            {
               _loc7_ = _loc7_ + WIDGET_EXPANDED_OFFSET_TOP;
            }
            _loc4_.move(WIDGET_COMPONENT_POSITIONS[_loc3_].left,_loc7_);
            _loc4_.setActualSize(_loc6_,_loc5_);
            _loc3_++;
         }
      }
   }
}
