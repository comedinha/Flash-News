package tibia.chat
{
   import shared.utility.StringHelper;
   
   public class NameFilterItem
   {
       
      
      private var m_Pattern:String = null;
      
      public var permanent:Boolean = false;
      
      protected var m_Undefined:Boolean = true;
      
      public function NameFilterItem(param1:String, param2:Boolean)
      {
         super();
         this.pattern = param1;
         this.permanent = param2;
      }
      
      public function get pattern() : String
      {
         return this.m_Pattern;
      }
      
      public function clone() : NameFilterItem
      {
         return new NameFilterItem(this.pattern,this.permanent);
      }
      
      public function set pattern(param1:String) : void
      {
         if(param1 != null)
         {
            param1 = StringHelper.s_Trim(param1);
         }
         if(param1 != null && param1.length > 0)
         {
            this.m_Pattern = param1;
         }
         else
         {
            this.m_Pattern = null;
         }
      }
   }
}
