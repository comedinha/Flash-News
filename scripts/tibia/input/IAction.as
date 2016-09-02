package tibia.input
{
   public interface IAction extends IActionImpl
   {
       
      
      function get hidden() : Boolean;
      
      function toString() : String;
      
      function clone() : IAction;
      
      function marshall() : XML;
      
      function equals(param1:IAction) : Boolean;
   }
}
