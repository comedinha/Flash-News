package tibia.actionbar.configurationWidgetClasses
{
   import mx.containers.VBox;
   import mx.controls.RadioButtonGroup;
   import flash.events.MouseEvent;
   import mx.events.ItemClickEvent;
   import mx.events.ListEvent;
   import tibia.magic.Spell;
   import mx.containers.Form;
   import mx.controls.RadioButton;
   import mx.containers.FormItem;
   import mx.controls.ComboBox;
   import mx.core.ClassFactory;
   import shared.controls.CustomList;
   import mx.containers.FormItemDirection;
   import tibia.magic.spellListWidgetClasses.SpellIconRenderer;
   import mx.controls.Text;
   import mx.controls.TextInput;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import tibia.input.PreventWhitespaceInput;
   import flash.events.TextEvent;
   import mx.controls.TextArea;
   import mx.core.ScrollPolicy;
   import mx.controls.CheckBox;
   import flash.display.DisplayObject;
   import tibia.input.IAction;
   import tibia.input.gameaction.SpellAction;
   import tibia.input.gameaction.TalkAction;
   import mx.collections.ArrayCollection;
   import mx.collections.Sort;
   import mx.collections.SortField;
   import tibia.magic.SpellStorage;
   import mx.core.EventPriority;
   
   public class TextEditor extends VBox implements IActionEditor
   {
      
      private static const TYPE_TALK:int = 1;
      
      private static const BUNDLE:String = "ActionButtonConfigurationWidget";
      
      private static const TYPE_SPELL:int = 0;
       
      
      private var m_UIType:RadioButtonGroup = null;
      
      private var m_Type:int = 0;
      
      private var m_SpellParameter:String = null;
      
      private var m_UncommittedSpell:Boolean = false;
      
      private var m_UISpell:ComboBox = null;
      
      private var m_UISpellParameter:TextInput = null;
      
      private var m_TalkText:String = null;
      
      private var m_UIConstructed:Boolean = false;
      
      private var m_UncommittedTalkText:Boolean = false;
      
      private var m_UISpellIcon:SpellIconRenderer = null;
      
      private var m_UITalkText:TextArea = null;
      
      private var m_SpellsView:ArrayCollection = null;
      
      private var m_Spell:Spell = null;
      
      private var m_UncommittedSpellParameter:Boolean = false;
      
      private var m_UncommittedTalkAutoSend:Boolean = false;
      
      private var m_TalkAutoSend:Boolean = false;
      
      private var m_UITalkAutoSend:CheckBox = null;
      
      private var m_UncommittedType:Boolean = true;
      
      private var m_UISpellDescription:Text = null;
      
      public function TextEditor()
      {
         super();
         label = resourceManager.getString(BUNDLE,"TEXT_TITLE");
         var _loc1_:Sort = new Sort();
         _loc1_.fields = [new SortField("name",true)];
         this.m_SpellsView = new ArrayCollection(SpellStorage.SPELLS);
         this.m_SpellsView.sort = _loc1_;
         this.m_SpellsView.refresh();
         addEventListener(MouseEvent.CLICK,this.onMouseClick,false,EventPriority.DEFAULT + 1,false);
      }
      
      private function onTalkAutoSendChange(param1:MouseEvent) : void
      {
         this.talkAutoSend = this.m_UITalkAutoSend.selected;
      }
      
      private function onTypeChange(param1:ItemClickEvent) : void
      {
         this.type = int(this.m_UIType.selectedValue);
      }
      
      protected function set type(param1:int) : void
      {
         if(param1 != TYPE_SPELL && param1 != TYPE_TALK)
         {
            param1 = TYPE_SPELL;
         }
         if(this.m_Type != param1)
         {
            this.m_Type = param1;
            this.m_UncommittedType = true;
            invalidateProperties();
            if(this.type == TYPE_SPELL)
            {
               this.talkAutoSend = false;
               this.talkText = null;
            }
            else
            {
               this.spell = null;
               this.spellParameter = null;
            }
         }
      }
      
      private function onSpellChange(param1:ListEvent) : void
      {
         this.spell = this.m_UISpell.selectedItem as Spell;
         this.spellParameter = null;
      }
      
      override protected function createChildren() : void
      {
         var _loc1_:Form = null;
         var _loc2_:RadioButton = null;
         var _loc3_:FormItem = null;
         if(!this.m_UIConstructed)
         {
            super.createChildren();
            _loc1_ = new Form();
            _loc1_.percentHeight = 100;
            _loc1_.percentWidth = 100;
            _loc1_.styleName = "actionConfigurationWidgetRootContainer";
            this.m_UIType = new RadioButtonGroup();
            this.m_UIType.addEventListener(ItemClickEvent.ITEM_CLICK,this.onTypeChange);
            _loc2_ = new RadioButton();
            _loc2_.group = this.m_UIType;
            _loc2_.label = resourceManager.getString(BUNDLE,"TEXT_SPELL_RADIO");
            _loc2_.styleName = this;
            _loc2_.value = TYPE_SPELL;
            _loc1_.addChild(_loc2_);
            _loc3_ = new FormItem();
            _loc3_.label = resourceManager.getString(BUNDLE,"TEXT_SPELL_COMBO");
            _loc3_.percentHeight = NaN;
            _loc3_.percentWidth = 100;
            this.m_UISpell = new ComboBox();
            this.m_UISpell.dataProvider = this.m_SpellsView;
            this.m_UISpell.dropdownFactory = new ClassFactory(CustomList);
            this.m_UISpell.labelField = "name";
            this.m_UISpell.percentHeight = NaN;
            this.m_UISpell.percentWidth = 100;
            this.m_UISpell.addEventListener(ListEvent.CHANGE,this.onSpellChange);
            _loc3_.addChild(this.m_UISpell);
            _loc1_.addChild(_loc3_);
            _loc3_ = new FormItem();
            _loc3_.direction = FormItemDirection.HORIZONTAL;
            _loc3_.label = resourceManager.getString(BUNDLE,"TEXT_SPELL_DETAILS");
            _loc3_.percentHeight = NaN;
            _loc3_.percentWidth = 100;
            this.m_UISpellIcon = new SpellIconRenderer();
            _loc3_.addChild(this.m_UISpellIcon);
            this.m_UISpellDescription = new Text();
            _loc3_.addChild(this.m_UISpellDescription);
            _loc1_.addChild(_loc3_);
            _loc3_ = new FormItem();
            _loc3_.label = resourceManager.getString(BUNDLE,"TEXT_SPELL_PARAMETER");
            _loc3_.percentHeight = NaN;
            _loc3_.percentWidth = 100;
            this.m_UISpellParameter = new TextInput();
            this.m_UISpellParameter.percentHeight = NaN;
            this.m_UISpellParameter.percentWidth = 100;
            this.m_UISpellParameter.maxChars = 256;
            this.m_UISpellParameter.addEventListener(Event.CHANGE,this.onSpellParameterChange);
            this.m_UISpellParameter.addEventListener(KeyboardEvent.KEY_DOWN,PreventWhitespaceInput);
            this.m_UISpellParameter.addEventListener(TextEvent.TEXT_INPUT,PreventWhitespaceInput);
            _loc3_.addChild(this.m_UISpellParameter);
            _loc1_.addChild(_loc3_);
            _loc2_ = new RadioButton();
            _loc2_.group = this.m_UIType;
            _loc2_.label = resourceManager.getString(BUNDLE,"TEXT_TALK_RADIO");
            _loc2_.styleName = this;
            _loc2_.value = TYPE_TALK;
            _loc1_.addChild(_loc2_);
            _loc3_ = new FormItem();
            _loc3_.label = resourceManager.getString(BUNDLE,"TEXT_TALK_TEXT");
            _loc3_.percentHeight = NaN;
            _loc3_.percentWidth = 100;
            this.m_UITalkText = new TextArea();
            this.m_UITalkText.percentWidth = 100;
            this.m_UITalkText.height = 50;
            this.m_UITalkText.maxChars = 256;
            this.m_UITalkText.verticalScrollPolicy = ScrollPolicy.OFF;
            this.m_UITalkText.addEventListener(Event.CHANGE,this.onTalkTextChange);
            this.m_UITalkText.addEventListener(KeyboardEvent.KEY_DOWN,PreventWhitespaceInput);
            this.m_UITalkText.addEventListener(TextEvent.TEXT_INPUT,PreventWhitespaceInput);
            _loc3_.addChild(this.m_UITalkText);
            _loc1_.addChild(_loc3_);
            _loc3_ = new FormItem();
            _loc3_.label = resourceManager.getString(BUNDLE,"TEXT_TALK_AUTOSEND");
            _loc3_.percentHeight = NaN;
            _loc3_.percentWidth = 100;
            this.m_UITalkAutoSend = new CheckBox();
            this.m_UITalkAutoSend.percentWidth = 100;
            this.m_UITalkAutoSend.addEventListener(MouseEvent.CLICK,this.onTalkAutoSendChange);
            _loc3_.addChild(this.m_UITalkAutoSend);
            _loc1_.addChild(_loc3_);
            addChild(_loc1_);
            this.m_UIConstructed = true;
         }
      }
      
      protected function get talkAutoSend() : Boolean
      {
         return this.m_TalkAutoSend;
      }
      
      private function onMouseClick(param1:MouseEvent) : void
      {
         var _loc2_:DisplayObject = param1.target as DisplayObject;
         while(_loc2_ != null)
         {
            if(_loc2_ == this.m_UISpell || _loc2_ == this.m_UISpellDescription || _loc2_ == this.m_UISpellIcon || _loc2_ == this.m_UISpellParameter)
            {
               this.type = TYPE_SPELL;
               return;
            }
            if(_loc2_ == this.m_UITalkAutoSend || _loc2_ == this.m_UITalkText)
            {
               this.type = TYPE_TALK;
               return;
            }
            _loc2_ = _loc2_.parent;
         }
      }
      
      protected function get spell() : Spell
      {
         return this.m_Spell;
      }
      
      public function get action() : IAction
      {
         var _loc1_:String = null;
         var _loc2_:String = null;
         if(this.type == TYPE_SPELL && this.spell != null)
         {
            _loc1_ = null;
            if(this.spellParameter != null)
            {
               _loc1_ = this.spellParameter.replace("/(^s+|s+$)/","");
            }
            return new SpellAction(this.spell.ID,_loc1_);
         }
         if(this.type == TYPE_TALK && this.talkText != null)
         {
            _loc2_ = this.talkText.replace(/^\s+/,"").replace(/\s+$/," ");
            return new TalkAction(_loc2_,this.talkAutoSend);
         }
         return null;
      }
      
      protected function get type() : int
      {
         return this.m_Type;
      }
      
      protected function set talkAutoSend(param1:Boolean) : void
      {
         if(this.m_TalkAutoSend != param1)
         {
            this.m_TalkAutoSend = param1;
            this.m_UncommittedTalkAutoSend = true;
            invalidateProperties();
         }
      }
      
      private function onTalkTextChange(param1:Event) : void
      {
         this.talkText = this.m_UITalkText.text;
      }
      
      protected function set spellParameter(param1:String) : void
      {
         if(this.spell == null || !this.spell.hasParameter)
         {
            param1 = null;
         }
         if(this.m_SpellParameter != param1)
         {
            this.m_SpellParameter = param1;
            this.m_UncommittedSpellParameter = true;
            invalidateProperties();
         }
      }
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
         if(this.m_UncommittedType)
         {
            this.m_UIType.selectedValue = this.type;
            if(this.type == TYPE_SPELL)
            {
               this.m_UISpell.enabled = true;
               this.m_UISpellDescription.enabled = true;
               this.m_UISpellIcon.enabled = true;
               if(this.spell != null && this.spell.hasParameter)
               {
                  this.m_UISpellParameter.enabled = true;
                  if(this.spellParameter != null)
                  {
                     this.m_UISpellParameter.selectionBeginIndex = this.m_UISpellParameter.selectionEndIndex = this.spellParameter.length;
                  }
                  this.m_UISpellParameter.setFocus();
               }
               else
               {
                  this.m_UISpellParameter.enabled = false;
               }
               this.m_UITalkAutoSend.enabled = false;
               this.m_UITalkText.enabled = false;
            }
            else
            {
               this.m_UISpell.enabled = false;
               this.m_UISpellDescription.enabled = false;
               this.m_UISpellIcon.enabled = false;
               this.m_UISpellParameter.enabled = false;
               this.m_UITalkAutoSend.enabled = true;
               this.m_UITalkText.enabled = true;
               if(this.talkText != null)
               {
                  this.m_UITalkText.selectionBeginIndex = this.m_UITalkText.selectionEndIndex = this.talkText.length;
               }
               this.m_UITalkText.setFocus();
            }
            this.m_UncommittedType = false;
         }
         if(this.m_UncommittedTalkText)
         {
            this.m_UITalkText.text = this.talkText;
            this.m_UncommittedTalkText = false;
         }
         if(this.m_UncommittedTalkAutoSend)
         {
            this.m_UITalkAutoSend.selected = this.talkAutoSend;
            this.m_UncommittedTalkAutoSend = false;
         }
         if(this.m_UncommittedSpell)
         {
            if(this.spell != null)
            {
               this.m_UISpellDescription.text = this.spell.name + "\n" + this.spell.formula;
               this.m_UISpellIcon.spell = this.spell;
               this.m_UISpell.selectedItem = this.spell;
               if(this.spell.hasParameter)
               {
                  this.m_UISpellParameter.enabled = true;
                  this.m_UISpellParameter.setFocus();
               }
               else
               {
                  this.m_UISpellParameter.enabled = false;
               }
               this.m_UISpellParameter.text = this.spellParameter;
            }
            else
            {
               this.m_UISpellDescription.text = null;
               this.m_UISpellIcon.spell = null;
               this.m_UISpell.selectedItem = null;
               this.m_UISpellParameter.enabled = false;
               this.m_UISpellParameter.text = null;
            }
            this.m_UncommittedSpell = false;
         }
         if(this.m_UncommittedSpellParameter)
         {
            this.m_UISpellParameter.text = this.spellParameter;
            this.m_UncommittedSpellParameter = false;
         }
      }
      
      protected function set spell(param1:Spell) : void
      {
         if(param1 == null && this.m_SpellsView.length > 0)
         {
            param1 = this.m_SpellsView.getItemAt(0) as Spell;
         }
         if(this.m_Spell != param1)
         {
            this.m_Spell = param1;
            this.m_UncommittedSpell = true;
            invalidateProperties();
         }
      }
      
      protected function get spellParameter() : String
      {
         return this.m_SpellParameter;
      }
      
      private function onSpellParameterChange(param1:Event) : void
      {
         this.spellParameter = this.m_UISpellParameter.text;
      }
      
      protected function set talkText(param1:String) : void
      {
         if(this.m_TalkText != param1)
         {
            this.m_TalkText = param1;
            this.m_UncommittedTalkText = true;
            invalidateProperties();
         }
      }
      
      public function set action(param1:IAction) : void
      {
         var _loc2_:TalkAction = null;
         if(param1 is SpellAction)
         {
            this.type = TYPE_SPELL;
            this.talkText = null;
            this.talkAutoSend = false;
            this.spell = SpellAction(param1).spell;
            this.spellParameter = SpellAction(param1).parameter;
         }
         else if(param1 is TalkAction)
         {
            _loc2_ = param1 as TalkAction;
            this.type = TYPE_TALK;
            this.talkText = _loc2_.text;
            this.talkAutoSend = _loc2_.autoSend;
            this.spell = null;
            this.spellParameter = null;
         }
         else
         {
            this.type = TYPE_SPELL;
            this.talkText = null;
            this.talkAutoSend = false;
            this.spell = null;
            this.spellParameter = null;
         }
      }
      
      protected function get talkText() : String
      {
         return this.m_TalkText;
      }
   }
}
