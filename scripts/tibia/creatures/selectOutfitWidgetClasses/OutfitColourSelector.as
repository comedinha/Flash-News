package tibia.creatures.selectOutfitWidgetClasses
{
   import flash.events.MouseEvent;
   import mx.core.EdgeMetrics;
   import mx.core.UIComponent;
   import mx.events.PropertyChangeEvent;
   import mx.styles.CSSStyleDeclaration;
   import mx.styles.StyleManager;
   import shared.controls.ColourRenderer;
   import shared.utility.Colour;
   
   public class OutfitColourSelector extends UIComponent
   {
      
      private static const BUNDLE:String = "SelectOutfitWidget";
      
      {
         s_InitializeStyle();
      }
      
      protected var m_HSI:int = 0;
      
      private var m_UncommittedHSI:Boolean = false;
      
      private var m_UIConstructed:Boolean = false;
      
      protected var m_UIColourRenderer:Vector.<ColourRenderer>;
      
      public function OutfitColourSelector()
      {
         this.m_UIColourRenderer = new Vector.<ColourRenderer>(Colour.HSI_H_STEPS * Colour.HSI_SI_VALUES,true);
         super();
      }
      
      private static function s_InitializeStyle() : void
      {
         var Selector:String = "OutfitColourSelector";
         var Decl:CSSStyleDeclaration = StyleManager.getStyleDeclaration(Selector);
         if(Decl == null)
         {
            Decl = new CSSStyleDeclaration(Selector);
         }
         Decl.defaultFactory = function():void
         {
            this.pickerSize = 12;
            this.horizontalGap = 2;
            this.verticalGap = 2;
            this.paddingLeft = 0;
            this.paddingRight = 0;
            this.paddingTop = 0;
            this.paddingBottom = 0;
         };
         StyleManager.setStyleDeclaration(Selector,Decl,true);
      }
      
      protected function onColourRendererClick(param1:MouseEvent) : void
      {
         if(param1 != null)
         {
            this.HSI = ColourRenderer(param1.currentTarget).data;
         }
      }
      
      override protected function measure() : void
      {
         var _loc2_:Number = NaN;
         var _loc4_:Number = NaN;
         super.measure();
         var _loc1_:EdgeMetrics = this.viewMetricsAndPadding;
         _loc2_ = getStyle("pickerSize");
         var _loc3_:Number = getStyle("horizontalGap");
         _loc4_ = getStyle("verticalGap");
         measuredMinWidth = measuredWidth = _loc1_.left + Colour.HSI_H_STEPS * (_loc2_ + _loc3_) - _loc3_ + _loc1_.right;
         measuredMinHeight = measuredHeight = _loc1_.top + Colour.HSI_SI_VALUES * (_loc2_ + _loc4_) - _loc4_ + _loc1_.bottom;
      }
      
      override protected function commitProperties() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         super.commitProperties();
         if(this.m_UncommittedHSI)
         {
            _loc1_ = 0;
            _loc2_ = this.m_UIColourRenderer.length;
            while(_loc1_ < _loc2_)
            {
               if(this.m_UIColourRenderer[_loc1_] != null)
               {
                  this.m_UIColourRenderer[_loc1_].selected = this.m_HSI == this.m_UIColourRenderer[_loc1_].data;
               }
               _loc1_++;
            }
            this.m_UncommittedHSI = false;
         }
      }
      
      private function set _71838HSI(param1:int) : void
      {
         if(this.m_HSI != param1)
         {
            this.m_HSI = param1;
            this.m_UncommittedHSI = true;
            invalidateProperties();
         }
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         super.updateDisplayList(param1,param2);
         var _loc3_:EdgeMetrics = this.viewMetricsAndPadding;
         var _loc4_:Number = getStyle("pickerSize");
         var _loc5_:Number = getStyle("horizontalGap");
         var _loc6_:Number = getStyle("verticalGap");
         var _loc7_:int = 0;
         var _loc8_:int = this.m_UIColourRenderer.length;
         var _loc9_:Number = _loc3_.left;
         var _loc10_:Number = _loc3_.top - _loc4_ - _loc6_;
         while(_loc7_ < _loc8_)
         {
            if(this.m_UIColourRenderer[_loc7_] != null)
            {
               if(_loc7_ % Colour.HSI_H_STEPS == 0)
               {
                  _loc9_ = _loc3_.left;
                  _loc10_ = _loc10_ + (_loc4_ + _loc6_);
               }
               this.m_UIColourRenderer[_loc7_].move(_loc9_,_loc10_);
               this.m_UIColourRenderer[_loc7_].setActualSize(_loc4_,_loc4_);
               _loc9_ = _loc9_ + (_loc4_ + _loc5_);
            }
            _loc7_++;
         }
      }
      
      override protected function createChildren() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(!this.m_UIConstructed)
         {
            super.createChildren();
            _loc1_ = 0;
            while(_loc1_ < Colour.HSI_SI_VALUES)
            {
               _loc2_ = 0;
               while(_loc2_ < Colour.HSI_H_STEPS)
               {
                  _loc3_ = _loc1_ * Colour.HSI_H_STEPS + _loc2_;
                  this.m_UIColourRenderer[_loc3_] = new ColourRenderer();
                  this.m_UIColourRenderer[_loc3_].ARGB = Colour.s_ARGBFromHSI(_loc3_);
                  this.m_UIColourRenderer[_loc3_].data = _loc3_;
                  this.m_UIColourRenderer[_loc3_].selected = this.m_HSI == _loc3_;
                  this.m_UIColourRenderer[_loc3_].styleName = this;
                  this.m_UIColourRenderer[_loc3_].addEventListener(MouseEvent.CLICK,this.onColourRendererClick);
                  addChild(this.m_UIColourRenderer[_loc3_]);
                  _loc2_++;
               }
               _loc1_++;
            }
            this.m_UIConstructed = true;
         }
      }
      
      [Bindable(event="propertyChange")]
      public function set HSI(param1:int) : void
      {
         var _loc2_:Object = this.HSI;
         if(_loc2_ !== param1)
         {
            this._71838HSI = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"HSI",_loc2_,param1));
         }
      }
      
      public function get HSI() : int
      {
         return this.m_HSI;
      }
      
      public function get viewMetricsAndPadding() : EdgeMetrics
      {
         var _loc1_:EdgeMetrics = new EdgeMetrics();
         _loc1_.bottom = getStyle("paddingBottom");
         _loc1_.left = getStyle("paddingLeft");
         _loc1_.right = getStyle("paddingRight");
         _loc1_.top = getStyle("paddingTop");
         return _loc1_;
      }
   }
}
