package tibia.actionbar
{
   import flash.display.DisplayObject;
   import mx.containers.Form;
   import mx.containers.FormHeading;
   import mx.containers.FormItem;
   import mx.controls.HRule;
   import mx.controls.Label;
   import shared.controls.CustomLabel;
   import tibia.actionbar.configurationWidgetClasses.IActionEditor;
   import tibia.actionbar.configurationWidgetClasses.ObjectEditor;
   import tibia.actionbar.configurationWidgetClasses.TextEditor;
   import tibia.game.PopUpBase;
   import tibia.input.IAction;
   import tibia.input.gameaction.EquipAction;
   import tibia.input.gameaction.UseAction;
   
   public class ConfigurationWidget extends PopUpBase
   {
      
      public static const BUNDLE:String = "ActionButtonConfigurationWidget";
       
      
      private var m_UIInfoLabel:Label = null;
      
      private var m_SlotIndex:int = -1;
      
      private var m_UncommittedSlotIndex:Boolean = false;
      
      private var m_UIActionEditor:IActionEditor = null;
      
      private var m_UncommittedActionBar:Boolean = false;
      
      private var m_UIConstructed:Boolean = false;
      
      private var m_UIInfoBindings:Label = null;
      
      private var m_ActionBar:ActionBar = null;
      
      public function ConfigurationWidget()
      {
         super();
         minHeight = 64;
         minWidth = 256;
      }
      
      public function set actionBar(param1:ActionBar) : void
      {
         if(this.m_ActionBar != param1)
         {
            this.m_ActionBar = param1;
            this.m_UncommittedActionBar = true;
            invalidateProperties();
            this.slotIndex = -1;
         }
      }
      
      public function set slotIndex(param1:int) : void
      {
         if(param1 < 0 || param1 >= ActionBar.NUM_ACTIONS)
         {
            param1 = -1;
         }
         if(this.m_SlotIndex != param1)
         {
            this.m_SlotIndex = param1;
            this.m_UncommittedSlotIndex = true;
            invalidateProperties();
         }
      }
      
      override protected function commitProperties() : void
      {
         var _loc2_:IAction = null;
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc5_:Array = null;
         var _loc1_:Boolean = false;
         if(this.m_UncommittedActionBar)
         {
            _loc1_ = true;
            this.m_UncommittedActionBar = false;
         }
         if(this.m_UncommittedSlotIndex)
         {
            if(this.m_UIActionEditor != null)
            {
               removeChild(this.m_UIActionEditor as DisplayObject);
               this.m_UIActionEditor = null;
            }
            if(this.actionBar != null && this.slotIndex >= 0 && this.slotIndex < ActionBar.NUM_ACTIONS)
            {
               _loc2_ = this.actionBar.getAction(this.slotIndex);
               if(_loc2_ is EquipAction || _loc2_ is UseAction)
               {
                  this.m_UIActionEditor = new ObjectEditor();
               }
               else
               {
                  this.m_UIActionEditor = new TextEditor();
               }
               this.m_UIActionEditor.action = _loc2_;
               this.m_UIActionEditor.percentHeight = 100;
               this.m_UIActionEditor.percentWidth = 100;
               this.m_UIActionEditor.styleName = "actionConfigurationWidgetEditor";
               addChildAt(this.m_UIActionEditor as DisplayObject,0);
            }
            _loc1_ = true;
            this.m_UncommittedSlotIndex = false;
         }
         if(_loc1_)
         {
            _loc3_ = null;
            _loc4_ = null;
            if(this.actionBar != null && this.slotIndex >= 0 && this.slotIndex < ActionBar.NUM_ACTIONS)
            {
               _loc5_ = this.actionBar.getBindings(this.slotIndex);
               if(_loc5_ != null && _loc5_.length > 0)
               {
                  _loc4_ = _loc5_.join(" / ");
               }
               else
               {
                  _loc4_ = resourceManager.getString(BUNDLE,"INFO_BINDINGS_EMPTY");
               }
               _loc3_ = this.actionBar.getLabel(this.slotIndex);
            }
            title = resourceManager.getString(BUNDLE,"TITLE",[_loc3_]);
            this.m_UIInfoBindings.text = _loc4_;
            this.m_UIInfoLabel.text = _loc3_;
         }
         super.commitProperties();
      }
      
      public function get slotIndex() : int
      {
         return this.m_SlotIndex;
      }
      
      override public function hide(param1:Boolean = false) : void
      {
         if(param1 && this.actionBar != null && this.slotIndex >= 0 && this.slotIndex < ActionBar.NUM_ACTIONS)
         {
            this.m_ActionBar.setAction(this.slotIndex,this.m_UIActionEditor.action);
         }
         super.hide(param1);
      }
      
      public function get actionBar() : ActionBar
      {
         return this.m_ActionBar;
      }
      
      override protected function createChildren() : void
      {
         var _loc1_:HRule = null;
         var _loc2_:Form = null;
         var _loc3_:FormHeading = null;
         var _loc4_:FormItem = null;
         if(!this.m_UIConstructed)
         {
            super.createChildren();
            _loc1_ = new HRule();
            _loc1_.percentWidth = 100;
            addChild(_loc1_);
            _loc2_ = new Form();
            _loc2_.percentWidth = 100;
            _loc2_.setStyle("paddingBottom",0);
            _loc2_.setStyle("paddingTop",0);
            _loc2_.setStyle("verticalGap",0);
            _loc3_ = new FormHeading();
            _loc3_.label = resourceManager.getString(BUNDLE,"INFO_HEADING");
            _loc2_.addChild(_loc3_);
            this.m_UIInfoLabel = new CustomLabel();
            this.m_UIInfoLabel.percentWidth = 100;
            this.m_UIInfoLabel.truncateToFit = true;
            this.m_UIInfoLabel.setStyle("fontWeight","bold");
            _loc4_ = new FormItem();
            _loc4_.label = resourceManager.getString(BUNDLE,"INFO_LABEL");
            _loc4_.percentWidth = 100;
            _loc4_.addChild(this.m_UIInfoLabel);
            _loc2_.addChild(_loc4_);
            this.m_UIInfoBindings = new CustomLabel();
            this.m_UIInfoBindings.percentWidth = 100;
            this.m_UIInfoBindings.truncateToFit = true;
            this.m_UIInfoBindings.setStyle("fontWeight","bold");
            _loc4_ = new FormItem();
            _loc4_.label = resourceManager.getString(BUNDLE,"INFO_BINDINGS");
            _loc4_.percentWidth = 100;
            _loc4_.addChild(this.m_UIInfoBindings);
            _loc2_.addChild(_loc4_);
            addChild(_loc2_);
            this.m_UIConstructed = true;
         }
      }
   }
}
