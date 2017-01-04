package tibia.controls
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.text.TextLineMetrics;
   import mx.containers.HBox;
   import mx.controls.Image;
   import mx.controls.Label;
   import shared.utility.i18n.i18nFormatNumber;
   
   public class TibiaCurrencyView extends HBox
   {
      
      private static const BUNDLE:String = "Tibia";
      
      private static const ICON_GOLD_COIN_CLASS:Class = TibiaCurrencyView_ICON_GOLD_COIN_CLASS;
      
      public static const CURRENCY_ICON_BONUS_REROLL:uint = 3;
      
      private static const ICON_TIBIA_COIN_CLASS:Class = TibiaCurrencyView_ICON_TIBIA_COIN_CLASS;
      
      private static const ICON_BONUS_REROLL_CLASS:Class = TibiaCurrencyView_ICON_BONUS_REROLL_CLASS;
      
      public static const ICON_TIBIA_COIN:BitmapData = Bitmap(new ICON_TIBIA_COIN_CLASS()).bitmapData;
      
      public static const CURRENCY_ICON_TIBIA_COIN:uint = 2;
      
      public static const ICON_BONUS_REROLL:BitmapData = Bitmap(new ICON_BONUS_REROLL_CLASS()).bitmapData;
      
      public static const CURRENCY_ICON_GOLD_COIN:uint = 1;
      
      public static const ICON_GOLD_COIN:BitmapData = Bitmap(new ICON_GOLD_COIN_CLASS()).bitmapData;
      
      public static const CURRENCY_ICON_NONE:uint = 0;
       
      
      private var m_UICurrencyImage:Image = null;
      
      private var m_CurrentCurrency:Number = NaN;
      
      private var m_UncomittedBaseCurrency:Boolean = false;
      
      private var m_UIBaseCurrencyText:Label = null;
      
      private var m_CurrencyIcon:uint = 0;
      
      private var m_UncomittedCurrentCurrency:Boolean = false;
      
      private var m_BaseCurrencyAmount:Number = NaN;
      
      private var m_NotEnoughCurrencyStyle:Boolean = false;
      
      private var m_UICurrentCurrencyText:Label = null;
      
      private var m_UIConstructed:Boolean = false;
      
      private var m_UncomittedCurrencyIcon:Boolean = false;
      
      public function TibiaCurrencyView()
      {
         super();
      }
      
      public function set notEnoughCurrency(param1:Boolean) : void
      {
         if(param1 != this.m_NotEnoughCurrencyStyle)
         {
            this.m_NotEnoughCurrencyStyle = param1;
            if(this.m_NotEnoughCurrencyStyle)
            {
               this.m_UICurrentCurrencyText.styleName = "notEnoughCurrency";
            }
            else
            {
               this.m_UICurrentCurrencyText.styleName = "";
            }
         }
      }
      
      public function get notEnoughCurrency() : Boolean
      {
         return this.m_NotEnoughCurrencyStyle;
      }
      
      public function get baseCurrency() : Number
      {
         return this.m_BaseCurrencyAmount;
      }
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
         if(this.m_UncomittedCurrentCurrency)
         {
            this.m_UICurrentCurrencyText.text = i18nFormatNumber(this.m_CurrentCurrency);
            this.m_UncomittedCurrentCurrency = false;
         }
         if(this.m_UncomittedBaseCurrency)
         {
            if(isNaN(this.m_BaseCurrencyAmount))
            {
               this.m_UIBaseCurrencyText.visible = false;
               this.m_UIBaseCurrencyText.includeInLayout = false;
               this.m_UIBaseCurrencyText.text = "";
            }
            else
            {
               this.m_UIBaseCurrencyText.visible = true;
               this.m_UIBaseCurrencyText.includeInLayout = true;
               this.m_UIBaseCurrencyText.text = i18nFormatNumber(this.m_BaseCurrencyAmount);
            }
            this.m_UncomittedBaseCurrency = false;
         }
         if(this.m_UncomittedCurrencyIcon)
         {
            this.m_UICurrencyImage.removeChildren();
            if(this.m_CurrencyIcon == CURRENCY_ICON_GOLD_COIN)
            {
               this.m_UICurrencyImage.addChild(new Bitmap(ICON_GOLD_COIN));
               this.m_UICurrencyImage.width = ICON_GOLD_COIN.width;
               this.m_UICurrencyImage.height = ICON_GOLD_COIN.height;
               this.m_UICurrencyImage.toolTip = resourceManager.getString(BUNDLE,"TOOLTIP_CURRENCY_GOLD");
            }
            else if(this.m_CurrencyIcon == CURRENCY_ICON_TIBIA_COIN)
            {
               this.m_UICurrencyImage.addChild(new Bitmap(ICON_TIBIA_COIN));
               this.m_UICurrencyImage.width = ICON_TIBIA_COIN.width;
               this.m_UICurrencyImage.height = ICON_TIBIA_COIN.height;
               this.m_UICurrencyImage.toolTip = resourceManager.getString(BUNDLE,"TOOLTIP_CURRENCY_TIBIA_COINS");
            }
            else if(this.m_CurrencyIcon == CURRENCY_ICON_BONUS_REROLL)
            {
               this.m_UICurrencyImage.addChild(new Bitmap(ICON_BONUS_REROLL));
               this.m_UICurrencyImage.width = ICON_BONUS_REROLL.width;
               this.m_UICurrencyImage.height = ICON_BONUS_REROLL.height;
               this.m_UICurrencyImage.toolTip = resourceManager.getString(BUNDLE,"TOOLTIP_CURRENCY_BONUS_REROLLS");
            }
            this.m_UncomittedCurrencyIcon = false;
         }
      }
      
      public function set baseCurrency(param1:Number) : void
      {
         if(param1 != this.m_BaseCurrencyAmount)
         {
            this.m_BaseCurrencyAmount = param1;
            this.m_UncomittedBaseCurrency = true;
            invalidateProperties();
         }
      }
      
      public function get currencyIcon() : uint
      {
         return this.m_CurrencyIcon;
      }
      
      override protected function createChildren() : void
      {
         if(!this.m_UIConstructed)
         {
            super.createChildren();
            this.m_UIBaseCurrencyText = new Label();
            this.m_UIBaseCurrencyText.text = "";
            this.m_UIBaseCurrencyText.visible = false;
            this.m_UIBaseCurrencyText.includeInLayout = false;
            this.m_UIBaseCurrencyText.styleName = "baseCurrency";
            addChild(this.m_UIBaseCurrencyText);
            this.m_UICurrentCurrencyText = new Label();
            this.m_UICurrentCurrencyText.text = "";
            addChild(this.m_UICurrentCurrencyText);
            this.m_UICurrencyImage = new Image();
            addChild(this.m_UICurrencyImage);
            styleName = "withBorder";
            this.m_UIConstructed = true;
         }
      }
      
      public function set currentCurrency(param1:uint) : void
      {
         if(param1 != this.m_CurrentCurrency)
         {
            this.m_CurrentCurrency = param1;
            this.m_UncomittedCurrentCurrency = true;
            invalidateProperties();
         }
      }
      
      public function set currencyIcon(param1:uint) : void
      {
         if(param1 != this.m_CurrencyIcon)
         {
            this.m_CurrencyIcon = param1;
            this.m_UncomittedCurrencyIcon = true;
            invalidateProperties();
         }
      }
      
      public function get currentCurrency() : uint
      {
         return this.m_CurrentCurrency;
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         var _loc3_:TextLineMetrics = null;
         var _loc4_:int = 0;
         super.updateDisplayList(param1,param2);
         if(this.m_UIBaseCurrencyText.visible)
         {
            _loc3_ = this.m_UIBaseCurrencyText.getLineMetrics(0);
            _loc4_ = _loc3_.height * 0.5 + 2;
            this.m_UIBaseCurrencyText.graphics.clear();
            this.m_UIBaseCurrencyText.graphics.lineStyle(1,this.m_UIBaseCurrencyText.getStyle("color"),1,true);
            this.m_UIBaseCurrencyText.graphics.moveTo(0,_loc4_);
            this.m_UIBaseCurrencyText.graphics.lineTo(_loc3_.width + 3,_loc4_);
         }
      }
   }
}
