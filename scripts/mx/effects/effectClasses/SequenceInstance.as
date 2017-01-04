package mx.effects.effectClasses
{
   import mx.core.UIComponent;
   import mx.core.mx_internal;
   import mx.effects.EffectInstance;
   import mx.effects.IEffectInstance;
   import mx.effects.Tween;
   
   use namespace mx_internal;
   
   public class SequenceInstance extends CompositeEffectInstance
   {
      
      mx_internal static const VERSION:String = "3.6.0.21751";
       
      
      private var startTime:Number = 0;
      
      private var currentInstanceDuration:Number = 0;
      
      private var currentSetIndex:int = -1;
      
      private var currentSet:Array;
      
      private var activeChildCount:Number;
      
      public function SequenceInstance(param1:Object)
      {
         super(param1);
      }
      
      override public function stop() : void
      {
         var _loc1_:Array = null;
         var _loc2_:Array = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:Array = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:IEffectInstance = null;
         if(activeEffectQueue && activeEffectQueue.length > 0)
         {
            _loc1_ = activeEffectQueue.concat();
            activeEffectQueue = null;
            _loc2_ = _loc1_[currentSetIndex];
            _loc3_ = _loc2_.length;
            _loc4_ = 0;
            while(_loc4_ < _loc3_)
            {
               _loc2_[_loc4_].stop();
               _loc4_++;
            }
            _loc5_ = _loc1_.length;
            _loc6_ = currentSetIndex + 1;
            while(_loc6_ < _loc5_)
            {
               _loc7_ = _loc1_[_loc6_];
               _loc8_ = _loc7_.length;
               _loc9_ = 0;
               while(_loc9_ < _loc8_)
               {
                  _loc10_ = _loc7_[_loc9_];
                  _loc10_.effect.deleteInstance(_loc10_);
                  _loc9_++;
               }
               _loc6_++;
            }
         }
         super.stop();
      }
      
      private function playNextChildSet(param1:Number = 0) : Boolean
      {
         var _loc2_:EffectInstance = null;
         if(!playReversed)
         {
            if(!activeEffectQueue || currentSetIndex++ >= activeEffectQueue.length - 1)
            {
               return false;
            }
         }
         else if(currentSetIndex-- <= 0)
         {
            return false;
         }
         var _loc3_:Array = activeEffectQueue[currentSetIndex];
         currentSet = [];
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_.length)
         {
            _loc2_ = _loc3_[_loc4_];
            currentSet.push(_loc2_);
            _loc2_.playReversed = playReversed;
            if(_loc2_.suspendBackgroundProcessing)
            {
               UIComponent.suspendBackgroundProcessing();
            }
            _loc2_.startEffect();
            _loc4_++;
         }
         currentInstanceDuration = currentInstanceDuration + _loc2_.actualDuration;
         return true;
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
            _loc1_ = _loc1_ + _loc4_[0].actualDuration;
            _loc3_++;
         }
         return _loc1_;
      }
      
      override public function end() : void
      {
         var _loc1_:Array = null;
         var _loc2_:Array = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:Array = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         endEffectCalled = true;
         if(activeEffectQueue && activeEffectQueue.length > 0)
         {
            _loc1_ = activeEffectQueue.concat();
            activeEffectQueue = null;
            _loc2_ = _loc1_[currentSetIndex];
            _loc3_ = _loc2_.length;
            _loc4_ = 0;
            while(_loc4_ < _loc3_)
            {
               _loc2_[_loc4_].end();
               _loc4_++;
            }
            _loc5_ = _loc1_.length;
            _loc6_ = currentSetIndex + 1;
            while(_loc6_ < _loc5_)
            {
               _loc7_ = _loc1_[_loc6_];
               _loc8_ = _loc7_.length;
               _loc9_ = 0;
               while(_loc9_ < _loc8_)
               {
                  EffectInstance(_loc7_[_loc9_]).playWithNoDuration();
                  _loc9_++;
               }
               _loc6_++;
            }
         }
         super.end();
      }
      
      override public function reverse() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         super.reverse();
         if(currentSet && currentSet.length > 0)
         {
            _loc1_ = currentSet.length;
            _loc2_ = 0;
            while(_loc2_ < _loc1_)
            {
               currentSet[_loc2_].reverse();
               _loc2_++;
            }
         }
      }
      
      override protected function onEffectEnd(param1:IEffectInstance) : void
      {
         if(Object(param1).suspendBackgroundProcessing)
         {
            UIComponent.resumeBackgroundProcessing();
         }
         if(endEffectCalled)
         {
            return;
         }
         var _loc2_:int = 0;
         while(_loc2_ < currentSet.length)
         {
            if(param1 == currentSet[_loc2_])
            {
               currentSet.splice(_loc2_,1);
               break;
            }
            _loc2_++;
         }
         if(currentSet.length == 0)
         {
            if(false == playNextChildSet())
            {
               finishRepeat();
            }
         }
      }
      
      override public function resume() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         super.resume();
         if(currentSet && currentSet.length > 0)
         {
            _loc1_ = currentSet.length;
            _loc2_ = 0;
            while(_loc2_ < _loc1_)
            {
               currentSet[_loc2_].resume();
               _loc2_++;
            }
         }
      }
      
      override public function play() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:Array = null;
         activeEffectQueue = [];
         currentSetIndex = !!playReversed?int(childSets.length):-1;
         _loc1_ = childSets.length;
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            _loc5_ = childSets[_loc2_];
            activeEffectQueue.push(_loc5_);
            _loc2_++;
         }
         super.play();
         startTime = Tween.intervalTime;
         if(activeEffectQueue.length == 0)
         {
            finishRepeat();
            return;
         }
         playNextChildSet();
      }
      
      override public function pause() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         super.pause();
         if(currentSet && currentSet.length > 0)
         {
            _loc1_ = currentSet.length;
            _loc2_ = 0;
            while(_loc2_ < _loc1_)
            {
               currentSet[_loc2_].pause();
               _loc2_++;
            }
         }
      }
   }
}
