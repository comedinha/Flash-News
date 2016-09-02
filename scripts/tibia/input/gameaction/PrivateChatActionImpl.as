package tibia.input.gameaction
{
   import tibia.input.IActionImpl;
   import mx.resources.IResourceManager;
   import tibia.input.widgetClasses.AskPlayerNameWidget;
   import mx.resources.ResourceManager;
   import mx.events.CloseEvent;
   import tibia.game.PopUpBase;
   import tibia.chat.Channel;
   import tibia.chat.ChatStorage;
   import tibia.chat.ChatWidget;
   import tibia.network.Communication;
   
   public class PrivateChatActionImpl implements IActionImpl
   {
      
      private static const BUNDLE:String = "ChatWidget";
      
      public static const CHAT_CHANNEL_NO_CHANNEL:int = -1;
      
      public static const CHAT_CHANNEL_INVITE:int = 1;
      
      public static const OPEN_CHAT_CHANNEL:int = 0;
      
      public static const OPEN_MESSAGE_CHANNEL:int = 3;
      
      public static const CHAT_CHANNEL_EXCLUDE:int = 2;
       
      
      protected var m_Type:int = -1;
      
      protected var m_ChannelID:int = -1;
      
      protected var m_Name:String = null;
      
      public function PrivateChatActionImpl(param1:int, param2:int, param3:String)
      {
         super();
         if(param1 != OPEN_CHAT_CHANNEL && param1 != OPEN_MESSAGE_CHANNEL && param1 != CHAT_CHANNEL_INVITE && param1 != CHAT_CHANNEL_EXCLUDE)
         {
            throw new ArgumentError("ChatActionImpl.ChatActionImpl: Invalid type: " + param1 + ".");
         }
         this.m_Type = param1;
         this.m_ChannelID = param2;
         this.m_Name = param3;
      }
      
      public function perform(param1:Boolean = false) : void
      {
         var _loc2_:String = null;
         var _loc3_:IResourceManager = null;
         var _loc4_:AskPlayerNameWidget = null;
         if(this.m_Type == OPEN_CHAT_CHANNEL || this.m_Name != null)
         {
            this.performInternal(this.m_Type,this.m_Name);
         }
         else
         {
            _loc2_ = null;
            switch(this.m_Type)
            {
               case CHAT_CHANNEL_INVITE:
                  _loc2_ = "ACTION_INVITE";
                  break;
               case CHAT_CHANNEL_EXCLUDE:
                  _loc2_ = "ACTION_EXCLUDE";
                  break;
               case OPEN_MESSAGE_CHANNEL:
                  _loc2_ = "ACTION_MESSAGE";
            }
            _loc3_ = ResourceManager.getInstance();
            _loc4_ = new AskPlayerNameWidget();
            _loc4_.prompt = _loc3_.getString(BUNDLE,_loc2_ + "_PROMPT");
            _loc4_.title = _loc3_.getString(BUNDLE,_loc2_ + "_TITLE");
            _loc4_.addEventListener(CloseEvent.CLOSE,this.onWidgetClose);
            _loc4_.show();
         }
      }
      
      private function onWidgetClose(param1:CloseEvent) : void
      {
         var _loc2_:AskPlayerNameWidget = null;
         if(param1 != null && param1.detail == PopUpBase.BUTTON_OKAY && (_loc2_ = param1.currentTarget as AskPlayerNameWidget) != null && _loc2_.playerName != null && _loc2_.playerName.length > 0)
         {
            this.performInternal(this.m_Type,_loc2_.playerName);
         }
      }
      
      private function performInternal(param1:int, param2:String) : void
      {
         var _loc6_:Channel = null;
         var _loc3_:ChatStorage = Tibia.s_GetChatStorage();
         var _loc4_:ChatWidget = Tibia.s_GetChatWidget();
         var _loc5_:Communication = Tibia.s_GetCommunication();
         if(_loc3_ != null && _loc4_ != null && _loc5_ != null && _loc5_.isGameRunning)
         {
            _loc6_ = null;
            switch(param1)
            {
               case OPEN_CHAT_CHANNEL:
                  _loc6_ = _loc3_.getChannel(_loc3_.ownPrivateChannelID);
                  if(_loc6_ == null)
                  {
                     _loc5_.sendCOPENCHANNEL();
                  }
                  else
                  {
                     _loc4_.leftChannel = _loc6_;
                  }
                  break;
               case OPEN_MESSAGE_CHANNEL:
                  _loc6_ = _loc3_.getChannel(param2);
                  if(_loc6_ == null)
                  {
                     _loc5_.sendCPRIVATECHANNEL(param2);
                  }
                  else
                  {
                     _loc4_.leftChannel = _loc6_;
                  }
                  break;
               case CHAT_CHANNEL_INVITE:
                  if(this.m_ChannelID > -1)
                  {
                     _loc5_.sendCINVITETOCHANNEL(param2,this.m_ChannelID);
                  }
                  break;
               case CHAT_CHANNEL_EXCLUDE:
                  if(this.m_ChannelID > -1)
                  {
                     _loc5_.sendCEXCLUDEFROMCHANNEL(param2,this.m_ChannelID);
                  }
            }
         }
      }
   }
}
