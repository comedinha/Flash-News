package mx.controls
{
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.text.TextLineMetrics;
   import flash.ui.Keyboard;
   import mx.collections.ArrayCollection;
   import mx.collections.CursorBookmark;
   import mx.controls.dataGridClasses.DataGridListData;
   import mx.controls.listClasses.BaseListData;
   import mx.controls.listClasses.IDropInListItemRenderer;
   import mx.controls.listClasses.IListItemRenderer;
   import mx.controls.listClasses.ListBase;
   import mx.controls.listClasses.ListData;
   import mx.core.ClassFactory;
   import mx.core.EdgeMetrics;
   import mx.core.FlexVersion;
   import mx.core.IDataRenderer;
   import mx.core.IFactory;
   import mx.core.ScrollPolicy;
   import mx.core.UIComponent;
   import mx.core.UIComponentGlobals;
   import mx.core.mx_internal;
   import mx.effects.Tween;
   import mx.events.CollectionEvent;
   import mx.events.CollectionEventKind;
   import mx.events.DropdownEvent;
   import mx.events.FlexEvent;
   import mx.events.FlexMouseEvent;
   import mx.events.InterManagerRequest;
   import mx.events.ListEvent;
   import mx.events.SandboxMouseEvent;
   import mx.events.ScrollEvent;
   import mx.events.ScrollEventDetail;
   import mx.managers.ISystemManager;
   import mx.managers.PopUpManager;
   import mx.styles.CSSStyleDeclaration;
   import mx.styles.StyleManager;
   
   use namespace mx_internal;
   
   public class ComboBox extends ComboBase implements IDataRenderer, IDropInListItemRenderer, IListItemRenderer
   {
      
      mx_internal static const VERSION:String = "3.6.0.21751";
      
      mx_internal static var createAccessibilityImplementation:Function;
       
      
      private var _labelField:String = "label";
      
      private var dropdownBorderStyle:String = "solid";
      
      private var implicitSelectedIndex:Boolean = false;
      
      private var _selectedIndexOnDropdown:int = -1;
      
      private var preferredDropdownWidth:Number;
      
      private var collectionChanged:Boolean = false;
      
      private var labelFunctionChanged:Boolean;
      
      private var selectedItemSet:Boolean;
      
      private var _dropdownWidth:Number = 100;
      
      private var inTween:Boolean = false;
      
      private var _oldIndex:int;
      
      private var tweenUp:Boolean = false;
      
      private var tween:Tween = null;
      
      private var labelFieldChanged:Boolean;
      
      private var _dropdown:ListBase;
      
      private var _dropdownFactory:IFactory;
      
      private var explicitText:Boolean;
      
      private var _prompt:String;
      
      private var _data:Object;
      
      private var bInKeyDown:Boolean = false;
      
      private var promptChanged:Boolean = false;
      
      private var _rowCount:int = 5;
      
      private var bRemoveDropdown:Boolean = true;
      
      private var _showingDropdown:Boolean = false;
      
      private var triggerEvent:Event;
      
      private var _listData:BaseListData;
      
      private var _itemRenderer:IFactory;
      
      private var _labelFunction:Function;
      
      public function ComboBox()
      {
         _dropdownFactory = new ClassFactory(List);
         super();
         dataProvider = new ArrayCollection();
         useFullDropdownSkin = true;
         wrapDownArrowButton = false;
         addEventListener("unload",unloadHandler);
         addEventListener(Event.REMOVED_FROM_STAGE,removedFromStageHandler);
      }
      
      override protected function calculatePreferredSizeFromData(param1:int) : Object
      {
         var _loc6_:TextLineMetrics = null;
         var _loc8_:Object = null;
         var _loc9_:String = null;
         var _loc2_:Number = 0;
         var _loc3_:Number = 0;
         var _loc4_:CursorBookmark = !!iterator?iterator.bookmark:null;
         iterator.seek(CursorBookmark.FIRST,0);
         var _loc5_:* = iterator != null;
         var _loc7_:int = 0;
         while(_loc7_ < param1)
         {
            if(_loc5_)
            {
               _loc8_ = !!iterator?iterator.current:null;
            }
            else
            {
               _loc8_ = null;
            }
            _loc9_ = itemToLabel(_loc8_);
            _loc6_ = measureText(_loc9_);
            _loc2_ = Math.max(_loc2_,_loc6_.width);
            _loc3_ = Math.max(_loc3_,_loc6_.height);
            if(iterator)
            {
               iterator.moveNext();
            }
            _loc7_++;
         }
         if(prompt)
         {
            _loc6_ = measureText(prompt);
            _loc2_ = Math.max(_loc2_,_loc6_.width);
            _loc3_ = Math.max(_loc3_,_loc6_.height);
         }
         _loc2_ = _loc2_ + (getStyle("paddingLeft") + getStyle("paddingRight"));
         if(iterator)
         {
            iterator.seek(_loc4_,0);
         }
         return {
            "width":_loc2_,
            "height":_loc3_
         };
      }
      
      private function dropdown_scrollHandler(param1:Event) : void
      {
         var _loc2_:ScrollEvent = null;
         if(param1 is ScrollEvent)
         {
            _loc2_ = ScrollEvent(param1);
            if(_loc2_.detail == ScrollEventDetail.THUMB_TRACK || _loc2_.detail == ScrollEventDetail.THUMB_POSITION || _loc2_.detail == ScrollEventDetail.LINE_UP || _loc2_.detail == ScrollEventDetail.LINE_DOWN)
            {
               dispatchEvent(_loc2_);
            }
         }
      }
      
      public function get dropdown() : ListBase
      {
         return getDropdown();
      }
      
      public function get selectedLabel() : String
      {
         var _loc1_:Object = selectedItem;
         return itemToLabel(_loc1_);
      }
      
      override protected function focusOutHandler(param1:FocusEvent) : void
      {
         if(_showingDropdown && _dropdown)
         {
            if(!param1.relatedObject || !_dropdown.contains(param1.relatedObject))
            {
               close();
            }
         }
         super.focusOutHandler(param1);
      }
      
      private function destroyDropdown() : void
      {
         if(inTween)
         {
            tween.endTween();
         }
         displayDropdown(false,null,false);
      }
      
      [Bindable("dropdownWidthChanged")]
      public function get dropdownWidth() : Number
      {
         return _dropdownWidth;
      }
      
      private function unloadHandler(param1:Event) : void
      {
         if(inTween)
         {
            UIComponent.resumeBackgroundProcessing();
            inTween = false;
         }
         if(_dropdown)
         {
            _dropdown.parent.removeChild(_dropdown);
         }
      }
      
      public function open() : void
      {
         displayDropdown(true);
      }
      
      public function set data(param1:Object) : void
      {
         var _loc2_:* = undefined;
         _data = param1;
         if(_listData && _listData is DataGridListData)
         {
            _loc2_ = _data[DataGridListData(_listData).dataField];
         }
         else if(_listData is ListData && ListData(_listData).labelField in _data)
         {
            _loc2_ = _data[ListData(_listData).labelField];
         }
         else
         {
            _loc2_ = _data;
         }
         if(_loc2_ !== undefined && !selectedItemSet)
         {
            selectedItem = _loc2_;
            selectedItemSet = false;
         }
         dispatchEvent(new FlexEvent(FlexEvent.DATA_CHANGE));
      }
      
      [Bindable("resize")]
      public function get rowCount() : int
      {
         return Math.max(1,Math.min(collection.length,_rowCount));
      }
      
      override protected function textInput_changeHandler(param1:Event) : void
      {
         super.textInput_changeHandler(param1);
         dispatchChangeEvent(param1,-1,-2);
      }
      
      private function dropdown_itemRollOutHandler(param1:Event) : void
      {
         dispatchEvent(param1);
      }
      
      override protected function measure() : void
      {
         super.measure();
         measuredMinWidth = Math.max(measuredWidth,DEFAULT_MEASURED_MIN_WIDTH);
         var _loc1_:Number = measureText("M").height + 6;
         var _loc2_:EdgeMetrics = borderMetrics;
         measuredMinHeight = measuredHeight = Math.max(_loc1_ + _loc2_.top + _loc2_.bottom,DEFAULT_MEASURED_MIN_HEIGHT);
         if(FlexVersion.compatibilityVersion >= FlexVersion.VERSION_3_0)
         {
            measuredMinHeight = measuredHeight = measuredHeight + (getStyle("paddingTop") + getStyle("paddingBottom"));
         }
      }
      
      private function dropdown_itemRollOverHandler(param1:Event) : void
      {
         dispatchEvent(param1);
      }
      
      public function get prompt() : String
      {
         return _prompt;
      }
      
      override protected function keyDownHandler(param1:KeyboardEvent) : void
      {
         var _loc2_:int = 0;
         if(!enabled)
         {
            return;
         }
         if(param1.target == textInput)
         {
            return;
         }
         if(param1.ctrlKey && param1.keyCode == Keyboard.DOWN)
         {
            displayDropdown(true,param1);
            param1.stopPropagation();
         }
         else if(param1.ctrlKey && param1.keyCode == Keyboard.UP)
         {
            close(param1);
            param1.stopPropagation();
         }
         else if(param1.keyCode == Keyboard.ESCAPE)
         {
            if(_showingDropdown)
            {
               if(_oldIndex != _dropdown.selectedIndex)
               {
                  selectedIndex = _oldIndex;
               }
               displayDropdown(false);
               param1.stopPropagation();
            }
         }
         else if(param1.keyCode == Keyboard.ENTER)
         {
            if(_showingDropdown)
            {
               close();
               param1.stopPropagation();
            }
         }
         else if(!editable || param1.keyCode == Keyboard.UP || param1.keyCode == Keyboard.DOWN || param1.keyCode == Keyboard.PAGE_UP || param1.keyCode == Keyboard.PAGE_DOWN)
         {
            _loc2_ = selectedIndex;
            bInKeyDown = _showingDropdown;
            dropdown.dispatchEvent(param1.clone());
            param1.stopPropagation();
            bInKeyDown = false;
         }
      }
      
      public function set dropdownWidth(param1:Number) : void
      {
         _dropdownWidth = param1;
         preferredDropdownWidth = param1;
         if(_dropdown)
         {
            _dropdown.setActualSize(param1,_dropdown.height);
         }
         dispatchEvent(new Event("dropdownWidthChanged"));
      }
      
      [Bindable("labelFieldChanged")]
      public function get labelField() : String
      {
         return _labelField;
      }
      
      public function set dropdownFactory(param1:IFactory) : void
      {
         _dropdownFactory = param1;
         dispatchEvent(new Event("dropdownFactoryChanged"));
      }
      
      [Bindable("collectionChange")]
      override public function set dataProvider(param1:Object) : void
      {
         selectionChanged = true;
         super.dataProvider = param1;
         destroyDropdown();
         invalidateProperties();
         invalidateSize();
      }
      
      mx_internal function get isShowingDropdown() : Boolean
      {
         return _showingDropdown;
      }
      
      override protected function collectionChangeHandler(param1:Event) : void
      {
         var _loc3_:CollectionEvent = null;
         var _loc2_:int = selectedIndex;
         super.collectionChangeHandler(param1);
         if(param1 is CollectionEvent)
         {
            _loc3_ = CollectionEvent(param1);
            if(collection.length == 0)
            {
               if(!selectedIndexChanged && !selectedItemChanged)
               {
                  if(super.selectedIndex != -1)
                  {
                     super.selectedIndex = -1;
                  }
                  implicitSelectedIndex = true;
                  invalidateDisplayList();
               }
               if(textInput && !editable)
               {
                  textInput.text = "";
               }
            }
            else if(_loc3_.kind == CollectionEventKind.ADD)
            {
               if(collection.length == _loc3_.items.length)
               {
                  if(selectedIndex == -1 && _prompt == null)
                  {
                     selectedIndex = 0;
                  }
               }
               else
               {
                  return;
               }
            }
            else if(_loc3_.kind == CollectionEventKind.UPDATE)
            {
               if(_loc3_.location == selectedIndex || _loc3_.items[0].source == selectedItem)
               {
                  selectionChanged = true;
               }
            }
            else
            {
               if(_loc3_.kind == CollectionEventKind.REPLACE)
               {
                  return;
               }
               if(_loc3_.kind == CollectionEventKind.RESET)
               {
                  collectionChanged = true;
                  if(!selectedIndexChanged && !selectedItemChanged)
                  {
                     selectedIndex = !!prompt?-1:0;
                  }
                  invalidateProperties();
               }
            }
            invalidateDisplayList();
            destroyDropdown();
         }
      }
      
      mx_internal function onTweenEnd(param1:Number) : void
      {
         if(_dropdown)
         {
            _dropdown.scrollRect = null;
            inTween = false;
            _dropdown.enabled = true;
            _dropdown.visible = _showingDropdown;
            if(bRemoveDropdown)
            {
               _dropdown.removeEventListener(FlexMouseEvent.MOUSE_DOWN_OUTSIDE,dropdown_mouseOutsideHandler);
               _dropdown.removeEventListener(FlexMouseEvent.MOUSE_WHEEL_OUTSIDE,dropdown_mouseOutsideHandler);
               _dropdown.removeEventListener(SandboxMouseEvent.MOUSE_DOWN_SOMEWHERE,dropdown_mouseOutsideHandler);
               _dropdown.removeEventListener(SandboxMouseEvent.MOUSE_WHEEL_SOMEWHERE,dropdown_mouseOutsideHandler);
               PopUpManager.removePopUp(_dropdown);
               _dropdown = null;
            }
         }
         bRemoveDropdown = true;
         UIComponent.resumeBackgroundProcessing();
         var _loc2_:DropdownEvent = new DropdownEvent(!!_showingDropdown?DropdownEvent.OPEN:DropdownEvent.CLOSE);
         _loc2_.triggerEvent = triggerEvent;
         dispatchEvent(_loc2_);
      }
      
      [Bindable("dataChange")]
      public function get listData() : BaseListData
      {
         return _listData;
      }
      
      private function getDropdown() : ListBase
      {
         var _loc2_:String = null;
         var _loc3_:CSSStyleDeclaration = null;
         if(!initialized)
         {
            return null;
         }
         if(!hasDropdown())
         {
            _loc2_ = getStyle("dropDownStyleName");
            if(_loc2_ == null)
            {
               _loc2_ = getStyle("dropdownStyleName");
            }
            _dropdown = dropdownFactory.newInstance();
            _dropdown.visible = false;
            _dropdown.focusEnabled = false;
            _dropdown.owner = this;
            if(itemRenderer)
            {
               _dropdown.itemRenderer = itemRenderer;
            }
            if(FlexVersion.compatibilityVersion < FlexVersion.VERSION_3_0)
            {
               _dropdown.styleName = this;
            }
            if(_loc2_)
            {
               if(FlexVersion.compatibilityVersion < FlexVersion.VERSION_3_0)
               {
                  _loc3_ = StyleManager.getStyleDeclaration("." + _loc2_);
                  if(_loc3_)
                  {
                     _dropdown.styleDeclaration = _loc3_;
                  }
               }
               else
               {
                  _dropdown.styleName = _loc2_;
               }
            }
            else if(FlexVersion.compatibilityVersion < FlexVersion.VERSION_3_0)
            {
               _dropdown.setStyle("cornerRadius",0);
            }
            PopUpManager.addPopUp(_dropdown,this);
            _dropdown.setStyle("selectionDuration",0);
            if(FlexVersion.compatibilityVersion < FlexVersion.VERSION_3_0 && dropdownBorderStyle && dropdownBorderStyle != "")
            {
               _dropdown.setStyle("borderStyle",dropdownBorderStyle);
            }
            if(!dataProvider)
            {
               dataProvider = new ArrayCollection();
            }
            _dropdown.dataProvider = dataProvider;
            _dropdown.rowCount = rowCount;
            _dropdown.width = _dropdownWidth;
            _dropdown.selectedIndex = selectedIndex;
            _oldIndex = selectedIndex;
            _dropdown.verticalScrollPolicy = ScrollPolicy.AUTO;
            _dropdown.labelField = _labelField;
            _dropdown.labelFunction = itemToLabel;
            _dropdown.allowDragSelection = true;
            _dropdown.addEventListener("change",dropdown_changeHandler);
            _dropdown.addEventListener(ScrollEvent.SCROLL,dropdown_scrollHandler);
            _dropdown.addEventListener(ListEvent.ITEM_ROLL_OVER,dropdown_itemRollOverHandler);
            _dropdown.addEventListener(ListEvent.ITEM_ROLL_OUT,dropdown_itemRollOutHandler);
            _dropdown.addEventListener(ListEvent.ITEM_CLICK,dropdown_itemClickHandler);
            UIComponentGlobals.layoutManager.validateClient(_dropdown,true);
            _dropdown.setActualSize(_dropdownWidth,_dropdown.getExplicitOrMeasuredHeight());
            _dropdown.validateDisplayList();
            _dropdown.cacheAsBitmap = true;
            systemManager.addEventListener(Event.RESIZE,stage_resizeHandler,false,0,true);
         }
         var _loc1_:Matrix = transform.concatenatedMatrix;
         _dropdown.scaleX = _loc1_.a;
         _dropdown.scaleY = _loc1_.d;
         return _dropdown;
      }
      
      private function stage_resizeHandler(param1:Event) : void
      {
         destroyDropdown();
      }
      
      override protected function downArrowButton_buttonDownHandler(param1:FlexEvent) : void
      {
         if(_showingDropdown)
         {
            close(param1);
         }
         else
         {
            displayDropdown(true,param1);
         }
      }
      
      [Bindable("valueCommit")]
      [Bindable("collectionChange")]
      [Bindable("change")]
      override public function set selectedItem(param1:Object) : void
      {
         selectedItemSet = true;
         implicitSelectedIndex = false;
         super.selectedItem = param1;
      }
      
      override protected function initializeAccessibility() : void
      {
         if(ComboBox.createAccessibilityImplementation != null)
         {
            ComboBox.createAccessibilityImplementation(this);
         }
      }
      
      public function itemToLabel(param1:Object, ... rest) : String
      {
         var item:Object = param1;
         if(item == null)
         {
            return "";
         }
         if(labelFunction != null)
         {
            return labelFunction(item);
         }
         if(typeof item == "object")
         {
            try
            {
               if(item[labelField] != null)
               {
                  item = item[labelField];
               }
            }
            catch(e:Error)
            {
            }
         }
         else if(typeof item == "xml")
         {
            try
            {
               if(item[labelField].length() != 0)
               {
                  item = item[labelField];
               }
            }
            catch(e:Error)
            {
            }
         }
         if(typeof item == "string")
         {
            return String(item);
         }
         try
         {
            return item.toString();
         }
         catch(e:Error)
         {
         }
         return " ";
      }
      
      [Bindable("dataChange")]
      public function get data() : Object
      {
         return _data;
      }
      
      mx_internal function onTweenUpdate(param1:Number) : void
      {
         if(_dropdown)
         {
            _dropdown.scrollRect = new Rectangle(0,param1,_dropdown.width,_dropdown.height);
         }
      }
      
      private function removedFromStageHandler(param1:Event) : void
      {
         destroyDropdown();
      }
      
      private function dropdown_mouseOutsideHandler(param1:Event) : void
      {
         var _loc2_:MouseEvent = null;
         if(param1 is MouseEvent)
         {
            _loc2_ = MouseEvent(param1);
            if(_loc2_.target != _dropdown)
            {
               return;
            }
            if(!hitTestPoint(_loc2_.stageX,_loc2_.stageY,true))
            {
               close(param1);
            }
         }
         else if(param1 is SandboxMouseEvent)
         {
            close(param1);
         }
      }
      
      [Bindable("dropdownFactoryChanged")]
      public function get dropdownFactory() : IFactory
      {
         return _dropdownFactory;
      }
      
      override public function styleChanged(param1:String) : void
      {
         destroyDropdown();
         super.styleChanged(param1);
      }
      
      public function set prompt(param1:String) : void
      {
         _prompt = param1;
         promptChanged = true;
         invalidateProperties();
      }
      
      override protected function commitProperties() : void
      {
         explicitText = textChanged;
         super.commitProperties();
         if(collectionChanged)
         {
            if(selectedIndex == -1 && implicitSelectedIndex && _prompt == null)
            {
               selectedIndex = 0;
            }
            selectedIndexChanged = true;
            collectionChanged = false;
         }
         if(promptChanged && prompt != null && selectedIndex == -1)
         {
            promptChanged = false;
            textInput.text = prompt;
         }
      }
      
      mx_internal function hasDropdown() : Boolean
      {
         return _dropdown != null;
      }
      
      public function set listData(param1:BaseListData) : void
      {
         _listData = param1;
      }
      
      public function set labelField(param1:String) : void
      {
         _labelField = param1;
         labelFieldChanged = true;
         invalidateDisplayList();
         dispatchEvent(new Event("labelFieldChanged"));
      }
      
      public function set labelFunction(param1:Function) : void
      {
         _labelFunction = param1;
         labelFunctionChanged = true;
         invalidateDisplayList();
         dispatchEvent(new Event("labelFunctionChanged"));
      }
      
      protected function get dropDownStyleFilters() : Object
      {
         return null;
      }
      
      public function set rowCount(param1:int) : void
      {
         _rowCount = param1;
         if(_dropdown)
         {
            _dropdown.rowCount = param1;
         }
      }
      
      private function dropdown_changeHandler(param1:Event) : void
      {
         var _loc2_:int = selectedIndex;
         if(_dropdown)
         {
            selectedIndex = _dropdown.selectedIndex;
         }
         if(!_showingDropdown)
         {
            dispatchChangeEvent(param1,_loc2_,selectedIndex);
         }
         else if(!bInKeyDown)
         {
            close();
         }
      }
      
      private function dropdown_itemClickHandler(param1:ListEvent) : void
      {
         if(_showingDropdown)
         {
            close();
         }
      }
      
      [Bindable("labelFunctionChanged")]
      public function get labelFunction() : Function
      {
         return _labelFunction;
      }
      
      [Bindable("valueCommit")]
      [Bindable("collectionChange")]
      [Bindable("change")]
      override public function set selectedIndex(param1:int) : void
      {
         super.selectedIndex = param1;
         if(param1 >= 0)
         {
            selectionChanged = true;
         }
         implicitSelectedIndex = false;
         invalidateDisplayList();
         if(textInput && !textChanged && param1 >= 0)
         {
            textInput.text = selectedLabel;
         }
         else if(textInput && prompt)
         {
            textInput.text = prompt;
         }
      }
      
      private function dispatchChangeEvent(param1:Event, param2:int, param3:int) : void
      {
         var _loc4_:Event = null;
         if(param2 != param3)
         {
            _loc4_ = param1 is ListEvent?param1:new ListEvent("change");
            dispatchEvent(_loc4_);
         }
      }
      
      private function displayDropdown(param1:Boolean, param2:Event = null, param3:Boolean = true) : void
      {
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Function = null;
         var _loc11_:Rectangle = null;
         var _loc12_:InterManagerRequest = null;
         var _loc13_:int = 0;
         var _loc14_:Number = NaN;
         if(!initialized || param1 == _showingDropdown)
         {
            return;
         }
         if(inTween)
         {
            tween.endTween();
         }
         var _loc8_:Point = new Point(0,unscaledHeight);
         _loc8_ = localToGlobal(_loc8_);
         var _loc9_:ISystemManager = systemManager.topLevelSystemManager;
         var _loc10_:DisplayObject = _loc9_.getSandboxRoot();
         if(_loc9_ != _loc10_)
         {
            _loc12_ = new InterManagerRequest(InterManagerRequest.SYSTEM_MANAGER_REQUEST,false,false,"getVisibleApplicationRect");
            _loc10_.dispatchEvent(_loc12_);
            _loc11_ = Rectangle(_loc12_.value);
         }
         else
         {
            _loc11_ = _loc9_.getVisibleApplicationRect();
         }
         if(param1)
         {
            _selectedIndexOnDropdown = selectedIndex;
            getDropdown();
            _dropdown.addEventListener(FlexMouseEvent.MOUSE_DOWN_OUTSIDE,dropdown_mouseOutsideHandler);
            _dropdown.addEventListener(FlexMouseEvent.MOUSE_WHEEL_OUTSIDE,dropdown_mouseOutsideHandler);
            _dropdown.addEventListener(SandboxMouseEvent.MOUSE_DOWN_SOMEWHERE,dropdown_mouseOutsideHandler);
            _dropdown.addEventListener(SandboxMouseEvent.MOUSE_WHEEL_SOMEWHERE,dropdown_mouseOutsideHandler);
            if(_dropdown.parent == null)
            {
               PopUpManager.addPopUp(_dropdown,this);
            }
            else
            {
               PopUpManager.bringToFront(_dropdown);
            }
            if(_loc8_.y + _dropdown.height > _loc11_.bottom && _loc8_.y > _loc11_.top + _dropdown.height)
            {
               _loc8_.y = _loc8_.y - (unscaledHeight + _dropdown.height);
               _loc4_ = -_dropdown.height;
               tweenUp = true;
            }
            else
            {
               _loc4_ = _dropdown.height;
               tweenUp = false;
            }
            _loc8_ = _dropdown.parent.globalToLocal(_loc8_);
            _loc13_ = _dropdown.selectedIndex;
            if(_loc13_ == -1)
            {
               _loc13_ = 0;
            }
            _loc14_ = _dropdown.verticalScrollPosition;
            _loc14_ = _loc13_ - 1;
            _loc14_ = Math.min(Math.max(_loc14_,0),_dropdown.maxVerticalScrollPosition);
            _dropdown.verticalScrollPosition = _loc14_;
            if(_dropdown.x != _loc8_.x || _dropdown.y != _loc8_.y)
            {
               _dropdown.move(_loc8_.x,_loc8_.y);
            }
            _dropdown.scrollRect = new Rectangle(0,_loc4_,_dropdown.width,_dropdown.height);
            if(!_dropdown.visible)
            {
               _dropdown.visible = true;
            }
            bRemoveDropdown = false;
            _showingDropdown = param1;
            _loc6_ = getStyle("openDuration");
            _loc5_ = 0;
            _loc7_ = getStyle("openEasingFunction") as Function;
         }
         else if(_dropdown)
         {
            _loc5_ = _loc8_.y + _dropdown.height > _loc11_.bottom || tweenUp?Number(-_dropdown.height):Number(_dropdown.height);
            _showingDropdown = param1;
            _loc4_ = 0;
            _loc6_ = getStyle("closeDuration");
            _loc7_ = getStyle("closeEasingFunction") as Function;
            _dropdown.resetDragScrolling();
         }
         inTween = true;
         UIComponentGlobals.layoutManager.validateNow();
         UIComponent.suspendBackgroundProcessing();
         if(_dropdown)
         {
            _dropdown.enabled = false;
         }
         _loc6_ = Math.max(1,_loc6_);
         if(!param3)
         {
            _loc6_ = 1;
         }
         tween = new Tween(this,_loc4_,_loc5_,_loc6_);
         if(_loc7_ != null && tween)
         {
            tween.easingFunction = _loc7_;
         }
         triggerEvent = param2;
      }
      
      public function get itemRenderer() : IFactory
      {
         return _itemRenderer;
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         super.updateDisplayList(param1,param2);
         if(_dropdown && !inTween)
         {
            if(!_showingDropdown)
            {
               destroyDropdown();
            }
         }
         else if(_showingDropdown)
         {
            bRemoveDropdown = false;
         }
         var _loc3_:Number = preferredDropdownWidth;
         if(isNaN(_loc3_))
         {
            _loc3_ = _dropdownWidth = param1;
         }
         if(labelFieldChanged)
         {
            if(_dropdown)
            {
               _dropdown.labelField = _labelField;
            }
            selectionChanged = true;
            if(!explicitText)
            {
               textInput.text = selectedLabel;
            }
            labelFieldChanged = false;
         }
         if(labelFunctionChanged)
         {
            selectionChanged = true;
            if(!explicitText)
            {
               textInput.text = selectedLabel;
            }
            labelFunctionChanged = false;
         }
         if(selectionChanged)
         {
            if(!textChanged)
            {
               if(selectedIndex == -1 && prompt)
               {
                  textInput.text = prompt;
               }
               else if(!explicitText)
               {
                  textInput.text = selectedLabel;
               }
            }
            textInput.invalidateDisplayList();
            textInput.validateNow();
            if(editable)
            {
               textInput.getTextField().setSelection(0,textInput.text.length);
               textInput.getTextField().scrollH = 0;
            }
            if(_dropdown)
            {
               _dropdown.selectedIndex = selectedIndex;
            }
            selectionChanged = false;
         }
         if(_dropdown && _dropdown.rowCount != rowCount)
         {
            _dropdown.rowCount = rowCount;
         }
      }
      
      public function close(param1:Event = null) : void
      {
         if(_showingDropdown)
         {
            if(_dropdown && selectedIndex != _dropdown.selectedIndex)
            {
               selectedIndex = _dropdown.selectedIndex;
            }
            displayDropdown(false,param1);
            dispatchChangeEvent(new Event("dummy"),_selectedIndexOnDropdown,selectedIndex);
         }
      }
      
      public function set itemRenderer(param1:IFactory) : void
      {
         _itemRenderer = param1;
         if(_dropdown)
         {
            _dropdown.itemRenderer = param1;
         }
         invalidateSize();
         invalidateDisplayList();
         dispatchEvent(new Event("itemRendererChanged"));
      }
      
      override public function set showInAutomationHierarchy(param1:Boolean) : void
      {
      }
   }
}
