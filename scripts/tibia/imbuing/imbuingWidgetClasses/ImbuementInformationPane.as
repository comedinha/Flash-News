package tibia.imbuing.imbuingWidgetClasses
{
   import mx.containers.HBox;
   import flash.display.BitmapData;
   import flash.display.Bitmap;
   import tibia.imbuing.AstralSource;
   import tibia.imbuing.ImbuingManager;
   import tibia.imbuing.ImbuementData;
   import mx.controls.ComboBox;
   import flash.events.MouseEvent;
   import tibia.game.PopUpBase;
   import shared.controls.EmbeddedDialog;
   import tibia.imbuing.ImbuingWidget;
   import mx.events.CloseEvent;
   import mx.core.EventPriority;
   import tibia.game.ExtendedTooltipEvent;
   import mx.containers.VBox;
   import flash.text.TextLineMetrics;
   import mx.controls.Image;
   import mx.core.UIComponent;
   import mx.controls.Label;
   import mx.events.DropdownEvent;
   import mx.events.ListEvent;
   import mx.controls.Text;
   import shared.controls.CustomButton;
   import tibia.controls.TibiaCurrencyView;
   import tibia.creatures.statusWidgetClasses.BitmapProgressBar;
   import flash.events.Event;
   import tibia.ingameshop.IngameShopManager;
   import tibia.ingameshop.IngameShopProduct;
   import tibia.appearances.widgetClasses.SimpleAppearanceRenderer;
   import tibia.imbuing.ExistingImbuement;
   import shared.utility.i18n.i18nFormatMinutesToCompactDayHourMinutesTimeString;
   
   public class ImbuementInformationPane extends HBox
   {
      
      private static const BUNDLE:String = "ImbuingWidget";
      
      public static const ICON_ARROW:BitmapData = Bitmap(new ICON_ARROW_CLASS()).bitmapData;
      
      private static const ICON_ARROW_CLASS:Class = ImbuementInformationPane_ICON_ARROW_CLASS;
       
      
      protected var m_UIAstralSourceAmountWidgets:Vector.<tibia.imbuing.imbuingWidgetClasses.AstralSourceAmountWidget>;
      
      protected var m_UIImbuementSelection:ComboBox = null;
      
      protected var m_ImbuementData:ImbuementData;
      
      private var m_AppearanceTypeID:uint = 0;
      
      protected var m_UIArrowImageBox:HBox = null;
      
      protected var m_UIImbueButton:tibia.imbuing.imbuingWidgetClasses.ImbuementButtonWidget;
      
      private var m_SelectedImbuingSlot:int = -1;
      
      protected var m_UIPremiumOnly:CustomButton = null;
      
      protected var m_UIDescriptionLabel:Text = null;
      
      protected var m_UIProgressBarBox:HBox = null;
      
      protected var m_UICategorySelection:ComboBox = null;
      
      protected var m_UILeftTitleLabel:Label = null;
      
      protected var m_UIRemainingTimeProgress:BitmapProgressBar = null;
      
      private var m_UIConstructed:Boolean = false;
      
      protected var m_UIRightTitleLabel:Label = null;
      
      protected var m_UITitleLabel:Label = null;
      
      private var m_UIImbuingItemAppearance:SimpleAppearanceRenderer = null;
      
      protected var m_UIProtectionCharmButton:tibia.imbuing.imbuingWidgetClasses.ImbuementButtonWidget;
      
      private var m_CurrentBalance:Number = NaN;
      
      private var m_UncommittedCurrentCurrency:Boolean = false;
      
      private var m_UncommittedImbuementData:Boolean = false;
      
      protected var m_ExistingImbuement:ExistingImbuement = null;
      
      protected var m_UIAstralSourcesBox:HBox = null;
      
      private var m_PlayerIsPremium:Boolean = false;
      
      private var m_TooltipUIElements:Vector.<UIComponent>;
      
      protected var m_UISuccessRate:Label = null;
      
      public function ImbuementInformationPane()
      {
         this.m_UIAstralSourceAmountWidgets = new Vector.<tibia.imbuing.imbuingWidgetClasses.AstralSourceAmountWidget>();
         this.m_ImbuementData = new ImbuementData(uint.MAX_VALUE,"");
         this.m_TooltipUIElements = new Vector.<UIComponent>();
         super();
      }
      
      protected function updateEmptySlotImbuingInfos() : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:uint = 0;
         var _loc4_:AstralSource = null;
         var _loc5_:AstralSource = null;
         var _loc6_:uint = 0;
         var _loc1_:ImbuingManager = ImbuingManager.getInstance();
         this.m_UITitleLabel.text = resourceManager.getString(BUNDLE,"LBL_IMBUE_EMPTY_SLOT");
         if(this.m_ImbuementData != null)
         {
            this.m_UIDescriptionLabel.text = this.m_ImbuementData.description;
            this.m_UIDescriptionLabel.toolTip = this.m_UIDescriptionLabel.text;
            if(this.m_ImbuementData.protectionGoldCost > this.m_CurrentBalance)
            {
               this.m_UIProtectionCharmButton.button.enabled = false;
               this.m_UIProtectionCharmButton.currencyView.notEnoughCurrency = true;
            }
            else
            {
               this.m_UIProtectionCharmButton.button.enabled = true;
               this.m_UIProtectionCharmButton.currencyView.notEnoughCurrency = false;
            }
            this.m_UIProtectionCharmButton.currencyView.currentCurrency = this.m_ImbuementData.protectionGoldCost;
            _loc2_ = true;
            _loc3_ = 0;
            while(_loc3_ < this.m_UIAstralSourceAmountWidgets.length)
            {
               if(_loc3_ < this.m_ImbuementData.astralSources.length)
               {
                  _loc4_ = this.m_ImbuementData.astralSources[_loc3_];
                  _loc5_ = _loc1_.getAvailableAstralSource(_loc4_.apperanceTypeID);
                  _loc6_ = _loc5_ == null?uint(0):uint(_loc5_.objectCount);
                  if(_loc6_ < _loc4_.objectCount)
                  {
                     _loc2_ = false;
                  }
                  this.m_UIAstralSourceAmountWidgets[_loc3_].refreshData(_loc4_.apperanceTypeID,_loc6_,_loc4_.objectCount);
               }
               else
               {
                  this.m_UIAstralSourceAmountWidgets[_loc3_].clear();
               }
               _loc3_++;
            }
            this.m_UISuccessRate.text = resourceManager.getString(BUNDLE,"SUCCESS_RATE_VALUE",[this.successRatePercent]);
            if(this.successRatePercent == 100)
            {
               this.m_UISuccessRate.styleName = "successRateHundredPercent";
            }
            else if(this.successRatePercent <= 50)
            {
               this.m_UISuccessRate.styleName = "successRateBelowTwentyPercent";
            }
            else
            {
               this.m_UISuccessRate.styleName = "successRate";
            }
            this.m_UIImbueButton.visible = true;
            this.m_UIImbueButton.includeInLayout = true;
            this.m_UIImbueButton.button.enabled = this.m_CurrentBalance >= this.completeGoldCost && _loc2_ && (this.m_ImbuementData.premiumOnly == false || this.m_ImbuementData.premiumOnly == true && this.playerIsPremium);
            this.m_UIImbueButton.currencyView.notEnoughCurrency = this.completeGoldCost > this.m_CurrentBalance;
            this.m_UIImbueButton.currencyView.currentCurrency = this.completeGoldCost;
            this.m_UIPremiumOnly.visible = this.m_ImbuementData.premiumOnly;
            if(this.playerIsPremium)
            {
               this.m_UIPremiumOnly.styleName = "premiumOnlyPremium";
               this.m_UIPremiumOnly.selected = true;
               this.m_UIPremiumOnly.enabled = false;
            }
            else
            {
               this.m_UIPremiumOnly.styleName = "premiumOnlyNoPremium";
               this.m_UIPremiumOnly.enabled = true;
               this.m_UIPremiumOnly.selected = false;
            }
         }
         this.m_UIImbueButton.button.styleName = "applyImbuementButton";
         this.m_UICategorySelection.enabled = true;
         this.m_UIImbuementSelection.enabled = true;
         this.m_UILeftTitleLabel.text = resourceManager.getString(BUNDLE,"REQUIRES_THESE_MATERIALS");
         this.m_UIRightTitleLabel.text = resourceManager.getString(BUNDLE,"SUCCESS_RATE");
         this.m_UISuccessRate.visible = true;
         this.m_UISuccessRate.includeInLayout = true;
         this.m_UIAstralSourcesBox.visible = true;
         this.m_UIAstralSourcesBox.includeInLayout = true;
         this.m_UIArrowImageBox.visible = true;
         this.m_UIProgressBarBox.visible = !this.m_UIAstralSourcesBox.visible;
         this.m_UIProgressBarBox.includeInLayout = !this.m_UIAstralSourcesBox.includeInLayout;
      }
      
      public function get imbuementData() : ImbuementData
      {
         return this.m_ImbuementData;
      }
      
      protected function onImbueClicked(param1:MouseEvent) : void
      {
         var _loc2_:PopUpBase = PopUpBase.getCurrent();
         var _loc3_:EmbeddedDialog = null;
         if(this.isInRemoveImbuementMode == false)
         {
            this.updateEmptySlotImbuingInfos();
         }
         if(this.m_UIImbueButton.button.enabled == false)
         {
            return;
         }
         _loc3_ = new EmbeddedDialog();
         _loc3_.width = ImbuingWidget.EMBEDDED_DIALOG_WIDTH;
         _loc3_.buttonFlags = EmbeddedDialog.YES | EmbeddedDialog.NO;
         if(this.isInRemoveImbuementMode)
         {
            _loc3_.title = resourceManager.getString(BUNDLE,"MESSAGE_CONFIRM_CLEARING_TITLE");
            _loc3_.text = resourceManager.getString(BUNDLE,"MESSAGE_CONFIRM_CLEARING_TEXT",[this.completeGoldCost,this.m_ExistingImbuement.imbuementData.name]);
            _loc3_.addEventListener(CloseEvent.CLOSE,this.onConfirmClearing,false,EventPriority.DEFAULT,true);
         }
         else
         {
            _loc3_.title = resourceManager.getString(BUNDLE,"MESSAGE_CONFIRM_IMBUING_TITLE");
            _loc3_.text = resourceManager.getString(BUNDLE,"MESSAGE_CONFIRM_IMBUING_TEXT",[this.m_ImbuementData.name,this.successRatePercent,this.completeGoldCost]);
            _loc3_.addEventListener(CloseEvent.CLOSE,this.onConfirmImbuing,false,EventPriority.DEFAULT,true);
         }
         if(_loc2_ != null)
         {
            _loc2_.embeddedDialog = _loc3_;
         }
         this.m_UncommittedImbuementData = true;
         invalidateProperties();
      }
      
      public function get selectedImbuingSlot() : int
      {
         return this.m_SelectedImbuingSlot;
      }
      
      protected function onProtectionCharmClicked(param1:MouseEvent) : void
      {
         this.m_UncommittedImbuementData = true;
         invalidateProperties();
      }
      
      public function refreshAvailableImbuements() : void
      {
         var _loc1_:ImbuingManager = null;
         var _loc2_:Vector.<String> = null;
         var _loc3_:Array = null;
         var _loc4_:String = null;
         if(this.m_ExistingImbuement != null && this.m_ExistingImbuement.empty == false)
         {
            this.m_UICategorySelection.dataProvider = [{
               "value":this.m_ExistingImbuement.imbuementData.category,
               "label":this.m_ExistingImbuement.imbuementData.category
            }];
            this.m_UIImbuementSelection.dataProvider = [{
               "value":this.m_ExistingImbuement.imbuementData.imbuementID,
               "label":this.m_ExistingImbuement.imbuementData.name
            }];
         }
         else
         {
            _loc1_ = ImbuingManager.getInstance();
            _loc2_ = _loc1_.imbuementCategories;
            if(_loc2_.length == 0)
            {
               this.m_UICategorySelection.dataProvider = [{
                  "value":"-",
                  "label":"-"
               }];
               this.m_UIImbuementSelection.dataProvider = [{
                  "value":0,
                  "label":"-"
               }];
            }
            else
            {
               _loc3_ = [];
               for each(_loc4_ in _loc2_)
               {
                  _loc3_.push({
                     "value":_loc4_,
                     "label":_loc4_
                  });
               }
               this.m_UICategorySelection.dataProvider = _loc3_;
               if(this.m_ImbuementData != null)
               {
                  this.selectItemInComboBoxes(this.m_ImbuementData);
               }
               else
               {
                  this.updateImbuementsForCategory(_loc2_[0]);
               }
               this.updateViewWithSelectedImbuement();
            }
         }
      }
      
      public function sendTooltipEvent(param1:String) : void
      {
         var _loc2_:ExtendedTooltipEvent = null;
         if(param1 != null && param1.length > 0)
         {
            _loc2_ = new ExtendedTooltipEvent(ExtendedTooltipEvent.SHOW,true,false,param1);
            dispatchEvent(_loc2_);
         }
         else
         {
            _loc2_ = new ExtendedTooltipEvent(ExtendedTooltipEvent.HIDE);
            dispatchEvent(_loc2_);
         }
      }
      
      private function onConfirmClearing(param1:CloseEvent) : void
      {
         if(param1.detail == EmbeddedDialog.YES)
         {
            Tibia.s_GetCommunication().sendCAPPLYCLEARINGCHARM(this.m_SelectedImbuingSlot);
         }
      }
      
      override protected function createChildren() : void
      {
         var _loc1_:VBox = null;
         var _loc2_:HBox = null;
         var _loc3_:HBox = null;
         var _loc4_:TextLineMetrics = null;
         var _loc5_:HBox = null;
         var _loc6_:HBox = null;
         var _loc7_:HBox = null;
         var _loc8_:uint = 0;
         var _loc9_:Image = null;
         var _loc10_:UIComponent = null;
         var _loc11_:tibia.imbuing.imbuingWidgetClasses.AstralSourceAmountWidget = null;
         super.createChildren();
         if(!this.m_UIConstructed)
         {
            _loc1_ = new VBox();
            _loc1_.percentWidth = 100;
            _loc1_.percentHeight = 100;
            this.m_UITitleLabel = new Label();
            _loc1_.addChild(this.m_UITitleLabel);
            _loc2_ = new HBox();
            _loc2_.percentWidth = 100;
            _loc2_.height = 30;
            this.m_UICategorySelection = new ComboBox();
            this.m_UICategorySelection.percentWidth = 50;
            this.m_UICategorySelection.addEventListener(DropdownEvent.CLOSE,this.onComboBoxChange);
            this.m_UICategorySelection.addEventListener(ListEvent.CHANGE,this.onComboBoxChange);
            this.m_UIImbuementSelection = new ComboBox();
            this.m_UIImbuementSelection.percentWidth = 50;
            _loc2_.addChild(this.m_UICategorySelection);
            _loc2_.addChild(this.m_UIImbuementSelection);
            _loc1_.addChild(_loc2_);
            _loc3_ = new HBox();
            _loc3_.percentWidth = 100;
            this.m_UIDescriptionLabel = new Text();
            _loc3_.addChild(this.m_UIDescriptionLabel);
            this.m_UIDescriptionLabel.percentWidth = 100;
            _loc4_ = this.m_UIDescriptionLabel.getLineMetrics(0);
            this.m_UIDescriptionLabel.height = _loc4_.height * 3;
            this.m_UIDescriptionLabel.truncateToFit = true;
            this.m_UIPremiumOnly = new CustomButton();
            this.m_UIPremiumOnly.width = 128;
            this.m_UIPremiumOnly.height = 38;
            this.m_UIPremiumOnly.label = resourceManager.getString(BUNDLE,"PREMIUM_ONLY");
            _loc3_.addChild(this.m_UIPremiumOnly);
            _loc1_.addChild(_loc3_);
            _loc5_ = new HBox();
            _loc5_.percentWidth = 100;
            this.m_UILeftTitleLabel = new Label();
            _loc5_.addChild(this.m_UILeftTitleLabel);
            _loc6_ = new HBox();
            _loc6_.percentWidth = 100;
            this.m_UIRightTitleLabel = new Label();
            _loc6_.addChild(this.m_UIRightTitleLabel);
            this.m_UISuccessRate = new Label();
            this.m_UISuccessRate.width = 40;
            _loc6_.addChild(this.m_UISuccessRate);
            _loc5_.addChild(_loc6_);
            _loc1_.addChild(_loc5_);
            _loc7_ = new HBox();
            _loc7_.percentWidth = 100;
            this.m_UIAstralSourcesBox = new HBox();
            this.m_UIAstralSourcesBox.percentWidth = 100;
            _loc8_ = 0;
            while(_loc8_ < 3)
            {
               _loc11_ = new tibia.imbuing.imbuingWidgetClasses.AstralSourceAmountWidget();
               _loc11_.clear();
               this.m_UIAstralSourceAmountWidgets.push(_loc11_);
               this.m_UIAstralSourcesBox.addChild(_loc11_);
               _loc8_++;
            }
            this.m_UIProtectionCharmButton = new tibia.imbuing.imbuingWidgetClasses.ImbuementButtonWidget();
            this.m_UIProtectionCharmButton.width = 70 + 2;
            this.m_UIProtectionCharmButton.percentHeight = 100;
            this.m_UIProtectionCharmButton.button.toggle = true;
            this.m_UIProtectionCharmButton.currencyView.currencyIcon == TibiaCurrencyView.CURRENCY_ICON_GOLD_COIN;
            this.m_UIAstralSourcesBox.addChild(this.m_UIProtectionCharmButton);
            this.m_UIArrowImageBox = new HBox();
            this.m_UIArrowImageBox.percentHeight = 100;
            this.m_UIArrowImageBox.percentWidth = 100;
            _loc9_ = new Image();
            _loc9_.addChild(new Bitmap(ICON_ARROW));
            _loc9_.width = ICON_ARROW.width;
            _loc9_.height = ICON_ARROW.height;
            this.m_UIArrowImageBox.addChild(_loc9_);
            this.m_UIProgressBarBox = new HBox();
            this.m_UIRemainingTimeProgress = new BitmapProgressBar();
            this.m_UIRemainingTimeProgress.percentWidth = 100;
            this.m_UIRemainingTimeProgress.labelEnabled = true;
            this.m_UIProgressBarBox.addChild(this.m_UIRemainingTimeProgress);
            this.m_UIImbueButton = new tibia.imbuing.imbuingWidgetClasses.ImbuementButtonWidget();
            this.m_UIImbueButton.width = this.m_UIPremiumOnly.width;
            this.m_UIImbueButton.percentHeight = 100;
            this.m_UIImbueButton.currencyView.currencyIcon = TibiaCurrencyView.CURRENCY_ICON_GOLD_COIN;
            _loc7_.addChild(this.m_UIAstralSourcesBox);
            _loc7_.addChild(this.m_UIProgressBarBox);
            _loc7_.addChild(this.m_UIArrowImageBox);
            _loc7_.addChild(this.m_UIImbueButton);
            _loc1_.addChild(_loc7_);
            addChild(_loc1_);
            this.m_UIImbuementSelection.addEventListener(DropdownEvent.CLOSE,this.onComboBoxChange);
            this.m_UIImbuementSelection.addEventListener(ListEvent.CHANGE,this.onComboBoxChange);
            this.m_UIProtectionCharmButton.addEventListener(MouseEvent.CLICK,this.onProtectionCharmClicked);
            this.m_UIImbueButton.addEventListener(MouseEvent.CLICK,this.onImbueClicked);
            this.m_UIPremiumOnly.addEventListener(MouseEvent.CLICK,this.onPremiumOnlyButtonClicked);
            this.m_TooltipUIElements.push(this.m_UIImbueButton,this.m_UIRemainingTimeProgress,this.m_UIProtectionCharmButton,this.m_UIPremiumOnly);
            this.m_TooltipUIElements = this.m_TooltipUIElements.concat(this.m_UIAstralSourceAmountWidgets);
            for each(_loc10_ in this.m_TooltipUIElements)
            {
               _loc10_.addEventListener(MouseEvent.MOUSE_OVER,this.onTooltipMouseEvent);
               _loc10_.addEventListener(MouseEvent.MOUSE_OUT,this.onTooltipMouseEvent);
            }
            _loc1_.styleName = "imbuingItemInformationBox";
            this.m_UITitleLabel.styleName = "headerLabel";
            this.m_UIRemainingTimeProgress.styleName = "imbuingDuration";
            this.m_UIProgressBarBox.styleName = "progressBarBox";
            this.m_UIAstralSourcesBox.styleName = "astralSourcesArrowBox";
            this.m_UIProtectionCharmButton.button.styleName = "protectionCharmButton";
            this.m_UIArrowImageBox.styleName = "astralSourcesArrowBox";
            this.m_UILeftTitleLabel.styleName = "headerLabel";
            this.m_UIRightTitleLabel.styleName = "headerLabel";
            _loc6_.styleName = "successRateBox";
            styleName = "sectionBorder";
            this.m_UIConstructed = true;
         }
      }
      
      public function dispose() : void
      {
         var _loc1_:UIComponent = null;
         if(this.m_UIConstructed)
         {
            this.m_UIImbuementSelection.removeEventListener(DropdownEvent.CLOSE,this.onComboBoxChange);
            this.m_UIImbuementSelection.removeEventListener(ListEvent.CHANGE,this.onComboBoxChange);
            this.m_UIProtectionCharmButton.removeEventListener(MouseEvent.CLICK,this.onProtectionCharmClicked);
            for each(_loc1_ in this.m_TooltipUIElements)
            {
               _loc1_.removeEventListener(MouseEvent.MOUSE_OVER,this.onTooltipMouseEvent);
               _loc1_.removeEventListener(MouseEvent.MOUSE_OUT,this.onTooltipMouseEvent);
            }
         }
      }
      
      public function set selectedImbuingSlot(param1:int) : void
      {
         this.m_SelectedImbuingSlot = param1;
      }
      
      protected function onComboBoxChange(param1:Event) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Object = null;
         if(param1 != null)
         {
            _loc2_ = -1;
            _loc3_ = null;
            switch(param1.currentTarget)
            {
               case this.m_UICategorySelection:
                  this.updateImbuementsForCategory(this.m_UICategorySelection.selectedLabel);
                  break;
               case this.m_UIImbuementSelection:
                  this.updateViewWithSelectedImbuement();
            }
         }
      }
      
      protected function get completeGoldCost() : uint
      {
         var _loc1_:uint = 0;
         if(this.isInRemoveImbuementMode)
         {
            return this.m_ExistingImbuement.clearingGoldCost;
         }
         _loc1_ = this.m_ImbuementData.goldCost;
         if(this.useProtectionCharm)
         {
            _loc1_ = _loc1_ + this.m_ImbuementData.protectionGoldCost;
         }
         return _loc1_;
      }
      
      public function selectItemInComboBoxes(param1:ImbuementData) : void
      {
         var _loc2_:Object = null;
         var _loc3_:Object = null;
         for each(_loc2_ in this.m_UICategorySelection.dataProvider)
         {
            if(_loc2_.value == param1.category)
            {
               this.m_UICategorySelection.selectedItem = _loc2_;
               for each(_loc3_ in this.m_UIImbuementSelection.dataProvider)
               {
                  if(_loc3_.value == param1.imbuementID)
                  {
                     this.m_UIImbuementSelection.selectedItem = _loc3_;
                  }
               }
            }
         }
      }
      
      public function get currentBalance() : Number
      {
         return this.m_CurrentBalance;
      }
      
      protected function updateViewWithSelectedImbuement() : void
      {
         var _loc1_:ImbuingManager = ImbuingManager.getInstance();
         if(this.m_UIImbuementSelection.selectedItem != null)
         {
            this.m_ImbuementData = _loc1_.getAvailableImbuementWithID(uint(this.m_UIImbuementSelection.selectedItem.value));
            this.m_UIProtectionCharmButton.button.selected = false;
         }
         else
         {
            this.m_ImbuementData = null;
         }
         this.m_UncommittedImbuementData = true;
         invalidateProperties();
      }
      
      protected function onPremiumOnlyButtonClicked(param1:MouseEvent) : void
      {
         IngameShopManager.getInstance().openShopWindow(true,IngameShopProduct.SERVICE_TYPE_PREMIUM);
      }
      
      public function set currentBalance(param1:Number) : void
      {
         if(param1 != this.m_CurrentBalance)
         {
            this.m_CurrentBalance = param1;
            this.m_UncommittedImbuementData = true;
            invalidateProperties();
         }
      }
      
      private function onTooltipMouseEvent(param1:MouseEvent) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:AstralSource = null;
         var _loc5_:AstralSource = null;
         var _loc6_:uint = 0;
         var _loc2_:ImbuingManager = ImbuingManager.getInstance();
         if(param1.type == MouseEvent.MOUSE_OUT)
         {
            this.sendTooltipEvent(null);
         }
         else if(param1.type == MouseEvent.MOUSE_OVER)
         {
            _loc3_ = 0;
            while(_loc3_ < this.m_UIAstralSourceAmountWidgets.length)
            {
               if(param1.currentTarget == this.m_UIAstralSourceAmountWidgets[_loc3_])
               {
                  if(this.m_ImbuementData == null)
                  {
                     this.sendTooltipEvent(null);
                     return;
                  }
                  if(_loc3_ < this.m_ImbuementData.astralSources.length)
                  {
                     _loc4_ = this.m_ImbuementData.astralSources[_loc3_];
                     _loc5_ = _loc2_.getAvailableAstralSource(_loc4_.apperanceTypeID);
                     _loc6_ = _loc5_ == null?uint(0):uint(_loc5_.objectCount);
                     if(_loc6_ < _loc4_.objectCount)
                     {
                        this.sendTooltipEvent(resourceManager.getString(BUNDLE,"TOOLTIP_IMBUEMENT_RESOURCE_UNAVAILABLE",[_loc4_.name]));
                     }
                     else
                     {
                        this.sendTooltipEvent(resourceManager.getString(BUNDLE,"TOOLTIP_IMBUEMENT_RESOURCE_AVAILABLE",[_loc4_.name]));
                     }
                  }
                  else
                  {
                     this.sendTooltipEvent(null);
                  }
                  return;
               }
               _loc3_++;
            }
            switch(param1.currentTarget)
            {
               case this.m_UIImbueButton:
                  if(this.isInRemoveImbuementMode)
                  {
                     this.sendTooltipEvent(resourceManager.getString(BUNDLE,"TOOLTIP_REMOVE_IMBUEMENT"));
                  }
                  else
                  {
                     this.sendTooltipEvent(resourceManager.getString(BUNDLE,"TOOLTIP_APPLY_IMBUEMENT"));
                  }
                  break;
               case this.m_UIRemainingTimeProgress:
                  this.sendTooltipEvent(resourceManager.getString(BUNDLE,"TOOLTIP_REMAINING_TIME"));
                  break;
               case this.m_UIProtectionCharmButton:
                  this.sendTooltipEvent(resourceManager.getString(BUNDLE,"TOOLTIP_PROTECTION_CHARM"));
                  break;
               case this.m_UIPremiumOnly:
                  if(this.playerIsPremium)
                  {
                     this.sendTooltipEvent(resourceManager.getString(BUNDLE,"TOOLTIP_PREMIUM_AVAILABLE"));
                  }
                  else
                  {
                     this.sendTooltipEvent(resourceManager.getString(BUNDLE,"TOOLTIP_PREMIUM_ONLY"));
                  }
                  break;
               default:
                  this.sendTooltipEvent(null);
            }
         }
      }
      
      public function set existingImbuement(param1:ExistingImbuement) : void
      {
         if(param1 != this.m_ExistingImbuement)
         {
            this.m_ExistingImbuement = param1;
            this.m_ImbuementData = this.m_ExistingImbuement.imbuementData;
            this.m_UncommittedImbuementData = true;
            invalidateProperties();
            this.refreshAvailableImbuements();
         }
      }
      
      protected function updateNoImbuementImbuingInfos() : void
      {
         this.m_UITitleLabel.text = resourceManager.getString(BUNDLE,"LBL_IMBUE_EMPTY_SLOT");
         this.m_UIDescriptionLabel.text = resourceManager.getString(BUNDLE,"NO_IMBUEMENT_AVAILABLE");
         this.m_UIDescriptionLabel.toolTip = "";
         this.m_UIPremiumOnly.visible = false;
         this.m_UICategorySelection.enabled = false;
         this.m_UIImbuementSelection.enabled = false;
         this.m_UIAstralSourcesBox.visible = false;
         this.m_UIAstralSourcesBox.includeInLayout = false;
         this.m_UIArrowImageBox.visible = false;
         this.m_UIProgressBarBox.visible = false;
         this.m_UIProgressBarBox.includeInLayout = false;
         this.m_UIImbueButton.visible = false;
         this.m_UIImbueButton.includeInLayout = false;
         this.m_UILeftTitleLabel.visible = false;
         this.m_UIRightTitleLabel.visible = false;
      }
      
      protected function updateImbuementsForCategory(param1:String) : void
      {
         var _loc2_:ImbuingManager = null;
         var _loc5_:ImbuementData = null;
         var _loc6_:String = null;
         _loc2_ = ImbuingManager.getInstance();
         var _loc3_:Vector.<ImbuementData> = _loc2_.getImbuementsForCategory(param1);
         var _loc4_:Array = [];
         for each(_loc5_ in _loc3_)
         {
            _loc6_ = _loc5_.name;
            if(_loc5_.premiumOnly)
            {
               _loc6_ = _loc6_ + resourceManager.getString(BUNDLE,"PREMIUM_IMBUEMENT_POSTFIX");
            }
            _loc4_.push({
               "value":_loc5_.imbuementID,
               "label":_loc6_
            });
         }
         this.m_UIImbuementSelection.dataProvider = _loc4_;
         this.updateViewWithSelectedImbuement();
      }
      
      public function set playerIsPremium(param1:Boolean) : void
      {
         if(param1 != this.m_PlayerIsPremium)
         {
            this.m_PlayerIsPremium = param1;
            this.m_UncommittedImbuementData = true;
            invalidateProperties();
         }
      }
      
      protected function get successRatePercent() : uint
      {
         if(this.isInRemoveImbuementMode)
         {
            return 100;
         }
         if(this.useProtectionCharm)
         {
            return 100;
         }
         return this.m_ImbuementData.successRatePercent;
      }
      
      protected function get isInRemoveImbuementMode() : Boolean
      {
         if(this.m_ExistingImbuement == null || this.m_ExistingImbuement.empty)
         {
            return false;
         }
         return true;
      }
      
      public function get existingImbuement() : ExistingImbuement
      {
         return this.m_ExistingImbuement;
      }
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
         if(this.m_UncommittedImbuementData)
         {
            if(this.m_ExistingImbuement != null && this.m_ExistingImbuement.imbuementData != null)
            {
               this.updateImbuedSlotImbuingInfos();
            }
            else if(this.m_ImbuementData != null)
            {
               this.updateEmptySlotImbuingInfos();
            }
            else
            {
               this.updateNoImbuementImbuingInfos();
            }
         }
         if(this.m_UncommittedCurrentCurrency)
         {
            this.m_UncommittedCurrentCurrency = false;
         }
      }
      
      private function onConfirmImbuing(param1:CloseEvent) : void
      {
         if(param1.detail == EmbeddedDialog.YES)
         {
            Tibia.s_GetCommunication().sendCAPPLYIMBUEMENT(this.m_SelectedImbuingSlot,this.m_ImbuementData.imbuementID,this.useProtectionCharm);
         }
      }
      
      public function set imbuementData(param1:ImbuementData) : void
      {
         if(param1 != this.m_ImbuementData)
         {
            this.m_ImbuementData = param1;
            this.m_UncommittedImbuementData = true;
            invalidateProperties();
         }
      }
      
      public function get playerIsPremium() : Boolean
      {
         return this.m_PlayerIsPremium;
      }
      
      protected function updateImbuedSlotImbuingInfos() : void
      {
         var _loc1_:ImbuingManager = ImbuingManager.getInstance();
         this.m_UITitleLabel.text = resourceManager.getString(BUNDLE,"LBL_CLEAR_IMBUED_SLOT",[this.m_ExistingImbuement.imbuementData.name]);
         this.m_UIDescriptionLabel.text = this.m_ExistingImbuement.imbuementData.description;
         this.m_UIDescriptionLabel.toolTip = this.m_UIDescriptionLabel.text;
         this.m_UIPremiumOnly.visible = false;
         this.m_UICategorySelection.enabled = false;
         this.m_UIImbuementSelection.enabled = false;
         this.m_UIImbueButton.visible = true;
         this.m_UIImbueButton.includeInLayout = true;
         this.m_UIImbueButton.currencyView.currentCurrency = this.m_ExistingImbuement.clearingGoldCost;
         if(this.m_UIImbueButton.currencyView.currentCurrency > this.m_CurrentBalance)
         {
            this.m_UIImbueButton.currencyView.notEnoughCurrency = true;
            this.m_UIImbueButton.button.enabled = false;
         }
         else
         {
            this.m_UIImbueButton.currencyView.notEnoughCurrency = false;
            this.m_UIImbueButton.button.enabled = true;
         }
         this.m_UIImbueButton.button.styleName = "removeImbuementButton";
         this.m_UILeftTitleLabel.text = resourceManager.getString(BUNDLE,"TIME_REMAINING");
         this.m_UIRightTitleLabel.text = resourceManager.getString(BUNDLE,"REMOVE_IMBUEMENT");
         this.m_UISuccessRate.visible = false;
         this.m_UISuccessRate.includeInLayout = false;
         this.m_UIAstralSourcesBox.visible = false;
         this.m_UIAstralSourcesBox.includeInLayout = false;
         this.m_UIArrowImageBox.visible = false;
         this.m_UIProgressBarBox.visible = !this.m_UIAstralSourcesBox.visible;
         this.m_UIProgressBarBox.includeInLayout = !this.m_UIAstralSourcesBox.includeInLayout;
         this.m_UIProgressBarBox.height = this.m_UIAstralSourcesBox.height;
         this.m_UIProgressBarBox.width = this.m_UIAstralSourcesBox.width;
         this.m_UIRemainingTimeProgress.maxValue = this.m_ExistingImbuement.imbuementData.durationInSeconds;
         this.m_UIRemainingTimeProgress.value = this.m_ExistingImbuement.remainingDurationInSeconds;
         this.m_UIRemainingTimeProgress.labelFormat = i18nFormatMinutesToCompactDayHourMinutesTimeString(this.m_ExistingImbuement.remainingDurationInSeconds / 60);
      }
      
      protected function get useProtectionCharm() : Boolean
      {
         if(this.m_UIProtectionCharmButton)
         {
            return this.m_UIProtectionCharmButton.button.selected;
         }
         return false;
      }
   }
}
