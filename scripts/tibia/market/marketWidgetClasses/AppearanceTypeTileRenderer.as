package tibia.market.marketWidgetClasses
{
   import mx.containers.HBox;
   import flash.geom.Rectangle;
   import shared.utility.TextFieldCache;
   import flash.geom.Matrix;
   import mx.core.FlexShape;
   import tibia.appearances.AppearanceType;
   import tibia.appearances.AppearanceStorage;
   import mx.controls.listClasses.ListBase;
   import tibia.appearances.widgetClasses.SkinnedAppearanceRenderer;
   import flash.events.Event;
   import tibia.market.MarketWidget;
   import flash.display.Graphics;
   import tibia.ingameshop.IngameShopManager;
   import mx.core.EventPriority;
   import mx.events.FlexEvent;
   import tibia.game.PopUpBase;
   
   public class AppearanceTypeTileRenderer extends HBox
   {
      
      private static var s_Rect:Rectangle = new Rectangle();
      
      private static var s_TextCache:TextFieldCache = new TextFieldCache(32,17,512,true);
      
      private static var s_Trans:Matrix = new Matrix();
       
      
      private var m_UIDepotCount:FlexShape = null;
      
      private var m_UncommittedSelection:Boolean = false;
      
      private var m_UncommittedAppearance:Boolean = false;
      
      private var m_Appearance:AppearanceType = null;
      
      private var m_UncommittedMarket:Boolean = false;
      
      private var m_Market:MarketWidget = null;
      
      private var m_UIConstructed:Boolean = false;
      
      private var m_UIAppearance:SkinnedAppearanceRenderer = null;
      
      private var m_UncommittedDepotCount:Boolean = false;
      
      public function AppearanceTypeTileRenderer()
      {
         super();
         addEventListener(FlexEvent.CREATION_COMPLETE,this.onCreationComplete);
      }
      
      protected function set appearance(param1:AppearanceType) : void
      {
         if(this.m_Appearance != param1)
         {
            this.m_Appearance = param1;
            this.m_UncommittedAppearance = true;
            this.invalidateDepotCount();
            this.invalidateSelection();
            invalidateProperties();
         }
      }
      
      override public function get data() : Object
      {
         return this.appearance;
      }
      
      protected function invalidateSelection() : void
      {
         this.m_UncommittedSelection = true;
         invalidateDisplayList();
      }
      
      override public function set data(param1:Object) : void
      {
         this.appearance = param1 as AppearanceType;
      }
      
      override protected function commitProperties() : void
      {
         var _loc1_:AppearanceStorage = null;
         super.commitProperties();
         if(this.m_UncommittedAppearance)
         {
            _loc1_ = null;
            if(this.appearance != null && (_loc1_ = Tibia.s_GetAppearanceStorage()) != null)
            {
               this.m_UIAppearance.appearance = _loc1_.createObjectInstance(this.appearance.marketShowAs,0);
               this.m_UIAppearance.highlighted = owner is ListBase && ListBase(owner).selectedItem === this.appearance;
            }
            else
            {
               this.m_UIAppearance.appearance = null;
               this.m_UIAppearance.highlighted = false;
            }
            this.m_UncommittedAppearance = false;
         }
         if(this.m_UncommittedMarket)
         {
            this.m_UncommittedMarket = false;
         }
      }
      
      protected function invalidateDepotCount() : void
      {
         this.m_UncommittedDepotCount = true;
         invalidateDisplayList();
      }
      
      override protected function createChildren() : void
      {
         if(!this.m_UIConstructed)
         {
            super.createChildren();
            this.m_UIAppearance = new SkinnedAppearanceRenderer();
            this.m_UIAppearance.styleName = "marketWidgetAppearanceRenderer";
            addChild(this.m_UIAppearance);
            this.m_UIDepotCount = new FlexShape();
            rawChildren.addChild(this.m_UIDepotCount);
            this.m_UIConstructed = true;
         }
      }
      
      protected function get appearance() : AppearanceType
      {
         return this.m_Appearance;
      }
      
      private function onDepotChange(param1:Event) : void
      {
         if(param1 != null)
         {
            this.invalidateDepotCount();
         }
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         var _loc3_:Graphics = null;
         var _loc4_:int = 0;
         var _loc5_:Rectangle = null;
         super.updateDisplayList(param1,param2);
         if(this.m_UncommittedDepotCount)
         {
            _loc3_ = this.m_UIDepotCount.graphics;
            _loc3_.clear();
            _loc4_ = 0;
            _loc5_ = null;
            if(this.appearance != null && this.market != null && this.appearance.ID != IngameShopManager.TIBIA_COINS_APPEARANCE_TYPE_ID && (_loc4_ = this.market.getDepotAmount(this.appearance)) > 0 && (_loc5_ = s_TextCache.getItem(_loc4_,String(_loc4_),4294967295)) != null)
            {
               s_Rect.x = this.m_UIAppearance.getExplicitOrMeasuredWidth() - this.m_UIAppearance.getStyle("paddingRight") - _loc5_.width;
               s_Rect.y = this.m_UIAppearance.getExplicitOrMeasuredHeight() - this.m_UIAppearance.getStyle("paddingBottom") - _loc5_.height;
               s_Trans.tx = -_loc5_.x + s_Rect.x;
               s_Trans.ty = -_loc5_.y + s_Rect.y;
               _loc3_.beginBitmapFill(s_TextCache,s_Trans,false,false);
               _loc3_.drawRect(s_Rect.x,s_Rect.y,_loc5_.width,_loc5_.height);
               _loc3_.endFill();
            }
            this.m_UIDepotCount.x = this.m_UIAppearance.x;
            this.m_UIDepotCount.y = this.m_UIAppearance.y;
            this.m_UncommittedDepotCount = false;
         }
         if(this.m_UncommittedSelection)
         {
            this.m_UIAppearance.highlighted = this.market != null && this.market.selectedType == this.appearance;
            this.m_UncommittedSelection = false;
         }
      }
      
      protected function set market(param1:MarketWidget) : void
      {
         if(this.m_Market != param1)
         {
            if(this.m_Market != null)
            {
               this.m_Market.removeEventListener(MarketWidget.DEPOT_CONTENT_CHANGE,this.onDepotChange);
               this.m_Market.removeEventListener(MarketWidget.SELECTED_TYPE_CHANGE,this.onSelectionChange);
            }
            this.m_Market = param1;
            if(this.m_Market != null)
            {
               this.m_Market.addEventListener(MarketWidget.DEPOT_CONTENT_CHANGE,this.onDepotChange,false,EventPriority.DEFAULT,true);
               this.m_Market.addEventListener(MarketWidget.SELECTED_TYPE_CHANGE,this.onSelectionChange);
            }
            this.m_UncommittedMarket = true;
            this.invalidateDepotCount();
            this.invalidateSelection();
            invalidateProperties();
         }
      }
      
      protected function get market() : MarketWidget
      {
         return this.m_Market;
      }
      
      private function onSelectionChange(param1:Event) : void
      {
         if(param1 != null)
         {
            this.invalidateSelection();
         }
      }
      
      private function onCreationComplete(param1:Event) : void
      {
         removeEventListener(FlexEvent.CREATION_COMPLETE,this.onCreationComplete);
         this.market = PopUpBase.getParentPopUp(this) as MarketWidget;
      }
   }
}
