package tibia.container
{
   import tibia.appearances.AppearanceTypeRef;
   
   public class InventoryTypeInfo extends AppearanceTypeRef
   {
       
      
      public var count:int = 0;
      
      public function InventoryTypeInfo(param1:int, param2:int, param3:int)
      {
         super(param1,param2);
         this.count = param3;
      }
   }
}
