package mx.events
{
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   public final class DataGridEventReason
   {
      
      public static const OTHER:String = "other";
      
      public static const CANCELLED:String = "cancelled";
      
      public static const NEW_COLUMN:String = "newColumn";
      
      mx_internal static const VERSION:String = "3.6.0.21751";
      
      public static const NEW_ROW:String = "newRow";
       
      
      public function DataGridEventReason()
      {
         super();
      }
   }
}
