package tibia.market.marketWidgetClasses
{
   import mx.collections.ArrayCollection;
   import flash.events.MouseEvent;
   import tibia.market.Offer;
   import mx.events.CloseEvent;
   import mx.core.EventPriority;
   import mx.controls.Button;
   import mx.events.ListEvent;
   import mx.controls.DataGrid;
   import mx.collections.Sort;
   import mx.collections.SortField;
   import mx.containers.HBox;
   import mx.controls.Label;
   import shared.controls.CustomButton;
   import shared.controls.CustomDataGrid;
   import mx.core.ClassFactory;
   import mx.core.ScrollPolicy;
   import mx.controls.dataGridClasses.DataGridColumn;
   import flash.events.Event;
   import tibia.market.MarketWidget;
   import shared.controls.EmbeddedDialog;
   import mx.containers.BoxDirection;
   
   public class MarketOffersView extends MarketComponent
   {
      
      private static const BUNDLE:String = "MarketWidget";
       
      
      private var m_SellOffersView:ArrayCollection;
      
      private var m_UISellAccept:Button = null;
      
      private var m_UISellOffers:DataGrid = null;
      
      private var m_BuyOffersView:ArrayCollection;
      
      private var m_UncommittedSelectedType:Boolean = false;
      
      private var m_UIBuyAccept:Button = null;
      
      private var m_UIBuyOffers:DataGrid = null;
      
      private var m_UIConstructed:Boolean = false;
      
      public function MarketOffersView(param1:MarketWidget)
      {
         this.m_BuyOffersView = new ArrayCollection();
         this.m_SellOffersView = new ArrayCollection();
         super(param1);
         direction = BoxDirection.VERTICAL;
         label = resourceManager.getString(BUNDLE,"MARKET_OFFERS_VIEW_LABEL");
         this.m_BuyOffersView = new ArrayCollection();
         this.m_BuyOffersView.filterFunction = Utility.createFilter({"kind":Offer.BUY_OFFER});
         this.m_BuyOffersView.refresh();
         this.m_SellOffersView = new ArrayCollection();
         this.m_SellOffersView.filterFunction = Utility.createFilter({"kind":Offer.SELL_OFFER});
         this.m_SellOffersView.refresh();
         market.addEventListener(MarketWidget.BROWSE_OFFERS_CHANGE,this.onOffersChange);
      }
      
      private function onAcceptClick(param1:MouseEvent) : void
      {
         var _loc3_:AcceptOfferDialog = null;
         var _loc2_:Offer = null;
         if(param1 != null && (_loc2_ = param1.currentTarget == this.m_UIBuyAccept?this.m_UIBuyOffers.selectedItem as Offer:this.m_UISellOffers.selectedItem as Offer) != null && this.checkAccept(_loc2_))
         {
            _loc3_ = new AcceptOfferDialog();
            _loc3_.market = market;
            _loc3_.offer = _loc2_;
            _loc3_.addEventListener(CloseEvent.CLOSE,this.onAcceptClose,false,EventPriority.DEFAULT,true);
            market.embeddedDialog = _loc3_;
         }
      }
      
      private function createOfferToolTip(param1:Offer) : String
      {
         if(param1.isDubious)
         {
            if(param1.kind == Offer.BUY_OFFER)
            {
               return resourceManager.getString(BUNDLE,"OFFERS_VIEW_OFFER_BELOW");
            }
            return resourceManager.getString(BUNDLE,"OFFERS_VIEW_OFFER_ABOVE");
         }
         return null;
      }
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
         if(this.m_UncommittedSelectedType)
         {
            this.updateOfferList(null);
            this.m_UncommittedSelectedType = false;
         }
      }
      
      private function onOfferClick(param1:ListEvent) : void
      {
         if(param1 != null && param1.itemRenderer != null)
         {
            this.updateOfferSelection(param1.itemRenderer.data as Offer);
         }
      }
      
      private function updateOfferList(param1:Array) : void
      {
         var _loc2_:Sort = new Sort();
         _loc2_.fields = [new SortField("piecePrice",false,true,true),new SortField("amount",false,true,true),new SortField("terminationTimestamp",false,false,true)];
         this.m_BuyOffersView.sort = _loc2_;
         this.m_BuyOffersView.source = param1;
         this.m_BuyOffersView.refresh();
         var _loc3_:Sort = new Sort();
         _loc3_.fields = [new SortField("piecePrice",false,false,true),new SortField("amount",false,true,true),new SortField("terminationTimestamp",false,false,true)];
         this.m_SellOffersView.sort = _loc3_;
         this.m_SellOffersView.source = param1;
         this.m_SellOffersView.refresh();
         this.updateOfferSelection(null);
      }
      
      override protected function createChildren() : void
      {
         var _loc1_:HBox = null;
         var _loc2_:Label = null;
         if(!this.m_UIConstructed)
         {
            super.createChildren();
            _loc1_ = new HBox();
            _loc1_.percentHeight = NaN;
            _loc1_.percentWidth = 100;
            _loc2_ = new Label();
            _loc2_.percentHeight = NaN;
            _loc2_.percentWidth = 100;
            _loc2_.text = resourceManager.getString(BUNDLE,"MARKET_OFFERS_VIEW_SELLOFFERS");
            _loc2_.setStyle("fontWeight","bold");
            _loc1_.addChild(_loc2_);
            this.m_UISellAccept = new CustomButton();
            this.m_UISellAccept.enabled = false;
            this.m_UISellAccept.label = resourceManager.getString(BUNDLE,"MARKET_OFFERS_VIEW_SELLACCEPT");
            this.m_UISellAccept.addEventListener(MouseEvent.CLICK,this.onAcceptClick);
            _loc1_.addChild(this.m_UISellAccept);
            addChild(_loc1_);
            this.m_UISellOffers = new CustomDataGrid();
            this.m_UISellOffers.columns = this.createOffersListColumns();
            this.m_UISellOffers.dataProvider = this.m_SellOffersView;
            this.m_UISellOffers.dataTipFunction = this.createOfferToolTip;
            this.m_UISellOffers.draggableColumns = false;
            this.m_UISellOffers.itemRenderer = new ClassFactory(CustomItemRenderer);
            this.m_UISellOffers.percentHeight = 100;
            this.m_UISellOffers.percentWidth = 100;
            this.m_UISellOffers.resizableColumns = false;
            this.m_UISellOffers.showDataTips = true;
            this.m_UISellOffers.styleName = "marketWidgetOffers";
            this.m_UISellOffers.verticalScrollPolicy = ScrollPolicy.ON;
            this.m_UISellOffers.addEventListener(ListEvent.CHANGE,this.onOfferClick);
            addChild(this.m_UISellOffers);
            _loc1_ = new HBox();
            _loc1_.percentHeight = NaN;
            _loc1_.percentWidth = 100;
            _loc2_ = new Label();
            _loc2_.percentHeight = NaN;
            _loc2_.percentWidth = 100;
            _loc2_.text = resourceManager.getString(BUNDLE,"MARKET_OFFERS_VIEW_BUYOFFERS");
            _loc2_.setStyle("fontWeight","bold");
            _loc1_.addChild(_loc2_);
            this.m_UIBuyAccept = new CustomButton();
            this.m_UIBuyAccept.enabled = false;
            this.m_UIBuyAccept.label = resourceManager.getString(BUNDLE,"MARKET_OFFERS_VIEW_BUYACCEPT");
            this.m_UIBuyAccept.addEventListener(MouseEvent.CLICK,this.onAcceptClick);
            _loc1_.addChild(this.m_UIBuyAccept);
            addChild(_loc1_);
            this.m_UIBuyOffers = new CustomDataGrid();
            this.m_UIBuyOffers.columns = this.createOffersListColumns();
            this.m_UIBuyOffers.dataProvider = this.m_BuyOffersView;
            this.m_UIBuyOffers.dataTipFunction = this.createOfferToolTip;
            this.m_UIBuyOffers.draggableColumns = false;
            this.m_UIBuyOffers.itemRenderer = new ClassFactory(CustomItemRenderer);
            this.m_UIBuyOffers.percentHeight = 100;
            this.m_UIBuyOffers.percentWidth = 100;
            this.m_UIBuyOffers.resizableColumns = false;
            this.m_UIBuyOffers.showDataTips = true;
            this.m_UIBuyOffers.styleName = "marketWidgetOffers";
            this.m_UIBuyOffers.verticalScrollPolicy = ScrollPolicy.ON;
            this.m_UIBuyOffers.addEventListener(ListEvent.CHANGE,this.onOfferClick);
            addChild(this.m_UIBuyOffers);
            this.m_UIConstructed = true;
         }
      }
      
      override public function set selectedType(param1:*) : void
      {
         if(selectedType != param1)
         {
            super.selectedType = param1;
            this.m_UncommittedSelectedType = true;
            invalidateProperties();
         }
      }
      
      private function createOffersListColumns() : Array
      {
         var _loc1_:Array = [];
         var _loc2_:DataGridColumn = new DataGridColumn();
         _loc2_.headerText = resourceManager.getString(BUNDLE,"OFFERS_VIEW_COLUMN_NAME");
         _loc2_.dataField = "character";
         _loc2_.editable = false;
         _loc2_.resizable = false;
         _loc2_.width = 120;
         _loc1_.push(_loc2_);
         _loc2_ = new DataGridColumn();
         _loc2_.headerText = resourceManager.getString(BUNDLE,"OFFERS_VIEW_COLUMN_AMOUNT");
         _loc2_.dataField = "amount";
         _loc2_.editable = false;
         _loc2_.resizable = false;
         _loc2_.width = 80;
         _loc1_.push(_loc2_);
         _loc2_ = new DataGridColumn();
         _loc2_.headerText = resourceManager.getString(BUNDLE,"OFFERS_VIEW_COLUMN_TOTALPRICE");
         _loc2_.dataField = "totalPrice";
         _loc2_.editable = false;
         _loc2_.labelFunction = Utility.formatOfferTotalPrice;
         _loc2_.resizable = false;
         _loc2_.width = 80;
         _loc1_.push(_loc2_);
         _loc2_ = new DataGridColumn();
         _loc2_.headerText = resourceManager.getString(BUNDLE,"OFFERS_VIEW_COLUMN_PIECEPRICE");
         _loc2_.dataField = "piecePrice";
         _loc2_.editable = false;
         _loc2_.labelFunction = Utility.formatOfferPiecePrice;
         _loc2_.resizable = false;
         _loc2_.width = 80;
         _loc1_.push(_loc2_);
         _loc2_ = new DataGridColumn();
         _loc2_.headerText = resourceManager.getString(BUNDLE,"OFFERS_VIEW_COLUMN_TIMESTAMP");
         _loc2_.dataField = "terminationTimestamp";
         _loc2_.labelFunction = Utility.formatOfferTerminationTimestamp;
         _loc2_.editable = false;
         _loc2_.resizable = false;
         _loc2_.width = 140;
         _loc1_.push(_loc2_);
         return _loc1_;
      }
      
      private function onOffersChange(param1:Event) : void
      {
         if(param1 != null && market.browseTypeID != MarketWidget.REQUEST_OWN_OFFERS && market.browseTypeID != MarketWidget.REQUEST_OWN_HISTORY)
         {
            this.updateOfferList(market.browseOffers);
         }
      }
      
      private function checkAccept(param1:Offer) : Boolean
      {
         return !market.serverResponsePending && param1 != null && (param1.kind != Offer.BUY_OFFER || market.getDepotAmount(param1.typeID) > 0) && (param1.kind != Offer.SELL_OFFER || market.accountBalance >= param1.piecePrice);
      }
      
      private function onAcceptClose(param1:CloseEvent) : void
      {
         var _loc2_:AcceptOfferDialog = null;
         if(param1 != null && param1.detail == EmbeddedDialog.OKAY && (_loc2_ = param1.currentTarget as AcceptOfferDialog) != null)
         {
            market.acceptOffer(_loc2_.offer,_loc2_.amount);
            this.updateOfferSelection(null);
         }
      }
      
      private function updateOfferSelection(param1:Offer) : void
      {
         if(param1 != null && param1.kind == Offer.BUY_OFFER)
         {
            this.m_UIBuyAccept.enabled = this.checkAccept(param1);
            this.m_UISellAccept.enabled = false;
            this.m_UISellOffers.selectedItem = null;
         }
         else if(param1 != null)
         {
            this.m_UIBuyAccept.enabled = false;
            this.m_UIBuyOffers.selectedItem = null;
            this.m_UISellAccept.enabled = this.checkAccept(param1);
         }
         else
         {
            this.m_UIBuyAccept.enabled = false;
            this.m_UIBuyOffers.selectedItem = null;
            this.m_UISellAccept.enabled = false;
            this.m_UISellOffers.selectedItem = null;
         }
      }
   }
}

import mx.controls.dataGridClasses.DataGridItemRenderer;
import mx.events.ToolTipEvent;
import tibia.market.Offer;

class CustomItemRenderer extends DataGridItemRenderer
{
    
   
   function CustomItemRenderer()
   {
      super();
   }
   
   override protected function toolTipShowHandler(param1:ToolTipEvent) : void
   {
   }
   
   override public function set data(param1:Object) : void
   {
      var _loc2_:* = undefined;
      var _loc3_:Offer = null;
      if(data != param1)
      {
         super.data = param1;
         _loc2_ = undefined;
         _loc3_ = param1 as Offer;
         if(_loc3_ != null && _loc3_.isDubious)
         {
            _loc2_ = 16711680;
         }
         setStyle("textRollOverColor",_loc2_);
         setStyle("textSelectedColor",_loc2_);
         setStyle("color",_loc2_);
      }
   }
}
