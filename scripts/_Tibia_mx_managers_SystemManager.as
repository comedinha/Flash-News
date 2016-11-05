package
{
   import mx.managers.SystemManager;
   import mx.core.IFlexModuleFactory;
   import mx.core.IFlexModule;
   import flash.system.Security;
   import flash.system.ApplicationDomain;
   import tibia.controls.CustomDownloadProgressBar;
   import flash.utils.Dictionary;
   import mx.core.FlexVersion;
   
   public class _Tibia_mx_managers_SystemManager extends SystemManager implements IFlexModuleFactory
   {
       
      
      private var _preloadedRSLs:Dictionary;
      
      public function _Tibia_mx_managers_SystemManager()
      {
         FlexVersion.compatibilityVersionString = "3.0.0";
         super();
      }
      
      override public function create(... rest) : Object
      {
         if(rest.length > 0 && !(rest[0] is String))
         {
            return super.create.apply(this,rest);
         }
         var _loc2_:String = rest.length == 0?"Tibia":String(rest[0]);
         var _loc3_:Class = Class(getDefinitionByName(_loc2_));
         if(!_loc3_)
         {
            return null;
         }
         var _loc4_:Object = new _loc3_();
         if(_loc4_ is IFlexModule)
         {
            IFlexModule(_loc4_).moduleFactory = this;
         }
         return _loc4_;
      }
      
      override public function allowInsecureDomain(... rest) : void
      {
         var _loc2_:* = null;
         Security.allowInsecureDomain(rest);
         for(_loc2_ in this._preloadedRSLs)
         {
            if(_loc2_.content && "allowInsecureDomainInRSL" in _loc2_.content)
            {
               _loc2_.content["allowInsecureDomainInRSL"](rest);
            }
         }
      }
      
      override public function info() : Object
      {
         return {
            "activate":"onActivation(event)",
            "applicationComplete":"onApplicationComplete(event)",
            "compiledLocales":["en_US"],
            "compiledResourceBundleNames":["ActionBarWidget","ActionButtonConfigurationWidget","BattlelistWidget","BodyContainerViewWidget","BuddylistWidget","BugReportWidget","ChannelSelectionWidget","CharacterProfileWidget","CharacterSelectionWidget","ChatStorage","ChatWidget","CombatControlWidget","Communication","Connection","ContainerViewWidget","DeathMessageWidget","EditBuddyWidget","EditListWidget","EditMarkWidget","EditTextWidget","GeneralButtonsWidget","Global","ImbuingWidget","IngameShopWidget","InputHandler","MarketWidget","MessageMode","MiniMapWidget","NPCTradeWidget","ObjectContextMenu","OptionsConfigurationWidget","PremiumWidget","PreyWidget","QuestLogWidget","ReportWidget","SafeTradeWidget","SelectOutfitWidget","SharedResources","SideBarHeader","SpellListWidget","SplitStackWidget","StaticAction","StatusWidget","Tibia","TutorialHintWidget","UnjustPointsWidget","WorldMapStorage","collections","containers","controls","core","effects","formatters","skins","styles","utils"],
            "currentDomain":ApplicationDomain.currentDomain,
            "deactivate":"onActivation(event)",
            "layout":"absolute",
            "mainClassName":"Tibia",
            "mixins":["_Tibia_FlexInit","_headerDateTextStyle","_dataGridStylesStyle","_ComboBoxStyle","_FormHeadingStyle","_errorTipStyle","_activeTabStyleStyle","_textAreaHScrollBarStyleStyle","_DataGridItemRendererStyle","_weekDayStyleStyle","_RadioButtonStyle","_windowStatusStyle","_ButtonStyle","_SWFLoaderStyle","_ToolTipStyle","_popUpMenuStyle","_globalStyle","_ApplicationControlBarStyle","_ButtonBarStyle","_DataGridStyle","_ButtonBarButtonStyle","_TabStyle","_FormItemLabelStyle","_HSliderStyle","_dateFieldPopupStyle","_TabBarStyle","_ScrollBarStyle","_todayStyleStyle","_FormItemStyle","_plainStyle","_windowStylesStyle","_CheckBoxStyle","_TabNavigatorStyle","_richTextEditorTextAreaStyleStyle","_FormStyle","_DragManagerStyle","_TextInputStyle","_swatchPanelTextFieldStyle","_headerDragProxyStyleStyle","_ControlBarStyle","_HRuleStyle","_activeButtonStyleStyle","_ListBaseStyle","_CursorManagerStyle","_alertButtonStyleStyle","_linkButtonStyleStyle","_textAreaVScrollBarStyleStyle","_MenuBarStyle","_ContainerStyle","_TreeStyle","_DividedBoxStyle","_opaquePanelStyle","_ApplicationStyle","_comboDropdownStyle","_TileListStyle","_MenuStyle","_TextAreaStyle","_TibiaWatcherSetupUtil"],
            "preinitialize":"onPreinitialise(event)",
            "preloader":CustomDownloadProgressBar
         };
      }
      
      override public function get preloadedRSLs() : Dictionary
      {
         if(this._preloadedRSLs == null)
         {
            this._preloadedRSLs = new Dictionary(true);
         }
         return this._preloadedRSLs;
      }
      
      override public function allowDomain(... rest) : void
      {
         var _loc2_:* = null;
         Security.allowDomain(rest);
         for(_loc2_ in this._preloadedRSLs)
         {
            if(_loc2_.content && "allowDomainInRSL" in _loc2_.content)
            {
               _loc2_.content["allowDomainInRSL"](rest);
            }
         }
      }
   }
}
