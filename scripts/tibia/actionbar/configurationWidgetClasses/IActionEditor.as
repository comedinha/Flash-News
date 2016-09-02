package tibia.actionbar.configurationWidgetClasses
{
   import mx.core.IUIComponent;
   import mx.styles.ISimpleStyleClient;
   import tibia.input.IAction;
   
   public interface IActionEditor extends IUIComponent, ISimpleStyleClient
   {
       
      
      function set action(param1:IAction) : void;
      
      function get action() : IAction;
   }
}
