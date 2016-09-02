package tibia.chat.chatWidgetClasses
{
   import mx.controls.Label;
   import tibia.input.InputEvent;
   import flash.ui.Keyboard;
   import mx.core.EdgeMetrics;
   import mx.core.IBorder;
   import flash.text.TextLineMetrics;
   import flash.events.MouseEvent;
   import mx.styles.ISimpleStyleClient;
   import flash.display.DisplayObject;
   import mx.core.FlexSprite;
   import flash.geom.Rectangle;
   import flash.display.Graphics;
   import flash.utils.Timer;
   import mx.core.IFlexDisplayObject;
   import flash.events.TimerEvent;
   
   public class PassiveTextField extends Label
   {
      
      protected static const BLINK_TIMEOUT:int = 500;
       
      
      private var m_UncommittedCaretIndex:Boolean = false;
      
      protected var m_CaretVisible:int = 1;
      
      protected var m_CaretTimer:Timer = null;
      
      private var m_UncommittedOverwriteMode:Boolean = false;
      
      protected var m_CaretLayer:FlexSprite = null;
      
      protected var m_CaretIndex:int = 0;
      
      protected var m_SelectionOffset:int = 0;
      
      private var m_UncommittedMaxLength:Boolean = false;
      
      protected var m_OverwriteMode:Boolean = false;
      
      protected var m_Border:IFlexDisplayObject = null;
      
      protected var m_SelectionStart:int = 0;
      
      private var m_UncommittedEnabled:Boolean = false;
      
      protected var m_MaxLength:int = -1;
      
      private var m_UncommittedSelection:Boolean = false;
      
      public function PassiveTextField()
      {
         super();
         mouseChildren = false;
         focusEnabled = false;
         truncateToFit = false;
         addEventListener(MouseEvent.RIGHT_CLICK,this.onMouseClick);
         addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
         addEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMove);
         this.m_CaretTimer = new Timer(BLINK_TIMEOUT,0);
         this.m_CaretTimer.addEventListener(TimerEvent.TIMER,this.onCaretTimer);
         this.m_CaretTimer.start();
      }
      
      public function onKeyboardInput(param1:uint, param2:uint, param3:uint, param4:Boolean, param5:Boolean, param6:Boolean) : Boolean
      {
         if(enabled && (param1 == InputEvent.KEY_DOWN || param1 == InputEvent.KEY_REPEAT))
         {
            switch(param3)
            {
               case Keyboard.BACKSPACE:
                  if(this.m_SelectionOffset == 0 && this.m_CaretIndex > 0)
                  {
                     this.setSelection(this.m_CaretIndex - 1,this.m_CaretIndex);
                  }
                  this.replaceSelectedText("");
                  break;
               case Keyboard.SPACE:
                  this.replaceSelectedText(" ");
                  break;
               case Keyboard.PAGE_UP:
               case Keyboard.PAGE_DOWN:
                  break;
               case Keyboard.END:
                  this.caretIndex = text.length;
                  break;
               case Keyboard.HOME:
                  this.caretIndex = 0;
                  break;
               case Keyboard.LEFT:
                  this.caretIndex--;
                  break;
               case Keyboard.UP:
                  break;
               case Keyboard.RIGHT:
                  this.caretIndex++;
                  break;
               case Keyboard.DOWN:
                  break;
               case Keyboard.INSERT:
                  this.overwriteMode = !this.overwriteMode;
                  break;
               case Keyboard.DELETE:
                  if(this.m_SelectionOffset == 0 && this.m_CaretIndex < text.length)
                  {
                     this.setSelection(this.m_CaretIndex,this.m_CaretIndex + 1);
                  }
                  this.replaceSelectedText("");
                  break;
               default:
                  if(param2 != 0)
                  {
                     this.replaceSelectedText(String.fromCharCode(param2));
                  }
            }
         }
         return false;
      }
      
      public function get borderMetrics() : EdgeMetrics
      {
         if(this.m_Border is IBorder)
         {
            return IBorder(this.m_Border).borderMetrics;
         }
         return EdgeMetrics.EMPTY;
      }
      
      override public function set enabled(param1:Boolean) : void
      {
         if(super.enabled != param1)
         {
            super.enabled = param1;
            this.m_UncommittedEnabled = true;
            invalidateProperties();
         }
      }
      
      override protected function measure() : void
      {
         var _loc1_:EdgeMetrics = null;
         var _loc2_:TextLineMetrics = null;
         _loc1_ = this.viewMetricsAndPadding;
         _loc2_ = textField.getUITextFormat().measureText("gG");
         measuredMinWidth = measuredWidth = _loc2_.width + 4 + _loc1_.left + _loc1_.right;
         measuredMinHeight = measuredHeight = _loc2_.height + 4 + _loc1_.top + _loc1_.bottom;
      }
      
      public function get caretIndex() : int
      {
         return this.m_CaretIndex;
      }
      
      protected function onMouseMove(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         if(param1 != null && param1.buttonDown && enabled)
         {
            _loc2_ = this.getCharIndexAtPoint(param1.localX,param1.localY);
            if(_loc2_ > -1)
            {
               this.setSelection(this.m_SelectionStart,_loc2_);
            }
         }
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         var _loc1_:Class = getStyle("borderSkin");
         if(_loc1_ != null)
         {
            this.m_Border = new _loc1_();
            if(this.m_Border is ISimpleStyleClient)
            {
               (this.m_Border as ISimpleStyleClient).styleName = this;
            }
            addChildAt(this.m_Border as DisplayObject,0);
         }
         if(textField != null)
         {
            textField.alwaysShowSelection = true;
         }
         if(this.m_CaretLayer == null)
         {
            this.m_CaretLayer = new FlexSprite();
            addChild(this.m_CaretLayer);
         }
      }
      
      public function set overwriteMode(param1:Boolean) : void
      {
         if(this.m_OverwriteMode != param1)
         {
            this.m_OverwriteMode = param1;
            this.m_UncommittedOverwriteMode = true;
            invalidateProperties();
         }
      }
      
      public function set caretIndex(param1:int) : void
      {
         if(this.m_CaretIndex != param1)
         {
            this.m_CaretIndex = param1;
            this.m_UncommittedCaretIndex = true;
            invalidateProperties();
         }
      }
      
      protected function onMouseClick(param1:MouseEvent) : void
      {
         if(param1 != null && enabled)
         {
            new PassiveTextFieldContextMenu(this).display(this,param1.stageX,param1.stageY);
         }
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         var _loc8_:uint = 0;
         var _loc9_:Number = NaN;
         if(this.m_Border != null)
         {
            this.m_Border.move(0,0);
            this.m_Border.setActualSize(param1,param2);
         }
         var _loc3_:EdgeMetrics = this.viewMetricsAndPadding;
         textField.move(_loc3_.left,_loc3_.top);
         textField.setActualSize(param1 - _loc3_.left - _loc3_.right,param2 - _loc3_.top - _loc3_.bottom);
         var _loc4_:Number = param1 - _loc3_.left - _loc3_.right;
         var _loc5_:Rectangle = new Rectangle(0,0,0,0);
         if(this.m_CaretIndex > 0)
         {
            _loc5_ = textField.getCharBoundaries(this.m_CaretIndex - 1);
         }
         var _loc6_:Number = 0;
         if(_loc5_ != null)
         {
            _loc6_ = _loc5_.right - textField.scrollH;
         }
         if(_loc6_ < 0)
         {
            textField.scrollH = _loc5_.right - 1;
            _loc6_ = 0;
         }
         if(_loc6_ > _loc4_)
         {
            textField.scrollH = _loc5_.right - _loc4_ + 1;
            _loc6_ = _loc4_;
         }
         _loc6_ = _loc6_ + _loc3_.left;
         this.m_CaretLayer.x = 0;
         this.m_CaretLayer.y = 0;
         var _loc7_:Graphics = this.m_CaretLayer.graphics;
         _loc7_.clear();
         if(enabled && this.m_CaretVisible > 0)
         {
            _loc8_ = getStyle("color");
            _loc9_ = getStyle("caretWidth");
            if(isNaN(_loc9_) || _loc9_ < 1)
            {
               _loc9_ = 1;
            }
            _loc7_.lineStyle(_loc9_,_loc8_,1);
            _loc7_.moveTo(_loc6_,_loc3_.top + 2);
            _loc7_.lineTo(_loc6_,param2 - _loc3_.bottom - 2);
         }
      }
      
      public function get viewMetricsAndPadding() : EdgeMetrics
      {
         var _loc1_:EdgeMetrics = this.borderMetrics.clone();
         _loc1_.bottom = _loc1_.bottom + getStyle("paddingBottom");
         _loc1_.left = _loc1_.left + getStyle("paddingLeft");
         _loc1_.right = _loc1_.right + getStyle("paddingRight");
         _loc1_.top = _loc1_.top + getStyle("paddingTop");
         return _loc1_;
      }
      
      public function replaceSelectedText(param1:String) : void
      {
         var _loc6_:int = 0;
         var _loc2_:int = 0;
         if(this.m_SelectionOffset < 0)
         {
            _loc2_ = this.m_SelectionStart + this.m_SelectionOffset;
         }
         else if(this.m_SelectionOffset > 0)
         {
            _loc2_ = this.m_SelectionStart;
         }
         else
         {
            _loc2_ = this.m_CaretIndex;
         }
         var _loc3_:int = _loc2_ + Math.abs(this.m_SelectionOffset);
         var _loc4_:String = text;
         if(_loc4_ == null)
         {
            _loc4_ = "";
         }
         if(this.m_MaxLength > 0)
         {
            _loc6_ = _loc3_ - _loc2_;
            param1 = param1.substr(0,this.m_MaxLength - _loc4_.length + _loc6_);
         }
         this.text = _loc4_.substring(0,_loc2_) + param1 + _loc4_.substring(_loc3_,_loc4_.length);
         var _loc5_:int = _loc2_ + param1.length;
         this.setSelection(_loc5_,_loc5_);
      }
      
      public function clearSelection() : void
      {
         this.m_SelectionStart = 0;
         this.m_SelectionOffset = 0;
         this.m_UncommittedSelection = true;
         invalidateProperties();
      }
      
      protected function onMouseDown(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         if(param1 != null && enabled)
         {
            _loc2_ = this.getCharIndexAtPoint(param1.localX,param1.localY);
            if(_loc2_ > -1)
            {
               this.m_CaretIndex = _loc2_;
               this.m_UncommittedCaretIndex = true;
               this.m_SelectionStart = _loc2_;
               this.m_SelectionOffset = 0;
               this.m_UncommittedSelection = true;
               invalidateProperties();
            }
         }
      }
      
      public function setSelection(param1:int, param2:int) : void
      {
         this.m_SelectionStart = param1;
         this.m_SelectionOffset = param2 - param1;
         this.m_UncommittedSelection = true;
         this.m_CaretIndex = param2;
         this.m_UncommittedCaretIndex = true;
         invalidateProperties();
      }
      
      public function get overwriteMode() : Boolean
      {
         return this.m_OverwriteMode;
      }
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
         if(this.m_UncommittedCaretIndex)
         {
            if(this.m_CaretIndex < 0)
            {
               this.m_CaretIndex = 0;
            }
            if(this.m_CaretIndex > text.length)
            {
               this.m_CaretIndex = text.length;
            }
            this.m_CaretVisible = 2;
            invalidateDisplayList();
            this.m_UncommittedCaretIndex = false;
         }
         if(this.m_UncommittedSelection)
         {
            if(this.m_SelectionOffset == 0)
            {
               textField.setSelection(this.m_CaretIndex,this.m_CaretIndex);
            }
            else
            {
               textField.setSelection(this.m_SelectionStart,this.m_SelectionStart + this.m_SelectionOffset);
            }
            this.m_UncommittedSelection = false;
         }
         if(this.m_UncommittedMaxLength)
         {
            if(text != null && this.m_MaxLength > -1 && this.m_MaxLength < text.length)
            {
               this.text = text.substr(0,this.m_MaxLength);
            }
            this.m_UncommittedMaxLength = false;
         }
         if(this.m_UncommittedOverwriteMode)
         {
            this.m_UncommittedOverwriteMode = false;
         }
         if(this.m_UncommittedEnabled)
         {
            if(enabled)
            {
               if(this.m_CaretTimer != null && !this.m_CaretTimer.running)
               {
                  this.m_CaretTimer.start();
               }
            }
            else if(this.m_CaretTimer != null && this.m_CaretTimer.running)
            {
               this.m_CaretTimer.stop();
            }
            this.m_UncommittedEnabled = false;
         }
      }
      
      public function set maxLength(param1:int) : void
      {
         if(this.m_MaxLength != param1)
         {
            this.m_MaxLength = param1;
            this.m_UncommittedMaxLength = true;
            invalidateProperties();
         }
      }
      
      public function get selectionBeginIndex() : int
      {
         return this.m_SelectionStart;
      }
      
      public function getCharIndexAtPoint(param1:Number, param2:Number) : int
      {
         if(param2 < 0 || param2 > height)
         {
            return -1;
         }
         if(param1 < 0 || param1 > width)
         {
            return -1;
         }
         if(text.length < 1)
         {
            return 0;
         }
         param1 = param1 + textField.scrollH;
         var _loc3_:int = 0;
         var _loc4_:int = text.length - 1;
         var _loc5_:int = 0;
         var _loc6_:Rectangle = null;
         while(_loc3_ <= _loc4_)
         {
            _loc5_ = (_loc3_ + _loc4_) / 2;
            if((_loc6_ = textField.getCharBoundaries(_loc5_)) == null)
            {
               return -1;
            }
            if(param1 < _loc6_.x)
            {
               _loc4_ = _loc5_ - 1;
               continue;
            }
            if(param1 > _loc6_.right)
            {
               _loc3_ = _loc5_ + 1;
               continue;
            }
            return _loc5_;
         }
         return _loc5_ + 1;
      }
      
      override public function set text(param1:String) : void
      {
         if(super.text != param1)
         {
            super.text = param1;
            if(param1 != null)
            {
               this.m_CaretIndex = param1.length;
            }
            else
            {
               this.m_CaretIndex = 0;
            }
            this.m_UncommittedCaretIndex = true;
            invalidateProperties();
         }
      }
      
      public function getSelectedText() : String
      {
         if(this.m_SelectionOffset < 0)
         {
            return text.substr(this.m_SelectionStart + this.m_SelectionOffset,Math.abs(this.m_SelectionOffset));
         }
         if(this.m_SelectionOffset > 0)
         {
            return text.substr(this.m_SelectionStart,this.m_SelectionOffset);
         }
         return "";
      }
      
      public function get selectionEndIndex() : int
      {
         return this.m_SelectionStart + this.m_SelectionOffset;
      }
      
      public function get length() : int
      {
         return super.textField.length;
      }
      
      public function get maxLength() : int
      {
         return this.m_MaxLength;
      }
      
      public function get viewMetrics() : EdgeMetrics
      {
         return this.borderMetrics.clone();
      }
      
      protected function onCaretTimer(param1:TimerEvent) : void
      {
         if(this.m_CaretVisible > 1)
         {
            this.m_CaretVisible--;
         }
         else
         {
            this.m_CaretVisible = (this.m_CaretVisible + 1) % 2;
            invalidateDisplayList();
         }
      }
      
      public function onTextInput(param1:uint, param2:String) : Boolean
      {
         if(enabled && param1 == InputEvent.TEXT_INPUT)
         {
            this.replaceSelectedText(param2);
         }
         return false;
      }
   }
}
