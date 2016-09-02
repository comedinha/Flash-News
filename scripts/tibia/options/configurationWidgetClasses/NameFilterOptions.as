package tibia.options.configurationWidgetClasses
{
   import mx.containers.HBox;
   import mx.controls.CheckBox;
   import tibia.chat.NameFilterSet;
   import mx.collections.ArrayCollection;
   import mx.controls.Label;
   import mx.containers.VBox;
   import tibia.options.ConfigurationWidget;
   import flash.events.Event;
   import tibia.options.OptionsStorage;
   import mx.collections.IList;
   
   public class NameFilterOptions extends HBox implements IOptionsEditor
   {
       
      
      protected var m_UIWhiteBuddies:CheckBox = null;
      
      protected var m_UIWhiteEnable:CheckBox = null;
      
      protected var m_UIBlackItems:tibia.options.configurationWidgetClasses.NameFilterListEditor = null;
      
      protected var m_UIBlackPrivate:CheckBox = null;
      
      private var m_UncommittedOptions:Boolean = false;
      
      private var m_UncommittedValues:Boolean = true;
      
      protected var m_UIBlackEnable:CheckBox = null;
      
      protected var m_UIWhiteItems:tibia.options.configurationWidgetClasses.NameFilterListEditor = null;
      
      protected var m_UIBlackYelling:CheckBox = null;
      
      protected var m_Options:OptionsStorage = null;
      
      private var m_UIConstructed:Boolean = false;
      
      public function NameFilterOptions()
      {
         super();
         label = resourceManager.getString(ConfigurationWidget.BUNDLE,"IGNORE_LABEL");
      }
      
      override protected function commitProperties() : void
      {
         var _loc1_:NameFilterSet = null;
         super.commitProperties();
         if(this.m_UncommittedOptions)
         {
            _loc1_ = null;
            if(this.m_Options != null)
            {
               _loc1_ = this.m_Options.getNameFilterSet(NameFilterSet.DEFAULT_SET);
            }
            if(_loc1_ != null)
            {
               this.m_UIBlackEnable.selected = _loc1_.blacklistEnabled;
               this.m_UIBlackPrivate.selected = _loc1_.blacklistPrivate;
               this.m_UIBlackYelling.selected = _loc1_.blacklistYelling;
               this.m_UIBlackItems.dataProvider = this.cloneList(_loc1_.blacklistItems);
               this.m_UIWhiteEnable.selected = _loc1_.whitelistEnabled;
               this.m_UIWhiteBuddies.selected = _loc1_.whitelistBuddies;
               this.m_UIWhiteItems.dataProvider = this.cloneList(_loc1_.whitelistItems);
            }
            else
            {
               this.m_UIBlackEnable.selected = false;
               this.m_UIBlackPrivate.selected = false;
               this.m_UIBlackYelling.selected = false;
               this.m_UIBlackItems.dataProvider = new ArrayCollection();
               this.m_UIWhiteEnable.selected = false;
               this.m_UIWhiteBuddies.selected = false;
               this.m_UIWhiteItems.dataProvider = new ArrayCollection();
            }
            this.m_UIBlackItems.enabled = this.m_UIBlackEnable.selected;
            this.m_UIBlackPrivate.enabled = this.m_UIBlackEnable.selected;
            this.m_UIBlackYelling.enabled = this.m_UIBlackEnable.selected;
            this.m_UIWhiteItems.enabled = this.m_UIWhiteEnable.selected;
            this.m_UIWhiteBuddies.enabled = this.m_UIWhiteEnable.selected;
            this.m_UncommittedOptions = false;
         }
      }
      
      override protected function createChildren() : void
      {
         var Bx:VBox = null;
         var Lbl:Label = null;
         if(!this.m_UIConstructed)
         {
            super.createChildren();
            Bx = new VBox();
            Bx.percentWidth = 50;
            Bx.percentHeight = 100;
            Bx.styleName = "optionsConfigurationWidgetRootContainer";
            this.m_UIBlackEnable = new CheckBox();
            this.m_UIBlackEnable.label = resourceManager.getString(ConfigurationWidget.BUNDLE,"IGNORE_CHECK_IGNORE_LIST_ACTIVE");
            this.m_UIBlackEnable.styleName = this;
            this.m_UIBlackEnable.addEventListener(Event.CHANGE,function(param1:Event):void
            {
               m_UIBlackItems.enabled = m_UIBlackEnable.selected;
               m_UIBlackYelling.enabled = m_UIBlackEnable.selected;
               m_UIBlackPrivate.enabled = m_UIBlackEnable.selected;
            });
            this.m_UIBlackEnable.addEventListener(Event.CHANGE,this.onValueChange);
            Bx.addChild(this.m_UIBlackEnable);
            Lbl = new Label();
            Lbl.text = resourceManager.getString(ConfigurationWidget.BUNDLE,"IGNORE_LBL_IGNORE_LIST_CHARACTERS");
            Lbl.setStyle("fontWeight","bold");
            Bx.addChild(Lbl);
            this.m_UIBlackItems = new tibia.options.configurationWidgetClasses.NameFilterListEditor();
            this.m_UIBlackItems.height = 250;
            this.m_UIBlackItems.percentHeight = NaN;
            this.m_UIBlackItems.percentWidth = 100;
            this.m_UIBlackItems.styleName = getStyle("blackListEditorStyle");
            this.m_UIBlackItems.setStyle("disabledOverlayAlpha",0);
            Bx.addChild(this.m_UIBlackItems);
            Lbl = new Label();
            Lbl.text = resourceManager.getString(ConfigurationWidget.BUNDLE,"IGNORE_LBL_IGNORE_LIST_GLOBAL");
            Lbl.setStyle("fontWeight","bold");
            Bx.addChild(Lbl);
            this.m_UIBlackYelling = new CheckBox();
            this.m_UIBlackYelling.label = resourceManager.getString(ConfigurationWidget.BUNDLE,"IGNORE_CHECK_IGNORE_LIST_YELLING");
            this.m_UIBlackYelling.styleName = this;
            this.m_UIBlackYelling.addEventListener(Event.CHANGE,this.onValueChange);
            Bx.addChild(this.m_UIBlackYelling);
            this.m_UIBlackPrivate = new CheckBox();
            this.m_UIBlackPrivate.label = resourceManager.getString(ConfigurationWidget.BUNDLE,"IGNORE_CHECK_IGNORE_LIST_PRIVATE");
            this.m_UIBlackPrivate.styleName = this;
            this.m_UIBlackPrivate.addEventListener(Event.CHANGE,this.onValueChange);
            Bx.addChild(this.m_UIBlackPrivate);
            addChild(Bx);
            Bx = new VBox();
            Bx.percentWidth = 50;
            Bx.percentHeight = 100;
            Bx.styleName = "optionsConfigurationWidgetRootContainer";
            this.m_UIWhiteEnable = new CheckBox();
            this.m_UIWhiteEnable.label = resourceManager.getString(ConfigurationWidget.BUNDLE,"IGNORE_CHECK_WHITE_LIST_ACTIVE");
            this.m_UIWhiteEnable.styleName = this;
            this.m_UIWhiteEnable.addEventListener(Event.CHANGE,function(param1:Event):void
            {
               m_UIWhiteItems.enabled = m_UIWhiteEnable.selected;
               m_UIWhiteBuddies.enabled = m_UIWhiteEnable.selected;
            });
            this.m_UIWhiteEnable.addEventListener(Event.CHANGE,this.onValueChange);
            Bx.addChild(this.m_UIWhiteEnable);
            Lbl = new Label();
            Lbl.text = resourceManager.getString(ConfigurationWidget.BUNDLE,"IGNORE_LBL_WHITE_LIST_CHARACTERS");
            Lbl.setStyle("fontWeight","bold");
            Bx.addChild(Lbl);
            this.m_UIWhiteItems = new tibia.options.configurationWidgetClasses.NameFilterListEditor();
            this.m_UIWhiteItems.height = 250;
            this.m_UIWhiteItems.percentHeight = NaN;
            this.m_UIWhiteItems.percentWidth = 100;
            this.m_UIWhiteItems.styleName = getStyle("whiteListEditorStyle");
            this.m_UIWhiteItems.setStyle("disabledOverlayAlpha",0);
            Bx.addChild(this.m_UIWhiteItems);
            Lbl = new Label();
            Lbl.text = resourceManager.getString(ConfigurationWidget.BUNDLE,"IGNORE_LBL_WHITE_LIST_GLOBAL");
            Lbl.setStyle("fontWeight","bold");
            Bx.addChild(Lbl);
            this.m_UIWhiteBuddies = new CheckBox();
            this.m_UIWhiteBuddies.label = resourceManager.getString(ConfigurationWidget.BUNDLE,"IGNORE_CHECK_WHITE_LIST_BUDDY");
            this.m_UIWhiteBuddies.styleName = this;
            this.m_UIWhiteBuddies.addEventListener(Event.CHANGE,this.onValueChange);
            Bx.addChild(this.m_UIWhiteBuddies);
            addChild(Bx);
            this.m_UIConstructed = true;
         }
      }
      
      public function get options() : OptionsStorage
      {
         return this.m_Options;
      }
      
      private function onValueChange(param1:Event) : void
      {
         var _loc2_:OptionsEditorEvent = null;
         if(param1 != null)
         {
            _loc2_ = new OptionsEditorEvent(OptionsEditorEvent.VALUE_CHANGE);
            dispatchEvent(_loc2_);
         }
      }
      
      private function cloneList(param1:IList, param2:IList = null) : IList
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc3_:IList = null;
         if(param1 != null)
         {
            _loc3_ = param2 != null?param2:new ArrayCollection();
            _loc3_.removeAll();
            _loc4_ = 0;
            _loc5_ = param1.length;
            while(_loc4_ < _loc5_)
            {
               _loc3_.addItem(param1.getItemAt(_loc4_).clone());
               _loc4_++;
            }
         }
         return _loc3_;
      }
      
      public function set options(param1:OptionsStorage) : void
      {
         this.m_Options = param1;
         this.m_UncommittedOptions = true;
         invalidateProperties();
      }
      
      public function close(param1:Boolean = false) : void
      {
         var _loc2_:NameFilterSet = null;
         if(this.m_Options != null && param1 && this.m_UncommittedValues)
         {
            _loc2_ = new NameFilterSet(NameFilterSet.DEFAULT_SET);
            _loc2_.blacklistEnabled = this.m_UIBlackEnable.selected;
            _loc2_.blacklistPrivate = this.m_UIBlackPrivate.selected;
            _loc2_.blacklistYelling = this.m_UIBlackYelling.selected;
            this.cloneList(this.m_UIBlackItems.dataProvider,_loc2_.blacklistItems);
            _loc2_.whitelistEnabled = this.m_UIWhiteEnable.selected;
            _loc2_.whitelistBuddies = this.m_UIWhiteBuddies.selected;
            this.cloneList(this.m_UIWhiteItems.dataProvider,_loc2_.whitelistItems);
            this.m_Options.addNameFilterSet(_loc2_);
            this.m_UncommittedValues = false;
         }
      }
   }
}
