package tibia.game
{
   import flash.display.DisplayObject;
   import flash.errors.IllegalOperationError;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.ui.Keyboard;
   import mx.collections.ArrayList;
   import mx.collections.IList;
   import mx.controls.Button;
   import mx.controls.List;
   import mx.controls.Text;
   import mx.core.IDataRenderer;
   import mx.events.CloseEvent;
   import mx.events.ListEvent;
   import shared.controls.CustomButton;
   import shared.controls.CustomList;
   import tibia.game.serverModalDialogClasses.Choice;
   import tibia.network.Communication;
   
   public class ServerModalDialog extends PopUpBase
   {
       
      
      private var m_Choices:Vector.<Choice>;
      
      private var m_UIMessage:Text = null;
      
      private var m_DefaultEscapeButton:uint = 255;
      
      private var m_UncommittedSelectedChoice:Boolean = false;
      
      private var m_SelectedChoice:int = -1;
      
      private var m_Buttons:Vector.<Choice>;
      
      private var m_Message:String = null;
      
      private var m_DefaultEnterButton:uint = 255;
      
      private var m_UncommittedChoices:Boolean = false;
      
      private var m_ID:uint = 0;
      
      private var m_UncommittedButtons:Boolean = false;
      
      private var m_UIChoices:List = null;
      
      private var m_UncommittedMessage:Boolean = false;
      
      public function ServerModalDialog(param1:uint)
      {
         this.m_Buttons = new Vector.<Choice>();
         this.m_Choices = new Vector.<Choice>();
         super();
         this.buttonFlags = BUTTON_NONE;
         keyboardFlags = KEY_NONE;
         this.m_ID = param1;
         addEventListener(CloseEvent.CLOSE,this.onClose);
         addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
      }
      
      public function get buttons() : Vector.<Choice>
      {
         return this.m_Buttons;
      }
      
      override protected function commitProperties() : void
      {
         var Child:DisplayObject = null;
         var i:int = 0;
         var ChoicesList:IList = null;
         super.commitProperties();
         if(this.m_UncommittedButtons)
         {
            Child = null;
            i = 0;
            i = footer.numChildren - 1;
            while(i >= 0)
            {
               Child = footer.removeChildAt(i);
               Child.removeEventListener(MouseEvent.CLICK,this.onClose);
               i--;
            }
            if(this.buttons != null)
            {
               i = 0;
               while(i < this.buttons.length)
               {
                  Child = new CustomButton();
                  Button(Child).label = this.buttons[i].label;
                  Button(Child).data = this.buttons[i].value;
                  Child.addEventListener(MouseEvent.CLICK,this.onClose);
                  footer.addChild(Child);
                  i++;
               }
            }
            this.m_UncommittedButtons = false;
         }
         if(this.m_UncommittedChoices)
         {
            if(this.choices != null && this.choices.length > 0)
            {
               if(this.m_UIChoices == null)
               {
                  this.m_UIChoices = new CustomList();
                  this.m_UIChoices.doubleClickEnabled = true;
                  this.m_UIChoices.minWidth = 250;
                  this.m_UIChoices.minHeight = 150;
                  this.m_UIChoices.percentHeight = 100;
                  this.m_UIChoices.percentWidth = 75;
                  this.m_UIChoices.addEventListener(ListEvent.CHANGE,this.onChoiceChange);
                  this.m_UIChoices.addEventListener(MouseEvent.DOUBLE_CLICK,this.onChoiceDoubleClick);
                  addChild(this.m_UIChoices);
               }
               ChoicesList = new ArrayList();
               this.choices.forEach(function(param1:Choice, param2:*, param3:*):void
               {
                  ChoicesList.addItem(param1);
               });
               this.m_UIChoices.dataProvider = ChoicesList;
               this.selectedChoice = 0;
            }
            else
            {
               if(this.m_UIChoices != null)
               {
                  removeChild(this.m_UIChoices);
                  this.m_UIChoices = null;
               }
               this.selectedChoice = -1;
            }
            this.m_UncommittedChoices = false;
         }
         if(this.m_UncommittedMessage)
         {
            this.m_UIMessage.htmlText = this.message;
            this.m_UncommittedMessage = false;
         }
         if(this.m_UncommittedSelectedChoice)
         {
            if(this.selectedChoice != -1 && this.m_UIChoices != null)
            {
               this.m_UIChoices.selectedIndex = this.selectedChoice;
               callLater(this.m_UIChoices.scrollToIndex,[this.selectedChoice]);
            }
            this.m_UncommittedSelectedChoice = false;
         }
      }
      
      public function set defaultEnterButton(param1:uint) : void
      {
         if(this.m_DefaultEnterButton != param1)
         {
            this.m_DefaultEnterButton = param1;
            if(this.m_DefaultEnterButton != 255)
            {
               keyboardFlags = keyboardFlags | KEY_ENTER;
            }
            else
            {
               keyboardFlags = keyboardFlags & ~KEY_ENTER;
            }
         }
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this.m_UIMessage = new Text();
         this.m_UIMessage.htmlText = this.message;
         this.m_UIMessage.maxHeight = NaN;
         this.m_UIMessage.maxWidth = 300;
         this.m_UIMessage.percentHeight = 100;
         this.m_UIMessage.percentWidth = 100;
         addChild(this.m_UIMessage);
      }
      
      public function get message() : String
      {
         return this.m_Message;
      }
      
      private function onClose(param1:Event) : void
      {
         var _loc2_:int = 255;
         if(param1 is CloseEvent && this.defaultEscapeButton != 255 && CloseEvent(param1).detail === BUTTON_CANCEL)
         {
            _loc2_ = this.defaultEscapeButton;
         }
         else if(param1 is CloseEvent && this.defaultEnterButton != 255 && CloseEvent(param1).detail === BUTTON_OKAY)
         {
            _loc2_ = this.defaultEnterButton;
         }
         else if(param1 is MouseEvent && param1.target is IDataRenderer)
         {
            _loc2_ = uint(IDataRenderer(param1.target).data);
         }
         else
         {
            throw IllegalOperationError("ServerModalDialog.onClose: Event " + param1.type + " is not supported.");
         }
         var _loc3_:int = 255;
         if(this.choices != null && this.choices.length > 0 && this.selectedChoice != -1)
         {
            _loc3_ = this.choices[this.selectedChoice].value;
         }
         var _loc4_:Communication = Tibia.s_GetCommunication();
         if(_loc4_ != null && _loc4_.isGameRunning)
         {
            _loc4_.sendCANSWERMODALDIALOG(this.ID,_loc2_,_loc3_);
         }
         if(!(param1 is CloseEvent) || param1.target == this)
         {
            this.hide(false);
         }
      }
      
      public function set message(param1:String) : void
      {
         if(this.m_Message != param1)
         {
            this.m_Message = param1;
            this.m_UncommittedMessage = true;
            invalidateProperties();
            invalidateSize();
         }
      }
      
      public function get ID() : uint
      {
         return this.m_ID;
      }
      
      private function get selectedChoice() : int
      {
         return this.m_SelectedChoice;
      }
      
      public function set buttons(param1:Vector.<Choice>) : void
      {
         if(this.m_Buttons != param1)
         {
            this.m_Buttons = param1;
            this.m_UncommittedButtons = true;
            invalidateProperties();
            invalidateSize();
         }
      }
      
      public function set defaultEscapeButton(param1:uint) : void
      {
         if(this.m_DefaultEscapeButton != param1)
         {
            this.m_DefaultEscapeButton = param1;
            if(this.m_DefaultEscapeButton != 255)
            {
               keyboardFlags = keyboardFlags | KEY_ESCAPE;
            }
            else
            {
               keyboardFlags = keyboardFlags & ~KEY_ESCAPE;
            }
         }
      }
      
      public function set choices(param1:Vector.<Choice>) : void
      {
         if(this.m_Choices != param1)
         {
            this.m_Choices = param1;
            this.m_UncommittedChoices = true;
            invalidateProperties();
            invalidateSize();
         }
      }
      
      override public function hide(param1:Boolean = false) : void
      {
         var _loc3_:DisplayObject = null;
         var _loc2_:int = footer.numChildren - 1;
         while(_loc2_ >= 0)
         {
            _loc3_ = footer.removeChildAt(_loc2_);
            _loc3_.removeEventListener(MouseEvent.CLICK,this.onClose);
            _loc2_--;
         }
         super.hide(param1);
      }
      
      override public function set buttonFlags(param1:uint) : void
      {
      }
      
      public function get choices() : Vector.<Choice>
      {
         return this.m_Choices;
      }
      
      public function get defaultEscapeButton() : uint
      {
         return this.m_DefaultEscapeButton;
      }
      
      override public function get buttonFlags() : uint
      {
         return BUTTON_NONE;
      }
      
      private function onChoiceChange(param1:ListEvent) : void
      {
         if(param1 != null)
         {
            this.selectedChoice = this.m_UIChoices.selectedIndex;
         }
      }
      
      public function get defaultEnterButton() : uint
      {
         return this.m_DefaultEnterButton;
      }
      
      private function onKeyDown(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == Keyboard.DOWN)
         {
            this.selectedChoice++;
         }
         else if(param1.keyCode == Keyboard.UP)
         {
            this.selectedChoice--;
         }
      }
      
      private function onChoiceDoubleClick(param1:MouseEvent) : void
      {
         var _loc2_:CloseEvent = null;
         if(this.choices != null && this.selectedChoice != -1 && this.defaultEnterButton != 255)
         {
            _loc2_ = new CloseEvent(CloseEvent.CLOSE);
            _loc2_.detail = BUTTON_OKAY;
            dispatchEvent(_loc2_);
         }
      }
      
      private function set selectedChoice(param1:int) : void
      {
         if(this.choices != null)
         {
            param1 = Math.max(0,Math.min(param1,this.choices.length - 1));
         }
         else
         {
            param1 = -1;
         }
         if(this.m_SelectedChoice != param1)
         {
            this.m_SelectedChoice = param1;
            this.m_UncommittedSelectedChoice = true;
            invalidateProperties();
         }
      }
   }
}
