package tibia.trade
{
   import tibia.sidebar.Widget;
   import mx.collections.IList;
   import tibia.trade.safeTradeWidgetClasses.SafeTradeWidgetView;
   import tibia.network.Communication;
   
   public class SafeTradeWidget extends Widget
   {
       
      
      protected var m_OtherItems:IList = null;
      
      protected var m_OtherName:String = null;
      
      protected var m_OwnItems:IList = null;
      
      protected var m_OwnName:String = null;
      
      public function SafeTradeWidget()
      {
         super();
      }
      
      public function set otherItems(param1:IList) : void
      {
         if(this.m_OtherItems != param1)
         {
            this.m_OtherItems = param1;
            if(m_ViewInstance is SafeTradeWidgetView)
            {
               SafeTradeWidgetView(m_ViewInstance).otherItems = this.m_OtherItems;
            }
         }
      }
      
      override public function close(param1:Boolean = false) : void
      {
         var _loc2_:Communication = null;
         if(param1 || closable && !closed)
         {
            _loc2_ = Tibia.s_GetCommunication();
            if(_loc2_ != null && _loc2_.isGameRunning)
            {
               _loc2_.sendCREJECTTRADE();
            }
         }
         super.close(param1);
      }
      
      public function set ownName(param1:String) : void
      {
         if(this.m_OwnName != param1)
         {
            this.m_OwnName = param1;
            if(m_ViewInstance is SafeTradeWidgetView)
            {
               SafeTradeWidgetView(m_ViewInstance).ownName = this.m_OwnName;
            }
         }
      }
      
      public function get otherItems() : IList
      {
         return this.m_OtherItems;
      }
      
      public function get ownName() : String
      {
         return this.m_OwnName;
      }
      
      public function set ownItems(param1:IList) : void
      {
         if(this.m_OwnItems != param1)
         {
            this.m_OwnItems = param1;
            if(m_ViewInstance is SafeTradeWidgetView)
            {
               SafeTradeWidgetView(m_ViewInstance).ownItems = this.m_OwnItems;
            }
         }
      }
      
      public function set otherName(param1:String) : void
      {
         if(this.m_OtherName != param1)
         {
            this.m_OtherName = param1;
            if(m_ViewInstance is SafeTradeWidgetView)
            {
               SafeTradeWidgetView(m_ViewInstance).otherName = this.m_OtherName;
            }
         }
      }
      
      public function get ownItems() : IList
      {
         return this.m_OwnItems;
      }
      
      public function get otherName() : String
      {
         return this.m_OtherName;
      }
   }
}
