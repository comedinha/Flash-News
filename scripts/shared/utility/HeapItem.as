package shared.utility
{
   public class HeapItem
   {
       
      
      var m_HeapKey:int = 0;
      
      var m_HeapPosition:int = 0;
      
      var m_HeapParent:shared.utility.Heap = null;
      
      public function HeapItem()
      {
         super();
      }
      
      public function reset() : void
      {
         this.m_HeapKey = 0;
         this.m_HeapPosition = 0;
         this.m_HeapParent = null;
      }
   }
}
