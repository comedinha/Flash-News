package shared.utility.i18n
{
   import mx.formatters.NumberFormatter;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   
   public function i18nFormatNumber(param1:Number) : String
   {
      var _loc2_:String = "Global";
      var _loc3_:IResourceManager = ResourceManager.getInstance();
      if(_loc3_ == null)
      {
         return "";
      }
      var _loc4_:NumberFormatter = new NumberFormatter();
      _loc4_.decimalSeparatorTo = _loc3_.getString(_loc2_,"NUMBER_FORMAT_DECIMAL_SEPARATOR");
      _loc4_.thousandsSeparatorTo = _loc3_.getString(_loc2_,"NUMBER_FORMAT_THOUSANDS_SEPARATOR");
      return _loc4_.format(param1);
   }
}
