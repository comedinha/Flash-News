package tibia.reporting.reportType
{
   import mx.resources.ResourceManager;
   import mx.resources.IResourceManager;
   
   public class Reason
   {
      
      private static const BUNDLE:String = "ReportWidget";
       
      
      private var m_Description:String = null;
      
      private var m_Name:String = null;
      
      private var m_Value:uint = 0;
      
      public function Reason(param1:String, param2:String, param3:uint)
      {
         super();
         var _loc4_:IResourceManager = ResourceManager.getInstance();
         this.m_Name = _loc4_.getString(BUNDLE,param1);
         this.m_Description = _loc4_.getString(BUNDLE,param2);
         this.m_Value = param3;
      }
      
      public function get value() : uint
      {
         return this.m_Value;
      }
      
      public function get name() : String
      {
         return this.m_Name;
      }
      
      public function get description() : String
      {
         return this.m_Description;
      }
   }
}
