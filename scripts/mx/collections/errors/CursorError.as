package mx.collections.errors
{
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   public class CursorError extends Error
   {
      
      mx_internal static const VERSION:String = "3.6.0.21751";
       
      
      public function CursorError(param1:String)
      {
         super(param1);
      }
   }
}
