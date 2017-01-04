package mx.controls.menuClasses
{
   import mx.controls.listClasses.ListData;
   import mx.core.IUIComponent;
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   public class MenuListData extends ListData
   {
      
      mx_internal static const VERSION:String = "3.6.0.21751";
       
      
      public var maxMeasuredBranchIconWidth:Number;
      
      public var maxMeasuredIconWidth:Number;
      
      public var useTwoColumns:Boolean;
      
      public var maxMeasuredTypeIconWidth:Number;
      
      public function MenuListData(param1:String, param2:Class, param3:String, param4:String, param5:IUIComponent, param6:int = 0, param7:int = 0)
      {
         super(param1,param2,param3,param4,param5,param6,param7);
      }
   }
}
