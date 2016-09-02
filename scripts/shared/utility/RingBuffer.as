package shared.utility
{
   import flash.events.EventDispatcher;
   import mx.collections.IList;
   import mx.events.CollectionEvent;
   import mx.events.CollectionEventKind;
   
   public class RingBuffer extends EventDispatcher implements IList
   {
       
      
      protected var m_Offset:int = 0;
      
      protected var m_Length:int = 0;
      
      protected var m_Data:Array = null;
      
      protected var m_Size:int = 0;
      
      public function RingBuffer(param1:int = 1)
      {
         super();
         if(param1 < 1)
         {
            throw new ArgumentError("RingBuffer.RingBuffer: Size has to be >= 1.");
         }
         this.m_Size = param1;
         this.m_Data = new Array(this.m_Size);
         this.m_Offset = 0;
         this.m_Length = 0;
      }
      
      public function get size() : int
      {
         return this.m_Size;
      }
      
      public function removeAll() : void
      {
         this.m_Data = new Array(this.m_Size);
         this.m_Offset = 0;
         this.m_Length = 0;
         var _loc1_:CollectionEvent = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE);
         _loc1_.kind = CollectionEventKind.RESET;
         dispatchEvent(_loc1_);
      }
      
      public function getItemIndex(param1:Object) : int
      {
         var _loc2_:int = 0;
         while(_loc2_ < this.m_Length)
         {
            if(this.m_Data[(this.m_Offset + _loc2_) % this.m_Size] == param1)
            {
               return _loc2_;
            }
            _loc2_++;
         }
         return -1;
      }
      
      public function removeItemAt(param1:int) : Object
      {
         if(param1 < 0 || param1 >= this.m_Length)
         {
            throw new RangeError("RingBuffer.removeItemAt: Index " + param1 + " is out of range.");
         }
         var _loc2_:Object = this.m_Data[(this.m_Offset + param1) % this.m_Size];
         var _loc3_:int = param1;
         while(_loc3_ < this.m_Length - 1)
         {
            this.m_Data[(this.m_Offset + _loc3_) % this.m_Size] = this.m_Data[(this.m_Offset + _loc3_ + 1) % this.m_Size];
            _loc3_++;
         }
         this.m_Length--;
         var _loc4_:CollectionEvent = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE);
         _loc4_.kind = CollectionEventKind.REMOVE;
         _loc4_.items = [_loc2_];
         _loc4_.location = param1;
         dispatchEvent(_loc4_);
         return _loc2_;
      }
      
      public function addItem(param1:Object) : void
      {
         this.addItemInternal(param1);
      }
      
      public function getItemAt(param1:int, param2:int = 0) : Object
      {
         if(param1 < 0 || param1 >= this.m_Length)
         {
            throw new RangeError("RingBuffer.getItemAt: Index " + param1 + " is out of range.");
         }
         return this.m_Data[(this.m_Offset + param1) % this.m_Size];
      }
      
      public function toArray() : Array
      {
         var _loc1_:Array = new Array(this.m_Length);
         var _loc2_:int = 0;
         while(_loc2_ < this.m_Length)
         {
            _loc1_[_loc2_] = this.m_Data[(this.m_Offset + _loc2_) % this.m_Size];
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function addItemAt(param1:Object, param2:int) : void
      {
         var _loc5_:Object = null;
         if(param2 < 0 || param2 > this.m_Length)
         {
            throw new RangeError("RingBuffer.addItemAt: Index " + param2 + " is out of range.");
         }
         var _loc3_:CollectionEvent = null;
         var _loc4_:int = 0;
         if(this.m_Length < this.m_Size)
         {
            _loc4_ = this.m_Length;
            while(_loc4_ > param2)
            {
               this.m_Data[_loc4_] = this.m_Data[_loc4_ - 1];
               _loc4_--;
            }
            this.m_Data[param2] = param1;
            this.m_Length++;
         }
         else
         {
            _loc5_ = this.m_Data[this.m_Offset];
            param2 = Math.min(param2,this.m_Size - 1);
            _loc4_ = 0;
            while(_loc4_ < param2)
            {
               this.m_Data[(this.m_Offset + _loc4_) % this.m_Size] = this.m_Data[(this.m_Offset + _loc4_ + 1) % this.m_Size];
               _loc4_++;
            }
            this.m_Data[(this.m_Offset + param2) % this.m_Size] = param1;
            _loc3_ = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE);
            _loc3_.kind = CollectionEventKind.REMOVE;
            _loc3_.items = [_loc5_];
            _loc3_.location = 0;
            dispatchEvent(_loc3_);
         }
         _loc3_ = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE);
         _loc3_.kind = CollectionEventKind.ADD;
         _loc3_.items = [param1];
         _loc3_.location = param2;
         dispatchEvent(_loc3_);
      }
      
      public function itemUpdated(param1:Object, param2:Object = null, param3:Object = null, param4:Object = null) : void
      {
         throw new Error("RingBuffer.itemUpdated: Not implemented.");
      }
      
      public function get length() : int
      {
         return this.m_Length;
      }
      
      private function addItemInternal(param1:Object) : Object
      {
         var _loc2_:CollectionEvent = null;
         var _loc3_:Object = null;
         if(this.m_Length < this.m_Size)
         {
            this.m_Data[(this.m_Offset + this.m_Length) % this.m_Size] = param1;
            this.m_Length++;
         }
         else
         {
            _loc3_ = this.m_Data[this.m_Offset];
            this.m_Data[this.m_Offset] = param1;
            this.m_Offset = (this.m_Offset + 1) % this.m_Size;
            _loc2_ = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE);
            _loc2_.kind = CollectionEventKind.REMOVE;
            _loc2_.items = [_loc3_];
            _loc2_.location = 0;
            dispatchEvent(_loc2_);
         }
         _loc2_ = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE);
         _loc2_.kind = CollectionEventKind.ADD;
         _loc2_.items = [param1];
         _loc2_.location = this.m_Length - 1;
         dispatchEvent(_loc2_);
         return _loc3_;
      }
      
      public function setItemAt(param1:Object, param2:int) : Object
      {
         if(param2 < 0 || param2 >= this.m_Length)
         {
            throw new RangeError("RingBuffer.setItemAt: Index " + param2 + " is out of range.");
         }
         var _loc3_:int = (this.m_Offset + param2) % this.m_Size;
         var _loc4_:Object = this.m_Data[_loc3_];
         this.m_Data[_loc3_] = param1;
         var _loc5_:CollectionEvent = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE,false,false,CollectionEventKind.REMOVE,param2);
         dispatchEvent(_loc5_);
         return _loc4_;
      }
   }
}
