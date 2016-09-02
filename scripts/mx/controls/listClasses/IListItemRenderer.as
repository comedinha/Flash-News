package mx.controls.listClasses
{
   import mx.core.IDataRenderer;
   import flash.events.IEventDispatcher;
   import mx.core.IFlexDisplayObject;
   import mx.managers.ILayoutManagerClient;
   import mx.styles.ISimpleStyleClient;
   import mx.core.IUIComponent;
   
   public interface IListItemRenderer extends IDataRenderer, IEventDispatcher, IFlexDisplayObject, ILayoutManagerClient, ISimpleStyleClient, IUIComponent
   {
       
   }
}
