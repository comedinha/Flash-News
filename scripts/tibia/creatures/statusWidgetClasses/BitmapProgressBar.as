package tibia.creatures.statusWidgetClasses
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.filters.BitmapFilterQuality;
   import flash.filters.GlowFilter;
   import flash.geom.Matrix;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import mx.core.EdgeMetrics;
   import mx.core.UIComponent;
   import mx.styles.CSSStyleDeclaration;
   import mx.styles.StyleManager;
   import mx.utils.StringUtil;
   import shared.skins.BitmapGrid;
   
   public class BitmapProgressBar extends UIComponent
   {
      
      public static const DIRECTION_BOTTOM_TO_TOP:String = "bt";
      
      public static const DIRECTION_RIGHT_TO_LEFT:String = "rl";
      
      public static const DIRECTION_TOP_TO_BOTTOM:String = "tb";
      
      protected static var s_Matrix:Matrix = new Matrix();
      
      public static const DIRECTION_AUTO:String = "a";
      
      public static const DIRECTION_LEFT_TO_RIGHT:String = "lr";
      
      {
         s_InitializeStyle();
      }
      
      protected var m_Direction:String = null;
      
      private var m_UncommittedTickValues:Boolean = false;
      
      private var m_StyleImageLimits = null;
      
      protected var m_LabelFormat:String = "{1}";
      
      private var m_UncommittedMaxValue:Boolean = false;
      
      protected var m_MaxValue:Number = 100.0;
      
      protected var m_UILeftOrnament:BitmapGrid = null;
      
      private var m_UIConstructed:Boolean = false;
      
      private var m_BarLimits:Array = null;
      
      private var m_UncommittedLabelFormat:Boolean = false;
      
      private var m_StyleImageNames = null;
      
      protected var m_TickValues:Array = null;
      
      protected var m_BarLabel:TextField = null;
      
      private var m_UncommittedLabelEnabled:Boolean = false;
      
      protected var m_LabelEnabled:Boolean = false;
      
      protected var m_UITick:BitmapGrid = null;
      
      private var m_UncommittedValue:Boolean = false;
      
      protected var m_UIRightOrnament:BitmapGrid = null;
      
      private var m_UncommittedDirection:Boolean = false;
      
      private var m_UncommittedMinValue:Boolean = false;
      
      protected var m_MinValue:Number = 0.0;
      
      protected var m_UIBackground:BitmapGrid = null;
      
      protected var m_UILabel:Bitmap = null;
      
      private var m_BarImages:Array = null;
      
      protected var m_Value:Number = 50.0;
      
      public function BitmapProgressBar()
      {
         super();
         this.m_UIBackground = new BitmapGrid(this,"background");
         this.m_UILeftOrnament = new BitmapGrid(this,"leftOrnament");
         this.m_UIRightOrnament = new BitmapGrid(this,"rightOrnament");
         this.m_UITick = new BitmapGrid(this,"tick");
      }
      
      private static function s_InitializeStyle() : void
      {
         var Selector:String = "BitmapProgressBar";
         var Decl:CSSStyleDeclaration = StyleManager.getStyleDeclaration(Selector);
         if(Decl == null)
         {
            Decl = new CSSStyleDeclaration(Selector);
         }
         Decl.defaultFactory = function():void
         {
            this.barImages = null;
            this.barLimits = null;
            this.fontColor = 16777215;
            this.fontFamily = "Verdana";
            this.fontSize = 11;
            this.fontStyle = "normal";
            this.fontWeight = "bold";
            this.paddingBottom = 0;
            this.paddingLeft = 0;
            this.paddingRight = 0;
            this.paddingTop = 0;
            this.leftOrnamentOffset = 0;
            this.rightOrnamentOffset = 0;
            this.tickOffset = 0;
         };
         StyleManager.setStyleDeclaration(Selector,Decl,true);
      }
      
      public function set direction(param1:String) : void
      {
         if(param1 != DIRECTION_LEFT_TO_RIGHT && param1 != DIRECTION_RIGHT_TO_LEFT)
         {
            param1 = DIRECTION_LEFT_TO_RIGHT;
         }
         if(this.m_Direction != param1)
         {
            this.m_Direction = param1;
            invalidateDisplayList();
            invalidateProperties();
            invalidateSize();
         }
      }
      
      public function get direction() : String
      {
         return this.m_Direction;
      }
      
      private function cacheBarImages(param1:Boolean = false) : void
      {
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc2_:* = getStyle("barImages");
         var _loc3_:* = getStyle("barLimits");
         var _loc4_:Class = null;
         if(param1 || this.m_StyleImageNames != _loc2_ || this.m_StyleImageLimits != _loc3_)
         {
            this.m_StyleImageNames = _loc2_;
            this.m_StyleImageLimits = _loc3_;
            this.m_BarLimits = [];
            this.m_BarImages = [];
            _loc5_ = 0;
            _loc6_ = _loc2_ is Array?int(_loc2_.length):0;
            _loc7_ = _loc3_ is Array?int(_loc3_.length):0;
            if(_loc6_ > 0 && _loc7_ == _loc6_)
            {
               _loc5_ = 0;
               while(_loc5_ < _loc6_)
               {
                  this.m_BarLimits[_loc5_] = Number(_loc3_[_loc5_]);
                  this.m_BarImages[_loc5_] = (_loc4_ = getStyle(_loc2_[_loc5_]) as Class) != null?new _loc4_():null;
                  _loc5_++;
               }
            }
            else if(_loc6_ == 0 && _loc7_ == _loc6_)
            {
               this.m_BarLimits[0] = Number(_loc3_);
               this.m_BarImages[0] = (_loc4_ = getStyle(_loc2_) as Class) != null?new _loc4_():null;
            }
         }
      }
      
      public function get labelFormat() : String
      {
         return this.m_LabelFormat;
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         var _loc3_:int = 0;
         var _loc4_:EdgeMetrics = this.viewMetricsAndPadding;
         var _loc5_:Number = _loc4_.left;
         var _loc6_:Number = _loc4_.top;
         var _loc7_:Number = 0;
         var _loc8_:Number = param1 - _loc5_ - _loc4_.right;
         var _loc9_:Number = 0;
         if(this.m_MaxValue > this.m_MinValue)
         {
            _loc9_ = this.m_Value / (this.m_MaxValue - this.m_MinValue);
            _loc8_ = Math.round(_loc8_ * _loc9_);
         }
         graphics.clear();
         this.m_UIBackground.drawGrid(graphics,0,0,param1,param2);
         _loc5_ = getStyle("leftOrnamentOffset");
         this.m_UILeftOrnament.drawGrid(graphics,_loc5_,0,this.m_UILeftOrnament.measuredWidth,this.m_UILeftOrnament.measuredHeight);
         _loc5_ = param1 - this.m_UIRightOrnament.measuredWidth + getStyle("rightOrnamentOffset");
         this.m_UIRightOrnament.drawGrid(graphics,_loc5_,0,this.m_UIRightOrnament.measuredWidth,this.m_UIRightOrnament.measuredHeight);
         this.cacheBarImages(this.m_BarLimits == null || this.m_BarImages == null);
         _loc3_ = this.m_BarLimits.length - 1;
         while(_loc3_ >= 0)
         {
            if(_loc9_ >= this.m_BarLimits[_loc3_])
            {
               break;
            }
            _loc3_--;
         }
         if(_loc3_ > -1 && this.m_BarImages[_loc3_] != null)
         {
            s_Matrix.tx = this.direction == DIRECTION_RIGHT_TO_LEFT?Number(param1 - _loc4_.right - _loc8_):Number(_loc4_.left);
            s_Matrix.ty = _loc4_.top;
            graphics.beginBitmapFill(this.m_BarImages[_loc3_].bitmapData,s_Matrix,true,false);
            graphics.drawRect(s_Matrix.tx,s_Matrix.ty,_loc8_,this.m_BarImages[_loc3_].height);
         }
         if(this.m_MaxValue > this.m_MinValue && this.m_TickValues != null)
         {
            _loc7_ = param2 - _loc4_.top - _loc4_.bottom;
            _loc8_ = param1 - _loc4_.left - _loc4_.right;
            _loc6_ = _loc4_.top + (_loc7_ - this.m_UITick.measuredHeight) / 2 + getStyle("tickOffset");
            _loc3_ = this.m_TickValues.length - 1;
            while(_loc3_ >= 0)
            {
               _loc5_ = _loc4_.left + _loc8_ * this.m_TickValues[_loc3_] / (this.m_MaxValue - this.m_MinValue) - this.m_UITick.measuredWidth / 2;
               this.m_UITick.drawGrid(graphics,_loc5_,_loc6_,this.m_UITick.measuredWidth,this.m_UITick.measuredHeight);
               _loc3_--;
            }
         }
         graphics.endFill();
         this.cacheBarLabel();
         this.m_UILabel.visible = this.m_LabelEnabled;
         var _loc10_:String = getStyle("labelHorizontalAlign");
         if(_loc10_ == "center")
         {
            this.m_UILabel.x = (param1 - _loc4_.right) / 2 - this.m_UILabel.width / 2;
         }
         else if(_loc10_ == "left")
         {
            this.m_UILabel.x = _loc4_.left;
         }
         else if(_loc10_ == "right")
         {
            this.m_UILabel.x = param1 - _loc4_.right - this.m_UILabel.width;
         }
         else
         {
            this.m_UILabel.x = this.direction == DIRECTION_RIGHT_TO_LEFT?Number(param1 - _loc4_.right - this.m_UILabel.width):Number(_loc4_.left);
         }
         this.m_UILabel.y = _loc4_.top + (param2 - _loc4_.top - _loc4_.bottom - this.m_UILabel.height) / 2;
      }
      
      public function set minValue(param1:Number) : void
      {
         param1 = Math.max(0,param1);
         if(this.m_MinValue != param1)
         {
            this.m_MinValue = param1;
            this.m_UncommittedMinValue = true;
            invalidateDisplayList();
            invalidateProperties();
         }
      }
      
      override protected function createChildren() : void
      {
         if(!this.m_UIConstructed)
         {
            super.createChildren();
            this.m_UILabel = new Bitmap();
            addChild(this.m_UILabel);
            this.m_UIConstructed = true;
         }
      }
      
      public function set labelFormat(param1:String) : void
      {
         if(this.m_LabelFormat != param1)
         {
            this.m_LabelFormat = param1;
            this.m_UncommittedLabelFormat = true;
            invalidateDisplayList();
            invalidateProperties();
            invalidateSize();
         }
      }
      
      public function get labelEnabled() : Boolean
      {
         return this.m_LabelEnabled;
      }
      
      public function get tickValues() : Array
      {
         return this.m_TickValues;
      }
      
      public function get viewMetricsAndPadding() : EdgeMetrics
      {
         var _loc1_:EdgeMetrics = this.borderMetrics.clone();
         _loc1_.bottom = _loc1_.bottom + getStyle("paddingBottom");
         _loc1_.left = _loc1_.left + getStyle("paddingLeft");
         _loc1_.right = _loc1_.right + getStyle("paddingRight");
         _loc1_.top = _loc1_.top + getStyle("paddingTop");
         return _loc1_;
      }
      
      public function get minValue() : Number
      {
         return this.m_MinValue;
      }
      
      override public function set styleName(param1:Object) : void
      {
         if(styleName != param1)
         {
            super.styleName = param1;
            this.m_UIBackground.invalidateStyle();
            this.m_UILeftOrnament.invalidateStyle();
            this.m_UIRightOrnament.invalidateStyle();
            this.m_UITick.invalidateStyle();
            this.m_BarImages = null;
            this.m_BarLimits = null;
         }
      }
      
      override public function styleChanged(param1:String) : void
      {
         switch(param1)
         {
            case "barImages":
            case "barLimits":
               this.m_BarImages = null;
               this.m_BarLimits = null;
               invalidateDisplayList();
               break;
            case "fontColor":
            case "fontFamily":
            case "fontSize":
            case "fontStyle":
            case "fontWeight":
               this.m_BarLabel.defaultTextFormat = new TextFormat(getStyle("fontFamily"),getStyle("fontSize"),getStyle("fontColor"),getStyle("fontWeight") == "bold",getStyle("fontStyle") == "italic");
               invalidateDisplayList();
               break;
            default:
               super.styleChanged(param1);
         }
      }
      
      public function set tickValues(param1:Array) : void
      {
         if(this.m_TickValues != param1)
         {
            this.m_TickValues = param1;
            this.m_UncommittedTickValues = true;
            invalidateDisplayList();
            invalidateProperties();
         }
      }
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
         if(this.m_UncommittedMaxValue)
         {
            this.m_UncommittedMaxValue = false;
         }
         if(this.m_UncommittedMinValue)
         {
            this.m_UncommittedMinValue = false;
         }
         if(this.m_UncommittedValue)
         {
            this.m_UncommittedValue = false;
         }
         if(this.m_UncommittedLabelEnabled)
         {
            this.m_UncommittedLabelEnabled = false;
         }
         if(this.m_UncommittedLabelFormat)
         {
            this.m_UncommittedLabelFormat = false;
         }
         if(this.m_UncommittedTickValues)
         {
            this.m_UncommittedTickValues = false;
         }
      }
      
      public function set maxValue(param1:Number) : void
      {
         param1 = Math.max(0,param1);
         if(this.m_MaxValue != param1)
         {
            this.m_MaxValue = param1;
            this.m_UncommittedMaxValue = true;
            invalidateDisplayList();
            invalidateProperties();
         }
      }
      
      private function cacheBarLabel() : void
      {
         if(this.m_BarLabel == null)
         {
            this.m_BarLabel = createInFontContext(TextField) as TextField;
            this.m_BarLabel.autoSize = TextFieldAutoSize.LEFT;
            this.m_BarLabel.defaultTextFormat = new TextFormat(getStyle("fontFamily"),getStyle("fontSize"),getStyle("fontColor"),getStyle("fontWeight") == "bold",getStyle("fontStyle") == "italic");
            this.m_BarLabel.filters = [new GlowFilter(0,1,2,2,4,BitmapFilterQuality.LOW,false,false)];
         }
         this.m_BarLabel.text = StringUtil.substitute(this.m_LabelFormat,this.m_MinValue,this.m_Value,this.m_MaxValue);
         var _loc1_:BitmapData = this.m_UILabel.bitmapData;
         if(_loc1_ == null || _loc1_.width != this.m_BarLabel.width || _loc1_.height != this.m_BarLabel.height)
         {
            _loc1_ = this.m_UILabel.bitmapData = new BitmapData(this.m_BarLabel.width,this.m_BarLabel.height,true,0);
            _loc1_.lock();
         }
         else
         {
            _loc1_.lock();
            _loc1_.fillRect(new Rectangle(0,0,this.m_BarLabel.width,this.m_BarLabel.height),0);
         }
         _loc1_.draw(this.m_BarLabel);
         _loc1_.unlock();
      }
      
      public function set labelEnabled(param1:Boolean) : void
      {
         if(this.m_LabelEnabled != param1)
         {
            this.m_LabelEnabled = param1;
            this.m_UncommittedLabelEnabled = true;
            invalidateDisplayList();
            invalidateProperties();
            invalidateSize();
         }
      }
      
      override protected function measure() : void
      {
         measuredMinWidth = measuredWidth = this.m_UIBackground.measuredWidth;
         measuredMinHeight = measuredHeight = this.m_UIBackground.measuredHeight;
      }
      
      public function set value(param1:Number) : void
      {
         param1 = Math.max(this.m_MinValue,Math.min(param1,this.m_MaxValue));
         if(this.m_Value != param1)
         {
            this.m_Value = param1;
            this.m_UncommittedValue = true;
            invalidateDisplayList();
            invalidateProperties();
         }
      }
      
      public function get maxValue() : Number
      {
         return this.m_MaxValue;
      }
      
      public function get borderMetrics() : EdgeMetrics
      {
         return this.m_UIBackground.borderMetrics;
      }
      
      public function get value() : Number
      {
         return this.m_Value;
      }
   }
}
