package tibia.options.configurationWidgetClasses
{
   import flash.events.Event;
   import flash.events.MouseEvent;
   import mx.collections.ArrayCollection;
   import mx.collections.IList;
   import mx.containers.Form;
   import mx.containers.FormItem;
   import mx.containers.HBox;
   import mx.containers.VBox;
   import mx.controls.Button;
   import mx.controls.CheckBox;
   import mx.controls.DataGrid;
   import mx.controls.dataGridClasses.DataGridColumn;
   import mx.core.ClassFactory;
   import mx.core.ScrollPolicy;
   import mx.events.CloseEvent;
   import mx.events.DataGridEvent;
   import mx.events.DataGridEventReason;
   import mx.events.FlexEvent;
   import mx.events.ListEvent;
   import shared.controls.CustomButton;
   import shared.controls.CustomDataGrid;
   import shared.controls.EmbeddedDialog;
   import tibia.chat.MessageFilterSet;
   import tibia.chat.MessageMode;
   import tibia.game.PopUpBase;
   import tibia.options.ConfigurationWidget;
   import tibia.options.OptionsStorage;
   
   public class MessageOptions extends VBox implements IOptionsEditor
   {
       
      
      private var m_UncommittedSelectedMode:Boolean = false;
      
      protected var m_SelectedMode:int = 0;
      
      protected var m_UIShowLevels:CheckBox = null;
      
      private var m_UncommittedValues:Boolean = true;
      
      protected var m_Options:OptionsStorage = null;
      
      protected var m_ID:int = 0;
      
      private var m_UIConstructed:Boolean = false;
      
      private var m_UncommittedFilterSet:Boolean = false;
      
      protected var m_AvailableFilterSet:IList = null;
      
      protected var m_UIFilter:DataGrid = null;
      
      private var m_UncommittedIndex:Boolean = false;
      
      protected var m_UIShowTimestamps:CheckBox = null;
      
      protected var m_UIReset:Button = null;
      
      private var m_UncommittedOptions:Boolean = false;
      
      protected var m_FilterSet:IList = null;
      
      protected var m_Index:int = 0;
      
      protected var m_DeletedFilterSet:IList = null;
      
      private var m_UncommittedID:Boolean = false;
      
      public function MessageOptions()
      {
         super();
         label = resourceManager.getString(ConfigurationWidget.BUNDLE,"MESSAGE_LABEL");
         horizontalScrollPolicy = ScrollPolicy.OFF;
         verticalScrollPolicy = ScrollPolicy.OFF;
         this.m_AvailableFilterSet = new ArrayCollection();
         this.m_DeletedFilterSet = new ArrayCollection();
         addEventListener(FlexEvent.CREATION_COMPLETE,this.onCreationComplete);
      }
      
      protected function onButtonClick(param1:MouseEvent) : void
      {
         var _loc2_:EmbeddedDialog = null;
         if(param1.currentTarget == this.m_UIReset)
         {
            _loc2_ = new EmbeddedDialog();
            _loc2_.buttonFlags = EmbeddedDialog.YES | EmbeddedDialog.NO;
            _loc2_.text = resourceManager.getString(ConfigurationWidget.BUNDLE,"MESSAGE_DLG_RESET_TEXT");
            _loc2_.title = resourceManager.getString(ConfigurationWidget.BUNDLE,"MESSAGE_DLG_RESET_TITLE");
            _loc2_.addEventListener(CloseEvent.CLOSE,this.onConfirmReset);
            PopUpBase.getCurrent().embeddedDialog = _loc2_;
         }
      }
      
      public function get ID() : int
      {
         return this.m_ID;
      }
      
      override protected function createChildren() : void
      {
         var _loc1_:VBox = null;
         var _loc2_:HBox = null;
         var _loc3_:Form = null;
         var _loc4_:FormItem = null;
         var _loc5_:Array = null;
         var _loc6_:DataGridColumn = null;
         if(!this.m_UIConstructed)
         {
            super.createChildren();
            _loc1_ = new VBox();
            _loc1_.percentHeight = 100;
            _loc1_.percentWidth = 100;
            _loc1_.styleName = "optionsConfigurationWidgetRootContainer";
            _loc2_ = new HBox();
            _loc2_.percentHeight = NaN;
            _loc2_.percentWidth = 100;
            _loc2_.setStyle("horizontalAlgin","center");
            _loc2_.setStyle("verticalAlign","middle");
            _loc3_ = new Form();
            _loc3_.percentHeight = NaN;
            _loc3_.percentWidth = 100;
            _loc3_.setStyle("paddingBottom",2);
            _loc3_.setStyle("paddingTop",2);
            _loc4_ = new FormItem();
            _loc4_.label = resourceManager.getString(ConfigurationWidget.BUNDLE,"MESSAGE_CONSOLE_TIMESTAMPS");
            _loc4_.percentHeight = NaN;
            _loc4_.percentWidth = 100;
            this.m_UIShowTimestamps = new CheckBox();
            this.m_UIShowTimestamps.addEventListener(Event.CHANGE,this.onCheckBoxChange);
            this.m_UIShowTimestamps.addEventListener(Event.CHANGE,this.onValueChange);
            _loc4_.addChild(this.m_UIShowTimestamps);
            _loc3_.addChild(_loc4_);
            _loc4_ = new FormItem();
            _loc4_.label = resourceManager.getString(ConfigurationWidget.BUNDLE,"MESSAGE_CONSOLE_LEVELS");
            _loc4_.percentHeight = NaN;
            _loc4_.percentWidth = 100;
            this.m_UIShowLevels = new CheckBox();
            this.m_UIShowLevels.addEventListener(Event.CHANGE,this.onCheckBoxChange);
            this.m_UIShowLevels.addEventListener(Event.CHANGE,this.onValueChange);
            _loc4_.addChild(this.m_UIShowLevels);
            _loc3_.addChild(_loc4_);
            _loc2_.addChild(_loc3_);
            this.m_UIReset = new CustomButton();
            this.m_UIReset.label = resourceManager.getString(ConfigurationWidget.BUNDLE,"MESSAGE_GENERAL_RESET");
            this.m_UIReset.addEventListener(MouseEvent.CLICK,this.onButtonClick);
            _loc2_.addChild(this.m_UIReset);
            _loc1_.addChild(_loc2_);
            this.m_UIFilter = new CustomDataGrid();
            _loc5_ = [];
            _loc6_ = new DataGridColumn();
            _loc6_.headerText = resourceManager.getString(ConfigurationWidget.BUNDLE,"MESSAGE_COLUMN_MODE");
            _loc6_.dataField = "modeName";
            _loc6_.editable = false;
            _loc6_.sortable = false;
            _loc6_.width = 190;
            _loc5_.push(_loc6_);
            _loc6_ = new DataGridColumn();
            _loc6_.headerText = resourceManager.getString(ConfigurationWidget.BUNDLE,"MESSAGE_COLUMN_ONSCREEN");
            _loc6_.dataField = "showOnscreen";
            _loc6_.editable = true;
            _loc6_.editorDataField = "selected";
            _loc6_.itemRenderer = new ClassFactory(CheckBox);
            _loc6_.rendererIsEditor = true;
            _loc6_.sortable = false;
            _loc6_.width = 95;
            _loc6_.setStyle("textAlign","center");
            _loc5_.push(_loc6_);
            _loc6_ = new DataGridColumn();
            _loc6_.headerText = resourceManager.getString(ConfigurationWidget.BUNDLE,"MESSAGE_COLUMN_CHANNEL");
            _loc6_.dataField = "showChannel";
            _loc6_.editable = true;
            _loc6_.editorDataField = "selected";
            _loc6_.itemRenderer = new ClassFactory(CheckBox);
            _loc6_.rendererIsEditor = true;
            _loc6_.sortable = false;
            _loc6_.width = 95;
            _loc6_.setStyle("textAlign","center");
            _loc5_.push(_loc6_);
            _loc6_ = new DataGridColumn();
            _loc6_.headerText = resourceManager.getString(ConfigurationWidget.BUNDLE,"MESSAGE_COLUMN_COLOUR");
            _loc6_.dataField = "textColour";
            _loc6_.editable = true;
            _loc6_.editorDataField = "selectedIndex";
            _loc6_.itemRenderer = new ClassFactory(ColorComboBox);
            _loc6_.rendererIsEditor = true;
            _loc6_.sortable = false;
            _loc6_.width = 110;
            _loc6_.setStyle("textAlign","center");
            _loc5_.push(_loc6_);
            this.m_UIFilter.columns = _loc5_;
            this.m_UIFilter.dataProvider = null;
            this.m_UIFilter.editable = true;
            this.m_UIFilter.draggableColumns = false;
            this.m_UIFilter.percentWidth = 100;
            this.m_UIFilter.percentHeight = 100;
            this.m_UIFilter.resizableColumns = false;
            this.m_UIFilter.sortableColumns = false;
            this.m_UIFilter.styleName = getStyle("messageModeListStyle");
            this.m_UIFilter.addEventListener(DataGridEvent.ITEM_EDIT_END,this.onGridEditEnd);
            this.m_UIFilter.addEventListener(ListEvent.CHANGE,this.onGridSelectionChange);
            _loc1_.addChild(this.m_UIFilter);
            addChild(_loc1_);
            this.m_UIConstructed = true;
         }
      }
      
      public function get options() : OptionsStorage
      {
         return this.m_Options;
      }
      
      private function onValueChange(param1:Event) : void
      {
         var _loc2_:OptionsEditorEvent = new OptionsEditorEvent(OptionsEditorEvent.VALUE_CHANGE);
         dispatchEvent(_loc2_);
      }
      
      protected function createFilterSet(param1:*) : IList
      {
         var _loc7_:MessageFilterSet = null;
         var _loc8_:IList = null;
         var _loc9_:Array = null;
         var _loc2_:Vector.<MessageMode> = new Vector.<MessageMode>();
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:MessageMode = null;
         if(param1 is MessageFilterSet)
         {
            _loc7_ = param1 as MessageFilterSet;
            _loc4_ = MessageMode.MESSAGE_BEYOND_LAST;
            _loc3_ = MessageMode.MESSAGE_NONE;
            while(_loc3_ < _loc4_)
            {
               _loc2_.push(_loc7_.getMessageMode(_loc3_));
               _loc3_++;
            }
         }
         else if(param1 is IList)
         {
            _loc8_ = param1 as IList;
            _loc4_ = _loc8_.length;
            _loc3_ = 0;
            while(_loc3_ < _loc4_)
            {
               if((_loc5_ = _loc8_.getItemAt(_loc3_) as MessageMode) != null)
               {
                  _loc2_.push(_loc5_);
               }
               _loc3_++;
            }
         }
         else if(param1 is Array)
         {
            _loc9_ = param1 as Array;
            _loc4_ = _loc9_.length;
            _loc3_ = 0;
            while(_loc3_ < _loc4_)
            {
               if((_loc5_ = _loc9_[_loc3_] as MessageMode) != null)
               {
                  _loc2_.push(_loc5_);
               }
               _loc3_++;
            }
         }
         else if(param1 is Vector.<MessageMode>)
         {
            _loc2_ = param1 as Vector.<MessageMode>;
         }
         else
         {
            throw new ArgumentError("MessageOptions.createFilterSet: Invalid filter set.");
         }
         var _loc6_:IList = new ArrayCollection();
         _loc4_ = _loc2_.length;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            if((_loc5_ = _loc2_[_loc3_]) != null && _loc5_.editable)
            {
               _loc6_.addItem({
                  "mode":_loc5_.ID,
                  "modeName":_loc5_.toString(),
                  "showOnscreen":_loc5_.showOnscreenMessage,
                  "showChannel":_loc5_.showChannelMessage,
                  "textColour":_loc5_.textColour
               });
            }
            _loc3_++;
         }
         return _loc6_;
      }
      
      public function set options(param1:OptionsStorage) : void
      {
         this.m_Options = param1;
         this.m_UncommittedOptions = true;
         invalidateProperties();
      }
      
      public function set ID(param1:int) : void
      {
         var _loc2_:Object = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         if(this.m_ID != param1)
         {
            _loc2_ = null;
            _loc3_ = -1;
            if(this.m_AvailableFilterSet != null)
            {
               _loc4_ = this.m_AvailableFilterSet.length;
               _loc5_ = 0;
               while(_loc5_ < _loc4_)
               {
                  if((_loc2_ = this.m_AvailableFilterSet.getItemAt(_loc5_)) != null && _loc2_.ID == param1)
                  {
                     _loc3_ = _loc5_;
                     break;
                  }
                  _loc5_++;
               }
            }
            if(_loc3_ < 0)
            {
               throw new ArgumentError("MessageOptions.set ID: Invalid ID.");
            }
            this.m_ID = param1;
            this.m_UncommittedID = true;
            this.m_Index = _loc3_;
            this.m_UncommittedIndex = true;
            this.m_FilterSet = _loc2_.filterSet as IList;
            this.m_UncommittedFilterSet = true;
            this.m_UncommittedSelectedMode = true;
            invalidateDisplayList();
            invalidateProperties();
         }
      }
      
      public function set selectedMode(param1:int) : void
      {
         if(!MessageMode.s_CheckMode(param1))
         {
            throw new ArgumentError("MessageOptions.set selectedMode: Invalid mode.");
         }
         if(this.m_SelectedMode != param1)
         {
            this.m_SelectedMode = param1;
            this.m_UncommittedSelectedMode = true;
            invalidateProperties();
         }
      }
      
      protected function getModeIndex(param1:IList, param2:int) : int
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:Object = null;
         if(param1 != null && MessageMode.s_CheckMode(param2))
         {
            _loc3_ = param1.length;
            _loc4_ = 0;
            while(_loc4_ < _loc3_)
            {
               _loc5_ = param1.getItemAt(_loc4_);
               if(_loc5_ != null && _loc5_.modeID == param2)
               {
                  return _loc4_;
               }
               _loc4_++;
            }
         }
         return -1;
      }
      
      override protected function commitProperties() : void
      {
         var _loc1_:Object = null;
         var _loc2_:Boolean = false;
         var _loc3_:Boolean = false;
         var _loc4_:int = 0;
         super.commitProperties();
         if(this.m_UncommittedOptions)
         {
            this.initaliseFilterSets();
            this.m_UncommittedOptions = false;
         }
         if(this.m_UncommittedID)
         {
            this.m_UncommittedID = false;
         }
         if(this.m_UncommittedIndex)
         {
            _loc1_ = null;
            _loc2_ = false;
            _loc3_ = false;
            if(this.m_Index >= 0 && this.m_Index < this.m_AvailableFilterSet.length)
            {
               _loc1_ = this.m_AvailableFilterSet.getItemAt(this.m_Index);
               _loc2_ = _loc1_.showTimestamps;
               _loc3_ = _loc1_.showLevels;
            }
            if(this.m_UIShowTimestamps != null)
            {
               this.m_UIShowTimestamps.selected = _loc2_;
            }
            if(this.m_UIShowLevels != null)
            {
               this.m_UIShowLevels.selected = _loc3_;
            }
            this.m_UncommittedIndex = false;
         }
         if(this.m_UncommittedSelectedMode)
         {
            _loc4_ = this.getModeIndex(this.m_FilterSet,this.m_SelectedMode);
            if(_loc4_ > -1 && this.m_UIFilter != null)
            {
               this.m_UIFilter.selectedIndex = _loc4_;
               this.m_UIFilter.scrollToIndex(_loc4_);
            }
            this.m_UncommittedSelectedMode = false;
         }
         if(this.m_UncommittedFilterSet)
         {
            if(this.m_UIFilter != null)
            {
               this.m_UIFilter.dataProvider = this.m_FilterSet;
            }
            this.m_UncommittedFilterSet = false;
         }
      }
      
      protected function onCreationComplete(param1:FlexEvent) : void
      {
         if(param1 != null)
         {
            removeEventListener(FlexEvent.CREATION_COMPLETE,this.onCreationComplete);
            if(this.m_SelectedMode != MessageMode.MESSAGE_NONE)
            {
               this.m_UncommittedSelectedMode = true;
               invalidateProperties();
            }
         }
      }
      
      protected function saveFilterSet(param1:IList, param2:MessageFilterSet) : void
      {
         var _loc5_:Object = null;
         var _loc6_:MessageMode = null;
         var _loc3_:int = param1.length;
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = param1.getItemAt(_loc4_);
            _loc6_ = param2.getMessageMode(_loc5_.mode);
            _loc6_.showOnscreenMessage = _loc5_.showOnscreen;
            _loc6_.showChannelMessage = _loc5_.showChannel;
            _loc6_.textColour = _loc5_.textColour;
            _loc4_++;
         }
      }
      
      protected function onGridSelectionChange(param1:ListEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Object = null;
         if(param1 != null)
         {
            _loc2_ = this.m_UIFilter.selectedIndex;
            _loc3_ = null;
            if(_loc2_ > -1 && this.m_FilterSet != null && (_loc3_ = this.m_FilterSet.getItemAt(_loc2_)) != null)
            {
               this.m_SelectedMode = int(_loc3_.modeID);
            }
            else
            {
               this.m_SelectedMode = MessageMode.MESSAGE_NONE;
            }
         }
      }
      
      public function get selectedMode() : int
      {
         return this.m_SelectedMode;
      }
      
      protected function initaliseFilterSets() : void
      {
         var _loc1_:Array = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:MessageFilterSet = null;
         var _loc5_:Object = null;
         this.m_AvailableFilterSet.removeAll();
         this.m_DeletedFilterSet.removeAll();
         if(this.m_Options != null)
         {
            this.m_ID = MessageFilterSet.DEFAULT_SET;
            this.m_Index = -1;
            this.m_FilterSet = null;
            _loc1_ = this.m_Options.getMessageFilterSetIDs();
            _loc2_ = _loc1_.length;
            _loc3_ = 0;
            while(_loc3_ < _loc2_)
            {
               _loc4_ = this.m_Options.getMessageFilterSet(_loc1_[_loc3_]);
               _loc5_ = {
                  "ID":_loc4_.ID,
                  "name":resourceManager.getString(ConfigurationWidget.BUNDLE,"MESSAGE_DEFAULT_SET_NAME",[_loc4_.ID + 1]),
                  "filterSet":this.createFilterSet(_loc4_),
                  "showTimestamps":_loc4_.showTimestamps,
                  "showLevels":_loc4_.showLevels,
                  "dirty":false
               };
               this.m_AvailableFilterSet.addItem(_loc5_);
               if(this.m_ID == _loc4_.ID)
               {
                  this.m_Index = _loc3_;
                  this.m_FilterSet = _loc5_.filterSet as IList;
               }
               _loc3_++;
            }
         }
         this.m_UncommittedID = true;
         this.m_UncommittedIndex = true;
         this.m_UncommittedFilterSet = true;
         this.m_UncommittedSelectedMode = true;
         invalidateDisplayList();
         invalidateProperties();
      }
      
      protected function onConfirmReset(param1:CloseEvent) : void
      {
         var _loc2_:OptionsEditorEvent = null;
         if(param1.detail == EmbeddedDialog.YES)
         {
            this.m_Options.resetMessageFilterSet();
            this.m_UncommittedOptions = true;
            invalidateProperties();
            _loc2_ = new OptionsEditorEvent(OptionsEditorEvent.VALUE_CHANGE);
            dispatchEvent(_loc2_);
         }
      }
      
      protected function onGridEditEnd(param1:DataGridEvent) : void
      {
         var _loc2_:OptionsEditorEvent = null;
         if(param1 != null && param1.reason != DataGridEventReason.CANCELLED)
         {
            this.m_AvailableFilterSet.getItemAt(this.m_Index).dirty = true;
            _loc2_ = new OptionsEditorEvent(OptionsEditorEvent.VALUE_CHANGE);
            dispatchEvent(_loc2_);
         }
      }
      
      public function close(param1:Boolean = false) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         var _loc5_:MessageFilterSet = null;
         if(this.m_Options != null && param1 && this.m_UncommittedValues)
         {
            _loc2_ = 0;
            _loc3_ = 0;
            _loc3_ = this.m_DeletedFilterSet.length;
            _loc2_ = 0;
            while(_loc2_ < _loc3_)
            {
               this.m_Options.removeMessageFilterSet(this.m_DeletedFilterSet.getItemAt(_loc2_).ID);
               _loc2_++;
            }
            _loc3_ = this.m_AvailableFilterSet.length;
            _loc2_ = 0;
            while(_loc2_ < _loc3_)
            {
               _loc4_ = this.m_AvailableFilterSet.getItemAt(_loc2_);
               if(_loc4_.dirty)
               {
                  _loc5_ = new MessageFilterSet(_loc4_.ID);
                  _loc5_.showTimestamps = _loc4_.showTimestamps;
                  _loc5_.showLevels = _loc4_.showLevels;
                  this.saveFilterSet(_loc4_.filterSet,_loc5_);
                  this.m_Options.addMessageFilterSet(_loc5_);
               }
               _loc2_++;
            }
            this.m_UncommittedValues = false;
         }
      }
      
      protected function onCheckBoxChange(param1:Event) : void
      {
         var _loc3_:OptionsEditorEvent = null;
         var _loc2_:Object = null;
         if(this.m_Index >= 0 && this.m_Index < this.m_AvailableFilterSet.length && (_loc2_ = this.m_AvailableFilterSet.getItemAt(this.m_Index)) != null && param1 != null)
         {
            switch(param1.currentTarget)
            {
               case this.m_UIShowTimestamps:
                  _loc2_.showTimestamps = this.m_UIShowTimestamps.selected;
                  _loc2_.dirty = true;
                  break;
               case this.m_UIShowLevels:
                  _loc2_.showLevels = this.m_UIShowLevels.selected;
                  _loc2_.dirty = true;
            }
            _loc3_ = new OptionsEditorEvent(OptionsEditorEvent.VALUE_CHANGE);
            dispatchEvent(_loc3_);
         }
      }
   }
}
