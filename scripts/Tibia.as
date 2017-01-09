package
{
   import build.ApperanceStorageFactory;
   import flash.display.StageAlign;
   import flash.display.StageScaleMode;
   import flash.errors.IllegalOperationError;
   import flash.events.ErrorEvent;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.MouseEvent;
   import flash.events.SecurityErrorEvent;
   import flash.events.TimerEvent;
   import flash.net.URLRequest;
   import flash.net.URLVariables;
   import flash.net.navigateToURL;
   import flash.utils.*;
   import loader.asset.IAssetProvider;
   import mx.binding.Binding;
   import mx.binding.BindingManager;
   import mx.binding.IBindingClient;
   import mx.binding.IWatcherSetupUtil;
   import mx.collections.ArrayCollection;
   import mx.containers.BoxDirection;
   import mx.containers.DividedBox;
   import mx.containers.HBox;
   import mx.core.Application;
   import mx.core.IUIComponent;
   import mx.core.UIComponentDescriptor;
   import mx.core.mx_internal;
   import mx.events.CloseEvent;
   import mx.events.DividerEvent;
   import mx.events.FlexEvent;
   import mx.events.PropertyChangeEvent;
   import mx.events.ResizeEvent;
   import mx.managers.CursorManager;
   import mx.managers.ToolTipManager;
   import mx.styles.CSSStyleDeclaration;
   import mx.styles.StyleManager;
   import shared.controls.CustomDividedBox;
   import shared.controls.EmbeddedDialog;
   import shared.skins.BitmapBorderSkin;
   import shared.skins.BitmapButtonIcon;
   import shared.skins.BitmapButtonSkin;
   import shared.skins.EmptySkin;
   import shared.skins.StyleSizedBitmapButtonSkin;
   import shared.skins.VectorBorderSkin;
   import shared.skins.VectorDataGridHeaderBackgroundSkin;
   import shared.skins.VectorDataGridHeaderSeparatorSkin;
   import shared.skins.VectorTabSkin;
   import shared.utility.URLHelper;
   import tibia.actionbar.ActionBarSet;
   import tibia.actionbar.HActionBarWidget;
   import tibia.actionbar.VActionBarWidget;
   import tibia.appearances.AppearanceStorage;
   import tibia.chat.ChatStorage;
   import tibia.chat.ChatWidget;
   import tibia.container.ContainerStorage;
   import tibia.controls.GameWindowContainer;
   import tibia.controls.GridContainer;
   import tibia.creatures.CreatureStorage;
   import tibia.creatures.Player;
   import tibia.creatures.StatusWidget;
   import tibia.cursors.DragCopyCursor;
   import tibia.cursors.DragLinkCursor;
   import tibia.cursors.DragMoveCursor;
   import tibia.cursors.DragNoneCursor;
   import tibia.cursors.ResizeHorizontalCursor;
   import tibia.cursors.ResizeVerticalCursor;
   import tibia.game.AccountCharacter;
   import tibia.game.CharacterSelectionWidget;
   import tibia.game.ConnectionLostWidget;
   import tibia.game.ContextMenuBase;
   import tibia.game.DeathMessageWidget;
   import tibia.game.FocusNotifier;
   import tibia.game.GameEvent;
   import tibia.game.IGameClient;
   import tibia.game.LoginWaitWidget;
   import tibia.game.MessageWidget;
   import tibia.game.PopUpBase;
   import tibia.game.PopUpQueue;
   import tibia.game.TimeoutWaitWidget;
   import tibia.help.UIEffectsManager;
   import tibia.ingameshop.IngameShopManager;
   import tibia.ingameshop.IngameShopProduct;
   import tibia.input.InputHandler;
   import tibia.input.gameaction.GameActionFactory;
   import tibia.magic.SpellStorage;
   import tibia.minimap.MiniMapStorage;
   import tibia.network.Communication;
   import tibia.network.Connection;
   import tibia.network.ConnectionEvent;
   import tibia.network.FailedConnectionRescheduler;
   import tibia.network.IConnectionData;
   import tibia.network.IServerConnection;
   import tibia.options.OptionsAsset;
   import tibia.options.OptionsStorage;
   import tibia.premium.PremiumManager;
   import tibia.sessiondump.Sessiondump;
   import tibia.sessiondump.SessiondumpConnectionData;
   import tibia.sessiondump.SessiondumpCreatureStorage;
   import tibia.sessiondump.controller.SessiondumpControllerBase;
   import tibia.sessiondump.controller.SessiondumpControllerHints;
   import tibia.sessiondump.controller.SessiondumpMouseShield;
   import tibia.sessiondump.hints.gameaction.SessiondumpHintsGameActionFactory;
   import tibia.sidebar.SideBarSet;
   import tibia.sidebar.SideBarWidget;
   import tibia.sidebar.ToggleBar;
   import tibia.sidebar.sideBarWidgetClasses.WidgetViewSkin;
   import tibia.worldmap.WorldMapStorage;
   import tibia.worldmap.WorldMapWidget;
   
   use namespace mx_internal;
   
   public class Tibia extends Application implements IBindingClient, IGameClient
   {
      
      protected static const CONNECTION_STATE_GAME:int = 4;
      
      private static const SHAREDOBJECT_NAME:String = "options";
      
      protected static const CONNECTION_STATE_PENDING:int = 3;
      
      public static const BUGGY_FLASH_PLAYER_VERSION:String = "21,0,0,182";
      
      public static const PROTOCOL_VERSION:int = 1101;
      
      public static var s_FrameTibiaTimestamp:Number = 0;
      
      public static var s_FrameRealTimestamp:Number = 0;
      
      protected static const ERR_INVALID_SIZE:int = 1;
      
      protected static const ERR_COULD_NOT_CONNECT:int = 5;
      
      public static const MAX_SESSION_KEY_LENGTH:int = 30;
      
      public static const CLIENT_TYPE:uint = 3;
      
      private static var _watcherSetupUtil:IWatcherSetupUtil;
      
      protected static const PACKETLENGTH_SIZE:int = 2;
      
      private static var s_LastTibiaFactorChangeRealTimestamp:int = 0;
      
      protected static const CHECKSUM_POS:int = PACKETLENGTH_POS + PACKETLENGTH_SIZE;
      
      public static const CLIENT_VERSION:uint = 2405;
      
      public static const PREVIEW_STATE_PREVIEW_NO_ACTIVE_CHANGE:uint = 1;
      
      protected static const PAYLOADLENGTH_POS:int = PAYLOAD_POS;
      
      protected static const CONNECTION_STATE_DISCONNECTED:int = 0;
      
      private static const OPTIONS_SAVE_INTERVAL:int = 30 * 60 * 1000;
      
      public static const PREVIEW_STATE_REGULAR:uint = 0;
      
      protected static const ERR_INVALID_CHECKSUM:int = 2;
      
      protected static const HEADER_SIZE:int = PACKETLENGTH_SIZE + CHECKSUM_SIZE;
      
      protected static const ERR_INTERNAL:int = 0;
      
      protected static const CHECKSUM_SIZE:int = 4;
      
      protected static const PAYLOADDATA_POSITION:int = PAYLOADLENGTH_POS + PAYLOADLENGTH_SIZE;
      
      protected static const HEADER_POS:int = 0;
      
      protected static const ERR_INVALID_MESSAGE:int = 3;
      
      public static var s_TibiaLoginTimestamp:Number = 0;
      
      private static const BUNDLE:String = "Tibia";
      
      public static const PREVIEW_STATE_PREVIEW_WITH_ACTIVE_CHANGE:uint = 2;
      
      protected static const ERR_INVALID_STATE:int = 4;
      
      protected static const PAYLOADLENGTH_SIZE:int = 2;
      
      private static var s_InternalTibiaTimerFactor:Number = 1;
      
      public static const CLIENT_PREVIEW_STATE:uint = 0;
      
      mx_internal static var _Tibia_StylesInit_done:Boolean = false;
      
      protected static const CONNECTION_STATE_CONNECTING_STAGE1:int = 1;
      
      protected static const CONNECTION_STATE_CONNECTING_STAGE2:int = 2;
      
      private static var s_LastTibiaFactorChangeTibiaTimestamp:uint = 0;
      
      private static var s_LastTibiaTimestamp:int = 0;
      
      protected static const PACKETLENGTH_POS:int = HEADER_POS;
      
      protected static const PAYLOAD_POS:int = HEADER_POS + HEADER_SIZE;
      
      protected static const ERR_CONNECTION_LOST:int = 6;
       
      
      private var _embed_css____images_prey_prey_unlock_temporarily_png_1138134336:Class;
      
      private var _embed_css_images_Icons_WidgetMenu_Skull_idle_png_1630824013:Class;
      
      private var _embed_css_images_custombutton_Button_Standard_tileable_ml_idle_png_1785933248:Class;
      
      private var _embed_css_images_Icons_Conditions_Strenghtened_png_957751449:Class;
      
      protected var m_CurrentOptionsAsset:OptionsAsset = null;
      
      private var _embed_css_images_Icons_CombatControls_PvPOn_active_png_342724498:Class;
      
      private var _embed_css_images_custombutton_Button_Highlight_tileable_bl_idle_png_308178610:Class;
      
      private var _embed_css_images_Arrow_ScrollHotkeys_over_png_191481507:Class;
      
      private var _embed_css_images_Button_PurchaseComplete_over_png_1939813504:Class;
      
      private var _embed_css____images_prey_prey_bonus_reroll_png_1664079721:Class;
      
      private var _embed_css_images_Icons_ProgressBars_SwordFighting_png_388408934:Class;
      
      private var _embed_css_images_Icons_WidgetMenu_GeneralControls_active_over_png_239349245:Class;
      
      private var _embed_css_images_Slot_InventoryHead_png_556570291:Class;
      
      private var _embed_css_images_Icons_Conditions_Drunk_png_495340422:Class;
      
      private var _embed_css_images_BarsHealth_fat_GreenFull_png_1675173631:Class;
      
      private var _embed_css_images_Icons_WidgetMenu_Inventory_idle_over_png_1298136851:Class;
      
      private var _embed_css____images_prey_prey_list_reroll_png_1720722638:Class;
      
      private var _embed_css_images_Icons_BattleList_HideSkulled_over_png_238536285:Class;
      
      private var _embed_css_images_Button_ContainerUp_over_png_133274678:Class;
      
      private var _embed_css_images_Button_LockHotkeys_UnLocked_idle_png_587263282:Class;
      
      mx_internal var _bindingsByDestination:Object;
      
      private var _embed_css_images_Icons_WidgetMenu_Inventory_active_over_png_609144603:Class;
      
      private var _embed_css_images_Arrow_ScrollTabs_over_png_1462627108:Class;
      
      private var _1314206572m_UIWorldMapWidget:WorldMapWidget;
      
      private var _embed_css_images_custombutton_Button_Standard_tileable_ml_over_png_517648064:Class;
      
      private var _embed_css_images_Icons_CombatControls_StandOff_over_png_325171198:Class;
      
      private var _embed_css_images_custombutton_Button_Border_tileable_ml_pressed_png_1348489359:Class;
      
      private var _embed_css_images_custombutton_Button_Standard_tileable_bl_disabled_png_1093953119:Class;
      
      private var _embed_css_images_Icons_WidgetMenu_Skull_active_png_1541707963:Class;
      
      private var _embed_css_images_Icons_TradeLists_ContainerDisplay_idle_png_851212863:Class;
      
      private var _embed_css_images_Icons_Inventory_StoreInbox_png_2111006747:Class;
      
      private var _embed_css_images_Icons_WidgetHeaders_Minimap_png_1626881241:Class;
      
      private var _embed_css_images_BarsHealth_default_GreenFull_png_807562777:Class;
      
      private var _embed_css_images_custombutton_Button_Gold_tileable_tc_pressed_png_206403197:Class;
      
      protected var m_ContainerStorage:ContainerStorage = null;
      
      private var _embed_css_images_Minimap_ZoomOut_pressed_png_630904298:Class;
      
      private var _embed_css_____assets_images_imbuing_imbuing_icon_remove_disabled_png_1775436169:Class;
      
      private var _embed_css_images_Icons_CombatControls_WhiteHandOff_over_png_1354370208:Class;
      
      protected var m_CurrentOptionsUploadErrorDelay:int = 0;
      
      private var _embed_css_images_Arrow_Minimap_LevelUpDown_over_png_536705658:Class;
      
      private var _1020379552m_UITibiaRootContainer:HBox;
      
      private var _embed_css_images_BarsHealth_compact_RedLow_png_298615636:Class;
      
      protected var m_IsActive:Boolean = false;
      
      private var _embed_css_images_Icons_CombatControls_DoveOff_over_png_1096554064:Class;
      
      private var _embed_css_images_custombutton_Button_Standard_tileable_ml_pressed_png_165397636:Class;
      
      private var _embed_css_images_Button_ChatTab_Close_pressed_png_1974009856:Class;
      
      private var _embed_css_images_custombutton_Button_Border_tileable_bc_disabled_png_372459381:Class;
      
      private var _embed_css_images_Icons_IngameShop_12x12_Yes_png_1011478395:Class;
      
      private var _embed_css_images_Icons_TradeLists_ListDisplay_over_png_417076086:Class;
      
      private var _embed_css_images_Minimap_ZoomIn_over_png_1410316311:Class;
      
      private var _embed_css_images_Button_ChatTab_Close_idle_png_1545025108:Class;
      
      private var _embed_css_images_custombutton_Button_Gold_tileable_tl_idle_png_1873827252:Class;
      
      private var _embed_css_images_BarsHealth_compact_RedLow2_png_6321508:Class;
      
      private var _embed_css_images_Icons_CombatControls_AutochaseOn_idle_png_1441980539:Class;
      
      private var _embed_css_images_Icons_Conditions_Poisoned_png_1674352817:Class;
      
      private var _embed_css_images_Scrollbar_Arrow_up_over_png_933050065:Class;
      
      protected var m_Options:OptionsStorage = null;
      
      private var _embed_css_images_Slot_InventoryAmmo_protected_png_235878180:Class;
      
      protected var m_CurrentOptionsLastUpload:int = -2.147483648E9;
      
      private var _embed_css_images_Arrow_ScrollHotkeys_pressed_png_1194517687:Class;
      
      private var _embed_css_images_Arrow_ScrollTabs_pressed_png_169219784:Class;
      
      private var _embed_css_images_Icons_CombatControls_RedFistOff_idle_png_2005346177:Class;
      
      private var _embed_css_images_Minimap_Center_idle_png_1943470262:Class;
      
      private var m_TutorialMode:Boolean = false;
      
      private var _embed_css_images_Icons_BattleList_HideNPCs_active_png_1949955707:Class;
      
      private var _embed_css_images_Icons_WidgetMenu_Prey_active_over_png_224076033:Class;
      
      private var _embed_css_images_Icons_Conditions_Slowed_png_479759276:Class;
      
      private var _embed_css_images_custombutton_Button_Border_tileable_tl_idle_png_402102152:Class;
      
      private var _embed_css_images_BuySellTab_idle_png_886708504:Class;
      
      private var _embed_css_images_Icons_WidgetMenu_VipList_idle_png_298077813:Class;
      
      private var _embed_css____images_prey_prey_list_reroll_disabled_png_1408279029:Class;
      
      private var _embed_css____images_prey_prey_confirm_monster_selection_png_1854902533:Class;
      
      private var _embed_css_images_Icons_WidgetMenu_Blessings_active_png_1623160046:Class;
      
      private var _1174474338m_UIActionBarLeft:VActionBarWidget;
      
      private var _embed_css_images_custombutton_Button_Gold_tileable_bl_over_png_608410194:Class;
      
      private var _embed_css_images_Icons_CombatControls_OffensiveOff_over_png_1112870265:Class;
      
      private var m_FailedConnectionRescheduler:FailedConnectionRescheduler;
      
      private var _embed_css_images_custombutton_Button_Border_tileable_ml_idle_png_901180245:Class;
      
      protected var m_CurrentOptionsDirty:Boolean = false;
      
      private var _embed_css_images_BarsXP_default_improved_png_1615848679:Class;
      
      private var _embed_css_images_custombutton_Button_IngameShopBuy_tileable_pressed_png_1298820406:Class;
      
      private var _embed_css_images_Icons_CombatControls_Mounted_idle_png_264427409:Class;
      
      private var _embed_css_images_Widget_Footer_tileable_end02_png_302478279:Class;
      
      private var _embed_css_images_Button_ContainerUp_pressed_png_697201334:Class;
      
      private var _embed_css_images_Slot_InventoryShield_protected_png_1678489541:Class;
      
      private var _embed_css_images_BarsHealth_compact_GreenLow_png_823416786:Class;
      
      private var _embed_css_images_Icons_BattleList_HidePlayers_active_over_png_961154706:Class;
      
      private var _embed_css_images_Icons_BattleList_HideMonsters_idle_png_1297366744:Class;
      
      private var _embed_css_images_Icons_ProgressBars_AxeFighting_png_854207195:Class;
      
      private var _embed_css_images_Icons_ProgressBars_FistFighting_png_946464807:Class;
      
      private var _embed_css_images_Button_ChatTab_Close_over_png_1679055020:Class;
      
      private var _embed_css_images_Slot_InventoryArmor_png_1846126774:Class;
      
      private var _embed_css_images_Scrollbar_Handler_png_487857897:Class;
      
      private var _embed_css_images_Slot_InventoryLegs_png_1244810316:Class;
      
      private var m_GameClientReady:Boolean = false;
      
      private var _embed_css_images_Icons_CombatControls_DoveOn_over_png_927199358:Class;
      
      private var _embed_css_images_Icons_CombatControls_DefensiveOff_over_png_88580271:Class;
      
      private var _embed_css_images_BG_Bars_default_enpieceOrnamented_png_1621675861:Class;
      
      private var _embed_css_images_BG_BarsXP_default_endpiece_png_1394078162:Class;
      
      private var _embed_css____images_prey_prey_list_reroll_small_png_1392369160:Class;
      
      private var _embed_css_images_Slot_Statusicon_highlighted_png_1468805634:Class;
      
      private var _embed_css_images_Icons_WidgetMenu_Minimap_idle_png_483881531:Class;
      
      private var _embed_css_images_custombutton_Button_Gold_tileable_ml_pressed_png_921560467:Class;
      
      private var _embed_css_images_custombutton_Button_Gold_tileable_bc_over_png_1310818591:Class;
      
      private var _embed_css_images_custombutton_Button_Standard_tileable_tl_pressed_png_1968611417:Class;
      
      private var _embed_css_images_Icons_WidgetHeaders_GetPremium_png_582079029:Class;
      
      private var _embed_css_images_BG_ChatTab_Tabdrop_png_60591148:Class;
      
      private var _embed_css_____assets_images_ingameshop_Icons_IngameShop_32x14_TransferCoins_png_198242323:Class;
      
      private var _embed_css_images_Arrow_ScrollTabsHighlighted_pressed_png_1019332597:Class;
      
      private var _embed_css_images_Icons_ProgressBars_CompactStyle_png_2100207391:Class;
      
      private var _embed_css_images_Icons_CombatControls_Mounted_over_png_83007855:Class;
      
      private var _embed_css_images_Inventory_png_54849410:Class;
      
      private var _embed_css_images_custombutton_Button_IngameShopBuy_tileable_over_png_2100178506:Class;
      
      private var _embed_css_images_BarsProgress_compact_orange_png_605959778:Class;
      
      private var _embed_css_images_BarsHealth_fat_Yellow_png_1332323165:Class;
      
      private var _embed_css_images_custombutton_Button_Border_tileable_bc_over_png_373998323:Class;
      
      private var _embed_css_images_Icons_CombatControls_MediumOff_over_png_418575695:Class;
      
      private var m_ConnectionEstablishedAndPacketReceived:Boolean = false;
      
      private var _embed_css_images_Icons_BattleList_PartyMembers_idle_png_590067760:Class;
      
      private var _embed_css_images_Button_Maximize_idle_png_1094816082:Class;
      
      private var _embed_css_images_Slot_InventoryShield_png_8091800:Class;
      
      private var _embed_css_images_Icons_CombatControls_PvPOff_active_png_75654116:Class;
      
      private var _embed_css_images_Icons_CombatControls_ExpertMode_idle_png_884394490:Class;
      
      private var _embed_css_images_custombutton_Button_Highlight_tileable_bc_idle_png_1286951951:Class;
      
      private var _embed_css_images_Arrow_WidgetToggle_idle_png_550075419:Class;
      
      private var _embed_css_images_BG_BarsProgress_compact_endpiece_png_1448454481:Class;
      
      private var _embed_css_images_BarsXP_default_zero_png_841389645:Class;
      
      private var _embed_css_images_Arrow_ScrollHotkeys_idle_png_1989691811:Class;
      
      private var _embed_css_images_Icons_Conditions_Cursed_png_226830886:Class;
      
      private var _embed_css_images_custombutton_Button_Highlight_tileable_tl_idle_png_908937052:Class;
      
      private var _embed_css_images_custombutton_Button_Border_tileable_ml_disabled_png_1474936339:Class;
      
      private var _embed_css____images_prey_prey_list_reroll_small_reactivate_png_1096128443:Class;
      
      private var _embed_css_images_BG_Bars_compact_tileable_png_1378708577:Class;
      
      private var _embed_css_images_Icons_WidgetHeaders_Prey_png_1844002948:Class;
      
      private var _embed_css_images_custombutton_Button_Standard_tileable_bc_pressed_png_572612494:Class;
      
      private var _embed_css_images_Icons_CombatControls_WhiteHandOff_idle_png_1012304800:Class;
      
      private var _embed_css____images_prey_prey_list_reroll_reactivate_png_1106340657:Class;
      
      private var _embed_css_images_Icons_WidgetMenu_BattleList_idle_png_224575958:Class;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      private var _1404294856m_UIGameWindow:GridContainer;
      
      private var _embed_css_images_Icons_WidgetMenu_Skull_idle_over_png_611961046:Class;
      
      private var _embed_css_images_Icon_NoPremium_png_1355667196:Class;
      
      private var _embed_css_images_ChatTab_tileable_png_1152222910:Class;
      
      private var _embed_css_images_Icons_ProgressBars_ClubFighting_png_1530352971:Class;
      
      private var _embed_css_images_custombutton_Button_Standard_tileable_bc_idle_png_1982739778:Class;
      
      protected var m_Connection:IServerConnection = null;
      
      private var _embed_css_images_Slot_InventoryBoots_png_1593843512:Class;
      
      private var _embed_css_images_BG_Stone2_Tileable_png_1536416308:Class;
      
      private var _embed_css_images_Icons_WidgetMenu_GetPremium_active_over_png_347021528:Class;
      
      private var _embed_css_images_custombutton_Button_Standard_tileable_mc_pressed_png_81347079:Class;
      
      private var _embed_css_images_custombutton_Button_Standard_tileable_tc_idle_png_24708496:Class;
      
      private var _embed_css_images_Icons_CombatControls_StandOff_idle_png_1491392258:Class;
      
      private var _64278965m_UISideBarA:SideBarWidget;
      
      private var _embed_css_images_Icons_BattleList_HidePlayers_over_png_419396003:Class;
      
      private var _embed_css_images_Slot_InventoryAmmo_png_813114047:Class;
      
      private var _embed_css_images_custombutton_Button_Gold_tileable_bc_idle_png_1121387039:Class;
      
      private var _embed_css_images_custombutton_Button_Standard_tileable_tc_over_png_1841477776:Class;
      
      private var _embed_css_images_Icons_Conditions_PZlock_png_2031018067:Class;
      
      private var _embed_css_images_Scrollbar_Arrow_down_over_png_1994681196:Class;
      
      private var _embed_css_images_Arrow_ScrollTabsHighlighted_over_png_475447497:Class;
      
      private var _embed_css_images_custombutton_Button_Gold_tileable_tl_over_png_1141054284:Class;
      
      private var _embed_css_images_custombutton_Button_Gold_tileable_mc_idle_png_313886890:Class;
      
      private var _embed_css_images_Icons_ProgressBars_LargeStyle_png_1014712263:Class;
      
      private var _embed_css_images_Icons_WidgetMenu_GetPremium_active_png_778187739:Class;
      
      private var _embed_css_images_Icons_WidgetMenu_Combat_active_png_390223278:Class;
      
      private var _embed_css_images_custombutton_Button_Border_tileable_tc_idle_png_1026384539:Class;
      
      protected var m_ConnectionDataPending:int = -1;
      
      private var _embed_css_images_BarsHealth_default_RedLow2_png_1110203394:Class;
      
      private var _embed_css_images_Slot_InventoryHead_protected_png_819760770:Class;
      
      private var _embed_css_images_Icons_BattleList_HidePlayers_active_png_1087801247:Class;
      
      private var _embed_css_images_Button_Combat_Stop_pressed_png_1343706347:Class;
      
      private var _embed_css_images_BG_Combat_ExpertOff_png_1133893050:Class;
      
      private var _embed_css_images_Icons_WidgetMenu_Trades_active_over_png_1728513382:Class;
      
      private var _embed_css_images_BG_BohemianTileable_Game_png_1148175408:Class;
      
      private var _embed_css_images_Arrow_Minimap_LevelUpDown_pressed_png_1728357286:Class;
      
      private var _embed_css_images_Minimap_Center_active_png_2136380360:Class;
      
      private var _embed_css_images_Icons_WidgetMenu_BattleList_active_over_png_523969601:Class;
      
      private var _embed_css_images_Icons_Conditions_Drowning_png_142081554:Class;
      
      private var _embed_css_images_Slot_InventoryRing_protected_png_613777710:Class;
      
      private var _embed_css_images_custombutton_Button_Highlight_tileable_tc_pressed_png_1467694627:Class;
      
      private var _embed_css_images_Icons_WidgetMenu_VipList_active_over_png_177527574:Class;
      
      private var _embed_css_images_Icons_CombatControls_ExpertModeOn_idle_png_652505055:Class;
      
      private var _embed_css_images_custombutton_Button_Standard_tileable_tc_pressed_png_1274559636:Class;
      
      private var _embed_css_images_Icons_WidgetMenu_Blessings_idle_png_1665211264:Class;
      
      private var _embed_css_images_Scrollbar_Arrow_down_idle_png_500241812:Class;
      
      private var _embed_css_images_Minimap_png_803584357:Class;
      
      private var _embed_css_images_Icons_Conditions_Burning_png_1552261945:Class;
      
      private var _embed_css_images_Slot_InventoryBoots_protected_png_395711413:Class;
      
      private var _embed_css_images_BarsHealth_default_RedLow_png_2034053770:Class;
      
      private var _embed_css_images_BG_BohemianTileable_ChatConsole_png_2063585141:Class;
      
      protected var m_WorldMapStorage:WorldMapStorage = null;
      
      private var _embed_css_images_Icons_CombatControls_WhiteHandOn_over_png_2062716238:Class;
      
      private var _embed_css_images_Minimap_ZoomOut_idle_png_1218964010:Class;
      
      private var _embed_css_images_UnjustifiedPoints_png_1971471823:Class;
      
      private var _embed_css_images_Icons_WidgetMenu_GetPremium_idle_png_1985287859:Class;
      
      protected var m_SpellStorage:SpellStorage = null;
      
      private var _1568861366m_UIOuterRootContainer:DividedBox;
      
      private var _embed_css_images_custombutton_Button_Border_tileable_tc_over_png_1913712539:Class;
      
      private var _embed_css_images_Arrow_ScrollHotkeys_disabled_png_326951061:Class;
      
      protected var m_CharacterDeath:Boolean = false;
      
      private var _embed_css_images_Icons_ProgressBars_ProgressOn_png_1171186177:Class;
      
      private var _embed_css_images_Slot_Hotkey_Cooldown_png_348452255:Class;
      
      private var _embed_css_images_Arrow_WidgetToggle_pressed_png_806241479:Class;
      
      private var _embed_css_images_BarsHealth_fat_Mana_png_1856202898:Class;
      
      private var _embed_css_images_Slot_InventoryNecklace_png_2012705831:Class;
      
      private var _embed_css_images_Button_Combat_Stop_over_png_564437783:Class;
      
      private var _embed_css_images_Icons_CombatControls_AutochaseOn_over_png_554521467:Class;
      
      private var _embed_css_images_Slot_InventoryBackpack_protected_png_274576798:Class;
      
      private var _embed_css_images_custombutton_Button_Standard_tileable_tl_disabled_png_1248907181:Class;
      
      protected var m_SecondaryTimestamp:int = 0;
      
      private var _embed_css_images_Icons_WidgetHeaders_BattleList_png_1186213636:Class;
      
      private var _embed_css_images_Icons_WidgetMenu_Containers_active_over_png_1480923629:Class;
      
      private var _embed_css_images_Border02_WidgetSidebar_slim_png_828323829:Class;
      
      private var _embed_css_images_Icons_BattleList_HideNPCs_over_png_977927827:Class;
      
      private var _embed_css_images_Icons_CombatControls_DoveOn_idle_png_1462206846:Class;
      
      private var _embed_css_images_Icons_WidgetMenu_Combat_idle_png_1668074132:Class;
      
      private var _embed_css_images_Bars_ProgressMarker_png_1761755336:Class;
      
      private var _embed_css_images_Icons_CombatControls_YellowHandOff_idle_png_768654451:Class;
      
      private var _embed_css_images_Arrow_WidgetToggle_BG_png_2044967256:Class;
      
      private var _embed_css_images_Slot_InventoryWeapon_png_1587500415:Class;
      
      private var _embed_css_images_Slot_InventoryArmor_protected_png_1192226633:Class;
      
      private var _embed_css_images_custombutton_Button_Standard_tileable_tl_over_png_546849157:Class;
      
      private var _embed_css_images_Arrow_Minimap_LevelUpDown_idle_png_332004998:Class;
      
      private var _embed_css_images_Border02_corners_png_1465567525:Class;
      
      private var _embed_css_images_Icons_WidgetMenu_Containers_active_png_309943728:Class;
      
      private var _embed_css_images_Scrollbar_Arrow_up_idle_png_48874961:Class;
      
      private var _embed_css_images_Slot_Statusicon_png_1608787474:Class;
      
      private var _embed_css_images_Icons_WidgetMenu_GeneralControls_active_png_611020736:Class;
      
      protected var m_PremiumManager:PremiumManager = null;
      
      private var _embed_css_images_Icons_BattleList_HideMonsters_active_over_png_1041894995:Class;
      
      private var _embed_css_images_Icons_CombatControls_ExpertModeOn_over_png_2021716257:Class;
      
      private var _embed_css_images_BarsHealth_fat_RedLow2_png_1983741974:Class;
      
      private var _embed_css_images_Button_Minimize_over_png_1989991220:Class;
      
      private var _embed_css_images_custombutton_Button_Gold_tileable_mc_pressed_png_1727779818:Class;
      
      private var _embed_css_____assets_images_imbuing_imbuing_icon_imbue_disabled_png_1836447193:Class;
      
      private var _embed_css____images_prey_prey_list_reroll_small_reactivate_disabled_png_1868832418:Class;
      
      private var _embed_css_images_Icons_BattleList_HideSkulled_active_png_1474407051:Class;
      
      private var _embed_css_images_Icons_BattleList_HideMonsters_active_png_1182126058:Class;
      
      private var _embed_css_images_Icons_Conditions_PZ_png_1659726190:Class;
      
      private var _embed_css_images_ChatTab_tileable_EndpieceLeft_png_1323048363:Class;
      
      private var _64278964m_UISideBarB:SideBarWidget;
      
      private var _embed_css_images_Widget_Footer_tileable_png_1914256359:Class;
      
      private var _embed_css_images_custombutton_Button_IngameShopBuy_tileable_end_pressed_png_301372130:Class;
      
      private var _embed_css_images_custombutton_Button_Border_tileable_ml_over_png_637758037:Class;
      
      private var _embed_css_images_BuySellTab_active_png_1449511366:Class;
      
      private var _embed_css_images_custombutton_Button_Standard_tileable_ml_disabled_png_1250879576:Class;
      
      private var _embed_css_images_Icons_CombatControls_RedFistOff_over_png_1679929985:Class;
      
      private var _embed_css_images_BarsHealth_fat_RedLow_png_1029541970:Class;
      
      private var _embed_css_images_Icons_WidgetMenu_Blessings_active_over_png_130321579:Class;
      
      private var _embed_css_images_Button_LockHotkeys_Locked_over_png_554269051:Class;
      
      private var _embed_css_images_Icons_WidgetMenu_GeneralControls_idle_over_png_1722601649:Class;
      
      private var _embed_css_images_Button_ContainerUp_idle_png_1017477430:Class;
      
      private var _embed_css_images_Icon_Premium_png_157361223:Class;
      
      private var _embed_css_images_Icons_WidgetMenu_Prey_idle_png_1066518890:Class;
      
      private var _embed_css_images_Icons_BattleList_HidePlayers_idle_png_112457565:Class;
      
      private var _embed_css_images_BG_Bars_default_tileable_png_813666947:Class;
      
      private var _embed_css_images_ChatTab_tileable_EndpieceRound_idle_png_1491157363:Class;
      
      private var _embed_css_images_Icons_CombatControls_YellowHandOn_over_png_713246121:Class;
      
      mx_internal var _bindings:Array;
      
      private var _embed_css_images_BarsHealth_fat_GreenLow_png_425933188:Class;
      
      private var _embed_css_images_BarsHealth_compact_GreenFull_png_147173125:Class;
      
      private var _embed_css_images_Icons_CombatControls_MediumOn_idle_png_1333658855:Class;
      
      private var _embed_css_images_BG_BarsProgress_compact_tileable_png_1503274352:Class;
      
      private var _embed_css_images_Icons_CombatControls_MediumOn_over_png_1002865639:Class;
      
      private var _embed_css_images_custombutton_Button_Gold_tileable_tl_pressed_png_169894520:Class;
      
      private var _embed_css_images_BarsHealth_default_RedFull_png_60642647:Class;
      
      private var _embed_css_images_Button_Close_over_png_1551448006:Class;
      
      private var _embed_css_images_Icons_WidgetMenu_Combat_idle_over_png_665522223:Class;
      
      private var _embed_css_images_BarsHealth_compact_RedFull_png_1122893911:Class;
      
      private var _embed_css_images_Icons_ProgressBars_Shielding_png_1404202048:Class;
      
      private var _embed_css_images_Icons_WidgetMenu_Trades_idle_png_925331141:Class;
      
      private var _embed_css_images_Button_ChatTabIgnore_pressed_png_653700051:Class;
      
      private var _embed_css_images_Button_LockHotkeys_Locked_idle_png_885060219:Class;
      
      private var _embed_css____images_prey_prey_confirm_monster_selection_disabled_png_1540726376:Class;
      
      private var _embed_css_images_Icons_CombatControls_DefensiveOff_idle_png_1794298449:Class;
      
      private var _embed_css_images_custombutton_Button_Highlight_tileable_tl_pressed_png_2092601240:Class;
      
      private var _embed_css_images_custombutton_Button_Highlight_tileable_ml_idle_png_1397612513:Class;
      
      private var _embed_css_images_Icons_WidgetMenu_VipList_active_png_781472649:Class;
      
      private var _embed_css_images_custombutton_Button_Standard_tileable_bl_pressed_png_1326387531:Class;
      
      private var _embed_css_images_custombutton_Button_Border_tileable_tl_pressed_png_1903116940:Class;
      
      private var _embed_css_images_Icons_WidgetHeaders_SafeTrades_png_1491550258:Class;
      
      private var _embed_css_images_ChatTab_tileable_EndpieceLeft_idle_png_1369512376:Class;
      
      private var _embed_css_images_custombutton_Button_Gold_tileable_bc_pressed_png_504718635:Class;
      
      private var _embed_css_images_Icons_CombatControls_OffensiveOff_idle_png_386961017:Class;
      
      private var _embed_css_images_custombutton_Button_Standard_tileable_mc_idle_png_1278990365:Class;
      
      private var _embed_css_images_Button_Minimize_pressed_png_1820422736:Class;
      
      private var _embed_css_images_custombutton_Button_Standard_tileable_mc_over_png_931421981:Class;
      
      private var _embed_css_images_Icons_WidgetMenu_Containers_idle_over_png_1529638289:Class;
      
      private var _embed_css_images_Icons_WidgetHeaders_Spells_png_527053179:Class;
      
      private var _embed_css_images_Icons_WidgetMenu_Minimap_idle_over_png_1778448670:Class;
      
      private var _2056921391m_UISideBarToggleLeft:ToggleBar;
      
      private var _embed_css_images_custombutton_Button_Standard_tileable_tc_disabled_png_509379672:Class;
      
      private var _embed_css____images_prey_prey_list_reroll_small_disabled_png_600754165:Class;
      
      private var _embed_css_images_Icons_CombatControls_RedFistOn_over_png_273027531:Class;
      
      private var _embed_css_images_custombutton_Button_Standard_tileable_bl_idle_png_1526099209:Class;
      
      private var _embed_css_images_Icons_CombatControls_PvPOn_idle_png_258280708:Class;
      
      private var _embed_css_images_Icons_Conditions_Electrified_png_1043769654:Class;
      
      private var _embed_css_images_BarsHealth_default_Mana_png_2014888902:Class;
      
      private var _embed_css_images_Scrollbar_Arrow_down_pressed_png_2102997480:Class;
      
      private var _embed_css_images_custombutton_Button_Highlight_tileable_tl_over_png_1798619228:Class;
      
      private var _embed_css_images_Icons_BattleList_HideSkulled_idle_png_629388963:Class;
      
      protected var m_AssetProvider:IAssetProvider = null;
      
      private var _embed_css_images_custombutton_Button_Highlight_tileable_bl_over_png_497741234:Class;
      
      private var _embed_css_images_BG_ChatTab_tileable_png_2031873750:Class;
      
      private var _embed_css_images_Button_ChatTabNew_pressed_png_1051530935:Class;
      
      private var _embed_css_images_Arrow_ScrollTabsHighlighted_idle_png_802144823:Class;
      
      private var _embed_css_images_custombutton_Button_Standard_tileable_bc_over_png_185603650:Class;
      
      private var _embed_css_images_Icons_Conditions_Logoutblock_png_626674025:Class;
      
      private var _embed_css_images_Minimap_ZoomIn_pressed_png_1554730941:Class;
      
      private var _embed_css_images_Button_MaximizePremium_over_png_138300341:Class;
      
      private var _embed_css_images_Slot_InventoryLegs_protected_png_785554311:Class;
      
      private var _embed_css_images_Icons_CombatControls_DefensiveOn_active_png_1844746073:Class;
      
      private var _embed_css_images_Icons_WidgetMenu_GeneralControls_idle_png_2058421838:Class;
      
      private var _embed_css_____assets_images_imbuing_imbuing_icon_imbue_active_png_2017811027:Class;
      
      private var _embed_css_images_Icons_BattleList_HideSkulled_active_over_png_660583768:Class;
      
      private var _embed_css_images_custombutton_Button_Border_tileable_tl_over_png_1128024712:Class;
      
      private var _embed_css_images_custombutton_Button_Border_tileable_tl_disabled_png_655788448:Class;
      
      private var _embed_css_images_Slot_InventoryRing_png_1209351389:Class;
      
      private var _embed_css_images_Button_LockHotkeys_UnLocked_over_png_935749170:Class;
      
      private var _embed_css_images_Icons_Conditions_Bleeding_png_325607052:Class;
      
      private var _embed_css_images_custombutton_Button_Border_tileable_bl_pressed_png_1894305430:Class;
      
      private var _embed_css_images_custombutton_Button_Standard_tileable_tl_idle_png_1925791611:Class;
      
      private var _embed_css_images_BG_Bars_fat_tileable_png_1851975525:Class;
      
      protected var m_DefaultOptionsAsset:OptionsAsset = null;
      
      private var _embed_css_images_Icons_WidgetMenu_Trades_active_png_1472479607:Class;
      
      private var _embed_css_images_custombutton_Button_Gold_tileable_tc_over_png_960245103:Class;
      
      private var _embed_css_images_Arrow_ScrollTabs_disabled_png_744892220:Class;
      
      private var _embed_css_images_Icons_BattleList_HideNPCs_idle_png_1862110099:Class;
      
      private var _embed_css_images_Icons_WidgetMenu_Skull_active_over_png_491271656:Class;
      
      private var _embed_css_images_Icons_WidgetMenu_Prey_active_png_1809319364:Class;
      
      private var _embed_css_images_Icons_ProgressBars_DistanceFighting_png_1306281466:Class;
      
      private var _embed_css_images_Minimap_ZoomIn_idle_png_394970857:Class;
      
      private var _embed_css_images_Icons_CombatControls_DefensiveOn_idle_png_1614728391:Class;
      
      private var _embed_css_images_custombutton_Button_Gold_tileable_tc_idle_png_628673647:Class;
      
      private var _embed_css_images_custombutton_Button_Border_tileable_bc_idle_png_721306611:Class;
      
      private var m_ForceDisableGameWindowSizeCalc:Boolean = false;
      
      private var _64278963m_UISideBarC:SideBarWidget;
      
      private var _embed_css_images_BG_Bars_compact_enpiece_png_1122989386:Class;
      
      private var _embed_css_images_Widget_Footer_tileable_end01_png_300497730:Class;
      
      private var _embed_css_images_Icons_WidgetMenu_Containers_idle_png_1947022978:Class;
      
      private var _embed_css_images_Icons_TradeLists_ContainerDisplay_over_png_1199957823:Class;
      
      private var _embed_css_images_Icons_Inventory_Store_png_1300473375:Class;
      
      private var _embed_css_images_Icons_BattleList_PartyMembers_active_png_1520198974:Class;
      
      private var _embed_css_images_Button_ChatTabIgnore_idle_png_373453081:Class;
      
      protected var m_CreatureStorage:CreatureStorage = null;
      
      private var _embed_css_images_Icons_ProgressBars_MagicLevel_png_1025231274:Class;
      
      private var _embed_css_images_Icons_ProgressBars_ParallelStyle_png_564397355:Class;
      
      private var _embed_css_images_Button_ChatTabNew_idle_png_1330657205:Class;
      
      private var _embed_css_____assets_images_imbuing_imbuing_icon_useprotection_active_png_1327320745:Class;
      
      private var _embed_css_images_Icons_ProgressBars_ProgressOff_png_1580407517:Class;
      
      private var _embed_css_images_slot_Hotkey_protected_png_1201653772:Class;
      
      private var _1356021457m_UICenterColumn:CustomDividedBox;
      
      private var _embed_css_images_BG_BarsXP_default_tileable_png_1408337339:Class;
      
      private var _embed_css_images_Icons_Conditions_Dazzled_png_1336617984:Class;
      
      protected var m_UIEffectsManager:UIEffectsManager = null;
      
      private var _embed_css_images_Button_PurchaseComplete_pressed_png_296739540:Class;
      
      protected var m_ConnectionDataList:Vector.<IConnectionData> = null;
      
      private var _embed_css_images_BarsXP_default__png_385879515:Class;
      
      private var _embed_css_images_Button_Close_idle_png_1218950854:Class;
      
      private var _embed_css_images_Button_Combat_Stop_idle_png_1826670103:Class;
      
      private var _embed_css_images_custombutton_Button_Border_tileable_bc_pressed_png_1988687265:Class;
      
      private var _embed_css_images_Arrow_WidgetToggle_over_png_334496997:Class;
      
      private var _embed_css_images_Icons_Conditions_Freezing_png_1581087256:Class;
      
      private var _embed_css_images_custombutton_Button_Border_tileable_bl_idle_png_1538038570:Class;
      
      private var _embed_css_images_Icons_WidgetHeaders_Combat_png_518010106:Class;
      
      private var _embed_css_images_ChatTab_tileable_idle_png_1025655505:Class;
      
      private var _embed_css_images_Icons_CombatControls_YellowHandOff_over_png_511982963:Class;
      
      private var _embed_css_images_BG_Widget_Menu_png_779308052:Class;
      
      private var _embed_css_images_custombutton_Button_Standard_tileable_mc_disabled_png_983765749:Class;
      
      private var _embed_css_images_Icons_CombatControls_OffensiveOn_idle_png_505642365:Class;
      
      private var _embed_css_images_Icons_WidgetMenu_Inventory_idle_png_1929909360:Class;
      
      private var _228925540m_UIStatusWidget:StatusWidget;
      
      private var _967396880m_UIBottomContainer:HBox;
      
      private var _embed_css_images_custombutton_Button_Highlight_tileable_tc_idle_png_1528191247:Class;
      
      private var _2043305115m_UIActionBarRight:VActionBarWidget;
      
      private var _embed_css_images_custombutton_Button_Border_tileable_bl_disabled_png_1194789362:Class;
      
      private var _embed_css_images_Widget_HeaderBG_png_1258056819:Class;
      
      private var _embed_css_images_Icons_CombatControls_PvPOff_idle_png_1515870738:Class;
      
      private var _embed_css_images_Button_Maximize_pressed_png_744580322:Class;
      
      private var _embed_css_images_custombutton_Button_Gold_tileable_ml_over_png_1035473025:Class;
      
      private var _embed_css_images_Icons_WidgetHeaders_Skull_png_980830817:Class;
      
      private var _embed_css_images_slot_container_png_1830671892:Class;
      
      protected var m_AppearanceStorage:AppearanceStorage = null;
      
      private var _embed_css_images_Button_ChatTabNew_over_png_67901621:Class;
      
      private var _embed_css_images_Button_Close_pressed_png_1627770558:Class;
      
      private var _embed_css_images_custombutton_Button_Border_tileable_bl_over_png_344982570:Class;
      
      private var _embed_css_images_Icons_WidgetMenu_Inventory_active_png_710741474:Class;
      
      private var _embed_css_images_Slot_InventoryWeapon_protected_png_1818101578:Class;
      
      private var _embed_css_images_Icons_BattleList_HideNPCs_active_over_png_551096440:Class;
      
      private var _embed_css_images_Slot_InventoryBackpack_png_1739537709:Class;
      
      private var _embed_css_images_Icons_TradeLists_ContainerDisplay_pressed_png_817941011:Class;
      
      private var _embed_css_images_Button_Minimize_idle_png_1665493556:Class;
      
      private var _629924354m_UIActionBarBottom:HActionBarWidget;
      
      public var _Tibia_Array1:Array;
      
      public var _Tibia_Array2:Array;
      
      private var _embed_css_images_Button_PurchaseComplete_idle_png_950754944:Class;
      
      private var _embed_css_images_Icons_CombatControls_Unmounted_idle_png_1675114250:Class;
      
      private var _embed_css_images_Border02_WidgetSidebar_png_43620945:Class;
      
      private var _embed_css_images_custombutton_Button_Highlight_tileable_bc_over_png_1207833841:Class;
      
      protected var m_ConnectionDataCurrent:int = -1;
      
      private var _embed_css_images_BG_Bars_default_enpiece_png_329250772:Class;
      
      private var _embed_css_images_Border_Widget_corner_png_969648405:Class;
      
      private var _embed_css_images_Icons_WidgetMenu_Combat_active_over_png_992770113:Class;
      
      private var _embed_css_images_custombutton_Button_Highlight_tileable_bl_pressed_png_697106038:Class;
      
      private var _embed_css_images_Icons_BattleList_PartyMembers_active_over_png_405251525:Class;
      
      private var _embed_css_images_custombutton_Button_Gold_tileable_mc_over_png_662243754:Class;
      
      private var _embed_css_images_custombutton_Button_Highlight_tileable_ml_over_png_1618062623:Class;
      
      private var _embed_css_images_Icons_BattleList_HideMonsters_over_png_1720793640:Class;
      
      private var _embed_css_images_slot_container_disabled_png_2143438719:Class;
      
      private var _embed_css_images_Minimap_ZoomOut_over_png_49587414:Class;
      
      private var _embed_css____images_prey_prey_unlock_permanently_png_1955932179:Class;
      
      private var _embed_css_images_Icons_TradeLists_ListDisplay_pressed_png_1846304974:Class;
      
      private var _embed_css_images_custombutton_Button_IngameShopBuy_tileable_end_over_png_2097822234:Class;
      
      private var _embed_css_images_Icons_WidgetMenu_BattleList_active_png_1129152252:Class;
      
      private var _embed_css_images_Icons_BattleList_PartyMembers_over_png_289252560:Class;
      
      private var _embed_css_images_BarsHealth_fat_RedFull_png_1188262271:Class;
      
      private var _748017946m_UIInputHandler:InputHandler;
      
      private var _embed_css_____assets_images_imbuing_imbuing_icon_useprotection_disabled_png_1477840035:Class;
      
      private var _embed_css_images_BG_Bars_fat_enpiece_png_254994756:Class;
      
      private var _embed_css_images_custombutton_Button_Highlight_tileable_ml_pressed_png_1040849779:Class;
      
      private var _embed_css_images_Icons_WidgetHeaders_GeneralControls_png_227481822:Class;
      
      private var _1423351586m_UIActionBarTop:HActionBarWidget;
      
      private var _embed_css_images_custombutton_Button_Highlight_tileable_tc_over_png_271197681:Class;
      
      private var _64278962m_UISideBarD:SideBarWidget;
      
      private var _embed_css_images_custombutton_Button_IngameShopBuy_tileable_end_idle_png_812485402:Class;
      
      private var _embed_css____images_prey_prey_bonus_reroll_disabled_png_218744390:Class;
      
      private var _embed_css_images_Icons_CombatControls_OffensiveOn_over_png_1922169731:Class;
      
      private var _embed_css_images_Button_Maximize_over_png_1257962926:Class;
      
      private var _embed_css_images_ChatTab_tileable_EndpieceRound_png_1662843318:Class;
      
      private var _embed_css_images_Arrow_ScrollTabs_idle_png_1793155108:Class;
      
      private var _embed_css_images_Icons_WidgetMenu_Prey_idle_over_png_257691859:Class;
      
      private var _embed_css_images_Icons_WidgetMenu_Minimap_active_png_1080311283:Class;
      
      private var _embed_css_images_Icons_WidgetHeaders_Trades_png_107866521:Class;
      
      protected var m_TutorialData:Object;
      
      private var _embed_css_images_custombutton_Button_Standard_tileable_bl_over_png_1195435017:Class;
      
      private var _embed_css_images_Minimap_Center_over_png_803503178:Class;
      
      private var _embed_css_images_Icons_CombatControls_Unmounted_over_png_948934666:Class;
      
      protected var m_EnableFocusNotifier:Boolean = true;
      
      protected var m_CurrentOptionsUploading:Boolean = false;
      
      private var _embed_css_images_Icons_CombatControls_WhiteHandOn_idle_png_1901846962:Class;
      
      private var _embed_css_images_BarsHealth_default_GreenLow_png_1485470108:Class;
      
      private var _embed_css_images_BG_BohemianTileable_png_1964434549:Class;
      
      private var _embed_css_images_slot_Hotkey_highlighted_png_1867388771:Class;
      
      private var _embed_css_images_Icons_WidgetMenu_BattleList_idle_over_png_803885037:Class;
      
      private var _embed_css_images_Icons_Conditions_Hungry_png_1160557067:Class;
      
      private var _embed_css_images_Icons_ProgressBars_DefaultStyle_png_1681795459:Class;
      
      private var _embed_css_images_slot_container_highlighted_png_622440584:Class;
      
      private var _embed_css_images_BG_Bars_fat_enpieceOrnamented_png_805098349:Class;
      
      private var _embed_css_images_custombutton_Button_Gold_tileable_bl_idle_png_1140384942:Class;
      
      protected var m_ChatStorage:ChatStorage = null;
      
      protected var m_Player:Player = null;
      
      protected var m_SessionKey:String = null;
      
      private var _embed_css_____assets_images_ingameshop_Icons_IngameShop_12x12_TibiaCoin_png_552533231:Class;
      
      private var _embed_css_images_Icons_WidgetMenu_Trades_idle_over_png_433309128:Class;
      
      private var _embed_css_images_slot_Hotkey_disabled_png_669884428:Class;
      
      private var _embed_css_images_Scrollbar_Arrow_up_pressed_png_228522939:Class;
      
      private var _embed_css_images_Icons_CombatControls_ExpertMode_disabled_png_1087726802:Class;
      
      private var _1313911232m_UIWorldMapWindow:GameWindowContainer;
      
      private var _embed_css_images_Icons_CombatControls_DoveOff_idle_png_165836976:Class;
      
      private var _665607314m_UISideBarToggleRight:ToggleBar;
      
      protected var m_SeconaryTimer:Timer = null;
      
      private var _embed_css_images_Border02_png_856171138:Class;
      
      private var _embed_css_images_Border_Widget_png_589090515:Class;
      
      private var _embed_css_images_custombutton_Button_Border_tileable_tc_disabled_png_1563054077:Class;
      
      private var _embed_css_____assets_images_imbuing_imbuing_slot_empty_png_1983091155:Class;
      
      private var _embed_css_images_BarsHealth_default_Yellow_png_808052085:Class;
      
      private var _embed_css_images_Icons_CombatControls_MediumOff_idle_png_844732849:Class;
      
      private var _embed_css_images_Icons_TradeLists_ListDisplay_idle_png_1140494966:Class;
      
      private var _embed_css_images_Icons_WidgetMenu_VipList_idle_over_png_540002728:Class;
      
      private var _embed_css_images_Icons_Conditions_Haste_png_46815841:Class;
      
      private var _embed_css_images_BarsXP_default_malus_png_1083584633:Class;
      
      private var _embed_css_images_Arrow_HotkeyToggle_BG_png_368269210:Class;
      
      private var _embed_css_images_slot_Hotkey_png_542831063:Class;
      
      protected var m_Communication:Communication = null;
      
      protected var m_MiniMapStorage:MiniMapStorage = null;
      
      private var _embed_css_images_Scrollbar_tileable_png_2024027095:Class;
      
      private var _embed_css_images_Button_Close_disabled_png_447174510:Class;
      
      private var _embed_css_images_Slot_InventoryNecklace_protected_png_1785395660:Class;
      
      private var _embed_css_images_custombutton_Button_Gold_tileable_ml_idle_png_1852541313:Class;
      
      private var _embed_css_images_Icons_CombatControls_ExpertMode_over_png_13719802:Class;
      
      private var _embed_css_images_Icons_WidgetMenu_Minimap_active_over_png_376047536:Class;
      
      private var _embed_css_images_Icons_ProgressBars_Fishing_png_368980363:Class;
      
      private var _embed_css____images_prey_prey_list_reroll_reactivate_disabled_png_74434796:Class;
      
      private var _883427326m_UIChatWidget:ChatWidget;
      
      mx_internal var _watchers:Array;
      
      private var _embed_css_images_BG_Combat_ExpertOn_png_2127142674:Class;
      
      private var _embed_css_images_custombutton_Button_IngameShopBuy_tileable_idle_png_931484342:Class;
      
      private var _embed_css_____assets_images_imbuing_imbuing_icon_remove_active_png_831749865:Class;
      
      private var _embed_css_images_Icons_CombatControls_RedFistOn_idle_png_142442293:Class;
      
      private var m_GameActionFactory:GameActionFactory = null;
      
      protected var m_ChannelsPending:Vector.<int> = null;
      
      private var _embed_css_images_BG_Bars_compact_enpieceOrnamented_png_918003981:Class;
      
      private var m_ConnectionLostDialog:ConnectionLostWidget;
      
      private var _embed_css_images_Icons_CombatControls_YellowHandOn_idle_png_572971351:Class;
      
      private var _embed_css_images_Icons_IngameShop_12x12_No_png_85749109:Class;
      
      private var _embed_css_images_custombutton_Button_Highlight_tileable_bc_pressed_png_1234389013:Class;
      
      private var _embed_css_images_Icons_Conditions_MagicShield_png_246939656:Class;
      
      private var _embed_css_images_Icons_WidgetHeaders_VipList_png_164461471:Class;
      
      private var _embed_css_images_ChatWindow_Mover_png_1725151138:Class;
      
      private var _embed_css_images_Icons_WidgetHeaders_Inventory_png_2094138972:Class;
      
      private var _embed_css_images_custombutton_Button_Border_tileable_tc_pressed_png_502332351:Class;
      
      private var _embed_css_images_custombutton_Button_Gold_tileable_bl_pressed_png_1833599894:Class;
      
      private var _embed_css_images_Button_MaximizePremium_idle_png_1870457525:Class;
      
      private var _embed_css_images_custombutton_Button_Standard_tileable_bc_disabled_png_1867898870:Class;
      
      private var _embed_css_images_BarsHealth_compact_Yellow_png_1489515415:Class;
      
      private var _documentDescriptor_:UIComponentDescriptor;
      
      private var _embed_css_images_Button_ChatTabIgnore_over_png_906238439:Class;
      
      private var _embed_css_images_BarsHealth_compact_Mana_png_1712179560:Class;
      
      public function Tibia()
      {
         this._documentDescriptor_ = new UIComponentDescriptor({
            "type":Application,
            "propertiesFactory":function():Object
            {
               return {"childDescriptors":[new UIComponentDescriptor({
                  "type":DividedBox,
                  "id":"m_UIOuterRootContainer",
                  "propertiesFactory":function():Object
                  {
                     return {
                        "percentWidth":100,
                        "percentHeight":100,
                        "doubleClickEnabled":true,
                        "liveDragging":true,
                        "resizeToContent":true,
                        "styleName":"invisibleDivider",
                        "childDescriptors":[new UIComponentDescriptor({
                           "type":HBox,
                           "id":"m_UITibiaRootContainer",
                           "propertiesFactory":function():Object
                           {
                              return {
                                 "percentWidth":100,
                                 "percentHeight":100,
                                 "minHeight":450,
                                 "styleName":"rootContainer",
                                 "childDescriptors":[new UIComponentDescriptor({
                                    "type":SideBarWidget,
                                    "id":"m_UISideBarA",
                                    "propertiesFactory":function():Object
                                    {
                                       return {
                                          "percentHeight":100,
                                          "styleWithBorder":"sideBarLeftWithBorder"
                                       };
                                    }
                                 }),new UIComponentDescriptor({
                                    "type":SideBarWidget,
                                    "id":"m_UISideBarB",
                                    "propertiesFactory":function():Object
                                    {
                                       return {"percentHeight":100};
                                    }
                                 }),new UIComponentDescriptor({
                                    "type":ToggleBar,
                                    "id":"m_UISideBarToggleLeft",
                                    "propertiesFactory":function():Object
                                    {
                                       return {
                                          "percentHeight":100,
                                          "styleName":"sideBarToggleLeft",
                                          "location":_Tibia_Array1_i()
                                       };
                                    }
                                 }),new UIComponentDescriptor({
                                    "type":CustomDividedBox,
                                    "id":"m_UICenterColumn",
                                    "events":{"dividerRelease":"__m_UICenterColumn_dividerRelease"},
                                    "propertiesFactory":function():Object
                                    {
                                       return {
                                          "percentWidth":100,
                                          "percentHeight":100,
                                          "doubleClickEnabled":true,
                                          "liveDragging":true,
                                          "resizeToContent":true,
                                          "styleName":"rootContainer",
                                          "childDescriptors":[new UIComponentDescriptor({
                                             "type":GridContainer,
                                             "id":"m_UIGameWindow",
                                             "events":{"resize":"__m_UIGameWindow_resize"},
                                             "propertiesFactory":function():Object
                                             {
                                                return {
                                                   "percentWidth":100,
                                                   "percentHeight":100,
                                                   "center":_Tibia_GameWindowContainer1_i(),
                                                   "top":_Tibia_StatusWidget1_i()
                                                };
                                             }
                                          }),new UIComponentDescriptor({
                                             "type":ChatWidget,
                                             "id":"m_UIChatWidget",
                                             "propertiesFactory":function():Object
                                             {
                                                return {
                                                   "percentWidth":100,
                                                   "percentHeight":0
                                                };
                                             }
                                          })]
                                       };
                                    }
                                 }),new UIComponentDescriptor({
                                    "type":ToggleBar,
                                    "id":"m_UISideBarToggleRight",
                                    "propertiesFactory":function():Object
                                    {
                                       return {
                                          "percentHeight":100,
                                          "styleName":"sideBarToggleRight",
                                          "location":_Tibia_Array2_i()
                                       };
                                    }
                                 }),new UIComponentDescriptor({
                                    "type":SideBarWidget,
                                    "id":"m_UISideBarC",
                                    "propertiesFactory":function():Object
                                    {
                                       return {"percentHeight":100};
                                    }
                                 }),new UIComponentDescriptor({
                                    "type":SideBarWidget,
                                    "id":"m_UISideBarD",
                                    "propertiesFactory":function():Object
                                    {
                                       return {
                                          "percentHeight":100,
                                          "styleWithBorder":"sideBarRightWithBorder"
                                       };
                                    }
                                 })]
                              };
                           }
                        }),new UIComponentDescriptor({
                           "type":HBox,
                           "id":"m_UIBottomContainer",
                           "propertiesFactory":function():Object
                           {
                              return {
                                 "percentWidth":100,
                                 "height":0
                              };
                           }
                        })]
                     };
                  }
               }),new UIComponentDescriptor({
                  "type":InputHandler,
                  "id":"m_UIInputHandler",
                  "propertiesFactory":function():Object
                  {
                     return {
                        "width":0,
                        "height":0,
                        "x":-10,
                        "y":-10
                     };
                  }
               })]};
            }
         });
         this.m_ConnectionLostDialog = new ConnectionLostWidget();
         this.m_TutorialData = new Object();
         this.m_FailedConnectionRescheduler = new FailedConnectionRescheduler();
         this._embed_css_____assets_images_imbuing_imbuing_icon_imbue_active_png_2017811027 = Tibia__embed_css_____assets_images_imbuing_imbuing_icon_imbue_active_png_2017811027;
         this._embed_css_____assets_images_imbuing_imbuing_icon_imbue_disabled_png_1836447193 = Tibia__embed_css_____assets_images_imbuing_imbuing_icon_imbue_disabled_png_1836447193;
         this._embed_css_____assets_images_imbuing_imbuing_icon_remove_active_png_831749865 = Tibia__embed_css_____assets_images_imbuing_imbuing_icon_remove_active_png_831749865;
         this._embed_css_____assets_images_imbuing_imbuing_icon_remove_disabled_png_1775436169 = Tibia__embed_css_____assets_images_imbuing_imbuing_icon_remove_disabled_png_1775436169;
         this._embed_css_____assets_images_imbuing_imbuing_icon_useprotection_active_png_1327320745 = Tibia__embed_css_____assets_images_imbuing_imbuing_icon_useprotection_active_png_1327320745;
         this._embed_css_____assets_images_imbuing_imbuing_icon_useprotection_disabled_png_1477840035 = Tibia__embed_css_____assets_images_imbuing_imbuing_icon_useprotection_disabled_png_1477840035;
         this._embed_css_____assets_images_imbuing_imbuing_slot_empty_png_1983091155 = Tibia__embed_css_____assets_images_imbuing_imbuing_slot_empty_png_1983091155;
         this._embed_css_____assets_images_ingameshop_Icons_IngameShop_12x12_TibiaCoin_png_552533231 = Tibia__embed_css_____assets_images_ingameshop_Icons_IngameShop_12x12_TibiaCoin_png_552533231;
         this._embed_css_____assets_images_ingameshop_Icons_IngameShop_32x14_TransferCoins_png_198242323 = Tibia__embed_css_____assets_images_ingameshop_Icons_IngameShop_32x14_TransferCoins_png_198242323;
         this._embed_css____images_prey_prey_bonus_reroll_disabled_png_218744390 = Tibia__embed_css____images_prey_prey_bonus_reroll_disabled_png_218744390;
         this._embed_css____images_prey_prey_bonus_reroll_png_1664079721 = Tibia__embed_css____images_prey_prey_bonus_reroll_png_1664079721;
         this._embed_css____images_prey_prey_confirm_monster_selection_disabled_png_1540726376 = Tibia__embed_css____images_prey_prey_confirm_monster_selection_disabled_png_1540726376;
         this._embed_css____images_prey_prey_confirm_monster_selection_png_1854902533 = Tibia__embed_css____images_prey_prey_confirm_monster_selection_png_1854902533;
         this._embed_css____images_prey_prey_list_reroll_disabled_png_1408279029 = Tibia__embed_css____images_prey_prey_list_reroll_disabled_png_1408279029;
         this._embed_css____images_prey_prey_list_reroll_png_1720722638 = Tibia__embed_css____images_prey_prey_list_reroll_png_1720722638;
         this._embed_css____images_prey_prey_list_reroll_reactivate_disabled_png_74434796 = Tibia__embed_css____images_prey_prey_list_reroll_reactivate_disabled_png_74434796;
         this._embed_css____images_prey_prey_list_reroll_reactivate_png_1106340657 = Tibia__embed_css____images_prey_prey_list_reroll_reactivate_png_1106340657;
         this._embed_css____images_prey_prey_list_reroll_small_disabled_png_600754165 = Tibia__embed_css____images_prey_prey_list_reroll_small_disabled_png_600754165;
         this._embed_css____images_prey_prey_list_reroll_small_png_1392369160 = Tibia__embed_css____images_prey_prey_list_reroll_small_png_1392369160;
         this._embed_css____images_prey_prey_list_reroll_small_reactivate_disabled_png_1868832418 = Tibia__embed_css____images_prey_prey_list_reroll_small_reactivate_disabled_png_1868832418;
         this._embed_css____images_prey_prey_list_reroll_small_reactivate_png_1096128443 = Tibia__embed_css____images_prey_prey_list_reroll_small_reactivate_png_1096128443;
         this._embed_css____images_prey_prey_unlock_permanently_png_1955932179 = Tibia__embed_css____images_prey_prey_unlock_permanently_png_1955932179;
         this._embed_css____images_prey_prey_unlock_temporarily_png_1138134336 = Tibia__embed_css____images_prey_prey_unlock_temporarily_png_1138134336;
         this._embed_css_images_Arrow_HotkeyToggle_BG_png_368269210 = Tibia__embed_css_images_Arrow_HotkeyToggle_BG_png_368269210;
         this._embed_css_images_Arrow_Minimap_LevelUpDown_idle_png_332004998 = Tibia__embed_css_images_Arrow_Minimap_LevelUpDown_idle_png_332004998;
         this._embed_css_images_Arrow_Minimap_LevelUpDown_over_png_536705658 = Tibia__embed_css_images_Arrow_Minimap_LevelUpDown_over_png_536705658;
         this._embed_css_images_Arrow_Minimap_LevelUpDown_pressed_png_1728357286 = Tibia__embed_css_images_Arrow_Minimap_LevelUpDown_pressed_png_1728357286;
         this._embed_css_images_Arrow_ScrollHotkeys_disabled_png_326951061 = Tibia__embed_css_images_Arrow_ScrollHotkeys_disabled_png_326951061;
         this._embed_css_images_Arrow_ScrollHotkeys_idle_png_1989691811 = Tibia__embed_css_images_Arrow_ScrollHotkeys_idle_png_1989691811;
         this._embed_css_images_Arrow_ScrollHotkeys_over_png_191481507 = Tibia__embed_css_images_Arrow_ScrollHotkeys_over_png_191481507;
         this._embed_css_images_Arrow_ScrollHotkeys_pressed_png_1194517687 = Tibia__embed_css_images_Arrow_ScrollHotkeys_pressed_png_1194517687;
         this._embed_css_images_Arrow_ScrollTabsHighlighted_idle_png_802144823 = Tibia__embed_css_images_Arrow_ScrollTabsHighlighted_idle_png_802144823;
         this._embed_css_images_Arrow_ScrollTabsHighlighted_over_png_475447497 = Tibia__embed_css_images_Arrow_ScrollTabsHighlighted_over_png_475447497;
         this._embed_css_images_Arrow_ScrollTabsHighlighted_pressed_png_1019332597 = Tibia__embed_css_images_Arrow_ScrollTabsHighlighted_pressed_png_1019332597;
         this._embed_css_images_Arrow_ScrollTabs_disabled_png_744892220 = Tibia__embed_css_images_Arrow_ScrollTabs_disabled_png_744892220;
         this._embed_css_images_Arrow_ScrollTabs_idle_png_1793155108 = Tibia__embed_css_images_Arrow_ScrollTabs_idle_png_1793155108;
         this._embed_css_images_Arrow_ScrollTabs_over_png_1462627108 = Tibia__embed_css_images_Arrow_ScrollTabs_over_png_1462627108;
         this._embed_css_images_Arrow_ScrollTabs_pressed_png_169219784 = Tibia__embed_css_images_Arrow_ScrollTabs_pressed_png_169219784;
         this._embed_css_images_Arrow_WidgetToggle_BG_png_2044967256 = Tibia__embed_css_images_Arrow_WidgetToggle_BG_png_2044967256;
         this._embed_css_images_Arrow_WidgetToggle_idle_png_550075419 = Tibia__embed_css_images_Arrow_WidgetToggle_idle_png_550075419;
         this._embed_css_images_Arrow_WidgetToggle_over_png_334496997 = Tibia__embed_css_images_Arrow_WidgetToggle_over_png_334496997;
         this._embed_css_images_Arrow_WidgetToggle_pressed_png_806241479 = Tibia__embed_css_images_Arrow_WidgetToggle_pressed_png_806241479;
         this._embed_css_images_BG_BarsProgress_compact_endpiece_png_1448454481 = Tibia__embed_css_images_BG_BarsProgress_compact_endpiece_png_1448454481;
         this._embed_css_images_BG_BarsProgress_compact_tileable_png_1503274352 = Tibia__embed_css_images_BG_BarsProgress_compact_tileable_png_1503274352;
         this._embed_css_images_BG_BarsXP_default_endpiece_png_1394078162 = Tibia__embed_css_images_BG_BarsXP_default_endpiece_png_1394078162;
         this._embed_css_images_BG_BarsXP_default_tileable_png_1408337339 = Tibia__embed_css_images_BG_BarsXP_default_tileable_png_1408337339;
         this._embed_css_images_BG_Bars_compact_enpieceOrnamented_png_918003981 = Tibia__embed_css_images_BG_Bars_compact_enpieceOrnamented_png_918003981;
         this._embed_css_images_BG_Bars_compact_enpiece_png_1122989386 = Tibia__embed_css_images_BG_Bars_compact_enpiece_png_1122989386;
         this._embed_css_images_BG_Bars_compact_tileable_png_1378708577 = Tibia__embed_css_images_BG_Bars_compact_tileable_png_1378708577;
         this._embed_css_images_BG_Bars_default_enpieceOrnamented_png_1621675861 = Tibia__embed_css_images_BG_Bars_default_enpieceOrnamented_png_1621675861;
         this._embed_css_images_BG_Bars_default_enpiece_png_329250772 = Tibia__embed_css_images_BG_Bars_default_enpiece_png_329250772;
         this._embed_css_images_BG_Bars_default_tileable_png_813666947 = Tibia__embed_css_images_BG_Bars_default_tileable_png_813666947;
         this._embed_css_images_BG_Bars_fat_enpieceOrnamented_png_805098349 = Tibia__embed_css_images_BG_Bars_fat_enpieceOrnamented_png_805098349;
         this._embed_css_images_BG_Bars_fat_enpiece_png_254994756 = Tibia__embed_css_images_BG_Bars_fat_enpiece_png_254994756;
         this._embed_css_images_BG_Bars_fat_tileable_png_1851975525 = Tibia__embed_css_images_BG_Bars_fat_tileable_png_1851975525;
         this._embed_css_images_BG_BohemianTileable_ChatConsole_png_2063585141 = Tibia__embed_css_images_BG_BohemianTileable_ChatConsole_png_2063585141;
         this._embed_css_images_BG_BohemianTileable_Game_png_1148175408 = Tibia__embed_css_images_BG_BohemianTileable_Game_png_1148175408;
         this._embed_css_images_BG_BohemianTileable_png_1964434549 = Tibia__embed_css_images_BG_BohemianTileable_png_1964434549;
         this._embed_css_images_BG_ChatTab_Tabdrop_png_60591148 = Tibia__embed_css_images_BG_ChatTab_Tabdrop_png_60591148;
         this._embed_css_images_BG_ChatTab_tileable_png_2031873750 = Tibia__embed_css_images_BG_ChatTab_tileable_png_2031873750;
         this._embed_css_images_BG_Combat_ExpertOff_png_1133893050 = Tibia__embed_css_images_BG_Combat_ExpertOff_png_1133893050;
         this._embed_css_images_BG_Combat_ExpertOn_png_2127142674 = Tibia__embed_css_images_BG_Combat_ExpertOn_png_2127142674;
         this._embed_css_images_BG_Stone2_Tileable_png_1536416308 = Tibia__embed_css_images_BG_Stone2_Tileable_png_1536416308;
         this._embed_css_images_BG_Widget_Menu_png_779308052 = Tibia__embed_css_images_BG_Widget_Menu_png_779308052;
         this._embed_css_images_BarsHealth_compact_GreenFull_png_147173125 = Tibia__embed_css_images_BarsHealth_compact_GreenFull_png_147173125;
         this._embed_css_images_BarsHealth_compact_GreenLow_png_823416786 = Tibia__embed_css_images_BarsHealth_compact_GreenLow_png_823416786;
         this._embed_css_images_BarsHealth_compact_Mana_png_1712179560 = Tibia__embed_css_images_BarsHealth_compact_Mana_png_1712179560;
         this._embed_css_images_BarsHealth_compact_RedFull_png_1122893911 = Tibia__embed_css_images_BarsHealth_compact_RedFull_png_1122893911;
         this._embed_css_images_BarsHealth_compact_RedLow2_png_6321508 = Tibia__embed_css_images_BarsHealth_compact_RedLow2_png_6321508;
         this._embed_css_images_BarsHealth_compact_RedLow_png_298615636 = Tibia__embed_css_images_BarsHealth_compact_RedLow_png_298615636;
         this._embed_css_images_BarsHealth_compact_Yellow_png_1489515415 = Tibia__embed_css_images_BarsHealth_compact_Yellow_png_1489515415;
         this._embed_css_images_BarsHealth_default_GreenFull_png_807562777 = Tibia__embed_css_images_BarsHealth_default_GreenFull_png_807562777;
         this._embed_css_images_BarsHealth_default_GreenLow_png_1485470108 = Tibia__embed_css_images_BarsHealth_default_GreenLow_png_1485470108;
         this._embed_css_images_BarsHealth_default_Mana_png_2014888902 = Tibia__embed_css_images_BarsHealth_default_Mana_png_2014888902;
         this._embed_css_images_BarsHealth_default_RedFull_png_60642647 = Tibia__embed_css_images_BarsHealth_default_RedFull_png_60642647;
         this._embed_css_images_BarsHealth_default_RedLow2_png_1110203394 = Tibia__embed_css_images_BarsHealth_default_RedLow2_png_1110203394;
         this._embed_css_images_BarsHealth_default_RedLow_png_2034053770 = Tibia__embed_css_images_BarsHealth_default_RedLow_png_2034053770;
         this._embed_css_images_BarsHealth_default_Yellow_png_808052085 = Tibia__embed_css_images_BarsHealth_default_Yellow_png_808052085;
         this._embed_css_images_BarsHealth_fat_GreenFull_png_1675173631 = Tibia__embed_css_images_BarsHealth_fat_GreenFull_png_1675173631;
         this._embed_css_images_BarsHealth_fat_GreenLow_png_425933188 = Tibia__embed_css_images_BarsHealth_fat_GreenLow_png_425933188;
         this._embed_css_images_BarsHealth_fat_Mana_png_1856202898 = Tibia__embed_css_images_BarsHealth_fat_Mana_png_1856202898;
         this._embed_css_images_BarsHealth_fat_RedFull_png_1188262271 = Tibia__embed_css_images_BarsHealth_fat_RedFull_png_1188262271;
         this._embed_css_images_BarsHealth_fat_RedLow2_png_1983741974 = Tibia__embed_css_images_BarsHealth_fat_RedLow2_png_1983741974;
         this._embed_css_images_BarsHealth_fat_RedLow_png_1029541970 = Tibia__embed_css_images_BarsHealth_fat_RedLow_png_1029541970;
         this._embed_css_images_BarsHealth_fat_Yellow_png_1332323165 = Tibia__embed_css_images_BarsHealth_fat_Yellow_png_1332323165;
         this._embed_css_images_BarsProgress_compact_orange_png_605959778 = Tibia__embed_css_images_BarsProgress_compact_orange_png_605959778;
         this._embed_css_images_BarsXP_default__png_385879515 = Tibia__embed_css_images_BarsXP_default__png_385879515;
         this._embed_css_images_BarsXP_default_improved_png_1615848679 = Tibia__embed_css_images_BarsXP_default_improved_png_1615848679;
         this._embed_css_images_BarsXP_default_malus_png_1083584633 = Tibia__embed_css_images_BarsXP_default_malus_png_1083584633;
         this._embed_css_images_BarsXP_default_zero_png_841389645 = Tibia__embed_css_images_BarsXP_default_zero_png_841389645;
         this._embed_css_images_Bars_ProgressMarker_png_1761755336 = Tibia__embed_css_images_Bars_ProgressMarker_png_1761755336;
         this._embed_css_images_Border02_WidgetSidebar_png_43620945 = Tibia__embed_css_images_Border02_WidgetSidebar_png_43620945;
         this._embed_css_images_Border02_WidgetSidebar_slim_png_828323829 = Tibia__embed_css_images_Border02_WidgetSidebar_slim_png_828323829;
         this._embed_css_images_Border02_corners_png_1465567525 = Tibia__embed_css_images_Border02_corners_png_1465567525;
         this._embed_css_images_Border02_png_856171138 = Tibia__embed_css_images_Border02_png_856171138;
         this._embed_css_images_Border_Widget_corner_png_969648405 = Tibia__embed_css_images_Border_Widget_corner_png_969648405;
         this._embed_css_images_Border_Widget_png_589090515 = Tibia__embed_css_images_Border_Widget_png_589090515;
         this._embed_css_images_Button_ChatTabIgnore_idle_png_373453081 = Tibia__embed_css_images_Button_ChatTabIgnore_idle_png_373453081;
         this._embed_css_images_Button_ChatTabIgnore_over_png_906238439 = Tibia__embed_css_images_Button_ChatTabIgnore_over_png_906238439;
         this._embed_css_images_Button_ChatTabIgnore_pressed_png_653700051 = Tibia__embed_css_images_Button_ChatTabIgnore_pressed_png_653700051;
         this._embed_css_images_Button_ChatTabNew_idle_png_1330657205 = Tibia__embed_css_images_Button_ChatTabNew_idle_png_1330657205;
         this._embed_css_images_Button_ChatTabNew_over_png_67901621 = Tibia__embed_css_images_Button_ChatTabNew_over_png_67901621;
         this._embed_css_images_Button_ChatTabNew_pressed_png_1051530935 = Tibia__embed_css_images_Button_ChatTabNew_pressed_png_1051530935;
         this._embed_css_images_Button_ChatTab_Close_idle_png_1545025108 = Tibia__embed_css_images_Button_ChatTab_Close_idle_png_1545025108;
         this._embed_css_images_Button_ChatTab_Close_over_png_1679055020 = Tibia__embed_css_images_Button_ChatTab_Close_over_png_1679055020;
         this._embed_css_images_Button_ChatTab_Close_pressed_png_1974009856 = Tibia__embed_css_images_Button_ChatTab_Close_pressed_png_1974009856;
         this._embed_css_images_Button_Close_disabled_png_447174510 = Tibia__embed_css_images_Button_Close_disabled_png_447174510;
         this._embed_css_images_Button_Close_idle_png_1218950854 = Tibia__embed_css_images_Button_Close_idle_png_1218950854;
         this._embed_css_images_Button_Close_over_png_1551448006 = Tibia__embed_css_images_Button_Close_over_png_1551448006;
         this._embed_css_images_Button_Close_pressed_png_1627770558 = Tibia__embed_css_images_Button_Close_pressed_png_1627770558;
         this._embed_css_images_Button_Combat_Stop_idle_png_1826670103 = Tibia__embed_css_images_Button_Combat_Stop_idle_png_1826670103;
         this._embed_css_images_Button_Combat_Stop_over_png_564437783 = Tibia__embed_css_images_Button_Combat_Stop_over_png_564437783;
         this._embed_css_images_Button_Combat_Stop_pressed_png_1343706347 = Tibia__embed_css_images_Button_Combat_Stop_pressed_png_1343706347;
         this._embed_css_images_Button_ContainerUp_idle_png_1017477430 = Tibia__embed_css_images_Button_ContainerUp_idle_png_1017477430;
         this._embed_css_images_Button_ContainerUp_over_png_133274678 = Tibia__embed_css_images_Button_ContainerUp_over_png_133274678;
         this._embed_css_images_Button_ContainerUp_pressed_png_697201334 = Tibia__embed_css_images_Button_ContainerUp_pressed_png_697201334;
         this._embed_css_images_Button_LockHotkeys_Locked_idle_png_885060219 = Tibia__embed_css_images_Button_LockHotkeys_Locked_idle_png_885060219;
         this._embed_css_images_Button_LockHotkeys_Locked_over_png_554269051 = Tibia__embed_css_images_Button_LockHotkeys_Locked_over_png_554269051;
         this._embed_css_images_Button_LockHotkeys_UnLocked_idle_png_587263282 = Tibia__embed_css_images_Button_LockHotkeys_UnLocked_idle_png_587263282;
         this._embed_css_images_Button_LockHotkeys_UnLocked_over_png_935749170 = Tibia__embed_css_images_Button_LockHotkeys_UnLocked_over_png_935749170;
         this._embed_css_images_Button_MaximizePremium_idle_png_1870457525 = Tibia__embed_css_images_Button_MaximizePremium_idle_png_1870457525;
         this._embed_css_images_Button_MaximizePremium_over_png_138300341 = Tibia__embed_css_images_Button_MaximizePremium_over_png_138300341;
         this._embed_css_images_Button_Maximize_idle_png_1094816082 = Tibia__embed_css_images_Button_Maximize_idle_png_1094816082;
         this._embed_css_images_Button_Maximize_over_png_1257962926 = Tibia__embed_css_images_Button_Maximize_over_png_1257962926;
         this._embed_css_images_Button_Maximize_pressed_png_744580322 = Tibia__embed_css_images_Button_Maximize_pressed_png_744580322;
         this._embed_css_images_Button_Minimize_idle_png_1665493556 = Tibia__embed_css_images_Button_Minimize_idle_png_1665493556;
         this._embed_css_images_Button_Minimize_over_png_1989991220 = Tibia__embed_css_images_Button_Minimize_over_png_1989991220;
         this._embed_css_images_Button_Minimize_pressed_png_1820422736 = Tibia__embed_css_images_Button_Minimize_pressed_png_1820422736;
         this._embed_css_images_Button_PurchaseComplete_idle_png_950754944 = Tibia__embed_css_images_Button_PurchaseComplete_idle_png_950754944;
         this._embed_css_images_Button_PurchaseComplete_over_png_1939813504 = Tibia__embed_css_images_Button_PurchaseComplete_over_png_1939813504;
         this._embed_css_images_Button_PurchaseComplete_pressed_png_296739540 = Tibia__embed_css_images_Button_PurchaseComplete_pressed_png_296739540;
         this._embed_css_images_BuySellTab_active_png_1449511366 = Tibia__embed_css_images_BuySellTab_active_png_1449511366;
         this._embed_css_images_BuySellTab_idle_png_886708504 = Tibia__embed_css_images_BuySellTab_idle_png_886708504;
         this._embed_css_images_ChatTab_tileable_EndpieceLeft_idle_png_1369512376 = Tibia__embed_css_images_ChatTab_tileable_EndpieceLeft_idle_png_1369512376;
         this._embed_css_images_ChatTab_tileable_EndpieceLeft_png_1323048363 = Tibia__embed_css_images_ChatTab_tileable_EndpieceLeft_png_1323048363;
         this._embed_css_images_ChatTab_tileable_EndpieceRound_idle_png_1491157363 = Tibia__embed_css_images_ChatTab_tileable_EndpieceRound_idle_png_1491157363;
         this._embed_css_images_ChatTab_tileable_EndpieceRound_png_1662843318 = Tibia__embed_css_images_ChatTab_tileable_EndpieceRound_png_1662843318;
         this._embed_css_images_ChatTab_tileable_idle_png_1025655505 = Tibia__embed_css_images_ChatTab_tileable_idle_png_1025655505;
         this._embed_css_images_ChatTab_tileable_png_1152222910 = Tibia__embed_css_images_ChatTab_tileable_png_1152222910;
         this._embed_css_images_ChatWindow_Mover_png_1725151138 = Tibia__embed_css_images_ChatWindow_Mover_png_1725151138;
         this._embed_css_images_Icon_NoPremium_png_1355667196 = Tibia__embed_css_images_Icon_NoPremium_png_1355667196;
         this._embed_css_images_Icon_Premium_png_157361223 = Tibia__embed_css_images_Icon_Premium_png_157361223;
         this._embed_css_images_Icons_BattleList_HideMonsters_active_over_png_1041894995 = Tibia__embed_css_images_Icons_BattleList_HideMonsters_active_over_png_1041894995;
         this._embed_css_images_Icons_BattleList_HideMonsters_active_png_1182126058 = Tibia__embed_css_images_Icons_BattleList_HideMonsters_active_png_1182126058;
         this._embed_css_images_Icons_BattleList_HideMonsters_idle_png_1297366744 = Tibia__embed_css_images_Icons_BattleList_HideMonsters_idle_png_1297366744;
         this._embed_css_images_Icons_BattleList_HideMonsters_over_png_1720793640 = Tibia__embed_css_images_Icons_BattleList_HideMonsters_over_png_1720793640;
         this._embed_css_images_Icons_BattleList_HideNPCs_active_over_png_551096440 = Tibia__embed_css_images_Icons_BattleList_HideNPCs_active_over_png_551096440;
         this._embed_css_images_Icons_BattleList_HideNPCs_active_png_1949955707 = Tibia__embed_css_images_Icons_BattleList_HideNPCs_active_png_1949955707;
         this._embed_css_images_Icons_BattleList_HideNPCs_idle_png_1862110099 = Tibia__embed_css_images_Icons_BattleList_HideNPCs_idle_png_1862110099;
         this._embed_css_images_Icons_BattleList_HideNPCs_over_png_977927827 = Tibia__embed_css_images_Icons_BattleList_HideNPCs_over_png_977927827;
         this._embed_css_images_Icons_BattleList_HidePlayers_active_over_png_961154706 = Tibia__embed_css_images_Icons_BattleList_HidePlayers_active_over_png_961154706;
         this._embed_css_images_Icons_BattleList_HidePlayers_active_png_1087801247 = Tibia__embed_css_images_Icons_BattleList_HidePlayers_active_png_1087801247;
         this._embed_css_images_Icons_BattleList_HidePlayers_idle_png_112457565 = Tibia__embed_css_images_Icons_BattleList_HidePlayers_idle_png_112457565;
         this._embed_css_images_Icons_BattleList_HidePlayers_over_png_419396003 = Tibia__embed_css_images_Icons_BattleList_HidePlayers_over_png_419396003;
         this._embed_css_images_Icons_BattleList_HideSkulled_active_over_png_660583768 = Tibia__embed_css_images_Icons_BattleList_HideSkulled_active_over_png_660583768;
         this._embed_css_images_Icons_BattleList_HideSkulled_active_png_1474407051 = Tibia__embed_css_images_Icons_BattleList_HideSkulled_active_png_1474407051;
         this._embed_css_images_Icons_BattleList_HideSkulled_idle_png_629388963 = Tibia__embed_css_images_Icons_BattleList_HideSkulled_idle_png_629388963;
         this._embed_css_images_Icons_BattleList_HideSkulled_over_png_238536285 = Tibia__embed_css_images_Icons_BattleList_HideSkulled_over_png_238536285;
         this._embed_css_images_Icons_BattleList_PartyMembers_active_over_png_405251525 = Tibia__embed_css_images_Icons_BattleList_PartyMembers_active_over_png_405251525;
         this._embed_css_images_Icons_BattleList_PartyMembers_active_png_1520198974 = Tibia__embed_css_images_Icons_BattleList_PartyMembers_active_png_1520198974;
         this._embed_css_images_Icons_BattleList_PartyMembers_idle_png_590067760 = Tibia__embed_css_images_Icons_BattleList_PartyMembers_idle_png_590067760;
         this._embed_css_images_Icons_BattleList_PartyMembers_over_png_289252560 = Tibia__embed_css_images_Icons_BattleList_PartyMembers_over_png_289252560;
         this._embed_css_images_Icons_CombatControls_AutochaseOn_idle_png_1441980539 = Tibia__embed_css_images_Icons_CombatControls_AutochaseOn_idle_png_1441980539;
         this._embed_css_images_Icons_CombatControls_AutochaseOn_over_png_554521467 = Tibia__embed_css_images_Icons_CombatControls_AutochaseOn_over_png_554521467;
         this._embed_css_images_Icons_CombatControls_DefensiveOff_idle_png_1794298449 = Tibia__embed_css_images_Icons_CombatControls_DefensiveOff_idle_png_1794298449;
         this._embed_css_images_Icons_CombatControls_DefensiveOff_over_png_88580271 = Tibia__embed_css_images_Icons_CombatControls_DefensiveOff_over_png_88580271;
         this._embed_css_images_Icons_CombatControls_DefensiveOn_active_png_1844746073 = Tibia__embed_css_images_Icons_CombatControls_DefensiveOn_active_png_1844746073;
         this._embed_css_images_Icons_CombatControls_DefensiveOn_idle_png_1614728391 = Tibia__embed_css_images_Icons_CombatControls_DefensiveOn_idle_png_1614728391;
         this._embed_css_images_Icons_CombatControls_DoveOff_idle_png_165836976 = Tibia__embed_css_images_Icons_CombatControls_DoveOff_idle_png_165836976;
         this._embed_css_images_Icons_CombatControls_DoveOff_over_png_1096554064 = Tibia__embed_css_images_Icons_CombatControls_DoveOff_over_png_1096554064;
         this._embed_css_images_Icons_CombatControls_DoveOn_idle_png_1462206846 = Tibia__embed_css_images_Icons_CombatControls_DoveOn_idle_png_1462206846;
         this._embed_css_images_Icons_CombatControls_DoveOn_over_png_927199358 = Tibia__embed_css_images_Icons_CombatControls_DoveOn_over_png_927199358;
         this._embed_css_images_Icons_CombatControls_ExpertModeOn_idle_png_652505055 = Tibia__embed_css_images_Icons_CombatControls_ExpertModeOn_idle_png_652505055;
         this._embed_css_images_Icons_CombatControls_ExpertModeOn_over_png_2021716257 = Tibia__embed_css_images_Icons_CombatControls_ExpertModeOn_over_png_2021716257;
         this._embed_css_images_Icons_CombatControls_ExpertMode_disabled_png_1087726802 = Tibia__embed_css_images_Icons_CombatControls_ExpertMode_disabled_png_1087726802;
         this._embed_css_images_Icons_CombatControls_ExpertMode_idle_png_884394490 = Tibia__embed_css_images_Icons_CombatControls_ExpertMode_idle_png_884394490;
         this._embed_css_images_Icons_CombatControls_ExpertMode_over_png_13719802 = Tibia__embed_css_images_Icons_CombatControls_ExpertMode_over_png_13719802;
         this._embed_css_images_Icons_CombatControls_MediumOff_idle_png_844732849 = Tibia__embed_css_images_Icons_CombatControls_MediumOff_idle_png_844732849;
         this._embed_css_images_Icons_CombatControls_MediumOff_over_png_418575695 = Tibia__embed_css_images_Icons_CombatControls_MediumOff_over_png_418575695;
         this._embed_css_images_Icons_CombatControls_MediumOn_idle_png_1333658855 = Tibia__embed_css_images_Icons_CombatControls_MediumOn_idle_png_1333658855;
         this._embed_css_images_Icons_CombatControls_MediumOn_over_png_1002865639 = Tibia__embed_css_images_Icons_CombatControls_MediumOn_over_png_1002865639;
         this._embed_css_images_Icons_CombatControls_Mounted_idle_png_264427409 = Tibia__embed_css_images_Icons_CombatControls_Mounted_idle_png_264427409;
         this._embed_css_images_Icons_CombatControls_Mounted_over_png_83007855 = Tibia__embed_css_images_Icons_CombatControls_Mounted_over_png_83007855;
         this._embed_css_images_Icons_CombatControls_OffensiveOff_idle_png_386961017 = Tibia__embed_css_images_Icons_CombatControls_OffensiveOff_idle_png_386961017;
         this._embed_css_images_Icons_CombatControls_OffensiveOff_over_png_1112870265 = Tibia__embed_css_images_Icons_CombatControls_OffensiveOff_over_png_1112870265;
         this._embed_css_images_Icons_CombatControls_OffensiveOn_idle_png_505642365 = Tibia__embed_css_images_Icons_CombatControls_OffensiveOn_idle_png_505642365;
         this._embed_css_images_Icons_CombatControls_OffensiveOn_over_png_1922169731 = Tibia__embed_css_images_Icons_CombatControls_OffensiveOn_over_png_1922169731;
         this._embed_css_images_Icons_CombatControls_PvPOff_active_png_75654116 = Tibia__embed_css_images_Icons_CombatControls_PvPOff_active_png_75654116;
         this._embed_css_images_Icons_CombatControls_PvPOff_idle_png_1515870738 = Tibia__embed_css_images_Icons_CombatControls_PvPOff_idle_png_1515870738;
         this._embed_css_images_Icons_CombatControls_PvPOn_active_png_342724498 = Tibia__embed_css_images_Icons_CombatControls_PvPOn_active_png_342724498;
         this._embed_css_images_Icons_CombatControls_PvPOn_idle_png_258280708 = Tibia__embed_css_images_Icons_CombatControls_PvPOn_idle_png_258280708;
         this._embed_css_images_Icons_CombatControls_RedFistOff_idle_png_2005346177 = Tibia__embed_css_images_Icons_CombatControls_RedFistOff_idle_png_2005346177;
         this._embed_css_images_Icons_CombatControls_RedFistOff_over_png_1679929985 = Tibia__embed_css_images_Icons_CombatControls_RedFistOff_over_png_1679929985;
         this._embed_css_images_Icons_CombatControls_RedFistOn_idle_png_142442293 = Tibia__embed_css_images_Icons_CombatControls_RedFistOn_idle_png_142442293;
         this._embed_css_images_Icons_CombatControls_RedFistOn_over_png_273027531 = Tibia__embed_css_images_Icons_CombatControls_RedFistOn_over_png_273027531;
         this._embed_css_images_Icons_CombatControls_StandOff_idle_png_1491392258 = Tibia__embed_css_images_Icons_CombatControls_StandOff_idle_png_1491392258;
         this._embed_css_images_Icons_CombatControls_StandOff_over_png_325171198 = Tibia__embed_css_images_Icons_CombatControls_StandOff_over_png_325171198;
         this._embed_css_images_Icons_CombatControls_Unmounted_idle_png_1675114250 = Tibia__embed_css_images_Icons_CombatControls_Unmounted_idle_png_1675114250;
         this._embed_css_images_Icons_CombatControls_Unmounted_over_png_948934666 = Tibia__embed_css_images_Icons_CombatControls_Unmounted_over_png_948934666;
         this._embed_css_images_Icons_CombatControls_WhiteHandOff_idle_png_1012304800 = Tibia__embed_css_images_Icons_CombatControls_WhiteHandOff_idle_png_1012304800;
         this._embed_css_images_Icons_CombatControls_WhiteHandOff_over_png_1354370208 = Tibia__embed_css_images_Icons_CombatControls_WhiteHandOff_over_png_1354370208;
         this._embed_css_images_Icons_CombatControls_WhiteHandOn_idle_png_1901846962 = Tibia__embed_css_images_Icons_CombatControls_WhiteHandOn_idle_png_1901846962;
         this._embed_css_images_Icons_CombatControls_WhiteHandOn_over_png_2062716238 = Tibia__embed_css_images_Icons_CombatControls_WhiteHandOn_over_png_2062716238;
         this._embed_css_images_Icons_CombatControls_YellowHandOff_idle_png_768654451 = Tibia__embed_css_images_Icons_CombatControls_YellowHandOff_idle_png_768654451;
         this._embed_css_images_Icons_CombatControls_YellowHandOff_over_png_511982963 = Tibia__embed_css_images_Icons_CombatControls_YellowHandOff_over_png_511982963;
         this._embed_css_images_Icons_CombatControls_YellowHandOn_idle_png_572971351 = Tibia__embed_css_images_Icons_CombatControls_YellowHandOn_idle_png_572971351;
         this._embed_css_images_Icons_CombatControls_YellowHandOn_over_png_713246121 = Tibia__embed_css_images_Icons_CombatControls_YellowHandOn_over_png_713246121;
         this._embed_css_images_Icons_Conditions_Bleeding_png_325607052 = Tibia__embed_css_images_Icons_Conditions_Bleeding_png_325607052;
         this._embed_css_images_Icons_Conditions_Burning_png_1552261945 = Tibia__embed_css_images_Icons_Conditions_Burning_png_1552261945;
         this._embed_css_images_Icons_Conditions_Cursed_png_226830886 = Tibia__embed_css_images_Icons_Conditions_Cursed_png_226830886;
         this._embed_css_images_Icons_Conditions_Dazzled_png_1336617984 = Tibia__embed_css_images_Icons_Conditions_Dazzled_png_1336617984;
         this._embed_css_images_Icons_Conditions_Drowning_png_142081554 = Tibia__embed_css_images_Icons_Conditions_Drowning_png_142081554;
         this._embed_css_images_Icons_Conditions_Drunk_png_495340422 = Tibia__embed_css_images_Icons_Conditions_Drunk_png_495340422;
         this._embed_css_images_Icons_Conditions_Electrified_png_1043769654 = Tibia__embed_css_images_Icons_Conditions_Electrified_png_1043769654;
         this._embed_css_images_Icons_Conditions_Freezing_png_1581087256 = Tibia__embed_css_images_Icons_Conditions_Freezing_png_1581087256;
         this._embed_css_images_Icons_Conditions_Haste_png_46815841 = Tibia__embed_css_images_Icons_Conditions_Haste_png_46815841;
         this._embed_css_images_Icons_Conditions_Hungry_png_1160557067 = Tibia__embed_css_images_Icons_Conditions_Hungry_png_1160557067;
         this._embed_css_images_Icons_Conditions_Logoutblock_png_626674025 = Tibia__embed_css_images_Icons_Conditions_Logoutblock_png_626674025;
         this._embed_css_images_Icons_Conditions_MagicShield_png_246939656 = Tibia__embed_css_images_Icons_Conditions_MagicShield_png_246939656;
         this._embed_css_images_Icons_Conditions_PZ_png_1659726190 = Tibia__embed_css_images_Icons_Conditions_PZ_png_1659726190;
         this._embed_css_images_Icons_Conditions_PZlock_png_2031018067 = Tibia__embed_css_images_Icons_Conditions_PZlock_png_2031018067;
         this._embed_css_images_Icons_Conditions_Poisoned_png_1674352817 = Tibia__embed_css_images_Icons_Conditions_Poisoned_png_1674352817;
         this._embed_css_images_Icons_Conditions_Slowed_png_479759276 = Tibia__embed_css_images_Icons_Conditions_Slowed_png_479759276;
         this._embed_css_images_Icons_Conditions_Strenghtened_png_957751449 = Tibia__embed_css_images_Icons_Conditions_Strenghtened_png_957751449;
         this._embed_css_images_Icons_IngameShop_12x12_No_png_85749109 = Tibia__embed_css_images_Icons_IngameShop_12x12_No_png_85749109;
         this._embed_css_images_Icons_IngameShop_12x12_Yes_png_1011478395 = Tibia__embed_css_images_Icons_IngameShop_12x12_Yes_png_1011478395;
         this._embed_css_images_Icons_Inventory_StoreInbox_png_2111006747 = Tibia__embed_css_images_Icons_Inventory_StoreInbox_png_2111006747;
         this._embed_css_images_Icons_Inventory_Store_png_1300473375 = Tibia__embed_css_images_Icons_Inventory_Store_png_1300473375;
         this._embed_css_images_Icons_ProgressBars_AxeFighting_png_854207195 = Tibia__embed_css_images_Icons_ProgressBars_AxeFighting_png_854207195;
         this._embed_css_images_Icons_ProgressBars_ClubFighting_png_1530352971 = Tibia__embed_css_images_Icons_ProgressBars_ClubFighting_png_1530352971;
         this._embed_css_images_Icons_ProgressBars_CompactStyle_png_2100207391 = Tibia__embed_css_images_Icons_ProgressBars_CompactStyle_png_2100207391;
         this._embed_css_images_Icons_ProgressBars_DefaultStyle_png_1681795459 = Tibia__embed_css_images_Icons_ProgressBars_DefaultStyle_png_1681795459;
         this._embed_css_images_Icons_ProgressBars_DistanceFighting_png_1306281466 = Tibia__embed_css_images_Icons_ProgressBars_DistanceFighting_png_1306281466;
         this._embed_css_images_Icons_ProgressBars_Fishing_png_368980363 = Tibia__embed_css_images_Icons_ProgressBars_Fishing_png_368980363;
         this._embed_css_images_Icons_ProgressBars_FistFighting_png_946464807 = Tibia__embed_css_images_Icons_ProgressBars_FistFighting_png_946464807;
         this._embed_css_images_Icons_ProgressBars_LargeStyle_png_1014712263 = Tibia__embed_css_images_Icons_ProgressBars_LargeStyle_png_1014712263;
         this._embed_css_images_Icons_ProgressBars_MagicLevel_png_1025231274 = Tibia__embed_css_images_Icons_ProgressBars_MagicLevel_png_1025231274;
         this._embed_css_images_Icons_ProgressBars_ParallelStyle_png_564397355 = Tibia__embed_css_images_Icons_ProgressBars_ParallelStyle_png_564397355;
         this._embed_css_images_Icons_ProgressBars_ProgressOff_png_1580407517 = Tibia__embed_css_images_Icons_ProgressBars_ProgressOff_png_1580407517;
         this._embed_css_images_Icons_ProgressBars_ProgressOn_png_1171186177 = Tibia__embed_css_images_Icons_ProgressBars_ProgressOn_png_1171186177;
         this._embed_css_images_Icons_ProgressBars_Shielding_png_1404202048 = Tibia__embed_css_images_Icons_ProgressBars_Shielding_png_1404202048;
         this._embed_css_images_Icons_ProgressBars_SwordFighting_png_388408934 = Tibia__embed_css_images_Icons_ProgressBars_SwordFighting_png_388408934;
         this._embed_css_images_Icons_TradeLists_ContainerDisplay_idle_png_851212863 = Tibia__embed_css_images_Icons_TradeLists_ContainerDisplay_idle_png_851212863;
         this._embed_css_images_Icons_TradeLists_ContainerDisplay_over_png_1199957823 = Tibia__embed_css_images_Icons_TradeLists_ContainerDisplay_over_png_1199957823;
         this._embed_css_images_Icons_TradeLists_ContainerDisplay_pressed_png_817941011 = Tibia__embed_css_images_Icons_TradeLists_ContainerDisplay_pressed_png_817941011;
         this._embed_css_images_Icons_TradeLists_ListDisplay_idle_png_1140494966 = Tibia__embed_css_images_Icons_TradeLists_ListDisplay_idle_png_1140494966;
         this._embed_css_images_Icons_TradeLists_ListDisplay_over_png_417076086 = Tibia__embed_css_images_Icons_TradeLists_ListDisplay_over_png_417076086;
         this._embed_css_images_Icons_TradeLists_ListDisplay_pressed_png_1846304974 = Tibia__embed_css_images_Icons_TradeLists_ListDisplay_pressed_png_1846304974;
         this._embed_css_images_Icons_WidgetHeaders_BattleList_png_1186213636 = Tibia__embed_css_images_Icons_WidgetHeaders_BattleList_png_1186213636;
         this._embed_css_images_Icons_WidgetHeaders_Combat_png_518010106 = Tibia__embed_css_images_Icons_WidgetHeaders_Combat_png_518010106;
         this._embed_css_images_Icons_WidgetHeaders_GeneralControls_png_227481822 = Tibia__embed_css_images_Icons_WidgetHeaders_GeneralControls_png_227481822;
         this._embed_css_images_Icons_WidgetHeaders_GetPremium_png_582079029 = Tibia__embed_css_images_Icons_WidgetHeaders_GetPremium_png_582079029;
         this._embed_css_images_Icons_WidgetHeaders_Inventory_png_2094138972 = Tibia__embed_css_images_Icons_WidgetHeaders_Inventory_png_2094138972;
         this._embed_css_images_Icons_WidgetHeaders_Minimap_png_1626881241 = Tibia__embed_css_images_Icons_WidgetHeaders_Minimap_png_1626881241;
         this._embed_css_images_Icons_WidgetHeaders_Prey_png_1844002948 = Tibia__embed_css_images_Icons_WidgetHeaders_Prey_png_1844002948;
         this._embed_css_images_Icons_WidgetHeaders_SafeTrades_png_1491550258 = Tibia__embed_css_images_Icons_WidgetHeaders_SafeTrades_png_1491550258;
         this._embed_css_images_Icons_WidgetHeaders_Skull_png_980830817 = Tibia__embed_css_images_Icons_WidgetHeaders_Skull_png_980830817;
         this._embed_css_images_Icons_WidgetHeaders_Spells_png_527053179 = Tibia__embed_css_images_Icons_WidgetHeaders_Spells_png_527053179;
         this._embed_css_images_Icons_WidgetHeaders_Trades_png_107866521 = Tibia__embed_css_images_Icons_WidgetHeaders_Trades_png_107866521;
         this._embed_css_images_Icons_WidgetHeaders_VipList_png_164461471 = Tibia__embed_css_images_Icons_WidgetHeaders_VipList_png_164461471;
         this._embed_css_images_Icons_WidgetMenu_BattleList_active_over_png_523969601 = Tibia__embed_css_images_Icons_WidgetMenu_BattleList_active_over_png_523969601;
         this._embed_css_images_Icons_WidgetMenu_BattleList_active_png_1129152252 = Tibia__embed_css_images_Icons_WidgetMenu_BattleList_active_png_1129152252;
         this._embed_css_images_Icons_WidgetMenu_BattleList_idle_over_png_803885037 = Tibia__embed_css_images_Icons_WidgetMenu_BattleList_idle_over_png_803885037;
         this._embed_css_images_Icons_WidgetMenu_BattleList_idle_png_224575958 = Tibia__embed_css_images_Icons_WidgetMenu_BattleList_idle_png_224575958;
         this._embed_css_images_Icons_WidgetMenu_Blessings_active_over_png_130321579 = Tibia__embed_css_images_Icons_WidgetMenu_Blessings_active_over_png_130321579;
         this._embed_css_images_Icons_WidgetMenu_Blessings_active_png_1623160046 = Tibia__embed_css_images_Icons_WidgetMenu_Blessings_active_png_1623160046;
         this._embed_css_images_Icons_WidgetMenu_Blessings_idle_png_1665211264 = Tibia__embed_css_images_Icons_WidgetMenu_Blessings_idle_png_1665211264;
         this._embed_css_images_Icons_WidgetMenu_Combat_active_over_png_992770113 = Tibia__embed_css_images_Icons_WidgetMenu_Combat_active_over_png_992770113;
         this._embed_css_images_Icons_WidgetMenu_Combat_active_png_390223278 = Tibia__embed_css_images_Icons_WidgetMenu_Combat_active_png_390223278;
         this._embed_css_images_Icons_WidgetMenu_Combat_idle_over_png_665522223 = Tibia__embed_css_images_Icons_WidgetMenu_Combat_idle_over_png_665522223;
         this._embed_css_images_Icons_WidgetMenu_Combat_idle_png_1668074132 = Tibia__embed_css_images_Icons_WidgetMenu_Combat_idle_png_1668074132;
         this._embed_css_images_Icons_WidgetMenu_Containers_active_over_png_1480923629 = Tibia__embed_css_images_Icons_WidgetMenu_Containers_active_over_png_1480923629;
         this._embed_css_images_Icons_WidgetMenu_Containers_active_png_309943728 = Tibia__embed_css_images_Icons_WidgetMenu_Containers_active_png_309943728;
         this._embed_css_images_Icons_WidgetMenu_Containers_idle_over_png_1529638289 = Tibia__embed_css_images_Icons_WidgetMenu_Containers_idle_over_png_1529638289;
         this._embed_css_images_Icons_WidgetMenu_Containers_idle_png_1947022978 = Tibia__embed_css_images_Icons_WidgetMenu_Containers_idle_png_1947022978;
         this._embed_css_images_Icons_WidgetMenu_GeneralControls_active_over_png_239349245 = Tibia__embed_css_images_Icons_WidgetMenu_GeneralControls_active_over_png_239349245;
         this._embed_css_images_Icons_WidgetMenu_GeneralControls_active_png_611020736 = Tibia__embed_css_images_Icons_WidgetMenu_GeneralControls_active_png_611020736;
         this._embed_css_images_Icons_WidgetMenu_GeneralControls_idle_over_png_1722601649 = Tibia__embed_css_images_Icons_WidgetMenu_GeneralControls_idle_over_png_1722601649;
         this._embed_css_images_Icons_WidgetMenu_GeneralControls_idle_png_2058421838 = Tibia__embed_css_images_Icons_WidgetMenu_GeneralControls_idle_png_2058421838;
         this._embed_css_images_Icons_WidgetMenu_GetPremium_active_over_png_347021528 = Tibia__embed_css_images_Icons_WidgetMenu_GetPremium_active_over_png_347021528;
         this._embed_css_images_Icons_WidgetMenu_GetPremium_active_png_778187739 = Tibia__embed_css_images_Icons_WidgetMenu_GetPremium_active_png_778187739;
         this._embed_css_images_Icons_WidgetMenu_GetPremium_idle_png_1985287859 = Tibia__embed_css_images_Icons_WidgetMenu_GetPremium_idle_png_1985287859;
         this._embed_css_images_Icons_WidgetMenu_Inventory_active_over_png_609144603 = Tibia__embed_css_images_Icons_WidgetMenu_Inventory_active_over_png_609144603;
         this._embed_css_images_Icons_WidgetMenu_Inventory_active_png_710741474 = Tibia__embed_css_images_Icons_WidgetMenu_Inventory_active_png_710741474;
         this._embed_css_images_Icons_WidgetMenu_Inventory_idle_over_png_1298136851 = Tibia__embed_css_images_Icons_WidgetMenu_Inventory_idle_over_png_1298136851;
         this._embed_css_images_Icons_WidgetMenu_Inventory_idle_png_1929909360 = Tibia__embed_css_images_Icons_WidgetMenu_Inventory_idle_png_1929909360;
         this._embed_css_images_Icons_WidgetMenu_Minimap_active_over_png_376047536 = Tibia__embed_css_images_Icons_WidgetMenu_Minimap_active_over_png_376047536;
         this._embed_css_images_Icons_WidgetMenu_Minimap_active_png_1080311283 = Tibia__embed_css_images_Icons_WidgetMenu_Minimap_active_png_1080311283;
         this._embed_css_images_Icons_WidgetMenu_Minimap_idle_over_png_1778448670 = Tibia__embed_css_images_Icons_WidgetMenu_Minimap_idle_over_png_1778448670;
         this._embed_css_images_Icons_WidgetMenu_Minimap_idle_png_483881531 = Tibia__embed_css_images_Icons_WidgetMenu_Minimap_idle_png_483881531;
         this._embed_css_images_Icons_WidgetMenu_Prey_active_over_png_224076033 = Tibia__embed_css_images_Icons_WidgetMenu_Prey_active_over_png_224076033;
         this._embed_css_images_Icons_WidgetMenu_Prey_active_png_1809319364 = Tibia__embed_css_images_Icons_WidgetMenu_Prey_active_png_1809319364;
         this._embed_css_images_Icons_WidgetMenu_Prey_idle_over_png_257691859 = Tibia__embed_css_images_Icons_WidgetMenu_Prey_idle_over_png_257691859;
         this._embed_css_images_Icons_WidgetMenu_Prey_idle_png_1066518890 = Tibia__embed_css_images_Icons_WidgetMenu_Prey_idle_png_1066518890;
         this._embed_css_images_Icons_WidgetMenu_Skull_active_over_png_491271656 = Tibia__embed_css_images_Icons_WidgetMenu_Skull_active_over_png_491271656;
         this._embed_css_images_Icons_WidgetMenu_Skull_active_png_1541707963 = Tibia__embed_css_images_Icons_WidgetMenu_Skull_active_png_1541707963;
         this._embed_css_images_Icons_WidgetMenu_Skull_idle_over_png_611961046 = Tibia__embed_css_images_Icons_WidgetMenu_Skull_idle_over_png_611961046;
         this._embed_css_images_Icons_WidgetMenu_Skull_idle_png_1630824013 = Tibia__embed_css_images_Icons_WidgetMenu_Skull_idle_png_1630824013;
         this._embed_css_images_Icons_WidgetMenu_Trades_active_over_png_1728513382 = Tibia__embed_css_images_Icons_WidgetMenu_Trades_active_over_png_1728513382;
         this._embed_css_images_Icons_WidgetMenu_Trades_active_png_1472479607 = Tibia__embed_css_images_Icons_WidgetMenu_Trades_active_png_1472479607;
         this._embed_css_images_Icons_WidgetMenu_Trades_idle_over_png_433309128 = Tibia__embed_css_images_Icons_WidgetMenu_Trades_idle_over_png_433309128;
         this._embed_css_images_Icons_WidgetMenu_Trades_idle_png_925331141 = Tibia__embed_css_images_Icons_WidgetMenu_Trades_idle_png_925331141;
         this._embed_css_images_Icons_WidgetMenu_VipList_active_over_png_177527574 = Tibia__embed_css_images_Icons_WidgetMenu_VipList_active_over_png_177527574;
         this._embed_css_images_Icons_WidgetMenu_VipList_active_png_781472649 = Tibia__embed_css_images_Icons_WidgetMenu_VipList_active_png_781472649;
         this._embed_css_images_Icons_WidgetMenu_VipList_idle_over_png_540002728 = Tibia__embed_css_images_Icons_WidgetMenu_VipList_idle_over_png_540002728;
         this._embed_css_images_Icons_WidgetMenu_VipList_idle_png_298077813 = Tibia__embed_css_images_Icons_WidgetMenu_VipList_idle_png_298077813;
         this._embed_css_images_Inventory_png_54849410 = Tibia__embed_css_images_Inventory_png_54849410;
         this._embed_css_images_Minimap_Center_active_png_2136380360 = Tibia__embed_css_images_Minimap_Center_active_png_2136380360;
         this._embed_css_images_Minimap_Center_idle_png_1943470262 = Tibia__embed_css_images_Minimap_Center_idle_png_1943470262;
         this._embed_css_images_Minimap_Center_over_png_803503178 = Tibia__embed_css_images_Minimap_Center_over_png_803503178;
         this._embed_css_images_Minimap_ZoomIn_idle_png_394970857 = Tibia__embed_css_images_Minimap_ZoomIn_idle_png_394970857;
         this._embed_css_images_Minimap_ZoomIn_over_png_1410316311 = Tibia__embed_css_images_Minimap_ZoomIn_over_png_1410316311;
         this._embed_css_images_Minimap_ZoomIn_pressed_png_1554730941 = Tibia__embed_css_images_Minimap_ZoomIn_pressed_png_1554730941;
         this._embed_css_images_Minimap_ZoomOut_idle_png_1218964010 = Tibia__embed_css_images_Minimap_ZoomOut_idle_png_1218964010;
         this._embed_css_images_Minimap_ZoomOut_over_png_49587414 = Tibia__embed_css_images_Minimap_ZoomOut_over_png_49587414;
         this._embed_css_images_Minimap_ZoomOut_pressed_png_630904298 = Tibia__embed_css_images_Minimap_ZoomOut_pressed_png_630904298;
         this._embed_css_images_Minimap_png_803584357 = Tibia__embed_css_images_Minimap_png_803584357;
         this._embed_css_images_Scrollbar_Arrow_down_idle_png_500241812 = Tibia__embed_css_images_Scrollbar_Arrow_down_idle_png_500241812;
         this._embed_css_images_Scrollbar_Arrow_down_over_png_1994681196 = Tibia__embed_css_images_Scrollbar_Arrow_down_over_png_1994681196;
         this._embed_css_images_Scrollbar_Arrow_down_pressed_png_2102997480 = Tibia__embed_css_images_Scrollbar_Arrow_down_pressed_png_2102997480;
         this._embed_css_images_Scrollbar_Arrow_up_idle_png_48874961 = Tibia__embed_css_images_Scrollbar_Arrow_up_idle_png_48874961;
         this._embed_css_images_Scrollbar_Arrow_up_over_png_933050065 = Tibia__embed_css_images_Scrollbar_Arrow_up_over_png_933050065;
         this._embed_css_images_Scrollbar_Arrow_up_pressed_png_228522939 = Tibia__embed_css_images_Scrollbar_Arrow_up_pressed_png_228522939;
         this._embed_css_images_Scrollbar_Handler_png_487857897 = Tibia__embed_css_images_Scrollbar_Handler_png_487857897;
         this._embed_css_images_Scrollbar_tileable_png_2024027095 = Tibia__embed_css_images_Scrollbar_tileable_png_2024027095;
         this._embed_css_images_Slot_Hotkey_Cooldown_png_348452255 = Tibia__embed_css_images_Slot_Hotkey_Cooldown_png_348452255;
         this._embed_css_images_Slot_InventoryAmmo_png_813114047 = Tibia__embed_css_images_Slot_InventoryAmmo_png_813114047;
         this._embed_css_images_Slot_InventoryAmmo_protected_png_235878180 = Tibia__embed_css_images_Slot_InventoryAmmo_protected_png_235878180;
         this._embed_css_images_Slot_InventoryArmor_png_1846126774 = Tibia__embed_css_images_Slot_InventoryArmor_png_1846126774;
         this._embed_css_images_Slot_InventoryArmor_protected_png_1192226633 = Tibia__embed_css_images_Slot_InventoryArmor_protected_png_1192226633;
         this._embed_css_images_Slot_InventoryBackpack_png_1739537709 = Tibia__embed_css_images_Slot_InventoryBackpack_png_1739537709;
         this._embed_css_images_Slot_InventoryBackpack_protected_png_274576798 = Tibia__embed_css_images_Slot_InventoryBackpack_protected_png_274576798;
         this._embed_css_images_Slot_InventoryBoots_png_1593843512 = Tibia__embed_css_images_Slot_InventoryBoots_png_1593843512;
         this._embed_css_images_Slot_InventoryBoots_protected_png_395711413 = Tibia__embed_css_images_Slot_InventoryBoots_protected_png_395711413;
         this._embed_css_images_Slot_InventoryHead_png_556570291 = Tibia__embed_css_images_Slot_InventoryHead_png_556570291;
         this._embed_css_images_Slot_InventoryHead_protected_png_819760770 = Tibia__embed_css_images_Slot_InventoryHead_protected_png_819760770;
         this._embed_css_images_Slot_InventoryLegs_png_1244810316 = Tibia__embed_css_images_Slot_InventoryLegs_png_1244810316;
         this._embed_css_images_Slot_InventoryLegs_protected_png_785554311 = Tibia__embed_css_images_Slot_InventoryLegs_protected_png_785554311;
         this._embed_css_images_Slot_InventoryNecklace_png_2012705831 = Tibia__embed_css_images_Slot_InventoryNecklace_png_2012705831;
         this._embed_css_images_Slot_InventoryNecklace_protected_png_1785395660 = Tibia__embed_css_images_Slot_InventoryNecklace_protected_png_1785395660;
         this._embed_css_images_Slot_InventoryRing_png_1209351389 = Tibia__embed_css_images_Slot_InventoryRing_png_1209351389;
         this._embed_css_images_Slot_InventoryRing_protected_png_613777710 = Tibia__embed_css_images_Slot_InventoryRing_protected_png_613777710;
         this._embed_css_images_Slot_InventoryShield_png_8091800 = Tibia__embed_css_images_Slot_InventoryShield_png_8091800;
         this._embed_css_images_Slot_InventoryShield_protected_png_1678489541 = Tibia__embed_css_images_Slot_InventoryShield_protected_png_1678489541;
         this._embed_css_images_Slot_InventoryWeapon_png_1587500415 = Tibia__embed_css_images_Slot_InventoryWeapon_png_1587500415;
         this._embed_css_images_Slot_InventoryWeapon_protected_png_1818101578 = Tibia__embed_css_images_Slot_InventoryWeapon_protected_png_1818101578;
         this._embed_css_images_Slot_Statusicon_highlighted_png_1468805634 = Tibia__embed_css_images_Slot_Statusicon_highlighted_png_1468805634;
         this._embed_css_images_Slot_Statusicon_png_1608787474 = Tibia__embed_css_images_Slot_Statusicon_png_1608787474;
         this._embed_css_images_UnjustifiedPoints_png_1971471823 = Tibia__embed_css_images_UnjustifiedPoints_png_1971471823;
         this._embed_css_images_Widget_Footer_tileable_end01_png_300497730 = Tibia__embed_css_images_Widget_Footer_tileable_end01_png_300497730;
         this._embed_css_images_Widget_Footer_tileable_end02_png_302478279 = Tibia__embed_css_images_Widget_Footer_tileable_end02_png_302478279;
         this._embed_css_images_Widget_Footer_tileable_png_1914256359 = Tibia__embed_css_images_Widget_Footer_tileable_png_1914256359;
         this._embed_css_images_Widget_HeaderBG_png_1258056819 = Tibia__embed_css_images_Widget_HeaderBG_png_1258056819;
         this._embed_css_images_custombutton_Button_Border_tileable_bc_disabled_png_372459381 = Tibia__embed_css_images_custombutton_Button_Border_tileable_bc_disabled_png_372459381;
         this._embed_css_images_custombutton_Button_Border_tileable_bc_idle_png_721306611 = Tibia__embed_css_images_custombutton_Button_Border_tileable_bc_idle_png_721306611;
         this._embed_css_images_custombutton_Button_Border_tileable_bc_over_png_373998323 = Tibia__embed_css_images_custombutton_Button_Border_tileable_bc_over_png_373998323;
         this._embed_css_images_custombutton_Button_Border_tileable_bc_pressed_png_1988687265 = Tibia__embed_css_images_custombutton_Button_Border_tileable_bc_pressed_png_1988687265;
         this._embed_css_images_custombutton_Button_Border_tileable_bl_disabled_png_1194789362 = Tibia__embed_css_images_custombutton_Button_Border_tileable_bl_disabled_png_1194789362;
         this._embed_css_images_custombutton_Button_Border_tileable_bl_idle_png_1538038570 = Tibia__embed_css_images_custombutton_Button_Border_tileable_bl_idle_png_1538038570;
         this._embed_css_images_custombutton_Button_Border_tileable_bl_over_png_344982570 = Tibia__embed_css_images_custombutton_Button_Border_tileable_bl_over_png_344982570;
         this._embed_css_images_custombutton_Button_Border_tileable_bl_pressed_png_1894305430 = Tibia__embed_css_images_custombutton_Button_Border_tileable_bl_pressed_png_1894305430;
         this._embed_css_images_custombutton_Button_Border_tileable_ml_disabled_png_1474936339 = Tibia__embed_css_images_custombutton_Button_Border_tileable_ml_disabled_png_1474936339;
         this._embed_css_images_custombutton_Button_Border_tileable_ml_idle_png_901180245 = Tibia__embed_css_images_custombutton_Button_Border_tileable_ml_idle_png_901180245;
         this._embed_css_images_custombutton_Button_Border_tileable_ml_over_png_637758037 = Tibia__embed_css_images_custombutton_Button_Border_tileable_ml_over_png_637758037;
         this._embed_css_images_custombutton_Button_Border_tileable_ml_pressed_png_1348489359 = Tibia__embed_css_images_custombutton_Button_Border_tileable_ml_pressed_png_1348489359;
         this._embed_css_images_custombutton_Button_Border_tileable_tc_disabled_png_1563054077 = Tibia__embed_css_images_custombutton_Button_Border_tileable_tc_disabled_png_1563054077;
         this._embed_css_images_custombutton_Button_Border_tileable_tc_idle_png_1026384539 = Tibia__embed_css_images_custombutton_Button_Border_tileable_tc_idle_png_1026384539;
         this._embed_css_images_custombutton_Button_Border_tileable_tc_over_png_1913712539 = Tibia__embed_css_images_custombutton_Button_Border_tileable_tc_over_png_1913712539;
         this._embed_css_images_custombutton_Button_Border_tileable_tc_pressed_png_502332351 = Tibia__embed_css_images_custombutton_Button_Border_tileable_tc_pressed_png_502332351;
         this._embed_css_images_custombutton_Button_Border_tileable_tl_disabled_png_655788448 = Tibia__embed_css_images_custombutton_Button_Border_tileable_tl_disabled_png_655788448;
         this._embed_css_images_custombutton_Button_Border_tileable_tl_idle_png_402102152 = Tibia__embed_css_images_custombutton_Button_Border_tileable_tl_idle_png_402102152;
         this._embed_css_images_custombutton_Button_Border_tileable_tl_over_png_1128024712 = Tibia__embed_css_images_custombutton_Button_Border_tileable_tl_over_png_1128024712;
         this._embed_css_images_custombutton_Button_Border_tileable_tl_pressed_png_1903116940 = Tibia__embed_css_images_custombutton_Button_Border_tileable_tl_pressed_png_1903116940;
         this._embed_css_images_custombutton_Button_Gold_tileable_bc_idle_png_1121387039 = Tibia__embed_css_images_custombutton_Button_Gold_tileable_bc_idle_png_1121387039;
         this._embed_css_images_custombutton_Button_Gold_tileable_bc_over_png_1310818591 = Tibia__embed_css_images_custombutton_Button_Gold_tileable_bc_over_png_1310818591;
         this._embed_css_images_custombutton_Button_Gold_tileable_bc_pressed_png_504718635 = Tibia__embed_css_images_custombutton_Button_Gold_tileable_bc_pressed_png_504718635;
         this._embed_css_images_custombutton_Button_Gold_tileable_bl_idle_png_1140384942 = Tibia__embed_css_images_custombutton_Button_Gold_tileable_bl_idle_png_1140384942;
         this._embed_css_images_custombutton_Button_Gold_tileable_bl_over_png_608410194 = Tibia__embed_css_images_custombutton_Button_Gold_tileable_bl_over_png_608410194;
         this._embed_css_images_custombutton_Button_Gold_tileable_bl_pressed_png_1833599894 = Tibia__embed_css_images_custombutton_Button_Gold_tileable_bl_pressed_png_1833599894;
         this._embed_css_images_custombutton_Button_Gold_tileable_mc_idle_png_313886890 = Tibia__embed_css_images_custombutton_Button_Gold_tileable_mc_idle_png_313886890;
         this._embed_css_images_custombutton_Button_Gold_tileable_mc_over_png_662243754 = Tibia__embed_css_images_custombutton_Button_Gold_tileable_mc_over_png_662243754;
         this._embed_css_images_custombutton_Button_Gold_tileable_mc_pressed_png_1727779818 = Tibia__embed_css_images_custombutton_Button_Gold_tileable_mc_pressed_png_1727779818;
         this._embed_css_images_custombutton_Button_Gold_tileable_ml_idle_png_1852541313 = Tibia__embed_css_images_custombutton_Button_Gold_tileable_ml_idle_png_1852541313;
         this._embed_css_images_custombutton_Button_Gold_tileable_ml_over_png_1035473025 = Tibia__embed_css_images_custombutton_Button_Gold_tileable_ml_over_png_1035473025;
         this._embed_css_images_custombutton_Button_Gold_tileable_ml_pressed_png_921560467 = Tibia__embed_css_images_custombutton_Button_Gold_tileable_ml_pressed_png_921560467;
         this._embed_css_images_custombutton_Button_Gold_tileable_tc_idle_png_628673647 = Tibia__embed_css_images_custombutton_Button_Gold_tileable_tc_idle_png_628673647;
         this._embed_css_images_custombutton_Button_Gold_tileable_tc_over_png_960245103 = Tibia__embed_css_images_custombutton_Button_Gold_tileable_tc_over_png_960245103;
         this._embed_css_images_custombutton_Button_Gold_tileable_tc_pressed_png_206403197 = Tibia__embed_css_images_custombutton_Button_Gold_tileable_tc_pressed_png_206403197;
         this._embed_css_images_custombutton_Button_Gold_tileable_tl_idle_png_1873827252 = Tibia__embed_css_images_custombutton_Button_Gold_tileable_tl_idle_png_1873827252;
         this._embed_css_images_custombutton_Button_Gold_tileable_tl_over_png_1141054284 = Tibia__embed_css_images_custombutton_Button_Gold_tileable_tl_over_png_1141054284;
         this._embed_css_images_custombutton_Button_Gold_tileable_tl_pressed_png_169894520 = Tibia__embed_css_images_custombutton_Button_Gold_tileable_tl_pressed_png_169894520;
         this._embed_css_images_custombutton_Button_Highlight_tileable_bc_idle_png_1286951951 = Tibia__embed_css_images_custombutton_Button_Highlight_tileable_bc_idle_png_1286951951;
         this._embed_css_images_custombutton_Button_Highlight_tileable_bc_over_png_1207833841 = Tibia__embed_css_images_custombutton_Button_Highlight_tileable_bc_over_png_1207833841;
         this._embed_css_images_custombutton_Button_Highlight_tileable_bc_pressed_png_1234389013 = Tibia__embed_css_images_custombutton_Button_Highlight_tileable_bc_pressed_png_1234389013;
         this._embed_css_images_custombutton_Button_Highlight_tileable_bl_idle_png_308178610 = Tibia__embed_css_images_custombutton_Button_Highlight_tileable_bl_idle_png_308178610;
         this._embed_css_images_custombutton_Button_Highlight_tileable_bl_over_png_497741234 = Tibia__embed_css_images_custombutton_Button_Highlight_tileable_bl_over_png_497741234;
         this._embed_css_images_custombutton_Button_Highlight_tileable_bl_pressed_png_697106038 = Tibia__embed_css_images_custombutton_Button_Highlight_tileable_bl_pressed_png_697106038;
         this._embed_css_images_custombutton_Button_Highlight_tileable_ml_idle_png_1397612513 = Tibia__embed_css_images_custombutton_Button_Highlight_tileable_ml_idle_png_1397612513;
         this._embed_css_images_custombutton_Button_Highlight_tileable_ml_over_png_1618062623 = Tibia__embed_css_images_custombutton_Button_Highlight_tileable_ml_over_png_1618062623;
         this._embed_css_images_custombutton_Button_Highlight_tileable_ml_pressed_png_1040849779 = Tibia__embed_css_images_custombutton_Button_Highlight_tileable_ml_pressed_png_1040849779;
         this._embed_css_images_custombutton_Button_Highlight_tileable_tc_idle_png_1528191247 = Tibia__embed_css_images_custombutton_Button_Highlight_tileable_tc_idle_png_1528191247;
         this._embed_css_images_custombutton_Button_Highlight_tileable_tc_over_png_271197681 = Tibia__embed_css_images_custombutton_Button_Highlight_tileable_tc_over_png_271197681;
         this._embed_css_images_custombutton_Button_Highlight_tileable_tc_pressed_png_1467694627 = Tibia__embed_css_images_custombutton_Button_Highlight_tileable_tc_pressed_png_1467694627;
         this._embed_css_images_custombutton_Button_Highlight_tileable_tl_idle_png_908937052 = Tibia__embed_css_images_custombutton_Button_Highlight_tileable_tl_idle_png_908937052;
         this._embed_css_images_custombutton_Button_Highlight_tileable_tl_over_png_1798619228 = Tibia__embed_css_images_custombutton_Button_Highlight_tileable_tl_over_png_1798619228;
         this._embed_css_images_custombutton_Button_Highlight_tileable_tl_pressed_png_2092601240 = Tibia__embed_css_images_custombutton_Button_Highlight_tileable_tl_pressed_png_2092601240;
         this._embed_css_images_custombutton_Button_IngameShopBuy_tileable_end_idle_png_812485402 = Tibia__embed_css_images_custombutton_Button_IngameShopBuy_tileable_end_idle_png_812485402;
         this._embed_css_images_custombutton_Button_IngameShopBuy_tileable_end_over_png_2097822234 = Tibia__embed_css_images_custombutton_Button_IngameShopBuy_tileable_end_over_png_2097822234;
         this._embed_css_images_custombutton_Button_IngameShopBuy_tileable_end_pressed_png_301372130 = Tibia__embed_css_images_custombutton_Button_IngameShopBuy_tileable_end_pressed_png_301372130;
         this._embed_css_images_custombutton_Button_IngameShopBuy_tileable_idle_png_931484342 = Tibia__embed_css_images_custombutton_Button_IngameShopBuy_tileable_idle_png_931484342;
         this._embed_css_images_custombutton_Button_IngameShopBuy_tileable_over_png_2100178506 = Tibia__embed_css_images_custombutton_Button_IngameShopBuy_tileable_over_png_2100178506;
         this._embed_css_images_custombutton_Button_IngameShopBuy_tileable_pressed_png_1298820406 = Tibia__embed_css_images_custombutton_Button_IngameShopBuy_tileable_pressed_png_1298820406;
         this._embed_css_images_custombutton_Button_Standard_tileable_bc_disabled_png_1867898870 = Tibia__embed_css_images_custombutton_Button_Standard_tileable_bc_disabled_png_1867898870;
         this._embed_css_images_custombutton_Button_Standard_tileable_bc_idle_png_1982739778 = Tibia__embed_css_images_custombutton_Button_Standard_tileable_bc_idle_png_1982739778;
         this._embed_css_images_custombutton_Button_Standard_tileable_bc_over_png_185603650 = Tibia__embed_css_images_custombutton_Button_Standard_tileable_bc_over_png_185603650;
         this._embed_css_images_custombutton_Button_Standard_tileable_bc_pressed_png_572612494 = Tibia__embed_css_images_custombutton_Button_Standard_tileable_bc_pressed_png_572612494;
         this._embed_css_images_custombutton_Button_Standard_tileable_bl_disabled_png_1093953119 = Tibia__embed_css_images_custombutton_Button_Standard_tileable_bl_disabled_png_1093953119;
         this._embed_css_images_custombutton_Button_Standard_tileable_bl_idle_png_1526099209 = Tibia__embed_css_images_custombutton_Button_Standard_tileable_bl_idle_png_1526099209;
         this._embed_css_images_custombutton_Button_Standard_tileable_bl_over_png_1195435017 = Tibia__embed_css_images_custombutton_Button_Standard_tileable_bl_over_png_1195435017;
         this._embed_css_images_custombutton_Button_Standard_tileable_bl_pressed_png_1326387531 = Tibia__embed_css_images_custombutton_Button_Standard_tileable_bl_pressed_png_1326387531;
         this._embed_css_images_custombutton_Button_Standard_tileable_mc_disabled_png_983765749 = Tibia__embed_css_images_custombutton_Button_Standard_tileable_mc_disabled_png_983765749;
         this._embed_css_images_custombutton_Button_Standard_tileable_mc_idle_png_1278990365 = Tibia__embed_css_images_custombutton_Button_Standard_tileable_mc_idle_png_1278990365;
         this._embed_css_images_custombutton_Button_Standard_tileable_mc_over_png_931421981 = Tibia__embed_css_images_custombutton_Button_Standard_tileable_mc_over_png_931421981;
         this._embed_css_images_custombutton_Button_Standard_tileable_mc_pressed_png_81347079 = Tibia__embed_css_images_custombutton_Button_Standard_tileable_mc_pressed_png_81347079;
         this._embed_css_images_custombutton_Button_Standard_tileable_ml_disabled_png_1250879576 = Tibia__embed_css_images_custombutton_Button_Standard_tileable_ml_disabled_png_1250879576;
         this._embed_css_images_custombutton_Button_Standard_tileable_ml_idle_png_1785933248 = Tibia__embed_css_images_custombutton_Button_Standard_tileable_ml_idle_png_1785933248;
         this._embed_css_images_custombutton_Button_Standard_tileable_ml_over_png_517648064 = Tibia__embed_css_images_custombutton_Button_Standard_tileable_ml_over_png_517648064;
         this._embed_css_images_custombutton_Button_Standard_tileable_ml_pressed_png_165397636 = Tibia__embed_css_images_custombutton_Button_Standard_tileable_ml_pressed_png_165397636;
         this._embed_css_images_custombutton_Button_Standard_tileable_tc_disabled_png_509379672 = Tibia__embed_css_images_custombutton_Button_Standard_tileable_tc_disabled_png_509379672;
         this._embed_css_images_custombutton_Button_Standard_tileable_tc_idle_png_24708496 = Tibia__embed_css_images_custombutton_Button_Standard_tileable_tc_idle_png_24708496;
         this._embed_css_images_custombutton_Button_Standard_tileable_tc_over_png_1841477776 = Tibia__embed_css_images_custombutton_Button_Standard_tileable_tc_over_png_1841477776;
         this._embed_css_images_custombutton_Button_Standard_tileable_tc_pressed_png_1274559636 = Tibia__embed_css_images_custombutton_Button_Standard_tileable_tc_pressed_png_1274559636;
         this._embed_css_images_custombutton_Button_Standard_tileable_tl_disabled_png_1248907181 = Tibia__embed_css_images_custombutton_Button_Standard_tileable_tl_disabled_png_1248907181;
         this._embed_css_images_custombutton_Button_Standard_tileable_tl_idle_png_1925791611 = Tibia__embed_css_images_custombutton_Button_Standard_tileable_tl_idle_png_1925791611;
         this._embed_css_images_custombutton_Button_Standard_tileable_tl_over_png_546849157 = Tibia__embed_css_images_custombutton_Button_Standard_tileable_tl_over_png_546849157;
         this._embed_css_images_custombutton_Button_Standard_tileable_tl_pressed_png_1968611417 = Tibia__embed_css_images_custombutton_Button_Standard_tileable_tl_pressed_png_1968611417;
         this._embed_css_images_slot_Hotkey_disabled_png_669884428 = Tibia__embed_css_images_slot_Hotkey_disabled_png_669884428;
         this._embed_css_images_slot_Hotkey_highlighted_png_1867388771 = Tibia__embed_css_images_slot_Hotkey_highlighted_png_1867388771;
         this._embed_css_images_slot_Hotkey_png_542831063 = Tibia__embed_css_images_slot_Hotkey_png_542831063;
         this._embed_css_images_slot_Hotkey_protected_png_1201653772 = Tibia__embed_css_images_slot_Hotkey_protected_png_1201653772;
         this._embed_css_images_slot_container_disabled_png_2143438719 = Tibia__embed_css_images_slot_container_disabled_png_2143438719;
         this._embed_css_images_slot_container_highlighted_png_622440584 = Tibia__embed_css_images_slot_container_highlighted_png_622440584;
         this._embed_css_images_slot_container_png_1830671892 = Tibia__embed_css_images_slot_container_png_1830671892;
         this._bindings = [];
         this._watchers = [];
         this._bindingsByDestination = {};
         this._bindingsBeginWithWord = {};
         super();
         mx_internal::_document = this;
         mx_internal::_Tibia_StylesInit();
         this.layout = "absolute";
         this.addEventListener("activate",this.___Tibia_Application1_activate);
         this.addEventListener("applicationComplete",this.___Tibia_Application1_applicationComplete);
         this.addEventListener("deactivate",this.___Tibia_Application1_deactivate);
         this.addEventListener("preinitialize",this.___Tibia_Application1_preinitialize);
      }
      
      public static function s_GetAppearanceStorage() : AppearanceStorage
      {
         return (application as Tibia).m_AppearanceStorage;
      }
      
      public static function s_GetInstance() : Tibia
      {
         return application as Tibia;
      }
      
      public static function s_GetChatStorage() : ChatStorage
      {
         return (application as Tibia).m_ChatStorage;
      }
      
      public static function s_GetSecondaryTimer() : Timer
      {
         return (application as Tibia).m_SeconaryTimer;
      }
      
      public static function get s_GameActionFactory() : GameActionFactory
      {
         return (application as Tibia).m_GameActionFactory;
      }
      
      public static function s_GetMiniMapStorage() : MiniMapStorage
      {
         return (application as Tibia).m_MiniMapStorage;
      }
      
      public static function s_SetOptions(param1:OptionsStorage) : void
      {
         var _loc2_:Tibia = application as Tibia;
         if(_loc2_ != null)
         {
            _loc2_.options = param1;
         }
      }
      
      public static function s_GetContainerStorage() : ContainerStorage
      {
         return (application as Tibia).m_ContainerStorage;
      }
      
      public static function s_GetStatusWidget() : StatusWidget
      {
         return (application as Tibia).m_UIStatusWidget;
      }
      
      public static function s_GetPremiumManager() : PremiumManager
      {
         return (application as Tibia).m_PremiumManager;
      }
      
      public static function s_GetUIEffectsManager() : UIEffectsManager
      {
         return (application as Tibia).m_UIEffectsManager;
      }
      
      public static function s_GetCreatureStorage() : CreatureStorage
      {
         return (application as Tibia).m_CreatureStorage;
      }
      
      public static function set s_TibiaTimerFactor(param1:Number) : void
      {
         if(!isNaN(param1))
         {
            s_LastTibiaFactorChangeTibiaTimestamp = s_GetTibiaTimer();
            s_LastTibiaFactorChangeRealTimestamp = getTimer();
            s_InternalTibiaTimerFactor = param1;
         }
      }
      
      public static function set s_GameActionFactory(param1:GameActionFactory) : void
      {
         (application as Tibia).m_GameActionFactory = param1;
      }
      
      public static function s_GetFrameFlash() : Boolean
      {
         return (int(Tibia.s_FrameTibiaTimestamp / 300) & 1) != 0;
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil) : void
      {
         Tibia._watcherSetupUtil = param1;
      }
      
      public static function get s_TutorialMode() : Boolean
      {
         return (application as Tibia).m_TutorialMode;
      }
      
      public static function get s_TutorialData() : Object
      {
         return (application as Tibia).m_TutorialData;
      }
      
      public static function s_GetCommunication() : Communication
      {
         return (application as Tibia).m_Communication;
      }
      
      public static function s_GetInputHandler() : InputHandler
      {
         return (application as Tibia).m_UIInputHandler;
      }
      
      public static function s_GetAssetProvider() : IAssetProvider
      {
         return (application as Tibia).m_AssetProvider;
      }
      
      public static function get s_TibiaTimerFactor() : Number
      {
         return s_InternalTibiaTimerFactor;
      }
      
      public static function s_GetSpellStorage() : SpellStorage
      {
         return (application as Tibia).m_SpellStorage;
      }
      
      public static function s_GetOptions() : OptionsStorage
      {
         return (application as Tibia).m_Options;
      }
      
      public static function s_GetChatWidget() : ChatWidget
      {
         return (application as Tibia).m_UIChatWidget;
      }
      
      public static function s_GetWorldMapStorage() : WorldMapStorage
      {
         return (application as Tibia).m_WorldMapStorage;
      }
      
      public static function s_GetConnection() : IServerConnection
      {
         return (application as Tibia).m_Connection;
      }
      
      public static function s_GetPlayer() : Player
      {
         return (application as Tibia).m_Player;
      }
      
      public static function s_GetTibiaTimer() : int
      {
         if(s_LastTibiaFactorChangeRealTimestamp == 0)
         {
            s_LastTibiaFactorChangeRealTimestamp = getTimer();
            s_LastTibiaFactorChangeTibiaTimestamp = s_LastTibiaTimestamp;
         }
         var _loc1_:uint = getTimer() - s_LastTibiaFactorChangeRealTimestamp;
         s_LastTibiaTimestamp = s_LastTibiaFactorChangeTibiaTimestamp + _loc1_ * s_InternalTibiaTimerFactor;
         return s_LastTibiaTimestamp;
      }
      
      public static function s_GetSessionKey() : String
      {
         return (application as Tibia).m_SessionKey;
      }
      
      public function set m_UIChatWidget(param1:ChatWidget) : void
      {
         var _loc2_:Object = null;
         _loc2_ = this._883427326m_UIChatWidget;
         if(_loc2_ !== param1)
         {
            this._883427326m_UIChatWidget = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"m_UIChatWidget",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get m_UIChatWidget() : ChatWidget
      {
         return this._883427326m_UIChatWidget;
      }
      
      private function _Tibia_VActionBarWidget1_i() : VActionBarWidget
      {
         var _loc1_:VActionBarWidget = new VActionBarWidget();
         this.m_UIActionBarLeft = _loc1_;
         _loc1_.styleName = "actionBarLeft";
         _loc1_.id = "m_UIActionBarLeft";
         BindingManager.executeBindings(this,"m_UIActionBarLeft",this.m_UIActionBarLeft);
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function onCloseLogoutCharacter(param1:CloseEvent) : void
      {
         if(param1.detail == PopUpBase.BUTTON_YES)
         {
            this.m_ConnectionDataPending = -1;
            if(this.m_Communication != null)
            {
               this.m_Communication.disconnect(false);
            }
         }
      }
      
      protected function onActivation(param1:Event) : void
      {
         if(param1.type == Event.ACTIVATE)
         {
            this.isActive = true;
         }
         else
         {
            this.isActive = false;
            if(this.m_UIInputHandler != null)
            {
               this.m_UIInputHandler.clearPressedKeys();
            }
         }
      }
      
      public function setConnectionDataList(param1:Vector.<IConnectionData>, param2:uint) : void
      {
         if(param1 == null || param1.length < 1)
         {
            throw new ArgumentError("Tibia.setConnectionDataList: Invalid connection data list.");
         }
         if(param2 < 0 || param2 >= param1.length)
         {
            throw new ArgumentError("Tibia.setConnectionDataList: Invalid pending connection data.");
         }
         var _loc3_:Vector.<IConnectionData> = this.m_ConnectionDataList;
         this.m_ConnectionDataList = param1;
         this.m_ConnectionDataCurrent = -1;
         this.m_ConnectionDataPending = param2;
         var _loc4_:IServerConnection = s_GetConnection();
         if(_loc4_ != null && _loc4_.isConnected)
         {
            _loc4_.disconnect();
         }
         else if(IServerConnection is Sessiondump && this.m_GameClientReady)
         {
            this.loginCharacter();
         }
      }
      
      public function setClientSize(param1:uint, param2:uint) : void
      {
         var _loc3_:Object = Application.application.systemManager;
         if(_loc3_.hasOwnProperty("setActualSize"))
         {
            _loc3_["setActualSize"](param1,param2);
         }
      }
      
      private function isValidPreviewStateForClient(param1:uint) : Boolean
      {
         switch(param1)
         {
            case PREVIEW_STATE_REGULAR:
               return CLIENT_PREVIEW_STATE == PREVIEW_STATE_REGULAR || CLIENT_PREVIEW_STATE == PREVIEW_STATE_PREVIEW_NO_ACTIVE_CHANGE;
            case PREVIEW_STATE_PREVIEW_NO_ACTIVE_CHANGE:
               return CLIENT_PREVIEW_STATE == PREVIEW_STATE_REGULAR || CLIENT_PREVIEW_STATE == PREVIEW_STATE_PREVIEW_NO_ACTIVE_CHANGE;
            case PREVIEW_STATE_PREVIEW_WITH_ACTIVE_CHANGE:
               return CLIENT_PREVIEW_STATE == PREVIEW_STATE_PREVIEW_WITH_ACTIVE_CHANGE;
            default:
               return false;
         }
      }
      
      private function onConnectionConnecting(param1:ConnectionEvent) : void
      {
         visible = false;
         if(param1.data != null && this.m_Player.name == null)
         {
            this.m_Player.name = param1.data as String;
         }
         this.m_ChannelsPending = this.m_ChatStorage.loadChannels();
         var _loc2_:MessageWidget = new MessageWidget();
         _loc2_.buttonFlags = PopUpBase.BUTTON_CANCEL;
         _loc2_.keyboardFlags = PopUpBase.KEY_ESCAPE;
         _loc2_.message = resourceManager.getString(BUNDLE,"DLG_CONNECTING_TEXT",[param1.message]);
         _loc2_.title = resourceManager.getString(BUNDLE,"DLG_CONNECTING_TITLE");
         _loc2_.addEventListener(CloseEvent.CLOSE,this.onCloseLoginCharacter);
         _loc2_.show();
      }
      
      private function onConnectionPending(param1:ConnectionEvent) : void
      {
         var _loc2_:int = 0;
         if(this.m_ChannelsPending != null)
         {
            for each(_loc2_ in this.m_ChannelsPending)
            {
               if(_loc2_ == ChatStorage.PRIVATE_CHANNEL_ID)
               {
                  this.m_Communication.sendCOPENCHANNEL();
               }
               else
               {
                  this.m_Communication.sendCJOINCHANNEL(_loc2_);
               }
            }
            this.m_ChannelsPending = null;
         }
         if(!this.m_CharacterDeath)
         {
            if(this.m_UIWorldMapWidget != null)
            {
               this.m_UIWorldMapWidget.player = this.m_Player;
            }
            if(this.m_UIStatusWidget != null)
            {
               this.m_UIStatusWidget.player = this.m_Player;
            }
            this.m_Communication.sendCENTERWORLD();
         }
      }
      
      public function logoutCharacter() : void
      {
         if(this.m_Connection == null || !this.m_Connection.isConnected)
         {
            throw new Error("Tibia.logoutCharacter: Not connected.");
         }
         this.m_FailedConnectionRescheduler.reset();
         var _loc1_:MessageWidget = new MessageWidget();
         _loc1_.buttonFlags = PopUpBase.BUTTON_YES | PopUpBase.BUTTON_NO;
         _loc1_.message = resourceManager.getString(BUNDLE,"DLG_LOGOUT_TEXT");
         _loc1_.title = resourceManager.getString(BUNDLE,"DLG_LOGOUT_TITLE");
         _loc1_.addEventListener(CloseEvent.CLOSE,this.onCloseLogoutCharacter);
         _loc1_.show();
      }
      
      public function saveLocalData() : void
      {
         if(!(this.m_Connection is Sessiondump))
         {
            this.m_MiniMapStorage.saveSectors(true);
         }
      }
      
      public function get isActive() : Boolean
      {
         return this.m_IsActive;
      }
      
      [Bindable(event="propertyChange")]
      public function get m_UIActionBarTop() : HActionBarWidget
      {
         return this._1423351586m_UIActionBarTop;
      }
      
      protected function connect(param1:IConnectionData) : void
      {
         var _loc3_:SessiondumpControllerBase = null;
         if(param1 is AccountCharacter)
         {
            if(!(this.m_Connection is Connection))
            {
               this.reset(true);
               this.releaseConnection();
            }
            this.m_Connection = new Connection();
         }
         else if(param1 is SessiondumpConnectionData)
         {
            if(!(this.m_Connection is Sessiondump))
            {
               this.reset(true);
               this.releaseConnection();
            }
            _loc3_ = null;
            if(this.m_TutorialMode)
            {
               _loc3_ = new SessiondumpControllerHints();
            }
            else
            {
               _loc3_ = new SessiondumpControllerBase();
            }
            this.m_Connection = new Sessiondump(_loc3_);
         }
         this.m_ConnectionEstablishedAndPacketReceived = false;
         this.m_Connection.addEventListener(ConnectionEvent.PENDING,this.onConnectionPending);
         this.m_Connection.addEventListener(ConnectionEvent.GAME,this.onConnectionGame);
         this.m_Connection.addEventListener(ConnectionEvent.CONNECTING,this.onConnectionConnecting);
         this.m_Connection.addEventListener(ConnectionEvent.CONNECTION_LOST,this.onConnectionLost);
         this.m_Connection.addEventListener(ConnectionEvent.CONNECTION_RECOVERED,this.onConnectionRecovered);
         this.m_Connection.addEventListener(ConnectionEvent.DEAD,this.onConnectionDeath);
         this.m_Connection.addEventListener(ConnectionEvent.DISCONNECTED,this.onConnectionDisconnected);
         this.m_Connection.addEventListener(ConnectionEvent.ERROR,this.onConnectionError);
         this.m_Connection.addEventListener(ConnectionEvent.LOGINCHALLENGE,this.onConnectionLoginChallenge);
         this.m_Connection.addEventListener(ConnectionEvent.LOGINADVICE,this.onConnectionLoginAdvice);
         this.m_Connection.addEventListener(ConnectionEvent.LOGINERROR,this.onConnectionLoginError);
         this.m_Connection.addEventListener(ConnectionEvent.LOGINWAIT,this.onConnectionLoginWait);
         var _loc2_:ConnectionEvent = new ConnectionEvent(ConnectionEvent.CREATED);
         dispatchEvent(_loc2_);
         this.m_Connection.connect(param1);
      }
      
      private function onUploadOptionsComplete(param1:Event) : void
      {
         this.m_CurrentOptionsDirty = false;
         this.m_CurrentOptionsLastUpload = getTimer();
         this.m_CurrentOptionsUploading = false;
         this.m_CurrentOptionsUploadErrorDelay = 0;
      }
      
      public function set m_UISideBarToggleRight(param1:ToggleBar) : void
      {
         var _loc2_:Object = null;
         _loc2_ = this._665607314m_UISideBarToggleRight;
         if(_loc2_ !== param1)
         {
            this._665607314m_UISideBarToggleRight = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"m_UISideBarToggleRight",_loc2_,param1));
         }
      }
      
      private function onCloseLoginWait(param1:CloseEvent) : void
      {
         if(param1.detail == TimeoutWaitWidget.TIMOUT_EXPIRED)
         {
            this.m_ConnectionDataPending = this.m_ConnectionDataCurrent;
         }
         else
         {
            this.m_ConnectionDataPending = -1;
            this.m_FailedConnectionRescheduler.reset();
         }
         if(this.m_Communication != null)
         {
            this.m_Communication.disconnect(false);
         }
      }
      
      public function set m_UIWorldMapWidget(param1:WorldMapWidget) : void
      {
         var _loc2_:Object = null;
         _loc2_ = this._1314206572m_UIWorldMapWidget;
         if(_loc2_ !== param1)
         {
            this._1314206572m_UIWorldMapWidget = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"m_UIWorldMapWidget",_loc2_,param1));
         }
      }
      
      private function _Tibia_bindingsSetup() : Array
      {
         var binding:Binding = null;
         var result:Array = [];
         binding = new Binding(this,function():String
         {
            var _loc1_:* = BoxDirection.VERTICAL;
            var _loc2_:* = _loc1_ == undefined?null:String(_loc1_);
            return _loc2_;
         },function(param1:String):void
         {
            m_UIOuterRootContainer.direction = param1;
         },"m_UIOuterRootContainer.direction");
         result[0] = binding;
         binding = new Binding(this,function():int
         {
            return SideBarSet.LOCATION_A;
         },function(param1:int):void
         {
            m_UISideBarA.location = param1;
         },"m_UISideBarA.location");
         result[1] = binding;
         binding = new Binding(this,function():int
         {
            return SideBarSet.LOCATION_B;
         },function(param1:int):void
         {
            m_UISideBarB.location = param1;
         },"m_UISideBarB.location");
         result[2] = binding;
         binding = new Binding(this,function():*
         {
            return SideBarSet.LOCATION_B;
         },function(param1:*):void
         {
            _Tibia_Array1[0] = param1;
         },"_Tibia_Array1[0]");
         result[3] = binding;
         binding = new Binding(this,function():*
         {
            return SideBarSet.LOCATION_A;
         },function(param1:*):void
         {
            _Tibia_Array1[1] = param1;
         },"_Tibia_Array1[1]");
         result[4] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = BoxDirection.VERTICAL;
            var _loc2_:* = _loc1_ == undefined?null:String(_loc1_);
            return _loc2_;
         },function(param1:String):void
         {
            m_UICenterColumn.direction = param1;
         },"m_UICenterColumn.direction");
         result[5] = binding;
         binding = new Binding(this,function():int
         {
            return ActionBarSet.LOCATION_TOP;
         },function(param1:int):void
         {
            m_UIActionBarTop.location = param1;
         },"m_UIActionBarTop.location");
         result[6] = binding;
         binding = new Binding(this,function():int
         {
            return ActionBarSet.LOCATION_BOTTOM;
         },function(param1:int):void
         {
            m_UIActionBarBottom.location = param1;
         },"m_UIActionBarBottom.location");
         result[7] = binding;
         binding = new Binding(this,function():int
         {
            return ActionBarSet.LOCATION_LEFT;
         },function(param1:int):void
         {
            m_UIActionBarLeft.location = param1;
         },"m_UIActionBarLeft.location");
         result[8] = binding;
         binding = new Binding(this,function():int
         {
            return ActionBarSet.LOCATION_RIGHT;
         },function(param1:int):void
         {
            m_UIActionBarRight.location = param1;
         },"m_UIActionBarRight.location");
         result[9] = binding;
         binding = new Binding(this,function():*
         {
            return SideBarSet.LOCATION_C;
         },function(param1:*):void
         {
            _Tibia_Array2[0] = param1;
         },"_Tibia_Array2[0]");
         result[10] = binding;
         binding = new Binding(this,function():*
         {
            return SideBarSet.LOCATION_D;
         },function(param1:*):void
         {
            _Tibia_Array2[1] = param1;
         },"_Tibia_Array2[1]");
         result[11] = binding;
         binding = new Binding(this,function():int
         {
            return SideBarSet.LOCATION_C;
         },function(param1:int):void
         {
            m_UISideBarC.location = param1;
         },"m_UISideBarC.location");
         result[12] = binding;
         binding = new Binding(this,function():int
         {
            return SideBarSet.LOCATION_D;
         },function(param1:int):void
         {
            m_UISideBarD.location = param1;
         },"m_UISideBarD.location");
         result[13] = binding;
         return result;
      }
      
      protected function onAppearancesLoadError(param1:ErrorEvent) : void
      {
         var _loc2_:GameEvent = null;
         if(param1 != null)
         {
            if(this.m_AppearanceStorage != null)
            {
               this.m_AppearanceStorage.removeEventListener(ErrorEvent.ERROR,this.onAppearancesLoadError);
               this.m_AppearanceStorage.removeEventListener(Event.COMPLETE,this.onAppearancesLoadComplete);
            }
            _loc2_ = new GameEvent(GameEvent.ERROR,true,false);
            _loc2_.message = param1.text;
            dispatchEvent(_loc2_);
         }
      }
      
      private function onCloseLoginCharacter(param1:CloseEvent) : void
      {
         if(param1.detail == PopUpBase.BUTTON_CANCEL)
         {
            this.m_ConnectionDataPending = -1;
            if(this.m_Communication != null)
            {
               this.m_Communication.disconnect(false);
            }
         }
      }
      
      protected function onAppearancesLoadComplete(param1:Event) : void
      {
         var _loc2_:GameEvent = null;
         if(param1 != null)
         {
            if(this.m_AppearanceStorage != null)
            {
               this.m_AppearanceStorage.removeEventListener(ErrorEvent.ERROR,this.onAppearancesLoadError);
               this.m_AppearanceStorage.removeEventListener(Event.COMPLETE,this.onAppearancesLoadComplete);
            }
            this.loadOptions();
            this.loginCharacter();
            this.m_GameClientReady = true;
            _loc2_ = new GameEvent(GameEvent.READY,true,false);
            dispatchEvent(_loc2_);
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get m_UIActionBarLeft() : VActionBarWidget
      {
         return this._1174474338m_UIActionBarLeft;
      }
      
      public function set isActive(param1:Boolean) : void
      {
         if(this.m_IsActive != param1)
         {
            this.m_IsActive = param1;
            if(this.m_EnableFocusNotifier)
            {
               if(this.m_IsActive == true)
               {
                  FocusNotifier.getInstance().hide();
               }
               else
               {
                  FocusNotifier.getInstance().show();
               }
            }
         }
      }
      
      public function loginCharacter() : void
      {
         var _loc2_:AccountCharacter = null;
         var _loc3_:* = false;
         if(this.m_ConnectionDataList == null || this.m_ConnectionDataList.length < 1)
         {
            throw new ArgumentError("Tibia.loginCharacter: Invalid connection data list.");
         }
         if(this.m_ConnectionDataPending < 0 || this.m_ConnectionDataPending >= this.m_ConnectionDataList.length)
         {
            throw new ArgumentError("Tibia.loginCharacter: Invalid pending connection data.");
         }
         this.reset();
         this.m_ConnectionDataCurrent = this.m_ConnectionDataPending;
         this.m_ConnectionDataPending = -1;
         this.m_CharacterDeath = false;
         var _loc1_:IConnectionData = null;
         _loc1_ = this.m_ConnectionDataList[this.m_ConnectionDataCurrent];
         if(_loc1_ is AccountCharacter)
         {
            _loc2_ = _loc1_ as AccountCharacter;
            if(_loc2_ == null)
            {
               throw new Error("Tibia.loginCharacter: connection data must be account character.");
            }
            _loc3_ = !this.isValidPreviewStateForClient(_loc2_.worldPreviewState);
            if(_loc3_)
            {
               this.reloadClient(_loc2_);
               _loc1_ = null;
            }
            else
            {
               _loc1_ = _loc2_;
            }
         }
         if(_loc1_ != null)
         {
            this.connect(_loc1_);
         }
      }
      
      public function set m_UIActionBarTop(param1:HActionBarWidget) : void
      {
         var _loc2_:Object = null;
         _loc2_ = this._1423351586m_UIActionBarTop;
         if(_loc2_ !== param1)
         {
            this._1423351586m_UIActionBarTop = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"m_UIActionBarTop",_loc2_,param1));
         }
      }
      
      mx_internal function _Tibia_StylesInit() : void
      {
         var style:CSSStyleDeclaration = null;
         var effects:Array = null;
         if(mx_internal::_Tibia_StylesInit_done)
         {
            return;
         }
         mx_internal::_Tibia_StylesInit_done = true;
         style = StyleManager.getStyleDeclaration("OfferDisplayBlock");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration("OfferDisplayBlock",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.borderThickness = 1;
               this.borderColor = 13415802;
               this.borderAlpha = 1;
               this.borderStyle = "solid";
            };
         }
         style = StyleManager.getStyleDeclaration("TextItem");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration("TextItem",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.horizontalGap = 0;
               this.rollOverColor = 2768716;
               this.paddingBottom = 0;
               this.paddingRight = 0;
               this.rollOverAlpha = 0.5;
               this.textRollOverColor = 13221291;
               this.paddingTop = 0;
               this.textColor = 13221291;
               this.paddingLeft = 0;
            };
         }
         style = StyleManager.getStyleDeclaration(".messageOptionsMessageModeList");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".messageOptionsMessageModeList",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.horizontalGridLineColor = 8089164;
               this.backgroundColor = "";
               this.borderColor = 8089164;
               this.selectionDuration = 0;
               this.alternatingItemColors = [1977654,16711680];
               this.color = 13221291;
               this.selectionColor = 658961;
               this.backgroundAlpha = 0.8;
               this.borderAlpha = 1;
               this.selectionEasingFunction = "";
               this.headerSeparatorSkin = VectorDataGridHeaderSeparatorSkin;
               this.headerBackgroundSkin = VectorDataGridHeaderBackgroundSkin;
               this.borderThickness = 1;
               this.alternatingItemAlphas = [0.8,0];
               this.rollOverColor = 2768716;
               this.verticalGridLines = true;
               this.verticalGridLineColor = 8089164;
               this.iconColor = 13221291;
               this.textSelectedColor = 13221291;
               this.textRollOverColor = 13221291;
               this.horizontalGridLines = false;
               this.borderStyle = "solid";
               this.disabledIconColor = 13221291;
            };
         }
         style = StyleManager.getStyleDeclaration(".ingameShopOfferBox");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".ingameShopOfferBox",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.borderThickness = 1;
               this.borderColor = 13415802;
               this.backgroundColor = 1842980;
               this.paddingBottom = 0;
               this.paddingRight = 0;
               this.borderAlpha = 1;
               this.paddingTop = 0;
               this.borderStyle = "solid";
               this.paddingLeft = 0;
            };
         }
         style = StyleManager.getStyleDeclaration(".spellListWidgetTab");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".spellListWidgetTab",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.defaultUpMask = "center";
               this.selectedDownMask = "center";
               this.textAlign = "center";
               this.paddingRight = 2;
               this.skin = BitmapButtonSkin;
               this.defaultDownMask = "center";
               this.selectedUpMask = "center";
               this.defaultUpCenterImage = _embed_css_images_BuySellTab_idle_png_886708504;
               this.paddingBottom = 0;
               this.selectedTextColor = 15904590;
               this.selectedOverCenterImage = _embed_css_images_BuySellTab_active_png_1449511366;
               this.defaultOverCenterImage = _embed_css_images_BuySellTab_idle_png_886708504;
               this.selectedOverMask = "center";
               this.defaultTextColor = 15904590;
               this.defaultDownCenterImage = _embed_css_images_BuySellTab_idle_png_886708504;
               this.selectedDownCenterImage = _embed_css_images_BuySellTab_active_png_1449511366;
               this.paddingTop = 0;
               this.paddingLeft = 2;
               this.defaultOverMask = "center";
               this.selectedUpCenterImage = _embed_css_images_BuySellTab_active_png_1449511366;
            };
         }
         style = StyleManager.getStyleDeclaration(".miniMapButtonNorth");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".miniMapButtonNorth",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.defaultUpMask = "top";
               this.skin = BitmapButtonSkin;
               this.defaultOverBottomImage = "right";
               this.defaultOverLeftImage = "right";
               this.defaultDownMask = "top";
               this.defaultDownBottomImage = "right";
               this.defaultUpRightImage = _embed_css_images_Arrow_ScrollTabs_idle_png_1793155108;
               this.defaultDownTopImage = "right";
               this.defaultDownRightImage = _embed_css_images_Arrow_ScrollTabs_pressed_png_169219784;
               this.defaultUpBottomImage = "right";
               this.defaultUpTopImage = "right";
               this.defaultDownLeftImage = "right";
               this.defaultOverRightImage = _embed_css_images_Arrow_ScrollTabs_over_png_1462627108;
               this.defaultOverTopImage = "right";
               this.defaultUpLeftImage = "right";
               this.defaultOverMask = "top";
            };
         }
         style = StyleManager.getStyleDeclaration(".bodySlotFinger");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".bodySlotFinger",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.emptyBackgroundImage = _embed_css_images_Slot_InventoryRing_png_1209351389;
            };
         }
         style = StyleManager.getStyleDeclaration(".customSliderIncreaseButton");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".customSliderIncreaseButton",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.defaultDisabledRightImage = _embed_css_images_Arrow_WidgetToggle_idle_png_550075419;
               this.defaultUpMask = "right";
               this.skin = BitmapButtonSkin;
               this.defaultOverLeftImage = "right";
               this.defaultDisabledMask = "right";
               this.defaultDisabledLeftImage = "right";
               this.defaultDownMask = "right";
               this.defaultUpRightImage = _embed_css_images_Arrow_WidgetToggle_idle_png_550075419;
               this.defaultDownRightImage = _embed_css_images_Arrow_WidgetToggle_pressed_png_806241479;
               this.defaultDownLeftImage = "right";
               this.defaultOverRightImage = _embed_css_images_Arrow_WidgetToggle_over_png_334496997;
               this.defaultUpLeftImage = "right";
               this.defaultOverMask = "right";
            };
         }
         style = StyleManager.getStyleDeclaration("PreyView");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration("PreyView",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.borderThickness = 1;
               this.borderColor = 13415802;
               this.backgroundColor = 658961;
               this.borderAlpha = 1;
               this.backgroundAlpha = 0.5;
               this.borderStyle = "solid";
               this.verticalGap = 2;
            };
         }
         style = StyleManager.getStyleDeclaration("Button");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration("Button",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.defaultDisabledRightImage = "left";
               this.defaultDisabledBottomRightImage = "bottomLeft";
               this.paddingRight = 4;
               this.selectedOverTopImage = _embed_css_images_custombutton_Button_Border_tileable_tc_over_png_1913712539;
               this.selectedDisabledBottomImage = _embed_css_images_custombutton_Button_Border_tileable_bc_disabled_png_372459381;
               this.selectedDownLeftImage = _embed_css_images_custombutton_Button_Border_tileable_ml_pressed_png_1348489359;
               this.selectedOverLeftImage = _embed_css_images_custombutton_Button_Border_tileable_ml_over_png_637758037;
               this.defaultOverBottomLeftImage = _embed_css_images_custombutton_Button_Standard_tileable_bl_over_png_1195435017;
               this.defaultDisabledTopImage = _embed_css_images_custombutton_Button_Standard_tileable_tc_disabled_png_509379672;
               this.defaultDownTopImage = _embed_css_images_custombutton_Button_Standard_tileable_tc_pressed_png_1274559636;
               this.selectedOverBottomRightImage = "bottomLeft";
               this.defaultUpCenterImage = _embed_css_images_custombutton_Button_Standard_tileable_mc_idle_png_1278990365;
               this.paddingBottom = 0;
               this.selectedDownTopLeftImage = _embed_css_images_custombutton_Button_Border_tileable_tl_pressed_png_1903116940;
               this.textSelectedColor = 13221291;
               this.defaultDownCenterImage = _embed_css_images_custombutton_Button_Standard_tileable_mc_pressed_png_81347079;
               this.selectedDownCenterImage = _embed_css_images_custombutton_Button_Standard_tileable_mc_pressed_png_81347079;
               this.defaultDisabledTopLeftImage = _embed_css_images_custombutton_Button_Standard_tileable_tl_disabled_png_1248907181;
               this.selectedUpBottomRightImage = "bottomLeft";
               this.height = 22;
               this.defaultUpTopRightImage = "topLeft";
               this.selectedUpTopRightImage = "topLeft";
               this.selectedUpCenterImage = _embed_css_images_custombutton_Button_Standard_tileable_mc_idle_png_1278990365;
               this.selectedDisabledTopImage = _embed_css_images_custombutton_Button_Border_tileable_tc_disabled_png_1563054077;
               this.selectedDownMask = "topLeft top topRight left center right bottomLeft bottom bottomRight";
               this.selectedDisabledTopLeftImage = _embed_css_images_custombutton_Button_Border_tileable_tl_disabled_png_655788448;
               this.selectedOverTopRightImage = "topLeft";
               this.defaultOverLeftImage = _embed_css_images_custombutton_Button_Standard_tileable_ml_over_png_517648064;
               this.defaultDownMask = "topLeft top topRight left center right bottomLeft bottom bottomRight";
               this.selectedUpTopImage = _embed_css_images_custombutton_Button_Border_tileable_tc_idle_png_1026384539;
               this.selectedUpMask = "topLeft top topRight left center right bottomLeft bottom bottomRight";
               this.selectedDownBottomImage = _embed_css_images_custombutton_Button_Border_tileable_bc_pressed_png_1988687265;
               this.selectedDisabledBottomLeftImage = _embed_css_images_custombutton_Button_Border_tileable_bl_disabled_png_1194789362;
               this.selectedOverTopLeftImage = _embed_css_images_custombutton_Button_Border_tileable_tl_over_png_1128024712;
               this.focusThickness = 0;
               this.defaultDownBottomLeftImage = _embed_css_images_custombutton_Button_Standard_tileable_bl_pressed_png_1326387531;
               this.selectedDownBottomLeftImage = _embed_css_images_custombutton_Button_Border_tileable_bl_pressed_png_1894305430;
               this.defaultDownLeftImage = _embed_css_images_custombutton_Button_Standard_tileable_ml_pressed_png_165397636;
               this.defaultOverRightImage = "left";
               this.defaultOverCenterImage = _embed_css_images_custombutton_Button_Standard_tileable_mc_over_png_931421981;
               this.defaultDisabledTopRightImage = "topLeft";
               this.selectedDownTopRightImage = "topLeft";
               this.selectedOverRightImage = "left";
               this.selectedUpRightImage = "left";
               this.textRollOverColor = 15904590;
               this.defaultUpLeftImage = _embed_css_images_custombutton_Button_Standard_tileable_ml_idle_png_1785933248;
               this.paddingLeft = 4;
               this.selectedOverBottomLeftImage = _embed_css_images_custombutton_Button_Border_tileable_bl_over_png_344982570;
               this.color = 15904590;
               this.defaultDisabledBottomLeftImage = _embed_css_images_custombutton_Button_Standard_tileable_bl_disabled_png_1093953119;
               this.selectedUpLeftImage = _embed_css_images_custombutton_Button_Border_tileable_ml_idle_png_901180245;
               this.skin = StyleSizedBitmapButtonSkin;
               this.defaultOverBottomRightImage = "bottomLeft";
               this.defaultOverBottomImage = _embed_css_images_custombutton_Button_Standard_tileable_bc_over_png_185603650;
               this.defaultDisabledLeftImage = _embed_css_images_custombutton_Button_Standard_tileable_ml_disabled_png_1250879576;
               this.selectedUpBottomLeftImage = _embed_css_images_custombutton_Button_Border_tileable_bl_idle_png_1538038570;
               this.defaultDownBottomImage = _embed_css_images_custombutton_Button_Standard_tileable_bc_pressed_png_572612494;
               this.defaultUpRightImage = "left";
               this.defaultOverTopRightImage = "topLeft";
               this.defaultDownTopLeftImage = _embed_css_images_custombutton_Button_Standard_tileable_tl_pressed_png_1968611417;
               this.defaultDownRightImage = "left";
               this.defaultUpBottomImage = _embed_css_images_custombutton_Button_Standard_tileable_bc_idle_png_1982739778;
               this.selectedDisabledLeftImage = _embed_css_images_custombutton_Button_Border_tileable_ml_disabled_png_1474936339;
               this.defaultUpTopImage = _embed_css_images_custombutton_Button_Standard_tileable_tc_idle_png_24708496;
               this.selectedDisabledTopRightImage = "topLeft";
               this.defaultOverTopImage = _embed_css_images_custombutton_Button_Standard_tileable_tc_over_png_1841477776;
               this.selectedDownRightImage = "left";
               this.selectedOverMask = "topLeft top topRight left center right bottomLeft bottom bottomRight";
               this.paddingTop = 0;
               this.selectedUpTopLeftImage = _embed_css_images_custombutton_Button_Border_tileable_tl_idle_png_402102152;
               this.defaultDisabledBottomImage = _embed_css_images_custombutton_Button_Standard_tileable_bc_disabled_png_1867898870;
               this.defaultOverMask = "topLeft top topRight left center right bottomLeft bottom bottomRight";
               this.selectedDisabledRightImage = "left";
               this.selectedUpBottomImage = _embed_css_images_custombutton_Button_Border_tileable_bc_idle_png_721306611;
               this.selectedDownBottomRightImage = "bottomLeft";
               this.defaultUpMask = "topLeft top topRight left center right bottomLeft bottom bottomRight";
               this.selectedDisabledCenterImage = _embed_css_images_custombutton_Button_Standard_tileable_mc_disabled_png_983765749;
               this.defaultUpBottomLeftImage = _embed_css_images_custombutton_Button_Standard_tileable_bl_idle_png_1526099209;
               this.defaultDisabledCenterImage = _embed_css_images_custombutton_Button_Standard_tileable_mc_disabled_png_983765749;
               this.defaultDisabledMask = "topLeft top topRight left center right bottomLeft bottom bottomRight";
               this.selectedOverBottomImage = _embed_css_images_custombutton_Button_Border_tileable_bc_over_png_373998323;
               this.disabledColor = 15904590;
               this.defaultDownTopRightImage = "topLeft";
               this.defaultUpTopLeftImage = _embed_css_images_custombutton_Button_Standard_tileable_tl_idle_png_1925791611;
               this.defaultUpBottomRightImage = "bottomLeft";
               this.selectedDownTopImage = _embed_css_images_custombutton_Button_Border_tileable_tc_pressed_png_502332351;
               this.selectedOverCenterImage = _embed_css_images_custombutton_Button_Standard_tileable_mc_over_png_931421981;
               this.width = 1;
               this.defaultDownBottomRightImage = "bottomLeft";
               this.selectedDisabledBottomRightImage = "bottomLeft";
               this.defaultOverTopLeftImage = _embed_css_images_custombutton_Button_Standard_tileable_tl_over_png_546849157;
               this.selectedDisabledMask = "topLeft top topRight left center right bottomLeft bottom bottomRight";
            };
         }
         style = StyleManager.getStyleDeclaration(".optionsConfigurationWidgetRootContainer");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".optionsConfigurationWidgetRootContainer",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.borderThickness = 1;
               this.borderColor = 8089164;
               this.backgroundColor = 2240055;
               this.paddingBottom = 2;
               this.paddingRight = 2;
               this.borderAlpha = 1;
               this.backgroundAlpha = 0.5;
               this.paddingTop = 2;
               this.borderStyle = "solid";
               this.paddingLeft = 2;
            };
         }
         style = StyleManager.getStyleDeclaration(".statusWidgetFatMana");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".statusWidgetFatMana",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.barImages = "barDefault";
               this.backgroundRightImage = _embed_css_images_BG_Bars_fat_enpiece_png_254994756;
               this.paddingRight = 1;
               this.backgroundMask = "center";
               this.leftOrnamentMask = "left";
               this.rightOrnamentMask = "none";
               this.backgroundCenterImage = _embed_css_images_BG_Bars_fat_tileable_png_1851975525;
               this.rightOrnamentRightImage = _embed_css_images_BG_Bars_fat_enpieceOrnamented_png_805098349;
               this.backgroundLeftImage = "right";
               this.leftOrnamentLeftImage = "right";
               this.paddingBottom = 3;
               this.barDefault = _embed_css_images_BarsHealth_fat_Mana_png_1856202898;
               this.leftOrnamentOffset = -6;
               this.rightOrnamentOffset = 6;
               this.paddingTop = 1;
               this.leftOrnamentRightImage = _embed_css_images_BG_Bars_fat_enpieceOrnamented_png_805098349;
               this.paddingLeft = 3;
               this.barLimits = 0;
            };
         }
         style = StyleManager.getStyleDeclaration(".validationFeedbackValid");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".validationFeedbackValid",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 13221291;
            };
         }
         style = StyleManager.getStyleDeclaration(".statusWidgetCompactMana");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".statusWidgetCompactMana",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.barImages = "barDefault";
               this.backgroundRightImage = _embed_css_images_BG_Bars_compact_enpiece_png_1122989386;
               this.paddingRight = 1;
               this.backgroundMask = "center";
               this.leftOrnamentMask = "left";
               this.rightOrnamentMask = "none";
               this.backgroundCenterImage = _embed_css_images_BG_Bars_compact_tileable_png_1378708577;
               this.rightOrnamentRightImage = _embed_css_images_BG_Bars_compact_enpieceOrnamented_png_918003981;
               this.backgroundLeftImage = "right";
               this.leftOrnamentLeftImage = "right";
               this.paddingBottom = 3;
               this.barDefault = _embed_css_images_BarsHealth_compact_Mana_png_1712179560;
               this.leftOrnamentOffset = -6;
               this.rightOrnamentOffset = 6;
               this.paddingTop = 1;
               this.leftOrnamentRightImage = _embed_css_images_BG_Bars_compact_enpieceOrnamented_png_918003981;
               this.paddingLeft = 3;
               this.barLimits = 0;
            };
         }
         style = StyleManager.getStyleDeclaration(".statusWidgetFatZeroSkillProgress");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".statusWidgetFatZeroSkillProgress",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.tickCenterImage = _embed_css_images_Bars_ProgressMarker_png_1761755336;
               this.backgroundRightImage = "left";
               this.barImages = "barDefault";
               this.tickMask = "center";
               this.paddingRight = -5;
               this.backgroundMask = "left center right";
               this.backgroundCenterImage = _embed_css_images_BG_BarsXP_default_tileable_png_1408337339;
               this.backgroundLeftImage = _embed_css_images_BG_BarsXP_default_endpiece_png_1394078162;
               this.barDefault = _embed_css_images_BarsXP_default_zero_png_841389645;
               this.paddingBottom = 4;
               this.tickOffset = 3;
               this.paddingTop = 3;
               this.paddingLeft = -5;
               this.barLimits = 0;
            };
         }
         style = StyleManager.getStyleDeclaration(".popUpFooterStyle");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".popUpFooterStyle",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.borderThickness = 1;
               this.borderColor = 8089164;
               this.backgroundColor = 658961;
               this.horizontalGap = 32;
               this.paddingBottom = 2;
               this.horizontalAlign = "center";
               this.paddingRight = 1;
               this.borderAlpha = 1;
               this.backgroundAlpha = 0.5;
               this.paddingTop = 1;
               this.borderStyle = "solid";
               this.paddingLeft = 1;
            };
         }
         style = StyleManager.getStyleDeclaration("TextInput");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration("TextInput",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.borderThickness = 1;
               this.borderColor = 0;
               this.backgroundColor = 2240055;
               this.focusThickness = 0;
               this.borderAlpha = 1;
               this.backgroundAlpha = 0.5;
               this.borderStyle = "solid";
            };
         }
         style = StyleManager.getStyleDeclaration(".statusWidgetCompactSkill");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".statusWidgetCompactSkill",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.progressBarMalusStyleName = "statusWidgetCompactMalusSkillProgress";
               this.verticalAlign = "middle";
               this.iconStyleName = "";
               this.progressBarBonusStyleName = "statusWidgetCompactBonusSkillProgress";
               this.progressBarZeroStyleName = "statusWidgetCompactZeroSkillProgress";
               this.horizontalGap = 0;
               this.progressBarStyleName = "statusWidgetCompactSkillProgress";
               this.labelStyleName = ".statusWidgetSkillProgress";
            };
         }
         style = StyleManager.getStyleDeclaration(".slotsBox");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".slotsBox",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.verticalAlign = "middle";
            };
         }
         style = StyleManager.getStyleDeclaration("GameWindowContainer");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration("GameWindowContainer",style,false);
         }
         style = StyleManager.getStyleDeclaration(".chatWidgetSingleView");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".chatWidgetSingleView",style,false);
         }
         style = StyleManager.getStyleDeclaration(".gameWindowLockButton");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".gameWindowLockButton",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.iconDefaultUpMask = "center";
               this.iconSelectedUpCenterImage = _embed_css_images_Button_LockHotkeys_Locked_idle_png_885060219;
               this.iconSelectedUpMask = "center";
               this.icon = BitmapButtonIcon;
               this.skin = _embed_css_images_Slot_Statusicon_png_1608787474;
               this.iconDefaultUpCenterImage = _embed_css_images_Button_LockHotkeys_UnLocked_idle_png_587263282;
               this.iconSelectedOverCenterImage = _embed_css_images_Button_LockHotkeys_Locked_over_png_554269051;
               this.iconDefaultDownMask = "center";
               this.iconDefaultDownCenterImage = _embed_css_images_Button_LockHotkeys_UnLocked_over_png_935749170;
               this.iconSelectedDownMask = "center";
               this.iconDefaultOverCenterImage = _embed_css_images_Button_LockHotkeys_UnLocked_over_png_935749170;
               this.iconSelectedDownCenterImage = _embed_css_images_Button_LockHotkeys_Locked_over_png_554269051;
               this.iconDefaultOverMask = "center";
               this.iconSelectedOverMask = "center";
            };
         }
         style = StyleManager.getStyleDeclaration(".basePrice");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".basePrice",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 7829367;
            };
         }
         style = StyleManager.getStyleDeclaration(".chatWidgetTitle");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".chatWidgetTitle",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.verticalAlign = "middle";
               this.horizontalGap = 0;
               this.paddingBottom = 0;
               this.horizontalAlign = "left";
               this.paddingRight = 0;
               this.borderTopImage = _embed_css_images_BG_ChatTab_tileable_png_2031873750;
               this.borderMask = "top";
               this.borderBottomImage = "top";
               this.paddingTop = 0;
               this.borderSkin = BitmapBorderSkin;
               this.verticalGap = 0;
               this.paddingLeft = 0;
            };
         }
         style = StyleManager.getStyleDeclaration(".withBorder");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".withBorder",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.borderThickness = 1;
               this.borderColor = 13415802;
               this.borderAlpha = 1;
               this.borderStyle = "solid";
            };
         }
         style = StyleManager.getStyleDeclaration("StatusWidget");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration("StatusWidget",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.verticalBigGap = 10;
               this.paddingRight = 1;
               this.borderSkin = BitmapBorderSkin;
               this.borderTopRightImage = _embed_css_images_Border02_corners_png_1465567525;
               this.verticalGap = 1;
               this.horizontalBigGap = 10;
               this.horizontalGap = 1;
               this.paddingBottom = 1;
               this.borderRightImage = _embed_css_images_Border02_png_856171138;
               this.borderMask = "all";
               this.paddingTop = 0;
               this.paddingLeft = 1;
               this.borderCenterImage = _embed_css_images_BG_Stone2_Tileable_png_1536416308;
            };
         }
         style = StyleManager.getStyleDeclaration("ComboBox");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration("ComboBox",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.borderThickness = 1;
               this.borderColor = 13221291;
               this.focusThickness = 0;
               this.highlightAlphas = [0,0];
               this.iconColor = 13221291;
               this.borderAlpha = 1;
               this.fillColors = [4937051,2501679];
               this.borderStyle = "solid";
               this.fillAlphas = [1,1];
            };
         }
         style = StyleManager.getStyleDeclaration(".editMarkSelector");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".editMarkSelector",style,false);
         }
         style = StyleManager.getStyleDeclaration(".combatButtonChase");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".combatButtonChase",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.defaultUpMask = "center";
               this.selectedDownMask = "center";
               this.skin = BitmapButtonSkin;
               this.defaultDisabledMask = "center";
               this.defaultDownMask = "center";
               this.selectedUpMask = "center";
               this.defaultUpCenterImage = _embed_css_images_Icons_CombatControls_StandOff_idle_png_1491392258;
               this.selectedOverCenterImage = _embed_css_images_Icons_CombatControls_AutochaseOn_over_png_554521467;
               this.defaultOverCenterImage = _embed_css_images_Icons_CombatControls_StandOff_over_png_325171198;
               this.selectedOverMask = "center";
               this.defaultDownCenterImage = _embed_css_images_Icons_CombatControls_StandOff_over_png_325171198;
               this.selectedDownCenterImage = _embed_css_images_Icons_CombatControls_AutochaseOn_over_png_554521467;
               this.defaultOverMask = "center";
               this.selectedDisabledMask = "center";
               this.selectedUpCenterImage = _embed_css_images_Icons_CombatControls_AutochaseOn_idle_png_1441980539;
            };
         }
         style = StyleManager.getStyleDeclaration(".chatWidgetInput");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".chatWidgetInput",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.verticalAlign = "middle";
               this.horizontalGap = 2;
               this.horizontalAlign = "left";
               this.borderTopImage = _embed_css_images_BG_ChatTab_tileable_png_2031873750;
               this.borderMask = "bottom";
               this.borderBottomImage = "top";
               this.paddingTop = 2;
               this.borderSkin = BitmapBorderSkin;
               this.verticalGap = 0;
            };
         }
         style = StyleManager.getStyleDeclaration(".actionBarWidgetToggleRight");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".actionBarWidgetToggleRight",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.iconDefaultOverTopImage = "right";
               this.iconDefaultUpMask = "left";
               this.paddingRight = 0;
               this.selectedOverTopImage = "right";
               this.selectedDownLeftImage = "right";
               this.selectedOverLeftImage = "right";
               this.iconDefaultDownMask = "left";
               this.defaultDownTopImage = "right";
               this.borderLeft = 0;
               this.iconDefaultUpRightImage = _embed_css_images_Arrow_ScrollTabs_idle_png_1793155108;
               this.paddingBottom = 0;
               this.iconDefaultOverBottomImage = "right";
               this.iconSelectedDownMask = "right";
               this.iconDefaultDownRightImage = _embed_css_images_Arrow_ScrollTabs_pressed_png_169219784;
               this.borderBottom = 0;
               this.iconSelectedUpLeftImage = "right";
               this.iconSelectedDownTopImage = "right";
               this.selectedDownMask = "right";
               this.iconSelectedUpMask = "right";
               this.iconDefaultDownTopImage = "right";
               this.iconSelectedUpTopImage = "right";
               this.defaultOverLeftImage = "right";
               this.selectedUpTopImage = "right";
               this.iconSelectedDownBottomImage = "right";
               this.iconSelectedOverRightImage = _embed_css_images_Arrow_ScrollTabs_over_png_1462627108;
               this.defaultDownMask = "left";
               this.selectedUpMask = "right";
               this.selectedDownBottomImage = "right";
               this.iconSelectedDownRightImage = _embed_css_images_Arrow_ScrollTabs_pressed_png_169219784;
               this.iconDefaultUpTopImage = "right";
               this.defaultDownLeftImage = "right";
               this.defaultOverRightImage = _embed_css_images_Arrow_HotkeyToggle_BG_png_368269210;
               this.borderRight = 0;
               this.selectedOverRightImage = _embed_css_images_Arrow_HotkeyToggle_BG_png_368269210;
               this.iconDefaultUpLeftImage = "right";
               this.selectedUpRightImage = _embed_css_images_Arrow_HotkeyToggle_BG_png_368269210;
               this.iconDefaultOverLeftImage = "right";
               this.defaultUpLeftImage = "right";
               this.paddingLeft = 0;
               this.iconDefaultUpBottomImage = "right";
               this.iconSelectedOverMask = "right";
               this.iconSelectedDownLeftImage = "right";
               this.iconSelectedOverLeftImage = "right";
               this.selectedUpLeftImage = "right";
               this.iconSelectedOverTopImage = "right";
               this.skin = BitmapButtonSkin;
               this.icon = BitmapButtonIcon;
               this.defaultOverBottomImage = "right";
               this.borderTop = 0;
               this.defaultDownBottomImage = "right";
               this.defaultUpRightImage = _embed_css_images_Arrow_HotkeyToggle_BG_png_368269210;
               this.defaultDownRightImage = _embed_css_images_Arrow_HotkeyToggle_BG_png_368269210;
               this.defaultUpBottomImage = "right";
               this.defaultUpTopImage = "right";
               this.iconSelectedUpRightImage = _embed_css_images_Arrow_ScrollTabs_idle_png_1793155108;
               this.defaultOverTopImage = "right";
               this.selectedDownRightImage = _embed_css_images_Arrow_HotkeyToggle_BG_png_368269210;
               this.selectedOverMask = "right";
               this.iconDefaultDownLeftImage = "right";
               this.iconDefaultOverMask = "left";
               this.paddingTop = 0;
               this.iconSelectedUpBottomImage = "right";
               this.defaultOverMask = "left";
               this.selectedUpBottomImage = "right";
               this.defaultUpMask = "left";
               this.iconSelectedOverBottomImage = "right";
               this.selectedOverBottomImage = "right";
               this.selectedDownTopImage = "right";
               this.iconDefaultDownBottomImage = "right";
               this.iconDefaultOverRightImage = _embed_css_images_Arrow_ScrollTabs_over_png_1462627108;
            };
         }
         style = StyleManager.getStyleDeclaration(".ingameShopYesButton");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".ingameShopYesButton",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.paddingBottom = 2;
               this.paddingRight = 8;
               this.icon = _embed_css_images_Icons_IngameShop_12x12_Yes_png_1011478395;
               this.paddingTop = 2;
               this.paddingLeft = 8;
            };
         }
         style = StyleManager.getStyleDeclaration(".sideBarHeaderMinimap");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".sideBarHeaderMinimap",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.defaultUpMask = "center";
               this.selectedDownMask = "center";
               this.skin = BitmapButtonSkin;
               this.defaultDownMask = "center";
               this.selectedUpMask = "center";
               this.defaultUpCenterImage = _embed_css_images_Icons_WidgetMenu_Minimap_idle_png_483881531;
               this.selectedOverCenterImage = _embed_css_images_Icons_WidgetMenu_Minimap_active_over_png_376047536;
               this.defaultOverCenterImage = _embed_css_images_Icons_WidgetMenu_Minimap_idle_over_png_1778448670;
               this.selectedOverMask = "center";
               this.defaultDownCenterImage = _embed_css_images_Icons_WidgetMenu_Minimap_idle_over_png_1778448670;
               this.selectedDownCenterImage = _embed_css_images_Icons_WidgetMenu_Minimap_active_over_png_376047536;
               this.defaultOverMask = "center";
               this.selectedUpCenterImage = _embed_css_images_Icons_WidgetMenu_Minimap_active_png_1080311283;
            };
         }
         style = StyleManager.getStyleDeclaration(".widgetViewClose");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".widgetViewClose",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.defaultUpCenterImage = _embed_css_images_Button_Close_idle_png_1218950854;
               this.defaultUpMask = "center";
               this.defaultOverCenterImage = _embed_css_images_Button_Close_over_png_1551448006;
               this.skin = BitmapButtonSkin;
               this.defaultDisabledCenterImage = _embed_css_images_Button_Close_disabled_png_447174510;
               this.defaultDisabledMask = "center";
               this.defaultDownCenterImage = _embed_css_images_Button_Close_pressed_png_1627770558;
               this.defaultDownMask = "center";
               this.defaultOverMask = "center";
            };
         }
         style = StyleManager.getStyleDeclaration(".mouseControlOptionsList");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".mouseControlOptionsList",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.horizontalGridLineColor = 8089164;
               this.backgroundColor = "";
               this.borderColor = 8089164;
               this.selectionDuration = 0;
               this.alternatingItemColors = [1977654,16711680];
               this.color = 13221291;
               this.selectionColor = 658961;
               this.backgroundAlpha = 0.8;
               this.borderAlpha = 1;
               this.selectionEasingFunction = "";
               this.headerSeparatorSkin = VectorDataGridHeaderSeparatorSkin;
               this.headerBackgroundSkin = VectorDataGridHeaderBackgroundSkin;
               this.borderThickness = 1;
               this.alternatingItemAlphas = [0.8,0];
               this.rollOverColor = 2768716;
               this.verticalGridLines = true;
               this.verticalGridLineColor = 8089164;
               this.iconColor = 13221291;
               this.textSelectedColor = 13221291;
               this.textRollOverColor = 13221291;
               this.horizontalGridLines = false;
               this.borderStyle = "solid";
               this.disabledIconColor = 13221291;
            };
         }
         style = StyleManager.getStyleDeclaration(".bodySlotTorsoBlessed");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".bodySlotTorsoBlessed",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.emptyBackgroundImage = _embed_css_images_Slot_InventoryArmor_protected_png_1192226633;
               this.backgroundImage = _embed_css_images_slot_Hotkey_protected_png_1201653772;
            };
         }
         style = StyleManager.getStyleDeclaration("Header");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration("Header",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.borderThickness = 1;
               this.borderColor = 13415802;
               this.backgroundColor = 658961;
               this.horizontalGap = 4;
               this.paddingBottom = 0;
               this.paddingRight = 2;
               this.borderAlpha = 1;
               this.backgroundAlpha = 0.5;
               this.paddingTop = 2;
               this.borderStyle = "solid";
               this.paddingLeft = 2;
            };
         }
         style = StyleManager.getStyleDeclaration(".marketWidgetFilter");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".marketWidgetFilter",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.verticalAlign = "middle";
               this.backgroundColor = "";
               this.borderColor = "";
               this.paddingRight = 2;
               this.backgroundAlpha = 0;
               this.borderAlpha = 0;
               this.verticalGap = 2;
               this.borderThickness = 0;
               this.horizontalGap = 2;
               this.paddingBottom = 2;
               this.horizontalAlign = "center";
               this.paddingTop = 2;
               this.borderStyle = "none";
               this.paddingLeft = 2;
            };
         }
         style = StyleManager.getStyleDeclaration(".offerDarkBorder");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".offerDarkBorder",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.verticalAlign = "middle";
               this.borderColor = 7630671;
               this.backgroundColor = 658961;
               this.paddingRight = 2;
               this.borderAlpha = 1;
               this.backgroundAlpha = 0.5;
               this.verticalGap = 2;
               this.borderThickness = 1;
               this.horizontalGap = 2;
               this.paddingBottom = 2;
               this.horizontalAlign = "center";
               this.paddingTop = 2;
               this.borderStyle = "solid";
               this.paddingLeft = 2;
            };
         }
         style = StyleManager.getStyleDeclaration(".miniMapButtonWest");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".miniMapButtonWest",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.defaultUpMask = "left";
               this.skin = BitmapButtonSkin;
               this.defaultOverBottomImage = "right";
               this.defaultOverLeftImage = "right";
               this.defaultDownMask = "left";
               this.defaultDownBottomImage = "right";
               this.defaultUpRightImage = _embed_css_images_Arrow_ScrollTabs_idle_png_1793155108;
               this.defaultDownTopImage = "right";
               this.defaultDownRightImage = _embed_css_images_Arrow_ScrollTabs_pressed_png_169219784;
               this.defaultUpBottomImage = "right";
               this.defaultUpTopImage = "right";
               this.defaultDownLeftImage = "right";
               this.defaultOverRightImage = _embed_css_images_Arrow_ScrollTabs_over_png_1462627108;
               this.defaultOverTopImage = "right";
               this.defaultUpLeftImage = "right";
               this.defaultOverMask = "left";
            };
         }
         style = StyleManager.getStyleDeclaration(".embeddedDialogTitleBox");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".embeddedDialogTitleBox",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.backgroundColor = 658961;
               this.paddingBottom = 2;
               this.horizontalAlign = "center";
               this.paddingRight = 2;
               this.backgroundAlpha = 0.8;
               this.paddingTop = 2;
               this.paddingLeft = 2;
            };
         }
         style = StyleManager.getStyleDeclaration(".premiumOnlyNoPremium");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".premiumOnlyNoPremium",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.icon = _embed_css_images_Icon_NoPremium_png_1355667196;
            };
         }
         style = StyleManager.getStyleDeclaration("MiniMapWidgetView");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration("MiniMapWidgetView",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.buttonWestStyle = "miniMapButtonWest";
               this.buttonUpStyle = "miniMapButtonUp";
               this.iconImage = _embed_css_images_Icons_WidgetHeaders_Minimap_png_1626881241;
               this.borderCenterMask = "all";
               this.buttonCenterStyle = "miniMapButtonCenter";
               this.borderFooterMask = "none";
               this.paddingRight = 0;
               this.buttonZoomOutStyle = "miniMapButtonZoomOut";
               this.borderCenterCenterImage = _embed_css_images_Minimap_png_803584357;
               this.paddingBottom = 0;
               this.buttonNorthStyle = "miniMapButtonNorth";
               this.buttonSouthStyle = "miniMapButtonSouth";
               this.buttonZoomInStyle = "miniMapButtonZoomIn";
               this.buttonDownStyle = "miniMapButtonDown";
               this.paddingTop = 0;
               this.paddingLeft = 0;
               this.buttonEastStyle = "miniMapButtonEast";
            };
         }
         style = StyleManager.getStyleDeclaration(".withBackground");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".withBackground",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.backgroundSkin = _embed_css_images_Slot_Statusicon_png_1608787474;
               this.highlightSkin = _embed_css_images_Slot_Statusicon_highlighted_png_1468805634;
            };
         }
         style = StyleManager.getStyleDeclaration(".preyRerollBonusButton");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".preyRerollBonusButton",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.icon = _embed_css____images_prey_prey_bonus_reroll_png_1664079721;
               this.disabledIcon = _embed_css____images_prey_prey_bonus_reroll_disabled_png_218744390;
            };
         }
         style = StyleManager.getStyleDeclaration(".buddylistContent");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".buddylistContent",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.paddingBottom = 2;
               this.paddingRight = 2;
               this.paddingTop = 2;
               this.paddingLeft = 2;
            };
         }
         style = StyleManager.getStyleDeclaration(".bodySlotLegs");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".bodySlotLegs",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.emptyBackgroundImage = _embed_css_images_Slot_InventoryLegs_png_1244810316;
            };
         }
         style = StyleManager.getStyleDeclaration(".chatWidgetTabBarScrollRightHighlight");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".chatWidgetTabBarScrollRightHighlight",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.defaultDisabledRightImage = _embed_css_images_Arrow_ScrollTabsHighlighted_idle_png_802144823;
               this.defaultUpMask = "right";
               this.skin = BitmapButtonSkin;
               this.defaultOverLeftImage = "right";
               this.defaultDisabledMask = "right";
               this.defaultDisabledLeftImage = "right";
               this.defaultDownMask = "right";
               this.defaultUpRightImage = _embed_css_images_Arrow_ScrollTabsHighlighted_idle_png_802144823;
               this.defaultDownRightImage = _embed_css_images_Arrow_ScrollTabsHighlighted_pressed_png_1019332597;
               this.defaultDownLeftImage = "right";
               this.defaultOverRightImage = _embed_css_images_Arrow_ScrollTabsHighlighted_over_png_475447497;
               this.defaultUpLeftImage = "right";
               this.defaultOverMask = "right";
            };
         }
         style = StyleManager.getStyleDeclaration(".chatWidgetTabBar");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".chatWidgetTabBar",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.scrollRightButtonStyle = "chatWidgetTabBarScrollRight";
               this.dropDownButtonStyle = "chatWidgetTabBarDropDown";
               this.scrollLeftButtonStyle = "chatWidgetTabBarScrollLeft";
               this.scrollRightButtonHighlightStyle = "chatWidgetTabBarScrollRightHighlight";
               this.navItemStyle = "chatWidgetDefaultTab";
               this.scrollLeftButtonHighlightStyle = "chatWidgetTabBarScrollLeftHighlight";
            };
         }
         style = StyleManager.getStyleDeclaration("DragManager");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration("DragManager",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.linkCursor = DragLinkCursor;
               this.rejectCursor = DragNoneCursor;
               this.copyCursor = DragCopyCursor;
               this.moveCursor = DragMoveCursor;
            };
         }
         style = StyleManager.getStyleDeclaration(".nameFilterOptionsWhiteListEditor");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".nameFilterOptionsWhiteListEditor",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.nameFilterListStyle = "nameFilterEditorList";
            };
         }
         style = StyleManager.getStyleDeclaration("DataGrid");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration("DataGrid",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.focusThickness = 0;
            };
         }
         style = StyleManager.getStyleDeclaration(".chatWidgetDefaultTabCloseButton");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".chatWidgetDefaultTabCloseButton",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.defaultUpCenterImage = _embed_css_images_Button_ChatTab_Close_idle_png_1545025108;
               this.defaultUpMask = "center";
               this.defaultOverCenterImage = _embed_css_images_Button_ChatTab_Close_over_png_1679055020;
               this.skin = BitmapButtonSkin;
               this.defaultDownCenterImage = _embed_css_images_Button_ChatTab_Close_pressed_png_1974009856;
               this.defaultDownMask = "center";
               this.defaultOverMask = "center";
            };
         }
         style = StyleManager.getStyleDeclaration(".miniMapButtonZoomOut");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".miniMapButtonZoomOut",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.defaultUpCenterImage = _embed_css_images_Minimap_ZoomOut_idle_png_1218964010;
               this.defaultUpMask = "center";
               this.defaultOverCenterImage = _embed_css_images_Minimap_ZoomOut_over_png_49587414;
               this.skin = BitmapButtonSkin;
               this.defaultDownCenterImage = _embed_css_images_Minimap_ZoomOut_pressed_png_630904298;
               this.defaultDownMask = "center";
               this.defaultOverMask = "center";
            };
         }
         style = StyleManager.getStyleDeclaration(".ingameShopOfferLastChance");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".ingameShopOfferLastChance",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 38143;
            };
         }
         style = StyleManager.getStyleDeclaration(".getCoinConfirmation");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".getCoinConfirmation",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.buttonYesStyle = "ingameShopYesButton";
               this.buttonCancelStyle = "ingameShopNoButton";
               this.errorColor = 16711680;
               this.informationColor = 4286945;
               this.successColor = 65280;
               this.buttonOkayStyle = "ingameShopYesButton";
               this.buttonNoStyle = "ingameShopNoButton";
               this.minimumButtonWidth = 60;
               this.titleBoxStyle = "popupDialogHeaderFooter";
               this.buttonBoxStyle = "popupDialogHeaderFooter";
            };
         }
         style = StyleManager.getStyleDeclaration(".marketWidgetTabContainer");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".marketWidgetTabContainer",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.verticalAlign = "middle";
               this.horizontalGap = 2;
               this.paddingBottom = 2;
               this.horizontalAlign = "center";
               this.paddingRight = 2;
               this.paddingTop = 2;
               this.verticalGap = 2;
               this.paddingLeft = 2;
            };
         }
         style = StyleManager.getStyleDeclaration(".applyImbuementButton");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".applyImbuementButton",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.icon = _embed_css_____assets_images_imbuing_imbuing_icon_imbue_active_png_2017811027;
               this.disabledIcon = _embed_css_____assets_images_imbuing_imbuing_icon_imbue_disabled_png_1836447193;
            };
         }
         style = StyleManager.getStyleDeclaration(".ingameShopCategoryBox");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".ingameShopCategoryBox",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.borderThickness = 1;
               this.borderColor = 13415802;
               this.borderAlpha = 1;
               this.borderStyle = "solid";
            };
         }
         style = StyleManager.getStyleDeclaration("MessageOptions");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration("MessageOptions",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.messageModeListStyle = "messageOptionsMessageModeList";
            };
         }
         style = StyleManager.getStyleDeclaration(".npcAmountSelector");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".npcAmountSelector",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.borderThickness = 1;
               this.borderColor = 8089164;
               this.backgroundColor = 1977654;
               this.horizontalGap = 4;
               this.paddingBottom = 2;
               this.paddingRight = 2;
               this.borderAlpha = 1;
               this.backgroundAlpha = 0.5;
               this.paddingTop = 2;
               this.borderStyle = "solid";
               this.verticalGap = 1;
               this.paddingLeft = 2;
            };
         }
         style = StyleManager.getStyleDeclaration(".bodySlotRightHandBlessed");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".bodySlotRightHandBlessed",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.emptyBackgroundImage = _embed_css_images_Slot_InventoryShield_protected_png_1678489541;
               this.backgroundImage = _embed_css_images_slot_Hotkey_protected_png_1201653772;
            };
         }
         style = StyleManager.getStyleDeclaration(".optionsConfigurationWidgetTabContainer");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".optionsConfigurationWidgetTabContainer",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.verticalAlign = "middle";
               this.horizontalGap = 2;
               this.paddingBottom = 2;
               this.horizontalAlign = "center";
               this.paddingRight = 2;
               this.paddingTop = 2;
               this.verticalGap = 2;
               this.paddingLeft = 2;
            };
         }
         style = StyleManager.getStyleDeclaration(".storeConfirmation");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".storeConfirmation",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.fontFamily = "Verdana";
               this.color = 13684944;
               this.textAlign = "center";
               this.fontSize = 9;
               this.paddingTop = 2;
               this.fontStyle = "normal";
               this.fontWeight = "bold";
            };
         }
         style = StyleManager.getStyleDeclaration(".battlelistWidgetViewHideNPC");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".battlelistWidgetViewHideNPC",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.defaultUpMask = "center";
               this.selectedDownMask = "center";
               this.skin = BitmapButtonSkin;
               this.defaultDownMask = "center";
               this.selectedUpMask = "center";
               this.defaultUpCenterImage = _embed_css_images_Icons_BattleList_HideNPCs_idle_png_1862110099;
               this.selectedOverCenterImage = _embed_css_images_Icons_BattleList_HideNPCs_active_over_png_551096440;
               this.defaultOverCenterImage = _embed_css_images_Icons_BattleList_HideNPCs_over_png_977927827;
               this.selectedOverMask = "center";
               this.defaultDownCenterImage = _embed_css_images_Icons_BattleList_HideNPCs_over_png_977927827;
               this.selectedDownCenterImage = _embed_css_images_Icons_BattleList_HideNPCs_active_over_png_551096440;
               this.defaultOverMask = "center";
               this.selectedUpCenterImage = _embed_css_images_Icons_BattleList_HideNPCs_active_png_1949955707;
            };
         }
         style = StyleManager.getStyleDeclaration("ToggleBar");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration("ToggleBar",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.borderRightImage = _embed_css_images_Border02_WidgetSidebar_png_43620945;
               this.verticalGap = 1;
               this.borderSkin = BitmapBorderSkin;
            };
         }
         style = StyleManager.getStyleDeclaration(".marketWidgetView");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".marketWidgetView",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.verticalAlign = "middle";
               this.backgroundColor = "";
               this.borderColor = "";
               this.paddingRight = 2;
               this.backgroundAlpha = 0;
               this.borderAlpha = 0;
               this.verticalGap = 2;
               this.borderThickness = 0;
               this.horizontalGap = 2;
               this.paddingBottom = 2;
               this.horizontalAlign = "center";
               this.paddingTop = 2;
               this.borderStyle = "none";
               this.paddingLeft = 2;
            };
         }
         style = StyleManager.getStyleDeclaration(".buyStyle");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".buyStyle",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.defaultUpMask = "left center right";
               this.color = 16777215;
               this.skin = BitmapButtonSkin;
               this.defaultOverLeftImage = _embed_css_images_custombutton_Button_IngameShopBuy_tileable_end_over_png_2097822234;
               this.defaultDownMask = "left center right";
               this.disabledColor = 16777215;
               this.defaultUpRightImage = "left";
               this.defaultUpCenterImage = _embed_css_images_custombutton_Button_IngameShopBuy_tileable_idle_png_931484342;
               this.defaultDownRightImage = "left";
               this.defaultDownLeftImage = _embed_css_images_custombutton_Button_IngameShopBuy_tileable_end_pressed_png_301372130;
               this.defaultOverRightImage = "left";
               this.defaultOverCenterImage = _embed_css_images_custombutton_Button_IngameShopBuy_tileable_over_png_2100178506;
               this.textSelectedColor = 16777215;
               this.textRollOverColor = 16777215;
               this.defaultDownCenterImage = _embed_css_images_custombutton_Button_IngameShopBuy_tileable_pressed_png_1298820406;
               this.defaultUpLeftImage = _embed_css_images_custombutton_Button_IngameShopBuy_tileable_end_idle_png_812485402;
               this.defaultOverMask = "left center right";
            };
         }
         style = StyleManager.getStyleDeclaration(".preyRerollListButton");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".preyRerollListButton",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.paddingBottom = 20;
               this.icon = _embed_css____images_prey_prey_list_reroll_png_1720722638;
               this.disabledIcon = _embed_css____images_prey_prey_list_reroll_disabled_png_1408279029;
            };
         }
         style = StyleManager.getStyleDeclaration(".npcCommitBox");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".npcCommitBox",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.paddingBottom = 2;
               this.paddingRight = 2;
               this.paddingTop = 2;
               this.paddingLeft = 2;
            };
         }
         style = StyleManager.getStyleDeclaration("SafeTradeWidgetView");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration("SafeTradeWidgetView",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.separatorColor = 8089164;
               this.tradeHeaderStyle = "tradeHeaderStyle";
               this.errorColor = 16711680;
               this.iconImage = _embed_css_images_Icons_WidgetHeaders_SafeTrades_png_1491550258;
               this.color = 13221291;
               this.tradeFooterStyle = "tradeFooterStyle";
               this.tradeItemListStyle = "tradeItemListStyle";
               this.disabledColor = 13221291;
               this.tradeItemSlotStyle = "";
            };
         }
         style = StyleManager.getStyleDeclaration(".preySelectPreyMonsterButton");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".preySelectPreyMonsterButton",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.icon = _embed_css____images_prey_prey_confirm_monster_selection_png_1854902533;
               this.disabledIcon = _embed_css____images_prey_prey_confirm_monster_selection_disabled_png_1540726376;
            };
         }
         style = StyleManager.getStyleDeclaration(".actionBarWidgetToggleLeft");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".actionBarWidgetToggleLeft",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.iconDefaultOverTopImage = "right";
               this.iconDefaultUpMask = "right";
               this.paddingRight = 0;
               this.selectedOverTopImage = "right";
               this.selectedDownLeftImage = "right";
               this.selectedOverLeftImage = "right";
               this.iconDefaultDownMask = "right";
               this.defaultDownTopImage = "right";
               this.borderLeft = 0;
               this.iconDefaultUpRightImage = _embed_css_images_Arrow_ScrollTabs_idle_png_1793155108;
               this.paddingBottom = 0;
               this.iconDefaultOverBottomImage = "right";
               this.iconSelectedDownMask = "left";
               this.iconDefaultDownRightImage = _embed_css_images_Arrow_ScrollTabs_pressed_png_169219784;
               this.borderBottom = 0;
               this.iconSelectedUpLeftImage = "right";
               this.iconSelectedDownTopImage = "right";
               this.selectedDownMask = "left";
               this.iconSelectedUpMask = "left";
               this.iconDefaultDownTopImage = "right";
               this.iconSelectedUpTopImage = "right";
               this.defaultOverLeftImage = "right";
               this.selectedUpTopImage = "right";
               this.iconSelectedDownBottomImage = "right";
               this.iconSelectedOverRightImage = _embed_css_images_Arrow_ScrollTabs_over_png_1462627108;
               this.defaultDownMask = "right";
               this.selectedUpMask = "left";
               this.selectedDownBottomImage = "right";
               this.iconSelectedDownRightImage = _embed_css_images_Arrow_ScrollTabs_pressed_png_169219784;
               this.iconDefaultUpTopImage = "right";
               this.defaultDownLeftImage = "right";
               this.defaultOverRightImage = _embed_css_images_Arrow_HotkeyToggle_BG_png_368269210;
               this.borderRight = 0;
               this.selectedOverRightImage = _embed_css_images_Arrow_HotkeyToggle_BG_png_368269210;
               this.iconDefaultUpLeftImage = "right";
               this.selectedUpRightImage = _embed_css_images_Arrow_HotkeyToggle_BG_png_368269210;
               this.iconDefaultOverLeftImage = "right";
               this.defaultUpLeftImage = "right";
               this.paddingLeft = 0;
               this.iconDefaultUpBottomImage = "right";
               this.iconSelectedOverMask = "left";
               this.iconSelectedDownLeftImage = "right";
               this.iconSelectedOverLeftImage = "right";
               this.selectedUpLeftImage = "right";
               this.iconSelectedOverTopImage = "right";
               this.skin = BitmapButtonSkin;
               this.icon = BitmapButtonIcon;
               this.defaultOverBottomImage = "right";
               this.borderTop = 0;
               this.defaultDownBottomImage = "right";
               this.defaultUpRightImage = _embed_css_images_Arrow_HotkeyToggle_BG_png_368269210;
               this.defaultDownRightImage = _embed_css_images_Arrow_HotkeyToggle_BG_png_368269210;
               this.defaultUpBottomImage = "right";
               this.defaultUpTopImage = "right";
               this.iconSelectedUpRightImage = _embed_css_images_Arrow_ScrollTabs_idle_png_1793155108;
               this.defaultOverTopImage = "right";
               this.selectedDownRightImage = _embed_css_images_Arrow_HotkeyToggle_BG_png_368269210;
               this.selectedOverMask = "left";
               this.iconDefaultDownLeftImage = "right";
               this.iconDefaultOverMask = "right";
               this.paddingTop = 0;
               this.iconSelectedUpBottomImage = "right";
               this.defaultOverMask = "right";
               this.selectedUpBottomImage = "right";
               this.defaultUpMask = "right";
               this.iconSelectedOverBottomImage = "right";
               this.selectedOverBottomImage = "right";
               this.selectedDownTopImage = "right";
               this.iconDefaultDownBottomImage = "right";
               this.iconDefaultOverRightImage = _embed_css_images_Arrow_ScrollTabs_over_png_1462627108;
            };
         }
         style = StyleManager.getStyleDeclaration(".purchaseCompletedStyle");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".purchaseCompletedStyle",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.defaultUpCenterImage = _embed_css_images_Button_PurchaseComplete_idle_png_950754944;
               this.defaultUpMask = "center";
               this.defaultOverCenterImage = _embed_css_images_Button_PurchaseComplete_over_png_1939813504;
               this.skin = BitmapButtonSkin;
               this.defaultDownCenterImage = _embed_css_images_Button_PurchaseComplete_pressed_png_296739540;
               this.defaultDownMask = "center";
               this.defaultOverMask = "center";
            };
         }
         style = StyleManager.getStyleDeclaration(".actionBarWidgetScrollRight");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".actionBarWidgetScrollRight",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.defaultDisabledRightImage = _embed_css_images_Arrow_ScrollHotkeys_disabled_png_326951061;
               this.paddingRight = 0;
               this.skin = BitmapButtonSkin;
               this.defaultOverBottomImage = "right";
               this.defaultDisabledLeftImage = "right";
               this.defaultDisabledTopImage = "right";
               this.defaultDownBottomImage = "right";
               this.defaultUpRightImage = _embed_css_images_Arrow_ScrollHotkeys_idle_png_1989691811;
               this.defaultDownTopImage = "right";
               this.defaultDownRightImage = _embed_css_images_Arrow_ScrollHotkeys_pressed_png_1194517687;
               this.defaultUpBottomImage = "right";
               this.defaultUpTopImage = "right";
               this.paddingBottom = 0;
               this.defaultOverTopImage = "right";
               this.paddingTop = 0;
               this.defaultDisabledBottomImage = "right";
               this.defaultOverMask = "right";
               this.defaultUpMask = "right";
               this.defaultOverLeftImage = "right";
               this.defaultDisabledMask = "right";
               this.defaultDownMask = "right";
               this.defaultDownLeftImage = "right";
               this.defaultOverRightImage = _embed_css_images_Arrow_ScrollHotkeys_over_png_191481507;
               this.defaultUpLeftImage = "right";
               this.paddingLeft = 0;
            };
         }
         style = StyleManager.getStyleDeclaration("OutfitColourSelector");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration("OutfitColourSelector",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.selectionAlpha = 1;
               this.horizontalGap = 2;
               this.paddingBottom = 0;
               this.pickerSize = 12;
               this.selectionColor = 13221291;
               this.paddingRight = 0;
               this.paddingTop = 0;
               this.verticalGap = 2;
               this.paddingLeft = 0;
            };
         }
         style = StyleManager.getStyleDeclaration(".imbuingDuration");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".imbuingDuration",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.backgroundLeftImage = _embed_css_images_BG_BarsProgress_compact_endpiece_png_1448454481;
               this.backgroundRightImage = "left";
               this.barImages = "barDefault";
               this.paddingBottom = 2;
               this.barDefault = _embed_css_images_BarsProgress_compact_orange_png_605959778;
               this.backgroundMask = "left center right";
               this.labelHorizontalAlign = "center";
               this.paddingTop = 2;
               this.backgroundCenterImage = _embed_css_images_BG_BarsProgress_compact_tileable_png_1503274352;
               this.barLimits = 0;
            };
         }
         style = StyleManager.getStyleDeclaration(".ingameShopOfferRendererBoxDisabled");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".ingameShopOfferRendererBoxDisabled",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.borderThickness = 1;
               this.borderColor = 7630671;
               this.backgroundColor = 658961;
               this.horizontalAlign = "center";
               this.borderAlpha = 1;
               this.backgroundAlpha = 0.5;
               this.borderSkin = VectorBorderSkin;
               this.borderStyle = "solid";
            };
         }
         style = StyleManager.getStyleDeclaration(".bodySlotNeck");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".bodySlotNeck",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.emptyBackgroundImage = _embed_css_images_Slot_InventoryNecklace_png_2012705831;
            };
         }
         style = StyleManager.getStyleDeclaration(".npcTradeModeBox");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".npcTradeModeBox",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.verticalAlign = "middle";
               this.paddingBottom = 0;
               this.horizontalAlign = "left";
               this.paddingRight = 2;
               this.borderTopImage = _embed_css_images_BG_ChatTab_tileable_png_2031873750;
               this.borderMask = "top";
               this.paddingTop = 0;
               this.borderSkin = BitmapBorderSkin;
               this.paddingLeft = 2;
            };
         }
         style = StyleManager.getStyleDeclaration("PremiumWidgetView");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration("PremiumWidgetView",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.iconImage = _embed_css_images_Icons_WidgetHeaders_GetPremium_png_582079029;
               this.color = 13221291;
               this.borderFooterMask = "none";
            };
         }
         style = StyleManager.getStyleDeclaration(".rootContainer");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".rootContainer",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.dividerBackgroundRightImage = _embed_css_images_Border02_png_856171138;
               this.dividerKnobAlignment = "top";
               this.dividerBackgroundTopRightImage = _embed_css_images_Border02_corners_png_1465567525;
               this.horizontalGap = 0;
               this.dividerThickness = 7;
               this.dividerBackgroundMask = "topLeft top topRight";
               this.dividerAffordance = 7;
               this.dividerKnobMask = "top";
               this.verticalGap = 7;
               this.dividerBackgroundTopLeftImage = "topRight";
               this.dividerKnobTopImage = _embed_css_images_ChatWindow_Mover_png_1725151138;
            };
         }
         style = StyleManager.getStyleDeclaration(".npcSummaryBox");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".npcSummaryBox",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.paddingBottom = 2;
               this.paddingRight = 2;
               this.paddingTop = 2;
               this.paddingLeft = 2;
            };
         }
         style = StyleManager.getStyleDeclaration(".bodySlotHip");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".bodySlotHip",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.emptyBackgroundImage = _embed_css_images_Slot_InventoryAmmo_png_813114047;
            };
         }
         style = StyleManager.getStyleDeclaration("ToolTip");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration("ToolTip",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.borderThickness = 1;
               this.borderColor = 13415802;
               this.backgroundColor = 658961;
               this.color = 13221291;
               this.borderAlpha = 1;
               this.backgroundAlpha = 0.8;
               this.borderSkin = VectorBorderSkin;
            };
         }
         style = StyleManager.getStyleDeclaration(".combatButtonMount");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".combatButtonMount",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.defaultUpMask = "center";
               this.selectedDownMask = "center";
               this.skin = BitmapButtonSkin;
               this.defaultDisabledMask = "center";
               this.defaultDownMask = "center";
               this.selectedUpMask = "center";
               this.defaultUpCenterImage = _embed_css_images_Icons_CombatControls_Unmounted_idle_png_1675114250;
               this.selectedOverCenterImage = _embed_css_images_Icons_CombatControls_Mounted_over_png_83007855;
               this.defaultOverCenterImage = _embed_css_images_Icons_CombatControls_Unmounted_over_png_948934666;
               this.selectedOverMask = "center";
               this.defaultDownCenterImage = _embed_css_images_Icons_CombatControls_Unmounted_over_png_948934666;
               this.selectedDownCenterImage = _embed_css_images_Icons_CombatControls_Mounted_over_png_83007855;
               this.defaultOverMask = "center";
               this.selectedDisabledMask = "center";
               this.selectedUpCenterImage = _embed_css_images_Icons_CombatControls_Mounted_idle_png_264427409;
            };
         }
         style = StyleManager.getStyleDeclaration(".statusWidgetParallelMana");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".statusWidgetParallelMana",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.barImages = "barDefault";
               this.backgroundRightImage = _embed_css_images_BG_Bars_default_enpiece_png_329250772;
               this.paddingRight = 3;
               this.backgroundMask = "center";
               this.leftOrnamentMask = "left";
               this.rightOrnamentMask = "right";
               this.backgroundCenterImage = _embed_css_images_BG_Bars_default_tileable_png_813666947;
               this.rightOrnamentRightImage = _embed_css_images_BG_Bars_default_enpieceOrnamented_png_1621675861;
               this.backgroundLeftImage = "right";
               this.leftOrnamentLeftImage = "right";
               this.paddingBottom = 3;
               this.barDefault = _embed_css_images_BarsHealth_default_Mana_png_2014888902;
               this.leftOrnamentOffset = -5;
               this.rightOrnamentOffset = 5;
               this.paddingTop = 1;
               this.leftOrnamentRightImage = _embed_css_images_BG_Bars_default_enpieceOrnamented_png_1621675861;
               this.paddingLeft = 3;
               this.barLimits = 0;
            };
         }
         style = StyleManager.getStyleDeclaration(".bodySlotHipBlessed");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".bodySlotHipBlessed",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.emptyBackgroundImage = _embed_css_images_Slot_InventoryAmmo_protected_png_235878180;
               this.backgroundImage = _embed_css_images_slot_Hotkey_protected_png_1201653772;
            };
         }
         style = StyleManager.getStyleDeclaration("TextArea");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration("TextArea",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.borderThickness = 1;
               this.borderColor = 0;
               this.backgroundColor = 2240055;
               this.focusThickness = 0;
               this.borderAlpha = 1;
               this.backgroundAlpha = 0.5;
               this.borderStyle = "solid";
            };
         }
         style = StyleManager.getStyleDeclaration(".bodySlotBack");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".bodySlotBack",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.emptyBackgroundImage = _embed_css_images_Slot_InventoryBackpack_png_1739537709;
            };
         }
         style = StyleManager.getStyleDeclaration("SpellIconRenderer");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration("SpellIconRenderer",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.overlaySelectedImage = _embed_css_images_slot_container_highlighted_png_622440584;
               this.paddingBottom = 1;
               this.backgroundImage = _embed_css_images_slot_container_png_1830671892;
               this.paddingRight = 1;
               this.overlayUnavailableImage = _embed_css_images_slot_container_disabled_png_2143438719;
               this.paddingTop = 1;
               this.paddingLeft = 1;
            };
         }
         style = StyleManager.getStyleDeclaration(".bodySlotBackBlessed");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".bodySlotBackBlessed",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.emptyBackgroundImage = _embed_css_images_Slot_InventoryBackpack_protected_png_274576798;
               this.backgroundImage = _embed_css_images_slot_Hotkey_protected_png_1201653772;
            };
         }
         style = StyleManager.getStyleDeclaration(".statusWidgetParallelSkillProgress");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".statusWidgetParallelSkillProgress",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.tickCenterImage = _embed_css_images_Bars_ProgressMarker_png_1761755336;
               this.backgroundRightImage = "left";
               this.barImages = "barDefault";
               this.tickMask = "center";
               this.paddingRight = -5;
               this.backgroundMask = "left center right";
               this.backgroundCenterImage = _embed_css_images_BG_BarsXP_default_tileable_png_1408337339;
               this.backgroundLeftImage = _embed_css_images_BG_BarsXP_default_endpiece_png_1394078162;
               this.barDefault = _embed_css_images_BarsXP_default__png_385879515;
               this.paddingBottom = 4;
               this.tickOffset = 3;
               this.paddingTop = 3;
               this.paddingLeft = -5;
               this.barLimits = 0;
            };
         }
         style = StyleManager.getStyleDeclaration(".sideBarHeaderBattlelist");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".sideBarHeaderBattlelist",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.defaultUpMask = "center";
               this.selectedDownMask = "center";
               this.skin = BitmapButtonSkin;
               this.defaultDownMask = "center";
               this.selectedUpMask = "center";
               this.defaultUpCenterImage = _embed_css_images_Icons_WidgetMenu_BattleList_idle_png_224575958;
               this.selectedOverCenterImage = _embed_css_images_Icons_WidgetMenu_BattleList_active_over_png_523969601;
               this.defaultOverCenterImage = _embed_css_images_Icons_WidgetMenu_BattleList_idle_over_png_803885037;
               this.selectedOverMask = "center";
               this.defaultDownCenterImage = _embed_css_images_Icons_WidgetMenu_BattleList_idle_over_png_803885037;
               this.selectedDownCenterImage = _embed_css_images_Icons_WidgetMenu_BattleList_active_over_png_523969601;
               this.defaultOverMask = "center";
               this.selectedUpCenterImage = _embed_css_images_Icons_WidgetMenu_BattleList_active_png_1129152252;
            };
         }
         style = StyleManager.getStyleDeclaration("BuddylistWidgetView");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration("BuddylistWidgetView",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.horizontalGap = 0;
               this.listStyle = "buddylist";
               this.paddingBottom = 0;
               this.iconImage = _embed_css_images_Icons_WidgetHeaders_VipList_png_164461471;
               this.paddingRight = 0;
               this.listBoxStyle = "buddylistContent";
               this.paddingTop = 0;
               this.verticalGap = 0;
               this.paddingLeft = 0;
            };
         }
         style = StyleManager.getStyleDeclaration(".ingameShopCategories");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".ingameShopCategories",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.paddintTop = 0;
               this.alternatingItemColors = [1842980,2174521];
               this.paddingRight = 2;
               this.paddingLeft = 2;
            };
         }
         style = StyleManager.getStyleDeclaration(".removeImbuementButton");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".removeImbuementButton",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.icon = _embed_css_____assets_images_imbuing_imbuing_icon_remove_active_png_831749865;
               this.disabledIcon = _embed_css_____assets_images_imbuing_imbuing_icon_remove_disabled_png_1775436169;
            };
         }
         style = StyleManager.getStyleDeclaration(".npcTradeButtonLayout");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".npcTradeButtonLayout",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.defaultUpMask = "center";
               this.selectedDownMask = "center";
               this.skin = BitmapButtonSkin;
               this.defaultDownMask = "center";
               this.selectedUpMask = "center";
               this.defaultUpCenterImage = _embed_css_images_Icons_TradeLists_ContainerDisplay_idle_png_851212863;
               this.selectedOverCenterImage = _embed_css_images_Icons_TradeLists_ListDisplay_over_png_417076086;
               this.defaultOverCenterImage = _embed_css_images_Icons_TradeLists_ContainerDisplay_over_png_1199957823;
               this.selectedOverMask = "center";
               this.defaultDownCenterImage = _embed_css_images_Icons_TradeLists_ContainerDisplay_pressed_png_817941011;
               this.selectedDownCenterImage = _embed_css_images_Icons_TradeLists_ListDisplay_pressed_png_1846304974;
               this.defaultOverMask = "center";
               this.selectedUpCenterImage = _embed_css_images_Icons_TradeLists_ListDisplay_idle_png_1140494966;
            };
         }
         style = StyleManager.getStyleDeclaration(".preyRerollListButtonSmall");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".preyRerollListButtonSmall",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.paddingRight = 75;
               this.icon = _embed_css____images_prey_prey_list_reroll_small_png_1392369160;
               this.disabledIcon = _embed_css____images_prey_prey_list_reroll_small_disabled_png_600754165;
            };
         }
         style = StyleManager.getStyleDeclaration("FocusNotifier");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration("FocusNotifier",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.modalTransparencyColor = 1580578;
               this.color = 13120000;
               this.modalTransparencyBlur = 0;
               this.modalTransparencyDuration = 0;
               this.modalTransparency = 0.5;
               this.fontSize = 18;
               this.fontWeight = "bold";
            };
         }
         style = StyleManager.getStyleDeclaration(".embeddedDialogTitle");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".embeddedDialogTitle",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.fontSize = 11;
               this.fontWeight = "bold";
            };
         }
         style = StyleManager.getStyleDeclaration(".marketWidgetViewToggle");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".marketWidgetViewToggle",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.defaultUpMask = "center";
               this.selectedDownMask = "center";
               this.skin = BitmapButtonSkin;
               this.defaultDownMask = "center";
               this.selectedUpMask = "center";
               this.defaultUpCenterImage = _embed_css_images_Icons_TradeLists_ContainerDisplay_idle_png_851212863;
               this.selectedOverCenterImage = _embed_css_images_Icons_TradeLists_ListDisplay_over_png_417076086;
               this.defaultOverCenterImage = _embed_css_images_Icons_TradeLists_ContainerDisplay_over_png_1199957823;
               this.selectedOverMask = "center";
               this.defaultDownCenterImage = _embed_css_images_Icons_TradeLists_ContainerDisplay_pressed_png_817941011;
               this.selectedDownCenterImage = _embed_css_images_Icons_TradeLists_ListDisplay_pressed_png_1846304974;
               this.defaultOverMask = "center";
               this.selectedUpCenterImage = _embed_css_images_Icons_TradeLists_ListDisplay_idle_png_1140494966;
            };
         }
         style = StyleManager.getStyleDeclaration("CategoryRenderer");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration("CategoryRenderer",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.verticalAlign = "middle";
               this.paddintTop = 0;
               this.horizontalGap = 4;
               this.paddingRight = 2;
               this.paddingLeft = 2;
            };
         }
         style = StyleManager.getStyleDeclaration(".astralSourceBox");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".astralSourceBox",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.borderThickness = 1;
               this.borderColor = 7630671;
               this.backgroundColor = 1842980;
               this.borderAlpha = 1;
               this.borderStyle = "solid";
            };
         }
         style = StyleManager.getStyleDeclaration(".sideBarToggleLeft");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".sideBarToggleLeft",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.iconDefaultOverTopImage = "right";
               this.iconDefaultUpMask = "right";
               this.paddingRight = 0;
               this.selectedOverTopImage = "right";
               this.selectedDownLeftImage = "right";
               this.selectedOverLeftImage = "right";
               this.iconDefaultDownMask = "right";
               this.defaultDownTopImage = "right";
               this.iconDefaultUpRightImage = _embed_css_images_Arrow_WidgetToggle_idle_png_550075419;
               this.paddingBottom = 0;
               this.iconDefaultOverBottomImage = "right";
               this.iconSelectedDownMask = "left";
               this.iconDefaultDownRightImage = _embed_css_images_Arrow_WidgetToggle_pressed_png_806241479;
               this.iconSelectedUpLeftImage = "right";
               this.iconSelectedDownTopImage = "right";
               this.selectedDownMask = "left";
               this.iconSelectedUpMask = "left";
               this.iconDefaultDownTopImage = "right";
               this.iconSelectedUpTopImage = "right";
               this.defaultOverLeftImage = "right";
               this.selectedUpTopImage = "right";
               this.iconSelectedDownBottomImage = "right";
               this.iconSelectedOverRightImage = _embed_css_images_Arrow_WidgetToggle_over_png_334496997;
               this.defaultDownMask = "right";
               this.selectedUpMask = "left";
               this.selectedDownBottomImage = "right";
               this.iconSelectedDownRightImage = _embed_css_images_Arrow_WidgetToggle_pressed_png_806241479;
               this.iconDefaultUpTopImage = "right";
               this.defaultDownLeftImage = "right";
               this.defaultOverRightImage = _embed_css_images_Arrow_WidgetToggle_BG_png_2044967256;
               this.selectedOverRightImage = _embed_css_images_Arrow_WidgetToggle_BG_png_2044967256;
               this.iconDefaultUpLeftImage = "right";
               this.selectedUpRightImage = _embed_css_images_Arrow_WidgetToggle_BG_png_2044967256;
               this.iconDefaultOverLeftImage = "right";
               this.defaultUpLeftImage = "right";
               this.paddingLeft = 0;
               this.iconDefaultUpBottomImage = "right";
               this.iconSelectedOverMask = "left";
               this.iconSelectedDownLeftImage = "right";
               this.iconSelectedOverLeftImage = "right";
               this.selectedUpLeftImage = "right";
               this.iconSelectedOverTopImage = "right";
               this.skin = BitmapButtonSkin;
               this.icon = BitmapButtonIcon;
               this.defaultOverBottomImage = "right";
               this.defaultDownBottomImage = "right";
               this.defaultUpRightImage = _embed_css_images_Arrow_WidgetToggle_BG_png_2044967256;
               this.toggleButtonStyle = "sideBarToggleLeft";
               this.defaultDownRightImage = _embed_css_images_Arrow_WidgetToggle_BG_png_2044967256;
               this.defaultUpBottomImage = "right";
               this.defaultUpTopImage = "right";
               this.iconSelectedUpRightImage = _embed_css_images_Arrow_WidgetToggle_idle_png_550075419;
               this.defaultOverTopImage = "right";
               this.selectedDownRightImage = _embed_css_images_Arrow_WidgetToggle_BG_png_2044967256;
               this.selectedOverMask = "left";
               this.iconDefaultDownLeftImage = "right";
               this.iconDefaultOverMask = "right";
               this.paddingTop = 0;
               this.iconSelectedUpBottomImage = "right";
               this.defaultOverMask = "right";
               this.selectedUpBottomImage = "right";
               this.defaultUpMask = "right";
               this.iconSelectedOverBottomImage = "right";
               this.selectedOverBottomImage = "right";
               this.selectedDownTopImage = "right";
               this.borderMask = "right";
               this.iconDefaultDownBottomImage = "right";
               this.iconDefaultOverRightImage = _embed_css_images_Arrow_WidgetToggle_over_png_334496997;
            };
         }
         style = StyleManager.getStyleDeclaration("Container");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration("Container",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.focusThickness = 0;
            };
         }
         style = StyleManager.getStyleDeclaration(".hotkeyOptionsSetScrollLeft");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".hotkeyOptionsSetScrollLeft",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.defaultDisabledRightImage = _embed_css_images_Arrow_ScrollTabs_disabled_png_744892220;
               this.defaultUpMask = "left";
               this.skin = BitmapButtonSkin;
               this.defaultOverLeftImage = "right";
               this.defaultDisabledMask = "left";
               this.defaultDisabledLeftImage = "right";
               this.defaultDownMask = "left";
               this.defaultUpRightImage = _embed_css_images_Arrow_ScrollTabs_idle_png_1793155108;
               this.defaultDownRightImage = _embed_css_images_Arrow_ScrollTabs_pressed_png_169219784;
               this.defaultDownLeftImage = "right";
               this.defaultOverRightImage = _embed_css_images_Arrow_ScrollTabs_over_png_1462627108;
               this.defaultUpLeftImage = "right";
               this.defaultOverMask = "left";
            };
         }
         style = StyleManager.getStyleDeclaration("Tibia");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration("Tibia",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.themeColor = 13221291;
               this.borderMask = "center";
               this.borderSkin = BitmapBorderSkin;
               this.borderCenterImage = _embed_css_images_BG_BohemianTileable_png_1964434549;
            };
         }
         style = StyleManager.getStyleDeclaration(".chatWidgetTabBarScrollRight");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".chatWidgetTabBarScrollRight",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.defaultDisabledRightImage = _embed_css_images_Arrow_ScrollTabs_disabled_png_744892220;
               this.defaultUpMask = "right";
               this.skin = BitmapButtonSkin;
               this.defaultOverBottomImage = "right";
               this.defaultOverLeftImage = "right";
               this.defaultDisabledMask = "right";
               this.defaultDisabledLeftImage = "right";
               this.defaultDownMask = "right";
               this.defaultDownBottomImage = "right";
               this.defaultUpRightImage = _embed_css_images_Arrow_ScrollTabs_idle_png_1793155108;
               this.defaultDownRightImage = _embed_css_images_Arrow_ScrollTabs_pressed_png_169219784;
               this.defaultUpBottomImage = "right";
               this.defaultDownLeftImage = "right";
               this.defaultOverRightImage = _embed_css_images_Arrow_ScrollTabs_over_png_1462627108;
               this.defaultUpLeftImage = "right";
               this.defaultDisabledBottomImage = "right";
               this.defaultOverMask = "right";
            };
         }
         style = StyleManager.getStyleDeclaration("List");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration("List",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.backgroundColor = "";
               this.selectionDuration = 0;
               this.alternatingItemColors = [658961,658961];
               this.color = 13221291;
               this.selectionColor = 4936794;
               this.backgroundAlpha = 0.8;
               this.selectionEasingFunction = "";
               this.borderSkin = EmptySkin;
               this.alternatingItemAlphas = [0.8,0.8];
               this.rollOverColor = 2633265;
               this.focusThickness = 0;
               this.textSelectedColor = 13221291;
               this.textRollOverColor = 13221291;
            };
         }
         style = StyleManager.getStyleDeclaration(".editMarkWidgetRootContainer");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".editMarkWidgetRootContainer",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.paddingBottom = 2;
               this.paddingRight = 2;
               this.paddingTop = 2;
               this.paddingLeft = 2;
            };
         }
         style = StyleManager.getStyleDeclaration(".notEnoughCurrency");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".notEnoughCurrency",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 13120000;
            };
         }
         style = StyleManager.getStyleDeclaration(".miniMapButtonCenter");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".miniMapButtonCenter",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.defaultUpCenterImage = _embed_css_images_Minimap_Center_idle_png_1943470262;
               this.defaultUpMask = "center";
               this.defaultOverCenterImage = _embed_css_images_Minimap_Center_over_png_803503178;
               this.skin = BitmapButtonSkin;
               this.defaultDownCenterImage = _embed_css_images_Minimap_Center_active_png_2136380360;
               this.defaultDownMask = "center";
               this.defaultOverMask = "center";
            };
         }
         style = StyleManager.getStyleDeclaration("ContextMenuBase");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration("ContextMenuBase",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.borderThickness = 1;
               this.borderColor = 13415802;
               this.backgroundColor = 658961;
               this.paddingBottom = 2;
               this.paddingRight = 2;
               this.borderAlpha = 1;
               this.backgroundAlpha = 0.8;
               this.paddingTop = 2;
               this.borderSkin = VectorBorderSkin;
               this.verticalGap = 0;
               this.paddingLeft = 2;
            };
         }
         style = StyleManager.getStyleDeclaration("ContainerViewWidgetView");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration("ContainerViewWidgetView",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.slotPaddingTop = 0;
               this.slotVerticalGap = 2;
               this.paddingRight = 1;
               this.verticalGap = 2;
               this.slotHorizontalGap = 2;
               this.slotPaddingRight = 0;
               this.pageRightButtonStyle = "containerPageRight";
               this.horizontalGap = 2;
               this.pageFooterStyle = "containerPageFooter";
               this.slotPaddingBottom = 0;
               this.upButtonStyle = "containerWigdetViewUp";
               this.slotVerticalAlign = "middle";
               this.pageLeftButtonStyle = "containerPageLeft";
               this.slotPaddingLeft = 5;
               this.slotHorizontalAlign = "center";
            };
         }
         style = StyleManager.getStyleDeclaration(".miniMapButtonSouth");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".miniMapButtonSouth",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.defaultUpMask = "bottom";
               this.skin = BitmapButtonSkin;
               this.defaultOverBottomImage = "right";
               this.defaultOverLeftImage = "right";
               this.defaultDownMask = "bottom";
               this.defaultDownBottomImage = "right";
               this.defaultUpRightImage = _embed_css_images_Arrow_ScrollTabs_idle_png_1793155108;
               this.defaultDownTopImage = "right";
               this.defaultDownRightImage = _embed_css_images_Arrow_ScrollTabs_pressed_png_169219784;
               this.defaultUpBottomImage = "right";
               this.defaultUpTopImage = "right";
               this.defaultDownLeftImage = "right";
               this.defaultOverRightImage = _embed_css_images_Arrow_ScrollTabs_over_png_1462627108;
               this.defaultOverTopImage = "right";
               this.defaultUpLeftImage = "right";
               this.defaultOverMask = "bottom";
            };
         }
         style = StyleManager.getStyleDeclaration(".npcTradeWidgetView");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".npcTradeWidgetView",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.overlayHighlightImage = _embed_css_images_slot_container_highlighted_png_622440584;
               this.paddingBottom = 1;
               this.backgroundImage = _embed_css_images_slot_container_png_1830671892;
               this.paddingRight = 1;
               this.overlayDisabledImage = _embed_css_images_slot_container_disabled_png_2143438719;
               this.paddingTop = 1;
               this.paddingLeft = 1;
            };
         }
         style = StyleManager.getStyleDeclaration(".battlelistHeader");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".battlelistHeader",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.verticalAlign = "middle";
               this.horizontalGap = 2;
               this.paddingBottom = 0;
               this.horizontalAlign = "center";
               this.paddingRight = 2;
               this.borderTopImage = _embed_css_images_BG_ChatTab_tileable_png_2031873750;
               this.borderMask = "top";
               this.paddingTop = 0;
               this.borderSkin = BitmapBorderSkin;
               this.verticalGap = 0;
               this.paddingLeft = 2;
            };
         }
         style = StyleManager.getStyleDeclaration(".battlelistContent");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".battlelistContent",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.paddingBottom = 2;
               this.paddingRight = 2;
               this.paddingTop = 2;
               this.paddingLeft = 2;
            };
         }
         style = StyleManager.getStyleDeclaration(".actionBarWidgetScrollLeft");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".actionBarWidgetScrollLeft",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.defaultDisabledRightImage = _embed_css_images_Arrow_ScrollHotkeys_disabled_png_326951061;
               this.paddingRight = 0;
               this.skin = BitmapButtonSkin;
               this.defaultOverBottomImage = "right";
               this.defaultDisabledLeftImage = "right";
               this.defaultDisabledTopImage = "right";
               this.defaultDownBottomImage = "right";
               this.defaultUpRightImage = _embed_css_images_Arrow_ScrollHotkeys_idle_png_1989691811;
               this.defaultDownTopImage = "right";
               this.defaultDownRightImage = _embed_css_images_Arrow_ScrollHotkeys_pressed_png_1194517687;
               this.defaultUpBottomImage = "right";
               this.defaultUpTopImage = "right";
               this.paddingBottom = 0;
               this.defaultOverTopImage = "right";
               this.paddingTop = 0;
               this.defaultDisabledBottomImage = "right";
               this.defaultOverMask = "left";
               this.defaultUpMask = "left";
               this.defaultOverLeftImage = "right";
               this.defaultDisabledMask = "left";
               this.defaultDownMask = "left";
               this.defaultDownLeftImage = "right";
               this.defaultOverRightImage = _embed_css_images_Arrow_ScrollHotkeys_over_png_191481507;
               this.defaultUpLeftImage = "right";
               this.paddingLeft = 0;
            };
         }
         style = StyleManager.getStyleDeclaration(".selectOutfitLabel");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".selectOutfitLabel",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.borderThickness = 1;
               this.verticalAlign = "middle";
               this.borderColor = 0;
               this.backgroundColor = 2240055;
               this.horizontalAlign = "center";
               this.borderAlpha = 1;
               this.backgroundAlpha = 0.5;
               this.borderStyle = "solid";
            };
         }
         style = StyleManager.getStyleDeclaration(".statusWidgetCompactBonusSkillProgress");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".statusWidgetCompactBonusSkillProgress",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.tickCenterImage = _embed_css_images_Bars_ProgressMarker_png_1761755336;
               this.backgroundRightImage = "left";
               this.barImages = "barDefault";
               this.tickMask = "center";
               this.paddingRight = -5;
               this.backgroundMask = "left center right";
               this.backgroundCenterImage = _embed_css_images_BG_BarsXP_default_tileable_png_1408337339;
               this.backgroundLeftImage = _embed_css_images_BG_BarsXP_default_endpiece_png_1394078162;
               this.barDefault = _embed_css_images_BarsXP_default_improved_png_1615848679;
               this.paddingBottom = 4;
               this.tickOffset = 3;
               this.paddingTop = 3;
               this.paddingLeft = -5;
               this.barLimits = 0;
            };
         }
         style = StyleManager.getStyleDeclaration("BattlelistWidgetView");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration("BattlelistWidgetView",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.headerBoxStyle = "battlelistHeader";
               this.hideNPCButtonStyle = "battlelistWidgetViewHideNPC";
               this.iconImage = _embed_css_images_Icons_WidgetHeaders_BattleList_png_1186213636;
               this.paddingRight = 0;
               this.listBoxStyle = "battlelistContent";
               this.verticalGap = 0;
               this.hidePartyButtonStyle = "battlelistWidgetViewHideParty";
               this.hideMonsterButtonStyle = "battlelistWidgetViewHideMonster";
               this.horizontalGap = 0;
               this.listStyle = "battlelist";
               this.paddingBottom = 0;
               this.paddingTop = 0;
               this.hidePlayerButtonStyle = "battlelistWidgetViewHidePlayer";
               this.paddingLeft = 0;
               this.hideNonSkulledButtonStyle = "battlelistWidgetViewHideNonSkulled";
            };
         }
         style = StyleManager.getStyleDeclaration("CharacterNameChangeWidget");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration("CharacterNameChangeWidget",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.buttonYesStyle = "ingameShopYesButton";
               this.buttonCancelStyle = "ingameShopNoButton";
               this.errorColor = 16711680;
               this.informationColor = 4286945;
               this.successColor = 65280;
               this.buttonOkayStyle = "ingameShopYesButton";
               this.buttonNoStyle = "ingameShopNoButton";
               this.minimumButtonWidth = 60;
               this.titleBoxStyle = "popupDialogHeaderFooter";
               this.buttonBoxStyle = "popupDialogHeaderFooter";
            };
         }
         style = StyleManager.getStyleDeclaration(".spellListWidgetTabContent");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".spellListWidgetTabContent",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.paddingBottom = 2;
               this.paddingRight = 2;
               this.paddingTop = 2;
               this.paddingLeft = 2;
            };
         }
         style = StyleManager.getStyleDeclaration(".chatWidgetRightHolder");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".chatWidgetRightHolder",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.verticalAlign = "bottom";
               this.horizontalGap = 0;
               this.paddingBottom = 0;
               this.horizontalAlign = "center";
               this.paddingRight = 0;
               this.borderMask = "center";
               this.paddingTop = 0;
               this.borderSkin = BitmapBorderSkin;
               this.verticalGap = 0;
               this.paddingLeft = 0;
               this.borderCenterImage = _embed_css_images_BG_ChatTab_Tabdrop_png_60591148;
            };
         }
         style = StyleManager.getStyleDeclaration(".optionsConfigurationWidgetTabNavigator");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".optionsConfigurationWidgetTabNavigator",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.borderThickness = 1;
               this.borderColor = 13415802;
               this.backgroundColor = 658961;
               this.paddingBottom = 1;
               this.paddingRight = 1;
               this.borderAlpha = 1;
               this.backgroundAlpha = 0.5;
               this.tabStyleName = "simpleTabNavigator";
               this.paddingTop = 1;
               this.borderStyle = "solid";
               this.paddingLeft = 1;
            };
         }
         style = StyleManager.getStyleDeclaration(".npcTradeModeTab");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".npcTradeModeTab",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.errorColor = 15904590;
               this.defaultUpMask = "center";
               this.selectedDownMask = "center";
               this.color = 15904590;
               this.textAlign = "center";
               this.paddingRight = 4;
               this.skin = BitmapButtonSkin;
               this.defaultDownMask = "center";
               this.selectedUpMask = "center";
               this.disabledColor = 15904590;
               this.defaultUpCenterImage = _embed_css_images_BuySellTab_idle_png_886708504;
               this.paddingBottom = 0;
               this.selectedOverCenterImage = _embed_css_images_BuySellTab_active_png_1449511366;
               this.defaultOverCenterImage = _embed_css_images_BuySellTab_idle_png_886708504;
               this.selectedOverMask = "center";
               this.textSelectedColor = 15904590;
               this.textRollOverColor = 15904590;
               this.defaultDownCenterImage = _embed_css_images_BuySellTab_idle_png_886708504;
               this.selectedDownCenterImage = _embed_css_images_BuySellTab_active_png_1449511366;
               this.paddingTop = 0;
               this.paddingLeft = 4;
               this.defaultOverMask = "center";
               this.selectedUpCenterImage = _embed_css_images_BuySellTab_active_png_1449511366;
            };
         }
         style = StyleManager.getStyleDeclaration("SmoothList");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration("SmoothList",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.borderThickness = 0;
               this.borderColor = 65280;
               this.backgroundColor = 65280;
               this.borderAlpha = 0;
               this.backgroundAlpha = 0;
               this.borderSkin = VectorBorderSkin;
            };
         }
         style = StyleManager.getStyleDeclaration(".containerWigdetViewUp");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".containerWigdetViewUp",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.defaultUpCenterImage = _embed_css_images_Button_ContainerUp_idle_png_1017477430;
               this.defaultUpMask = "center";
               this.defaultOverCenterImage = _embed_css_images_Button_ContainerUp_over_png_133274678;
               this.skin = BitmapButtonSkin;
               this.defaultDisabledCenterImage = _embed_css_images_Button_ContainerUp_idle_png_1017477430;
               this.defaultDisabledMask = "center";
               this.defaultDownCenterImage = _embed_css_images_Button_ContainerUp_pressed_png_697201334;
               this.defaultDownMask = "center";
               this.defaultOverMask = "center";
            };
         }
         style = StyleManager.getStyleDeclaration(".nicklist");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".nicklist",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.itemVerticalGap = 0;
               this.itemHorizontalGap = 0;
            };
         }
         style = StyleManager.getStyleDeclaration(".hotkeyOptionsSetScrollRight");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".hotkeyOptionsSetScrollRight",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.defaultDisabledRightImage = _embed_css_images_Arrow_ScrollTabs_disabled_png_744892220;
               this.defaultUpMask = "right";
               this.skin = BitmapButtonSkin;
               this.defaultOverLeftImage = "right";
               this.defaultDisabledMask = "right";
               this.defaultDisabledLeftImage = "right";
               this.defaultDownMask = "right";
               this.defaultUpRightImage = _embed_css_images_Arrow_ScrollTabs_idle_png_1793155108;
               this.defaultDownRightImage = _embed_css_images_Arrow_ScrollTabs_pressed_png_169219784;
               this.defaultDownLeftImage = "right";
               this.defaultOverRightImage = _embed_css_images_Arrow_ScrollTabs_over_png_1462627108;
               this.defaultUpLeftImage = "right";
               this.defaultOverMask = "right";
            };
         }
         style = StyleManager.getStyleDeclaration(".selectOutfitTabNavigator");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".selectOutfitTabNavigator",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.borderThickness = 1;
               this.borderColor = 13415802;
               this.backgroundColor = 658961;
               this.paddingBottom = 1;
               this.paddingRight = 1;
               this.borderAlpha = 1;
               this.backgroundAlpha = 0.5;
               this.tabStyleName = "simpleTabNavigator";
               this.paddingTop = 1;
               this.borderStyle = "solid";
               this.paddingLeft = 1;
            };
         }
         style = StyleManager.getStyleDeclaration(".combatButtonBalanced");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".combatButtonBalanced",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.defaultUpMask = "center";
               this.selectedDownMask = "center";
               this.skin = BitmapButtonSkin;
               this.defaultDisabledMask = "center";
               this.defaultDownMask = "center";
               this.selectedUpMask = "center";
               this.defaultUpCenterImage = _embed_css_images_Icons_CombatControls_MediumOff_idle_png_844732849;
               this.selectedOverCenterImage = _embed_css_images_Icons_CombatControls_MediumOn_over_png_1002865639;
               this.defaultOverCenterImage = _embed_css_images_Icons_CombatControls_MediumOff_over_png_418575695;
               this.selectedOverMask = "center";
               this.defaultDownCenterImage = _embed_css_images_Icons_CombatControls_MediumOff_over_png_418575695;
               this.selectedDownCenterImage = _embed_css_images_Icons_CombatControls_MediumOn_over_png_1002865639;
               this.defaultOverMask = "center";
               this.selectedDisabledMask = "center";
               this.selectedUpCenterImage = _embed_css_images_Icons_CombatControls_MediumOn_idle_png_1333658855;
            };
         }
         style = StyleManager.getStyleDeclaration("CheckBox");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration("CheckBox",style,false);
         }
         style = StyleManager.getStyleDeclaration(".ingameShopCategoryDescription");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".ingameShopCategoryDescription",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.fontSize = 9;
            };
         }
         style = StyleManager.getStyleDeclaration(".npcAmountBox");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".npcAmountBox",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.paddingBottom = 2;
               this.paddingRight = 2;
               this.paddingTop = 2;
               this.paddingLeft = 2;
            };
         }
         style = StyleManager.getStyleDeclaration(".ingameShopBold");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".ingameShopBold",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.fontWeight = "bold";
            };
         }
         style = StyleManager.getStyleDeclaration(".buddylistWidgetView");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".buddylistWidgetView",style,false);
         }
         style = StyleManager.getStyleDeclaration("Sidebar");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration("Sidebar",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.paddingBottom = 0;
               this.paddingRight = 0;
               this.paddingTop = 0;
               this.verticalGap = 2;
               this.paddingLeft = 0;
               this.fontWeight = "bold";
            };
         }
         style = StyleManager.getStyleDeclaration("BodyContainerViewWidgetView");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration("BodyContainerViewWidgetView",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.capacityFontColor = 16777215;
               this.iconImage = _embed_css_images_Icons_WidgetHeaders_Inventory_png_2094138972;
               this.capacityFontFamily = "Verdana";
               this.borderCenterMask = "all";
               this.paddingRight = 0;
               this.borderCenterCenterImage = _embed_css_images_Inventory_png_54849410;
               this.bodySlotFeetStyle = "bodySlotFeet";
               this.bodySlotLeftHandBlessedStyle = "bodySlotLeftHandBlessed";
               this.bodySlotLegsBlessedStyle = "bodySlotLegsBlessed";
               this.verticalGap = 0;
               this.bodySlotTorsoBlessedStyle = "bodySlotTorsoBlessed";
               this.bodySlotLegsStyle = "bodySlotLegs";
               this.bodySlotLeftHandStyle = "bodySlotLeftHand";
               this.paddingBottom = 0;
               this.capacityFontStyle = "normal";
               this.bodySlotFeetBlessedStyle = "bodySlotFeetBlessed";
               this.paddingTop = 0;
               this.bodySlotFingerBlessedStyle = "bodySlotFingerBlessed";
               this.bodySlotRightHandBlessedStyle = "bodySlotRightHandBlessed";
               this.capacityFontWeight = "bold";
               this.bodySlotBackStyle = "bodySlotBack";
               this.bodySlotHipStyle = "bodySlotHip";
               this.bodySlotRightHandStyle = "bodySlotRightHand";
               this.buttonStoreInboxStyle = "buttonStoreInbox";
               this.borderFooterMask = "none";
               this.bodySlotTorsoStyle = "bodySlotTorso";
               this.bodySlotHipBlessedStyle = "bodySlotHipBlessed";
               this.bodySlotPremiumStyle = "bodySlotPremium";
               this.bodySlotFingerStyle = "bodySlotFinger";
               this.horizontalGap = 0;
               this.capacityFontSize = 9;
               this.bodySlotBlessingStyle = "bodySlotBlessing";
               this.bodySlotNeckStyle = "bodySlotNeck";
               this.bodySlotBackBlessedStyle = "bodySlotBackBlessed";
               this.bodySlotHeadBlessedStyle = "bodySlotHeadBlessed";
               this.bodySlotNeckBlessedStyle = "bodySlotNeckBlessed";
               this.paddingLeft = 0;
               this.bodySlotHeadStyle = "bodySlotHead";
               this.buttonIngameShopStyle = "buttonIngameShop";
            };
         }
         style = StyleManager.getStyleDeclaration(".actionBarBottom");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".actionBarBottom",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.toggleButtonStyle = "actionBarWidgetToggleBottom";
               this.scrollUpButtonStyle = "actionBarWidgetScrollRight";
               this.scrollDownButtonStyle = "actionBarWidgetScrollLeft";
               this.borderMask = "left bottomLeft bottom bottomRight right center";
            };
         }
         style = StyleManager.getStyleDeclaration(".sideBarHeaderCombat");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".sideBarHeaderCombat",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.defaultUpMask = "center";
               this.selectedDownMask = "center";
               this.skin = BitmapButtonSkin;
               this.defaultDownMask = "center";
               this.selectedUpMask = "center";
               this.defaultUpCenterImage = _embed_css_images_Icons_WidgetMenu_Combat_idle_png_1668074132;
               this.selectedOverCenterImage = _embed_css_images_Icons_WidgetMenu_Combat_active_over_png_992770113;
               this.defaultOverCenterImage = _embed_css_images_Icons_WidgetMenu_Combat_idle_over_png_665522223;
               this.selectedOverMask = "center";
               this.defaultDownCenterImage = _embed_css_images_Icons_WidgetMenu_Combat_idle_over_png_665522223;
               this.selectedDownCenterImage = _embed_css_images_Icons_WidgetMenu_Combat_active_over_png_992770113;
               this.defaultOverMask = "center";
               this.selectedUpCenterImage = _embed_css_images_Icons_WidgetMenu_Combat_active_png_390223278;
            };
         }
         style = StyleManager.getStyleDeclaration(".statusWidgetFatSkill");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".statusWidgetFatSkill",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.progressBarMalusStyleName = "statusWidgetFatMalusSkillProgress";
               this.verticalAlign = "middle";
               this.iconStyleName = "";
               this.progressBarBonusStyleName = "statusWidgetFatBonusSkillProgress";
               this.progressBarZeroStyleName = "statusWidgetFatZeroSkillProgress";
               this.horizontalGap = 0;
               this.progressBarStyleName = "statusWidgetFatSkillProgress";
               this.labelStyleName = ".statusWidgetSkillProgress";
            };
         }
         style = StyleManager.getStyleDeclaration(".astralSourceLabel");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".astralSourceLabel",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.textAlign = "center";
               this.fontWeight = "bold";
            };
         }
         style = StyleManager.getStyleDeclaration("DividedBox");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration("DividedBox",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.verticalDividerCursor = ResizeVerticalCursor;
               this.horizontalDividerCursor = ResizeHorizontalCursor;
            };
         }
         style = StyleManager.getStyleDeclaration(".baseCurrency");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".baseCurrency",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 7829367;
            };
         }
         style = StyleManager.getStyleDeclaration(".battlelistWidgetViewHidePlayer");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".battlelistWidgetViewHidePlayer",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.defaultUpMask = "center";
               this.selectedDownMask = "center";
               this.skin = BitmapButtonSkin;
               this.defaultDownMask = "center";
               this.selectedUpMask = "center";
               this.defaultUpCenterImage = _embed_css_images_Icons_BattleList_HidePlayers_idle_png_112457565;
               this.selectedOverCenterImage = _embed_css_images_Icons_BattleList_HidePlayers_active_over_png_961154706;
               this.defaultOverCenterImage = _embed_css_images_Icons_BattleList_HidePlayers_over_png_419396003;
               this.selectedOverMask = "center";
               this.defaultDownCenterImage = _embed_css_images_Icons_BattleList_HidePlayers_over_png_419396003;
               this.selectedDownCenterImage = _embed_css_images_Icons_BattleList_HidePlayers_active_over_png_961154706;
               this.defaultOverMask = "center";
               this.selectedUpCenterImage = _embed_css_images_Icons_BattleList_HidePlayers_active_png_1087801247;
            };
         }
         style = StyleManager.getStyleDeclaration(".buttonDialogOpenStoreButton");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".buttonDialogOpenStoreButton",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.icon = _embed_css_images_Icons_Inventory_Store_png_1300473375;
            };
         }
         style = StyleManager.getStyleDeclaration(".miniMapButtonZoomIn");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".miniMapButtonZoomIn",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.defaultUpCenterImage = _embed_css_images_Minimap_ZoomIn_idle_png_394970857;
               this.defaultUpMask = "center";
               this.defaultOverCenterImage = _embed_css_images_Minimap_ZoomIn_over_png_1410316311;
               this.skin = BitmapButtonSkin;
               this.defaultDownCenterImage = _embed_css_images_Minimap_ZoomIn_pressed_png_1554730941;
               this.defaultDownMask = "center";
               this.defaultOverMask = "center";
            };
         }
         style = StyleManager.getStyleDeclaration(".actionBarWidgetScrollTop");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".actionBarWidgetScrollTop",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.defaultDisabledRightImage = _embed_css_images_Arrow_ScrollHotkeys_disabled_png_326951061;
               this.paddingRight = 0;
               this.skin = BitmapButtonSkin;
               this.defaultOverBottomImage = "right";
               this.defaultDisabledLeftImage = "right";
               this.defaultDisabledTopImage = "right";
               this.defaultDownBottomImage = "right";
               this.defaultUpRightImage = _embed_css_images_Arrow_ScrollHotkeys_idle_png_1989691811;
               this.defaultDownTopImage = "right";
               this.defaultDownRightImage = _embed_css_images_Arrow_ScrollHotkeys_pressed_png_1194517687;
               this.defaultUpBottomImage = "right";
               this.defaultUpTopImage = "right";
               this.paddingBottom = 0;
               this.defaultOverTopImage = "right";
               this.paddingTop = 0;
               this.defaultDisabledBottomImage = "right";
               this.defaultOverMask = "top";
               this.defaultUpMask = "top";
               this.defaultOverLeftImage = "right";
               this.defaultDisabledMask = "top";
               this.defaultDownMask = "top";
               this.defaultDownLeftImage = "right";
               this.defaultOverRightImage = _embed_css_images_Arrow_ScrollHotkeys_over_png_191481507;
               this.defaultUpLeftImage = "right";
               this.paddingLeft = 0;
            };
         }
         style = StyleManager.getStyleDeclaration(".sideBarUnjustPoints");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".sideBarUnjustPoints",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.defaultUpMask = "center";
               this.selectedDownMask = "center";
               this.skin = BitmapButtonSkin;
               this.defaultDownMask = "center";
               this.selectedUpMask = "center";
               this.defaultUpCenterImage = _embed_css_images_Icons_WidgetMenu_Skull_idle_png_1630824013;
               this.selectedOverCenterImage = _embed_css_images_Icons_WidgetMenu_Skull_active_over_png_491271656;
               this.defaultOverCenterImage = _embed_css_images_Icons_WidgetMenu_Skull_idle_over_png_611961046;
               this.selectedOverMask = "center";
               this.defaultDownCenterImage = _embed_css_images_Icons_WidgetMenu_Skull_idle_over_png_611961046;
               this.selectedDownCenterImage = _embed_css_images_Icons_WidgetMenu_Skull_active_over_png_491271656;
               this.defaultOverMask = "center";
               this.selectedUpCenterImage = _embed_css_images_Icons_WidgetMenu_Skull_active_png_1541707963;
            };
         }
         style = StyleManager.getStyleDeclaration(".buttonIngameShop");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".buttonIngameShop",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.selectedOverBottomLeftImage = _embed_css_images_custombutton_Button_Highlight_tileable_bl_over_png_497741234;
               this.selectedUpLeftImage = _embed_css_images_custombutton_Button_Highlight_tileable_ml_idle_png_1397612513;
               this.paddingRight = 22;
               this.icon = _embed_css_images_Icons_Inventory_Store_png_1300473375;
               this.selectedOverTopImage = _embed_css_images_custombutton_Button_Highlight_tileable_tc_over_png_271197681;
               this.selectedDownLeftImage = _embed_css_images_custombutton_Button_Highlight_tileable_ml_pressed_png_1040849779;
               this.selectedOverLeftImage = _embed_css_images_custombutton_Button_Highlight_tileable_ml_over_png_1618062623;
               this.selectedUpBottomLeftImage = _embed_css_images_custombutton_Button_Highlight_tileable_bl_idle_png_308178610;
               this.selectedOverBottomRightImage = "bottomLeft";
               this.selectedDownRightImage = "left";
               this.selectedOverMask = "topLeft top topRight left center right bottomLeft bottom bottomRight";
               this.selectedDownTopLeftImage = _embed_css_images_custombutton_Button_Highlight_tileable_tl_pressed_png_2092601240;
               this.selectedDownCenterImage = _embed_css_images_custombutton_Button_Standard_tileable_mc_pressed_png_81347079;
               this.selectedUpTopLeftImage = _embed_css_images_custombutton_Button_Highlight_tileable_tl_idle_png_908937052;
               this.selectedUpBottomRightImage = "bottomLeft";
               this.selectedUpTopRightImage = "topLeft";
               this.selectedUpCenterImage = _embed_css_images_custombutton_Button_Standard_tileable_mc_idle_png_1278990365;
               this.selectedUpBottomImage = _embed_css_images_custombutton_Button_Highlight_tileable_bc_idle_png_1286951951;
               this.selectedDownBottomRightImage = "bottomLeft";
               this.selectedDownMask = "topLeft top topRight left center right bottomLeft bottom bottomRight";
               this.selectedOverTopRightImage = "topLeft";
               this.selectedOverBottomImage = _embed_css_images_custombutton_Button_Highlight_tileable_bc_over_png_1207833841;
               this.selectedUpTopImage = _embed_css_images_custombutton_Button_Highlight_tileable_tc_idle_png_1528191247;
               this.selectedUpMask = "topLeft top topRight left center right bottomLeft bottom bottomRight";
               this.selectedDownBottomImage = _embed_css_images_custombutton_Button_Highlight_tileable_bc_pressed_png_1234389013;
               this.selectedDownTopImage = _embed_css_images_custombutton_Button_Highlight_tileable_tc_pressed_png_1467694627;
               this.selectedOverTopLeftImage = _embed_css_images_custombutton_Button_Highlight_tileable_tl_over_png_1798619228;
               this.selectedDownBottomLeftImage = _embed_css_images_custombutton_Button_Highlight_tileable_bl_pressed_png_697106038;
               this.selectedOverCenterImage = _embed_css_images_custombutton_Button_Standard_tileable_mc_over_png_931421981;
               this.selectedDownTopRightImage = "topLeft";
               this.selectedOverRightImage = "left";
               this.selectedUpRightImage = "left";
               this.paddingLeft = 23;
            };
         }
         style = StyleManager.getStyleDeclaration(".ingameShopNoPadding");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".ingameShopNoPadding",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.paddingBottom = 0;
               this.paddingRight = 0;
               this.paddingTop = 0;
               this.paddingLeft = 0;
            };
         }
         style = StyleManager.getStyleDeclaration(".statusWidgetCompactSkillProgress");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".statusWidgetCompactSkillProgress",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.tickCenterImage = _embed_css_images_Bars_ProgressMarker_png_1761755336;
               this.backgroundRightImage = "left";
               this.barImages = "barDefault";
               this.tickMask = "center";
               this.paddingRight = -5;
               this.backgroundMask = "left center right";
               this.backgroundCenterImage = _embed_css_images_BG_BarsXP_default_tileable_png_1408337339;
               this.backgroundLeftImage = _embed_css_images_BG_BarsXP_default_endpiece_png_1394078162;
               this.barDefault = _embed_css_images_BarsXP_default__png_385879515;
               this.paddingBottom = 4;
               this.tickOffset = 3;
               this.paddingTop = 3;
               this.paddingLeft = -5;
               this.barLimits = 0;
            };
         }
         style = StyleManager.getStyleDeclaration(".ingameShopCreditBox");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".ingameShopCreditBox",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.verticalAlign = "middle";
               this.borderColor = 13415802;
               this.backgroundColor = 658961;
               this.paddingRight = 2;
               this.borderAlpha = 1;
               this.backgroundAlpha = 0.5;
               this.verticalGap = 2;
               this.borderThickness = 1;
               this.paddingBottom = 2;
               this.horizontalAlign = "center";
               this.paddingTop = 2;
               this.borderStyle = "solid";
               this.paddingLeft = 2;
            };
         }
         style = StyleManager.getStyleDeclaration(".containerPageRight");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".containerPageRight",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.defaultDisabledRightImage = _embed_css_images_Arrow_WidgetToggle_idle_png_550075419;
               this.defaultUpMask = "right";
               this.skin = BitmapButtonSkin;
               this.defaultOverBottomImage = "right";
               this.defaultOverLeftImage = "right";
               this.defaultDisabledMask = "right";
               this.defaultDisabledLeftImage = "right";
               this.defaultDownMask = "right";
               this.defaultDownBottomImage = "right";
               this.defaultUpRightImage = _embed_css_images_Arrow_WidgetToggle_idle_png_550075419;
               this.defaultDownRightImage = _embed_css_images_Arrow_WidgetToggle_pressed_png_806241479;
               this.defaultUpBottomImage = "right";
               this.defaultDownLeftImage = "right";
               this.defaultOverRightImage = _embed_css_images_Arrow_WidgetToggle_over_png_334496997;
               this.defaultUpLeftImage = "right";
               this.defaultDisabledBottomImage = "right";
               this.defaultOverMask = "right";
            };
         }
         style = StyleManager.getStyleDeclaration(".battlelistWidgetViewHideParty");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".battlelistWidgetViewHideParty",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.defaultUpMask = "center";
               this.selectedDownMask = "center";
               this.skin = BitmapButtonSkin;
               this.defaultDownMask = "center";
               this.selectedUpMask = "center";
               this.defaultUpCenterImage = _embed_css_images_Icons_BattleList_PartyMembers_idle_png_590067760;
               this.selectedOverCenterImage = _embed_css_images_Icons_BattleList_PartyMembers_active_over_png_405251525;
               this.defaultOverCenterImage = _embed_css_images_Icons_BattleList_PartyMembers_over_png_289252560;
               this.selectedOverMask = "center";
               this.defaultDownCenterImage = _embed_css_images_Icons_BattleList_PartyMembers_over_png_289252560;
               this.selectedDownCenterImage = _embed_css_images_Icons_BattleList_PartyMembers_active_over_png_405251525;
               this.defaultOverMask = "center";
               this.selectedUpCenterImage = _embed_css_images_Icons_BattleList_PartyMembers_active_png_1520198974;
            };
         }
         style = StyleManager.getStyleDeclaration("SpellListWidgetView");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration("SpellListWidgetView",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.horizontalGap = 0;
               this.paddingBottom = 0;
               this.iconImage = _embed_css_images_Icons_WidgetHeaders_Spells_png_527053179;
               this.paddingRight = 0;
               this.paddingTop = 0;
               this.verticalGap = 0;
               this.paddingLeft = 0;
            };
         }
         style = StyleManager.getStyleDeclaration("ActionBarWidget");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration("ActionBarWidget",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.horizontalGap = 2;
               this.paddingBottom = 2;
               this.borderRightImage = _embed_css_images_Border02_png_856171138;
               this.paddingRight = 2;
               this.paddingTop = 2;
               this.borderSkin = BitmapBorderSkin;
               this.borderTopRightImage = _embed_css_images_Border02_corners_png_1465567525;
               this.verticalGap = 2;
               this.paddingLeft = 2;
               this.borderCenterImage = _embed_css_images_BG_BohemianTileable_Game_png_1148175408;
            };
         }
         style = StyleManager.getStyleDeclaration(".preyRerollListButtonReactivate");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".preyRerollListButtonReactivate",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.icon = _embed_css____images_prey_prey_list_reroll_reactivate_png_1106340657;
               this.disabledIcon = _embed_css____images_prey_prey_list_reroll_reactivate_disabled_png_74434796;
            };
         }
         style = StyleManager.getStyleDeclaration(".preyDurationProgressSidebar");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".preyDurationProgressSidebar",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.tickCenterImage = _embed_css_images_Bars_ProgressMarker_png_1761755336;
               this.backgroundRightImage = "left";
               this.barImages = "barDefault";
               this.tickMask = "center";
               this.paddingRight = -5;
               this.backgroundMask = "left center right";
               this.backgroundCenterImage = _embed_css_images_BG_BarsXP_default_tileable_png_1408337339;
               this.backgroundLeftImage = _embed_css_images_BG_BarsXP_default_endpiece_png_1394078162;
               this.barDefault = _embed_css_images_BarsXP_default_malus_png_1083584633;
               this.paddingBottom = 4;
               this.tickOffset = 3;
               this.paddingTop = 3;
               this.paddingLeft = -5;
               this.barLimits = 0;
            };
         }
         style = StyleManager.getStyleDeclaration(".popUpTitleStyle");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".popUpTitleStyle",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 13221291;
               this.paddingRight = 8;
               this.fontSize = 12;
               this.fontWeight = "bold";
            };
         }
         style = StyleManager.getStyleDeclaration("TibiaCurrencyView");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration("TibiaCurrencyView",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.verticalAlign = "middle";
               this.horizontalGap = 0;
               this.paddingBottom = 0;
               this.color = 16232264;
               this.horizontalAlign = "right";
               this.paddingRight = 4;
               this.paddingTop = 0;
               this.paddingLeft = 4;
               this.fontWeight = "bold";
            };
         }
         style = StyleManager.getStyleDeclaration(".chatWidgetButtonIgnore");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".chatWidgetButtonIgnore",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.defaultUpCenterImage = _embed_css_images_Button_ChatTabIgnore_idle_png_373453081;
               this.defaultUpMask = "center";
               this.defaultOverCenterImage = _embed_css_images_Button_ChatTabIgnore_over_png_906238439;
               this.skin = BitmapButtonSkin;
               this.defaultDownCenterImage = _embed_css_images_Button_ChatTabIgnore_pressed_png_653700051;
               this.defaultDownMask = "center";
               this.defaultOverMask = "center";
            };
         }
         style = StyleManager.getStyleDeclaration(".nameFilterOptionsBlackListEditor");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".nameFilterOptionsBlackListEditor",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.nameFilterListStyle = "nameFilterEditorList";
            };
         }
         style = StyleManager.getStyleDeclaration(".preyPaddedBox");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".preyPaddedBox",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.paddingBottom = 5;
               this.paddingRight = 5;
               this.paddingTop = 5;
               this.paddingLeft = 5;
            };
         }
         style = StyleManager.getStyleDeclaration(".miniMapButtonEast");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".miniMapButtonEast",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.defaultUpMask = "right";
               this.skin = BitmapButtonSkin;
               this.defaultOverBottomImage = "right";
               this.defaultOverLeftImage = "right";
               this.defaultDownMask = "right";
               this.defaultDownBottomImage = "right";
               this.defaultUpRightImage = _embed_css_images_Arrow_ScrollTabs_idle_png_1793155108;
               this.defaultDownTopImage = "right";
               this.defaultDownRightImage = _embed_css_images_Arrow_ScrollTabs_pressed_png_169219784;
               this.defaultUpBottomImage = "right";
               this.defaultUpTopImage = "right";
               this.defaultDownLeftImage = "right";
               this.defaultOverRightImage = _embed_css_images_Arrow_ScrollTabs_over_png_1462627108;
               this.defaultOverTopImage = "right";
               this.defaultUpLeftImage = "right";
               this.defaultOverMask = "right";
            };
         }
         style = StyleManager.getStyleDeclaration(".sideBarHeaderTrade");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".sideBarHeaderTrade",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.defaultUpMask = "center";
               this.selectedDownMask = "center";
               this.skin = BitmapButtonSkin;
               this.defaultDownMask = "center";
               this.selectedUpMask = "center";
               this.defaultUpCenterImage = _embed_css_images_Icons_WidgetMenu_Trades_idle_png_925331141;
               this.selectedOverCenterImage = _embed_css_images_Icons_WidgetMenu_Trades_active_over_png_1728513382;
               this.defaultOverCenterImage = _embed_css_images_Icons_WidgetMenu_Trades_idle_over_png_433309128;
               this.selectedOverMask = "center";
               this.defaultDownCenterImage = _embed_css_images_Icons_WidgetMenu_Trades_idle_over_png_433309128;
               this.selectedDownCenterImage = _embed_css_images_Icons_WidgetMenu_Trades_active_over_png_1728513382;
               this.defaultOverMask = "center";
               this.selectedUpCenterImage = _embed_css_images_Icons_WidgetMenu_Trades_active_png_1472479607;
            };
         }
         style = StyleManager.getStyleDeclaration("WorldMapWidget");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration("WorldMapWidget",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.borderMask = "center";
               this.borderSkin = BitmapBorderSkin;
               this.borderCenterImage = _embed_css_images_BG_BohemianTileable_Game_png_1148175408;
            };
         }
         style = StyleManager.getStyleDeclaration(".selectOutfitPrev");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".selectOutfitPrev",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.defaultDisabledRightImage = _embed_css_images_Arrow_ScrollTabs_disabled_png_744892220;
               this.defaultUpMask = "left";
               this.skin = BitmapButtonSkin;
               this.defaultOverLeftImage = "right";
               this.defaultDisabledMask = "left";
               this.defaultDisabledLeftImage = "right";
               this.defaultDownMask = "left";
               this.defaultUpRightImage = _embed_css_images_Arrow_ScrollTabs_idle_png_1793155108;
               this.defaultDownRightImage = _embed_css_images_Arrow_ScrollTabs_pressed_png_169219784;
               this.defaultDownLeftImage = "right";
               this.defaultOverRightImage = _embed_css_images_Arrow_ScrollTabs_over_png_1462627108;
               this.defaultUpLeftImage = "right";
               this.defaultOverMask = "left";
            };
         }
         style = StyleManager.getStyleDeclaration(".nameFilterEditorList");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".nameFilterEditorList",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.horizontalGridLineColor = 8089164;
               this.backgroundColor = "";
               this.borderColor = 8089164;
               this.selectionDuration = 0;
               this.alternatingItemColors = [1977654,16711680];
               this.color = 13221291;
               this.selectionColor = 658961;
               this.backgroundAlpha = 0.8;
               this.borderAlpha = 1;
               this.selectionEasingFunction = "";
               this.headerSeparatorSkin = VectorDataGridHeaderSeparatorSkin;
               this.headerBackgroundSkin = VectorDataGridHeaderBackgroundSkin;
               this.borderThickness = 1;
               this.alternatingItemAlphas = [0.8,0];
               this.rollOverColor = 2768716;
               this.verticalGridLines = true;
               this.verticalGridLineColor = 8089164;
               this.iconColor = 13221291;
               this.textSelectedColor = 13221291;
               this.textRollOverColor = 13221291;
               this.horizontalGridLines = false;
               this.borderStyle = "solid";
               this.disabledIconColor = 13221291;
            };
         }
         style = StyleManager.getStyleDeclaration(".itemBorder");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".itemBorder",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.borderThickness = 1;
               this.borderColor = 7630671;
               this.borderAlpha = 1;
               this.borderStyle = "solid";
            };
         }
         style = StyleManager.getStyleDeclaration(".spellListWidgetViewToggle");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".spellListWidgetViewToggle",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.defaultUpMask = "center";
               this.selectedDownMask = "center";
               this.skin = BitmapButtonSkin;
               this.defaultDownMask = "center";
               this.selectedUpMask = "center";
               this.defaultUpCenterImage = _embed_css_images_Icons_TradeLists_ContainerDisplay_idle_png_851212863;
               this.selectedOverCenterImage = _embed_css_images_Icons_TradeLists_ListDisplay_over_png_417076086;
               this.defaultOverCenterImage = _embed_css_images_Icons_TradeLists_ContainerDisplay_over_png_1199957823;
               this.selectedOverMask = "center";
               this.defaultDownCenterImage = _embed_css_images_Icons_TradeLists_ContainerDisplay_pressed_png_817941011;
               this.selectedDownCenterImage = _embed_css_images_Icons_TradeLists_ListDisplay_pressed_png_1846304974;
               this.defaultOverMask = "center";
               this.selectedUpCenterImage = _embed_css_images_Icons_TradeLists_ListDisplay_idle_png_1140494966;
            };
         }
         style = StyleManager.getStyleDeclaration(".chatWidgetView");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".chatWidgetView",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.dividerThickness = 5;
               this.horizontalGap = 5;
               this.dividerBackgroundMask = "left";
               this.dividerBackgroundLeftImage = _embed_css_images_Border02_WidgetSidebar_slim_png_828323829;
               this.dividerAffordance = 5;
               this.verticalGap = 0;
            };
         }
         style = StyleManager.getStyleDeclaration(".marketWidgetRootContainer");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".marketWidgetRootContainer",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.borderThickness = 1;
               this.backgroundColor = 2240055;
               this.borderColor = 13415802;
               this.paddingBottom = 1;
               this.paddingRight = 1;
               this.backgroundAlpha = 0.5;
               this.borderAlpha = 1;
               this.paddingTop = 1;
               this.borderStyle = "solid";
               this.paddingLeft = 1;
            };
         }
         style = StyleManager.getStyleDeclaration(".chatWidgetTextField");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".chatWidgetTextField",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.borderThickness = 1;
               this.borderColor = 0;
               this.backgroundColor = 0;
               this.backgroundAlpha = 0.33;
               this.borderStyle = "solid";
            };
         }
         style = StyleManager.getStyleDeclaration(".statusWidgetFatHitpoints");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".statusWidgetFatHitpoints",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.barRedLow = _embed_css_images_BarsHealth_fat_RedLow_png_1029541970;
               this.barImages = ["barRedLow2","barRedLow","barRedFull","barYellow","barGreenLow","barGreenFull"];
               this.backgroundRightImage = _embed_css_images_BG_Bars_fat_enpiece_png_254994756;
               this.barRedFull = _embed_css_images_BarsHealth_fat_RedFull_png_1188262271;
               this.barGreenFull = _embed_css_images_BarsHealth_fat_GreenFull_png_1675173631;
               this.paddingRight = 3;
               this.backgroundMask = "center";
               this.leftOrnamentMask = "none";
               this.barYellow = _embed_css_images_BarsHealth_fat_Yellow_png_1332323165;
               this.barGreenLow = _embed_css_images_BarsHealth_fat_GreenLow_png_425933188;
               this.rightOrnamentMask = "right";
               this.backgroundCenterImage = _embed_css_images_BG_Bars_fat_tileable_png_1851975525;
               this.rightOrnamentRightImage = _embed_css_images_BG_Bars_fat_enpieceOrnamented_png_805098349;
               this.backgroundLeftImage = "right";
               this.leftOrnamentLeftImage = "right";
               this.paddingBottom = 3;
               this.barRedLow2 = _embed_css_images_BarsHealth_fat_RedLow2_png_1983741974;
               this.leftOrnamentOffset = -6;
               this.rightOrnamentOffset = 6;
               this.paddingTop = 1;
               this.leftOrnamentRightImage = _embed_css_images_BG_Bars_fat_enpieceOrnamented_png_805098349;
               this.paddingLeft = 1;
               this.barLimits = [0,0.04,0.1,0.3,0.6,0.95];
            };
         }
         style = StyleManager.getStyleDeclaration(".chatWidgetTabBarScrollLeftHighlight");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".chatWidgetTabBarScrollLeftHighlight",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.defaultDisabledRightImage = _embed_css_images_Arrow_ScrollTabsHighlighted_idle_png_802144823;
               this.defaultUpMask = "left";
               this.skin = BitmapButtonSkin;
               this.defaultOverLeftImage = "right";
               this.defaultDisabledMask = "left";
               this.defaultDisabledLeftImage = "right";
               this.defaultDownMask = "left";
               this.defaultUpRightImage = _embed_css_images_Arrow_ScrollTabsHighlighted_idle_png_802144823;
               this.defaultDownRightImage = _embed_css_images_Arrow_ScrollTabsHighlighted_pressed_png_1019332597;
               this.defaultDownLeftImage = "right";
               this.defaultOverRightImage = _embed_css_images_Arrow_ScrollTabsHighlighted_over_png_475447497;
               this.defaultUpLeftImage = "right";
               this.defaultOverMask = "left";
            };
         }
         style = StyleManager.getStyleDeclaration(".miniMapButtonUp");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".miniMapButtonUp",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.defaultDownTopImage = _embed_css_images_Arrow_Minimap_LevelUpDown_pressed_png_1728357286;
               this.defaultUpBottomImage = "top";
               this.defaultUpTopImage = _embed_css_images_Arrow_Minimap_LevelUpDown_idle_png_332004998;
               this.defaultUpMask = "top";
               this.skin = BitmapButtonSkin;
               this.defaultOverTopImage = _embed_css_images_Arrow_Minimap_LevelUpDown_over_png_536705658;
               this.defaultOverBottomImage = "top";
               this.defaultDownMask = "top";
               this.defaultDownBottomImage = "top";
               this.defaultOverMask = "top";
            };
         }
         style = StyleManager.getStyleDeclaration(".npcTradeModeTabBar");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".npcTradeModeTabBar",style,false);
         }
         style = StyleManager.getStyleDeclaration(".bodySlotFingerBlessed");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".bodySlotFingerBlessed",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.emptyBackgroundImage = _embed_css_images_Slot_InventoryRing_protected_png_613777710;
               this.backgroundImage = _embed_css_images_slot_Hotkey_protected_png_1201653772;
            };
         }
         style = StyleManager.getStyleDeclaration(".spellListWidgetTabBar");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".spellListWidgetTabBar",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.tabHeight = 23;
               this.tabStyleName = "spellListWidgetTab";
               this.tabWidth = 40;
            };
         }
         style = StyleManager.getStyleDeclaration(".bodySlotLeftHandBlessed");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".bodySlotLeftHandBlessed",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.emptyBackgroundImage = _embed_css_images_Slot_InventoryWeapon_protected_png_1818101578;
               this.backgroundImage = _embed_css_images_slot_Hotkey_protected_png_1201653772;
            };
         }
         style = StyleManager.getStyleDeclaration("SpellTileRenderer");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration("SpellTileRenderer",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.verticalAlign = "middle";
               this.horizontalGap = 0;
               this.verticalGap = 0;
            };
         }
         style = StyleManager.getStyleDeclaration(".statusWidgetIcons");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".statusWidgetIcons",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.iconProgressOff = _embed_css_images_Icons_ProgressBars_ProgressOff_png_1580407517;
               this.iconStatePoisoned = _embed_css_images_Icons_Conditions_Poisoned_png_1674352817;
               this.iconSkillFightAxe = _embed_css_images_Icons_ProgressBars_AxeFighting_png_854207195;
               this.iconStateDrowning = _embed_css_images_Icons_Conditions_Drowning_png_142081554;
               this.iconStateElectrified = _embed_css_images_Icons_Conditions_Electrified_png_1043769654;
               this.iconStateStrengthened = _embed_css_images_Icons_Conditions_Strenghtened_png_957751449;
               this.iconSkillFightDistance = _embed_css_images_Icons_ProgressBars_DistanceFighting_png_1306281466;
               this.iconStateBleeding = _embed_css_images_Icons_Conditions_Bleeding_png_325607052;
               this.iconStateFast = _embed_css_images_Icons_Conditions_Haste_png_46815841;
               this.iconSkillFightClub = _embed_css_images_Icons_ProgressBars_ClubFighting_png_1530352971;
               this.iconStatePZEntered = _embed_css_images_Icons_Conditions_PZ_png_1659726190;
               this.iconStateCursed = _embed_css_images_Icons_Conditions_Cursed_png_226830886;
               this.iconStateDrunk = _embed_css_images_Icons_Conditions_Drunk_png_495340422;
               this.iconSkillFightShield = _embed_css_images_Icons_ProgressBars_Shielding_png_1404202048;
               this.iconStateDazzled = _embed_css_images_Icons_Conditions_Dazzled_png_1336617984;
               this.iconSkillFightSword = _embed_css_images_Icons_ProgressBars_SwordFighting_png_388408934;
               this.iconStyleParallel = _embed_css_images_Icons_ProgressBars_ParallelStyle_png_564397355;
               this.iconSkillFightFist = _embed_css_images_Icons_ProgressBars_FistFighting_png_946464807;
               this.iconStyleCompact = _embed_css_images_Icons_ProgressBars_CompactStyle_png_2100207391;
               this.iconStyleLarge = _embed_css_images_Icons_ProgressBars_LargeStyle_png_1014712263;
               this.iconStateHungry = _embed_css_images_Icons_Conditions_Hungry_png_1160557067;
               this.iconProgressOn = _embed_css_images_Icons_ProgressBars_ProgressOn_png_1171186177;
               this.iconSkillMagLevel = _embed_css_images_Icons_ProgressBars_MagicLevel_png_1025231274;
               this.iconSkillFishing = _embed_css_images_Icons_ProgressBars_Fishing_png_368980363;
               this.iconStateFighting = _embed_css_images_Icons_Conditions_Logoutblock_png_626674025;
               this.iconStateFreezing = _embed_css_images_Icons_Conditions_Freezing_png_1581087256;
               this.iconStatePZBlock = _embed_css_images_Icons_Conditions_PZlock_png_2031018067;
               this.iconSkillLevel = _embed_css_images_Icons_ProgressBars_ProgressOn_png_1171186177;
               this.iconStateBurning = _embed_css_images_Icons_Conditions_Burning_png_1552261945;
               this.iconStateManaShield = _embed_css_images_Icons_Conditions_MagicShield_png_246939656;
               this.iconStyleDefault = _embed_css_images_Icons_ProgressBars_DefaultStyle_png_1681795459;
               this.iconStateSlow = _embed_css_images_Icons_Conditions_Slowed_png_479759276;
            };
         }
         style = StyleManager.getStyleDeclaration("PreySidebarView");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration("PreySidebarView",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.horizontalGap = 0;
               this.paddingBottom = 0;
               this.iconImage = _embed_css_images_Icons_WidgetHeaders_Prey_png_1844002948;
               this.color = 16777215;
               this.paddingRight = 0;
               this.paddingTop = 0;
               this.verticalGap = 0;
               this.paddingLeft = 0;
            };
         }
         style = StyleManager.getStyleDeclaration(".embeddedDialogContentBox");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".embeddedDialogContentBox",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.verticalAlign = "middle";
               this.paddingBottom = 2;
               this.horizontalAlign = "left";
               this.paddingRight = 2;
               this.paddingTop = 2;
               this.paddingLeft = 2;
            };
         }
         style = StyleManager.getStyleDeclaration("ItemInformationPane");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration("ItemInformationPane",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.backgroundColor = 658961;
               this.paddingBottom = 4;
               this.paddingRight = 4;
               this.backgroundAlpha = 0.5;
               this.paddingTop = 4;
               this.paddingLeft = 4;
            };
         }
         style = StyleManager.getStyleDeclaration(".miniMapButtonDown");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".miniMapButtonDown",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.defaultDownTopImage = _embed_css_images_Arrow_Minimap_LevelUpDown_pressed_png_1728357286;
               this.defaultUpBottomImage = "top";
               this.defaultUpTopImage = _embed_css_images_Arrow_Minimap_LevelUpDown_idle_png_332004998;
               this.defaultUpMask = "bottom";
               this.skin = BitmapButtonSkin;
               this.defaultOverTopImage = _embed_css_images_Arrow_Minimap_LevelUpDown_over_png_536705658;
               this.defaultOverBottomImage = "top";
               this.defaultDownMask = "bottom";
               this.defaultDownBottomImage = "top";
               this.defaultOverMask = "bottom";
            };
         }
         style = StyleManager.getStyleDeclaration(".battlelistWidgetView");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".battlelistWidgetView",style,false);
         }
         style = StyleManager.getStyleDeclaration(".ingameShopOfferList");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".ingameShopOfferList",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.backgroundColor = "";
               this.selectionDuration = 0;
               this.alternatingItemColors = [1842980,1842980];
               this.color = 13221291;
               this.selectionColor = 4936794;
               this.paddingRight = 2;
               this.backgroundAlpha = 0.8;
               this.selectionEasingFunction = "";
               this.borderSkin = EmptySkin;
               this.rollOverColor = 2633265;
               this.paddingBottom = 2;
               this.focusThickness = 0;
               this.textSelectedColor = 13221291;
               this.textRollOverColor = 13221291;
               this.paddingTop = 2;
               this.paddingLeft = 2;
            };
         }
         style = StyleManager.getStyleDeclaration("SideBarWidget");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration("SideBarWidget",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.borderBackgroundColor = 0;
               this.horizontalGap = 0;
               this.paddingBottom = 0;
               this.resizeCursorSkin = ResizeVerticalCursor;
               this.borderRightImage = _embed_css_images_Border02_WidgetSidebar_slim_png_828323829;
               this.paddingRight = 2;
               this.borderBackgroundAlpha = 0;
               this.borderMask = "none";
               this.paddingTop = 0;
               this.borderSkin = BitmapBorderSkin;
               this.verticalGap = 1;
               this.paddingLeft = 2;
            };
         }
         style = StyleManager.getStyleDeclaration(".marketWidgetAmountDecrease");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".marketWidgetAmountDecrease",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.defaultDisabledRightImage = _embed_css_images_Arrow_ScrollTabs_disabled_png_744892220;
               this.defaultUpMask = "left";
               this.skin = BitmapButtonSkin;
               this.defaultOverLeftImage = "right";
               this.defaultDisabledMask = "left";
               this.defaultDisabledLeftImage = "right";
               this.defaultDownMask = "left";
               this.defaultUpRightImage = _embed_css_images_Arrow_ScrollTabs_idle_png_1793155108;
               this.defaultDownRightImage = _embed_css_images_Arrow_ScrollTabs_pressed_png_169219784;
               this.defaultDownLeftImage = "right";
               this.defaultOverRightImage = _embed_css_images_Arrow_ScrollTabs_over_png_1462627108;
               this.defaultUpLeftImage = "right";
               this.defaultOverMask = "left";
            };
         }
         style = StyleManager.getStyleDeclaration(".successRateBox");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".successRateBox",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.horizontalAlign = "right";
            };
         }
         style = StyleManager.getStyleDeclaration(".bodySlotPremium");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".bodySlotPremium",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.defaultUpCenterImage = _embed_css_images_Icons_WidgetMenu_GetPremium_active_png_778187739;
               this.defaultUpMask = "center";
               this.defaultOverCenterImage = _embed_css_images_Icons_WidgetMenu_GetPremium_active_over_png_347021528;
               this.skin = BitmapButtonSkin;
               this.defaultDisabledCenterImage = _embed_css_images_Icons_WidgetMenu_GetPremium_idle_png_1985287859;
               this.defaultDisabledMask = "center";
               this.defaultDownCenterImage = _embed_css_images_Icons_WidgetMenu_GetPremium_active_over_png_347021528;
               this.defaultDownMask = "center";
               this.defaultOverMask = "center";
            };
         }
         style = StyleManager.getStyleDeclaration(".statusWidgetDefault");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".statusWidgetDefault",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.horizontalGap = 1;
               this.hitpointsOffsetX = -2;
               this.manaOffsetY = -1;
               this.manaOffsetX = 2;
               this.stateStyle = "statusWidgetDefault";
               this.skillStyle = "statusWidgetDefaultSkill";
               this.manaStyle = "statusWidgetDefaultMana";
               this.hitpointsStyle = "statusWidgetDefaultHitpoints";
               this.hitpointsOffsetY = -1;
               this.verticalGap = 1;
            };
         }
         style = StyleManager.getStyleDeclaration(".battlelistWidgetViewHideNonSkulled");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".battlelistWidgetViewHideNonSkulled",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.defaultUpMask = "center";
               this.selectedDownMask = "center";
               this.skin = BitmapButtonSkin;
               this.defaultDownMask = "center";
               this.selectedUpMask = "center";
               this.defaultUpCenterImage = _embed_css_images_Icons_BattleList_HideSkulled_idle_png_629388963;
               this.selectedOverCenterImage = _embed_css_images_Icons_BattleList_HideSkulled_active_over_png_660583768;
               this.defaultOverCenterImage = _embed_css_images_Icons_BattleList_HideSkulled_over_png_238536285;
               this.selectedOverMask = "center";
               this.defaultDownCenterImage = _embed_css_images_Icons_BattleList_HideSkulled_over_png_238536285;
               this.selectedDownCenterImage = _embed_css_images_Icons_BattleList_HideSkulled_active_over_png_660583768;
               this.defaultOverMask = "center";
               this.selectedUpCenterImage = _embed_css_images_Icons_BattleList_HideSkulled_active_png_1474407051;
            };
         }
         style = StyleManager.getStyleDeclaration(".bodySlotTorso");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".bodySlotTorso",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.emptyBackgroundImage = _embed_css_images_Slot_InventoryArmor_png_1846126774;
            };
         }
         style = StyleManager.getStyleDeclaration(".statusWidgetParallelZeroSkillProgress");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".statusWidgetParallelZeroSkillProgress",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.tickCenterImage = _embed_css_images_Bars_ProgressMarker_png_1761755336;
               this.backgroundRightImage = "left";
               this.barImages = "barDefault";
               this.tickMask = "center";
               this.paddingRight = -5;
               this.backgroundMask = "left center right";
               this.backgroundCenterImage = _embed_css_images_BG_BarsXP_default_tileable_png_1408337339;
               this.backgroundLeftImage = _embed_css_images_BG_BarsXP_default_endpiece_png_1394078162;
               this.barDefault = _embed_css_images_BarsXP_default_zero_png_841389645;
               this.paddingBottom = 4;
               this.tickOffset = 3;
               this.paddingTop = 3;
               this.paddingLeft = -5;
               this.barLimits = 0;
            };
         }
         style = StyleManager.getStyleDeclaration("OutfitTypeSelector");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration("OutfitTypeSelector",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.verticalAlign = "top";
               this.borderColor = 8089164;
               this.backgroundColor = 2240055;
               this.paddingRight = 2;
               this.borderAlpha = 1;
               this.backgroundAlpha = 0.5;
               this.nameLabelStyle = "selectOutfitLabel";
               this.borderThickness = 1;
               this.paddingBottom = 2;
               this.prevButtonStyle = "selectOutfitPrev";
               this.horizontalAlign = "center";
               this.nextButtonStyle = "selectOutfitNext";
               this.paddingTop = 2;
               this.borderStyle = "solid";
               this.paddingLeft = 2;
            };
         }
         style = StyleManager.getStyleDeclaration("CombatControlWidgetView");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration("CombatControlWidgetView",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.buttonSecureStyle = "combatButtonSecure";
               this.buttonExpertModeStyle = "combatButtonExpert";
               this.buttonWhiteHandStyle = "combatButtonWhiteHand";
               this.buttonDefensiveStyle = "combatButtonDefensive";
               this.iconImage = _embed_css_images_Icons_WidgetHeaders_Combat_png_518010106;
               this.borderCenterMask = "all";
               this.borderFooterMask = "none";
               this.paddingRight = 0;
               this.buttonDoveStyle = "combatButtonDove";
               this.borderCenterCenterImage = _embed_css_images_BG_Combat_ExpertOff_png_1133893050;
               this.buttonRedFistStyle = "combatButtonRedFist";
               this.paddingBottom = 0;
               this.buttonMountStyle = "combatButtonMount";
               this.buttonStopStyle = "combatButtonStop";
               this.paddingTop = 0;
               this.buttonOffensiveStyle = "combatButtonOffensive";
               this.buttonChaseStyle = "combatButtonChase";
               this.buttonBalancedStyle = "combatButtonBalanced";
               this.paddingLeft = 0;
               this.buttonYellowHandStyle = "combatButtonYellowHand";
            };
         }
         style = StyleManager.getStyleDeclaration(".statusWidgetDefaultHitpoints");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".statusWidgetDefaultHitpoints",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.barRedLow = _embed_css_images_BarsHealth_default_RedLow_png_2034053770;
               this.barImages = ["barRedLow2","barRedLow","barRedFull","barYellow","barGreenLow","barGreenFull"];
               this.backgroundRightImage = _embed_css_images_BG_Bars_default_enpiece_png_329250772;
               this.barRedFull = _embed_css_images_BarsHealth_default_RedFull_png_60642647;
               this.barGreenFull = _embed_css_images_BarsHealth_default_GreenFull_png_807562777;
               this.paddingRight = 3;
               this.backgroundMask = "center";
               this.leftOrnamentMask = "none";
               this.barYellow = _embed_css_images_BarsHealth_default_Yellow_png_808052085;
               this.barGreenLow = _embed_css_images_BarsHealth_default_GreenLow_png_1485470108;
               this.rightOrnamentMask = "right";
               this.backgroundCenterImage = _embed_css_images_BG_Bars_default_tileable_png_813666947;
               this.rightOrnamentRightImage = _embed_css_images_BG_Bars_default_enpieceOrnamented_png_1621675861;
               this.backgroundLeftImage = "right";
               this.leftOrnamentLeftImage = "right";
               this.paddingBottom = 3;
               this.barRedLow2 = _embed_css_images_BarsHealth_default_RedLow2_png_1110203394;
               this.leftOrnamentOffset = -5;
               this.rightOrnamentOffset = 5;
               this.paddingTop = 1;
               this.leftOrnamentRightImage = _embed_css_images_BG_Bars_default_enpieceOrnamented_png_1621675861;
               this.paddingLeft = 1;
               this.barLimits = [0,0.04,0.1,0.3,0.6,0.95];
            };
         }
         style = StyleManager.getStyleDeclaration("SeparatorItem");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration("SeparatorItem",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.separatorColor = 8089164;
               this.separatorWidth = 0.9;
               this.separatorAlpha = 1;
               this.separatorHeight = 4;
            };
         }
         style = StyleManager.getStyleDeclaration(".sideBarHeaderBuddylist");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".sideBarHeaderBuddylist",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.defaultUpMask = "center";
               this.selectedDownMask = "center";
               this.skin = BitmapButtonSkin;
               this.defaultDownMask = "center";
               this.selectedUpMask = "center";
               this.defaultUpCenterImage = _embed_css_images_Icons_WidgetMenu_VipList_idle_png_298077813;
               this.selectedOverCenterImage = _embed_css_images_Icons_WidgetMenu_VipList_active_over_png_177527574;
               this.defaultOverCenterImage = _embed_css_images_Icons_WidgetMenu_VipList_idle_over_png_540002728;
               this.selectedOverMask = "center";
               this.defaultDownCenterImage = _embed_css_images_Icons_WidgetMenu_VipList_idle_over_png_540002728;
               this.selectedDownCenterImage = _embed_css_images_Icons_WidgetMenu_VipList_active_over_png_177527574;
               this.defaultOverMask = "center";
               this.selectedUpCenterImage = _embed_css_images_Icons_WidgetMenu_VipList_active_png_781472649;
            };
         }
         style = StyleManager.getStyleDeclaration(".sideBarLeftWithBorder");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".sideBarLeftWithBorder",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.borderBackgroundColor = 0;
               this.horizontalGap = 0;
               this.paddingBottom = 0;
               this.resizeCursorSkin = ResizeVerticalCursor;
               this.borderRightImage = _embed_css_images_Border02_WidgetSidebar_slim_png_828323829;
               this.paddingRight = 2;
               this.borderBackgroundAlpha = 0;
               this.borderMask = "right";
               this.paddingTop = 0;
               this.borderSkin = BitmapBorderSkin;
               this.verticalGap = 1;
               this.paddingLeft = 2;
            };
         }
         style = StyleManager.getStyleDeclaration(".buttonStoreInbox");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".buttonStoreInbox",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.paddingRight = 12;
               this.icon = _embed_css_images_Icons_Inventory_StoreInbox_png_2111006747;
               this.paddingLeft = 12;
            };
         }
         style = StyleManager.getStyleDeclaration("ContainerSlot");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration("ContainerSlot",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.backgroundColor = 16711680;
               this.paddingBottom = 1;
               this.backgroundImage = _embed_css_images_slot_container_png_1830671892;
               this.paddingRight = 1;
               this.backgroundAlpha = 1;
               this.paddingTop = 1;
               this.paddingLeft = 1;
            };
         }
         style = StyleManager.getStyleDeclaration(".battlelist");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".battlelist",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.paddingBottom = 0;
               this.itemBackgroundColors = [2768716,16711680];
               this.itemVerticalGap = 0;
               this.paddingRight = 2;
               this.itemRendererStyle = "battlelistWidgetView";
               this.itemBackgroundAlphas = [0.5,0];
               this.paddingTop = 0;
               this.itemHorizontalGap = 0;
               this.paddingLeft = 0;
            };
         }
         style = StyleManager.getStyleDeclaration(".noBackground");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".noBackground",style,false);
         }
         style = StyleManager.getStyleDeclaration(".sideBarPrey");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".sideBarPrey",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.defaultUpMask = "center";
               this.selectedDownMask = "center";
               this.skin = BitmapButtonSkin;
               this.defaultDownMask = "center";
               this.selectedUpMask = "center";
               this.defaultUpCenterImage = _embed_css_images_Icons_WidgetMenu_Prey_idle_png_1066518890;
               this.selectedOverCenterImage = _embed_css_images_Icons_WidgetMenu_Prey_active_over_png_224076033;
               this.defaultOverCenterImage = _embed_css_images_Icons_WidgetMenu_Prey_idle_over_png_257691859;
               this.selectedOverMask = "center";
               this.defaultDownCenterImage = _embed_css_images_Icons_WidgetMenu_Prey_idle_over_png_257691859;
               this.selectedDownCenterImage = _embed_css_images_Icons_WidgetMenu_Prey_active_over_png_224076033;
               this.defaultOverMask = "center";
               this.selectedUpCenterImage = _embed_css_images_Icons_WidgetMenu_Prey_active_png_1809319364;
            };
         }
         style = StyleManager.getStyleDeclaration(".invisibleDivider");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".invisibleDivider",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.dividerThickness = 0;
               this.horizontalGap = 0;
               this.dividerAffordance = 0;
               this.verticalGap = 0;
            };
         }
         style = StyleManager.getStyleDeclaration(".npcObjectSelector");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".npcObjectSelector",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.alternatingItemColors = [2768716,1977654];
               this.slotVerticalGap = 2;
               this.paddingRight = 0;
               this.selectionColor = "";
               this.backgroundAlpha = 0.5;
               this.infoBorderColor = 8089164;
               this.verticalGap = 0;
               this.slotHorizontalGap = 2;
               this.infoBackgroundColor = 1977654;
               this.slotPaddingRight = 0;
               this.infoBorderThickness = 1;
               this.paddingBottom = 0;
               this.slotPaddingBottom = 0;
               this.paddingTop = 0;
               this.slotHorizontalAlign = "center";
               this.backgroundColor = "";
               this.slotPaddingTop = 0;
               this.infoBorderAlpha = 1;
               this.infoBackgroundAlpha = 0.5;
               this.horizontalGap = 0;
               this.alternatingItemAlphas = [0.5,0.5];
               this.rollOverColor = "";
               this.slotVerticalAlign = "middle";
               this.slotPaddingLeft = 5;
               this.paddingLeft = 0;
               this.infoBorderStyle = "solid";
            };
         }
         style = StyleManager.getStyleDeclaration("PurchaseConfirmationWidget");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration("PurchaseConfirmationWidget",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.buttonYesStyle = "ingameShopYesButton";
               this.buttonCancelStyle = "ingameShopNoButton";
               this.errorColor = 16711680;
               this.informationColor = 4286945;
               this.successColor = 65280;
               this.buttonOkayStyle = "ingameShopYesButton";
               this.buttonNoStyle = "ingameShopNoButton";
               this.minimumButtonWidth = 60;
               this.titleBoxStyle = "popupDialogHeaderFooter";
               this.buttonBoxStyle = "popupDialogHeaderFooter";
            };
         }
         style = StyleManager.getStyleDeclaration(".combatButtonStop");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".combatButtonStop",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.defaultUpCenterImage = _embed_css_images_Button_Combat_Stop_idle_png_1826670103;
               this.defaultUpMask = "center";
               this.defaultOverCenterImage = _embed_css_images_Button_Combat_Stop_over_png_564437783;
               this.skin = BitmapButtonSkin;
               this.defaultDownCenterImage = _embed_css_images_Button_Combat_Stop_pressed_png_1343706347;
               this.defaultDownMask = "center";
               this.defaultOverMask = "center";
            };
         }
         style = StyleManager.getStyleDeclaration(".preyMonsterList");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".preyMonsterList",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.borderColor = 13415802;
               this.backgroundColor = "";
               this.selectionDuration = 0;
               this.alternatingItemColors = [1842980,1842980];
               this.color = 13221291;
               this.selectionColor = 4936794;
               this.paddingRight = 2;
               this.borderAlpha = 1;
               this.backgroundAlpha = 0.8;
               this.selectionEasingFunction = "";
               this.borderThickness = 1;
               this.rollOverColor = 2633265;
               this.paddingBottom = 2;
               this.focusThickness = 0;
               this.textSelectedColor = 13221291;
               this.textRollOverColor = 13221291;
               this.paddingTop = 2;
               this.borderStyle = "solid";
               this.paddingLeft = 2;
            };
         }
         style = StyleManager.getStyleDeclaration(".astralSourceImageWrapper");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".astralSourceImageWrapper",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.verticalAlign = "middle";
               this.horizontalAlign = "center";
            };
         }
         style = StyleManager.getStyleDeclaration(".getCoinsGoldStyle");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".getCoinsGoldStyle",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 16777215;
               this.skin = BitmapButtonSkin;
               this.icon = _embed_css_____assets_images_ingameshop_Icons_IngameShop_12x12_TibiaCoin_png_552533231;
               this.defaultOverBottomRightImage = "bottomLeft";
               this.defaultOverBottomImage = _embed_css_images_custombutton_Button_Gold_tileable_bc_over_png_1310818591;
               this.defaultOverBottomLeftImage = _embed_css_images_custombutton_Button_Gold_tileable_bl_over_png_608410194;
               this.defaultDownBottomImage = _embed_css_images_custombutton_Button_Gold_tileable_bc_pressed_png_504718635;
               this.defaultUpRightImage = "left";
               this.defaultDownTopImage = _embed_css_images_custombutton_Button_Gold_tileable_tc_pressed_png_206403197;
               this.defaultOverTopRightImage = "topLeft";
               this.defaultDownTopLeftImage = _embed_css_images_custombutton_Button_Gold_tileable_tl_pressed_png_169894520;
               this.defaultUpCenterImage = _embed_css_images_custombutton_Button_Gold_tileable_mc_idle_png_313886890;
               this.defaultDownRightImage = "left";
               this.defaultUpBottomImage = _embed_css_images_custombutton_Button_Gold_tileable_bc_idle_png_1121387039;
               this.defaultUpTopImage = _embed_css_images_custombutton_Button_Gold_tileable_tc_idle_png_628673647;
               this.defaultOverTopImage = _embed_css_images_custombutton_Button_Gold_tileable_tc_over_png_960245103;
               this.textSelectedColor = 16777215;
               this.defaultDownCenterImage = _embed_css_images_custombutton_Button_Gold_tileable_mc_pressed_png_1727779818;
               this.defaultUpTopRightImage = "topLeft";
               this.defaultOverMask = "topLeft top topRight left center right bottomLeft bottom bottomRight";
               this.defaultUpMask = "topLeft top topRight left center right bottomLeft bottom bottomRight";
               this.defaultUpBottomLeftImage = _embed_css_images_custombutton_Button_Gold_tileable_bl_idle_png_1140384942;
               this.defaultOverLeftImage = _embed_css_images_custombutton_Button_Gold_tileable_ml_over_png_1035473025;
               this.defaultDownMask = "topLeft top topRight left center right bottomLeft bottom bottomRight";
               this.disabledColor = 16777215;
               this.defaultDownTopRightImage = "topLeft";
               this.defaultUpTopLeftImage = _embed_css_images_custombutton_Button_Gold_tileable_tl_idle_png_1873827252;
               this.defaultUpBottomRightImage = "bottomLeft";
               this.defaultDownBottomLeftImage = _embed_css_images_custombutton_Button_Gold_tileable_bl_pressed_png_1833599894;
               this.defaultDownLeftImage = _embed_css_images_custombutton_Button_Gold_tileable_ml_pressed_png_921560467;
               this.defaultOverRightImage = "left";
               this.defaultOverCenterImage = _embed_css_images_custombutton_Button_Gold_tileable_mc_over_png_662243754;
               this.defaultDownBottomRightImage = "bottomLeft";
               this.textRollOverColor = 16777215;
               this.defaultUpLeftImage = _embed_css_images_custombutton_Button_Gold_tileable_ml_idle_png_1852541313;
               this.defaultOverTopLeftImage = _embed_css_images_custombutton_Button_Gold_tileable_tl_over_png_1141054284;
            };
         }
         style = StyleManager.getStyleDeclaration(".purchaseBonusRerollsButton");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".purchaseBonusRerollsButton",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.icon = _embed_css____images_prey_prey_unlock_permanently_png_1955932179;
            };
         }
         style = StyleManager.getStyleDeclaration(".popUpHeaderStyle");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".popUpHeaderStyle",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.borderThickness = 1;
               this.borderColor = 8089164;
               this.backgroundColor = 658961;
               this.paddingBottom = 2;
               this.paddingRight = 2;
               this.borderAlpha = 1;
               this.backgroundAlpha = 0.5;
               this.paddingTop = 2;
               this.borderStyle = "solid";
               this.paddingLeft = 2;
            };
         }
         style = StyleManager.getStyleDeclaration("ObjectEditor");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration("ObjectEditor",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.errorColor = 13221291;
               this.color = 13221291;
               this.textSelectedColor = 13221291;
               this.textRollOverColor = 13221291;
               this.disabledColor = 13221291;
            };
         }
         style = StyleManager.getStyleDeclaration(".statusWidgetParallelMalusSkillProgress");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".statusWidgetParallelMalusSkillProgress",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.tickCenterImage = _embed_css_images_Bars_ProgressMarker_png_1761755336;
               this.backgroundRightImage = "left";
               this.barImages = "barDefault";
               this.tickMask = "center";
               this.paddingRight = -5;
               this.backgroundMask = "left center right";
               this.backgroundCenterImage = _embed_css_images_BG_BarsXP_default_tileable_png_1408337339;
               this.backgroundLeftImage = _embed_css_images_BG_BarsXP_default_endpiece_png_1394078162;
               this.barDefault = _embed_css_images_BarsXP_default_malus_png_1083584633;
               this.paddingBottom = 4;
               this.tickOffset = 3;
               this.paddingTop = 3;
               this.paddingLeft = -5;
               this.barLimits = 0;
            };
         }
         style = StyleManager.getStyleDeclaration(".marketWidgetAmountIncrease");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".marketWidgetAmountIncrease",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.defaultDisabledRightImage = _embed_css_images_Arrow_ScrollTabs_disabled_png_744892220;
               this.defaultUpMask = "right";
               this.skin = BitmapButtonSkin;
               this.defaultOverLeftImage = "right";
               this.defaultDisabledMask = "right";
               this.defaultDisabledLeftImage = "right";
               this.defaultDownMask = "right";
               this.defaultUpRightImage = _embed_css_images_Arrow_ScrollTabs_idle_png_1793155108;
               this.defaultDownRightImage = _embed_css_images_Arrow_ScrollTabs_pressed_png_169219784;
               this.defaultDownLeftImage = "right";
               this.defaultOverRightImage = _embed_css_images_Arrow_ScrollTabs_over_png_1462627108;
               this.defaultUpLeftImage = "right";
               this.defaultOverMask = "right";
            };
         }
         style = StyleManager.getStyleDeclaration("MarketWidget");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration("MarketWidget",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.errorColor = 16711680;
            };
         }
         style = StyleManager.getStyleDeclaration(".hintBox");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".hintBox",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.borderThickness = 1;
               this.borderColor = 13415802;
               this.paddingBottom = 4;
               this.paddingRight = 4;
               this.borderAlpha = 1;
               this.paddingTop = 4;
               this.borderStyle = "solid";
               this.paddingLeft = 4;
            };
         }
         style = StyleManager.getStyleDeclaration(".statusWidgetDefaultMalusSkillProgress");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".statusWidgetDefaultMalusSkillProgress",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.tickCenterImage = _embed_css_images_Bars_ProgressMarker_png_1761755336;
               this.backgroundRightImage = "left";
               this.barImages = "barDefault";
               this.tickMask = "center";
               this.paddingRight = -5;
               this.backgroundMask = "left center right";
               this.backgroundCenterImage = _embed_css_images_BG_BarsXP_default_tileable_png_1408337339;
               this.backgroundLeftImage = _embed_css_images_BG_BarsXP_default_endpiece_png_1394078162;
               this.barDefault = _embed_css_images_BarsXP_default_malus_png_1083584633;
               this.paddingBottom = 4;
               this.tickOffset = 3;
               this.paddingTop = 3;
               this.paddingLeft = -5;
               this.barLimits = 0;
            };
         }
         style = StyleManager.getStyleDeclaration(".ingameShopOfferRendererBoxEnabled");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".ingameShopOfferRendererBoxEnabled",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.borderThickness = 1;
               this.borderColor = 7630671;
               this.backgroundColor = 1842980;
               this.horizontalAlign = "center";
               this.borderAlpha = 1;
               this.backgroundAlpha = 0.8;
               this.borderSkin = VectorBorderSkin;
               this.borderStyle = "solid";
            };
         }
         style = StyleManager.getStyleDeclaration("GeneralButtonsWidgetView");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration("GeneralButtonsWidgetView",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.iconImage = _embed_css_images_Icons_WidgetHeaders_GeneralControls_png_227481822;
               this.borderFooterMask = "none";
            };
         }
         style = StyleManager.getStyleDeclaration(".statusWidgetFatBonusSkillProgress");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".statusWidgetFatBonusSkillProgress",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.tickCenterImage = _embed_css_images_Bars_ProgressMarker_png_1761755336;
               this.backgroundRightImage = "left";
               this.barImages = "barDefault";
               this.tickMask = "center";
               this.paddingRight = -5;
               this.backgroundMask = "left center right";
               this.backgroundCenterImage = _embed_css_images_BG_BarsXP_default_tileable_png_1408337339;
               this.backgroundLeftImage = _embed_css_images_BG_BarsXP_default_endpiece_png_1394078162;
               this.barDefault = _embed_css_images_BarsXP_default_improved_png_1615848679;
               this.paddingBottom = 4;
               this.tickOffset = 3;
               this.paddingTop = 3;
               this.paddingLeft = -5;
               this.barLimits = 0;
            };
         }
         style = StyleManager.getStyleDeclaration(".combatButtonDefensive");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".combatButtonDefensive",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.defaultUpMask = "center";
               this.selectedDownMask = "center";
               this.skin = BitmapButtonSkin;
               this.defaultDisabledMask = "center";
               this.defaultDownMask = "center";
               this.selectedUpMask = "center";
               this.defaultUpCenterImage = _embed_css_images_Icons_CombatControls_DefensiveOff_idle_png_1794298449;
               this.selectedOverCenterImage = _embed_css_images_Icons_CombatControls_DefensiveOn_active_png_1844746073;
               this.defaultOverCenterImage = _embed_css_images_Icons_CombatControls_DefensiveOff_over_png_88580271;
               this.selectedOverMask = "center";
               this.defaultDownCenterImage = _embed_css_images_Icons_CombatControls_DefensiveOff_over_png_88580271;
               this.selectedDownCenterImage = _embed_css_images_Icons_CombatControls_DefensiveOn_active_png_1844746073;
               this.defaultOverMask = "center";
               this.selectedDisabledMask = "center";
               this.selectedUpCenterImage = _embed_css_images_Icons_CombatControls_DefensiveOn_idle_png_1614728391;
            };
         }
         style = StyleManager.getStyleDeclaration(".astralSourcesArrowBox");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".astralSourcesArrowBox",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.verticalAlign = "middle";
               this.horizontalAlign = "center";
            };
         }
         style = StyleManager.getStyleDeclaration(".customSliderDecreaseButton");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".customSliderDecreaseButton",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.defaultDisabledRightImage = _embed_css_images_Arrow_WidgetToggle_idle_png_550075419;
               this.defaultUpMask = "left";
               this.skin = BitmapButtonSkin;
               this.defaultOverLeftImage = "right";
               this.defaultDisabledMask = "left";
               this.defaultDisabledLeftImage = "right";
               this.defaultDownMask = "left";
               this.defaultUpRightImage = _embed_css_images_Arrow_WidgetToggle_idle_png_550075419;
               this.defaultDownRightImage = _embed_css_images_Arrow_WidgetToggle_pressed_png_806241479;
               this.defaultDownLeftImage = "right";
               this.defaultOverRightImage = _embed_css_images_Arrow_WidgetToggle_over_png_334496997;
               this.defaultUpLeftImage = "right";
               this.defaultOverMask = "left";
            };
         }
         style = StyleManager.getStyleDeclaration("TransactionHistory");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration("TransactionHistory",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.horizontalGridLineColor = 8089164;
               this.backgroundColor = "";
               this.borderColor = 8089164;
               this.selectionDuration = 0;
               this.alternatingItemColors = [1977654,16711680];
               this.color = 13221291;
               this.selectionColor = 658961;
               this.backgroundAlpha = 0.8;
               this.borderAlpha = 1;
               this.selectionEasingFunction = "";
               this.headerSeparatorSkin = VectorDataGridHeaderSeparatorSkin;
               this.headerBackgroundSkin = VectorDataGridHeaderBackgroundSkin;
               this.borderThickness = 1;
               this.alternatingItemAlphas = [0.8,0];
               this.rollOverColor = 2768716;
               this.verticalGridLines = true;
               this.verticalGridLineColor = 8089164;
               this.iconColor = 13221291;
               this.textSelectedColor = 13221291;
               this.textRollOverColor = 13221291;
               this.horizontalGridLines = false;
               this.borderStyle = "solid";
               this.disabledIconColor = 13221291;
            };
         }
         style = StyleManager.getStyleDeclaration("CustomList");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration("CustomList",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.backgroundColor = "";
               this.selectionDuration = 0;
               this.alternatingItemColors = [658961,658961];
               this.color = 13221291;
               this.selectionColor = 4936794;
               this.backgroundAlpha = 0.8;
               this.selectionEasingFunction = "";
               this.borderSkin = EmptySkin;
               this.alternatingItemAlphas = [0.8,0.8];
               this.rollOverColor = 2633265;
               this.focusThickness = 0;
               this.textSelectedColor = 13221291;
               this.textRollOverColor = 13221291;
            };
         }
         style = StyleManager.getStyleDeclaration(".preyRerollListButtonReactivateSmall");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".preyRerollListButtonReactivateSmall",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.paddingRight = 75;
               this.icon = _embed_css____images_prey_prey_list_reroll_small_reactivate_png_1096128443;
               this.disabledIcon = _embed_css____images_prey_prey_list_reroll_small_reactivate_disabled_png_1868832418;
            };
         }
         style = StyleManager.getStyleDeclaration("HotkeyOptions");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration("HotkeyOptions",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.setTextInputStyle = "hotkeyOptionsSetTextInput";
               this.setScrollLeftStyle = "hotkeyOptionsSetScrollLeft";
               this.setScrollRightStyle = "hotkeyOptionsSetScrollRight";
               this.mappingListStyle = "hotkeyOptionsMappingList";
            };
         }
         style = StyleManager.getStyleDeclaration("MouseControlOptions");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration("MouseControlOptions",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.mouseControlOptionsListStyle = "mouseControlOptionsList";
            };
         }
         style = StyleManager.getStyleDeclaration(".sectionBorder");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".sectionBorder",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.borderThickness = 1;
               this.borderColor = 13415802;
               this.borderAlpha = 1;
               this.borderStyle = "solid";
            };
         }
         style = StyleManager.getStyleDeclaration(".bodySlotLeftHand");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".bodySlotLeftHand",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.emptyBackgroundImage = _embed_css_images_Slot_InventoryWeapon_png_1587500415;
            };
         }
         style = StyleManager.getStyleDeclaration(".battlelistWidgetViewHideMonster");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".battlelistWidgetViewHideMonster",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.defaultUpMask = "center";
               this.selectedDownMask = "center";
               this.skin = BitmapButtonSkin;
               this.defaultDownMask = "center";
               this.selectedUpMask = "center";
               this.defaultUpCenterImage = _embed_css_images_Icons_BattleList_HideMonsters_idle_png_1297366744;
               this.selectedOverCenterImage = _embed_css_images_Icons_BattleList_HideMonsters_active_over_png_1041894995;
               this.defaultOverCenterImage = _embed_css_images_Icons_BattleList_HideMonsters_over_png_1720793640;
               this.selectedOverMask = "center";
               this.defaultDownCenterImage = _embed_css_images_Icons_BattleList_HideMonsters_over_png_1720793640;
               this.selectedDownCenterImage = _embed_css_images_Icons_BattleList_HideMonsters_active_over_png_1041894995;
               this.defaultOverMask = "center";
               this.selectedUpCenterImage = _embed_css_images_Icons_BattleList_HideMonsters_active_png_1182126058;
            };
         }
         style = StyleManager.getStyleDeclaration(".spellListWidgetForm");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".spellListWidgetForm",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.errorColor = 16711680;
               this.color = 13221291;
               this.paddingRight = 0;
               this.verticalGap = -2;
               this.disabledColor = 13221291;
               this.indicatorGap = 4;
               this.borderThickness = 0;
               this.horizontalGap = 0;
               this.paddingBottom = 0;
               this.textSelectedColor = 13221291;
               this.textRollOverColor = 13221291;
               this.paddingTop = 0;
               this.borderStyle = "none";
               this.paddingLeft = 0;
            };
         }
         style = StyleManager.getStyleDeclaration(".chatWidgetRightTab");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".chatWidgetRightTab",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.closeButtonTop = 4;
               this.selectedUpLeftImage = _embed_css_images_ChatTab_tileable_EndpieceLeft_png_1323048363;
               this.paddingRight = 4;
               this.skin = BitmapButtonSkin;
               this.selectedDownLeftImage = _embed_css_images_ChatTab_tileable_EndpieceLeft_png_1323048363;
               this.selectedOverLeftImage = _embed_css_images_ChatTab_tileable_EndpieceLeft_png_1323048363;
               this.defaultUpRightImage = _embed_css_images_ChatTab_tileable_EndpieceRound_idle_png_1491157363;
               this.defaultUpCenterImage = _embed_css_images_ChatTab_tileable_idle_png_1025655505;
               this.defaultDownRightImage = _embed_css_images_ChatTab_tileable_EndpieceRound_idle_png_1491157363;
               this.paddingBottom = 0;
               this.selectedTextColor = 15904590;
               this.closeButtonRight = 4;
               this.selectedDownRightImage = _embed_css_images_ChatTab_tileable_EndpieceRound_png_1662843318;
               this.selectedOverMask = "left center right";
               this.defaultDownCenterImage = _embed_css_images_ChatTab_tileable_idle_png_1025655505;
               this.selectedDownCenterImage = _embed_css_images_ChatTab_tileable_png_1152222910;
               this.paddingTop = 0;
               this.defaultOverMask = "left center right";
               this.selectedUpCenterImage = _embed_css_images_ChatTab_tileable_png_1152222910;
               this.defaultUpMask = "left center right";
               this.selectedDownMask = "left center right";
               this.textAlign = "left";
               this.defaultOverLeftImage = _embed_css_images_ChatTab_tileable_EndpieceLeft_idle_png_1369512376;
               this.highlightTextColor = 13120000;
               this.defaultDownMask = "left center right";
               this.selectedUpMask = "left center right";
               this.defaultDownLeftImage = _embed_css_images_ChatTab_tileable_EndpieceLeft_idle_png_1369512376;
               this.defaultOverRightImage = _embed_css_images_ChatTab_tileable_EndpieceRound_idle_png_1491157363;
               this.selectedOverCenterImage = _embed_css_images_ChatTab_tileable_png_1152222910;
               this.defaultOverCenterImage = _embed_css_images_ChatTab_tileable_idle_png_1025655505;
               this.selectedOverRightImage = _embed_css_images_ChatTab_tileable_EndpieceRound_png_1662843318;
               this.selectedUpRightImage = _embed_css_images_ChatTab_tileable_EndpieceRound_png_1662843318;
               this.defaultTextColor = 13221291;
               this.defaultUpLeftImage = _embed_css_images_ChatTab_tileable_EndpieceLeft_idle_png_1369512376;
               this.paddingLeft = 4;
               this.closeButtonStyle = "chatWidgetDefaultTabCloseButton";
            };
         }
         style = StyleManager.getStyleDeclaration("GridContainer");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration("GridContainer",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.horizontalGap = 0;
               this.verticalGap = 0;
            };
         }
         style = StyleManager.getStyleDeclaration(".bodySlotRightHand");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".bodySlotRightHand",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.emptyBackgroundImage = _embed_css_images_Slot_InventoryShield_png_8091800;
            };
         }
         style = StyleManager.getStyleDeclaration(".npcObjectBox");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".npcObjectBox",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.paddingBottom = 2;
               this.paddingRight = 2;
               this.paddingTop = 2;
               this.paddingLeft = 2;
            };
         }
         style = StyleManager.getStyleDeclaration(".actionBarWidgetScrollBottom");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".actionBarWidgetScrollBottom",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.defaultDisabledRightImage = _embed_css_images_Arrow_ScrollHotkeys_disabled_png_326951061;
               this.paddingRight = 0;
               this.skin = BitmapButtonSkin;
               this.defaultOverBottomImage = "right";
               this.defaultDisabledLeftImage = "right";
               this.defaultDisabledTopImage = "right";
               this.defaultDownBottomImage = "right";
               this.defaultUpRightImage = _embed_css_images_Arrow_ScrollHotkeys_idle_png_1989691811;
               this.defaultDownTopImage = "right";
               this.defaultDownRightImage = _embed_css_images_Arrow_ScrollHotkeys_pressed_png_1194517687;
               this.defaultUpBottomImage = "right";
               this.defaultUpTopImage = "right";
               this.paddingBottom = 0;
               this.defaultOverTopImage = "right";
               this.paddingTop = 0;
               this.defaultDisabledBottomImage = "right";
               this.defaultOverMask = "bottom";
               this.defaultUpMask = "bottom";
               this.defaultOverLeftImage = "right";
               this.defaultDisabledMask = "bottom";
               this.defaultDownMask = "bottom";
               this.defaultDownLeftImage = "right";
               this.defaultOverRightImage = _embed_css_images_Arrow_ScrollHotkeys_over_png_191481507;
               this.defaultUpLeftImage = "right";
               this.paddingLeft = 0;
            };
         }
         style = StyleManager.getStyleDeclaration(".actionConfigurationWidgetRootContainer");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".actionConfigurationWidgetRootContainer",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.paddingBottom = 2;
               this.paddingRight = 2;
               this.paddingTop = 2;
               this.paddingLeft = 2;
            };
         }
         style = StyleManager.getStyleDeclaration(".statusWidgetCompact");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".statusWidgetCompact",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.horizontalGap = 1;
               this.hitpointsOffsetX = -2;
               this.manaOffsetY = -1;
               this.manaOffsetX = 2;
               this.stateStyle = "statusWidgetCompact";
               this.skillStyle = "statusWidgetCompactSkill";
               this.manaStyle = "statusWidgetCompactMana";
               this.hitpointsStyle = "statusWidgetCompactHitpoints";
               this.hitpointsOffsetY = -1;
               this.verticalGap = 1;
            };
         }
         style = StyleManager.getStyleDeclaration(".combatButtonExpert");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".combatButtonExpert",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.defaultUpMask = "center";
               this.selectedDownMask = "center";
               this.skin = BitmapButtonSkin;
               this.defaultDisabledMask = "center";
               this.defaultDisabledCenterImage = _embed_css_images_Icons_CombatControls_ExpertMode_disabled_png_1087726802;
               this.defaultDownMask = "center";
               this.selectedUpMask = "center";
               this.defaultUpCenterImage = _embed_css_images_Icons_CombatControls_ExpertMode_idle_png_884394490;
               this.selectedOverCenterImage = _embed_css_images_Icons_CombatControls_ExpertModeOn_over_png_2021716257;
               this.defaultOverCenterImage = _embed_css_images_Icons_CombatControls_ExpertMode_over_png_13719802;
               this.selectedOverMask = "center";
               this.defaultDownCenterImage = _embed_css_images_Icons_CombatControls_ExpertMode_over_png_13719802;
               this.selectedDownCenterImage = _embed_css_images_Icons_CombatControls_ExpertModeOn_over_png_2021716257;
               this.defaultOverMask = "center";
               this.selectedDisabledMask = "center";
               this.selectedUpCenterImage = _embed_css_images_Icons_CombatControls_ExpertModeOn_idle_png_652505055;
            };
         }
         style = StyleManager.getStyleDeclaration(".expandButtonPremiumTriggered");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".expandButtonPremiumTriggered",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.selectedDownMask = "center";
               this.selectedOverCenterImage = _embed_css_images_Button_MaximizePremium_over_png_138300341;
               this.selectedOverMask = "center";
               this.selectedDownCenterImage = _embed_css_images_Button_Maximize_pressed_png_744580322;
               this.selectedUpMask = "center";
               this.selectedUpCenterImage = _embed_css_images_Button_MaximizePremium_idle_png_1870457525;
            };
         }
         style = StyleManager.getStyleDeclaration("EditMarkWidget");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration("EditMarkWidget",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.descriptionStyle = "editMarkDescription";
               this.markSelectorStyle = "editMarkSelector";
            };
         }
         style = StyleManager.getStyleDeclaration(".hotkeyOptionsMappingList");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".hotkeyOptionsMappingList",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.horizontalGridLineColor = 8089164;
               this.backgroundColor = "";
               this.borderColor = 8089164;
               this.selectionDuration = 0;
               this.alternatingItemColors = [1977654,16711680];
               this.color = 13221291;
               this.selectionColor = 658961;
               this.backgroundAlpha = 0.8;
               this.borderAlpha = 1;
               this.selectionEasingFunction = "";
               this.headerSeparatorSkin = VectorDataGridHeaderSeparatorSkin;
               this.headerBackgroundSkin = VectorDataGridHeaderBackgroundSkin;
               this.borderThickness = 1;
               this.alternatingItemAlphas = [0.8,0];
               this.rollOverColor = 2768716;
               this.verticalGridLines = true;
               this.verticalGridLineColor = 8089164;
               this.iconColor = 13221291;
               this.textSelectedColor = 13221291;
               this.textRollOverColor = 13221291;
               this.horizontalGridLines = false;
               this.borderStyle = "solid";
               this.disabledIconColor = 13221291;
            };
         }
         style = StyleManager.getStyleDeclaration(".successRateBelowTwentyPercent");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".successRateBelowTwentyPercent",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 13120000;
               this.textAlign = "right";
            };
         }
         style = StyleManager.getStyleDeclaration(".actionBarWidget");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".actionBarWidget",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.overlayCooldownImage = _embed_css_images_Slot_Hotkey_Cooldown_png_348452255;
               this.overlayHighlightImage = _embed_css_images_slot_Hotkey_highlighted_png_1867388771;
               this.backgroundLabelColor = 14277081;
               this.paddingBottom = 3;
               this.overlayLabelColor = 16777215;
               this.backgroundImage = _embed_css_images_slot_Hotkey_png_542831063;
               this.paddingRight = 3;
               this.overlayDisabledImage = _embed_css_images_slot_Hotkey_disabled_png_669884428;
               this.paddingTop = 3;
               this.paddingLeft = 3;
            };
         }
         style = StyleManager.getStyleDeclaration(".getCoinsStyle");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".getCoinsStyle",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.icon = _embed_css_____assets_images_ingameshop_Icons_IngameShop_12x12_TibiaCoin_png_552533231;
            };
         }
         style = StyleManager.getStyleDeclaration(".ingameShopNoButton");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".ingameShopNoButton",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.paddingBottom = 2;
               this.paddingRight = 8;
               this.icon = _embed_css_images_Icons_IngameShop_12x12_No_png_85749109;
               this.paddingTop = 2;
               this.paddingLeft = 8;
            };
         }
         style = StyleManager.getStyleDeclaration(".successRateHundredPercent");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".successRateHundredPercent",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 4500773;
               this.textAlign = "right";
            };
         }
         style = StyleManager.getStyleDeclaration("Text");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration("Text",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.borderThickness = 1;
               this.borderColor = 0;
               this.backgroundColor = 2240055;
               this.borderAlpha = 1;
               this.backgroundAlpha = 0.5;
               this.borderStyle = "solid";
            };
         }
         style = StyleManager.getStyleDeclaration(".bodySlotBlessing");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".bodySlotBlessing",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.defaultUpCenterImage = _embed_css_images_Icons_WidgetMenu_Blessings_active_png_1623160046;
               this.defaultUpMask = "center";
               this.defaultOverCenterImage = _embed_css_images_Icons_WidgetMenu_Blessings_active_over_png_130321579;
               this.skin = BitmapButtonSkin;
               this.defaultDisabledCenterImage = _embed_css_images_Icons_WidgetMenu_Blessings_idle_png_1665211264;
               this.defaultDisabledMask = "center";
               this.defaultDownCenterImage = _embed_css_images_Icons_WidgetMenu_Blessings_active_over_png_130321579;
               this.defaultDownMask = "center";
               this.defaultOverMask = "center";
            };
         }
         style = StyleManager.getStyleDeclaration(".statusWidgetParallel");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".statusWidgetParallel",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.horizontalGap = 1;
               this.hitpointsOffsetX = 0;
               this.manaOffsetY = 0;
               this.manaOffsetX = 0;
               this.stateStyle = "statusWidgetParallel";
               this.skillStyle = "statusWidgetParallelSkill";
               this.manaStyle = "statusWidgetParallelMana";
               this.hitpointsStyle = "statusWidgetParallelHitpoints";
               this.hitpointsOffsetY = -1;
               this.verticalGap = 1;
            };
         }
         style = StyleManager.getStyleDeclaration("EmbeddedDialog");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration("EmbeddedDialog",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.verticalAlign = "top";
               this.backgroundColor = 658961;
               this.borderColor = 8089164;
               this.buttonStyle = "";
               this.backgroundAlpha = 0.8;
               this.borderAlpha = 1;
               this.buttonBoxStyle = "embeddedDialogButtonBox";
               this.borderThickness = 1;
               this.contentBoxStyle = "embeddedDialogContentBox";
               this.horizontalAlign = "center";
               this.titleBoxStyle = "embeddedDialogTitleBox";
               this.titleStyle = "embeddedDialogTitle";
               this.textStyle = "embeddedDialogText";
               this.borderStyle = "solid";
            };
         }
         style = StyleManager.getStyleDeclaration("NameFilterOptions");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration("NameFilterOptions",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.errorColor = 13221291;
               this.color = 13221291;
               this.whiteListEditorStyle = "nameFilterOptionsBlackListEditor";
               this.textSelectedColor = 13221291;
               this.textRollOverColor = 13221291;
               this.blackListEditorStyle = "nameFilterOptionsWhiteListEditor";
               this.disabledColor = 13221291;
            };
         }
         style = StyleManager.getStyleDeclaration(".protectionCharmButton");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".protectionCharmButton",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.icon = _embed_css_____assets_images_imbuing_imbuing_icon_useprotection_active_png_1327320745;
               this.disabledIcon = _embed_css_____assets_images_imbuing_imbuing_icon_useprotection_disabled_png_1477840035;
            };
         }
         style = StyleManager.getStyleDeclaration(".npcSummaryForm");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".npcSummaryForm",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.borderThickness = 1;
               this.borderColor = 8089164;
               this.backgroundColor = 1977654;
               this.horizontalGap = 4;
               this.paddingBottom = 2;
               this.paddingRight = 2;
               this.borderAlpha = 1;
               this.backgroundAlpha = 0.5;
               this.paddingTop = 2;
               this.borderStyle = "solid";
               this.verticalGap = 1;
               this.paddingLeft = 2;
            };
         }
         style = StyleManager.getStyleDeclaration(".actionBarWidgetToggleBottom");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".actionBarWidgetToggleBottom",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.iconDefaultOverTopImage = "right";
               this.iconDefaultUpMask = "top";
               this.paddingRight = 0;
               this.selectedOverTopImage = "right";
               this.selectedDownLeftImage = "right";
               this.selectedOverLeftImage = "right";
               this.iconDefaultDownMask = "top";
               this.defaultDownTopImage = "right";
               this.borderLeft = 0;
               this.iconDefaultUpRightImage = _embed_css_images_Arrow_ScrollTabs_idle_png_1793155108;
               this.paddingBottom = 0;
               this.iconDefaultOverBottomImage = "right";
               this.iconSelectedDownMask = "bottom";
               this.iconDefaultDownRightImage = _embed_css_images_Arrow_ScrollTabs_pressed_png_169219784;
               this.borderBottom = 0;
               this.iconSelectedUpLeftImage = "right";
               this.iconSelectedDownTopImage = "right";
               this.selectedDownMask = "bottom";
               this.iconSelectedUpMask = "bottom";
               this.iconDefaultDownTopImage = "right";
               this.iconSelectedUpTopImage = "right";
               this.defaultOverLeftImage = "right";
               this.selectedUpTopImage = "right";
               this.iconSelectedDownBottomImage = "right";
               this.iconSelectedOverRightImage = _embed_css_images_Arrow_ScrollTabs_over_png_1462627108;
               this.defaultDownMask = "top";
               this.selectedUpMask = "bottom";
               this.selectedDownBottomImage = "right";
               this.iconSelectedDownRightImage = _embed_css_images_Arrow_ScrollTabs_pressed_png_169219784;
               this.iconDefaultUpTopImage = "right";
               this.defaultDownLeftImage = "right";
               this.defaultOverRightImage = _embed_css_images_Arrow_HotkeyToggle_BG_png_368269210;
               this.borderRight = 0;
               this.selectedOverRightImage = _embed_css_images_Arrow_HotkeyToggle_BG_png_368269210;
               this.iconDefaultUpLeftImage = "right";
               this.selectedUpRightImage = _embed_css_images_Arrow_HotkeyToggle_BG_png_368269210;
               this.iconDefaultOverLeftImage = "right";
               this.defaultUpLeftImage = "right";
               this.paddingLeft = 0;
               this.iconDefaultUpBottomImage = "right";
               this.iconSelectedOverMask = "bottom";
               this.iconSelectedDownLeftImage = "right";
               this.iconSelectedOverLeftImage = "right";
               this.selectedUpLeftImage = "right";
               this.iconSelectedOverTopImage = "right";
               this.skin = BitmapButtonSkin;
               this.icon = BitmapButtonIcon;
               this.defaultOverBottomImage = "right";
               this.borderTop = 0;
               this.defaultDownBottomImage = "right";
               this.defaultUpRightImage = _embed_css_images_Arrow_HotkeyToggle_BG_png_368269210;
               this.defaultDownRightImage = _embed_css_images_Arrow_HotkeyToggle_BG_png_368269210;
               this.defaultUpBottomImage = "right";
               this.defaultUpTopImage = "right";
               this.iconSelectedUpRightImage = _embed_css_images_Arrow_ScrollTabs_idle_png_1793155108;
               this.defaultOverTopImage = "right";
               this.selectedDownRightImage = _embed_css_images_Arrow_HotkeyToggle_BG_png_368269210;
               this.selectedOverMask = "bottom";
               this.iconDefaultDownLeftImage = "right";
               this.iconDefaultOverMask = "top";
               this.paddingTop = 0;
               this.iconSelectedUpBottomImage = "right";
               this.defaultOverMask = "top";
               this.selectedUpBottomImage = "right";
               this.defaultUpMask = "top";
               this.iconSelectedOverBottomImage = "right";
               this.selectedOverBottomImage = "right";
               this.selectedDownTopImage = "right";
               this.iconDefaultDownBottomImage = "right";
               this.iconDefaultOverRightImage = _embed_css_images_Arrow_ScrollTabs_over_png_1462627108;
            };
         }
         style = StyleManager.getStyleDeclaration("TextEditor");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration("TextEditor",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.errorColor = 13221291;
               this.color = 13221291;
               this.textSelectedColor = 13221291;
               this.textRollOverColor = 13221291;
               this.disabledColor = 13221291;
            };
         }
         style = StyleManager.getStyleDeclaration(".ingameShopOfferSale");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".ingameShopOfferSale",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 16232264;
            };
         }
         style = StyleManager.getStyleDeclaration(".embeddedDialogText");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".embeddedDialogText",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.fontWeight = "normal";
            };
         }
         style = StyleManager.getStyleDeclaration(".premiumWidgetGridItem");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".premiumWidgetGridItem",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.verticalAlign = "middle";
            };
         }
         style = StyleManager.getStyleDeclaration(".actionBarLeft");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".actionBarLeft",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.toggleButtonStyle = "actionBarWidgetToggleLeft";
               this.scrollUpButtonStyle = "actionBarWidgetScrollBottom";
               this.scrollDownButtonStyle = "actionBarWidgetScrollTop";
               this.borderMask = "left center";
            };
         }
         style = StyleManager.getStyleDeclaration("SideBarHeader");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration("SideBarHeader",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.verticalAlign = "middle";
               this.buttonGeneralStyle = "sideBarHeaderGeneral";
               this.buttonTradeStyle = "sideBarHeaderTrade";
               this.paddingRight = 0;
               this.buttonMinimapStyle = "sideBarHeaderMinimap";
               this.buttonContainerStyle = "sideBarHeaderContainer";
               this.buttonCombatStyle = "sideBarHeaderCombat";
               this.verticalGap = 2;
               this.borderSkin = BitmapBorderSkin;
               this.borderTopRightImage = _embed_css_images_Border02_corners_png_1465567525;
               this.buttonBuddylistStyle = "sideBarHeaderBuddylist";
               this.horizontalGap = 2;
               this.paddingBottom = 2;
               this.horizontalAlign = "center";
               this.borderRightImage = _embed_css_images_Border02_png_856171138;
               this.buttonBodyStyle = "sideBarHeaderBody";
               this.buttonUnjustPointsStyle = "sideBarUnjustPoints";
               this.borderMask = "left bottomLeft bottom bottomRight right center";
               this.paddingTop = 2;
               this.buttonPreyStyle = "sideBarPrey";
               this.paddingLeft = 0;
               this.buttonBattlelistStyle = "sideBarHeaderBattlelist";
               this.borderCenterImage = _embed_css_images_BG_Widget_Menu_png_779308052;
               this.foldButtonStyleName = "sideBarHeaderFold";
            };
         }
         style = StyleManager.getStyleDeclaration(".marketWidgetOffers");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".marketWidgetOffers",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.horizontalGridLineColor = 8089164;
               this.backgroundColor = "";
               this.borderColor = 8089164;
               this.selectionDuration = 0;
               this.alternatingItemColors = [1977654,16711680];
               this.color = 13221291;
               this.selectionColor = 658961;
               this.backgroundAlpha = 0.8;
               this.borderAlpha = 1;
               this.selectionEasingFunction = "";
               this.headerSeparatorSkin = VectorDataGridHeaderSeparatorSkin;
               this.headerBackgroundSkin = VectorDataGridHeaderBackgroundSkin;
               this.borderThickness = 1;
               this.alternatingItemAlphas = [0.8,0];
               this.rollOverColor = 2768716;
               this.verticalGridLines = true;
               this.verticalGridLineColor = 8089164;
               this.iconColor = 13221291;
               this.textSelectedColor = 13221291;
               this.textRollOverColor = 13221291;
               this.horizontalGridLines = false;
               this.borderStyle = "solid";
               this.disabledIconColor = 13221291;
            };
         }
         style = StyleManager.getStyleDeclaration(".imbuingItemAppearanceRenderer");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".imbuingItemAppearanceRenderer",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.overlayHighlightImage = _embed_css_images_slot_container_highlighted_png_622440584;
               this.paddingBottom = 1;
               this.backgroundImage = _embed_css_images_slot_container_png_1830671892;
               this.paddingRight = 1;
               this.overlayDisabledImage = _embed_css_images_slot_container_disabled_png_2143438719;
               this.paddingTop = 1;
               this.paddingLeft = 1;
            };
         }
         style = StyleManager.getStyleDeclaration("HRule");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration("HRule",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.strokeWidth = 1;
               this.strokeColor = 8089164;
            };
         }
         style = StyleManager.getStyleDeclaration(".actionBarWidgetToggleTop");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".actionBarWidgetToggleTop",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.iconDefaultOverTopImage = "right";
               this.iconDefaultUpMask = "bottom";
               this.paddingRight = 0;
               this.selectedOverTopImage = "right";
               this.selectedDownLeftImage = "right";
               this.selectedOverLeftImage = "right";
               this.iconDefaultDownMask = "bottom";
               this.defaultDownTopImage = "right";
               this.borderLeft = 0;
               this.iconDefaultUpRightImage = _embed_css_images_Arrow_ScrollTabs_idle_png_1793155108;
               this.paddingBottom = 0;
               this.iconDefaultOverBottomImage = "right";
               this.iconSelectedDownMask = "top";
               this.iconDefaultDownRightImage = _embed_css_images_Arrow_ScrollTabs_pressed_png_169219784;
               this.borderBottom = 0;
               this.iconSelectedUpLeftImage = "right";
               this.iconSelectedDownTopImage = "right";
               this.selectedDownMask = "top";
               this.iconSelectedUpMask = "top";
               this.iconDefaultDownTopImage = "right";
               this.iconSelectedUpTopImage = "right";
               this.defaultOverLeftImage = "right";
               this.selectedUpTopImage = "right";
               this.iconSelectedDownBottomImage = "right";
               this.iconSelectedOverRightImage = _embed_css_images_Arrow_ScrollTabs_over_png_1462627108;
               this.defaultDownMask = "bottom";
               this.selectedUpMask = "top";
               this.selectedDownBottomImage = "right";
               this.iconSelectedDownRightImage = _embed_css_images_Arrow_ScrollTabs_pressed_png_169219784;
               this.iconDefaultUpTopImage = "right";
               this.defaultDownLeftImage = "right";
               this.defaultOverRightImage = _embed_css_images_Arrow_HotkeyToggle_BG_png_368269210;
               this.borderRight = 0;
               this.selectedOverRightImage = _embed_css_images_Arrow_HotkeyToggle_BG_png_368269210;
               this.iconDefaultUpLeftImage = "right";
               this.selectedUpRightImage = _embed_css_images_Arrow_HotkeyToggle_BG_png_368269210;
               this.iconDefaultOverLeftImage = "right";
               this.defaultUpLeftImage = "right";
               this.paddingLeft = 0;
               this.iconDefaultUpBottomImage = "right";
               this.iconSelectedOverMask = "top";
               this.iconSelectedDownLeftImage = "right";
               this.iconSelectedOverLeftImage = "right";
               this.selectedUpLeftImage = "right";
               this.iconSelectedOverTopImage = "right";
               this.skin = BitmapButtonSkin;
               this.icon = BitmapButtonIcon;
               this.defaultOverBottomImage = "right";
               this.borderTop = 0;
               this.defaultDownBottomImage = "right";
               this.defaultUpRightImage = _embed_css_images_Arrow_HotkeyToggle_BG_png_368269210;
               this.defaultDownRightImage = _embed_css_images_Arrow_HotkeyToggle_BG_png_368269210;
               this.defaultUpBottomImage = "right";
               this.defaultUpTopImage = "right";
               this.iconSelectedUpRightImage = _embed_css_images_Arrow_ScrollTabs_idle_png_1793155108;
               this.defaultOverTopImage = "right";
               this.selectedDownRightImage = _embed_css_images_Arrow_HotkeyToggle_BG_png_368269210;
               this.selectedOverMask = "top";
               this.iconDefaultDownLeftImage = "right";
               this.iconDefaultOverMask = "bottom";
               this.paddingTop = 0;
               this.iconSelectedUpBottomImage = "right";
               this.defaultOverMask = "bottom";
               this.selectedUpBottomImage = "right";
               this.defaultUpMask = "bottom";
               this.iconSelectedOverBottomImage = "right";
               this.selectedOverBottomImage = "right";
               this.selectedDownTopImage = "right";
               this.iconDefaultDownBottomImage = "right";
               this.iconDefaultOverRightImage = _embed_css_images_Arrow_ScrollTabs_over_png_1462627108;
            };
         }
         style = StyleManager.getStyleDeclaration(".sideBarHeaderFold");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".sideBarHeaderFold",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.iconDefaultOverTopImage = "right";
               this.iconDefaultUpMask = "top";
               this.paddingRight = 0;
               this.selectedOverTopImage = "right";
               this.selectedDownLeftImage = "right";
               this.selectedOverLeftImage = "right";
               this.iconDefaultDownMask = "top";
               this.defaultDownTopImage = "right";
               this.iconDefaultUpRightImage = _embed_css_images_Arrow_WidgetToggle_idle_png_550075419;
               this.paddingBottom = 0;
               this.iconDefaultOverBottomImage = "right";
               this.iconSelectedDownMask = "bottom";
               this.iconDefaultDownRightImage = _embed_css_images_Arrow_WidgetToggle_pressed_png_806241479;
               this.iconSelectedUpLeftImage = "right";
               this.iconSelectedDownTopImage = "right";
               this.selectedDownMask = "bottom";
               this.iconSelectedUpMask = "bottom";
               this.iconDefaultDownTopImage = "right";
               this.iconSelectedUpTopImage = "right";
               this.defaultOverLeftImage = "right";
               this.selectedUpTopImage = "right";
               this.iconSelectedDownBottomImage = "right";
               this.iconSelectedOverRightImage = _embed_css_images_Arrow_WidgetToggle_over_png_334496997;
               this.defaultDownMask = "top";
               this.selectedUpMask = "bottom";
               this.selectedDownBottomImage = "right";
               this.iconSelectedDownRightImage = _embed_css_images_Arrow_WidgetToggle_pressed_png_806241479;
               this.iconDefaultUpTopImage = "right";
               this.defaultDownLeftImage = "right";
               this.defaultOverRightImage = _embed_css_images_Arrow_WidgetToggle_BG_png_2044967256;
               this.selectedOverRightImage = _embed_css_images_Arrow_WidgetToggle_BG_png_2044967256;
               this.iconDefaultUpLeftImage = "right";
               this.selectedUpRightImage = _embed_css_images_Arrow_WidgetToggle_BG_png_2044967256;
               this.iconDefaultOverLeftImage = "right";
               this.defaultUpLeftImage = "right";
               this.paddingLeft = 0;
               this.iconDefaultUpBottomImage = "right";
               this.iconSelectedOverMask = "bottom";
               this.iconSelectedDownLeftImage = "right";
               this.iconSelectedOverLeftImage = "right";
               this.selectedUpLeftImage = "right";
               this.iconSelectedOverTopImage = "right";
               this.skin = BitmapButtonSkin;
               this.icon = BitmapButtonIcon;
               this.defaultOverBottomImage = "right";
               this.defaultDownBottomImage = "right";
               this.defaultUpRightImage = _embed_css_images_Arrow_WidgetToggle_BG_png_2044967256;
               this.defaultDownRightImage = _embed_css_images_Arrow_WidgetToggle_BG_png_2044967256;
               this.defaultUpBottomImage = "right";
               this.defaultUpTopImage = "right";
               this.iconSelectedUpRightImage = _embed_css_images_Arrow_WidgetToggle_idle_png_550075419;
               this.defaultOverTopImage = "right";
               this.selectedDownRightImage = _embed_css_images_Arrow_WidgetToggle_BG_png_2044967256;
               this.selectedOverMask = "bottom";
               this.iconDefaultDownLeftImage = "right";
               this.iconDefaultOverMask = "top";
               this.paddingTop = 0;
               this.iconSelectedUpBottomImage = "right";
               this.defaultOverMask = "top";
               this.selectedUpBottomImage = "right";
               this.defaultUpMask = "top";
               this.iconSelectedOverBottomImage = "right";
               this.selectedOverBottomImage = "right";
               this.selectedDownTopImage = "right";
               this.iconDefaultDownBottomImage = "right";
               this.iconDefaultOverRightImage = _embed_css_images_Arrow_WidgetToggle_over_png_334496997;
            };
         }
         style = StyleManager.getStyleDeclaration(".hovered");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".hovered",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.backgroundColor = 2633265;
            };
         }
         style = StyleManager.getStyleDeclaration(".selectOutfitTabContainer");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".selectOutfitTabContainer",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.verticalAlign = "middle";
               this.horizontalGap = 2;
               this.paddingBottom = 2;
               this.horizontalAlign = "center";
               this.paddingRight = 2;
               this.paddingTop = 2;
               this.verticalGap = 2;
               this.paddingLeft = 2;
            };
         }
         style = StyleManager.getStyleDeclaration(".combatButtonSecure");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".combatButtonSecure",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.defaultUpMask = "center";
               this.selectedDownMask = "center";
               this.skin = BitmapButtonSkin;
               this.defaultDisabledMask = "center";
               this.defaultDownMask = "center";
               this.selectedUpMask = "center";
               this.defaultUpCenterImage = _embed_css_images_Icons_CombatControls_PvPOff_idle_png_1515870738;
               this.selectedOverCenterImage = _embed_css_images_Icons_CombatControls_PvPOn_active_png_342724498;
               this.defaultOverCenterImage = _embed_css_images_Icons_CombatControls_PvPOff_active_png_75654116;
               this.selectedOverMask = "center";
               this.defaultDownCenterImage = _embed_css_images_Icons_CombatControls_PvPOff_active_png_75654116;
               this.selectedDownCenterImage = _embed_css_images_Icons_CombatControls_PvPOn_active_png_342724498;
               this.defaultOverMask = "center";
               this.selectedDisabledMask = "center";
               this.selectedUpCenterImage = _embed_css_images_Icons_CombatControls_PvPOn_idle_png_258280708;
            };
         }
         style = StyleManager.getStyleDeclaration(".statusWidgetCompactHitpoints");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".statusWidgetCompactHitpoints",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.barRedLow = _embed_css_images_BarsHealth_compact_RedLow_png_298615636;
               this.barImages = ["barRedLow2","barRedLow","barRedFull","barYellow","barGreenLow","barGreenFull"];
               this.backgroundRightImage = _embed_css_images_BG_Bars_compact_enpiece_png_1122989386;
               this.barRedFull = _embed_css_images_BarsHealth_compact_RedFull_png_1122893911;
               this.barGreenFull = _embed_css_images_BarsHealth_compact_GreenFull_png_147173125;
               this.paddingRight = 3;
               this.backgroundMask = "center";
               this.leftOrnamentMask = "none";
               this.barYellow = _embed_css_images_BarsHealth_compact_Yellow_png_1489515415;
               this.barGreenLow = _embed_css_images_BarsHealth_compact_GreenLow_png_823416786;
               this.rightOrnamentMask = "right";
               this.backgroundCenterImage = _embed_css_images_BG_Bars_compact_tileable_png_1378708577;
               this.rightOrnamentRightImage = _embed_css_images_BG_Bars_compact_enpieceOrnamented_png_918003981;
               this.backgroundLeftImage = "right";
               this.leftOrnamentLeftImage = "right";
               this.paddingBottom = 3;
               this.barRedLow2 = _embed_css_images_BarsHealth_compact_RedLow2_png_6321508;
               this.leftOrnamentOffset = -6;
               this.rightOrnamentOffset = 6;
               this.paddingTop = 1;
               this.leftOrnamentRightImage = _embed_css_images_BG_Bars_compact_enpieceOrnamented_png_918003981;
               this.paddingLeft = 1;
               this.barLimits = [0,0.04,0.1,0.3,0.6,0.95];
            };
         }
         style = StyleManager.getStyleDeclaration(".bodySlotHead");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".bodySlotHead",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.emptyBackgroundImage = _embed_css_images_Slot_InventoryHead_png_556570291;
            };
         }
         style = StyleManager.getStyleDeclaration(".chatWidgetDefaultTab");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".chatWidgetDefaultTab",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.closeButtonTop = 4;
               this.selectedUpLeftImage = _embed_css_images_ChatTab_tileable_EndpieceLeft_png_1323048363;
               this.paddingRight = 4;
               this.skin = BitmapButtonSkin;
               this.selectedDownLeftImage = _embed_css_images_ChatTab_tileable_EndpieceLeft_png_1323048363;
               this.selectedOverLeftImage = _embed_css_images_ChatTab_tileable_EndpieceLeft_png_1323048363;
               this.defaultUpRightImage = _embed_css_images_ChatTab_tileable_EndpieceRound_idle_png_1491157363;
               this.defaultUpCenterImage = _embed_css_images_ChatTab_tileable_idle_png_1025655505;
               this.defaultDownRightImage = _embed_css_images_ChatTab_tileable_EndpieceRound_idle_png_1491157363;
               this.paddingBottom = 0;
               this.selectedTextColor = 15904590;
               this.closeButtonRight = 4;
               this.selectedDownRightImage = _embed_css_images_ChatTab_tileable_EndpieceRound_png_1662843318;
               this.selectedOverMask = "left center right";
               this.defaultDownCenterImage = _embed_css_images_ChatTab_tileable_idle_png_1025655505;
               this.selectedDownCenterImage = _embed_css_images_ChatTab_tileable_png_1152222910;
               this.paddingTop = 0;
               this.defaultOverMask = "left center right";
               this.selectedUpCenterImage = _embed_css_images_ChatTab_tileable_png_1152222910;
               this.defaultUpMask = "left center right";
               this.selectedDownMask = "left center right";
               this.textAlign = "left";
               this.defaultOverLeftImage = _embed_css_images_ChatTab_tileable_EndpieceLeft_idle_png_1369512376;
               this.highlightTextColor = 13120000;
               this.defaultDownMask = "left center right";
               this.selectedUpMask = "left center right";
               this.defaultDownLeftImage = _embed_css_images_ChatTab_tileable_EndpieceLeft_idle_png_1369512376;
               this.defaultOverRightImage = _embed_css_images_ChatTab_tileable_EndpieceRound_idle_png_1491157363;
               this.selectedOverCenterImage = _embed_css_images_ChatTab_tileable_png_1152222910;
               this.defaultOverCenterImage = _embed_css_images_ChatTab_tileable_idle_png_1025655505;
               this.selectedOverRightImage = _embed_css_images_ChatTab_tileable_EndpieceRound_png_1662843318;
               this.selectedUpRightImage = _embed_css_images_ChatTab_tileable_EndpieceRound_png_1662843318;
               this.defaultTextColor = 13221291;
               this.defaultUpLeftImage = _embed_css_images_ChatTab_tileable_EndpieceLeft_idle_png_1369512376;
               this.paddingLeft = 4;
               this.closeButtonStyle = "chatWidgetDefaultTabCloseButton";
            };
         }
         style = StyleManager.getStyleDeclaration(".sideBarRightWithBorder");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".sideBarRightWithBorder",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.borderBackgroundColor = 0;
               this.horizontalGap = 0;
               this.paddingBottom = 0;
               this.resizeCursorSkin = ResizeVerticalCursor;
               this.borderRightImage = _embed_css_images_Border02_WidgetSidebar_slim_png_828323829;
               this.paddingRight = 2;
               this.borderBackgroundAlpha = 0;
               this.borderMask = "left";
               this.paddingTop = 0;
               this.borderSkin = BitmapBorderSkin;
               this.verticalGap = 1;
               this.paddingLeft = 2;
            };
         }
         style = StyleManager.getStyleDeclaration("PopUpBase");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration("PopUpBase",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.backgroundColor = 658961;
               this.borderColor = 8089164;
               this.errorColor = 13221291;
               this.color = 13221291;
               this.footerStyle = "popUpFooterStyle";
               this.backgroundAlpha = 0.5;
               this.borderAlpha = 1;
               this.disabledColor = 13221291;
               this.borderTop = 33;
               this.iconStyle = null;
               this.cornerRadius = 0;
               this.headerStyle = "popUpHeaderStyle";
               this.borderThickness = 1;
               this.borderLeft = 3;
               this.modalTransparencyColor = 1580578;
               this.modalTransparencyBlur = 0;
               this.borderRight = 3;
               this.modalTransparencyDuration = 0;
               this.modalTransparency = 0.5;
               this.titleStyle = "popUpTitleStyle";
               this.borderStyle = "solid";
               this.borderBottom = 33;
            };
         }
         style = StyleManager.getStyleDeclaration(".marketWidgetAppearanceRenderer");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".marketWidgetAppearanceRenderer",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.overlayHighlightImage = _embed_css_images_slot_container_highlighted_png_622440584;
               this.paddingBottom = 1;
               this.backgroundImage = _embed_css_images_slot_container_png_1830671892;
               this.paddingRight = 1;
               this.overlayDisabledImage = _embed_css_images_slot_container_disabled_png_2143438719;
               this.paddingTop = 1;
               this.paddingLeft = 1;
            };
         }
         style = StyleManager.getStyleDeclaration(".imbuingSlot");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".imbuingSlot",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.defaultUpCenterImage = _embed_css_images_Icons_BattleList_HidePlayers_idle_png_112457565;
               this.selectedOverCenterImage = _embed_css_images_Icons_BattleList_HidePlayers_active_over_png_961154706;
               this.defaultOverCenterImage = _embed_css_images_Icons_BattleList_HidePlayers_over_png_419396003;
               this.icon = _embed_css_____assets_images_imbuing_imbuing_slot_empty_png_1983091155;
               this.defaultDownCenterImage = _embed_css_images_Icons_BattleList_HidePlayers_over_png_419396003;
               this.selectedDownCenterImage = _embed_css_images_Icons_BattleList_HidePlayers_active_over_png_961154706;
               this.selectedUpCenterImage = _embed_css_images_Icons_BattleList_HidePlayers_active_png_1087801247;
            };
         }
         style = StyleManager.getStyleDeclaration(".premiumWidgetButtonBox");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".premiumWidgetButtonBox",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.verticalAlign = "middle";
            };
         }
         style = StyleManager.getStyleDeclaration(".combatButtonRedFist");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".combatButtonRedFist",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.defaultUpMask = "center";
               this.selectedDownMask = "center";
               this.skin = BitmapButtonSkin;
               this.defaultDisabledMask = "center";
               this.defaultDownMask = "center";
               this.selectedUpMask = "center";
               this.defaultUpCenterImage = _embed_css_images_Icons_CombatControls_RedFistOff_idle_png_2005346177;
               this.selectedOverCenterImage = _embed_css_images_Icons_CombatControls_RedFistOn_over_png_273027531;
               this.defaultOverCenterImage = _embed_css_images_Icons_CombatControls_RedFistOff_over_png_1679929985;
               this.selectedOverMask = "center";
               this.defaultDownCenterImage = _embed_css_images_Icons_CombatControls_RedFistOff_over_png_1679929985;
               this.selectedDownCenterImage = _embed_css_images_Icons_CombatControls_RedFistOn_over_png_273027531;
               this.defaultOverMask = "center";
               this.selectedDisabledMask = "center";
               this.selectedUpCenterImage = _embed_css_images_Icons_CombatControls_RedFistOn_idle_png_142442293;
            };
         }
         style = StyleManager.getStyleDeclaration(".preyTitle");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".preyTitle",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.textAlign = "center";
               this.fontWeight = "bold";
            };
         }
         style = StyleManager.getStyleDeclaration(".statusWidgetFatSkillProgress");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".statusWidgetFatSkillProgress",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.tickCenterImage = _embed_css_images_Bars_ProgressMarker_png_1761755336;
               this.backgroundRightImage = "left";
               this.barImages = "barDefault";
               this.tickMask = "center";
               this.paddingRight = -5;
               this.backgroundMask = "left center right";
               this.backgroundCenterImage = _embed_css_images_BG_BarsXP_default_tileable_png_1408337339;
               this.backgroundLeftImage = _embed_css_images_BG_BarsXP_default_endpiece_png_1394078162;
               this.barDefault = _embed_css_images_BarsXP_default__png_385879515;
               this.paddingBottom = 4;
               this.tickOffset = 3;
               this.paddingTop = 3;
               this.paddingLeft = -5;
               this.barLimits = 0;
            };
         }
         style = StyleManager.getStyleDeclaration(".progressBarBox");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".progressBarBox",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.verticalAlign = "middle";
               this.horizontalAlign = "center";
            };
         }
         style = StyleManager.getStyleDeclaration(".itemAndSlotBox");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".itemAndSlotBox",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.verticalAlign = "middle";
               this.paddingLeft = 4;
            };
         }
         style = StyleManager.getStyleDeclaration(".statusWidgetDefaultBonusSkillProgress");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".statusWidgetDefaultBonusSkillProgress",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.tickCenterImage = _embed_css_images_Bars_ProgressMarker_png_1761755336;
               this.backgroundRightImage = "left";
               this.barImages = "barDefault";
               this.tickMask = "center";
               this.paddingRight = -5;
               this.backgroundMask = "left center right";
               this.backgroundCenterImage = _embed_css_images_BG_BarsXP_default_tileable_png_1408337339;
               this.backgroundLeftImage = _embed_css_images_BG_BarsXP_default_endpiece_png_1394078162;
               this.barDefault = _embed_css_images_BarsXP_default_improved_png_1615848679;
               this.paddingBottom = 4;
               this.tickOffset = 3;
               this.paddingTop = 3;
               this.paddingLeft = -5;
               this.barLimits = 0;
            };
         }
         style = StyleManager.getStyleDeclaration(".statusWidgetFatMalusSkillProgress");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".statusWidgetFatMalusSkillProgress",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.tickCenterImage = _embed_css_images_Bars_ProgressMarker_png_1761755336;
               this.backgroundRightImage = "left";
               this.barImages = "barDefault";
               this.tickMask = "center";
               this.paddingRight = -5;
               this.backgroundMask = "left center right";
               this.backgroundCenterImage = _embed_css_images_BG_BarsXP_default_tileable_png_1408337339;
               this.backgroundLeftImage = _embed_css_images_BG_BarsXP_default_endpiece_png_1394078162;
               this.barDefault = _embed_css_images_BarsXP_default_malus_png_1083584633;
               this.paddingBottom = 4;
               this.tickOffset = 3;
               this.paddingTop = 3;
               this.paddingLeft = -5;
               this.barLimits = 0;
            };
         }
         style = StyleManager.getStyleDeclaration(".popupDialogHeaderFooter");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".popupDialogHeaderFooter",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.verticalAlign = "middle";
               this.borderColor = 7630671;
               this.backgroundColor = 658961;
               this.paddingRight = 2;
               this.borderAlpha = 1;
               this.backgroundAlpha = 0.5;
               this.verticalGap = 2;
               this.borderThickness = 1;
               this.horizontalGap = 15;
               this.paddingBottom = 2;
               this.horizontalAlign = "center";
               this.paddingTop = 2;
               this.borderStyle = "solid";
               this.paddingLeft = 2;
            };
         }
         style = StyleManager.getStyleDeclaration(".selected");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".selected",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.backgroundColor = 4936794;
            };
         }
         style = StyleManager.getStyleDeclaration(".bodySlotHeadBlessed");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".bodySlotHeadBlessed",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.emptyBackgroundImage = _embed_css_images_Slot_InventoryHead_protected_png_819760770;
               this.backgroundImage = _embed_css_images_slot_Hotkey_protected_png_1201653772;
            };
         }
         style = StyleManager.getStyleDeclaration(".border");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".border",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.borderThickness = 1;
               this.borderColor = 7630671;
               this.borderAlpha = 1;
               this.borderStyle = "solid";
            };
         }
         style = StyleManager.getStyleDeclaration("CustomSlider");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration("CustomSlider",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.decreaseButtonStyle = "customSliderDecreaseButton";
               this.increaseButtonStyle = "customSliderIncreaseButton";
            };
         }
         style = StyleManager.getStyleDeclaration(".selectOutfitNext");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".selectOutfitNext",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.defaultDisabledRightImage = _embed_css_images_Arrow_ScrollTabs_disabled_png_744892220;
               this.defaultUpMask = "right";
               this.skin = BitmapButtonSkin;
               this.defaultOverLeftImage = "right";
               this.defaultDisabledMask = "right";
               this.defaultDisabledLeftImage = "right";
               this.defaultDownMask = "right";
               this.defaultUpRightImage = _embed_css_images_Arrow_ScrollTabs_idle_png_1793155108;
               this.defaultDownRightImage = _embed_css_images_Arrow_ScrollTabs_pressed_png_169219784;
               this.defaultDownLeftImage = "right";
               this.defaultOverRightImage = _embed_css_images_Arrow_ScrollTabs_over_png_1462627108;
               this.defaultUpLeftImage = "right";
               this.defaultOverMask = "right";
            };
         }
         style = StyleManager.getStyleDeclaration(".chatWidgetButtonOpen");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".chatWidgetButtonOpen",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.defaultUpCenterImage = _embed_css_images_Button_ChatTabNew_idle_png_1330657205;
               this.defaultUpMask = "center";
               this.defaultOverCenterImage = _embed_css_images_Button_ChatTabNew_over_png_67901621;
               this.skin = BitmapButtonSkin;
               this.defaultDownCenterImage = _embed_css_images_Button_ChatTabNew_pressed_png_1051530935;
               this.defaultDownMask = "center";
               this.defaultOverMask = "center";
            };
         }
         style = StyleManager.getStyleDeclaration(".statusWidgetParallelBonusSkillProgress");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".statusWidgetParallelBonusSkillProgress",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.tickCenterImage = _embed_css_images_Bars_ProgressMarker_png_1761755336;
               this.backgroundRightImage = "left";
               this.barImages = "barDefault";
               this.tickMask = "center";
               this.paddingRight = -5;
               this.backgroundMask = "left center right";
               this.backgroundCenterImage = _embed_css_images_BG_BarsXP_default_tileable_png_1408337339;
               this.backgroundLeftImage = _embed_css_images_BG_BarsXP_default_endpiece_png_1394078162;
               this.barDefault = _embed_css_images_BarsXP_default_improved_png_1615848679;
               this.paddingBottom = 4;
               this.tickOffset = 3;
               this.paddingTop = 3;
               this.paddingLeft = -5;
               this.barLimits = 0;
            };
         }
         style = StyleManager.getStyleDeclaration(".sideBarHeaderGeneral");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".sideBarHeaderGeneral",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.defaultUpMask = "center";
               this.selectedDownMask = "center";
               this.skin = BitmapButtonSkin;
               this.defaultDownMask = "center";
               this.selectedUpMask = "center";
               this.defaultUpCenterImage = _embed_css_images_Icons_WidgetMenu_GeneralControls_idle_png_2058421838;
               this.selectedOverCenterImage = _embed_css_images_Icons_WidgetMenu_GeneralControls_active_over_png_239349245;
               this.defaultOverCenterImage = _embed_css_images_Icons_WidgetMenu_GeneralControls_idle_over_png_1722601649;
               this.selectedOverMask = "center";
               this.defaultDownCenterImage = _embed_css_images_Icons_WidgetMenu_GeneralControls_idle_over_png_1722601649;
               this.selectedDownCenterImage = _embed_css_images_Icons_WidgetMenu_GeneralControls_active_over_png_239349245;
               this.defaultOverMask = "center";
               this.selectedUpCenterImage = _embed_css_images_Icons_WidgetMenu_GeneralControls_active_png_611020736;
            };
         }
         style = StyleManager.getStyleDeclaration("WidgetView");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration("WidgetView",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.borderCenterBackgroundColor = 1977654;
               this.headerVerticalAlign = "middle";
               this.paddingRight = 2;
               this.borderFooterBottomImage = _embed_css_images_Widget_Footer_tileable_png_1914256359;
               this.borderSkin = WidgetViewSkin;
               this.titleFontColor = 13221291;
               this.paddingBottom = 2;
               this.titleFontSize = 11;
               this.footerPaddingTop = 0;
               this.footerHorizontalAlign = "left";
               this.iconLeft = 2;
               this.footerPaddingBottom = 0;
               this.borderFooterMask = "bottomLeft bottom bottomRight";
               this.headerWidth = 141;
               this.borderHeaderTop = 22;
               this.headerPaddingBottom = 0;
               this.borderCenterRightImage = _embed_css_images_Border_Widget_png_589090515;
               this.iconTop = 2;
               this.footerVerticalAlign = "top";
               this.borderCenterBackgroundAlpha = 0.5;
               this.paddingLeft = 2;
               this.headerTop = 2;
               this.iconHeight = 19;
               this.borderCenterMask = "all";
               this.borderFooterBottomLeftImage = _embed_css_images_Widget_Footer_tileable_end01_png_300497730;
               this.footerTop = 0;
               this.verticalGap = 2;
               this.headerPaddingRight = 0;
               this.borderFooterBottomRightImage = _embed_css_images_Widget_Footer_tileable_end02_png_302478279;
               this.footerPaddingLeft = 0;
               this.headerPaddingTop = 0;
               this.paddingTop = 2;
               this.borderCenterTopRightImage = _embed_css_images_Border_Widget_corner_png_969648405;
               this.headerHorizontalAlign = "center";
               this.borderHeaderTopImage = _embed_css_images_Widget_HeaderBG_png_1258056819;
               this.borderHeaderMask = "top";
               this.iconWidth = 23;
               this.footerHeight = 10;
               this.titleFontWeight = "normal";
               this.footerPaddingRight = 0;
               this.footerLeft = 0;
               this.collapseButtonStyle = "widgetViewCollapse";
               this.headerLeft = 39;
               this.footerWidth = 184;
               this.horizontalGap = 2;
               this.headerHorizontalGap = 1;
               this.headerPaddingLeft = 0;
               this.headerHeight = 19;
               this.closeButtonStyle = "widgetViewClose";
            };
         }
         style = StyleManager.getStyleDeclaration(".bodySlotFeetBlessed");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".bodySlotFeetBlessed",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.emptyBackgroundImage = _embed_css_images_Slot_InventoryBoots_protected_png_395711413;
               this.backgroundImage = _embed_css_images_slot_Hotkey_protected_png_1201653772;
            };
         }
         style = StyleManager.getStyleDeclaration(".premiumOnlyPremium");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".premiumOnlyPremium",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.icon = _embed_css_images_Icon_Premium_png_157361223;
            };
         }
         style = StyleManager.getStyleDeclaration(".sideBarToggleRight");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".sideBarToggleRight",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.iconDefaultOverTopImage = "right";
               this.iconDefaultUpMask = "left";
               this.paddingRight = 0;
               this.selectedOverTopImage = "right";
               this.selectedDownLeftImage = "right";
               this.selectedOverLeftImage = "right";
               this.iconDefaultDownMask = "left";
               this.defaultDownTopImage = "right";
               this.iconDefaultUpRightImage = _embed_css_images_Arrow_WidgetToggle_idle_png_550075419;
               this.paddingBottom = 0;
               this.iconDefaultOverBottomImage = "right";
               this.iconSelectedDownMask = "right";
               this.iconDefaultDownRightImage = _embed_css_images_Arrow_WidgetToggle_pressed_png_806241479;
               this.iconSelectedUpLeftImage = "right";
               this.iconSelectedDownTopImage = "right";
               this.selectedDownMask = "right";
               this.iconSelectedUpMask = "right";
               this.iconDefaultDownTopImage = "right";
               this.iconSelectedUpTopImage = "right";
               this.defaultOverLeftImage = "right";
               this.selectedUpTopImage = "right";
               this.iconSelectedDownBottomImage = "right";
               this.iconSelectedOverRightImage = _embed_css_images_Arrow_WidgetToggle_over_png_334496997;
               this.defaultDownMask = "left";
               this.selectedUpMask = "right";
               this.selectedDownBottomImage = "right";
               this.iconSelectedDownRightImage = _embed_css_images_Arrow_WidgetToggle_pressed_png_806241479;
               this.iconDefaultUpTopImage = "right";
               this.defaultDownLeftImage = "right";
               this.defaultOverRightImage = _embed_css_images_Arrow_WidgetToggle_BG_png_2044967256;
               this.selectedOverRightImage = _embed_css_images_Arrow_WidgetToggle_BG_png_2044967256;
               this.iconDefaultUpLeftImage = "right";
               this.selectedUpRightImage = _embed_css_images_Arrow_WidgetToggle_BG_png_2044967256;
               this.iconDefaultOverLeftImage = "right";
               this.defaultUpLeftImage = "right";
               this.paddingLeft = 0;
               this.iconDefaultUpBottomImage = "right";
               this.iconSelectedOverMask = "right";
               this.iconSelectedDownLeftImage = "right";
               this.iconSelectedOverLeftImage = "right";
               this.selectedUpLeftImage = "right";
               this.iconSelectedOverTopImage = "right";
               this.skin = BitmapButtonSkin;
               this.icon = BitmapButtonIcon;
               this.defaultOverBottomImage = "right";
               this.defaultDownBottomImage = "right";
               this.defaultUpRightImage = _embed_css_images_Arrow_WidgetToggle_BG_png_2044967256;
               this.toggleButtonStyle = "sideBarToggleRight";
               this.defaultDownRightImage = _embed_css_images_Arrow_WidgetToggle_BG_png_2044967256;
               this.defaultUpBottomImage = "right";
               this.defaultUpTopImage = "right";
               this.iconSelectedUpRightImage = _embed_css_images_Arrow_WidgetToggle_idle_png_550075419;
               this.defaultOverTopImage = "right";
               this.selectedDownRightImage = _embed_css_images_Arrow_WidgetToggle_BG_png_2044967256;
               this.selectedOverMask = "right";
               this.iconDefaultDownLeftImage = "right";
               this.iconDefaultOverMask = "left";
               this.paddingTop = 0;
               this.iconSelectedUpBottomImage = "right";
               this.defaultOverMask = "left";
               this.selectedUpBottomImage = "right";
               this.defaultUpMask = "left";
               this.iconSelectedOverBottomImage = "right";
               this.selectedOverBottomImage = "right";
               this.selectedDownTopImage = "right";
               this.borderMask = "left";
               this.iconDefaultDownBottomImage = "right";
               this.iconDefaultOverRightImage = _embed_css_images_Arrow_WidgetToggle_over_png_334496997;
            };
         }
         style = StyleManager.getStyleDeclaration("UnjustPointsWidgetView");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration("UnjustPointsWidgetView",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.horizontalGap = 0;
               this.paddingBottom = 0;
               this.iconImage = _embed_css_images_Icons_WidgetHeaders_Skull_png_980830817;
               this.color = 16777215;
               this.borderCenterMask = "all";
               this.paddingRight = 0;
               this.borderFooterMask = "none";
               this.borderCenterCenterImage = _embed_css_images_UnjustifiedPoints_png_1971471823;
               this.paddingTop = 0;
               this.verticalGap = 0;
               this.paddingLeft = 0;
            };
         }
         style = StyleManager.getStyleDeclaration(".statusWidgetFat");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".statusWidgetFat",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.horizontalGap = 1;
               this.hitpointsOffsetX = -2;
               this.manaOffsetY = -1;
               this.manaOffsetX = 2;
               this.stateStyle = "statusWidgetFat";
               this.skillStyle = "statusWidgetFatSkill";
               this.manaStyle = "statusWidgetFatMana";
               this.hitpointsStyle = "statusWidgetFatHitpoints";
               this.hitpointsOffsetY = -1;
               this.verticalGap = 1;
            };
         }
         style = StyleManager.getStyleDeclaration("NPCTradeWidgetView");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration("NPCTradeWidgetView",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.amountBoxStyle = "npcAmountBox";
               this.errorColor = 16711680;
               this.iconImage = _embed_css_images_Icons_WidgetHeaders_Trades_png_107866521;
               this.color = 13221291;
               this.paddingRight = 0;
               this.summaryFormStyle = "npcSummaryForm";
               this.tradeModeTabStyle = "npcTradeModeTab";
               this.disabledColor = 13221291;
               this.objectSelectorStyle = "npcObjectSelector";
               this.tradeModeTabBarStyle = "npcTradeModeTabBar";
               this.tradeModeBoxStyle = "npcTradeModeBox";
               this.summaryBoxStyle = "npcSummaryBox";
               this.paddingBottom = 0;
               this.amountSelectorStyle = "npcAmountSelector";
               this.tradeModeTabHeight = 23;
               this.commitBoxStyle = "npcCommitBox";
               this.objectBoxStyle = "npcObjectBox";
               this.tradeModeTabWidth = 40;
               this.tradeModeLayoutButtonStyle = "npcTradeButtonLayout";
               this.paddingTop = 0;
               this.paddingLeft = 0;
            };
         }
         style = StyleManager.getStyleDeclaration(".tradeItemListStyle");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".tradeItemListStyle",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.horizontalGap = 2;
               this.paddingBottom = 2;
               this.paddingRight = 3;
               this.paddingTop = 2;
               this.verticalGap = 2;
               this.paddingLeft = 3;
            };
         }
         style = StyleManager.getStyleDeclaration("BodySlot");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration("BodySlot",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.backgroundColor = 65280;
               this.emptyBackgroundColor = 16711680;
               this.backgroundImage = _embed_css_images_slot_Hotkey_png_542831063;
               this.paddingRight = 3;
               this.backgroundAlpha = 1;
               this.backgroundOverAlpha = 1;
               this.emptyBackgroundAlpha = 1;
               this.backgroundOutAlpha = 1;
               this.paddingBottom = 3;
               this.emptyBackgroundOutAlpha = 1;
               this.emptyBackgroundOverAlpha = 1;
               this.paddingTop = 3;
               this.paddingLeft = 3;
            };
         }
         style = StyleManager.getStyleDeclaration(".spellListWidgetTabBarBackground");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".spellListWidgetTabBarBackground",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.verticalAlign = "middle";
               this.paddingBottom = 0;
               this.horizontalAlign = "left";
               this.paddingRight = 2;
               this.borderTopImage = _embed_css_images_BG_ChatTab_tileable_png_2031873750;
               this.borderMask = "top";
               this.paddingTop = 0;
               this.borderSkin = BitmapBorderSkin;
               this.paddingLeft = 2;
            };
         }
         style = StyleManager.getStyleDeclaration(".statusWidgetSkillProgress");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".statusWidgetSkillProgress",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.fontFamily = "Verdana";
               this.fontSize = 10;
               this.fontStyle = "normal";
               this.fontColor = 16777215;
               this.fontWeight = "bold";
            };
         }
         style = StyleManager.getStyleDeclaration("MainContentPane");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration("MainContentPane",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.paddingTop = 1;
               this.verticalGap = 2;
               this.fontWeight = "bold";
            };
         }
         style = StyleManager.getStyleDeclaration(".chatWidgetRightView");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".chatWidgetRightView",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.borderThickness = 1;
               this.borderColor = 8089164;
               this.borderAlpha = 1;
               this.borderStyle = "solid";
            };
         }
         style = StyleManager.getStyleDeclaration("ShopReponseWidget");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration("ShopReponseWidget",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.buttonYesStyle = "ingameShopYesButton";
               this.buttonCancelStyle = "ingameShopNoButton";
               this.errorColor = 16711680;
               this.informationColor = 4286945;
               this.successColor = 65280;
               this.buttonOkayStyle = "ingameShopYesButton";
               this.buttonNoStyle = "ingameShopNoButton";
               this.minimumButtonWidth = 60;
               this.titleBoxStyle = "popupDialogHeaderFooter";
               this.buttonBoxStyle = "popupDialogHeaderFooter";
            };
         }
         style = StyleManager.getStyleDeclaration(".statusWidgetParallelSkill");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".statusWidgetParallelSkill",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.progressBarMalusStyleName = "statusWidgetParallelMalusSkillProgress";
               this.verticalAlign = "middle";
               this.iconStyleName = "";
               this.progressBarBonusStyleName = "statusWidgetParallelBonusSkillProgress";
               this.progressBarZeroStyleName = "statusWidgetParallelZeroSkillProgress";
               this.horizontalGap = 0;
               this.progressBarStyleName = "statusWidgetParallelSkillProgress";
               this.labelStyleName = ".statusWidgetSkillProgress";
            };
         }
         style = StyleManager.getStyleDeclaration("ScrollBar");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration("ScrollBar",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.thumbSkin = _embed_css_images_Scrollbar_Handler_png_487857897;
               this.backgroundColor = 65280;
               this.upArrowDownSkin = _embed_css_images_Scrollbar_Arrow_up_pressed_png_228522939;
               this.trackSkin = _embed_css_images_Scrollbar_tileable_png_2024027095;
               this.downArrowDownSkin = _embed_css_images_Scrollbar_Arrow_down_pressed_png_2102997480;
               this.upArrowDisabledSkin = _embed_css_images_Scrollbar_Arrow_up_idle_png_48874961;
               this.upArrowUpSkin = _embed_css_images_Scrollbar_Arrow_up_idle_png_48874961;
               this.backgroundAlpha = 0;
               this.downArrowDisabledSkin = _embed_css_images_Scrollbar_Arrow_down_idle_png_500241812;
               this.upArrowOverSkin = _embed_css_images_Scrollbar_Arrow_up_over_png_933050065;
               this.downArrowUpSkin = _embed_css_images_Scrollbar_Arrow_down_idle_png_500241812;
               this.downArrowOverSkin = _embed_css_images_Scrollbar_Arrow_down_over_png_1994681196;
            };
         }
         style = StyleManager.getStyleDeclaration(".statusWidgetCompactZeroSkillProgress");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".statusWidgetCompactZeroSkillProgress",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.tickCenterImage = _embed_css_images_Bars_ProgressMarker_png_1761755336;
               this.backgroundRightImage = "left";
               this.barImages = "barDefault";
               this.tickMask = "center";
               this.paddingRight = -5;
               this.backgroundMask = "left center right";
               this.backgroundCenterImage = _embed_css_images_BG_BarsXP_default_tileable_png_1408337339;
               this.backgroundLeftImage = _embed_css_images_BG_BarsXP_default_endpiece_png_1394078162;
               this.barDefault = _embed_css_images_BarsXP_default_zero_png_841389645;
               this.paddingBottom = 4;
               this.tickOffset = 3;
               this.paddingTop = 3;
               this.paddingLeft = -5;
               this.barLimits = 0;
            };
         }
         style = StyleManager.getStyleDeclaration(".marketWidgetTabNavigator");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".marketWidgetTabNavigator",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.borderThickness = 1;
               this.borderColor = 13415802;
               this.backgroundColor = 658961;
               this.paddingBottom = 1;
               this.paddingRight = 1;
               this.borderAlpha = 1;
               this.backgroundAlpha = 0.5;
               this.tabStyleName = "simpleTabNavigator";
               this.paddingTop = 1;
               this.borderStyle = "solid";
               this.paddingLeft = 1;
            };
         }
         style = StyleManager.getStyleDeclaration(".transferCoinsButton");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".transferCoinsButton",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.icon = _embed_css_____assets_images_ingameshop_Icons_IngameShop_32x14_TransferCoins_png_198242323;
            };
         }
         style = StyleManager.getStyleDeclaration(".embeddedDialogButtonBox");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".embeddedDialogButtonBox",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.backgroundColor = 658961;
               this.horizontalGap = 16;
               this.paddingBottom = 2;
               this.horizontalAlign = "center";
               this.paddingRight = 2;
               this.backgroundAlpha = 0.8;
               this.paddingTop = 2;
               this.paddingLeft = 2;
            };
         }
         style = StyleManager.getStyleDeclaration(".astralSourceLabelAmountMissing");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".astralSourceLabelAmountMissing",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.backgroundColor = 1842980;
               this.color = 13120000;
               this.textAlign = "center";
               this.fontWeight = "bold";
            };
         }
         style = StyleManager.getStyleDeclaration(".sideBarHeaderContainer");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".sideBarHeaderContainer",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.defaultUpMask = "center";
               this.selectedDownMask = "center";
               this.skin = BitmapButtonSkin;
               this.defaultDownMask = "center";
               this.selectedUpMask = "center";
               this.defaultUpCenterImage = _embed_css_images_Icons_WidgetMenu_Containers_idle_png_1947022978;
               this.selectedOverCenterImage = _embed_css_images_Icons_WidgetMenu_Containers_active_over_png_1480923629;
               this.defaultOverCenterImage = _embed_css_images_Icons_WidgetMenu_Containers_idle_over_png_1529638289;
               this.selectedOverMask = "center";
               this.defaultDownCenterImage = _embed_css_images_Icons_WidgetMenu_Containers_idle_over_png_1529638289;
               this.selectedDownCenterImage = _embed_css_images_Icons_WidgetMenu_Containers_active_over_png_1480923629;
               this.defaultOverMask = "center";
               this.selectedUpCenterImage = _embed_css_images_Icons_WidgetMenu_Containers_active_png_309943728;
            };
         }
         style = StyleManager.getStyleDeclaration(".containerPageFooter");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".containerPageFooter",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.borderColor = 8089164;
               this.backgroundColor = 1977654;
               this.errorColor = 16711680;
               this.color = 13221291;
               this.paddingRight = 2;
               this.borderAlpha = 1;
               this.backgroundAlpha = 0.5;
               this.verticalGap = 1;
               this.disabledColor = 13221291;
               this.borderThickness = 1;
               this.horizontalGap = 4;
               this.paddingBottom = 2;
               this.paddingTop = 2;
               this.borderStyle = "solid";
               this.paddingLeft = 2;
            };
         }
         style = StyleManager.getStyleDeclaration("ChatWidget");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration("ChatWidget",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.titleRightTabStyle = "chatWidgetRightTab";
               this.titleBarStyle = "chatWidgetTitle";
               this.titleTabBarStyle = "chatWidgetTabBar";
               this.inputBarTextFieldStyle = "chatWidgetTextField";
               this.inputBarStyle = "chatWidgetInput";
               this.paddingRight = 0;
               this.titleRightHolderStyle = "chatWidgetRightHolder";
               this.titleIgnoreButtonStyle = "chatWidgetButtonIgnore";
               this.borderSkin = BitmapBorderSkin;
               this.borderTopRightImage = _embed_css_images_Border02_corners_png_1465567525;
               this.verticalGap = 0;
               this.viewBarSingleViewStyle = "chatWidgetSingleView";
               this.viewBarStyle = "chatWidgetView";
               this.horizontalGap = 0;
               this.paddingBottom = 0;
               this.titleOpenButtonStyle = "chatWidgetButtonOpen";
               this.viewBarRightViewStyle = "chatWidgetRightView";
               this.borderRightImage = _embed_css_images_Border02_png_856171138;
               this.borderMask = "left bottomLeft bottom bottomRight right center";
               this.paddingTop = 0;
               this.viewBarLeftViewStyle = "chatWidgetLeftView";
               this.paddingLeft = 0;
               this.borderCenterImage = _embed_css_images_BG_BohemianTileable_ChatConsole_png_2063585141;
            };
         }
         style = StyleManager.getStyleDeclaration(".statusWidgetDefaultZeroSkillProgress");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".statusWidgetDefaultZeroSkillProgress",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.tickCenterImage = _embed_css_images_Bars_ProgressMarker_png_1761755336;
               this.backgroundRightImage = "left";
               this.barImages = "barDefault";
               this.tickMask = "center";
               this.paddingRight = -5;
               this.backgroundMask = "left center right";
               this.backgroundCenterImage = _embed_css_images_BG_BarsXP_default_tileable_png_1408337339;
               this.backgroundLeftImage = _embed_css_images_BG_BarsXP_default_endpiece_png_1394078162;
               this.barDefault = _embed_css_images_BarsXP_default_zero_png_841389645;
               this.paddingBottom = 4;
               this.tickOffset = 3;
               this.paddingTop = 3;
               this.paddingLeft = -5;
               this.barLimits = 0;
            };
         }
         style = StyleManager.getStyleDeclaration(".ingameShopHistoryCredits");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".ingameShopHistoryCredits",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.verticalAlign = "middle";
               this.paddingBottom = 0;
               this.horizontalAlign = "right";
               this.paddingRight = 2;
               this.paddingTop = 0;
               this.verticalGap = 0;
               this.borderSkin = EmptySkin;
               this.paddingLeft = 2;
            };
         }
         style = StyleManager.getStyleDeclaration("CoinWidget");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration("CoinWidget",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.verticalAlign = "middle";
               this.horizontalGap = 2;
               this.color = 16232264;
               this.fontWeight = "bold";
            };
         }
         style = StyleManager.getStyleDeclaration(".bodySlotFeet");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".bodySlotFeet",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.emptyBackgroundImage = _embed_css_images_Slot_InventoryBoots_png_1593843512;
            };
         }
         style = StyleManager.getStyleDeclaration(".actionBarTop");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".actionBarTop",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.toggleButtonStyle = "actionBarWidgetToggleTop";
               this.scrollUpButtonStyle = "actionBarWidgetScrollRight";
               this.scrollDownButtonStyle = "actionBarWidgetScrollLeft";
               this.borderMask = "left topLeft top topRight right center";
            };
         }
         style = StyleManager.getStyleDeclaration(".chatWidgetTabBarDropDown");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".chatWidgetTabBarDropDown",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.defaultDisabledRightImage = _embed_css_images_Arrow_ScrollTabs_disabled_png_744892220;
               this.defaultUpMask = "bottom";
               this.defaultDisabledBottom = 11;
               this.defaultDownBottom = 11;
               this.skin = BitmapButtonSkin;
               this.defaultUpBottom = 11;
               this.defaultOverBottomImage = "right";
               this.defaultOverLeftImage = "right";
               this.defaultDisabledMask = "bottom";
               this.defaultDisabledLeftImage = "right";
               this.defaultDownMask = "bottom";
               this.defaultDownBottomImage = "right";
               this.defaultUpRightImage = _embed_css_images_Arrow_ScrollTabs_idle_png_1793155108;
               this.defaultDownRightImage = _embed_css_images_Arrow_ScrollTabs_pressed_png_169219784;
               this.defaultUpBottomImage = "right";
               this.defaultDownLeftImage = "right";
               this.defaultOverRightImage = _embed_css_images_Arrow_ScrollTabs_over_png_1462627108;
               this.defaultOverBottom = 11;
               this.defaultUpLeftImage = "right";
               this.defaultDisabledBottomImage = "right";
               this.defaultOverMask = "bottom";
            };
         }
         style = StyleManager.getStyleDeclaration(".chatWidgetLeftView");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".chatWidgetLeftView",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.borderThickness = 1;
               this.borderColor = 8089164;
               this.borderAlpha = 1;
               this.borderStyle = "solid";
            };
         }
         style = StyleManager.getStyleDeclaration(".bodySlotLegsBlessed");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".bodySlotLegsBlessed",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.emptyBackgroundImage = _embed_css_images_Slot_InventoryLegs_protected_png_785554311;
               this.backgroundImage = _embed_css_images_slot_Hotkey_protected_png_1201653772;
            };
         }
         style = StyleManager.getStyleDeclaration(".combatButtonYellowHand");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".combatButtonYellowHand",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.defaultUpMask = "center";
               this.selectedDownMask = "center";
               this.skin = BitmapButtonSkin;
               this.defaultDisabledMask = "center";
               this.defaultDownMask = "center";
               this.selectedUpMask = "center";
               this.defaultUpCenterImage = _embed_css_images_Icons_CombatControls_YellowHandOff_idle_png_768654451;
               this.selectedOverCenterImage = _embed_css_images_Icons_CombatControls_YellowHandOn_over_png_713246121;
               this.defaultOverCenterImage = _embed_css_images_Icons_CombatControls_YellowHandOff_over_png_511982963;
               this.selectedOverMask = "center";
               this.defaultDownCenterImage = _embed_css_images_Icons_CombatControls_YellowHandOff_over_png_511982963;
               this.selectedDownCenterImage = _embed_css_images_Icons_CombatControls_YellowHandOn_over_png_713246121;
               this.defaultOverMask = "center";
               this.selectedDisabledMask = "center";
               this.selectedUpCenterImage = _embed_css_images_Icons_CombatControls_YellowHandOn_idle_png_572971351;
            };
         }
         style = StyleManager.getStyleDeclaration("NicklistItemRenderer");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration("NicklistItemRenderer",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.subscriberTextColor = 6355040;
               this.pendingTextColor = 16753920;
               this.inviteeTextColor = 16277600;
            };
         }
         style = StyleManager.getStyleDeclaration(".preyUnlockTemporarilyButton");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".preyUnlockTemporarilyButton",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.icon = _embed_css____images_prey_prey_unlock_temporarily_png_1138134336;
            };
         }
         style = StyleManager.getStyleDeclaration(".statusWidgetDefaultSkillProgress");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".statusWidgetDefaultSkillProgress",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.tickCenterImage = _embed_css_images_Bars_ProgressMarker_png_1761755336;
               this.backgroundRightImage = "left";
               this.barImages = "barDefault";
               this.tickMask = "center";
               this.paddingRight = -5;
               this.backgroundMask = "left center right";
               this.backgroundCenterImage = _embed_css_images_BG_BarsXP_default_tileable_png_1408337339;
               this.backgroundLeftImage = _embed_css_images_BG_BarsXP_default_endpiece_png_1394078162;
               this.barDefault = _embed_css_images_BarsXP_default__png_385879515;
               this.paddingBottom = 4;
               this.tickOffset = 3;
               this.paddingTop = 3;
               this.paddingLeft = -5;
               this.barLimits = 0;
            };
         }
         style = StyleManager.getStyleDeclaration(".containerPageLeft");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".containerPageLeft",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.defaultDisabledRightImage = _embed_css_images_Arrow_WidgetToggle_idle_png_550075419;
               this.defaultUpMask = "left";
               this.skin = BitmapButtonSkin;
               this.defaultOverBottomImage = "right";
               this.defaultOverLeftImage = "right";
               this.defaultDisabledMask = "left";
               this.defaultDisabledLeftImage = "right";
               this.defaultDownMask = "left";
               this.defaultDownBottomImage = "right";
               this.defaultUpRightImage = _embed_css_images_Arrow_WidgetToggle_idle_png_550075419;
               this.defaultDownRightImage = _embed_css_images_Arrow_WidgetToggle_pressed_png_806241479;
               this.defaultUpBottomImage = "right";
               this.defaultDownLeftImage = "right";
               this.defaultOverRightImage = _embed_css_images_Arrow_WidgetToggle_over_png_334496997;
               this.defaultUpLeftImage = "right";
               this.defaultDisabledBottomImage = "right";
               this.defaultOverMask = "left";
            };
         }
         style = StyleManager.getStyleDeclaration("CustomButton");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration("CustomButton",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.defaultDisabledRightImage = "left";
               this.defaultDisabledBottomRightImage = "bottomLeft";
               this.paddingRight = 4;
               this.selectedOverTopImage = _embed_css_images_custombutton_Button_Border_tileable_tc_over_png_1913712539;
               this.selectedDisabledBottomImage = _embed_css_images_custombutton_Button_Border_tileable_bc_disabled_png_372459381;
               this.selectedDownLeftImage = _embed_css_images_custombutton_Button_Border_tileable_ml_pressed_png_1348489359;
               this.selectedOverLeftImage = _embed_css_images_custombutton_Button_Border_tileable_ml_over_png_637758037;
               this.defaultOverBottomLeftImage = _embed_css_images_custombutton_Button_Standard_tileable_bl_over_png_1195435017;
               this.defaultDisabledTopImage = _embed_css_images_custombutton_Button_Standard_tileable_tc_disabled_png_509379672;
               this.defaultDownTopImage = _embed_css_images_custombutton_Button_Standard_tileable_tc_pressed_png_1274559636;
               this.selectedOverBottomRightImage = "bottomLeft";
               this.defaultUpCenterImage = _embed_css_images_custombutton_Button_Standard_tileable_mc_idle_png_1278990365;
               this.paddingBottom = 0;
               this.selectedDownTopLeftImage = _embed_css_images_custombutton_Button_Border_tileable_tl_pressed_png_1903116940;
               this.textSelectedColor = 13221291;
               this.defaultDownCenterImage = _embed_css_images_custombutton_Button_Standard_tileable_mc_pressed_png_81347079;
               this.selectedDownCenterImage = _embed_css_images_custombutton_Button_Standard_tileable_mc_pressed_png_81347079;
               this.defaultDisabledTopLeftImage = _embed_css_images_custombutton_Button_Standard_tileable_tl_disabled_png_1248907181;
               this.selectedUpBottomRightImage = "bottomLeft";
               this.height = 22;
               this.defaultUpTopRightImage = "topLeft";
               this.selectedUpTopRightImage = "topLeft";
               this.selectedUpCenterImage = _embed_css_images_custombutton_Button_Standard_tileable_mc_idle_png_1278990365;
               this.selectedDisabledTopImage = _embed_css_images_custombutton_Button_Border_tileable_tc_disabled_png_1563054077;
               this.selectedDownMask = "topLeft top topRight left center right bottomLeft bottom bottomRight";
               this.selectedDisabledTopLeftImage = _embed_css_images_custombutton_Button_Border_tileable_tl_disabled_png_655788448;
               this.selectedOverTopRightImage = "topLeft";
               this.defaultOverLeftImage = _embed_css_images_custombutton_Button_Standard_tileable_ml_over_png_517648064;
               this.defaultDownMask = "topLeft top topRight left center right bottomLeft bottom bottomRight";
               this.selectedUpTopImage = _embed_css_images_custombutton_Button_Border_tileable_tc_idle_png_1026384539;
               this.selectedUpMask = "topLeft top topRight left center right bottomLeft bottom bottomRight";
               this.selectedDownBottomImage = _embed_css_images_custombutton_Button_Border_tileable_bc_pressed_png_1988687265;
               this.selectedDisabledBottomLeftImage = _embed_css_images_custombutton_Button_Border_tileable_bl_disabled_png_1194789362;
               this.selectedOverTopLeftImage = _embed_css_images_custombutton_Button_Border_tileable_tl_over_png_1128024712;
               this.focusThickness = 0;
               this.defaultDownBottomLeftImage = _embed_css_images_custombutton_Button_Standard_tileable_bl_pressed_png_1326387531;
               this.selectedDownBottomLeftImage = _embed_css_images_custombutton_Button_Border_tileable_bl_pressed_png_1894305430;
               this.defaultDownLeftImage = _embed_css_images_custombutton_Button_Standard_tileable_ml_pressed_png_165397636;
               this.defaultOverRightImage = "left";
               this.defaultOverCenterImage = _embed_css_images_custombutton_Button_Standard_tileable_mc_over_png_931421981;
               this.defaultDisabledTopRightImage = "topLeft";
               this.selectedDownTopRightImage = "topLeft";
               this.selectedOverRightImage = "left";
               this.selectedUpRightImage = "left";
               this.textRollOverColor = 15904590;
               this.defaultUpLeftImage = _embed_css_images_custombutton_Button_Standard_tileable_ml_idle_png_1785933248;
               this.paddingLeft = 4;
               this.selectedOverBottomLeftImage = _embed_css_images_custombutton_Button_Border_tileable_bl_over_png_344982570;
               this.color = 15904590;
               this.defaultDisabledBottomLeftImage = _embed_css_images_custombutton_Button_Standard_tileable_bl_disabled_png_1093953119;
               this.selectedUpLeftImage = _embed_css_images_custombutton_Button_Border_tileable_ml_idle_png_901180245;
               this.skin = StyleSizedBitmapButtonSkin;
               this.defaultOverBottomRightImage = "bottomLeft";
               this.defaultOverBottomImage = _embed_css_images_custombutton_Button_Standard_tileable_bc_over_png_185603650;
               this.defaultDisabledLeftImage = _embed_css_images_custombutton_Button_Standard_tileable_ml_disabled_png_1250879576;
               this.selectedUpBottomLeftImage = _embed_css_images_custombutton_Button_Border_tileable_bl_idle_png_1538038570;
               this.defaultDownBottomImage = _embed_css_images_custombutton_Button_Standard_tileable_bc_pressed_png_572612494;
               this.defaultUpRightImage = "left";
               this.defaultOverTopRightImage = "topLeft";
               this.defaultDownTopLeftImage = _embed_css_images_custombutton_Button_Standard_tileable_tl_pressed_png_1968611417;
               this.defaultDownRightImage = "left";
               this.defaultUpBottomImage = _embed_css_images_custombutton_Button_Standard_tileable_bc_idle_png_1982739778;
               this.selectedDisabledLeftImage = _embed_css_images_custombutton_Button_Border_tileable_ml_disabled_png_1474936339;
               this.defaultUpTopImage = _embed_css_images_custombutton_Button_Standard_tileable_tc_idle_png_24708496;
               this.selectedDisabledTopRightImage = "topLeft";
               this.defaultOverTopImage = _embed_css_images_custombutton_Button_Standard_tileable_tc_over_png_1841477776;
               this.selectedDownRightImage = "left";
               this.selectedOverMask = "topLeft top topRight left center right bottomLeft bottom bottomRight";
               this.paddingTop = 0;
               this.selectedUpTopLeftImage = _embed_css_images_custombutton_Button_Border_tileable_tl_idle_png_402102152;
               this.defaultDisabledBottomImage = _embed_css_images_custombutton_Button_Standard_tileable_bc_disabled_png_1867898870;
               this.defaultOverMask = "topLeft top topRight left center right bottomLeft bottom bottomRight";
               this.selectedDisabledRightImage = "left";
               this.selectedUpBottomImage = _embed_css_images_custombutton_Button_Border_tileable_bc_idle_png_721306611;
               this.selectedDownBottomRightImage = "bottomLeft";
               this.defaultUpMask = "topLeft top topRight left center right bottomLeft bottom bottomRight";
               this.selectedDisabledCenterImage = _embed_css_images_custombutton_Button_Standard_tileable_mc_disabled_png_983765749;
               this.defaultUpBottomLeftImage = _embed_css_images_custombutton_Button_Standard_tileable_bl_idle_png_1526099209;
               this.defaultDisabledCenterImage = _embed_css_images_custombutton_Button_Standard_tileable_mc_disabled_png_983765749;
               this.defaultDisabledMask = "topLeft top topRight left center right bottomLeft bottom bottomRight";
               this.selectedOverBottomImage = _embed_css_images_custombutton_Button_Border_tileable_bc_over_png_373998323;
               this.disabledColor = 15904590;
               this.defaultDownTopRightImage = "topLeft";
               this.defaultUpTopLeftImage = _embed_css_images_custombutton_Button_Standard_tileable_tl_idle_png_1925791611;
               this.defaultUpBottomRightImage = "bottomLeft";
               this.selectedDownTopImage = _embed_css_images_custombutton_Button_Border_tileable_tc_pressed_png_502332351;
               this.selectedOverCenterImage = _embed_css_images_custombutton_Button_Standard_tileable_mc_over_png_931421981;
               this.width = 1;
               this.defaultDownBottomRightImage = "bottomLeft";
               this.selectedDisabledBottomRightImage = "bottomLeft";
               this.defaultOverTopLeftImage = _embed_css_images_custombutton_Button_Standard_tileable_tl_over_png_546849157;
               this.selectedDisabledMask = "topLeft top topRight left center right bottomLeft bottom bottomRight";
            };
         }
         style = StyleManager.getStyleDeclaration(".combatButtonOffensive");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".combatButtonOffensive",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.defaultUpMask = "center";
               this.selectedDownMask = "center";
               this.skin = BitmapButtonSkin;
               this.defaultDisabledMask = "center";
               this.defaultDownMask = "center";
               this.selectedUpMask = "center";
               this.defaultUpCenterImage = _embed_css_images_Icons_CombatControls_OffensiveOff_idle_png_386961017;
               this.selectedOverCenterImage = _embed_css_images_Icons_CombatControls_OffensiveOn_over_png_1922169731;
               this.defaultOverCenterImage = _embed_css_images_Icons_CombatControls_OffensiveOff_over_png_1112870265;
               this.selectedOverMask = "center";
               this.defaultDownCenterImage = _embed_css_images_Icons_CombatControls_OffensiveOff_over_png_1112870265;
               this.selectedDownCenterImage = _embed_css_images_Icons_CombatControls_OffensiveOn_over_png_1922169731;
               this.defaultOverMask = "center";
               this.selectedDisabledMask = "center";
               this.selectedUpCenterImage = _embed_css_images_Icons_CombatControls_OffensiveOn_idle_png_505642365;
            };
         }
         style = StyleManager.getStyleDeclaration(".actionBarRight");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".actionBarRight",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.toggleButtonStyle = "actionBarWidgetToggleRight";
               this.scrollUpButtonStyle = "actionBarWidgetScrollBottom";
               this.scrollDownButtonStyle = "actionBarWidgetScrollTop";
               this.borderMask = "right center";
            };
         }
         style = StyleManager.getStyleDeclaration(".widgetViewCollapse");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".widgetViewCollapse",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.defaultUpMask = "center";
               this.selectedDownMask = "center";
               this.selectedDisabledCenterImage = _embed_css_images_Button_Maximize_idle_png_1094816082;
               this.skin = BitmapButtonSkin;
               this.defaultDisabledCenterImage = _embed_css_images_Button_Minimize_idle_png_1665493556;
               this.defaultDisabledMask = "center";
               this.defaultDownMask = "center";
               this.selectedUpMask = "center";
               this.defaultUpCenterImage = _embed_css_images_Button_Minimize_idle_png_1665493556;
               this.selectedOverCenterImage = _embed_css_images_Button_Maximize_over_png_1257962926;
               this.defaultOverCenterImage = _embed_css_images_Button_Minimize_over_png_1989991220;
               this.selectedOverMask = "center";
               this.defaultDownCenterImage = _embed_css_images_Button_Minimize_pressed_png_1820422736;
               this.selectedDownCenterImage = _embed_css_images_Button_Maximize_pressed_png_744580322;
               this.defaultOverMask = "center";
               this.selectedDisabledMask = "center";
               this.selectedUpCenterImage = _embed_css_images_Button_Maximize_idle_png_1094816082;
            };
         }
         style = StyleManager.getStyleDeclaration(".sideBarHeaderBody");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".sideBarHeaderBody",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.defaultUpMask = "center";
               this.selectedDownMask = "center";
               this.skin = BitmapButtonSkin;
               this.defaultDownMask = "center";
               this.selectedUpMask = "center";
               this.defaultUpCenterImage = _embed_css_images_Icons_WidgetMenu_Inventory_idle_png_1929909360;
               this.selectedOverCenterImage = _embed_css_images_Icons_WidgetMenu_Inventory_active_over_png_609144603;
               this.defaultOverCenterImage = _embed_css_images_Icons_WidgetMenu_Inventory_idle_over_png_1298136851;
               this.selectedOverMask = "center";
               this.defaultDownCenterImage = _embed_css_images_Icons_WidgetMenu_Inventory_idle_over_png_1298136851;
               this.selectedDownCenterImage = _embed_css_images_Icons_WidgetMenu_Inventory_active_over_png_609144603;
               this.defaultOverMask = "center";
               this.selectedUpCenterImage = _embed_css_images_Icons_WidgetMenu_Inventory_active_png_710741474;
            };
         }
         style = StyleManager.getStyleDeclaration(".combatButtonDove");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".combatButtonDove",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.defaultUpMask = "center";
               this.selectedDownMask = "center";
               this.skin = BitmapButtonSkin;
               this.defaultDisabledMask = "center";
               this.defaultDownMask = "center";
               this.selectedUpMask = "center";
               this.defaultUpCenterImage = _embed_css_images_Icons_CombatControls_DoveOff_idle_png_165836976;
               this.selectedOverCenterImage = _embed_css_images_Icons_CombatControls_DoveOn_over_png_927199358;
               this.defaultOverCenterImage = _embed_css_images_Icons_CombatControls_DoveOff_over_png_1096554064;
               this.selectedOverMask = "center";
               this.defaultDownCenterImage = _embed_css_images_Icons_CombatControls_DoveOff_over_png_1096554064;
               this.selectedDownCenterImage = _embed_css_images_Icons_CombatControls_DoveOn_over_png_927199358;
               this.defaultOverMask = "center";
               this.selectedDisabledMask = "center";
               this.selectedUpCenterImage = _embed_css_images_Icons_CombatControls_DoveOn_idle_png_1462206846;
            };
         }
         style = StyleManager.getStyleDeclaration("ActionButtonToolTip");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration("ActionButtonToolTip",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.borderThickness = 1;
               this.borderColor = 13415802;
               this.backgroundColor = 658961;
               this.color = 13221291;
               this.borderAlpha = 1;
               this.backgroundAlpha = 0.8;
               this.borderSkin = VectorBorderSkin;
            };
         }
         style = StyleManager.getStyleDeclaration(".statusWidgetDefaultSkill");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".statusWidgetDefaultSkill",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.progressBarMalusStyleName = "statusWidgetDefaultMalusSkillProgress";
               this.verticalAlign = "middle";
               this.iconStyleName = "";
               this.progressBarBonusStyleName = "statusWidgetDefaultBonusSkillProgress";
               this.progressBarZeroStyleName = "statusWidgetDefaultZeroSkillProgress";
               this.horizontalGap = 0;
               this.progressBarStyleName = "statusWidgetDefaultSkillProgress";
               this.labelStyleName = ".statusWidgetSkillProgress";
            };
         }
         style = StyleManager.getStyleDeclaration(".statusWidgetParallelHitpoints");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".statusWidgetParallelHitpoints",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.barRedLow = _embed_css_images_BarsHealth_default_RedLow_png_2034053770;
               this.barImages = ["barRedLow2","barRedLow","barRedFull","barYellow","barGreenLow","barGreenFull"];
               this.backgroundRightImage = _embed_css_images_BG_Bars_default_enpiece_png_329250772;
               this.barRedFull = _embed_css_images_BarsHealth_default_RedFull_png_60642647;
               this.barGreenFull = _embed_css_images_BarsHealth_default_GreenFull_png_807562777;
               this.paddingRight = 3;
               this.backgroundMask = "center";
               this.leftOrnamentMask = "left";
               this.barYellow = _embed_css_images_BarsHealth_default_Yellow_png_808052085;
               this.barGreenLow = _embed_css_images_BarsHealth_default_GreenLow_png_1485470108;
               this.rightOrnamentMask = "right";
               this.backgroundCenterImage = _embed_css_images_BG_Bars_default_tileable_png_813666947;
               this.rightOrnamentRightImage = _embed_css_images_BG_Bars_default_enpieceOrnamented_png_1621675861;
               this.backgroundLeftImage = "right";
               this.leftOrnamentLeftImage = "right";
               this.paddingBottom = 3;
               this.barRedLow2 = _embed_css_images_BarsHealth_default_RedLow2_png_1110203394;
               this.leftOrnamentOffset = -5;
               this.rightOrnamentOffset = 5;
               this.paddingTop = 1;
               this.leftOrnamentRightImage = _embed_css_images_BG_Bars_default_enpieceOrnamented_png_1621675861;
               this.paddingLeft = 3;
               this.barLimits = [0,0.04,0.1,0.3,0.6,0.95];
            };
         }
         style = StyleManager.getStyleDeclaration(".chatWidgetTabBarScrollLeft");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".chatWidgetTabBarScrollLeft",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.defaultDisabledRightImage = _embed_css_images_Arrow_ScrollTabs_disabled_png_744892220;
               this.defaultUpMask = "left";
               this.skin = BitmapButtonSkin;
               this.defaultOverBottomImage = "right";
               this.defaultOverLeftImage = "right";
               this.defaultDisabledMask = "left";
               this.defaultDisabledLeftImage = "right";
               this.defaultDownMask = "left";
               this.defaultDownBottomImage = "right";
               this.defaultUpRightImage = _embed_css_images_Arrow_ScrollTabs_idle_png_1793155108;
               this.defaultDownRightImage = _embed_css_images_Arrow_ScrollTabs_pressed_png_169219784;
               this.defaultUpBottomImage = "right";
               this.defaultDownLeftImage = "right";
               this.defaultOverRightImage = _embed_css_images_Arrow_ScrollTabs_over_png_1462627108;
               this.defaultUpLeftImage = "right";
               this.defaultDisabledBottomImage = "right";
               this.defaultOverMask = "left";
            };
         }
         style = StyleManager.getStyleDeclaration("ImbuementInformationPane");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration("ImbuementInformationPane",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.backgroundColor = 658961;
               this.paddingBottom = 4;
               this.paddingRight = 4;
               this.backgroundAlpha = 0.5;
               this.paddingTop = 4;
               this.paddingLeft = 4;
            };
         }
         style = StyleManager.getStyleDeclaration(".simpleTabNavigator");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".simpleTabNavigator",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.selectedBorderColor = 13415802;
               this.selectedBackgroundAlpha = 0.5;
               this.paddingRight = 0;
               this.skin = VectorTabSkin;
               this.selectedBorderAlpha = 1;
               this.selectedBackgroundColor = 658961;
               this.defaultBackgroundColor = 2240055;
               this.defaultBorderColor = 8089164;
               this.paddingBottom = 0;
               this.defaultBackgroundAlpha = 0.5;
               this.selectedTextColor = 13221291;
               this.defaultBorderAlpha = 1;
               this.selectedBorderThickness = 1;
               this.defaultTextColor = 15904590;
               this.paddingTop = 0;
               this.defaultBorderThickness = 1;
               this.paddingLeft = 0;
            };
         }
         style = StyleManager.getStyleDeclaration(".successRate");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".successRate",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.textAlign = "right";
            };
         }
         style = StyleManager.getStyleDeclaration(".headerLabel");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".headerLabel",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.fontWeight = "bold";
            };
         }
         style = StyleManager.getStyleDeclaration(".bodySlotNeckBlessed");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".bodySlotNeckBlessed",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.emptyBackgroundImage = _embed_css_images_Slot_InventoryNecklace_protected_png_1785395660;
               this.backgroundImage = _embed_css_images_slot_Hotkey_protected_png_1201653772;
            };
         }
         style = StyleManager.getStyleDeclaration("ChannelView");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration("ChannelView",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.dividerThickness = 5;
               this.horizontalGap = 5;
               this.dividerBackgroundMask = "left";
               this.dividerBackgroundLeftImage = _embed_css_images_Border02_WidgetSidebar_slim_png_828323829;
               this.messagesStyle = "messages";
               this.dividerAffordance = 5;
               this.verticalGap = 0;
               this.nicklistStyle = "nicklist";
            };
         }
         style = StyleManager.getStyleDeclaration(".ingameShopOfferNew");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".ingameShopOfferNew",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 44562;
            };
         }
         style = StyleManager.getStyleDeclaration(".preyDuration");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".preyDuration",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.backgroundLeftImage = _embed_css_images_BG_BarsProgress_compact_endpiece_png_1448454481;
               this.backgroundRightImage = "left";
               this.barImages = "barDefault";
               this.paddingBottom = 2;
               this.barDefault = _embed_css_images_BarsProgress_compact_orange_png_605959778;
               this.backgroundMask = "left center right";
               this.paddingTop = 2;
               this.labelHorizontalAlign = "center";
               this.backgroundCenterImage = _embed_css_images_BG_BarsProgress_compact_tileable_png_1503274352;
               this.barLimits = 0;
            };
         }
         style = StyleManager.getStyleDeclaration(".combatButtonWhiteHand");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".combatButtonWhiteHand",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.defaultUpMask = "center";
               this.selectedDownMask = "center";
               this.skin = BitmapButtonSkin;
               this.defaultDisabledMask = "center";
               this.defaultDownMask = "center";
               this.selectedUpMask = "center";
               this.defaultUpCenterImage = _embed_css_images_Icons_CombatControls_WhiteHandOff_idle_png_1012304800;
               this.selectedOverCenterImage = _embed_css_images_Icons_CombatControls_WhiteHandOn_over_png_2062716238;
               this.defaultOverCenterImage = _embed_css_images_Icons_CombatControls_WhiteHandOff_over_png_1354370208;
               this.selectedOverMask = "center";
               this.defaultDownCenterImage = _embed_css_images_Icons_CombatControls_WhiteHandOff_over_png_1354370208;
               this.selectedDownCenterImage = _embed_css_images_Icons_CombatControls_WhiteHandOn_over_png_2062716238;
               this.defaultOverMask = "center";
               this.selectedDisabledMask = "center";
               this.selectedUpCenterImage = _embed_css_images_Icons_CombatControls_WhiteHandOn_idle_png_1901846962;
            };
         }
         style = StyleManager.getStyleDeclaration("OfferDetails");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration("OfferDetails",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.paddingBottom = 6;
               this.paddingRight = 6;
               this.paddingTop = 6;
               this.verticalGap = 6;
               this.paddingLeft = 6;
               this.fontWeight = "normal";
            };
         }
         style = StyleManager.getStyleDeclaration("SelectOutfitWidget");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration("SelectOutfitWidget",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.outfitDialogOpenStoreButtonStyle = "buttonDialogOpenStoreButton";
            };
         }
         style = StyleManager.getStyleDeclaration(".buddylist");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".buddylist",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.horizontalGap = 0;
               this.paddingBottom = 0;
               this.itemBackgroundColors = [2768716,16711680];
               this.paddingRight = 2;
               this.itemRendererStyle = "buddylistWidgetView";
               this.itemBackgroundAlphas = [0.5,0];
               this.paddingTop = 0;
               this.verticalGap = 2;
               this.paddingLeft = 0;
            };
         }
         style = StyleManager.getStyleDeclaration(".statusWidgetDefaultMana");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".statusWidgetDefaultMana",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.barImages = "barDefault";
               this.backgroundRightImage = _embed_css_images_BG_Bars_default_enpiece_png_329250772;
               this.paddingRight = 1;
               this.backgroundMask = "center";
               this.leftOrnamentMask = "left";
               this.rightOrnamentMask = "none";
               this.backgroundCenterImage = _embed_css_images_BG_Bars_default_tileable_png_813666947;
               this.rightOrnamentRightImage = _embed_css_images_BG_Bars_default_enpieceOrnamented_png_1621675861;
               this.backgroundLeftImage = "right";
               this.leftOrnamentLeftImage = "right";
               this.paddingBottom = 3;
               this.barDefault = _embed_css_images_BarsHealth_default_Mana_png_2014888902;
               this.leftOrnamentOffset = -5;
               this.rightOrnamentOffset = 5;
               this.paddingTop = 1;
               this.leftOrnamentRightImage = _embed_css_images_BG_Bars_default_enpieceOrnamented_png_1621675861;
               this.paddingLeft = 3;
               this.barLimits = 0;
            };
         }
         style = StyleManager.getStyleDeclaration(".statusWidgetCompactMalusSkillProgress");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".statusWidgetCompactMalusSkillProgress",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.tickCenterImage = _embed_css_images_Bars_ProgressMarker_png_1761755336;
               this.backgroundRightImage = "left";
               this.barImages = "barDefault";
               this.tickMask = "center";
               this.paddingRight = -5;
               this.backgroundMask = "left center right";
               this.backgroundCenterImage = _embed_css_images_BG_BarsXP_default_tileable_png_1408337339;
               this.backgroundLeftImage = _embed_css_images_BG_BarsXP_default_endpiece_png_1394078162;
               this.barDefault = _embed_css_images_BarsXP_default_malus_png_1083584633;
               this.paddingBottom = 4;
               this.tickOffset = 3;
               this.paddingTop = 3;
               this.paddingLeft = -5;
               this.barLimits = 0;
            };
         }
         style = StyleManager.getStyleDeclaration(".expandedView");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".expandedView",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.borderCenterMask = "all";
               this.borderFooterMask = "none";
               this.borderCenterCenterImage = _embed_css_images_BG_Combat_ExpertOn_png_2127142674;
            };
         }
         style = StyleManager.getStyleDeclaration(".validationFeedbackError");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".validationFeedbackError",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 13120000;
            };
         }
         style = StyleManager.getStyleDeclaration(".preyUnlockPermanentlyButton");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".preyUnlockPermanentlyButton",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.icon = _embed_css____images_prey_prey_unlock_permanently_png_1955932179;
            };
         }
         StyleManager.mx_internal::initProtoChainRoots();
      }
      
      protected function onGameWindowResize(param1:ResizeEvent) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         if(this.options != null && this.m_UIGameWindow != null && this.m_UIChatWidget != null && !this.m_ForceDisableGameWindowSizeCalc)
         {
            _loc2_ = this.m_UIGameWindow.height;
            _loc3_ = this.m_UIChatWidget.height;
            if(this.options.generalUIGameWindowHeight > 0.01 && this.options.generalUIGameWindowHeight < 99.99)
            {
               this.options.generalUIGameWindowHeight = _loc2_ * 100 / (_loc2_ + _loc3_);
            }
         }
         this.m_ForceDisableGameWindowSizeCalc = false;
      }
      
      [Bindable(event="propertyChange")]
      public function get m_UITibiaRootContainer() : HBox
      {
         return this._1020379552m_UITibiaRootContainer;
      }
      
      private function _Tibia_Array1_i() : Array
      {
         var _loc1_:Array = [undefined,undefined];
         this._Tibia_Array1 = _loc1_;
         BindingManager.executeBindings(this,"_Tibia_Array1",this._Tibia_Array1);
         return _loc1_;
      }
      
      public function setSessionKey(param1:String) : void
      {
         this.m_SessionKey = param1;
      }
      
      protected function onPreinitialise(param1:FlexEvent) : void
      {
         this.m_AppearanceStorage = ApperanceStorageFactory.s_CreateAppearanceStorage();
         this.m_AppearanceStorage.addEventListener(Event.COMPLETE,this.onAppearancesLoadComplete);
         this.m_AppearanceStorage.addEventListener(ErrorEvent.ERROR,this.onAppearancesLoadError);
         this.addEventListener(ConnectionEvent.CREATED,this.onConnectionCreated);
         this.m_ChatStorage = new ChatStorage();
         this.m_ChannelsPending = new Vector.<int>();
         this.m_ContainerStorage = new ContainerStorage();
         this.m_MiniMapStorage = new MiniMapStorage();
         this.m_SpellStorage = new SpellStorage();
         this.m_WorldMapStorage = new WorldMapStorage();
         this.m_UIEffectsManager = new UIEffectsManager();
         this.m_SeconaryTimer = new Timer(50);
         this.m_SeconaryTimer.addEventListener(TimerEvent.TIMER,this.onSecondaryTimer);
         this.m_SeconaryTimer.start();
      }
      
      public function __m_UICenterColumn_dividerRelease(param1:DividerEvent) : void
      {
         this.onDividerRelease(param1);
      }
      
      [Bindable(event="propertyChange")]
      public function get m_UIActionBarBottom() : HActionBarWidget
      {
         return this._629924354m_UIActionBarBottom;
      }
      
      public function initializeGameClient(param1:Boolean, param2:Object = null) : void
      {
         this.m_TutorialMode = param1;
         this.m_TutorialData = param2;
         if(this.m_TutorialMode)
         {
            this.m_GameActionFactory = new SessiondumpHintsGameActionFactory();
         }
         else
         {
            this.m_GameActionFactory = new GameActionFactory();
         }
         s_InternalTibiaTimerFactor = 1;
      }
      
      public function __m_UIGameWindow_resize(param1:ResizeEvent) : void
      {
         this.onGameWindowResize(param1);
      }
      
      protected function onApplicationComplete(param1:FlexEvent) : void
      {
         ToolTipManager.showDelay = 750;
         ToolTipManager.scrubDelay = 0;
         stage.align = StageAlign.TOP_LEFT;
         stage.frameRate = 100;
         stage.scaleMode = StageScaleMode.NO_SCALE;
         stage.showDefaultContextMenu = false;
         if(this.m_UICenterColumn != null && this.m_UICenterColumn.numDividers > 0 && this.m_UICenterColumn.getDividerAt(0) != null)
         {
            this.m_UICenterColumn.getDividerAt(0).doubleClickEnabled = true;
            this.m_UICenterColumn.getDividerAt(0).addEventListener(MouseEvent.DOUBLE_CLICK,this.onGameWindowAutofit);
         }
         if(this.m_EnableFocusNotifier && this.isActive == false)
         {
            FocusNotifier.getInstance().captureMouse = true;
            FocusNotifier.getInstance().show();
         }
      }
      
      public function ___Tibia_Application1_deactivate(param1:Event) : void
      {
         this.onActivation(param1);
      }
      
      private function updateCombatTactics() : void
      {
         if(this.m_Communication != null && this.m_Communication.isGameRunning && this.m_Options != null)
         {
            this.m_Communication.sendCSETTACTICS(this.m_Options.combatAttackMode,this.m_Options.combatChaseMode,this.m_Options.combatSecureMode,this.m_Options.combatPVPMode);
         }
      }
      
      public function ___Tibia_Application1_applicationComplete(param1:FlexEvent) : void
      {
         this.onApplicationComplete(param1);
      }
      
      protected function reloadClient(param1:AccountCharacter = null, param2:String = null) : void
      {
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:URLVariables = null;
         var _loc3_:URLRequest = null;
         if(param2 != null && param2.length > 0)
         {
            _loc3_ = new URLRequest(param2);
         }
         else
         {
            _loc3_ = new URLRequest(URLHelper.s_GetBrowserCurrentUrl());
         }
         if(param1 != null)
         {
            _loc4_ = URLHelper.s_GetBrowserCurrentBaseUrl();
            if(param2 != null)
            {
               _loc4_ = param2;
            }
            _loc5_ = URLHelper.s_GetBrowserCurrentQuerystring();
            _loc6_ = new URLVariables(_loc5_);
            _loc3_ = new URLRequest(_loc4_);
            _loc6_.name = param1.name;
            _loc3_.data = _loc6_;
         }
         navigateToURL(_loc3_,"_self");
      }
      
      private function updateGameWindowSize() : void
      {
         var _loc1_:Number = NaN;
         if(this.options != null && this.m_UIGameWindow != null && this.m_UIChatWidget != null)
         {
            _loc1_ = this.options.generalUIGameWindowHeight;
            if(Math.abs(this.m_UIGameWindow.percentHeight - _loc1_) > 0.01)
            {
               this.m_ForceDisableGameWindowSizeCalc = true;
            }
            this.m_UIGameWindow.percentHeight = _loc1_;
            this.m_UIChatWidget.percentHeight = 100 - _loc1_;
         }
      }
      
      private function loadOptions() : void
      {
         if(this.options == null)
         {
            this.options = new OptionsStorage(this.m_DefaultOptionsAsset == null?null:this.m_DefaultOptionsAsset.xml,this.m_CurrentOptionsAsset == null?null:this.m_CurrentOptionsAsset.xml);
         }
      }
      
      private function onConnectionLoginWait(param1:ConnectionEvent) : void
      {
         visible = false;
         this.saveLocalData();
         this.saveOptions();
         var _loc2_:LoginWaitWidget = new LoginWaitWidget();
         _loc2_.message = param1.message;
         _loc2_.timeout = Number(param1.data);
         _loc2_.addEventListener(CloseEvent.CLOSE,this.onCloseLoginWait);
         _loc2_.show();
      }
      
      private function onConnectionLost(param1:ConnectionEvent) : void
      {
         this.saveLocalData();
         this.saveOptions();
         this.m_ConnectionLostDialog = new ConnectionLostWidget();
         this.m_ConnectionLostDialog.timeout = Number(60 * 1000);
         this.m_ConnectionLostDialog.addEventListener(CloseEvent.CLOSE,this.onCloseConnectionLostDialog);
         this.m_ConnectionLostDialog.show();
      }
      
      protected function onGameWindowAutofit(param1:MouseEvent) : void
      {
         this.autofitGameWindow();
      }
      
      public function get isFocusNotifierEnabled() : Boolean
      {
         return this.m_EnableFocusNotifier;
      }
      
      private function setCurrentOptionsFromAssets(param1:IAssetProvider) : void
      {
         if(this.m_CurrentOptionsAsset != null)
         {
            this.m_CurrentOptionsAsset.removeEventListener(Event.COMPLETE,this.onUploadOptionsComplete);
            this.m_CurrentOptionsAsset.removeEventListener(ErrorEvent.ERROR,this.onUploadOptionsError);
            this.m_CurrentOptionsAsset.removeEventListener(IOErrorEvent.IO_ERROR,this.onUploadOptionsError);
            this.m_CurrentOptionsAsset.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onUploadOptionsError);
         }
         this.m_CurrentOptionsAsset = this.m_AssetProvider.getCurrentOptions();
         this.m_CurrentOptionsDirty = false;
         this.m_CurrentOptionsLastUpload = 0;
         this.m_CurrentOptionsUploading = false;
         if(this.m_CurrentOptionsAsset != null)
         {
            this.m_CurrentOptionsAsset.addEventListener(Event.COMPLETE,this.onUploadOptionsComplete);
            this.m_CurrentOptionsAsset.addEventListener(ErrorEvent.ERROR,this.onUploadOptionsError);
            this.m_CurrentOptionsAsset.addEventListener(IOErrorEvent.IO_ERROR,this.onUploadOptionsError);
            this.m_CurrentOptionsAsset.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onUploadOptionsError);
            param1.removeAsset(this.m_CurrentOptionsAsset);
         }
      }
      
      public function set m_UITibiaRootContainer(param1:HBox) : void
      {
         var _loc2_:Object = null;
         _loc2_ = this._1020379552m_UITibiaRootContainer;
         if(_loc2_ !== param1)
         {
            this._1020379552m_UITibiaRootContainer = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"m_UITibiaRootContainer",_loc2_,param1));
         }
      }
      
      private function _Tibia_HActionBarWidget2_i() : HActionBarWidget
      {
         var _loc1_:HActionBarWidget = new HActionBarWidget();
         this.m_UIActionBarBottom = _loc1_;
         _loc1_.styleName = "actionBarBottom";
         _loc1_.id = "m_UIActionBarBottom";
         BindingManager.executeBindings(this,"m_UIActionBarBottom",this.m_UIActionBarBottom);
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      public function set m_UIActionBarLeft(param1:VActionBarWidget) : void
      {
         var _loc2_:Object = null;
         _loc2_ = this._1174474338m_UIActionBarLeft;
         if(_loc2_ !== param1)
         {
            this._1174474338m_UIActionBarLeft = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"m_UIActionBarLeft",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get m_UIOuterRootContainer() : DividedBox
      {
         return this._1568861366m_UIOuterRootContainer;
      }
      
      private function onConnectionLoginAdvice(param1:ConnectionEvent) : void
      {
         visible = false;
         var _loc2_:MessageWidget = new MessageWidget();
         _loc2_.buttonFlags = PopUpBase.BUTTON_OKAY;
         _loc2_.keyboardFlags = PopUpBase.KEY_ENTER;
         _loc2_.message = resourceManager.getString(BUNDLE,"DLG_LOGINADVICE_TEXT",[param1.message]);
         _loc2_.priority = PopUpBase.DEFAULT_PRIORITY + 1;
         _loc2_.title = resourceManager.getString(BUNDLE,"DLG_LOGINADVICE_TITLE");
         _loc2_.show();
      }
      
      [Bindable(event="propertyChange")]
      public function get m_UIActionBarRight() : VActionBarWidget
      {
         return this._2043305115m_UIActionBarRight;
      }
      
      private function onConnectionRecovered(param1:ConnectionEvent) : void
      {
         this.m_ConnectionLostDialog.hide();
      }
      
      override public function initialize() : void
      {
         var target:Tibia = null;
         var watcherSetupUtilClass:Object = null;
         mx_internal::setDocumentDescriptor(this._documentDescriptor_);
         var bindings:Array = this._Tibia_bindingsSetup();
         var watchers:Array = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_TibiaWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(param1:String):*
         {
            return target[param1];
         },bindings,watchers);
         var i:uint = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         super.initialize();
      }
      
      protected function transferToLiveServer(param1:String) : void
      {
         var _loc4_:AccountCharacter = null;
         if(!this.m_TutorialMode)
         {
            throw new IllegalOperationError("Tibia.transferToLiveServer: Must be in tutorial mode");
         }
         var _loc2_:int = -1;
         var _loc3_:int = 0;
         while(_loc3_ < this.m_ConnectionDataList.length - 1)
         {
            _loc4_ = this.m_ConnectionDataList[_loc3_] as AccountCharacter;
            if(_loc4_ != null && _loc4_.name == param1)
            {
               _loc2_ = _loc3_;
               break;
            }
            _loc3_++;
         }
         if(_loc2_ > -1)
         {
            this.initializeGameClient(false);
            this.setConnectionDataList(this.m_ConnectionDataList,_loc2_);
            this.loginCharacter();
            this.setCurrentOptionsFromAssets(this.m_AssetProvider);
            this.m_DefaultOptionsAsset = this.m_AssetProvider.getDefaultOptions();
            if(this.m_DefaultOptionsAsset != null)
            {
               this.m_AssetProvider.removeAsset(this.m_DefaultOptionsAsset);
            }
            this.options = null;
            this.loadOptions();
            return;
         }
         throw new ArgumentError("No ConnectionData found for character " + param1);
      }
      
      private function _Tibia_VActionBarWidget2_i() : VActionBarWidget
      {
         var _loc1_:VActionBarWidget = new VActionBarWidget();
         this.m_UIActionBarRight = _loc1_;
         _loc1_.styleName = "actionBarRight";
         _loc1_.id = "m_UIActionBarRight";
         BindingManager.executeBindings(this,"m_UIActionBarRight",this.m_UIActionBarRight);
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _Tibia_bindingExprs() : void
      {
         var _loc1_:* = undefined;
         _loc1_ = BoxDirection.VERTICAL;
         _loc1_ = SideBarSet.LOCATION_A;
         _loc1_ = SideBarSet.LOCATION_B;
         _loc1_ = SideBarSet.LOCATION_B;
         _loc1_ = SideBarSet.LOCATION_A;
         _loc1_ = BoxDirection.VERTICAL;
         _loc1_ = ActionBarSet.LOCATION_TOP;
         _loc1_ = ActionBarSet.LOCATION_BOTTOM;
         _loc1_ = ActionBarSet.LOCATION_LEFT;
         _loc1_ = ActionBarSet.LOCATION_RIGHT;
         _loc1_ = SideBarSet.LOCATION_C;
         _loc1_ = SideBarSet.LOCATION_D;
         _loc1_ = SideBarSet.LOCATION_C;
         _loc1_ = SideBarSet.LOCATION_D;
      }
      
      private function onCloseConnectionLostDialog(param1:CloseEvent) : void
      {
         if(param1.detail == PopUpBase.BUTTON_ABORT || param1.detail == TimeoutWaitWidget.TIMOUT_EXPIRED)
         {
            this.m_ConnectionDataPending = -1;
            this.m_Communication.disconnect(true);
         }
      }
      
      public function set m_UIActionBarBottom(param1:HActionBarWidget) : void
      {
         var _loc2_:Object = null;
         _loc2_ = this._629924354m_UIActionBarBottom;
         if(_loc2_ !== param1)
         {
            this._629924354m_UIActionBarBottom = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"m_UIActionBarBottom",_loc2_,param1));
         }
      }
      
      public function ___Tibia_Application1_activate(param1:Event) : void
      {
         this.onActivation(param1);
      }
      
      public function autofitGameWindow() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:GridContainer = null;
         var _loc6_:IUIComponent = null;
         var _loc7_:Number = NaN;
         if(this.options != null && this.m_UIGameWindow != null && this.m_UIChatWidget != null && this.m_UIWorldMapWidget)
         {
            _loc1_ = this.m_UIGameWindow.height + this.m_UIChatWidget.height;
            _loc2_ = this.m_UIGameWindow.width;
            _loc3_ = 0;
            _loc4_ = 0;
            _loc5_ = null;
            _loc6_ = null;
            if((_loc5_ = this.m_UIGameWindow) != null)
            {
               if((_loc6_ = _loc5_.top) != null && _loc6_.includeInLayout)
               {
                  _loc3_ = _loc3_ + _loc6_.getExplicitOrMeasuredHeight();
               }
               if((_loc6_ = _loc5_.bottom) != null && _loc6_.includeInLayout)
               {
                  _loc3_ = _loc3_ + _loc6_.getExplicitOrMeasuredHeight();
               }
               if((_loc6_ = _loc5_.left) != null && _loc6_.includeInLayout)
               {
                  _loc4_ = _loc4_ + _loc6_.getExplicitOrMeasuredWidth();
               }
               if((_loc6_ = _loc5_.right) != null && _loc6_.includeInLayout)
               {
                  _loc4_ = _loc4_ + _loc6_.getExplicitOrMeasuredWidth();
               }
            }
            if((_loc5_ = this.m_UIGameWindow.center as GridContainer) != null)
            {
               if((_loc6_ = _loc5_.top) != null && _loc6_.includeInLayout)
               {
                  _loc3_ = _loc3_ + _loc6_.getExplicitOrMeasuredHeight();
               }
               if((_loc6_ = _loc5_.bottom) != null && _loc6_.includeInLayout)
               {
                  _loc3_ = _loc3_ + _loc6_.getExplicitOrMeasuredHeight();
               }
               if((_loc6_ = _loc5_.left) != null && _loc6_.includeInLayout)
               {
                  _loc4_ = _loc4_ + _loc6_.getExplicitOrMeasuredWidth();
               }
               if((_loc6_ = _loc5_.right) != null && _loc6_.includeInLayout)
               {
                  _loc4_ = _loc4_ + _loc6_.getExplicitOrMeasuredWidth();
               }
            }
            _loc7_ = this.m_UIWorldMapWidget.calculateOptimalSize(_loc2_ - _loc4_,_loc1_ - _loc3_).height + _loc3_;
            this.options.generalUIGameWindowHeight = _loc7_ * 100 / _loc1_;
         }
      }
      
      public function set m_UIBottomContainer(param1:HBox) : void
      {
         var _loc2_:Object = null;
         _loc2_ = this._967396880m_UIBottomContainer;
         if(_loc2_ !== param1)
         {
            this._967396880m_UIBottomContainer = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"m_UIBottomContainer",_loc2_,param1));
         }
      }
      
      private function onOptionsChange(param1:PropertyChangeEvent) : void
      {
         if(param1.property == "generalUIGameWindowHeight" || param1.property == "*")
         {
            this.updateGameWindowSize();
         }
         if(param1.property == "*")
         {
            this.updateCombatTactics();
         }
         this.m_CurrentOptionsDirty = true;
      }
      
      public function set m_UIWorldMapWindow(param1:GameWindowContainer) : void
      {
         var _loc2_:Object = null;
         _loc2_ = this._1313911232m_UIWorldMapWindow;
         if(_loc2_ !== param1)
         {
            this._1313911232m_UIWorldMapWindow = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"m_UIWorldMapWindow",_loc2_,param1));
         }
      }
      
      public function set m_UISideBarA(param1:SideBarWidget) : void
      {
         var _loc2_:Object = null;
         _loc2_ = this._64278965m_UISideBarA;
         if(_loc2_ !== param1)
         {
            this._64278965m_UISideBarA = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"m_UISideBarA",_loc2_,param1));
         }
      }
      
      public function set m_UISideBarB(param1:SideBarWidget) : void
      {
         var _loc2_:Object = null;
         _loc2_ = this._64278964m_UISideBarB;
         if(_loc2_ !== param1)
         {
            this._64278964m_UISideBarB = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"m_UISideBarB",_loc2_,param1));
         }
      }
      
      public function set m_UISideBarC(param1:SideBarWidget) : void
      {
         var _loc2_:Object = null;
         _loc2_ = this._64278963m_UISideBarC;
         if(_loc2_ !== param1)
         {
            this._64278963m_UISideBarC = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"m_UISideBarC",_loc2_,param1));
         }
      }
      
      public function set m_UISideBarD(param1:SideBarWidget) : void
      {
         var _loc2_:Object = null;
         _loc2_ = this._64278962m_UISideBarD;
         if(_loc2_ !== param1)
         {
            this._64278962m_UISideBarD = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"m_UISideBarD",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get m_UISideBarToggleRight() : ToggleBar
      {
         return this._665607314m_UISideBarToggleRight;
      }
      
      [Bindable(event="propertyChange")]
      public function get m_UIWorldMapWidget() : WorldMapWidget
      {
         return this._1314206572m_UIWorldMapWidget;
      }
      
      private function onCloseChangeCharacter(param1:CloseEvent) : void
      {
         var _loc4_:GameEvent = null;
         var _loc2_:AccountCharacter = null;
         var _loc3_:EmbeddedDialog = null;
         if(param1.currentTarget is CharacterSelectionWidget && param1.detail == PopUpBase.BUTTON_OKAY && CharacterSelectionWidget(param1.currentTarget).selectedCharacterIndex != -1)
         {
            this.m_ConnectionDataPending = CharacterSelectionWidget(param1.currentTarget).selectedCharacterIndex;
            if(this.m_ConnectionDataPending >= 0 && this.m_ConnectionDataPending < this.m_ConnectionDataList.length)
            {
               _loc2_ = this.m_ConnectionDataList[this.m_ConnectionDataPending] as AccountCharacter;
            }
         }
         if(param1.detail != PopUpBase.BUTTON_OKAY && param1.currentTarget is CharacterSelectionWidget && (this.m_Connection == null || !this.m_Connection.isConnected))
         {
            _loc4_ = new GameEvent(GameEvent.CLOSE,true,false);
            dispatchEvent(_loc4_);
         }
         else if(param1.detail == PopUpBase.BUTTON_OKAY && param1.currentTarget is CharacterSelectionWidget && _loc2_ != null && !this.isValidPreviewStateForClient(_loc2_.worldPreviewState))
         {
            param1.preventDefault();
            _loc3_ = new EmbeddedDialog();
            _loc3_.name = "ConfirmClientChange";
            _loc3_.buttonFlags = PopUpBase.BUTTON_YES | PopUpBase.BUTTON_NO;
            _loc3_.text = resourceManager.getString(BUNDLE,"DLG_CLIENT_CHANGE_TEXT");
            _loc3_.title = resourceManager.getString(BUNDLE,"DLG_CLIENT_CHANGE_TITLE");
            _loc3_.addEventListener(CloseEvent.CLOSE,this.onCloseChangeCharacter);
            CharacterSelectionWidget(param1.currentTarget).embeddedDialog = _loc3_;
         }
         else if((param1.detail == PopUpBase.BUTTON_YES || param1.detail == PopUpBase.BUTTON_OKAY) && (param1.currentTarget is CharacterSelectionWidget || param1.currentTarget is EmbeddedDialog && EmbeddedDialog(param1.currentTarget).name == "ConfirmClientChange") && this.m_ConnectionDataPending != -1)
         {
            if(param1.currentTarget as EmbeddedDialog != null)
            {
               ((param1.currentTarget as EmbeddedDialog).parent as PopUpBase).hide(false);
            }
            if(this.m_Connection != null && this.m_Connection.isConnected)
            {
               this.m_Communication.disconnect(false);
            }
            else if(this.m_Connection == null || !this.m_Connection.isConnected)
            {
               this.loginCharacter();
            }
         }
         else if(param1.currentTarget is CharacterSelectionWidget && param1.detail == PopUpBase.BUTTON_OKAY)
         {
            param1.preventDefault();
            _loc3_ = new EmbeddedDialog();
            _loc3_.name = "NoCharacterSelected";
            _loc3_.buttonFlags = PopUpBase.BUTTON_OKAY;
            _loc3_.text = resourceManager.getString(BUNDLE,"DLG_CHANGE_CHARACTER_NO_SELECTION_TEXT");
            _loc3_.title = resourceManager.getString(BUNDLE,"DLG_CHANGE_CHARACTER_NO_SELECTION_TITLE");
            _loc3_.addEventListener(CloseEvent.CLOSE,this.onCloseChangeCharacter);
            CharacterSelectionWidget(param1.currentTarget).embeddedDialog = _loc3_;
         }
      }
      
      private function onConnectionDisconnected(param1:ConnectionEvent) : void
      {
         visible = false;
         if(!this.m_ConnectionEstablishedAndPacketReceived && this.m_FailedConnectionRescheduler.shouldAttemptReconnect())
         {
            this.onConnectionLoginWait(this.m_FailedConnectionRescheduler.buildEventForReconnectionAndIncreaseRetries());
            return;
         }
         this.saveLocalData();
         this.saveOptions();
         if(this.m_TutorialMode)
         {
            this.transferToLiveServer(this.m_TutorialData["player-name"]);
         }
         else if(this.m_ConnectionDataPending == -1)
         {
            this.changeCharacter();
         }
         else
         {
            this.loginCharacter();
         }
      }
      
      public function get isRunning() : Boolean
      {
         return this.m_Connection != null && this.m_Connection.isGameRunning || this.m_CurrentOptionsUploading;
      }
      
      public function get currentConnection() : Object
      {
         return this.m_Connection;
      }
      
      public function set options(param1:OptionsStorage) : void
      {
         if(this.m_Options != param1)
         {
            if(this.m_Options != null)
            {
               this.m_Options.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onOptionsChange);
               this.m_Options.unload();
            }
            this.m_Options = param1;
            this.m_ChatStorage.options = this.m_Options;
            if(this.m_CreatureStorage != null)
            {
               this.m_CreatureStorage.options = this.m_Options;
            }
            this.m_WorldMapStorage.options = this.m_Options;
            this.m_UIActionBarBottom.options = this.m_Options;
            this.m_UIActionBarLeft.options = this.m_Options;
            this.m_UIActionBarRight.options = this.m_Options;
            this.m_UIActionBarTop.options = this.m_Options;
            this.m_UIChatWidget.options = this.m_Options;
            this.m_UIInputHandler.options = this.m_Options;
            this.m_UISideBarA.options = this.m_Options;
            this.m_UISideBarB.options = this.m_Options;
            this.m_UISideBarC.options = this.m_Options;
            this.m_UISideBarD.options = this.m_Options;
            this.m_UISideBarToggleLeft.options = this.m_Options;
            this.m_UISideBarToggleRight.options = this.m_Options;
            this.m_UIStatusWidget.options = this.m_Options;
            this.m_UIWorldMapWidget.options = this.m_Options;
            this.m_UIWorldMapWindow.options = this.m_Options;
            this.updateCombatTactics();
            this.updateGameWindowSize();
            if(this.m_Options != null)
            {
               this.m_Options.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onOptionsChange);
            }
            this.m_CurrentOptionsDirty = true;
         }
      }
      
      public function reset(param1:Boolean = true) : void
      {
         var _loc2_:int = 0;
         if(this.m_ChatStorage != null)
         {
            this.m_ChatStorage.reset();
         }
         if(this.m_ContainerStorage != null)
         {
            this.m_ContainerStorage.reset();
         }
         if(this.m_CreatureStorage != null)
         {
            this.m_CreatureStorage.reset(param1);
         }
         if(this.m_Player != null && param1 == true)
         {
            this.m_Player.reset();
         }
         if(this.m_SpellStorage != null)
         {
            this.m_SpellStorage.reset();
         }
         if(this.m_WorldMapStorage != null)
         {
            this.m_WorldMapStorage.reset();
         }
         if(this.m_Options != null)
         {
            this.m_Options.combatPVPMode = OptionsStorage.COMBAT_PVP_MODE_DOVE;
            this.m_Options.combatSecureMode = OptionsStorage.COMBAT_SECURE_ON;
         }
         if(this.m_UIActionBarBottom != null)
         {
            this.m_UIActionBarBottom.containerStorage = this.m_ContainerStorage;
         }
         if(this.m_UIActionBarLeft != null)
         {
            this.m_UIActionBarLeft.containerStorage = this.m_ContainerStorage;
         }
         if(this.m_UIActionBarRight != null)
         {
            this.m_UIActionBarRight.containerStorage = this.m_ContainerStorage;
         }
         if(this.m_UIActionBarTop != null)
         {
            this.m_UIActionBarTop.containerStorage = this.m_ContainerStorage;
         }
         if(this.m_UIChatWidget != null)
         {
            this.m_UIChatWidget.chatStorage = this.m_ChatStorage;
            this.m_UIChatWidget.leftChannel = this.m_ChatStorage.getChannel(ChatStorage.LOCAL_CHANNEL_ID);
            this.m_UIChatWidget.rightChannel = null;
         }
         if(this.m_UIStatusWidget != null)
         {
            this.m_UIStatusWidget.player = this.m_Player;
         }
         if(this.m_UIWorldMapWidget != null)
         {
            this.m_UIWorldMapWidget.reset();
         }
         if(this.options != null)
         {
            _loc2_ = 0;
            for each(_loc2_ in this.options.getSideBarSetIDs())
            {
               this.options.getSideBarSet(_loc2_).closeVolatileWidgets();
            }
            for each(_loc2_ in this.options.getBuddySetIDs())
            {
               this.options.getBuddySet(_loc2_).clearBuddies();
            }
         }
         CursorManager.getInstance().removeAllCursors();
         if(ContextMenuBase.getCurrent() != null)
         {
            ContextMenuBase.getCurrent().hide();
         }
         PopUpQueue.getInstance().hideByPriority(PopUpBase.DEFAULT_PRIORITY);
      }
      
      public function changeCharacter() : void
      {
         var _loc2_:IConnectionData = null;
         var _loc3_:CharacterSelectionWidget = null;
         var _loc1_:ArrayCollection = new ArrayCollection();
         for each(_loc2_ in this.m_ConnectionDataList)
         {
            if(_loc2_ is AccountCharacter)
            {
               _loc1_.addItem(_loc2_);
            }
         }
         this.m_FailedConnectionRescheduler.reset();
         if(_loc1_.length > 0)
         {
            _loc3_ = new CharacterSelectionWidget();
            _loc3_.characters = _loc1_;
            _loc3_.selectedCharacterIndex = this.m_ConnectionDataCurrent;
            _loc3_.addEventListener(CloseEvent.CLOSE,this.onCloseChangeCharacter);
            _loc3_.show();
         }
         else
         {
            this.m_ConnectionDataPending = 0;
            this.loginCharacter();
         }
      }
      
      public function set m_UIGameWindow(param1:GridContainer) : void
      {
         var _loc2_:Object = null;
         _loc2_ = this._1404294856m_UIGameWindow;
         if(_loc2_ !== param1)
         {
            this._1404294856m_UIGameWindow = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"m_UIGameWindow",_loc2_,param1));
         }
      }
      
      private function _Tibia_Array2_i() : Array
      {
         var _loc1_:Array = [undefined,undefined];
         this._Tibia_Array2 = _loc1_;
         BindingManager.executeBindings(this,"_Tibia_Array2",this._Tibia_Array2);
         return _loc1_;
      }
      
      public function set m_UICenterColumn(param1:CustomDividedBox) : void
      {
         var _loc2_:Object = null;
         _loc2_ = this._1356021457m_UICenterColumn;
         if(_loc2_ !== param1)
         {
            this._1356021457m_UICenterColumn = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"m_UICenterColumn",_loc2_,param1));
         }
      }
      
      public function set m_UISideBarToggleLeft(param1:ToggleBar) : void
      {
         var _loc2_:Object = null;
         _loc2_ = this._2056921391m_UISideBarToggleLeft;
         if(_loc2_ !== param1)
         {
            this._2056921391m_UISideBarToggleLeft = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"m_UISideBarToggleLeft",_loc2_,param1));
         }
      }
      
      public function set m_UIInputHandler(param1:InputHandler) : void
      {
         var _loc2_:Object = null;
         _loc2_ = this._748017946m_UIInputHandler;
         if(_loc2_ !== param1)
         {
            this._748017946m_UIInputHandler = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"m_UIInputHandler",_loc2_,param1));
         }
      }
      
      private function onConnectionError(param1:ConnectionEvent) : void
      {
         if(param1.errorType == ERR_COULD_NOT_CONNECT && this.m_FailedConnectionRescheduler.shouldAttemptReconnect())
         {
            this.m_ConnectionEstablishedAndPacketReceived = true;
            this.onConnectionLoginWait(this.m_FailedConnectionRescheduler.buildEventForReconnectionAndIncreaseRetries());
            return;
         }
         this.m_FailedConnectionRescheduler.reset();
         visible = false;
         this.saveLocalData();
         this.saveOptions();
         SessiondumpMouseShield.getInstance().hide();
         var _loc2_:MessageWidget = new MessageWidget();
         _loc2_.buttonFlags = PopUpBase.BUTTON_OKAY;
         _loc2_.keyboardFlags = PopUpBase.KEY_ENTER;
         _loc2_.message = resourceManager.getString(BUNDLE,"DLG_ERROR_TEXT_GENERAL",[param1.message]);
         _loc2_.title = resourceManager.getString(BUNDLE,"DLG_ERROR_TITLE");
         _loc2_.addEventListener(CloseEvent.CLOSE,this.onCloseError);
         _loc2_.show();
      }
      
      private function onSecondaryTimer(param1:TimerEvent) : void
      {
         var _loc2_:int = s_GetTibiaTimer();
         if(_loc2_ > this.m_CurrentOptionsLastUpload + this.m_CurrentOptionsUploadErrorDelay + OPTIONS_SAVE_INTERVAL)
         {
            this.saveOptions();
         }
         this.m_SecondaryTimestamp = _loc2_;
      }
      
      private function onConnectionCreated(param1:ConnectionEvent) : void
      {
         var _loc3_:Sessiondump = null;
         var _loc2_:IServerConnection = Tibia.s_GetConnection();
         if(_loc2_ is Connection)
         {
            if(this.m_CreatureStorage == null || this.m_CreatureStorage is CreatureStorage == false)
            {
               this.m_CreatureStorage = new CreatureStorage();
            }
            SessiondumpMouseShield.getInstance().hide();
         }
         else if(_loc2_ is Sessiondump)
         {
            _loc3_ = _loc2_ as Sessiondump;
            if(this.m_CreatureStorage == null || this.m_CreatureStorage is SessiondumpCreatureStorage == false)
            {
               this.m_CreatureStorage = new SessiondumpCreatureStorage();
            }
            SessiondumpMouseShield.getInstance().show();
         }
         this.m_Player = this.m_CreatureStorage.player;
         if(s_TutorialData != null)
         {
            this.m_Player.name = s_TutorialData["player-name"] as String;
         }
         this.m_PremiumManager = new PremiumManager(this.m_Player);
         this.m_UIStatusWidget.player = this.m_Player;
         this.m_UIWorldMapWidget.creatureStorage = this.m_CreatureStorage;
         this.m_UIWorldMapWidget.player = this.m_Player;
         this.m_UIWorldMapWidget.worldMapStorage = this.m_WorldMapStorage;
         this.m_Communication = new Communication(this.m_Connection,this.m_AppearanceStorage,this.m_ChatStorage,this.m_ContainerStorage,this.m_CreatureStorage,this.m_MiniMapStorage,this.m_Player,this.m_SpellStorage,this.m_WorldMapStorage);
      }
      
      [Bindable(event="propertyChange")]
      public function get m_UIBottomContainer() : HBox
      {
         return this._967396880m_UIBottomContainer;
      }
      
      public function set isFocusNotifierEnabled(param1:Boolean) : void
      {
         if(param1 != this.m_EnableFocusNotifier)
         {
            this.m_EnableFocusNotifier = param1;
            if(!this.m_EnableFocusNotifier)
            {
               FocusNotifier.getInstance().hide();
            }
         }
      }
      
      private function onConnectionLoginError(param1:ConnectionEvent) : void
      {
         visible = false;
         this.saveLocalData();
         this.saveOptions();
         var _loc2_:MessageWidget = new MessageWidget();
         _loc2_.buttonFlags = PopUpBase.BUTTON_OKAY;
         _loc2_.keyboardFlags = PopUpBase.KEY_ENTER;
         _loc2_.message = resourceManager.getString(BUNDLE,"DLG_LOGINERROR_TEXT",[param1.message]);
         _loc2_.title = resourceManager.getString(BUNDLE,"DLG_LOGINERROR_TITLE");
         _loc2_.addEventListener(CloseEvent.CLOSE,this.onCloseError);
         _loc2_.show();
      }
      
      private function _Tibia_StatusWidget1_i() : StatusWidget
      {
         var _loc1_:StatusWidget = new StatusWidget();
         this.m_UIStatusWidget = _loc1_;
         _loc1_.id = "m_UIStatusWidget";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function onCloseError(param1:CloseEvent) : void
      {
         var _loc2_:GameEvent = new GameEvent(GameEvent.CLOSE,true,false);
         dispatchEvent(_loc2_);
      }
      
      protected function releaseConnection() : void
      {
         if(this.m_Connection != null)
         {
            this.m_Connection.removeEventListener(ConnectionEvent.PENDING,this.onConnectionPending);
            this.m_Connection.removeEventListener(ConnectionEvent.GAME,this.onConnectionGame);
            this.m_Connection.removeEventListener(ConnectionEvent.CONNECTING,this.onConnectionConnecting);
            this.m_Connection.removeEventListener(ConnectionEvent.CONNECTION_LOST,this.onConnectionLost);
            this.m_Connection.removeEventListener(ConnectionEvent.CONNECTION_RECOVERED,this.onConnectionRecovered);
            this.m_Connection.removeEventListener(ConnectionEvent.DEAD,this.onConnectionDeath);
            this.m_Connection.removeEventListener(ConnectionEvent.DISCONNECTED,this.onConnectionDisconnected);
            this.m_Connection.removeEventListener(ConnectionEvent.ERROR,this.onConnectionError);
            this.m_Connection.removeEventListener(ConnectionEvent.LOGINCHALLENGE,this.onConnectionLoginChallenge);
            this.m_Connection.removeEventListener(ConnectionEvent.LOGINADVICE,this.onConnectionLoginAdvice);
            this.m_Connection.removeEventListener(ConnectionEvent.LOGINERROR,this.onConnectionLoginError);
            this.m_Connection.removeEventListener(ConnectionEvent.LOGINWAIT,this.onConnectionLoginWait);
            this.m_Connection.disconnect(false);
            this.m_Connection = null;
            this.m_ConnectionEstablishedAndPacketReceived = false;
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get m_UISideBarA() : SideBarWidget
      {
         return this._64278965m_UISideBarA;
      }
      
      [Bindable(event="propertyChange")]
      public function get m_UISideBarC() : SideBarWidget
      {
         return this._64278963m_UISideBarC;
      }
      
      [Bindable(event="propertyChange")]
      public function get m_UISideBarB() : SideBarWidget
      {
         return this._64278964m_UISideBarB;
      }
      
      [Bindable(event="propertyChange")]
      public function get m_UISideBarD() : SideBarWidget
      {
         return this._64278962m_UISideBarD;
      }
      
      private function onConnectionDeath(param1:ConnectionEvent) : void
      {
         visible = true;
         this.m_CharacterDeath = true;
         var _loc2_:Object = param1.data is Object?param1.data as Object:{
            "type":ConnectionEvent.DEATH_REGULAR,
            "fairFightFactor":0
         };
         var _loc3_:MessageWidget = new DeathMessageWidget();
         _loc3_.title = resourceManager.getString(BUNDLE,"DLG_DEAD_TITLE");
         if(_loc2_.type == ConnectionEvent.DEATH_UNFAIR)
         {
            _loc3_.message = resourceManager.getString(BUNDLE,"DLG_DEAD_TEXT_UNFAIR",[100 - _loc2_.fairFightFactor]);
         }
         else if(_loc2_.type == ConnectionEvent.DEATH_BLESSED)
         {
            _loc3_.message = resourceManager.getString(BUNDLE,"DLG_DEAD_TEXT_BLESSED");
         }
         else if(_loc2_.type == ConnectionEvent.DEATH_NOPENALTY)
         {
            _loc3_.message = resourceManager.getString(BUNDLE,"DLG_DEAD_TEXT_NOPENALTY");
         }
         else
         {
            _loc3_.message = resourceManager.getString(BUNDLE,"DLG_DEAD_TEXT_FAIR");
         }
         _loc3_.addEventListener(CloseEvent.CLOSE,this.onCloseDeath);
         _loc3_.show();
      }
      
      public function saveOptions() : void
      {
         if(this.m_Options != null)
         {
            this.m_ChatStorage.saveChannels();
            if(this.m_CurrentOptionsAsset != null && !this.m_CurrentOptionsUploading && this.m_CurrentOptionsDirty)
            {
               this.m_CurrentOptionsAsset.upload(this.options.marshall(),this.m_SessionKey);
               this.m_CurrentOptionsUploading = true;
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get m_UIWorldMapWindow() : GameWindowContainer
      {
         return this._1313911232m_UIWorldMapWindow;
      }
      
      protected function onDividerRelease(param1:DividerEvent) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         if(this.options != null && this.m_UIGameWindow != null && this.m_UIChatWidget != null)
         {
            _loc2_ = this.m_UIGameWindow.height;
            _loc3_ = this.m_UIChatWidget.height;
            if(!isNaN(this.m_UIChatWidget.minHeight) && Math.abs(_loc3_ - this.m_UIChatWidget.minHeight) < 0.01)
            {
               this.options.generalUIGameWindowHeight = 100;
            }
            else if(!isNaN(this.m_UIGameWindow.minHeight) && Math.abs(_loc2_ - this.m_UIGameWindow.minHeight) < 0.01)
            {
               this.options.generalUIGameWindowHeight = 0;
            }
            else
            {
               this.options.generalUIGameWindowHeight = _loc2_ * 100 / (_loc2_ + _loc3_);
            }
         }
      }
      
      public function ___Tibia_Application1_preinitialize(param1:FlexEvent) : void
      {
         this.onPreinitialise(param1);
      }
      
      private function onConnectionLoginChallenge(param1:ConnectionEvent) : void
      {
         this.m_ConnectionEstablishedAndPacketReceived = true;
      }
      
      private function _Tibia_GameWindowContainer1_i() : GameWindowContainer
      {
         var _loc1_:GameWindowContainer = new GameWindowContainer();
         this.m_UIWorldMapWindow = _loc1_;
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.center = this._Tibia_WorldMapWidget1_i();
         _loc1_.top = this._Tibia_HActionBarWidget1_i();
         _loc1_.bottom = this._Tibia_HActionBarWidget2_i();
         _loc1_.left = this._Tibia_VActionBarWidget1_i();
         _loc1_.right = this._Tibia_VActionBarWidget2_i();
         _loc1_.id = "m_UIWorldMapWindow";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function onCloseDeath(param1:CloseEvent) : void
      {
         if(param1.detail == PopUpBase.BUTTON_OKAY || param1.detail == DeathMessageWidget.EXTRA_BUTTON_STORE)
         {
            if(this.m_Communication != null)
            {
               this.m_Communication.sendCENTERWORLD();
               if(param1.detail == DeathMessageWidget.EXTRA_BUTTON_STORE)
               {
                  IngameShopManager.getInstance().openShopWindow(true,IngameShopProduct.SERVICE_TYPE_BLESSINGS,true);
               }
            }
         }
         else
         {
            this.m_ConnectionDataPending = -1;
            if(this.m_Communication != null)
            {
               this.m_Communication.disconnect(false);
            }
         }
      }
      
      public function get options() : OptionsStorage
      {
         return this.m_Options;
      }
      
      public function set m_UIOuterRootContainer(param1:DividedBox) : void
      {
         var _loc2_:Object = null;
         _loc2_ = this._1568861366m_UIOuterRootContainer;
         if(_loc2_ !== param1)
         {
            this._1568861366m_UIOuterRootContainer = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"m_UIOuterRootContainer",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get m_UIGameWindow() : GridContainer
      {
         return this._1404294856m_UIGameWindow;
      }
      
      [Bindable(event="propertyChange")]
      public function get m_UICenterColumn() : CustomDividedBox
      {
         return this._1356021457m_UICenterColumn;
      }
      
      public function set m_UIActionBarRight(param1:VActionBarWidget) : void
      {
         var _loc2_:Object = null;
         _loc2_ = this._2043305115m_UIActionBarRight;
         if(_loc2_ !== param1)
         {
            this._2043305115m_UIActionBarRight = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"m_UIActionBarRight",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get m_UISideBarToggleLeft() : ToggleBar
      {
         return this._2056921391m_UISideBarToggleLeft;
      }
      
      [Bindable(event="propertyChange")]
      public function get m_UIInputHandler() : InputHandler
      {
         return this._748017946m_UIInputHandler;
      }
      
      private function onUploadOptionsError(param1:ErrorEvent) : void
      {
         this.m_CurrentOptionsUploading = false;
         if(param1.errorID == -1)
         {
            this.m_CurrentOptionsUploadErrorDelay = 1000 * 60 * 60 * 24 * 365;
         }
         else
         {
            this.m_CurrentOptionsUploadErrorDelay = this.m_CurrentOptionsUploadErrorDelay == 0?2000:int(this.m_CurrentOptionsUploadErrorDelay * 2);
         }
      }
      
      private function _Tibia_WorldMapWidget1_i() : WorldMapWidget
      {
         var _loc1_:WorldMapWidget = new WorldMapWidget();
         this.m_UIWorldMapWidget = _loc1_;
         _loc1_.id = "m_UIWorldMapWidget";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      public function unload() : void
      {
         if(this.m_AppearanceStorage != null)
         {
            this.m_AppearanceStorage.removeEventListener(Event.COMPLETE,this.onAppearancesLoadComplete);
            this.m_AppearanceStorage.removeEventListener(ErrorEvent.ERROR,this.onAppearancesLoadError);
            this.m_AppearanceStorage.reset();
         }
         if(this.m_ChatStorage != null)
         {
            this.m_ChatStorage.reset();
         }
         if(this.m_ContainerStorage != null)
         {
            this.m_ContainerStorage.reset();
         }
         if(this.m_CreatureStorage != null)
         {
            this.m_CreatureStorage.reset();
         }
         if(this.m_MiniMapStorage != null)
         {
            this.m_MiniMapStorage.reset();
         }
         if(this.m_Player != null)
         {
            this.m_Player.reset();
         }
         if(this.m_SpellStorage != null)
         {
            this.m_SpellStorage.reset();
         }
         if(this.m_WorldMapStorage != null)
         {
            this.m_WorldMapStorage.reset();
         }
         this.releaseConnection();
         if(this.m_SeconaryTimer != null)
         {
            this.m_SeconaryTimer.stop();
         }
         if(this.m_UIInputHandler != null)
         {
            this.m_UIInputHandler.dispose();
         }
         CursorManager.getInstance().removeAllCursors();
         if(ContextMenuBase.getCurrent() != null)
         {
            ContextMenuBase.getCurrent().hide();
         }
         FocusNotifier.getInstance().hide();
         PopUpQueue.getInstance().hideByPriority(int.MAX_VALUE);
      }
      
      public function set m_UIStatusWidget(param1:StatusWidget) : void
      {
         var _loc2_:Object = null;
         _loc2_ = this._228925540m_UIStatusWidget;
         if(_loc2_ !== param1)
         {
            this._228925540m_UIStatusWidget = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"m_UIStatusWidget",_loc2_,param1));
         }
      }
      
      private function _Tibia_HActionBarWidget1_i() : HActionBarWidget
      {
         var _loc1_:HActionBarWidget = new HActionBarWidget();
         this.m_UIActionBarTop = _loc1_;
         _loc1_.styleName = "actionBarTop";
         _loc1_.id = "m_UIActionBarTop";
         BindingManager.executeBindings(this,"m_UIActionBarTop",this.m_UIActionBarTop);
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      [Bindable(event="propertyChange")]
      public function get m_UIStatusWidget() : StatusWidget
      {
         return this._228925540m_UIStatusWidget;
      }
      
      private function onConnectionGame(param1:ConnectionEvent) : void
      {
         if(this.m_ChatStorage != null)
         {
            this.m_ChatStorage.resetChannelActivationTimeout();
         }
         PopUpQueue.getInstance().hideByPriority(PopUpBase.DEFAULT_PRIORITY);
         if(ContextMenuBase.getCurrent() != null)
         {
            ContextMenuBase.getCurrent().hide();
         }
         visible = true;
         this.updateCombatTactics();
         this.m_CharacterDeath = false;
      }
      
      public function setAssetProvider(param1:IAssetProvider) : void
      {
         if(param1 == null)
         {
            throw new Error("Tibia.setAssetProvider: asset provider must not be null.");
         }
         this.m_AssetProvider = param1;
         var _loc2_:OptionsAsset = !!this.m_TutorialMode?this.m_AssetProvider.getDefaultOptionsTutorial():this.m_AssetProvider.getDefaultOptions();
         this.m_DefaultOptionsAsset = _loc2_;
         if(_loc2_ != null)
         {
            param1.removeAsset(_loc2_);
         }
         if(!this.m_TutorialMode)
         {
            this.setCurrentOptionsFromAssets(param1);
         }
         this.m_AppearanceStorage.setAssetProvider(param1);
      }
   }
}
