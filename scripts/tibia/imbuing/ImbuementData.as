package tibia.imbuing
{
   public class ImbuementData
   {
       
      
      private var m_IconID:uint = 0;
      
      private var m_Description:String;
      
      private var m_AstralSources:Vector.<AstralSource>;
      
      private var m_ID:uint = 0;
      
      private var m_Category:String;
      
      private var m_PremiumOnly:Boolean = false;
      
      private var m_SuccessRatePercent:Number = 0.0;
      
      private var m_ProtectionGoldCost:uint = 0;
      
      private var m_DurationInSeconds:uint = 0;
      
      private var m_Name:String;
      
      private var m_GoldCost:uint = 0;
      
      public function ImbuementData(param1:uint, param2:String)
      {
         this.m_AstralSources = new Vector.<AstralSource>();
         super();
         this.m_ID = param1;
         this.m_Name = param2;
      }
      
      public function set iconID(param1:uint) : void
      {
         this.m_IconID = param1;
      }
      
      public function set astralSources(param1:Vector.<AstralSource>) : void
      {
         this.m_AstralSources = param1;
      }
      
      public function get successRatePercent() : uint
      {
         return this.m_SuccessRatePercent;
      }
      
      public function set category(param1:String) : void
      {
         this.m_Category = param1;
      }
      
      public function set successRatePercent(param1:uint) : void
      {
         this.m_SuccessRatePercent = param1;
      }
      
      public function get category() : String
      {
         return this.m_Category;
      }
      
      public function get imbuementID() : uint
      {
         return this.m_ID;
      }
      
      public function get name() : String
      {
         return this.m_Name;
      }
      
      public function get goldCost() : uint
      {
         return this.m_GoldCost;
      }
      
      public function set description(param1:String) : void
      {
         this.m_Description = param1;
      }
      
      public function set durationInSeconds(param1:uint) : void
      {
         this.m_DurationInSeconds = param1;
      }
      
      public function get protectionGoldCost() : uint
      {
         return this.m_ProtectionGoldCost;
      }
      
      public function get iconID() : uint
      {
         return this.m_IconID;
      }
      
      public function get astralSources() : Vector.<AstralSource>
      {
         return this.m_AstralSources;
      }
      
      public function set premiumOnly(param1:Boolean) : void
      {
         this.m_PremiumOnly = param1;
      }
      
      public function set goldCost(param1:uint) : void
      {
         this.m_GoldCost = param1;
      }
      
      public function get premiumOnly() : Boolean
      {
         return this.m_PremiumOnly;
      }
      
      public function set protectionGoldCost(param1:uint) : void
      {
         this.m_ProtectionGoldCost = param1;
      }
      
      public function get durationInSeconds() : uint
      {
         return this.m_DurationInSeconds;
      }
      
      public function get description() : String
      {
         return this.m_Description;
      }
   }
}
