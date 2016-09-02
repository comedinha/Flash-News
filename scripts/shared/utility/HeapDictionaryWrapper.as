package shared.utility
{
   import flash.utils.Dictionary;
   
   public class HeapDictionaryWrapper
   {
       
      
      private var m_Dictionary:Dictionary = null;
      
      private var m_Keys:Vector.<Object> = null;
      
      private var m_Heap:shared.utility.Heap = null;
      
      public function HeapDictionaryWrapper()
      {
         super();
         this.clear();
      }
      
      public function remove(param1:*) : Boolean
      {
         var _loc2_:HeapDictionaryItem = null;
         var _loc3_:uint = 0;
         if(param1 in this.m_Dictionary)
         {
            _loc2_ = this.m_Dictionary[param1] as HeapDictionaryItem;
            _loc2_.data = undefined;
            delete this.m_Dictionary[param1];
            _loc3_ = this.m_Keys.indexOf(param1,0);
            this.m_Keys.splice(_loc3_,1);
            this.m_Heap.updateKey(_loc2_,int.MIN_VALUE);
            this.m_Heap.extractMinItem();
            return true;
         }
         return false;
      }
      
      public function get length() : uint
      {
         return this.m_Keys.length;
      }
      
      public function peekMinItem() : Object
      {
         return this.m_Heap.peekMinItem() == null?null:HeapDictionaryItem(this.m_Heap.peekMinItem()).data;
      }
      
      public function extractMinItem() : Object
      {
         var _loc1_:Object = null;
         var _loc2_:HeapDictionaryItem = null;
         _loc1_ = this.peekMinItemKey();
         _loc2_ = this.m_Dictionary[_loc1_] as HeapDictionaryItem;
         var _loc3_:Object = _loc2_.data;
         this.remove(_loc1_);
         return _loc3_;
      }
      
      public function put(param1:*, param2:Object, param3:int = -2.147483648E9) : void
      {
         var _loc4_:HeapDictionaryItem = null;
         if(param1 in this.m_Dictionary)
         {
            _loc4_ = this.m_Dictionary[param1] as HeapDictionaryItem;
            this.m_Heap.updateKey(_loc4_,param3);
            _loc4_.data = param2;
         }
         else
         {
            _loc4_ = new HeapDictionaryItem(param1,param2);
            this.m_Dictionary[param1] = _loc4_;
            this.m_Keys.push(param1);
            this.m_Heap.addItem(_loc4_,param3);
         }
      }
      
      public function clear() : void
      {
         this.m_Dictionary = new Dictionary();
         this.m_Keys = new Vector.<Object>();
         this.m_Heap = new shared.utility.Heap();
      }
      
      public function peekMinItemKey() : Object
      {
         return this.m_Heap.peekMinItem() == null?null:HeapDictionaryItem(this.m_Heap.peekMinItem()).key;
      }
      
      public function get(param1:*, param2:int = -2.147483648E9) : *
      {
         var _loc3_:HeapDictionaryItem = null;
         if(param1 in this.m_Dictionary)
         {
            _loc3_ = this.m_Dictionary[param1] as HeapDictionaryItem;
            this.m_Heap.updateKey(_loc3_,param2);
            return _loc3_.data;
         }
         return null;
      }
      
      public function updateHeapPriority(param1:Object, param2:int) : void
      {
         var _loc3_:HeapDictionaryItem = this.m_Dictionary[param1] as HeapDictionaryItem;
         if(_loc3_ != null)
         {
            this.m_Heap.updateKey(_loc3_,param2);
         }
      }
      
      public function get keys() : Vector.<Object>
      {
         return this.m_Keys.concat();
      }
      
      public function contains(param1:*) : Boolean
      {
         return param1 in this.m_Dictionary;
      }
   }
}

import shared.utility.HeapItem;

class HeapDictionaryItem extends HeapItem
{
    
   
   private var m_Data;
   
   private var m_Key = null;
   
   function HeapDictionaryItem(param1:*, param2:*)
   {
      super();
      this.m_Key = param1;
      this.m_Data = param2;
   }
   
   public function get data() : *
   {
      return this.m_Data;
   }
   
   public function set data(param1:*) : void
   {
      this.m_Data = param1;
   }
   
   public function get key() : *
   {
      return this.m_Key;
   }
}
