package tibia.sidebar
{
   import mx.core.Container;
   import mx.events.DragEvent;
   import tibia.sidebar.sideBarWidgetClasses.WidgetView;
   import mx.core.DragSource;
   import mx.managers.DragManager;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import mx.events.SandboxMouseEvent;
   import mx.events.PropertyChangeEvent;
   import mx.events.CollectionEvent;
   import mx.core.EdgeMetrics;
   import flash.display.DisplayObject;
   import mx.events.CollectionEventKind;
   import tibia.options.OptionsStorage;
   import tibia.sidebar.sideBarWidgetClasses.SideBarHeader;
   import tibia.cursors.CursorHelper;
   import flash.geom.Point;
   import mx.core.UIComponent;
   import mx.core.IUIComponent;
   import mx.core.mx_internal;
   import mx.core.IBorder;
   import mx.managers.CursorManagerPriority;
   import mx.core.ScrollPolicy;
   
   public class SideBarWidget extends Container
   {
      
      protected static const DRAG_OPACITY:Number = 0.75;
      
      protected static const DEFAULT_WIDGET_HEIGHT:Number = 200;
      
      protected static const DEFAULT_WIDGET_WIDTH:Number = 184;
      
      protected static const DRAG_TYPE_SPELL:String = "spell";
      
      protected static const DRAG_TYPE_CHANNEL:String = "channel";
      
      protected static const DRAG_TYPE_WIDGETBASE:String = "widgetBase";
      
      protected static const DRAG_TYPE_ACTION:String = "action";
      
      protected static const DRAG_TYPE_OBJECT:String = "object";
      
      protected static const DRAG_TYPE_STATUSWIDGET:String = "statusWidget";
       
      
      protected var m_StyleWithoutBorder:String = null;
      
      protected var m_LayoutMode:int = 0;
      
      private var m_UncommittedVisible:Boolean = false;
      
      private var m_UIConstructed:Boolean = false;
      
      protected var m_StyleWithBorder:String = null;
      
      protected var m_LayoutProtected:Object = null;
      
      protected var m_Options:OptionsStorage = null;
      
      private var m_DropOffset:Number = NaN;
      
      protected var m_SideBarSet:tibia.sidebar.SideBarSet = null;
      
      private var m_DropIndicatorSkipIndex:int = -1;
      
      private var m_ResizeWidget:WidgetView = null;
      
      private var m_UncommittedOptions:Boolean = false;
      
      protected var m_LayoutWidth:Number = 0;
      
      private var m_UncommittedStyleWithBorder:Boolean = false;
      
      private var m_UIHeader:SideBarHeader = null;
      
      private var m_UncommittedStyleWithoutBorder:Boolean = false;
      
      private var m_CursorHelper:CursorHelper;
      
      private var m_ResizeUsedHeight:Number = NaN;
      
      private var m_UIDropIndicator:DisplayObject = null;
      
      private var m_ResizeStartPoint:Point;
      
      private var m_DropOffsetList:Array;
      
      private var m_ResizeStartHeight:Number = NaN;
      
      private var m_UncommittedLocation:Boolean = false;
      
      protected var m_Location:int = -1;
      
      protected var m_DropAvailableHeight:Number = NaN;
      
      private var m_UncommittedSideBarSet:Boolean = false;
      
      public function SideBarWidget()
      {
         this.m_DropOffsetList = [];
         this.m_ResizeStartPoint = new Point(NaN,NaN);
         this.m_CursorHelper = new CursorHelper(CursorManagerPriority.HIGH);
         super();
         horizontalScrollPolicy = ScrollPolicy.OFF;
         verticalScrollPolicy = ScrollPolicy.OFF;
         addEventListener(DragEvent.DRAG_DROP,this.onWidgetDragEvent);
         addEventListener(DragEvent.DRAG_ENTER,this.onWidgetDragEvent);
         addEventListener(DragEvent.DRAG_EXIT,this.onWidgetDragEvent);
         addEventListener(DragEvent.DRAG_OVER,this.onWidgetDragEvent);
      }
      
      private function onWidgetDragEvent(param1:DragEvent) : void
      {
         var _loc4_:WidgetView = null;
         var _loc5_:int = 0;
         var _loc6_:Widget = null;
         var _loc7_:int = 0;
         var _loc2_:DragSource = null;
         var _loc3_:int = -1;
         if(param1 != null && (_loc2_ = param1.dragSource) != null && (_loc2_.hasFormat("dragType") && _loc2_.dataForFormat("dragType") == DRAG_TYPE_WIDGETBASE) && (_loc2_.hasFormat("widgetID") && (_loc3_ = int(_loc2_.dataForFormat("widgetID"))) > -1))
         {
            _loc4_ = null;
            _loc5_ = -1;
            switch(param1.type)
            {
               case DragEvent.DRAG_DROP:
                  _loc5_ = this.getDropIndex(param1.localY);
                  _loc6_ = this.m_SideBarSet.getWidgetByType(Widget.TYPE_PREMIUM);
                  if(_loc6_ != null && Tibia.s_GetPremiumManager().freePlayerLimitations)
                  {
                     _loc7_ = this.m_SideBarSet.getSideBar(this.m_Location).getWidgetInstanceIndex(_loc6_);
                     _loc5_ = Math.max(_loc5_,_loc7_ + 1);
                  }
                  if(this.m_DropIndicatorSkipIndex > -1 && _loc5_ > this.m_DropIndicatorSkipIndex)
                  {
                     _loc5_--;
                  }
                  this.m_SideBarSet.showWidgetByID(_loc3_,this.m_Location,_loc5_);
               case DragEvent.DRAG_EXIT:
                  this.updateDropIndicator(false);
                  break;
               case DragEvent.DRAG_ENTER:
                  _loc4_ = this.m_SideBarSet.getWidgetByID(_loc3_).acquireViewInstance(false);
                  _loc5_ = this.m_SideBarSet.getSideBar(this.m_Location).getWidgetIndexByID(_loc3_);
                  if(this.m_SideBarSet.getSideBar(this.m_Location).visible && this.hasEnoughSpace(_loc4_))
                  {
                     this.updateDropIndicator(true,_loc5_);
                     DragManager.acceptDragDrop(this);
                  }
               case DragEvent.DRAG_OVER:
                  this.layoutDropIndicator(param1.localY);
            }
         }
      }
      
      private function onWidgetMouseResizeEvent(param1:Event) : void
      {
         var _loc2_:Number = NaN;
         if(param1 != null && this.m_ResizeWidget != null)
         {
            switch(param1.type)
            {
               case MouseEvent.MOUSE_MOVE:
                  _loc2_ = this.m_ResizeStartHeight + MouseEvent(param1).stageY - this.m_ResizeStartPoint.y;
                  this.m_ResizeWidget.resizeWidgetAbsolute(_loc2_,false);
                  break;
               case MouseEvent.MOUSE_UP:
               case SandboxMouseEvent.MOUSE_UP_SOMEWHERE:
                  this.finishMouseResize();
            }
         }
      }
      
      function get sideBarSet() : tibia.sidebar.SideBarSet
      {
         return this.m_SideBarSet;
      }
      
      private function onWidgetDragInit(param1:MouseEvent) : void
      {
         var _loc4_:DragSource = null;
         var _loc2_:WidgetView = null;
         var _loc3_:Widget = null;
         if(param1 != null && (_loc2_ = param1.currentTarget as WidgetView) != null && (_loc3_ = _loc2_.widgetInstance) != null)
         {
            switch(param1.type)
            {
               case MouseEvent.MOUSE_DOWN:
                  if(_loc2_.hitTestDragHandle(param1.stageX,param1.stageY))
                  {
                     _loc2_.addEventListener(MouseEvent.MOUSE_MOVE,this.onWidgetDragInit);
                     _loc2_.addEventListener(MouseEvent.MOUSE_UP,this.onWidgetDragInit);
                     _loc2_.addEventListener(SandboxMouseEvent.MOUSE_UP_SOMEWHERE,this.onWidgetDragInit);
                  }
                  break;
               case MouseEvent.MOUSE_MOVE:
                  _loc4_ = new DragSource();
                  _loc4_.addData(DRAG_TYPE_WIDGETBASE,"dragType");
                  _loc4_.addData(_loc3_.ID,"widgetID");
                  DragManager.doDrag(_loc2_,_loc4_,param1 as MouseEvent);
               case MouseEvent.MOUSE_UP:
               case SandboxMouseEvent.MOUSE_UP_SOMEWHERE:
                  _loc2_.removeEventListener(MouseEvent.MOUSE_MOVE,this.onWidgetDragInit);
                  _loc2_.removeEventListener(MouseEvent.MOUSE_UP,this.onWidgetDragInit);
                  _loc2_.removeEventListener(SandboxMouseEvent.MOUSE_UP_SOMEWHERE,this.onWidgetDragInit);
            }
         }
      }
      
      function set sideBarSet(param1:tibia.sidebar.SideBarSet) : void
      {
         if(this.m_SideBarSet != param1)
         {
            if(this.m_SideBarSet != null)
            {
               this.m_SideBarSet.getSideBar(this.m_Location).removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onSideBarPropertyChange);
               this.m_SideBarSet.getSideBar(this.m_Location).removeEventListener(CollectionEvent.COLLECTION_CHANGE,this.onWidgetViewAddRemove);
            }
            this.m_SideBarSet = param1;
            if(this.m_SideBarSet != null)
            {
               this.m_SideBarSet.getSideBar(this.m_Location).addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onSideBarPropertyChange);
               this.m_SideBarSet.getSideBar(this.m_Location).addEventListener(CollectionEvent.COLLECTION_CHANGE,this.onWidgetViewAddRemove);
            }
            this.m_UncommittedSideBarSet = true;
            invalidateProperties();
         }
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         layoutChrome(param1,unscaledHeight);
         var _loc3_:EdgeMetrics = viewMetricsAndPadding;
         var _loc4_:Number = Math.max(0,getStyle("verticalGap"));
         var _loc5_:Number = 0;
         var _loc6_:Number = 0;
         var _loc7_:Number = 0;
         var _loc8_:Number = 0;
         var _loc9_:Number = getStyle("paddingLeft");
         var _loc10_:Number = 0;
         var _loc11_:Number = param1 - _loc3_.left - _loc3_.right;
         if(this.m_UIHeader != null)
         {
            _loc7_ = this.m_UIHeader.getExplicitOrMeasuredHeight();
            _loc8_ = this.m_UIHeader.getExplicitOrMeasuredWidth();
            this.m_UIHeader.visible = visible;
            this.m_UIHeader.move(Math.round(_loc3_.left + (_loc11_ - _loc8_) / 2),0);
            this.m_UIHeader.setActualSize(_loc8_,_loc7_);
            _loc10_ = _loc7_;
         }
         var _loc12_:int = 0;
         var _loc13_:WidgetView = null;
         var _loc14_:Number = param2 - _loc10_ - _loc3_.top - _loc3_.bottom;
         var _loc15_:Number = -_loc4_;
         if(!visible)
         {
            this.m_LayoutMode = 0;
            this.m_LayoutWidth = 0;
            this.m_DropAvailableHeight = 0;
            _loc12_ = numChildren - 1;
            while(_loc12_ >= 0)
            {
               _loc13_ = getChildAt(_loc12_) as WidgetView;
               _loc13_.visible = false;
               _loc12_--;
            }
         }
         else if(this.m_LayoutMode == 1)
         {
            this.m_LayoutMode = 0;
            this.m_LayoutWidth = _loc11_;
            this.m_DropAvailableHeight = 0;
            _loc6_ = _loc10_ + _loc3_.top;
            this.m_DropOffsetList.length = 0;
            this.m_DropOffsetList[0] = _loc6_;
            this.m_DropAvailableHeight = _loc14_;
            _loc12_ = 0;
            while(_loc12_ < numChildren)
            {
               if((_loc13_ = getChildAt(_loc12_) as WidgetView) != null && !_loc13_.widgetClosed)
               {
                  _loc7_ = _loc13_.widgetSuggestedHeight;
                  _loc15_ = _loc15_ + (_loc7_ + _loc4_);
                  if(_loc15_ <= _loc14_)
                  {
                     _loc13_.move(_loc9_,_loc6_);
                     _loc13_.setActualSize(_loc11_,_loc7_);
                     _loc13_.visible = true;
                     _loc6_ = _loc6_ + (_loc7_ + _loc4_);
                     this.m_DropOffsetList[_loc12_ + 1] = _loc6_;
                  }
                  else
                  {
                     _loc13_.widgetInstance.close(true);
                  }
                  this.m_DropAvailableHeight = this.m_DropAvailableHeight - (_loc13_.widgetRequiredHeight + _loc4_);
               }
               _loc12_++;
            }
         }
         else
         {
            this.m_LayoutMode = 0;
            this.m_LayoutWidth = _loc11_;
            this.m_DropAvailableHeight = _loc14_;
            _loc12_ = numChildren - 1;
            while(_loc12_ >= 0)
            {
               if((_loc13_ = getChildAt(_loc12_) as WidgetView) != null && !_loc13_.widgetClosed)
               {
                  _loc15_ = _loc15_ + (_loc13_.widgetSuggestedHeight + _loc4_);
               }
               _loc12_--;
            }
            _loc12_ = numChildren;
            while(_loc15_ > _loc14_ && --_loc12_ >= 0)
            {
               if((_loc13_ = getChildAt(_loc12_) as WidgetView) != null && !_loc13_.widgetClosed)
               {
                  if(_loc13_.widgetResizable)
                  {
                     _loc15_ = _loc15_ + _loc13_.resizeWidgetDelta(_loc14_ - _loc15_,this.m_ResizeWidget == null);
                  }
                  if(this.m_ResizeWidget == null && _loc15_ > _loc14_ && _loc13_.widgetClosable && !this.widgetIsProtected(_loc13_))
                  {
                     _loc13_.widgetInstance.close(true);
                     _loc15_ = _loc15_ - (_loc13_.widgetSuggestedHeight + _loc4_);
                  }
               }
            }
            this.widgetSetProtected(null);
            _loc12_ = numChildren;
            while(this.m_ResizeWidget != null && !isNaN(this.m_ResizeUsedHeight) && _loc15_ < this.m_ResizeUsedHeight && --_loc12_ >= 0)
            {
               _loc13_ = getChildAt(_loc12_) as WidgetView;
               if(_loc13_ == this.m_ResizeWidget)
               {
                  break;
               }
               if(!_loc13_.widgetClosed && _loc13_.widgetResizable)
               {
                  _loc15_ = _loc15_ + _loc13_.resizeWidgetDelta(this.m_ResizeUsedHeight - _loc15_,false);
               }
            }
            this.m_ResizeUsedHeight = _loc15_;
            _loc6_ = _loc10_ + _loc3_.top;
            this.m_DropOffsetList.length = 0;
            this.m_DropOffsetList[0] = _loc6_;
            this.m_DropAvailableHeight = _loc14_ + _loc4_;
            _loc12_ = 0;
            while(_loc12_ < numChildren)
            {
               if((_loc13_ = getChildAt(_loc12_) as WidgetView) != null)
               {
                  _loc7_ = _loc13_.widgetSuggestedHeight;
                  _loc13_.move(_loc9_,_loc6_);
                  _loc13_.setActualSize(_loc11_,_loc7_);
                  _loc13_.visible = true;
                  _loc6_ = _loc6_ + (_loc7_ + _loc4_);
                  this.m_DropOffsetList[_loc12_ + 1] = _loc6_;
                  if(!_loc13_.widgetClosed)
                  {
                     this.m_DropAvailableHeight = this.m_DropAvailableHeight - (_loc13_.widgetRequiredHeight + _loc4_);
                  }
               }
               _loc12_++;
            }
         }
         this.layoutDropIndicator();
      }
      
      private function updateDropIndicator(param1:Boolean, param2:int = -1) : void
      {
         var _loc3_:Class = null;
         if(!param1 && this.m_UIDropIndicator != null)
         {
            rawChildren.removeChild(this.m_UIDropIndicator);
            this.m_UIDropIndicator = null;
            this.m_DropIndicatorSkipIndex = -1;
         }
         if(param1 && this.m_UIDropIndicator == null)
         {
            _loc3_ = getStyle("dropIndicatorSkin") as Class;
            if(_loc3_ != null)
            {
               this.m_UIDropIndicator = DisplayObject(new _loc3_());
               rawChildren.addChild(this.m_UIDropIndicator);
            }
            this.m_DropIndicatorSkipIndex = param2;
         }
      }
      
      protected function onWidgetViewAddRemove(param1:CollectionEvent) : void
      {
         var _loc2_:Widget = null;
         var _loc3_:WidgetView = null;
         var _loc4_:DisplayObject = null;
         if(param1 != null)
         {
            this.finishMouseResize();
            _loc2_ = null;
            if(param1.items != null && param1.items.length == 1)
            {
               _loc2_ = Widget(param1.items[0]);
            }
            _loc3_ = null;
            switch(param1.kind)
            {
               case CollectionEventKind.ADD:
                  if(_loc2_ != null && (_loc3_ = _loc2_.acquireViewInstance(true)) != null)
                  {
                     _loc3_.addEventListener(MouseEvent.MOUSE_DOWN,this.onWidgetDragInit);
                     _loc3_.addEventListener(MouseEvent.MOUSE_MOVE,this.onWidgetMouseResizeInit);
                     _loc3_.addEventListener(MouseEvent.MOUSE_OVER,this.onWidgetMouseResizeInit);
                     _loc3_.addEventListener(MouseEvent.MOUSE_OUT,this.onWidgetMouseResizeInit);
                     _loc3_.addEventListener(MouseEvent.MOUSE_DOWN,this.onWidgetMouseResizeInit);
                     _loc3_.invalidateWidgetInstance();
                     addChildAt(_loc3_,param1.location);
                     this.widgetSetProtected(_loc3_);
                  }
                  break;
               case CollectionEventKind.REMOVE:
                  _loc4_ = removeChildAt(param1.location);
                  _loc4_.removeEventListener(MouseEvent.MOUSE_DOWN,this.onWidgetDragInit);
                  _loc4_.removeEventListener(MouseEvent.MOUSE_MOVE,this.onWidgetMouseResizeInit);
                  _loc4_.removeEventListener(MouseEvent.MOUSE_OVER,this.onWidgetMouseResizeInit);
                  _loc4_.removeEventListener(MouseEvent.MOUSE_OUT,this.onWidgetMouseResizeInit);
                  _loc4_.removeEventListener(MouseEvent.MOUSE_DOWN,this.onWidgetMouseResizeInit);
                  break;
               case CollectionEventKind.MOVE:
                  if(_loc2_ != null && (_loc3_ = _loc2_.acquireViewInstance(false)) != null)
                  {
                     _loc3_.invalidateWidgetInstance();
                     setChildIndex(_loc3_,param1.location);
                     this.widgetSetProtected(_loc3_);
                  }
                  break;
               default:
                  this.resetWidgets();
            }
         }
      }
      
      public function get options() : OptionsStorage
      {
         return this.m_Options;
      }
      
      override protected function createChildren() : void
      {
         if(!this.m_UIConstructed)
         {
            super.createChildren();
            this.resetHeader();
            this.resetWidgets();
            this.m_UIConstructed = true;
         }
      }
      
      protected function onSideBarPropertyChange(param1:PropertyChangeEvent) : void
      {
         if(param1 != null)
         {
            switch(param1.property as String)
            {
               case "visible":
                  this.visible = this.m_SideBarSet.getSideBar(this.m_Location).visible;
            }
         }
      }
      
      private function finishMouseResize() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:WidgetView = null;
         if(this.m_ResizeWidget != null)
         {
            _loc1_ = 0;
            _loc2_ = numChildren;
            if(contains(this.m_ResizeWidget))
            {
               _loc1_ = getChildIndex(this.m_ResizeWidget);
            }
            while(_loc1_ < _loc2_)
            {
               _loc3_ = getChildAt(_loc1_) as WidgetView;
               if(_loc3_ != null && !_loc3_.widgetClosed && (!_loc3_.widgetCollapsible || !_loc3_.widgetCollapsed) && _loc3_.widgetResizable)
               {
                  _loc3_.resizeWidgetAbsolute(_loc3_.widgetSuggestedHeight,true);
               }
               _loc1_++;
            }
            if(this.m_ResizeWidget != null)
            {
               this.m_ResizeWidget.addEventListener(MouseEvent.MOUSE_MOVE,this.onWidgetMouseResizeInit);
               this.m_ResizeWidget.addEventListener(MouseEvent.MOUSE_OVER,this.onWidgetMouseResizeInit);
               this.m_ResizeWidget.addEventListener(MouseEvent.MOUSE_OUT,this.onWidgetMouseResizeInit);
            }
         }
         systemManager.removeEventListener(MouseEvent.MOUSE_MOVE,this.onWidgetMouseResizeEvent);
         systemManager.removeEventListener(MouseEvent.MOUSE_UP,this.onWidgetMouseResizeEvent);
         systemManager.removeEventListener(SandboxMouseEvent.MOUSE_UP_SOMEWHERE,this.onWidgetMouseResizeEvent);
         this.m_ResizeWidget = null;
         this.m_ResizeStartHeight = NaN;
         this.m_ResizeStartPoint.x = NaN;
         this.m_ResizeStartPoint.y = NaN;
         this.updateMouseResizeCursor(false);
      }
      
      public function get location() : int
      {
         return this.m_Location;
      }
      
      public function get styleWithBorder() : String
      {
         return this.m_StyleWithBorder;
      }
      
      public function set options(param1:OptionsStorage) : void
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
            this.m_UncommittedOptions = true;
            invalidateProperties();
            this.updateSideBarSet();
         }
      }
      
      private function updateSiblingStyleNames() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:DisplayObject = null;
         if(parent != null)
         {
            _loc1_ = parent.numChildren;
            _loc2_ = 0;
            while(_loc2_ < _loc1_)
            {
               _loc3_ = parent.getChildAt(_loc2_);
               if(_loc3_ is SideBarWidget)
               {
                  SideBarWidget(_loc3_).updateOwnStyleName();
               }
               _loc2_++;
            }
         }
      }
      
      protected function widgetIsProtected(param1:*) : Boolean
      {
         if(param1 is Widget)
         {
            return (param1 as Widget).acquireViewInstance() == this.m_LayoutProtected;
         }
         if(param1 is WidgetView)
         {
            return param1 as WidgetView == this.m_LayoutProtected;
         }
         return false;
      }
      
      protected function resetHeader() : void
      {
         if(this.m_UIHeader != null)
         {
            this.m_UIHeader.sideBarSet = null;
            this.m_UIHeader.location = -1;
            rawChildren.removeChild(this.m_UIHeader as DisplayObject);
         }
         this.m_UIHeader = new SideBarHeader();
         this.m_UIHeader.sideBarSet = this.m_SideBarSet;
         this.m_UIHeader.location = this.m_Location;
         rawChildren.addChild(this.m_UIHeader as DisplayObject);
      }
      
      private function updateSideBarSet() : void
      {
         if(this.m_Options != null)
         {
            this.sideBarSet = this.m_Options.getSideBarSet(tibia.sidebar.SideBarSet.DEFAULT_SET);
         }
         else
         {
            this.sideBarSet = null;
         }
      }
      
      private function updateMouseResizeCursor(param1:Boolean) : void
      {
         var _loc2_:Class = null;
         if(param1)
         {
            _loc2_ = getStyle("resizeCursorSkin");
            if(!DragManager.isDragging)
            {
               this.m_CursorHelper.setCursor(_loc2_);
            }
         }
         else
         {
            this.m_CursorHelper.resetCursor();
         }
      }
      
      protected function onOptionsChange(param1:PropertyChangeEvent) : void
      {
         if(param1 != null)
         {
            switch(param1.property)
            {
               case "sideBarSet":
               case "*":
                  this.updateSideBarSet();
            }
         }
      }
      
      protected function widgetSetProtected(param1:*) : void
      {
         if(param1 is Widget)
         {
            this.m_LayoutProtected = (param1 as Widget).acquireViewInstance();
         }
         else if(param1 is WidgetView)
         {
            this.m_LayoutProtected = param1 as WidgetView;
         }
         else
         {
            this.m_LayoutProtected = null;
         }
      }
      
      public function set styleWithBorder(param1:String) : void
      {
         if(this.m_StyleWithBorder != param1)
         {
            this.m_StyleWithBorder = param1;
            this.m_UncommittedStyleWithBorder = true;
            invalidateProperties();
         }
      }
      
      private function layoutDropIndicator(param1:Number = NaN) : void
      {
         var _loc2_:int = 0;
         if(!isNaN(param1))
         {
            this.m_DropOffset = param1;
         }
         if(this.m_UIDropIndicator != null)
         {
            _loc2_ = this.getDropIndex(this.m_DropOffset);
            this.m_UIDropIndicator.x = (this.m_LayoutWidth - this.m_UIDropIndicator.width) / 2;
            this.m_UIDropIndicator.y = this.m_DropOffsetList[_loc2_] - (getStyle("verticalGap") + this.m_UIDropIndicator.height) / 2;
            rawChildren.setChildIndex(this.m_UIDropIndicator as DisplayObject,rawChildren.numChildren - 1);
         }
      }
      
      private function updateOwnStyleName() : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         if(styleName != null && styleName != this.m_StyleWithBorder && styleName != this.m_StyleWithoutBorder)
         {
            return;
         }
         var _loc1_:Boolean = false;
         if(parent != null)
         {
            _loc2_ = parent.getChildIndex(this);
            _loc3_ = parent.numChildren;
            for each(_loc4_ in [-1,1])
            {
               _loc5_ = _loc2_ + _loc4_;
               if(_loc5_ >= 0 && _loc5_ < _loc3_ && parent.getChildAt(_loc5_) is SideBarWidget && parent.getChildAt(_loc5_).visible)
               {
                  _loc1_ = true;
                  break;
               }
            }
         }
         if(_loc1_)
         {
            styleName = this.m_StyleWithBorder;
         }
         else
         {
            styleName = this.m_StyleWithoutBorder;
         }
      }
      
      override protected function measure() : void
      {
         var _loc4_:UIComponent = null;
         super.measure();
         var _loc1_:Number = this.m_UIHeader != null?Number(this.m_UIHeader.getExplicitOrMeasuredWidth()):Number(0);
         var _loc2_:int = numChildren - 1;
         while(_loc2_ >= 0)
         {
            _loc4_ = getChildAt(_loc2_) as UIComponent;
            if(_loc4_ != null)
            {
               _loc1_ = Math.max(_loc1_,_loc4_.getExplicitOrMeasuredWidth());
            }
            _loc2_--;
         }
         _loc1_ = Math.max(_loc1_,DEFAULT_WIDGET_WIDTH);
         var _loc3_:EdgeMetrics = viewMetricsAndPadding;
         measuredMinWidth = measuredWidth = _loc3_.left + _loc1_ + _loc3_.right;
      }
      
      public function set styleWithoutBorder(param1:String) : void
      {
         if(this.m_StyleWithoutBorder != param1)
         {
            this.m_StyleWithoutBorder = param1;
            this.m_UncommittedStyleWithoutBorder = true;
            invalidateProperties();
         }
      }
      
      public function set location(param1:int) : void
      {
         if(this.m_Location != param1)
         {
            this.m_Location = param1;
            this.m_UncommittedLocation = true;
            invalidateProperties();
         }
      }
      
      override public function set visible(param1:Boolean) : void
      {
         super.visible = param1;
         this.m_UncommittedVisible = true;
         invalidateProperties();
      }
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
         if(this.m_UncommittedSideBarSet)
         {
            this.m_LayoutMode = 1;
            this.finishMouseResize();
            if(this.m_UIHeader != null)
            {
               this.m_UIHeader.sideBarSet = this.m_SideBarSet;
            }
            this.resetWidgets();
            this.visible = this.m_SideBarSet != null && this.m_SideBarSet.getSideBar(this.m_Location).visible;
            this.m_UncommittedSideBarSet = false;
         }
         if(this.m_UncommittedLocation)
         {
            this.m_LayoutMode = 1;
            this.finishMouseResize();
            if(this.m_UIHeader != null)
            {
               this.m_UIHeader.location = this.m_Location;
            }
            this.m_UncommittedLocation = false;
         }
         if(this.m_UncommittedOptions)
         {
            this.m_UncommittedOptions = false;
         }
         if(this.m_UncommittedVisible)
         {
            includeInLayout = visible;
            this.updateSiblingStyleNames();
            this.m_UncommittedVisible = false;
         }
         if(this.m_UncommittedStyleWithBorder || this.m_UncommittedStyleWithoutBorder)
         {
            this.updateSiblingStyleNames();
            this.m_UncommittedStyleWithBorder = false;
            this.m_UncommittedStyleWithoutBorder = false;
         }
      }
      
      private function getDropIndex(param1:Number) : int
      {
         var _loc2_:int = this.m_DropOffsetList.length;
         if(this.m_DropOffsetList.length < 2 || param1 <= this.m_DropOffsetList[0])
         {
            return 0;
         }
         if(param1 >= this.m_DropOffsetList[_loc2_ - 1])
         {
            return _loc2_ - 1;
         }
         var _loc3_:Number = 0;
         var _loc4_:Number = 0;
         var _loc5_:Number = 0;
         var _loc6_:int = -1;
         var _loc7_:int = 0;
         while(_loc7_ < _loc2_ - 1)
         {
            _loc3_ = this.m_DropOffsetList[_loc7_];
            _loc4_ = this.m_DropOffsetList[_loc7_ + 1];
            _loc5_ = (_loc3_ + _loc4_) / 2;
            if(_loc3_ <= param1 && param1 < _loc5_)
            {
               _loc6_ = _loc7_;
               break;
            }
            if(_loc5_ <= param1 && param1 < _loc4_)
            {
               _loc6_ = _loc7_ + 1;
               break;
            }
            _loc7_++;
         }
         if(this.m_DropIndicatorSkipIndex > -1 && _loc6_ == this.m_DropIndicatorSkipIndex + 1)
         {
            _loc6_--;
         }
         return _loc6_;
      }
      
      public function get styleWithoutBorder() : String
      {
         return this.m_StyleWithoutBorder;
      }
      
      private function onWidgetMouseResizeInit(param1:MouseEvent) : void
      {
         var _loc3_:Boolean = false;
         var _loc2_:WidgetView = null;
         if(param1 != null && this.m_ResizeWidget == null && (_loc2_ = param1.currentTarget as WidgetView) != null)
         {
            _loc3_ = !DragManager.isDragging && !_loc2_.widgetClosed && _loc2_.widgetResizable && _loc2_.hitTestResizeHandle(param1.stageX,param1.stageY);
            switch(param1.type)
            {
               case MouseEvent.MOUSE_DOWN:
                  if(_loc3_)
                  {
                     this.m_ResizeWidget = _loc2_;
                     this.m_ResizeStartHeight = _loc2_.widgetSuggestedHeight;
                     this.m_ResizeStartPoint.x = param1.stageX;
                     this.m_ResizeStartPoint.y = param1.stageY;
                     this.m_ResizeWidget.removeEventListener(MouseEvent.MOUSE_MOVE,this.onWidgetMouseResizeInit);
                     this.m_ResizeWidget.removeEventListener(MouseEvent.MOUSE_OVER,this.onWidgetMouseResizeInit);
                     this.m_ResizeWidget.removeEventListener(MouseEvent.MOUSE_OUT,this.onWidgetMouseResizeInit);
                     systemManager.addEventListener(MouseEvent.MOUSE_MOVE,this.onWidgetMouseResizeEvent);
                     systemManager.addEventListener(MouseEvent.MOUSE_UP,this.onWidgetMouseResizeEvent);
                     systemManager.addEventListener(SandboxMouseEvent.MOUSE_UP_SOMEWHERE,this.onWidgetMouseResizeEvent);
                     this.updateMouseResizeCursor(true);
                  }
                  break;
               case MouseEvent.MOUSE_MOVE:
               case MouseEvent.MOUSE_OVER:
                  this.updateMouseResizeCursor(_loc3_);
                  break;
               case MouseEvent.MOUSE_OUT:
                  this.updateMouseResizeCursor(false);
            }
         }
      }
      
      public function resetWidgets() : void
      {
         var _loc5_:* = false;
         var _loc6_:WidgetViewWithIndex = null;
         var _loc7_:SideBar = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc1_:Widget = null;
         var _loc2_:WidgetView = null;
         var _loc3_:Vector.<WidgetViewWithIndex> = new Vector.<WidgetViewWithIndex>();
         var _loc4_:int = numChildren - 1;
         while(_loc4_ >= 0)
         {
            _loc1_ = null;
            _loc2_ = removeChildAt(_loc4_) as WidgetView;
            _loc5_ = !(_loc2_ != null && _loc2_.widgetInstance != null && !Widget.s_GetRestorable(_loc2_.widgetInstance.type));
            if(!_loc5_)
            {
               _loc6_ = new WidgetViewWithIndex(_loc2_,_loc4_);
               _loc3_.push(_loc6_);
            }
            else if(_loc2_ != null && _loc5_)
            {
               _loc2_.removeEventListener(MouseEvent.MOUSE_DOWN,this.onWidgetDragInit);
               _loc2_.removeEventListener(MouseEvent.MOUSE_MOVE,this.onWidgetMouseResizeInit);
               _loc2_.removeEventListener(MouseEvent.MOUSE_OVER,this.onWidgetMouseResizeInit);
               _loc2_.removeEventListener(MouseEvent.MOUSE_OUT,this.onWidgetMouseResizeInit);
               _loc2_.removeEventListener(MouseEvent.MOUSE_DOWN,this.onWidgetMouseResizeInit);
               _loc1_ = _loc2_.widgetInstance;
            }
            if(_loc1_ != null && _loc5_)
            {
               _loc1_.releaseViewInstance();
            }
            _loc4_--;
         }
         if(this.m_SideBarSet != null)
         {
            _loc7_ = this.m_SideBarSet.getSideBar(this.m_Location);
            _loc8_ = 0;
            _loc9_ = _loc7_.length;
            while(_loc8_ < _loc9_)
            {
               _loc2_ = _loc7_.getWidgetInstanceAt(_loc8_).acquireViewInstance(true);
               _loc2_.addEventListener(MouseEvent.MOUSE_DOWN,this.onWidgetDragInit);
               _loc2_.addEventListener(MouseEvent.MOUSE_MOVE,this.onWidgetMouseResizeInit);
               _loc2_.addEventListener(MouseEvent.MOUSE_OVER,this.onWidgetMouseResizeInit);
               _loc2_.addEventListener(MouseEvent.MOUSE_OUT,this.onWidgetMouseResizeInit);
               _loc2_.addEventListener(MouseEvent.MOUSE_DOWN,this.onWidgetMouseResizeInit);
               _loc2_.invalidateWidgetInstance();
               addChild(_loc2_);
               _loc8_++;
            }
         }
         _loc4_ = _loc3_.length - 1;
         while(_loc4_ >= 0)
         {
            _loc6_ = _loc3_[_loc4_];
            if(_loc6_.Index >= 0 && _loc6_.Index < numChildren)
            {
               addChildAt(_loc6_.WidgetViewObj,_loc6_.Index);
            }
            else
            {
               addChild(_loc6_.WidgetViewObj);
            }
            this.m_SideBarSet.insertOrphanWidget(_loc6_.WidgetViewObj.widgetInstance,this.m_Location,_loc6_.Index);
            _loc4_--;
         }
         this.widgetSetProtected(null);
      }
      
      private function hasEnoughSpace(param1:IUIComponent) : Boolean
      {
         if(param1 == null)
         {
            return false;
         }
         var _loc2_:Number = param1.measuredMinHeight;
         return contains(param1 as DisplayObject) || !isNaN(this.m_DropAvailableHeight) && !isNaN(_loc2_) && _loc2_ <= this.m_DropAvailableHeight;
      }
      
      override public function get borderMetrics() : EdgeMetrics
      {
         if(mx_internal::border is IBorder)
         {
            return IBorder(mx_internal::border).borderMetrics;
         }
         return super.borderMetrics;
      }
   }
}

import tibia.sidebar.sideBarWidgetClasses.WidgetView;

class WidgetViewWithIndex
{
    
   
   public var Index:int;
   
   public var WidgetViewObj:WidgetView;
   
   function WidgetViewWithIndex(param1:WidgetView, param2:int)
   {
      super();
      this.WidgetViewObj = param1;
      this.Index = param2;
   }
}
