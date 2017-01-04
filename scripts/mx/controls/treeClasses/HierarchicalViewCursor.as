package mx.controls.treeClasses
{
   import flash.events.EventDispatcher;
   import flash.utils.Dictionary;
   import mx.collections.CursorBookmark;
   import mx.collections.ICollectionView;
   import mx.collections.IViewCursor;
   import mx.core.mx_internal;
   import mx.events.CollectionEvent;
   import mx.events.CollectionEventKind;
   
   use namespace mx_internal;
   
   public class HierarchicalViewCursor extends EventDispatcher implements IViewCursor
   {
      
      mx_internal static const VERSION:String = "3.6.0.21751";
       
      
      private var itemToUID:Function;
      
      private var openNodes:Object;
      
      private var collection:HierarchicalCollectionView;
      
      private var childIndexStack:Array;
      
      private var parentNodes:Array;
      
      private var _currentDepth:int = 1;
      
      private var model:ICollectionView;
      
      private var dataDescriptor:ITreeDataDescriptor;
      
      private var more:Boolean;
      
      private var currentIndex:int = 0;
      
      private var modelCursor:IViewCursor;
      
      private var childNodes:Object;
      
      private var currentChildIndex:int = 0;
      
      public function HierarchicalViewCursor(param1:HierarchicalCollectionView, param2:ICollectionView, param3:ITreeDataDescriptor, param4:Function, param5:Object)
      {
         childNodes = [];
         parentNodes = [];
         childIndexStack = [];
         super();
         this.collection = param1;
         this.model = param2;
         this.dataDescriptor = param3;
         this.itemToUID = param4;
         this.openNodes = param5;
         param1.addEventListener(CollectionEvent.COLLECTION_CHANGE,collectionChangeHandler,false,0,true);
         modelCursor = param2.createCursor();
         if(param2.length > 1)
         {
            more = true;
         }
         else
         {
            more = false;
         }
      }
      
      private function isNodeBefore(param1:Object, param2:Object) : Boolean
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:ICollectionView = null;
         var _loc6_:Object = null;
         var _loc9_:Object = null;
         var _loc10_:Object = null;
         var _loc11_:Object = null;
         if(param2 == null)
         {
            return false;
         }
         var _loc7_:Array = getParentStack(param1);
         var _loc8_:Array = getParentStack(param2);
         while(_loc7_.length && _loc8_.length)
         {
            _loc9_ = _loc7_.shift();
            _loc10_ = _loc8_.shift();
            if(_loc9_ != _loc10_)
            {
               _loc6_ = collection.getParentItem(_loc9_);
               if(_loc6_ != null && dataDescriptor.isBranch(_loc6_,model) && dataDescriptor.hasChildren(_loc6_,model))
               {
                  _loc5_ = dataDescriptor.getChildren(_loc6_,model);
               }
               else
               {
                  _loc5_ = model;
               }
               _loc3_ = _loc5_.length;
               _loc11_ = _loc5_[_loc4_];
               if(_loc11_ == _loc10_)
               {
                  return false;
               }
               if(_loc11_ == _loc9_)
               {
                  return true;
               }
            }
         }
         if(_loc7_.length)
         {
            param1 = _loc7_.shift();
         }
         if(_loc8_.length)
         {
            param2 = _loc8_.shift();
         }
         _loc5_ = model;
         _loc3_ = _loc5_.length;
         _loc4_ = 0;
         while(_loc4_ < _loc3_)
         {
            _loc11_ = _loc5_[_loc4_];
            if(_loc11_ == param2)
            {
               return false;
            }
            if(_loc11_ == param1)
            {
               return true;
            }
            _loc4_++;
         }
         return false;
      }
      
      public function findFirst(param1:Object) : Boolean
      {
         return findAny(param1);
      }
      
      public function remove() : Object
      {
         return null;
      }
      
      public function get afterLast() : Boolean
      {
         return currentIndex >= collection.length && current == null;
      }
      
      public function collectionChangeHandler(param1:CollectionEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         var _loc5_:Object = null;
         var _loc6_:Object = null;
         var _loc7_:Array = null;
         var _loc8_:Dictionary = null;
         var _loc10_:int = 0;
         var _loc9_:Boolean = false;
         _loc7_ = getParentStack(current);
         _loc8_ = new Dictionary();
         _loc3_ = _loc7_.length;
         _loc2_ = 0;
         while(_loc2_ < _loc3_ - 1)
         {
            _loc8_[_loc7_[_loc2_]] = _loc2_ + 1;
            _loc2_++;
         }
         _loc6_ = _loc7_[_loc7_.length - 1];
         if(param1.kind == CollectionEventKind.ADD)
         {
            _loc3_ = param1.items.length;
            if(param1.location <= currentIndex)
            {
               currentIndex = currentIndex + _loc3_;
               _loc9_ = true;
            }
            _loc2_ = 0;
            while(_loc2_ < _loc3_)
            {
               _loc4_ = param1.items[_loc2_];
               if(_loc9_)
               {
                  _loc5_ = collection.getParentItem(_loc4_);
                  if(_loc5_ == _loc6_)
                  {
                     currentChildIndex++;
                  }
                  else if(_loc8_[_loc5_] != null)
                  {
                     childIndexStack[_loc8_[_loc5_]]++;
                  }
               }
               _loc2_++;
            }
         }
         else if(param1.kind == CollectionEventKind.REMOVE)
         {
            _loc3_ = param1.items.length;
            if(param1.location <= currentIndex)
            {
               if(param1.location + _loc3_ >= currentIndex)
               {
                  _loc10_ = param1.location;
                  moveToFirst();
                  seek(CursorBookmark.FIRST,_loc10_);
                  _loc2_ = 0;
                  while(_loc2_ < _loc3_)
                  {
                     _loc4_ = param1.items[_loc2_];
                     delete collection.parentMap[itemToUID(_loc4_)];
                     _loc2_++;
                  }
                  return;
               }
               currentIndex = currentIndex - _loc3_;
               _loc9_ = true;
            }
            _loc2_ = 0;
            while(_loc2_ < _loc3_)
            {
               _loc4_ = param1.items[_loc2_];
               if(_loc9_)
               {
                  _loc5_ = collection.getParentItem(_loc4_);
                  if(_loc5_ == _loc6_)
                  {
                     currentChildIndex--;
                  }
                  else if(_loc8_[_loc5_] != null)
                  {
                     childIndexStack[_loc8_[_loc5_]]--;
                  }
               }
               delete collection.parentMap[itemToUID(_loc4_)];
               _loc2_++;
            }
         }
      }
      
      public function get view() : ICollectionView
      {
         return model;
      }
      
      public function get bookmark() : CursorBookmark
      {
         return new CursorBookmark(currentIndex.toString());
      }
      
      public function insert(param1:Object) : void
      {
      }
      
      private function getParentStack(param1:Object) : Array
      {
         var _loc2_:Array = [];
         var _loc3_:Object = collection.getParentItem(param1);
         while(_loc3_ != null)
         {
            _loc2_.unshift(_loc3_);
            _loc3_ = collection.getParentItem(_loc3_);
         }
         return _loc2_;
      }
      
      public function get currentDepth() : int
      {
         return _currentDepth;
      }
      
      private function isItemVisible(param1:Object) : Boolean
      {
         var _loc2_:Object = collection.getParentItem(param1);
         while(_loc2_ != null)
         {
            if(openNodes[itemToUID(_loc2_)] == null)
            {
               return false;
            }
            _loc2_ = collection.getParentItem(_loc2_);
         }
         return true;
      }
      
      public function moveToLast() : void
      {
         var _loc3_:Object = null;
         childNodes = [];
         childIndexStack = [];
         _currentDepth = 1;
         parentNodes = [];
         var _loc1_:Boolean = false;
         modelCursor.seek(CursorBookmark.LAST,0);
         var _loc2_:Object = modelCursor.current;
         while(openNodes[itemToUID(_loc2_)] && dataDescriptor.isBranch(_loc2_,model) && dataDescriptor.hasChildren(_loc2_,model))
         {
            _loc3_ = childNodes;
            childNodes = dataDescriptor.getChildren(_loc2_,model);
            if(childNodes != null && childNodes.length > 0)
            {
               parentNodes.push(_loc2_);
               childIndexStack.push(currentChildIndex);
               _loc2_ = childNodes[childNodes.length - 1];
               currentChildIndex = childNodes.length - 1;
               _currentDepth++;
               continue;
            }
            childNodes = _loc3_;
            break;
         }
         currentIndex = collection.length - 1;
      }
      
      public function movePrevious() : Boolean
      {
         var grandParent:Object = null;
         var previousChildNodes:Object = null;
         var currentNode:Object = current;
         if(currentNode == null)
         {
            return false;
         }
         if(parentNodes && parentNodes.length > 0)
         {
            if(currentChildIndex == 0)
            {
               currentNode = parentNodes.pop();
               currentChildIndex = childIndexStack.pop();
               grandParent = parentNodes[parentNodes.length - 1];
               if(grandParent != null && dataDescriptor.isBranch(grandParent,model) && dataDescriptor.hasChildren(grandParent,model))
               {
                  childNodes = dataDescriptor.getChildren(grandParent,model);
               }
               else
               {
                  childNodes = [];
               }
               _currentDepth--;
               currentIndex--;
               return true;
            }
            try
            {
               currentNode = childNodes[--currentChildIndex];
            }
            catch(e:RangeError)
            {
               return false;
            }
         }
         else
         {
            more = modelCursor.movePrevious();
            if(more)
            {
               currentNode = modelCursor.current;
            }
            else
            {
               currentIndex = -1;
               currentNode = null;
               return false;
            }
         }
         while(openNodes[itemToUID(currentNode)] && dataDescriptor.isBranch(currentNode,model) && dataDescriptor.hasChildren(currentNode,model))
         {
            previousChildNodes = childNodes;
            childNodes = dataDescriptor.getChildren(currentNode,model);
            if(childNodes.length > 0)
            {
               childIndexStack.push(currentChildIndex);
               parentNodes.push(currentNode);
               currentChildIndex = childNodes.length - 1;
               currentNode = childNodes[currentChildIndex];
               _currentDepth++;
               continue;
            }
            childNodes = previousChildNodes;
            break;
         }
         currentIndex--;
         return true;
      }
      
      public function moveNext() : Boolean
      {
         var previousChildNodes:Object = null;
         var grandParent:Object = null;
         var currentNode:Object = current;
         if(currentNode == null)
         {
            return false;
         }
         var uid:String = itemToUID(currentNode);
         if(!collection.parentMap.hasOwnProperty(uid))
         {
            collection.parentMap[uid] = parentNodes[parentNodes.length - 1];
         }
         if(openNodes[uid] && dataDescriptor.isBranch(currentNode,model) && dataDescriptor.hasChildren(currentNode,model))
         {
            previousChildNodes = childNodes;
            childNodes = dataDescriptor.getChildren(currentNode,model);
            if(childNodes.length > 0)
            {
               childIndexStack.push(currentChildIndex);
               parentNodes.push(currentNode);
               currentChildIndex = 0;
               currentNode = childNodes[0];
               currentIndex++;
               _currentDepth++;
               return true;
            }
            childNodes = previousChildNodes;
         }
         while(childNodes != null && childNodes.length > 0 && currentChildIndex >= Math.max(childNodes.length - 1,0))
         {
            if(childIndexStack.length < 1 && !more)
            {
               currentNode = null;
               currentIndex++;
               _currentDepth = 1;
               return false;
            }
            currentNode = parentNodes.pop();
            grandParent = parentNodes[parentNodes.length - 1];
            if(grandParent != null && dataDescriptor.isBranch(grandParent,model) && dataDescriptor.hasChildren(grandParent,model))
            {
               childNodes = dataDescriptor.getChildren(grandParent,model);
            }
            else
            {
               childNodes = [];
            }
            currentChildIndex = childIndexStack.pop();
            _currentDepth--;
         }
         if(childIndexStack.length == 0)
         {
            _currentDepth = 1;
            more = modelCursor.moveNext();
            if(more)
            {
               currentNode = modelCursor.current;
            }
            else
            {
               _currentDepth = 1;
               currentIndex++;
               currentNode = null;
               return false;
            }
         }
         else
         {
            try
            {
               currentNode = childNodes[++currentChildIndex];
               currentIndex++;
               return true;
            }
            catch(e:RangeError)
            {
               return false;
            }
            continue loop0;
         }
         currentIndex++;
         return true;
      }
      
      public function get index() : int
      {
         return currentIndex;
      }
      
      public function findLast(param1:Object) : Boolean
      {
         var _loc3_:Object = null;
         var _loc4_:Boolean = false;
         var _loc5_:* = null;
         seek(CursorBookmark.LAST);
         var _loc2_:Boolean = false;
         while(true)
         {
            if(_loc2_)
            {
               return false;
            }
            _loc3_ = current;
            _loc4_ = true;
            for(_loc5_ in param1)
            {
               if(_loc3_[_loc5_] != param1[_loc5_])
               {
                  _loc4_ = false;
                  break;
               }
            }
            if(_loc4_)
            {
               break;
            }
            _loc2_ = movePrevious();
         }
         return true;
      }
      
      public function get beforeFirst() : Boolean
      {
         return currentIndex <= collection.length && current == null;
      }
      
      public function get current() : Object
      {
         try
         {
            if(childIndexStack.length == 0)
            {
               return modelCursor.current;
            }
            return childNodes[currentChildIndex];
         }
         catch(e:RangeError)
         {
         }
         return null;
      }
      
      public function findAny(param1:Object) : Boolean
      {
         var _loc3_:Object = null;
         var _loc4_:Boolean = false;
         var _loc5_:* = null;
         seek(CursorBookmark.FIRST);
         var _loc2_:Boolean = false;
         while(true)
         {
            if(_loc2_)
            {
               return false;
            }
            _loc3_ = dataDescriptor.getData(current);
            _loc4_ = true;
            for(_loc5_ in param1)
            {
               if(_loc3_[_loc5_] != param1[_loc5_])
               {
                  _loc4_ = false;
                  break;
               }
            }
            if(_loc4_)
            {
               break;
            }
            _loc2_ = moveNext();
         }
         return true;
      }
      
      private function moveToFirst() : void
      {
         childNodes = [];
         modelCursor.seek(CursorBookmark.FIRST,0);
         if(model.length > 1)
         {
            more = true;
         }
         else
         {
            more = false;
         }
         currentChildIndex = 0;
         parentNodes = [];
         childIndexStack = [];
         currentIndex = 0;
         _currentDepth = 1;
      }
      
      public function seek(param1:CursorBookmark, param2:int = 0, param3:int = 0) : void
      {
         var _loc4_:int = 0;
         if(param1 == CursorBookmark.FIRST)
         {
            _loc4_ = 0;
         }
         else if(param1 == CursorBookmark.CURRENT)
         {
            _loc4_ = currentIndex;
         }
         else if(param1 == CursorBookmark.LAST)
         {
            _loc4_ = collection.length - 1;
         }
         else
         {
            _loc4_ = int(param1.value);
         }
         _loc4_ = Math.max(Math.min(_loc4_ + param2,collection.length),0);
         var _loc5_:int = Math.abs(currentIndex - _loc4_);
         var _loc6_:int = Math.abs(collection.length - _loc4_);
         var _loc7_:* = true;
         if(_loc5_ < _loc4_)
         {
            if(_loc6_ < _loc5_)
            {
               moveToLast();
               if(_loc6_ == 0)
               {
                  moveNext();
                  _loc4_ = 0;
               }
               else
               {
                  _loc4_ = _loc6_ - 1;
               }
               _loc7_ = false;
            }
            else
            {
               _loc7_ = currentIndex < _loc4_;
               _loc4_ = _loc5_;
               if(currentIndex == collection.length)
               {
                  _loc4_--;
                  moveToLast();
               }
            }
         }
         else if(_loc6_ < _loc4_)
         {
            moveToLast();
            if(_loc6_ == 0)
            {
               moveNext();
               _loc4_ = 0;
            }
            else
            {
               _loc4_ = _loc6_ - 1;
            }
            _loc7_ = false;
         }
         else
         {
            moveToFirst();
         }
         if(_loc7_)
         {
            while(_loc4_ && _loc4_ > 0)
            {
               moveNext();
               _loc4_--;
            }
         }
         else
         {
            while(_loc4_ && _loc4_ > 0)
            {
               movePrevious();
               _loc4_--;
            }
         }
      }
   }
}
