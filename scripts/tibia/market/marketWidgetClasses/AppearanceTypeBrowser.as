package tibia.market.marketWidgetClasses
{
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import mx.collections.ArrayCollection;
   import mx.collections.Sort;
   import mx.containers.HBox;
   import mx.containers.VBox;
   import mx.containers.ViewStack;
   import mx.controls.Button;
   import mx.controls.Spacer;
   import mx.controls.TabBar;
   import mx.controls.listClasses.ListBase;
   import mx.core.ClassFactory;
   import mx.core.EventPriority;
   import mx.core.ScrollPolicy;
   import mx.core.mx_internal;
   import mx.events.FlexEvent;
   import mx.events.IndexChangedEvent;
   import mx.events.ListEvent;
   import shared.controls.CustomButton;
   import shared.controls.CustomList;
   import shared.controls.CustomTileList;
   import shared.controls.SimpleTabBar;
   import shared.utility.closure;
   import tibia.appearances.AppearanceStorage;
   import tibia.appearances.AppearanceType;
   import tibia.game.PopUpBase;
   import tibia.market.MarketWidget;
   import tibia.options.OptionsStorage;
   
   public class AppearanceTypeBrowser extends VBox implements IAppearanceTypeFilterEditor
   {
      
      private static const ACTION_NONE:int = 0;
      
      private static const BUNDLE:String = "MarketWidget";
      
      public static const LAYOUT_TILE:int = 1;
      
      public static const EDITOR_CATEGORY:int = 0;
      
      public static const LAYOUT_LIST:int = 0;
      
      public static const FILTER_CHANGE:String = "filterChange";
      
      private static const ACTION_CONTEXT_MENU:int = 3;
      
      public static const EDITOR_NAME:int = 1;
       
      
      private var m_AppearanceTypes:Array = null;
      
      private var m_UIEditorStack:ViewStack = null;
      
      private var m_UncommittedLayout:Boolean = true;
      
      private var m_Editor:int = 0;
      
      private var m_FilterFunction:Function = null;
      
      private var m_UncommittedDepot:Boolean = true;
      
      private var m_UncommittedAppearanceTypes:Boolean = false;
      
      private var m_UncommittedSelectedType:int = 0;
      
      private var m_SelectedType:AppearanceType = null;
      
      private var m_UIViewToggle:Button = null;
      
      private var m_UIConstructed:Boolean = false;
      
      private var m_UIEditor:Vector.<IAppearanceTypeFilterEditor>;
      
      private var m_UIDepot:Button = null;
      
      private var m_Depot:Boolean = false;
      
      private var m_AppearanceTypesView:ArrayCollection = null;
      
      private var m_Layout:int = 1;
      
      private var m_UncommittedEditor:Boolean = false;
      
      private var m_UncommittedFilterFunction:Boolean = false;
      
      private var m_UIEditorToggle:TabBar = null;
      
      private var m_UIView:ListBase = null;
      
      private var m_CreationComplete:Boolean = false;
      
      public function AppearanceTypeBrowser()
      {
         this.m_UIEditor = new Vector.<IAppearanceTypeFilterEditor>();
         super();
         var _loc1_:Sort = new Sort();
         _loc1_.compareFunction = Utility.compareAppearanceType;
         this.m_AppearanceTypesView = new ArrayCollection();
         this.m_AppearanceTypesView.sort = _loc1_;
         var _loc2_:AppearanceStorage = Tibia.s_GetAppearanceStorage();
         if(_loc2_ != null)
         {
            this.appearanceTypes = _loc2_.marketObjectTypes;
         }
         var _loc3_:OptionsStorage = Tibia.s_GetOptions();
         if(_loc3_ != null)
         {
            this.viewLayout = _loc3_.marketBrowserLayout;
            this.filterEditor = _loc3_.marketBrowserEditor;
            this.filterDepot = _loc3_.marketBrowserDepot;
         }
         var _loc4_:MarketWidget = PopUpBase.getCurrent() as MarketWidget;
         if(_loc4_ != null)
         {
            _loc4_.addEventListener(MarketWidget.DEPOT_CONTENT_CHANGE,this.onFilterChange,false,EventPriority.DEFAULT,true);
         }
         addEventListener(FlexEvent.CREATION_COMPLETE,this.onCreationComplete);
      }
      
      private function get filterEditor() : int
      {
         return this.m_Editor;
      }
      
      private function set filterEditor(param1:int) : void
      {
         if(param1 != EDITOR_CATEGORY && param1 != EDITOR_NAME)
         {
            param1 = EDITOR_CATEGORY;
         }
         if(this.m_Editor != param1)
         {
            this.m_Editor = param1;
            this.m_UncommittedEditor = true;
            this.invalidateFilterFunction();
            invalidateProperties();
         }
      }
      
      public function invalidateFilterFunction() : void
      {
         this.m_FilterFunction = null;
         dispatchEvent(new Event(FILTER_CHANGE));
         this.m_UncommittedFilterFunction = true;
         invalidateProperties();
      }
      
      private function get filterDepot() : Boolean
      {
         return this.m_Depot;
      }
      
      private function set _selectedType(param1:AppearanceType) : void
      {
         if(this.m_SelectedType != param1)
         {
            this.m_SelectedType = param1;
            this.m_UncommittedSelectedType = 1;
            invalidateProperties();
            dispatchEvent(new Event(Event.CHANGE));
         }
      }
      
      public function get viewLayout() : int
      {
         return this.m_Layout;
      }
      
      private function onCreationComplete(param1:Event) : void
      {
         removeEventListener(FlexEvent.CREATION_COMPLETE,this.onCreationComplete);
         this.m_CreationComplete = true;
         this.invalidateFilterFunction();
      }
      
      private function onViewMouseEvent(param1:MouseEvent) : void
      {
         var _loc2_:ListBase = null;
         var _loc3_:AppearanceTypeTileRenderer = null;
         var _loc4_:AppearanceType = null;
         var _loc5_:int = 0;
         if(param1 != null)
         {
            _loc2_ = param1.currentTarget as ListBase;
            _loc3_ = _loc2_ != null?_loc2_.mx_internal::mouseEventToItemRendererOrEditor(param1) as AppearanceTypeTileRenderer:null;
            _loc4_ = _loc3_ != null?_loc3_.data as AppearanceType:null;
            _loc5_ = ACTION_NONE;
            if(param1.type == MouseEvent.CLICK && !param1.altKey && !param1.ctrlKey && !param1.shiftKey)
            {
               _loc5_ = ACTION_NONE;
            }
            else if(param1.altKey)
            {
               _loc5_ = ACTION_NONE;
            }
            else if(param1.ctrlKey)
            {
               _loc5_ = ACTION_CONTEXT_MENU;
            }
            else if(param1.shiftKey)
            {
               _loc5_ = ACTION_NONE;
            }
            else
            {
               _loc5_ = ACTION_CONTEXT_MENU;
            }
            switch(_loc5_)
            {
               case ACTION_CONTEXT_MENU:
            }
         }
      }
      
      override protected function createChildren() : void
      {
         var _TabContainer:VBox = null;
         var _FilterContainer:VBox = null;
         var _ViewContainer:VBox = null;
         var _BarContainer:HBox = null;
         var _Spacer:Spacer = null;
         if(!this.m_UIConstructed)
         {
            super.createChildren();
            setStyle("horizontalGap",0);
            setStyle("verticalGap",0);
            setStyle("paddingBottom",0);
            setStyle("paddingLeft",0);
            setStyle("paddingRight",0);
            setStyle("paddingTop",0);
            _TabContainer = new VBox();
            _TabContainer.percentHeight = 100;
            _TabContainer.percentWidth = 100;
            _TabContainer.styleName = "marketWidgetRootContainer";
            _TabContainer.setStyle("verticalGap",4);
            _FilterContainer = new VBox();
            _FilterContainer.percentWidth = 100;
            _FilterContainer.styleName = "marketWidgetFilter";
            this.m_UIEditorStack = new ViewStack();
            this.m_UIEditorStack.height = 70;
            this.m_UIEditorStack.percentWidth = 100;
            this.m_UIEditorStack.addEventListener(IndexChangedEvent.CHANGE,function(param1:Event):void
            {
               filterEditor = m_UIEditorStack.selectedIndex;
            });
            _FilterContainer.addChild(this.m_UIEditorStack);
            this.m_UIEditor[EDITOR_CATEGORY] = new AppearanceTypeCategoryFilterEditor();
            this.m_UIEditor[EDITOR_CATEGORY].percentHeight = 100;
            this.m_UIEditor[EDITOR_CATEGORY].percentWidth = 100;
            this.m_UIEditor[EDITOR_CATEGORY].addEventListener(FILTER_CHANGE,this.onFilterChange);
            this.m_UIEditor[EDITOR_CATEGORY].setStyle("borderColor","");
            this.m_UIEditor[EDITOR_CATEGORY].setStyle("borderStyle","none");
            this.m_UIEditor[EDITOR_CATEGORY].setStyle("borderThickness",0);
            this.m_UIEditor[EDITOR_CATEGORY].setStyle("horizontalAlign","center");
            this.m_UIEditor[EDITOR_CATEGORY].setStyle("horizontalGap",2);
            this.m_UIEditor[EDITOR_CATEGORY].setStyle("verticalAlign","middle");
            this.m_UIEditor[EDITOR_CATEGORY].setStyle("verticalGap",2);
            this.m_UIEditorStack.addChild(this.m_UIEditor[0] as DisplayObject);
            this.m_UIEditor[EDITOR_NAME] = new AppearanceTypeNameFilterEditor();
            this.m_UIEditor[EDITOR_NAME].percentHeight = 100;
            this.m_UIEditor[EDITOR_NAME].percentWidth = 100;
            this.m_UIEditor[EDITOR_NAME].addEventListener(FILTER_CHANGE,this.onFilterChange);
            this.m_UIEditor[EDITOR_NAME].setStyle("borderColor","");
            this.m_UIEditor[EDITOR_NAME].setStyle("borderStyle","none");
            this.m_UIEditor[EDITOR_NAME].setStyle("borderThickness",0);
            this.m_UIEditor[EDITOR_NAME].setStyle("horizontalAlign","center");
            this.m_UIEditor[EDITOR_NAME].setStyle("horizontalGap",2);
            this.m_UIEditor[EDITOR_NAME].setStyle("verticalAlign","middle");
            this.m_UIEditor[EDITOR_NAME].setStyle("verticalGap",2);
            this.m_UIEditorStack.addChild(this.m_UIEditor[1] as DisplayObject);
            this.m_UIDepot = new CustomButton();
            this.m_UIDepot.label = resourceManager.getString(BUNDLE,"RESTRICT_DEPOT_LABEL");
            this.m_UIDepot.percentWidth = 100;
            this.m_UIDepot.toggle = true;
            this.m_UIDepot.toolTip = resourceManager.getString(BUNDLE,"RESTRICT_DEPOT_TOOLTIP");
            this.m_UIDepot.addEventListener(Event.CHANGE,function(param1:Event):void
            {
               filterDepot = m_UIDepot.selected;
            });
            this.m_UIDepot.setStyle("fontSize",9);
            this.m_UIDepot.setStyle("paddingLeft",0);
            this.m_UIDepot.setStyle("paddingRight",0);
            _FilterContainer.addChild(this.m_UIDepot);
            _TabContainer.addChild(_FilterContainer);
            _ViewContainer = new VBox();
            _ViewContainer.percentHeight = 100;
            _ViewContainer.percentWidth = 100;
            _ViewContainer.styleName = "marketWidgetView";
            this.m_UIView = this.createFilterView(this.viewLayout);
            this.m_UIView.dataProvider = this.m_AppearanceTypesView;
            this.m_UIView.selectedItem = this.selectedType;
            this.m_UIView.verticalScrollPosition = 0;
            this.m_UIView.addEventListener(ListEvent.CHANGE,this.onSelectedTypeChange);
            this.m_UIView.addEventListener(MouseEvent.CLICK,this.onViewMouseEvent);
            this.m_UIView.addEventListener(MouseEvent.RIGHT_CLICK,this.onViewMouseEvent);
            _ViewContainer.addChild(this.m_UIView);
            _TabContainer.addChild(_ViewContainer);
            _BarContainer = new HBox();
            _BarContainer.percentWidth = 100;
            _BarContainer.setStyle("horizontalGap",0);
            this.m_UIEditorToggle = new SimpleTabBar();
            this.m_UIEditorToggle.dataProvider = this.m_UIEditorStack;
            this.m_UIEditorToggle.styleName = "marketWidgetTabNavigator";
            this.m_UIEditorToggle.setStyle("paddingBottom",-1);
            this.m_UIEditorToggle.setStyle("paddingLeft",0);
            this.m_UIEditorToggle.setStyle("paddingRight",0);
            this.m_UIEditorToggle.setStyle("paddingTop",0);
            this.m_UIEditorToggle.setStyle("tabWidth",55);
            _BarContainer.addChild(this.m_UIEditorToggle);
            _Spacer = new Spacer();
            _Spacer.percentWidth = 100;
            _BarContainer.addChild(_Spacer);
            this.m_UIViewToggle = new CustomButton();
            this.m_UIViewToggle.selected = this.viewLayout == LAYOUT_TILE;
            this.m_UIViewToggle.styleName = "marketWidgetViewToggle";
            this.m_UIViewToggle.toggle = true;
            this.m_UIViewToggle.addEventListener(Event.CHANGE,function(param1:Event):void
            {
               if(viewLayout == LAYOUT_TILE)
               {
                  viewLayout = LAYOUT_LIST;
               }
               else
               {
                  viewLayout = LAYOUT_TILE;
               }
            });
            _BarContainer.addChild(this.m_UIViewToggle);
            addChild(_BarContainer);
            addChild(_TabContainer);
            this.m_UIConstructed = true;
         }
      }
      
      private function set filterDepot(param1:Boolean) : void
      {
         if(this.m_Depot != param1)
         {
            this.m_Depot = param1;
            this.m_UncommittedDepot = true;
            this.invalidateFilterFunction();
            invalidateProperties();
         }
      }
      
      private function onFilterChange(param1:Event) : void
      {
         this.invalidateFilterFunction();
      }
      
      override protected function commitProperties() : void
      {
         var _loc3_:IAppearanceTypeFilterEditor = null;
         super.commitProperties();
         var _loc1_:OptionsStorage = Tibia.s_GetOptions();
         if(this.m_UncommittedAppearanceTypes)
         {
            this.m_AppearanceTypesView.filterFunction = this.filterFunction;
            this.m_AppearanceTypesView.source = this.appearanceTypes;
            this.m_AppearanceTypesView.refresh();
            this.m_UncommittedAppearanceTypes = false;
         }
         var _loc2_:Boolean = false;
         if(this.m_UncommittedSelectedType == 2)
         {
            for each(_loc3_ in this.m_UIEditor)
            {
               _loc3_.adjustFilterFunction(this._selectedType);
            }
            this.adjustFilterFunction(this._selectedType);
            this.m_UncommittedSelectedType = 1;
         }
         if(this.m_UncommittedFilterFunction)
         {
            this.m_AppearanceTypesView.filterFunction = this.filterFunction;
            this.m_AppearanceTypesView.refresh();
            if(this.filterFunction != null && !this.filterFunction(this._selectedType))
            {
               this._selectedType = null;
            }
            _loc2_ = true;
            this.m_UncommittedFilterFunction = false;
         }
         if(this.m_UncommittedSelectedType == 1)
         {
            this.m_UIView.selectedItem = this._selectedType;
            _loc2_ = true;
            this.m_UncommittedSelectedType = 0;
         }
         if(this.m_UncommittedLayout)
         {
            if(_loc1_ != null)
            {
               _loc1_.marketBrowserLayout = this.viewLayout;
            }
            this.m_UIView.removeEventListener(ListEvent.CHANGE,this.onSelectedTypeChange);
            this.m_UIView.removeEventListener(MouseEvent.CLICK,this.onViewMouseEvent);
            this.m_UIView.removeEventListener(MouseEvent.RIGHT_CLICK,this.onViewMouseEvent);
            this.m_UIView = this.replaceChild(this.m_UIView,this.createFilterView(this.viewLayout)) as ListBase;
            this.m_UIView.dataProvider = this.m_AppearanceTypesView;
            this.m_UIView.selectedItem = this.selectedType;
            this.m_UIView.verticalScrollPosition = 0;
            this.m_UIView.addEventListener(ListEvent.CHANGE,this.onSelectedTypeChange);
            this.m_UIView.addEventListener(MouseEvent.CLICK,this.onViewMouseEvent);
            this.m_UIView.addEventListener(MouseEvent.RIGHT_CLICK,this.onViewMouseEvent);
            this.m_UIViewToggle.selected = this.viewLayout == LAYOUT_TILE;
            this.m_UncommittedLayout = false;
         }
         if(this.m_UncommittedDepot)
         {
            if(_loc1_ != null)
            {
               _loc1_.marketBrowserDepot = this.filterDepot;
            }
            this.m_UIDepot.selected = this.filterDepot;
            this.m_UncommittedDepot = false;
         }
         if(this.m_UncommittedEditor)
         {
            if(_loc1_ != null)
            {
               _loc1_.marketBrowserEditor = this.filterEditor;
            }
            this.m_UIEditorStack.selectedIndex = this.filterEditor;
            this.m_UncommittedEditor = false;
         }
         if(_loc2_)
         {
            if(this.m_UIView.selectedIndex > -1)
            {
               this.m_UIView.validateNow();
            }
            if(this.m_UIView.selectedIndex > -1)
            {
               this.m_UIView.scrollToIndex(this.m_UIView.selectedIndex);
            }
            else
            {
               this.m_UIView.verticalScrollPosition = 0;
            }
            _loc2_ = false;
         }
      }
      
      private function onSelectedTypeChange(param1:ListEvent) : void
      {
         var _loc2_:ListBase = null;
         if(param1 != null && (_loc2_ = param1.currentTarget as ListBase) != null)
         {
            this._selectedType = _loc2_.selectedItem as AppearanceType;
         }
      }
      
      private function replaceChild(param1:DisplayObject, param2:DisplayObject) : DisplayObject
      {
         var _loc3_:DisplayObjectContainer = null;
         _loc3_ = param1.parent;
         var _loc4_:int = _loc3_.getChildIndex(param1);
         _loc3_.removeChildAt(_loc4_);
         return _loc3_.addChildAt(param2,_loc4_);
      }
      
      private function createFilterView(param1:int) : ListBase
      {
         var _loc3_:ClassFactory = null;
         var _loc2_:ListBase = null;
         switch(param1)
         {
            case LAYOUT_LIST:
               _loc2_ = new CustomList();
               _loc2_.itemRenderer = new ClassFactory(AppearanceTypeListRenderer);
               _loc2_.setStyle("backgroundAlpha",0.5);
               _loc2_.setStyle("backgroundColor",undefined);
               _loc2_.setStyle("alternatingItemAlphas",[0.5,0.5]);
               _loc2_.setStyle("alternatingItemColors",[2768716,1977654]);
               _loc2_.setStyle("rollOverColor",undefined);
               _loc2_.setStyle("selectionColor",undefined);
               _loc2_.setStyle("paddingBottom",1);
               _loc2_.setStyle("paddingTop",1);
               break;
            case LAYOUT_TILE:
               _loc3_ = new ClassFactory();
               _loc3_.generator = AppearanceTypeTileRenderer;
               _loc3_.properties = {
                  "height":36,
                  "width":36,
                  "horizontalScrollPolicy":ScrollPolicy.OFF,
                  "verticalScrollPolicy":ScrollPolicy.OFF,
                  "styleName":{
                     "paddingLeft":1,
                     "paddingRight":1,
                     "paddingTop":1,
                     "paddingBottom":1
                  }
               };
               _loc2_ = new CustomTileList();
               _loc2_.columnCount = 4;
               _loc2_.columnWidth = _loc3_.properties.width;
               _loc2_.itemRenderer = _loc3_;
               _loc2_.rowHeight = _loc3_.properties.height;
               _loc2_.setStyle("backgroundColor",0);
               _loc2_.setStyle("backgroundAlpha",0);
               _loc2_.setStyle("borderAlpha",0);
               _loc2_.setStyle("borderColor",0);
               _loc2_.setStyle("borderStyle","none");
               _loc2_.setStyle("borderThickness",0);
               _loc2_.setStyle("paddingBottom",0);
               _loc2_.setStyle("paddingTop",0);
         }
         _loc2_.percentHeight = 100;
         _loc2_.percentWidth = 100;
         _loc2_.verticalScrollPolicy = ScrollPolicy.ON;
         return _loc2_;
      }
      
      private function get _selectedType() : AppearanceType
      {
         return this.m_SelectedType;
      }
      
      public function adjustFilterFunction(param1:AppearanceType) : void
      {
         if(param1 == null || !param1.isMarket)
         {
            return;
         }
         var _loc2_:MarketWidget = PopUpBase.getCurrent() as MarketWidget;
         this.filterDepot = this.filterDepot && (_loc2_ != null && _loc2_.getDepotAmount(param1) > 0);
      }
      
      public function set viewLayout(param1:int) : void
      {
         if(param1 != LAYOUT_LIST && param1 != LAYOUT_TILE)
         {
            param1 = LAYOUT_TILE;
         }
         if(this.m_Layout != param1)
         {
            this.m_Layout = param1;
            this.m_UncommittedLayout = true;
            invalidateProperties();
         }
      }
      
      public function set selectedType(param1:*) : void
      {
         param1 = this.mapToAppearanceTypes(param1);
         if(this._selectedType != param1)
         {
            this._selectedType = param1;
            this.m_UncommittedSelectedType = 2;
            invalidateProperties();
         }
      }
      
      public function get appearanceTypes() : Array
      {
         return this.m_AppearanceTypes;
      }
      
      public function get filterFunction() : Function
      {
         var Market:MarketWidget = null;
         var Filter:Function = null;
         if(this.m_FilterFunction == null && this.m_CreationComplete)
         {
            Market = null;
            if(this.filterDepot)
            {
               Market = PopUpBase.getCurrent() as MarketWidget;
            }
            Filter = null;
            if(this.filterEditor > -1)
            {
               Filter = this.m_UIEditor[this.filterEditor].filterFunction;
            }
            this.m_FilterFunction = closure({
               "market":Market,
               "filter":Filter
            },function(param1:AppearanceType):Boolean
            {
               return param1 != null && param1.isMarket && (this["market"] == null || this["market"].getDepotAmount(param1)) && (this["filter"] == null || this["filter"](param1));
            });
         }
         return this.m_FilterFunction;
      }
      
      public function set appearanceTypes(param1:Array) : void
      {
         if(this.m_AppearanceTypes != param1)
         {
            this.m_AppearanceTypes = param1;
            this.m_UncommittedAppearanceTypes = true;
            invalidateProperties();
            this._selectedType = null;
         }
      }
      
      public function get selectedType() : AppearanceType
      {
         return this._selectedType;
      }
      
      private function mapToAppearanceTypes(param1:*) : AppearanceType
      {
         var _loc3_:AppearanceType = null;
         var _loc2_:int = -1;
         if(param1 is AppearanceType && AppearanceType(param1).isMarket)
         {
            _loc2_ = AppearanceType(param1).marketTradeAs;
         }
         else
         {
            _loc2_ = int(param1);
         }
         for each(_loc3_ in this.appearanceTypes)
         {
            if(_loc3_.marketTradeAs == _loc2_)
            {
               return _loc3_;
            }
         }
         return null;
      }
   }
}
