package shared.controls
{
   import flash.events.MouseEvent;
   import mx.containers.Box;
   import mx.containers.HBox;
   import mx.containers.VBox;
   import mx.controls.Button;
   import mx.controls.Label;
   import mx.controls.Text;
   import mx.core.Container;
   import mx.core.EventPriority;
   import mx.core.ScrollPolicy;
   import mx.events.CloseEvent;
   
   public class EmbeddedDialog extends VBox
   {
      
      public static const NO:uint = 2;
      
      public static const YES:uint = 1;
      
      public static const CLEAR:uint = 32;
      
      private static const BUNDLE:String = "Global";
      
      public static const OKAY:uint = 4;
      
      public static const CLOSE:uint = 16;
      
      private static const DEFAULT_MIN_HEIGHT:Number = 50;
      
      public static const CANCEL:uint = 8;
      
      private static const BUTTON_FLAGS:Array = [{
         "data":EmbeddedDialog.OKAY,
         "label":"BTN_OKAY",
         "styleName":"buttonOkayStyle"
      },{
         "data":EmbeddedDialog.YES,
         "label":"BTN_YES",
         "styleName":"buttonYesStyle"
      },{
         "data":EmbeddedDialog.CLOSE,
         "label":"BTN_CLOSE",
         "styleName":"buttonCloseStyle"
      },{
         "data":EmbeddedDialog.NO,
         "label":"BTN_NO",
         "styleName":"buttonNoStyle"
      },{
         "data":EmbeddedDialog.CLEAR,
         "label":"BTN_CLEAR",
         "styleName":"buttonClearStyle"
      },{
         "data":EmbeddedDialog.CANCEL,
         "label":"BTN_CANCEL",
         "styleName":"buttonCancelStyle"
      }];
      
      public static const NONE:uint = 0;
       
      
      private var m_UIText:Text = null;
      
      protected var m_ButtonFlags:uint = 8;
      
      private var m_UncommittedTitle:Boolean = true;
      
      private var m_UITitle:Label = null;
      
      private var m_UIContentBox:Box = null;
      
      private var m_UITitleBox:HBox = null;
      
      private var m_UncommittedText:Boolean = true;
      
      protected var m_Text:String = null;
      
      private var m_UncommittedButtonFlags:Boolean = true;
      
      protected var m_Title:String = null;
      
      private var m_UIConstructed:Boolean = false;
      
      private var m_UIButtonBox:HBox = null;
      
      public function EmbeddedDialog()
      {
         super();
         horizontalScrollPolicy = ScrollPolicy.OFF;
         verticalScrollPolicy = ScrollPolicy.OFF;
         addEventListener(CloseEvent.CLOSE,this.onClose,false,EventPriority.DEFAULT_HANDLER,false);
      }
      
      public function get buttonFlags() : uint
      {
         return this.m_ButtonFlags;
      }
      
      override protected function commitProperties() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Button = null;
         super.commitProperties();
         if(this.m_UncommittedText)
         {
            if(this.m_UIText != null)
            {
               this.m_UIText.text = this.m_Text;
            }
            this.m_UncommittedText = false;
         }
         if(this.m_UncommittedTitle)
         {
            this.m_UITitle.text = this.m_Title;
            this.m_UITitleBox.includeInLayout = this.m_Title != null;
            this.m_UITitleBox.visible = this.m_Title != null;
            this.m_UncommittedTitle = false;
         }
         if(this.m_UncommittedButtonFlags)
         {
            _loc1_ = 0;
            _loc2_ = null;
            _loc1_ = this.m_UIButtonBox.numChildren - 1;
            while(_loc1_ >= 0)
            {
               _loc2_ = this.m_UIButtonBox.removeChildAt(_loc1_) as Button;
               if(_loc2_ != null)
               {
                  _loc2_.removeEventListener(MouseEvent.CLICK,this.onButtonClick);
               }
               _loc1_--;
            }
            _loc1_ = 0;
            while(_loc1_ < BUTTON_FLAGS.length)
            {
               if((this.m_ButtonFlags & BUTTON_FLAGS[_loc1_].data) != 0)
               {
                  _loc2_ = new CustomButton();
                  _loc2_.label = resourceManager.getString(BUNDLE,BUTTON_FLAGS[_loc1_].label);
                  _loc2_.data = BUTTON_FLAGS[_loc1_].data;
                  _loc2_.styleName = getStyle(BUTTON_FLAGS[_loc1_].styleName);
                  _loc2_.addEventListener(MouseEvent.CLICK,this.onButtonClick);
                  _loc2_.minWidth = getStyle("minimumButtonWidth");
                  this.m_UIButtonBox.addChild(_loc2_);
               }
               _loc1_++;
            }
            this.m_UIButtonBox.includeInLayout = this.m_ButtonFlags != NONE;
            this.m_UIButtonBox.visible = this.m_ButtonFlags != NONE;
            this.m_UncommittedButtonFlags = false;
         }
      }
      
      public function get titleBox() : Box
      {
         return this.m_UITitleBox;
      }
      
      private function onButtonClick(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:CloseEvent = null;
         if(param1.currentTarget is Button)
         {
            _loc2_ = int(Button(param1.currentTarget).data);
            _loc3_ = new CloseEvent(CloseEvent.CLOSE,false,true,_loc2_);
            dispatchEvent(_loc3_);
         }
      }
      
      public function set text(param1:String) : void
      {
         if(this.m_Text != param1)
         {
            this.m_Text = param1;
            this.m_UncommittedText = true;
            invalidateProperties();
         }
      }
      
      override protected function createChildren() : void
      {
         if(!this.m_UIConstructed)
         {
            super.createChildren();
            this.m_UITitleBox = new HBox();
            this.m_UITitleBox.percentWidth = 100;
            this.m_UITitleBox.styleName = getStyle("titleBoxStyle");
            addChild(this.m_UITitleBox);
            this.m_UITitle = new Label();
            this.m_UITitle.styleName = getStyle("titleStyle");
            this.m_UITitleBox.addChild(this.m_UITitle);
            this.m_UIContentBox = new VBox();
            this.m_UIContentBox.minHeight = DEFAULT_MIN_HEIGHT;
            this.m_UIContentBox.percentHeight = 100;
            this.m_UIContentBox.percentWidth = 100;
            this.m_UIContentBox.styleName = getStyle("contentBoxStyle");
            this.createContent(this.m_UIContentBox);
            addChild(this.m_UIContentBox);
            this.m_UIButtonBox = new HBox();
            this.m_UIButtonBox.percentWidth = 100;
            this.m_UIButtonBox.styleName = getStyle("buttonBoxStyle");
            addChild(this.m_UIButtonBox);
            this.m_UIConstructed = true;
         }
      }
      
      protected function createContent(param1:Box) : void
      {
         this.m_UIText = new Text();
         this.m_UIText.percentWidth = 100;
         this.m_UIText.styleName = getStyle("textStyle");
         param1.addChild(this.m_UIText);
      }
      
      public function get title() : String
      {
         return this.m_Title;
      }
      
      private function onClose(param1:CloseEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Button = null;
         removeEventListener(CloseEvent.CLOSE,this.onClose);
         if(!param1.cancelable || !param1.isDefaultPrevented())
         {
            _loc2_ = this.m_UIButtonBox.numChildren - 1;
            while(_loc2_ >= 0)
            {
               _loc3_ = this.m_UIButtonBox.removeChildAt(_loc2_) as Button;
               if(_loc3_ != null)
               {
                  _loc3_.removeEventListener(MouseEvent.CLICK,this.onButtonClick);
               }
               _loc2_--;
            }
            if(owner is Container && Container(owner).rawChildren.contains(this))
            {
               Container(owner).rawChildren.removeChild(this);
            }
            else if(owner != null && owner.contains(this))
            {
               owner.removeChild(this);
            }
         }
      }
      
      public function set buttonFlags(param1:uint) : void
      {
         param1 = param1 & (YES | NO | OKAY | CANCEL | CLOSE | CLEAR);
         if(this.m_ButtonFlags != param1)
         {
            this.m_ButtonFlags = param1;
            this.m_UncommittedButtonFlags = true;
            invalidateProperties();
         }
      }
      
      public function get text() : String
      {
         return this.m_Text;
      }
      
      public function get content() : Box
      {
         return this.m_UIContentBox;
      }
      
      public function set title(param1:String) : void
      {
         if(this.m_Title != param1)
         {
            this.m_Title = param1;
            this.m_UncommittedTitle = true;
            invalidateProperties();
         }
      }
   }
}
