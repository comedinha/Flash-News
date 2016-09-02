package tibia.trade.npcTradeWidgetClasses
{
   import mx.core.UIComponent;
   import mx.controls.listClasses.IListItemRenderer;
   import mx.styles.CSSStyleDeclaration;
   import mx.styles.StyleManager;
   import tibia.appearances.widgetClasses.SkinnedAppearanceRenderer;
   import mx.controls.Label;
   import tibia.trade.TradeObjectRef;
   
   public class ListObjectRefItemRenderer extends UIComponent implements IListItemRenderer
   {
      
      private static const BUNDLE:String = "NPCTradeWidget";
      
      {
         s_InitializeStyle();
      }
      
      protected var m_UIObject:SkinnedAppearanceRenderer = null;
      
      private var m_UIConstructed:Boolean = false;
      
      protected var m_UIName:Label = null;
      
      protected var m_UIProperties:Label = null;
      
      private var m_UncommittedData:Boolean = false;
      
      protected var m_Data:TradeObjectRef = null;
      
      public function ListObjectRefItemRenderer()
      {
         super();
      }
      
      private static function s_InitializeStyle() : void
      {
         var Selector:String = "ListObjectRefItemRenderer";
         var Decl:CSSStyleDeclaration = StyleManager.getStyleDeclaration(Selector);
         if(Decl == null)
         {
            Decl = new CSSStyleDeclaration();
         }
         Decl.defaultFactory = function():void
         {
            this.rendererHorizontalGap = 2;
            this.rendererVerticalGap = 0;
            this.rendererPaddingBottom = 2;
            this.rendererPaddingLeft = 2;
            this.rendererPaddingRight = 2;
            this.rendererPaddingTop = 2;
         };
         StyleManager.setStyleDeclaration(Selector,Decl,true);
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         super.updateDisplayList(param1,param2);
         var _loc3_:Number = 0;
         var _loc4_:Number = 0;
         var _loc5_:Number = getStyle("rendererPaddingLeft");
         var _loc6_:Number = getStyle("rendererPaddingTop");
         var _loc7_:Number = param1 - _loc5_ - getStyle("rendererPaddingRight");
         var _loc8_:Number = param2 - _loc6_ - getStyle("rendererPaddingBottom");
         var _loc9_:Number = getStyle("rendererHorizontalGap");
         _loc3_ = this.m_UIObject.getExplicitOrMeasuredWidth();
         _loc4_ = this.m_UIObject.getExplicitOrMeasuredHeight();
         this.m_UIObject.setActualSize(_loc3_,_loc4_);
         this.m_UIObject.move(_loc5_,_loc6_ + (_loc8_ - _loc4_) / 2);
         this.m_UIObject.visible = true;
         _loc5_ = _loc5_ + (_loc3_ + _loc9_);
         _loc7_ = _loc7_ - (_loc3_ + _loc9_);
         _loc3_ = this.m_UIProperties.getExplicitOrMeasuredWidth();
         _loc4_ = this.m_UIProperties.getExplicitOrMeasuredHeight();
         this.m_UIProperties.setActualSize(_loc7_,_loc4_);
         this.m_UIProperties.move(_loc5_,_loc6_ + _loc8_ - _loc4_);
         this.m_UIProperties.visible = true;
         _loc8_ = _loc8_ - _loc4_;
         _loc3_ = this.m_UIName.getExplicitOrMeasuredWidth();
         _loc4_ = this.m_UIName.getExplicitOrMeasuredHeight();
         this.m_UIName.setActualSize(_loc7_,_loc8_);
         this.m_UIName.move(_loc5_,_loc6_);
         this.m_UIName.visible = true;
      }
      
      private function getObjectName() : String
      {
         if(this.m_Data != null)
         {
            return this.m_Data.name;
         }
         return null;
      }
      
      private function getObjectProperties() : String
      {
         if(this.m_Data != null)
         {
            return resourceManager.getString(BUNDLE,"LBL_MONEY_AND_WEIGHT_FORMAT",[this.m_Data.price,(this.m_Data.weight / 100).toFixed(2)]);
         }
         return null;
      }
      
      public function get data() : Object
      {
         return this.m_Data;
      }
      
      override protected function measure() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         super.measure();
         _loc1_ = getStyle("rendererPaddingLeft") + getStyle("rendererPaddingRight");
         _loc2_ = getStyle("rendererPaddingTop") + getStyle("rendererPaddingBottom");
         _loc3_ = Math.max(this.m_UIObject.getExplicitOrMeasuredWidth(),this.m_UIName.getExplicitOrMeasuredHeight() + this.m_UIProperties.getExplicitOrMeasuredHeight());
         _loc4_ = this.m_UIObject.getExplicitOrMeasuredHeight() + getStyle("rendererHorizontalGap") + Math.max(this.m_UIName.getExplicitOrMeasuredWidth(),this.m_UIProperties.getExplicitOrMeasuredWidth());
         measuredWidth = _loc4_ + _loc1_;
         measuredMinWidth = _loc4_ + _loc1_;
         measuredHeight = _loc3_ + _loc2_;
         measuredMinHeight = _loc3_ + _loc2_;
      }
      
      override protected function createChildren() : void
      {
         if(!this.m_UIConstructed)
         {
            super.createChildren();
            this.m_UIObject = new SkinnedAppearanceRenderer();
            this.m_UIObject.appearance = this.m_Data;
            this.m_UIObject.styleName = "npcTradeWidgetView";
            addChild(this.m_UIObject);
            this.m_UIName = new Label();
            this.m_UIName.percentHeight = 100;
            this.m_UIName.percentWidth = 100;
            this.m_UIName.text = this.getObjectName();
            addChild(this.m_UIName);
            this.m_UIProperties = new Label();
            this.m_UIProperties.percentHeight = NaN;
            this.m_UIProperties.percentWidth = 100;
            this.m_UIProperties.text = this.getObjectProperties();
            addChild(this.m_UIProperties);
            this.m_UIConstructed = true;
         }
      }
      
      public function set data(param1:Object) : void
      {
         this.m_Data = param1 as TradeObjectRef;
         this.m_UncommittedData = true;
         invalidateProperties();
      }
      
      override protected function commitProperties() : void
      {
         var _loc1_:Boolean = false;
         super.commitProperties();
         if(this.m_UncommittedData)
         {
            _loc1_ = this.m_Data != null && this.m_Data.amount > 0;
            this.m_UIObject.enabled = _loc1_;
            this.m_UIObject.appearance = this.m_Data;
            this.m_UIName.enabled = _loc1_;
            this.m_UIName.text = this.getObjectName();
            this.m_UIProperties.enabled = _loc1_;
            this.m_UIProperties.text = this.getObjectProperties();
            this.m_UncommittedData = false;
         }
      }
   }
}
