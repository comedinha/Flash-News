package shared.controls
{
   import mx.core.ScrollControlBase;
   import flash.geom.Point;
   import mx.styles.CSSStyleDeclaration;
   import mx.styles.StyleManager;
   import shared.utility.ExtentCache;
   import flash.events.MouseEvent;
   import mx.controls.listClasses.IListItemRenderer;
   import flash.display.DisplayObject;
   import mx.core.EdgeMetrics;
   import mx.events.ScrollEvent;
   import mx.managers.LayoutManager;
   import mx.events.ScrollEventDirection;
   import flash.display.Graphics;
   import flash.utils.Timer;
   import flash.events.TimerEvent;
   import mx.events.SandboxMouseEvent;
   import flash.display.Stage;
   import mx.core.UIComponent;
   import mx.events.ListEvent;
   import mx.events.ListEventReason;
   import mx.events.CollectionEvent;
   import mx.events.CollectionEventKind;
   import mx.collections.IList;
   import mx.core.ClassFactory;
   import flash.events.Event;
   import mx.core.FlexSprite;
   import mx.core.ScrollPolicy;
   
   public class SmoothList extends ScrollControlBase
   {
      
      public static const FOLLOW_TAIL_ON:String = "on";
      
      private static const m_TempPoint2:Point = new Point();
      
      private static const DRAGSCROLL_DELAY:int = 50;
      
      private static const LINE_SCROLL_SIZE:Number = 6;
      
      private static const DRAGSCROLL_MAX_DISTANCE:Number = 128;
      
      public static const FOLLOW_TAIL_AUTO:String = "auto";
      
      private static const m_TempPoint:Point = new Point();
      
      private static const DRAGSCROLL_MAX_SPEED:Number = 12;
      
      public static const FOLLOW_TAIL_OFF:String = "off";
      
      {
         s_InitializeStyle();
      }
      
      protected var m_ExtentChache:ExtentCache = null;
      
      protected var m_SelectedIndex:int = -1;
      
      protected var m_Selectable:Boolean = true;
      
      protected var m_FirstVisibleItem:int = -1;
      
      private var m_MouseCursorOverList:Boolean = false;
      
      protected var m_AlignBottom:Boolean = false;
      
      protected var m_ForceUpdate:Boolean = false;
      
      protected var m_UIContentLayer:UIComponent = null;
      
      protected var m_RendererMap:Array = null;
      
      protected var m_ResizeFollowTailHeight:Number = NaN;
      
      private var m_UIConstructed:Boolean = false;
      
      protected var m_DragScrollTimer:Timer = null;
      
      protected var m_ItemDefaultCount:int = 1;
      
      protected var m_LastVisibleItem:int = -1;
      
      protected var m_ItemRendererFactory:ClassFactory = null;
      
      protected var m_ItemMinCount:int = 1;
      
      protected var m_FollowTail:Boolean = false;
      
      private var m_UncommittedRollOverItem:Boolean = true;
      
      protected var m_RollOverItem:int = -1;
      
      protected var m_FollowTailPolicy:String = "off";
      
      protected var m_UISelectionLayer:FlexSprite = null;
      
      private var m_UncommittedDataProvider:Boolean = false;
      
      protected var m_ItemHeightHint:int = 0;
      
      protected var m_DataProvider:IList = null;
      
      protected var m_DragScrollClick:Point = null;
      
      protected var m_UIItemLayer:UIComponent = null;
      
      protected var m_AvailableRenderers:Array = null;
      
      private var m_UncommittedSelectedIndex:Boolean = true;
      
      public function SmoothList(param1:Class, param2:int = 0)
      {
         super();
         verticalScrollPolicy = ScrollPolicy.ON;
         this.m_ItemHeightHint = param2;
         this.m_ItemRendererFactory = new ClassFactory(param1);
         this.resetExtentCache();
         this.resetRendererCache();
      }
      
      private static function s_InitializeStyle() : void
      {
         var Selector:String = "SmoothList";
         var Decl:CSSStyleDeclaration = StyleManager.getStyleDeclaration(Selector);
         if(Decl == null)
         {
            Decl = new CSSStyleDeclaration(Selector);
         }
         Decl.defaultFactory = function():void
         {
            this.borderSkin = undefined;
            this.itemBackgroundColors = undefined;
            this.itemBackgroundAlphas = undefined;
            this.itemHorizontalGap = 0;
            this.itemVerticalGap = 2;
            this.itemSelectionColor = 16711680;
            this.itemSelectionAlpha = 1;
            this.itemRendererStyle = undefined;
            this.paddingBottom = 0;
            this.paddingLeft = 0;
            this.paddingRight = 0;
            this.paddingTop = 0;
         };
         StyleManager.setStyleDeclaration(Selector,Decl,true);
      }
      
      public function get defaultItemCount() : int
      {
         return this.m_ItemDefaultCount;
      }
      
      protected function onMouseMove(param1:MouseEvent) : void
      {
         if(param1 != null)
         {
            this.updateRollOverItem(param1.stageX,param1.stageY,true);
         }
      }
      
      protected function aquireItemRenderer(param1:int = -1, param2:int = 1) : IListItemRenderer
      {
         var _loc3_:IListItemRenderer = null;
         if(param1 > -1 && param1 < this.m_UIItemLayer.numChildren)
         {
            _loc3_ = IListItemRenderer(this.m_UIItemLayer.getChildAt(param1));
         }
         else
         {
            if(this.m_AvailableRenderers.length > 0)
            {
               _loc3_ = IListItemRenderer(this.m_AvailableRenderers.pop());
            }
            else
            {
               _loc3_ = this.createItemRenderer();
            }
            if(param2 > 0)
            {
               this.m_UIItemLayer.addChild(DisplayObject(_loc3_));
            }
            else
            {
               this.m_UIItemLayer.addChildAt(DisplayObject(_loc3_),0);
            }
         }
         return _loc3_;
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         var _loc3_:EdgeMetrics = null;
         var _loc11_:Number = NaN;
         var _loc16_:int = 0;
         var _loc17_:Number = NaN;
         var _loc18_:int = 0;
         var _loc19_:Number = NaN;
         var _loc20_:ScrollEvent = null;
         var _loc21_:Array = null;
         var _loc22_:Array = null;
         super.updateDisplayList(param1,param2);
         _loc3_ = this.viewMetricsAndPadding;
         var _loc4_:Number = getStyle("itemHorizontalGap");
         var _loc5_:Number = getStyle("itemVerticalGap");
         var _loc6_:int = param1 - _loc3_.left - _loc3_.right;
         var _loc7_:int = param2 - _loc3_.top - _loc3_.bottom;
         var _loc8_:int = this.m_DataProvider != null?int(this.m_DataProvider.length):0;
         var _loc9_:int = this.m_ExtentChache.topToIndex(verticalScrollPosition);
         var _loc10_:IListItemRenderer = null;
         _loc11_ = verticalScrollPosition - this.m_ExtentChache.top(_loc9_);
         var _loc12_:Number = _loc11_ + _loc7_ + _loc5_;
         var _loc13_:Number = this.m_UIItemLayer.height;
         this.m_UIContentLayer.move(_loc3_.left,_loc3_.top);
         this.m_UIContentLayer.setActualSize(_loc6_,_loc7_);
         if(isNaN(_loc11_))
         {
            _loc11_ = 0;
         }
         this.m_AlignBottom = this.m_FollowTail || param2 > this.m_ResizeFollowTailHeight;
         if(this.m_ForceUpdate || this.m_AlignBottom || this.m_ExtentChache.width != _loc6_ || this.m_FirstVisibleItem != _loc9_ || this.m_LastVisibleItem != this.m_ExtentChache.topToIndex(verticalScrollPosition + _loc7_))
         {
            this.m_RendererMap.length = 0;
            this.m_ExtentChache.width = _loc6_;
            _loc16_ = 0;
            if(this.m_AlignBottom)
            {
               _loc16_ = -1;
               _loc13_ = 0;
               this.m_FirstVisibleItem = this.m_LastVisibleItem = _loc8_ - 1;
            }
            else
            {
               _loc16_ = 1;
               _loc13_ = 0;
               this.m_FirstVisibleItem = this.m_LastVisibleItem = Math.min(_loc9_,_loc8_ - 1);
            }
            _loc17_ = 0;
            _loc18_ = 0;
            _loc18_ = 0;
            _loc9_ = this.m_LastVisibleItem;
            while(_loc9_ >= 0 && _loc9_ < _loc8_ && _loc13_ < _loc12_)
            {
               _loc10_ = this.aquireItemRenderer(_loc18_++,_loc16_);
               _loc10_.data = this.m_DataProvider.getItemAt(_loc9_);
               _loc10_.height = NaN;
               _loc10_.width = _loc6_;
               LayoutManager.getInstance().validateClient(_loc10_,true);
               _loc17_ = _loc10_.getExplicitOrMeasuredHeight();
               _loc13_ = _loc13_ + (_loc17_ + _loc5_);
               this.m_RendererMap.splice(_loc16_ > 0?_loc18_ - 1:0,0,_loc10_);
               this.m_ExtentChache.updateItemAt(_loc17_,_loc9_);
               this.m_FirstVisibleItem = Math.min(this.m_FirstVisibleItem,_loc9_);
               this.m_LastVisibleItem = Math.max(this.m_LastVisibleItem,_loc9_);
               if(_loc16_ > 0 && _loc9_ == _loc8_ - 1 && _loc18_ < _loc8_ && _loc12_ > 0)
               {
                  _loc9_ = this.m_FirstVisibleItem;
                  _loc16_ = -1;
               }
               _loc9_ = _loc9_ + _loc16_;
            }
            this.trimItemRenderers(_loc18_);
            _loc19_ = 0;
            _loc9_ = 0;
            while(_loc9_ < _loc18_)
            {
               _loc10_ = IListItemRenderer(this.m_RendererMap[_loc9_]);
               _loc17_ = _loc10_.getExplicitOrMeasuredHeight();
               _loc10_.move(0,_loc19_);
               _loc10_.setActualSize(_loc6_,_loc17_);
               _loc19_ = _loc19_ + (_loc17_ + _loc5_);
               _loc9_++;
            }
         }
         if(_loc13_ > _loc12_ - _loc11_)
         {
            if(verticalScrollPosition > maxVerticalScrollPosition)
            {
               this.m_ResizeFollowTailHeight = param2;
               this.m_AlignBottom = true;
            }
         }
         else
         {
            this.m_ResizeFollowTailHeight = NaN;
         }
         if(this.m_AlignBottom)
         {
            this.m_UIItemLayer.move(0,_loc7_ - _loc13_);
            this.m_UIItemLayer.setActualSize(_loc6_,_loc13_);
         }
         else
         {
            this.m_UIItemLayer.move(0,_loc13_ < _loc7_?Number(0):Number(-_loc11_));
            this.m_UIItemLayer.setActualSize(_loc6_,_loc13_);
         }
         _loc13_ = _loc8_ > 0?Number(this.m_ExtentChache.bottom(_loc8_ - 1)):Number(0);
         setScrollBarProperties(1,1,_loc13_,_loc7_);
         if(this.m_AlignBottom)
         {
            verticalScrollPosition = Math.max(0,_loc13_ - _loc7_);
         }
         else
         {
            if(_loc13_ < _loc7_)
            {
               verticalScrollPosition = 0;
            }
            _loc20_ = new ScrollEvent(ScrollEvent.SCROLL);
            _loc20_.direction = ScrollEventDirection.VERTICAL;
            _loc20_.position = verticalScrollPosition;
            _loc20_.delta = 0;
            dispatchEvent(_loc20_);
         }
         var _loc14_:Point = localToGlobal(new Point(mouseX,mouseY));
         this.updateRollOverItem(_loc14_.x,_loc14_.y,this.m_ForceUpdate);
         this.m_ForceUpdate = false;
         var _loc15_:Graphics = this.m_UISelectionLayer.graphics;
         _loc15_.clear();
         if(getStyle("itemBackgroundColors") !== undefined)
         {
            _loc21_ = getStyle("itemBackgroundColors");
            _loc22_ = getStyle("itemBackgroundAlphas");
            if(_loc21_.length == 1)
            {
               _loc15_.beginFill(_loc21_[0],_loc22_[0]);
               _loc15_.drawRect(0,0,this.m_UIItemLayer.width,this.m_UIItemLayer.height);
            }
            else
            {
               _loc9_ = this.m_FirstVisibleItem;
               while(_loc9_ <= this.m_LastVisibleItem)
               {
                  if((!this.m_Selectable || this.m_SelectedIndex != _loc9_) && (_loc10_ = this.itemIndexToItemRenderer(_loc9_)) != null)
                  {
                     _loc15_.beginFill(_loc21_[_loc9_ % _loc21_.length],_loc22_[_loc9_ % _loc21_.length]);
                     _loc15_.drawRect(Math.floor(_loc10_.x - _loc4_ / 2),Math.floor(_loc10_.y - _loc5_ / 2),Math.ceil(_loc10_.width + _loc4_),Math.ceil(_loc10_.height + _loc5_));
                  }
                  _loc9_++;
               }
            }
         }
         if(this.m_Selectable && getStyle("itemSelectionColor") !== undefined && (_loc10_ = this.itemIndexToItemRenderer(this.m_SelectedIndex)) != null)
         {
            _loc15_.beginFill(getStyle("itemSelectionColor"),getStyle("itemSelectionAlpha"));
            _loc15_.drawRect(_loc10_.x,_loc10_.y,_loc10_.width,_loc10_.height);
         }
         _loc15_.endFill();
         this.m_UISelectionLayer.x = this.m_UIItemLayer.x;
         this.m_UISelectionLayer.y = this.m_UIItemLayer.y;
         if(verticalScrollBar != null)
         {
            verticalScrollBar.lineScrollSize = LINE_SCROLL_SIZE;
         }
         if(horizontalScrollBar != null)
         {
            horizontalScrollBar.lineScrollSize = LINE_SCROLL_SIZE;
         }
      }
      
      public function get minItemCount() : int
      {
         return this.m_ItemMinCount;
      }
      
      protected function resetRendererCache() : void
      {
         if(this.m_AvailableRenderers == null)
         {
            this.m_AvailableRenderers = new Array();
         }
         this.m_AvailableRenderers.length = 0;
         if(this.m_RendererMap == null)
         {
            this.m_RendererMap = new Array();
         }
         this.m_RendererMap.length = 0;
         if(this.m_UIItemLayer != null)
         {
            while(this.m_UIItemLayer.numChildren > 0)
            {
               this.m_UIItemLayer.removeChildAt(0);
            }
         }
      }
      
      public function set followTailPolicy(param1:String) : void
      {
         switch(param1)
         {
            case FOLLOW_TAIL_ON:
               this.m_FollowTail = true;
               break;
            case FOLLOW_TAIL_OFF:
               this.m_FollowTail = false;
               break;
            case FOLLOW_TAIL_AUTO:
               this.m_FollowTail = true;
               break;
            default:
               return;
         }
         this.m_FollowTailPolicy = param1;
         invalidateDisplayList();
      }
      
      public function set minItemCount(param1:int) : void
      {
         if(this.m_ItemMinCount != param1)
         {
            this.m_ItemMinCount = Math.max(1,param1);
            this.m_ItemDefaultCount = Math.max(this.m_ItemMinCount,this.m_ItemDefaultCount);
            invalidateSize();
         }
      }
      
      protected function startDragToScroll() : void
      {
         if(this.m_DragScrollTimer != null)
         {
            this.stopDragToScroll();
         }
         this.m_DragScrollTimer = new Timer(DRAGSCROLL_DELAY);
         this.m_DragScrollTimer.addEventListener(TimerEvent.TIMER,this.onDragScrollTimer);
         this.m_DragScrollTimer.start();
         var _loc1_:DisplayObject = systemManager.getSandboxRoot();
         if(_loc1_ != null)
         {
            _loc1_.addEventListener(MouseEvent.MOUSE_UP,this.onMouseUp);
            _loc1_.addEventListener(SandboxMouseEvent.MOUSE_UP_SOMEWHERE,this.onMouseUp);
         }
      }
      
      public function set defaultItemCount(param1:int) : void
      {
         if(this.m_ItemDefaultCount != param1)
         {
            this.m_ItemDefaultCount = Math.max(this.m_ItemMinCount,param1);
            invalidateSize();
         }
      }
      
      protected function createItemRenderer() : IListItemRenderer
      {
         var _loc1_:IListItemRenderer = IListItemRenderer(this.m_ItemRendererFactory.newInstance());
         _loc1_.owner = this;
         if(getStyle("itemRendererStyle") !== undefined)
         {
            _loc1_.styleName = getStyle("itemRendererStyle");
         }
         else
         {
            _loc1_.styleName = this;
         }
         return _loc1_;
      }
      
      public function set selectedItem(param1:Object) : void
      {
         if(this.m_Selectable && param1 != null && this.m_DataProvider != null)
         {
            this.m_SelectedIndex = this.m_DataProvider.getItemIndex(param1);
            this.m_UncommittedSelectedIndex = true;
            invalidateProperties();
         }
      }
      
      protected function onRollOver(param1:MouseEvent) : void
      {
         this.m_MouseCursorOverList = true;
         if(param1 != null)
         {
            this.updateRollOverItem(param1.stageX,param1.stageY,true);
            this.m_DragScrollClick = null;
         }
      }
      
      public function mouseEventToItemRenderer(param1:MouseEvent) : IListItemRenderer
      {
         var _loc3_:DisplayObject = null;
         var _loc2_:Class = this.m_ItemRendererFactory.generator;
         if(param1 != null)
         {
            _loc3_ = param1.target as DisplayObject;
            while(_loc3_ != null && !(_loc3_ is Stage))
            {
               if(_loc3_ is _loc2_)
               {
                  return _loc3_ as IListItemRenderer;
               }
               _loc3_ = _loc3_.parent;
            }
         }
         return null;
      }
      
      public function pointToItemIndex(param1:Number, param2:Number) : int
      {
         var _loc11_:Point = null;
         var _loc3_:int = this.m_FirstVisibleItem;
         var _loc4_:int = this.m_LastVisibleItem;
         if(_loc3_ < 0 || _loc4_ < 0 || !hitTestPoint(param1,param2))
         {
            return -1;
         }
         var _loc5_:Number = verticalScrollPosition;
         if(isNaN(_loc5_))
         {
            _loc5_ = 0;
         }
         m_TempPoint.setTo(param1,param2);
         var _loc6_:Point = globalToLocal(m_TempPoint);
         if(_loc6_.x < 0 || _loc6_.x > this.width || _loc6_.y < 0 || _loc6_.y > this.height)
         {
            return -1;
         }
         _loc11_ = this.m_UIItemLayer.globalToContent(m_TempPoint);
         if(_loc11_.x < 0 || _loc11_.x > this.m_UIItemLayer.width)
         {
            return -1;
         }
         var _loc7_:Number = unscaledHeight - viewMetrics.top - viewMetrics.bottom;
         if(this.m_AlignBottom && this.m_ExtentChache.bottom(this.m_LastVisibleItem) < _loc7_)
         {
            _loc5_ = _loc5_ + (_loc6_.y - (_loc7_ - this.m_ExtentChache.bottom(this.m_LastVisibleItem)));
         }
         else
         {
            _loc5_ = _loc5_ + _loc6_.y;
         }
         var _loc8_:* = 0;
         var _loc9_:Number = 0;
         var _loc10_:Number = 0;
         while(_loc3_ <= _loc4_)
         {
            _loc8_ = _loc3_ + _loc4_ >> 1;
            _loc9_ = this.m_ExtentChache.top(_loc8_);
            _loc10_ = _loc9_ + this.m_ExtentChache.getItemAt(_loc8_);
            if(_loc5_ < _loc9_)
            {
               _loc4_ = _loc8_ - 1;
               continue;
            }
            if(_loc5_ > _loc10_)
            {
               _loc3_ = _loc8_ + 1;
               continue;
            }
            return _loc8_;
         }
         return -1;
      }
      
      protected function resetExtentCache() : void
      {
         if(this.m_ExtentChache == null)
         {
            this.m_ExtentChache = new ExtentCache(this.m_ItemHeightHint);
         }
         this.m_ExtentChache.reset();
         this.m_ExtentChache.gap = getStyle("itemVerticalGap");
         this.m_FirstVisibleItem = -1;
         this.m_LastVisibleItem = -1;
         this.m_FollowTail = this.m_FollowTailPolicy == FOLLOW_TAIL_ON || this.m_FollowTailPolicy == FOLLOW_TAIL_AUTO;
      }
      
      protected function stopDragToScroll() : void
      {
         if(this.m_DragScrollTimer != null)
         {
            this.m_DragScrollTimer.stop();
            this.m_DragScrollTimer.removeEventListener(TimerEvent.TIMER,this.onDragScrollTimer);
         }
         this.m_DragScrollTimer = null;
         var _loc1_:DisplayObject = systemManager.getSandboxRoot();
         if(_loc1_ != null)
         {
            _loc1_.removeEventListener(MouseEvent.MOUSE_UP,this.onMouseUp);
            _loc1_.removeEventListener(SandboxMouseEvent.MOUSE_UP_SOMEWHERE,this.onMouseUp);
         }
      }
      
      protected function updateRollOverItem(param1:Number, param2:Number, param3:Boolean = false) : void
      {
         var _loc4_:int = -1;
         if(this.m_MouseCursorOverList && !isNaN(param1) && !isNaN(param2))
         {
            _loc4_ = this.pointToItemIndex(param1,param2);
         }
         var _loc5_:ListEvent = null;
         if(param3 || this.m_RollOverItem != _loc4_)
         {
            if(this.m_RollOverItem > -1 && this.m_RollOverItem != _loc4_)
            {
               _loc5_ = new ListEvent(ListEvent.ITEM_ROLL_OUT);
               _loc5_.columnIndex = 0;
               _loc5_.rowIndex = this.m_RollOverItem;
               _loc5_.reason = ListEventReason.OTHER;
               _loc5_.itemRenderer = this.itemIndexToItemRenderer(this.m_RollOverItem);
               dispatchEvent(_loc5_);
            }
            this.m_RollOverItem = _loc4_;
            if(this.m_RollOverItem > -1)
            {
               _loc5_ = new ListEvent(ListEvent.ITEM_ROLL_OVER);
               _loc5_.columnIndex = 0;
               _loc5_.rowIndex = this.m_RollOverItem;
               _loc5_.reason = ListEventReason.OTHER;
               _loc5_.itemRenderer = this.itemIndexToItemRenderer(this.m_RollOverItem);
               dispatchEvent(_loc5_);
            }
         }
      }
      
      protected function onMouseClick(param1:MouseEvent) : void
      {
         var _loc3_:ListEvent = null;
         var _loc2_:int = 0;
         if(param1 != null && (_loc2_ = this.pointToItemIndex(param1.stageX,param1.stageY)) > -1)
         {
            this.selectedIndex = _loc2_;
            _loc3_ = new ListEvent(ListEvent.ITEM_CLICK);
            _loc3_.columnIndex = 0;
            _loc3_.rowIndex = _loc2_;
            _loc3_.reason = ListEventReason.OTHER;
            _loc3_.itemRenderer = this.itemIndexToItemRenderer(_loc2_);
            dispatchEvent(_loc3_);
         }
      }
      
      override protected function mouseWheelHandler(param1:MouseEvent) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:ScrollEvent = null;
         if(verticalScrollBar != null && verticalScrollBar.visible)
         {
            param1.stopPropagation();
            _loc2_ = verticalScrollPosition;
            _loc3_ = verticalScrollPosition - param1.delta * verticalScrollBar.lineScrollSize;
            if(_loc3_ < 0)
            {
               _loc3_ = 0;
            }
            if(_loc3_ > maxVerticalScrollPosition)
            {
               _loc3_ = maxVerticalScrollPosition;
            }
            if(this.m_FollowTailPolicy == FOLLOW_TAIL_AUTO)
            {
               this.m_FollowTail = _loc3_ >= maxVerticalScrollPosition;
            }
            if(_loc2_ != _loc3_)
            {
               verticalScrollPosition = _loc3_;
               _loc4_ = new ScrollEvent(ScrollEvent.SCROLL);
               _loc4_.direction = ScrollEventDirection.VERTICAL;
               _loc4_.position = _loc3_;
               _loc4_.delta = _loc3_ - _loc2_;
               dispatchEvent(_loc4_);
               invalidateDisplayList();
            }
         }
      }
      
      protected function onDataProviderChange(param1:CollectionEvent) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         if(param1 != null)
         {
            _loc2_ = unscaledHeight - viewMetrics.top - viewMetrics.bottom;
            _loc3_ = NaN;
            _loc4_ = NaN;
            _loc5_ = verticalScrollPosition;
            switch(param1.kind)
            {
               case CollectionEventKind.ADD:
                  this.m_ExtentChache.addItemAt(NaN,param1.location);
                  if(param1.location <= this.m_FirstVisibleItem)
                  {
                     this.m_FirstVisibleItem++;
                     this.m_LastVisibleItem++;
                     verticalScrollPosition = verticalScrollPosition + (this.m_ExtentChache.getItemAt(param1.location) + this.m_ExtentChache.gap);
                  }
                  else if(param1.location > this.m_FirstVisibleItem && param1.location <= this.m_LastVisibleItem)
                  {
                     this.m_LastVisibleItem++;
                  }
                  break;
               case CollectionEventKind.MOVE:
                  _loc3_ = this.m_ExtentChache.removeItemAt(param1.oldLocation);
                  this.m_ExtentChache.addItemAt(_loc3_,param1.location);
                  if(param1.oldLocation < this.m_FirstVisibleItem)
                  {
                     verticalScrollPosition = verticalScrollPosition - _loc3_;
                     this.m_FirstVisibleItem--;
                  }
                  if(param1.location <= this.m_FirstVisibleItem)
                  {
                     verticalScrollPosition = verticalScrollPosition + _loc3_;
                     this.m_FirstVisibleItem++;
                  }
                  if(param1.oldLocation >= this.m_FirstVisibleItem && param1.oldLocation <= this.m_LastVisibleItem || param1.location >= this.m_FirstVisibleItem && param1.location <= this.m_LastVisibleItem)
                  {
                     this.m_LastVisibleItem = Math.min(this.m_LastVisibleItem,param1.oldLocation - 1,param1.location - 1);
                  }
                  break;
               case CollectionEventKind.REMOVE:
                  _loc3_ = this.m_ExtentChache.removeItemAt(param1.location);
                  if(param1.location < this.m_FirstVisibleItem)
                  {
                     this.m_FirstVisibleItem--;
                     this.m_LastVisibleItem--;
                     verticalScrollPosition = verticalScrollPosition - (_loc3_ + this.m_ExtentChache.gap);
                  }
                  else if(this.m_FirstVisibleItem <= param1.location && param1.location <= this.m_LastVisibleItem)
                  {
                     this.m_LastVisibleItem--;
                  }
                  break;
               case CollectionEventKind.REPLACE:
               case CollectionEventKind.UPDATE:
                  if(param1.location > -1)
                  {
                     if(param1.location > -1 && param1.location < this.m_FirstVisibleItem)
                     {
                        _loc3_ = this.m_ExtentChache.updateItemAt(NaN,param1.location);
                        _loc4_ = !isNaN(_loc3_)?Number(this.m_ExtentChache.getItemAt(param1.location) - _loc3_):Number(0);
                        verticalScrollPosition = verticalScrollPosition + _loc4_;
                     }
                     else if(param1.location == this.m_FirstVisibleItem)
                     {
                        verticalScrollPosition = this.m_ExtentChache.top(this.m_FirstVisibleItem);
                        this.m_LastVisibleItem = -1;
                     }
                     else if(param1.location > this.m_FirstVisibleItem && param1.location <= this.m_LastVisibleItem)
                     {
                        this.m_LastVisibleItem = -1;
                     }
                  }
                  break;
               case CollectionEventKind.REFRESH:
                  this.m_ForceUpdate = true;
                  if(this.m_DataProvider.length > 0)
                  {
                     verticalScrollPosition = Math.max(0,Math.min(_loc5_,maxVerticalScrollPosition));
                  }
                  else
                  {
                     verticalScrollPosition = 0;
                  }
                  break;
               case CollectionEventKind.RESET:
                  this.m_ForceUpdate = true;
                  this.resetExtentCache();
                  verticalScrollPosition = 0;
            }
            this.m_SelectedIndex = -1;
            this.m_UncommittedSelectedIndex = true;
            invalidateProperties();
            this.m_ForceUpdate = true;
            invalidateDisplayList();
         }
      }
      
      public function get viewMetricsAndPadding() : EdgeMetrics
      {
         var _loc1_:EdgeMetrics = viewMetrics.clone();
         _loc1_.bottom = _loc1_.bottom + getStyle("paddingBottom");
         _loc1_.left = _loc1_.left + getStyle("paddingLeft");
         _loc1_.right = _loc1_.right + getStyle("paddingRight");
         _loc1_.top = _loc1_.top + getStyle("paddingTop");
         return _loc1_;
      }
      
      protected function onRollOut(param1:MouseEvent) : void
      {
         this.m_MouseCursorOverList = false;
         if(param1 != null)
         {
            if(param1.buttonDown && this.m_DragScrollClick != null && this.m_DragScrollTimer == null)
            {
               this.startDragToScroll();
            }
            if(this.m_RollOverItem > -1)
            {
               this.updateRollOverItem(param1.stageX,param1.stageY,true);
            }
         }
      }
      
      public function get dataProvider() : IList
      {
         return this.m_DataProvider;
      }
      
      public function itemRendererToIndex(param1:IListItemRenderer) : int
      {
         var _loc2_:int = this.m_RendererMap.length - 1;
         while(_loc2_ >= 0)
         {
            if(this.m_RendererMap[_loc2_] == param1)
            {
               return this.m_FirstVisibleItem + _loc2_;
            }
            _loc2_--;
         }
         return -1;
      }
      
      protected function onDragScrollTimer(param1:TimerEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:ScrollEvent = null;
         if(param1 != null)
         {
            _loc2_ = 0;
            _loc3_ = 0;
            if(mouseY < 0)
            {
               _loc2_ = -1;
               _loc3_ = -mouseY;
            }
            if(mouseY > unscaledHeight)
            {
               _loc2_ = 1;
               _loc3_ = mouseY - unscaledHeight;
            }
            if(_loc2_ == 0 || _loc3_ == 0)
            {
               return;
            }
            _loc3_ = Math.min(_loc3_,DRAGSCROLL_MAX_DISTANCE) / DRAGSCROLL_MAX_DISTANCE;
            _loc3_ = _loc2_ * _loc3_ * DRAGSCROLL_MAX_SPEED;
            _loc4_ = verticalScrollPosition;
            _loc5_ = verticalScrollPosition + _loc3_;
            if(_loc5_ < 0)
            {
               _loc5_ = 0;
            }
            if(_loc5_ > maxVerticalScrollPosition)
            {
               _loc5_ = maxVerticalScrollPosition;
            }
            if(_loc4_ != _loc5_)
            {
               verticalScrollPosition = _loc5_;
               _loc6_ = new ScrollEvent(ScrollEvent.SCROLL);
               _loc6_.direction = ScrollEventDirection.VERTICAL;
               _loc6_.position = _loc5_;
               _loc6_.delta = _loc5_ - _loc4_;
               dispatchEvent(_loc6_);
               invalidateDisplayList();
            }
         }
      }
      
      protected function onMouseDown(param1:MouseEvent) : void
      {
         if(param1 != null)
         {
            if(hitTestPoint(param1.stageX,param1.stageY))
            {
               this.m_DragScrollClick = new Point(param1.localX,param1.localY);
            }
            else
            {
               this.m_DragScrollClick = null;
            }
         }
      }
      
      public function get followTailPolicy() : String
      {
         return this.m_FollowTailPolicy;
      }
      
      protected function onMouseUp(param1:Event) : void
      {
         if(param1 != null)
         {
            this.stopDragToScroll();
         }
      }
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
         if(this.m_UncommittedDataProvider)
         {
            this.m_SelectedIndex = -1;
            this.m_RollOverItem = -1;
            this.resetExtentCache();
            this.resetRendererCache();
            invalidateDisplayList();
            this.m_UncommittedDataProvider = false;
         }
         if(this.m_UncommittedSelectedIndex)
         {
            invalidateDisplayList();
            this.m_UncommittedSelectedIndex = false;
         }
         if(this.m_UncommittedRollOverItem)
         {
            invalidateDisplayList();
            this.m_UncommittedRollOverItem = false;
         }
      }
      
      override public function styleChanged(param1:String) : void
      {
         switch(param1)
         {
            case "itemVerticalGap":
               this.m_ExtentChache.gap = getStyle("itemVerticalGap");
               break;
            default:
               super.styleChanged(param1);
         }
      }
      
      override protected function createChildren() : void
      {
         if(!this.m_UIConstructed)
         {
            super.createChildren();
            this.m_UIContentLayer = new UIComponent();
            this.m_UIContentLayer.mask = maskShape;
            addChild(this.m_UIContentLayer);
            this.m_UISelectionLayer = new FlexSprite();
            this.m_UISelectionLayer.mouseEnabled = false;
            this.m_UIContentLayer.addChild(this.m_UISelectionLayer);
            this.m_UIItemLayer = new UIComponent();
            this.m_UIItemLayer.addEventListener(MouseEvent.CLICK,this.onMouseClick);
            this.m_UIItemLayer.addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
            this.m_UIItemLayer.addEventListener(MouseEvent.MOUSE_UP,this.onMouseUp);
            this.m_UIContentLayer.addChild(this.m_UIItemLayer);
            addEventListener(MouseEvent.ROLL_OUT,this.onRollOut);
            addEventListener(MouseEvent.ROLL_OVER,this.onRollOver);
            addEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMove);
            this.m_UIConstructed = true;
         }
      }
      
      public function set selectable(param1:Boolean) : void
      {
         if(this.m_Selectable && !param1)
         {
            this.selectedIndex = -1;
         }
         this.m_Selectable = param1;
      }
      
      override protected function measure() : void
      {
         super.measure();
         var _loc1_:Number = 0;
         if(!isNaN(getStyle("itemVerticalGap")))
         {
            _loc1_ = getStyle("itemVerticalGap");
         }
         if(this.m_ItemMinCount > 1)
         {
            measuredMinHeight = this.m_ItemMinCount * this.m_ItemHeightHint + (this.m_ItemMinCount - 1) * _loc1_;
         }
         else
         {
            measuredMinHeight = this.m_ItemHeightHint;
         }
         if(this.m_ItemDefaultCount > 1)
         {
            measuredHeight = this.m_ItemDefaultCount * this.m_ItemHeightHint + (this.m_ItemDefaultCount - 1) * _loc1_;
         }
         else
         {
            measuredHeight = this.m_ItemHeightHint;
         }
      }
      
      override protected function scrollHandler(param1:Event) : void
      {
         super.scrollHandler(param1);
         if(this.m_FollowTailPolicy == FOLLOW_TAIL_AUTO)
         {
            this.m_FollowTail = verticalScrollPosition >= maxVerticalScrollPosition;
         }
         invalidateDisplayList();
      }
      
      protected function trimItemRenderers(param1:int = 0) : void
      {
         var _loc2_:int = this.m_UIItemLayer.numChildren;
         while(param1 >= 0 && _loc2_ > param1)
         {
            this.m_AvailableRenderers.push(this.m_UIItemLayer.removeChildAt(--_loc2_));
         }
      }
      
      public function get selectable() : Boolean
      {
         return this.m_Selectable;
      }
      
      public function set dataProvider(param1:IList) : void
      {
         if(this.m_DataProvider != param1)
         {
            if(this.m_DataProvider != null)
            {
               this.m_DataProvider.removeEventListener(CollectionEvent.COLLECTION_CHANGE,this.onDataProviderChange);
            }
            this.m_DataProvider = param1;
            if(this.m_DataProvider != null)
            {
               this.m_DataProvider.addEventListener(CollectionEvent.COLLECTION_CHANGE,this.onDataProviderChange);
            }
            this.m_UncommittedDataProvider = true;
            invalidateProperties();
         }
      }
      
      public function get selectedIndex() : int
      {
         return this.m_SelectedIndex;
      }
      
      public function get selectedItem() : Object
      {
         if(this.m_Selectable && this.m_DataProvider != null && this.m_SelectedIndex >= 0 && this.m_SelectedIndex < this.m_DataProvider.length)
         {
            return this.m_DataProvider.getItemAt(this.m_SelectedIndex);
         }
         return null;
      }
      
      public function set selectedIndex(param1:int) : void
      {
         if(this.m_Selectable && this.m_SelectedIndex != param1)
         {
            if(this.m_DataProvider == null || !this.m_Selectable)
            {
               this.m_SelectedIndex = -1;
            }
            else
            {
               this.m_SelectedIndex = Math.min(Math.max(0,param1),this.m_DataProvider.length);
            }
            this.m_UncommittedSelectedIndex = true;
            invalidateProperties();
         }
      }
      
      public function itemIndexToItemRenderer(param1:int) : IListItemRenderer
      {
         if(param1 < this.m_FirstVisibleItem || param1 > this.m_LastVisibleItem)
         {
            return null;
         }
         return this.m_RendererMap[param1 - this.m_FirstVisibleItem] as IListItemRenderer;
      }
   }
}
