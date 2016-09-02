package mx.controls
{
   import mx.core.UIComponent;
   import mx.core.IIMESupport;
   import mx.managers.IFocusManagerComponent;
   import mx.core.mx_internal;
   import flash.events.Event;
   import mx.events.CollectionEvent;
   import mx.events.CollectionEventKind;
   import mx.events.FlexEvent;
   import flash.events.FocusEvent;
   import mx.managers.IFocusManager;
   import mx.core.FlexVersion;
   import mx.utils.UIDUtil;
   import mx.collections.ICollectionView;
   import mx.styles.ISimpleStyleClient;
   import flash.display.DisplayObject;
   import mx.styles.StyleProxy;
   import mx.core.IFlexDisplayObject;
   import mx.collections.IViewCursor;
   import flash.events.MouseEvent;
   import flash.events.KeyboardEvent;
   import mx.core.EdgeMetrics;
   import mx.core.UITextField;
   import mx.collections.CursorBookmark;
   import mx.collections.ArrayCollection;
   import mx.collections.IList;
   import mx.collections.ListCollectionView;
   import mx.collections.XMLListCollection;
   import mx.core.IRectangularBorder;
   
   use namespace mx_internal;
   
   public class ComboBase extends UIComponent implements IIMESupport, IFocusManagerComponent
   {
      
      mx_internal static var createAccessibilityImplementation:Function;
      
      mx_internal static const VERSION:String = "3.6.0.21751";
      
      private static var _textInputStyleFilters:Object = {
         "backgroundAlpha":"backgroundAlpha",
         "backgroundColor":"backgroundColor",
         "backgroundImage":"backgroundImage",
         "backgroundDisabledColor":"backgroundDisabledColor",
         "backgroundSize":"backgroundSize",
         "borderAlpha":"borderAlpha",
         "borderColor":"borderColor",
         "borderSides":"borderSides",
         "borderSkin":"borderSkin",
         "borderStyle":"borderStyle",
         "borderThickness":"borderThickness",
         "dropShadowColor":"dropShadowColor",
         "dropShadowEnabled":"dropShadowEnabled",
         "embedFonts":"embedFonts",
         "focusAlpha":"focusAlpha",
         "focusBlendMode":"focusBlendMode",
         "focusRoundedCorners":"focusRoundedCorners",
         "focusThickness":"focusThickness",
         "leading":"leading",
         "paddingLeft":"paddingLeft",
         "paddingRight":"paddingRight",
         "shadowDirection":"shadowDirection",
         "shadowDistance":"shadowDistance",
         "textDecoration":"textDecoration"
      };
       
      
      private var _enabled:Boolean = false;
      
      mx_internal var useFullDropdownSkin:Boolean = false;
      
      mx_internal var selectedItemChanged:Boolean = false;
      
      mx_internal var selectionChanged:Boolean = false;
      
      mx_internal var downArrowButton:mx.controls.Button;
      
      private var _restrict:String;
      
      protected var collection:ICollectionView;
      
      private var _text:String = "";
      
      mx_internal var border:IFlexDisplayObject;
      
      private var _selectedItem:Object;
      
      mx_internal var editableChanged:Boolean = true;
      
      private var enabledChanged:Boolean = false;
      
      private var selectedUID:String;
      
      mx_internal var selectedIndexChanged:Boolean = false;
      
      mx_internal var oldBorderStyle:String;
      
      protected var textInput:mx.controls.TextInput;
      
      private var _editable:Boolean = false;
      
      mx_internal var collectionIterator:IViewCursor;
      
      mx_internal var textChanged:Boolean;
      
      private var _imeMode:String = null;
      
      protected var iterator:IViewCursor;
      
      mx_internal var wrapDownArrowButton:Boolean = true;
      
      private var _selectedIndex:int = -1;
      
      public function ComboBase()
      {
         super();
         tabEnabled = true;
      }
      
      protected function collectionChangeHandler(param1:Event) : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:Number = NaN;
         var _loc4_:Object = null;
         var _loc5_:CollectionEvent = null;
         var _loc6_:int = 0;
         var _loc7_:String = null;
         if(param1 is CollectionEvent)
         {
            _loc2_ = false;
            _loc5_ = CollectionEvent(param1);
            if(_loc5_.kind == CollectionEventKind.ADD)
            {
               if(selectedIndex >= _loc5_.location)
               {
                  _selectedIndex++;
               }
            }
            if(_loc5_.kind == CollectionEventKind.REMOVE)
            {
               _loc6_ = 0;
               while(_loc6_ < _loc5_.items.length)
               {
                  _loc7_ = itemToUID(_loc5_.items[_loc6_]);
                  if(selectedUID == _loc7_)
                  {
                     selectionChanged = true;
                  }
                  _loc6_++;
               }
               if(selectionChanged)
               {
                  if(_selectedIndex >= collection.length)
                  {
                     _selectedIndex = collection.length - 1;
                  }
                  selectedIndexChanged = true;
                  _loc2_ = true;
                  invalidateDisplayList();
               }
               else if(selectedIndex >= _loc5_.location)
               {
                  _selectedIndex--;
                  selectedIndexChanged = true;
                  _loc2_ = true;
                  invalidateDisplayList();
               }
            }
            if(_loc5_.kind == CollectionEventKind.REFRESH)
            {
               selectedItemChanged = true;
               _loc2_ = true;
            }
            invalidateDisplayList();
            if(_loc2_)
            {
               dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));
            }
         }
      }
      
      override public function set enabled(param1:Boolean) : void
      {
         super.enabled = param1;
         _enabled = param1;
         enabledChanged = true;
         invalidateProperties();
      }
      
      public function get imeMode() : String
      {
         return _imeMode;
      }
      
      override protected function focusOutHandler(param1:FocusEvent) : void
      {
         super.focusOutHandler(param1);
         var _loc2_:IFocusManager = focusManager;
         if(_loc2_)
         {
            _loc2_.defaultButtonEnabled = true;
         }
         if(_editable)
         {
            dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));
         }
      }
      
      override public function get baselinePosition() : Number
      {
         if(FlexVersion.compatibilityVersion < FlexVersion.VERSION_3_0)
         {
            return textInput.y + textInput.baselinePosition;
         }
         if(!validateBaselinePosition())
         {
            return NaN;
         }
         return textInput.y + textInput.baselinePosition;
      }
      
      public function set imeMode(param1:String) : void
      {
         _imeMode = param1;
         if(textInput)
         {
            textInput.imeMode = _imeMode;
         }
      }
      
      protected function itemToUID(param1:Object) : String
      {
         if(!param1)
         {
            return "null";
         }
         return UIDUtil.getUID(param1);
      }
      
      protected function downArrowButton_buttonDownHandler(param1:FlexEvent) : void
      {
      }
      
      override protected function createChildren() : void
      {
         var _loc1_:Class = null;
         var _loc2_:Object = null;
         super.createChildren();
         if(!border)
         {
            _loc1_ = getStyle("borderSkin");
            if(_loc1_)
            {
               border = new _loc1_();
               if(border is IFocusManagerComponent)
               {
                  IFocusManagerComponent(border).focusEnabled = false;
               }
               if(border is ISimpleStyleClient)
               {
                  ISimpleStyleClient(border).styleName = this;
               }
               addChild(DisplayObject(border));
            }
         }
         if(!downArrowButton)
         {
            downArrowButton = new mx.controls.Button();
            downArrowButton.styleName = new StyleProxy(this,arrowButtonStyleFilters);
            downArrowButton.focusEnabled = false;
            addChild(downArrowButton);
            downArrowButton.addEventListener(FlexEvent.BUTTON_DOWN,downArrowButton_buttonDownHandler);
         }
         if(!textInput)
         {
            _loc2_ = getStyle("textInputStyleName");
            if(!_loc2_)
            {
               _loc2_ = new StyleProxy(this,textInputStyleFilters);
            }
            textInput = new mx.controls.TextInput();
            textInput.editable = _editable;
            editableChanged = true;
            textInput.restrict = "^\x1b";
            textInput.focusEnabled = false;
            textInput.imeMode = _imeMode;
            textInput.styleName = _loc2_;
            textInput.addEventListener(Event.CHANGE,textInput_changeHandler);
            textInput.addEventListener(FlexEvent.ENTER,textInput_enterHandler);
            textInput.addEventListener(FocusEvent.FOCUS_IN,focusInHandler);
            textInput.addEventListener(FocusEvent.FOCUS_OUT,focusOutHandler);
            textInput.addEventListener(FlexEvent.VALUE_COMMIT,textInput_valueCommitHandler);
            addChild(textInput);
            textInput.move(0,0);
            textInput.parentDrawsFocus = true;
         }
      }
      
      public function set selectedItem(param1:Object) : void
      {
         setSelectedItem(param1);
      }
      
      override protected function initializeAccessibility() : void
      {
         if(ComboBase.createAccessibilityImplementation != null)
         {
            ComboBase.createAccessibilityImplementation(this);
         }
      }
      
      private function textInput_enterHandler(param1:FlexEvent) : void
      {
         dispatchEvent(param1);
         dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));
      }
      
      protected function calculatePreferredSizeFromData(param1:int) : Object
      {
         return null;
      }
      
      override public function setFocus() : void
      {
         if(textInput && _editable)
         {
            textInput.setFocus();
         }
         else
         {
            super.setFocus();
         }
      }
      
      private function textInput_valueCommitHandler(param1:FlexEvent) : void
      {
         _text = textInput.text;
         dispatchEvent(param1);
      }
      
      [NonCommittingChangeEvent("change")]
      [Bindable("valueCommit")]
      [Bindable("collectionChange")]
      public function get text() : String
      {
         return _text;
      }
      
      [Bindable("collectionChange")]
      public function get dataProvider() : Object
      {
         return collection;
      }
      
      protected function get arrowButtonStyleFilters() : Object
      {
         return null;
      }
      
      public function set editable(param1:Boolean) : void
      {
         _editable = param1;
         editableChanged = true;
         invalidateProperties();
         dispatchEvent(new Event("editableChanged"));
      }
      
      override public function styleChanged(param1:String) : void
      {
         if(downArrowButton)
         {
            downArrowButton.styleChanged(param1);
         }
         if(textInput)
         {
            textInput.styleChanged(param1);
         }
         if(border && border is ISimpleStyleClient)
         {
            ISimpleStyleClient(border).styleChanged(param1);
         }
         super.styleChanged(param1);
      }
      
      [Bindable("restrictChanged")]
      public function get restrict() : String
      {
         return _restrict;
      }
      
      [Bindable("valueCommit")]
      [Bindable("change")]
      public function get selectedItem() : Object
      {
         return _selectedItem;
      }
      
      mx_internal function get ComboDownArrowButton() : mx.controls.Button
      {
         return downArrowButton;
      }
      
      private function setSelectedItem(param1:Object, param2:Boolean = true) : void
      {
         if(!collection || collection.length == 0)
         {
            _selectedItem = param1;
            selectedItemChanged = true;
            invalidateDisplayList();
            return;
         }
         var _loc3_:Boolean = false;
         var _loc4_:IViewCursor = collection.createCursor();
         var _loc5_:int = 0;
         do
         {
            if(param1 == _loc4_.current)
            {
               _selectedIndex = _loc5_;
               _selectedItem = param1;
               selectedUID = itemToUID(param1);
               selectionChanged = true;
               _loc3_ = true;
               break;
            }
            _loc5_++;
         }
         while(_loc4_.moveNext());
         
         if(!_loc3_)
         {
            selectedIndex = -1;
            _selectedItem = null;
            selectedUID = null;
         }
         invalidateDisplayList();
      }
      
      override protected function commitProperties() : void
      {
         var _loc1_:Boolean = false;
         super.commitProperties();
         textInput.restrict = _restrict;
         if(textChanged)
         {
            textInput.text = _text;
            textChanged = false;
         }
         if(enabledChanged)
         {
            textInput.enabled = _enabled;
            editableChanged = true;
            downArrowButton.enabled = _enabled;
            enabledChanged = false;
         }
         if(editableChanged)
         {
            editableChanged = false;
            _loc1_ = _editable;
            if(wrapDownArrowButton == false)
            {
               if(_loc1_)
               {
                  if(oldBorderStyle)
                  {
                     setStyle("borderStyle",oldBorderStyle);
                  }
               }
               else
               {
                  oldBorderStyle = getStyle("borderStyle");
                  setStyle("borderStyle","comboNonEdit");
               }
            }
            if(useFullDropdownSkin)
            {
               downArrowButton.upSkinName = !!_loc1_?"editableUpSkin":"upSkin";
               downArrowButton.overSkinName = !!_loc1_?"editableOverSkin":"overSkin";
               downArrowButton.downSkinName = !!_loc1_?"editableDownSkin":"downSkin";
               downArrowButton.disabledSkinName = !!_loc1_?"editableDisabledSkin":"disabledSkin";
               downArrowButton.changeSkins();
               downArrowButton.invalidateDisplayList();
            }
            if(textInput)
            {
               textInput.editable = _loc1_;
               textInput.selectable = _loc1_;
               if(_loc1_)
               {
                  textInput.removeEventListener(MouseEvent.MOUSE_DOWN,textInput_mouseEventHandler);
                  textInput.removeEventListener(MouseEvent.MOUSE_UP,textInput_mouseEventHandler);
                  textInput.removeEventListener(MouseEvent.ROLL_OVER,textInput_mouseEventHandler);
                  textInput.removeEventListener(MouseEvent.ROLL_OUT,textInput_mouseEventHandler);
                  textInput.addEventListener(KeyboardEvent.KEY_DOWN,keyDownHandler);
               }
               else
               {
                  textInput.addEventListener(MouseEvent.MOUSE_DOWN,textInput_mouseEventHandler);
                  textInput.addEventListener(MouseEvent.MOUSE_UP,textInput_mouseEventHandler);
                  textInput.addEventListener(MouseEvent.ROLL_OVER,textInput_mouseEventHandler);
                  textInput.addEventListener(MouseEvent.ROLL_OUT,textInput_mouseEventHandler);
                  textInput.removeEventListener(KeyboardEvent.KEY_DOWN,keyDownHandler);
               }
            }
         }
      }
      
      protected function get textInputStyleFilters() : Object
      {
         return _textInputStyleFilters;
      }
      
      public function set text(param1:String) : void
      {
         _text = param1;
         textChanged = true;
         invalidateProperties();
         dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));
      }
      
      override protected function isOurFocus(param1:DisplayObject) : Boolean
      {
         return param1 == textInput || super.isOurFocus(param1);
      }
      
      [Bindable("editableChanged")]
      public function get editable() : Boolean
      {
         return _editable;
      }
      
      override protected function measure() : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Object = null;
         var _loc4_:EdgeMetrics = null;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         super.measure();
         var _loc1_:Number = getStyle("arrowButtonWidth");
         _loc2_ = downArrowButton.getExplicitOrMeasuredHeight();
         if(collection && collection.length > 0)
         {
            _loc3_ = calculatePreferredSizeFromData(collection.length);
            _loc4_ = borderMetrics;
            _loc5_ = _loc3_.width + _loc4_.left + _loc4_.right + 8;
            _loc6_ = _loc3_.height + _loc4_.top + _loc4_.bottom + UITextField.TEXT_HEIGHT_PADDING;
            measuredMinWidth = measuredWidth = _loc5_ + _loc1_;
            measuredMinHeight = measuredHeight = Math.max(_loc6_,_loc2_);
         }
         else
         {
            measuredMinWidth = DEFAULT_MEASURED_MIN_WIDTH;
            measuredWidth = DEFAULT_MEASURED_WIDTH;
            measuredMinHeight = DEFAULT_MEASURED_MIN_HEIGHT;
            measuredHeight = DEFAULT_MEASURED_HEIGHT;
         }
         if(FlexVersion.compatibilityVersion >= FlexVersion.VERSION_3_0)
         {
            _loc7_ = getStyle("paddingTop") + getStyle("paddingBottom");
            measuredMinHeight = measuredMinHeight + _loc7_;
            measuredHeight = measuredHeight + _loc7_;
         }
      }
      
      protected function textInput_changeHandler(param1:Event) : void
      {
         _text = textInput.text;
         if(_selectedIndex != -1)
         {
            _selectedIndex = -1;
            _selectedItem = null;
            selectedUID = null;
         }
      }
      
      mx_internal function getTextInput() : mx.controls.TextInput
      {
         return textInput;
      }
      
      override protected function focusInHandler(param1:FocusEvent) : void
      {
         super.focusInHandler(param1);
      }
      
      [Bindable("valueCommit")]
      [Bindable("change")]
      public function get value() : Object
      {
         if(_editable)
         {
            return text;
         }
         var _loc1_:Object = selectedItem;
         if(_loc1_ == null || typeof _loc1_ != "object")
         {
            return _loc1_;
         }
         return _loc1_.data != null?_loc1_.data:_loc1_.label;
      }
      
      private function textInput_mouseEventHandler(param1:Event) : void
      {
         downArrowButton.dispatchEvent(param1);
      }
      
      public function set selectedIndex(param1:int) : void
      {
         var _loc2_:CursorBookmark = null;
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         var _loc5_:String = null;
         _selectedIndex = param1;
         if(param1 == -1)
         {
            _selectedItem = null;
            selectedUID = null;
         }
         if(!collection || collection.length == 0)
         {
            selectedIndexChanged = true;
         }
         else if(param1 != -1)
         {
            param1 = Math.min(param1,collection.length - 1);
            _loc2_ = iterator.bookmark;
            _loc3_ = param1;
            iterator.seek(CursorBookmark.FIRST,_loc3_);
            _loc4_ = iterator.current;
            _loc5_ = itemToUID(_loc4_);
            iterator.seek(_loc2_,0);
            _selectedIndex = param1;
            _selectedItem = _loc4_;
            selectedUID = _loc5_;
         }
         selectionChanged = true;
         invalidateDisplayList();
         dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));
      }
      
      public function set dataProvider(param1:Object) : void
      {
         var _loc3_:Array = null;
         if(param1 is Array)
         {
            collection = new ArrayCollection(param1 as Array);
         }
         else if(param1 is ICollectionView)
         {
            collection = ICollectionView(param1);
         }
         else if(param1 is IList)
         {
            collection = new ListCollectionView(IList(param1));
         }
         else if(param1 is XMLList)
         {
            collection = new XMLListCollection(param1 as XMLList);
         }
         else
         {
            _loc3_ = [param1];
            collection = new ArrayCollection(_loc3_);
         }
         iterator = collection.createCursor();
         collectionIterator = collection.createCursor();
         collection.addEventListener(CollectionEvent.COLLECTION_CHANGE,collectionChangeHandler,false,0,true);
         var _loc2_:CollectionEvent = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE);
         _loc2_.kind = CollectionEventKind.RESET;
         collectionChangeHandler(_loc2_);
         dispatchEvent(_loc2_);
         invalidateSize();
         invalidateDisplayList();
      }
      
      protected function get borderMetrics() : EdgeMetrics
      {
         if(border && border is IRectangularBorder)
         {
            return IRectangularBorder(border).borderMetrics;
         }
         return EdgeMetrics.EMPTY;
      }
      
      public function set restrict(param1:String) : void
      {
         _restrict = param1;
         invalidateProperties();
         dispatchEvent(new Event("restrictChanged"));
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         var _loc7_:EdgeMetrics = null;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         super.updateDisplayList(param1,param2);
         var _loc3_:Number = param1;
         var _loc4_:Number = param2;
         var _loc5_:Number = getStyle("arrowButtonWidth");
         var _loc6_:Number = textInput.getExplicitOrMeasuredHeight();
         if(isNaN(_loc5_))
         {
            _loc5_ = 0;
         }
         if(wrapDownArrowButton)
         {
            _loc7_ = borderMetrics;
            _loc8_ = _loc4_ - _loc7_.top - _loc7_.bottom;
            downArrowButton.setActualSize(_loc8_,_loc8_);
            downArrowButton.move(_loc3_ - _loc5_ - _loc7_.right,_loc7_.top);
            border.setActualSize(_loc3_,_loc4_);
            textInput.setActualSize(_loc3_ - _loc5_,_loc6_);
         }
         else if(!_editable && useFullDropdownSkin)
         {
            _loc9_ = getStyle("paddingTop");
            _loc10_ = getStyle("paddingBottom");
            downArrowButton.move(0,0);
            border.setActualSize(_loc3_,_loc4_);
            textInput.setActualSize(_loc3_ - _loc5_,_loc6_);
            textInput.border.visible = false;
            if(FlexVersion.compatibilityVersion >= FlexVersion.VERSION_3_0)
            {
               textInput.move(textInput.x,(_loc4_ - _loc6_ - _loc9_ - _loc10_) / 2 + _loc9_);
            }
            downArrowButton.setActualSize(param1,param2);
         }
         else
         {
            downArrowButton.move(_loc3_ - _loc5_,0);
            border.setActualSize(_loc3_ - _loc5_,_loc4_);
            textInput.setActualSize(_loc3_ - _loc5_,_loc4_);
            downArrowButton.setActualSize(_loc5_,param2);
            textInput.border.visible = true;
         }
         if(selectedItemChanged)
         {
            selectedItem = selectedItem;
            selectedItemChanged = false;
            selectedIndexChanged = false;
         }
         if(selectedIndexChanged)
         {
            selectedIndex = selectedIndex;
            selectedIndexChanged = false;
         }
      }
      
      [Bindable("valueCommit")]
      [Bindable("change")]
      public function get selectedIndex() : int
      {
         return _selectedIndex;
      }
   }
}
