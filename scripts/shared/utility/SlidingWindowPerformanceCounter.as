package shared.utility
{
   import flash.utils.getTimer;
   
   public class SlidingWindowPerformanceCounter implements IPerformanceCounter
   {
       
      
      private var m_PauseDuration:uint = 0;
      
      private var m_Total:Number = 0.0;
      
      private var m_Length:uint = 0;
      
      private var m_Position:uint = 0;
      
      private var m_Data:Vector.<Number> = null;
      
      private var m_Min:Number = Infinity;
      
      private var m_Max:Number = -Infinity;
      
      private var m_PauseStart:Number = NaN;
      
      private var m_Start:Number = NaN;
      
      public function SlidingWindowPerformanceCounter(param1:int)
      {
         super();
         if(param1 <= 0)
         {
            throw new ArgumentError("SlidingWindowPerformanceCounter.SlidingWindowPerformanceCounter: Invalid window size.");
         }
         this.m_Data = new Vector.<Number>(param1,true);
      }
      
      public function stop() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:Number = NaN;
         if(!isNaN(this.m_Start))
         {
            _loc1_ = this.m_Data.length;
            this.resume();
            _loc2_ = getTimer() - this.m_Start - this.m_PauseDuration;
            this.m_Total = this.m_Total - this.m_Data[this.m_Position] + _loc2_;
            this.m_Data[this.m_Position] = _loc2_;
            this.m_Position = (this.m_Position + 1) % _loc1_;
            this.m_Length++;
            this.m_Max = NaN;
            this.m_Min = NaN;
            this.m_Start = NaN;
            this.m_PauseStart = NaN;
         }
      }
      
      public function get total() : Number
      {
         return this.m_Total;
      }
      
      public function get minimum() : Number
      {
         var _loc1_:int = 0;
         if(isNaN(this.m_Min))
         {
            this.m_Min = Number.POSITIVE_INFINITY;
            _loc1_ = Math.min(this.m_Length,this.m_Data.length) - 1;
            while(_loc1_ >= 0)
            {
               if(this.m_Data[_loc1_] < this.m_Min)
               {
                  this.m_Min = this.m_Data[_loc1_];
               }
               _loc1_--;
            }
         }
         return this.m_Min;
      }
      
      public function reset() : void
      {
         var _loc1_:int = Math.min(this.m_Length,this.m_Data.length) - 1;
         while(_loc1_ >= 0)
         {
            this.m_Data[_loc1_] = 0;
            _loc1_--;
         }
         this.m_Length = 0;
         this.m_Max = Number.NEGATIVE_INFINITY;
         this.m_Min = Number.POSITIVE_INFINITY;
         this.m_Position = 0;
         this.m_Start = NaN;
         this.m_Total = 0;
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
      
      public function get maximum() : Number
      {
         var _loc1_:int = 0;
         if(isNaN(this.m_Max))
         {
            this.m_Max = Number.NEGATIVE_INFINITY;
            _loc1_ = Math.min(this.m_Length,this.m_Data.length) - 1;
            while(_loc1_ >= 0)
            {
               if(this.m_Data[_loc1_] > this.m_Max)
               {
                  this.m_Max = this.m_Data[_loc1_];
               }
               _loc1_--;
            }
         }
         return this.m_Max;
      }
      
      public function get average() : Number
      {
         if(this.m_Length > 0)
         {
            return this.m_Total / Math.min(this.m_Length,this.m_Data.length);
         }
         return 0;
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
      
      public function toString() : String
      {
         return this.m_Length + "/" + this.m_Total + "/" + this.minimum.toFixed(2) + "/" + this.average.toFixed(2) + "/" + this.maximum.toFixed(2);
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
