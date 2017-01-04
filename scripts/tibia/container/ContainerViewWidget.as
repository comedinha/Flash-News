package tibia.container
{
   import tibia.container.containerViewWidgetClasses.ContainerViewWidgetView;
   import tibia.network.Communication;
   import tibia.sidebar.Widget;
   import tibia.sidebar.sideBarWidgetClasses.WidgetView;
   
   public class ContainerViewWidget extends Widget
   {
       
      
      protected var m_Container:ContainerView = null;
      
      public function ContainerViewWidget()
      {
         super();
      }
      
      override public function acquireViewInstance(param1:Boolean = true) : WidgetView
      {
         options = Tibia.s_GetOptions();
         var _loc2_:WidgetView = super.acquireViewInstance(param1);
         if(_loc2_ is ContainerViewWidgetView)
         {
            _loc2_.options = options;
            ContainerViewWidgetView(_loc2_).container = this.m_Container;
         }
         return _loc2_;
      }
      
      public function get container() : ContainerView
      {
         return this.m_Container;
      }
      
      public function set container(param1:ContainerView) : void
      {
         if(this.m_Container != param1)
         {
            this.m_Container = param1;
            if(m_ViewInstance is ContainerViewWidgetView)
            {
               ContainerViewWidgetView(m_ViewInstance).container = this.m_Container;
            }
         }
      }
      
      override public function close(param1:Boolean = false) : void
      {
         var _loc2_:Communication = null;
         if(param1 || closable && !closed)
         {
            if(this.m_Container != null)
            {
               m_Closed = true;
               if(m_ViewInstance != null)
               {
                  m_ViewInstance.widgetClosed = m_Closed;
               }
               _loc2_ = Tibia.s_GetCommunication();
               if(_loc2_ != null && _loc2_.isGameRunning)
               {
                  _loc2_.sendCCLOSECONTAINER(this.m_Container.ID);
               }
            }
            else
            {
               super.close(param1);
            }
         }
      }
      
      override public function releaseViewInstance() : void
      {
         this.container = null;
         super.releaseViewInstance();
      }
   }
}
