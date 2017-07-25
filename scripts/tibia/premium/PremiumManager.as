package tibia.premium
{
   import flash.events.EventDispatcher;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import mx.events.PropertyChangeEvent;
   import mx.events.PropertyChangeEventKind;
   import tibia.creatures.Player;
   import tibia.options.OptionsStorage;
   import tibia.sidebar.SideBarSet;
   import tibia.sidebar.Widget;
   
   public class PremiumManager extends EventDispatcher
   {
      
      protected static const PREMIUM_TRIGGER_DAILY_REWARD:uint = 18;
      
      protected static const PREMIUM_TRIGGER_PREY:uint = 16;
      
      protected static const PREMIUM_TRIGGER_CYCLOPEDIA:uint = 19;
      
      protected static const PREMIUM_TRIGGER_DEATH_PENALTY:uint = 7;
      
      public static const HIGHLIGHT_TIMEOUT:int = 1000 * 60 * 10;
      
      protected static const PREMIUM_TRIGGER_ACCESS_ARENAS:uint = 15;
      
      protected static const PREMIUM_TRIGGER_CLASS_PROMOTION:uint = 13;
      
      public static const PREMIUM_BUTTON_GENERAL_CONTROLS:int = 0;
      
      protected static const PREMIUM_TRIGGER_ALL_AREAS:uint = 0;
      
      protected static const PREMIUM_TRIGGER_IMBUING:uint = 17;
      
      protected static const PREMIUM_TRIGGER_ALL_OUTFITS:uint = 5;
      
      protected static const PREMIUM_EXPIRY_THRESHOLD:uint = 3;
      
      protected static const PREMIUM_TRIGGER_XP_BOOST:uint = 6;
      
      protected static const PREMIUM_TRIGGER_DEPOT_SPACE:uint = 11;
      
      protected static const PREMIUM_TRIGGER_INVITE_PRIVCHAT:uint = 12;
      
      protected static const PREMIUM_URL:String = "/account/index.php?subtopic=redirectlogin&clienttarget=payment&clientselection=FC";
      
      protected static const PREMIUM_TRIGGER_ALL_SPELLS:uint = 2;
      
      protected static const PREMIUM_TRIGGER_MARKET:uint = 8;
      
      public static const PREMIUM_BUTTON_SHOP:int = 2;
      
      protected static const PREMIUM_TRIGGER_TRAVEL_FASTER:uint = 3;
      
      public static const PREMIUM_BUTTON_WIDGET:int = 1;
      
      protected static const PREMIUM_TRIGGER_RENT_HOUSES:uint = 9;
      
      protected static const PREMIUM_TRIGGER_VIP_LIST:uint = 10;
      
      protected static const PREMIUM_TRIGGER_RIDE_MOUNTS:uint = 4;
      
      protected static const PREMIUM_TRIGGER_RENEW_PREMIUM:uint = 14;
      
      protected static const PREMIUM_TRIGGER_TRAIN_OFFLINE:uint = 1;
       
      
      protected var m_PremiumMessages:Vector.<PremiumMessage> = null;
      
      protected var m_Player:Player = null;
      
      public function PremiumManager(param1:Player)
      {
         super();
         if(param1 == null)
         {
            throw new ArgumentError("PremiumManager: Player instance is null");
         }
         this.m_PremiumMessages = new Vector.<PremiumMessage>();
         this.m_Player = param1;
         this.m_Player.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onPlayerPropertyChange);
      }
      
      public function get premiumExpiryDays() : int
      {
         var _loc1_:Number = Math.max(0,this.m_Player.premiumUntil - new Date().time / 1000);
         return _loc1_ / (60 * 60 * 24) + 1;
      }
      
      public function get premiumMessages() : Vector.<PremiumMessage>
      {
         return this.m_PremiumMessages;
      }
      
      public function isWidgetVisible() : Boolean
      {
         var _loc3_:SideBarSet = null;
         var _loc1_:Widget = null;
         var _loc2_:OptionsStorage = Tibia.s_GetOptions();
         if(_loc2_ != null)
         {
            _loc3_ = _loc2_.getSideBarSet(SideBarSet.DEFAULT_SET);
            if(_loc3_ != null)
            {
               _loc1_ = _loc3_.getWidgetByType(Widget.TYPE_PREMIUM);
            }
         }
         return _loc1_ != null && !_loc1_.closed;
      }
      
      protected function onPlayerPropertyChange(param1:PropertyChangeEvent) : void
      {
         if(param1 != null && param1.kind == PropertyChangeEventKind.UPDATE && param1.property == "premium")
         {
            this.showOrHideWidgetBasedOnPremiumStatus();
         }
      }
      
      public function get freePlayerLimitations() : Boolean
      {
         return !(this.m_Player.premium || this.m_Player.premiumUntil > 0);
      }
      
      public function showOrHideWidget(param1:Boolean) : void
      {
         var _loc4_:SideBarSet = null;
         var _loc5_:int = 0;
         var _loc2_:Widget = null;
         var _loc3_:OptionsStorage = Tibia.s_GetOptions();
         if(_loc3_ != null)
         {
            _loc4_ = _loc3_.getSideBarSet(SideBarSet.DEFAULT_SET);
            if(_loc4_ != null)
            {
               _loc2_ = _loc4_.getWidgetByType(Widget.TYPE_PREMIUM);
               if(_loc2_ == null && param1)
               {
                  _loc5_ = this.findVisibleSidebarLocation(_loc4_);
                  _loc2_ = _loc4_.showWidgetType(Widget.TYPE_PREMIUM,_loc5_,0);
                  _loc2_.collapsed = true;
               }
               else if(_loc2_ != null && param1 == false)
               {
                  _loc2_.close();
                  _loc2_ = null;
               }
            }
         }
      }
      
      private function translateMessageId(param1:uint) : PremiumMessage
      {
         switch(param1)
         {
            case PREMIUM_TRIGGER_ALL_AREAS:
               return PremiumMessage.ALL_AREAS;
            case PREMIUM_TRIGGER_TRAIN_OFFLINE:
               return PremiumMessage.TRAIN_OFFLINE;
            case PREMIUM_TRIGGER_ALL_SPELLS:
               return PremiumMessage.ALL_SPELLS;
            case PREMIUM_TRIGGER_TRAVEL_FASTER:
               return PremiumMessage.TRAVEL_FASTER;
            case PREMIUM_TRIGGER_RIDE_MOUNTS:
               return PremiumMessage.RIDE_MOUNTS;
            case PREMIUM_TRIGGER_ALL_OUTFITS:
               return PremiumMessage.ALL_OUTFITS;
            case PREMIUM_TRIGGER_XP_BOOST:
               return PremiumMessage.XP_BOOST;
            case PREMIUM_TRIGGER_DEATH_PENALTY:
               return PremiumMessage.DEATH_PENALTY;
            case PREMIUM_TRIGGER_MARKET:
               return PremiumMessage.MARKET;
            case PREMIUM_TRIGGER_RENT_HOUSES:
               return PremiumMessage.RENT_HOUSES;
            case PREMIUM_TRIGGER_VIP_LIST:
               return PremiumMessage.VIP_LIST;
            case PREMIUM_TRIGGER_DEPOT_SPACE:
               return PremiumMessage.DEPOT_SPACE;
            case PREMIUM_TRIGGER_INVITE_PRIVCHAT:
               return PremiumMessage.INVITE_PRIVCHAT;
            case PREMIUM_TRIGGER_CLASS_PROMOTION:
               return PremiumMessage.CLASS_PROMOTION;
            case PREMIUM_TRIGGER_RENEW_PREMIUM:
               return PremiumMessage.RENEW_PREMIUM;
            case PREMIUM_TRIGGER_ACCESS_ARENAS:
               return PremiumMessage.ACCESS_ARENAS;
            default:
               throw new ArgumentError("Invalid premium trigger ID: " + param1);
         }
      }
      
      public function goToPaymentWebsite(param1:int) : void
      {
         var _loc2_:URLRequest = new URLRequest(PREMIUM_URL + param1);
         navigateToURL(_loc2_,"_blank");
      }
      
      public function updatePremiumMessages(param1:Vector.<uint>) : void
      {
         var a_MessageIds:Vector.<uint> = param1;
         this.m_PremiumMessages.length = 0;
         a_MessageIds.forEach(function(param1:uint, param2:int, param3:Vector.<uint>):void
         {
            var a_MessageID:uint = param1;
            var a_Index:int = param2;
            var a_Vector:Vector.<uint> = param3;
            try
            {
               m_PremiumMessages.push(translateMessageId(a_MessageID));
               return;
            }
            catch(_Error:ArgumentError)
            {
               return;
            }
         });
         var Event:PremiumEvent = new PremiumEvent(PremiumEvent.TRIGGER);
         Event.messages = this.m_PremiumMessages;
         Event.highlightExpiry = HIGHLIGHT_TIMEOUT;
         dispatchEvent(Event);
      }
      
      public function showOrHideWidgetBasedOnPremiumStatus() : void
      {
         var _loc1_:Boolean = this.isWidgetVisible();
         var _loc2_:Boolean = this.freePlayerLimitations || this.m_Player.premium && this.premiumExpiryDays <= PREMIUM_EXPIRY_THRESHOLD;
         if(_loc1_ && !_loc2_)
         {
            this.showOrHideWidget(false);
         }
         else if(!_loc1_ && _loc2_)
         {
            this.showOrHideWidget(true);
         }
      }
      
      private function findVisibleSidebarLocation(param1:SideBarSet) : int
      {
         var _loc3_:int = 0;
         var _loc2_:Array = [SideBarSet.LOCATION_C,SideBarSet.LOCATION_B,SideBarSet.LOCATION_D,SideBarSet.LOCATION_A];
         for each(_loc3_ in _loc2_)
         {
            if(param1.getSideBar(_loc3_).visible)
            {
               return _loc3_;
            }
         }
         return SideBarSet.LOCATION_B;
      }
   }
}
