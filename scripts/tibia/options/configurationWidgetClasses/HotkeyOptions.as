package tibia.options.configurationWidgetClasses
{
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.events.TextEvent;
   import mx.collections.ArrayCollection;
   import mx.collections.ICollectionView;
   import mx.collections.IList;
   import mx.containers.Form;
   import mx.containers.FormItem;
   import mx.containers.FormItemDirection;
   import mx.containers.VBox;
   import mx.containers.ViewStack;
   import mx.controls.Button;
   import mx.controls.DataGrid;
   import mx.controls.Spacer;
   import mx.controls.TextInput;
   import mx.controls.dataGridClasses.DataGridColumn;
   import mx.core.ClassFactory;
   import mx.core.EventPriority;
   import mx.core.ScrollPolicy;
   import mx.events.CloseEvent;
   import mx.events.FlexEvent;
   import mx.events.IndexChangedEvent;
   import mx.events.ListEvent;
   import shared.controls.CustomButton;
   import shared.controls.CustomDataGrid;
   import shared.controls.EmbeddedDialog;
   import tibia.actionbar.ActionBarSet;
   import tibia.game.PopUpBase;
   import tibia.input.IAction;
   import tibia.input.MappingSet;
   import tibia.input.MouseRepeatEvent;
   import tibia.input.PreventWhitespaceInput;
   import tibia.input.mapping.Binding;
   import tibia.input.mapping.Mapping;
   import tibia.input.staticaction.StaticAction;
   import tibia.options.ConfigurationWidget;
   import tibia.options.OptionsStorage;
   
   public class HotkeyOptions extends VBox implements IOptionsEditor
   {
      
      private static const STATE_CHANGED:int = 1;
      
      private static const STATE_REMOVED:int = 2;
      
      private static const STATE_UNCHANGED:int = 0;
       
      
      private var m_UISetName:TextInput = null;
      
      private var m_UncommittedAction:Boolean = false;
      
      private var m_UIPrevSet:Button = null;
      
      private var m_Options:OptionsStorage = null;
      
      private var m_UIConstructed:Boolean = false;
      
      private var m_UIRemoveSet:Button = null;
      
      private var m_UncommittedIndex:Boolean = false;
      
      private var m_UIAddSet:Button = null;
      
      private var m_UIMapping:DataGrid = null;
      
      private var m_UIReset:Button = null;
      
      private var m_MappingSets:Array;
      
      private var m_UncommittedMode:Boolean = false;
      
      private var m_Mode:int = 1;
      
      private var m_UncommittedOptions:Boolean = false;
      
      private var m_Index:int = -1;
      
      private var m_Action:IAction = null;
      
      private var m_UINextSet:Button = null;
      
      private var m_UIMode:Button = null;
      
      public function HotkeyOptions()
      {
         this.m_MappingSets = [];
         super();
         label = resourceManager.getString(ConfigurationWidget.BUNDLE,"HOTKEY_LABEL");
         horizontalScrollPolicy = ScrollPolicy.OFF;
         verticalScrollPolicy = ScrollPolicy.OFF;
         addEventListener(FlexEvent.CREATION_COMPLETE,this.onCreationComplete);
         setStyle("horizontalAlign","center");
         setStyle("verticalAlign","middle");
      }
      
      private function countSets() : int
      {
         var _loc2_:Object = null;
         var _loc1_:int = 0;
         for each(_loc2_ in this.m_MappingSets)
         {
            if(_loc2_.state != STATE_REMOVED)
            {
               _loc1_++;
            }
         }
         return _loc1_;
      }
      
      private function onFinishEditBinding(param1:CloseEvent) : void
      {
         var _loc3_:OptionsEditorEvent = null;
         var _loc2_:PopUpBase = PopUpBase.getCurrent();
         if(_loc2_ != null)
         {
            _loc2_.keyboardFlags = PopUpBase.KEY_ENTER | PopUpBase.KEY_ESCAPE;
         }
         if(param1.detail != EmbeddedDialog.CANCEL && this.m_Index >= 0 && this.m_Index < this.m_MappingSets.length)
         {
            this.m_MappingSets[this.m_Index].state = STATE_CHANGED;
            this.m_UncommittedIndex = true;
            invalidateProperties();
            _loc3_ = new OptionsEditorEvent(OptionsEditorEvent.VALUE_CHANGE);
            dispatchEvent(_loc3_);
         }
      }
      
      private function onChangeAction(param1:ListEvent) : void
      {
         var _loc2_:Object = null;
         if(param1.itemRenderer != null && (_loc2_ = param1.itemRenderer.data) != null && _loc2_.hasOwnProperty("action"))
         {
            this.action = _loc2_.action as IAction;
         }
         else
         {
            this.action = null;
         }
      }
      
      private function onConfirmResetMapping(param1:CloseEvent) : void
      {
         var _loc2_:Object = null;
         var _loc3_:MappingSet = null;
         var _loc4_:OptionsEditorEvent = null;
         if(param1.detail == EmbeddedDialog.YES && this.m_Index >= 0 && this.m_Index < this.m_MappingSets.length)
         {
            _loc2_ = this.m_MappingSets[this.m_Index];
            _loc3_ = this.m_Options.getDefaultMappingSet();
            if(this.m_Mode == MappingSet.CHAT_MODE_OFF)
            {
               _loc2_.chatModeOff = this.createMapping(_loc3_.chatModeOff.binding);
            }
            else
            {
               _loc2_.chatModeOn = this.createMapping(_loc3_.chatModeOn.binding);
            }
            _loc2_.state = STATE_CHANGED;
            this.m_UncommittedIndex = true;
            invalidateProperties();
            _loc4_ = new OptionsEditorEvent(OptionsEditorEvent.VALUE_CHANGE);
            dispatchEvent(_loc4_);
         }
      }
      
      protected function saveMapping(param1:Array, param2:Mapping) : void
      {
         if(param1 == null)
         {
            throw new ArgumentError("HotkeyOptions.saveEditList: Invalid edit mapping.");
         }
         if(param2 == null)
         {
            throw new ArgumentError("HotkeyOptions.saveEditList: Invalid set mapping.");
         }
         param2.removeAll(false);
         var _loc3_:Binding = null;
         var _loc4_:int = param1.length;
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            if((_loc3_ = param1[_loc5_].firstBinding as Binding) != null)
            {
               param2.addItem(_loc3_);
            }
            if((_loc3_ = param1[_loc5_].secondBinding as Binding) != null)
            {
               param2.addItem(_loc3_);
            }
            _loc5_++;
         }
      }
      
      private function onButtonClick(param1:MouseEvent) : void
      {
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:Array = null;
         var _loc8_:int = 0;
         var _loc2_:PopUpBase = PopUpBase.getCurrent();
         var _loc3_:EmbeddedDialog = null;
         var _loc4_:String = null;
         if(param1.currentTarget == this.m_UINextSet)
         {
            this.cycleSet(1);
         }
         else if(param1.currentTarget == this.m_UIPrevSet)
         {
            this.cycleSet(-1);
         }
         else if(param1.currentTarget == this.m_UIReset && this.m_Index >= 0 && this.m_Index < this.m_MappingSets.length)
         {
            _loc5_ = resourceManager.getString(ConfigurationWidget.BUNDLE,this.m_Mode == MappingSet.CHAT_MODE_OFF?"HOTKEY_MODE_CHATMODEOFF":"HOTKEY_MODE_CHATMODEON");
            _loc4_ = this.m_MappingSets[this.m_Index].name;
            _loc3_ = new EmbeddedDialog();
            _loc3_.buttonFlags = EmbeddedDialog.YES | EmbeddedDialog.NO;
            _loc3_.title = resourceManager.getString(ConfigurationWidget.BUNDLE,"HOTKEY_DLG_RESET_TITLE");
            _loc3_.text = resourceManager.getString(ConfigurationWidget.BUNDLE,"HOTKEY_DLG_RESET_TEXT",[_loc5_,_loc4_]);
            _loc3_.addEventListener(CloseEvent.CLOSE,this.onConfirmResetMapping,false,EventPriority.DEFAULT,true);
            if(_loc2_ != null)
            {
               _loc2_.embeddedDialog = _loc3_;
            }
         }
         else if(param1.currentTarget == this.m_UIAddSet && this.countSets() < Math.min(ActionBarSet.NUM_SETS,MappingSet.NUM_SETS))
         {
            _loc6_ = resourceManager.getString(ConfigurationWidget.BUNDLE,"HOTKEY_DLG_ADD_DEFAULT_SET");
            _loc7_ = [{
               "index":-1,
               "name":_loc6_
            }];
            _loc8_ = 0;
            while(_loc8_ < this.m_MappingSets.length)
            {
               if(this.m_MappingSets[_loc8_].state != STATE_REMOVED)
               {
                  _loc7_.push({
                     "index":_loc8_,
                     "name":this.m_MappingSets[_loc8_].name
                  });
               }
               _loc8_++;
            }
            _loc3_ = new AddMappingSetDialog();
            AddMappingSetDialog(_loc3_).mappingSets = _loc7_;
            AddMappingSetDialog(_loc3_).selectedIndex = 0;
            _loc3_.buttonFlags = EmbeddedDialog.OKAY | EmbeddedDialog.CANCEL;
            _loc3_.title = resourceManager.getString(ConfigurationWidget.BUNDLE,"HOTKEY_DLG_ADD_TITLE");
            _loc3_.text = resourceManager.getString(ConfigurationWidget.BUNDLE,"HOTKEY_DLG_ADD_TEXT",[_loc6_]);
            _loc3_.addEventListener(CloseEvent.CLOSE,this.onConfirmAddMappingSet,false,EventPriority.DEFAULT,true);
            if(_loc2_ != null)
            {
               _loc2_.embeddedDialog = _loc3_;
            }
         }
         else if(param1.currentTarget == this.m_UIRemoveSet && this.m_Index >= 0 && this.m_Index < this.m_MappingSets.length && this.countSets() > 1)
         {
            _loc4_ = this.m_MappingSets[this.m_Index].name;
            _loc3_ = new EmbeddedDialog();
            _loc3_.buttonFlags = EmbeddedDialog.YES | EmbeddedDialog.NO;
            _loc3_.title = resourceManager.getString(ConfigurationWidget.BUNDLE,"HOTKEY_DLG_REMOVE_TITLE");
            _loc3_.text = resourceManager.getString(ConfigurationWidget.BUNDLE,"HOTKEY_DLG_REMOVE_TEXT",[_loc4_]);
            _loc3_.addEventListener(CloseEvent.CLOSE,this.onConfirmRemoveMappingSet,false,EventPriority.DEFAULT,true);
            if(_loc2_ != null)
            {
               _loc2_.embeddedDialog = _loc3_;
            }
         }
      }
      
      public function get ID() : int
      {
         if(this.m_Index >= 0 && this.m_Index < this.m_MappingSets.length)
         {
            return this.m_MappingSets[this.m_Index].oldID;
         }
         return -1;
      }
      
      private function cycleSet(param1:int) : void
      {
         var _loc2_:int = -1;
         var _loc3_:int = this.m_MappingSets.length;
         if(this.m_Index >= 0 && this.m_Index < _loc3_ && this.m_MappingSets[this.m_Index].state != STATE_REMOVED)
         {
            _loc2_ = this.m_Index;
            while(param1 > 0)
            {
               _loc2_ = (_loc2_ + 1) % _loc3_;
               if(this.m_MappingSets[_loc2_].state != STATE_REMOVED)
               {
                  param1--;
               }
            }
            while(param1 < 0)
            {
               _loc2_ = (_loc2_ - 1 + _loc3_) % _loc3_;
               if(this.m_MappingSets[_loc2_].state != STATE_REMOVED)
               {
                  param1++;
               }
            }
         }
         if(this.m_Index != _loc2_)
         {
            this.m_Index = _loc2_;
            this.m_UncommittedIndex = true;
            invalidateProperties();
         }
      }
      
      public function get options() : OptionsStorage
      {
         return this.m_Options;
      }
      
      override protected function createChildren() : void
      {
         var _loc1_:VBox = null;
         var _loc2_:Form = null;
         var _loc3_:FormItem = null;
         var _loc4_:Spacer = null;
         var _loc5_:Array = null;
         var _loc6_:DataGridColumn = null;
         if(!this.m_UIConstructed)
         {
            super.createChildren();
            _loc1_ = new VBox();
            _loc1_.percentHeight = 100;
            _loc1_.percentWidth = 100;
            _loc1_.styleName = "optionsConfigurationWidgetRootContainer";
            _loc2_ = new Form();
            _loc2_.percentHeight = NaN;
            _loc2_.percentWidth = 100;
            _loc2_.setStyle("paddingBottom",2);
            _loc2_.setStyle("paddingTop",2);
            _loc2_.setStyle("paddingRight",0);
            _loc3_ = new FormItem();
            _loc3_.direction = FormItemDirection.HORIZONTAL;
            _loc3_.label = resourceManager.getString(ConfigurationWidget.BUNDLE,"HOTKEY_SETNAME");
            _loc3_.percentHeight = NaN;
            _loc3_.percentWidth = 100;
            this.m_UIPrevSet = new CustomButton();
            this.m_UIPrevSet.styleName = getStyle("setScrollLeftStyle");
            this.m_UIPrevSet.addEventListener(MouseEvent.CLICK,this.onButtonClick);
            this.m_UIPrevSet.addEventListener(MouseEvent.MOUSE_DOWN,this.onButtonDown);
            this.m_UIPrevSet.addEventListener(MouseRepeatEvent.REPEAT_MOUSE_DOWN,this.onButtonClick);
            _loc3_.addChild(this.m_UIPrevSet);
            this.m_UISetName = new TextInput();
            this.m_UISetName.width = 134;
            this.m_UISetName.maxChars = 10;
            this.m_UISetName.styleName = getStyle("setTextInputStyle");
            this.m_UISetName.addEventListener(Event.CHANGE,this.onChangeSetName);
            this.m_UISetName.addEventListener(KeyboardEvent.KEY_DOWN,PreventWhitespaceInput);
            this.m_UISetName.addEventListener(TextEvent.TEXT_INPUT,PreventWhitespaceInput);
            _loc3_.addChild(this.m_UISetName);
            this.m_UINextSet = new CustomButton();
            this.m_UINextSet.styleName = getStyle("setScrollRightStyle");
            this.m_UINextSet.addEventListener(MouseEvent.CLICK,this.onButtonClick);
            this.m_UINextSet.addEventListener(MouseEvent.MOUSE_DOWN,this.onButtonDown);
            this.m_UINextSet.addEventListener(MouseRepeatEvent.REPEAT_MOUSE_DOWN,this.onButtonClick);
            _loc3_.addChild(this.m_UINextSet);
            _loc4_ = new Spacer();
            _loc4_.percentWidth = 100;
            _loc3_.addChild(_loc4_);
            this.m_UIAddSet = new CustomButton();
            this.m_UIAddSet.label = resourceManager.getString(ConfigurationWidget.BUNDLE,"HOTKEY_ADD_SET");
            this.m_UIAddSet.addEventListener(MouseEvent.CLICK,this.onButtonClick);
            _loc3_.addChild(this.m_UIAddSet);
            this.m_UIRemoveSet = new CustomButton();
            this.m_UIRemoveSet.label = resourceManager.getString(ConfigurationWidget.BUNDLE,"HOTKEY_REMOVE_SET");
            this.m_UIRemoveSet.addEventListener(MouseEvent.CLICK,this.onButtonClick);
            _loc3_.addChild(this.m_UIRemoveSet);
            _loc3_.setStyle("horizontalGap",2);
            _loc3_.setStyle("verticalGap",2);
            _loc2_.addChild(_loc3_);
            _loc3_ = new FormItem();
            _loc3_.direction = FormItemDirection.HORIZONTAL;
            _loc3_.label = resourceManager.getString(ConfigurationWidget.BUNDLE,"HOTKEY_MODE");
            _loc3_.percentHeight = NaN;
            _loc3_.percentWidth = 100;
            this.m_UIMode = new CustomButton();
            this.m_UIMode.width = 75;
            this.m_UIMode.label = resourceManager.getString(ConfigurationWidget.BUNDLE,this.m_Mode == MappingSet.CHAT_MODE_OFF?"HOTKEY_MODE_CHATMODEOFF":"HOTKEY_MODE_CHATMODEON");
            this.m_UIMode.addEventListener(MouseEvent.CLICK,this.onToggleMode);
            _loc3_.addChild(this.m_UIMode);
            _loc4_ = new Spacer();
            _loc4_.percentWidth = 100;
            _loc3_.addChild(_loc4_);
            this.m_UIReset = new CustomButton();
            this.m_UIReset.label = resourceManager.getString(ConfigurationWidget.BUNDLE,"HOTKEY_RESET_MAPPING");
            this.m_UIReset.addEventListener(MouseEvent.CLICK,this.onButtonClick);
            _loc3_.addChild(this.m_UIReset);
            _loc2_.addChild(_loc3_);
            _loc1_.addChild(_loc2_);
            this.m_UIMapping = new CustomDataGrid();
            _loc5_ = [];
            _loc6_ = new DataGridColumn();
            _loc6_.headerText = resourceManager.getString(ConfigurationWidget.BUNDLE,"HOTKEY_COLUMN_ACTION");
            _loc6_.dataField = "action";
            _loc6_.editable = false;
            _loc6_.sortable = false;
            _loc6_.width = 224;
            _loc5_.push(_loc6_);
            _loc6_ = new DataGridColumn();
            _loc6_.headerText = resourceManager.getString(ConfigurationWidget.BUNDLE,"HOTKEY_COLUMN_FIRST_BINDING");
            _loc6_.dataField = "firstBinding";
            _loc6_.editable = false;
            _loc6_.itemRenderer = new ClassFactory(CustomItemRenderer#1629);
            _loc6_.sortable = false;
            _loc6_.width = 126;
            _loc6_.setStyle("textAlign","center");
            _loc5_.push(_loc6_);
            _loc6_ = new DataGridColumn();
            _loc6_.headerText = resourceManager.getString(ConfigurationWidget.BUNDLE,"HOTKEY_COLUMN_SECOND_BINDING");
            _loc6_.dataField = "secondBinding";
            _loc6_.editable = false;
            _loc6_.itemRenderer = new ClassFactory(CustomItemRenderer#1629);
            _loc6_.sortable = false;
            _loc6_.width = 126;
            _loc6_.setStyle("textAlign","center");
            _loc5_.push(_loc6_);
            this.m_UIMapping.columns = _loc5_;
            this.m_UIMapping.dataProvider = null;
            this.m_UIMapping.draggableColumns = false;
            this.m_UIMapping.percentWidth = 100;
            this.m_UIMapping.percentHeight = 100;
            this.m_UIMapping.resizableColumns = false;
            this.m_UIMapping.sortableColumns = false;
            this.m_UIMapping.styleName = getStyle("mappingListStyle");
            this.m_UIMapping.addEventListener(ListEvent.CHANGE,this.onChangeAction);
            this.m_UIMapping.addEventListener(ListEvent.ITEM_CLICK,this.onBeginEditBinding);
            _loc1_.addChild(this.m_UIMapping);
            addChild(_loc1_);
            this.m_UIConstructed = true;
         }
      }
      
      public function get mode() : int
      {
         return this.m_Mode;
      }
      
      private function onChangeSetName(param1:Event) : void
      {
         var _loc2_:Object = null;
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc5_:OptionsEditorEvent = null;
         if(this.m_Index >= 0 && this.m_Index < this.m_MappingSets.length)
         {
            _loc2_ = this.m_MappingSets[this.m_Index];
            _loc3_ = this.m_UISetName.text;
            _loc4_ = MappingSet.s_GetSanitizedSetName(_loc2_.oldID,_loc3_,false);
            if(_loc3_ == null || _loc3_.length < 1)
            {
               this.m_UISetName.text = _loc4_;
               this.m_UISetName.setSelection(0,2147483647);
            }
            else
            {
               this.m_UISetName.text = _loc4_;
            }
            _loc2_.name = _loc4_;
            _loc2_.state = STATE_CHANGED;
            _loc5_ = new OptionsEditorEvent(OptionsEditorEvent.VALUE_CHANGE);
            dispatchEvent(_loc5_);
         }
      }
      
      public function beginEditBinding(param1:IAction, param2:int = 0) : void
      {
         var _loc7_:Array = null;
         var _loc8_:Object = null;
         var _loc3_:PopUpBase = PopUpBase.getCurrent();
         if(_loc3_ == null || _loc3_.embeddedDialog != null)
         {
            return;
         }
         var _loc4_:Object = null;
         if(this.m_Index >= 0 && this.m_Index < this.m_MappingSets.length)
         {
            _loc7_ = this.m_Mode == MappingSet.CHAT_MODE_OFF?this.m_MappingSets[this.m_Index].chatModeOff:this.m_MappingSets[this.m_Index].chatModeOn;
            for each(_loc8_ in _loc7_)
            {
               if(_loc8_.action.equals(param1))
               {
                  _loc4_ = _loc8_;
                  break;
               }
            }
         }
         if(_loc4_ == null)
         {
            return;
         }
         var _loc5_:Binding = null;
         if(param2 == 0 && _loc4_.firstBinding != null)
         {
            _loc5_ = _loc4_.firstBinding;
         }
         else if(param2 == 1 && _loc4_.secondBinding != null)
         {
            _loc5_ = _loc4_.secondBinding;
         }
         else
         {
            _loc5_ = new Binding(param1,0,0,0,null,true);
         }
         if(!_loc5_.editable)
         {
            return;
         }
         var _loc6_:EditBindingDialog = new EditBindingDialog();
         _loc6_.binding = _loc5_;
         _loc6_.mapping = _loc7_;
         _loc6_.addEventListener(CloseEvent.CLOSE,this.onFinishEditBinding,false,EventPriority.DEFAULT,true);
         _loc3_.embeddedDialog = _loc6_;
         stage.focus = _loc6_;
         _loc3_.keyboardFlags = PopUpBase.KEY_NONE;
      }
      
      public function get action() : IAction
      {
         return this.m_Action;
      }
      
      private function onCreationComplete(param1:FlexEvent) : void
      {
         removeEventListener(FlexEvent.CREATION_COMPLETE,this.onCreationComplete);
         if(this.m_Action != null)
         {
            this.m_UncommittedAction = true;
            invalidateProperties();
         }
         if(parent is ViewStack)
         {
            parent.addEventListener(IndexChangedEvent.CHANGE,this.onSelectionChange,false,EventPriority.DEFAULT,true);
         }
      }
      
      protected function createMapping(param1:*) : Array
      {
         var _loc4_:StaticAction = null;
         var _loc5_:Binding = null;
         if(!(param1 is Array) && !(param1 is Vector.<Binding>))
         {
            throw new ArgumentError("HotkeyOptions.createMapping: Invalid input.");
         }
         var _loc2_:Array = [];
         var _loc3_:Object = null;
         for each(_loc4_ in StaticAction.s_GetAllActions())
         {
            _loc3_ = {
               "action":_loc4_,
               "firstBinding":null,
               "secondBinding":null
            };
            for each(_loc5_ in param1)
            {
               if(_loc5_.action.equals(_loc4_))
               {
                  if(_loc3_.firstBinding == null)
                  {
                     _loc3_.firstBinding = _loc5_.clone();
                  }
                  else if(_loc3_.secondBinding == null)
                  {
                     _loc3_.secondBinding = _loc5_.clone();
                  }
               }
            }
            _loc2_.push(_loc3_);
         }
         return _loc2_;
      }
      
      private function onButtonDown(param1:MouseEvent) : void
      {
         if(param1 is MouseRepeatEvent)
         {
            MouseRepeatEvent(param1).repeatEnabled = true;
         }
      }
      
      public function set ID(param1:int) : void
      {
         var _loc2_:int = this.m_MappingSets.length - 1;
         while(_loc2_ >= 0)
         {
            if(this.m_MappingSets[_loc2_].oldID == param1)
            {
               break;
            }
            _loc2_--;
         }
         if(this.m_Index != _loc2_)
         {
            this.m_Index = _loc2_;
            this.m_UncommittedIndex = true;
            invalidateProperties();
         }
      }
      
      protected function initaliseMappingSets() : void
      {
         var _loc1_:Array = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:MappingSet = null;
         var _loc5_:Object = null;
         this.m_MappingSets = [];
         this.m_Index = -1;
         this.m_Mode = MappingSet.CHAT_MODE_OFF;
         if(this.m_Options != null)
         {
            this.m_Mode = this.m_Options.generalInputSetMode;
            _loc1_ = this.m_Options.getMappingSetIDs();
            _loc2_ = _loc1_.length;
            _loc3_ = 0;
            while(_loc3_ < _loc2_)
            {
               _loc4_ = this.m_Options.getMappingSet(_loc1_[_loc3_]);
               _loc5_ = {
                  "oldID":_loc4_.ID,
                  "newID":-1,
                  "cloneID":-1,
                  "name":_loc4_.name,
                  "chatModeOn":this.createMapping(_loc4_.chatModeOn.binding),
                  "chatModeOff":this.createMapping(_loc4_.chatModeOff.binding),
                  "state":STATE_UNCHANGED
               };
               if(this.m_Options.generalInputSetID == _loc4_.ID)
               {
                  this.m_Index = _loc3_;
               }
               this.m_MappingSets.push(_loc5_);
               _loc3_++;
            }
         }
         this.m_UncommittedIndex = true;
         this.m_UncommittedMode = true;
         invalidateProperties();
      }
      
      public function set options(param1:OptionsStorage) : void
      {
         this.m_Options = param1;
         this.m_UncommittedOptions = true;
         invalidateProperties();
      }
      
      public function set mode(param1:int) : void
      {
         if(param1 != MappingSet.CHAT_MODE_OFF && param1 != MappingSet.CHAT_MODE_ON && param1 != MappingSet.CHAT_MODE_TEMPORARY)
         {
            throw new ArgumentError("HotkeyOptions.set mode: Invalid mode: " + param1);
         }
         if(this.m_Mode != param1)
         {
            this.m_Mode = param1;
            this.m_UncommittedMode = true;
            invalidateProperties();
         }
      }
      
      override protected function commitProperties() : void
      {
         var Name:String = null;
         var _List:ICollectionView = null;
         var i:int = 0;
         var Item:Object = null;
         super.commitProperties();
         if(this.m_UncommittedOptions)
         {
            this.initaliseMappingSets();
            this.m_UncommittedOptions = false;
         }
         var UncommittedMapping:Boolean = false;
         var UncommittedSelection:Boolean = false;
         var UncommittedScrollPosition:Number = NaN;
         if(this.m_UncommittedIndex)
         {
            Name = "";
            if(this.m_Index >= 0 && this.m_Index < this.m_MappingSets.length)
            {
               Name = this.m_MappingSets[this.m_Index].name;
            }
            this.m_UISetName.text = Name;
            UncommittedMapping = true;
            UncommittedSelection = true;
            UncommittedScrollPosition = this.m_UIMapping.verticalScrollPosition;
            this.m_UncommittedIndex = false;
         }
         if(this.m_UncommittedMode)
         {
            this.m_UIMode.label = resourceManager.getString(ConfigurationWidget.BUNDLE,this.m_Mode == MappingSet.CHAT_MODE_OFF?"HOTKEY_MODE_CHATMODEOFF":"HOTKEY_MODE_CHATMODEON");
            UncommittedMapping = true;
            UncommittedSelection = true;
            UncommittedScrollPosition = this.m_UIMapping.verticalScrollPosition;
            this.m_UncommittedMode = false;
         }
         if(UncommittedMapping)
         {
            if(this.m_Index >= 0 && this.m_Index < this.m_MappingSets.length)
            {
               _List = new ArrayCollection(this.m_Mode == MappingSet.CHAT_MODE_OFF?this.m_MappingSets[this.m_Index].chatModeOff:this.m_MappingSets[this.m_Index].chatModeOn);
               _List.filterFunction = function(param1:Object):Boolean
               {
                  return param1 != null && param1.hasOwnProperty("action") && param1.action is IAction && !IAction(param1.action).hidden;
               };
               _List.refresh();
               this.m_UIMapping.dataProvider = _List;
            }
            else
            {
               this.m_UIMapping.dataProvider = null;
            }
            UncommittedSelection = true;
            UncommittedMapping = false;
         }
         if(this.m_UncommittedAction)
         {
            UncommittedSelection = true;
            UncommittedScrollPosition = -1;
            this.m_UncommittedAction = false;
         }
         if(UncommittedSelection)
         {
            i = -1;
            if(this.m_UIMapping.dataProvider is IList)
            {
               i = IList(this.m_UIMapping.dataProvider).length - 1;
               while(i >= 0)
               {
                  Item = IList(this.m_UIMapping.dataProvider).getItemAt(i);
                  if(Item != null && Item.hasOwnProperty("action") && Item.action is IAction && IAction(Item.action).equals(this.m_Action))
                  {
                     break;
                  }
                  i--;
               }
            }
            this.m_UIMapping.selectedIndex = i;
            UncommittedSelection = false;
         }
         if(!isNaN(UncommittedScrollPosition))
         {
            if(UncommittedScrollPosition == -1 && this.m_UIMapping.selectedIndex != -1)
            {
               this.m_UIMapping.validateNow();
               this.m_UIMapping.scrollToIndex(this.m_UIMapping.selectedIndex);
            }
            else
            {
               this.m_UIMapping.verticalScrollPosition = Math.max(0,UncommittedScrollPosition);
            }
            UncommittedScrollPosition = NaN;
         }
         this.m_UIAddSet.enabled = this.countSets() < Math.max(ActionBarSet.NUM_SETS,MappingSet.NUM_SETS);
         this.m_UIRemoveSet.enabled = this.countSets() > 1;
      }
      
      protected function cloneMapping(param1:Array) : Array
      {
         if(param1 == null)
         {
            throw new ArgumentError("HotkeyOptions.cloneMapping: Invalid mapping.");
         }
         var _loc2_:Array = [];
         var _loc3_:int = 0;
         var _loc4_:int = param1.length;
         while(_loc3_ < _loc4_)
         {
            _loc2_.push({
               "action":param1[_loc3_].action,
               "firstBinding":(param1[_loc3_].firstBinding != null?Binding(param1[_loc3_].firstBinding).clone():null),
               "secondBinding":(param1[_loc3_].secondBinding != null?Binding(param1[_loc3_].secondBinding).clone():null)
            });
            _loc3_++;
         }
         return _loc2_;
      }
      
      private function onToggleMode(param1:MouseEvent) : void
      {
         if(this.m_Index >= 0 && this.m_Index < this.m_MappingSets.length)
         {
            this.m_Mode = this.m_Mode == MappingSet.CHAT_MODE_OFF?int(MappingSet.CHAT_MODE_ON):int(MappingSet.CHAT_MODE_OFF);
            this.m_UncommittedMode = true;
            invalidateProperties();
         }
      }
      
      private function onConfirmAddMappingSet(param1:CloseEvent) : void
      {
         var _loc2_:AddMappingSetDialog = null;
         var _loc3_:int = 0;
         var _loc4_:Array = null;
         var _loc5_:Array = null;
         var _loc6_:int = 0;
         var _loc7_:OptionsEditorEvent = null;
         var _loc8_:MappingSet = null;
         if(param1.detail == EmbeddedDialog.OKAY && this.countSets() < Math.max(ActionBarSet.NUM_SETS,MappingSet.NUM_SETS))
         {
            _loc2_ = AddMappingSetDialog(param1.currentTarget);
            _loc3_ = -1;
            _loc4_ = null;
            _loc5_ = null;
            _loc6_ = -1;
            if(_loc2_.mappingSets != null && _loc2_.selectedIndex >= 0 && _loc2_.selectedIndex < _loc2_.mappingSets.length)
            {
               _loc3_ = _loc2_.mappingSets[_loc2_.selectedIndex].index;
            }
            if(_loc3_ >= 0 && _loc3_ < this.m_MappingSets.length)
            {
               _loc4_ = this.cloneMapping(this.m_MappingSets[_loc3_].chatModeOff);
               _loc5_ = this.cloneMapping(this.m_MappingSets[_loc3_].chatModeOn);
               if(this.m_MappingSets[_loc3_].oldID != -1)
               {
                  _loc6_ = this.m_MappingSets[_loc3_].oldID;
               }
               else
               {
                  _loc6_ = this.m_MappingSets[_loc3_].cloneID;
               }
            }
            else
            {
               _loc8_ = this.m_Options.getDefaultMappingSet();
               _loc4_ = this.createMapping(_loc8_.chatModeOff.binding);
               _loc5_ = this.createMapping(_loc8_.chatModeOn.binding);
            }
            this.m_Index = Math.max(0,this.m_Index + 1);
            this.m_UncommittedIndex = true;
            invalidateProperties();
            this.m_MappingSets.splice(this.m_Index,0,{
               "oldID":-1,
               "newID":-1,
               "cloneID":_loc6_,
               "name":resourceManager.getString(ConfigurationWidget.BUNDLE,"HOTKEY_DLG_ADD_NEW_SET"),
               "chatModeOff":_loc4_,
               "chatModeOn":_loc5_,
               "state":STATE_CHANGED
            });
            _loc7_ = new OptionsEditorEvent(OptionsEditorEvent.VALUE_CHANGE);
            dispatchEvent(_loc7_);
         }
      }
      
      private function onBeginEditBinding(param1:ListEvent) : void
      {
         var _loc2_:Object = null;
         if(param1.columnIndex > 0 && param1.itemRenderer != null && (_loc2_ = param1.itemRenderer.data) != null && _loc2_.hasOwnProperty("action") && _loc2_.hasOwnProperty("firstBinding") && _loc2_.hasOwnProperty("secondBinding"))
         {
            this.beginEditBinding(_loc2_.action,param1.columnIndex - 1);
         }
      }
      
      public function set action(param1:IAction) : void
      {
         if(param1 != null && !(param1 is StaticAction))
         {
            throw new ArgumentError("HotkeyOptions.set selectedAction: Invalid action.");
         }
         if(this.m_Action != param1)
         {
            this.m_Action = param1;
            this.m_UncommittedAction = true;
            invalidateProperties();
         }
      }
      
      private function onConfirmRemoveMappingSet(param1:CloseEvent) : void
      {
         var _loc2_:OptionsEditorEvent = null;
         if(param1.detail == EmbeddedDialog.YES && this.m_Index >= 0 && this.m_Index < this.m_MappingSets.length && this.countSets() > 1)
         {
            this.m_MappingSets[this.m_Index].state = STATE_REMOVED;
            while(this.m_Index < this.m_MappingSets.length - 1 && this.m_MappingSets[this.m_Index].state == STATE_REMOVED)
            {
               this.m_Index++;
            }
            while(this.m_Index > 0 && this.m_MappingSets[this.m_Index].state == STATE_REMOVED)
            {
               this.m_Index--;
            }
            this.m_UncommittedIndex = true;
            invalidateProperties();
            _loc2_ = new OptionsEditorEvent(OptionsEditorEvent.VALUE_CHANGE);
            dispatchEvent(_loc2_);
         }
      }
      
      private function onSelectionChange(param1:IndexChangedEvent) : void
      {
         var _loc2_:PopUpBase = PopUpBase.getCurrent();
         if(_loc2_ != null && param1.currentTarget is ViewStack && ViewStack(param1.currentTarget).selectedChild != this)
         {
            _loc2_.embeddedDialog = null;
         }
      }
      
      public function close(param1:Boolean = false) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Object = null;
         var _loc7_:MappingSet = null;
         var _loc8_:ActionBarSet = null;
         if(this.m_Options != null && param1)
         {
            _loc2_ = 0;
            _loc3_ = 0;
            _loc4_ = MappingSet.DEFAULT_SET;
            _loc5_ = 0;
            _loc6_ = null;
            _loc7_ = null;
            _loc8_ = null;
            _loc2_ = 0;
            _loc3_ = this.m_MappingSets.length;
            while(_loc2_ < _loc3_)
            {
               _loc6_ = this.m_MappingSets[_loc2_];
               if(_loc6_.state == STATE_REMOVED)
               {
                  this.m_Options.removeActionBarSet(_loc6_.oldID);
                  this.m_Options.removeMappingSet(_loc6_.oldID);
               }
               else
               {
                  _loc6_.newID = _loc5_++;
                  if(_loc2_ == this.m_Index)
                  {
                     _loc4_ = _loc6_.newID;
                  }
                  if(_loc6_.oldID != -1 && _loc6_.oldID != _loc6_.newID)
                  {
                     _loc6_.cloneID = _loc6_.newID;
                     _loc7_ = this.m_Options.getMappingSet(_loc6_.oldID);
                     if(_loc7_ != null)
                     {
                        _loc7_.changeID(_loc6_.newID);
                     }
                     _loc8_ = this.m_Options.getActionBarSet(_loc6_.oldID);
                     if(_loc8_ != null)
                     {
                        _loc8_.changeID(_loc6_.newID);
                     }
                  }
               }
               _loc2_++;
            }
            _loc2_ = 0;
            _loc3_ = this.m_MappingSets.length;
            while(_loc2_ < _loc3_)
            {
               _loc6_ = this.m_MappingSets[_loc2_];
               if(_loc6_.state == STATE_CHANGED)
               {
                  _loc7_ = new MappingSet(_loc6_.newID,_loc6_.name);
                  this.saveMapping(_loc6_.chatModeOn,_loc7_.chatModeOn);
                  this.saveMapping(_loc6_.chatModeOff,_loc7_.chatModeOff);
                  this.m_Options.addMappingSet(_loc7_);
                  if(_loc6_.oldID == -1)
                  {
                     if(_loc6_.cloneID == -1)
                     {
                        _loc8_ = this.m_Options.getDefaultActionBarSet();
                     }
                     else
                     {
                        _loc8_ = this.m_Options.getActionBarSet(_loc6_.cloneID).clone();
                     }
                     _loc8_.changeID(_loc6_.newID);
                     this.m_Options.addActionBarSet(_loc8_);
                  }
               }
               _loc2_++;
            }
            this.m_Options.generalInputSetID = _loc4_;
         }
      }
   }
}

import mx.controls.dataGridClasses.DataGridItemRenderer;
import mx.controls.dataGridClasses.DataGridListData;
import tibia.input.mapping.Binding;

class CustomItemRenderer#1629 extends DataGridItemRenderer
{
    
   
   function CustomItemRenderer#1629()
   {
      super();
   }
   
   private function getRenderedBinding(param1:Object) : Binding
   {
      var _loc2_:DataGridListData = null;
      var _loc3_:String = null;
      if(param1 != null && (_loc2_ = listData as DataGridListData) != null && (_loc3_ = _loc2_.dataField) != null && param1.hasOwnProperty(_loc3_))
      {
         return param1[_loc3_] as Binding;
      }
      return null;
   }
   
   override public function set data(param1:Object) : void
   {
      var _loc2_:Binding = null;
      var _loc3_:* = undefined;
      if(data != param1)
      {
         super.data = param1;
         _loc2_ = this.getRenderedBinding(param1);
         _loc3_ = undefined;
         if(_loc2_ != null && !_loc2_.editable)
         {
            _loc3_ = 16711680;
         }
         setStyle("textRollOverColor",_loc3_);
         setStyle("textSelectedColor",_loc3_);
         setStyle("color",_loc3_);
      }
   }
}
