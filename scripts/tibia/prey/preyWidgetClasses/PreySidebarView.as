package tibia.prey.preyWidgetClasses
{
   import flash.events.MouseEvent;
   import mx.containers.VBox;
   import mx.core.ScrollPolicy;
   import mx.events.PropertyChangeEvent;
   import tibia.prey.PreyData;
   import tibia.prey.PreyManager;
   import tibia.prey.PreyWidget;
   import tibia.sidebar.sideBarWidgetClasses.WidgetView;
   
   public class PreySidebarView extends WidgetView
   {
      
      private static const BUNDLE:String = "PreyWidget";
       
      
      private var m_UIConstructed:Boolean = false;
      
      private var m_UncommittedPreyList:Boolean = true;
      
      private var m_UIBox:VBox = null;
      
      public function PreySidebarView()
      {
         super();
         titleText = resourceManager.getString(BUNDLE,"TITLE");
         verticalScrollPolicy = ScrollPolicy.OFF;
         horizontalScrollPolicy = ScrollPolicy.OFF;
         minHeight = PreyListRenderer.HEIGHT_HINT;
         PreyManager.getInstance().addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onPreyManagerDataChanged);
      }
      
      protected function onMouseClick(param1:MouseEvent) : void
      {
         PreyWidget.s_ShowIfAppropriate();
      }
      
      protected function onPreyManagerDataChanged(param1:PropertyChangeEvent) : void
      {
         if(param1.property == "prey")
         {
            this.m_UncommittedPreyList = true;
            invalidateProperties();
         }
      }
      
      override protected function commitProperties() : void
      {
         var _loc1_:Vector.<PreyData> = null;
         var _loc2_:int = 0;
         var _loc3_:PreyListRenderer = null;
         super.commitProperties();
         if(this.m_UncommittedPreyList)
         {
            _loc1_ = PreyManager.getInstance().preys;
            while(this.m_UIBox.getChildren().length != _loc1_.length)
            {
               if(this.m_UIBox.getChildren().length > _loc1_.length)
               {
                  this.m_UIBox.removeChildAt(this.m_UIBox.getChildren().length - 1);
               }
               else
               {
                  _loc3_ = new PreyListRenderer();
                  _loc3_.percentWidth = 100;
                  this.m_UIBox.addChild(_loc3_);
               }
            }
            _loc2_ = 0;
            while(_loc2_ < _loc1_.length && _loc2_ < this.m_UIBox.getChildren().length)
            {
               (this.m_UIBox.getChildAt(_loc2_) as PreyListRenderer).data = _loc1_[_loc2_];
               _loc2_++;
            }
            invalidateSize();
            invalidateDisplayList();
            this.m_UncommittedPreyList = false;
         }
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         if(!this.m_UIConstructed)
         {
            this.m_UIBox = new VBox();
            this.m_UIBox.percentHeight = 100;
            this.m_UIBox.percentWidth = 100;
            this.m_UIBox.addEventListener(MouseEvent.CLICK,this.onMouseClick);
            addChild(this.m_UIBox);
            this.m_UIConstructed = true;
         }
      }
   }
}
