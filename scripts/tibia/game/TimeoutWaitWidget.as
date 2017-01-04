package tibia.game
{
   import flash.events.TimerEvent;
   import flash.utils.getTimer;
   import mx.events.CloseEvent;
   
   public class TimeoutWaitWidget extends MessageWidget
   {
      
      private static const BUNDLE:String = "Tibia";
      
      public static const TIMOUT_EXPIRED:int = 2147483647;
       
      
      protected var m_ShowTimestamp:Number = -1;
      
      protected var m_Timeout:Number = 0;
      
      private var m_UncommittedTimeout:Boolean = false;
      
      private var m_UncommittedMessage:Boolean = false;
      
      public function TimeoutWaitWidget()
      {
         super();
         buttonFlags = PopUpBase.BUTTON_ABORT;
         keyboardFlags = PopUpBase.KEY_ESCAPE;
      }
      
      public function get timeout() : Number
      {
         return this.m_Timeout;
      }
      
      public function set timeout(param1:Number) : void
      {
         if(this.m_Timeout != param1)
         {
            this.m_Timeout = param1;
            this.m_UncommittedTimeout = true;
            invalidateProperties();
         }
      }
      
      public function get remainingTime() : Number
      {
         if(this.m_ShowTimestamp > -1)
         {
            return this.m_ShowTimestamp + this.m_Timeout - getTimer();
         }
         return this.m_Timeout;
      }
      
      protected function updateMessage() : void
      {
      }
      
      protected function onTimer(param1:TimerEvent) : void
      {
         var _loc2_:int = 0;
         if(param1 != null)
         {
            _loc2_ = this.remainingTime;
            if(_loc2_ <= 0)
            {
               Tibia.s_GetSecondaryTimer().removeEventListener(TimerEvent.TIMER,this.onTimer);
               this.onTimeoutOccurred();
            }
            else
            {
               this.updateMessage();
            }
         }
      }
      
      public function get elapsedTime() : Number
      {
         if(this.m_ShowTimestamp > -1)
         {
            return getTimer() - this.m_ShowTimestamp;
         }
         return getTimer();
      }
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
         var _loc1_:Boolean = false;
         if(this.m_UncommittedMessage)
         {
            _loc1_ = true;
            this.m_UncommittedMessage = false;
         }
         if(this.m_UncommittedTimeout)
         {
            _loc1_ = true;
            this.m_UncommittedTimeout = false;
         }
         if(_loc1_)
         {
            this.updateMessage();
         }
      }
      
      override public function hide(param1:Boolean = false) : void
      {
         super.hide(param1);
         if(this.m_ShowTimestamp > -1)
         {
            this.m_ShowTimestamp = -1;
            Tibia.s_GetSecondaryTimer().removeEventListener(TimerEvent.TIMER,this.onTimer);
         }
      }
      
      protected function getTimeString(param1:uint) : String
      {
         var _loc2_:Number = 0;
         var _loc3_:String = null;
         if(param1 > 60000)
         {
            _loc2_ = Math.ceil(param1 / 60000);
            _loc3_ = _loc2_ == 1?resourceManager.getString(BUNDLE,"TEXT_MINUTE",[_loc2_]):resourceManager.getString(BUNDLE,"TEXT_MINUTES",[_loc2_]);
         }
         else
         {
            _loc2_ = Math.ceil(param1 / 1000);
            _loc3_ = _loc2_ == 1?resourceManager.getString(BUNDLE,"TEXT_SECOND",[_loc2_]):resourceManager.getString(BUNDLE,"TEXT_SECONDS",[_loc2_]);
         }
         return _loc3_;
      }
      
      override public function set message(param1:String) : void
      {
         if(message != param1)
         {
            super.message = param1;
            this.m_UncommittedMessage = true;
            invalidateProperties();
         }
      }
      
      override public function show() : void
      {
         super.show();
         if(this.m_ShowTimestamp < 0)
         {
            this.m_ShowTimestamp = getTimer();
            Tibia.s_GetSecondaryTimer().addEventListener(TimerEvent.TIMER,this.onTimer);
         }
      }
      
      protected function onTimeoutOccurred() : void
      {
         var _loc1_:CloseEvent = new CloseEvent(CloseEvent.CLOSE);
         _loc1_.detail = TIMOUT_EXPIRED;
         dispatchEvent(_loc1_);
      }
   }
}
