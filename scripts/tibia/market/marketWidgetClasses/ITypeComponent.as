package tibia.market.marketWidgetClasses
{
   import tibia.appearances.AppearanceType;
   
   public interface ITypeComponent
   {
       
      
      function set selectedType(param1:*) : void;
      
      function get selectedType() : AppearanceType;
   }
}
