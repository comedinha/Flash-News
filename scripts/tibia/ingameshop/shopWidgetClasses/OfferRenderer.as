package tibia.ingameshop.shopWidgetClasses
{
   import mx.containers.VBox;
   import flash.display.BitmapData;
   import flash.geom.Point;
   import flash.display.Bitmap;
   import mx.containers.HBox;
   import mx.controls.Label;
   import mx.controls.Image;
   import tibia.ingameshop.IngameShopOffer;
   import mx.core.IUIComponent;
   import mx.core.Container;
   import flash.filters.ColorMatrixFilter;
   import mx.core.ScrollPolicy;
   
   public class OfferRenderer extends VBox
   {
      
      private static const BUNDLE:String = "IngameShopWidget";
      
      public static const ICON_SALE:BitmapData = Bitmap(new ICON_SALE_CLASS()).bitmapData;
      
      private static const BLACK_WHITE_FILTER:Array = [0.3,0.59,0.11,0,-10,0.3,0.59,0.11,0,-10,0.3,0.59,0.11,0,-10,0,0,0,1,0];
      
      public static const ICON_EXPIRING:BitmapData = Bitmap(new ICON_EXPIRING_CLASS()).bitmapData;
      
      public static const ICON_NEW:BitmapData = Bitmap(new ICON_NEW_CLASS()).bitmapData;
      
      private static const ICON_NEW_CLASS:Class = OfferRenderer_ICON_NEW_CLASS;
      
      private static const ICON_SALE_CLASS:Class = OfferRenderer_ICON_SALE_CLASS;
      
      private static const SPECIAL_ICON_OFFSET:Point = new Point(1,24);
      
      private static const ICON_EXPIRING_CLASS:Class = OfferRenderer_ICON_EXPIRING_CLASS;
       
      
      private var m_UIMainContainer:VBox;
      
      private var m_UIPrice:tibia.ingameshop.shopWidgetClasses.CoinWidget;
      
      private var m_UncommittedOffer:Boolean;
      
      private var m_UISpecialIcon:Image;
      
      private var m_UIName:Label;
      
      private var m_UIIcon:tibia.ingameshop.shopWidgetClasses.SliderImage;
      
      public function OfferRenderer()
      {
         super();
         horizontalScrollPolicy = ScrollPolicy.OFF;
         verticalScrollPolicy = ScrollPolicy.OFF;
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         var _loc1_:VBox = new VBox();
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         var _loc2_:int = 5;
         _loc1_.setStyle("paddingLeft",_loc2_);
         _loc1_.setStyle("paddingRight",_loc2_);
         _loc1_.setStyle("paddingTop",_loc2_);
         _loc1_.setStyle("paddingBottom",_loc2_);
         addChild(_loc1_);
         this.m_UIMainContainer = new VBox();
         this.m_UIMainContainer.percentWidth = 100;
         _loc1_.addChild(this.m_UIMainContainer);
         var _loc3_:HBox = new HBox();
         _loc3_.percentWidth = 100;
         _loc3_.styleName = "offerDarkBorder";
         this.m_UIMainContainer.addChild(_loc3_);
         this.m_UIName = new Label();
         this.m_UIName.maxWidth = 100;
         this.m_UIName.truncateToFit = true;
         _loc3_.addChild(this.m_UIName);
         this.m_UIIcon = new tibia.ingameshop.shopWidgetClasses.SliderImage(64);
         this.m_UIMainContainer.addChild(this.m_UIIcon);
         this.m_UIPrice = new tibia.ingameshop.shopWidgetClasses.CoinWidget();
         this.m_UIPrice.percentWidth = 100;
         this.m_UIPrice.styleName = "offerDarkBorder";
         this.m_UIMainContainer.addChild(this.m_UIPrice);
         this.m_UISpecialIcon = new Image();
         this.m_UISpecialIcon.addChild(new Bitmap());
         this.m_UIMainContainer.rawChildren.addChild(this.m_UISpecialIcon);
         this.m_UISpecialIcon.move(SPECIAL_ICON_OFFSET.x,SPECIAL_ICON_OFFSET.y);
      }
      
      private function getTitleStyle(param1:IngameShopOffer) : String
      {
         if(param1.disabled)
         {
            return "";
         }
         if(param1.isSale())
         {
            return "ingameShopOfferSale";
         }
         if(param1.isNew())
         {
            return "ingameShopOfferNew";
         }
         if(param1.isTimed())
         {
            return "ingameShopOfferLastChance";
         }
         return "";
      }
      
      override public function set data(param1:Object) : void
      {
         super.data = param1;
         this.m_UncommittedOffer = true;
         invalidateProperties();
      }
      
      override protected function commitProperties() : void
      {
         var _loc1_:IngameShopOffer = null;
         var _loc2_:Bitmap = null;
         super.commitProperties();
         if(this.m_UncommittedOffer)
         {
            _loc1_ = data as IngameShopOffer;
            if(_loc1_ != null)
            {
               this.m_UIName.text = _loc1_.name;
               this.m_UIName.styleName = this.getTitleStyle(_loc1_);
               this.m_UIIcon.setImageIdentifiers(_loc1_.iconIdentifiers);
               this.m_UIPrice.coins = _loc1_.price;
               this.setDisabledStyle(_loc1_.disabled);
               this.m_UIMainContainer.toolTip = !!_loc1_.disabled?resourceManager.getString(BUNDLE,"LBL_CANNOT_BUY_GENERIC") + "\n" + _loc1_.disabledReason + "\n" + _loc1_.description:_loc1_.description;
               _loc2_ = this.m_UISpecialIcon.getChildAt(0) as Bitmap;
               this.m_UISpecialIcon.visible = _loc1_.isSale() || _loc1_.isNew() || _loc1_.isTimed();
               if(_loc1_.isSale())
               {
                  _loc2_.bitmapData = ICON_SALE;
                  this.m_UISpecialIcon.setActualSize(ICON_SALE.width,ICON_SALE.height);
               }
               else if(_loc1_.isNew())
               {
                  _loc2_.bitmapData = ICON_NEW;
                  this.m_UISpecialIcon.setActualSize(ICON_NEW.width,ICON_NEW.height);
               }
               else if(_loc1_.isTimed())
               {
                  _loc2_.bitmapData = ICON_EXPIRING;
                  this.m_UISpecialIcon.setActualSize(ICON_EXPIRING.width,ICON_EXPIRING.height);
               }
            }
            else
            {
               this.m_UIIcon.setImageIdentifiers(null);
            }
            this.m_UncommittedOffer = false;
         }
      }
      
      private function setDisabledStyle(param1:Boolean) : void
      {
         var _loc3_:IUIComponent = null;
         var _loc4_:Container = null;
         var _loc5_:int = 0;
         var _loc2_:Array = [this];
         this.m_UIMainContainer.styleName = !!param1?"ingameShopOfferRendererBoxDisabled":"ingameShopOfferRendererBoxEnabled";
         while(_loc2_.length > 0)
         {
            _loc3_ = _loc2_.pop() as IUIComponent;
            if(_loc3_ != null)
            {
               if(param1)
               {
                  _loc3_.filters = [new ColorMatrixFilter(BLACK_WHITE_FILTER)];
               }
               else
               {
                  _loc3_.filters = [];
               }
            }
            _loc4_ = _loc3_ as Container;
            if(_loc4_ != null)
            {
               _loc5_ = 0;
               while(_loc5_ < _loc4_.getChildren().length)
               {
                  _loc2_.push(_loc4_.getChildAt(_loc5_));
                  _loc5_++;
               }
               continue;
            }
         }
      }
   }
}
