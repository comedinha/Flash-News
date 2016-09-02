package tibia.appearances
{
   public class FrameDuration
   {
       
      
      private var m_MinimumDuration:uint = 0;
      
      private var m_MaximumDuration:uint = 0;
      
      public function FrameDuration(param1:uint, param2:uint)
      {
         super();
         if(param1 <= param2)
         {
            this.m_MinimumDuration = param1;
            this.m_MaximumDuration = param2;
            return;
         }
         throw new ArgumentError("FrameDuration: MinimumDuration > MaximumDuration");
      }
      
      public function get minimumDuration() : uint
      {
         return this.m_MinimumDuration;
      }
      
      public function get maximumDuration() : uint
      {
         return this.m_MaximumDuration;
      }
      
      public function get duration() : uint
      {
         var _loc1_:uint = 0;
         if(this.m_MinimumDuration == this.m_MaximumDuration)
         {
            return this.m_MinimumDuration;
         }
         _loc1_ = this.m_MaximumDuration - this.m_MinimumDuration;
         return this.m_MinimumDuration + Math.round(Math.random() * _loc1_);
      }
   }
}
