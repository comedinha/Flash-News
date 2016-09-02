package tibia.market.marketWidgetClasses
{
   import mx.controls.Button;
   import mx.collections.ArrayCollection;
   import tibia.ingameshop.shopWidgetClasses.CoinWidget;
   import mx.containers.VBox;
   import mx.containers.HBox;
   import mx.controls.Spacer;
   import mx.controls.Label;
   import shared.controls.CustomButton;
   import flash.events.MouseEvent;
   import mx.controls.ComboBox;
   import mx.events.DropdownEvent;
   import mx.events.ListEvent;
   import mx.controls.TextInput;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.KeyboardEvent;
   import flash.events.TextEvent;
   import tibia.input.MouseRepeatEvent;
   import mx.controls.CheckBox;
   import tibia.market.Offer;
   import tibia.market.MarketWidget;
   import tibia.ingameshop.IngameShopManager;
   import shared.utility.i18n.i18nFormatNumber;
   import tibia.ingameshop.IngameShopEvent;
   import mx.containers.BoxDirection;
   import mx.core.EventPriority;
   
   public class MarketOfferEditor extends MarketComponent
   {
      
      private static const BUNDLE:String = "MarketWidget";
       
      
      private var m_UIAmountIncrease:Button = null;
      
      private var m_KindList:ArrayCollection = null;
      
      private var m_UICoinBalance:CoinWidget = null;
      
      private var m_Amount:int = 1;
      
      private var m_CumulativePrice:uint = 1;
      
      private var m_UncommittedSelectedType:Boolean = true;
      
      private var m_UITotalPrice:Label = null;
      
      private var m_PiecePrice:uint = 1;
      
      private var m_UIConstructed:Boolean = false;
      
      private var m_UIAccountBalance:Label = null;
      
      private var m_UICumulativePriceEdit:TextInput = null;
      
      private var m_UICreate:Button = null;
      
      private var m_UncommittedKind:Boolean = true;
      
      private var m_Kind:int = -1;
      
      private var m_UncommittedAmount:Boolean = true;
      
      private var m_UncommittedOffer:Boolean = true;
      
      private var m_UIAmountEdit:TextInput = null;
      
      private var m_UncommittedCumulativePrice:Boolean = true;
      
      private var m_UncommittedAnonymous:Boolean = true;
      
      private var m_UIKind:ComboBox = null;
      
      private var m_UIAmountDecrease:Button = null;
      
      private var m_UIAnonymous:CheckBox = null;
      
      private var m_AmountStepping:int = 1;
      
      private var m_UIPiecePriceEdit:TextInput = null;
      
      private var m_UncommittedPiecePrice:Boolean = true;
      
      private var m_UncommittedCoins:Boolean = true;
      
      private var m_Anonymous:Boolean = false;
      
      public function MarketOfferEditor(param1:MarketWidget)
      {
         var a_Market:MarketWidget = param1;
         super(a_Market);
         direction = BoxDirection.VERTICAL;
         label = resourceManager.getString(BUNDLE,"MARKET_EDIT_LABEL");
         this.m_KindList = new ArrayCollection([{
            "value":-1,
            "label":resourceManager.getString(BUNDLE,"KIND_SELECT")
         },{
            "value":Offer.BUY_OFFER,
            "label":resourceManager.getString(BUNDLE,"KIND_BUY_OFFER")
         },{
            "value":Offer.SELL_OFFER,
            "label":resourceManager.getString(BUNDLE,"KIND_SELL_OFFER")
         }]);
         this.m_KindList.filterFunction = function(param1:Object):Boolean
         {
            return param1 != null && (param1.value == -1 || selectedType != null) && (param1.value == -1 || market.activeOffers < MarketWidget.OFFER_MAX_ACTIVE) && (param1.value != Offer.SELL_OFFER || market.getDepotAmount(selectedType) > 0);
         };
         this.m_KindList.refresh();
         market.addEventListener(MarketWidget.ACCOUNT_BALANCE_CHANGE,this.onMarketChange,false,EventPriority.DEFAULT,true);
         market.addEventListener(MarketWidget.ACTIVE_OFFERS_CHANGE,this.onMarketChange,false,EventPriority.DEFAULT,true);
         IngameShopManager.getInstance().addEventListener(IngameShopEvent.CREDIT_BALANCE_CHANGED,this.onCoinBalanceChange);
      }
      
      private function get offerKind() : int
      {
         return this.m_Kind;
      }
      
      private function get offerCumulativePrice() : uint
      {
         return this.m_CumulativePrice;
      }
      
      override protected function createChildren() : void
      {
         var _Header:HBox = null;
         var _Label:Label = null;
         var _Content:HBox = null;
         var _Group:VBox = null;
         var _Row:HBox = null;
         var _Footer:VBox = null;
         var _FirstLine:HBox = null;
         var _Spacer:Spacer = null;
         var _SecondLine:HBox = null;
         if(!this.m_UIConstructed)
         {
            super.createChildren();
            _Header = new HBox();
            _Header.percentWidth = 100;
            _Label = new Label();
            _Label.percentWidth = 100;
            _Label.text = resourceManager.getString(BUNDLE,"MARKET_EDIT_LABEL");
            _Label.setStyle("fontWeight","bold");
            _Header.addChild(_Label);
            this.m_UICreate = new CustomButton();
            this.m_UICreate.enabled = false;
            this.m_UICreate.label = resourceManager.getString(BUNDLE,"MARKET_EDIT_CREATE_LABEL");
            this.m_UICreate.addEventListener(MouseEvent.CLICK,this.onCreate);
            _Header.addChild(this.m_UICreate);
            _Content = new HBox();
            _Content.percentHeight = 100;
            _Content.percentWidth = 100;
            _Content.setStyle("horizontalGap",2);
            _Content.setStyle("verticalGap",2);
            _Group = new VBox();
            _Group.percentHeight = 100;
            _Group.setStyle("horizontalAlign","center");
            _Group.setStyle("horizontalGap",2);
            _Group.setStyle("verticalGap",2);
            _Label = new Label();
            _Label.text = resourceManager.getString(BUNDLE,"MARKET_EDIT_KIND_LABEL");
            _Group.addChild(_Label);
            this.m_UIKind = new ComboBox();
            this.m_UIKind.dataProvider = this.m_KindList;
            this.m_UIKind.labelField = "label";
            this.m_UIKind.maxWidth = 150;
            this.m_UIKind.percentHeight = 100;
            this.m_UIKind.percentWidth = 100;
            this.m_UIKind.addEventListener(DropdownEvent.CLOSE,this.onKindChange);
            this.m_UIKind.addEventListener(ListEvent.CHANGE,this.onKindChange);
            _Group.addChild(this.m_UIKind);
            _Content.addChild(_Group);
            _Group = new VBox();
            _Group.percentHeight = 100;
            _Group.percentWidth = 100;
            _Group.setStyle("horizontalAlign","center");
            _Group.setStyle("horizontalGap",2);
            _Group.setStyle("verticalGap",2);
            _Label = new Label();
            _Label.text = resourceManager.getString(BUNDLE,"MARKET_EDIT_CUMULATIVEPRICE_LABEL");
            _Group.addChild(_Label);
            this.m_UICumulativePriceEdit = new TextInput();
            this.m_UICumulativePriceEdit.maxChars = 15;
            this.m_UICumulativePriceEdit.percentHeight = 100;
            this.m_UICumulativePriceEdit.percentWidth = 100;
            this.m_UICumulativePriceEdit.addEventListener(Event.CHANGE,function(param1:Event):void
            {
               offerCumulativePrice = Math.max(0,Math.min(Number(m_UICumulativePriceEdit.text),uint.MAX_VALUE));
            });
            this.m_UICumulativePriceEdit.addEventListener(FocusEvent.FOCUS_OUT,function(param1:FocusEvent):void
            {
               offerCumulativePrice = offerAmount * offerPiecePrice;
            });
            this.m_UICumulativePriceEdit.addEventListener(KeyboardEvent.KEY_DOWN,Utility.preventNonNumericInput);
            this.m_UICumulativePriceEdit.addEventListener(TextEvent.TEXT_INPUT,Utility.preventNonNumericInput);
            _Group.addChild(this.m_UICumulativePriceEdit);
            _Content.addChild(_Group);
            _Group = new VBox();
            _Group.percentHeight = 100;
            _Group.percentWidth = 100;
            _Group.setStyle("horizontalAlign","center");
            _Group.setStyle("horizontalGap",2);
            _Group.setStyle("verticalGap",2);
            _Label = new Label();
            _Label.text = resourceManager.getString(BUNDLE,"MARKET_EDIT_PIECEPRICE_LABEL");
            _Group.addChild(_Label);
            this.m_UIPiecePriceEdit = new TextInput();
            this.m_UIPiecePriceEdit.maxChars = 10;
            this.m_UIPiecePriceEdit.percentHeight = 100;
            this.m_UIPiecePriceEdit.percentWidth = 100;
            this.m_UIPiecePriceEdit.addEventListener(Event.CHANGE,function(param1:Event):void
            {
               offerPiecePrice = Math.max(0,Math.min(Number(m_UIPiecePriceEdit.text),uint.MAX_VALUE));
            });
            this.m_UIPiecePriceEdit.addEventListener(FocusEvent.FOCUS_OUT,function(param1:FocusEvent):void
            {
               offerPiecePrice = Math.max(1,offerPiecePrice);
            });
            this.m_UIPiecePriceEdit.addEventListener(KeyboardEvent.KEY_DOWN,Utility.preventNonNumericInput);
            this.m_UIPiecePriceEdit.addEventListener(TextEvent.TEXT_INPUT,Utility.preventNonNumericInput);
            _Group.addChild(this.m_UIPiecePriceEdit);
            _Content.addChild(_Group);
            _Group = new VBox();
            _Group.percentHeight = 100;
            _Group.setStyle("horizontalAlign","center");
            _Group.setStyle("horizontalGap",2);
            _Group.setStyle("verticalGap",2);
            _Label = new Label();
            _Label.text = resourceManager.getString(BUNDLE,"MARKET_EDIT_AMOUNT_LABEL");
            _Group.addChild(_Label);
            _Row = new HBox();
            _Row.percentHeight = 100;
            _Row.percentWidth = 100;
            _Row.setStyle("horizontalGap",2);
            _Row.setStyle("verticalGap",2);
            this.m_UIAmountDecrease = new CustomButton();
            this.m_UIAmountDecrease.styleName = "marketWidgetAmountDecrease";
            this.m_UIAmountDecrease.addEventListener(MouseEvent.CLICK,this.onButtonClick);
            this.m_UIAmountDecrease.addEventListener(MouseEvent.MOUSE_DOWN,this.onButtonDown);
            this.m_UIAmountDecrease.addEventListener(MouseRepeatEvent.REPEAT_MOUSE_DOWN,this.onButtonClick);
            _Row.addChild(this.m_UIAmountDecrease);
            this.m_UIAmountEdit = new TextInput();
            this.m_UIAmountEdit.maxWidth = 75;
            this.m_UIAmountEdit.percentHeight = 100;
            this.m_UIAmountEdit.percentWidth = 100;
            this.m_UIAmountEdit.addEventListener(Event.CHANGE,function(param1:Event):void
            {
               offerAmount = Math.max(0,Math.min(Number(m_UIAmountEdit.text),int.MAX_VALUE));
            });
            this.m_UIAmountEdit.addEventListener(FocusEvent.FOCUS_OUT,function(param1:FocusEvent):void
            {
               offerAmount = Math.max(1,offerAmount);
            });
            this.m_UIAmountEdit.addEventListener(KeyboardEvent.KEY_DOWN,Utility.preventNonNumericInput);
            this.m_UIAmountEdit.addEventListener(TextEvent.TEXT_INPUT,Utility.preventNonNumericInput);
            _Row.addChild(this.m_UIAmountEdit);
            this.m_UIAmountIncrease = new CustomButton();
            this.m_UIAmountIncrease.styleName = "marketWidgetAmountIncrease";
            this.m_UIAmountIncrease.addEventListener(MouseEvent.CLICK,this.onButtonClick);
            this.m_UIAmountIncrease.addEventListener(MouseEvent.MOUSE_DOWN,this.onButtonDown);
            this.m_UIAmountIncrease.addEventListener(MouseRepeatEvent.REPEAT_MOUSE_DOWN,this.onButtonClick);
            _Row.addChild(this.m_UIAmountIncrease);
            _Group.addChild(_Row);
            _Content.addChild(_Group);
            _Group = new VBox();
            _Group.percentHeight = 100;
            _Group.setStyle("horizontalAlign","center");
            _Group.setStyle("horizontalGap",2);
            _Group.setStyle("verticalGap",2);
            _Label = new Label();
            _Label.text = resourceManager.getString(BUNDLE,"MARKET_EDIT_ANONYMOUS_LABEL");
            _Group.addChild(_Label);
            this.m_UIAnonymous = new CheckBox();
            this.m_UIAnonymous.percentHeight = 100;
            this.m_UIAnonymous.addEventListener(Event.CHANGE,function(param1:Event):void
            {
               offerAnonymous = m_UIAnonymous.selected;
            });
            _Group.addChild(this.m_UIAnonymous);
            _Content.addChild(_Group);
            _Footer = new VBox();
            _Footer.percentWidth = 100;
            _Footer.setStyle("verticalGap",2);
            _FirstLine = new HBox();
            _FirstLine.percentWidth = 100;
            _Footer.addChild(_FirstLine);
            _Label = new Label();
            _Label.text = resourceManager.getString(BUNDLE,"MARKET_EDIT_ACCOUNTBALANCE_LABEL");
            _FirstLine.addChild(_Label);
            this.m_UIAccountBalance = new Label();
            this.m_UIAccountBalance.setStyle("fontWeight","bold");
            _FirstLine.addChild(this.m_UIAccountBalance);
            _Spacer = new Spacer();
            _Spacer.percentWidth = 100;
            _FirstLine.addChild(_Spacer);
            _Label = new Label();
            _Label.text = resourceManager.getString(BUNDLE,"MARKET_EDIT_TOTALPRICE_LABEL");
            _FirstLine.addChild(_Label);
            this.m_UITotalPrice = new Label();
            this.m_UITotalPrice.minWidth = 100;
            this.m_UITotalPrice.setStyle("fontWeight","bold");
            _FirstLine.addChild(this.m_UITotalPrice);
            _SecondLine = new HBox();
            _SecondLine.percentWidth = 100;
            _Footer.addChild(_SecondLine);
            _Label = new Label();
            _Label.text = resourceManager.getString(BUNDLE,"MARKET_EDIT_COINS_LABEL");
            _SecondLine.addChild(_Label);
            this.m_UICoinBalance = new CoinWidget();
            _SecondLine.addChild(this.m_UICoinBalance);
            addChild(_Header);
            addChild(_Content);
            addChild(_Footer);
            this.m_UIConstructed = true;
         }
      }
      
      private function onButtonClick(param1:MouseEvent) : void
      {
         this.offerAmount = this.offerAmount + (param1.currentTarget == this.m_UIAmountDecrease?-this.m_AmountStepping:this.m_AmountStepping) * (!!param1.shiftKey?10:1);
      }
      
      private function set offerKind(param1:int) : void
      {
         if(param1 != Offer.BUY_OFFER && param1 != Offer.SELL_OFFER)
         {
            param1 = -1;
         }
         if(this.m_Kind != param1)
         {
            this.m_Kind = param1;
            this.m_UncommittedKind = true;
            invalidateProperties();
            this.invalidateOffer();
            this.offerAmount = 1;
            this.offerPiecePrice = 1;
            this.offerAnonymous = false;
         }
      }
      
      private function onKindChange(param1:Event) : void
      {
         var _loc2_:ComboBox = null;
         if(param1 != null && (_loc2_ = param1.currentTarget as ComboBox) != null && _loc2_.enabled)
         {
            this.offerKind = _loc2_.selectedItem.value;
         }
      }
      
      private function set offerAmount(param1:int) : void
      {
         var _loc5_:int = 0;
         var _loc2_:int = Math.max(MarketWidget.OFFER_MAX_AMOUNT_NONCUMULATIVE,MarketWidget.OFFER_MAX_AMOUNT_CUMULATIVE);
         if(this.offerKind == Offer.SELL_OFFER)
         {
            _loc5_ = market.getDepotAmount(selectedType);
            _loc2_ = _loc5_ - _loc5_ % this.m_AmountStepping;
         }
         var _loc3_:int = param1 - param1 % this.m_AmountStepping;
         var _loc4_:int = Math.max(this.m_AmountStepping,Math.min(_loc3_,_loc2_));
         if(this.m_Amount != _loc4_ || param1 != _loc4_)
         {
            this.m_Amount = _loc4_;
            this.m_UncommittedAmount = true;
            if(this.m_Amount > 0)
            {
               this.m_CumulativePrice = this.m_Amount * this.offerPiecePrice;
            }
            else
            {
               this.m_CumulativePrice = this.offerPiecePrice;
            }
            this.m_UncommittedCumulativePrice = true;
            invalidateProperties();
            this.invalidateOffer();
         }
      }
      
      private function set offerCumulativePrice(param1:uint) : void
      {
         var _loc2_:Number = Math.max(0,Math.min(param1,MarketWidget.OFFER_MAX_TOTALPRICE));
         if(this.m_CumulativePrice != _loc2_ || param1 != _loc2_)
         {
            this.m_CumulativePrice = _loc2_;
            this.m_UncommittedCumulativePrice = true;
            if(this.m_CumulativePrice > 0 && this.offerAmount > 0)
            {
               this.m_PiecePrice = Math.max(1,Math.floor(this.m_CumulativePrice / this.offerAmount));
            }
            else
            {
               this.m_PiecePrice = 1;
            }
            this.m_UncommittedPiecePrice = true;
            invalidateProperties();
            this.invalidateOffer();
         }
      }
      
      private function onMarketChange(param1:Event) : void
      {
         if(param1 != null)
         {
            this.invalidateKind();
            this.invalidateOffer();
         }
      }
      
      override protected function commitProperties() : void
      {
         var _loc1_:* = false;
         var _loc2_:Number = NaN;
         super.commitProperties();
         if(this.m_UncommittedSelectedType)
         {
            if(selectedType != null && selectedType.marketTradeAs == IngameShopManager.TIBIA_COINS_APPEARANCE_TYPE_ID)
            {
               this.m_AmountStepping = IngameShopManager.getInstance().getCreditPackageSize();
            }
            else
            {
               this.m_AmountStepping = 1;
            }
            this.offerKind = -1;
            this.offerAmount = this.m_AmountStepping;
            this.offerPiecePrice = 1;
            this.offerAnonymous = false;
            this.m_UncommittedSelectedType = false;
         }
         if(this.m_UncommittedKind)
         {
            this.m_KindList.refresh();
            this.m_UIKind.selectedIndex = Math.max(0,Math.min(this.offerKind + 1,this.m_KindList.length - 1));
            _loc1_ = this.offerKind > -1;
            this.m_UIPiecePriceEdit.enabled = _loc1_;
            this.m_UICumulativePriceEdit.enabled = _loc1_;
            this.m_UIAmountEdit.enabled = _loc1_;
            this.m_UIAmountDecrease.enabled = _loc1_;
            this.m_UIAmountIncrease.enabled = _loc1_;
            this.m_UIAnonymous.enabled = _loc1_;
            this.m_UIAccountBalance.text = i18nFormatNumber(market.accountBalance);
            this.m_UITotalPrice.text = null;
            this.m_UncommittedKind = false;
         }
         if(this.m_UncommittedAmount)
         {
            this.m_UIAmountEdit.text = this.offerAmount > 0?String(this.offerAmount):null;
            this.m_UncommittedAmount = false;
         }
         if(this.m_UncommittedPiecePrice)
         {
            this.m_UIPiecePriceEdit.text = this.offerPiecePrice > 0?String(this.offerPiecePrice):null;
            this.m_UncommittedPiecePrice = false;
         }
         if(this.m_UncommittedCumulativePrice)
         {
            this.m_UICumulativePriceEdit.text = this.offerCumulativePrice > 0?String(this.offerCumulativePrice):null;
            this.m_UncommittedCumulativePrice = false;
         }
         if(this.m_UncommittedAnonymous)
         {
            this.m_UIAnonymous.selected = this.offerAnonymous;
            this.m_UncommittedAnonymous = false;
         }
         if(this.m_UncommittedOffer)
         {
            if(selectedType != null && this.offerKind > -1)
            {
               this.m_UICreate.enabled = market.mayCreateOffer(this.offerKind,selectedType,this.offerAmount,this.offerPiecePrice);
               _loc2_ = market.getOfferTotalPrice(this.offerKind,this.offerAmount,this.offerPiecePrice);
               this.m_UITotalPrice.text = i18nFormatNumber(_loc2_);
               this.m_UITotalPrice.setStyle("color",_loc2_ <= market.accountBalance?getStyle("color"):getStyle("errorColor"));
            }
            else
            {
               this.m_UICreate.enabled = false;
               this.m_UITotalPrice.text = null;
            }
            this.m_UncommittedOffer = false;
         }
         if(this.m_UncommittedCoins)
         {
            this.m_UICoinBalance.coins = IngameShopManager.getInstance().getConfirmedCreditBalance();
            this.m_UICoinBalance.coinsAreFinal = IngameShopManager.getInstance().creditsAreFinal();
            this.m_UncommittedCoins = false;
         }
      }
      
      private function onCreate(param1:MouseEvent) : void
      {
         if(param1 != null)
         {
            market.createOffer(this.offerKind,selectedType.marketTradeAs,this.offerAmount,this.offerPiecePrice,this.offerAnonymous);
            this.offerKind = -1;
            this.offerAmount = 1;
            this.offerPiecePrice = 1;
            this.offerAnonymous = false;
         }
      }
      
      private function onButtonDown(param1:MouseEvent) : void
      {
         if(param1 is MouseRepeatEvent)
         {
            MouseRepeatEvent(param1).repeatEnabled = true;
         }
      }
      
      private function get offerAmount() : int
      {
         return this.m_Amount;
      }
      
      private function set offerAnonymous(param1:Boolean) : void
      {
         if(this.m_Anonymous != param1)
         {
            this.m_Anonymous = param1;
            this.m_UncommittedAnonymous = true;
            invalidateProperties();
         }
      }
      
      private function set offerPiecePrice(param1:uint) : void
      {
         var _loc2_:uint = MarketWidget.OFFER_MAX_TOTALPRICE;
         if(this.offerAmount > 0)
         {
            _loc2_ = _loc2_ / this.offerAmount;
         }
         var _loc3_:uint = Math.max(0,Math.min(param1,_loc2_));
         if(this.m_PiecePrice != _loc3_ || param1 != _loc3_)
         {
            this.m_PiecePrice = _loc3_;
            this.m_UncommittedPiecePrice = true;
            if(this.m_PiecePrice > 0)
            {
               this.m_CumulativePrice = this.offerAmount * this.m_PiecePrice;
            }
            else
            {
               this.m_CumulativePrice = this.offerAmount;
            }
            this.m_UncommittedCumulativePrice = true;
            invalidateProperties();
            this.invalidateOffer();
         }
      }
      
      private function invalidateKind() : void
      {
         this.m_UncommittedKind = true;
         invalidateProperties();
      }
      
      private function invalidateOffer() : void
      {
         this.m_UncommittedOffer = true;
         invalidateProperties();
      }
      
      private function get offerPiecePrice() : uint
      {
         return this.m_PiecePrice;
      }
      
      private function get offerAnonymous() : Boolean
      {
         return this.m_Anonymous;
      }
      
      override public function set selectedType(param1:*) : void
      {
         if(selectedType != param1)
         {
            super.selectedType = param1;
            this.m_UncommittedSelectedType = true;
            this.invalidateKind();
            invalidateProperties();
            this.invalidateOffer();
         }
      }
      
      private function onCoinBalanceChange(param1:IngameShopEvent) : void
      {
         this.m_UncommittedCoins = true;
         invalidateProperties();
      }
   }
}
