package mx.controls
{
   import mx.controls.listClasses.TileBase;
   import mx.core.mx_internal;
   import mx.core.ScrollPolicy;
   import mx.core.ClassFactory;
   import mx.controls.listClasses.TileListItemRenderer;
   
   use namespace mx_internal;
   
   public class TileList extends TileBase
   {
      
      mx_internal static const VERSION:String = "3.6.0.21751";
       
      
      public function TileList()
      {
         super();
         _horizontalScrollPolicy = ScrollPolicy.AUTO;
         itemRenderer = new ClassFactory(TileListItemRenderer);
      }
   }
}
