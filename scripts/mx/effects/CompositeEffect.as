package mx.effects
{
   import mx.core.mx_internal;
   import mx.effects.effectClasses.CompositeEffectInstance;
   import mx.effects.effectClasses.PropertyChanges;
   
   use namespace mx_internal;
   
   public class CompositeEffect extends Effect
   {
      
      mx_internal static const VERSION:String = "3.6.0.21751";
       
      
      private var _affectedProperties:Array;
      
      private var childTargets:Array;
      
      public var children:Array;
      
      public function CompositeEffect(param1:Object = null)
      {
         children = [];
         super(param1);
         instanceClass = CompositeEffectInstance;
      }
      
      override public function createInstances(param1:Array = null) : Array
      {
         if(!param1)
         {
            param1 = this.targets;
         }
         childTargets = param1;
         var _loc2_:IEffectInstance = createInstance();
         childTargets = null;
         return !!_loc2_?[_loc2_]:[];
      }
      
      override protected function initInstance(param1:IEffectInstance) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Effect = null;
         super.initInstance(param1);
         var _loc2_:CompositeEffectInstance = CompositeEffectInstance(param1);
         var _loc3_:Object = childTargets;
         if(!(_loc3_ is Array))
         {
            _loc3_ = [_loc3_];
         }
         if(children)
         {
            _loc4_ = children.length;
            _loc5_ = 0;
            while(_loc5_ < _loc4_)
            {
               _loc6_ = children[_loc5_];
               if(propertyChangesArray != null)
               {
                  _loc6_.propertyChangesArray = propertyChangesArray;
               }
               if(_loc6_.filterObject == null && filterObject)
               {
                  _loc6_.filterObject = filterObject;
               }
               if(effectTargetHost)
               {
                  _loc6_.effectTargetHost = effectTargetHost;
               }
               if(_loc6_.targets.length == 0)
               {
                  _loc2_.addChildSet(children[_loc5_].createInstances(_loc3_));
               }
               else
               {
                  _loc2_.addChildSet(children[_loc5_].createInstances(_loc6_.targets));
               }
               _loc5_++;
            }
         }
      }
      
      override mx_internal function captureValues(param1:Array, param2:Boolean) : Array
      {
         var _loc5_:Effect = null;
         var _loc3_:int = children.length;
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = children[_loc4_];
            param1 = _loc5_.captureValues(param1,param2);
            _loc4_++;
         }
         return param1;
      }
      
      public function addChild(param1:IEffect) : void
      {
         children.push(param1);
         _affectedProperties = null;
      }
      
      override mx_internal function applyStartValues(param1:Array, param2:Array) : void
      {
         var _loc5_:Effect = null;
         var _loc6_:Array = null;
         var _loc3_:int = children.length;
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = children[_loc4_];
            _loc6_ = _loc5_.targets.length > 0?_loc5_.targets:param2;
            if(_loc5_.filterObject == null && filterObject)
            {
               _loc5_.filterObject = filterObject;
            }
            _loc5_.applyStartValues(param1,_loc6_);
            _loc4_++;
         }
      }
      
      override public function createInstance(param1:Object = null) : IEffectInstance
      {
         if(!childTargets)
         {
            childTargets = [param1];
         }
         var _loc2_:IEffectInstance = super.createInstance(param1);
         childTargets = null;
         return _loc2_;
      }
      
      override protected function filterInstance(param1:Array, param2:Object) : Boolean
      {
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         if(filterObject)
         {
            _loc3_ = targets;
            if(_loc3_.length == 0)
            {
               _loc3_ = childTargets;
            }
            _loc4_ = _loc3_.length;
            _loc5_ = 0;
            while(_loc5_ < _loc4_)
            {
               if(filterObject.filterInstance(param1,effectTargetHost,_loc3_[_loc5_]))
               {
                  return true;
               }
               _loc5_++;
            }
            return false;
         }
         return true;
      }
      
      override public function captureStartValues() : void
      {
         var _loc1_:Array = getChildrenTargets();
         propertyChangesArray = [];
         var _loc2_:int = _loc1_.length;
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            propertyChangesArray.push(new PropertyChanges(_loc1_[_loc3_]));
            _loc3_++;
         }
         propertyChangesArray = captureValues(propertyChangesArray,true);
         endValuesCaptured = false;
      }
      
      private function getChildrenTargets() : Array
      {
         var _loc3_:Array = null;
         var _loc4_:Effect = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:* = null;
         var _loc1_:Array = [];
         var _loc2_:Object = {};
         _loc5_ = children.length;
         _loc6_ = 0;
         while(_loc6_ < _loc5_)
         {
            _loc4_ = children[_loc6_];
            if(_loc4_ is CompositeEffect)
            {
               _loc3_ = CompositeEffect(_loc4_).getChildrenTargets();
               _loc7_ = _loc3_.length;
               _loc8_ = 0;
               while(_loc8_ < _loc7_)
               {
                  if(_loc3_[_loc8_] != null)
                  {
                     _loc2_[_loc3_[_loc8_].toString()] = _loc3_[_loc8_];
                  }
                  _loc8_++;
               }
            }
            else if(_loc4_.targets != null)
            {
               _loc7_ = _loc4_.targets.length;
               _loc8_ = 0;
               while(_loc8_ < _loc7_)
               {
                  if(_loc4_.targets[_loc8_] != null)
                  {
                     _loc2_[_loc4_.targets[_loc8_].toString()] = _loc4_.targets[_loc8_];
                  }
                  _loc8_++;
               }
            }
            _loc6_++;
         }
         _loc5_ = targets.length;
         _loc6_ = 0;
         while(_loc6_ < _loc5_)
         {
            if(targets[_loc6_] != null)
            {
               _loc2_[targets[_loc6_].toString()] = targets[_loc6_];
            }
            _loc6_++;
         }
         for(_loc9_ in _loc2_)
         {
            _loc1_.push(_loc2_[_loc9_]);
         }
         return _loc1_;
      }
      
      override public function getAffectedProperties() : Array
      {
         var _loc1_:Array = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(!_affectedProperties)
         {
            _loc1_ = [];
            _loc2_ = children.length;
            _loc3_ = 0;
            while(_loc3_ < _loc2_)
            {
               _loc1_ = _loc1_.concat(children[_loc3_].getAffectedProperties());
               _loc3_++;
            }
            _affectedProperties = _loc1_;
         }
         return _affectedProperties;
      }
   }
}
