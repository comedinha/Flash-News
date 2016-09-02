package tibia.ingameshop
{
   public class IngameShopHistoryEntry
   {
      
      public static const TRANSACTION_GIFT:int = 1;
      
      public static const TRANSACTION_PURCHASE_OR_CREDITCHANGE:int = 0;
      
      public static const TRANSACTION_REFUND:int = 2;
       
      
      private var m_Timestamp:Number;
      
      private var m_TransactionType:int;
      
      private var m_TransactionName:String;
      
      private var m_CreditChange:Number;
      
      public function IngameShopHistoryEntry(param1:Number, param2:Number, param3:int, param4:String)
      {
         super();
         this.m_Timestamp = param1;
         this.m_CreditChange = param2;
         this.m_TransactionType = param3;
         this.m_TransactionName = param4;
      }
      
      public function isRefund() : Boolean
      {
         return this.transactionType == TRANSACTION_REFUND;
      }
      
      public function get creditChange() : Number
      {
         return this.m_CreditChange;
      }
      
      public function get transactionName() : String
      {
         return this.m_TransactionName;
      }
      
      public function get timestamp() : Number
      {
         return this.m_Timestamp;
      }
      
      public function get transactionType() : int
      {
         return this.m_TransactionType;
      }
      
      public function isGift() : Boolean
      {
         return this.transactionType == TRANSACTION_GIFT;
      }
   }
}
