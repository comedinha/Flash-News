package tibia.appearances
{
   public class AppearanceAnimator
   {
      
      private static const ENVIRONMENTAL_EFFECTS:Array = [];
      
      public static const ANIMATION_DELAY_BEFORE_RESET:int = 1000;
      
      public static const FRAME_GROUP_WALKING:uint = 1;
      
      public static const PHASE_AUTOMATIC:int = -1;
      
      protected static const APPEARANCE_EFFECT:uint = 2;
      
      public static const SPRITE_CACHE_PAGE_DIMENSION:uint = 512;
      
      public static const FRAME_GROUP_DEFAULT:uint = FRAME_GROUP_IDLE;
      
      private static const MAX_SPEED_DELAY:int = 100;
      
      public static const FRAME_GROUP_IDLE:uint = 0;
      
      public static const COMPRESSED_IMAGES_CACHE_MEMORY:uint = 4 * 768 * 768 * 15;
      
      public static const ANIMATION_ASYNCHRON:int = 0;
      
      protected static const APPEARANCE_MISSILE:uint = 3;
      
      public static const PHASE_RANDOM:int = 254;
      
      private static const MINIMUM_SPEED_FRAME_DURATION:int = 90 * 8;
      
      public static const PHASE_ASYNCHRONOUS:int = 255;
      
      public static const SPRITE_CACHE_PAGE_COUNT:uint = 5 * 5;
      
      private static const MIN_SPEED_DELAY:int = 550;
      
      protected static const APPEARANCE_OBJECT:uint = 0;
      
      private static const MAXIMUM_SPEED_FRAME_DURATION:int = 35 * 8;
      
      protected static const APPEARANCE_OUTFIT:uint = 1;
      
      public static const ANIMATION_SYNCHRON:int = 1;
       
      
      private var m_PhaseCount:uint;
      
      private var m_LastAnimationTick:Number = 0;
      
      private var m_NextFrameStrategy:NextFrameStrategy;
      
      private var m_FrameDurations:Vector.<tibia.appearances.FrameDuration>;
      
      private var m_CurrentPhaseDuration:uint;
      
      private var m_HasFinishedAnimation:Boolean = false;
      
      private var m_StartPhase:int;
      
      private var m_AnimationType:int;
      
      private var m_CurrentPhase:uint;
      
      public function AppearanceAnimator(param1:uint, param2:int, param3:int, param4:int, param5:Vector.<tibia.appearances.FrameDuration>)
      {
         super();
         if(param4 != ANIMATION_ASYNCHRON && param4 != ANIMATION_SYNCHRON)
         {
            throw new ArgumentError("AppearanceAnimator: Unexpected animation type " + param4);
         }
         if(param5.length != param1)
         {
            throw new ArgumentError("AppearanceAnimator: Frameduration differs from phase count");
         }
         if(param2 < -1 || param2 >= param1)
         {
            throw new ArgumentError("AppearanceAnimator: Invalid start phase " + param2);
         }
         this.m_PhaseCount = param1;
         this.m_StartPhase = param2;
         this.m_AnimationType = param4;
         this.m_FrameDurations = param5;
         this.m_LastAnimationTick = Tibia.s_FrameTibiaTimestamp > 0?Number(Tibia.s_FrameTibiaTimestamp):Number(Tibia.s_GetTibiaTimer());
         if(param3 < 0)
         {
            this.m_NextFrameStrategy = new PingPongFrameStrategy();
         }
         else
         {
            this.m_NextFrameStrategy = new LoopFrameStrategy(param3);
         }
         this.phase = PHASE_AUTOMATIC;
      }
      
      public function get frameDurations() : Vector.<tibia.appearances.FrameDuration>
      {
         return this.m_FrameDurations;
      }
      
      public function setEndless() : void
      {
         this.m_NextFrameStrategy = new LoopFrameStrategy(0);
         this.reset();
      }
      
      public function get lastAnimationTick() : Number
      {
         return this.m_LastAnimationTick;
      }
      
      public function reset() : void
      {
         this.phase = PHASE_AUTOMATIC;
         this.m_HasFinishedAnimation = false;
         this.m_NextFrameStrategy.reset();
      }
      
      public function get phaseCount() : uint
      {
         return this.m_PhaseCount;
      }
      
      public function clone() : AppearanceAnimator
      {
         var _loc1_:AppearanceAnimator = null;
         if(this.m_AnimationType == ANIMATION_SYNCHRON)
         {
            return this;
         }
         _loc1_ = new AppearanceAnimator(this.m_PhaseCount,this.m_StartPhase,0,this.m_AnimationType,this.m_FrameDurations);
         _loc1_.m_NextFrameStrategy = this.m_NextFrameStrategy.clone();
         _loc1_.phase = PHASE_AUTOMATIC;
         return _loc1_;
      }
      
      public function get animationType() : int
      {
         return this.m_AnimationType;
      }
      
      public function get finished() : Boolean
      {
         return this.m_HasFinishedAnimation;
      }
      
      public function animate(param1:Number, param2:int = 0) : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:uint = 0;
         var _loc5_:int = 0;
         if(param1 != this.m_LastAnimationTick && !this.m_HasFinishedAnimation)
         {
            _loc3_ = param1 - this.m_LastAnimationTick;
            if(_loc3_ >= this.m_CurrentPhaseDuration)
            {
               _loc4_ = this.m_NextFrameStrategy.nextFrame(this.m_CurrentPhase,this.m_PhaseCount);
               if(this.m_CurrentPhase != _loc4_)
               {
                  _loc5_ = param2 == 0?int(this.m_FrameDurations[_loc4_].duration - (_loc3_ - this.m_CurrentPhaseDuration)):int(this.calculateMovementPhaseDuration(param2));
                  if(_loc5_ < 0 && this.m_AnimationType == ANIMATION_SYNCHRON)
                  {
                     this.calculateSynchronousPhase();
                  }
                  else
                  {
                     this.m_CurrentPhase = _loc4_;
                     this.m_CurrentPhaseDuration = Math.max(0,_loc5_);
                  }
               }
               else
               {
                  this.m_HasFinishedAnimation = true;
               }
            }
            else
            {
               this.m_CurrentPhaseDuration = this.m_CurrentPhaseDuration - _loc3_;
            }
            this.m_LastAnimationTick = param1;
         }
      }
      
      public function set phase(param1:int) : void
      {
         if(this.m_AnimationType == ANIMATION_ASYNCHRON)
         {
            if(param1 == PHASE_ASYNCHRONOUS)
            {
               this.m_CurrentPhase = 0;
            }
            else if(param1 == PHASE_RANDOM)
            {
               this.m_CurrentPhase = Math.floor(Math.random() * this.m_PhaseCount);
            }
            else if(param1 >= 0 && param1 < this.m_PhaseCount)
            {
               this.m_CurrentPhase = param1;
            }
            else
            {
               this.m_CurrentPhase = this.startPhase;
            }
            this.m_HasFinishedAnimation = false;
            this.m_CurrentPhaseDuration = this.m_FrameDurations[this.m_CurrentPhase].duration;
         }
         else
         {
            this.calculateSynchronousPhase();
         }
      }
      
      private function calculateSynchronousPhase() : void
      {
         var _loc6_:tibia.appearances.FrameDuration = null;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc1_:Number = 0;
         var _loc2_:uint = 0;
         while(_loc2_ < this.m_PhaseCount)
         {
            _loc6_ = this.m_FrameDurations[_loc2_];
            _loc1_ = _loc1_ + _loc6_.duration;
            _loc2_++;
         }
         var _loc3_:Number = Tibia.s_FrameTibiaTimestamp > 0?Number(Tibia.s_FrameTibiaTimestamp):Number(Tibia.s_GetTibiaTimer());
         var _loc4_:Number = _loc3_ % _loc1_;
         var _loc5_:Number = 0;
         _loc2_ = 0;
         while(_loc2_ < this.m_PhaseCount)
         {
            _loc7_ = this.m_FrameDurations[_loc2_].duration;
            if(_loc4_ >= _loc5_ && _loc4_ < _loc5_ + _loc7_)
            {
               this.m_CurrentPhase = _loc2_;
               _loc8_ = _loc4_ - _loc5_;
               this.m_CurrentPhaseDuration = _loc7_ - _loc8_;
               break;
            }
            _loc5_ = _loc5_ + _loc7_;
            _loc2_++;
         }
         this.m_LastAnimationTick = _loc3_;
      }
      
      public function get startPhase() : uint
      {
         if(this.m_StartPhase > -1)
         {
            return this.m_StartPhase;
         }
         return Math.floor(Math.random() * this.m_PhaseCount);
      }
      
      private function calculateMovementPhaseDuration(param1:int) : Number
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         _loc2_ = MAX_SPEED_DELAY;
         _loc3_ = MIN_SPEED_DELAY;
         var _loc4_:int = Math.min(Math.max(_loc2_,param1),_loc3_);
         var _loc5_:Number = Number(_loc4_ - _loc2_) / Number(_loc3_ - _loc2_);
         var _loc6_:int = MINIMUM_SPEED_FRAME_DURATION / this.m_PhaseCount;
         var _loc7_:int = MAXIMUM_SPEED_FRAME_DURATION / this.m_PhaseCount;
         return (_loc6_ - _loc7_) * _loc5_ + _loc7_;
      }
      
      public function get phase() : int
      {
         return this.m_CurrentPhase;
      }
      
      public function set finished(param1:Boolean) : void
      {
         this.m_HasFinishedAnimation = param1;
      }
   }
}

class PingPongFrameStrategy extends NextFrameStrategy
{
   
   private static const PHASE_FORWARD:int = 0;
   
   private static const PHASE_BACKWARD:int = 1;
    
   
   private var m_CurrentDirection:int = 0;
   
   function PingPongFrameStrategy()
   {
      super();
   }
   
   override public function nextFrame(param1:uint, param2:uint) : uint
   {
      var _loc3_:int = this.m_CurrentDirection == PHASE_FORWARD?1:-1;
      var _loc4_:int = param1 + _loc3_;
      if(_loc4_ < 0 || _loc4_ >= param2)
      {
         this.m_CurrentDirection = this.m_CurrentDirection == PHASE_FORWARD?int(PHASE_BACKWARD):int(PHASE_FORWARD);
         _loc3_ = _loc3_ * -1;
      }
      return param1 + _loc3_;
   }
   
   override public function clone() : NextFrameStrategy
   {
      var _loc1_:PingPongFrameStrategy = new PingPongFrameStrategy();
      _loc1_.m_CurrentDirection = this.m_CurrentDirection;
      return _loc1_;
   }
   
   override public function reset() : void
   {
      this.m_CurrentDirection = PHASE_FORWARD;
   }
}

class LoopFrameStrategy extends NextFrameStrategy
{
    
   
   private var m_LoopCount:uint;
   
   private var m_CurrentLoop:uint = 0;
   
   function LoopFrameStrategy(param1:uint)
   {
      super();
      this.m_LoopCount = param1;
   }
   
   override public function nextFrame(param1:uint, param2:uint) : uint
   {
      var _loc3_:uint = param1 + 1;
      if(_loc3_ < param2)
      {
         return _loc3_;
      }
      if(this.m_CurrentLoop < this.m_LoopCount - 1 || this.m_LoopCount == 0)
      {
         this.m_CurrentLoop++;
         return 0;
      }
      return param1;
   }
   
   override public function clone() : NextFrameStrategy
   {
      var _loc1_:LoopFrameStrategy = new LoopFrameStrategy(this.m_LoopCount);
      _loc1_.m_CurrentLoop = this.m_CurrentLoop;
      return _loc1_;
   }
   
   override public function reset() : void
   {
      this.m_CurrentLoop = 0;
   }
}

import flash.errors.IllegalOperationError;

class NextFrameStrategy
{
    
   
   function NextFrameStrategy()
   {
      super();
   }
   
   public function nextFrame(param1:uint, param2:uint) : uint
   {
      throw new IllegalOperationError("NextFrameStrategy.nextFrame: Must override in subclass");
   }
   
   public function clone() : NextFrameStrategy
   {
      throw new IllegalOperationError("NextFrameStrategy.clone: Must override in subclass");
   }
   
   public function reset() : void
   {
   }
}
