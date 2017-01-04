package tibia.ingameshop.shopWidgetClasses
{
   import flash.errors.IllegalOperationError;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import mx.collections.ArrayCollection;
   import mx.core.ClassFactory;
   import mx.core.IDataRenderer;
   import mx.events.ListEvent;
   import shared.controls.CustomTileList;
   import tibia.ingameshop.IngameShopCategory;
   import tibia.ingameshop.IngameShopEvent;
   import tibia.ingameshop.IngameShopManager;
   import tibia.ingameshop.IngameShopOffer;
   import tibia.ingameshop.IngameShopWidget;
   
   public class OfferList extends CustomTileList implements IIngameShopWidgetComponent, IDataRenderer
   {
      
      private static const LIST_ITEM_HEIGHT:int = 140;
      
      private static const BUNDLE:String = "IngameShopWidget";
      
      private static const LIST_ITEM_WIDTH:int = 120;
       
      
      private var m_LastStoreEventOffer:int;
      
      private var m_UncommittedCategory:Boolean;
      
      private var m_ShopWindow:IngameShopWidget;
      
      public function OfferList()
      {
         super();
         styleName = "ingameShopOfferList";
         itemRenderer = new ClassFactory(OfferRenderer);
         columnWidth = LIST_ITEM_WIDTH;
         rowHeight = LIST_ITEM_HEIGHT;
         doubleClickEnabled = true;
         addEventListener(ListEvent.CHANGE,this.onOfferSelected);
         addEventListener(ListEvent.ITEM_CLICK,this.onOfferClicked);
         this.m_UncommittedCategory = true;
      }
      
      override protected function mouseWheelHandler(param1:MouseEvent) : void
      {
         param1.delta = Math.max(-1,Math.min(1,param1.delta));
         super.mouseWheelHandler(param1);
      }
      
      private function updateUIOnOfferSelection(param1:IngameShopOffer) : void
      {
         if(this.m_ShopWindow != null)
         {
            this.m_ShopWindow.mainView.setShowButtonBar(param1 != null);
            this.m_ShopWindow.mainView.detailsList.offer = param1;
         }
      }
      
      protected function onOfferSelected(param1:ListEvent) : void
      {
         var _loc2_:IngameShopOffer = param1.itemRenderer.data as IngameShopOffer;
         this.updateUIOnOfferSelection(_loc2_);
      }
      
      override protected function commitProperties() : void
      {
         var _loc1_:IngameShopCategory = null;
         var _loc2_:Array = null;
         var _loc3_:int = 0;
         super.commitProperties();
         if(this.m_UncommittedCategory)
         {
            selectedItem = null;
            this.updateUIOnOfferSelection(null);
            _loc1_ = data as IngameShopCategory;
            if(_loc1_ != null)
            {
               _loc2_ = new Array();
               _loc3_ = 0;
               while(_loc3_ < _loc1_.offers.length)
               {
                  _loc2_.push(_loc1_.offers[_loc3_]);
                  _loc3_++;
               }
               dataProvider = new ArrayCollection(_loc2_);
            }
            else
            {
               dataProvider = null;
            }
            this.m_UncommittedCategory = false;
         }
      }
      
      public function getSelectedOffer() : IngameShopOffer
      {
         return selectedItem as IngameShopOffer;
      }
      
      protected function onOfferClicked(param1:ListEvent) : void
      {
         var _loc2_:IngameShopOffer = param1.itemRenderer.data as IngameShopOffer;
         if(_loc2_ != null && this.m_LastStoreEventOffer != _loc2_.offerID)
         {
            this.m_LastStoreEventOffer = _loc2_.offerID;
            Tibia.s_GetCommunication().sendCSTOREEVENT(IngameShopManager.STORE_EVENT_SELECT_OFFER,_loc2_.offerID);
         }
      }
      
      protected function onCurrentOffersChanged(param1:IngameShopEvent) : void
      {
         this.m_UncommittedCategory = true;
         invalidateProperties();
      }
      
      public function set shopWidget(param1:IngameShopWidget) : void
      {
         if(this.m_ShopWindow != null)
         {
            throw new IllegalOperationError("IngameShopOfferList.shopWidget: Attempted to set reference twice");
         }
         this.m_ShopWindow = param1;
      }
      
      protected function onOfferDoubleClicked(param1:Event) : void
      {
         var _loc3_:IngameShopEvent = null;
         var _loc2_:IngameShopOffer = this.getSelectedOffer();
         if(_loc2_ != null)
         {
            _loc3_ = new IngameShopEvent(IngameShopEvent.OFFER_ACTIVATED);
            _loc3_.data = _loc2_;
            dispatchEvent(_loc3_);
         }
      }
      
      override public function set data(param1:Object) : void
      {
         var _loc2_:IngameShopCategory = super.data as IngameShopCategory;
         if(_loc2_ != null)
         {
            _loc2_.removeEventListener(IngameShopEvent.CATEGORY_OFFERS_CHANGED,this.onCurrentOffersChanged);
         }
         var _loc3_:IngameShopCategory = param1 as IngameShopCategory;
         if(_loc3_ != null)
         {
            _loc3_.addEventListener(IngameShopEvent.CATEGORY_OFFERS_CHANGED,this.onCurrentOffersChanged);
         }
         super.data = param1;
         this.m_UncommittedCategory = true;
         invalidateProperties();
      }
      
      public function dispose() : void
      {
         removeEventListener(ListEvent.CHANGE,this.onOfferSelected);
         removeEventListener(ListEvent.ITEM_CLICK,this.onOfferClicked);
         this.data = null;
         this.m_ShopWindow = null;
      }
   }
}
