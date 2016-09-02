package tibia.game
{
   import mx.controls.Button;
   import flash.events.MouseEvent;
   import shared.controls.CustomButton;
   import mx.events.CloseEvent;
   
   public class DeathMessageWidget extends MessageWidget
   {
      
      private static const EXTRA_BUTTON_FLAGS:Array = [{
         "data":EXTRA_BUTTON_STORE,
         "label":"BTN_STORE"
      }];
      
      private static const BUNDLE:String = "DeathMessageWidget";
      
      public static const EXTRA_BUTTON_STORE:uint = 4194304;
      
      private static const EXTRA_BUTTON_MASK:uint = EXTRA_BUTTON_STORE;
       
      
      private var m_UncommittedExtraButtonFlags:Boolean = false;
      
      protected var m_ExtraButtonFlags:uint = 0;
      
      public function DeathMessageWidget()
      {
         super();
         this.buttonFlags = BUTTON_CANCEL | BUTTON_OKAY | EXTRA_BUTTON_STORE;
      }
      
      override protected function commitProperties() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Button = null;
         super.commitProperties();
         if(this.m_UncommittedExtraButtonFlags)
         {
            _loc1_ = 0;
            _loc2_ = 0;
            _loc3_ = null;
            _loc1_ = footer.numChildren - 1;
            while(_loc1_ >= 0)
            {
               _loc3_ = Button(footer.getChildAt(_loc1_));
               if((uint(_loc3_.data) & EXTRA_BUTTON_MASK) != 0)
               {
                  _loc3_.removeEventListener(MouseEvent.CLICK,this.onExtraButton);
                  footer.removeChildAt(_loc1_);
               }
               _loc1_--;
            }
            _loc1_ = 0;
            while(_loc1_ < EXTRA_BUTTON_FLAGS.length)
            {
               if((this.m_ExtraButtonFlags & EXTRA_BUTTON_FLAGS[_loc1_].data) != 0)
               {
                  _loc3_ = new CustomButton();
                  _loc3_.enabled = (this.m_ExtraButtonFlags & PopUpBase.DISABLE_BUTTONS) == 0;
                  _loc3_.label = resourceManager.getString(BUNDLE,EXTRA_BUTTON_FLAGS[_loc1_].label);
                  _loc3_.data = EXTRA_BUTTON_FLAGS[_loc1_].data;
                  _loc3_.addEventListener(MouseEvent.CLICK,this.onExtraButton);
                  footer.addChildAt(_loc3_,_loc2_);
                  _loc2_++;
               }
               _loc1_++;
            }
            this.m_UncommittedExtraButtonFlags = true;
         }
      }
      
      protected function onExtraButton(param1:MouseEvent) : void
      {
         var _loc2_:Button = null;
         var _loc3_:CloseEvent = null;
         if(param1 != null)
         {
            _loc2_ = param1.currentTarget as Button;
            if(_loc2_ == null)
            {
               return;
            }
            switch(uint(_loc2_.data))
            {
               case EXTRA_BUTTON_STORE:
                  _loc3_ = new CloseEvent(CloseEvent.CLOSE,true,false);
                  _loc3_.detail = DeathMessageWidget.EXTRA_BUTTON_STORE;
                  dispatchEvent(_loc3_);
                  if(!_loc3_.cancelable || !_loc3_.isDefaultPrevented())
                  {
                     hide(false);
                  }
            }
         }
      }
      
      override public function get buttonFlags() : uint
      {
         return super.buttonFlags | this.m_ExtraButtonFlags;
      }
      
      override public function set buttonFlags(param1:uint) : void
      {
         super.buttonFlags = param1;
         var _loc2_:uint = param1 & EXTRA_BUTTON_MASK;
         if(this.m_ExtraButtonFlags != _loc2_)
         {
            this.m_ExtraButtonFlags = _loc2_;
            this.m_UncommittedExtraButtonFlags = true;
            invalidateProperties();
         }
      }
   }
}
