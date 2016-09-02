package mx.effects.effectClasses
{
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   public class SetPropertyActionInstance extends ActionEffectInstance
   {
      
      mx_internal static const VERSION:String = "3.6.0.21751";
       
      
      private var _value;
      
      public var name:String;
      
      public function SetPropertyActionInstance(param1:Object)
      {
         super(param1);
      }
      
      public function get value() : *
      {
         var _loc1_:* = undefined;
         if(mx_internal::playReversed)
         {
            _loc1_ = getStartValue();
            if(_loc1_ != undefined)
            {
               return _loc1_;
            }
         }
         return _value;
      }
      
      public function set value(param1:*) : void
      {
         _value = param1;
      }
      
      override public function play() : void
      {
         var _loc1_:String = null;
         var _loc2_:Object = null;
         super.play();
         if(value === undefined && propertyChanges)
         {
            if(name in propertyChanges.end && propertyChanges.start[name] != propertyChanges.end[name])
            {
               value = propertyChanges.end[name];
            }
         }
         if(target && name && value !== undefined)
         {
            if(target[name] is Number)
            {
               _loc1_ = name;
               _loc2_ = value;
               if(name == "width" || name == "height")
               {
                  if(_loc2_ is String && _loc2_.indexOf("%") >= 0)
                  {
                     _loc1_ = name == "width"?"percentWidth":"percentHeight";
                     _loc2_ = _loc2_.slice(0,_loc2_.indexOf("%"));
                  }
               }
               target[_loc1_] = Number(_loc2_);
            }
            else if(target[name] is Boolean)
            {
               if(value is String)
               {
                  target[name] = value.toLowerCase() == "true";
               }
               else
               {
                  target[name] = value;
               }
            }
            else
            {
               target[name] = value;
            }
         }
         finishRepeat();
      }
      
      override protected function saveStartValue() : *
      {
         if(name != null)
         {
            try
            {
               return target[name];
            }
            catch(e:Error)
            {
            }
         }
         return undefined;
      }
   }
}
