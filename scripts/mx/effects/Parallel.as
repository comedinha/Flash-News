package mx.effects
{
   import mx.core.mx_internal;
   import mx.effects.effectClasses.ParallelInstance;
   
   use namespace mx_internal;
   
   public class Parallel extends CompositeEffect
   {
      
      mx_internal static const VERSION:String = "3.6.0.21751";
       
      
      public function Parallel(param1:Object = null)
      {
         super(param1);
         instanceClass = ParallelInstance;
      }
   }
}
