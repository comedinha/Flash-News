package tibia.chat
{
   import flash.events.EventDispatcher;
   import mx.collections.ArrayCollection;
   import mx.collections.IList;
   import mx.core.EventPriority;
   import mx.events.CollectionEvent;
   import mx.events.PropertyChangeEvent;
   import mx.events.PropertyChangeEventKind;
   import shared.utility.RingBuffer;
   import tibia.chat.chatWidgetClasses.NicklistItem;
   
   public class Channel extends EventDispatcher
   {
      
      protected static const MESSAGES_SIZE:int = 50000;
      
      public static const MAX_NAME_LENGTH:int = 30;
       
      
      protected var m_CanModerate:Boolean = false;
      
      protected var m_SendMode:int = 0;
      
      protected var m_NicklistItems:ArrayCollection = null;
      
      protected var m_SendAllowed:Boolean = true;
      
      protected var m_Closable:Boolean = true;
      
      protected var m_ID = null;
      
      protected var m_Name:String = null;
      
      protected var m_Messages:IList = null;
      
      public function Channel(param1:Object, param2:String, param3:int)
      {
         super();
         this.m_ID = Channel.s_NormaliseIdentifier(param1);
         this.m_Name = param2;
         this.m_SendMode = param3;
         this.m_Messages = new RingBuffer(MESSAGES_SIZE);
         this.m_Messages.addEventListener(CollectionEvent.COLLECTION_CHANGE,this.onMessagesEvent,false,EventPriority.DEFAULT_HANDLER,false);
         this.m_Closable = true;
         this.m_SendAllowed = true;
         this.m_NicklistItems = new ArrayCollection();
      }
      
      public static function s_NormaliseIdentifier(param1:Object) : Object
      {
         var _loc2_:int = 0;
         var _loc3_:String = null;
         if(param1 is Channel)
         {
            return Channel(param1).ID;
         }
         if(param1 is int)
         {
            _loc2_ = int(param1);
            if(_loc2_ >= 0)
            {
               return _loc2_;
            }
         }
         else if(param1 is String)
         {
            _loc3_ = String(param1);
            if(_loc3_.length > 0)
            {
               return _loc3_.toLowerCase().substr(0,Channel.MAX_NAME_LENGTH);
            }
         }
         return null;
      }
      
      public function clearMessages() : void
      {
         this.m_Messages.removeAll();
      }
      
      public function get isPartyChannel() : Boolean
      {
         return ChatStorage.ns_chat_internal::s_IsPartyChannel(this.m_ID);
      }
      
      public function playerLeft(param1:String) : void
      {
         var _loc2_:NicklistItem = this.getNicklistItem(param1,false);
         if(_loc2_ != null)
         {
            _loc2_.state = NicklistItem.STATE_INVITED;
         }
      }
      
      public function playerJoined(param1:String) : void
      {
         var _loc2_:NicklistItem = this.getNicklistItem(param1,true);
         _loc2_.state = NicklistItem.STATE_SUBSCRIBER;
      }
      
      public function get name() : String
      {
         return this.m_Name;
      }
      
      public function get messages() : IList
      {
         return this.m_Messages;
      }
      
      public function get sendAllowed() : Boolean
      {
         return this.m_SendAllowed;
      }
      
      public function get sendMode() : int
      {
         return this.m_SendMode;
      }
      
      public function playerInvited(param1:String) : void
      {
         var _loc2_:NicklistItem = this.getNicklistItem(param1,true);
         _loc2_.state = NicklistItem.STATE_INVITED;
      }
      
      public function appendMessage(param1:ChannelMessage) : void
      {
         this.m_Messages.addItem(param1);
      }
      
      public function get canModerate() : Boolean
      {
         return this.m_CanModerate;
      }
      
      public function set name(param1:String) : void
      {
         this.m_Name = param1;
      }
      
      private function getNicklistItemIndex(param1:String) : int
      {
         var _loc2_:String = param1.toLowerCase();
         var _loc3_:String = null;
         var _loc4_:int = 0;
         var _loc5_:int = this.m_NicklistItems.length - 1;
         var _loc6_:int = 0;
         while(_loc4_ <= _loc5_)
         {
            _loc6_ = _loc4_ + _loc5_ >>> 1;
            _loc3_ = NicklistItem(this.m_NicklistItems.getItemAt(_loc6_)).name.toLowerCase();
            if(_loc3_ < _loc2_)
            {
               _loc4_ = _loc6_ + 1;
               continue;
            }
            if(_loc3_ > _loc2_)
            {
               _loc5_ = _loc6_ - 1;
               continue;
            }
            return _loc6_;
         }
         return -_loc4_ - 1;
      }
      
      public function set sendAllowed(param1:Boolean) : void
      {
         var _loc2_:PropertyChangeEvent = null;
         if(param1 != this.m_SendAllowed)
         {
            this.m_SendAllowed = param1;
            _loc2_ = new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE);
            _loc2_.kind = PropertyChangeEventKind.UPDATE;
            _loc2_.property = "sendAllowed";
            dispatchEvent(_loc2_);
         }
      }
      
      public function get ID() : Object
      {
         return this.m_ID;
      }
      
      public function set closable(param1:Boolean) : void
      {
         var _loc2_:PropertyChangeEvent = null;
         if(param1 != this.m_Closable)
         {
            this.m_Closable = param1;
            _loc2_ = new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE);
            _loc2_.kind = PropertyChangeEventKind.UPDATE;
            _loc2_.property = "closable";
            dispatchEvent(_loc2_);
         }
      }
      
      public function get showNicklist() : Boolean
      {
         var _loc1_:int = this.m_ID is int?int(int(this.m_ID)):-1;
         return this.isGuildChannel || this.isPartyChannel || this.isPrivate;
      }
      
      public function dispose() : void
      {
         if(this.m_Messages != null)
         {
            this.m_Messages.removeEventListener(CollectionEvent.COLLECTION_CHANGE,this.onMessagesEvent);
            this.m_Messages.removeAll();
         }
         if(this.m_NicklistItems != null)
         {
            this.m_NicklistItems.removeAll();
         }
      }
      
      public function get isRestorable() : Boolean
      {
         return (!ChatStorage.ns_chat_internal::s_IsPrivateChannel(this.m_ID) || this.m_SendAllowed) && ChatStorage.ns_chat_internal::s_IsRestorableChannel(this.m_ID);
      }
      
      public function playerExcluded(param1:String) : void
      {
         this.removeNicklistItem(param1);
      }
      
      public function set canModerate(param1:Boolean) : void
      {
         this.m_CanModerate = param1;
      }
      
      public function get closable() : Boolean
      {
         return this.m_Closable;
      }
      
      public function get safeID() : int
      {
         if(this.m_ID is int)
         {
            return int(this.m_ID);
         }
         return -1;
      }
      
      public function get isGuildChannel() : Boolean
      {
         return ChatStorage.ns_chat_internal::s_IsGuildChannel(this.m_ID);
      }
      
      private function getNicklistItem(param1:String, param2:Boolean = false) : NicklistItem
      {
         var _loc4_:NicklistItem = null;
         var _loc3_:int = this.getNicklistItemIndex(param1);
         if(_loc3_ < 0)
         {
            if(param2 == true)
            {
               _loc4_ = new NicklistItem(param1);
               this.m_NicklistItems.addItemAt(_loc4_,-_loc3_ - 1);
               return _loc4_;
            }
            return null;
         }
         return this.m_NicklistItems.getItemAt(_loc3_) as NicklistItem;
      }
      
      public function clearNicklist() : void
      {
         this.m_NicklistItems.removeAll();
      }
      
      private function removeNicklistItem(param1:String) : Boolean
      {
         var _loc2_:int = this.getNicklistItemIndex(param1);
         if(_loc2_ > -1)
         {
            this.m_NicklistItems.removeItemAt(_loc2_);
            return true;
         }
         return false;
      }
      
      protected function onMessagesEvent(param1:CollectionEvent) : void
      {
         if(param1 != null && (!param1.cancelable || !param1.isDefaultPrevented()))
         {
            dispatchEvent(param1);
         }
      }
      
      public function playerPending(param1:String) : void
      {
         var _loc2_:NicklistItem = this.getNicklistItem(param1,true);
         _loc2_.state = NicklistItem.STATE_PENDING;
      }
      
      private function isNicklistItemExisting(param1:String) : Boolean
      {
         return this.getNicklistItem(param1) != null;
      }
      
      public function get isPrivate() : Boolean
      {
         return ChatStorage.ns_chat_internal::s_IsPrivateChannel(this.m_ID);
      }
      
      public function get nicklistItems() : IList
      {
         return this.m_NicklistItems;
      }
   }
}
