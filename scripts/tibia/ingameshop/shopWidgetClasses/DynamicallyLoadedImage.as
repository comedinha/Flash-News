package tibia.ingameshop.shopWidgetClasses
{
   import mx.controls.Image;
   import flash.display.Bitmap;
   import tibia.ingameshop.IngameShopEvent;
   import tibia.ingameshop.IngameShopManager;
   import flash.display.BitmapData;
   import tibia.ingameshop.DynamicImage;
   
   public class DynamicallyLoadedImage extends Image
   {
       
      
      private var m_Bitmap:Bitmap;
      
      private var m_UncommittedBitmapData:Boolean;
      
      private var m_MaximumImageSize:int;
      
      private var m_DynamicImage:DynamicImage;
      
      private var m_ResizeToImage:Boolean;
      
      public function DynamicallyLoadedImage(param1:int = 64)
      {
         super();
         this.m_MaximumImageSize = param1;
         this.m_ResizeToImage = true;
      }
      
      protected function onImageChanged(param1:IngameShopEvent) : void
      {
         this.m_UncommittedBitmapData = true;
         invalidateProperties();
      }
      
      public function setImageIdentifier(param1:String) : void
      {
         if(param1 != null)
         {
            param1 = this.m_MaximumImageSize + "/" + param1;
            this.dynamicImage = IngameShopManager.getInstance().imageManager.getImage(param1);
         }
         else
         {
            this.dynamicImage = null;
         }
      }
      
      public function get resizeToImage() : Boolean
      {
         return this.m_ResizeToImage;
      }
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
         if(this.m_UncommittedBitmapData)
         {
            if(this.m_DynamicImage != null)
            {
               this.m_Bitmap.bitmapData = this.m_DynamicImage.bitmapData;
            }
            else
            {
               this.m_Bitmap.bitmapData = new BitmapData(this.m_MaximumImageSize,this.m_MaximumImageSize,true,0);
            }
            if(this.m_ResizeToImage)
            {
               height = Math.min(this.m_MaximumImageSize,this.m_Bitmap.bitmapData.height);
               width = Math.min(this.m_MaximumImageSize,this.m_Bitmap.bitmapData.width);
            }
            else
            {
               height = this.m_MaximumImageSize;
               width = this.m_MaximumImageSize;
               this.m_Bitmap.height = this.m_MaximumImageSize;
               this.m_Bitmap.width = this.m_MaximumImageSize;
            }
            this.m_UncommittedBitmapData = false;
         }
      }
      
      public function set resizeToImage(param1:Boolean) : void
      {
         if(param1 != this.m_ResizeToImage)
         {
            this.m_ResizeToImage = param1;
            this.m_UncommittedBitmapData = true;
            invalidateProperties();
         }
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this.m_Bitmap = new Bitmap();
         addChild(this.m_Bitmap);
         this.m_UncommittedBitmapData = true;
      }
      
      public function set dynamicImage(param1:DynamicImage) : void
      {
         if(this.m_DynamicImage != null)
         {
            this.m_DynamicImage.removeEventListener(IngameShopEvent.IMAGE_CHANGED,this.onImageChanged);
         }
         this.m_DynamicImage = param1;
         this.m_UncommittedBitmapData = true;
         invalidateProperties();
         if(this.m_DynamicImage != null)
         {
            this.m_DynamicImage.addEventListener(IngameShopEvent.IMAGE_CHANGED,this.onImageChanged,false,0,true);
         }
      }
   }
}
