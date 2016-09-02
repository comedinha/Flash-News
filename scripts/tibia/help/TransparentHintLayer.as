package tibia.help
{
   import mx.core.Container;
   import flash.events.Event;
   import mx.managers.ISystemManager;
   import mx.containers.Box;
   
   public class TransparentHintLayer extends Container
   {
      
      private static var s_Instance:tibia.help.TransparentHintLayer = null;
       
      
      public function TransparentHintLayer()
      {
         super();
         this.mouseEnabled = false;
         this.mouseChildren = false;
      }
      
      public static function getInstance() : tibia.help.TransparentHintLayer
      {
         if(s_Instance == null)
         {
            s_Instance = new tibia.help.TransparentHintLayer();
         }
         return s_Instance;
      }
      
      private function onResize(param1:Event) : void
      {
         invalidateSize();
         invalidateDisplayList();
      }
      
      public function hide() : void
      {
         var _loc1_:ISystemManager = Tibia.s_GetInstance().systemManager;
         if(_loc1_.popUpChildren.contains(this))
         {
            _loc1_.popUpChildren.removeChild(this);
         }
         var _loc2_:Box = Tibia.s_GetInstance().m_UITibiaRootContainer;
         if(_loc2_ != null)
         {
            _loc2_.removeEventListener(Event.RESIZE,this.onResize);
         }
      }
      
      public function show() : void
      {
         var _loc1_:ISystemManager = Tibia.s_GetInstance().systemManager;
         _loc1_.popUpChildren.addChild(this);
         var _loc2_:Box = Tibia.s_GetInstance().m_UITibiaRootContainer;
         if(_loc2_ != null)
         {
            _loc2_.addEventListener(Event.RESIZE,this.onResize);
         }
      }
      
      override protected function measure() : void
      {
         super.measure();
         var _loc1_:Box = Tibia.s_GetInstance().m_UITibiaRootContainer;
         if(_loc1_ != null)
         {
            measuredMinHeight = _loc1_.height;
            measuredHeight = _loc1_.height;
            measuredMinWidth = Math.max(measuredMinWidth,_loc1_.width);
            measuredWidth = Math.max(measuredWidth,_loc1_.width);
         }
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         var unscaledWidth:Number = param1;
         var unscaledHeight:Number = param2;
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         with(this.graphics)
         {
            
            clear();
            beginFill(16711680,0);
            drawRect(0,0,unscaledWidth,unscaledHeight);
            endFill();
         }
      }
   }
}
