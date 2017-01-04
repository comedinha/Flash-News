package shared.controls
{
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.utils.getTimer;
   import mx.controls.Button;
   
   public class CustomButton extends Button
   {
       
      
      private var m_EventQueue:Vector.<DeferredEvent>;
      
      public function CustomButton()
      {
         this.m_EventQueue = new Vector.<CustomButton>();
         super();
         addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
      }
      
      override protected function mouseUpHandler(param1:MouseEvent) : void
      {
         this.m_EventQueue.length = 0;
         super.mouseUpHandler(param1);
      }
      
      private function onEnterFrame(param1:Event) : void
      {
         this.processEventQueue();
      }
      
      private function processEventQueue(param1:int = 0) : void
      {
         var _loc5_:MouseEvent = null;
         var _loc2_:int = getTimer() - param1;
         var _loc3_:uint = this.m_EventQueue.length;
         var _loc4_:uint = 0;
         while(_loc4_ < _loc3_ && this.m_EventQueue[_loc4_].timestamp <= _loc2_)
         {
            _loc5_ = this.m_EventQueue[_loc4_].event;
            if(_loc5_.type == MouseEvent.ROLL_OUT)
            {
               super.rollOutHandler(_loc5_);
            }
            else
            {
               super.rollOverHandler(_loc5_);
            }
            _loc4_++;
         }
         if(_loc4_ < _loc3_)
         {
            this.m_EventQueue = this.m_EventQueue.slice(_loc4_);
         }
         else
         {
            this.m_EventQueue.length = 0;
         }
      }
      
      override protected function keyUpHandler(param1:KeyboardEvent) : void
      {
         this.m_EventQueue.length = 0;
         super.keyUpHandler(param1);
      }
      
      override protected function rollOutHandler(param1:MouseEvent) : void
      {
         this.m_EventQueue.push(new DeferredEvent(param1));
         this.processEventQueue(50);
      }
      
      override protected function keyDownHandler(param1:KeyboardEvent) : void
      {
         this.m_EventQueue.length = 0;
         super.keyDownHandler(param1);
      }
      
      override protected function mouseDownHandler(param1:MouseEvent) : void
      {
         this.m_EventQueue.length = 0;
         super.mouseDownHandler(param1);
      }
      
      override protected function rollOverHandler(param1:MouseEvent) : void
      {
         this.m_EventQueue.push(new DeferredEvent(param1));
         this.processEventQueue(50);
      }
   }
}

import flash.events.MouseEvent;
import flash.utils.getTimer;

class DeferredEvent
{
    
   
   public var event:MouseEvent = null;
   
   public var timestamp:int = 0;
   
   function DeferredEvent(param1:MouseEvent, param2:int = -1)
   {
      super();
      this.event = param1;
      if(param2 < 0)
      {
         this.timestamp = getTimer();
      }
      else
      {
         this.timestamp = param2;
      }
   }
}
