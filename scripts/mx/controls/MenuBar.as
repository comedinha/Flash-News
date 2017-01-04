package mx.controls
{
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.ui.Keyboard;
   import flash.xml.XMLNode;
   import mx.collections.ArrayCollection;
   import mx.collections.ICollectionView;
   import mx.collections.IViewCursor;
   import mx.collections.XMLListCollection;
   import mx.collections.errors.ItemPendingError;
   import mx.containers.ApplicationControlBar;
   import mx.controls.menuClasses.IMenuBarItemRenderer;
   import mx.controls.menuClasses.IMenuDataDescriptor;
   import mx.controls.menuClasses.MenuBarItem;
   import mx.controls.treeClasses.DefaultDataDescriptor;
   import mx.core.ClassFactory;
   import mx.core.EventPriority;
   import mx.core.FlexVersion;
   import mx.core.IFactory;
   import mx.core.IFlexDisplayObject;
   import mx.core.IUIComponent;
   import mx.core.UIComponent;
   import mx.core.UIComponentGlobals;
   import mx.core.mx_internal;
   import mx.events.CollectionEvent;
   import mx.events.CollectionEventKind;
   import mx.events.FlexEvent;
   import mx.events.InterManagerRequest;
   import mx.events.MenuEvent;
   import mx.managers.IFocusManagerComponent;
   import mx.managers.ISystemManager;
   import mx.managers.PopUpManager;
   import mx.styles.CSSStyleDeclaration;
   import mx.styles.ISimpleStyleClient;
   import mx.styles.StyleManager;
   import mx.styles.StyleProxy;
   
   use namespace mx_internal;
   
   public class MenuBar extends UIComponent implements IFocusManagerComponent
   {
      
      mx_internal static var createAccessibilityImplementation:Function;
      
      private static const MARGIN_WIDTH:int = 10;
      
      mx_internal static const VERSION:String = "3.6.0.21751";
      
      private static var _menuBarItemStyleFilters:Object = null;
       
      
      private var dataProviderChanged:Boolean = false;
      
      public var menus:Array;
      
      private var _labelField:String = "label";
      
      private var menuBarItemRendererChanged:Boolean = false;
      
      private var _menuBarItemRenderer:IFactory;
      
      private var openMenuIndex:int = -1;
      
      public var menuBarItems:Array;
      
      private var _iconField:String = "icon";
      
      private var background:IFlexDisplayObject;
      
      mx_internal var showRootChanged:Boolean = false;
      
      private var inKeyDown:Boolean = false;
      
      private var isInsideACB:Boolean = false;
      
      mx_internal var _hasRoot:Boolean = false;
      
      mx_internal var _showRoot:Boolean = true;
      
      private var supposedToLoseFocus:Boolean = false;
      
      mx_internal var _dataDescriptor:IMenuDataDescriptor;
      
      mx_internal var _rootModel:ICollectionView;
      
      public var labelFunction:Function;
      
      private var iconFieldChanged:Boolean = false;
      
      private var isDown:Boolean;
      
      public function MenuBar()
      {
         _dataDescriptor = new DefaultDataDescriptor();
         menuBarItems = [];
         menus = [];
         super();
         menuBarItemRenderer = new ClassFactory(MenuBarItem);
         tabChildren = false;
      }
      
      private static function menuHideHandler(param1:MenuEvent) : void
      {
         var _loc2_:Menu = Menu(param1.target);
         if(!param1.isDefaultPrevented() && param1.menu == _loc2_)
         {
            _loc2_.supposedToLoseFocus = true;
            PopUpManager.removePopUp(_loc2_);
            _loc2_.removeEventListener(MenuEvent.MENU_HIDE,menuHideHandler);
         }
      }
      
      [Bindable("iconFieldChanged")]
      public function get iconField() : String
      {
         return _iconField;
      }
      
      override public function set enabled(param1:Boolean) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         super.enabled = param1;
         if(menuBarItems)
         {
            _loc2_ = menuBarItems.length;
            _loc3_ = 0;
            while(_loc3_ < _loc2_)
            {
               menuBarItems[_loc3_].enabled = param1;
               _loc3_++;
            }
         }
      }
      
      public function get showRoot() : Boolean
      {
         return _showRoot;
      }
      
      override public function set showInAutomationHierarchy(param1:Boolean) : void
      {
      }
      
      private function removeAll() : void
      {
         var _loc1_:IMenuBarItemRenderer = null;
         if(dataProviderChanged)
         {
            commitProperties();
         }
         while(menuBarItems.length > 0)
         {
            _loc1_ = menuBarItems[0];
            removeChild(DisplayObject(_loc1_));
            menuBarItems.splice(0,1);
         }
         menus = [];
         invalidateSize();
         invalidateDisplayList();
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         var _loc9_:IMenuBarItemRenderer = null;
         super.updateDisplayList(param1,param2);
         var _loc3_:Number = MARGIN_WIDTH;
         var _loc4_:Number = 0;
         var _loc5_:int = menuBarItems.length;
         var _loc6_:Boolean = false;
         var _loc7_:Boolean = param1 == 0 || param2 == 0;
         var _loc8_:int = 0;
         while(_loc8_ < _loc5_)
         {
            _loc9_ = menuBarItems[_loc8_];
            _loc9_.setActualSize(_loc9_.getExplicitOrMeasuredWidth(),param2);
            _loc9_.visible = !_loc7_;
            _loc3_ = _loc9_.x = _loc3_ + _loc4_;
            _loc4_ = _loc9_.width;
            if(!_loc7_ && (_loc9_.getExplicitOrMeasuredHeight() > param2 || _loc3_ + _loc4_ > param1))
            {
               _loc6_ = true;
            }
            _loc8_++;
         }
         if(background)
         {
            background.setActualSize(param1,param2);
            background.visible = !_loc7_;
         }
         scrollRect = !!_loc6_?new Rectangle(0,0,param1,param2):null;
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
         if(menuBarItems.length == 0)
         {
            return super.baselinePosition;
         }
         var _loc1_:IUIComponent = menuBarItems[0] as IUIComponent;
         if(!_loc1_)
         {
            return super.baselinePosition;
         }
         validateNow();
         return _loc1_.y + _loc1_.baselinePosition;
      }
      
      protected function get menuBarItemStyleFilters() : Object
      {
         return _menuBarItemStyleFilters;
      }
      
      public function set iconField(param1:String) : void
      {
         if(_iconField != param1)
         {
            iconFieldChanged = true;
            _iconField = param1;
            invalidateProperties();
            dispatchEvent(new Event("iconFieldChanged"));
         }
      }
      
      public function set menuBarItemRenderer(param1:IFactory) : void
      {
         if(_menuBarItemRenderer != param1)
         {
            _menuBarItemRenderer = param1;
            menuBarItemRendererChanged = true;
            invalidateProperties();
            dispatchEvent(new Event("menuBarItemRendererChanged"));
         }
      }
      
      public function get hasRoot() : Boolean
      {
         return _hasRoot;
      }
      
      override protected function initializeAccessibility() : void
      {
         if(MenuBar.createAccessibilityImplementation != null)
         {
            MenuBar.createAccessibilityImplementation(this);
         }
      }
      
      public function itemToIcon(param1:Object) : Class
      {
         var iconClass:Class = null;
         var icon:* = undefined;
         var data:Object = param1;
         if(data == null)
         {
            return null;
         }
         if(data is XML)
         {
            try
            {
               if(data[iconField].length() != 0)
               {
                  icon = String(data[iconField]);
                  if(icon != null)
                  {
                     iconClass = Class(systemManager.getDefinitionByName(icon));
                     if(iconClass)
                     {
                        return iconClass;
                     }
                     return document[icon];
                  }
               }
            }
            catch(e:Error)
            {
            }
         }
         else if(data is Object)
         {
            try
            {
               if(data[iconField] != null)
               {
                  if(data[iconField] is Class)
                  {
                     return data[iconField];
                  }
                  if(data[iconField] is String)
                  {
                     iconClass = Class(systemManager.getDefinitionByName(data[iconField]));
                     if(iconClass)
                     {
                        return iconClass;
                     }
                     return document[data[iconField]];
                  }
               }
            }
            catch(e:Error)
            {
            }
         }
         return null;
      }
      
      private function addMenuAt(param1:int, param2:Object, param3:Object = null) : void
      {
         var _loc4_:Menu = null;
         var _loc5_:Object = null;
         if(!dataProvider)
         {
            dataProvider = {};
         }
         var _loc6_:Object = param2;
         insertMenuBarItem(param1,_loc5_);
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         var _loc1_:Object = parent;
         while(_loc1_)
         {
            if(_loc1_ is ApplicationControlBar)
            {
               isInsideACB = true;
               break;
            }
            _loc1_ = _loc1_.parent;
         }
         updateBackground();
      }
      
      override protected function focusOutHandler(param1:FocusEvent) : void
      {
         super.focusOutHandler(param1);
         if(supposedToLoseFocus)
         {
            getMenuAt(openMenuIndex).hide();
         }
         supposedToLoseFocus = false;
      }
      
      public function itemToLabel(param1:Object) : String
      {
         var data:Object = param1;
         if(data == null)
         {
            return " ";
         }
         if(labelFunction != null)
         {
            return labelFunction(data);
         }
         if(data is XML)
         {
            try
            {
               if(data[labelField].length() != 0)
               {
                  data = data[labelField];
               }
            }
            catch(e:Error)
            {
            }
         }
         else if(data is Object)
         {
            try
            {
               if(data[labelField] != null)
               {
                  data = data[labelField];
               }
            }
            catch(e:Error)
            {
            }
         }
         else if(data is String)
         {
            return String(data);
         }
         try
         {
            return data.toString();
         }
         catch(e:Error)
         {
         }
         return " ";
      }
      
      private function mouseOutHandler(param1:MouseEvent) : void
      {
         var _loc5_:MenuEvent = null;
         var _loc2_:IMenuBarItemRenderer = IMenuBarItemRenderer(param1.target);
         var _loc3_:int = _loc2_.menuBarItemIndex;
         var _loc4_:Menu = getMenuAt(_loc3_);
         if(_loc2_.enabled && openMenuIndex != _loc3_)
         {
            menuBarItems[_loc3_].menuBarItemState = "itemUpSkin";
         }
         if(_loc2_.data && _loc4_.dataDescriptor.getType(_loc2_.data) != "separator")
         {
            _loc5_ = new MenuEvent(MenuEvent.ITEM_ROLL_OUT);
            _loc5_.index = _loc3_;
            _loc5_.menuBar = this;
            _loc5_.label = itemToLabel(_loc2_.data);
            _loc5_.item = _loc2_.data;
            _loc5_.itemRenderer = _loc2_;
            dispatchEvent(_loc5_);
         }
      }
      
      private function collectionChangeHandler(param1:Event) : void
      {
         var _loc2_:CollectionEvent = null;
         if(param1 is CollectionEvent)
         {
            _loc2_ = CollectionEvent(param1);
            if(_loc2_.kind == CollectionEventKind.ADD)
            {
               dataProviderChanged = true;
               invalidateProperties();
            }
            else if(_loc2_.kind == CollectionEventKind.REMOVE)
            {
               dataProviderChanged = true;
               invalidateProperties();
            }
            else if(_loc2_.kind == CollectionEventKind.REFRESH)
            {
               dataProviderChanged = true;
               dataProvider = dataProvider;
               invalidateProperties();
               invalidateSize();
            }
            else if(_loc2_.kind == CollectionEventKind.RESET)
            {
               dataProviderChanged = true;
               invalidateProperties();
               invalidateSize();
            }
            else if(_loc2_.kind == CollectionEventKind.UPDATE)
            {
               if(openMenuIndex == -1)
               {
                  dataProviderChanged = true;
                  invalidateProperties();
               }
            }
         }
         invalidateDisplayList();
      }
      
      override public function notifyStyleChangeInChildren(param1:String, param2:Boolean) : void
      {
         super.notifyStyleChangeInChildren(param1,param2);
         var _loc3_:int = menuBarItems.length;
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            getMenuAt(_loc4_).notifyStyleChangeInChildren(param1,param2);
            _loc4_++;
         }
      }
      
      private function mouseUpHandler(param1:MouseEvent) : void
      {
         var _loc2_:IMenuBarItemRenderer = IMenuBarItemRenderer(param1.target);
         var _loc3_:int = _loc2_.menuBarItemIndex;
         if(_loc2_.enabled && !isDown)
         {
            getMenuAt(_loc3_).hideAllMenus();
            _loc2_.menuBarItemState = "itemOverSkin";
         }
      }
      
      private function mouseDownHandler(param1:MouseEvent) : void
      {
         var _loc5_:ICollectionView = null;
         var _loc6_:MenuEvent = null;
         var _loc7_:MenuEvent = null;
         var _loc2_:IMenuBarItemRenderer = IMenuBarItemRenderer(param1.target);
         var _loc3_:int = _loc2_.menuBarItemIndex;
         var _loc4_:Menu = getMenuAt(_loc3_);
         if(_loc2_.enabled)
         {
            _loc2_.menuBarItemState = "itemDownSkin";
            if(!isDown)
            {
               _loc4_.supposedToLoseFocus = true;
               _loc5_ = ICollectionView(_loc4_.dataProvider);
               if(_loc4_.dataDescriptor.isBranch(_loc2_.data,_loc2_.data) && _loc4_.dataDescriptor.hasChildren(_loc2_.data,_loc2_.data))
               {
                  showMenu(_loc3_);
               }
               else if(_loc4_)
               {
                  selectedIndex = _loc3_;
                  _loc6_ = new MenuEvent(MenuEvent.MENU_SHOW);
                  _loc6_.menuBar = this;
                  _loc6_.menu = _loc4_;
                  dispatchEvent(_loc6_);
               }
               isDown = true;
            }
            else
            {
               isDown = false;
            }
            if(_loc4_.dataDescriptor.getType(_loc2_.data) != "separator")
            {
               _loc7_ = new MenuEvent(MenuEvent.CHANGE);
               _loc7_.index = _loc3_;
               _loc7_.menuBar = this;
               _loc7_.label = itemToLabel(_loc2_.data);
               _loc7_.item = _loc2_.data;
               _loc7_.itemRenderer = _loc2_;
               dispatchEvent(_loc7_);
            }
         }
      }
      
      public function get dataDescriptor() : IMenuDataDescriptor
      {
         return IMenuDataDescriptor(_dataDescriptor);
      }
      
      [Bindable("collectionChange")]
      public function get dataProvider() : Object
      {
         if(_rootModel)
         {
            return _rootModel;
         }
         return null;
      }
      
      private function showMenu(param1:Number) : void
      {
         var _loc6_:Rectangle = null;
         var _loc8_:InterManagerRequest = null;
         selectedIndex = param1;
         var _loc2_:IMenuBarItemRenderer = menuBarItems[param1];
         var _loc3_:Menu = getMenuAt(param1);
         var _loc4_:ISystemManager = systemManager.topLevelSystemManager;
         var _loc5_:DisplayObject = _loc4_.getSandboxRoot();
         if(_loc4_ != _loc5_)
         {
            _loc8_ = new InterManagerRequest(InterManagerRequest.SYSTEM_MANAGER_REQUEST,false,false,"getVisibleApplicationRect");
            _loc5_.dispatchEvent(_loc8_);
            _loc6_ = Rectangle(_loc8_.value);
         }
         else
         {
            _loc6_ = _loc4_.getVisibleApplicationRect();
         }
         if(_loc3_.parentDisplayObject && (!_loc3_.parent || !_loc3_.parent.contains(_loc3_.parentDisplayObject)))
         {
            PopUpManager.addPopUp(_loc3_,this,false);
            _loc3_.addEventListener(MenuEvent.MENU_HIDE,menuHideHandler,false,EventPriority.DEFAULT_HANDLER);
         }
         UIComponentGlobals.layoutManager.validateClient(_loc3_,true);
         var _loc7_:Point = new Point(0,0);
         _loc7_ = DisplayObject(_loc2_).localToGlobal(_loc7_);
         if(_loc7_.y + _loc2_.height + 1 + _loc3_.getExplicitOrMeasuredHeight() > _loc6_.height + _loc6_.y)
         {
            _loc7_.y = _loc7_.y - _loc3_.getExplicitOrMeasuredHeight();
         }
         else
         {
            _loc7_.y = _loc7_.y + (_loc2_.height + 1);
         }
         if(_loc7_.x + _loc3_.getExplicitOrMeasuredWidth() > _loc6_.width + _loc6_.x)
         {
            _loc7_.x = _loc6_.x + _loc6_.width - _loc3_.getExplicitOrMeasuredWidth();
         }
         _loc7_ = _loc5_.globalToLocal(_loc7_);
         if(isInsideACB)
         {
            _loc7_.y = _loc7_.y + 2;
         }
         _loc3_.show(_loc7_.x,_loc7_.y);
      }
      
      [Bindable("menuBarItemRendererChanged")]
      public function get menuBarItemRenderer() : IFactory
      {
         return _menuBarItemRenderer;
      }
      
      public function getMenuAt(param1:int) : Menu
      {
         var _loc5_:Object = null;
         var _loc6_:CSSStyleDeclaration = null;
         if(dataProviderChanged)
         {
            commitProperties();
         }
         var _loc2_:IMenuBarItemRenderer = menuBarItems[param1];
         var _loc3_:Object = _loc2_.data;
         var _loc4_:Menu = menus[param1];
         if(_loc4_ == null)
         {
            _loc4_ = new Menu();
            _loc4_.showRoot = false;
            if(FlexVersion.compatibilityVersion < FlexVersion.VERSION_3_0)
            {
               _loc4_.styleName = this;
            }
            _loc5_ = getStyle("menuStyleName");
            if(_loc5_)
            {
               if(FlexVersion.compatibilityVersion < FlexVersion.VERSION_3_0)
               {
                  _loc6_ = StyleManager.getStyleDeclaration("." + _loc5_);
                  if(_loc6_)
                  {
                     _loc4_.styleDeclaration = _loc6_;
                  }
               }
               else
               {
                  _loc4_.styleName = _loc5_;
               }
            }
            _loc4_.sourceMenuBar = this;
            _loc4_.owner = this;
            _loc4_.addEventListener("menuHide",eventHandler);
            _loc4_.addEventListener("itemRollOver",eventHandler);
            _loc4_.addEventListener("itemRollOut",eventHandler);
            _loc4_.addEventListener("menuShow",eventHandler);
            _loc4_.addEventListener("itemClick",eventHandler);
            _loc4_.addEventListener("change",eventHandler);
            _loc4_.iconField = _iconField;
            _loc4_.labelField = _labelField;
            _loc4_.labelFunction = labelFunction;
            _loc4_.dataDescriptor = _dataDescriptor;
            _loc4_.invalidateSize();
            menus[param1] = _loc4_;
            _loc4_.sourceMenuBarItem = _loc2_;
            Menu.popUpMenu(_loc4_,this,_loc3_);
         }
         return _loc4_;
      }
      
      public function set labelField(param1:String) : void
      {
         if(_labelField != param1)
         {
            _labelField = param1;
            dispatchEvent(new Event("labelFieldChanged"));
         }
      }
      
      override protected function commitProperties() : void
      {
         var i:int = 0;
         var cursor:IViewCursor = null;
         var tmpCollection:ICollectionView = null;
         var rootItem:* = undefined;
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
               rootItem = _rootModel.createCursor().current;
               if(rootItem != null && _dataDescriptor.isBranch(rootItem,_rootModel) && _dataDescriptor.hasChildren(rootItem,_rootModel))
               {
                  tmpCollection = _dataDescriptor.getChildren(rootItem,_rootModel);
               }
            }
            removeAll();
            if(_rootModel)
            {
               if(!tmpCollection)
               {
                  tmpCollection = _rootModel;
               }
               tmpCollection.addEventListener(CollectionEvent.COLLECTION_CHANGE,collectionChangeHandler,false,EventPriority.DEFAULT_HANDLER,true);
               if(tmpCollection.length > 0)
               {
                  cursor = tmpCollection.createCursor();
                  i = 0;
                  while(!cursor.afterLast)
                  {
                     try
                     {
                        insertMenuBarItem(i,cursor.current);
                     }
                     catch(e:ItemPendingError)
                     {
                     }
                     cursor.moveNext();
                     i++;
                  }
               }
            }
         }
         if(iconFieldChanged || menuBarItemRendererChanged)
         {
            iconFieldChanged = false;
            menuBarItemRendererChanged = false;
            removeAll();
            if(_rootModel)
            {
               if(!tmpCollection)
               {
                  tmpCollection = _rootModel;
               }
               if(tmpCollection.length > 0)
               {
                  cursor = tmpCollection.createCursor();
                  i = 0;
                  while(!cursor.afterLast)
                  {
                     try
                     {
                        insertMenuBarItem(i,cursor.current);
                     }
                     catch(e:ItemPendingError)
                     {
                     }
                     cursor.moveNext();
                     i++;
                  }
               }
            }
         }
         super.commitProperties();
      }
      
      override public function styleChanged(param1:String) : void
      {
         var _loc2_:int = 0;
         var _loc4_:String = null;
         var _loc5_:Menu = null;
         var _loc6_:CSSStyleDeclaration = null;
         super.styleChanged(param1);
         var _loc3_:int = menuBarItems.length;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            getMenuAt(_loc2_).styleChanged(param1);
            _loc2_++;
         }
         if(!param1 || param1 == "" || param1 == "backgroundSkin")
         {
            updateBackground();
         }
         if(param1 == null || param1 == "styleName" || param1 == "menuStyleName")
         {
            _loc4_ = getStyle("menuStyleName");
            if(_loc4_)
            {
               if(FlexVersion.compatibilityVersion < FlexVersion.VERSION_3_0)
               {
                  _loc6_ = StyleManager.getStyleDeclaration("." + _loc4_);
                  if(_loc6_)
                  {
                     _loc2_ = 0;
                     while(_loc2_ < menus.length)
                     {
                        _loc5_ = menus[_loc2_];
                        _loc5_.styleDeclaration = _loc6_;
                        _loc5_.regenerateStyleCache(true);
                        _loc2_++;
                     }
                  }
               }
               else
               {
                  _loc2_ = 0;
                  while(_loc2_ < menus.length)
                  {
                     _loc5_ = menus[_loc2_];
                     _loc5_.styleName = _loc4_;
                     _loc2_++;
                  }
               }
            }
         }
      }
      
      private function removeMenuBarItemAt(param1:int) : void
      {
         if(dataProviderChanged)
         {
            commitProperties();
         }
         var _loc2_:IMenuBarItemRenderer = menuBarItems[param1];
         if(_loc2_)
         {
            removeChild(DisplayObject(_loc2_));
            menuBarItems.splice(param1,1);
            invalidateSize();
            invalidateDisplayList();
         }
      }
      
      protected function updateBackground() : void
      {
         var _loc1_:Class = null;
         if(isInsideACB)
         {
            setStyle("translucent",true);
         }
         else
         {
            if(background)
            {
               removeChild(DisplayObject(background));
               background = null;
            }
            _loc1_ = getStyle("backgroundSkin");
            background = new _loc1_();
            if(background is ISimpleStyleClient)
            {
               ISimpleStyleClient(background).styleName = this;
            }
            addChildAt(DisplayObject(background),0);
         }
      }
      
      override protected function measure() : void
      {
         var _loc1_:int = 0;
         super.measure();
         _loc1_ = menuBarItems.length;
         measuredWidth = 0;
         measuredHeight = DEFAULT_MEASURED_MIN_HEIGHT;
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            measuredWidth = measuredWidth + menuBarItems[_loc2_].getExplicitOrMeasuredWidth();
            measuredHeight = Math.max(measuredHeight,menuBarItems[_loc2_].getExplicitOrMeasuredHeight());
            _loc2_++;
         }
         if(_loc1_ > 0)
         {
            measuredWidth = measuredWidth + 2 * MARGIN_WIDTH;
         }
         else
         {
            measuredWidth = DEFAULT_MEASURED_MIN_WIDTH;
         }
         measuredMinWidth = measuredWidth;
         measuredMinHeight = measuredHeight;
      }
      
      override protected function keyDownHandler(param1:KeyboardEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:Boolean = false;
         var _loc5_:int = 0;
         var _loc6_:Menu = null;
         var _loc7_:ICollectionView = null;
         var _loc8_:IMenuBarItemRenderer = null;
         var _loc2_:int = menuBarItems.length;
         if(param1.keyCode == Keyboard.RIGHT || param1.keyCode == Keyboard.LEFT)
         {
            inKeyDown = true;
            _loc3_ = openMenuIndex;
            _loc4_ = false;
            _loc5_ = 0;
            while(!_loc4_ && _loc5_ < _loc2_)
            {
               _loc5_++;
               _loc3_ = param1.keyCode == Keyboard.RIGHT?int(_loc3_ + 1):int(_loc3_ - 1);
               if(_loc3_ >= _loc2_)
               {
                  _loc3_ = 0;
               }
               else if(_loc3_ < 0)
               {
                  _loc3_ = _loc2_ - 1;
               }
               if(menuBarItems[_loc3_].enabled)
               {
                  _loc4_ = true;
               }
            }
            if(_loc5_ <= _loc2_ && _loc4_)
            {
               menuBarItems[_loc3_].dispatchEvent(new MouseEvent(MouseEvent.MOUSE_OVER));
            }
            param1.stopPropagation();
         }
         if(param1.keyCode == Keyboard.DOWN)
         {
            if(openMenuIndex != -1)
            {
               _loc6_ = getMenuAt(openMenuIndex);
               _loc6_.selectedIndex = 0;
               supposedToLoseFocus = true;
               _loc7_ = ICollectionView(_loc6_.dataProvider);
               _loc8_ = _loc6_.sourceMenuBarItem;
               if(_loc6_.dataDescriptor.isBranch(_loc8_.data,_loc8_.data) && _loc6_.dataDescriptor.hasChildren(_loc8_.data,_loc8_.data))
               {
                  _loc6_.setFocus();
               }
            }
            param1.stopPropagation();
         }
         if(param1.keyCode == Keyboard.ENTER || param1.keyCode == Keyboard.ESCAPE)
         {
            if(openMenuIndex != -1)
            {
               getMenuAt(openMenuIndex).hide();
            }
            param1.stopPropagation();
         }
      }
      
      [Bindable("labelFieldChanged")]
      public function get labelField() : String
      {
         return _labelField;
      }
      
      public function set selectedIndex(param1:int) : void
      {
         openMenuIndex = param1;
         dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));
      }
      
      private function mouseOverHandler(param1:MouseEvent) : void
      {
         var _loc6_:MenuEvent = null;
         var _loc7_:Number = NaN;
         var _loc8_:ICollectionView = null;
         var _loc9_:IMenuBarItemRenderer = null;
         var _loc10_:Menu = null;
         var _loc2_:IMenuBarItemRenderer = IMenuBarItemRenderer(param1.target);
         var _loc3_:int = _loc2_.menuBarItemIndex;
         var _loc4_:Boolean = false;
         var _loc5_:Menu = getMenuAt(_loc3_);
         if(_loc2_.enabled)
         {
            if(openMenuIndex != -1 || inKeyDown)
            {
               _loc7_ = openMenuIndex;
               if(_loc7_ != _loc3_)
               {
                  isDown = false;
                  if(_loc7_ != -1)
                  {
                     _loc9_ = menuBarItems[_loc7_];
                     _loc9_.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_UP));
                     _loc9_.menuBarItemState = "itemUpSkin";
                     _loc6_ = new MenuEvent(MenuEvent.ITEM_ROLL_OUT);
                     _loc6_.menuBar = this;
                     _loc6_.index = _loc7_;
                     _loc6_.label = itemToLabel(_loc9_.data);
                     _loc6_.item = _loc9_.data;
                     _loc6_.itemRenderer = _loc9_;
                     dispatchEvent(_loc6_);
                  }
                  _loc2_.menuBarItemState = "itemDownSkin";
                  _loc8_ = ICollectionView(_loc5_.dataProvider);
                  if(_loc5_.dataDescriptor.isBranch(_loc2_.data,_loc2_.data) && _loc5_.dataDescriptor.hasChildren(_loc2_.data,_loc2_.data))
                  {
                     showMenu(_loc3_);
                  }
                  else if(_loc5_)
                  {
                     selectedIndex = _loc3_;
                     _loc6_ = new MenuEvent(MenuEvent.MENU_SHOW);
                     _loc6_.menuBar = this;
                     _loc6_.menu = _loc5_;
                     dispatchEvent(_loc6_);
                     _loc2_.menuBarItemState = "itemOverSkin";
                  }
                  isDown = true;
                  if(_loc5_.dataDescriptor.getType(_loc2_.data) != "separator")
                  {
                     _loc4_ = true;
                     _loc6_ = new MenuEvent(MenuEvent.CHANGE);
                     _loc6_.index = _loc3_;
                     _loc6_.menuBar = this;
                     _loc6_.label = itemToLabel(_loc2_.data);
                     _loc6_.item = _loc2_.data;
                     _loc6_.itemRenderer = _loc2_;
                     dispatchEvent(_loc6_);
                  }
               }
               else
               {
                  _loc10_ = getMenuAt(_loc3_);
                  _loc10_.deleteDependentSubMenus();
                  _loc10_.setFocus();
               }
            }
            else
            {
               _loc2_.menuBarItemState = "itemOverSkin";
               isDown = false;
               if(_loc5_.dataDescriptor.getType(_loc2_.data) != "separator")
               {
                  _loc4_ = true;
               }
            }
            inKeyDown = false;
            if(_loc4_)
            {
               _loc6_ = new MenuEvent(MenuEvent.ITEM_ROLL_OVER);
               _loc6_.index = _loc3_;
               _loc6_.menuBar = this;
               _loc6_.label = itemToLabel(_loc2_.data);
               _loc6_.item = _loc2_.data;
               _loc6_.itemRenderer = _loc2_;
               dispatchEvent(_loc6_);
            }
         }
      }
      
      public function set dataDescriptor(param1:IMenuDataDescriptor) : void
      {
         _dataDescriptor = param1;
         menus = [];
      }
      
      private function insertMenuBarItem(param1:int, param2:Object) : void
      {
         if(dataProviderChanged)
         {
            commitProperties();
            return;
         }
         var _loc3_:IMenuBarItemRenderer = menuBarItemRenderer.newInstance();
         _loc3_.styleName = new StyleProxy(this,menuBarItemStyleFilters);
         _loc3_.visible = false;
         _loc3_.enabled = enabled && _dataDescriptor.isEnabled(param2) != false;
         _loc3_.data = param2;
         _loc3_.menuBar = this;
         _loc3_.menuBarItemIndex = param1;
         addChild(DisplayObject(_loc3_));
         menuBarItems.splice(param1,0,_loc3_);
         invalidateSize();
         invalidateDisplayList();
         _loc3_.addEventListener(MouseEvent.MOUSE_OVER,mouseOverHandler);
         _loc3_.addEventListener(MouseEvent.MOUSE_DOWN,mouseDownHandler);
         _loc3_.addEventListener(MouseEvent.MOUSE_UP,mouseUpHandler);
         _loc3_.addEventListener(MouseEvent.MOUSE_OUT,mouseOutHandler);
      }
      
      public function set dataProvider(param1:Object) : void
      {
         var _loc3_:XMLList = null;
         var _loc4_:Array = null;
         if(_rootModel)
         {
            _rootModel.removeEventListener(CollectionEvent.COLLECTION_CHANGE,collectionChangeHandler);
         }
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
            _loc3_ = new XMLList();
            _loc3_ = _loc3_ + param1;
            _rootModel = new XMLListCollection(_loc3_);
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
            _loc4_ = [];
            _loc4_.push(param1);
            _rootModel = new ArrayCollection(_loc4_);
         }
         else
         {
            _rootModel = new ArrayCollection();
         }
         _rootModel.addEventListener(CollectionEvent.COLLECTION_CHANGE,collectionChangeHandler,false,0,true);
         dataProviderChanged = true;
         invalidateProperties();
         var _loc2_:CollectionEvent = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE);
         _loc2_.kind = CollectionEventKind.RESET;
         collectionChangeHandler(_loc2_);
         dispatchEvent(_loc2_);
      }
      
      [Bindable("valueCommit")]
      public function get selectedIndex() : int
      {
         return openMenuIndex;
      }
      
      override protected function focusInHandler(param1:FocusEvent) : void
      {
         super.focusInHandler(param1);
      }
      
      private function eventHandler(param1:Event) : void
      {
         var _loc2_:String = null;
         if(param1 is MenuEvent)
         {
            _loc2_ = param1.type;
            if(param1.type == MenuEvent.MENU_HIDE && MenuEvent(param1).menu == menus[openMenuIndex])
            {
               menuBarItems[openMenuIndex].menuBarItemState = "itemUpSkin";
               openMenuIndex = -1;
               dispatchEvent(param1 as MenuEvent);
            }
            else
            {
               dispatchEvent(param1);
            }
         }
      }
      
      public function set showRoot(param1:Boolean) : void
      {
         if(_showRoot != param1)
         {
            showRootChanged = true;
            _showRoot = param1;
            invalidateProperties();
         }
      }
   }
}
