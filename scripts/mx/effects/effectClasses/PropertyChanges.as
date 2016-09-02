package mx.effects.effectClasses
{
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   public class PropertyChanges
   {
      
      mx_internal static const VERSION:String = "3.6.0.21751";
       
      
      public var target:Object;
      
      public var start:Object;
      
      public var end:Object;
      
      public function PropertyChanges(param1:Object)
      {
         end = {};
         start = {};
         super();
         this.target = param1;
      }
   }
}
