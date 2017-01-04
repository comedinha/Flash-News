package mx.controls
{
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Graphics;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.ui.Keyboard;
   import flash.utils.Dictionary;
   import flash.utils.describeType;
   import mx.collections.CursorBookmark;
   import mx.collections.ICollectionView;
   import mx.collections.ItemResponder;
   import mx.collections.Sort;
   import mx.collections.SortField;
   import mx.collections.errors.ItemPendingError;
   import mx.controls.dataGridClasses.DataGridBase;
   import mx.controls.dataGridClasses.DataGridColumn;
   import mx.controls.dataGridClasses.DataGridDragProxy;
   import mx.controls.dataGridClasses.DataGridHeader;
   import mx.controls.dataGridClasses.DataGridItemRenderer;
   import mx.controls.dataGridClasses.DataGridListData;
   import mx.controls.listClasses.BaseListData;
   import mx.controls.listClasses.IDropInListItemRenderer;
   import mx.controls.listClasses.IListItemRenderer;
   import mx.controls.listClasses.ListBaseContentHolder;
   import mx.controls.listClasses.ListBaseSeekPending;
   import mx.controls.listClasses.ListRowInfo;
   import mx.controls.scrollClasses.ScrollBar;
   import mx.core.ContextualClassFactory;
   import mx.core.EdgeMetrics;
   import mx.core.EventPriority;
   import mx.core.FlexShape;
   import mx.core.FlexSprite;
   import mx.core.FlexVersion;
   import mx.core.IFactory;
   import mx.core.IFlexDisplayObject;
   import mx.core.IFlexModuleFactory;
   import mx.core.IIMESupport;
   import mx.core.IInvalidating;
   import mx.core.IPropertyChangeNotifier;
   import mx.core.IRectangularBorder;
   import mx.core.IUIComponent;
   import mx.core.ScrollPolicy;
   import mx.core.UIComponent;
   import mx.core.UIComponentGlobals;
   import mx.core.mx_internal;
   import mx.events.CollectionEvent;
   import mx.events.CollectionEventKind;
   import mx.events.DataGridEvent;
   import mx.events.DataGridEventReason;
   import mx.events.DragEvent;
   import mx.events.IndexChangedEvent;
   import mx.events.ListEvent;
   import mx.events.SandboxMouseEvent;
   import mx.events.ScrollEvent;
   import mx.events.ScrollEventDetail;
   import mx.managers.IFocusManager;
   import mx.managers.IFocusManagerComponent;
   import mx.skins.halo.ListDropIndicator;
   import mx.styles.ISimpleStyleClient;
   import mx.styles.StyleManager;
   import mx.utils.ObjectUtil;
   import mx.utils.StringUtil;
   
   use namespace mx_internal;
   
   public class DataGrid extends DataGridBase implements IIMESupport
   {
      
      mx_internal static const VERSION:String = "3.6.0.21751";
      
      mx_internal static var createAccessibilityImplementation:Function;
       
      
      private var lastItemDown:IListItemRenderer;
      
      public var itemEditorInstance:IListItemRenderer;
      
      private var displayableColumns:Array;
      
      private var displayWidth:Number;
      
      mx_internal var resizingColumn:DataGridColumn;
      
      private var dontEdit:Boolean = false;
      
      mx_internal var movingColumn:DataGridColumn;
      
      private var generatedColumns:Boolean = true;
      
      private var lastEditedItemPosition;
      
      private var _headerWordWrapPresent:Boolean = false;
      
      public var editable:Boolean = false;
      
      private var losingFocus:Boolean = false;
      
      private var lastItemFocused:DisplayObject;
      
      private var _originalHeaderHeight:Number = 0;
      
      private var _minColumnWidth:Number;
      
      mx_internal var sortDirection:String;
      
      private var manualSort:Boolean;
      
      private var bEditedItemPositionChanged:Boolean = false;
      
      private var sortColumn:DataGridColumn;
      
      private var actualContentHolder:ListBaseContentHolder;
      
      private var _columns:Array;
      
      private var inEndEdit:Boolean = false;
      
      private var lockedColumnWidth:Number = 0;
      
      public var resizableColumns:Boolean = true;
      
      private var _originalExplicitHeaderHeight:Boolean = false;
      
      private var minColumnWidthInvalid:Boolean = false;
      
      private var _editedItemPosition:Object;
      
      private var _imeMode:String = null;
      
      private var actualRowIndex:int;
      
      private var _proposedEditedItemPosition;
      
      private var itemEditorPositionChanged:Boolean = false;
      
      mx_internal var sortIndex:int = -1;
      
      private var skipHeaderUpdate:Boolean = false;
      
      mx_internal var lastSortIndex:int = -1;
      
      private var actualColIndex:int;
      
      mx_internal var lockedColumnDropIndicator:IFlexDisplayObject;
      
      public var sortableColumns:Boolean = true;
      
      private var collectionUpdatesDisabled:Boolean = false;
      
      private var _draggableColumns:Boolean = true;
      
      private var _focusPane:Sprite;
      
      public function DataGrid()
      {
         super();
         _columns = [];
         setRowHeight(20);
         addEventListener(DataGridEvent.ITEM_EDIT_BEGINNING,itemEditorItemEditBeginningHandler,false,EventPriority.DEFAULT_HANDLER);
         addEventListener(DataGridEvent.ITEM_EDIT_BEGIN,itemEditorItemEditBeginHandler,false,EventPriority.DEFAULT_HANDLER);
         addEventListener(DataGridEvent.ITEM_EDIT_END,itemEditorItemEditEndHandler,false,EventPriority.DEFAULT_HANDLER);
         addEventListener(DataGridEvent.HEADER_RELEASE,headerReleaseHandler,false,EventPriority.DEFAULT_HANDLER);
         addEventListener(MouseEvent.MOUSE_UP,mouseUpHandler);
      }
      
      mx_internal function _drawHeaderBackground(param1:UIComponent) : void
      {
         drawHeaderBackground(param1);
      }
      
      override public function measureWidthOfItems(param1:int = -1, param2:int = 0) : Number
      {
         var _loc3_:Number = 0;
         var _loc4_:int = !!columns?int(columns.length):0;
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            if(columns[_loc5_].visible)
            {
               _loc3_ = _loc3_ + columns[_loc5_].width;
            }
            _loc5_++;
         }
         return _loc3_;
      }
      
      public function get imeMode() : String
      {
         return _imeMode;
      }
      
      private function mouseFocusChangeHandler(param1:MouseEvent) : void
      {
         if(itemEditorInstance && !param1.isDefaultPrevented() && itemRendererContains(itemEditorInstance,DisplayObject(param1.target)))
         {
            param1.preventDefault();
         }
      }
      
      public function destroyItemEditor() : void
      {
         var _loc1_:DataGridEvent = null;
         if(itemEditorInstance)
         {
            DisplayObject(itemEditorInstance).removeEventListener(KeyboardEvent.KEY_DOWN,editorKeyDownHandler);
            systemManager.getSandboxRoot().removeEventListener(MouseEvent.MOUSE_DOWN,editorMouseDownHandler,true);
            systemManager.getSandboxRoot().removeEventListener(SandboxMouseEvent.MOUSE_DOWN_SOMEWHERE,editorMouseDownHandler);
            systemManager.removeEventListener(Event.RESIZE,editorStageResizeHandler,true);
            _loc1_ = new DataGridEvent(DataGridEvent.ITEM_FOCUS_OUT);
            _loc1_.columnIndex = _editedItemPosition.columnIndex;
            _loc1_.rowIndex = _editedItemPosition.rowIndex;
            _loc1_.itemRenderer = itemEditorInstance;
            dispatchEvent(_loc1_);
            if(!_columns[_editedItemPosition.columnIndex].rendererIsEditor)
            {
               if(itemEditorInstance && itemEditorInstance is UIComponent)
               {
                  UIComponent(itemEditorInstance).drawFocus(false);
               }
               actualContentHolder.removeChild(DisplayObject(itemEditorInstance));
               editedItemRenderer.visible = true;
            }
            itemEditorInstance = null;
            _editedItemPosition = null;
         }
      }
      
      override protected function mouseUpHandler(param1:MouseEvent) : void
      {
         var _loc2_:DataGridEvent = null;
         var _loc3_:IListItemRenderer = null;
         var _loc4_:Sprite = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:Point = null;
         _loc3_ = mouseEventToItemRenderer(param1);
         super.mouseUpHandler(param1);
         if(_loc3_ && _loc3_ != itemEditorInstance && (lastItemDown == _loc3_ || itemRendererContains(lastItemDown,lastItemFocused)))
         {
            if(lastItemDown != _loc3_)
            {
               _loc3_ = lastItemDown;
            }
            lastItemFocused = null;
            _loc7_ = itemRendererToIndices(_loc3_);
            if(_loc7_ && _loc7_.y >= 0 && editable && !dontEdit)
            {
               if(displayableColumns[_loc7_.x].editable)
               {
                  beginningEdit(displayableColumns[_loc7_.x].colNum,_loc7_.y,_loc3_);
               }
               else
               {
                  lastEditedItemPosition = {
                     "columnIndex":displayableColumns[_loc7_.x].colNum,
                     "rowIndex":_loc7_.y
                  };
               }
            }
         }
         else if(lastItemDown && lastItemDown != itemEditorInstance)
         {
            _loc7_ = itemRendererToIndices(lastItemDown);
            if(_loc7_ && _loc7_.y >= 0 && editable && !dontEdit)
            {
               if(displayableColumns[_loc7_.x].editable)
               {
                  beginningEdit(displayableColumns[_loc7_.x].colNum,_loc7_.y,lastItemDown);
               }
               else
               {
                  lastEditedItemPosition = {
                     "columnIndex":displayableColumns[_loc7_.x].colNum,
                     "rowIndex":_loc7_.y
                  };
               }
            }
         }
         lastItemDown = null;
      }
      
      private function itemEditorItemEditEndHandler(param1:DataGridEvent) : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:Object = null;
         var _loc4_:String = null;
         var _loc5_:Object = null;
         var _loc6_:String = null;
         var _loc7_:XML = null;
         var _loc8_:DataGridListData = null;
         var _loc9_:IFocusManager = null;
         if(!param1.isDefaultPrevented())
         {
            _loc2_ = false;
            if(param1.reason == DataGridEventReason.NEW_COLUMN)
            {
               if(!collectionUpdatesDisabled)
               {
                  collection.disableAutoUpdate();
                  collectionUpdatesDisabled = true;
               }
            }
            else if(collectionUpdatesDisabled)
            {
               collection.enableAutoUpdate();
               collectionUpdatesDisabled = false;
            }
            if(itemEditorInstance && param1.reason != DataGridEventReason.CANCELLED)
            {
               _loc3_ = itemEditorInstance[_columns[param1.columnIndex].editorDataField];
               _loc4_ = _columns[param1.columnIndex].dataField;
               _loc5_ = param1.itemRenderer.data;
               _loc6_ = "";
               for each(_loc7_ in describeType(_loc5_).variable)
               {
                  if(_loc4_ == _loc7_.@name.toString())
                  {
                     _loc6_ = _loc7_.@type.toString();
                     break;
                  }
               }
               if(_loc6_ == "String")
               {
                  if(!(_loc3_ is String))
                  {
                     _loc3_ = _loc3_.toString();
                  }
               }
               else if(_loc6_ == "uint")
               {
                  if(!(_loc3_ is uint))
                  {
                     _loc3_ = uint(_loc3_);
                  }
               }
               else if(_loc6_ == "int")
               {
                  if(!(_loc3_ is int))
                  {
                     _loc3_ = int(_loc3_);
                  }
               }
               else if(_loc6_ == "Number")
               {
                  if(!(_loc3_ is int))
                  {
                     _loc3_ = Number(_loc3_);
                  }
               }
               if(_loc4_ != null && getCurrentDataValue(_loc5_,_loc4_) !== _loc3_)
               {
                  _loc2_ = setNewValue(_loc5_,_loc4_,_loc3_,param1.columnIndex);
               }
               if(_loc2_ && !(_loc5_ is IPropertyChangeNotifier || _loc5_ is XML))
               {
                  collection.itemUpdated(_loc5_,_loc4_);
               }
               if(param1.itemRenderer is IDropInListItemRenderer)
               {
                  _loc8_ = DataGridListData(IDropInListItemRenderer(param1.itemRenderer).listData);
                  _loc8_.label = _columns[param1.columnIndex].itemToLabel(_loc5_);
                  IDropInListItemRenderer(param1.itemRenderer).listData = _loc8_;
               }
               param1.itemRenderer.data = _loc5_;
            }
         }
         else if(param1.reason != DataGridEventReason.OTHER)
         {
            if(itemEditorInstance && _editedItemPosition)
            {
               if(selectedIndex != _editedItemPosition.rowIndex)
               {
                  selectedIndex = _editedItemPosition.rowIndex;
               }
               _loc9_ = focusManager;
               if(itemEditorInstance is IFocusManagerComponent)
               {
                  _loc9_.setFocus(IFocusManagerComponent(itemEditorInstance));
               }
            }
         }
         if(param1.reason == DataGridEventReason.OTHER || !param1.isDefaultPrevented())
         {
            destroyItemEditor();
         }
      }
      
      public function set imeMode(param1:String) : void
      {
         _imeMode = param1;
      }
      
      mx_internal function measureHeightOfItemsUptoMaxHeight(param1:int = -1, param2:int = 0, param3:Number = -1) : Number
      {
         var item:IListItemRenderer = null;
         var c:DataGridColumn = null;
         var n:int = 0;
         var j:int = 0;
         var data:Object = null;
         var index:int = param1;
         var count:int = param2;
         var maxHeight:Number = param3;
         if(!columns.length)
         {
            return rowHeight * count;
         }
         var h:Number = 0;
         var ch:Number = 0;
         var paddingTop:Number = getStyle("paddingTop");
         var paddingBottom:Number = getStyle("paddingBottom");
         var lockedCount:int = lockedRowCount;
         if(headerVisible && count > 0 && index == -1)
         {
            h = calculateHeaderHeight();
            if(maxHeight != -1 && h > maxHeight)
            {
               setRowCount(0);
               return 0;
            }
            count--;
            index = 0;
         }
         var bookmark:CursorBookmark = !!iterator?iterator.bookmark:null;
         var bMore:Boolean = iterator != null;
         if(index != -1 && iterator)
         {
            try
            {
               iterator.seek(CursorBookmark.FIRST,index);
            }
            catch(e:ItemPendingError)
            {
               bMore = false;
            }
         }
         if(lockedCount > 0)
         {
            try
            {
               collectionIterator.seek(CursorBookmark.FIRST,0);
            }
            catch(e:ItemPendingError)
            {
               bMore = false;
            }
         }
         var i:int = 0;
         while(i < count)
         {
            if(bMore)
            {
               data = lockedCount > 0?collectionIterator.current:iterator.current;
               ch = 0;
               n = columns.length;
               j = 0;
               while(j < n)
               {
                  c = columns[j];
                  if(c.visible)
                  {
                     item = c.getMeasuringRenderer(false,data);
                     if(DisplayObject(item).parent == null)
                     {
                        listContent.addChild(DisplayObject(item));
                     }
                     setupRendererFromData(c,item,data);
                     ch = Math.max(ch,!!variableRowHeight?Number(item.getExplicitOrMeasuredHeight() + paddingBottom + paddingTop):Number(rowHeight));
                  }
                  j++;
               }
            }
            if(maxHeight != -1 && (h + ch > maxHeight || !bMore))
            {
               try
               {
                  if(iterator)
                  {
                     iterator.seek(bookmark,0);
                  }
               }
               catch(e:ItemPendingError)
               {
               }
               count = !!headerVisible?int(i + 1):int(i);
               setRowCount(count);
               return h;
            }
            h = h + ch;
            if(iterator)
            {
               try
               {
                  bMore = iterator.moveNext();
                  if(lockedCount > 0)
                  {
                     collectionIterator.moveNext();
                     lockedCount--;
                  }
               }
               catch(e:ItemPendingError)
               {
                  bMore = false;
               }
            }
            i++;
         }
         if(iterator)
         {
            try
            {
               iterator.seek(bookmark,0);
            }
            catch(e:ItemPendingError)
            {
            }
         }
         return h;
      }
      
      mx_internal function get sortArrow() : IFlexDisplayObject
      {
         return DataGridHeader(header).sortArrow;
      }
      
      override protected function focusOutHandler(param1:FocusEvent) : void
      {
         var _loc2_:DisplayObject = null;
         if(param1.target == this)
         {
            super.focusOutHandler(param1);
         }
         if(param1.relatedObject == this && itemRendererContains(itemEditorInstance,DisplayObject(param1.target)))
         {
            return;
         }
         if(param1.relatedObject == null && itemRendererContains(editedItemRenderer,DisplayObject(param1.target)))
         {
            return;
         }
         if(param1.relatedObject == null && itemRendererContains(itemEditorInstance,DisplayObject(param1.target)))
         {
            return;
         }
         if(itemEditorInstance && (!param1.relatedObject || !itemRendererContains(itemEditorInstance,param1.relatedObject)))
         {
            _loc2_ = DisplayObject(param1.relatedObject);
            while(_loc2_ && _loc2_ != this)
            {
               if(_loc2_ is IListItemRenderer && _loc2_.parent.parent == this && _loc2_.parent is ListBaseContentHolder)
               {
                  if(_loc2_.visible)
                  {
                     return;
                  }
               }
               if(_loc2_ is IUIComponent)
               {
                  _loc2_ = IUIComponent(_loc2_).owner;
               }
               else
               {
                  _loc2_ = _loc2_.parent;
               }
            }
            endEdit(DataGridEventReason.OTHER);
            removeEventListener(FocusEvent.KEY_FOCUS_CHANGE,keyFocusChangeHandler);
            removeEventListener(MouseEvent.MOUSE_DOWN,mouseFocusChangeHandler);
         }
      }
      
      private function itemEditorItemEditBeginningHandler(param1:DataGridEvent) : void
      {
         if(!param1.isDefaultPrevented())
         {
            setEditedItemPosition({
               "columnIndex":param1.columnIndex,
               "rowIndex":param1.rowIndex
            });
         }
         else if(!itemEditorInstance)
         {
            _editedItemPosition = null;
            editable = false;
            setFocus();
            editable = true;
         }
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         if(!header)
         {
            header = new headerClass();
            header.styleName = this;
            addChild(header);
         }
      }
      
      mx_internal function _clearSeparators() : void
      {
         clearSeparators();
      }
      
      public function set draggableColumns(param1:Boolean) : void
      {
         _draggableColumns = param1;
      }
      
      private function updateSortIndexAndDirection() : void
      {
         if(!sortableColumns)
         {
            lastSortIndex = sortIndex;
            sortIndex = -1;
            if(lastSortIndex != sortIndex)
            {
               invalidateDisplayList();
            }
            return;
         }
         if(!dataProvider)
         {
            return;
         }
         var _loc1_:ICollectionView = ICollectionView(dataProvider);
         var _loc2_:Sort = _loc1_.sort;
         if(!_loc2_)
         {
            sortIndex = lastSortIndex = -1;
            return;
         }
         var _loc3_:Array = _loc2_.fields;
         if(!_loc3_)
         {
            return;
         }
         if(_loc3_.length != 1)
         {
            lastSortIndex = sortIndex;
            sortIndex = -1;
            if(lastSortIndex != sortIndex)
            {
               invalidateDisplayList();
            }
            return;
         }
         var _loc4_:SortField = _loc3_[0];
         var _loc5_:int = _columns.length;
         sortIndex = -1;
         var _loc6_:int = 0;
         while(_loc6_ < _loc5_)
         {
            if(_columns[_loc6_].dataField == _loc4_.name)
            {
               sortIndex = !!_columns[_loc6_].sortable?int(_loc6_):-1;
               sortDirection = !!_loc4_.descending?"DESC":"ASC";
               return;
            }
            _loc6_++;
         }
      }
      
      protected function isComplexColumn(param1:String) : Boolean
      {
         return param1.indexOf(".") != -1;
      }
      
      [Bindable("itemFocusIn")]
      public function get editedItemPosition() : Object
      {
         if(_editedItemPosition)
         {
            return {
               "rowIndex":_editedItemPosition.rowIndex,
               "columnIndex":_editedItemPosition.columnIndex
            };
         }
         return _editedItemPosition;
      }
      
      private function drawVerticalSeparator(param1:Sprite, param2:int, param3:uint, param4:Number, param5:Boolean = false) : void
      {
         var _loc10_:IFlexDisplayObject = null;
         var _loc11_:IFlexDisplayObject = null;
         var _loc12_:IFlexDisplayObject = null;
         var _loc13_:IFlexDisplayObject = null;
         var _loc14_:Class = null;
         var _loc15_:ISimpleStyleClient = null;
         var _loc16_:Number = NaN;
         var _loc6_:String = "vSeparator" + param2;
         var _loc7_:String = "vLockedSeparator" + param2;
         var _loc8_:String = !!param5?_loc7_:_loc6_;
         var _loc9_:String = !!param5?"verticalLockedSeparatorSkin":"verticalSeparatorSkin";
         _loc10_ = IFlexDisplayObject(param1.getChildByName(_loc6_));
         _loc11_ = IFlexDisplayObject(param1.getChildByName(_loc7_));
         _loc13_ = !!param5?_loc11_:_loc10_;
         _loc12_ = !!param5?_loc10_:_loc11_;
         if(_loc12_)
         {
            param1.removeChild(DisplayObject(_loc12_));
         }
         if(!_loc13_)
         {
            _loc14_ = Class(getStyle(_loc9_));
            if(_loc14_)
            {
               _loc13_ = IFlexDisplayObject(new _loc14_());
               _loc13_.name = _loc8_;
               _loc15_ = _loc13_ as ISimpleStyleClient;
               if(_loc15_)
               {
                  _loc15_.styleName = this;
               }
               param1.addChild(DisplayObject(_loc13_));
            }
         }
         if(_loc13_)
         {
            _loc16_ = !isNaN(_loc13_.measuredWidth)?Number(_loc13_.measuredWidth):Number(1);
            _loc13_.setActualSize(_loc16_,param1.parent.parent.height);
            _loc13_.move(param4 - Math.round(_loc16_ / 2),0);
         }
         else
         {
            drawVerticalLine(param1,param2,param3,param4);
         }
      }
      
      override public function set headerHeight(param1:Number) : void
      {
         super.headerHeight = param1;
         _originalHeaderHeight = !!isNaN(param1)?Number(22):Number(param1);
         _originalExplicitHeaderHeight = !isNaN(param1);
      }
      
      private function headerReleaseHandler(param1:DataGridEvent) : void
      {
         if(!param1.isDefaultPrevented())
         {
            manualSort = true;
            sortByColumn(param1.columnIndex);
            manualSort = false;
         }
      }
      
      override mx_internal function resizeColumn(param1:int, param2:Number) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:Number = NaN;
         var _loc6_:DataGridColumn = null;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         if((!visibleColumns || visibleColumns.length == 0) && (!visibleLockedColumns || visibleLockedColumns.length == 0))
         {
            _columns[param1].setWidth(param2);
            _columns[param1].preferredWidth = param2;
            return;
         }
         if(param2 < _columns[param1].minWidth)
         {
            param2 = _columns[param1].minWidth;
         }
         if(_horizontalScrollPolicy == ScrollPolicy.ON || _horizontalScrollPolicy == ScrollPolicy.AUTO)
         {
            _columns[param1].setWidth(param2);
            _columns[param1].explicitWidth = param2;
            _columns[param1].preferredWidth = param2;
            columnsInvalid = true;
         }
         else
         {
            _loc3_ = _columns.length;
            _loc4_ = 0;
            while(_loc4_ < _loc3_)
            {
               if(param1 == _columns[_loc4_].colNum)
               {
                  break;
               }
               _loc4_++;
            }
            if(_loc4_ >= _columns.length - 1)
            {
               return;
            }
            param1 = _loc4_;
            _loc5_ = 0;
            _loc4_ = param1 + 1;
            while(_loc4_ < _loc3_)
            {
               if(_columns[_loc4_].visible)
               {
                  if(_columns[_loc4_].resizable)
                  {
                     _loc5_ = _loc5_ + _columns[_loc4_].width;
                  }
               }
               _loc4_++;
            }
            _loc8_ = _columns[param1].width - param2 + _loc5_;
            if(_loc5_)
            {
               _columns[param1].setWidth(param2);
               _columns[param1].explicitWidth = param2;
            }
            _loc9_ = 0;
            _loc4_ = param1 + 1;
            while(_loc4_ < _loc3_)
            {
               if(_columns[_loc4_].visible)
               {
                  if(_columns[_loc4_].resizable)
                  {
                     _loc7_ = Math.floor(_columns[_loc4_].width * _loc8_ / _loc5_);
                     if(_loc7_ < _columns[_loc4_].minWidth)
                     {
                        _loc7_ = _columns[_loc4_].minWidth;
                     }
                     _columns[_loc4_].setWidth(_loc7_);
                     _loc9_ = _loc9_ + _columns[_loc4_].width;
                     _loc6_ = _columns[_loc4_];
                  }
               }
               _loc4_++;
            }
            if(_loc9_ > _loc8_)
            {
               _loc7_ = _columns[param1].width - _loc9_ + _loc8_;
               if(_loc7_ < _columns[param1].minWidth)
               {
                  _loc7_ = _columns[param1].minWidth;
               }
               _columns[param1].setWidth(_loc7_);
            }
            else if(_loc6_)
            {
               _loc6_.setWidth(_loc6_.width - _loc9_ + _loc8_);
            }
         }
         itemsSizeChanged = true;
         invalidateDisplayList();
      }
      
      private function generateCols() : void
      {
         var col:DataGridColumn = null;
         var newCols:Array = null;
         var cols:Array = null;
         var info:Object = null;
         var itmObj:Object = null;
         var p:String = null;
         var n:int = 0;
         var colName:Object = null;
         var i:int = 0;
         if(collection.length > 0)
         {
            newCols = [];
            if(dataProvider)
            {
               try
               {
                  iterator.seek(CursorBookmark.FIRST);
                  if(!iteratorValid)
                  {
                     iteratorValid = true;
                     lastSeekPending = null;
                  }
               }
               catch(e:ItemPendingError)
               {
                  lastSeekPending = new ListBaseSeekPending(CursorBookmark.FIRST,0);
                  e.addResponder(new ItemResponder(generateColumnsPendingResultHandler,seekPendingFailureHandler,lastSeekPending));
                  iteratorValid = false;
                  return;
               }
               info = ObjectUtil.getClassInfo(iterator.current,["uid","mx_internal_uid"]);
               if(info)
               {
                  cols = info.properties;
               }
            }
            if(!cols)
            {
               itmObj = iterator.current;
               for(p in itmObj)
               {
                  if(p != "uid")
                  {
                     col = new DataGridColumn();
                     col.dataField = p;
                     newCols.push(col);
                  }
               }
            }
            else
            {
               n = cols.length;
               i = 0;
               while(i < n)
               {
                  colName = cols[i];
                  if(colName is QName)
                  {
                     colName = QName(colName).localName;
                  }
                  col = new DataGridColumn();
                  col.dataField = String(colName);
                  newCols.push(col);
                  i++;
               }
            }
            columns = newCols;
            generatedColumns = true;
         }
      }
      
      override protected function drawRowBackgrounds() : void
      {
         drawRowGraphics(listContent);
      }
      
      mx_internal function get vScrollBar() : ScrollBar
      {
         return verticalScrollBar;
      }
      
      override public function showDropFeedback(param1:DragEvent) : void
      {
         var _loc2_:Class = null;
         super.showDropFeedback(param1);
         if(lockedColumnCount > 0)
         {
            if(!lockedColumnDropIndicator)
            {
               _loc2_ = getStyle("dropIndicatorSkin");
               if(!_loc2_)
               {
                  _loc2_ = ListDropIndicator;
               }
               lockedColumnDropIndicator = IFlexDisplayObject(new _loc2_());
               lockedColumnDropIndicator.x = 2;
               lockedColumnDropIndicator.setActualSize(lockedColumnContent.width - 2,4);
               lockedColumnDropIndicator.visible = true;
            }
            if(dropIndicator.parent == listContent)
            {
               lockedColumnContent.addChild(DisplayObject(lockedColumnDropIndicator));
            }
            else
            {
               lockedColumnAndRowContent.addChild(DisplayObject(lockedColumnDropIndicator));
            }
            lockedColumnDropIndicator.y = dropIndicator.y;
         }
      }
      
      override protected function scrollPositionToIndex(param1:int, param2:int) : int
      {
         return !!iterator?int(param2 + lockedRowCount):-1;
      }
      
      protected function setNewValue(param1:Object, param2:String, param3:Object, param4:int) : Boolean
      {
         var _loc5_:Array = null;
         var _loc6_:String = null;
         var _loc7_:Object = null;
         if(!isComplexColumn(param2))
         {
            param1[param2] = param3;
         }
         else
         {
            _loc5_ = param2.split(".");
            _loc6_ = _loc5_.pop();
            _loc7_ = deriveComplexFieldReference(param1,_loc5_);
            _loc7_[_loc6_] = param3;
         }
         return true;
      }
      
      private function drawHorizontalSeparator(param1:Sprite, param2:int, param3:uint, param4:Number, param5:Boolean = false) : void
      {
         var _loc10_:IFlexDisplayObject = null;
         var _loc11_:IFlexDisplayObject = null;
         var _loc12_:IFlexDisplayObject = null;
         var _loc13_:IFlexDisplayObject = null;
         var _loc14_:Class = null;
         var _loc15_:ISimpleStyleClient = null;
         var _loc16_:Number = NaN;
         var _loc6_:String = "hSeparator" + param2;
         var _loc7_:String = "hLockedSeparator" + param2;
         var _loc8_:String = !!param5?_loc7_:_loc6_;
         var _loc9_:String = !!param5?"horizontalLockedSeparatorSkin":"horizontalSeparatorSkin";
         _loc10_ = IFlexDisplayObject(param1.getChildByName(_loc6_));
         _loc11_ = IFlexDisplayObject(param1.getChildByName(_loc7_));
         _loc13_ = !!param5?_loc11_:_loc10_;
         _loc12_ = !!param5?_loc10_:_loc11_;
         if(_loc12_)
         {
            param1.removeChild(DisplayObject(_loc12_));
         }
         if(!_loc13_)
         {
            _loc14_ = Class(getStyle(_loc9_));
            if(_loc14_)
            {
               _loc13_ = IFlexDisplayObject(new _loc14_());
               _loc13_.name = _loc8_;
               _loc15_ = _loc13_ as ISimpleStyleClient;
               if(_loc15_)
               {
                  _loc15_.styleName = this;
               }
               param1.addChild(DisplayObject(_loc13_));
            }
         }
         if(_loc13_)
         {
            _loc16_ = !isNaN(_loc13_.measuredHeight)?Number(_loc13_.measuredHeight):Number(1);
            _loc13_.setActualSize(displayWidth - lockedColumnWidth,_loc16_);
            _loc13_.move(0,param4);
         }
         else
         {
            drawHorizontalLine(param1,param2,param3,param4);
         }
      }
      
      private function itemEditorItemEditBeginHandler(param1:DataGridEvent) : void
      {
         var _loc2_:IFocusManager = null;
         if(root)
         {
            systemManager.addEventListener(Event.DEACTIVATE,deactivateHandler,false,0,true);
         }
         if(!param1.isDefaultPrevented() && actualContentHolder.listItems[actualRowIndex][actualColIndex].data != null)
         {
            createItemEditor(param1.columnIndex,param1.rowIndex);
            if(editedItemRenderer is IDropInListItemRenderer && itemEditorInstance is IDropInListItemRenderer)
            {
               IDropInListItemRenderer(itemEditorInstance).listData = IDropInListItemRenderer(editedItemRenderer).listData;
            }
            if(!columns[param1.columnIndex].rendererIsEditor)
            {
               itemEditorInstance.data = editedItemRenderer.data;
            }
            if(itemEditorInstance is IInvalidating)
            {
               IInvalidating(itemEditorInstance).validateNow();
            }
            if(itemEditorInstance is IIMESupport)
            {
               IIMESupport(itemEditorInstance).imeMode = columns[param1.columnIndex].imeMode == null?_imeMode:columns[param1.columnIndex].imeMode;
            }
            _loc2_ = focusManager;
            if(itemEditorInstance is IFocusManagerComponent)
            {
               _loc2_.setFocus(IFocusManagerComponent(itemEditorInstance));
            }
            _loc2_.defaultButtonEnabled = false;
            param1 = new DataGridEvent(DataGridEvent.ITEM_FOCUS_IN);
            param1.columnIndex = _editedItemPosition.columnIndex;
            param1.rowIndex = _editedItemPosition.rowIndex;
            param1.itemRenderer = itemEditorInstance;
            dispatchEvent(param1);
         }
      }
      
      private function setEditedItemPosition(param1:Object) : void
      {
         bEditedItemPositionChanged = true;
         _proposedEditedItemPosition = param1;
         invalidateDisplayList();
      }
      
      private function keyFocusChangeHandler(param1:FocusEvent) : void
      {
         if(param1.keyCode == Keyboard.TAB && !param1.isDefaultPrevented() && findNextItemRenderer(param1.shiftKey))
         {
            param1.preventDefault();
         }
      }
      
      override public function set horizontalScrollPolicy(param1:String) : void
      {
         super.horizontalScrollPolicy = param1;
         columnsInvalid = true;
         itemsSizeChanged = true;
         invalidateDisplayList();
      }
      
      public function set editedItemPosition(param1:Object) : void
      {
         if(!param1)
         {
            setEditedItemPosition(null);
            return;
         }
         var _loc2_:Object = {
            "rowIndex":param1.rowIndex,
            "columnIndex":param1.columnIndex
         };
         setEditedItemPosition(_loc2_);
      }
      
      override public function measureHeightOfItems(param1:int = -1, param2:int = 0) : Number
      {
         return measureHeightOfItemsUptoMaxHeight(param1,param2);
      }
      
      override protected function makeRowsAndColumns(param1:Number, param2:Number, param3:Number, param4:Number, param5:int, param6:int, param7:Boolean = false, param8:uint = 0) : Point
      {
         var _loc10_:DataGridColumn = null;
         var _loc11_:IListItemRenderer = null;
         var _loc12_:ListRowInfo = null;
         var _loc13_:Sprite = null;
         var _loc14_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc16_:Number = NaN;
         var _loc17_:Number = NaN;
         allowItemSizeChangeNotification = false;
         var _loc9_:Point = super.makeRowsAndColumns(param1,param2,param3,param4,param5,param6,param7,param8);
         if(itemEditorInstance)
         {
            actualContentHolder.setChildIndex(DisplayObject(itemEditorInstance),actualContentHolder.numChildren - 1);
            if(lockedColumnCount && editedItemPosition.columnIndex <= visibleLockedColumns[lockedColumnCount - 1].colNum)
            {
               _loc10_ = visibleLockedColumns[actualColIndex];
            }
            else
            {
               _loc10_ = visibleColumns[actualColIndex];
            }
            _loc11_ = actualContentHolder.listItems[actualRowIndex][actualColIndex];
            _loc12_ = actualContentHolder.rowInfo[actualRowIndex];
            if(_loc11_ && !_loc10_.rendererIsEditor)
            {
               _loc14_ = _loc10_.editorXOffset;
               _loc15_ = _loc10_.editorYOffset;
               _loc16_ = _loc10_.editorWidthOffset;
               _loc17_ = _loc10_.editorHeightOffset;
               itemEditorInstance.move(_loc11_.x + _loc14_,_loc12_.y + _loc15_);
               itemEditorInstance.setActualSize(Math.min(_loc10_.width + _loc16_,actualContentHolder.width - itemEditorInstance.x),Math.min(_loc12_.height + _loc17_,actualContentHolder.height - itemEditorInstance.y));
               _loc11_.visible = false;
            }
            _loc13_ = Sprite(actualContentHolder.getChildByName("lines"));
            if(_loc13_)
            {
               actualContentHolder.setChildIndex(_loc13_,actualContentHolder.numChildren - 1);
            }
         }
         allowItemSizeChangeNotification = variableRowHeight;
         return _loc9_;
      }
      
      private function scrollToEditedItem(param1:int, param2:int) : void
      {
         var _loc8_:int = 0;
         actualContentHolder = listContent;
         var _loc3_:Array = actualContentHolder.listItems;
         var _loc4_:int = verticalScrollPosition + _loc3_.length - 1 + lockedRowCount;
         var _loc5_:int = rowInfo[_loc3_.length - 1].y + rowInfo[_loc3_.length - 1].height > listContent.height?1:0;
         if(param1 > lockedRowCount)
         {
            if(param1 < verticalScrollPosition + lockedRowCount)
            {
               verticalScrollPosition = param1 - lockedRowCount;
            }
            else
            {
               while(param1 > _loc4_ || param1 == _loc4_ && param1 > verticalScrollPosition + lockedRowCount && _loc5_)
               {
                  if(verticalScrollPosition == maxVerticalScrollPosition)
                  {
                     break;
                  }
                  verticalScrollPosition = Math.min(verticalScrollPosition + (param1 > _loc4_?param1 - _loc4_:_loc5_),maxVerticalScrollPosition);
                  _loc4_ = verticalScrollPosition + _loc3_.length - 1 + lockedRowCount;
                  _loc5_ = rowInfo[_loc3_.length - 1].y + rowInfo[_loc3_.length - 1].height > listContent.height?1:0;
               }
            }
            actualRowIndex = param1 - verticalScrollPosition - lockedRowCount;
         }
         else if(param1 == lockedRowCount)
         {
            verticalScrollPosition = 0;
            actualRowIndex = param1 - lockedRowCount;
         }
         else
         {
            if(lockedRowCount)
            {
               actualContentHolder = lockedRowContent;
            }
            actualRowIndex = param1;
         }
         _loc3_ = actualContentHolder.listItems;
         var _loc6_:uint = _loc3_ && _loc3_[0]?uint(_loc3_[0].length):uint(visibleColumns.length);
         var _loc7_:int = horizontalScrollPosition + _loc6_ - 1 + lockedColumnCount;
         if(param2 > lockedColumnCount)
         {
            _loc8_ = _loc3_[0][_loc6_ - 1].x + _loc3_[0][_loc6_ - 1].width > listContent.width?1:0;
            if(param2 < horizontalScrollPosition + lockedColumnCount)
            {
               horizontalScrollPosition = param2 - lockedColumnCount;
            }
            else
            {
               while(param2 > _loc7_ || param2 == _loc7_ && param2 > horizontalScrollPosition + lockedColumnCount && _loc8_)
               {
                  if(horizontalScrollPosition == maxHorizontalScrollPosition)
                  {
                     break;
                  }
                  horizontalScrollPosition = Math.min(horizontalScrollPosition + (param2 > _loc7_?param2 - _loc7_:_loc8_),maxHorizontalScrollPosition);
                  _loc6_ = _loc3_ && _loc3_[0]?uint(_loc3_[0].length):uint(visibleColumns.length);
                  _loc7_ = horizontalScrollPosition + _loc6_ - 1 + lockedColumnCount;
                  _loc8_ = _loc3_[0][_loc6_ - 1].x + _loc3_[0][_loc6_ - 1].width > listContent.width?1:0;
               }
            }
            actualColIndex = param2 - horizontalScrollPosition - lockedColumnCount;
         }
         else if(param2 == lockedColumnCount)
         {
            horizontalScrollPosition = 0;
            actualColIndex = param2 - lockedColumnCount;
         }
         else
         {
            if(lockedColumnCount)
            {
               if(actualContentHolder == lockedRowContent)
               {
                  actualContentHolder = lockedColumnAndRowContent;
               }
               else
               {
                  actualContentHolder = lockedColumnContent;
               }
            }
            actualColIndex = param2;
         }
      }
      
      private function sortByColumn(param1:int) : void
      {
         var _loc4_:Sort = null;
         var _loc5_:SortField = null;
         var _loc6_:String = null;
         var _loc7_:Array = null;
         var _loc8_:int = 0;
         var _loc2_:DataGridColumn = columns[param1];
         var _loc3_:* = Boolean(_loc2_.sortDescending);
         if(_loc2_.sortable)
         {
            _loc4_ = collection.sort;
            if(_loc4_)
            {
               _loc4_.compareFunction = null;
               _loc7_ = _loc4_.fields;
               if(_loc7_)
               {
                  _loc8_ = 0;
                  while(_loc8_ < _loc7_.length)
                  {
                     if(_loc7_[_loc8_].name == _loc2_.dataField)
                     {
                        _loc5_ = _loc7_[_loc8_];
                        _loc3_ = !_loc5_.descending;
                        break;
                     }
                     _loc8_++;
                  }
               }
            }
            else
            {
               _loc4_ = new Sort();
            }
            if(!_loc5_)
            {
               _loc5_ = new SortField(_loc2_.dataField);
            }
            _loc2_.sortDescending = _loc3_;
            _loc6_ = !!_loc3_?"DESC":"ASC";
            sortDirection = _loc6_;
            lastSortIndex = sortIndex;
            sortIndex = param1;
            sortColumn = _loc2_;
            _loc5_.name = _loc2_.dataField;
            if(_loc2_.sortCompareFunction != null)
            {
               _loc5_.compareFunction = _loc2_.sortCompareFunction;
            }
            else
            {
               _loc5_.compareFunction = null;
            }
            _loc5_.descending = _loc3_;
            _loc4_.fields = [_loc5_];
         }
         collection.sort = _loc4_;
         collection.refresh();
      }
      
      override mx_internal function columnRendererChanged(param1:DataGridColumn) : void
      {
         var _loc2_:DisplayObject = null;
         var _loc4_:* = undefined;
         var _loc5_:Array = null;
         var _loc6_:IFactory = null;
         var _loc7_:Dictionary = null;
         var _loc8_:* = undefined;
         var _loc3_:Dictionary = param1.measuringObjects;
         if(_loc3_)
         {
            for(_loc4_ in _loc3_)
            {
               _loc6_ = IFactory(_loc4_);
               _loc2_ = param1.measuringObjects[_loc6_];
               if(_loc2_)
               {
                  _loc2_.parent.removeChild(_loc2_);
                  param1.measuringObjects[_loc6_] = null;
               }
               if(param1.freeItemRenderersByFactory && param1.freeItemRenderersByFactory[_loc6_])
               {
                  _loc7_ = param1.freeItemRenderersByFactory[_loc6_];
                  for(_loc8_ in _loc7_)
                  {
                     _loc2_ = DisplayObject(_loc8_);
                     _loc2_.parent.removeChild(_loc2_);
                  }
                  param1.freeItemRenderersByFactory[_loc6_] = new Dictionary(true);
               }
            }
            _loc5_ = freeItemRenderersTable[param1] as Array;
            if(_loc5_)
            {
               while(_loc5_.length)
               {
                  _loc2_ = _loc5_.pop();
               }
            }
         }
         _loc2_ = param1.cachedHeaderRenderer as DisplayObject;
         if(_loc2_ && _loc2_.parent)
         {
            _loc2_.parent.removeChild(_loc2_);
         }
         param1.cachedHeaderRenderer = null;
         rendererChanged = true;
         invalidateDisplayList();
      }
      
      override public function invalidateDisplayList() : void
      {
         super.invalidateDisplayList();
         if(header)
         {
            header.headerItemsChanged = true;
            header.invalidateSize();
            header.invalidateDisplayList();
         }
         if(lockedColumnHeader)
         {
            lockedColumnHeader.headerItemsChanged = true;
            lockedColumnHeader.invalidateSize();
            lockedColumnHeader.invalidateDisplayList();
         }
      }
      
      private function findNextEnterItemRenderer(param1:KeyboardEvent) : void
      {
         if(_proposedEditedItemPosition !== undefined)
         {
            return;
         }
         _editedItemPosition = lastEditedItemPosition;
         if(!_editedItemPosition)
         {
            return;
         }
         var _loc2_:int = _editedItemPosition.rowIndex;
         var _loc3_:int = _editedItemPosition.columnIndex;
         var _loc4_:int = _editedItemPosition.rowIndex + (!!param1.shiftKey?-1:1);
         if(_loc4_ < collection.length && _loc4_ >= 0)
         {
            _loc2_ = _loc4_;
         }
         beginningEdit(_loc3_,_loc2_);
      }
      
      override public function set verticalScrollPosition(param1:Number) : void
      {
         skipHeaderUpdate = true;
         var _loc2_:Number = super.verticalScrollPosition;
         super.verticalScrollPosition = param1;
         if(_loc2_ != param1)
         {
            if(lockedColumnContent)
            {
               drawRowGraphics(lockedColumnContent);
            }
         }
         skipHeaderUpdate = false;
      }
      
      override public function get columnCount() : int
      {
         if(_columns)
         {
            return _columns.length;
         }
         return 0;
      }
      
      protected function deriveComplexFieldReference(param1:Object, param2:Array) : Object
      {
         var _loc4_:int = 0;
         var _loc3_:Object = param1;
         if(param2)
         {
            _loc4_ = 0;
            while(_loc4_ < param2.length)
            {
               _loc3_ = _loc3_[param2[_loc4_]];
               _loc4_++;
            }
         }
         return _loc3_;
      }
      
      override public function calculateDropIndex(param1:DragEvent = null) : int
      {
         var _loc2_:IListItemRenderer = null;
         var _loc3_:IListItemRenderer = null;
         var _loc4_:Point = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         if(param1)
         {
            _loc4_ = new Point(param1.localX,param1.localY);
            _loc4_ = DisplayObject(param1.target).localToGlobal(_loc4_);
            _loc4_ = listContent.globalToLocal(_loc4_);
            _loc5_ = listItems.length;
            _loc6_ = 0;
            while(_loc6_ < _loc5_)
            {
               if(listItems[_loc6_][0])
               {
                  _loc3_ = listItems[_loc6_][0];
               }
               if(rowInfo[_loc6_].y <= _loc4_.y && _loc4_.y < rowInfo[_loc6_].y + rowInfo[_loc6_].height)
               {
                  _loc2_ = listItems[_loc6_][0];
                  break;
               }
               _loc6_++;
            }
            if(!_loc2_ && lockedRowContent)
            {
               _loc4_ = listContent.localToGlobal(_loc4_);
               _loc4_ = lockedRowContent.globalToLocal(_loc4_);
               _loc5_ = lockedRowContent.listItems.length;
               _loc6_ = 0;
               while(_loc6_ < _loc5_)
               {
                  if(lockedRowContent.rowInfo[_loc6_].y <= _loc4_.y && _loc4_.y < lockedRowContent.rowInfo[_loc6_].y + lockedRowContent.rowInfo[_loc6_].height)
                  {
                     _loc2_ = lockedRowContent.listItems[_loc6_][0];
                     break;
                  }
                  _loc6_++;
               }
            }
            if(_loc2_)
            {
               lastDropIndex = itemRendererToIndex(_loc2_);
            }
            else if(_loc3_)
            {
               lastDropIndex = itemRendererToIndex(_loc3_) + 1;
            }
            else
            {
               lastDropIndex = !!collection?int(collection.length):0;
            }
         }
         return lastDropIndex;
      }
      
      override protected function measure() : void
      {
         var _loc1_:EdgeMetrics = null;
         super.measure();
         if(explicitRowCount != -1)
         {
            measuredHeight = measuredHeight + headerHeight;
            measuredMinHeight = measuredMinHeight + headerHeight;
         }
         _loc1_ = viewMetrics;
         var _loc2_:int = columns.length;
         if(_loc2_ == 0)
         {
            measuredWidth = DEFAULT_MEASURED_WIDTH;
            measuredMinWidth = DEFAULT_MEASURED_MIN_WIDTH;
            return;
         }
         var _loc3_:Number = 0;
         var _loc4_:Number = 0;
         var _loc5_:int = 0;
         while(_loc5_ < _loc2_)
         {
            if(columns[_loc5_].visible)
            {
               _loc3_ = _loc3_ + columns[_loc5_].preferredWidth;
               if(isNaN(_minColumnWidth))
               {
                  _loc4_ = _loc4_ + columns[_loc5_].minWidth;
               }
            }
            _loc5_++;
         }
         if(!isNaN(_minColumnWidth))
         {
            _loc4_ = _loc2_ * _minColumnWidth;
         }
         measuredWidth = _loc3_ + _loc1_.left + _loc1_.right;
         measuredMinWidth = _loc4_ + _loc1_.left + _loc1_.right;
         if(verticalScrollPolicy == ScrollPolicy.AUTO && verticalScrollBar && verticalScrollBar.visible)
         {
            measuredWidth = measuredWidth - verticalScrollBar.minWidth;
            measuredMinWidth = measuredMinWidth - verticalScrollBar.minWidth;
         }
         if(horizontalScrollPolicy == ScrollPolicy.AUTO && horizontalScrollBar && horizontalScrollBar.visible)
         {
            measuredHeight = measuredHeight - horizontalScrollBar.minHeight;
            measuredMinHeight = measuredMinHeight - horizontalScrollBar.minHeight;
         }
      }
      
      private function lockedRowSeekPendingResultHandler(param1:Object, param2:ListBaseSeekPending) : void
      {
         var data:Object = param1;
         var info:ListBaseSeekPending = param2;
         try
         {
            lockedRowContent.iterator.seek(CursorBookmark.FIRST);
         }
         catch(e:ItemPendingError)
         {
            e.addResponder(new ItemResponder(lockedRowSeekPendingResultHandler,seekPendingFailureHandler,null));
         }
         itemsSizeChanged = true;
         invalidateDisplayList();
      }
      
      override protected function mouseDownHandler(param1:MouseEvent) : void
      {
         var _loc2_:IListItemRenderer = null;
         var _loc3_:Sprite = null;
         var _loc5_:Point = null;
         var _loc6_:Boolean = false;
         _loc2_ = mouseEventToItemRenderer(param1);
         lastItemDown = null;
         var _loc4_:Boolean = itemRendererContains(itemEditorInstance,DisplayObject(param1.target));
         if(!_loc4_)
         {
            if(_loc2_)
            {
               lastItemDown = _loc2_;
               _loc5_ = itemRendererToIndices(_loc2_);
               _loc6_ = true;
               if(itemEditorInstance)
               {
                  if(displayableColumns[_loc5_.x].editable == false)
                  {
                     _loc6_ = endEdit(DataGridEventReason.OTHER);
                  }
                  else if(editedItemPosition)
                  {
                     _loc6_ = endEdit(editedItemPosition.rowIndex == _loc5_.y?DataGridEventReason.NEW_COLUMN:DataGridEventReason.NEW_ROW);
                  }
                  else
                  {
                     _loc6_ = false;
                  }
               }
               if(!_loc6_)
               {
                  return;
               }
            }
            else if(itemEditorInstance)
            {
               endEdit(DataGridEventReason.OTHER);
            }
            super.mouseDownHandler(param1);
            if(_loc2_)
            {
               if(displayableColumns[_loc5_.x].rendererIsEditor)
               {
                  resetDragScrolling();
               }
            }
         }
         else
         {
            resetDragScrolling();
         }
      }
      
      public function get minColumnWidth() : Number
      {
         return _minColumnWidth;
      }
      
      private function findNextItemRenderer(param1:Boolean) : Boolean
      {
         var _loc7_:String = null;
         if(!lastEditedItemPosition)
         {
            return false;
         }
         if(_proposedEditedItemPosition !== undefined)
         {
            return true;
         }
         _editedItemPosition = lastEditedItemPosition;
         var _loc2_:int = _editedItemPosition.rowIndex;
         var _loc3_:int = _editedItemPosition.columnIndex;
         var _loc4_:Boolean = false;
         var _loc5_:int = !!param1?-1:1;
         var _loc6_:int = collection.length - 1;
         while(!_loc4_)
         {
            _loc3_ = _loc3_ + _loc5_;
            if(_loc3_ >= _columns.length || _loc3_ < 0)
            {
               _loc3_ = _loc3_ < 0?int(_columns.length - 1):0;
               _loc2_ = _loc2_ + _loc5_;
               if(_loc2_ > _loc6_ || _loc2_ < 0)
               {
                  if(endEdit(DataGridEventReason.NEW_ROW))
                  {
                     setEditedItemPosition(null);
                     losingFocus = true;
                     setFocus();
                     return false;
                  }
                  return true;
               }
            }
            if(_columns[_loc3_].editable && _columns[_loc3_].visible)
            {
               _loc4_ = true;
               _loc7_ = _loc2_ == _editedItemPosition.rowIndex?DataGridEventReason.NEW_COLUMN:DataGridEventReason.NEW_ROW;
               if(!itemEditorInstance || endEdit(_loc7_))
               {
                  beginningEdit(_loc3_,_loc2_);
               }
            }
         }
         return _loc4_;
      }
      
      protected function clearSeparators() : void
      {
         DataGridHeader(header)._clearSeparators();
         if(lockedColumnHeader)
         {
            DataGridHeader(lockedColumnHeader)._clearSeparators();
         }
      }
      
      override protected function mouseEventToItemRenderer(param1:MouseEvent) : IListItemRenderer
      {
         var _loc2_:IListItemRenderer = null;
         _loc2_ = super.mouseEventToItemRenderer(param1);
         return _loc2_ == itemEditorInstance?null:_loc2_;
      }
      
      private function deactivateHandler(param1:Event) : void
      {
         if(itemEditorInstance)
         {
            endEdit(DataGridEventReason.OTHER);
            losingFocus = true;
            setFocus();
         }
      }
      
      override protected function focusInHandler(param1:FocusEvent) : void
      {
         var _loc2_:DataGridEvent = null;
         var _loc3_:Boolean = false;
         if(losingFocus)
         {
            losingFocus = false;
            return;
         }
         if(editable)
         {
            addEventListener(FocusEvent.KEY_FOCUS_CHANGE,keyFocusChangeHandler);
            addEventListener(MouseEvent.MOUSE_DOWN,mouseFocusChangeHandler);
         }
         if(param1.target != this)
         {
            if(itemEditorInstance && itemRendererContains(itemEditorInstance,DisplayObject(param1.target)))
            {
               return;
            }
            lastItemFocused = DisplayObject(param1.target);
            return;
         }
         lastItemFocused = null;
         super.focusInHandler(param1);
         if(editable && !isPressed)
         {
            _editedItemPosition = lastEditedItemPosition;
            _loc3_ = false;
            if(!_editedItemPosition)
            {
               _editedItemPosition = {
                  "rowIndex":0,
                  "columnIndex":0
               };
            }
            while(_editedItemPosition.columnIndex != _columns.length)
            {
               if(_columns[_editedItemPosition.columnIndex].editable && _columns[_editedItemPosition.columnIndex].visible)
               {
                  _loc3_ = true;
                  break;
               }
               _editedItemPosition.columnIndex++;
            }
            if(_loc3_)
            {
               beginningEdit(_editedItemPosition.columnIndex,_editedItemPosition.rowIndex);
            }
         }
      }
      
      override public function set dataProvider(param1:Object) : void
      {
         if(itemEditorInstance)
         {
            endEdit(DataGridEventReason.OTHER);
         }
         lastEditedItemPosition = null;
         super.dataProvider = param1;
      }
      
      override protected function keyDownHandler(param1:KeyboardEvent) : void
      {
         if(itemEditorInstance || param1.target != param1.currentTarget)
         {
            return;
         }
         if(param1.keyCode != Keyboard.SPACE)
         {
            super.keyDownHandler(param1);
         }
         else if(caretIndex != -1)
         {
            moveSelectionVertically(param1.keyCode,param1.shiftKey,param1.ctrlKey);
         }
      }
      
      protected function drawLinesAndColumnBackgrounds() : void
      {
         drawLinesAndColumnGraphics(listContent,visibleColumns,{});
      }
      
      public function createItemEditor(param1:int, param2:int) : void
      {
         var _loc7_:int = 0;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:IFactory = null;
         if(displayableColumns.length != _columns.length)
         {
            _loc7_ = 0;
            while(_loc7_ < displayableColumns.length)
            {
               if(displayableColumns[_loc7_].colNum >= param1)
               {
                  param1 = _loc7_;
                  break;
               }
               _loc7_++;
            }
            if(_loc7_ == displayableColumns.length)
            {
               param1 = 0;
            }
         }
         var _loc3_:DataGridColumn = displayableColumns[param1];
         if(param2 >= lockedRowCount)
         {
            param2 = param2 - (verticalScrollPosition + lockedRowCount);
         }
         if(param1 >= lockedColumnCount)
         {
            param1 = param1 - (horizontalScrollPosition + lockedColumnCount);
         }
         var _loc4_:IListItemRenderer = actualContentHolder.listItems[param2][param1];
         var _loc5_:ListRowInfo = actualContentHolder.rowInfo[param2];
         if(!_loc3_.rendererIsEditor)
         {
            _loc8_ = 0;
            _loc9_ = -2;
            _loc10_ = 0;
            _loc11_ = 4;
            if(!itemEditorInstance)
            {
               _loc12_ = _loc3_.itemEditor;
               _loc8_ = _loc3_.editorXOffset;
               _loc9_ = _loc3_.editorYOffset;
               _loc10_ = _loc3_.editorWidthOffset;
               _loc11_ = _loc3_.editorHeightOffset;
               itemEditorInstance = _loc12_.newInstance();
               itemEditorInstance.owner = this;
               itemEditorInstance.styleName = _loc3_;
               actualContentHolder.addChild(DisplayObject(itemEditorInstance));
            }
            actualContentHolder.setChildIndex(DisplayObject(itemEditorInstance),actualContentHolder.numChildren - 1);
            itemEditorInstance.visible = true;
            itemEditorInstance.move(_loc4_.x + _loc8_,_loc5_.y + _loc9_);
            itemEditorInstance.setActualSize(Math.min(_loc3_.width + _loc10_,actualContentHolder.width - 1 - itemEditorInstance.x),Math.min(_loc5_.height + _loc11_,actualContentHolder.height - itemEditorInstance.y));
            DisplayObject(itemEditorInstance).addEventListener(FocusEvent.FOCUS_OUT,itemEditorFocusOutHandler);
            _loc4_.visible = false;
         }
         else
         {
            itemEditorInstance = _loc4_;
         }
         DisplayObject(itemEditorInstance).addEventListener(KeyboardEvent.KEY_DOWN,editorKeyDownHandler);
         systemManager.getSandboxRoot().addEventListener(MouseEvent.MOUSE_DOWN,editorMouseDownHandler,true,0,true);
         systemManager.getSandboxRoot().addEventListener(SandboxMouseEvent.MOUSE_DOWN_SOMEWHERE,editorMouseDownHandler,false,0,true);
         systemManager.addEventListener(Event.RESIZE,editorStageResizeHandler,true,0,true);
         var _loc6_:DataGridEvent = new DataGridEvent(DataGridEvent.ITEM_EDITOR_CREATE,false,true,param1,null,param2);
         dispatchEvent(_loc6_);
      }
      
      override public function set enabled(param1:Boolean) : void
      {
         super.enabled = param1;
         if(header)
         {
            header.enabled = param1;
         }
         if(itemEditorInstance)
         {
            endEdit(DataGridEventReason.OTHER);
         }
         invalidateDisplayList();
      }
      
      override protected function collectionChangeHandler(param1:Event) : void
      {
         var _loc2_:Object = null;
         var _loc3_:CollectionEvent = null;
         var _loc4_:CollectionEvent = null;
         if(param1 is CollectionEvent)
         {
            _loc3_ = CollectionEvent(param1);
            if(_loc3_.kind == CollectionEventKind.RESET)
            {
               if(itemEditorInstance)
               {
                  endEdit(DataGridEventReason.CANCELLED);
               }
               setEditedItemPosition(null);
               if(generatedColumns)
               {
                  generateCols();
               }
               else
               {
                  columnsInvalid = true;
               }
               updateSortIndexAndDirection();
               if(lockedRowContent)
               {
                  lockedRowContent.iterator = collection.createCursor();
               }
               if(lockedColumnAndRowContent)
               {
                  lockedColumnAndRowContent.iterator = collection.createCursor();
               }
            }
            else if(_loc3_.kind == CollectionEventKind.REFRESH && !manualSort)
            {
               updateSortIndexAndDirection();
            }
            else if(_loc3_.kind == CollectionEventKind.ADD)
            {
               if(editedItemPosition)
               {
                  if(_loc3_.location <= editedItemPosition.rowIndex)
                  {
                     _loc2_ = editedItemPosition;
                     if(inEndEdit)
                     {
                        _editedItemPosition = {
                           "columnIndex":editedItemPosition.columnIndex,
                           "rowIndex":Math.max(0,editedItemPosition.rowIndex + _loc3_.items.length)
                        };
                     }
                     else if(itemEditorInstance)
                     {
                        _editedItemPosition = {
                           "columnIndex":editedItemPosition.columnIndex,
                           "rowIndex":Math.max(0,editedItemPosition.rowIndex + _loc3_.items.length)
                        };
                        itemEditorPositionChanged = true;
                        lastEditedItemPosition = _editedItemPosition;
                     }
                     else
                     {
                        setEditedItemPosition({
                           "columnIndex":_loc2_.columnIndex,
                           "rowIndex":Math.max(0,_loc2_.rowIndex + _loc3_.items.length)
                        });
                     }
                  }
               }
            }
            else if(_loc3_.kind == CollectionEventKind.REMOVE)
            {
               if(editedItemPosition)
               {
                  if(collection.length == 0)
                  {
                     if(itemEditorInstance)
                     {
                        endEdit(DataGridEventReason.CANCELLED);
                     }
                     setEditedItemPosition(null);
                  }
                  else if(_loc3_.location <= editedItemPosition.rowIndex)
                  {
                     _loc2_ = editedItemPosition;
                     if(_loc3_.location == editedItemPosition.rowIndex && itemEditorInstance)
                     {
                        endEdit(DataGridEventReason.CANCELLED);
                     }
                     if(inEndEdit)
                     {
                        _editedItemPosition = {
                           "columnIndex":editedItemPosition.columnIndex,
                           "rowIndex":Math.max(0,editedItemPosition.rowIndex - _loc3_.items.length)
                        };
                     }
                     else if(itemEditorInstance)
                     {
                        _editedItemPosition = {
                           "columnIndex":editedItemPosition.columnIndex,
                           "rowIndex":Math.max(0,editedItemPosition.rowIndex - _loc3_.items.length)
                        };
                        itemEditorPositionChanged = true;
                        lastEditedItemPosition = _editedItemPosition;
                     }
                     else
                     {
                        setEditedItemPosition({
                           "columnIndex":_loc2_.columnIndex,
                           "rowIndex":Math.max(0,_loc2_.rowIndex - _loc3_.items.length)
                        });
                     }
                  }
               }
            }
            else if(_loc3_.kind == CollectionEventKind.REPLACE)
            {
               if(editedItemPosition)
               {
                  if(_loc3_.location == editedItemPosition.rowIndex && itemEditorInstance)
                  {
                     endEdit(DataGridEventReason.CANCELLED);
                  }
               }
            }
         }
         super.collectionChangeHandler(param1);
         if(param1 is CollectionEvent)
         {
            _loc4_ = CollectionEvent(param1);
            if(_loc4_.kind == CollectionEventKind.ADD)
            {
               if(collection.length == 1)
               {
                  if(generatedColumns)
                  {
                     generateCols();
                  }
               }
            }
            else if(_loc4_.kind == CollectionEventKind.REFRESH)
            {
               if(lockedRowCount && lockedRowContent)
               {
                  lockedRowContent.iterator.seek(CursorBookmark.FIRST,0);
               }
            }
         }
      }
      
      override protected function get dragImage() : IUIComponent
      {
         var _loc1_:DataGridDragProxy = new DataGridDragProxy();
         _loc1_.owner = this;
         _loc1_.moduleFactory = moduleFactory;
         return _loc1_;
      }
      
      public function get draggableColumns() : Boolean
      {
         return _draggableColumns;
      }
      
      protected function drawSeparators() : void
      {
         DataGridHeader(header)._drawSeparators();
         if(lockedColumnHeader)
         {
            DataGridHeader(lockedColumnHeader)._drawSeparators();
         }
      }
      
      override protected function scrollVertically(param1:int, param2:int, param3:Boolean) : void
      {
         super.scrollVertically(param1,param2,param3);
         if(getStyle("horizontalGridLines"))
         {
            drawLinesAndColumnGraphics(listContent,visibleColumns,{});
            if(lockedColumnCount)
            {
               drawLinesAndColumnGraphics(lockedColumnContent,visibleLockedColumns,{"right":1});
            }
         }
      }
      
      override public function get baselinePosition() : Number
      {
         var _loc2_:Number = NaN;
         if(FlexVersion.compatibilityVersion < FlexVersion.VERSION_3_0)
         {
            _loc2_ = 0;
            if(border && border is IRectangularBorder)
            {
               _loc2_ = IRectangularBorder(border).borderMetrics.top;
            }
            return _loc2_ + measureText(" ").ascent;
         }
         if(!validateBaselinePosition())
         {
            return NaN;
         }
         if(!showHeaders)
         {
            return super.baselinePosition;
         }
         var _loc1_:IUIComponent = DataGridHeader(header).rendererArray[0];
         if(!_loc1_)
         {
            return super.baselinePosition;
         }
         return header.y + _loc1_.y + _loc1_.baselinePosition;
      }
      
      private function displayingPartialRow() : Boolean
      {
         var _loc1_:int = listItems.length - 1 - offscreenExtraRowsBottom;
         if(rowInfo[_loc1_].y + rowInfo[_loc1_].height > listContent.heightExcludingOffsets - listContent.topOffset)
         {
            return true;
         }
         return false;
      }
      
      mx_internal function calculateHeaderHeight() : Number
      {
         var _loc1_:IListItemRenderer = null;
         var _loc2_:DataGridColumn = null;
         var _loc3_:DataGridListData = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         if(!columns.length)
         {
            return rowHeight;
         }
         if(!listContent)
         {
            return rowHeight;
         }
         var _loc4_:Number = 0;
         var _loc7_:Number = getStyle("paddingTop");
         var _loc8_:Number = getStyle("paddingBottom");
         if(showHeaders)
         {
            _loc4_ = 0;
            _loc5_ = columns.length;
            if(_headerWordWrapPresent)
            {
               _headerHeight = _originalHeaderHeight;
               _explicitHeaderHeight = _originalExplicitHeaderHeight;
            }
            _loc6_ = 0;
            while(_loc6_ < _loc5_)
            {
               _loc2_ = columns[_loc6_];
               if(_loc2_.visible)
               {
                  _loc1_ = _loc2_.cachedHeaderRenderer;
                  if(!_loc1_)
                  {
                     _loc1_ = createColumnItemRenderer(_loc2_,true,_loc2_);
                     _loc1_.styleName = _loc2_;
                     _loc2_.cachedHeaderRenderer = _loc1_;
                  }
                  if(DisplayObject(_loc1_).parent == null)
                  {
                     listContent.addChild(DisplayObject(_loc1_));
                     _loc1_.visible = false;
                  }
                  _loc3_ = DataGridListData(makeListData(_loc2_,uid,0,_loc2_.colNum,_loc2_));
                  rowMap[_loc1_.name] = _loc3_;
                  if(_loc1_ is IDropInListItemRenderer)
                  {
                     IDropInListItemRenderer(_loc1_).listData = _loc3_;
                  }
                  _loc1_.data = _loc2_;
                  _loc1_.explicitWidth = _loc2_.width;
                  UIComponentGlobals.layoutManager.validateClient(_loc1_,true);
                  _loc4_ = Math.max(_loc4_,!!_explicitHeaderHeight?Number(headerHeight):Number(_loc1_.getExplicitOrMeasuredHeight() + _loc8_ + _loc7_));
                  if(columnHeaderWordWrap(_loc2_))
                  {
                     _headerWordWrapPresent = true;
                  }
               }
               _loc6_++;
            }
            if(_headerWordWrapPresent)
            {
               _originalHeaderHeight = _headerHeight;
               _originalExplicitHeaderHeight = _explicitHeaderHeight;
               _headerHeight = _loc4_;
               _explicitHeaderHeight = true;
            }
         }
         return _loc4_;
      }
      
      private function calculateColumnSizes() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc5_:DataGridColumn = null;
         var _loc6_:Number = NaN;
         var _loc7_:DataGridColumn = null;
         var _loc8_:Number = NaN;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc4_:Number = 0;
         if(columns.length == 0)
         {
            visibleColumns = [];
            visibleLockedColumns = [];
            lockedColumnWidth = 0;
            columnsInvalid = false;
            return;
         }
         if(columnsInvalid)
         {
            columnsInvalid = false;
            visibleColumns = [];
            visibleLockedColumns = [];
            lockedColumnWidth = 0;
            if(minColumnWidthInvalid)
            {
               _loc2_ = columns.length;
               _loc3_ = 0;
               while(_loc3_ < _loc2_)
               {
                  columns[_loc3_].minWidth = minColumnWidth;
                  _loc3_++;
               }
               minColumnWidthInvalid = false;
            }
            displayableColumns = null;
            _loc2_ = _columns.length;
            _loc3_ = 0;
            while(_loc3_ < _loc2_)
            {
               if(displayableColumns && _columns[_loc3_].visible)
               {
                  displayableColumns.push(_columns[_loc3_]);
               }
               else if(!displayableColumns && !_columns[_loc3_].visible)
               {
                  displayableColumns = new Array(_loc3_);
                  _loc9_ = 0;
                  while(_loc9_ < _loc3_)
                  {
                     displayableColumns[_loc9_] = _columns[_loc9_];
                     _loc9_++;
                  }
               }
               _loc3_++;
            }
            if(!displayableColumns)
            {
               displayableColumns = _columns;
            }
            if(horizontalScrollPolicy == ScrollPolicy.OFF)
            {
               _loc2_ = displayableColumns.length;
               _loc3_ = 0;
               while(_loc3_ < _loc2_)
               {
                  _loc5_ = displayableColumns[_loc3_];
                  if(_loc3_ < lockedColumnCount)
                  {
                     visibleLockedColumns.push(_loc5_);
                  }
                  else
                  {
                     visibleColumns.push(_loc5_);
                  }
                  _loc3_++;
               }
            }
            else
            {
               _loc2_ = displayableColumns.length;
               _loc3_ = 0;
               while(_loc3_ < _loc2_)
               {
                  if(!(_loc3_ >= lockedColumnCount && _loc3_ < lockedColumnCount + horizontalScrollPosition))
                  {
                     _loc5_ = displayableColumns[_loc3_];
                     if(_loc5_.preferredWidth < _loc5_.minWidth)
                     {
                        _loc5_.preferredWidth = _loc5_.minWidth;
                     }
                     if(_loc4_ < displayWidth)
                     {
                        if(_loc3_ < lockedColumnCount)
                        {
                           lockedColumnWidth = lockedColumnWidth + Math.max(!!isNaN(_loc5_.explicitWidth)?Number(_loc5_.preferredWidth):Number(_loc5_.explicitWidth),_loc5_.minWidth);
                           visibleLockedColumns.push(_loc5_);
                        }
                        else
                        {
                           visibleColumns.push(_loc5_);
                        }
                        _loc4_ = _loc4_ + Math.max(!!isNaN(_loc5_.explicitWidth)?Number(_loc5_.preferredWidth):Number(_loc5_.explicitWidth),_loc5_.minWidth);
                        if(_loc5_.width != _loc5_.preferredWidth)
                        {
                           _loc5_.setWidth(_loc5_.preferredWidth);
                        }
                     }
                     else
                     {
                        if(visibleColumns.length == 0)
                        {
                           visibleColumns.push(displayableColumns[0]);
                        }
                        break;
                     }
                  }
                  _loc3_++;
               }
            }
         }
         if(horizontalScrollPolicy == ScrollPolicy.OFF)
         {
            _loc10_ = 0;
            _loc11_ = 0;
            _loc2_ = visibleColumns.length;
            _loc3_ = 0;
            while(_loc3_ < _loc2_)
            {
               if(visibleColumns[_loc3_].resizable && !visibleColumns[_loc3_].newlyVisible)
               {
                  if(!isNaN(visibleColumns[_loc3_].explicitWidth))
                  {
                     _loc11_ = _loc11_ + visibleColumns[_loc3_].width;
                  }
                  else
                  {
                     _loc10_++;
                     _loc11_ = _loc11_ + visibleColumns[_loc3_].minWidth;
                  }
               }
               else
               {
                  _loc11_ = _loc11_ + visibleColumns[_loc3_].width;
               }
               _loc4_ = _loc4_ + visibleColumns[_loc3_].width;
               _loc3_++;
            }
            _loc2_ = visibleLockedColumns.length;
            _loc3_ = 0;
            while(_loc3_ < _loc2_)
            {
               if(visibleLockedColumns[_loc3_].resizable && !visibleLockedColumns[_loc3_].newlyVisible)
               {
                  if(!isNaN(visibleLockedColumns[_loc3_].explicitWidth))
                  {
                     _loc11_ = _loc11_ + visibleLockedColumns[_loc3_].width;
                  }
                  else
                  {
                     _loc10_++;
                     _loc11_ = _loc11_ + visibleLockedColumns[_loc3_].minWidth;
                  }
               }
               else
               {
                  _loc11_ = _loc11_ + visibleLockedColumns[_loc3_].width;
               }
               _loc4_ = _loc4_ + visibleLockedColumns[_loc3_].width;
               _loc3_++;
            }
            _loc13_ = displayWidth;
            if(displayWidth > _loc11_ && _loc10_)
            {
               _loc2_ = visibleLockedColumns.length;
               _loc3_ = 0;
               while(_loc3_ < _loc2_)
               {
                  if(visibleLockedColumns[_loc3_].resizable && !visibleLockedColumns[_loc3_].newlyVisible && isNaN(visibleLockedColumns[_loc3_].explicitWidth))
                  {
                     _loc7_ = visibleLockedColumns[_loc3_];
                     if(_loc4_ > displayWidth)
                     {
                        _loc12_ = (_loc7_.width - _loc7_.minWidth) / (_loc4_ - _loc11_);
                     }
                     else
                     {
                        _loc12_ = _loc7_.width / _loc4_;
                     }
                     _loc8_ = _loc7_.width - (_loc4_ - displayWidth) * _loc12_;
                     _loc14_ = visibleLockedColumns[_loc3_].minWidth;
                     visibleLockedColumns[_loc3_].setWidth(_loc8_ > _loc14_?_loc8_:_loc14_);
                  }
                  _loc13_ = _loc13_ - visibleLockedColumns[_loc3_].width;
                  visibleLockedColumns[_loc3_].newlyVisible = false;
                  _loc3_++;
               }
               _loc2_ = visibleColumns.length;
               _loc3_ = 0;
               while(_loc3_ < _loc2_)
               {
                  if(visibleColumns[_loc3_].resizable && !visibleColumns[_loc3_].newlyVisible && isNaN(visibleColumns[_loc3_].explicitWidth))
                  {
                     _loc7_ = visibleColumns[_loc3_];
                     if(_loc4_ > displayWidth)
                     {
                        _loc12_ = (_loc7_.width - _loc7_.minWidth) / (_loc4_ - _loc11_);
                     }
                     else
                     {
                        _loc12_ = _loc7_.width / _loc4_;
                     }
                     _loc8_ = _loc7_.width - (_loc4_ - displayWidth) * _loc12_;
                     _loc14_ = visibleColumns[_loc3_].minWidth;
                     visibleColumns[_loc3_].setWidth(_loc8_ > _loc14_?_loc8_:_loc14_);
                  }
                  _loc13_ = _loc13_ - visibleColumns[_loc3_].width;
                  visibleColumns[_loc3_].newlyVisible = false;
                  _loc3_++;
               }
               if(_loc13_ && _loc7_)
               {
                  _loc7_.setWidth(_loc7_.width + _loc13_);
               }
            }
            else
            {
               _loc2_ = visibleLockedColumns.length;
               _loc3_ = 0;
               while(_loc3_ < _loc2_)
               {
                  _loc7_ = visibleLockedColumns[_loc3_];
                  _loc12_ = _loc7_.width / _loc4_;
                  _loc8_ = displayWidth * _loc12_;
                  _loc7_.setWidth(_loc8_);
                  _loc7_.explicitWidth = NaN;
                  _loc13_ = _loc13_ - _loc8_;
                  _loc3_++;
               }
               _loc2_ = visibleColumns.length;
               _loc3_ = 0;
               while(_loc3_ < _loc2_)
               {
                  _loc7_ = visibleColumns[_loc3_];
                  _loc12_ = _loc7_.width / _loc4_;
                  _loc8_ = displayWidth * _loc12_;
                  _loc7_.setWidth(_loc8_);
                  _loc7_.explicitWidth = NaN;
                  _loc13_ = _loc13_ - _loc8_;
                  _loc3_++;
               }
               if(_loc13_ && _loc7_)
               {
                  _loc7_.setWidth(_loc7_.width + _loc13_);
               }
            }
         }
         else
         {
            _loc4_ = 0;
            _loc2_ = visibleColumns.length;
            _loc3_ = 0;
            while(_loc3_ < _loc2_)
            {
               if(_loc4_ > displayWidth - lockedColumnWidth)
               {
                  visibleColumns.splice(_loc3_);
                  break;
               }
               _loc4_ = _loc4_ + (!!isNaN(visibleColumns[_loc3_].explicitWidth)?visibleColumns[_loc3_].preferredWidth:visibleColumns[_loc3_].explicitWidth);
               _loc3_++;
            }
            if(visibleColumns.length == 0)
            {
               return;
            }
            _loc3_ = visibleColumns[visibleColumns.length - 1].colNum + 1;
            if(_loc4_ < displayWidth - lockedColumnWidth && _loc3_ < displayableColumns.length)
            {
               _loc2_ = displayableColumns.length;
               while(_loc3_ < _loc2_ && _loc4_ < displayWidth - lockedColumnWidth)
               {
                  _loc5_ = displayableColumns[_loc3_];
                  visibleColumns.push(_loc5_);
                  _loc4_ = _loc4_ + (!!isNaN(_loc5_.explicitWidth)?_loc5_.preferredWidth:_loc5_.explicitWidth);
                  _loc3_++;
               }
            }
            else if(_loc4_ < displayWidth - lockedColumnWidth && horizontalScrollPosition > 0)
            {
               while(_loc4_ < displayWidth - lockedColumnWidth && horizontalScrollPosition > 0)
               {
                  _loc5_ = displayableColumns[lockedColumnCount + horizontalScrollPosition - 1];
                  _loc6_ = !!isNaN(_loc5_.explicitWidth)?Number(_loc5_.preferredWidth):Number(_loc5_.explicitWidth);
                  if(_loc6_ < displayWidth - lockedColumnWidth - _loc4_)
                  {
                     visibleColumns.splice(0,0,_loc5_);
                     _loc15_.super.horizontalScrollPosition = super.horizontalScrollPosition - 1;
                     _loc4_ = _loc4_ + _loc6_;
                     continue;
                  }
                  break;
               }
            }
            _loc7_ = visibleColumns[visibleColumns.length - 1];
            _loc6_ = !!isNaN(_loc7_.explicitWidth)?Number(_loc7_.preferredWidth):Number(_loc7_.explicitWidth);
            _loc8_ = _loc6_ + displayWidth - lockedColumnWidth - _loc4_;
            if(_loc7_ == displayableColumns[displayableColumns.length - 1] && _loc7_.resizable && _loc8_ >= _loc7_.minWidth && _loc8_ > _loc6_)
            {
               _loc7_.setWidth(_loc8_);
               maxHorizontalScrollPosition = displayableColumns.length - visibleColumns.length;
            }
            else if(visibleColumns.length == 1 && _loc7_ == displayableColumns[displayableColumns.length - 1])
            {
               maxHorizontalScrollPosition = displayableColumns.length - visibleColumns.length;
            }
            else
            {
               maxHorizontalScrollPosition = displayableColumns.length - visibleColumns.length + 1;
            }
         }
         lockedColumnWidth = 0;
         if(visibleLockedColumns.length)
         {
            _loc2_ = visibleLockedColumns.length;
            _loc3_ = 0;
            while(_loc3_ < _loc2_)
            {
               _loc5_ = visibleLockedColumns[_loc3_];
               lockedColumnWidth = lockedColumnWidth + _loc5_.width;
               _loc3_++;
            }
         }
      }
      
      private function beginningEdit(param1:int, param2:int, param3:IListItemRenderer = null) : void
      {
         var _loc4_:DataGridEvent = new DataGridEvent(DataGridEvent.ITEM_EDIT_BEGINNING,false,true);
         _loc4_.columnIndex = param1;
         _loc4_.dataField = _columns[param1].dataField;
         _loc4_.rowIndex = param2;
         _loc4_.itemRenderer = param3;
         if(!dispatchEvent(_loc4_))
         {
            lastEditedItemPosition = {
               "columnIndex":param1,
               "rowIndex":param2
            };
         }
      }
      
      protected function drawRowGraphics(param1:ListBaseContentHolder) : void
      {
         var _loc3_:Array = null;
         var _loc7_:int = 0;
         var _loc2_:Sprite = Sprite(param1.getChildByName("rowBGs"));
         if(!_loc2_)
         {
            _loc2_ = new FlexSprite();
            _loc2_.mouseEnabled = false;
            _loc2_.name = "rowBGs";
            param1.addChildAt(_loc2_,0);
         }
         _loc3_ = getStyle("alternatingItemColors");
         if(!_loc3_ || _loc3_.length == 0)
         {
            while(_loc2_.numChildren > _loc7_)
            {
               _loc2_.removeChildAt(_loc2_.numChildren - 1);
            }
            return;
         }
         StyleManager.getColorNames(_loc3_);
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = verticalScrollPosition;
         _loc7_ = param1.listItems.length;
         while(_loc4_ < _loc7_)
         {
            drawRowBackground(_loc2_,_loc5_++,param1.rowInfo[_loc4_].y,param1.rowInfo[_loc4_].height,_loc3_[_loc6_ % _loc3_.length],_loc6_);
            _loc4_++;
            _loc6_++;
         }
         while(_loc2_.numChildren > _loc5_)
         {
            _loc2_.removeChildAt(_loc2_.numChildren - 1);
         }
      }
      
      protected function drawHorizontalLine(param1:Sprite, param2:int, param3:uint, param4:Number) : void
      {
         var _loc5_:ListBaseContentHolder = param1.parent.parent as ListBaseContentHolder;
         var _loc6_:Graphics = param1.graphics;
         _loc6_.lineStyle(1,param3);
         _loc6_.moveTo(0,param4);
         _loc6_.lineTo(_loc5_.width,param4);
      }
      
      override protected function initializeAccessibility() : void
      {
         if(DataGrid.createAccessibilityImplementation != null)
         {
            DataGrid.createAccessibilityImplementation(this);
         }
      }
      
      private function endEdit(param1:String) : Boolean
      {
         if(!editedItemRenderer)
         {
            return true;
         }
         inEndEdit = true;
         var _loc2_:DataGridEvent = new DataGridEvent(DataGridEvent.ITEM_EDIT_END,false,true);
         _loc2_.columnIndex = editedItemPosition.columnIndex;
         _loc2_.dataField = _columns[editedItemPosition.columnIndex].dataField;
         _loc2_.rowIndex = editedItemPosition.rowIndex;
         _loc2_.itemRenderer = editedItemRenderer;
         _loc2_.reason = param1;
         dispatchEvent(_loc2_);
         dontEdit = itemEditorInstance != null;
         if(!dontEdit && param1 == DataGridEventReason.CANCELLED)
         {
            losingFocus = true;
            setFocus();
         }
         inEndEdit = false;
         return !_loc2_.isDefaultPrevented();
      }
      
      private function editorKeyDownHandler(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == Keyboard.ESCAPE)
         {
            endEdit(DataGridEventReason.CANCELLED);
         }
         else if(param1.ctrlKey && param1.charCode == 46)
         {
            endEdit(DataGridEventReason.CANCELLED);
         }
         else if(param1.charCode == Keyboard.ENTER && param1.keyCode != 229)
         {
            if(!_editedItemPosition)
            {
               return;
            }
            if(columns[_editedItemPosition.columnIndex].editorUsesEnterKey)
            {
               return;
            }
            if(endEdit(DataGridEventReason.NEW_ROW) && !dontEdit)
            {
               findNextEnterItemRenderer(param1);
            }
         }
      }
      
      private function itemEditorFocusOutHandler(param1:FocusEvent) : void
      {
         if(param1.relatedObject && contains(param1.relatedObject))
         {
            return;
         }
         if(!param1.relatedObject)
         {
            return;
         }
         if(itemEditorInstance)
         {
            endEdit(DataGridEventReason.OTHER);
         }
      }
      
      override public function itemToLabel(param1:Object) : String
      {
         return displayableColumns[sortIndex == -1?0:sortIndex].itemToLabel(param1);
      }
      
      mx_internal function _drawSeparators() : void
      {
         drawSeparators();
      }
      
      override protected function configureScrollBars() : void
      {
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         if(columnsInvalid)
         {
            return;
         }
         if(!displayableColumns)
         {
            return;
         }
         var _loc1_:Array = this.listItems;
         if(visibleColumns && !visibleColumns.length && visibleLockedColumns && visibleLockedColumns.length)
         {
            _loc1_ = lockedColumnContent.listItems;
         }
         var _loc2_:Object = horizontalScrollBar;
         var _loc3_:Object = verticalScrollBar;
         var _loc4_:int = _loc1_.length;
         if(_loc4_ == 0)
         {
            if(_loc2_ || _loc3_)
            {
               if(listContent.height)
               {
                  setScrollBarProperties(0,0,0,0);
               }
            }
            return;
         }
         if(_loc4_ > 1 && displayingPartialRow())
         {
            _loc4_--;
         }
         var _loc5_:int = verticalScrollPosition;
         var _loc6_:int = 0;
         while(_loc4_ && _loc1_[_loc4_ - 1].length == 0)
         {
            if(collection && _loc4_ + _loc5_ >= collection.length - lockedRowCount)
            {
               _loc4_--;
               _loc6_++;
               continue;
            }
            break;
         }
         if(verticalScrollPosition > 0 && _loc6_ > 0)
         {
            if(adjustVerticalScrollPositionDownward(Math.max(_loc4_,1)))
            {
               return;
            }
         }
         _loc4_ = _loc4_ - (offscreenExtraRowsTop + offscreenExtraRowsBottom);
         var _loc7_:Boolean = collection && collection.length > 0;
         var _loc8_:int = _loc7_ && _loc4_ > 0?int(listItems[0].length):int(visibleColumns.length);
         if(_loc7_ && _loc4_ > 0 && _loc8_ > 1 && listItems[0][_loc8_ - 1].x + visibleColumns[_loc8_ - 1].width > displayWidth - listContent.x + viewMetrics.left)
         {
            _loc8_--;
         }
         else if(_loc8_ > 1 && !_loc7_)
         {
            _loc9_ = 0;
            _loc10_ = 0;
            while(_loc10_ < visibleColumns.length)
            {
               _loc9_ = _loc9_ + visibleColumns[_loc10_].width;
               _loc10_++;
            }
            if(_loc9_ > displayWidth - listContent.x + viewMetrics.left)
            {
               _loc8_--;
            }
         }
         setScrollBarProperties(displayableColumns.length - lockedColumnCount,Math.max(_loc8_,1),!!collection?int(collection.length - lockedRowCount):0,Math.max(_loc4_,1));
         if((!verticalScrollBar || !verticalScrollBar.visible) && collection && collection.length - lockedRowCount > _loc4_)
         {
            maxVerticalScrollPosition = collection.length - lockedRowCount - _loc4_;
         }
         if((!horizontalScrollBar || !horizontalScrollBar.visible) && displayableColumns.length - lockedColumnCount > _loc8_ - lockedColumnCount)
         {
            maxHorizontalScrollPosition = displayableColumns.length - lockedColumnCount - _loc8_;
         }
      }
      
      override public function set horizontalScrollPosition(param1:Number) : void
      {
         var _loc3_:CursorBookmark = null;
         var _loc4_:CursorBookmark = null;
         if(!initialized || listItems.length == 0)
         {
            super.horizontalScrollPosition = param1;
            return;
         }
         var _loc2_:int = super.horizontalScrollPosition;
         super.horizontalScrollPosition = param1;
         scrollAreaChanged = true;
         columnsInvalid = true;
         calculateColumnSizes();
         if(itemsSizeChanged)
         {
            return;
         }
         if(_loc2_ != param1)
         {
            removeClipMask();
            if(iterator)
            {
               _loc3_ = iterator.bookmark;
            }
            clearIndicators();
            clearVisibleData();
            makeRowsAndColumns(0,0,listContent.width,listContent.height,0,0);
            if(lockedRowCount)
            {
               _loc4_ = lockedRowContent.iterator.bookmark;
               makeRows(lockedRowContent,0,0,unscaledWidth,unscaledHeight,0,0,true,lockedRowCount);
               if(iteratorValid)
               {
                  lockedRowContent.iterator.seek(_loc4_,0);
               }
            }
            if(headerVisible && header)
            {
               header.visibleColumns = visibleColumns;
               header.headerItemsChanged = true;
               header.invalidateSize();
               header.validateNow();
            }
            if(iterator && _loc3_)
            {
               iterator.seek(_loc3_,0);
            }
            invalidateDisplayList();
            addClipMask(false);
         }
      }
      
      protected function drawColumnBackground(param1:Sprite, param2:int, param3:uint, param4:DataGridColumn) : void
      {
         var _loc5_:Shape = null;
         _loc5_ = Shape(param1.getChildByName(param2.toString()));
         if(!_loc5_)
         {
            _loc5_ = new FlexShape();
            param1.addChild(_loc5_);
            _loc5_.name = param2.toString();
         }
         var _loc6_:Graphics = _loc5_.graphics;
         _loc6_.clear();
         _loc6_.beginFill(param3);
         var _loc7_:Object = rowInfo[listItems.length - 1];
         var _loc8_:DataGridHeader = param1.parent == lockedColumnContent?DataGridHeader(lockedColumnHeader):DataGridHeader(header);
         var _loc9_:Number = _loc8_.rendererArray[param2].x;
         var _loc10_:Number = rowInfo[0].y;
         var _loc11_:Number = Math.min(_loc7_.y + _loc7_.height,listContent.height - _loc10_);
         _loc6_.drawRect(_loc9_,_loc10_,_loc8_.visibleColumns[param2].width,listContent.height - _loc10_);
         _loc6_.endFill();
      }
      
      override public function set columns(param1:Array) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:DataGridColumn = null;
         var _loc5_:DisplayObject = null;
         _loc2_ = _columns.length;
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            columnRendererChanged(_columns[_loc3_]);
            _loc3_++;
         }
         freeItemRenderersTable = new Dictionary(false);
         columnMap = {};
         _columns = param1.slice(0);
         columnsInvalid = true;
         generatedColumns = false;
         _loc2_ = param1.length;
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = _columns[_loc3_];
            _loc4_.owner = this;
            _loc4_.colNum = _loc3_;
            if(_loc4_.cachedHeaderRenderer)
            {
               _loc5_ = _loc4_.cachedHeaderRenderer as DisplayObject;
               if(_loc5_.parent)
               {
                  _loc5_.parent.removeChild(_loc5_);
               }
               _loc4_.cachedHeaderRenderer = null;
            }
            _loc3_++;
         }
         updateSortIndexAndDirection();
         itemsSizeChanged = true;
         invalidateDisplayList();
         dispatchEvent(new Event("columnsChanged"));
      }
      
      override protected function mouseWheelHandler(param1:MouseEvent) : void
      {
         if(itemEditorInstance)
         {
            endEdit(DataGridEventReason.OTHER);
         }
         super.mouseWheelHandler(param1);
      }
      
      public function get editedItemRenderer() : IListItemRenderer
      {
         if(!itemEditorInstance)
         {
            return null;
         }
         return actualContentHolder.listItems[actualRowIndex][actualColIndex];
      }
      
      public function set minColumnWidth(param1:Number) : void
      {
         _minColumnWidth = param1;
         minColumnWidthInvalid = true;
         itemsSizeChanged = true;
         columnsInvalid = true;
         invalidateDisplayList();
      }
      
      override public function set focusPane(param1:Sprite) : void
      {
         super.focusPane = param1;
         if(!param1 && _focusPane)
         {
            _focusPane.mask = null;
         }
         _focusPane = param1;
      }
      
      override mx_internal function get rendererArray() : Array
      {
         var _loc1_:Array = listItems.slice();
         var _loc2_:Array = DataGridHeader(header).rendererArray;
         _loc1_.unshift(_loc2_);
         return _loc1_;
      }
      
      override protected function commitProperties() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         var _loc3_:Object = null;
         var _loc4_:IListItemRenderer = null;
         var _loc5_:DataGridColumn = null;
         var _loc6_:Number = NaN;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         super.commitProperties();
         if(itemsNeedMeasurement)
         {
            itemsNeedMeasurement = false;
            if(isNaN(explicitRowHeight))
            {
               if(iterator && columns.length > 0)
               {
                  visibleColumns = columns;
                  columnsInvalid = true;
                  _loc1_ = getStyle("paddingTop");
                  _loc2_ = getStyle("paddingBottom");
                  _loc3_ = iterator.current;
                  _loc6_ = 0;
                  _loc7_ = columns.length;
                  _loc8_ = 0;
                  while(_loc8_ < _loc7_)
                  {
                     _loc5_ = columns[_loc8_];
                     if(_loc5_.visible)
                     {
                        _loc4_ = _loc5_.getMeasuringRenderer(false,_loc3_);
                        if(DisplayObject(_loc4_).parent == null)
                        {
                           listContent.addChild(DisplayObject(_loc4_));
                        }
                        setupRendererFromData(_loc5_,_loc4_,_loc3_);
                        _loc6_ = Math.max(_loc6_,_loc4_.getExplicitOrMeasuredHeight() + _loc2_ + _loc1_);
                     }
                     _loc8_++;
                  }
                  setRowHeight(Math.max(_loc6_,20));
               }
               else
               {
                  setRowHeight(20);
               }
            }
         }
      }
      
      protected function drawRowBackground(param1:Sprite, param2:int, param3:Number, param4:Number, param5:uint, param6:int) : void
      {
         var _loc8_:Shape = null;
         var _loc7_:ListBaseContentHolder = ListBaseContentHolder(param1.parent);
         if(param2 < param1.numChildren)
         {
            _loc8_ = Shape(param1.getChildAt(param2));
         }
         else
         {
            _loc8_ = new FlexShape();
            _loc8_.name = "background";
            param1.addChild(_loc8_);
         }
         _loc8_.y = param3;
         param4 = Math.min(param4,_loc7_.height - param3);
         var _loc9_:Graphics = _loc8_.graphics;
         _loc9_.clear();
         _loc9_.beginFill(param5,getStyle("backgroundAlpha"));
         _loc9_.drawRect(0,0,_loc7_.width,param4);
         _loc9_.endFill();
      }
      
      private function adjustVerticalScrollPositionDownward(param1:int) : Boolean
      {
         var item:IListItemRenderer = null;
         var c:DataGridColumn = null;
         var n:int = 0;
         var j:int = 0;
         var bMore:Boolean = false;
         var data:Object = null;
         var rowCount:int = param1;
         var bookmark:CursorBookmark = iterator.bookmark;
         var h:Number = 0;
         var ch:Number = 0;
         var paddingTop:Number = getStyle("paddingTop");
         var paddingBottom:Number = getStyle("paddingBottom");
         h = rowInfo[rowCount - 1].y + rowInfo[rowCount - 1].height;
         h = listContent.heightExcludingOffsets - listContent.topOffset - h;
         var numRows:int = 0;
         try
         {
            if(iterator.afterLast)
            {
               iterator.seek(CursorBookmark.LAST,0);
            }
            else
            {
               bMore = iterator.movePrevious();
            }
         }
         catch(e:ItemPendingError)
         {
            bMore = false;
         }
         if(!bMore)
         {
            super.verticalScrollPosition = 0;
            try
            {
               iterator.seek(CursorBookmark.FIRST,0);
               if(!iteratorValid)
               {
                  iteratorValid = true;
                  lastSeekPending = null;
               }
            }
            catch(e:ItemPendingError)
            {
               lastSeekPending = new ListBaseSeekPending(CursorBookmark.FIRST,0);
               e.addResponder(new ItemResponder(seekPendingResultHandler,seekPendingFailureHandler,lastSeekPending));
               iteratorValid = false;
               invalidateList();
               return true;
            }
            updateList();
            return true;
         }
         while(h > 0 && bMore)
         {
            if(bMore)
            {
               data = iterator.current;
               ch = 0;
               n = columns.length;
               j = 0;
               while(j < n)
               {
                  c = columns[j];
                  if(c.visible)
                  {
                     if(variableRowHeight)
                     {
                        item = c.getMeasuringRenderer(false,data);
                        if(DisplayObject(item).parent == null)
                        {
                           listContent.addChild(DisplayObject(item));
                        }
                        setupRendererFromData(c,item,data);
                     }
                     ch = Math.max(ch,!!variableRowHeight?Number(item.getExplicitOrMeasuredHeight() + paddingBottom + paddingTop):Number(rowHeight));
                  }
                  j++;
               }
            }
            h = h - ch;
            try
            {
               bMore = iterator.movePrevious();
               numRows++;
            }
            catch(e:ItemPendingError)
            {
               bMore = false;
               continue;
            }
         }
         if(h < 0)
         {
            numRows--;
         }
         iterator.seek(bookmark,0);
         verticalScrollPosition = Math.max(0,verticalScrollPosition - numRows);
         if(numRows > 0 && !variableRowHeight)
         {
            configureScrollBars();
         }
         return numRows > 0;
      }
      
      override protected function calculateRowHeight(param1:Object, param2:Number, param3:Boolean = false) : Number
      {
         var _loc4_:IListItemRenderer = null;
         var _loc5_:DataGridColumn = null;
         var _loc7_:int = 0;
         var _loc6_:int = columns.length;
         var _loc8_:int = 0;
         var _loc9_:int = visibleLockedColumns.length;
         if(param3 && visibleColumns.length == _columns.length)
         {
            return param2;
         }
         var _loc10_:Number = getStyle("paddingTop");
         var _loc11_:Number = getStyle("paddingBottom");
         _loc7_ = 0;
         while(_loc7_ < _loc6_)
         {
            if(param3 && _loc8_ < _loc9_ && visibleLockedColumns[_loc8_].colNum == columns[_loc7_].colNum)
            {
               _loc8_++;
            }
            else if(param3 && _loc8_ - _loc9_ < visibleColumns.length && visibleColumns[_loc8_ - _loc9_].colNum == columns[_loc7_].colNum)
            {
               _loc8_++;
            }
            else
            {
               _loc5_ = columns[_loc7_];
               if(_loc5_.visible)
               {
                  _loc4_ = _loc5_.getMeasuringRenderer(false,param1);
                  if(DisplayObject(_loc4_).parent == null)
                  {
                     listContent.addChild(DisplayObject(_loc4_));
                  }
                  setupRendererFromData(_loc5_,_loc4_,param1);
                  param2 = Math.max(param2,_loc4_.getExplicitOrMeasuredHeight() + _loc11_ + _loc10_);
               }
            }
            _loc7_++;
         }
         return param2;
      }
      
      [Bindable("columnsChanged")]
      override public function get columns() : Array
      {
         return _columns.slice(0);
      }
      
      override protected function scrollHandler(param1:Event) : void
      {
         var _loc2_:ScrollBar = null;
         var _loc3_:Number = NaN;
         if(param1.target == verticalScrollBar || param1.target == horizontalScrollBar)
         {
            if(param1 is ScrollEvent)
            {
               if(!liveScrolling && ScrollEvent(param1).detail == ScrollEventDetail.THUMB_TRACK)
               {
                  return;
               }
               if(itemEditorInstance)
               {
                  endEdit(DataGridEventReason.OTHER);
               }
               _loc2_ = ScrollBar(param1.target);
               _loc3_ = _loc2_.scrollPosition;
               if(_loc2_ == verticalScrollBar)
               {
                  verticalScrollPosition = _loc3_;
               }
               else if(_loc2_ == horizontalScrollBar)
               {
                  horizontalScrollPosition = _loc3_;
               }
               super.scrollHandler(param1);
            }
         }
      }
      
      public function isItemEditable(param1:Object) : Boolean
      {
         if(!editable)
         {
            return false;
         }
         if(!param1)
         {
            return false;
         }
         return true;
      }
      
      mx_internal function _placeSortArrow() : void
      {
         placeSortArrow();
      }
      
      protected function drawLinesAndColumnGraphics(param1:ListBaseContentHolder, param2:Array, param3:Object) : void
      {
         var _loc8_:uint = 0;
         var _loc9_:int = 0;
         var _loc13_:Number = NaN;
         var _loc14_:Sprite = null;
         var _loc15_:int = 0;
         var _loc16_:Number = NaN;
         var _loc17_:DataGridColumn = null;
         var _loc18_:Object = null;
         var _loc19_:Shape = null;
         var _loc20_:Graphics = null;
         var _loc21_:DisplayObject = null;
         var _loc4_:Sprite = Sprite(param1.getChildByName("lines"));
         if(!_loc4_)
         {
            _loc4_ = new UIComponent();
            _loc4_.name = "lines";
            _loc4_.cacheAsBitmap = true;
            _loc4_.mouseEnabled = false;
            param1.addChild(_loc4_);
         }
         param1.setChildIndex(_loc4_,param1.numChildren - 1);
         var _loc5_:Array = param1.rowInfo;
         _loc4_.graphics.clear();
         var _loc6_:Sprite = Sprite(_loc4_.getChildByName("body"));
         if(!_loc6_)
         {
            _loc6_ = new UIComponent();
            _loc6_.name = "body";
            _loc6_.mouseEnabled = false;
            _loc4_.addChild(_loc6_);
         }
         _loc6_.graphics.clear();
         while(_loc6_.numChildren)
         {
            _loc6_.removeChildAt(0);
         }
         var _loc7_:Number = unscaledHeight - 1;
         var _loc10_:uint = !!param2?uint(param2.length):uint(0);
         var _loc11_:uint = param1.listItems.length;
         _loc8_ = getStyle("horizontalGridLineColor");
         if(getStyle("horizontalGridLines"))
         {
            _loc9_ = 0;
            while(_loc9_ < _loc11_)
            {
               _loc13_ = _loc5_[_loc9_].y + _loc5_[_loc9_].height;
               if(_loc13_ < param1.height)
               {
                  drawHorizontalSeparator(_loc6_,_loc9_,_loc8_,_loc13_);
               }
               _loc9_++;
            }
         }
         if(param3.top)
         {
            drawHorizontalSeparator(_loc6_,_loc9_++,0,_loc5_[0].y,true);
         }
         if(param3.bottom && _loc11_ > 0)
         {
            drawHorizontalSeparator(_loc6_,_loc9_++,0,_loc5_[_loc11_ - 1].y + _loc5_[_loc11_ - 1].height,true);
         }
         var _loc12_:Boolean = getStyle("verticalGridLines");
         _loc8_ = getStyle("verticalGridLineColor");
         if(_loc10_)
         {
            _loc14_ = Sprite(param1.getChildByName("colBGs"));
            _loc15_ = -1;
            _loc16_ = 0;
            _loc9_ = 0;
            while(_loc9_ < _loc10_)
            {
               if(_loc12_ && _loc9_ < _loc10_ - 1)
               {
                  drawVerticalSeparator(_loc6_,_loc9_,_loc8_,_loc16_ + param2[_loc9_].width);
               }
               _loc17_ = param2[_loc9_];
               if(enabled)
               {
                  _loc18_ = _loc17_.getStyle("backgroundColor");
               }
               else
               {
                  _loc18_ = _loc17_.getStyle("backgroundDisabledColor");
               }
               if(_loc18_ !== null && !isNaN(Number(_loc18_)))
               {
                  if(!_loc14_)
                  {
                     _loc14_ = new FlexSprite();
                     _loc14_.mouseEnabled = false;
                     _loc14_.name = "colBGs";
                     param1.addChildAt(_loc14_,param1.getChildIndex(param1.getChildByName("rowBGs")) + 1);
                  }
                  drawColumnBackground(_loc14_,_loc9_,Number(_loc18_),_loc17_);
                  _loc15_ = _loc9_;
               }
               else if(_loc14_)
               {
                  _loc19_ = Shape(_loc14_.getChildByName(_loc9_.toString()));
                  if(_loc19_)
                  {
                     _loc20_ = _loc19_.graphics;
                     _loc20_.clear();
                     _loc14_.removeChild(_loc19_);
                  }
               }
               _loc16_ = _loc16_ + param2[_loc9_].width;
               _loc9_++;
            }
            if(_loc14_ && _loc14_.numChildren)
            {
               while(_loc14_.numChildren)
               {
                  _loc21_ = _loc14_.getChildAt(_loc14_.numChildren - 1);
                  if(parseInt(_loc21_.name) > _loc15_)
                  {
                     _loc14_.removeChild(_loc21_);
                     continue;
                  }
                  break;
               }
            }
         }
         if(param3.right && param2 && param2.length)
         {
            if(param1.listItems.length && param1.listItems[0].length)
            {
               drawVerticalSeparator(_loc6_,_loc9_++,0,param1.listItems[0][_loc10_ - 1].x + param2[_loc10_ - 1].width,true);
            }
            else
            {
               _loc16_ = 0;
               _loc9_ = 0;
               while(_loc9_ < _loc10_)
               {
                  _loc16_ = _loc16_ + param2[_loc9_].width;
                  _loc9_++;
               }
               drawVerticalSeparator(_loc6_,_loc9_++,0,_loc16_,true);
            }
         }
         if(param3.left)
         {
            drawVerticalSeparator(_loc6_,_loc9_++,0,0,true);
         }
      }
      
      protected function placeSortArrow() : void
      {
         DataGridHeader(header)._placeSortArrow();
         if(lockedColumnHeader)
         {
            DataGridHeader(lockedColumnHeader)._placeSortArrow();
         }
      }
      
      private function commitEditedItemPosition(param1:Object) : void
      {
         var _loc7_:String = null;
         var _loc8_:int = 0;
         var _loc9_:ListEvent = null;
         if(!enabled || !editable)
         {
            return;
         }
         if(!collection || collection.length == 0)
         {
            return;
         }
         if(itemEditorInstance && param1 && itemEditorInstance is IFocusManagerComponent && _editedItemPosition.rowIndex == param1.rowIndex && _editedItemPosition.columnIndex == param1.columnIndex)
         {
            IFocusManagerComponent(itemEditorInstance).setFocus();
            return;
         }
         if(itemEditorInstance)
         {
            if(!param1)
            {
               _loc7_ = DataGridEventReason.OTHER;
            }
            else
            {
               _loc7_ = !editedItemPosition || param1.rowIndex == editedItemPosition.rowIndex?DataGridEventReason.NEW_COLUMN:DataGridEventReason.NEW_ROW;
            }
            if(!endEdit(_loc7_) && _loc7_ != DataGridEventReason.OTHER)
            {
               return;
            }
         }
         _editedItemPosition = param1;
         if(!param1)
         {
            return;
         }
         if(dontEdit)
         {
            return;
         }
         var _loc2_:int = param1.rowIndex;
         var _loc3_:int = param1.columnIndex;
         if(displayableColumns.length != _columns.length)
         {
            _loc8_ = 0;
            while(_loc8_ < displayableColumns.length)
            {
               if(displayableColumns[_loc8_].colNum >= _loc3_)
               {
                  _loc3_ = _loc8_;
                  break;
               }
               _loc8_++;
            }
            if(_loc8_ == displayableColumns.length)
            {
               _loc3_ = 0;
            }
         }
         var _loc4_:Boolean = false;
         if(selectedIndex != param1.rowIndex)
         {
            commitSelectedIndex(param1.rowIndex);
            _loc4_ = true;
         }
         scrollToEditedItem(_loc2_,_loc3_);
         var _loc5_:IListItemRenderer = actualContentHolder.listItems[actualRowIndex][actualColIndex];
         if(!_loc5_)
         {
            commitEditedItemPosition(null);
            return;
         }
         if(!isItemEditable(_loc5_.data))
         {
            commitEditedItemPosition(null);
            return;
         }
         if(_loc4_)
         {
            _loc9_ = new ListEvent(ListEvent.CHANGE);
            _loc9_.columnIndex = param1.columnIndex;
            _loc9_.rowIndex = param1.rowIndex;
            _loc9_.itemRenderer = _loc5_;
            dispatchEvent(_loc9_);
         }
         var _loc6_:DataGridEvent = new DataGridEvent(DataGridEvent.ITEM_EDIT_BEGIN,false,true);
         _loc6_.columnIndex = displayableColumns[_loc3_].colNum;
         _loc6_.rowIndex = _editedItemPosition.rowIndex;
         _loc6_.itemRenderer = _loc5_;
         dispatchEvent(_loc6_);
         lastEditedItemPosition = _editedItemPosition;
         if(bEditedItemPositionChanged)
         {
            bEditedItemPositionChanged = false;
            commitEditedItemPosition(_proposedEditedItemPosition);
            _proposedEditedItemPosition = undefined;
         }
         if(!itemEditorInstance)
         {
            commitEditedItemPosition(null);
         }
      }
      
      protected function getCurrentDataValue(param1:Object, param2:String) : String
      {
         if(!isComplexColumn(param2))
         {
            return param1[param2];
         }
         var _loc3_:Array = param2.split(".");
         var _loc4_:Object = deriveComplexFieldReference(param1,_loc3_);
         return String(_loc4_);
      }
      
      private function editorStageResizeHandler(param1:Event) : void
      {
         if(param1.target is DisplayObjectContainer && DisplayObjectContainer(param1.target).contains(this))
         {
            endEdit(DataGridEventReason.OTHER);
         }
      }
      
      private function generateColumnsPendingResultHandler(param1:Object, param2:ListBaseSeekPending) : void
      {
         if(columns.length == 0)
         {
            generateCols();
         }
         seekPendingResultHandler(param1,param2);
      }
      
      protected function drawVerticalLine(param1:Sprite, param2:int, param3:uint, param4:Number) : void
      {
         var _loc5_:ListBaseContentHolder = param1.parent.parent as ListBaseContentHolder;
         var _loc6_:Graphics = param1.graphics;
         _loc6_.lineStyle(1,param3,100);
         _loc6_.moveTo(param4,!!headerVisible?Number(0):Number(1));
         _loc6_.lineTo(param4,_loc5_.height);
      }
      
      private function editorMouseDownHandler(param1:Event) : void
      {
         if(param1 is MouseEvent && owns(DisplayObject(param1.target)))
         {
            return;
         }
         endEdit(DataGridEventReason.OTHER);
         losingFocus = true;
         setFocus();
      }
      
      override protected function adjustListContent(param1:Number = -1, param2:Number = -1) : void
      {
         var ww:Number = NaN;
         var lcx:Number = NaN;
         var lcy:Number = NaN;
         var hcx:Number = NaN;
         var pt:Point = null;
         var unscaledWidth:Number = param1;
         var unscaledHeight:Number = param2;
         var hh:Number = 0;
         if(headerVisible)
         {
            if(lockedColumnCount > 0)
            {
               lockedColumnHeader.visible = true;
               hcx = viewMetrics.left + Math.min(DataGridHeader(lockedColumnHeader).leftOffset,0);
               lockedColumnHeader.move(hcx,viewMetrics.top);
               hh = lockedColumnHeader.getExplicitOrMeasuredHeight();
               lockedColumnHeader.setActualSize(lockedColumnWidth + 1,hh);
               DataGridHeader(lockedColumnHeader).needRightSeparator = true;
               DataGridHeader(lockedColumnHeader).needRightSeparatorEvents = true;
            }
            header.visible = true;
            hcx = viewMetrics.left + lockedColumnWidth + Math.min(DataGridHeader(header).leftOffset,0);
            header.move(hcx,viewMetrics.top);
            if(verticalScrollBar != null && verticalScrollBar.visible && (horizontalScrollBar == null || !horizontalScrollBar.visible) && headerVisible && roomForScrollBar(verticalScrollBar,unscaledWidth,unscaledHeight - header.height))
            {
               ww = Math.max(0,DataGridHeader(header).rightOffset) - hcx - borderMetrics.right;
            }
            else
            {
               ww = Math.max(0,DataGridHeader(header).rightOffset) - hcx - viewMetrics.right;
            }
            hh = header.getExplicitOrMeasuredHeight();
            header.setActualSize(unscaledWidth + ww,hh);
            if(!skipHeaderUpdate)
            {
               header.headerItemsChanged = true;
               header.invalidateDisplayList();
            }
         }
         else
         {
            header.visible = false;
            if(lockedColumnCount > 0)
            {
               lockedColumnHeader.visible = false;
            }
         }
         if(lockedRowCount > 0 && lockedRowContent && lockedRowContent.iterator)
         {
            try
            {
               lockedRowContent.iterator.seek(CursorBookmark.FIRST);
               pt = makeRows(lockedRowContent,0,0,unscaledWidth,unscaledHeight,0,0,true,lockedRowCount,true);
               if(lockedColumnCount > 0)
               {
                  lcx = viewMetrics.left + Math.min(lockedColumnAndRowContent.leftOffset,0);
                  lcy = viewMetrics.top + Math.min(lockedColumnAndRowContent.topOffset,0) + Math.ceil(hh);
                  lockedColumnAndRowContent.move(lcx,lcy);
                  lockedColumnAndRowContent.setActualSize(lockedColumnWidth,lockedColumnAndRowContent.getExplicitOrMeasuredHeight());
               }
               lcx = viewMetrics.left + lockedColumnWidth + Math.min(lockedRowContent.leftOffset,0);
               lcy = viewMetrics.top + Math.min(lockedRowContent.topOffset,0) + Math.ceil(hh);
               lockedRowContent.move(lcx,lcy);
               ww = Math.max(0,lockedRowContent.rightOffset) - lcx - viewMetrics.right;
               lockedRowContent.setActualSize(unscaledWidth + ww,lockedRowContent.getExplicitOrMeasuredHeight());
               hh = hh + lockedRowContent.getExplicitOrMeasuredHeight();
            }
            catch(e:ItemPendingError)
            {
               e.addResponder(new ItemResponder(lockedRowSeekPendingResultHandler,seekPendingFailureHandler,null));
            }
         }
         if(lockedColumnCount > 0)
         {
            lcx = viewMetrics.left + Math.min(lockedColumnContent.leftOffset,0);
            lcy = viewMetrics.top + Math.min(lockedColumnContent.topOffset,0) + Math.ceil(hh);
            lockedColumnContent.move(lcx,lcy);
            ww = lockedColumnWidth + lockedColumnContent.rightOffset - lockedColumnContent.leftOffset;
            lockedColumnContent.setActualSize(ww,unscaledHeight + Math.max(0,lockedColumnContent.bottomOffset) - lcy - viewMetrics.bottom);
         }
         lcx = viewMetrics.left + lockedColumnWidth + Math.min(listContent.leftOffset,0);
         lcy = viewMetrics.top + Math.min(listContent.topOffset,0) + Math.ceil(hh);
         listContent.move(lcx,lcy);
         ww = Math.max(0,listContent.rightOffset) - lcx - viewMetrics.right;
         hh = Math.max(0,listContent.bottomOffset) - lcy - viewMetrics.bottom;
         listContent.setActualSize(Math.max(0,unscaledWidth + ww),Math.max(0,unscaledHeight + hh));
      }
      
      mx_internal function setupRendererFromData(param1:DataGridColumn, param2:IListItemRenderer, param3:Object) : void
      {
         var _loc4_:DataGridListData = DataGridListData(makeListData(param3,itemToUID(param3),0,param1.colNum,param1));
         if(param2 is IDropInListItemRenderer)
         {
            IDropInListItemRenderer(param2).listData = !!param3?_loc4_:null;
         }
         param2.data = param3;
         param2.explicitWidth = getWidthOfItem(param2,param1);
         UIComponentGlobals.layoutManager.validateClient(param2,true);
      }
      
      override public function get itemRenderer() : IFactory
      {
         var _loc1_:String = null;
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc4_:* = false;
         var _loc5_:* = false;
         var _loc6_:IFlexModuleFactory = null;
         if(super.itemRenderer == null)
         {
            _loc1_ = StringUtil.trimArrayElements(getStyle("fontFamily"),",");
            _loc2_ = getStyle("fontWeight");
            _loc3_ = getStyle("fontStyle");
            _loc4_ = _loc2_ == "bold";
            _loc5_ = _loc3_ == "italic";
            _loc6_ = getFontContext(_loc1_,_loc4_,_loc5_);
            super.itemRenderer = new ContextualClassFactory(DataGridItemRenderer,_loc6_);
         }
         return super.itemRenderer;
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:EdgeMetrics = null;
         if(displayWidth != param1 - viewMetrics.right - viewMetrics.left)
         {
            displayWidth = param1 - viewMetrics.right - viewMetrics.left;
            columnsInvalid = true;
         }
         calculateColumnSizes();
         if(itemEditorPositionChanged)
         {
            itemEditorPositionChanged = false;
            if(!lastItemDown)
            {
               scrollToEditedItem(editedItemPosition.rowIndex,editedItemPosition.colIndex);
            }
         }
         super.updateDisplayList(param1,param2);
         if(collection && collection.length)
         {
            setRowCount(listItems.length);
            if(listItems.length)
            {
               setColumnCount(listItems[0].length);
            }
            else
            {
               setColumnCount(0);
            }
         }
         if(verticalScrollBar != null && verticalScrollBar.visible && (horizontalScrollBar == null || !horizontalScrollBar.visible) && headerVisible)
         {
            _loc3_ = header.height;
            _loc4_ = borderMetrics;
            if(roomForScrollBar(verticalScrollBar,param1 - _loc4_.left - _loc4_.right,param2 - _loc3_ - _loc4_.top - _loc4_.bottom))
            {
               verticalScrollBar.move(verticalScrollBar.x,viewMetrics.top + _loc3_);
               verticalScrollBar.setActualSize(verticalScrollBar.width,param2 - viewMetrics.top - viewMetrics.bottom - _loc3_);
               verticalScrollBar.visible = true;
               headerMask.width = headerMask.width + verticalScrollBar.getExplicitOrMeasuredWidth();
               if(!DataGridHeader(header).needRightSeparator)
               {
                  header.invalidateDisplayList();
                  DataGridHeader(header).needRightSeparator = true;
               }
            }
            else if(DataGridHeader(header).needRightSeparator)
            {
               header.invalidateDisplayList();
               DataGridHeader(header).needRightSeparator = false;
            }
         }
         else if(DataGridHeader(header).needRightSeparator)
         {
            header.invalidateDisplayList();
            DataGridHeader(header).needRightSeparator = false;
         }
         if(bEditedItemPositionChanged)
         {
            bEditedItemPositionChanged = false;
            if(!lastItemDown)
            {
               commitEditedItemPosition(_proposedEditedItemPosition);
            }
            _proposedEditedItemPosition = undefined;
            itemsSizeChanged = false;
         }
         drawRowBackgrounds();
         drawLinesAndColumnBackgrounds();
         if(lockedRowCount && lockedRowContent)
         {
            drawRowGraphics(lockedRowContent);
            drawLinesAndColumnGraphics(lockedRowContent,visibleColumns,{"bottom":1});
            if(lockedColumnCount)
            {
               drawRowGraphics(lockedColumnAndRowContent);
               drawLinesAndColumnGraphics(lockedColumnAndRowContent,visibleLockedColumns,{
                  "right":1,
                  "bottom":1
               });
            }
         }
         if(lockedColumnCount)
         {
            drawRowGraphics(lockedColumnContent);
            drawLinesAndColumnGraphics(lockedColumnContent,visibleLockedColumns,{"right":1});
         }
      }
      
      mx_internal function shiftColumns(param1:int, param2:int, param3:Event = null) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:IndexChangedEvent = null;
         var _loc7_:int = 0;
         var _loc8_:DataGridColumn = null;
         if(param2 >= 0 && param1 != param2)
         {
            _loc4_ = param1 < param2?1:-1;
            _loc5_ = param1;
            while(_loc5_ != param2)
            {
               _loc7_ = _loc5_ + _loc4_;
               _loc8_ = _columns[_loc5_];
               _columns[_loc5_] = _columns[_loc7_];
               _columns[_loc7_] = _loc8_;
               _columns[_loc5_].colNum = _loc5_;
               _columns[_loc7_].colNum = _loc7_;
               _loc5_ = _loc5_ + _loc4_;
            }
            if(sortIndex == param1)
            {
               sortIndex = sortIndex + (param2 - param1);
            }
            else if(param1 < sortIndex && sortIndex <= param2 || param2 <= sortIndex && sortIndex < param1)
            {
               sortIndex = sortIndex - _loc4_;
            }
            if(lastSortIndex == param1)
            {
               lastSortIndex = lastSortIndex + (param2 - param1);
            }
            else if(param1 < lastSortIndex && lastSortIndex <= param2 || param2 <= lastSortIndex && lastSortIndex < param1)
            {
               lastSortIndex = lastSortIndex - _loc4_;
            }
            columnsInvalid = true;
            itemsSizeChanged = true;
            invalidateDisplayList();
            if(lockedColumnHeader)
            {
               lockedColumnHeader.invalidateDisplayList();
            }
            _loc6_ = new IndexChangedEvent(IndexChangedEvent.HEADER_SHIFT);
            _loc6_.oldIndex = param1;
            _loc6_.newIndex = param2;
            _loc6_.triggerEvent = param3;
            dispatchEvent(_loc6_);
         }
      }
      
      override public function hideDropFeedback(param1:DragEvent) : void
      {
         super.hideDropFeedback(param1);
         if(lockedColumnDropIndicator)
         {
            DisplayObject(lockedColumnDropIndicator).parent.removeChild(DisplayObject(lockedColumnDropIndicator));
            lockedColumnDropIndicator = null;
         }
      }
      
      override protected function dragStartHandler(param1:DragEvent) : void
      {
         if(collectionUpdatesDisabled)
         {
            collection.enableAutoUpdate();
            collectionUpdatesDisabled = false;
         }
         super.dragStartHandler(param1);
      }
      
      protected function drawHeaderBackground(param1:UIComponent) : void
      {
         DataGridHeader(param1.parent)._drawHeaderBackground(param1);
      }
   }
}
