package mx.states
{
   import mx.core.mx_internal;
   import mx.effects.IEffect;
   
   use namespace mx_internal;
   
   public class Transition
   {
      
      mx_internal static const VERSION:String = "3.6.0.21751";
       
      
      public var effect:IEffect;
      
      public var toState:String = "*";
      
      public var fromState:String = "*";
      
      public function Transition()
      {
         super();
      }
   }
}
