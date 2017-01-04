package tibia.market.marketWidgetClasses
{
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.events.TextEvent;
   import mx.containers.Box;
   import mx.containers.HBox;
   import mx.controls.Button;
   import mx.controls.Label;
   import mx.controls.TextInput;
   import shared.controls.CustomButton;
   import shared.controls.EmbeddedDialog;
   import shared.utility.i18n.i18nFormatNumber;
   import tibia.ingameshop.IngameShopManager;
   import tibia.input.MouseRepeatEvent;
   import tibia.market.MarketWidget;
   import tibia.market.Offer;
   
   public class AcceptOfferDialog extends EmbeddedDialog
   {
      
      private static const BUNDLE:String = "MarketWidget";
       
      
      private var m_UIAmountIncrease:Button = null;
      
      private var m_UIAmountEdit:TextInput = null;
      
      private var m_UncommittedAmount:Boolean = false;
      
      private var m_Amount:int = 0;
      
      private var m_UncommittedOffer:Boolean = false;
      
      private var m_UITotalCostLabel:Label = null;
      
      private var m_AmountStepping:int = 1;
      
      private var m_MaxAmount:int = -1;
      
      private var m_UIAmountDecrease:Button = null;
      
      private var m_UncommittedMarket:Boolean = false;
      
      private var m_Market:MarketWidget = null;
      
      private var m_Offer:Offer = null;
      
      public function AcceptOfferDialog()
      {
         super();
         buttonFlags = EmbeddedDialog.OKAY | EmbeddedDialog.CANCEL;
         title = resourceManager.getString(BUNDLE,"MARKET_DIALOG_GENERIC_TITLE");
         text = resourceManager.getString(BUNDLE,"MARKET_DIALOG_ACCEPT_TEXT");
      }
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
         if(this.m_UncommittedOffer)
         {
            if(this.m_Offer != null && this.m_Offer.typeID == IngameShopManager.TIBIA_COINS_APPEARANCE_TYPE_ID)
            {
               this.m_AmountStepping = IngameShopManager.getInstance().getCreditPackageSize();
            }
            else
            {
               this.m_AmountStepping = 1;
            }
            this.amount = this.m_AmountStepping;
         }
         if(this.m_UncommittedAmount)
         {
            this.m_UIAmountEdit.text = String(this.amount);
            this.m_UIAmountEdit.setFocus();
            this.m_UIAmountEdit.selectionBeginIndex = this.m_UIAmountEdit.selectionEndIndex = this.m_UIAmountEdit.length + 1;
            this.updateTotalCost();
         }
         if(!this.m_UncommittedMarket)
         {
         }
         if(this.m_UncommittedAmount || this.m_UncommittedMarket || this.m_UncommittedOffer)
         {
            if(this.amount <= this.maxAmount)
            {
               buttonFlags = EmbeddedDialog.OKAY | EmbeddedDialog.CANCEL;
            }
            else
            {
               buttonFlags = EmbeddedDialog.CANCEL;
            }
            this.m_UncommittedAmount = false;
            this.m_UncommittedMarket = false;
            this.m_UncommittedOffer = false;
         }
      }
      
      override protected function createContent(param1:Box) : void
      {
         var a_Container:Box = param1;
         super.createContent(a_Container);
         var Outer:HBox = new HBox();
         Outer.percentWidth = 100;
         Outer.setStyle("horizontalAlign","center");
         Outer.setStyle("verticalAlign","middle");
         var Inner:HBox = new HBox();
         Inner.setStyle("horizontalGap",2);
         Inner.setStyle("verticalGap",2);
         this.m_UIAmountDecrease = new CustomButton();
         this.m_UIAmountDecrease.styleName = "marketWidgetAmountDecrease";
         this.m_UIAmountDecrease.addEventListener(MouseEvent.CLICK,this.onButtonClick);
         this.m_UIAmountDecrease.addEventListener(MouseEvent.MOUSE_DOWN,this.onButtonDown);
         this.m_UIAmountDecrease.addEventListener(MouseRepeatEvent.REPEAT_MOUSE_DOWN,this.onButtonClick);
         Inner.addChild(this.m_UIAmountDecrease);
         this.m_UIAmountEdit = new TextInput();
         this.m_UIAmountEdit.maxChars = 10;
         this.m_UIAmountEdit.addEventListener(Event.CHANGE,function(param1:Event):void
         {
            amount = parseInt(m_UIAmountEdit.text);
         });
         this.m_UIAmountEdit.addEventListener(KeyboardEvent.KEY_DOWN,Utility.preventNonNumericInput);
         this.m_UIAmountEdit.addEventListener(TextEvent.TEXT_INPUT,Utility.preventNonNumericInput);
         Inner.addChild(this.m_UIAmountEdit);
         this.m_UIAmountIncrease = new CustomButton();
         this.m_UIAmountIncrease.styleName = "marketWidgetAmountIncrease";
         this.m_UIAmountIncrease.addEventListener(MouseEvent.CLICK,this.onButtonClick);
         this.m_UIAmountIncrease.addEventListener(MouseEvent.MOUSE_DOWN,this.onButtonDown);
         this.m_UIAmountIncrease.addEventListener(MouseRepeatEvent.REPEAT_MOUSE_DOWN,this.onButtonClick);
         Inner.addChild(this.m_UIAmountIncrease);
         this.m_UITotalCostLabel = new Label();
         Inner.addChild(this.m_UITotalCostLabel);
         Outer.addChild(Inner);
         a_Container.minHeight = 60;
         a_Container.addChild(Outer);
      }
      
      private function onButtonClick(param1:MouseEvent) : void
      {
         this.amount = this.amount + (param1.currentTarget == this.m_UIAmountDecrease?-this.m_AmountStepping:this.m_AmountStepping) * (!!param1.shiftKey?10:1);
      }
      
      public function get amount() : int
      {
         return this.m_Amount;
      }
      
      public function set offer(param1:Offer) : void
      {
         if(this.m_Offer != param1)
         {
            this.m_Offer = param1;
            this.m_MaxAmount = -1;
            this.m_UncommittedOffer = true;
            invalidateProperties();
         }
      }
      
      private function updateTotalCost() : void
      {
         var _loc1_:uint = 0;
         if(this.m_Offer != null)
         {
            _loc1_ = this.m_Offer.piecePrice;
         }
         this.m_UITotalCostLabel.text = "total " + i18nFormatNumber(_loc1_ * this.amount) + " gold";
      }
      
      public function set amount(param1:int) : void
      {
         var _loc2_:int = 0;
         _loc2_ = param1 - param1 % this.m_AmountStepping;
         var _loc3_:int = Math.max(this.m_AmountStepping,Math.min(_loc2_,this.maxAmount));
         if(this.m_Amount != param1)
         {
            this.m_Amount = _loc3_;
            this.m_UncommittedAmount = true;
            invalidateProperties();
         }
      }
      
      public function get maxAmount() : int
      {
         var _loc1_:int = 0;
         if(this.m_MaxAmount < 0)
         {
            _loc1_ = this.offer != null?int(this.offer.amount - this.offer.amount % this.m_AmountStepping):0;
            if(this.market == null || this.offer == null)
            {
               this.m_MaxAmount = 0;
            }
            else if(this.offer.kind == Offer.BUY_OFFER)
            {
               this.m_MaxAmount = Math.min(this.market.getDepotAmount(this.offer.typeID),_loc1_);
            }
            else
            {
               this.m_MaxAmount = Math.floor(this.market.accountBalance / this.offer.piecePrice);
            }
            this.m_MaxAmount = Math.min(this.m_MaxAmount,_loc1_,Math.max(MarketWidget.OFFER_MAX_AMOUNT_NONCUMULATIVE,MarketWidget.OFFER_MAX_AMOUNT_CUMULATIVE));
         }
         return this.m_MaxAmount;
      }
      
      private function onButtonDown(param1:MouseEvent) : void
      {
         if(param1 is MouseRepeatEvent)
         {
            MouseRepeatEvent(param1).repeatEnabled = true;
         }
      }
      
      public function get market() : MarketWidget
      {
         return this.m_Market;
      }
      
      public function get offer() : Offer
      {
         return this.m_Offer;
      }
      
      public function set market(param1:MarketWidget) : void
      {
         if(this.m_Market != param1)
         {
            this.m_Market = param1;
            this.m_MaxAmount = -1;
            this.m_UncommittedMarket = true;
            invalidateProperties();
         }
      }
   }
}
