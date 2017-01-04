package tibia.ingameshop.shopWidgetClasses
{
   import flash.events.MouseEvent;
   import mx.containers.HBox;
   import mx.controls.Button;
   import shared.controls.CustomButton;
   import tibia.ingameshop.DynamicImage;
   
   public class SliderImage extends HBox
   {
      
      private static const IMAGE_MANAGED_FROM_OUTSIDE:int = -1;
       
      
      private var m_UILeftSliderButton:Button;
      
      private var m_UncommittedImageIndex:Boolean = true;
      
      private var m_UIRightSliderButton:Button;
      
      private var m_MaximumImageSize:int = 64;
      
      private var m_ImageIdentifierList:Vector.<String>;
      
      private var m_UIImage:DynamicallyLoadedImage;
      
      private var m_CurrentImageIndex:int = 0;
      
      public function SliderImage(param1:int = 64)
      {
         super();
         this.m_ImageIdentifierList = new Vector.<String>();
         this.m_MaximumImageSize = param1;
         setStyle("verticalAlign","middle");
         setStyle("horizontalGap",0);
      }
      
      public function set currentImageIndex(param1:int) : void
      {
         param1 = Math.max(0,Math.min(this.m_ImageIdentifierList.length - 1,param1));
         if(param1 != this.m_CurrentImageIndex)
         {
            this.m_CurrentImageIndex = param1;
            this.m_UncommittedImageIndex = true;
            invalidateProperties();
         }
      }
      
      protected function onSliderButtonClicked(param1:MouseEvent) : void
      {
         if(param1.target == this.m_UILeftSliderButton)
         {
            this.currentImageIndex = this.currentImageIndex - 1;
         }
         else
         {
            this.currentImageIndex = this.currentImageIndex + 1;
         }
      }
      
      public function setImageIdentifiers(param1:Vector.<String>) : void
      {
         this.currentImageIndex = 0;
         if(param1 != null)
         {
            this.m_ImageIdentifierList = param1.concat();
         }
         else
         {
            this.m_ImageIdentifierList.length = 0;
         }
         this.m_UncommittedImageIndex = true;
         invalidateProperties();
      }
      
      public function set dynamicImage(param1:DynamicImage) : void
      {
         this.m_CurrentImageIndex = IMAGE_MANAGED_FROM_OUTSIDE;
         this.m_ImageIdentifierList.length = 0;
         this.m_UIImage.dynamicImage = param1;
         this.m_UncommittedImageIndex = true;
         invalidateProperties();
      }
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
         if(this.m_UncommittedImageIndex)
         {
            if(this.m_CurrentImageIndex != IMAGE_MANAGED_FROM_OUTSIDE)
            {
               if(this.m_CurrentImageIndex < this.m_ImageIdentifierList.length)
               {
                  this.m_UIImage.setImageIdentifier(this.m_ImageIdentifierList[this.m_CurrentImageIndex]);
               }
               else
               {
                  this.m_UIImage.setImageIdentifier(null);
               }
            }
            this.m_UILeftSliderButton.visible = this.m_ImageIdentifierList.length > 1 && this.m_CurrentImageIndex > 0;
            this.m_UIRightSliderButton.visible = this.m_ImageIdentifierList.length > 1 && this.m_CurrentImageIndex < this.m_ImageIdentifierList.length - 1;
            this.m_UncommittedImageIndex = false;
         }
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this.m_UILeftSliderButton = new CustomButton();
         this.m_UILeftSliderButton.styleName = "customSliderDecreaseButton";
         this.m_UILeftSliderButton.addEventListener(MouseEvent.CLICK,this.onSliderButtonClicked);
         addChild(this.m_UILeftSliderButton);
         this.m_UIImage = new DynamicallyLoadedImage(this.m_MaximumImageSize);
         this.m_UIImage.resizeToImage = false;
         addChild(this.m_UIImage);
         this.m_UIRightSliderButton = new CustomButton();
         this.m_UIRightSliderButton.styleName = "customSliderIncreaseButton";
         this.m_UIRightSliderButton.addEventListener(MouseEvent.CLICK,this.onSliderButtonClicked);
         addChild(this.m_UIRightSliderButton);
      }
      
      public function get currentImageIndex() : int
      {
         return this.m_CurrentImageIndex;
      }
      
      public function dispose() : void
      {
         this.m_UIImage.dynamicImage = null;
         this.m_UILeftSliderButton.removeEventListener(MouseEvent.CLICK,this.onSliderButtonClicked);
         this.m_UIRightSliderButton.removeEventListener(MouseEvent.CLICK,this.onSliderButtonClicked);
      }
   }
}
