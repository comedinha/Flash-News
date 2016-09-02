package tibia.market.marketWidgetClasses
{
   import mx.core.IUIComponent;
   import mx.styles.IStyleClient;
   import tibia.appearances.AppearanceType;
   
   public interface IAppearanceTypeFilterEditor extends IUIComponent, IStyleClient
   {
       
      
      function get filterFunction() : Function;
      
      function invalidateFilterFunction() : void;
      
      function adjustFilterFunction(param1:AppearanceType) : void;
   }
}
