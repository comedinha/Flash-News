package shared.utility
{
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   
   public function replaceChild(param1:DisplayObject, param2:DisplayObject) : DisplayObject
   {
      var _loc3_:DisplayObjectContainer = null;
      var _loc4_:int = 0;
      if(param1 != null)
      {
         _loc3_ = param1.parent;
         _loc4_ = _loc3_.getChildIndex(param1);
         _loc3_.removeChildAt(_loc4_);
         if(param2 != null)
         {
            _loc3_.addChildAt(param2,_loc4_);
         }
      }
      return param2;
   }
}
