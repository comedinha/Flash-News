package tibia.market
{
   public class OfferID
   {
       
      
      private var m_Counter:uint = 0;
      
      private var m_Timestamp:uint = 0;
      
      public function OfferID(param1:uint, param2:uint)
      {
         super();
         this.m_Timestamp = param1;
         this.m_Counter = param2;
      }
      
      public function isLessThan(param1:OfferID) : Boolean
      {
         return this.m_Timestamp < param1.m_Timestamp || this.m_Timestamp == param1.m_Timestamp && this.m_Counter < param1.m_Counter;
      }
      
      public function get timestamp() : uint
      {
         return this.m_Timestamp;
      }
      
      public function isEqual(param1:OfferID) : Boolean
      {
         return this.m_Timestamp == param1.m_Timestamp && this.m_Counter == param1.m_Counter;
      }
      
      public function get counter() : uint
      {
         return this.m_Counter;
      }
   }
}
