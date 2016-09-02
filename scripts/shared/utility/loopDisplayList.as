package shared.utility
{
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Stage;
   
   public function loopDisplayList(param1:DisplayObjectContainer, param2:DisplayObject = null, param3:Function = null) : DisplayObject
   {
      var _loc4_:DisplayObject = param2;
      var _loc5_:DisplayObject = null;
      var _loc6_:DisplayObjectContainer = null;
      do
      {
         if(_loc4_ == null)
         {
            _loc4_ = param1;
         }
         else if((_loc6_ = _loc4_ as DisplayObjectContainer) != null && _loc6_.numChildren > 0)
         {
            _loc4_ = _loc6_.getChildAt(0);
         }
         else if((_loc5_ = getNextSibling(_loc4_)) != null)
         {
            _loc4_ = _loc5_;
         }
         else
         {
            _loc6_ = _loc4_.parent;
            _loc4_ = null;
            while(_loc4_ == null && _loc6_ != null && !(_loc6_ is Stage) && _loc6_ != param1)
            {
               if((_loc5_ = getNextSibling(_loc6_)) != null)
               {
                  _loc4_ = _loc5_;
               }
               else
               {
                  _loc6_ = _loc6_.parent;
               }
            }
         }
      }
      while(_loc4_ != null && (param3 == null || param3(_loc4_) !== true));
      
      return _loc4_;
   }
}

function getNextSibling(param1:DisplayObject):DisplayObject
{
   var _loc2_:DisplayObjectContainer = null;
   var _loc3_:int = 0;
   if(param1 != null && param1.parent != null && !(param1 is Stage))
   {
      _loc2_ = param1.parent;
      _loc3_ = _loc2_.getChildIndex(param1);
      if(_loc3_ < _loc2_.numChildren - 1)
      {
         return _loc2_.getChildAt(_loc3_ + 1);
      }
   }
   return null;
}