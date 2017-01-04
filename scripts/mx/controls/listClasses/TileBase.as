package mx.controls.listClasses
{
   import flash.display.DisplayObject;
   import flash.display.Graphics;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.geom.Point;
   import flash.ui.Keyboard;
   import flash.utils.Dictionary;
   import flash.utils.setInterval;
   import mx.collections.CursorBookmark;
   import mx.collections.ItemResponder;
   import mx.collections.ItemWrapper;
   import mx.collections.ModifiedCollectionView;
   import mx.collections.errors.ItemPendingError;
   import mx.controls.scrollClasses.ScrollBar;
   import mx.core.ClassFactory;
   import mx.core.EdgeMetrics;
   import mx.core.FlexShape;
   import mx.core.FlexSprite;
   import mx.core.IFactory;
   import mx.core.IFlexDisplayObject;
   import mx.core.UIComponentGlobals;
   import mx.core.mx_internal;
   import mx.events.CollectionEvent;
   import mx.events.CollectionEventKind;
   import mx.events.DragEvent;
   import mx.events.ListEvent;
   import mx.events.ScrollEvent;
   import mx.events.ScrollEventDetail;
   import mx.events.ScrollEventDirection;
   import mx.skins.halo.ListDropIndicator;
   import mx.styles.StyleManager;
   
   use namespace mx_internal;
   
   public class TileBase extends ListBase
   {
      
      mx_internal static const VERSION:String = "3.6.0.21751";
       
      
      private var _direction:String = "horizontal";
      
      private var lastRowCount:int = 0;
      
      private var _maxRows:int = 0;
      
      private var bSelectItem:Boolean = false;
      
      private var bCtrlKey:Boolean = false;
      
      private var lastColumnCount:int = 0;
      
      private var lastKey:uint = 0;
      
      private var _maxColumns:int = 0;
      
      protected var measuringObjects:Dictionary;
      
      private var bShiftKey:Boolean = false;
      
      public function TileBase()
      {
         super();
         itemRenderer = new ClassFactory(TileListItemRenderer);
         setRowHeight(50);
         setColumnWidth(50);
      }
      
      override public function measureWidthOfItems(param1:int = -1, param2:int = 0) : Number
      {
         var _loc3_:IListItemRenderer = null;
         var _loc4_:Number = NaN;
         var _loc5_:ListData = null;
         var _loc7_:Object = null;
         var _loc8_:Object = null;
         var _loc9_:IFactory = null;
         var _loc6_:Boolean = false;
         if(collection && collection.length)
         {
            _loc7_ = iterator.current;
            _loc8_ = _loc7_ is ItemWrapper?_loc7_.data:_loc7_;
            if(!measuringObjects)
            {
               measuringObjects = new Dictionary(true);
            }
            _loc9_ = getItemRendererFactory(_loc8_);
            _loc3_ = measuringObjects[_loc9_];
            if(!_loc3_)
            {
               _loc3_ = getMeasuringRenderer(_loc8_);
               _loc6_ = true;
            }
            _loc5_ = ListData(makeListData(_loc8_,uid,0,0));
            if(_loc3_ is IDropInListItemRenderer)
            {
               IDropInListItemRenderer(_loc3_).listData = !!_loc8_?_loc5_:null;
            }
            _loc3_.data = _loc8_;
            UIComponentGlobals.layoutManager.validateClient(_loc3_,true);
            _loc4_ = _loc3_.getExplicitOrMeasuredWidth();
            if(_loc6_)
            {
               _loc3_.setActualSize(_loc4_,_loc3_.getExplicitOrMeasuredHeight());
               _loc6_ = false;
            }
         }
         if(isNaN(_loc4_) || _loc4_ == 0)
         {
            _loc4_ = 50;
         }
         return _loc4_ * param2;
      }
      
      override public function indexToItemRenderer(param1:int) : IListItemRenderer
      {
         var _loc2_:int = indexToRow(param1);
         if(_loc2_ < verticalScrollPosition || _loc2_ >= verticalScrollPosition + rowCount)
         {
            return null;
         }
         var _loc3_:int = indexToColumn(param1);
         if(_loc3_ < horizontalScrollPosition || _loc3_ >= horizontalScrollPosition + columnCount)
         {
            return null;
         }
         return listItems[_loc2_ - verticalScrollPosition][_loc3_ - horizontalScrollPosition];
      }
      
      public function set direction(param1:String) : void
      {
         _direction = param1;
         itemsSizeChanged = true;
         offscreenExtraRowsOrColumnsChanged = true;
         if(listContent)
         {
            if(direction == TileBaseDirection.HORIZONTAL)
            {
               listContent.leftOffset = listContent.rightOffset = 0;
               offscreenExtraColumnsLeft = offscreenExtraColumnsRight = 0;
            }
            else
            {
               listContent.topOffset = listContent.bottomOffset = 0;
               offscreenExtraRowsTop = offscreenExtraRowsBottom = 0;
            }
         }
         invalidateProperties();
         invalidateSize();
         invalidateDisplayList();
         dispatchEvent(new Event("directionChanged"));
      }
      
      [Bindable("directionChanged")]
      public function get direction() : String
      {
         return _direction;
      }
      
      override mx_internal function reconstructDataFromListItems() : Array
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:IListItemRenderer = null;
         var _loc5_:Object = null;
         if(direction == TileBaseDirection.HORIZONTAL || !listItems)
         {
            return super.reconstructDataFromListItems();
         }
         var _loc1_:Array = [];
         if(listItems.length > 0)
         {
            _loc2_ = 0;
            while(_loc2_ < listItems[0].length)
            {
               _loc3_ = 0;
               while(_loc3_ < listItems.length)
               {
                  if(listItems[_loc3_] && listItems[_loc3_].length > _loc2_)
                  {
                     _loc4_ = listItems[_loc3_][_loc2_] as IListItemRenderer;
                     if(_loc4_)
                     {
                        _loc5_ = _loc4_.data;
                        _loc1_.push(_loc5_);
                     }
                  }
                  _loc3_++;
               }
               _loc2_++;
            }
         }
         return _loc1_;
      }
      
      override protected function moveSelectionHorizontally(param1:uint, param2:Boolean, param3:Boolean) : void
      {
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:IListItemRenderer = null;
         var _loc7_:String = null;
         var _loc8_:int = 0;
         var _loc9_:Boolean = false;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc16_:ScrollEvent = null;
         var _loc12_:int = listItems[0].length - offscreenExtraColumnsLeft - offscreenExtraColumnsRight;
         var _loc13_:int = maxColumns > 0 && direction != TileBaseDirection.VERTICAL?int(maxColumns):int(_loc12_);
         var _loc14_:int = !!displayingPartialRow()?1:0;
         var _loc15_:int = !!displayingPartialColumn()?1:0;
         if(!collection)
         {
            return;
         }
         showCaret = true;
         switch(param1)
         {
            case Keyboard.LEFT:
               if(caretIndex > 0)
               {
                  if(direction == TileBaseDirection.HORIZONTAL)
                  {
                     caretIndex--;
                  }
                  else
                  {
                     _loc10_ = indexToRow(caretIndex);
                     _loc11_ = indexToColumn(caretIndex);
                     if(_loc11_ == 0)
                     {
                        _loc10_--;
                        _loc11_ = lastColumnInRow(_loc10_);
                     }
                     else
                     {
                        _loc11_--;
                     }
                     caretIndex = Math.min(indicesToIndex(_loc10_,_loc11_),collection.length - 1);
                  }
                  _loc10_ = indexToRow(caretIndex);
                  _loc11_ = indexToColumn(caretIndex);
                  if(direction == TileBaseDirection.HORIZONTAL)
                  {
                     if(_loc10_ < verticalScrollPosition)
                     {
                        _loc4_ = verticalScrollPosition - 1;
                     }
                     else if(_loc10_ > verticalScrollPosition + rowCount - _loc14_)
                     {
                        _loc4_ = maxVerticalScrollPosition;
                     }
                  }
                  else if(_loc11_ < horizontalScrollPosition)
                  {
                     _loc5_ = horizontalScrollPosition - 1;
                  }
                  else if(_loc11_ > horizontalScrollPosition + _loc12_ - 1 - _loc15_)
                  {
                     _loc5_ = maxHorizontalScrollPosition;
                  }
               }
               break;
            case Keyboard.RIGHT:
               if(caretIndex < collection.length - 1)
               {
                  if(direction == TileBaseDirection.HORIZONTAL || caretIndex == -1)
                  {
                     caretIndex++;
                  }
                  else
                  {
                     _loc10_ = indexToRow(caretIndex);
                     _loc11_ = indexToColumn(caretIndex);
                     if(_loc11_ == lastColumnInRow(_loc10_))
                     {
                        _loc11_ = 0;
                        _loc10_++;
                     }
                     else
                     {
                        _loc11_++;
                     }
                     caretIndex = Math.min(indicesToIndex(_loc10_,_loc11_),collection.length - 1);
                  }
                  _loc10_ = indexToRow(caretIndex);
                  _loc11_ = indexToColumn(caretIndex);
                  if(direction == TileBaseDirection.HORIZONTAL)
                  {
                     if(_loc10_ >= verticalScrollPosition + rowCount - _loc14_ && verticalScrollPosition < maxVerticalScrollPosition)
                     {
                        _loc4_ = verticalScrollPosition + 1;
                     }
                     if(_loc10_ < verticalScrollPosition)
                     {
                        _loc4_ = _loc10_;
                     }
                  }
                  else
                  {
                     if(_loc11_ >= horizontalScrollPosition + _loc12_ - _loc15_ && horizontalScrollPosition < maxHorizontalScrollPosition)
                     {
                        _loc5_ = horizontalScrollPosition + 1;
                     }
                     if(_loc11_ < horizontalScrollPosition)
                     {
                        _loc5_ = _loc11_;
                     }
                  }
               }
               break;
            case Keyboard.PAGE_UP:
               if(caretIndex < 0)
               {
                  caretIndex = scrollPositionToIndex(horizontalScrollPosition,verticalScrollPosition);
               }
               _loc10_ = indexToRow(caretIndex);
               _loc11_ = indexToColumn(caretIndex);
               if(_loc11_ > 0)
               {
                  _loc5_ = _loc11_ = Math.max(horizontalScrollPosition - (_loc12_ - _loc15_),0);
                  caretIndex = indicesToIndex(_loc10_,_loc11_);
               }
               break;
            case Keyboard.PAGE_DOWN:
               if(caretIndex < 0)
               {
                  caretIndex = scrollPositionToIndex(horizontalScrollPosition,verticalScrollPosition);
               }
               _loc10_ = indexToRow(caretIndex);
               _loc11_ = indexToColumn(caretIndex);
               if(_loc11_ < maxHorizontalScrollPosition)
               {
                  _loc11_ = Math.min(horizontalScrollPosition + _loc12_ - _loc15_,indexToColumn(collection.length - 1));
                  if(_loc11_ > horizontalScrollPosition)
                  {
                     _loc5_ = Math.min(_loc11_,maxHorizontalScrollPosition);
                  }
                  caretIndex = indicesToIndex(_loc10_,_loc11_);
               }
               break;
            case Keyboard.HOME:
               if(collection.length)
               {
                  caretIndex = 0;
                  _loc5_ = 0;
                  _loc4_ = 0;
               }
               break;
            case Keyboard.END:
               if(caretIndex < collection.length)
               {
                  caretIndex = collection.length - 1;
                  _loc5_ = maxHorizontalScrollPosition;
                  _loc4_ = maxVerticalScrollPosition;
               }
         }
         if(!isNaN(_loc4_))
         {
            if(_loc4_ != verticalScrollPosition)
            {
               _loc16_ = new ScrollEvent(ScrollEvent.SCROLL);
               _loc16_.detail = ScrollEventDetail.THUMB_POSITION;
               _loc16_.direction = ScrollEventDirection.VERTICAL;
               _loc16_.delta = _loc4_ - verticalScrollPosition;
               _loc16_.position = _loc4_;
               verticalScrollPosition = _loc4_;
               dispatchEvent(_loc16_);
            }
         }
         if(iteratorValid)
         {
            if(!isNaN(_loc5_))
            {
               if(_loc5_ != horizontalScrollPosition)
               {
                  _loc16_ = new ScrollEvent(ScrollEvent.SCROLL);
                  _loc16_.detail = ScrollEventDetail.THUMB_POSITION;
                  _loc16_.direction = ScrollEventDirection.HORIZONTAL;
                  _loc16_.delta = _loc5_ - horizontalScrollPosition;
                  _loc16_.position = _loc5_;
                  horizontalScrollPosition = _loc5_;
                  dispatchEvent(_loc16_);
               }
            }
         }
         if(!iteratorValid)
         {
            keySelectionPending = true;
            return;
         }
         bShiftKey = param2;
         bCtrlKey = param3;
         lastKey = param1;
         finishKeySelection();
      }
      
      override mx_internal function removeClipMask() : void
      {
      }
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
         if(itemsNeedMeasurement)
         {
            itemsNeedMeasurement = false;
            if(isNaN(explicitRowHeight))
            {
               setRowHeight(measureHeightOfItems(0,1));
            }
            if(isNaN(explicitColumnWidth))
            {
               setColumnWidth(measureWidthOfItems(0,1));
            }
         }
      }
      
      override public function scrollToIndex(param1:int) : Boolean
      {
         var newVPos:int = 0;
         var newHPos:int = 0;
         var index:int = param1;
         var firstIndex:int = scrollPositionToIndex(horizontalScrollPosition,verticalScrollPosition);
         var numItemsVisible:int = (listItems.length - offscreenExtraRowsTop - offscreenExtraRowsBottom) * (listItems[0].length - offscreenExtraColumnsLeft - offscreenExtraColumnsRight);
         if(index >= firstIndex + numItemsVisible || index < firstIndex)
         {
            newVPos = Math.min(indexToRow(index),maxVerticalScrollPosition);
            newHPos = Math.min(indexToColumn(index),maxHorizontalScrollPosition);
            try
            {
               iterator.seek(CursorBookmark.FIRST,scrollPositionToIndex(horizontalScrollPosition,verticalScrollPosition));
               super.horizontalScrollPosition = newHPos;
               super.verticalScrollPosition = newVPos;
            }
            catch(e:ItemPendingError)
            {
            }
            return true;
         }
         return false;
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
            if(!param1)
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
            if(freeItemRenderers && freeItemRenderers.length && freeItemRenderersByFactory[_loc2_])
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
      
      protected function drawTileBackgrounds() : void
      {
         var _loc2_:Array = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:IListItemRenderer = null;
         var _loc10_:int = 0;
         var _loc11_:DisplayObject = null;
         var _loc1_:Sprite = Sprite(listContent.getChildByName("tileBGs"));
         if(!_loc1_)
         {
            _loc1_ = new FlexSprite();
            _loc1_.mouseEnabled = false;
            _loc1_.name = "tileBGs";
            listContent.addChildAt(_loc1_,0);
         }
         _loc2_ = getStyle("alternatingItemColors");
         if(!_loc2_ || _loc2_.length == 0)
         {
            while(_loc1_.numChildren > _loc5_)
            {
               _loc1_.removeChildAt(_loc1_.numChildren - 1);
            }
            return;
         }
         StyleManager.getColorNames(_loc2_);
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         while(_loc4_ < rowCount)
         {
            _loc6_ = 0;
            while(_loc6_ < columnCount)
            {
               _loc7_ = _loc4_ < rowCount - 1?Number(rowHeight):Number(Math.min(rowHeight,listContent.height - (rowCount - 1) * rowHeight));
               _loc8_ = _loc6_ < columnCount - 1?Number(columnWidth):Number(Math.min(columnWidth,listContent.width - (columnCount - 1) * columnWidth));
               _loc9_ = !!listItems[_loc4_]?listItems[_loc4_][_loc6_]:null;
               _loc10_ = (verticalScrollPosition + _loc4_) * columnCount + (horizontalScrollPosition + _loc6_);
               _loc11_ = drawTileBackground(_loc1_,_loc4_,_loc6_,_loc8_,_loc7_,_loc2_[_loc10_ % _loc2_.length],_loc9_);
               _loc11_.y = _loc4_ * rowHeight;
               _loc11_.x = _loc6_ * columnWidth;
               _loc6_++;
            }
            _loc4_++;
         }
         _loc5_ = rowCount * columnCount;
         while(_loc1_.numChildren > _loc5_)
         {
            _loc1_.removeChildAt(_loc1_.numChildren - 1);
         }
      }
      
      private function displayingPartialRow() : Boolean
      {
         var _loc2_:IListItemRenderer = null;
         var _loc1_:Array = listItems[listItems.length - 1 - offscreenExtraRowsBottom];
         if(_loc1_ && _loc1_.length > 0)
         {
            _loc2_ = _loc1_[0];
            if(!_loc2_ || _loc2_.y + _loc2_.height > listContent.heightExcludingOffsets - listContent.topOffset)
            {
               return true;
            }
         }
         return false;
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         listContent.mask = maskShape;
      }
      
      override mx_internal function addClipMask(param1:Boolean) : void
      {
      }
      
      override protected function finishKeySelection() : void
      {
         var _loc1_:String = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:IListItemRenderer = null;
         var _loc6_:ListEvent = null;
         var _loc2_:Boolean = false;
         if(caretIndex < 0)
         {
            return;
         }
         _loc3_ = indexToRow(caretIndex);
         _loc4_ = indexToColumn(caretIndex);
         _loc5_ = listItems[_loc3_ - verticalScrollPosition + offscreenExtraRowsTop][_loc4_ - horizontalScrollPosition + offscreenExtraColumnsLeft];
         if(!bCtrlKey)
         {
            selectItem(_loc5_,bShiftKey,bCtrlKey);
            _loc2_ = true;
         }
         if(bCtrlKey)
         {
            _loc1_ = itemToUID(_loc5_.data);
            drawItem(visibleData[_loc1_],selectedData[_loc1_] != null,false,true);
         }
         if(_loc2_)
         {
            _loc6_ = new ListEvent(ListEvent.CHANGE);
            _loc6_.itemRenderer = _loc5_;
            _loc6_.rowIndex = _loc3_;
            _loc6_.columnIndex = _loc4_;
            dispatchEvent(_loc6_);
         }
      }
      
      override protected function scrollPositionToIndex(param1:int, param2:int) : int
      {
         var _loc3_:int = 0;
         if(iterator)
         {
            if(direction == TileBaseDirection.HORIZONTAL)
            {
               _loc3_ = param2 * columnCount + param1;
            }
            else
            {
               _loc3_ = param1 * rowCount + param2;
            }
            return _loc3_;
         }
         return -1;
      }
      
      override protected function keyDownHandler(param1:KeyboardEvent) : void
      {
         var _loc2_:IListItemRenderer = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         if(!iteratorValid)
         {
            return;
         }
         if(!collection)
         {
            return;
         }
         switch(param1.keyCode)
         {
            case Keyboard.UP:
            case Keyboard.DOWN:
               moveSelectionVertically(param1.keyCode,param1.shiftKey,param1.ctrlKey);
               param1.stopPropagation();
               break;
            case Keyboard.LEFT:
            case Keyboard.RIGHT:
               moveSelectionHorizontally(param1.keyCode,param1.shiftKey,param1.ctrlKey);
               param1.stopPropagation();
               break;
            case Keyboard.END:
            case Keyboard.HOME:
            case Keyboard.PAGE_UP:
            case Keyboard.PAGE_DOWN:
               if(direction == TileBaseDirection.VERTICAL)
               {
                  moveSelectionHorizontally(param1.keyCode,param1.shiftKey,param1.ctrlKey);
               }
               else
               {
                  moveSelectionVertically(param1.keyCode,param1.shiftKey,param1.ctrlKey);
               }
               param1.stopPropagation();
               break;
            case Keyboard.SPACE:
               if(caretIndex < 0)
               {
                  break;
               }
               _loc3_ = indexToRow(caretIndex);
               _loc4_ = indexToColumn(caretIndex);
               _loc2_ = listItems[_loc3_ - verticalScrollPosition][_loc4_ - horizontalScrollPosition];
               selectItem(_loc2_,param1.shiftKey,param1.ctrlKey);
               break;
            default:
               if(findKey(param1.keyCode))
               {
                  param1.stopPropagation();
               }
         }
      }
      
      override protected function indexToColumn(param1:int) : int
      {
         var _loc3_:int = 0;
         if(direction == TileBaseDirection.VERTICAL)
         {
            _loc3_ = maxRows > 0?int(maxRows):int(rowCount);
            return Math.floor(param1 / _loc3_);
         }
         var _loc2_:int = maxColumns > 0?int(maxColumns):int(columnCount);
         return param1 % _loc2_;
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         if(explicitColumnCount > 0 && isNaN(explicitColumnWidth))
         {
            setColumnWidth(Math.floor((width - viewMetrics.left - viewMetrics.right) / explicitColumnCount));
         }
         if(explicitRowCount > 0 && isNaN(explicitRowHeight))
         {
            setRowHeight(Math.floor((height - viewMetrics.top - viewMetrics.bottom) / explicitRowCount));
         }
         super.updateDisplayList(param1,param2);
         drawTileBackgrounds();
      }
      
      override protected function scrollHorizontally(param1:int, param2:int, param3:Boolean) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Number = NaN;
         var _loc7_:String = null;
         var _loc8_:int = 0;
         var _loc9_:Number = NaN;
         var _loc14_:int = 0;
         var _loc15_:int = 0;
         var _loc16_:int = 0;
         var _loc20_:int = 0;
         var _loc21_:int = 0;
         var _loc22_:IListItemRenderer = null;
         var _loc23_:int = 0;
         var _loc24_:int = 0;
         var _loc25_:Point = null;
         var _loc26_:int = 0;
         var _loc27_:IListItemRenderer = null;
         var _loc28_:int = 0;
         var _loc29_:int = 0;
         if(param2 == 0)
         {
            return;
         }
         removeClipMask();
         var _loc10_:int = offscreenExtraColumnsRight;
         var _loc11_:int = offscreenExtraColumnsLeft;
         var _loc12_:int = offscreenExtraColumns / 2;
         var _loc13_:int = offscreenExtraColumns / 2;
         if(param3)
         {
            offscreenExtraColumnsLeft = Math.min(_loc12_,offscreenExtraColumnsLeft + param2);
            _loc14_ = param2 - (offscreenExtraColumnsLeft - _loc11_);
            _loc15_ = _loc14_;
         }
         else
         {
            _loc20_ = offscreenExtraColumnsRight == 0 && listItems[0] && listItems[0].length > 0 && listItems[0][listItems[0].length - 1] && listItems[0][listItems[0].length - 1].x + columnWidth < listContent.widthExcludingOffsets - listContent.leftOffset?1:0;
            offscreenExtraColumnsLeft = Math.min(_loc12_,param1);
            offscreenExtraColumnsRight = Math.min(offscreenExtraColumnsRight + param2 - _loc20_,_loc13_);
            _loc14_ = param2 - (_loc11_ - offscreenExtraColumnsLeft);
            _loc16_ = offscreenExtraColumnsLeft - _loc11_ + _loc20_ + (offscreenExtraColumnsRight - _loc10_);
            _loc15_ = param2 - (offscreenExtraColumnsRight - _loc10_) - _loc20_;
         }
         var _loc17_:int = listItems[0].length;
         var _loc18_:int = 0;
         while(_loc18_ < _loc15_)
         {
            _loc21_ = 0;
            while(_loc21_ < rowCount)
            {
               _loc22_ = !!param3?listItems[_loc21_][_loc18_]:listItems[_loc21_][_loc17_ - _loc18_ - 1];
               if(_loc22_)
               {
                  delete visibleData[rowMap[_loc22_.name].uid];
                  removeIndicators(rowMap[_loc22_.name].uid);
                  addToFreeItemRenderers(_loc22_);
                  delete rowMap[_loc22_.name];
                  if(param3)
                  {
                     listItems[_loc21_][_loc18_] = null;
                  }
                  else
                  {
                     listItems[_loc21_][_loc17_ - _loc18_ - 1] = null;
                  }
               }
               _loc21_++;
            }
            _loc18_++;
         }
         if(param3)
         {
            _loc9_ = _loc14_ * columnWidth;
            _loc6_ = 0;
            _loc18_ = _loc14_;
            while(_loc18_ < _loc17_)
            {
               _loc21_ = 0;
               while(_loc21_ < rowCount)
               {
                  _loc27_ = listItems[_loc21_][_loc18_];
                  if(_loc27_)
                  {
                     _loc22_ = _loc27_;
                     _loc22_.x = _loc22_.x - _loc9_;
                     _loc7_ = rowMap[_loc22_.name].uid;
                     listItems[_loc21_][_loc18_ - _loc14_] = _loc22_;
                     rowMap[_loc22_.name].columnIndex = rowMap[_loc22_.name].columnIndex - _loc14_;
                     moveIndicatorsHorizontally(_loc7_,-_loc9_);
                  }
                  else
                  {
                     listItems[_loc21_][_loc18_ - _loc14_] = null;
                  }
                  _loc21_++;
               }
               _loc6_ = _loc6_ + columnWidth;
               _loc18_++;
            }
            _loc18_ = 0;
            while(_loc18_ < _loc14_)
            {
               _loc21_ = 0;
               while(_loc21_ < rowCount)
               {
                  listItems[_loc21_][_loc17_ - _loc18_ - 1] = null;
                  _loc21_++;
               }
               _loc18_++;
            }
            _loc8_ = indicesToIndex(verticalScrollPosition,horizontalScrollPosition + _loc17_ - offscreenExtraColumnsLeft - _loc14_);
            seekPositionSafely(_loc8_);
            _loc23_ = param2 + (_loc13_ - _loc10_);
            _loc24_ = !!listItems.length?int(listItems[0].length - _loc14_):0;
            allowRendererStealingDuringLayout = false;
            _loc25_ = makeRowsAndColumns(_loc6_,0,listContent.width,listContent.height,_loc17_ - _loc14_,0,true,_loc23_);
            allowRendererStealingDuringLayout = true;
            _loc26_ = listItems[0].length - (_loc24_ + _loc25_.x);
            if(_loc26_)
            {
               _loc18_ = 0;
               while(_loc18_ < listItems.length)
               {
                  _loc21_ = 0;
                  while(_loc21_ < _loc26_)
                  {
                     listItems[_loc18_].pop();
                     _loc21_++;
                  }
                  _loc18_++;
               }
            }
            _loc8_ = indicesToIndex(verticalScrollPosition,horizontalScrollPosition - offscreenExtraColumnsLeft);
            seekPositionSafely(_loc8_);
            offscreenExtraColumnsRight = Math.max(0,_loc13_ - (_loc25_.x < param2?_loc23_ - _loc25_.x:0));
         }
         else
         {
            if(_loc16_ < 0)
            {
               _loc29_ = listItems[0].length + _loc16_;
               _loc21_ = 0;
               while(_loc21_ < rowCount)
               {
                  while(listItems[_loc21_].length > _loc29_)
                  {
                     listItems[_loc21_].pop();
                  }
                  _loc21_++;
               }
            }
            _loc9_ = _loc14_ * columnWidth;
            if(_loc14_)
            {
               _loc6_ = _loc9_;
            }
            _loc28_ = _loc17_ + _loc16_;
            _loc18_ = _loc28_ - _loc14_ - 1;
            while(_loc18_ >= 0)
            {
               _loc21_ = 0;
               while(_loc21_ < rowCount)
               {
                  _loc22_ = listItems[_loc21_][_loc18_];
                  if(_loc22_)
                  {
                     _loc22_.x = _loc22_.x + _loc9_;
                     _loc7_ = rowMap[_loc22_.name].uid;
                     listItems[_loc21_][_loc18_ + _loc14_] = _loc22_;
                     rowMap[_loc22_.name].columnIndex = rowMap[_loc22_.name].columnIndex + _loc14_;
                     moveIndicatorsHorizontally(_loc7_,_loc9_);
                  }
                  else
                  {
                     listItems[_loc21_][_loc18_ + _loc14_] = null;
                  }
                  _loc21_++;
               }
               _loc18_--;
            }
            _loc18_ = 0;
            while(_loc18_ < _loc14_)
            {
               _loc21_ = 0;
               while(_loc21_ < rowCount)
               {
                  listItems[_loc21_][_loc18_] = null;
                  _loc21_++;
               }
               _loc18_++;
            }
            _loc8_ = indicesToIndex(verticalScrollPosition,horizontalScrollPosition - offscreenExtraColumnsLeft);
            seekPositionSafely(_loc8_);
            allowRendererStealingDuringLayout = false;
            makeRowsAndColumns(0,0,_loc6_,listContent.height,0,0,true,_loc14_);
            allowRendererStealingDuringLayout = true;
            seekPositionSafely(_loc8_);
         }
         var _loc19_:Number = listContent.widthExcludingOffsets;
         listContent.leftOffset = -columnWidth * offscreenExtraColumnsLeft;
         listContent.rightOffset = !!offscreenExtraColumnsRight?Number(listItems[0][listItems[0].length - 1].x + listItems[0][listItems[0].length - 1].width + listContent.leftOffset - _loc19_):Number(0);
         adjustListContent();
         addClipMask(false);
      }
      
      override mx_internal function adjustOffscreenRowsAndColumns() : void
      {
         if(direction == TileBaseDirection.VERTICAL)
         {
            offscreenExtraRows = 0;
            offscreenExtraColumns = offscreenExtraRowsOrColumns;
         }
         else
         {
            offscreenExtraColumns = 0;
            offscreenExtraRows = offscreenExtraRowsOrColumns;
         }
      }
      
      override protected function moveSelectionVertically(param1:uint, param2:Boolean, param3:Boolean) : void
      {
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:IListItemRenderer = null;
         var _loc7_:String = null;
         var _loc8_:int = 0;
         var _loc9_:Boolean = false;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc17_:ScrollEvent = null;
         var _loc10_:Boolean = false;
         var _loc13_:int = listItems.length - offscreenExtraRowsTop - offscreenExtraRowsBottom;
         var _loc14_:int = maxRows > 0 && direction != TileBaseDirection.HORIZONTAL?int(maxRows):int(_loc13_);
         var _loc15_:int = !!displayingPartialRow()?1:0;
         var _loc16_:int = !!displayingPartialColumn()?1:0;
         if(!collection)
         {
            return;
         }
         showCaret = true;
         switch(param1)
         {
            case Keyboard.UP:
               if(caretIndex > 0)
               {
                  if(direction == TileBaseDirection.VERTICAL)
                  {
                     caretIndex--;
                  }
                  else
                  {
                     _loc11_ = indexToRow(caretIndex);
                     _loc12_ = indexToColumn(caretIndex);
                     if(_loc11_ == 0)
                     {
                        _loc12_--;
                        _loc11_ = lastRowInColumn(_loc12_);
                     }
                     else
                     {
                        _loc11_--;
                     }
                     caretIndex = Math.min(indicesToIndex(_loc11_,_loc12_),collection.length - 1);
                  }
                  _loc11_ = indexToRow(caretIndex);
                  _loc12_ = indexToColumn(caretIndex);
                  if(_loc11_ < verticalScrollPosition)
                  {
                     _loc4_ = verticalScrollPosition - 1;
                  }
                  if(_loc11_ > verticalScrollPosition + _loc13_ - _loc15_)
                  {
                     _loc4_ = maxVerticalScrollPosition;
                  }
                  if(_loc12_ < horizontalScrollPosition)
                  {
                     _loc5_ = horizontalScrollPosition - 1;
                  }
               }
               break;
            case Keyboard.DOWN:
               if(caretIndex < collection.length - 1)
               {
                  if(direction == TileBaseDirection.VERTICAL || caretIndex == -1)
                  {
                     caretIndex++;
                  }
                  else
                  {
                     _loc11_ = indexToRow(caretIndex);
                     _loc12_ = indexToColumn(caretIndex);
                     if(_loc11_ == lastRowInColumn(_loc12_))
                     {
                        _loc11_ = 0;
                        _loc12_++;
                     }
                     else
                     {
                        _loc11_++;
                     }
                     caretIndex = Math.min(indicesToIndex(_loc11_,_loc12_),collection.length - 1);
                  }
                  _loc11_ = indexToRow(caretIndex);
                  _loc12_ = indexToColumn(caretIndex);
                  if(_loc11_ >= verticalScrollPosition + _loc13_ - _loc15_ && verticalScrollPosition < maxVerticalScrollPosition)
                  {
                     _loc4_ = verticalScrollPosition + 1;
                  }
                  if(_loc11_ < verticalScrollPosition)
                  {
                     _loc4_ = _loc11_;
                  }
                  if(_loc12_ > horizontalScrollPosition + columnCount - 1)
                  {
                     _loc5_ = horizontalScrollPosition + 1;
                  }
               }
               break;
            case Keyboard.PAGE_UP:
               if(caretIndex < 0)
               {
                  caretIndex = scrollPositionToIndex(horizontalScrollPosition,verticalScrollPosition);
               }
               _loc11_ = indexToRow(caretIndex);
               _loc12_ = indexToColumn(caretIndex);
               if(verticalScrollPosition > 0)
               {
                  if(_loc11_ == verticalScrollPosition)
                  {
                     _loc4_ = _loc11_ = Math.max(verticalScrollPosition - (_loc13_ - _loc15_),0);
                  }
                  else
                  {
                     _loc11_ = verticalScrollPosition;
                  }
                  caretIndex = indicesToIndex(_loc11_,_loc12_);
                  break;
               }
            case Keyboard.HOME:
               if(collection.length)
               {
                  caretIndex = 0;
                  _loc4_ = 0;
                  _loc5_ = 0;
               }
               break;
            case Keyboard.PAGE_DOWN:
               if(caretIndex < 0)
               {
                  caretIndex = scrollPositionToIndex(horizontalScrollPosition,verticalScrollPosition);
               }
               _loc11_ = indexToRow(caretIndex);
               _loc12_ = indexToColumn(caretIndex);
               if(_loc11_ < maxVerticalScrollPosition)
               {
                  if(_loc11_ == verticalScrollPosition + (_loc13_ - _loc15_))
                  {
                     _loc4_ = Math.min(verticalScrollPosition + _loc13_ - _loc15_,maxVerticalScrollPosition);
                     _loc11_ = verticalScrollPosition + _loc13_;
                  }
                  else
                  {
                     _loc11_ = Math.min(verticalScrollPosition + _loc13_ - _loc15_,indexToRow(collection.length - 1));
                     if(_loc11_ == verticalScrollPosition + _loc13_ - _loc15_)
                     {
                        _loc4_ = Math.min(verticalScrollPosition + _loc13_ - _loc15_,maxVerticalScrollPosition);
                     }
                  }
                  caretIndex = Math.min(indicesToIndex(_loc11_,_loc12_),collection.length - 1);
                  break;
               }
            case Keyboard.END:
               if(caretIndex < collection.length)
               {
                  caretIndex = collection.length - 1;
                  _loc4_ = maxVerticalScrollPosition;
                  _loc5_ = maxHorizontalScrollPosition;
               }
         }
         if(!isNaN(_loc4_))
         {
            if(_loc4_ != verticalScrollPosition)
            {
               _loc17_ = new ScrollEvent(ScrollEvent.SCROLL);
               _loc17_.detail = ScrollEventDetail.THUMB_POSITION;
               _loc17_.direction = ScrollEventDirection.VERTICAL;
               _loc17_.delta = _loc4_ - verticalScrollPosition;
               _loc17_.position = _loc4_;
               verticalScrollPosition = _loc4_;
               dispatchEvent(_loc17_);
            }
         }
         if(iteratorValid)
         {
            if(!isNaN(_loc5_))
            {
               if(_loc5_ != horizontalScrollPosition)
               {
                  _loc17_ = new ScrollEvent(ScrollEvent.SCROLL);
                  _loc17_.detail = ScrollEventDetail.THUMB_POSITION;
                  _loc17_.direction = ScrollEventDirection.HORIZONTAL;
                  _loc17_.delta = _loc5_ - horizontalScrollPosition;
                  _loc17_.position = _loc5_;
                  horizontalScrollPosition = _loc5_;
                  dispatchEvent(_loc17_);
               }
            }
         }
         if(!iteratorValid)
         {
            keySelectionPending = true;
            return;
         }
         bShiftKey = param2;
         bCtrlKey = param3;
         lastKey = param1;
         finishKeySelection();
      }
      
      override protected function scrollVertically(param1:int, param2:int, param3:Boolean) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Number = NaN;
         var _loc7_:String = null;
         var _loc8_:int = 0;
         var _loc9_:Number = NaN;
         var _loc14_:int = 0;
         var _loc15_:int = 0;
         var _loc16_:int = 0;
         var _loc21_:int = 0;
         var _loc22_:int = 0;
         var _loc23_:IListItemRenderer = null;
         var _loc24_:int = 0;
         var _loc25_:Point = null;
         var _loc26_:int = 0;
         removeClipMask();
         var _loc10_:int = offscreenExtraRowsBottom;
         var _loc11_:int = offscreenExtraRowsTop;
         var _loc12_:int = offscreenExtraRows / 2;
         var _loc13_:int = offscreenExtraRows / 2;
         if(param3)
         {
            offscreenExtraRowsTop = Math.min(_loc12_,offscreenExtraRowsTop + param2);
            _loc14_ = param2 - (offscreenExtraRowsTop - _loc11_);
            _loc15_ = _loc14_;
         }
         else
         {
            _loc21_ = offscreenExtraRowsBottom == 0 && listItems.length && listItems[listItems.length - 1][0] && listItems[listItems.length - 1][0].y + rowHeight < listContent.heightExcludingOffsets - listContent.topOffset?1:0;
            offscreenExtraRowsTop = Math.min(_loc12_,param1);
            offscreenExtraRowsBottom = Math.min(offscreenExtraRowsBottom + param2 - _loc21_,_loc13_);
            _loc14_ = param2 - (_loc11_ - offscreenExtraRowsTop);
            _loc16_ = offscreenExtraRowsTop - _loc11_ + _loc21_ + (offscreenExtraRowsBottom - _loc10_);
            _loc15_ = param2 - (offscreenExtraRowsBottom - _loc10_) - _loc21_;
         }
         var _loc17_:int = listItems.length;
         var _loc18_:int = 0;
         while(_loc18_ < _loc15_)
         {
            _loc5_ = !!param3?int(listItems[_loc18_].length):int(listItems[_loc17_ - _loc18_ - 1].length);
            _loc22_ = 0;
            while(_loc22_ < columnCount && _loc22_ < _loc5_)
            {
               _loc23_ = !!param3?listItems[_loc18_][_loc22_]:listItems[_loc17_ - _loc18_ - 1][_loc22_];
               if(_loc23_)
               {
                  delete visibleData[rowMap[_loc23_.name].uid];
                  removeIndicators(rowMap[_loc23_.name].uid);
                  addToFreeItemRenderers(_loc23_);
                  delete rowMap[_loc23_.name];
                  if(param3)
                  {
                     listItems[_loc18_][_loc22_] = null;
                  }
                  else
                  {
                     listItems[_loc17_ - _loc18_ - 1][_loc22_] = null;
                  }
               }
               _loc22_++;
            }
            _loc18_++;
         }
         var _loc19_:int = listItems.length;
         if(param3)
         {
            _loc9_ = _loc14_ * rowHeight;
            _loc6_ = 0;
            _loc18_ = _loc14_;
            while(_loc18_ < _loc19_)
            {
               _loc5_ = listItems[_loc18_].length;
               _loc22_ = 0;
               while(_loc22_ < columnCount && _loc22_ < _loc5_)
               {
                  _loc23_ = listItems[_loc18_][_loc22_];
                  listItems[_loc18_ - _loc14_][_loc22_] = _loc23_;
                  if(_loc23_)
                  {
                     _loc23_.y = _loc23_.y - _loc9_;
                     rowMap[_loc23_.name].rowIndex = rowMap[_loc23_.name].rowIndex - _loc14_;
                     moveIndicatorsVertically(rowMap[_loc23_.name].uid,-_loc9_);
                  }
                  _loc22_++;
               }
               if(_loc5_ < columnCount)
               {
                  _loc22_ = _loc5_;
                  while(_loc22_ < columnCount)
                  {
                     listItems[_loc18_ - _loc14_][_loc22_] = null;
                     _loc22_++;
                  }
               }
               rowInfo[_loc18_ - _loc14_] = rowInfo[_loc18_];
               rowInfo[_loc18_ - _loc14_].y = rowInfo[_loc18_ - _loc14_].y - _loc9_;
               _loc6_ = rowInfo[_loc18_ - _loc14_].y + rowHeight;
               _loc18_++;
            }
            listItems.splice(_loc19_ - _loc14_ - 1,_loc14_);
            rowInfo.splice(_loc19_ - _loc14_ - 1,_loc14_);
            _loc8_ = indicesToIndex(verticalScrollPosition - offscreenExtraRowsTop + _loc19_ - _loc14_,horizontalScrollPosition);
            seekPositionSafely(_loc8_);
            _loc24_ = param2 + (_loc13_ - _loc10_);
            _loc25_ = makeRowsAndColumns(0,_loc6_,listContent.width,_loc6_ + param2 * rowHeight,0,_loc19_ - _loc14_,true,_loc24_);
            _loc26_ = _loc24_ - _loc25_.y;
            while(_loc26_--)
            {
               listItems.pop();
               rowInfo.pop();
            }
            _loc8_ = indicesToIndex(verticalScrollPosition - offscreenExtraRowsTop,horizontalScrollPosition);
            seekPositionSafely(_loc8_);
            offscreenExtraRowsBottom = Math.max(0,_loc13_ - (_loc25_.y < param2?_loc24_ - _loc25_.y:0));
         }
         else
         {
            if(_loc16_ < 0)
            {
               listItems.splice(listItems.length + _loc16_,-_loc16_);
               rowInfo.splice(rowInfo.length + _loc16_,-_loc16_);
            }
            else if(_loc16_ > 0)
            {
               _loc18_ = 0;
               while(_loc18_ < _loc16_)
               {
                  listItems[_loc19_ + _loc18_] = [];
                  _loc18_++;
               }
            }
            _loc9_ = _loc14_ * rowHeight;
            _loc6_ = rowInfo[_loc14_].y;
            _loc18_ = listItems.length - 1 - _loc14_;
            while(_loc18_ >= 0)
            {
               _loc5_ = listItems[_loc18_].length;
               _loc22_ = 0;
               while(_loc22_ < columnCount && _loc22_ < _loc5_)
               {
                  _loc23_ = listItems[_loc18_][_loc22_];
                  if(_loc23_)
                  {
                     _loc23_.y = _loc23_.y + _loc9_;
                     rowMap[_loc23_.name].rowIndex = rowMap[_loc23_.name].rowIndex + _loc14_;
                     _loc7_ = rowMap[_loc23_.name].uid;
                     listItems[_loc18_ + _loc14_][_loc22_] = _loc23_;
                     moveIndicatorsVertically(_loc7_,_loc9_);
                  }
                  else
                  {
                     listItems[_loc18_ + _loc14_][_loc22_] = null;
                  }
                  _loc22_++;
               }
               rowInfo[_loc18_ + _loc14_] = rowInfo[_loc18_];
               rowInfo[_loc18_ + _loc14_].y = rowInfo[_loc18_ + _loc14_].y + _loc9_;
               _loc18_--;
            }
            _loc18_ = 0;
            while(_loc18_ < _loc14_)
            {
               _loc22_ = 0;
               while(_loc22_ < columnCount)
               {
                  listItems[_loc18_][_loc22_] = null;
                  _loc22_++;
               }
               _loc18_++;
            }
            _loc8_ = indicesToIndex(verticalScrollPosition - offscreenExtraRowsTop,horizontalScrollPosition);
            seekPositionSafely(_loc8_);
            allowRendererStealingDuringLayout = false;
            _loc25_ = makeRowsAndColumns(0,0,listContent.width,_loc6_,0,0,true,_loc14_);
            allowRendererStealingDuringLayout = true;
            seekPositionSafely(_loc8_);
         }
         var _loc20_:Number = listContent.heightExcludingOffsets;
         listContent.topOffset = -rowHeight * offscreenExtraRowsTop;
         listContent.bottomOffset = !!offscreenExtraRowsBottom?Number(rowInfo[rowInfo.length - 1].y + rowHeight + listContent.topOffset - _loc20_):Number(0);
         adjustListContent();
         addClipMask(false);
      }
      
      override public function showDropFeedback(param1:DragEvent) : void
      {
         var _loc7_:Class = null;
         var _loc8_:EdgeMetrics = null;
         if(!dropIndicator)
         {
            _loc7_ = getStyle("dropIndicatorSkin");
            if(!_loc7_)
            {
               _loc7_ = ListDropIndicator;
            }
            dropIndicator = IFlexDisplayObject(new _loc7_());
            _loc8_ = viewMetrics;
            drawFocus(true);
            dropIndicator.x = 2;
            if(direction == TileBaseDirection.HORIZONTAL)
            {
               dropIndicator.setActualSize(rowHeight - 4,4);
               DisplayObject(dropIndicator).rotation = 90;
            }
            else
            {
               dropIndicator.setActualSize(columnWidth - 4,4);
            }
            dropIndicator.visible = true;
            listContent.addChild(DisplayObject(dropIndicator));
            if(collection)
            {
               dragScrollingInterval = setInterval(dragScroll,15);
            }
         }
         var _loc2_:int = calculateDropIndex(param1);
         var _loc3_:int = indexToRow(_loc2_);
         var _loc4_:int = indexToColumn(_loc2_);
         _loc3_ = _loc3_ - (verticalScrollPosition - offscreenExtraRowsTop);
         _loc4_ = _loc4_ - (horizontalScrollPosition - offscreenExtraColumnsLeft);
         var _loc5_:Number = listItems.length;
         if(_loc3_ >= _loc5_)
         {
            _loc3_ = _loc5_ - 1;
         }
         var _loc6_:Number = !!_loc5_?Number(listItems[0].length):Number(0);
         if(_loc4_ > _loc6_)
         {
            _loc4_ = _loc6_;
         }
         dropIndicator.x = _loc6_ && listItems[_loc3_].length && listItems[_loc3_][_loc4_]?Number(listItems[_loc3_][_loc4_].x):Number(_loc4_ * columnWidth);
         dropIndicator.y = _loc5_ && listItems[_loc3_].length && listItems[_loc3_][0]?Number(listItems[_loc3_][0].y):Number(_loc3_ * rowHeight);
      }
      
      public function set maxColumns(param1:int) : void
      {
         if(_maxColumns != param1)
         {
            _maxColumns = param1;
            invalidateSize();
            invalidateDisplayList();
         }
      }
      
      override protected function configureScrollBars() : void
      {
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc1_:int = listItems.length;
         if(_loc1_ == 0)
         {
            return;
         }
         var _loc2_:int = listItems[0].length;
         if(_loc2_ == 0)
         {
            return;
         }
         if(_loc1_ > 1 && (_loc1_ - offscreenExtraRowsTop - offscreenExtraRowsBottom) * rowHeight > listContent.heightExcludingOffsets)
         {
            _loc1_--;
         }
         _loc1_ = _loc1_ - (offscreenExtraRowsTop + offscreenExtraRowsBottom);
         if(_loc2_ > 1 && (_loc2_ - offscreenExtraColumnsLeft - offscreenExtraColumnsRight) * columnWidth > listContent.widthExcludingOffsets)
         {
            _loc2_--;
         }
         _loc2_ = _loc2_ - (offscreenExtraColumnsLeft + offscreenExtraColumnsRight);
         var _loc3_:Object = horizontalScrollBar;
         var _loc4_:Object = verticalScrollBar;
         if(direction == TileBaseDirection.VERTICAL)
         {
            if(iteratorValid && horizontalScrollPosition > 0)
            {
               _loc8_ = 0;
               while(_loc2_ > 0 && listItems[0][_loc2_ + offscreenExtraColumnsLeft - 1] == null)
               {
                  _loc2_--;
                  _loc8_++;
               }
               _loc9_ = Math.floor(listContent.widthExcludingOffsets / columnWidth);
               _loc10_ = Math.max(0,_loc9_ - (_loc2_ + _loc8_));
               if(_loc8_ || _loc10_)
               {
                  _loc11_ = 0;
                  while(_loc11_ < listItems.length)
                  {
                     while(listItems[_loc11_].length > _loc2_ + offscreenExtraColumnsLeft)
                     {
                        (listItems[_loc11_] as Array).pop();
                     }
                     _loc11_++;
                  }
                  if(!runningDataEffect)
                  {
                     horizontalScrollPosition = Math.max(0,horizontalScrollPosition - (_loc8_ + _loc10_));
                     _loc7_ = scrollPositionToIndex(Math.max(0,horizontalScrollPosition - offscreenExtraColumnsLeft),verticalScrollPosition);
                     seekPositionSafely(_loc7_);
                     updateList();
                  }
                  return;
               }
            }
            if(!iteratorValid)
            {
               _loc1_ = Math.floor(listContent.heightExcludingOffsets / rowHeight);
            }
            _loc5_ = maxRows > 0?int(maxRows):int(_loc1_);
            _loc6_ = !!collection?int(Math.ceil(collection.length / _loc5_)):int(_loc2_);
         }
         else
         {
            if(iteratorValid && verticalScrollPosition > 0)
            {
               _loc12_ = 0;
               while(_loc1_ > 0 && (listItems[_loc1_ + offscreenExtraRowsTop - 1] == null || listItems[_loc1_ + offscreenExtraRowsTop - 1][0] == null))
               {
                  _loc1_--;
                  _loc12_++;
               }
               if(_loc12_)
               {
                  while(listItems.length > _loc1_ + offscreenExtraRowsTop)
                  {
                     listItems.pop();
                     rowInfo.pop();
                  }
                  if(!runningDataEffect)
                  {
                     verticalScrollPosition = Math.max(0,verticalScrollPosition - _loc12_);
                     _loc7_ = scrollPositionToIndex(horizontalScrollPosition,Math.max(0,verticalScrollPosition - offscreenExtraRowsTop));
                     seekPositionSafely(_loc7_);
                     updateList();
                  }
                  return;
               }
            }
            if(!iteratorValid)
            {
               _loc2_ = Math.floor(listContent.widthExcludingOffsets / columnWidth);
            }
            _loc6_ = maxColumns > 0?int(maxColumns):int(_loc2_);
            _loc5_ = !!collection?int(Math.ceil(collection.length / _loc6_)):int(_loc1_);
         }
         maxHorizontalScrollPosition = Math.max(0,_loc6_ - _loc2_);
         maxVerticalScrollPosition = Math.max(0,_loc5_ - _loc1_);
         setScrollBarProperties(_loc6_,_loc2_,_loc5_,_loc1_);
      }
      
      override protected function indexToRow(param1:int) : int
      {
         var _loc3_:int = 0;
         if(direction == TileBaseDirection.VERTICAL)
         {
            _loc3_ = maxRows > 0?int(maxRows):int(rowCount);
            return param1 % _loc3_;
         }
         var _loc2_:int = maxColumns > 0?int(maxColumns):int(columnCount);
         return Math.floor(param1 / _loc2_);
      }
      
      private function displayingPartialColumn() : Boolean
      {
         var _loc1_:IListItemRenderer = null;
         if(listItems[0] && listItems[0].length > 0)
         {
            _loc1_ = listItems[0][listItems[0].length - 1 - offscreenExtraColumnsRight];
            if(_loc1_ && _loc1_.x + _loc1_.width > listContent.widthExcludingOffsets - listContent.leftOffset)
            {
               return true;
            }
         }
         return false;
      }
      
      override protected function scrollHandler(param1:Event) : void
      {
         var scrollBar:ScrollBar = null;
         var pos:Number = NaN;
         var delta:int = 0;
         var startIndex:int = 0;
         var o:EdgeMetrics = null;
         var bookmark:CursorBookmark = null;
         var event:Event = param1;
         if(event is ScrollEvent)
         {
            if(!liveScrolling && ScrollEvent(event).detail == ScrollEventDetail.THUMB_TRACK)
            {
               return;
            }
            scrollBar = ScrollBar(event.target);
            pos = scrollBar.scrollPosition;
            if(scrollBar == verticalScrollBar)
            {
               delta = pos - verticalScrollPosition;
               super.scrollHandler(event);
               if(Math.abs(delta) >= listItems.length || !iteratorValid)
               {
                  startIndex = indicesToIndex(pos,horizontalScrollPosition);
                  try
                  {
                     iterator.seek(CursorBookmark.FIRST,startIndex);
                     if(!iteratorValid)
                     {
                        iteratorValid = true;
                        lastSeekPending = null;
                     }
                  }
                  catch(e:ItemPendingError)
                  {
                     lastSeekPending = new ListBaseSeekPending(CursorBookmark.FIRST,startIndex);
                     e.addResponder(new ItemResponder(seekPendingResultHandler,seekPendingFailureHandler,lastSeekPending));
                     iteratorValid = false;
                  }
                  bookmark = iterator.bookmark;
                  clearIndicators();
                  clearVisibleData();
                  makeRowsAndColumns(0,0,listContent.width,listContent.height,0,0);
                  iterator.seek(bookmark,0);
                  drawRowBackgrounds();
               }
               else if(delta != 0)
               {
                  scrollVertically(pos,Math.abs(delta),delta > 0);
               }
            }
            else
            {
               delta = pos - horizontalScrollPosition;
               super.scrollHandler(event);
               if(Math.abs(delta) >= listItems[0].length || !iteratorValid)
               {
                  startIndex = indicesToIndex(verticalScrollPosition,pos);
                  try
                  {
                     iterator.seek(CursorBookmark.FIRST,startIndex);
                     if(!iteratorValid)
                     {
                        iteratorValid = true;
                        lastSeekPending = null;
                     }
                  }
                  catch(e:ItemPendingError)
                  {
                     lastSeekPending = new ListBaseSeekPending(CursorBookmark.FIRST,startIndex);
                     e.addResponder(new ItemResponder(seekPendingResultHandler,seekPendingFailureHandler,lastSeekPending));
                     iteratorValid = false;
                  }
                  bookmark = iterator.bookmark;
                  clearIndicators();
                  clearVisibleData();
                  makeRowsAndColumns(0,0,listContent.width,listContent.height,0,0);
                  iterator.seek(bookmark,0);
                  drawRowBackgrounds();
               }
               else if(delta != 0)
               {
                  scrollHorizontally(pos,Math.abs(delta),delta > 0);
               }
            }
         }
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
      
      override public function itemRendererToIndex(param1:IListItemRenderer) : int
      {
         var _loc2_:String = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         if(runningDataEffect)
         {
            _loc2_ = itemToUID(dataItemWrappersByRenderer[param1]);
         }
         else
         {
            _loc2_ = itemToUID(param1.data);
         }
         var _loc3_:int = listItems.length;
         var _loc4_:int = 0;
         while(_loc4_ < listItems.length)
         {
            _loc5_ = listItems[_loc4_].length;
            _loc6_ = 0;
            while(_loc6_ < _loc5_)
            {
               if(listItems[_loc4_][_loc6_] && rowMap[listItems[_loc4_][_loc6_].name].uid == _loc2_)
               {
                  if(direction == TileBaseDirection.VERTICAL)
                  {
                     return (_loc6_ + horizontalScrollPosition - offscreenExtraColumnsLeft) * Math.max(maxRows,rowCount) + _loc4_;
                  }
                  return (_loc4_ + verticalScrollPosition - offscreenExtraRowsTop) * Math.max(maxColumns,columnCount) + _loc6_;
               }
               _loc6_++;
            }
            _loc4_++;
         }
         return -1;
      }
      
      override public function measureHeightOfItems(param1:int = -1, param2:int = 0) : Number
      {
         var _loc3_:Number = NaN;
         var _loc7_:Object = null;
         var _loc8_:Object = null;
         var _loc9_:IFactory = null;
         var _loc10_:IListItemRenderer = null;
         var _loc4_:Boolean = false;
         if(collection && collection.length)
         {
            _loc7_ = iterator.current;
            _loc8_ = _loc7_ is ItemWrapper?_loc7_.data:_loc7_;
            _loc9_ = getItemRendererFactory(_loc8_);
            _loc10_ = measuringObjects[_loc9_];
            if(_loc10_ == null)
            {
               _loc10_ = getMeasuringRenderer(_loc8_);
               _loc4_ = true;
            }
            setupRendererFromData(_loc10_,_loc8_);
            _loc3_ = _loc10_.getExplicitOrMeasuredHeight();
            if(_loc4_)
            {
               _loc10_.setActualSize(_loc10_.getExplicitOrMeasuredWidth(),_loc3_);
               _loc4_ = false;
            }
         }
         if(isNaN(_loc3_) || _loc3_ == 0)
         {
            _loc3_ = 50;
         }
         var _loc5_:Number = getStyle("paddingTop");
         var _loc6_:Number = getStyle("paddingBottom");
         _loc3_ = _loc3_ + (_loc5_ + _loc6_);
         return _loc3_ * param2;
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
      
      private function getPreparedItemRenderer(param1:int, param2:int, param3:Object, param4:Object, param5:String) : IListItemRenderer
      {
         var _loc7_:IListItemRenderer = null;
         var _loc8_:ListData = null;
         var _loc9_:ListData = null;
         var _loc6_:IListItemRenderer = listItems[param1][param2];
         if(_loc6_)
         {
            if(!!runningDataEffect?dataItemWrappersByRenderer[_loc6_] != param3:_loc6_.data != param4)
            {
               addToFreeItemRenderers(_loc6_);
            }
            else
            {
               _loc7_ = _loc6_;
            }
         }
         if(!_loc7_)
         {
            if(allowRendererStealingDuringLayout)
            {
               _loc7_ = visibleData[param5];
               if(!_loc7_ && param3 != param4)
               {
                  _loc7_ = visibleData[itemToUID(param4)];
               }
            }
            if(_loc7_)
            {
               _loc9_ = ListData(rowMap[_loc7_.name]);
               if(_loc9_)
               {
                  if(direction == TileBaseDirection.HORIZONTAL && (_loc9_.rowIndex > param1 || _loc9_.rowIndex == param1 && _loc9_.columnIndex > param2) || direction == TileBaseDirection.VERTICAL && (_loc9_.columnIndex > param2 || _loc9_.columnIndex == param2 && _loc9_.rowIndex > param1))
                  {
                     listItems[_loc9_.rowIndex][_loc9_.columnIndex] = null;
                  }
                  else
                  {
                     _loc7_ = null;
                  }
               }
            }
            if(!_loc7_)
            {
               _loc7_ = getReservedOrFreeItemRenderer(param3);
               if(_loc7_ && !isRendererUnconstrained(_loc7_))
               {
                  _loc7_.x = 0;
                  _loc7_.y = 0;
               }
            }
            if(!_loc7_)
            {
               _loc7_ = createItemRenderer(param4);
            }
            _loc7_.owner = this;
            _loc7_.styleName = listContent;
         }
         if(!_loc7_.parent)
         {
            listContent.addChild(DisplayObject(_loc7_));
         }
         _loc8_ = ListData(makeListData(param4,param5,param1,param2));
         rowMap[_loc7_.name] = _loc8_;
         if(_loc7_ is IDropInListItemRenderer)
         {
            IDropInListItemRenderer(_loc7_).listData = !!param4?_loc8_:null;
         }
         _loc7_.data = param4;
         if(param3 != param4)
         {
            dataItemWrappersByRenderer[_loc7_] = param3;
         }
         _loc7_.visible = true;
         if(param5)
         {
            visibleData[param5] = _loc7_;
         }
         listItems[param1][param2] = _loc7_;
         UIComponentGlobals.layoutManager.validateClient(_loc7_,true);
         return _loc7_;
      }
      
      private function placeAndDrawItemRenderer(param1:IListItemRenderer, param2:Number, param3:Number, param4:String) : void
      {
         var _loc8_:Number = NaN;
         var _loc5_:* = false;
         var _loc6_:* = false;
         var _loc7_:* = false;
         _loc8_ = param1.getExplicitOrMeasuredHeight();
         if(param1.width != columnWidth || _loc8_ != rowHeight - cachedPaddingTop - cachedPaddingBottom)
         {
            param1.setActualSize(columnWidth,rowHeight - cachedPaddingTop - cachedPaddingBottom);
         }
         if(!isRendererUnconstrained(param1))
         {
            param1.move(param2,param3 + cachedPaddingTop);
         }
         _loc5_ = selectedData[param4] != null;
         if(runningDataEffect)
         {
            _loc5_ = Boolean(_loc5_ || selectedData[itemToUID(param1.data)] != null);
            _loc5_ = Boolean(_loc5_ && !getRendererSemanticValue(param1,ModifiedCollectionView.REPLACEMENT) && !getRendererSemanticValue(param1,ModifiedCollectionView.ADDED));
         }
         _loc6_ = highlightUID == param4;
         _loc7_ = caretUID == param4;
         if(param4)
         {
            drawItem(param1,_loc5_,_loc6_,_loc7_);
         }
      }
      
      override protected function makeRowsAndColumns(param1:Number, param2:Number, param3:Number, param4:Number, param5:int, param6:int, param7:Boolean = false, param8:uint = 0) : Point
      {
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc15_:Object = null;
         var _loc16_:Object = null;
         var _loc17_:String = null;
         var _loc18_:IListItemRenderer = null;
         var _loc19_:IListItemRenderer = null;
         var _loc20_:Boolean = false;
         var _loc21_:Boolean = false;
         var _loc22_:int = 0;
         var _loc23_:Number = NaN;
         var _loc24_:int = 0;
         var _loc25_:int = 0;
         var _loc29_:Array = null;
         var _loc26_:Boolean = false;
         var _loc27_:Boolean = false;
         var _loc28_:Boolean = false;
         if(columnWidth == 0 || rowHeight == 0)
         {
            return null;
         }
         invalidateSizeFlag = true;
         allowItemSizeChangeNotification = false;
         if(direction == TileBaseDirection.VERTICAL)
         {
            _loc9_ = maxRows > 0?int(maxRows):int(Math.max(Math.floor(listContent.heightExcludingOffsets / rowHeight),1));
            _loc10_ = Math.max(Math.ceil(listContent.widthExcludingOffsets / columnWidth),1);
            setRowCount(_loc9_);
            setColumnCount(_loc10_);
            _loc11_ = param5;
            _loc13_ = param1;
            _loc25_ = _loc11_ - 1;
            _loc20_ = iterator != null && !iterator.afterLast && iteratorValid;
            while(param7 && param8-- || !param7 && _loc11_ < _loc10_ + param5)
            {
               _loc12_ = param6;
               _loc14_ = param2;
               while(_loc12_ < _loc9_)
               {
                  _loc21_ = _loc20_;
                  _loc15_ = !!_loc20_?iterator.current:null;
                  _loc16_ = _loc15_ is ItemWrapper?_loc15_.data:_loc15_;
                  _loc20_ = moveNextSafely(_loc20_);
                  if(!listItems[_loc12_])
                  {
                     listItems[_loc12_] = [];
                  }
                  if(_loc21_ && _loc14_ < param4)
                  {
                     _loc17_ = itemToUID(_loc15_);
                     rowInfo[_loc12_] = new ListRowInfo(_loc14_,rowHeight,_loc17_);
                     _loc19_ = getPreparedItemRenderer(_loc12_,_loc11_,_loc15_,_loc16_,_loc17_);
                     placeAndDrawItemRenderer(_loc19_,_loc13_,_loc14_,_loc17_);
                     _loc25_ = Math.max(_loc11_,_loc25_);
                  }
                  else
                  {
                     _loc18_ = listItems[_loc12_][_loc11_];
                     if(_loc18_)
                     {
                        addToFreeItemRenderers(_loc18_);
                        listItems[_loc12_][_loc11_] = null;
                     }
                     rowInfo[_loc12_] = new ListRowInfo(_loc14_,rowHeight,_loc17_);
                  }
                  _loc14_ = _loc14_ + rowHeight;
                  _loc12_++;
               }
               _loc11_++;
               if(param6)
               {
                  _loc22_ = 0;
                  while(_loc22_ < param6)
                  {
                     _loc20_ = moveNextSafely(_loc20_);
                     _loc22_++;
                  }
               }
               _loc13_ = _loc13_ + columnWidth;
            }
         }
         else
         {
            _loc10_ = maxColumns > 0?int(maxColumns):int(Math.max(Math.floor(listContent.widthExcludingOffsets / columnWidth),1));
            _loc9_ = Math.max(Math.ceil(listContent.heightExcludingOffsets / rowHeight),1);
            setColumnCount(_loc10_);
            setRowCount(_loc9_);
            _loc12_ = param6;
            _loc14_ = param2;
            _loc20_ = iterator != null && !iterator.afterLast && iteratorValid;
            _loc24_ = _loc12_ - 1;
            while(param7 && param8-- || !param7 && _loc12_ < _loc9_ + param6)
            {
               _loc11_ = param5;
               _loc13_ = param1;
               rowInfo[_loc12_] = null;
               while(_loc11_ < _loc10_)
               {
                  _loc21_ = _loc20_;
                  _loc15_ = !!_loc20_?iterator.current:null;
                  _loc16_ = _loc15_ is ItemWrapper?_loc15_.data:_loc15_;
                  _loc20_ = moveNextSafely(_loc20_);
                  if(!listItems[_loc12_])
                  {
                     listItems[_loc12_] = [];
                  }
                  if(_loc21_ && _loc13_ < param3)
                  {
                     _loc17_ = itemToUID(_loc15_);
                     if(!rowInfo[_loc12_])
                     {
                        rowInfo[_loc12_] = new ListRowInfo(_loc14_,rowHeight,_loc17_);
                     }
                     _loc19_ = getPreparedItemRenderer(_loc12_,_loc11_,_loc15_,_loc16_,_loc17_);
                     placeAndDrawItemRenderer(_loc19_,_loc13_,_loc14_,_loc17_);
                     _loc24_ = _loc12_;
                  }
                  else
                  {
                     if(!rowInfo[_loc12_])
                     {
                        rowInfo[_loc12_] = new ListRowInfo(_loc14_,rowHeight,_loc17_);
                     }
                     _loc18_ = listItems[_loc12_][_loc11_];
                     if(_loc18_)
                     {
                        addToFreeItemRenderers(_loc18_);
                        listItems[_loc12_][_loc11_] = null;
                     }
                  }
                  _loc13_ = _loc13_ + columnWidth;
                  _loc11_++;
               }
               _loc12_++;
               if(param5)
               {
                  _loc22_ = 0;
                  while(_loc22_ < param5)
                  {
                     _loc20_ = moveNextSafely(_loc20_);
                     _loc22_++;
                  }
               }
               _loc14_ = _loc14_ + rowHeight;
            }
         }
         if(!param7)
         {
            while(listItems.length > _loc9_ + offscreenExtraRowsTop)
            {
               _loc29_ = listItems.pop();
               rowInfo.pop();
               _loc22_ = 0;
               while(_loc22_ < _loc29_.length)
               {
                  _loc18_ = _loc29_[_loc22_];
                  if(_loc18_)
                  {
                     addToFreeItemRenderers(_loc18_);
                  }
                  _loc22_++;
               }
            }
            if(listItems.length && listItems[0].length > _loc10_ + offscreenExtraColumnsLeft)
            {
               _loc22_ = 0;
               while(_loc22_ < _loc9_ + offscreenExtraRowsTop)
               {
                  _loc29_ = listItems[_loc22_];
                  while(_loc29_.length > _loc10_ + offscreenExtraColumnsLeft)
                  {
                     _loc18_ = _loc29_.pop();
                     if(_loc18_)
                     {
                        addToFreeItemRenderers(_loc18_);
                     }
                  }
                  _loc22_++;
               }
            }
         }
         allowItemSizeChangeNotification = true;
         invalidateSizeFlag = false;
         return new Point(_loc25_ - param5 + 1,_loc24_ - param6 + 1);
      }
      
      private function lastColumnInRow(param1:int) : int
      {
         var _loc2_:int = maxRows > 0?int(maxRows):int(rowCount);
         var _loc3_:int = Math.floor((collection.length - 1) / _loc2_);
         if(indicesToIndex(param1,_loc3_) >= collection.length)
         {
            _loc3_--;
         }
         return _loc3_;
      }
      
      override protected function get dragImageOffsets() : Point
      {
         var _loc4_:* = null;
         var _loc1_:Point = new Point(8192,8192);
         var _loc2_:Boolean = false;
         var _loc3_:int = listItems.length;
         for(_loc4_ in visibleData)
         {
            if(selectedData[_loc4_])
            {
               _loc1_.x = Math.min(_loc1_.x,visibleData[_loc4_].x);
               _loc1_.y = Math.min(_loc1_.y,visibleData[_loc4_].y);
               _loc2_ = true;
            }
         }
         if(_loc2_)
         {
            return _loc1_;
         }
         return new Point(0,0);
      }
      
      public function get maxColumns() : int
      {
         return _maxColumns;
      }
      
      public function set maxRows(param1:int) : void
      {
         if(_maxRows != param1)
         {
            _maxRows = param1;
            invalidateSize();
            invalidateDisplayList();
         }
      }
      
      public function get maxRows() : int
      {
         return _maxRows;
      }
      
      private function moveNextSafely(param1:Boolean) : Boolean
      {
         var more:Boolean = param1;
         if(iterator && more)
         {
            try
            {
               more = iterator.moveNext();
            }
            catch(e1:ItemPendingError)
            {
               lastSeekPending = new ListBaseSeekPending(CursorBookmark.CURRENT,0);
               e1.addResponder(new ItemResponder(seekPendingResultHandler,seekPendingFailureHandler,lastSeekPending));
               more = false;
               iteratorValid = false;
            }
         }
         return more;
      }
      
      private function lastRowInColumn(param1:int) : int
      {
         var _loc2_:int = maxColumns > 0?int(maxColumns):int(columnCount);
         var _loc3_:int = Math.floor((collection.length - 1) / _loc2_);
         if(param1 * _loc3_ > collection.length)
         {
            _loc3_--;
         }
         return _loc3_;
      }
      
      protected function drawTileBackground(param1:Sprite, param2:int, param3:int, param4:Number, param5:Number, param6:uint, param7:IListItemRenderer) : DisplayObject
      {
         var _loc9_:Shape = null;
         var _loc8_:int = param2 * columnCount + param3;
         if(_loc8_ < param1.numChildren)
         {
            _loc9_ = Shape(param1.getChildAt(_loc8_));
         }
         else
         {
            _loc9_ = new FlexShape();
            _loc9_.name = "tileBackground";
            param1.addChild(_loc9_);
         }
         var _loc10_:Graphics = _loc9_.graphics;
         _loc10_.clear();
         _loc10_.beginFill(param6,getStyle("backgroundAlpha"));
         _loc10_.drawRect(0,0,param4,param5);
         _loc10_.endFill();
         return _loc9_;
      }
      
      override public function calculateDropIndex(param1:DragEvent = null) : int
      {
         var _loc2_:IListItemRenderer = null;
         var _loc3_:Point = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         if(param1)
         {
            _loc3_ = new Point(param1.localX,param1.localY);
            _loc3_ = DisplayObject(param1.target).localToGlobal(_loc3_);
            _loc3_ = listContent.globalToLocal(_loc3_);
            _loc4_ = listItems.length;
            _loc5_ = 0;
            while(_loc5_ < _loc4_)
            {
               if(rowInfo[_loc5_].y <= _loc3_.y && _loc3_.y < rowInfo[_loc5_].y + rowInfo[_loc5_].height)
               {
                  _loc6_ = listItems[_loc5_].length;
                  _loc7_ = 0;
                  while(_loc7_ < _loc6_)
                  {
                     if(listItems[_loc5_][_loc7_] && listItems[_loc5_][_loc7_].x <= _loc3_.x && _loc3_.x < listItems[_loc5_][_loc7_].x + listItems[_loc5_][_loc7_].width)
                     {
                        _loc2_ = listItems[_loc5_][_loc7_];
                        if(!DisplayObject(_loc2_).visible)
                        {
                           _loc2_ = null;
                        }
                        break;
                     }
                     _loc7_++;
                  }
                  break;
               }
               _loc5_++;
            }
            if(_loc2_)
            {
               lastDropIndex = itemRendererToIndex(_loc2_);
            }
            else
            {
               lastDropIndex = !!collection?int(collection.length):0;
            }
         }
         return lastDropIndex;
      }
      
      override public function set itemRenderer(param1:IFactory) : void
      {
         super.itemRenderer = param1;
         purgeMeasuringRenderers();
      }
      
      mx_internal function setupRendererFromData(param1:IListItemRenderer, param2:Object) : void
      {
         var _loc3_:ListData = ListData(makeListData(param2,itemToUID(param2),0,0));
         if(param1 is IDropInListItemRenderer)
         {
            IDropInListItemRenderer(param1).listData = !!param2?_loc3_:null;
         }
         param1.data = param2;
         UIComponentGlobals.layoutManager.validateClient(param1,true);
      }
      
      protected function makeListData(param1:Object, param2:String, param3:int, param4:int) : BaseListData
      {
         return new ListData(itemToLabel(param1),itemToIcon(param1),labelField,param2,this,param3,param4);
      }
      
      override public function indicesToIndex(param1:int, param2:int) : int
      {
         var _loc4_:int = 0;
         if(direction == TileBaseDirection.VERTICAL)
         {
            _loc4_ = maxRows > 0?int(maxRows):int(rowCount);
            return param2 * _loc4_ + param1;
         }
         var _loc3_:int = maxColumns > 0?int(maxColumns):int(columnCount);
         return param1 * _loc3_ + param2;
      }
      
      override protected function adjustListContent(param1:Number = -1, param2:Number = -1) : void
      {
         var _loc3_:* = false;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         super.adjustListContent(param1,param2);
         if(!collection)
         {
            return;
         }
         var _loc7_:int = collection.length;
         if(direction == TileBaseDirection.VERTICAL)
         {
            _loc5_ = maxRows > 0?int(maxRows):int(Math.max(Math.floor(listContent.heightExcludingOffsets / rowHeight),1));
            _loc6_ = Math.max(Math.ceil(listContent.widthExcludingOffsets / columnWidth),1);
            if(_loc5_ != lastRowCount)
            {
               _loc3_ = listContent.widthExcludingOffsets / columnWidth != Math.ceil(listContent.widthExcludingOffsets / columnWidth);
               _loc8_ = Math.max(Math.ceil(_loc7_ / _loc5_) - _loc6_,0);
               if(_loc3_)
               {
                  _loc8_++;
               }
               if(horizontalScrollPosition > _loc8_)
               {
                  $horizontalScrollPosition = _loc8_;
               }
               setRowCount(_loc5_);
               setColumnCount(_loc6_);
               _loc4_ = scrollPositionToIndex(Math.max(0,horizontalScrollPosition - offscreenExtraColumnsLeft),verticalScrollPosition);
               seekPositionSafely(_loc4_);
            }
            lastRowCount = _loc5_;
         }
         else
         {
            _loc6_ = maxColumns > 0?int(maxColumns):int(Math.max(Math.floor(listContent.widthExcludingOffsets / columnWidth),1));
            _loc5_ = Math.max(Math.ceil(listContent.heightExcludingOffsets / rowHeight),1);
            if(_loc6_ != lastColumnCount)
            {
               _loc3_ = listContent.heightExcludingOffsets / rowHeight != Math.ceil(listContent.heightExcludingOffsets / rowHeight);
               _loc9_ = Math.max(Math.ceil(_loc7_ / _loc6_) - _loc5_,0);
               if(_loc3_)
               {
                  _loc9_++;
               }
               if(verticalScrollPosition > _loc9_)
               {
                  $verticalScrollPosition = _loc9_;
               }
               setRowCount(_loc5_);
               setColumnCount(_loc6_);
               _loc4_ = scrollPositionToIndex(horizontalScrollPosition,Math.max(0,verticalScrollPosition - offscreenExtraRowsTop));
               seekPositionSafely(_loc4_);
            }
            lastColumnCount = _loc6_;
         }
      }
      
      override protected function collectionChangeHandler(param1:Event) : void
      {
         var _loc2_:CollectionEvent = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         if(param1 is CollectionEvent)
         {
            _loc2_ = CollectionEvent(param1);
            if(_loc2_.location == 0 || _loc2_.kind == CollectionEventKind.REFRESH)
            {
               itemsNeedMeasurement = true;
               invalidateProperties();
            }
            if(_loc2_.kind == CollectionEventKind.REMOVE)
            {
               _loc3_ = indicesToIndex(verticalScrollPosition,horizontalScrollPosition);
               if(_loc2_.location < _loc3_)
               {
                  _loc3_ = _loc3_ - _loc2_.items.length;
                  super.collectionChangeHandler(param1);
                  _loc4_ = 0;
                  _loc5_ = 0;
                  if(direction == TileBaseDirection.HORIZONTAL)
                  {
                     super.verticalScrollPosition = indexToRow(_loc3_);
                     _loc4_ = Math.min(offscreenExtraRows / 2,verticalScrollPosition);
                  }
                  else
                  {
                     super.horizontalScrollPosition = indexToColumn(_loc3_);
                     _loc5_ = Math.min(offscreenExtraColumns / 2,horizontalScrollPosition);
                  }
                  _loc6_ = scrollPositionToIndex(horizontalScrollPosition - _loc5_,verticalScrollPosition - _loc4_);
                  seekPositionSafely(_loc6_);
                  return;
               }
            }
         }
         super.collectionChangeHandler(param1);
      }
   }
}
