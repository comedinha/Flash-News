package tibia.network
{
   import flash.events.ErrorEvent;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.events.ProgressEvent;
   import flash.events.SecurityErrorEvent;
   import flash.events.TimerEvent;
   import flash.net.Socket;
   import flash.system.Security;
   import flash.utils.ByteArray;
   import flash.utils.Endian;
   import flash.utils.Timer;
   import flash.utils.getTimer;
   import mx.resources.ResourceManager;
   import shared.cryptography.RSAPublicKey;
   import shared.cryptography.XTEA;
   import shared.utility.StringHelper;
   import tibia.creatures.Creature;
   import tibia.game.AccountCharacter;
   
   public class Connection extends EventDispatcher implements IServerConnection
   {
      
      protected static const CUPCONTAINER:int = 136;
      
      protected static const CQUITGAME:int = 20;
      
      protected static const CMARKETACCEPT:int = 248;
      
      protected static const CGONORTHWEST:int = 109;
      
      protected static const CADDBUDDY:int = 220;
      
      protected static const SOUTFIT:int = 200;
      
      protected static const CONNECTION_STATE_PENDING:int = 3;
      
      protected static const CSETTACTICS:int = 160;
      
      protected static const CPERFORMANCEMETRICS:int = 31;
      
      protected static const SSHOWMESSAGEDIALOG:int = 237;
      
      protected static const ERR_COULD_NOT_CONNECT:int = 5;
      
      protected static const CGOSOUTH:int = 103;
      
      protected static const SSETTACTICS:int = 167;
      
      protected static const SPLAYERDATABASIC:int = 159;
      
      protected static const PACKETLENGTH_SIZE:int = 2;
      
      protected static const SMESSAGE:int = 180;
      
      protected static const CPING:int = 29;
      
      protected static const SCREDITBALANCE:int = 223;
      
      protected static const SPREYDATA:int = 232;
      
      protected static const CGETQUESTLOG:int = 240;
      
      protected static const CENTERWORLD:int = 15;
      
      protected static const CHECKSUM_POS:int = PACKETLENGTH_POS + PACKETLENGTH_SIZE;
      
      protected static const CBUYOBJECT:int = 122;
      
      public static const CLIENT_VERSION:uint = 2416;
      
      protected static const SPING:int = 29;
      
      protected static const CCLOSENPCCHANNEL:int = 158;
      
      public static const PREVIEW_STATE_PREVIEW_NO_ACTIVE_CHANGE:uint = 1;
      
      protected static const SWAIT:int = 182;
      
      protected static const SLOGINSUCCESS:int = 23;
      
      protected static const CROTATENORTH:int = 111;
      
      protected static const CATTACK:int = 161;
      
      public static const LATENCY_LOW:Number = 200;
      
      protected static const CLOOKATCREATURE:int = 141;
      
      protected static const CJOINCHANNEL:int = 152;
      
      protected static const CROTATEEAST:int = 112;
      
      protected static const SBUDDYDATA:int = 210;
      
      protected static const CUSEONCREATURE:int = 132;
      
      public static const LATENCY_HIGH:Number = 1000;
      
      protected static const SPREYTIMELEFT:int = 231;
      
      protected static const CBROWSEFIELD:int = 203;
      
      protected static const CPREYACTION:int = 235;
      
      protected static const SCREATUREPARTY:int = 145;
      
      protected static const SQUESTLOG:int = 240;
      
      protected static const CGUILDMESSAGE:int = 155;
      
      protected static const CCANCEL:int = 190;
      
      protected static const ERR_INTERNAL:int = 0;
      
      protected static const CREMOVEBUDDY:int = 221;
      
      protected static const CAPPLYIMBUEMENT:int = 213;
      
      private static const BUNDLE:String = "Connection";
      
      protected static const CCLOSECONTAINER:int = 135;
      
      protected static const SFIELDDATA:int = 105;
      
      protected static const SCLOSECONTAINER:int = 111;
      
      protected static const SLEFTROW:int = 104;
      
      protected static const SFULLMAP:int = 100;
      
      protected static const CREQUESTRESOURCEBALANCE:int = 237;
      
      protected static const SMISSILEEFFECT:int = 133;
      
      public static const MESSAGEDIALOG_IMBUEMENT_ERROR:int = 1;
      
      protected static const CGOWEST:int = 104;
      
      protected static const CPASSLEADERSHIP:int = 166;
      
      protected static const SSPELLGROUPDELAY:int = 165;
      
      protected static const SBOTTOMROW:int = 103;
      
      protected static const CGETOBJECTINFO:int = 243;
      
      protected static const CSEEKINCONTAINER:int = 204;
      
      protected static const SQUESTLINE:int = 241;
      
      protected static const SUPDATINGSHOPBALANCE:int = 242;
      
      protected static const CGOSOUTHWEST:int = 108;
      
      protected static const SLOGINERROR:int = 20;
      
      protected static const SCREATUREMARKS:int = 147;
      
      protected static const SPREYFREELISTREROLLAVAILABILITY:int = 230;
      
      protected static const CREJECTTRADE:int = 128;
      
      protected static const CLOGIN:int = 10;
      
      protected static const SREQUESTPURCHASEDATA:int = 225;
      
      protected static const CREVOKEINVITATION:int = 165;
      
      protected static const SCREATURESKULL:int = 144;
      
      public static const MESSAGEDIALOG_PREY_ERROR:int = 21;
      
      protected static const CGETCHANNELS:int = 151;
      
      protected static const SUNJUSTIFIEDPOINTS:int = 183;
      
      protected static const SPLAYERDATACURRENT:int = 160;
      
      protected static const STRAPPERS:int = 135;
      
      protected static const SOBJECTINFO:int = 244;
      
      protected static const CGETQUESTLINE:int = 241;
      
      protected static const SSNAPBACK:int = 181;
      
      protected static const ERR_CONNECTION_LOST:int = 6;
      
      protected static const CROTATESOUTH:int = 113;
      
      protected static const CACCEPTTRADE:int = 127;
      
      protected static const SCHANNELS:int = 171;
      
      protected static const SOPENCHANNEL:int = 172;
      
      protected static const STOPFLOOR:int = 190;
      
      private static const PING_RETRY_COUNT:int = 3;
      
      public static const MESSAGEDIALOG_PREY_MESSAGE:int = 20;
      
      protected static const CBUYPREMIUMOFFER:int = 252;
      
      protected static const CLOOKTRADE:int = 126;
      
      protected static const SPRIVATECHANNEL:int = 173;
      
      protected static const SBLESSINGS:int = 156;
      
      protected static const SINGAMESHOPSUCCESS:int = 254;
      
      protected static const SSTOREBUTTONINDICATORS:int = 25;
      
      protected static const CPRIVATECHANNEL:int = 154;
      
      protected static const CGETTRANSACTIONHISTORY:int = 254;
      
      protected static const SLOGINWAIT:int = 22;
      
      public static const RESOURCETYPE_BANK_GOLD:int = 0;
      
      protected static const SCREATEONMAP:int = 106;
      
      protected static const SPREYREROLLPRICE:int = 233;
      
      public static const PREVIEW_STATE_REGULAR:uint = 0;
      
      protected static const CTRADEOBJECT:int = 125;
      
      public static const MESSAGEDIALOG_CLEARING_CHARM_SUCCESS:int = 10;
      
      protected static const CLOOK:int = 140;
      
      protected static const ERR_INVALID_CHECKSUM:int = 2;
      
      protected static const PAYLOADLENGTH_POS:int = PAYLOAD_POS;
      
      protected static const SCONTAINER:int = 110;
      
      protected static const SNPCOFFER:int = 122;
      
      protected static const CMARKETCANCEL:int = 247;
      
      protected static const SWORLDENTERED:int = 15;
      
      protected static const CEXCLUDEFROMCHANNEL:int = 172;
      
      protected static const STRANSACTIONHISTORY:int = 253;
      
      protected static const SPREMIUMSHOPOFFERS:int = 252;
      
      protected static const CMOUNT:int = 212;
      
      protected static const CCLOSENPCTRADE:int = 124;
      
      protected static const SMARKETBROWSE:int = 249;
      
      protected static const CSELLOBJECT:int = 123;
      
      protected static const CMARKETBROWSE:int = 245;
      
      protected static const SMARKETLEAVE:int = 247;
      
      protected static const SCOUNTEROFFER:int = 126;
      
      protected static const CFOLLOW:int = 162;
      
      protected static const SBUDDYGROUPDATA:int = 212;
      
      public static const MESSAGEDIALOG_IMBUING_STATION_NOT_FOUND:int = 3;
      
      protected static const HEADER_POS:int = 0;
      
      protected static const SMARKETENTER:int = 246;
      
      protected static const CONNECTION_STATE_CONNECTING_STAGE1:int = 1;
      
      protected static const SCREATURESPEED:int = 143;
      
      protected static const CREQUESTSHOPOFFERS:int = 251;
      
      protected static const CANSWERMODALDIALOG:int = 249;
      
      protected static const CCLOSEDIMBUINGDIALOG:int = 215;
      
      protected static const SSPELLDELAY:int = 164;
      
      protected static const CEDITBUDDY:int = 222;
      
      protected static const SDELETEONMAP:int = 108;
      
      protected static const CEDITGUILDMESSAGE:int = 156;
      
      protected static const CONNECTION_STATE_CONNECTING_STAGE2:int = 2;
      
      protected static const CROTATEWEST:int = 114;
      
      public static const LATENCY_MEDIUM:Number = 500;
      
      protected static const SEDITGUILDMESSAGE:int = 174;
      
      protected static const SCREATUREOUTFIT:int = 142;
      
      public static const PROTOCOL_VERSION:int = 1110;
      
      protected static const SAMBIENTE:int = 130;
      
      protected static const ERR_INVALID_SIZE:int = 1;
      
      protected static const SLOGINCHALLENGE:int = 31;
      
      protected static const CLEAVECHANNEL:int = 153;
      
      private static const PING_LATENCY_INTERVAL:uint = 15;
      
      protected static const SPLAYERSKILLS:int = 161;
      
      protected static const CTHANKYOU:int = 231;
      
      protected static const SRESOURCEBALANCE:int = 238;
      
      protected static const SCREATUREUNPASS:int = 146;
      
      protected static const SSHOWMODALDIALOG:int = 250;
      
      protected static const CONNECTION_STATE_DISCONNECTED:int = 0;
      
      protected static const CGONORTHEAST:int = 106;
      
      protected static const RECONNECT_DELAY:int = 3000;
      
      protected static const SDELETEINCONTAINER:int = 114;
      
      public static const RESOURCETYPE_INVENTORY_GOLD:int = 1;
      
      protected static const SCREATEINCONTAINER:int = 112;
      
      protected static const SCREATUREHEALTH:int = 140;
      
      protected static const CERRORFILEENTRY:int = 232;
      
      protected static const HEADER_SIZE:int = PACKETLENGTH_SIZE + CHECKSUM_SIZE;
      
      protected static const STOPROW:int = 101;
      
      protected static const SBOTTOMFLOOR:int = 191;
      
      protected static const CTURNOBJECT:int = 133;
      
      protected static const COPENPREMIUMSHOP:int = 250;
      
      protected static const CINSPECTPLAYER:int = 206;
      
      protected static const CUSEOBJECT:int = 130;
      
      protected static const CHECKSUM_SIZE:int = 4;
      
      protected static const CLOOKNPCTRADE:int = 121;
      
      protected static const CINVITETOCHANNEL:int = 171;
      
      protected static const CUSETWOOBJECTS:int = 131;
      
      protected static const ERR_INVALID_STATE:int = 4;
      
      protected static const SPREMIUMTRIGGER:int = 158;
      
      protected static const ERR_INVALID_MESSAGE:int = 3;
      
      protected static const CINVITETOPARTY:int = 163;
      
      protected static const SCREATURELIGHT:int = 141;
      
      protected static const CPINGBACK:int = 30;
      
      protected static const SPINGBACK:int = 30;
      
      protected static const STUTORIALHINT:int = 220;
      
      protected static const SPLAYERGOODS:int = 123;
      
      protected static const CSTOP:int = 105;
      
      protected static const SPLAYERINVENTORY:int = 245;
      
      protected static const SINSPECTIONSTATE:int = 119;
      
      protected static const CINSPECTOBJECT:int = 205;
      
      protected static const CMOVEOBJECT:int = 120;
      
      protected static const CRULEVIOLATIONREPORT:int = 242;
      
      protected static const CJOINAGGRESSION:int = 142;
      
      protected static const SMOVECREATURE:int = 109;
      
      protected static const SSWITCHPRESET:int = 157;
      
      protected static const CGOEAST:int = 102;
      
      public static const MESSAGEDIALOG_CLEARING_CHARM_ERROR:int = 11;
      
      protected static const CEDITLIST:int = 138;
      
      protected static const CTOGGLEWRAPSTATE:int = 139;
      
      protected static const CJOINPARTY:int = 164;
      
      protected static const SEDITLIST:int = 151;
      
      protected static const SCLOSETRADE:int = 127;
      
      protected static const SMULTIUSEDELAY:int = 166;
      
      protected static const CONNECTION_STATE_GAME:int = 4;
      
      protected static const CSTOREEVENT:int = 233;
      
      protected static const SSETINVENTORY:int = 120;
      
      protected static const CGOPATH:int = 100;
      
      protected static const CLEAVEPARTY:int = 167;
      
      protected static const SCHANGEONMAP:int = 107;
      
      protected static const CGOSOUTHEAST:int = 107;
      
      protected static const SINSPECTIONLIST:int = 118;
      
      private static const PING_RETRY_INTERVAL:uint = 5;
      
      protected static const CEQUIPOBJECT:int = 119;
      
      protected static const SCREATUREPVPHELPERS:int = 148;
      
      public static const CLIENT_TYPE:uint = 3;
      
      protected static const COPENCHANNEL:int = 170;
      
      protected static const SDEAD:int = 40;
      
      protected static const SCHANGEINCONTAINER:int = 113;
      
      protected static const SIMBUINGDIALOGREFRESH:int = 235;
      
      public static const MESSAGEDIALOG_IMBUEMENT_ROLL_FAILED:int = 2;
      
      protected static const SDELETEINVENTORY:int = 121;
      
      protected static const CTRANSFERCURRENCY:int = 239;
      
      protected static const SINGAMESHOPERROR:int = 224;
      
      protected static const SCHANNELEVENT:int = 243;
      
      protected static const SLOGINADVICE:int = 21;
      
      protected static const SPVPSITUATIONS:int = 184;
      
      protected static const CAPPLYCLEARINGCHARM:int = 214;
      
      protected static const CGONORTH:int = 101;
      
      protected static const SMARKETDETAIL:int = 248;
      
      public static const MESSAGEDIALOG_IMBUEMENT_SUCCESS:int = 0;
      
      protected static const CTALK:int = 150;
      
      protected static const SPREMIUMSHOP:int = 251;
      
      protected static const STALK:int = 170;
      
      protected static const CEDITTEXT:int = 137;
      
      protected static const SCLOSENPCTRADE:int = 124;
      
      protected static const SPENDINGSTATEENTERED:int = 10;
      
      public static const PREVIEW_STATE_PREVIEW_WITH_ACTIVE_CHANGE:uint = 2;
      
      protected static const SRIGHTROW:int = 102;
      
      protected static const SEDITTEXT:int = 150;
      
      protected static const SOPENOWNCHANNEL:int = 178;
      
      protected static const PAYLOADLENGTH_SIZE:int = 2;
      
      protected static const SGRAPHICALEFFECT:int = 131;
      
      protected static const CBUGREPORT:int = 230;
      
      public static const CLIENT_PREVIEW_STATE:uint = 0;
      
      protected static const PAYLOADDATA_POSITION:int = PAYLOADLENGTH_POS + PAYLOADLENGTH_SIZE;
      
      protected static const SCLOSEIMBUINGDIALOG:int = 236;
      
      protected static const CMARKETLEAVE:int = 244;
      
      protected static const COPENTRANSACTIONHISTORY:int = 253;
      
      protected static const CSHAREEXPERIENCE:int = 168;
      
      protected static const SCLEARTARGET:int = 163;
      
      protected static const SCREATURETYPE:int = 149;
      
      protected static const SBUDDYSTATUSCHANGE:int = 211;
      
      protected static const CGETOUTFIT:int = 210;
      
      protected static const SCLOSECHANNEL:int = 179;
      
      protected static const CSETOUTFIT:int = 211;
      
      protected static const PACKETLENGTH_POS:int = HEADER_POS;
      
      protected static const SAUTOMAPFLAG:int = 221;
      
      protected static const SOWNOFFER:int = 125;
      
      protected static const PAYLOAD_POS:int = HEADER_POS + HEADER_SIZE;
      
      public static const RESOURCETYPE_PREY_BONUS_REROLLS:int = 10;
      
      protected static const SSETSTOREDEEPLINK:int = 168;
      
      protected static const CMARKETCREATE:int = 246;
      
      protected static const SPLAYERSTATE:int = 162;
       
      
      private var m_Address:String = null;
      
      private var m_PingEarliestTime:uint = 0;
      
      private var m_CurrentConnectionData:IConnectionData = null;
      
      private var m_SessionKey:String = null;
      
      private var m_PacketReader:NetworkPacketReader = null;
      
      private var m_XTEA:XTEA = null;
      
      private var m_LastEvent:int = 0;
      
      private var m_Port:int = 2.147483647E9;
      
      protected var m_SecondaryTimestamp:int = 0;
      
      private var m_PingLatestTime:uint = 0;
      
      private var m_PingLatency:uint = 0;
      
      private var m_MessageReader:NetworkMessageReader = null;
      
      private var m_PingCount:int = 0;
      
      private var m_ConnectionDelay:Timer = null;
      
      private var m_ConnectionState:int = 0;
      
      private var m_Communication:IServerCommunication = null;
      
      private var m_ConnectionWasLost:Boolean = false;
      
      private var m_PingTimer:Timer = null;
      
      private var m_RSAPublicKey:RSAPublicKey = null;
      
      private var m_PingTimeout:uint = 0;
      
      private var m_Socket:Socket = null;
      
      private var m_InputBuffer:ByteArray = null;
      
      private var m_WorldName:String = null;
      
      private var m_PingSent:uint = 0;
      
      private var m_CharacterName:String = null;
      
      private var m_MessageWriter:NetworkMessageWriter = null;
      
      private var m_ConnectedSince:int = 0;
      
      public function Connection()
      {
         super();
         this.setConnectionState(CONNECTION_STATE_DISCONNECTED,false);
         this.m_Socket = null;
         this.createNewInputBuffer();
         this.m_MessageWriter = new NetworkMessageWriter();
         this.m_RSAPublicKey = new RSAPublicKey();
         this.m_XTEA = new XTEA();
      }
      
      public function get latency() : uint
      {
         return this.m_PingLatency;
      }
      
      private function createNewInputBuffer() : void
      {
         this.m_InputBuffer = new ByteArray();
         this.m_InputBuffer.endian = Endian.LITTLE_ENDIAN;
         this.m_PacketReader = new NetworkPacketReader(this.m_InputBuffer);
         this.m_MessageReader = new NetworkMessageReader(this.m_InputBuffer);
      }
      
      public function get isPending() : Boolean
      {
         return this.m_ConnectionState == CONNECTION_STATE_PENDING;
      }
      
      private function handleSendError(param1:int, param2:Error) : void
      {
         var _loc3_:int = param2 != null?int(param2.errorID):-1;
         this.handleConnectionError(512 + param1,_loc3_,param2);
      }
      
      public function dispose() : void
      {
         this.m_Communication = null;
      }
      
      protected function removeListeners(param1:Socket) : void
      {
         var _loc2_:Timer = null;
         if(param1 != null)
         {
            param1.removeEventListener(ProgressEvent.SOCKET_DATA,this.onSocketData);
            param1.removeEventListener(Event.CLOSE,this.onSocketClose);
            param1.removeEventListener(Event.CONNECT,this.onSocketConnect);
            param1.removeEventListener(IOErrorEvent.IO_ERROR,this.onSocketError);
            param1.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onSocketError);
            _loc2_ = Tibia.s_GetSecondaryTimer();
            _loc2_.removeEventListener(TimerEvent.TIMER,this.onSecondaryTimer);
         }
      }
      
      protected function sendCPINGBACK() : void
      {
         var b:ByteArray = null;
         try
         {
            b = this.m_MessageWriter.createMessage();
            b.writeByte(CPINGBACK);
            this.m_MessageWriter.finishMessage();
            return;
         }
         catch(e:Error)
         {
            handleSendError(CPINGBACK,e);
            return;
         }
      }
      
      protected function onDelayComplete(param1:TimerEvent) : void
      {
         var a_Event:TimerEvent = param1;
         if(a_Event != null)
         {
            try
            {
               this.m_ConnectionDelay.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onDelayComplete);
               this.m_ConnectionDelay.stop();
               this.m_ConnectionDelay = null;
               this.m_LastEvent = getTimer();
               this.m_Socket.connect(this.m_Address,this.m_Port);
               return;
            }
            catch(e:Error)
            {
               handleConnectionError(ERR_COULD_NOT_CONNECT,0,e);
               return;
            }
         }
      }
      
      private function onMessageWriterFinished() : void
      {
         var _loc1_:ByteArray = this.m_MessageWriter.outputPacketBuffer;
         this.m_Socket.writeBytes(_loc1_,0,_loc1_.length);
         this.m_Socket.flush();
      }
      
      protected function onSocketConnect(param1:Event) : void
      {
         this.m_LastEvent = this.m_ConnectedSince = getTimer();
         if(this.m_ConnectionState != CONNECTION_STATE_CONNECTING_STAGE1)
         {
            this.handleConnectionError(ERR_INVALID_STATE,1,param1);
         }
         else
         {
            this.sendProxyWorldNameIdentification();
         }
      }
      
      public function get connectionState() : uint
      {
         return this.m_ConnectionState;
      }
      
      private function sendProxyWorldNameIdentification() : void
      {
         var _loc1_:* = null;
         if(this.m_WorldName != null)
         {
            _loc1_ = this.m_WorldName + "\n";
            this.m_Socket.writeUTFBytes(_loc1_);
         }
      }
      
      public function get messageWriter() : IMessageWriter
      {
         return this.m_MessageWriter;
      }
      
      protected function sendCLOGIN(param1:int, param2:int) : void
      {
         var b:ByteArray = null;
         var PayloadStart:int = 0;
         var a_ChallengeTimeStamp:int = param1;
         var a_ChallengeRandom:int = param2;
         try
         {
            b = this.m_MessageWriter.createMessage();
            b.writeByte(CLOGIN);
            b.writeShort(CLIENT_TYPE);
            b.writeShort(Communication.PROTOCOL_VERSION);
            b.writeUnsignedInt(CLIENT_VERSION);
            b.writeShort(Tibia.s_GetAppearanceStorage().contentRevision);
            b.writeByte(CLIENT_PREVIEW_STATE);
            PayloadStart = b.position;
            b.writeByte(0);
            this.m_XTEA.writeKey(b);
            b.writeByte(0);
            StringHelper.s_WriteToByteArray(b,this.m_SessionKey,Tibia.MAX_SESSION_KEY_LENGTH);
            StringHelper.s_WriteToByteArray(b,this.m_CharacterName,Creature.MAX_NAME_LENGHT);
            b.writeUnsignedInt(a_ChallengeTimeStamp);
            b.writeByte(a_ChallengeRandom);
            this.m_RSAPublicKey.encrypt(b,PayloadStart,RSAPublicKey.BLOCKSIZE);
            this.m_MessageWriter.finishMessage();
            return;
         }
         catch(e:Error)
         {
            handleSendError(CLOGIN,e);
            return;
         }
      }
      
      protected function readSPING(param1:ByteArray) : void
      {
         this.sendCPINGBACK();
      }
      
      protected function readSLOGINWAIT(param1:ByteArray) : void
      {
         var _loc2_:String = StringHelper.s_ReadLongStringFromByteArray(param1);
         var _loc3_:int = param1.readUnsignedByte() * 1000;
         this.disconnect(false);
         var _loc4_:ConnectionEvent = new ConnectionEvent(ConnectionEvent.LOGINWAIT);
         _loc4_.message = _loc2_;
         _loc4_.data = _loc3_;
         dispatchEvent(_loc4_);
      }
      
      protected function readSLOGINERROR(param1:ByteArray) : void
      {
         var _loc2_:String = StringHelper.s_ReadLongStringFromByteArray(param1);
         this.disconnect(false);
         var _loc3_:ConnectionEvent = new ConnectionEvent(ConnectionEvent.LOGINERROR);
         _loc3_.message = _loc2_;
         dispatchEvent(_loc3_);
      }
      
      private function handleConnectionError(param1:int, param2:int = 0, param3:Object = null) : void
      {
         this.disconnect(false);
         var _loc4_:String = null;
         switch(param1)
         {
            case ERR_COULD_NOT_CONNECT:
               _loc4_ = ResourceManager.getInstance().getString(BUNDLE,"MSG_COULD_NOT_CONNECT");
               break;
            case ERR_CONNECTION_LOST:
               _loc4_ = ResourceManager.getInstance().getString(BUNDLE,"MSG_LOST_CONNECTION");
               break;
            case ERR_INTERNAL:
            default:
               _loc4_ = ResourceManager.getInstance().getString(BUNDLE,"MSG_INTERNAL_ERROR",[param1,param2]);
         }
         var _loc5_:ConnectionEvent = new ConnectionEvent(ConnectionEvent.ERROR);
         _loc5_.message = _loc4_;
         _loc5_.data = null;
         _loc5_.errorType = param1;
         dispatchEvent(_loc5_);
      }
      
      public function setConnectionState(param1:uint, param2:Boolean = true) : void
      {
         this.m_ConnectionState = param1;
         var _loc3_:ConnectionEvent = null;
         if(this.m_ConnectionState == CONNECTION_STATE_GAME)
         {
            if(param2)
            {
               _loc3_ = new ConnectionEvent(ConnectionEvent.GAME);
               dispatchEvent(_loc3_);
            }
         }
         else if(this.m_ConnectionState == CONNECTION_STATE_PENDING)
         {
            if(param2)
            {
               _loc3_ = new ConnectionEvent(ConnectionEvent.PENDING);
               dispatchEvent(_loc3_);
            }
         }
         else if(this.m_ConnectionState == CONNECTION_STATE_DISCONNECTED)
         {
            if(param2)
            {
               _loc3_ = new ConnectionEvent(ConnectionEvent.DISCONNECTED);
               dispatchEvent(_loc3_);
            }
         }
         else if(this.m_ConnectionState == CONNECTION_STATE_CONNECTING_STAGE1)
         {
            this.m_PacketReader.xtea = null;
            this.m_MessageWriter.xtea = null;
            if(param2)
            {
               _loc3_ = new ConnectionEvent(ConnectionEvent.CONNECTING);
               _loc3_.data = this.m_CharacterName;
               dispatchEvent(_loc3_);
            }
         }
         else if(this.m_ConnectionState == CONNECTION_STATE_CONNECTING_STAGE2)
         {
            this.m_PacketReader.xtea = this.m_XTEA;
            this.m_MessageWriter.xtea = this.m_XTEA;
         }
      }
      
      public function get connectionDuration() : int
      {
         if(this.m_ConnectionState == CONNECTION_STATE_GAME)
         {
            return getTimer() - this.m_ConnectedSince;
         }
         return 0;
      }
      
      public function disconnect(param1:Boolean = true) : void
      {
         var a_SendEvent:Boolean = param1;
         if(this.m_Socket != null)
         {
            this.removeListeners(this.m_Socket);
            try
            {
               this.m_Socket.addEventListener(IOErrorEvent.IO_ERROR,this.onSocketErrorNoErrorHandling);
               this.m_Socket.close();
               this.m_Socket.removeEventListener(IOErrorEvent.IO_ERROR,this.onSocketErrorNoErrorHandling);
            }
            catch(_Error:*)
            {
            }
            this.m_Socket = null;
         }
         if(this.m_InputBuffer != null)
         {
            this.m_InputBuffer.length = 0;
         }
         if(this.m_MessageWriter != null)
         {
            this.m_MessageWriter.registerMessageFinishedCallback(null);
         }
         if(this.m_ConnectionDelay != null)
         {
            this.m_ConnectionDelay.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onDelayComplete);
            this.m_ConnectionDelay.stop();
            this.m_ConnectionDelay = null;
         }
         this.m_SessionKey = null;
         this.m_CharacterName = null;
         this.m_Address = null;
         this.m_Port = int.MAX_VALUE;
         this.m_WorldName = null;
         this.m_PingEarliestTime = 0;
         this.m_PingLatestTime = 0;
         this.m_PingTimeout = 0;
         this.m_PingCount = 0;
         if(this.m_PingTimer != null)
         {
            this.m_PingTimer.removeEventListener(TimerEvent.TIMER,this.onCheckAlive);
            this.m_PingTimer.stop();
            this.m_PingTimer = null;
         }
         this.m_PingSent = 0;
         this.m_PingLatency = 0;
         this.m_CurrentConnectionData = null;
         this.setConnectionState(CONNECTION_STATE_DISCONNECTED,a_SendEvent);
      }
      
      protected function addListeners(param1:Socket) : void
      {
         var _loc2_:Timer = null;
         if(param1 != null)
         {
            param1.addEventListener(ProgressEvent.SOCKET_DATA,this.onSocketData);
            param1.addEventListener(Event.CLOSE,this.onSocketClose);
            param1.addEventListener(Event.CONNECT,this.onSocketConnect);
            param1.addEventListener(IOErrorEvent.IO_ERROR,this.onSocketError);
            param1.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onSocketError);
            _loc2_ = Tibia.s_GetSecondaryTimer();
            _loc2_.addEventListener(TimerEvent.TIMER,this.onSecondaryTimer);
         }
      }
      
      public function get connectionData() : IConnectionData
      {
         return this.m_CurrentConnectionData;
      }
      
      public function get messageReader() : IMessageReader
      {
         return this.m_MessageReader;
      }
      
      public function set communication(param1:IServerCommunication) : void
      {
         this.m_Communication = param1;
      }
      
      protected function sendCPING() : void
      {
         var b:ByteArray = null;
         try
         {
            b = this.m_MessageWriter.createMessage();
            b.writeByte(CPING);
            this.m_MessageWriter.finishMessage();
            return;
         }
         catch(e:Error)
         {
            handleSendError(CPING,e);
            return;
         }
      }
      
      public function readCommunicationData() : void
      {
         var Type:uint = 0;
         var e:ConnectionEvent = null;
         if(this.m_PacketReader == null)
         {
            throw new Error("Connection.readSocketData: Packet reader is null.");
         }
         if(this.messageReader == null)
         {
            throw new Error("Connection.readSocketData: Message reader is null.");
         }
         if(this.m_ConnectionState != CONNECTION_STATE_CONNECTING_STAGE1 && this.m_ConnectionState != CONNECTION_STATE_CONNECTING_STAGE2 && this.m_ConnectionState != CONNECTION_STATE_PENDING && this.m_ConnectionState != CONNECTION_STATE_GAME)
         {
            return;
         }
         if(this.m_Socket != null && this.m_Socket.connected && this.m_Socket.bytesAvailable > 0)
         {
            this.m_Socket.readBytes(this.m_InputBuffer,this.m_InputBuffer.length);
         }
         var readNextPacket:Boolean = true;
         while(readNextPacket)
         {
            if(this.m_PacketReader.isPacketReady)
            {
               if(this.m_PacketReader.isValidPacket == false)
               {
                  this.handleConnectionError(ERR_INVALID_CHECKSUM,0,"Connection.readSocketData: Invalid checksum.");
                  return;
               }
               this.m_PacketReader.preparePacket();
               while(this.m_PacketReader.containsUnreadMessage)
               {
                  Type = this.messageReader.messageType;
                  if(Type != SPING && Type != SPINGBACK)
                  {
                     this.m_PingEarliestTime = Math.min(this.m_PingLatestTime,this.m_PingTimer.currentCount + PING_RETRY_INTERVAL);
                  }
                  else if(Type == SPINGBACK)
                  {
                     this.m_PingEarliestTime = this.m_PingLatestTime = this.m_PingTimer.currentCount + PING_LATENCY_INTERVAL;
                     this.m_PingTimeout = this.m_PingEarliestTime + PING_RETRY_COUNT * PING_RETRY_INTERVAL;
                     if(this.m_PingCount > 0)
                     {
                        this.m_PingCount--;
                     }
                     if(this.m_PingCount == 0)
                     {
                        this.m_PingLatency = getTimer() - this.m_PingSent;
                        if(this.m_ConnectionWasLost)
                        {
                           this.m_ConnectionWasLost = false;
                           e = new ConnectionEvent(ConnectionEvent.CONNECTION_RECOVERED);
                           dispatchEvent(e);
                        }
                     }
                  }
                  try
                  {
                     switch(Type)
                     {
                        case SPING:
                           this.readSPING(this.m_InputBuffer);
                           this.messageReader.finishMessage();
                           break;
                        case SPINGBACK:
                           this.readSPINGBACK(this.m_InputBuffer);
                           this.messageReader.finishMessage();
                           break;
                        case SLOGINCHALLENGE:
                           this.readSLOGINCHALLENGE(this.m_InputBuffer);
                           this.messageReader.finishMessage();
                           break;
                        case SLOGINERROR:
                           this.readSLOGINERROR(this.m_InputBuffer);
                           this.messageReader.finishMessage();
                           break;
                        case SLOGINADVICE:
                           this.readSLOGINADVICE(this.m_InputBuffer);
                           this.messageReader.finishMessage();
                           break;
                        case SLOGINWAIT:
                           this.readSLOGINWAIT(this.m_InputBuffer);
                           this.messageReader.finishMessage();
                           break;
                        default:
                           if(this.communication != null)
                           {
                              this.communication.readMessage(this.messageReader);
                           }
                     }
                     if(this.isConnected && this.messageReader.messageWasRead == false)
                     {
                        this.handleConnectionError(ERR_INVALID_MESSAGE,0,"Connection.readSocketData: Invalid message type " + Type + ".");
                     }
                  }
                  catch(_Error:Error)
                  {
                     handleReadError(Type,_Error);
                     return;
                  }
               }
               this.m_PacketReader.finishPacket();
            }
            else
            {
               readNextPacket = false;
            }
            if(this.communication != null)
            {
               this.communication.messageProcessingFinished();
            }
         }
      }
      
      private function handleReadError(param1:int, param2:Error) : void
      {
         var _loc3_:int = param2 != null?int(param2.errorID):-1;
         this.handleConnectionError(256 + param1,_loc3_,param2);
      }
      
      public function get communication() : IServerCommunication
      {
         return this.m_Communication;
      }
      
      protected function readSLOGINCHALLENGE(param1:ByteArray) : void
      {
         var _loc2_:int = param1.readUnsignedInt();
         var _loc3_:int = param1.readUnsignedByte();
         param1.position = param1.position + param1.bytesAvailable;
         this.sendCLOGIN(_loc2_,_loc3_);
         this.setConnectionState(CONNECTION_STATE_CONNECTING_STAGE2,false);
         var _loc4_:ConnectionEvent = new ConnectionEvent(ConnectionEvent.LOGINCHALLENGE);
         dispatchEvent(_loc4_);
      }
      
      private function onCheckAlive(param1:TimerEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:ConnectionEvent = null;
         if(this.isGameRunning || this.isPending)
         {
            _loc2_ = this.m_PingTimer.currentCount;
            if(this.m_PingEarliestTime == 0)
            {
               this.m_PingEarliestTime = _loc2_;
            }
            if(_loc2_ >= this.m_PingEarliestTime && (_loc2_ - this.m_PingEarliestTime) % PING_RETRY_INTERVAL == 0 && uint((_loc2_ - this.m_PingEarliestTime) / PING_RETRY_INTERVAL) < PING_RETRY_COUNT)
            {
               this.m_PingTimeout = this.m_PingEarliestTime + PING_RETRY_COUNT * PING_RETRY_INTERVAL;
               this.m_PingCount++;
               this.m_PingSent = getTimer();
               this.sendCPING();
            }
            if(_loc2_ >= this.m_PingTimeout && !(false || false))
            {
               if(this.m_ConnectionWasLost == false)
               {
                  this.m_ConnectionWasLost = true;
                  _loc3_ = new ConnectionEvent(ConnectionEvent.CONNECTION_LOST);
                  dispatchEvent(_loc3_);
               }
            }
         }
      }
      
      protected function readSPINGBACK(param1:ByteArray) : void
      {
      }
      
      protected function onSocketClose(param1:Event) : void
      {
         this.m_LastEvent = getTimer();
         if(this.m_ConnectionState != CONNECTION_STATE_GAME && this.m_ConnectionState != CONNECTION_STATE_PENDING)
         {
            switch(this.m_ConnectionState)
            {
               case CONNECTION_STATE_DISCONNECTED:
                  this.handleConnectionError(ERR_INVALID_STATE,2,param1);
                  break;
               case CONNECTION_STATE_CONNECTING_STAGE1:
                  this.handleConnectionError(ERR_COULD_NOT_CONNECT,0,param1);
                  break;
               case CONNECTION_STATE_CONNECTING_STAGE2:
                  this.handleConnectionError(ERR_CONNECTION_LOST,0,param1);
            }
         }
         else
         {
            this.disconnect();
         }
      }
      
      protected function readSLOGINADVICE(param1:ByteArray) : void
      {
         var _loc2_:String = StringHelper.s_ReadLongStringFromByteArray(param1);
         var _loc3_:ConnectionEvent = new ConnectionEvent(ConnectionEvent.LOGINADVICE);
         _loc3_.message = _loc2_;
         dispatchEvent(_loc3_);
      }
      
      private function onSecondaryTimer(param1:TimerEvent) : void
      {
         var _loc2_:int = Tibia.s_GetTibiaTimer();
         if(_loc2_ > this.m_SecondaryTimestamp)
         {
            this.readCommunicationData();
         }
         this.m_SecondaryTimestamp = _loc2_;
      }
      
      public function connect(param1:IConnectionData) : void
      {
         var _loc4_:* = null;
         if(!(param1 is AccountCharacter))
         {
            throw new Error("Connection.connect: Invalid connection data.",2147483639);
         }
         var _loc2_:AccountCharacter = param1 as AccountCharacter;
         this.m_CurrentConnectionData = _loc2_;
         if(_loc2_.sessionKey == null || _loc2_.sessionKey.length < 1)
         {
            throw new Error("Connection.connect: Invalid session key.",2147483638);
         }
         if(_loc2_.name == null || _loc2_.name.length < 1)
         {
            throw new Error("Connection.connect: Invalid character name.",2147483636);
         }
         if(_loc2_.address == null || _loc2_.address.length < 1)
         {
            throw new Error("Connection.connect: Invalid server address.",2147483635);
         }
         if(_loc2_.port < 0 || _loc2_.port > 65535)
         {
            throw new Error("Connection.connect: Invalid port number.",2147483634);
         }
         if(this.m_ConnectionState != CONNECTION_STATE_DISCONNECTED)
         {
            throw new Error("Connection.connect: Invalid state.",2147483633);
         }
         this.m_XTEA.generateKey();
         if(this.m_Socket != null)
         {
            this.removeListeners(this.m_Socket);
            this.m_Socket = null;
         }
         this.m_Socket = new Socket();
         this.addListeners(this.m_Socket);
         if(this.m_InputBuffer == null)
         {
            this.createNewInputBuffer();
         }
         this.m_InputBuffer.clear();
         this.m_PacketReader.xtea = null;
         this.m_MessageWriter.registerMessageFinishedCallback(this.onMessageWriterFinished);
         if(Security.sandboxType != Security.LOCAL_TRUSTED)
         {
            _loc4_ = "xmlsocket://" + _loc2_.address + ":843";
            Security.loadPolicyFile(_loc4_);
         }
         this.m_SessionKey = _loc2_.sessionKey;
         this.m_CharacterName = _loc2_.name;
         this.m_Address = _loc2_.address;
         this.m_Port = _loc2_.port;
         this.m_WorldName = _loc2_.world;
         this.m_ConnectedSince = 0;
         this.setConnectionState(CONNECTION_STATE_CONNECTING_STAGE1);
         this.m_PingEarliestTime = 0;
         this.m_PingLatestTime = 0;
         this.m_PingTimeout = 0;
         this.m_PingCount = 0;
         this.m_PingTimer = new Timer(1000,0);
         this.m_PingTimer.addEventListener(TimerEvent.TIMER,this.onCheckAlive);
         this.m_PingTimer.start();
         this.m_PingSent = 0;
         this.m_PingLatency = 0;
         if(this.m_ConnectionDelay != null)
         {
            this.m_ConnectionDelay.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onDelayComplete);
            this.m_ConnectionDelay.stop();
            this.m_ConnectionDelay = null;
         }
         var _loc3_:int = Math.max(0,this.m_LastEvent + RECONNECT_DELAY - getTimer());
         this.m_ConnectionDelay = new Timer(_loc3_,1);
         this.m_ConnectionDelay.addEventListener(TimerEvent.TIMER_COMPLETE,this.onDelayComplete);
         this.m_ConnectionDelay.start();
      }
      
      public function get isGameRunning() : Boolean
      {
         return this.m_ConnectionState == CONNECTION_STATE_GAME;
      }
      
      protected function onSocketErrorNoErrorHandling(param1:ErrorEvent) : void
      {
      }
      
      protected function onSocketData(param1:ProgressEvent) : void
      {
         this.m_LastEvent = getTimer();
         if(this.m_ConnectionState != CONNECTION_STATE_CONNECTING_STAGE1 && this.m_ConnectionState != CONNECTION_STATE_CONNECTING_STAGE2 && this.m_ConnectionState != CONNECTION_STATE_PENDING && this.m_ConnectionState != CONNECTION_STATE_GAME)
         {
            this.handleConnectionError(ERR_INVALID_STATE,3,param1);
         }
         else
         {
            this.readCommunicationData();
         }
      }
      
      protected function onSocketError(param1:ErrorEvent) : void
      {
         this.m_LastEvent = getTimer();
         switch(this.m_ConnectionState)
         {
            case CONNECTION_STATE_DISCONNECTED:
               this.handleConnectionError(ERR_INVALID_STATE,0,param1);
               break;
            case CONNECTION_STATE_CONNECTING_STAGE1:
               this.handleConnectionError(ERR_COULD_NOT_CONNECT,0,param1);
               break;
            case CONNECTION_STATE_CONNECTING_STAGE2:
            case CONNECTION_STATE_PENDING:
            case CONNECTION_STATE_GAME:
               this.handleConnectionError(ERR_CONNECTION_LOST,0,param1);
         }
      }
      
      public function get isConnected() : Boolean
      {
         return this.m_ConnectionState == CONNECTION_STATE_CONNECTING_STAGE1 || this.m_ConnectionState == CONNECTION_STATE_CONNECTING_STAGE2 || this.m_ConnectionState == CONNECTION_STATE_PENDING || this.m_ConnectionState == CONNECTION_STATE_GAME;
      }
   }
}
