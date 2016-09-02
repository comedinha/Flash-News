package tibia.chat.chatWidgetClasses
{
   import flash.events.Event;
   import tibia.chat.Channel;
   import tibia.chat.ChannelMessage;
   
   public class ChannelEvent extends Event
   {
      
      public static const VIEW_CONTEXT_MENU:String = "viewContextMenu";
      
      public static const DEHIGHLIGHT:String = "dehighlight";
      
      public static const HIGHLIGHT:String = "highlight";
      
      public static const TAB_CONTEXT_MENU:String = "tabContextMenu";
      
      public static const NICKLIST_CONTEXT_MENU:String = "nicklistContextMenu";
       
      
      public var channel:Channel = null;
      
      public var message:ChannelMessage = null;
      
      public var name:String = null;
      
      public function ChannelEvent(param1:String, param2:Boolean = true, param3:Boolean = true, param4:Channel = null, param5:ChannelMessage = null, param6:String = null)
      {
         super(param1,param2,param3);
         this.channel = param4;
         this.message = param5;
         this.name = param6;
      }
      
      override public function clone() : Event
      {
         return new ChannelEvent(type,bubbles,cancelable,this.channel,this.message,this.name);
      }
   }
}
