package tibia.market.marketWidgetClasses
{
   import mx.collections.ArrayCollection;
   import mx.events.ListEvent;
   import tibia.market.Offer;
   import tibia.market.MarketWidget;
   import mx.events.CloseEvent;
   import shared.controls.EmbeddedDialog;
   import mx.controls.dataGridClasses.DataGridColumn;
   import flash.events.Event;
   import mx.controls.DataGrid;
   import mx.collections.Sort;
   import mx.collections.SortField;
   import mx.controls.Button;
   import flash.events.MouseEvent;
   import mx.core.EventPriority;
   import mx.containers.HBox;
   import mx.controls.Label;
   import shared.controls.CustomButton;
   import shared.controls.CustomDataGrid;
   import mx.core.ScrollPolicy;
   import mx.containers.BoxDirection;
   
   public class OwnOffersView extends MarketComponent
   {
      
      private static const BUNDLE:String = "MarketWidget";
       
      
      private var m_SellOffersView:ArrayCollection;
      
      private var m_UISellOffers:DataGrid = null;
      
      private var m_BuyOffersView:ArrayCollection;
      
      private var m_UISellCancel:Button = null;
      
      private var m_UIBuyOffers:DataGrid = null;
      
      private var m_UIBuyCancel:Button = null;
      
      private var m_UIConstructed:Boolean = false;
      
      public function OwnOffersView(param1:MarketWidget)
      {
         this.m_BuyOffersView = new ArrayCollection();
         this.m_SellOffersView = new ArrayCollection();
         super(param1);
         direction = BoxDirection.VERTICAL;
         label = resourceManager.getString(BUNDLE,"OWN_OFFERS_VIEW_LABEL");
         this.m_BuyOffersView = new ArrayCollection();
         this.m_BuyOffersView.filterFunction = Utility.createFilter({"kind":Offer.BUY_OFFER});
         this.m_BuyOffersView.refresh();
         this.m_SellOffersView = new ArrayCollection();
         this.m_SellOffersView.filterFunction = Utility.createFilter({"kind":Offer.SELL_OFFER});
         this.m_SellOffersView.refresh();
         market.addEventListener(MarketWidget.BROWSE_OFFERS_CHANGE,this.onOffersChange);
      }
      
      private function onOfferDoubleClick(param1:ListEvent) : void
      {
         var _loc2_:Offer = null;
         if(param1 != null && param1.itemRenderer != null && (_loc2_ = param1.itemRenderer.data as Offer) != null && MarketWidget.isValidTypeID(_loc2_.typeID))
         {
            market.selectedType = _loc2_.typeID;
            market.selectedView = MarketWidget.VIEW_MARKET_OFFERS;
         }
      }
      
      private function onCancelClose(param1:CloseEvent) : void
      {
         var _loc2_:CancelOfferDialog = null;
         if(param1 != null && param1.detail == EmbeddedDialog.YES && (_loc2_ = param1.currentTarget as CancelOfferDialog) != null)
         {
            market.cancelOffer(_loc2_.offer);
            this.updateOfferSelection(null);
         }
      }
      
      private function onOfferClick(param1:ListEvent) : void
      {
         if(param1 != null && param1.itemRenderer != null)
         {
            this.updateOfferSelection(param1.itemRenderer.data as Offer);
         }
      }
      
      private function createOffersListColumns() : Array
      {
         var _loc1_:Array = [];
         var _loc2_:DataGridColumn = new DataGridColumn();
         _loc2_.headerText = resourceManager.getString(BUNDLE,"OFFERS_VIEW_COLUMN_TYPEID");
         _loc2_.dataField = "typeID";
         _loc2_.editable = false;
         _loc2_.labelFunction = Utility.formatOfferTypeID;
         _loc2_.resizable = false;
         _loc2_.sortCompareFunction = Utility.compareOfferByItemName;
         _loc2_.width = 290;
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
         if(param1 != null && (market.browseTypeID == MarketWidget.REQUEST_OWN_OFFERS || market.browseTypeID == -1))
         {
            this.updateOfferList(market.browseOffers);
         }
      }
      
      private function updateOfferList(param1:Array) : void
      {
         var _loc2_:Sort = new Sort();
         var _loc3_:SortField = new SortField("typeID",false,false,false);
         _loc3_.compareFunction = Utility.compareOfferByItemName;
         _loc2_.fields = [_loc3_,new SortField("terminationTimestamp",false,false,true)];
         this.m_BuyOffersView.sort = _loc2_;
         this.m_BuyOffersView.source = param1;
         this.m_BuyOffersView.refresh();
         this.m_SellOffersView.sort = _loc2_;
         this.m_SellOffersView.source = param1;
         this.m_SellOffersView.refresh();
         this.updateOfferSelection(null);
      }
      
      private function onCancelClick(param1:MouseEvent) : void
      {
         var _loc3_:CancelOfferDialog = null;
         var _loc2_:Offer = null;
         if(param1 != null && (_loc2_ = param1.currentTarget == this.m_UIBuyCancel?this.m_UIBuyOffers.selectedItem as Offer:this.m_UISellOffers.selectedItem as Offer) != null && !market.serverResponsePending)
         {
            _loc3_ = new CancelOfferDialog();
            _loc3_.offer = _loc2_;
            _loc3_.addEventListener(CloseEvent.CLOSE,this.onCancelClose,false,EventPriority.DEFAULT,true);
            market.embeddedDialog = _loc3_;
         }
      }
      
      private function updateOfferSelection(param1:Offer) : void
      {
         if(param1 != null && param1.kind == Offer.BUY_OFFER)
         {
            this.m_UIBuyCancel.enabled = !market.serverResponsePending;
            this.m_UISellCancel.enabled = false;
            this.m_UISellOffers.selectedItem = null;
         }
         else if(param1 != null)
         {
            this.m_UIBuyCancel.enabled = false;
            this.m_UIBuyOffers.selectedItem = null;
            this.m_UISellCancel.enabled = !market.serverResponsePending;
         }
         else
         {
            this.m_UIBuyCancel.enabled = false;
            this.m_UIBuyOffers.selectedItem = null;
            this.m_UISellCancel.enabled = false;
            this.m_UISellOffers.selectedItem = null;
         }
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
            _loc2_.text = resourceManager.getString(BUNDLE,"OWN_OFFERS_VIEW_SELLOFFERS");
            _loc2_.setStyle("fontWeight","bold");
            _loc1_.addChild(_loc2_);
            this.m_UISellCancel = new CustomButton();
            this.m_UISellCancel.enabled = false;
            this.m_UISellCancel.label = resourceManager.getString(BUNDLE,"OWN_OFFERS_VIEW_SELLCANCEL");
            this.m_UISellCancel.addEventListener(MouseEvent.CLICK,this.onCancelClick);
            _loc1_.addChild(this.m_UISellCancel);
            addChild(_loc1_);
            this.m_UISellOffers = new CustomDataGrid();
            this.m_UISellOffers.columns = this.createOffersListColumns();
            this.m_UISellOffers.dataProvider = this.m_SellOffersView;
            this.m_UISellOffers.doubleClickEnabled = true;
            this.m_UISellOffers.draggableColumns = false;
            this.m_UISellOffers.percentHeight = 100;
            this.m_UISellOffers.percentWidth = 100;
            this.m_UISellOffers.resizableColumns = false;
            this.m_UISellOffers.styleName = "marketWidgetOffers";
            this.m_UISellOffers.verticalScrollPolicy = ScrollPolicy.ON;
            this.m_UISellOffers.addEventListener(ListEvent.CHANGE,this.onOfferClick);
            this.m_UISellOffers.addEventListener(ListEvent.ITEM_DOUBLE_CLICK,this.onOfferDoubleClick);
            addChild(this.m_UISellOffers);
            _loc1_ = new HBox();
            _loc1_.percentHeight = NaN;
            _loc1_.percentWidth = 100;
            _loc2_ = new Label();
            _loc2_.percentHeight = NaN;
            _loc2_.percentWidth = 100;
            _loc2_.text = resourceManager.getString(BUNDLE,"OWN_OFFERS_VIEW_BUYOFFERS");
            _loc2_.setStyle("fontWeight","bold");
            _loc1_.addChild(_loc2_);
            this.m_UIBuyCancel = new CustomButton();
            this.m_UIBuyCancel.enabled = false;
            this.m_UIBuyCancel.label = resourceManager.getString(BUNDLE,"OWN_OFFERS_VIEW_BUYCANCEL");
            this.m_UIBuyCancel.addEventListener(MouseEvent.CLICK,this.onCancelClick);
            _loc1_.addChild(this.m_UIBuyCancel);
            addChild(_loc1_);
            this.m_UIBuyOffers = new CustomDataGrid();
            this.m_UIBuyOffers.columns = this.createOffersListColumns();
            this.m_UIBuyOffers.dataProvider = this.m_BuyOffersView;
            this.m_UIBuyOffers.doubleClickEnabled = true;
            this.m_UIBuyOffers.draggableColumns = false;
            this.m_UIBuyOffers.percentHeight = 100;
            this.m_UIBuyOffers.percentWidth = 100;
            this.m_UIBuyOffers.resizableColumns = false;
            this.m_UIBuyOffers.styleName = "marketWidgetOffers";
            this.m_UIBuyOffers.verticalScrollPolicy = ScrollPolicy.ON;
            this.m_UIBuyOffers.addEventListener(ListEvent.CHANGE,this.onOfferClick);
            this.m_UIBuyOffers.addEventListener(ListEvent.ITEM_DOUBLE_CLICK,this.onOfferDoubleClick);
            addChild(this.m_UIBuyOffers);
            this.m_UIConstructed = true;
         }
      }
   }
}
