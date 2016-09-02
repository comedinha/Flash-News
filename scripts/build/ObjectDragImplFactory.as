package build
{
   import tibia.game.ObjectDragImpl;
   
   public class ObjectDragImplFactory
   {
       
      
      public function ObjectDragImplFactory()
      {
         super();
         throw new Error("ObjectDragImplFactory must not be instantiated");
      }
      
      public static function s_CreateObjectDragImpl() : ObjectDragImpl
      {
         var _loc1_:ObjectDragImpl = null;
         _loc1_ = new ObjectDragImpl();
         return _loc1_;
      }
   }
}
