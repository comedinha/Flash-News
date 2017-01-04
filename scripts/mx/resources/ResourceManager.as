package mx.resources
{
   import mx.core.Singleton;
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   public class ResourceManager
   {
      
      private static var implClassDependency:ResourceManagerImpl;
      
      private static var instance:IResourceManager;
      
      mx_internal static const VERSION:String = "3.6.0.21751";
       
      
      public function ResourceManager()
      {
         super();
      }
      
      public static function getInstance() : IResourceManager
      {
         if(!instance)
         {
            try
            {
               instance = IResourceManager(Singleton.getInstance("mx.resources::IResourceManager"));
            }
            catch(e:Error)
            {
               instance = new ResourceManagerImpl();
            }
         }
         return instance;
      }
   }
}
