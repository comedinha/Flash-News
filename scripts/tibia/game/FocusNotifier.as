package tibia.game
{
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.setTimeout;
   import mx.controls.Label;
   import mx.core.UIComponent;
   import mx.managers.ISystemManager;
   
   public class FocusNotifier extends UIComponent
   {
      
      private static var s_Instance:FocusNotifier = null;
      
      private static const BUNDLE:String = "Global";
       
      
      private var m_UILabel:Label = null;
      
      private var m_CaptureMouse:Boolean = false;
      
      private var m_IsShown:Boolean = false;
      
      public function FocusNotifier()
      {
         super();
         mouseEnabled = false;
      }
      
      public static function getInstance() : FocusNotifier
      {
         if(s_Instance == null)
         {
            s_Instance = new FocusNotifier();
         }
         return s_Instance;
      }
      
      override protected function measure() : void
      {
         super.measure();
         var _loc1_:DisplayObject = Tibia.s_GetInstance();
         if(_loc1_ != null)
         {
            measuredMinHeight = Math.max(measuredMinHeight,_loc1_.height);
            measuredHeight = Math.max(measuredHeight,_loc1_.height);
            measuredMinWidth = Math.max(measuredMinWidth,_loc1_.width);
            measuredWidth = Math.max(measuredWidth,_loc1_.width);
         }
      }
      
      public function get isShown() : Boolean
      {
         return this.m_IsShown;
      }
      
      public function hide(param1:Boolean = true) : void
      {
         var _loc2_:ISystemManager = null;
         if(this.captureMouse && param1)
         {
            setTimeout(this.hide,50,false);
         }
         else if(this.m_IsShown)
         {
            _loc2_ = Tibia.s_GetInstance().systemManager;
            _loc2_.removeEventListener(Event.RESIZE,this.onResize);
            _loc2_.removeEventListener(MouseEvent.MOUSE_DOWN,this.onMouseEvent);
            _loc2_.removeEventListener(MouseEvent.RIGHT_MOUSE_DOWN,this.onMouseEvent);
            _loc2_.removeChildFromSandboxRoot("popUpChildren",this);
            this.m_IsShown = false;
            if(Tibia.s_GetInputHandler() != null)
            {
               Tibia.s_GetInputHandler().captureKeyboard = true;
            }
            if(PopUpBase.getCurrent() != null)
            {
               PopUpBase.getCurrent().setFocus();
               PopUpBase.getCurrent().drawFocus(false);
            }
         }
      }
      
      private function onMouseEvent(param1:MouseEvent) : void
      {
         if(this.isShown && this.captureMouse)
         {
            param1.preventDefault();
         }
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         super.updateDisplayList(param1,param2);
         graphics.clear();
         if(getStyle("modalTransparencyColor") !== undefined)
         {
            _loc3_ = getStyle("modalTransparencyColor");
            _loc4_ = getStyle("modalTransparency");
            graphics.beginFill(_loc3_,_loc4_);
            graphics.drawRect(0,0,param1,param2);
            graphics.endFill();
         }
         if(this.m_UILabel != null)
         {
            _loc5_ = this.m_UILabel.getExplicitOrMeasuredHeight();
            _loc6_ = this.m_UILabel.getExplicitOrMeasuredWidth();
            this.m_UILabel.move((param1 - _loc6_) / 2,(param2 - _loc5_) / 4);
            this.m_UILabel.setActualSize(_loc6_,_loc5_);
         }
      }
      
      private function onResize(param1:Event) : void
      {
         invalidateDisplayList();
         invalidateSize();
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this.m_UILabel = new Label();
         this.m_UILabel.styleName = this;
         this.m_UILabel.text = resourceManager.getString(BUNDLE,"MSG_CLICK_TO_ACTIVATE");
         addChild(this.m_UILabel);
      }
      
      public function show() : void
      {
         var _loc1_:ISystemManager = null;
         if(!this.m_IsShown)
         {
            if(Tibia.s_GetInputHandler() != null)
            {
               Tibia.s_GetInputHandler().captureKeyboard = false;
            }
            _loc1_ = Tibia.s_GetInstance().systemManager;
            _loc1_.addChildToSandboxRoot("popUpChildren",this);
            _loc1_.addEventListener(Event.RESIZE,this.onResize);
            _loc1_.addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseEvent);
            _loc1_.addEventListener(MouseEvent.RIGHT_MOUSE_DOWN,this.onMouseEvent);
            this.m_IsShown = true;
         }
      }
      
      public function set captureMouse(param1:Boolean) : void
      {
         this.m_CaptureMouse = param1;
      }
      
      public function get captureMouse() : Boolean
      {
         return this.m_CaptureMouse;
      }
   }
}
