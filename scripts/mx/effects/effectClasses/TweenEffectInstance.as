package mx.effects.effectClasses
{
   import mx.effects.EffectInstance;
   import mx.core.mx_internal;
   import mx.effects.Tween;
   import mx.events.TweenEvent;
   import mx.core.UIComponentGlobals;
   
   use namespace mx_internal;
   
   public class TweenEffectInstance extends EffectInstance
   {
      
      mx_internal static const VERSION:String = "3.6.0.21751";
       
      
      private var _seekTime:Number = 0;
      
      public var easingFunction:Function;
      
      public var tween:Tween;
      
      mx_internal var needToLayout:Boolean = false;
      
      public function TweenEffectInstance(param1:Object)
      {
         super(param1);
      }
      
      override public function stop() : void
      {
         super.stop();
         if(tween)
         {
            tween.stop();
         }
      }
      
      mx_internal function applyTweenStartValues() : void
      {
         if(duration > 0)
         {
            onTweenUpdate(tween.getCurrentValue(0));
         }
      }
      
      override public function get playheadTime() : Number
      {
         if(tween)
         {
            return tween.playheadTime + super.playheadTime;
         }
         return 0;
      }
      
      protected function createTween(param1:Object, param2:Object, param3:Object, param4:Number = -1, param5:Number = -1) : Tween
      {
         var _loc6_:Tween = new Tween(param1,param2,param3,param4,param5);
         _loc6_.addEventListener(TweenEvent.TWEEN_START,tweenEventHandler);
         _loc6_.addEventListener(TweenEvent.TWEEN_UPDATE,tweenEventHandler);
         _loc6_.addEventListener(TweenEvent.TWEEN_END,tweenEventHandler);
         if(easingFunction != null)
         {
            _loc6_.easingFunction = easingFunction;
         }
         if(_seekTime > 0)
         {
            _loc6_.seek(_seekTime);
         }
         _loc6_.playReversed = playReversed;
         return _loc6_;
      }
      
      private function tweenEventHandler(param1:TweenEvent) : void
      {
         dispatchEvent(param1);
      }
      
      override public function end() : void
      {
         stopRepeat = true;
         if(delayTimer)
         {
            delayTimer.reset();
         }
         if(tween)
         {
            tween.endTween();
            tween = null;
         }
      }
      
      override public function reverse() : void
      {
         super.reverse();
         if(tween)
         {
            tween.reverse();
         }
         super.playReversed = !playReversed;
      }
      
      override mx_internal function set playReversed(param1:Boolean) : void
      {
         super.playReversed = param1;
         if(tween)
         {
            tween.playReversed = param1;
         }
      }
      
      override public function resume() : void
      {
         super.resume();
         if(tween)
         {
            tween.resume();
         }
      }
      
      public function onTweenEnd(param1:Object) : void
      {
         onTweenUpdate(param1);
         tween = null;
         if(needToLayout)
         {
            UIComponentGlobals.layoutManager.validateNow();
         }
         finishRepeat();
      }
      
      public function onTweenUpdate(param1:Object) : void
      {
      }
      
      override public function pause() : void
      {
         super.pause();
         if(tween)
         {
            tween.pause();
         }
      }
      
      public function seek(param1:Number) : void
      {
         if(tween)
         {
            tween.seek(param1);
         }
         else
         {
            _seekTime = param1;
         }
      }
   }
}
