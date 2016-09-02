package tibia.actionbar.widgetClasses
{
   import mx.containers.VBox;
   import mx.core.IToolTip;
   import mx.containers.Form;
   import tibia.actionbar.ActionBar;
   import mx.core.IChildList;
   import mx.controls.Label;
   import mx.core.IRawChildrenContainer;
   import tibia.input.IAction;
   import tibia.container.ContainerStorage;
   import tibia.magic.Spell;
   import tibia.input.gameaction.UseAction;
   import tibia.input.gameaction.EquipAction;
   import tibia.input.gameaction.SpellAction;
   import mx.core.ClassFactory;
   import mx.core.ScrollPolicy;
   import mx.controls.Text;
   import mx.containers.FormItem;
   
   public class ActionButtonToolTip extends VBox implements IToolTip
   {
      
      protected static const TYPE_INSTANT:int = 1;
      
      protected static const TYPE_RUNE:int = 2;
      
      protected static const GROUP_ATTACK:int = 1;
      
      public static const BUNDLE:String = "ActionBarWidget";
      
      protected static const GROUP_SUPPORT:int = 3;
      
      protected static const GROUP_HEALING:int = 2;
      
      protected static const GROUP_POWERSTRIKES:int = 4;
      
      protected static const TYPE_NONE:int = 0;
      
      protected static const GROUP_NONE:int = 0;
       
      
      private var m_ActionButton:tibia.actionbar.widgetClasses.IActionButton = null;
      
      private var m_UIForm:Form = null;
      
      private var m_ActionBar:ActionBar = null;
      
      private var m_UIConstructed:Boolean = false;
      
      private var m_UncommittedActionBar:Boolean = false;
      
      private var m_UncommittedActionButton:Boolean = false;
      
      public function ActionButtonToolTip()
      {
         super();
      }
      
      public function get actionButton() : tibia.actionbar.widgetClasses.IActionButton
      {
         return this.m_ActionButton;
      }
      
      private function disableTruncateToFit(param1:IChildList) : void
      {
         var _loc3_:IChildList = null;
         var _loc4_:int = 0;
         var _loc2_:Array = [param1];
         while(_loc2_.length > 0)
         {
            _loc3_ = _loc2_.shift() as IChildList;
            if(_loc3_ != null)
            {
               if(_loc3_ is Label)
               {
                  Label(_loc3_).truncateToFit = false;
               }
               if(_loc3_ is IRawChildrenContainer)
               {
                  _loc3_ = IRawChildrenContainer(_loc3_).rawChildren;
               }
               _loc4_ = _loc3_.numChildren - 1;
               while(_loc4_ >= 0)
               {
                  _loc2_.push(_loc3_.getChildAt(_loc4_));
                  _loc4_--;
               }
            }
         }
      }
      
      public function set actionButton(param1:tibia.actionbar.widgetClasses.IActionButton) : void
      {
         if(this.m_ActionButton != param1)
         {
            this.m_ActionButton = param1;
            this.m_UncommittedActionButton = true;
            invalidateProperties();
         }
      }
      
      override protected function commitProperties() : void
      {
         var _loc1_:IAction = null;
         var _loc2_:Array = null;
         var _loc3_:String = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:ContainerStorage = null;
         var _loc7_:int = 0;
         var _loc8_:Spell = null;
         var _loc9_:String = null;
         super.commitProperties();
         if(this.m_UncommittedActionBar || this.m_UncommittedActionButton)
         {
            this.m_UIForm.removeAllChildren();
            if(this.actionBar != null && this.actionButton != null)
            {
               _loc1_ = this.actionButton.action;
               this.createFormLabel(this.m_UIForm,resourceManager.getString(BUNDLE,"TIP_LABEL_ACTION"),_loc1_ != null?String(_loc1_):resourceManager.getString(BUNDLE,"TIP_ITEM_EMPTY"));
               if(_loc1_ is UseAction || _loc1_ is EquipAction)
               {
                  _loc4_ = -1;
                  _loc5_ = -1;
                  if(_loc1_ is UseAction)
                  {
                     _loc4_ = UseAction(_loc1_).type.ID;
                     _loc5_ = UseAction(_loc1_).data;
                  }
                  else
                  {
                     _loc4_ = EquipAction(_loc1_).type.ID;
                     _loc5_ = EquipAction(_loc1_).data;
                  }
                  _loc6_ = Tibia.s_GetContainerStorage();
                  if(_loc4_ != -1 && _loc5_ != -1 && _loc6_ != null)
                  {
                     _loc7_ = _loc6_.getAvailableInventory(_loc4_,_loc5_);
                     this.createFormLabel(this.m_UIForm,resourceManager.getString(BUNDLE,"TIP_LABEL_USE_REMAINING"),String(_loc7_));
                  }
               }
               else if(_loc1_ is SpellAction)
               {
                  _loc8_ = SpellAction(_loc1_).spell;
                  this.createFormLabel(this.m_UIForm,resourceManager.getString(BUNDLE,"TIP_LABEL_SPELL_FORMULA"),_loc8_.getFormattedFormula(SpellAction(_loc1_).parameter),new ClassFactory(Label));
                  this.createFormLabel(this.m_UIForm,resourceManager.getString(BUNDLE,"TIP_LABEL_SPELL_DELAY"),int(_loc8_.delaySelf / 1000) + "s");
                  _loc9_ = null;
                  if(_loc8_.castMana > 0)
                  {
                     _loc9_ = String(_loc8_.castMana);
                  }
                  else
                  {
                     _loc9_ = resourceManager.getString(BUNDLE,"TIP_LABEL_SPELL_MANA_VARYING");
                  }
                  this.createFormLabel(this.m_UIForm,resourceManager.getString(BUNDLE,"TIP_LABEL_SPELL_CAST"),_loc9_ + " / " + _loc8_.castSoulPoints);
               }
               this.createFormLabel(this.m_UIForm,resourceManager.getString(BUNDLE,"TIP_LABEL_LABEL"),this.actionBar.getLabel(this.actionButton.position));
               _loc2_ = this.actionBar.getBindings(this.actionButton.position);
               _loc3_ = null;
               if(_loc2_ != null && _loc2_.length > 0)
               {
                  _loc3_ = _loc2_.join(" / ");
               }
               else
               {
                  _loc3_ = resourceManager.getString(BUNDLE,"TIP_ITEM_EMPTY");
               }
               this.createFormLabel(this.m_UIForm,resourceManager.getString(BUNDLE,"TIP_LABEL_HOTKEY"),_loc3_,new ClassFactory(Label));
            }
            this.m_UncommittedActionBar = false;
            this.m_UncommittedActionButton = false;
         }
      }
      
      override protected function createChildren() : void
      {
         if(!this.m_UIConstructed)
         {
            super.createChildren();
            this.m_UIForm = new Form();
            this.m_UIForm.horizontalScrollPolicy = ScrollPolicy.OFF;
            this.m_UIForm.verticalScrollPolicy = ScrollPolicy.OFF;
            this.m_UIForm.setStyle("paddingBottom",0);
            this.m_UIForm.setStyle("paddingTop",0);
            this.m_UIForm.setStyle("indicatorGap",4);
            this.m_UIForm.setStyle("verticalGap",0);
            addChild(this.m_UIForm);
            this.m_UIConstructed = true;
         }
      }
      
      public function set text(param1:String) : void
      {
      }
      
      public function get text() : String
      {
         return "";
      }
      
      private function createFormLabel(param1:Form, param2:String, param3:String, param4:ClassFactory = null) : void
      {
         var _loc5_:Text = new Text();
         _loc5_.maxWidth = 200;
         _loc5_.text = param3;
         _loc5_.setStyle("fontWeight","bold");
         var _loc6_:FormItem = new FormItem();
         _loc6_.label = param2;
         _loc6_.addChild(_loc5_);
         param1.addChild(_loc6_);
         this.disableTruncateToFit(_loc6_);
      }
      
      public function set actionBar(param1:ActionBar) : void
      {
         if(this.m_ActionBar != param1)
         {
            this.m_ActionBar = param1;
            this.m_UncommittedActionBar = true;
            invalidateProperties();
         }
      }
      
      public function get actionBar() : ActionBar
      {
         return this.m_ActionBar;
      }
   }
}
