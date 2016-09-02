package mx.controls.listClasses
{
   import mx.core.mx_internal;
   import mx.collections.CursorBookmark;
   
   use namespace mx_internal;
   
   public class ListBaseFindPending
   {
      
      mx_internal static const VERSION:String = "3.6.0.21751";
       
      
      public var currentIndex:int;
      
      public var stopIndex:int;
      
      public var startingBookmark:CursorBookmark;
      
      public var searchString:String;
      
      public var offset:int;
      
      public var bookmark:CursorBookmark;
      
      public function ListBaseFindPending(param1:String, param2:CursorBookmark, param3:CursorBookmark, param4:int, param5:int, param6:int)
      {
         super();
         this.searchString = param1;
         this.startingBookmark = param2;
         this.bookmark = param3;
         this.offset = param4;
         this.currentIndex = param5;
         this.stopIndex = param6;
      }
   }
}
