package tibia.creatures
{
   import flash.events.EventDispatcher;
   import mx.collections.ArrayList;
   import mx.collections.IList;
   import mx.resources.ResourceManager;
   import tibia.chat.ChatStorage;
   import tibia.chat.MessageMode;
   import tibia.creatures.buddylistClasses.Buddy;
   import tibia.creatures.buddylistClasses.BuddyIcon;
   import tibia.network.Communication;
   import tibia.worldmap.WorldMapStorage;
   
   public class BuddySet extends EventDispatcher
   {
      
      private static const BUDDIES_REFRESH:int = 1;
      
      public static const DEFAULT_SET:int = 0;
      
      protected static const OPTIONS_MAX_COMPATIBLE_VERSION:Number = 5;
      
      public static const NUM_SETS:int = 1;
      
      private static const BUDDIES_REBUILD:int = 2;
      
      private static const BUNDLE:String = "BuddylistWidget";
      
      private static const BUDDIES_NOACTION:int = 0;
      
      protected static const OPTIONS_MIN_COMPATIBLE_VERSION:Number = 2;
       
      
      private var m_Icons:Vector.<BuddyIcon> = null;
      
      private var m_ID:int = 0;
      
      private var m_Buddies:IList = null;
      
      public function BuddySet(param1:int)
      {
         super();
         this.m_ID = param1;
         this.m_Buddies = new ArrayList();
         this.m_Icons = new Vector.<BuddyIcon>();
         var _loc2_:int = 0;
         while(_loc2_ < BuddyIcon.NUM_ICONS)
         {
            this.m_Icons.push(new BuddyIcon(_loc2_));
            _loc2_++;
         }
      }
      
      public function removeBuddy(param1:int, param2:Boolean = true) : void
      {
         var _loc4_:Communication = null;
         var _loc3_:int = this.getBuddyIndex(param1);
         if(_loc3_ > -1)
         {
            this.m_Buddies.removeItemAt(_loc3_);
            _loc4_ = null;
            if(param2 && (_loc4_ = Tibia.s_GetCommunication()) != null && _loc4_.isGameRunning)
            {
               _loc4_.sendCREMOVEBUDDY(param1);
            }
         }
      }
      
      public function addBuddy(param1:String, param2:Boolean = true) : void
      {
         var _loc3_:Communication = null;
         if(param2 && (_loc3_ = Tibia.s_GetCommunication()) != null && _loc3_.isGameRunning)
         {
            _loc3_.sendCADDBUDDY(param1);
         }
      }
      
      public function get length() : int
      {
         return this.m_Buddies.length;
      }
      
      private function getBuddyIndex(param1:int) : int
      {
         var _loc5_:Buddy = null;
         var _loc2_:int = 0;
         var _loc3_:int = this.m_Buddies.length - 1;
         var _loc4_:int = 0;
         while(_loc2_ <= _loc3_)
         {
            _loc4_ = _loc2_ + _loc3_ >>> 1;
            _loc5_ = Buddy(this.m_Buddies.getItemAt(_loc4_));
            if(_loc5_.ID < param1)
            {
               _loc2_ = _loc4_ + 1;
               continue;
            }
            if(_loc5_.ID > param1)
            {
               _loc3_ = _loc4_ - 1;
               continue;
            }
            return _loc4_;
         }
         return -_loc2_ - 1;
      }
      
      public function get buddies() : IList
      {
         return this.m_Buddies;
      }
      
      public function markBuddiesOffline() : void
      {
         var _loc2_:Buddy = null;
         var _loc1_:int = this.m_Buddies.length - 1;
         while(_loc1_ >= 0)
         {
            _loc2_ = Buddy(this.m_Buddies.getItemAt(_loc1_));
            _loc2_.name = null;
            _loc2_.status = Buddy.STATUS_OFFLINE;
            _loc2_.lastUpdate = Number.NEGATIVE_INFINITY;
            _loc1_--;
         }
      }
      
      public function updateBuddy(param1:int, ... rest) : void
      {
         var _loc5_:String = null;
         var _loc6_:WorldMapStorage = null;
         var _loc7_:ChatStorage = null;
         var _loc3_:Buddy = null;
         var _loc4_:int = this.getBuddyIndex(param1);
         if(rest.length == 1)
         {
            if(_loc4_ > -1)
            {
               _loc3_ = Buddy(this.m_Buddies.getItemAt(_loc4_));
               _loc3_.status = uint(rest[0]);
               _loc3_.lastUpdate = Tibia.s_FrameTibiaTimestamp;
               if(_loc3_.status == Buddy.STATUS_ONLINE && _loc3_.notify)
               {
                  _loc5_ = ResourceManager.getInstance().getString(BUNDLE,"NOTIFICATION_MESSAGE",[_loc3_.name]);
                  _loc6_ = Tibia.s_GetWorldMapStorage();
                  if(_loc6_ != null)
                  {
                     _loc6_.addOnscreenMessage(MessageMode.MESSAGE_STATUS,_loc5_);
                  }
                  _loc7_ = Tibia.s_GetChatStorage();
                  if(_loc7_ != null)
                  {
                     _loc7_.addChannelMessage(-1,-1,null,0,MessageMode.MESSAGE_STATUS,_loc5_);
                  }
               }
            }
         }
         else if(rest.length == 5)
         {
            if(_loc4_ > -1)
            {
               _loc3_ = Buddy(this.m_Buddies.getItemAt(_loc4_));
            }
            else
            {
               _loc3_ = new Buddy(param1,null);
               if(this.m_Buddies.length < Buddy.NUM_BUDDIES)
               {
                  this.m_Buddies.addItemAt(_loc3_,-_loc4_ - 1);
               }
            }
            _loc3_.name = String(rest[0]);
            _loc3_.description = String(rest[1]);
            _loc3_.icon = int(rest[2]);
            _loc3_.notify = Boolean(rest[3]);
            _loc3_.status = uint(rest[4]);
            _loc3_.lastUpdate = Number.NEGATIVE_INFINITY;
         }
         else
         {
            throw new ArgumentError("BuddySet.updateBuddy: Invalid overload.");
         }
      }
      
      public function getBuddy(param1:*) : Buddy
      {
         var _loc2_:int = 0;
         var _loc3_:String = null;
         var _loc4_:int = 0;
         var _loc5_:Buddy = null;
         var _loc6_:String = null;
         if(param1 is int)
         {
            _loc2_ = this.getBuddyIndex(int(param1));
            if(_loc2_ > -1)
            {
               return Buddy(this.m_Buddies.getItemAt(_loc2_));
            }
         }
         else if(param1 is String)
         {
            _loc3_ = String(param1).toLowerCase();
            _loc4_ = this.m_Buddies.length - 1;
            while(_loc4_ >= 0)
            {
               _loc5_ = Buddy(this.m_Buddies.getItemAt(_loc4_));
               _loc6_ = _loc5_.name;
               if(_loc6_ != null)
               {
                  _loc6_ = _loc6_.toLowerCase();
               }
               if(_loc6_ == _loc3_)
               {
                  return _loc5_;
               }
               _loc4_--;
            }
         }
         return null;
      }
      
      public function get icons() : Vector.<BuddyIcon>
      {
         return this.m_Icons;
      }
      
      public function get ID() : int
      {
         return this.m_ID;
      }
      
      public function clone() : BuddySet
      {
         var _loc4_:Buddy = null;
         var _loc1_:BuddySet = new BuddySet(this.m_ID);
         var _loc2_:int = 0;
         var _loc3_:int = Math.min(this.m_Buddies.length,Buddy.NUM_BUDDIES);
         while(_loc2_ < _loc3_)
         {
            _loc4_ = Buddy(this.m_Buddies.getItemAt(_loc2_));
            _loc1_.m_Buddies.addItem(_loc4_.clone());
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function clearBuddies() : void
      {
         this.m_Buddies.removeAll();
      }
   }
}
