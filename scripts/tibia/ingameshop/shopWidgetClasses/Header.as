package tibia.ingameshop.shopWidgetClasses
{
   import mx.containers.HBox;
   import mx.core.IDataRenderer;
   import flash.display.BitmapData;
   import flash.display.Bitmap;
   import tibia.ingameshop.IngameShopWidget;
   import flash.errors.IllegalOperationError;
   import mx.controls.Text;
   import mx.containers.VBox;
   import mx.containers.ViewStack;
   import tibia.ingameshop.IngameShopCategory;
   import tibia.ingameshop.IngameShopOffer;
   import tibia.ingameshop.DynamicImage;
   
   public class Header extends HBox implements IIngameShopWidgetComponent, IDataRenderer
   {
      
      private static const VIEW_OFFER:int = 1;
      
      private static const BUNDLE:String = "IngameShopWidget";
      
      public static const STATIC_HEADER_TRANSACTION_HISTORY:int = 0;
      
      private static const ICON_COINS_CLASS:Class = Header_ICON_COINS_CLASS;
      
      private static const VIEW_CATEGORY:int = 0;
      
      private static const ICON_COINS:BitmapData = Bitmap(new ICON_COINS_CLASS()).bitmapData;
       
      
      private var m_UILabelHeader:Text;
      
      private var m_UIIcon:tibia.ingameshop.shopWidgetClasses.SliderImage;
      
      private var m_UncommittedSelection:Boolean;
      
      private var m_UIDetailsStack:ViewStack;
      
      private var m_UILabelDescription:Text;
      
      private var m_UILabelPrice:tibia.ingameshop.shopWidgetClasses.CoinWidget;
      
      private var m_ShopWindow:IngameShopWidget;
      
      public function Header()
      {
         super();
      }
      
      public function set shopWidget(param1:IngameShopWidget) : void
      {
         if(this.m_ShopWindow != null)
         {
            throw new IllegalOperationError("IngameShopOfferList.shopWidget: Attempted to set reference twice");
         }
         this.m_ShopWindow = param1;
      }
      
      public function setStaticHeader(param1:int) : void
      {
         this.data = {"staticHeader":param1};
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         setStyle("verticalAlign","middle");
         this.m_UIIcon = new tibia.ingameshop.shopWidgetClasses.SliderImage(64);
         addChild(this.m_UIIcon);
         var _loc1_:VBox = new VBox();
         _loc1_.percentWidth = 100;
         _loc1_.setStyle("verticalGap",2);
         addChild(_loc1_);
         this.m_UILabelHeader = new Text();
         this.m_UILabelHeader.styleName = "ingameShopBold";
         _loc1_.addChild(this.m_UILabelHeader);
         this.m_UIDetailsStack = new ViewStack();
         this.m_UIDetailsStack.percentWidth = 100;
         this.m_UIDetailsStack.resizeToContent = true;
         _loc1_.addChild(this.m_UIDetailsStack);
         var _loc2_:HBox = new HBox();
         _loc2_.percentWidth = 100;
         this.m_UIDetailsStack.addChild(_loc2_);
         this.m_UILabelDescription = new Text();
         this.m_UILabelDescription.percentWidth = 100;
         this.m_UILabelDescription.styleName = "ingameShopCategoryDescription";
         _loc2_.addChild(this.m_UILabelDescription);
         this.m_UILabelPrice = new tibia.ingameshop.shopWidgetClasses.CoinWidget();
         this.m_UILabelPrice.percentWidth = 100;
         this.m_UIDetailsStack.addChild(this.m_UILabelPrice);
         this.m_UncommittedSelection = true;
      }
      
      override protected function commitProperties() : void
      {
         var _loc1_:IngameShopCategory = null;
         var _loc2_:IngameShopOffer = null;
         var _loc3_:int = 0;
         var _loc4_:DynamicImage = null;
         super.commitProperties();
         if(this.m_UncommittedSelection && this.m_ShopWindow != null)
         {
            _loc1_ = data as IngameShopCategory;
            _loc2_ = data as IngameShopOffer;
            _loc3_ = data != null && data.hasOwnProperty("staticHeader")?int(data.staticHeader):-1;
            if(_loc2_ != null)
            {
               this.m_UILabelHeader.text = _loc2_.name;
               this.m_UILabelPrice.coins = _loc2_.price;
               this.m_UIIcon.setImageIdentifiers(_loc2_.iconIdentifiers);
               this.m_UIDetailsStack.selectedIndex = VIEW_OFFER;
            }
            else if(_loc1_ != null)
            {
               this.m_UILabelHeader.text = _loc1_.name;
               this.m_UILabelDescription.text = _loc1_.description;
               this.m_UIIcon.setImageIdentifiers(_loc1_.iconIdentifiers);
               this.m_UIDetailsStack.selectedIndex = VIEW_CATEGORY;
            }
            else if(_loc3_ == STATIC_HEADER_TRANSACTION_HISTORY)
            {
               this.m_UILabelHeader.text = resourceManager.getString(BUNDLE,"TITLE_TRANSACTION_HISTORY");
               this.m_UILabelDescription.text = resourceManager.getString(BUNDLE,"LBL_TRANSACTION_HISTORY");
               _loc4_ = new DynamicImage();
               _loc4_.bitmapData = ICON_COINS;
               this.m_UIIcon.dynamicImage = _loc4_;
               this.m_UIDetailsStack.selectedIndex = VIEW_CATEGORY;
            }
            else
            {
               this.m_UILabelHeader.text = "";
               this.m_UILabelDescription.text = "";
               this.m_UIIcon.dynamicImage = null;
               this.m_UIDetailsStack.selectedIndex = VIEW_CATEGORY;
            }
            this.m_UncommittedSelection = false;
         }
      }
      
      override public function set data(param1:Object) : void
      {
         super.data = param1;
         this.m_UncommittedSelection = true;
         invalidateProperties();
      }
      
      public function dispose() : void
      {
         this.m_UIIcon.dispose();
         this.m_ShopWindow = null;
      }
   }
}
