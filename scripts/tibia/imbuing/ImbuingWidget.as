package tibia.imbuing
{
   import flash.text.TextLineMetrics;
   import mx.containers.HBox;
   import mx.controls.Text;
   import mx.events.PropertyChangeEvent;
   import shared.controls.EmbeddedDialog;
   import shared.utility.i18n.i18nFormatNumber;
   import tibia.controls.TibiaCurrencyView;
   import tibia.creatures.Player;
   import tibia.game.ExtendedTooltipEvent;
   import tibia.game.PopUpBase;
   import tibia.imbuing.imbuingWidgetClasses.ImbuementInformationPane;
   import tibia.imbuing.imbuingWidgetClasses.ImbuementSlotWidget;
   import tibia.imbuing.imbuingWidgetClasses.ItemInformationPane;
   
   public class ImbuingWidget extends PopUpBase
   {
      
      private static var s_CurrentInstance:ImbuingWidget = null;
      
      private static const BUNDLE:String = "ImbuingWidget";
      
      public static const EMBEDDED_DIALOG_WIDTH:int = 380;
       
      
      private var m_UncommittedPlayer:Boolean = false;
      
      private var m_Player:Player = null;
      
      private var m_UIGoldBalance:TibiaCurrencyView = null;
      
      private var m_UIItemInformationPane:ItemInformationPane = null;
      
      private var m_UncommittedPlayerData:Boolean = false;
      
      private var m_UIHintLabel:Text = null;
      
      private var m_UncomittedImbuementData:Boolean = false;
      
      private var m_UIImbuementInformationPane:ImbuementInformationPane = null;
      
      private var m_UIConstructed:Boolean = false;
      
      public function ImbuingWidget()
      {
         super();
         height = 518;
         width = 600;
         title = resourceManager.getString(BUNDLE,"TITLE");
         buttonFlags = PopUpBase.BUTTON_CLOSE;
         keyboardFlags = PopUpBase.KEY_ESCAPE;
         stretchEmbeddedDialog = false;
         this.player = Tibia.s_GetPlayer();
      }
      
      public static function s_GetCurrentInstance() : ImbuingWidget
      {
         return s_CurrentInstance;
      }
      
      override public function hide(param1:Boolean = false) : void
      {
         super.hide(param1);
         ImbuingManager.getInstance().removeEventListener(ImbuingEvent.IMBUEMENT_DATA_CHANGED,this.onImbuementDataChanged);
         if(this.m_UIConstructed)
         {
            this.m_UIItemInformationPane.removeEventListener(ImbuingEvent.IMBUEMENT_SLOT_SELECTED,this.onImbuementSlotSelected);
            this.m_UIItemInformationPane.removeEventListener(ExtendedTooltipEvent.SHOW,this.onExtendedTooltipEvent);
            this.m_UIItemInformationPane.removeEventListener(ExtendedTooltipEvent.HIDE,this.onExtendedTooltipEvent);
            this.m_UIImbuementInformationPane.removeEventListener(ExtendedTooltipEvent.SHOW,this.onExtendedTooltipEvent);
            this.m_UIImbuementInformationPane.removeEventListener(ExtendedTooltipEvent.HIDE,this.onExtendedTooltipEvent);
            this.m_UIItemInformationPane.dispose();
            this.m_UIImbuementInformationPane.dispose();
         }
         Tibia.s_GetCommunication().sendCCLOSEDIMBUINGDIALOG();
         s_CurrentInstance = null;
      }
      
      public function set player(param1:Player) : void
      {
         if(this.m_Player != param1)
         {
            if(this.m_Player != null)
            {
               this.m_Player.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onPlayerChange);
            }
            this.m_Player = param1;
            this.m_UncommittedPlayerData = true;
            invalidateProperties();
            if(this.m_Player != null)
            {
               this.m_Player.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onPlayerChange);
            }
         }
      }
      
      override protected function commitProperties() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:Boolean = false;
         var _loc3_:String = null;
         var _loc4_:String = null;
         super.commitProperties();
         if(this.m_UncomittedImbuementData)
         {
            this.m_UIItemInformationPane.apperanceTypeID = ImbuingManager.getInstance().apperanceTypeID;
            this.m_UIItemInformationPane.selectedImbuingSlot = 0;
            this.onImbuementSlotSelected(null);
            this.m_UncomittedImbuementData = false;
         }
         if(this.m_UncommittedPlayerData)
         {
            _loc1_ = NaN;
            _loc2_ = false;
            if(this.m_Player != null)
            {
               _loc1_ = this.m_Player.bankGoldBalance + this.m_Player.inventoryGoldBalance;
               _loc2_ = this.m_Player.premium;
               if(this.m_UIGoldBalance)
               {
                  this.m_UIGoldBalance.baseCurrency = NaN;
                  this.m_UIGoldBalance.currentCurrency = _loc1_;
                  _loc3_ = i18nFormatNumber(this.m_Player.inventoryGoldBalance);
                  _loc4_ = i18nFormatNumber(this.m_Player.bankGoldBalance);
                  this.m_UIGoldBalance.toolTip = resourceManager.getString(BUNDLE,"TOOLTIP_GOLD_BALANCE",[_loc3_,_loc4_]);
               }
            }
            this.m_UIImbuementInformationPane.currentBalance = _loc1_;
            this.m_UIImbuementInformationPane.playerIsPremium = _loc2_;
            this.m_UncommittedPlayerData = false;
         }
      }
      
      override protected function createChildren() : void
      {
         var _loc1_:HBox = null;
         var _loc2_:TextLineMetrics = null;
         if(!this.m_UIConstructed)
         {
            super.createChildren();
            this.m_UIItemInformationPane = new ItemInformationPane();
            this.m_UIItemInformationPane.percentWidth = 100;
            addChild(this.m_UIItemInformationPane);
            this.m_UIItemInformationPane.selectedImbuingSlot = 0;
            this.m_UIImbuementInformationPane = new ImbuementInformationPane();
            this.m_UIImbuementInformationPane.percentWidth = 100;
            this.m_UIImbuementInformationPane.percentHeight = 100;
            addChild(this.m_UIImbuementInformationPane);
            _loc1_ = new HBox();
            _loc1_.percentWidth = 100;
            this.m_UIHintLabel = new Text();
            this.m_UIHintLabel.percentWidth = 100;
            _loc1_.addChild(this.m_UIHintLabel);
            addChild(_loc1_);
            this.m_UIGoldBalance = new TibiaCurrencyView();
            this.m_UIGoldBalance.currencyIcon = TibiaCurrencyView.CURRENCY_ICON_GOLD_COIN;
            this.m_UIGoldBalance.width = 200;
            addChild(this.m_UIGoldBalance);
            _loc1_.styleName = "hintBox";
            _loc2_ = this.m_UIHintLabel.getLineMetrics(0);
            this.m_UIHintLabel.height = _loc2_.height * 3;
            ImbuingManager.getInstance().addEventListener(ImbuingEvent.IMBUEMENT_DATA_CHANGED,this.onImbuementDataChanged);
            this.m_UIItemInformationPane.addEventListener(ImbuingEvent.IMBUEMENT_SLOT_SELECTED,this.onImbuementSlotSelected);
            this.m_UIItemInformationPane.addEventListener(ExtendedTooltipEvent.SHOW,this.onExtendedTooltipEvent);
            this.m_UIItemInformationPane.addEventListener(ExtendedTooltipEvent.HIDE,this.onExtendedTooltipEvent);
            this.m_UIImbuementInformationPane.addEventListener(ExtendedTooltipEvent.SHOW,this.onExtendedTooltipEvent);
            this.m_UIImbuementInformationPane.addEventListener(ExtendedTooltipEvent.HIDE,this.onExtendedTooltipEvent);
            this.m_UIConstructed = true;
         }
      }
      
      protected function onImbuementDataChanged(param1:ImbuingEvent) : void
      {
         var _loc2_:ImbuingManager = null;
         var _loc5_:ExistingImbuement = null;
         _loc2_ = ImbuingManager.getInstance();
         this.m_UIItemInformationPane.apperanceTypeID = _loc2_.apperanceTypeID;
         var _loc3_:Vector.<ExistingImbuement> = _loc2_.existingImbuements;
         var _loc4_:Vector.<int> = new Vector.<int>();
         for each(_loc5_ in _loc2_.existingImbuements)
         {
            if(_loc5_.empty)
            {
               _loc4_.push(ImbuementSlotWidget.IMBUING_IMAGE_EMPTY);
            }
            else
            {
               _loc4_.push(_loc5_.imbuementData.iconID);
            }
         }
         this.m_UIItemInformationPane.imbuingSlotImages = _loc4_;
         this.onImbuementSlotSelected(null);
      }
      
      public function get player() : Player
      {
         return this.m_Player;
      }
      
      protected function onImbuementSlotSelected(param1:ImbuingEvent) : void
      {
         var _loc4_:Vector.<ExistingImbuement> = null;
         var _loc2_:ImbuingManager = ImbuingManager.getInstance();
         var _loc3_:int = this.m_UIItemInformationPane.selectedImbuingSlot;
         if(_loc3_ > -1)
         {
            _loc4_ = _loc2_.existingImbuements;
            if(_loc3_ < _loc4_.length)
            {
               this.m_UIImbuementInformationPane.existingImbuement = _loc4_[_loc3_];
            }
            else
            {
               this.m_UIImbuementInformationPane.existingImbuement = null;
            }
         }
         this.m_UIImbuementInformationPane.selectedImbuingSlot = _loc3_;
      }
      
      protected function onExtendedTooltipEvent(param1:ExtendedTooltipEvent) : void
      {
         if(param1.type == ExtendedTooltipEvent.SHOW)
         {
            this.m_UIHintLabel.text = param1.tooltip;
         }
         else if(param1.type == ExtendedTooltipEvent.HIDE)
         {
            this.m_UIHintLabel.text = "";
         }
      }
      
      public function showImbuingResultDialog(param1:String) : void
      {
         var _loc2_:EmbeddedDialog = new EmbeddedDialog();
         _loc2_.name = "ImbuingDialogResult";
         _loc2_.buttonFlags = PopUpBase.BUTTON_OKAY;
         _loc2_.text = param1;
         _loc2_.title = resourceManager.getString(BUNDLE,"RESULTDIALOG_TITLE");
         _loc2_.width = EMBEDDED_DIALOG_WIDTH;
         embeddedDialog = _loc2_;
      }
      
      private function onPlayerChange(param1:PropertyChangeEvent) : void
      {
         if(param1.property == "bankGoldBalance" || param1.property == "inventoryGoldBalance" || param1.property == "premium")
         {
            this.m_UncommittedPlayerData = true;
            invalidateProperties();
         }
      }
      
      override public function show() : void
      {
         super.show();
         s_CurrentInstance = this;
      }
   }
}
