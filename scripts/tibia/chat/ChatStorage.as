package tibia.chat
{
   import flash.events.EventDispatcher;
   import flash.utils.getTimer;
   import mx.collections.ArrayCollection;
   import mx.collections.IList;
   import mx.core.EventPriority;
   import mx.events.CollectionEvent;
   import mx.events.CollectionEventKind;
   import mx.events.PropertyChangeEvent;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   import shared.utility.StringHelper;
   import tibia.§chat:ns_chat_internal§.s_IsPrivateChannel;
   import tibia.§chat:ns_chat_internal§.s_IsRestorableChannel;
   import tibia.creatures.Player;
   import tibia.game.MessageWidget;
   import tibia.game.Tibia11NagWidget;
   import tibia.network.Communication;
   import tibia.options.OptionsStorage;
   import tibia.reporting.reportType.Type;
   
   public class ChatStorage extends EventDispatcher
   {
      
      private static const BUNDLE:String = "ChatStorage";
      
      public static const DEBUG_CHANNEL_ID:int = 131069;
      
      public static const LOCAL_CHANNEL_LABEL:String = ResourceManager.getInstance().getString(BUNDLE,"LBL_LOCAL_CHANNEL");
      
      public static const MAX_GUILD_MOTD_LENGTH:int = 255;
      
      public static const DEBUG_CHANNEL_LABEL:String = ResourceManager.getInstance().getString(BUNDLE,"LBL_DEBUG_CHANNEL");
      
      private static const CHANNEL_ACTIVATION_TIMEOUT:int = 500;
      
      public static const LAST_PARTY_CHANNEL_ID:int = 65533;
      
      public static const LAST_PRIVATE_CHANNEL_ID:int = 9999;
      
      public static const LOOT_CHANNEL_LABEL:String = ResourceManager.getInstance().getString(BUNDLE,"LBL_LOOT_CHANNEL");
      
      public static const NPC_CHANNEL_ID:int = 65534;
      
      public static const FIRST_GUILD_CHANNEL_ID:int = 10000;
      
      public static const ROOK_ADVERTISING_CHANNEL_ID:int = 6;
      
      private static const MSG_CHANNEL_NO_ANONYMOUS:String = ResourceManager.getInstance().getString(BUNDLE,"MSG_CHANNEL_NO_ANONYMOUS");
      
      public static const HELP_CHANNEL_ID:int = 7;
      
      public static const PRIVATE_CHANNEL_ID:int = 65535;
      
      private static const MSG_CHANNEL_TO_SELF:String = ResourceManager.getInstance().getString(BUNDLE,"MSG_CHANNEL_TO_SELF");
      
      public static const MAX_TALK_LENGTH:int = 255;
      
      public static const MAIN_ADVERTISING_CHANNEL_ID:int = 5;
      
      public static const FIRST_PRIVATE_CHANNEL_ID:int = 10;
      
      public static const SESSIONDUMP_CHANNEL_LABEL:String = ResourceManager.getInstance().getString(BUNDLE,"LBL_SESSIONDUMP_CHANNEL");
      
      public static const FIRST_PARTY_CHANNEL_ID:int = 20000;
      
      public static const LOCAL_CHANNEL_ID:int = 131071;
      
      public static const LAST_GUILD_CHANNEL_ID:int = 19999;
      
      public static const LOOT_CHANNEL_ID:int = 131067;
      
      public static const SERVER_CHANNEL_ID:int = 131070;
      
      private static const MSG_CHANNEL_CLOSED:String = ResourceManager.getInstance().getString(BUNDLE,"MSG_CHANNEL_CLOSED");
      
      public static const NPC_CHANNEL_LABEL:String = ResourceManager.getInstance().getString(BUNDLE,"LBL_NPC_CHANNEL");
      
      public static const SESSIONDUMP_CHANNEL_ID:int = 131068;
      
      public static const SERVER_CHANNEL_LABEL:String = ResourceManager.getInstance().getString(BUNDLE,"LBL_SERVER_CHANNEL");
       
      
      protected var m_Channels:IList = null;
      
      protected var m_OwnPrivateChannelID:int = -1;
      
      protected var m_ChannelActivationTimeout:Number = 0;
      
      protected var m_Options:OptionsStorage = null;
      
      public function ChatStorage()
      {
         super();
         this.m_Channels = new ArrayCollection();
         this.m_Channels.addEventListener(CollectionEvent.COLLECTION_CHANGE,this.onChannelsChange,false,EventPriority.DEFAULT_HANDLER,true);
         this.resetChannelActivationTimeout();
      }
      
      static function s_IsPartyChannel(param1:Object) : Boolean
      {
         var _loc2_:int = 0;
         if(param1 is int)
         {
            _loc2_ = int(param1);
            return _loc2_ >= FIRST_PARTY_CHANNEL_ID && _loc2_ <= LAST_PARTY_CHANNEL_ID;
         }
         return false;
      }
      
      static function s_IsPrivateChannel(param1:Object) : Boolean
      {
         if(param1 is int)
         {
            return int(param1) >= FIRST_PRIVATE_CHANNEL_ID && int(param1) <= LAST_PRIVATE_CHANNEL_ID;
         }
         return false;
      }
      
      static function s_IsRestorableChannel(param1:Object) : Boolean
      {
         if(param1 is int)
         {
            return param1 < FIRST_PRIVATE_CHANNEL_ID;
         }
         return false;
      }
      
      static function s_IsGuildChannel(param1:Object) : Boolean
      {
         var _loc2_:int = 0;
         if(param1 is int)
         {
            _loc2_ = int(param1);
            return _loc2_ >= FIRST_GUILD_CHANNEL_ID && _loc2_ <= LAST_GUILD_CHANNEL_ID;
         }
         return false;
      }
      
      public function get ownPrivateChannelID() : int
      {
         return this.m_OwnPrivateChannelID;
      }
      
      public function getChannelIndex(param1:Object) : int
      {
         var _loc4_:Channel = null;
         var _loc2_:Object = Channel.s_NormaliseIdentifier(param1);
         if(_loc2_ == null)
         {
            return -1;
         }
         var _loc3_:int = 0;
         while(_loc3_ < this.m_Channels.length)
         {
            _loc4_ = this.m_Channels.getItemAt(_loc3_) as Channel;
            if(_loc4_ != null && _loc4_.ID === _loc2_)
            {
               return _loc3_;
            }
            _loc3_++;
         }
         return -1;
      }
      
      public function set ownPrivateChannelID(param1:int) : void
      {
         this.m_OwnPrivateChannelID = param1;
      }
      
      public function leaveChannel(param1:Object) : void
      {
         var _loc4_:Channel = null;
         var _loc2_:Object = Channel.s_NormaliseIdentifier(param1);
         var _loc3_:Communication = Tibia.s_GetCommunication();
         if(_loc3_ != null && _loc3_.isGameRunning)
         {
            if(s_IsPrivateChannel(_loc2_))
            {
               _loc4_ = this.getChannel(_loc2_);
               if(_loc4_ == null || _loc4_.sendAllowed)
               {
                  _loc3_.sendCLEAVECHANNEL(int(_loc2_));
               }
            }
            else if(_loc2_ === NPC_CHANNEL_ID)
            {
               _loc3_.sendCCLOSENPCCHANNEL();
            }
            else if(_loc2_ is int)
            {
               _loc3_.sendCLEAVECHANNEL(int(_loc2_));
            }
         }
         if(_loc2_ === this.m_OwnPrivateChannelID)
         {
            this.m_OwnPrivateChannelID = -1;
         }
         this.removeChannel(_loc2_);
      }
      
      public function getChannel(param1:Object) : Channel
      {
         var _loc4_:Channel = null;
         var _loc2_:Object = Channel.s_NormaliseIdentifier(param1);
         if(_loc2_ == null)
         {
            return null;
         }
         var _loc3_:int = 0;
         while(_loc3_ < this.m_Channels.length)
         {
            _loc4_ = this.m_Channels.getItemAt(_loc3_) as Channel;
            if(_loc4_ != null && _loc4_.ID === _loc2_)
            {
               return _loc4_;
            }
            _loc3_++;
         }
         return null;
      }
      
      public function sendChannelMessage(param1:String, param2:Channel, param3:int) : String
      {
         var _loc4_:Communication = Tibia.s_GetCommunication();
         var _loc5_:Player = Tibia.s_GetPlayer();
         if(_loc4_ == null || !_loc4_.isGameRunning || _loc5_ == null)
         {
            return "";
         }
         var _loc6_:String = StringHelper.s_Trim(param1).substr(0,ChatStorage.MAX_TALK_LENGTH);
         if(_loc6_.length < 1)
         {
            return "";
         }
         var _loc7_:int = param3 != MessageMode.MESSAGE_NONE?int(param3):int(param2.sendMode);
         var _loc8_:Object = null;
         if(param2.ID !== DEBUG_CHANNEL_ID && param2.ID !== LOCAL_CHANNEL_ID && param2.ID !== SERVER_CHANNEL_ID && param2.sendAllowed)
         {
            _loc8_ = param2.ID;
         }
         var _loc9_:String = null;
         var _loc10_:RegExp = /^#([sywbixc])\s+(.*)/i;
         var _loc11_:RegExp = /^([*@$])([^\1]+?)\1\s*(.*)/;
         var _loc12_:Object = null;
         var _loc13_:String = null;
         if((_loc12_ = _loc10_.exec(_loc6_)) != null)
         {
            _loc13_ = String(_loc12_[1]).toLowerCase();
            switch(_loc13_)
            {
               case "b":
                  _loc7_ = MessageMode.MESSAGE_GAMEMASTER_BROADCAST;
                  break;
               case "c":
                  _loc7_ = MessageMode.MESSAGE_GAMEMASTER_CHANNEL;
                  break;
               case "i":
                  _loc7_ = MessageMode.MESSAGE_NONE;
                  break;
               case "s":
                  _loc7_ = MessageMode.MESSAGE_SAY;
                  break;
               case "w":
                  _loc7_ = MessageMode.MESSAGE_WHISPER;
                  break;
               case "x":
                  _loc7_ = MessageMode.MESSAGE_NONE;
                  break;
               case "y":
                  _loc7_ = MessageMode.MESSAGE_YELL;
            }
            _loc6_ = _loc12_[2];
         }
         else if((_loc12_ = _loc11_.exec(_loc6_)) != null)
         {
            _loc13_ = String(_loc12_[1]).toLowerCase();
            switch(_loc13_)
            {
               case "*":
                  _loc7_ = MessageMode.MESSAGE_PRIVATE_TO;
                  break;
               case "@":
                  _loc7_ = MessageMode.MESSAGE_GAMEMASTER_PRIVATE_TO;
            }
            _loc9_ = String(_loc12_[2]).substr(0,Channel.MAX_NAME_LENGTH);
            _loc8_ = Channel.s_NormaliseIdentifier(_loc12_[2]);
            _loc6_ = _loc12_[3];
         }
         if(_loc7_ == MessageMode.MESSAGE_GAMEMASTER_CHANNEL && (_loc8_ == null || _loc8_ is String || _loc8_ === NPC_CHANNEL_ID))
         {
            Tibia.s_GetWorldMapStorage().addOnscreenMessage(MessageMode.MESSAGE_FAILURE,MSG_CHANNEL_NO_ANONYMOUS);
            return "";
         }
         if(this.hasOwnPrivateChannel)
         {
            if(_loc13_ == "i")
            {
               _loc4_.sendCINVITETOCHANNEL(_loc6_,this.ownPrivateChannelID);
            }
            else if(_loc13_ == "x")
            {
               _loc4_.sendCEXCLUDEFROMCHANNEL(_loc6_,this.ownPrivateChannelID);
            }
         }
         switch(_loc7_)
         {
            case MessageMode.MESSAGE_NONE:
               break;
            case MessageMode.MESSAGE_SAY:
            case MessageMode.MESSAGE_WHISPER:
            case MessageMode.MESSAGE_YELL:
               _loc4_.sendCTALK(_loc7_,_loc6_);
               break;
            case MessageMode.MESSAGE_CHANNEL:
               _loc4_.sendCTALK(_loc7_,int(_loc8_),_loc6_);
               break;
            case MessageMode.MESSAGE_PRIVATE_TO:
               this.addChannelMessage(_loc8_,-1,_loc5_.name,_loc5_.level,MessageMode.MESSAGE_PRIVATE_TO,_loc6_);
               if(_loc8_ !== _loc5_.name.toLowerCase())
               {
                  _loc4_.sendCTALK(_loc7_,String(_loc8_),_loc6_);
               }
               break;
            case MessageMode.MESSAGE_NPC_TO:
               this.addChannelMessage(_loc8_,-1,_loc5_.name,_loc5_.level,MessageMode.MESSAGE_NPC_TO,_loc6_);
               _loc4_.sendCTALK(_loc7_,_loc6_);
               break;
            case MessageMode.MESSAGE_GAMEMASTER_BROADCAST:
               _loc4_.sendCTALK(_loc7_,_loc6_);
               break;
            case MessageMode.MESSAGE_GAMEMASTER_CHANNEL:
               _loc4_.sendCTALK(_loc7_,int(_loc8_),_loc6_);
               break;
            case MessageMode.MESSAGE_GAMEMASTER_PRIVATE_TO:
               this.addChannelMessage(_loc8_,-1,_loc5_.name,_loc5_.level,MessageMode.MESSAGE_GAMEMASTER_PRIVATE_TO,_loc6_);
               if(_loc8_ !== _loc5_.name.toLowerCase())
               {
                  _loc4_.sendCTALK(_loc7_,String(_loc8_),_loc6_);
               }
         }
         if(_loc8_ !== param2.ID && (_loc7_ == MessageMode.MESSAGE_PRIVATE_TO || _loc7_ == MessageMode.MESSAGE_GAMEMASTER_PRIVATE_TO))
         {
            return "*" + _loc9_ + "* ";
         }
         return "";
      }
      
      public function get channels() : IList
      {
         return this.m_Channels;
      }
      
      public function addChannelMessage(param1:Object, param2:int, param3:String, param4:int, param5:int, param6:String) : ChannelMessage
      {
         var _loc10_:Boolean = false;
         var _loc11_:* = false;
         var _loc12_:Channel = null;
         var _loc13_:ChannelMessage = null;
         var _loc7_:MessageFilterSet = null;
         var _loc8_:MessageMode = null;
         var _loc9_:NameFilterSet = null;
         if(this.m_Options != null && (_loc7_ = this.m_Options.getMessageFilterSet(MessageFilterSet.DEFAULT_SET)) != null && (_loc8_ = _loc7_.getMessageMode(param5)) != null && _loc8_.showChannelMessage && (_loc9_ = this.m_Options.getNameFilterSet(NameFilterSet.DEFAULT_SET)) != null && (_loc8_.ignoreNameFilter || _loc9_.acceptMessage(param5,param3,param6)))
         {
            _loc10_ = param3 != null && (param1 === ChatStorage.HELP_CHANNEL_ID || param4 > 0);
            _loc11_ = param2 > 0;
            _loc12_ = null;
            _loc13_ = new ChannelMessage(param2,param3,param4,param5,param6);
            _loc13_.formatMessage(_loc7_.showTimestamps,_loc7_.showLevels,_loc8_.textARGB,_loc8_.highlightARGB);
            switch(param5)
            {
               case MessageMode.MESSAGE_SAY:
               case MessageMode.MESSAGE_WHISPER:
               case MessageMode.MESSAGE_YELL:
                  _loc13_.setReportTypeAllowed(Type.REPORT_NAME,_loc10_);
                  _loc13_.setReportTypeAllowed(Type.REPORT_STATEMENT,_loc11_);
                  _loc12_ = this.getChannel(LOCAL_CHANNEL_ID);
                  break;
               case MessageMode.MESSAGE_PRIVATE_FROM:
                  _loc13_.setReportTypeAllowed(Type.REPORT_NAME,_loc10_);
                  _loc13_.setReportTypeAllowed(Type.REPORT_STATEMENT,_loc11_);
                  _loc12_ = this.getChannel(param3);
                  if(_loc12_ == null)
                  {
                     _loc12_ = this.getChannel(LOCAL_CHANNEL_ID);
                  }
                  break;
               case MessageMode.MESSAGE_PRIVATE_TO:
                  _loc13_.setReportTypeAllowed(Type.REPORT_NAME,_loc10_);
                  _loc13_.setReportTypeAllowed(Type.REPORT_STATEMENT,_loc11_);
                  _loc12_ = this.getChannel(param1);
                  if(_loc12_ == null)
                  {
                     _loc12_ = this.getChannel(LOCAL_CHANNEL_ID);
                  }
                  break;
               case MessageMode.MESSAGE_CHANNEL_MANAGEMENT:
                  _loc12_ = this.getChannel(param1);
                  if(_loc12_ == null)
                  {
                     _loc12_ = this.getChannel(SERVER_CHANNEL_ID);
                  }
                  break;
               case MessageMode.MESSAGE_CHANNEL:
               case MessageMode.MESSAGE_CHANNEL_HIGHLIGHT:
                  _loc13_.setReportTypeAllowed(Type.REPORT_NAME,_loc10_);
                  _loc13_.setReportTypeAllowed(Type.REPORT_STATEMENT,_loc11_);
                  _loc12_ = this.getChannel(param1);
                  break;
               case MessageMode.MESSAGE_SPELL:
                  _loc13_.setReportTypeAllowed(Type.REPORT_NAME,_loc10_);
                  _loc12_ = this.getChannel(LOCAL_CHANNEL_ID);
                  break;
               case MessageMode.MESSAGE_NPC_FROM_START_BLOCK:
               case MessageMode.MESSAGE_NPC_FROM:
               case MessageMode.MESSAGE_NPC_TO:
                  _loc12_ = this.addChannel(NPC_CHANNEL_ID,NPC_CHANNEL_LABEL,MessageMode.MESSAGE_NPC_TO);
                  break;
               case MessageMode.MESSAGE_GAMEMASTER_BROADCAST:
                  _loc12_ = this.getChannel(SERVER_CHANNEL_ID);
                  break;
               case MessageMode.MESSAGE_GAMEMASTER_CHANNEL:
                  _loc12_ = this.getChannel(param1);
                  break;
               case MessageMode.MESSAGE_GAMEMASTER_PRIVATE_FROM:
               case MessageMode.MESSAGE_GAMEMASTER_PRIVATE_TO:
                  _loc12_ = this.getChannel(SERVER_CHANNEL_ID);
                  break;
               case MessageMode.MESSAGE_LOGIN:
               case MessageMode.MESSAGE_ADMIN:
               case MessageMode.MESSAGE_GAME:
               case MessageMode.MESSAGE_GAME_HIGHLIGHT:
               case MessageMode.MESSAGE_LOOK:
               case MessageMode.MESSAGE_DAMAGE_DEALED:
               case MessageMode.MESSAGE_DAMAGE_RECEIVED:
               case MessageMode.MESSAGE_HEAL:
               case MessageMode.MESSAGE_MANA:
               case MessageMode.MESSAGE_EXP:
               case MessageMode.MESSAGE_DAMAGE_OTHERS:
               case MessageMode.MESSAGE_HEAL_OTHERS:
               case MessageMode.MESSAGE_EXP_OTHERS:
               case MessageMode.MESSAGE_STATUS:
               case MessageMode.MESSAGE_LOOT:
               case MessageMode.MESSAGE_TRADE_NPC:
               case MessageMode.MESSAGE_REPORT:
               case MessageMode.MESSAGE_HOTKEY_USE:
               case MessageMode.MESSAGE_TUTORIAL_HINT:
               case MessageMode.MESSAGE_THANKYOU:
                  _loc12_ = this.getChannel(SERVER_CHANNEL_ID);
                  break;
               case MessageMode.MESSAGE_GUILD:
                  _loc13_.setReportTypeAllowed(Type.REPORT_NAME,_loc10_);
                  _loc13_.setReportTypeAllowed(Type.REPORT_STATEMENT,_loc11_);
                  _loc12_ = this.getChannel(param1);
                  if(_loc12_ == null)
                  {
                     _loc12_ == this.getChannel(SERVER_CHANNEL_ID);
                  }
                  break;
               case MessageMode.MESSAGE_PARTY_MANAGEMENT:
               case MessageMode.MESSAGE_PARTY:
                  _loc13_.setReportTypeAllowed(Type.REPORT_NAME,_loc10_);
                  _loc13_.setReportTypeAllowed(Type.REPORT_STATEMENT,_loc11_);
                  _loc12_ = this.getChannel(param1);
                  if(_loc12_ == null)
                  {
                     _loc12_ = this.getChannel(SERVER_CHANNEL_ID);
                  }
            }
            if(_loc12_ != null)
            {
               _loc12_.appendMessage(_loc13_);
               return _loc13_;
            }
         }
         return null;
      }
      
      public function loadChannels() : Vector.<int>
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc1_:Vector.<int> = new Vector.<int>();
         var _loc2_:ChannelSet = null;
         if(this.m_Options != null && (_loc2_ = this.m_Options.getChannelSet(ChannelSet.DEFAULT_SET)) != null)
         {
            _loc3_ = 0;
            _loc4_ = _loc2_.length;
            while(_loc3_ < _loc4_)
            {
               _loc5_ = _loc2_.getItemAt(_loc3_);
               if(s_IsRestorableChannel(_loc5_) && this.getChannel(_loc5_) == null)
               {
                  _loc1_.push(_loc5_);
               }
               _loc3_++;
            }
         }
         return _loc1_;
      }
      
      public function resetChannelActivationTimeout() : void
      {
         this.m_ChannelActivationTimeout = getTimer() + CHANNEL_ACTIVATION_TIMEOUT;
      }
      
      public function get options() : OptionsStorage
      {
         return this.m_Options;
      }
      
      public function removeChannel(param1:Object) : Channel
      {
         var _loc3_:int = 0;
         var _loc2_:Channel = this.getChannel(param1);
         if(_loc2_ != null)
         {
            _loc3_ = this.m_Channels.getItemIndex(_loc2_);
            if(_loc3_ > -1)
            {
               this.m_Channels.removeItemAt(_loc3_);
            }
         }
         if(_loc2_ != null && _loc2_.ID === this.m_OwnPrivateChannelID)
         {
            this.m_OwnPrivateChannelID = -1;
         }
         return _loc2_;
      }
      
      public function getChannelAt(param1:int) : Channel
      {
         if(param1 >= 0 && param1 < this.m_Channels.length)
         {
            return Channel(this.m_Channels.getItemAt(param1));
         }
         return null;
      }
      
      public function addChannel(param1:Object, param2:String, param3:int) : Channel
      {
         var _loc6_:IResourceManager = null;
         var _loc7_:CollectionEvent = null;
         var _loc4_:Channel = this.getChannel(param1);
         if(_loc4_ == null)
         {
            _loc4_ = new Channel(param1,param2,param3);
            this.m_Channels.addItem(_loc4_);
            _loc6_ = ResourceManager.getInstance();
            switch(param1)
            {
               case HELP_CHANNEL_ID:
                  this.addChannelMessage(param1,-1,null,0,MessageMode.MESSAGE_CHANNEL_MANAGEMENT,_loc6_.getString(BUNDLE,"MSG_HELP_CHANNEL_INFO"));
                  break;
               case MAIN_ADVERTISING_CHANNEL_ID:
               case ROOK_ADVERTISING_CHANNEL_ID:
                  this.addChannelMessage(param1,-1,null,0,MessageMode.MESSAGE_CHANNEL_MANAGEMENT,_loc6_.getString(BUNDLE,"MSG_ADVERTISING_CHANNEL_INFO"));
            }
         }
         else
         {
            _loc4_.name = param2;
            _loc4_.sendAllowed = true;
            _loc7_ = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE);
            _loc7_.kind = CollectionEventKind.UPDATE;
            _loc7_.items = [_loc4_];
            this.m_Channels.dispatchEvent(_loc7_);
         }
         var _loc5_:Player = Tibia.s_GetPlayer();
         if(_loc5_ != null && _loc5_.name != null)
         {
            _loc4_.playerJoined(_loc5_.name);
         }
         return _loc4_;
      }
      
      protected function onChannelsChange(param1:CollectionEvent) : void
      {
         if(param1 != null && (!param1.cancelable || !param1.isDefaultPrevented()))
         {
            dispatchEvent(param1);
         }
      }
      
      public function reset() : void
      {
         var _loc1_:Channel = null;
         var _loc2_:int = this.m_Channels.length - 1;
         while(_loc2_ >= 0)
         {
            Channel(this.m_Channels.removeItemAt(_loc2_)).dispose();
            _loc2_--;
         }
         _loc1_ = this.getChannel(LOCAL_CHANNEL_ID);
         if(_loc1_ == null)
         {
            _loc1_ = this.addChannel(LOCAL_CHANNEL_ID,LOCAL_CHANNEL_LABEL,MessageMode.MESSAGE_SAY);
            _loc1_.closable = false;
         }
         _loc1_ = this.getChannel(SERVER_CHANNEL_ID);
         if(_loc1_ == null)
         {
            _loc1_ = this.addChannel(SERVER_CHANNEL_ID,SERVER_CHANNEL_LABEL,MessageMode.MESSAGE_SAY);
            _loc1_.closable = false;
         }
         this.m_OwnPrivateChannelID = -1;
         this.resetChannelActivationTimeout();
      }
      
      public function get channelActivationTimeout() : Number
      {
         return this.m_ChannelActivationTimeout;
      }
      
      public function closeChannel(param1:Object) : void
      {
         var _loc2_:Object = Channel.s_NormaliseIdentifier(param1);
         this.addChannelMessage(_loc2_,-1,null,0,MessageMode.MESSAGE_CHANNEL_MANAGEMENT,MSG_CHANNEL_CLOSED);
         var _loc3_:Channel = this.getChannel(_loc2_);
         if(_loc3_ != null)
         {
            _loc3_.sendAllowed = false;
            _loc3_.closable = true;
            _loc3_.clearNicklist();
         }
         if(this.m_OwnPrivateChannelID === _loc2_)
         {
            this.m_OwnPrivateChannelID = -1;
         }
      }
      
      public function saveChannels() : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:Channel = null;
         var _loc1_:ChannelSet = null;
         if(this.m_Options != null && (_loc1_ = this.m_Options.getChannelSet(ChannelSet.DEFAULT_SET)) != null)
         {
            _loc2_ = 0;
            _loc3_ = 0;
            _loc4_ = this.m_Channels.length;
            while(_loc3_ < _loc4_)
            {
               _loc5_ = Channel(this.m_Channels.getItemAt(_loc3_));
               if(_loc5_.isRestorable)
               {
                  _loc1_.addItemAt(int(_loc5_.ID),_loc2_++);
               }
               _loc3_++;
            }
            _loc1_.length = _loc2_;
         }
      }
      
      protected function onOptionsChange(param1:PropertyChangeEvent) : void
      {
         if(param1 != null)
         {
            switch(param1.property)
            {
               case "messageFilterSet":
               case "textColour":
               case "highlightColour":
               case "showTimestamps":
               case "showLevels":
                  this.formatChannelMessages();
                  break;
               case "channelSet":
                  this.arrangeChannelSet();
                  break;
               case "*":
                  this.arrangeChannelSet();
                  this.formatChannelMessages();
            }
         }
      }
      
      private function arrangeChannelSet() : void
      {
      }
      
      private function formatChannelMessages() : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:Boolean = false;
         var _loc4_:int = 0;
         var _loc5_:IList = null;
         var _loc6_:int = 0;
         var _loc7_:CollectionEvent = null;
         var _loc8_:ChannelMessage = null;
         var _loc9_:MessageMode = null;
         var _loc1_:MessageFilterSet = null;
         if(this.m_Options != null && (_loc1_ = this.m_Options.getMessageFilterSet(MessageFilterSet.DEFAULT_SET)) != null)
         {
            _loc2_ = _loc1_.showTimestamps;
            _loc3_ = _loc1_.showLevels;
            _loc4_ = this.m_Channels.length - 1;
            while(_loc4_ >= 0)
            {
               _loc5_ = Channel(this.m_Channels.getItemAt(_loc4_)).messages;
               _loc6_ = _loc5_.length - 1;
               while(_loc6_ >= 0)
               {
                  _loc8_ = ChannelMessage(_loc5_.getItemAt(_loc6_));
                  _loc9_ = _loc1_.getMessageMode(_loc8_.mode);
                  _loc8_.formatMessage(_loc2_,_loc3_,_loc9_.textARGB,_loc9_.highlightARGB);
                  _loc6_--;
               }
               _loc7_ = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE);
               _loc7_.kind = CollectionEventKind.RESET;
               _loc5_.dispatchEvent(_loc7_);
               _loc4_--;
            }
         }
      }
      
      public function joinChannel(param1:Object) : void
      {
         var _loc3_:Object = null;
         var _loc4_:Player = null;
         var _loc5_:MessageWidget = null;
         var _loc2_:Communication = Tibia.s_GetCommunication();
         if(_loc2_ != null && _loc2_.isGameRunning)
         {
            _loc3_ = Channel.s_NormaliseIdentifier(param1);
            if(_loc3_ is int && int(_loc3_) >= 0 && int(_loc3_) < NPC_CHANNEL_ID)
            {
               _loc2_.sendCJOINCHANNEL(int(_loc3_));
            }
            else if(_loc3_ is int && int(_loc3_) == NPC_CHANNEL_ID)
            {
               this.addChannel(NPC_CHANNEL_ID,NPC_CHANNEL_LABEL,MessageMode.MESSAGE_NPC_TO);
            }
            else if(_loc3_ is int && int(_loc3_) == PRIVATE_CHANNEL_ID)
            {
               _loc2_.sendCOPENCHANNEL();
            }
            else if(_loc3_ is String)
            {
               _loc4_ = Tibia.s_GetPlayer();
               if(_loc4_ == null || _loc4_.name == null)
               {
                  return;
               }
               if(_loc3_ == _loc4_.name.toLowerCase())
               {
                  Tibia.s_GetWorldMapStorage().addOnscreenMessage(MessageMode.MESSAGE_FAILURE,MSG_CHANNEL_TO_SELF);
               }
               else
               {
                  _loc2_.sendCPRIVATECHANNEL(String(_loc3_));
               }
            }
            else if(_loc3_ is int && int(_loc3_) == LOOT_CHANNEL_ID)
            {
               _loc5_ = new Tibia11NagWidget();
               _loc5_.show();
            }
         }
      }
      
      public function get hasOwnPrivateChannel() : Boolean
      {
         return s_IsPrivateChannel(this.m_OwnPrivateChannelID);
      }
      
      public function set options(param1:OptionsStorage) : void
      {
         if(this.m_Options != param1)
         {
            if(this.m_Options != null)
            {
               this.m_Options.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onOptionsChange);
            }
            this.m_Options = param1;
            if(this.m_Options != null)
            {
               this.m_Options.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onOptionsChange);
            }
         }
      }
   }
}
