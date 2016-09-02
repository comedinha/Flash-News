package mx.controls
{
   import mx.containers.Box;
   import mx.core.mx_internal;
   import mx.core.Container;
   import mx.events.IndexChangedEvent;
   import mx.core.FlexVersion;
   import flash.events.Event;
   import flash.display.DisplayObject;
   import mx.collections.IList;
   import flash.events.MouseEvent;
   import mx.events.ItemClickEvent;
   import flash.display.InteractiveObject;
   import mx.core.ScrollPolicy;
   import mx.events.ChildExistenceChangedEvent;
   import mx.containers.ViewStack;
   import mx.core.UIComponent;
   import mx.core.IFlexDisplayObject;
   import mx.core.IFactory;
   import mx.events.CollectionEvent;
   import mx.collections.ArrayCollection;
   import mx.events.FlexEvent;
   import mx.core.ClassFactory;
   import mx.containers.BoxDirection;
   
   use namespace mx_internal;
   
   public class NavBar extends Box
   {
      
      mx_internal static const VERSION:String = "3.6.0.21751";
       
      
      private var _labelField:String = "label";
      
      private var _iconField:String = "icon";
      
      private var _dataProvider:IList;
      
      private var measurementHasBeenCalled:Boolean = false;
      
      private var _toolTipField:String = "toolTip";
      
      mx_internal var navItemFactory:IFactory;
      
      private var pendingTargetStack:Object;
      
      private var lastToolTip:String = null;
      
      private var _labelFunction:Function;
      
      mx_internal var targetStack:ViewStack;
      
      private var _selectedIndex:int = -1;
      
      private var dataProviderChanged:Boolean = false;
      
      public function NavBar()
      {
         navItemFactory = new ClassFactory(Button);
         super();
         direction = BoxDirection.HORIZONTAL;
         showInAutomationHierarchy = true;
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
         if(param1 != enabled)
         {
            super.enabled = param1;
            _loc2_ = numChildren;
            _loc3_ = 0;
            while(_loc3_ < _loc2_)
            {
               if(targetStack)
               {
                  Button(getChildAt(_loc3_)).enabled = param1 && Container(targetStack.getChildAt(_loc3_)).enabled;
               }
               else
               {
                  Button(getChildAt(_loc3_)).enabled = param1;
               }
               _loc3_++;
            }
         }
      }
      
      protected function updateNavItemIcon(param1:int, param2:Class) : void
      {
         var _loc3_:Button = Button(getChildAt(param1));
         _loc3_.setStyle("icon",param2);
      }
      
      private function childIndexChangeHandler(param1:IndexChangedEvent) : void
      {
         if(param1.target == this)
         {
            return;
         }
         setChildIndex(getChildAt(param1.oldIndex),param1.newIndex);
         resetNavItems();
      }
      
      protected function hiliteSelectedNavItem(param1:int) : void
      {
      }
      
      private function checkPendingTargetStack() : void
      {
         if(pendingTargetStack)
         {
            _setTargetViewStack(pendingTargetStack);
            pendingTargetStack = null;
         }
      }
      
      private function setTargetViewStack(param1:Object) : void
      {
         if(!measurementHasBeenCalled && param1)
         {
            pendingTargetStack = param1;
            invalidateProperties();
         }
         else
         {
            _setTargetViewStack(param1);
         }
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
         if(numChildren == 0)
         {
            return super.baselinePosition;
         }
         var _loc1_:Button = Button(getChildAt(0));
         validateNow();
         return _loc1_.y + _loc1_.baselinePosition;
      }
      
      private function enabledChangedHandler(param1:Event) : void
      {
         var _loc2_:int = targetStack.getChildIndex(DisplayObject(param1.target));
         Button(getChildAt(_loc2_)).enabled = enabled && param1.target.enabled;
      }
      
      private function labelChangedHandler(param1:Event) : void
      {
         var _loc2_:int = targetStack.getChildIndex(DisplayObject(param1.target));
         updateNavItemLabel(_loc2_,Container(param1.target).label);
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         if(dataProviderChanged)
         {
            createNavChildren();
            dataProviderChanged = false;
         }
      }
      
      override public function notifyStyleChangeInChildren(param1:String, param2:Boolean) : void
      {
         super.notifyStyleChangeInChildren(param1,true);
      }
      
      protected function clickHandler(param1:MouseEvent) : void
      {
         var _loc2_:int = getChildIndex(DisplayObject(param1.currentTarget));
         if(targetStack)
         {
            targetStack.selectedIndex = _loc2_;
         }
         _selectedIndex = _loc2_;
         var _loc3_:ItemClickEvent = new ItemClickEvent(ItemClickEvent.ITEM_CLICK);
         _loc3_.label = Button(param1.currentTarget).label;
         _loc3_.index = _loc2_;
         _loc3_.relatedObject = InteractiveObject(param1.currentTarget);
         _loc3_.item = !!_dataProvider?_dataProvider.getItemAt(_loc2_):null;
         dispatchEvent(_loc3_);
         param1.stopImmediatePropagation();
      }
      
      override public function get horizontalScrollPolicy() : String
      {
         return ScrollPolicy.OFF;
      }
      
      public function set iconField(param1:String) : void
      {
         _iconField = param1;
         if(_dataProvider)
         {
            dataProvider = _dataProvider;
         }
         dispatchEvent(new Event("iconFieldChanged"));
      }
      
      private function childAddHandler(param1:ChildExistenceChangedEvent) : void
      {
         if(param1.target == this)
         {
            return;
         }
         if(param1.relatedObject.parent != targetStack)
         {
            return;
         }
         var _loc2_:Container = Container(param1.relatedObject);
         var _loc3_:Button = Button(createNavItem(itemToLabel(_loc2_),_loc2_.icon));
         var _loc4_:int = _loc2_.parent.getChildIndex(DisplayObject(_loc2_));
         setChildIndex(_loc3_,_loc4_);
         if(_loc2_.toolTip)
         {
            _loc3_.toolTip = _loc2_.toolTip;
            _loc2_.toolTip = null;
         }
         _loc2_.addEventListener("labelChanged",labelChangedHandler);
         _loc2_.addEventListener("iconChanged",iconChangedHandler);
         _loc2_.addEventListener("enabledChanged",enabledChangedHandler);
         _loc2_.addEventListener("toolTipChanged",toolTipChangedHandler);
         _loc3_.enabled = enabled && _loc2_.enabled;
         callLater(resetNavItems);
      }
      
      public function itemToLabel(param1:Object) : String
      {
         var data:Object = param1;
         if(data == null)
         {
            return "";
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
         if(data is String)
         {
            return String(data);
         }
         if(data is Number)
         {
            return data.toString();
         }
         return "";
      }
      
      private function createNavChildren() : void
      {
         var item:Object = null;
         var navItem:Button = null;
         var label:String = null;
         var iconValue:Object = null;
         var icon:Class = null;
         if(!_dataProvider)
         {
            return;
         }
         var n:int = _dataProvider.length;
         var i:int = 0;
         while(i < n)
         {
            item = _dataProvider.getItemAt(i);
            if(item is String && labelFunction == null)
            {
               navItem = Button(createNavItem(String(item)));
            }
            else
            {
               label = itemToLabel(item);
               if(iconField)
               {
                  iconValue = null;
                  try
                  {
                     iconValue = item[iconField];
                  }
                  catch(e:Error)
                  {
                  }
                  icon = iconValue is String?Class(systemManager.getDefinitionByName(String(iconValue))):Class(iconValue);
                  navItem = Button(createNavItem(label,icon));
               }
               else
               {
                  navItem = Button(createNavItem(label,null));
               }
               if(toolTipField)
               {
                  try
                  {
                     navItem.toolTip = item[toolTipField] === undefined?null:item[toolTipField];
                  }
                  catch(e:Error)
                  {
                  }
               }
            }
            navItem.enabled = enabled;
            i++;
         }
         resetNavItems();
      }
      
      public function set toolTipField(param1:String) : void
      {
         _toolTipField = param1;
         if(_dataProvider)
         {
            dataProvider = _dataProvider;
         }
         dispatchEvent(new Event("toolTipFieldChanged"));
      }
      
      private function _setTargetViewStack(param1:Object) : void
      {
         var _loc2_:ViewStack = null;
         var _loc4_:int = 0;
         var _loc5_:Container = null;
         var _loc6_:int = 0;
         var _loc7_:Button = null;
         if(param1 is ViewStack)
         {
            _loc2_ = ViewStack(param1);
         }
         else if(param1)
         {
            _loc2_ = parentDocument[param1];
         }
         else
         {
            _loc2_ = null;
         }
         if(targetStack)
         {
            targetStack.removeEventListener(ChildExistenceChangedEvent.CHILD_ADD,childAddHandler);
            targetStack.removeEventListener(ChildExistenceChangedEvent.CHILD_REMOVE,childRemoveHandler);
            targetStack.removeEventListener(Event.CHANGE,changeHandler);
            targetStack.removeEventListener(IndexChangedEvent.CHILD_INDEX_CHANGE,childIndexChangeHandler);
            _loc4_ = targetStack.numChildren;
            _loc6_ = 0;
            while(_loc6_ < _loc4_)
            {
               _loc5_ = Container(targetStack.getChildAt(_loc6_));
               _loc5_.removeEventListener("labelChanged",labelChangedHandler);
               _loc5_.removeEventListener("iconChanged",iconChangedHandler);
               _loc5_.removeEventListener("enabledChanged",enabledChangedHandler);
               _loc5_.removeEventListener("toolTipChanged",toolTipChangedHandler);
               _loc6_++;
            }
         }
         removeAllChildren();
         _selectedIndex = -1;
         targetStack = _loc2_;
         if(!targetStack)
         {
            return;
         }
         targetStack.addEventListener(ChildExistenceChangedEvent.CHILD_ADD,childAddHandler);
         targetStack.addEventListener(ChildExistenceChangedEvent.CHILD_REMOVE,childRemoveHandler);
         targetStack.addEventListener(Event.CHANGE,changeHandler);
         targetStack.addEventListener(IndexChangedEvent.CHILD_INDEX_CHANGE,childIndexChangeHandler);
         _loc4_ = targetStack.numChildren;
         _loc6_ = 0;
         while(_loc6_ < _loc4_)
         {
            _loc5_ = Container(targetStack.getChildAt(_loc6_));
            _loc7_ = Button(createNavItem(itemToLabel(_loc5_),_loc5_.icon));
            if(_loc5_.toolTip)
            {
               _loc7_.toolTip = _loc5_.toolTip;
               _loc5_.toolTip = null;
            }
            _loc5_.addEventListener("labelChanged",labelChangedHandler);
            _loc5_.addEventListener("iconChanged",iconChangedHandler);
            _loc5_.addEventListener("enabledChanged",enabledChangedHandler);
            _loc5_.addEventListener("toolTipChanged",toolTipChangedHandler);
            _loc7_.enabled = enabled && _loc5_.enabled;
            _loc6_++;
         }
         var _loc3_:int = targetStack.selectedIndex;
         if(_loc3_ == -1 && targetStack.numChildren > 0)
         {
            _loc3_ = 0;
         }
         if(_loc3_ != -1)
         {
            hiliteSelectedNavItem(_loc3_);
         }
         resetNavItems();
         invalidateDisplayList();
      }
      
      private function toolTipChangedHandler(param1:Event) : void
      {
         var _loc2_:int = targetStack.getChildIndex(DisplayObject(param1.target));
         var _loc3_:UIComponent = UIComponent(getChildAt(_loc2_));
         if(UIComponent(param1.target).toolTip)
         {
            _loc3_.toolTip = UIComponent(param1.target).toolTip;
            lastToolTip = UIComponent(param1.target).toolTip;
            UIComponent(param1.target).toolTip = null;
         }
         else if(!lastToolTip)
         {
            _loc3_.toolTip = UIComponent(param1.target).toolTip;
            lastToolTip = "placeholder";
            UIComponent(param1.target).toolTip = null;
         }
         else
         {
            lastToolTip = null;
         }
      }
      
      protected function createNavItem(param1:String, param2:Class = null) : IFlexDisplayObject
      {
         return null;
      }
      
      [Bindable("collectionChange")]
      public function get dataProvider() : Object
      {
         return !!targetStack?targetStack:_dataProvider;
      }
      
      protected function updateNavItemLabel(param1:int, param2:String) : void
      {
         var _loc3_:Button = Button(getChildAt(param1));
         _loc3_.label = param2;
      }
      
      override public function set horizontalScrollPolicy(param1:String) : void
      {
      }
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
         if(!measurementHasBeenCalled)
         {
            checkPendingTargetStack();
            measurementHasBeenCalled = true;
         }
         if(dataProviderChanged)
         {
            dataProviderChanged = false;
            createNavChildren();
         }
         if(blocker)
         {
            blocker.visible = false;
         }
      }
      
      public function set labelField(param1:String) : void
      {
         _labelField = param1;
         if(_dataProvider)
         {
            dataProvider = _dataProvider;
         }
         dispatchEvent(new Event("labelFieldChanged"));
      }
      
      private function iconChangedHandler(param1:Event) : void
      {
         var _loc2_:int = targetStack.getChildIndex(DisplayObject(param1.target));
         updateNavItemIcon(_loc2_,Container(param1.target).icon);
      }
      
      protected function resetNavItems() : void
      {
      }
      
      [Bindable("toolTipFieldChanged")]
      public function get toolTipField() : String
      {
         return _toolTipField;
      }
      
      public function set labelFunction(param1:Function) : void
      {
         _labelFunction = param1;
         if(_dataProvider)
         {
            dataProvider = _dataProvider;
         }
         dispatchEvent(new Event("labelFunctionChanged"));
      }
      
      [Bindable("labelFieldChanged")]
      public function get labelField() : String
      {
         return _labelField;
      }
      
      override public function set verticalScrollPolicy(param1:String) : void
      {
      }
      
      private function childRemoveHandler(param1:ChildExistenceChangedEvent) : void
      {
         if(param1.target == this)
         {
            return;
         }
         param1.relatedObject.removeEventListener("labelChanged",labelChangedHandler);
         param1.relatedObject.removeEventListener("iconChanged",iconChangedHandler);
         param1.relatedObject.removeEventListener("enabledChanged",enabledChangedHandler);
         param1.relatedObject.removeEventListener("toolTipChanged",toolTipChangedHandler);
         var _loc2_:ViewStack = ViewStack(param1.target);
         removeChildAt(_loc2_.getChildIndex(param1.relatedObject));
         callLater(resetNavItems);
      }
      
      [Bindable("labelFunctionChanged")]
      public function get labelFunction() : Function
      {
         return _labelFunction;
      }
      
      override public function get verticalScrollPolicy() : String
      {
         return ScrollPolicy.OFF;
      }
      
      public function set dataProvider(param1:Object) : void
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         if(param1 && !(param1 is String) && !(param1 is ViewStack) && !(param1 is Array) && !(param1 is IList))
         {
            _loc2_ = resourceManager.getString("controls","errWrongContainer",[id]);
            throw new Error(_loc2_);
         }
         if(_dataProvider)
         {
            _dataProvider.removeEventListener(CollectionEvent.COLLECTION_CHANGE,collectionChangeHandler);
         }
         if(param1 is String && (document && document[param1]))
         {
            param1 = document[param1];
         }
         if(param1 is String || param1 is ViewStack)
         {
            setTargetViewStack(param1);
            return;
         }
         if(param1 is IList && IList(param1).length > 0 && IList(param1).getItemAt(0) is DisplayObject || param1 is Array && (param1 as Array).length > 0 && param1[0] is DisplayObject)
         {
            _loc3_ = !!id?className + " \'" + id + "\'":"a " + className;
            _loc2_ = resourceManager.getString("controls","errWrongType",[_loc3_]);
            throw new Error(_loc2_);
         }
         setTargetViewStack(null);
         removeAllChildren();
         if(param1 is IList)
         {
            _dataProvider = IList(param1);
         }
         else if(param1 is Array)
         {
            _dataProvider = new ArrayCollection(param1 as Array);
         }
         else
         {
            _dataProvider = null;
         }
         dataProviderChanged = true;
         invalidateProperties();
         if(_dataProvider)
         {
            _dataProvider.addEventListener(CollectionEvent.COLLECTION_CHANGE,collectionChangeHandler,false,0,true);
         }
         if(inheritingStyles == UIComponent.STYLE_UNINITIALIZED)
         {
            return;
         }
         dispatchEvent(new Event("collectionChange"));
      }
      
      private function changeHandler(param1:Event) : void
      {
         if(param1.target == dataProvider)
         {
            hiliteSelectedNavItem(Object(param1.target).selectedIndex);
         }
      }
      
      private function collectionChangeHandler(param1:Event) : void
      {
         dataProvider = dataProvider;
      }
      
      public function set selectedIndex(param1:int) : void
      {
         _selectedIndex = param1;
         if(targetStack)
         {
            targetStack.selectedIndex = param1;
         }
         dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));
      }
      
      [Bindable("valueCommit")]
      [Bindable("itemClick")]
      public function get selectedIndex() : int
      {
         return _selectedIndex;
      }
   }
}
