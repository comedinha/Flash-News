package mx.managers
{
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.Timer;
   import mx.controls.ToolTip;
   import mx.core.ApplicationGlobals;
   import mx.core.IInvalidating;
   import mx.core.IToolTip;
   import mx.core.IUIComponent;
   import mx.core.mx_internal;
   import mx.effects.EffectManager;
   import mx.effects.IAbstractEffect;
   import mx.events.EffectEvent;
   import mx.events.InterManagerRequest;
   import mx.events.ToolTipEvent;
   import mx.styles.IStyleClient;
   import mx.validators.IValidatorListener;
   
   use namespace mx_internal;
   
   public class ToolTipManagerImpl extends EventDispatcher implements IToolTipManager2
   {
      
      mx_internal static const VERSION:String = "3.6.0.21751";
      
      private static var instance:IToolTipManager2;
       
      
      private var _enabled:Boolean = true;
      
      private var _showDelay:Number = 500;
      
      private var _hideEffect:IAbstractEffect;
      
      mx_internal var hideTimer:Timer;
      
      private var _scrubDelay:Number = 100;
      
      private var _toolTipClass:Class;
      
      mx_internal var showTimer:Timer;
      
      private var sandboxRoot:IEventDispatcher = null;
      
      mx_internal var currentText:String;
      
      private var _currentToolTip:DisplayObject;
      
      mx_internal var scrubTimer:Timer;
      
      mx_internal var previousTarget:DisplayObject;
      
      private var _currentTarget:DisplayObject;
      
      private var systemManager:ISystemManager = null;
      
      private var _showEffect:IAbstractEffect;
      
      private var _hideDelay:Number = 10000;
      
      mx_internal var initialized:Boolean = false;
      
      mx_internal var isError:Boolean;
      
      public function ToolTipManagerImpl()
      {
         _toolTipClass = ToolTip;
         super();
         if(instance)
         {
            throw new Error("Instance already exists.");
         }
         this.systemManager = SystemManagerGlobals.topLevelSystemManagers[0] as ISystemManager;
         sandboxRoot = this.systemManager.getSandboxRoot();
         sandboxRoot.addEventListener(InterManagerRequest.TOOLTIP_MANAGER_REQUEST,marshalToolTipManagerHandler,false,0,true);
         var _loc1_:InterManagerRequest = new InterManagerRequest(InterManagerRequest.TOOLTIP_MANAGER_REQUEST);
         _loc1_.name = "update";
         sandboxRoot.dispatchEvent(_loc1_);
      }
      
      public static function getInstance() : IToolTipManager2
      {
         if(!instance)
         {
            instance = new ToolTipManagerImpl();
         }
         return instance;
      }
      
      mx_internal function systemManager_mouseDownHandler(param1:MouseEvent) : void
      {
         reset();
      }
      
      public function set showDelay(param1:Number) : void
      {
         _showDelay = param1;
      }
      
      mx_internal function showTimer_timerHandler(param1:TimerEvent) : void
      {
         if(currentTarget)
         {
            createTip();
            initializeTip();
            positionTip();
            showTip();
         }
      }
      
      mx_internal function hideEffectEnded() : void
      {
         var _loc1_:ToolTipEvent = null;
         reset();
         if(previousTarget)
         {
            _loc1_ = new ToolTipEvent(ToolTipEvent.TOOL_TIP_END);
            _loc1_.toolTip = currentToolTip;
            previousTarget.dispatchEvent(_loc1_);
         }
      }
      
      public function set scrubDelay(param1:Number) : void
      {
         _scrubDelay = param1;
      }
      
      public function get currentToolTip() : IToolTip
      {
         return _currentToolTip as IToolTip;
      }
      
      private function mouseIsOver(param1:DisplayObject) : Boolean
      {
         if(!param1 || !param1.stage)
         {
            return false;
         }
         if(param1.stage.mouseX == 0 && param1.stage.mouseY == 0)
         {
            return false;
         }
         return param1.hitTestPoint(param1.stage.mouseX,param1.stage.mouseY,true);
      }
      
      mx_internal function toolTipMouseOutHandler(param1:MouseEvent) : void
      {
         checkIfTargetChanged(param1.relatedObject);
      }
      
      public function get enabled() : Boolean
      {
         return _enabled;
      }
      
      public function createToolTip(param1:String, param2:Number, param3:Number, param4:String = null, param5:IUIComponent = null) : IToolTip
      {
         var _loc6_:ToolTip = new ToolTip();
         var _loc7_:ISystemManager = !!param5?param5.systemManager as ISystemManager:ApplicationGlobals.application.systemManager as ISystemManager;
         _loc7_.topLevelSystemManager.addChildToSandboxRoot("toolTipChildren",_loc6_ as DisplayObject);
         if(param4)
         {
            _loc6_.setStyle("styleName","errorTip");
            _loc6_.setStyle("borderStyle",param4);
         }
         _loc6_.text = param1;
         sizeTip(_loc6_);
         _loc6_.move(param2,param3);
         return _loc6_ as IToolTip;
      }
      
      mx_internal function reset() : void
      {
         var _loc1_:ISystemManager = null;
         showTimer.reset();
         hideTimer.reset();
         if(currentToolTip)
         {
            if(showEffect || hideEffect)
            {
               currentToolTip.removeEventListener(EffectEvent.EFFECT_END,effectEndHandler);
            }
            EffectManager.endEffectsForTarget(currentToolTip);
            _loc1_ = currentToolTip.systemManager as ISystemManager;
            _loc1_.topLevelSystemManager.removeChildFromSandboxRoot("toolTipChildren",currentToolTip as DisplayObject);
            currentToolTip = null;
            scrubTimer.delay = scrubDelay;
            scrubTimer.reset();
            if(scrubDelay > 0)
            {
               scrubTimer.delay = scrubDelay;
               scrubTimer.start();
            }
         }
      }
      
      public function set currentToolTip(param1:IToolTip) : void
      {
         _currentToolTip = param1 as DisplayObject;
         var _loc2_:InterManagerRequest = new InterManagerRequest(InterManagerRequest.TOOLTIP_MANAGER_REQUEST);
         _loc2_.name = "currentToolTip";
         _loc2_.value = param1;
         sandboxRoot.dispatchEvent(_loc2_);
      }
      
      public function get toolTipClass() : Class
      {
         return _toolTipClass;
      }
      
      private function hideImmediately(param1:DisplayObject) : void
      {
         checkIfTargetChanged(null);
      }
      
      mx_internal function showTip() : void
      {
         var _loc2_:ISystemManager = null;
         var _loc1_:ToolTipEvent = new ToolTipEvent(ToolTipEvent.TOOL_TIP_SHOW);
         _loc1_.toolTip = currentToolTip;
         currentTarget.dispatchEvent(_loc1_);
         if(isError)
         {
            currentTarget.addEventListener("change",changeHandler);
         }
         else
         {
            _loc2_ = getSystemManager(currentTarget);
            _loc2_.addEventListener(MouseEvent.MOUSE_DOWN,systemManager_mouseDownHandler);
         }
         currentToolTip.visible = true;
         if(!showEffect)
         {
            showEffectEnded();
         }
      }
      
      mx_internal function effectEndHandler(param1:EffectEvent) : void
      {
         if(param1.effectInstance.effect == showEffect)
         {
            showEffectEnded();
         }
         else if(param1.effectInstance.effect == hideEffect)
         {
            hideEffectEnded();
         }
      }
      
      public function get hideDelay() : Number
      {
         return _hideDelay;
      }
      
      public function get currentTarget() : DisplayObject
      {
         return _currentTarget;
      }
      
      mx_internal function showEffectEnded() : void
      {
         var _loc1_:ToolTipEvent = null;
         if(hideDelay == 0)
         {
            hideTip();
         }
         else if(hideDelay < Infinity)
         {
            hideTimer.delay = hideDelay;
            hideTimer.start();
         }
         if(currentTarget)
         {
            _loc1_ = new ToolTipEvent(ToolTipEvent.TOOL_TIP_SHOWN);
            _loc1_.toolTip = currentToolTip;
            currentTarget.dispatchEvent(_loc1_);
         }
      }
      
      public function get hideEffect() : IAbstractEffect
      {
         return _hideEffect;
      }
      
      mx_internal function changeHandler(param1:Event) : void
      {
         reset();
      }
      
      public function set enabled(param1:Boolean) : void
      {
         _enabled = param1;
      }
      
      mx_internal function errorTipMouseOverHandler(param1:MouseEvent) : void
      {
         checkIfTargetChanged(DisplayObject(param1.target));
      }
      
      public function get showDelay() : Number
      {
         return _showDelay;
      }
      
      public function get scrubDelay() : Number
      {
         return _scrubDelay;
      }
      
      public function registerErrorString(param1:DisplayObject, param2:String, param3:String) : void
      {
         if(!param2 && param3)
         {
            param1.addEventListener(MouseEvent.MOUSE_OVER,errorTipMouseOverHandler);
            param1.addEventListener(MouseEvent.MOUSE_OUT,errorTipMouseOutHandler);
            if(mouseIsOver(param1))
            {
               showImmediately(param1);
            }
         }
         else if(param2 && !param3)
         {
            param1.removeEventListener(MouseEvent.MOUSE_OVER,errorTipMouseOverHandler);
            param1.removeEventListener(MouseEvent.MOUSE_OUT,errorTipMouseOutHandler);
            if(mouseIsOver(param1))
            {
               hideImmediately(param1);
            }
         }
      }
      
      mx_internal function initialize() : void
      {
         if(!showTimer)
         {
            showTimer = new Timer(0,1);
            showTimer.addEventListener(TimerEvent.TIMER,showTimer_timerHandler);
         }
         if(!hideTimer)
         {
            hideTimer = new Timer(0,1);
            hideTimer.addEventListener(TimerEvent.TIMER,hideTimer_timerHandler);
         }
         if(!scrubTimer)
         {
            scrubTimer = new Timer(0,1);
         }
         initialized = true;
      }
      
      public function destroyToolTip(param1:IToolTip) : void
      {
         var _loc2_:ISystemManager = param1.systemManager as ISystemManager;
         _loc2_.topLevelSystemManager.removeChildFromSandboxRoot("toolTipChildren",DisplayObject(param1));
      }
      
      mx_internal function checkIfTargetChanged(param1:DisplayObject) : void
      {
         if(!enabled)
         {
            return;
         }
         findTarget(param1);
         if(currentTarget != previousTarget)
         {
            targetChanged();
            previousTarget = currentTarget;
         }
      }
      
      private function marshalToolTipManagerHandler(param1:Event) : void
      {
         var _loc2_:InterManagerRequest = null;
         if(param1 is InterManagerRequest)
         {
            return;
         }
         var _loc3_:Object = param1;
         switch(_loc3_.name)
         {
            case "currentToolTip":
               _currentToolTip = _loc3_.value;
               break;
            case ToolTipEvent.TOOL_TIP_HIDE:
               if(_currentToolTip is IToolTip)
               {
                  hideTip();
               }
               break;
            case "update":
               param1.stopImmediatePropagation();
               _loc2_ = new InterManagerRequest(InterManagerRequest.TOOLTIP_MANAGER_REQUEST);
               _loc2_.name = "currentToolTip";
               _loc2_.value = _currentToolTip;
               sandboxRoot.dispatchEvent(_loc2_);
         }
      }
      
      public function set toolTipClass(param1:Class) : void
      {
         _toolTipClass = param1;
      }
      
      private function getGlobalBounds(param1:DisplayObject, param2:DisplayObject) : Rectangle
      {
         var _loc3_:Point = new Point(0,0);
         _loc3_ = param1.localToGlobal(_loc3_);
         _loc3_ = param2.globalToLocal(_loc3_);
         return new Rectangle(_loc3_.x,_loc3_.y,param1.width,param1.height);
      }
      
      mx_internal function positionTip() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         var _loc5_:Rectangle = null;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:ISystemManager = null;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Point = null;
         var _loc3_:Number = currentToolTip.screen.width;
         var _loc4_:Number = currentToolTip.screen.height;
         if(isError)
         {
            _loc5_ = getGlobalBounds(currentTarget,currentToolTip.root);
            _loc1_ = _loc5_.right + 4;
            _loc2_ = _loc5_.top - 1;
            if(_loc1_ + currentToolTip.width > _loc3_)
            {
               _loc6_ = NaN;
               _loc7_ = NaN;
               _loc1_ = _loc5_.left - 2;
               if(_loc1_ + currentToolTip.width + 4 > _loc3_)
               {
                  _loc6_ = _loc3_ - _loc1_ - 4;
                  _loc7_ = Object(toolTipClass).maxWidth;
                  Object(toolTipClass).maxWidth = _loc6_;
                  if(currentToolTip is IStyleClient)
                  {
                     IStyleClient(currentToolTip).setStyle("borderStyle","errorTipAbove");
                  }
                  currentToolTip["text"] = currentToolTip["text"];
               }
               else
               {
                  if(currentToolTip is IStyleClient)
                  {
                     IStyleClient(currentToolTip).setStyle("borderStyle","errorTipAbove");
                  }
                  currentToolTip["text"] = currentToolTip["text"];
               }
               if(currentToolTip.height + 2 < _loc5_.top)
               {
                  _loc2_ = _loc5_.top - (currentToolTip.height + 2);
               }
               else
               {
                  _loc2_ = _loc5_.bottom + 2;
                  if(!isNaN(_loc6_))
                  {
                     Object(toolTipClass).maxWidth = _loc6_;
                  }
                  if(currentToolTip is IStyleClient)
                  {
                     IStyleClient(currentToolTip).setStyle("borderStyle","errorTipBelow");
                  }
                  currentToolTip["text"] = currentToolTip["text"];
               }
            }
            sizeTip(currentToolTip);
            if(!isNaN(_loc7_))
            {
               Object(toolTipClass).maxWidth = _loc7_;
            }
         }
         else
         {
            _loc8_ = getSystemManager(currentTarget);
            _loc1_ = DisplayObject(_loc8_).mouseX + 11;
            _loc2_ = DisplayObject(_loc8_).mouseY + 22;
            _loc9_ = currentToolTip.width;
            if(_loc1_ + _loc9_ > _loc3_)
            {
               _loc1_ = _loc3_ - _loc9_;
            }
            _loc10_ = currentToolTip.height;
            if(_loc2_ + _loc10_ > _loc4_)
            {
               _loc2_ = _loc4_ - _loc10_;
            }
            _loc11_ = new Point(_loc1_,_loc2_);
            _loc11_ = DisplayObject(_loc8_).localToGlobal(_loc11_);
            _loc11_ = DisplayObject(sandboxRoot).globalToLocal(_loc11_);
            _loc1_ = _loc11_.x;
            _loc2_ = _loc11_.y;
         }
         currentToolTip.move(_loc1_,_loc2_);
      }
      
      mx_internal function errorTipMouseOutHandler(param1:MouseEvent) : void
      {
         checkIfTargetChanged(param1.relatedObject);
      }
      
      mx_internal function findTarget(param1:DisplayObject) : void
      {
         while(param1)
         {
            if(param1 is IValidatorListener)
            {
               currentText = IValidatorListener(param1).errorString;
               if(currentText != null && currentText != "")
               {
                  currentTarget = param1;
                  isError = true;
                  return;
               }
            }
            if(param1 is IToolTipManagerClient)
            {
               currentText = IToolTipManagerClient(param1).toolTip;
               if(currentText != null)
               {
                  currentTarget = param1;
                  isError = false;
                  return;
               }
            }
            param1 = param1.parent;
         }
         currentText = null;
         currentTarget = null;
      }
      
      public function registerToolTip(param1:DisplayObject, param2:String, param3:String) : void
      {
         if(!param2 && param3)
         {
            param1.addEventListener(MouseEvent.MOUSE_OVER,toolTipMouseOverHandler);
            param1.addEventListener(MouseEvent.MOUSE_OUT,toolTipMouseOutHandler);
            if(mouseIsOver(param1))
            {
               showImmediately(param1);
            }
         }
         else if(param2 && !param3)
         {
            param1.removeEventListener(MouseEvent.MOUSE_OVER,toolTipMouseOverHandler);
            param1.removeEventListener(MouseEvent.MOUSE_OUT,toolTipMouseOutHandler);
            if(mouseIsOver(param1))
            {
               hideImmediately(param1);
            }
         }
      }
      
      private function showImmediately(param1:DisplayObject) : void
      {
         var _loc2_:Number = ToolTipManager.showDelay;
         ToolTipManager.showDelay = 0;
         checkIfTargetChanged(param1);
         ToolTipManager.showDelay = _loc2_;
      }
      
      public function set hideDelay(param1:Number) : void
      {
         _hideDelay = param1;
      }
      
      private function getSystemManager(param1:DisplayObject) : ISystemManager
      {
         return param1 is IUIComponent?IUIComponent(param1).systemManager:null;
      }
      
      public function set currentTarget(param1:DisplayObject) : void
      {
         _currentTarget = param1;
      }
      
      public function sizeTip(param1:IToolTip) : void
      {
         if(param1 is IInvalidating)
         {
            IInvalidating(param1).validateNow();
         }
         param1.setActualSize(param1.getExplicitOrMeasuredWidth(),param1.getExplicitOrMeasuredHeight());
      }
      
      public function set showEffect(param1:IAbstractEffect) : void
      {
         _showEffect = param1 as IAbstractEffect;
      }
      
      mx_internal function targetChanged() : void
      {
         var _loc1_:ToolTipEvent = null;
         var _loc2_:InterManagerRequest = null;
         if(!initialized)
         {
            initialize();
         }
         if(previousTarget && currentToolTip)
         {
            if(currentToolTip is IToolTip)
            {
               _loc1_ = new ToolTipEvent(ToolTipEvent.TOOL_TIP_HIDE);
               _loc1_.toolTip = currentToolTip;
               previousTarget.dispatchEvent(_loc1_);
            }
            else
            {
               _loc2_ = new InterManagerRequest(InterManagerRequest.TOOLTIP_MANAGER_REQUEST);
               _loc2_.name = ToolTipEvent.TOOL_TIP_HIDE;
               sandboxRoot.dispatchEvent(_loc2_);
            }
         }
         reset();
         if(currentTarget)
         {
            if(currentText == "")
            {
               return;
            }
            _loc1_ = new ToolTipEvent(ToolTipEvent.TOOL_TIP_START);
            currentTarget.dispatchEvent(_loc1_);
            if(showDelay == 0 || scrubTimer.running)
            {
               createTip();
               initializeTip();
               positionTip();
               showTip();
            }
            else
            {
               showTimer.delay = showDelay;
               showTimer.start();
            }
         }
      }
      
      public function set hideEffect(param1:IAbstractEffect) : void
      {
         _hideEffect = param1 as IAbstractEffect;
      }
      
      mx_internal function hideTimer_timerHandler(param1:TimerEvent) : void
      {
         hideTip();
      }
      
      mx_internal function initializeTip() : void
      {
         if(currentToolTip is IToolTip)
         {
            IToolTip(currentToolTip).text = currentText;
         }
         if(isError && currentToolTip is IStyleClient)
         {
            IStyleClient(currentToolTip).setStyle("styleName","errorTip");
         }
         sizeTip(currentToolTip);
         if(currentToolTip is IStyleClient)
         {
            if(showEffect)
            {
               IStyleClient(currentToolTip).setStyle("showEffect",showEffect);
            }
            if(hideEffect)
            {
               IStyleClient(currentToolTip).setStyle("hideEffect",hideEffect);
            }
         }
         if(showEffect || hideEffect)
         {
            currentToolTip.addEventListener(EffectEvent.EFFECT_END,effectEndHandler);
         }
      }
      
      public function get showEffect() : IAbstractEffect
      {
         return _showEffect;
      }
      
      mx_internal function toolTipMouseOverHandler(param1:MouseEvent) : void
      {
         checkIfTargetChanged(DisplayObject(param1.target));
      }
      
      mx_internal function hideTip() : void
      {
         var _loc1_:ToolTipEvent = null;
         var _loc2_:ISystemManager = null;
         if(previousTarget)
         {
            _loc1_ = new ToolTipEvent(ToolTipEvent.TOOL_TIP_HIDE);
            _loc1_.toolTip = currentToolTip;
            previousTarget.dispatchEvent(_loc1_);
         }
         if(currentToolTip)
         {
            currentToolTip.visible = false;
         }
         if(isError)
         {
            if(currentTarget)
            {
               currentTarget.removeEventListener("change",changeHandler);
            }
         }
         else if(previousTarget)
         {
            _loc2_ = getSystemManager(previousTarget);
            _loc2_.removeEventListener(MouseEvent.MOUSE_DOWN,systemManager_mouseDownHandler);
         }
         if(!hideEffect)
         {
            hideEffectEnded();
         }
      }
      
      mx_internal function createTip() : void
      {
         var _loc1_:ToolTipEvent = new ToolTipEvent(ToolTipEvent.TOOL_TIP_CREATE);
         currentTarget.dispatchEvent(_loc1_);
         if(_loc1_.toolTip)
         {
            currentToolTip = _loc1_.toolTip;
         }
         else
         {
            currentToolTip = new toolTipClass();
         }
         currentToolTip.visible = false;
         var _loc2_:ISystemManager = getSystemManager(currentTarget) as ISystemManager;
         _loc2_.topLevelSystemManager.addChildToSandboxRoot("toolTipChildren",currentToolTip as DisplayObject);
      }
   }
}
