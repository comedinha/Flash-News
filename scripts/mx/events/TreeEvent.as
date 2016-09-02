package mx.events
{
   import flash.events.Event;
   import mx.core.mx_internal;
   import mx.controls.listClasses.IListItemRenderer;
   
   use namespace mx_internal;
   
   public class TreeEvent extends Event
   {
      
      public static const ITEM_OPEN:String = "itemOpen";
      
      mx_internal static const VERSION:String = "3.6.0.21751";
      
      public static const ITEM_OPENING:String = "itemOpening";
      
      public static const ITEM_CLOSE:String = "itemClose";
       
      
      public var dispatchEvent:Boolean;
      
      public var animate:Boolean;
      
      public var triggerEvent:Event;
      
      public var itemRenderer:IListItemRenderer;
      
      public var opening:Boolean;
      
      public var item:Object;
      
      public function TreeEvent(param1:String, param2:Boolean = false, param3:Boolean = false, param4:Object = null, param5:IListItemRenderer = null, param6:Event = null)
      {
         super(param1,param2,param3);
         this.item = param4;
         this.itemRenderer = param5;
         this.triggerEvent = param6;
      }
      
      override public function clone() : Event
      {
         return new TreeEvent(type,bubbles,cancelable,item,itemRenderer,triggerEvent);
      }
   }
}
