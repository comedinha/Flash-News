package mx.controls
{
   import mx.managers.IFocusManagerComponent;
   import mx.core.mx_internal;
   import mx.core.EdgeMetrics;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.EventPhase;
   import flash.ui.Keyboard;
   import mx.containers.BoxDirection;
   import mx.core.IUIComponent;
   import flash.events.MouseEvent;
   import flash.display.DisplayObject;
   import mx.core.IFlexDisplayObject;
   import mx.styles.StyleManager;
   import mx.events.ChildExistenceChangedEvent;
   import mx.core.ClassFactory;
   import mx.controls.buttonBarClasses.ButtonBarButton;
   
   use namespace mx_internal;
   
   public class ButtonBar extends NavBar implements IFocusManagerComponent
   {
      
      mx_internal static const VERSION:String = "3.6.0.21751";
       
      
      mx_internal var simulatedClickTriggerEvent:Event = null;
      
      mx_internal var focusedIndex:int = 0;
      
      private var directionChanged:Boolean = false;
      
      mx_internal var buttonWidthProp:String = "buttonWidth";
      
      private var oldUnscaledHeight:Number;
      
      mx_internal var buttonStyleNameProp:String = "buttonStyleName";
      
      mx_internal var lastButtonStyleNameProp:String = "lastButtonStyleName";
      
      private var recalcButtonWidths:Boolean = false;
      
      private var oldUnscaledWidth:Number;
      
      private var recalcButtonHeights:Boolean = false;
      
      mx_internal var buttonHeightProp:String = "buttonHeight";
      
      mx_internal var firstButtonStyleNameProp:String = "firstButtonStyleName";
      
      public function ButtonBar()
      {
         super();
         tabEnabled = true;
         navItemFactory = new ClassFactory(ButtonBarButton);
         addEventListener("scaleXChanged",scaleChangedHandler);
         addEventListener("scaleYChanged",scaleChangedHandler);
         addEventListener(ChildExistenceChangedEvent.CHILD_REMOVE,childRemoveHandler);
      }
      
      override public function get borderMetrics() : EdgeMetrics
      {
         return EdgeMetrics.EMPTY;
      }
      
      protected function resetButtonHeights() : void
      {
         var _loc2_:Button = null;
         var _loc1_:int = 0;
         while(_loc1_ < numChildren)
         {
            _loc2_ = getChildAt(_loc1_) as Button;
            if(_loc2_)
            {
               _loc2_.explicitHeight = NaN;
               _loc2_.minHeight = NaN;
               _loc2_.maxHeight = NaN;
            }
            _loc1_++;
         }
      }
      
      override protected function keyUpHandler(param1:KeyboardEvent) : void
      {
         var _loc2_:Button = null;
         if(param1.eventPhase != EventPhase.AT_TARGET)
         {
            return;
         }
         switch(param1.keyCode)
         {
            case Keyboard.SPACE:
               if(focusedIndex != -1)
               {
                  _loc2_ = Button(getChildAt(focusedIndex));
                  _loc2_.dispatchEvent(param1);
               }
               param1.stopPropagation();
         }
      }
      
      mx_internal function nextIndex(param1:int) : int
      {
         var _loc2_:int = numChildren;
         if(_loc2_ == 0)
         {
            return -1;
         }
         return param1 == _loc2_ - 1?0:int(param1 + 1);
      }
      
      private function calcFullWidth() : Number
      {
         var _loc6_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc1_:int = numChildren;
         var _loc2_:Number = 0;
         if(_loc1_ == 0)
         {
            return 0;
         }
         if(_loc1_ > 1)
         {
            _loc2_ = getStyle("horizontalGap");
         }
         var _loc3_:* = direction == BoxDirection.HORIZONTAL;
         var _loc4_:Number = getStyle(buttonWidthProp);
         var _loc5_:IUIComponent = IUIComponent(getChildAt(0));
         if(_loc4_)
         {
            _loc6_ = !!isNaN(_loc5_.explicitWidth)?Number(_loc4_):Number(_loc5_.explicitWidth);
         }
         else
         {
            _loc6_ = _loc5_.getExplicitOrMeasuredWidth();
         }
         var _loc7_:int = 1;
         while(_loc7_ < _loc1_)
         {
            _loc5_ = IUIComponent(getChildAt(_loc7_));
            if(_loc4_)
            {
               _loc8_ = !!isNaN(_loc5_.explicitWidth)?Number(_loc4_):Number(_loc5_.explicitWidth);
            }
            else
            {
               _loc8_ = _loc5_.getExplicitOrMeasuredWidth();
            }
            if(_loc3_)
            {
               _loc6_ = _loc6_ + (_loc2_ + _loc8_);
            }
            else
            {
               _loc6_ = Math.max(_loc6_,_loc8_);
            }
            _loc7_++;
         }
         return _loc6_;
      }
      
      override protected function clickHandler(param1:MouseEvent) : void
      {
         if(simulatedClickTriggerEvent == null)
         {
            focusedIndex = getChildIndex(DisplayObject(param1.currentTarget));
            drawButtonFocus(focusedIndex,true);
         }
         super.clickHandler(param1);
      }
      
      override protected function createNavItem(param1:String, param2:Class = null) : IFlexDisplayObject
      {
         var _loc3_:Button = Button(navItemFactory.newInstance());
         _loc3_.focusEnabled = false;
         _loc3_.label = param1;
         _loc3_.setStyle("icon",param2);
         _loc3_.addEventListener(MouseEvent.CLICK,clickHandler);
         addChild(_loc3_);
         recalcButtonWidths = recalcButtonHeights = true;
         return _loc3_;
      }
      
      override public function styleChanged(param1:String) : void
      {
         var _loc2_:Boolean = param1 == null || param1 == "styleName";
         super.styleChanged(param1);
         if(_loc2_ || param1 == buttonStyleNameProp || param1 == firstButtonStyleNameProp || param1 == lastButtonStyleNameProp)
         {
            resetNavItems();
         }
         else if(param1 == buttonWidthProp)
         {
            recalcButtonWidths = true;
         }
         else if(param1 == buttonHeightProp)
         {
            recalcButtonHeights = true;
         }
         else if(StyleManager.isInheritingStyle(param1) && StyleManager.isSizeInvalidatingStyle(param1))
         {
            recalcButtonWidths = recalcButtonHeights = true;
         }
      }
      
      protected function resetButtonWidths() : void
      {
         var _loc2_:Button = null;
         var _loc1_:int = 0;
         while(_loc1_ < numChildren)
         {
            _loc2_ = getChildAt(_loc1_) as Button;
            if(_loc2_)
            {
               _loc2_.explicitWidth = NaN;
               _loc2_.minWidth = NaN;
               _loc2_.maxWidth = NaN;
            }
            _loc1_++;
         }
      }
      
      override protected function commitProperties() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         super.commitProperties();
         if(directionChanged)
         {
            directionChanged = false;
            _loc1_ = numChildren;
            _loc2_ = 0;
            while(_loc2_ < _loc1_)
            {
               Button(getChildAt(_loc2_)).changeSkins();
               _loc2_++;
            }
         }
         if(recalcButtonHeights)
         {
            resetButtonHeights();
         }
         if(recalcButtonWidths)
         {
            resetButtonWidths();
         }
      }
      
      private function calcFullHeight() : Number
      {
         var _loc2_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc1_:int = numChildren;
         if(_loc1_ == 0)
         {
            return 0;
         }
         if(_loc1_ > 1)
         {
            _loc2_ = getStyle("verticalGap");
         }
         var _loc3_:* = direction == BoxDirection.VERTICAL;
         var _loc4_:Number = getStyle(buttonHeightProp);
         var _loc5_:IUIComponent = IUIComponent(getChildAt(0));
         if(_loc4_)
         {
            _loc6_ = !!isNaN(_loc5_.explicitHeight)?Number(_loc4_):Number(_loc5_.explicitHeight);
         }
         else
         {
            _loc6_ = _loc5_.getExplicitOrMeasuredHeight();
         }
         var _loc7_:int = 1;
         while(_loc7_ < _loc1_)
         {
            _loc5_ = IUIComponent(getChildAt(_loc7_));
            if(_loc4_)
            {
               _loc8_ = !!isNaN(_loc5_.explicitHeight)?Number(_loc4_):Number(_loc5_.explicitHeight);
            }
            else
            {
               _loc8_ = _loc5_.getExplicitOrMeasuredHeight();
            }
            if(_loc3_)
            {
               _loc6_ = _loc6_ + (_loc2_ + _loc8_);
            }
            else
            {
               _loc6_ = Math.max(_loc6_,_loc8_);
            }
            _loc7_++;
         }
         return _loc6_;
      }
      
      override protected function resetNavItems() : void
      {
         var _loc4_:Button = null;
         var _loc1_:String = getStyle(buttonStyleNameProp);
         var _loc2_:String = getStyle(firstButtonStyleNameProp);
         var _loc3_:String = getStyle(lastButtonStyleNameProp);
         if(!_loc1_)
         {
            _loc1_ = "ButtonBarButton";
         }
         if(!_loc2_)
         {
            _loc2_ = _loc1_;
         }
         if(!_loc3_)
         {
            _loc3_ = _loc1_;
         }
         var _loc5_:int = numChildren;
         var _loc6_:int = 0;
         while(_loc6_ < _loc5_)
         {
            _loc4_ = Button(getChildAt(_loc6_));
            if(_loc6_ == 0)
            {
               _loc4_.styleName = _loc2_;
            }
            else if(_loc6_ == _loc5_ - 1)
            {
               _loc4_.styleName = _loc3_;
            }
            else
            {
               _loc4_.styleName = _loc1_;
            }
            _loc4_.changeSkins();
            _loc4_.invalidateDisplayList();
            _loc6_++;
         }
         recalcButtonWidths = recalcButtonHeights = true;
         invalidateDisplayList();
      }
      
      override public function get viewMetrics() : EdgeMetrics
      {
         return EdgeMetrics.EMPTY;
      }
      
      mx_internal function prevIndex(param1:int) : int
      {
         var _loc2_:int = numChildren;
         return param1 == 0?int(_loc2_ - 1):int(param1 - 1);
      }
      
      private function scaleChangedHandler(param1:Event) : void
      {
         resetButtonHeights();
         resetButtonWidths();
      }
      
      mx_internal function drawButtonFocus(param1:int, param2:Boolean) : void
      {
         var _loc3_:Button = null;
         if(numChildren > 0 && param1 < numChildren)
         {
            _loc3_ = Button(getChildAt(param1));
            _loc3_.drawFocus(param2 && focusManager.showFocusIndicator);
            if(param2)
            {
               dispatchEvent(new Event("focusDraw"));
            }
            if(!param2 && _loc3_.phase != ButtonPhase.UP)
            {
               _loc3_.phase = ButtonPhase.UP;
            }
         }
      }
      
      override protected function keyDownHandler(param1:KeyboardEvent) : void
      {
         var _loc2_:Button = null;
         if(param1.eventPhase != EventPhase.AT_TARGET)
         {
            return;
         }
         switch(param1.keyCode)
         {
            case Keyboard.DOWN:
            case Keyboard.RIGHT:
               focusManager.showFocusIndicator = true;
               drawButtonFocus(focusedIndex,false);
               focusedIndex = nextIndex(focusedIndex);
               if(focusedIndex != -1)
               {
                  drawButtonFocus(focusedIndex,true);
               }
               param1.stopPropagation();
               break;
            case Keyboard.UP:
            case Keyboard.LEFT:
               focusManager.showFocusIndicator = true;
               drawButtonFocus(focusedIndex,false);
               focusedIndex = prevIndex(focusedIndex);
               if(focusedIndex != -1)
               {
                  drawButtonFocus(focusedIndex,true);
               }
               param1.stopPropagation();
               break;
            case Keyboard.SPACE:
               if(focusedIndex != -1)
               {
                  _loc2_ = Button(getChildAt(focusedIndex));
                  _loc2_.dispatchEvent(param1);
               }
               param1.stopPropagation();
         }
      }
      
      override protected function measure() : void
      {
         var _loc1_:EdgeMetrics = null;
         super.measure();
         _loc1_ = viewMetricsAndPadding;
         measuredWidth = calcFullWidth() + _loc1_.left + _loc1_.right;
         measuredHeight = calcFullHeight() + _loc1_.top + _loc1_.bottom;
         if(getStyle(buttonWidthProp))
         {
            measuredMinWidth = measuredWidth;
         }
         if(getStyle(buttonHeightProp))
         {
            measuredMinHeight = measuredHeight;
         }
      }
      
      private function childRemoveHandler(param1:ChildExistenceChangedEvent) : void
      {
         var _loc8_:Button = null;
         var _loc2_:DisplayObject = param1.relatedObject;
         var _loc3_:int = getChildIndex(_loc2_);
         var _loc4_:int = numChildren;
         if(_loc4_ < 2)
         {
            return;
         }
         var _loc5_:String = getStyle(buttonStyleNameProp);
         var _loc6_:String = getStyle(firstButtonStyleNameProp);
         var _loc7_:String = getStyle(lastButtonStyleNameProp);
         if(!_loc5_)
         {
            _loc5_ = "buttonBarButtonStyle";
         }
         if(!_loc6_)
         {
            _loc6_ = _loc5_;
         }
         if(!_loc7_)
         {
            _loc7_ = _loc5_;
         }
         if(_loc3_ == 0 || _loc3_ == _loc4_ - 1)
         {
            _loc8_ = Button(getChildAt(_loc3_ == _loc4_ - 1?int(_loc4_ - 2):0));
            _loc8_.styleName = _loc3_ == 0?_loc6_:_loc7_;
            _loc8_.changeSkins();
            _loc8_.invalidateDisplayList();
         }
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         var _loc3_:* = false;
         var _loc16_:int = 0;
         var _loc17_:Button = null;
         var _loc18_:Number = NaN;
         var _loc19_:int = 0;
         var _loc20_:int = 0;
         var _loc21_:Number = NaN;
         var _loc22_:int = 0;
         var _loc23_:int = 0;
         var _loc24_:int = 0;
         var _loc25_:Number = NaN;
         _loc3_ = direction == BoxDirection.HORIZONTAL;
         var _loc4_:* = !_loc3_;
         var _loc5_:Number = getStyle(buttonWidthProp);
         var _loc6_:Number = getStyle(buttonHeightProp);
         var _loc7_:Number = _loc6_;
         var _loc8_:EdgeMetrics = viewMetricsAndPadding;
         var _loc9_:int = numChildren;
         var _loc10_:Number = getStyle("horizontalGap");
         var _loc11_:Number = getStyle("verticalGap");
         var _loc12_:Number = _loc3_ && numChildren > 0?Number(_loc10_ * (_loc9_ - 1)):Number(0);
         var _loc13_:Number = _loc4_ && numChildren > 0?Number(_loc11_ * (_loc9_ - 1)):Number(0);
         var _loc14_:Number = param1 - _loc8_.left - _loc8_.right - _loc12_;
         var _loc15_:Number = param2 - _loc8_.top - _loc8_.bottom - _loc13_;
         if(!_loc14_ || !_loc15_)
         {
            return;
         }
         if(border)
         {
            border.visible = false;
         }
         if(param1 != oldUnscaledWidth)
         {
            recalcButtonWidths = true;
            oldUnscaledWidth = param1;
         }
         if(param2 != oldUnscaledHeight)
         {
            recalcButtonHeights = true;
            oldUnscaledHeight = param2;
         }
         if(recalcButtonWidths)
         {
            recalcButtonWidths = false;
            if(isNaN(_loc5_) && _loc4_)
            {
               _loc5_ = _loc14_;
            }
            _loc18_ = _loc14_ - (calcFullWidth() - _loc12_);
            _loc19_ = _loc9_ > 0?int(_loc14_ / _loc9_):0;
            _loc20_ = 0;
            _loc21_ = 0;
            _loc22_ = 0;
            if(_loc18_ != 0 && _loc3_)
            {
               _loc16_ = 0;
               while(_loc16_ < _loc9_)
               {
                  _loc17_ = Button(getChildAt(_loc16_));
                  if(isNaN(_loc17_.explicitWidth))
                  {
                     _loc23_ = _loc17_.measuredWidth;
                     _loc21_ = _loc21_ + _loc23_;
                     if(_loc23_ > _loc19_)
                     {
                        _loc20_++;
                     }
                     else
                     {
                        _loc22_ = _loc22_ + _loc23_;
                     }
                  }
                  _loc16_++;
               }
            }
            else
            {
               _loc21_ = _loc14_;
            }
            _loc16_ = 0;
            while(_loc16_ < _loc9_)
            {
               _loc17_ = Button(getChildAt(_loc16_));
               if(isNaN(_loc17_.explicitWidth))
               {
                  _loc17_.minWidth = 0;
                  if(!isNaN(_loc5_))
                  {
                     _loc17_.minWidth = _loc17_.maxWidth = _loc5_;
                     _loc17_.percentWidth = _loc5_ / Math.min(_loc14_,_loc21_) * 100;
                  }
                  else if(_loc18_ < 0)
                  {
                     _loc24_ = _loc17_.measuredWidth;
                     if(_loc24_ > _loc19_)
                     {
                        _loc24_ = (_loc14_ - _loc22_) / _loc20_;
                     }
                     _loc17_.percentWidth = Number(_loc24_) / _loc14_ * 100;
                  }
                  else if(_loc18_ > 0)
                  {
                     _loc17_.percentWidth = _loc17_.measuredWidth / _loc21_ * 100;
                  }
                  else
                  {
                     _loc17_.percentWidth = NaN;
                  }
                  if(_loc4_)
                  {
                     _loc17_.percentWidth = 100;
                  }
               }
               _loc16_++;
            }
         }
         if(recalcButtonHeights)
         {
            recalcButtonHeights = false;
            if(isNaN(_loc7_) && _loc3_)
            {
               _loc7_ = _loc15_;
            }
            _loc18_ = _loc15_ - (calcFullHeight() - _loc13_);
            _loc25_ = 0;
            if(_loc18_ != 0 && _loc4_)
            {
               _loc16_ = 0;
               while(_loc16_ < _loc9_)
               {
                  _loc17_ = Button(getChildAt(_loc16_));
                  if(isNaN(_loc17_.explicitHeight))
                  {
                     _loc25_ = _loc25_ + _loc17_.measuredHeight;
                  }
                  _loc16_++;
               }
            }
            _loc16_ = 0;
            while(_loc16_ < _loc9_)
            {
               _loc17_ = Button(getChildAt(_loc16_));
               if(isNaN(_loc17_.explicitHeight))
               {
                  _loc17_.minHeight = 0;
                  if(!isNaN(_loc7_))
                  {
                     _loc17_.minHeight = _loc7_;
                     _loc17_.percentHeight = _loc7_ / Math.min(_loc25_,_loc15_) * 100;
                  }
                  if(!isNaN(_loc6_))
                  {
                     _loc17_.maxHeight = _loc6_;
                  }
                  if(_loc3_)
                  {
                     _loc17_.percentHeight = 100;
                  }
                  else if(_loc18_ < 0)
                  {
                     _loc17_.percentHeight = _loc17_.measuredHeight / _loc25_ * 100;
                  }
                  else if(_loc18_ > 0)
                  {
                     _loc17_.percentHeight = _loc17_.measuredHeight / _loc25_ * 100;
                  }
                  else
                  {
                     _loc17_.percentHeight = NaN;
                  }
               }
               _loc16_++;
            }
         }
         super.updateDisplayList(param1,param2);
      }
      
      override public function drawFocus(param1:Boolean) : void
      {
         drawButtonFocus(focusedIndex,param1);
      }
      
      [Bindable("directionChanged")]
      override public function set direction(param1:String) : void
      {
         if(initialized && param1 != direction)
         {
            directionChanged = true;
            invalidateProperties();
         }
         super.direction = param1;
      }
   }
}
