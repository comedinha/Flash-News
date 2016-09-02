package tibia.appearances
{
   class AppearanceTypeInfo extends AppearanceTypeRef
   {
       
      
      public var name:String = null;
      
      function AppearanceTypeInfo(param1:int, param2:int, param3:String)
      {
         super(param1,param2);
         if(param3 == null || param3.length < 1)
         {
            throw new ArgumentError("AppearanceTypeInfo.AppearanceTypeInfo: Invalid name.");
         }
         this.name = param3;
      }
   }
}
