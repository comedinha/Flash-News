package mx.formatters
{
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   public class NumberFormatter extends Formatter
   {
      
      mx_internal static const VERSION:String = "3.6.0.21751";
       
      
      private var roundingOverride:String;
      
      private var thousandsSeparatorFromOverride:String;
      
      private var _useNegativeSign:Object;
      
      private var decimalSeparatorFromOverride:String;
      
      private var _decimalSeparatorTo:String;
      
      private var useThousandsSeparatorOverride:Object;
      
      private var _thousandsSeparatorTo:String;
      
      private var useNegativeSignOverride:Object;
      
      private var thousandsSeparatorToOverride:String;
      
      private var decimalSeparatorToOverride:String;
      
      private var precisionOverride:Object;
      
      private var _rounding:String;
      
      private var _useThousandsSeparator:Object;
      
      private var _thousandsSeparatorFrom:String;
      
      private var _decimalSeparatorFrom:String;
      
      private var _precision:Object;
      
      public function NumberFormatter()
      {
         super();
      }
      
      public function set precision(param1:Object) : void
      {
         precisionOverride = param1;
         _precision = param1 != null?int(param1):resourceManager.getInt("formatters","numberFormatterPrecision");
      }
      
      public function get useNegativeSign() : Object
      {
         return _useNegativeSign;
      }
      
      override protected function resourcesChanged() : void
      {
         super.resourcesChanged();
         decimalSeparatorFrom = decimalSeparatorFromOverride;
         decimalSeparatorTo = decimalSeparatorToOverride;
         precision = precisionOverride;
         rounding = roundingOverride;
         thousandsSeparatorFrom = thousandsSeparatorFromOverride;
         thousandsSeparatorTo = thousandsSeparatorToOverride;
         useNegativeSign = useNegativeSignOverride;
         useThousandsSeparator = useThousandsSeparatorOverride;
      }
      
      public function get rounding() : String
      {
         return _rounding;
      }
      
      public function set thousandsSeparatorTo(param1:String) : void
      {
         thousandsSeparatorToOverride = param1;
         _thousandsSeparatorTo = param1 != null?param1:resourceManager.getString("SharedResources","thousandsSeparatorTo");
      }
      
      public function get thousandsSeparatorFrom() : String
      {
         return _thousandsSeparatorFrom;
      }
      
      public function set decimalSeparatorTo(param1:String) : void
      {
         decimalSeparatorToOverride = param1;
         _decimalSeparatorTo = param1 != null?param1:resourceManager.getString("SharedResources","decimalSeparatorTo");
      }
      
      public function set useNegativeSign(param1:Object) : void
      {
         useNegativeSignOverride = param1;
         _useNegativeSign = param1 != null?Boolean(param1):resourceManager.getBoolean("formatters","useNegativeSign");
      }
      
      override public function format(param1:Object) : String
      {
         var _loc9_:String = null;
         var _loc10_:Number = NaN;
         if(error)
         {
            error = null;
         }
         if(useThousandsSeparator && (decimalSeparatorFrom == thousandsSeparatorFrom || decimalSeparatorTo == thousandsSeparatorTo))
         {
            error = defaultInvalidFormatError;
            return "";
         }
         if(decimalSeparatorTo == "" || !isNaN(Number(decimalSeparatorTo)))
         {
            error = defaultInvalidFormatError;
            return "";
         }
         var _loc2_:NumberBase = new NumberBase(decimalSeparatorFrom,thousandsSeparatorFrom,decimalSeparatorTo,thousandsSeparatorTo);
         if(param1 is String)
         {
            param1 = _loc2_.parseNumberString(String(param1));
         }
         if(param1 === null || isNaN(Number(param1)))
         {
            error = defaultInvalidValueError;
            return "";
         }
         var _loc3_:* = Number(param1) < 0;
         var _loc4_:String = param1.toString();
         _loc4_.toLowerCase();
         var _loc5_:int = _loc4_.indexOf("e");
         if(_loc5_ != -1)
         {
            _loc4_ = _loc2_.expandExponents(_loc4_);
         }
         var _loc6_:Array = _loc4_.split(".");
         var _loc7_:int = !!_loc6_[1]?int(String(_loc6_[1]).length):0;
         if(precision <= _loc7_)
         {
            if(rounding != NumberBaseRoundType.NONE)
            {
               _loc4_ = _loc2_.formatRoundingWithPrecision(_loc4_,rounding,int(precision));
            }
         }
         var _loc8_:Number = Number(_loc4_);
         if(Math.abs(_loc8_) >= 1)
         {
            _loc6_ = _loc4_.split(".");
            _loc9_ = !!useThousandsSeparator?_loc2_.formatThousands(String(_loc6_[0])):String(_loc6_[0]);
            if(_loc6_[1] != null && _loc6_[1] != "")
            {
               _loc4_ = _loc9_ + decimalSeparatorTo + _loc6_[1];
            }
            else
            {
               _loc4_ = _loc9_;
            }
         }
         else if(Math.abs(_loc8_) > 0)
         {
            if(_loc4_.indexOf("e") != -1)
            {
               _loc10_ = Math.abs(_loc8_) + 1;
               _loc4_ = _loc10_.toString();
            }
            _loc4_ = decimalSeparatorTo + _loc4_.substring(_loc4_.indexOf(".") + 1);
         }
         _loc4_ = _loc2_.formatPrecision(_loc4_,int(precision));
         if(Number(_loc4_) == 0)
         {
            _loc3_ = false;
         }
         if(_loc3_)
         {
            _loc4_ = _loc2_.formatNegative(_loc4_,useNegativeSign);
         }
         if(!_loc2_.isValid)
         {
            error = defaultInvalidFormatError;
            return "";
         }
         return _loc4_;
      }
      
      public function get decimalSeparatorFrom() : String
      {
         return _decimalSeparatorFrom;
      }
      
      public function set rounding(param1:String) : void
      {
         roundingOverride = param1;
         _rounding = param1 != null?param1:resourceManager.getString("formatters","rounding");
      }
      
      public function get thousandsSeparatorTo() : String
      {
         return _thousandsSeparatorTo;
      }
      
      public function get decimalSeparatorTo() : String
      {
         return _decimalSeparatorTo;
      }
      
      public function set thousandsSeparatorFrom(param1:String) : void
      {
         thousandsSeparatorFromOverride = param1;
         _thousandsSeparatorFrom = param1 != null?param1:resourceManager.getString("SharedResources","thousandsSeparatorFrom");
      }
      
      public function set useThousandsSeparator(param1:Object) : void
      {
         useThousandsSeparatorOverride = param1;
         _useThousandsSeparator = param1 != null?Boolean(param1):resourceManager.getBoolean("formatters","useThousandsSeparator");
      }
      
      public function get useThousandsSeparator() : Object
      {
         return _useThousandsSeparator;
      }
      
      public function set decimalSeparatorFrom(param1:String) : void
      {
         decimalSeparatorFromOverride = param1;
         _decimalSeparatorFrom = param1 != null?param1:resourceManager.getString("SharedResources","decimalSeparatorFrom");
      }
      
      public function get precision() : Object
      {
         return _precision;
      }
   }
}
