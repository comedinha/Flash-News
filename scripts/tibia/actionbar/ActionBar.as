package tibia.actionbar
{
   import flash.events.EventDispatcher;
   import tibia.input.IAction;
   import tibia.input.gameaction.EquipAction;
   import tibia.input.gameaction.SpellAction;
   import tibia.input.gameaction.TalkAction;
   import tibia.input.gameaction.UseAction;
   import tibia.options.OptionsStorage;
   import tibia.input.MappingSet;
   import tibia.input.mapping.Mapping;
   import tibia.input.staticaction.StaticActionList;
   import mx.resources.ResourceManager;
   import mx.events.PropertyChangeEvent;
   import mx.events.PropertyChangeEventKind;
   
   public class ActionBar extends EventDispatcher
   {
      
      public static const NUM_ACTIONS:int = 30;
      
      protected static const OPTIONS_MAX_COMPATIBLE_VERSION:Number = 5;
      
      public static const BUNDLE:String = "ActionBarWidget";
      
      protected static const OPTIONS_MIN_COMPATIBLE_VERSION:Number = 2;
       
      
      protected var m_Visible:Boolean = false;
      
      protected var m_Actions:Vector.<IAction> = null;
      
      protected var m_Location:int = -1;
      
      public function ActionBar(param1:int)
      {
         super();
         this.m_Actions = new Vector.<IAction>(NUM_ACTIONS,true);
         if(param1 != ActionBarSet.LOCATION_TOP && param1 != ActionBarSet.LOCATION_BOTTOM && param1 != ActionBarSet.LOCATION_LEFT && param1 != ActionBarSet.LOCATION_RIGHT)
         {
            throw new ArgumentError("ActionBar.ActionBar: Invalid location.");
         }
         this.m_Location = param1;
         this.m_Visible = false;
      }
      
      public static function s_Unmarshall(param1:XML, param2:Number) : ActionBar
      {
         var _loc6_:XML = null;
         var _loc7_:String = null;
         var _loc8_:IAction = null;
         var _loc9_:int = 0;
         if(param1 == null || param1.localName() != "actionbar" || param2 < OPTIONS_MIN_COMPATIBLE_VERSION || param2 > OPTIONS_MAX_COMPATIBLE_VERSION)
         {
            throw new Error("ActionBar.s_Unmarshall: Invalid input.");
         }
         var _loc3_:XMLList = null;
         if((_loc3_ = param1.@location) == null || _loc3_.length() != 1)
         {
            return null;
         }
         var _loc4_:int = parseInt(_loc3_[0].toString());
         if(_loc4_ != ActionBarSet.LOCATION_TOP && _loc4_ != ActionBarSet.LOCATION_BOTTOM && _loc4_ != ActionBarSet.LOCATION_LEFT && _loc4_ != ActionBarSet.LOCATION_RIGHT)
         {
            return null;
         }
         var _loc5_:ActionBar = new ActionBar(_loc4_);
         if((_loc3_ = param1.@visible) != null && _loc3_.length() == 1)
         {
            _loc5_.visible = _loc3_[0].toString() == "true";
         }
         for each(_loc6_ in param1.elements("action"))
         {
            _loc7_ = null;
            if((_loc3_ = _loc6_.@type) != null && _loc3_.length() == 1)
            {
               _loc7_ = _loc3_[0].toString();
            }
            _loc8_ = null;
            switch(_loc7_)
            {
               case "equip":
                  _loc8_ = EquipAction.s_Unmarshall(_loc6_,param2);
                  break;
               case "spell":
                  _loc8_ = SpellAction.s_Unmarshall(_loc6_,param2);
                  break;
               case "talk":
                  _loc8_ = TalkAction.s_Unmarshall(_loc6_,param2);
                  break;
               case "use":
                  _loc8_ = UseAction.s_Unmarshall(_loc6_,param2);
            }
            _loc9_ = -1;
            if((_loc3_ = _loc6_.@index) != null && _loc3_.length() == 1)
            {
               _loc9_ = parseInt(_loc3_[0].toString());
            }
            if(_loc9_ >= 0 && _loc9_ < NUM_ACTIONS && _loc8_ != null)
            {
               _loc5_.setAction(_loc9_,_loc8_);
            }
         }
         return _loc5_;
      }
      
      public static function getBindings(param1:int, param2:int, param3:int = -1) : Array
      {
         if(param2 < 0 || param2 >= NUM_ACTIONS)
         {
            throw new RangeError("ActionBar.getBindings: Invalid slot index: " + param2);
         }
         var _loc4_:OptionsStorage = Tibia.s_GetOptions();
         if(_loc4_ == null)
         {
            return [];
         }
         if(param3 < 0)
         {
            param3 = _loc4_.generalInputSetID;
         }
         var _loc5_:MappingSet = null;
         var _loc6_:Mapping = null;
         if((_loc5_ = _loc4_.getMappingSet(param3)) == null || (_loc6_ = _loc4_.generalInputSetMode == MappingSet.CHAT_MODE_OFF?_loc5_.chatModeOff:_loc5_.chatModeOn) == null)
         {
            throw new ArgumentError("ActionBar.getBindings: Invalid input set: " + param3);
         }
         return _loc6_.getBindingsByAction(StaticActionList.getActionButtonTrigger(param1,param2));
      }
      
      public static function getLabel(param1:int, param2:int) : String
      {
         if(param2 < 0 || param2 >= NUM_ACTIONS)
         {
            throw new RangeError("ActionBar.getLabel: Invalid slot: " + param2);
         }
         var _loc3_:String = null;
         switch(param1)
         {
            case ActionBarSet.LOCATION_BOTTOM:
               _loc3_ = "BAR_LABEL_BOTTOM";
               break;
            case ActionBarSet.LOCATION_LEFT:
               _loc3_ = "BAR_LABEL_LEFT";
               break;
            case ActionBarSet.LOCATION_RIGHT:
               _loc3_ = "BAR_LABEL_RIGHT";
               break;
            case ActionBarSet.LOCATION_TOP:
               _loc3_ = "BAR_LABEL_TOP";
               break;
            default:
               throw new RangeError("ActionBar.getLabel: Invalid location: " + param1);
         }
         return ResourceManager.getInstance().getString(BUNDLE,_loc3_,[param2 + 1]);
      }
      
      public function get size() : int
      {
         return this.m_Actions.length;
      }
      
      public function getTrigger(param1:int) : IAction
      {
         return StaticActionList.getActionButtonTrigger(this.m_Location,param1);
      }
      
      public function getBindings(param1:int, param2:int = -1) : Array
      {
         return ActionBar.getBindings(this.m_Location,param1,param2);
      }
      
      public function get length() : int
      {
         var _loc1_:int = 0;
         var _loc2_:int = this.m_Actions.length - 1;
         while(_loc2_ >= 0)
         {
            if(this.m_Actions[_loc2_] != null)
            {
               _loc1_++;
            }
            _loc2_--;
         }
         return _loc1_;
      }
      
      public function perform(param1:int) : void
      {
         var a_Index:int = param1;
         if(this.m_Actions[a_Index] != null)
         {
            try
            {
               this.m_Actions[a_Index].perform();
               return;
            }
            catch(_Error:*)
            {
               return;
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function set location(param1:int) : void
      {
         var _loc2_:Object = this.location;
         if(_loc2_ !== param1)
         {
            this._1901043637location = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"location",_loc2_,param1));
         }
      }
      
      public function getAction(param1:int) : IAction
      {
         return this.m_Actions[param1];
      }
      
      private function set _466743410visible(param1:Boolean) : void
      {
         this.m_Visible = param1;
      }
      
      private function set _1901043637location(param1:int) : void
      {
         if(param1 != ActionBarSet.LOCATION_TOP && param1 != ActionBarSet.LOCATION_BOTTOM && param1 != ActionBarSet.LOCATION_LEFT && param1 != ActionBarSet.LOCATION_RIGHT)
         {
            throw new ArgumentError("ActionBar.location: Invalid location.");
         }
         this.m_Location = param1;
      }
      
      public function get visible() : Boolean
      {
         return this.m_Visible;
      }
      
      public function get location() : int
      {
         return this.m_Location;
      }
      
      public function setAction(param1:int, param2:IAction) : void
      {
         var _loc3_:PropertyChangeEvent = null;
         if(this.m_Actions[param1] != param2)
         {
            this.m_Actions[param1] = param2;
            _loc3_ = new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE);
            _loc3_.kind = PropertyChangeEventKind.UPDATE;
            _loc3_.property = "action";
            _loc3_.newValue = param2;
            dispatchEvent(_loc3_);
         }
      }
      
      [Bindable(event="propertyChange")]
      public function set visible(param1:Boolean) : void
      {
         var _loc2_:Object = this.visible;
         if(_loc2_ !== param1)
         {
            this._466743410visible = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"visible",_loc2_,param1));
         }
      }
      
      public function marshall() : XML
      {
         var _loc3_:XML = null;
         var _loc1_:XML = <actionbar visible="{this.m_Visible}"></actionbar>;
         var _loc2_:int = 0;
         while(_loc2_ < this.m_Actions.length)
         {
            if(this.m_Actions[_loc2_] != null)
            {
               _loc3_ = this.m_Actions[_loc2_].marshall();
               _loc3_.@index = _loc2_;
               _loc1_.appendChild(_loc3_);
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function getLabel(param1:int) : String
      {
         return ActionBar.getLabel(this.m_Location,param1);
      }
   }
}
