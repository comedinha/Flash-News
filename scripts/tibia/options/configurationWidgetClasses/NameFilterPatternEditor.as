package tibia.options.configurationWidgetClasses
{
   import mx.containers.HBox;
   import mx.controls.listClasses.IDropInListItemRenderer;
   import mx.managers.IFocusManagerComponent;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.ui.Keyboard;
   import flash.events.TextEvent;
   import shared.utility.StringHelper;
   import tibia.options.ConfigurationWidget;
   import tibia.options.ns_options_internal;
   import mx.controls.listClasses.BaseListData;
   import mx.controls.dataGridClasses.DataGridListData;
   import mx.events.DataGridEvent;
   import mx.events.ListEvent;
   import mx.controls.listClasses.ListData;
   import mx.controls.List;
   import mx.events.ListEventReason;
   import mx.controls.Tree;
   import mx.controls.DataGrid;
   import mx.events.DataGridEventReason;
   import mx.controls.TextInput;
   
   public class NameFilterPatternEditor extends HBox implements IDropInListItemRenderer, IFocusManagerComponent
   {
       
      
      private var m_UncommittedListData:Boolean = false;
      
      private var m_UncommittedData:Boolean = false;
      
      private var m_UncommittedText:Boolean = false;
      
      protected var m_Text:String = null;
      
      protected var m_ListData:BaseListData = null;
      
      private var m_UIConstructed:Boolean = false;
      
      protected var m_UIText:TextInput = null;
      
      public function NameFilterPatternEditor()
      {
         super();
         setStyle("borderSkin",null);
         setStyle("borderStyle","none");
         setStyle("horizontalAlign","left");
         setStyle("verticalAlign","middle");
      }
      
      protected function onTextInput(param1:Event) : void
      {
         var _loc2_:String = null;
         if(param1 != null)
         {
            _loc2_ = null;
            if(param1 is KeyboardEvent && param1.type == KeyboardEvent.KEY_DOWN && KeyboardEvent(param1).keyCode == Keyboard.ENTER)
            {
               param1.preventDefault();
               param1.stopImmediatePropagation();
               this.finishEditText();
            }
            else if(param1 is KeyboardEvent)
            {
               _loc2_ = String.fromCharCode(KeyboardEvent(param1).charCode);
            }
            else if(param1 is TextEvent)
            {
               _loc2_ = TextEvent(param1).text;
            }
            if(this.m_UIText.selectionBeginIndex == 0 && (_loc2_ == null || _loc2_.length < 1 || StringHelper.s_IsWhitsepace(_loc2_)))
            {
               param1.preventDefault();
               param1.stopImmediatePropagation();
            }
         }
      }
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
         if(this.m_UncommittedData)
         {
            this.startEditText();
            this.m_UncommittedData = false;
         }
         if(this.m_UncommittedListData)
         {
            this.startEditText();
            this.m_UncommittedListData = false;
         }
         if(this.m_UncommittedText)
         {
            if(this.m_Text != null)
            {
               this.m_UIText.text = this.m_Text;
            }
            else
            {
               this.m_UIText.text = resourceManager.getString(ConfigurationWidget.ns_options_internal::BUNDLE,"IGNORE_FILTEREDITOR_LBL_EMPTY_PATTERN");
            }
            this.m_UncommittedText = false;
         }
      }
      
      public function set listData(param1:BaseListData) : void
      {
         if(this.m_ListData != param1)
         {
            this.m_ListData = param1;
            this.m_UncommittedListData = true;
            invalidateProperties();
         }
      }
      
      private function finishEditText() : void
      {
         var _loc2_:DataGridListData = null;
         var _loc3_:DataGridEvent = null;
         var _loc1_:ListEvent = null;
         if(this.m_ListData is ListData && owner is List)
         {
            _loc1_ = new ListEvent(ListEvent.ITEM_EDIT_END,false,true);
            _loc1_.columnIndex = this.m_ListData.columnIndex;
            _loc1_.rowIndex = this.m_ListData.rowIndex;
            _loc1_.reason = ListEventReason.NEW_ROW;
            _loc1_.itemRenderer = this;
            owner.dispatchEvent(_loc1_);
         }
         else if(this.m_ListData is ListData && owner is Tree)
         {
            _loc1_ = new ListEvent(ListEvent.ITEM_EDIT_END,false,true);
            _loc1_.columnIndex = this.m_ListData.columnIndex;
            _loc1_.rowIndex = this.m_ListData.rowIndex;
            _loc1_.reason = ListEventReason.NEW_ROW;
            _loc1_.itemRenderer = this;
            owner.dispatchEvent(_loc1_);
         }
         else if(this.m_ListData is DataGridListData && owner is DataGrid)
         {
            _loc2_ = this.m_ListData as DataGridListData;
            _loc3_ = new DataGridEvent(DataGridEvent.ITEM_EDIT_END,false,true);
            _loc3_.columnIndex = _loc2_.columnIndex;
            _loc3_.dataField = _loc2_.dataField;
            _loc3_.rowIndex = _loc2_.rowIndex;
            _loc3_.reason = DataGridEventReason.NEW_ROW;
            _loc3_.itemRenderer = this;
            owner.dispatchEvent(_loc3_);
         }
      }
      
      override public function set data(param1:Object) : void
      {
         if(super.data != param1)
         {
            super.data = param1;
            this.m_UncommittedData = true;
            invalidateProperties();
         }
      }
      
      public function set text(param1:String) : void
      {
         if(this.m_Text == null || this.m_Text != param1)
         {
            this.m_Text = param1;
            this.m_UncommittedText = true;
            invalidateProperties();
         }
      }
      
      override public function setFocus() : void
      {
         if(this.m_UIText != null)
         {
            this.m_UIText.setFocus();
            if(this.text == null)
            {
               this.m_UIText.setSelection(0,2147483647);
            }
         }
         else
         {
            super.setFocus();
         }
      }
      
      override protected function createChildren() : void
      {
         if(!this.m_UIConstructed)
         {
            super.createChildren();
            this.m_UIText = new TextInput();
            this.m_UIText.percentHeight = NaN;
            this.m_UIText.percentWidth = 100;
            this.m_UIText.addEventListener(KeyboardEvent.KEY_DOWN,this.onTextInput);
            this.m_UIText.addEventListener(TextEvent.TEXT_INPUT,this.onTextInput);
            this.m_UIText.setStyle("borderSkin",null);
            this.m_UIText.setStyle("borderStyle","none");
            addChild(this.m_UIText);
         }
      }
      
      public function get listData() : BaseListData
      {
         return this.m_ListData;
      }
      
      public function get text() : String
      {
         var _loc1_:String = this.m_Text;
         var _loc2_:String = this.m_UIText != null?StringHelper.s_Trim(this.m_UIText.text):null;
         if(_loc2_ == null || _loc2_.length < 1)
         {
            return null;
         }
         if(_loc1_ == null && _loc2_ == resourceManager.getString(ConfigurationWidget.ns_options_internal::BUNDLE,"IGNORE_FILTEREDITOR_LBL_EMPTY_PATTERN"))
         {
            return null;
         }
         return _loc2_;
      }
      
      private function startEditText() : void
      {
         var _loc3_:String = null;
         var _loc1_:Object = super.data;
         var _loc2_:String = null;
         if(_loc1_ is String)
         {
            _loc2_ = String(_loc1_);
         }
         else if(this.m_ListData is DataGridListData)
         {
            _loc3_ = DataGridListData(this.m_ListData).dataField;
            if(_loc1_ != null && _loc1_.hasOwnProperty(_loc3_))
            {
               _loc2_ = _loc1_[_loc3_] as String;
            }
         }
         this.text = _loc2_;
      }
   }
}
