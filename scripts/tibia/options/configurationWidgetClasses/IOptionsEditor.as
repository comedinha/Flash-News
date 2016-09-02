package tibia.options.configurationWidgetClasses
{
   import mx.core.IUIComponent;
   import mx.styles.ISimpleStyleClient;
   import tibia.options.OptionsStorage;
   
   public interface IOptionsEditor extends IUIComponent, ISimpleStyleClient
   {
       
      
      function get creationPolicy() : String;
      
      function set creationPolicy(param1:String) : void;
      
      function close(param1:Boolean = false) : void;
      
      function set options(param1:OptionsStorage) : void;
      
      function get options() : OptionsStorage;
   }
}
