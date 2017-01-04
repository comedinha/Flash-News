package tibia.input.mapping
{
   import flash.events.MouseEvent;
   import flash.ui.Keyboard;
   import mx.collections.IList;
   import tibia.input.InputHandler;
   import tibia.input.MouseClickBothEvent;
   
   public class MouseMapping
   {
      
      protected static const RENDERER_DEFAULT_HEIGHT:Number = MAP_WIDTH * FIELD_SIZE;
      
      private static const KEYMODIFIED_LEFT_CLICK_BINDINGS:Array = [new MouseBinding(MOUSE_BUTTON_LEFT,0,ACTION_AUTOWALK),new MouseBinding(MOUSE_BUTTON_MIDDLE,0,ACTION_ATTACK_OR_TALK),new MouseBinding(MOUSE_BUTTON_RIGHT,0,ACTION_CONTEXT_MENU),new MouseBinding(MOUSE_BUTTON_LEFT,Keyboard.SHIFT,ACTION_LOOK),new MouseBinding(MOUSE_BUTTON_RIGHT,Keyboard.SHIFT,ACTION_LOOK),new MouseBinding(MOUSE_BUTTON_LEFT,Keyboard.CONTROL,ACTION_USE_OR_OPEN),new MouseBinding(MOUSE_BUTTON_RIGHT,Keyboard.CONTROL,ACTION_USE_OR_OPEN),new MouseBinding(MOUSE_BUTTON_LEFT,Keyboard.ALTERNATE,ACTION_ATTACK_OR_TALK),new MouseBinding(MOUSE_BUTTON_RIGHT,Keyboard.ALTERNATE,ACTION_ATTACK_OR_TALK)];
      
      private static const ACTION_LOOK:int = 6;
      
      protected static const OPTIONS_MAX_COMPATIBLE_VERSION:Number = 5;
      
      private static const ACTION_SMARTCLICK:int = 100;
      
      private static const ACTION_TALK:int = 9;
      
      protected static const NUM_EFFECTS:int = 200;
      
      protected static const ONSCREEN_MESSAGE_WIDTH:int = 295;
      
      protected static const FIELD_ENTER_POSSIBLE:uint = 0;
      
      private static const MOUSE_BUTTON_MIDDLE:int = 3;
      
      private static const SMART_LEFT_CLICK_BINDINGS:Array = [new MouseBinding(MOUSE_BUTTON_LEFT,0,ACTION_SMARTCLICK),new MouseBinding(MOUSE_BUTTON_MIDDLE,0,ACTION_AUTOWALK),new MouseBinding(MOUSE_BUTTON_RIGHT,0,ACTION_CONTEXT_MENU),new MouseBinding(MOUSE_BUTTON_LEFT,Keyboard.SHIFT,ACTION_LOOK),new MouseBinding(MOUSE_BUTTON_LEFT,Keyboard.CONTROL,ACTION_AUTOWALK)];
      
      protected static const FIELD_ENTER_NOT_POSSIBLE:uint = 2;
      
      protected static const FIELD_HEIGHT:int = 24;
      
      public static const PRESET_KEYMODIFIED_LEFT_CLICK:MouseMapping = new MouseMapping(KEYMODIFIED_LEFT_CLICK_BINDINGS);
      
      private static const MOUSE_BUTTON_RIGHT:int = 2;
      
      protected static const UNDERGROUND_LAYER:int = 2;
      
      protected static const ONSCREEN_MESSAGE_HEIGHT:int = 195;
      
      private static const MOUSE_BUTTON_LEFT:int = 1;
      
      protected static const FIELD_CACHESIZE:int = FIELD_SIZE;
      
      protected static const FIELD_SIZE:int = 32;
      
      protected static const FIELD_ENTER_POSSIBLE_NO_ANIMATION:uint = 1;
      
      protected static const PLAYER_OFFSET_X:int = 8;
      
      protected static const PLAYER_OFFSET_Y:int = 6;
      
      private static const EMPTY_BINDING:Array = [new MouseBinding(MOUSE_BUTTON_LEFT,0,0),new MouseBinding(MOUSE_BUTTON_MIDDLE,0,0),new MouseBinding(MOUSE_BUTTON_RIGHT,0,0),new MouseBinding(MOUSE_BUTTON_LEFT,Keyboard.SHIFT,0),new MouseBinding(MOUSE_BUTTON_MIDDLE,Keyboard.SHIFT,0),new MouseBinding(MOUSE_BUTTON_RIGHT,Keyboard.SHIFT,0),new MouseBinding(MOUSE_BUTTON_LEFT,Keyboard.CONTROL,0),new MouseBinding(MOUSE_BUTTON_MIDDLE,Keyboard.CONTROL,0),new MouseBinding(MOUSE_BUTTON_RIGHT,Keyboard.CONTROL,0),new MouseBinding(MOUSE_BUTTON_LEFT,Keyboard.ALTERNATE,0),new MouseBinding(MOUSE_BUTTON_MIDDLE,Keyboard.ALTERNATE,0),new MouseBinding(MOUSE_BUTTON_RIGHT,Keyboard.ALTERNATE,0),new MouseBinding(MOUSE_BUTTON_BOTH,0,0)];
      
      protected static const MAP_MAX_X:int = MAP_MIN_X + (1 << 14 - 1);
      
      protected static const OPTIONS_MIN_COMPATIBLE_VERSION:Number = 2;
      
      protected static const MAP_MAX_Z:int = 15;
      
      protected static const NUM_ONSCREEN_MESSAGES:int = 16;
      
      protected static const MAP_MAX_Y:int = MAP_MIN_Y + (1 << 14 - 1);
      
      public static const PRESET_SMART_RIGHT_CLICK:MouseMapping = new MouseMapping(SMART_RIGHT_CLICK_BINDINGS);
      
      private static const ACTION_ATTACK:int = 1;
      
      private static const ACTION_CONTEXT_MENU:int = 5;
      
      protected static const GROUND_LAYER:int = 7;
      
      protected static const MAP_HEIGHT:int = 11;
      
      protected static const RENDERER_DEFAULT_WIDTH:Number = MAP_WIDTH * FIELD_SIZE;
      
      private static const ACTION_NONE:int = 0;
      
      protected static const NUM_FIELDS:int = MAPSIZE_Z * MAPSIZE_Y * MAPSIZE_X;
      
      private static const ACTION_OPEN:int = 8;
      
      private static const ACTION_ATTACK_OR_TALK:int = 102;
      
      private static const MOUSE_BUTTON_BOTH:int = 4;
      
      private static const ACTION_UNSET:int = -1;
      
      private static const ACTION_AUTOWALK_HIGHLIGHT:int = 4;
      
      protected static const MAP_MIN_X:int = 24576;
      
      protected static const MAP_MIN_Y:int = 24576;
      
      protected static const MAP_MIN_Z:int = 0;
      
      private static const ACTION_USE_OR_OPEN:int = 101;
      
      protected static const RENDERER_MIN_HEIGHT:Number = Math.round(MAP_HEIGHT * 2 / 3 * FIELD_SIZE);
      
      protected static const MAPSIZE_W:int = 10;
      
      protected static const MAPSIZE_X:int = MAP_WIDTH + 3;
      
      protected static const MAPSIZE_Y:int = MAP_HEIGHT + 3;
      
      protected static const MAPSIZE_Z:int = 8;
      
      protected static const RENDERER_MIN_WIDTH:Number = Math.round(MAP_WIDTH * 2 / 3 * FIELD_SIZE);
      
      private static const ACTION_USE:int = 7;
      
      private static const ACTION_AUTOWALK:int = 3;
      
      protected static const MAP_WIDTH:int = 15;
      
      public static const PRESET_SMART_LEFT_CLICK:MouseMapping = new MouseMapping(SMART_LEFT_CLICK_BINDINGS);
      
      private static const SMART_RIGHT_CLICK_BINDINGS:Array = [new MouseBinding(MOUSE_BUTTON_LEFT,0,ACTION_AUTOWALK),new MouseBinding(MOUSE_BUTTON_MIDDLE,0,ACTION_LOOK),new MouseBinding(MOUSE_BUTTON_RIGHT,0,ACTION_SMARTCLICK),new MouseBinding(MOUSE_BUTTON_LEFT,Keyboard.SHIFT,ACTION_LOOK),new MouseBinding(MOUSE_BUTTON_RIGHT,Keyboard.SHIFT,ACTION_LOOK),new MouseBinding(MOUSE_BUTTON_LEFT,Keyboard.CONTROL,ACTION_CONTEXT_MENU),new MouseBinding(MOUSE_BUTTON_RIGHT,Keyboard.CONTROL,ACTION_CONTEXT_MENU),new MouseBinding(MOUSE_BUTTON_LEFT,Keyboard.ALTERNATE,ACTION_SMARTCLICK),new MouseBinding(MOUSE_BUTTON_RIGHT,Keyboard.ALTERNATE,ACTION_SMARTCLICK),new MouseBinding(MOUSE_BUTTON_BOTH,0,ACTION_LOOK)];
       
      
      protected var m_MouseBindings:Vector.<MouseBinding>;
      
      private var m_ShowMouseCursorForAction:Boolean = true;
      
      public function MouseMapping(param1:* = null)
      {
         this.m_MouseBindings = new Vector.<MouseBinding>(EMPTY_BINDING.length,true);
         super();
         var _loc2_:int = 0;
         while(_loc2_ < EMPTY_BINDING.length)
         {
            this.m_MouseBindings[_loc2_] = EMPTY_BINDING[_loc2_].clone();
            _loc2_++;
         }
         if(param1 != null)
         {
            this.addAll(param1);
         }
      }
      
      public static function s_Unmarshall(param1:XML, param2:Number, param3:MouseMapping) : MouseMapping
      {
         var _loc5_:XML = null;
         var _loc6_:MouseBinding = null;
         if(param1 == null || param1.localName() != "mousemapping" || param2 < OPTIONS_MIN_COMPATIBLE_VERSION || param2 > OPTIONS_MAX_COMPATIBLE_VERSION)
         {
            throw new Error("MouseMapping.s_Unmarshall: Invalid input.");
         }
         if(param3 == null)
         {
            throw new Error("MouseMapping.s_Unmarshall: Invalid mapping.");
         }
         var _loc4_:XMLList = null;
         if((_loc4_ = param1.@showMouseCursorForAction) == null || _loc4_.length() != 1)
         {
            return null;
         }
         param3.showMouseCursorForAction = _loc4_[0].toString() == "true";
         for each(_loc5_ in param1.elements("mousebinding"))
         {
            _loc6_ = MouseBinding.s_Unmarshall(_loc5_,param2);
            if(_loc6_ != null)
            {
               param3.setBinding(_loc6_);
            }
         }
         return param3;
      }
      
      public function addAll(param1:*) : void
      {
         if(!(param1 is Array) && !(param1 is Vector.<MouseBinding>) && !(param1 is IList))
         {
            throw new ArgumentError("MouseMapping.addAll: Invalid input(1).");
         }
         var _loc2_:int = param1.length;
         var _loc3_:int = this.m_MouseBindings.length;
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_)
         {
            if(param1[_loc4_] == null)
            {
               throw new ArgumentError("MouseMapping.addAll: Invalid input(2).");
            }
            this.setBinding(param1[_loc4_]);
            _loc4_++;
         }
      }
      
      public function get showMouseCursorForAction() : Boolean
      {
         return this.m_ShowMouseCursorForAction;
      }
      
      public function setBinding(param1:MouseBinding) : void
      {
         if(param1 == null)
         {
            throw new ArgumentError("MouseMapping.setBinding: Invalid input.");
         }
         var _loc2_:MouseBinding = this.findBinding(param1.mouseButton,param1.modifierKey);
         if(_loc2_ != null)
         {
            _loc2_.action = param1.action;
         }
      }
      
      public function set showMouseCursorForAction(param1:Boolean) : void
      {
         this.m_ShowMouseCursorForAction = param1;
      }
      
      public function findBindingForLeftMouseButtonAndPressedModifierKey() : MouseBinding
      {
         return this.findBinding(MOUSE_BUTTON_LEFT,this.internalGetModifierKey());
      }
      
      public function get mouseBindings() : Vector.<MouseBinding>
      {
         return this.m_MouseBindings;
      }
      
      public function findBinding(param1:uint, param2:uint) : MouseBinding
      {
         var _loc3_:MouseBinding = null;
         for each(_loc3_ in this.m_MouseBindings)
         {
            if(_loc3_.appliesTo(param1,param2))
            {
               return _loc3_;
            }
         }
         return null;
      }
      
      public function replaceAll(param1:*) : void
      {
         if(!(param1 is Array) && !(param1 is Vector.<MouseBinding>) && !(param1 is IList))
         {
            throw new ArgumentError("MouseMapping.addAll: Invalid input(1).");
         }
         this.addAll(EMPTY_BINDING);
         this.addAll(param1);
      }
      
      public function marshall() : XML
      {
         var _loc2_:MouseBinding = null;
         var _loc1_:XML = <mousemapping showMouseCursorForAction="{this.m_ShowMouseCursorForAction}"></mousemapping>;
         for each(_loc2_ in this.m_MouseBindings)
         {
            _loc1_.appendChild(_loc2_.marshall());
         }
         return _loc1_;
      }
      
      private function internalGetModifierKey() : uint
      {
         var _loc1_:InputHandler = Tibia.s_GetInputHandler();
         if(_loc1_.isKeyPressed(Keyboard.CONTROL))
         {
            return Keyboard.CONTROL;
         }
         if(_loc1_.isKeyPressed(Keyboard.SHIFT))
         {
            return Keyboard.SHIFT;
         }
         if(_loc1_.isKeyPressed(Keyboard.ALTERNATE))
         {
            return Keyboard.ALTERNATE;
         }
         return 0;
      }
      
      public function equals(param1:MouseMapping) : Boolean
      {
         var _loc2_:MouseBinding = null;
         for each(_loc2_ in this.m_MouseBindings)
         {
            if(!_loc2_.equals(param1.findBinding(_loc2_.mouseButton,_loc2_.modifierKey)))
            {
               return false;
            }
         }
         return true;
      }
      
      public function initialiseDefaultBindings() : void
      {
         this.addAll(EMPTY_BINDING);
         this.addAll(SMART_LEFT_CLICK_BINDINGS);
      }
      
      public function findBindingByMouseEvent(param1:MouseEvent) : MouseBinding
      {
         if(param1 == null)
         {
            return null;
         }
         var _loc2_:uint = 0;
         if(param1 is MouseClickBothEvent)
         {
            _loc2_ = MOUSE_BUTTON_BOTH;
         }
         else if(param1.type == MouseEvent.CLICK || param1.type == MouseEvent.ROLL_OUT || param1.type == MouseEvent.ROLL_OVER || param1.type == MouseEvent.MOUSE_DOWN || param1.type == MouseEvent.MOUSE_UP || param1.type == MouseEvent.MOUSE_OVER || param1.type == MouseEvent.MOUSE_OUT || param1.type == MouseEvent.MOUSE_MOVE)
         {
            _loc2_ = MOUSE_BUTTON_LEFT;
         }
         else if(param1.type == MouseEvent.RIGHT_CLICK || param1.type == MouseEvent.RIGHT_MOUSE_DOWN || param1.type == MouseEvent.RIGHT_MOUSE_UP)
         {
            _loc2_ = MOUSE_BUTTON_RIGHT;
         }
         else if(param1.type == MouseEvent.MIDDLE_CLICK || param1.type == MouseEvent.MIDDLE_MOUSE_DOWN || param1.type == MouseEvent.MIDDLE_MOUSE_UP)
         {
            _loc2_ = MOUSE_BUTTON_MIDDLE;
         }
         var _loc3_:uint = 0;
         if(param1.ctrlKey)
         {
            _loc3_ = Keyboard.CONTROL;
         }
         else if(param1.shiftKey)
         {
            _loc3_ = Keyboard.SHIFT;
         }
         else if(param1.altKey)
         {
            _loc3_ = Keyboard.ALTERNATE;
         }
         return this.findBinding(_loc2_,_loc3_);
      }
   }
}
