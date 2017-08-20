package tibia.network
{
   import flash.system.Capabilities;
   import flash.utils.ByteArray;
   import mx.collections.ArrayCollection;
   import mx.collections.IList;
   import mx.resources.ResourceManager;
   import shared.utility.AccumulatingCounter;
   import shared.utility.BrowserHelper;
   import shared.utility.Colour;
   import shared.utility.StringHelper;
   import shared.utility.Vector3D;
   import tibia.appearances.AppearanceAnimator;
   import tibia.appearances.AppearanceInstance;
   import tibia.appearances.AppearanceStorage;
   import tibia.appearances.AppearanceType;
   import tibia.appearances.AppearanceTypeRef;
   import tibia.appearances.EffectInstance;
   import tibia.appearances.FrameGroup;
   import tibia.appearances.Marks;
   import tibia.appearances.MissileInstance;
   import tibia.appearances.ObjectInstance;
   import tibia.appearances.OutfitInstance;
   import tibia.chat.Channel;
   import tibia.chat.ChannelSelectionWidget;
   import tibia.chat.ChatStorage;
   import tibia.chat.MessageMode;
   import tibia.chat.MessageStorage;
   import tibia.chat.NameFilterSet;
   import tibia.chat.log;
   import tibia.container.BodyContainerView;
   import tibia.container.ContainerStorage;
   import tibia.container.ContainerView;
   import tibia.container.InventoryTypeInfo;
   import tibia.creatures.BuddySet;
   import tibia.creatures.Creature;
   import tibia.creatures.CreatureStorage;
   import tibia.creatures.Player;
   import tibia.creatures.SelectOutfitWidget;
   import tibia.creatures.UnjustPointsInfo;
   import tibia.game.BugReportTypo;
   import tibia.game.BugReportWidget;
   import tibia.game.EditListWidget;
   import tibia.game.EditTextWidget;
   import tibia.game.PopUpBase;
   import tibia.game.ServerModalDialog;
   import tibia.game.SimpleEditTextWidget;
   import tibia.game.serverModalDialogClasses.Choice;
   import tibia.help.TutorialHint;
   import tibia.imbuing.AstralSource;
   import tibia.imbuing.ExistingImbuement;
   import tibia.imbuing.ImbuementData;
   import tibia.imbuing.ImbuingManager;
   import tibia.ingameshop.IngameShopCategory;
   import tibia.ingameshop.IngameShopHistoryEntry;
   import tibia.ingameshop.IngameShopManager;
   import tibia.ingameshop.IngameShopOffer;
   import tibia.ingameshop.IngameShopProduct;
   import tibia.ingameshop.IngameShopWidget;
   import tibia.magic.SpellStorage;
   import tibia.market.MarketWidget;
   import tibia.market.Offer;
   import tibia.market.OfferID;
   import tibia.market.OfferStatistics;
   import tibia.minimap.MiniMapStorage;
   import tibia.options.OptionsStorage;
   import tibia.prey.PreyData;
   import tibia.prey.PreyManager;
   import tibia.prey.PreyMonsterInformation;
   import tibia.prey.PreyWidget;
   import tibia.questlog.QuestFlag;
   import tibia.questlog.QuestLine;
   import tibia.questlog.QuestLogWidget;
   import tibia.reporting.ReportWidget;
   import tibia.reporting.reportType.Type;
   import tibia.sidebar.SideBarSet;
   import tibia.sidebar.Widget;
   import tibia.trade.NPCTradeWidget;
   import tibia.trade.SafeTradeWidget;
   import tibia.trade.TradeObjectRef;
   import tibia.worldmap.WorldMapStorage;
   
   public class Communication implements IServerCommunication
   {
      
      protected static const RENDERER_DEFAULT_HEIGHT:Number = MAP_WIDTH * FIELD_SIZE;
      
      protected static const CUPCONTAINER:int = 136;
      
      protected static const SPLAYERSTATE:int = 162;
      
      protected static const CMARKETACCEPT:int = 248;
      
      protected static const OPTIONS_MAX_COMPATIBLE_VERSION:Number = 5;
      
      protected static const PARTY_MEMBER_SEXP_ACTIVE:int = 5;
      
      protected static const CONNECTION_STATE_PENDING:int = 3;
      
      protected static const SKILL_FIGHTCLUB:int = 10;
      
      protected static const RISKINESS_DANGEROUS:int = 1;
      
      protected static const CGOSOUTH:int = 103;
      
      protected static const GUILD_NONE:int = 0;
      
      protected static const PK_PARTYMODE:int = 2;
      
      protected static const FIELD_HEIGHT:int = 24;
      
      protected static const ONSCREEN_MESSAGE_HEIGHT:int = 195;
      
      protected static const SMESSAGE:int = 180;
      
      protected static const CPING:int = 29;
      
      protected static const PARTY_OTHER:int = 11;
      
      protected static const SKILL_EXPERIENCE:int = 0;
      
      protected static const SSETTACTICS:int = 167;
      
      protected static const TYPE_NPC:int = 2;
      
      protected static const CENTERWORLD:int = 15;
      
      protected static const PARTY_MEMBER_SEXP_INACTIVE_GUILTY:int = 7;
      
      protected static const CBUYOBJECT:int = 122;
      
      protected static const SPING:int = 29;
      
      protected static const FIELD_SIZE:int = 32;
      
      protected static const CROTATENORTH:int = 111;
      
      protected static const PATH_NORTH:int = 3;
      
      protected static const SWAIT:int = 182;
      
      protected static const SCREDITBALANCE:int = 223;
      
      protected static const CJOINCHANNEL:int = 152;
      
      protected static const SKILL_FED:int = 15;
      
      protected static const CROTATEEAST:int = 112;
      
      protected static const SKILL_MAGLEVEL:int = 2;
      
      protected static const CUSEONCREATURE:int = 132;
      
      protected static const CCLOSENPCCHANNEL:int = 158;
      
      public static const PREVIEW_STATE_PREVIEW_NO_ACTIVE_CHANGE:uint = 1;
      
      protected static const SKILL_HITPOINTS_PERCENT:int = 3;
      
      protected static const CGUILDMESSAGE:int = 155;
      
      protected static const PROFESSION_MASK_KNIGHT:int = 1 << PROFESSION_KNIGHT;
      
      protected static const ERR_INTERNAL:int = 0;
      
      protected static const CREMOVEBUDDY:int = 221;
      
      protected static const SUMMON_OTHERS:int = 2;
      
      protected static const CAPPLYIMBUEMENT:int = 213;
      
      protected static const NPC_SPEECH_TRADER:uint = 2;
      
      protected static const SFIELDDATA:int = 105;
      
      protected static const CCLOSECONTAINER:int = 135;
      
      protected static const CPASSLEADERSHIP:int = 166;
      
      protected static const PROFESSION_NONE:int = 0;
      
      protected static const MAX_NAME_LENGTH:int = 29;
      
      protected static const SLEFTROW:int = 104;
      
      protected static const CGOWEST:int = 104;
      
      protected static const PARTY_LEADER:int = 1;
      
      protected static const PATH_MATRIX_SIZE:int = 2 * PATH_MAX_DISTANCE + 1;
      
      protected static const PATH_COST_MAX:int = 250;
      
      protected static const STATE_PZ_ENTERED:int = 14;
      
      protected static const PATH_MAX_STEPS:int = 128;
      
      protected static const SKILL_CARRYSTRENGTH:int = 7;
      
      protected static const SBOTTOMROW:int = 103;
      
      protected static const STATE_DROWNING:int = 8;
      
      protected static const CGETOBJECTINFO:int = 243;
      
      protected static const MAP_MIN_X:int = 24576;
      
      protected static const MAP_MIN_Y:int = 24576;
      
      protected static const MAP_MIN_Z:int = 0;
      
      protected static const SUPDATINGSHOPBALANCE:int = 242;
      
      protected static const RENDERER_MIN_HEIGHT:Number = Math.round(MAP_HEIGHT * 2 / 3 * FIELD_SIZE);
      
      protected static const CGOSOUTHWEST:int = 108;
      
      protected static const RENDERER_MIN_WIDTH:Number = Math.round(MAP_WIDTH * 2 / 3 * FIELD_SIZE);
      
      protected static const SPREYFREELISTREROLLAVAILABILITY:int = 230;
      
      protected static const CREVOKEINVITATION:int = 165;
      
      protected static const CGETCHANNELS:int = 151;
      
      protected static const PARTY_MEMBER_SEXP_OFF:int = 3;
      
      protected static const SCREATURESKULL:int = 144;
      
      protected static const CLOGIN:int = 10;
      
      protected static const PROFESSION_MASK_DRUID:int = 1 << PROFESSION_DRUID;
      
      protected static const SPLAYERDATACURRENT:int = 160;
      
      protected static const SOBJECTINFO:int = 244;
      
      protected static const ERR_CONNECTION_LOST:int = 6;
      
      protected static const PROFESSION_SORCERER:int = 3;
      
      protected static const CROTATESOUTH:int = 113;
      
      protected static const PARTY_NONE:int = 0;
      
      protected static const PATH_SOUTH:int = 7;
      
      protected static const ONSCREEN_MESSAGE_WIDTH:int = 295;
      
      protected static const FIELD_ENTER_POSSIBLE:uint = 0;
      
      protected static const PATH_NORTH_WEST:int = 4;
      
      protected static const PROFESSION_MASK_NONE:int = 1 << PROFESSION_NONE;
      
      protected static const CLOOKTRADE:int = 126;
      
      protected static const SCHANNELS:int = 171;
      
      protected static const SOPENCHANNEL:int = 172;
      
      public static const MESSAGEDIALOG_PREY_MESSAGE:int = 20;
      
      protected static const PARTY_LEADER_SEXP_INACTIVE_GUILTY:int = 8;
      
      protected static const FIELD_CACHESIZE:int = FIELD_SIZE;
      
      protected static const PATH_ERROR_UNREACHABLE:int = -4;
      
      protected static const CGETTRANSACTIONHISTORY:int = 254;
      
      protected static const SLOGINWAIT:int = 22;
      
      protected static const CPRIVATECHANNEL:int = 154;
      
      protected static const SINGAMESHOPSUCCESS:int = 254;
      
      public static const PREVIEW_STATE_REGULAR:uint = 0;
      
      protected static const ERR_INVALID_CHECKSUM:int = 2;
      
      protected static const SCONTAINER:int = 110;
      
      protected static const SKILL_MANA_LEECH_AMOUNT:int = 24;
      
      protected static const SNPCOFFER:int = 122;
      
      protected static const CMARKETCANCEL:int = 247;
      
      protected static const CEXCLUDEFROMCHANNEL:int = 172;
      
      protected static const SKILL_HITPOINTS:int = 4;
      
      protected static const STRANSACTIONHISTORY:int = 253;
      
      protected static const SPREMIUMSHOPOFFERS:int = 252;
      
      protected static const CMARKETBROWSE:int = 245;
      
      protected static const SMARKETBROWSE:int = 249;
      
      protected static const BLESSING_ADVENTURER:int = 1;
      
      protected static const CSELLOBJECT:int = 123;
      
      protected static const STATE_FREEZING:int = 9;
      
      protected static const SMARKETLEAVE:int = 247;
      
      protected static const NUM_FIELDS:int = MAPSIZE_Z * MAPSIZE_Y * MAPSIZE_X;
      
      protected static const CFOLLOW:int = 162;
      
      protected static const SBUDDYGROUPDATA:int = 212;
      
      protected static const SKILL_LIFE_LEECH_CHANCE:int = 21;
      
      protected static const SMARKETENTER:int = 246;
      
      protected static const SCLIENTCHECK:int = 99;
      
      protected static const SKILL_FIGHTFIST:int = 13;
      
      protected static const CBLESSINGSDIALOG:int = 207;
      
      protected static const SCREATURESPEED:int = 143;
      
      protected static const STATE_FIGHTING:int = 7;
      
      protected static const NPC_SPEECH_NORMAL:uint = 1;
      
      protected static const SSPELLDELAY:int = 164;
      
      protected static const SITEMWASTED:int = 206;
      
      protected static const BLESSING_SPIRITUAL_SHIELDING:int = BLESSING_FIRE_OF_SUNS << 1;
      
      protected static const BLESSING_SPARK_OF_PHOENIX:int = BLESSING_WISDOM_OF_SOLITUDE << 1;
      
      protected static const RISKINESS_NONE:int = 0;
      
      protected static const SCREATUREOUTFIT:int = 142;
      
      protected static const NUM_PVP_HELPERS_FOR_RISKINESS_DANGEROUS:uint = 5;
      
      public static const RESOURCETYPE_COLLECTION_TOKENS:int = 20;
      
      protected static const SLOGINCHALLENGE:int = 31;
      
      protected static const SPLAYERSKILLS:int = 161;
      
      protected static const CTHANKYOU:int = 231;
      
      protected static const SRESOURCEBALANCE:int = 238;
      
      protected static const SSHOWMODALDIALOG:int = 250;
      
      protected static const FIELD_ENTER_POSSIBLE_NO_ANIMATION:uint = 1;
      
      protected static const STATE_NONE:int = -1;
      
      protected static const SOPENREWARDWALL:int = 226;
      
      protected static const SDELETEINCONTAINER:int = 114;
      
      protected static const PATH_MAX_DISTANCE:int = 110;
      
      protected static const SCREATEINCONTAINER:int = 112;
      
      protected static const SCREATUREHEALTH:int = 140;
      
      protected static const CERRORFILEENTRY:int = 232;
      
      protected static const HEADER_SIZE:int = PACKETLENGTH_SIZE + SEQUENCE_NUMBER_SIZE;
      
      protected static const STATE_BLEEDING:int = 15;
      
      protected static const CINSPECTPLAYER:int = 206;
      
      protected static const STATE_DAZZLED:int = 10;
      
      protected static const CUSEOBJECT:int = 130;
      
      protected static const ERR_INVALID_MESSAGE:int = 3;
      
      protected static const COPENPREMIUMSHOP:int = 250;
      
      protected static const CUSETWOOBJECTS:int = 131;
      
      protected static const BLESSING_BLOOD_OF_THE_MOUNTAIN:int = BLESSING_HEART_OF_THE_MOUNTAIN << 1;
      
      protected static const ERR_INVALID_STATE:int = 4;
      
      protected static const PATH_COST_UNDEFINED:int = 254;
      
      protected static const SDAILYREWARDHISTORY:int = 229;
      
      protected static const CPINGBACK:int = 30;
      
      protected static const CINVITETOPARTY:int = 163;
      
      protected static const SRESTINGAREASTATE:int = 169;
      
      protected static const SPINGBACK:int = 30;
      
      protected static const SITEMLOOTED:int = 207;
      
      protected static const PK_ATTACKER:int = 1;
      
      protected static const STATE_ELECTRIFIED:int = 2;
      
      protected static const SPLAYERGOODS:int = 123;
      
      protected static const SINSPECTIONSTATE:int = 119;
      
      protected static const CINSPECTOBJECT:int = 205;
      
      protected static const CMOVEOBJECT:int = 120;
      
      public static const MESSAGEDIALOG_CLEARING_CHARM_ERROR:int = 11;
      
      protected static const CGOEAST:int = 102;
      
      protected static const SMOVECREATURE:int = 109;
      
      protected static const CSTOREEVENT:int = 233;
      
      protected static const CTOGGLEWRAPSTATE:int = 139;
      
      protected static const CJOINPARTY:int = 164;
      
      protected static const PK_NONE:int = 0;
      
      protected static const CONNECTION_STATE_GAME:int = 4;
      
      protected static const SMULTIUSEDELAY:int = 166;
      
      protected static const CGOPATH:int = 100;
      
      protected static const SCHANGEONMAP:int = 107;
      
      protected static const CGOSOUTHEAST:int = 107;
      
      protected static const CLEAVEPARTY:int = 167;
      
      protected static const SINSPECTIONLIST:int = 118;
      
      protected static const CEQUIPOBJECT:int = 119;
      
      protected static const PROFESSION_MASK_SORCERER:int = 1 << PROFESSION_SORCERER;
      
      protected static const UNDERGROUND_LAYER:int = 2;
      
      protected static const COPENCHANNEL:int = 170;
      
      protected static const SDEAD:int = 40;
      
      protected static const PROFESSION_PALADIN:int = 2;
      
      protected static const PLAYER_OFFSET_X:int = 8;
      
      protected static const PLAYER_OFFSET_Y:int = 6;
      
      protected static const SPVPSITUATIONS:int = 184;
      
      protected static const SLOGINADVICE:int = 21;
      
      protected static const SCHANNELEVENT:int = 243;
      
      protected static const PARTY_LEADER_SEXP_OFF:int = 4;
      
      protected static const MAP_MAX_X:int = MAP_MIN_X + (1 << 14 - 1);
      
      protected static const MAP_MAX_Y:int = MAP_MIN_Y + (1 << 14 - 1);
      
      protected static const MAP_MAX_Z:int = 15;
      
      protected static const SMARKETDETAIL:int = 248;
      
      public static const MESSAGEDIALOG_IMBUEMENT_SUCCESS:int = 0;
      
      protected static const STATE_FAST:int = 6;
      
      protected static const CTALK:int = 150;
      
      protected static const BLESSING_NONE:int = 0;
      
      protected static const PATH_NORTH_EAST:int = 2;
      
      protected static const CEDITTEXT:int = 137;
      
      protected static const PATH_ERROR_TOO_FAR:int = -3;
      
      protected static const SEQUENCE_NUMBER_POS:int = PACKETLENGTH_POS + PACKETLENGTH_SIZE;
      
      protected static const STALK:int = 170;
      
      protected static const GUILD_OTHER:int = 5;
      
      protected static const PROFESSION_MASK_PALADIN:int = 1 << PROFESSION_PALADIN;
      
      protected static const SKILL_MANA:int = 5;
      
      protected static const SEDITTEXT:int = 150;
      
      protected static const SOPENOWNCHANNEL:int = 178;
      
      public static const PREVIEW_STATE_PREVIEW_WITH_ACTIVE_CHANGE:uint = 2;
      
      protected static const STIBIATIME:int = 239;
      
      protected static const PAYLOADLENGTH_SIZE:int = 2;
      
      public static const CLIENT_PREVIEW_STATE:uint = 0;
      
      protected static const SCLOSEIMBUINGDIALOG:int = 236;
      
      protected static const SEQUENCE_NUMBER_SIZE:int = 4;
      
      protected static const SDAILYREWARDCOLLECTIONSTATE:int = 222;
      
      protected static const CMARKETLEAVE:int = 244;
      
      protected static const COPENTRANSACTIONHISTORY:int = 253;
      
      protected static const CSHAREEXPERIENCE:int = 168;
      
      protected static const SCLEARTARGET:int = 163;
      
      protected static const PK_AGGRESSOR:int = 3;
      
      protected static const MAPSIZE_W:int = 10;
      
      protected static const CGETOUTFIT:int = 210;
      
      protected static const MAPSIZE_Y:int = MAP_HEIGHT + 3;
      
      protected static const MAPSIZE_Z:int = 8;
      
      protected static const STATE_HUNGRY:int = 31;
      
      protected static const MAPSIZE_X:int = MAP_WIDTH + 3;
      
      protected static const SCLOSECHANNEL:int = 179;
      
      protected static const NPC_SPEECH_QUEST:uint = 3;
      
      protected static const SOWNOFFER:int = 125;
      
      protected static const PAYLOAD_POS:int = HEADER_POS + HEADER_SIZE;
      
      protected static const SKILL_GOSTRENGTH:int = 6;
      
      protected static const SSETSTOREDEEPLINK:int = 168;
      
      protected static const PATH_ERROR_GO_DOWNSTAIRS:int = -1;
      
      protected static const CMARKETCREATE:int = 246;
      
      protected static const PARTY_LEADER_SEXP_ACTIVE:int = 6;
      
      protected static const CQUITGAME:int = 20;
      
      protected static const PARTY_MAX_FLASHING_TIME:uint = 5000;
      
      protected static const CADDBUDDY:int = 220;
      
      protected static const CGONORTHWEST:int = 109;
      
      protected static const PK_REVENGE:int = 6;
      
      protected static const NPC_SPEECH_NONE:uint = 0;
      
      protected static const SOUTFIT:int = 200;
      
      protected static const NPC_SPEECH_TRAVEL:uint = 5;
      
      protected static const CSETTACTICS:int = 160;
      
      protected static const CPERFORMANCEMETRICS:int = 31;
      
      protected static const SSHOWMESSAGEDIALOG:int = 237;
      
      protected static const ERR_COULD_NOT_CONNECT:int = 5;
      
      protected static const PATH_COST_OBSTACLE:int = 255;
      
      protected static const SPLAYERDATABASIC:int = 159;
      
      protected static const PACKETLENGTH_SIZE:int = 2;
      
      protected static const SPREYDATA:int = 232;
      
      protected static const CGETQUESTLOG:int = 240;
      
      protected static const STATE_DRUNK:int = 3;
      
      protected static const BLESSING_FIRE_OF_SUNS:int = BLESSING_SPARK_OF_PHOENIX << 1;
      
      public static const CLIENT_VERSION:uint = 2491;
      
      protected static const CATTACK:int = 161;
      
      protected static const SKILL_MANA_LEECH_CHANCE:int = 23;
      
      protected static const SLOGINSUCCESS:int = 23;
      
      protected static const CLOOKATCREATURE:int = 141;
      
      protected static const OPTIONS_MIN_COMPATIBLE_VERSION:Number = 2;
      
      protected static const NUM_TRAPPERS:int = 8;
      
      protected static const SBUDDYDATA:int = 210;
      
      protected static const SPREYTIMELEFT:int = 231;
      
      protected static const CBROWSEFIELD:int = 203;
      
      protected static const CPREYACTION:int = 235;
      
      protected static const SCREATUREPARTY:int = 145;
      
      protected static const SQUESTLOG:int = 240;
      
      protected static const GROUND_LAYER:int = 7;
      
      protected static const CCANCEL:int = 190;
      
      protected static const SKILL_NONE:int = -1;
      
      private static const BUNDLE:String = "Communication";
      
      protected static const GUILD_MEMBER:int = 4;
      
      protected static const PATH_EMPTY:int = 0;
      
      protected static const SFULLMAP:int = 100;
      
      protected static const SCLOSECONTAINER:int = 111;
      
      protected static const SCLOSEREWARDWALL:int = 227;
      
      protected static const CREQUESTRESOURCEBALANCE:int = 237;
      
      protected static const SMISSILEEFFECT:int = 133;
      
      public static const MESSAGEDIALOG_IMBUEMENT_ERROR:int = 1;
      
      protected static const PATH_ERROR_GO_UPSTAIRS:int = -2;
      
      protected static const SMARKETSTATISTICS:int = 205;
      
      protected static const SSPELLGROUPDELAY:int = 165;
      
      protected static const CSEEKINCONTAINER:int = 204;
      
      protected static const SQUESTLINE:int = 241;
      
      protected static const GUILD_WAR_NEUTRAL:int = 3;
      
      protected static const BLESSING_HEART_OF_THE_MOUNTAIN:int = BLESSING_EMBRACE_OF_TIBIA << 1;
      
      protected static const SLOGINERROR:int = 20;
      
      protected static const SCREATUREMARKS:int = 147;
      
      protected static const CREJECTTRADE:int = 128;
      
      protected static const MAP_WIDTH:int = 15;
      
      protected static const SREQUESTPURCHASEDATA:int = 225;
      
      public static const MESSAGEDIALOG_PREY_ERROR:int = 21;
      
      protected static const STRAPPERS:int = 135;
      
      protected static const PARTY_MEMBER_SEXP_INACTIVE_INNOCENT:int = 9;
      
      protected static const GUILD_WAR_ALLY:int = 1;
      
      protected static const SUNJUSTIFIEDPOINTS:int = 183;
      
      protected static const CGETQUESTLINE:int = 241;
      
      protected static const SSNAPBACK:int = 181;
      
      protected static const SDAILYREWARDBASIC:int = 228;
      
      protected static const NUM_EFFECTS:int = 200;
      
      protected static const STATE_SLOW:int = 5;
      
      protected static const SIMPACTTRACKING:int = 204;
      
      protected static const CACCEPTTRADE:int = 127;
      
      protected static const STOPFLOOR:int = 190;
      
      protected static const CBUYPREMIUMOFFER:int = 252;
      
      protected static const NPC_SPEECH_QUESTTRADER:uint = 4;
      
      protected static const SPRIVATECHANNEL:int = 173;
      
      protected static const SBLESSINGS:int = 156;
      
      protected static const BLESSING_WISDOM_OF_SOLITUDE:int = BLESSING_TWIST_OF_FATE << 1;
      
      protected static const SSTOREBUTTONINDICATORS:int = 25;
      
      protected static const PAYLOADLENGTH_POS:int = PAYLOAD_POS;
      
      public static const RESOURCETYPE_BANK_GOLD:int = 0;
      
      protected static const SCREATEONMAP:int = 106;
      
      protected static const SPREYREROLLPRICE:int = 233;
      
      protected static const PATH_SOUTH_WEST:int = 6;
      
      protected static const CTRADEOBJECT:int = 125;
      
      public static const MESSAGEDIALOG_CLEARING_CHARM_SUCCESS:int = 10;
      
      protected static const CLOOK:int = 140;
      
      protected static const BLESSING_EMBRACE_OF_TIBIA:int = BLESSING_SPIRITUAL_SHIELDING << 1;
      
      protected static const SWORLDENTERED:int = 15;
      
      protected static const STRACKEDQUESTFLAGS:int = 208;
      
      protected static const HEADER_POS:int = 0;
      
      protected static const PATH_WEST:int = 5;
      
      protected static const MAP_HEIGHT:int = 11;
      
      protected static const SKILL_OFFLINETRAINING:int = 18;
      
      protected static const STATE_MANA_SHIELD:int = 4;
      
      protected static const CMOUNT:int = 212;
      
      protected static const CCLOSENPCTRADE:int = 124;
      
      protected static const STATE_CURSED:int = 11;
      
      protected static const PARTY_LEADER_SEXP_INACTIVE_INNOCENT:int = 10;
      
      protected static const SCOUNTEROFFER:int = 126;
      
      protected static const STATE_POISONED:int = 0;
      
      protected static const PATH_EXISTS:int = 1;
      
      protected static const CANSWERMODALDIALOG:int = 249;
      
      protected static const STATE_BURNING:int = 1;
      
      public static const MESSAGEDIALOG_IMBUING_STATION_NOT_FOUND:int = 3;
      
      protected static const CONNECTION_STATE_CONNECTING_STAGE1:int = 1;
      
      protected static const GUILD_WAR_ENEMY:int = 2;
      
      protected static const CREQUESTSHOPOFFERS:int = 251;
      
      protected static const CONNECTION_STATE_CONNECTING_STAGE2:int = 2;
      
      protected static const PROFESSION_MASK_ANY:int = PROFESSION_MASK_DRUID | PROFESSION_MASK_KNIGHT | PROFESSION_MASK_PALADIN | PROFESSION_MASK_SORCERER;
      
      protected static const CCLOSEDIMBUINGDIALOG:int = 215;
      
      protected static const CEDITBUDDY:int = 222;
      
      protected static const SDELETEONMAP:int = 108;
      
      protected static const CEDITGUILDMESSAGE:int = 156;
      
      protected static const STATE_PZ_BLOCK:int = 13;
      
      protected static const CROTATEWEST:int = 114;
      
      protected static const SEDITGUILDMESSAGE:int = 174;
      
      public static const PROTOCOL_VERSION:int = 1141;
      
      protected static const SAMBIENTE:int = 130;
      
      protected static const ERR_INVALID_SIZE:int = 1;
      
      protected static const CLEAVECHANNEL:int = 153;
      
      protected static const PARTY_MEMBER:int = 2;
      
      protected static const SCREATUREUNPASS:int = 146;
      
      protected static const SKILL_STAMINA:int = 17;
      
      protected static const SKILL_FIGHTSHIELD:int = 8;
      
      protected static const CONNECTION_STATE_DISCONNECTED:int = 0;
      
      protected static const SKILL_FIGHTDISTANCE:int = 9;
      
      protected static const PK_EXCPLAYERKILLER:int = 5;
      
      protected static const NUM_CREATURES:int = 1300;
      
      protected static const SKILL_FISHING:int = 14;
      
      protected static const CGONORTHEAST:int = 106;
      
      public static const RESOURCETYPE_INVENTORY_GOLD:int = 1;
      
      protected static const PK_PLAYERKILLER:int = 4;
      
      protected static const SBOTTOMFLOOR:int = 191;
      
      protected static const STOPROW:int = 101;
      
      protected static const CTURNOBJECT:int = 133;
      
      protected static const CINVITETOCHANNEL:int = 171;
      
      protected static const CLOOKNPCTRADE:int = 121;
      
      protected static const PATH_ERROR_INTERNAL:int = -5;
      
      protected static const SPREMIUMTRIGGER:int = 158;
      
      protected static const SCREATURELIGHT:int = 141;
      
      protected static const SKILL_FIGHTSWORD:int = 11;
      
      protected static const STUTORIALHINT:int = 220;
      
      protected static const CSTOP:int = 105;
      
      protected static const SPLAYERINVENTORY:int = 245;
      
      protected static const CRULEVIOLATIONREPORT:int = 242;
      
      protected static const SKILL_LIFE_LEECH_AMOUNT:int = 22;
      
      protected static const CJOINAGGRESSION:int = 142;
      
      protected static const SSWITCHPRESET:int = 157;
      
      protected static const CEDITLIST:int = 138;
      
      protected static const SEDITLIST:int = 151;
      
      protected static const SCLOSETRADE:int = 127;
      
      protected static const SSETINVENTORY:int = 120;
      
      protected static const SUMMON_OWN:int = 1;
      
      protected static const SKILL_CRITICAL_HIT_CHANCE:int = 19;
      
      protected static const SKILL_EXPERIENCE_GAIN:int = -2;
      
      protected static const FIELD_ENTER_NOT_POSSIBLE:uint = 2;
      
      public static const CLIENT_TYPE:uint = 3;
      
      protected static const PROFESSION_KNIGHT:int = 1;
      
      protected static const SCHANGEINCONTAINER:int = 113;
      
      protected static const SIMBUINGDIALOGREFRESH:int = 235;
      
      protected static const SCREATUREPVPHELPERS:int = 148;
      
      protected static const SDELETEINVENTORY:int = 121;
      
      protected static const CTRANSFERCURRENCY:int = 239;
      
      public static const MESSAGEDIALOG_IMBUEMENT_ROLL_FAILED:int = 2;
      
      protected static const SINGAMESHOPERROR:int = 224;
      
      protected static const SKILL_FIGHTAXE:int = 12;
      
      protected static const SKILL_CRITICAL_HIT_DAMAGE:int = 20;
      
      protected static const CAPPLYCLEARINGCHARM:int = 214;
      
      protected static const CGONORTH:int = 101;
      
      protected static const SKILL_SOULPOINTS:int = 16;
      
      protected static const NUM_ONSCREEN_MESSAGES:int = 16;
      
      protected static const BLESSING_TWIST_OF_FATE:int = BLESSING_ADVENTURER << 1;
      
      protected static const PAYLOADDATA_POSITION:int = PAYLOADLENGTH_POS + PAYLOADLENGTH_SIZE;
      
      protected static const SPREMIUMSHOP:int = 251;
      
      protected static const TYPE_PLAYER:int = 0;
      
      protected static const SCLOSENPCTRADE:int = 124;
      
      protected static const SPENDINGSTATEENTERED:int = 10;
      
      protected static const RENDERER_DEFAULT_WIDTH:Number = MAP_WIDTH * FIELD_SIZE;
      
      protected static const SRIGHTROW:int = 102;
      
      protected static const SSHOWGAMENEWS:int = 152;
      
      protected static const SGRAPHICALEFFECT:int = 131;
      
      protected static const CBUGREPORT:int = 230;
      
      protected static const PATH_SOUTH_EAST:int = 8;
      
      protected static const TYPE_MONSTER:int = 1;
      
      protected static const SBLESSINGSDIALOG:int = 155;
      
      protected static const SCREATURETYPE:int = 149;
      
      protected static const SBUDDYSTATUSCHANGE:int = 211;
      
      protected static const SKILL_LEVEL:int = 1;
      
      protected static const PATH_EAST:int = 1;
      
      protected static const STATE_STRENGTHENED:int = 12;
      
      protected static const PROFESSION_DRUID:int = 4;
      
      protected static const PACKETLENGTH_POS:int = HEADER_POS;
      
      protected static const SUMMON_NONE:int = 0;
      
      protected static const SAUTOMAPFLAG:int = 221;
      
      protected static const TYPE_PLAYERSUMMON:int = 3;
      
      protected static const SKILLTRACKING:int = 209;
      
      protected static const CSETOUTFIT:int = 211;
      
      public static const RESOURCETYPE_PREY_BONUS_REROLLS:int = 10;
      
      protected static const PATH_MATRIX_CENTER:int = PATH_MAX_DISTANCE;
      
      protected static const PK_MAX_FLASHING_TIME:uint = 5000;
       
      
      private var m_AppearanceStorage:AppearanceStorage = null;
      
      private var m_BeatDuration:int = 0;
      
      private var m_ServerConnection:IServerConnection = null;
      
      private var m_ContainerStorage:ContainerStorage = null;
      
      private var m_MessageStorage:MessageStorage = null;
      
      private var m_WorldMapStorage:WorldMapStorage = null;
      
      private var m_SpellStorage:SpellStorage = null;
      
      private var m_BugreportsAllowed:Boolean = false;
      
      private var m_ChatStorage:ChatStorage = null;
      
      private var m_Player:Player = null;
      
      private var m_LastSnapback:Vector3D;
      
      private var m_CreatureStorage:CreatureStorage = null;
      
      private var m_MiniMapStorage:MiniMapStorage = null;
      
      private var m_SnapbackCount:int = 0;
      
      private var m_PendingQuestLog:Boolean = false;
      
      private var m_PendingQuestLine:int = -1;
      
      public function Communication(param1:IServerConnection, param2:AppearanceStorage, param3:ChatStorage, param4:ContainerStorage, param5:CreatureStorage, param6:MiniMapStorage, param7:Player, param8:SpellStorage, param9:WorldMapStorage)
      {
         this.m_LastSnapback = new Vector3D();
         super();
         if(param1 == null)
         {
            throw new Error("Connection.Connection: Invalid connection data.",2147483646);
         }
         this.m_ServerConnection = param1;
         param1.communication = this;
         if(param2 == null)
         {
            throw new Error("Connection.Connection: Invalid appearance data.",2147483645);
         }
         this.m_AppearanceStorage = param2;
         if(param3 == null)
         {
            throw new Error("Connection.Connection: Invalid chat data.",2147483644);
         }
         this.m_ChatStorage = param3;
         if(param4 == null)
         {
            throw new Error("Connection.Connection: Invalid container data.",2147483643);
         }
         this.m_ContainerStorage = param4;
         if(param5 == null)
         {
            throw new Error("Connection.Connection: Invalid creature list.",2147483642);
         }
         this.m_CreatureStorage = param5;
         if(param6 == null)
         {
            throw new Error("Connection.Connection: Invalid mini-map.",2147483641);
         }
         this.m_MiniMapStorage = param6;
         if(param7 == null)
         {
            throw new Error("Connection.Connection: Invalid player.",2147483640);
         }
         this.m_Player = param7;
         if(param8 == null)
         {
            throw new Error("Connection.Connection: Invalid spell data",2147483639);
         }
         this.m_SpellStorage = param8;
         if(param9 == null)
         {
            throw new Error("Connection.Connection: Invalid world map.",2147483638);
         }
         this.m_WorldMapStorage = param9;
         this.m_MessageStorage = new MessageStorage();
         this.m_LastSnapback.setComponents(0,0,0);
         this.m_SnapbackCount = 0;
         this.m_PendingQuestLog = false;
         this.m_PendingQuestLine = -1;
      }
      
      protected function readSOPENREWARDWALL(param1:ByteArray) : void
      {
         var _loc5_:int = 0;
         var _loc9_:String = null;
         var _loc2_:Boolean = param1.readBoolean();
         var _loc3_:int = param1.readUnsignedInt();
         var _loc4_:int = param1.readUnsignedByte();
         _loc5_ = param1.readUnsignedByte();
         if(_loc5_ != 0)
         {
            _loc9_ = StringHelper.s_ReadLongStringFromByteArray(param1);
         }
         var _loc6_:int = param1.readUnsignedInt();
         var _loc7_:int = param1.readUnsignedShort();
         var _loc8_:int = param1.readUnsignedShort();
      }
      
      protected function readSCREATURESKULL(param1:ByteArray) : void
      {
         var _loc2_:int = 0;
         _loc2_ = param1.readUnsignedInt();
         var _loc3_:int = param1.readUnsignedByte();
         var _loc4_:Creature = this.m_CreatureStorage.getCreature(_loc2_);
         if(_loc4_ != null)
         {
            _loc4_.setPKFlag(_loc3_);
         }
         this.m_CreatureStorage.invalidateOpponents();
      }
      
      public function sendCCLOSECONTAINER(param1:int) : void
      {
         var b:ByteArray = null;
         var a_ID:int = param1;
         try
         {
            b = this.m_ServerConnection.messageWriter.createMessage();
            b.writeByte(CCLOSECONTAINER);
            b.writeByte(a_ID);
            this.m_ServerConnection.messageWriter.finishMessage();
            return;
         }
         catch(e:Error)
         {
            handleSendError(CCLOSECONTAINER,e);
            return;
         }
      }
      
      protected function readMountOutfit(param1:ByteArray, param2:AppearanceInstance) : AppearanceInstance
      {
         if(param1 == null || param1.bytesAvailable < 2)
         {
            throw new Error("Connection.readMountOutfit: Not enough data.",2147483619);
         }
         var _loc3_:int = param1.readUnsignedShort();
         if(param2 is OutfitInstance && param2.ID == _loc3_)
         {
            return param2;
         }
         if(_loc3_ != 0)
         {
            return this.m_AppearanceStorage.createOutfitInstance(_loc3_,0,0,0,0,0);
         }
         return null;
      }
      
      public function sendCREMOVEBUDDY(param1:int) : void
      {
         var b:ByteArray = null;
         var a_ID:int = param1;
         try
         {
            b = this.m_ServerConnection.messageWriter.createMessage();
            b.writeByte(CREMOVEBUDDY);
            b.writeUnsignedInt(a_ID);
            this.m_ServerConnection.messageWriter.finishMessage();
            return;
         }
         catch(e:Error)
         {
            handleSendError(CREMOVEBUDDY,e);
            return;
         }
      }
      
      public function sendCOPENPREMIUMSHOP(param1:int, param2:String) : void
      {
         var b:ByteArray = null;
         var a_InitialStoreServiceType:int = param1;
         var a_InitialCategory:String = param2;
         try
         {
            b = this.m_ServerConnection.messageWriter.createMessage();
            b.writeByte(COPENPREMIUMSHOP);
            b.writeByte(a_InitialStoreServiceType);
            StringHelper.s_WriteToByteArray(b,a_InitialCategory);
            this.m_ServerConnection.messageWriter.finishMessage();
            return;
         }
         catch(e:Error)
         {
            handleSendError(COPENPREMIUMSHOP,e);
            return;
         }
      }
      
      public function sendCUSEOBJECT(param1:int, param2:int, param3:int, param4:int, param5:int, param6:int) : void
      {
         var b:ByteArray = null;
         var a_X:int = param1;
         var a_Y:int = param2;
         var a_Z:int = param3;
         var a_TypeID:int = param4;
         var a_PositionOrData:int = param5;
         var a_Window:int = param6;
         try
         {
            if(a_X != 65535)
            {
               this.m_Player.stopAutowalk(false);
            }
            b = this.m_ServerConnection.messageWriter.createMessage();
            b.writeByte(CUSEOBJECT);
            b.writeShort(a_X);
            b.writeShort(a_Y);
            b.writeByte(a_Z);
            b.writeShort(a_TypeID);
            b.writeByte(a_PositionOrData);
            b.writeByte(a_Window);
            this.m_ServerConnection.messageWriter.finishMessage();
            return;
         }
         catch(e:Error)
         {
            handleSendError(CUSEOBJECT,e);
            return;
         }
      }
      
      public function sendCCANCEL() : void
      {
         var b:ByteArray = null;
         try
         {
            b = this.m_ServerConnection.messageWriter.createMessage();
            b.writeByte(CCANCEL);
            this.m_ServerConnection.messageWriter.finishMessage();
            return;
         }
         catch(e:Error)
         {
            handleSendError(CCANCEL,e);
            return;
         }
      }
      
      protected function readSCLOSECHANNEL(param1:ByteArray) : void
      {
         var _loc2_:int = 0;
         _loc2_ = param1.readUnsignedShort();
         this.m_ChatStorage.closeChannel(_loc2_);
      }
      
      protected function readSPREMIUMSHOP(param1:ByteArray) : void
      {
         var _loc2_:IngameShopManager = null;
         var _loc3_:* = false;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc8_:String = null;
         var _loc9_:String = null;
         var _loc10_:int = 0;
         var _loc11_:IngameShopCategory = null;
         var _loc12_:Vector.<String> = null;
         var _loc13_:uint = 0;
         var _loc14_:uint = 0;
         var _loc15_:String = null;
         _loc2_ = IngameShopManager.getInstance();
         _loc3_ = param1.readUnsignedByte() == 1;
         _loc4_ = Number.NaN;
         _loc5_ = Number.NaN;
         if(_loc3_)
         {
            _loc4_ = param1.readInt();
            _loc5_ = param1.readInt();
         }
         _loc2_.setCreditBalance(_loc4_,_loc5_);
         _loc6_ = param1.readUnsignedShort();
         _loc7_ = 0;
         while(_loc7_ < _loc6_)
         {
            _loc8_ = StringHelper.s_ReadLongStringFromByteArray(param1);
            _loc9_ = StringHelper.s_ReadLongStringFromByteArray(param1);
            _loc10_ = param1.readUnsignedByte();
            _loc11_ = new IngameShopCategory(_loc8_,_loc9_,_loc10_);
            _loc12_ = new Vector.<String>();
            _loc13_ = param1.readUnsignedByte();
            _loc14_ = 0;
            while(_loc14_ < _loc13_)
            {
               _loc12_.push(StringHelper.s_ReadLongStringFromByteArray(param1));
               _loc14_++;
            }
            _loc11_.iconIdentifiers = _loc12_;
            _loc15_ = StringHelper.s_ReadLongStringFromByteArray(param1);
            _loc2_.addCategory(_loc11_,_loc15_);
            _loc7_++;
         }
         _loc2_.openShopWindow(false,IngameShopProduct.SERVICE_TYPE_UNKNOWN);
      }
      
      public function sendCPASSLEADERSHIP(param1:int) : void
      {
         var b:ByteArray = null;
         var a_CreatureID:int = param1;
         try
         {
            b = this.m_ServerConnection.messageWriter.createMessage();
            b.writeByte(CPASSLEADERSHIP);
            b.writeInt(a_CreatureID);
            this.m_ServerConnection.messageWriter.finishMessage();
            return;
         }
         catch(e:Error)
         {
            handleSendError(CPASSLEADERSHIP,e);
            return;
         }
      }
      
      protected function readSKILLTRACKING(param1:ByteArray) : void
      {
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:ObjectInstance = null;
         var _loc2_:String = StringHelper.s_ReadLongStringFromByteArray(param1);
         var _loc3_:AppearanceInstance = this.readCreatureOutfit(param1,null);
         _loc4_ = param1.readUnsignedByte();
         _loc5_ = 0;
         while(_loc5_ < _loc4_)
         {
            _loc6_ = this.readObjectInstance(param1);
            _loc5_++;
         }
      }
      
      public function sendCINVITETOCHANNEL(param1:String, param2:int) : void
      {
         var b:ByteArray = null;
         var a_Name:String = param1;
         var a_ChannelID:int = param2;
         try
         {
            b = this.m_ServerConnection.messageWriter.createMessage();
            b.writeByte(CINVITETOCHANNEL);
            StringHelper.s_WriteToByteArray(b,a_Name,Creature.MAX_NAME_LENGHT);
            b.writeShort(a_ChannelID);
            this.m_ServerConnection.messageWriter.finishMessage();
            return;
         }
         catch(e:Error)
         {
            handleSendError(CINVITETOCHANNEL,e);
            return;
         }
      }
      
      public function sendCUSETWOOBJECTS(param1:int, param2:int, param3:int, param4:int, param5:int, param6:int, param7:int, param8:int, param9:int, param10:int) : void
      {
         var b:ByteArray = null;
         var a_FirstX:int = param1;
         var a_FirstY:int = param2;
         var a_FirstZ:int = param3;
         var a_FirstTypeID:int = param4;
         var a_FirstPositionOrData:int = param5;
         var a_SndX:int = param6;
         var a_SndY:int = param7;
         var a_SndZ:int = param8;
         var a_SndTypeID:int = param9;
         var a_SndPosition:int = param10;
         try
         {
            if(a_FirstX != 65535 || a_SndX != 65535)
            {
               this.m_Player.stopAutowalk(false);
            }
            b = this.m_ServerConnection.messageWriter.createMessage();
            b.writeByte(CUSETWOOBJECTS);
            b.writeShort(a_FirstX);
            b.writeShort(a_FirstY);
            b.writeByte(a_FirstZ);
            b.writeShort(a_FirstTypeID);
            b.writeByte(a_FirstPositionOrData);
            b.writeShort(a_SndX);
            b.writeShort(a_SndY);
            b.writeByte(a_SndZ);
            b.writeShort(a_SndTypeID);
            b.writeByte(a_SndPosition);
            this.m_ServerConnection.messageWriter.finishMessage();
            return;
         }
         catch(e:Error)
         {
            handleSendError(CUSETWOOBJECTS,e);
            return;
         }
      }
      
      protected function readFloor(param1:ByteArray, param2:int, param3:int = 0) : int
      {
         var _loc10_:int = 0;
         if(param1 == null)
         {
            throw new Error("Connection.readFloor: Not enough data.",2147483617);
         }
         if(param2 < 0 || param2 >= MAPSIZE_Z)
         {
            throw new Error("Connection.readFloor: Floor number out of range.",2147483616);
         }
         var _loc4_:int = param3;
         var _loc5_:uint = 0;
         var _loc6_:int = 0;
         var _loc7_:Vector3D = new Vector3D();
         var _loc8_:Vector3D = new Vector3D();
         var _loc9_:int = 0;
         while(_loc9_ <= MAPSIZE_X - 1)
         {
            _loc10_ = 0;
            while(_loc10_ <= MAPSIZE_Y - 1)
            {
               if(_loc4_ > 0)
               {
                  _loc4_--;
               }
               else
               {
                  _loc4_ = this.readField(param1,_loc9_,_loc10_,param2);
               }
               _loc7_.setComponents(_loc9_,_loc10_,param2);
               this.m_WorldMapStorage.toAbsolute(_loc7_,_loc8_);
               if(_loc8_.z == this.m_MiniMapStorage.getPositionZ())
               {
                  this.m_WorldMapStorage.updateMiniMap(_loc9_,_loc10_,param2);
                  _loc5_ = this.m_WorldMapStorage.getMiniMapColour(_loc9_,_loc10_,param2);
                  _loc6_ = this.m_WorldMapStorage.getMiniMapCost(_loc9_,_loc10_,param2);
                  this.m_MiniMapStorage.updateField(_loc8_.x,_loc8_.y,_loc8_.z,_loc5_,_loc6_,false);
               }
               _loc10_++;
            }
            _loc9_++;
         }
         return _loc4_;
      }
      
      private function handleSendError(param1:int, param2:Error) : void
      {
         var _loc3_:int = param2 != null?int(param2.errorID):-1;
         this.handleConnectionError(512 + param1,_loc3_,param2);
      }
      
      protected function readMarketOffer(param1:ByteArray, param2:int, param3:int) : Offer
      {
         var _loc4_:uint = param1.readUnsignedInt();
         var _loc5_:uint = param1.readUnsignedShort();
         var _loc6_:int = 0;
         switch(param3)
         {
            case MarketWidget.REQUEST_OWN_OFFERS:
            case MarketWidget.REQUEST_OWN_HISTORY:
               _loc6_ = param1.readUnsignedShort();
               break;
            default:
               _loc6_ = param3;
         }
         var _loc7_:int = param1.readUnsignedShort();
         var _loc8_:uint = param1.readUnsignedInt();
         var _loc9_:String = null;
         var _loc10_:int = Offer.ACTIVE;
         switch(param3)
         {
            case MarketWidget.REQUEST_OWN_OFFERS:
               break;
            case MarketWidget.REQUEST_OWN_HISTORY:
               _loc10_ = param1.readUnsignedByte();
               break;
            default:
               _loc9_ = StringHelper.s_ReadLongStringFromByteArray(param1);
         }
         return new Offer(new OfferID(_loc4_,_loc5_),param2,_loc6_,_loc7_,_loc8_,_loc9_,_loc10_);
      }
      
      public function sendCREQUESTRESOURCEBALANCE(param1:int) : void
      {
         var b:ByteArray = null;
         var a_ResourceType:int = param1;
         try
         {
            b = this.m_ServerConnection.messageWriter.createMessage();
            b.writeByte(CREQUESTRESOURCEBALANCE);
            b.writeByte(a_ResourceType);
            this.m_ServerConnection.messageWriter.finishMessage();
            return;
         }
         catch(e:Error)
         {
            handleSendError(CSTOREEVENT,e);
            return;
         }
      }
      
      public function dispose() : void
      {
         this.m_ServerConnection = null;
      }
      
      protected function readSPENDINGSTATEENTERED(param1:ByteArray) : void
      {
         this.m_ServerConnection.setConnectionState(CONNECTION_STATE_PENDING);
      }
      
      public function sendStatementCRULEVIOLATIONREPORT(param1:int, param2:String, param3:String, param4:String, param5:int) : void
      {
         var b:ByteArray = null;
         var a_Reason:int = param1;
         var a_CharacterName:String = param2;
         var a_Comment:String = param3;
         var a_Translation:String = param4;
         var a_StatementID:int = param5;
         try
         {
            if(a_Translation == null)
            {
               a_Translation = "";
            }
            b = this.m_ServerConnection.messageWriter.createMessage();
            b.writeByte(CRULEVIOLATIONREPORT);
            b.writeByte(Type.REPORT_STATEMENT);
            b.writeByte(a_Reason);
            StringHelper.s_WriteToByteArray(b,a_CharacterName,Creature.MAX_NAME_LENGHT);
            StringHelper.s_WriteToByteArray(b,a_Comment,ReportWidget.MAX_COMMENT_LENGTH);
            StringHelper.s_WriteToByteArray(b,a_Translation,ReportWidget.MAX_TRANSLATION_LENGTH);
            b.writeUnsignedInt(a_StatementID);
            this.m_ServerConnection.messageWriter.finishMessage();
            return;
         }
         catch(e:Error)
         {
            handleSendError(CRULEVIOLATIONREPORT,e);
            return;
         }
      }
      
      protected function readSDAILYREWARDBASIC(param1:ByteArray) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc6_:String = null;
         var _loc7_:uint = 0;
         _loc2_ = param1.readUnsignedByte();
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            this.readDailyReward(param1);
            this.readDailyReward(param1);
            _loc3_++;
         }
         _loc4_ = param1.readUnsignedByte();
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc6_ = StringHelper.s_ReadLongStringFromByteArray(param1);
            _loc7_ = param1.readUnsignedByte();
            _loc3_++;
         }
         var _loc5_:uint = param1.readUnsignedByte();
      }
      
      protected function readSEDITLIST(param1:ByteArray) : void
      {
         var _loc2_:EditListWidget = new EditListWidget();
         _loc2_.type = param1.readUnsignedByte();
         _loc2_.ID = param1.readUnsignedInt();
         _loc2_.text = StringHelper.s_ReadLongStringFromByteArray(param1);
         _loc2_.show();
      }
      
      public function sendCINVITETOPARTY(param1:int) : void
      {
         var b:ByteArray = null;
         var a_CreatureID:int = param1;
         try
         {
            b = this.m_ServerConnection.messageWriter.createMessage();
            b.writeByte(CINVITETOPARTY);
            b.writeInt(a_CreatureID);
            this.m_ServerConnection.messageWriter.finishMessage();
            return;
         }
         catch(e:Error)
         {
            handleSendError(CINVITETOPARTY,e);
            return;
         }
      }
      
      protected function readSTOPROW(param1:ByteArray) : void
      {
         var _loc2_:Vector3D = this.m_WorldMapStorage.getPosition();
         _loc2_.y--;
         this.m_WorldMapStorage.setPosition(_loc2_.x,_loc2_.y,_loc2_.z);
         this.m_MiniMapStorage.setPosition(_loc2_.x,_loc2_.y,_loc2_.z);
         this.m_WorldMapStorage.scrollMap(0,1);
         this.m_WorldMapStorage.invalidateOnscreenMessages();
         this.readArea(param1,0,0,MAPSIZE_X - 1,0);
      }
      
      protected function readObjectInstance(param1:ByteArray, param2:int = -1) : ObjectInstance
      {
         var _loc5_:uint = 0;
         if(param1 == null || param2 == -1 && param1.bytesAvailable < 2)
         {
            throw new Error("Connection.readObjectInstance: Not enough data.",2147483628);
         }
         if(param2 == -1)
         {
            param2 = param1.readUnsignedShort();
         }
         if(param2 == 0)
         {
            return null;
         }
         if(param2 <= AppearanceInstance.CREATURE)
         {
            throw new Error("Connection.readObjectInstance: Invalid type.",2147483627);
         }
         var _loc3_:ObjectInstance = this.m_AppearanceStorage.createObjectInstance(param2,0);
         var _loc4_:uint = param1.readUnsignedByte();
         _loc3_.marks.setMark(Marks.MARK_TYPE_PERMANENT,_loc4_);
         if(_loc3_ == null || _loc3_.m_Type == null)
         {
            throw new Error("Connection.readObjectInstance: Invalid instance.",2147483626);
         }
         if(_loc3_.m_Type.isLiquidContainer || _loc3_.m_Type.isLiquidPool || _loc3_.m_Type.isCumulative)
         {
            _loc3_.data = param1.readUnsignedByte();
         }
         if(_loc3_.m_Type.FrameGroups[FrameGroup.FRAME_GROUP_DEFAULT].isAnimation)
         {
            _loc5_ = param1.readUnsignedByte();
            if(_loc5_ == 0)
            {
               _loc3_.phase = AppearanceAnimator.PHASE_AUTOMATIC;
            }
            else
            {
               _loc3_.phase = _loc5_;
            }
         }
         return _loc3_;
      }
      
      protected function readUnsigned64BitValue(param1:ByteArray) : Number
      {
         var _loc2_:uint = param1.readUnsignedInt();
         var _loc3_:uint = param1.readUnsignedInt();
         if((_loc3_ & 4292870144) != 0)
         {
            throw new RangeError("Connection.readUnsigned64BitValue: Value out of range.");
         }
         return Number(_loc2_) + Number(_loc3_ & 2097151) * Math.pow(2,32);
      }
      
      protected function readSSNAPBACK(param1:ByteArray) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Vector3D = null;
         _loc2_ = param1.readUnsignedByte();
         _loc3_ = this.m_Player.position;
         if(_loc3_.equals(this.m_LastSnapback))
         {
            this.m_SnapbackCount++;
         }
         else
         {
            this.m_SnapbackCount = 0;
         }
         this.m_LastSnapback.setVector(_loc3_);
         if(this.m_SnapbackCount >= 16)
         {
            this.m_Player.stopAutowalk(true);
            this.m_CreatureStorage.setAttackTarget(null,false);
            this.sendCCANCEL();
            this.m_SnapbackCount = 0;
         }
         this.m_Player.abortAutowalk(_loc2_);
      }
      
      protected function readSTRAPPERS(param1:ByteArray) : void
      {
         var _loc5_:int = 0;
         var _loc6_:Creature = null;
         var _loc2_:int = param1.readUnsignedByte();
         if(_loc2_ > NUM_TRAPPERS)
         {
            throw new Error("Connection.readSTRAPPERS: Too many trappers.",0);
         }
         var _loc3_:Vector.<Creature> = new Vector.<Creature>();
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_)
         {
            _loc5_ = param1.readUnsignedInt();
            _loc6_ = this.m_CreatureStorage.getCreature(_loc5_);
            if(_loc6_ == null)
            {
            }
            _loc3_.push(_loc6_);
            _loc4_++;
         }
         this.m_CreatureStorage.setTrappers(_loc3_);
      }
      
      protected function readSFULLMAP(param1:ByteArray) : void
      {
         var _loc2_:Vector3D = this.readCoordinate(param1);
         this.m_Player.stopAutowalk(true);
         this.m_CreatureStorage.markAllOpponentsVisible(false);
         this.m_MiniMapStorage.setPosition(_loc2_.x,_loc2_.y,_loc2_.z);
         this.m_WorldMapStorage.resetMap();
         this.m_WorldMapStorage.invalidateOnscreenMessages();
         this.m_WorldMapStorage.setPosition(_loc2_.x,_loc2_.y,_loc2_.z);
         this.readArea(param1,0,0,MAPSIZE_X - 1,MAPSIZE_Y - 1);
         this.m_WorldMapStorage.valid = true;
      }
      
      protected function readSCLOSEREWARDWALL(param1:ByteArray) : void
      {
      }
      
      protected function readSSHOWMESSAGEDIALOG(param1:ByteArray) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:String = null;
         var _loc4_:PreyWidget = null;
         _loc2_ = param1.readUnsignedByte();
         _loc3_ = StringHelper.s_ReadLongStringFromByteArray(param1);
         if(_loc2_ == MESSAGEDIALOG_IMBUEMENT_SUCCESS || _loc2_ == MESSAGEDIALOG_IMBUEMENT_ERROR || _loc2_ == MESSAGEDIALOG_IMBUEMENT_ROLL_FAILED || _loc2_ == MESSAGEDIALOG_IMBUING_STATION_NOT_FOUND || _loc2_ == MESSAGEDIALOG_CLEARING_CHARM_SUCCESS || _loc2_ == MESSAGEDIALOG_CLEARING_CHARM_ERROR)
         {
            ImbuingManager.getInstance().showImbuingResultDialog(_loc3_);
         }
         else if(_loc2_ == MESSAGEDIALOG_PREY_MESSAGE || _loc2_ == MESSAGEDIALOG_PREY_ERROR)
         {
            _loc4_ = PreyWidget.s_GetCurrentInstance();
            if(_loc4_ != null)
            {
               _loc4_.showMessageDialog(_loc3_);
            }
         }
      }
      
      protected function readSLEFTROW(param1:ByteArray) : void
      {
         var _loc2_:Vector3D = this.m_WorldMapStorage.getPosition();
         _loc2_.x--;
         this.m_WorldMapStorage.setPosition(_loc2_.x,_loc2_.y,_loc2_.z);
         this.m_MiniMapStorage.setPosition(_loc2_.x,_loc2_.y,_loc2_.z);
         this.m_WorldMapStorage.scrollMap(1,0);
         this.m_WorldMapStorage.invalidateOnscreenMessages();
         this.readArea(param1,0,0,0,MAPSIZE_Y - 1);
      }
      
      public function sendCSTOP() : void
      {
         var b:ByteArray = null;
         try
         {
            this.m_CreatureStorage.clearTargets();
            b = this.m_ServerConnection.messageWriter.createMessage();
            b.writeByte(CSTOP);
            this.m_ServerConnection.messageWriter.finishMessage();
            return;
         }
         catch(e:Error)
         {
            handleSendError(CSTOP,e);
            return;
         }
      }
      
      protected function readSPREMIUMTRIGGER(param1:ByteArray) : void
      {
         var _loc2_:Vector.<uint> = null;
         var _loc3_:int = 0;
         _loc2_ = new Vector.<uint>();
         _loc3_ = param1.readUnsignedByte() - 1;
         while(_loc3_ >= 0)
         {
            _loc2_.push(param1.readUnsignedByte());
            _loc3_--;
         }
         Tibia.s_GetPremiumManager().updatePremiumMessages(_loc2_);
      }
      
      protected function readSTRANSACTIONHISTORY(param1:ByteArray) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:Vector.<IngameShopHistoryEntry> = null;
         var _loc6_:int = 0;
         var _loc7_:Number = NaN;
         var _loc8_:int = 0;
         var _loc9_:Number = NaN;
         var _loc10_:String = null;
         _loc2_ = param1.readUnsignedInt();
         _loc3_ = param1.readUnsignedInt();
         _loc4_ = param1.readUnsignedByte();
         _loc5_ = new Vector.<IngameShopHistoryEntry>();
         _loc6_ = 0;
         while(_loc6_ < _loc4_)
         {
            _loc7_ = param1.readUnsignedInt();
            _loc8_ = param1.readUnsignedByte();
            _loc9_ = param1.readInt();
            _loc10_ = StringHelper.s_ReadLongStringFromByteArray(param1);
            _loc5_.push(new IngameShopHistoryEntry(_loc7_,_loc9_,_loc8_,_loc10_));
            _loc6_++;
         }
         IngameShopManager.getInstance().setHistory(_loc2_,_loc3_,_loc5_);
      }
      
      protected function readSCREATUREHEALTH(param1:ByteArray) : void
      {
         var _loc2_:int = 0;
         _loc2_ = param1.readUnsignedInt();
         var _loc3_:int = param1.readUnsignedByte();
         var _loc4_:Creature = this.m_CreatureStorage.getCreature(_loc2_);
         if(_loc4_ != null && _loc4_.ID != this.m_Player.ID)
         {
            _loc4_.setSkillValue(SKILL_HITPOINTS_PERCENT,_loc3_);
         }
         else if(_loc4_ == null)
         {
         }
         this.m_CreatureStorage.invalidateOpponents();
      }
      
      protected function readSCLOSECONTAINER(param1:ByteArray) : void
      {
         this.m_ContainerStorage.closeContainerView(param1.readUnsignedByte());
      }
      
      public function sendCGETOBJECTINFO(... rest) : void
      {
         var b:ByteArray = null;
         var v:Vector.<AppearanceTypeRef> = null;
         var i:int = 0;
         var n:int = 0;
         var a_Parameters:Array = rest;
         try
         {
            b = null;
            if(a_Parameters.length == 1 && a_Parameters[0] is Vector.<AppearanceTypeRef>)
            {
               v = a_Parameters[0] as Vector.<AppearanceTypeRef>;
               i = 0;
               n = Math.min(v.length,255);
               if(n > 0)
               {
                  b = this.m_ServerConnection.messageWriter.createMessage();
                  b.writeByte(CGETOBJECTINFO);
                  b.writeByte(n);
                  i = 0;
                  while(i < n)
                  {
                     b.writeShort(v[i].ID);
                     b.writeByte(v[i].data);
                     i++;
                  }
                  this.m_ServerConnection.messageWriter.finishMessage();
               }
            }
            else if(a_Parameters.length == 2)
            {
               b = this.m_ServerConnection.messageWriter.createMessage();
               b.writeByte(CGETOBJECTINFO);
               b.writeByte(1);
               b.writeShort(int(a_Parameters[i]));
               b.writeByte(int(a_Parameters[i]));
               this.m_ServerConnection.messageWriter.finishMessage();
            }
            else
            {
               throw new Error("Connection.sendCGETOBJECTINFO: Illegal overload.",0);
            }
            return;
         }
         catch(e:Error)
         {
            handleSendError(CGETOBJECTINFO,e);
            return;
         }
      }
      
      public function sendCSEEKINCONTAINER(param1:int, param2:int) : void
      {
         var b:ByteArray = null;
         var a_ID:int = param1;
         var a_Index:int = param2;
         try
         {
            b = this.m_ServerConnection.messageWriter.createMessage();
            b.writeByte(CSEEKINCONTAINER);
            b.writeByte(a_ID);
            b.writeShort(a_Index);
            this.m_ServerConnection.messageWriter.finishMessage();
            return;
         }
         catch(e:Error)
         {
            handleSendError(CSEEKINCONTAINER,e);
            return;
         }
      }
      
      public function sendCMOVEOBJECT(param1:int, param2:int, param3:int, param4:int, param5:int, param6:int, param7:int, param8:int, param9:int) : void
      {
         var b:ByteArray = null;
         var a_StartX:int = param1;
         var a_StartY:int = param2;
         var a_StartZ:int = param3;
         var a_TypeID:int = param4;
         var a_Position:int = param5;
         var a_DestX:int = param6;
         var a_DestY:int = param7;
         var a_DestZ:int = param8;
         var a_Amount:int = param9;
         try
         {
            if(a_StartX != 65535)
            {
               this.m_Player.stopAutowalk(false);
            }
            b = this.m_ServerConnection.messageWriter.createMessage();
            b.writeByte(CMOVEOBJECT);
            b.writeShort(a_StartX);
            b.writeShort(a_StartY);
            b.writeByte(a_StartZ);
            b.writeShort(a_TypeID);
            b.writeByte(a_Position);
            b.writeShort(a_DestX);
            b.writeShort(a_DestY);
            b.writeByte(a_DestZ);
            b.writeByte(a_Amount);
            this.m_ServerConnection.messageWriter.finishMessage();
            return;
         }
         catch(e:Error)
         {
            handleSendError(CMOVEOBJECT,e);
            return;
         }
      }
      
      protected function readSCHANNELS(param1:ByteArray) : void
      {
         var _loc2_:IList = null;
         var _loc3_:int = 0;
         var _loc4_:ChannelSelectionWidget = null;
         _loc2_ = new ArrayCollection();
         _loc3_ = param1.readUnsignedByte();
         while(_loc3_ > 0)
         {
            _loc2_.addItem({
               "ID":param1.readUnsignedShort(),
               "name":StringHelper.s_ReadLongStringFromByteArray(param1,Channel.MAX_NAME_LENGTH)
            });
            _loc3_--;
         }
         _loc2_.addItem({
            "ID":ChatStorage.NPC_CHANNEL_ID,
            "name":ChatStorage.NPC_CHANNEL_LABEL
         });
         _loc2_.addItem({
            "ID":ChatStorage.LOOT_CHANNEL_ID,
            "name":ChatStorage.LOOT_CHANNEL_LABEL
         });
         _loc4_ = new ChannelSelectionWidget();
         _loc4_.channels = _loc2_;
         _loc4_.show();
      }
      
      protected function readSSPELLGROUPDELAY(param1:ByteArray) : void
      {
         this.m_SpellStorage.setSpellGroupDelay(param1.readUnsignedByte(),param1.readUnsignedInt());
      }
      
      protected function readSDAILYREWARDHISTORYA(param1:ByteArray) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:String = null;
         var _loc7_:uint = 0;
         _loc2_ = param1.readUnsignedByte();
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = param1.readUnsignedInt();
            _loc5_ = param1.readUnsignedByte();
            _loc6_ = StringHelper.s_ReadLongStringFromByteArray(param1);
            _loc7_ = param1.readUnsignedShort();
            _loc3_++;
         }
      }
      
      public function sendCSTOREEVENT(param1:int, param2:int) : void
      {
         var b:ByteArray = null;
         var a_StoreEventType:int = param1;
         var a_OfferID:int = param2;
         try
         {
            b = this.m_ServerConnection.messageWriter.createMessage();
            b.writeByte(CSTOREEVENT);
            switch(a_StoreEventType)
            {
               case IngameShopManager.STORE_EVENT_SELECT_OFFER:
                  b.writeByte(a_StoreEventType);
                  b.writeUnsignedInt(a_OfferID);
            }
            this.m_ServerConnection.messageWriter.finishMessage();
            return;
         }
         catch(e:Error)
         {
            handleSendError(CSTOREEVENT,e);
            return;
         }
      }
      
      protected function readSMARKETLEAVE(param1:ByteArray) : void
      {
         var _loc2_:MarketWidget = null;
         _loc2_ = PopUpBase.getCurrent() as MarketWidget;
         if(_loc2_ != null)
         {
            _loc2_.hide(true);
         }
      }
      
      protected function readCreatureOutfit(param1:ByteArray, param2:AppearanceInstance) : AppearanceInstance
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         if(param1 == null || param1.bytesAvailable < 4)
         {
            throw new Error("Connection.readCreatureOutfit: Not enough data.",2147483620);
         }
         var _loc3_:int = param1.readUnsignedShort();
         if(_loc3_ != 0)
         {
            _loc4_ = param1.readUnsignedByte();
            _loc5_ = param1.readUnsignedByte();
            _loc6_ = param1.readUnsignedByte();
            _loc7_ = param1.readUnsignedByte();
            _loc8_ = param1.readUnsignedByte();
            if(param2 is OutfitInstance && param2.ID == _loc3_)
            {
               OutfitInstance(param2).updateProperties(_loc4_,_loc5_,_loc6_,_loc7_,_loc8_);
               return param2;
            }
            return this.m_AppearanceStorage.createOutfitInstance(_loc3_,_loc4_,_loc5_,_loc6_,_loc7_,_loc8_);
         }
         _loc9_ = param1.readUnsignedShort();
         if(param2 is ObjectInstance && param2.ID == _loc9_)
         {
            return param2;
         }
         if(_loc9_ == 0)
         {
            return this.m_AppearanceStorage.createOutfitInstance(OutfitInstance.INVISIBLE_OUTFIT_ID,0,0,0,0,0);
         }
         return this.m_AppearanceStorage.createObjectInstance(_loc9_,0);
      }
      
      public function sendCJOINAGGRESSION(param1:int) : void
      {
         var b:ByteArray = null;
         var a_CreatureID:int = param1;
         try
         {
            b = this.m_ServerConnection.messageWriter.createMessage();
            b.writeByte(CJOINAGGRESSION);
            b.writeInt(a_CreatureID);
            this.m_ServerConnection.messageWriter.finishMessage();
            return;
         }
         catch(e:Error)
         {
            handleSendError(CJOINAGGRESSION,e);
            return;
         }
      }
      
      public function sendCREVOKEINVITATION(param1:int) : void
      {
         var b:ByteArray = null;
         var a_CreatureID:int = param1;
         try
         {
            b = this.m_ServerConnection.messageWriter.createMessage();
            b.writeByte(CREVOKEINVITATION);
            b.writeInt(a_CreatureID);
            this.m_ServerConnection.messageWriter.finishMessage();
            return;
         }
         catch(e:Error)
         {
            handleSendError(CREVOKEINVITATION,e);
            return;
         }
      }
      
      protected function readSTOPFLOOR(param1:ByteArray) : void
      {
         var _loc2_:Vector3D = null;
         var _loc3_:Vector3D = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         _loc2_ = this.m_WorldMapStorage.getPosition();
         _loc2_.x++;
         _loc2_.y++;
         _loc2_.z--;
         this.m_WorldMapStorage.setPosition(_loc2_.x,_loc2_.y,_loc2_.z);
         this.m_MiniMapStorage.setPosition(_loc2_.x,_loc2_.y,_loc2_.z);
         if(_loc2_.z > GROUND_LAYER)
         {
            this.m_WorldMapStorage.scrollMap(0,0,-1);
            this.readFloor(param1,2 * UNDERGROUND_LAYER,0);
         }
         else if(_loc2_.z == GROUND_LAYER)
         {
            this.m_WorldMapStorage.scrollMap(0,0,-(UNDERGROUND_LAYER + 1));
            _loc7_ = 0;
            _loc8_ = UNDERGROUND_LAYER;
            while(_loc8_ <= GROUND_LAYER)
            {
               _loc7_ = this.readFloor(param1,_loc8_,_loc7_);
               _loc8_++;
            }
         }
         this.m_Player.stopAutowalk(true);
         this.m_WorldMapStorage.invalidateOnscreenMessages();
         _loc3_ = this.m_WorldMapStorage.toMap(_loc2_);
         _loc4_ = 0;
         _loc5_ = 0;
         _loc6_ = 0;
         while(_loc6_ < MAPSIZE_X)
         {
            _loc9_ = 0;
            while(_loc9_ < MAPSIZE_Y)
            {
               _loc3_.x = _loc6_;
               _loc3_.y = _loc9_;
               _loc2_ = this.m_WorldMapStorage.toAbsolute(_loc3_,_loc2_);
               this.m_WorldMapStorage.updateMiniMap(_loc3_.x,_loc3_.y,_loc3_.z);
               _loc4_ = this.m_WorldMapStorage.getMiniMapColour(_loc3_.x,_loc3_.y,_loc3_.z);
               _loc5_ = this.m_WorldMapStorage.getMiniMapCost(_loc3_.x,_loc3_.y,_loc3_.z);
               this.m_MiniMapStorage.updateField(_loc2_.x,_loc2_.y,_loc2_.z,_loc4_,_loc5_,false);
               _loc9_++;
            }
            _loc6_++;
         }
      }
      
      protected function readSPLAYERINVENTORY(param1:ByteArray) : void
      {
         var _loc2_:Vector.<InventoryTypeInfo> = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         _loc2_ = new Vector.<InventoryTypeInfo>();
         _loc3_ = param1.readUnsignedShort() - 1;
         while(_loc3_ >= 0)
         {
            _loc4_ = param1.readUnsignedShort();
            _loc5_ = param1.readUnsignedByte();
            _loc6_ = param1.readUnsignedShort();
            _loc2_.push(new InventoryTypeInfo(_loc4_,_loc5_,_loc6_));
            _loc3_--;
         }
         this.m_ContainerStorage.setPlayerInventory(_loc2_);
      }
      
      protected function readSCLOSEIMBUINGDIALOG(param1:ByteArray) : void
      {
         ImbuingManager.getInstance().closeImbuingWindow();
      }
      
      protected function readSPLAYERSKILLS(param1:ByteArray) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Array = null;
         var _loc7_:Array = null;
         _loc2_ = 0;
         _loc3_ = 0;
         _loc4_ = 0;
         _loc5_ = 0;
         _loc6_ = [SKILL_FIGHTFIST,SKILL_FIGHTCLUB,SKILL_FIGHTSWORD,SKILL_FIGHTAXE,SKILL_FIGHTDISTANCE,SKILL_FIGHTSHIELD,SKILL_FISHING];
         _loc7_ = [SKILL_CRITICAL_HIT_CHANCE,SKILL_CRITICAL_HIT_DAMAGE,SKILL_LIFE_LEECH_CHANCE,SKILL_LIFE_LEECH_AMOUNT,SKILL_MANA_LEECH_CHANCE,SKILL_MANA_LEECH_AMOUNT];
         for each(_loc2_ in _loc6_)
         {
            _loc3_ = param1.readUnsignedShort();
            _loc4_ = param1.readUnsignedShort();
            _loc5_ = param1.readUnsignedByte();
            this.m_Player.setSkill(_loc2_,_loc3_,_loc4_,_loc5_);
         }
         for each(_loc2_ in _loc7_)
         {
            _loc3_ = param1.readUnsignedShort();
            _loc4_ = param1.readUnsignedShort();
            this.m_Player.setSkill(_loc2_,_loc3_,_loc4_,0);
         }
      }
      
      protected function readSSTOREBUTTONINDICATORS(param1:ByteArray) : void
      {
         var _loc2_:Boolean = param1.readBoolean();
         var _loc3_:Boolean = param1.readBoolean();
      }
      
      protected function readSPVPSITUATIONS(param1:ByteArray) : void
      {
         this.m_Player.openPvpSituations = param1.readUnsignedByte();
      }
      
      public function sendCEDITLIST(param1:int, param2:int, param3:String) : void
      {
         var b:ByteArray = null;
         var a_Type:int = param1;
         var a_ID:int = param2;
         var a_Text:String = param3;
         try
         {
            b = this.m_ServerConnection.messageWriter.createMessage();
            b.writeByte(CEDITLIST);
            b.writeByte(a_Type);
            b.writeUnsignedInt(a_ID);
            StringHelper.s_WriteToByteArray(b,a_Text);
            this.m_ServerConnection.messageWriter.finishMessage();
            return;
         }
         catch(e:Error)
         {
            handleSendError(CEDITLIST,e);
            return;
         }
      }
      
      protected function readSCLIENTCHECK(param1:ByteArray) : void
      {
         var _loc2_:uint = param1.readUnsignedInt();
         var _loc3_:ByteArray = new ByteArray();
         param1.readBytes(_loc3_,0,_loc2_);
      }
      
      protected function readSCLEARTARGET(param1:ByteArray) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Creature = null;
         _loc2_ = param1.readUnsignedInt();
         _loc3_ = null;
         if((_loc3_ = this.m_CreatureStorage.getAttackTarget()) != null && _loc2_ == _loc3_.ID)
         {
            this.m_CreatureStorage.setAttackTarget(null,false);
         }
         else if((_loc3_ = this.m_CreatureStorage.getFollowTarget()) != null && _loc2_ == _loc3_.ID)
         {
            this.m_CreatureStorage.setFollowTarget(null,false);
         }
      }
      
      public function sendCREJECTTRADE() : void
      {
         var b:ByteArray = null;
         try
         {
            b = this.m_ServerConnection.messageWriter.createMessage();
            b.writeByte(CREJECTTRADE);
            this.m_ServerConnection.messageWriter.finishMessage();
            return;
         }
         catch(e:Error)
         {
            handleSendError(CREJECTTRADE,e);
            return;
         }
      }
      
      public function sendCGETCHANNELS() : void
      {
         var b:ByteArray = null;
         try
         {
            b = this.m_ServerConnection.messageWriter.createMessage();
            b.writeByte(CGETCHANNELS);
            this.m_ServerConnection.messageWriter.finishMessage();
            return;
         }
         catch(e:Error)
         {
            handleSendError(CGETCHANNELS,e);
            return;
         }
      }
      
      protected function readSMARKETENTER(param1:ByteArray) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:uint = 0;
         var _loc4_:Array = null;
         var _loc5_:int = 0;
         var _loc6_:MarketWidget = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         _loc2_ = this.readSigned64BitValue(param1);
         _loc3_ = param1.readUnsignedByte();
         _loc4_ = [];
         _loc5_ = param1.readUnsignedShort() - 1;
         while(_loc5_ >= 0)
         {
            _loc7_ = param1.readUnsignedShort();
            _loc8_ = param1.readUnsignedShort();
            _loc4_.push(new InventoryTypeInfo(_loc7_,0,_loc8_));
            _loc5_--;
         }
         _loc6_ = PopUpBase.getCurrent() as MarketWidget;
         if(_loc6_ == null)
         {
            _loc6_ = new MarketWidget();
            _loc6_.show();
         }
         _loc6_.serverResponsePending = false;
         _loc6_.accountBalance = _loc2_;
         _loc6_.activeOffers = _loc3_;
         _loc6_.depotContent = _loc4_;
      }
      
      protected function readSINSPECTIONSTATE(param1:ByteArray) : void
      {
         param1.readUnsignedInt();
         param1.readUnsignedByte();
      }
      
      protected function readSWAIT(param1:ByteArray) : void
      {
         this.m_Player.earliestMoveTime = this.m_Player.earliestMoveTime + param1.readUnsignedShort();
      }
      
      protected function readSBUDDYDATA(param1:ByteArray) : void
      {
         var _loc2_:int = 0;
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc5_:uint = 0;
         var _loc6_:Boolean = false;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         var _loc9_:int = 0;
         var _loc10_:OptionsStorage = null;
         var _loc11_:BuddySet = null;
         _loc2_ = param1.readUnsignedInt();
         _loc3_ = StringHelper.s_ReadLongStringFromByteArray(param1,Creature.MAX_NAME_LENGHT);
         _loc4_ = StringHelper.s_ReadLongStringFromByteArray(param1,Creature.MAX_DESCRIPTION_LENGHT);
         _loc5_ = param1.readUnsignedInt();
         _loc6_ = param1.readBoolean();
         _loc7_ = param1.readByte();
         _loc8_ = param1.readByte();
         _loc9_ = 0;
         while(_loc9_ < _loc8_)
         {
            param1.readByte();
            _loc9_++;
         }
         _loc10_ = Tibia.s_GetOptions();
         _loc11_ = null;
         if(_loc10_ != null && (_loc11_ = _loc10_.getBuddySet(BuddySet.DEFAULT_SET)) != null)
         {
            _loc11_.updateBuddy(_loc2_,_loc3_,_loc4_,_loc5_,_loc6_,_loc7_);
         }
      }
      
      protected function readSDELETEINCONTAINER(param1:ByteArray) : void
      {
         var _loc2_:int = 0;
         _loc2_ = param1.readUnsignedByte();
         var _loc3_:int = param1.readUnsignedShort();
         var _loc4_:ObjectInstance = this.readObjectInstance(param1);
         var _loc5_:ContainerView = this.m_ContainerStorage.getContainerView(_loc2_);
         if(_loc5_ != null)
         {
            _loc5_.removeObject(_loc3_,_loc4_);
         }
      }
      
      protected function readSLOGINSUCCESS(param1:ByteArray) : void
      {
         this.m_Player.ID = param1.readUnsignedInt();
         this.m_BeatDuration = param1.readUnsignedShort();
         Creature.speedA = this.readDouble(param1);
         Creature.speedB = this.readDouble(param1);
         Creature.speedC = this.readDouble(param1);
         this.m_BugreportsAllowed = param1.readUnsignedByte() == 1;
         var _loc2_:OptionsStorage = Tibia.s_GetOptions();
         _loc2_.uiHints.canChangePvPFramingOption = param1.readUnsignedByte() == 1;
         _loc2_.uiHints.expertModeButtonEnabled = param1.readUnsignedByte() == 1;
         var _loc3_:String = StringHelper.s_ReadLongStringFromByteArray(param1);
         var _loc4_:Number = param1.readUnsignedShort();
         IngameShopManager.getInstance().setupWithServerSettings(_loc3_,_loc4_);
      }
      
      public function sendCTOGGLEWRAPSTATE(param1:int, param2:int, param3:int, param4:int, param5:int) : void
      {
         var b:ByteArray = null;
         var a_X:int = param1;
         var a_Y:int = param2;
         var a_Z:int = param3;
         var a_TypeID:int = param4;
         var a_Position:int = param5;
         try
         {
            b = this.m_ServerConnection.messageWriter.createMessage();
            b.writeByte(CTOGGLEWRAPSTATE);
            b.writeShort(a_X);
            b.writeShort(a_Y);
            b.writeByte(a_Z);
            b.writeShort(a_TypeID);
            b.writeByte(a_Position);
            this.m_ServerConnection.messageWriter.finishMessage();
            return;
         }
         catch(e:Error)
         {
            handleSendError(CTURNOBJECT,e);
            return;
         }
      }
      
      public function sendBotCRULEVIOLATIONREPORT(param1:int, param2:String, param3:String) : void
      {
         var b:ByteArray = null;
         var a_Reason:int = param1;
         var a_CharacterName:String = param2;
         var a_Comment:String = param3;
         try
         {
            b = this.m_ServerConnection.messageWriter.createMessage();
            b.writeByte(CRULEVIOLATIONREPORT);
            b.writeByte(Type.REPORT_BOT);
            b.writeByte(a_Reason);
            StringHelper.s_WriteToByteArray(b,a_CharacterName,Creature.MAX_NAME_LENGHT);
            StringHelper.s_WriteToByteArray(b,a_Comment,ReportWidget.MAX_COMMENT_LENGTH);
            this.m_ServerConnection.messageWriter.finishMessage();
            return;
         }
         catch(e:Error)
         {
            handleSendError(CRULEVIOLATIONREPORT,e);
            return;
         }
      }
      
      public function sendCGETQUESTLINE(param1:int) : void
      {
         var b:ByteArray = null;
         var a_QuestLine:int = param1;
         try
         {
            b = this.m_ServerConnection.messageWriter.createMessage();
            b.writeByte(CGETQUESTLINE);
            b.writeShort(a_QuestLine);
            this.m_ServerConnection.messageWriter.finishMessage();
            this.m_PendingQuestLine = a_QuestLine;
            return;
         }
         catch(e:Error)
         {
            handleSendError(CGETQUESTLINE,e);
            return;
         }
      }
      
      protected function readSAUTOMAPFLAG(param1:ByteArray) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:String = null;
         _loc2_ = param1.readUnsignedShort();
         _loc3_ = param1.readUnsignedShort();
         _loc4_ = param1.readUnsignedByte();
         _loc5_ = param1.readUnsignedByte();
         _loc6_ = StringHelper.s_ReadLongStringFromByteArray(param1);
         this.m_MiniMapStorage.setMark(_loc2_,_loc3_,_loc4_,_loc5_,_loc6_);
         this.m_MiniMapStorage.highlightMarks();
      }
      
      protected function readSDAILYREWARDCOLLECTIONSTATE(param1:ByteArray) : void
      {
         var _loc2_:uint = param1.readUnsignedByte();
      }
      
      public function sendCJOINPARTY(param1:int) : void
      {
         var b:ByteArray = null;
         var a_CreatureID:int = param1;
         try
         {
            b = this.m_ServerConnection.messageWriter.createMessage();
            b.writeByte(CJOINPARTY);
            b.writeInt(a_CreatureID);
            this.m_ServerConnection.messageWriter.finishMessage();
            return;
         }
         catch(e:Error)
         {
            handleSendError(CJOINPARTY,e);
            return;
         }
      }
      
      private function handleConnectionError(param1:int, param2:int = 0, param3:Object = null) : void
      {
         this.m_ServerConnection.disconnect(false);
         var _loc4_:String = null;
         switch(param1)
         {
            case ERR_INTERNAL:
         }
         _loc4_ = ResourceManager.getInstance().getString(BUNDLE,"MSG_INTERNAL_ERROR",[param1,param2]);
         var _loc5_:ConnectionEvent = new ConnectionEvent(ConnectionEvent.ERROR);
         _loc5_.message = _loc4_;
         _loc5_.data = null;
         this.m_ServerConnection.dispatchEvent(_loc5_);
      }
      
      protected function readSCREATEINCONTAINER(param1:ByteArray) : void
      {
         var _loc2_:int = 0;
         _loc2_ = param1.readUnsignedByte();
         var _loc3_:int = param1.readUnsignedShort();
         var _loc4_:ObjectInstance = this.readObjectInstance(param1);
         var _loc5_:ContainerView = this.m_ContainerStorage.getContainerView(_loc2_);
         if(_loc5_ != null)
         {
            _loc5_.addObject(_loc3_,_loc4_);
         }
      }
      
      protected function readSPREYTIMELEFT(param1:ByteArray) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:Number = NaN;
         _loc2_ = param1.readUnsignedByte();
         _loc3_ = param1.readUnsignedShort();
         PreyManager.getInstance().setPreyTimeLeft(_loc2_,_loc3_);
      }
      
      protected function readSPREYFREELISTREROLLAVAILABILITY(param1:ByteArray) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:Number = NaN;
         _loc2_ = param1.readUnsignedByte();
         _loc3_ = param1.readUnsignedShort();
         PreyManager.getInstance().setTimeUntilFreeListReroll(_loc2_,_loc3_);
      }
      
      public function sendCLEAVEPARTY() : void
      {
         var b:ByteArray = null;
         try
         {
            b = this.m_ServerConnection.messageWriter.createMessage();
            b.writeByte(CLEAVEPARTY);
            this.m_ServerConnection.messageWriter.finishMessage();
            return;
         }
         catch(e:Error)
         {
            handleSendError(CLEAVEPARTY,e);
            return;
         }
      }
      
      protected function readSPLAYERSTATE(param1:ByteArray) : void
      {
         var _loc2_:uint = 0;
         _loc2_ = param1.readUnsignedInt();
         this.m_Player.stateFlags = _loc2_;
      }
      
      protected function readSDELETEONMAP(param1:ByteArray) : void
      {
         var _loc9_:uint = 0;
         var _loc10_:int = 0;
         var _loc2_:int = param1.readUnsignedShort();
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:Vector3D = null;
         var _loc6_:Vector3D = null;
         var _loc7_:ObjectInstance = null;
         var _loc8_:Creature = null;
         if(_loc2_ != 65535)
         {
            _loc5_ = this.readCoordinate(param1,_loc2_);
            if(!this.m_WorldMapStorage.isVisible(_loc5_.x,_loc5_.y,_loc5_.z,true))
            {
               throw new Error("Connection.readSDELETEONMAP: Co-ordinate " + _loc5_ + " is out of range.",0);
            }
            _loc6_ = this.m_WorldMapStorage.toMap(_loc5_);
            _loc4_ = param1.readUnsignedByte();
            if((_loc7_ = this.m_WorldMapStorage.getObject(_loc6_.x,_loc6_.y,_loc6_.z,_loc4_)) == null)
            {
               throw new Error("Connection.readSDELETEONMAP: Object not found.",1);
            }
            if(_loc7_.ID == AppearanceInstance.CREATURE && (_loc8_ = this.m_CreatureStorage.getCreature(_loc7_.data)) == null)
            {
               throw new Error("Connection.readSDELETEONMAP: Creature not found: " + _loc7_.data,2);
            }
            this.m_WorldMapStorage.deleteObject(_loc6_.x,_loc6_.y,_loc6_.z,_loc4_);
         }
         else
         {
            _loc3_ = param1.readUnsignedInt();
            if((_loc8_ = this.m_CreatureStorage.getCreature(_loc3_)) == null)
            {
               throw new Error("Connection.readSDELETEONMAP: Creature not found: " + _loc3_,3);
            }
            _loc5_ = _loc8_.position;
            if(!this.m_WorldMapStorage.isVisible(_loc5_.x,_loc5_.y,_loc5_.z,true))
            {
               throw new Error("Connection.readSDELETEONMAP: Co-ordinate " + _loc5_ + " is out of range.",4);
            }
            _loc6_ = this.m_WorldMapStorage.toMap(_loc5_);
         }
         if(_loc8_ != null)
         {
            this.m_CreatureStorage.markOpponentVisible(_loc8_,false);
         }
         if(_loc5_.z == this.m_MiniMapStorage.getPositionZ())
         {
            this.m_WorldMapStorage.updateMiniMap(_loc6_.x,_loc6_.y,_loc6_.z);
            _loc9_ = this.m_WorldMapStorage.getMiniMapColour(_loc6_.x,_loc6_.y,_loc6_.z);
            _loc10_ = this.m_WorldMapStorage.getMiniMapCost(_loc6_.x,_loc6_.y,_loc6_.z);
            this.m_MiniMapStorage.updateField(_loc5_.x,_loc5_.y,_loc5_.z,_loc9_,_loc10_,false);
         }
      }
      
      public function sendCROTATESOUTH() : void
      {
         var b:ByteArray = null;
         try
         {
            b = this.m_ServerConnection.messageWriter.createMessage();
            b.writeByte(CROTATESOUTH);
            this.m_ServerConnection.messageWriter.finishMessage();
            return;
         }
         catch(e:Error)
         {
            handleSendError(CROTATESOUTH,e);
            return;
         }
      }
      
      protected function readSNPCOFFER(param1:ByteArray) : void
      {
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:String = null;
         var _loc12_:uint = 0;
         var _loc13_:uint = 0;
         var _loc14_:uint = 0;
         var _loc15_:NPCTradeWidget = null;
         var _loc2_:String = StringHelper.s_ReadLongStringFromByteArray(param1);
         var _loc3_:IList = new ArrayCollection();
         var _loc4_:IList = new ArrayCollection();
         var _loc5_:int = param1.readUnsignedShort();
         var _loc6_:int = 0;
         while(_loc6_ < _loc5_)
         {
            _loc9_ = param1.readUnsignedShort();
            _loc10_ = param1.readUnsignedByte();
            _loc11_ = StringHelper.s_ReadLongStringFromByteArray(param1,NPCTradeWidget.MAX_WARE_NAME_LENGTH);
            _loc12_ = param1.readUnsignedInt();
            _loc13_ = param1.readUnsignedInt();
            _loc14_ = param1.readUnsignedInt();
            if(_loc13_ > 0)
            {
               _loc3_.addItem(new TradeObjectRef(_loc9_,_loc10_,_loc11_,_loc13_,_loc12_));
            }
            if(_loc14_ > 0)
            {
               _loc4_.addItem(new TradeObjectRef(_loc9_,_loc10_,_loc11_,_loc14_,_loc12_));
            }
            _loc6_++;
         }
         var _loc7_:OptionsStorage = Tibia.s_GetOptions();
         var _loc8_:SideBarSet = null;
         if(_loc7_ != null && (_loc8_ = _loc7_.getSideBarSet(SideBarSet.DEFAULT_SET)) != null)
         {
            _loc15_ = _loc8_.getWidgetByType(Widget.TYPE_NPCTRADE) as NPCTradeWidget;
            if(_loc15_ == null)
            {
               _loc15_ = _loc8_.showWidgetType(Widget.TYPE_NPCTRADE,-1,-1) as NPCTradeWidget;
            }
            _loc15_.npcName = _loc2_;
            _loc15_.buyObjects = _loc3_;
            _loc15_.sellObjects = _loc4_;
            _loc15_.categories = null;
         }
      }
      
      protected function readSITEMWASTED(param1:ByteArray) : void
      {
         var _loc2_:uint = param1.readUnsignedShort();
      }
      
      public function sendCPRIVATECHANNEL(param1:String) : void
      {
         var b:ByteArray = null;
         var a_Name:String = param1;
         try
         {
            b = this.m_ServerConnection.messageWriter.createMessage();
            b.writeByte(CPRIVATECHANNEL);
            StringHelper.s_WriteToByteArray(b,a_Name,Creature.MAX_NAME_LENGHT);
            this.m_ServerConnection.messageWriter.finishMessage();
            return;
         }
         catch(e:Error)
         {
            handleSendError(CPRIVATECHANNEL,e);
            return;
         }
      }
      
      public function disconnect(param1:Boolean) : void
      {
         if((this.m_ServerConnection.isGameRunning || this.m_ServerConnection.isPending) && !param1)
         {
            this.sendCQUITGAME();
         }
         else
         {
            this.m_ServerConnection.disconnect();
         }
      }
      
      protected function readSCLOSENPCTRADE(param1:ByteArray) : void
      {
         var _loc2_:OptionsStorage = Tibia.s_GetOptions();
         var _loc3_:SideBarSet = null;
         var _loc4_:NPCTradeWidget = null;
         if(_loc2_ != null && (_loc3_ = _loc2_.getSideBarSet(SideBarSet.DEFAULT_SET)) != null && (_loc4_ = _loc3_.getWidgetByType(Widget.TYPE_NPCTRADE) as NPCTradeWidget) != null)
         {
            _loc4_.buyObjects = null;
            _loc4_.sellObjects = null;
            _loc4_.categories = null;
            _loc3_.hideWidgetType(Widget.TYPE_NPCTRADE,-1);
         }
      }
      
      protected function readSSPELLDELAY(param1:ByteArray) : void
      {
         this.m_SpellStorage.setSpellDelay(param1.readUnsignedByte(),param1.readUnsignedInt());
      }
      
      public function sendCACCEPTTRADE() : void
      {
         var b:ByteArray = null;
         try
         {
            b = this.m_ServerConnection.messageWriter.createMessage();
            b.writeByte(CACCEPTTRADE);
            this.m_ServerConnection.messageWriter.finishMessage();
            return;
         }
         catch(e:Error)
         {
            handleSendError(CACCEPTTRADE,e);
            return;
         }
      }
      
      protected function readSFIELDDATA(param1:ByteArray) : void
      {
         var _loc4_:uint = 0;
         var _loc5_:int = 0;
         var _loc2_:Vector3D = this.readCoordinate(param1);
         if(!this.m_WorldMapStorage.isVisible(_loc2_.x,_loc2_.y,_loc2_.z,true))
         {
            throw new Error("Connection.readSFIELDDATA: Co-ordinate " + _loc2_ + " is out of range.",0);
         }
         var _loc3_:Vector3D = this.m_WorldMapStorage.toMap(_loc2_);
         this.m_WorldMapStorage.resetField(_loc3_.x,_loc3_.y,_loc3_.z,true,false);
         this.readField(param1,_loc3_.x,_loc3_.y,_loc3_.z);
         if(_loc2_.z == this.m_MiniMapStorage.getPositionZ())
         {
            this.m_WorldMapStorage.updateMiniMap(_loc3_.x,_loc3_.y,_loc3_.z);
            _loc4_ = this.m_WorldMapStorage.getMiniMapColour(_loc3_.x,_loc3_.y,_loc3_.z);
            _loc5_ = this.m_WorldMapStorage.getMiniMapCost(_loc3_.x,_loc3_.y,_loc3_.z);
            this.m_MiniMapStorage.updateField(_loc2_.x,_loc2_.y,_loc2_.z,_loc4_,_loc5_,false);
         }
      }
      
      public function sendCBUYPREMIUMOFFER(param1:int, param2:int, ... rest) : void
      {
         var b:ByteArray = null;
         var a_OfferID:int = param1;
         var a_ServiceType:int = param2;
         var a_Args:Array = rest;
         if(a_ServiceType == IngameShopProduct.SERVICE_TYPE_UNKNOWN && a_Args.length > 0 || a_ServiceType == IngameShopProduct.SERVICE_TYPE_CHARACTER_NAME_CHANGE && a_Args.length != 1)
         {
            throw new ArgumentError("sendCBUYPREMIUMOFFER: Invalid parameter count for specified service " + a_ServiceType + ": " + a_Args.length);
         }
         try
         {
            b = this.m_ServerConnection.messageWriter.createMessage();
            b.writeByte(CBUYPREMIUMOFFER);
            b.writeUnsignedInt(a_OfferID);
            b.writeByte(a_ServiceType);
            if(a_ServiceType == IngameShopProduct.SERVICE_TYPE_CHARACTER_NAME_CHANGE)
            {
               StringHelper.s_WriteToByteArray(b,a_Args[0] as String);
            }
            this.m_ServerConnection.messageWriter.finishMessage();
            return;
         }
         catch(e:Error)
         {
            handleSendError(CBUYPREMIUMOFFER,e);
            return;
         }
      }
      
      public function sendCEQUIPOBJECT(param1:int, param2:int) : void
      {
         var b:ByteArray = null;
         var a_TypeID:int = param1;
         var a_Data:int = param2;
         try
         {
            b = this.m_ServerConnection.messageWriter.createMessage();
            b.writeByte(CEQUIPOBJECT);
            b.writeShort(a_TypeID);
            b.writeByte(a_Data);
            this.m_ServerConnection.messageWriter.finishMessage();
            return;
         }
         catch(e:Error)
         {
            handleSendError(CEQUIPOBJECT,e);
            return;
         }
      }
      
      public function sendCTRANSFERCURRENCY(param1:String, param2:uint) : void
      {
         var b:ByteArray = null;
         var a_TargetCharacter:String = param1;
         var a_Amount:uint = param2;
         try
         {
            b = this.m_ServerConnection.messageWriter.createMessage();
            b.writeByte(CTRANSFERCURRENCY);
            StringHelper.s_WriteToByteArray(b,a_TargetCharacter);
            b.writeUnsignedInt(a_Amount);
            this.m_ServerConnection.messageWriter.finishMessage();
            return;
         }
         catch(e:Error)
         {
            handleSendError(CTRANSFERCURRENCY,e);
            return;
         }
      }
      
      protected function readSIMPACTTRACKING(param1:ByteArray) : void
      {
         var _loc2_:Boolean = param1.readBoolean();
         var _loc3_:uint = param1.readUnsignedInt();
      }
      
      protected function readSRIGHTROW(param1:ByteArray) : void
      {
         var _loc2_:Vector3D = this.m_WorldMapStorage.getPosition();
         _loc2_.x++;
         this.m_WorldMapStorage.setPosition(_loc2_.x,_loc2_.y,_loc2_.z);
         this.m_MiniMapStorage.setPosition(_loc2_.x,_loc2_.y,_loc2_.z);
         this.m_WorldMapStorage.scrollMap(-1,0);
         this.m_WorldMapStorage.invalidateOnscreenMessages();
         this.readArea(param1,MAPSIZE_X - 1,0,MAPSIZE_X - 1,MAPSIZE_Y - 1);
      }
      
      public function sendCOPENCHANNEL() : void
      {
         var b:ByteArray = null;
         try
         {
            b = this.m_ServerConnection.messageWriter.createMessage();
            b.writeByte(COPENCHANNEL);
            this.m_ServerConnection.messageWriter.finishMessage();
            return;
         }
         catch(e:Error)
         {
            handleSendError(COPENCHANNEL,e);
            return;
         }
      }
      
      protected function readSEDITTEXT(param1:ByteArray) : void
      {
         var _loc2_:EditTextWidget = new EditTextWidget();
         _loc2_.ID = param1.readUnsignedInt();
         var _loc3_:ObjectInstance = this.readObjectInstance(param1);
         _loc2_.object = new AppearanceTypeRef(_loc3_.ID,_loc3_.data);
         _loc2_.maxChars = param1.readUnsignedShort();
         _loc2_.text = StringHelper.s_ReadLongStringFromByteArray(param1);
         _loc2_.author = StringHelper.s_ReadLongStringFromByteArray(param1);
         _loc2_.date = StringHelper.s_ReadLongStringFromByteArray(param1);
         _loc2_.show();
      }
      
      private function handleReadError(param1:int, param2:Error) : void
      {
         var _loc3_:int = param2 != null?int(param2.errorID):-1;
         this.handleConnectionError(256 + param1,_loc3_,param2);
      }
      
      public function sendCAPPLYCLEARINGCHARM(param1:uint) : void
      {
         var b:ByteArray = null;
         var a_SlotNumber:uint = param1;
         try
         {
            b = this.m_ServerConnection.messageWriter.createMessage();
            b.writeByte(CAPPLYCLEARINGCHARM);
            b.writeByte(a_SlotNumber);
            this.m_ServerConnection.messageWriter.finishMessage();
            return;
         }
         catch(e:Error)
         {
            handleSendError(CAPPLYCLEARINGCHARM,e);
            return;
         }
      }
      
      public function sendCGETTRANSACTIONHISTORY(param1:int, param2:int) : void
      {
         var b:ByteArray = null;
         var a_CurrentPage:int = param1;
         var a_EntriesPerPage:int = param2;
         try
         {
            b = this.m_ServerConnection.messageWriter.createMessage();
            b.writeByte(CGETTRANSACTIONHISTORY);
            b.writeUnsignedInt(a_CurrentPage);
            b.writeByte(a_EntriesPerPage);
            this.m_ServerConnection.messageWriter.finishMessage();
            return;
         }
         catch(e:Error)
         {
            handleSendError(CGETTRANSACTIONHISTORY,e);
            return;
         }
      }
      
      protected function readSBOTTOMROW(param1:ByteArray) : void
      {
         var _loc2_:Vector3D = this.m_WorldMapStorage.getPosition();
         _loc2_.y++;
         this.m_WorldMapStorage.setPosition(_loc2_.x,_loc2_.y,_loc2_.z);
         this.m_MiniMapStorage.setPosition(_loc2_.x,_loc2_.y,_loc2_.z);
         this.m_WorldMapStorage.scrollMap(0,-1);
         this.m_WorldMapStorage.invalidateOnscreenMessages();
         this.readArea(param1,0,MAPSIZE_Y - 1,MAPSIZE_X - 1,MAPSIZE_Y - 1);
      }
      
      protected function readSDELETEINVENTORY(param1:ByteArray) : void
      {
         var _loc2_:int = param1.readUnsignedByte();
         var _loc3_:BodyContainerView = this.m_ContainerStorage.getBodyContainerView();
         if(_loc3_ != null)
         {
            _loc3_.setObject(_loc2_,null);
         }
      }
      
      protected function readSSETTACTICS(param1:ByteArray) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:OptionsStorage = null;
         _loc2_ = param1.readUnsignedByte();
         _loc3_ = param1.readUnsignedByte();
         _loc4_ = param1.readUnsignedByte();
         _loc5_ = param1.readUnsignedByte();
         _loc6_ = Tibia.s_GetOptions();
         if(_loc6_ != null)
         {
            _loc6_.combatAttackMode = _loc2_;
            _loc6_.combatChaseMode = _loc3_;
            _loc6_.combatSecureMode = _loc4_;
            _loc6_.combatPVPMode = _loc5_;
         }
      }
      
      protected function readSUSEDELAY(param1:ByteArray) : void
      {
         this.m_ContainerStorage.setMultiUseDelay(param1.readUnsignedInt());
      }
      
      public function sendCLOOK(param1:int, param2:int, param3:int, param4:int, param5:int) : void
      {
         var b:ByteArray = null;
         var a_X:int = param1;
         var a_Y:int = param2;
         var a_Z:int = param3;
         var a_TypeID:int = param4;
         var a_Position:int = param5;
         try
         {
            b = this.m_ServerConnection.messageWriter.createMessage();
            b.writeByte(CLOOK);
            b.writeShort(a_X);
            b.writeShort(a_Y);
            b.writeByte(a_Z);
            b.writeShort(a_TypeID);
            b.writeByte(a_Position);
            this.m_ServerConnection.messageWriter.finishMessage();
            return;
         }
         catch(e:Error)
         {
            handleSendError(CLOOK,e);
            return;
         }
      }
      
      protected function readSPRIVATECHANNEL(param1:ByteArray) : void
      {
         var _loc2_:String = null;
         _loc2_ = StringHelper.s_ReadLongStringFromByteArray(param1,Creature.MAX_NAME_LENGHT);
         this.m_ChatStorage.addChannel(_loc2_,_loc2_,MessageMode.MESSAGE_PRIVATE_TO);
      }
      
      protected function readSINSPECTIONLIST(param1:ByteArray) : void
      {
         throw new Error("Connection.readSINSPECTIONLIST: Invalid Message for Flash-Client.");
      }
      
      protected function readSQUESTLINE(param1:ByteArray) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Array = null;
         var _loc5_:int = 0;
         var _loc6_:uint = 0;
         var _loc7_:String = null;
         var _loc8_:String = null;
         var _loc9_:QuestLogWidget = null;
         _loc2_ = param1.readUnsignedShort();
         _loc3_ = param1.readUnsignedByte();
         _loc4_ = new Array();
         _loc5_ = 0;
         while(_loc5_ < _loc3_)
         {
            _loc6_ = param1.readUnsignedShort();
            _loc7_ = StringHelper.s_ReadLongStringFromByteArray(param1,QuestFlag.MAX_NAME_LENGTH);
            _loc8_ = StringHelper.s_ReadLongStringFromByteArray(param1,QuestFlag.MAX_DESCRIPTION_LENGTH);
            _loc4_.push(new QuestFlag(_loc7_,_loc8_));
            _loc5_++;
         }
         if(this.m_PendingQuestLine == _loc2_)
         {
            _loc9_ = PopUpBase.getCurrent() as QuestLogWidget;
            if(_loc9_ != null)
            {
               _loc9_.questFlags = _loc4_;
            }
            this.m_PendingQuestLine = -1;
         }
      }
      
      protected function readSTUTORIALHINT(param1:ByteArray) : void
      {
         var _loc2_:int = 0;
         var _loc3_:TutorialHint = null;
         _loc2_ = param1.readUnsignedByte();
         log("Connection.readSTUTORIALHINT: " + _loc2_);
         _loc3_ = new TutorialHint(_loc2_);
         _loc3_.perform();
      }
      
      protected function readSPREYREROLLPRICE(param1:ByteArray) : void
      {
         PreyManager.getInstance().listRerollPrice = param1.readUnsignedInt();
      }
      
      public function sendCTALK(param1:int, ... rest) : void
      {
         var b:ByteArray = null;
         var a_Mode:int = param1;
         var a_Parameters:Array = rest;
         try
         {
            b = this.m_ServerConnection.messageWriter.createMessage();
            b.writeByte(CTALK);
            b.writeByte(a_Mode);
            if(a_Parameters.length == 1 && a_Parameters[0] is String)
            {
               StringHelper.s_WriteToByteArray(b,a_Parameters[0] as String,ChatStorage.MAX_TALK_LENGTH);
            }
            else if(a_Parameters.length == 2 && a_Parameters[0] is String && a_Parameters[1] is String)
            {
               StringHelper.s_WriteToByteArray(b,a_Parameters[0] as String,Creature.MAX_NAME_LENGHT);
               StringHelper.s_WriteToByteArray(b,a_Parameters[1] as String,ChatStorage.MAX_TALK_LENGTH);
            }
            else if(a_Parameters.length == 2 && a_Parameters[0] is Number && a_Parameters[1] is String)
            {
               b.writeShort(a_Parameters[0] as Number);
               StringHelper.s_WriteToByteArray(b,a_Parameters[1] as String,ChatStorage.MAX_TALK_LENGTH);
            }
            else
            {
               throw new Error("Connection.sendCTALK: Invalid overloaded call.",0);
            }
            this.m_ServerConnection.messageWriter.finishMessage();
            return;
         }
         catch(e:Error)
         {
            handleSendError(CTALK,e);
            return;
         }
      }
      
      public function sendCTRADEOBJECT(param1:int, param2:int, param3:int, param4:int, param5:int, param6:int) : void
      {
         var b:ByteArray = null;
         var a_X:int = param1;
         var a_Y:int = param2;
         var a_Z:int = param3;
         var a_ObjectType:int = param4;
         var a_Position:int = param5;
         var a_TradePartner:int = param6;
         try
         {
            this.m_Player.stopAutowalk(false);
            b = this.m_ServerConnection.messageWriter.createMessage();
            b.writeByte(CTRADEOBJECT);
            b.writeShort(a_X);
            b.writeShort(a_Y);
            b.writeByte(a_Z);
            b.writeShort(a_ObjectType);
            b.writeByte(a_Position);
            b.writeUnsignedInt(a_TradePartner);
            this.m_ServerConnection.messageWriter.finishMessage();
            return;
         }
         catch(e:Error)
         {
            handleSendError(CTRADEOBJECT,e);
            return;
         }
      }
      
      protected function readSCREATURESPEED(param1:ByteArray) : void
      {
         var _loc2_:int = 0;
         _loc2_ = param1.readUnsignedInt();
         var _loc3_:int = param1.readUnsignedShort();
         var _loc4_:int = param1.readUnsignedShort();
         var _loc5_:Creature = this.m_CreatureStorage.getCreature(_loc2_);
         if(_loc5_ != null)
         {
            _loc5_.setSkill(SKILL_GOSTRENGTH,_loc4_,_loc3_,0);
         }
         this.m_CreatureStorage.invalidateOpponents();
      }
      
      protected function readSINGAMESHOPERROR(param1:ByteArray) : void
      {
         var _loc2_:int = 0;
         var _loc3_:String = null;
         _loc2_ = param1.readUnsignedByte();
         _loc3_ = StringHelper.s_ReadLongStringFromByteArray(param1);
         IngameShopManager.getInstance().propagateError(_loc3_,_loc2_);
      }
      
      public function sendCMARKETCANCEL(param1:Offer) : void
      {
         var b:ByteArray = null;
         var a_Offer:Offer = param1;
         try
         {
            b = this.m_ServerConnection.messageWriter.createMessage();
            b.writeByte(CMARKETCANCEL);
            b.writeUnsignedInt(a_Offer.offerID.timestamp);
            b.writeShort(a_Offer.offerID.counter);
            this.m_ServerConnection.messageWriter.finishMessage();
            return;
         }
         catch(e:Error)
         {
            handleSendError(CMARKETCANCEL,e);
            return;
         }
      }
      
      public function get allowBugreports() : Boolean
      {
         return this.m_BugreportsAllowed;
      }
      
      public function sendCEDITTEXT(param1:int, param2:String) : void
      {
         var b:ByteArray = null;
         var a_ID:int = param1;
         var a_Text:String = param2;
         try
         {
            b = this.m_ServerConnection.messageWriter.createMessage();
            b.writeByte(CEDITTEXT);
            b.writeUnsignedInt(a_ID);
            StringHelper.s_WriteToByteArray(b,a_Text);
            this.m_ServerConnection.messageWriter.finishMessage();
            return;
         }
         catch(e:Error)
         {
            handleSendError(CEDITTEXT,e);
            return;
         }
      }
      
      public function sendCEXCLUDEFROMCHANNEL(param1:String, param2:int) : void
      {
         var b:ByteArray = null;
         var a_Name:String = param1;
         var a_ChannelID:int = param2;
         try
         {
            b = this.m_ServerConnection.messageWriter.createMessage();
            b.writeByte(CEXCLUDEFROMCHANNEL);
            StringHelper.s_WriteToByteArray(b,a_Name,Creature.MAX_NAME_LENGHT);
            b.writeShort(a_ChannelID);
            this.m_ServerConnection.messageWriter.finishMessage();
            return;
         }
         catch(e:Error)
         {
            handleSendError(CEXCLUDEFROMCHANNEL,e);
            return;
         }
      }
      
      protected function readImbuementData(param1:ByteArray) : ImbuementData
      {
         var _loc2_:uint = 0;
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc8_:* = false;
         var _loc9_:uint = 0;
         var _loc10_:Vector.<AstralSource> = null;
         var _loc11_:uint = 0;
         var _loc12_:uint = 0;
         var _loc13_:uint = 0;
         var _loc14_:uint = 0;
         var _loc15_:ImbuementData = null;
         var _loc16_:uint = 0;
         var _loc17_:String = null;
         var _loc18_:uint = 0;
         var _loc19_:AstralSource = null;
         _loc2_ = param1.readUnsignedInt();
         _loc3_ = StringHelper.s_ReadLongStringFromByteArray(param1);
         _loc4_ = StringHelper.s_ReadLongStringFromByteArray(param1);
         _loc5_ = StringHelper.s_ReadLongStringFromByteArray(param1);
         _loc6_ = param1.readUnsignedShort();
         _loc7_ = param1.readUnsignedInt();
         _loc8_ = param1.readUnsignedByte() != 0;
         _loc9_ = param1.readUnsignedByte();
         _loc10_ = new Vector.<AstralSource>();
         _loc11_ = 0;
         while(_loc11_ < _loc9_)
         {
            _loc16_ = param1.readUnsignedShort();
            _loc17_ = StringHelper.s_ReadLongStringFromByteArray(param1);
            _loc18_ = param1.readUnsignedShort();
            _loc19_ = new AstralSource(_loc16_,_loc18_,_loc17_);
            _loc10_.push(_loc19_);
            _loc11_++;
         }
         _loc12_ = param1.readUnsignedInt();
         _loc13_ = param1.readUnsignedByte();
         _loc14_ = param1.readUnsignedInt();
         _loc15_ = new ImbuementData(_loc2_,_loc3_);
         _loc15_.description = _loc4_;
         _loc15_.category = _loc5_;
         _loc15_.iconID = _loc6_;
         _loc15_.durationInSeconds = _loc7_;
         _loc15_.premiumOnly = _loc8_;
         _loc15_.goldCost = _loc12_;
         _loc15_.protectionGoldCost = _loc14_;
         _loc15_.successRatePercent = _loc13_;
         _loc15_.astralSources = _loc10_;
         return _loc15_;
      }
      
      public function sendCMARKETBROWSE(param1:int) : void
      {
         var b:ByteArray = null;
         var a_TypeID:int = param1;
         try
         {
            b = this.m_ServerConnection.messageWriter.createMessage();
            b.writeByte(CMARKETBROWSE);
            b.writeShort(a_TypeID);
            this.m_ServerConnection.messageWriter.finishMessage();
            return;
         }
         catch(e:Error)
         {
            handleSendError(CMARKETBROWSE,e);
            return;
         }
      }
      
      protected function readField(param1:ByteArray, param2:int, param3:int, param4:int) : int
      {
         var _loc12_:int = 0;
         var _loc5_:Boolean = false;
         var _loc6_:Vector3D = new Vector3D(param2,param3,param4);
         var _loc7_:Vector3D = this.m_WorldMapStorage.toAbsolute(_loc6_);
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:ObjectInstance = null;
         var _loc11_:Creature = null;
         while(true)
         {
            _loc12_ = param1.readUnsignedShort();
            if(_loc12_ >= 65280)
            {
               break;
            }
            if(!_loc5_)
            {
               _loc10_ = this.m_AppearanceStorage.createEnvironmentalEffect(_loc12_);
               this.m_WorldMapStorage.setEnvironmentalEffect(param2,param3,param4,_loc10_);
               _loc5_ = true;
            }
            else
            {
               if(_loc12_ == AppearanceInstance.UNKNOWNCREATURE || _loc12_ == AppearanceInstance.OUTDATEDCREATURE || _loc12_ == AppearanceInstance.CREATURE)
               {
                  _loc11_ = this.readCreatureInstance(param1,_loc12_,_loc7_);
                  _loc10_ = this.m_AppearanceStorage.createObjectInstance(AppearanceInstance.CREATURE,_loc11_.ID);
                  if(_loc8_ < MAPSIZE_W)
                  {
                     this.m_WorldMapStorage.appendObject(param2,param3,param4,_loc10_);
                  }
               }
               else
               {
                  _loc10_ = this.readObjectInstance(param1,_loc12_);
                  if(_loc8_ < MAPSIZE_W)
                  {
                     this.m_WorldMapStorage.appendObject(param2,param3,param4,_loc10_);
                  }
                  else
                  {
                     throw new Error("Connection.readField: Expected creatures but received regular object.",2147483618);
                  }
               }
               _loc8_++;
            }
         }
         _loc9_ = _loc12_ - 65280;
         return _loc9_;
      }
      
      protected function readDouble(param1:ByteArray) : Number
      {
         var _loc2_:uint = param1.readUnsignedByte();
         var _loc3_:uint = param1.readUnsignedInt();
         return (_loc3_ - int.MAX_VALUE) / Math.pow(10,_loc2_);
      }
      
      public function sendCINSPECTTRADE(param1:int, param2:int) : void
      {
         var b:ByteArray = null;
         var a_Side:int = param1;
         var a_Position:int = param2;
         try
         {
            b = this.m_ServerConnection.messageWriter.createMessage();
            b.writeByte(CLOOKTRADE);
            b.writeByte(a_Side);
            b.writeByte(a_Position);
            this.m_ServerConnection.messageWriter.finishMessage();
            return;
         }
         catch(e:Error)
         {
            handleSendError(CLOOKTRADE,e);
            return;
         }
      }
      
      public function messageProcessingFinished(param1:Boolean = true) : void
      {
         this.m_WorldMapStorage.refreshFields();
         if(param1)
         {
            this.m_MiniMapStorage.refreshSectors();
         }
         this.m_CreatureStorage.refreshOpponents();
      }
      
      public function get isPending() : Boolean
      {
         return this.m_ServerConnection.isPending;
      }
      
      protected function readSSWITCHPRESET(param1:ByteArray) : void
      {
         var _loc2_:int = 0;
         var _loc3_:OptionsStorage = null;
         _loc2_ = param1.readUnsignedInt();
         _loc3_ = Tibia.s_GetOptions();
         if(_loc3_ != null)
         {
            switch(_loc2_)
            {
               case PROFESSION_KNIGHT:
                  _loc3_.setMappingAndActionBarSets("Knight");
                  break;
               case PROFESSION_PALADIN:
                  _loc3_.setMappingAndActionBarSets("Paladin");
                  break;
               case PROFESSION_SORCERER:
                  _loc3_.setMappingAndActionBarSets("Sorcerer");
                  break;
               case PROFESSION_DRUID:
                  _loc3_.setMappingAndActionBarSets("Druid");
                  break;
               default:
                  throw new ArgumentError("readSSWITCHPRESET: Invalid preset id");
            }
         }
      }
      
      protected function readSigned64BitValue(param1:ByteArray) : Number
      {
         var _loc2_:uint = param1.readUnsignedInt();
         var _loc3_:uint = param1.readUnsignedInt();
         if((_loc3_ & 2145386496) != 0)
         {
            throw new RangeError("Connection.readSigned64BitValue: Value out of range.");
         }
         var _loc4_:Number = Number(_loc2_) + Number(_loc3_ & 2097151) * Math.pow(2,32);
         if((_loc3_ & 2147483648) != 0)
         {
            return -_loc4_;
         }
         return Number(_loc4_);
      }
      
      protected function readSPLAYERDATACURRENT(param1:ByteArray) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:uint = 0;
         var _loc12_:Boolean = false;
         _loc2_ = Tibia.s_FrameTibiaTimestamp;
         _loc3_ = 0;
         _loc4_ = 0;
         _loc5_ = 0;
         _loc3_ = Math.max(0,param1.readShort());
         _loc4_ = Math.max(0,param1.readShort());
         _loc5_ = 0;
         this.m_Player.setSkill(SKILL_HITPOINTS,_loc3_,_loc4_,_loc5_);
         _loc3_ = Math.max(0,param1.readInt());
         _loc4_ = Math.max(0,param1.readInt());
         _loc5_ = 0;
         this.m_Player.setSkill(SKILL_CARRYSTRENGTH,_loc3_,_loc4_,_loc5_);
         _loc3_ = this.readSigned64BitValue(param1);
         _loc4_ = 1;
         _loc5_ = 0;
         this.m_Player.setSkill(SKILL_EXPERIENCE,_loc3_,_loc4_,_loc5_);
         _loc3_ = param1.readUnsignedShort();
         _loc4_ = 1;
         _loc5_ = param1.readUnsignedByte();
         this.m_Player.setSkill(SKILL_LEVEL,_loc3_,_loc4_,_loc5_);
         _loc6_ = param1.readUnsignedShort() / 100;
         _loc7_ = param1.readUnsignedShort() / 100;
         _loc8_ = param1.readUnsignedShort() / 100;
         _loc9_ = param1.readUnsignedShort() / 100;
         _loc10_ = param1.readUnsignedShort() / 100;
         this.m_Player.experienceGainInfo.updateGainInfo(_loc6_,_loc7_,_loc8_,_loc9_,_loc10_);
         _loc3_ = Math.max(0,param1.readShort());
         _loc4_ = Math.max(0,param1.readShort());
         _loc5_ = 0;
         this.m_Player.setSkill(SKILL_MANA,_loc3_,_loc4_,_loc5_);
         _loc3_ = param1.readUnsignedByte();
         _loc4_ = param1.readUnsignedByte();
         _loc5_ = param1.readUnsignedByte();
         this.m_Player.setSkill(SKILL_MAGLEVEL,_loc3_,_loc4_,_loc5_);
         _loc3_ = param1.readUnsignedByte();
         _loc4_ = 1;
         _loc5_ = 0;
         this.m_Player.setSkill(SKILL_SOULPOINTS,_loc3_,_loc4_,_loc5_);
         _loc3_ = _loc2_ + 60 * 1000 * param1.readUnsignedShort();
         _loc4_ = _loc2_;
         _loc5_ = 0;
         this.m_Player.setSkill(SKILL_STAMINA,_loc3_,_loc4_,_loc5_);
         _loc3_ = this.m_Player.getSkillValue(SKILL_GOSTRENGTH);
         _loc4_ = param1.readUnsignedShort();
         _loc5_ = 0;
         this.m_Player.setSkill(SKILL_GOSTRENGTH,_loc3_,_loc4_,_loc5_);
         _loc3_ = _loc2_ + 1000 * param1.readUnsignedShort();
         _loc4_ = _loc2_;
         _loc5_ = 0;
         this.m_Player.setSkill(SKILL_FED,_loc3_,_loc4_,_loc5_);
         _loc3_ = _loc2_ + 60 * 1000 * param1.readUnsignedShort();
         _loc4_ = _loc2_;
         _loc5_ = 0;
         this.m_Player.setSkill(SKILL_OFFLINETRAINING,_loc3_,_loc4_,_loc5_);
         _loc11_ = param1.readUnsignedShort();
         _loc12_ = param1.readBoolean();
         this.m_Player.experienceGainInfo.updateStoreXpBoost(_loc11_,_loc12_);
      }
      
      protected function readSOWNOFFER(param1:ByteArray) : void
      {
         var _loc8_:SafeTradeWidget = null;
         var _loc2_:String = StringHelper.s_ReadLongStringFromByteArray(param1,Creature.MAX_NAME_LENGHT);
         var _loc3_:int = param1.readUnsignedByte();
         var _loc4_:IList = new ArrayCollection();
         var _loc5_:int = 0;
         while(_loc5_ < _loc3_)
         {
            _loc4_.addItem(this.readObjectInstance(param1));
            _loc5_++;
         }
         var _loc6_:OptionsStorage = Tibia.s_GetOptions();
         var _loc7_:SideBarSet = null;
         if(_loc6_ != null && (_loc7_ = _loc6_.getSideBarSet(SideBarSet.DEFAULT_SET)) != null)
         {
            _loc8_ = _loc7_.getWidgetByType(Widget.TYPE_SAFETRADE) as SafeTradeWidget;
            if(_loc8_ == null)
            {
               _loc8_ = _loc7_.showWidgetType(Widget.TYPE_SAFETRADE,-1,-1) as SafeTradeWidget;
            }
            _loc8_.ownName = _loc2_;
            _loc8_.ownItems = _loc4_;
         }
      }
      
      protected function readSMOVECREATURE(param1:ByteArray) : void
      {
         var _loc10_:Vector3D = null;
         var _loc15_:int = 0;
         var _loc2_:int = param1.readUnsignedShort();
         var _loc3_:Vector3D = null;
         var _loc4_:Vector3D = null;
         var _loc5_:int = -1;
         var _loc6_:ObjectInstance = null;
         var _loc7_:Creature = null;
         if(_loc2_ != 65535)
         {
            _loc3_ = this.readCoordinate(param1,_loc2_);
            if(!this.m_WorldMapStorage.isVisible(_loc3_.x,_loc3_.y,_loc3_.z,true))
            {
               throw new Error("Connection.readSMOVECREATURE: Start co-ordinate " + _loc3_ + " is invalid.",0);
            }
            _loc4_ = this.m_WorldMapStorage.toMap(_loc3_);
            _loc5_ = param1.readUnsignedByte();
            if((_loc6_ = this.m_WorldMapStorage.getObject(_loc4_.x,_loc4_.y,_loc4_.z,_loc5_)) == null || _loc6_.ID != AppearanceInstance.CREATURE || (_loc7_ = this.m_CreatureStorage.getCreature(_loc6_.data)) == null)
            {
               throw new Error("Connection.readSMOVECREATURE: No creature at position " + _loc3_ + ", index " + _loc5_ + ".",1);
            }
         }
         else
         {
            _loc15_ = param1.readUnsignedInt();
            _loc6_ = this.m_AppearanceStorage.createObjectInstance(AppearanceInstance.CREATURE,_loc15_);
            if((_loc7_ = this.m_CreatureStorage.getCreature(_loc15_)) == null)
            {
               throw new Error("Connection.readSMOVECREATURE: Creature " + _loc15_ + " not found.",2);
            }
            _loc3_ = _loc7_.position;
            if(!this.m_WorldMapStorage.isVisible(_loc3_.x,_loc3_.y,_loc3_.z,true))
            {
               throw new Error("Connection.readSMOVECREATURE: Start co-ordinate " + _loc3_ + " is invalid.",3);
            }
            _loc4_ = this.m_WorldMapStorage.toMap(_loc3_);
         }
         var _loc8_:Vector3D = this.readCoordinate(param1);
         if(!this.m_WorldMapStorage.isVisible(_loc8_.x,_loc8_.y,_loc8_.z,true))
         {
            throw new Error("Connection.readSMOVECREATURE: Target co-ordinate " + _loc8_ + " is invalid.",4);
         }
         var _loc9_:Vector3D = this.m_WorldMapStorage.toMap(_loc8_);
         _loc10_ = _loc8_.sub(_loc3_);
         var _loc11_:Boolean = _loc10_.z != 0 || Math.abs(_loc10_.x) > 1 || Math.abs(_loc10_.y) > 1;
         var _loc12_:ObjectInstance = null;
         if(!_loc11_ && ((_loc12_ = this.m_WorldMapStorage.getObject(_loc9_.x,_loc9_.y,_loc9_.z,0)) == null || _loc12_.m_Type == null || !_loc12_.m_Type.isBank))
         {
            throw new Error("Connection.readSMOVECREATURE: Target field " + _loc8_ + " has no BANK.",5);
         }
         if(_loc2_ != 65535)
         {
            this.m_WorldMapStorage.deleteObject(_loc4_.x,_loc4_.y,_loc4_.z,_loc5_);
         }
         this.m_WorldMapStorage.putObject(_loc9_.x,_loc9_.y,_loc9_.z,_loc6_);
         _loc7_.setPosition(_loc8_.x,_loc8_.y,_loc8_.z);
         if(_loc11_)
         {
            if(_loc7_.ID == this.m_Player.ID)
            {
               Player(_loc7_).stopAutowalk(true);
            }
            if(_loc10_.x > 0)
            {
               _loc7_.direction = 1;
            }
            else if(_loc10_.x < 0)
            {
               _loc7_.direction = 3;
            }
            else if(_loc10_.y < 0)
            {
               _loc7_.direction = 0;
            }
            else if(_loc10_.y > 0)
            {
               _loc7_.direction = 2;
            }
            if(_loc7_.ID != this.m_Player.ID)
            {
               _loc7_.stopMovementAnimation();
            }
         }
         else
         {
            _loc7_.startMovementAnimation(_loc10_.x,_loc10_.y,_loc12_.m_Type.waypoints);
         }
         this.m_CreatureStorage.markOpponentVisible(_loc7_,true);
         this.m_CreatureStorage.invalidateOpponents();
         var _loc13_:uint = 0;
         var _loc14_:int = 0;
         if(_loc3_.z == this.m_MiniMapStorage.getPositionZ())
         {
            this.m_WorldMapStorage.updateMiniMap(_loc4_.x,_loc4_.y,_loc4_.z);
            _loc13_ = this.m_WorldMapStorage.getMiniMapColour(_loc4_.x,_loc4_.y,_loc4_.z);
            _loc14_ = this.m_WorldMapStorage.getMiniMapCost(_loc4_.x,_loc4_.y,_loc4_.z);
            this.m_MiniMapStorage.updateField(_loc3_.x,_loc3_.y,_loc3_.z,_loc13_,_loc14_,false);
         }
         if(_loc8_.z == this.m_MiniMapStorage.getPositionZ())
         {
            this.m_WorldMapStorage.updateMiniMap(_loc9_.x,_loc9_.y,_loc9_.z);
            _loc13_ = this.m_WorldMapStorage.getMiniMapColour(_loc9_.x,_loc9_.y,_loc9_.z);
            _loc14_ = this.m_WorldMapStorage.getMiniMapCost(_loc9_.x,_loc9_.y,_loc9_.z);
            this.m_MiniMapStorage.updateField(_loc8_.x,_loc8_.y,_loc8_.z,_loc13_,_loc14_,false);
         }
      }
      
      public function sendCMOUNT(param1:Boolean) : void
      {
         var b:ByteArray = null;
         var a_Mount:Boolean = param1;
         try
         {
            b = this.m_ServerConnection.messageWriter.createMessage();
            b.writeByte(CMOUNT);
            b.writeBoolean(a_Mount);
            this.m_ServerConnection.messageWriter.finishMessage();
            return;
         }
         catch(e:Error)
         {
            handleSendError(CMOUNT,e);
            return;
         }
      }
      
      public function sendCCLOSENPCTRADE() : void
      {
         var b:ByteArray = null;
         try
         {
            b = this.m_ServerConnection.messageWriter.createMessage();
            b.writeByte(CCLOSENPCTRADE);
            this.m_ServerConnection.messageWriter.finishMessage();
            return;
         }
         catch(e:Error)
         {
            handleSendError(CCLOSENPCTRADE,e);
            return;
         }
      }
      
      protected function readSSETSTOREDEEPLINK(param1:ByteArray) : void
      {
         var _loc2_:int = 0;
         _loc2_ = param1.readUnsignedByte();
         IngameShopManager.getInstance().currentlyFeaturedServiceType = _loc2_;
      }
      
      public function sendCSELLOBJECT(param1:int, param2:int, param3:int, param4:Boolean) : void
      {
         var b:ByteArray = null;
         var a_Type:int = param1;
         var a_Data:int = param2;
         var a_Amount:int = param3;
         var a_KeepEquipped:Boolean = param4;
         try
         {
            b = this.m_ServerConnection.messageWriter.createMessage();
            b.writeByte(CSELLOBJECT);
            b.writeShort(a_Type);
            b.writeByte(a_Data);
            b.writeByte(a_Amount);
            b.writeBoolean(a_KeepEquipped);
            this.m_ServerConnection.messageWriter.finishMessage();
            return;
         }
         catch(e:Error)
         {
            handleSendError(CSELLOBJECT,e);
            return;
         }
      }
      
      protected function readSBOTTOMFLOOR(param1:ByteArray) : void
      {
         var _loc2_:Vector3D = null;
         var _loc3_:Vector3D = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         _loc2_ = this.m_WorldMapStorage.getPosition();
         _loc2_.x--;
         _loc2_.y--;
         _loc2_.z++;
         this.m_WorldMapStorage.setPosition(_loc2_.x,_loc2_.y,_loc2_.z);
         this.m_MiniMapStorage.setPosition(_loc2_.x,_loc2_.y,_loc2_.z);
         if(_loc2_.z > GROUND_LAYER + 1)
         {
            this.m_WorldMapStorage.scrollMap(0,0,1);
            if(_loc2_.z <= MAP_MAX_Z - UNDERGROUND_LAYER)
            {
               this.readFloor(param1,0);
            }
         }
         else if(_loc2_.z == GROUND_LAYER + 1)
         {
            this.m_WorldMapStorage.scrollMap(0,0,UNDERGROUND_LAYER + 1);
            _loc7_ = 0;
            _loc8_ = UNDERGROUND_LAYER;
            while(_loc8_ >= 0)
            {
               _loc7_ = this.readFloor(param1,_loc8_,_loc7_);
               _loc8_--;
            }
         }
         this.m_Player.stopAutowalk(true);
         this.m_WorldMapStorage.invalidateOnscreenMessages();
         _loc3_ = this.m_WorldMapStorage.toMap(_loc2_);
         _loc4_ = 0;
         _loc5_ = 0;
         _loc6_ = 0;
         while(_loc6_ < MAPSIZE_X)
         {
            _loc9_ = 0;
            while(_loc9_ < MAPSIZE_Y)
            {
               _loc3_.x = _loc6_;
               _loc3_.y = _loc9_;
               _loc2_ = this.m_WorldMapStorage.toAbsolute(_loc3_,_loc2_);
               this.m_WorldMapStorage.updateMiniMap(_loc3_.x,_loc3_.y,_loc3_.z);
               _loc4_ = this.m_WorldMapStorage.getMiniMapColour(_loc3_.x,_loc3_.y,_loc3_.z);
               _loc5_ = this.m_WorldMapStorage.getMiniMapCost(_loc3_.x,_loc3_.y,_loc3_.z);
               this.m_MiniMapStorage.updateField(_loc2_.x,_loc2_.y,_loc2_.z,_loc4_,_loc5_,false);
               _loc9_++;
            }
            _loc6_++;
         }
      }
      
      protected function readSGRAPHICALEFFECT(param1:ByteArray) : void
      {
         var _loc2_:Vector3D = this.readCoordinate(param1);
         var _loc3_:EffectInstance = this.m_AppearanceStorage.createEffectInstance(param1.readUnsignedByte());
         this.m_WorldMapStorage.appendEffect(_loc2_.x,_loc2_.y,_loc2_.z,_loc3_);
      }
      
      public function sendCFOLLOW(param1:int) : void
      {
         var b:ByteArray = null;
         var a_CreatureID:int = param1;
         try
         {
            if(a_CreatureID != 0)
            {
               this.m_Player.stopAutowalk(false);
            }
            b = this.m_ServerConnection.messageWriter.createMessage();
            b.writeByte(CFOLLOW);
            b.writeInt(a_CreatureID);
            b.writeInt(a_CreatureID);
            this.m_ServerConnection.messageWriter.finishMessage();
            return;
         }
         catch(e:Error)
         {
            handleSendError(CFOLLOW,e);
            return;
         }
      }
      
      public function sendCBUGREPORT(param1:int, param2:String, param3:* = null) : void
      {
         var Message:String = null;
         var b:ByteArray = null;
         var Coordinate:Vector3D = null;
         var TypoSpeaker:String = null;
         var TypoText:String = null;
         var a_BugCategory:int = param1;
         var a_UserMessage:String = param2;
         var a_BugInformation:* = param3;
         try
         {
            Message = "";
            if(a_UserMessage != null)
            {
               Message = Message + a_UserMessage.substr(0,BugReportWidget.MAX_USER_MESSAGE_LENGTH);
            }
            Message = Message + ("\nClient-Version=" + CLIENT_VERSION);
            Message = Message + ("\nBrowser=" + BrowserHelper.s_GetBrowserString());
            Message = Message + ("\nFlash=" + Capabilities.serverString);
            if(Message.length > BugReportWidget.MAX_TOTAL_MESSAGE_LENGTH)
            {
               Message = Message.substr(0,BugReportWidget.MAX_TOTAL_MESSAGE_LENGTH);
            }
            b = this.m_ServerConnection.messageWriter.createMessage();
            b.writeByte(CBUGREPORT);
            b.writeByte(a_BugCategory);
            StringHelper.s_WriteToByteArray(b,Message);
            if(a_BugCategory == BugReportWidget.BUG_CATEGORY_MAP)
            {
               Coordinate = this.m_Player.getPosition();
               if(a_BugInformation is Vector3D)
               {
                  Coordinate = a_BugInformation as Vector3D;
               }
               b.writeShort(Coordinate.x);
               b.writeShort(Coordinate.y);
               b.writeByte(Coordinate.z);
            }
            else if(a_BugCategory == BugReportWidget.BUG_CATEGORY_TYPO)
            {
               TypoSpeaker = "";
               TypoText = "";
               if(a_BugInformation is BugReportTypo)
               {
                  TypoSpeaker = (a_BugInformation as BugReportTypo).Speaker;
                  TypoText = (a_BugInformation as BugReportTypo).Text;
               }
               StringHelper.s_WriteToByteArray(b,TypoSpeaker != null?TypoSpeaker:"");
               StringHelper.s_WriteToByteArray(b,TypoText != null?TypoText:"");
            }
            this.m_ServerConnection.messageWriter.finishMessage();
            return;
         }
         catch(e:Error)
         {
            handleSendError(CBUGREPORT,e);
            return;
         }
      }
      
      protected function readSUNJUSTIFIEDPOINTS(param1:ByteArray) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         _loc2_ = param1.readUnsignedByte();
         _loc3_ = param1.readUnsignedByte();
         _loc4_ = param1.readUnsignedByte();
         _loc5_ = param1.readUnsignedByte();
         _loc6_ = param1.readUnsignedByte();
         _loc7_ = param1.readUnsignedByte();
         _loc8_ = param1.readUnsignedByte();
         this.m_Player.unjustPoints = new UnjustPointsInfo(_loc2_,_loc3_,_loc4_,_loc5_,_loc6_,_loc7_,_loc8_);
      }
      
      protected function readDailyReward(param1:ByteArray) : void
      {
         var _loc2_:int = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:String = null;
         var _loc8_:uint = 0;
         var _loc9_:uint = 0;
         var _loc10_:int = 0;
         var _loc11_:uint = 0;
         var _loc12_:uint = 0;
         _loc2_ = param1.readUnsignedByte();
         if(_loc2_ == 1)
         {
            _loc3_ = param1.readUnsignedByte();
            _loc4_ = param1.readUnsignedByte();
            _loc5_ = 0;
            while(_loc5_ < _loc4_)
            {
               _loc6_ = param1.readUnsignedShort();
               _loc7_ = StringHelper.s_ReadLongStringFromByteArray(param1);
               _loc8_ = param1.readUnsignedInt();
               _loc5_++;
            }
         }
         else if(_loc2_ == 2)
         {
            _loc9_ = param1.readUnsignedByte();
            _loc5_ = 0;
            while(_loc5_ < _loc9_)
            {
               _loc10_ = param1.readUnsignedByte();
               if(_loc10_ == 1)
               {
                  _loc6_ = param1.readUnsignedShort();
                  _loc7_ = StringHelper.s_ReadLongStringFromByteArray(param1);
                  _loc11_ = param1.readUnsignedByte();
               }
               else if(_loc10_ == 2)
               {
                  _loc11_ = param1.readUnsignedByte();
               }
               else if(_loc10_ == 3)
               {
                  _loc12_ = param1.readUnsignedShort();
               }
               _loc5_++;
            }
         }
      }
      
      protected function readSSETINVENTORY(param1:ByteArray) : void
      {
         var _loc2_:int = param1.readUnsignedByte();
         var _loc3_:ObjectInstance = this.readObjectInstance(param1);
         var _loc4_:BodyContainerView = this.m_ContainerStorage.getBodyContainerView();
         if(_loc4_ != null)
         {
            _loc4_.setObject(_loc2_,_loc3_);
         }
      }
      
      public function sendCOPENTRANSACTIONHISTORY(param1:int) : void
      {
         var b:ByteArray = null;
         var a_EntriesPerPage:int = param1;
         try
         {
            b = this.m_ServerConnection.messageWriter.createMessage();
            b.writeByte(COPENTRANSACTIONHISTORY);
            b.writeByte(a_EntriesPerPage);
            this.m_ServerConnection.messageWriter.finishMessage();
            return;
         }
         catch(e:Error)
         {
            handleSendError(COPENTRANSACTIONHISTORY,e);
            return;
         }
      }
      
      public function sendCANSWERMODALDIALOG(param1:uint, param2:int, param3:int) : void
      {
         var b:ByteArray = null;
         var a_ID:uint = param1;
         var a_Button:int = param2;
         var a_Choice:int = param3;
         try
         {
            b = this.m_ServerConnection.messageWriter.createMessage();
            b.writeByte(CANSWERMODALDIALOG);
            b.writeUnsignedInt(a_ID);
            b.writeByte(a_Button);
            b.writeByte(a_Choice);
            this.m_ServerConnection.messageWriter.finishMessage();
            return;
         }
         catch(e:Error)
         {
            handleSendError(CANSWERMODALDIALOG,e);
            return;
         }
      }
      
      public function sendCMARKETLEAVE() : void
      {
         var b:ByteArray = null;
         try
         {
            b = this.m_ServerConnection.messageWriter.createMessage();
            b.writeByte(CMARKETLEAVE);
            this.m_ServerConnection.messageWriter.finishMessage();
            return;
         }
         catch(e:Error)
         {
            handleSendError(CMARKETLEAVE,e);
            return;
         }
      }
      
      protected function readSEDITGUILDMESSAGE(param1:ByteArray) : void
      {
         var _loc2_:SimpleEditTextWidget = null;
         _loc2_ = new SimpleEditTextWidget();
         _loc2_.ID = 0;
         _loc2_.maxChars = ChatStorage.MAX_GUILD_MOTD_LENGTH;
         _loc2_.text = StringHelper.s_ReadLongStringFromByteArray(param1,ChatStorage.MAX_GUILD_MOTD_LENGTH);
         _loc2_.show();
      }
      
      protected function readArea(param1:ByteArray, param2:int, param3:int, param4:int, param5:int) : int
      {
         var _loc15_:int = 0;
         var _loc16_:int = 0;
         var _loc6_:Vector3D = this.m_WorldMapStorage.getPosition();
         var _loc7_:Vector3D = new Vector3D();
         var _loc8_:Vector3D = new Vector3D();
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         if(_loc6_.z <= GROUND_LAYER)
         {
            _loc9_ = 0;
            _loc10_ = GROUND_LAYER + 1;
            _loc11_ = 1;
         }
         else
         {
            _loc9_ = 2 * UNDERGROUND_LAYER;
            _loc10_ = Math.max(-1,_loc6_.z - MAP_MAX_Z + 1);
            _loc11_ = -1;
         }
         var _loc12_:int = 0;
         var _loc13_:uint = 0;
         var _loc14_:int = 0;
         while(_loc9_ != _loc10_)
         {
            _loc15_ = param2;
            while(_loc15_ <= param4)
            {
               _loc16_ = param3;
               while(_loc16_ <= param5)
               {
                  if(_loc12_ > 0)
                  {
                     _loc12_--;
                  }
                  else
                  {
                     _loc12_ = this.readField(param1,_loc15_,_loc16_,_loc9_);
                  }
                  _loc7_.setComponents(_loc15_,_loc16_,_loc9_);
                  this.m_WorldMapStorage.toAbsolute(_loc7_,_loc8_);
                  if(_loc8_.z == this.m_MiniMapStorage.getPositionZ())
                  {
                     this.m_WorldMapStorage.updateMiniMap(_loc15_,_loc16_,_loc9_);
                     _loc13_ = this.m_WorldMapStorage.getMiniMapColour(_loc15_,_loc16_,_loc9_);
                     _loc14_ = this.m_WorldMapStorage.getMiniMapCost(_loc15_,_loc16_,_loc9_);
                     this.m_MiniMapStorage.updateField(_loc8_.x,_loc8_.y,_loc8_.z,_loc13_,_loc14_,false);
                  }
                  _loc16_++;
               }
               _loc15_++;
            }
            _loc9_ = _loc9_ + _loc11_;
         }
         return _loc12_;
      }
      
      protected function readSOPENOWNCHANNEL(param1:ByteArray) : void
      {
         var _loc2_:int = 0;
         var _loc3_:String = null;
         var _loc4_:Channel = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:String = null;
         var _loc10_:String = null;
         _loc2_ = param1.readUnsignedShort();
         _loc3_ = StringHelper.s_ReadLongStringFromByteArray(param1,Channel.MAX_NAME_LENGTH);
         _loc4_ = this.m_ChatStorage.addChannel(_loc2_,_loc3_,MessageMode.MESSAGE_CHANNEL);
         _loc4_.canModerate = true;
         if(_loc4_.isPrivate)
         {
            this.m_ChatStorage.ownPrivateChannelID = _loc2_;
         }
         _loc5_ = param1.readUnsignedShort();
         _loc6_ = 0;
         while(_loc6_ < _loc5_)
         {
            _loc9_ = StringHelper.s_ReadLongStringFromByteArray(param1,Creature.MAX_NAME_LENGHT);
            _loc4_.playerJoined(_loc9_);
            _loc6_++;
         }
         _loc7_ = param1.readUnsignedShort();
         _loc8_ = 0;
         while(_loc8_ < _loc7_)
         {
            _loc10_ = StringHelper.s_ReadLongStringFromByteArray(param1,Creature.MAX_NAME_LENGHT);
            _loc4_.playerInvited(_loc10_);
            _loc8_++;
         }
      }
      
      protected function readSCREDITBALANCE(param1:ByteArray) : void
      {
         var _loc2_:* = false;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         _loc2_ = param1.readUnsignedByte() == 1;
         _loc3_ = Number.NaN;
         _loc4_ = Number.NaN;
         if(_loc2_)
         {
            _loc3_ = param1.readInt();
            _loc4_ = param1.readInt();
         }
         IngameShopManager.getInstance().setCreditBalance(_loc3_,_loc4_);
      }
      
      public function sendCSHAREEXPERIENCE(param1:Boolean) : void
      {
         var b:ByteArray = null;
         var a_Enabled:Boolean = param1;
         try
         {
            b = this.m_ServerConnection.messageWriter.createMessage();
            b.writeByte(CSHAREEXPERIENCE);
            b.writeBoolean(a_Enabled);
            this.m_ServerConnection.messageWriter.finishMessage();
            return;
         }
         catch(e:Error)
         {
            handleSendError(CSHAREEXPERIENCE,e);
            return;
         }
      }
      
      protected function readSCHANGEINCONTAINER(param1:ByteArray) : void
      {
         var _loc2_:int = 0;
         _loc2_ = param1.readUnsignedByte();
         var _loc3_:int = param1.readUnsignedShort();
         var _loc4_:ObjectInstance = this.readObjectInstance(param1);
         var _loc5_:ContainerView = this.m_ContainerStorage.getContainerView(_loc2_);
         if(_loc5_ != null)
         {
            _loc5_.changeObject(_loc3_,_loc4_);
         }
      }
      
      protected function readSAMBIENTE(param1:ByteArray) : void
      {
         var _loc2_:int = param1.readUnsignedByte();
         var _loc3_:Colour = Colour.s_FromEightBit(param1.readUnsignedByte());
         this.m_WorldMapStorage.setAmbientLight(_loc3_,_loc2_);
      }
      
      protected function readSBLESSINGS(param1:ByteArray) : void
      {
         var _loc2_:uint = 0;
         _loc2_ = param1.readUnsignedShort();
         if(this.m_Player != null)
         {
            this.m_Player.blessings = _loc2_;
         }
         var _loc3_:uint = param1.readUnsignedByte();
      }
      
      protected function readSBLESSINGSDIALOG(param1:ByteArray) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc13_:uint = 0;
         var _loc14_:uint = 0;
         var _loc15_:uint = 0;
         var _loc16_:uint = 0;
         var _loc17_:uint = 0;
         var _loc18_:String = null;
         _loc2_ = param1.readUnsignedByte();
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            _loc14_ = param1.readUnsignedShort();
            _loc15_ = param1.readUnsignedByte();
            _loc3_++;
         }
         var _loc4_:Boolean = param1.readBoolean();
         var _loc5_:uint = param1.readUnsignedByte();
         var _loc6_:uint = param1.readUnsignedByte();
         var _loc7_:uint = param1.readUnsignedByte();
         var _loc8_:uint = param1.readUnsignedByte();
         var _loc9_:uint = param1.readUnsignedByte();
         var _loc10_:uint = param1.readUnsignedByte();
         var _loc11_:Boolean = param1.readBoolean();
         var _loc12_:Boolean = param1.readBoolean();
         _loc13_ = param1.readUnsignedByte();
         _loc3_ = 0;
         while(_loc3_ < _loc13_)
         {
            _loc16_ = param1.readUnsignedInt();
            _loc17_ = param1.readUnsignedByte();
            _loc18_ = StringHelper.s_ReadLongStringFromByteArray(param1);
            _loc3_++;
         }
      }
      
      protected function readSPLAYERGOODS(param1:ByteArray) : void
      {
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc2_:Number = this.readSigned64BitValue(param1);
         var _loc3_:Vector.<InventoryTypeInfo> = new Vector.<InventoryTypeInfo>();
         var _loc4_:int = param1.readUnsignedByte() - 1;
         while(_loc4_ >= 0)
         {
            _loc5_ = param1.readUnsignedShort();
            _loc6_ = param1.readUnsignedByte();
            _loc3_.push(new InventoryTypeInfo(_loc5_,0,_loc6_));
            _loc4_--;
         }
         this.m_ContainerStorage.setPlayerGoods(_loc3_);
         this.m_ContainerStorage.setPlayerMoney(_loc2_);
      }
      
      protected function readSINGAMESHOPSUCCESS(param1:ByteArray) : void
      {
         var _loc3_:String = null;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc2_:int = param1.readUnsignedByte();
         _loc3_ = StringHelper.s_ReadLongStringFromByteArray(param1);
         _loc4_ = param1.readInt();
         _loc5_ = param1.readInt();
         IngameShopManager.getInstance().completePurchase(_loc3_);
         IngameShopManager.getInstance().setCreditBalance(_loc4_,_loc5_);
      }
      
      protected function readSPREYDATA(param1:ByteArray) : void
      {
         var _loc2_:PreyManager = null;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:String = null;
         var _loc6_:AppearanceInstance = null;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         var _loc9_:uint = 0;
         var _loc10_:uint = 0;
         var _loc11_:Vector.<PreyMonsterInformation> = null;
         var _loc12_:uint = 0;
         _loc2_ = PreyManager.getInstance();
         _loc3_ = param1.readUnsignedByte();
         _loc4_ = param1.readUnsignedByte();
         if(_loc4_ == PreyData.STATE_LOCKED)
         {
            _loc2_.changeStateToLocked(_loc3_,param1.readUnsignedByte());
         }
         else if(_loc4_ == PreyData.STATE_INACTIVE)
         {
            _loc2_.changeStateToInactive(_loc3_);
         }
         else if(_loc4_ == PreyData.STATE_ACTIVE)
         {
            _loc5_ = StringHelper.s_ReadLongStringFromByteArray(param1);
            _loc6_ = this.readCreatureOutfit(param1,null);
            _loc7_ = param1.readUnsignedByte();
            _loc8_ = param1.readUnsignedShort();
            _loc9_ = param1.readUnsignedByte();
            _loc2_.changeStateToActive(_loc3_,_loc7_,_loc8_,_loc9_,new PreyMonsterInformation(_loc5_,_loc6_));
            _loc2_.setPreyTimeLeft(_loc3_,param1.readUnsignedShort());
         }
         else if(_loc4_ == PreyData.STATE_SELECTION)
         {
            _loc10_ = param1.readUnsignedByte();
            _loc11_ = new Vector.<PreyMonsterInformation>();
            _loc12_ = 0;
            while(_loc12_ < _loc10_)
            {
               _loc5_ = StringHelper.s_ReadLongStringFromByteArray(param1);
               _loc6_ = this.readCreatureOutfit(param1,null);
               _loc11_.push(new PreyMonsterInformation(_loc5_,_loc6_));
               _loc12_++;
            }
            _loc2_.changeStateToSelection(_loc3_,_loc11_);
         }
         else if(_loc4_ == PreyData.STATE_SELECTION_CHANGE_MONSTER)
         {
            _loc7_ = param1.readUnsignedByte();
            _loc8_ = param1.readUnsignedShort();
            _loc9_ = param1.readUnsignedByte();
            _loc10_ = param1.readUnsignedByte();
            _loc11_ = new Vector.<PreyMonsterInformation>();
            _loc12_ = 0;
            while(_loc12_ < _loc10_)
            {
               _loc5_ = StringHelper.s_ReadLongStringFromByteArray(param1);
               _loc6_ = this.readCreatureOutfit(param1,null);
               _loc11_.push(new PreyMonsterInformation(_loc5_,_loc6_));
               _loc12_++;
            }
            _loc2_.changeStateToSelectionChangeMonster(_loc3_,_loc7_,_loc8_,_loc9_,_loc11_);
         }
         _loc2_.setTimeUntilFreeListReroll(_loc3_,param1.readUnsignedShort());
      }
      
      public function sendCGETOUTFIT() : void
      {
         var b:ByteArray = null;
         try
         {
            b = this.m_ServerConnection.messageWriter.createMessage();
            b.writeByte(CGETOUTFIT);
            this.m_ServerConnection.messageWriter.finishMessage();
            return;
         }
         catch(e:Error)
         {
            handleSendError(CGETOUTFIT,e);
            return;
         }
      }
      
      protected function readSBUDDYGROUPDATA(param1:ByteArray) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:int = 0;
         _loc2_ = param1.readByte();
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            param1.readByte();
            StringHelper.s_ReadLongStringFromByteArray(param1);
            param1.readBoolean();
            _loc3_++;
         }
         param1.readByte();
      }
      
      public function sendCREQUESTSHOPOFFERS(param1:String) : void
      {
         var b:ByteArray = null;
         var a_CategoryName:String = param1;
         try
         {
            b = this.m_ServerConnection.messageWriter.createMessage();
            b.writeByte(CREQUESTSHOPOFFERS);
            b.writeByte(IngameShopProduct.SERVICE_TYPE_UNKNOWN);
            StringHelper.s_WriteToByteArray(b,a_CategoryName);
            this.m_ServerConnection.messageWriter.finishMessage();
            return;
         }
         catch(e:Error)
         {
            handleSendError(CREQUESTSHOPOFFERS,e);
            return;
         }
      }
      
      protected function readSUPDATINGSHOPBALANCE(param1:ByteArray) : void
      {
         var _loc2_:* = false;
         _loc2_ = param1.readUnsignedByte() == 1;
         IngameShopManager.getInstance().setCreditBalanceUpdating(_loc2_);
      }
      
      protected function readSIMBUINGDIALOGREFRESH(param1:ByteArray) : void
      {
         var _loc2_:ImbuingManager = null;
         var _loc3_:ImbuementData = null;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:Vector.<ExistingImbuement> = null;
         var _loc7_:uint = 0;
         var _loc8_:Vector.<ImbuementData> = null;
         var _loc9_:uint = 0;
         var _loc10_:uint = 0;
         var _loc11_:Vector.<AstralSource> = null;
         var _loc12_:uint = 0;
         var _loc13_:uint = 0;
         var _loc14_:ExistingImbuement = null;
         var _loc15_:* = false;
         var _loc16_:uint = 0;
         var _loc17_:uint = 0;
         var _loc18_:uint = 0;
         var _loc19_:uint = 0;
         var _loc20_:AstralSource = null;
         _loc2_ = ImbuingManager.getInstance();
         _loc3_ = null;
         _loc4_ = param1.readUnsignedShort();
         _loc5_ = param1.readUnsignedByte();
         _loc6_ = new Vector.<ExistingImbuement>();
         _loc7_ = 0;
         while(_loc7_ < _loc5_)
         {
            _loc15_ = param1.readUnsignedByte() != 0;
            if(_loc15_)
            {
               _loc3_ = this.readImbuementData(param1);
               _loc16_ = param1.readUnsignedInt();
               _loc17_ = param1.readUnsignedInt();
               _loc14_ = new ExistingImbuement(_loc3_,_loc16_,_loc17_);
            }
            else
            {
               _loc14_ = new ExistingImbuement();
            }
            _loc6_.push(_loc14_);
            _loc7_++;
         }
         _loc8_ = new Vector.<ImbuementData>();
         _loc9_ = param1.readUnsignedShort();
         _loc10_ = 0;
         while(_loc10_ < _loc9_)
         {
            _loc3_ = this.readImbuementData(param1);
            _loc8_.push(_loc3_);
            _loc10_++;
         }
         _loc11_ = new Vector.<AstralSource>();
         _loc12_ = param1.readUnsignedInt();
         _loc13_ = 0;
         while(_loc13_ < _loc12_)
         {
            _loc18_ = param1.readUnsignedShort();
            _loc19_ = param1.readUnsignedShort();
            _loc20_ = new AstralSource(_loc18_,_loc19_);
            _loc11_.push(_loc20_);
            _loc13_++;
         }
         _loc2_.openImbuingWindow();
         _loc2_.refreshImbuingData(_loc4_,_loc6_,_loc8_,_loc11_);
      }
      
      protected function readSITEMLOOTED(param1:ByteArray) : void
      {
         var _loc2_:ObjectInstance = this.readObjectInstance(param1);
         var _loc3_:String = StringHelper.s_ReadLongStringFromByteArray(param1);
      }
      
      public function sendCSETOUTFIT(param1:int, param2:int, param3:int, param4:int, param5:int, param6:int, param7:int) : void
      {
         var b:ByteArray = null;
         var a_PlayerOutfit:int = param1;
         var a_Colour0:int = param2;
         var a_Colour1:int = param3;
         var a_Colour2:int = param4;
         var a_Colour3:int = param5;
         var a_Addons:int = param6;
         var a_MountOutfit:int = param7;
         try
         {
            b = this.m_ServerConnection.messageWriter.createMessage();
            b.writeByte(CSETOUTFIT);
            b.writeShort(a_PlayerOutfit);
            b.writeByte(a_Colour0);
            b.writeByte(a_Colour1);
            b.writeByte(a_Colour2);
            b.writeByte(a_Colour3);
            b.writeByte(a_Addons);
            b.writeShort(a_MountOutfit);
            this.m_ServerConnection.messageWriter.finishMessage();
            return;
         }
         catch(e:Error)
         {
            handleSendError(CSETOUTFIT,e);
            return;
         }
      }
      
      protected function readSDEAD(param1:ByteArray) : void
      {
         var _loc5_:Number = NaN;
         var _loc2_:ConnectionEvent = new ConnectionEvent(ConnectionEvent.DEAD);
         _loc2_.message = null;
         var _loc3_:int = param1.readUnsignedByte();
         if(_loc3_ == 0)
         {
            _loc5_ = param1.readUnsignedByte();
            if(_loc5_ < 100)
            {
               _loc2_.data = {
                  "type":ConnectionEvent.DEATH_UNFAIR,
                  "fairFightFactor":_loc5_
               };
            }
            else
            {
               _loc2_.data = {
                  "type":ConnectionEvent.DEATH_REGULAR,
                  "fairFightFactor":0
               };
            }
         }
         else if(_loc3_ == 1)
         {
            _loc2_.data = {
               "type":ConnectionEvent.DEATH_BLESSED,
               "fairFightFactor":0
            };
         }
         else if(_loc3_ == 2)
         {
            _loc2_.data = {
               "type":ConnectionEvent.DEATH_NOPENALTY,
               "fairFightFactor":0
            };
         }
         else
         {
            throw new Error("Connection.readSDEAD: Invalid death type " + _loc3_);
         }
         var _loc4_:Boolean = param1.readBoolean();
         this.m_ServerConnection.dispatchEvent(_loc2_);
      }
      
      public function get beatDuration() : int
      {
         return this.m_BeatDuration;
      }
      
      public function sendCMARKETCREATE(param1:int, param2:int, param3:int, param4:uint, param5:Boolean) : void
      {
         var b:ByteArray = null;
         var a_Kind:int = param1;
         var a_TypeID:int = param2;
         var a_Amount:int = param3;
         var a_PiecePrice:uint = param4;
         var a_IsAnonymous:Boolean = param5;
         try
         {
            b = this.m_ServerConnection.messageWriter.createMessage();
            b.writeByte(CMARKETCREATE);
            b.writeByte(a_Kind);
            b.writeShort(a_TypeID);
            b.writeShort(a_Amount);
            b.writeUnsignedInt(a_PiecePrice);
            b.writeBoolean(a_IsAnonymous);
            this.m_ServerConnection.messageWriter.finishMessage();
            return;
         }
         catch(e:Error)
         {
            handleSendError(CMARKETCREATE,e);
            return;
         }
      }
      
      protected function readSCHANNELEVENT(param1:ByteArray) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Channel = null;
         var _loc4_:String = null;
         var _loc5_:int = 0;
         _loc2_ = param1.readUnsignedShort();
         _loc3_ = this.m_ChatStorage.getChannel(_loc2_);
         _loc4_ = StringHelper.s_ReadLongStringFromByteArray(param1,Creature.MAX_NAME_LENGHT);
         _loc5_ = param1.readUnsignedByte();
         if(_loc3_ != null && _loc4_ != null)
         {
            switch(_loc5_)
            {
               case 0:
                  _loc3_.playerJoined(_loc4_);
                  break;
               case 1:
                  _loc3_.playerLeft(_loc4_);
                  break;
               case 2:
                  _loc3_.playerInvited(_loc4_);
                  break;
               case 3:
                  _loc3_.playerExcluded(_loc4_);
                  break;
               case 4:
                  _loc3_.playerPending(_loc4_);
            }
         }
      }
      
      public function sendCEDITGUILDMESSAGE(param1:String) : void
      {
         var b:ByteArray = null;
         var a_Text:String = param1;
         try
         {
            b = this.m_ServerConnection.messageWriter.createMessage();
            b.writeByte(CEDITGUILDMESSAGE);
            StringHelper.s_WriteToByteArray(b,a_Text,ChatStorage.MAX_GUILD_MOTD_LENGTH);
            this.m_ServerConnection.messageWriter.finishMessage();
            return;
         }
         catch(e:Error)
         {
            handleSendError(CPRIVATECHANNEL,e);
            return;
         }
      }
      
      public function sendCCLOSEDIMBUINGDIALOG() : void
      {
         var b:ByteArray = null;
         try
         {
            b = this.m_ServerConnection.messageWriter.createMessage();
            b.writeByte(CCLOSEDIMBUINGDIALOG);
            this.m_ServerConnection.messageWriter.finishMessage();
            return;
         }
         catch(e:Error)
         {
            handleSendError(CCLOSEDIMBUINGDIALOG,e);
            return;
         }
      }
      
      protected function sendCQUITGAME() : void
      {
         var b:ByteArray = null;
         try
         {
            b = this.m_ServerConnection.messageWriter.createMessage();
            b.writeByte(CQUITGAME);
            this.m_ServerConnection.messageWriter.finishMessage();
            return;
         }
         catch(e:Error)
         {
            handleSendError(CQUITGAME,e);
            return;
         }
      }
      
      protected function readSREQUESTPURCHASEDATA(param1:ByteArray) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         _loc2_ = param1.readUnsignedInt();
         _loc3_ = param1.readUnsignedByte();
         if(_loc3_ == IngameShopProduct.SERVICE_TYPE_CHARACTER_NAME_CHANGE)
         {
            IngameShopManager.getInstance().requestNameForNameChange(_loc2_);
         }
      }
      
      public function sendCMARKETACCEPT(param1:Offer, param2:int) : void
      {
         var b:ByteArray = null;
         var a_Offer:Offer = param1;
         var a_Amount:int = param2;
         try
         {
            b = this.m_ServerConnection.messageWriter.createMessage();
            b.writeByte(CMARKETACCEPT);
            b.writeUnsignedInt(a_Offer.offerID.timestamp);
            b.writeShort(a_Offer.offerID.counter);
            b.writeShort(a_Amount);
            this.m_ServerConnection.messageWriter.finishMessage();
            return;
         }
         catch(e:Error)
         {
            handleSendError(CMARKETACCEPT,e);
            return;
         }
      }
      
      public function sendCADDBUDDY(param1:String) : void
      {
         var b:ByteArray = null;
         var a_Name:String = param1;
         try
         {
            b = this.m_ServerConnection.messageWriter.createMessage();
            b.writeByte(CADDBUDDY);
            StringHelper.s_WriteToByteArray(b,a_Name,Creature.MAX_NAME_LENGHT);
            this.m_ServerConnection.messageWriter.finishMessage();
            return;
         }
         catch(e:Error)
         {
            handleSendError(CADDBUDDY,e);
            return;
         }
      }
      
      public function sendCEDITBUDDY(param1:int, param2:String, param3:uint, param4:Boolean) : void
      {
         var b:ByteArray = null;
         var a_ID:int = param1;
         var a_Description:String = param2;
         var a_Icon:uint = param3;
         var a_Notify:Boolean = param4;
         try
         {
            b = this.m_ServerConnection.messageWriter.createMessage();
            b.writeByte(CEDITBUDDY);
            b.writeUnsignedInt(a_ID);
            StringHelper.s_WriteToByteArray(b,a_Description,Creature.MAX_DESCRIPTION_LENGHT);
            b.writeUnsignedInt(a_Icon);
            b.writeBoolean(a_Notify);
            this.m_ServerConnection.messageWriter.finishMessage();
            return;
         }
         catch(e:Error)
         {
            handleSendError(CEDITBUDDY,e);
            return;
         }
      }
      
      protected function readSCONTAINER(param1:ByteArray) : void
      {
         var _loc14_:ObjectInstance = null;
         var _loc2_:int = param1.readUnsignedByte();
         var _loc3_:ObjectInstance = this.readObjectInstance(param1);
         var _loc4_:String = StringHelper.s_Capitalise(StringHelper.s_ReadLongStringFromByteArray(param1,ContainerStorage.MAX_NAME_LENGTH));
         var _loc5_:int = param1.readUnsignedByte();
         var _loc6_:* = param1.readUnsignedByte() != 0;
         var _loc7_:* = param1.readUnsignedByte() != 0;
         var _loc8_:* = param1.readUnsignedByte() != 0;
         var _loc9_:int = param1.readUnsignedShort();
         var _loc10_:int = param1.readUnsignedShort();
         var _loc11_:int = param1.readUnsignedByte();
         if(_loc11_ > _loc5_)
         {
            throw new Error("Connection.readSCONTAINER: Number of content objects " + _loc11_ + " exceeds number of slots per page " + _loc5_,0);
         }
         if(_loc11_ > _loc9_)
         {
            throw new Error("Connection.readSCONTAINER: Number of content objects " + _loc11_ + " exceeds number of total objects " + _loc9_,1);
         }
         var _loc12_:ContainerView = this.m_ContainerStorage.createContainerView(_loc2_,_loc3_,_loc4_,_loc6_,_loc7_,_loc8_,_loc5_,_loc9_ - _loc11_,_loc10_);
         if(_loc12_ == null)
         {
            throw new Error("Connection.readSCONTAINER: Failed to create view.",2);
         }
         var _loc13_:int = 0;
         while(_loc13_ < _loc11_)
         {
            _loc14_ = this.readObjectInstance(param1);
            _loc12_.addObject(_loc10_ + _loc13_,_loc14_);
            _loc13_++;
         }
      }
      
      public function sendCROTATEWEST() : void
      {
         var b:ByteArray = null;
         try
         {
            b = this.m_ServerConnection.messageWriter.createMessage();
            b.writeByte(CROTATEWEST);
            this.m_ServerConnection.messageWriter.finishMessage();
            return;
         }
         catch(e:Error)
         {
            handleSendError(CROTATEWEST,e);
            return;
         }
      }
      
      protected function readSCREATUREPARTY(param1:ByteArray) : void
      {
         var _loc2_:int = 0;
         _loc2_ = param1.readUnsignedInt();
         var _loc3_:int = param1.readUnsignedByte();
         var _loc4_:Creature = this.m_CreatureStorage.getCreature(_loc2_);
         if(_loc4_ != null)
         {
            _loc4_.setPartyFlag(_loc3_);
         }
         this.m_CreatureStorage.invalidateOpponents();
      }
      
      public function sendCUPCONTAINER(param1:int) : void
      {
         var b:ByteArray = null;
         var a_ID:int = param1;
         try
         {
            b = this.m_ServerConnection.messageWriter.createMessage();
            b.writeByte(CUPCONTAINER);
            b.writeByte(a_ID);
            this.m_ServerConnection.messageWriter.finishMessage();
            return;
         }
         catch(e:Error)
         {
            handleSendError(CUPCONTAINER,e);
            return;
         }
      }
      
      public function sendNameCRULEVIOLATIONREPORT(param1:int, param2:String, param3:String, param4:String) : void
      {
         var b:ByteArray = null;
         var a_Reason:int = param1;
         var a_CharacterName:String = param2;
         var a_Comment:String = param3;
         var a_Translation:String = param4;
         try
         {
            if(a_Translation == null)
            {
               a_Translation = "";
            }
            b = this.m_ServerConnection.messageWriter.createMessage();
            b.writeByte(CRULEVIOLATIONREPORT);
            b.writeByte(Type.REPORT_NAME);
            b.writeByte(a_Reason);
            StringHelper.s_WriteToByteArray(b,a_CharacterName,Creature.MAX_NAME_LENGHT);
            StringHelper.s_WriteToByteArray(b,a_Comment,ReportWidget.MAX_COMMENT_LENGTH);
            StringHelper.s_WriteToByteArray(b,a_Translation,ReportWidget.MAX_TRANSLATION_LENGTH);
            this.m_ServerConnection.messageWriter.finishMessage();
            return;
         }
         catch(e:Error)
         {
            handleSendError(CRULEVIOLATIONREPORT,e);
            return;
         }
      }
      
      public function readMessage(param1:IMessageReader) : void
      {
         var Type:int = 0;
         var a_MessageReader:IMessageReader = param1;
         Type = a_MessageReader.messageType;
         var CommunicationData:ByteArray = a_MessageReader.inputBuffer;
         try
         {
            switch(Type)
            {
               case SPENDINGSTATEENTERED:
                  this.readSPENDINGSTATEENTERED(CommunicationData);
                  a_MessageReader.finishMessage();
                  break;
               case SWORLDENTERED:
                  this.readSWORLDENTERED(CommunicationData);
                  a_MessageReader.finishMessage();
                  break;
               case SLOGINSUCCESS:
                  this.readSLOGINSUCCESS(CommunicationData);
                  a_MessageReader.finishMessage();
                  break;
               case SSTOREBUTTONINDICATORS:
                  this.readSSTOREBUTTONINDICATORS(CommunicationData);
                  a_MessageReader.finishMessage();
                  break;
               case SDEAD:
                  this.readSDEAD(CommunicationData);
                  a_MessageReader.finishMessage();
                  break;
               case SCLIENTCHECK:
                  this.readSCLIENTCHECK(CommunicationData);
                  a_MessageReader.finishMessage();
                  break;
               case SFULLMAP:
                  this.readSFULLMAP(CommunicationData);
                  a_MessageReader.finishMessage();
                  break;
               case STOPROW:
                  this.readSTOPROW(CommunicationData);
                  a_MessageReader.finishMessage();
                  break;
               case SRIGHTROW:
                  this.readSRIGHTROW(CommunicationData);
                  a_MessageReader.finishMessage();
                  break;
               case SBOTTOMROW:
                  this.readSBOTTOMROW(CommunicationData);
                  a_MessageReader.finishMessage();
                  break;
               case SLEFTROW:
                  this.readSLEFTROW(CommunicationData);
                  a_MessageReader.finishMessage();
                  break;
               case SFIELDDATA:
                  this.readSFIELDDATA(CommunicationData);
                  a_MessageReader.finishMessage();
                  break;
               case SCREATEONMAP:
                  this.readSCREATEONMAP(CommunicationData);
                  a_MessageReader.finishMessage();
                  break;
               case SCHANGEONMAP:
                  this.readSCHANGEONMAP(CommunicationData);
                  a_MessageReader.finishMessage();
                  break;
               case SDELETEONMAP:
                  this.readSDELETEONMAP(CommunicationData);
                  a_MessageReader.finishMessage();
                  break;
               case SMOVECREATURE:
                  this.readSMOVECREATURE(CommunicationData);
                  a_MessageReader.finishMessage();
                  break;
               case SCONTAINER:
                  this.readSCONTAINER(CommunicationData);
                  a_MessageReader.finishMessage();
                  break;
               case SCLOSECONTAINER:
                  this.readSCLOSECONTAINER(CommunicationData);
                  a_MessageReader.finishMessage();
                  break;
               case SCREATEINCONTAINER:
                  this.readSCREATEINCONTAINER(CommunicationData);
                  a_MessageReader.finishMessage();
                  break;
               case SCHANGEINCONTAINER:
                  this.readSCHANGEINCONTAINER(CommunicationData);
                  a_MessageReader.finishMessage();
                  break;
               case SDELETEINCONTAINER:
                  this.readSDELETEINCONTAINER(CommunicationData);
                  a_MessageReader.finishMessage();
                  break;
               case SINSPECTIONLIST:
                  this.readSINSPECTIONLIST(CommunicationData);
                  a_MessageReader.finishMessage();
                  break;
               case SINSPECTIONSTATE:
                  this.readSINSPECTIONSTATE(CommunicationData);
                  a_MessageReader.finishMessage();
                  break;
               case SSETINVENTORY:
                  this.readSSETINVENTORY(CommunicationData);
                  a_MessageReader.finishMessage();
                  break;
               case SDELETEINVENTORY:
                  this.readSDELETEINVENTORY(CommunicationData);
                  a_MessageReader.finishMessage();
                  break;
               case SNPCOFFER:
                  this.readSNPCOFFER(CommunicationData);
                  a_MessageReader.finishMessage();
                  break;
               case SPLAYERGOODS:
                  this.readSPLAYERGOODS(CommunicationData);
                  a_MessageReader.finishMessage();
                  break;
               case SCLOSENPCTRADE:
                  this.readSCLOSENPCTRADE(CommunicationData);
                  a_MessageReader.finishMessage();
                  break;
               case SOWNOFFER:
                  this.readSOWNOFFER(CommunicationData);
                  a_MessageReader.finishMessage();
                  break;
               case SCOUNTEROFFER:
                  this.readSCOUNTEROFFER(CommunicationData);
                  a_MessageReader.finishMessage();
                  break;
               case SCLOSETRADE:
                  this.readSCLOSETRADE(CommunicationData);
                  a_MessageReader.finishMessage();
                  break;
               case SAMBIENTE:
                  this.readSAMBIENTE(CommunicationData);
                  a_MessageReader.finishMessage();
                  break;
               case SGRAPHICALEFFECT:
                  this.readSGRAPHICALEFFECT(CommunicationData);
                  a_MessageReader.finishMessage();
                  break;
               case SMISSILEEFFECT:
                  this.readSMISSILEEFFECT(CommunicationData);
                  a_MessageReader.finishMessage();
                  break;
               case STRAPPERS:
                  this.readSTRAPPERS(CommunicationData);
                  a_MessageReader.finishMessage();
                  break;
               case SCREATUREHEALTH:
                  this.readSCREATUREHEALTH(CommunicationData);
                  a_MessageReader.finishMessage();
                  break;
               case SCREATURELIGHT:
                  this.readSCREATURELIGHT(CommunicationData);
                  a_MessageReader.finishMessage();
                  break;
               case SCREATUREOUTFIT:
                  this.readSCREATUREOUTFIT(CommunicationData);
                  a_MessageReader.finishMessage();
                  break;
               case SCREATURESPEED:
                  this.readSCREATURESPEED(CommunicationData);
                  a_MessageReader.finishMessage();
                  break;
               case SCREATURESKULL:
                  this.readSCREATURESKULL(CommunicationData);
                  a_MessageReader.finishMessage();
                  break;
               case SCREATUREPARTY:
                  this.readSCREATUREPARTY(CommunicationData);
                  a_MessageReader.finishMessage();
                  break;
               case SCREATUREUNPASS:
                  this.readSCREATUREUNPASS(CommunicationData);
                  a_MessageReader.finishMessage();
                  break;
               case SCREATUREPVPHELPERS:
                  this.readSCREATUREPVPHELPERS(CommunicationData);
                  a_MessageReader.finishMessage();
                  break;
               case SCREATUREMARKS:
                  this.readSCREATUREMARKS(CommunicationData);
                  a_MessageReader.finishMessage();
                  break;
               case SCREATURETYPE:
                  this.readSCREATURETYPE(CommunicationData);
                  a_MessageReader.finishMessage();
                  break;
               case SEDITTEXT:
                  this.readSEDITTEXT(CommunicationData);
                  a_MessageReader.finishMessage();
                  break;
               case SEDITLIST:
                  this.readSEDITLIST(CommunicationData);
                  a_MessageReader.finishMessage();
                  break;
               case SSHOWGAMENEWS:
                  this.readSSHOWGAMENEWS(CommunicationData);
                  a_MessageReader.finishMessage();
                  break;
               case SBLESSINGSDIALOG:
                  this.readSBLESSINGSDIALOG(CommunicationData);
                  a_MessageReader.finishMessage();
                  break;
               case SBLESSINGS:
                  this.readSBLESSINGS(CommunicationData);
                  a_MessageReader.finishMessage();
                  break;
               case SSWITCHPRESET:
                  this.readSSWITCHPRESET(CommunicationData);
                  a_MessageReader.finishMessage();
                  break;
               case SPREMIUMTRIGGER:
                  this.readSPREMIUMTRIGGER(CommunicationData);
                  a_MessageReader.finishMessage();
                  break;
               case SPLAYERDATABASIC:
                  this.readSPLAYERDATABASIC(CommunicationData);
                  a_MessageReader.finishMessage();
                  break;
               case SPLAYERDATACURRENT:
                  this.readSPLAYERDATACURRENT(CommunicationData);
                  a_MessageReader.finishMessage();
                  break;
               case SPLAYERSKILLS:
                  this.readSPLAYERSKILLS(CommunicationData);
                  a_MessageReader.finishMessage();
                  break;
               case SPLAYERSTATE:
                  this.readSPLAYERSTATE(CommunicationData);
                  a_MessageReader.finishMessage();
                  break;
               case SCLEARTARGET:
                  this.readSCLEARTARGET(CommunicationData);
                  a_MessageReader.finishMessage();
                  break;
               case SSPELLDELAY:
                  this.readSSPELLDELAY(CommunicationData);
                  a_MessageReader.finishMessage();
                  break;
               case SSPELLGROUPDELAY:
                  this.readSSPELLGROUPDELAY(CommunicationData);
                  a_MessageReader.finishMessage();
                  break;
               case SMULTIUSEDELAY:
                  this.readSUSEDELAY(CommunicationData);
                  a_MessageReader.finishMessage();
                  break;
               case SSETTACTICS:
                  this.readSSETTACTICS(CommunicationData);
                  a_MessageReader.finishMessage();
                  break;
               case SSETSTOREDEEPLINK:
                  this.readSSETSTOREDEEPLINK(CommunicationData);
                  a_MessageReader.finishMessage();
                  break;
               case SRESTINGAREASTATE:
                  this.readSRESTINGAREASTATE(CommunicationData);
                  a_MessageReader.finishMessage();
                  break;
               case STALK:
                  this.readSTALK(CommunicationData);
                  a_MessageReader.finishMessage();
                  break;
               case SCHANNELS:
                  this.readSCHANNELS(CommunicationData);
                  a_MessageReader.finishMessage();
                  break;
               case SOPENCHANNEL:
                  this.readSOPENCHANNEL(CommunicationData);
                  a_MessageReader.finishMessage();
                  break;
               case SPRIVATECHANNEL:
                  this.readSPRIVATECHANNEL(CommunicationData);
                  a_MessageReader.finishMessage();
                  break;
               case SEDITGUILDMESSAGE:
                  this.readSEDITGUILDMESSAGE(CommunicationData);
                  a_MessageReader.finishMessage();
                  break;
               case SOPENOWNCHANNEL:
                  this.readSOPENOWNCHANNEL(CommunicationData);
                  a_MessageReader.finishMessage();
                  break;
               case SCLOSECHANNEL:
                  this.readSCLOSECHANNEL(CommunicationData);
                  a_MessageReader.finishMessage();
                  break;
               case SMESSAGE:
                  this.readSMESSAGE(CommunicationData);
                  a_MessageReader.finishMessage();
                  break;
               case SSNAPBACK:
                  this.readSSNAPBACK(CommunicationData);
                  a_MessageReader.finishMessage();
                  break;
               case SWAIT:
                  this.readSWAIT(CommunicationData);
                  a_MessageReader.finishMessage();
                  break;
               case SUNJUSTIFIEDPOINTS:
                  this.readSUNJUSTIFIEDPOINTS(CommunicationData);
                  a_MessageReader.finishMessage();
                  break;
               case SPVPSITUATIONS:
                  this.readSPVPSITUATIONS(CommunicationData);
                  a_MessageReader.finishMessage();
                  break;
               case STOPFLOOR:
                  this.readSTOPFLOOR(CommunicationData);
                  a_MessageReader.finishMessage();
                  break;
               case SBOTTOMFLOOR:
                  this.readSBOTTOMFLOOR(CommunicationData);
                  a_MessageReader.finishMessage();
                  break;
               case SOUTFIT:
                  this.readSOUTFIT(CommunicationData);
                  a_MessageReader.finishMessage();
                  break;
               case SIMPACTTRACKING:
                  this.readSIMPACTTRACKING(CommunicationData);
                  a_MessageReader.finishMessage();
                  break;
               case SMARKETSTATISTICS:
                  this.readSMARKETSTATISTICS(CommunicationData);
                  a_MessageReader.finishMessage();
                  break;
               case SITEMWASTED:
                  this.readSITEMWASTED(CommunicationData);
                  a_MessageReader.finishMessage();
                  break;
               case SITEMLOOTED:
                  this.readSITEMLOOTED(CommunicationData);
                  a_MessageReader.finishMessage();
                  break;
               case STRACKEDQUESTFLAGS:
                  this.readSTRACKEDQUESTFLAGS(CommunicationData);
                  a_MessageReader.finishMessage();
                  break;
               case SKILLTRACKING:
                  this.readSKILLTRACKING(CommunicationData);
                  a_MessageReader.finishMessage();
                  break;
               case SBUDDYDATA:
                  this.readSBUDDYDATA(CommunicationData);
                  a_MessageReader.finishMessage();
                  break;
               case SBUDDYSTATUSCHANGE:
                  this.readSBUDDYSTATUSCHANGE(CommunicationData);
                  a_MessageReader.finishMessage();
                  break;
               case SBUDDYGROUPDATA:
                  this.readSBUDDYGROUPDATA(CommunicationData);
                  a_MessageReader.finishMessage();
                  break;
               case STUTORIALHINT:
                  this.readSTUTORIALHINT(CommunicationData);
                  a_MessageReader.finishMessage();
                  break;
               case SAUTOMAPFLAG:
                  this.readSAUTOMAPFLAG(CommunicationData);
                  a_MessageReader.finishMessage();
                  break;
               case SDAILYREWARDCOLLECTIONSTATE:
                  this.readSDAILYREWARDCOLLECTIONSTATE(CommunicationData);
                  a_MessageReader.finishMessage();
                  break;
               case SCREDITBALANCE:
                  this.readSCREDITBALANCE(CommunicationData);
                  a_MessageReader.finishMessage();
                  break;
               case SINGAMESHOPERROR:
                  this.readSINGAMESHOPERROR(CommunicationData);
                  a_MessageReader.finishMessage();
                  break;
               case SREQUESTPURCHASEDATA:
                  this.readSREQUESTPURCHASEDATA(CommunicationData);
                  a_MessageReader.finishMessage();
                  break;
               case SOPENREWARDWALL:
                  this.readSOPENREWARDWALL(CommunicationData);
                  a_MessageReader.finishMessage();
                  break;
               case SCLOSEREWARDWALL:
                  this.readSCLOSEREWARDWALL(CommunicationData);
                  a_MessageReader.finishMessage();
                  break;
               case SDAILYREWARDBASIC:
                  this.readSDAILYREWARDBASIC(CommunicationData);
                  a_MessageReader.finishMessage();
                  break;
               case SDAILYREWARDHISTORY:
                  this.readSDAILYREWARDHISTORYA(CommunicationData);
                  a_MessageReader.finishMessage();
                  break;
               case SPREYFREELISTREROLLAVAILABILITY:
                  this.readSPREYFREELISTREROLLAVAILABILITY(CommunicationData);
                  a_MessageReader.finishMessage();
                  break;
               case SPREYTIMELEFT:
                  this.readSPREYTIMELEFT(CommunicationData);
                  a_MessageReader.finishMessage();
                  break;
               case SPREYDATA:
                  this.readSPREYDATA(CommunicationData);
                  a_MessageReader.finishMessage();
                  break;
               case SPREYREROLLPRICE:
                  this.readSPREYREROLLPRICE(CommunicationData);
                  a_MessageReader.finishMessage();
                  break;
               case SIMBUINGDIALOGREFRESH:
                  this.readSIMBUINGDIALOGREFRESH(CommunicationData);
                  a_MessageReader.finishMessage();
                  break;
               case SSHOWMESSAGEDIALOG:
                  this.readSSHOWMESSAGEDIALOG(CommunicationData);
                  a_MessageReader.finishMessage();
                  break;
               case SCLOSEIMBUINGDIALOG:
                  this.readSCLOSEIMBUINGDIALOG(CommunicationData);
                  a_MessageReader.finishMessage();
                  break;
               case SRESOURCEBALANCE:
                  this.readSRESOURCEBALANCE(CommunicationData);
                  a_MessageReader.finishMessage();
                  break;
               case STIBIATIME:
                  this.readSTIBIATIME(CommunicationData);
                  a_MessageReader.finishMessage();
                  break;
               case SQUESTLOG:
                  this.readSQUESTLOG(CommunicationData);
                  a_MessageReader.finishMessage();
                  break;
               case SQUESTLINE:
                  this.readSQUESTLINE(CommunicationData);
                  a_MessageReader.finishMessage();
                  break;
               case SUPDATINGSHOPBALANCE:
                  this.readSUPDATINGSHOPBALANCE(CommunicationData);
                  a_MessageReader.finishMessage();
                  break;
               case SCHANNELEVENT:
                  this.readSCHANNELEVENT(CommunicationData);
                  a_MessageReader.finishMessage();
                  break;
               case SOBJECTINFO:
                  this.readSOBJECTINFO(CommunicationData);
                  a_MessageReader.finishMessage();
                  break;
               case SPLAYERINVENTORY:
                  this.readSPLAYERINVENTORY(CommunicationData);
                  a_MessageReader.finishMessage();
                  break;
               case SMARKETENTER:
                  this.readSMARKETENTER(CommunicationData);
                  a_MessageReader.finishMessage();
                  break;
               case SMARKETLEAVE:
                  this.readSMARKETLEAVE(CommunicationData);
                  a_MessageReader.finishMessage();
                  break;
               case SMARKETDETAIL:
                  this.readSMARKETDETAIL(CommunicationData);
                  a_MessageReader.finishMessage();
                  break;
               case SMARKETBROWSE:
                  this.readSMARKETBROWSE(CommunicationData);
                  a_MessageReader.finishMessage();
                  break;
               case SSHOWMODALDIALOG:
                  this.readSSHOWMODALDIALOG(CommunicationData);
                  a_MessageReader.finishMessage();
                  break;
               case SPREMIUMSHOP:
                  this.readSPREMIUMSHOP(CommunicationData);
                  a_MessageReader.finishMessage();
                  break;
               case SPREMIUMSHOPOFFERS:
                  this.readSPREMIUMSHOPOFFERS(CommunicationData);
                  a_MessageReader.finishMessage();
                  break;
               case STRANSACTIONHISTORY:
                  this.readSTRANSACTIONHISTORY(CommunicationData);
                  a_MessageReader.finishMessage();
                  break;
               case SINGAMESHOPSUCCESS:
                  this.readSINGAMESHOPSUCCESS(CommunicationData);
                  a_MessageReader.finishMessage();
                  break;
               default:
                  return;
            }
            return;
         }
         catch(_Error:Error)
         {
            handleReadError(Type,_Error);
            return;
         }
      }
      
      protected function readSTRACKEDQUESTFLAGS(param1:ByteArray) : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:String = null;
         var _loc8_:String = null;
         var _loc9_:String = null;
         _loc2_ = param1.readBoolean();
         if(_loc2_)
         {
            _loc3_ = param1.readUnsignedByte();
            _loc4_ = param1.readUnsignedByte();
            _loc5_ = 0;
            while(_loc5_ < _loc4_)
            {
               _loc6_ = param1.readUnsignedShort();
               _loc7_ = StringHelper.s_ReadLongStringFromByteArray(param1);
               _loc8_ = StringHelper.s_ReadLongStringFromByteArray(param1);
               _loc9_ = StringHelper.s_ReadLongStringFromByteArray(param1);
               _loc5_++;
            }
         }
         else
         {
            _loc6_ = param1.readUnsignedShort();
            _loc8_ = StringHelper.s_ReadLongStringFromByteArray(param1);
            _loc9_ = StringHelper.s_ReadLongStringFromByteArray(param1);
         }
      }
      
      public function sendCSETTACTICS(param1:int, param2:int, param3:int, param4:uint) : void
      {
         var b:ByteArray = null;
         var a_AttackMode:int = param1;
         var a_ChaseMode:int = param2;
         var a_SecureMode:int = param3;
         var a_PVPMode:uint = param4;
         try
         {
            b = this.m_ServerConnection.messageWriter.createMessage();
            b.writeByte(CSETTACTICS);
            b.writeByte(a_AttackMode);
            b.writeByte(a_ChaseMode);
            b.writeByte(a_SecureMode);
            b.writeByte(a_PVPMode);
            this.m_ServerConnection.messageWriter.finishMessage();
            return;
         }
         catch(e:Error)
         {
            handleSendError(CSETTACTICS,e);
            return;
         }
      }
      
      public function sendCPERFORMANCEMETRICS(param1:AccumulatingCounter, param2:AccumulatingCounter) : void
      {
         var b:ByteArray = null;
         var FLASH_FPS_LIMIT:uint = 0;
         var a_ObjectCounter:AccumulatingCounter = param1;
         var a_FpsCounter:AccumulatingCounter = param2;
         try
         {
            b = this.m_ServerConnection.messageWriter.createMessage();
            b.writeByte(CPERFORMANCEMETRICS);
            b.writeShort(a_ObjectCounter.minimum);
            b.writeShort(a_ObjectCounter.maximum);
            b.writeShort(a_ObjectCounter.average);
            b.writeShort(a_FpsCounter.minimum);
            b.writeShort(a_FpsCounter.maximum);
            b.writeShort(a_FpsCounter.average);
            FLASH_FPS_LIMIT = 60;
            b.writeShort(FLASH_FPS_LIMIT);
            this.m_ServerConnection.messageWriter.finishMessage();
            return;
         }
         catch(e:Error)
         {
            handleSendError(CPERFORMANCEMETRICS,e);
            return;
         }
      }
      
      protected function readSMARKETDETAIL(param1:ByteArray) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         var _loc9_:uint = 0;
         var _loc10_:uint = 0;
         var _loc11_:Array = null;
         var _loc12_:MarketWidget = null;
         var _loc13_:String = null;
         _loc2_ = param1.readUnsignedShort();
         _loc3_ = [];
         _loc4_ = 0;
         _loc4_ = 0;
         while(_loc4_ <= MarketWidget.DETAIL_FIELD_IMBUEMENT_SLOTS)
         {
            _loc13_ = StringHelper.s_ReadLongStringFromByteArray(param1);
            _loc3_.push(_loc13_);
            _loc4_++;
         }
         _loc5_ = new Date().time / 1000 * OfferStatistics.SECONDS_PER_DAY;
         _loc6_ = 0;
         _loc7_ = 0;
         _loc8_ = 0;
         _loc9_ = 0;
         _loc10_ = 0;
         _loc11_ = [];
         _loc6_ = _loc5_;
         _loc4_ = param1.readUnsignedByte() - 1;
         while(_loc4_ >= 0)
         {
            _loc6_ = _loc6_ - OfferStatistics.SECONDS_PER_DAY;
            _loc7_ = param1.readUnsignedInt();
            _loc8_ = param1.readUnsignedInt();
            _loc9_ = param1.readUnsignedInt();
            _loc10_ = param1.readUnsignedInt();
            _loc11_.push(new OfferStatistics(_loc6_,Offer.BUY_OFFER,_loc7_,_loc8_,_loc9_,_loc10_));
            _loc4_--;
         }
         _loc6_ = _loc5_;
         _loc4_ = param1.readUnsignedByte() - 1;
         while(_loc4_ >= 0)
         {
            _loc6_ = _loc6_ - OfferStatistics.SECONDS_PER_DAY;
            _loc7_ = param1.readUnsignedInt();
            _loc8_ = param1.readUnsignedInt();
            _loc9_ = param1.readUnsignedInt();
            _loc10_ = param1.readUnsignedInt();
            _loc11_.push(new OfferStatistics(_loc6_,Offer.SELL_OFFER,_loc7_,_loc8_,_loc9_,_loc10_));
            _loc4_--;
         }
         _loc12_ = PopUpBase.getCurrent() as MarketWidget;
         if(_loc12_ != null)
         {
            _loc12_.mergeBrowseDetail(_loc2_,_loc3_,_loc11_);
         }
      }
      
      protected function readSQUESTLOG(param1:ByteArray) : void
      {
         var _loc2_:Array = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:QuestLogWidget = null;
         var _loc6_:int = 0;
         var _loc7_:String = null;
         var _loc8_:* = false;
         this.m_PendingQuestLine = -1;
         this.m_PendingQuestLog = false;
         _loc2_ = new Array();
         _loc3_ = param1.readUnsignedShort();
         _loc4_ = 0;
         while(_loc4_ < _loc3_)
         {
            _loc6_ = param1.readUnsignedShort();
            _loc7_ = StringHelper.s_ReadLongStringFromByteArray(param1,QuestLine.MAX_NAME_LENGTH);
            _loc8_ = param1.readUnsignedByte() == 1;
            _loc2_.push(new QuestLine(_loc6_,_loc7_,_loc8_));
            _loc4_++;
         }
         _loc5_ = PopUpBase.getCurrent() as QuestLogWidget;
         if(_loc5_ == null)
         {
            _loc5_ = new QuestLogWidget();
         }
         _loc5_.questLines = _loc2_;
         _loc5_.show();
      }
      
      public function sendCLEAVECHANNEL(param1:int) : void
      {
         var b:ByteArray = null;
         var a_ChannelID:int = param1;
         try
         {
            b = this.m_ServerConnection.messageWriter.createMessage();
            b.writeByte(CLEAVECHANNEL);
            b.writeShort(a_ChannelID);
            this.m_ServerConnection.messageWriter.finishMessage();
            return;
         }
         catch(e:Error)
         {
            handleSendError(CLEAVECHANNEL,e);
            return;
         }
      }
      
      protected function readSWORLDENTERED(param1:ByteArray) : void
      {
         if(this.m_ServerConnection.connectionState == CONNECTION_STATE_PENDING)
         {
            this.m_CreatureStorage.reset();
            this.m_MiniMapStorage.setPosition(0,0,0);
            this.m_WorldMapStorage.resetMap();
            this.m_WorldMapStorage.resetOnscreenMessages();
            this.m_WorldMapStorage.setPosition(0,0,0);
            this.m_WorldMapStorage.valid = false;
         }
         this.m_ServerConnection.setConnectionState(CONNECTION_STATE_GAME);
      }
      
      protected function readCreatureInstance(param1:ByteArray, param2:int = -1, param3:Vector3D = null) : Creature
      {
         if(param1 == null || param2 == -1 && param1.bytesAvailable < 2)
         {
            throw new Error("Connection.readCreatureInstance: Not enough data.",2147483625);
         }
         if(param2 == -1)
         {
            param2 = param1.readUnsignedShort();
         }
         if(param2 != AppearanceInstance.UNKNOWNCREATURE && param2 != AppearanceInstance.CREATURE && param2 != AppearanceInstance.OUTDATEDCREATURE)
         {
            throw new Error("Connection.readCreatureInstance: Invalid type.",2147483624);
         }
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = -1;
         var _loc7_:Creature = null;
         switch(param2)
         {
            case AppearanceInstance.UNKNOWNCREATURE:
               _loc5_ = param1.readUnsignedInt();
               _loc4_ = param1.readUnsignedInt();
               _loc6_ = param1.readUnsignedByte();
               if(_loc4_ == this.m_Player.ID)
               {
                  _loc7_ = this.m_Player;
               }
               else
               {
                  _loc7_ = new Creature(_loc4_);
               }
               _loc7_ = this.m_CreatureStorage.replaceCreature(_loc7_,_loc5_);
               if(_loc7_ != null)
               {
                  _loc7_.type = _loc6_;
                  if(_loc7_.isSummon)
                  {
                     _loc7_.summonerCreatureID = param1.readUnsignedInt();
                  }
                  _loc7_.name = StringHelper.s_ReadLongStringFromByteArray(param1,Creature.MAX_NAME_LENGHT);
                  _loc7_.setSkillValue(SKILL_HITPOINTS_PERCENT,param1.readUnsignedByte());
                  _loc7_.direction = param1.readUnsignedByte();
                  _loc7_.outfit = this.readCreatureOutfit(param1,_loc7_.outfit);
                  _loc7_.mountOutfit = this.readMountOutfit(param1,_loc7_.mountOutfit);
                  _loc7_.brightness = param1.readUnsignedByte();
                  _loc7_.lightColour = Colour.s_FromEightBit(param1.readUnsignedByte());
                  _loc7_.setSkillValue(SKILL_GOSTRENGTH,param1.readUnsignedShort());
                  _loc7_.setPKFlag(param1.readUnsignedByte());
                  _loc7_.setPartyFlag(param1.readUnsignedByte());
                  _loc7_.guildFlag = param1.readUnsignedByte();
                  _loc7_.type = param1.readUnsignedByte();
                  if(_loc7_.isSummon)
                  {
                     _loc7_.summonerCreatureID = param1.readUnsignedInt();
                  }
                  _loc7_.speechCategory = param1.readUnsignedByte();
                  _loc7_.marks.setMark(Marks.MARK_TYPE_PERMANENT,param1.readUnsignedByte());
                  param1.readUnsignedByte();
                  _loc7_.numberOfPVPHelpers = param1.readUnsignedShort();
                  _loc7_.isUnpassable = param1.readUnsignedByte() != 0;
                  break;
               }
               throw new Error("Connection.readCreatureInstance: Failed to append creature.",2147483623);
            case AppearanceInstance.OUTDATEDCREATURE:
               _loc4_ = param1.readUnsignedInt();
               _loc7_ = this.m_CreatureStorage.getCreature(_loc4_);
               if(_loc7_ != null)
               {
                  _loc7_.setSkillValue(SKILL_HITPOINTS_PERCENT,param1.readUnsignedByte());
                  _loc7_.direction = param1.readUnsignedByte();
                  _loc7_.outfit = this.readCreatureOutfit(param1,_loc7_.outfit);
                  _loc7_.mountOutfit = this.readMountOutfit(param1,_loc7_.mountOutfit);
                  _loc7_.brightness = param1.readUnsignedByte();
                  _loc7_.lightColour = Colour.s_FromEightBit(param1.readUnsignedByte());
                  _loc7_.setSkillValue(SKILL_GOSTRENGTH,param1.readUnsignedShort());
                  _loc7_.setPKFlag(param1.readUnsignedByte());
                  _loc7_.setPartyFlag(param1.readUnsignedByte());
                  _loc7_.type = param1.readUnsignedByte();
                  if(_loc7_.isSummon)
                  {
                     _loc7_.summonerCreatureID = param1.readUnsignedInt();
                  }
                  _loc7_.speechCategory = param1.readUnsignedByte();
                  _loc7_.marks.setMark(Marks.MARK_TYPE_PERMANENT,param1.readUnsignedByte());
                  param1.readUnsignedByte();
                  _loc7_.numberOfPVPHelpers = param1.readUnsignedShort();
                  _loc7_.isUnpassable = param1.readUnsignedByte() != 0;
                  break;
               }
               throw new Error("Connection.readCreatureInstance: Outdated creature not found.",2147483622);
            case AppearanceInstance.CREATURE:
               _loc4_ = param1.readUnsignedInt();
               _loc7_ = this.m_CreatureStorage.getCreature(_loc4_);
               if(_loc7_ != null)
               {
                  _loc7_.direction = param1.readUnsignedByte();
                  _loc7_.isUnpassable = param1.readUnsignedByte() != 0;
                  break;
               }
               throw new Error("Connection.readCreatureInstance: Known creature not found.",2147483621);
         }
         if(param3 != null)
         {
            _loc7_.setPosition(param3.x,param3.y,param3.z);
         }
         this.m_CreatureStorage.markOpponentVisible(_loc7_,true);
         this.m_CreatureStorage.invalidateOpponents();
         return _loc7_;
      }
      
      public function readCoordinate(param1:ByteArray, param2:int = -1, param3:int = -1, param4:int = -1) : Vector3D
      {
         if(param2 == -1)
         {
            param2 = param1.readUnsignedShort();
         }
         if(param3 == -1)
         {
            param3 = param1.readUnsignedShort();
         }
         if(param4 == -1)
         {
            param4 = param1.readUnsignedByte();
         }
         return new Vector3D(param2,param3,param4);
      }
      
      public function sendCTHANKYOU(param1:uint) : void
      {
         var b:ByteArray = null;
         var a_StatementID:uint = param1;
         try
         {
            b = this.m_ServerConnection.messageWriter.createMessage();
            b.writeByte(CTHANKYOU);
            b.writeUnsignedInt(a_StatementID);
            this.m_ServerConnection.messageWriter.finishMessage();
            return;
         }
         catch(e:Error)
         {
            handleSendError(CTHANKYOU,e);
            return;
         }
      }
      
      protected function readSOBJECTINFO(param1:ByteArray) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:String = null;
         _loc2_ = param1.readUnsignedByte() - 1;
         while(_loc2_ >= 0)
         {
            _loc3_ = param1.readUnsignedShort();
            _loc4_ = param1.readUnsignedByte();
            _loc5_ = StringHelper.s_ReadLongStringFromByteArray(param1);
            this.m_AppearanceStorage.setCachedObjectTypeName(_loc3_,_loc4_,_loc5_);
            _loc2_--;
         }
      }
      
      protected function readSTIBIATIME(param1:ByteArray) : void
      {
         var _loc2_:uint = param1.readUnsignedByte();
         var _loc3_:uint = param1.readUnsignedByte();
      }
      
      protected function readSPREMIUMSHOPOFFERS(param1:ByteArray) : void
      {
         var _loc2_:String = null;
         var _loc3_:Vector.<IngameShopOffer> = null;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:IngameShopCategory = null;
         var _loc7_:int = 0;
         var _loc8_:String = null;
         var _loc9_:String = null;
         var _loc10_:IngameShopOffer = null;
         var _loc11_:Vector.<String> = null;
         var _loc12_:uint = 0;
         var _loc13_:uint = 0;
         var _loc14_:int = 0;
         var _loc15_:String = null;
         var _loc16_:String = null;
         var _loc17_:Vector.<String> = null;
         var _loc18_:uint = 0;
         var _loc19_:uint = 0;
         var _loc20_:String = null;
         var _loc21_:IngameShopProduct = null;
         _loc2_ = StringHelper.s_ReadLongStringFromByteArray(param1);
         _loc3_ = new Vector.<IngameShopOffer>();
         _loc4_ = param1.readUnsignedShort();
         _loc5_ = 0;
         while(_loc5_ < _loc4_)
         {
            _loc7_ = param1.readUnsignedInt();
            _loc8_ = StringHelper.s_ReadLongStringFromByteArray(param1);
            _loc9_ = IngameShopOffer.s_ReplacePlaceholderTextInStoreDescription(StringHelper.s_ReadLongStringFromByteArray(param1));
            _loc10_ = new IngameShopOffer(_loc7_,_loc8_,_loc9_);
            _loc10_.price = param1.readUnsignedInt();
            _loc10_.highlightState = param1.readUnsignedByte();
            if(_loc10_.highlightState == IngameShopOffer.HIGHLIGHT_STATE_SALE)
            {
               _loc10_.saleValidUntilTimestamp = param1.readUnsignedInt();
               _loc10_.basePrice = param1.readUnsignedInt();
            }
            _loc10_.disabledState = param1.readUnsignedByte();
            if(_loc10_.disabledState == IngameShopOffer.DISABLED_STATE_DISABLED)
            {
               _loc10_.disabledReason = StringHelper.s_ReadLongStringFromByteArray(param1);
            }
            _loc11_ = new Vector.<String>();
            _loc12_ = param1.readUnsignedByte();
            _loc13_ = 0;
            while(_loc13_ < _loc12_)
            {
               _loc11_.push(StringHelper.s_ReadLongStringFromByteArray(param1));
               _loc13_++;
            }
            _loc10_.iconIdentifiers = _loc11_;
            _loc14_ = param1.readUnsignedShort();
            _loc13_ = 0;
            while(_loc13_ < _loc14_)
            {
               _loc15_ = StringHelper.s_ReadLongStringFromByteArray(param1);
               _loc16_ = IngameShopOffer.s_ReplacePlaceholderTextInStoreDescription(StringHelper.s_ReadLongStringFromByteArray(param1));
               _loc17_ = new Vector.<String>();
               _loc18_ = param1.readUnsignedByte();
               _loc19_ = 0;
               while(_loc19_ < _loc18_)
               {
                  _loc17_.push(StringHelper.s_ReadLongStringFromByteArray(param1));
                  _loc19_++;
               }
               _loc20_ = StringHelper.s_ReadLongStringFromByteArray(param1);
               _loc21_ = new IngameShopProduct(_loc15_,_loc16_,_loc20_);
               _loc21_.iconIdentifiers = _loc17_;
               _loc10_.products.push(_loc21_);
               _loc13_++;
            }
            if(_loc10_.disabledState != IngameShopOffer.DISABLED_STATE_HIDDEN)
            {
               _loc3_.push(_loc10_);
            }
            _loc5_++;
         }
         _loc6_ = IngameShopManager.getInstance().getCategory(_loc2_);
         if(_loc6_ != null)
         {
            _loc6_.offers = _loc3_;
            if(IngameShopWidget.s_GetCurrentInstance() != null)
            {
               IngameShopWidget.s_GetCurrentInstance().selectCategory(_loc6_);
            }
         }
      }
      
      protected function readSCHANGEONMAP(param1:ByteArray) : void
      {
         var _loc10_:uint = 0;
         var _loc11_:int = 0;
         var _loc2_:int = param1.readUnsignedShort();
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:Vector3D = null;
         var _loc6_:Vector3D = null;
         var _loc7_:ObjectInstance = null;
         var _loc8_:Creature = null;
         var _loc9_:int = 0;
         if(_loc2_ != 65535)
         {
            _loc5_ = this.readCoordinate(param1,_loc2_);
            if(!this.m_WorldMapStorage.isVisible(_loc5_.x,_loc5_.y,_loc5_.z,true))
            {
               throw new Error("Connection.readSCHANGEONMAP: Co-ordinate " + _loc5_ + " is out of range.",0);
            }
            _loc6_ = this.m_WorldMapStorage.toMap(_loc5_);
            _loc4_ = param1.readUnsignedByte();
            if((_loc7_ = this.m_WorldMapStorage.getObject(_loc6_.x,_loc6_.y,_loc6_.z,_loc4_)) == null)
            {
               throw new Error("Connection.readSCHANGEONMAP: Object not found.",1);
            }
            if(_loc7_.ID == AppearanceInstance.CREATURE && (_loc8_ = this.m_CreatureStorage.getCreature(_loc7_.data)) == null)
            {
               throw new Error("Connection.readSCHANGEONMAP: Creature not found: " + _loc7_.data,2);
            }
            if(_loc8_ != null)
            {
               this.m_CreatureStorage.markOpponentVisible(_loc8_,false);
            }
            _loc9_ = param1.readUnsignedShort();
            if(_loc9_ == AppearanceInstance.UNKNOWNCREATURE || _loc9_ == AppearanceInstance.OUTDATEDCREATURE || _loc9_ == AppearanceInstance.CREATURE)
            {
               _loc8_ = this.readCreatureInstance(param1,_loc9_,_loc5_);
               _loc7_ = this.m_AppearanceStorage.createObjectInstance(AppearanceInstance.CREATURE,_loc8_.ID);
            }
            else
            {
               _loc7_ = this.readObjectInstance(param1,_loc9_);
            }
            this.m_WorldMapStorage.changeObject(_loc6_.x,_loc6_.y,_loc6_.z,_loc4_,_loc7_);
         }
         else
         {
            _loc3_ = param1.readUnsignedInt();
            if((_loc8_ = this.m_CreatureStorage.getCreature(_loc3_)) == null)
            {
               throw new Error("Connection.readSDELETEONMAP: Creature not found: " + _loc3_,3);
            }
            _loc5_ = _loc8_.position;
            if(!this.m_WorldMapStorage.isVisible(_loc5_.x,_loc5_.y,_loc5_.z,true))
            {
               throw new Error("Connection.readSCHANGEONMAP: Co-ordinate " + _loc5_ + " is out of range.",4);
            }
            _loc6_ = this.m_WorldMapStorage.toMap(_loc5_);
            this.m_CreatureStorage.markOpponentVisible(_loc8_,false);
            _loc9_ = param1.readUnsignedShort();
            if(_loc9_ == AppearanceInstance.UNKNOWNCREATURE || _loc9_ == AppearanceInstance.OUTDATEDCREATURE || _loc9_ == AppearanceInstance.CREATURE)
            {
               _loc8_ = this.readCreatureInstance(param1,_loc9_);
            }
            else
            {
               throw new Error("Connection.readSDELETEONMAP: Received object of type " + _loc9_ + " when a creature was expected.",5);
            }
         }
         if(_loc5_.z == this.m_MiniMapStorage.getPositionZ())
         {
            this.m_WorldMapStorage.updateMiniMap(_loc6_.x,_loc6_.y,_loc6_.z);
            _loc10_ = this.m_WorldMapStorage.getMiniMapColour(_loc6_.x,_loc6_.y,_loc6_.z);
            _loc11_ = this.m_WorldMapStorage.getMiniMapCost(_loc6_.x,_loc6_.y,_loc6_.z);
            this.m_MiniMapStorage.updateField(_loc5_.x,_loc5_.y,_loc5_.z,_loc10_,_loc11_,false);
         }
      }
      
      protected function readSCLOSETRADE(param1:ByteArray) : void
      {
         var _loc2_:OptionsStorage = Tibia.s_GetOptions();
         var _loc3_:SideBarSet = null;
         var _loc4_:SafeTradeWidget = null;
         if(_loc2_ != null && (_loc3_ = _loc2_.getSideBarSet(SideBarSet.DEFAULT_SET)) != null && (_loc4_ = _loc3_.getWidgetByType(Widget.TYPE_SAFETRADE) as SafeTradeWidget) != null)
         {
            _loc4_.ownName = null;
            _loc4_.ownItems = null;
            _loc4_.otherName = null;
            _loc4_.otherItems = null;
            _loc3_.hideWidgetType(Widget.TYPE_SAFETRADE,-1);
         }
      }
      
      protected function readSMISSILEEFFECT(param1:ByteArray) : void
      {
         var _loc2_:Vector3D = this.readCoordinate(param1);
         var _loc3_:Vector3D = this.readCoordinate(param1);
         var _loc4_:int = param1.readUnsignedByte();
         var _loc5_:MissileInstance = this.m_AppearanceStorage.createMissileInstance(_loc4_,_loc2_,_loc3_);
         this.m_WorldMapStorage.appendEffect(_loc2_.x,_loc2_.y,_loc2_.z,_loc5_);
      }
      
      protected function readSOPENCHANNEL(param1:ByteArray) : void
      {
         var _loc2_:int = 0;
         var _loc3_:String = null;
         var _loc4_:Channel = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:String = null;
         var _loc10_:String = null;
         _loc2_ = param1.readUnsignedShort();
         _loc3_ = StringHelper.s_ReadLongStringFromByteArray(param1,Channel.MAX_NAME_LENGTH);
         _loc4_ = this.m_ChatStorage.addChannel(_loc2_,_loc3_,MessageMode.MESSAGE_CHANNEL);
         _loc5_ = param1.readUnsignedShort();
         _loc6_ = 0;
         while(_loc6_ < _loc5_)
         {
            _loc9_ = StringHelper.s_ReadLongStringFromByteArray(param1,Creature.MAX_NAME_LENGHT);
            _loc4_.playerJoined(_loc9_);
            _loc6_++;
         }
         _loc7_ = param1.readUnsignedShort();
         _loc8_ = 0;
         while(_loc8_ < _loc7_)
         {
            _loc10_ = StringHelper.s_ReadLongStringFromByteArray(param1,Creature.MAX_NAME_LENGHT);
            _loc4_.playerInvited(_loc10_);
            _loc8_++;
         }
      }
      
      public function sendCGETQUESTLOG() : void
      {
         var b:ByteArray = null;
         try
         {
            if(!this.m_PendingQuestLog)
            {
               b = this.m_ServerConnection.messageWriter.createMessage();
               b.writeByte(CGETQUESTLOG);
               this.m_ServerConnection.messageWriter.finishMessage();
               this.m_PendingQuestLine = -1;
               this.m_PendingQuestLog = true;
            }
            return;
         }
         catch(e:Error)
         {
            handleSendError(CGETQUESTLOG,e);
            return;
         }
      }
      
      protected function readSSHOWGAMENEWS(param1:ByteArray) : void
      {
         param1.readUnsignedInt();
         param1.readUnsignedByte();
      }
      
      protected function readSOUTFIT(param1:ByteArray) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:String = null;
         var _loc11_:* = 0;
         var _loc12_:AppearanceType = null;
         var _loc13_:IList = null;
         var _loc14_:int = 0;
         var _loc15_:IList = null;
         var _loc16_:SelectOutfitWidget = null;
         _loc2_ = param1.readUnsignedShort();
         _loc3_ = param1.readUnsignedByte();
         _loc4_ = param1.readUnsignedByte();
         _loc5_ = param1.readUnsignedByte();
         _loc6_ = param1.readUnsignedByte();
         _loc7_ = param1.readUnsignedByte();
         _loc8_ = param1.readUnsignedShort();
         _loc9_ = 0;
         _loc10_ = null;
         _loc11_ = 0;
         _loc12_ = null;
         _loc13_ = new ArrayCollection();
         _loc14_ = param1.readUnsignedByte();
         while(_loc14_ > 0)
         {
            _loc9_ = param1.readUnsignedShort();
            _loc10_ = StringHelper.s_ReadLongStringFromByteArray(param1,OutfitInstance.MAX_NAME_LENGTH);
            _loc11_ = int(param1.readUnsignedByte());
            _loc12_ = this.m_AppearanceStorage.getOutfitType(_loc9_);
            if(_loc12_ == null)
            {
               throw new Error("Connection.readSOUTFIT: Unknown player outfit type " + _loc9_ + ".",0);
            }
            _loc11_ = _loc11_ & 1 << _loc12_.FrameGroups[FrameGroup.FRAME_GROUP_DEFAULT].patternHeight - 1 - 1;
            _loc13_.addItem({
               "ID":_loc9_,
               "name":_loc10_,
               "addons":_loc11_
            });
            _loc14_--;
         }
         _loc15_ = new ArrayCollection();
         _loc14_ = param1.readUnsignedByte();
         while(_loc14_ > 0)
         {
            _loc9_ = param1.readUnsignedShort();
            _loc10_ = StringHelper.s_ReadLongStringFromByteArray(param1,OutfitInstance.MAX_NAME_LENGTH);
            _loc12_ = this.m_AppearanceStorage.getOutfitType(_loc9_);
            if(_loc12_ == null)
            {
               throw new Error("Connection.readSOUTFIT: Unknown mount outfit type " + _loc9_ + ".",1);
            }
            _loc15_.addItem({
               "ID":_loc9_,
               "name":_loc10_
            });
            _loc14_--;
         }
         _loc16_ = new SelectOutfitWidget();
         _loc16_.playerOutfits = _loc13_;
         _loc16_.playerType = _loc2_;
         _loc16_.playerColours = [_loc3_,_loc4_,_loc5_,_loc6_];
         _loc16_.playerAddons = _loc7_;
         _loc16_.mountOutfits = _loc15_;
         _loc16_.mountType = _loc8_;
         _loc16_.show();
      }
      
      protected function readSCREATURELIGHT(param1:ByteArray) : void
      {
         var _loc2_:int = 0;
         _loc2_ = param1.readUnsignedInt();
         var _loc3_:int = param1.readUnsignedByte();
         var _loc4_:int = param1.readUnsignedByte();
         var _loc5_:Creature = this.m_CreatureStorage.getCreature(_loc2_);
         if(_loc5_ != null)
         {
            _loc5_.brightness = _loc3_;
            _loc5_.lightColour = Colour.s_FromEightBit(_loc4_);
         }
         this.m_CreatureStorage.invalidateOpponents();
      }
      
      public function sendCATTACK(param1:int) : void
      {
         var b:ByteArray = null;
         var a_CreatureID:int = param1;
         try
         {
            if(a_CreatureID != 0)
            {
               this.m_Player.stopAutowalk(false);
            }
            b = this.m_ServerConnection.messageWriter.createMessage();
            b.writeByte(CATTACK);
            b.writeInt(a_CreatureID);
            b.writeInt(a_CreatureID);
            this.m_ServerConnection.messageWriter.finishMessage();
            return;
         }
         catch(e:Error)
         {
            handleSendError(CATTACK,e);
            return;
         }
      }
      
      public function sendCENTERWORLD() : void
      {
         var b:ByteArray = null;
         try
         {
            b = this.m_ServerConnection.messageWriter.createMessage();
            b.writeByte(CENTERWORLD);
            this.m_ServerConnection.messageWriter.finishMessage();
            return;
         }
         catch(e:Error)
         {
            handleSendError(CENTERWORLD,e);
            return;
         }
      }
      
      public function sendCCLOSENPCCHANNEL() : void
      {
         var b:ByteArray = null;
         try
         {
            b = this.m_ServerConnection.messageWriter.createMessage();
            b.writeByte(CCLOSENPCCHANNEL);
            this.m_ServerConnection.messageWriter.finishMessage();
            return;
         }
         catch(e:Error)
         {
            handleSendError(CCLOSENPCCHANNEL,e);
            return;
         }
      }
      
      protected function readSTALK(param1:ByteArray) : void
      {
         var StatementID:int = 0;
         var Speaker:String = null;
         var SpeakerLevel:int = 0;
         var Mode:int = 0;
         var Pos:Vector3D = null;
         var ChannelID:Object = null;
         var Text:String = null;
         var a_Bytes:ByteArray = param1;
         StatementID = a_Bytes.readUnsignedInt();
         Speaker = StringHelper.s_ReadLongStringFromByteArray(a_Bytes,Creature.MAX_NAME_LENGHT);
         SpeakerLevel = a_Bytes.readUnsignedShort();
         Mode = a_Bytes.readUnsignedByte();
         Pos = null;
         ChannelID = null;
         switch(Mode)
         {
            case MessageMode.MESSAGE_SAY:
            case MessageMode.MESSAGE_WHISPER:
            case MessageMode.MESSAGE_YELL:
               Pos = this.readCoordinate(a_Bytes);
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
               Pos = this.readCoordinate(a_Bytes);
               ChannelID = ChatStorage.LOCAL_CHANNEL_ID;
               break;
            case MessageMode.MESSAGE_NPC_FROM_START_BLOCK:
               Pos = this.readCoordinate(a_Bytes);
               break;
            case MessageMode.MESSAGE_NPC_FROM:
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
               Pos = this.readCoordinate(a_Bytes);
               ChannelID = -1;
               break;
            case MessageMode.MESSAGE_GAME:
               break;
            default:
               throw new Error("Connection.readSTALK: Invalid message mode " + Mode + ".",0);
         }
         Text = StringHelper.s_ReadLongStringFromByteArray(a_Bytes,ChatStorage.MAX_TALK_LENGTH);
         if(Mode != MessageMode.MESSAGE_NPC_FROM_START_BLOCK && Mode != MessageMode.MESSAGE_NPC_FROM)
         {
            try
            {
               this.m_WorldMapStorage.addOnscreenMessage(Pos,StatementID,Speaker,SpeakerLevel,Mode,Text);
            }
            catch(e:Error)
            {
               throw new Error("Connection.readSTALK: Failed to add message: " + e.message,1);
            }
            try
            {
               this.m_ChatStorage.addChannelMessage(ChannelID,StatementID,Speaker,SpeakerLevel,Mode,Text);
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
      
      public function sendCLOOKATCREATURE(param1:int) : void
      {
         var b:ByteArray = null;
         var a_CreatureID:int = param1;
         try
         {
            b = this.m_ServerConnection.messageWriter.createMessage();
            b.writeByte(CLOOKATCREATURE);
            b.writeUnsignedInt(a_CreatureID);
            this.m_ServerConnection.messageWriter.finishMessage();
            return;
         }
         catch(e:Error)
         {
            handleSendError(CLOOKATCREATURE,e);
            return;
         }
      }
      
      protected function readSPLAYERDATABASIC(param1:ByteArray) : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         _loc2_ = param1.readBoolean();
         this.m_Player.premiumUntil = param1.readUnsignedInt();
         this.m_Player.premium = _loc2_;
         this.m_Player.profession = param1.readUnsignedByte();
         this.m_Player.hasReachedMain = param1.readBoolean();
         _loc3_ = [];
         _loc4_ = param1.readUnsignedShort() - 1;
         while(_loc4_ >= 0)
         {
            _loc3_.push(param1.readUnsignedByte());
            _loc4_--;
         }
         this.m_Player.knownSpells = _loc3_;
      }
      
      protected function readSCREATUREOUTFIT(param1:ByteArray) : void
      {
         var _loc2_:int = 0;
         _loc2_ = param1.readUnsignedInt();
         var _loc3_:AppearanceInstance = this.readCreatureOutfit(param1,null);
         var _loc4_:AppearanceInstance = this.readMountOutfit(param1,null);
         var _loc5_:Creature = this.m_CreatureStorage.getCreature(_loc2_);
         if(_loc5_ != null)
         {
            _loc5_.outfit = _loc3_;
            _loc5_.mountOutfit = _loc4_;
         }
         this.m_CreatureStorage.invalidateOpponents();
      }
      
      public function sendCROTATENORTH() : void
      {
         var b:ByteArray = null;
         try
         {
            b = this.m_ServerConnection.messageWriter.createMessage();
            b.writeByte(CROTATENORTH);
            this.m_ServerConnection.messageWriter.finishMessage();
            return;
         }
         catch(e:Error)
         {
            handleSendError(CROTATENORTH,e);
            return;
         }
      }
      
      public function sendCBUYOBJECT(param1:int, param2:int, param3:int, param4:Boolean, param5:Boolean) : void
      {
         var b:ByteArray = null;
         var a_Type:int = param1;
         var a_Data:int = param2;
         var a_Amount:int = param3;
         var a_IgnoreCapacity:Boolean = param4;
         var a_WithBackpacks:Boolean = param5;
         try
         {
            b = this.m_ServerConnection.messageWriter.createMessage();
            b.writeByte(CBUYOBJECT);
            b.writeShort(a_Type);
            b.writeByte(a_Data);
            b.writeByte(a_Amount);
            b.writeBoolean(a_IgnoreCapacity);
            b.writeBoolean(a_WithBackpacks);
            this.m_ServerConnection.messageWriter.finishMessage();
            return;
         }
         catch(e:Error)
         {
            handleSendError(CBUYOBJECT,e);
            return;
         }
      }
      
      protected function readSMARKETBROWSE(param1:ByteArray) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Array = null;
         var _loc5_:MarketWidget = null;
         _loc2_ = param1.readUnsignedShort();
         _loc3_ = 0;
         _loc4_ = [];
         _loc3_ = param1.readUnsignedInt() - 1;
         while(_loc3_ >= 0)
         {
            _loc4_.push(this.readMarketOffer(param1,Offer.BUY_OFFER,_loc2_));
            _loc3_--;
         }
         _loc3_ = param1.readUnsignedInt() - 1;
         while(_loc3_ >= 0)
         {
            _loc4_.push(this.readMarketOffer(param1,Offer.SELL_OFFER,_loc2_));
            _loc3_--;
         }
         _loc5_ = PopUpBase.getCurrent() as MarketWidget;
         if(_loc5_ != null)
         {
            _loc5_.mergeBrowseOffers(_loc2_,_loc4_);
         }
      }
      
      public function sendCROTATEEAST() : void
      {
         var b:ByteArray = null;
         try
         {
            b = this.m_ServerConnection.messageWriter.createMessage();
            b.writeByte(CROTATEEAST);
            this.m_ServerConnection.messageWriter.finishMessage();
            return;
         }
         catch(e:Error)
         {
            handleSendError(CROTATEEAST,e);
            return;
         }
      }
      
      protected function readSCREATUREPVPHELPERS(param1:ByteArray) : void
      {
         var _loc2_:int = 0;
         _loc2_ = param1.readUnsignedInt();
         var _loc3_:uint = param1.readUnsignedShort();
         var _loc4_:Creature = this.m_CreatureStorage.getCreature(_loc2_);
         if(_loc4_ != null)
         {
            _loc4_.numberOfPVPHelpers = _loc3_;
         }
         this.m_CreatureStorage.invalidateOpponents();
      }
      
      protected function readSMESSAGE(param1:ByteArray) : void
      {
         var SecondaryError:int = 0;
         var Mode:int = 0;
         var ChannelID:int = 0;
         var Text:String = null;
         var Pos:Vector3D = null;
         var Value:Number = NaN;
         var Color:uint = 0;
         var SpeakerMatch:Array = null;
         var Speaker:String = null;
         var NameFilter:NameFilterSet = null;
         var _MarketWidget:MarketWidget = null;
         var a_Bytes:ByteArray = param1;
         try
         {
            SecondaryError = 0;
            Mode = a_Bytes.readUnsignedByte();
            ChannelID = -1;
            Text = null;
            Pos = null;
            Value = NaN;
            Color = 0;
            switch(Mode)
            {
               case MessageMode.MESSAGE_CHANNEL_MANAGEMENT:
                  ChannelID = a_Bytes.readUnsignedShort();
                  Text = StringHelper.s_ReadLongStringFromByteArray(a_Bytes);
                  SpeakerMatch = Text.match(/^(.+?) invites you to |^You have been excluded from the channel ([^']+)'s Channel\.$/);
                  Speaker = SpeakerMatch != null?SpeakerMatch[1] != undefined?SpeakerMatch[1]:SpeakerMatch[2]:null;
                  NameFilter = Tibia.s_GetOptions().getNameFilterSet(NameFilterSet.DEFAULT_SET);
                  if(NameFilter != null && NameFilter.acceptMessage(Mode,Speaker,Text))
                  {
                     SecondaryError = 1;
                     this.m_WorldMapStorage.addOnscreenMessage(null,-1,null,0,Mode,Text);
                     SecondaryError = 2;
                     this.m_ChatStorage.addChannelMessage(ChannelID,-1,null,0,Mode,Text);
                  }
                  break;
               case MessageMode.MESSAGE_GUILD:
               case MessageMode.MESSAGE_PARTY_MANAGEMENT:
               case MessageMode.MESSAGE_PARTY:
                  ChannelID = a_Bytes.readUnsignedShort();
               case MessageMode.MESSAGE_LOGIN:
               case MessageMode.MESSAGE_ADMIN:
               case MessageMode.MESSAGE_GAME:
               case MessageMode.MESSAGE_GAME_HIGHLIGHT:
               case MessageMode.MESSAGE_FAILURE:
               case MessageMode.MESSAGE_LOOK:
               case MessageMode.MESSAGE_STATUS:
               case MessageMode.MESSAGE_LOOT:
               case MessageMode.MESSAGE_TRADE_NPC:
               case MessageMode.MESSAGE_HOTKEY_USE:
                  Text = StringHelper.s_ReadLongStringFromByteArray(a_Bytes);
                  SecondaryError = 3;
                  this.m_WorldMapStorage.addOnscreenMessage(null,-1,null,0,Mode,Text);
                  SecondaryError = 4;
                  this.m_ChatStorage.addChannelMessage(ChannelID,-1,null,0,Mode,Text);
                  break;
               case MessageMode.MESSAGE_MARKET:
                  Text = StringHelper.s_ReadLongStringFromByteArray(a_Bytes);
                  _MarketWidget = PopUpBase.getCurrent() as MarketWidget;
                  if(_MarketWidget != null)
                  {
                     _MarketWidget.serverResponsePending = false;
                     _MarketWidget.showMessage(Text);
                  }
                  break;
               case MessageMode.MESSAGE_REPORT:
                  ReportWidget.s_ReportTimestampReset();
                  Text = StringHelper.s_ReadLongStringFromByteArray(a_Bytes);
                  SecondaryError = 5;
                  this.m_WorldMapStorage.addOnscreenMessage(null,-1,null,0,Mode,Text);
                  SecondaryError = 6;
                  this.m_ChatStorage.addChannelMessage(-1,-1,null,0,Mode,Text);
                  break;
               case MessageMode.MESSAGE_DAMAGE_DEALED:
               case MessageMode.MESSAGE_DAMAGE_RECEIVED:
               case MessageMode.MESSAGE_DAMAGE_OTHERS:
                  Pos = this.readCoordinate(a_Bytes);
                  Value = a_Bytes.readUnsignedInt();
                  Color = a_Bytes.readUnsignedByte();
                  SecondaryError = 7;
                  if(Value > 0)
                  {
                     this.m_WorldMapStorage.addOnscreenMessage(Pos,-1,null,0,Mode,Value,Color);
                  }
                  Value = a_Bytes.readUnsignedInt();
                  Color = a_Bytes.readUnsignedByte();
                  SecondaryError = 8;
                  if(Value > 0)
                  {
                     this.m_WorldMapStorage.addOnscreenMessage(Pos,-1,null,0,Mode,Value,Color);
                  }
                  Text = StringHelper.s_ReadLongStringFromByteArray(a_Bytes);
                  SecondaryError = 9;
                  this.m_ChatStorage.addChannelMessage(-1,-1,null,0,Mode,Text);
                  break;
               case MessageMode.MESSAGE_HEAL:
               case MessageMode.MESSAGE_MANA:
               case MessageMode.MESSAGE_EXP:
               case MessageMode.MESSAGE_HEAL_OTHERS:
               case MessageMode.MESSAGE_EXP_OTHERS:
                  Pos = this.readCoordinate(a_Bytes);
                  Value = a_Bytes.readUnsignedInt();
                  Color = a_Bytes.readUnsignedByte();
                  SecondaryError = 10;
                  this.m_WorldMapStorage.addOnscreenMessage(Pos,-1,null,0,Mode,Value,Color);
                  Text = StringHelper.s_ReadLongStringFromByteArray(a_Bytes);
                  SecondaryError = 11;
                  this.m_ChatStorage.addChannelMessage(-1,-1,null,0,Mode,Text);
                  break;
               default:
                  throw new Error("Connection.readSMESSAGE: Invalid message mode " + Mode + ".",0);
            }
            return;
         }
         catch(e:Error)
         {
            throw new Error("Connection.readSMESSAGE: Failed to add message of type " + Mode + ": " + e.message,SecondaryError);
         }
      }
      
      protected function readSRESTINGAREASTATE(param1:ByteArray) : void
      {
         var _loc2_:Boolean = param1.readBoolean();
         var _loc3_:Boolean = param1.readBoolean();
         var _loc4_:String = StringHelper.s_ReadLongStringFromByteArray(param1,Creature.MAX_NAME_LENGHT);
      }
      
      protected function readSSHOWMODALDIALOG(param1:ByteArray) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc5_:Vector.<Choice> = null;
         var _loc6_:String = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:Vector.<Choice> = null;
         var _loc10_:uint = 0;
         var _loc11_:uint = 0;
         var _loc12_:Boolean = false;
         var _loc13_:ServerModalDialog = null;
         _loc2_ = param1.readUnsignedInt();
         _loc3_ = StringHelper.s_ReadLongStringFromByteArray(param1);
         _loc4_ = StringHelper.s_ReadLongStringFromByteArray(param1);
         _loc5_ = new Vector.<Choice>();
         _loc6_ = null;
         _loc7_ = 0;
         _loc8_ = 0;
         _loc8_ = param1.readUnsignedByte();
         while(_loc8_ > 0)
         {
            _loc6_ = StringHelper.s_ReadLongStringFromByteArray(param1);
            _loc7_ = param1.readUnsignedByte();
            _loc5_.push(new Choice(_loc6_,_loc7_));
            _loc8_--;
         }
         _loc9_ = new Vector.<Choice>();
         _loc8_ = param1.readUnsignedByte();
         while(_loc8_ > 0)
         {
            _loc6_ = StringHelper.s_ReadLongStringFromByteArray(param1);
            _loc7_ = param1.readUnsignedByte();
            _loc9_.push(new Choice(_loc6_,_loc7_));
            _loc8_--;
         }
         _loc10_ = param1.readUnsignedByte();
         _loc11_ = param1.readUnsignedByte();
         _loc12_ = param1.readBoolean();
         _loc13_ = new ServerModalDialog(_loc2_);
         _loc13_.buttons = _loc5_;
         _loc13_.choices = _loc9_;
         _loc13_.defaultEnterButton = _loc11_;
         _loc13_.defaultEscapeButton = _loc10_;
         _loc13_.message = _loc4_;
         _loc13_.priority = PopUpBase.DEFAULT_PRIORITY + (!!_loc12_?1:0);
         _loc13_.title = _loc3_;
         _loc13_.show();
      }
      
      protected function readSMARKETSTATISTICS(param1:ByteArray) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         _loc2_ = param1.readUnsignedShort();
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = param1.readUnsignedShort();
            _loc5_ = param1.readUnsignedInt();
            _loc3_++;
         }
      }
      
      protected function readSCOUNTEROFFER(param1:ByteArray) : void
      {
         var _loc8_:SafeTradeWidget = null;
         var _loc2_:String = StringHelper.s_ReadLongStringFromByteArray(param1,Creature.MAX_NAME_LENGHT);
         var _loc3_:int = param1.readUnsignedByte();
         var _loc4_:IList = new ArrayCollection();
         var _loc5_:int = 0;
         while(_loc5_ < _loc3_)
         {
            _loc4_.addItem(this.readObjectInstance(param1));
            _loc5_++;
         }
         var _loc6_:OptionsStorage = Tibia.s_GetOptions();
         var _loc7_:SideBarSet = null;
         if(_loc6_ != null && (_loc7_ = _loc6_.getSideBarSet(SideBarSet.DEFAULT_SET)) != null)
         {
            _loc8_ = _loc7_.getWidgetByType(Widget.TYPE_SAFETRADE) as SafeTradeWidget;
            if(_loc8_ == null)
            {
               _loc8_ = _loc7_.showWidgetType(Widget.TYPE_SAFETRADE,-1,-1) as SafeTradeWidget;
            }
            _loc8_.otherName = _loc2_;
            _loc8_.otherItems = _loc4_;
         }
      }
      
      public function sendCJOINCHANNEL(param1:int) : void
      {
         var b:ByteArray = null;
         var a_ChannelID:int = param1;
         try
         {
            b = this.m_ServerConnection.messageWriter.createMessage();
            b.writeByte(CJOINCHANNEL);
            b.writeShort(a_ChannelID);
            this.m_ServerConnection.messageWriter.finishMessage();
            return;
         }
         catch(e:Error)
         {
            handleSendError(CJOINCHANNEL,e);
            return;
         }
      }
      
      protected function readSRESOURCEBALANCE(param1:ByteArray) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:Number = NaN;
         _loc2_ = param1.readUnsignedByte();
         _loc3_ = this.readSigned64BitValue(param1);
         if(_loc2_ == RESOURCETYPE_BANK_GOLD)
         {
            this.m_Player.bankGoldBalance = _loc3_;
         }
         else if(_loc2_ == RESOURCETYPE_INVENTORY_GOLD)
         {
            this.m_Player.inventoryGoldBalance = _loc3_;
         }
         else if(_loc2_ == RESOURCETYPE_PREY_BONUS_REROLLS)
         {
            PreyManager.getInstance().bonusRerollAmount = _loc3_;
         }
         else if(_loc2_ == RESOURCETYPE_COLLECTION_TOKENS)
         {
         }
      }
      
      public function get isGameRunning() : Boolean
      {
         return this.m_ServerConnection.isGameRunning;
      }
      
      protected function readSCREATEONMAP(param1:ByteArray) : void
      {
         var _loc8_:uint = 0;
         var _loc9_:int = 0;
         var _loc2_:Vector3D = this.readCoordinate(param1);
         if(!this.m_WorldMapStorage.isVisible(_loc2_.x,_loc2_.y,_loc2_.z,true))
         {
            throw new Error("Connection.readSCREATEONMAP: Co-ordinate " + _loc2_ + " is out of range.",0);
         }
         var _loc3_:Vector3D = this.m_WorldMapStorage.toMap(_loc2_);
         var _loc4_:int = param1.readUnsignedByte();
         var _loc5_:int = param1.readUnsignedShort();
         var _loc6_:ObjectInstance = null;
         var _loc7_:Creature = null;
         if(_loc5_ == AppearanceInstance.UNKNOWNCREATURE || _loc5_ == AppearanceInstance.OUTDATEDCREATURE || _loc5_ == AppearanceInstance.CREATURE)
         {
            _loc7_ = this.readCreatureInstance(param1,_loc5_,_loc2_);
            if(_loc7_.ID == this.m_Player.ID)
            {
               this.m_Player.stopAutowalk(true);
            }
            _loc6_ = this.m_AppearanceStorage.createObjectInstance(AppearanceInstance.CREATURE,_loc7_.ID);
         }
         else
         {
            _loc6_ = this.readObjectInstance(param1,_loc5_);
         }
         if(_loc4_ == 255)
         {
            this.m_WorldMapStorage.putObject(_loc3_.x,_loc3_.y,_loc3_.z,_loc6_);
         }
         else
         {
            if(_loc4_ >= MAPSIZE_W)
            {
               throw new Error("Connection.readSCREATEONMAP: Invalid position.",1);
            }
            this.m_WorldMapStorage.insertObject(_loc3_.x,_loc3_.y,_loc3_.z,_loc4_,_loc6_);
         }
         if(_loc2_.z == this.m_MiniMapStorage.getPositionZ())
         {
            this.m_WorldMapStorage.updateMiniMap(_loc3_.x,_loc3_.y,_loc3_.z);
            _loc8_ = this.m_WorldMapStorage.getMiniMapColour(_loc3_.x,_loc3_.y,_loc3_.z);
            _loc9_ = this.m_WorldMapStorage.getMiniMapCost(_loc3_.x,_loc3_.y,_loc3_.z);
            this.m_MiniMapStorage.updateField(_loc2_.x,_loc2_.y,_loc2_.z,_loc8_,_loc9_,false);
         }
      }
      
      protected function readSCREATUREUNPASS(param1:ByteArray) : void
      {
         var _loc2_:int = 0;
         _loc2_ = param1.readUnsignedInt();
         var _loc3_:Boolean = param1.readBoolean();
         var _loc4_:Creature = this.m_CreatureStorage.getCreature(_loc2_);
         if(_loc4_ != null)
         {
            _loc4_.isUnpassable = _loc3_;
         }
      }
      
      public function sendCPREYACTION(param1:int, param2:int, param3:int) : void
      {
         var b:ByteArray = null;
         var a_PreyID:int = param1;
         var a_PreyAction:int = param2;
         var a_MonsterIndex:int = param3;
         try
         {
            b = this.m_ServerConnection.messageWriter.createMessage();
            b.writeByte(CPREYACTION);
            b.writeByte(a_PreyID);
            b.writeByte(a_PreyAction);
            if(a_PreyAction == 2)
            {
               b.writeByte(a_MonsterIndex);
            }
            this.m_ServerConnection.messageWriter.finishMessage();
            return;
         }
         catch(e:Error)
         {
            handleSendError(CSTOREEVENT,e);
            return;
         }
      }
      
      protected function readSCREATUREMARKS(param1:ByteArray) : void
      {
         var _loc2_:int = 0;
         _loc2_ = param1.readUnsignedInt();
         var _loc3_:uint = param1.readUnsignedByte();
         var _loc4_:uint = param1.readUnsignedByte();
         var _loc5_:Creature = this.m_CreatureStorage.getCreature(_loc2_);
         if(_loc5_ != null)
         {
            if(_loc3_ == 1)
            {
               _loc5_.marks.setMark(Marks.MARK_TYPE_ONE_SECOND_TEMP,_loc4_);
            }
            else
            {
               _loc5_.marks.setMark(Marks.MARK_TYPE_PERMANENT,_loc4_);
            }
         }
         this.m_CreatureStorage.invalidateOpponents();
      }
      
      protected function readSBUDDYSTATUSCHANGE(param1:ByteArray) : void
      {
         var _loc2_:int = 0;
         var _loc3_:uint = 0;
         var _loc4_:OptionsStorage = null;
         var _loc5_:BuddySet = null;
         _loc2_ = param1.readUnsignedInt();
         _loc3_ = param1.readByte();
         _loc4_ = Tibia.s_GetOptions();
         _loc5_ = null;
         if(_loc4_ != null && (_loc5_ = _loc4_.getBuddySet(BuddySet.DEFAULT_SET)) != null)
         {
            _loc5_.updateBuddy(_loc2_,_loc3_);
         }
      }
      
      public function sendCGUILDMESSAGE() : void
      {
         var b:ByteArray = null;
         try
         {
            b = this.m_ServerConnection.messageWriter.createMessage();
            b.writeByte(CGUILDMESSAGE);
            this.m_ServerConnection.messageWriter.finishMessage();
            return;
         }
         catch(e:Error)
         {
            handleSendError(CPRIVATECHANNEL,e);
            return;
         }
      }
      
      public function sendCUSEONCREATURE(param1:int, param2:int, param3:int, param4:int, param5:int, param6:int) : void
      {
         var b:ByteArray = null;
         var a_X:int = param1;
         var a_Y:int = param2;
         var a_Z:int = param3;
         var a_TypeID:int = param4;
         var a_PositionOrData:int = param5;
         var a_CreatureID:int = param6;
         try
         {
            this.m_Player.stopAutowalk(false);
            b = this.m_ServerConnection.messageWriter.createMessage();
            b.writeByte(CUSEONCREATURE);
            b.writeShort(a_X);
            b.writeShort(a_Y);
            b.writeByte(a_Z);
            b.writeShort(a_TypeID);
            b.writeByte(a_PositionOrData);
            b.writeUnsignedInt(a_CreatureID);
            this.m_ServerConnection.messageWriter.finishMessage();
            return;
         }
         catch(e:Error)
         {
            handleSendError(CUSEONCREATURE,e);
            return;
         }
      }
      
      public function sendCGO(param1:Array) : void
      {
         var Type:int = 0;
         var b:ByteArray = null;
         var i:int = 0;
         var a_Path:Array = param1;
         Type = -1;
         try
         {
            this.m_CreatureStorage.clearTargets();
            if(a_Path == null || a_Path.length == 0)
            {
               return;
            }
            b = this.m_ServerConnection.messageWriter.createMessage();
            if(a_Path.length == 1)
            {
               switch(a_Path[0] & 65535)
               {
                  case PATH_EAST:
                     Type = CGOEAST;
                     break;
                  case PATH_NORTH_EAST:
                     Type = CGONORTHEAST;
                     break;
                  case PATH_NORTH:
                     Type = CGONORTH;
                     break;
                  case PATH_NORTH_WEST:
                     Type = CGONORTHWEST;
                     break;
                  case PATH_WEST:
                     Type = CGOWEST;
                     break;
                  case PATH_SOUTH_WEST:
                     Type = CGOSOUTHWEST;
                     break;
                  case PATH_SOUTH:
                     Type = CGOSOUTH;
                     break;
                  case PATH_SOUTH_EAST:
                     Type = CGOSOUTHEAST;
               }
               b.writeByte(Type);
            }
            else
            {
               Type = CGOPATH;
               b.writeByte(Type);
               b.writeByte(a_Path.length & 255);
               i = 0;
               while(i < a_Path.length)
               {
                  b.writeByte(a_Path[i] & 65535);
                  i++;
               }
            }
            this.m_ServerConnection.messageWriter.finishMessage();
            return;
         }
         catch(e:Error)
         {
            handleSendError(Type,e);
            return;
         }
      }
      
      public function sendCBROWSEFIELD(param1:int, param2:int, param3:int) : void
      {
         var b:ByteArray = null;
         var a_X:int = param1;
         var a_Y:int = param2;
         var a_Z:int = param3;
         try
         {
            b = this.m_ServerConnection.messageWriter.createMessage();
            b.writeByte(CBROWSEFIELD);
            b.writeShort(a_X);
            b.writeShort(a_Y);
            b.writeByte(a_Z);
            this.m_ServerConnection.messageWriter.finishMessage();
            return;
         }
         catch(e:Error)
         {
            handleSendError(CBROWSEFIELD,e);
            return;
         }
      }
      
      protected function readSCREATURETYPE(param1:ByteArray) : void
      {
         var _loc2_:int = 0;
         _loc2_ = param1.readUnsignedInt();
         var _loc3_:uint = param1.readUnsignedByte();
         var _loc4_:Creature = this.m_CreatureStorage.getCreature(_loc2_);
         if(_loc4_ != null)
         {
            _loc4_.type = _loc3_;
            if(_loc4_.isSummon)
            {
               _loc4_.summonerCreatureID = param1.readUnsignedInt();
            }
         }
         this.m_CreatureStorage.invalidateOpponents();
      }
      
      public function sendCTURNOBJECT(param1:int, param2:int, param3:int, param4:int, param5:int) : void
      {
         var b:ByteArray = null;
         var a_X:int = param1;
         var a_Y:int = param2;
         var a_Z:int = param3;
         var a_TypeID:int = param4;
         var a_Position:int = param5;
         try
         {
            b = this.m_ServerConnection.messageWriter.createMessage();
            b.writeByte(CTURNOBJECT);
            b.writeShort(a_X);
            b.writeShort(a_Y);
            b.writeByte(a_Z);
            b.writeShort(a_TypeID);
            b.writeByte(a_Position);
            this.m_ServerConnection.messageWriter.finishMessage();
            return;
         }
         catch(e:Error)
         {
            handleSendError(CTURNOBJECT,e);
            return;
         }
      }
      
      public function sendCAPPLYIMBUEMENT(param1:uint, param2:uint, param3:Boolean) : void
      {
         var b:ByteArray = null;
         var a_SlotNumber:uint = param1;
         var a_ImbuementID:uint = param2;
         var a_UseProtectionCharm:Boolean = param3;
         try
         {
            b = this.m_ServerConnection.messageWriter.createMessage();
            b.writeByte(CAPPLYIMBUEMENT);
            b.writeByte(a_SlotNumber);
            b.writeUnsignedInt(a_ImbuementID);
            b.writeBoolean(a_UseProtectionCharm);
            this.m_ServerConnection.messageWriter.finishMessage();
            return;
         }
         catch(e:Error)
         {
            handleSendError(CAPPLYIMBUEMENT,e);
            return;
         }
      }
      
      public function sendCINSPECTNPCTRADE(param1:int, param2:int) : void
      {
         var b:ByteArray = null;
         var a_Type:int = param1;
         var a_Data:int = param2;
         try
         {
            b = this.m_ServerConnection.messageWriter.createMessage();
            b.writeByte(CLOOKNPCTRADE);
            b.writeShort(a_Type);
            b.writeByte(a_Data);
            this.m_ServerConnection.messageWriter.finishMessage();
            return;
         }
         catch(e:Error)
         {
            handleSendError(CLOOKNPCTRADE,e);
            return;
         }
      }
   }
}
