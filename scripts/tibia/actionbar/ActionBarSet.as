package tibia.actionbar
{
   import flash.events.EventDispatcher;
   import mx.core.EventPriority;
   import mx.events.PropertyChangeEvent;
   
   public class ActionBarSet extends EventDispatcher
   {
      
      public static const DEFAULT_SET:int = 0;
      
      public static const NUM_LOCATIONS:int = 4;
      
      protected static const OPTIONS_MAX_COMPATIBLE_VERSION:Number = 5;
      
      public static const NUM_SETS:int = 12;
      
      public static const LOCATION_TOP:int = 0;
      
      public static const LOCATION_BOTTOM:int = 1;
      
      public static const LOCATION_LEFT:int = 2;
      
      public static const LOCATION_RIGHT:int = 3;
      
      protected static const OPTIONS_MIN_COMPATIBLE_VERSION:Number = 2;
       
      
      protected var m_ActionBars:Vector.<ActionBar> = null;
      
      protected var m_ID:int = 0;
      
      public function ActionBarSet(param1:int)
      {
         super();
         this.m_ActionBars = new Vector.<ActionBar>(LOCATION_RIGHT + 1,true);
         this.m_ID = param1;
      }
      
      public static function s_Unmarshall(param1:XML, param2:Number) : ActionBarSet
      {
         var _loc4_:int = 0;
         var _loc6_:XML = null;
         var _loc7_:ActionBar = null;
         if(param1 == null || param1.localName() != "actionbarset" || param2 < OPTIONS_MIN_COMPATIBLE_VERSION || param2 > OPTIONS_MAX_COMPATIBLE_VERSION)
         {
            throw new Error("ActionBarSet.s_Unmarshall: Invalid input.");
         }
         var _loc3_:XMLList = null;
         if((_loc3_ = param1.@id) == null || _loc3_.length() != 1)
         {
            return null;
         }
         _loc4_ = parseInt(_loc3_[0].toString());
         var _loc5_:ActionBarSet = new ActionBarSet(_loc4_);
         for each(_loc6_ in param1.elements("actionbar"))
         {
            _loc7_ = ActionBar.s_Unmarshall(_loc6_,param2);
            if(_loc7_ != null)
            {
               _loc5_.setActionBar(_loc7_);
            }
         }
         return _loc5_;
      }
      
      public function initialiseDefaultActionBars() : void
      {
         var _loc1_:ActionBar = new ActionBar(LOCATION_BOTTOM);
         _loc1_.visible = true;
         this.setActionBar(_loc1_);
         var _loc2_:ActionBar = new ActionBar(LOCATION_LEFT);
         this.setActionBar(_loc2_);
         var _loc3_:ActionBar = new ActionBar(LOCATION_RIGHT);
         this.setActionBar(_loc3_);
         var _loc4_:ActionBar = new ActionBar(LOCATION_TOP);
         this.setActionBar(_loc4_);
      }
      
      public function get ID() : int
      {
         return this.m_ID;
      }
      
      public function getActionBar(param1:int) : ActionBar
      {
         return this.m_ActionBars[param1];
      }
      
      function changeID(param1:int) : void
      {
         this.m_ID = param1;
      }
      
      protected function onActionBarChange(param1:PropertyChangeEvent) : void
      {
         if(param1 != null && (!param1.cancelable || !param1.isDefaultPrevented()))
         {
            dispatchEvent(param1);
         }
      }
      
      public function marshall() : XML
      {
         var _loc3_:XML = null;
         var _loc1_:XML = <actionbarset id="{this.m_ID}"></actionbarset>;
         var _loc2_:int = 0;
         while(_loc2_ < this.m_ActionBars.length)
         {
            if(this.m_ActionBars[_loc2_] != null)
            {
               _loc3_ = this.m_ActionBars[_loc2_].marshall();
               _loc3_.@location = _loc2_;
               _loc1_.appendChild(_loc3_);
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function setActionBar(param1:ActionBar) : void
      {
         if(param1 == null)
         {
            throw new ArgumentError("ActionBarSet.setActionBar: Invalid action bar.");
         }
         var _loc2_:int = param1.location;
         if(this.m_ActionBars[_loc2_] != param1)
         {
            if(this.m_ActionBars[_loc2_] != null)
            {
               this.m_ActionBars[_loc2_].removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onActionBarChange);
            }
            this.m_ActionBars[_loc2_] = param1;
            this.m_ActionBars[_loc2_].addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onActionBarChange,false,EventPriority.DEFAULT_HANDLER,false);
         }
      }
      
      public function clone() : ActionBarSet
      {
         var _loc1_:XML = this.marshall();
         return s_Unmarshall(_loc1_,OPTIONS_MAX_COMPATIBLE_VERSION);
      }
   }
}
