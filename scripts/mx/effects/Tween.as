package mx.effects
{
   import flash.events.EventDispatcher;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import flash.utils.getTimer;
   import mx.core.UIComponentGlobals;
   import mx.core.mx_internal;
   import mx.events.TweenEvent;
   
   use namespace mx_internal;
   
   public class Tween extends EventDispatcher
   {
      
      private static var timer:Timer = null;
      
      private static var interval:Number = 10;
      
      mx_internal static var activeTweens:Array = [];
      
      mx_internal static var intervalTime:Number = NaN;
      
      mx_internal static const VERSION:String = "3.6.0.21751";
       
      
      private var started:Boolean = false;
      
      private var previousUpdateTime:Number;
      
      public var duration:Number = 3000;
      
      private var id:int;
      
      private var arrayMode:Boolean;
      
      private var _isPlaying:Boolean = true;
      
      private var startValue:Object;
      
      public var listener:Object;
      
      private var userEquation:Function;
      
      mx_internal var needToLayout:Boolean = false;
      
      private var updateFunction:Function;
      
      private var _doSeek:Boolean = false;
      
      mx_internal var startTime:Number;
      
      private var endFunction:Function;
      
      private var endValue:Object;
      
      private var _doReverse:Boolean = false;
      
      private var _playheadTime:Number = 0;
      
      private var _invertValues:Boolean = false;
      
      private var maxDelay:Number = 87.5;
      
      public function Tween(param1:Object, param2:Object, param3:Object, param4:Number = -1, param5:Number = -1, param6:Function = null, param7:Function = null)
      {
         userEquation = defaultEasingFunction;
         super();
         if(!param1)
         {
            return;
         }
         if(param2 is Array)
         {
            arrayMode = true;
         }
         this.listener = param1;
         this.startValue = param2;
         this.endValue = param3;
         if(!isNaN(param4) && param4 != -1)
         {
            this.duration = param4;
         }
         if(!isNaN(param5) && param5 != -1)
         {
            maxDelay = 1000 / param5;
         }
         this.updateFunction = param6;
         this.endFunction = param7;
         if(param4 == 0)
         {
            id = -1;
            endTween();
         }
         else
         {
            Tween.addTween(this);
         }
      }
      
      mx_internal static function removeTween(param1:Tween) : void
      {
         removeTweenAt(param1.id);
      }
      
      private static function addTween(param1:Tween) : void
      {
         param1.id = activeTweens.length;
         activeTweens.push(param1);
         if(!timer)
         {
            timer = new Timer(interval);
            timer.addEventListener(TimerEvent.TIMER,timerHandler);
            timer.start();
         }
         else
         {
            timer.start();
         }
         if(isNaN(intervalTime))
         {
            intervalTime = getTimer();
         }
         param1.startTime = param1.previousUpdateTime = intervalTime;
      }
      
      private static function timerHandler(param1:TimerEvent) : void
      {
         var _loc6_:Tween = null;
         var _loc2_:Boolean = false;
         var _loc3_:Number = intervalTime;
         intervalTime = getTimer();
         var _loc4_:int = activeTweens.length;
         var _loc5_:int = _loc4_;
         while(_loc5_ >= 0)
         {
            _loc6_ = Tween(activeTweens[_loc5_]);
            if(_loc6_)
            {
               _loc6_.needToLayout = false;
               _loc6_.doInterval();
               if(_loc6_.needToLayout)
               {
                  _loc2_ = true;
               }
            }
            _loc5_--;
         }
         if(_loc2_)
         {
            UIComponentGlobals.layoutManager.validateNow();
         }
         param1.updateAfterEvent();
      }
      
      private static function removeTweenAt(param1:int) : void
      {
         var _loc4_:Tween = null;
         if(param1 >= activeTweens.length || param1 < 0)
         {
            return;
         }
         activeTweens.splice(param1,1);
         var _loc2_:int = activeTweens.length;
         var _loc3_:int = param1;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = Tween(activeTweens[_loc3_]);
            _loc4_.id--;
            _loc3_++;
         }
         if(_loc2_ == 0)
         {
            intervalTime = NaN;
            timer.reset();
         }
      }
      
      mx_internal function get playheadTime() : Number
      {
         return _playheadTime;
      }
      
      public function stop() : void
      {
         if(id >= 0)
         {
            Tween.removeTweenAt(id);
         }
      }
      
      mx_internal function get playReversed() : Boolean
      {
         return _invertValues;
      }
      
      mx_internal function set playReversed(param1:Boolean) : void
      {
         _invertValues = param1;
      }
      
      public function resume() : void
      {
         _isPlaying = true;
         startTime = intervalTime - _playheadTime;
         if(_doReverse)
         {
            reverse();
            _doReverse = false;
         }
      }
      
      public function setTweenHandlers(param1:Function, param2:Function) : void
      {
         this.updateFunction = param1;
         this.endFunction = param2;
      }
      
      private function defaultEasingFunction(param1:Number, param2:Number, param3:Number, param4:Number) : Number
      {
         return param3 / 2 * (Math.sin(Math.PI * (param1 / param4 - 0.5)) + 1) + param2;
      }
      
      public function set easingFunction(param1:Function) : void
      {
         userEquation = param1;
      }
      
      public function endTween() : void
      {
         var _loc1_:TweenEvent = new TweenEvent(TweenEvent.TWEEN_END);
         var _loc2_:Object = getCurrentValue(duration);
         _loc1_.value = _loc2_;
         dispatchEvent(_loc1_);
         if(endFunction != null)
         {
            endFunction(_loc2_);
         }
         else
         {
            listener.onTweenEnd(_loc2_);
         }
         if(id >= 0)
         {
            Tween.removeTweenAt(id);
         }
      }
      
      public function reverse() : void
      {
         if(_isPlaying)
         {
            _doReverse = false;
            seek(duration - _playheadTime);
            _invertValues = !_invertValues;
         }
         else
         {
            _doReverse = !_doReverse;
         }
      }
      
      mx_internal function getCurrentValue(param1:Number) : Object
      {
         var _loc2_:Array = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         if(duration == 0)
         {
            return endValue;
         }
         if(_invertValues)
         {
            param1 = duration - param1;
         }
         if(arrayMode)
         {
            _loc2_ = [];
            _loc3_ = startValue.length;
            _loc4_ = 0;
            while(_loc4_ < _loc3_)
            {
               _loc2_[_loc4_] = userEquation(param1,startValue[_loc4_],endValue[_loc4_] - startValue[_loc4_],duration);
               _loc4_++;
            }
            return _loc2_;
         }
         return userEquation(param1,startValue,Number(endValue) - Number(startValue),duration);
      }
      
      mx_internal function doInterval() : Boolean
      {
         var _loc2_:Number = NaN;
         var _loc3_:Object = null;
         var _loc4_:TweenEvent = null;
         var _loc5_:TweenEvent = null;
         var _loc1_:Boolean = false;
         previousUpdateTime = intervalTime;
         if(_isPlaying || _doSeek)
         {
            _loc2_ = intervalTime - startTime;
            _playheadTime = _loc2_;
            _loc3_ = getCurrentValue(_loc2_);
            if(_loc2_ >= duration && !_doSeek)
            {
               endTween();
               _loc1_ = true;
            }
            else
            {
               if(!started)
               {
                  _loc5_ = new TweenEvent(TweenEvent.TWEEN_START);
                  dispatchEvent(_loc5_);
                  started = true;
               }
               _loc4_ = new TweenEvent(TweenEvent.TWEEN_UPDATE);
               _loc4_.value = _loc3_;
               dispatchEvent(_loc4_);
               if(updateFunction != null)
               {
                  updateFunction(_loc3_);
               }
               else
               {
                  listener.onTweenUpdate(_loc3_);
               }
            }
            _doSeek = false;
         }
         return _loc1_;
      }
      
      public function pause() : void
      {
         _isPlaying = false;
      }
      
      public function seek(param1:Number) : void
      {
         var _loc2_:Number = intervalTime;
         previousUpdateTime = _loc2_;
         startTime = _loc2_ - param1;
         _doSeek = true;
      }
   }
}
