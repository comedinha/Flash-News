package tibia.sessiondump
{
   import tibia.network.IConnectionData;
   
   public class SessiondumpConnectionData implements IConnectionData
   {
       
      
      private var m_Id:uint = 0;
      
      private var m_DurationMilliseconds:uint = 0;
      
      private var m_Url:String = null;
      
      public function SessiondumpConnectionData(param1:uint, param2:String, param3:uint)
      {
         super();
         this.m_Id = param1;
         this.m_Url = param2;
         this.m_DurationMilliseconds = param3;
      }
      
      public function get durationMilliseconds() : uint
      {
         return this.m_DurationMilliseconds;
      }
      
      public function get id() : uint
      {
         return this.m_Id;
      }
      
      public function get url() : String
      {
         return this.m_Url;
      }
   }
}
