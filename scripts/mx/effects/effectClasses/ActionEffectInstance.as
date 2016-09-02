package mx.effects.effectClasses
{
   import mx.effects.EffectInstance;
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   public class ActionEffectInstance extends EffectInstance
   {
      
      mx_internal static const VERSION:String = "3.6.0.21751";
       
      
      protected var playedAction:Boolean = false;
      
      private var _startValue;
      
      public function ActionEffectInstance(param1:Object)
      {
         super(param1);
      }
      
      override public function play() : void
      {
         super.play();
         if(!mx_internal::playReversed)
         {
            _startValue = saveStartValue();
         }
         playedAction = true;
      }
      
      protected function getStartValue() : *
      {
         return _startValue;
      }
      
      override public function end() : void
      {
         if(!playedAction)
         {
            play();
         }
         super.end();
      }
      
      protected function saveStartValue() : *
      {
      }
   }
}
