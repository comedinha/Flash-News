package mx.events
{
   import flash.events.Event;
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   public class SliderEvent extends Event
   {
      
      public static const THUMB_PRESS:String = "thumbPress";
      
      public static const CHANGE:String = "change";
      
      mx_internal static const VERSION:String = "3.6.0.21751";
      
      public static const THUMB_DRAG:String = "thumbDrag";
      
      public static const THUMB_RELEASE:String = "thumbRelease";
       
      
      public var value:Number;
      
      public var triggerEvent:Event;
      
      public var clickTarget:String;
      
      public var thumbIndex:int;
      
      public var keyCode:int;
      
      public function SliderEvent(param1:String, param2:Boolean = false, param3:Boolean = false, param4:int = -1, param5:Number = NaN, param6:Event = null, param7:String = null, param8:int = -1)
      {
         super(param1,param2,param3);
         this.thumbIndex = param4;
         this.value = param5;
         this.triggerEvent = param6;
         this.clickTarget = param7;
         this.keyCode = param8;
      }
      
      override public function clone() : Event
      {
         return new SliderEvent(type,bubbles,cancelable,thumbIndex,value,triggerEvent,clickTarget,keyCode);
      }
   }
}
