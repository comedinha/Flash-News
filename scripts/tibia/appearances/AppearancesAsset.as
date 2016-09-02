package tibia.appearances
{
   import tibia.game.Asset;
   
   public class AppearancesAsset extends Asset
   {
       
      
      private var m_AppearancesContentRevision:int;
      
      public function AppearancesAsset(param1:String, param2:int, param3:int)
      {
         super(param1,param2);
         this.m_AppearancesContentRevision = param3;
      }
      
      public function set contentRevision(param1:int) : void
      {
         this.m_AppearancesContentRevision = param1;
      }
      
      public function get contentRevision() : int
      {
         return this.m_AppearancesContentRevision;
      }
   }
}
