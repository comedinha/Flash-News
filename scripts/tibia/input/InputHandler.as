package tibia.input
{
   import mx.core.UIComponent;
   import flash.events.EventDispatcher;
   import flash.events.FocusEvent;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.events.TextEvent;
   import flash.events.TimerEvent;
   import flash.display.InteractiveObject;
   import flash.events.Event;
   import tibia.input.mapping.Binding;
   import shared.utility.WeakReference;
   import mx.controls.TextInput;
   import shared.cryptography.Random;
   import flash.utils.getTimer;
   import tibia.options.OptionsStorage;
   import flash.geom.Point;
   import tibia.input.staticaction.PlayerMove;
   import flash.ui.Keyboard;
   import tibia.input.mapping.MouseBinding;
   import mx.events.PropertyChangeEvent;
   import flash.utils.Timer;
   import mx.events.FlexEvent;
   import tibia.input.mapping.Mapping;
   import flash.display.DisplayObjectContainer;
   import flash.display.DisplayObject;
   import mx.core.EventPriority;
   import shared.utility.BrowserHelper;
   
   public class InputHandler extends UIComponent
   {
      
      private static const ACTION_UNSET:int = -1;
      
      private static const MOUSE_BUTTON_LEFT:int = 1;
      
      private static const MOUSE_BUTTON_BOTH:int = 4;
      
      private static const ACTION_USE_OR_OPEN:int = 101;
      
      private static const ACTION_SMARTCLICK:int = 100;
      
      private static const MOUSE_BUTTON_RIGHT:int = 2;
      
      private static const ACTION_LOOK:int = 6;
      
      private static const MOUSE_CLICK_MOVE:Number = 8;
      
      private static const ACTION_TALK:int = 9;
      
      private static const MOUSE_LEFT:uint = 0;
      
      private static const ACTION_USE:int = 7;
      
      private static const MOUSE_BUTTON_MIDDLE:int = 3;
      
      private static const ACTION_NONE:int = 0;
      
      private static const MOUSE_RIGHT:uint = 1;
      
      private static const ACTION_AUTOWALK:int = 3;
      
      private static const ACTION_ATTACK:int = 1;
      
      private static const KEY_REPEAT_MIN_DELAY:uint = 250;
      
      private static const ACTION_OPEN:int = 8;
      
      private static const ACTION_AUTOWALK_HIGHLIGHT:int = 4;
      
      private static const ACTION_CONTEXT_MENU:int = 5;
      
      private static const MOUSE_REPEAT_TIMEOUT:int = 500;
      
      private static const ACTION_ATTACK_OR_TALK:int = 102;
      
      private static const MOUSE_DOUBLECLICK_TIMEOUT:int = 250;
       
      
      private var m_UncommittedCaptureKeyboard:Boolean = true;
      
      protected var m_MouseRepeatEvent:tibia.input.MouseRepeatEvent = null;
      
      protected var m_MovementBindings:Vector.<Binding> = null;
      
      protected var m_MouseEventTime:int = 0;
      
      protected var m_KeyboardTextTarget:InteractiveObject = null;
      
      protected var m_MouseEventTarget:WeakReference;
      
      private var m_UITextInput:TextInput = null;
      
      protected var m_MouseEventPoint:Point;
      
      protected var m_MouseEventState:int = 0;
      
      protected var m_Options:OptionsStorage = null;
      
      private var m_UIConstructed:Boolean = false;
      
      protected var m_MouseRepeatTrigger:Boolean = false;
      
      protected var m_MouseEventCode:uint = 0;
      
      protected var m_MouseRepeatTimer:Timer = null;
      
      protected var m_Numlock:Boolean = false;
      
      private var m_UncommittedOptions:Boolean = false;
      
      protected var m_KeyboardHandlerActive:Boolean = false;
      
      private var m_InternetExplorer:Boolean = false;
      
      protected var m_Mapping:Mapping = null;
      
      protected var m_MouseRepeatTarget:WeakReference;
      
      protected var m_CaptureKeyboard:Boolean = true;
      
      protected var m_KeyPressed:Vector.<int>;
      
      protected var m_KeyCode:uint = 0;
      
      private var m_CaptureDisableCount:int = 0;
      
      protected var m_MouseDown:Vector.<Boolean>;
      
      protected var m_MouseHandlerActive:Boolean = false;
      
      public function InputHandler()
      {
         this.m_MouseDown = new Vector.<Boolean>(2);
         this.m_MouseEventPoint = new Point(-1,-1);
         this.m_MouseEventTarget = new WeakReference();
         this.m_MouseRepeatTarget = new WeakReference();
         this.m_KeyPressed = new Vector.<int>(256);
         super();
         this.m_InternetExplorer = BrowserHelper.s_GetBrowserID() == BrowserHelper.INTERNETEXPLORER;
         this.m_MouseRepeatTimer = new Timer(0,0);
         addEventListener(FlexEvent.CREATION_COMPLETE,this.onCreationComplete);
         Tibia.s_GetSecondaryTimer().addEventListener(TimerEvent.TIMER,this.onKeyboardRepeatTimer);
      }
      
      private function registerSandboxListeners() : void
      {
         var _loc1_:EventDispatcher = systemManager.getSandboxRoot();
         if(_loc1_ != null)
         {
            _loc1_.addEventListener(FocusEvent.FOCUS_IN,this.onSandboxFocus,true,int.MAX_VALUE,false);
            _loc1_.addEventListener(FocusEvent.FOCUS_OUT,this.onSandboxFocus,true,int.MAX_VALUE,false);
            _loc1_.addEventListener(FocusEvent.KEY_FOCUS_CHANGE,this.onSandboxFocus,true,int.MAX_VALUE,false);
            _loc1_.addEventListener(FocusEvent.MOUSE_FOCUS_CHANGE,this.onSandboxFocus,true,int.MAX_VALUE,false);
            _loc1_.addEventListener(KeyboardEvent.KEY_DOWN,this.onSandboxKeyboard,true,int.MAX_VALUE,false);
            _loc1_.addEventListener(KeyboardEvent.KEY_UP,this.onSandboxKeyboard,true,int.MAX_VALUE,false);
            _loc1_.addEventListener(MouseEvent.CLICK,this.onSandboxMouse,true,int.MAX_VALUE,false);
            _loc1_.addEventListener(MouseEvent.DOUBLE_CLICK,this.onSandboxMouse,true,int.MAX_VALUE,false);
            _loc1_.addEventListener(MouseEvent.MOUSE_DOWN,this.onSandboxMouse,true,int.MAX_VALUE,false);
            _loc1_.addEventListener(MouseEvent.MOUSE_UP,this.onSandboxMouse,true,int.MAX_VALUE,false);
            _loc1_.addEventListener(MouseEvent.RIGHT_CLICK,this.onSandboxMouse,true,int.MAX_VALUE,false);
            _loc1_.addEventListener(MouseEvent.RIGHT_MOUSE_DOWN,this.onSandboxMouse,true,int.MAX_VALUE,false);
            _loc1_.addEventListener(MouseEvent.RIGHT_MOUSE_UP,this.onSandboxMouse,true,int.MAX_VALUE,false);
            _loc1_.addEventListener(TextEvent.TEXT_INPUT,this.onSandboxText,true,int.MAX_VALUE,false);
         }
      }
      
      protected function onMouseRepeatTimer(param1:TimerEvent) : void
      {
         var _loc2_:InteractiveObject = null;
         var _loc3_:String = null;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:tibia.input.MouseRepeatEvent = null;
         if(this.m_MouseRepeatTrigger && this.m_MouseRepeatEvent != null && this.m_MouseRepeatTarget.value is InteractiveObject)
         {
            if(this.m_MouseRepeatTimer.currentCount == 1 && this.m_MouseRepeatTimer.repeatCount == 1)
            {
               this.m_MouseRepeatTimer.delay = this.m_MouseRepeatEvent.repeatInterval;
               this.m_MouseRepeatTimer.repeatCount = 0;
               this.m_MouseRepeatTimer.reset();
               this.m_MouseRepeatTimer.start();
            }
            _loc2_ = this.m_MouseRepeatTarget.value as InteractiveObject;
            _loc3_ = this.m_MouseRepeatEvent.type == MouseEvent.MOUSE_DOWN?tibia.input.MouseRepeatEvent.REPEAT_MOUSE_DOWN:tibia.input.MouseRepeatEvent.REPEAT_RIGHT_MOUSE_DOWN;
            _loc4_ = this.m_MouseRepeatEvent.localX - _loc2_.mouseX;
            _loc5_ = this.m_MouseRepeatEvent.localY - _loc2_.mouseY;
            _loc6_ = Math.sqrt(_loc4_ * _loc4_ + _loc5_ * _loc5_);
            _loc7_ = new tibia.input.MouseRepeatEvent(_loc3_,this.m_MouseRepeatEvent.bubbles,this.m_MouseRepeatEvent.cancelable);
            _loc7_.localX = _loc2_.mouseX;
            _loc7_.localY = _loc2_.mouseY;
            _loc7_.ctrlKey = this.m_MouseRepeatEvent.ctrlKey;
            _loc7_.altKey = this.m_MouseRepeatEvent.altKey;
            _loc7_.shiftKey = this.m_MouseRepeatEvent.shiftKey;
            _loc7_.buttonDown = true;
            _loc7_.delta = _loc6_;
            _loc7_.repeatEnabled = this.m_MouseRepeatEvent.repeatEnabled;
            _loc7_.repeatInterval = this.m_MouseRepeatEvent.repeatInterval;
            _loc2_.dispatchEvent(_loc7_);
            if(!_loc7_.cancelable || !_loc7_.isDefaultPrevented())
            {
               if(!_loc7_.repeatEnabled)
               {
                  this.finishMouseRepeat();
               }
               else if(_loc7_.repeatInterval != this.m_MouseRepeatEvent.repeatInterval)
               {
                  this.m_MouseRepeatTimer.delay = _loc7_.repeatInterval;
               }
            }
         }
      }
      
      protected function onMouseRepeatPause(param1:Event) : void
      {
         this.m_MouseRepeatTrigger = param1.type == MouseEvent.ROLL_OVER;
      }
      
      private function finishMouseRepeat() : void
      {
         var _loc1_:InteractiveObject = null;
         this.m_MouseRepeatTrigger = false;
         this.m_MouseRepeatEvent = null;
         if(this.m_MouseRepeatTarget.value is InteractiveObject)
         {
            _loc1_ = this.m_MouseRepeatTarget.value as InteractiveObject;
            _loc1_.removeEventListener(MouseEvent.ROLL_OUT,this.onMouseRepeatPause);
            _loc1_.removeEventListener(MouseEvent.ROLL_OVER,this.onMouseRepeatPause);
            this.m_MouseRepeatTarget.value = null;
         }
         if(this.m_MouseRepeatTimer != null)
         {
            this.m_MouseRepeatTimer.removeEventListener(TimerEvent.TIMER,this.onMouseRepeatTimer);
            this.m_MouseRepeatTimer.reset();
         }
      }
      
      override protected function createChildren() : void
      {
         if(!this.m_UIConstructed)
         {
            super.createChildren();
            this.m_UITextInput = new TextInput();
            addChild(this.m_UITextInput);
            this.m_UIConstructed = true;
         }
      }
      
      public function isKeyPressed(param1:uint) : Boolean
      {
         return this.m_KeyPressed[param1] != 0;
      }
      
      protected function onSandboxMouse(param1:MouseEvent) : void
      {
         if(this.m_MouseHandlerActive)
         {
            return;
         }
         this.m_MouseHandlerActive = true;
         this.cancelEvent(param1);
         if(param1.type == MouseEvent.MOUSE_DOWN || param1.type == MouseEvent.RIGHT_MOUSE_DOWN)
         {
            this.internalMouseDown(param1);
         }
         else if(param1.type == MouseEvent.MOUSE_UP || param1.type == MouseEvent.RIGHT_MOUSE_UP)
         {
            this.internalMouseUp(param1);
         }
         this.m_MouseHandlerActive = false;
      }
      
      public function set captureKeyboard(param1:Boolean) : void
      {
         if(!param1)
         {
            this.m_CaptureDisableCount++;
         }
         else
         {
            this.m_CaptureDisableCount--;
         }
         var _loc2_:* = this.m_CaptureDisableCount <= 0;
         if(_loc2_)
         {
            this.m_CaptureDisableCount = 0;
         }
         if(this.m_CaptureKeyboard != _loc2_)
         {
            this.m_CaptureKeyboard = _loc2_;
            this.m_UncommittedCaptureKeyboard = true;
            invalidateProperties();
         }
      }
      
      private function internalMouseUp(param1:MouseEvent) : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc13_:MouseEvent = null;
         Random.s_PoolPutUnsignedInt(param1.stageX << 16 | param1.stageY);
         var _loc2_:uint = param1.type == MouseEvent.MOUSE_UP?uint(MOUSE_LEFT):uint(MOUSE_RIGHT);
         this.m_MouseDown[_loc2_] = false;
         _loc3_ = this.m_MouseEventPoint.x - param1.stageX;
         _loc4_ = this.m_MouseEventPoint.y - param1.stageY;
         var _loc5_:Number = Math.sqrt(_loc3_ * _loc3_ + _loc4_ * _loc4_);
         var _loc6_:int = getTimer();
         var _loc7_:InteractiveObject = this.getMouseTarget(param1.stageX,param1.stageY);
         var _loc8_:Boolean = param1.altKey;
         var _loc9_:Boolean = param1.ctrlKey;
         var _loc10_:Boolean = param1.shiftKey;
         var _loc11_:String = null;
         var _loc12_:Boolean = false;
         if(this.m_MouseEventState == 1)
         {
            this.m_MouseEventState = 2;
         }
         else if(this.m_MouseEventState == 2)
         {
            _loc12_ = true;
            _loc11_ = MouseEvent.CLICK;
            this.m_MouseEventState = 0;
         }
         else if(this.m_MouseEventState == 3)
         {
            this.m_MouseEventState = 0;
         }
         else if(_loc5_ < MOUSE_CLICK_MOVE && this.m_MouseEventCode == _loc2_ && this.m_MouseEventCode == MOUSE_LEFT && this.m_MouseEventTime + MOUSE_DOUBLECLICK_TIMEOUT > _loc6_ && _loc7_ == this.m_MouseEventTarget.value && (_loc7_ == null || _loc7_.doubleClickEnabled))
         {
            _loc11_ = MouseEvent.DOUBLE_CLICK;
            this.m_MouseEventState = 0;
            this.m_MouseEventTime = 0;
         }
         else if(_loc5_ < MOUSE_CLICK_MOVE && this.m_MouseEventCode == _loc2_ && _loc7_ == this.m_MouseEventTarget.value)
         {
            _loc11_ = param1.type == MouseEvent.MOUSE_UP?MouseEvent.CLICK:MouseEvent.RIGHT_CLICK;
            this.m_MouseEventState = 0;
            this.m_MouseEventTime = _loc6_;
         }
         else
         {
            this.m_MouseEventState = 0;
         }
         if(this.m_MouseRepeatTarget.value is InteractiveObject && this.m_MouseRepeatEvent != null && (param1.type != MouseEvent.MOUSE_UP || this.m_MouseRepeatEvent.type == MouseEvent.MOUSE_DOWN) && (param1.type != MouseEvent.RIGHT_MOUSE_UP || this.m_MouseRepeatEvent.type == MouseEvent.RIGHT_MOUSE_DOWN))
         {
            if(this.m_MouseRepeatTimer == null || this.m_MouseRepeatTimer.currentCount > 0)
            {
               _loc11_ = null;
            }
            this.finishMouseRepeat();
         }
         if(_loc7_ != null)
         {
            _loc13_ = new MouseEvent(param1.type,true,true);
            _loc13_.localX = _loc7_.mouseX;
            _loc13_.localY = _loc7_.mouseY;
            _loc13_.relatedObject = param1.relatedObject;
            _loc13_.altKey = _loc8_;
            _loc13_.ctrlKey = _loc9_;
            _loc13_.shiftKey = _loc10_;
            _loc13_.buttonDown = false;
            _loc13_.delta = _loc5_;
            _loc7_.dispatchEvent(_loc13_);
            if((!_loc13_.cancelable || !_loc13_.isDefaultPrevented()) && _loc11_ != null)
            {
               if(_loc12_)
               {
                  _loc13_ = new MouseClickBothEvent(_loc11_,true,true);
               }
               else
               {
                  _loc13_ = new MouseEvent(_loc11_,true,true);
               }
               _loc13_.localX = _loc7_.mouseX;
               _loc13_.localY = _loc7_.mouseY;
               _loc13_.relatedObject = param1.relatedObject;
               _loc13_.altKey = _loc8_;
               _loc13_.ctrlKey = _loc9_;
               _loc13_.shiftKey = _loc10_;
               _loc13_.buttonDown = false;
               _loc13_.delta = _loc5_;
               _loc7_.dispatchEvent(_loc13_);
            }
         }
      }
      
      public function get options() : OptionsStorage
      {
         return this.m_Options;
      }
      
      protected function onKeyboardRepeatTimer(param1:TimerEvent) : void
      {
         var _loc3_:Binding = null;
         var _loc2_:int = Tibia.s_GetTibiaTimer();
         if(this.m_CaptureKeyboard && this.m_MovementBindings != null)
         {
            for each(_loc3_ in this.m_MovementBindings)
            {
               if(this.isKeyPressed(_loc3_.keyCode) && this.m_KeyPressed[_loc3_.keyCode] + KEY_REPEAT_MIN_DELAY < _loc2_ && _loc3_.appliesTo((_loc3_.action as PlayerMove).eventMask,_loc3_.keyCode,this.isKeyPressed(Keyboard.ALTERNATE),this.isKeyPressed(Keyboard.CONTROL),this.isKeyPressed(Keyboard.SHIFT)))
               {
                  _loc3_.action.perform(true);
               }
            }
         }
      }
      
      private function internalMouseDown(param1:MouseEvent) : void
      {
         var _loc5_:tibia.input.MouseRepeatEvent = null;
         Random.s_PoolPutUnsignedInt(param1.stageX << 16 | param1.stageY);
         var _loc2_:uint = param1.type == MouseEvent.MOUSE_DOWN?uint(MOUSE_LEFT):uint(MOUSE_RIGHT);
         this.m_MouseDown[_loc2_] = true;
         this.m_MouseEventCode = _loc2_;
         this.m_MouseEventPoint.setTo(param1.stageX,param1.stageY);
         var _loc3_:MouseBinding = null;
         if(this.m_Options != null && this.m_Options.mouseMapping != null && (_loc3_ = this.m_Options.mouseMapping.findBinding(MOUSE_BUTTON_BOTH,0)) != null && _loc3_.action != 0 && (this.m_MouseDown[MOUSE_LEFT] && this.m_MouseDown[MOUSE_RIGHT]) && this.m_MouseRepeatTarget.value == null)
         {
            this.m_MouseEventState = 1;
         }
         else
         {
            this.m_MouseEventState = 0;
         }
         var _loc4_:InteractiveObject = this.getMouseTarget(param1.stageX,param1.stageY);
         if(_loc4_ != this.m_MouseEventTarget.value)
         {
            this.m_MouseEventTarget.value = _loc4_;
            this.m_MouseEventTime = 0;
         }
         if(_loc4_ != null)
         {
            _loc5_ = new tibia.input.MouseRepeatEvent(param1.type,true,true);
            _loc5_.localX = _loc4_.mouseX;
            _loc5_.localY = _loc4_.mouseY;
            _loc5_.relatedObject = param1.relatedObject;
            _loc5_.ctrlKey = param1.ctrlKey;
            _loc5_.altKey = param1.altKey;
            _loc5_.shiftKey = param1.shiftKey;
            _loc5_.buttonDown = true;
            _loc5_.delta = 0;
            _loc4_.dispatchEvent(_loc5_);
            if(_loc5_.cancelable && _loc5_.isDefaultPrevented())
            {
               this.m_MouseEventState = 3;
            }
            else if((!_loc5_.cancelable || !_loc5_.isDefaultPrevented()) && _loc5_.repeatEnabled && this.m_MouseDown[MOUSE_LEFT] != this.m_MouseDown[MOUSE_RIGHT] && this.m_MouseRepeatTarget.value == null)
            {
               this.initMouseRepeat(_loc4_,_loc5_);
            }
         }
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
            this.updateMapping();
         }
      }
      
      private function cancelEvent(param1:Event) : void
      {
         if(param1)
         {
            if(param1.cancelable)
            {
               param1.preventDefault();
            }
            param1.stopImmediatePropagation();
            param1.stopPropagation();
         }
      }
      
      public function dispose() : void
      {
         this.captureKeyboard = false;
         this.unregisterSandboxListeners();
         Tibia.s_GetSecondaryTimer().removeEventListener(TimerEvent.TIMER,this.onKeyboardRepeatTimer);
         var _loc1_:int = 0;
         _loc1_ = this.m_KeyPressed.length - 1;
         while(_loc1_ >= 0)
         {
            this.m_KeyPressed[_loc1_] = 0;
            _loc1_--;
         }
         _loc1_ = this.m_MouseDown.length - 1;
         while(_loc1_ >= 0)
         {
            this.m_MouseDown[_loc1_] = false;
            _loc1_--;
         }
         this.m_MovementBindings = null;
      }
      
      protected function onSandboxText(param1:TextEvent) : void
      {
         var _loc3_:InteractiveObject = null;
         if(this.m_KeyboardHandlerActive)
         {
            return;
         }
         if(this.m_KeyboardTextTarget != null)
         {
            _loc3_ = this.m_KeyboardTextTarget;
            while(_loc3_ != null)
            {
               _loc3_ = _loc3_.parent as InteractiveObject;
               if(param1.target == _loc3_)
               {
                  return;
               }
            }
         }
         this.m_KeyboardHandlerActive = true;
         this.m_KeyboardTextTarget = param1.target as InteractiveObject;
         var _loc2_:Boolean = this.m_KeyCode >= Keyboard.NUMPAD_0 && this.m_KeyCode <= Keyboard.NUMPAD_DIVIDE;
         if(_loc2_)
         {
            this.cancelEvent(param1);
         }
         if(this.m_CaptureKeyboard && this.m_Mapping != null && !_loc2_)
         {
            this.cancelEvent(param1);
            this.m_Mapping.onTextInput(InputEvent.TEXT_INPUT,param1.text);
         }
         this.m_KeyboardHandlerActive = false;
      }
      
      protected function onCreationComplete(param1:FlexEvent) : void
      {
         removeEventListener(FlexEvent.CREATION_COMPLETE,this.onCreationComplete);
         if(this.m_UITextInput != null)
         {
            this.m_UITextInput.setFocus();
            this.m_UITextInput.drawFocus(false);
         }
         this.registerSandboxListeners();
      }
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
         if(this.m_UncommittedOptions)
         {
            this.m_UncommittedOptions = false;
         }
         if(this.m_UncommittedCaptureKeyboard)
         {
            if(this.m_CaptureKeyboard)
            {
               if(this.m_UITextInput != null)
               {
                  this.m_UITextInput.setFocus();
                  this.m_UITextInput.drawFocus(false);
               }
               focusManager.deactivate();
            }
            else
            {
               focusManager.activate();
            }
            this.m_UncommittedCaptureKeyboard = false;
         }
      }
      
      public function clearPressedKeys() : void
      {
         var _loc1_:int = 0;
         if(this.m_KeyPressed != null)
         {
            _loc1_ = this.m_KeyPressed.length - 1;
            while(_loc1_ >= 0)
            {
               this.m_KeyPressed[_loc1_] = 0;
               _loc1_--;
            }
         }
      }
      
      private function updateMapping() : void
      {
         var _loc3_:Binding = null;
         var _loc1_:MappingSet = null;
         var _loc2_:Mapping = null;
         if(this.m_Options != null && (_loc1_ = this.m_Options.getMappingSet(this.m_Options.generalInputSetID)) != null)
         {
            if(this.m_Options.generalInputSetMode == MappingSet.CHAT_MODE_OFF)
            {
               _loc2_ = _loc1_.chatModeOff;
            }
            else
            {
               _loc2_ = _loc1_.chatModeOn;
            }
         }
         if(_loc2_ != null && _loc2_.binding != null)
         {
            this.m_MovementBindings = new Vector.<Binding>();
            for each(_loc3_ in _loc2_.binding)
            {
               if(_loc3_.action != null && _loc3_.action is PlayerMove)
               {
                  this.m_MovementBindings.push(_loc3_);
               }
            }
         }
         this.m_Mapping = _loc2_;
      }
      
      protected function onOptionsChange(param1:PropertyChangeEvent) : void
      {
         switch(param1.property)
         {
            case "generalInputSetID":
            case "generalInputSetMode":
            case "mappingSet":
            case "*":
               this.updateMapping();
         }
      }
      
      protected function onSandboxFocus(param1:FocusEvent) : void
      {
         if(this.m_CaptureKeyboard)
         {
            this.cancelEvent(param1);
            if(this.m_UITextInput != null)
            {
               this.m_UITextInput.setFocus();
               this.m_UITextInput.drawFocus(false);
            }
         }
         this.clearPressedKeys();
      }
      
      public function isModifierKeyPressed(param1:MouseEvent = null) : Boolean
      {
         if(param1 != null)
         {
            return param1.ctrlKey || param1.shiftKey || param1.altKey;
         }
         return this.isKeyPressed(Keyboard.CONTROL) || this.isKeyPressed(Keyboard.SHIFT) || this.isKeyPressed(Keyboard.ALTERNATE);
      }
      
      private function unregisterSandboxListeners() : void
      {
         var _loc1_:EventDispatcher = systemManager.getSandboxRoot();
         if(_loc1_ != null)
         {
            _loc1_.removeEventListener(FocusEvent.FOCUS_IN,this.onSandboxFocus,true);
            _loc1_.removeEventListener(FocusEvent.FOCUS_OUT,this.onSandboxFocus,true);
            _loc1_.removeEventListener(FocusEvent.KEY_FOCUS_CHANGE,this.onSandboxFocus,true);
            _loc1_.removeEventListener(FocusEvent.MOUSE_FOCUS_CHANGE,this.onSandboxFocus,true);
            _loc1_.removeEventListener(KeyboardEvent.KEY_DOWN,this.onSandboxKeyboard,true);
            _loc1_.removeEventListener(KeyboardEvent.KEY_UP,this.onSandboxKeyboard,true);
            _loc1_.removeEventListener(MouseEvent.CLICK,this.onSandboxMouse,true);
            _loc1_.removeEventListener(MouseEvent.DOUBLE_CLICK,this.onSandboxMouse,true);
            _loc1_.removeEventListener(MouseEvent.MOUSE_DOWN,this.onSandboxMouse,true);
            _loc1_.removeEventListener(MouseEvent.MOUSE_UP,this.onSandboxMouse,true);
            _loc1_.removeEventListener(MouseEvent.RIGHT_CLICK,this.onSandboxMouse,true);
            _loc1_.removeEventListener(MouseEvent.RIGHT_MOUSE_DOWN,this.onSandboxMouse,true);
            _loc1_.removeEventListener(MouseEvent.RIGHT_MOUSE_UP,this.onSandboxMouse,true);
            _loc1_.removeEventListener(TextEvent.TEXT_INPUT,this.onSandboxText,true);
         }
      }
      
      override protected function measure() : void
      {
         super.measure();
         measuredMinWidth = measuredWidth = 0;
         measuredMinHeight = measuredHeight = 0;
      }
      
      public function get captureKeyboard() : Boolean
      {
         return this.m_CaptureKeyboard;
      }
      
      private function getMouseTarget(param1:Number, param2:Number) : InteractiveObject
      {
         var _loc3_:DisplayObjectContainer = null;
         var _loc6_:DisplayObject = null;
         var _loc7_:DisplayObjectContainer = null;
         var _loc8_:InteractiveObject = null;
         _loc3_ = DisplayObjectContainer(systemManager.getSandboxRoot());
         var _loc4_:Array = _loc3_.getObjectsUnderPoint(new Point(param1,param2));
         if(_loc4_ == null)
         {
            return _loc3_;
         }
         var _loc5_:int = _loc4_.length - 1;
         while(true)
         {
            if(_loc5_ < 0)
            {
               return _loc3_;
            }
            _loc6_ = null;
            _loc7_ = null;
            _loc8_ = null;
            _loc6_ = _loc4_[_loc5_] as DisplayObject;
            while(_loc6_ != null && _loc6_ != _loc3_)
            {
               if(_loc6_.visible && _loc6_ is DisplayObjectContainer && DisplayObjectContainer(_loc6_).mouseEnabled && !DisplayObjectContainer(_loc6_).mouseChildren)
               {
                  _loc7_ = DisplayObjectContainer(_loc6_);
               }
               _loc6_ = _loc6_.parent;
            }
            if(_loc7_ != null)
            {
               return _loc7_;
            }
            _loc6_ = _loc4_[_loc5_] as DisplayObject;
            while(_loc6_ != null && _loc6_ != _loc3_)
            {
               if(_loc6_.visible && _loc6_ is InteractiveObject && InteractiveObject(_loc6_).mouseEnabled)
               {
                  _loc8_ = InteractiveObject(_loc6_);
                  break;
               }
               _loc6_ = _loc6_.parent;
            }
            if(_loc8_ != null)
            {
               break;
            }
            _loc5_--;
         }
         return _loc8_;
      }
      
      protected function onSandboxKeyboard(param1:KeyboardEvent) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:ModifierKeyEvent = null;
         var _loc2_:* = false;
         if(this.m_KeyboardHandlerActive)
         {
            return;
         }
         this.m_KeyboardHandlerActive = true;
         if(param1.keyCode > this.m_KeyPressed.length)
         {
            param1.keyCode = 0;
         }
         if(param1.type == KeyboardEvent.KEY_UP)
         {
            _loc2_ = this.m_KeyPressed[param1.keyCode] != 0;
            this.m_KeyPressed[param1.keyCode] = 0;
            if(Keyboard.numLock != this.m_Numlock)
            {
               this.clearPressedKeys();
               this.m_Numlock = Keyboard.numLock;
            }
         }
         if(this.m_CaptureKeyboard && this.m_Mapping != null && !(param1.altKey && param1.ctrlKey))
         {
            this.cancelEvent(param1);
            if(param1.type == KeyboardEvent.KEY_DOWN || this.isInternetExplorer && param1.ctrlKey)
            {
               _loc3_ = this.m_KeyPressed[param1.keyCode] != 0?uint(InputEvent.KEY_REPEAT):uint(InputEvent.KEY_DOWN);
               this.m_Mapping.onKeyInput(_loc3_,param1.charCode,param1.keyCode,param1.altKey,param1.ctrlKey,param1.shiftKey);
            }
            if(param1.type == KeyboardEvent.KEY_UP)
            {
               this.m_Mapping.onKeyInput(InputEvent.KEY_UP,param1.charCode,param1.keyCode,param1.altKey,param1.ctrlKey,param1.shiftKey);
            }
         }
         if(param1.type == KeyboardEvent.KEY_DOWN)
         {
            this.m_KeyCode = param1.keyCode;
            _loc2_ = this.m_KeyPressed[param1.keyCode] != 0 != (!this.isInternetExplorer || param1.keyCode != Keyboard.TAB);
            this.m_KeyPressed[param1.keyCode] = !this.isInternetExplorer || param1.keyCode != Keyboard.TAB?int(Tibia.s_GetTibiaTimer()):0;
         }
         if(_loc2_)
         {
            _loc4_ = new ModifierKeyEvent(ModifierKeyEvent.MODIFIER_KEYS_CHANGED,param1.bubbles,param1.cancelable,param1.charCode,param1.keyCode,param1.keyLocation,param1.ctrlKey,param1.altKey,param1.shiftKey);
            this.dispatchEvent(_loc4_);
         }
         this.m_KeyboardHandlerActive = false;
      }
      
      private function initMouseRepeat(param1:InteractiveObject, param2:tibia.input.MouseRepeatEvent) : void
      {
         var _loc3_:InteractiveObject = null;
         this.m_MouseRepeatTrigger = true;
         this.m_MouseRepeatEvent = param2;
         this.m_MouseRepeatTarget.value = param1;
         if(this.m_MouseRepeatTarget.value is InteractiveObject)
         {
            _loc3_ = this.m_MouseRepeatTarget.value as InteractiveObject;
            _loc3_.addEventListener(MouseEvent.ROLL_OUT,this.onMouseRepeatPause,false,EventPriority.DEFAULT,true);
            _loc3_.addEventListener(MouseEvent.ROLL_OVER,this.onMouseRepeatPause,false,EventPriority.DEFAULT,true);
         }
         if(this.m_MouseRepeatTimer != null)
         {
            this.m_MouseRepeatTimer.delay = MOUSE_REPEAT_TIMEOUT;
            this.m_MouseRepeatTimer.repeatCount = 1;
            this.m_MouseRepeatTimer.addEventListener(TimerEvent.TIMER,this.onMouseRepeatTimer);
            this.m_MouseRepeatTimer.start();
         }
      }
      
      private function get isInternetExplorer() : Boolean
      {
         return this.m_InternetExplorer;
      }
   }
}
