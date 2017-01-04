package mx.controls.treeClasses
{
   import mx.controls.listClasses.BaseListData;
   import mx.controls.listClasses.ListBase;
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   public class TreeListData extends BaseListData
   {
      
      mx_internal static const VERSION:String = "3.6.0.21751";
       
      
      public var hasChildren:Boolean;
      
      public var depth:int;
      
      public var disclosureIcon:Class;
      
      public var open:Boolean;
      
      public var indent:int;
      
      public var item:Object;
      
      public var icon:Class;
      
      public function TreeListData(param1:String, param2:String, param3:ListBase, param4:int = 0, param5:int = 0)
      {
         super(param1,param2,param3,param4,param5);
      }
   }
}
