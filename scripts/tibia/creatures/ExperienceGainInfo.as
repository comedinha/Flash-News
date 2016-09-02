package tibia.creatures
{
   import flash.events.EventDispatcher;
   import mx.events.PropertyChangeEvent;
   import mx.events.PropertyChangeEventKind;
   
   public class ExperienceGainInfo extends EventDispatcher
   {
       
      
      private var m_BaseXpGain:Number;
      
      private var m_CanBuyMoreStoreXpBoosts:Boolean;
      
      private var m_RemainingStoreXpBoostSeconds:uint;
      
      private var m_HuntingBoostFactor:Number;
      
      private var m_StoreBoostAddend:Number;
      
      private var m_VoucherAddend:Number;
      
      private var m_GrindingAddend:Number;
      
      public function ExperienceGainInfo()
      {
         super();
         this.reset();
      }
      
      public function get remaingStoreXpBoostSeconds() : uint
      {
         return this.m_RemainingStoreXpBoostSeconds;
      }
      
      public function get isStoreXpBoostPaused() : Boolean
      {
         return this.m_StoreBoostAddend == 0 && this.m_RemainingStoreXpBoostSeconds > 0;
      }
      
      public function get baseXpGain() : Number
      {
         return this.m_BaseXpGain;
      }
      
      public function get grindingAddend() : Number
      {
         return this.m_GrindingAddend;
      }
      
      public function updateStoreXpBoost(param1:uint, param2:Boolean) : void
      {
         var _loc3_:PropertyChangeEvent = null;
         if(param1 != this.m_RemainingStoreXpBoostSeconds || param2 != this.m_CanBuyMoreStoreXpBoosts)
         {
            this.m_RemainingStoreXpBoostSeconds = param1;
            this.m_CanBuyMoreStoreXpBoosts = param2;
            _loc3_ = new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE);
            _loc3_.kind = PropertyChangeEventKind.UPDATE;
            _loc3_.property = "storeXpBoost";
            dispatchEvent(_loc3_);
         }
      }
      
      public function reset() : void
      {
         this.m_BaseXpGain = 1;
         this.m_VoucherAddend = 0;
         this.m_GrindingAddend = 0;
         this.m_StoreBoostAddend = 0;
         this.m_HuntingBoostFactor = 1;
         this.m_RemainingStoreXpBoostSeconds = 0;
         this.m_CanBuyMoreStoreXpBoosts = true;
      }
      
      public function get canCurrentlyBuyXpBoost() : Boolean
      {
         return this.m_RemainingStoreXpBoostSeconds == 0 && this.m_CanBuyMoreStoreXpBoosts;
      }
      
      public function get huntingBoostFactor() : Number
      {
         return this.m_HuntingBoostFactor;
      }
      
      public function computeXpGainModifier() : Number
      {
         return (this.m_BaseXpGain + this.m_VoucherAddend + this.m_GrindingAddend + this.m_StoreBoostAddend) * this.m_HuntingBoostFactor;
      }
      
      public function get voucherAddend() : Number
      {
         return this.m_VoucherAddend;
      }
      
      public function get storeBoostAddend() : Number
      {
         return this.m_StoreBoostAddend;
      }
      
      public function updateGainInfo(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number) : void
      {
         var _loc6_:PropertyChangeEvent = null;
         if(param1 != this.m_BaseXpGain || param2 != this.m_VoucherAddend || param3 != this.m_GrindingAddend || param4 != this.m_StoreBoostAddend || param5 != this.m_HuntingBoostFactor)
         {
            this.m_BaseXpGain = param1;
            this.m_VoucherAddend = param2;
            this.m_GrindingAddend = param3;
            this.m_StoreBoostAddend = param4;
            this.m_HuntingBoostFactor = param5;
            _loc6_ = new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE);
            _loc6_.kind = PropertyChangeEventKind.UPDATE;
            _loc6_.property = "xpGain";
            dispatchEvent(_loc6_);
         }
      }
   }
}
