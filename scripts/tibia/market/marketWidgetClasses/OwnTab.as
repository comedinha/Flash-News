package tibia.market.marketWidgetClasses
{
   import tibia.market.MarketWidget;
   import mx.containers.TabNavigator;
   import flash.events.Event;
   import shared.controls.SimpleTabNavigator;
   import mx.events.IndexChangedEvent;
   import mx.containers.BoxDirection;
   
   public class OwnTab extends MarketComponent implements IViewContainer
   {
      
      private static const BUNDLE:String = "MarketWidget";
       
      
      private var m_UIViewHistory:tibia.market.marketWidgetClasses.OwnHistoryView = null;
      
      private var m_UIViewNavigator:TabNavigator = null;
      
      private var m_UIConstructed:Boolean = false;
      
      private var m_UncommittedSelectedView:Boolean = true;
      
      private var m_SelectedView:uint = 3;
      
      private var m_UIViewOffers:tibia.market.marketWidgetClasses.OwnOffersView = null;
      
      public function OwnTab(param1:MarketWidget)
      {
         super(param1);
         direction = BoxDirection.VERTICAL;
         label = resourceManager.getString(BUNDLE,"OWN_OFFERS_LABEL");
      }
      
      public function get selectedView() : uint
      {
         return this.m_SelectedView;
      }
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
         if(this.m_UncommittedSelectedView)
         {
            switch(this.m_SelectedView)
            {
               case MarketWidget.VIEW_OWN_OFFERS:
                  this.m_UIViewNavigator.selectedChild = this.m_UIViewOffers;
                  break;
               case MarketWidget.VIEW_OWN_HISTORY:
                  this.m_UIViewNavigator.selectedChild = this.m_UIViewHistory;
            }
            this.m_UncommittedSelectedView = false;
         }
      }
      
      public function set selectedView(param1:uint) : void
      {
         if(this.m_SelectedView != param1 && (param1 == MarketWidget.VIEW_OWN_OFFERS || param1 == MarketWidget.VIEW_OWN_HISTORY))
         {
            this.m_SelectedView = param1;
            this.m_UncommittedSelectedView = true;
            invalidateProperties();
            dispatchEvent(new Event(MarketWidget.SELECTED_VIEW_CHANGE,true,false));
         }
      }
      
      private function onViewChange(param1:Event) : void
      {
         if(param1 != null)
         {
            switch(this.m_UIViewNavigator.selectedChild)
            {
               case this.m_UIViewOffers:
                  this.selectedView = MarketWidget.VIEW_OWN_OFFERS;
                  break;
               case this.m_UIViewHistory:
                  this.selectedView = MarketWidget.VIEW_OWN_HISTORY;
            }
         }
      }
      
      override protected function createChildren() : void
      {
         if(!this.m_UIConstructed)
         {
            super.createChildren();
            this.m_UIViewNavigator = new SimpleTabNavigator();
            this.m_UIViewNavigator.percentHeight = 100;
            this.m_UIViewNavigator.percentWidth = 100;
            this.m_UIViewNavigator.styleName = "marketWidgetTabNavigator";
            this.m_UIViewNavigator.addEventListener(IndexChangedEvent.CHANGE,this.onViewChange);
            this.m_UIViewNavigator.setStyle("tabWidth",95);
            addChild(this.m_UIViewNavigator);
            this.m_UIViewOffers = new tibia.market.marketWidgetClasses.OwnOffersView(market);
            this.m_UIViewOffers.percentHeight = 100;
            this.m_UIViewOffers.percentWidth = 100;
            this.m_UIViewOffers.styleName = "marketWidgetRootContainer";
            this.m_UIViewOffers.setStyle("borderAlpha",undefined);
            this.m_UIViewOffers.setStyle("borderColor",undefined);
            this.m_UIViewOffers.setStyle("borderStyle","none");
            this.m_UIViewOffers.setStyle("borderThickness",undefined);
            this.m_UIViewNavigator.addChild(this.m_UIViewOffers);
            this.m_UIViewHistory = new tibia.market.marketWidgetClasses.OwnHistoryView(market);
            this.m_UIViewHistory.percentHeight = 100;
            this.m_UIViewHistory.percentWidth = 100;
            this.m_UIViewHistory.styleName = "marketWidgetRootContainer";
            this.m_UIViewHistory.setStyle("borderAlpha",undefined);
            this.m_UIViewHistory.setStyle("borderColor",undefined);
            this.m_UIViewHistory.setStyle("borderStyle","none");
            this.m_UIViewHistory.setStyle("borderThickness",undefined);
            this.m_UIViewNavigator.addChild(this.m_UIViewHistory);
            this.m_UIConstructed = true;
         }
      }
   }
}
