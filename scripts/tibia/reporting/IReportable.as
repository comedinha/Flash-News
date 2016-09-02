package tibia.reporting
{
   public interface IReportable
   {
       
      
      function isReportTypeAllowed(param1:uint) : Boolean;
      
      function get ID() : int;
      
      function get characterName() : String;
      
      function setReportTypeAllowed(param1:uint, param2:Boolean = true) : void;
   }
}
