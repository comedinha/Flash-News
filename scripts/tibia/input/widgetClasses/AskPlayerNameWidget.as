package tibia.input.widgetClasses
{
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.TextEvent;
   import mx.controls.Label;
   import mx.controls.TextInput;
   import shared.utility.StringHelper;
   import tibia.creatures.Creature;
   import tibia.game.PopUpBase;
   import tibia.input.PreventWhitespaceInput;
   
   public class AskPlayerNameWidget extends PopUpBase
   {
       
      
      protected var m_UILabel:Label = null;
      
      private var m_UIConstructed:Boolean = false;
      
      protected var m_UIText:TextInput = null;
      
      private var m_UncommittedPrompt:Boolean = false;
      
      protected var m_Prompt:String = null;
      
      private var m_UncommittedName:Boolean = false;
      
      protected var m_Name:String = null;
      
      public function AskPlayerNameWidget()
      {
         super();
      }
      
      override protected function createChildren() : void
      {
         if(!this.m_UIConstructed)
         {
            super.createChildren();
            this.m_UILabel = new Label();
            this.m_UILabel.text = this.m_Prompt;
            this.m_UILabel.percentHeight = NaN;
            this.m_UILabel.percentWidth = 100;
            addChild(this.m_UILabel);
            this.m_UIText = new TextInput();
            this.m_UIText.maxChars = Creature.MAX_NAME_LENGHT;
            this.m_UIText.minWidth = Creature.MAX_NAME_LENGHT * 10;
            this.m_UIText.text = this.m_Name;
            this.m_UIText.percentHeight = NaN;
            this.m_UIText.percentWidth = 100;
            this.m_UIText.addEventListener(Event.CHANGE,this.onTextChange);
            this.m_UIText.addEventListener(KeyboardEvent.KEY_DOWN,PreventWhitespaceInput);
            this.m_UIText.addEventListener(TextEvent.TEXT_INPUT,PreventWhitespaceInput);
            addChild(this.m_UIText);
            this.m_UIConstructed = true;
         }
      }
      
      public function get prompt() : String
      {
         return this.m_Prompt;
      }
      
      public function set prompt(param1:String) : void
      {
         if(this.m_Prompt != param1)
         {
            this.m_Prompt = param1;
            this.m_UncommittedPrompt = true;
            invalidateProperties();
         }
      }
      
      protected function onTextChange(param1:Event) : void
      {
         var _loc2_:String = null;
         var _loc3_:Event = null;
         if(param1 != null)
         {
            _loc2_ = StringHelper.s_Trim(this.m_UIText.text);
            if(this.m_Name != _loc2_)
            {
               this.m_Name = _loc2_;
               _loc3_ = new Event(Event.CHANGE);
               dispatchEvent(_loc3_);
            }
         }
      }
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
         if(this.m_UncommittedName)
         {
            this.m_UIText.text = this.m_Name;
            this.m_UncommittedName = false;
         }
         if(this.m_UncommittedPrompt)
         {
            this.m_UILabel.text = this.m_Prompt;
            this.m_UncommittedPrompt = false;
         }
      }
      
      public function get playerName() : String
      {
         return this.m_Name;
      }
      
      public function set playerName(param1:String) : void
      {
         var _loc2_:Event = null;
         if(this.m_Name != param1)
         {
            this.m_Name = param1;
            this.m_UncommittedName = true;
            invalidateProperties();
            _loc2_ = new Event(Event.CHANGE);
            dispatchEvent(_loc2_);
         }
      }
   }
}
