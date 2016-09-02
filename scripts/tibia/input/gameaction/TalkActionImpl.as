package tibia.input.gameaction
{
   import tibia.input.IActionImpl;
   import tibia.chat.ChatWidget;
   import tibia.chat.ChatStorage;
   import tibia.network.Communication;
   import tibia.chat.ns_chat_internal;
   
   public class TalkActionImpl implements IActionImpl
   {
      
      protected static const CURRENT_CHANNEL_ID:int = -1;
       
      
      protected var m_AutoSend:Boolean = false;
      
      private var m_ChannelID:int = -1;
      
      protected var m_Text:String = null;
      
      public function TalkActionImpl(param1:String, param2:Boolean, param3:int = -1)
      {
         var _loc4_:ChatWidget = null;
         super();
         if(param1 != null)
         {
            this.m_Text = param1.replace("/^s+/","").replace("/s+$/"," ");
         }
         else
         {
            _loc4_ = Tibia.s_GetChatWidget();
            if(_loc4_ != null)
            {
               this.m_Text = _loc4_.text;
            }
         }
         this.m_AutoSend = param2;
         this.m_ChannelID = param3;
      }
      
      public function perform(param1:Boolean = false) : void
      {
         var _loc2_:ChatWidget = Tibia.s_GetChatWidget();
         var _loc3_:ChatStorage = Tibia.s_GetChatStorage();
         var _loc4_:Communication = Tibia.s_GetCommunication();
         if(_loc2_ == null || _loc3_ == null || _loc4_ == null || this.m_Text == null)
         {
            return;
         }
         if(this.m_ChannelID != CURRENT_CHANNEL_ID)
         {
            _loc2_.leftChannel = _loc3_.getChannel(this.m_ChannelID);
         }
         _loc2_.text = this.m_Text;
         if(this.m_AutoSend)
         {
            _loc2_.ns_chat_internal::onChatSend();
         }
      }
   }
}
