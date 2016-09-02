package tibia.options.configurationWidgetClasses
{
   import mx.containers.VBox;
   import flash.events.Event;
   import tibia.input.mapping.MouseMapping;
   import mx.controls.CheckBox;
   import tibia.input.mapping.MouseBinding;
   import flash.utils.Dictionary;
   import tibia.options.ConfigurationWidget;
   import mx.controls.DataGrid;
   import mx.events.DataGridEvent;
   import mx.events.DataGridEventReason;
   import mx.containers.Form;
   import mx.controls.dataGridClasses.DataGridColumn;
   import mx.containers.FormItem;
   import mx.core.ClassFactory;
   import mx.styles.StyleManager;
   import mx.controls.ComboBox;
   import shared.controls.CustomList;
   import mx.events.DropdownEvent;
   import mx.events.ListEvent;
   import shared.controls.CustomDataGrid;
   import mx.collections.IList;
   import tibia.options.OptionsStorage;
   import mx.events.FlexEvent;
   import mx.core.ScrollPolicy;
   import mx.collections.ArrayCollection;
   
   public class MouseControlOptions extends VBox implements IOptionsEditor
   {
      
      private static const ACTION_UNSET:int = -1;
      
      private static const MOUSE_BUTTON_LEFT:int = 1;
      
      private static const MOUSE_BUTTON_BOTH:int = 4;
      
      protected static const OWN_MOUSE_CONTROL_TYPES:Array = [{
         "value":MOUSE_CONTROL_PRESET_SMART_LEFT_CLICK,
         "label":"MOUSE_CONTROL_PRESET_LEFT_SMART_CLICK"
      },{
         "value":MOUSE_CONTROL_PRESET_SMART_RIGHT_CLICK,
         "label":"MOUSE_CONTROL_PRESET_RIGHT_SMART_CLICK"
      },{
         "value":MOUSE_CONTROL_PRESET_KEYMODIFIED_LEFT_CLICK,
         "label":"MOUSE_CONTROL_PRESET_KEYMODIFIED_LEFT_CLICK"
      },{
         "value":MOUSE_CONTROL_PRESET_CUSTOM,
         "label":"MOUSE_CONTROL_PRESET_CUSTOM"
      }];
      
      private static const ACTION_USE_OR_OPEN:int = 101;
      
      private static const ACTION_SMARTCLICK:int = 100;
      
      private static const MOUSE_BUTTON_RIGHT:int = 2;
      
      private static const ACTION_LOOK:int = 6;
      
      private static const ACTION_TALK:int = 9;
      
      protected static const ACTION_TYPES_SORT_ORDER:Array = [ACTION_NONE,ACTION_SMARTCLICK,ACTION_ATTACK_OR_TALK,ACTION_USE_OR_OPEN,ACTION_AUTOWALK,ACTION_LOOK,ACTION_CONTEXT_MENU];
      
      private static const ACTION_USE:int = 7;
      
      private static const MOUSE_BUTTON_MIDDLE:int = 3;
      
      private static const ACTION_NONE:int = 0;
      
      private static const MOUSE_CONTROL_PRESET_CUSTOM:uint = 3;
      
      private static const ACTION_AUTOWALK:int = 3;
      
      private static const MOUSE_CONTROL_PRESET_SMART_RIGHT_CLICK:uint = 1;
      
      private static const ACTION_ATTACK:int = 1;
      
      private static const MOUSE_CONTROL_PRESET_KEYMODIFIED_LEFT_CLICK:uint = 2;
      
      private static const ACTION_OPEN:int = 8;
      
      private static const ACTION_AUTOWALK_HIGHLIGHT:int = 4;
      
      private static const ACTION_CONTEXT_MENU:int = 5;
      
      private static const MOUSE_CONTROL_PRESET_SMART_LEFT_CLICK:uint = 0;
      
      private static const ACTION_ATTACK_OR_TALK:int = 102;
       
      
      private var m_UncommittedMouseBindings:Boolean = false;
      
      protected var m_UIShowMousecursorForAction:CheckBox = null;
      
      private var m_UncommittedOptions:Boolean = false;
      
      private var m_UncommittedShowMouseCursorForAction:Boolean = false;
      
      private var m_UncommittedValues:Boolean = true;
      
      protected var m_UIMouseBindings:DataGrid = null;
      
      protected var m_MouseBindings:IList = null;
      
      protected var m_Options:OptionsStorage = null;
      
      private var m_UIConstructed:Boolean = false;
      
      protected var m_UIInputMouseControlType:ComboBox = null;
      
      public function MouseControlOptions()
      {
         super();
         label = resourceManager.getString(ConfigurationWidget.BUNDLE,"MOUSE_LABEL");
         horizontalScrollPolicy = ScrollPolicy.OFF;
         verticalScrollPolicy = ScrollPolicy.OFF;
         this.m_MouseBindings = new ArrayCollection();
         addEventListener(FlexEvent.CREATION_COMPLETE,this.onCreationComplete);
      }
      
      protected function onComboBoxChange(param1:Event) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Object = null;
         if(param1 != null)
         {
            _loc2_ = -1;
            _loc3_ = null;
            switch(param1.currentTarget)
            {
               case this.m_UIInputMouseControlType:
                  _loc2_ = this.m_UIInputMouseControlType.selectedIndex;
                  if(_loc2_ >= 0 && _loc2_ < OWN_MOUSE_CONTROL_TYPES.length)
                  {
                     switch(OWN_MOUSE_CONTROL_TYPES[_loc2_].value)
                     {
                        case MOUSE_CONTROL_PRESET_SMART_LEFT_CLICK:
                           this.initaliseMouseBindings(MouseMapping.PRESET_SMART_LEFT_CLICK);
                           break;
                        case MOUSE_CONTROL_PRESET_SMART_RIGHT_CLICK:
                           this.initaliseMouseBindings(MouseMapping.PRESET_SMART_RIGHT_CLICK);
                           break;
                        case MOUSE_CONTROL_PRESET_KEYMODIFIED_LEFT_CLICK:
                           this.initaliseMouseBindings(MouseMapping.PRESET_KEYMODIFIED_LEFT_CLICK);
                           break;
                        case MOUSE_CONTROL_PRESET_CUSTOM:
                           this.initaliseMouseBindings(this.m_Options.mouseMapping);
                     }
                     this.m_UncommittedMouseBindings = true;
                     invalidateProperties();
                  }
            }
         }
      }
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
         if(this.m_UncommittedOptions)
         {
            this.initaliseMouseBindings(this.m_Options.mouseMapping);
            this.m_UncommittedOptions = false;
         }
         if(this.m_UncommittedShowMouseCursorForAction)
         {
            this.m_UIShowMousecursorForAction.selected = this.m_Options.mouseMapping.showMouseCursorForAction;
            this.m_UncommittedShowMouseCursorForAction = false;
         }
         if(this.m_UncommittedMouseBindings)
         {
            if(this.m_MouseBindings != null)
            {
               this.m_UIMouseBindings.dataProvider = this.m_MouseBindings;
               this.determinePreset();
            }
            this.m_UncommittedMouseBindings = false;
         }
      }
      
      private function gridRowToMouseBinding(param1:Object) : MouseBinding
      {
         var _loc2_:MouseBinding = new MouseBinding(param1.mouseButton,param1.modifierKey,param1.action);
         return _loc2_;
      }
      
      private function MouseBindingLocalisedLabelFunction(param1:Object) : String
      {
         var _loc2_:Dictionary = new Dictionary();
         _loc2_[ACTION_NONE] = "MOUSE_CONTROL_ACTION_NONE";
         _loc2_[ACTION_SMARTCLICK] = "MOUSE_CONTROL_ACTION_SMARTCLICK";
         _loc2_[ACTION_ATTACK_OR_TALK] = "MOUSE_CONTROL_ACTION_ATTACK_OR_TALK";
         _loc2_[ACTION_USE_OR_OPEN] = "MOUSE_CONTROL_ACTION_USE_OR_OPEN";
         _loc2_[ACTION_AUTOWALK] = "MOUSE_CONTROL_ACTION_AUTOWALK";
         _loc2_[ACTION_LOOK] = "MOUSE_CONTROL_ACTION_LOOK";
         _loc2_[ACTION_CONTEXT_MENU] = "MOUSE_CONTROL_ACTION_CONTEXT_MENU";
         var _loc3_:uint = param1 as uint;
         if(_loc3_ in _loc2_)
         {
            return resourceManager.getString(ConfigurationWidget.BUNDLE,_loc2_[_loc3_]);
         }
         return resourceManager.getString(ConfigurationWidget.BUNDLE,"MOUSE_CONTROL_ACTION_NONE");
      }
      
      protected function onGridEditEnd(param1:DataGridEvent) : void
      {
         var _loc2_:OptionsEditorEvent = null;
         if(param1 != null && param1.reason != DataGridEventReason.CANCELLED)
         {
            this.writeBackMouseBindings();
            _loc2_ = new OptionsEditorEvent(OptionsEditorEvent.VALUE_CHANGE);
            dispatchEvent(_loc2_);
            this.determinePreset();
         }
      }
      
      override protected function createChildren() : void
      {
         var LocalisedLabelFunction:Function = null;
         var Root:VBox = null;
         var Head:VBox = null;
         var Frm:Form = null;
         var Item:FormItem = null;
         var TextColor:* = undefined;
         var Column:Array = null;
         var Col:DataGridColumn = null;
         var ComboBoxClassFactory:ClassFactory = null;
         if(!this.m_UIConstructed)
         {
            super.createChildren();
            LocalisedLabelFunction = function(param1:Object):String
            {
               if(param1.hasOwnProperty("label"))
               {
                  return resourceManager.getString(ConfigurationWidget.BUNDLE,param1.label);
               }
               return String(param1);
            };
            Root = new VBox();
            Root.percentHeight = 100;
            Root.percentWidth = 100;
            Root.styleName = "optionsConfigurationWidgetRootContainer";
            Head = new VBox();
            Head.percentHeight = NaN;
            Head.percentWidth = 100;
            Head.setStyle("horizontalAlgin","center");
            Head.setStyle("verticalAlign","middle");
            Frm = new Form();
            Frm.percentHeight = NaN;
            Frm.percentWidth = 100;
            Frm.setStyle("paddingBottom",2);
            Frm.setStyle("paddingTop",2);
            Item = new FormItem();
            Item.label = resourceManager.getString(ConfigurationWidget.BUNDLE,"MOUSE_CONTROL_SHOW_ACTION_MOUSE_CURSOR");
            Item.percentHeight = NaN;
            Item.percentWidth = 100;
            this.m_UIShowMousecursorForAction = new CheckBox();
            this.m_UIShowMousecursorForAction.addEventListener(Event.CHANGE,this.onCheckBoxChange);
            this.m_UIShowMousecursorForAction.addEventListener(Event.CHANGE,this.onValueChange);
            this.m_UIShowMousecursorForAction.label = resourceManager.getString(ConfigurationWidget.BUNDLE,"MOUSE_CONTROL_SHOW_ACTION_MOUSE_CURSOR_DESCRIPTION");
            TextColor = StyleManager.getStyleDeclaration("TextItem").getStyle("textColor");
            this.m_UIShowMousecursorForAction.setStyle("color",TextColor);
            this.m_UIShowMousecursorForAction.setStyle("textRollOverColor",TextColor);
            Item.addChild(this.m_UIShowMousecursorForAction);
            Frm.addChild(Item);
            Head.addChild(Frm);
            Frm = new Form();
            Frm.percentHeight = NaN;
            Frm.percentWidth = 100;
            Frm.setStyle("paddingBottom",2);
            Frm.setStyle("paddingTop",2);
            Item = new FormItem();
            Item.label = resourceManager.getString(ConfigurationWidget.BUNDLE,"MOUSE_CONTROL_PRESETS");
            Item.percentHeight = NaN;
            Item.percentWidth = 100;
            this.m_UIInputMouseControlType = new ComboBox();
            this.m_UIInputMouseControlType.dataProvider = OWN_MOUSE_CONTROL_TYPES;
            this.m_UIInputMouseControlType.dropdownFactory = new ClassFactory(CustomList);
            this.m_UIInputMouseControlType.labelField = "label";
            this.m_UIInputMouseControlType.labelFunction = LocalisedLabelFunction;
            this.m_UIInputMouseControlType.addEventListener(DropdownEvent.CLOSE,this.onComboBoxChange);
            this.m_UIInputMouseControlType.addEventListener(ListEvent.CHANGE,this.onComboBoxChange);
            this.m_UIInputMouseControlType.addEventListener(ListEvent.CHANGE,this.onValueChange);
            Item.addChild(this.m_UIInputMouseControlType);
            Frm.addChild(Item);
            Head.addChild(Frm);
            Root.addChild(Head);
            this.m_UIMouseBindings = new CustomDataGrid();
            Column = [];
            Col = new DataGridColumn();
            Col.headerText = resourceManager.getString(ConfigurationWidget.BUNDLE,"MOUSE_CONTROL_COLUMN_MOUSE_BUTTON");
            Col.dataField = "mouseButtonWithModifier";
            Col.editable = false;
            Col.sortable = false;
            Col.width = 190;
            Column.push(Col);
            ComboBoxClassFactory = new ClassFactory(ComboBox);
            ComboBoxClassFactory.properties = {
               "dataProvider":ACTION_TYPES_SORT_ORDER,
               "labelFunction":this.MouseBindingLocalisedLabelFunction
            };
            Col = new DataGridColumn();
            Col.headerText = resourceManager.getString(ConfigurationWidget.BUNDLE,"MOUSE_CONTROL_COLUMN_ACTION");
            Col.dataField = "action";
            Col.editable = true;
            Col.editorDataField = "value";
            Col.itemRenderer = ComboBoxClassFactory;
            Col.rendererIsEditor = true;
            Col.sortable = false;
            Col.width = 110;
            Col.setStyle("textAlign","center");
            Column.push(Col);
            this.m_UIMouseBindings.columns = Column;
            this.m_UIMouseBindings.dataProvider = null;
            this.m_UIMouseBindings.editable = true;
            this.m_UIMouseBindings.draggableColumns = false;
            this.m_UIMouseBindings.percentWidth = 100;
            this.m_UIMouseBindings.percentHeight = 100;
            this.m_UIMouseBindings.resizableColumns = false;
            this.m_UIMouseBindings.sortableColumns = false;
            this.m_UIMouseBindings.styleName = getStyle("mouseControlOptionsListStyle");
            this.m_UIMouseBindings.addEventListener(DataGridEvent.ITEM_EDIT_END,this.onGridEditEnd,false,-100);
            Root.addChild(this.m_UIMouseBindings);
            addChild(Root);
            this.m_UIConstructed = true;
         }
      }
      
      private function writeBackMouseBindings() : void
      {
         var _loc1_:Object = null;
         var _loc2_:MouseBinding = null;
         for each(_loc1_ in this.m_MouseBindings)
         {
            _loc2_ = this.gridRowToMouseBinding(_loc1_);
            this.m_Options.mouseMapping.setBinding(_loc2_);
         }
      }
      
      public function get options() : OptionsStorage
      {
         return this.m_Options;
      }
      
      private function determinePreset() : void
      {
         var _loc2_:Object = null;
         var _loc3_:MouseBinding = null;
         var _loc1_:MouseMapping = new MouseMapping();
         for each(_loc2_ in this.m_MouseBindings)
         {
            _loc3_ = this.gridRowToMouseBinding(_loc2_);
            _loc1_.setBinding(_loc3_);
         }
         if(_loc1_.equals(MouseMapping.PRESET_SMART_LEFT_CLICK))
         {
            this.m_UIInputMouseControlType.selectedIndex = MOUSE_CONTROL_PRESET_SMART_LEFT_CLICK;
         }
         else if(_loc1_.equals(MouseMapping.PRESET_SMART_RIGHT_CLICK))
         {
            this.m_UIInputMouseControlType.selectedIndex = MOUSE_CONTROL_PRESET_SMART_RIGHT_CLICK;
         }
         else if(_loc1_.equals(MouseMapping.PRESET_KEYMODIFIED_LEFT_CLICK))
         {
            this.m_UIInputMouseControlType.selectedIndex = MOUSE_CONTROL_PRESET_KEYMODIFIED_LEFT_CLICK;
         }
         else
         {
            this.m_UIInputMouseControlType.selectedIndex = MOUSE_CONTROL_PRESET_CUSTOM;
         }
      }
      
      protected function initaliseMouseBindings(param1:MouseMapping) : void
      {
         var _loc2_:MouseBinding = null;
         var _loc3_:String = null;
         this.m_MouseBindings.removeAll();
         if(param1 != null)
         {
            for each(_loc2_ in param1.mouseBindings)
            {
               _loc3_ = _loc2_.toString();
               this.m_MouseBindings.addItem({
                  "mouseButton":_loc2_.mouseButton,
                  "modifierKey":_loc2_.modifierKey,
                  "mouseButtonWithModifier":_loc3_,
                  "action":_loc2_.action
               });
            }
         }
         this.m_UncommittedShowMouseCursorForAction = true;
         this.m_UncommittedMouseBindings = true;
         invalidateDisplayList();
         invalidateProperties();
      }
      
      protected function onCheckBoxChange(param1:Event) : void
      {
         switch(param1.currentTarget)
         {
            case this.m_UIShowMousecursorForAction:
               this.m_Options.mouseMapping.showMouseCursorForAction = this.m_UIShowMousecursorForAction.selected;
               this.m_UncommittedShowMouseCursorForAction = true;
         }
         var _loc2_:OptionsEditorEvent = new OptionsEditorEvent(OptionsEditorEvent.VALUE_CHANGE);
         dispatchEvent(_loc2_);
      }
      
      protected function onCreationComplete(param1:FlexEvent) : void
      {
         if(param1 != null)
         {
            removeEventListener(FlexEvent.CREATION_COMPLETE,this.onCreationComplete);
         }
      }
      
      public function close(param1:Boolean = false) : void
      {
         if(this.m_Options != null && param1 && this.m_UncommittedValues)
         {
            this.writeBackMouseBindings();
            this.m_Options.mouseMapping.showMouseCursorForAction = this.m_UIShowMousecursorForAction.selected;
            this.m_UncommittedValues = false;
         }
      }
      
      private function onValueChange(param1:Event) : void
      {
         var _loc2_:OptionsEditorEvent = new OptionsEditorEvent(OptionsEditorEvent.VALUE_CHANGE);
         dispatchEvent(_loc2_);
      }
      
      public function set options(param1:OptionsStorage) : void
      {
         this.m_Options = param1;
         this.m_UncommittedOptions = true;
         invalidateProperties();
      }
   }
}
