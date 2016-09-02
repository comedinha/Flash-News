package tibia.ingameshop
{
   import flash.events.EventDispatcher;
   import tibia.network.Communication;
   
   public final class IngameShopManager extends EventDispatcher
   {
      
      private static var s_Instance:tibia.ingameshop.IngameShopManager = null;
      
      public static const STORE_EVENT_SELECT_OFFER:int = 0;
      
      public static const TIBIA_COINS_APPEARANCE_TYPE_ID:int = 22118;
       
      
      private var m_ImageManager:tibia.ingameshop.DynamicImageManager;
      
      private var m_CreditsAreFinal:Boolean = false;
      
      private var m_CurrentlyFeaturedServiceType:int = 0;
      
      private var m_Categories:Vector.<tibia.ingameshop.IngameShopCategory>;
      
      private var m_CanRequestNextTransactionHistoryPage:Boolean = false;
      
      private var m_History:Vector.<tibia.ingameshop.IngameShopHistoryEntry>;
      
      private var m_CreditBalance:Number = NaN;
      
      private var m_CurrentTransactionHistoryPage:int = 0;
      
      private var m_ConfirmedCreditBalance:Number = NaN;
      
      private var m_CreditPackageSize:Number = 25;
      
      public function IngameShopManager()
      {
         this.m_Categories = new Vector.<tibia.ingameshop.IngameShopCategory>();
         this.m_History = new Vector.<tibia.ingameshop.IngameShopHistoryEntry>();
         super();
      }
      
      public static function getInstance() : tibia.ingameshop.IngameShopManager
      {
         if(s_Instance == null)
         {
            s_Instance = new tibia.ingameshop.IngameShopManager();
         }
         return s_Instance;
      }
      
      public function canRequestNextHistoryPage() : Boolean
      {
         return this.m_CanRequestNextTransactionHistoryPage;
      }
      
      public function purchaseRegularOffer(param1:int) : void
      {
         var _loc2_:Communication = Tibia.s_GetCommunication();
         if(_loc2_ != null && _loc2_.isGameRunning)
         {
            _loc2_.sendCBUYPREMIUMOFFER(param1,IngameShopProduct.SERVICE_TYPE_UNKNOWN);
         }
      }
      
      private function recursiveSearchOffer(param1:int, param2:Vector.<tibia.ingameshop.IngameShopCategory>) : IngameShopOffer
      {
         var OfferList:Vector.<IngameShopOffer> = null;
         var a_OfferID:int = param1;
         var a_Categories:Vector.<tibia.ingameshop.IngameShopCategory> = param2;
         OfferList = new Vector.<IngameShopOffer>();
         this.recursiveVisitCategory(a_Categories,function(param1:IngameShopCategory):void
         {
            var _loc2_:int = 0;
            while(_loc2_ < param1.offers.length)
            {
               if(param1.offers[_loc2_].offerID == a_OfferID)
               {
                  OfferList.push(param1.offers[_loc2_]);
               }
               _loc2_++;
            }
         });
         return OfferList.length > 0?OfferList[0]:null;
      }
      
      public function creditsAreFinal() : Boolean
      {
         return this.m_CreditsAreFinal;
      }
      
      public function pageTransactionHistory(param1:int, param2:int) : void
      {
         var _loc3_:Communication = Tibia.s_GetCommunication();
         if(_loc3_ != null && _loc3_.isGameRunning)
         {
            _loc3_.sendCGETTRANSACTIONHISTORY(param1,param2);
         }
      }
      
      public function setCreditBalanceUpdating(param1:Boolean) : void
      {
         if(this.m_CreditsAreFinal != param1)
         {
            this.m_CreditsAreFinal = param1;
            dispatchEvent(new IngameShopEvent(IngameShopEvent.CREDIT_BALANCE_CHANGED));
         }
      }
      
      public function setupWithServerSettings(param1:String, param2:Number) : void
      {
         var _loc3_:String = param1.length > 0 && param1.charAt(param1.length - 1) != "/"?param1 + "/":param1;
         this.m_ImageManager = new tibia.ingameshop.DynamicImageManager(_loc3_,"igs-",60 * 60);
         this.m_CreditPackageSize = param2;
      }
      
      public function set currentlyFeaturedServiceType(param1:int) : void
      {
         var _loc2_:IngameShopEvent = null;
         if(param1 != this.m_CurrentlyFeaturedServiceType)
         {
            this.m_CurrentlyFeaturedServiceType = param1;
            _loc2_ = new IngameShopEvent(IngameShopEvent.CURRENTLY_FEATURED_SERVICE_TYPE_CHANGED);
            dispatchEvent(_loc2_);
         }
      }
      
      public function refreshTransactionHistory(param1:int) : void
      {
         if(this.getHistory().length > 0)
         {
            this.setHistory(0,false,new Vector.<tibia.ingameshop.IngameShopHistoryEntry>());
         }
         var _loc2_:Communication = Tibia.s_GetCommunication();
         if(_loc2_ != null && _loc2_.isGameRunning)
         {
            _loc2_.sendCOPENTRANSACTIONHISTORY(param1);
         }
      }
      
      private function recursiveVisitCategory(param1:Vector.<tibia.ingameshop.IngameShopCategory>, param2:Function) : void
      {
         var _loc3_:tibia.ingameshop.IngameShopCategory = null;
         for each(_loc3_ in param1)
         {
            param2(_loc3_);
            if(_loc3_.subCategories.length > 0)
            {
               this.recursiveVisitCategory(_loc3_.subCategories,param2);
            }
         }
      }
      
      public function get imageManager() : tibia.ingameshop.DynamicImageManager
      {
         return this.m_ImageManager;
      }
      
      public function getRootCategories() : Vector.<tibia.ingameshop.IngameShopCategory>
      {
         return this.m_Categories;
      }
      
      public function getHistory() : Vector.<tibia.ingameshop.IngameShopHistoryEntry>
      {
         return this.m_History;
      }
      
      public function propagateError(param1:String, param2:int) : void
      {
         var _loc3_:IngameShopEvent = new IngameShopEvent(IngameShopEvent.ERROR_RECEIVED);
         _loc3_.errorType = param2;
         _loc3_.message = param1;
         dispatchEvent(_loc3_);
      }
      
      public function setHistory(param1:int, param2:Boolean, param3:Vector.<tibia.ingameshop.IngameShopHistoryEntry>) : void
      {
         this.m_History = param3;
         this.m_CurrentTransactionHistoryPage = param1;
         this.m_CanRequestNextTransactionHistoryPage = param2;
         var _loc4_:IngameShopEvent = new IngameShopEvent(IngameShopEvent.HISTORY_CHANGED);
         dispatchEvent(_loc4_);
      }
      
      public function purchaseCharacterNameChange(param1:int, param2:String) : void
      {
         var _loc3_:Communication = Tibia.s_GetCommunication();
         if(_loc3_ != null && _loc3_.isGameRunning)
         {
            _loc3_.sendCBUYPREMIUMOFFER(param1,IngameShopProduct.SERVICE_TYPE_CHARACTER_NAME_CHANGE,param2);
         }
      }
      
      public function getHistoryPage() : int
      {
         return this.m_CurrentTransactionHistoryPage;
      }
      
      private function recursiveSearchCategory(param1:String, param2:Vector.<tibia.ingameshop.IngameShopCategory>) : tibia.ingameshop.IngameShopCategory
      {
         var _loc3_:tibia.ingameshop.IngameShopCategory = null;
         var _loc4_:tibia.ingameshop.IngameShopCategory = null;
         for each(_loc3_ in param2)
         {
            if(_loc3_.name == param1)
            {
               return _loc3_;
            }
            if(_loc3_.subCategories.length > 0)
            {
               _loc4_ = this.recursiveSearchCategory(param1,_loc3_.subCategories);
               if(_loc4_ != null)
               {
                  return _loc4_;
               }
            }
         }
         return null;
      }
      
      public function setCreditBalance(param1:Number, param2:Number) : void
      {
         if(this.m_CreditBalance != param1)
         {
            this.m_CreditBalance = param1;
            this.m_ConfirmedCreditBalance = param2;
            dispatchEvent(new IngameShopEvent(IngameShopEvent.CREDIT_BALANCE_CHANGED));
         }
      }
      
      public function requestNameForNameChange(param1:int) : void
      {
         var _loc2_:IngameShopEvent = new IngameShopEvent(IngameShopEvent.NAME_CHANGE_REQUESTED);
         _loc2_.data = param1;
         dispatchEvent(_loc2_);
      }
      
      public function getCreditBalance() : Number
      {
         return this.m_CreditBalance;
      }
      
      public function transferCredits(param1:String, param2:Number) : void
      {
         var _loc3_:Communication = Tibia.s_GetCommunication();
         if(_loc3_ != null && _loc3_.isGameRunning)
         {
            _loc3_.sendCTRANSFERCURRENCY(param1,param2);
         }
      }
      
      public function openShopWindow(param1:Boolean, param2:int, param3:Boolean = false) : void
      {
         var _loc4_:Communication = Tibia.s_GetCommunication();
         if(param1 && _loc4_ != null && (_loc4_.isGameRunning || param3))
         {
            this.m_Categories.length = 0;
            _loc4_.sendCOPENPREMIUMSHOP(param2,"");
            this.currentlyFeaturedServiceType = IngameShopProduct.SERVICE_TYPE_UNKNOWN;
         }
         else if(!param1)
         {
            if(IngameShopWidget.s_GetCurrentInstance() == null)
            {
               new IngameShopWidget().show();
            }
         }
      }
      
      public function completePurchase(param1:String) : void
      {
         var _loc2_:IngameShopEvent = new IngameShopEvent(IngameShopEvent.PURCHASE_COMPLETED);
         _loc2_.message = param1;
         dispatchEvent(_loc2_);
      }
      
      public function getCategory(param1:String) : tibia.ingameshop.IngameShopCategory
      {
         return this.recursiveSearchCategory(param1,this.m_Categories);
      }
      
      public function getConfirmedCreditBalance() : Number
      {
         return this.m_ConfirmedCreditBalance;
      }
      
      public function get currentlyFeaturedServiceType() : int
      {
         return this.m_CurrentlyFeaturedServiceType;
      }
      
      public function getCreditPackageSize() : Number
      {
         return this.m_CreditPackageSize;
      }
      
      public function addCategory(param1:tibia.ingameshop.IngameShopCategory, param2:String) : void
      {
         var _loc4_:tibia.ingameshop.IngameShopCategory = null;
         var _loc3_:tibia.ingameshop.IngameShopCategory = this.recursiveSearchCategory(param1.name,this.m_Categories);
         if(_loc3_ != null)
         {
            _loc3_.offers = param1.offers;
         }
         else if(param2 != null && param2.length > 0)
         {
            _loc4_ = this.recursiveSearchCategory(param2,this.m_Categories);
            if(_loc4_ != null)
            {
               _loc4_.subCategories.push(param1);
            }
            else
            {
               throw ArgumentError("IngameShopManager.addCategory: Invalid parent category " + param2);
            }
         }
         else
         {
            this.m_Categories.push(param1);
         }
      }
   }
}
