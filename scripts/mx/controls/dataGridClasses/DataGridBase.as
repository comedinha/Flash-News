package mx.controls.dataGridClasses
{
   import mx.controls.listClasses.ListBase;
   import mx.core.IFontContextComponent;
   import mx.core.mx_internal;
   import mx.controls.listClasses.ListBaseContentHolder;
   import flash.display.DisplayObject;
   import mx.controls.listClasses.ListRowInfo;
   import mx.core.IUITextField;
   import flash.events.Event;
   import flash.display.Sprite;
   import flash.display.Shape;
   import mx.controls.listClasses.IListItemRenderer;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   import mx.core.SpriteAsset;
   import mx.events.ListEvent;
   import flash.ui.Keyboard;
   import flash.display.Graphics;
   import mx.core.UIComponentGlobals;
   import mx.events.DragEvent;
   import mx.core.EdgeMetrics;
   import mx.skins.halo.ListDropIndicator;
   import mx.core.IFlexDisplayObject;
   import flash.utils.setInterval;
   import mx.collections.CursorBookmark;
   import mx.events.TweenEvent;
   import mx.core.IFlexModuleFactory;
   import mx.core.IInvalidating;
   import mx.controls.listClasses.BaseListData;
   import mx.collections.errors.ItemPendingError;
   import mx.controls.listClasses.ListBaseSeekPending;
   import mx.collections.ItemResponder;
   import mx.core.IFactory;
   import mx.events.ScrollEvent;
   import mx.events.ScrollEventDetail;
   import mx.events.ScrollEventDirection;
   import flash.events.MouseEvent;
   import mx.core.IUIComponent;
   import mx.controls.listClasses.IDropInListItemRenderer;
   import mx.collections.IViewCursor;
   
   use namespace mx_internal;
   
   public class DataGridBase extends ListBase implements IFontContextComponent
   {
      
      mx_internal static const VERSION:String = "3.6.0.21751";
       
      
      private var _showHeaders:Boolean = true;
      
      mx_internal var visibleColumns:Array;
      
      private var lockedColumnMask:Shape;
      
      protected var headerMask:Shape;
      
      protected var freeItemRenderersTable:Dictionary;
      
      mx_internal var visibleLockedColumns:Array;
      
      protected var columnMap:Object;
      
      private var indicatorDictionary:Dictionary;
      
      private var lockedColumnAndRowMask:Shape;
      
      private var bSelectItem:Boolean = false;
      
      private var bCtrlKey:Boolean = false;
      
      private var inSelectItem:Boolean = false;
      
      private var lockedRowCountChanged:Boolean = false;
      
      private var lockedColumnHeaderMask:Shape;
      
      mx_internal var _explicitHeaderHeight:Boolean;
      
      protected var lockedColumnAndRowContent:mx.controls.dataGridClasses.DataGridLockedRowContentHolder;
      
      protected var lockedColumnContent:ListBaseContentHolder;
      
      mx_internal var columnsInvalid:Boolean = true;
      
      private var lockedRowMask:Shape;
      
      protected var header:mx.controls.dataGridClasses.DataGridHeaderBase;
      
      mx_internal var _lockedColumnCount:int = 0;
      
      mx_internal var _lockedRowCount:int = 0;
      
      protected var lockedColumnHeader:mx.controls.dataGridClasses.DataGridHeaderBase;
      
      protected var columnHighlightIndicator:Sprite;
      
      protected var columnCaretIndicator:Sprite;
      
      private var lockedColumnCountChanged:Boolean = false;
      
      protected var lockedRowContent:mx.controls.dataGridClasses.DataGridLockedRowContentHolder;
      
      mx_internal var headerClass:Class;
      
      private var lastKey:uint = 0;
      
      mx_internal var _headerHeight:Number = 22;
      
      private var bShiftKey:Boolean = false;
      
      public function DataGridBase()
      {
         headerClass = DataGridHeader;
         indicatorDictionary = new Dictionary(true);
         super();
         listType = "vertical";
         defaultRowCount = 7;
         columnMap = {};
         freeItemRenderersTable = new Dictionary(false);
      }
      
      mx_internal function get dataGridLockedColumnAndRows() : ListBaseContentHolder
      {
         return lockedColumnAndRowContent;
      }
      
      override protected function removeFromRowArrays(param1:int) : void
      {
         super.removeFromRowArrays(param1);
         if(lockedColumnCount)
         {
            lockedColumnContent.listItems.splice(param1,1);
            lockedColumnContent.rowInfo.splice(param1,1);
         }
      }
      
      override mx_internal function removeClipMask() : void
      {
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:DisplayObject = null;
         super.removeClipMask();
         if(!lockedColumnContent)
         {
            return;
         }
         var _loc1_:int = listItems.length - 1;
         if(_loc1_ < 0)
         {
            return;
         }
         var _loc2_:Number = rowInfo[_loc1_].height;
         var _loc3_:ListRowInfo = rowInfo[_loc1_];
         var _loc4_:Array = lockedColumnContent.listItems[_loc1_];
         if(_loc4_)
         {
            _loc5_ = _loc4_.length;
            _loc6_ = 0;
            while(_loc6_ < _loc5_)
            {
               _loc7_ = _loc4_[_loc6_];
               if(_loc7_ is IUITextField)
               {
                  if(_loc7_.height != _loc2_ - (_loc7_.y - _loc3_.y))
                  {
                     _loc7_.height = _loc2_ - (_loc7_.y - _loc3_.y);
                  }
               }
               else if(_loc7_ && _loc7_.mask)
               {
                  itemMaskFreeList.push(_loc7_.mask);
                  _loc7_.mask = null;
               }
               _loc6_++;
            }
         }
      }
      
      private function selectionRemovedListener(param1:Event) : void
      {
         if(!lockedColumnCount)
         {
            return;
         }
         var _loc2_:Sprite = indicatorDictionary[param1.target] as Sprite;
         if(_loc2_)
         {
            _loc2_.parent.removeChild(_loc2_);
         }
      }
      
      override protected function shiftRow(param1:int, param2:int, param3:int, param4:Boolean) : void
      {
         var _loc5_:Array = null;
         var _loc6_:IListItemRenderer = null;
         var _loc7_:int = 0;
         super.shiftRow(param1,param2,param3,param4);
         if(lockedColumnCount)
         {
            _loc5_ = lockedColumnContent.listItems;
            param3 = _loc5_[param1].length;
            _loc7_ = 0;
            while(_loc7_ < param3)
            {
               _loc6_ = _loc5_[param1][_loc7_];
               if(param4)
               {
                  _loc5_[param2][_loc7_] = _loc6_;
                  rowMap[_loc6_.name].rowIndex = param2;
               }
               else
               {
                  rowMap[_loc6_.name].rowIndex = param1;
               }
               _loc7_++;
            }
            if(param4)
            {
               lockedColumnContent.rowInfo[param2] = lockedColumnContent.rowInfo[param1];
            }
         }
      }
      
      protected function makeRow(param1:ListBaseContentHolder, param2:int, param3:Number, param4:Number, param5:Number, param6:Object, param7:String) : Number
      {
         var _loc9_:ListBaseContentHolder = null;
         var _loc10_:IListItemRenderer = null;
         var _loc11_:IListItemRenderer = null;
         var _loc12_:DataGridColumn = null;
         var _loc13_:Point = null;
         var _loc8_:Array = param1.listItems;
         if(lockedColumnCount > 0)
         {
            if(param1 == lockedRowContent)
            {
               _loc9_ = lockedColumnAndRowContent;
            }
            else
            {
               _loc9_ = lockedColumnContent;
            }
         }
         else
         {
            _loc9_ = null;
         }
         var _loc14_:int = 0;
         var _loc15_:Number = param3;
         var _loc16_:Number = 0;
         while(_loc14_ < visibleLockedColumns.length)
         {
            _loc12_ = visibleLockedColumns[_loc14_];
            _loc10_ = setupColumnItemRenderer(_loc12_,_loc9_,param2,_loc14_,param6,param7);
            _loc13_ = layoutColumnItemRenderer(_loc12_,_loc10_,_loc15_,param5);
            _loc15_ = _loc15_ + _loc13_.x;
            _loc14_++;
            _loc16_ = Math.ceil(Math.max(_loc16_,!!variableRowHeight?Number(_loc13_.y + cachedPaddingTop + cachedPaddingBottom):Number(rowHeight)));
         }
         if(visibleLockedColumns.length)
         {
            while(_loc9_.listItems[param2].length > _loc14_)
            {
               _loc11_ = _loc9_.listItems[param2].pop();
               addToFreeItemRenderers(_loc11_);
            }
         }
         _loc14_ = 0;
         _loc15_ = param3;
         while(_loc15_ < param4 && _loc14_ < visibleColumns.length)
         {
            _loc12_ = visibleColumns[_loc14_];
            _loc10_ = setupColumnItemRenderer(_loc12_,param1,param2,_loc14_,param6,param7);
            _loc13_ = layoutColumnItemRenderer(_loc12_,_loc10_,_loc15_,param5);
            _loc15_ = _loc15_ + _loc13_.x;
            _loc14_++;
            _loc16_ = Math.ceil(Math.max(_loc16_,!!variableRowHeight?Number(_loc13_.y + cachedPaddingTop + cachedPaddingBottom):Number(rowHeight)));
         }
         while(_loc8_[param2].length > _loc14_)
         {
            _loc11_ = _loc8_[param2].pop();
            addToFreeItemRenderers(_loc11_);
         }
         return _loc16_;
      }
      
      [Bindable("resize")]
      public function get headerHeight() : Number
      {
         return _headerHeight;
      }
      
      mx_internal function columnHeaderWordWrap(param1:DataGridColumn) : Boolean
      {
         if(param1.headerWordWrap == true)
         {
            return true;
         }
         if(param1.headerWordWrap == false)
         {
            return false;
         }
         return wordWrap;
      }
      
      override protected function drawHighlightIndicator(param1:Sprite, param2:Number, param3:Number, param4:Number, param5:Number, param6:uint, param7:IListItemRenderer) : void
      {
         var _loc8_:ListBaseContentHolder = null;
         var _loc9_:Sprite = null;
         super.drawHighlightIndicator(param1,param2,param3,unscaledWidth - viewMetrics.left - viewMetrics.right,param5,param6,param7);
         if(lockedColumnCount)
         {
            if(param7.parent == listContent)
            {
               _loc8_ = lockedColumnContent;
            }
            else
            {
               _loc8_ = lockedColumnAndRowContent;
            }
            _loc9_ = _loc8_.selectionLayer;
            if(!columnHighlightIndicator)
            {
               columnHighlightIndicator = new SpriteAsset();
               _loc8_.selectionLayer.addChild(DisplayObject(columnHighlightIndicator));
            }
            else if(columnHighlightIndicator.parent != _loc9_)
            {
               _loc9_.addChild(columnHighlightIndicator);
            }
            else
            {
               _loc9_.setChildIndex(DisplayObject(columnHighlightIndicator),_loc9_.numChildren - 1);
            }
            super.drawHighlightIndicator(columnHighlightIndicator,param2,param3,_loc8_.width,param5,param6,param7);
         }
      }
      
      override protected function finishKeySelection() : void
      {
         var _loc1_:String = null;
         var _loc5_:IListItemRenderer = null;
         var _loc7_:Point = null;
         var _loc8_:ListEvent = null;
         var _loc2_:int = listItems.length;
         var _loc3_:int = listItems.length - offscreenExtraRowsTop - offscreenExtraRowsBottom;
         var _loc4_:int = rowInfo[_loc2_ - offscreenExtraRowsBottom - 1].y + rowInfo[_loc2_ - offscreenExtraRowsBottom - 1].height > listContent.heightExcludingOffsets - listContent.topOffset?1:0;
         if(lastKey == Keyboard.PAGE_DOWN)
         {
            if(_loc3_ - _loc4_ == 0)
            {
               caretIndex = Math.min(verticalScrollPosition + lockedRowCount + _loc3_ - _loc4_,collection.length - 1);
            }
            else
            {
               caretIndex = Math.min(verticalScrollPosition + lockedRowCount + _loc3_ - _loc4_ - 1,collection.length - 1);
            }
         }
         var _loc6_:Boolean = false;
         if(bSelectItem && (caretIndex - verticalScrollPosition >= 0 || caretIndex < lockedRowCount))
         {
            if(caretIndex - lockedRowCount - verticalScrollPosition > Math.max(_loc3_ - _loc4_ - 1,0))
            {
               if(lastKey == Keyboard.END && maxVerticalScrollPosition > verticalScrollPosition)
               {
                  caretIndex = caretIndex - 1;
                  moveSelectionVertically(lastKey,bShiftKey,bCtrlKey);
                  return;
               }
               caretIndex = lockedRowCount + _loc3_ - _loc4_ - 1 + verticalScrollPosition;
            }
            if(caretIndex < lockedRowCount)
            {
               _loc5_ = lockedRowContent.listItems[caretIndex][0];
            }
            else
            {
               _loc5_ = listItems[caretIndex - lockedRowCount - verticalScrollPosition + offscreenExtraRowsTop][0];
            }
            if(_loc5_)
            {
               _loc1_ = itemToUID(_loc5_.data);
               _loc5_ = UIDToItemRenderer(_loc1_);
               if(!bCtrlKey || lastKey == Keyboard.SPACE)
               {
                  selectItem(_loc5_,bShiftKey,bCtrlKey);
                  _loc6_ = true;
               }
               if(bCtrlKey)
               {
                  drawItem(_loc5_,selectedData[_loc1_] != null,_loc1_ == highlightUID,true);
               }
            }
         }
         if(_loc6_)
         {
            _loc7_ = itemRendererToIndices(_loc5_);
            _loc8_ = new ListEvent(ListEvent.CHANGE);
            if(_loc7_)
            {
               _loc8_.columnIndex = _loc7_.x;
               _loc8_.rowIndex = _loc7_.y;
            }
            _loc8_.itemRenderer = _loc5_;
            dispatchEvent(_loc8_);
         }
      }
      
      override mx_internal function addClipMask(param1:Boolean) : void
      {
         var _loc2_:Graphics = null;
         var _loc11_:DisplayObject = null;
         var _loc12_:Number = NaN;
         if(param1)
         {
            if(horizontalScrollBar && horizontalScrollBar.visible || hasOnlyTextRenderers() || listContent.bottomOffset != 0 || listContent.topOffset != 0 || listContent.leftOffset != 0 || listContent.rightOffset != 0)
            {
               listContent.mask = maskShape;
               selectionLayer.mask = null;
               if(!headerMask)
               {
                  headerMask = new Shape();
                  addChild(headerMask);
                  _loc2_ = headerMask.graphics;
                  _loc2_.beginFill(16777215);
                  _loc2_.drawRect(0,0,10,10);
                  _loc2_.endFill();
                  headerMask.visible = false;
               }
               header.mask = headerMask;
               header.selectionLayer.mask = null;
               headerMask.width = maskShape.width;
               headerMask.height = maskShape.height;
               headerMask.x = maskShape.x;
               headerMask.y = maskShape.y;
               if(verticalScrollBar != null && verticalScrollBar.visible && (horizontalScrollBar == null || !horizontalScrollBar.visible) && headerVisible)
               {
                  headerMask.width = headerMask.width + verticalScrollBar.getExplicitOrMeasuredWidth();
               }
               if(lockedRowContent)
               {
                  if(!lockedRowMask)
                  {
                     lockedRowMask = new Shape();
                     addChild(lockedRowMask);
                     _loc2_ = lockedRowMask.graphics;
                     _loc2_.beginFill(16777215);
                     _loc2_.drawRect(0,0,10,10);
                     _loc2_.endFill();
                     lockedRowMask.visible = false;
                  }
                  lockedRowContent.mask = lockedRowMask;
                  lockedRowContent.selectionLayer.mask = null;
                  lockedRowMask.width = maskShape.width;
                  lockedRowMask.height = maskShape.height;
                  lockedRowMask.x = maskShape.x;
                  lockedRowMask.y = maskShape.y;
               }
               if(lockedColumnContent)
               {
                  if(!lockedColumnMask)
                  {
                     lockedColumnMask = new Shape();
                     addChild(lockedColumnMask);
                     _loc2_ = lockedColumnMask.graphics;
                     _loc2_.beginFill(16777215);
                     _loc2_.drawRect(0,0,10,10);
                     _loc2_.endFill();
                     lockedColumnMask.visible = false;
                  }
                  lockedColumnContent.mask = lockedColumnMask;
                  lockedColumnContent.selectionLayer.mask = null;
                  lockedColumnMask.width = maskShape.width;
                  lockedColumnMask.height = maskShape.height;
                  lockedColumnMask.x = maskShape.x;
                  lockedColumnMask.y = maskShape.y;
               }
               if(lockedColumnAndRowContent)
               {
                  if(!lockedColumnAndRowMask)
                  {
                     lockedColumnAndRowMask = new Shape();
                     addChild(lockedColumnAndRowMask);
                     _loc2_ = lockedColumnAndRowMask.graphics;
                     _loc2_.beginFill(16777215);
                     _loc2_.drawRect(0,0,10,10);
                     _loc2_.endFill();
                     lockedColumnAndRowMask.visible = false;
                  }
                  lockedColumnAndRowContent.mask = lockedColumnAndRowMask;
                  lockedColumnAndRowContent.selectionLayer.mask = null;
                  lockedColumnAndRowMask.width = maskShape.width;
                  lockedColumnAndRowMask.height = maskShape.height;
                  lockedColumnAndRowMask.x = maskShape.x;
                  lockedColumnAndRowMask.y = maskShape.y;
               }
               if(lockedColumnHeader)
               {
                  if(!lockedColumnHeaderMask)
                  {
                     lockedColumnHeaderMask = new Shape();
                     addChild(lockedColumnHeaderMask);
                     _loc2_ = lockedColumnHeaderMask.graphics;
                     _loc2_.beginFill(16777215);
                     _loc2_.drawRect(0,0,10,10);
                     _loc2_.endFill();
                     lockedColumnHeaderMask.visible = false;
                  }
                  lockedColumnHeader.mask = lockedColumnHeaderMask;
                  lockedColumnHeader.selectionLayer.mask = null;
                  lockedColumnHeaderMask.width = maskShape.width;
                  lockedColumnHeaderMask.height = maskShape.height;
                  lockedColumnHeaderMask.x = maskShape.x;
                  lockedColumnHeaderMask.y = maskShape.y;
               }
            }
            else
            {
               listContent.mask = null;
               selectionLayer.mask = maskShape;
               if(!headerMask)
               {
                  headerMask = new Shape();
                  addChild(headerMask);
                  _loc2_ = headerMask.graphics;
                  _loc2_.beginFill(16777215);
                  _loc2_.drawRect(0,0,10,10);
                  _loc2_.endFill();
                  headerMask.visible = false;
               }
               header.mask = null;
               header.selectionLayer.mask = headerMask;
               headerMask.width = maskShape.width;
               headerMask.height = maskShape.height;
               headerMask.x = maskShape.x;
               headerMask.y = maskShape.y;
               if(verticalScrollBar != null && verticalScrollBar.visible && (horizontalScrollBar == null || !horizontalScrollBar.visible) && headerVisible)
               {
                  headerMask.width = headerMask.width + verticalScrollBar.getExplicitOrMeasuredWidth();
               }
               if(lockedRowContent)
               {
                  if(!lockedRowMask)
                  {
                     lockedRowMask = new Shape();
                     addChild(lockedRowMask);
                     _loc2_ = lockedRowMask.graphics;
                     _loc2_.beginFill(16777215);
                     _loc2_.drawRect(0,0,10,10);
                     _loc2_.endFill();
                     lockedRowMask.visible = false;
                  }
                  lockedRowContent.mask = null;
                  lockedRowContent.selectionLayer.mask = lockedRowMask;
                  lockedRowMask.width = maskShape.width;
                  lockedRowMask.height = maskShape.height;
                  lockedRowMask.x = maskShape.x;
                  lockedRowMask.y = maskShape.y;
               }
               if(lockedColumnContent)
               {
                  if(!lockedColumnMask)
                  {
                     lockedColumnMask = new Shape();
                     addChild(lockedColumnMask);
                     _loc2_ = lockedColumnMask.graphics;
                     _loc2_.beginFill(16777215);
                     _loc2_.drawRect(0,0,10,10);
                     _loc2_.endFill();
                     lockedColumnMask.visible = false;
                  }
                  lockedColumnContent.mask = null;
                  lockedColumnContent.selectionLayer.mask = lockedColumnMask;
                  lockedColumnMask.width = maskShape.width;
                  lockedColumnMask.height = maskShape.height;
                  lockedColumnMask.x = maskShape.x;
                  lockedColumnMask.y = maskShape.y;
               }
               if(lockedColumnAndRowContent)
               {
                  if(!lockedColumnAndRowMask)
                  {
                     lockedColumnAndRowMask = new Shape();
                     addChild(lockedColumnAndRowMask);
                     _loc2_ = lockedColumnAndRowMask.graphics;
                     _loc2_.beginFill(16777215);
                     _loc2_.drawRect(0,0,10,10);
                     _loc2_.endFill();
                     lockedColumnAndRowMask.visible = false;
                  }
                  lockedColumnAndRowContent.mask = null;
                  lockedColumnAndRowContent.selectionLayer.mask = lockedColumnAndRowMask;
                  lockedColumnAndRowMask.width = maskShape.width;
                  lockedColumnAndRowMask.height = maskShape.height;
                  lockedColumnAndRowMask.x = maskShape.x;
                  lockedColumnAndRowMask.y = maskShape.y;
               }
               if(lockedColumnHeader)
               {
                  if(!lockedColumnHeaderMask)
                  {
                     lockedColumnHeaderMask = new Shape();
                     addChild(lockedColumnHeaderMask);
                     _loc2_ = lockedColumnHeaderMask.graphics;
                     _loc2_.beginFill(16777215);
                     _loc2_.drawRect(0,0,10,10);
                     _loc2_.endFill();
                     lockedColumnHeaderMask.visible = false;
                  }
                  lockedColumnHeader.mask = null;
                  lockedColumnHeader.selectionLayer.mask = lockedColumnHeaderMask;
                  lockedColumnHeaderMask.width = maskShape.width;
                  lockedColumnHeaderMask.height = maskShape.height;
                  lockedColumnHeaderMask.x = maskShape.x;
                  lockedColumnHeaderMask.y = maskShape.y;
               }
            }
         }
         if(listContent.mask)
         {
            return;
         }
         var _loc3_:int = listItems.length - 1;
         var _loc4_:ListRowInfo = rowInfo[_loc3_];
         var _loc5_:Array = listItems[_loc3_];
         if(_loc4_.y + _loc4_.height <= listContent.height)
         {
            return;
         }
         var _loc6_:int = _loc5_.length;
         var _loc7_:Number = _loc4_.y;
         var _loc8_:Number = listContent.width;
         var _loc9_:Number = listContent.height - _loc4_.y;
         var _loc10_:int = 0;
         while(_loc10_ < _loc6_)
         {
            _loc11_ = _loc5_[_loc10_];
            _loc12_ = _loc11_.y - _loc7_;
            if(_loc11_ is IUITextField)
            {
               _loc11_.height = Math.max(_loc9_ - _loc12_,0);
            }
            else
            {
               _loc11_.mask = createItemMask(0,_loc7_ + _loc12_,_loc8_,Math.max(_loc9_ - _loc12_,0));
            }
            _loc10_++;
         }
         if(lockedColumnContent)
         {
            _loc5_ = lockedColumnContent.listItems[_loc3_];
            _loc6_ = _loc5_.length;
            _loc8_ = lockedColumnContent.width;
            _loc10_ = 0;
            while(_loc10_ < _loc6_)
            {
               _loc11_ = _loc5_[_loc10_];
               _loc12_ = _loc11_.y - _loc7_;
               if(_loc11_ is IUITextField)
               {
                  _loc11_.height = Math.max(_loc9_ - _loc12_,0);
               }
               else
               {
                  _loc11_.mask = createItemMask(0,_loc7_ + _loc12_,_loc8_,Math.max(_loc9_ - _loc12_,0),lockedColumnContent);
               }
               _loc10_++;
            }
         }
      }
      
      mx_internal function get headerVisible() : Boolean
      {
         return showHeaders && headerHeight > 0;
      }
      
      public function set headerHeight(param1:Number) : void
      {
         _headerHeight = param1;
         _explicitHeaderHeight = true;
         itemsSizeChanged = true;
         invalidateDisplayList();
      }
      
      mx_internal function resizeColumn(param1:int, param2:Number) : void
      {
      }
      
      override protected function drawCaretIndicator(param1:Sprite, param2:Number, param3:Number, param4:Number, param5:Number, param6:uint, param7:IListItemRenderer) : void
      {
         var _loc8_:ListBaseContentHolder = null;
         var _loc9_:Sprite = null;
         super.drawCaretIndicator(param1,param2,param3,unscaledWidth - viewMetrics.left - viewMetrics.right,param5,param6,param7);
         if(lockedColumnCount)
         {
            if(param7.parent == listContent)
            {
               _loc8_ = lockedColumnContent;
            }
            else
            {
               _loc8_ = lockedColumnAndRowContent;
            }
            _loc9_ = _loc8_.selectionLayer;
            if(!columnCaretIndicator)
            {
               columnCaretIndicator = new SpriteAsset();
               _loc8_.selectionLayer.addChild(DisplayObject(columnCaretIndicator));
            }
            else if(columnCaretIndicator.parent != _loc9_)
            {
               _loc9_.addChild(columnCaretIndicator);
            }
            else
            {
               _loc9_.setChildIndex(DisplayObject(columnCaretIndicator),_loc9_.numChildren - 1);
            }
            super.drawCaretIndicator(columnCaretIndicator,param2,param3,_loc8_.width,param5,param6,param7);
         }
      }
      
      mx_internal function get dataGridLockedRows() : ListBaseContentHolder
      {
         return lockedRowContent;
      }
      
      protected function layoutColumnItemRenderer(param1:DataGridColumn, param2:IListItemRenderer, param3:Number, param4:Number) : Point
      {
         var _loc5_:Number = 0;
         var _loc6_:Number = 0;
         if(param2)
         {
            param2.explicitWidth = _loc5_ = getWidthOfItem(param2,param1);
            UIComponentGlobals.layoutManager.validateClient(param2,true);
            _loc6_ = param2.getExplicitOrMeasuredHeight();
            param2.setActualSize(_loc5_,!!variableRowHeight?Number(param2.getExplicitOrMeasuredHeight()):Number(rowHeight - cachedPaddingTop - cachedPaddingBottom));
            param2.move(param3,param4 + cachedPaddingTop);
         }
         return new Point(_loc5_,_loc6_);
      }
      
      override public function showDropFeedback(param1:DragEvent) : void
      {
         var _loc3_:Class = null;
         var _loc4_:EdgeMetrics = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         if(!dropIndicator)
         {
            _loc3_ = getStyle("dropIndicatorSkin");
            if(!_loc3_)
            {
               _loc3_ = ListDropIndicator;
            }
            dropIndicator = IFlexDisplayObject(new _loc3_());
            _loc4_ = viewMetrics;
            drawFocus(true);
            dropIndicator.x = 2;
            dropIndicator.setActualSize(listContent.width - 4,4);
            dropIndicator.visible = true;
            listContent.addChild(DisplayObject(dropIndicator));
            if(collection)
            {
               dragScrollingInterval = setInterval(dragScroll,15);
            }
         }
         var _loc2_:Number = calculateDropIndex(param1);
         if(lockedRowCount && _loc2_ < lockedRowCount)
         {
            if(dropIndicator.parent != lockedRowContent)
            {
               lockedRowContent.addChild(DisplayObject(dropIndicator));
            }
            dropIndicator.y = lockedRowContent.listItems[_loc2_][0].y - 1;
         }
         else
         {
            _loc5_ = listItems.length;
            _loc6_ = _loc5_ > 0 && rowInfo[_loc5_ - offscreenExtraRowsBottom - 1].y + rowInfo[_loc5_ - offscreenExtraRowsBottom - 1].height > listContent.heightExcludingOffsets - listContent.topOffset?1:0;
            _loc2_ = _loc2_ - (verticalScrollPosition + lockedRowCount);
            if(_loc2_ >= _loc5_)
            {
               if(_loc6_)
               {
                  _loc2_ = _loc5_ - 1;
               }
               else
               {
                  _loc2_ = _loc5_;
               }
            }
            if(_loc2_ < 0)
            {
               _loc2_ = 0;
            }
            if(dropIndicator.parent != listContent)
            {
               listContent.addChild(DisplayObject(dropIndicator));
            }
            dropIndicator.y = calculateDropIndicatorY(_loc5_,_loc2_ + offscreenExtraRowsTop);
         }
      }
      
      mx_internal function columnRendererChanged(param1:DataGridColumn) : void
      {
      }
      
      override protected function selectItem(param1:IListItemRenderer, param2:Boolean, param3:Boolean, param4:Boolean = true) : Boolean
      {
         var _loc5_:CursorBookmark = iterator.bookmark;
         if(lockedRowCount)
         {
            inSelectItem = true;
            iterator.seek(CursorBookmark.FIRST,0);
         }
         var _loc6_:Boolean = super.selectItem(param1,param2,param3,param4);
         if(lockedRowCount)
         {
            iterator.seek(_loc5_,0);
            inSelectItem = false;
         }
         return _loc6_;
      }
      
      mx_internal function get dataGridLockedColumns() : ListBaseContentHolder
      {
         return lockedColumnContent;
      }
      
      override protected function addToRowArrays() : void
      {
         super.addToRowArrays();
         if(lockedColumnCount)
         {
            lockedColumnContent.listItems.splice(0,0,null);
            lockedColumnContent.rowInfo.splice(0,0,null);
         }
      }
      
      override public function itemRendererToIndex(param1:IListItemRenderer) : int
      {
         var _loc2_:int = 0;
         if(param1.name in rowMap)
         {
            _loc2_ = rowMap[param1.name].rowIndex;
            if(param1.parent is mx.controls.dataGridClasses.DataGridLockedRowContentHolder)
            {
               return _loc2_;
            }
            return _loc2_ + lockedRowCount + verticalScrollPosition - offscreenExtraRowsTop;
         }
         return int.MIN_VALUE;
      }
      
      override protected function makeRowsAndColumns(param1:Number, param2:Number, param3:Number, param4:Number, param5:int, param6:int, param7:Boolean = false, param8:uint = 0) : Point
      {
         return makeRows(listContent,param1,param2,param3,param4,param5,param6,param7,param8);
      }
      
      protected function removeExtraRow(param1:ListBaseContentHolder) : void
      {
         var _loc2_:IListItemRenderer = null;
         var _loc5_:ListBaseContentHolder = null;
         var _loc3_:Array = param1.listItems;
         var _loc4_:Object = param1.rowInfo;
         if(param1 == lockedRowContent)
         {
            _loc5_ = lockedColumnAndRowContent;
         }
         else
         {
            _loc5_ = lockedColumnContent;
         }
         var _loc6_:Array = _loc3_.pop();
         _loc4_.pop();
         while(_loc6_.length)
         {
            _loc2_ = _loc6_.pop();
            addToFreeItemRenderers(_loc2_);
         }
         if(_loc5_)
         {
            _loc5_.rowInfo.pop();
            _loc6_ = _loc5_.listItems.pop();
            while(_loc6_ && _loc6_.length)
            {
               _loc2_ = _loc6_.pop();
               addToFreeItemRenderers(_loc2_);
            }
         }
      }
      
      override mx_internal function selectionTween_updateHandler(param1:TweenEvent) : void
      {
         var _loc2_:Sprite = null;
         super.selectionTween_updateHandler(param1);
         if(lockedColumnCount)
         {
            _loc2_ = Sprite(param1.target.listener);
            _loc2_ = indicatorDictionary[_loc2_] as Sprite;
            _loc2_.alpha = Number(param1.value);
         }
      }
      
      override protected function purgeItemRenderers() : void
      {
         var _loc1_:Array = null;
         var _loc2_:Array = null;
         var _loc3_:IListItemRenderer = null;
         if(lockedRowContent)
         {
            _loc1_ = lockedRowContent.listItems;
            while(_loc1_.length)
            {
               _loc2_ = _loc1_.pop();
               while(_loc2_.length)
               {
                  _loc3_ = IListItemRenderer(_loc2_.pop());
                  if(_loc3_)
                  {
                     lockedRowContent.removeChild(DisplayObject(_loc3_));
                     delete lockedRowContent.visibleData[itemToUID(_loc3_.data)];
                  }
               }
            }
         }
         if(lockedColumnContent)
         {
            _loc1_ = lockedColumnContent.listItems;
            while(_loc1_.length)
            {
               _loc2_ = _loc1_.pop();
               while(_loc2_.length)
               {
                  _loc3_ = IListItemRenderer(_loc2_.pop());
                  if(_loc3_)
                  {
                     lockedColumnContent.removeChild(DisplayObject(_loc3_));
                     delete lockedColumnContent.visibleData[itemToUID(_loc3_.data)];
                  }
               }
            }
         }
         if(lockedColumnAndRowContent)
         {
            _loc1_ = lockedColumnAndRowContent.listItems;
            while(_loc1_.length)
            {
               _loc2_ = _loc1_.pop();
               while(_loc2_.length)
               {
                  _loc3_ = IListItemRenderer(_loc2_.pop());
                  if(_loc3_)
                  {
                     lockedColumnAndRowContent.removeChild(DisplayObject(_loc3_));
                     delete lockedColumnAndRowContent.visibleData[itemToUID(_loc3_.data)];
                  }
               }
            }
         }
         super.purgeItemRenderers();
      }
      
      protected function clearRow(param1:ListBaseContentHolder, param2:int) : void
      {
         var _loc4_:ListBaseContentHolder = null;
         var _loc5_:IListItemRenderer = null;
         var _loc3_:Array = param1.listItems;
         if(lockedColumnCount > 0)
         {
            if(param1 == lockedRowContent)
            {
               _loc4_ = lockedColumnAndRowContent;
            }
            else
            {
               _loc4_ = lockedColumnContent;
            }
         }
         else
         {
            _loc4_ = null;
         }
         while(_loc3_[param2].length)
         {
            _loc5_ = _loc3_[param2].pop();
            addToFreeItemRenderers(_loc5_);
         }
         if(_loc4_)
         {
            while(_loc4_.listItems[param2].length)
            {
               _loc5_ = _loc4_.listItems[param2].pop();
               addToFreeItemRenderers(_loc5_);
            }
         }
      }
      
      override protected function moveIndicatorsVertically(param1:String, param2:Number) : void
      {
         super.moveIndicatorsVertically(param1,param2);
         if(lockedColumnCount)
         {
            if(param1)
            {
               if(selectionIndicators[param1])
               {
                  Sprite(indicatorDictionary[selectionIndicators[param1]]).y = Sprite(indicatorDictionary[selectionIndicators[param1]]).y + param2;
               }
               if(highlightUID == param1)
               {
                  columnHighlightIndicator.y = columnHighlightIndicator.y + param2;
               }
               if(caretUID == param1)
               {
                  columnCaretIndicator.y = columnCaretIndicator.y + param2;
               }
            }
         }
      }
      
      mx_internal function getAllVisibleColumns() : Array
      {
         var _loc1_:Array = [];
         if(lockedColumnCount)
         {
            _loc1_ = _loc1_.concat(visibleLockedColumns);
         }
         _loc1_ = _loc1_.concat(visibleColumns);
         return _loc1_;
      }
      
      override protected function drawSelectionIndicator(param1:Sprite, param2:Number, param3:Number, param4:Number, param5:Number, param6:uint, param7:IListItemRenderer) : void
      {
         var _loc8_:ListBaseContentHolder = null;
         var _loc9_:Sprite = null;
         var _loc10_:Sprite = null;
         super.drawSelectionIndicator(param1,param2,param3,unscaledWidth - viewMetrics.left - viewMetrics.right,param5,param6,param7);
         if(lockedColumnCount)
         {
            if(param7.parent == listContent)
            {
               _loc8_ = lockedColumnContent;
            }
            else
            {
               _loc8_ = lockedColumnAndRowContent;
            }
            _loc9_ = _loc8_.selectionLayer;
            _loc10_ = indicatorDictionary[param1] as Sprite;
            if(!_loc10_)
            {
               _loc10_ = new SpriteAsset();
               _loc10_.mouseEnabled = false;
               _loc9_.addChild(DisplayObject(_loc10_));
               param1.parent.addEventListener(Event.REMOVED,selectionRemovedListener);
               indicatorDictionary[param1] = _loc10_;
            }
            super.drawSelectionIndicator(_loc10_,param2,param3,_loc8_.width,param5,param6,param7);
         }
      }
      
      public function get fontContext() : IFlexModuleFactory
      {
         return moduleFactory;
      }
      
      override protected function itemRendererToIndices(param1:IListItemRenderer) : Point
      {
         if(!param1 || !(param1.name in rowMap))
         {
            return null;
         }
         var _loc2_:ListBaseContentHolder = param1.parent as ListBaseContentHolder;
         var _loc3_:Boolean = false;
         var _loc4_:int = rowMap[param1.name].rowIndex;
         var _loc5_:int = _loc2_.listItems[_loc4_].length;
         var _loc6_:int = 0;
         while(_loc6_ < _loc5_)
         {
            if(_loc2_.listItems[_loc4_][_loc6_] == param1)
            {
               _loc3_ = true;
               break;
            }
            _loc6_++;
         }
         if(!_loc3_)
         {
            return null;
         }
         if(lockedRowContent == _loc2_)
         {
            return new Point(_loc6_ + horizontalScrollPosition + lockedColumnCount,_loc4_ + offscreenExtraRowsTop);
         }
         if(lockedColumnAndRowContent == _loc2_)
         {
            return new Point(_loc6_,_loc4_ + offscreenExtraRowsTop);
         }
         if(lockedColumnContent == _loc2_)
         {
            return new Point(_loc6_,_loc4_ + verticalScrollPosition + lockedRowCount + offscreenExtraRowsTop);
         }
         return new Point(_loc6_ + horizontalScrollPosition + lockedColumnCount,_loc4_ + verticalScrollPosition + lockedRowCount + offscreenExtraRowsTop);
      }
      
      protected function updateRendererDisplayList(param1:IListItemRenderer) : void
      {
         var _loc2_:IInvalidating = null;
         if(param1 is IInvalidating)
         {
            _loc2_ = IInvalidating(param1);
            _loc2_.invalidateDisplayList();
            _loc2_.validateNow();
         }
      }
      
      override public function indicesToIndex(param1:int, param2:int) : int
      {
         if(inSelectItem)
         {
            return 0;
         }
         return param1;
      }
      
      override protected function clearIndicators() : void
      {
         super.clearIndicators();
         if(lockedColumnCount && lockedColumnContent)
         {
            while(lockedColumnContent.selectionLayer.numChildren > 0)
            {
               lockedColumnContent.selectionLayer.removeChildAt(0);
            }
         }
         if(lockedRowCount && lockedRowContent)
         {
            while(lockedRowContent.selectionLayer.numChildren > 0)
            {
               lockedRowContent.selectionLayer.removeChildAt(0);
            }
            if(lockedColumnCount && lockedColumnAndRowContent)
            {
               while(lockedColumnAndRowContent.selectionLayer.numChildren > 0)
               {
                  lockedColumnAndRowContent.selectionLayer.removeChildAt(0);
               }
            }
         }
         if(header)
         {
            header.clearSelectionLayer();
         }
         if(lockedColumnHeader)
         {
            lockedColumnHeader.clearSelectionLayer();
         }
      }
      
      protected function makeListData(param1:Object, param2:String, param3:int, param4:int, param5:DataGridColumn) : BaseListData
      {
         if(param1 is DataGridColumn)
         {
            return new DataGridListData(param5.headerText != null?param5.headerText:param5.dataField,param5.dataField,param4,param2,this,param3);
         }
         return new DataGridListData(param5.itemToLabel(param1),param5.dataField,param4,param2,this,param3);
      }
      
      override protected function drawItem(param1:IListItemRenderer, param2:Boolean = false, param3:Boolean = false, param4:Boolean = false, param5:Boolean = false) : void
      {
         var _loc7_:int = 0;
         var _loc8_:IListItemRenderer = null;
         var _loc9_:ListBaseContentHolder = null;
         if(!param1)
         {
            return;
         }
         super.drawItem(param1,param2,param3,param4,param5);
         var _loc6_:int = rowMap[param1.name].rowIndex;
         _loc7_ = 0;
         while(_loc7_ < visibleColumns.length)
         {
            _loc8_ = (param1.parent as ListBaseContentHolder).listItems[_loc6_][_loc7_];
            updateRendererDisplayList(_loc8_);
            _loc7_++;
         }
         if(lockedColumnCount)
         {
            if(param1.parent == listContent || param1.parent == lockedColumnContent)
            {
               _loc9_ = lockedColumnContent;
            }
            else
            {
               _loc9_ = lockedColumnAndRowContent;
            }
            _loc7_ = 0;
            while(_loc7_ < visibleLockedColumns.length)
            {
               _loc8_ = _loc9_.listItems[_loc6_][_loc7_];
               updateRendererDisplayList(_loc8_);
               _loc7_++;
            }
         }
      }
      
      override protected function adjustAfterRemove(param1:Array, param2:int, param3:Boolean) : Boolean
      {
         var firstUID:String = null;
         var i:int = 0;
         var uid:String = null;
         var items:Array = param1;
         var location:int = param2;
         var requiresValueCommit:Boolean = param3;
         var adjustIterator:Boolean = false;
         if(lockedRowCount && listItems.length && listItems[0].length)
         {
            if(location <= lockedRowCount + verticalScrollPosition)
            {
               adjustIterator = true;
            }
            else
            {
               firstUID = rowMap[listItems[0][0].name].uid;
               i = 0;
               while(i < items.length)
               {
                  uid = itemToUID(items[i]);
                  if(uid == firstUID && verticalScrollPosition == 0)
                  {
                     adjustIterator = true;
                     break;
                  }
                  i++;
               }
            }
         }
         var retval:Boolean = super.adjustAfterRemove(items,location,requiresValueCommit);
         if(lockedRowCount)
         {
            if(verticalScrollPosition > 0 && location > lockedRowCount && verticalScrollPosition <= lockedRowCount && verticalScrollPosition == maxVerticalScrollPosition)
            {
               super.verticalScrollPosition = verticalScrollPosition - items.length;
               adjustIterator = true;
            }
            if(adjustIterator)
            {
               try
               {
                  iterator.seek(CursorBookmark.FIRST,lockedRowCount + verticalScrollPosition);
                  if(!iteratorValid)
                  {
                     iteratorValid = true;
                     lastSeekPending = null;
                  }
               }
               catch(e:ItemPendingError)
               {
                  lastSeekPending = new ListBaseSeekPending(CursorBookmark.FIRST,lockedRowCount + verticalScrollPosition);
                  e.addResponder(new ItemResponder(seekPendingResultHandler,seekPendingFailureHandler,lastSeekPending));
                  iteratorValid = false;
               }
            }
         }
         return retval;
      }
      
      override protected function clearCaretIndicator(param1:Sprite, param2:IListItemRenderer) : void
      {
         super.clearCaretIndicator(param1,param2);
         if(lockedColumnCount)
         {
            if(columnCaretIndicator)
            {
               Sprite(columnCaretIndicator).graphics.clear();
            }
         }
      }
      
      public function get lockedRowCount() : int
      {
         return _lockedRowCount;
      }
      
      mx_internal function get gridColumnMap() : Object
      {
         return columnMap;
      }
      
      override protected function UIDToItemRenderer(param1:String) : IListItemRenderer
      {
         var _loc2_:IListItemRenderer = visibleData[param1];
         if(!_loc2_)
         {
            if(lockedRowContent)
            {
               _loc2_ = lockedRowContent.visibleData[param1];
            }
         }
         if(!_loc2_)
         {
            if(lockedColumnContent)
            {
               _loc2_ = lockedColumnContent.visibleData[param1];
            }
         }
         if(!_loc2_)
         {
            if(lockedColumnAndRowContent)
            {
               _loc2_ = lockedColumnAndRowContent.visibleData[param1];
            }
         }
         return _loc2_;
      }
      
      override protected function destroyRow(param1:int, param2:int) : void
      {
         var _loc3_:Array = null;
         var _loc4_:Array = null;
         var _loc5_:Object = null;
         var _loc6_:IListItemRenderer = null;
         var _loc7_:String = null;
         var _loc8_:int = 0;
         super.destroyRow(param1,param2);
         if(lockedColumnCount)
         {
            _loc3_ = lockedColumnContent.listItems;
            param2 = _loc3_[param1].length;
            _loc4_ = lockedColumnContent.rowInfo;
            _loc5_ = lockedColumnContent.visibleData;
            _loc7_ = _loc4_[param1].uid;
            removeIndicators(_loc7_);
            _loc8_ = 0;
            while(_loc8_ < param2)
            {
               _loc6_ = _loc3_[param1][_loc8_];
               if(_loc6_.data)
               {
                  delete _loc5_[_loc7_];
               }
               addToFreeItemRenderers(_loc6_);
               _loc8_++;
            }
         }
      }
      
      public function createColumnItemRenderer(param1:DataGridColumn, param2:Boolean, param3:Object) : IListItemRenderer
      {
         var _loc4_:IFactory = null;
         var _loc5_:IListItemRenderer = null;
         var _loc6_:Dictionary = null;
         var _loc7_:* = undefined;
         _loc4_ = param1.getItemRendererFactory(param2,param3);
         if(!_loc4_)
         {
            if(!param3)
            {
               _loc4_ = nullItemRenderer;
            }
            if(!_loc4_)
            {
               _loc4_ = itemRenderer;
            }
         }
         if(_loc4_ == param1.itemRenderer)
         {
            if(freeItemRenderersTable[param1] && freeItemRenderersTable[param1].length)
            {
               _loc5_ = freeItemRenderersTable[param1].pop();
               delete param1.freeItemRenderersByFactory[_loc4_][_loc5_];
            }
         }
         else if(param1.freeItemRenderersByFactory)
         {
            _loc6_ = param1.freeItemRenderersByFactory[_loc4_];
            if(_loc6_)
            {
               for(_loc7_ in _loc6_)
               {
                  _loc5_ = IListItemRenderer(_loc7_);
                  delete _loc6_[_loc7_];
               }
            }
         }
         if(!_loc5_)
         {
            _loc5_ = _loc4_.newInstance();
            if(_loc5_)
            {
               _loc5_.styleName = param1;
               factoryMap[_loc5_] = _loc4_;
            }
         }
         if(_loc5_)
         {
            _loc5_.owner = this;
         }
         return _loc5_;
      }
      
      public function set showHeaders(param1:Boolean) : void
      {
         if(param1 == _showHeaders)
         {
            return;
         }
         _showHeaders = param1;
         itemsSizeChanged = true;
         invalidateDisplayList();
         dispatchEvent(new Event("showHeadersChanged"));
      }
      
      override protected function addToFreeItemRenderers(param1:IListItemRenderer) : void
      {
         var _loc5_:DataGridColumn = null;
         DisplayObject(param1).visible = false;
         delete rowMap[param1.name];
         var _loc2_:IFactory = factoryMap[param1];
         var _loc3_:String = itemToUID(param1.data);
         var _loc4_:Object = ListBaseContentHolder(param1.parent).visibleData;
         if(_loc4_[_loc3_] == param1)
         {
            delete _loc4_[_loc3_];
         }
         if(columnMap[param1.name])
         {
            _loc5_ = columnMap[param1.name];
            if(_loc2_ == _loc5_.itemRenderer)
            {
               if(freeItemRenderersTable[_loc5_] == undefined)
               {
                  freeItemRenderersTable[_loc5_] = [];
               }
               freeItemRenderersTable[_loc5_].push(param1);
            }
            if(!_loc5_.freeItemRenderersByFactory)
            {
               _loc5_.freeItemRenderersByFactory = new Dictionary(true);
            }
            if(_loc5_.freeItemRenderersByFactory[_loc2_] == undefined)
            {
               _loc5_.freeItemRenderersByFactory[_loc2_] = new Dictionary(true);
            }
            _loc5_.freeItemRenderersByFactory[_loc2_][param1] = 1;
            delete columnMap[param1.name];
         }
      }
      
      override protected function moveSelectionVertically(param1:uint, param2:Boolean, param3:Boolean) : void
      {
         var _loc4_:Number = NaN;
         var _loc5_:IListItemRenderer = null;
         var _loc6_:String = null;
         var _loc7_:int = 0;
         var _loc13_:ScrollEvent = null;
         var _loc8_:Boolean = false;
         showCaret = true;
         var _loc9_:int = listItems.length;
         var _loc10_:int = listItems.length - offscreenExtraRowsTop - offscreenExtraRowsBottom;
         var _loc11_:int = rowInfo[_loc9_ - offscreenExtraRowsBottom - 1].y + rowInfo[_loc9_ - offscreenExtraRowsBottom - 1].height > listContent.heightExcludingOffsets - listContent.topOffset?1:0;
         var _loc12_:Boolean = false;
         bSelectItem = false;
         switch(param1)
         {
            case Keyboard.UP:
               if(caretIndex > 0)
               {
                  caretIndex--;
                  bSelectItem = true;
                  if(caretIndex >= lockedRowCount)
                  {
                     _loc12_ = true;
                  }
               }
               break;
            case Keyboard.DOWN:
               if(caretIndex >= lockedRowCount - 1)
               {
                  if(caretIndex < collection.length - 1)
                  {
                     caretIndex++;
                     _loc12_ = true;
                     bSelectItem = true;
                  }
                  else if(caretIndex == collection.length - 1 && _loc11_)
                  {
                     if(verticalScrollPosition < maxVerticalScrollPosition)
                     {
                        _loc4_ = verticalScrollPosition + 1;
                     }
                  }
               }
               else if(caretIndex < collection.length - 1)
               {
                  caretIndex++;
                  bSelectItem = true;
               }
               break;
            case Keyboard.PAGE_UP:
               if(caretIndex > lockedRowCount)
               {
                  if(caretIndex > verticalScrollPosition + lockedRowCount && caretIndex < verticalScrollPosition + lockedRowCount + _loc10_)
                  {
                     caretIndex = verticalScrollPosition + lockedRowCount;
                  }
                  else
                  {
                     caretIndex = Math.max(caretIndex - Math.max(_loc10_ - _loc11_,1),lockedRowCount);
                     _loc4_ = Math.max(caretIndex,lockedRowCount) - lockedRowCount;
                  }
                  bSelectItem = true;
               }
               else
               {
                  caretIndex = 0;
                  bSelectItem = true;
               }
               break;
            case Keyboard.PAGE_DOWN:
               if(!(caretIndex >= verticalScrollPosition + lockedRowCount && caretIndex < verticalScrollPosition + lockedRowCount + _loc10_ - _loc11_ - 1))
               {
                  if(caretIndex - lockedRowCount == verticalScrollPosition && _loc10_ - _loc11_ <= 1)
                  {
                     caretIndex++;
                  }
                  _loc4_ = Math.min(Math.max(caretIndex - lockedRowCount,0),maxVerticalScrollPosition);
               }
               bSelectItem = true;
               break;
            case Keyboard.HOME:
               if(caretIndex > 0)
               {
                  caretIndex = 0;
                  bSelectItem = true;
                  _loc4_ = 0;
               }
               break;
            case Keyboard.END:
               if(lockedRowCount >= collection.length)
               {
                  caretIndex = collection.length - 1;
                  bSelectItem = true;
               }
               else if(caretIndex < collection.length - 1)
               {
                  caretIndex = collection.length - 1;
                  bSelectItem = true;
                  _loc4_ = maxVerticalScrollPosition;
               }
               break;
            case Keyboard.SPACE:
               _loc12_ = true;
               bSelectItem = true;
         }
         if(_loc12_)
         {
            if(caretIndex >= verticalScrollPosition + lockedRowCount + _loc10_ - _loc11_)
            {
               if(_loc10_ - _loc11_ == 0)
               {
                  _loc4_ = Math.min(maxVerticalScrollPosition,Math.max(caretIndex - lockedRowCount,0));
               }
               else
               {
                  _loc4_ = Math.min(maxVerticalScrollPosition,caretIndex - lockedRowCount - _loc10_ + _loc11_ + 1);
               }
            }
            else if(caretIndex < verticalScrollPosition + lockedRowCount)
            {
               _loc4_ = Math.max(caretIndex - lockedRowCount,0);
            }
         }
         if(!isNaN(_loc4_))
         {
            if(verticalScrollPosition != _loc4_)
            {
               _loc13_ = new ScrollEvent(ScrollEvent.SCROLL);
               _loc13_.detail = ScrollEventDetail.THUMB_POSITION;
               _loc13_.direction = ScrollEventDirection.VERTICAL;
               _loc13_.delta = _loc4_ - verticalScrollPosition;
               _loc13_.position = _loc4_;
               verticalScrollPosition = _loc4_;
               dispatchEvent(_loc13_);
            }
            if(!iteratorValid)
            {
               keySelectionPending = true;
               return;
            }
         }
         bShiftKey = param2;
         bCtrlKey = param3;
         lastKey = param1;
         finishKeySelection();
      }
      
      override protected function set allowItemSizeChangeNotification(param1:Boolean) : void
      {
         if(lockedColumnContent)
         {
            lockedColumnContent.allowItemSizeChangeNotification = param1;
         }
         if(lockedRowContent)
         {
            lockedRowContent.allowItemSizeChangeNotification = param1;
         }
         if(lockedColumnAndRowContent)
         {
            lockedColumnAndRowContent.allowItemSizeChangeNotification = param1;
         }
         super.allowItemSizeChangeNotification = param1;
      }
      
      override protected function clearVisibleData() : void
      {
         if(lockedColumnContent)
         {
            lockedColumnContent.visibleData = {};
         }
         if(lockedRowContent)
         {
            lockedRowContent.visibleData = {};
         }
         if(lockedColumnAndRowContent)
         {
            lockedColumnAndRowContent.visibleData = {};
         }
         super.clearVisibleData();
      }
      
      override protected function moveRowVertically(param1:int, param2:int, param3:Number) : void
      {
         var _loc4_:Array = null;
         var _loc5_:Array = null;
         var _loc6_:IListItemRenderer = null;
         var _loc7_:int = 0;
         super.moveRowVertically(param1,param2,param3);
         if(lockedColumnCount)
         {
            _loc4_ = lockedColumnContent.listItems;
            param2 = _loc4_[param1].length;
            _loc5_ = lockedColumnContent.rowInfo;
            _loc7_ = 0;
            while(_loc7_ < param2)
            {
               _loc6_ = _loc4_[param1][_loc7_];
               _loc6_.move(_loc6_.x,_loc6_.y + param3);
               _loc7_++;
            }
         }
      }
      
      override mx_internal function mouseEventToItemRendererOrEditor(param1:MouseEvent) : IListItemRenderer
      {
         var _loc4_:ListBaseContentHolder = null;
         var _loc6_:Array = null;
         var _loc7_:Array = null;
         var _loc8_:Point = null;
         var _loc9_:Number = NaN;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:Number = NaN;
         var _loc13_:int = 0;
         var _loc14_:int = 0;
         var _loc2_:Boolean = false;
         var _loc3_:DisplayObject = DisplayObject(param1.target);
         var _loc5_:Array = this.visibleColumns;
         if(param1.target == listContent)
         {
            _loc4_ = listContent;
         }
         else if(param1.target == lockedColumnContent)
         {
            _loc4_ = lockedColumnContent;
            _loc5_ = visibleLockedColumns;
         }
         else if(param1.target == lockedRowContent)
         {
            _loc4_ = lockedRowContent;
         }
         else if(param1.target == lockedColumnAndRowContent)
         {
            _loc4_ = lockedColumnAndRowContent;
            _loc5_ = visibleLockedColumns;
         }
         else if(param1.target == highlightIndicator)
         {
            _loc4_ = highlightIndicator.parent.parent as ListBaseContentHolder;
            _loc5_ = this.visibleColumns;
            if(_loc4_ == lockedColumnContent || _loc4_ == lockedColumnAndRowContent)
            {
               _loc5_ = visibleLockedColumns;
            }
            _loc2_ = true;
         }
         else if(param1.target == columnHighlightIndicator)
         {
            _loc4_ = columnHighlightIndicator.parent.parent as ListBaseContentHolder;
            _loc5_ = this.visibleColumns;
            if(_loc4_ == lockedColumnContent || _loc4_ == lockedColumnAndRowContent)
            {
               _loc5_ = visibleLockedColumns;
            }
            _loc2_ = true;
         }
         if(_loc2_ || _loc3_ == _loc4_)
         {
            _loc6_ = _loc4_.listItems;
            _loc7_ = _loc4_.rowInfo;
            _loc8_ = new Point(param1.stageX,param1.stageY);
            _loc8_ = _loc4_.globalToLocal(_loc8_);
            _loc9_ = 0;
            _loc10_ = _loc6_.length;
            _loc11_ = 0;
            while(_loc11_ < _loc10_)
            {
               if(_loc6_[_loc11_].length)
               {
                  if(_loc8_.y < _loc9_ + _loc7_[_loc11_].height)
                  {
                     _loc12_ = 0;
                     _loc13_ = _loc5_.length;
                     _loc14_ = 0;
                     while(_loc14_ < _loc13_)
                     {
                        if(_loc8_.x < _loc12_ + _loc5_[_loc14_].width)
                        {
                           return _loc6_[_loc11_][_loc14_];
                        }
                        _loc12_ = _loc12_ + _loc5_[_loc14_].width;
                        _loc14_++;
                     }
                  }
               }
               _loc9_ = _loc9_ + _loc7_[_loc11_].height;
               _loc11_++;
            }
         }
         while(_loc3_ && _loc3_ != this)
         {
            if(_loc3_ is IListItemRenderer && _loc3_.parent && _loc3_.parent.parent == this && _loc3_.parent is ListBaseContentHolder)
            {
               if(_loc3_.visible)
               {
                  return IListItemRenderer(_loc3_);
               }
               break;
            }
            if(_loc3_ is IUIComponent)
            {
               _loc3_ = IUIComponent(_loc3_).owner;
            }
            else
            {
               _loc3_ = _loc3_.parent;
            }
         }
         return null;
      }
      
      mx_internal function getWidthOfItem(param1:IListItemRenderer, param2:DataGridColumn) : Number
      {
         return param2.width;
      }
      
      override protected function indexToRow(param1:int) : int
      {
         if(param1 < lockedRowCount)
         {
            return -1;
         }
         return param1 - lockedRowCount;
      }
      
      mx_internal function get dataGridHeader() : mx.controls.dataGridClasses.DataGridHeaderBase
      {
         return header;
      }
      
      public function set fontContext(param1:IFlexModuleFactory) : void
      {
         this.moduleFactory = param1;
      }
      
      protected function drawVisibleItem(param1:String, param2:Boolean = false, param3:Boolean = false, param4:Boolean = false, param5:Boolean = false) : void
      {
         if(visibleData[param1])
         {
            drawItem(visibleData[param1],param2,param3,param4,param5);
         }
         if(lockedRowCount && lockedRowContent && lockedRowContent.visibleData[param1])
         {
            drawItem(lockedRowContent.visibleData[param1],param2,param3,param4,param5);
         }
      }
      
      protected function prepareRowArray(param1:ListBaseContentHolder, param2:int) : void
      {
         var _loc4_:ListBaseContentHolder = null;
         var _loc3_:Array = param1.listItems;
         if(lockedColumnCount > 0)
         {
            if(param1 == lockedRowContent)
            {
               _loc4_ = lockedColumnAndRowContent;
            }
            else
            {
               _loc4_ = lockedColumnContent;
            }
         }
         else
         {
            _loc4_ = null;
         }
         if(!_loc3_[param2])
         {
            _loc3_[param2] = [];
         }
         if(_loc4_)
         {
            if(!_loc4_.listItems[param2])
            {
               _loc4_.listItems[param2] = [];
            }
         }
      }
      
      [Bindable("showHeadersChanged")]
      public function get showHeaders() : Boolean
      {
         return _showHeaders;
      }
      
      protected function adjustRow(param1:ListBaseContentHolder, param2:int, param3:Number, param4:Number) : void
      {
         var _loc6_:ListBaseContentHolder = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:IListItemRenderer = null;
         var _loc5_:Array = param1.listItems;
         if(lockedColumnCount > 0)
         {
            if(param1 == lockedRowContent)
            {
               _loc6_ = lockedColumnAndRowContent;
            }
            else
            {
               _loc6_ = lockedColumnContent;
            }
         }
         else
         {
            _loc6_ = null;
         }
         if(_loc5_[param2])
         {
            if(_loc6_)
            {
               _loc9_ = _loc6_.listItems[param2].length;
               _loc8_ = 0;
               while(_loc8_ < _loc9_)
               {
                  _loc6_.listItems[param2][_loc8_].setActualSize(_loc6_.listItems[param2][_loc8_].width,param4 - cachedPaddingTop - cachedPaddingBottom);
                  _loc8_++;
               }
            }
            _loc9_ = _loc5_[param2].length;
            _loc8_ = 0;
            while(_loc8_ < _loc9_)
            {
               _loc5_[param2][_loc8_].setActualSize(_loc5_[param2][_loc8_].width,param4 - cachedPaddingTop - cachedPaddingBottom);
               _loc8_++;
            }
         }
         if(cachedVerticalAlign != "top")
         {
            if(cachedVerticalAlign == "bottom")
            {
               _loc10_ = _loc5_[param2].length;
               _loc8_ = 0;
               while(_loc8_ < _loc10_)
               {
                  _loc11_ = _loc5_[param2][_loc8_];
                  _loc11_.move(_loc11_.x,param3 + param4 - cachedPaddingBottom - _loc11_.getExplicitOrMeasuredHeight());
                  _loc8_++;
               }
               if(_loc6_)
               {
                  _loc9_ = _loc6_.listItems[param2].length;
                  _loc8_ = 0;
                  while(_loc8_ < _loc9_)
                  {
                     _loc11_ = _loc6_.listItems[param2][_loc8_];
                     _loc11_.move(_loc11_.x,param3 + param4 - cachedPaddingBottom - _loc11_.getExplicitOrMeasuredHeight());
                     _loc8_++;
                  }
               }
            }
            else
            {
               _loc10_ = _loc5_[param2].length;
               _loc8_ = 0;
               while(_loc8_ < _loc10_)
               {
                  _loc11_ = _loc5_[param2][_loc8_];
                  _loc11_.move(_loc11_.x,param3 + cachedPaddingTop + (param4 - cachedPaddingBottom - cachedPaddingTop - _loc11_.getExplicitOrMeasuredHeight()) / 2);
                  _loc8_++;
               }
               if(_loc6_)
               {
                  _loc9_ = _loc6_.listItems[param2].length;
                  _loc8_ = 0;
                  while(_loc8_ < _loc9_)
                  {
                     _loc11_ = _loc6_.listItems[param2][_loc8_];
                     _loc11_.move(_loc11_.x,param3 + cachedPaddingTop + (param4 - cachedPaddingBottom - cachedPaddingTop - _loc11_.getExplicitOrMeasuredHeight()) / 2);
                     _loc8_++;
                  }
               }
            }
         }
      }
      
      override protected function restoreRowArrays(param1:int) : void
      {
         super.restoreRowArrays(param1);
         if(lockedColumnCount)
         {
            lockedColumnContent.listItems.splice(0,param1);
            lockedColumnContent.rowInfo.splice(0,param1);
         }
      }
      
      protected function setupColumnItemRenderer(param1:DataGridColumn, param2:ListBaseContentHolder, param3:int, param4:int, param5:Object, param6:String) : IListItemRenderer
      {
         var _loc8_:IListItemRenderer = null;
         var _loc9_:DataGridListData = null;
         var _loc7_:Array = param2.listItems;
         _loc8_ = _loc7_[param3][param4];
         if(!_loc8_ || itemToUID(_loc8_.data) != param6 || columnMap[_loc8_.name] != param1)
         {
            _loc8_ = createColumnItemRenderer(param1,false,param5);
            if(_loc8_ == null)
            {
               return null;
            }
            if(_loc8_.parent != param2)
            {
               param2.addChild(DisplayObject(_loc8_));
            }
            columnMap[_loc8_.name] = param1;
            if(_loc7_[param3][param4])
            {
               addToFreeItemRenderers(_loc7_[param3][param4]);
            }
            _loc7_[param3][param4] = _loc8_;
         }
         _loc9_ = DataGridListData(makeListData(param5,param6,param3,param1.colNum,param1));
         rowMap[_loc8_.name] = _loc9_;
         if(_loc8_ is IDropInListItemRenderer)
         {
            IDropInListItemRenderer(_loc8_).listData = !!param5?_loc9_:null;
         }
         _loc8_.data = param5;
         _loc8_.visible = true;
         if(param6 && param4 == 0)
         {
            param2.visibleData[param6] = _loc8_;
         }
         return _loc8_;
      }
      
      override protected function adjustAfterAdd(param1:Array, param2:int) : Boolean
      {
         var items:Array = param1;
         var location:int = param2;
         var retval:Boolean = super.adjustAfterAdd(items,location);
         if(lockedRowCount)
         {
            if(verticalScrollPosition > 0 && verticalScrollPosition >= location && location <= lockedRowCount)
            {
               if(verticalScrollPosition + lockedRowCount >= collection.length)
               {
                  super.verticalScrollPosition = verticalScrollPosition - items.length;
               }
            }
            if(collection.length - items.length <= lockedRowCount && collection.length >= lockedRowCount || location <= lockedRowCount || location == lockedRowCount + verticalScrollPosition)
            {
               try
               {
                  iterator.seek(CursorBookmark.FIRST,lockedRowCount + verticalScrollPosition);
                  if(!iteratorValid)
                  {
                     iteratorValid = true;
                     lastSeekPending = null;
                  }
               }
               catch(e:ItemPendingError)
               {
                  lastSeekPending = new ListBaseSeekPending(CursorBookmark.FIRST,lockedRowCount + verticalScrollPosition);
                  e.addResponder(new ItemResponder(seekPendingResultHandler,seekPendingFailureHandler,lastSeekPending));
                  iteratorValid = false;
               }
            }
         }
         return retval;
      }
      
      protected function calculateRowHeight(param1:Object, param2:Number, param3:Boolean = false) : Number
      {
         return NaN;
      }
      
      public function set columns(param1:Array) : void
      {
      }
      
      public function get columns() : Array
      {
         return null;
      }
      
      public function set lockedColumnCount(param1:int) : void
      {
         _lockedColumnCount = param1;
         lockedColumnCountChanged = true;
         itemsSizeChanged = true;
         columnsInvalid = true;
         invalidateDisplayList();
      }
      
      mx_internal function get dataGridLockedColumnHeader() : mx.controls.dataGridClasses.DataGridHeaderBase
      {
         return lockedColumnHeader;
      }
      
      protected function makeRows(param1:ListBaseContentHolder, param2:Number, param3:Number, param4:Number, param5:Number, param6:int, param7:int, param8:Boolean = false, param9:uint = 0, param10:Boolean = false) : Point
      {
         var xx:Number = NaN;
         var yy:Number = NaN;
         var hh:Number = NaN;
         var i:int = 0;
         var j:int = 0;
         var n:int = 0;
         var item:IListItemRenderer = null;
         var data:Object = null;
         var uid:String = null;
         var contentHolder:ListBaseContentHolder = param1;
         var left:Number = param2;
         var top:Number = param3;
         var right:Number = param4;
         var bottom:Number = param5;
         var firstCol:int = param6;
         var firstRow:int = param7;
         var byCount:Boolean = param8;
         var rowsNeeded:uint = param9;
         var alwaysCleanup:Boolean = param10;
         var bSelected:Boolean = false;
         var bHighlight:Boolean = false;
         var bCaret:Boolean = false;
         var colNum:int = 0;
         var rowNum:int = 0;
         var rowsMade:int = 0;
         var listItems:Array = contentHolder.listItems;
         var iterator:IViewCursor = contentHolder.iterator;
         var visibleData:Object = contentHolder.visibleData;
         var rowInfo:Object = contentHolder.rowInfo;
         if((!visibleColumns || visibleColumns.length == 0) && lockedColumnCount == 0)
         {
            while(listItems.length)
            {
               rowNum = listItems.length - 1;
               while(listItems[rowNum].length)
               {
                  item = listItems[rowNum].pop();
                  addToFreeItemRenderers(item);
               }
               listItems.pop();
            }
            contentHolder.visibleData = {};
            return new Point(0,0);
         }
         invalidateSizeFlag = true;
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
            data = !!more?iterator.current:null;
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
               }
            }
            hh = 0;
            uid = null;
            prepareRowArray(contentHolder,rowNum);
            if(valid)
            {
               uid = itemToUID(data);
               hh = makeRow(contentHolder,rowNum,left,right,yy,data,uid);
            }
            else
            {
               hh = rowNum > 1?Number(rowInfo[rowNum - 1].height):Number(rowHeight);
            }
            if(valid && variableRowHeight)
            {
               hh = Math.ceil(calculateRowHeight(data,hh,true));
            }
            if(valid)
            {
               adjustRow(contentHolder,rowNum,yy,hh);
            }
            else
            {
               clearRow(contentHolder,rowNum);
            }
            bSelected = selectedData[uid] != null;
            bHighlight = highlightUID == uid;
            bCaret = caretUID == uid;
            setRowInfo(contentHolder,rowNum,yy,hh,uid);
            if(valid)
            {
               drawVisibleItem(uid,bSelected,bHighlight,bCaret);
            }
            if(hh == 0)
            {
               hh = rowHeight;
            }
            yy = yy + hh;
            rowNum++;
            rowsMade++;
         }
         if(!byCount || alwaysCleanup)
         {
            while(rowNum < listItems.length)
            {
               removeExtraRow(contentHolder);
            }
         }
         invalidateSizeFlag = false;
         return new Point(colNum,rowsMade);
      }
      
      override protected function clearHighlightIndicator(param1:Sprite, param2:IListItemRenderer) : void
      {
         super.clearHighlightIndicator(param1,param2);
         if(lockedColumnCount)
         {
            if(columnHighlightIndicator)
            {
               Sprite(columnHighlightIndicator).graphics.clear();
            }
         }
      }
      
      mx_internal function columnWordWrap(param1:DataGridColumn) : Boolean
      {
         if(param1.wordWrap == true)
         {
            return true;
         }
         if(param1.wordWrap == false)
         {
            return false;
         }
         return wordWrap;
      }
      
      protected function setRowInfo(param1:ListBaseContentHolder, param2:int, param3:Number, param4:Number, param5:String) : void
      {
         var _loc8_:ListBaseContentHolder = null;
         var _loc6_:Array = param1.listItems;
         var _loc7_:Object = param1.rowInfo;
         if(lockedColumnCount > 0)
         {
            if(param1 == lockedRowContent)
            {
               _loc8_ = lockedColumnAndRowContent;
            }
            else
            {
               _loc8_ = lockedColumnContent;
            }
         }
         else
         {
            _loc8_ = null;
         }
         _loc7_[param2] = new ListRowInfo(param3,param4,param5);
         if(_loc8_)
         {
            _loc8_.rowInfo[param2] = _loc7_[param2];
         }
      }
      
      override protected function truncateRowArrays(param1:int) : void
      {
         super.truncateRowArrays(param1);
         if(lockedColumnCount)
         {
            lockedColumnContent.listItems.splice(param1);
            lockedColumnContent.rowInfo.splice(param1);
         }
      }
      
      public function get lockedColumnCount() : int
      {
         return _lockedColumnCount;
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         if(header)
         {
            header.visibleColumns = visibleColumns;
            header.headerItemsChanged = true;
            header.invalidateSize();
            header.validateNow();
         }
         if(lockedColumnCountChanged)
         {
            lockedColumnCountChanged = false;
            if(lockedColumnCount > 0)
            {
               if(!lockedColumnContent)
               {
                  lockedColumnHeader = new headerClass();
                  lockedColumnHeader.styleName = this;
                  addChild(lockedColumnHeader);
                  lockedColumnAndRowContent = new mx.controls.dataGridClasses.DataGridLockedRowContentHolder(this);
                  lockedColumnAndRowContent.styleName = this;
                  addChild(lockedColumnAndRowContent);
                  lockedColumnContent = new ListBaseContentHolder(this);
                  lockedColumnContent.styleName = this;
                  addChild(lockedColumnContent);
               }
               lockedColumnHeader.visible = true;
               lockedColumnAndRowContent.visible = lockedRowCount > 0;
               lockedColumnContent.visible = true;
            }
            else if(lockedColumnContent)
            {
               lockedColumnHeader.visible = false;
               lockedColumnAndRowContent.visible = false;
               lockedColumnContent.visible = false;
            }
         }
         if(lockedRowCountChanged && iterator)
         {
            lockedRowCountChanged = false;
            if(lockedRowCount > 0)
            {
               if(!lockedRowContent)
               {
                  lockedRowContent = new mx.controls.dataGridClasses.DataGridLockedRowContentHolder(this);
                  lockedRowContent.styleName = this;
                  addChild(lockedRowContent);
               }
               lockedRowContent.visible = true;
            }
            else if(lockedRowContent)
            {
               lockedRowContent.visible = false;
            }
            if(lockedColumnAndRowContent)
            {
               lockedColumnAndRowContent.visible = lockedRowCount > 0 && lockedColumnCount > 0;
            }
            seekPositionSafely(lockedRowCount + verticalScrollPosition);
         }
         if(lockedRowContent && lockedColumnAndRowContent)
         {
            _loc4_ = getChildIndex(lockedColumnAndRowContent);
            _loc3_ = getChildIndex(lockedRowContent);
            if(_loc4_ < _loc3_)
            {
               setChildIndex(lockedRowContent,_loc4_);
            }
         }
         if(lockedColumnContent && lockedColumnAndRowContent)
         {
            _loc4_ = getChildIndex(lockedColumnAndRowContent);
            _loc3_ = getChildIndex(lockedColumnContent);
            if(_loc4_ < _loc3_)
            {
               setChildIndex(lockedColumnContent,_loc4_);
            }
         }
         if(headerVisible && lockedColumnHeader)
         {
            lockedColumnHeader.visibleColumns = visibleLockedColumns;
            lockedColumnHeader.headerItemsChanged = true;
            lockedColumnHeader.invalidateSize();
            lockedColumnHeader.validateNow();
         }
         super.updateDisplayList(param1,param2);
      }
      
      public function set lockedRowCount(param1:int) : void
      {
         _lockedRowCount = param1;
         lockedRowCountChanged = true;
         itemsSizeChanged = true;
         invalidateDisplayList();
      }
   }
}
