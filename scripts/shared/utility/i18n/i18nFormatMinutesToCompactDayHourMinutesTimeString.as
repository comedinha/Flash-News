package shared.utility.i18n
{
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   
   public function i18nFormatMinutesToCompactDayHourMinutesTimeString(param1:uint) : String
   {
      var _loc3_:uint = 0;
      var _loc4_:uint = 0;
      var _loc5_:uint = 0;
      var _loc6_:IResourceManager = null;
      var _loc2_:String = "Global";
      if(param1 > 60 * 24)
      {
         _loc3_ = param1 / (60 * 24);
         _loc4_ = (param1 - _loc3_ * 24 * 60) / 60;
         _loc5_ = param1 % 60;
         _loc6_ = ResourceManager.getInstance();
         if(_loc6_ == null)
         {
            return "";
         }
         return _loc6_.getString(_loc2_,"TIMESTRING_COMPACT_WITH_DAYS",[_loc3_,_loc4_,_loc5_]);
      }
      return i18nFormatMinutesToCompactHourMinutesTimeString(param1);
   }
}
