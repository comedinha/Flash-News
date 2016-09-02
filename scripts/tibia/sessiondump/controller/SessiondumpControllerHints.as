package tibia.sessiondump.controller
{
   import tibia.sessiondump.hints.SessiondumpHintBase;
   import tibia.sessiondump.hints.SessiondumpHints;
   import tibia.tutorial.TutorialProgressServiceAsset;
   import flash.events.Event;
   import tibia.sessiondump.SessiondumpEvent;
   import tibia.help.TransparentHintLayer;
   import flash.events.EventDispatcher;
   import flash.events.MouseEvent;
   import tibia.chat.MessageStorage;
   import flash.utils.ByteArray;
   import shared.utility.Vector3D;
   import shared.utility.StringHelper;
   import tibia.creatures.Creature;
   import tibia.chat.ChatStorage;
   import tibia.chat.MessageMode;
   import tibia.sessiondump.Sessiondump;
   import tibia.sessiondump.SessiondumpReader;
   import tibia.chat.log;
   import tibia.sessiondump.hints.SessiondumpHintsAsset;
   import loader.asset.IAssetProvider;
   import tibia.game.AssetBase;
   
   public class SessiondumpControllerHints extends SessiondumpControllerBase
   {
       
      
      private var m_SessiondumpHints:SessiondumpHints = null;
      
      private var m_MessageStorage:MessageStorage = null;
      
      private var m_CurrentHint:SessiondumpHintBase = null;
      
      private var m_OriginalPlayerName:String = null;
      
      private var m_TutorialProgressServiceAsset:TutorialProgressServiceAsset = null;
      
      public function SessiondumpControllerHints()
      {
         var _loc3_:SessiondumpHintsAsset = null;
         super();
         var _loc1_:IAssetProvider = Tibia.s_GetAssetProvider();
         var _loc2_:Vector.<AssetBase> = _loc1_.getAssetsByClass(SessiondumpHintsAsset);
         if(_loc2_.length == 1)
         {
            _loc3_ = _loc2_[0] as SessiondumpHintsAsset;
            this.m_SessiondumpHints = SessiondumpHints.s_Unmarshall(_loc3_.sessiondumpHintsObject);
            _loc2_ = _loc1_.getAssetsByClass(TutorialProgressServiceAsset);
            if(_loc2_.length == 1)
            {
               this.m_TutorialProgressServiceAsset = _loc2_[0] as TutorialProgressServiceAsset;
               this.m_MessageStorage = new MessageStorage();
               return;
            }
            throw new Error("SessiondumpControllerHints.SessiondumpControllerHints: No tutorial progress service asset");
         }
         throw new Error("SessiondumpControllerHints.SessiondumpControllerHints: No sessiondump hints asset");
      }
      
      override public function setTargetTimestamp(param1:uint, param2:int = 0) : void
      {
         var _loc3_:SessiondumpHintBase = null;
         if(this.m_SessiondumpHints != null)
         {
            _loc3_ = this.m_SessiondumpHints.getNextSessiondumpHintToProcess(param1 - 1);
            while(_loc3_ != null)
            {
               _loc3_.cancel();
               _loc3_ = this.m_SessiondumpHints.getNextSessiondumpHintToProcess(param1);
            }
         }
         super.setTargetTimestamp(param1,param2);
      }
      
      public function set sessiondumpHints(param1:SessiondumpHints) : void
      {
         this.m_SessiondumpHints = param1;
      }
      
      public function get tutorialProgressServiceAsset() : TutorialProgressServiceAsset
      {
         return this.m_TutorialProgressServiceAsset;
      }
      
      private function onSessiondumpComplete(param1:Event) : void
      {
         m_Sessiondump.disconnect(true);
      }
      
      private function onSessiondumpHeaderRead(param1:SessiondumpEvent) : void
      {
         m_SessiondumpReader.packetReader.skipClientPackets = false;
      }
      
      private function onSessiondumpMessageProcessed(param1:SessiondumpEvent) : void
      {
         if(param1.messageType == SPLAYERDATABASIC && this.m_SessiondumpHints != null)
         {
            if(this.m_SessiondumpHints.playerName != null)
            {
               this.m_OriginalPlayerName = Tibia.s_GetPlayer().name;
               Tibia.s_GetPlayer().name = this.m_SessiondumpHints.playerName;
            }
            if(this.m_SessiondumpHints.playerOutfit != null)
            {
               Tibia.s_GetPlayer().outfit = this.m_SessiondumpHints.playerOutfit;
            }
         }
      }
      
      override public function set playSpeedFactor(param1:Number) : void
      {
         if(param1 > 1)
         {
            if(this.m_CurrentHint != null)
            {
               if(this.m_CurrentHint.processed == false)
               {
                  this.m_CurrentHint.cancel();
               }
               super.suspendProcessing = false;
            }
         }
         super.playSpeedFactor = param1;
      }
      
      private function onSessiondumpPacketReceived(param1:SessiondumpEvent) : void
      {
         var _loc2_:Boolean = this.processSessiondumpHints(m_SessiondumpReader.packetReader.packetTimestamp);
         if(_loc2_)
         {
            param1.preventDefault();
            this.playSpeedFactor = 1;
         }
      }
      
      override public function disconnect() : void
      {
         TransparentHintLayer.getInstance().hide();
         if(m_Sessiondump != null)
         {
            m_Sessiondump.removeEventListener(SessiondumpEvent.PACKET_AVAILABLE,this.onSessiondumpPacketReceived);
            m_Sessiondump.removeEventListener(SessiondumpEvent.MESSAGE_AVAILABLE,this.onSessiondumpMesageAvailable);
            m_Sessiondump.removeEventListener(SessiondumpEvent.MESSAGE_PROCESSED,this.onSessiondumpMessageProcessed);
            m_Sessiondump.removeEventListener(Event.COMPLETE,this.onSessiondumpComplete);
         }
         if(m_SessiondumpReader != null)
         {
            m_SessiondumpReader.removeEventListener(SessiondumpEvent.HEADER_READ,this.onSessiondumpHeaderRead);
         }
         this.unregisterSandboxListeners();
         super.disconnect();
      }
      
      public function get sessiondumpHints() : SessiondumpHints
      {
         return this.m_SessiondumpHints;
      }
      
      private function unregisterSandboxListeners() : void
      {
         var _loc1_:EventDispatcher = Tibia.s_GetInstance().systemManager.getSandboxRoot();
         if(_loc1_ != null)
         {
            _loc1_.removeEventListener(MouseEvent.DOUBLE_CLICK,this.onSandboxMouseFilter,true);
            _loc1_.removeEventListener(MouseEvent.RIGHT_CLICK,this.onSandboxMouseFilter,true);
            _loc1_.removeEventListener(MouseEvent.RIGHT_MOUSE_DOWN,this.onSandboxMouseFilter,true);
            _loc1_.removeEventListener(MouseEvent.RIGHT_MOUSE_UP,this.onSandboxMouseFilter,true);
            _loc1_.removeEventListener(MouseEvent.MIDDLE_CLICK,this.onSandboxMouseFilter,true);
            _loc1_.removeEventListener(MouseEvent.MIDDLE_MOUSE_UP,this.onSandboxMouseFilter,true);
            _loc1_.removeEventListener(MouseEvent.MIDDLE_MOUSE_DOWN,this.onSandboxMouseFilter,true);
            _loc1_.removeEventListener(MouseEvent.MOUSE_WHEEL,this.onSandboxMouseFilter,true);
         }
      }
      
      protected function readSTALK(param1:ByteArray) : void
      {
         var a_Bytes:ByteArray = param1;
         var StatementID:int = a_Bytes.readUnsignedInt();
         var Speaker:String = StringHelper.s_ReadLongStringFromByteArray(a_Bytes,Creature.MAX_NAME_LENGHT);
         var SpeakerLevel:int = a_Bytes.readUnsignedShort();
         var Mode:int = a_Bytes.readUnsignedByte();
         if(Speaker == this.m_OriginalPlayerName)
         {
            Speaker = Tibia.s_GetPlayer().name;
         }
         var Pos:Vector3D = null;
         var ChannelID:Object = null;
         switch(Mode)
         {
            case MessageMode.MESSAGE_SAY:
            case MessageMode.MESSAGE_WHISPER:
            case MessageMode.MESSAGE_YELL:
               Pos = Tibia.s_GetCommunication().readCoordinate(a_Bytes);
               ChannelID = ChatStorage.LOCAL_CHANNEL_ID;
               break;
            case MessageMode.MESSAGE_PRIVATE_FROM:
               Pos = null;
               ChannelID = Speaker;
               break;
            case MessageMode.MESSAGE_CHANNEL:
            case MessageMode.MESSAGE_CHANNEL_HIGHLIGHT:
               Pos = null;
               ChannelID = a_Bytes.readUnsignedShort();
               break;
            case MessageMode.MESSAGE_SPELL:
               Pos = Tibia.s_GetCommunication().readCoordinate(a_Bytes);
               ChannelID = ChatStorage.LOCAL_CHANNEL_ID;
               break;
            case MessageMode.MESSAGE_NPC_FROM_START_BLOCK:
               Pos = Tibia.s_GetCommunication().readCoordinate(a_Bytes);
               ChannelID = ChatStorage.NPC_CHANNEL_ID;
               break;
            case MessageMode.MESSAGE_NPC_FROM:
               ChannelID = ChatStorage.NPC_CHANNEL_ID;
               break;
            case MessageMode.MESSAGE_GAMEMASTER_BROADCAST:
               Pos = null;
               ChannelID = null;
               break;
            case MessageMode.MESSAGE_GAMEMASTER_CHANNEL:
               Pos = null;
               ChannelID = a_Bytes.readUnsignedShort();
               break;
            case MessageMode.MESSAGE_GAMEMASTER_PRIVATE_FROM:
               Pos = null;
               ChannelID = Speaker;
               break;
            case MessageMode.MESSAGE_BARK_LOW:
            case MessageMode.MESSAGE_BARK_LOUD:
               Pos = Tibia.s_GetCommunication().readCoordinate(a_Bytes);
               ChannelID = -1;
               break;
            default:
               throw new Error("Connection.readSTALK: Invalid message mode " + Mode + ".",0);
         }
         var Text:String = StringHelper.s_ReadLongStringFromByteArray(a_Bytes,ChatStorage.MAX_TALK_LENGTH);
         if(Mode != MessageMode.MESSAGE_NPC_FROM_START_BLOCK && Mode != MessageMode.MESSAGE_NPC_FROM)
         {
            try
            {
               Tibia.s_GetWorldMapStorage().addOnscreenMessage(Pos,StatementID,Speaker,SpeakerLevel,Mode,Text);
            }
            catch(e:Error)
            {
               throw new Error("Connection.readSTALK: Failed to add message: " + e.message,1);
            }
            try
            {
               Tibia.s_GetChatStorage().addChannelMessage(ChannelID,StatementID,Speaker,SpeakerLevel,Mode,Text);
            }
            catch(e:Error)
            {
               throw new Error("Connection.readSTALK: Failed to add message: " + e.message,2);
            }
         }
         else if(Mode == MessageMode.MESSAGE_NPC_FROM_START_BLOCK)
         {
            this.m_MessageStorage.startMessageBlock(Speaker,Pos,Text);
         }
         else if(Mode == MessageMode.MESSAGE_NPC_FROM)
         {
            this.m_MessageStorage.addTextToBlock(Speaker,Text);
         }
      }
      
      override public function connect(param1:Sessiondump, param2:SessiondumpReader) : void
      {
         super.connect(param1,param2);
         Tibia.s_GetUIEffectsManager().clearEffects();
         TransparentHintLayer.getInstance().show();
         SessiondumpMouseShield.getInstance().reset();
         if(this.m_SessiondumpHints != null)
         {
            this.m_SessiondumpHints.reset();
         }
         this.registerSandboxListeners();
         param1.addEventListener(SessiondumpEvent.PACKET_AVAILABLE,this.onSessiondumpPacketReceived);
         param1.addEventListener(SessiondumpEvent.MESSAGE_AVAILABLE,this.onSessiondumpMesageAvailable);
         param2.addEventListener(SessiondumpEvent.HEADER_READ,this.onSessiondumpHeaderRead);
         param1.addEventListener(SessiondumpEvent.MESSAGE_PROCESSED,this.onSessiondumpMessageProcessed);
         param1.addEventListener(Event.COMPLETE,this.onSessiondumpComplete);
      }
      
      private function processSessiondumpHints(param1:uint) : Boolean
      {
         var _loc2_:SessiondumpHintBase = null;
         if(this.m_SessiondumpHints != null)
         {
            _loc2_ = this.m_SessiondumpHints.getNextSessiondumpHintToProcess(param1);
            while(_loc2_ != null)
            {
               if(_loc2_ != null)
               {
                  if(_loc2_.timestamp < currentSessiondumpTimestamp)
                  {
                     _loc2_.cancel();
                  }
                  else
                  {
                     _loc2_.perform();
                  }
                  if(_loc2_.processed == false)
                  {
                     if(this.m_CurrentHint == null)
                     {
                        this.m_CurrentHint = _loc2_;
                     }
                     break;
                  }
                  this.m_CurrentHint = null;
               }
               _loc2_ = this.m_SessiondumpHints.getNextSessiondumpHintToProcess(param1);
            }
         }
         if(_loc2_ == null)
         {
            this.m_CurrentHint = null;
         }
         return this.m_CurrentHint != null;
      }
      
      public function continueSessiondump() : void
      {
         SessiondumpMouseShield.getInstance().endFadeAnimation();
         play();
      }
      
      protected function onSandboxMouseFilter(param1:MouseEvent) : void
      {
         param1.preventDefault();
         param1.stopImmediatePropagation();
      }
      
      private function onSessiondumpMesageAvailable(param1:SessiondumpEvent) : void
      {
         if(param1.messageType == STALK)
         {
            this.readSTALK(m_Sessiondump.inputStream);
            m_Sessiondump.messageReader.finishMessage();
            param1.preventDefault();
            log("onSessiondumpMesageAvailable: STALK");
         }
      }
      
      private function registerSandboxListeners() : void
      {
         var _loc1_:EventDispatcher = Tibia.s_GetInstance().systemManager.getSandboxRoot();
         if(_loc1_ != null)
         {
            _loc1_.addEventListener(MouseEvent.DOUBLE_CLICK,this.onSandboxMouseFilter,true,int.MAX_VALUE,false);
            _loc1_.addEventListener(MouseEvent.RIGHT_CLICK,this.onSandboxMouseFilter,true,int.MAX_VALUE,false);
            _loc1_.addEventListener(MouseEvent.RIGHT_MOUSE_DOWN,this.onSandboxMouseFilter,true,int.MAX_VALUE,false);
            _loc1_.addEventListener(MouseEvent.RIGHT_MOUSE_UP,this.onSandboxMouseFilter,true,int.MAX_VALUE,false);
            _loc1_.addEventListener(MouseEvent.MIDDLE_CLICK,this.onSandboxMouseFilter,true,int.MAX_VALUE,false);
            _loc1_.addEventListener(MouseEvent.MIDDLE_MOUSE_UP,this.onSandboxMouseFilter,true,int.MAX_VALUE,false);
            _loc1_.addEventListener(MouseEvent.MIDDLE_MOUSE_DOWN,this.onSandboxMouseFilter,true,int.MAX_VALUE,false);
            _loc1_.addEventListener(MouseEvent.MOUSE_WHEEL,this.onSandboxMouseFilter,true,int.MAX_VALUE,false);
         }
      }
      
      override protected function processPackets() : void
      {
         var _loc1_:uint = nextSessiondumpPacketTimestamp;
         if(this.processSessiondumpHints(_loc1_) == false)
         {
            suspendProcessing = false;
            super.processPackets();
         }
         else
         {
            suspendProcessing = true;
            synchronizeSessiondumpTimeWithTibiaTime(Tibia.s_GetTibiaTimer());
            this.playSpeedFactor = 1;
         }
      }
   }
}
