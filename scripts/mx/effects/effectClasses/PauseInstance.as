package mx.effects.effectClasses
{
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   public class PauseInstance extends TweenEffectInstance
   {
      
      mx_internal static const VERSION:String = "3.6.0.21751";
       
      
      public function PauseInstance(param1:Object)
      {
         super(param1);
      }
      
      override public function play() : void
      {
         super.play();
         tween = createTween(this,0,0,duration);
      }
   }
}
