package tibia.controls
{
   import flash.events.MouseEvent;
   import tibia.options.OptionsStorage;
   import mx.events.PropertyChangeEvent;
   import mx.controls.Button;
   import shared.controls.CustomButton;
   
   public class GameWindowContainer extends GridContainer
   {
       
      
      private var m_Options:OptionsStorage = null;
      
      private var m_UncommittedOptions:Boolean = false;
      
      private var m_UIConstructed:Boolean = false;
      
      private var m_UILock:Button = null;
      
      public function GameWindowContainer()
      {
         super();
      }
      
      private function onLockClick(param1:MouseEvent) : void
      {
         if(this.options != null)
         {
            this.options.generalActionBarsLock = !this.options.generalActionBarsLock;
         }
      }
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
         if(this.m_UncommittedOptions)
         {
            this.m_UILock.selected = this.options != null && this.options.generalActionBarsLock;
            this.m_UncommittedOptions = false;
         }
      }
      
      private function onOptionsChange(param1:PropertyChangeEvent) : void
      {
         if(param1.property == "generalActionBarsLock" || param1.property == "*")
         {
            this.m_UILock.selected = this.options != null && this.options.generalActionBarsLock;
         }
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         super.updateDisplayList(param1,param2);
         var _loc3_:Number = this.m_UILock.getExplicitOrMeasuredWidth();
         var _loc4_:Number = this.m_UILock.getExplicitOrMeasuredHeight();
         this.m_UILock.move(param1 - _loc3_,0);
         this.m_UILock.setActualSize(_loc3_,_loc4_);
         setChildIndex(this.m_UILock,numChildren - 1);
      }
      
      override protected function createChildren() : void
      {
         if(!this.m_UIConstructed)
         {
            super.createChildren();
            this.m_UILock = new CustomButton();
            this.m_UILock.selected = this.options != null && this.options.generalActionBarsLock;
            this.m_UILock.styleName = "gameWindowLockButton";
            this.m_UILock.toggle = true;
            this.m_UILock.addEventListener(MouseEvent.CLICK,this.onLockClick);
            addChild(this.m_UILock);
            this.m_UIConstructed = true;
         }
      }
      
      public function set options(param1:OptionsStorage) : void
      {
         if(this.m_Options != param1)
         {
            if(this.m_Options != null)
            {
               this.m_Options.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onOptionsChange);
            }
            this.m_Options = param1;
            if(this.m_Options != null)
            {
               this.m_Options.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onOptionsChange);
            }
            this.m_UncommittedOptions = true;
            invalidateProperties();
         }
      }
      
      public function get options() : OptionsStorage
      {
         return this.m_Options;
      }
   }
}
