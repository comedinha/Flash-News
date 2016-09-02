package tibia.sessiondump.controller
{
   import mx.core.Container;
   import mx.managers.ISystemManager;
   import flash.utils.setTimeout;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import tibia.game.PopUpBase;
   import tibia.help.GUIRectangle;
   import flash.events.MouseEvent;
   import tibia.cursors.DefaultRejectCursor;
   import mx.core.UIComponent;
   import mx.effects.Sequence;
   import flash.geom.Rectangle;
   import mx.effects.Fade;
   import tibia.cursors.CursorHelper;
   import flash.display.BlendMode;
   import mx.containers.Box;
   import mx.effects.Pause;
   import mx.managers.CursorManagerPriority;
   
   public class SessiondumpMouseShield extends Container
   {
      
      private static var s_Instance:tibia.sessiondump.controller.SessiondumpMouseShield = null;
      
      private static const BUNDLE:String = "Global";
       
      
      private var m_UIEmbeddedMouseShield:UIComponent = null;
      
      private var m_FadeSequence:Sequence;
      
      private var m_MouseShieldRegion:Rectangle;
      
      private var m_IsShown:Boolean = false;
      
      private var m_CursorHelper:CursorHelper;
      
      private var m_FadeAnimationRequested:Boolean = false;
      
      private var m_FullyTransparent:Boolean = false;
      
      private var m_MouseShieldHoles:Vector.<GUIRectangle>;
      
      private var m_CaptureMouse:Boolean = true;
      
      private var m_ShowHintLabel:Boolean = true;
      
      public function SessiondumpMouseShield()
      {
         this.m_MouseShieldRegion = new Rectangle();
         this.m_MouseShieldHoles = new Vector.<GUIRectangle>();
         this.m_FadeSequence = new Sequence();
         this.m_CursorHelper = new CursorHelper(CursorManagerPriority.MEDIUM);
         super();
         this.blendMode == BlendMode.LAYER;
         mouseChildren = false;
      }
      
      public static function getInstance() : tibia.sessiondump.controller.SessiondumpMouseShield
      {
         if(s_Instance == null)
         {
            s_Instance = new tibia.sessiondump.controller.SessiondumpMouseShield();
         }
         return s_Instance;
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
            this.setMouseCapture(false);
            _loc2_.popUpChildren.removeChild(this);
            this.m_CursorHelper.resetCursor();
            Tibia.s_GetInstance().m_UITibiaRootContainer.removeEventListener(Event.RESIZE,this.onResize);
            Tibia.s_GetSecondaryTimer().removeEventListener(TimerEvent.TIMER,this.onTimer);
            Tibia.s_GetInstance().removeEventListener(Event.ACTIVATE,this.onActiveChanged);
            Tibia.s_GetInstance().removeEventListener(Event.DEACTIVATE,this.onActiveChanged);
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
      
      public function set captureMouse(param1:Boolean) : void
      {
         this.m_CaptureMouse = param1;
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         var _GUIRectangle:* = undefined;
         var a_UnscaledWidth:Number = param1;
         var a_UnscaledHeight:Number = param2;
         super.updateDisplayList(a_UnscaledWidth,a_UnscaledHeight);
         this.m_UIEmbeddedMouseShield.x = 0;
         this.m_UIEmbeddedMouseShield.y = 0;
         with(_loc4_)
         {
            
            clear();
            beginFill(0,1);
            drawRect(0,0,a_UnscaledWidth,a_UnscaledHeight);
            for each(_GUIRectangle in m_MouseShieldHoles)
            {
               if(_GUIRectangle.rectangle != null)
               {
                  drawRect(_GUIRectangle.rectangle.x,_GUIRectangle.rectangle.y,_GUIRectangle.rectangle.width,_GUIRectangle.rectangle.height);
               }
            }
            endFill();
         }
      }
      
      public function get isShown() : Boolean
      {
         return this.m_IsShown;
      }
      
      public function reset() : void
      {
         this.endFadeAnimation();
         this.clearMouseHoles();
      }
      
      public function refreshMouseHoles() : void
      {
         var _loc1_:GUIRectangle = null;
         for each(_loc1_ in this.m_MouseShieldHoles)
         {
            _loc1_.refresh();
         }
      }
      
      private function onMouseEvent(param1:MouseEvent) : void
      {
         if(param1.type == MouseEvent.ROLL_OVER)
         {
            this.m_CursorHelper.setCursor(DefaultRejectCursor);
         }
         else if(param1.type == MouseEvent.ROLL_OUT)
         {
            this.m_CursorHelper.resetCursor();
         }
      }
      
      public function endFadeAnimation(param1:Boolean = true) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Fade = null;
         if(this.m_FadeSequence != null)
         {
            _loc2_ = this.m_UIEmbeddedMouseShield.alpha;
            _loc3_ = new Fade();
            _loc3_.alphaFrom = _loc2_;
            _loc3_.alphaTo = 0;
            _loc3_.duration = 400;
            _loc3_.target = this.m_UIEmbeddedMouseShield;
            this.m_FadeSequence.end();
            this.m_UIEmbeddedMouseShield.alpha = _loc2_;
            _loc3_.play();
         }
         if(param1)
         {
            this.m_FadeAnimationRequested = false;
         }
      }
      
      public function set fullyTransparent(param1:Boolean) : void
      {
         if(this.m_FullyTransparent != param1)
         {
            this.m_FullyTransparent = param1;
            invalidateDisplayList();
         }
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         var _loc1_:ISystemManager = null;
         if((_loc1_ = Tibia.s_GetInstance().systemManager) != null && _loc1_.stage != null)
         {
            this.m_UIEmbeddedMouseShield = new UIComponent();
            this.m_UIEmbeddedMouseShield.alpha = 0;
            this.addChild(this.m_UIEmbeddedMouseShield);
            this.blendMode = BlendMode.LAYER;
            this.m_UIEmbeddedMouseShield.blendMode = BlendMode.LAYER;
            _loc1_.deployMouseShields(true);
            this.m_UIEmbeddedMouseShield.addEventListener(MouseEvent.ROLL_OVER,this.onMouseEvent);
            this.m_UIEmbeddedMouseShield.addEventListener(MouseEvent.ROLL_OUT,this.onMouseEvent);
            this.addEventListener(MouseEvent.ROLL_OVER,this.onMouseEvent);
            this.addEventListener(MouseEvent.ROLL_OUT,this.onMouseEvent);
         }
         this.m_CursorHelper.setCursor(DefaultRejectCursor);
      }
      
      private function setMouseCapture(param1:Boolean) : void
      {
         var _loc2_:ISystemManager = Tibia.s_GetInstance().systemManager;
         var _loc3_:String = null;
         var _loc4_:Array = new Array(MouseEvent.MOUSE_WHEEL,MouseEvent.ROLL_OVER,MouseEvent.ROLL_OUT,MouseEvent.MOUSE_MOVE,MouseEvent.MOUSE_DOWN,MouseEvent.RIGHT_MOUSE_DOWN,MouseEvent.MIDDLE_MOUSE_DOWN,MouseEvent.MOUSE_UP,MouseEvent.RIGHT_MOUSE_UP,MouseEvent.MIDDLE_MOUSE_UP,MouseEvent.CLICK,MouseEvent.RIGHT_CLICK,MouseEvent.MIDDLE_CLICK,MouseEvent.DOUBLE_CLICK);
         if(param1)
         {
            for each(_loc3_ in _loc4_)
            {
               _loc2_.addEventListener(_loc3_,this.onMouseEvent,true,int.MAX_VALUE);
            }
         }
         else
         {
            for each(_loc3_ in _loc4_)
            {
               _loc2_.removeEventListener(_loc3_,this.onMouseEvent,true);
            }
         }
      }
      
      public function addMouseHole(param1:GUIRectangle) : void
      {
         this.m_MouseShieldHoles.push(param1);
         invalidateDisplayList();
      }
      
      override protected function measure() : void
      {
         var _loc1_:Box = null;
         super.measure();
         _loc1_ = Tibia.s_GetInstance().m_UITibiaRootContainer;
         if(_loc1_ != null)
         {
            measuredMinHeight = _loc1_.height;
            measuredHeight = _loc1_.height;
            measuredMinWidth = Math.max(measuredMinWidth,_loc1_.width);
            measuredWidth = Math.max(measuredWidth,_loc1_.width);
            this.m_MouseShieldRegion.setTo(0,0,measuredWidth,measuredHeight);
            this.refreshMouseHoles();
         }
      }
      
      public function set showHintLabel(param1:Boolean) : void
      {
         if(this.m_ShowHintLabel != param1)
         {
            this.m_ShowHintLabel = param1;
            invalidateDisplayList();
         }
      }
      
      public function get fullyTransparent() : Boolean
      {
         return this.m_FullyTransparent;
      }
      
      private function onTimer(param1:Event) : void
      {
         this.refreshMouseHoles();
         invalidateDisplayList();
      }
      
      private function onActiveChanged(param1:Event) : void
      {
         if(this.m_FadeAnimationRequested)
         {
            if(param1.type == Event.ACTIVATE)
            {
               this.startFadeAnimation();
            }
            else if(param1.type == Event.DEACTIVATE)
            {
               this.endFadeAnimation(false);
            }
         }
      }
      
      public function startFadeAnimation(param1:uint = 10000) : void
      {
         this.m_FadeAnimationRequested = true;
         if(Tibia.s_GetInstance().isActive == false)
         {
            return;
         }
         if(this.m_FadeSequence != null)
         {
            this.m_FadeSequence.end();
         }
         this.m_FadeSequence = new Sequence();
         var _loc2_:Fade = new Fade();
         _loc2_.alphaFrom = 0;
         _loc2_.alphaTo = 0.7;
         _loc2_.duration = 700;
         this.m_FadeSequence.addChild(_loc2_);
         var _loc3_:Pause = new Pause();
         _loc3_.duration = 500;
         this.m_FadeSequence.addChild(_loc3_);
         _loc2_ = new Fade();
         _loc2_.alphaFrom = 0.7;
         _loc2_.alphaTo = 0;
         _loc2_.duration = 700;
         this.m_FadeSequence.addChild(_loc2_);
         _loc3_ = new Pause();
         _loc3_.duration = 3000;
         this.m_FadeSequence.addChild(_loc3_);
         this.m_FadeSequence.startDelay = param1;
         this.m_FadeSequence.repeatCount = int.MAX_VALUE;
         this.m_FadeSequence.target = this.m_UIEmbeddedMouseShield;
         this.m_FadeSequence.play();
      }
      
      public function get showHintLabel() : Boolean
      {
         return this.m_ShowHintLabel;
      }
      
      private function onResize(param1:Event) : void
      {
         this.refreshMouseHoles();
         invalidateDisplayList();
         invalidateSize();
      }
      
      public function clearMouseHoles() : void
      {
         this.m_MouseShieldHoles.length = 0;
         invalidateDisplayList();
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
            Tibia.s_GetInstance().m_UITibiaRootContainer.addEventListener(Event.RESIZE,this.onResize);
            Tibia.s_GetInstance().addEventListener(Event.ACTIVATE,this.onActiveChanged);
            Tibia.s_GetInstance().addEventListener(Event.DEACTIVATE,this.onActiveChanged);
            Tibia.s_GetSecondaryTimer().addEventListener(TimerEvent.TIMER,this.onTimer);
            this.m_IsShown = true;
         }
      }
      
      public function get captureMouse() : Boolean
      {
         return this.m_CaptureMouse;
      }
   }
}
