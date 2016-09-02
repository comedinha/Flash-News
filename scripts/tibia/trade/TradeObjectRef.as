package tibia.trade
{
   import tibia.appearances.AppearanceTypeRef;
   
   public class TradeObjectRef extends AppearanceTypeRef
   {
       
      
      public var weight:uint = 0;
      
      public var price:uint = 0;
      
      public var name:String = null;
      
      public var amount:uint = 0;
      
      public function TradeObjectRef(param1:int, param2:int, param3:String, param4:uint, param5:uint, param6:uint = 2.147483647E9)
      {
         super(param1,param2);
         this.name = param3;
         this.price = param4;
         this.weight = param5;
         this.amount = param6;
      }
      
      public function toString() : String
      {
         return "(" + ID + "," + data + " -- " + this.name + ", " + this.price + ", " + this.weight + ")";
      }
      
      override public function clone() : AppearanceTypeRef
      {
         return new TradeObjectRef(m_ID,m_Data,this.name,this.price,this.weight,this.amount);
      }
   }
}
