package tibia.input.mapping
{
   import flash.ui.Keyboard;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   import tibia.input.IAction;
   import tibia.input.InputEvent;
   import tibia.input.staticaction.StaticAction;
   
   public class Binding
   {
      
      private static const LOCALE_MAPPING:Array = [{
         "key":48,
         "modifier":16,
         "result":48
      },{
         "key":48,
         "modifier":16,
         "text":"=",
         "result":48
      },{
         "key":49,
         "modifier":16,
         "result":49
      },{
         "key":50,
         "modifier":16,
         "result":50
      },{
         "key":50,
         "modifier":16,
         "text":"\"",
         "result":50
      },{
         "key":51,
         "modifier":16,
         "result":51
      },{
         "key":51,
         "modifier":16,
         "text":"§",
         "result":51
      },{
         "key":52,
         "modifier":16,
         "result":52
      },{
         "key":53,
         "modifier":16,
         "result":53
      },{
         "key":54,
         "modifier":16,
         "result":54
      },{
         "key":54,
         "modifier":16,
         "text":"&",
         "result":54
      },{
         "char":94,
         "key":54,
         "modifier":16,
         "result":54
      },{
         "key":55,
         "modifier":16,
         "result":55
      },{
         "key":55,
         "modifier":16,
         "text":"/",
         "result":55
      },{
         "key":56,
         "modifier":16,
         "result":56
      },{
         "key":56,
         "modifier":16,
         "text":"(",
         "result":56
      },{
         "key":57,
         "modifier":16,
         "result":57
      },{
         "key":57,
         "modifier":16,
         "text":")",
         "result":57
      },{
         "key":186,
         "modifier":16,
         "result":59
      },{
         "key":186,
         "modifier":16,
         "text":"Ü",
         "result":252
      },{
         "char":252,
         "key":186,
         "modifier":17,
         "result":252
      },{
         "char":186,
         "key":186,
         "modifier":0,
         "text":"ł",
         "result":321
      },{
         "char":186,
         "key":186,
         "modifier":16,
         "text":"Ł",
         "result":321
      },{
         "char":186,
         "key":186,
         "modifier":17,
         "result":321
      },{
         "char":231,
         "key":186,
         "modifier":16,
         "text":"Ç",
         "result":231
      },{
         "char":231,
         "key":186,
         "modifier":17,
         "result":231
      },{
         "key":187,
         "modifier":16,
         "result":61
      },{
         "key":187,
         "modifier":16,
         "text":"*",
         "result":43
      },{
         "char":43,
         "key":187,
         "modifier":16,
         "text":"?",
         "result":43
      },{
         "key":188,
         "modifier":16,
         "result":44
      },{
         "key":188,
         "modifier":16,
         "text":";",
         "result":44
      },{
         "key":189,
         "modifier":16,
         "result":45
      },{
         "key":190,
         "modifier":16,
         "result":46
      },{
         "key":190,
         "modifier":16,
         "text":":",
         "result":46
      },{
         "key":191,
         "modifier":16,
         "result":47
      },{
         "key":191,
         "modifier":16,
         "text":"\'",
         "result":35
      },{
         "char":34,
         "key":191,
         "modifier":16,
         "text":"*",
         "result":39
      },{
         "key":191,
         "modifier":16,
         "text":":",
         "result":59
      },{
         "key":192,
         "modifier":16,
         "result":96
      },{
         "key":192,
         "modifier":16,
         "text":"Ö",
         "result":246
      },{
         "char":192,
         "key":192,
         "modifier":0,
         "result":731
      },{
         "char":192,
         "key":192,
         "modifier":16,
         "result":731
      },{
         "char":192,
         "key":192,
         "modifier":17,
         "result":731
      },{
         "char":34,
         "key":192,
         "modifier":16,
         "text":"\"",
         "result":39
      },{
         "key":219,
         "modifier":16,
         "result":91
      },{
         "key":219,
         "modifier":16,
         "text":"?",
         "result":223
      },{
         "char":219,
         "key":219,
         "modifier":0,
         "text":"ż",
         "result":380
      },{
         "char":219,
         "key":219,
         "modifier":16,
         "text":"ń",
         "result":380
      },{
         "char":219,
         "key":219,
         "modifier":17,
         "result":380
      },{
         "char":219,
         "key":219,
         "modifier":0,
         "result":180
      },{
         "char":219,
         "key":219,
         "modifier":16,
         "result":180
      },{
         "char":219,
         "key":219,
         "modifier":17,
         "result":180
      },{
         "key":220,
         "modifier":16,
         "result":92
      },{
         "char":220,
         "key":220,
         "modifier":0,
         "result":94
      },{
         "char":220,
         "key":220,
         "modifier":16,
         "result":94
      },{
         "char":220,
         "key":220,
         "modifier":17,
         "result":94
      },{
         "char":243,
         "key":220,
         "modifier":16,
         "text":"ź",
         "result":243
      },{
         "char":125,
         "key":220,
         "modifier":16,
         "text":"}",
         "result":93
      },{
         "key":221,
         "modifier":16,
         "result":93
      },{
         "char":221,
         "key":221,
         "modifier":0,
         "result":180
      },{
         "char":221,
         "key":221,
         "modifier":16,
         "result":180
      },{
         "char":221,
         "key":221,
         "modifier":17,
         "result":180
      },{
         "char":221,
         "key":221,
         "modifier":0,
         "text":"ś",
         "result":347
      },{
         "char":221,
         "key":221,
         "modifier":16,
         "text":"ć",
         "result":347
      },{
         "char":221,
         "key":221,
         "modifier":17,
         "result":347
      },{
         "char":123,
         "key":221,
         "modifier":16,
         "text":"{",
         "result":91
      },{
         "key":222,
         "modifier":16,
         "result":39
      },{
         "key":222,
         "modifier":16,
         "text":"Ä",
         "result":228
      },{
         "char":222,
         "key":222,
         "modifier":0,
         "text":"ą",
         "result":261
      },{
         "char":222,
         "key":222,
         "modifier":16,
         "text":"ę",
         "result":261
      },{
         "char":222,
         "key":222,
         "modifier":17,
         "result":261
      },{
         "char":222,
         "key":222,
         "modifier":0,
         "result":126
      },{
         "char":222,
         "key":222,
         "modifier":16,
         "result":126
      },{
         "char":222,
         "key":222,
         "modifier":17,
         "result":126
      },{
         "key":226,
         "modifier":16,
         "result":92
      },{
         "key":226,
         "modifier":16,
         "text":"\\",
         "result":60
      },{
         "char":60,
         "key":226,
         "modifier":16,
         "text":">",
         "result":60
      }];
      
      protected static const OPTIONS_MAX_COMPATIBLE_VERSION:Number = 5;
      
      private static const BUNDLE:String = "InputHandler";
      
      protected static const OPTIONS_MIN_COMPATIBLE_VERSION:Number = 2;
       
      
      private var m_RawText:String = null;
      
      private var m_RawKey:uint = 0;
      
      private var m_Editable:Boolean = true;
      
      private var m_ToString:String = null;
      
      private var m_Action:IAction = null;
      
      private var m_RawMod:uint = 0;
      
      private var m_EventMask:uint = 0;
      
      private var m_RawChar:uint = 0;
      
      public function Binding(param1:IAction, param2:*, param3:uint, param4:uint, param5:String = null, param6:Boolean = true)
      {
         super();
         if(param1 == null)
         {
            throw new ArgumentError("Binding.Binding: Invalid action.");
         }
         this.m_Action = param1;
         if(param1 is StaticAction)
         {
            this.m_EventMask = (param1 as StaticAction).eventMask;
         }
         else
         {
            this.m_EventMask = InputEvent.KEY_DOWN;
         }
         if((this.m_EventMask & ~(InputEvent.KEY_ANY | InputEvent.TEXT_ANY)) != 0)
         {
            throw new ArgumentError("Binding.Binding: Invalid event mask: " + this.m_EventMask);
         }
         var _loc7_:uint = 0;
         if(param2 is String && String(param2).length == 1)
         {
            _loc7_ = String(param2).charCodeAt(0);
         }
         else if(param2 is uint)
         {
            _loc7_ = uint(param2);
         }
         this.update(_loc7_,param3,param4,param5);
         this.m_Editable = param6;
      }
      
      public static function isBindable(param1:uint, param2:Boolean = false, param3:Boolean = false, param4:Boolean = false) : Boolean
      {
         return param1 != Keyboard.ALTERNATE && param1 != Keyboard.COMMAND && param1 != Keyboard.CONTROL && param1 != Keyboard.SHIFT && param1 != 12 && param1 != 19 && param1 != 20 && param1 != 44 && param1 != 91 && param1 != 92 && param1 != 93 && param1 != 144 && param1 != 145 && (!param2 && !param3 && !param4 || param2 && !param3 && !param4 || !param2 && param3 && !param4 || !param2 && !param3 && param4);
      }
      
      public static function unmarshall(param1:XML, param2:Number) : Binding
      {
         if(param1 == null || param1.localName() != "binding" || param2 < OPTIONS_MIN_COMPATIBLE_VERSION || param2 > OPTIONS_MAX_COMPATIBLE_VERSION)
         {
            throw new Error("Binding.s_Unmarshall: Invalid input.");
         }
         var _loc3_:XMLList = null;
         var _loc4_:uint = 0;
         if((_loc3_ = param1.@charCode) != null && _loc3_.length() == 1)
         {
            _loc4_ = parseInt(_loc3_.toString());
         }
         if((_loc3_ = param1.@keyCode) == null || _loc3_.length() != 1)
         {
            return null;
         }
         var _loc5_:uint = parseInt(_loc3_[0].toString());
         var _loc6_:String = null;
         if((_loc3_ = param1.@text) != null && _loc3_.length() == 1)
         {
            _loc6_ = _loc3_[0].toString();
         }
         if((_loc3_ = param1.@modifierCode) == null || _loc3_.length() != 1)
         {
            return null;
         }
         var _loc7_:uint = parseInt(_loc3_.toString());
         if((_loc3_ = param1.action) == null || _loc3_.length() < 1)
         {
            return null;
         }
         var _loc8_:IAction = StaticAction.s_Unmarshall(_loc3_[0],param2);
         if(_loc8_ != null)
         {
            return new Binding(_loc8_,_loc4_,_loc5_,_loc7_,_loc6_);
         }
         return null;
      }
      
      public static function isControlKey(param1:uint) : Boolean
      {
         return param1 == 0 || param1 == Keyboard.BACKSPACE || param1 == Keyboard.TAB || param1 == Keyboard.ENTER || param1 >= Keyboard.COMMAND && param1 <= Keyboard.ALTERNATE || param1 >= Keyboard.CAPS_LOCK && param1 <= Keyboard.NUMPAD || param1 == Keyboard.ESCAPE || param1 >= Keyboard.PAGE_UP && param1 <= Keyboard.DOWN || param1 >= Keyboard.INSERT && param1 <= Keyboard.DELETE || param1 >= Keyboard.NUMPAD_0 && param1 <= Keyboard.NUMPAD_DIVIDE || param1 >= Keyboard.F1 && param1 <= Keyboard.F15 || param1 == 91 || param1 == 92 || param1 == 93;
      }
      
      public static function toModifierCode(param1:Boolean, param2:Boolean, param3:Boolean) : uint
      {
         return !!param1?uint(Keyboard.ALTERNATE):!!param2?uint(Keyboard.CONTROL):!!param3?uint(Keyboard.SHIFT):uint(0);
      }
      
      private function formatAsString() : String
      {
         var _loc1_:IResourceManager = ResourceManager.getInstance();
         if((this.m_EventMask & InputEvent.TEXT_ANY) != 0)
         {
            return _loc1_.getString(BUNDLE,"BINDING_TEXT");
         }
         if(this.m_RawKey == 0)
         {
            return _loc1_.getString(BUNDLE,"BINDING_EMPTY");
         }
         var _loc2_:* = null;
         if(this.m_RawMod == Keyboard.ALTERNATE)
         {
            _loc2_ = _loc1_.getString(BUNDLE,"BINDING_KEY_ALTERNATE") + " + ";
         }
         else if(this.m_RawMod == Keyboard.CONTROL)
         {
            _loc2_ = _loc1_.getString(BUNDLE,"BINDING_KEY_CONTROL") + " + ";
         }
         else if(this.m_RawMod == Keyboard.SHIFT)
         {
            _loc2_ = _loc1_.getString(BUNDLE,"BINDING_KEY_SHIFT") + " + ";
         }
         else
         {
            _loc2_ = "";
         }
         if(this.m_RawKey >= Keyboard.NUMPAD_0 && this.m_RawKey <= Keyboard.NUMPAD_DIVIDE)
         {
            _loc2_ = _loc2_ + (_loc1_.getString(BUNDLE,"BINDING_KEY_NUMPAD_PREFIX") + "-");
         }
         var _loc3_:uint = 0;
         if(this.m_RawKey == Keyboard.BACKSPACE)
         {
            _loc2_ = _loc2_ + _loc1_.getString(BUNDLE,"BINDING_KEY_BACKSPACE");
         }
         else if(this.m_RawKey == Keyboard.TAB)
         {
            _loc2_ = _loc2_ + _loc1_.getString(BUNDLE,"BINDING_KEY_TAB");
         }
         else if(this.m_RawKey == Keyboard.ENTER)
         {
            _loc2_ = _loc2_ + _loc1_.getString(BUNDLE,"BINDING_KEY_ENTER");
         }
         else if(this.m_RawKey == Keyboard.COMMAND)
         {
            _loc2_ = _loc2_ + _loc1_.getString(BUNDLE,"BINDING_KEY_COMMAND");
         }
         else if(this.m_RawKey == Keyboard.CAPS_LOCK)
         {
            _loc2_ = _loc2_ + _loc1_.getString(BUNDLE,"BINDING_KEY_CAPS_LOCK");
         }
         else if(this.m_RawKey == Keyboard.NUMPAD)
         {
            _loc2_ = _loc2_ + _loc1_.getString(BUNDLE,"BINDING_KEY_NUMPAD");
         }
         else if(this.m_RawKey == Keyboard.ESCAPE)
         {
            _loc2_ = _loc2_ + _loc1_.getString(BUNDLE,"BINDING_KEY_ESCAPE");
         }
         else if(this.m_RawKey == Keyboard.SPACE)
         {
            _loc2_ = _loc2_ + _loc1_.getString(BUNDLE,"BINDING_KEY_SPACE");
         }
         else if(this.m_RawKey == Keyboard.PAGE_UP)
         {
            _loc2_ = _loc2_ + _loc1_.getString(BUNDLE,"BINDING_KEY_PAGE_UP");
         }
         else if(this.m_RawKey == Keyboard.PAGE_DOWN)
         {
            _loc2_ = _loc2_ + _loc1_.getString(BUNDLE,"BINDING_KEY_PAGE_DOWN");
         }
         else if(this.m_RawKey == Keyboard.END)
         {
            _loc2_ = _loc2_ + _loc1_.getString(BUNDLE,"BINDING_KEY_END");
         }
         else if(this.m_RawKey == Keyboard.HOME)
         {
            _loc2_ = _loc2_ + _loc1_.getString(BUNDLE,"BINDING_KEY_HOME");
         }
         else if(this.m_RawKey == Keyboard.LEFT)
         {
            _loc2_ = _loc2_ + _loc1_.getString(BUNDLE,"BINDING_KEY_LEFT");
         }
         else if(this.m_RawKey == Keyboard.UP)
         {
            _loc2_ = _loc2_ + _loc1_.getString(BUNDLE,"BINDING_KEY_UP");
         }
         else if(this.m_RawKey == Keyboard.RIGHT)
         {
            _loc2_ = _loc2_ + _loc1_.getString(BUNDLE,"BINDING_KEY_RIGHT");
         }
         else if(this.m_RawKey == Keyboard.DOWN)
         {
            _loc2_ = _loc2_ + _loc1_.getString(BUNDLE,"BINDING_KEY_DOWN");
         }
         else if(this.m_RawKey == Keyboard.INSERT)
         {
            _loc2_ = _loc2_ + _loc1_.getString(BUNDLE,"BINDING_KEY_INSERT");
         }
         else if(this.m_RawKey == Keyboard.DELETE)
         {
            _loc2_ = _loc2_ + _loc1_.getString(BUNDLE,"BINDING_KEY_DELETE");
         }
         else if(this.m_RawKey >= Keyboard.NUMPAD_0 && this.m_RawKey <= Keyboard.NUMPAD_9)
         {
            _loc2_ = _loc2_ + String.fromCharCode(48 + this.m_RawKey - Keyboard.NUMPAD_0);
         }
         else if(this.m_RawKey == Keyboard.NUMPAD_MULTIPLY)
         {
            _loc2_ = _loc2_ + _loc1_.getString(BUNDLE,"BINDING_KEY_NUMPAD_MULTIPLY");
         }
         else if(this.m_RawKey == Keyboard.NUMPAD_ADD)
         {
            _loc2_ = _loc2_ + _loc1_.getString(BUNDLE,"BINDING_KEY_NUMPAD_ADD");
         }
         else if(this.m_RawKey == Keyboard.NUMPAD_ENTER)
         {
            _loc2_ = _loc2_ + _loc1_.getString(BUNDLE,"BINDING_KEY_NUMPAD_ENTER");
         }
         else if(this.m_RawKey == Keyboard.NUMPAD_SUBTRACT)
         {
            _loc2_ = _loc2_ + _loc1_.getString(BUNDLE,"BINDING_KEY_NUMPAD_SUBTRACT");
         }
         else if(this.m_RawKey == Keyboard.NUMPAD_DECIMAL)
         {
            _loc2_ = _loc2_ + _loc1_.getString(BUNDLE,"BINDING_KEY_NUMPAD_DECIMAL");
         }
         else if(this.m_RawKey == Keyboard.NUMPAD_DIVIDE)
         {
            _loc2_ = _loc2_ + _loc1_.getString(BUNDLE,"BINDING_KEY_NUMPAD_DIVIDE");
         }
         else if(this.m_RawKey >= Keyboard.F1 && this.m_RawKey <= Keyboard.F15)
         {
            _loc2_ = _loc2_ + _loc1_.getString(BUNDLE,"BINDING_KEY_FUNCTION",[1 + this.m_RawKey - Keyboard.F1]);
         }
         else if(this.m_RawKey != 0 && (_loc3_ = this.mapCharCode()) != 0)
         {
            _loc2_ = _loc2_ + String.fromCharCode(_loc3_).toUpperCase();
         }
         else
         {
            _loc2_ = _loc2_ + _loc1_.getString(BUNDLE,"BINDING_UNKNOWN");
         }
         return _loc2_;
      }
      
      public function update(param1:*, param2:uint = 0, param3:uint = 0, param4:String = null) : void
      {
         var _loc6_:Binding = null;
         if(!this.m_Editable)
         {
            return;
         }
         if(param1 is Binding)
         {
            _loc6_ = Binding(param1);
            this.update(_loc6_.m_RawChar,_loc6_.m_RawKey,_loc6_.m_RawMod,_loc6_.m_RawText);
            return;
         }
         var _loc5_:uint = uint(param1);
         if((this.m_EventMask & InputEvent.KEY_ANY) != 0)
         {
            if(!isBindable(param2))
            {
               throw new ArgumentError("Binding.set updateBinding: Invalid keyCode: " + param2);
            }
            if(!isControlKey(param2) && _loc5_ == 0)
            {
               throw new ArgumentError("Binding.set updateBinding: Invalid keyCode/charCode combination: " + param2 + "/" + _loc5_);
            }
            if(param3 != 0 && param3 != Keyboard.ALTERNATE && param3 != Keyboard.CONTROL && param3 != Keyboard.SHIFT)
            {
               throw new ArgumentError("Binding.set updateBinding: Invalid modifier: " + param3);
            }
         }
         else
         {
            _loc5_ = 0;
            param2 = 0;
            param3 = 0;
            param4 = null;
         }
         if(this.m_RawChar != _loc5_ || this.m_RawKey != param2 || this.m_RawMod != param3 || this.m_RawText != param4)
         {
            this.m_RawChar = _loc5_;
            this.m_RawKey = param2;
            this.m_RawMod = param3;
            this.m_RawText = param4;
            this.m_ToString = null;
         }
      }
      
      public function marshall() : XML
      {
         var _loc1_:XML = <binding keyCode="{this.m_RawKey}" modifierCode="{this.m_RawMod}">
                    {this.m_Action.marshall()}
                  </binding>;
         if(this.m_RawChar != 0)
         {
            _loc1_.@charCode = this.m_RawChar;
         }
         if(this.m_RawText != null)
         {
            _loc1_.@text = this.m_RawText;
         }
         return _loc1_;
      }
      
      public function toString() : String
      {
         if(this.m_ToString == null)
         {
            this.m_ToString = this.formatAsString();
         }
         return this.m_ToString;
      }
      
      public function clone() : Binding
      {
         if(this.m_Editable)
         {
            return new Binding(this.m_Action.clone(),this.m_RawChar,this.m_RawKey,this.m_RawMod,this.m_RawText,this.m_Editable);
         }
         return this;
      }
      
      public function conflicts(param1:Binding) : Boolean
      {
         var _loc2_:* = false;
         var _loc3_:* = false;
         if(param1 != null)
         {
            _loc2_ = (this.m_EventMask & InputEvent.KEY_ANY) != 0;
            _loc3_ = (param1.m_EventMask & InputEvent.KEY_ANY) != 0;
            if(_loc2_ == _loc3_ && (this.m_RawKey == param1.m_RawKey && this.m_RawMod == param1.m_RawMod))
            {
               return true;
            }
            if(_loc2_ && !_loc3_ && (this.m_RawMod == 0 || this.m_RawMod == Keyboard.SHIFT) && !isControlKey(this.m_RawKey))
            {
               return true;
            }
            if(!_loc2_ && _loc3_ && (param1.m_RawMod == 0 || param1.m_RawMod == Keyboard.SHIFT) && !isControlKey(param1.m_RawKey))
            {
               return true;
            }
         }
         return false;
      }
      
      public function get modifierCode() : uint
      {
         return this.m_RawMod;
      }
      
      private function mapCharCode() : uint
      {
         var _loc4_:Object = null;
         if(isControlKey(this.m_RawKey))
         {
            return 0;
         }
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:uint = this.m_RawChar;
         for each(_loc4_ in LOCALE_MAPPING)
         {
            _loc2_ = 0;
            if(_loc4_.hasOwnProperty("char"))
            {
               if(_loc4_.char != this.m_RawChar)
               {
                  continue;
               }
               _loc2_++;
            }
            if(_loc4_.hasOwnProperty("key"))
            {
               if(_loc4_.key != this.m_RawKey)
               {
                  continue;
               }
               _loc2_++;
            }
            if(_loc4_.hasOwnProperty("modifier"))
            {
               if(_loc4_.modifier != this.m_RawMod)
               {
                  continue;
               }
               _loc2_++;
            }
            if(_loc4_.hasOwnProperty("text"))
            {
               if(_loc4_.text != this.m_RawText)
               {
                  continue;
               }
               _loc2_++;
            }
            if(_loc2_ > _loc1_)
            {
               _loc1_ = _loc2_;
               _loc3_ = _loc4_.result;
            }
            else if(_loc2_ == _loc1_)
            {
            }
         }
         return _loc3_;
      }
      
      public function appliesTo(param1:uint, param2:uint, param3:Boolean, param4:Boolean, param5:Boolean) : Boolean
      {
         return (this.m_EventMask & param1) != 0 && this.m_RawKey == param2 && (this.m_RawMod != 0 || !param3 && !param4 && !param5) && (this.m_RawMod != Keyboard.ALTERNATE || param3 && !param4 && !param5) && (this.m_RawMod != Keyboard.CONTROL || !param3 && param4 && !param5) && (this.m_RawMod != Keyboard.SHIFT || !param3 && !param4 && param5);
      }
      
      public function get editable() : Boolean
      {
         return this.m_Editable;
      }
      
      public function get keyCode() : uint
      {
         return this.m_RawKey;
      }
      
      public function get action() : IAction
      {
         return this.m_Action;
      }
      
      public function equals(param1:Binding) : Boolean
      {
         return param1 != null && this.m_Action.equals(param1.m_Action) && this.m_EventMask == param1.m_EventMask && this.m_RawKey == param1.m_RawKey && this.m_RawMod == param1.m_RawMod && this.m_Editable == param1.m_Editable;
      }
   }
}
