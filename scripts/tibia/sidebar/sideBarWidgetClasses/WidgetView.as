package tibia.sidebar.sideBarWidgetClasses
{
   import flash.display.DisplayObject;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import mx.containers.Box;
   import mx.containers.BoxDirection;
   import mx.containers.HBox;
   import mx.controls.Button;
   import mx.core.Container;
   import mx.core.EdgeMetrics;
   import mx.core.IBorder;
   import mx.core.IFlexDisplayObject;
   import mx.core.ScrollPolicy;
   import mx.core.UIComponent;
   import mx.core.mx_internal;
   import mx.events.PropertyChangeEvent;
   import mx.styles.CSSStyleDeclaration;
   import mx.styles.IStyleClient;
   import mx.styles.StyleManager;
   import mx.styles.StyleProxy;
   import shared.controls.CustomButton;
   import shared.controls.CustomLabel;
   import tibia.options.OptionsStorage;
   import tibia.sidebar.Widget;
   
   public class WidgetView extends Box
   {
      
      protected static const DEFAULT_WIDGET_HEIGHT:Number = 200;
      
      private static const TITLE_LABEL_STYLE_FILTER:Object = {
         "titleFontFamily":"fontFamily",
         "titleFontSize":"fontSize",
         "titleFontWeight":"fontWeight",
         "titleFontColor":"color"
      };
      
      protected static const DEFAULT_WIDGET_WIDTH:Number = 184;
      
      private static const FOOTER_STYLE_FILTER:Object = {
         "footerPaddingBottom":"paddingBottom",
         "footerPaddingLeft":"paddingLeft",
         "footerPaddingRight":"paddingRight",
         "footerPaddingTop":"paddingTop",
         "footerHorizontalAlign":"horizontalAlign",
         "footerHorizontalGap":"horizontalGap",
         "footerVerticalAlign":"verticalAlign",
         "footerVerticalGap":"verticalGap"
      };
      
      private static const HEADER_STYLE_FILTER:Object = {
         "headerPaddingBottom":"paddingBottom",
         "headerPaddingLeft":"paddingLeft",
         "headerPaddingRight":"paddingRight",
         "headerPaddingTop":"paddingTop",
         "headerHorizontalAlign":"horizontalAlign",
         "headerHorizontalGap":"horizontalGap",
         "headerVerticalAlign":"verticalAlign",
         "headerVerticalGap":"verticalGap"
      };
      
      {
         s_InitializeStyle();
      }
      
      private var m_MeasuredMaxHeight:Number = NaN;
      
      private var m_UncommittedWidgetCollapsible:Boolean = false;
      
      private var m_UncommittedWidgetCollapsed:Boolean = false;
      
      protected var m_WidgetInstance:Widget = null;
      
      private var m_UIConstructed:Boolean = false;
      
      private var m_UncommittedWidgetHeight:Boolean = false;
      
      protected var m_WidgetHeight:Number = NaN;
      
      private var m_MeasuredMaxWidth:Number = NaN;
      
      private var m_UncommittedWidgetInstance:Boolean = false;
      
      private var m_UncommittedWidgetResizable:Boolean = false;
      
      protected var m_WidgetClosable:Boolean = false;
      
      private var m_UncommittedWidgetClosed:Boolean = false;
      
      protected var m_WidgetClosed:Boolean = false;
      
      protected var m_UICollapseButton:Button = null;
      
      protected var m_WidgetCollapsed:Boolean = false;
      
      protected var m_Options:OptionsStorage = null;
      
      protected var m_WidgetCollapsible:Boolean = false;
      
      private var m_UncommittedWidgetClosable:Boolean = false;
      
      protected var m_UICloseButton:Button = null;
      
      private var m_UncommittedTitle:Boolean = false;
      
      private var m_UITitleLabel:CustomLabel = null;
      
      protected var m_UIHeader:HBox = null;
      
      protected var m_WidgetResizable:Boolean = false;
      
      private var m_UIFooter:HBox = null;
      
      protected var m_Title:String = null;
      
      private var m_UITitleIcon:IFlexDisplayObject = null;
      
      public function WidgetView()
      {
         super();
         focusEnabled = false;
         tabEnabled = false;
         tabChildren = false;
      }
      
      private static function s_InitializeStyle() : void
      {
         var Decl:CSSStyleDeclaration = StyleManager.getStyleDeclaration("WidgetView");
         if(Decl == null)
         {
            Decl = new CSSStyleDeclaration();
         }
         Decl.defaultFactory = function():void
         {
            this.iconLeft = 0;
            this.iconTop = 0;
            this.iconWidth = 0;
            this.iconHeight = 0;
            this.iconImage = undefined;
            this.headerLeft = 0;
            this.headerTop = 0;
            this.headerWidth = 0;
            this.headerHeight = 0;
            this.titleFontFamily = undefined;
            this.titleFontWeight = undefined;
            this.titleFontSize = undefined;
            this.titleFontColor = undefined;
            this.footerTop = 0;
            this.footerLeft = 0;
            this.footerWidth = 0;
            this.footerHeight = 0;
         };
         StyleManager.setStyleDeclaration("WidgetView",Decl,true);
      }
      
      public function set measuredMaxHeight(param1:Number) : void
      {
         this.m_MeasuredMaxHeight = param1;
      }
      
      function invalidateWidgetInstance() : void
      {
         this.m_UncommittedWidgetInstance = true;
         invalidateProperties();
      }
      
      function set widgetHeight(param1:Number) : void
      {
         if(this.m_WidgetHeight != param1)
         {
            this.m_WidgetHeight = param1;
            this.m_UncommittedWidgetHeight = true;
            invalidateDisplayList();
            invalidateProperties();
         }
      }
      
      protected function getFooterHeight() : Number
      {
         if(mx_internal::border is WidgetViewSkin)
         {
            return WidgetViewSkin(mx_internal::border).footerHeight;
         }
         return viewMetrics.bottom;
      }
      
      function get widgetRequiredHeight() : Number
      {
         if(this.m_WidgetCollapsible)
         {
            return this.getHeaderHeight();
         }
         if(this.m_WidgetResizable && !isNaN(explicitMinHeight))
         {
            return explicitMinHeight;
         }
         if(this.m_WidgetResizable && !isNaN(measuredMinHeight))
         {
            return measuredMinHeight;
         }
         return getExplicitOrMeasuredHeight();
      }
      
      override protected function createChildren() : void
      {
         if(!this.m_UIConstructed)
         {
            super.createChildren();
            this.m_UIHeader = new HBox();
            this.m_UIHeader.doubleClickEnabled = true;
            this.m_UIHeader.horizontalScrollPolicy = ScrollPolicy.OFF;
            this.m_UIHeader.percentHeight = NaN;
            this.m_UIHeader.percentWidth = 100;
            this.m_UIHeader.styleName = new StyleProxy(this,HEADER_STYLE_FILTER);
            this.m_UIHeader.verticalScrollPolicy = ScrollPolicy.OFF;
            this.m_UIHeader.addEventListener(MouseEvent.DOUBLE_CLICK,this.onHeaderDoubleClick);
            rawChildren.addChild(this.m_UIHeader);
            this.m_UITitleLabel = new CustomLabel();
            this.m_UITitleLabel.percentHeight = NaN;
            this.m_UITitleLabel.percentWidth = 100;
            this.m_UITitleLabel.styleName = new StyleProxy(this,TITLE_LABEL_STYLE_FILTER);
            this.setFilteredStyles(this.m_UITitleLabel,TITLE_LABEL_STYLE_FILTER);
            this.m_UIHeader.addChild(this.m_UITitleLabel);
            this.m_UICollapseButton = new CustomButton();
            this.m_UICollapseButton.toggle = true;
            this.m_UICollapseButton.selected = this.m_WidgetCollapsed;
            this.m_UICollapseButton.styleName = getStyle("collapseButtonStyle");
            this.m_UICollapseButton.addEventListener(MouseEvent.CLICK,this.onHeaderClick);
            this.m_UIHeader.addChild(this.m_UICollapseButton);
            this.m_UICloseButton = new CustomButton();
            this.m_UICloseButton.styleName = getStyle("closeButtonStyle");
            this.m_UICloseButton.addEventListener(MouseEvent.CLICK,this.onHeaderClick);
            this.m_UIHeader.addChild(this.m_UICloseButton);
            this.m_UIFooter = new HBox();
            this.m_UIFooter.horizontalScrollPolicy = ScrollPolicy.OFF;
            this.m_UIFooter.percentHeight = NaN;
            this.m_UIFooter.percentWidth = 100;
            this.m_UIFooter.styleName = new StyleProxy(this,FOOTER_STYLE_FILTER);
            this.m_UIFooter.verticalScrollPolicy = ScrollPolicy.OFF;
            rawChildren.addChild(this.m_UIFooter);
            this.titleIcon = this.getStyleInstance("iconImage");
            this.m_UIConstructed = true;
         }
      }
      
      function hitTestDragHandle(param1:Number, param2:Number) : Boolean
      {
         var _loc3_:Point = globalToLocal(new Point(param1,param2));
         return this.m_WidgetInstance.draggable && _loc3_.x >= 0 && _loc3_.x < width && _loc3_.y >= 0 && _loc3_.y < this.getHeaderHeight();
      }
      
      function get widgetCollapsible() : Boolean
      {
         return this.m_WidgetCollapsible;
      }
      
      function set options(param1:OptionsStorage) : void
      {
         if(this.m_Options != param1)
         {
            if(this.m_Options != null)
            {
               this.m_Options.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onOptionsChange);
            }
            this.m_Options = param1;
            if(this.m_Options != null)
            {
               this.m_Options.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onOptionsChange);
            }
            this.commitOptions();
         }
      }
      
      function get widgetSuggestedHeight() : Number
      {
         if(this.widgetCollapsed)
         {
            return this.getHeaderHeight();
         }
         return getExplicitOrMeasuredHeight();
      }
      
      public function set titleText(param1:String) : void
      {
         if(this.m_Title != param1)
         {
            this.m_Title = param1;
            this.m_UncommittedTitle = true;
            invalidateProperties();
         }
      }
      
      function get widgetClosable() : Boolean
      {
         return this.m_WidgetClosable;
      }
      
      function set widgetCollapsible(param1:Boolean) : void
      {
         if(this.m_WidgetCollapsible != param1)
         {
            this.m_WidgetCollapsible = param1;
            this.m_UncommittedWidgetCollapsible = true;
            invalidateProperties();
         }
      }
      
      protected function onOptionsChange(param1:PropertyChangeEvent) : void
      {
      }
      
      public function set measuredMaxWidth(param1:Number) : void
      {
         this.m_MeasuredMaxWidth = param1;
      }
      
      private function onHeaderDoubleClick(param1:MouseEvent) : void
      {
         if(this.widgetInstance != null && this.widgetInstance.collapsible)
         {
            this.widgetInstance.collapsed = !this.widgetInstance.collapsed;
         }
      }
      
      override protected function measure() : void
      {
         var _loc1_:EdgeMetrics = viewMetricsAndPadding;
         var _loc2_:Number = getStyle("verticalGap");
         var _loc3_:UIComponent = null;
         var _loc4_:int = 0;
         var _loc5_:int = numChildren;
         var _loc6_:Number = 0;
         var _loc7_:Number = 0;
         if(_loc5_ > 0)
         {
            if(direction == BoxDirection.VERTICAL)
            {
               _loc6_ = _loc7_ = -_loc2_;
               _loc4_ = 0;
               while(_loc4_ < _loc5_)
               {
                  _loc3_ = UIComponent(getChildAt(_loc4_));
                  _loc6_ = _loc6_ + (_loc3_.getExplicitOrMeasuredHeight() + _loc2_);
                  _loc7_ = _loc7_ + (_loc2_ + (!isNaN(_loc3_.explicitMinHeight)?_loc3_.explicitMinHeight:_loc3_.measuredMinHeight));
                  _loc4_++;
               }
            }
            else
            {
               _loc4_ = 0;
               while(_loc4_ < _loc5_)
               {
                  _loc3_ = UIComponent(getChildAt(_loc4_));
                  _loc6_ = Math.max(_loc6_,_loc3_.getExplicitOrMeasuredHeight());
                  _loc7_ = Math.max(_loc7_,!isNaN(_loc3_.explicitMinHeight)?Number(_loc3_.explicitMinHeight):Number(_loc3_.measuredMinHeight));
                  _loc4_++;
               }
            }
         }
         _loc6_ = _loc6_ + (_loc1_.top + _loc1_.bottom);
         _loc7_ = _loc7_ + (_loc1_.top + _loc1_.bottom);
         measuredMinWidth = DEFAULT_WIDGET_WIDTH;
         measuredWidth = DEFAULT_WIDGET_WIDTH;
         measuredMinHeight = Math.max(_loc7_,this.header.getExplicitOrMeasuredHeight());
         measuredHeight = Math.max(_loc7_,_loc6_);
      }
      
      function hitTestResizeHandle(param1:Number, param2:Number) : Boolean
      {
         var _loc3_:Point = globalToLocal(new Point(param1,param2));
         return !this.m_WidgetCollapsed && _loc3_.x >= 0 && _loc3_.x < width && _loc3_.y >= height - this.getFooterHeight() && _loc3_.y < height;
      }
      
      protected function commitOptions() : void
      {
      }
      
      override public function setStyle(param1:String, param2:*) : void
      {
         if(TITLE_LABEL_STYLE_FILTER[param1] != null)
         {
            this.m_UITitleLabel.setStyle(TITLE_LABEL_STYLE_FILTER[param1],param2);
         }
         else
         {
            super.setStyle(param1,param2);
         }
      }
      
      function get widgetCollapsed() : Boolean
      {
         return this.m_WidgetCollapsed;
      }
      
      function resizeWidgetDelta(param1:Number, param2:Boolean) : Number
      {
         return this.resizeWidgetAbsolute(getExplicitOrMeasuredHeight() + param1,param2);
      }
      
      protected function getHeaderHeight() : Number
      {
         if(mx_internal::border is WidgetViewSkin)
         {
            return WidgetViewSkin(mx_internal::border).headerHeight;
         }
         return viewMetrics.top;
      }
      
      function get widgetHeight() : Number
      {
         return this.m_WidgetHeight;
      }
      
      public function get measuredMaxHeight() : Number
      {
         return this.m_MeasuredMaxHeight;
      }
      
      protected function get header() : Container
      {
         return this.m_UIHeader;
      }
      
      function set widgetResizable(param1:Boolean) : void
      {
         if(this.m_WidgetResizable != param1)
         {
            this.m_WidgetResizable = param1;
            this.m_UncommittedWidgetResizable = true;
            invalidateProperties();
         }
      }
      
      function set widgetClosable(param1:Boolean) : void
      {
         if(this.m_WidgetClosable != param1)
         {
            this.m_WidgetClosable = param1;
            this.m_UncommittedWidgetClosable = true;
            invalidateProperties();
         }
      }
      
      protected function get footer() : Container
      {
         return this.m_UIFooter;
      }
      
      private function onHeaderClick(param1:MouseEvent) : void
      {
         if(this.widgetInstance != null)
         {
            if(param1.currentTarget == this.m_UICloseButton)
            {
               if(this.widgetInstance.closable)
               {
                  this.widgetInstance.close();
               }
            }
            else if(param1.currentTarget == this.m_UICollapseButton)
            {
               if(this.widgetInstance.collapsible)
               {
                  this.widgetInstance.collapsed = !this.widgetInstance.collapsed;
               }
            }
         }
      }
      
      function get options() : OptionsStorage
      {
         return this.m_Options;
      }
      
      function set widgetClosed(param1:Boolean) : void
      {
         if(this.m_WidgetClosed != param1)
         {
            this.m_WidgetClosed = param1;
            this.m_UncommittedWidgetClosed = true;
            invalidateDisplayList();
            invalidateProperties();
         }
      }
      
      public function get unscaledInnerWidth() : Number
      {
         var _loc1_:EdgeMetrics = viewMetricsAndPadding;
         return DEFAULT_WIDGET_WIDTH - _loc1_.left - _loc1_.right;
      }
      
      public function get titleText() : String
      {
         return this.m_Title;
      }
      
      public function get measuredMaxWidth() : Number
      {
         return this.m_MeasuredMaxWidth;
      }
      
      function resizeWidgetAbsolute(param1:Number, param2:Boolean) : Number
      {
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         if(this.m_WidgetClosed || this.m_WidgetCollapsed || !this.m_WidgetResizable)
         {
            return 0;
         }
         _loc3_ = NaN;
         if(!isNaN(explicitMinHeight))
         {
            _loc3_ = explicitMinHeight;
         }
         else if(!isNaN(measuredMinHeight))
         {
            _loc3_ = measuredMinHeight;
         }
         else
         {
            _loc3_ = this.getHeaderHeight();
         }
         _loc4_ = NaN;
         if(!isNaN(explicitMaxHeight))
         {
            _loc4_ = explicitMaxHeight;
         }
         else if(!isNaN(this.measuredMaxHeight))
         {
            _loc4_ = this.measuredMaxHeight;
         }
         else
         {
            _loc4_ = measuredHeight;
         }
         _loc5_ = getExplicitOrMeasuredHeight();
         _loc6_ = NaN;
         _loc7_ = 0;
         if(_loc5_ >= _loc4_)
         {
            _loc6_ = Math.max(_loc3_,param1);
            if(_loc6_ < _loc5_)
            {
               explicitHeight = _loc6_;
               _loc7_ = _loc6_ - _loc5_;
            }
         }
         else
         {
            _loc6_ = Math.max(_loc3_,Math.min(param1,_loc4_));
            explicitHeight = _loc6_;
            _loc7_ = _loc6_ - _loc5_;
         }
         if(param2)
         {
            this.m_WidgetInstance.height = _loc6_;
         }
         return _loc7_;
      }
      
      private function getStyleInstance(param1:String) : IFlexDisplayObject
      {
         var _loc2_:Class = getStyle(param1) as Class;
         var _loc3_:IFlexDisplayObject = null;
         if(_loc2_ != null)
         {
            _loc3_ = IFlexDisplayObject(new _loc2_());
         }
         return _loc3_;
      }
      
      function releaseInstance() : void
      {
         this.m_UICollapseButton.removeEventListener(MouseEvent.CLICK,this.onHeaderClick);
         this.m_UICloseButton.removeEventListener(MouseEvent.CLICK,this.onHeaderClick);
         this.m_UIHeader.removeEventListener(MouseEvent.DOUBLE_CLICK,this.onHeaderDoubleClick);
      }
      
      override protected function commitProperties() : void
      {
         if(this.m_UncommittedWidgetClosable)
         {
            this.m_UICloseButton.enabled = this.m_WidgetClosable;
            this.m_UncommittedWidgetClosable = false;
         }
         if(this.m_UncommittedWidgetClosed)
         {
            this.m_UncommittedWidgetClosed = false;
         }
         if(this.m_UncommittedWidgetCollapsed)
         {
            if(this.m_WidgetCollapsed)
            {
               explicitHeight = this.getHeaderHeight();
            }
            else
            {
               height = explicitHeight = this.m_WidgetHeight;
            }
            this.m_UICollapseButton.selected = this.m_WidgetCollapsed;
            this.m_UIFooter.visible = !this.m_WidgetCollapsed;
            this.m_UncommittedWidgetCollapsed = false;
         }
         if(this.m_UncommittedWidgetCollapsible)
         {
            this.m_UICollapseButton.enabled = this.m_WidgetCollapsible;
            this.m_UncommittedWidgetCollapsible = false;
         }
         if(this.m_UncommittedWidgetHeight)
         {
            if(this.m_WidgetCollapsed)
            {
               explicitHeight = this.getHeaderHeight();
            }
            else
            {
               explicitHeight = this.m_WidgetHeight;
            }
            this.m_UICollapseButton.selected = this.m_WidgetCollapsed;
            this.m_UIFooter.visible = !this.m_WidgetCollapsed;
            this.m_UncommittedWidgetHeight = false;
         }
         if(this.m_UncommittedWidgetInstance)
         {
            this.m_UncommittedWidgetInstance = false;
         }
         if(this.m_UncommittedWidgetResizable)
         {
            this.m_UncommittedWidgetResizable = false;
         }
         super.commitProperties();
         if(this.m_UncommittedTitle)
         {
            this.m_UITitleLabel.text = this.m_Title;
            this.m_UncommittedTitle = false;
         }
      }
      
      function get widgetResizable() : Boolean
      {
         return this.m_WidgetResizable;
      }
      
      function get widgetClosed() : Boolean
      {
         return this.m_WidgetClosed;
      }
      
      private function setFilteredStyles(param1:IStyleClient, param2:Object) : void
      {
         var _loc3_:* = null;
         for(_loc3_ in param2)
         {
            if(param2[_loc3_] != null)
            {
               param1.setStyle(param2[_loc3_],getStyle(_loc3_));
            }
         }
      }
      
      public function set titleIcon(param1:IFlexDisplayObject) : void
      {
         var _loc2_:DisplayObject = null;
         if(this.m_UITitleIcon != param1)
         {
            _loc2_ = rawChildren.getChildByName("iconImage");
            if(_loc2_ != null)
            {
               rawChildren.removeChild(_loc2_);
            }
            this.m_UITitleIcon = param1;
            if(this.m_UITitleIcon == null)
            {
               this.m_UITitleIcon = this.getStyleInstance("iconImage");
            }
            if(this.m_UITitleIcon != null)
            {
               this.m_UITitleIcon.name = "iconImage";
               rawChildren.addChild(DisplayObject(this.m_UITitleIcon));
            }
         }
      }
      
      public function get unscaledInnerHeight() : Number
      {
         var _loc1_:EdgeMetrics = viewMetricsAndPadding;
         return unscaledHeight - _loc1_.top - _loc1_.bottom;
      }
      
      function set widgetCollapsed(param1:Boolean) : void
      {
         if(this.m_WidgetCollapsed != param1)
         {
            this.m_WidgetCollapsed = param1;
            this.m_UncommittedWidgetCollapsed = true;
            invalidateDisplayList();
            invalidateProperties();
         }
      }
      
      public function get titleIcon() : IFlexDisplayObject
      {
         return this.m_UITitleIcon;
      }
      
      function set widgetInstance(param1:Widget) : void
      {
         if(this.m_WidgetInstance != param1)
         {
            this.m_WidgetInstance = param1;
            this.m_UncommittedWidgetInstance = true;
            invalidateProperties();
         }
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         super.updateDisplayList(param1,param2);
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = 0;
         var _loc8_:Number = 0;
         if(mx_internal::border is WidgetViewSkin)
         {
            _loc7_ = WidgetViewSkin(mx_internal::border).headerHeight;
            _loc8_ = WidgetViewSkin(mx_internal::border).footerHeight;
         }
         else
         {
            _loc7_ = viewMetrics.top;
            _loc8_ = viewMetrics.bottom;
         }
         if(this.m_UITitleIcon != null)
         {
            _loc3_ = 0;
            _loc4_ = 0;
            _loc5_ = param1;
            _loc6_ = _loc7_;
            if(getStyle("iconLeft") !== undefined)
            {
               _loc3_ = getStyle("iconLeft");
            }
            if(getStyle("iconTop") !== undefined)
            {
               _loc4_ = getStyle("iconTop");
            }
            if(getStyle("iconWidth") !== undefined)
            {
               _loc5_ = getStyle("iconWidth");
            }
            if(getStyle("iconHeight") !== undefined)
            {
               _loc6_ = getStyle("iconHeight");
            }
            _loc3_ = Math.max(0,Math.min(_loc3_,param1));
            _loc4_ = Math.max(0,Math.min(_loc4_,_loc7_));
            _loc5_ = Math.max(0,Math.min(_loc5_,param1 - _loc3_));
            _loc6_ = Math.max(0,Math.min(_loc6_,_loc7_ - _loc4_));
            this.m_UITitleIcon.move(_loc3_ + (_loc5_ - this.m_UITitleIcon.measuredWidth) / 2,_loc4_ + (_loc6_ - this.m_UITitleIcon.measuredHeight) / 2);
            this.m_UITitleIcon.setActualSize(this.m_UITitleIcon.measuredWidth,this.m_UITitleIcon.measuredHeight);
         }
         _loc3_ = 0;
         _loc4_ = 0;
         _loc5_ = param1;
         _loc6_ = _loc7_;
         if(getStyle("headerLeft") !== undefined)
         {
            _loc3_ = getStyle("headerLeft");
         }
         if(getStyle("headerTop") !== undefined)
         {
            _loc4_ = getStyle("headerTop");
         }
         if(getStyle("headerWidth") !== undefined)
         {
            _loc5_ = getStyle("headerWidth");
         }
         if(getStyle("headerHeight") !== undefined)
         {
            _loc6_ = getStyle("headerHeight");
         }
         _loc3_ = Math.max(0,Math.min(_loc3_,param1));
         _loc4_ = Math.max(0,Math.min(_loc4_,_loc7_));
         _loc5_ = Math.max(0,Math.min(_loc5_,param1 - _loc3_));
         _loc6_ = Math.max(0,Math.min(_loc6_,_loc7_ - _loc4_));
         this.m_UIHeader.move(_loc3_,_loc4_);
         this.m_UIHeader.setActualSize(_loc5_,_loc6_);
         _loc3_ = 0;
         _loc4_ = 0;
         _loc5_ = param1;
         _loc6_ = _loc8_;
         if(getStyle("footerLeft") !== undefined)
         {
            _loc3_ = getStyle("footerLeft");
         }
         if(getStyle("footerTop") !== undefined)
         {
            _loc4_ = getStyle("footerTop");
         }
         if(getStyle("footerWidth") !== undefined)
         {
            _loc5_ = getStyle("footerWidth");
         }
         if(getStyle("footerHeight") !== undefined)
         {
            _loc6_ = getStyle("footerHeight");
         }
         _loc3_ = Math.max(0,Math.min(_loc3_,param1));
         _loc4_ = Math.max(0,Math.min(_loc4_,_loc8_));
         _loc5_ = Math.max(0,Math.min(_loc5_,param1 - _loc3_));
         _loc6_ = Math.max(0,Math.min(_loc6_,_loc8_ - _loc4_));
         this.m_UIFooter.move(_loc3_,param2 - _loc8_ + _loc4_);
         this.m_UIFooter.setActualSize(_loc5_,_loc6_);
      }
      
      function get widgetInstance() : Widget
      {
         return this.m_WidgetInstance;
      }
      
      override public function get borderMetrics() : EdgeMetrics
      {
         if(mx_internal::border is IBorder)
         {
            return IBorder(mx_internal::border).borderMetrics;
         }
         return EdgeMetrics.EMPTY;
      }
   }
}
