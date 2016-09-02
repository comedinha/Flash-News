package tibia.premium
{
   import flash.display.BitmapData;
   import mx.core.BitmapAsset;
   
   public final class PremiumMessage
   {
      
      private static const ICON_DEPOT_SPACE_BITMAP:BitmapData = (new ICON_DEPOT_SPACE_CLASS() as BitmapAsset).bitmapData;
      
      public static const XP_BOOST:tibia.premium.PremiumMessage = new tibia.premium.PremiumMessage("LBL_XP_BOOST",ICON_XP_BOOST_BITMAP);
      
      public static const INVITE_PRIVCHAT:tibia.premium.PremiumMessage = new tibia.premium.PremiumMessage("LBL_INVITE_PRIVCHAT",ICON_INVITE_PRIVCHAT_BITMAP);
      
      private static const ICON_ALL_OUTFITS_CLASS:Class = PremiumMessage_ICON_ALL_OUTFITS_CLASS;
      
      private static const ICON_VIP_LIST_CLASS:Class = PremiumMessage_ICON_VIP_LIST_CLASS;
      
      private static const ICON_CLASS_PROMOTION_CLASS:Class = PremiumMessage_ICON_CLASS_PROMOTION_CLASS;
      
      public static const ACCESS_ARENAS:tibia.premium.PremiumMessage = new tibia.premium.PremiumMessage("LBL_ACCESS_ARENAS",ICON_ACCESS_ARENAS_BITMAP);
      
      private static const ICON_CLASS_PROMOTION_BITMAP:BitmapData = (new ICON_CLASS_PROMOTION_CLASS() as BitmapAsset).bitmapData;
      
      private static const ICON_DEATH_PENALTY_CLASS:Class = PremiumMessage_ICON_DEATH_PENALTY_CLASS;
      
      private static const ICON_RIDE_MOUNTS_BITMAP:BitmapData = (new ICON_RIDE_MOUNTS_CLASS() as BitmapAsset).bitmapData;
      
      private static const ICON_DEATH_PENALTY_BITMAP:BitmapData = (new ICON_DEATH_PENALTY_CLASS() as BitmapAsset).bitmapData;
      
      public static const RENT_HOUSES:tibia.premium.PremiumMessage = new tibia.premium.PremiumMessage("LBL_RENT_HOUSES",ICON_RENT_HOUSES_BITMAP);
      
      private static const ICON_MARKET_CLASS:Class = PremiumMessage_ICON_MARKET_CLASS;
      
      private static const ICON_MAP_BITMAP:BitmapData = (new ICON_MAP_CLASS() as BitmapAsset).bitmapData;
      
      public static const VIP_LIST:tibia.premium.PremiumMessage = new tibia.premium.PremiumMessage("LBL_VIP_LIST",ICON_VIP_LIST_BITMAP);
      
      public static const RIDE_MOUNTS:tibia.premium.PremiumMessage = new tibia.premium.PremiumMessage("LBL_RIDE_MOUNTS",ICON_RIDE_MOUNTS_BITMAP);
      
      private static const ICON_SPELL_CLASS:Class = PremiumMessage_ICON_SPELL_CLASS;
      
      private static const ICON_XP_BOOST_BITMAP:BitmapData = (new ICON_XP_BOOST_CLASS() as BitmapAsset).bitmapData;
      
      public static const ALL_AREAS:tibia.premium.PremiumMessage = new tibia.premium.PremiumMessage("LBL_ALL_AREAS",ICON_MAP_BITMAP);
      
      private static const ICON_RENT_HOUSES_BITMAP:BitmapData = (new ICON_RENT_HOUSES_CLASS() as BitmapAsset).bitmapData;
      
      public static const RENEW_PREMIUM:tibia.premium.PremiumMessage = new tibia.premium.PremiumMessage("LBL_RENEW_PREMIUM",ICON_RENEW_PREMIUM_BITMAP);
      
      private static const ICON_ALL_OUTFITS_BITMAP:BitmapData = (new ICON_ALL_OUTFITS_CLASS() as BitmapAsset).bitmapData;
      
      private static const ICON_INVITE_PRIVCHAT_BITMAP:BitmapData = (new ICON_INVITE_PRIVCHAT_CLASS() as BitmapAsset).bitmapData;
      
      private static const ICON_TRAINING_CLASS:Class = PremiumMessage_ICON_TRAINING_CLASS;
      
      public static const MARKET:tibia.premium.PremiumMessage = new tibia.premium.PremiumMessage("LBL_MARKET",ICON_MARKET_BITMAP);
      
      private static const ICON_RENEW_PREMIUM_CLASS:Class = PremiumMessage_ICON_RENEW_PREMIUM_CLASS;
      
      private static const ICON_TRAVEL_FASTER_BITMAP:BitmapData = (new ICON_TRAVEL_FASTER_CLASS() as BitmapAsset).bitmapData;
      
      public static const ALL_SPELLS:tibia.premium.PremiumMessage = new tibia.premium.PremiumMessage("LBL_ALL_SPELLS",ICON_SPELL_BITMAP);
      
      private static const ICON_SPELL_BITMAP:BitmapData = (new ICON_SPELL_CLASS() as BitmapAsset).bitmapData;
      
      public static const TRAVEL_FASTER:tibia.premium.PremiumMessage = new tibia.premium.PremiumMessage("LBL_TRAVEL_FASTER",ICON_TRAVEL_FASTER_BITMAP);
      
      private static const ICON_MAP_CLASS:Class = PremiumMessage_ICON_MAP_CLASS;
      
      private static const ICON_MARKET_BITMAP:BitmapData = (new ICON_MARKET_CLASS() as BitmapAsset).bitmapData;
      
      private static const ICON_DEPOT_SPACE_CLASS:Class = PremiumMessage_ICON_DEPOT_SPACE_CLASS;
      
      private static const ICON_RENEW_PREMIUM_BITMAP:BitmapData = (new ICON_RENEW_PREMIUM_CLASS() as BitmapAsset).bitmapData;
      
      private static const ICON_ACCESS_ARENAS_CLASS:Class = PremiumMessage_ICON_ACCESS_ARENAS_CLASS;
      
      private static const ICON_XP_BOOST_CLASS:Class = PremiumMessage_ICON_XP_BOOST_CLASS;
      
      private static const ICON_TRAVEL_FASTER_CLASS:Class = PremiumMessage_ICON_TRAVEL_FASTER_CLASS;
      
      public static const CLASS_PROMOTION:tibia.premium.PremiumMessage = new tibia.premium.PremiumMessage("LBL_CLASS_PROMOTION",ICON_CLASS_PROMOTION_BITMAP);
      
      public static const TRAIN_OFFLINE:tibia.premium.PremiumMessage = new tibia.premium.PremiumMessage("LBL_TRAIN_OFFLINE",ICON_TRAINING_BITMAP);
      
      private static const ICON_ACCESS_ARENAS_BITMAP:BitmapData = (new ICON_ACCESS_ARENAS_CLASS() as BitmapAsset).bitmapData;
      
      private static const ICON_TRAINING_BITMAP:BitmapData = (new ICON_TRAINING_CLASS() as BitmapAsset).bitmapData;
      
      private static const ICON_VIP_LIST_BITMAP:BitmapData = (new ICON_VIP_LIST_CLASS() as BitmapAsset).bitmapData;
      
      public static const ALL_OUTFITS:tibia.premium.PremiumMessage = new tibia.premium.PremiumMessage("LBL_ALL_OUTFITS",ICON_ALL_OUTFITS_BITMAP);
      
      private static const ICON_RENT_HOUSES_CLASS:Class = PremiumMessage_ICON_RENT_HOUSES_CLASS;
      
      private static const ICON_RIDE_MOUNTS_CLASS:Class = PremiumMessage_ICON_RIDE_MOUNTS_CLASS;
      
      public static const DEPOT_SPACE:tibia.premium.PremiumMessage = new tibia.premium.PremiumMessage("LBL_DEPOT_SPACE",ICON_DEPOT_SPACE_BITMAP);
      
      private static const ICON_INVITE_PRIVCHAT_CLASS:Class = PremiumMessage_ICON_INVITE_PRIVCHAT_CLASS;
      
      public static const DEATH_PENALTY:tibia.premium.PremiumMessage = new tibia.premium.PremiumMessage("LBL_DEATH_PENALTY",ICON_DEATH_PENALTY_BITMAP);
       
      
      private var m_Icon:BitmapData;
      
      private var m_ResourceText:String;
      
      public function PremiumMessage(param1:String, param2:BitmapData = null)
      {
         super();
         this.m_ResourceText = param1;
         this.m_Icon = param2;
      }
      
      public function set icon(param1:BitmapData) : void
      {
         this.m_Icon = param1;
      }
      
      public function get resourceText() : String
      {
         return this.m_ResourceText;
      }
      
      public function set resourceText(param1:String) : void
      {
         this.m_ResourceText = param1;
      }
      
      public function get icon() : BitmapData
      {
         return this.m_Icon;
      }
   }
}
