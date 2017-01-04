package mx.skins
{
   import mx.core.EdgeMetrics;
   import mx.core.IBorder;
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   public class Border extends ProgrammaticSkin implements IBorder
   {
      
      mx_internal static const VERSION:String = "3.6.0.21751";
       
      
      public function Border()
      {
         super();
      }
      
      public function get borderMetrics() : EdgeMetrics
      {
         return EdgeMetrics.EMPTY;
      }
   }
}
