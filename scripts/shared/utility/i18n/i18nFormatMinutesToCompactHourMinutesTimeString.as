package shared.utility.i18n
{
   import mx.resources.ResourceManager;
   import mx.resources.IResourceManager;
   
   public function i18nFormatMinutesToCompactHourMinutesTimeString(param1:uint) : String
   {
      var _loc2_:String = "Global";
      var _loc3_:IResourceManager = ResourceManager.getInstance();
      if(_loc3_ == null)
      {
         return "";
      }
      var _loc4_:uint = param1 / 60;
      var _loc5_:uint = param1 % 60;
      if(_loc4_ > 0)
      {
         return _loc3_.getString(_loc2_,"TIMESTRING_COMPACT_WITH_HOURS",[_loc4_,_loc5_]);
      }
      return _loc3_.getString(_loc2_,"TIMESTRING_COMPACT_MINUTES",[_loc5_]);
   }
}
