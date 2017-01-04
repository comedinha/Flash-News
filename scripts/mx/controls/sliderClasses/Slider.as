package mx.controls.sliderClasses
{
   import flash.display.DisplayObject;
   import flash.display.Graphics;
   import flash.events.FocusEvent;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import mx.core.FlexVersion;
   import mx.core.IFlexDisplayObject;
   import mx.core.UIComponent;
   import mx.core.mx_internal;
   import mx.effects.Tween;
   import mx.events.FlexEvent;
   import mx.events.SliderEvent;
   import mx.events.SliderEventClickTarget;
   import mx.formatters.NumberFormatter;
   import mx.styles.ISimpleStyleClient;
   import mx.styles.StyleProxy;
   
   use namespace mx_internal;
   
   public class Slider extends UIComponent
   {
      
      mx_internal static const VERSION:String = "3.6.0.21751";
      
      mx_internal static var createAccessibilityImplementation:Function;
       
      
      private var _enabled:Boolean;
      
      private var snapIntervalChanged:Boolean = false;
      
      private var _direction:String = "horizontal";
      
      private var _thumbClass:Class;
      
      private var _labels:Array;
      
      public var allowTrackClick:Boolean = true;
      
      private var valuesChanged:Boolean = false;
      
      mx_internal var keyInteraction:Boolean = false;
      
      private var directionChanged:Boolean = false;
      
      private var enabledChanged:Boolean = false;
      
      private var dataFormatter:NumberFormatter;
      
      private var track:IFlexDisplayObject;
      
      private var _values:Array;
      
      private var initValues:Boolean = true;
      
      public var liveDragging:Boolean = false;
      
      private var thumbs:UIComponent;
      
      private var _tickInterval:Number = 0;
      
      private var ticksChanged:Boolean = false;
      
      private var minimumSet:Boolean = false;
      
      private var ticks:UIComponent;
      
      private var _thumbCount:int = 1;
      
      private var labelObjects:UIComponent;
      
      public var allowThumbOverlap:Boolean = false;
      
      private var snapIntervalPrecision:int = -1;
      
      mx_internal var dataTip:SliderDataTip;
      
      private var _snapInterval:Number = 0;
      
      private var thumbsChanged:Boolean = true;
      
      private var _tabIndex:Number;
      
      private var _sliderDataTipClass:Class;
      
      private var tabIndexChanged:Boolean;
      
      private var _tickValues:Array;
      
      private var labelsChanged:Boolean = false;
      
      private var interactionClickTarget:String;
      
      private var trackHighlightChanged:Boolean = true;
      
      private var _minimum:Number = 0;
      
      public var showDataTip:Boolean = true;
      
      mx_internal var innerSlider:UIComponent;
      
      private var labelStyleChanged:Boolean = false;
      
      private var _dataTipFormatFunction:Function;
      
      private var trackHitArea:UIComponent;
      
      private var highlightTrack:IFlexDisplayObject;
      
      private var _maximum:Number = 10;
      
      public function Slider()
      {
         _labels = [];
         _thumbClass = SliderThumb;
         _sliderDataTipClass = SliderDataTip;
         _tickValues = [];
         _values = [0,0];
         super();
         tabChildren = true;
      }
      
      public function get sliderThumbClass() : Class
      {
         return _thumbClass;
      }
      
      public function set sliderThumbClass(param1:Class) : void
      {
         _thumbClass = param1;
         thumbsChanged = true;
         invalidateProperties();
         invalidateDisplayList();
      }
      
      public function set tickInterval(param1:Number) : void
      {
         _tickInterval = param1;
         ticksChanged = true;
         invalidateProperties();
         invalidateDisplayList();
      }
      
      public function set direction(param1:String) : void
      {
         _direction = param1;
         directionChanged = true;
         invalidateProperties();
         invalidateSize();
         invalidateDisplayList();
      }
      
      public function get minimum() : Number
      {
         return _minimum;
      }
      
      override protected function commitProperties() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:* = false;
         var _loc4_:int = 0;
         var _loc5_:SliderLabel = null;
         var _loc6_:String = null;
         var _loc7_:Number = NaN;
         super.commitProperties();
         if(trackHighlightChanged)
         {
            trackHighlightChanged = false;
            if(getStyle("showTrackHighlight"))
            {
               createHighlightTrack();
            }
            else if(highlightTrack)
            {
               innerSlider.removeChild(DisplayObject(highlightTrack));
               highlightTrack = null;
            }
         }
         if(directionChanged)
         {
            directionChanged = false;
            _loc3_ = _direction == SliderDirection.HORIZONTAL;
            if(_loc3_)
            {
               DisplayObject(innerSlider).rotation = 0;
            }
            else
            {
               DisplayObject(innerSlider).rotation = -90;
               innerSlider.y = unscaledHeight;
            }
            if(labelObjects)
            {
               _loc4_ = labelObjects.numChildren - 1;
               while(_loc4_ >= 0)
               {
                  _loc5_ = SliderLabel(labelObjects.getChildAt(_loc4_));
                  _loc5_.rotation = !!_loc3_?Number(0):Number(90);
                  _loc4_--;
               }
            }
         }
         if(labelStyleChanged && !labelsChanged)
         {
            labelStyleChanged = false;
            if(labelObjects)
            {
               _loc6_ = getStyle("labelStyleName");
               _loc1_ = labelObjects.numChildren;
               _loc2_ = 0;
               while(_loc2_ < _loc1_)
               {
                  ISimpleStyleClient(labelObjects.getChildAt(_loc2_)).styleName = _loc6_;
                  _loc2_++;
               }
            }
         }
         if(ticksChanged)
         {
            ticksChanged = false;
            createTicks();
         }
         if(labelsChanged)
         {
            labelsChanged = false;
            createLabels();
         }
         if(thumbsChanged)
         {
            thumbsChanged = false;
            createThumbs();
         }
         if(initValues)
         {
            initValues = false;
            if(!valuesChanged)
            {
               _loc7_ = minimum;
               _loc1_ = _thumbCount;
               _loc2_ = 0;
               while(_loc2_ < _loc1_)
               {
                  _values[_loc2_] = _loc7_;
                  setValueAt(_loc7_,_loc2_);
                  if(_snapInterval && _snapInterval != 0)
                  {
                     _loc7_ = _loc7_ + snapInterval;
                  }
                  else
                  {
                     _loc7_++;
                  }
                  _loc2_++;
               }
               snapIntervalChanged = false;
            }
         }
         if(snapIntervalChanged)
         {
            snapIntervalChanged = false;
            if(!valuesChanged)
            {
               _loc1_ = thumbs.numChildren;
               _loc2_ = 0;
               while(_loc2_ < _loc1_)
               {
                  setValueAt(getValueFromX(SliderThumb(thumbs.getChildAt(_loc2_)).xPosition),_loc2_);
                  _loc2_++;
               }
            }
         }
         if(valuesChanged)
         {
            valuesChanged = false;
            _loc1_ = _thumbCount;
            _loc2_ = 0;
            while(_loc2_ < _loc1_)
            {
               setValueAt(getValueFromX(getXFromValue(Math.min(Math.max(values[_loc2_],minimum),maximum))),_loc2_);
               _loc2_++;
            }
         }
         if(enabledChanged)
         {
            enabledChanged = false;
            _loc1_ = thumbs.numChildren;
            _loc2_ = 0;
            while(_loc2_ < _loc1_)
            {
               SliderThumb(thumbs.getChildAt(_loc2_)).enabled = _enabled;
               _loc2_++;
            }
            _loc1_ = !!labelObjects?int(labelObjects.numChildren):0;
            _loc2_ = 0;
            while(_loc2_ < _loc1_)
            {
               SliderLabel(labelObjects.getChildAt(_loc2_)).enabled = _enabled;
               _loc2_++;
            }
         }
         if(tabIndexChanged)
         {
            tabIndexChanged = false;
            _loc1_ = thumbs.numChildren;
            _loc2_ = 0;
            while(_loc2_ < _loc1_)
            {
               SliderThumb(thumbs.getChildAt(_loc2_)).tabIndex = _tabIndex;
               _loc2_++;
            }
         }
      }
      
      mx_internal function getSnapValue(param1:Number, param2:SliderThumb = null) : Number
      {
         var _loc3_:Number = NaN;
         var _loc4_:Boolean = false;
         var _loc5_:Object = null;
         var _loc6_:SliderThumb = null;
         var _loc7_:SliderThumb = null;
         if(!isNaN(_snapInterval) && _snapInterval != 0)
         {
            _loc3_ = getValueFromX(param1);
            if(param2 && thumbs.numChildren > 1 && !allowThumbOverlap)
            {
               _loc4_ = true;
               _loc5_ = getXBounds(param2.thumbIndex);
               _loc6_ = param2.thumbIndex > 0?SliderThumb(thumbs.getChildAt(param2.thumbIndex - 1)):null;
               _loc7_ = param2.thumbIndex + 1 < thumbs.numChildren?SliderThumb(thumbs.getChildAt(param2.thumbIndex + 1)):null;
               if(_loc6_)
               {
                  _loc5_.min = _loc5_.min - _loc6_.width / 2;
                  if(_loc3_ == minimum)
                  {
                     if(getValueFromX(_loc6_.xPosition - _loc6_.width / 2) != minimum)
                     {
                        _loc4_ = false;
                     }
                  }
               }
               else if(_loc3_ == minimum)
               {
                  _loc4_ = false;
               }
               if(_loc7_)
               {
                  _loc5_.max = _loc5_.max + _loc7_.width / 2;
                  if(_loc3_ == maximum)
                  {
                     if(getValueFromX(_loc7_.xPosition + _loc7_.width / 2) != maximum)
                     {
                        _loc4_ = false;
                     }
                  }
               }
               else if(_loc3_ == maximum)
               {
                  _loc4_ = false;
               }
               if(_loc4_)
               {
                  _loc3_ = Math.min(Math.max(_loc3_,getValueFromX(Math.round(_loc5_.min)) + _snapInterval),getValueFromX(Math.round(_loc5_.max)) - _snapInterval);
               }
            }
            return getXFromValue(_loc3_);
         }
         return param1;
      }
      
      private function createHighlightTrack() : void
      {
         var _loc2_:Class = null;
         var _loc1_:Boolean = getStyle("showTrackHighlight");
         if(!highlightTrack && _loc1_)
         {
            _loc2_ = getStyle("trackHighlightSkin");
            highlightTrack = new _loc2_();
            if(highlightTrack is ISimpleStyleClient)
            {
               ISimpleStyleClient(highlightTrack).styleName = this;
            }
            innerSlider.addChildAt(DisplayObject(highlightTrack),innerSlider.getChildIndex(DisplayObject(track)) + 1);
         }
      }
      
      mx_internal function drawTrackHighlight() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         var _loc3_:SliderThumb = null;
         var _loc4_:SliderThumb = null;
         if(highlightTrack)
         {
            _loc3_ = SliderThumb(thumbs.getChildAt(0));
            if(_thumbCount > 1)
            {
               _loc1_ = _loc3_.xPosition;
               _loc4_ = SliderThumb(thumbs.getChildAt(1));
               _loc2_ = _loc4_.xPosition - _loc3_.xPosition;
            }
            else
            {
               _loc1_ = track.x;
               _loc2_ = _loc3_.xPosition - _loc1_;
            }
            highlightTrack.move(_loc1_,track.y + 1);
            highlightTrack.setActualSize(_loc2_ > 0?Number(_loc2_):Number(0),highlightTrack.height);
         }
      }
      
      mx_internal function getXBounds(param1:int) : Object
      {
         var _loc2_:Number = track.x + track.width;
         var _loc3_:Number = track.x;
         if(allowThumbOverlap)
         {
            return {
               "max":_loc2_,
               "min":_loc3_
            };
         }
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:SliderThumb = param1 > 0?SliderThumb(thumbs.getChildAt(param1 - 1)):null;
         var _loc7_:SliderThumb = param1 + 1 < thumbs.numChildren?SliderThumb(thumbs.getChildAt(param1 + 1)):null;
         if(_loc6_)
         {
            _loc4_ = _loc6_.xPosition + _loc6_.width / 2;
         }
         if(_loc7_)
         {
            _loc5_ = _loc7_.xPosition - _loc7_.width / 2;
         }
         if(isNaN(_loc4_))
         {
            _loc4_ = _loc3_;
         }
         else
         {
            _loc4_ = Math.min(Math.max(_loc3_,_loc4_),_loc2_);
         }
         if(isNaN(_loc5_))
         {
            _loc5_ = _loc2_;
         }
         else
         {
            _loc5_ = Math.max(Math.min(_loc2_,_loc5_),_loc3_);
         }
         return {
            "max":_loc5_,
            "min":_loc4_
         };
      }
      
      protected function get thumbStyleFilters() : Object
      {
         return null;
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         var _loc11_:Number = NaN;
         var _loc23_:SliderLabel = null;
         var _loc24_:SliderLabel = null;
         var _loc25_:SliderThumb = null;
         super.updateDisplayList(param1,param2);
         var _loc3_:* = _direction == SliderDirection.HORIZONTAL;
         var _loc4_:int = !!labelObjects?int(labelObjects.numChildren):0;
         var _loc5_:int = !!thumbs?int(thumbs.numChildren):0;
         var _loc6_:Number = getStyle("trackMargin");
         var _loc7_:Number = 6;
         var _loc8_:SliderThumb = SliderThumb(thumbs.getChildAt(0));
         if(thumbs && _loc8_)
         {
            _loc7_ = _loc8_.getExplicitOrMeasuredWidth();
         }
         var _loc9_:Number = _loc7_ / 2;
         var _loc10_:Number = _loc9_;
         var _loc12_:Number = 0;
         if(_loc4_ > 0)
         {
            _loc23_ = SliderLabel(labelObjects.getChildAt(0));
            _loc12_ = !!_loc3_?Number(_loc23_.getExplicitOrMeasuredWidth()):Number(_loc23_.getExplicitOrMeasuredHeight());
         }
         var _loc13_:Number = 0;
         if(_loc4_ > 1)
         {
            _loc24_ = SliderLabel(labelObjects.getChildAt(_loc4_ - 1));
            _loc13_ = !!_loc3_?Number(_loc24_.getExplicitOrMeasuredWidth()):Number(_loc24_.getExplicitOrMeasuredHeight());
         }
         if(!isNaN(_loc6_))
         {
            _loc11_ = _loc6_;
         }
         else
         {
            _loc11_ = (_loc12_ + _loc13_) / 2;
         }
         if(_loc4_ > 0)
         {
            if(!isNaN(_loc6_))
            {
               _loc9_ = Math.max(_loc9_,_loc11_ / (_loc4_ > 1?2:1));
            }
            else
            {
               _loc9_ = Math.max(_loc9_,_loc12_ / 2);
            }
         }
         else
         {
            _loc9_ = Math.max(_loc9_,_loc11_ / 2);
         }
         var _loc14_:Object = getComponentBounds();
         var _loc15_:Number = ((!!_loc3_?param2:param1) - (Number(_loc14_.lower) - Number(_loc14_.upper))) / 2 - Number(_loc14_.upper);
         track.move(Math.round(_loc9_),Math.round(_loc15_));
         track.setActualSize((!!_loc3_?param1:param2) - _loc9_ * 2,track.height);
         var _loc16_:Number = track.y + (track.height - _loc8_.getExplicitOrMeasuredHeight()) / 2 + getStyle("thumbOffset");
         var _loc17_:int = _thumbCount;
         var _loc18_:int = 0;
         while(_loc18_ < _loc17_)
         {
            _loc25_ = SliderThumb(thumbs.getChildAt(_loc18_));
            _loc25_.move(_loc25_.x,_loc16_);
            _loc25_.visible = true;
            _loc25_.setActualSize(_loc25_.getExplicitOrMeasuredWidth(),_loc25_.getExplicitOrMeasuredHeight());
            _loc18_++;
         }
         var _loc19_:Graphics = trackHitArea.graphics;
         var _loc20_:Number = 0;
         if(_tickInterval > 0 || _tickValues && _tickValues.length > 0)
         {
            _loc20_ = getStyle("tickLength");
         }
         _loc19_.clear();
         _loc19_.beginFill(0,0);
         var _loc21_:Number = _loc8_.getExplicitOrMeasuredHeight();
         var _loc22_:Number = !_loc21_?Number(0):Number(_loc21_ / 2);
         _loc19_.drawRect(track.x,track.y - _loc22_ - _loc20_,track.width,track.height + _loc21_ + _loc20_);
         _loc19_.endFill();
         if(_direction != SliderDirection.HORIZONTAL)
         {
            innerSlider.y = param2;
         }
         layoutTicks();
         layoutLabels();
         setPosFromValue();
         drawTrackHighlight();
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         if(!innerSlider)
         {
            innerSlider = new UIComponent();
            UIComponent(innerSlider).tabChildren = true;
            addChild(innerSlider);
         }
         createBackgroundTrack();
         if(!trackHitArea)
         {
            trackHitArea = new UIComponent();
            innerSlider.addChild(trackHitArea);
            trackHitArea.addEventListener(MouseEvent.MOUSE_DOWN,track_mouseDownHandler);
         }
         invalidateProperties();
      }
      
      public function set minimum(param1:Number) : void
      {
         _minimum = param1;
         ticksChanged = true;
         if(!initValues)
         {
            valuesChanged = true;
         }
         invalidateProperties();
         invalidateDisplayList();
      }
      
      public function get tickValues() : Array
      {
         return _tickValues;
      }
      
      public function get maximum() : Number
      {
         return _maximum;
      }
      
      private function createBackgroundTrack() : void
      {
         var _loc1_:Class = null;
         if(!track)
         {
            _loc1_ = getStyle("trackSkin");
            track = new _loc1_();
            if(track is ISimpleStyleClient)
            {
               ISimpleStyleClient(track).styleName = this;
            }
            innerSlider.addChildAt(DisplayObject(track),0);
         }
      }
      
      private function positionDataTip(param1:Object) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Number = param1.x;
         var _loc5_:Number = param1.y;
         var _loc6_:String = getStyle("dataTipPlacement");
         var _loc7_:Number = getStyle("dataTipOffset");
         if(_direction == SliderDirection.HORIZONTAL)
         {
            _loc2_ = _loc4_;
            _loc3_ = _loc5_;
            if(_loc6_ == "left")
            {
               _loc2_ = _loc2_ - (_loc7_ + dataTip.width);
               _loc3_ = _loc3_ + (param1.height - dataTip.height) / 2;
            }
            else if(_loc6_ == "right")
            {
               _loc2_ = _loc2_ + (_loc7_ + param1.width);
               _loc3_ = _loc3_ + (param1.height - dataTip.height) / 2;
            }
            else if(_loc6_ == "top")
            {
               _loc3_ = _loc3_ - (_loc7_ + dataTip.height);
               _loc2_ = _loc2_ - (dataTip.width - param1.width) / 2;
            }
            else if(_loc6_ == "bottom")
            {
               _loc3_ = _loc3_ + (_loc7_ + param1.height);
               _loc2_ = _loc2_ - (dataTip.width - param1.width) / 2;
            }
         }
         else
         {
            _loc2_ = _loc5_;
            _loc3_ = unscaledHeight - _loc4_ - (dataTip.height + param1.width) / 2;
            if(_loc6_ == "left")
            {
               _loc2_ = _loc2_ - (_loc7_ + dataTip.width);
            }
            else if(_loc6_ == "right")
            {
               _loc2_ = _loc2_ + (_loc7_ + param1.height);
            }
            else if(_loc6_ == "top")
            {
               _loc3_ = _loc3_ - (_loc7_ + (dataTip.height + param1.width) / 2);
               _loc2_ = _loc2_ - (dataTip.width - param1.height) / 2;
            }
            else if(_loc6_ == "bottom")
            {
               _loc3_ = _loc3_ + (_loc7_ + (dataTip.height + param1.width) / 2);
               _loc2_ = _loc2_ - (dataTip.width - param1.height) / 2;
            }
         }
         var _loc8_:Point = new Point(_loc2_,_loc3_);
         var _loc9_:Point = localToGlobal(_loc8_);
         _loc9_ = dataTip.parent.globalToLocal(_loc9_);
         dataTip.x = _loc9_.x < 0?Number(0):Number(_loc9_.x);
         dataTip.y = _loc9_.y < 0?Number(0):Number(_loc9_.y);
      }
      
      [Bindable("change")]
      public function get values() : Array
      {
         return _values;
      }
      
      private function createLabels() : void
      {
         var _loc1_:SliderLabel = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:String = null;
         if(labelObjects)
         {
            _loc2_ = labelObjects.numChildren - 1;
            while(_loc2_ >= 0)
            {
               labelObjects.removeChildAt(_loc2_);
               _loc2_--;
            }
         }
         else
         {
            labelObjects = new UIComponent();
            innerSlider.addChildAt(labelObjects,innerSlider.getChildIndex(trackHitArea));
         }
         if(_labels)
         {
            _loc3_ = _labels.length;
            _loc4_ = 0;
            while(_loc4_ < _loc3_)
            {
               _loc1_ = new SliderLabel();
               _loc1_.text = _labels[_loc4_] is String?_labels[_loc4_]:_labels[_loc4_].toString();
               if(_direction != SliderDirection.HORIZONTAL)
               {
                  _loc1_.rotation = 90;
               }
               _loc5_ = getStyle("labelStyleName");
               if(_loc5_)
               {
                  _loc1_.styleName = _loc5_;
               }
               labelObjects.addChild(_loc1_);
               _loc4_++;
            }
         }
      }
      
      private function destroyDataTip() : void
      {
         if(dataTip)
         {
            systemManager.toolTipChildren.removeChild(dataTip);
            dataTip = null;
         }
      }
      
      private function setValueFromPos(param1:int) : void
      {
         var _loc2_:SliderThumb = SliderThumb(thumbs.getChildAt(param1));
         setValueAt(getValueFromX(_loc2_.xPosition),param1);
      }
      
      public function set tickValues(param1:Array) : void
      {
         _tickValues = param1;
         ticksChanged = true;
         invalidateProperties();
         invalidateDisplayList();
      }
      
      override public function get enabled() : Boolean
      {
         return _enabled;
      }
      
      public function set values(param1:Array) : void
      {
         _values = param1;
         valuesChanged = true;
         minimumSet = true;
         invalidateProperties();
         invalidateDisplayList();
      }
      
      mx_internal function getXFromValue(param1:Number) : Number
      {
         var _loc2_:Number = NaN;
         if(param1 == minimum)
         {
            _loc2_ = track.x;
         }
         else if(param1 == maximum)
         {
            _loc2_ = track.x + track.width;
         }
         else
         {
            _loc2_ = track.x + (param1 - minimum) * track.width / (maximum - minimum);
         }
         return _loc2_;
      }
      
      public function set maximum(param1:Number) : void
      {
         _maximum = param1;
         ticksChanged = true;
         if(!initValues)
         {
            valuesChanged = true;
         }
         invalidateProperties();
         invalidateDisplayList();
      }
      
      mx_internal function onThumbPress(param1:Object) : void
      {
         var _loc3_:String = null;
         var _loc4_:String = null;
         if(showDataTip)
         {
            dataFormatter = new NumberFormatter();
            dataFormatter.precision = getStyle("dataTipPrecision");
            if(!dataTip)
            {
               dataTip = SliderDataTip(new sliderDataTipClass());
               systemManager.toolTipChildren.addChild(dataTip);
               _loc4_ = getStyle("dataTipStyleName");
               if(_loc4_)
               {
                  dataTip.styleName = _loc4_;
               }
            }
            if(_dataTipFormatFunction != null)
            {
               _loc3_ = this._dataTipFormatFunction(getValueFromX(param1.xPosition));
            }
            else
            {
               _loc3_ = dataFormatter.format(getValueFromX(param1.xPosition));
            }
            dataTip.text = _loc3_;
            dataTip.validateNow();
            dataTip.setActualSize(dataTip.getExplicitOrMeasuredWidth(),dataTip.getExplicitOrMeasuredHeight());
            positionDataTip(param1);
         }
         keyInteraction = false;
         var _loc2_:SliderEvent = new SliderEvent(SliderEvent.THUMB_PRESS);
         _loc2_.value = getValueFromX(param1.xPosition);
         _loc2_.thumbIndex = param1.thumbIndex;
         dispatchEvent(_loc2_);
      }
      
      public function setThumbValueAt(param1:int, param2:Number) : void
      {
         setValueAt(param2,param1,true);
         valuesChanged = true;
         invalidateProperties();
         invalidateDisplayList();
      }
      
      public function set snapInterval(param1:Number) : void
      {
         _snapInterval = param1;
         var _loc2_:Array = new String(1 + param1).split(".");
         if(_loc2_.length == 2)
         {
            snapIntervalPrecision = _loc2_[1].length;
         }
         else
         {
            snapIntervalPrecision = -1;
         }
         if(!isNaN(param1) && param1 != 0)
         {
            snapIntervalChanged = true;
            invalidateProperties();
            invalidateDisplayList();
         }
      }
      
      mx_internal function unRegisterMouseMove(param1:Function) : void
      {
         innerSlider.removeEventListener(MouseEvent.MOUSE_MOVE,param1);
      }
      
      mx_internal function getTrackHitArea() : UIComponent
      {
         return trackHitArea;
      }
      
      private function layoutTicks() : void
      {
         var _loc1_:Graphics = null;
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Boolean = false;
         var _loc8_:int = 0;
         var _loc9_:Number = NaN;
         if(ticks)
         {
            _loc1_ = ticks.graphics;
            _loc2_ = getStyle("tickLength");
            _loc3_ = getStyle("tickOffset");
            _loc4_ = getStyle("tickThickness");
            _loc6_ = getStyle("tickColor");
            _loc7_ = _tickValues && _tickValues.length > 0?true:false;
            _loc8_ = 0;
            _loc9_ = !!_loc7_?Number(_tickValues[_loc8_++]):Number(minimum);
            _loc1_.clear();
            if(_tickInterval > 0 || _loc7_)
            {
               _loc1_.lineStyle(_loc4_,_loc6_,100);
               do
               {
                  _loc5_ = Math.round(getXFromValue(_loc9_));
                  _loc1_.moveTo(_loc5_,_loc2_);
                  _loc1_.lineTo(_loc5_,0);
                  _loc9_ = !!_loc7_?_loc8_ < _tickValues.length?Number(_tickValues[_loc8_++]):Number(NaN):Number(_tickInterval + _loc9_);
               }
               while(_loc9_ < maximum || _loc7_ && _loc8_ < _tickValues.length);
               
               if(!_loc7_ || _loc9_ == maximum)
               {
                  _loc5_ = track.x + track.width - 1;
                  _loc1_.moveTo(_loc5_,_loc2_);
                  _loc1_.lineTo(_loc5_,0);
               }
               ticks.y = Math.round(track.y + _loc3_ - _loc2_);
            }
         }
      }
      
      public function getThumbAt(param1:int) : SliderThumb
      {
         return param1 >= 0 && param1 < thumbs.numChildren?SliderThumb(thumbs.getChildAt(param1)):null;
      }
      
      private function setPosFromValue() : void
      {
         var _loc3_:SliderThumb = null;
         var _loc1_:int = _thumbCount;
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = SliderThumb(thumbs.getChildAt(_loc2_));
            _loc3_.xPosition = getXFromValue(values[_loc2_]);
            _loc2_++;
         }
      }
      
      private function createThumbs() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:SliderThumb = null;
         if(thumbs)
         {
            _loc1_ = thumbs.numChildren;
            _loc2_ = _loc1_ - 1;
            while(_loc2_ >= 0)
            {
               thumbs.removeChildAt(_loc2_);
               _loc2_--;
            }
         }
         else
         {
            thumbs = new UIComponent();
            thumbs.tabChildren = true;
            thumbs.tabEnabled = false;
            innerSlider.addChild(thumbs);
         }
         _loc1_ = _thumbCount;
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = SliderThumb(new _thumbClass());
            _loc3_.owner = this;
            _loc3_.styleName = new StyleProxy(this,thumbStyleFilters);
            _loc3_.thumbIndex = _loc2_;
            _loc3_.visible = true;
            _loc3_.enabled = enabled;
            _loc3_.upSkinName = "thumbUpSkin";
            _loc3_.downSkinName = "thumbDownSkin";
            _loc3_.disabledSkinName = "thumbDisabledSkin";
            _loc3_.overSkinName = "thumbOverSkin";
            _loc3_.skinName = "thumbSkin";
            thumbs.addChild(_loc3_);
            _loc3_.addEventListener(FocusEvent.FOCUS_IN,thumb_focusInHandler);
            _loc3_.addEventListener(FocusEvent.FOCUS_OUT,thumb_focusOutHandler);
            _loc2_++;
         }
      }
      
      override public function set tabIndex(param1:int) : void
      {
         super.tabIndex = param1;
         _tabIndex = param1;
         tabIndexChanged = true;
         invalidateProperties();
      }
      
      public function get direction() : String
      {
         return _direction;
      }
      
      override public function set enabled(param1:Boolean) : void
      {
         _enabled = param1;
         enabledChanged = true;
         invalidateProperties();
      }
      
      override protected function measure() : void
      {
         var _loc1_:* = false;
         var _loc6_:Number = NaN;
         super.measure();
         _loc1_ = direction == SliderDirection.HORIZONTAL;
         var _loc2_:int = !!labelObjects?int(labelObjects.numChildren):0;
         var _loc3_:Number = getStyle("trackMargin");
         var _loc4_:Number = DEFAULT_MEASURED_WIDTH;
         if(!isNaN(_loc3_))
         {
            if(_loc2_ > 0)
            {
               _loc4_ = _loc4_ + (!!_loc1_?SliderLabel(labelObjects.getChildAt(0)).getExplicitOrMeasuredWidth() / 2:SliderLabel(labelObjects.getChildAt(0)).getExplicitOrMeasuredHeight() / 2);
            }
            if(_loc2_ > 1)
            {
               _loc4_ = _loc4_ + (!!_loc1_?SliderLabel(labelObjects.getChildAt(_loc2_ - 1)).getExplicitOrMeasuredWidth() / 2:SliderLabel(labelObjects.getChildAt(_loc2_ - 1)).getExplicitOrMeasuredHeight() / 2);
            }
         }
         var _loc5_:Object = getComponentBounds();
         _loc6_ = _loc5_.lower - _loc5_.upper;
         measuredMinWidth = measuredWidth = !!_loc1_?Number(_loc4_):Number(_loc6_);
         measuredMinHeight = measuredHeight = !!_loc1_?Number(_loc6_):Number(_loc4_);
      }
      
      [Bindable("valueCommit")]
      [Bindable("change")]
      public function get value() : Number
      {
         return _values[0];
      }
      
      public function get tickInterval() : Number
      {
         return _tickInterval;
      }
      
      override public function get baselinePosition() : Number
      {
         if(FlexVersion.compatibilityVersion < FlexVersion.VERSION_3_0)
         {
            return super.baselinePosition;
         }
         if(!validateBaselinePosition())
         {
            return NaN;
         }
         return int(0.75 * height);
      }
      
      mx_internal function getSnapIntervalWidth() : Number
      {
         return _snapInterval * track.width / (maximum - minimum);
      }
      
      private function thumb_focusOutHandler(param1:FocusEvent) : void
      {
         dispatchEvent(param1);
      }
      
      override protected function initializeAccessibility() : void
      {
         if(Slider.createAccessibilityImplementation != null)
         {
            Slider.createAccessibilityImplementation(this);
         }
      }
      
      public function get snapInterval() : Number
      {
         return _snapInterval;
      }
      
      public function set thumbCount(param1:int) : void
      {
         var _loc2_:int = param1 > 2?2:int(param1);
         _loc2_ = param1 < 1?1:int(param1);
         if(_loc2_ != _thumbCount)
         {
            _thumbCount = _loc2_;
            thumbsChanged = true;
            initValues = true;
            invalidateProperties();
            invalidateDisplayList();
         }
      }
      
      mx_internal function registerMouseMove(param1:Function) : void
      {
         innerSlider.addEventListener(MouseEvent.MOUSE_MOVE,param1);
      }
      
      public function set dataTipFormatFunction(param1:Function) : void
      {
         _dataTipFormatFunction = param1;
      }
      
      override public function styleChanged(param1:String) : void
      {
         var _loc2_:Boolean = param1 == null || param1 == "styleName";
         super.styleChanged(param1);
         if(param1 == "showTrackHighlight" || _loc2_)
         {
            trackHighlightChanged = true;
            invalidateProperties();
         }
         if(param1 == "trackHighlightSkin" || _loc2_)
         {
            if(innerSlider && highlightTrack)
            {
               innerSlider.removeChild(DisplayObject(highlightTrack));
               highlightTrack = null;
            }
            trackHighlightChanged = true;
            invalidateProperties();
         }
         if(param1 == "labelStyleName" || _loc2_)
         {
            labelStyleChanged = true;
            invalidateProperties();
         }
         if(param1 == "trackMargin" || _loc2_)
         {
            invalidateSize();
         }
         if(param1 == "trackSkin" || _loc2_)
         {
            if(track)
            {
               innerSlider.removeChild(DisplayObject(track));
               track = null;
               createBackgroundTrack();
            }
         }
         invalidateDisplayList();
      }
      
      public function set sliderDataTipClass(param1:Class) : void
      {
         _sliderDataTipClass = param1;
         invalidateProperties();
      }
      
      mx_internal function onThumbMove(param1:Object) : void
      {
         var _loc2_:Number = getValueFromX(param1.xPosition);
         if(showDataTip)
         {
            dataTip.text = _dataTipFormatFunction != null?_dataTipFormatFunction(_loc2_):dataFormatter.format(_loc2_);
            dataTip.setActualSize(dataTip.getExplicitOrMeasuredWidth(),dataTip.getExplicitOrMeasuredHeight());
            positionDataTip(param1);
         }
         if(liveDragging)
         {
            interactionClickTarget = SliderEventClickTarget.THUMB;
            setValueAt(_loc2_,param1.thumbIndex);
         }
         var _loc3_:SliderEvent = new SliderEvent(SliderEvent.THUMB_DRAG);
         _loc3_.value = _loc2_;
         _loc3_.thumbIndex = param1.thumbIndex;
         dispatchEvent(_loc3_);
      }
      
      private function layoutLabels() : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Object = null;
         var _loc7_:int = 0;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc1_:Number = !!labelObjects?Number(labelObjects.numChildren):Number(0);
         if(_loc1_ > 0)
         {
            _loc3_ = track.width / (_loc1_ - 1);
            _loc2_ = Math.max((_direction == SliderDirection.HORIZONTAL?unscaledWidth:unscaledHeight) - track.width,SliderThumb(thumbs.getChildAt(0)).getExplicitOrMeasuredWidth());
            _loc5_ = track.x;
            _loc7_ = 0;
            while(_loc7_ < _loc1_)
            {
               _loc6_ = labelObjects.getChildAt(_loc7_);
               _loc6_.setActualSize(_loc6_.getExplicitOrMeasuredWidth(),_loc6_.getExplicitOrMeasuredHeight());
               _loc8_ = track.y - _loc6_.height + getStyle("labelOffset");
               if(_direction == SliderDirection.HORIZONTAL)
               {
                  _loc4_ = _loc6_.getExplicitOrMeasuredWidth() / 2;
                  if(_loc7_ == 0)
                  {
                     _loc4_ = Math.min(_loc4_,_loc2_ / (_loc1_ > Number(1)?Number(2):Number(1)));
                  }
                  else if(_loc7_ == _loc1_ - 1)
                  {
                     _loc4_ = Math.max(_loc4_,_loc6_.getExplicitOrMeasuredWidth() - _loc2_ / 2);
                  }
                  _loc6_.move(_loc5_ - _loc4_,_loc8_);
               }
               else
               {
                  _loc9_ = getStyle("labelOffset");
                  _loc4_ = _loc6_.getExplicitOrMeasuredHeight() / 2;
                  if(_loc7_ == 0)
                  {
                     _loc4_ = Math.max(_loc4_,_loc6_.getExplicitOrMeasuredHeight() - _loc2_ / (_loc1_ > Number(1)?Number(2):Number(1)));
                  }
                  else if(_loc7_ == _loc1_ - 1)
                  {
                     _loc4_ = Math.min(_loc4_,_loc2_ / 2);
                  }
                  _loc6_.move(_loc5_ + _loc4_,track.y + _loc9_ + (_loc9_ > 0?0:-_loc6_.getExplicitOrMeasuredWidth()));
               }
               _loc5_ = _loc5_ + _loc3_;
               _loc7_++;
            }
         }
      }
      
      public function get thumbCount() : int
      {
         return _thumbCount;
      }
      
      private function getComponentBounds() : Object
      {
         var _loc3_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc8_:SliderLabel = null;
         var _loc9_:Number = NaN;
         var _loc10_:int = 0;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc1_:* = direction == SliderDirection.HORIZONTAL;
         var _loc2_:int = !!labelObjects?int(labelObjects.numChildren):0;
         var _loc4_:Number = 0;
         var _loc6_:Number = 0;
         var _loc7_:Number = track.height;
         if(_loc2_ > 0)
         {
            _loc8_ = SliderLabel(labelObjects.getChildAt(0));
            if(_loc1_)
            {
               _loc4_ = _loc8_.getExplicitOrMeasuredHeight();
            }
            else
            {
               _loc10_ = 0;
               while(_loc10_ < _loc2_)
               {
                  _loc8_ = SliderLabel(labelObjects.getChildAt(_loc10_));
                  _loc4_ = Math.max(_loc4_,_loc8_.getExplicitOrMeasuredWidth());
                  _loc10_++;
               }
            }
            _loc9_ = getStyle("labelOffset");
            _loc3_ = _loc9_ - (_loc9_ > 0?0:_loc4_);
            _loc6_ = Math.min(_loc6_,_loc3_);
            _loc7_ = Math.max(_loc7_,_loc9_ + (_loc9_ > 0?_loc4_:0));
         }
         if(ticks)
         {
            _loc11_ = getStyle("tickLength");
            _loc12_ = getStyle("tickOffset");
            _loc6_ = Math.min(_loc6_,_loc12_ - _loc11_);
            _loc7_ = Math.max(_loc7_,_loc12_);
         }
         if(thumbs.numChildren > 0)
         {
            _loc5_ = (track.height - SliderThumb(thumbs.getChildAt(0)).getExplicitOrMeasuredHeight()) / 2 + getStyle("thumbOffset");
            _loc6_ = Math.min(_loc6_,_loc5_);
            _loc7_ = Math.max(_loc7_,_loc5_ + SliderThumb(thumbs.getChildAt(0)).getExplicitOrMeasuredHeight());
         }
         return {
            "lower":_loc7_,
            "upper":_loc6_
         };
      }
      
      mx_internal function onThumbRelease(param1:Object) : void
      {
         interactionClickTarget = SliderEventClickTarget.THUMB;
         destroyDataTip();
         setValueFromPos(param1.thumbIndex);
         dataFormatter = null;
         var _loc2_:SliderEvent = new SliderEvent(SliderEvent.THUMB_RELEASE);
         _loc2_.value = getValueFromX(param1.xPosition);
         _loc2_.thumbIndex = param1.thumbIndex;
         dispatchEvent(_loc2_);
      }
      
      public function get dataTipFormatFunction() : Function
      {
         return _dataTipFormatFunction;
      }
      
      public function set value(param1:Number) : void
      {
         setValueAt(param1,0,true);
         valuesChanged = true;
         minimumSet = true;
         invalidateProperties();
         invalidateDisplayList();
         dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));
      }
      
      mx_internal function updateThumbValue(param1:int) : void
      {
         setValueFromPos(param1);
      }
      
      private function track_mouseDownHandler(param1:MouseEvent) : void
      {
         var _loc2_:Point = null;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:SliderThumb = null;
         var _loc9_:Number = NaN;
         var _loc10_:Tween = null;
         var _loc11_:Function = null;
         var _loc12_:Number = NaN;
         if(param1.target != trackHitArea && param1.target != ticks)
         {
            return;
         }
         if(enabled && allowTrackClick)
         {
            interactionClickTarget = SliderEventClickTarget.TRACK;
            keyInteraction = false;
            _loc2_ = new Point(param1.localX,param1.localY);
            _loc3_ = _loc2_.x;
            _loc4_ = 0;
            _loc5_ = 10000000;
            _loc6_ = _thumbCount;
            _loc7_ = 0;
            while(_loc7_ < _loc6_)
            {
               _loc12_ = Math.abs(SliderThumb(thumbs.getChildAt(_loc7_)).xPosition - _loc3_);
               if(_loc12_ < _loc5_)
               {
                  _loc4_ = _loc7_;
                  _loc5_ = _loc12_;
               }
               _loc7_++;
            }
            _loc8_ = SliderThumb(thumbs.getChildAt(_loc4_));
            if(!isNaN(_snapInterval) && _snapInterval != 0)
            {
               _loc3_ = getXFromValue(getValueFromX(_loc3_));
            }
            _loc9_ = getStyle("slideDuration");
            _loc10_ = new Tween(_loc8_,_loc8_.xPosition,_loc3_,_loc9_);
            _loc11_ = getStyle("slideEasingFunction") as Function;
            if(_loc11_ != null)
            {
               _loc10_.easingFunction = _loc11_;
            }
            drawTrackHighlight();
         }
      }
      
      public function get sliderDataTipClass() : Class
      {
         return _sliderDataTipClass;
      }
      
      private function createTicks() : void
      {
         if(!ticks)
         {
            ticks = new UIComponent();
            innerSlider.addChild(ticks);
         }
      }
      
      mx_internal function getValueFromX(param1:Number) : Number
      {
         var _loc2_:Number = (param1 - track.x) * (maximum - minimum) / track.width + minimum;
         if(_loc2_ - minimum <= 0.002)
         {
            _loc2_ = minimum;
         }
         else if(maximum - _loc2_ <= 0.002)
         {
            _loc2_ = maximum;
         }
         else if(!isNaN(_snapInterval) && _snapInterval != 0)
         {
            _loc2_ = Math.round((_loc2_ - minimum) / _snapInterval) * _snapInterval + minimum;
         }
         return _loc2_;
      }
      
      private function thumb_focusInHandler(param1:FocusEvent) : void
      {
         dispatchEvent(param1);
      }
      
      private function setValueAt(param1:Number, param2:int, param3:Boolean = false) : void
      {
         var _loc5_:Number = NaN;
         var _loc6_:SliderEvent = null;
         var _loc4_:Number = _values[param2];
         if(snapIntervalPrecision != -1)
         {
            _loc5_ = Math.pow(10,snapIntervalPrecision);
            param1 = Math.round(param1 * _loc5_) / _loc5_;
         }
         _values[param2] = param1;
         if(!param3)
         {
            _loc6_ = new SliderEvent(SliderEvent.CHANGE);
            _loc6_.value = param1;
            _loc6_.thumbIndex = param2;
            _loc6_.clickTarget = interactionClickTarget;
            if(keyInteraction)
            {
               _loc6_.triggerEvent = new KeyboardEvent(KeyboardEvent.KEY_DOWN);
               keyInteraction = false;
            }
            else
            {
               _loc6_.triggerEvent = new MouseEvent(MouseEvent.CLICK);
            }
            if(!isNaN(_loc4_))
            {
               if(Math.abs(_loc4_ - param1) > 0.002)
               {
                  dispatchEvent(_loc6_);
               }
            }
            else if(!isNaN(param1))
            {
               dispatchEvent(_loc6_);
            }
         }
         invalidateDisplayList();
      }
      
      public function set labels(param1:Array) : void
      {
         _labels = param1;
         labelsChanged = true;
         invalidateProperties();
         invalidateSize();
         invalidateDisplayList();
      }
      
      public function get labels() : Array
      {
         return _labels;
      }
   }
}
