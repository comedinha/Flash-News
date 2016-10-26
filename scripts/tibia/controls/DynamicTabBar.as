package tibia.controls
{
   import mx.core.UIComponent;
   import mx.styles.CSSStyleDeclaration;
   import mx.styles.StyleManager;
   import mx.controls.Button;
   import mx.core.Container;
   import shared.controls.CustomButton;
   import flash.events.MouseEvent;
   import tibia.input.MouseRepeatEvent;
   import tibia.controls.dynamicTabBarClasses.DynamicTab;
   import flash.events.Event;
   import tibia.controls.dynamicTabBarClasses.TabBarEvent;
   import mx.collections.IList;
   import mx.containers.ViewStack;
   import flash.display.DisplayObject;
   import mx.collections.ArrayCollection;
   import mx.core.ClassFactory;
   import mx.events.MenuEvent;
   import mx.core.ScrollPolicy;
   import mx.events.CollectionEvent;
   import mx.events.ChildExistenceChangedEvent;
   import mx.events.IndexChangedEvent;
   import mx.core.DragSource;
   import mx.core.EventPriority;
   import mx.events.SandboxMouseEvent;
   import mx.managers.DragManager;
   import flash.utils.Timer;
   import tibia.controls.dynamicTabBarClasses.TabBarMenu;
   import mx.events.DragEvent;
   import mx.events.PropertyChangeEvent;
   import mx.events.CollectionEventKind;
   import mx.controls.Menu;
   import flash.events.TimerEvent;
   import mx.core.mx_internal;
   
   public class DynamicTabBar extends UIComponent
   {
      
      public static const DROP_DOWN_OFF:int = 1;
      
      public static const CLOSE_NEVER:int = 0;
      
      public static const CLOSE_SELECTED:int = 2;
      
      public static const DROP_DOWN_ON:int = 2;
      
      public static const CLOSE_ALWAYS:int = 1;
      
      public static const CLOSE_ROLLOVER:int = 3;
      
      public static const DROP_DOWN_AUTO:int = 0;
      
      {
         s_InitializeStyle();
      }
      
      protected var m_UIDropDownButton:Button = null;
      
      protected var m_ScrollPolicy:String = "auto";
      
      private var m_UncommittedScrollPolicy:Boolean = false;
      
      private var m_UncommittedDropDownPolicy:Boolean = false;
      
      protected var m_TabResize:Boolean = false;
      
      protected var m_ScrollPosition:int = 0;
      
      private var m_UIConstructed:Boolean = false;
      
      protected var m_TabMinWidth:Number = NaN;
      
      protected var m_ClosePolicy:int = 2;
      
      private var m_UncommittedLabelFunction:Boolean = false;
      
      private var m_UncommittedLabelField:Boolean = false;
      
      protected var m_UILeftButton:Button = null;
      
      private var m_UncommittedDataProvider:Boolean = false;
      
      private var m_UncommittedSelectedIndex:Boolean = false;
      
      protected var m_DataProvider:Object = null;
      
      private var m_UncommittedTabMinWidth:Boolean = false;
      
      private var m_UncommittedClosePolicy:Boolean = false;
      
      protected var m_DragEnabled:Boolean = false;
      
      protected var m_LabelFunction:Function = null;
      
      protected var m_DragAutoScrollTimer:Timer = null;
      
      protected var m_SelectedIndex:int = -1;
      
      private var m_NavItemFactory:ClassFactory = null;
      
      private var m_UncommittedScrollPosition:Boolean = false;
      
      private var m_UncommittedToolTipField:Boolean = false;
      
      protected var m_ToolTipField:String = "toolTip";
      
      protected var m_TabMaxWidth:Number = NaN;
      
      protected var m_IconField:String = "icon";
      
      private var m_UncommittedTabResize:Boolean = false;
      
      private var m_UncommittedDragEnabled:Boolean = false;
      
      protected var m_LabelField:String = "label";
      
      protected var m_UIInternalChildren:int = 0;
      
      private var m_UncommittedTabMaxWidth:Boolean = false;
      
      protected var m_DragAutoScrollDirection:int = -1;
      
      private var m_UncommittedNavItemFactory:Boolean = false;
      
      private var m_FirstVisibleIndex:int = 0;
      
      protected var m_UIDropIndicator:DisplayObject = null;
      
      protected var m_UIRightButton:Button = null;
      
      private var m_LastVisibleIndex:int = 0;
      
      protected var m_DropDownPolicy:int = 0;
      
      protected var m_UIDropDownMenu:Menu = null;
      
      private var m_UncommittedIconField:Boolean = false;
      
      public function DynamicTabBar()
      {
         super();
         addEventListener(DragEvent.DRAG_DROP,this.onNavItemDragEvent);
         addEventListener(DragEvent.DRAG_ENTER,this.onNavItemDragEvent);
         addEventListener(DragEvent.DRAG_EXIT,this.onNavItemDragEvent);
         addEventListener(DragEvent.DRAG_OVER,this.onNavItemDragEvent);
         addEventListener(MouseEvent.MOUSE_WHEEL,this.onScrollWheel);
         this.navItemFactory = new ClassFactory(DynamicTab);
         this.m_DragAutoScrollTimer = new Timer(500);
         this.m_DragAutoScrollTimer.addEventListener(TimerEvent.TIMER,this.onScrollDrag);
         this.m_DragAutoScrollDirection = 0;
      }
      
      private static function s_InitializeStyle() : void
      {
         var Selector:String = ".defaultScrollLeftButtonStyle";
         var Decl:CSSStyleDeclaration = StyleManager.getStyleDeclaration(Selector);
         if(Decl == null)
         {
            Decl = new CSSStyleDeclaration();
         }
         Decl.defaultFactory = function():void
         {
            this.disabledSkin = null;
            this.downSkin = null;
            this.overSkin = null;
            this.upSkin = null;
         };
         StyleManager.setStyleDeclaration(Selector,Decl,false);
         Selector = ".defaultScrollRightButtonStyle";
         Decl = StyleManager.getStyleDeclaration(Selector);
         if(Decl == null)
         {
            Decl = new CSSStyleDeclaration();
         }
         Decl.defaultFactory = function():void
         {
            this.disabledSkin = null;
            this.downSkin = null;
            this.overSkin = null;
            this.upSkin = null;
         };
         StyleManager.setStyleDeclaration(Selector,Decl,false);
         Selector = ".defaultDropDownButtonStyle";
         Decl = StyleManager.getStyleDeclaration(Selector);
         if(Decl == null)
         {
            Decl = new CSSStyleDeclaration();
         }
         Decl.defaultFactory = function():void
         {
            this.disabledSkin = null;
            this.downSkin = null;
            this.overSkin = null;
            this.upSkin = null;
         };
         StyleManager.setStyleDeclaration(Selector,Decl,false);
         Selector = "DynamicTabBar";
         Decl = StyleManager.getStyleDeclaration(Selector);
         if(Decl == null)
         {
            Decl = new CSSStyleDeclaration();
         }
         Decl.defaultFactory = function():void
         {
            this.horizontalGap = 0;
            this.paddingBottom = 0;
            this.paddingLeft = 2;
            this.paddingRight = 2;
            this.paddingTop = 0;
            this.dropIndicatorSkin = null;
            this.scrollLeftButtonStyle = "defaultScrollLeftButtonStyle";
            this.scrollRightButtonStyle = "defaultScrollRightButtonStyle";
            this.dropDownButtonStyle = "defaultDropDownButtonStyle";
         };
         StyleManager.setStyleDeclaration(Selector,Decl,true);
      }
      
      public function get iconField() : String
      {
         return this.m_IconField;
      }
      
      public function set iconField(param1:String) : void
      {
         if(this.m_IconField != param1)
         {
            this.m_IconField = param1;
            this.m_UncommittedIconField = true;
            invalidateProperties();
         }
      }
      
      private function itemToToolTip(param1:Object) : String
      {
         if(param1 is Container)
         {
            return Container(param1).toolTip;
         }
         if(param1 != null && this.m_ToolTipField != null && param1.hasOwnProperty(this.m_ToolTipField))
         {
            return String(param1[this.m_ToolTipField]);
         }
         return null;
      }
      
      public function get scrollPosition() : int
      {
         return this.m_ScrollPosition;
      }
      
      public function set tabMaxWidth(param1:Number) : void
      {
         if(this.m_TabMaxWidth != param1)
         {
            this.m_TabMaxWidth = param1;
            this.m_UncommittedTabMaxWidth = true;
            invalidateDisplayList();
            invalidateProperties();
            invalidateSize();
         }
      }
      
      override protected function createChildren() : void
      {
         if(!this.m_UIConstructed)
         {
            super.createChildren();
            this.m_UILeftButton = new CustomButton();
            this.m_UILeftButton.styleName = getStyle("scrollLeftButtonStyle");
            this.m_UILeftButton.addEventListener(MouseEvent.MOUSE_DOWN,this.onScrollButtonDown);
            this.m_UILeftButton.addEventListener(MouseEvent.CLICK,this.onScrollButtonClick);
            this.m_UILeftButton.addEventListener(MouseRepeatEvent.REPEAT_MOUSE_DOWN,this.onScrollButtonClick);
            this.m_UILeftButton.setStyle("repeatDelay",500);
            addChild(this.m_UILeftButton);
            this.m_UIInternalChildren++;
            this.m_UIRightButton = new CustomButton();
            this.m_UIRightButton.styleName = getStyle("scrollRightButtonStyle");
            this.m_UIRightButton.addEventListener(MouseEvent.MOUSE_DOWN,this.onScrollButtonDown);
            this.m_UIRightButton.addEventListener(MouseEvent.CLICK,this.onScrollButtonClick);
            this.m_UIRightButton.addEventListener(MouseRepeatEvent.REPEAT_MOUSE_DOWN,this.onScrollButtonClick);
            this.m_UIRightButton.setStyle("repeatDelay",500);
            addChild(this.m_UIRightButton);
            this.m_UIInternalChildren++;
            this.m_UIDropDownButton = new CustomButton();
            this.m_UIDropDownButton.styleName = getStyle("dropDownButtonStyle");
            this.m_UIDropDownButton.addEventListener(MouseEvent.CLICK,this.onDropDownButton);
            addChild(this.m_UIDropDownButton);
            this.m_UIInternalChildren++;
            this.createDropIndicator();
            this.m_UIConstructed = true;
         }
      }
      
      public function set scrollPosition(param1:int) : void
      {
         param1 = Math.max(0,Math.min(param1,this.getDataProviderLength() - 1));
         if(this.m_ScrollPosition != param1)
         {
            this.m_ScrollPosition = param1;
            this.m_UncommittedScrollPosition = true;
            invalidateDisplayList();
            invalidateProperties();
         }
      }
      
      protected function onScrollWheel(param1:MouseEvent) : void
      {
         this.scrollPosition = this.scrollPosition + -param1.delta / Math.abs(param1.delta) * (!!param1.shiftKey?10:1);
      }
      
      protected function createNavItem(param1:Object) : DynamicTab
      {
         var _loc2_:DynamicTab = DynamicTab(this.m_NavItemFactory.newInstance());
         _loc2_.closePolicy = this.m_ClosePolicy;
         _loc2_.enabled = this.itemToEnabled(param1);
         _loc2_.focusEnabled = false;
         _loc2_.label = this.itemToLabel(param1);
         _loc2_.styleName = getStyle("navItemStyle");
         _loc2_.toggle = true;
         _loc2_.toolTip = this.itemToToolTip(param1);
         _loc2_.addEventListener(Event.CLOSE,this.onNavItemClose);
         _loc2_.addEventListener(MouseEvent.MOUSE_DOWN,this.onNavItemSelect);
         _loc2_.addEventListener(MouseEvent.MOUSE_DOWN,this.onNavItemDragInit);
         _loc2_.setStyle("icon",this.itemToIcon(param1));
         addChildAt(_loc2_,numChildren - this.m_UIInternalChildren);
         return _loc2_;
      }
      
      protected function onNavItemClose(param1:Event) : void
      {
         var _loc2_:DynamicTab = null;
         var _loc3_:int = 0;
         var _loc4_:TabBarEvent = null;
         var _loc5_:int = 0;
         if(param1 != null)
         {
            _loc2_ = DynamicTab(param1.currentTarget);
            _loc3_ = getChildIndex(_loc2_);
            _loc4_ = new TabBarEvent(TabBarEvent.CLOSE);
            _loc4_.index = _loc3_;
            dispatchEvent(_loc4_);
            if(!_loc4_.cancelable || !_loc4_.isDefaultPrevented())
            {
               _loc5_ = -1;
               if(_loc3_ < this.m_SelectedIndex)
               {
                  _loc5_ = this.m_SelectedIndex - 1;
               }
               else if(_loc3_ == this.m_SelectedIndex)
               {
                  _loc5_ = Math.min(this.m_SelectedIndex,this.getDataProviderLength() - 2);
               }
               else
               {
                  _loc5_ = this.m_SelectedIndex;
               }
               if(this.m_DataProvider is IList)
               {
                  IList(this.m_DataProvider).removeItemAt(_loc3_);
               }
               else if(this.m_DataProvider is ViewStack)
               {
                  ViewStack(this.m_DataProvider).removeChildAt(_loc3_);
               }
               this.selectedIndex = _loc5_;
            }
            else
            {
               param1.preventDefault();
            }
         }
      }
      
      protected function onStackSelectionChange(param1:Event) : void
      {
         if(param1 != null)
         {
            this.selectedIndex = ViewStack(this.m_DataProvider).selectedIndex;
         }
      }
      
      protected function onStackChildChange(param1:Event) : void
      {
         var _loc2_:Container = null;
         var _loc3_:int = 0;
         var _loc4_:DynamicTab = null;
         if(param1 != null)
         {
            _loc2_ = Container(param1.target);
            _loc3_ = ViewStack(this.m_DataProvider).getChildIndex(_loc2_);
            _loc4_ = DynamicTab(getChildAt(_loc3_));
            switch(param1.type)
            {
               case "enabledChanged":
                  _loc4_.enabled = _loc2_.enabled;
                  break;
               case "iconChanged":
                  _loc4_.setStyle("icon",_loc2_.icon);
                  break;
               case "labelChanged":
                  _loc4_.label = _loc2_.label;
                  break;
               case "toolTipChanged":
                  _loc4_.toolTip = _loc2_.toolTip;
            }
            invalidateDisplayList();
            invalidateSize();
         }
      }
      
      public function get tabMinWidth() : Number
      {
         return this.m_TabMinWidth;
      }
      
      public function get closePolicy() : int
      {
         return this.m_ClosePolicy;
      }
      
      private function createDropIndicator() : void
      {
         if(this.m_UIDropIndicator != null && contains(this.m_UIDropIndicator))
         {
            removeChild(this.m_UIDropIndicator);
            this.m_UIInternalChildren--;
         }
         this.m_UIDropIndicator = null;
         var _loc1_:Class = getStyle("dropIndicatorSkin") as Class;
         if(_loc1_ != null)
         {
            this.m_UIDropIndicator = DisplayObject(new _loc1_());
            this.m_UIDropIndicator.visible = false;
            addChild(this.m_UIDropIndicator);
            this.m_UIInternalChildren++;
         }
      }
      
      protected function onScrollButtonClick(param1:MouseEvent) : void
      {
         if(param1.currentTarget == this.m_UILeftButton)
         {
            this.scrollPosition = this.scrollPosition - (!!param1.shiftKey?10:1);
         }
         else if(param1.currentTarget == this.m_UIRightButton)
         {
            this.scrollPosition = this.scrollPosition + (!!param1.shiftKey?10:1);
         }
      }
      
      protected function createDropDownMenu() : IList
      {
         var _loc4_:DynamicTab = null;
         var _loc1_:IList = new ArrayCollection();
         var _loc2_:int = 0;
         var _loc3_:int = this.getDataProviderLength();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = DynamicTab(getChildAt(_loc2_));
            _loc1_.addItem({"label":_loc4_.label});
            _loc2_++;
         }
         return _loc1_;
      }
      
      protected function get navItemFactory() : ClassFactory
      {
         return this.m_NavItemFactory;
      }
      
      public function set tabResize(param1:Boolean) : void
      {
         if(this.m_TabResize != param1)
         {
            this.m_TabResize = param1;
            this.m_UncommittedTabResize = true;
            invalidateDisplayList();
            invalidateProperties();
            invalidateSize();
         }
      }
      
      private function destroyDropDownMenu() : void
      {
         if(this.m_UIDropDownMenu != null)
         {
            this.m_UIDropDownMenu.hide();
            this.m_UIDropDownMenu.removeEventListener(MenuEvent.ITEM_CLICK,this.onDropDownMenu);
            this.m_UIDropDownMenu = null;
         }
      }
      
      override protected function measure() : void
      {
         var _loc8_:DynamicTab = null;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         super.measure();
         var _loc1_:Number = getStyle("paddingLeft") + getStyle("paddingRight");
         var _loc2_:Number = 0;
         var _loc3_:Number = 0;
         var _loc4_:Number = 0;
         var _loc5_:Number = 0;
         if(this.m_ScrollPolicy != ScrollPolicy.OFF)
         {
            _loc1_ = _loc1_ + (this.m_UILeftButton.getExplicitOrMeasuredWidth() + this.m_UIRightButton.getExplicitOrMeasuredWidth());
            _loc2_ = Math.max(_loc2_,this.m_UILeftButton.getExplicitOrMeasuredHeight(),this.m_UIRightButton.getExplicitOrMeasuredHeight());
         }
         if(this.m_DropDownPolicy != DROP_DOWN_OFF)
         {
            _loc1_ = _loc1_ + this.m_UIDropDownButton.getExplicitOrMeasuredWidth();
            _loc2_ = Math.max(_loc2_,this.m_UIDropDownButton.getExplicitOrMeasuredHeight());
         }
         var _loc6_:int = 0;
         var _loc7_:int = numChildren - this.m_UIInternalChildren;
         _loc6_ = 0;
         while(_loc6_ < _loc7_)
         {
            _loc8_ = DynamicTab(getChildAt(_loc6_));
            _loc9_ = 0;
            _loc10_ = _loc8_.getExplicitOrMeasuredWidth();
            if(this.m_TabResize && !isNaN(this.m_TabMinWidth))
            {
               _loc9_ = this.m_TabMinWidth;
            }
            else if(!isNaN(_loc8_.minWidth))
            {
               _loc9_ = _loc8_.minWidth;
            }
            else
            {
               _loc9_ = _loc10_;
            }
            if(this.m_TabResize && !isNaN(this.m_TabMaxWidth))
            {
               _loc10_ = Math.min(_loc10_,this.m_TabMaxWidth);
            }
            _loc4_ = Math.max(_loc4_,_loc9_);
            _loc3_ = _loc3_ + Math.max(_loc9_,_loc10_);
            _loc5_ = Math.max(_loc5_,_loc8_.getExplicitOrMeasuredHeight());
            _loc6_++;
         }
         if(_loc7_ > 1)
         {
            _loc3_ = _loc3_ + (_loc7_ - 1) * getStyle("horizontalGap");
         }
         measuredWidth = _loc1_ + _loc3_;
         measuredMinWidth = _loc1_ + _loc4_;
         measuredHeight = measuredMinHeight = Math.max(_loc2_,_loc5_) + getStyle("paddingTop") + getStyle("paddingBottom");
      }
      
      public function get scrollPolicy() : String
      {
         return this.m_ScrollPolicy;
      }
      
      private function itemToEnabled(param1:Object) : Boolean
      {
         if(param1 is Container)
         {
            return Container(param1).enabled;
         }
         return true;
      }
      
      public function get labelField() : String
      {
         return this.m_LabelField;
      }
      
      public function set dataProvider(param1:Object) : void
      {
         var _loc2_:IList = null;
         var _loc3_:ViewStack = null;
         var _loc4_:Container = null;
         var _loc5_:int = 0;
         if(this.m_DataProvider != param1)
         {
            _loc2_ = null;
            _loc3_ = null;
            _loc4_ = null;
            _loc5_ = 0;
            if(this.m_DataProvider is IList)
            {
               _loc2_ = IList(this.m_DataProvider);
               _loc2_.removeEventListener(CollectionEvent.COLLECTION_CHANGE,this.onIListChange);
            }
            else if(this.m_DataProvider is ViewStack)
            {
               _loc3_ = ViewStack(this.m_DataProvider);
               _loc3_.removeEventListener(ChildExistenceChangedEvent.CHILD_ADD,this.onStackChange);
               _loc3_.removeEventListener(ChildExistenceChangedEvent.CHILD_REMOVE,this.onStackChange);
               _loc3_.removeEventListener(Event.CHANGE,this.onStackSelectionChange);
               _loc3_.removeEventListener(IndexChangedEvent.CHILD_INDEX_CHANGE,this.onStackChange);
               _loc5_ = _loc3_.numChildren - 1;
               while(_loc5_ >= 0)
               {
                  _loc4_ = Container(_loc3_.getChildAt(_loc5_));
                  _loc4_.removeEventListener("enabledChanged",this.onStackChildChange);
                  _loc4_.removeEventListener("iconChanged",this.onStackChildChange);
                  _loc4_.removeEventListener("labelChanged",this.onStackChildChange);
                  _loc4_.removeEventListener("toolTipChanged",this.onStackChildChange);
                  _loc5_--;
               }
            }
            if(param1 == null)
            {
               this.m_DataProvider = null;
            }
            else if(param1 is Array)
            {
               this.m_DataProvider = new ArrayCollection(param1 as Array);
            }
            else if(param1 is IList)
            {
               this.m_DataProvider = param1;
            }
            else if(param1 is ViewStack)
            {
               this.m_DataProvider = param1;
            }
            else
            {
               throw new ArgumentError("DynamicTabBar.set dataProvider: Invalid data provider.");
            }
            if(this.m_DataProvider is IList)
            {
               _loc2_ = IList(this.m_DataProvider);
               _loc2_.addEventListener(CollectionEvent.COLLECTION_CHANGE,this.onIListChange);
            }
            else if(this.m_DataProvider is ViewStack)
            {
               _loc3_ = ViewStack(this.m_DataProvider);
               _loc3_.addEventListener(ChildExistenceChangedEvent.CHILD_ADD,this.onStackChange);
               _loc3_.addEventListener(ChildExistenceChangedEvent.CHILD_REMOVE,this.onStackChange);
               _loc3_.addEventListener(Event.CHANGE,this.onStackSelectionChange);
               _loc3_.addEventListener(IndexChangedEvent.CHILD_INDEX_CHANGE,this.onStackChange);
               _loc5_ = _loc3_.numChildren - 1;
               while(_loc5_ >= 0)
               {
                  _loc4_ = Container(_loc3_.getChildAt(_loc5_));
                  _loc4_.addEventListener("enabledChanged",this.onStackChildChange);
                  _loc4_.addEventListener("iconChanged",this.onStackChildChange);
                  _loc4_.addEventListener("labelChanged",this.onStackChildChange);
                  _loc4_.addEventListener("toolTipChanged",this.onStackChildChange);
                  _loc5_--;
               }
            }
            this.m_UncommittedDataProvider = true;
            invalidateProperties();
         }
      }
      
      public function get tabMaxWidth() : Number
      {
         return this.m_TabMaxWidth;
      }
      
      public function get dragEnabled() : Boolean
      {
         return this.m_DragEnabled;
      }
      
      protected function getDataProviderLength() : int
      {
         if(this.m_DataProvider is IList)
         {
            return IList(this.m_DataProvider).length;
         }
         if(this.m_DataProvider is ViewStack)
         {
            return ViewStack(this.m_DataProvider).numChildren;
         }
         return 0;
      }
      
      protected function selectNavItems() : void
      {
         var _loc1_:int = numChildren - this.m_UIInternalChildren - 1;
         while(_loc1_ >= 0)
         {
            DynamicTab(getChildAt(_loc1_)).selected = _loc1_ == this.m_SelectedIndex;
            _loc1_--;
         }
      }
      
      protected function onNavItemDragInit(param1:Event) : void
      {
         var _loc2_:DynamicTab = null;
         var _loc3_:int = 0;
         var _loc4_:DragSource = null;
         if(param1 != null && this.m_DragEnabled)
         {
            _loc2_ = DynamicTab(param1.currentTarget);
            _loc3_ = getChildIndex(_loc2_);
            switch(param1.type)
            {
               case MouseEvent.MOUSE_DOWN:
                  _loc2_.addEventListener(MouseEvent.MOUSE_MOVE,this.onNavItemDragInit,false,EventPriority.DEFAULT,true);
                  _loc2_.addEventListener(MouseEvent.MOUSE_UP,this.onNavItemDragInit,false,EventPriority.DEFAULT,true);
                  _loc2_.addEventListener(SandboxMouseEvent.MOUSE_UP_SOMEWHERE,this.onNavItemDragInit,false,EventPriority.DEFAULT,true);
                  break;
               case MouseEvent.MOUSE_MOVE:
                  _loc4_ = new DragSource();
                  _loc4_.addData("dynamicTab","dragType");
                  _loc4_.addData(this,"dragTabBar");
                  _loc4_.addData(_loc3_,"dragTabIndex");
                  DragManager.doDrag(_loc2_,_loc4_,param1 as MouseEvent);
               case MouseEvent.MOUSE_UP:
                  _loc2_.removeEventListener(MouseEvent.MOUSE_MOVE,this.onNavItemDragInit);
                  _loc2_.removeEventListener(MouseEvent.MOUSE_UP,this.onNavItemDragInit);
                  _loc2_.removeEventListener(SandboxMouseEvent.MOUSE_UP_SOMEWHERE,this.onNavItemDragInit);
            }
         }
      }
      
      protected function destroyNavItem(param1:int) : DynamicTab
      {
         var _loc2_:DynamicTab = null;
         if(param1 >= 0 && param1 < numChildren - this.m_UIInternalChildren)
         {
            _loc2_ = DynamicTab(removeChildAt(param1));
            _loc2_.removeEventListener(Event.CLOSE,this.onNavItemClose);
            _loc2_.removeEventListener(MouseEvent.MOUSE_DOWN,this.onNavItemSelect);
            _loc2_.removeEventListener(MouseEvent.MOUSE_DOWN,this.onNavItemDragInit);
         }
         return _loc2_;
      }
      
      public function set dropDownPolicy(param1:int) : void
      {
         if(this.m_DropDownPolicy != param1)
         {
            this.m_DropDownPolicy = param1;
            this.m_UncommittedDropDownPolicy = true;
            invalidateDisplayList();
            invalidateProperties();
            invalidateSize();
         }
      }
      
      private function itemToIcon(param1:Object) : Class
      {
         if(param1 is Container)
         {
            return Container(param1).icon;
         }
         if(param1 != null && this.m_IconField != null && param1.hasOwnProperty(this.m_IconField))
         {
            return param1[this.m_IconField] as Class;
         }
         return null;
      }
      
      protected function onDropDownButton(param1:MouseEvent) : void
      {
         if(param1 != null)
         {
            this.destroyDropDownMenu();
            this.m_UIDropDownMenu = TabBarMenu.s_CreateMenu(null,this.createDropDownMenu(),true);
            this.m_UIDropDownMenu.selectedIndex = this.m_SelectedIndex;
            this.m_UIDropDownMenu.addEventListener(MenuEvent.ITEM_CLICK,this.onDropDownMenu);
            this.m_UIDropDownMenu.show(param1.stageX,param1.stageY);
         }
      }
      
      public function set tabMinWidth(param1:Number) : void
      {
         if(this.m_TabMinWidth != param1)
         {
            this.m_TabMinWidth = param1;
            this.m_UncommittedTabMinWidth = true;
            invalidateDisplayList();
            invalidateProperties();
            invalidateSize();
         }
      }
      
      public function set closePolicy(param1:int) : void
      {
         if(this.m_ClosePolicy != param1)
         {
            this.m_ClosePolicy = param1;
            this.m_UncommittedClosePolicy = true;
            invalidateDisplayList();
            invalidateProperties();
            invalidateSize();
         }
      }
      
      protected function onNavItemDragEvent(param1:DragEvent) : void
      {
         var _loc2_:DragSource = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:TabBarEvent = null;
         var _loc6_:IList = null;
         var _loc7_:ViewStack = null;
         if(param1 != null && this.m_DragEnabled)
         {
            _loc2_ = param1.dragSource;
            if(!_loc2_.hasFormat("dragType") || _loc2_.dataForFormat("dragType") != "dynamicTab")
            {
               return;
            }
            if(!_loc2_.hasFormat("dragTabBar") || _loc2_.dataForFormat("dragTabBar") != this)
            {
               return;
            }
            if(!_loc2_.hasFormat("dragTabIndex"))
            {
               return;
            }
            _loc3_ = int(_loc2_.dataForFormat("dragTabIndex"));
            _loc4_ = this.getDropIndex(param1.localX,param1.localY);
            switch(param1.type)
            {
               case DragEvent.DRAG_DROP:
                  if(_loc3_ < _loc4_)
                  {
                     _loc4_--;
                  }
                  if(_loc3_ != _loc4_)
                  {
                     _loc5_ = new TabBarEvent(TabBarEvent.DROP);
                     _loc5_.oldIndex = _loc3_;
                     _loc5_.index = _loc4_;
                     dispatchEvent(_loc5_);
                     if(!_loc5_.cancelable || !_loc5_.isDefaultPrevented())
                     {
                        if(this.m_DataProvider is IList)
                        {
                           _loc6_ = IList(this.m_DataProvider);
                           _loc6_.addItemAt(_loc6_.removeItemAt(_loc3_),_loc4_);
                        }
                        else if(this.m_DataProvider is ViewStack)
                        {
                           _loc7_ = ViewStack(this.m_DataProvider);
                           _loc7_.addChildAt(_loc7_.removeChildAt(_loc3_),_loc4_);
                        }
                        this.selectedIndex = _loc4_;
                     }
                  }
               case DragEvent.DRAG_EXIT:
                  this.m_DragAutoScrollTimer.stop();
                  this.m_DragAutoScrollDirection = 0;
                  this.layoutDropIndicator(-1);
                  break;
               case DragEvent.DRAG_ENTER:
                  DragManager.acceptDragDrop(this);
               case DragEvent.DRAG_OVER:
                  if(this.m_UILeftButton.hitTestPoint(param1.stageX,param1.stageY))
                  {
                     this.m_DragAutoScrollDirection = -1;
                  }
                  else if(this.m_UIRightButton.hitTestPoint(param1.stageX,param1.stageY))
                  {
                     this.m_DragAutoScrollDirection = 1;
                  }
                  else
                  {
                     this.m_DragAutoScrollDirection = 0;
                  }
                  if(this.m_DragAutoScrollDirection != 0 && !this.m_DragAutoScrollTimer.running)
                  {
                     this.m_DragAutoScrollTimer.start();
                  }
                  this.layoutDropIndicator(_loc4_);
            }
         }
      }
      
      protected function getFirstVisibleIndex() : int
      {
         return this.m_ScrollPosition;
      }
      
      protected function onScrollButtonDown(param1:MouseEvent) : void
      {
         if(param1 is MouseRepeatEvent)
         {
            MouseRepeatEvent(param1).repeatEnabled = true;
         }
      }
      
      protected function rebuildNavItems() : void
      {
         var _loc1_:int = 0;
         var _loc3_:IList = null;
         var _loc4_:ViewStack = null;
         this.m_FirstVisibleIndex = 0;
         this.m_LastVisibleIndex = 0;
         _loc1_ = numChildren - this.m_UIInternalChildren - 1;
         while(_loc1_ >= 0)
         {
            this.destroyNavItem(_loc1_);
            _loc1_--;
         }
         _loc1_ = 0;
         var _loc2_:int = 0;
         if(this.m_DataProvider is IList)
         {
            _loc3_ = IList(this.m_DataProvider);
            _loc1_ = 0;
            _loc2_ = _loc3_.length;
            while(_loc1_ < _loc2_)
            {
               this.createNavItem(_loc3_.getItemAt(_loc1_));
               _loc1_++;
            }
         }
         else if(this.m_DataProvider is ViewStack)
         {
            _loc4_ = ViewStack(this.m_DataProvider);
            _loc1_ = 0;
            _loc2_ < _loc4_.numChildren;
            while(_loc1_ < _loc2_)
            {
               this.createNavItem(_loc4_.getChildAt(_loc1_));
               _loc1_++;
            }
         }
         this.selectNavItems();
      }
      
      protected function set navItemFactory(param1:ClassFactory) : void
      {
         if(this.m_NavItemFactory != param1)
         {
            this.m_NavItemFactory = param1;
            this.m_UncommittedNavItemFactory = true;
            invalidateDisplayList();
            invalidateSize();
            invalidateProperties();
         }
      }
      
      public function get tabResize() : Boolean
      {
         return this.m_TabResize;
      }
      
      protected function getLastVisibleIndex() : int
      {
         return this.m_LastVisibleIndex;
      }
      
      private function itemToLabel(param1:Object) : String
      {
         if(param1 is Container)
         {
            return Container(param1).label;
         }
         if(param1 != null && this.m_LabelFunction != null)
         {
            return String(this.m_LabelFunction(param1));
         }
         if(param1 != null && this.m_LabelField != null && param1.hasOwnProperty(this.m_LabelField))
         {
            return String(param1[this.m_LabelField]);
         }
         return null;
      }
      
      protected function onDropDownMenu(param1:MenuEvent) : void
      {
         if(param1 != null)
         {
            this.destroyDropDownMenu();
            this.selectedIndex = param1.index;
         }
      }
      
      private function getDropIndex(param1:Number, param2:Number) : int
      {
         var _loc3_:int = this.getFirstVisibleIndex();
         var _loc4_:int = this.getLastVisibleIndex();
         if(_loc3_ >= _loc4_)
         {
            return -1;
         }
         _loc4_--;
         var _loc5_:int = 0;
         var _loc6_:DynamicTab = null;
         while(_loc3_ <= _loc4_)
         {
            _loc5_ = (_loc3_ + _loc4_) / 2;
            _loc6_ = DynamicTab(getChildAt(_loc5_));
            if(param1 < _loc6_.x)
            {
               _loc4_ = _loc5_ - 1;
            }
            else
            {
               if(param1 < _loc6_.x + _loc6_.width / 2)
               {
                  return _loc5_;
               }
               if(param1 < _loc6_.x + _loc6_.width)
               {
                  return _loc5_ + 1;
               }
               _loc3_ = _loc5_ + 1;
            }
         }
         if(param1 < _loc6_.x + _loc6_.width / 2)
         {
            return _loc5_;
         }
         return _loc5_ + 1;
      }
      
      public function get dataProvider() : Object
      {
         return this.m_DataProvider;
      }
      
      public function get dropDownPolicy() : int
      {
         return this.m_DropDownPolicy;
      }
      
      public function set toolTipField(param1:String) : void
      {
         if(this.m_ToolTipField != param1)
         {
            this.m_ToolTipField = param1;
            this.m_UncommittedToolTipField = true;
            invalidateProperties();
         }
      }
      
      override public function styleChanged(param1:String) : void
      {
         super.styleChanged(param1);
         switch(param1)
         {
            case "dropIndicatorSkin":
               this.createDropIndicator();
               break;
            case "scrollLeftButtonStyle":
               if(this.m_UILeftButton != null)
               {
                  this.m_UILeftButton.styleName = getStyle("scrollLeftButtonStyle");
               }
               invalidateDisplayList();
               invalidateSize();
               break;
            case "scrollRightButtonStyle":
               if(this.m_UIRightButton != null)
               {
                  this.m_UIRightButton.styleName = getStyle("scrollRightButtonStyle");
               }
               invalidateDisplayList();
               invalidateSize();
               break;
            case "dropDownButtonStyle":
               if(this.m_UIDropDownButton != null)
               {
                  this.m_UIDropDownButton.styleName = getStyle("dropDownButtonStyle");
               }
               invalidateDisplayList();
               invalidateSize();
         }
      }
      
      public function set scrollPolicy(param1:String) : void
      {
         if(this.m_ScrollPolicy != param1)
         {
            this.m_ScrollPolicy = param1;
            this.m_UncommittedScrollPolicy = true;
            invalidateDisplayList();
            invalidateProperties();
            invalidateSize();
         }
      }
      
      override protected function commitProperties() : void
      {
         var _loc1_:int = 0;
         super.commitProperties();
         if(this.m_UncommittedDataProvider)
         {
            this.selectedIndex = this.m_SelectedIndex;
            this.scrollPosition = this.m_ScrollPosition;
            this.rebuildNavItems();
            this.m_UncommittedDataProvider = false;
         }
         if(this.m_UncommittedIconField)
         {
            this.rebuildNavItems();
            this.m_UncommittedIconField = false;
         }
         if(this.m_UncommittedLabelField)
         {
            this.rebuildNavItems();
            this.m_UncommittedLabelField = false;
         }
         if(this.m_UncommittedLabelFunction)
         {
            this.rebuildNavItems();
            this.m_UncommittedLabelField = false;
         }
         if(this.m_UncommittedToolTipField)
         {
            this.rebuildNavItems();
            this.m_UncommittedToolTipField = false;
         }
         if(this.m_UncommittedClosePolicy)
         {
            _loc1_ = this.getDataProviderLength() - 1;
            while(_loc1_ >= 0)
            {
               DynamicTab(getChildAt(_loc1_)).closePolicy = this.m_ClosePolicy;
               _loc1_--;
            }
            this.m_UncommittedClosePolicy = false;
         }
         if(this.m_UncommittedDragEnabled)
         {
            this.m_UncommittedDragEnabled = false;
         }
         if(this.m_UncommittedSelectedIndex)
         {
            this.selectNavItems();
            this.m_UncommittedSelectedIndex = false;
         }
         if(this.m_UncommittedScrollPolicy)
         {
            if(this.m_ScrollPolicy == ScrollPolicy.OFF)
            {
               this.scrollPosition = 0;
            }
            this.m_UncommittedScrollPolicy = false;
         }
         if(this.m_UncommittedScrollPosition)
         {
            this.m_UncommittedScrollPosition = false;
         }
         if(this.m_UncommittedTabResize)
         {
            this.m_UncommittedTabResize = false;
         }
         if(this.m_UncommittedTabMinWidth)
         {
            this.m_UncommittedTabMinWidth = false;
         }
         if(this.m_UncommittedTabMaxWidth)
         {
            this.m_UncommittedTabMaxWidth = false;
         }
         if(this.m_UncommittedDropDownPolicy)
         {
            this.m_UncommittedDropDownPolicy = false;
         }
         if(this.m_UncommittedNavItemFactory)
         {
            this.rebuildNavItems();
            this.m_UncommittedNavItemFactory = false;
         }
      }
      
      public function set labelField(param1:String) : void
      {
         if(this.m_LabelField != param1)
         {
            this.m_LabelField = param1;
            this.m_UncommittedLabelField = true;
            invalidateProperties();
         }
      }
      
      private function layoutDropIndicator(param1:int) : void
      {
         var _loc2_:DynamicTab = null;
         var _loc3_:int = 0;
         if(this.m_UIDropIndicator != null)
         {
            _loc2_ = null;
            _loc3_ = this.getLastVisibleIndex();
            if(param1 >= this.m_ScrollPosition && param1 < _loc3_)
            {
               _loc2_ = DynamicTab(getChildAt(param1));
               this.m_UIDropIndicator.x = _loc2_.x - this.m_UIDropIndicator.width / 2;
               this.m_UIDropIndicator.y = 0;
               this.m_UIDropIndicator.visible = true;
            }
            else if(param1 == _loc3_)
            {
               _loc2_ = DynamicTab(getChildAt(param1 - 1));
               this.m_UIDropIndicator.x = _loc2_.x + _loc2_.width - this.m_UIDropIndicator.width / 2;
               this.m_UIDropIndicator.y = 0;
               this.m_UIDropIndicator.visible = true;
            }
            else
            {
               this.m_UIDropIndicator.visible = false;
            }
         }
      }
      
      public function get toolTipField() : String
      {
         return this.m_ToolTipField;
      }
      
      public function set labelFunction(param1:Function) : void
      {
         if(this.m_LabelFunction != param1)
         {
            this.m_LabelFunction = param1;
            this.m_UncommittedLabelFunction = true;
            invalidateProperties();
         }
      }
      
      protected function onNavItemSelect(param1:MouseEvent) : void
      {
         var _loc2_:DynamicTab = null;
         var _loc3_:int = 0;
         if(param1 != null)
         {
            _loc2_ = DynamicTab(param1.currentTarget);
            _loc3_ = getChildIndex(_loc2_);
            if(_loc2_.enabled)
            {
               this.selectedIndex = _loc3_;
            }
         }
      }
      
      protected function onIListChange(param1:CollectionEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:Object = null;
         if(param1 != null)
         {
            _loc2_ = 0;
            _loc3_ = 0;
            _loc4_ = 0;
            _loc5_ = null;
            switch(param1.kind)
            {
               case CollectionEventKind.ADD:
                  _loc2_ = 0;
                  _loc4_ = param1.items.length;
                  while(_loc2_ < _loc4_)
                  {
                     _loc3_ = param1.location + _loc2_;
                     _loc5_ = IList(this.m_DataProvider).getItemAt(_loc3_);
                     setChildIndex(this.createNavItem(_loc5_),_loc3_);
                     _loc2_++;
                  }
                  break;
               case CollectionEventKind.MOVE:
                  setChildIndex(getChildAt(param1.oldLocation),param1.location);
                  break;
               case CollectionEventKind.REMOVE:
                  _loc2_ = 0;
                  _loc4_ = param1.items.length;
                  while(_loc2_ < _loc4_)
                  {
                     this.destroyNavItem(param1.location + _loc2_);
                     _loc2_++;
                  }
                  this.selectNavItems();
                  break;
               case CollectionEventKind.REFRESH:
               case CollectionEventKind.RESET:
                  this.rebuildNavItems();
                  break;
               case CollectionEventKind.REPLACE:
                  _loc3_ = param1.location;
                  _loc5_ = IList(this.m_DataProvider).getItemAt(_loc3_);
                  this.destroyNavItem(_loc3_);
                  setChildIndex(this.createNavItem(_loc5_),_loc3_);
                  this.selectNavItems();
                  break;
               case CollectionEventKind.UPDATE:
                  _loc2_ = 0;
                  _loc4_ = param1.items.length;
                  while(_loc2_ < _loc4_)
                  {
                     _loc5_ = param1.items[_loc2_];
                     if(_loc5_ is PropertyChangeEvent)
                     {
                        _loc5_ = PropertyChangeEvent(_loc5_).target;
                     }
                     _loc3_ = IList(this.m_DataProvider).getItemIndex(_loc5_);
                     if(_loc3_ > -1)
                     {
                        this.destroyNavItem(_loc3_);
                        setChildIndex(this.createNavItem(_loc5_),_loc3_);
                        _loc2_++;
                        continue;
                     }
                     this.rebuildNavItems();
                     break;
                  }
                  this.selectNavItems();
            }
            invalidateDisplayList();
            invalidateSize();
         }
      }
      
      public function set dragEnabled(param1:Boolean) : void
      {
         if(this.m_DragEnabled != param1)
         {
            this.m_DragEnabled = param1;
            this.m_UncommittedDragEnabled = true;
            invalidateProperties();
         }
      }
      
      public function get labelFunction() : Function
      {
         return this.m_LabelFunction;
      }
      
      public function set selectedIndex(param1:int) : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:TabBarEvent = null;
         if(param1 < 0 || param1 >= this.getDataProviderLength())
         {
            param1 = -1;
         }
         if(this.m_SelectedIndex != param1)
         {
            _loc2_ = param1 > -1 && (param1 < this.getFirstVisibleIndex() || param1 >= this.getLastVisibleIndex());
            this.m_SelectedIndex = param1;
            this.m_UncommittedSelectedIndex = true;
            invalidateDisplayList();
            invalidateProperties();
            if(_loc2_)
            {
               this.scrollPosition = param1;
            }
            _loc3_ = new TabBarEvent(TabBarEvent.SELECT,false,false);
            _loc3_.index = param1;
            dispatchEvent(_loc3_);
         }
      }
      
      public function get selectedIndex() : int
      {
         return this.m_SelectedIndex;
      }
      
      protected function onScrollDrag(param1:TimerEvent) : void
      {
         if(param1 != null)
         {
            this.scrollPosition = this.scrollPosition + this.m_DragAutoScrollDirection;
            validateNow();
            this.layoutDropIndicator(this.getDropIndex(mouseX,mouseY));
         }
      }
      
      protected function onStackChange(param1:Event) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Container = null;
         if(param1 != null && param1.target != this)
         {
            _loc2_ = 0;
            _loc3_ = 0;
            _loc4_ = null;
            switch(param1.type)
            {
               case ChildExistenceChangedEvent.CHILD_ADD:
                  _loc4_ = Container(ChildExistenceChangedEvent(param1).relatedObject);
                  _loc4_.addEventListener("enabledChanged",this.onStackChildChange);
                  _loc4_.addEventListener("iconChanged",this.onStackChildChange);
                  _loc4_.addEventListener("labelChanged",this.onStackChildChange);
                  _loc4_.addEventListener("toolTipChanged",this.onStackChildChange);
                  _loc2_ = ViewStack(this.m_DataProvider).getChildIndex(_loc4_);
                  setChildIndex(this.createNavItem(_loc4_),_loc2_);
                  break;
               case ChildExistenceChangedEvent.CHILD_REMOVE:
                  _loc4_ = Container(ChildExistenceChangedEvent(param1).relatedObject);
                  _loc4_.removeEventListener("enabledChanged",this.onStackChildChange);
                  _loc4_.removeEventListener("iconChanged",this.onStackChildChange);
                  _loc4_.removeEventListener("labelChanged",this.onStackChildChange);
                  _loc4_.removeEventListener("toolTipChanged",this.onStackChildChange);
                  _loc2_ = ViewStack(this.m_DataProvider).getChildIndex(_loc4_);
                  removeChildAt(_loc2_);
                  break;
               case IndexChangedEvent.CHILD_INDEX_CHANGE:
                  _loc2_ = IndexChangedEvent(param1).oldIndex;
                  _loc3_ = IndexChangedEvent(param1).newIndex;
                  setChildIndex(getChildAt(_loc2_),_loc3_);
            }
            invalidateDisplayList();
            invalidateSize();
         }
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         var _loc20_:Number = NaN;
         var _loc21_:* = false;
         super.updateDisplayList(param1,param2);
         var _loc3_:Number = getStyle("paddingLeft");
         var _loc4_:Number = param1;
         var _loc5_:Number = getStyle("paddingTop");
         var _loc6_:Number = param1 - _loc3_ - getStyle("paddingRight");
         var _loc7_:Number = param2 - _loc5_ - getStyle("paddingBottom");
         var _loc8_:Number = 0;
         var _loc9_:Number = 0;
         var _loc10_:Number = 0;
         var _loc11_:* = measuredWidth > param1;
         if(this.m_DropDownPolicy != DROP_DOWN_OFF)
         {
            _loc8_ = this.m_UIDropDownButton.getExplicitOrMeasuredWidth();
            _loc9_ = this.m_UIDropDownButton.getExplicitOrMeasuredHeight();
            this.m_UIDropDownButton.setActualSize(_loc8_,_loc9_);
            this.m_UIDropDownButton.move(_loc4_ - _loc8_,(param2 - _loc9_) / 2);
            this.m_UIDropDownButton.visible = this.m_DropDownPolicy == DROP_DOWN_ON || _loc11_;
            _loc4_ = _loc4_ - _loc8_;
            _loc6_ = _loc6_ - _loc8_;
         }
         else
         {
            this.m_UIDropDownButton.visible = false;
         }
         if(this.m_ScrollPolicy != ScrollPolicy.OFF)
         {
            _loc8_ = this.m_UILeftButton.getExplicitOrMeasuredWidth();
            _loc9_ = this.m_UILeftButton.getExplicitOrMeasuredHeight();
            this.m_UILeftButton.setActualSize(_loc8_,_loc9_);
            this.m_UILeftButton.move(0,(param2 - _loc9_) / 2);
            this.m_UILeftButton.visible = this.m_ScrollPolicy == ScrollPolicy.ON || _loc11_;
            _loc3_ = _loc3_ + _loc8_;
            _loc6_ = _loc6_ - _loc8_;
            _loc8_ = this.m_UIRightButton.getExplicitOrMeasuredWidth();
            _loc9_ = this.m_UIRightButton.getExplicitOrMeasuredHeight();
            this.m_UIRightButton.setActualSize(_loc8_,_loc9_);
            this.m_UIRightButton.move(_loc4_ - _loc8_,(param2 - _loc9_) / 2);
            this.m_UIRightButton.visible = this.m_ScrollPolicy == ScrollPolicy.ON || _loc11_;
            _loc6_ = _loc6_ - _loc8_;
         }
         else
         {
            this.m_UILeftButton.visible = false;
            this.m_UIRightButton.visible = false;
         }
         var _loc12_:int = 0;
         var _loc13_:int = numChildren - this.m_UIInternalChildren;
         var _loc14_:DynamicTab = null;
         var _loc15_:Vector.<Object> = new Vector.<Object>(_loc13_,true);
         var _loc16_:Number = 0;
         var _loc17_:Number = 0;
         var _loc18_:Number = 0;
         _loc12_ = 0;
         while(_loc12_ < _loc13_)
         {
            _loc14_ = DynamicTab(getChildAt(_loc12_));
            _loc14_.visible = false;
            _loc8_ = _loc14_.getExplicitOrMeasuredWidth();
            if(this.m_TabResize && !isNaN(this.m_TabMinWidth))
            {
               _loc10_ = this.m_TabMinWidth;
            }
            else if(!isNaN(_loc14_.minWidth))
            {
               _loc10_ = _loc14_.minWidth;
            }
            else
            {
               _loc10_ = _loc8_;
            }
            if(this.m_TabResize && !isNaN(this.m_TabMaxWidth))
            {
               _loc8_ = Math.min(_loc8_,this.m_TabMaxWidth);
            }
            _loc8_ = Math.max(_loc10_,_loc8_);
            _loc15_[_loc12_] = {
               "val":_loc8_,
               "max":_loc8_,
               "min":_loc10_
            };
            _loc17_ = _loc17_ + _loc8_;
            _loc18_ = _loc18_ + _loc10_;
            _loc16_ = Math.max(_loc16_,_loc14_.getExplicitOrMeasuredHeight());
            _loc12_++;
         }
         if(this.m_TabResize && _loc17_ > _loc18_ && _loc17_ > _loc6_)
         {
            _loc20_ = Math.max(0,1 - (_loc17_ - _loc6_) / (_loc17_ - _loc18_));
            _loc12_ = 0;
            while(_loc12_ < _loc13_)
            {
               _loc15_[_loc12_].val = Math.floor(_loc15_[_loc12_].min + _loc20_ * (_loc15_[_loc12_].max - _loc15_[_loc12_].min));
               _loc12_++;
            }
         }
         var _loc19_:Number = getStyle("horizontalGap");
         this.m_ScrollPosition = Math.max(0,Math.min(this.m_ScrollPosition,_loc13_ - 1));
         _loc12_ = this.m_ScrollPosition;
         while(_loc12_ >= 0 && _loc12_ < _loc13_ && _loc6_ >= _loc15_[_loc12_].val)
         {
            _loc6_ = _loc6_ - (_loc15_[_loc12_].val + _loc19_);
            _loc12_++;
         }
         _loc13_ = _loc12_;
         _loc12_ = this.m_ScrollPosition - 1;
         while(_loc12_ >= 0 && _loc6_ >= _loc15_[_loc12_].val)
         {
            _loc6_ = _loc6_ - (_loc15_[_loc12_].val + _loc19_);
            _loc12_--;
            this.m_ScrollPosition--;
         }
         _loc12_ = this.m_ScrollPosition;
         while(_loc12_ < _loc13_)
         {
            _loc14_ = DynamicTab(getChildAt(_loc12_));
            _loc8_ = _loc15_[_loc12_].val;
            _loc9_ = _loc14_.getExplicitOrMeasuredHeight();
            _loc14_.setActualSize(_loc8_,_loc9_);
            _loc14_.move(_loc3_,_loc5_ + _loc7_ - _loc9_);
            _loc14_.visible = true;
            _loc3_ = _loc3_ + (_loc8_ + _loc19_);
            _loc12_++;
         }
         this.m_FirstVisibleIndex = this.m_ScrollPosition;
         this.m_LastVisibleIndex = _loc13_;
         if(this.m_ScrollPolicy != ScrollPolicy.OFF)
         {
            _loc21_ = this.m_ScrollPosition > 0;
            if(this.m_UILeftButton.enabled && !_loc21_)
            {
               this.m_UILeftButton.mx_internal::buttonReleased();
            }
            this.m_UILeftButton.enabled = _loc21_;
            _loc21_ = _loc13_ < numChildren - this.m_UIInternalChildren;
            if(this.m_UIRightButton.enabled && !_loc21_)
            {
               this.m_UIRightButton.mx_internal::buttonReleased();
            }
            this.m_UIRightButton.enabled = _loc21_;
         }
         else
         {
            this.m_UILeftButton.enabled = false;
            this.m_UIRightButton.enabled = false;
         }
         if(this.m_DropDownPolicy != DROP_DOWN_OFF)
         {
            this.m_UIDropDownButton.enabled = this.m_UILeftButton.enabled || this.m_UIRightButton.enabled;
         }
         else
         {
            this.m_UIDropDownButton.enabled = false;
         }
      }
   }
}
