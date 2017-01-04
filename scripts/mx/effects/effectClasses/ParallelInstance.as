package mx.effects.effectClasses
{
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import mx.core.UIComponent;
   import mx.core.mx_internal;
   import mx.effects.EffectInstance;
   import mx.effects.IEffectInstance;
   
   use namespace mx_internal;
   
   public class ParallelInstance extends CompositeEffectInstance
   {
      
      mx_internal static const VERSION:String = "3.6.0.21751";
       
      
      private var timer:Timer;
      
      private var isReversed:Boolean = false;
      
      private var replayEffectQueue:Array;
      
      private var doneEffectQueue:Array;
      
      public function ParallelInstance(param1:Object)
      {
         super(param1);
      }
      
      override public function stop() : void
      {
         var _loc1_:Array = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         stopTimer();
         if(activeEffectQueue)
         {
            _loc1_ = activeEffectQueue.concat();
            activeEffectQueue = null;
            _loc2_ = _loc1_.length;
            _loc3_ = 0;
            while(_loc3_ < _loc2_)
            {
               if(_loc1_[_loc3_])
               {
                  _loc1_[_loc3_].stop();
               }
               _loc3_++;
            }
         }
         super.stop();
      }
      
      private function startTimer() : void
      {
         if(!timer)
         {
            timer = new Timer(10);
            timer.addEventListener(TimerEvent.TIMER,timerHandler);
         }
         timer.start();
      }
      
      override mx_internal function get durationWithoutRepeat() : Number
      {
         var _loc4_:Array = null;
         var _loc1_:Number = 0;
         var _loc2_:int = childSets.length;
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = childSets[_loc3_];
            _loc1_ = Math.max(_loc4_[0].actualDuration,_loc1_);
            _loc3_++;
         }
         return _loc1_;
      }
      
      private function timerHandler(param1:TimerEvent) : void
      {
         var _loc5_:EffectInstance = null;
         var _loc2_:Number = durationWithoutRepeat - playheadTime;
         var _loc3_:int = replayEffectQueue.length;
         if(_loc3_ == 0)
         {
            stopTimer();
            return;
         }
         var _loc4_:int = _loc3_ - 1;
         while(_loc4_ >= 0)
         {
            _loc5_ = replayEffectQueue[_loc4_];
            if(_loc2_ <= _loc5_.actualDuration)
            {
               activeEffectQueue.push(_loc5_);
               replayEffectQueue.splice(_loc4_,1);
               _loc5_.playReversed = playReversed;
               _loc5_.startEffect();
            }
            _loc4_--;
         }
      }
      
      private function stopTimer() : void
      {
         if(timer)
         {
            timer.reset();
         }
      }
      
      override public function addChildSet(param1:Array) : void
      {
         var _loc2_:CompositeEffectInstance = null;
         super.addChildSet(param1);
         if(param1.length > 0)
         {
            _loc2_ = param1[0] as CompositeEffectInstance;
            if(param1[0] is RotateInstance || _loc2_ != null && _loc2_.hasRotateInstance())
            {
               childSets.pop();
               childSets.unshift(param1);
            }
         }
      }
      
      override public function reverse() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         super.reverse();
         if(isReversed)
         {
            _loc1_ = activeEffectQueue.length;
            _loc2_ = 0;
            while(_loc2_ < _loc1_)
            {
               activeEffectQueue[_loc2_].reverse();
               _loc2_++;
            }
            stopTimer();
         }
         else
         {
            replayEffectQueue = doneEffectQueue.splice(0);
            _loc1_ = activeEffectQueue.length;
            _loc2_ = 0;
            while(_loc2_ < _loc1_)
            {
               activeEffectQueue[_loc2_].reverse();
               _loc2_++;
            }
            startTimer();
         }
         isReversed = !isReversed;
      }
      
      override public function end() : void
      {
         var _loc1_:Array = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         endEffectCalled = true;
         stopTimer();
         if(activeEffectQueue)
         {
            _loc1_ = activeEffectQueue.concat();
            activeEffectQueue = null;
            _loc2_ = _loc1_.length;
            _loc3_ = 0;
            while(_loc3_ < _loc2_)
            {
               if(_loc1_[_loc3_])
               {
                  _loc1_[_loc3_].end();
               }
               _loc3_++;
            }
         }
         super.end();
      }
      
      override protected function onEffectEnd(param1:IEffectInstance) : void
      {
         if(Object(param1).suspendBackgroundProcessing)
         {
            UIComponent.resumeBackgroundProcessing();
         }
         if(endEffectCalled || activeEffectQueue == null)
         {
            return;
         }
         var _loc2_:int = activeEffectQueue.length;
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            if(param1 == activeEffectQueue[_loc3_])
            {
               doneEffectQueue.push(param1);
               activeEffectQueue.splice(_loc3_,1);
               break;
            }
            _loc3_++;
         }
         if(_loc2_ == 1)
         {
            finishRepeat();
         }
      }
      
      override public function resume() : void
      {
         super.resume();
         var _loc1_:int = activeEffectQueue.length;
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            activeEffectQueue[_loc2_].resume();
            _loc2_++;
         }
      }
      
      override public function play() : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Array = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:EffectInstance = null;
         var _loc8_:Array = null;
         doneEffectQueue = [];
         activeEffectQueue = [];
         replayEffectQueue = [];
         var _loc1_:Boolean = false;
         super.play();
         _loc2_ = childSets.length;
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = childSets[_loc3_];
            _loc5_ = _loc4_.length;
            _loc6_ = 0;
            while(_loc6_ < _loc5_ && activeEffectQueue != null)
            {
               _loc7_ = _loc4_[_loc6_];
               if(playReversed && _loc7_.actualDuration < durationWithoutRepeat)
               {
                  replayEffectQueue.push(_loc7_);
                  startTimer();
               }
               else
               {
                  _loc7_.playReversed = playReversed;
                  activeEffectQueue.push(_loc7_);
               }
               if(_loc7_.suspendBackgroundProcessing)
               {
                  UIComponent.suspendBackgroundProcessing();
               }
               _loc6_++;
            }
            _loc3_++;
         }
         if(activeEffectQueue.length > 0)
         {
            _loc8_ = activeEffectQueue.slice(0);
            _loc3_ = 0;
            while(_loc3_ < _loc8_.length)
            {
               _loc8_[_loc3_].startEffect();
               _loc3_++;
            }
         }
      }
      
      override public function pause() : void
      {
         super.pause();
         var _loc1_:int = activeEffectQueue.length;
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            activeEffectQueue[_loc2_].pause();
            _loc2_++;
         }
      }
   }
}
