package mx.effects
{
   import mx.core.mx_internal;
   import mx.effects.effectClasses.SequenceInstance;
   
   use namespace mx_internal;
   
   public class Sequence extends CompositeEffect
   {
      
      mx_internal static const VERSION:String = "3.6.0.21751";
       
      
      public function Sequence(param1:Object = null)
      {
         super(param1);
         instanceClass = SequenceInstance;
      }
      
      override protected function initInstance(param1:IEffectInstance) : void
      {
         super.initInstance(param1);
      }
   }
}
