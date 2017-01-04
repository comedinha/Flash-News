package tibia.chat
{
   import mx.collections.ArrayCollection;
   import mx.collections.IList;
   import shared.utility.XMLHelper;
   import tibia.creatures.BuddySet;
   import tibia.options.OptionsStorage;
   import tibia.options.ns_options_internal;
   
   public class NameFilterSet
   {
      
      public static const DEFAULT_SET:int = 0;
      
      protected static const OPTIONS_MAX_COMPATIBLE_VERSION:Number = 5;
      
      public static const NUM_SETS:int = 1;
      
      protected static const OPTIONS_MIN_COMPATIBLE_VERSION:Number = 2;
       
      
      protected var m_BlackItems:IList = null;
      
      protected var m_BlackYelling:Boolean = false;
      
      protected var m_WhiteEnabled:Boolean = true;
      
      protected var m_WhiteItems:IList = null;
      
      protected var m_ID:int = 0;
      
      protected var m_BlackEnabled:Boolean = true;
      
      protected var m_BlackPrivate:Boolean = false;
      
      protected var m_WhiteBuddies:Boolean = false;
      
      public function NameFilterSet(param1:int)
      {
         super();
         this.m_ID = param1;
         this.m_BlackItems = new ArrayCollection();
         this.m_WhiteItems = new ArrayCollection();
      }
      
      public static function s_Unmarshall(param1:XML, param2:Number) : NameFilterSet
      {
         var _loc4_:int = 0;
         var _loc6_:XML = null;
         var _loc7_:XML = null;
         var _loc8_:XML = null;
         if(param1 == null || param1.localName() != "namefilterset" || param2 < OPTIONS_MIN_COMPATIBLE_VERSION || param2 > OPTIONS_MAX_COMPATIBLE_VERSION)
         {
            throw new Error("NameFilterSet.s_Unmarshall: Invalid input.");
         }
         var _loc3_:XMLList = null;
         if((_loc3_ = param1.@id) == null || _loc3_.length() != 1)
         {
            return null;
         }
         _loc4_ = parseInt(_loc3_[0].toString());
         var _loc5_:NameFilterSet = new NameFilterSet(_loc4_);
         for each(_loc6_ in param1.elements())
         {
            switch(_loc6_.localName())
            {
               case "blacklistEnabled":
                  _loc5_.blacklistEnabled = XMLHelper.s_UnmarshallBoolean(_loc6_);
                  continue;
               case "blacklistPrivate":
                  _loc5_.blacklistPrivate = XMLHelper.s_UnmarshallBoolean(_loc6_);
                  continue;
               case "blacklistYelling":
                  _loc5_.blacklistYelling = XMLHelper.s_UnmarshallBoolean(_loc6_);
                  continue;
               case "blacklistItems":
                  for each(_loc7_ in _loc6_.elements("name"))
                  {
                     _loc5_.ns_options_internal::blacklistItems.addItem(new NameFilterItem(XMLHelper.s_UnmarshallString(_loc7_),true));
                  }
                  continue;
               case "whitelistEnabled":
                  _loc5_.whitelistEnabled = XMLHelper.s_UnmarshallBoolean(_loc6_);
                  continue;
               case "whitelistBuddies":
                  _loc5_.whitelistBuddies = XMLHelper.s_UnmarshallBoolean(_loc6_);
                  continue;
               case "whitelistItems":
                  for each(_loc8_ in _loc6_.elements("name"))
                  {
                     _loc5_.ns_options_internal::whitelistItems.addItem(new NameFilterItem(XMLHelper.s_UnmarshallString(_loc8_),true));
                  }
                  continue;
               default:
                  continue;
            }
         }
         return _loc5_;
      }
      
      public function removeBlacklist(param1:String) : void
      {
         var _loc2_:int = -1;
         while((_loc2_ = this.indexOf(param1,this.m_BlackItems)) > -1)
         {
            this.m_BlackItems.removeItemAt(_loc2_);
         }
      }
      
      public function set whitelistBuddies(param1:Boolean) : void
      {
         this.m_WhiteBuddies = param1;
      }
      
      public function addBlacklist(param1:String, param2:Boolean = false) : void
      {
         if(this.indexOf(param1,this.m_BlackItems) < 0)
         {
            this.m_BlackItems.addItem(new NameFilterItem(param1,param2));
         }
      }
      
      public function set blacklistEnabled(param1:Boolean) : void
      {
         this.m_BlackEnabled = param1;
      }
      
      public function set blacklistPrivate(param1:Boolean) : void
      {
         this.m_BlackPrivate = param1;
      }
      
      public function marshall() : XML
      {
         var _loc1_:XML = <namefilterset id="{this.m_ID}">
                         <blacklistEnabled>{this.m_BlackEnabled}</blacklistEnabled>
                         <blacklistPrivate>{this.m_BlackPrivate}</blacklistPrivate>
                         <blacklistYelling>{this.m_BlackYelling}</blacklistYelling>
                         <whitelistEnabled>{this.m_WhiteEnabled}</whitelistEnabled>
                         <whitelistBuddies>{this.m_WhiteBuddies}</whitelistBuddies>
                       </namefilterset>;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:NameFilterItem = null;
         var _loc5_:XML = null;
         _loc5_ = <blacklistItems/>;
         _loc2_ = 0;
         _loc3_ = this.m_BlackItems.length;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = NameFilterItem(this.m_BlackItems.getItemAt(_loc2_));
            if(_loc4_.permanent)
            {
               _loc5_.appendChild(<name>{_loc4_.pattern}</name>);
            }
            _loc2_++;
         }
         _loc1_.appendChild(_loc5_);
         _loc5_ = <whitelistItems/>;
         _loc2_ = 0;
         _loc3_ = this.m_WhiteItems.length;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = NameFilterItem(this.m_WhiteItems.getItemAt(_loc2_));
            if(_loc4_.permanent)
            {
               _loc5_.appendChild(<name>{_loc4_.pattern}</name>);
            }
            _loc2_++;
         }
         _loc1_.appendChild(_loc5_);
         return _loc1_;
      }
      
      function get whitelistItems() : IList
      {
         return this.m_WhiteItems;
      }
      
      private function indexOf(param1:String, param2:IList) : int
      {
         var _loc3_:int = 0;
         var _loc4_:NameFilterItem = null;
         if(param1 != null && param2 != null)
         {
            param1 = param1.toLowerCase();
            _loc3_ = param2.length - 1;
            while(_loc3_ >= 0)
            {
               _loc4_ = NameFilterItem(param2.getItemAt(_loc3_));
               if(_loc4_ != null && _loc4_.pattern != null && _loc4_.pattern.toLowerCase() == param1)
               {
                  return _loc3_;
               }
               _loc3_--;
            }
         }
         return -1;
      }
      
      public function get ID() : int
      {
         return this.m_ID;
      }
      
      public function isWhitelisted(param1:String) : Boolean
      {
         return this.indexOf(param1,this.m_WhiteItems) > -1;
      }
      
      public function get whitelistBuddies() : Boolean
      {
         return this.m_WhiteBuddies;
      }
      
      public function acceptMessage(param1:int, param2:String, param3:String) : Boolean
      {
         var _loc4_:OptionsStorage = null;
         var _loc5_:BuddySet = null;
         if(this.m_WhiteEnabled)
         {
            _loc4_ = Tibia.s_GetOptions();
            _loc5_ = null;
            if(this.m_WhiteBuddies && _loc4_ != null && (_loc5_ = _loc4_.getBuddySet(BuddySet.DEFAULT_SET)) != null && _loc5_.getBuddy(param2) != null)
            {
               return true;
            }
            if(this.indexOf(param2,this.m_WhiteItems) > -1)
            {
               return true;
            }
         }
         if(this.m_BlackEnabled)
         {
            if(this.m_BlackPrivate && param1 == MessageMode.MESSAGE_PRIVATE_FROM)
            {
               return false;
            }
            if(this.m_BlackYelling && param1 == MessageMode.MESSAGE_YELL)
            {
               return false;
            }
            if(this.indexOf(param2,this.m_BlackItems) > -1)
            {
               return false;
            }
         }
         return true;
      }
      
      function get blacklistItems() : IList
      {
         return this.m_BlackItems;
      }
      
      public function get blacklistEnabled() : Boolean
      {
         return this.m_BlackEnabled;
      }
      
      public function isBlacklisted(param1:String) : Boolean
      {
         return this.indexOf(param1,this.m_BlackItems) > -1;
      }
      
      public function set blacklistYelling(param1:Boolean) : void
      {
         this.m_BlackYelling = param1;
      }
      
      public function get blacklistPrivate() : Boolean
      {
         return this.m_BlackPrivate;
      }
      
      public function get blacklistYelling() : Boolean
      {
         return this.m_BlackYelling;
      }
      
      public function get whitelistEnabled() : Boolean
      {
         return this.m_WhiteEnabled;
      }
      
      public function set whitelistEnabled(param1:Boolean) : void
      {
         this.m_WhiteEnabled = param1;
      }
      
      public function clone() : NameFilterSet
      {
         var _loc1_:NameFilterSet = new NameFilterSet(this.ID);
         _loc1_.blacklistEnabled = this.blacklistEnabled;
         _loc1_.blacklistPrivate = this.blacklistPrivate;
         _loc1_.blacklistYelling = this.blacklistYelling;
         _loc1_.whitelistBuddies = this.whitelistBuddies;
         _loc1_.whitelistEnabled = this.whitelistEnabled;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         _loc2_ = 0;
         _loc3_ = this.m_BlackItems.length;
         while(_loc2_ < _loc3_)
         {
            _loc1_.m_BlackItems.addItem(this.m_BlackItems.getItemAt(_loc2_).clone());
            _loc2_++;
         }
         _loc2_ = 0;
         _loc3_ = this.m_WhiteItems.length;
         while(_loc2_ < _loc3_)
         {
            _loc1_.m_WhiteItems.addItem(this.m_WhiteItems.getItemAt(_loc2_).clone());
            _loc2_++;
         }
         return _loc1_;
      }
   }
}
