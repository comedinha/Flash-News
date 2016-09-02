package tibia.ingameshop.shopWidgetClasses
{
   import tibia.ingameshop.IngameShopWidget;
   
   public interface IIngameShopWidgetComponent
   {
       
      
      function set shopWidget(param1:IngameShopWidget) : void;
      
      function dispose() : void;
   }
}
