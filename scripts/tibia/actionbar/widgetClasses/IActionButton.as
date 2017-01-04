package tibia.actionbar.widgetClasses
{
   import mx.core.IFlexDisplayObject;
   import mx.core.IInvalidating;
   import mx.core.IUIComponent;
   import mx.managers.IToolTipManagerClient;
   import tibia.input.IAction;
   
   public interface IActionButton extends IFlexDisplayObject, IUIComponent, IToolTipManagerClient, IInvalidating
   {
       
      
      function get position() : int;
      
      function set position(param1:int) : void;
      
      function set action(param1:IAction) : void;
      
      function get action() : IAction;
   }
}
