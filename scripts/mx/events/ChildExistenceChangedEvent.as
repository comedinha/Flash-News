package mx.events
{
   import flash.events.Event;
   import mx.core.mx_internal;
   import flash.display.DisplayObject;
   
   use namespace mx_internal;
   
   public class ChildExistenceChangedEvent extends Event
   {
      
      public static const CHILD_REMOVE:String = "childRemove";
      
      mx_internal static const VERSION:String = "3.6.0.21751";
      
      public static const OVERLAY_CREATED:String = "overlayCreated";
      
      public static const CHILD_ADD:String = "childAdd";
       
      
      public var relatedObject:DisplayObject;
      
      public function ChildExistenceChangedEvent(param1:String, param2:Boolean = false, param3:Boolean = false, param4:DisplayObject = null)
      {
         super(param1,param2,param3);
         this.relatedObject = param4;
      }
      
      override public function clone() : Event
      {
         return new ChildExistenceChangedEvent(type,bubbles,cancelable,relatedObject);
      }
   }
}
