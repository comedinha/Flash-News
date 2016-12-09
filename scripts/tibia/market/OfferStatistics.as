package tibia.market
{
   public class OfferStatistics
   {
      
      public static const SECONDS_PER_DAY:int = 24 * 60 * 60;
       
      
      private var m_Timestamp:uint = 0;
      
      private var m_Kind:int;
      
      private var m_TotalTransactions:uint = 0;
      
      private var m_MinimumPrice:uint = 0;
      
      private var m_TotalPrice:uint = 0;
      
      private var m_MaximumPrice:uint = 0;
      
      public function OfferStatistics(param1:uint, param2:int, param3:uint, param4:uint, param5:uint, param6:uint)
      {
         this.m_Kind = Offer.BUY_OFFER;
         super();
         this.m_Timestamp = Math.floor(param1 / SECONDS_PER_DAY) * SECONDS_PER_DAY;
         if(param2 != Offer.BUY_OFFER && param2 != Offer.SELL_OFFER)
         {
            throw new ArgumentError("OfferStatistics.OfferStatistics: Invalid offer kind " + param2 + ".");
         }
         this.m_Kind = param2;
         this.m_TotalTransactions = param3;
         this.m_TotalPrice = param4;
         this.m_MaximumPrice = param5;
         this.m_MinimumPrice = param6;
      }
      
      public function get minimumPrice() : uint
      {
         return this.m_MinimumPrice;
      }
      
      public function get totalPrice() : uint
      {
         return this.m_TotalPrice;
      }
      
      public function get maximumPrice() : uint
      {
         return this.m_MaximumPrice;
      }
      
      public function get kind() : int
      {
         return this.m_Kind;
      }
      
      public function get totalTransactions() : uint
      {
         return this.m_TotalTransactions;
      }
      
      public function get timestamp() : uint
      {
         return this.m_Timestamp;
      }
   }
}
