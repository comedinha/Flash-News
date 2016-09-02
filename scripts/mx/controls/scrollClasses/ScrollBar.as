package mx.controls.scrollClasses
{
   import mx.core.UIComponent;
   import mx.core.mx_internal;
   import mx.controls.Button;
   import mx.events.ScrollEvent;
   import mx.events.FlexEvent;
   import flash.events.MouseEvent;
   import flash.display.DisplayObject;
   import mx.events.SandboxMouseEvent;
   import flash.geom.Point;
   import flash.utils.Timer;
   import flash.events.TimerEvent;
   import mx.events.ScrollEventDetail;
   import mx.styles.ISimpleStyleClient;
   import mx.styles.StyleProxy;
   import flash.ui.Keyboard;
   import flash.events.Event;
   import mx.core.FlexVersion;
   
   use namespace mx_internal;
   
   public class ScrollBar extends UIComponent
   {
      
      mx_internal static const VERSION:String = "3.6.0.21751";
      
      public static const THICKNESS:Number = 16;
       
      
      private var _direction:String = "vertical";
      
      private var _pageScrollSize:Number = 0;
      
      mx_internal var scrollTrack:Button;
      
      mx_internal var downArrow:Button;
      
      mx_internal var scrollThumb:mx.controls.scrollClasses.ScrollThumb;
      
      private var trackScrollRepeatDirection:int;
      
      private var _minScrollPosition:Number = 0;
      
      private var trackPosition:Number;
      
      private var _pageSize:Number = 0;
      
      mx_internal var _minHeight:Number = 32;
      
      private var _maxScrollPosition:Number = 0;
      
      private var trackScrollTimer:Timer;
      
      mx_internal var upArrow:Button;
      
      private var _lineScrollSize:Number = 1;
      
      private var _scrollPosition:Number = 0;
      
      private var trackScrolling:Boolean = false;
      
      mx_internal var isScrolling:Boolean;
      
      mx_internal var oldPosition:Number;
      
      mx_internal var _minWidth:Number = 16;
      
      public function ScrollBar()
      {
         super();
      }
      
      override public function set enabled(param1:Boolean) : void
      {
         super.enabled = param1;
         invalidateDisplayList();
      }
      
      public function set lineScrollSize(param1:Number) : void
      {
         _lineScrollSize = param1;
      }
      
      public function get minScrollPosition() : Number
      {
         return _minScrollPosition;
      }
      
      mx_internal function dispatchScrollEvent(param1:Number, param2:String) : void
      {
         var _loc3_:ScrollEvent = new ScrollEvent(ScrollEvent.SCROLL);
         _loc3_.detail = param2;
         _loc3_.position = scrollPosition;
         _loc3_.delta = scrollPosition - param1;
         _loc3_.direction = direction;
         dispatchEvent(_loc3_);
      }
      
      private function downArrow_buttonDownHandler(param1:FlexEvent) : void
      {
         if(isNaN(oldPosition))
         {
            oldPosition = scrollPosition;
         }
         lineScroll(1);
      }
      
      private function scrollTrack_mouseDownHandler(param1:MouseEvent) : void
      {
         if(!(param1.target == this || param1.target == scrollTrack))
         {
            return;
         }
         trackScrolling = true;
         var _loc2_:DisplayObject = systemManager.getSandboxRoot();
         _loc2_.addEventListener(MouseEvent.MOUSE_UP,scrollTrack_mouseUpHandler,true);
         _loc2_.addEventListener(MouseEvent.MOUSE_MOVE,scrollTrack_mouseMoveHandler,true);
         _loc2_.addEventListener(SandboxMouseEvent.MOUSE_UP_SOMEWHERE,scrollTrack_mouseLeaveHandler);
         systemManager.deployMouseShields(true);
         var _loc3_:Point = new Point(param1.localX,param1.localY);
         _loc3_ = param1.target.localToGlobal(_loc3_);
         _loc3_ = globalToLocal(_loc3_);
         trackPosition = _loc3_.y;
         if(isNaN(oldPosition))
         {
            oldPosition = scrollPosition;
         }
         trackScrollRepeatDirection = scrollThumb.y + scrollThumb.height < _loc3_.y?1:scrollThumb.y > _loc3_.y?-1:0;
         pageScroll(trackScrollRepeatDirection);
         if(!trackScrollTimer)
         {
            trackScrollTimer = new Timer(getStyle("repeatDelay"),1);
            trackScrollTimer.addEventListener(TimerEvent.TIMER,trackScrollTimerHandler);
         }
         else
         {
            trackScrollTimer.delay = getStyle("repeatDelay");
            trackScrollTimer.repeatCount = 1;
         }
         trackScrollTimer.start();
      }
      
      public function set minScrollPosition(param1:Number) : void
      {
         _minScrollPosition = param1;
         invalidateDisplayList();
      }
      
      public function get scrollPosition() : Number
      {
         return _scrollPosition;
      }
      
      mx_internal function get linePlusDetail() : String
      {
         return direction == ScrollBarDirection.VERTICAL?ScrollEventDetail.LINE_DOWN:ScrollEventDetail.LINE_RIGHT;
      }
      
      public function get maxScrollPosition() : Number
      {
         return _maxScrollPosition;
      }
      
      protected function get thumbStyleFilters() : Object
      {
         return null;
      }
      
      override public function set doubleClickEnabled(param1:Boolean) : void
      {
      }
      
      public function get lineScrollSize() : Number
      {
         return _lineScrollSize;
      }
      
      mx_internal function get virtualHeight() : Number
      {
         return unscaledHeight;
      }
      
      public function set scrollPosition(param1:Number) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         _scrollPosition = param1;
         if(scrollThumb)
         {
            if(!cacheAsBitmap)
            {
               cacheHeuristic = scrollThumb.cacheHeuristic = true;
            }
            if(!isScrolling)
            {
               param1 = Math.min(param1,maxScrollPosition);
               param1 = Math.max(param1,minScrollPosition);
               _loc2_ = maxScrollPosition - minScrollPosition;
               _loc3_ = _loc2_ == 0 || isNaN(_loc2_)?Number(0):Number((param1 - minScrollPosition) * (trackHeight - scrollThumb.height) / _loc2_ + trackY);
               _loc4_ = (virtualWidth - scrollThumb.width) / 2 + getStyle("thumbOffset");
               scrollThumb.move(Math.round(_loc4_),Math.round(_loc3_));
            }
         }
      }
      
      protected function get downArrowStyleFilters() : Object
      {
         return null;
      }
      
      public function get pageSize() : Number
      {
         return _pageSize;
      }
      
      public function set pageScrollSize(param1:Number) : void
      {
         _pageScrollSize = param1;
      }
      
      public function set maxScrollPosition(param1:Number) : void
      {
         _maxScrollPosition = param1;
         invalidateDisplayList();
      }
      
      mx_internal function pageScroll(param1:int) : void
      {
         var _loc4_:Number = NaN;
         var _loc5_:String = null;
         var _loc2_:Number = _pageScrollSize != 0?Number(_pageScrollSize):Number(pageSize);
         var _loc3_:Number = _scrollPosition + param1 * _loc2_;
         if(_loc3_ > maxScrollPosition)
         {
            _loc3_ = maxScrollPosition;
         }
         else if(_loc3_ < minScrollPosition)
         {
            _loc3_ = minScrollPosition;
         }
         if(_loc3_ != scrollPosition)
         {
            _loc4_ = scrollPosition;
            scrollPosition = _loc3_;
            _loc5_ = param1 < 0?pageMinusDetail:pagePlusDetail;
            dispatchScrollEvent(_loc4_,_loc5_);
         }
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         if(!scrollTrack)
         {
            scrollTrack = new Button();
            scrollTrack.focusEnabled = false;
            scrollTrack.skinName = "trackSkin";
            scrollTrack.upSkinName = "trackUpSkin";
            scrollTrack.overSkinName = "trackOverSkin";
            scrollTrack.downSkinName = "trackDownSkin";
            scrollTrack.disabledSkinName = "trackDisabledSkin";
            if(scrollTrack is ISimpleStyleClient)
            {
               ISimpleStyleClient(scrollTrack).styleName = this;
            }
            addChild(scrollTrack);
            scrollTrack.validateProperties();
         }
         if(!upArrow)
         {
            upArrow = new Button();
            upArrow.enabled = false;
            upArrow.autoRepeat = true;
            upArrow.focusEnabled = false;
            upArrow.upSkinName = "upArrowUpSkin";
            upArrow.overSkinName = "upArrowOverSkin";
            upArrow.downSkinName = "upArrowDownSkin";
            upArrow.disabledSkinName = "upArrowDisabledSkin";
            upArrow.skinName = "upArrowSkin";
            upArrow.upIconName = "";
            upArrow.overIconName = "";
            upArrow.downIconName = "";
            upArrow.disabledIconName = "";
            addChild(upArrow);
            upArrow.styleName = new StyleProxy(this,upArrowStyleFilters);
            upArrow.validateProperties();
            upArrow.addEventListener(FlexEvent.BUTTON_DOWN,upArrow_buttonDownHandler);
         }
         if(!downArrow)
         {
            downArrow = new Button();
            downArrow.enabled = false;
            downArrow.autoRepeat = true;
            downArrow.focusEnabled = false;
            downArrow.upSkinName = "downArrowUpSkin";
            downArrow.overSkinName = "downArrowOverSkin";
            downArrow.downSkinName = "downArrowDownSkin";
            downArrow.disabledSkinName = "downArrowDisabledSkin";
            downArrow.skinName = "downArrowSkin";
            downArrow.upIconName = "";
            downArrow.overIconName = "";
            downArrow.downIconName = "";
            downArrow.disabledIconName = "";
            addChild(downArrow);
            downArrow.styleName = new StyleProxy(this,downArrowStyleFilters);
            downArrow.validateProperties();
            downArrow.addEventListener(FlexEvent.BUTTON_DOWN,downArrow_buttonDownHandler);
         }
      }
      
      private function scrollTrack_mouseOverHandler(param1:MouseEvent) : void
      {
         if(!(param1.target == this || param1.target == scrollTrack))
         {
            return;
         }
         if(trackScrolling)
         {
            trackScrollTimer.start();
         }
      }
      
      private function get minDetail() : String
      {
         return direction == ScrollBarDirection.VERTICAL?ScrollEventDetail.AT_TOP:ScrollEventDetail.AT_LEFT;
      }
      
      mx_internal function isScrollBarKey(param1:uint) : Boolean
      {
         var _loc2_:Number = NaN;
         if(param1 == Keyboard.HOME)
         {
            if(scrollPosition != 0)
            {
               _loc2_ = scrollPosition;
               scrollPosition = 0;
               dispatchScrollEvent(_loc2_,minDetail);
            }
            return true;
         }
         if(param1 == Keyboard.END)
         {
            if(scrollPosition < maxScrollPosition)
            {
               _loc2_ = scrollPosition;
               scrollPosition = maxScrollPosition;
               dispatchScrollEvent(_loc2_,maxDetail);
            }
            return true;
         }
         return false;
      }
      
      mx_internal function get lineMinusDetail() : String
      {
         return direction == ScrollBarDirection.VERTICAL?ScrollEventDetail.LINE_UP:ScrollEventDetail.LINE_LEFT;
      }
      
      mx_internal function get pageMinusDetail() : String
      {
         return direction == ScrollBarDirection.VERTICAL?ScrollEventDetail.PAGE_UP:ScrollEventDetail.PAGE_LEFT;
      }
      
      private function get maxDetail() : String
      {
         return direction == ScrollBarDirection.VERTICAL?ScrollEventDetail.AT_BOTTOM:ScrollEventDetail.AT_RIGHT;
      }
      
      private function scrollTrack_mouseLeaveHandler(param1:Event) : void
      {
         trackScrolling = false;
         var _loc2_:DisplayObject = systemManager.getSandboxRoot();
         _loc2_.removeEventListener(MouseEvent.MOUSE_UP,scrollTrack_mouseUpHandler,true);
         _loc2_.removeEventListener(MouseEvent.MOUSE_MOVE,scrollTrack_mouseMoveHandler,true);
         _loc2_.removeEventListener(SandboxMouseEvent.MOUSE_UP_SOMEWHERE,scrollTrack_mouseLeaveHandler);
         systemManager.deployMouseShields(false);
         if(trackScrollTimer)
         {
            trackScrollTimer.reset();
         }
         if(param1.target != scrollTrack)
         {
            return;
         }
         var _loc3_:String = oldPosition > scrollPosition?pageMinusDetail:pagePlusDetail;
         dispatchScrollEvent(oldPosition,_loc3_);
         oldPosition = NaN;
      }
      
      protected function get upArrowStyleFilters() : Object
      {
         return null;
      }
      
      private function get trackHeight() : Number
      {
         return virtualHeight - (upArrow.getExplicitOrMeasuredHeight() + downArrow.getExplicitOrMeasuredHeight());
      }
      
      public function get pageScrollSize() : Number
      {
         return _pageScrollSize;
      }
      
      override protected function measure() : void
      {
         super.measure();
         upArrow.validateSize();
         downArrow.validateSize();
         scrollTrack.validateSize();
         if(FlexVersion.compatibilityVersion >= FlexVersion.VERSION_3_0)
         {
            _minWidth = !!scrollThumb?Number(scrollThumb.getExplicitOrMeasuredWidth()):Number(0);
            _minWidth = Math.max(scrollTrack.getExplicitOrMeasuredWidth(),upArrow.getExplicitOrMeasuredWidth(),downArrow.getExplicitOrMeasuredWidth(),_minWidth);
         }
         else
         {
            _minWidth = upArrow.getExplicitOrMeasuredWidth();
         }
         _minHeight = upArrow.getExplicitOrMeasuredHeight() + downArrow.getExplicitOrMeasuredHeight();
      }
      
      mx_internal function lineScroll(param1:int) : void
      {
         var _loc4_:Number = NaN;
         var _loc5_:String = null;
         var _loc2_:Number = _lineScrollSize;
         var _loc3_:Number = _scrollPosition + param1 * _loc2_;
         if(_loc3_ > maxScrollPosition)
         {
            _loc3_ = maxScrollPosition;
         }
         else if(_loc3_ < minScrollPosition)
         {
            _loc3_ = minScrollPosition;
         }
         if(_loc3_ != scrollPosition)
         {
            _loc4_ = scrollPosition;
            scrollPosition = _loc3_;
            _loc5_ = param1 < 0?lineMinusDetail:linePlusDetail;
            dispatchScrollEvent(_loc4_,_loc5_);
         }
      }
      
      public function setScrollProperties(param1:Number, param2:Number, param3:Number, param4:Number = 0) : void
      {
         var _loc5_:Number = NaN;
         this.pageSize = param1;
         _pageScrollSize = param4 > 0?Number(param4):Number(param1);
         this.minScrollPosition = Math.max(param2,0);
         this.maxScrollPosition = Math.max(param3,0);
         _scrollPosition = Math.max(this.minScrollPosition,_scrollPosition);
         _scrollPosition = Math.min(this.maxScrollPosition,_scrollPosition);
         if(this.maxScrollPosition - this.minScrollPosition > 0 && enabled)
         {
            upArrow.enabled = true;
            downArrow.enabled = true;
            scrollTrack.enabled = true;
            addEventListener(MouseEvent.MOUSE_DOWN,scrollTrack_mouseDownHandler);
            addEventListener(MouseEvent.MOUSE_OVER,scrollTrack_mouseOverHandler);
            addEventListener(MouseEvent.MOUSE_OUT,scrollTrack_mouseOutHandler);
            if(!scrollThumb)
            {
               scrollThumb = new mx.controls.scrollClasses.ScrollThumb();
               scrollThumb.focusEnabled = false;
               addChildAt(scrollThumb,getChildIndex(downArrow));
               scrollThumb.styleName = new StyleProxy(this,thumbStyleFilters);
               scrollThumb.upSkinName = "thumbUpSkin";
               scrollThumb.overSkinName = "thumbOverSkin";
               scrollThumb.downSkinName = "thumbDownSkin";
               scrollThumb.iconName = "thumbIcon";
               scrollThumb.skinName = "thumbSkin";
            }
            _loc5_ = trackHeight < 0?Number(0):Number(Math.round(param1 / (this.maxScrollPosition - this.minScrollPosition + param1) * trackHeight));
            if(_loc5_ < scrollThumb.minHeight)
            {
               if(trackHeight < scrollThumb.minHeight)
               {
                  scrollThumb.visible = false;
               }
               else
               {
                  _loc5_ = scrollThumb.minHeight;
                  scrollThumb.visible = true;
                  scrollThumb.setActualSize(scrollThumb.measuredWidth,scrollThumb.minHeight);
               }
            }
            else
            {
               scrollThumb.visible = true;
               scrollThumb.setActualSize(scrollThumb.measuredWidth,_loc5_);
            }
            scrollThumb.setRange(upArrow.getExplicitOrMeasuredHeight() + 0,virtualHeight - downArrow.getExplicitOrMeasuredHeight() - scrollThumb.height,this.minScrollPosition,this.maxScrollPosition);
            scrollPosition = Math.max(Math.min(scrollPosition,this.maxScrollPosition),this.minScrollPosition);
         }
         else
         {
            upArrow.enabled = false;
            downArrow.enabled = false;
            scrollTrack.enabled = false;
            if(scrollThumb)
            {
               scrollThumb.visible = false;
            }
         }
      }
      
      private function trackScrollTimerHandler(param1:Event) : void
      {
         if(trackScrollRepeatDirection == 1)
         {
            if(scrollThumb.y + scrollThumb.height > trackPosition)
            {
               return;
            }
         }
         if(trackScrollRepeatDirection == -1)
         {
            if(scrollThumb.y < trackPosition)
            {
               return;
            }
         }
         pageScroll(trackScrollRepeatDirection);
         if(trackScrollTimer && trackScrollTimer.repeatCount == 1)
         {
            trackScrollTimer.delay = getStyle("repeatInterval");
            trackScrollTimer.repeatCount = 0;
         }
      }
      
      private function upArrow_buttonDownHandler(param1:FlexEvent) : void
      {
         if(isNaN(oldPosition))
         {
            oldPosition = scrollPosition;
         }
         lineScroll(-1);
      }
      
      public function set pageSize(param1:Number) : void
      {
         _pageSize = param1;
      }
      
      private function get trackY() : Number
      {
         return upArrow.getExplicitOrMeasuredHeight();
      }
      
      private function scrollTrack_mouseOutHandler(param1:MouseEvent) : void
      {
         if(trackScrolling)
         {
            trackScrollTimer.stop();
         }
      }
      
      private function scrollTrack_mouseUpHandler(param1:MouseEvent) : void
      {
         scrollTrack_mouseLeaveHandler(param1);
      }
      
      private function scrollTrack_mouseMoveHandler(param1:MouseEvent) : void
      {
         var _loc2_:Point = null;
         if(trackScrolling)
         {
            _loc2_ = new Point(param1.stageX,param1.stageY);
            _loc2_ = globalToLocal(_loc2_);
            trackPosition = _loc2_.y;
         }
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         if($height == 1)
         {
            return;
         }
         if(!upArrow)
         {
            return;
         }
         super.updateDisplayList(param1,param2);
         if(cacheAsBitmap)
         {
            cacheHeuristic = scrollThumb.cacheHeuristic = false;
         }
         upArrow.setActualSize(upArrow.getExplicitOrMeasuredWidth(),upArrow.getExplicitOrMeasuredHeight());
         if(FlexVersion.compatibilityVersion >= FlexVersion.VERSION_3_0)
         {
            upArrow.move((virtualWidth - upArrow.width) / 2,0);
         }
         else
         {
            upArrow.move(0,0);
         }
         scrollTrack.setActualSize(scrollTrack.getExplicitOrMeasuredWidth(),virtualHeight);
         if(FlexVersion.compatibilityVersion >= FlexVersion.VERSION_3_0)
         {
            scrollTrack.x = (virtualWidth - scrollTrack.width) / 2;
         }
         scrollTrack.y = 0;
         downArrow.setActualSize(downArrow.getExplicitOrMeasuredWidth(),downArrow.getExplicitOrMeasuredHeight());
         if(FlexVersion.compatibilityVersion >= FlexVersion.VERSION_3_0)
         {
            downArrow.move((virtualWidth - downArrow.width) / 2,virtualHeight - downArrow.getExplicitOrMeasuredHeight());
         }
         else
         {
            downArrow.move(0,virtualHeight - downArrow.getExplicitOrMeasuredHeight());
         }
         setScrollProperties(pageSize,minScrollPosition,maxScrollPosition,_pageScrollSize);
         scrollPosition = _scrollPosition;
      }
      
      mx_internal function get pagePlusDetail() : String
      {
         return direction == ScrollBarDirection.VERTICAL?ScrollEventDetail.PAGE_DOWN:ScrollEventDetail.PAGE_RIGHT;
      }
      
      mx_internal function get virtualWidth() : Number
      {
         return unscaledWidth;
      }
      
      public function set direction(param1:String) : void
      {
         _direction = param1;
         invalidateSize();
         invalidateDisplayList();
         dispatchEvent(new Event("directionChanged"));
      }
      
      [Bindable("directionChanged")]
      public function get direction() : String
      {
         return _direction;
      }
   }
}
