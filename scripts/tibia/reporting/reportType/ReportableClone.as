package tibia.reporting.reportType
{
   import tibia.reporting.IReportable;
   
   public class ReportableClone implements IReportable
   {
       
      
      private var m_CharacterName:String = null;
      
      private var m_ReportTypeAllowed:Object;
      
      private var m_ID:int = 0;
      
      public function ReportableClone(param1:int, param2:String)
      {
         this.m_ReportTypeAllowed = {};
         super();
         this.m_CharacterName = param2;
         this.m_ID = param1;
      }
      
      public static function s_CloneReportable(param1:IReportable) : IReportable
      {
         var _loc2_:IReportable = new ReportableClone(param1.ID,param1.characterName);
         _loc2_.setReportTypeAllowed(Type.REPORT_BOT,param1.isReportTypeAllowed(Type.REPORT_BOT));
         _loc2_.setReportTypeAllowed(Type.REPORT_NAME,param1.isReportTypeAllowed(Type.REPORT_NAME));
         _loc2_.setReportTypeAllowed(Type.REPORT_STATEMENT,param1.isReportTypeAllowed(Type.REPORT_STATEMENT));
         return _loc2_;
      }
      
      public function get characterName() : String
      {
         return this.m_CharacterName;
      }
      
      public function isReportTypeAllowed(param1:uint) : Boolean
      {
         if(this.m_ReportTypeAllowed.hasOwnProperty(param1))
         {
            return this.m_ReportTypeAllowed[param1];
         }
         return false;
      }
      
      public function setReportTypeAllowed(param1:uint, param2:Boolean = true) : void
      {
         this.m_ReportTypeAllowed[param1] = param2;
      }
      
      public function get ID() : int
      {
         return this.m_ID;
      }
   }
}
