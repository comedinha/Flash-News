package tibia.input
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.ui.Keyboard;
   import mx.events.PropertyChangeEvent;
   import mx.resources.ResourceManager;
   import shared.utility.StringHelper;
   import tibia.input.mapping.Binding;
   import tibia.input.mapping.Mapping;
   import tibia.input.staticaction.StaticActionList;
   
   public class MappingSet implements IEventDispatcher
   {
      
      public static const DEFAULT_SET:int = 0;
      
      protected static const OPTIONS_MAX_COMPATIBLE_VERSION:Number = 5;
      
      public static const NUM_SETS:int = 12;
      
      public static const CHAT_MODE_OFF_DEFAULT_BINDINGS:Array = [new Binding(StaticActionList.MISC_LOGOUT_CHARACTER,"Q",Keyboard.Q,Keyboard.CONTROL),new Binding(StaticActionList.MISC_CHANGE_CHARACTER,"F",Keyboard.F,Keyboard.CONTROL),new Binding(StaticActionList.MISC_SHOW_EDIT_OPTIONS,"Z",Keyboard.Z,Keyboard.CONTROL),new Binding(StaticActionList.MISC_SHOW_EDIT_HOTKEYS,"K",Keyboard.K,Keyboard.CONTROL),new Binding(StaticActionList.PLAYER_MOUNT,"M",Keyboard.M,Keyboard.CONTROL),new Binding(StaticActionList.PLAYER_CANCEL,0,Keyboard.ESCAPE,0),new Binding(StaticActionList.MISC_TOGGLE_MAPPING_MODE,0,Keyboard.ENTER,Keyboard.CONTROL),new Binding(StaticActionList.CHAT_COPYPASTE_SELECT,"A",Keyboard.A,Keyboard.CONTROL,null,false),new Binding(StaticActionList.CHAT_COPYPASTE_COPY,"C",Keyboard.C,Keyboard.CONTROL,null,false),new Binding(StaticActionList.CHAT_SEND_TEXT,0,Keyboard.ENTER,0,null,false),new Binding(StaticActionList.PLAYER_MOVE_UP,0,Keyboard.UP,0),new Binding(StaticActionList.PLAYER_MOVE_UP,0,Keyboard.NUMPAD_8,0),new Binding(StaticActionList.PLAYER_MOVE_LEFT,0,Keyboard.LEFT,0),new Binding(StaticActionList.PLAYER_MOVE_LEFT,0,Keyboard.NUMPAD_4,0),new Binding(StaticActionList.PLAYER_MOVE_RIGHT,0,Keyboard.RIGHT,0),new Binding(StaticActionList.PLAYER_MOVE_RIGHT,0,Keyboard.NUMPAD_6,0),new Binding(StaticActionList.PLAYER_MOVE_DOWN,0,Keyboard.DOWN,0),new Binding(StaticActionList.PLAYER_MOVE_DOWN,0,Keyboard.NUMPAD_2,0),new Binding(StaticActionList.PLAYER_MOVE_UP_LEFT,0,Keyboard.NUMPAD_7,0),new Binding(StaticActionList.PLAYER_MOVE_DOWN_LEFT,0,Keyboard.NUMPAD_1,0),new Binding(StaticActionList.PLAYER_MOVE_UP_RIGHT,0,Keyboard.NUMPAD_9,0),new Binding(StaticActionList.PLAYER_MOVE_DOWN_RIGHT,0,Keyboard.NUMPAD_3,0),new Binding(StaticActionList.PLAYER_TURN_UP,0,Keyboard.UP,Keyboard.CONTROL),new Binding(StaticActionList.PLAYER_TURN_LEFT,0,Keyboard.LEFT,Keyboard.CONTROL),new Binding(StaticActionList.PLAYER_TURN_RIGHT,0,Keyboard.RIGHT,Keyboard.CONTROL),new Binding(StaticActionList.PLAYER_TURN_DOWN,0,Keyboard.DOWN,Keyboard.CONTROL)];
      
      protected static const OPTIONS_MIN_COMPATIBLE_VERSION:Number = 2;
      
      private static const BUNDLE:String = "InputHandler";
      
      public static const CHAT_MODE_ON_DEFAULT_BINDINGS:Array = [new Binding(StaticActionList.MISC_LOGOUT_CHARACTER,"Q",Keyboard.Q,Keyboard.CONTROL),new Binding(StaticActionList.MISC_CHANGE_CHARACTER,"F",Keyboard.F,Keyboard.CONTROL),new Binding(StaticActionList.MISC_SHOW_EDIT_OPTIONS,"Z",Keyboard.Z,Keyboard.CONTROL),new Binding(StaticActionList.MISC_SHOW_EDIT_HOTKEYS,"K",Keyboard.K,Keyboard.CONTROL),new Binding(StaticActionList.PLAYER_MOUNT,"M",Keyboard.M,Keyboard.CONTROL),new Binding(StaticActionList.PLAYER_CANCEL,0,Keyboard.ESCAPE,0),new Binding(StaticActionList.MISC_TOGGLE_MAPPING_MODE,0,Keyboard.ENTER,Keyboard.CONTROL),new Binding(StaticActionList.CHAT_MOVE_CURSOR_LEFT,0,Keyboard.LEFT,Keyboard.SHIFT),new Binding(StaticActionList.CHAT_MOVE_CURSOR_RIGHT,0,Keyboard.RIGHT,Keyboard.SHIFT),new Binding(StaticActionList.CHAT_HISTORY_PREV,0,Keyboard.UP,Keyboard.SHIFT),new Binding(StaticActionList.CHAT_HISTORY_NEXT,0,Keyboard.DOWN,Keyboard.SHIFT),new Binding(StaticActionList.CHAT_TEXT_INPUT,0,0,0,null,false),new Binding(StaticActionList.CHAT_MOVE_CURSOR_HOME,0,Keyboard.HOME,0,null,false),new Binding(StaticActionList.CHAT_MOVE_CURSOR_END,0,Keyboard.END,0,null,false),new Binding(StaticActionList.CHAT_COPYPASTE_SELECT,"A",Keyboard.A,Keyboard.CONTROL,null,false),new Binding(StaticActionList.CHAT_COPYPASTE_COPY,"C",Keyboard.C,Keyboard.CONTROL,null,false),new Binding(StaticActionList.CHAT_COPYPASTE_INSERT,"V",Keyboard.V,Keyboard.CONTROL,null,false),new Binding(StaticActionList.CHAT_COPYPASTE_CUT,"X",Keyboard.X,Keyboard.CONTROL,null,false),new Binding(StaticActionList.CHAT_DELETE_PREV,0,Keyboard.BACKSPACE,0,null,false),new Binding(StaticActionList.CHAT_DELETE_NEXT,0,Keyboard.DELETE,0,null,false),new Binding(StaticActionList.CHAT_SEND_TEXT,0,Keyboard.ENTER,0,null,false),new Binding(StaticActionList.PLAYER_MOVE_UP,0,Keyboard.UP,0),new Binding(StaticActionList.PLAYER_MOVE_UP,0,Keyboard.NUMPAD_8,0),new Binding(StaticActionList.PLAYER_MOVE_LEFT,0,Keyboard.LEFT,0),new Binding(StaticActionList.PLAYER_MOVE_LEFT,0,Keyboard.NUMPAD_4,0),new Binding(StaticActionList.PLAYER_MOVE_RIGHT,0,Keyboard.RIGHT,0),new Binding(StaticActionList.PLAYER_MOVE_RIGHT,0,Keyboard.NUMPAD_6,0),new Binding(StaticActionList.PLAYER_MOVE_DOWN,0,Keyboard.DOWN,0),new Binding(StaticActionList.PLAYER_MOVE_DOWN,0,Keyboard.NUMPAD_2,0),new Binding(StaticActionList.PLAYER_MOVE_UP_LEFT,0,Keyboard.NUMPAD_7,0),new Binding(StaticActionList.PLAYER_MOVE_DOWN_LEFT,0,Keyboard.NUMPAD_1,0),new Binding(StaticActionList.PLAYER_MOVE_UP_RIGHT,0,Keyboard.NUMPAD_9,0),new Binding(StaticActionList.PLAYER_MOVE_DOWN_RIGHT,0,Keyboard.NUMPAD_3,0),new Binding(StaticActionList.PLAYER_TURN_UP,0,Keyboard.UP,Keyboard.CONTROL),new Binding(StaticActionList.PLAYER_TURN_LEFT,0,Keyboard.LEFT,Keyboard.CONTROL),new Binding(StaticActionList.PLAYER_TURN_RIGHT,0,Keyboard.RIGHT,Keyboard.CONTROL),new Binding(StaticActionList.PLAYER_TURN_DOWN,0,Keyboard.DOWN,Keyboard.CONTROL)];
      
      public static const CHAT_MODE_OFF:int = 1;
      
      public static const CHAT_MODE_ON:int = 0;
      
      public static const CHAT_MODE_TEMPORARY:int = 2;
      
      private static const MAX_NAME_LENGTH:int = 10;
       
      
      protected var m_ChatModeOn:Mapping = null;
      
      protected var m_ChatModeOff:Mapping = null;
      
      protected var m_ID:int = 0;
      
      private var _bindingEventDispatcher:EventDispatcher;
      
      protected var m_Name:String = null;
      
      public function MappingSet(param1:int, param2:String = null)
      {
         this._bindingEventDispatcher = new EventDispatcher(IEventDispatcher(this));
         super();
         this.m_ID = param1;
         this.m_ChatModeOn = new Mapping();
         this.m_ChatModeOff = new Mapping();
         this.m_Name = s_GetSanitizedSetName(param1,param2,true);
      }
      
      public static function s_Unmarshall(param1:XML, param2:Number) : MappingSet
      {
         var _loc5_:String = null;
         var _loc7_:XML = null;
         var _loc8_:int = 0;
         if(param1 == null || param1.localName() != "mappingset" || param2 < OPTIONS_MIN_COMPATIBLE_VERSION || param2 > OPTIONS_MAX_COMPATIBLE_VERSION)
         {
            throw new Error("MappingSet.s_Unmarshall: Invalid input.");
         }
         var _loc3_:XMLList = null;
         if((_loc3_ = param1.@id) == null || _loc3_.length() != 1)
         {
            return null;
         }
         var _loc4_:int = parseInt(_loc3_[0].toString());
         if((_loc3_ = param1.@name) == null || _loc3_.length() != 1)
         {
            return null;
         }
         _loc5_ = s_GetSanitizedSetName(_loc4_,_loc3_[0].toString(),true);
         var _loc6_:MappingSet = new MappingSet(_loc4_,_loc5_);
         _loc6_.initialiseDefaultBindings();
         if(param2 >= 4)
         {
            for each(_loc7_ in param1.elements("mapping"))
            {
               _loc8_ = -1;
               if((_loc3_ = _loc7_.@mode) != null && _loc3_.length() == 1)
               {
                  _loc8_ = parseInt(_loc3_[0].toString());
               }
               if(_loc8_ == CHAT_MODE_ON)
               {
                  _loc6_.m_ChatModeOn.removeAll();
                  Mapping.s_Unmarshall(_loc7_,param2,_loc6_.m_ChatModeOn);
               }
               else if(_loc8_ == CHAT_MODE_OFF)
               {
                  _loc6_.m_ChatModeOff.removeAll();
                  Mapping.s_Unmarshall(_loc7_,param2,_loc6_.m_ChatModeOff);
               }
            }
         }
         return _loc6_;
      }
      
      public static function s_GetSanitizedSetName(param1:int, param2:String, param3:Boolean) : String
      {
         if(param2 != null)
         {
            param2 = StringHelper.s_StripNewline(param2);
            param2 = StringHelper.s_TrimFront(param2);
            if(param3)
            {
               param2 = StringHelper.s_TrimBack(param2);
            }
            param2 = param2.substr(0,MAX_NAME_LENGTH);
         }
         if(param2 == null || param2.length < 1)
         {
            param2 = ResourceManager.getInstance().getString(BUNDLE,"MAPPINGSET_DEFAULT_NAME",[param1 + 1]);
         }
         return param2;
      }
      
      private function set _1836514214chatModeOn(param1:Mapping) : void
      {
         if(param1 != null)
         {
            this.m_ChatModeOn = param1;
            return;
         }
         throw new ArgumentError("MappingSet.set chatModeOn: Invalid mapping.");
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      public function get name() : String
      {
         return this.m_Name;
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public function marshall() : XML
      {
         var _loc1_:XML = this.m_ChatModeOn.marshall();
         _loc1_.@mode = CHAT_MODE_ON;
         var _loc2_:XML = this.m_ChatModeOff.marshall();
         _loc2_.@mode = CHAT_MODE_OFF;
         return <mappingset id="{this.m_ID}" name="{this.m_Name}">{_loc1_}{_loc2_}</mappingset>;
      }
      
      function changeID(param1:int) : void
      {
         this.m_ID = param1;
      }
      
      public function get chatModeOff() : Mapping
      {
         return this.m_ChatModeOff;
      }
      
      [Bindable(event="propertyChange")]
      public function set name(param1:String) : void
      {
         var _loc2_:Object = this.name;
         if(_loc2_ !== param1)
         {
            this._3373707name = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"name",_loc2_,param1));
         }
      }
      
      public function get ID() : int
      {
         return this.m_ID;
      }
      
      private function set _3373707name(param1:String) : void
      {
         this.m_Name = s_GetSanitizedSetName(this.m_ID,param1,true);
      }
      
      public function clone() : MappingSet
      {
         var _loc1_:MappingSet = new MappingSet(this.m_ID);
         _loc1_.m_ChatModeOn = this.m_ChatModeOn.clone();
         _loc1_.m_ChatModeOff = this.m_ChatModeOff.clone();
         return _loc1_;
      }
      
      public function get chatModeOn() : Mapping
      {
         return this.m_ChatModeOn;
      }
      
      private function set _1097365932chatModeOff(param1:Mapping) : void
      {
         if(param1 != null)
         {
            this.m_ChatModeOff = param1;
            return;
         }
         throw new ArgumentError("MappingSet.set chatModeOff: Invalid mapping.");
      }
      
      [Bindable(event="propertyChange")]
      public function set chatModeOff(param1:Mapping) : void
      {
         var _loc2_:Object = this.chatModeOff;
         if(_loc2_ !== param1)
         {
            this._1097365932chatModeOff = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"chatModeOff",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function set chatModeOn(param1:Mapping) : void
      {
         var _loc2_:Object = this.chatModeOn;
         if(_loc2_ !== param1)
         {
            this._1836514214chatModeOn = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"chatModeOn",_loc2_,param1));
         }
      }
      
      public function initialiseDefaultBindings() : void
      {
         this.m_ChatModeOn.removeAll(false);
         this.m_ChatModeOn.addAll(CHAT_MODE_ON_DEFAULT_BINDINGS);
         this.m_ChatModeOff.removeAll(false);
         this.m_ChatModeOff.addAll(CHAT_MODE_OFF_DEFAULT_BINDINGS);
      }
   }
}
