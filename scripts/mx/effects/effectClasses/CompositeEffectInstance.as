package mx.effects.effectClasses
{
   import flash.events.Event;
   import mx.core.mx_internal;
   import mx.effects.EffectInstance;
   import mx.effects.IEffectInstance;
   import mx.effects.Tween;
   import mx.events.EffectEvent;
   
   use namespace mx_internal;
   
   public class CompositeEffectInstance extends EffectInstance
   {
      
      mx_internal static const VERSION:String = "3.6.0.21751";
       
      
      mx_internal var childSets:Array;
      
      mx_internal var activeEffectQueue:Array;
      
      private var _playheadTime:Number = 0;
      
      mx_internal var timerTween:Tween;
      
      mx_internal var endEffectCalled:Boolean;
      
      public function CompositeEffectInstance(param1:Object)
      {
         activeEffectQueue = [];
         childSets = [];
         super(param1);
      }
      
      override public function get playheadTime() : Number
      {
         return _playheadTime + super.playheadTime;
      }
      
      override mx_internal function get actualDuration() : Number
      {
         var _loc1_:Number = NaN;
         if(repeatCount > 0)
         {
            _loc1_ = durationWithoutRepeat * repeatCount + (repeatDelay * repeatCount - 1) + startDelay;
         }
         return _loc1_;
      }
      
      override public function play() : void
      {
         timerTween = new Tween(this,0,0,durationWithoutRepeat);
         super.play();
      }
      
      override public function finishEffect() : void
      {
         activeEffectQueue = null;
         super.finishEffect();
      }
      
      mx_internal function hasRotateInstance() : Boolean
      {
         var _loc1_:int = 0;
         var _loc2_:CompositeEffectInstance = null;
         if(childSets)
         {
            _loc1_ = 0;
            while(_loc1_ < childSets.length)
            {
               if(childSets[_loc1_].length > 0)
               {
                  _loc2_ = childSets[_loc1_][0] as CompositeEffectInstance;
                  if(childSets[_loc1_][0] is RotateInstance || _loc2_ && _loc2_.hasRotateInstance())
                  {
                     return true;
                  }
               }
               _loc1_++;
            }
         }
         return false;
      }
      
      mx_internal function get durationWithoutRepeat() : Number
      {
         return 0;
      }
      
      override public function initEffect(param1:Event) : void
      {
         var _loc4_:Array = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         super.initEffect(param1);
         var _loc2_:int = childSets.length;
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = childSets[_loc3_];
            _loc5_ = _loc4_.length;
            _loc6_ = 0;
            while(_loc6_ < _loc5_)
            {
               _loc4_[_loc6_].initEffect(param1);
               _loc6_++;
            }
            _loc3_++;
         }
      }
      
      override public function stop() : void
      {
         super.stop();
         if(timerTween)
         {
            timerTween.stop();
         }
      }
      
      override public function reverse() : void
      {
         super.reverse();
         super.playReversed = !playReversed;
         if(timerTween)
         {
            timerTween.reverse();
         }
      }
      
      public function addChildSet(param1:Array) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(param1)
         {
            _loc2_ = param1.length;
            if(_loc2_ > 0)
            {
               if(!childSets)
               {
                  childSets = [param1];
               }
               else
               {
                  childSets.push(param1);
               }
               _loc3_ = 0;
               while(_loc3_ < _loc2_)
               {
                  param1[_loc3_].addEventListener(EffectEvent.EFFECT_END,effectEndHandler);
                  param1[_loc3_].parentCompositeEffectInstance = this;
                  _loc3_++;
               }
            }
         }
      }
      
      protected function onEffectEnd(param1:IEffectInstance) : void
      {
      }
      
      override mx_internal function playWithNoDuration() : void
      {
         super.playWithNoDuration();
         end();
      }
      
      public function onTweenUpdate(param1:Object) : void
      {
         _playheadTime = !!timerTween?Number(timerTween.playheadTime):Number(_playheadTime);
      }
      
      override public function pause() : void
      {
         super.pause();
         if(timerTween)
         {
            timerTween.pause();
         }
      }
      
      mx_internal function effectEndHandler(param1:EffectEvent) : void
      {
         onEffectEnd(param1.effectInstance);
      }
      
      override public function resume() : void
      {
         super.resume();
         if(timerTween)
         {
            timerTween.resume();
         }
      }
      
      public function onTweenEnd(param1:Object) : void
      {
         _playheadTime = !!timerTween?Number(timerTween.playheadTime):Number(_playheadTime);
      }
   }
}
