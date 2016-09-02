package tibia.premium
{
   import tibia.sidebar.Widget;
   
   public class PremiumWidget extends Widget
   {
       
      
      private var m_PremiumManager:tibia.premium.PremiumManager = null;
      
      public function PremiumWidget()
      {
         super();
         this.m_PremiumManager = Tibia.s_GetPremiumManager();
      }
      
      public function get premiumManager() : tibia.premium.PremiumManager
      {
         return this.m_PremiumManager;
      }
      
      override public function get closable() : Boolean
      {
         return this.m_PremiumManager != null && !this.m_PremiumManager.freePlayerLimitations;
      }
      
      override public function get draggable() : Boolean
      {
         return this.m_PremiumManager != null && !this.m_PremiumManager.freePlayerLimitations;
      }
   }
}
