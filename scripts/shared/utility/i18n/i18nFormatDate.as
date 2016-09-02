package shared.utility.i18n
{
   import mx.resources.ResourceManager;
   import mx.resources.IResourceManager;
   import mx.formatters.DateFormatter;
   
   public function i18nFormatDate(param1:Date) : String
   {
      var _loc2_:String = "Global";
      var _loc3_:IResourceManager = ResourceManager.getInstance();
      if(_loc3_ == null)
      {
         return "";
      }
      var _loc4_:DateFormatter = new DateFormatter();
      _loc4_.formatString = _loc3_.getString(_loc2_,"DATE_FORMAT");
      return _loc4_.format(param1);
   }
}
