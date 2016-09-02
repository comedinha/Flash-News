package mx.managers
{
   import flash.events.IEventDispatcher;
   import flash.display.DisplayObject;
   
   public interface IFocusManagerContainer extends IEventDispatcher
   {
       
      
      function set focusManager(param1:IFocusManager) : void;
      
      function get focusManager() : IFocusManager;
      
      function get systemManager() : ISystemManager;
      
      function contains(param1:DisplayObject) : Boolean;
   }
}
