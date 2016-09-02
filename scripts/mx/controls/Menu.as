package mx.controls
{
   import mx.managers.IFocusManagerContainer;
   import mx.core.mx_internal;
   import mx.events.MenuEvent;
   import mx.managers.PopUpManager;
   import flash.display.DisplayObjectContainer;
   import flash.display.DisplayObject;
   import mx.core.Application;
   import mx.controls.listClasses.IListItemRenderer;
   import mx.collections.CursorBookmark;
   import mx.controls.menuClasses.MenuListData;
   import mx.controls.menuClasses.IMenuItemRenderer;
   import flash.events.MouseEvent;
   import flash.events.FocusEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.clearInterval;
   import mx.effects.Tween;
   import flash.events.Event;
   import mx.events.ListEvent;
   import mx.events.SandboxMouseEvent;
   import mx.controls.menuClasses.IMenuBarItemRenderer;
   import mx.events.FlexEvent;
   import mx.core.EdgeMetrics;
   import flash.events.KeyboardEvent;
   import flash.ui.Keyboard;
   import mx.core.UIComponent;
   import mx.controls.menuClasses.IMenuDataDescriptor;
   import flash.xml.XMLNode;
   import mx.collections.XMLListCollection;
   import mx.collections.ICollectionView;
   import mx.collections.ArrayCollection;
   import mx.events.CollectionEvent;
   import mx.events.CollectionEventKind;
   import mx.core.UIComponentGlobals;
   import mx.controls.listClasses.BaseListData;
   import mx.core.ScrollPolicy;
   import mx.core.EventPriority;
   import flash.utils.setTimeout;
   import mx.events.InterManagerRequest;
   import mx.managers.ISystemManager;
   import mx.controls.treeClasses.DefaultDataDescriptor;
   import mx.core.ClassFactory;
   import mx.controls.menuClasses.MenuItemRenderer;
   
   use namespace mx_internal;
   
   public class Menu extends List implements IFocusManagerContainer
   {
      
      mx_internal static var createAccessibilityImplementation:Function;
      
      mx_internal static const VERSION:String = "3.6.0.21751";
       
      
      mx_internal var parentDisplayObject:DisplayObject;
      
      private var isDirectionLeft:Boolean = false;
      
      mx_internal var popupTween:Tween;
      
      mx_internal var closeTimer:int = 0;
      
      mx_internal var openSubMenuTimer:int = 0;
      
      mx_internal var showRootChanged:Boolean = false;
      
      mx_internal var sourceMenuBarItem:IMenuBarItemRenderer;
      
      mx_internal var _hasRoot:Boolean = false;
      
      mx_internal var dataProviderChanged:Boolean = false;
      
      private var maxMeasuredTypeIconWidth:Number = 0;
      
      mx_internal var sourceMenuBar:mx.controls.MenuBar;
      
      private var maxMeasuredBranchIconWidth:Number = 0;
      
      private var maxMeasuredIconWidth:Number = 0;
      
      private var subMenu:mx.controls.Menu;
      
      mx_internal var _parentMenu:mx.controls.Menu;
      
      mx_internal var _dataDescriptor:IMenuDataDescriptor;
      
      private var hiddenItem:IListItemRenderer;
      
      mx_internal var _showRoot:Boolean = true;
      
      private var useTwoColumns:Boolean = false;
      
      mx_internal var supposedToLoseFocus:Boolean = false;
      
      private var anchorRow:IListItemRenderer;
      
      mx_internal var _rootModel:ICollectionView;
      
      mx_internal var _listDataProvider:ICollectionView;
      
      public function Menu()
      {
         _dataDescriptor = new DefaultDataDescriptor();
         super();
         itemRenderer = new ClassFactory(MenuItemRenderer);
         setRowHeight(19);
         iconField = "icon";
         visible = false;
      }
      
      private static function menuHideHandler(param1:MenuEvent) : void
      {
         var _loc2_:mx.controls.Menu = mx.controls.Menu(param1.target);
         if(!param1.isDefaultPrevented() && param1.menu == _loc2_)
         {
            _loc2_.supposedToLoseFocus = true;
            PopUpManager.removePopUp(_loc2_);
            _loc2_.removeEventListener(MenuEvent.MENU_HIDE,menuHideHandler);
         }
      }
      
      public static function popUpMenu(param1:mx.controls.Menu, param2:DisplayObjectContainer, param3:Object) : void
      {
         param1.parentDisplayObject = !!param2?param2:DisplayObject(Application.application);
         if(!param3)
         {
            param3 = new XML();
         }
         param1.supposedToLoseFocus = true;
         param1.dataProvider = param3;
      }
      
      public static function createMenu(param1:DisplayObjectContainer, param2:Object, param3:Boolean = true) : mx.controls.Menu
      {
         var _loc4_:mx.controls.Menu = null;
         _loc4_ = new mx.controls.Menu();
         _loc4_.tabEnabled = false;
         _loc4_.owner = DisplayObjectContainer(Application.application);
         _loc4_.showRoot = param3;
         popUpMenu(_loc4_,param1,param2);
         return _loc4_;
      }
      
      private function moveSelBy(param1:Number, param2:Number) : void
      {
         var _loc6_:Object = null;
         var _loc8_:MenuEvent = null;
         var _loc9_:Object = null;
         var _loc3_:Number = param1;
         if(isNaN(_loc3_))
         {
            _loc3_ = -1;
         }
         var _loc4_:Number = Math.max(0,Math.min(rowCount,collection.length) - 1);
         var _loc5_:Number = _loc3_;
         var _loc7_:int = 0;
         while(true)
         {
            _loc5_ = _loc5_ + param2;
            if(_loc7_ > _loc4_)
            {
               break;
            }
            _loc7_++;
            if(_loc5_ > _loc4_)
            {
               _loc5_ = 0;
            }
            else if(_loc5_ < 0)
            {
               _loc5_ = _loc4_;
            }
            _loc6_ = listItems[_loc5_][0];
            if(!(_loc6_.data && (_dataDescriptor.getType(_loc6_.data) == "separator" || !_dataDescriptor.isEnabled(_loc6_.data))))
            {
               if(selectedIndex != -1)
               {
                  _loc9_ = listItems[selectedIndex][0];
                  _loc8_ = new MenuEvent(MenuEvent.ITEM_ROLL_OUT);
                  _loc8_.menu = this;
                  _loc8_.index = this.selectedIndex;
                  _loc8_.menuBar = sourceMenuBar;
                  _loc8_.label = itemToLabel(_loc9_.data);
                  _loc8_.item = _loc9_.data;
                  _loc8_.itemRenderer = IListItemRenderer(_loc9_);
                  getRootMenu().dispatchEvent(_loc8_);
               }
               if(_loc6_.data)
               {
                  selectItem(listItems[_loc5_ - verticalScrollPosition][0],false,false);
                  _loc8_ = new MenuEvent(MenuEvent.ITEM_ROLL_OVER);
                  _loc8_.menu = this;
                  _loc8_.index = this.selectedIndex;
                  _loc8_.menuBar = sourceMenuBar;
                  _loc8_.label = itemToLabel(_loc6_.data);
                  _loc8_.item = _loc6_.data;
                  _loc8_.itemRenderer = IListItemRenderer(_loc6_);
                  getRootMenu().dispatchEvent(_loc8_);
               }
               return;
            }
         }
      }
      
      override public function measureWidthOfItems(param1:int = -1, param2:int = 0) : Number
      {
         var _loc6_:CursorBookmark = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:Boolean = false;
         var _loc10_:Object = null;
         var _loc11_:MenuListData = null;
         var _loc12_:IListItemRenderer = null;
         var _loc13_:IMenuItemRenderer = null;
         var _loc3_:Number = 0;
         var _loc4_:Number = getStyle("leftIconGap");
         var _loc5_:Number = getStyle("rightIconGap");
         maxMeasuredIconWidth = 0;
         maxMeasuredTypeIconWidth = 0;
         maxMeasuredBranchIconWidth = 0;
         useTwoColumns = false;
         if(collection && collection.length)
         {
            _loc6_ = iterator.bookmark;
            _loc7_ = param2;
            _loc8_ = 0;
            while(_loc8_ < 2)
            {
               iterator.seek(CursorBookmark.FIRST,param1);
               param2 = _loc7_;
               _loc9_ = false;
               while(param2)
               {
                  _loc10_ = iterator.current;
                  _loc12_ = hiddenItem = getMeasuringRenderer(_loc10_);
                  _loc12_.explicitWidth = NaN;
                  setupRendererFromData(_loc12_,_loc10_);
                  _loc3_ = Math.max(_loc12_.getExplicitOrMeasuredWidth(),_loc3_);
                  if(_loc12_ is IMenuItemRenderer)
                  {
                     _loc13_ = IMenuItemRenderer(_loc12_);
                     if(_loc13_.measuredIconWidth > maxMeasuredIconWidth)
                     {
                        maxMeasuredIconWidth = _loc13_.measuredIconWidth;
                        _loc9_ = true;
                     }
                     if(_loc13_.measuredTypeIconWidth > maxMeasuredTypeIconWidth)
                     {
                        maxMeasuredTypeIconWidth = _loc13_.measuredTypeIconWidth;
                        _loc9_ = true;
                     }
                     if(_loc13_.measuredBranchIconWidth > maxMeasuredBranchIconWidth)
                     {
                        maxMeasuredBranchIconWidth = _loc13_.measuredBranchIconWidth;
                        _loc9_ = true;
                     }
                     if(_loc13_.measuredIconWidth > 0 && _loc13_.measuredTypeIconWidth)
                     {
                        useTwoColumns = true;
                        _loc9_ = true;
                     }
                  }
                  param2--;
                  if(!iterator.moveNext())
                  {
                     break;
                  }
               }
               if(_loc8_ == 0)
               {
                  if(!(_loc9_ && (maxMeasuredIconWidth + maxMeasuredTypeIconWidth > _loc4_ || maxMeasuredBranchIconWidth > _loc5_)))
                  {
                     break;
                  }
               }
               _loc8_++;
            }
            iterator.seek(_loc6_,0);
         }
         if(!_loc3_)
         {
            _loc3_ = 200;
         }
         _loc3_ = _loc3_ + (getStyle("paddingLeft") + getStyle("paddingRight"));
         return _loc3_;
      }
      
      override protected function mouseUpHandler(param1:MouseEvent) : void
      {
         var _loc2_:MenuEvent = null;
         var _loc4_:Object = null;
         var _loc5_:Boolean = false;
         if(!enabled || !selectable || !visible)
         {
            return;
         }
         super.mouseUpHandler(param1);
         var _loc3_:IListItemRenderer = mouseEventToItemRenderer(param1);
         if(_loc3_ && _loc3_.data)
         {
            _loc4_ = _loc3_.data;
         }
         if(_loc4_ != null && _dataDescriptor.isEnabled(_loc4_) && !_dataDescriptor.isBranch(_loc4_))
         {
            _loc5_ = _dataDescriptor.getType(_loc4_) != "radio" || !_dataDescriptor.isToggled(_loc4_);
            if(_loc5_)
            {
               setMenuItemToggled(_loc4_,!_dataDescriptor.isToggled(_loc4_));
            }
            _loc2_ = new MenuEvent(MenuEvent.ITEM_CLICK);
            _loc2_.menu = this;
            _loc2_.index = this.selectedIndex;
            _loc2_.menuBar = sourceMenuBar;
            _loc2_.label = itemToLabel(_loc4_);
            _loc2_.item = _loc4_;
            _loc2_.itemRenderer = _loc3_;
            getRootMenu().dispatchEvent(_loc2_);
            if(_loc5_)
            {
               _loc2_ = new MenuEvent(MenuEvent.CHANGE);
               _loc2_.menu = this;
               _loc2_.index = this.selectedIndex;
               _loc2_.menuBar = sourceMenuBar;
               _loc2_.label = itemToLabel(_loc4_);
               _loc2_.item = _loc4_;
               _loc2_.itemRenderer = _loc3_;
               getRootMenu().dispatchEvent(_loc2_);
            }
            hideAllMenus();
         }
      }
      
      private function isMouseOverMenu(param1:MouseEvent) : Boolean
      {
         var _loc2_:DisplayObject = DisplayObject(param1.target);
         while(_loc2_)
         {
            if(_loc2_ is mx.controls.Menu)
            {
               return true;
            }
            _loc2_ = _loc2_.parent;
         }
         return false;
      }
      
      override protected function focusOutHandler(param1:FocusEvent) : void
      {
         super.focusOutHandler(param1);
         if(!supposedToLoseFocus)
         {
            hideAllMenus();
         }
         supposedToLoseFocus = false;
      }
      
      mx_internal function openSubMenu(param1:IListItemRenderer) : void
      {
         var _loc3_:mx.controls.Menu = null;
         var _loc7_:Number = NaN;
         var _loc12_:Number = NaN;
         supposedToLoseFocus = true;
         var _loc2_:mx.controls.Menu = getRootMenu();
         if(!IMenuItemRenderer(param1).menu)
         {
            _loc3_ = new mx.controls.Menu();
            _loc3_.parentMenu = this;
            _loc3_.owner = this;
            _loc3_.showRoot = showRoot;
            _loc3_.dataDescriptor = _loc2_.dataDescriptor;
            _loc3_.styleName = _loc2_;
            _loc3_.labelField = _loc2_.labelField;
            _loc3_.labelFunction = _loc2_.labelFunction;
            _loc3_.iconField = _loc2_.iconField;
            _loc3_.iconFunction = _loc2_.iconFunction;
            _loc3_.itemRenderer = _loc2_.itemRenderer;
            _loc3_.rowHeight = _loc2_.rowHeight;
            _loc3_.scaleY = _loc2_.scaleY;
            _loc3_.scaleX = _loc2_.scaleX;
            if(param1.data && _dataDescriptor.isBranch(param1.data) && _dataDescriptor.hasChildren(param1.data))
            {
               _loc3_.dataProvider = _dataDescriptor.getChildren(param1.data);
            }
            _loc3_.sourceMenuBar = sourceMenuBar;
            _loc3_.sourceMenuBarItem = sourceMenuBarItem;
            IMenuItemRenderer(param1).menu = _loc3_;
            PopUpManager.addPopUp(_loc3_,_loc2_,false);
         }
         else
         {
            _loc3_ = IMenuItemRenderer(param1).menu;
         }
         var _loc4_:DisplayObject = DisplayObject(param1);
         var _loc5_:Point = new Point(0,0);
         _loc5_ = _loc4_.localToGlobal(_loc5_);
         if(_loc4_.root)
         {
            _loc5_ = _loc4_.root.globalToLocal(_loc5_);
         }
         var _loc6_:Number = _loc5_.y;
         if(!isDirectionLeft)
         {
            _loc7_ = _loc5_.x + param1.width;
         }
         else
         {
            _loc7_ = _loc5_.x - _loc3_.getExplicitOrMeasuredWidth();
         }
         var _loc8_:Rectangle = systemManager.getVisibleApplicationRect();
         var _loc9_:DisplayObject = systemManager.getSandboxRoot();
         var _loc10_:Point = _loc9_.localToGlobal(new Point(_loc7_,_loc6_));
         var _loc11_:Number = _loc10_.x + _loc3_.getExplicitOrMeasuredWidth() - _loc8_.right;
         if(_loc11_ > 0 || _loc10_.x < _loc8_.x)
         {
            _loc12_ = getExplicitOrMeasuredWidth() + _loc3_.getExplicitOrMeasuredWidth();
            if(isDirectionLeft)
            {
               _loc12_ = _loc12_ * -1;
            }
            _loc7_ = Math.max(_loc7_ - _loc12_,0);
            _loc10_ = new Point(_loc7_,_loc6_);
            _loc10_ = _loc9_.localToGlobal(_loc10_);
            _loc11_ = Math.max(0,_loc10_.x + width - _loc8_.right);
            _loc7_ = Math.max(_loc7_ - _loc11_,0);
         }
         _loc3_.isDirectionLeft = this.x > _loc7_;
         _loc11_ = _loc10_.y + _loc3_.getExplicitOrMeasuredHeight() - _loc8_.bottom;
         if(_loc11_ > 0 || _loc10_.y < _loc8_.y)
         {
            _loc6_ = Math.max(_loc6_ - _loc11_,0);
         }
         _loc3_.show(_loc7_,_loc6_);
         subMenu = _loc3_;
         clearInterval(openSubMenuTimer);
         openSubMenuTimer = 0;
      }
      
      public function get parentMenu() : mx.controls.Menu
      {
         return _parentMenu;
      }
      
      private function parentRowHeightHandler(param1:Event) : void
      {
         rowHeight = parentMenu.rowHeight;
      }
      
      mx_internal function hideAllMenus() : void
      {
         getRootMenu().hide();
         getRootMenu().deleteDependentSubMenus();
      }
      
      override public function dispatchEvent(param1:Event) : Boolean
      {
         var _loc2_:MenuEvent = null;
         if(!(param1 is MenuEvent) && param1 is ListEvent && (param1.type == ListEvent.ITEM_ROLL_OUT || param1.type == ListEvent.ITEM_ROLL_OVER || param1.type == ListEvent.CHANGE))
         {
            param1.stopImmediatePropagation();
         }
         if(!(param1 is MenuEvent) && param1 is ListEvent && param1.type == ListEvent.ITEM_CLICK)
         {
            _loc2_ = new MenuEvent(param1.type,param1.bubbles,param1.cancelable);
            _loc2_.item = ListEvent(param1).itemRenderer.data;
            _loc2_.label = itemToLabel(ListEvent(param1).itemRenderer);
            return super.dispatchEvent(_loc2_);
         }
         return super.dispatchEvent(param1);
      }
      
      mx_internal function deleteDependentSubMenus() : void
      {
         var _loc3_:mx.controls.Menu = null;
         var _loc1_:int = listItems.length;
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            if(listItems[_loc2_][0])
            {
               _loc3_ = IMenuItemRenderer(listItems[_loc2_][0]).menu;
               if(_loc3_)
               {
                  _loc3_.deleteDependentSubMenus();
                  PopUpManager.removePopUp(_loc3_);
                  IMenuItemRenderer(listItems[_loc2_][0]).menu = null;
               }
            }
            _loc2_++;
         }
      }
      
      public function hide() : void
      {
         var _loc1_:DisplayObject = null;
         var _loc2_:MenuEvent = null;
         if(visible)
         {
            if(popupTween)
            {
               popupTween.endTween();
            }
            clearSelected();
            if(anchorRow)
            {
               drawItem(anchorRow,false,false);
               anchorRow = null;
            }
            visible = false;
            _loc1_ = systemManager.getSandboxRoot();
            _loc1_.removeEventListener(MouseEvent.MOUSE_DOWN,mouseDownOutsideHandler);
            removeEventListener(SandboxMouseEvent.MOUSE_DOWN_SOMEWHERE,mouseDownOutsideHandler);
            _loc2_ = new MenuEvent(MenuEvent.MENU_HIDE);
            _loc2_.menu = this;
            _loc2_.menuBar = sourceMenuBar;
            getRootMenu().dispatchEvent(_loc2_);
         }
      }
      
      override public function set horizontalScrollPolicy(param1:String) : void
      {
      }
      
      public function set parentMenu(param1:mx.controls.Menu) : void
      {
         _parentMenu = param1;
         param1.addEventListener(FlexEvent.HIDE,parentHideHandler,false,0,true);
         param1.addEventListener("rowHeightChanged",parentRowHeightHandler,false,0,true);
         param1.addEventListener("iconFieldChanged",parentIconFieldHandler,false,0,true);
         param1.addEventListener("iconFunctionChanged",parentIconFunctionHandler,false,0,true);
         param1.addEventListener("labelFieldChanged",parentLabelFieldHandler,false,0,true);
         param1.addEventListener("labelFunctionChanged",parentLabelFunctionHandler,false,0,true);
         param1.addEventListener("itemRendererChanged",parentItemRendererHandler,false,0,true);
      }
      
      protected function setMenuItemToggled(param1:Object, param2:Boolean) : void
      {
         var _loc3_:String = null;
         var _loc4_:int = 0;
         var _loc5_:IListItemRenderer = null;
         var _loc6_:Object = null;
         itemsSizeChanged = true;
         invalidateDisplayList();
         if(_dataDescriptor.getType(param1) == "radio")
         {
            _loc3_ = _dataDescriptor.getGroupName(param1);
            _loc4_ = 0;
            while(_loc4_ < listItems.length)
            {
               _loc5_ = listItems[_loc4_][0];
               _loc6_ = _loc5_.data;
               if(_dataDescriptor.getType(_loc6_) == "radio" && _dataDescriptor.getGroupName(_loc6_) == _loc3_)
               {
                  _dataDescriptor.setToggled(_loc6_,_loc6_ == param1);
               }
               _loc4_++;
            }
         }
         if(param2 != _dataDescriptor.isToggled(param1))
         {
            _dataDescriptor.setToggled(param1,param2);
         }
      }
      
      override protected function measure() : void
      {
         var _loc1_:EdgeMetrics = null;
         var _loc2_:int = 0;
         super.measure();
         if(!dataProvider || dataProvider.length == 0)
         {
            measuredWidth = 0;
            measuredHeight = 0;
         }
         else
         {
            _loc1_ = viewMetrics;
            measuredMinWidth = measuredWidth = measureWidthOfItems(0,dataProvider.length);
            if(variableRowHeight)
            {
               _loc2_ = measureHeightOfItems(0,dataProvider.length);
            }
            else
            {
               _loc2_ = dataProvider.length * rowHeight;
            }
            measuredMinHeight = measuredHeight = _loc2_ + _loc1_.top + _loc1_.bottom;
         }
      }
      
      override protected function mouseDownHandler(param1:MouseEvent) : void
      {
         var _loc3_:Object = null;
         var _loc2_:IListItemRenderer = mouseEventToItemRenderer(param1);
         if(_loc2_ && _loc2_.data)
         {
            _loc3_ = _loc2_.data;
         }
         if(_loc3_ && _dataDescriptor.isEnabled(_loc3_) && !_dataDescriptor.isBranch(_loc3_))
         {
            super.mouseDownHandler(param1);
         }
      }
      
      override protected function mouseEventToItemRenderer(param1:MouseEvent) : IListItemRenderer
      {
         var _loc2_:IListItemRenderer = super.mouseEventToItemRenderer(param1);
         if(_loc2_ && _loc2_.data && _dataDescriptor.getType(_loc2_.data) == "separator")
         {
            return null;
         }
         return _loc2_;
      }
      
      override protected function keyDownHandler(param1:KeyboardEvent) : void
      {
         var _loc5_:MenuEvent = null;
         var _loc2_:IListItemRenderer = selectedIndex == -1?null:listItems[selectedIndex - verticalScrollPosition][0];
         var _loc3_:Object = !!_loc2_?_loc2_.data:null;
         var _loc4_:mx.controls.Menu = !!_loc2_?IMenuItemRenderer(_loc2_).menu:null;
         if(param1.keyCode == Keyboard.UP)
         {
            if(_loc3_ && _dataDescriptor.isBranch(_loc3_) && _loc4_ && _loc4_.visible)
            {
               supposedToLoseFocus = true;
               _loc4_.setFocus();
               _loc4_.moveSelBy(_loc4_.dataProvider.length,-1);
            }
            else
            {
               moveSelBy(selectedIndex,-1);
            }
            param1.stopPropagation();
         }
         else if(param1.keyCode == Keyboard.DOWN)
         {
            if(_loc3_ && _dataDescriptor.isBranch(_loc3_) && _loc4_ && _loc4_.visible)
            {
               supposedToLoseFocus = true;
               _loc4_.setFocus();
               _loc4_.moveSelBy(-1,1);
            }
            else
            {
               moveSelBy(selectedIndex,1);
            }
            param1.stopPropagation();
         }
         else if(param1.keyCode == Keyboard.RIGHT)
         {
            if(_loc3_ && _dataDescriptor.isBranch(_loc3_))
            {
               openSubMenu(_loc2_);
               _loc4_ = IMenuItemRenderer(_loc2_).menu;
               supposedToLoseFocus = true;
               _loc4_.setFocus();
               _loc4_.moveSelBy(-1,1);
            }
            else if(sourceMenuBar)
            {
               supposedToLoseFocus = true;
               sourceMenuBar.setFocus();
               sourceMenuBar.dispatchEvent(param1);
            }
            param1.stopPropagation();
         }
         else if(param1.keyCode == Keyboard.LEFT)
         {
            if(_parentMenu)
            {
               supposedToLoseFocus = true;
               hide();
               _parentMenu.setFocus();
            }
            else if(sourceMenuBar)
            {
               supposedToLoseFocus = true;
               sourceMenuBar.setFocus();
               sourceMenuBar.dispatchEvent(param1);
            }
            param1.stopPropagation();
         }
         else if(param1.keyCode == Keyboard.ENTER || param1.keyCode == Keyboard.SPACE)
         {
            if(_loc3_ && _dataDescriptor.isBranch(_loc3_))
            {
               openSubMenu(_loc2_);
               _loc4_ = IMenuItemRenderer(_loc2_).menu;
               supposedToLoseFocus = true;
               _loc4_.setFocus();
               _loc4_.moveSelBy(-1,1);
            }
            else if(_loc3_)
            {
               setMenuItemToggled(_loc3_,!_dataDescriptor.isToggled(_loc3_));
               _loc5_ = new MenuEvent(MenuEvent.ITEM_CLICK);
               _loc5_.menu = this;
               _loc5_.index = this.selectedIndex;
               _loc5_.menuBar = sourceMenuBar;
               _loc5_.label = itemToLabel(_loc3_);
               _loc5_.item = _loc3_;
               _loc5_.itemRenderer = _loc2_;
               getRootMenu().dispatchEvent(_loc5_);
               _loc5_ = new MenuEvent(MenuEvent.CHANGE);
               _loc5_.menu = this;
               _loc5_.index = this.selectedIndex;
               _loc5_.menuBar = sourceMenuBar;
               _loc5_.label = itemToLabel(_loc3_);
               _loc5_.item = _loc3_;
               _loc5_.itemRenderer = _loc2_;
               getRootMenu().dispatchEvent(_loc5_);
               hideAllMenus();
            }
            param1.stopPropagation();
         }
         else if(param1.keyCode == Keyboard.TAB)
         {
            _loc5_ = new MenuEvent(MenuEvent.MENU_HIDE);
            _loc5_.menu = getRootMenu();
            _loc5_.menuBar = sourceMenuBar;
            getRootMenu().dispatchEvent(_loc5_);
            hideAllMenus();
            param1.stopPropagation();
         }
         else if(param1.keyCode == Keyboard.ESCAPE)
         {
            if(_parentMenu)
            {
               supposedToLoseFocus = true;
               hide();
               _parentMenu.setFocus();
            }
            else
            {
               _loc5_ = new MenuEvent(MenuEvent.MENU_HIDE);
               _loc5_.menu = getRootMenu();
               _loc5_.menuBar = sourceMenuBar;
               getRootMenu().dispatchEvent(_loc5_);
               hideAllMenus();
               param1.stopPropagation();
            }
         }
      }
      
      private function parentItemRendererHandler(param1:Event) : void
      {
         itemRenderer = parentMenu.itemRenderer;
      }
      
      mx_internal function onTweenEnd(param1:Object) : void
      {
         UIComponent.resumeBackgroundProcessing();
         scrollRect = null;
         popupTween = null;
      }
      
      public function set dataDescriptor(param1:IMenuDataDescriptor) : void
      {
         _dataDescriptor = param1;
      }
      
      override public function set dataProvider(param1:Object) : void
      {
         var _loc2_:XMLList = null;
         var _loc3_:Array = null;
         if(typeof param1 == "string")
         {
            param1 = new XML(param1);
         }
         else if(param1 is XMLNode)
         {
            param1 = new XML(XMLNode(param1).toString());
         }
         else if(param1 is XMLList)
         {
            param1 = new XMLListCollection(param1 as XMLList);
         }
         if(param1 is XML)
         {
            _hasRoot = true;
            _loc2_ = new XMLList();
            _loc2_ = _loc2_ + param1;
            _rootModel = new XMLListCollection(_loc2_);
         }
         else if(param1 is ICollectionView)
         {
            _rootModel = ICollectionView(param1);
            if(_rootModel.length == 1)
            {
               _hasRoot = true;
            }
         }
         else if(param1 is Array)
         {
            _rootModel = new ArrayCollection(param1 as Array);
         }
         else if(param1 is Object)
         {
            _hasRoot = true;
            _loc3_ = [];
            _loc3_.push(param1);
            _rootModel = new ArrayCollection(_loc3_);
         }
         else
         {
            _rootModel = new ArrayCollection();
         }
         dataProviderChanged = true;
         invalidateProperties();
      }
      
      override protected function drawItem(param1:IListItemRenderer, param2:Boolean = false, param3:Boolean = false, param4:Boolean = false, param5:Boolean = false) : void
      {
         if(!getStyle("useRollOver"))
         {
            super.drawItem(param1,param2,false,false,param5);
         }
         else
         {
            super.drawItem(param1,param2,param3,param4,param5);
         }
      }
      
      private function parentLabelFieldHandler(param1:Event) : void
      {
         labelField = parentMenu.labelField;
      }
      
      override protected function collectionChangeHandler(param1:Event) : void
      {
         var _loc2_:CollectionEvent = null;
         if(param1 is CollectionEvent)
         {
            _loc2_ = CollectionEvent(param1);
            if(_loc2_.kind == CollectionEventKind.ADD)
            {
               super.collectionChangeHandler(param1);
               dataProviderChanged = true;
               invalidateProperties();
               invalidateSize();
               UIComponentGlobals.layoutManager.validateClient(this);
               setActualSize(getExplicitOrMeasuredWidth(),getExplicitOrMeasuredHeight());
            }
            else if(_loc2_.kind == CollectionEventKind.REMOVE)
            {
               super.collectionChangeHandler(param1);
               dataProviderChanged = true;
               invalidateProperties();
               invalidateSize();
               UIComponentGlobals.layoutManager.validateClient(this);
               setActualSize(getExplicitOrMeasuredWidth(),getExplicitOrMeasuredHeight());
            }
            else if(_loc2_.kind == CollectionEventKind.REFRESH)
            {
               dataProviderChanged = true;
               invalidateProperties();
               invalidateSize();
            }
            else if(_loc2_.kind == CollectionEventKind.RESET)
            {
               dataProviderChanged = true;
               invalidateProperties();
               invalidateSize();
            }
         }
         itemsSizeChanged = true;
         invalidateDisplayList();
      }
      
      override protected function makeListData(param1:Object, param2:String, param3:int) : BaseListData
      {
         var _loc4_:MenuListData = new MenuListData(itemToLabel(param1),itemToIcon(param1),labelField,param2,this,param3);
         _loc4_.maxMeasuredIconWidth = maxMeasuredIconWidth;
         _loc4_.maxMeasuredTypeIconWidth = maxMeasuredTypeIconWidth;
         _loc4_.maxMeasuredBranchIconWidth = maxMeasuredBranchIconWidth;
         _loc4_.useTwoColumns = useTwoColumns;
         return _loc4_;
      }
      
      public function get showRoot() : Boolean
      {
         return _showRoot;
      }
      
      private function parentLabelFunctionHandler(param1:Event) : void
      {
         labelFunction = parentMenu.labelFunction;
      }
      
      private function getRowIndex(param1:IListItemRenderer) : int
      {
         var _loc3_:IListItemRenderer = null;
         var _loc2_:int = 0;
         while(_loc2_ < listItems.length)
         {
            _loc3_ = listItems[_loc2_][0];
            if(_loc3_ && _loc3_.data && _dataDescriptor.getType(_loc3_.data) != "separator")
            {
               if(_loc3_ == param1)
               {
                  return _loc2_;
               }
            }
            _loc2_++;
         }
         return -1;
      }
      
      private function parentIconFunctionHandler(param1:Event) : void
      {
         iconFunction = parentMenu.iconFunction;
      }
      
      mx_internal function get subMenus() : Array
      {
         var _loc1_:Array = [];
         var _loc2_:int = 0;
         while(_loc2_ < listItems.length)
         {
            _loc1_.push(listItems[_loc2_][0].menu);
            _loc2_++;
         }
         return _loc1_;
      }
      
      override public function setFocus() : void
      {
         super.setFocus();
      }
      
      public function get hasRoot() : Boolean
      {
         return _hasRoot;
      }
      
      private function parentHideHandler(param1:FlexEvent) : void
      {
         visible = false;
      }
      
      override protected function initializeAccessibility() : void
      {
         if(createAccessibilityImplementation != null)
         {
            createAccessibilityImplementation(this);
         }
      }
      
      private function closeSubMenu(param1:mx.controls.Menu) : void
      {
         param1.hide();
         clearInterval(param1.closeTimer);
         param1.closeTimer = 0;
      }
      
      override protected function mouseOutHandler(param1:MouseEvent) : void
      {
         var _loc3_:Object = null;
         if(!enabled || !selectable || !visible)
         {
            return;
         }
         systemManager.removeEventListener(MouseEvent.MOUSE_UP,mouseUpHandler,true);
         var _loc2_:IListItemRenderer = mouseEventToItemRenderer(param1);
         if(!_loc2_)
         {
            return;
         }
         if(_loc2_ && _loc2_.data)
         {
            _loc3_ = _loc2_.data;
         }
         if(openSubMenuTimer)
         {
            clearInterval(openSubMenuTimer);
            openSubMenuTimer = 0;
         }
         if(itemRendererContains(_loc2_,param1.relatedObject) || itemRendererContains(_loc2_,DisplayObject(param1.target)) || param1.relatedObject == highlightIndicator || param1.relatedObject == listContent || !highlightItemRenderer)
         {
            return;
         }
         if(getStyle("useRollOver") && _loc3_)
         {
            clearHighlight(_loc2_);
         }
      }
      
      override public function get horizontalScrollPolicy() : String
      {
         return ScrollPolicy.OFF;
      }
      
      private function mouseDownOutsideHandler(param1:Event) : void
      {
         var _loc2_:MouseEvent = null;
         if(param1 is MouseEvent)
         {
            _loc2_ = MouseEvent(param1);
            if(!isMouseOverMenu(_loc2_) && !isMouseOverMenuBarItem(_loc2_))
            {
               hideAllMenus();
            }
         }
         else if(param1 is SandboxMouseEvent)
         {
            hideAllMenus();
         }
      }
      
      override protected function configureScrollBars() : void
      {
      }
      
      public function get dataDescriptor() : IMenuDataDescriptor
      {
         return IMenuDataDescriptor(_dataDescriptor);
      }
      
      override public function get dataProvider() : Object
      {
         var _loc1_:* = super.dataProvider;
         if(_loc1_ == null)
         {
            if(_rootModel != null)
            {
               return _rootModel;
            }
            return null;
         }
         return _loc1_;
      }
      
      override public function styleChanged(param1:String) : void
      {
         super.styleChanged(param1);
         deleteDependentSubMenus();
      }
      
      mx_internal function onTweenUpdate(param1:Object) : void
      {
         scrollRect = new Rectangle(0,0,param1[0],param1[1]);
      }
      
      override protected function commitProperties() : void
      {
         var _loc1_:ICollectionView = null;
         var _loc2_:* = undefined;
         if(showRootChanged)
         {
            if(!_hasRoot)
            {
               showRootChanged = false;
            }
         }
         if(dataProviderChanged || showRootChanged)
         {
            dataProviderChanged = false;
            showRootChanged = false;
            if(_rootModel && !_showRoot && _hasRoot)
            {
               _loc2_ = _rootModel.createCursor().current;
               if(_loc2_ != null && _dataDescriptor.isBranch(_loc2_,_rootModel) && _dataDescriptor.hasChildren(_loc2_,_rootModel))
               {
                  _loc1_ = _dataDescriptor.getChildren(_loc2_,_rootModel);
               }
            }
            if(_listDataProvider)
            {
               _listDataProvider.removeEventListener(CollectionEvent.COLLECTION_CHANGE,collectionChangeHandler,false);
            }
            if(_rootModel)
            {
               if(!_loc1_)
               {
                  _loc1_ = _rootModel;
               }
               _listDataProvider = _loc1_;
               super.dataProvider = _loc1_;
               _listDataProvider.addEventListener(CollectionEvent.COLLECTION_CHANGE,collectionChangeHandler,false,EventPriority.DEFAULT_HANDLER,true);
            }
            else
            {
               _listDataProvider = null;
               super.dataProvider = null;
            }
         }
         super.commitProperties();
      }
      
      private function parentIconFieldHandler(param1:Event) : void
      {
         iconField = parentMenu.iconField;
      }
      
      mx_internal function getRootMenu() : mx.controls.Menu
      {
         var _loc1_:mx.controls.Menu = this;
         while(_loc1_.parentMenu)
         {
            _loc1_ = _loc1_.parentMenu;
         }
         return _loc1_;
      }
      
      override protected function mouseClickHandler(param1:MouseEvent) : void
      {
      }
      
      override public function set verticalScrollPolicy(param1:String) : void
      {
      }
      
      override mx_internal function clearHighlight(param1:IListItemRenderer) : void
      {
         var _loc4_:MenuEvent = null;
         var _loc2_:String = itemToUID(param1.data);
         drawItem(visibleData[_loc2_],isItemSelected(param1.data),false,_loc2_ == caretUID);
         var _loc3_:Point = itemRendererToIndices(param1);
         if(_loc3_)
         {
            _loc4_ = new MenuEvent(MenuEvent.ITEM_ROLL_OUT);
            _loc4_.menu = this;
            _loc4_.index = getRowIndex(param1);
            _loc4_.menuBar = sourceMenuBar;
            _loc4_.label = itemToLabel(param1.data);
            _loc4_.item = param1.data;
            _loc4_.itemRenderer = param1;
            getRootMenu().dispatchEvent(_loc4_);
         }
      }
      
      override protected function mouseOverHandler(param1:MouseEvent) : void
      {
         var item:Object = null;
         var menuEvent:MenuEvent = null;
         var event:MouseEvent = param1;
         if(!enabled || !selectable || !visible)
         {
            return;
         }
         systemManager.addEventListener(MouseEvent.MOUSE_UP,mouseUpHandler,true,0,true);
         var row:IListItemRenderer = mouseEventToItemRenderer(event);
         if(!row)
         {
            return;
         }
         if(row && row.data)
         {
            item = row.data;
         }
         isPressed = event.buttonDown;
         if(row && row != anchorRow)
         {
            if(anchorRow)
            {
               drawItem(anchorRow,false,false);
            }
            if(subMenu)
            {
               subMenu.supposedToLoseFocus = true;
               subMenu.closeTimer = setTimeout(closeSubMenu,250,subMenu);
            }
            subMenu = null;
            anchorRow = null;
         }
         else if(subMenu && subMenu.subMenu)
         {
            subMenu.subMenu.hide();
         }
         if(_dataDescriptor.isBranch(item) && _dataDescriptor.isEnabled(item))
         {
            anchorRow = row;
            if(subMenu && subMenu.closeTimer)
            {
               clearInterval(subMenu.closeTimer);
               subMenu.closeTimer = 0;
            }
            if(!subMenu || !subMenu.visible)
            {
               if(openSubMenuTimer)
               {
                  clearInterval(openSubMenuTimer);
               }
               openSubMenuTimer = setTimeout(function(param1:IListItemRenderer):void
               {
                  openSubMenu(param1);
               },250,row);
            }
         }
         if(item && _dataDescriptor.isEnabled(item))
         {
            if(event.relatedObject)
            {
               if(itemRendererContains(row,event.relatedObject) || row == lastHighlightItemRenderer || event.relatedObject == highlightIndicator)
               {
                  return;
               }
            }
         }
         if(row)
         {
            drawItem(row,false,Boolean(item && _dataDescriptor.isEnabled(item)));
            if(isPressed)
            {
               if(item && _dataDescriptor.isEnabled(item))
               {
                  if(!_dataDescriptor.isBranch(item))
                  {
                     selectItem(row,event.shiftKey,event.ctrlKey);
                  }
                  else
                  {
                     clearSelected();
                  }
               }
            }
            if(item && _dataDescriptor.isEnabled(item))
            {
               menuEvent = new MenuEvent(MenuEvent.ITEM_ROLL_OVER);
               menuEvent.menu = this;
               menuEvent.index = getRowIndex(row);
               menuEvent.menuBar = sourceMenuBar;
               menuEvent.label = itemToLabel(item);
               menuEvent.item = item;
               menuEvent.itemRenderer = row;
               getRootMenu().dispatchEvent(menuEvent);
            }
         }
      }
      
      override public function get verticalScrollPolicy() : String
      {
         return ScrollPolicy.OFF;
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         super.updateDisplayList(param1,param2);
         border.move(0,0);
         border.visible = dataProvider != null && dataProvider.length > 0;
         if(hiddenItem)
         {
            hiddenItem.setActualSize(param1,hiddenItem.getExplicitOrMeasuredHeight());
         }
      }
      
      private function isMouseOverMenuBarItem(param1:MouseEvent) : Boolean
      {
         if(!sourceMenuBarItem)
         {
            return false;
         }
         var _loc2_:DisplayObject = DisplayObject(param1.target);
         while(_loc2_)
         {
            if(_loc2_ == sourceMenuBarItem)
            {
               return true;
            }
            _loc2_ = _loc2_.parent;
         }
         return false;
      }
      
      public function show(param1:Object = null, param2:Object = null) : void
      {
         var _loc7_:Rectangle = null;
         var _loc8_:Point = null;
         var _loc9_:Number = NaN;
         var _loc10_:InterManagerRequest = null;
         if(collection && collection.length == 0)
         {
            return;
         }
         if(parentMenu && !parentMenu.visible)
         {
            return;
         }
         if(visible)
         {
            return;
         }
         if(parentDisplayObject && (!parent || !parent.contains(parentDisplayObject)))
         {
            PopUpManager.addPopUp(this,parentDisplayObject,false);
            addEventListener(MenuEvent.MENU_HIDE,menuHideHandler,false,EventPriority.DEFAULT_HANDLER);
         }
         var _loc3_:MenuEvent = new MenuEvent(MenuEvent.MENU_SHOW);
         _loc3_.menu = this;
         _loc3_.menuBar = sourceMenuBar;
         getRootMenu().dispatchEvent(_loc3_);
         systemManager.activate(this);
         if(param1 !== null && !isNaN(Number(param1)))
         {
            x = Number(param1);
         }
         if(param2 !== null && !isNaN(Number(param2)))
         {
            y = Number(param2);
         }
         var _loc4_:ISystemManager = systemManager.topLevelSystemManager;
         var _loc5_:DisplayObject = _loc4_.getSandboxRoot();
         if(this != getRootMenu())
         {
            _loc8_ = new Point(x,y);
            _loc8_ = _loc5_.localToGlobal(_loc8_);
            if(_loc4_ != _loc5_)
            {
               _loc10_ = new InterManagerRequest(InterManagerRequest.SYSTEM_MANAGER_REQUEST,false,false,"getVisibleApplicationRect");
               _loc5_.dispatchEvent(_loc10_);
               _loc7_ = Rectangle(_loc10_.value);
            }
            else
            {
               _loc7_ = _loc4_.getVisibleApplicationRect();
            }
            _loc9_ = _loc8_.x + width - _loc7_.right;
            if(_loc9_ > 0)
            {
               x = Math.max(x - _loc9_,0);
            }
            _loc9_ = _loc8_.y + height - _loc7_.bottom;
            if(_loc9_ > 0)
            {
               y = Math.max(y - _loc9_,0);
            }
         }
         UIComponentGlobals.layoutManager.validateClient(this,true);
         setActualSize(getExplicitOrMeasuredWidth(),getExplicitOrMeasuredHeight());
         cacheAsBitmap = true;
         var _loc6_:Number = getStyle("openDuration");
         if(_loc6_ != 0)
         {
            scrollRect = new Rectangle(0,0,unscaledWidth,0);
            visible = true;
            UIComponentGlobals.layoutManager.validateNow();
            UIComponent.suspendBackgroundProcessing();
            popupTween = new Tween(this,[0,0],[unscaledWidth,unscaledHeight],_loc6_);
         }
         else
         {
            UIComponentGlobals.layoutManager.validateNow();
            visible = true;
         }
         focusManager.setFocus(this);
         supposedToLoseFocus = true;
         _loc5_.addEventListener(MouseEvent.MOUSE_DOWN,mouseDownOutsideHandler,false,0,true);
         addEventListener(SandboxMouseEvent.MOUSE_DOWN_SOMEWHERE,mouseDownOutsideHandler,false,0,true);
      }
      
      public function set showRoot(param1:Boolean) : void
      {
         if(_showRoot != param1)
         {
            _showRoot = param1;
            showRootChanged = true;
            invalidateProperties();
         }
      }
   }
}
