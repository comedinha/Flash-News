package mx.resources
{
   public interface IResourceBundle
   {
       
      
      function get content() : Object;
      
      function get locale() : String;
      
      function get bundleName() : String;
   }
}
