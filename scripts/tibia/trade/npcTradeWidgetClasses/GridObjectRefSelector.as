package tibia.trade.npcTradeWidgetClasses
{
   import mx.collections.IList;
   import mx.containers.Tile;
   import mx.containers.VBox;
   import mx.controls.Label;
   import mx.core.IUIComponent;
   import mx.core.ScrollPolicy;
   import mx.events.CollectionEvent;
   import mx.events.CollectionEventKind;
   import mx.styles.StyleProxy;
   import tibia.appearances.widgetClasses.SkinnedAppearanceRenderer;
   import tibia.trade.TradeObjectRef;
   
   public class GridObjectRefSelector extends ObjectRefSelectorBase
   {
      
      private static const BUNDLE:String = "NPCTradeWidget";
      
      private static const TILE_STYLE_FILTER:Object = {
         "slotHorizontalAlign":"horizontalAlign",
         "slotVerticalAlign":"verticalAlign",
         "slotHorizontalGap":"horizontalGap",
         "slotVerticalGap":"verticalGap",
         "slotPaddingBottom":"paddingBottom",
         "slotPaddingLeft":"paddingLeft",
         "slotPaddingRight":"paddingRight",
         "slotPaddingTop":"paddingTop"
      };
      
      private static const INFO_STYLE_FILTER:Object = {
         "infoBorderAlpha":"borderAlpha",
         "infoBorderColor":"borderColor",
         "infoBorderStyle":"borderStyle",
         "infoBorderThickness":"borderThickness",
         "infoBackgroundAlpha":"backgroundAlpha",
         "infoBackgroundColor":"backgroundColor",
         "infoHorizontalAlign":"horizontalAlign",
         "infoVerticalAlign":"verticalAlign",
         "infoHorizontalGap":"horizontalGap",
         "infoVerticalGap":"verticalGap",
         "infoPaddingBottom":"paddingBottom",
         "infoPaddingLeft":"paddingLeft",
         "infoPaddingRight":"paddingRight",
         "infoPaddingTop":"paddingTop"
      };
       
      
      protected var m_UIProperties:Label = null;
      
      private var m_InvalidObjectRenderer:Boolean = false;
      
      private var m_InvalidObjectState:Boolean = false;
      
      protected var m_UIName:Label = null;
      
      private var m_UncommittedSelectedIndex:Boolean = false;
      
      private var m_UIConstructed:Boolean = false;
      
      protected var m_UIInfo:VBox = null;
      
      private var m_InvalidObjectInfo:Boolean = false;
      
      protected var m_UITile:Tile = null;
      
      public function GridObjectRefSelector()
      {
         super();
      }
      
      protected function onDataProviderChange(param1:CollectionEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:TradeObjectRef = null;
         var _loc6_:SkinnedAppearanceRenderer = null;
         if(param1 != null)
         {
            _loc2_ = 0;
            _loc3_ = 0;
            _loc4_ = 0;
            _loc5_ = null;
            _loc6_ = null;
            switch(param1.kind)
            {
               case CollectionEventKind.ADD:
                  _loc2_ = 0;
                  _loc4_ = param1.items.length;
                  while(_loc2_ < _loc4_)
                  {
                     _loc3_ = param1.location + _loc2_;
                     _loc5_ = TradeObjectRef(param1.items[_loc2_]);
                     _loc6_ = new SkinnedAppearanceRenderer();
                     _loc6_.enabled = _loc5_.amount > 0;
                     _loc6_.appearance = _loc5_;
                     _loc6_.highlighted = _loc3_ == selectedIndex;
                     _loc6_.styleName = "npcTradeWidgetView";
                     this.m_UITile.addChildAt(_loc6_,_loc3_);
                     _loc2_++;
                  }
                  break;
               case CollectionEventKind.MOVE:
                  this.m_UITile.setChildIndex(this.m_UITile.getChildAt(param1.oldLocation),param1.location);
                  break;
               case CollectionEventKind.REMOVE:
                  _loc2_ = 0;
                  _loc4_ = param1.items.length;
                  while(_loc2_ < _loc4_)
                  {
                     _loc3_ = param1.location + _loc2_;
                     _loc6_ = SkinnedAppearanceRenderer(this.m_UITile.removeChildAt(_loc3_));
                     _loc2_++;
                  }
                  break;
               case CollectionEventKind.UPDATE:
                  break;
               case CollectionEventKind.REFRESH:
               case CollectionEventKind.REPLACE:
               case CollectionEventKind.RESET:
                  this.invalidateObjectRenderers();
            }
            this.invalidateObjectInfo();
            this.invalidateObjectStates();
         }
      }
      
      protected function invalidateObjectRenderers() : void
      {
         this.m_InvalidObjectRenderer = true;
         invalidateProperties();
      }
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TradeObjectRef = null;
         var _loc4_:SkinnedAppearanceRenderer = null;
         if(this.m_InvalidObjectInfo)
         {
            _loc3_ = selectedObject;
            if(_loc3_ != null)
            {
               this.m_UIName.text = _loc3_.name;
               this.m_UIProperties.text = resourceManager.getString(BUNDLE,"LBL_MONEY_AND_WEIGHT_FORMAT",[_loc3_.price,(_loc3_.weight / 100).toFixed(2)]);
            }
            else
            {
               this.m_UIName.text = null;
               this.m_UIProperties.text = null;
            }
            this.m_InvalidObjectInfo = false;
         }
         if(this.m_InvalidObjectRenderer)
         {
            _loc1_ = this.m_UITile.numChildren - 1;
            while(_loc1_ >= 0)
            {
               _loc4_ = SkinnedAppearanceRenderer(this.m_UITile.removeChildAt(_loc1_));
               _loc1_--;
            }
            if(dataProvider != null)
            {
               _loc1_ = 0;
               _loc2_ = dataProvider.length;
               while(_loc1_ < _loc2_)
               {
                  _loc3_ = TradeObjectRef(dataProvider.getItemAt(_loc1_));
                  _loc4_ = new SkinnedAppearanceRenderer();
                  _loc4_.enabled = _loc3_.amount > 0;
                  _loc4_.appearance = _loc3_;
                  _loc4_.highlighted = _loc1_ == selectedIndex;
                  _loc4_.styleName = "npcTradeWidgetView";
                  this.m_UITile.addChild(_loc4_);
                  _loc1_++;
               }
            }
            this.m_InvalidObjectRenderer = false;
         }
         if(this.m_InvalidObjectState)
         {
            _loc1_ = this.m_UITile.numChildren - 1;
            while(_loc1_ >= 0)
            {
               _loc4_ = SkinnedAppearanceRenderer(this.m_UITile.getChildAt(_loc1_));
               _loc3_ = TradeObjectRef(_loc4_.appearance);
               _loc4_.enabled = _loc3_ != null && _loc3_.amount > 0;
               _loc4_.highlighted = _loc3_ != null && _loc1_ == selectedIndex;
               _loc1_--;
            }
            this.m_InvalidObjectState = false;
         }
         if(this.m_UncommittedSelectedIndex)
         {
            if(selectedIndex < 0)
            {
               this.m_UITile.verticalScrollPosition = 0;
            }
            this.m_UncommittedSelectedIndex = false;
         }
      }
      
      override protected function createChildren() : void
      {
         if(!this.m_UIConstructed)
         {
            super.createChildren();
            this.m_UITile = new Tile();
            this.m_UITile.percentHeight = 100;
            this.m_UITile.percentWidth = 100;
            this.m_UITile.verticalScrollPolicy = ScrollPolicy.ON;
            this.m_UITile.styleName = new StyleProxy(this,TILE_STYLE_FILTER);
            addChild(this.m_UITile);
            this.m_UIInfo = new VBox();
            this.m_UIInfo.percentHeight = NaN;
            this.m_UIInfo.percentWidth = 100;
            this.m_UIInfo.styleName = new StyleProxy(this,INFO_STYLE_FILTER);
            this.m_UIName = new Label();
            this.m_UIName.percentHeight = NaN;
            this.m_UIName.percentWidth = 100;
            this.m_UIInfo.addChild(this.m_UIName);
            this.m_UIProperties = new Label();
            this.m_UIProperties.percentHeight = NaN;
            this.m_UIProperties.percentWidth = 100;
            this.m_UIInfo.addChild(this.m_UIProperties);
            addChild(this.m_UIInfo);
            this.m_UIConstructed = true;
         }
      }
      
      override protected function measure() : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc8_:IUIComponent = null;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         super.measure();
         var _loc1_:Number = 0;
         var _loc2_:Number = 0;
         _loc3_ = 0;
         _loc4_ = 0;
         var _loc5_:int = numChildren - 1;
         while(_loc5_ >= 0)
         {
            _loc8_ = IUIComponent(getChildAt(_loc5_));
            _loc9_ = _loc8_.getExplicitOrMeasuredWidth();
            _loc10_ = _loc8_.getExplicitOrMeasuredHeight();
            _loc2_ = Math.max(_loc2_,_loc9_);
            _loc1_ = Math.max(_loc1_,!isNaN(_loc8_.minWidth)?Number(_loc8_.minWidth):Number(_loc9_));
            _loc4_ = _loc4_ + _loc10_;
            _loc3_ = _loc3_ + (!isNaN(_loc8_.minHeight)?_loc8_.minHeight:_loc10_);
            _loc5_--;
         }
         var _loc6_:Number = getStyle("paddingTop") + Math.max(numChildren - 1,0) * getStyle("verticalGap") + getStyle("paddingBottom");
         var _loc7_:Number = getStyle("paddingLeft") + getStyle("paddingRight");
         measuredWidth = _loc2_ + _loc7_;
         measuredMinWidth = _loc1_ + _loc7_;
         measuredHeight = _loc4_ + _loc6_;
         measuredMinHeight = _loc3_ + _loc6_;
      }
      
      override public function get layout() : int
      {
         return ObjectRefSelectorBase.LAYOUT_GRID;
      }
      
      override public function set selectedIndex(param1:int) : void
      {
         if(selectedIndex != param1)
         {
            super.selectedIndex = param1;
            this.invalidateObjectInfo();
            this.invalidateObjectStates();
            this.m_UncommittedSelectedIndex = true;
         }
      }
      
      override public function set dataProvider(param1:IList) : void
      {
         if(dataProvider != param1)
         {
            if(dataProvider != null)
            {
               dataProvider.removeEventListener(CollectionEvent.COLLECTION_CHANGE,this.onDataProviderChange);
            }
            super.dataProvider = param1;
            this.invalidateObjectInfo();
            this.invalidateObjectRenderers();
            this.invalidateObjectStates();
            if(dataProvider != null)
            {
               dataProvider.addEventListener(CollectionEvent.COLLECTION_CHANGE,this.onDataProviderChange);
            }
         }
      }
      
      protected function invalidateObjectInfo() : void
      {
         this.m_InvalidObjectInfo = true;
         invalidateProperties();
      }
      
      protected function invalidateObjectStates() : void
      {
         this.m_InvalidObjectState = true;
         invalidateProperties();
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         super.updateDisplayList(param1,param2);
         var _loc3_:Number = getStyle("paddingLeft");
         var _loc4_:Number = getStyle("paddingTop");
         var _loc5_:Number = getStyle("horizontalGap");
         var _loc6_:Number = getStyle("verticalGap");
         var _loc7_:Number = param1 - _loc3_ - getStyle("paddingRight");
         var _loc8_:Number = param2 - _loc4_ - getStyle("paddingBottom");
         var _loc9_:Number = this.m_UIInfo.getExplicitOrMeasuredWidth();
         var _loc10_:Number = this.m_UIInfo.getExplicitOrMeasuredHeight();
         this.m_UIInfo.move(_loc3_,_loc4_ + _loc8_ - _loc10_);
         this.m_UIInfo.setActualSize(_loc7_,_loc10_);
         _loc8_ = _loc8_ - (_loc10_ + _loc6_);
         this.m_UITile.move(_loc3_,_loc4_);
         this.m_UITile.setActualSize(_loc7_,_loc8_);
      }
   }
}
