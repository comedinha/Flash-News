package tibia.creatures
{
   public class SkillCounter
   {
      
      private static const NUM_DATA_POINTS:int = 15;
       
      
      protected var m_DataPoints:Vector.<Number>;
      
      protected var m_DataTimestamps:Vector.<uint>;
      
      public function SkillCounter()
      {
         this.m_DataPoints = new Vector.<Number>(NUM_DATA_POINTS,true);
         this.m_DataTimestamps = new Vector.<uint>(NUM_DATA_POINTS,true);
         super();
         this.reset();
      }
      
      public function addSkillGain(param1:Number) : void
      {
         if(param1 < 0 || isNaN(param1))
         {
            throw new ArgumentError("SkillCounter.addSkillGain: Gain is negative.");
         }
         var _loc2_:uint = uint(Tibia.s_GetTibiaTimer() / 60000);
         var _loc3_:int = _loc2_ % NUM_DATA_POINTS;
         if(this.m_DataTimestamps[_loc3_] != _loc2_)
         {
            this.m_DataTimestamps[_loc3_] = _loc2_;
            this.m_DataPoints[_loc3_] = param1;
         }
         else
         {
            this.m_DataPoints[_loc3_] = this.m_DataPoints[_loc3_] + param1;
         }
      }
      
      public function getAverageGain() : Number
      {
         var _loc1_:Number = 0;
         var _loc2_:uint = uint(Tibia.s_GetTibiaTimer() / 60000);
         var _loc3_:int = NUM_DATA_POINTS - 1;
         while(_loc3_ >= 0)
         {
            if(this.m_DataTimestamps[_loc3_] + NUM_DATA_POINTS >= _loc2_)
            {
               _loc1_ = _loc1_ + this.m_DataPoints[_loc3_];
            }
            _loc3_--;
         }
         return _loc1_ * 60 / NUM_DATA_POINTS;
      }
      
      public function reset() : void
      {
         var _loc1_:int = 0;
         _loc1_ = 0;
         while(_loc1_ < NUM_DATA_POINTS)
         {
            this.m_DataPoints[_loc1_] = 0;
            this.m_DataTimestamps[_loc1_] = 0;
            _loc1_++;
         }
      }
   }
}
