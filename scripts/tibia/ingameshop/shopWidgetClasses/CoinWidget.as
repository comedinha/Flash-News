package tibia.ingameshop.shopWidgetClasses
{
   import mx.containers.HBox;
   import flash.display.BitmapData;
   import flash.display.Bitmap;
   import mx.controls.Label;
   import shared.utility.i18n.i18nFormatNumber;
   import mx.controls.Image;
   
   public class CoinWidget extends HBox
   {
      
      private static const ICON_COINS_CLASS:Class = CoinWidget_ICON_COINS_CLASS;
      
      private static const BUNDLE:String = "IngameShopWidget";
      
      public static const ICON_COINS:BitmapData = Bitmap(new ICON_COINS_CLASS()).bitmapData;
       
      
      private var m_UIUpdatingText:Label;
      
      private var m_UICoinsText:Label;
      
      private var m_Coins:Number;
      
      private var m_UncommittedCoins:Boolean = true;
      
      private var m_UICoinsIcon:Image;
      
      private var m_CoinsAreFinal:Boolean = true;
      
      public function CoinWidget()
      {
         super();
         this.m_Coins = 0;
         this.m_CoinsAreFinal = true;
      }
      
      public function set coins(param1:Number) : void
      {
         if(param1 != this.m_Coins)
         {
            this.m_Coins = param1;
            this.m_UncommittedCoins = true;
            invalidateProperties();
         }
      }
      
      override protected function commitProperties() : void
      {
         var _loc1_:* = false;
         super.commitProperties();
         if(this.m_UncommittedCoins)
         {
            _loc1_ = !isNaN(this.m_Coins);
            this.m_UICoinsText.text = !!_loc1_?resourceManager.getString(BUNDLE,"LBL_CREDITS_VALUE",[i18nFormatNumber(this.m_Coins)]):"-";
            this.m_UICoinsIcon.visible = _loc1_;
            this.m_UICoinsIcon.includeInLayout = _loc1_;
            this.m_UIUpdatingText.visible = !this.m_CoinsAreFinal;
            this.m_UIUpdatingText.includeInLayout = !this.m_CoinsAreFinal;
            invalidateSize();
            this.m_UncommittedCoins = false;
         }
      }
      
      public function set coinsAreFinal(param1:Boolean) : void
      {
         if(param1 != this.m_CoinsAreFinal)
         {
            this.m_CoinsAreFinal = param1;
            this.m_UncommittedCoins = true;
            invalidateProperties();
         }
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this.m_UICoinsText = new Label();
         addChild(this.m_UICoinsText);
         this.m_UICoinsIcon = new Image();
         this.m_UICoinsIcon.addChild(new Bitmap(ICON_COINS));
         this.m_UICoinsIcon.width = ICON_COINS.width;
         this.m_UICoinsIcon.height = ICON_COINS.height;
         addChild(this.m_UICoinsIcon);
         this.m_UIUpdatingText = new Label();
         this.m_UIUpdatingText.text = resourceManager.getString(BUNDLE,"LBL_CREDITS_UPDATING");
         addChild(this.m_UIUpdatingText);
      }
   }
}
