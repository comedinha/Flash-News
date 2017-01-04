package tibia.ingameshop
{
   import flash.events.EventDispatcher;
   
   public class IngameShopCategory extends EventDispatcher
   {
      
      private static var CATEGORY_NEW_PRODUCTS:String = "New Products";
      
      private static var CATEGORY_SPECIAL_OFFERS:String = "Special Offers";
       
      
      private var m_Offers:Vector.<IngameShopOffer> = null;
      
      private var m_Subcategories:Vector.<IngameShopCategory> = null;
      
      private var m_CategoryHighlightState:int = 0;
      
      private var m_Description:String = null;
      
      private var m_Name:String = null;
      
      private var m_IconIdentifiers:Vector.<String>;
      
      public function IngameShopCategory(param1:String, param2:String, param3:int)
      {
         super();
         if(param1 == null)
         {
            throw new ArgumentError("IngameShopCategory: Name is null");
         }
         this.m_Name = param1;
         this.m_Description = param2;
         this.m_CategoryHighlightState = param3;
         this.m_Subcategories = new Vector.<IngameShopCategory>();
         this.m_Offers = new Vector.<IngameShopOffer>();
         this.m_IconIdentifiers = new Vector.<String>();
      }
      
      public function set iconIdentifiers(param1:Vector.<String>) : void
      {
         this.m_IconIdentifiers = param1;
      }
      
      public function get subCategories() : Vector.<IngameShopCategory>
      {
         return this.m_Subcategories;
      }
      
      public function hasTimedOffer() : Boolean
      {
         return this.m_CategoryHighlightState == IngameShopOffer.HIGHLIGHT_STATE_TIMED;
      }
      
      public function hasSaleOffer() : Boolean
      {
         return this.m_Name != IngameShopCategory.CATEGORY_SPECIAL_OFFERS && this.m_CategoryHighlightState == IngameShopOffer.HIGHLIGHT_STATE_SALE;
      }
      
      public function get name() : String
      {
         return this.m_Name;
      }
      
      public function set offers(param1:Vector.<IngameShopOffer>) : void
      {
         this.m_Offers = param1;
         var _loc2_:IngameShopEvent = new IngameShopEvent(IngameShopEvent.CATEGORY_OFFERS_CHANGED);
         _loc2_.data = this;
         dispatchEvent(_loc2_);
      }
      
      public function hasNewOffer() : Boolean
      {
         return this.m_Name != IngameShopCategory.CATEGORY_NEW_PRODUCTS && this.m_CategoryHighlightState == IngameShopOffer.HIGHLIGHT_STATE_NEW;
      }
      
      public function get offers() : Vector.<IngameShopOffer>
      {
         return this.m_Offers;
      }
      
      public function get iconIdentifiers() : Vector.<String>
      {
         return this.m_IconIdentifiers;
      }
      
      public function get description() : String
      {
         return this.m_Description;
      }
   }
}
