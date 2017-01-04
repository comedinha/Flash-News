package tibia.options.configurationWidgetClasses
{
   import flash.events.Event;
   import flash.events.MouseEvent;
   import mx.containers.Form;
   import mx.containers.FormHeading;
   import mx.containers.FormItem;
   import mx.containers.FormItemDirection;
   import mx.containers.VBox;
   import mx.controls.Button;
   import mx.controls.CheckBox;
   import mx.core.EventPriority;
   import mx.events.CloseEvent;
   import shared.controls.EmbeddedDialog;
   import tibia.game.PopUpBase;
   import tibia.options.ConfigurationWidget;
   import tibia.options.OptionsStorage;
   
   public class GeneralOptions extends VBox implements IOptionsEditor
   {
      
      private static const DIALOG_OPTIONS_RESET:int = 1;
      
      private static const DIALOG_NONE:int = 0;
       
      
      protected var m_UIShowPremiumWidget:CheckBox = null;
      
      private var m_UncommittedOptions:Boolean = false;
      
      protected var m_UIAskBeforeBuying:CheckBox = null;
      
      private var m_UncommittedValues:Boolean = true;
      
      protected var m_UIResetAllOptions:Button = null;
      
      protected var m_UIAutoChaseOff:CheckBox = null;
      
      private var m_UIConstructed:Boolean = false;
      
      protected var m_Options:OptionsStorage = null;
      
      public function GeneralOptions()
      {
         super();
         label = resourceManager.getString(ConfigurationWidget.BUNDLE,"GENERAL_LABEL");
      }
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
         if(this.m_UncommittedOptions)
         {
            if(Tibia.s_GetPremiumManager() != null)
            {
               this.m_UIShowPremiumWidget.selected = Tibia.s_GetPremiumManager().isWidgetVisible();
            }
            if(this.m_Options != null)
            {
               this.m_UIAutoChaseOff.selected = this.m_Options.combatAutoChaseOff;
               this.m_UIAskBeforeBuying.selected = this.m_Options.generalShopShowBuyConfirmation;
            }
            else
            {
               this.m_UIAutoChaseOff.selected = false;
               this.m_UIAskBeforeBuying.selected = true;
               this.m_UIShowPremiumWidget.selected = true;
            }
            this.m_UncommittedOptions = false;
         }
      }
      
      private function showEmbeddedDialog(param1:int, param2:String = null) : void
      {
         var _loc3_:EmbeddedDialog = null;
         if(param1 != DIALOG_NONE && (_loc3_ = PopUpBase.getCurrent().embeddedDialog) == null)
         {
            _loc3_ = new EmbeddedDialog();
            _loc3_.addEventListener(CloseEvent.CLOSE,this.onCloseEmbeddedDialog,false,EventPriority.DEFAULT,true);
         }
         if(_loc3_ != null)
         {
            _loc3_.data = param1;
         }
         switch(param1)
         {
            case DIALOG_OPTIONS_RESET:
               _loc3_.buttonFlags = EmbeddedDialog.YES | EmbeddedDialog.NO;
               _loc3_.title = resourceManager.getString(ConfigurationWidget.BUNDLE,"GENERAL_OPTIONS_DLG_RESET_TITLE");
               _loc3_.text = resourceManager.getString(ConfigurationWidget.BUNDLE,"GENERAL_OPTIONS_DLG_RESET_TEXT");
         }
         PopUpBase.getCurrent().embeddedDialog = _loc3_;
      }
      
      private function onButtonClick(param1:MouseEvent) : void
      {
         if(param1.currentTarget == this.m_UIResetAllOptions)
         {
            this.showEmbeddedDialog(DIALOG_OPTIONS_RESET);
         }
      }
      
      override protected function createChildren() : void
      {
         var LocalisedLabelFunction:Function = null;
         var Frm:Form = null;
         var Heading:FormHeading = null;
         var Item:FormItem = null;
         var FreePlayerLimitations:Boolean = false;
         if(!this.m_UIConstructed)
         {
            super.createChildren();
            LocalisedLabelFunction = function(param1:Object):String
            {
               if(param1.hasOwnProperty("label"))
               {
                  return resourceManager.getString(ConfigurationWidget.BUNDLE,param1.label);
               }
               return String(param1);
            };
            Frm = new Form();
            Frm.styleName = "optionsConfigurationWidgetRootContainer";
            Heading = null;
            Item = null;
            Heading = new FormHeading();
            Heading.label = resourceManager.getString(ConfigurationWidget.BUNDLE,"GENERAL_COMBAT_HEADING");
            Heading.percentHeight = NaN;
            Heading.percentWidth = 100;
            Frm.addChild(Heading);
            Item = new FormItem();
            Item.label = resourceManager.getString(ConfigurationWidget.BUNDLE,"GENERAL_COMBAT_AUTOCHASEOFF");
            Item.percentHeight = NaN;
            Item.percentWidth = 100;
            this.m_UIAutoChaseOff = new CheckBox();
            this.m_UIAutoChaseOff.addEventListener(Event.CHANGE,this.onValueChange);
            Item.addChild(this.m_UIAutoChaseOff);
            Frm.addChild(Item);
            addChild(Frm);
            Heading = new FormHeading();
            Heading.label = resourceManager.getString(ConfigurationWidget.BUNDLE,"INGAMESHOP_HEADING");
            Heading.percentHeight = NaN;
            Heading.percentWidth = 100;
            Frm.addChild(Heading);
            Item = new FormItem();
            Item.label = resourceManager.getString(ConfigurationWidget.BUNDLE,"INGAMESHOP_ASK_BEFORE_BUYING");
            Item.percentHeight = NaN;
            Item.percentWidth = 100;
            this.m_UIAskBeforeBuying = new CheckBox();
            this.m_UIAskBeforeBuying.addEventListener(Event.CHANGE,this.onValueChange);
            Item.addChild(this.m_UIAskBeforeBuying);
            Frm.addChild(Item);
            addChild(Frm);
            Heading = new FormHeading();
            Heading.label = resourceManager.getString(ConfigurationWidget.BUNDLE,"PREMIUM_HEADING");
            Heading.percentHeight = NaN;
            Heading.percentWidth = 100;
            Frm.addChild(Heading);
            Item = new FormItem();
            Item.label = resourceManager.getString(ConfigurationWidget.BUNDLE,"PREMIUM_SHOW_WIDGET");
            Item.percentHeight = NaN;
            Item.percentWidth = 100;
            this.m_UIShowPremiumWidget = new CheckBox();
            this.m_UIShowPremiumWidget.addEventListener(Event.CHANGE,this.onValueChange);
            FreePlayerLimitations = true;
            if(Tibia.s_GetPremiumManager() != null)
            {
               FreePlayerLimitations = Tibia.s_GetPremiumManager().freePlayerLimitations;
            }
            this.m_UIShowPremiumWidget.enabled = !FreePlayerLimitations;
            Item.addChild(this.m_UIShowPremiumWidget);
            Frm.addChild(Item);
            addChild(Frm);
            Heading = new FormHeading();
            Heading.label = resourceManager.getString(ConfigurationWidget.BUNDLE,"GENERAL_OPTIONS_RESET_HEADING");
            Heading.percentHeight = NaN;
            Heading.percentWidth = 100;
            Frm.addChild(Heading);
            Item = new FormItem();
            Item.direction = FormItemDirection.VERTICAL;
            Item.label = resourceManager.getString(ConfigurationWidget.BUNDLE,"GENERAL_OPTIONS_RESET_LABEL");
            this.m_UIResetAllOptions = new Button();
            this.m_UIResetAllOptions.label = resourceManager.getString(ConfigurationWidget.BUNDLE,"GENERAL_OPTIONS_RESET");
            this.m_UIResetAllOptions.addEventListener(MouseEvent.CLICK,this.onButtonClick);
            Item.addChild(this.m_UIResetAllOptions);
            Frm.addChild(Item);
            addChild(Frm);
            this.m_UIConstructed = true;
         }
      }
      
      public function get options() : OptionsStorage
      {
         return this.m_Options;
      }
      
      private function onValueChange(param1:Event) : void
      {
         var _loc2_:OptionsEditorEvent = null;
         if(param1 != null)
         {
            _loc2_ = new OptionsEditorEvent(OptionsEditorEvent.VALUE_CHANGE);
            dispatchEvent(_loc2_);
         }
      }
      
      private function onCloseEmbeddedDialog(param1:CloseEvent) : void
      {
         var _loc3_:ConfigurationWidget = null;
         var _loc4_:OptionsEditorEvent = null;
         var _loc2_:EmbeddedDialog = param1.currentTarget as EmbeddedDialog;
         if(_loc2_.data === DIALOG_OPTIONS_RESET)
         {
            if(param1.detail == EmbeddedDialog.YES)
            {
               this.m_Options.reset();
               _loc3_ = PopUpBase.getParentPopUp(this) as ConfigurationWidget;
               if(_loc3_ != null)
               {
                  _loc3_.options = _loc3_.options;
               }
               _loc4_ = new OptionsEditorEvent(OptionsEditorEvent.VALUE_CHANGE);
               dispatchEvent(_loc4_);
            }
         }
      }
      
      public function set options(param1:OptionsStorage) : void
      {
         this.m_Options = param1;
         this.m_UncommittedOptions = true;
         invalidateProperties();
      }
      
      public function close(param1:Boolean = false) : void
      {
         if(this.m_Options != null && param1 && this.m_UncommittedValues)
         {
            this.m_Options.combatAutoChaseOff = this.m_UIAutoChaseOff.selected;
            this.m_Options.generalShopShowBuyConfirmation = this.m_UIAskBeforeBuying.selected;
            if(Tibia.s_GetPremiumManager() != null)
            {
               Tibia.s_GetPremiumManager().showOrHideWidget(this.m_UIShowPremiumWidget.selected);
            }
            this.m_UncommittedValues = false;
         }
      }
   }
}
