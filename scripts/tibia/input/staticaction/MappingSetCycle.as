package tibia.input.staticaction
{
   import tibia.options.OptionsStorage;
   
   public class MappingSetCycle extends StaticAction
   {
      
      public static const NEXT:int = 1;
      
      public static const PREV:int = -1;
       
      
      protected var m_Direction:int = 1;
      
      public function MappingSetCycle(param1:int, param2:String, param3:uint, param4:int)
      {
         super(param1,param2,param3,false);
         if(param4 != NEXT && param4 != PREV)
         {
            throw new ArgumentError("MappingSetCycle.MappingSetCycle: Invalid direction: " + param4);
         }
         this.m_Direction = param4;
      }
      
      override public function perform(param1:Boolean = false) : void
      {
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc2_:OptionsStorage = Tibia.s_GetOptions();
         if(_loc2_ != null)
         {
            _loc3_ = _loc2_.getMappingSetIDs();
            if(_loc3_ != null && _loc3_.length > 0)
            {
               _loc4_ = 0;
               _loc5_ = _loc3_.length;
               _loc4_ = 0;
               while(_loc4_ < _loc5_)
               {
                  if(_loc3_[_loc4_] == _loc2_.generalInputSetID)
                  {
                     break;
                  }
                  _loc4_++;
               }
               _loc4_ = _loc4_ + this.m_Direction;
               if(_loc4_ < 0)
               {
                  _loc4_ = _loc4_ + _loc5_;
               }
               else if(_loc4_ >= _loc5_)
               {
                  _loc4_ = _loc4_ - _loc5_;
               }
               _loc2_.generalInputSetID = _loc3_[_loc4_];
            }
         }
      }
   }
}
