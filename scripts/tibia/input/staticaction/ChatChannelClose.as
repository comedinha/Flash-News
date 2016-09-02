package tibia.input.staticaction
{
   import tibia.chat.ChatStorage;
   import tibia.chat.ChatWidget;
   
   public class ChatChannelClose extends StaticAction
   {
       
      
      private var m_LeftChannel:Boolean = true;
      
      public function ChatChannelClose(param1:int, param2:String, param3:uint, param4:Boolean)
      {
         super(param1,param2,param3,false);
         this.m_LeftChannel = param4;
      }
      
      override public function perform(param1:Boolean = false) : void
      {
         var _loc2_:ChatStorage = Tibia.s_GetChatStorage();
         if(_loc2_ == null)
         {
            return;
         }
         var _loc3_:ChatWidget = Tibia.s_GetChatWidget();
         if(_loc3_ == null)
         {
            return;
         }
         if(this.m_LeftChannel && _loc3_.leftChannel != null && _loc3_.leftChannel.closable)
         {
            _loc2_.leaveChannel(_loc3_.leftChannel);
         }
         else if(!this.m_LeftChannel && _loc3_.rightChannel != null)
         {
            _loc3_.rightChannel = null;
         }
      }
   }
}
