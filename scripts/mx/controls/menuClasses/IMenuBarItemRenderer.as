package mx.controls.menuClasses
{
   import mx.controls.MenuBar;
   import mx.controls.listClasses.IListItemRenderer;
   import mx.core.IDataRenderer;
   import mx.core.IUIComponent;
   import mx.styles.ISimpleStyleClient;
   
   public interface IMenuBarItemRenderer extends IDataRenderer, IUIComponent, ISimpleStyleClient, IListItemRenderer
   {
       
      
      function get menuBar() : MenuBar;
      
      function set menuBarItemState(param1:String) : void;
      
      function set menuBarItemIndex(param1:int) : void;
      
      function set menuBar(param1:MenuBar) : void;
      
      function get menuBarItemState() : String;
      
      function get menuBarItemIndex() : int;
   }
}
