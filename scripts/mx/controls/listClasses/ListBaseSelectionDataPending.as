package mx.controls.listClasses
{
   import mx.core.mx_internal;
   import mx.collections.CursorBookmark;
   
   use namespace mx_internal;
   
   public class ListBaseSelectionDataPending
   {
      
      mx_internal static const VERSION:String = "3.6.0.21751";
       
      
      public var items:Array;
      
      public var index:int;
      
      public var bookmark:CursorBookmark;
      
      public var offset:int;
      
      public var useFind:Boolean;
      
      public function ListBaseSelectionDataPending(param1:Boolean, param2:int, param3:Array, param4:CursorBookmark, param5:int)
      {
         super();
         this.useFind = param1;
         this.index = param2;
         this.items = param3;
         this.bookmark = param4;
         this.offset = param5;
      }
   }
}
