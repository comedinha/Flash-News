package tibia.ingameshop
{
   import flash.events.Event;
   
   public class IngameShopEvent extends Event
   {
      
      public static const HISTORY_CLICKED:String = "historyClicked";
      
      public static const ERROR_INFORMATION:int = 4;
      
      public static const HISTORY_CHANGED:String = "historyChanged";
      
      public static const CREDIT_BALANCE_CHANGED:String = "creditBalanceChanged";
      
      public static const OFFER_DEACTIVATED:String = "offerDeactivated";
      
      public static const IMAGE_CHANGED:String = "imageChanged";
      
      public static const CURRENTLY_FEATURED_SERVICE_TYPE_CHANGED:String = "currentlyFeaturedServiceTypeChanged";
      
      public static const CATEGORY_OFFERS_CHANGED:String = "categoryOffersChanged";
      
      public static const ERROR_RECEIVED:String = "shopError";
      
      public static const ERROR_TRANSACTION_HISTORY:int = 2;
      
      public static const ERROR_PURCHASE_FAILED:int = 0;
      
      public static const ERROR_NO_ERROR:int = -1;
      
      public static const PURCHASE_COMPLETED:String = "purchaseCompleted";
      
      public static const OFFER_ACTIVATED:String = "offerActivated";
      
      public static const NAME_CHANGE_REQUESTED:String = "nameChangeRequested";
      
      public static const ERROR_NETWORK:int = 1;
      
      public static const ERROR_TRANSFER_FAILED:int = 3;
      
      public static const CATEGORY_SELECTED:String = "categorySelected";
       
      
      private var m_ErrorType:int = -1;
      
      private var m_Message:String = null;
      
      private var m_Data:Object = null;
      
      public function IngameShopEvent(param1:String, param2:Boolean = false, param3:Boolean = false)
      {
         super(param1,param2,param3);
      }
      
      public function get errorType() : int
      {
         return this.m_ErrorType;
      }
      
      public function set errorType(param1:int) : void
      {
         this.m_ErrorType = param1;
      }
      
      public function get message() : String
      {
         return this.m_Message;
      }
      
      public function get data() : Object
      {
         return this.m_Data;
      }
      
      public function set message(param1:String) : void
      {
         this.m_Message = param1;
      }
      
      public function set data(param1:Object) : void
      {
         this.m_Data = param1;
      }
      
      override public function clone() : Event
      {
         var _loc1_:IngameShopEvent = new IngameShopEvent(type,bubbles,cancelable);
         _loc1_.m_Message = this.m_Message;
         _loc1_.m_ErrorType = this.m_ErrorType;
         _loc1_.m_Data = this.m_Data;
         return _loc1_;
      }
   }
}
