package shared.utility
{
   public class ArrayHelper
   {
       
      
      public function ArrayHelper()
      {
         super();
      }
      
      public static function s_IndexOf(param1:Array, param2:String, param3:*) : int
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         if(param1 != null && param2 != null)
         {
            _loc4_ = 0;
            _loc5_ = param1.length;
            while(_loc4_ < _loc5_)
            {
               if(param1[_loc4_] != null && param1[_loc4_].hasOwnProperty(param2) && param1[_loc4_][param2] == param3)
               {
                  return _loc4_;
               }
               _loc4_++;
            }
         }
         return -1;
      }
   }
}
