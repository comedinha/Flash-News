package tibia.sidebar
{
   import tibia.sidebar.sideBarWidgetClasses.WidgetView;
   import tibia.sidebar.sideBarWidgetClasses.CombatControlWidgetView;
   import tibia.creatures.Player;
   
   public class CombatControlWidget extends Widget
   {
       
      
      protected var m_Player:Player = null;
      
      public function CombatControlWidget()
      {
         super();
      }
      
      override public function acquireViewInstance(param1:Boolean = true) : WidgetView
      {
         options = Tibia.s_GetOptions();
         this.player = Tibia.s_GetPlayer();
         var _loc2_:CombatControlWidgetView = super.acquireViewInstance(param1) as CombatControlWidgetView;
         if(_loc2_ != null)
         {
            _loc2_.options = m_Options;
            _loc2_.player = this.m_Player;
         }
         return _loc2_;
      }
      
      public function get player() : Player
      {
         return this.m_Player;
      }
      
      public function set player(param1:Player) : void
      {
         if(this.m_Player != param1)
         {
            this.m_Player = param1;
            if(m_ViewInstance is CombatControlWidgetView)
            {
               CombatControlWidgetView(m_ViewInstance).player = this.m_Player;
            }
         }
      }
      
      override public function releaseViewInstance() : void
      {
         options = null;
         this.player = null;
         super.releaseViewInstance();
      }
   }
}
