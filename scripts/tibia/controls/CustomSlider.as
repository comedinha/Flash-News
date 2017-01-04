package tibia.controls
{
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import mx.containers.Canvas;
   import mx.controls.Button;
   import mx.controls.HSlider;
   import mx.controls.sliderClasses.Slider;
   import mx.controls.sliderClasses.SliderDirection;
   import mx.controls.sliderClasses.SliderThumb;
   import mx.core.EdgeMetrics;
   import mx.core.UIComponent;
   import mx.core.mx_internal;
   import mx.events.SliderEvent;
   import mx.skins.halo.SliderHighlightSkin;
   import mx.skins.halo.SliderThumbSkin;
   import mx.skins.halo.SliderTrackSkin;
   import mx.styles.CSSStyleDeclaration;
   import mx.styles.StyleManager;
   import mx.styles.StyleProxy;
   import shared.controls.CustomButton;
   import tibia.input.MouseRepeatEvent;
   
   public class CustomSlider extends Canvas
   {
      
      private static const SLIDER_STYLE_FILTER:Object = {
         "borderColor":"borderColor",
         "dataTipOffset":"dataTipOffset",
         "dataTipPrecision":"dataTipPrecision",
         "dataTipStyleName":"dataTipStyleName",
         "fillAlphas":"fillAlphas",
         "fillColors":"fillColors",
         "invertThumbDirection":"invertThumbDirection",
         "labelOffset":"labelOffset",
         "labelStyleName":"labelStyleName",
         "showTrackHighlight":"showTrackHighlight",
         "slideDuration":"slideDuration",
         "slideEasingFunction":"slideEasingFunction",
         "thumbDisabledSkin":"thumbDisabledSkin",
         "thumbDownSkin":"thumbDownSkin",
         "thumbOffset":"thumbOffset",
         "thumbOverSkin":"thumbOverSkin",
         "thumbSkin":"thumbSkin",
         "thumbUpSkin":"thumbUpSkin",
         "tickColor":"tickColor",
         "tickLength":"tickLength",
         "tickOffset":"tickOffset",
         "tickThickness":"tickThickness",
         "trackColors":"trackColors",
         "trackHighlightSkin":"trackHighlightSkin",
         "trackMargin":"trackMargin",
         "trackSkin":"trackSkin"
      };
      
      {
         s_InitialiseStyle();
      }
      
      protected var m_UIIncrease:Button = null;
      
      protected var m_TrackClickEnabled:Boolean = true;
      
      protected var m_ButtonClickEnabled:Boolean = true;
      
      protected var m_UISlider:Slider = null;
      
      private var m_UIConstructed:Boolean = false;
      
      protected var m_UIDecrease:Button = null;
      
      protected var m_TrackClickAmount:Number = 10.0;
      
      public function CustomSlider()
      {
         super();
         this.m_UISlider = new HSlider();
         this.m_UISlider.addEventListener(SliderEvent.CHANGE,this.onSliderEvent);
         this.m_UISlider.addEventListener(SliderEvent.THUMB_DRAG,this.onSliderEvent);
         this.m_UISlider.addEventListener(SliderEvent.THUMB_PRESS,this.onSliderEvent);
         this.m_UISlider.addEventListener(SliderEvent.THUMB_RELEASE,this.onSliderEvent);
         this.m_UIDecrease = new CustomButton();
         this.m_UIIncrease = new CustomButton();
      }
      
      private static function s_InitialiseStyle() : void
      {
         var Selector:String = "CustomSlider";
         var Decl:CSSStyleDeclaration = StyleManager.getStyleDeclaration(Selector);
         if(Decl == null)
         {
            Decl = new CSSStyleDeclaration(Selector);
         }
         Decl.defaultFactory = function():void
         {
            this.horizontalAlign = "center";
            this.verticalAlign = "middle";
            this.horizontalGap = 2;
            this.verticalGap = 2;
            this.borderColor = 9542041;
            this.dataTipOffset = 16;
            this.dataTipPlacement = "top";
            this.dataTipPrecision = 2;
            this.labelOffset = -10;
            this.showTrackHighlight = false;
            this.slideDuration = 300;
            this.thumbDisabledSkin = null;
            this.thumbDownSkin = null;
            this.thumbOffset = 0;
            this.thumbOverSkin = null;
            this.thumbSkin = SliderThumbSkin;
            this.thumbUpSkin = null;
            this.tickColor = 7305079;
            this.tickLength = 3;
            this.tickOffset = -6;
            this.tickThickness = 1;
            this.trackColors = [15198183,15198183];
            this.trackHighlightSkin = SliderHighlightSkin;
            this.trackSkin = SliderTrackSkin;
         };
         StyleManager.setStyleDeclaration(Selector,Decl,true);
      }
      
      public function get tickInterval() : Number
      {
         return this.m_UISlider.tickInterval;
      }
      
      public function get sliderThumbClass() : Class
      {
         return this.m_UISlider.sliderThumbClass;
      }
      
      public function set tickInterval(param1:Number) : void
      {
         this.m_UISlider.tickInterval = param1;
      }
      
      public function set labels(param1:Array) : void
      {
         this.m_UISlider.labels = param1;
      }
      
      public function set sliderThumbClass(param1:Class) : void
      {
         this.m_UISlider.sliderThumbClass = param1;
      }
      
      public function get minimum() : Number
      {
         return this.m_UISlider.minimum;
      }
      
      public function get labels() : Array
      {
         return this.m_UISlider.labels;
      }
      
      override protected function createChildren() : void
      {
         if(!this.m_UIConstructed)
         {
            super.createChildren();
            this.m_UIDecrease.styleName = getStyle("decreaseButtonStyle");
            this.m_UIDecrease.addEventListener(MouseEvent.MOUSE_DOWN,this.onButtonDown);
            this.m_UIDecrease.addEventListener(MouseEvent.CLICK,this.onButtonClick);
            this.m_UIDecrease.addEventListener(MouseRepeatEvent.REPEAT_MOUSE_DOWN,this.onButtonClick);
            addChild(this.m_UIDecrease);
            this.m_UISlider.allowTrackClick = false;
            this.m_UISlider.minHeight = NaN;
            this.m_UISlider.minWidth = 10;
            this.m_UISlider.sliderThumbClass = SliderThumbNoKeyboard;
            this.m_UISlider.styleName = new StyleProxy(this,SLIDER_STYLE_FILTER);
            this.m_UISlider.addEventListener(MouseEvent.CLICK,this.onTrackDown);
            addChild(this.m_UISlider);
            this.m_UIIncrease.styleName = getStyle("increaseButtonStyle");
            this.m_UIIncrease.addEventListener(MouseEvent.MOUSE_DOWN,this.onButtonDown);
            this.m_UIIncrease.addEventListener(MouseEvent.CLICK,this.onButtonClick);
            this.m_UIIncrease.addEventListener(MouseRepeatEvent.REPEAT_MOUSE_DOWN,this.onButtonClick);
            addChild(this.m_UIIncrease);
            this.m_UIConstructed = true;
         }
      }
      
      public function set minimum(param1:Number) : void
      {
         this.m_UISlider.minimum = param1;
         this.m_UIDecrease.enabled = this.value > param1;
      }
      
      protected function onButtonClick(param1:MouseEvent) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:SliderEvent = null;
         if(this.m_ButtonClickEnabled)
         {
            _loc2_ = !!param1.shiftKey?Number(10):Number(1);
            if(param1.currentTarget == this.m_UIDecrease)
            {
               this.value = this.value - this.m_UISlider.snapInterval * _loc2_;
            }
            else
            {
               this.value = this.value + this.m_UISlider.snapInterval * _loc2_;
            }
            _loc3_ = new SliderEvent(SliderEvent.CHANGE);
            _loc3_.clickTarget = String(param1.currentTarget);
            _loc3_.thumbIndex = 0;
            _loc3_.triggerEvent = new MouseEvent(MouseEvent.CLICK);
            _loc3_.value = this.value;
            dispatchEvent(_loc3_);
         }
      }
      
      public function get tickValues() : Array
      {
         return this.m_UISlider.tickValues;
      }
      
      public function get maximum() : Number
      {
         return this.m_UISlider.maximum;
      }
      
      public function get values() : Array
      {
         return this.m_UISlider.values;
      }
      
      public function get allowTrackClick() : Boolean
      {
         return this.m_TrackClickEnabled;
      }
      
      public function set showDataTip(param1:Boolean) : void
      {
         this.m_UISlider.showDataTip = param1;
      }
      
      public function get snapInterval() : Number
      {
         return this.m_UISlider.snapInterval;
      }
      
      public function set thumbCount(param1:int) : void
      {
      }
      
      public function set liveDragging(param1:Boolean) : void
      {
         this.m_UISlider.liveDragging = param1;
      }
      
      public function set tickValues(param1:Array) : void
      {
         this.m_UISlider.tickValues = param1;
      }
      
      public function set dataTipFormatFunction(param1:Function) : void
      {
         this.m_UISlider.dataTipFormatFunction = param1;
      }
      
      protected function onButtonDown(param1:MouseEvent) : void
      {
         if(param1 is MouseRepeatEvent)
         {
            MouseRepeatEvent(param1).repeatEnabled = true;
         }
      }
      
      public function set values(param1:Array) : void
      {
         this.m_UISlider.values = param1;
      }
      
      public function set maximum(param1:Number) : void
      {
         this.m_UISlider.maximum = param1;
         this.m_UIIncrease.enabled = this.value < param1;
      }
      
      public function set allowTrackClick(param1:Boolean) : void
      {
         this.m_TrackClickEnabled = param1;
      }
      
      public function set sliderDataTipClass(param1:Class) : void
      {
         this.m_UISlider.sliderDataTipClass = param1;
      }
      
      public function get showDataTip() : Boolean
      {
         return this.m_UISlider.showDataTip;
      }
      
      public function setThumbValueAt(param1:int, param2:Number) : void
      {
         return this.m_UISlider.setThumbValueAt(param1,param2);
      }
      
      public function get thumbCount() : int
      {
         return this.m_UISlider.thumbCount;
      }
      
      protected function onSliderEvent(param1:SliderEvent) : void
      {
         if(param1 != null && (!param1.cancelable || !param1.isDefaultPrevented()))
         {
            dispatchEvent(param1.clone());
            this.m_UIDecrease.enabled = this.value > this.minimum;
            this.m_UIIncrease.enabled = this.value < this.maximum;
         }
      }
      
      public function get liveDragging() : Boolean
      {
         return this.m_UISlider.liveDragging;
      }
      
      public function set snapInterval(param1:Number) : void
      {
         this.m_UISlider.snapInterval = param1;
      }
      
      public function set value(param1:Number) : void
      {
         this.m_UISlider.value = param1;
         this.m_UIDecrease.enabled = param1 > this.minimum;
         this.m_UIIncrease.enabled = param1 < this.maximum;
      }
      
      override protected function measure() : void
      {
         var _loc1_:EdgeMetrics = null;
         var _loc10_:UIComponent = null;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         super.measure();
         _loc1_ = viewMetricsAndPadding;
         var _loc2_:Number = getStyle("horizontalGap");
         var _loc3_:Number = getStyle("verticalGap");
         var _loc4_:Number = 0;
         var _loc5_:Number = 0;
         var _loc6_:Number = 0;
         var _loc7_:Number = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         while(_loc9_ < numChildren)
         {
            _loc10_ = UIComponent(getChildAt(_loc9_));
            if(!(_loc10_ == null || !_loc10_.includeInLayout))
            {
               _loc11_ = _loc10_.getExplicitOrMeasuredHeight();
               _loc12_ = _loc10_.getExplicitOrMeasuredWidth();
               _loc13_ = !isNaN(_loc10_.explicitMinHeight)?Number(_loc10_.explicitMinHeight):Number(_loc10_.measuredMinHeight);
               _loc14_ = !isNaN(_loc10_.explicitMinWidth)?Number(_loc10_.explicitMinWidth):Number(_loc10_.measuredMinWidth);
               if(this.direction == SliderDirection.HORIZONTAL)
               {
                  _loc7_ = _loc7_ + _loc14_;
                  _loc6_ = _loc6_ + _loc12_;
                  _loc5_ = Math.max(_loc5_,_loc13_);
                  _loc4_ = Math.max(_loc4_,_loc11_);
               }
               else
               {
                  _loc7_ = Math.max(_loc7_,_loc14_);
                  _loc6_ = Math.max(_loc7_,_loc12_);
                  _loc5_ = _loc5_ + _loc13_;
                  _loc4_ = _loc4_ + _loc11_;
               }
               _loc8_++;
            }
            _loc9_++;
         }
         _loc8_ = Math.max(0,_loc8_ - 1);
         if(this.direction == SliderDirection.HORIZONTAL)
         {
            _loc7_ = _loc7_ + _loc8_ * _loc2_;
            _loc6_ = _loc6_ + _loc8_ * _loc2_;
         }
         else
         {
            _loc5_ = _loc5_ + _loc8_ * _loc3_;
            _loc4_ = _loc4_ + _loc8_ * _loc3_;
         }
         measuredMinWidth = _loc7_ + _loc1_.left + _loc1_.right;
         measuredWidth = _loc6_ + _loc1_.left + _loc1_.right;
         measuredMinHeight = _loc5_ + _loc1_.top + _loc1_.bottom;
         measuredHeight = _loc4_ + _loc1_.top + _loc1_.bottom;
      }
      
      public function get sliderDataTipClass() : Class
      {
         return this.m_UISlider.sliderDataTipClass;
      }
      
      public function set trackClickAmount(param1:Number) : void
      {
         this.m_TrackClickAmount = param1;
      }
      
      protected function onTrackDown(param1:MouseEvent) : void
      {
         var _loc2_:UIComponent = null;
         var _loc3_:Number = NaN;
         var _loc4_:SliderEvent = null;
         if(this.m_TrackClickEnabled && param1 != null && param1.target == this.m_UISlider.mx_internal::getTrackHitArea())
         {
            _loc2_ = this.m_UISlider.getThumbAt(0);
            _loc3_ = _loc2_.localToGlobal(new Point(0,0)).x + _loc2_.width / _loc2_.scaleX / 2;
            if(param1.stageX < _loc3_)
            {
               this.value = this.value - this.m_TrackClickAmount;
            }
            else
            {
               this.value = this.value + this.m_TrackClickAmount;
            }
            _loc4_ = new SliderEvent(SliderEvent.CHANGE);
            _loc4_.clickTarget = String(param1.target);
            _loc4_.thumbIndex = 0;
            _loc4_.triggerEvent = new MouseEvent(MouseEvent.CLICK);
            _loc4_.value = this.value;
            dispatchEvent(_loc4_);
         }
      }
      
      public function get dataTipFormatFunction() : Function
      {
         return this.m_UISlider.dataTipFormatFunction;
      }
      
      public function get value() : Number
      {
         return this.m_UISlider.value;
      }
      
      public function getThumbAt(param1:int) : SliderThumb
      {
         return this.m_UISlider.getThumbAt(param1);
      }
      
      public function set allowThumbOverlap(param1:Boolean) : void
      {
         this.m_UISlider.allowThumbOverlap = param1;
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         super.updateDisplayList(param1,param2);
         var _loc3_:EdgeMetrics = viewMetricsAndPadding;
         var _loc4_:Number = getStyle("horizontalGap");
         var _loc5_:Number = getStyle("verticalGap");
         var _loc6_:Number = 0;
         var _loc7_:Number = 0;
         var _loc8_:Number = 0;
         var _loc9_:Number = 0;
         var _loc10_:Number = 0;
         if(this.direction == SliderDirection.HORIZONTAL)
         {
            param2 = param2 - (_loc3_.top + _loc3_.bottom);
            _loc6_ = this.m_UIDecrease.getExplicitOrMeasuredHeight();
            _loc7_ = this.m_UIDecrease.getExplicitOrMeasuredWidth();
            this.m_UIDecrease.move(_loc3_.left,_loc3_.top + (param2 - _loc6_) / 2);
            this.m_UIDecrease.setActualSize(_loc7_,_loc6_);
            _loc8_ = _loc3_.left + _loc7_ + _loc4_;
            _loc10_ = param1 - _loc8_;
            _loc6_ = this.m_UIIncrease.getExplicitOrMeasuredHeight();
            _loc7_ = this.m_UIIncrease.getExplicitOrMeasuredWidth();
            this.m_UIIncrease.move(param1 - _loc3_.right - _loc7_,_loc3_.top + (param2 - _loc6_) / 2);
            this.m_UIIncrease.setActualSize(_loc7_,_loc6_);
            _loc10_ = _loc10_ - (_loc3_.right + _loc7_ + _loc4_);
            _loc6_ = this.m_UISlider.getExplicitOrMeasuredHeight();
            _loc7_ = this.m_UISlider.getExplicitOrMeasuredWidth();
            this.m_UISlider.move(_loc8_,_loc3_.top + (param2 - _loc6_) / 2);
            this.m_UISlider.setActualSize(_loc10_,_loc6_);
         }
         else
         {
            param1 = param1 - (_loc3_.left + _loc3_.right);
            _loc6_ = this.m_UIDecrease.getExplicitOrMeasuredHeight();
            _loc7_ = this.m_UIDecrease.getExplicitOrMeasuredWidth();
            this.m_UIDecrease.move(_loc3_.left + (param1 - _loc7_) / 2,_loc3_.top);
            this.m_UIDecrease.setActualSize(_loc7_,_loc6_);
            _loc9_ = _loc3_.top + _loc6_ + _loc5_;
            _loc10_ = param2 - _loc9_;
            _loc6_ = this.m_UIIncrease.getExplicitOrMeasuredHeight();
            _loc7_ = this.m_UIIncrease.getExplicitOrMeasuredWidth();
            this.m_UIIncrease.move(_loc3_.left + (param1 - _loc7_) / 2,param2 - _loc3_.bottom - _loc6_);
            this.m_UIIncrease.setActualSize(_loc7_,_loc6_);
            _loc10_ = _loc10_ - (_loc3_.bottom + _loc6_ + _loc5_);
            _loc6_ = this.m_UISlider.getExplicitOrMeasuredHeight();
            _loc7_ = this.m_UISlider.getExplicitOrMeasuredWidth();
            this.m_UISlider.move(_loc3_.left + (param1 - _loc7_) / 2,_loc9_);
            this.m_UISlider.setActualSize(_loc7_,_loc10_);
         }
      }
      
      public function get allowThumbOverlap() : Boolean
      {
         return this.m_UISlider.allowThumbOverlap;
      }
      
      public function set direction(param1:String) : void
      {
      }
      
      public function get direction() : String
      {
         return this.m_UISlider.direction;
      }
   }
}

import flash.events.KeyboardEvent;
import mx.controls.sliderClasses.SliderThumb;

class SliderThumbNoKeyboard extends SliderThumb
{
    
   
   function SliderThumbNoKeyboard()
   {
      super();
   }
   
   override protected function keyUpHandler(param1:KeyboardEvent) : void
   {
   }
   
   override protected function keyDownHandler(param1:KeyboardEvent) : void
   {
   }
}
