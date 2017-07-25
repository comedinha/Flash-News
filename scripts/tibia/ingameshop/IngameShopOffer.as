package tibia.ingameshop
{
   public class IngameShopOffer
   {
      
      public static const HIGHLIGHT_STATE_SALE:int = 2;
      
      public static const HIGHLIGHT_STATE_NEW:int = 1;
      
      public static const DISABLED_STATE_DISABLED:int = 1;
      
      public static const HIGHLIGHT_STATE_NONE:int = 0;
      
      public static const DISABLED_STATE_ACTIVE:int = 0;
      
      public static const DISABLED_STATE_HIDDEN:int = 2;
      
      public static const HIGHLIGHT_STATE_TIMED:int = 3;
       
      
      private var m_DisabledState:int;
      
      private var m_OfferID:int;
      
      private var m_BasePrice:Number;
      
      private var m_Description:String;
      
      private var m_Products:Vector.<IngameShopProduct>;
      
      private var m_DisabledReason:String;
      
      private var m_ActualPrice:Number;
      
      private var m_SalidValidUntilTimestamp:Number;
      
      private var m_HighlightState:int;
      
      private var m_Name:String;
      
      private var m_IconIdentifiers:Vector.<String>;
      
      public function IngameShopOffer(param1:int, param2:String, param3:String)
      {
         super();
         this.m_OfferID = param1;
         this.m_Name = param2;
         this.m_Description = param3;
         this.m_Products = new Vector.<IngameShopProduct>();
         this.m_IconIdentifiers = new Vector.<String>();
         this.m_ActualPrice = 0;
         this.m_BasePrice = NaN;
         this.m_HighlightState = HIGHLIGHT_STATE_NONE;
         this.m_DisabledState = DISABLED_STATE_ACTIVE;
         this.m_DisabledReason = "";
         this.m_SalidValidUntilTimestamp = 0;
      }
      
      public static function s_ReplacePlaceholderTextInStoreDescription(param1:String) : String
      {
         return param1.replace(/\{1\}/g,"\nNote that decoration kits and the objects they contain are not tradable. A decoration kit can only be unwrapped in a house of which the purchasing character is the owner. If the character loses this house or gives it to another character, the purchased decoration will be wrapped back and sent to the character\'s inbox.");
      }
      
      public function set disabledReason(param1:String) : void
      {
         this.m_DisabledReason = param1;
      }
      
      public function set highlightState(param1:int) : void
      {
         this.m_HighlightState = param1;
      }
      
      public function get highlightState() : int
      {
         return this.m_HighlightState;
      }
      
      public function set products(param1:Vector.<IngameShopProduct>) : void
      {
         this.m_Products = param1;
      }
      
      public function get price() : Number
      {
         return this.m_ActualPrice;
      }
      
      public function get name() : String
      {
         return this.m_Name;
      }
      
      public function isTimed() : Boolean
      {
         return this.m_HighlightState == HIGHLIGHT_STATE_TIMED;
      }
      
      public function isBundle() : Boolean
      {
         return this.m_Products.length > 1;
      }
      
      public function get disabledState() : int
      {
         return this.m_DisabledState;
      }
      
      public function isSale() : Boolean
      {
         return this.m_HighlightState == HIGHLIGHT_STATE_SALE;
      }
      
      public function isNew() : Boolean
      {
         return this.m_HighlightState == HIGHLIGHT_STATE_NEW;
      }
      
      public function get disabledReason() : String
      {
         return this.m_DisabledReason;
      }
      
      public function set price(param1:Number) : void
      {
         this.m_ActualPrice = param1;
      }
      
      public function set iconIdentifiers(param1:Vector.<String>) : void
      {
         this.m_IconIdentifiers = param1;
      }
      
      public function clone() : IngameShopOffer
      {
         var Clone:IngameShopOffer = new IngameShopOffer(this.m_OfferID,this.m_Name,this.m_Description);
         Clone.m_ActualPrice = this.m_ActualPrice;
         Clone.m_BasePrice = this.m_BasePrice;
         Clone.m_HighlightState = this.m_HighlightState;
         Clone.m_Products = this.m_Products.map(function(param1:IngameShopProduct):IngameShopProduct
         {
            return param1.clone();
         });
         Clone.m_IconIdentifiers = this.m_IconIdentifiers;
         Clone.m_DisabledReason = this.m_DisabledReason;
         Clone.m_DisabledState = this.m_DisabledState;
         Clone.m_SalidValidUntilTimestamp = this.m_SalidValidUntilTimestamp;
         return Clone;
      }
      
      public function set disabledState(param1:int) : void
      {
         if(param1 != DISABLED_STATE_ACTIVE && param1 != DISABLED_STATE_DISABLED && param1 != DISABLED_STATE_HIDDEN)
         {
            throw ArgumentError("IngameShopOffer.disabled (set): Invalid disabled state " + param1);
         }
         this.m_DisabledState = param1;
      }
      
      public function get products() : Vector.<IngameShopProduct>
      {
         return this.m_Products;
      }
      
      public function set basePrice(param1:Number) : void
      {
         this.m_BasePrice = param1;
      }
      
      public function get iconIdentifiers() : Vector.<String>
      {
         return this.m_IconIdentifiers;
      }
      
      public function set saleValidUntilTimestamp(param1:Number) : void
      {
         this.m_SalidValidUntilTimestamp = param1;
      }
      
      public function get saleValidUntilTimestamp() : Number
      {
         return this.m_SalidValidUntilTimestamp;
      }
      
      public function get disabled() : Boolean
      {
         return this.m_DisabledState != DISABLED_STATE_ACTIVE;
      }
      
      public function get offerID() : int
      {
         return this.m_OfferID;
      }
      
      public function get basePrice() : Number
      {
         return this.m_BasePrice;
      }
      
      public function priceReductionPercent() : Number
      {
         var _loc1_:Number = NaN;
         if(!isNaN(this.m_BasePrice) && this.m_BasePrice > 0 && this.m_BasePrice > this.m_ActualPrice)
         {
            _loc1_ = this.m_ActualPrice / this.m_BasePrice;
            return 1 - _loc1_;
         }
         return 0;
      }
      
      public function get description() : String
      {
         return this.m_Description;
      }
   }
}
