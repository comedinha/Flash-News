package mx.containers
{
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   public class GridItem extends HBox
   {
      
      mx_internal static const VERSION:String = "3.6.0.21751";
       
      
      var colIndex:int = 0;
      
      private var _rowSpan:int = 1;
      
      private var _colSpan:int = 1;
      
      public function GridItem()
      {
         super();
      }
      
      public function set rowSpan(param1:int) : void
      {
         _rowSpan = param1;
         invalidateSize();
      }
      
      public function get colSpan() : int
      {
         return _colSpan;
      }
      
      public function set colSpan(param1:int) : void
      {
         _colSpan = param1;
         invalidateSize();
      }
      
      public function get rowSpan() : int
      {
         return _rowSpan;
      }
   }
}
