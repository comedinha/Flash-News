package tibia.actionbar.configurationWidgetClasses
{
   import mx.containers.VBox;
   import mx.controls.RadioButton;
   import mx.controls.RadioButtonGroup;
   import mx.events.ItemClickEvent;
   import tibia.appearances.AppearanceStorage;
   import tibia.appearances.AppearanceType;
   import tibia.input.IAction;
   import tibia.input.gameaction.EquipAction;
   import tibia.input.gameaction.UseAction;
   
   public class ObjectEditor extends VBox implements IActionEditor
   {
      
      private static const BUNDLE:String = "ActionButtonConfigurationWidget";
       
      
      private var m_UncommittedTarget:Boolean = false;
      
      private var m_Target:int = 0;
      
      protected var m_UITarget:RadioButtonGroup = null;
      
      private var m_UncommittedAppearanceData:Boolean = false;
      
      private var m_AppearanceData:int = 0;
      
      protected var m_UIConstructed:Boolean = false;
      
      private var m_UncommittedAppearanceType:Boolean = false;
      
      private var m_AppearanceType:AppearanceType = null;
      
      protected var m_UIRootContainer:VBox = null;
      
      public function ObjectEditor()
      {
         super();
         label = resourceManager.getString(BUNDLE,"OBJECT_TITLE");
      }
      
      protected function get appearanceType() : AppearanceType
      {
         return this.m_AppearanceType;
      }
      
      override protected function commitProperties() : void
      {
         var _loc1_:Boolean = false;
         var _loc2_:* = false;
         var _loc3_:Boolean = false;
         var _loc4_:RadioButton = null;
         super.commitProperties();
         if(this.m_UncommittedAppearanceType)
         {
            _loc1_ = this.appearanceType != null && !this.appearanceType.isMultiUse;
            _loc2_ = !_loc1_;
            _loc3_ = this.appearanceType != null && this.appearanceType.isCloth;
            _loc4_ = null;
            this.m_UIRootContainer.removeAllChildren();
            if(_loc1_)
            {
               _loc4_ = new RadioButton();
               _loc4_.group = this.m_UITarget;
               _loc4_.label = resourceManager.getString(BUNDLE,"OBJECT_USE_TARGET_SELF");
               _loc4_.styleName = this;
               _loc4_.value = UseAction.TARGET_SELF;
               this.m_UIRootContainer.addChild(_loc4_);
            }
            if(_loc2_)
            {
               _loc4_ = new RadioButton();
               _loc4_.group = this.m_UITarget;
               _loc4_.label = resourceManager.getString(BUNDLE,"OBJECT_MULTIUSE_TARGET_SELF");
               _loc4_.styleName = this;
               _loc4_.value = UseAction.TARGET_SELF;
               this.m_UIRootContainer.addChild(_loc4_);
               _loc4_ = new RadioButton();
               _loc4_.group = this.m_UITarget;
               _loc4_.label = resourceManager.getString(BUNDLE,"OBJECT_MULTIUSE_TARGET_ATTACK");
               _loc4_.styleName = this;
               _loc4_.value = UseAction.TARGET_ATTACK;
               this.m_UIRootContainer.addChild(_loc4_);
               _loc4_ = new RadioButton();
               _loc4_.group = this.m_UITarget;
               _loc4_.label = resourceManager.getString(BUNDLE,"OBJECT_MULTIUSE_TARGET_CROSSHAIR");
               _loc4_.styleName = this;
               _loc4_.value = UseAction.TARGET_CROSSHAIR;
               this.m_UIRootContainer.addChild(_loc4_);
            }
            if(_loc3_)
            {
               _loc4_ = new RadioButton();
               _loc4_.value = EquipAction.TARGET_AUTO;
               _loc4_.label = resourceManager.getString(BUNDLE,"OBJECT_EQUIP_TARGET_SELF");
               _loc4_.group = this.m_UITarget;
               _loc4_.styleName = this;
               this.m_UIRootContainer.addChild(_loc4_);
            }
            this.m_UncommittedAppearanceType = false;
         }
         if(this.m_UncommittedAppearanceData)
         {
            this.m_UncommittedAppearanceData = false;
         }
         if(this.m_UncommittedTarget)
         {
            this.m_UITarget.selectedValue = this.target;
            this.m_UncommittedTarget = false;
         }
      }
      
      protected function get target() : int
      {
         return this.m_Target;
      }
      
      override protected function createChildren() : void
      {
         if(!this.m_UIConstructed)
         {
            super.createChildren();
            this.m_UIRootContainer = new VBox();
            this.m_UIRootContainer.percentHeight = 100;
            this.m_UIRootContainer.percentWidth = 100;
            this.m_UIRootContainer.styleName = "actionConfigurationWidgetRootContainer";
            addChild(this.m_UIRootContainer);
            this.m_UITarget = new RadioButtonGroup();
            this.m_UITarget.addEventListener(ItemClickEvent.ITEM_CLICK,this.onTargetChange);
            this.m_UIConstructed = true;
         }
      }
      
      protected function set appearanceData(param1:int) : void
      {
         if(this.m_AppearanceData != param1)
         {
            this.m_AppearanceData = param1;
            this.m_UncommittedAppearanceData = true;
            invalidateProperties();
         }
      }
      
      protected function set target(param1:int) : void
      {
         if(this.m_Target != param1)
         {
            this.m_Target = param1;
            this.m_UncommittedTarget = true;
            invalidateProperties();
         }
      }
      
      public function set action(param1:IAction) : void
      {
         var _loc2_:AppearanceStorage = Tibia.s_GetAppearanceStorage();
         if(param1 is UseAction && _loc2_ != null)
         {
            this.appearanceType = UseAction(param1).type;
            this.appearanceData = UseAction(param1).data;
            this.target = UseAction(param1).target;
         }
         else if(param1 is EquipAction && _loc2_ != null)
         {
            this.appearanceType = EquipAction(param1).type;
            this.appearanceData = EquipAction(param1).data;
            this.target = EquipAction.TARGET_AUTO;
         }
         else
         {
            this.appearanceType = null;
            this.appearanceData = 0;
            this.target = UseAction.TARGET_SELF;
         }
      }
      
      protected function get appearanceData() : int
      {
         return this.m_AppearanceData;
      }
      
      private function onTargetChange(param1:ItemClickEvent) : void
      {
         this.target = int(this.m_UITarget.selectedValue);
      }
      
      protected function set appearanceType(param1:AppearanceType) : void
      {
         if(this.m_AppearanceType != param1)
         {
            this.m_AppearanceType = param1;
            this.m_UncommittedAppearanceType = true;
            invalidateProperties();
            this.appearanceData = 0;
         }
      }
      
      public function get action() : IAction
      {
         if(this.appearanceType != null)
         {
            switch(this.target)
            {
               case UseAction.TARGET_SELF:
               case UseAction.TARGET_ATTACK:
               case UseAction.TARGET_CROSSHAIR:
                  return new UseAction(this.appearanceType.ID,this.appearanceData,this.target);
               case EquipAction.TARGET_AUTO:
                  return new EquipAction(this.appearanceType,this.appearanceData,this.target);
            }
         }
         return null;
      }
   }
}
