package mx.controls
{
   import mx.core.UIComponent;
   import mx.core.IDataRenderer;
   import mx.controls.listClasses.IDropInListItemRenderer;
   import mx.managers.IFocusManagerComponent;
   import mx.controls.listClasses.IListItemRenderer;
   import mx.core.IFontContextComponent;
   import mx.core.IButton;
   import mx.core.mx_internal;
   import mx.core.UITextField;
   import mx.core.EdgeMetrics;
   import mx.core.IFlexDisplayObject;
   import flash.text.TextLineMetrics;
   import flash.events.MouseEvent;
   import flash.display.DisplayObject;
   import mx.core.IProgrammaticSkin;
   import mx.core.IStateClient;
   import mx.styles.ISimpleStyleClient;
   import mx.core.IInvalidating;
   import mx.core.IUIComponent;
   import mx.core.IUITextField;
   import mx.core.FlexVersion;
   import flash.events.Event;
   import mx.events.FlexEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import flash.events.FocusEvent;
   import mx.controls.dataGridClasses.DataGridListData;
   import mx.core.IFlexModuleFactory;
   import mx.controls.listClasses.BaseListData;
   import mx.events.MoveEvent;
   import mx.core.IBorder;
   import mx.core.IFlexAsset;
   import mx.events.SandboxMouseEvent;
   import flash.events.KeyboardEvent;
   import flash.ui.Keyboard;
   import mx.core.IRectangularBorder;
   
   use namespace mx_internal;
   
   public class Button extends UIComponent implements IDataRenderer, IDropInListItemRenderer, IFocusManagerComponent, IListItemRenderer, IFontContextComponent, IButton
   {
      
      mx_internal static var createAccessibilityImplementation:Function;
      
      mx_internal static var TEXT_WIDTH_PADDING:Number = UITextField.TEXT_WIDTH_PADDING + 1;
      
      mx_internal static const VERSION:String = "3.6.0.21751";
       
      
      mx_internal var _emphasized:Boolean = false;
      
      mx_internal var extraSpacing:Number = 20.0;
      
      private var icons:Array;
      
      public var selectedField:String = null;
      
      private var labelChanged:Boolean = false;
      
      private var skinMeasuredWidth:Number;
      
      mx_internal var checkedDefaultSkin:Boolean = false;
      
      private var autoRepeatTimer:Timer;
      
      mx_internal var disabledIconName:String = "disabledIcon";
      
      mx_internal var disabledSkinName:String = "disabledSkin";
      
      mx_internal var checkedDefaultIcon:Boolean = false;
      
      public var stickyHighlighting:Boolean = false;
      
      private var enabledChanged:Boolean = false;
      
      mx_internal var selectedUpIconName:String = "selectedUpIcon";
      
      mx_internal var selectedUpSkinName:String = "selectedUpSkin";
      
      mx_internal var upIconName:String = "upIcon";
      
      mx_internal var upSkinName:String = "upSkin";
      
      mx_internal var centerContent:Boolean = true;
      
      mx_internal var buttonOffset:Number = 0;
      
      private var skinMeasuredHeight:Number;
      
      private var oldUnscaledWidth:Number;
      
      mx_internal var downIconName:String = "downIcon";
      
      mx_internal var _labelPlacement:String = "right";
      
      mx_internal var downSkinName:String = "downSkin";
      
      mx_internal var _toggle:Boolean = false;
      
      private var _phase:String = "up";
      
      private var toolTipSet:Boolean = false;
      
      private var _data:Object;
      
      mx_internal var currentIcon:IFlexDisplayObject;
      
      mx_internal var currentSkin:IFlexDisplayObject;
      
      mx_internal var overIconName:String = "overIcon";
      
      mx_internal var selectedDownIconName:String = "selectedDownIcon";
      
      mx_internal var overSkinName:String = "overSkin";
      
      mx_internal var iconName:String = "icon";
      
      mx_internal var skinName:String = "skin";
      
      mx_internal var selectedDownSkinName:String = "selectedDownSkin";
      
      private var skins:Array;
      
      private var selectedSet:Boolean;
      
      private var _autoRepeat:Boolean = false;
      
      private var styleChangedFlag:Boolean = true;
      
      mx_internal var selectedOverIconName:String = "selectedOverIcon";
      
      private var _listData:BaseListData;
      
      mx_internal var selectedOverSkinName:String = "selectedOverSkin";
      
      protected var textField:IUITextField;
      
      private var labelSet:Boolean;
      
      mx_internal var defaultIconUsesStates:Boolean = false;
      
      mx_internal var defaultSkinUsesStates:Boolean = false;
      
      mx_internal var toggleChanged:Boolean = false;
      
      private var emphasizedChanged:Boolean = false;
      
      private var _label:String = "";
      
      mx_internal var _selected:Boolean = false;
      
      mx_internal var selectedDisabledIconName:String = "selectedDisabledIcon";
      
      mx_internal var selectedDisabledSkinName:String = "selectedDisabledSkin";
      
      public function Button()
      {
         skins = [];
         icons = [];
         super();
         mouseChildren = false;
         addEventListener(MouseEvent.ROLL_OVER,rollOverHandler);
         addEventListener(MouseEvent.ROLL_OUT,rollOutHandler);
         addEventListener(MouseEvent.MOUSE_DOWN,mouseDownHandler);
         addEventListener(MouseEvent.MOUSE_UP,mouseUpHandler);
         addEventListener(MouseEvent.CLICK,clickHandler);
      }
      
      private function previousVersion_measure() : void
      {
         var bm:EdgeMetrics = null;
         var lineMetrics:TextLineMetrics = null;
         var paddingLeft:Number = NaN;
         var paddingRight:Number = NaN;
         var paddingTop:Number = NaN;
         var paddingBottom:Number = NaN;
         var horizontalGap:Number = NaN;
         super.measure();
         var textWidth:Number = 0;
         var textHeight:Number = 0;
         if(label)
         {
            lineMetrics = measureText(label);
            textWidth = lineMetrics.width;
            textHeight = lineMetrics.height;
            paddingLeft = getStyle("paddingLeft");
            paddingRight = getStyle("paddingRight");
            paddingTop = getStyle("paddingTop");
            paddingBottom = getStyle("paddingBottom");
            textWidth = textWidth + (paddingLeft + paddingRight + getStyle("textIndent"));
            textHeight = textHeight + (paddingTop + paddingBottom);
         }
         try
         {
            bm = currentSkin["borderMetrics"];
         }
         catch(e:Error)
         {
            bm = new EdgeMetrics(3,3,3,3);
         }
         var tempCurrentIcon:IFlexDisplayObject = getCurrentIcon();
         var iconWidth:Number = !!tempCurrentIcon?Number(tempCurrentIcon.width):Number(0);
         var iconHeight:Number = !!tempCurrentIcon?Number(tempCurrentIcon.height):Number(0);
         var w:Number = 0;
         var h:Number = 0;
         if(labelPlacement == ButtonLabelPlacement.LEFT || labelPlacement == ButtonLabelPlacement.RIGHT)
         {
            w = textWidth + iconWidth;
            if(iconWidth != 0)
            {
               horizontalGap = getStyle("horizontalGap");
               w = w + (horizontalGap - 2);
            }
            h = Math.max(textHeight,iconHeight + 6);
         }
         else
         {
            w = Math.max(textWidth,iconWidth);
            h = textHeight + iconHeight;
            if(iconHeight != 0)
            {
               h = h + getStyle("verticalGap");
            }
         }
         if(bm)
         {
            w = w + (bm.left + bm.right);
            h = h + (bm.top + bm.bottom);
         }
         if(label && label.length != 0)
         {
            w = w + extraSpacing;
         }
         else
         {
            w = w + 6;
         }
         if(currentSkin && (isNaN(skinMeasuredWidth) || isNaN(skinMeasuredHeight)))
         {
            skinMeasuredWidth = currentSkin.measuredWidth;
            skinMeasuredHeight = currentSkin.measuredHeight;
         }
         if(!isNaN(skinMeasuredWidth))
         {
            w = Math.max(skinMeasuredWidth,w);
         }
         if(!isNaN(skinMeasuredHeight))
         {
            h = Math.max(skinMeasuredHeight,h);
         }
         measuredMinWidth = measuredWidth = w;
         measuredMinHeight = measuredHeight = h;
      }
      
      [Bindable("labelChanged")]
      public function get label() : String
      {
         return _label;
      }
      
      mx_internal function getCurrentIconName() : String
      {
         var _loc1_:String = null;
         if(!enabled)
         {
            _loc1_ = !!selected?selectedDisabledIconName:disabledIconName;
         }
         else if(phase == ButtonPhase.UP)
         {
            _loc1_ = !!selected?selectedUpIconName:upIconName;
         }
         else if(phase == ButtonPhase.OVER)
         {
            _loc1_ = !!selected?selectedOverIconName:overIconName;
         }
         else if(phase == ButtonPhase.DOWN)
         {
            _loc1_ = !!selected?selectedDownIconName:downIconName;
         }
         return _loc1_;
      }
      
      protected function mouseUpHandler(param1:MouseEvent) : void
      {
         if(!enabled)
         {
            return;
         }
         phase = ButtonPhase.OVER;
         buttonReleased();
         if(!toggle)
         {
            param1.updateAfterEvent();
         }
      }
      
      override protected function adjustFocusRect(param1:DisplayObject = null) : void
      {
         super.adjustFocusRect(!currentSkin?DisplayObject(currentIcon):this);
      }
      
      mx_internal function set phase(param1:String) : void
      {
         _phase = param1;
         invalidateSize();
         invalidateDisplayList();
      }
      
      mx_internal function viewIconForPhase(param1:String) : IFlexDisplayObject
      {
         var _loc3_:IFlexDisplayObject = null;
         var _loc4_:Boolean = false;
         var _loc5_:String = null;
         var _loc2_:Class = Class(getStyle(param1));
         if(!_loc2_)
         {
            _loc2_ = Class(getStyle(iconName));
            if(defaultIconUsesStates)
            {
               param1 = iconName;
            }
            if(!checkedDefaultIcon && _loc2_)
            {
               _loc3_ = IFlexDisplayObject(new _loc2_());
               if(!(_loc3_ is IProgrammaticSkin) && _loc3_ is IStateClient)
               {
                  defaultIconUsesStates = true;
                  param1 = iconName;
               }
               if(_loc3_)
               {
                  checkedDefaultIcon = true;
               }
            }
         }
         _loc3_ = IFlexDisplayObject(getChildByName(param1));
         if(_loc3_ == null)
         {
            if(_loc2_ != null)
            {
               _loc3_ = IFlexDisplayObject(new _loc2_());
               _loc3_.name = param1;
               if(_loc3_ is ISimpleStyleClient)
               {
                  ISimpleStyleClient(_loc3_).styleName = this;
               }
               addChild(DisplayObject(_loc3_));
               _loc4_ = false;
               if(_loc3_ is IInvalidating)
               {
                  IInvalidating(_loc3_).validateNow();
                  _loc4_ = true;
               }
               else if(_loc3_ is IProgrammaticSkin)
               {
                  IProgrammaticSkin(_loc3_).validateDisplayList();
                  _loc4_ = true;
               }
               if(_loc3_ && _loc3_ is IUIComponent)
               {
                  IUIComponent(_loc3_).enabled = enabled;
               }
               if(_loc4_)
               {
                  _loc3_.setActualSize(_loc3_.measuredWidth,_loc3_.measuredHeight);
               }
               icons.push(_loc3_);
            }
         }
         if(currentIcon != null)
         {
            currentIcon.visible = false;
         }
         currentIcon = _loc3_;
         if(defaultIconUsesStates && currentIcon is IStateClient)
         {
            _loc5_ = "";
            if(!enabled)
            {
               _loc5_ = !!selected?"selectedDisabled":"disabled";
            }
            else if(phase == ButtonPhase.UP)
            {
               _loc5_ = !!selected?"selectedUp":"up";
            }
            else if(phase == ButtonPhase.OVER)
            {
               _loc5_ = !!selected?"selectedOver":"over";
            }
            else if(phase == ButtonPhase.DOWN)
            {
               _loc5_ = !!selected?"selectedDown":"down";
            }
            IStateClient(currentIcon).currentState = _loc5_;
         }
         if(currentIcon != null)
         {
            currentIcon.visible = true;
         }
         return _loc3_;
      }
      
      mx_internal function viewSkinForPhase(param1:String, param2:String) : void
      {
         var _loc4_:IFlexDisplayObject = null;
         var _loc5_:Number = NaN;
         var _loc6_:ISimpleStyleClient = null;
         var _loc3_:Class = Class(getStyle(param1));
         if(!_loc3_)
         {
            _loc3_ = Class(getStyle(skinName));
            if(defaultSkinUsesStates)
            {
               param1 = skinName;
            }
            if(!checkedDefaultSkin && _loc3_)
            {
               _loc4_ = IFlexDisplayObject(new _loc3_());
               if(!(_loc4_ is IProgrammaticSkin) && _loc4_ is IStateClient)
               {
                  defaultSkinUsesStates = true;
                  param1 = skinName;
               }
               if(_loc4_)
               {
                  checkedDefaultSkin = true;
               }
            }
         }
         _loc4_ = IFlexDisplayObject(getChildByName(param1));
         if(!_loc4_)
         {
            if(_loc3_)
            {
               _loc4_ = IFlexDisplayObject(new _loc3_());
               _loc4_.name = param1;
               _loc6_ = _loc4_ as ISimpleStyleClient;
               if(_loc6_)
               {
                  _loc6_.styleName = this;
               }
               addChild(DisplayObject(_loc4_));
               _loc4_.setActualSize(unscaledWidth,unscaledHeight);
               if(_loc4_ is IInvalidating && initialized)
               {
                  IInvalidating(_loc4_).validateNow();
               }
               else if(_loc4_ is IProgrammaticSkin && initialized)
               {
                  IProgrammaticSkin(_loc4_).validateDisplayList();
               }
               skins.push(_loc4_);
            }
         }
         if(currentSkin)
         {
            currentSkin.visible = false;
         }
         currentSkin = _loc4_;
         if(defaultSkinUsesStates && currentSkin is IStateClient)
         {
            IStateClient(currentSkin).currentState = param2;
         }
         if(currentSkin)
         {
            currentSkin.visible = true;
         }
         if(enabled)
         {
            if(phase == ButtonPhase.OVER)
            {
               _loc5_ = textField.getStyle("textRollOverColor");
            }
            else if(phase == ButtonPhase.DOWN)
            {
               _loc5_ = textField.getStyle("textSelectedColor");
            }
            else
            {
               _loc5_ = textField.getStyle("color");
            }
            textField.setColor(_loc5_);
         }
      }
      
      mx_internal function getTextField() : IUITextField
      {
         return textField;
      }
      
      protected function rollOverHandler(param1:MouseEvent) : void
      {
         if(phase == ButtonPhase.UP)
         {
            if(param1.buttonDown)
            {
               return;
            }
            phase = ButtonPhase.OVER;
            param1.updateAfterEvent();
         }
         else if(phase == ButtonPhase.OVER)
         {
            phase = ButtonPhase.DOWN;
            param1.updateAfterEvent();
            if(autoRepeatTimer)
            {
               autoRepeatTimer.start();
            }
         }
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         if(!textField)
         {
            textField = IUITextField(createInFontContext(UITextField));
            textField.styleName = this;
            addChild(DisplayObject(textField));
         }
      }
      
      mx_internal function setSelected(param1:Boolean, param2:Boolean = false) : void
      {
         if(_selected != param1)
         {
            _selected = param1;
            invalidateDisplayList();
            if(FlexVersion.compatibilityVersion < FlexVersion.VERSION_3_0)
            {
               if(toggle)
               {
                  dispatchEvent(new Event(Event.CHANGE));
               }
            }
            else if(toggle && !param2)
            {
               dispatchEvent(new Event(Event.CHANGE));
            }
            dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));
         }
      }
      
      private function autoRepeatTimer_timerDelayHandler(param1:Event) : void
      {
         if(!enabled)
         {
            return;
         }
         dispatchEvent(new FlexEvent(FlexEvent.BUTTON_DOWN));
         if(autoRepeat)
         {
            autoRepeatTimer.reset();
            autoRepeatTimer.removeEventListener(TimerEvent.TIMER,autoRepeatTimer_timerDelayHandler);
            autoRepeatTimer.delay = getStyle("repeatInterval");
            autoRepeatTimer.addEventListener(TimerEvent.TIMER,autoRepeatTimer_timerHandler);
            autoRepeatTimer.start();
         }
      }
      
      public function get autoRepeat() : Boolean
      {
         return _autoRepeat;
      }
      
      public function set selected(param1:Boolean) : void
      {
         selectedSet = true;
         setSelected(param1,true);
      }
      
      override protected function focusOutHandler(param1:FocusEvent) : void
      {
         super.focusOutHandler(param1);
         if(phase != ButtonPhase.UP)
         {
            phase = ButtonPhase.UP;
         }
      }
      
      [Bindable("labelPlacementChanged")]
      public function get labelPlacement() : String
      {
         return _labelPlacement;
      }
      
      public function set autoRepeat(param1:Boolean) : void
      {
         _autoRepeat = param1;
         if(param1)
         {
            autoRepeatTimer = new Timer(1);
         }
         else
         {
            autoRepeatTimer = null;
         }
      }
      
      mx_internal function changeIcons() : void
      {
         var _loc1_:int = icons.length;
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            removeChild(icons[_loc2_]);
            _loc2_++;
         }
         icons = [];
         checkedDefaultIcon = false;
         defaultIconUsesStates = false;
      }
      
      public function set data(param1:Object) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         _data = param1;
         if(_listData && _listData is DataGridListData && DataGridListData(_listData).dataField != null)
         {
            _loc2_ = _data[DataGridListData(_listData).dataField];
            _loc3_ = "";
         }
         else if(_listData)
         {
            if(selectedField)
            {
               _loc2_ = _data[selectedField];
            }
            _loc3_ = _listData.label;
         }
         else
         {
            _loc2_ = _data;
         }
         if(_loc2_ !== undefined && !selectedSet)
         {
            selected = _loc2_ as Boolean;
            selectedSet = false;
         }
         if(_loc3_ !== undefined && !labelSet)
         {
            label = _loc3_;
            labelSet = false;
         }
         dispatchEvent(new FlexEvent(FlexEvent.DATA_CHANGE));
      }
      
      mx_internal function getCurrentIcon() : IFlexDisplayObject
      {
         var _loc1_:String = getCurrentIconName();
         if(!_loc1_)
         {
            return null;
         }
         return viewIconForPhase(_loc1_);
      }
      
      public function get fontContext() : IFlexModuleFactory
      {
         return moduleFactory;
      }
      
      public function get emphasized() : Boolean
      {
         return _emphasized;
      }
      
      [Bindable("dataChange")]
      public function get listData() : BaseListData
      {
         return _listData;
      }
      
      mx_internal function layoutContents(param1:Number, param2:Number, param3:Boolean) : void
      {
         var _loc20_:TextLineMetrics = null;
         var _loc28_:MoveEvent = null;
         if(FlexVersion.compatibilityVersion < FlexVersion.VERSION_3_0)
         {
            previousVersion_layoutContents(param1,param2,param3);
            return;
         }
         var _loc4_:Number = 0;
         var _loc5_:Number = 0;
         var _loc6_:Number = 0;
         var _loc7_:Number = 0;
         var _loc8_:Number = 0;
         var _loc9_:Number = 0;
         var _loc10_:Number = 0;
         var _loc11_:Number = 0;
         var _loc12_:Number = 0;
         var _loc13_:Number = 0;
         var _loc14_:Number = getStyle("paddingLeft");
         var _loc15_:Number = getStyle("paddingRight");
         var _loc16_:Number = getStyle("paddingTop");
         var _loc17_:Number = getStyle("paddingBottom");
         var _loc18_:Number = 0;
         var _loc19_:Number = 0;
         if(label)
         {
            _loc20_ = measureText(label);
            _loc18_ = _loc20_.width + TEXT_WIDTH_PADDING;
            _loc19_ = _loc20_.height + UITextField.TEXT_HEIGHT_PADDING;
         }
         else
         {
            _loc20_ = measureText("Wj");
            _loc19_ = _loc20_.height + UITextField.TEXT_HEIGHT_PADDING;
         }
         var _loc21_:Number = !!param3?Number(buttonOffset):Number(0);
         var _loc22_:String = getStyle("textAlign");
         var _loc23_:Number = param1;
         var _loc24_:Number = param2;
         var _loc25_:EdgeMetrics = currentSkin && currentSkin is IBorder && !(currentSkin is IFlexAsset)?IBorder(currentSkin).borderMetrics:null;
         if(_loc25_)
         {
            _loc23_ = _loc23_ - (_loc25_.left + _loc25_.right);
            _loc24_ = _loc24_ - (_loc25_.top + _loc25_.bottom);
         }
         if(currentIcon)
         {
            _loc8_ = currentIcon.width;
            _loc9_ = currentIcon.height;
         }
         if(labelPlacement == ButtonLabelPlacement.LEFT || labelPlacement == ButtonLabelPlacement.RIGHT)
         {
            _loc12_ = getStyle("horizontalGap");
            if(_loc8_ == 0 || _loc18_ == 0)
            {
               _loc12_ = 0;
            }
            if(_loc18_ > 0)
            {
               textField.width = _loc4_ = Math.max(Math.min(_loc23_ - _loc8_ - _loc12_ - _loc14_ - _loc15_,_loc18_),0);
            }
            else
            {
               textField.width = _loc4_ = 0;
            }
            textField.height = _loc5_ = Math.min(_loc24_,_loc19_);
            if(_loc22_ == "left")
            {
               _loc6_ = _loc6_ + _loc14_;
            }
            else if(_loc22_ == "right")
            {
               _loc6_ = _loc6_ + (_loc23_ - _loc4_ - _loc8_ - _loc12_ - _loc15_);
            }
            else
            {
               _loc6_ = _loc6_ + ((_loc23_ - _loc4_ - _loc8_ - _loc12_ - _loc14_ - _loc15_) / 2 + _loc14_);
            }
            if(labelPlacement == ButtonLabelPlacement.RIGHT)
            {
               _loc6_ = _loc6_ + (_loc8_ + _loc12_);
               _loc10_ = _loc6_ - (_loc8_ + _loc12_);
            }
            else
            {
               _loc10_ = _loc6_ + _loc4_ + _loc12_;
            }
            _loc11_ = (_loc24_ - _loc9_ - _loc16_ - _loc17_) / 2 + _loc16_;
            _loc7_ = (_loc24_ - _loc5_ - _loc16_ - _loc17_) / 2 + _loc16_;
         }
         else
         {
            _loc13_ = getStyle("verticalGap");
            if(_loc9_ == 0 || label == "")
            {
               _loc13_ = 0;
            }
            if(_loc18_ > 0)
            {
               textField.width = _loc4_ = Math.max(_loc23_ - _loc14_ - _loc15_,0);
               textField.height = _loc5_ = Math.min(_loc24_ - _loc9_ - _loc16_ - _loc17_ - _loc13_,_loc19_);
            }
            else
            {
               textField.width = _loc4_ = 0;
               textField.height = _loc5_ = 0;
            }
            _loc6_ = _loc14_;
            if(_loc22_ == "left")
            {
               _loc10_ = _loc10_ + _loc14_;
            }
            else if(_loc22_ == "right")
            {
               _loc10_ = _loc10_ + Math.max(_loc23_ - _loc8_ - _loc15_,_loc14_);
            }
            else
            {
               _loc10_ = _loc10_ + ((_loc23_ - _loc8_ - _loc14_ - _loc15_) / 2 + _loc14_);
            }
            if(labelPlacement == ButtonLabelPlacement.TOP)
            {
               _loc7_ = _loc7_ + ((_loc24_ - _loc5_ - _loc9_ - _loc16_ - _loc17_ - _loc13_) / 2 + _loc16_);
               _loc11_ = _loc11_ + (_loc7_ + _loc5_ + _loc13_);
            }
            else
            {
               _loc11_ = _loc11_ + ((_loc24_ - _loc5_ - _loc9_ - _loc16_ - _loc17_ - _loc13_) / 2 + _loc16_);
               _loc7_ = _loc7_ + (_loc11_ + _loc9_ + _loc13_);
            }
         }
         var _loc26_:Number = _loc21_;
         var _loc27_:Number = _loc21_;
         if(_loc25_)
         {
            _loc26_ = _loc26_ + _loc25_.left;
            _loc27_ = _loc27_ + _loc25_.top;
         }
         textField.x = Math.round(_loc6_ + _loc26_);
         textField.y = Math.round(_loc7_ + _loc27_);
         if(currentIcon)
         {
            _loc10_ = _loc10_ + _loc26_;
            _loc11_ = _loc11_ + _loc27_;
            _loc28_ = new MoveEvent(MoveEvent.MOVE);
            _loc28_.oldX = currentIcon.x;
            _loc28_.oldY = currentIcon.y;
            currentIcon.x = Math.round(_loc10_);
            currentIcon.y = Math.round(_loc11_);
            currentIcon.dispatchEvent(_loc28_);
         }
         if(currentSkin)
         {
            setChildIndex(DisplayObject(currentSkin),numChildren - 1);
         }
         if(currentIcon)
         {
            setChildIndex(DisplayObject(currentIcon),numChildren - 1);
         }
         if(textField)
         {
            setChildIndex(DisplayObject(textField),numChildren - 1);
         }
      }
      
      protected function mouseDownHandler(param1:MouseEvent) : void
      {
         if(!enabled)
         {
            return;
         }
         systemManager.getSandboxRoot().addEventListener(MouseEvent.MOUSE_UP,systemManager_mouseUpHandler,true);
         systemManager.getSandboxRoot().addEventListener(SandboxMouseEvent.MOUSE_UP_SOMEWHERE,stage_mouseLeaveHandler);
         buttonPressed();
         param1.updateAfterEvent();
      }
      
      override protected function keyDownHandler(param1:KeyboardEvent) : void
      {
         if(!enabled)
         {
            return;
         }
         if(param1.keyCode == Keyboard.SPACE)
         {
            buttonPressed();
         }
      }
      
      protected function rollOutHandler(param1:MouseEvent) : void
      {
         if(phase == ButtonPhase.OVER)
         {
            phase = ButtonPhase.UP;
            param1.updateAfterEvent();
         }
         else if(phase == ButtonPhase.DOWN && !stickyHighlighting)
         {
            phase = ButtonPhase.OVER;
            param1.updateAfterEvent();
            if(autoRepeatTimer)
            {
               autoRepeatTimer.stop();
            }
         }
      }
      
      mx_internal function get phase() : String
      {
         return _phase;
      }
      
      override public function set enabled(param1:Boolean) : void
      {
         if(super.enabled == param1)
         {
            return;
         }
         super.enabled = param1;
         enabledChanged = true;
         invalidateProperties();
         invalidateDisplayList();
      }
      
      override protected function measure() : void
      {
         var _loc9_:TextLineMetrics = null;
         if(FlexVersion.compatibilityVersion < FlexVersion.VERSION_3_0)
         {
            previousVersion_measure();
            return;
         }
         super.measure();
         var _loc1_:Number = 0;
         var _loc2_:Number = 0;
         if(label)
         {
            _loc9_ = measureText(label);
            _loc1_ = _loc9_.width + TEXT_WIDTH_PADDING;
            _loc2_ = _loc9_.height + UITextField.TEXT_HEIGHT_PADDING;
         }
         var _loc3_:IFlexDisplayObject = getCurrentIcon();
         var _loc4_:Number = !!_loc3_?Number(_loc3_.width):Number(0);
         var _loc5_:Number = !!_loc3_?Number(_loc3_.height):Number(0);
         var _loc6_:Number = 0;
         var _loc7_:Number = 0;
         if(labelPlacement == ButtonLabelPlacement.LEFT || labelPlacement == ButtonLabelPlacement.RIGHT)
         {
            _loc6_ = _loc1_ + _loc4_;
            if(_loc1_ && _loc4_)
            {
               _loc6_ = _loc6_ + getStyle("horizontalGap");
            }
            _loc7_ = Math.max(_loc2_,_loc5_);
         }
         else
         {
            _loc6_ = Math.max(_loc1_,_loc4_);
            _loc7_ = _loc2_ + _loc5_;
            if(_loc2_ && _loc5_)
            {
               _loc7_ = _loc7_ + getStyle("verticalGap");
            }
         }
         if(_loc1_ || _loc4_)
         {
            _loc6_ = _loc6_ + (getStyle("paddingLeft") + getStyle("paddingRight"));
            _loc7_ = _loc7_ + (getStyle("paddingTop") + getStyle("paddingBottom"));
         }
         var _loc8_:EdgeMetrics = currentSkin && currentSkin is IBorder && !(currentSkin is IFlexAsset)?IBorder(currentSkin).borderMetrics:null;
         if(_loc8_)
         {
            _loc6_ = _loc6_ + (_loc8_.left + _loc8_.right);
            _loc7_ = _loc7_ + (_loc8_.top + _loc8_.bottom);
         }
         if(currentSkin && (isNaN(skinMeasuredWidth) || isNaN(skinMeasuredHeight)))
         {
            skinMeasuredWidth = currentSkin.measuredWidth;
            skinMeasuredHeight = currentSkin.measuredHeight;
         }
         if(!isNaN(skinMeasuredWidth))
         {
            _loc6_ = Math.max(skinMeasuredWidth,_loc6_);
         }
         if(!isNaN(skinMeasuredHeight))
         {
            _loc7_ = Math.max(skinMeasuredHeight,_loc7_);
         }
         measuredMinWidth = measuredWidth = _loc6_;
         measuredMinHeight = measuredHeight = _loc7_;
      }
      
      [Bindable("toggleChanged")]
      public function get toggle() : Boolean
      {
         return _toggle;
      }
      
      mx_internal function buttonReleased() : void
      {
         systemManager.getSandboxRoot().removeEventListener(MouseEvent.MOUSE_UP,systemManager_mouseUpHandler,true);
         systemManager.getSandboxRoot().removeEventListener(SandboxMouseEvent.MOUSE_UP_SOMEWHERE,stage_mouseLeaveHandler);
         if(autoRepeatTimer)
         {
            autoRepeatTimer.removeEventListener(TimerEvent.TIMER,autoRepeatTimer_timerDelayHandler);
            autoRepeatTimer.removeEventListener(TimerEvent.TIMER,autoRepeatTimer_timerHandler);
            autoRepeatTimer.reset();
         }
      }
      
      mx_internal function buttonPressed() : void
      {
         phase = ButtonPhase.DOWN;
         dispatchEvent(new FlexEvent(FlexEvent.BUTTON_DOWN));
         if(autoRepeat)
         {
            autoRepeatTimer.delay = getStyle("repeatDelay");
            autoRepeatTimer.addEventListener(TimerEvent.TIMER,autoRepeatTimer_timerDelayHandler);
            autoRepeatTimer.start();
         }
      }
      
      override protected function keyUpHandler(param1:KeyboardEvent) : void
      {
         if(!enabled)
         {
            return;
         }
         if(param1.keyCode == Keyboard.SPACE)
         {
            buttonReleased();
            if(phase == ButtonPhase.DOWN)
            {
               dispatchEvent(new MouseEvent(MouseEvent.CLICK));
            }
            phase = ButtonPhase.UP;
         }
      }
      
      [Bindable("valueCommit")]
      [Bindable("click")]
      public function get selected() : Boolean
      {
         return _selected;
      }
      
      public function set labelPlacement(param1:String) : void
      {
         _labelPlacement = param1;
         invalidateSize();
         invalidateDisplayList();
         dispatchEvent(new Event("labelPlacementChanged"));
      }
      
      protected function clickHandler(param1:MouseEvent) : void
      {
         if(!enabled)
         {
            param1.stopImmediatePropagation();
            return;
         }
         if(toggle)
         {
            setSelected(!selected);
            param1.updateAfterEvent();
         }
      }
      
      override protected function initializeAccessibility() : void
      {
         if(Button.createAccessibilityImplementation != null)
         {
            Button.createAccessibilityImplementation(this);
         }
      }
      
      public function set toggle(param1:Boolean) : void
      {
         _toggle = param1;
         toggleChanged = true;
         invalidateProperties();
         invalidateDisplayList();
         dispatchEvent(new Event("toggleChanged"));
      }
      
      override public function get baselinePosition() : Number
      {
         var _loc1_:String = null;
         var _loc2_:TextLineMetrics = null;
         if(FlexVersion.compatibilityVersion < FlexVersion.VERSION_3_0)
         {
            _loc1_ = label;
            if(!_loc1_)
            {
               _loc1_ = "Wj";
            }
            validateNow();
            if(!label && (labelPlacement == ButtonLabelPlacement.TOP || labelPlacement == ButtonLabelPlacement.BOTTOM))
            {
               _loc2_ = measureText(_loc1_);
               return (measuredHeight - _loc2_.height) / 2 + _loc2_.ascent;
            }
            return textField.y + measureText(_loc1_).ascent;
         }
         if(!validateBaselinePosition())
         {
            return NaN;
         }
         return textField.y + textField.baselinePosition;
      }
      
      [Bindable("dataChange")]
      public function get data() : Object
      {
         return _data;
      }
      
      public function set fontContext(param1:IFlexModuleFactory) : void
      {
         this.moduleFactory = param1;
      }
      
      mx_internal function viewSkin() : void
      {
         var _loc1_:String = null;
         var _loc2_:String = null;
         if(!enabled)
         {
            _loc1_ = !!selected?selectedDisabledSkinName:disabledSkinName;
            _loc2_ = !!selected?"selectedDisabled":"disabled";
         }
         else if(phase == ButtonPhase.UP)
         {
            _loc1_ = !!selected?selectedUpSkinName:upSkinName;
            _loc2_ = !!selected?"selectedUp":"up";
         }
         else if(phase == ButtonPhase.OVER)
         {
            _loc1_ = !!selected?selectedOverSkinName:overSkinName;
            _loc2_ = !!selected?"selectedOver":"over";
         }
         else if(phase == ButtonPhase.DOWN)
         {
            _loc1_ = !!selected?selectedDownSkinName:downSkinName;
            _loc2_ = !!selected?"selectedDown":"down";
         }
         viewSkinForPhase(_loc1_,_loc2_);
      }
      
      override public function styleChanged(param1:String) : void
      {
         styleChangedFlag = true;
         super.styleChanged(param1);
         if(!param1 || param1 == "styleName")
         {
            changeSkins();
            changeIcons();
            if(initialized)
            {
               viewSkin();
               viewIcon();
            }
         }
         else if(param1.toLowerCase().indexOf("skin") != -1)
         {
            changeSkins();
         }
         else if(param1.toLowerCase().indexOf("icon") != -1)
         {
            changeIcons();
            invalidateSize();
         }
      }
      
      public function set emphasized(param1:Boolean) : void
      {
         _emphasized = param1;
         emphasizedChanged = true;
         invalidateDisplayList();
      }
      
      mx_internal function viewIcon() : void
      {
         var _loc1_:String = getCurrentIconName();
         viewIconForPhase(_loc1_);
      }
      
      override public function set toolTip(param1:String) : void
      {
         super.toolTip = param1;
         if(param1)
         {
            toolTipSet = true;
         }
         else
         {
            toolTipSet = false;
            invalidateDisplayList();
         }
      }
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
         if(hasFontContextChanged() && textField != null)
         {
            removeChild(DisplayObject(textField));
            textField = null;
         }
         if(!textField)
         {
            textField = IUITextField(createInFontContext(UITextField));
            textField.styleName = this;
            addChild(DisplayObject(textField));
            enabledChanged = true;
            toggleChanged = true;
         }
         if(!initialized)
         {
            viewSkin();
            viewIcon();
         }
         if(enabledChanged)
         {
            textField.enabled = enabled;
            if(currentIcon && currentIcon is IUIComponent)
            {
               IUIComponent(currentIcon).enabled = enabled;
            }
            enabledChanged = false;
         }
         if(toggleChanged)
         {
            if(!toggle)
            {
               selected = false;
            }
            toggleChanged = false;
         }
      }
      
      mx_internal function changeSkins() : void
      {
         var _loc1_:int = skins.length;
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            removeChild(skins[_loc2_]);
            _loc2_++;
         }
         skins = [];
         skinMeasuredWidth = NaN;
         skinMeasuredHeight = NaN;
         checkedDefaultSkin = false;
         defaultSkinUsesStates = false;
         if(initialized && FlexVersion.compatibilityVersion >= FlexVersion.VERSION_3_0)
         {
            viewSkin();
            invalidateSize();
         }
      }
      
      private function autoRepeatTimer_timerHandler(param1:Event) : void
      {
         if(!enabled)
         {
            return;
         }
         dispatchEvent(new FlexEvent(FlexEvent.BUTTON_DOWN));
      }
      
      private function previousVersion_layoutContents(param1:Number, param2:Number, param3:Boolean) : void
      {
         var _loc20_:TextLineMetrics = null;
         var _loc28_:Number = NaN;
         var _loc29_:MoveEvent = null;
         var _loc4_:Number = 0;
         var _loc5_:Number = 0;
         var _loc6_:Number = 0;
         var _loc7_:Number = 0;
         var _loc8_:Number = 0;
         var _loc9_:Number = 0;
         var _loc10_:Number = 0;
         var _loc11_:Number = 0;
         var _loc12_:Number = 2;
         var _loc13_:Number = 2;
         var _loc14_:Number = getStyle("paddingLeft");
         var _loc15_:Number = getStyle("paddingRight");
         var _loc16_:Number = getStyle("paddingTop");
         var _loc17_:Number = getStyle("paddingBottom");
         var _loc18_:Number = 0;
         var _loc19_:Number = 0;
         if(label)
         {
            _loc20_ = measureText(label);
            if(_loc20_.width > 0)
            {
               _loc18_ = _loc14_ + _loc15_ + getStyle("textIndent") + _loc20_.width;
            }
            _loc19_ = _loc20_.height;
         }
         else
         {
            _loc20_ = measureText("Wj");
            _loc19_ = _loc20_.height;
         }
         var _loc21_:Number = !!param3?Number(buttonOffset):Number(0);
         var _loc22_:String = getStyle("textAlign");
         var _loc23_:EdgeMetrics = currentSkin && currentSkin is IRectangularBorder?IRectangularBorder(currentSkin).borderMetrics:null;
         var _loc24_:Number = param1;
         var _loc25_:Number = param2 - _loc16_ - _loc17_;
         if(_loc23_)
         {
            _loc24_ = _loc24_ - (_loc23_.left + _loc23_.right);
            _loc25_ = _loc25_ - (_loc23_.top + _loc23_.bottom);
         }
         if(currentIcon)
         {
            _loc8_ = currentIcon.width;
            _loc9_ = currentIcon.height;
         }
         if(labelPlacement == ButtonLabelPlacement.LEFT || labelPlacement == ButtonLabelPlacement.RIGHT)
         {
            _loc12_ = getStyle("horizontalGap");
            if(_loc8_ == 0 || _loc18_ == 0)
            {
               _loc12_ = 0;
            }
            if(_loc18_ > 0)
            {
               textField.width = _loc4_ = Math.max(_loc24_ - _loc8_ - _loc12_ - _loc14_ - _loc15_,0);
            }
            else
            {
               textField.width = _loc4_ = 0;
            }
            textField.height = _loc5_ = Math.min(_loc25_ + 2,_loc19_ + UITextField.TEXT_HEIGHT_PADDING);
            if(labelPlacement == ButtonLabelPlacement.RIGHT)
            {
               _loc6_ = _loc8_ + _loc12_;
               if(centerContent)
               {
                  if(_loc22_ == "left")
                  {
                     _loc6_ = _loc6_ + _loc14_;
                  }
                  else if(_loc22_ == "right")
                  {
                     _loc6_ = _loc6_ + (_loc24_ - _loc4_ - _loc8_ - _loc12_ - _loc14_);
                  }
                  else
                  {
                     _loc28_ = (_loc24_ - _loc4_ - _loc8_ - _loc12_) / 2;
                     _loc6_ = _loc6_ + Math.max(_loc28_,_loc14_);
                  }
               }
               _loc10_ = _loc6_ - (_loc8_ + _loc12_);
               if(!centerContent)
               {
                  _loc6_ = _loc6_ + _loc14_;
               }
            }
            else
            {
               _loc6_ = _loc24_ - _loc4_ - _loc8_ - _loc12_ - _loc15_;
               if(centerContent)
               {
                  if(_loc22_ == "left")
                  {
                     _loc6_ = 2;
                  }
                  else if(_loc22_ == "right")
                  {
                     _loc6_--;
                  }
                  else if(_loc6_ > 0)
                  {
                     _loc6_ = _loc6_ / 2;
                  }
               }
               _loc10_ = _loc6_ + _loc4_ + _loc12_;
            }
            _loc11_ = _loc7_ = 0;
            if(centerContent)
            {
               _loc11_ = Math.round((_loc25_ - _loc9_) / 2) + _loc16_;
               _loc7_ = Math.round((_loc25_ - _loc5_) / 2) + _loc16_;
            }
            else
            {
               _loc7_ = _loc7_ + (Math.max(0,(_loc25_ - _loc5_) / 2) + _loc16_);
               _loc11_ = _loc11_ + (Math.max(0,(_loc25_ - _loc9_) / 2 - 1) + _loc16_);
            }
         }
         else
         {
            _loc13_ = getStyle("verticalGap");
            if(_loc9_ == 0 || _loc19_ == 0)
            {
               _loc13_ = 0;
            }
            if(_loc18_ > 0)
            {
               textField.width = _loc4_ = Math.min(_loc24_,_loc18_ + UITextField.TEXT_WIDTH_PADDING);
               textField.height = _loc5_ = Math.min(_loc25_ - _loc9_ + 1,_loc19_ + 5);
            }
            else
            {
               textField.width = _loc4_ = 0;
               textField.height = _loc5_ = 0;
            }
            _loc6_ = (_loc24_ - _loc4_) / 2;
            _loc10_ = (_loc24_ - _loc8_) / 2;
            if(labelPlacement == ButtonLabelPlacement.TOP)
            {
               _loc7_ = _loc25_ - _loc5_ - _loc9_ - _loc13_;
               if(centerContent && _loc7_ > 0)
               {
                  _loc7_ = _loc7_ / 2;
               }
               _loc7_ = _loc7_ + _loc16_;
               _loc11_ = _loc7_ + _loc5_ + _loc13_ - 3;
            }
            else
            {
               _loc7_ = _loc9_ + _loc13_ + _loc16_;
               if(centerContent)
               {
                  _loc7_ = _loc7_ + ((_loc25_ - _loc5_ - _loc9_ - _loc13_) / 2 + 1);
               }
               _loc11_ = _loc7_ - _loc9_ - _loc13_ + 3;
            }
         }
         var _loc26_:Number = _loc21_;
         var _loc27_:Number = _loc21_;
         if(_loc23_)
         {
            _loc26_ = _loc26_ + _loc23_.left;
            _loc27_ = _loc27_ + _loc23_.top;
         }
         textField.x = _loc6_ + _loc26_;
         textField.y = _loc7_ + _loc27_;
         if(currentIcon)
         {
            _loc10_ = _loc10_ + _loc26_;
            _loc11_ = _loc11_ + _loc27_;
            _loc29_ = new MoveEvent(MoveEvent.MOVE);
            _loc29_.oldX = currentIcon.x;
            _loc29_.oldY = currentIcon.y;
            currentIcon.x = Math.round(_loc10_);
            currentIcon.y = Math.round(_loc11_);
            currentIcon.dispatchEvent(_loc29_);
         }
         if(currentSkin)
         {
            setChildIndex(DisplayObject(currentSkin),numChildren - 1);
         }
         if(currentIcon)
         {
            setChildIndex(DisplayObject(currentIcon),numChildren - 1);
         }
         if(textField)
         {
            setChildIndex(DisplayObject(textField),numChildren - 1);
         }
      }
      
      private function systemManager_mouseUpHandler(param1:MouseEvent) : void
      {
         if(contains(DisplayObject(param1.target)))
         {
            return;
         }
         phase = ButtonPhase.UP;
         buttonReleased();
         param1.updateAfterEvent();
      }
      
      public function set label(param1:String) : void
      {
         labelSet = true;
         if(_label != param1)
         {
            _label = param1;
            labelChanged = true;
            invalidateSize();
            invalidateDisplayList();
            dispatchEvent(new Event("labelChanged"));
         }
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         var _loc5_:IFlexDisplayObject = null;
         var _loc6_:Boolean = false;
         super.updateDisplayList(param1,param2);
         if(emphasizedChanged)
         {
            changeSkins();
            emphasizedChanged = false;
         }
         var _loc3_:int = skins.length;
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = IFlexDisplayObject(skins[_loc4_]);
            _loc5_.setActualSize(param1,param2);
            _loc4_++;
         }
         viewSkin();
         viewIcon();
         layoutContents(param1,param2,phase == ButtonPhase.DOWN);
         if(oldUnscaledWidth > param1 || textField.text != label || labelChanged || styleChangedFlag)
         {
            textField.text = label;
            _loc6_ = textField.truncateToFit();
            if(!toolTipSet)
            {
               if(_loc6_)
               {
                  super.toolTip = label;
               }
               else
               {
                  super.toolTip = null;
               }
            }
            styleChangedFlag = false;
            labelChanged = false;
         }
         oldUnscaledWidth = param1;
      }
      
      private function stage_mouseLeaveHandler(param1:Event) : void
      {
         phase = ButtonPhase.UP;
         buttonReleased();
      }
      
      public function set listData(param1:BaseListData) : void
      {
         _listData = param1;
      }
   }
}
