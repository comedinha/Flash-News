package mx.containers
{
   import mx.styles.StyleManager;
   import mx.core.mx_internal;
   import flash.events.Event;
   import mx.core.UIComponent;
   import mx.containers.dividedBoxClasses.BoxDivider;
   import mx.core.IFlexDisplayObject;
   import mx.managers.CursorManager;
   import mx.core.IUIComponent;
   import mx.core.EdgeMetrics;
   import flash.events.MouseEvent;
   import mx.events.DividerEvent;
   import mx.events.ChildExistenceChangedEvent;
   import flash.display.DisplayObject;
   import mx.managers.CursorManagerPriority;
   import flash.geom.Point;
   import mx.core.IInvalidating;
   
   use namespace mx_internal;
   
   public class DividedBox extends Box
   {
      
      mx_internal static const VERSION:String = "3.6.0.21751";
      
      private static const PROXY_DIVIDER_INDEX:int = 999;
      
      private static var classInitialized:Boolean = false;
       
      
      private var postLayoutChanges:Array;
      
      private var minDelta:Number;
      
      private var layoutStyleChanged:Boolean = false;
      
      private var dbPreferredHeight:Number;
      
      private var dbMinWidth:Number;
      
      private var maxDelta:Number;
      
      private var activeDividerStartPosition:Number;
      
      mx_internal var activeDivider:BoxDivider;
      
      private var dbMinHeight:Number;
      
      private var dividerLayer:UIComponent = null;
      
      private var dragStartPosition:Number;
      
      public var liveDragging:Boolean = false;
      
      private var oldChildSizes:Array;
      
      protected var dividerClass:Class;
      
      private var dbPreferredWidth:Number;
      
      private var dragDelta:Number;
      
      private var activeDividerIndex:int = -1;
      
      private var _resizeToContent:Boolean = false;
      
      private var numLayoutChildren:int = 0;
      
      private var cursorID:int = 0;
      
      private var dontCoalesceDividers:Boolean;
      
      public function DividedBox()
      {
         dividerClass = BoxDivider;
         super();
         if(!classInitialized)
         {
            initializeClass();
            classInitialized = true;
         }
         addEventListener(ChildExistenceChangedEvent.CHILD_ADD,childAddHandler);
         addEventListener(ChildExistenceChangedEvent.CHILD_REMOVE,childRemoveHandler);
         showInAutomationHierarchy = true;
      }
      
      private static function initializeClass() : void
      {
         StyleManager.registerSizeInvalidatingStyle("dividerAffordance");
         StyleManager.registerSizeInvalidatingStyle("dividerThickness");
      }
      
      public function set resizeToContent(param1:Boolean) : void
      {
         if(param1 != _resizeToContent)
         {
            _resizeToContent = param1;
            if(param1)
            {
               invalidateSize();
            }
         }
      }
      
      private function child_includeInLayoutChangedHandler(param1:Event) : void
      {
         var _loc2_:UIComponent = UIComponent(param1.target);
         if(_loc2_.includeInLayout && ++numLayoutChildren > 1)
         {
            createDivider(numLayoutChildren - 2);
         }
         else if(!_loc2_.includeInLayout && --numLayoutChildren > 0)
         {
            dividerLayer.removeChild(getDividerAt(numLayoutChildren - 1));
         }
         dbMinWidth = NaN;
         dbMinHeight = NaN;
         dbPreferredWidth = NaN;
         dbPreferredHeight = NaN;
         invalidateSize();
      }
      
      private function createDivider(param1:int) : BoxDivider
      {
         if(!dividerLayer)
         {
            dividerLayer = UIComponent(rawChildren.addChild(new UIComponent()));
         }
         var _loc2_:BoxDivider = BoxDivider(new dividerClass());
         dividerLayer.addChild(_loc2_);
         if(param1 == PROXY_DIVIDER_INDEX)
         {
            rawChildren.setChildIndex(dividerLayer,rawChildren.numChildren - 1);
         }
         var _loc3_:IFlexDisplayObject = param1 == PROXY_DIVIDER_INDEX?getDividerAt(activeDividerIndex):this;
         _loc2_.styleName = _loc3_;
         _loc2_.owner = this;
         return _loc2_;
      }
      
      public function moveDivider(param1:int, param2:Number) : void
      {
         if(param1 < 0 || param1 >= numDividers)
         {
            return;
         }
         if(activeDividerIndex >= 0)
         {
            return;
         }
         activeDividerIndex = param1;
         cacheChildSizes();
         computeMinAndMaxDelta();
         dragDelta = limitDelta(param2);
         adjustChildSizes();
         invalidateSize();
         invalidateDisplayList();
         resetDividerTracking();
      }
      
      mx_internal function restoreCursor() : void
      {
         if(cursorID != CursorManager.NO_CURSOR)
         {
            cursorManager.removeCursor(cursorID);
            cursorID = CursorManager.NO_CURSOR;
         }
      }
      
      private function layoutDivider(param1:int, param2:Number, param3:Number, param4:IUIComponent, param5:IUIComponent) : void
      {
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc6_:BoxDivider = BoxDivider(getDividerAt(param1));
         var _loc7_:EdgeMetrics = viewMetrics;
         var _loc8_:Number = getStyle("verticalGap");
         var _loc9_:Number = getStyle("horizontalGap");
         var _loc10_:Number = _loc6_.getStyle("dividerThickness");
         var _loc11_:Number = _loc6_.getStyle("dividerAffordance");
         if(isVertical())
         {
            _loc12_ = _loc11_;
            if(_loc12_ < _loc10_)
            {
               _loc12_ = _loc10_;
            }
            if(_loc12_ > _loc8_)
            {
               _loc12_ = _loc8_;
            }
            _loc6_.setActualSize(param2 - _loc7_.left - _loc7_.right,_loc12_);
            _loc6_.move(_loc7_.left,Math.round((param4.y + param4.height + param5.y - _loc12_) / 2));
         }
         else
         {
            _loc13_ = _loc11_;
            if(_loc13_ < _loc10_)
            {
               _loc13_ = _loc10_;
            }
            if(_loc13_ > _loc9_)
            {
               _loc13_ = _loc9_;
            }
            _loc6_.setActualSize(_loc13_,param3 - _loc7_.top - _loc7_.bottom);
            _loc6_.move(Math.round((param4.x + param4.width + param5.x - _loc13_) / 2),_loc7_.top);
         }
         _loc6_.invalidateDisplayList();
      }
      
      private function computeMinAndMaxDelta() : void
      {
         computeAllowableMovement(activeDividerIndex);
      }
      
      mx_internal function stopDividerDrag(param1:BoxDivider, param2:MouseEvent) : void
      {
         if(param2)
         {
            dragDelta = limitDelta(getMousePosition(param2) - dragStartPosition);
         }
         var _loc3_:DividerEvent = new DividerEvent(DividerEvent.DIVIDER_RELEASE);
         _loc3_.dividerIndex = activeDividerIndex;
         _loc3_.delta = dragDelta;
         dispatchEvent(_loc3_);
         if(!liveDragging)
         {
            if(dragDelta == 0)
            {
               getDividerAt(activeDividerIndex).state = DividerState.OVER;
            }
            if(activeDivider)
            {
               dividerLayer.removeChild(activeDivider);
            }
            activeDivider = null;
            adjustChildSizes();
            invalidateSize();
            invalidateDisplayList();
         }
         resetDividerTracking();
         systemManager.getSandboxRoot().removeEventListener(MouseEvent.MOUSE_MOVE,mouseMoveHandler,true);
         systemManager.deployMouseShields(false);
      }
      
      private function postLayoutAdjustment() : void
      {
         var _loc3_:Object = null;
         var _loc1_:int = postLayoutChanges.length;
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = postLayoutChanges[_loc2_];
            if(_loc3_.percentWidth !== undefined)
            {
               _loc3_.child.percentWidth = _loc3_.percentWidth;
            }
            if(_loc3_.percentHeight !== undefined)
            {
               _loc3_.child.percentHeight = _loc3_.percentHeight;
            }
            if(_loc3_.explicitWidth !== undefined)
            {
               _loc3_.child.explicitWidth = _loc3_.explicitWidth;
            }
            if(_loc3_.explicitHeight !== undefined)
            {
               _loc3_.child.explicitHeight = _loc3_.explicitHeight;
            }
            _loc2_++;
         }
         postLayoutChanges = null;
      }
      
      public function get numDividers() : int
      {
         if(dividerLayer)
         {
            if(!liveDragging && activeDivider)
            {
               return dividerLayer.numChildren - 1;
            }
            return dividerLayer.numChildren;
         }
         return 0;
      }
      
      private function resetDividerTracking() : void
      {
         activeDivider = null;
         activeDividerIndex = -1;
         activeDividerStartPosition = NaN;
         dragStartPosition = NaN;
         dragDelta = NaN;
         oldChildSizes = null;
         minDelta = NaN;
         maxDelta = NaN;
      }
      
      private function childAddHandler(param1:ChildExistenceChangedEvent) : void
      {
         var _loc2_:DisplayObject = param1.relatedObject;
         _loc2_.addEventListener("includeInLayoutChanged",child_includeInLayoutChangedHandler);
         if(!IUIComponent(_loc2_).includeInLayout)
         {
            return;
         }
         numLayoutChildren++;
         if(numLayoutChildren > 1)
         {
            createDivider(numLayoutChildren - 2);
         }
         dbMinWidth = NaN;
         dbMinHeight = NaN;
         dbPreferredWidth = NaN;
         dbPreferredHeight = NaN;
      }
      
      mx_internal function changeCursor(param1:BoxDivider) : void
      {
         var _loc2_:Class = null;
         if(cursorID == CursorManager.NO_CURSOR)
         {
            _loc2_ = !!isVertical()?getStyle("verticalDividerCursor") as Class:getStyle("horizontalDividerCursor") as Class;
            cursorID = cursorManager.setCursor(_loc2_,CursorManagerPriority.HIGH,0,0);
         }
      }
      
      private function mouseMoveHandler(param1:MouseEvent) : void
      {
         dragDelta = limitDelta(getMousePosition(param1) - dragStartPosition);
         var _loc2_:DividerEvent = new DividerEvent(DividerEvent.DIVIDER_DRAG);
         _loc2_.dividerIndex = activeDividerIndex;
         _loc2_.delta = dragDelta;
         dispatchEvent(_loc2_);
         if(liveDragging)
         {
            adjustChildSizes();
            invalidateDisplayList();
            updateDisplayList(unscaledWidth,unscaledHeight);
         }
         else if(isVertical())
         {
            activeDivider.move(0,activeDividerStartPosition + dragDelta);
         }
         else
         {
            activeDivider.move(activeDividerStartPosition + dragDelta,0);
         }
      }
      
      public function get resizeToContent() : Boolean
      {
         return _resizeToContent;
      }
      
      mx_internal function startDividerDrag(param1:BoxDivider, param2:MouseEvent) : void
      {
         if(activeDividerIndex >= 0)
         {
            return;
         }
         activeDividerIndex = getDividerIndex(param1);
         var _loc3_:DividerEvent = new DividerEvent(DividerEvent.DIVIDER_PRESS);
         _loc3_.dividerIndex = activeDividerIndex;
         dispatchEvent(_loc3_);
         if(liveDragging)
         {
            activeDivider = param1;
         }
         else
         {
            activeDivider = createDivider(PROXY_DIVIDER_INDEX);
            activeDivider.visible = false;
            activeDivider.state = DividerState.DOWN;
            activeDivider.setActualSize(param1.width,param1.height);
            activeDivider.move(param1.x,param1.y);
            activeDivider.visible = true;
            param1.state = DividerState.UP;
         }
         if(isVertical())
         {
            activeDividerStartPosition = activeDivider.y;
         }
         else
         {
            activeDividerStartPosition = activeDivider.x;
         }
         dragStartPosition = getMousePosition(param2);
         dragDelta = 0;
         cacheChildSizes();
         adjustChildSizes();
         computeMinAndMaxDelta();
         systemManager.getSandboxRoot().addEventListener(MouseEvent.MOUSE_MOVE,mouseMoveHandler,true);
         systemManager.deployMouseShields(true);
      }
      
      mx_internal function getDividerIndex(param1:BoxDivider) : int
      {
         var _loc2_:int = numChildren;
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_ - 1)
         {
            if(getDividerAt(_loc3_) == param1)
            {
               return _loc3_;
            }
            _loc3_++;
         }
         return -1;
      }
      
      private function cacheSizes() : void
      {
         var _loc5_:IUIComponent = null;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         oldChildSizes = [];
         var _loc1_:Boolean = isVertical();
         var _loc2_:Number = Number.MAX_VALUE;
         var _loc3_:int = numChildren;
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = IUIComponent(getChildAt(_loc4_));
            if(_loc5_.includeInLayout)
            {
               _loc6_ = !!_loc1_?Number(_loc5_.height):Number(_loc5_.width);
               _loc7_ = !!_loc1_?Number(_loc5_.maxHeight):Number(_loc5_.maxWidth);
               _loc8_ = !!_loc1_?Number(_loc5_.explicitMinHeight):Number(_loc5_.explicitMinWidth);
               _loc9_ = !!isNaN(_loc8_)?Number(0):Number(_loc8_);
               _loc10_ = Math.max(0,_loc6_ - _loc9_);
               _loc11_ = Math.max(0,_loc7_ - _loc6_);
               if(_loc6_ > 0 && _loc6_ < _loc2_)
               {
                  _loc2_ = _loc6_;
               }
               oldChildSizes.push(new ChildSizeInfo(_loc6_,_loc9_,_loc7_,_loc10_,_loc11_));
            }
            _loc4_++;
         }
         oldChildSizes.push(new ChildSizeInfo(_loc2_ == Number.MAX_VALUE?Number(1):Number(_loc2_)));
      }
      
      private function limitDelta(param1:Number) : Number
      {
         if(param1 < minDelta)
         {
            param1 = minDelta;
         }
         else if(param1 > maxDelta)
         {
            param1 = maxDelta;
         }
         param1 = Math.round(param1);
         return param1;
      }
      
      override public function styleChanged(param1:String) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         super.styleChanged(param1);
         if(dividerLayer)
         {
            _loc2_ = dividerLayer.numChildren;
            _loc3_ = 0;
            while(_loc3_ < _loc2_)
            {
               getDividerAt(_loc3_).styleChanged(param1);
               _loc3_++;
            }
         }
         if(StyleManager.isSizeInvalidatingStyle(param1))
         {
            layoutStyleChanged = true;
         }
      }
      
      private function getMousePosition(param1:MouseEvent) : Number
      {
         var _loc2_:Point = new Point(param1.stageX,param1.stageY);
         _loc2_ = globalToLocal(_loc2_);
         return !!isVertical()?Number(_loc2_.y):Number(_loc2_.x);
      }
      
      private function adjustChildSizes() : void
      {
         distributeDelta();
      }
      
      override protected function measure() : void
      {
         var _loc10_:IUIComponent = null;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc15_:* = false;
         var _loc16_:* = false;
         var _loc17_:Number = NaN;
         var _loc18_:Number = NaN;
         super.measure();
         if(!isNaN(dbPreferredWidth) && !_resizeToContent && !layoutStyleChanged)
         {
            measuredMinWidth = dbMinWidth;
            measuredMinHeight = dbMinHeight;
            measuredWidth = dbPreferredWidth;
            measuredHeight = dbPreferredHeight;
            return;
         }
         layoutStyleChanged = false;
         var _loc1_:Boolean = this.isVertical();
         var _loc2_:Number = 0;
         var _loc3_:Number = 0;
         var _loc4_:Number = 0;
         var _loc5_:Number = 0;
         var _loc6_:int = numChildren;
         var _loc7_:int = 0;
         while(_loc7_ < _loc6_)
         {
            _loc10_ = IUIComponent(getChildAt(_loc7_));
            if(_loc10_.includeInLayout)
            {
               _loc11_ = _loc10_.getExplicitOrMeasuredWidth();
               _loc12_ = _loc10_.getExplicitOrMeasuredHeight();
               _loc13_ = _loc10_.minWidth;
               _loc14_ = _loc10_.minHeight;
               _loc15_ = !isNaN(_loc10_.percentWidth);
               _loc16_ = !isNaN(_loc10_.percentHeight);
               _loc17_ = Math.min(_loc11_,_loc13_);
               _loc18_ = Math.min(_loc12_,_loc14_);
               if(_loc1_)
               {
                  _loc2_ = Math.max(!!_loc15_?Number(_loc13_):Number(_loc11_),_loc2_);
                  _loc4_ = Math.max(_loc11_,_loc4_);
                  _loc3_ = _loc3_ + (!!_loc16_?_loc18_:_loc12_);
                  _loc5_ = _loc5_ + _loc12_;
               }
               else
               {
                  _loc2_ = _loc2_ + (!!_loc15_?_loc17_:_loc11_);
                  _loc4_ = _loc4_ + _loc11_;
                  _loc3_ = Math.max(!!_loc16_?Number(_loc14_):Number(_loc12_),_loc3_);
                  _loc5_ = Math.max(_loc12_,_loc5_);
               }
            }
            _loc7_++;
         }
         var _loc8_:Number = layoutObject.widthPadding(numLayoutChildren);
         var _loc9_:Number = layoutObject.heightPadding(numLayoutChildren);
         measuredMinWidth = dbMinWidth = _loc2_ + _loc8_;
         measuredMinHeight = dbMinHeight = _loc3_ + _loc9_;
         measuredWidth = dbPreferredWidth = _loc4_ + _loc8_;
         measuredHeight = dbPreferredHeight = _loc5_ + _loc9_;
      }
      
      private function childRemoveHandler(param1:ChildExistenceChangedEvent) : void
      {
         var _loc2_:DisplayObject = param1.relatedObject;
         _loc2_.removeEventListener("includeInLayoutChanged",child_includeInLayoutChangedHandler);
         if(!IUIComponent(_loc2_).includeInLayout)
         {
            return;
         }
         numLayoutChildren--;
         if(numLayoutChildren > 0)
         {
            dividerLayer.removeChild(getDividerAt(numLayoutChildren - 1));
         }
         dbMinWidth = NaN;
         dbMinHeight = NaN;
         dbPreferredWidth = NaN;
         dbPreferredHeight = NaN;
         invalidateSize();
      }
      
      override protected function scrollChildren() : void
      {
         super.scrollChildren();
         if(contentPane && dividerLayer)
         {
            dividerLayer.scrollRect = contentPane.scrollRect;
         }
      }
      
      public function getDividerAt(param1:int) : BoxDivider
      {
         return BoxDivider(dividerLayer.getChildAt(param1));
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc8_:IUIComponent = null;
         if(!liveDragging && activeDivider)
         {
            _loc3_ = numChildren;
            _loc4_ = 0;
            while(_loc4_ < _loc3_)
            {
               _loc8_ = IUIComponent(getChildAt(_loc4_));
               if(_loc8_.includeInLayout)
               {
                  _loc8_.measuredMinWidth = 0;
                  _loc8_.measuredMinHeight = 0;
               }
               _loc4_++;
            }
            return;
         }
         preLayoutAdjustment();
         super.updateDisplayList(param1,param2);
         postLayoutAdjustment();
         if(!dividerLayer)
         {
            return;
         }
         var _loc5_:EdgeMetrics = viewMetrics;
         dividerLayer.x = _loc5_.left;
         dividerLayer.y = _loc5_.top;
         var _loc6_:IUIComponent = null;
         var _loc7_:int = 0;
         _loc3_ = numChildren;
         _loc4_ = 0;
         while(_loc4_ < _loc3_)
         {
            _loc8_ = UIComponent(getChildAt(_loc4_));
            if(_loc8_.includeInLayout)
            {
               if(_loc6_)
               {
                  layoutDivider(_loc7_,param1,param2,_loc6_,_loc8_);
                  _loc7_++;
               }
               _loc6_ = _loc8_;
            }
            _loc4_++;
         }
      }
      
      private function cacheChildSizes() : void
      {
         oldChildSizes = [];
         cacheSizes();
      }
      
      private function distributeDelta() : void
      {
         var _loc5_:int = 0;
         var _loc6_:ChildSizeInfo = null;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:IUIComponent = null;
         var _loc10_:Number = NaN;
         if(!dragDelta)
         {
            return;
         }
         var _loc1_:Boolean = isVertical();
         var _loc2_:int = numLayoutChildren;
         var _loc3_:int = activeDividerIndex;
         var _loc4_:Number = oldChildSizes[_loc2_].size - Math.abs(dragDelta);
         if(_loc4_ <= 0 || isNaN(_loc4_))
         {
            _loc4_ = 1;
         }
         var _loc11_:int = -1;
         var _loc12_:int = -1;
         while(_loc12_ < activeDividerIndex)
         {
            if(UIComponent(getChildAt(++_loc11_)).includeInLayout)
            {
               _loc12_++;
            }
         }
         var _loc13_:int = _loc11_;
         var _loc14_:Number = dragDelta;
         _loc5_ = _loc3_;
         while(_loc5_ >= 0)
         {
            _loc6_ = ChildSizeInfo(oldChildSizes[_loc5_]);
            _loc7_ = _loc14_ < 0?Number(-Math.min(-_loc14_,_loc6_.deltaMin)):Number(Math.min(_loc14_,_loc6_.deltaMax));
            _loc8_ = _loc6_.size + _loc7_;
            _loc14_ = _loc14_ - _loc7_;
            do
            {
               _loc9_ = IUIComponent(getChildAt(_loc13_--));
            }
            while(!_loc9_.includeInLayout);
            
            _loc10_ = _loc8_ / _loc4_ * 100;
            if(_loc1_)
            {
               _loc9_.percentHeight = _loc10_;
            }
            else
            {
               _loc9_.percentWidth = _loc10_;
            }
            if(_loc9_ is IInvalidating)
            {
               IInvalidating(_loc9_).invalidateSize();
            }
            _loc5_--;
         }
         _loc13_ = _loc11_ + 1;
         _loc14_ = dragDelta;
         _loc5_ = _loc3_ + 1;
         while(_loc5_ < _loc2_)
         {
            _loc6_ = ChildSizeInfo(oldChildSizes[_loc5_]);
            _loc7_ = _loc14_ < 0?Number(Math.min(-_loc14_,_loc6_.deltaMax)):Number(-Math.min(_loc14_,_loc6_.deltaMin));
            _loc8_ = _loc6_.size + _loc7_;
            _loc14_ = _loc14_ + _loc7_;
            do
            {
               _loc9_ = IUIComponent(getChildAt(_loc13_++));
            }
            while(!_loc9_.includeInLayout);
            
            _loc10_ = _loc8_ / _loc4_ * 100;
            if(_loc1_)
            {
               _loc9_.percentHeight = _loc10_;
            }
            else
            {
               _loc9_.percentWidth = _loc10_;
            }
            if(_loc9_ is IInvalidating)
            {
               IInvalidating(_loc9_).invalidateSize();
            }
            _loc5_++;
         }
      }
      
      private function preLayoutAdjustment() : void
      {
         var _loc5_:int = 0;
         var _loc6_:IUIComponent = null;
         var _loc7_:Number = NaN;
         var _loc8_:Object = null;
         var _loc9_:Number = NaN;
         var _loc1_:Boolean = isVertical();
         var _loc2_:Number = 0;
         var _loc3_:Number = 0;
         var _loc4_:int = numChildren;
         _loc5_ = 0;
         while(_loc5_ < _loc4_)
         {
            _loc6_ = IUIComponent(getChildAt(_loc5_));
            if(_loc6_.includeInLayout)
            {
               _loc6_.measuredMinWidth = 0;
               _loc6_.measuredMinHeight = 0;
               _loc7_ = !!_loc1_?Number(_loc6_.percentHeight):Number(_loc6_.percentWidth);
               if(!isNaN(_loc7_))
               {
                  _loc2_ = _loc2_ + _loc7_;
                  _loc3_++;
               }
            }
            _loc5_++;
         }
         postLayoutChanges = [];
         if(_loc2_ == 0 && _loc3_ == 0)
         {
            _loc5_ = _loc4_ - 1;
            while(_loc5_ >= 0)
            {
               _loc6_ = UIComponent(getChildAt(_loc5_));
               if(_loc6_.includeInLayout)
               {
                  _loc8_ = {"child":_loc6_};
                  if(_loc1_)
                  {
                     if(_loc6_.explicitHeight)
                     {
                        _loc8_.explicitHeight = _loc6_.explicitHeight;
                     }
                     else
                     {
                        _loc8_.percentHeight = NaN;
                     }
                     _loc6_.percentHeight = 100;
                  }
                  else
                  {
                     if(_loc6_.explicitWidth)
                     {
                        _loc8_.explicitWidth = _loc6_.explicitWidth;
                     }
                     else if(_loc6_.percentWidth)
                     {
                        _loc8_.percentWidth = NaN;
                     }
                     _loc6_.percentWidth = 100;
                  }
                  postLayoutChanges.push(_loc8_);
                  break;
               }
               _loc5_--;
            }
         }
         else if(_loc2_ < 100)
         {
            _loc9_ = Math.ceil((100 - _loc2_) / _loc3_);
            _loc5_ = 0;
            while(_loc5_ < _loc4_)
            {
               _loc6_ = IUIComponent(getChildAt(_loc5_));
               if(_loc6_.includeInLayout)
               {
                  _loc8_ = {"child":_loc6_};
                  if(_loc1_)
                  {
                     _loc7_ = _loc6_.percentHeight;
                     if(!isNaN(_loc7_))
                     {
                        _loc8_.percentHeight = _loc6_.percentHeight;
                        postLayoutChanges.push(_loc8_);
                        _loc6_.percentHeight = (_loc7_ + _loc9_) * unscaledHeight;
                     }
                  }
                  else
                  {
                     _loc7_ = _loc6_.percentWidth;
                     if(!isNaN(_loc7_))
                     {
                        _loc8_.percentWidth = _loc6_.percentWidth;
                        postLayoutChanges.push(_loc8_);
                        _loc6_.percentWidth = (_loc7_ + _loc9_) * unscaledWidth;
                     }
                  }
               }
               _loc5_++;
            }
         }
      }
      
      private function computeAllowableMovement(param1:int) : void
      {
         var _loc7_:int = 0;
         var _loc8_:ChildSizeInfo = null;
         var _loc2_:Number = 0;
         var _loc3_:Number = 0;
         var _loc4_:Number = 0;
         var _loc5_:Number = 0;
         var _loc6_:int = numLayoutChildren;
         if(param1 < 0)
         {
            return;
         }
         _loc7_ = param1;
         while(_loc7_ >= 0)
         {
            _loc8_ = ChildSizeInfo(oldChildSizes[_loc7_]);
            _loc2_ = _loc2_ + (dontCoalesceDividers && _loc2_?0:_loc8_.deltaMin);
            _loc3_ = _loc3_ + (dontCoalesceDividers && _loc3_?0:_loc8_.deltaMax);
            _loc7_--;
         }
         _loc7_ = param1 + 1;
         while(_loc7_ < _loc6_)
         {
            _loc8_ = ChildSizeInfo(oldChildSizes[_loc7_]);
            _loc4_ = _loc4_ + (dontCoalesceDividers && _loc4_?0:_loc8_.deltaMin);
            _loc5_ = _loc5_ + (dontCoalesceDividers && _loc5_?0:_loc8_.deltaMax);
            _loc7_++;
         }
         var _loc9_:Number = Math.min(_loc2_,_loc5_);
         var _loc10_:Number = Math.min(_loc4_,_loc3_);
         minDelta = -_loc9_;
         maxDelta = _loc10_;
      }
      
      override public function set direction(param1:String) : void
      {
         var _loc2_:int = 0;
         if(super.direction != param1)
         {
            super.direction = param1;
            if(dividerLayer)
            {
               _loc2_ = 0;
               while(_loc2_ < dividerLayer.numChildren)
               {
                  getDividerAt(_loc2_).invalidateDisplayList();
                  _loc2_++;
               }
            }
         }
      }
   }
}

class ChildSizeInfo
{
    
   
   public var size:Number;
   
   public var min:Number;
   
   public var max:Number;
   
   public var deltaMin:Number;
   
   public var deltaMax:Number;
   
   function ChildSizeInfo(param1:Number, param2:Number = 0, param3:Number = 0, param4:Number = 0, param5:Number = 0)
   {
      super();
      this.size = param1;
      this.min = param2;
      this.max = param3;
      this.deltaMin = param4;
      this.deltaMax = param5;
   }
}
