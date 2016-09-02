package tibia.appearances
{
   public class AppearanceTypeRef
   {
       
      
      private var m_Key:int = 0;
      
      protected var m_Data:int = 0;
      
      protected var m_ID:int = 0;
      
      public function AppearanceTypeRef(param1:int, param2:int)
      {
         super();
         this.m_ID = param1;
         this.m_Data = param2;
         this.m_Key = (this.m_ID & 65535) << 8 | this.m_Data & 255;
      }
      
      public static function s_Compare(param1:AppearanceTypeRef, param2:AppearanceTypeRef) : Number
      {
         if(param1 != null && param2 != null)
         {
            return param1.m_Key - param2.m_Key;
         }
         return -1;
      }
      
      public static function s_Equals(param1:AppearanceTypeRef, param2:AppearanceTypeRef) : Boolean
      {
         return param1 != null && param2 != null && param1.m_Key == param2.m_Key;
      }
      
      public static function s_CompareExternal(param1:AppearanceTypeRef, param2:int, param3:int) : Number
      {
         if(param1 != null)
         {
            return param1.m_Key - ((param2 & 65535) << 8 | param3 & 255);
         }
         return -1;
      }
      
      public static function s_EqualsExternal(param1:AppearanceTypeRef, param2:int, param3:int) : Boolean
      {
         return param1 != null && param1.m_Key == ((param2 & 65535) << 8 | param3 & 255);
      }
      
      public function compare(param1:AppearanceTypeRef) : Number
      {
         return s_Compare(this,param1);
      }
      
      public function clone() : AppearanceTypeRef
      {
         return new AppearanceTypeRef(this.m_ID,this.m_Data);
      }
      
      public function get data() : int
      {
         return this.m_Data;
      }
      
      public function get ID() : int
      {
         return this.m_ID;
      }
      
      public function equals(param1:AppearanceTypeRef) : Boolean
      {
         return s_Equals(this,param1);
      }
   }
}
