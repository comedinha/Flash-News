package shared.utility
{
   import flash.utils.Dictionary;
   
   public class WeakReference
   {
       
      
      private var m_Dictionary:Dictionary;
      
      public function WeakReference(param1:* = null)
      {
         this.m_Dictionary = new Dictionary(true);
         super();
         this.value = param1;
      }
      
      public function get value() : *
      {
         var _loc1_:* = undefined;
         for(_loc1_ in this.m_Dictionary)
         {
            return _loc1_;
         }
         return null;
      }
      
      public function set value(param1:*) : void
      {
         var _loc2_:* = undefined;
         for(_loc2_ in this.m_Dictionary)
         {
            delete this.m_Dictionary[_loc2_];
         }
         if(param1 != null)
         {
            this.m_Dictionary[param1] = true;
         }
      }
   }
}
