package tibia.magic
{
   public class Magic
   {
       
      
      private var m_RestrictProfession:int = -1;
      
      private var m_CastMana:int = 0;
      
      private var m_DelaySecondary:int = 0;
      
      private var m_GroupSecondary:int = -1;
      
      private var m_ID:int = -1;
      
      private var m_GroupPrimary:int = -1;
      
      private var m_RestrictLevel:int = -1;
      
      private var m_DelayPrimary:int = 0;
      
      private var m_DelaySelf:int = 0;
      
      public function Magic(param1:int, param2:int, param3:int, param4:int, param5:int, param6:int, param7:int, param8:int, param9:int)
      {
         super();
         this.m_ID = param1;
         this.m_GroupPrimary = param2;
         this.m_GroupSecondary = param3;
         this.m_RestrictLevel = param4;
         this.m_RestrictProfession = param5;
         this.m_CastMana = param6;
         this.m_DelaySelf = param7;
         this.m_DelayPrimary = param8;
         this.m_DelaySecondary = param9;
      }
      
      public function get groupPrimary() : int
      {
         return this.m_GroupPrimary;
      }
      
      public function get ID() : int
      {
         return this.m_ID;
      }
      
      public function get restrictProfession() : int
      {
         return this.m_RestrictProfession;
      }
      
      public function get castMana() : int
      {
         return this.m_CastMana;
      }
      
      public function get restrictLevel() : int
      {
         return this.m_RestrictLevel;
      }
      
      public function get delaySelf() : int
      {
         return this.m_DelaySelf;
      }
      
      public function get delaySecondary() : int
      {
         return this.m_DelaySecondary;
      }
      
      public function get groupSecondary() : int
      {
         return this.m_GroupSecondary;
      }
      
      public function get delayPrimary() : int
      {
         return this.m_DelayPrimary;
      }
   }
}
