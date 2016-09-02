package tibia.premium
{
   import flash.events.Event;
   import tibia.ingameshop.IngameShopProduct;
   
   public class PremiumEvent extends Event
   {
      
      public static const TRIGGER:String = "PREMIUMTRIGGER";
      
      public static const HIGHLIGHT:String = "PREMIUMHIGHLIGHT";
       
      
      protected var m_FeaturedStoreServiceType:int = 0;
      
      protected var m_HighlightExpiry:int = 0;
      
      protected var m_Messages:Vector.<tibia.premium.PremiumMessage> = null;
      
      public function PremiumEvent(param1:String, param2:Boolean = false, param3:Boolean = false, param4:Vector.<tibia.premium.PremiumMessage> = null, param5:int = 0, param6:int = 0)
      {
         super(param1,param2,param3);
         this.m_Messages = param4;
         this.m_FeaturedStoreServiceType = param5;
         this.m_HighlightExpiry = param6;
      }
      
      public function get featuredStoreServiceType() : int
      {
         return this.m_FeaturedStoreServiceType;
      }
      
      override public function clone() : Event
      {
         return new PremiumEvent(type,bubbles,cancelable,this.messages,this.featuredStoreServiceType,this.highlightExpiry);
      }
      
      public function get highlightExpiry() : int
      {
         return this.m_HighlightExpiry;
      }
      
      public function get messages() : Vector.<tibia.premium.PremiumMessage>
      {
         return this.m_Messages;
      }
      
      public function get highlight() : Boolean
      {
         return this.m_FeaturedStoreServiceType != IngameShopProduct.SERVICE_TYPE_UNKNOWN;
      }
      
      public function set featuredStoreServiceType(param1:int) : void
      {
         this.m_FeaturedStoreServiceType = param1;
      }
      
      public function set highlightExpiry(param1:int) : void
      {
         this.m_HighlightExpiry = param1;
      }
      
      public function set messages(param1:Vector.<tibia.premium.PremiumMessage>) : void
      {
         this.m_Messages = param1;
      }
   }
}
