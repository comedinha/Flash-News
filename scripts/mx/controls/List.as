package mx.controls
{
   import flash.display.DisplayObject;
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
   import mx.collections.CursorBookmark;
   import mx.collections.IList;
   import mx.collections.ItemResponder;
   import mx.collections.ItemWrapper;
   import mx.collections.ModifiedCollectionView;
   import mx.collections.errors.ItemPendingError;
   import mx.controls.listClasses.BaseListData;
   import mx.controls.listClasses.IDropInListItemRenderer;
   import mx.controls.listClasses.IListItemRenderer;
   import mx.controls.listClasses.ListBase;
   import mx.controls.listClasses.ListBaseSeekPending;
   import mx.controls.listClasses.ListData;
   import mx.controls.listClasses.ListItemRenderer;
   import mx.controls.listClasses.ListRowInfo;
   import mx.controls.scrollClasses.ScrollBar;
   import mx.core.ClassFactory;
   import mx.core.EdgeMetrics;
   import mx.core.EventPriority;
   import mx.core.FlexShape;
   import mx.core.FlexSprite;
   import mx.core.FlexVersion;
   import mx.core.IFactory;
   import mx.core.IIMESupport;
   import mx.core.IInvalidating;
   import mx.core.IPropertyChangeNotifier;
   import mx.core.ScrollPolicy;
   import mx.core.UIComponent;
   import mx.core.UIComponentGlobals;
   import mx.core.mx_internal;
   import mx.events.CollectionEvent;
   import mx.events.CollectionEventKind;
   import mx.events.ListEvent;
   import mx.events.ListEventReason;
   import mx.events.SandboxMouseEvent;
   import mx.events.ScrollEvent;
   import mx.events.ScrollEventDetail;
   import mx.managers.IFocusManager;
   import mx.managers.IFocusManagerComponent;
   import mx.styles.StyleManager;
   
   use namespace mx_internal;
   
   public class List extends ListBase implements IIMESupport
   {
      
      mx_internal static const VERSION:String = "3.6.0.21751";
      
      mx_internal static var createAccessibilityImplementation:Function;
       
      
      public var editorXOffset:Number = 0;
      
      public var itemEditorInstance:IListItemRenderer;
      
      public var rendererIsEditor:Boolean = false;
      
      private var dontEdit:Boolean = false;
      
      public var editorYOffset:Number = 0;
      
      public var editorWidthOffset:Number = 0;
      
      private var lastEditedItemPosition;
      
      public var itemEditor:IFactory;
      
      public var editable:Boolean = false;
      
      private var losingFocus:Boolean = false;
      
      public var editorUsesEnterKey:Boolean = false;
      
      public var editorDataField:String = "text";
      
      private var bEditedItemPositionChanged:Boolean = false;
      
      mx_internal var _lockedRowCount:int = 0;
      
      private var inEndEdit:Boolean = false;
      
      public var editorHeightOffset:Number = 0;
      
      private var _editedItemPosition:Object;
      
      private var _imeMode:String;
      
      private var actualRowIndex:int;
      
      private var _proposedEditedItemPosition;
      
      private var actualColIndex:int = 0;
      
      protected var measuringObjects:Dictionary;
      
      public function List()
      {
         itemEditor = new ClassFactory(TextInput);
         super();
         listType = "vertical";
         bColumnScrolling = false;
         itemRenderer = new ClassFactory(ListItemRenderer);
         _horizontalScrollPolicy = ScrollPolicy.OFF;
         _verticalScrollPolicy = ScrollPolicy.AUTO;
         defaultColumnCount = 1;
         defaultRowCount = 7;
         addEventListener(ListEvent.ITEM_EDIT_BEGINNING,itemEditorItemEditBeginningHandler,false,EventPriority.DEFAULT_HANDLER);
         addEventListener(ListEvent.ITEM_EDIT_BEGIN,itemEditorItemEditBeginHandler,false,EventPriority.DEFAULT_HANDLER);
         addEventListener(ListEvent.ITEM_EDIT_END,itemEditorItemEditEndHandler,false,EventPriority.DEFAULT_HANDLER);
      }
      
      override public function measureWidthOfItems(param1:int = -1, param2:int = 0) : Number
      {
         var item:IListItemRenderer = null;
         var rw:Number = NaN;
         var data:Object = null;
         var factory:IFactory = null;
         var index:int = param1;
         var count:int = param2;
         if(count == 0)
         {
            count = !!collection?int(collection.length):0;
         }
         if(collection && collection.length == 0)
         {
            count = 0;
         }
         var w:Number = 0;
         var bookmark:CursorBookmark = !!iterator?iterator.bookmark:null;
         if(index != -1 && iterator)
         {
            try
            {
               iterator.seek(CursorBookmark.FIRST,index);
            }
            catch(e:ItemPendingError)
            {
               return 0;
            }
         }
         var more:Boolean = iterator != null;
         var i:int = 0;
         while(i < count)
         {
            if(more)
            {
               data = iterator.current;
               factory = getItemRendererFactory(data);
               item = measuringObjects[factory];
               if(!item)
               {
                  item = getMeasuringRenderer(data);
               }
               item.explicitWidth = NaN;
               setupRendererFromData(item,data);
               rw = item.measuredWidth;
               w = Math.max(w,rw);
            }
            if(more)
            {
               try
               {
                  more = iterator.moveNext();
               }
               catch(e:ItemPendingError)
               {
                  more = false;
               }
            }
            i++;
         }
         if(iterator)
         {
            iterator.seek(bookmark,0);
         }
         if(w == 0)
         {
            if(explicitWidth)
            {
               return explicitWidth;
            }
            return DEFAULT_MEASURED_WIDTH;
         }
         var paddingLeft:Number = getStyle("paddingLeft");
         var paddingRight:Number = getStyle("paddingRight");
         w = w + (paddingLeft + paddingRight);
         return w;
      }
      
      private function findNextEnterItemRenderer(param1:KeyboardEvent) : void
      {
         if(_proposedEditedItemPosition !== undefined)
         {
            return;
         }
         _editedItemPosition = lastEditedItemPosition;
         var _loc2_:int = _editedItemPosition.rowIndex;
         var _loc3_:int = _editedItemPosition.columnIndex;
         var _loc4_:int = _editedItemPosition.rowIndex + (!!param1.shiftKey?-1:1);
         if(_loc4_ < collection.length && _loc4_ >= 0)
         {
            _loc2_ = _loc4_;
         }
         var _loc5_:ListEvent = new ListEvent(ListEvent.ITEM_EDIT_BEGINNING,false,true);
         _loc5_.rowIndex = _loc2_;
         _loc5_.columnIndex = 0;
         dispatchEvent(_loc5_);
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
      
      public function set imeMode(param1:String) : void
      {
         _imeMode = param1;
      }
      
      override protected function mouseUpHandler(param1:MouseEvent) : void
      {
         var _loc2_:ListEvent = null;
         var _loc3_:IListItemRenderer = null;
         var _loc4_:Sprite = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:Point = null;
         _loc3_ = mouseEventToItemRenderer(param1);
         super.mouseUpHandler(param1);
         if(_loc3_ && _loc3_.data && _loc3_ != itemEditorInstance)
         {
            _loc7_ = itemRendererToIndices(_loc3_);
            if(editable && !dontEdit)
            {
               _loc2_ = new ListEvent(ListEvent.ITEM_EDIT_BEGINNING,false,true);
               _loc2_.rowIndex = _loc7_.y;
               _loc2_.columnIndex = 0;
               _loc2_.itemRenderer = _loc3_;
               dispatchEvent(_loc2_);
            }
         }
      }
      
      private function itemEditorItemEditEndHandler(param1:ListEvent) : void
      {
         var bChanged:Boolean = false;
         var bFieldChanged:Boolean = false;
         var newData:Object = null;
         var data:Object = null;
         var editCollection:IList = null;
         var listData:BaseListData = null;
         var fm:IFocusManager = null;
         var event:ListEvent = param1;
         if(!event.isDefaultPrevented())
         {
            bChanged = false;
            bFieldChanged = false;
            newData = itemEditorInstance[editorDataField];
            data = event.itemRenderer.data;
            if(data is String)
            {
               if(!(newData is String))
               {
                  newData = newData.toString();
               }
            }
            else if(data is uint)
            {
               if(!(newData is uint))
               {
                  newData = uint(newData);
               }
            }
            else if(data is int)
            {
               if(!(newData is int))
               {
                  newData = int(newData);
               }
            }
            else if(data is Number)
            {
               if(!(newData is int))
               {
                  newData = Number(newData);
               }
            }
            else
            {
               bFieldChanged = true;
               try
               {
                  data[labelField] = newData;
                  if(!(data is IPropertyChangeNotifier))
                  {
                     if(actualCollection)
                     {
                        actualCollection.itemUpdated(data,labelField);
                     }
                     else
                     {
                        collection.itemUpdated(data,labelField);
                     }
                  }
               }
               catch(e:Error)
               {
                  trace("attempt to write to",labelField,"failed.  You may need a custom ITEM_EDIT_END handler");
               }
            }
            if(!bFieldChanged)
            {
               if(data !== newData)
               {
                  bChanged = true;
                  data = newData;
               }
               if(bChanged)
               {
                  editCollection = !!actualCollection?actualCollection as IList:collection as IList;
                  if(editCollection)
                  {
                     IList(editCollection).setItemAt(data,event.rowIndex);
                  }
                  else
                  {
                     trace("attempt to update collection failed.  You may need a custom ITEM_EDIT_END handler");
                  }
               }
            }
            if(event.itemRenderer is IDropInListItemRenderer)
            {
               listData = BaseListData(IDropInListItemRenderer(event.itemRenderer).listData);
               listData.label = itemToLabel(data);
               IDropInListItemRenderer(event.itemRenderer).listData = listData;
            }
            delete visibleData[itemToUID(event.itemRenderer.data)];
            event.itemRenderer.data = data;
            visibleData[itemToUID(data)] = event.itemRenderer;
         }
         else if(event.reason != ListEventReason.OTHER)
         {
            if(itemEditorInstance && _editedItemPosition)
            {
               if(selectedIndex != _editedItemPosition.rowIndex)
               {
                  selectedIndex = _editedItemPosition.rowIndex;
               }
               fm = focusManager;
               if(itemEditorInstance is IFocusManagerComponent)
               {
                  fm.setFocus(IFocusManagerComponent(itemEditorInstance));
               }
            }
         }
         if(event.reason == ListEventReason.OTHER || !event.isDefaultPrevented())
         {
            destroyItemEditor();
         }
      }
      
      private function itemEditorItemEditBeginningHandler(param1:ListEvent) : void
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
      
      override public function createItemRenderer(param1:Object) : IListItemRenderer
      {
         var _loc2_:IFactory = null;
         var _loc3_:IListItemRenderer = null;
         var _loc4_:Dictionary = null;
         var _loc5_:* = undefined;
         _loc2_ = getItemRendererFactory(param1);
         if(!_loc2_)
         {
            if(param1 == null)
            {
               _loc2_ = nullItemRenderer;
            }
            if(!_loc2_)
            {
               _loc2_ = itemRenderer;
            }
         }
         if(_loc2_ == itemRenderer)
         {
            if(freeItemRenderers && freeItemRenderers.length)
            {
               _loc3_ = freeItemRenderers.pop();
               delete freeItemRenderersByFactory[_loc2_][_loc3_];
            }
         }
         else if(freeItemRenderersByFactory)
         {
            _loc4_ = freeItemRenderersByFactory[_loc2_];
            if(_loc4_)
            {
               for(_loc5_ in _loc4_)
               {
                  _loc3_ = IListItemRenderer(_loc5_);
                  delete _loc4_[_loc5_];
               }
            }
         }
         if(!_loc3_)
         {
            _loc3_ = _loc2_.newInstance();
            _loc3_.styleName = this;
            factoryMap[_loc3_] = _loc2_;
         }
         _loc3_.owner = this;
         return _loc3_;
      }
      
      override protected function focusOutHandler(param1:FocusEvent) : void
      {
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
            endEdit(ListEventReason.OTHER);
            removeEventListener(FocusEvent.KEY_FOCUS_CHANGE,keyFocusChangeHandler);
            removeEventListener(MouseEvent.MOUSE_DOWN,mouseFocusChangeHandler);
         }
      }
      
      override protected function scrollHorizontally(param1:int, param2:int, param3:Boolean) : void
      {
         var _loc4_:int = listItems.length;
         var _loc5_:Number = getStyle("paddingLeft");
         var _loc6_:int = 0;
         while(_loc6_ < _loc4_)
         {
            if(listItems[_loc6_].length)
            {
               listItems[_loc6_][0].x = -param1 + _loc5_;
            }
            _loc6_++;
         }
      }
      
      override protected function drawHighlightIndicator(param1:Sprite, param2:Number, param3:Number, param4:Number, param5:Number, param6:uint, param7:IListItemRenderer) : void
      {
         super.drawHighlightIndicator(param1,0,param3,unscaledWidth - viewMetrics.left - viewMetrics.right,param5,param6,param7);
      }
      
      [Bindable("itemFocusIn")]
      public function get editedItemPosition() : Object
      {
         if(_editedItemPosition)
         {
            return {
               "rowIndex":_editedItemPosition.rowIndex,
               "columnIndex":0
            };
         }
         return _editedItemPosition;
      }
      
      private function setEditedItemPosition(param1:Object) : void
      {
         bEditedItemPositionChanged = true;
         _proposedEditedItemPosition = param1;
         invalidateDisplayList();
      }
      
      override protected function drawRowBackgrounds() : void
      {
         var _loc2_:Array = null;
         var _loc6_:int = 0;
         var _loc1_:Sprite = Sprite(listContent.getChildByName("rowBGs"));
         if(!_loc1_)
         {
            _loc1_ = new FlexSprite();
            _loc1_.mouseEnabled = false;
            _loc1_.name = "rowBGs";
            listContent.addChildAt(_loc1_,0);
         }
         _loc2_ = getStyle("alternatingItemColors");
         if(!_loc2_ || _loc2_.length == 0)
         {
            while(_loc1_.numChildren > _loc6_)
            {
               _loc1_.removeChildAt(_loc1_.numChildren - 1);
            }
            return;
         }
         StyleManager.getColorNames(_loc2_);
         var _loc3_:int = 0;
         var _loc4_:int = verticalScrollPosition;
         var _loc5_:int = 0;
         _loc6_ = listItems.length;
         while(_loc3_ < _loc6_)
         {
            drawRowBackground(_loc1_,_loc5_++,rowInfo[_loc3_].y,rowInfo[_loc3_].height,_loc2_[_loc4_ % _loc2_.length],_loc4_);
            _loc3_++;
            _loc4_++;
         }
         while(_loc1_.numChildren > _loc6_)
         {
            _loc1_.removeChildAt(_loc1_.numChildren - 1);
         }
      }
      
      override protected function drawCaretIndicator(param1:Sprite, param2:Number, param3:Number, param4:Number, param5:Number, param6:uint, param7:IListItemRenderer) : void
      {
         super.drawCaretIndicator(param1,0,param3,unscaledWidth - viewMetrics.left - viewMetrics.right,param5,param6,param7);
      }
      
      private function deactivateHandler(param1:Event) : void
      {
         if(itemEditorInstance)
         {
            endEdit(ListEventReason.OTHER);
            losingFocus = true;
            setFocus();
         }
      }
      
      protected function layoutEditor(param1:int, param2:int, param3:int, param4:int) : void
      {
         itemEditorInstance.move(param1,param2);
         itemEditorInstance.setActualSize(param3,param4);
      }
      
      private function editorKeyDownHandler(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == Keyboard.ESCAPE)
         {
            endEdit(ListEventReason.CANCELLED);
         }
         else if(param1.ctrlKey && param1.charCode == 46)
         {
            endEdit(ListEventReason.CANCELLED);
         }
         else if(param1.charCode == Keyboard.ENTER && param1.keyCode != 229)
         {
            if(editorUsesEnterKey)
            {
               return;
            }
            if(endEdit(ListEventReason.NEW_ROW))
            {
               if(!dontEdit)
               {
                  findNextEnterItemRenderer(param1);
               }
            }
         }
      }
      
      private function itemEditorItemEditBeginHandler(param1:ListEvent) : void
      {
         var _loc2_:IFocusManager = null;
         if(root)
         {
            systemManager.addEventListener(Event.DEACTIVATE,deactivateHandler,false,0,true);
         }
         if(!param1.isDefaultPrevented() && listItems[actualRowIndex][actualColIndex].data != null)
         {
            createItemEditor(param1.columnIndex,param1.rowIndex);
            if(editedItemRenderer is IDropInListItemRenderer && itemEditorInstance is IDropInListItemRenderer)
            {
               IDropInListItemRenderer(itemEditorInstance).listData = IDropInListItemRenderer(editedItemRenderer).listData;
            }
            if(!rendererIsEditor)
            {
               itemEditorInstance.data = editedItemRenderer.data;
            }
            if(itemEditorInstance is IInvalidating)
            {
               IInvalidating(itemEditorInstance).validateNow();
            }
            if(itemEditorInstance is IIMESupport)
            {
               IIMESupport(itemEditorInstance).imeMode = imeMode;
            }
            _loc2_ = focusManager;
            if(itemEditorInstance is IFocusManagerComponent)
            {
               _loc2_.setFocus(IFocusManagerComponent(itemEditorInstance));
            }
            _loc2_.defaultButtonEnabled = false;
            param1 = new ListEvent(ListEvent.ITEM_FOCUS_IN);
            param1.rowIndex = _editedItemPosition.rowIndex;
            param1.itemRenderer = itemEditorInstance;
            dispatchEvent(param1);
         }
      }
      
      private function editingTemporarilyPrevented(param1:Object) : Boolean
      {
         var _loc2_:int = 0;
         var _loc3_:IListItemRenderer = null;
         if(runningDataEffect && param1)
         {
            _loc2_ = param1.rowIndex - verticalScrollPosition + offscreenExtraRowsTop;
            if(_loc2_ < 0 || _loc2_ >= listItems.length)
            {
               return false;
            }
            _loc3_ = listItems[_loc2_][0];
            if(_loc3_ && (getRendererSemanticValue(_loc3_,"replaced") || getRendererSemanticValue(_loc3_,"removed")))
            {
               return true;
            }
         }
         return false;
      }
      
      override public function measureHeightOfItems(param1:int = -1, param2:int = 0) : Number
      {
         var data:Object = null;
         var item:IListItemRenderer = null;
         var index:int = param1;
         var count:int = param2;
         if(count == 0)
         {
            count = !!collection?int(collection.length):0;
         }
         var paddingTop:Number = getStyle("paddingTop");
         var paddingBottom:Number = getStyle("paddingBottom");
         var ww:Number = 200;
         if(listContent.width)
         {
            ww = listContent.width;
         }
         var h:Number = 0;
         var bookmark:CursorBookmark = !!iterator?iterator.bookmark:null;
         if(index != -1 && iterator)
         {
            iterator.seek(CursorBookmark.FIRST,index);
         }
         var rh:Number = rowHeight;
         var more:Boolean = iterator != null;
         var i:int = 0;
         while(i < count)
         {
            if(more)
            {
               rh = rowHeight;
               data = iterator.current;
               item = getMeasuringRenderer(data);
               item.explicitWidth = ww;
               setupRendererFromData(item,data);
               if(variableRowHeight)
               {
                  rh = item.getExplicitOrMeasuredHeight() + paddingTop + paddingBottom;
               }
            }
            h = h + rh;
            if(more)
            {
               try
               {
                  more = iterator.moveNext();
               }
               catch(e:ItemPendingError)
               {
                  more = false;
               }
            }
            i++;
         }
         if(iterator)
         {
            iterator.seek(bookmark,0);
         }
         return h;
      }
      
      mx_internal function callSetupRendererFromData(param1:IListItemRenderer, param2:Object) : void
      {
         setupRendererFromData(param1,param2);
      }
      
      override protected function drawSelectionIndicator(param1:Sprite, param2:Number, param3:Number, param4:Number, param5:Number, param6:uint, param7:IListItemRenderer) : void
      {
         super.drawSelectionIndicator(param1,0,param3,unscaledWidth - viewMetrics.left - viewMetrics.right,param5,param6,param7);
      }
      
      private function keyFocusChangeHandler(param1:FocusEvent) : void
      {
         if(param1.keyCode == Keyboard.TAB && !param1.isDefaultPrevented() && findNextItemRenderer(param1.shiftKey))
         {
            param1.preventDefault();
         }
      }
      
      public function set editedItemPosition(param1:Object) : void
      {
         var _loc2_:Object = {
            "rowIndex":param1.rowIndex,
            "columnIndex":0
         };
         setEditedItemPosition(_loc2_);
      }
      
      override protected function makeRowsAndColumns(param1:Number, param2:Number, param3:Number, param4:Number, param5:int, param6:int, param7:Boolean = false, param8:uint = 0) : Point
      {
         var yy:Number = NaN;
         var hh:Number = NaN;
         var i:int = 0;
         var j:int = 0;
         var item:IListItemRenderer = null;
         var oldItem:IListItemRenderer = null;
         var rowData:BaseListData = null;
         var data:Object = null;
         var wrappedData:Object = null;
         var uid:String = null;
         var rh:Number = NaN;
         var ld:BaseListData = null;
         var rr:Array = null;
         var rowInfo:ListRowInfo = null;
         var dx:Number = NaN;
         var dy:Number = NaN;
         var dw:Number = NaN;
         var dh:Number = NaN;
         var left:Number = param1;
         var top:Number = param2;
         var right:Number = param3;
         var bottom:Number = param4;
         var firstCol:int = param5;
         var firstRow:int = param6;
         var byCount:Boolean = param7;
         var rowsNeeded:uint = param8;
         listContent.allowItemSizeChangeNotification = false;
         var paddingLeft:Number = getStyle("paddingLeft");
         var paddingRight:Number = getStyle("paddingRight");
         var xx:Number = left + paddingLeft - horizontalScrollPosition;
         var ww:Number = right - paddingLeft - paddingRight;
         var bSelected:Boolean = false;
         var bHighlight:Boolean = false;
         var bCaret:Boolean = false;
         var colNum:int = 0;
         var rowNum:int = lockedRowCount;
         var rowsMade:int = 0;
         var more:Boolean = true;
         var valid:Boolean = true;
         yy = top;
         rowNum = firstRow;
         more = iterator != null && !iterator.afterLast && iteratorValid;
         while(!byCount && yy < bottom || byCount && rowsNeeded > 0)
         {
            if(byCount)
            {
               rowsNeeded--;
            }
            valid = more;
            wrappedData = !!more?iterator.current:null;
            data = wrappedData is ItemWrapper?wrappedData.data:wrappedData;
            uid = null;
            if(!listItems[rowNum])
            {
               listItems[rowNum] = [];
            }
            if(valid)
            {
               item = listItems[rowNum][colNum];
               uid = itemToUID(wrappedData);
               if(!item || (runningDataEffect && dataItemWrappersByRenderer[item]?Boolean(dataItemWrappersByRenderer[item] != wrappedData):Boolean(item.data != data)))
               {
                  if(allowRendererStealingDuringLayout)
                  {
                     item = visibleData[uid];
                     if(!item && wrappedData != data)
                     {
                        item = visibleData[itemToUID(data)];
                     }
                  }
                  if(item)
                  {
                     ld = BaseListData(rowMap[item.name]);
                     if(ld && ld.rowIndex > rowNum)
                     {
                        listItems[ld.rowIndex] = [];
                     }
                     else
                     {
                        item = null;
                     }
                  }
                  if(!item)
                  {
                     item = getReservedOrFreeItemRenderer(wrappedData);
                  }
                  if(!item)
                  {
                     item = createItemRenderer(data);
                     item.owner = this;
                     item.styleName = listContent;
                     listContent.addChild(DisplayObject(item));
                  }
                  oldItem = listItems[rowNum][colNum];
                  if(oldItem)
                  {
                     addToFreeItemRenderers(oldItem);
                  }
                  listItems[rowNum][colNum] = item;
               }
               rowData = makeListData(data,uid,rowNum);
               rowMap[item.name] = rowData;
               if(item is IDropInListItemRenderer)
               {
                  if(data != null)
                  {
                     IDropInListItemRenderer(item).listData = rowData;
                  }
                  else
                  {
                     IDropInListItemRenderer(item).listData = null;
                  }
               }
               item.data = data;
               item.enabled = enabled;
               item.visible = true;
               if(uid != null)
               {
                  visibleData[uid] = item;
               }
               if(wrappedData != data)
               {
                  dataItemWrappersByRenderer[item] = wrappedData;
               }
               item.explicitWidth = ww;
               if(item is IInvalidating && (wordWrapChanged || variableRowHeight))
               {
                  IInvalidating(item).invalidateSize();
               }
               UIComponentGlobals.layoutManager.validateClient(item,true);
               hh = Math.ceil(!!variableRowHeight?Number(item.getExplicitOrMeasuredHeight() + cachedPaddingTop + cachedPaddingBottom):Number(rowHeight));
               rh = item.getExplicitOrMeasuredHeight();
               item.setActualSize(ww,!!variableRowHeight?Number(rh):Number(rowHeight - cachedPaddingTop - cachedPaddingBottom));
               item.move(xx,yy + cachedPaddingTop);
            }
            else
            {
               hh = rowNum > 0?Number(rowInfo[rowNum - 1].height):Number(rowHeight);
               if(hh == 0)
               {
                  hh = rowHeight;
               }
               oldItem = listItems[rowNum][colNum];
               if(oldItem)
               {
                  addToFreeItemRenderers(oldItem);
                  listItems[rowNum].splice(colNum,1);
               }
            }
            bSelected = selectedData[uid] != null;
            if(wrappedData != data)
            {
               bSelected = bSelected || selectedData[itemToUID(data)];
               bSelected = bSelected && !getRendererSemanticValue(item,ModifiedCollectionView.REPLACEMENT) && !getRendererSemanticValue(item,ModifiedCollectionView.ADDED);
            }
            bHighlight = highlightUID == uid;
            bCaret = caretUID == uid;
            rowInfo[rowNum] = new ListRowInfo(yy,hh,uid,data);
            if(valid)
            {
               drawItem(item,bSelected,bHighlight,bCaret);
            }
            yy = yy + hh;
            rowNum++;
            rowsMade++;
            if(iterator && more)
            {
               try
               {
                  more = iterator.moveNext();
               }
               catch(e:ItemPendingError)
               {
                  lastSeekPending = new ListBaseSeekPending(CursorBookmark.CURRENT,0);
                  e.addResponder(new ItemResponder(seekPendingResultHandler,seekPendingFailureHandler,lastSeekPending));
                  more = false;
                  iteratorValid = false;
                  continue;
               }
            }
         }
         if(!byCount)
         {
            while(rowNum < listItems.length)
            {
               rr = listItems.pop();
               rowInfo.pop();
               while(rr.length)
               {
                  item = rr.pop();
                  addToFreeItemRenderers(item);
               }
            }
         }
         if(itemEditorInstance)
         {
            listContent.setChildIndex(DisplayObject(itemEditorInstance),listContent.numChildren - 1);
            item = listItems[actualRowIndex][actualColIndex];
            rowInfo = rowInfo[actualRowIndex];
            if(item && !rendererIsEditor)
            {
               dx = editorXOffset;
               dy = editorYOffset;
               dw = editorWidthOffset;
               dh = editorHeightOffset;
               layoutEditor(item.x + dx,rowInfo.y + dy,Math.min(item.width + dw,listContent.width - listContent.x - itemEditorInstance.x),Math.min(rowInfo.height + dh,listContent.height - listContent.y - itemEditorInstance.y));
            }
         }
         listContent.allowItemSizeChangeNotification = variableRowHeight;
         return new Point(colNum,rowsMade);
      }
      
      override protected function measure() : void
      {
         super.measure();
         var _loc1_:EdgeMetrics = viewMetrics;
         measuredMinWidth = DEFAULT_MEASURED_MIN_WIDTH;
         if(initialized && variableRowHeight && explicitRowCount < 1 && isNaN(explicitRowHeight))
         {
            measuredHeight = height;
         }
      }
      
      private function findNextItemRenderer(param1:Boolean) : Boolean
      {
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
         var _loc4_:int = _editedItemPosition.rowIndex + (!!param1?-1:1);
         if(_loc4_ < collection.length && _loc4_ >= 0)
         {
            _loc2_ = _loc4_;
            var _loc5_:ListEvent = new ListEvent(ListEvent.ITEM_EDIT_BEGINNING,false,true);
            _loc5_.rowIndex = _loc2_;
            _loc5_.columnIndex = _loc3_;
            dispatchEvent(_loc5_);
            return true;
         }
         setEditedItemPosition(null);
         losingFocus = true;
         setFocus();
         return false;
      }
      
      override protected function mouseDownHandler(param1:MouseEvent) : void
      {
         var _loc2_:IListItemRenderer = null;
         var _loc3_:Sprite = null;
         var _loc5_:Point = null;
         var _loc6_:Boolean = false;
         _loc2_ = mouseEventToItemRenderer(param1);
         var _loc4_:Boolean = itemRendererContains(itemEditorInstance,DisplayObject(param1.target));
         if(!_loc4_)
         {
            if(_loc2_ && _loc2_.data)
            {
               _loc5_ = itemRendererToIndices(_loc2_);
               _loc6_ = true;
               if(itemEditorInstance)
               {
                  _loc6_ = endEdit(ListEventReason.NEW_ROW);
               }
               if(!_loc6_)
               {
                  return;
               }
            }
            else if(itemEditorInstance)
            {
               endEdit(ListEventReason.OTHER);
            }
            super.mouseDownHandler(param1);
         }
      }
      
      override protected function keyDownHandler(param1:KeyboardEvent) : void
      {
         if(itemEditorInstance)
         {
            return;
         }
         super.keyDownHandler(param1);
      }
      
      override protected function focusInHandler(param1:FocusEvent) : void
      {
         var _loc2_:* = false;
         if(param1.target != this)
         {
            return;
         }
         if(losingFocus)
         {
            losingFocus = false;
            return;
         }
         super.focusInHandler(param1);
         if(editable && !isPressed)
         {
            _editedItemPosition = lastEditedItemPosition;
            _loc2_ = editedItemPosition != null;
            if(!_editedItemPosition)
            {
               _editedItemPosition = {
                  "rowIndex":0,
                  "columnIndex":0
               };
               _loc2_ = Boolean(listItems.length && listItems[0].length > 0);
            }
            if(_loc2_)
            {
               setEditedItemPosition(_editedItemPosition);
            }
         }
         if(editable)
         {
            addEventListener(FocusEvent.KEY_FOCUS_CHANGE,keyFocusChangeHandler);
            addEventListener(MouseEvent.MOUSE_DOWN,mouseFocusChangeHandler);
         }
      }
      
      override protected function mouseEventToItemRenderer(param1:MouseEvent) : IListItemRenderer
      {
         var _loc2_:IListItemRenderer = super.mouseEventToItemRenderer(param1);
         return _loc2_ == itemEditorInstance?null:_loc2_;
      }
      
      protected function makeListData(param1:Object, param2:String, param3:int) : BaseListData
      {
         return new ListData(itemToLabel(param1),itemToIcon(param1),labelField,param2,this,param3);
      }
      
      public function createItemEditor(param1:int, param2:int) : void
      {
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         param1 = 0;
         if(param2 > lockedRowCount)
         {
            param2 = param2 - verticalScrollPosition;
         }
         var _loc3_:IListItemRenderer = listItems[param2][param1];
         var _loc4_:ListRowInfo = rowInfo[param2];
         if(!rendererIsEditor)
         {
            _loc5_ = 0;
            _loc6_ = -2;
            _loc7_ = 0;
            _loc8_ = 4;
            if(!itemEditorInstance)
            {
               _loc5_ = editorXOffset;
               _loc6_ = editorYOffset;
               _loc7_ = editorWidthOffset;
               _loc8_ = editorHeightOffset;
               itemEditorInstance = itemEditor.newInstance();
               itemEditorInstance.owner = this;
               itemEditorInstance.styleName = this;
               listContent.addChild(DisplayObject(itemEditorInstance));
            }
            listContent.setChildIndex(DisplayObject(itemEditorInstance),listContent.numChildren - 1);
            itemEditorInstance.visible = true;
            layoutEditor(_loc3_.x + _loc5_,_loc4_.y + _loc6_,Math.min(_loc3_.width + _loc7_,listContent.width - listContent.x - itemEditorInstance.x),Math.min(_loc4_.height + _loc8_,listContent.height - listContent.y - itemEditorInstance.y));
            DisplayObject(itemEditorInstance).addEventListener("focusOut",itemEditorFocusOutHandler);
         }
         else
         {
            itemEditorInstance = _loc3_;
         }
         DisplayObject(itemEditorInstance).addEventListener(KeyboardEvent.KEY_DOWN,editorKeyDownHandler);
         systemManager.getSandboxRoot().addEventListener(MouseEvent.MOUSE_DOWN,editorMouseDownHandler,true,0,true);
         systemManager.getSandboxRoot().addEventListener(SandboxMouseEvent.MOUSE_DOWN_SOMEWHERE,editorMouseDownHandler,false,0,true);
      }
      
      public function get lockedRowCount() : int
      {
         return _lockedRowCount;
      }
      
      override public function set enabled(param1:Boolean) : void
      {
         super.enabled = param1;
         if(itemEditorInstance)
         {
            endEdit(ListEventReason.OTHER);
         }
         invalidateDisplayList();
      }
      
      protected function endEdit(param1:String) : Boolean
      {
         if(!editedItemRenderer)
         {
            return true;
         }
         inEndEdit = true;
         var _loc2_:ListEvent = new ListEvent(ListEvent.ITEM_EDIT_END,false,true);
         _loc2_.rowIndex = editedItemPosition.rowIndex;
         _loc2_.itemRenderer = editedItemRenderer;
         _loc2_.reason = param1;
         dispatchEvent(_loc2_);
         dontEdit = itemEditorInstance != null;
         if(!dontEdit && param1 == ListEventReason.CANCELLED)
         {
            losingFocus = true;
            setFocus();
         }
         inEndEdit = false;
         return !_loc2_.isDefaultPrevented();
      }
      
      override protected function collectionChangeHandler(param1:Event) : void
      {
         var _loc2_:CollectionEvent = null;
         if(param1 is CollectionEvent)
         {
            _loc2_ = CollectionEvent(param1);
            if(_loc2_.kind == CollectionEventKind.REMOVE)
            {
               if(editedItemPosition)
               {
                  if(collection.length == 0)
                  {
                     if(itemEditorInstance)
                     {
                        endEdit(ListEventReason.CANCELLED);
                     }
                     setEditedItemPosition(null);
                  }
                  else if(_loc2_.location <= editedItemPosition.rowIndex)
                  {
                     if(inEndEdit)
                     {
                        _editedItemPosition = {
                           "columnIndex":editedItemPosition.columnIndex,
                           "rowIndex":Math.max(0,editedItemPosition.rowIndex - _loc2_.items.length)
                        };
                     }
                     else
                     {
                        setEditedItemPosition({
                           "columnIndex":editedItemPosition.columnIndex,
                           "rowIndex":Math.max(0,editedItemPosition.rowIndex - _loc2_.items.length)
                        });
                     }
                  }
               }
            }
         }
         super.collectionChangeHandler(param1);
      }
      
      override public function get baselinePosition() : Number
      {
         if(FlexVersion.compatibilityVersion < FlexVersion.VERSION_3_0)
         {
            if(listItems.length && listItems[0].length)
            {
               return borderMetrics.top + cachedPaddingTop + listItems[0][0].baselinePosition;
            }
            return NaN;
         }
         return super.baselinePosition;
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
            endEdit(ListEventReason.OTHER);
         }
      }
      
      override public function set dataProvider(param1:Object) : void
      {
         if(itemEditorInstance)
         {
            endEdit(ListEventReason.OTHER);
         }
         super.dataProvider = param1;
      }
      
      override protected function initializeAccessibility() : void
      {
         if(createAccessibilityImplementation != null)
         {
            createAccessibilityImplementation(this);
         }
      }
      
      override protected function configureScrollBars() : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:int = 0;
         var _loc1_:int = listItems.length;
         if(_loc1_ == 0)
         {
            return;
         }
         var _loc4_:int = listItems.length;
         while(_loc1_ > 1 && rowInfo[_loc4_ - 1].y + rowInfo[_loc4_ - 1].height > listContent.height - listContent.bottomOffset)
         {
            _loc1_--;
            _loc4_--;
         }
         var _loc5_:int = verticalScrollPosition - lockedRowCount - 1;
         var _loc6_:int = 0;
         while(_loc1_ && listItems[_loc1_ - 1].length == 0)
         {
            if(collection && _loc1_ + _loc5_ >= collection.length)
            {
               _loc1_--;
               _loc6_++;
               continue;
            }
            break;
         }
         if(verticalScrollPosition > 0 && _loc6_ > 0 && !runningDataEffect)
         {
            if(adjustVerticalScrollPositionDownward(Math.max(_loc1_,1)))
            {
               return;
            }
         }
         if(listContent.topOffset)
         {
            _loc2_ = Math.abs(listContent.topOffset);
            _loc3_ = 0;
            while(rowInfo[_loc3_].y + rowInfo[_loc3_].height <= _loc2_)
            {
               _loc1_--;
               _loc3_++;
               if(_loc3_ == _loc1_)
               {
                  break;
               }
            }
         }
         var _loc7_:int = listItems[0].length;
         var _loc8_:Object = horizontalScrollBar;
         var _loc9_:Object = verticalScrollBar;
         var _loc10_:int = Math.round(unscaledWidth);
         var _loc11_:int = !!collection?int(collection.length - lockedRowCount):0;
         var _loc12_:int = _loc1_ - lockedRowCount;
         setScrollBarProperties(!!isNaN(_maxHorizontalScrollPosition)?int(Math.round(listContent.width)):int(Math.round(_maxHorizontalScrollPosition + _loc10_)),_loc10_,_loc11_,_loc12_);
         maxVerticalScrollPosition = Math.max(_loc11_ - _loc12_,0);
      }
      
      override protected function mouseWheelHandler(param1:MouseEvent) : void
      {
         if(itemEditorInstance)
         {
            endEdit(ListEventReason.OTHER);
         }
         super.mouseWheelHandler(param1);
      }
      
      override public function set maxHorizontalScrollPosition(param1:Number) : void
      {
         super.maxHorizontalScrollPosition = param1;
         scrollAreaChanged = true;
         invalidateDisplayList();
      }
      
      override protected function scrollHandler(param1:Event) : void
      {
         var scrollBar:ScrollBar = null;
         var pos:Number = NaN;
         var delta:int = 0;
         var o:EdgeMetrics = null;
         var bookmark:CursorBookmark = null;
         var event:Event = param1;
         if(event is ScrollEvent)
         {
            if(itemEditorInstance)
            {
               endEdit(ListEventReason.OTHER);
            }
            if(!liveScrolling && ScrollEvent(event).detail == ScrollEventDetail.THUMB_TRACK)
            {
               return;
            }
            scrollBar = ScrollBar(event.target);
            pos = scrollBar.scrollPosition;
            removeClipMask();
            if(scrollBar == verticalScrollBar)
            {
               delta = pos - verticalScrollPosition;
               super.scrollHandler(event);
               if(Math.abs(delta) >= listItems.length - lockedRowCount || !iteratorValid)
               {
                  try
                  {
                     if(!iteratorValid)
                     {
                        iterator.seek(CursorBookmark.FIRST,pos);
                     }
                     else
                     {
                        iterator.seek(CursorBookmark.CURRENT,delta);
                     }
                     if(!iteratorValid)
                     {
                        iteratorValid = true;
                        lastSeekPending = null;
                     }
                  }
                  catch(e:ItemPendingError)
                  {
                     lastSeekPending = new ListBaseSeekPending(CursorBookmark.FIRST,pos);
                     e.addResponder(new ItemResponder(seekPendingResultHandler,seekPendingFailureHandler,lastSeekPending));
                     iteratorValid = false;
                  }
                  bookmark = iterator.bookmark;
                  clearIndicators();
                  clearVisibleData();
                  makeRowsAndColumns(0,0,listContent.width,listContent.height,0,0);
                  iterator.seek(bookmark,0);
               }
               else if(delta != 0)
               {
                  scrollVertically(pos,Math.abs(delta),Boolean(delta > 0));
               }
               if(variableRowHeight)
               {
                  configureScrollBars();
               }
               drawRowBackgrounds();
            }
            else
            {
               delta = pos - _horizontalScrollPosition;
               super.scrollHandler(event);
               scrollHorizontally(pos,Math.abs(delta),Boolean(delta > 0));
            }
            addClipMask(false);
         }
      }
      
      public function get editedItemRenderer() : IListItemRenderer
      {
         if(!itemEditorInstance)
         {
            return null;
         }
         return listItems[actualRowIndex][actualColIndex];
      }
      
      private function commitEditedItemPosition(param1:Object) : void
      {
         var _loc10_:String = null;
         if(!enabled || !editable)
         {
            return;
         }
         if(itemEditorInstance && param1 && itemEditorInstance is IFocusManagerComponent && _editedItemPosition.rowIndex == param1.rowIndex)
         {
            IFocusManagerComponent(itemEditorInstance).setFocus();
            return;
         }
         if(itemEditorInstance)
         {
            if(!param1)
            {
               _loc10_ = ListEventReason.OTHER;
            }
            else
            {
               _loc10_ = ListEventReason.NEW_ROW;
            }
            if(!endEdit(_loc10_) && _loc10_ != ListEventReason.OTHER)
            {
               return;
            }
         }
         _editedItemPosition = param1;
         if(!param1 || dontEdit)
         {
            return;
         }
         var _loc2_:int = param1.rowIndex;
         var _loc3_:int = param1.columnIndex;
         if(selectedIndex != param1.rowIndex)
         {
            commitSelectedIndex(param1.rowIndex);
         }
         var _loc4_:int = lockedRowCount;
         var _loc5_:int = verticalScrollPosition + listItems.length - offscreenExtraRowsTop - offscreenExtraRowsBottom - 1;
         var _loc6_:int = rowInfo[listItems.length - offscreenExtraRowsBottom - 1].y + rowInfo[listItems.length - offscreenExtraRowsBottom - 1].height > listContent.height?1:0;
         if(_loc2_ > _loc4_)
         {
            if(_loc2_ < verticalScrollPosition + _loc4_)
            {
               verticalScrollPosition = _loc2_ - _loc4_;
            }
            else
            {
               while(_loc2_ > _loc5_ || _loc2_ == _loc5_ && _loc2_ > verticalScrollPosition + _loc4_ && _loc6_)
               {
                  if(verticalScrollPosition == maxVerticalScrollPosition)
                  {
                     break;
                  }
                  verticalScrollPosition = Math.min(verticalScrollPosition + (_loc2_ > _loc5_?_loc2_ - _loc5_:_loc6_),maxVerticalScrollPosition);
                  _loc5_ = verticalScrollPosition + listItems.length - offscreenExtraRowsTop - offscreenExtraRowsBottom - 1;
                  _loc6_ = rowInfo[listItems.length - offscreenExtraRowsBottom - 1].y + rowInfo[listItems.length - offscreenExtraRowsBottom - 1].height > listContent.height?1:0;
               }
            }
            actualRowIndex = _loc2_ - verticalScrollPosition;
         }
         else
         {
            if(_loc2_ == _loc4_)
            {
               verticalScrollPosition = 0;
            }
            actualRowIndex = _loc2_;
         }
         var _loc7_:EdgeMetrics = borderMetrics;
         actualColIndex = _loc3_;
         var _loc8_:IListItemRenderer = listItems[actualRowIndex][actualColIndex];
         if(!_loc8_)
         {
            commitEditedItemPosition(null);
            return;
         }
         if(!isItemEditable(_loc8_.data))
         {
            commitEditedItemPosition(null);
            return;
         }
         var _loc9_:ListEvent = new ListEvent(ListEvent.ITEM_EDIT_BEGIN,false,true);
         _loc9_.rowIndex = _editedItemPosition.rowIndex;
         _loc9_.itemRenderer = _loc8_;
         dispatchEvent(_loc9_);
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
      
      protected function drawRowBackground(param1:Sprite, param2:int, param3:Number, param4:Number, param5:uint, param6:int) : void
      {
         var _loc7_:Shape = null;
         if(param2 < param1.numChildren)
         {
            _loc7_ = Shape(param1.getChildAt(param2));
         }
         else
         {
            _loc7_ = new FlexShape();
            _loc7_.name = "rowBackground";
            param1.addChild(_loc7_);
         }
         param4 = Math.min(rowInfo[param2].height,listContent.height - rowInfo[param2].y);
         _loc7_.y = rowInfo[param2].y;
         var _loc8_:Graphics = _loc7_.graphics;
         _loc8_.clear();
         _loc8_.beginFill(param5,getStyle("backgroundAlpha"));
         _loc8_.drawRect(0,0,listContent.width,param4);
         _loc8_.endFill();
      }
      
      override protected function commitProperties() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         var _loc3_:IListItemRenderer = null;
         var _loc4_:Number = NaN;
         var _loc5_:int = 0;
         super.commitProperties();
         if(itemsNeedMeasurement)
         {
            itemsNeedMeasurement = false;
            if(isNaN(explicitRowHeight))
            {
               if(iterator)
               {
                  _loc1_ = getStyle("paddingTop");
                  _loc2_ = getStyle("paddingBottom");
                  _loc3_ = getMeasuringRenderer(iterator.current);
                  _loc4_ = 200;
                  if(listContent.width)
                  {
                     _loc4_ = listContent.width;
                  }
                  _loc3_.explicitWidth = _loc4_;
                  setupRendererFromData(_loc3_,iterator.current);
                  _loc5_ = _loc3_.getExplicitOrMeasuredHeight() + _loc1_ + _loc2_;
                  setRowHeight(Math.max(_loc5_,20));
               }
               else
               {
                  setRowHeight(20);
               }
            }
            if(isNaN(explicitColumnWidth))
            {
               setColumnWidth(measureWidthOfItems(0,explicitRowCount < 1?int(defaultRowCount):int(explicitRowCount)));
            }
         }
      }
      
      mx_internal function getMeasuringRenderer(param1:Object) : IListItemRenderer
      {
         var _loc2_:IListItemRenderer = null;
         if(!measuringObjects)
         {
            measuringObjects = new Dictionary(true);
         }
         var _loc3_:IFactory = getItemRendererFactory(param1);
         _loc2_ = measuringObjects[_loc3_];
         if(!_loc2_)
         {
            _loc2_ = createItemRenderer(param1);
            _loc2_.owner = this;
            _loc2_.name = "hiddenItem";
            _loc2_.visible = false;
            _loc2_.styleName = listContent;
            listContent.addChild(DisplayObject(_loc2_));
            measuringObjects[_loc3_] = _loc2_;
         }
         return _loc2_;
      }
      
      mx_internal function purgeMeasuringRenderers() : void
      {
         var _loc1_:IListItemRenderer = null;
         for each(_loc1_ in measuringObjects)
         {
            if(_loc1_.parent)
            {
               _loc1_.parent.removeChild(DisplayObject(_loc1_));
            }
         }
         if(!measuringObjects)
         {
            measuringObjects = new Dictionary(true);
         }
      }
      
      private function adjustVerticalScrollPositionDownward(param1:int) : Boolean
      {
         var n:int = 0;
         var j:int = 0;
         var more:Boolean = false;
         var data:Object = null;
         var rowCount:int = param1;
         var bookmark:CursorBookmark = iterator.bookmark;
         var h:Number = 0;
         var ch:Number = 0;
         var paddingTop:Number = getStyle("paddingTop");
         var paddingBottom:Number = getStyle("paddingBottom");
         var paddingLeft:Number = getStyle("paddingLeft");
         var paddingRight:Number = getStyle("paddingRight");
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
               more = iterator.movePrevious();
            }
         }
         catch(e:ItemPendingError)
         {
            more = false;
         }
         if(!more)
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
         var item:IListItemRenderer = getMeasuringRenderer(iterator.current);
         item.explicitWidth = listContent.width - paddingLeft - paddingRight;
         while(h > 0 && more)
         {
            if(more)
            {
               data = iterator.current;
               setupRendererFromData(item,data);
               ch = !!variableRowHeight?Number(item.getExplicitOrMeasuredHeight() + paddingBottom + paddingTop):Number(rowHeight);
            }
            h = h - ch;
            try
            {
               more = iterator.movePrevious();
               numRows++;
            }
            catch(e:ItemPendingError)
            {
               more = false;
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
      
      public function isItemEditable(param1:Object) : Boolean
      {
         if(!editable)
         {
            return false;
         }
         if(param1 == null)
         {
            return false;
         }
         return true;
      }
      
      override protected function adjustListContent(param1:Number = -1, param2:Number = -1) : void
      {
         var _loc3_:Number = viewMetrics.left + Math.max(listContent.leftOffset,0);
         var _loc4_:Number = viewMetrics.top + listContent.topOffset;
         listContent.move(_loc3_,_loc4_);
         var _loc5_:Number = Math.max(0,listContent.rightOffset) - _loc3_ - viewMetrics.right;
         var _loc6_:Number = Math.max(0,listContent.bottomOffset) - _loc4_ - viewMetrics.bottom;
         var _loc7_:Number = param1 + _loc5_;
         if(horizontalScrollPolicy == ScrollPolicy.ON || horizontalScrollPolicy == ScrollPolicy.AUTO && !isNaN(_maxHorizontalScrollPosition))
         {
            if(isNaN(_maxHorizontalScrollPosition))
            {
               _loc7_ = _loc7_ * 2;
            }
            else
            {
               _loc7_ = _loc7_ + _maxHorizontalScrollPosition;
            }
         }
         listContent.setActualSize(_loc7_,param2 + _loc6_);
      }
      
      private function editorMouseDownHandler(param1:Event) : void
      {
         if(param1 is MouseEvent && itemRendererContains(itemEditorInstance,DisplayObject(param1.target)))
         {
            return;
         }
         endEdit(ListEventReason.OTHER);
      }
      
      override public function set itemRenderer(param1:IFactory) : void
      {
         super.itemRenderer = param1;
         purgeMeasuringRenderers();
      }
      
      mx_internal function setupRendererFromData(param1:IListItemRenderer, param2:Object) : void
      {
         var _loc3_:Object = param2 is ItemWrapper?param2.data:param2;
         if(param1 is IDropInListItemRenderer)
         {
            if(_loc3_ != null)
            {
               IDropInListItemRenderer(param1).listData = makeListData(_loc3_,itemToUID(param2),0);
            }
            else
            {
               IDropInListItemRenderer(param1).listData = null;
            }
         }
         param1.data = _loc3_;
         if(param1 is IInvalidating)
         {
            IInvalidating(param1).invalidateSize();
         }
         UIComponentGlobals.layoutManager.validateClient(param1,true);
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         super.updateDisplayList(param1,param2);
         setRowCount(listItems.length);
         if(bEditedItemPositionChanged && !editingTemporarilyPrevented(_proposedEditedItemPosition))
         {
            bEditedItemPositionChanged = false;
            commitEditedItemPosition(_proposedEditedItemPosition);
            _proposedEditedItemPosition = undefined;
         }
         drawRowBackgrounds();
      }
      
      public function destroyItemEditor() : void
      {
         var _loc1_:ListEvent = null;
         if(itemEditorInstance)
         {
            DisplayObject(itemEditorInstance).removeEventListener(KeyboardEvent.KEY_DOWN,editorKeyDownHandler);
            systemManager.getSandboxRoot().removeEventListener(MouseEvent.MOUSE_DOWN,editorMouseDownHandler,true);
            systemManager.getSandboxRoot().removeEventListener(SandboxMouseEvent.MOUSE_DOWN_SOMEWHERE,editorMouseDownHandler);
            _loc1_ = new ListEvent(ListEvent.ITEM_FOCUS_OUT);
            _loc1_.rowIndex = _editedItemPosition.rowIndex;
            _loc1_.itemRenderer = editedItemRenderer;
            dispatchEvent(_loc1_);
            if(!rendererIsEditor)
            {
               if(itemEditorInstance && itemEditorInstance is UIComponent)
               {
                  UIComponent(itemEditorInstance).drawFocus(false);
               }
               listContent.removeChild(DisplayObject(itemEditorInstance));
            }
            itemEditorInstance = null;
            _editedItemPosition = null;
         }
      }
      
      mx_internal function callMakeListData(param1:Object, param2:String, param3:int) : BaseListData
      {
         return makeListData(param1,param2,param3);
      }
      
      public function set lockedRowCount(param1:int) : void
      {
         _lockedRowCount = param1;
         invalidateDisplayList();
      }
   }
}
