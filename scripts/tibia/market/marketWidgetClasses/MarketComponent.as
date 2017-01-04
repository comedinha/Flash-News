package tibia.market.marketWidgetClasses
{
   import flash.events.Event;
   import mx.containers.Box;
   import tibia.appearances.AppearanceStorage;
   import tibia.appearances.AppearanceType;
   import tibia.market.MarketWidget;
   
   public class MarketComponent extends Box implements ITypeComponent
   {
       
      
      private var m_Market:MarketWidget = null;
      
      private var m_SelectedType:AppearanceType = null;
      
      public function MarketComponent(param1:MarketWidget)
      {
         super();
         this.m_Market = param1;
      }
      
      public function get selectedType() : AppearanceType
      {
         return this.m_SelectedType;
      }
      
      public function set selectedType(param1:*) : void
      {
         var _loc2_:AppearanceStorage = Tibia.s_GetAppearanceStorage();
         if(_loc2_ != null)
         {
            param1 = _loc2_.getMarketObjectType(param1);
         }
         else
         {
            param1 = null;
         }
         if(this.m_SelectedType != param1)
         {
            this.m_SelectedType = param1;
            dispatchEvent(new Event(MarketWidget.SELECTED_TYPE_CHANGE,true,false));
         }
      }
      
      public function get market() : MarketWidget
      {
         return this.m_Market;
      }
   }
}
