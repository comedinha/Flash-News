package mx.effects
{
   import mx.core.mx_internal;
   import mx.effects.effectClasses.PauseInstance;
   
   use namespace mx_internal;
   
   public class Pause extends TweenEffect
   {
      
      mx_internal static const VERSION:String = "3.6.0.21751";
       
      
      public function Pause(param1:Object = null)
      {
         super(param1);
         instanceClass = PauseInstance;
      }
      
      override public function createInstances(param1:Array = null) : Array
      {
         var _loc2_:IEffectInstance = createInstance();
         return !!_loc2_?[_loc2_]:[];
      }
   }
}
