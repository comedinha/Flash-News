package tibia.ingameshop.shopWidgetClasses
{
   import mx.containers.HBox;
   import mx.containers.VBox;
   import mx.controls.Text;
   import tibia.ingameshop.IngameShopOffer;
   
   public class OfferDisplayBlock extends HBox
   {
      
      private static const BUNDLE:String = "IngameShopWidget";
       
      
      private var m_UIPrice:CoinWidget;
      
      private var m_Offer:IngameShopOffer;
      
      private var m_UncommittedOffer:Boolean;
      
      private var m_UITitle:Text;
      
      private var m_UIIcon:SliderImage;
      
      public function OfferDisplayBlock()
      {
         super();
      }
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
         if(this.m_UncommittedOffer)
         {
            if(this.m_Offer != null)
            {
               this.m_UITitle.text = this.m_Offer.name;
               this.m_UIPrice.coins = this.m_Offer.price;
               this.m_UIPrice.baseCoins = this.m_Offer.basePrice;
               this.m_UIIcon.setImageIdentifiers(this.m_Offer.iconIdentifiers);
            }
            else
            {
               this.m_UIIcon.dynamicImage = null;
            }
            this.m_UncommittedOffer = false;
         }
      }
      
      public function set offer(param1:IngameShopOffer) : void
      {
         this.m_Offer = param1;
         this.m_UncommittedOffer = true;
         invalidateProperties();
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this.m_UIIcon = new SliderImage(64);
         this.m_UIIcon.setStyle("paddingTop",2);
         this.m_UIIcon.setStyle("paddingBottom",12);
         addChild(this.m_UIIcon);
         var _loc1_:VBox = new VBox();
         _loc1_.percentWidth = _loc1_.percentHeight = 100;
         _loc1_.setStyle("verticalGap",2);
         _loc1_.setStyle("verticalAlign","middle");
         addChild(_loc1_);
         this.m_UITitle = new Text();
         this.m_UITitle.styleName = "ingameShopBold";
         _loc1_.addChild(this.m_UITitle);
         this.m_UIPrice = new CoinWidget();
         this.m_UIPrice.percentWidth = 100;
         _loc1_.addChild(this.m_UIPrice);
      }
      
      public function get offer() : IngameShopOffer
      {
         return this.m_Offer;
      }
   }
}
