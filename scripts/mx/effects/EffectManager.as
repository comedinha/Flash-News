package mx.effects
{
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.FocusEvent;
   import flash.utils.Dictionary;
   import mx.core.ApplicationGlobals;
   import mx.core.EventPriority;
   import mx.core.IDeferredInstantiationUIComponent;
   import mx.core.IFlexDisplayObject;
   import mx.core.IUIComponent;
   import mx.core.UIComponent;
   import mx.core.UIComponentCachePolicy;
   import mx.core.mx_internal;
   import mx.events.EffectEvent;
   import mx.events.FlexEvent;
   import mx.events.MoveEvent;
   import mx.events.ResizeEvent;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   
   use namespace mx_internal;
   
   public class EffectManager extends EventDispatcher
   {
      
      private static var _resourceManager:IResourceManager;
      
      private static var effects:Dictionary = new Dictionary(true);
      
      mx_internal static var effectsPlaying:Array = [];
      
      private static var targetsInfo:Array = [];
      
      mx_internal static const VERSION:String = "3.6.0.21751";
      
      private static var effectTriggersForEvent:Object = {};
      
      mx_internal static var lastEffectCreated:Effect;
      
      private static var eventHandlingSuspendCount:Number = 0;
      
      private static var eventsForEffectTriggers:Object = {};
       
      
      public function EffectManager()
      {
         super();
      }
      
      public static function suspendEventHandling() : void
      {
         eventHandlingSuspendCount++;
      }
      
      mx_internal static function registerEffectTrigger(param1:String, param2:String) : void
      {
         var _loc3_:Number = NaN;
         if(param1 != "")
         {
            if(param2 == "")
            {
               _loc3_ = param1.length;
               if(_loc3_ > 6 && param1.substring(_loc3_ - 6) == "Effect")
               {
                  param2 = param1.substring(0,_loc3_ - 6);
               }
            }
            if(param2 != "")
            {
               effectTriggersForEvent[param2] = param1;
               eventsForEffectTriggers[param1] = param2;
            }
         }
      }
      
      private static function removedEffectHandler(param1:DisplayObject, param2:DisplayObjectContainer, param3:int, param4:Event) : void
      {
         suspendEventHandling();
         param2.addChildAt(param1,param3);
         resumeEventHandling();
         createAndPlayEffect(param4,param1);
      }
      
      private static function createAndPlayEffect(param1:Event, param2:Object) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc9_:String = null;
         var _loc10_:String = null;
         var _loc11_:Array = null;
         var _loc12_:Array = null;
         var _loc13_:Array = null;
         var _loc14_:Array = null;
         var _loc15_:EffectInstance = null;
         var _loc3_:Effect = createEffectForType(param2,param1.type);
         if(!_loc3_)
         {
            return;
         }
         if(_loc3_ is Zoom && param1.type == MoveEvent.MOVE)
         {
            _loc9_ = resourceManager.getString("effects","incorrectTrigger");
            throw new Error(_loc9_);
         }
         if(param2.initialized == false)
         {
            _loc10_ = param1.type;
            if(_loc10_ == MoveEvent.MOVE || _loc10_ == ResizeEvent.RESIZE || _loc10_ == FlexEvent.SHOW || _loc10_ == FlexEvent.HIDE || _loc10_ == Event.CHANGE)
            {
               _loc3_ = null;
               return;
            }
         }
         if(_loc3_.target is IUIComponent)
         {
            _loc11_ = IUIComponent(_loc3_.target).tweeningProperties;
            if(_loc11_ && _loc11_.length > 0)
            {
               _loc12_ = _loc3_.getAffectedProperties();
               _loc4_ = _loc11_.length;
               _loc6_ = _loc12_.length;
               _loc5_ = 0;
               while(_loc5_ < _loc4_)
               {
                  _loc7_ = 0;
                  while(_loc7_ < _loc6_)
                  {
                     if(_loc11_[_loc5_] == _loc12_[_loc7_])
                     {
                        _loc3_ = null;
                        return;
                     }
                     _loc7_++;
                  }
                  _loc5_++;
               }
            }
         }
         if(_loc3_.target is UIComponent && UIComponent(_loc3_.target).isEffectStarted)
         {
            _loc13_ = _loc3_.getAffectedProperties();
            _loc5_ = 0;
            while(_loc5_ < _loc13_.length)
            {
               _loc14_ = _loc3_.target.getEffectsForProperty(_loc13_[_loc5_]);
               if(_loc14_.length > 0)
               {
                  if(param1.type == ResizeEvent.RESIZE)
                  {
                     return;
                  }
                  _loc7_ = 0;
                  while(_loc7_ < _loc14_.length)
                  {
                     _loc15_ = _loc14_[_loc7_];
                     if(param1.type == FlexEvent.SHOW && _loc15_.hideOnEffectEnd)
                     {
                        _loc15_.target.removeEventListener(FlexEvent.SHOW,_loc15_.eventHandler);
                        _loc15_.hideOnEffectEnd = false;
                     }
                     _loc15_.end();
                     _loc7_++;
                  }
               }
               _loc5_++;
            }
         }
         _loc3_.triggerEvent = param1;
         _loc3_.addEventListener(EffectEvent.EFFECT_END,EffectManager.effectEndHandler);
         lastEffectCreated = _loc3_;
         var _loc8_:Array = _loc3_.play();
         _loc4_ = _loc8_.length;
         _loc5_ = 0;
         while(_loc5_ < _loc4_)
         {
            effectsPlaying.push(new EffectNode(_loc3_,_loc8_[_loc5_]));
            _loc5_++;
         }
         if(_loc3_.suspendBackgroundProcessing)
         {
            UIComponent.suspendBackgroundProcessing();
         }
      }
      
      public static function endEffectsForTarget(param1:IUIComponent) : void
      {
         var _loc4_:EffectInstance = null;
         var _loc2_:int = effectsPlaying.length;
         var _loc3_:int = _loc2_ - 1;
         while(_loc3_ >= 0)
         {
            _loc4_ = effectsPlaying[_loc3_].instance;
            if(_loc4_.target == param1)
            {
               _loc4_.end();
            }
            _loc3_--;
         }
      }
      
      private static function cacheOrUncacheTargetAsBitmap(param1:IUIComponent, param2:Boolean = true, param3:Boolean = true) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Object = null;
         _loc4_ = targetsInfo.length;
         _loc5_ = 0;
         while(_loc5_ < _loc4_)
         {
            if(targetsInfo[_loc5_].target == param1)
            {
               _loc6_ = targetsInfo[_loc5_];
               break;
            }
            _loc5_++;
         }
         if(!_loc6_)
         {
            _loc6_ = {
               "target":param1,
               "bitmapEffectsCount":0,
               "vectorEffectsCount":0
            };
            targetsInfo.push(_loc6_);
         }
         if(param2)
         {
            if(param3)
            {
               _loc6_.bitmapEffectsCount++;
               if(_loc6_.vectorEffectsCount == 0 && param1 is IDeferredInstantiationUIComponent)
               {
                  IDeferredInstantiationUIComponent(param1).cacheHeuristic = true;
               }
            }
            else if(_loc6_.vectorEffectsCount++ == 0 && param1 is IDeferredInstantiationUIComponent && IDeferredInstantiationUIComponent(param1).cachePolicy == UIComponentCachePolicy.AUTO)
            {
               param1.cacheAsBitmap = false;
            }
         }
         else
         {
            if(param3)
            {
               if(_loc6_.bitmapEffectsCount != 0)
               {
                  _loc6_.bitmapEffectsCount--;
               }
               if(param1 is IDeferredInstantiationUIComponent)
               {
                  IDeferredInstantiationUIComponent(param1).cacheHeuristic = false;
               }
            }
            else if(_loc6_.vectorEffectsCount != 0)
            {
               if(--_loc6_.vectorEffectsCount == 0 && _loc6_.bitmapEffectsCount != 0)
               {
                  _loc4_ = _loc6_.bitmapEffectsCount;
                  _loc5_ = 0;
                  while(_loc5_ < _loc4_)
                  {
                     if(param1 is IDeferredInstantiationUIComponent)
                     {
                        IDeferredInstantiationUIComponent(param1).cacheHeuristic = true;
                     }
                     _loc5_++;
                  }
               }
            }
            if(_loc6_.bitmapEffectsCount == 0 && _loc6_.vectorEffectsCount == 0)
            {
               _loc4_ = targetsInfo.length;
               _loc5_ = 0;
               while(_loc5_ < _loc4_)
               {
                  if(targetsInfo[_loc5_].target == param1)
                  {
                     targetsInfo.splice(_loc5_,1);
                     break;
                  }
                  _loc5_++;
               }
            }
         }
      }
      
      mx_internal static function eventHandler(param1:Event) : void
      {
         var _loc2_:FocusEvent = null;
         var _loc3_:DisplayObject = null;
         var _loc4_:int = 0;
         var _loc5_:DisplayObjectContainer = null;
         var _loc6_:int = 0;
         if(!(param1.currentTarget is IFlexDisplayObject))
         {
            return;
         }
         if(eventHandlingSuspendCount > 0)
         {
            return;
         }
         if(param1 is FocusEvent && (param1.type == FocusEvent.FOCUS_OUT || param1.type == FocusEvent.FOCUS_IN))
         {
            _loc2_ = FocusEvent(param1);
            if(_loc2_.relatedObject && (_loc2_.currentTarget.contains(_loc2_.relatedObject) || _loc2_.currentTarget == _loc2_.relatedObject))
            {
               return;
            }
         }
         if((param1.type == Event.ADDED || param1.type == Event.REMOVED) && param1.target != param1.currentTarget)
         {
            return;
         }
         if(param1.type == Event.REMOVED)
         {
            if(param1.target is UIComponent)
            {
               if(UIComponent(param1.target).initialized == false)
               {
                  return;
               }
               if(UIComponent(param1.target).isEffectStarted)
               {
                  _loc4_ = 0;
                  while(_loc4_ < UIComponent(param1.target)._effectsStarted.length)
                  {
                     if(UIComponent(param1.target)._effectsStarted[_loc4_].triggerEvent.type == Event.REMOVED)
                     {
                        return;
                     }
                     _loc4_++;
                  }
               }
            }
            _loc3_ = param1.target as DisplayObject;
            if(_loc3_ != null)
            {
               _loc5_ = _loc3_.parent as DisplayObjectContainer;
               if(_loc5_ != null)
               {
                  _loc6_ = _loc5_.getChildIndex(_loc3_);
                  if(_loc6_ >= 0)
                  {
                     if(_loc3_ is UIComponent)
                     {
                        UIComponent(_loc3_).callLater(removedEffectHandler,[_loc3_,_loc5_,_loc6_,param1]);
                     }
                  }
               }
            }
         }
         else
         {
            createAndPlayEffect(param1,param1.currentTarget);
         }
      }
      
      mx_internal static function endBitmapEffect(param1:IUIComponent) : void
      {
         cacheOrUncacheTargetAsBitmap(param1,false,true);
      }
      
      private static function animateSameProperty(param1:Effect, param2:Effect, param3:EffectInstance) : Boolean
      {
         var _loc4_:Array = null;
         var _loc5_:Array = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         if(param1.target == param3.target)
         {
            _loc4_ = param1.getAffectedProperties();
            _loc5_ = param2.getAffectedProperties();
            _loc6_ = _loc4_.length;
            _loc7_ = _loc5_.length;
            _loc8_ = 0;
            while(_loc8_ < _loc6_)
            {
               _loc9_ = 0;
               while(_loc9_ < _loc7_)
               {
                  if(_loc4_[_loc8_] == _loc5_[_loc9_])
                  {
                     return true;
                  }
                  _loc9_++;
               }
               _loc8_++;
            }
         }
         return false;
      }
      
      mx_internal static function effectFinished(param1:EffectInstance) : void
      {
         delete effects[param1];
      }
      
      mx_internal static function effectsInEffect() : Boolean
      {
         var _loc1_:* = undefined;
         for(_loc1_ in effects)
         {
            return true;
         }
         return false;
      }
      
      mx_internal static function effectEndHandler(param1:EffectEvent) : void
      {
         var _loc5_:DisplayObject = null;
         var _loc6_:DisplayObjectContainer = null;
         var _loc2_:IEffectInstance = param1.effectInstance;
         var _loc3_:int = effectsPlaying.length;
         var _loc4_:int = _loc3_ - 1;
         while(_loc4_ >= 0)
         {
            if(effectsPlaying[_loc4_].instance == _loc2_)
            {
               effectsPlaying.splice(_loc4_,1);
               break;
            }
            _loc4_--;
         }
         if(Object(_loc2_).hideOnEffectEnd == true)
         {
            _loc2_.target.removeEventListener(FlexEvent.SHOW,Object(_loc2_).eventHandler);
            _loc2_.target.setVisible(false,true);
         }
         if(_loc2_.triggerEvent && _loc2_.triggerEvent.type == Event.REMOVED)
         {
            _loc5_ = _loc2_.target as DisplayObject;
            if(_loc5_ != null)
            {
               _loc6_ = _loc5_.parent as DisplayObjectContainer;
               if(_loc6_ != null)
               {
                  suspendEventHandling();
                  _loc6_.removeChild(_loc5_);
                  resumeEventHandling();
               }
            }
         }
         if(_loc2_.suspendBackgroundProcessing)
         {
            UIComponent.resumeBackgroundProcessing();
         }
      }
      
      mx_internal static function startBitmapEffect(param1:IUIComponent) : void
      {
         cacheOrUncacheTargetAsBitmap(param1,true,true);
      }
      
      mx_internal static function setStyle(param1:String, param2:*) : void
      {
         var _loc3_:String = eventsForEffectTriggers[param1];
         if(_loc3_ != null && _loc3_ != "")
         {
            param2.addEventListener(_loc3_,EffectManager.eventHandler,false,EventPriority.EFFECT);
         }
      }
      
      mx_internal static function getEventForEffectTrigger(param1:String) : String
      {
         var effectTrigger:String = param1;
         if(eventsForEffectTriggers)
         {
            try
            {
               return eventsForEffectTriggers[effectTrigger];
            }
            catch(e:Error)
            {
               return "";
            }
            return "";
         }
         return "";
      }
      
      mx_internal static function createEffectForType(param1:Object, param2:String) : Effect
      {
         var cls:Class = null;
         var effectObj:Effect = null;
         var doc:Object = null;
         var target:Object = param1;
         var type:String = param2;
         var trigger:String = effectTriggersForEvent[type];
         if(trigger == "")
         {
            trigger = type + "Effect";
         }
         var value:Object = target.getStyle(trigger);
         if(!value)
         {
            return null;
         }
         if(value is Class)
         {
            cls = Class(value);
            return new cls(target);
         }
         try
         {
            if(value is String)
            {
               doc = target.parentDocument;
               if(!doc)
               {
                  doc = ApplicationGlobals.application;
               }
               effectObj = doc[value];
            }
            else if(value is Effect)
            {
               effectObj = Effect(value);
            }
            if(effectObj)
            {
               effectObj.target = target;
               return effectObj;
            }
         }
         catch(e:Error)
         {
         }
         var effectClass:Class = Class(target.systemManager.getDefinitionByName("mx.effects." + value));
         if(effectClass)
         {
            return new effectClass(target);
         }
         return null;
      }
      
      mx_internal static function effectStarted(param1:EffectInstance) : void
      {
         effects[param1] = 1;
      }
      
      public static function resumeEventHandling() : void
      {
         eventHandlingSuspendCount--;
      }
      
      mx_internal static function startVectorEffect(param1:IUIComponent) : void
      {
         cacheOrUncacheTargetAsBitmap(param1,true,false);
      }
      
      mx_internal static function endVectorEffect(param1:IUIComponent) : void
      {
         cacheOrUncacheTargetAsBitmap(param1,false,false);
      }
      
      private static function get resourceManager() : IResourceManager
      {
         if(!_resourceManager)
         {
            _resourceManager = ResourceManager.getInstance();
         }
         return _resourceManager;
      }
   }
}

import mx.effects.Effect;
import mx.effects.EffectInstance;

class EffectNode
{
    
   
   public var factory:Effect;
   
   public var instance:EffectInstance;
   
   function EffectNode(param1:Effect, param2:EffectInstance)
   {
      super();
      this.factory = param1;
      this.instance = param2;
   }
}
