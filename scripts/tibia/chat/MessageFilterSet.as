package tibia.chat
{
   import flash.events.EventDispatcher;
   import mx.events.PropertyChangeEvent;
   import mx.events.PropertyChangeEventKind;
   import shared.utility.XMLHelper;
   
   public class MessageFilterSet extends EventDispatcher
   {
      
      public static const DEFAULT_SET:int = 0;
      
      protected static const OPTIONS_MAX_COMPATIBLE_VERSION:Number = 5;
      
      public static const NUM_SETS:int = 1;
      
      protected static const OPTIONS_MIN_COMPATIBLE_VERSION:Number = 2;
       
      
      protected var m_MessageModes:Vector.<MessageMode> = null;
      
      protected var m_ShowTimestamps:Boolean = true;
      
      protected var m_ID:int = 0;
      
      protected var m_ShowLevels:Boolean = true;
      
      public function MessageFilterSet(param1:int)
      {
         super();
         this.m_ID = param1;
         this.m_MessageModes = new Vector.<MessageMode>(MessageMode.MESSAGE_BEYOND_LAST,true);
         var _loc2_:int = MessageMode.MESSAGE_NONE;
         while(_loc2_ < MessageMode.MESSAGE_BEYOND_LAST)
         {
            this.addMessageMode(new MessageMode(_loc2_));
            _loc2_++;
         }
         this.reset();
      }
      
      public static function s_Unmarshall(param1:XML, param2:Number) : MessageFilterSet
      {
         var _loc4_:int = 0;
         var _loc6_:XML = null;
         var _loc7_:XML = null;
         var _loc8_:MessageMode = null;
         if(param1 == null || param1.localName() != "messagefilterset" || param2 < OPTIONS_MIN_COMPATIBLE_VERSION || param2 > OPTIONS_MAX_COMPATIBLE_VERSION)
         {
            throw new Error("MessageFilterSet.s_Unmarshall: Invalid input.");
         }
         var _loc3_:XMLList = null;
         if((_loc3_ = param1.@id) == null || _loc3_.length() != 1)
         {
            return null;
         }
         _loc4_ = parseInt(_loc3_[0].toString());
         var _loc5_:MessageFilterSet = new MessageFilterSet(_loc4_);
         for each(_loc6_ in param1.elements())
         {
            switch(_loc6_.localName())
            {
               case "messagemodes":
                  for each(_loc7_ in _loc6_.elements("messagemode"))
                  {
                     _loc8_ = MessageMode.s_Unmarshall(_loc7_,param2);
                     if(_loc8_ != null && _loc8_.editable)
                     {
                        _loc5_.addMessageMode(_loc8_);
                     }
                  }
                  continue;
               case "showtimestamps":
                  _loc5_.showTimestamps = XMLHelper.s_UnmarshallBoolean(_loc6_);
                  continue;
               case "showlevels":
                  _loc5_.showLevels = XMLHelper.s_UnmarshallBoolean(_loc6_);
                  continue;
               default:
                  continue;
            }
         }
         return _loc5_;
      }
      
      public function get showTimestamps() : Boolean
      {
         return this.m_ShowTimestamps;
      }
      
      [Bindable(event="propertyChange")]
      public function set showTimestamps(param1:Boolean) : void
      {
         var _loc2_:Object = this.showTimestamps;
         if(_loc2_ !== param1)
         {
            this._991962886showTimestamps = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"showTimestamps",_loc2_,param1));
         }
      }
      
      public function get showLevels() : Boolean
      {
         return this.m_ShowLevels;
      }
      
      private function set _568961740showLevels(param1:Boolean) : void
      {
         this.m_ShowLevels = param1;
      }
      
      private function set _991962886showTimestamps(param1:Boolean) : void
      {
         this.m_ShowTimestamps = param1;
      }
      
      protected function onMessageModeChange(param1:PropertyChangeEvent) : void
      {
         var _loc2_:PropertyChangeEvent = null;
         if(param1 != null && (!param1.cancelable || !param1.isDefaultPrevented()))
         {
            _loc2_ = new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE);
            _loc2_.kind = PropertyChangeEventKind.UPDATE;
            _loc2_.property = "messageMode";
            dispatchEvent(_loc2_);
         }
      }
      
      public function marshall() : XML
      {
         var _loc1_:XML = <messagefilterset id="{this.m_ID}">
                         <showtimestamps>{this.m_ShowTimestamps}</showtimestamps>
                         <showlevels>{this.m_ShowLevels}</showlevels>
                       </messagefilterset>;
         var _loc2_:XML = <messagemodes/>;
         var _loc3_:int = MessageMode.MESSAGE_NONE;
         while(_loc3_ < MessageMode.MESSAGE_BEYOND_LAST)
         {
            if(this.m_MessageModes[_loc3_].editable)
            {
               _loc2_.appendChild(this.m_MessageModes[_loc3_].marshall());
            }
            _loc3_++;
         }
         _loc1_.appendChild(_loc2_);
         return _loc1_;
      }
      
      public function reset() : void
      {
         var _loc1_:int = MessageMode.MESSAGE_NONE;
         while(_loc1_ < MessageMode.MESSAGE_BEYOND_LAST)
         {
            this.m_MessageModes[_loc1_].initialiseDefaultValues();
            _loc1_++;
         }
         this.m_ShowLevels = true;
         this.m_ShowTimestamps = true;
      }
      
      public function addMessageMode(param1:MessageMode) : void
      {
         var _loc3_:PropertyChangeEvent = null;
         var _loc2_:int = param1.ID;
         if(this.m_MessageModes[_loc2_] != param1)
         {
            if(this.m_MessageModes[_loc2_] != null)
            {
               this.m_MessageModes[_loc2_].removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onMessageModeChange);
            }
            this.m_MessageModes[_loc2_] = param1;
            this.m_MessageModes[_loc2_].addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onMessageModeChange);
            _loc3_ = new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE);
            _loc3_.kind = PropertyChangeEventKind.UPDATE;
            _loc3_.property = "messageMode";
            _loc3_.newValue = param1;
            dispatchEvent(_loc3_);
         }
      }
      
      public function getMessageMode(param1:int) : MessageMode
      {
         if(!MessageMode.s_CheckMode(param1))
         {
            throw new ArgumentError("MessageModeSet.getMessageMode: Invalid mode: " + param1 + ".");
         }
         return this.m_MessageModes[param1];
      }
      
      public function get ID() : int
      {
         return this.m_ID;
      }
      
      [Bindable(event="propertyChange")]
      public function set showLevels(param1:Boolean) : void
      {
         var _loc2_:Object = this.showLevels;
         if(_loc2_ !== param1)
         {
            this._568961740showLevels = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"showLevels",_loc2_,param1));
         }
      }
   }
}
