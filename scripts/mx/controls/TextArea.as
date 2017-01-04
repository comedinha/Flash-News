package mx.controls
{
   import flash.accessibility.AccessibilityProperties;
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.IOErrorEvent;
   import flash.events.MouseEvent;
   import flash.events.TextEvent;
   import flash.system.IME;
   import flash.system.IMEConversionMode;
   import flash.text.StyleSheet;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFieldType;
   import flash.text.TextLineMetrics;
   import mx.controls.listClasses.BaseListData;
   import mx.controls.listClasses.IDropInListItemRenderer;
   import mx.controls.listClasses.IListItemRenderer;
   import mx.core.EdgeMetrics;
   import mx.core.FlexVersion;
   import mx.core.IDataRenderer;
   import mx.core.IFlexModuleFactory;
   import mx.core.IFontContextComponent;
   import mx.core.IIMESupport;
   import mx.core.IInvalidating;
   import mx.core.IUITextField;
   import mx.core.ScrollControlBase;
   import mx.core.ScrollPolicy;
   import mx.core.UITextField;
   import mx.core.mx_internal;
   import mx.events.FlexEvent;
   import mx.events.ScrollEvent;
   import mx.events.ScrollEventDetail;
   import mx.events.ScrollEventDirection;
   import mx.managers.IFocusManager;
   import mx.managers.IFocusManagerComponent;
   
   use namespace mx_internal;
   
   public class TextArea extends ScrollControlBase implements IDataRenderer, IDropInListItemRenderer, IFocusManagerComponent, IIMESupport, IListItemRenderer, IFontContextComponent
   {
      
      mx_internal static const VERSION:String = "3.6.0.21751";
       
      
      private var _text:String = "";
      
      private var _selectable:Boolean = true;
      
      private var _textWidth:Number;
      
      private var _restrict:String = null;
      
      private var htmlTextChanged:Boolean = false;
      
      private var _maxChars:int = 0;
      
      private var enabledChanged:Boolean = false;
      
      private var _condenseWhite:Boolean = false;
      
      private var accessibilityPropertiesChanged:Boolean = false;
      
      private var _hScrollPosition:Number;
      
      private var _textHeight:Number;
      
      private var displayAsPasswordChanged:Boolean = false;
      
      private var prevMode:String = "UNKNOWN";
      
      private var selectableChanged:Boolean = false;
      
      private var restrictChanged:Boolean = false;
      
      private var selectionChanged:Boolean = false;
      
      private var maxCharsChanged:Boolean = false;
      
      private var _tabIndex:int = -1;
      
      private var errorCaught:Boolean = false;
      
      private var _selectionBeginIndex:int = 0;
      
      private var wordWrapChanged:Boolean = false;
      
      private var _data:Object;
      
      private var explicitHTMLText:String = null;
      
      private var styleSheetChanged:Boolean = false;
      
      private var tabIndexChanged:Boolean = false;
      
      private var editableChanged:Boolean = false;
      
      private var _editable:Boolean = true;
      
      private var allowScrollEvent:Boolean = true;
      
      private var _imeMode:String = null;
      
      private var condenseWhiteChanged:Boolean = false;
      
      protected var textField:IUITextField;
      
      private var _listData:BaseListData;
      
      private var _displayAsPassword:Boolean = false;
      
      private var _wordWrap:Boolean = true;
      
      private var _styleSheet:StyleSheet;
      
      private var textChanged:Boolean = false;
      
      private var _accessibilityProperties:AccessibilityProperties;
      
      private var _selectionEndIndex:int = 0;
      
      private var _htmlText:String = "";
      
      private var _vScrollPosition:Number;
      
      private var textSet:Boolean;
      
      public function TextArea()
      {
         super();
         tabChildren = true;
         _horizontalScrollPolicy = ScrollPolicy.AUTO;
         _verticalScrollPolicy = ScrollPolicy.AUTO;
      }
      
      public function get imeMode() : String
      {
         return _imeMode;
      }
      
      public function set imeMode(param1:String) : void
      {
         _imeMode = param1;
      }
      
      override protected function focusOutHandler(param1:FocusEvent) : void
      {
         var _loc2_:IFocusManager = focusManager;
         if(_loc2_)
         {
            _loc2_.defaultButtonEnabled = true;
         }
         super.focusOutHandler(param1);
         if(_imeMode != null && _editable)
         {
            if(IME.conversionMode != IMEConversionMode.UNKNOWN && prevMode != IMEConversionMode.UNKNOWN)
            {
               IME.conversionMode = prevMode;
            }
            IME.enabled = false;
         }
         dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));
      }
      
      mx_internal function getTextField() : IUITextField
      {
         return textField;
      }
      
      private function textField_textInputHandler(param1:TextEvent) : void
      {
         param1.stopImmediatePropagation();
         var _loc2_:TextEvent = new TextEvent(TextEvent.TEXT_INPUT,false,true);
         _loc2_.text = param1.text;
         dispatchEvent(_loc2_);
         if(_loc2_.isDefaultPrevented())
         {
            param1.preventDefault();
         }
      }
      
      override public function get accessibilityProperties() : AccessibilityProperties
      {
         return _accessibilityProperties;
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         createTextField(-1);
      }
      
      private function adjustScrollBars() : void
      {
         var _loc1_:Number = textField.bottomScrollV - textField.scrollV + 1;
         var _loc2_:Number = textField.numLines;
         setScrollBarProperties(textField.width + textField.maxScrollH,textField.width,textField.numLines,_loc1_);
      }
      
      private function textFieldChanged(param1:Boolean, param2:Boolean) : void
      {
         var _loc3_:* = false;
         var _loc4_:* = false;
         if(!param1)
         {
            _loc3_ = _text != textField.text;
            _text = textField.text;
         }
         _loc4_ = _htmlText != textField.htmlText;
         _htmlText = textField.htmlText;
         if(_loc3_)
         {
            dispatchEvent(new Event("textChanged"));
            if(param2)
            {
               dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));
            }
         }
         if(_loc4_)
         {
            dispatchEvent(new Event("htmlTextChanged"));
         }
         _textWidth = textField.textWidth;
         _textHeight = textField.textHeight;
      }
      
      private function textField_ioErrorHandler(param1:IOErrorEvent) : void
      {
      }
      
      [NonCommittingChangeEvent("change")]
      [Bindable("textChanged")]
      public function get text() : String
      {
         return _text;
      }
      
      public function get styleSheet() : StyleSheet
      {
         return _styleSheet;
      }
      
      mx_internal function createTextField(param1:int) : void
      {
         if(!textField)
         {
            textField = IUITextField(createInFontContext(UITextField));
            textField.autoSize = TextFieldAutoSize.NONE;
            textField.enabled = enabled;
            textField.ignorePadding = true;
            textField.multiline = true;
            textField.selectable = true;
            textField.styleName = this;
            textField.tabEnabled = true;
            textField.type = TextFieldType.INPUT;
            textField.useRichTextClipboard = true;
            textField.wordWrap = true;
            textField.addEventListener(Event.CHANGE,textField_changeHandler);
            textField.addEventListener(Event.SCROLL,textField_scrollHandler);
            textField.addEventListener(IOErrorEvent.IO_ERROR,textField_ioErrorHandler);
            textField.addEventListener(TextEvent.TEXT_INPUT,textField_textInputHandler);
            textField.addEventListener("textFieldStyleChange",textField_textFieldStyleChangeHandler);
            textField.addEventListener("textFormatChange",textField_textFormatChangeHandler);
            textField.addEventListener("textInsert",textField_textModifiedHandler);
            textField.addEventListener("textReplace",textField_textModifiedHandler);
            textField.addEventListener("nativeDragDrop",textField_nativeDragDropHandler);
            if(param1 == -1)
            {
               addChild(DisplayObject(textField));
            }
            else
            {
               addChildAt(DisplayObject(textField),param1);
            }
         }
      }
      
      override public function get tabIndex() : int
      {
         return _tabIndex;
      }
      
      override public function set accessibilityProperties(param1:AccessibilityProperties) : void
      {
         if(param1 == _accessibilityProperties)
         {
            return;
         }
         _accessibilityProperties = param1;
         accessibilityPropertiesChanged = true;
         invalidateProperties();
      }
      
      public function setSelection(param1:int, param2:int) : void
      {
         _selectionBeginIndex = param1;
         _selectionEndIndex = param2;
         selectionChanged = true;
         invalidateProperties();
      }
      
      [Bindable("condenseWhiteChanged")]
      public function get condenseWhite() : Boolean
      {
         return _condenseWhite;
      }
      
      override protected function isOurFocus(param1:DisplayObject) : Boolean
      {
         return param1 == textField || super.isOurFocus(param1);
      }
      
      [Bindable("displayAsPasswordChanged")]
      public function get displayAsPassword() : Boolean
      {
         return _displayAsPassword;
      }
      
      public function get selectionBeginIndex() : int
      {
         return !!textField?int(textField.selectionBeginIndex):int(_selectionBeginIndex);
      }
      
      public function get selectable() : Boolean
      {
         return _selectable;
      }
      
      [Bindable("viewChanged")]
      [Bindable("scroll")]
      override public function set verticalScrollPosition(param1:Number) : void
      {
         super.verticalScrollPosition = param1;
         _vScrollPosition = param1;
         if(textField)
         {
            textField.scrollV = param1 + 1;
            textField.background = false;
         }
         else
         {
            invalidateProperties();
         }
      }
      
      public function set text(param1:String) : void
      {
         textSet = true;
         if(!param1)
         {
            param1 = "";
         }
         if(!isHTML && param1 == _text)
         {
            return;
         }
         _text = param1;
         textChanged = true;
         _htmlText = null;
         explicitHTMLText = null;
         invalidateProperties();
         invalidateSize();
         invalidateDisplayList();
         dispatchEvent(new Event("textChanged"));
         dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));
      }
      
      public function set data(param1:Object) : void
      {
         var _loc2_:* = undefined;
         _data = param1;
         if(_listData)
         {
            _loc2_ = _listData.label;
         }
         else if(_data != null)
         {
            if(_data is String)
            {
               _loc2_ = String(_data);
            }
            else
            {
               _loc2_ = _data.toString();
            }
         }
         if(_loc2_ !== undefined && !textSet)
         {
            text = _loc2_;
            textSet = false;
         }
         dispatchEvent(new FlexEvent(FlexEvent.DATA_CHANGE));
      }
      
      public function set styleSheet(param1:StyleSheet) : void
      {
         _styleSheet = param1;
         styleSheetChanged = true;
         htmlTextChanged = true;
         invalidateProperties();
      }
      
      override protected function measure() : void
      {
         super.measure();
         measuredMinWidth = DEFAULT_MEASURED_MIN_WIDTH;
         measuredWidth = DEFAULT_MEASURED_WIDTH;
         measuredMinHeight = measuredHeight = 2 * DEFAULT_MEASURED_MIN_HEIGHT;
      }
      
      public function get fontContext() : IFlexModuleFactory
      {
         return moduleFactory;
      }
      
      public function get selectionEndIndex() : int
      {
         return !!textField?int(textField.selectionEndIndex):int(_selectionEndIndex);
      }
      
      [Bindable("editableChanged")]
      public function get editable() : Boolean
      {
         return _editable;
      }
      
      override protected function focusInHandler(param1:FocusEvent) : void
      {
         var message:String = null;
         var event:FocusEvent = param1;
         if(event.target == this)
         {
            systemManager.stage.focus = TextField(textField);
         }
         var fm:IFocusManager = focusManager;
         if(editable && fm)
         {
            fm.showFocusIndicator = true;
         }
         if(fm)
         {
            fm.defaultButtonEnabled = false;
         }
         super.focusInHandler(event);
         if(_imeMode != null && _editable)
         {
            IME.enabled = true;
            prevMode = IME.conversionMode;
            try
            {
               if(!errorCaught && IME.conversionMode != IMEConversionMode.UNKNOWN)
               {
                  IME.conversionMode = _imeMode;
               }
               errorCaught = false;
               return;
            }
            catch(e:Error)
            {
               errorCaught = true;
               message = resourceManager.getString("controls","unsupportedMode",[_imeMode]);
               throw new Error(message);
            }
         }
      }
      
      [Bindable("dataChange")]
      public function get listData() : BaseListData
      {
         return _listData;
      }
      
      [Bindable("wordWrapChanged")]
      public function get wordWrap() : Boolean
      {
         return _wordWrap;
      }
      
      override public function set tabIndex(param1:int) : void
      {
         if(param1 == _tabIndex)
         {
            return;
         }
         _tabIndex = param1;
         tabIndexChanged = true;
         invalidateProperties();
      }
      
      [NonCommittingChangeEvent("change")]
      [Bindable("htmlTextChanged")]
      public function get htmlText() : String
      {
         return _htmlText;
      }
      
      override public function set enabled(param1:Boolean) : void
      {
         if(param1 == enabled)
         {
            return;
         }
         super.enabled = param1;
         enabledChanged = true;
         if(verticalScrollBar)
         {
            verticalScrollBar.enabled = param1;
         }
         if(horizontalScrollBar)
         {
            horizontalScrollBar.enabled = param1;
         }
         invalidateProperties();
         if(border && border is IInvalidating)
         {
            IInvalidating(border).invalidateDisplayList();
         }
      }
      
      private function textField_textFieldStyleChangeHandler(param1:Event) : void
      {
         textFieldChanged(true,false);
      }
      
      public function set restrict(param1:String) : void
      {
         if(param1 == _restrict)
         {
            return;
         }
         _restrict = param1;
         restrictChanged = true;
         invalidateProperties();
         dispatchEvent(new Event("restrictChanged"));
      }
      
      private function textField_nativeDragDropHandler(param1:Event) : void
      {
         textField_changeHandler(param1);
      }
      
      override public function get baselinePosition() : Number
      {
         var _loc1_:String = null;
         if(FlexVersion.compatibilityVersion < FlexVersion.VERSION_3_0)
         {
            _loc1_ = text;
            if(!_loc1_ || _loc1_ == "")
            {
               _loc1_ = " ";
            }
            return viewMetrics.top + measureText(_loc1_).ascent;
         }
         if(!validateBaselinePosition())
         {
            return NaN;
         }
         return textField.y + textField.baselinePosition;
      }
      
      private function textField_changeHandler(param1:Event) : void
      {
         textFieldChanged(false,false);
         adjustScrollBars();
         textChanged = false;
         htmlTextChanged = false;
         param1.stopImmediatePropagation();
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      public function set condenseWhite(param1:Boolean) : void
      {
         if(param1 == _condenseWhite)
         {
            return;
         }
         _condenseWhite = param1;
         condenseWhiteChanged = true;
         if(isHTML)
         {
            htmlTextChanged = true;
         }
         invalidateProperties();
         invalidateSize();
         invalidateDisplayList();
         dispatchEvent(new Event("condenseWhiteChanged"));
      }
      
      public function get textWidth() : Number
      {
         return _textWidth;
      }
      
      public function set displayAsPassword(param1:Boolean) : void
      {
         if(param1 == _displayAsPassword)
         {
            return;
         }
         _displayAsPassword = param1;
         displayAsPasswordChanged = true;
         invalidateProperties();
         invalidateSize();
         invalidateDisplayList();
         dispatchEvent(new Event("displayAsPasswordChanged"));
      }
      
      override public function get horizontalScrollPolicy() : String
      {
         return height <= 40?ScrollPolicy.OFF:_horizontalScrollPolicy;
      }
      
      [Bindable("dataChange")]
      public function get data() : Object
      {
         return _data;
      }
      
      override public function get maxVerticalScrollPosition() : Number
      {
         return !!textField?Number(textField.maxScrollV - 1):Number(0);
      }
      
      public function set maxChars(param1:int) : void
      {
         if(param1 == _maxChars)
         {
            return;
         }
         _maxChars = param1;
         maxCharsChanged = true;
         invalidateProperties();
         dispatchEvent(new Event("maxCharsChanged"));
      }
      
      public function set selectable(param1:Boolean) : void
      {
         if(param1 == selectable)
         {
            return;
         }
         _selectable = param1;
         selectableChanged = true;
         invalidateProperties();
      }
      
      [Bindable("viewChanged")]
      [Bindable("scroll")]
      override public function set horizontalScrollPosition(param1:Number) : void
      {
         super.horizontalScrollPosition = param1;
         _hScrollPosition = param1;
         if(textField)
         {
            textField.scrollH = param1;
            textField.background = false;
         }
         else
         {
            invalidateProperties();
         }
      }
      
      override public function setFocus() : void
      {
         var _loc1_:int = verticalScrollPosition;
         allowScrollEvent = false;
         textField.setFocus();
         verticalScrollPosition = _loc1_;
         allowScrollEvent = true;
      }
      
      public function set selectionBeginIndex(param1:int) : void
      {
         _selectionBeginIndex = param1;
         selectionChanged = true;
         invalidateProperties();
      }
      
      [Bindable("restrictChanged")]
      public function get restrict() : String
      {
         return _restrict;
      }
      
      override protected function scrollHandler(param1:Event) : void
      {
         if(param1 is ScrollEvent)
         {
            if(!liveScrolling && ScrollEvent(param1).detail == ScrollEventDetail.THUMB_TRACK)
            {
               return;
            }
            super.scrollHandler(param1);
            textField.scrollH = horizontalScrollPosition;
            textField.scrollV = verticalScrollPosition + 1;
            _vScrollPosition = textField.scrollV - 1;
            _hScrollPosition = textField.scrollH;
         }
      }
      
      public function set fontContext(param1:IFlexModuleFactory) : void
      {
         this.moduleFactory = param1;
      }
      
      mx_internal function removeTextField() : void
      {
         if(textField)
         {
            textField.removeEventListener(Event.CHANGE,textField_changeHandler);
            textField.removeEventListener(Event.SCROLL,textField_scrollHandler);
            textField.removeEventListener(IOErrorEvent.IO_ERROR,textField_ioErrorHandler);
            textField.removeEventListener(TextEvent.TEXT_INPUT,textField_textInputHandler);
            textField.removeEventListener("textFieldStyleChange",textField_textFieldStyleChangeHandler);
            textField.removeEventListener("textFormatChange",textField_textFormatChangeHandler);
            textField.removeEventListener("textInsert",textField_textModifiedHandler);
            textField.removeEventListener("textReplace",textField_textModifiedHandler);
            textField.removeEventListener("nativeDragDrop",textField_nativeDragDropHandler);
            removeChild(DisplayObject(textField));
            textField = null;
         }
      }
      
      public function set selectionEndIndex(param1:int) : void
      {
         _selectionEndIndex = param1;
         selectionChanged = true;
         invalidateProperties();
      }
      
      public function get textHeight() : Number
      {
         return _textHeight;
      }
      
      public function set editable(param1:Boolean) : void
      {
         if(param1 == _editable)
         {
            return;
         }
         _editable = param1;
         editableChanged = true;
         invalidateProperties();
         dispatchEvent(new Event("editableChanged"));
      }
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
         if(hasFontContextChanged() && textField != null)
         {
            removeTextField();
            createTextField(-1);
            accessibilityPropertiesChanged = true;
            condenseWhiteChanged = true;
            displayAsPasswordChanged = true;
            editableChanged = true;
            enabledChanged = true;
            maxCharsChanged = true;
            restrictChanged = true;
            selectableChanged = true;
            tabIndexChanged = true;
            wordWrapChanged = true;
            textChanged = true;
            selectionChanged = true;
         }
         if(accessibilityPropertiesChanged)
         {
            textField.accessibilityProperties = _accessibilityProperties;
            accessibilityPropertiesChanged = false;
         }
         if(condenseWhiteChanged)
         {
            textField.condenseWhite = _condenseWhite;
            condenseWhiteChanged = false;
         }
         if(displayAsPasswordChanged)
         {
            textField.displayAsPassword = _displayAsPassword;
            displayAsPasswordChanged = false;
         }
         if(editableChanged)
         {
            textField.type = _editable && enabled?TextFieldType.INPUT:TextFieldType.DYNAMIC;
            editableChanged = false;
         }
         if(enabledChanged)
         {
            textField.enabled = enabled;
            enabledChanged = false;
         }
         if(maxCharsChanged)
         {
            textField.maxChars = _maxChars;
            maxCharsChanged = false;
         }
         if(restrictChanged)
         {
            textField.restrict = _restrict;
            restrictChanged = false;
         }
         if(selectableChanged)
         {
            textField.selectable = _selectable;
            selectableChanged = false;
         }
         if(styleSheetChanged)
         {
            textField.styleSheet = _styleSheet;
            styleSheetChanged = false;
         }
         if(tabIndexChanged)
         {
            textField.tabIndex = _tabIndex;
            tabIndexChanged = false;
         }
         if(wordWrapChanged)
         {
            textField.wordWrap = _wordWrap;
            wordWrapChanged = false;
         }
         if(textChanged || htmlTextChanged)
         {
            if(isHTML)
            {
               textField.htmlText = explicitHTMLText;
            }
            else
            {
               textField.text = _text;
            }
            textFieldChanged(false,true);
            textChanged = false;
            htmlTextChanged = false;
         }
         if(selectionChanged)
         {
            textField.setSelection(_selectionBeginIndex,_selectionEndIndex);
            selectionChanged = false;
         }
         if(!isNaN(_hScrollPosition))
         {
            horizontalScrollPosition = _hScrollPosition;
         }
         if(!isNaN(_vScrollPosition))
         {
            verticalScrollPosition = _vScrollPosition;
         }
      }
      
      private function get isHTML() : Boolean
      {
         return explicitHTMLText != null;
      }
      
      public function set listData(param1:BaseListData) : void
      {
         _listData = param1;
      }
      
      [Bindable("maxCharsChanged")]
      public function get maxChars() : int
      {
         return _maxChars;
      }
      
      override public function get maxHorizontalScrollPosition() : Number
      {
         return !!textField?Number(textField.maxScrollH):Number(0);
      }
      
      override protected function mouseWheelHandler(param1:MouseEvent) : void
      {
         param1.stopPropagation();
      }
      
      private function textField_scrollHandler(param1:Event) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:ScrollEvent = null;
         if(initialized && allowScrollEvent)
         {
            _loc2_ = textField.scrollH - horizontalScrollPosition;
            _loc3_ = textField.scrollV - 1 - verticalScrollPosition;
            horizontalScrollPosition = textField.scrollH;
            verticalScrollPosition = textField.scrollV - 1;
            if(_loc2_)
            {
               _loc4_ = new ScrollEvent(ScrollEvent.SCROLL,false,false,null,horizontalScrollPosition,ScrollEventDirection.HORIZONTAL,_loc2_);
               dispatchEvent(_loc4_);
            }
            if(_loc3_)
            {
               _loc4_ = new ScrollEvent(ScrollEvent.SCROLL,false,false,null,verticalScrollPosition,ScrollEventDirection.VERTICAL,_loc3_);
               dispatchEvent(_loc4_);
            }
         }
      }
      
      public function set wordWrap(param1:Boolean) : void
      {
         if(param1 == _wordWrap)
         {
            return;
         }
         _wordWrap = param1;
         wordWrapChanged = true;
         invalidateProperties();
         invalidateDisplayList();
         dispatchEvent(new Event("wordWrapChanged"));
      }
      
      private function textField_textModifiedHandler(param1:Event) : void
      {
         textFieldChanged(false,true);
      }
      
      private function textField_textFormatChangeHandler(param1:Event) : void
      {
         textFieldChanged(true,false);
      }
      
      public function set htmlText(param1:String) : void
      {
         textSet = true;
         if(!param1)
         {
            param1 = "";
         }
         _htmlText = param1;
         htmlTextChanged = true;
         _text = null;
         explicitHTMLText = param1;
         invalidateProperties();
         invalidateSize();
         invalidateDisplayList();
         dispatchEvent(new Event("htmlTextChanged"));
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         super.updateDisplayList(param1,param2);
         var _loc3_:EdgeMetrics = viewMetrics;
         _loc3_.left = _loc3_.left + getStyle("paddingLeft");
         _loc3_.top = _loc3_.top + getStyle("paddingTop");
         _loc3_.right = _loc3_.right + getStyle("paddingRight");
         _loc3_.bottom = _loc3_.bottom + getStyle("paddingBottom");
         textField.move(_loc3_.left,_loc3_.top);
         var _loc4_:Number = param1 - _loc3_.left - _loc3_.right;
         var _loc5_:Number = param2 - _loc3_.top - _loc3_.bottom;
         if(_loc3_.top + _loc3_.bottom > 0)
         {
            _loc5_++;
         }
         textField.setActualSize(Math.max(4,_loc4_),Math.max(4,_loc5_));
         if(!initialized)
         {
            callLater(invalidateDisplayList);
         }
         else
         {
            callLater(adjustScrollBars);
         }
         if(isNaN(_hScrollPosition))
         {
            _hScrollPosition = 0;
         }
         if(isNaN(_vScrollPosition))
         {
            _vScrollPosition = 0;
         }
         var _loc6_:Number = Math.min(textField.maxScrollH,_hScrollPosition);
         if(_loc6_ != textField.scrollH)
         {
            horizontalScrollPosition = _loc6_;
         }
         _loc6_ = Math.min(textField.maxScrollV - 1,_vScrollPosition);
         if(_loc6_ != textField.scrollV - 1)
         {
            verticalScrollPosition = _loc6_;
         }
      }
      
      public function getLineMetrics(param1:int) : TextLineMetrics
      {
         return !!textField?textField.getLineMetrics(param1):null;
      }
      
      override public function get verticalScrollPolicy() : String
      {
         return height <= 40?ScrollPolicy.OFF:_verticalScrollPolicy;
      }
      
      public function get length() : int
      {
         return text != null?int(text.length):-1;
      }
   }
}
