package tibia.market.marketWidgetClasses
{
   import tibia.market.Offer;
   import shared.utility.i18n.i18nFormatNumber;
   import mx.resources.ResourceManager;
   import mx.resources.IResourceManager;
   import tibia.appearances.AppearanceStorage;
   import tibia.appearances.AppearanceType;
   import flash.events.Event;
   import mx.controls.TextInput;
   import flash.events.KeyboardEvent;
   import flash.events.TextEvent;
   import shared.utility.closure;
   import shared.utility.i18n.i18nFormatDate;
   
   class Utility
   {
      
      private static const MARKET_BUNDLE:String = "MarketWidget";
      
      private static const GLOBAL_BUNDLE:String = "Global";
       
      
      function Utility()
      {
         super();
      }
      
      public static function formatOfferPiecePrice(param1:Offer, ... rest) : String
      {
         return i18nFormatNumber(param1.piecePrice);
      }
      
      public static function formatOfferTerminationReason(param1:Offer, ... rest) : String
      {
         var _loc3_:IResourceManager = ResourceManager.getInstance();
         switch(param1.terminationReason)
         {
            case Offer.ACTIVE:
               return _loc3_.getString(MARKET_BUNDLE,"REASON_ACTIVE");
            case Offer.CANCELLED:
               return _loc3_.getString(MARKET_BUNDLE,"REASON_CANCELLED");
            case Offer.EXPIRED:
               return _loc3_.getString(MARKET_BUNDLE,"REASON_EXPIRED");
            case Offer.ACCEPTED:
               return _loc3_.getString(MARKET_BUNDLE,param1.kind == Offer.BUY_OFFER?"REASON_ACCEPTED_BUY_OFFER":"REASON_ACCEPTED_SELL_OFFER");
            default:
               return _loc3_.getString(MARKET_BUNDLE,"REASON_UNKNOWN");
         }
      }
      
      public static function formatOfferTotalPrice(param1:Offer, ... rest) : String
      {
         return i18nFormatNumber(param1.totalPrice);
      }
      
      public static function compareOfferByItemName(param1:Object, param2:Object, param3:Array = null) : int
      {
         var _loc4_:Offer = param1 as Offer;
         var _loc5_:Offer = param2 as Offer;
         if(_loc4_ == null || _loc5_ == null)
         {
            return 0;
         }
         var _loc6_:AppearanceStorage = Tibia.s_GetAppearanceStorage();
         if(_loc6_ == null)
         {
            return 0;
         }
         var _loc7_:AppearanceType = _loc6_.getMarketObjectType(_loc4_.typeID);
         var _loc8_:AppearanceType = _loc6_.getMarketObjectType(_loc5_.typeID);
         if(_loc7_ == null || !_loc7_.isMarket || _loc8_ == null || !_loc8_.isMarket)
         {
            return 0;
         }
         if(_loc7_.marketNameLowerCase < _loc8_.marketNameLowerCase)
         {
            return -1;
         }
         if(_loc7_.marketNameLowerCase > _loc8_.marketNameLowerCase)
         {
            return 1;
         }
         if(_loc4_.typeID < _loc5_.typeID)
         {
            return -1;
         }
         if(_loc4_.typeID > _loc5_.typeID)
         {
            return 1;
         }
         return 0;
      }
      
      public static function preventNonNumericInput(param1:Event) : void
      {
         var _loc2_:TextInput = null;
         var _loc3_:String = null;
         var _loc4_:RegExp = null;
         if(param1 != null)
         {
            _loc2_ = param1.currentTarget as TextInput;
            if(_loc2_ == null)
            {
               return;
            }
            _loc3_ = null;
            if(param1 is KeyboardEvent && KeyboardEvent(param1).charCode != 0)
            {
               _loc3_ = String.fromCharCode(KeyboardEvent(param1).charCode);
            }
            else if(param1 is TextEvent)
            {
               _loc3_ = TextEvent(param1).text;
            }
            else
            {
               return;
            }
            _loc4_ = /[0-9]/;
            if(!_loc4_.test(_loc3_) || _loc3_ == "0" && _loc2_.selectionBeginIndex == 0)
            {
               param1.preventDefault();
               param1.stopImmediatePropagation();
            }
         }
      }
      
      public static function createFilter(param1:Object) : Function
      {
         var a_Filter:Object = param1;
         return closure({"filter":a_Filter},function(param1:*):Boolean
         {
            var _loc2_:* = undefined;
            if(param1 == null)
            {
               return false;
            }
            for(_loc2_ in this["filter"])
            {
               if(!param1.hasOwnProperty(_loc2_) || param1[_loc2_] !== this["filter"][_loc2_])
               {
                  return false;
               }
            }
            return true;
         });
      }
      
      public static function formatOfferTerminationTimestamp(param1:Offer, ... rest) : String
      {
         return i18nFormatDate(new Date(param1.terminationTimestamp * 1000));
      }
      
      public static function formatOfferTypeID(param1:Offer, ... rest) : String
      {
         var _loc3_:AppearanceStorage = null;
         var _loc4_:AppearanceType = null;
         if(param1 != null && (_loc3_ = Tibia.s_GetAppearanceStorage()) != null && (_loc4_ = _loc3_.getMarketObjectType(param1.typeID)) != null)
         {
            return _loc4_.marketName;
         }
         var _loc5_:IResourceManager = ResourceManager.getInstance();
         return _loc5_.getString(MARKET_BUNDLE,"TYPE_UNKNOWN");
      }
      
      public static function compareAppearanceType(param1:Object, param2:Object, param3:Array = null) : int
      {
         var _loc4_:AppearanceType = param1 as AppearanceType;
         var _loc5_:AppearanceType = param2 as AppearanceType;
         if(_loc4_ != null && _loc4_.isMarket && _loc5_ != null && _loc5_.isMarket)
         {
            if(_loc4_.marketNameLowerCase < _loc5_.marketNameLowerCase)
            {
               return -1;
            }
            if(_loc4_.marketNameLowerCase > _loc5_.marketNameLowerCase)
            {
               return 1;
            }
            if(_loc4_.ID < _loc5_.ID)
            {
               return -1;
            }
            if(_loc4_.ID > _loc5_.ID)
            {
               return 1;
            }
         }
         return 0;
      }
   }
}
