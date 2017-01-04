package tibia.ingameshop.shopWidgetClasses
{
   import flash.display.BitmapData;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import mx.containers.HBox;
   import mx.controls.Button;
   import mx.controls.Text;
   import mx.controls.TextArea;
   import mx.core.BitmapAsset;
   import mx.events.CloseEvent;
   import shared.controls.EmbeddedDialog;
   import tibia.appearances.AppearanceAnimator;
   import tibia.appearances.FrameDuration;
   import tibia.appearances.widgetClasses.SimpleAnimationRenderer;
   import tibia.ingameshop.IngameShopEvent;
   import tibia.ingameshop.IngameShopWidget;
   
   public class ShopReponseWidget extends EmbeddedDialog
   {
      
      private static const PURCHASE_SUCCESS_IDLE_BITMAP:BitmapData = (new PURCHASE_SUCCESS_IDLE() as BitmapAsset).bitmapData;
      
      private static const BUNDLE:String = "IngameShopWidget";
      
      private static const PURCHASE_SUCCESS_PRESSED_BITMAP:BitmapData = (new PURCHASE_SUCCESS_PRESSED() as BitmapAsset).bitmapData;
      
      private static const PURCHASE_SUCCESS_PRESSED:Class = ShopReponseWidget_PURCHASE_SUCCESS_PRESSED;
      
      private static const PURCHASE_SUCCESS_IDLE:Class = ShopReponseWidget_PURCHASE_SUCCESS_IDLE;
       
      
      private var m_ButtonTimer:Timer;
      
      private var m_SuccessButton:Button;
      
      private var m_ButtonAnimation:SimpleAnimationRenderer;
      
      private var m_ErrorType:int;
      
      private var m_Message:String;
      
      public function ShopReponseWidget(param1:String, param2:int)
      {
         super();
         this.m_ErrorType = param2;
         this.m_Message = param1;
         title = this.getTitleStringByErrorState();
         text = param1;
         width = IngameShopWidget.EMBEDDED_DIALOG_WIDTH;
         if(param2 != IngameShopEvent.ERROR_NO_ERROR)
         {
            minHeight = 175;
            buttonFlags = EmbeddedDialog.OKAY;
         }
         else
         {
            buttonFlags = EmbeddedDialog.NONE;
         }
      }
      
      protected function onStoreSuccessButtonAnimationOver(param1:TimerEvent) : void
      {
         var _loc2_:CloseEvent = new CloseEvent(CloseEvent.CLOSE,false,true,EmbeddedDialog.OKAY);
         dispatchEvent(_loc2_);
      }
      
      protected function onStoreSuccessButtonClicked(param1:MouseEvent) : void
      {
         this.setPurchaseButtonPressedAnimation();
         this.m_ButtonAnimation.removeEventListener(MouseEvent.CLICK,this.onStoreSuccessButtonClicked);
         this.m_ButtonTimer.start();
      }
      
      private function setPurchaseButtonPressedAnimation() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:int = 0;
         var _loc3_:uint = 0;
         var _loc4_:Vector.<FrameDuration> = null;
         var _loc5_:uint = 0;
         var _loc6_:AppearanceAnimator = null;
         var _loc7_:uint = 0;
         if(this.m_ButtonAnimation != null)
         {
            _loc1_ = 108;
            _loc2_ = 1;
            _loc3_ = PURCHASE_SUCCESS_PRESSED_BITMAP.width / _loc1_;
            _loc4_ = new Vector.<FrameDuration>();
            _loc5_ = 0;
            while(_loc5_ < _loc3_)
            {
               _loc7_ = _loc5_ < 5?uint(150):uint(100);
               _loc4_.push(new FrameDuration(_loc7_,_loc7_));
               _loc5_++;
            }
            _loc6_ = new AppearanceAnimator(_loc3_,0,_loc2_,AppearanceAnimator.ANIMATION_ASYNCHRON,_loc4_);
            this.m_ButtonAnimation.setAnimation(PURCHASE_SUCCESS_PRESSED_BITMAP,_loc1_,_loc6_);
         }
      }
      
      private function getTitleStringByErrorState() : String
      {
         switch(this.m_ErrorType)
         {
            case IngameShopEvent.ERROR_NO_ERROR:
               return resourceManager.getString(BUNDLE,"TITLE_PURCHASE_SUCCESS");
            case IngameShopEvent.ERROR_INFORMATION:
               return resourceManager.getString(BUNDLE,"TITLE_PURCHASE_INFORMATION");
            default:
               return resourceManager.getString(BUNDLE,"TITLE_PURCHASE_ERROR");
         }
      }
      
      override protected function createChildren() : void
      {
         var _loc1_:HBox = null;
         var _loc2_:Text = null;
         var _loc3_:TextArea = null;
         super.createChildren();
         if(this.getTextColorStyleNameByErrorState() != null)
         {
            titleBox.setStyle("color",getStyle(this.getTextColorStyleNameByErrorState()));
         }
         if(this.m_ErrorType == IngameShopEvent.ERROR_NO_ERROR)
         {
            _loc1_ = new HBox();
            _loc1_.percentHeight = 100;
            _loc1_.percentWidth = 100;
            this.m_SuccessButton = new Button();
            this.m_SuccessButton.styleName = "purchaseCompletedStyle";
            this.m_ButtonAnimation = new SimpleAnimationRenderer();
            this.m_ButtonAnimation.moveTarget = this.m_SuccessButton;
            this.m_ButtonAnimation.addEventListener(MouseEvent.CLICK,this.onStoreSuccessButtonClicked);
            _loc2_ = content.getChildAt(0) as Text;
            content.removeAllChildren();
            _loc3_ = new TextArea();
            _loc3_.editable = false;
            _loc3_.text = text;
            _loc3_.percentWidth = 100;
            _loc3_.maxHeight = _loc3_.height = PURCHASE_SUCCESS_IDLE_BITMAP.height;
            _loc1_.addChild(_loc3_);
            _loc1_.addChild(this.m_SuccessButton);
            _loc1_.rawChildren.addChild(this.m_ButtonAnimation);
            content.addChild(_loc1_);
            this.m_ButtonTimer = new Timer(2050);
            this.m_ButtonTimer.addEventListener(TimerEvent.TIMER,this.onStoreSuccessButtonAnimationOver);
            this.setPurchaseButtonIdleAnimation();
         }
      }
      
      private function getTextColorStyleNameByErrorState() : String
      {
         switch(this.m_ErrorType)
         {
            case IngameShopEvent.ERROR_NO_ERROR:
               return "successColor";
            case IngameShopEvent.ERROR_PURCHASE_FAILED:
               return "errorColor";
            case IngameShopEvent.ERROR_NETWORK:
               return "errorColor";
            case IngameShopEvent.ERROR_TRANSFER_FAILED:
               return "errorColor";
            case IngameShopEvent.ERROR_INFORMATION:
               return "informationColor";
            case IngameShopEvent.ERROR_TRANSACTION_HISTORY:
            default:
               return null;
         }
      }
      
      private function setPurchaseButtonIdleAnimation() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:int = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:Vector.<FrameDuration> = null;
         var _loc6_:uint = 0;
         var _loc7_:AppearanceAnimator = null;
         if(this.m_ButtonAnimation != null)
         {
            _loc1_ = 108;
            _loc2_ = 0;
            _loc3_ = PURCHASE_SUCCESS_IDLE_BITMAP.width / _loc1_;
            _loc4_ = 150;
            _loc5_ = new Vector.<FrameDuration>();
            _loc6_ = 0;
            while(_loc6_ < _loc3_)
            {
               _loc5_.push(new FrameDuration(_loc4_,_loc4_));
               _loc6_++;
            }
            _loc7_ = new AppearanceAnimator(_loc3_,0,_loc2_,AppearanceAnimator.ANIMATION_ASYNCHRON,_loc5_);
            this.m_ButtonAnimation.setAnimation(PURCHASE_SUCCESS_IDLE_BITMAP,_loc1_,_loc7_);
         }
      }
   }
}
