package tibia.chat
{
   import flash.events.EventDispatcher;
   import shared.utility.XMLHelper;
   import mx.events.PropertyChangeEvent;
   import mx.events.PropertyChangeEventKind;
   
   public class ChannelSet extends EventDispatcher
   {
      
      public static const DEFAULT_SET:int = 0;
      
      protected static const OPTIONS_MAX_COMPATIBLE_VERSION:Number = 5;
      
      public static const NUM_SETS:int = 1;
      
      protected static const OPTIONS_MIN_COMPATIBLE_VERSION:Number = 2;
       
      
      protected var m_Channels:Vector.<uint> = null;
      
      protected var m_ID:int = 0;
      
      public function ChannelSet(param1:int)
      {
         super();
         this.m_ID = param1;
         this.m_Channels = new Vector.<uint>();
      }
      
      public static function s_Unmarshall(param1:XML, param2:Number) : ChannelSet
      {
         var _loc4_:int = 0;
         var _loc6_:XML = null;
         if(param1 == null || param1.localName() != "channelset" || param2 < OPTIONS_MIN_COMPATIBLE_VERSION || param2 > OPTIONS_MAX_COMPATIBLE_VERSION)
         {
            throw new Error("ChannelSet.s_Unmarshall: Invalid input.");
         }
         var _loc3_:XMLList = null;
         if((_loc3_ = param1.@id) == null || _loc3_.length() != 1)
         {
            return null;
         }
         _loc4_ = parseInt(_loc3_[0].toString());
         var _loc5_:ChannelSet = new ChannelSet(_loc4_);
         for each(_loc6_ in param1.elements("channel"))
         {
            _loc5_.addItem(XMLHelper.s_UnmarshallInteger(_loc6_));
         }
         return _loc5_;
      }
      
      public function get length() : int
      {
         return this.m_Channels.length;
      }
      
      public function addItemAt(param1:int, param2:int) : void
      {
         var _loc4_:Boolean = false;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:PropertyChangeEvent = null;
         var _loc3_:int = this.m_Channels.indexOf(param1);
         if(param2 < 0 || _loc3_ < 0 && param2 > this.m_Channels.length || _loc3_ > -1 && param2 >= this.m_Channels.length)
         {
            throw new RangeError("ChannelSet.addItemAt: Index " + param2 + " is out of range.");
         }
         if(ChatStorage.ns_chat_internal::s_IsRestorableChannel(param1))
         {
            _loc4_ = false;
            if(_loc3_ < 0)
            {
               this.m_Channels.splice(param2,0,param1);
               _loc4_ = true;
            }
            else if(_loc3_ != param2)
            {
               _loc5_ = _loc3_;
               _loc6_ = _loc3_ < param2?1:-1;
               while(_loc5_ != param2)
               {
                  this.m_Channels[_loc5_] = this.m_Channels[_loc5_ + _loc6_];
                  _loc5_ = _loc5_ + _loc6_;
               }
               this.m_Channels[param2] = param1;
               _loc4_ = true;
            }
            if(_loc4_)
            {
               _loc7_ = new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE);
               _loc7_.kind = PropertyChangeEventKind.UPDATE;
               _loc7_.property = "channels";
               dispatchEvent(_loc7_);
            }
         }
      }
      
      public function setItemAt(param1:uint, param2:int) : int
      {
         var _loc4_:PropertyChangeEvent = null;
         if(param2 < 0 || param2 >= this.m_Channels.length)
         {
            throw new RangeError("ChannelSet.setItemAt: Index " + param2 + " is out of range.");
         }
         var _loc3_:uint = this.m_Channels[param2];
         if(ChatStorage.ns_chat_internal::s_IsRestorableChannel(param1))
         {
            this.m_Channels[param2] = param1;
            _loc4_ = new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE);
            _loc4_.kind = PropertyChangeEventKind.UPDATE;
            _loc4_.property = "channels";
            dispatchEvent(_loc4_);
         }
         return _loc3_;
      }
      
      public function getItemIndex(param1:int) : int
      {
         return this.m_Channels.indexOf(param1);
      }
      
      public function removeItemAt(param1:int) : int
      {
         if(param1 < 0 || param1 >= this.m_Channels.length)
         {
            throw new RangeError("ChannelSet.removeItemAt: Index " + param1 + " is out of range.");
         }
         var _loc2_:int = int(this.m_Channels.splice(param1,1));
         var _loc3_:PropertyChangeEvent = new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE);
         _loc3_.kind = PropertyChangeEventKind.UPDATE;
         _loc3_.property = "channels";
         dispatchEvent(_loc3_);
         return _loc2_;
      }
      
      public function set length(param1:int) : void
      {
         var _loc2_:PropertyChangeEvent = null;
         if(param1 < 0 || param1 > this.m_Channels.length)
         {
            throw new RangeError("ChannelSet.set length: Length " + param1 + " is invalid.");
         }
         if(this.m_Channels.length != param1)
         {
            this.m_Channels.length = param1;
            _loc2_ = new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE);
            _loc2_.kind = PropertyChangeEventKind.UPDATE;
            _loc2_.property = "channels";
            dispatchEvent(_loc2_);
         }
      }
      
      public function marshall() : XML
      {
         var _loc1_:XML = <channelset id="{this.m_ID}"></channelset>;
         var _loc2_:int = 0;
         while(_loc2_ < this.m_Channels.length)
         {
            _loc1_.appendChild(<channel>{this.m_Channels[_loc2_]}</channel>);
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function addItem(param1:int) : void
      {
         var _loc2_:PropertyChangeEvent = null;
         if(ChatStorage.ns_chat_internal::s_IsRestorableChannel(param1) && this.m_Channels.indexOf(param1) < 0)
         {
            this.m_Channels.push(param1);
            _loc2_ = new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE);
            _loc2_.kind = PropertyChangeEventKind.UPDATE;
            _loc2_.property = "channels";
            dispatchEvent(_loc2_);
         }
      }
      
      public function get ID() : int
      {
         return this.m_ID;
      }
      
      public function getItemAt(param1:int) : int
      {
         if(param1 < 0 || param1 >= this.m_Channels.length)
         {
            throw new RangeError("ChannelSet.getItemAt: Index " + param1 + " is out of range.");
         }
         return this.m_Channels[param1];
      }
      
      public function removeAll() : void
      {
         this.m_Channels.length = 0;
         var _loc1_:PropertyChangeEvent = new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE);
         _loc1_.kind = PropertyChangeEventKind.UPDATE;
         _loc1_.property = "channels";
         dispatchEvent(_loc1_);
      }
   }
}
