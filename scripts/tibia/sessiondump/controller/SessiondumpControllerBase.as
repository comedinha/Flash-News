package tibia.sessiondump.controller
{
   import tibia.sessiondump.Sessiondump;
   import flash.utils.Timer;
   import flash.events.TimerEvent;
   import flash.utils.getTimer;
   import tibia.sessiondump.SessiondumpReader;
   import tibia.sessiondump.SessiondumpEvent;
   import flash.events.Event;
   import shared.utility.nextPowerOfTwo;
   
   public class SessiondumpControllerBase implements ISessiondumpRemoteControl
   {
      
      protected static const CUPCONTAINER:int = 136;
      
      protected static const CQUITGAME:int = 20;
      
      protected static const CMARKETACCEPT:int = 248;
      
      protected static const CONNECTION_STATE_PENDING:int = 3;
      
      protected static const CGONORTHWEST:int = 109;
      
      protected static const SOUTFIT:int = 200;
      
      protected static const CSETTACTICS:int = 160;
      
      protected static const CPERFORMANCEMETRICS:int = 31;
      
      protected static const CADDBUDDY:int = 220;
      
      protected static const ERR_COULD_NOT_CONNECT:int = 5;
      
      protected static const SSETTACTICS:int = 167;
      
      protected static const SPLAYERDATABASIC:int = 159;
      
      protected static const CGOSOUTH:int = 103;
      
      protected static const PACKETLENGTH_SIZE:int = 2;
      
      protected static const SMESSAGE:int = 180;
      
      protected static const CPING:int = 29;
      
      protected static const SCREDITBALANCE:int = 223;
      
      protected static const CHECKSUM_POS:int = PACKETLENGTH_POS + PACKETLENGTH_SIZE;
      
      protected static const CGETQUESTLOG:int = 240;
      
      protected static const CENTERWORLD:int = 15;
      
      protected static const CCLOSENPCCHANNEL:int = 158;
      
      protected static const CBUYOBJECT:int = 122;
      
      protected static const SPING:int = 29;
      
      protected static const CROTATENORTH:int = 111;
      
      protected static const SWAIT:int = 182;
      
      protected static const CATTACK:int = 161;
      
      protected static const SLOGINSUCCESS:int = 23;
      
      protected static const CLOOKATCREATURE:int = 141;
      
      protected static const CJOINCHANNEL:int = 152;
      
      protected static const CROTATEEAST:int = 112;
      
      protected static const SBUDDYDATA:int = 210;
      
      protected static const CUSEONCREATURE:int = 132;
      
      protected static const CBROWSEFIELD:int = 203;
      
      protected static const SCREATUREPARTY:int = 145;
      
      protected static const SQUESTLOG:int = 240;
      
      protected static const ERR_INTERNAL:int = 0;
      
      protected static const CCANCEL:int = 190;
      
      protected static const CGUILDMESSAGE:int = 155;
      
      protected static const CREMOVEBUDDY:int = 221;
      
      protected static const CCLOSECONTAINER:int = 135;
      
      protected static const SFIELDDATA:int = 105;
      
      protected static const SCLOSECONTAINER:int = 111;
      
      protected static const SLEFTROW:int = 104;
      
      protected static const SFULLMAP:int = 100;
      
      protected static const SMISSILEEFFECT:int = 133;
      
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
      
      protected static const CREJECTTRADE:int = 128;
      
      protected static const SREQUESTPURCHASEDATA:int = 225;
      
      protected static const CREVOKEINVITATION:int = 165;
      
      protected static const SCREATURESKULL:int = 144;
      
      protected static const CLOGIN:int = 10;
      
      protected static const ERR_CONNECTION_LOST:int = 6;
      
      protected static const SUNJUSTIFIEDPOINTS:int = 183;
      
      protected static const SPLAYERDATACURRENT:int = 160;
      
      protected static const STRAPPERS:int = 135;
      
      protected static const SOBJECTINFO:int = 244;
      
      protected static const CGETQUESTLINE:int = 241;
      
      protected static const SSNAPBACK:int = 181;
      
      protected static const CROTATESOUTH:int = 113;
      
      protected static const CGETCHANNELS:int = 151;
      
      protected static const CACCEPTTRADE:int = 127;
      
      protected static const SCHANNELS:int = 171;
      
      protected static const SOPENCHANNEL:int = 172;
      
      protected static const STOPFLOOR:int = 190;
      
      protected static const CBUYPREMIUMOFFER:int = 252;
      
      protected static const SPRIVATECHANNEL:int = 173;
      
      protected static const SBLESSINGS:int = 156;
      
      protected static const SINGAMESHOPSUCCESS:int = 254;
      
      protected static const SSTOREBUTTONINDICATORS:int = 25;
      
      protected static const CPRIVATECHANNEL:int = 154;
      
      protected static const PAYLOADLENGTH_POS:int = PAYLOAD_POS;
      
      protected static const SLOGINWAIT:int = 22;
      
      protected static const SCREATEONMAP:int = 106;
      
      protected static const CGETTRANSACTIONHISTORY:int = 254;
      
      protected static const CTRADEOBJECT:int = 125;
      
      protected static const CLOOK:int = 140;
      
      protected static const ERR_INVALID_CHECKSUM:int = 2;
      
      protected static const SCONTAINER:int = 110;
      
      protected static const SNPCOFFER:int = 122;
      
      protected static const CMARKETCANCEL:int = 247;
      
      protected static const SWORLDENTERED:int = 15;
      
      protected static const HEADER_POS:int = 0;
      
      protected static const STRANSACTIONHISTORY:int = 253;
      
      protected static const SPREMIUMSHOPOFFERS:int = 252;
      
      protected static const CSELLOBJECT:int = 123;
      
      protected static const CMOUNT:int = 212;
      
      protected static const CCLOSENPCTRADE:int = 124;
      
      protected static const SMARKETBROWSE:int = 249;
      
      protected static const CMARKETBROWSE:int = 245;
      
      protected static const SMARKETLEAVE:int = 247;
      
      protected static const SCOUNTEROFFER:int = 126;
      
      protected static const CFOLLOW:int = 162;
      
      protected static const CANSWERMODALDIALOG:int = 249;
      
      protected static const CEXCLUDEFROMCHANNEL:int = 172;
      
      protected static const SMARKETENTER:int = 246;
      
      protected static const CONNECTION_STATE_CONNECTING_STAGE1:int = 1;
      
      protected static const CONNECTION_STATE_CONNECTING_STAGE2:int = 2;
      
      protected static const SCREATURESPEED:int = 143;
      
      protected static const CREQUESTSHOPOFFERS:int = 251;
      
      protected static const SSPELLDELAY:int = 164;
      
      protected static const CEDITBUDDY:int = 222;
      
      protected static const SDELETEONMAP:int = 108;
      
      protected static const CEDITGUILDMESSAGE:int = 156;
      
      protected static const CROTATEWEST:int = 114;
      
      public static const PROTOCOL_VERSION:int = 1097;
      
      protected static const SCREATUREOUTFIT:int = 142;
      
      protected static const SEDITGUILDMESSAGE:int = 174;
      
      protected static const SAMBIENTE:int = 130;
      
      protected static const ERR_INVALID_SIZE:int = 1;
      
      protected static const SLOGINCHALLENGE:int = 31;
      
      protected static const CLEAVECHANNEL:int = 153;
      
      protected static const SPLAYERSKILLS:int = 161;
      
      protected static const CTHANKYOU:int = 231;
      
      protected static const SCREATUREUNPASS:int = 146;
      
      protected static const SSHOWMODALDIALOG:int = 250;
      
      protected static const CONNECTION_STATE_DISCONNECTED:int = 0;
      
      protected static const CGONORTHEAST:int = 106;
      
      protected static const SDELETEINCONTAINER:int = 114;
      
      protected static const SCREATEINCONTAINER:int = 112;
      
      protected static const CERRORFILEENTRY:int = 232;
      
      protected static const HEADER_SIZE:int = PACKETLENGTH_SIZE + CHECKSUM_SIZE;
      
      protected static const CINSPECTNPCTRADE:int = 121;
      
      protected static const SCREATUREHEALTH:int = 140;
      
      protected static const STOPROW:int = 101;
      
      protected static const CHECKSUM_SIZE:int = 4;
      
      protected static const CTURNOBJECT:int = 133;
      
      protected static const COPENPREMIUMSHOP:int = 250;
      
      protected static const CUSEOBJECT:int = 130;
      
      protected static const ERR_INVALID_MESSAGE:int = 3;
      
      protected static const SBOTTOMFLOOR:int = 191;
      
      protected static const CINVITETOCHANNEL:int = 171;
      
      protected static const CUSETWOOBJECTS:int = 131;
      
      protected static const ERR_INVALID_STATE:int = 4;
      
      protected static const SPREMIUMTRIGGER:int = 158;
      
      protected static const CINVITETOPARTY:int = 163;
      
      protected static const SCREATURELIGHT:int = 141;
      
      protected static const CPINGBACK:int = 30;
      
      protected static const SPINGBACK:int = 30;
      
      protected static const STUTORIALHINT:int = 220;
      
      protected static const SPLAYERGOODS:int = 123;
      
      protected static const CSTOP:int = 105;
      
      protected static const SPLAYERINVENTORY:int = 245;
      
      protected static const CMOVEOBJECT:int = 120;
      
      protected static const CRULEVIOLATIONREPORT:int = 242;
      
      protected static const CJOINAGGRESSION:int = 142;
      
      protected static const SMOVECREATURE:int = 109;
      
      protected static const SSWITCHPRESET:int = 157;
      
      protected static const CGOEAST:int = 102;
      
      protected static const CEDITLIST:int = 138;
      
      protected static const CTOGGLEWRAPSTATE:int = 139;
      
      protected static const CJOINPARTY:int = 164;
      
      protected static const SCLOSETRADE:int = 127;
      
      protected static const CONNECTION_STATE_GAME:int = 4;
      
      protected static const SMULTIUSEDELAY:int = 166;
      
      protected static const CSTOREEVENT:int = 233;
      
      protected static const SEDITLIST:int = 151;
      
      protected static const SSETINVENTORY:int = 120;
      
      protected static const CGOPATH:int = 100;
      
      protected static const CLEAVEPARTY:int = 167;
      
      protected static const SCHANGEONMAP:int = 107;
      
      protected static const CGOSOUTHEAST:int = 107;
      
      protected static const CEQUIPOBJECT:int = 119;
      
      protected static const SCREATUREPVPHELPERS:int = 148;
      
      protected static const COPENCHANNEL:int = 170;
      
      protected static const SDEAD:int = 40;
      
      protected static const SCHANGEINCONTAINER:int = 113;
      
      protected static const SDELETEINVENTORY:int = 121;
      
      protected static const CTRANSFERCURRENCY:int = 239;
      
      protected static const SINGAMESHOPERROR:int = 224;
      
      protected static const SCHANNELEVENT:int = 243;
      
      protected static const SPVPSITUATIONS:int = 184;
      
      protected static const SLOGINADVICE:int = 21;
      
      protected static const CGONORTH:int = 101;
      
      protected static const SMARKETDETAIL:int = 248;
      
      protected static const CTALK:int = 150;
      
      protected static const PAYLOADDATA_POSITION:int = PAYLOADLENGTH_POS + PAYLOADLENGTH_SIZE;
      
      protected static const SPREMIUMSHOP:int = 251;
      
      protected static const STALK:int = 170;
      
      protected static const CEDITTEXT:int = 137;
      
      protected static const SCLOSENPCTRADE:int = 124;
      
      protected static const SPENDINGSTATEENTERED:int = 10;
      
      protected static const PAYLOADLENGTH_SIZE:int = 2;
      
      protected static const SRIGHTROW:int = 102;
      
      protected static const CINSPECTTRADE:int = 126;
      
      protected static const SEDITTEXT:int = 150;
      
      protected static const SOPENOWNCHANNEL:int = 178;
      
      protected static const SGRAPHICALEFFECT:int = 131;
      
      protected static const CBUGREPORT:int = 230;
      
      private static const CALCULATED_PLAYSPEED_FACTOR_SAMPLE_SIZE:uint = 3;
      
      protected static const CMARKETLEAVE:int = 244;
      
      protected static const COPENTRANSACTIONHISTORY:int = 253;
      
      protected static const CSHAREEXPERIENCE:int = 168;
      
      protected static const SCLEARTARGET:int = 163;
      
      protected static const SCREATURETYPE:int = 149;
      
      protected static const CGETOUTFIT:int = 210;
      
      protected static const SCLOSECHANNEL:int = 179;
      
      protected static const CSETOUTFIT:int = 211;
      
      protected static const PACKETLENGTH_POS:int = HEADER_POS;
      
      protected static const SBUDDYSTATUSCHANGE:int = 211;
      
      protected static const SAUTOMAPFLAG:int = 221;
      
      protected static const SOWNOFFER:int = 125;
      
      protected static const PAYLOAD_POS:int = HEADER_POS + HEADER_SIZE;
      
      protected static const SSETSTOREDEEPLINK:int = 168;
      
      protected static const CMARKETCREATE:int = 246;
      
      protected static const SPLAYERSTATE:int = 162;
       
      
      private var m_CalculatedPlayspeedFactors:Vector.<uint> = null;
      
      private var m_StartTimestamp:int = 0;
      
      private var m_LastProcessedSessiondumpPacketTimestamp:uint = 0;
      
      protected var m_Sessiondump:Sessiondump = null;
      
      private var m_PlaybackFactor:Number = 1;
      
      private var m_SuspendProcessingOfMessages:Boolean = false;
      
      private var m_CalculatedPlayspeedFactorCurrentIndex:uint = 0;
      
      private var m_YieldMessageProcessingAfterMilliseconds:uint = 200;
      
      protected var m_SecondaryTimestamp:int = 0;
      
      private var m_LastRealTimestamp:uint = 0;
      
      private var m_TargetSessiondumpLabel:SessiondumpTargetInformation = null;
      
      private var m_MaxPlayspeedFactor:uint = 1024;
      
      private var m_CalculatedPlayspeedLastProcessedSessiondumpPacketTimestamp:uint = 0;
      
      protected var m_SessiondumpReader:SessiondumpReader = null;
      
      public function SessiondumpControllerBase()
      {
         super();
      }
      
      public function set suspendProcessing(param1:Boolean) : void
      {
         if(param1 != this.m_SuspendProcessingOfMessages && param1 == false)
         {
            this.synchronizeSessiondumpTimeWithTibiaTime(Tibia.s_GetTibiaTimer());
         }
         this.m_SuspendProcessingOfMessages = param1;
      }
      
      public function set maxPlayspeedFactor(param1:uint) : void
      {
         if(param1 == 0)
         {
            throw new ArgumentError("Sessiondump.maxPlayspeedFactor: Value must be bigger than zero");
         }
         this.m_MaxPlayspeedFactor = param1;
      }
      
      public function get calculatedPlaySpeedFactor() : Number
      {
         if(this.playSpeedFactor == 0 && this.playSpeedFactor <= 1)
         {
            return this.playSpeedFactor;
         }
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         while(_loc3_ < CALCULATED_PLAYSPEED_FACTOR_SAMPLE_SIZE)
         {
            _loc1_ = _loc1_ + this.m_CalculatedPlayspeedFactors[_loc3_];
            _loc2_++;
            _loc3_++;
         }
         if(_loc2_ > 0)
         {
            return _loc1_ / _loc2_ + 0.5;
         }
         return 0;
      }
      
      public function get targetTimestamp() : uint
      {
         if(this.m_TargetSessiondumpLabel != null)
         {
            return this.m_TargetSessiondumpLabel.offsetMilliseconds;
         }
         return 0;
      }
      
      public function clearTargetTimestamp() : void
      {
         this.m_TargetSessiondumpLabel = null;
      }
      
      public function stop() : void
      {
         Tibia.s_GetInstance().reset();
         this.m_Sessiondump.reconnect();
         this.playSpeedFactor = 1;
      }
      
      public function get sessiondumpDuration() : uint
      {
         return this.m_Sessiondump.sessiondumpDuration;
      }
      
      public function get isConnected() : Boolean
      {
         return this.m_Sessiondump.isConnected;
      }
      
      public function get sessiondump() : Sessiondump
      {
         return this.m_Sessiondump;
      }
      
      public function disconnect() : void
      {
         this.m_Sessiondump = null;
         var _loc1_:Timer = Tibia.s_GetSecondaryTimer();
         _loc1_.removeEventListener(TimerEvent.TIMER,this.onSecondaryTimer);
      }
      
      public function get playSpeedFactor() : Number
      {
         return Tibia.s_TibiaTimerFactor;
      }
      
      public function get yieldMessageProcessingAfterMilliseconds() : uint
      {
         return this.m_YieldMessageProcessingAfterMilliseconds;
      }
      
      private function measureRealPlaybackSpeed() : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc1_:uint = getTimer();
         if(this.m_CalculatedPlayspeedLastProcessedSessiondumpPacketTimestamp != this.m_LastProcessedSessiondumpPacketTimestamp && _loc1_ > this.m_LastRealTimestamp + 500)
         {
            _loc2_ = _loc1_ - this.m_LastRealTimestamp;
            _loc3_ = this.m_LastProcessedSessiondumpPacketTimestamp - this.m_CalculatedPlayspeedLastProcessedSessiondumpPacketTimestamp;
            if(_loc2_ > 0)
            {
               _loc4_ = _loc3_ / _loc2_;
               this.m_CalculatedPlayspeedFactors[this.m_CalculatedPlayspeedFactorCurrentIndex++ % CALCULATED_PLAYSPEED_FACTOR_SAMPLE_SIZE] = _loc4_;
               this.m_LastRealTimestamp = _loc1_;
               this.m_CalculatedPlayspeedLastProcessedSessiondumpPacketTimestamp = this.m_LastProcessedSessiondumpPacketTimestamp;
            }
         }
      }
      
      private function cleanupBeforeForcedRender() : void
      {
         Tibia.s_GetWorldMapStorage().resetOnscreenMessages();
      }
      
      public function play() : void
      {
         Tibia.s_TibiaTimerFactor = 1;
         this.m_TargetSessiondumpLabel = null;
      }
      
      public function set yieldMessageProcessingAfterMilliseconds(param1:uint) : void
      {
         this.m_YieldMessageProcessingAfterMilliseconds = param1;
      }
      
      public function setTargetTimestamp(param1:uint, param2:int = 0) : void
      {
         if(param1 != 0)
         {
            this.m_TargetSessiondumpLabel = new SessiondumpTargetInformation(param1,param2);
            if(this.playSpeedFactor < 1)
            {
               this.playSpeedFactor = 1;
            }
            this.m_SuspendProcessingOfMessages = false;
         }
         else
         {
            this.m_TargetSessiondumpLabel = null;
         }
      }
      
      public function set playSpeedFactor(param1:Number) : void
      {
         var _loc3_:uint = 0;
         var _loc2_:Number = Math.min(this.m_MaxPlayspeedFactor,param1);
         if(!isNaN(param1) && Tibia.s_TibiaTimerFactor != _loc2_)
         {
            Tibia.s_TibiaTimerFactor = _loc2_;
            if(param1 == 0)
            {
               _loc3_ = 0;
               while(_loc3_ < CALCULATED_PLAYSPEED_FACTOR_SAMPLE_SIZE)
               {
                  this.m_CalculatedPlayspeedFactors[_loc3_] = 0;
                  _loc3_++;
               }
            }
         }
      }
      
      public function get currentSessiondumpTimestamp() : uint
      {
         if(this.m_SessiondumpReader.packetReader != null)
         {
            return this.m_LastProcessedSessiondumpPacketTimestamp;
         }
         return 0;
      }
      
      public function get maxPlayspeedFactor() : uint
      {
         return this.m_MaxPlayspeedFactor;
      }
      
      public function showInfo() : void
      {
      }
      
      public function get nextSessiondumpPacketTimestamp() : uint
      {
         if(this.m_SessiondumpReader.isPacketReady)
         {
            return this.m_SessiondumpReader.packetReader.packetTimestamp;
         }
         return 0;
      }
      
      public function get isGameRunning() : Boolean
      {
         return this.m_Sessiondump.connectionState == CONNECTION_STATE_GAME;
      }
      
      protected function synchronizeSessiondumpTimeWithTibiaTime(param1:int) : void
      {
         var _loc2_:uint = param1 - this.m_StartTimestamp;
         if(_loc2_ > this.nextSessiondumpPacketTimestamp || _loc2_ < this.m_LastProcessedSessiondumpPacketTimestamp)
         {
            this.m_StartTimestamp = param1 - Math.max(this.m_LastProcessedSessiondumpPacketTimestamp,this.nextSessiondumpPacketTimestamp);
         }
      }
      
      public function connect(param1:Sessiondump, param2:SessiondumpReader) : void
      {
         this.m_Sessiondump = param1;
         this.m_SessiondumpReader = param2;
         this.m_CalculatedPlayspeedLastProcessedSessiondumpPacketTimestamp = 0;
         this.m_LastProcessedSessiondumpPacketTimestamp = 0;
         this.m_TargetSessiondumpLabel = null;
         this.m_LastRealTimestamp = 0;
         this.m_CalculatedPlayspeedFactorCurrentIndex = 0;
         this.synchronizeSessiondumpTimeWithTibiaTime(Tibia.s_GetTibiaTimer());
         this.m_PlaybackFactor = 1;
         Tibia.s_TibiaTimerFactor = this.m_PlaybackFactor;
         if(Tibia.s_GetMiniMapStorage() != null)
         {
            Tibia.s_GetMiniMapStorage().reset();
         }
         this.m_CalculatedPlayspeedFactors = new Vector.<uint>(CALCULATED_PLAYSPEED_FACTOR_SAMPLE_SIZE,true);
         var _loc3_:Timer = Tibia.s_GetSecondaryTimer();
         _loc3_.addEventListener(TimerEvent.TIMER,this.onSecondaryTimer);
      }
      
      public function get currentSessiondumpEstimatedTimestamp() : uint
      {
         if(this.m_Sessiondump == null)
         {
            return 0;
         }
         if(this.m_Sessiondump.sessiondumpDone)
         {
            return this.m_Sessiondump.sessiondumpDuration;
         }
         if(this.m_SuspendProcessingOfMessages)
         {
            this.synchronizeSessiondumpTimeWithTibiaTime(Tibia.s_GetTibiaTimer());
         }
         return Math.min(Math.max(Tibia.s_GetTibiaTimer() - this.m_StartTimestamp,this.currentSessiondumpTimestamp),this.nextSessiondumpPacketTimestamp);
      }
      
      public function get suspendProcessing() : Boolean
      {
         return this.m_SuspendProcessingOfMessages;
      }
      
      private function onSecondaryTimer(param1:TimerEvent) : void
      {
         var _loc2_:int = Tibia.s_GetTibiaTimer();
         if(_loc2_ > this.m_SecondaryTimestamp)
         {
            this.processPackets();
         }
         this.m_SecondaryTimestamp = _loc2_;
      }
      
      public function get stillLoading() : Boolean
      {
         return this.m_Sessiondump.stillLoading;
      }
      
      public function gotoKeyframe(param1:uint) : void
      {
         var _loc3_:uint = 0;
         if(this.m_Sessiondump.stillLoading)
         {
            throw new Error("Sessiondump.gotoKeyframe: Sessiondump has to be read completely for a goto to work");
         }
         this.m_SessiondumpReader.messageReader.finishMessage();
         this.m_SessiondumpReader.packetReader.finishPacket();
         this.m_SessiondumpReader.inputBuffer.position = param1;
         var _loc2_:Boolean = false;
         if(this.m_SessiondumpReader.packetReader.isPacketReady)
         {
            this.m_LastProcessedSessiondumpPacketTimestamp = this.m_SessiondumpReader.packetReader.packetTimestamp;
            this.m_CalculatedPlayspeedLastProcessedSessiondumpPacketTimestamp = this.m_LastProcessedSessiondumpPacketTimestamp;
            while(this.m_SessiondumpReader.packetReader.containsUnreadMessage)
            {
               _loc3_ = this.m_SessiondumpReader.messageReader.messageType;
               if(_loc3_ != Sessiondump.SKEYFRAMEBEGIN)
               {
                  this.m_SessiondumpReader.messageReader.finishMessage();
                  continue;
               }
               _loc2_ = true;
               break;
            }
         }
         if(_loc2_ == false)
         {
            throw new Error("Sessiondump.gotoKeyframe: Packet contains no KEYFRAMEBEGIN message");
         }
         this.m_Sessiondump.processNextKeyframe();
         Tibia.s_GetInstance().reset(false);
         this.synchronizeSessiondumpTimeWithTibiaTime(Tibia.s_GetTibiaTimer());
         this.playSpeedFactor = 1;
      }
      
      protected function processPackets() : void
      {
         var _loc1_:* = false;
         var _loc2_:int = 0;
         var _loc3_:uint = 0;
         var _loc4_:SessiondumpEvent = null;
         var _loc5_:Boolean = false;
         var _loc6_:SessiondumpEvent = null;
         var _loc7_:Event = null;
         if(this.m_Sessiondump.sessiondumpDone || this.m_SuspendProcessingOfMessages)
         {
            return;
         }
         this.measureRealPlaybackSpeed();
         if(this.m_SessiondumpReader != null && this.m_SessiondumpReader.isPacketReady)
         {
            _loc1_ = true;
            _loc2_ = Tibia.s_GetTibiaTimer();
            _loc3_ = _loc2_ - this.m_StartTimestamp;
            while(_loc1_)
            {
               if(this.m_SuspendProcessingOfMessages)
               {
                  _loc1_ = false;
               }
               else if(this.m_Sessiondump.state == Sessiondump.STATE_LOADED && this.m_SessiondumpReader.inputBuffer.bytesAvailable == 0)
               {
                  _loc1_ = false;
               }
               else if(this.m_SessiondumpReader.packetReader.isPacketReady == false)
               {
                  _loc1_ = false;
               }
               else if(this.isGameRunning && getTimer() - Tibia.s_FrameRealTimestamp > this.m_YieldMessageProcessingAfterMilliseconds)
               {
                  _loc1_ = false;
                  if(_loc3_ > this.m_SessiondumpReader.packetReader.packetTimestamp)
                  {
                     this.synchronizeSessiondumpTimeWithTibiaTime(_loc2_);
                  }
                  this.cleanupBeforeForcedRender();
               }
               else if(this.m_TargetSessiondumpLabel != null && this.m_TargetSessiondumpLabel.calculatedOffsetMilliseconds > this.m_LastProcessedSessiondumpPacketTimestamp)
               {
                  _loc1_ = true;
                  if(this.calculatedPlaySpeedFactor > 1)
                  {
                     this.playSpeedFactor = nextPowerOfTwo(this.calculatedPlaySpeedFactor);
                  }
               }
               else
               {
                  if(this.m_TargetSessiondumpLabel != null)
                  {
                     if(this.m_TargetSessiondumpLabel.calculatedOffsetMilliseconds <= this.m_LastProcessedSessiondumpPacketTimestamp)
                     {
                        this.playSpeedFactor = 1;
                        this.synchronizeSessiondumpTimeWithTibiaTime(_loc2_);
                     }
                     if(this.m_TargetSessiondumpLabel.offsetMilliseconds <= this.m_LastProcessedSessiondumpPacketTimestamp)
                     {
                        if(this.m_Sessiondump.hasEventListener(SessiondumpEvent.TARGET_REACHED))
                        {
                           _loc4_ = new SessiondumpEvent(SessiondumpEvent.TARGET_REACHED,false,false,0,false,this.m_TargetSessiondumpLabel.offsetMilliseconds);
                           this.m_Sessiondump.dispatchEvent(_loc4_);
                        }
                        this.m_TargetSessiondumpLabel = null;
                        this.playSpeedFactor = 1;
                        this.synchronizeSessiondumpTimeWithTibiaTime(_loc2_);
                        _loc3_ = 0;
                     }
                  }
                  _loc1_ = this.m_SessiondumpReader.packetReader.packetTimestamp < _loc3_;
               }
               if(_loc1_)
               {
                  _loc5_ = false;
                  if(this.m_Sessiondump.hasEventListener(SessiondumpEvent.PACKET_AVAILABLE))
                  {
                     _loc6_ = new SessiondumpEvent(SessiondumpEvent.PACKET_AVAILABLE,false,true,0,this.m_SessiondumpReader.packetReader.isClientPacket,this.m_SessiondumpReader.packetReader.packetTimestamp);
                     this.m_Sessiondump.dispatchEvent(_loc6_);
                     _loc5_ = _loc6_.isDefaultPrevented();
                  }
                  if(this.m_Sessiondump == null || _loc5_)
                  {
                     _loc1_ = false;
                     this.synchronizeSessiondumpTimeWithTibiaTime(_loc2_);
                  }
                  else
                  {
                     this.m_Sessiondump.readCommunicationData();
                     this.m_LastProcessedSessiondumpPacketTimestamp = this.m_SessiondumpReader.packetReader.packetTimestamp;
                  }
                  if(this.m_Sessiondump != null && this.m_Sessiondump.isConnected)
                  {
                     this.m_Sessiondump.communication.messageProcessingFinished(false);
                  }
                  else
                  {
                     _loc1_ = false;
                  }
               }
            }
         }
         if(this.m_Sessiondump != null && (!this.m_Sessiondump.isConnected || this.m_Sessiondump.sessiondumpDone))
         {
            this.synchronizeSessiondumpTimeWithTibiaTime(_loc2_);
            Tibia.s_TibiaTimerFactor = 0;
            _loc7_ = new Event(Event.COMPLETE);
            this.m_Sessiondump.dispatchEvent(_loc7_);
         }
      }
      
      public function pause() : void
      {
         this.playSpeedFactor = 0;
         this.synchronizeSessiondumpTimeWithTibiaTime(Tibia.s_GetTibiaTimer());
         this.m_TargetSessiondumpLabel = null;
      }
   }
}

class SessiondumpTargetInformation
{
    
   
   private var m_JumpOffsetMilliseconds:int = 0;
   
   private var m_OffsetMilliseconds:uint = 0;
   
   function SessiondumpTargetInformation(param1:uint, param2:int)
   {
      super();
      this.m_OffsetMilliseconds = param1;
      this.m_JumpOffsetMilliseconds = param2;
   }
   
   public function get calculatedOffsetMilliseconds() : uint
   {
      return Math.max(0,this.m_OffsetMilliseconds + this.m_JumpOffsetMilliseconds);
   }
   
   public function get offsetMilliseconds() : uint
   {
      return this.m_OffsetMilliseconds;
   }
}
