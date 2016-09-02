package shared.utility
{
   public function closure(param1:Object, param2:Function, ... rest) : Function
   {
      var a_Context:Object = param1;
      var a_Function:Function = param2;
      var a_Parameters:Array = rest;
      var f:Function = function():*
      {
         var _loc2_:* = arguments.callee.impl;
         var _loc3_:* = arguments.callee.context;
         var _loc4_:Array = [];
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         _loc5_ = 0;
         _loc7_ = arguments.callee.parameters.length;
         while(_loc5_ < _loc7_)
         {
            _loc4_[_loc6_++] = arguments.callee.parameters[_loc5_];
            _loc5_++;
         }
         _loc5_ = 0;
         _loc7_ = arguments.length;
         while(_loc5_ < _loc7_)
         {
            _loc4_[_loc6_++] = arguments[_loc5_];
            _loc5_++;
         }
         return _loc2_.apply(_loc3_,_loc4_);
      };
      var _f:Object = f;
      _f.impl = a_Function;
      _f.context = a_Context;
      _f.parameters = a_Parameters;
      return f;
   }
}
