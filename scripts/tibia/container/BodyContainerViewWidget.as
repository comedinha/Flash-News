package tibia.container
{
   import tibia.container.bodyContainerViewWigdetClasses.BodyContainerViewWidgetView;
   import tibia.creatures.Player;
   import tibia.sidebar.Widget;
   import tibia.sidebar.sideBarWidgetClasses.WidgetView;
   
   public class BodyContainerViewWidget extends Widget
   {
       
      
      protected var m_Player:Player = null;
      
      protected var m_BodyContainer:BodyContainerView = null;
      
      public function BodyContainerViewWidget()
      {
         super();
      }
      
      override public function acquireViewInstance(param1:Boolean = true) : WidgetView
      {
         options = Tibia.s_GetOptions();
         if(type == Widget.TYPE_BODY)
         {
            this.bodyContainer = Tibia.s_GetContainerStorage().getBodyContainerView();
            this.player = Tibia.s_GetPlayer();
         }
         var _loc2_:WidgetView = super.acquireViewInstance(param1);
         if(_loc2_ is BodyContainerViewWidgetView)
         {
            _loc2_.options = options;
            BodyContainerViewWidgetView(_loc2_).bodyContainer = this.m_BodyContainer;
            BodyContainerViewWidgetView(_loc2_).player = this.m_Player;
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
            if(m_ViewInstance is BodyContainerViewWidgetView)
            {
               BodyContainerViewWidgetView(m_ViewInstance).player = this.m_Player;
            }
         }
      }
      
      override public function releaseViewInstance() : void
      {
         this.bodyContainer = null;
         this.player = null;
         super.releaseViewInstance();
      }
      
      public function set bodyContainer(param1:BodyContainerView) : void
      {
         if(this.m_BodyContainer != param1)
         {
            this.m_BodyContainer = param1;
            if(m_ViewInstance is BodyContainerViewWidgetView)
            {
               BodyContainerViewWidgetView(m_ViewInstance).bodyContainer = this.m_BodyContainer;
            }
         }
      }
      
      public function get bodyContainer() : BodyContainerView
      {
         return this.m_BodyContainer;
      }
   }
}
