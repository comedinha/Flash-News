package shared.utility
{
   import flash.display.DisplayObject;
   import flash.display.Stage;
   import flash.geom.Point;
   
   public function getClassInstanceUnderPoint(param1:Stage, param2:Point, param3:Class) : *
   {
      var _loc6_:DisplayObject = null;
      var _loc4_:Array = param1.getObjectsUnderPoint(param2);
      var _loc5_:int = _loc4_.length - 1;
      while(_loc5_ >= 0)
      {
         _loc6_ = DisplayObject(_loc4_[_loc5_]);
         while(_loc6_ != null)
         {
            if(_loc6_ is param3)
            {
               return _loc6_;
            }
            if(_loc6_ is Stage)
            {
               _loc6_ = null;
            }
            else
            {
               _loc6_ = _loc6_.parent;
            }
         }
         _loc5_--;
      }
      return null;
   }
}
