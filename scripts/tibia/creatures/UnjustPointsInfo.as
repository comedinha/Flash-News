package tibia.creatures
{
   public class UnjustPointsInfo
   {
       
      
      private var m_ProgressMonth:uint;
      
      private var m_KillsRemainingWeek:uint;
      
      private var m_KillsRemainingDay:uint;
      
      private var m_KillsRemainingMonth:uint;
      
      private var m_ProgressWeek:uint;
      
      private var m_ProgressDay:uint;
      
      private var m_SkullDuration:uint;
      
      public function UnjustPointsInfo(param1:uint, param2:uint, param3:uint, param4:uint, param5:uint, param6:uint, param7:uint)
      {
         super();
         this.m_ProgressDay = param1;
         this.m_KillsRemainingDay = param2;
         this.m_ProgressWeek = param3;
         this.m_KillsRemainingWeek = param4;
         this.m_ProgressMonth = param5;
         this.m_KillsRemainingMonth = param6;
         this.m_SkullDuration = param7;
      }
      
      public function get killsRemainingWeek() : uint
      {
         return this.m_KillsRemainingWeek;
      }
      
      public function get progressWeek() : uint
      {
         return this.m_ProgressWeek;
      }
      
      public function equals(param1:UnjustPointsInfo) : Boolean
      {
         return this.m_ProgressDay == param1.progressDay && this.m_ProgressWeek == param1.progressWeek && this.m_ProgressMonth == param1.progressMonth && this.m_KillsRemainingDay == param1.killsRemainingDay && this.m_KillsRemainingWeek == param1.killsRemainingWeek && this.m_KillsRemainingMonth == param1.killsRemainingMonth && this.m_SkullDuration == param1.skullDuration;
      }
      
      public function get progressDay() : uint
      {
         return this.m_ProgressDay;
      }
      
      public function get skullDuration() : uint
      {
         return this.m_SkullDuration;
      }
      
      public function get progressMonth() : uint
      {
         return this.m_ProgressMonth;
      }
      
      public function get killsRemainingMonth() : uint
      {
         return this.m_KillsRemainingMonth;
      }
      
      public function get killsRemainingDay() : uint
      {
         return this.m_KillsRemainingDay;
      }
   }
}
