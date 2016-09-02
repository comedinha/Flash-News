package tibia.market
{
   public class Offer
   {
      
      public static const BUY_OFFER:int = 0;
      
      public static const EXPIRED:int = 2;
      
      public static const ACTIVE:int = 0;
      
      public static const ACCEPTED:int = 3;
      
      public static const SELL_OFFER:int = 1;
      
      public static const CANCELLED:int = 1;
       
      
      private var m_OfferID:tibia.market.OfferID = null;
      
      private var m_Kind:int = 0;
      
      private var m_TypeID:int = 0;
      
      private var m_Amount:int = 0;
      
      public var isDubious:Boolean = false;
      
      private var m_PiecePrice:uint = 0;
      
      private var m_TerminationReason:int = 0;
      
      private var m_Character:String = null;
      
      public function Offer(param1:tibia.market.OfferID, param2:int, param3:int, param4:int, param5:int, param6:String, param7:int)
      {
         super();
         if(param1 == null)
         {
            throw new ArgumentError("Offer.Offer: Invalid offer ID.");
         }
         this.m_OfferID = param1;
         if(param2 != BUY_OFFER && param2 != SELL_OFFER)
         {
            throw new ArgumentError("Offer.Offer: Invalid kind " + param2 + ".");
         }
         this.m_Kind = param2;
         this.m_TypeID = param3;
         this.m_Amount = param4;
         this.m_PiecePrice = param5;
         this.m_Character = param6;
         if(param7 != ACTIVE && param7 != CANCELLED && param7 != EXPIRED && param7 != ACCEPTED)
         {
            throw new ArgumentError("Offer.Offer: Invalid termination reason " + param7 + ".");
         }
         this.m_TerminationReason = param7;
      }
      
      public function get typeID() : int
      {
         return this.m_TypeID;
      }
      
      public function get amount() : int
      {
         return this.m_Amount;
      }
      
      public function get kind() : int
      {
         return this.m_Kind;
      }
      
      public function isLessThan(param1:Offer) : Boolean
      {
         return this.m_OfferID.isLessThan(param1.m_OfferID);
      }
      
      public function get totalPrice() : uint
      {
         return this.m_Amount * this.m_PiecePrice;
      }
      
      public function get terminationReason() : int
      {
         return this.m_TerminationReason;
      }
      
      public function get character() : String
      {
         return this.m_Character;
      }
      
      public function isEqual(param1:Offer) : Boolean
      {
         return this.m_OfferID.isEqual(param1.m_OfferID);
      }
      
      public function get terminationTimestamp() : uint
      {
         return this.m_OfferID.timestamp;
      }
      
      public function get piecePrice() : uint
      {
         return this.m_PiecePrice;
      }
      
      public function get offerID() : tibia.market.OfferID
      {
         return this.m_OfferID;
      }
   }
}
