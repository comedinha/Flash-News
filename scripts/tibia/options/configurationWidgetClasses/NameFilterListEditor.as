package tibia.options.configurationWidgetClasses
{
   import mx.containers.VBox;
   import mx.controls.DataGrid;
   import mx.events.DataGridEvent;
   import mx.events.DataGridEventReason;
   import mx.controls.Button;
   import mx.controls.dataGridClasses.DataGridColumn;
   import mx.containers.HBox;
   import mx.controls.Spacer;
   import shared.controls.CustomDataGrid;
   import tibia.options.ConfigurationWidget;
   import mx.core.ClassFactory;
   import mx.controls.CheckBox;
   import shared.controls.CustomButton;
   import flash.events.MouseEvent;
   import mx.collections.IList;
   import tibia.chat.NameFilterItem;
   import mx.collections.ArrayCollection;
   
   public class NameFilterListEditor extends VBox
   {
       
      
      protected var m_UIList:DataGrid = null;
      
      protected var m_UIButtonAdd:Button = null;
      
      protected var m_DataProvider:IList = null;
      
      private var m_UIConstructed:Boolean = false;
      
      protected var m_UIButtonDel:Button = null;
      
      public function NameFilterListEditor()
      {
         super();
      }
      
      override public function set enabled(param1:Boolean) : void
      {
         super.enabled = param1;
         if(this.m_UIList != null)
         {
            this.m_UIList.enabled = param1;
         }
         if(this.m_UIButtonAdd != null)
         {
            this.m_UIButtonAdd.enabled = param1;
         }
         if(this.m_UIButtonDel != null)
         {
            this.m_UIButtonDel.enabled = param1;
         }
      }
      
      protected function onListEdit(param1:DataGridEvent) : void
      {
         var _loc2_:NameFilterPatternEditor = null;
         var _loc3_:OptionsEditorEvent = null;
         if(param1 != null && this.m_DataProvider != null)
         {
            switch(param1.type)
            {
               case DataGridEvent.ITEM_EDIT_BEGIN:
                  break;
               case DataGridEvent.ITEM_EDIT_END:
                  if(param1.columnIndex == 1 && (param1.reason == DataGridEventReason.CANCELLED || param1.reason == DataGridEventReason.NEW_ROW || param1.reason == DataGridEventReason.OTHER))
                  {
                     _loc2_ = NameFilterPatternEditor(this.m_UIList.itemEditorInstance);
                     if(_loc2_ == null)
                     {
                        _loc2_ = NameFilterPatternEditor(param1.itemRenderer);
                     }
                     if(_loc2_ != null && _loc2_.text == null)
                     {
                        param1.preventDefault();
                        this.m_UIList.editedItemPosition = null;
                        this.m_UIList.destroyItemEditor();
                        this.removeItem(param1.rowIndex);
                     }
                  }
                  if(param1.reason != DataGridEventReason.CANCELLED)
                  {
                     _loc3_ = new OptionsEditorEvent(OptionsEditorEvent.VALUE_CHANGE);
                     dispatchEvent(_loc3_);
                  }
            }
         }
      }
      
      override protected function createChildren() : void
      {
         var _loc1_:DataGridColumn = null;
         var _loc2_:DataGridColumn = null;
         var _loc3_:HBox = null;
         var _loc4_:Spacer = null;
         if(!this.m_UIConstructed)
         {
            super.createChildren();
            this.m_UIList = new CustomDataGrid();
            _loc1_ = new DataGridColumn();
            _loc1_.dataField = "permanent";
            _loc1_.editable = true;
            _loc1_.editorDataField = "selected";
            _loc1_.headerText = resourceManager.getString(ConfigurationWidget.BUNDLE,"IGNORE_FILTEREDITOR_LBL_PERMANENT_COLUMN");
            _loc1_.itemRenderer = new ClassFactory(CheckBox);
            _loc1_.rendererIsEditor = true;
            _loc1_.width = 50;
            _loc1_.setStyle("textAlign","center");
            _loc2_ = new DataGridColumn();
            _loc2_.dataField = "pattern";
            _loc2_.editable = true;
            _loc2_.editorDataField = "text";
            _loc2_.headerText = resourceManager.getString(ConfigurationWidget.BUNDLE,"IGNORE_FILTEREDITOR_LBL_PATTERN_COLUMN");
            _loc2_.itemRenderer = new ClassFactory(NameFilterPatternEditor);
            _loc2_.rendererIsEditor = true;
            _loc2_.sortable = true;
            _loc2_.width = NaN;
            this.m_UIList.columns = [_loc1_,_loc2_];
            this.m_UIList.dataProvider = this.m_DataProvider;
            this.m_UIList.draggableColumns = false;
            this.m_UIList.editable = true;
            this.m_UIList.enabled = enabled;
            this.m_UIList.percentHeight = 100;
            this.m_UIList.percentWidth = 100;
            this.m_UIList.resizableColumns = false;
            this.m_UIList.sortableColumns = false;
            this.m_UIList.styleName = getStyle("nameFilterListStyle");
            this.m_UIList.addEventListener(DataGridEvent.ITEM_EDIT_BEGIN,this.onListEdit);
            this.m_UIList.addEventListener(DataGridEvent.ITEM_EDIT_END,this.onListEdit);
            addChild(this.m_UIList);
            _loc3_ = new HBox();
            _loc3_.percentHeight = NaN;
            _loc3_.percentWidth = 100;
            this.m_UIButtonAdd = new CustomButton();
            this.m_UIButtonAdd.enabled = enabled;
            this.m_UIButtonAdd.label = resourceManager.getString(ConfigurationWidget.BUNDLE,"IGNORE_FILTEREDITOR_BTN_ADD");
            this.m_UIButtonAdd.addEventListener(MouseEvent.CLICK,this.onButtonClick);
            _loc3_.addChild(this.m_UIButtonAdd);
            _loc4_ = new Spacer();
            _loc4_.percentWidth = 100;
            _loc3_.addChild(_loc4_);
            this.m_UIButtonDel = new CustomButton();
            this.m_UIButtonDel.enabled = enabled;
            this.m_UIButtonDel.label = resourceManager.getString(ConfigurationWidget.BUNDLE,"IGNORE_FILTEREDITOR_BTN_DEL");
            this.m_UIButtonDel.addEventListener(MouseEvent.CLICK,this.onButtonClick);
            _loc3_.addChild(this.m_UIButtonDel);
            addChild(_loc3_);
            this.m_UIConstructed = true;
         }
      }
      
      private function addItem() : NameFilterItem
      {
         var _loc1_:NameFilterItem = null;
         if(this.m_DataProvider != null)
         {
            this.stripEmptyPatterns(this.m_DataProvider);
            _loc1_ = new NameFilterItem(null,false);
            this.m_DataProvider.addItem(_loc1_);
            this.m_UIList.validateNow();
            this.m_UIList.editedItemPosition = {
               "rowIndex":this.m_DataProvider.length - 1,
               "columnIndex":1
            };
            return _loc1_;
         }
         return null;
      }
      
      public function set dataProvider(param1:*) : void
      {
         if(param1 && param1 is Array)
         {
            this.m_DataProvider = new ArrayCollection(param1 as Array);
         }
         else if(param1 && param1 is IList)
         {
            this.m_DataProvider = param1;
         }
         else
         {
            this.m_DataProvider = new ArrayCollection();
         }
         if(this.m_DataProvider != null)
         {
            this.stripEmptyPatterns(this.m_DataProvider);
         }
         if(this.m_UIList)
         {
            this.m_UIList.dataProvider = this.m_DataProvider;
            this.m_UIList.validateNow();
         }
      }
      
      protected function onButtonClick(param1:MouseEvent) : void
      {
         if(param1 != null && this.m_DataProvider != null)
         {
            switch(param1.currentTarget)
            {
               case this.m_UIButtonAdd:
                  this.addItem();
                  break;
               case this.m_UIButtonDel:
                  this.removeItem(this.m_UIList.selectedIndex);
            }
         }
      }
      
      private function stripEmptyPatterns(param1:IList) : void
      {
         var _loc2_:int = 0;
         var _loc3_:NameFilterItem = null;
         if(param1 != null)
         {
            _loc2_ = param1.length - 1;
            while(_loc2_ >= 0)
            {
               _loc3_ = NameFilterItem(param1.getItemAt(_loc2_));
               if(_loc3_ == null || _loc3_.pattern == null)
               {
                  param1.removeItemAt(_loc2_);
               }
               _loc2_--;
            }
         }
      }
      
      public function get dataProvider() : IList
      {
         return this.m_DataProvider;
      }
      
      private function removeItem(param1:int) : NameFilterItem
      {
         var _loc2_:NameFilterItem = null;
         if(this.m_DataProvider != null && param1 > -1 && param1 < this.m_DataProvider.length)
         {
            _loc2_ = NameFilterItem(this.m_DataProvider.removeItemAt(param1));
            this.m_UIList.validateNow();
            if((param1 = Math.min(param1,this.m_DataProvider.length - 1)) > -1)
            {
               this.m_UIList.selectedIndex = param1;
               this.m_UIList.scrollToIndex(param1);
            }
            return _loc2_;
         }
         return null;
      }
   }
}
