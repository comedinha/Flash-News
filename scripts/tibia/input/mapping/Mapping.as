package tibia.input.mapping
{
   import tibia.input.IAction;
   import tibia.input.staticaction.StaticAction;
   import tibia.input.InputEvent;
   
   public class Mapping
   {
      
      protected static const OPTIONS_MAX_COMPATIBLE_VERSION:Number = 5;
      
      protected static const OPTIONS_MIN_COMPATIBLE_VERSION:Number = 2;
       
      
      protected var m_Binding:Vector.<tibia.input.mapping.Binding>;
      
      public function Mapping()
      {
         this.m_Binding = new Vector.<tibia.input.mapping.Binding>();
         super();
      }
      
      public static function s_Unmarshall(param1:XML, param2:Number, param3:Mapping) : Mapping
      {
         var _loc4_:XML = null;
         var _loc5_:tibia.input.mapping.Binding = null;
         if(param1 == null || param1.localName() != "mapping" || param2 < OPTIONS_MIN_COMPATIBLE_VERSION || param2 > OPTIONS_MAX_COMPATIBLE_VERSION)
         {
            throw new Error("Mapping.s_Unmarshall: Invalid input.");
         }
         if(param3 == null)
         {
            throw new Error("Mapping.s_Unmarshall: Invalid mapping.");
         }
         for each(_loc4_ in param1.elements("binding"))
         {
            _loc5_ = tibia.input.mapping.Binding.unmarshall(_loc4_,param2);
            if(_loc5_ != null)
            {
               param3.addItemInternal(_loc5_);
            }
         }
         return param3;
      }
      
      public function addAll(param1:*) : Boolean
      {
         if(!(param1 is Array) && !(param1 is Vector.<tibia.input.mapping.Binding>))
         {
            throw new ArgumentError("Mapping.addAll: Invalid input(1).");
         }
         var _loc2_:int = param1.length;
         var _loc3_:int = this.m_Binding.length;
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_)
         {
            if(param1[_loc4_] == null)
            {
               throw new ArgumentError("Mapping.addAll: Invalid input(2).");
            }
            if(this.getConflictingBinding(param1[_loc4_]) != null)
            {
               this.m_Binding.length = _loc3_;
               return false;
            }
            this.m_Binding.push(param1[_loc4_].clone());
            _loc4_++;
         }
         return true;
      }
      
      public function clone() : Mapping
      {
         var _loc1_:Mapping = new Mapping();
         var _loc2_:int = this.m_Binding.length;
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc1_.m_Binding[_loc3_] = this.m_Binding[_loc3_].clone();
            _loc3_++;
         }
         return _loc1_;
      }
      
      public function get binding() : Vector.<tibia.input.mapping.Binding>
      {
         return this.m_Binding;
      }
      
      function onKeyInput(param1:uint, param2:uint, param3:uint, param4:Boolean, param5:Boolean, param6:Boolean) : void
      {
         var b:tibia.input.mapping.Binding = null;
         var _Action:IAction = null;
         var a_Event:uint = param1;
         var a_Char:uint = param2;
         var a_Key:uint = param3;
         var a_Alt:Boolean = param4;
         var a_Ctrl:Boolean = param5;
         var a_Shift:Boolean = param6;
         for each(b in this.m_Binding)
         {
            if(a_Alt && (a_Ctrl || a_Shift) && b.appliesTo(a_Event,a_Key,true,false,false) || a_Ctrl && (a_Alt || a_Shift) && b.appliesTo(a_Event,a_Key,false,true,false) || a_Shift && (a_Alt || a_Ctrl) && b.appliesTo(a_Event,a_Key,false,false,true) || a_Alt && a_Ctrl && b.appliesTo(a_Event,a_Key,false,false,false) || a_Alt && a_Shift && b.appliesTo(a_Event,a_Key,false,false,false) || a_Ctrl && a_Shift && b.appliesTo(a_Event,a_Key,false,false,false) || b.appliesTo(a_Event,a_Key,a_Alt,a_Ctrl,a_Shift))
            {
               try
               {
                  _Action = b.action;
                  if(_Action is StaticAction)
                  {
                     StaticAction(_Action).keyCallback(a_Event,a_Char,a_Key,a_Alt,a_Ctrl,a_Shift);
                  }
                  else
                  {
                     _Action.perform(a_Event == InputEvent.KEY_REPEAT);
                  }
               }
               catch(e:Error)
               {
               }
               break;
            }
         }
      }
      
      public function getConflictingBinding(param1:tibia.input.mapping.Binding) : tibia.input.mapping.Binding
      {
         var _loc2_:tibia.input.mapping.Binding = null;
         if(param1 == null)
         {
            throw new ArgumentError("Mapping.getConflictingBinding: Invalid binding.");
         }
         for each(_loc2_ in this.m_Binding)
         {
            if(_loc2_.conflicts(param1))
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public function marshall(param1:Boolean = true) : XML
      {
         var _loc2_:XML = <mapping></mapping>;
         var _loc3_:int = this.m_Binding.length;
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            if(this.m_Binding[_loc4_] != null && (!param1 || this.m_Binding[_loc4_].editable))
            {
               _loc2_.appendChild(this.m_Binding[_loc4_].marshall());
            }
            _loc4_++;
         }
         return _loc2_;
      }
      
      public function getBindingsByAction(param1:IAction) : Array
      {
         if(param1 == null)
         {
            throw new ArgumentError("Mapping.getBindingsByAction: Invalid action.");
         }
         var _loc2_:Array = [];
         var _loc3_:int = this.m_Binding.length;
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            if(this.m_Binding[_loc4_].action.equals(param1))
            {
               _loc2_.push(this.m_Binding[_loc4_]);
            }
            _loc4_++;
         }
         return _loc2_;
      }
      
      public function addItem(param1:tibia.input.mapping.Binding) : Boolean
      {
         if(param1 == null)
         {
            throw new ArgumentError("Mapping.addItem: Invalid binding.");
         }
         if(this.getConflictingBinding(param1) != null)
         {
            return false;
         }
         this.m_Binding.push(param1.clone());
         return true;
      }
      
      public function removeItem(param1:tibia.input.mapping.Binding) : void
      {
         var _loc2_:int = this.m_Binding.length - 1;
         while(_loc2_ >= 0)
         {
            if(this.m_Binding[_loc2_].equals(param1))
            {
               this.m_Binding.splice(_loc2_,1);
               break;
            }
            _loc2_--;
         }
      }
      
      private function addItemInternal(param1:tibia.input.mapping.Binding) : Boolean
      {
         if(param1 == null)
         {
            throw new ArgumentError("Mapping.addItemInternal: Invalid binding.");
         }
         var _loc2_:int = this.m_Binding.length - 1;
         var _loc3_:int = 0;
         while(_loc2_ >= 0)
         {
            if(this.m_Binding[_loc2_].conflicts(param1))
            {
               if(!this.m_Binding[_loc2_].editable)
               {
                  return false;
               }
               this.m_Binding[_loc2_] = param1;
               return true;
            }
            if(this.m_Binding[_loc2_].action.equals(param1.action) && ++_loc3_ > 2)
            {
               return false;
            }
            _loc2_--;
         }
         this.m_Binding.push(param1);
         return true;
      }
      
      public function removeAll(param1:Boolean = true) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:tibia.input.mapping.Binding = null;
         if(!param1)
         {
            this.m_Binding.length = 0;
         }
         else
         {
            _loc2_ = this.m_Binding.length;
            _loc3_ = _loc2_ - 1;
            while(_loc3_ >= 0)
            {
               if(this.m_Binding[_loc3_] == null || this.m_Binding[_loc3_].editable)
               {
                  _loc2_--;
                  _loc4_ = this.m_Binding[_loc2_];
                  this.m_Binding[_loc2_] = this.m_Binding[_loc3_];
                  this.m_Binding[_loc3_] = _loc4_;
               }
               _loc3_--;
            }
            this.m_Binding.length = _loc2_;
         }
      }
      
      function onTextInput(param1:uint, param2:String) : void
      {
         var b:tibia.input.mapping.Binding = null;
         var a_Event:uint = param1;
         var a_Text:String = param2;
         for each(b in this.m_Binding)
         {
            if(b.appliesTo(a_Event,0,false,false,false))
            {
               try
               {
                  if(b.action is StaticAction)
                  {
                     StaticAction(b.action).textCallback(a_Event,a_Text);
                  }
                  else
                  {
                     b.action.perform();
                  }
               }
               catch(e:Error)
               {
               }
               break;
            }
         }
      }
   }
}
