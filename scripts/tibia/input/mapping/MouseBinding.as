package tibia.input.mapping
{
   import flash.ui.Keyboard;
   import mx.resources.ResourceManager;
   import mx.resources.IResourceManager;
   
   public class MouseBinding
   {
      
      private static const ACTION_UNSET:int = -1;
      
      private static const MOUSE_BUTTON_LEFT:int = 1;
      
      private static const MOUSE_BUTTON_BOTH:int = 4;
      
      private static const ACTION_USE_OR_OPEN:int = 101;
      
      private static const ACTION_LOOK:int = 6;
      
      protected static const OPTIONS_MAX_COMPATIBLE_VERSION:Number = 5;
      
      private static const MOUSE_BUTTON_RIGHT:int = 2;
      
      private static const ACTION_SMARTCLICK:int = 100;
      
      private static const ACTION_TALK:int = 9;
      
      private static const BUNDLE:String = "InputHandler";
      
      protected static const OPTIONS_MIN_COMPATIBLE_VERSION:Number = 2;
      
      private static const ACTION_USE:int = 7;
      
      private static const MOUSE_BUTTON_MIDDLE:int = 3;
      
      private static const ACTION_NONE:int = 0;
      
      private static const ACTION_AUTOWALK:int = 3;
      
      private static const ACTION_ATTACK:int = 1;
      
      private static const ACTION_OPEN:int = 8;
      
      private static const ACTION_CONTEXT_MENU:int = 5;
      
      private static const ACTION_ATTACK_OR_TALK:int = 102;
      
      private static const ACTION_AUTOWALK_HIGHLIGHT:int = 4;
       
      
      private var m_MouseButton:uint = 1;
      
      private var m_Action:uint = 0;
      
      private var m_ModifierKey:uint = 16.0;
      
      public function MouseBinding(param1:uint, param2:uint, param3:uint)
      {
         super();
         this.m_MouseButton = param1;
         this.m_ModifierKey = param2;
         this.m_Action = param3;
      }
      
      public static function s_Unmarshall(param1:XML, param2:Number) : MouseBinding
      {
         if(param1 == null || param1.localName() != "mousebinding" || param2 < OPTIONS_MIN_COMPATIBLE_VERSION || param2 > OPTIONS_MAX_COMPATIBLE_VERSION)
         {
            throw new Error("MouseBinding.s_Unmarshall: Invalid input.");
         }
         var _loc3_:XMLList = null;
         if((_loc3_ = param1.@mouseButton) == null || _loc3_.length() != 1)
         {
            return null;
         }
         var _loc4_:uint = parseInt(_loc3_.toString());
         if(_loc4_ != MOUSE_BUTTON_LEFT && _loc4_ != MOUSE_BUTTON_RIGHT && _loc4_ != MOUSE_BUTTON_MIDDLE && _loc4_ != MOUSE_BUTTON_BOTH)
         {
            return null;
         }
         if((_loc3_ = param1.@modifierCode) == null || _loc3_.length() != 1)
         {
            return null;
         }
         var _loc5_:uint = parseInt(_loc3_.toString());
         if(_loc5_ != 0 && _loc5_ != Keyboard.CONTROL && _loc5_ != Keyboard.ALTERNATE && _loc5_ != Keyboard.SHIFT)
         {
            return null;
         }
         if((_loc3_ = param1.@action) == null || _loc3_.length() != 1)
         {
            return null;
         }
         var _loc6_:uint = parseInt(_loc3_.toString());
         if(_loc6_ != ACTION_NONE && _loc6_ != ACTION_ATTACK_OR_TALK && _loc6_ != ACTION_USE_OR_OPEN && _loc6_ != ACTION_LOOK && _loc6_ != ACTION_AUTOWALK && _loc6_ != ACTION_CONTEXT_MENU && _loc6_ != ACTION_SMARTCLICK)
         {
            return null;
         }
         return new MouseBinding(_loc4_,_loc5_,_loc6_);
      }
      
      public function toString() : String
      {
         return this.formatAsString();
      }
      
      public function appliesTo(param1:uint, param2:uint) : Boolean
      {
         return this.m_MouseButton == param1 && this.m_ModifierKey == param2;
      }
      
      public function set action(param1:uint) : void
      {
         this.m_Action = param1;
      }
      
      public function marshall() : XML
      {
         var _loc1_:XML = <mousebinding mouseButton="{this.m_MouseButton}" modifierCode="{this.m_ModifierKey}" action="{this.m_Action}"/>;
         return _loc1_;
      }
      
      public function get modifierKey() : uint
      {
         return this.m_ModifierKey;
      }
      
      public function clone() : MouseBinding
      {
         return new MouseBinding(this.m_MouseButton,this.m_ModifierKey,this.m_Action);
      }
      
      public function get mouseButton() : uint
      {
         return this.m_MouseButton;
      }
      
      private function formatAsString() : String
      {
         var _loc1_:IResourceManager = ResourceManager.getInstance();
         var _loc2_:* = null;
         if(this.m_ModifierKey == Keyboard.ALTERNATE)
         {
            _loc2_ = _loc1_.getString(BUNDLE,"BINDING_KEY_ALTERNATE") + " + ";
         }
         else if(this.m_ModifierKey == Keyboard.CONTROL)
         {
            _loc2_ = _loc1_.getString(BUNDLE,"BINDING_KEY_CONTROL") + " + ";
         }
         else if(this.m_ModifierKey == Keyboard.SHIFT)
         {
            _loc2_ = _loc1_.getString(BUNDLE,"BINDING_KEY_SHIFT") + " + ";
         }
         else
         {
            _loc2_ = "";
         }
         var _loc3_:uint = 0;
         if(this.m_MouseButton == MOUSE_BUTTON_LEFT)
         {
            _loc2_ = _loc2_ + _loc1_.getString(BUNDLE,"MOUSE_BINDING_BUTTON_LEFT");
         }
         else if(this.m_MouseButton == MOUSE_BUTTON_MIDDLE)
         {
            _loc2_ = _loc2_ + _loc1_.getString(BUNDLE,"MOUSE_BINDING_BUTTON_MIDDLE");
         }
         else if(this.m_MouseButton == MOUSE_BUTTON_RIGHT)
         {
            _loc2_ = _loc2_ + _loc1_.getString(BUNDLE,"MOUSE_BINDING_BUTTON_RIGHT");
         }
         else if(this.m_MouseButton == MOUSE_BUTTON_BOTH)
         {
            _loc2_ = _loc2_ + _loc1_.getString(BUNDLE,"MOUSE_BINDING_BUTTON_BOTH");
         }
         else
         {
            _loc2_ = _loc2_ + _loc1_.getString(BUNDLE,"MOUSE_BINDING_UNKNOWN");
         }
         return _loc2_;
      }
      
      public function get action() : uint
      {
         return this.m_Action;
      }
      
      public function equals(param1:MouseBinding) : Boolean
      {
         return param1 != null && this.appliesTo(param1.mouseButton,param1.modifierKey) && this.m_Action == param1.action;
      }
   }
}
