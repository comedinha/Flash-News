package mx.controls.listClasses
{
   import mx.core.mx_internal;
   import mx.collections.CursorBookmark;
   
   use namespace mx_internal;
   
   public class ListBaseSeekPending
   {
      
      mx_internal static const VERSION:String = "3.6.0.21751";
       
      
      public var offset:int;
      
      public var bookmark:CursorBookmark;
      
      public function ListBaseSeekPending(param1:CursorBookmark, param2:int)
      {
         super();
         this.bookmark = param1;
         this.offset = param2;
      }
   }
}
