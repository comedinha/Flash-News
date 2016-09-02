package shared.utility
{
   import flash.system.Capabilities;
   
   public function checkPlayerVersion(param1:int, param2:int, param3:int, param4:int) : Boolean
   {
      var _loc5_:RegExp = null;
      _loc5_ = /^\w* (\d*),(\d*),(\d*),(\d*)$/;
      var _loc6_:Object = _loc5_.exec(Capabilities.version);
      if(_loc6_ == null)
      {
         return false;
      }
      if(_loc6_[1] > param1)
      {
         return true;
      }
      if(_loc6_[1] == param1)
      {
         if(_loc6_[2] > param2)
         {
            return true;
         }
         if(_loc6_[2] == param2)
         {
            if(_loc6_[3] > param3)
            {
               return true;
            }
            if(_loc6_[3] == param3)
            {
               if(_loc6_[4] >= param4)
               {
                  return true;
               }
            }
         }
      }
      return false;
   }
}
