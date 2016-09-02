package shared.utility
{
   import flash.utils.getTimer;
   
   public class AccumulatingPerformanceCounter implements IPerformanceCounter
   {
       
      
      private var m_PauseDuration:uint = 0;
      
      private var m_Total:Number = 0;
      
      private var m_Length:uint = 0;
      
      private var m_Min:Number = Infinity;
      
      private var m_Max:Number = -Infinity;
      
      private var m_PauseStart:Number = NaN;
      
      private var m_Start:Number = NaN;
      
      public function AccumulatingPerformanceCounter()
      {
         super();
      }
      
      public function stop() : void
      {
         var _loc1_:Number = NaN;
         if(!isNaN(this.m_Start))
         {
            this.resume();
            _loc1_ = getTimer() - this.m_Start - this.m_PauseDuration;
            if(_loc1_ > this.m_Max)
            {
               this.m_Max = _loc1_;
            }
            if(_loc1_ < this.m_Min)
            {
               this.m_Min = _loc1_;
            }
            this.m_Length++;
            this.m_Start = NaN;
            this.m_PauseStart = NaN;
            this.m_Total = this.m_Total + _loc1_;
         }
      }
      
      public function get total() : Number
      {
         return this.m_Total;
      }
      
      public function get minimum() : Number
      {
         return this.m_Min;
      }
      
      public function reset() : void
      {
         this.m_Length = 0;
         this.m_Max = Number.NEGATIVE_INFINITY;
         this.m_Min = Number.POSITIVE_INFINITY;
         this.m_Start = NaN;
         this.m_Total = 0;
      }
      
      public function get maximum() : Number
      {
         return this.m_Max;
      }
      
      public function start() : void
      {
         this.m_Start = getTimer();
         this.m_PauseDuration = 0;
         this.m_PauseStart = NaN;
      }
      
      public function get length() : uint
      {
         return this.m_Length;
      }
      
      public function get average() : Number
      {
         if(this.m_Length > 0)
         {
            return this.m_Total / this.m_Length;
         }
         return 0;
      }
      
      public function toString() : String
      {
         return this.m_Length + "/" + this.m_Total + "/" + this.minimum.toFixed(2) + "/" + this.average.toFixed(2) + "/" + this.maximum.toFixed(2);
      }
      
      public function resume() : void
      {
         var _loc1_:Number = NaN;
         if(!isNaN(this.m_PauseStart))
         {
            _loc1_ = getTimer() - this.m_PauseStart;
            this.m_PauseDuration = this.m_PauseDuration + _loc1_;
            this.m_PauseStart = NaN;
         }
      }
      
      public function pause() : void
      {
         if(isNaN(this.m_PauseStart))
         {
            this.m_PauseStart = getTimer();
         }
      }
   }
}
