package tibia.market.marketWidgetClasses
{
   import flash.events.Event;
   import mx.containers.BoxDirection;
   import mx.containers.Form;
   import mx.containers.FormHeading;
   import mx.containers.FormItem;
   import mx.controls.Label;
   import mx.core.ScrollPolicy;
   import shared.utility.i18n.i18nFormatNumber;
   import tibia.market.MarketWidget;
   import tibia.market.Offer;
   import tibia.market.OfferStatistics;
   
   public class MarketStatisticsView extends MarketComponent
   {
      
      private static const BUNDLE:String = "MarketWidget";
       
      
      private var m_UIBuyMaximum:Label = null;
      
      private var m_UISellTransactions:Label = null;
      
      private var m_UISellMinimum:Label = null;
      
      private var m_UISellAverage:Label = null;
      
      private var m_UncommittedSelectedType:Boolean = false;
      
      private var m_UISellMaximum:Label = null;
      
      private var m_UIBuyMinimum:Label = null;
      
      private var m_UIConstructed:Boolean = false;
      
      private var m_UIBuyTransactions:Label = null;
      
      private var m_UIBuyAverage:Label = null;
      
      public function MarketStatisticsView(param1:MarketWidget)
      {
         super(param1);
         direction = BoxDirection.VERTICAL;
         label = resourceManager.getString(BUNDLE,"MARKET_STATISTICS_VIEW_LABEL");
         horizontalScrollPolicy = ScrollPolicy.OFF;
         market.addEventListener(MarketWidget.BROWSE_DETAILS_CHANGE,this.onStatisticsChange);
      }
      
      private function resetForm() : void
      {
         var _loc1_:Label = null;
         for each(_loc1_ in [this.m_UIBuyTransactions,this.m_UIBuyAverage,this.m_UIBuyMaximum,this.m_UIBuyMinimum,this.m_UISellTransactions,this.m_UISellAverage,this.m_UISellMaximum,this.m_UISellMinimum])
         {
            _loc1_.text = resourceManager.getString(BUNDLE,"MARKET_STATISTICS_VIEW_EMPTY");
         }
      }
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
         if(this.m_UncommittedSelectedType)
         {
            this.resetForm();
            this.m_UncommittedSelectedType = false;
         }
      }
      
      override protected function createChildren() : void
      {
         var _loc1_:Form = null;
         var _loc2_:FormHeading = null;
         var _loc3_:FormItem = null;
         if(!this.m_UIConstructed)
         {
            super.createChildren();
            _loc1_ = new Form();
            _loc1_.percentHeight = 100;
            _loc1_.percentWidth = 100;
            _loc1_.setStyle("paddingBottom",0);
            _loc1_.setStyle("paddingLeft",0);
            _loc1_.setStyle("paddingRight",0);
            _loc1_.setStyle("paddingTop",0);
            _loc1_.setStyle("horizontalGap",8);
            _loc1_.setStyle("verticalGap",6);
            _loc2_ = new FormHeading();
            _loc2_.label = resourceManager.getString(BUNDLE,"MARKET_STATISTICS_VIEW_BUYOFFERS");
            _loc1_.addChild(_loc2_);
            _loc3_ = new FormItem();
            _loc3_.label = resourceManager.getString(BUNDLE,"MARKET_STATISTICS_VIEW_TOTALTRANSACTIONS");
            this.m_UIBuyTransactions = new Label();
            this.m_UIBuyTransactions.text = resourceManager.getString(BUNDLE,"MARKET_STATISTICS_VIEW_EMPTY");
            this.m_UIBuyTransactions.setStyle("fontWeight","bold");
            _loc3_.addChild(this.m_UIBuyTransactions);
            _loc1_.addChild(_loc3_);
            _loc3_ = new FormItem();
            _loc3_.label = resourceManager.getString(BUNDLE,"MARKET_STATISTICS_VIEW_MAXIMUM");
            this.m_UIBuyMaximum = new Label();
            this.m_UIBuyMaximum.text = resourceManager.getString(BUNDLE,"MARKET_STATISTICS_VIEW_EMPTY");
            this.m_UIBuyMaximum.setStyle("fontWeight","bold");
            _loc3_.addChild(this.m_UIBuyMaximum);
            _loc1_.addChild(_loc3_);
            _loc3_ = new FormItem();
            _loc3_.label = resourceManager.getString(BUNDLE,"MARKET_STATISTICS_VIEW_AVERAGE");
            this.m_UIBuyAverage = new Label();
            this.m_UIBuyAverage.text = resourceManager.getString(BUNDLE,"MARKET_STATISTICS_VIEW_EMPTY");
            this.m_UIBuyAverage.setStyle("fontWeight","bold");
            _loc3_.addChild(this.m_UIBuyAverage);
            _loc1_.addChild(_loc3_);
            _loc3_ = new FormItem();
            _loc3_.label = resourceManager.getString(BUNDLE,"MARKET_STATISTICS_VIEW_MINIMUM");
            this.m_UIBuyMinimum = new Label();
            this.m_UIBuyMinimum.text = resourceManager.getString(BUNDLE,"MARKET_STATISTICS_VIEW_EMPTY");
            this.m_UIBuyMinimum.setStyle("fontWeight","bold");
            _loc3_.addChild(this.m_UIBuyMinimum);
            _loc1_.addChild(_loc3_);
            _loc2_ = new FormHeading();
            _loc2_.label = resourceManager.getString(BUNDLE,"MARKET_STATISTICS_VIEW_SELLOFFERS");
            _loc1_.addChild(_loc2_);
            _loc3_ = new FormItem();
            _loc3_.label = resourceManager.getString(BUNDLE,"MARKET_STATISTICS_VIEW_TOTALTRANSACTIONS");
            this.m_UISellTransactions = new Label();
            this.m_UISellTransactions.text = resourceManager.getString(BUNDLE,"MARKET_STATISTICS_VIEW_EMPTY");
            this.m_UISellTransactions.setStyle("fontWeight","bold");
            _loc3_.addChild(this.m_UISellTransactions);
            _loc1_.addChild(_loc3_);
            _loc3_ = new FormItem();
            _loc3_.label = resourceManager.getString(BUNDLE,"MARKET_STATISTICS_VIEW_MAXIMUM");
            this.m_UISellMaximum = new Label();
            this.m_UISellMaximum.text = resourceManager.getString(BUNDLE,"MARKET_STATISTICS_VIEW_EMPTY");
            this.m_UISellMaximum.setStyle("fontWeight","bold");
            _loc3_.addChild(this.m_UISellMaximum);
            _loc1_.addChild(_loc3_);
            _loc3_ = new FormItem();
            _loc3_.label = resourceManager.getString(BUNDLE,"MARKET_STATISTICS_VIEW_AVERAGE");
            this.m_UISellAverage = new Label();
            this.m_UISellAverage.text = resourceManager.getString(BUNDLE,"MARKET_STATISTICS_VIEW_EMPTY");
            this.m_UISellAverage.setStyle("fontWeight","bold");
            _loc3_.addChild(this.m_UISellAverage);
            _loc1_.addChild(_loc3_);
            _loc3_ = new FormItem();
            _loc3_.label = resourceManager.getString(BUNDLE,"MARKET_STATISTICS_VIEW_MINIMUM");
            this.m_UISellMinimum = new Label();
            this.m_UISellMinimum.text = resourceManager.getString(BUNDLE,"MARKET_STATISTICS_VIEW_EMPTY");
            this.m_UISellMinimum.setStyle("fontWeight","bold");
            _loc3_.addChild(this.m_UISellMinimum);
            _loc1_.addChild(_loc3_);
            addChild(_loc1_);
            this.m_UIConstructed = true;
         }
      }
      
      private function onStatisticsChange(param1:Event) : void
      {
         var _loc2_:OfferStatistics = null;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         if(param1 != null)
         {
            _loc2_ = null;
            _loc3_ = 0;
            _loc4_ = 0;
            _loc5_ = 0;
            _loc6_ = 0;
            if(market.browseStatistics != null)
            {
               _loc3_ = _loc4_ = 0;
               _loc5_ = Number.NEGATIVE_INFINITY;
               _loc6_ = Number.POSITIVE_INFINITY;
               for each(_loc2_ in market.browseStatistics)
               {
                  if(_loc2_.kind == Offer.BUY_OFFER)
                  {
                     _loc3_ = _loc3_ + _loc2_.totalTransactions;
                     _loc4_ = _loc4_ + _loc2_.totalPrice;
                     if(_loc2_.maximumPrice > _loc5_)
                     {
                        _loc5_ = _loc2_.maximumPrice;
                     }
                     if(_loc2_.minimumPrice < _loc6_)
                     {
                        _loc6_ = _loc2_.minimumPrice;
                     }
                  }
               }
               _loc5_ = Math.max(0,_loc5_);
               _loc6_ = Math.min(_loc6_,_loc5_);
               this.m_UIBuyTransactions.text = String(_loc3_);
               this.m_UIBuyAverage.text = _loc3_ > 0?i18nFormatNumber(Math.round(_loc4_ / _loc3_)):"0";
               this.m_UIBuyMaximum.text = i18nFormatNumber(_loc5_);
               this.m_UIBuyMinimum.text = i18nFormatNumber(_loc6_);
               _loc3_ = _loc4_ = 0;
               _loc5_ = Number.NEGATIVE_INFINITY;
               _loc6_ = Number.POSITIVE_INFINITY;
               for each(_loc2_ in market.browseStatistics)
               {
                  if(_loc2_.kind == Offer.SELL_OFFER)
                  {
                     _loc3_ = _loc3_ + _loc2_.totalTransactions;
                     _loc4_ = _loc4_ + _loc2_.totalPrice;
                     if(_loc2_.maximumPrice > _loc5_)
                     {
                        _loc5_ = _loc2_.maximumPrice;
                     }
                     if(_loc2_.minimumPrice < _loc6_)
                     {
                        _loc6_ = _loc2_.minimumPrice;
                     }
                  }
               }
               _loc5_ = Math.max(0,_loc5_);
               _loc6_ = Math.min(_loc6_,_loc5_);
               this.m_UISellTransactions.text = String(_loc3_);
               this.m_UISellAverage.text = _loc3_ > 0?i18nFormatNumber(Math.round(_loc4_ / _loc3_)):"0";
               this.m_UISellMaximum.text = i18nFormatNumber(_loc5_);
               this.m_UISellMinimum.text = i18nFormatNumber(_loc6_);
            }
            else
            {
               this.resetForm();
            }
         }
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
   }
}
