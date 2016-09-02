package tibia.creatures
{
   import tibia.sidebar.Widget;
   import tibia.sidebar.sideBarWidgetClasses.WidgetView;
   import tibia.creatures.battlelistWidgetClasses.BattlelistWidgetView;
   
   public class BattlelistWidget extends Widget
   {
       
      
      protected var m_CreatureStorage:tibia.creatures.CreatureStorage = null;
      
      public function BattlelistWidget()
      {
         super();
      }
      
      override public function acquireViewInstance(param1:Boolean = true) : WidgetView
      {
         options = Tibia.s_GetOptions();
         this.creatureStorage = Tibia.s_GetCreatureStorage();
         if(this.creatureStorage != null)
         {
            this.creatureStorage.setAim(null);
         }
         var _loc2_:BattlelistWidgetView = super.acquireViewInstance(param1) as BattlelistWidgetView;
         if(_loc2_ != null)
         {
            _loc2_.creatureStorage = this.m_CreatureStorage;
         }
         return _loc2_;
      }
      
      override public function releaseViewInstance() : void
      {
         options = null;
         if(this.creatureStorage != null)
         {
            this.creatureStorage.setAim(null);
            this.creatureStorage = null;
         }
         super.releaseViewInstance();
      }
      
      public function set creatureStorage(param1:tibia.creatures.CreatureStorage) : void
      {
         if(this.m_CreatureStorage != param1)
         {
            this.m_CreatureStorage = param1;
            if(m_ViewInstance is BattlelistWidgetView)
            {
               BattlelistWidgetView(m_ViewInstance).creatureStorage = this.m_CreatureStorage;
            }
         }
      }
      
      public function get creatureStorage() : tibia.creatures.CreatureStorage
      {
         return this.m_CreatureStorage;
      }
   }
}
