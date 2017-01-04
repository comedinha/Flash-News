package shared.utility
{
   public class Heap
   {
       
      
      private var m_Length:int = 0;
      
      private var m_Heap:Vector.<HeapItem> = null;
      
      public function Heap(param1:int = 0)
      {
         super();
         this.m_Heap = new Vector.<HeapItem>(param1);
      }
      
      public function addItem(param1:HeapItem, param2:int) : HeapItem
      {
         var _loc3_:int = 0;
         if(param1 != null)
         {
            _loc3_ = this.m_Length;
            param1.m_HeapKey = param2;
            param1.m_HeapParent = this;
            param1.m_HeapPosition = _loc3_;
            this.m_Heap[_loc3_] = param1;
            this.m_Length++;
            this.minHeapify(_loc3_);
         }
         return param1;
      }
      
      public function updateKey(param1:HeapItem, param2:int) : HeapItem
      {
         if(param1 != null && param1.m_HeapParent == this && param1.m_HeapPosition < this.m_Length && param1.m_HeapKey != param2)
         {
            param1.m_HeapKey = param2;
            this.minHeapify(param1.m_HeapPosition);
         }
         return param1;
      }
      
      public function get length() : int
      {
         return this.m_Length;
      }
      
      private function minHeapify(param1:int, param2:Boolean = true) : void
      {
         var _loc3_:int = param1;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:HeapItem = null;
         while(param2 && _loc3_ > 0)
         {
            _loc4_ = _loc3_ + 1 >>> 1 - 1;
            if(this.m_Heap[_loc3_].m_HeapKey < this.m_Heap[_loc4_].m_HeapKey)
            {
               _loc8_ = this.m_Heap[_loc4_];
               this.m_Heap[_loc4_] = this.m_Heap[_loc3_];
               this.m_Heap[_loc4_].m_HeapPosition = _loc4_;
               this.m_Heap[_loc3_] = _loc8_;
               this.m_Heap[_loc3_].m_HeapPosition = _loc3_;
               _loc3_ = _loc4_;
            }
            else
            {
               _loc3_ = 0;
            }
         }
         while(true)
         {
            _loc5_ = _loc3_ + 1 << 1 - 1;
            _loc6_ = _loc5_ + 1;
            _loc7_ = _loc3_;
            if(_loc5_ < this.m_Length && this.m_Heap[_loc5_].m_HeapKey < this.m_Heap[_loc7_].m_HeapKey)
            {
               _loc7_ = _loc5_;
            }
            if(_loc6_ < this.m_Length && this.m_Heap[_loc6_].m_HeapKey < this.m_Heap[_loc7_].m_HeapKey)
            {
               _loc7_ = _loc6_;
            }
            if(_loc7_ > _loc3_)
            {
               _loc8_ = this.m_Heap[_loc3_];
               this.m_Heap[_loc3_] = this.m_Heap[_loc7_];
               this.m_Heap[_loc3_].m_HeapPosition = _loc3_;
               this.m_Heap[_loc7_] = _loc8_;
               this.m_Heap[_loc7_].m_HeapPosition = _loc7_;
               _loc3_ = _loc7_;
               continue;
            }
            break;
         }
      }
      
      public function peekMinItem() : HeapItem
      {
         return this.m_Length > 0?this.m_Heap[0]:null;
      }
      
      public function extractMinItem() : HeapItem
      {
         if(this.m_Length <= 0)
         {
            return null;
         }
         var _loc1_:HeapItem = this.m_Heap[0];
         _loc1_.m_HeapParent = null;
         _loc1_.m_HeapPosition = -1;
         this.m_Length--;
         this.m_Heap[0] = this.m_Heap[this.m_Length];
         this.m_Heap[this.m_Length] = null;
         this.minHeapify(0);
         return _loc1_;
      }
      
      public function clear(param1:Boolean = true) : void
      {
         var _loc2_:HeapItem = null;
         var _loc3_:int = 0;
         while(_loc3_ < this.m_Length)
         {
            if(_loc2_ != null)
            {
               _loc2_.m_HeapPosition = -1;
               _loc2_.m_HeapParent = null;
            }
            _loc3_++;
         }
         this.m_Length = 0;
         if(param1)
         {
            this.m_Heap.length = 0;
         }
      }
   }
}
