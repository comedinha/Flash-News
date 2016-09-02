package tibia.ingameshop.shopWidgetClasses
{
   import mx.containers.VBox;
   import mx.controls.Text;
   import mx.controls.Label;
   import mx.containers.Grid;
   import tibia.ingameshop.IngameShopOffer;
   import tibia.ingameshop.IngameShopWidget;
   import shared.utility.i18n.i18nFormatDate;
   import flash.errors.IllegalOperationError;
   import tibia.ingameshop.IngameShopProduct;
   import mx.containers.GridRow;
   import mx.containers.GridItem;
   
   public class OfferDetails extends VBox implements IIngameShopWidgetComponent
   {
      
      private static const BUNDLE:String = "IngameShopWidget";
      
      private static const DISABLED_REASON_COLOR:String = 13843516.toString(16);
       
      
      private var m_UIBundleBox:VBox;
      
      private var m_UIDescriptionText:Text;
      
      private var m_UncommittedOffer:Boolean;
      
      private var m_UIProductGrid:Grid;
      
      private var m_Offer:IngameShopOffer;
      
      private var m_ShopWindow:IngameShopWidget;
      
      public function OfferDetails()
      {
         super();
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this.m_UIDescriptionText = new Text();
         this.m_UIDescriptionText.percentWidth = 100;
         addChild(this.m_UIDescriptionText);
         this.m_UIBundleBox = new VBox();
         this.m_UIBundleBox.percentWidth = 100;
         this.m_UIBundleBox.styleName = "ingameShopNoPadding";
         addChild(this.m_UIBundleBox);
         var _loc1_:Label = new Label();
         _loc1_.text = resourceManager.getString(BUNDLE,"LBL_BUNDLE");
         _loc1_.styleName = "ingameShopBold";
         this.m_UIBundleBox.addChild(_loc1_);
         this.m_UIProductGrid = new Grid();
         this.m_UIProductGrid.percentWidth = 100;
         this.m_UIBundleBox.addChild(this.m_UIProductGrid);
      }
      
      private function formatTimeLeftString(param1:Number) : String
      {
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc2_:Number = param1 - Math.floor(new Date().time / 1000);
         if(_loc2_ > 0)
         {
            _loc3_ = _loc2_ / 86400;
            _loc4_ = _loc2_ % 86400 / (60 * 60);
            if(_loc3_ > 0)
            {
               return resourceManager.getString(BUNDLE,_loc3_ == 1?"TEXT_SALE_DURATION_DAY":"TEXT_SALE_DURATION_DAYS",[_loc3_]);
            }
            if(_loc4_ > 0)
            {
               return resourceManager.getString(BUNDLE,_loc4_ == 1?"TEXT_SALE_DURATION_HOUR":"TEXT_SALE_DURATION_HOURS",[_loc4_]);
            }
            return resourceManager.getString(BUNDLE,"TEXT_SALE_DURATION_MINUTES");
         }
         return resourceManager.getString(BUNDLE,"TEXT_SALE_DURATION_MINUTES");
      }
      
      public function dispose() : void
      {
         this.m_ShopWindow = null;
      }
      
      override protected function commitProperties() : void
      {
         var _loc1_:* = null;
         if(this.m_UncommittedOffer)
         {
            if(this.m_Offer != null)
            {
               _loc1_ = "";
               if(this.m_Offer.disabled)
               {
                  _loc1_ = _loc1_ + ("<p><font color=\"#" + DISABLED_REASON_COLOR + "\">");
                  _loc1_ = _loc1_ + (resourceManager.getString(BUNDLE,"LBL_CANNOT_BUY_GENERIC") + "\n" + this.m_Offer.disabledReason);
                  _loc1_ = _loc1_ + "</font></p>\n";
               }
               if(this.m_Offer.isSale())
               {
                  _loc1_ = _loc1_ + "<p>";
                  _loc1_ = _loc1_ + resourceManager.getString(BUNDLE,"TEXT_SALE_DESCRIPTION",[i18nFormatDate(new Date(this.m_Offer.saleValidUntilTimestamp * 1000)),this.formatTimeLeftString(this.m_Offer.saleValidUntilTimestamp),resourceManager.getString(BUNDLE,this.m_Offer.price == 1?"LBL_CREDITS_LONG_SINGULAR":"LBL_CREDITS_LONG_PLURAL",[this.m_Offer.price]),(this.m_Offer.priceReductionPercent() * 100).toFixed(0),resourceManager.getString(BUNDLE,this.m_Offer.basePrice == 1?"LBL_CREDITS_LONG_SINGULAR":"LBL_CREDITS_LONG_PLURAL",[this.m_Offer.basePrice])]);
                  _loc1_ = _loc1_ + "</p>\n";
               }
               _loc1_ = _loc1_ + this.m_Offer.description;
               this.m_UIDescriptionText.htmlText = _loc1_;
               this.m_UIBundleBox.setVisible(this.m_Offer.isBundle());
               this.buildBundleGrid();
            }
            this.m_UncommittedOffer = false;
         }
      }
      
      public function set shopWidget(param1:IngameShopWidget) : void
      {
         if(this.m_ShopWindow != null)
         {
            throw new IllegalOperationError("IngameShopOfferList.shopWidget: Attempted to set reference twice");
         }
         this.m_ShopWindow = param1;
      }
      
      public function get offer() : IngameShopOffer
      {
         return this.m_Offer;
      }
      
      private function buildBundleGrid() : void
      {
         var _loc1_:IngameShopProduct = null;
         var _loc2_:GridRow = null;
         var _loc3_:GridItem = null;
         var _loc4_:GridItem = null;
         var _loc5_:SliderImage = null;
         var _loc6_:Label = null;
         this.m_UIProductGrid.removeAllChildren();
         for each(_loc1_ in this.m_Offer.products)
         {
            _loc2_ = new GridRow();
            _loc3_ = new GridItem();
            _loc4_ = new GridItem();
            _loc4_.setStyle("verticalAlign","middle");
            _loc2_.addChild(_loc3_);
            _loc2_.addChild(_loc4_);
            this.m_UIProductGrid.addChild(_loc2_);
            _loc5_ = new SliderImage(64);
            _loc5_.setImageIdentifiers(_loc1_.iconIdentifiers);
            _loc5_.toolTip = _loc1_.description;
            _loc3_.addChild(_loc5_);
            _loc6_ = new Label();
            _loc6_.text = _loc1_.name;
            _loc6_.toolTip = _loc1_.description;
            _loc4_.addChild(_loc6_);
         }
      }
      
      public function set offer(param1:IngameShopOffer) : void
      {
         this.m_Offer = param1;
         this.m_UncommittedOffer = true;
         invalidateProperties();
      }
   }
}
