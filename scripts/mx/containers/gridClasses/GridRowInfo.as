package mx.containers.gridClasses
{
   import mx.core.mx_internal;
   import mx.core.UIComponent;
   
   use namespace mx_internal;
   
   public class GridRowInfo
   {
      
      mx_internal static const VERSION:String = "3.6.0.21751";
       
      
      public var y:Number;
      
      public var preferred:Number;
      
      public var max:Number;
      
      public var height:Number;
      
      public var flex:Number;
      
      public var min:Number;
      
      public function GridRowInfo()
      {
         super();
         min = 0;
         preferred = 0;
         max = UIComponent.DEFAULT_MAX_HEIGHT;
         flex = 0;
      }
   }
}
