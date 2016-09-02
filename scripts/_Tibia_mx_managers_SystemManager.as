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
            "compiledResourceBundleNames":["ActionBarWidget","ActionButtonConfigurationWidget","BattlelistWidget","BodyContainerViewWidget","BuddylistWidget","BugReportWidget","ChannelSelectionWidget","CharacterProfileWidget","CharacterSelectionWidget","ChatStorage","ChatWidget","CombatControlWidget","Communication","Connection","ContainerViewWidget","DeathMessageWidget","EditBuddyWidget","EditListWidget","EditMarkWidget","EditTextWidget","GeneralButtonsWidget","Global","IngameShopWidget","InputHandler","MarketWidget","MessageMode","MiniMapWidget","NPCTradeWidget","ObjectContextMenu","OptionsConfigurationWidget","PremiumWidget","QuestLogWidget","ReportWidget","SafeTradeWidget","SelectOutfitWidget","SharedResources","SideBarHeader","SpellListWidget","SplitStackWidget","StaticAction","StatusWidget","Tibia","TutorialHintWidget","UnjustPointsWidget","WorldMapStorage","collections","containers","controls","core","effects","formatters","skins","styles","utils"],
            "currentDomain":ApplicationDomain.currentDomain,
            "deactivate":"onActivation(event)",
            "layout":"absolute",
            "mainClassName":"Tibia",
            "mixins":["_Tibia_FlexInit","_DividedBoxStyle","_alertButtonStyleStyle","_FormHeadingStyle","_SWFLoaderStyle","_FormStyle","_headerDateTextStyle","_todayStyleStyle","_windowStylesStyle","_FormItemLabelStyle","_TextInputStyle","_dateFieldPopupStyle","_ApplicationControlBarStyle","_FormItemStyle","_ComboBoxStyle","_dataGridStylesStyle","_TabStyle","_headerDragProxyStyleStyle","_popUpMenuStyle","_TabNavigatorStyle","_HSliderStyle","_DragManagerStyle","_windowStatusStyle","_TextAreaStyle","_ContainerStyle","_swatchPanelTextFieldStyle","_ButtonBarStyle","_RadioButtonStyle","_textAreaHScrollBarStyleStyle","_MenuBarStyle","_comboDropdownStyle","_CheckBoxStyle","_ButtonStyle","_linkButtonStyleStyle","_richTextEditorTextAreaStyleStyle","_ControlBarStyle","_textAreaVScrollBarStyleStyle","_globalStyle","_ListBaseStyle","_TabBarStyle","_ApplicationStyle","_TileListStyle","_ToolTipStyle","_CursorManagerStyle","_ButtonBarButtonStyle","_opaquePanelStyle","_errorTipStyle","_MenuStyle","_TreeStyle","_DataGridStyle","_HRuleStyle","_activeTabStyleStyle","_ScrollBarStyle","_plainStyle","_activeButtonStyleStyle","_DataGridItemRendererStyle","_weekDayStyleStyle","_TibiaWatcherSetupUtil"],
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
