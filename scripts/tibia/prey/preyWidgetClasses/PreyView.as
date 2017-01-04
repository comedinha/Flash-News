package tibia.prey.preyWidgetClasses
{
   import flash.display.DisplayObject;
   import flash.events.MouseEvent;
   import mx.containers.Box;
   import mx.containers.HBox;
   import mx.containers.VBox;
   import mx.controls.Button;
   import mx.controls.Label;
   import mx.controls.Spacer;
   import mx.controls.Text;
   import mx.events.CloseEvent;
   import mx.events.ListEvent;
   import mx.events.PropertyChangeEvent;
   import shared.controls.CustomButton;
   import shared.controls.EmbeddedDialog;
   import shared.utility.StringHelper;
   import shared.utility.i18n.i18nFormatNumber;
   import shared.utility.i18n.i18nFormatTime;
   import tibia.controls.TibiaCurrencyView;
   import tibia.creatures.statusWidgetClasses.BitmapProgressBar;
   import tibia.game.PopUpBase;
   import tibia.ingameshop.IngameShopManager;
   import tibia.ingameshop.IngameShopProduct;
   import tibia.network.Communication;
   import tibia.prey.PreyData;
   import tibia.prey.PreyManager;
   
   public class PreyView extends VBox
   {
      
      private static const BUNDLE:String = "PreyWidget";
       
      
      private var m_UncommittedMonsterSelection:Boolean = false;
      
      private var m_UIMonsterSelectionGrid:PreyMonsterSelection = null;
      
      private var m_UncommittedState:Boolean = false;
      
      private var m_UncommittedMonster:Boolean = false;
      
      private var m_UISelectMonsterButton:Button = null;
      
      private var m_UncommittedResources:Boolean = false;
      
      private var m_UncommittedBonus:Boolean = false;
      
      private var m_UIBonusRerollCost:TibiaCurrencyView = null;
      
      private var m_UIHoverHelp:Text = null;
      
      private var m_UIPreyActionBox:Box = null;
      
      private var m_UIListRerollCost:TibiaCurrencyView = null;
      
      private var m_UIRemainingTimeProgress:BitmapProgressBar = null;
      
      private var m_UILockedSpacer:Spacer = null;
      
      private var m_UIMonsterSelectRerollCost:TibiaCurrencyView = null;
      
      private var m_UIConstructed:Boolean = false;
      
      private var m_UIRerollMonsterListButton:Button = null;
      
      private var m_UIBonusRerollButton:Button = null;
      
      private var m_UITitleLabel:Label = null;
      
      private var m_ParentDialog:PopUpBase = null;
      
      private var m_UncommittedMonsterList:Boolean = false;
      
      private var m_UIUnlockWithCoinsButton:Button = null;
      
      private var m_UIMonsterDisplay:PreyMonsterDisplay = null;
      
      private var m_UIRerollMonsterListButtonSmall:Button = null;
      
      private var m_UIFreeRerollTimeSmall:BitmapProgressBar = null;
      
      private var m_UIUnlockWithPremiumButton:Button = null;
      
      private var m_UIFreeRerollTime:BitmapProgressBar = null;
      
      private var m_UIMonsterSelectionActionBox:Box = null;
      
      private var m_UncommittedTime:Boolean = false;
      
      public function PreyView(param1:PopUpBase)
      {
         super();
         width = 221;
         height = 420;
         setStyle("horizontalAlign","center");
         this.m_ParentDialog = param1;
         PreyManager.getInstance().addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onPreyManagerDataChanged);
         Tibia.s_GetPlayer().addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onPlayerDataChanged);
      }
      
      protected function updateTitleString() : void
      {
         var _loc1_:PreyData = null;
         _loc1_ = this.prey;
         var _loc2_:Boolean = _loc1_.state == PreyData.STATE_SELECTION || _loc1_.state == PreyData.STATE_SELECTION_CHANGE_MONSTER;
         if(_loc1_.state == PreyData.STATE_INACTIVE && !_loc2_)
         {
            this.m_UITitleLabel.text = resourceManager.getString(BUNDLE,"PREY_STATE_INACTIVE");
         }
         else if(_loc1_.state == PreyData.STATE_ACTIVE)
         {
            this.m_UITitleLabel.text = _loc1_.monster.monsterName;
         }
         else if(_loc2_)
         {
            this.m_UITitleLabel.text = this.m_UIMonsterSelectionGrid.selectedMonsterIndex >= 0?resourceManager.getString(BUNDLE,"PREY_STATE_SELECTED",[_loc1_.monsterList[this.m_UIMonsterSelectionGrid.selectedMonsterIndex].monsterName]):resourceManager.getString(BUNDLE,"PREY_STATE_SELECTION");
         }
         else if(_loc1_.state == PreyData.STATE_LOCKED)
         {
            this.m_UITitleLabel.text = resourceManager.getString(BUNDLE,"PREY_STATE_LOCKED");
         }
      }
      
      protected function onRerollBonusClicked(param1:MouseEvent) : void
      {
         var _loc2_:EmbeddedDialog = new EmbeddedDialog();
         _loc2_.title = resourceManager.getString(BUNDLE,"CONFIRM_BONUSREROLL_TITLE");
         if(PreyManager.getInstance().bonusRerollAmount > 1)
         {
            _loc2_.text = resourceManager.getString(BUNDLE,"CONFIRM_BONUSREROLL_TEXT",[PreyManager.getInstance().bonusRerollAmount]);
         }
         else
         {
            _loc2_.text = resourceManager.getString(BUNDLE,"CONFIRM_LAST_BONUSREROLL_TEXT");
         }
         _loc2_.buttonFlags = EmbeddedDialog.YES | EmbeddedDialog.NO;
         _loc2_.addEventListener(CloseEvent.CLOSE,this.onRerollBonusConfirmed);
         this.m_ParentDialog.embeddedDialog = _loc2_;
      }
      
      public function dispose() : void
      {
         this.data = null;
         PreyManager.getInstance().removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onPreyManagerDataChanged);
         Tibia.s_GetPlayer().removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onPlayerDataChanged);
      }
      
      protected function onPreyMonsterSelected(param1:ListEvent) : void
      {
         this.m_UncommittedMonsterSelection = true;
         invalidateProperties();
      }
      
      override protected function createChildren() : void
      {
         var _loc1_:VBox = null;
         var _loc2_:VBox = null;
         var _loc3_:VBox = null;
         if(!this.m_UIConstructed)
         {
            super.createChildren();
            this.m_UITitleLabel = new Label();
            this.m_UITitleLabel.styleName = "preyTitle";
            this.m_UITitleLabel.percentWidth = 100;
            addChild(this.m_UITitleLabel);
            this.m_UIMonsterSelectionGrid = new PreyMonsterSelection();
            this.m_UIMonsterSelectionGrid.width = this.m_UIMonsterSelectionGrid.height = this.m_UIMonsterSelectionGrid.maxColumns * 64 + 3;
            this.m_UIMonsterSelectionGrid.addEventListener(ListEvent.CHANGE,this.onPreyMonsterSelected);
            this.m_UIMonsterSelectionGrid.addEventListener(MouseEvent.MOUSE_OVER,this.onHelpTextRequested);
            this.m_UIMonsterSelectionGrid.addEventListener(MouseEvent.MOUSE_OUT,this.onClearHelpTextRequested);
            addChild(this.m_UIMonsterSelectionGrid);
            this.m_UIMonsterSelectionActionBox = new HBox();
            this.m_UIMonsterSelectionActionBox.percentWidth = 100;
            this.m_UIMonsterSelectionActionBox.styleName = "preyPaddedBox";
            addChild(this.m_UIMonsterSelectionActionBox);
            _loc1_ = new VBox();
            _loc1_.percentWidth = 100;
            this.m_UIMonsterSelectionActionBox.addChild(_loc1_);
            this.m_UIRerollMonsterListButtonSmall = new CustomButton();
            this.m_UIRerollMonsterListButtonSmall.percentWidth = 100;
            this.m_UIRerollMonsterListButtonSmall.height = 33;
            this.m_UIRerollMonsterListButtonSmall.styleName = "preyRerollListButtonSmall";
            this.m_UIRerollMonsterListButtonSmall.addEventListener(MouseEvent.CLICK,this.onRerollMonsterClicked);
            this.m_UIRerollMonsterListButtonSmall.addEventListener(MouseEvent.MOUSE_OVER,this.onHelpTextRequested);
            this.m_UIRerollMonsterListButtonSmall.addEventListener(MouseEvent.MOUSE_OUT,this.onClearHelpTextRequested);
            _loc1_.addChild(this.m_UIRerollMonsterListButtonSmall);
            this.m_UIFreeRerollTimeSmall = new BitmapProgressBar();
            this.m_UIFreeRerollTimeSmall.labelEnabled = true;
            this.m_UIFreeRerollTimeSmall.styleName = "preyDuration";
            this.m_UIFreeRerollTimeSmall.width = 70;
            this.m_UIFreeRerollTimeSmall.height = 22;
            this.m_UIFreeRerollTimeSmall.visible = true;
            this.m_UIFreeRerollTimeSmall.x = 60;
            this.m_UIFreeRerollTimeSmall.y = 6;
            this.m_UIFreeRerollTimeSmall.addEventListener(MouseEvent.MOUSE_OVER,this.onHelpTextRequested);
            this.m_UIFreeRerollTimeSmall.addEventListener(MouseEvent.MOUSE_OUT,this.onClearHelpTextRequested);
            _loc1_.rawChildren.addChild(this.m_UIFreeRerollTimeSmall);
            this.m_UIMonsterSelectRerollCost = new TibiaCurrencyView();
            this.m_UIMonsterSelectRerollCost.percentWidth = 100;
            this.m_UIMonsterSelectRerollCost.currencyIcon = TibiaCurrencyView.CURRENCY_ICON_GOLD_COIN;
            _loc1_.addChild(this.m_UIMonsterSelectRerollCost);
            this.m_UISelectMonsterButton = new CustomButton();
            this.m_UISelectMonsterButton.styleName = "preySelectPreyMonsterButton";
            this.m_UISelectMonsterButton.enabled = false;
            this.m_UISelectMonsterButton.width = 66;
            this.m_UISelectMonsterButton.height = 58;
            this.m_UISelectMonsterButton.addEventListener(MouseEvent.CLICK,this.onPreyMonsterSelectionConfirmed);
            this.m_UISelectMonsterButton.addEventListener(MouseEvent.MOUSE_OVER,this.onHelpTextRequested);
            this.m_UISelectMonsterButton.addEventListener(MouseEvent.MOUSE_OUT,this.onClearHelpTextRequested);
            this.m_UIMonsterSelectionActionBox.addChild(this.m_UISelectMonsterButton);
            this.m_UIMonsterDisplay = new PreyMonsterDisplay();
            this.m_UIMonsterDisplay.addEventListener(MouseEvent.MOUSE_OVER,this.onHelpTextRequested);
            this.m_UIMonsterDisplay.addEventListener(MouseEvent.MOUSE_OUT,this.onClearHelpTextRequested);
            addChild(this.m_UIMonsterDisplay);
            this.m_UIRemainingTimeProgress = new BitmapProgressBar();
            this.m_UIRemainingTimeProgress.percentWidth = 95;
            this.m_UIRemainingTimeProgress.styleName = "preyDuration";
            this.m_UIRemainingTimeProgress.labelEnabled = true;
            this.m_UIRemainingTimeProgress.addEventListener(MouseEvent.MOUSE_OVER,this.onHelpTextRequested);
            this.m_UIRemainingTimeProgress.addEventListener(MouseEvent.MOUSE_OUT,this.onClearHelpTextRequested);
            addChild(this.m_UIRemainingTimeProgress);
            this.m_UIPreyActionBox = new HBox();
            this.m_UIPreyActionBox.percentWidth = 100;
            this.m_UIPreyActionBox.styleName = "preyPaddedBox";
            addChild(this.m_UIPreyActionBox);
            _loc2_ = new VBox();
            _loc2_.percentWidth = 100;
            this.m_UIPreyActionBox.addChild(_loc2_);
            this.m_UIRerollMonsterListButton = new CustomButton();
            this.m_UIRerollMonsterListButton.percentWidth = 100;
            this.m_UIRerollMonsterListButton.height = 74;
            this.m_UIRerollMonsterListButton.styleName = "preyRerollListButton";
            this.m_UIRerollMonsterListButton.addEventListener(MouseEvent.CLICK,this.onRerollMonsterClicked);
            this.m_UIRerollMonsterListButton.addEventListener(MouseEvent.MOUSE_OVER,this.onHelpTextRequested);
            this.m_UIRerollMonsterListButton.addEventListener(MouseEvent.MOUSE_OUT,this.onClearHelpTextRequested);
            _loc2_.addChild(this.m_UIRerollMonsterListButton);
            this.m_UIFreeRerollTime = new BitmapProgressBar();
            this.m_UIFreeRerollTime.labelEnabled = true;
            this.m_UIFreeRerollTime.styleName = "preyDuration";
            this.m_UIFreeRerollTime.width = 125;
            this.m_UIFreeRerollTime.height = 22;
            this.m_UIFreeRerollTime.visible = true;
            this.m_UIFreeRerollTime.x = 5;
            this.m_UIFreeRerollTime.y = 47;
            this.m_UIFreeRerollTime.addEventListener(MouseEvent.MOUSE_OVER,this.onHelpTextRequested);
            this.m_UIFreeRerollTime.addEventListener(MouseEvent.MOUSE_OUT,this.onClearHelpTextRequested);
            _loc2_.rawChildren.addChild(this.m_UIFreeRerollTime);
            this.m_UIListRerollCost = new TibiaCurrencyView();
            this.m_UIListRerollCost.percentWidth = 100;
            this.m_UIListRerollCost.currencyIcon = TibiaCurrencyView.CURRENCY_ICON_GOLD_COIN;
            _loc2_.addChild(this.m_UIListRerollCost);
            _loc3_ = new VBox();
            this.m_UIPreyActionBox.addChild(_loc3_);
            this.m_UIBonusRerollButton = new CustomButton();
            this.m_UIBonusRerollButton.width = 66;
            this.m_UIBonusRerollButton.height = 74;
            this.m_UIBonusRerollButton.styleName = "preyRerollBonusButton";
            this.m_UIBonusRerollButton.addEventListener(MouseEvent.CLICK,this.onRerollBonusClicked);
            this.m_UIBonusRerollButton.addEventListener(MouseEvent.MOUSE_OVER,this.onHelpTextRequested);
            this.m_UIBonusRerollButton.addEventListener(MouseEvent.MOUSE_OUT,this.onClearHelpTextRequested);
            _loc3_.addChild(this.m_UIBonusRerollButton);
            this.m_UIBonusRerollCost = new TibiaCurrencyView();
            this.m_UIBonusRerollCost.width = this.m_UIBonusRerollButton.width;
            this.m_UIBonusRerollCost.currencyIcon = TibiaCurrencyView.CURRENCY_ICON_BONUS_REROLL;
            _loc3_.addChild(this.m_UIBonusRerollCost);
            this.m_UILockedSpacer = new Spacer();
            this.m_UILockedSpacer.height = 3;
            addChild(this.m_UILockedSpacer);
            this.m_UIUnlockWithCoinsButton = new CustomButton();
            this.m_UIUnlockWithCoinsButton.percentWidth = 95;
            this.m_UIUnlockWithCoinsButton.height = 50;
            this.m_UIUnlockWithCoinsButton.label = resourceManager.getString(BUNDLE,"BUTTON_UNLOCK_PERMANENTLY");
            this.m_UIUnlockWithCoinsButton.styleName = "preyUnlockPermanentlyButton";
            this.m_UIUnlockWithCoinsButton.addEventListener(MouseEvent.CLICK,this.onUnlockPreySlotRequested);
            this.m_UIUnlockWithCoinsButton.addEventListener(MouseEvent.MOUSE_OVER,this.onHelpTextRequested);
            this.m_UIUnlockWithCoinsButton.addEventListener(MouseEvent.MOUSE_OUT,this.onClearHelpTextRequested);
            addChild(this.m_UIUnlockWithCoinsButton);
            this.m_UIUnlockWithPremiumButton = new CustomButton();
            this.m_UIUnlockWithPremiumButton.percentWidth = this.m_UIUnlockWithCoinsButton.percentWidth;
            this.m_UIUnlockWithPremiumButton.height = this.m_UIUnlockWithCoinsButton.height;
            this.m_UIUnlockWithPremiumButton.label = resourceManager.getString(BUNDLE,"BUTTON_UNLOCK_TEMPORARILY");
            this.m_UIUnlockWithPremiumButton.styleName = "preyUnlockTemporarilyButton";
            this.m_UIUnlockWithPremiumButton.addEventListener(MouseEvent.CLICK,this.onUnlockPreySlotRequested);
            this.m_UIUnlockWithPremiumButton.addEventListener(MouseEvent.MOUSE_OVER,this.onHelpTextRequested);
            this.m_UIUnlockWithPremiumButton.addEventListener(MouseEvent.MOUSE_OUT,this.onClearHelpTextRequested);
            addChild(this.m_UIUnlockWithPremiumButton);
            this.m_UIHoverHelp = new Text();
            this.m_UIHoverHelp.percentHeight = 100;
            this.m_UIHoverHelp.percentWidth = 100;
            addChild(this.m_UIHoverHelp);
            this.m_UIConstructed = true;
         }
      }
      
      protected function onPreyPropertyChanged(param1:PropertyChangeEvent) : void
      {
         if(param1.property == "state")
         {
            this.m_UncommittedState = true;
         }
         else if(param1.property == "bonusType" || param1.property == "bonusValue" || param1.property == "bonusGrade")
         {
            this.m_UncommittedBonus = true;
         }
         else if(param1.property == "monster")
         {
            this.m_UncommittedMonster = true;
         }
         else if(param1.property == "monsterList")
         {
            this.m_UncommittedMonsterList = true;
         }
         else if(param1.property == "preyTimeLeft")
         {
            this.m_UncommittedTime = true;
         }
         else if(param1.property == "timeUntilFreeListReroll")
         {
            this.m_UncommittedResources = true;
            this.m_UncommittedTime = true;
         }
         invalidateProperties();
      }
      
      protected function onRerollMonsterConfirmed(param1:CloseEvent) : void
      {
         this.m_ParentDialog.embeddedDialog.removeEventListener(CloseEvent.CLOSE,this.onRerollMonsterConfirmed);
         var _loc2_:Communication = Tibia.s_GetCommunication();
         if(_loc2_ != null && this.prey != null && param1.detail == EmbeddedDialog.YES)
         {
            _loc2_.sendCPREYACTION(this.prey.id,PreyManager.PREY_ACTION_LISTREROLL,0);
         }
      }
      
      protected function get isInactive() : Boolean
      {
         return this.prey != null && (this.prey.state == PreyData.STATE_INACTIVE || this.prey.state == PreyData.STATE_SELECTION);
      }
      
      protected function onRerollMonsterClicked(param1:MouseEvent) : void
      {
         var _loc2_:EmbeddedDialog = new EmbeddedDialog();
         _loc2_.title = resourceManager.getString(BUNDLE,"CONFIRM_LISTREROLL_TITLE");
         if(this.prey.timeUntilFreeListReroll > 0)
         {
            _loc2_.text = resourceManager.getString(BUNDLE,"CONFIRM_LISTREROLL_GOLD",[i18nFormatNumber(PreyManager.getInstance().listRerollPrice),i18nFormatNumber(Tibia.s_GetPlayer().bankGoldBalance + Tibia.s_GetPlayer().inventoryGoldBalance)]);
         }
         else
         {
            _loc2_.text = resourceManager.getString(BUNDLE,"CONFIRM_LISTREROLL_FREE");
         }
         _loc2_.buttonFlags = EmbeddedDialog.YES | EmbeddedDialog.NO;
         _loc2_.addEventListener(CloseEvent.CLOSE,this.onRerollMonsterConfirmed);
         this.m_ParentDialog.embeddedDialog = _loc2_;
      }
      
      protected function get prey() : PreyData
      {
         return data as PreyData;
      }
      
      protected function onUnlockPreySlotRequested(param1:MouseEvent) : void
      {
         var _loc2_:int = IngameShopProduct.SERVICE_TYPE_PREY;
         if(param1.currentTarget == this.m_UIUnlockWithPremiumButton)
         {
            _loc2_ = IngameShopProduct.SERVICE_TYPE_PREMIUM;
         }
         IngameShopManager.getInstance().openShopWindow(true,_loc2_);
      }
      
      protected function updatePreyBonus() : void
      {
         this.m_UIMonsterDisplay.setBonus(this.prey.bonusType,this.prey.bonusValue,this.prey.bonusGrade);
      }
      
      protected function updatePreyState() : void
      {
         var _loc1_:PreyData = null;
         if(contains(this.m_UIMonsterDisplay))
         {
            removeChild(this.m_UIMonsterDisplay);
         }
         if(contains(this.m_UIMonsterSelectionGrid))
         {
            removeChild(this.m_UIMonsterSelectionGrid);
         }
         _loc1_ = this.prey;
         var _loc2_:Boolean = _loc1_.state == PreyData.STATE_SELECTION || _loc1_.state == PreyData.STATE_SELECTION_CHANGE_MONSTER;
         addChildAt(!!_loc2_?this.m_UIMonsterSelectionGrid:this.m_UIMonsterDisplay,1);
         this.m_UIMonsterSelectionActionBox.visible = this.m_UIMonsterSelectionActionBox.includeInLayout = _loc2_;
         this.m_UIPreyActionBox.visible = this.m_UIPreyActionBox.includeInLayout = _loc1_.state != PreyData.STATE_LOCKED && !_loc2_;
         this.m_UIRemainingTimeProgress.visible = this.m_UIRemainingTimeProgress.includeInLayout = !_loc2_;
         this.m_UIRemainingTimeProgress.labelEnabled = _loc1_.state != PreyData.STATE_LOCKED && _loc1_.state != PreyData.STATE_INACTIVE;
         this.m_UIUnlockWithCoinsButton.visible = this.m_UIUnlockWithCoinsButton.includeInLayout = _loc1_.state == PreyData.STATE_LOCKED && (_loc1_.unlockOption == PreyData.UNLOCK_PREMIUM_OR_STORE || _loc1_.unlockOption == PreyData.UNLOCK_STORE);
         this.m_UIUnlockWithPremiumButton.visible = _loc1_.state == PreyData.STATE_LOCKED && _loc1_.unlockOption == PreyData.UNLOCK_PREMIUM_OR_STORE;
         this.m_UIUnlockWithPremiumButton.includeInLayout = _loc1_.state == PreyData.STATE_LOCKED;
         this.m_UILockedSpacer.visible = this.m_UILockedSpacer.includeInLayout = this.m_UIUnlockWithCoinsButton.visible;
         this.updateTitleString();
         this.updateResourceDisplayElements();
         this.m_UIRerollMonsterListButton.styleName = !this.isInactive?"preyRerollListButton":"preyRerollListButtonReactivate";
         this.m_UIRerollMonsterListButtonSmall.styleName = !this.isInactive?"preyRerollListButtonSmall":"preyRerollListButtonReactivateSmall";
      }
      
      protected function updateTime() : void
      {
         var _loc1_:PreyData = null;
         _loc1_ = this.prey;
         this.m_UIRemainingTimeProgress.minValue = 0;
         this.m_UIRemainingTimeProgress.maxValue = PreyData.PREY_FULL_DURATION;
         this.m_UIRemainingTimeProgress.value = _loc1_.preyTimeLeft;
         this.m_UIRemainingTimeProgress.labelFormat = StringHelper.s_MillisecondsToTimeString(_loc1_.preyTimeLeft * 60 * 1000,false).slice(0,-3);
         var _loc2_:Date = new Date(0,0,0,_loc1_.timeUntilFreeListReroll / 60,_loc1_.timeUntilFreeListReroll % 60);
         this.m_UIFreeRerollTime.minValue = 0;
         this.m_UIFreeRerollTime.maxValue = _loc1_.timeUntilFreeListRerollMax;
         this.m_UIFreeRerollTime.value = _loc1_.timeUntilFreeListReroll;
         this.m_UIFreeRerollTime.labelFormat = _loc1_.timeUntilFreeListReroll == 0?resourceManager.getString(BUNDLE,"LIST_REROLL_FREE"):i18nFormatTime(_loc2_);
         this.m_UIFreeRerollTimeSmall.minValue = 0;
         this.m_UIFreeRerollTimeSmall.maxValue = _loc1_.timeUntilFreeListRerollMax;
         this.m_UIFreeRerollTimeSmall.value = _loc1_.timeUntilFreeListReroll;
         this.m_UIFreeRerollTimeSmall.labelFormat = _loc1_.timeUntilFreeListReroll == 0?resourceManager.getString(BUNDLE,"LIST_REROLL_FREE_SMALL"):i18nFormatTime(_loc2_);
      }
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
         var _loc1_:PreyData = this.prey;
         if(_loc1_ != null)
         {
            if(this.m_UncommittedState)
            {
               this.updatePreyState();
               this.m_UncommittedState = false;
            }
            if(this.m_UncommittedBonus)
            {
               this.updatePreyBonus();
               this.m_UncommittedBonus = false;
            }
            if(this.m_UncommittedMonster)
            {
               this.updatePreyMonster();
               this.m_UncommittedMonster = false;
            }
            if(this.m_UncommittedMonsterList)
            {
               this.updatePreyMonsterList();
               this.m_UncommittedMonsterList = false;
            }
         }
         if(this.m_UncommittedMonsterSelection)
         {
            this.m_UISelectMonsterButton.enabled = this.m_UIMonsterSelectionGrid.selectedMonsterIndex >= 0;
            this.updateTitleString();
            this.m_UncommittedMonsterSelection = false;
         }
         if(this.m_UncommittedResources)
         {
            this.updateResourceDisplayElements();
            this.m_UncommittedResources = false;
         }
         if(this.m_UncommittedTime)
         {
            if(_loc1_ != null)
            {
               this.updateTime();
            }
            this.m_UncommittedTime = false;
         }
      }
      
      protected function onRerollBonusConfirmed(param1:CloseEvent) : void
      {
         this.m_ParentDialog.embeddedDialog.removeEventListener(CloseEvent.CLOSE,this.onRerollBonusConfirmed);
         var _loc2_:Communication = Tibia.s_GetCommunication();
         if(_loc2_ != null && this.prey != null && param1.detail == EmbeddedDialog.YES)
         {
            _loc2_.sendCPREYACTION(this.prey.id,PreyManager.PREY_ACTION_BONUSREROLL,0);
         }
      }
      
      protected function onPreyManagerDataChanged(param1:PropertyChangeEvent) : void
      {
         this.m_UncommittedResources = true;
         invalidateProperties();
      }
      
      override public function set data(param1:Object) : void
      {
         if(this.prey != null)
         {
            this.prey.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onPreyPropertyChanged);
         }
         super.data = param1;
         if(this.prey != null)
         {
            this.prey.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onPreyPropertyChanged);
         }
         this.m_UncommittedState = true;
         this.m_UncommittedBonus = true;
         this.m_UncommittedMonster = true;
         this.m_UncommittedMonsterList = true;
         this.m_UncommittedResources = true;
         this.m_UncommittedTime = true;
         invalidateProperties();
      }
      
      protected function updatePreyMonster() : void
      {
         if(this.prey.monster != null)
         {
            this.m_UIMonsterDisplay.setMonster(this.prey.monster.monsterAppearanceInstance);
         }
         else
         {
            this.m_UIMonsterDisplay.setMonster(null);
         }
      }
      
      protected function onHelpTextRequested(param1:MouseEvent) : void
      {
         var _loc3_:Date = null;
         if(this.prey == null)
         {
            return;
         }
         var _loc2_:String = "";
         if(param1.currentTarget == this.m_UIMonsterDisplay || param1.currentTarget == this.m_UIRemainingTimeProgress)
         {
            if(this.prey.state == PreyData.STATE_LOCKED)
            {
               _loc2_ = resourceManager.getString(BUNDLE,"HELP_PREYDESCRIPTION_LOCKED");
            }
            else if(this.prey.state == PreyData.STATE_INACTIVE)
            {
               _loc2_ = resourceManager.getString(BUNDLE,"HELP_PREYDESCRIPTION_INACTIVE");
            }
            else
            {
               _loc2_ = resourceManager.getString(BUNDLE,"HELP_PREYDESCRIPTION",[this.prey.monster.monsterName,StringHelper.s_MillisecondsToTimeString(this.prey.preyTimeLeft * 60 * 1000,false).slice(0,-3),this.prey.generateBonusGradeString(),this.prey.generateBonusString(),this.prey.generateBonusDescription()]);
            }
         }
         else if(param1.currentTarget == this.m_UIUnlockWithCoinsButton)
         {
            _loc2_ = resourceManager.getString(BUNDLE,"HELP_UNLOCK_PERMANENTLY");
         }
         else if(param1.currentTarget == this.m_UIUnlockWithPremiumButton)
         {
            _loc2_ = resourceManager.getString(BUNDLE,"HELP_UNLOCK_TEMPORARILY");
         }
         else if(param1.currentTarget == this.m_UIMonsterSelectionGrid)
         {
            if(this.isInactive)
            {
               _loc2_ = resourceManager.getString(BUNDLE,"HELP_MONSTERSELECTION_REACTIVATE");
            }
            else
            {
               _loc2_ = resourceManager.getString(BUNDLE,"HELP_MONSTERSELECTION_CHANGE",[this.prey.bonusValue,this.prey.generateBonusString()]);
            }
         }
         else if(param1.currentTarget == this.m_UIRerollMonsterListButton || param1.currentTarget == this.m_UIRerollMonsterListButtonSmall)
         {
            if((param1.currentTarget as Button).enabled)
            {
               _loc2_ = resourceManager.getString(BUNDLE,"HELP_LISTREROLL");
            }
            else
            {
               _loc2_ = resourceManager.getString(BUNDLE,"HELP_LISTREROLL_NOTENOUGHGOLD");
            }
         }
         else if(param1.currentTarget == this.m_UIFreeRerollTime || param1.currentTarget == this.m_UIFreeRerollTimeSmall)
         {
            if(this.prey.timeUntilFreeListReroll == 0)
            {
               _loc2_ = resourceManager.getString(BUNDLE,"HELP_LISTREROLL_DURATION_FREE");
            }
            else
            {
               _loc3_ = new Date(0,0,0,this.prey.timeUntilFreeListReroll / 60,this.prey.timeUntilFreeListReroll % 60);
               _loc2_ = resourceManager.getString(BUNDLE,"HELP_LISTREROLL_DURATION_REMAINING",[i18nFormatTime(_loc3_)]);
            }
         }
         else if(param1.currentTarget == this.m_UIBonusRerollButton)
         {
            if(this.prey.state == PreyData.STATE_INACTIVE)
            {
               _loc2_ = resourceManager.getString(BUNDLE,"HELP_BONUSREROLL_INACTIVE");
            }
            else if((param1.currentTarget as Button).enabled)
            {
               _loc2_ = resourceManager.getString(BUNDLE,"HELP_BONUSREROLL");
            }
            else
            {
               _loc2_ = resourceManager.getString(BUNDLE,"HELP_BONUSREROLL_NOTENOUGHREROLLS");
            }
         }
         else if(param1.currentTarget == this.m_UISelectMonsterButton)
         {
            if((param1.currentTarget as Button).enabled)
            {
               if(!this.isInactive)
               {
                  _loc2_ = resourceManager.getString(BUNDLE,"HELP_CONFIRMMONSTER_CHANGE",[this.prey.monsterList[this.m_UIMonsterSelectionGrid.selectedMonsterIndex].monsterName,this.prey.bonusValue,this.prey.generateBonusString()]);
               }
               else
               {
                  _loc2_ = resourceManager.getString(BUNDLE,"HELP_CONFIRMMONSTER_REACTIVATE",[this.prey.monsterList[this.m_UIMonsterSelectionGrid.selectedMonsterIndex].monsterName]);
               }
            }
            else
            {
               _loc2_ = resourceManager.getString(BUNDLE,"HELP_CONFIRMMONSTER_DISABLED");
            }
         }
         this.m_UIHoverHelp.text = _loc2_;
      }
      
      protected function updateResourceDisplayElements() : void
      {
         var _loc1_:Boolean = false;
         _loc1_ = this.prey != null && this.prey.timeUntilFreeListReroll == 0;
         var _loc2_:Number = !!_loc1_?Number(PreyManager.getInstance().listRerollPrice):Number(Number.NaN);
         var _loc3_:Number = !!_loc1_?Number(0):Number(PreyManager.getInstance().listRerollPrice);
         var _loc4_:* = _loc3_ <= Tibia.s_GetPlayer().bankGoldBalance + Tibia.s_GetPlayer().inventoryGoldBalance;
         this.m_UIRerollMonsterListButtonSmall.enabled = _loc4_;
         this.m_UIMonsterSelectRerollCost.baseCurrency = _loc2_;
         this.m_UIMonsterSelectRerollCost.currentCurrency = _loc3_;
         this.m_UIMonsterSelectRerollCost.notEnoughCurrency = !_loc4_;
         this.m_UIRerollMonsterListButton.enabled = _loc4_;
         this.m_UIListRerollCost.baseCurrency = _loc2_;
         this.m_UIListRerollCost.currentCurrency = _loc3_;
         this.m_UIListRerollCost.notEnoughCurrency = !_loc4_;
         this.m_UIBonusRerollButton.enabled = PreyManager.getInstance().bonusRerollAmount > 0 && (this.prey != null && this.prey.state == PreyData.STATE_ACTIVE);
         this.m_UIBonusRerollCost.currentCurrency = 1;
         this.m_UIBonusRerollCost.notEnoughCurrency = PreyManager.getInstance().bonusRerollAmount == 0;
      }
      
      protected function onPlayerDataChanged(param1:PropertyChangeEvent) : void
      {
         if(param1.property == "*" || param1.property == "bankGoldBalance" || param1.property == "inventoryGoldBalance")
         {
            this.m_UncommittedResources = true;
            invalidateProperties();
         }
      }
      
      protected function onClearHelpTextRequested(param1:*) : void
      {
         this.m_UIHoverHelp.text = "";
      }
      
      protected function onPreyMonsterSelectionConfirmed(param1:MouseEvent) : void
      {
         var _loc2_:Communication = Tibia.s_GetCommunication();
         if(_loc2_ != null && this.prey != null)
         {
            _loc2_.sendCPREYACTION(this.prey.id,PreyManager.PREY_ACTION_MONSTERSELECTION,this.m_UIMonsterSelectionGrid.selectedMonsterIndex);
         }
      }
      
      protected function updatePreyMonsterList() : void
      {
         if(this.prey.monsterList != null)
         {
            this.m_UIMonsterSelectionGrid.monsterList = this.prey.monsterList;
            this.m_UISelectMonsterButton.enabled = false;
            this.updateTitleString();
         }
      }
   }
}
