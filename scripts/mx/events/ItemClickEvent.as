package mx.events
{
   import flash.events.Event;
   import mx.core.mx_internal;
   import flash.display.InteractiveObject;
   
   use namespace mx_internal;
   
   public class ItemClickEvent extends Event
   {
      
      mx_internal static const VERSION:String = "3.6.0.21751";
      
      public static const ITEM_CLICK:String = "itemClick";
       
      
      public var relatedObject:InteractiveObject;
      
      public var index:int;
      
      public var label:String;
      
      public var item:Object;
      
      public function ItemClickEvent(param1:String, param2:Boolean = false, param3:Boolean = false, param4:String = null, param5:int = -1, param6:InteractiveObject = null, param7:Object = null)
      {
         super(param1,param2,param3);
         this.label = param4;
         this.index = param5;
         this.relatedObject = param6;
         this.item = param7;
      }
      
      override public function clone() : Event
      {
         return new ItemClickEvent(type,bubbles,cancelable,label,index,relatedObject,item);
      }
   }
}
