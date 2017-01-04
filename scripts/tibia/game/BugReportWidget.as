package tibia.game
{
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.TextEvent;
   import mx.controls.ComboBox;
   import mx.controls.Text;
   import mx.controls.TextArea;
   import shared.utility.StringHelper;
   import tibia.input.PreventWhitespaceInput;
   import tibia.network.Communication;
   
   public class BugReportWidget extends PopUpBase
   {
      
      public static const BUG_CATEGORY_TYPO:int = 1;
      
      public static const BUG_CATEGORY_MAP:int = 0;
      
      public static const BUG_CATEGORY_TECHNICAL:int = 2;
      
      private static const BUNDLE:String = "BugReportWidget";
      
      public static const MAX_TOTAL_MESSAGE_LENGTH:int = MAX_USER_MESSAGE_LENGTH + 512;
      
      public static const MAX_USER_MESSAGE_LENGTH:int = 1024;
      
      public static const BUG_CATEGORY_OTHER:int = 3;
       
      
      protected var m_UncommitedCategory:Boolean = false;
      
      private var m_UncommittedSystemMessage:Boolean = false;
      
      protected var m_UserMessage:String = null;
      
      protected var m_UIBugCategory:ComboBox = null;
      
      protected var m_BugInformation = null;
      
      private var m_UncommittedUserMessage:Boolean = false;
      
      protected var m_UIUserMessage:TextArea = null;
      
      protected var m_Category:int = 3;
      
      private var m_UIConstructed:Boolean = false;
      
      public function BugReportWidget()
      {
         super();
         title = resourceManager.getString(BUNDLE,"TITLE");
         keyboardFlags = PopUpBase.KEY_ESCAPE;
      }
      
      override public function hide(param1:Boolean = false) : void
      {
         var _loc2_:Communication = null;
         if(param1)
         {
            _loc2_ = Tibia.s_GetCommunication();
            if(_loc2_ != null && _loc2_.allowBugreports && _loc2_.isGameRunning)
            {
               _loc2_.sendCBUGREPORT(this.m_Category,this.m_UserMessage,this.m_BugInformation);
            }
         }
         super.hide(param1);
      }
      
      public function get userMessage() : String
      {
         return this.m_UserMessage;
      }
      
      protected function onTextChange(param1:Event) : void
      {
         if(param1 != null)
         {
            this.m_UserMessage = StringHelper.s_Trim(this.m_UIUserMessage.text);
         }
      }
      
      protected function onCategoryChange(param1:Event) : void
      {
         if(param1 != null)
         {
            this.m_Category = this.m_UIBugCategory.selectedIndex;
         }
      }
      
      public function get bugInformation() : *
      {
         return this.m_BugInformation;
      }
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
         if(this.m_UncommittedUserMessage)
         {
            this.m_UIUserMessage.text = this.m_UserMessage;
            this.m_UncommittedUserMessage = false;
         }
         if(this.m_UncommittedSystemMessage)
         {
            this.m_UncommittedSystemMessage = false;
         }
         if(this.m_UncommitedCategory)
         {
            this.m_UIBugCategory.selectedIndex = this.m_Category;
            this.m_UncommitedCategory = false;
         }
      }
      
      override protected function createChildren() : void
      {
         var _loc1_:Text = null;
         if(!this.m_UIConstructed)
         {
            super.createChildren();
            _loc1_ = new Text();
            _loc1_.text = resourceManager.getString(BUNDLE,"PROMPT");
            _loc1_.percentHeight = NaN;
            _loc1_.percentWidth = 100;
            addChild(_loc1_);
            this.m_UIBugCategory = new ComboBox();
            this.m_UIBugCategory.minWidth = 300;
            this.m_UIBugCategory.percentWidth = 100;
            this.m_UIBugCategory.dataProvider = [resourceManager.getString(BUNDLE,"BUG_CATEGORY_MAP"),resourceManager.getString(BUNDLE,"BUG_CATEGORY_TYPO"),resourceManager.getString(BUNDLE,"BUG_CATEGORY_TECHNICAL"),resourceManager.getString(BUNDLE,"BUG_CATEGORY_OTHER")];
            this.m_UIBugCategory.selectedIndex = this.m_Category;
            this.m_UIBugCategory.addEventListener(Event.CHANGE,this.onCategoryChange);
            addChild(this.m_UIBugCategory);
            this.m_UIUserMessage = new TextArea();
            this.m_UIUserMessage.maxChars = BugReportWidget.MAX_USER_MESSAGE_LENGTH;
            this.m_UIUserMessage.minHeight = 200;
            this.m_UIUserMessage.minWidth = 300;
            this.m_UIUserMessage.percentHeight = NaN;
            this.m_UIUserMessage.percentWidth = 100;
            this.m_UIUserMessage.text = this.m_UserMessage;
            this.m_UIUserMessage.addEventListener(Event.CHANGE,this.onTextChange);
            this.m_UIUserMessage.addEventListener(KeyboardEvent.KEY_DOWN,PreventWhitespaceInput);
            this.m_UIUserMessage.addEventListener(TextEvent.TEXT_INPUT,PreventWhitespaceInput);
            addChild(this.m_UIUserMessage);
            this.m_UIConstructed = true;
         }
      }
      
      public function set bugInformation(param1:*) : void
      {
         if(this.m_BugInformation != param1)
         {
            this.m_BugInformation = param1;
            this.m_UncommittedSystemMessage = true;
            invalidateProperties();
         }
      }
      
      public function set userMessage(param1:String) : void
      {
         if(this.m_UserMessage != param1)
         {
            this.m_UserMessage = param1;
            this.m_UncommittedUserMessage = true;
            invalidateProperties();
         }
      }
      
      public function set category(param1:int) : void
      {
         if(param1 >= BUG_CATEGORY_MAP && param1 <= BUG_CATEGORY_OTHER)
         {
            if(this.m_Category != param1)
            {
               this.m_Category = param1;
               this.m_UncommitedCategory = true;
               invalidateProperties();
            }
            return;
         }
         throw new Error("BugReportWidget.setCategory: Invalid category " + param1);
      }
   }
}
