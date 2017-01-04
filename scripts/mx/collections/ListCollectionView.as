package mx.collections
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.utils.Proxy;
   import flash.utils.flash_proxy;
   import flash.utils.getQualifiedClassName;
   import mx.collections.errors.CollectionViewError;
   import mx.collections.errors.ItemPendingError;
   import mx.collections.errors.SortError;
   import mx.core.IMXMLObject;
   import mx.core.mx_internal;
   import mx.events.CollectionEvent;
   import mx.events.CollectionEventKind;
   import mx.events.PropertyChangeEvent;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   import mx.utils.ObjectUtil;
   
   use namespace mx_internal;
   
   public class ListCollectionView extends Proxy implements ICollectionView, IList, IMXMLObject
   {
      
      mx_internal static const VERSION:String = "3.6.0.21751";
       
      
      private var autoUpdateCounter:int;
      
      private var _list:IList;
      
      private var _filterFunction:Function;
      
      protected var localIndex:Array;
      
      mx_internal var dispatchResetEvent:Boolean = true;
      
      private var pendingUpdates:Array;
      
      private var resourceManager:IResourceManager;
      
      private var eventDispatcher:EventDispatcher;
      
      private var revision:int;
      
      private var _sort:Sort;
      
      public function ListCollectionView(param1:IList = null)
      {
         resourceManager = ResourceManager.getInstance();
         super();
         eventDispatcher = new EventDispatcher(this);
         this.list = param1;
      }
      
      private function handlePendingUpdates() : void
      {
         var _loc1_:Array = null;
         var _loc2_:CollectionEvent = null;
         var _loc3_:int = 0;
         var _loc4_:CollectionEvent = null;
         var _loc5_:int = 0;
         if(pendingUpdates)
         {
            _loc1_ = pendingUpdates;
            pendingUpdates = null;
            _loc3_ = 0;
            while(_loc3_ < _loc1_.length)
            {
               _loc4_ = _loc1_[_loc3_];
               if(_loc4_.kind == CollectionEventKind.UPDATE)
               {
                  if(!_loc2_)
                  {
                     _loc2_ = _loc4_;
                  }
                  else
                  {
                     _loc5_ = 0;
                     while(_loc5_ < _loc4_.items.length)
                     {
                        _loc2_.items.push(_loc4_.items[_loc5_]);
                        _loc5_++;
                     }
                  }
               }
               else
               {
                  listChangeHandler(_loc4_);
               }
               _loc3_++;
            }
            if(_loc2_)
            {
               listChangeHandler(_loc2_);
            }
         }
      }
      
      private function replaceItemsInView(param1:Array, param2:int, param3:Boolean = true) : void
      {
         var _loc4_:int = 0;
         var _loc5_:Array = null;
         var _loc6_:Array = null;
         var _loc7_:int = 0;
         var _loc8_:PropertyChangeEvent = null;
         var _loc9_:CollectionEvent = null;
         if(localIndex)
         {
            _loc4_ = param1.length;
            _loc5_ = [];
            _loc6_ = [];
            _loc7_ = 0;
            while(_loc7_ < _loc4_)
            {
               _loc8_ = param1[_loc7_];
               _loc5_.push(_loc8_.oldValue);
               _loc6_.push(_loc8_.newValue);
               _loc7_++;
            }
            removeItemsFromView(_loc5_,param2,param3);
            addItemsToView(_loc6_,param2,param3);
         }
         else
         {
            _loc9_ = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE);
            _loc9_.kind = CollectionEventKind.REPLACE;
            _loc9_.location = param2;
            _loc9_.items = param1;
            dispatchEvent(_loc9_);
         }
      }
      
      private function getFilteredItemIndex(param1:Object) : int
      {
         var _loc4_:Object = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc2_:int = list.getItemIndex(param1);
         if(_loc2_ == 0)
         {
            return 0;
         }
         var _loc3_:int = _loc2_ - 1;
         while(_loc3_ >= 0)
         {
            _loc4_ = list.getItemAt(_loc3_);
            if(filterFunction(_loc4_))
            {
               _loc5_ = localIndex.length;
               _loc6_ = 0;
               while(_loc6_ < _loc5_)
               {
                  if(localIndex[_loc6_] == _loc4_)
                  {
                     return _loc6_ + 1;
                  }
                  _loc6_++;
               }
            }
            _loc3_--;
         }
         return 0;
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return eventDispatcher.willTrigger(param1);
      }
      
      mx_internal function findItem(param1:Object, param2:String, param3:Boolean = false) : int
      {
         var _loc4_:String = null;
         if(!sort)
         {
            _loc4_ = resourceManager.getString("collections","itemNotFound");
            throw new CollectionViewError(_loc4_);
         }
         if(localIndex.length == 0)
         {
            return !!param3?0:-1;
         }
         return sort.findItem(localIndex,param1,param2,param3);
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         eventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      override flash_proxy function nextName(param1:int) : String
      {
         return (param1 - 1).toString();
      }
      
      public function removeAll() : void
      {
         var _loc2_:int = 0;
         var _loc1_:int = length;
         if(_loc1_ > 0)
         {
            if(localIndex)
            {
               _loc2_ = _loc1_ - 1;
               while(_loc2_ >= 0)
               {
                  removeItemAt(_loc2_);
                  _loc2_--;
               }
            }
            else
            {
               list.removeAll();
            }
         }
      }
      
      override flash_proxy function hasProperty(param1:*) : Boolean
      {
         var n:Number = NaN;
         var name:* = param1;
         if(name is QName)
         {
            name = name.localName;
         }
         var index:int = -1;
         try
         {
            n = parseInt(String(name));
            if(!isNaN(n))
            {
               index = int(n);
            }
         }
         catch(e:Error)
         {
         }
         if(index == -1)
         {
            return false;
         }
         return index >= 0 && index < length;
      }
      
      public function addAllAt(param1:IList, param2:int) : void
      {
         var _loc3_:int = param1.length;
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            this.addItemAt(param1.getItemAt(_loc4_),_loc4_ + param2);
            _loc4_++;
         }
      }
      
      [Bindable("collectionChange")]
      public function getItemAt(param1:int, param2:int = 0) : Object
      {
         var _loc3_:String = null;
         if(param1 < 0 || param1 >= length)
         {
            _loc3_ = resourceManager.getString("collections","outOfBounds",[param1]);
            throw new RangeError(_loc3_);
         }
         if(localIndex)
         {
            return localIndex[param1];
         }
         if(list)
         {
            return list.getItemAt(param1,param2);
         }
         return null;
      }
      
      private function moveItemInView(param1:Object, param2:Boolean = true, param3:Array = null) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:CollectionEvent = null;
         if(localIndex)
         {
            _loc4_ = -1;
            _loc5_ = 0;
            while(_loc5_ < localIndex.length)
            {
               if(localIndex[_loc5_] == param1)
               {
                  _loc4_ = _loc5_;
                  break;
               }
               _loc5_++;
            }
            if(_loc4_ > -1)
            {
               localIndex.splice(_loc4_,1);
            }
            _loc6_ = addItemsToView([param1],_loc4_,false);
            if(param2)
            {
               _loc7_ = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE);
               _loc7_.items.push(param1);
               if(param3 && _loc6_ == _loc4_ && _loc6_ > -1)
               {
                  param3.push(param1);
                  return;
               }
               if(_loc6_ > -1 && _loc4_ > -1)
               {
                  _loc7_.kind = CollectionEventKind.MOVE;
                  _loc7_.location = _loc6_;
                  _loc7_.oldLocation = _loc4_;
               }
               else if(_loc6_ > -1)
               {
                  _loc7_.kind = CollectionEventKind.ADD;
                  _loc7_.location = _loc6_;
               }
               else if(_loc4_ > -1)
               {
                  _loc7_.kind = CollectionEventKind.REMOVE;
                  _loc7_.location = _loc4_;
               }
               else
               {
                  param2 = false;
               }
               if(param2)
               {
                  dispatchEvent(_loc7_);
               }
            }
         }
      }
      
      public function contains(param1:Object) : Boolean
      {
         return getItemIndex(param1) != -1;
      }
      
      [Bindable("sortChanged")]
      public function get sort() : Sort
      {
         return _sort;
      }
      
      private function removeItemsFromView(param1:Array, param2:int, param3:Boolean = true) : void
      {
         var _loc6_:int = 0;
         var _loc7_:Object = null;
         var _loc8_:int = 0;
         var _loc9_:CollectionEvent = null;
         var _loc4_:Array = !!localIndex?[]:param1;
         var _loc5_:int = param2;
         if(localIndex)
         {
            _loc6_ = 0;
            while(_loc6_ < param1.length)
            {
               _loc7_ = param1[_loc6_];
               _loc8_ = getItemIndex(_loc7_);
               if(_loc8_ > -1)
               {
                  localIndex.splice(_loc8_,1);
                  _loc4_.push(_loc7_);
                  _loc5_ = _loc8_;
               }
               _loc6_++;
            }
         }
         if(param3 && _loc4_.length > 0)
         {
            _loc9_ = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE);
            _loc9_.kind = CollectionEventKind.REMOVE;
            _loc9_.location = !localIndex || _loc4_.length == 1?int(_loc5_):-1;
            _loc9_.items = _loc4_;
            dispatchEvent(_loc9_);
         }
      }
      
      [Bindable("listChanged")]
      public function get list() : IList
      {
         return _list;
      }
      
      public function addItemAt(param1:Object, param2:int) : void
      {
         var _loc4_:String = null;
         if(param2 < 0 || !list || param2 > length)
         {
            _loc4_ = resourceManager.getString("collections","outOfBounds",[param2]);
            throw new RangeError(_loc4_);
         }
         var _loc3_:int = param2;
         if(localIndex && sort)
         {
            _loc3_ = list.length;
         }
         else if(localIndex && filterFunction != null)
         {
            if(_loc3_ == localIndex.length)
            {
               _loc3_ = list.length;
            }
            else
            {
               _loc3_ = list.getItemIndex(localIndex[param2]);
            }
         }
         list.addItemAt(param1,_loc3_);
      }
      
      public function itemUpdated(param1:Object, param2:Object = null, param3:Object = null, param4:Object = null) : void
      {
         list.itemUpdated(param1,param2,param3,param4);
      }
      
      private function populateLocalIndex() : void
      {
         if(list)
         {
            localIndex = list.toArray();
         }
         else
         {
            localIndex = [];
         }
      }
      
      private function handlePropertyChangeEvents(param1:Array) : void
      {
         var _loc3_:Array = null;
         var _loc4_:Object = null;
         var _loc5_:int = 0;
         var _loc6_:Array = null;
         var _loc7_:int = 0;
         var _loc8_:PropertyChangeEvent = null;
         var _loc9_:Object = null;
         var _loc10_:* = false;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         var _loc14_:int = 0;
         var _loc15_:CollectionEvent = null;
         var _loc2_:Array = param1;
         if(sort || filterFunction != null)
         {
            _loc3_ = [];
            _loc5_ = 0;
            while(_loc5_ < param1.length)
            {
               _loc8_ = param1[_loc5_];
               if(_loc8_.target)
               {
                  _loc9_ = _loc8_.target;
                  _loc10_ = _loc8_.target != _loc8_.source;
               }
               else
               {
                  _loc9_ = _loc8_.source;
                  _loc10_ = false;
               }
               _loc11_ = 0;
               while(_loc11_ < _loc3_.length)
               {
                  if(_loc3_[_loc11_].item == _loc9_)
                  {
                     param1 = _loc3_[_loc11_].events;
                     _loc12_ = param1.length;
                     _loc13_ = 0;
                     while(_loc13_ < _loc12_)
                     {
                        if(param1[_loc13_].property != _loc8_.property)
                        {
                           param1.push(_loc8_);
                           break;
                        }
                        _loc13_++;
                     }
                     break;
                  }
                  _loc11_++;
               }
               if(_loc11_ < _loc3_.length)
               {
                  _loc4_ = _loc3_[_loc11_];
               }
               else
               {
                  _loc4_ = {
                     "item":_loc9_,
                     "move":_loc10_,
                     "events":[_loc8_]
                  };
                  _loc3_.push(_loc4_);
               }
               _loc4_.move = _loc4_.move || filterFunction || !_loc8_.property || sort && sort.propertyAffectsSort(String(_loc8_.property));
               _loc5_++;
            }
            _loc2_ = [];
            _loc5_ = 0;
            while(_loc5_ < _loc3_.length)
            {
               _loc4_ = _loc3_[_loc5_];
               if(_loc4_.move)
               {
                  moveItemInView(_loc4_.item,_loc4_.item,_loc2_);
               }
               else
               {
                  _loc2_.push(_loc4_.item);
               }
               _loc5_++;
            }
            _loc6_ = [];
            _loc7_ = 0;
            while(_loc7_ < _loc2_.length)
            {
               _loc14_ = 0;
               while(_loc14_ < _loc3_.length)
               {
                  if(_loc2_[_loc7_] == _loc3_[_loc14_].item)
                  {
                     _loc6_ = _loc6_.concat(_loc3_[_loc14_].events);
                  }
                  _loc14_++;
               }
               _loc7_++;
            }
            _loc2_ = _loc6_;
         }
         if(_loc2_.length > 0)
         {
            _loc15_ = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE);
            _loc15_.kind = CollectionEventKind.UPDATE;
            _loc15_.items = _loc2_;
            dispatchEvent(_loc15_);
         }
      }
      
      public function set sort(param1:Sort) : void
      {
         _sort = param1;
         dispatchEvent(new Event("sortChanged"));
      }
      
      override flash_proxy function nextValue(param1:int) : *
      {
         return getItemAt(param1 - 1);
      }
      
      public function setItemAt(param1:Object, param2:int) : Object
      {
         var _loc4_:String = null;
         var _loc5_:Object = null;
         if(param2 < 0 || !list || param2 >= length)
         {
            _loc4_ = resourceManager.getString("collections","outOfBounds",[param2]);
            throw new RangeError(_loc4_);
         }
         var _loc3_:int = param2;
         if(localIndex)
         {
            if(param2 > localIndex.length)
            {
               _loc3_ = list.length;
            }
            else
            {
               _loc5_ = localIndex[param2];
               _loc3_ = list.getItemIndex(_loc5_);
            }
         }
         return list.setItemAt(param1,_loc3_);
      }
      
      mx_internal function getBookmark(param1:int) : ListCollectionViewBookmark
      {
         var value:Object = null;
         var message:String = null;
         var index:int = param1;
         if(index < 0 || index > length)
         {
            message = resourceManager.getString("collections","invalidIndex",[index]);
            throw new CollectionViewError(message);
         }
         try
         {
            value = getItemAt(index);
         }
         catch(e:Error)
         {
            value = null;
         }
         return new ListCollectionViewBookmark(value,this,revision,index);
      }
      
      private function addItemsToView(param1:Array, param2:int, param3:Boolean = true) : int
      {
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:Object = null;
         var _loc10_:String = null;
         var _loc11_:CollectionEvent = null;
         var _loc4_:Array = !!localIndex?[]:param1;
         var _loc5_:int = param2;
         var _loc6_:Boolean = true;
         if(localIndex)
         {
            _loc7_ = param2;
            _loc8_ = 0;
            while(_loc8_ < param1.length)
            {
               _loc9_ = param1[_loc8_];
               if(filterFunction == null || filterFunction(_loc9_))
               {
                  if(sort)
                  {
                     _loc7_ = findItem(_loc9_,Sort.ANY_INDEX_MODE,true);
                     if(_loc6_)
                     {
                        _loc5_ = _loc7_;
                        _loc6_ = false;
                     }
                  }
                  else
                  {
                     _loc7_ = getFilteredItemIndex(_loc9_);
                     if(_loc6_)
                     {
                        _loc5_ = _loc7_;
                        _loc6_ = false;
                     }
                  }
                  if(sort && sort.unique && sort.compareFunction(_loc9_,localIndex[_loc7_]) == 0)
                  {
                     _loc10_ = resourceManager.getString("collections","incorrectAddition");
                     throw new CollectionViewError(_loc10_);
                  }
                  localIndex.splice(_loc7_++,0,_loc9_);
                  _loc4_.push(_loc9_);
               }
               else
               {
                  _loc5_ = -1;
               }
               _loc8_++;
            }
         }
         if(localIndex && _loc4_.length > 1)
         {
            _loc5_ = -1;
         }
         if(param3 && _loc4_.length > 0)
         {
            _loc11_ = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE);
            _loc11_.kind = CollectionEventKind.ADD;
            _loc11_.location = _loc5_;
            _loc11_.items = _loc4_;
            dispatchEvent(_loc11_);
         }
         return _loc5_;
      }
      
      public function addAll(param1:IList) : void
      {
         addAllAt(param1,length);
      }
      
      public function set list(param1:IList) : void
      {
         var _loc2_:* = false;
         var _loc3_:* = false;
         if(_list != param1)
         {
            if(_list)
            {
               _list.removeEventListener(CollectionEvent.COLLECTION_CHANGE,listChangeHandler);
               _loc2_ = _list.length > 0;
            }
            _list = param1;
            if(_list)
            {
               _list.addEventListener(CollectionEvent.COLLECTION_CHANGE,listChangeHandler,false,0,true);
               _loc3_ = _list.length > 0;
            }
            if(_loc2_ || _loc3_)
            {
               reset();
            }
            dispatchEvent(new Event("listChanged"));
         }
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         eventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return eventDispatcher.dispatchEvent(param1);
      }
      
      public function getItemIndex(param1:Object) : int
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         if(sort)
         {
            _loc3_ = sort.findItem(localIndex,param1,Sort.FIRST_INDEX_MODE);
            if(_loc3_ == -1)
            {
               return -1;
            }
            _loc4_ = sort.findItem(localIndex,param1,Sort.LAST_INDEX_MODE);
            _loc2_ = _loc3_;
            while(_loc2_ <= _loc4_)
            {
               if(localIndex[_loc2_] == param1)
               {
                  return _loc2_;
               }
               _loc2_++;
            }
            return -1;
         }
         if(filterFunction != null)
         {
            _loc5_ = localIndex.length;
            _loc2_ = 0;
            while(_loc2_ < _loc5_)
            {
               if(localIndex[_loc2_] == param1)
               {
                  return _loc2_;
               }
               _loc2_++;
            }
            return -1;
         }
         return list.getItemIndex(param1);
      }
      
      mx_internal function getLocalItemIndex(param1:Object) : int
      {
         var _loc2_:int = 0;
         var _loc3_:int = localIndex.length;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            if(localIndex[_loc2_] == param1)
            {
               return _loc2_;
            }
            _loc2_++;
         }
         return -1;
      }
      
      override flash_proxy function getProperty(param1:*) : *
      {
         var n:Number = NaN;
         var message:String = null;
         var name:* = param1;
         if(name is QName)
         {
            name = name.localName;
         }
         var index:int = -1;
         try
         {
            n = parseInt(String(name));
            if(!isNaN(n))
            {
               index = int(n);
            }
         }
         catch(e:Error)
         {
         }
         if(index == -1)
         {
            message = resourceManager.getString("collections","unknownProperty",[name]);
            throw new Error(message);
         }
         return getItemAt(index);
      }
      
      public function enableAutoUpdate() : void
      {
         if(autoUpdateCounter > 0)
         {
            autoUpdateCounter--;
            if(autoUpdateCounter == 0)
            {
               handlePendingUpdates();
            }
         }
      }
      
      mx_internal function reset() : void
      {
         var _loc1_:CollectionEvent = null;
         internalRefresh(false);
         if(dispatchResetEvent)
         {
            _loc1_ = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE);
            _loc1_.kind = CollectionEventKind.RESET;
            dispatchEvent(_loc1_);
         }
      }
      
      public function toArray() : Array
      {
         var _loc1_:Array = null;
         if(localIndex)
         {
            _loc1_ = localIndex.concat();
         }
         else
         {
            _loc1_ = list.toArray();
         }
         return _loc1_;
      }
      
      public function removeItemAt(param1:int) : Object
      {
         var _loc3_:String = null;
         var _loc4_:Object = null;
         if(param1 < 0 || param1 >= length)
         {
            _loc3_ = resourceManager.getString("collections","outOfBounds",[param1]);
            throw new RangeError(_loc3_);
         }
         var _loc2_:int = param1;
         if(localIndex)
         {
            _loc4_ = localIndex[param1];
            _loc2_ = list.getItemIndex(_loc4_);
         }
         return list.removeItemAt(_loc2_);
      }
      
      override flash_proxy function callProperty(param1:*, ... rest) : *
      {
         return null;
      }
      
      public function initialized(param1:Object, param2:String) : void
      {
         refresh();
      }
      
      override flash_proxy function setProperty(param1:*, param2:*) : void
      {
         var n:Number = NaN;
         var message:String = null;
         var name:* = param1;
         var value:* = param2;
         if(name is QName)
         {
            name = name.localName;
         }
         var index:int = -1;
         try
         {
            n = parseInt(String(name));
            if(!isNaN(n))
            {
               index = int(n);
            }
         }
         catch(e:Error)
         {
         }
         if(index == -1)
         {
            message = resourceManager.getString("collections","unknownProperty",[name]);
            throw new Error(message);
         }
         setItemAt(value,index);
      }
      
      public function addItem(param1:Object) : void
      {
         addItemAt(param1,length);
      }
      
      private function internalRefresh(param1:Boolean) : Boolean
      {
         var tmp:Array = null;
         var len:int = 0;
         var i:int = 0;
         var item:Object = null;
         var refreshEvent:CollectionEvent = null;
         var dispatch:Boolean = param1;
         if(sort || filterFunction != null)
         {
            try
            {
               populateLocalIndex();
            }
            catch(pending:ItemPendingError)
            {
               pending.addResponder(new ItemResponder(function(param1:Object, param2:Object = null):void
               {
                  internalRefresh(dispatch);
               },function(param1:Object, param2:Object = null):void
               {
               }));
               return false;
            }
            if(filterFunction != null)
            {
               tmp = [];
               len = localIndex.length;
               i = 0;
               while(i < len)
               {
                  item = localIndex[i];
                  if(filterFunction(item))
                  {
                     tmp.push(item);
                  }
                  i++;
               }
               localIndex = tmp;
            }
            if(sort)
            {
               sort.sort(localIndex);
               dispatch = true;
            }
         }
         else if(localIndex)
         {
            localIndex = null;
         }
         revision++;
         pendingUpdates = null;
         if(dispatch)
         {
            refreshEvent = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE);
            refreshEvent.kind = CollectionEventKind.REFRESH;
            dispatchEvent(refreshEvent);
         }
         return true;
      }
      
      public function set filterFunction(param1:Function) : void
      {
         _filterFunction = param1;
         dispatchEvent(new Event("filterFunctionChanged"));
      }
      
      mx_internal function getBookmarkIndex(param1:CursorBookmark) : int
      {
         var bm:ListCollectionViewBookmark = null;
         var message:String = null;
         var bookmark:CursorBookmark = param1;
         if(!(bookmark is ListCollectionViewBookmark) || ListCollectionViewBookmark(bookmark).view != this)
         {
            message = resourceManager.getString("collections","bookmarkNotFound");
            throw new CollectionViewError(message);
         }
         bm = ListCollectionViewBookmark(bookmark);
         if(bm.viewRevision != revision)
         {
            if(bm.index < 0 || bm.index >= length || getItemAt(bm.index) != bm.value)
            {
               try
               {
                  bm.index = getItemIndex(bm.value);
               }
               catch(e:SortError)
               {
                  bm.index = getLocalItemIndex(bm.value);
               }
            }
            bm.viewRevision = revision;
         }
         return bm.index;
      }
      
      public function refresh() : Boolean
      {
         return internalRefresh(true);
      }
      
      [Bindable("filterFunctionChanged")]
      public function get filterFunction() : Function
      {
         return _filterFunction;
      }
      
      public function createCursor() : IViewCursor
      {
         return new ListCollectionViewCursor(this);
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return eventDispatcher.hasEventListener(param1);
      }
      
      [Bindable("collectionChange")]
      public function get length() : int
      {
         if(localIndex)
         {
            return localIndex.length;
         }
         if(list)
         {
            return list.length;
         }
         return 0;
      }
      
      override flash_proxy function nextNameIndex(param1:int) : int
      {
         return param1 < length?int(param1 + 1):0;
      }
      
      public function disableAutoUpdate() : void
      {
         autoUpdateCounter++;
      }
      
      public function toString() : String
      {
         if(localIndex)
         {
            return ObjectUtil.toString(localIndex);
         }
         if(list && Object(list).toString)
         {
            return Object(list).toString();
         }
         return getQualifiedClassName(this);
      }
      
      private function listChangeHandler(param1:CollectionEvent) : void
      {
         if(autoUpdateCounter > 0)
         {
            if(!pendingUpdates)
            {
               pendingUpdates = [];
            }
            pendingUpdates.push(param1);
         }
         else
         {
            switch(param1.kind)
            {
               case CollectionEventKind.ADD:
                  addItemsToView(param1.items,param1.location);
                  break;
               case CollectionEventKind.RESET:
                  reset();
                  break;
               case CollectionEventKind.REMOVE:
                  removeItemsFromView(param1.items,param1.location);
                  break;
               case CollectionEventKind.REPLACE:
                  replaceItemsInView(param1.items,param1.location);
                  break;
               case CollectionEventKind.UPDATE:
                  handlePropertyChangeEvents(param1.items);
                  break;
               default:
                  dispatchEvent(param1);
            }
         }
      }
   }
}

import mx.collections.CursorBookmark;
import mx.collections.ListCollectionView;
import mx.core.mx_internal;

use namespace mx_internal;

class ListCollectionViewBookmark extends CursorBookmark
{
    
   
   mx_internal var viewRevision:int;
   
   mx_internal var index:int;
   
   mx_internal var view:ListCollectionView;
   
   function ListCollectionViewBookmark(param1:Object, param2:ListCollectionView, param3:int, param4:int)
   {
      super(param1);
      this.view = param2;
      this.viewRevision = param3;
      this.index = param4;
   }
   
   override public function getViewIndex() : int
   {
      return view.getBookmarkIndex(this);
   }
}

import flash.events.EventDispatcher;
import mx.collections.CursorBookmark;
import mx.collections.ICollectionView;
import mx.collections.IViewCursor;
import mx.collections.ListCollectionView;
import mx.collections.Sort;
import mx.collections.errors.CollectionViewError;
import mx.collections.errors.CursorError;
import mx.collections.errors.ItemPendingError;
import mx.collections.errors.SortError;
import mx.core.mx_internal;
import mx.events.CollectionEvent;
import mx.events.CollectionEventKind;
import mx.events.FlexEvent;
import mx.resources.IResourceManager;
import mx.resources.ResourceManager;

use namespace mx_internal;

class ListCollectionViewCursor extends EventDispatcher implements IViewCursor
{
   
   private static const BEFORE_FIRST_INDEX:int = -1;
   
   private static const AFTER_LAST_INDEX:int = -2;
    
   
   private var _view:ListCollectionView;
   
   private var invalid:Boolean;
   
   private var resourceManager:IResourceManager;
   
   private var currentIndex:int;
   
   private var currentValue:Object;
   
   function ListCollectionViewCursor(param1:ListCollectionView)
   {
      var view:ListCollectionView = param1;
      resourceManager = ResourceManager.getInstance();
      super();
      _view = view;
      _view.addEventListener(CollectionEvent.COLLECTION_CHANGE,collectionEventHandler,false,0,true);
      currentIndex = view.length > 0?0:int(AFTER_LAST_INDEX);
      if(currentIndex == 0)
      {
         try
         {
            setCurrent(view.getItemAt(0),false);
            return;
         }
         catch(e:ItemPendingError)
         {
            currentIndex = BEFORE_FIRST_INDEX;
            setCurrent(null,false);
            return;
         }
      }
   }
   
   public function findAny(param1:Object) : Boolean
   {
      var index:int = 0;
      var values:Object = param1;
      checkValid();
      var lcView:ListCollectionView = ListCollectionView(view);
      try
      {
         index = lcView.findItem(values,Sort.ANY_INDEX_MODE);
      }
      catch(e:SortError)
      {
         throw new CursorError(e.message);
      }
      if(index > -1)
      {
         currentIndex = index;
         setCurrent(lcView.getItemAt(currentIndex));
      }
      return index > -1;
   }
   
   public function remove() : Object
   {
      var oldIndex:int = 0;
      var message:String = null;
      if(beforeFirst || afterLast)
      {
         message = resourceManager.getString("collections","invalidRemove");
         throw new CursorError(message);
      }
      oldIndex = currentIndex;
      currentIndex++;
      if(currentIndex >= view.length)
      {
         currentIndex = AFTER_LAST_INDEX;
         setCurrent(null);
      }
      else
      {
         try
         {
            setCurrent(ListCollectionView(view).getItemAt(currentIndex));
         }
         catch(e:ItemPendingError)
         {
            setCurrent(null,false);
            ListCollectionView(view).removeItemAt(oldIndex);
            throw e;
         }
      }
      var removed:Object = ListCollectionView(view).removeItemAt(oldIndex);
      return removed;
   }
   
   private function setCurrent(param1:Object, param2:Boolean = true) : void
   {
      currentValue = param1;
      if(param2)
      {
         dispatchEvent(new FlexEvent(FlexEvent.CURSOR_UPDATE));
      }
   }
   
   public function seek(param1:CursorBookmark, param2:int = 0, param3:int = 0) : void
   {
      var message:String = null;
      var bookmark:CursorBookmark = param1;
      var offset:int = param2;
      var prefetch:int = param3;
      checkValid();
      if(view.length == 0)
      {
         currentIndex = AFTER_LAST_INDEX;
         setCurrent(null,false);
         return;
      }
      var newIndex:int = currentIndex;
      if(bookmark == CursorBookmark.FIRST)
      {
         newIndex = 0;
      }
      else if(bookmark == CursorBookmark.LAST)
      {
         newIndex = view.length - 1;
      }
      else if(bookmark != CursorBookmark.CURRENT)
      {
         try
         {
            newIndex = ListCollectionView(view).getBookmarkIndex(bookmark);
            if(newIndex < 0)
            {
               setCurrent(null);
               message = resourceManager.getString("collections","bookmarkInvalid");
               throw new CursorError(message);
            }
         }
         catch(bmError:CollectionViewError)
         {
            message = resourceManager.getString("collections","bookmarkInvalid");
            throw new CursorError(message);
         }
      }
      newIndex = newIndex + offset;
      var newCurrent:Object = null;
      if(newIndex >= view.length)
      {
         currentIndex = AFTER_LAST_INDEX;
      }
      else if(newIndex < 0)
      {
         currentIndex = BEFORE_FIRST_INDEX;
      }
      else
      {
         newCurrent = ListCollectionView(view).getItemAt(newIndex,prefetch);
         currentIndex = newIndex;
      }
      setCurrent(newCurrent);
   }
   
   public function insert(param1:Object) : void
   {
      var _loc2_:int = 0;
      var _loc3_:String = null;
      if(afterLast)
      {
         _loc2_ = view.length;
      }
      else if(beforeFirst)
      {
         if(view.length > 0)
         {
            _loc3_ = resourceManager.getString("collections","invalidInsert");
            throw new CursorError(_loc3_);
         }
         _loc2_ = 0;
      }
      else
      {
         _loc2_ = currentIndex;
      }
      ListCollectionView(view).addItemAt(param1,_loc2_);
   }
   
   [Bindable("cursorUpdate")]
   public function get afterLast() : Boolean
   {
      checkValid();
      return currentIndex == AFTER_LAST_INDEX || view.length == 0;
   }
   
   private function checkValid() : void
   {
      var _loc1_:String = null;
      if(invalid)
      {
         _loc1_ = resourceManager.getString("collections","invalidCursor");
         throw new CursorError(_loc1_);
      }
   }
   
   private function collectionEventHandler(param1:CollectionEvent) : void
   {
      var event:CollectionEvent = param1;
      switch(event.kind)
      {
         case CollectionEventKind.ADD:
            if(event.location <= currentIndex)
            {
               currentIndex = currentIndex + event.items.length;
            }
            break;
         case CollectionEventKind.REMOVE:
            if(event.location < currentIndex)
            {
               currentIndex = currentIndex - event.items.length;
            }
            else if(event.location == currentIndex)
            {
               if(currentIndex < view.length)
               {
                  try
                  {
                     setCurrent(ListCollectionView(view).getItemAt(currentIndex));
                  }
                  catch(error:ItemPendingError)
                  {
                     setCurrent(null,false);
                  }
               }
               else
               {
                  currentIndex = AFTER_LAST_INDEX;
                  setCurrent(null);
               }
            }
            break;
         case CollectionEventKind.MOVE:
            if(event.oldLocation == currentIndex)
            {
               currentIndex = event.location;
            }
            else
            {
               if(event.oldLocation < currentIndex)
               {
                  currentIndex = currentIndex - event.items.length;
               }
               if(event.location <= currentIndex)
               {
                  currentIndex = currentIndex + event.items.length;
               }
            }
            break;
         case CollectionEventKind.REFRESH:
            if(!(beforeFirst || afterLast))
            {
               try
               {
                  currentIndex = ListCollectionView(view).getItemIndex(currentValue);
               }
               catch(e:SortError)
               {
                  if(ListCollectionView(view).sort)
                  {
                     currentIndex = ListCollectionView(view).getLocalItemIndex(currentValue);
                  }
               }
               if(currentIndex == -1)
               {
                  setCurrent(null);
               }
            }
            break;
         case CollectionEventKind.REPLACE:
            if(event.location == currentIndex)
            {
               try
               {
                  setCurrent(ListCollectionView(view).getItemAt(currentIndex));
               }
               catch(error:ItemPendingError)
               {
                  setCurrent(null,false);
               }
            }
            break;
         case CollectionEventKind.RESET:
            currentIndex = BEFORE_FIRST_INDEX;
            setCurrent(null);
      }
   }
   
   public function moveNext() : Boolean
   {
      if(afterLast)
      {
         return false;
      }
      var _loc1_:int = !!beforeFirst?0:int(currentIndex + 1);
      if(_loc1_ >= view.length)
      {
         _loc1_ = AFTER_LAST_INDEX;
         setCurrent(null);
      }
      else
      {
         setCurrent(ListCollectionView(view).getItemAt(_loc1_));
      }
      currentIndex = _loc1_;
      return !afterLast;
   }
   
   public function get view() : ICollectionView
   {
      checkValid();
      return _view;
   }
   
   public function movePrevious() : Boolean
   {
      if(beforeFirst)
      {
         return false;
      }
      var _loc1_:int = !!afterLast?int(view.length - 1):int(currentIndex - 1);
      if(_loc1_ == -1)
      {
         _loc1_ = BEFORE_FIRST_INDEX;
         setCurrent(null);
      }
      else
      {
         setCurrent(ListCollectionView(view).getItemAt(_loc1_));
      }
      currentIndex = _loc1_;
      return !beforeFirst;
   }
   
   public function findLast(param1:Object) : Boolean
   {
      var index:int = 0;
      var values:Object = param1;
      checkValid();
      var lcView:ListCollectionView = ListCollectionView(view);
      try
      {
         index = lcView.findItem(values,Sort.LAST_INDEX_MODE);
      }
      catch(sortError:SortError)
      {
         throw new CursorError(sortError.message);
      }
      if(index > -1)
      {
         currentIndex = index;
         setCurrent(lcView.getItemAt(currentIndex));
      }
      return index > -1;
   }
   
   [Bindable("cursorUpdate")]
   public function get beforeFirst() : Boolean
   {
      checkValid();
      return currentIndex == BEFORE_FIRST_INDEX || view.length == 0;
   }
   
   [Bindable("cursorUpdate")]
   public function get bookmark() : CursorBookmark
   {
      checkValid();
      if(view.length == 0 || beforeFirst)
      {
         return CursorBookmark.FIRST;
      }
      if(afterLast)
      {
         return CursorBookmark.LAST;
      }
      return ListCollectionView(view).getBookmark(currentIndex);
   }
   
   public function findFirst(param1:Object) : Boolean
   {
      var index:int = 0;
      var values:Object = param1;
      checkValid();
      var lcView:ListCollectionView = ListCollectionView(view);
      try
      {
         index = lcView.findItem(values,Sort.FIRST_INDEX_MODE);
      }
      catch(sortError:SortError)
      {
         throw new CursorError(sortError.message);
      }
      if(index > -1)
      {
         currentIndex = index;
         setCurrent(lcView.getItemAt(currentIndex));
      }
      return index > -1;
   }
   
   [Bindable("cursorUpdate")]
   public function get current() : Object
   {
      checkValid();
      return currentValue;
   }
}
