package build
{
   import tibia.appearances.AppearanceStorage;
   
   public class ApperanceStorageFactory
   {
       
      
      public function ApperanceStorageFactory()
      {
         super();
         throw new Error("ApperanceStorageFactory must not be instantiated");
      }
      
      public static function s_CreateAppearanceStorage() : AppearanceStorage
      {
         var _loc1_:AppearanceStorage = null;
         _loc1_ = new AppearanceStorage();
         return _loc1_;
      }
   }
}
