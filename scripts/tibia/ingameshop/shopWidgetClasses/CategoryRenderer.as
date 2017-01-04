package tibia.ingameshop.shopWidgetClasses
{
   import flash.display.Bitmap;
   import flash.geom.Point;
   import mx.containers.HBox;
   import mx.controls.Image;
   import mx.controls.Text;
   import mx.core.ScrollPolicy;
   import tibia.ingameshop.IngameShopCategory;
   
   public class CategoryRenderer extends HBox
   {
      
      private static const SPECIAL_ICON_OFFSET:Point = new Point(0,0);
       
      
      private var m_UITextBox:Text;
      
      private var m_UISpecialIcon:Image;
      
      private var m_UncommittedCategory:Boolean;
      
      private var m_UIIcon:DynamicallyLoadedImage;
      
      public function CategoryRenderer()
      {
         super();
      }
      
      override protected function commitProperties() : void
      {
         var _loc1_:IngameShopCategory = null;
         var _loc2_:Bitmap = null;
         super.commitProperties();
         if(this.m_UncommittedCategory)
         {
            _loc1_ = data as IngameShopCategory;
            if(_loc1_ != null)
            {
               this.m_UITextBox.text = _loc1_.name;
               this.m_UIIcon.setImageIdentifier(_loc1_.iconIdentifiers != null && _loc1_.iconIdentifiers.length > 0?_loc1_.iconIdentifiers[0]:null);
               toolTip = _loc1_.description;
               _loc2_ = this.m_UISpecialIcon.getChildAt(0) as Bitmap;
               _loc2_.bitmapData = OfferRenderer.ICON_SALE;
               this.m_UISpecialIcon.setActualSize(OfferRenderer.ICON_SALE.width,OfferRenderer.ICON_SALE.height);
               this.m_UISpecialIcon.visible = _loc1_.hasSaleOffer() || _loc1_.hasNewOffer() || _loc1_.hasTimedOffer();
               if(_loc1_.hasSaleOffer())
               {
                  _loc2_.bitmapData = OfferRenderer.ICON_SALE;
               }
               else if(_loc1_.hasNewOffer())
               {
                  _loc2_.bitmapData = OfferRenderer.ICON_NEW;
               }
               else if(_loc1_.hasTimedOffer())
               {
                  _loc2_.bitmapData = OfferRenderer.ICON_EXPIRING;
               }
               if(this.m_UISpecialIcon.visible)
               {
                  this.m_UISpecialIcon.setActualSize(_loc2_.bitmapData.width,_loc2_.bitmapData.height);
               }
            }
            this.m_UncommittedCategory = false;
         }
      }
      
      override public function set data(param1:Object) : void
      {
         super.data = param1;
         this.m_UncommittedCategory = true;
         invalidateProperties();
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         verticalScrollPolicy = ScrollPolicy.OFF;
         horizontalScrollPolicy = ScrollPolicy.OFF;
         this.m_UIIcon = new DynamicallyLoadedImage(32);
         this.m_UIIcon.resizeToImage = false;
         addChild(this.m_UIIcon);
         this.m_UITextBox = new Text();
         addChild(this.m_UITextBox);
         this.m_UISpecialIcon = new Image();
         this.m_UISpecialIcon.addChild(new Bitmap());
         rawChildren.addChild(this.m_UISpecialIcon);
         this.m_UISpecialIcon.move(SPECIAL_ICON_OFFSET.x,SPECIAL_ICON_OFFSET.y);
      }
   }
}
