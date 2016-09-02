package shared.utility
{
   public class AccumulatingCounter
   {
       
      
      private var m_Min:Number = Infinity;
      
      private var m_Max:Number = -Infinity;
      
      private var m_Length:uint = 0;
      
      private var m_Total:Number = 0;
      
      public function AccumulatingCounter()
      {
         super();
      }
      
      public function get length() : uint
      {
         return this.m_Length;
      }
      
      public function get maximum() : Number
      {
         return this.m_Max;
      }
      
      public function update(param1:Number) : void
      {
         if(param1 > this.m_Max)
         {
            this.m_Max = param1;
         }
         if(param1 < this.m_Min && param1 > 0)
         {
            this.m_Min = param1;
         }
         this.m_Length++;
         this.m_Total = this.m_Total + param1;
      }
      
      public function toString() : String
      {
         return this.m_Length + "/" + this.m_Total + "/" + this.minimum.toFixed(2) + "/" + this.average.toFixed(2) + "/" + this.maximum.toFixed(2);
      }
      
      public function get minimum() : Number
      {
         return this.m_Min;
      }
      
      public function get total() : Number
      {
         return this.m_Total;
      }
      
      public function reset() : void
      {
         this.m_Length = 0;
         this.m_Max = Number.NEGATIVE_INFINITY;
         this.m_Min = Number.POSITIVE_INFINITY;
         this.m_Total = 0;
      }
      
      public function get average() : Number
      {
         if(this.m_Length > 0)
         {
            return this.m_Total / this.m_Length;
         }
         return 0;
      }
   }
}
