package tibia.sessiondump
{
   import flash.events.ErrorEvent;
   import flash.events.EventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   import flash.utils.ByteArray;
   import mx.resources.ResourceManager;
   import shared.utility.Colour;
   import shared.utility.StringHelper;
   import tibia.appearances.AppearanceInstance;
   import tibia.appearances.AppearanceStorage;
   import tibia.appearances.Marks;
   import tibia.appearances.ObjectInstance;
   import tibia.appearances.OutfitInstance;
   import tibia.creatures.Creature;
   import tibia.network.ConnectionEvent;
   import tibia.network.IConnectionData;
   import tibia.network.IMessageReader;
   import tibia.network.IMessageWriter;
   import tibia.network.IServerCommunication;
   import tibia.network.IServerConnection;
   import tibia.sessiondump.controller.SessiondumpControllerBase;
   
   public class Sessiondump extends EventDispatcher implements IServerConnection
   {
      
      protected static const CUPCONTAINER:int = 136;
      
      protected static const CQUITGAME:int = 20;
      
      protected static const CMARKETACCEPT:int = 248;
      
      protected static const CONNECTION_STATE_PENDING:int = 3;
      
      protected static const CGONORTHWEST:int = 109;
      
      protected static const PK_MAX_FLASHING_TIME:uint = 5000;
      
      protected static const PARTY_MAX_FLASHING_TIME:uint = 5000;
      
      protected static const PK_REVENGE:int = 6;
      
      protected static const SOUTFIT:int = 200;
      
      protected static const CADDBUDDY:int = 220;
      
      protected static const SKILL_FIGHTCLUB:int = 10;
      
      protected static const NPC_SPEECH_NONE:uint = 0;
      
      protected static const CSETTACTICS:int = 160;
      
      protected static const CPERFORMANCEMETRICS:int = 31;
      
      protected static const PARTY_MEMBER_SEXP_ACTIVE:int = 5;
      
      protected static const SSHOWMESSAGEDIALOG:int = 237;
      
      protected static const PARTY_LEADER_SEXP_ACTIVE:int = 6;
      
      protected static const RISKINESS_DANGEROUS:int = 1;
      
      protected static const PK_PARTYMODE:int = 2;
      
      protected static const ERR_COULD_NOT_CONNECT:int = 5;
      
      protected static const GUILD_NONE:int = 0;
      
      protected static const SSETTACTICS:int = 167;
      
      protected static const SPLAYERDATABASIC:int = 159;
      
      protected static const CGOSOUTH:int = 103;
      
      protected static const PACKETLENGTH_SIZE:int = 2;
      
      protected static const SMESSAGE:int = 180;
      
      protected static const CPING:int = 29;
      
      protected static const STATE_DRUNK:int = 3;
      
      protected static const SCREDITBALANCE:int = 223;
      
      protected static const SPREYDATA:int = 232;
      
      protected static const CGETQUESTLOG:int = 240;
      
      protected static const CENTERWORLD:int = 15;
      
      protected static const SKILL_EXPERIENCE:int = 0;
      
      protected static const PARTY_MEMBER_SEXP_INACTIVE_GUILTY:int = 7;
      
      protected static const CBUYOBJECT:int = 122;
      
      protected static const SPING:int = 29;
      
      protected static const CROTATENORTH:int = 111;
      
      protected static const SWAIT:int = 182;
      
      protected static const CATTACK:int = 161;
      
      protected static const SLOGINSUCCESS:int = 23;
      
      protected static const CCLOSENPCCHANNEL:int = 158;
      
      protected static const SKILL_MANA_LEECH_CHANCE:int = 23;
      
      protected static const CLOOKATCREATURE:int = 141;
      
      protected static const CJOINCHANNEL:int = 152;
      
      protected static const SKILL_FED:int = 15;
      
      protected static const PARTY_OTHER:int = 11;
      
      protected static const CROTATEEAST:int = 112;
      
      protected static const NUM_TRAPPERS:int = 8;
      
      protected static const SBUDDYDATA:int = 210;
      
      protected static const SKILL_MAGLEVEL:int = 2;
      
      protected static const CUSEONCREATURE:int = 132;
      
      protected static const TYPE_NPC:int = 2;
      
      protected static const BLESSING_FIRE_OF_SUNS:int = BLESSING_SPARK_OF_PHOENIX << 1;
      
      protected static const CBROWSEFIELD:int = 203;
      
      protected static const CPREYACTION:int = 235;
      
      protected static const SCREATUREPARTY:int = 145;
      
      protected static const SQUESTLOG:int = 240;
      
      protected static const ERR_INTERNAL:int = 0;
      
      protected static const NPC_SPEECH_QUEST:uint = 3;
      
      protected static const NPC_SPEECH_TRAVEL:uint = 5;
      
      protected static const CCANCEL:int = 190;
      
      protected static const CGUILDMESSAGE:int = 155;
      
      protected static const SPREYTIMELEFT:int = 231;
      
      public static const STATE_DEFAULT:int = 0;
      
      protected static const CAPPLYIMBUEMENT:int = 213;
      
      protected static const CREMOVEBUDDY:int = 221;
      
      protected static const CCLOSECONTAINER:int = 135;
      
      protected static const SKILL_NONE:int = -1;
      
      protected static const SFIELDDATA:int = 105;
      
      private static const KEYFRAME_STATE_PROCESS:uint = 1;
      
      protected static const GUILD_MEMBER:int = 4;
      
      protected static const SKILL_HITPOINTS_PERCENT:int = 3;
      
      protected static const SCLOSECONTAINER:int = 111;
      
      protected static const MAX_NAME_LENGTH:int = 29;
      
      protected static const SLEFTROW:int = 104;
      
      protected static const SFULLMAP:int = 100;
      
      protected static const CREQUESTRESOURCEBALANCE:int = 237;
      
      protected static const SUMMON_OTHERS:int = 2;
      
      protected static const SMISSILEEFFECT:int = 133;
      
      public static const MESSAGEDIALOG_IMBUEMENT_ERROR:int = 1;
      
      protected static const CGOWEST:int = 104;
      
      protected static const PROFESSION_NONE:int = 0;
      
      protected static const NPC_SPEECH_TRADER:uint = 2;
      
      protected static const STATE_PZ_ENTERED:int = 14;
      
      protected static const CPASSLEADERSHIP:int = 166;
      
      public static const STATE_ERROR:int = -1;
      
      protected static const SKILL_CARRYSTRENGTH:int = 7;
      
      protected static const SSPELLGROUPDELAY:int = 165;
      
      private static const BUNDLE:String = "Connection";
      
      protected static const SBOTTOMROW:int = 103;
      
      protected static const CGETOBJECTINFO:int = 243;
      
      protected static const STATE_DROWNING:int = 8;
      
      protected static const CSEEKINCONTAINER:int = 204;
      
      protected static const SQUESTLINE:int = 241;
      
      protected static const GUILD_WAR_NEUTRAL:int = 3;
      
      protected static const SUPDATINGSHOPBALANCE:int = 242;
      
      protected static const PARTY_LEADER:int = 1;
      
      protected static const CGOSOUTHWEST:int = 108;
      
      protected static const SLOGINERROR:int = 20;
      
      protected static const SCREATUREMARKS:int = 147;
      
      protected static const BLESSING_HEART_OF_THE_MOUNTAIN:int = BLESSING_EMBRACE_OF_TIBIA << 1;
      
      protected static const SPREYFREELISTREROLLAVAILABILITY:int = 230;
      
      protected static const CREJECTTRADE:int = 128;
      
      protected static const SREQUESTPURCHASEDATA:int = 225;
      
      protected static const CREVOKEINVITATION:int = 165;
      
      protected static const ERR_CONNECTION_LOST:int = 6;
      
      protected static const CLOGIN:int = 10;
      
      public static const MESSAGEDIALOG_PREY_ERROR:int = 21;
      
      protected static const SCREATURESKULL:int = 144;
      
      protected static const SUNJUSTIFIEDPOINTS:int = 183;
      
      protected static const PARTY_MEMBER_SEXP_INACTIVE_INNOCENT:int = 9;
      
      protected static const SPLAYERDATACURRENT:int = 160;
      
      protected static const STRAPPERS:int = 135;
      
      protected static const SOBJECTINFO:int = 244;
      
      protected static const PROFESSION_MASK_DRUID:int = 1 << PROFESSION_DRUID;
      
      protected static const CGETQUESTLINE:int = 241;
      
      protected static const SSNAPBACK:int = 181;
      
      protected static const CGETCHANNELS:int = 151;
      
      protected static const PARTY_MEMBER_SEXP_OFF:int = 3;
      
      public static const SCREATUREDATA:int = 3;
      
      protected static const CROTATESOUTH:int = 113;
      
      protected static const GUILD_WAR_ALLY:int = 1;
      
      protected static const STATE_SLOW:int = 5;
      
      protected static const CACCEPTTRADE:int = 127;
      
      protected static const PARTY_NONE:int = 0;
      
      protected static const SCHANNELS:int = 171;
      
      protected static const SOPENCHANNEL:int = 172;
      
      protected static const STOPFLOOR:int = 190;
      
      protected static const PROFESSION_SORCERER:int = 3;
      
      public static const MESSAGEDIALOG_PREY_MESSAGE:int = 20;
      
      protected static const CBUYPREMIUMOFFER:int = 252;
      
      protected static const CLOOKTRADE:int = 126;
      
      protected static const SPRIVATECHANNEL:int = 173;
      
      protected static const PROFESSION_MASK_NONE:int = 1 << PROFESSION_NONE;
      
      protected static const SBLESSINGS:int = 156;
      
      protected static const PROFESSION_MASK_KNIGHT:int = 1 << PROFESSION_KNIGHT;
      
      private static const HEADER_MAGIC_BYTES_SIZE:uint = 3;
      
      protected static const BLESSING_WISDOM_OF_SOLITUDE:int = BLESSING_TWIST_OF_FATE << 1;
      
      protected static const PARTY_LEADER_SEXP_INACTIVE_GUILTY:int = 8;
      
      protected static const SINGAMESHOPSUCCESS:int = 254;
      
      protected static const SSTOREBUTTONINDICATORS:int = 25;
      
      protected static const CPRIVATECHANNEL:int = 154;
      
      protected static const PAYLOADLENGTH_POS:int = PAYLOAD_POS;
      
      protected static const SLOGINWAIT:int = 22;
      
      public static const RESOURCETYPE_BANK_GOLD:int = 0;
      
      protected static const SCREATEONMAP:int = 106;
      
      protected static const SPREYREROLLPRICE:int = 233;
      
      public static const SKEYFRAMEEND:int = 2;
      
      protected static const NPC_SPEECH_QUESTTRADER:uint = 4;
      
      protected static const CTRADEOBJECT:int = 125;
      
      protected static const CGETTRANSACTIONHISTORY:int = 254;
      
      protected static const CLOOK:int = 140;
      
      protected static const ERR_INVALID_CHECKSUM:int = 2;
      
      public static const MESSAGEDIALOG_CLEARING_CHARM_SUCCESS:int = 10;
      
      protected static const BLESSING_EMBRACE_OF_TIBIA:int = BLESSING_SPIRITUAL_SHIELDING << 1;
      
      protected static const SCONTAINER:int = 110;
      
      public static const SKEYFRAMEBEGIN:int = 1;
      
      protected static const SNPCOFFER:int = 122;
      
      protected static const SKILL_MANA_LEECH_AMOUNT:int = 24;
      
      protected static const CMARKETCANCEL:int = 247;
      
      protected static const SWORLDENTERED:int = 15;
      
      protected static const HEADER_POS:int = 0;
      
      protected static const SKILL_HITPOINTS:int = 4;
      
      protected static const STRANSACTIONHISTORY:int = 253;
      
      protected static const SKILL_OFFLINETRAINING:int = 18;
      
      protected static const SPREMIUMSHOPOFFERS:int = 252;
      
      protected static const STATE_MANA_SHIELD:int = 4;
      
      protected static const CMOUNT:int = 212;
      
      protected static const CCLOSENPCTRADE:int = 124;
      
      protected static const SMARKETBROWSE:int = 249;
      
      protected static const CSELLOBJECT:int = 123;
      
      private static const KEYFRAME_STATE_NONE:uint = 0;
      
      protected static const CMARKETBROWSE:int = 245;
      
      protected static const STATE_CURSED:int = 11;
      
      protected static const STATE_FREEZING:int = 9;
      
      protected static const PARTY_LEADER_SEXP_INACTIVE_INNOCENT:int = 10;
      
      protected static const SMARKETLEAVE:int = 247;
      
      protected static const BLESSING_ADVENTURER:int = 1;
      
      protected static const SCOUNTEROFFER:int = 126;
      
      protected static const CFOLLOW:int = 162;
      
      protected static const STATE_POISONED:int = 0;
      
      protected static const SBUDDYGROUPDATA:int = 212;
      
      protected static const SKILL_LIFE_LEECH_CHANCE:int = 21;
      
      protected static const CEXCLUDEFROMCHANNEL:int = 172;
      
      protected static const STATE_BURNING:int = 1;
      
      public static const MESSAGEDIALOG_IMBUING_STATION_NOT_FOUND:int = 3;
      
      protected static const SMARKETENTER:int = 246;
      
      protected static const SCLIENTCHECK:int = 99;
      
      protected static const CONNECTION_STATE_CONNECTING_STAGE1:int = 1;
      
      protected static const CBLESSINGSDIALOG:int = 207;
      
      protected static const CONNECTION_STATE_CONNECTING_STAGE2:int = 2;
      
      protected static const GUILD_WAR_ENEMY:int = 2;
      
      protected static const SCREATURESPEED:int = 143;
      
      protected static const CREQUESTSHOPOFFERS:int = 251;
      
      protected static const CANSWERMODALDIALOG:int = 249;
      
      protected static const PROFESSION_MASK_ANY:int = PROFESSION_MASK_DRUID | PROFESSION_MASK_KNIGHT | PROFESSION_MASK_PALADIN | PROFESSION_MASK_SORCERER;
      
      protected static const CCLOSEDIMBUINGDIALOG:int = 215;
      
      protected static const NPC_SPEECH_NORMAL:uint = 1;
      
      protected static const STATE_FIGHTING:int = 7;
      
      protected static const SKILL_FIGHTFIST:int = 13;
      
      protected static const SSPELLDELAY:int = 164;
      
      protected static const BLESSING_SPIRITUAL_SHIELDING:int = BLESSING_FIRE_OF_SUNS << 1;
      
      protected static const CEDITBUDDY:int = 222;
      
      private static const HEADER_HEADER_LENGTH_SIZE:uint = 2;
      
      protected static const SDELETEONMAP:int = 108;
      
      protected static const CEDITGUILDMESSAGE:int = 156;
      
      protected static const CROTATEWEST:int = 114;
      
      public static const PROTOCOL_VERSION:int = 1130;
      
      protected static const SCREATUREOUTFIT:int = 142;
      
      protected static const SEDITGUILDMESSAGE:int = 174;
      
      protected static const BLESSING_SPARK_OF_PHOENIX:int = BLESSING_WISDOM_OF_SOLITUDE << 1;
      
      protected static const SAMBIENTE:int = 130;
      
      protected static const ERR_INVALID_SIZE:int = 1;
      
      protected static const NUM_PVP_HELPERS_FOR_RISKINESS_DANGEROUS:uint = 5;
      
      protected static const STATE_PZ_BLOCK:int = 13;
      
      protected static const SLOGINCHALLENGE:int = 31;
      
      protected static const CLEAVECHANNEL:int = 153;
      
      protected static const PARTY_MEMBER:int = 2;
      
      protected static const SPLAYERSKILLS:int = 161;
      
      protected static const CTHANKYOU:int = 231;
      
      private static const ERROR_INVALID_SESSIONDUMP:uint = 2;
      
      protected static const SRESOURCEBALANCE:int = 238;
      
      protected static const SCREATUREUNPASS:int = 146;
      
      protected static const RISKINESS_NONE:int = 0;
      
      protected static const SKILL_STAMINA:int = 17;
      
      protected static const SSHOWMODALDIALOG:int = 250;
      
      protected static const CONNECTION_STATE_DISCONNECTED:int = 0;
      
      protected static const SKILL_FIGHTSHIELD:int = 8;
      
      protected static const STATE_NONE:int = -1;
      
      protected static const CGONORTHEAST:int = 106;
      
      protected static const NUM_CREATURES:int = 1300;
      
      protected static const SDELETEINCONTAINER:int = 114;
      
      protected static const PK_EXCPLAYERKILLER:int = 5;
      
      public static const RESOURCETYPE_INVENTORY_GOLD:int = 1;
      
      protected static const SKILL_FISHING:int = 14;
      
      protected static const SCREATEINCONTAINER:int = 112;
      
      protected static const SKILL_FIGHTDISTANCE:int = 9;
      
      protected static const PK_PLAYERKILLER:int = 4;
      
      protected static const CERRORFILEENTRY:int = 232;
      
      protected static const HEADER_SIZE:int = PACKETLENGTH_SIZE + SEQUENCE_NUMBER_SIZE;
      
      protected static const SCREATUREHEALTH:int = 140;
      
      protected static const STOPROW:int = 101;
      
      protected static const SBOTTOMFLOOR:int = 191;
      
      protected static const CTURNOBJECT:int = 133;
      
      protected static const COPENPREMIUMSHOP:int = 250;
      
      protected static const CINSPECTPLAYER:int = 206;
      
      private static const ERROR_SESSIONDUMP_CONNECTION_ERROR:uint = 1;
      
      protected static const CUSEOBJECT:int = 130;
      
      protected static const ERR_INVALID_MESSAGE:int = 3;
      
      protected static const CINVITETOCHANNEL:int = 171;
      
      protected static const CLOOKNPCTRADE:int = 121;
      
      protected static const BLESSING_BLOOD_OF_THE_MOUNTAIN:int = BLESSING_HEART_OF_THE_MOUNTAIN << 1;
      
      protected static const STATE_BLEEDING:int = 15;
      
      protected static const ERR_INVALID_STATE:int = 4;
      
      protected static const CUSETWOOBJECTS:int = 131;
      
      protected static const SPREMIUMTRIGGER:int = 158;
      
      public static const STATE_DONE:int = 3;
      
      protected static const CINVITETOPARTY:int = 163;
      
      protected static const STATE_DAZZLED:int = 10;
      
      protected static const SCREATURELIGHT:int = 141;
      
      protected static const CPINGBACK:int = 30;
      
      protected static const SPINGBACK:int = 30;
      
      protected static const STUTORIALHINT:int = 220;
      
      protected static const PK_ATTACKER:int = 1;
      
      protected static const STATE_ELECTRIFIED:int = 2;
      
      protected static const SKILL_FIGHTSWORD:int = 11;
      
      protected static const SPLAYERGOODS:int = 123;
      
      protected static const CSTOP:int = 105;
      
      protected static const SPLAYERINVENTORY:int = 245;
      
      protected static const CINSPECTOBJECT:int = 205;
      
      protected static const SINSPECTIONSTATE:int = 119;
      
      protected static const CMOVEOBJECT:int = 120;
      
      protected static const CRULEVIOLATIONREPORT:int = 242;
      
      protected static const SKILL_LIFE_LEECH_AMOUNT:int = 22;
      
      protected static const CJOINAGGRESSION:int = 142;
      
      protected static const SMOVECREATURE:int = 109;
      
      protected static const SSWITCHPRESET:int = 157;
      
      protected static const CGOEAST:int = 102;
      
      public static const MESSAGEDIALOG_CLEARING_CHARM_ERROR:int = 11;
      
      protected static const CEDITLIST:int = 138;
      
      protected static const CTOGGLEWRAPSTATE:int = 139;
      
      protected static const CJOINPARTY:int = 164;
      
      protected static const PK_NONE:int = 0;
      
      protected static const SCLOSETRADE:int = 127;
      
      protected static const CONNECTION_STATE_GAME:int = 4;
      
      protected static const SMULTIUSEDELAY:int = 166;
      
      private static const KEYFRAME_STATE_SKIP:uint = 2;
      
      protected static const CSTOREEVENT:int = 233;
      
      protected static const SEDITLIST:int = 151;
      
      protected static const SSETINVENTORY:int = 120;
      
      protected static const SUMMON_OWN:int = 1;
      
      protected static const CGOPATH:int = 100;
      
      protected static const CLEAVEPARTY:int = 167;
      
      protected static const SCHANGEONMAP:int = 107;
      
      protected static const CGOSOUTHEAST:int = 107;
      
      protected static const SINSPECTIONLIST:int = 118;
      
      protected static const SKILL_EXPERIENCE_GAIN:int = -2;
      
      protected static const CEQUIPOBJECT:int = 119;
      
      protected static const SCREATUREPVPHELPERS:int = 148;
      
      protected static const PROFESSION_MASK_SORCERER:int = 1 << PROFESSION_SORCERER;
      
      protected static const COPENCHANNEL:int = 170;
      
      protected static const SDEAD:int = 40;
      
      protected static const SCHANGEINCONTAINER:int = 113;
      
      protected static const SIMBUINGDIALOGREFRESH:int = 235;
      
      public static const MESSAGEDIALOG_IMBUEMENT_ROLL_FAILED:int = 2;
      
      protected static const SDELETEINVENTORY:int = 121;
      
      protected static const CTRANSFERCURRENCY:int = 239;
      
      protected static const PROFESSION_PALADIN:int = 2;
      
      protected static const SINGAMESHOPERROR:int = 224;
      
      protected static const SCHANNELEVENT:int = 243;
      
      protected static const SKILL_CRITICAL_HIT_CHANCE:int = 19;
      
      protected static const SPVPSITUATIONS:int = 184;
      
      protected static const SKILL_CRITICAL_HIT_DAMAGE:int = 20;
      
      protected static const SLOGINADVICE:int = 21;
      
      protected static const PROFESSION_KNIGHT:int = 1;
      
      protected static const SKILL_FIGHTAXE:int = 12;
      
      public static const STATE_LOADING:int = 1;
      
      protected static const CAPPLYCLEARINGCHARM:int = 214;
      
      protected static const CGONORTH:int = 101;
      
      protected static const PARTY_LEADER_SEXP_OFF:int = 4;
      
      protected static const SMARKETDETAIL:int = 248;
      
      protected static const SKILL_SOULPOINTS:int = 16;
      
      public static const MESSAGEDIALOG_IMBUEMENT_SUCCESS:int = 0;
      
      protected static const BLESSING_TWIST_OF_FATE:int = BLESSING_ADVENTURER << 1;
      
      protected static const CTALK:int = 150;
      
      protected static const PAYLOADDATA_POSITION:int = PAYLOADLENGTH_POS + PAYLOADLENGTH_SIZE;
      
      protected static const STATE_FAST:int = 6;
      
      protected static const SPREMIUMSHOP:int = 251;
      
      protected static const SEQUENCE_NUMBER_POS:int = PACKETLENGTH_POS + PACKETLENGTH_SIZE;
      
      protected static const STALK:int = 170;
      
      protected static const CEDITTEXT:int = 137;
      
      protected static const GUILD_OTHER:int = 5;
      
      protected static const SCLOSENPCTRADE:int = 124;
      
      protected static const SPENDINGSTATEENTERED:int = 10;
      
      protected static const PAYLOADLENGTH_SIZE:int = 2;
      
      protected static const TYPE_PLAYER:int = 0;
      
      protected static const SRIGHTROW:int = 102;
      
      protected static const SKILL_MANA:int = 5;
      
      protected static const SEDITTEXT:int = 150;
      
      protected static const SOPENOWNCHANNEL:int = 178;
      
      protected static const SGRAPHICALEFFECT:int = 131;
      
      protected static const CBUGREPORT:int = 230;
      
      protected static const BLESSING_NONE:int = 0;
      
      protected static const PROFESSION_MASK_PALADIN:int = 1 << PROFESSION_PALADIN;
      
      protected static const SCLOSEIMBUINGDIALOG:int = 236;
      
      protected static const TYPE_MONSTER:int = 1;
      
      protected static const CMARKETLEAVE:int = 244;
      
      protected static const SEQUENCE_NUMBER_SIZE:int = 4;
      
      protected static const SBLESSINGSDIALOG:int = 155;
      
      protected static const COPENTRANSACTIONHISTORY:int = 253;
      
      protected static const CSHAREEXPERIENCE:int = 168;
      
      protected static const SCLEARTARGET:int = 163;
      
      protected static const SCREATURETYPE:int = 149;
      
      protected static const CGETOUTFIT:int = 210;
      
      protected static const STATE_STRENGTHENED:int = 12;
      
      public static const STATE_LOADED:int = 2;
      
      protected static const PK_AGGRESSOR:int = 3;
      
      protected static const STATE_HUNGRY:int = 31;
      
      protected static const SKILL_LEVEL:int = 1;
      
      protected static const SCLOSECHANNEL:int = 179;
      
      protected static const PROFESSION_DRUID:int = 4;
      
      protected static const CSETOUTFIT:int = 211;
      
      protected static const PACKETLENGTH_POS:int = HEADER_POS;
      
      protected static const SBUDDYSTATUSCHANGE:int = 211;
      
      protected static const SUMMON_NONE:int = 0;
      
      protected static const SAUTOMAPFLAG:int = 221;
      
      protected static const TYPE_PLAYERSUMMON:int = 3;
      
      protected static const SOWNOFFER:int = 125;
      
      protected static const PAYLOAD_POS:int = HEADER_POS + HEADER_SIZE;
      
      public static const RESOURCETYPE_PREY_BONUS_REROLLS:int = 10;
      
      protected static const SKILL_GOSTRENGTH:int = 6;
      
      protected static const SSETSTOREDEEPLINK:int = 168;
      
      protected static const CMARKETCREATE:int = 246;
      
      protected static const SPLAYERSTATE:int = 162;
       
      
      private var m_ProcessNextKeyframe:Boolean = false;
      
      private var m_State:uint = 0;
      
      private var m_SessiondumpLoader:SessiondumpLoader = null;
      
      private var m_KeyframeState:uint = 0;
      
      private var m_SessiondumpController:SessiondumpControllerBase = null;
      
      private var m_ConnectionData:SessiondumpConnectionData = null;
      
      private var m_ConnectionState:int = 0;
      
      private var m_Communication:IServerCommunication = null;
      
      private var m_MessageWriter:DummyMessageWriter = null;
      
      private var m_InputStream:ByteArray = null;
      
      private var m_SessiondumpReader:SessiondumpReader = null;
      
      public function Sessiondump(param1:SessiondumpControllerBase)
      {
         super();
         this.m_MessageWriter = new DummyMessageWriter();
         this.m_SessiondumpController = param1;
      }
      
      protected function readSLOGINWAIT(param1:ByteArray) : void
      {
         var _loc2_:String = StringHelper.s_ReadLongStringFromByteArray(param1);
         var _loc3_:int = param1.readUnsignedByte() * 1000;
         this.disconnect();
         var _loc4_:ConnectionEvent = new ConnectionEvent(ConnectionEvent.LOGINWAIT);
         _loc4_.message = _loc2_;
         _loc4_.data = _loc3_;
         dispatchEvent(_loc4_);
      }
      
      public function get latency() : uint
      {
         return 0;
      }
      
      public function get isConnected() : Boolean
      {
         return this.m_ConnectionState == CONNECTION_STATE_CONNECTING_STAGE1 || this.m_ConnectionState == CONNECTION_STATE_CONNECTING_STAGE2 || this.m_ConnectionState == CONNECTION_STATE_PENDING || this.m_ConnectionState == CONNECTION_STATE_GAME;
      }
      
      private function handleConnectionError(param1:int, param2:int = 0, param3:Object = null) : void
      {
         this.disconnect();
         var _loc4_:* = null;
         switch(param1)
         {
            case ERROR_INVALID_SESSIONDUMP:
               _loc4_ = "Invalid sessiondump (Code: " + param1 + ")";
               break;
            case ERROR_SESSIONDUMP_CONNECTION_ERROR:
               _loc4_ = "Error while loading sessiondump (Code: " + param1 + "." + param2 + ")";
               break;
            case ERR_INTERNAL:
            default:
               _loc4_ = ResourceManager.getInstance().getString(BUNDLE,"MSG_INTERNAL_ERROR",[param1,param2]);
         }
         var _loc5_:ConnectionEvent = new ConnectionEvent(ConnectionEvent.ERROR);
         _loc5_.message = _loc4_;
         _loc5_.data = null;
         dispatchEvent(_loc5_);
      }
      
      public function processNextKeyframe() : void
      {
         this.m_KeyframeState = KEYFRAME_STATE_PROCESS;
      }
      
      public function get state() : uint
      {
         return this.m_State;
      }
      
      public function get isPending() : Boolean
      {
         return this.m_ConnectionState == CONNECTION_STATE_PENDING;
      }
      
      protected function readMountOutfit(param1:ByteArray, param2:AppearanceInstance) : AppearanceInstance
      {
         var _loc3_:AppearanceStorage = Tibia.s_GetAppearanceStorage();
         if(param1 == null || param1.bytesAvailable < 2)
         {
            throw new Error("Sessiondump.readMountOutfit: Not enough data.",2147483619);
         }
         var _loc4_:int = param1.readUnsignedShort();
         if(param2 is OutfitInstance && param2.ID == _loc4_)
         {
            return param2;
         }
         if(_loc4_ != 0)
         {
            return _loc3_.createOutfitInstance(_loc4_,0,0,0,0,0);
         }
         return null;
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
            if(param2)
            {
               _loc3_ = new ConnectionEvent(ConnectionEvent.CONNECTING);
               dispatchEvent(_loc3_);
            }
         }
         else if(this.m_ConnectionState == CONNECTION_STATE_CONNECTING_STAGE2)
         {
         }
      }
      
      public function disconnect(param1:Boolean = true) : void
      {
         this.m_State = STATE_DEFAULT;
         if(this.m_SessiondumpReader.packetReader != null)
         {
            this.m_SessiondumpReader.packetReader.finishPacket();
            this.m_InputStream.position = this.m_InputStream.length;
         }
         this.setConnectionState(CONNECTION_STATE_DISCONNECTED,param1);
         this.m_SessiondumpController.disconnect();
      }
      
      public function get messageReader() : IMessageReader
      {
         return this.m_SessiondumpReader != null?this.m_SessiondumpReader.messageReader:null;
      }
      
      protected function readSKEYFRAMEBEGIN(param1:ByteArray) : void
      {
         if(this.m_KeyframeState == KEYFRAME_STATE_NONE)
         {
            this.m_KeyframeState = KEYFRAME_STATE_SKIP;
         }
         (Tibia.s_GetCreatureStorage() as SessiondumpCreatureStorage).resetKeyframeCreatures();
      }
      
      public function readCommunicationData() : void
      {
         var Type:uint = 0;
         var PacketAvailableEvent:SessiondumpEvent = null;
         var MessageProcessedEvent:SessiondumpEvent = null;
         while(this.m_SessiondumpReader.packetReader.containsUnreadMessage)
         {
            Type = this.messageReader.messageType;
            if(hasEventListener(SessiondumpEvent.MESSAGE_AVAILABLE))
            {
               PacketAvailableEvent = new SessiondumpEvent(SessiondumpEvent.MESSAGE_AVAILABLE,false,true,Type,this.m_SessiondumpReader.packetReader.isClientPacket,this.m_SessiondumpReader.packetReader.packetTimestamp);
               dispatchEvent(PacketAvailableEvent);
               if(PacketAvailableEvent.isDefaultPrevented())
               {
                  return;
               }
            }
            if(!this.isConnected)
            {
               return;
            }
            if(this.m_KeyframeState == KEYFRAME_STATE_SKIP && Type != SKEYFRAMEEND && Type != SCREATUREDATA || this.m_SessiondumpReader.packetReader.isClientPacket)
            {
               this.messageReader.finishMessage();
            }
            else
            {
               try
               {
                  switch(Type)
                  {
                     case SKEYFRAMEBEGIN:
                        this.readSKEYFRAMEBEGIN(this.m_InputStream);
                        this.messageReader.finishMessage();
                        break;
                     case SKEYFRAMEEND:
                        this.readSKEYFRAMEEND(this.m_InputStream);
                        this.messageReader.finishMessage();
                        break;
                     case SCREATUREDATA:
                        this.readSCREATUREDATA(this.m_InputStream);
                        this.messageReader.finishMessage();
                        break;
                     case SPING:
                        this.readSPING(this.m_InputStream);
                        this.messageReader.finishMessage();
                        break;
                     case SPINGBACK:
                        this.readSPINGBACK(this.m_InputStream);
                        this.messageReader.finishMessage();
                        break;
                     case SLOGINCHALLENGE:
                        this.readSLOGINCHALLENGE(this.m_InputStream);
                        this.messageReader.finishMessage();
                        break;
                     case SLOGINERROR:
                        this.readSLOGINERROR(this.m_InputStream);
                        this.messageReader.finishMessage();
                        break;
                     case SLOGINADVICE:
                        this.readSLOGINADVICE(this.m_InputStream);
                        this.messageReader.finishMessage();
                        break;
                     case SLOGINWAIT:
                        this.readSLOGINWAIT(this.m_InputStream);
                        this.messageReader.finishMessage();
                        break;
                     case SSHOWMODALDIALOG:
                        this.messageReader.finishMessage();
                        break;
                     case SOUTFIT:
                        this.messageReader.finishMessage();
                        break;
                     case SQUESTLOG:
                        this.messageReader.finishMessage();
                        break;
                     case SCHANNELS:
                        this.messageReader.finishMessage();
                        break;
                     case SEDITTEXT:
                        this.messageReader.finishMessage();
                        break;
                     case SEDITLIST:
                        this.messageReader.finishMessage();
                        break;
                     case STUTORIALHINT:
                        this.messageReader.finishMessage();
                        break;
                     case SPREMIUMSHOP:
                        this.messageReader.finishMessage();
                        break;
                     case SPREMIUMSHOPOFFERS:
                        this.messageReader.finishMessage();
                        break;
                     default:
                        if(this.communication != null)
                        {
                           this.communication.readMessage(this.messageReader);
                        }
                  }
                  if(this.messageReader.messageWasRead && hasEventListener(SessiondumpEvent.MESSAGE_PROCESSED))
                  {
                     MessageProcessedEvent = new SessiondumpEvent(SessiondumpEvent.MESSAGE_PROCESSED,false,false,Type,this.m_SessiondumpReader.packetReader.isClientPacket,this.m_SessiondumpReader.packetReader.packetTimestamp);
                     dispatchEvent(MessageProcessedEvent);
                  }
                  if(this.isConnected && this.messageReader.messageWasRead == false)
                  {
                     this.handleConnectionError(ERR_INVALID_MESSAGE,0,"Sessiondump.readSocketData: Invalid message type " + Type + ".");
                  }
               }
               catch(_Error:Error)
               {
                  handleReadError(Type,_Error);
                  return;
               }
            }
         }
         this.m_SessiondumpReader.packetReader.finishPacket();
      }
      
      public function set communication(param1:IServerCommunication) : void
      {
         this.m_Communication = param1;
      }
      
      public function get connectionData() : IConnectionData
      {
         return this.m_ConnectionData;
      }
      
      public function get sessiondumpDone() : Boolean
      {
         return this.m_SessiondumpLoader.isLoadingFinished && this.m_InputStream.position == this.m_InputStream.length;
      }
      
      public function get sessiondumpLoader() : SessiondumpLoader
      {
         return this.m_SessiondumpLoader;
      }
      
      public function get sessiondumpDuration() : uint
      {
         return this.m_ConnectionData != null?uint(this.m_ConnectionData.durationMilliseconds):uint(0);
      }
      
      public function get sessiondumpController() : SessiondumpControllerBase
      {
         return this.m_SessiondumpController;
      }
      
      private function handleReadError(param1:int, param2:Error) : void
      {
         var _loc3_:int = param2 != null?int(param2.errorID):-1;
         this.handleConnectionError(256 + param1,_loc3_,param2);
      }
      
      public function get connectionState() : uint
      {
         return this.m_ConnectionState;
      }
      
      public function get communication() : IServerCommunication
      {
         return this.m_Communication;
      }
      
      public function reconnect() : void
      {
         this.disconnect(false);
         this.connect(this.m_ConnectionData);
      }
      
      protected function readCreatureOutfit(param1:ByteArray, param2:AppearanceInstance) : AppearanceInstance
      {
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc3_:AppearanceStorage = Tibia.s_GetAppearanceStorage();
         if(param1 == null || param1.bytesAvailable < 4)
         {
            throw new Error("Sessiondump.readCreatureOutfit: Not enough data.",2147483620);
         }
         var _loc4_:int = param1.readUnsignedShort();
         if(_loc4_ != 0)
         {
            _loc5_ = param1.readUnsignedByte();
            _loc6_ = param1.readUnsignedByte();
            _loc7_ = param1.readUnsignedByte();
            _loc8_ = param1.readUnsignedByte();
            _loc9_ = param1.readUnsignedByte();
            if(param2 is OutfitInstance && param2.ID == _loc4_)
            {
               OutfitInstance(param2).updateProperties(_loc5_,_loc6_,_loc7_,_loc8_,_loc9_);
               return param2;
            }
            return _loc3_.createOutfitInstance(_loc4_,_loc5_,_loc6_,_loc7_,_loc8_,_loc9_);
         }
         _loc10_ = param1.readUnsignedShort();
         if(param2 is ObjectInstance && param2.ID == _loc10_)
         {
            return param2;
         }
         if(_loc10_ == 0)
         {
            return _loc3_.createOutfitInstance(OutfitInstance.INVISIBLE_OUTFIT_ID,0,0,0,0,0);
         }
         return _loc3_.createObjectInstance(_loc10_,0);
      }
      
      protected function readSLOGINCHALLENGE(param1:ByteArray) : void
      {
         var _loc2_:int = param1.readUnsignedInt();
         var _loc3_:int = param1.readUnsignedByte();
         this.setConnectionState(CONNECTION_STATE_CONNECTING_STAGE2,false);
      }
      
      public function get isGameRunning() : Boolean
      {
         return this.m_ConnectionState == CONNECTION_STATE_GAME;
      }
      
      private function onLoaderError(param1:ErrorEvent) : void
      {
         this.handleConnectionError(ERROR_SESSIONDUMP_CONNECTION_ERROR,param1.errorID,param1.text);
      }
      
      public function load() : void
      {
         if(this.m_State == STATE_DEFAULT || this.sessiondumpDone)
         {
            if(this.m_SessiondumpLoader != null)
            {
               this.m_SessiondumpLoader.removeEventListener(IOErrorEvent.IO_ERROR,this.onLoaderError);
               this.m_SessiondumpLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onLoaderError);
            }
            this.m_SessiondumpLoader = new SessiondumpLoader();
            this.m_SessiondumpLoader.addEventListener(IOErrorEvent.IO_ERROR,this.onLoaderError);
            this.m_SessiondumpLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onLoaderError);
            this.m_SessiondumpLoader.load(this.m_ConnectionData.url);
            this.m_InputStream = this.m_SessiondumpLoader.inputStream;
            this.m_SessiondumpReader = new SessiondumpReader(this.m_InputStream);
         }
      }
      
      public function get messageWriter() : IMessageWriter
      {
         return this.m_MessageWriter;
      }
      
      protected function readSLOGINADVICE(param1:ByteArray) : void
      {
         var _loc2_:String = StringHelper.s_ReadLongStringFromByteArray(param1);
         var _loc3_:ConnectionEvent = new ConnectionEvent(ConnectionEvent.LOGINADVICE);
         _loc3_.message = _loc2_;
         dispatchEvent(_loc3_);
      }
      
      protected function readSCREATUREDATA(param1:ByteArray) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = -1;
         var _loc5_:Creature = null;
         var _loc6_:Creature = Tibia.s_GetPlayer();
         var _loc7_:SessiondumpCreatureStorage = Tibia.s_GetCreatureStorage() as SessiondumpCreatureStorage;
         _loc3_ = param1.readUnsignedInt();
         _loc2_ = param1.readUnsignedInt();
         _loc4_ = param1.readUnsignedByte();
         if(_loc2_ == _loc6_.ID)
         {
            _loc5_ = _loc6_;
         }
         else
         {
            _loc5_ = new Creature(_loc2_);
            _loc7_.addKeyframeCreature(_loc5_);
         }
         if(_loc5_ != null)
         {
            _loc5_.type = _loc4_;
            _loc5_.name = StringHelper.s_ReadLongStringFromByteArray(param1,Creature.MAX_NAME_LENGHT);
            _loc5_.setSkillValue(SKILL_HITPOINTS_PERCENT,param1.readUnsignedByte());
            _loc5_.direction = param1.readUnsignedByte();
            _loc5_.outfit = this.readCreatureOutfit(param1,_loc5_.outfit);
            _loc5_.mountOutfit = this.readMountOutfit(param1,_loc5_.mountOutfit);
            _loc5_.brightness = param1.readUnsignedByte();
            _loc5_.lightColour = Colour.s_FromEightBit(param1.readUnsignedByte());
            _loc5_.setSkillValue(SKILL_GOSTRENGTH,param1.readUnsignedShort());
            _loc5_.setPKFlag(param1.readUnsignedByte());
            _loc5_.setPartyFlag(param1.readUnsignedByte());
            _loc5_.guildFlag = param1.readUnsignedByte();
            _loc5_.type = param1.readUnsignedByte();
            _loc5_.speechCategory = param1.readUnsignedByte();
            _loc5_.marks.setMark(Marks.MARK_TYPE_PERMANENT,param1.readUnsignedByte());
            _loc5_.numberOfPVPHelpers = param1.readUnsignedShort();
            _loc5_.isUnpassable = param1.readUnsignedByte() != 0;
            return;
         }
         throw new Error("Sessiondump.readSCREATUREDATA: Failed to append creature.",2147483623);
      }
      
      protected function readSPINGBACK(param1:ByteArray) : void
      {
      }
      
      protected function readSPING(param1:ByteArray) : void
      {
      }
      
      public function get inputStream() : ByteArray
      {
         return this.m_InputStream;
      }
      
      public function get stillLoading() : Boolean
      {
         return !this.m_SessiondumpLoader.isLoadingFinished;
      }
      
      protected function readSKEYFRAMEEND(param1:ByteArray) : void
      {
         this.m_KeyframeState = KEYFRAME_STATE_NONE;
      }
      
      public function connect(param1:IConnectionData) : void
      {
         if(!(param1 is SessiondumpConnectionData))
         {
            throw new Error("Sessiondump.connect: Invalid connection data.",2147483639);
         }
         this.m_ConnectionData = param1 as SessiondumpConnectionData;
         if(this.m_ConnectionData.url == null || this.m_ConnectionData.url.length < 1)
         {
            throw new Error("Connection.connect: Invalid url.",2147483638);
         }
         this.m_State = STATE_DEFAULT;
         this.m_SessiondumpReader = null;
         this.load();
         this.m_SessiondumpController.connect(this,this.m_SessiondumpReader);
         this.setConnectionState(CONNECTION_STATE_CONNECTING_STAGE1,true);
      }
      
      protected function readSLOGINERROR(param1:ByteArray) : void
      {
         var _loc2_:String = StringHelper.s_ReadLongStringFromByteArray(param1);
         this.disconnect();
         var _loc3_:ConnectionEvent = new ConnectionEvent(ConnectionEvent.LOGINERROR);
         _loc3_.message = _loc2_;
         dispatchEvent(_loc3_);
      }
   }
}
