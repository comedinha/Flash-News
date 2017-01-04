package mx.controls
{
   import flash.display.DisplayObject;
   import flash.display.Graphics;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.ui.Keyboard;
   import flash.xml.XMLNode;
   import mx.collections.ArrayCollection;
   import mx.collections.CursorBookmark;
   import mx.collections.ICollectionView;
   import mx.collections.IViewCursor;
   import mx.collections.ItemResponder;
   import mx.collections.XMLListCollection;
   import mx.collections.errors.ItemPendingError;
   import mx.controls.listClasses.BaseListData;
   import mx.controls.listClasses.IDropInListItemRenderer;
   import mx.controls.listClasses.IListItemRenderer;
   import mx.controls.listClasses.ListBaseSelectionDataPending;
   import mx.controls.listClasses.ListRowInfo;
   import mx.controls.treeClasses.DefaultDataDescriptor;
   import mx.controls.treeClasses.HierarchicalCollectionView;
   import mx.controls.treeClasses.HierarchicalViewCursor;
   import mx.controls.treeClasses.ITreeDataDescriptor;
   import mx.controls.treeClasses.ITreeDataDescriptor2;
   import mx.controls.treeClasses.TreeItemRenderer;
   import mx.controls.treeClasses.TreeListData;
   import mx.core.ClassFactory;
   import mx.core.EdgeMetrics;
   import mx.core.EventPriority;
   import mx.core.FlexShape;
   import mx.core.FlexSprite;
   import mx.core.IFactory;
   import mx.core.IFlexDisplayObject;
   import mx.core.IIMESupport;
   import mx.core.IInvalidating;
   import mx.core.UIComponent;
   import mx.core.UIComponentGlobals;
   import mx.core.mx_internal;
   import mx.effects.Tween;
   import mx.events.CollectionEvent;
   import mx.events.CollectionEventKind;
   import mx.events.DragEvent;
   import mx.events.ListEvent;
   import mx.events.ListEventReason;
   import mx.events.ScrollEvent;
   import mx.events.TreeEvent;
   import mx.managers.DragManager;
   import mx.styles.StyleManager;
   
   use namespace mx_internal;
   
   public class Tree extends List implements IIMESupport
   {
      
      mx_internal static const VERSION:String = "3.6.0.21751";
      
      mx_internal static var createAccessibilityImplementation:Function;
       
      
      mx_internal var wrappedCollection:ICollectionView;
      
      private var lastTreeSeekPending:TreeSeekPending;
      
      private var _openItems:Object;
      
      private var rowIndex:int;
      
      private var _dragMoveEnabled:Boolean = true;
      
      mx_internal var collectionLength:int;
      
      private var eventAfterTween:Object;
      
      private var rowsTweened:int;
      
      mx_internal var showRootChanged:Boolean = false;
      
      private var dontEdit:Boolean = false;
      
      private var openItemsChanged:Boolean = false;
      
      private var opening:Boolean;
      
      mx_internal var _hasRoot:Boolean = false;
      
      private var rowNameID:Number = 0;
      
      private var tween:Object;
      
      private var expandedItem:Object;
      
      private var bSelectedItemRemoved:Boolean = false;
      
      private var IS_NEW_ROW_STYLE:Object;
      
      private var dataProviderChanged:Boolean = false;
      
      private var bFinishArrowKeySelection:Boolean = false;
      
      private var haveItemIndices:Boolean;
      
      mx_internal var collectionThrowsIPE:Boolean;
      
      mx_internal var _dropData:Object;
      
      private var eventPending:Object;
      
      private var rowList:Array;
      
      private var minScrollInterval:Number = 50;
      
      private var maskList:Array;
      
      public var itemIcons:Object;
      
      mx_internal var isOpening:Boolean = false;
      
      private var _editable:Boolean = false;
      
      private var _userMaxHorizontalScrollPosition:Number = 0;
      
      private var lastUserInteraction:Event;
      
      private var proposedSelectedItem:Object;
      
      mx_internal var _showRoot:Boolean = true;
      
      mx_internal var _dataDescriptor:ITreeDataDescriptor;
      
      mx_internal var _rootModel:ICollectionView;
      
      private var oldLength:int = -1;
      
      private var _itemEditor:IFactory;
      
      public function Tree()
      {
         IS_NEW_ROW_STYLE = {
            "depthColors":true,
            "indentation":true,
            "disclosureOpenIcon":true,
            "disclosureClosedIcon":true,
            "folderOpenIcon":true,
            "folderClosedIcon":true,
            "defaultLeafIcon":true
         };
         _itemEditor = new ClassFactory(TextInput);
         _dataDescriptor = new DefaultDataDescriptor();
         _openItems = {};
         super();
         itemRenderer = new ClassFactory(TreeItemRenderer);
         editorXOffset = 12;
         editorWidthOffset = -12;
         addEventListener(TreeEvent.ITEM_OPENING,expandItemHandler,false,EventPriority.DEFAULT_HANDLER);
      }
      
      override mx_internal function removeClipMask() : void
      {
      }
      
      override protected function dragOverHandler(param1:DragEvent) : void
      {
         var event:DragEvent = param1;
         if(event.isDefaultPrevented())
         {
            return;
         }
         lastDragEvent = event;
         try
         {
            if(iteratorValid && event.dragSource.hasFormat("treeItems"))
            {
               if(collectionThrowsIPE)
               {
                  checkItemIndices(event);
               }
               DragManager.showFeedback(!!event.ctrlKey?DragManager.COPY:DragManager.MOVE);
               showDropFeedback(event);
               return;
            }
         }
         catch(e:ItemPendingError)
         {
            if(!lastTreeSeekPending)
            {
               lastTreeSeekPending = new TreeSeekPending(event,dragOverHandler);
               e.addResponder(new ItemResponder(seekPendingDuringDragResultHandler,seekPendingDuringDragFailureHandler,lastTreeSeekPending));
            }
         }
         catch(e1:Error)
         {
         }
         hideDropFeedback(event);
         DragManager.showFeedback(DragManager.NONE);
      }
      
      override protected function mouseUpHandler(param1:MouseEvent) : void
      {
         if(!tween)
         {
            super.mouseUpHandler(param1);
         }
      }
      
      private function buildUpCollectionEvents(param1:Boolean) : Array
      {
         var _loc2_:CollectionEvent = null;
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         var _loc5_:Array = null;
         var _loc10_:ICollectionView = null;
         var _loc11_:IViewCursor = null;
         var _loc12_:Boolean = false;
         var _loc13_:Array = null;
         var _loc14_:int = 0;
         var _loc6_:Array = [];
         var _loc7_:Array = [];
         var _loc8_:Array = [];
         var _loc9_:int = getItemIndex(expandedItem);
         if(param1)
         {
            _loc10_ = getChildren(expandedItem,iterator.view);
            if(!_loc10_)
            {
               return [];
            }
            _loc11_ = _loc10_.createCursor();
            _loc12_ = true;
            while(!_loc11_.afterLast)
            {
               _loc6_.push(_loc11_.current);
               _loc11_.moveNext();
            }
         }
         else
         {
            _loc13_ = [];
            _loc14_ = 0;
            _loc13_ = getOpenChildrenStack(expandedItem,_loc13_);
            while(_loc14_ < _loc13_.length)
            {
               _loc3_ = 0;
               while(_loc3_ < selectedItems.length)
               {
                  if(selectedItems[_loc3_] == _loc13_[_loc14_])
                  {
                     bSelectedItemRemoved = true;
                  }
                  _loc3_++;
               }
               _loc7_.push(_loc13_[_loc14_]);
               _loc14_++;
            }
         }
         if(_loc6_.length > 0)
         {
            _loc2_ = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE);
            _loc2_.kind = CollectionEventKind.ADD;
            _loc2_.location = _loc9_ + 1;
            _loc2_.items = _loc6_;
            _loc8_.push(_loc2_);
         }
         if(_loc7_.length > 0)
         {
            _loc2_ = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE);
            _loc2_.kind = CollectionEventKind.REMOVE;
            _loc2_.location = _loc9_ + 1;
            _loc2_.items = _loc7_;
            _loc8_.push(_loc2_);
         }
         return _loc8_;
      }
      
      private function updateDropData(param1:DragEvent) : void
      {
         var _loc9_:Object = null;
         var _loc10_:int = 0;
         var _loc2_:int = rowInfo.length;
         var _loc3_:int = 0;
         var _loc4_:int = rowInfo[_loc3_].height;
         var _loc5_:Point = globalToLocal(new Point(param1.stageX,param1.stageY));
         while(rowInfo[_loc3_] && _loc5_.y >= _loc4_)
         {
            if(_loc3_ != rowInfo.length - 1)
            {
               _loc3_++;
               _loc4_ = _loc4_ + rowInfo[_loc3_].height;
            }
            else
            {
               _loc4_ = _loc4_ + rowInfo[_loc3_].height;
               _loc3_++;
            }
         }
         var _loc6_:Number = _loc3_ < rowInfo.length?Number(rowInfo[_loc3_].y):Number(rowInfo[_loc3_ - 1].y + rowInfo[_loc3_ - 1].height);
         var _loc7_:Number = _loc5_.y - _loc6_;
         var _loc8_:Number = _loc3_ < rowInfo.length?Number(rowInfo[_loc3_].height):Number(rowInfo[_loc3_ - 1].height);
         _loc3_ = _loc3_ + verticalScrollPosition;
         var _loc11_:Boolean = false;
         var _loc12_:int = !!collection?int(collection.length):0;
         var _loc13_:Object = _loc3_ > _verticalScrollPosition && _loc3_ <= _loc12_?listItems[_loc3_ - _verticalScrollPosition - 1][0].data:null;
         var _loc14_:Object = _loc3_ - verticalScrollPosition < rowInfo.length && _loc3_ < _loc12_?listItems[_loc3_ - _verticalScrollPosition][0].data:null;
         var _loc15_:Object = !!collection?getParentItem(_loc13_):null;
         var _loc16_:Object = !!collection?getParentItem(_loc14_):null;
         if(_loc7_ > _loc8_ * 0.5 && isItemOpen(_loc14_) && _dataDescriptor.isBranch(_loc14_,iterator.view) && (!_dataDescriptor.hasChildren(_loc14_,iterator.view) || _dataDescriptor.getChildren(_loc14_,iterator.view).length == 0))
         {
            _loc9_ = _loc14_;
            _loc10_ = 0;
            _loc11_ = true;
         }
         else if(!_loc13_ && !_loc3_ == _loc2_)
         {
            _loc9_ = !!collection?getParentItem(_loc14_):null;
            _loc10_ = !!_loc14_?int(getChildIndexInParent(_loc9_,_loc14_)):0;
            _loc3_ = 0;
         }
         else if(_loc14_ && _loc16_ == _loc13_)
         {
            _loc9_ = _loc13_;
            _loc10_ = 0;
         }
         else if(_loc13_ && _loc14_ && _loc15_ == _loc16_)
         {
            _loc9_ = !!collection?getParentItem(_loc13_):null;
            _loc10_ = !!iterator?int(getChildIndexInParent(_loc9_,_loc14_)):0;
         }
         else if(_loc13_ && _loc7_ < _loc8_ * 0.5)
         {
            _loc9_ = _loc15_;
            _loc10_ = getChildIndexInParent(_loc9_,_loc13_) + 1;
         }
         else if(!_loc14_)
         {
            _loc9_ = null;
            if(_loc3_ - verticalScrollPosition == 0)
            {
               _loc10_ = 0;
            }
            else if(collection)
            {
               _loc10_ = collection.length;
            }
            else
            {
               _loc10_ = 0;
            }
         }
         else
         {
            _loc9_ = _loc16_;
            _loc10_ = getChildIndexInParent(_loc9_,_loc14_);
         }
         _dropData = {
            "parent":_loc9_,
            "index":_loc10_,
            "localX":param1.localX,
            "localY":param1.localY,
            "emptyFolder":_loc11_,
            "rowHeight":_loc8_,
            "rowIndex":_loc3_
         };
      }
      
      mx_internal function removeChildItem(param1:Object, param2:Object, param3:Number) : Boolean
      {
         return _dataDescriptor.removeChildAt(param1,param2,param3,iterator.view);
      }
      
      public function set openItems(param1:Object) : void
      {
         var _loc2_:* = null;
         var _loc3_:* = undefined;
         if(param1 != null)
         {
            for(_loc2_ in _openItems)
            {
               delete _openItems[_loc2_];
            }
            for each(_loc3_ in param1)
            {
               _openItems[itemToUID(_loc3_)] = _loc3_;
            }
            openItemsChanged = true;
            invalidateProperties();
         }
      }
      
      override protected function drawRowBackgrounds() : void
      {
         var color:Object = null;
         var colors:Array = null;
         var n:int = 0;
         var d:int = 0;
         var rowColor:uint = 0;
         var rowBGs:Sprite = Sprite(listContent.getChildByName("rowBGs"));
         if(!rowBGs)
         {
            rowBGs = new FlexSprite();
            rowBGs.name = "rowBGs";
            rowBGs.mouseEnabled = false;
            listContent.addChildAt(rowBGs,0);
         }
         var depthColors:Boolean = false;
         colors = getStyle("depthColors");
         if(colors)
         {
            depthColors = true;
         }
         else
         {
            colors = getStyle("alternatingItemColors");
         }
         color = getStyle("backgroundColor");
         if(!colors || colors.length == 0)
         {
            while(rowBGs.numChildren > n)
            {
               rowBGs.removeChildAt(rowBGs.numChildren - 1);
            }
            return;
         }
         StyleManager.getColorNames(colors);
         var curRow:int = 0;
         var actualRow:int = verticalScrollPosition;
         var i:int = 0;
         n = listItems.length;
         while(curRow < n)
         {
            if(depthColors)
            {
               try
               {
                  if(listItems[curRow][0])
                  {
                     d = getItemDepth(listItems[curRow][0].data,curRow);
                     rowColor = !!colors[d - 1]?uint(colors[d - 1]):uint(uint(color));
                     drawRowBackground(rowBGs,i++,rowInfo[curRow].y,rowInfo[curRow].height,rowColor,curRow);
                  }
                  else
                  {
                     drawRowBackground(rowBGs,i++,rowInfo[curRow].y,rowInfo[curRow].height,uint(color),curRow);
                  }
               }
               catch(e:Error)
               {
               }
            }
            else
            {
               drawRowBackground(rowBGs,i++,rowInfo[curRow].y,rowInfo[curRow].height,colors[actualRow % colors.length],actualRow);
            }
            curRow++;
            actualRow++;
         }
         while(rowBGs.numChildren > n)
         {
            rowBGs.removeChildAt(rowBGs.numChildren - 1);
         }
      }
      
      override public function showDropFeedback(param1:DragEvent) : void
      {
         var _loc5_:int = 0;
         super.showDropFeedback(param1);
         var _loc2_:EdgeMetrics = viewMetrics;
         var _loc3_:int = 0;
         updateDropData(param1);
         var _loc4_:int = 0;
         if(_dropData.parent)
         {
            _loc3_ = getItemIndex(iterator.current);
            _loc5_ = getItemDepth(_dropData.parent,Math.abs(_loc3_ - getItemIndex(_dropData.parent)));
            _loc4_ = (_loc5_ + 1) * getStyle("indentation");
         }
         else
         {
            _loc4_ = getStyle("indentation");
         }
         if(_loc4_ < 0)
         {
            _loc4_ = 0;
         }
         dropIndicator.width = listContent.width - _loc4_;
         dropIndicator.x = _loc4_ + _loc2_.left + 2;
         if(_dropData.emptyFolder)
         {
            dropIndicator.y = dropIndicator.y + _dropData.rowHeight / 2;
         }
      }
      
      mx_internal function dispatchTreeEvent(param1:String, param2:Object, param3:IListItemRenderer, param4:Event = null, param5:Boolean = true, param6:Boolean = true, param7:Boolean = true) : void
      {
         var _loc8_:TreeEvent = null;
         if(param1 == TreeEvent.ITEM_OPENING)
         {
            _loc8_ = new TreeEvent(TreeEvent.ITEM_OPENING,false,true);
            _loc8_.opening = param5;
            _loc8_.animate = param6;
            _loc8_.dispatchEvent = param7;
         }
         if(!_loc8_)
         {
            _loc8_ = new TreeEvent(param1);
         }
         _loc8_.item = param2;
         _loc8_.itemRenderer = param3;
         _loc8_.triggerEvent = param4;
         dispatchEvent(_loc8_);
      }
      
      private function finishArrowKeySelection() : void
      {
         var _loc1_:ListEvent = null;
         var _loc2_:Point = null;
         var _loc3_:int = 0;
         bFinishArrowKeySelection = false;
         if(proposedSelectedItem)
         {
            selectedItem = proposedSelectedItem;
         }
         if(selectedItem === proposedSelectedItem || !proposedSelectedItem)
         {
            _loc1_ = new ListEvent(ListEvent.CHANGE);
            _loc1_.itemRenderer = indexToItemRenderer(selectedIndex);
            _loc2_ = itemRendererToIndices(_loc1_.itemRenderer);
            if(_loc2_)
            {
               _loc1_.rowIndex = _loc2_.y;
               _loc1_.columnIndex = _loc2_.x;
            }
            dispatchEvent(_loc1_);
            _loc3_ = getItemIndex(selectedItem);
            if(_loc3_ != caretIndex)
            {
               caretIndex = selectedIndex;
            }
            if(_loc3_ < _verticalScrollPosition)
            {
               verticalScrollPosition = _loc3_;
            }
         }
         else
         {
            bFinishArrowKeySelection = true;
         }
      }
      
      override protected function layoutEditor(param1:int, param2:int, param3:int, param4:int) : void
      {
         var _loc5_:int = rowMap[editedItemRenderer.name].indent;
         itemEditorInstance.move(param1 + _loc5_,param2);
         itemEditorInstance.setActualSize(param3 - _loc5_,param4);
      }
      
      public function isItemOpen(param1:Object) : Boolean
      {
         var _loc2_:String = itemToUID(param1);
         return _openItems[_loc2_] != null;
      }
      
      override mx_internal function addClipMask(param1:Boolean) : void
      {
         var _loc2_:EdgeMetrics = viewMetrics;
         if(horizontalScrollBar && horizontalScrollBar.visible)
         {
            _loc2_.bottom = _loc2_.bottom - horizontalScrollBar.minHeight;
         }
         if(verticalScrollBar && verticalScrollBar.visible)
         {
            _loc2_.right = _loc2_.right - verticalScrollBar.minWidth;
         }
         listContent.scrollRect = new Rectangle(0,0,unscaledWidth - _loc2_.left - _loc2_.right,listContent.heightExcludingOffsets);
      }
      
      private function collapseSelectedItems() : Array
      {
         var _loc3_:Object = null;
         var _loc4_:Array = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:Object = null;
         var _loc1_:ArrayCollection = new ArrayCollection(selectedItems);
         var _loc2_:int = 0;
         while(_loc2_ < selectedItems.length)
         {
            _loc3_ = selectedItems[_loc2_];
            _loc4_ = getParentStack(_loc3_);
            _loc5_ = 0;
            while(_loc5_ < _loc4_.length)
            {
               if(_loc1_.contains(_loc4_[_loc5_]))
               {
                  _loc6_ = _loc1_.getItemIndex(_loc3_);
                  _loc7_ = _loc1_.removeItemAt(_loc6_);
                  break;
               }
               _loc5_++;
            }
            _loc2_++;
         }
         return _loc1_.source;
      }
      
      override public function isItemVisible(param1:Object) : Boolean
      {
         var _loc3_:String = null;
         if(visibleData[itemToUID(param1)])
         {
            return true;
         }
         var _loc2_:Object = getParentItem(param1);
         if(_loc2_)
         {
            _loc3_ = itemToUID(_loc2_);
            if(visibleData[_loc3_] && _openItems[_loc3_])
            {
               return true;
            }
         }
         return false;
      }
      
      private function getIndexItem(param1:int) : Object
      {
         var _loc2_:IViewCursor = collection.createCursor();
         var _loc3_:int = param1;
         while(_loc2_.moveNext())
         {
            if(_loc3_ == 0)
            {
               return _loc2_.current;
            }
            _loc3_--;
         }
         return null;
      }
      
      private function seekPendingDuringDragResultHandler(param1:Object, param2:TreeSeekPending) : void
      {
         lastTreeSeekPending = null;
         if(lastDragEvent)
         {
            param2.retryFunction(param2.event);
         }
      }
      
      private function getChildIndexInParent(param1:Object, param2:Object) : int
      {
         var _loc4_:IViewCursor = null;
         var _loc5_:ICollectionView = null;
         var _loc3_:int = 0;
         if(!param1)
         {
            _loc4_ = ICollectionView(iterator.view).createCursor();
            while(!_loc4_.afterLast)
            {
               if(param2 === _loc4_.current)
               {
                  break;
               }
               _loc3_++;
               _loc4_.moveNext();
            }
         }
         else if(param1 != null && _dataDescriptor.isBranch(param1,iterator.view) && _dataDescriptor.hasChildren(param1,iterator.view))
         {
            _loc5_ = getChildren(param1,iterator.view);
            if(_loc5_.contains(param2))
            {
               _loc4_ = _loc5_.createCursor();
               while(!_loc4_.afterLast)
               {
                  if(param2 === _loc4_.current)
                  {
                     break;
                  }
                  _loc4_.moveNext();
                  _loc3_++;
               }
            }
         }
         return _loc3_;
      }
      
      override public function get dragMoveEnabled() : Boolean
      {
         return _dragMoveEnabled;
      }
      
      override protected function mouseDownHandler(param1:MouseEvent) : void
      {
         if(!tween)
         {
            super.mouseDownHandler(param1);
         }
      }
      
      override public function calculateDropIndex(param1:DragEvent = null) : int
      {
         if(param1)
         {
            updateDropData(param1);
         }
         return _dropData.rowIndex;
      }
      
      override protected function keyDownHandler(param1:KeyboardEvent) : void
      {
         var _loc2_:ListEvent = null;
         var _loc3_:Point = null;
         var _loc5_:IListItemRenderer = null;
         var _loc6_:* = false;
         var _loc7_:Object = null;
         var _loc8_:ICollectionView = null;
         var _loc9_:IViewCursor = null;
         if(isOpening)
         {
            param1.stopImmediatePropagation();
            return;
         }
         if(itemEditorInstance)
         {
            return;
         }
         var _loc4_:Object = selectedItem;
         if(param1.ctrlKey)
         {
            super.keyDownHandler(param1);
         }
         else if(param1.keyCode == Keyboard.SPACE)
         {
            if(caretIndex != selectedIndex)
            {
               _loc5_ = indexToItemRenderer(caretIndex);
               if(_loc5_)
               {
                  drawItem(_loc5_);
               }
               caretIndex = selectedIndex;
            }
            if(isBranch(_loc4_))
            {
               _loc6_ = !isItemOpen(_loc4_);
               dispatchTreeEvent(TreeEvent.ITEM_OPENING,_loc4_,null,param1,_loc6_,true,true);
            }
            param1.stopImmediatePropagation();
         }
         else if(param1.keyCode == Keyboard.LEFT)
         {
            if(isItemOpen(_loc4_))
            {
               dispatchTreeEvent(TreeEvent.ITEM_OPENING,_loc4_,null,param1,false,true,true);
            }
            else
            {
               _loc7_ = getParentItem(_loc4_);
               if(_loc7_)
               {
                  proposedSelectedItem = _loc7_;
                  finishArrowKeySelection();
               }
            }
            param1.stopImmediatePropagation();
         }
         else if(param1.keyCode == Keyboard.RIGHT)
         {
            if(isBranch(_loc4_))
            {
               if(isItemOpen(_loc4_))
               {
                  if(_loc4_)
                  {
                     _loc8_ = getChildren(_loc4_,iterator.view);
                     if(_loc8_)
                     {
                        _loc9_ = _loc8_.createCursor();
                        if(_loc9_.current)
                        {
                           proposedSelectedItem = _loc9_.current;
                        }
                     }
                     else
                     {
                        proposedSelectedItem = null;
                     }
                  }
                  else
                  {
                     selectedItem = proposedSelectedItem = null;
                  }
                  finishArrowKeySelection();
               }
               else
               {
                  dispatchTreeEvent(TreeEvent.ITEM_OPENING,_loc4_,null,param1,true,true,true);
               }
            }
            param1.stopImmediatePropagation();
         }
         else if(param1.keyCode == Keyboard.NUMPAD_MULTIPLY)
         {
            expandChildrenOf(_loc4_,!isItemOpen(_loc4_));
         }
         else if(param1.keyCode == Keyboard.NUMPAD_ADD)
         {
            if(isBranch(_loc4_))
            {
               if(!isItemOpen(_loc4_))
               {
                  dispatchTreeEvent(TreeEvent.ITEM_OPENING,_loc4_,null,param1,true,true,true);
               }
            }
         }
         else if(param1.keyCode == Keyboard.NUMPAD_SUBTRACT)
         {
            if(isItemOpen(_loc4_))
            {
               dispatchTreeEvent(TreeEvent.ITEM_OPENING,_loc4_,null,param1,false,true,true);
            }
         }
         else
         {
            super.keyDownHandler(param1);
         }
      }
      
      mx_internal function onTweenEnd(param1:Object) : void
      {
         var _loc2_:int = 0;
         var _loc3_:* = undefined;
         var _loc4_:IDropInListItemRenderer = null;
         var _loc6_:* = undefined;
         var _loc7_:Object = null;
         var _loc8_:Array = null;
         var _loc9_:int = 0;
         var _loc10_:DisplayObject = null;
         UIComponent.resumeBackgroundProcessing();
         onTweenUpdate(param1);
         var _loc5_:int = listItems.length;
         isOpening = false;
         if(collection)
         {
            _loc8_ = !!opening?buildUpCollectionEvents(true):buildUpCollectionEvents(false);
            _loc2_ = 0;
            while(_loc2_ < _loc8_.length)
            {
               collection.dispatchEvent(_loc8_[_loc2_]);
               _loc2_++;
            }
         }
         if(opening)
         {
            _loc9_ = -1;
            _loc2_ = rowIndex;
            while(_loc2_ < _loc5_)
            {
               if(listItems[_loc2_].length)
               {
                  _loc3_ = listItems[_loc2_][0];
                  _loc10_ = _loc3_.mask;
                  if(_loc10_)
                  {
                     listContent.removeChild(_loc10_);
                     _loc3_.mask = null;
                  }
                  rowMap[_loc3_.name].rowIndex = _loc2_;
                  if(_loc3_ is IDropInListItemRenderer)
                  {
                     _loc4_ = IDropInListItemRenderer(_loc3_);
                     if(_loc4_.listData)
                     {
                        _loc4_.listData.rowIndex = _loc2_;
                        _loc4_.listData = _loc4_.listData;
                     }
                  }
                  if(_loc3_.y > listContent.height)
                  {
                     addToFreeItemRenderers(_loc3_);
                     _loc6_ = itemToUID(_loc3_.data);
                     if(selectionIndicators[_loc6_])
                     {
                        _loc7_ = selectionIndicators[_loc6_];
                        if(_loc7_)
                        {
                           _loc10_ = _loc7_.mask;
                           if(_loc10_)
                           {
                              listContent.removeChild(_loc10_);
                              _loc7_.mask = null;
                           }
                        }
                        removeIndicators(_loc6_);
                     }
                     delete rowMap[_loc3_.name];
                     if(_loc9_ < 0)
                     {
                        _loc9_ = _loc2_;
                     }
                  }
               }
               else if(rowInfo[_loc2_].y >= listContent.height)
               {
                  if(_loc9_ < 0)
                  {
                     _loc9_ = _loc2_;
                  }
               }
               _loc2_++;
            }
            if(_loc9_ >= 0)
            {
               rowInfo.splice(_loc9_);
               listItems.splice(_loc9_);
            }
         }
         else
         {
            _loc2_ = 0;
            while(_loc2_ < rowList.length)
            {
               _loc10_ = rowList[_loc2_].item.mask;
               if(_loc10_)
               {
                  listContent.removeChild(_loc10_);
                  rowList[_loc2_].item.mask = null;
               }
               addToFreeItemRenderers(rowList[_loc2_].item);
               _loc6_ = itemToUID(rowList[_loc2_].item.data);
               if(selectionIndicators[_loc6_])
               {
                  _loc7_ = selectionIndicators[_loc6_];
                  if(_loc7_)
                  {
                     _loc10_ = _loc7_.mask;
                     if(_loc10_)
                     {
                        listContent.removeChild(_loc10_);
                        _loc7_.mask = null;
                     }
                  }
                  removeIndicators(_loc6_);
               }
               delete rowMap[rowList[_loc2_].item.name];
               _loc2_++;
            }
            _loc2_ = rowIndex;
            while(_loc2_ < _loc5_)
            {
               if(listItems[_loc2_].length)
               {
                  _loc3_ = listItems[_loc2_][0];
                  rowMap[_loc3_.name].rowIndex = _loc2_;
                  if(_loc3_ is IDropInListItemRenderer)
                  {
                     _loc4_ = IDropInListItemRenderer(_loc3_);
                     if(_loc4_.listData)
                     {
                        _loc4_.listData.rowIndex = _loc2_;
                        _loc4_.listData = _loc4_.listData;
                     }
                  }
               }
               _loc2_++;
            }
         }
         if(eventAfterTween)
         {
            dispatchTreeEvent(!!isItemOpen(eventAfterTween)?TreeEvent.ITEM_OPEN:TreeEvent.ITEM_CLOSE,eventAfterTween,visibleData[itemToUID(eventAfterTween)],lastUserInteraction);
            lastUserInteraction = null;
            eventAfterTween = false;
         }
         itemsSizeChanged = true;
         invalidateDisplayList();
         tween = null;
      }
      
      override protected function adjustAfterRemove(param1:Array, param2:int, param3:Boolean) : Boolean
      {
         var _loc4_:int = selectedItems.length;
         var _loc5_:Boolean = param3;
         var _loc6_:int = param1.length;
         if(_selectedIndex > param2)
         {
            _selectedIndex = _selectedIndex - _loc6_;
            _loc5_ = true;
         }
         if(bSelectedItemRemoved && _loc4_ < 1)
         {
            _selectedIndex = getItemIndex(expandedItem);
            _loc5_ = true;
            bSelectionChanged = true;
            bSelectedIndexChanged = true;
            invalidateDisplayList();
         }
         return _loc5_;
      }
      
      public function set dataDescriptor(param1:ITreeDataDescriptor) : void
      {
         _dataDescriptor = param1;
      }
      
      private function isBranch(param1:Object) : Boolean
      {
         if(param1 != null)
         {
            return _dataDescriptor.isBranch(param1,iterator.view);
         }
         return false;
      }
      
      private function getVisibleChildrenCount(param1:Object) : int
      {
         var _loc4_:Object = null;
         var _loc5_:IViewCursor = null;
         var _loc2_:int = 0;
         if(param1 == null)
         {
            return _loc2_;
         }
         var _loc3_:String = itemToUID(param1);
         if(_openItems[_loc3_] && _dataDescriptor.isBranch(param1,iterator.view) && _dataDescriptor.hasChildren(param1,iterator.view))
         {
            _loc4_ = getChildren(param1,iterator.view);
         }
         if(_loc4_ != null)
         {
            _loc5_ = _loc4_.createCursor();
            while(!_loc5_.afterLast)
            {
               _loc2_++;
               _loc3_ = itemToUID(_loc5_.current);
               if(_openItems[_loc3_])
               {
                  _loc2_ = _loc2_ + getVisibleChildrenCount(_loc5_.current);
               }
               _loc5_.moveNext();
            }
         }
         return _loc2_;
      }
      
      mx_internal function getChildren(param1:Object, param2:Object) : ICollectionView
      {
         var _loc3_:ICollectionView = _dataDescriptor.getChildren(param1,param2);
         return _loc3_;
      }
      
      public function expandChildrenOf(param1:Object, param2:Boolean) : void
      {
         var _loc3_:ICollectionView = null;
         var _loc4_:IViewCursor = null;
         if(iterator == null)
         {
            return;
         }
         if(isBranch(param1))
         {
            dispatchTreeEvent(TreeEvent.ITEM_OPENING,param1,null,null,param2,false,true);
            if(param1 != null && _dataDescriptor.isBranch(param1,iterator.view) && _dataDescriptor.hasChildren(param1,iterator.view))
            {
               _loc3_ = getChildren(param1,iterator.view);
            }
            if(_loc3_)
            {
               _loc4_ = _loc3_.createCursor();
               while(!_loc4_.afterLast)
               {
                  if(isBranch(_loc4_.current))
                  {
                     expandChildrenOf(_loc4_.current,param2);
                  }
                  _loc4_.moveNext();
               }
            }
         }
      }
      
      [Bindable("collectionChange")]
      override public function set dataProvider(param1:Object) : void
      {
         var _loc2_:XMLList = null;
         var _loc3_:Array = null;
         if(_rootModel)
         {
            _rootModel.removeEventListener(CollectionEvent.COLLECTION_CHANGE,collectionChangeHandler);
         }
         if(typeof param1 == "string")
         {
            param1 = new XML(param1);
         }
         else if(param1 is XMLNode)
         {
            param1 = new XML(XMLNode(param1).toString());
         }
         else if(param1 is XMLList)
         {
            param1 = new XMLListCollection(param1 as XMLList);
         }
         if(param1 is XML)
         {
            _hasRoot = true;
            _loc2_ = new XMLList();
            _loc2_ = _loc2_ + param1;
            _rootModel = new XMLListCollection(_loc2_);
         }
         else if(param1 is ICollectionView)
         {
            _rootModel = ICollectionView(param1);
            if(_rootModel.length == 1)
            {
               _hasRoot = true;
            }
         }
         else if(param1 is Array)
         {
            _rootModel = new ArrayCollection(param1 as Array);
         }
         else if(param1 is Object)
         {
            _hasRoot = true;
            _loc3_ = [];
            _loc3_.push(param1);
            _rootModel = new ArrayCollection(_loc3_);
         }
         else
         {
            _rootModel = new ArrayCollection();
         }
         dataProviderChanged = true;
         invalidateProperties();
      }
      
      public function get showRoot() : Boolean
      {
         return _showRoot;
      }
      
      override protected function collectionChangeHandler(param1:Event) : void
      {
         var _loc2_:Object = null;
         var _loc3_:Object = null;
         var _loc4_:CollectionEvent = null;
         if(iterator == null)
         {
            return;
         }
         if(param1 is CollectionEvent)
         {
            _loc4_ = CollectionEvent(param1);
            if(_loc4_.kind == CollectionEventKind.EXPAND)
            {
               param1.stopPropagation();
            }
            if(_loc4_.kind == CollectionEventKind.UPDATE)
            {
               param1.stopPropagation();
               itemsSizeChanged = true;
               invalidateDisplayList();
            }
            else
            {
               super.collectionChangeHandler(param1);
            }
         }
      }
      
      override protected function makeListData(param1:Object, param2:String, param3:int) : BaseListData
      {
         var _loc4_:TreeListData = new TreeListData(itemToLabel(param1),param2,this,param3);
         initListData(param1,_loc4_);
         return _loc4_;
      }
      
      override public function itemToIcon(param1:Object) : Class
      {
         var icon:* = undefined;
         var item:Object = param1;
         if(item == null)
         {
            return null;
         }
         var open:Boolean = isItemOpen(item);
         var branch:Boolean = isBranch(item);
         var uid:String = itemToUID(item);
         var iconClass:Class = itemIcons && itemIcons[uid]?itemIcons[uid][!!open?"iconID2":"iconID"]:null;
         if(iconClass)
         {
            return iconClass;
         }
         if(iconFunction != null)
         {
            return iconFunction(item);
         }
         if(branch)
         {
            return getStyle(!!open?"folderOpenIcon":"folderClosedIcon");
         }
         if(item is XML)
         {
            try
            {
               if(item[iconField].length() != 0)
               {
                  icon = String(item[iconField]);
               }
            }
            catch(e:Error)
            {
            }
         }
         else if(item is Object)
         {
            try
            {
               if(iconField && item[iconField])
               {
                  icon = item[iconField];
               }
               else if(item.icon)
               {
                  icon = item.icon;
               }
            }
            catch(e:Error)
            {
            }
         }
         if(icon == null)
         {
            icon = getStyle("defaultLeafIcon");
         }
         if(icon is Class)
         {
            return icon;
         }
         if(icon is String)
         {
            iconClass = Class(systemManager.getDefinitionByName(String(icon)));
            if(iconClass)
            {
               return iconClass;
            }
            return document[icon];
         }
         return Class(icon);
      }
      
      public function get openItems() : Object
      {
         var _loc2_:* = undefined;
         var _loc1_:Array = [];
         for each(_loc2_ in _openItems)
         {
            _loc1_.push(_loc2_);
         }
         return _loc1_;
      }
      
      override mx_internal function selectionDataPendingResultHandler(param1:Object, param2:ListBaseSelectionDataPending) : void
      {
         super.selectionDataPendingResultHandler(param1,param2);
         if(bFinishArrowKeySelection && selectedItem === proposedSelectedItem)
         {
            finishArrowKeySelection();
         }
      }
      
      override protected function initializeAccessibility() : void
      {
         if(Tree.createAccessibilityImplementation != null)
         {
            Tree.createAccessibilityImplementation(this);
         }
      }
      
      override protected function mouseOutHandler(param1:MouseEvent) : void
      {
         if(!tween)
         {
            super.mouseOutHandler(param1);
         }
      }
      
      public function get hasRoot() : Boolean
      {
         return _hasRoot;
      }
      
      override protected function dragEnterHandler(param1:DragEvent) : void
      {
         var event:DragEvent = param1;
         if(event.isDefaultPrevented())
         {
            return;
         }
         lastDragEvent = event;
         haveItemIndices = false;
         try
         {
            if(iteratorValid && event.dragSource.hasFormat("treeItems"))
            {
               DragManager.acceptDragDrop(this);
               DragManager.showFeedback(!!event.ctrlKey?DragManager.COPY:DragManager.MOVE);
               showDropFeedback(event);
               return;
            }
         }
         catch(e:ItemPendingError)
         {
            if(!lastTreeSeekPending)
            {
               lastTreeSeekPending = new TreeSeekPending(event,dragEnterHandler);
               e.addResponder(new ItemResponder(seekPendingDuringDragResultHandler,seekPendingDuringDragFailureHandler,lastTreeSeekPending));
            }
         }
         catch(e1:Error)
         {
         }
         hideDropFeedback(event);
         DragManager.showFeedback(DragManager.NONE);
      }
      
      protected function initListData(param1:Object, param2:TreeListData) : void
      {
         if(param1 == null)
         {
            return;
         }
         var _loc3_:Boolean = isItemOpen(param1);
         var _loc4_:Boolean = isBranch(param1);
         var _loc5_:String = itemToUID(param1);
         param2.disclosureIcon = getStyle(!!_loc3_?"disclosureOpenIcon":"disclosureClosedIcon");
         param2.open = _loc3_;
         param2.hasChildren = _loc4_;
         param2.depth = getItemDepth(param1,param2.rowIndex);
         param2.indent = (param2.depth - 1) * getStyle("indentation");
         param2.item = param1;
         param2.icon = itemToIcon(param1);
      }
      
      private function getIndent() : Number
      {
         var _loc2_:* = null;
         var _loc1_:Number = 0;
         for(_loc2_ in _openItems)
         {
            _loc1_ = Math.max(getParentStack(_openItems[_loc2_]).length + 1,_loc1_);
         }
         return _loc1_ * getStyle("indentation");
      }
      
      public function setItemIcon(param1:Object, param2:Class, param3:Class) : void
      {
         if(!itemIcons)
         {
            itemIcons = {};
         }
         if(!param3)
         {
            param3 = param2;
         }
         itemIcons[itemToUID(param1)] = {
            "iconID":param2,
            "iconID2":param3
         };
         itemsSizeChanged = true;
         invalidateDisplayList();
      }
      
      public function set firstVisibleItem(param1:Object) : void
      {
         var _loc2_:int = getItemIndex(param1);
         if(_loc2_ < 0)
         {
            return;
         }
         verticalScrollPosition = Math.min(maxVerticalScrollPosition,_loc2_);
         dispatchEvent(new Event("firstVisibleItemChanged"));
      }
      
      override protected function mouseWheelHandler(param1:MouseEvent) : void
      {
         if(!tween)
         {
            super.mouseWheelHandler(param1);
         }
      }
      
      mx_internal function onTweenUpdate(param1:Object) : void
      {
         var _loc2_:IFlexDisplayObject = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Sprite = null;
         _loc3_ = listItems.length;
         _loc4_ = rowIndex;
         while(_loc4_ < _loc3_)
         {
            if(listItems[_loc4_].length)
            {
               _loc2_ = IFlexDisplayObject(listItems[_loc4_][0]);
               _loc6_ = _loc2_.y;
               _loc2_.move(_loc2_.x,rowInfo[_loc4_].itemOldY + param1);
               _loc5_ = _loc2_.y - _loc6_;
            }
            _loc7_ = selectionIndicators[rowInfo[_loc4_].uid];
            rowInfo[_loc4_].y = rowInfo[_loc4_].y + _loc5_;
            if(_loc7_)
            {
               _loc7_.y = _loc7_.y + _loc5_;
            }
            _loc4_++;
         }
         _loc3_ = rowList.length;
         _loc4_ = 0;
         while(_loc4_ < _loc3_)
         {
            _loc7_ = null;
            _loc2_ = IFlexDisplayObject(rowList[_loc4_].item);
            if(rowMap[_loc2_.name] != null)
            {
               _loc7_ = selectionIndicators[BaseListData(rowMap[_loc2_.name]).uid];
            }
            _loc6_ = _loc2_.y;
            _loc2_.move(_loc2_.x,rowList[_loc4_].itemOldY + param1);
            _loc5_ = _loc2_.y - _loc6_;
            if(_loc7_)
            {
               _loc7_.y = _loc7_.y + _loc5_;
            }
            _loc4_++;
         }
      }
      
      override public function set dragMoveEnabled(param1:Boolean) : void
      {
         _dragMoveEnabled = param1;
      }
      
      public function get dataDescriptor() : ITreeDataDescriptor
      {
         return ITreeDataDescriptor(_dataDescriptor);
      }
      
      override public function get dataProvider() : Object
      {
         if(_rootModel)
         {
            return _rootModel;
         }
         return null;
      }
      
      override public function set maxHorizontalScrollPosition(param1:Number) : void
      {
         _userMaxHorizontalScrollPosition = param1;
         param1 = param1 + getIndent();
         super.maxHorizontalScrollPosition = param1;
      }
      
      override protected function scrollHandler(param1:Event) : void
      {
         if(isOpening)
         {
            return;
         }
         if(param1 is ScrollEvent)
         {
            super.scrollHandler(param1);
         }
      }
      
      override protected function addDragData(param1:Object) : void
      {
         param1.addHandler(collapseSelectedItems,"treeItems");
      }
      
      mx_internal function getItemDepth(param1:Object, param2:int) : int
      {
         if(!collection)
         {
            return 0;
         }
         if(!iterator)
         {
            listContent.iterator = collection.createCursor();
         }
         if(iterator.current == param1)
         {
            return getCurrentCursorDepth();
         }
         var _loc3_:CursorBookmark = iterator.bookmark;
         iterator.seek(_loc3_,param2);
         var _loc4_:int = getCurrentCursorDepth();
         iterator.seek(_loc3_,0);
         return _loc4_;
      }
      
      override public function styleChanged(param1:String) : void
      {
         if(param1 == null || param1 == "styleName" || IS_NEW_ROW_STYLE[param1])
         {
            itemsSizeChanged = true;
            invalidateDisplayList();
         }
         super.styleChanged(param1);
      }
      
      mx_internal function expandItemHandler(param1:TreeEvent) : void
      {
         if(param1.isDefaultPrevented())
         {
            return;
         }
         if(param1.type == TreeEvent.ITEM_OPENING)
         {
            expandItem(param1.item,param1.opening,param1.animate,param1.dispatchEvent,param1.triggerEvent);
         }
      }
      
      override protected function mouseDoubleClickHandler(param1:MouseEvent) : void
      {
         if(!tween)
         {
            super.mouseDoubleClickHandler(param1);
         }
      }
      
      mx_internal function addChildItem(param1:Object, param2:Object, param3:Number) : Boolean
      {
         return _dataDescriptor.addChildAt(param1,param2,param3,iterator.view);
      }
      
      private function getParentStack(param1:Object) : Array
      {
         var _loc2_:Array = [];
         if(param1 == null)
         {
            return _loc2_;
         }
         var _loc3_:* = getParentItem(param1);
         while(_loc3_)
         {
            _loc2_.push(_loc3_);
            _loc3_ = getParentItem(_loc3_);
         }
         return _loc2_;
      }
      
      public function getItemIndex(param1:Object) : int
      {
         var _loc2_:IViewCursor = collection.createCursor();
         var _loc3_:int = 0;
         while(_loc2_.current !== param1)
         {
            _loc3_++;
            if(!_loc2_.moveNext())
            {
               break;
            }
         }
         _loc2_.seek(CursorBookmark.FIRST,0);
         return _loc3_;
      }
      
      public function expandItem(param1:Object, param2:Boolean, param3:Boolean = false, param4:Boolean = false, param5:Event = null) : void
      {
         var i:int = 0;
         var newRowIndex:int = 0;
         var rowData:BaseListData = null;
         var tmpMask:DisplayObject = null;
         var tmpRowInfo:Object = null;
         var row:Array = null;
         var n:int = 0;
         var eventArr:Array = null;
         var renderer:IListItemRenderer = null;
         var xx:Number = NaN;
         var ww:Number = NaN;
         var yy:Number = NaN;
         var hh:Number = NaN;
         var delta:int = 0;
         var maxDist:Number = NaN;
         var oE:Function = null;
         var di:IDropInListItemRenderer = null;
         var treeListData:TreeListData = null;
         var data:Object = null;
         var referenceRowInfo:ListRowInfo = null;
         var rh:Number = NaN;
         var more:Boolean = false;
         var valid:Boolean = false;
         var startY:Number = NaN;
         var maskY:Number = NaN;
         var maskX:Number = NaN;
         var indicator:Object = null;
         var item:Object = param1;
         var open:Boolean = param2;
         var animate:Boolean = param3;
         var dispatchEvent:Boolean = param4;
         var cause:Event = param5;
         if(iterator == null)
         {
            return;
         }
         if(cause)
         {
            lastUserInteraction = cause;
         }
         expandedItem = item;
         listContent.allowItemSizeChangeNotification = false;
         var bSelected:Boolean = false;
         var bHighlight:Boolean = false;
         var bCaret:Boolean = false;
         var uid:String = itemToUID(item);
         if(!isBranch(item) || isItemOpen(item) == open || isOpening)
         {
            return;
         }
         if(itemEditorInstance)
         {
            endEdit(ListEventReason.OTHER);
         }
         oldLength = collectionLength;
         var bookmark:CursorBookmark = iterator.bookmark;
         var event:CollectionEvent = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE,false,true,CollectionEventKind.EXPAND);
         event.items = [item];
         if(open)
         {
            _openItems[uid] = item;
            collection.dispatchEvent(event);
            rowsTweened = Math.abs(oldLength - collection.length);
         }
         else
         {
            delete _openItems[uid];
            collection.dispatchEvent(event);
            rowsTweened = Math.abs(oldLength - collection.length);
         }
         if(isItemVisible(item))
         {
            if(visibleData[uid])
            {
               n = listItems.length;
               rowIndex = 0;
               while(rowIndex < n)
               {
                  if(rowInfo[rowIndex].uid == uid)
                  {
                     rowIndex++;
                     break;
                  }
                  rowIndex++;
               }
            }
            var rC:int = listItems.length;
            var rowsToMove:int = rowsTweened;
            var dur:Number = getStyle("openDuration");
            if(animate && rowIndex < rC && rowsToMove > 0 && rowsToMove < 20 && dur != 0)
            {
               if(tween)
               {
                  tween.endTween();
               }
               renderer = listItems[rowIndex - 1][0];
               if(renderer is IDropInListItemRenderer)
               {
                  di = IDropInListItemRenderer(renderer);
                  treeListData = TreeListData(di.listData);
                  treeListData = TreeListData(makeListData(treeListData.item,treeListData.uid,treeListData.rowIndex));
                  di.listData = treeListData;
                  renderer.data = renderer.data;
               }
               opening = open;
               isOpening = true;
               maskList = [];
               rowList = [];
               xx = getStyle("paddingLeft") - horizontalScrollPosition;
               ww = renderer.width;
               yy = 0;
               delta = rowIndex;
               maxDist = 0;
               if(open)
               {
                  newRowIndex = rowIndex;
                  maxDist = listContent.height - rowInfo[rowIndex].y;
                  iterator.seek(CursorBookmark.CURRENT,delta);
                  i = 0;
                  while(i < rowsToMove && yy < maxDist)
                  {
                     data = iterator.current;
                     if(freeItemRenderers.length)
                     {
                        renderer = freeItemRenderers.pop();
                     }
                     else
                     {
                        renderer = createItemRenderer(data);
                        renderer.owner = this;
                        renderer.styleName = listContent;
                        listContent.addChild(DisplayObject(renderer));
                     }
                     uid = itemToUID(data);
                     rowData = makeListData(data,uid,rowIndex + i);
                     rowMap[renderer.name] = rowData;
                     if(renderer is IDropInListItemRenderer)
                     {
                        IDropInListItemRenderer(renderer).listData = !!data?rowData:null;
                     }
                     renderer.data = data;
                     renderer.enabled = enabled;
                     if(data)
                     {
                        visibleData[uid] = renderer;
                        renderer.visible = true;
                     }
                     else
                     {
                        renderer.visible = false;
                     }
                     renderer.explicitWidth = ww;
                     if(renderer is IInvalidating && (wordWrapChanged || variableRowHeight))
                     {
                        IInvalidating(renderer).invalidateSize();
                     }
                     UIComponentGlobals.layoutManager.validateClient(renderer,true);
                     hh = Math.ceil(!!variableRowHeight?Number(renderer.getExplicitOrMeasuredHeight() + cachedPaddingTop + cachedPaddingBottom):Number(rowHeight));
                     rh = renderer.getExplicitOrMeasuredHeight();
                     renderer.setActualSize(ww,!!variableRowHeight?Number(rh):Number(rowHeight - cachedPaddingTop - cachedPaddingBottom));
                     renderer.move(xx,yy + cachedPaddingTop);
                     bSelected = selectedData[uid] != null;
                     bHighlight = highlightUID == uid;
                     bCaret = caretUID == uid;
                     tmpRowInfo = new ListRowInfo(yy,hh,uid,data);
                     if(data)
                     {
                        drawItem(renderer,bSelected,bHighlight,bCaret);
                     }
                     yy = yy + hh;
                     rowInfo.splice(rowIndex + i,0,tmpRowInfo);
                     row = [];
                     row.push(renderer);
                     listItems.splice(rowIndex + i,0,row);
                     if(i < rowsToMove - 1)
                     {
                        try
                        {
                           iterator.moveNext();
                        }
                        catch(e:ItemPendingError)
                        {
                           rowsToMove = i + 1;
                           break;
                        }
                     }
                     i++;
                  }
                  rowsTweened = i;
                  referenceRowInfo = rowInfo[rowIndex + rowsTweened];
                  i = 0;
                  while(i < rowsTweened)
                  {
                     renderer = listItems[rowIndex + i][0];
                     renderer.move(renderer.x,renderer.y - (yy - referenceRowInfo.y));
                     rowInfo[rowIndex + i].y = rowInfo[rowIndex + i].y - (yy - referenceRowInfo.y);
                     tmpMask = makeMask();
                     tmpMask.x = xx;
                     tmpMask.y = referenceRowInfo.y;
                     tmpMask.width = ww;
                     tmpMask.height = yy;
                     listItems[rowIndex + i][0].mask = tmpMask;
                     i++;
                  }
               }
               else
               {
                  more = true;
                  valid = true;
                  startY = yy = rowInfo[listItems.length - 1].y + rowInfo[listItems.length - 1].height;
                  i = rowIndex;
                  while(i < rowIndex + rowsToMove && i < rC)
                  {
                     maxDist = maxDist + rowInfo[i].height;
                     rowList.push({"item":listItems[i][0]});
                     tmpMask = makeMask();
                     tmpMask.x = xx;
                     tmpMask.y = listItems[rowIndex][0].y;
                     tmpMask.width = ww;
                     tmpMask.height = maxDist;
                     listItems[i][0].mask = tmpMask;
                     i++;
                  }
                  rowsToMove = i - rowIndex;
                  rowInfo.splice(rowIndex,rowsToMove);
                  listItems.splice(rowIndex,rowsToMove);
                  iterator.seek(CursorBookmark.CURRENT,listItems.length);
                  more = iterator != null && !iterator.afterLast && iteratorValid;
                  maxDist = maxDist + yy;
                  i = 0;
                  while(i < rowsToMove && yy < maxDist)
                  {
                     uid = null;
                     data = null;
                     renderer = null;
                     valid = more;
                     data = !!more?iterator.current:null;
                     if(valid)
                     {
                        if(freeItemRenderers.length)
                        {
                           renderer = freeItemRenderers.pop();
                        }
                        else
                        {
                           renderer = createItemRenderer(data);
                           renderer.owner = this;
                           renderer.styleName = listContent;
                           listContent.addChild(DisplayObject(renderer));
                        }
                        uid = itemToUID(data);
                        rowData = makeListData(data,uid,rC - rowsToMove + i);
                        rowMap[renderer.name] = rowData;
                        if(renderer is IDropInListItemRenderer)
                        {
                           IDropInListItemRenderer(renderer).listData = !!data?rowData:null;
                        }
                        renderer.data = data;
                        renderer.enabled = enabled;
                        if(data)
                        {
                           visibleData[uid] = renderer;
                           renderer.visible = true;
                        }
                        else
                        {
                           renderer.visible = false;
                        }
                        renderer.explicitWidth = ww;
                        if(renderer is IInvalidating && (wordWrapChanged || variableRowHeight))
                        {
                           IInvalidating(renderer).invalidateSize();
                        }
                        UIComponentGlobals.layoutManager.validateClient(renderer,true);
                        hh = Math.ceil(!!variableRowHeight?Number(renderer.getExplicitOrMeasuredHeight() + cachedPaddingTop + cachedPaddingBottom):Number(rowHeight));
                        rh = renderer.getExplicitOrMeasuredHeight();
                        renderer.setActualSize(ww,!!variableRowHeight?Number(rh):Number(rowHeight - cachedPaddingTop - cachedPaddingBottom));
                        renderer.move(xx,yy + cachedPaddingTop);
                     }
                     else if(!variableRowHeight)
                     {
                        hh = rowIndex + i > 0?Number(rowInfo[rowIndex + i - 1].height):Number(rowHeight);
                     }
                     else if(rowList[i])
                     {
                        hh = Math.ceil(rowList[i].item.getExplicitOrMeasuredHeight() + cachedPaddingTop + cachedPaddingBottom);
                     }
                     else
                     {
                        hh = rowHeight;
                     }
                     bSelected = selectedData[uid] != null;
                     bHighlight = highlightUID == uid;
                     bCaret = caretUID == uid;
                     tmpRowInfo = new ListRowInfo(yy,hh,uid,data);
                     rowInfo.push(tmpRowInfo);
                     if(data)
                     {
                        drawItem(renderer,bSelected,bHighlight,bCaret);
                     }
                     yy = yy + hh;
                     if(valid)
                     {
                        row = [];
                        row.push(renderer);
                        listItems.push(row);
                     }
                     else
                     {
                        listItems.push([]);
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
                  maskY = rowList[0].item.y - getStyle("paddingTop");
                  maskX = rowList[0].item.x - getStyle("paddingLeft");
                  i = 0;
                  while(i < rowList.length)
                  {
                     indicator = selectionIndicators[itemToUID(rowList[i].item.data)];
                     if(indicator)
                     {
                        tmpMask = makeMask();
                        tmpMask.x = maskX;
                        tmpMask.y = maskY;
                        tmpMask.width = rowList[i].item.width + getStyle("paddingLeft") + getStyle("paddingRight");
                        tmpMask.height = rowList[i].item.y + rowList[i].item.height + getStyle("paddingTop") + getStyle("paddingBottom") - maskY;
                        selectionIndicators[itemToUID(rowList[i].item.data)].mask = tmpMask;
                     }
                     i++;
                  }
               }
               iterator.seek(bookmark,0);
               rC = rowList.length;
               i = 0;
               while(i < rC)
               {
                  rowList[i].itemOldY = rowList[i].item.y;
                  i++;
               }
               rC = listItems.length;
               i = rowIndex;
               while(i < rC)
               {
                  if(listItems[i].length)
                  {
                     rowInfo[i].itemOldY = listItems[i][0].y;
                  }
                  rowInfo[i].oldY = rowInfo[i].y;
                  i++;
               }
               dur = dur * Math.max(rowsToMove / 5,1);
               if(dispatchEvent)
               {
                  eventAfterTween = item;
               }
               tween = new Tween(this,0,!!open?yy:startY - yy,dur,5);
               oE = getStyle("openEasingFunction") as Function;
               if(oE != null)
               {
                  tween.easingFunction = oE;
               }
               UIComponent.suspendBackgroundProcessing();
               UIComponentGlobals.layoutManager.validateNow();
            }
            else
            {
               if(dispatchEvent)
               {
                  dispatchTreeEvent(!!open?TreeEvent.ITEM_OPEN:TreeEvent.ITEM_CLOSE,item,visibleData[itemToUID(item)],lastUserInteraction);
                  lastUserInteraction = null;
               }
               itemsSizeChanged = true;
               invalidateDisplayList();
            }
            if(!wordWrap && initialized)
            {
               super.maxHorizontalScrollPosition = _userMaxHorizontalScrollPosition > 0?Number(_userMaxHorizontalScrollPosition + getIndent()):Number(super.maxHorizontalScrollPosition);
            }
            listContent.allowItemSizeChangeNotification = variableRowHeight;
            return;
         }
         eventArr = !!open?buildUpCollectionEvents(true):buildUpCollectionEvents(false);
         i = 0;
         while(i < eventArr.length)
         {
            collection.dispatchEvent(eventArr[i]);
            i++;
         }
      }
      
      override protected function commitProperties() : void
      {
         var _loc1_:ICollectionView = null;
         var _loc2_:* = undefined;
         if(showRootChanged)
         {
            if(!_hasRoot)
            {
               showRootChanged = false;
            }
         }
         if(dataProviderChanged || showRootChanged || openItemsChanged)
         {
            dataProviderChanged = false;
            showRootChanged = false;
            if(!openItemsChanged)
            {
               _openItems = {};
            }
            if(_rootModel && !_showRoot && _hasRoot)
            {
               _loc2_ = _rootModel.createCursor().current;
               if(_loc2_ != null && _dataDescriptor.isBranch(_loc2_,_rootModel) && _dataDescriptor.hasChildren(_loc2_,_rootModel))
               {
                  _loc1_ = getChildren(_loc2_,_rootModel);
               }
            }
            if(_rootModel)
            {
               super.dataProvider = wrappedCollection = _dataDescriptor is ITreeDataDescriptor2?ITreeDataDescriptor2(_dataDescriptor).getHierarchicalCollectionAdaptor(_loc1_ != null?_loc1_:_rootModel,itemToUID,_openItems):new HierarchicalCollectionView(_loc1_ != null?_loc1_:_rootModel,_dataDescriptor,itemToUID,_openItems);
               wrappedCollection.addEventListener(CollectionEvent.COLLECTION_CHANGE,collectionChangeHandler,false,EventPriority.DEFAULT_HANDLER,true);
            }
            else
            {
               super.dataProvider = null;
            }
         }
         super.commitProperties();
      }
      
      public function getParentItem(param1:Object) : *
      {
         if(param1 == null)
         {
            return null;
         }
         if(param1 && collection)
         {
            if(_dataDescriptor is ITreeDataDescriptor2)
            {
               return ITreeDataDescriptor2(_dataDescriptor).getParent(param1,wrappedCollection,_rootModel);
            }
            return HierarchicalCollectionView(collection).getParentItem(param1);
         }
         return null;
      }
      
      [Bindable("firstVisibleItemChanged")]
      public function get firstVisibleItem() : Object
      {
         if(listItems.length > 0 && listItems[0].length > 0)
         {
            return listItems[0][0].data;
         }
         return null;
      }
      
      private function getCurrentCursorDepth() : int
      {
         if(_dataDescriptor is ITreeDataDescriptor2)
         {
            return ITreeDataDescriptor2(_dataDescriptor).getNodeDepth(iterator.current,iterator,_rootModel);
         }
         return HierarchicalViewCursor(iterator).currentDepth;
      }
      
      override public function get maxHorizontalScrollPosition() : Number
      {
         return _userMaxHorizontalScrollPosition > 0?Number(_userMaxHorizontalScrollPosition):Number(super.maxHorizontalScrollPosition);
      }
      
      private function getOpenChildrenStack(param1:Object, param2:Array) : Array
      {
         var _loc3_:Object = null;
         if(param1 == null)
         {
            return param2;
         }
         var _loc4_:ICollectionView = getChildren(param1,iterator.view);
         if(!_loc4_)
         {
            return [];
         }
         var _loc5_:IViewCursor = _loc4_.createCursor();
         while(!_loc5_.afterLast)
         {
            _loc3_ = _loc5_.current;
            param2.push(_loc3_);
            if(isBranch(_loc3_) && isItemOpen(_loc3_))
            {
               getOpenChildrenStack(_loc3_,param2);
            }
            _loc5_.moveNext();
         }
         return param2;
      }
      
      override protected function dragDropHandler(param1:DragEvent) : void
      {
         var _loc2_:Array = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc8_:int = 0;
         var _loc9_:Array = null;
         var _loc10_:Object = null;
         if(param1.isDefaultPrevented())
         {
            return;
         }
         hideDropFeedback(param1);
         if(param1.dragSource.hasFormat("treeItems"))
         {
            _loc2_ = param1.dragSource.dataForFormat("treeItems") as Array;
            if(param1.action == DragManager.MOVE && dragMoveEnabled)
            {
               if(param1.dragInitiator == this)
               {
                  calculateDropIndex(param1);
                  _loc8_ = _dropData.index;
                  _loc9_ = getParentStack(_dropData.parent);
                  _loc9_.unshift(_dropData.parent);
                  _loc4_ = _loc2_.length;
                  _loc3_ = 0;
                  while(_loc3_ < _loc4_)
                  {
                     _loc6_ = getParentItem(_loc2_[_loc3_]);
                     _loc5_ = getChildIndexInParent(_loc6_,_loc2_[_loc3_]);
                     for each(_loc7_ in _loc9_)
                     {
                        if(_loc2_[_loc3_] === _loc7_)
                        {
                           return;
                        }
                     }
                     removeChildItem(_loc6_,_loc2_[_loc3_],_loc5_);
                     if(_loc6_ == _dropData.parent && _loc5_ < _dropData.index)
                     {
                        _loc8_--;
                     }
                     addChildItem(_dropData.parent,_loc2_[_loc3_],_loc8_);
                     _loc3_++;
                  }
                  return;
               }
            }
            if(param1.action == DragManager.COPY)
            {
               if(!dataProvider)
               {
                  dataProvider = [];
                  validateNow();
               }
               _loc4_ = _loc2_.length;
               _loc3_ = 0;
               while(_loc3_ < _loc4_)
               {
                  _loc10_ = copyItemWithUID(_loc2_[_loc3_]);
                  addChildItem(_dropData.parent,_loc10_,_dropData.index);
                  _loc3_++;
               }
            }
         }
         lastDragEvent = null;
      }
      
      private function checkItemIndices(param1:DragEvent) : void
      {
         var _loc2_:Array = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:Object = null;
         if(haveItemIndices)
         {
            return;
         }
         if((param1.action == DragManager.MOVE || param1.action == DragManager.NONE) && dragMoveEnabled)
         {
            if(param1.dragInitiator == this)
            {
               _loc2_ = param1.dragSource.dataForFormat("treeItems") as Array;
               _loc3_ = _loc2_.length;
               _loc4_ = 0;
               while(_loc4_ < _loc3_)
               {
                  _loc5_ = getParentItem(_loc2_[_loc4_]);
                  getChildIndexInParent(_loc5_,_loc2_[_loc4_]);
                  _loc4_++;
               }
               haveItemIndices = true;
            }
         }
      }
      
      override protected function mouseClickHandler(param1:MouseEvent) : void
      {
         if(!tween)
         {
            super.mouseClickHandler(param1);
         }
      }
      
      override protected function mouseOverHandler(param1:MouseEvent) : void
      {
         if(!tween)
         {
            super.mouseOverHandler(param1);
         }
      }
      
      private function seekPendingDuringDragFailureHandler(param1:Object, param2:TreeSeekPending) : void
      {
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         if(tween)
         {
            tween.endTween();
         }
         super.updateDisplayList(param1,param2);
         if(collection)
         {
            collectionLength = collection.length;
         }
      }
      
      private function makeMask() : DisplayObject
      {
         var _loc1_:Shape = new FlexShape();
         _loc1_.name = "mask";
         var _loc2_:Graphics = _loc1_.graphics;
         _loc2_.beginFill(16777215);
         _loc2_.moveTo(0,0);
         _loc2_.lineTo(0,10);
         _loc2_.lineTo(10,10);
         _loc2_.lineTo(10,0);
         _loc2_.lineTo(0,0);
         _loc2_.endFill();
         listContent.addChild(_loc1_);
         return _loc1_;
      }
      
      override protected function dragCompleteHandler(param1:DragEvent) : void
      {
         var items:Array = null;
         var parent:* = undefined;
         var index:int = 0;
         var i:int = 0;
         var n:int = 0;
         var targetTree:Tree = null;
         var item:Object = null;
         var event:DragEvent = param1;
         isPressed = false;
         if(event.isDefaultPrevented())
         {
            return;
         }
         resetDragScrolling();
         try
         {
            if(event.dragSource.hasFormat("treeItems"))
            {
               if(event.action == DragManager.MOVE && dragMoveEnabled)
               {
                  if(event.relatedObject != this)
                  {
                     items = event.dragSource.dataForFormat("treeItems") as Array;
                     n = items.length;
                     i = 0;
                     while(i < n)
                     {
                        parent = getParentItem(items[i]);
                        index = getChildIndexInParent(parent,items[i]);
                        removeChildItem(parent,items[i],index);
                        i++;
                     }
                     if(event.relatedObject is Tree)
                     {
                        targetTree = Tree(event.relatedObject);
                        if(!targetTree.dataProvider)
                        {
                           targetTree.dataProvider = [];
                           targetTree.validateNow();
                        }
                        n = items.length;
                        i = 0;
                        while(i < n)
                        {
                           item = items[i];
                           targetTree.addChildItem(targetTree._dropData.parent,item,targetTree._dropData.index);
                           i++;
                        }
                     }
                  }
                  clearSelected(false);
               }
            }
         }
         catch(e:ItemPendingError)
         {
            e.addResponder(new ItemResponder(seekPendingDuringDragResultHandler,seekPendingDuringDragFailureHandler,new TreeSeekPending(event,dragCompleteHandler)));
         }
         lastDragEvent = null;
      }
      
      public function set showRoot(param1:Boolean) : void
      {
         if(_showRoot != param1)
         {
            _showRoot = param1;
            showRootChanged = true;
            invalidateProperties();
         }
      }
   }
}

import mx.events.DragEvent;

class TreeSeekPending
{
    
   
   public var retryFunction:Function;
   
   public var event:DragEvent;
   
   function TreeSeekPending(param1:DragEvent, param2:Function)
   {
      super();
      this.event = param1;
      this.retryFunction = param2;
   }
}
