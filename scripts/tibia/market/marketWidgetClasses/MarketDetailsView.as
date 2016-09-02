package tibia.market.marketWidgetClasses
{
   import tibia.market.MarketWidget;
   import flash.events.Event;
   import mx.controls.Text;
   import mx.containers.FormItem;
   import mx.containers.Form;
   import mx.core.ScrollPolicy;
   import mx.containers.BoxDirection;
   
   public class MarketDetailsView extends MarketComponent
   {
      
      private static const FIELDS:Array = [{
         "index":MarketWidget.DETAIL_FIELD_DESCRIPTION,
         "name":"DETAIL_FIELD_DESCRIPTION"
      },{
         "index":MarketWidget.DETAIL_FIELD_CAPACITY,
         "name":"DETAIL_FIELD_CAPACITY"
      },{
         "index":MarketWidget.DETAIL_FIELD_RUNE_SPELL,
         "name":"DETAIL_FIELD_RUNE_SPELL"
      },{
         "index":MarketWidget.DETAIL_FIELD_WEIGHT,
         "name":"DETAIL_FIELD_WEIGHT"
      },{
         "index":MarketWidget.DETAIL_FIELD_WEAPON_TYPE,
         "name":"DETAIL_FIELD_WEAPON_TYPE"
      },{
         "index":MarketWidget.DETAIL_FIELD_ATTACK,
         "name":"DETAIL_FIELD_ATTACK"
      },{
         "index":MarketWidget.DETAIL_FIELD_ARMOR,
         "name":"DETAIL_FIELD_ARMOR"
      },{
         "index":MarketWidget.DETAIL_FIELD_DEFENCE,
         "name":"DETAIL_FIELD_DEFENCE"
      },{
         "index":MarketWidget.DETAIL_FIELD_PROTECTION,
         "name":"DETAIL_FIELD_PROTECTION"
      },{
         "index":MarketWidget.DETAIL_FIELD_SKILLBOOST,
         "name":"DETAIL_FIELD_SKILLBOOST"
      },{
         "index":MarketWidget.DETAIL_FIELD_EXPIRE,
         "name":"DETAIL_FIELD_EXPIRE"
      },{
         "index":MarketWidget.DETAIL_FIELD_USES,
         "name":"DETAIL_FIELD_USES"
      },{
         "index":MarketWidget.DETAIL_FIELD_RESTRICT_LEVEL,
         "name":"DETAIL_FIELD_RESTRICT_LEVEL"
      },{
         "index":MarketWidget.DETAIL_FIELD_RESTRICT_MAGICLEVEL,
         "name":"DETAIL_FIELD_RESTRICT_MAGICLEVEL"
      },{
         "index":MarketWidget.DETAIL_FIELD_RESTRICT_PROFESSION,
         "name":"DETAIL_FIELD_RESTRICT_PROFESSION"
      }];
      
      private static const BUNDLE:String = "MarketWidget";
       
      
      private var m_UIConstructed:Boolean = false;
      
      private var m_UncommittedSelectedType:Boolean = false;
      
      private var m_UIForm:Form = null;
      
      public function MarketDetailsView(param1:MarketWidget)
      {
         super(param1);
         direction = BoxDirection.VERTICAL;
         label = resourceManager.getString(BUNDLE,"MARKET_DETAILS_VIEW_LABEL");
         market.addEventListener(MarketWidget.BROWSE_DETAILS_CHANGE,this.onDetailsChange);
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
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
         if(this.m_UncommittedSelectedType)
         {
            this.m_UIForm.removeAllChildren();
            this.m_UncommittedSelectedType = false;
         }
      }
      
      private function onDetailsChange(param1:Event) : void
      {
         var _loc2_:int = 0;
         var _loc3_:String = null;
         var _loc4_:Text = null;
         var _loc5_:FormItem = null;
         if(param1 != null)
         {
            this.m_UIForm.removeAllChildren();
            if(market == null || market.browseDetail == null || market.browseDetail.length != FIELDS.length)
            {
               return;
            }
            _loc2_ = 0;
            while(_loc2_ < FIELDS.length)
            {
               _loc3_ = market.browseDetail[FIELDS[_loc2_].index];
               if(_loc3_ != null && _loc3_.length > 0)
               {
                  _loc4_ = new Text();
                  _loc4_.text = _loc3_;
                  _loc4_.width = 250;
                  _loc4_.setStyle("fontWeight","bold");
                  _loc5_ = new FormItem();
                  _loc5_.label = resourceManager.getString(BUNDLE,FIELDS[_loc2_].name);
                  _loc5_.addChild(_loc4_);
                  this.m_UIForm.addChild(_loc5_);
               }
               _loc2_++;
            }
         }
      }
      
      override protected function createChildren() : void
      {
         if(!this.m_UIConstructed)
         {
            super.createChildren();
            this.m_UIForm = new Form();
            this.m_UIForm.horizontalScrollPolicy = ScrollPolicy.OFF;
            this.m_UIForm.percentHeight = 100;
            this.m_UIForm.setStyle("labelWidth",185);
            this.m_UIForm.setStyle("paddingBottom",0);
            this.m_UIForm.setStyle("paddingTop",0);
            addChild(this.m_UIForm);
            this.m_UIConstructed = true;
         }
      }
   }
}
