package tibia.market.marketWidgetClasses
{
   import tibia.market.MarketWidget;
   import flash.events.Event;
   import tibia.appearances.AppearanceStorage;
   import mx.controls.Label;
   import mx.containers.VBox;
   import mx.containers.HBox;
   import tibia.appearances.widgetClasses.SkinnedAppearanceRenderer;
   import shared.controls.CustomLabel;
   import mx.containers.ViewStack;
   import mx.events.IndexChangedEvent;
   import shared.controls.SimpleTabBar;
   import mx.controls.TabBar;
   import mx.containers.BoxDirection;
   
   public class MarketTab extends MarketComponent implements IViewContainer
   {
      
      private static const BUNDLE:String = "MarketWidget";
       
      
      private var m_UIBrowser:tibia.market.marketWidgetClasses.AppearanceTypeBrowser = null;
      
      private var m_UncommittedSelectedView:Boolean = true;
      
      private var m_SelectedView:uint = 0;
      
      private var m_UIViewDetails:tibia.market.marketWidgetClasses.MarketDetailsView = null;
      
      private var m_UIName:Label = null;
      
      private var m_UIViewStack:ViewStack = null;
      
      private var m_UIViewToggle:TabBar = null;
      
      private var m_UncommittedSelectedType:Boolean = false;
      
      private var m_UIViewStatistics:tibia.market.marketWidgetClasses.MarketStatisticsView = null;
      
      private var m_UIConstructed:Boolean = false;
      
      private var m_UIViewOffers:tibia.market.marketWidgetClasses.MarketOffersView = null;
      
      private var m_UIEditor:tibia.market.marketWidgetClasses.MarketOfferEditor = null;
      
      private var m_UIIcon:SkinnedAppearanceRenderer = null;
      
      public function MarketTab(param1:MarketWidget)
      {
         super(param1);
         direction = BoxDirection.HORIZONTAL;
         label = resourceManager.getString(BUNDLE,"MARKET_OFFERS_LABEL");
      }
      
      public function set selectedView(param1:uint) : void
      {
         if(this.m_SelectedView != param1 && (param1 == MarketWidget.VIEW_MARKET_OFFERS || param1 == MarketWidget.VIEW_MARKET_DETAILS || param1 == MarketWidget.VIEW_MARKET_STATISTICS))
         {
            this.m_SelectedView = param1;
            this.m_UncommittedSelectedView = true;
            invalidateProperties();
            dispatchEvent(new Event(MarketWidget.SELECTED_VIEW_CHANGE,true,false));
         }
      }
      
      private function onTypeChange(param1:Event) : void
      {
         if(param1 != null)
         {
            this.selectedType = this.m_UIBrowser.selectedType;
         }
      }
      
      override protected function commitProperties() : void
      {
         var _loc1_:AppearanceStorage = null;
         super.commitProperties();
         if(this.m_UncommittedSelectedView)
         {
            switch(this.m_SelectedView)
            {
               case MarketWidget.VIEW_MARKET_OFFERS:
                  this.m_UIViewStack.selectedChild = this.m_UIViewOffers;
                  break;
               case MarketWidget.VIEW_MARKET_DETAILS:
                  this.m_UIViewStack.selectedChild = this.m_UIViewDetails;
                  break;
               case MarketWidget.VIEW_MARKET_STATISTICS:
                  this.m_UIViewStack.selectedChild = this.m_UIViewStatistics;
            }
            this.m_UncommittedSelectedView = false;
         }
         if(this.m_UncommittedSelectedType)
         {
            if(selectedType != null)
            {
               _loc1_ = Tibia.s_GetAppearanceStorage();
               this.m_UIIcon.appearance = _loc1_ != null?_loc1_.getObjectType(selectedType.marketShowAs):null;
               this.m_UIName.text = selectedType.marketName;
            }
            else
            {
               this.m_UIIcon.appearance = null;
               this.m_UIName.text = resourceManager.getString(BUNDLE,"MARKET_OFFERS_NO_TYPE");
            }
            this.m_UIBrowser.selectedType = selectedType;
            this.m_UIViewOffers.selectedType = selectedType;
            this.m_UIViewDetails.selectedType = selectedType;
            this.m_UIViewStatistics.selectedType = selectedType;
            this.m_UIEditor.selectedType = selectedType;
            this.m_UncommittedSelectedType = false;
         }
      }
      
      override protected function createChildren() : void
      {
         var _loc1_:VBox = null;
         var _loc2_:VBox = null;
         var _loc3_:HBox = null;
         var _loc4_:VBox = null;
         if(!this.m_UIConstructed)
         {
            super.createChildren();
            this.m_UIBrowser = new tibia.market.marketWidgetClasses.AppearanceTypeBrowser();
            this.m_UIBrowser.percentHeight = 100;
            this.m_UIBrowser.width = 177;
            this.m_UIBrowser.addEventListener(Event.CHANGE,this.onTypeChange);
            addChild(this.m_UIBrowser);
            _loc1_ = new VBox();
            _loc1_.percentHeight = 100;
            _loc1_.percentWidth = 100;
            _loc1_.setStyle("horizontalGap",0);
            _loc1_.setStyle("verticalGap",0);
            _loc1_.setStyle("paddingBottom",0);
            _loc1_.setStyle("paddingLeft",0);
            _loc1_.setStyle("paddingRight",0);
            _loc1_.setStyle("paddingTop",0);
            _loc2_ = new VBox();
            _loc2_.percentHeight = 100;
            _loc2_.percentWidth = 100;
            _loc2_.styleName = "marketWidgetRootContainer";
            _loc3_ = new HBox();
            _loc3_.percentHeight = NaN;
            _loc3_.percentWidth = 100;
            _loc3_.setStyle("horizontalAlign","left");
            _loc3_.setStyle("vertcialAlign","middle");
            _loc3_.setStyle("fontSize",12);
            _loc3_.setStyle("fontWeight","bold");
            this.m_UIIcon = new SkinnedAppearanceRenderer();
            _loc3_.addChild(this.m_UIIcon);
            this.m_UIName = new CustomLabel();
            this.m_UIName.percentHeight = NaN;
            this.m_UIName.percentWidth = 100;
            this.m_UIName.text = resourceManager.getString(BUNDLE,"MARKET_OFFERS_NO_TYPE");
            this.m_UIName.truncateToFit = true;
            _loc3_.addChild(this.m_UIName);
            _loc2_.addChild(_loc3_);
            this.m_UIViewStack = new ViewStack();
            this.m_UIViewStack.percentHeight = 100;
            this.m_UIViewStack.percentWidth = 100;
            this.m_UIViewStack.addEventListener(IndexChangedEvent.CHANGE,this.onViewChange);
            _loc2_.addChild(this.m_UIViewStack);
            this.m_UIViewOffers = new tibia.market.marketWidgetClasses.MarketOffersView(market);
            this.m_UIViewOffers.percentHeight = 100;
            this.m_UIViewOffers.percentWidth = 100;
            this.m_UIViewOffers.styleName = "marketWidgetView";
            this.m_UIViewStack.addChild(this.m_UIViewOffers);
            this.m_UIViewDetails = new tibia.market.marketWidgetClasses.MarketDetailsView(market);
            this.m_UIViewDetails.percentHeight = 100;
            this.m_UIViewDetails.percentWidth = 100;
            this.m_UIViewDetails.styleName = "marketWidgetView";
            this.m_UIViewStack.addChild(this.m_UIViewDetails);
            this.m_UIViewStatistics = new tibia.market.marketWidgetClasses.MarketStatisticsView(market);
            this.m_UIViewStatistics.percentHeight = 100;
            this.m_UIViewStatistics.percentWidth = 100;
            this.m_UIViewStatistics.styleName = "marketWidgetView";
            this.m_UIViewStack.addChild(this.m_UIViewStatistics);
            this.m_UIEditor = new tibia.market.marketWidgetClasses.MarketOfferEditor(market);
            this.m_UIEditor.percentHeight = NaN;
            this.m_UIEditor.percentWidth = 100;
            this.m_UIEditor.styleName = "marketWidgetView";
            _loc2_.addChild(this.m_UIEditor);
            _loc4_ = new VBox();
            _loc4_.percentHeight = NaN;
            _loc4_.percentWidth = 100;
            _loc4_.setStyle("horizontalAlign","right");
            this.m_UIViewToggle = new SimpleTabBar();
            this.m_UIViewToggle.dataProvider = this.m_UIViewStack;
            this.m_UIViewToggle.percentHeight = NaN;
            this.m_UIViewToggle.percentWidth = NaN;
            this.m_UIViewToggle.styleName = "marketWidgetTabNavigator";
            this.m_UIViewToggle.setStyle("paddingBottom",-1);
            this.m_UIViewToggle.setStyle("paddingLeft",0);
            this.m_UIViewToggle.setStyle("paddingRight",0);
            this.m_UIViewToggle.setStyle("paddingTop",0);
            this.m_UIViewToggle.setStyle("tabWidth",65);
            _loc4_.addChild(this.m_UIViewToggle);
            _loc1_.addChild(_loc4_);
            _loc1_.addChild(_loc2_);
            addChild(_loc1_);
            this.m_UIConstructed = true;
         }
      }
      
      public function get selectedView() : uint
      {
         return this.m_SelectedView;
      }
      
      override public function set selectedType(param1:*) : void
      {
         if(selectedType != param1)
         {
            super.selectedType = param1;
            this.m_UncommittedSelectedType = true;
            invalidateProperties();
         }
      }
      
      private function onViewChange(param1:Event) : void
      {
         if(param1 != null)
         {
            switch(this.m_UIViewStack.selectedChild)
            {
               case this.m_UIViewOffers:
                  this.selectedView = MarketWidget.VIEW_MARKET_OFFERS;
                  break;
               case this.m_UIViewDetails:
                  this.selectedView = MarketWidget.VIEW_MARKET_DETAILS;
                  break;
               case this.m_UIViewStatistics:
                  this.selectedView = MarketWidget.VIEW_MARKET_STATISTICS;
            }
         }
      }
   }
}
