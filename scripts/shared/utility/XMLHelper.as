package shared.utility
{
   public class XMLHelper
   {
       
      
      public function XMLHelper()
      {
         super();
      }
      
      public static function s_UnmarshallInteger(param1:XML) : Number
      {
         if(param1.hasComplexContent())
         {
            throw new ArgumentError("XMLHelper.s_UnmarshallInteger(): Invalid element.");
         }
         var _loc2_:XMLList = param1.text();
         var _loc3_:int = _loc2_.length();
         if(_loc3_ == 0)
         {
            return 0;
         }
         return parseInt(_loc2_[0].toString());
      }
      
      public static function s_UnmarshallString(param1:XML) : String
      {
         if(param1.hasComplexContent())
         {
            throw new ArgumentError("XMLHelper.s_UnmarshallString(): Invalid element.");
         }
         var _loc2_:XMLList = param1.text();
         var _loc3_:int = _loc2_.length();
         if(_loc3_ == 0)
         {
            return "";
         }
         return _loc2_[0].toString();
      }
      
      public static function s_UnmarshallBoolean(param1:XML) : Boolean
      {
         var _loc4_:String = null;
         if(param1.hasComplexContent())
         {
            throw new ArgumentError("XMLHelper.s_UnmarshallDecimal(): Invalid element.");
         }
         var _loc2_:XMLList = param1.text();
         var _loc3_:int = _loc2_.length();
         if(_loc3_ == 0)
         {
            return false;
         }
         _loc4_ = _loc2_[0].toString();
         return _loc4_ == "true" || parseInt(_loc4_) == 1;
      }
      
      public static function s_UnmarshallDecimal(param1:XML) : Number
      {
         if(param1.hasComplexContent())
         {
            throw new ArgumentError("XMLHelper.s_UnmarshallDecimal(): Invalid element.");
         }
         var _loc2_:XMLList = param1.text();
         var _loc3_:int = _loc2_.length();
         if(_loc3_ == 0)
         {
            return 0;
         }
         return Number(_loc2_[0].toString());
      }
   }
}
