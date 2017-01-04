package tibia.input.widgetClasses
{
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.ui.Keyboard;
   import mx.events.SliderEvent;
   import shared.controls.ShapeWrapper;
   import tibia.appearances.AppearanceStorage;
   import tibia.appearances.AppearanceType;
   import tibia.appearances.ObjectInstance;
   import tibia.appearances.widgetClasses.SimpleAppearanceRenderer;
   import tibia.controls.CustomSlider;
   import tibia.game.PopUpBase;
   
   public class SplitStackWidget extends PopUpBase
   {
      
      private static const BUNDLE:String = "SplitStackWidget";
       
      
      protected var m_UncommittedSelectedAmount:Boolean = false;
      
      protected var m_SelectedAmount:int = 0;
      
      private var m_ObjectInvalid:Boolean = false;
      
      protected var m_ObjectType:AppearanceType = null;
      
      private var m_UncommittedObjectType:Boolean = false;
      
      protected var m_InputAmount:int = 0;
      
      protected var m_UIAmount:CustomSlider = null;
      
      protected var m_ObjectInstance:ObjectInstance = null;
      
      private var m_UncommittedObjectAmount:Boolean = false;
      
      protected var m_ObjectAmount:int = 0;
      
      private var m_UIConstructed:Boolean = false;
      
      protected var m_UIObjectInstance:SimpleAppearanceRenderer = null;
      
      public function SplitStackWidget()
      {
         super();
         title = resourceManager.getString(BUNDLE,"TITLE");
         setStyle("verticalAlign","middle");
         setStyle("horizontalAlign","center");
         addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
         addEventListener(MouseEvent.MOUSE_WHEEL,this.onMouseWheel);
      }
      
      protected function onKeyDown(param1:KeyboardEvent) : void
      {
         var _loc2_:int = 0;
         if(param1.keyCode >= Keyboard.NUMBER_0 && param1.keyCode <= Keyboard.NUMBER_9)
         {
            this.m_InputAmount = (this.m_InputAmount * 10 + (param1.keyCode - Keyboard.NUMBER_0)) % 100;
            this.selectedAmount = Math.min(Math.max(1,this.m_InputAmount),this.m_ObjectAmount);
         }
         else
         {
            _loc2_ = 0;
            if(param1.keyCode == Keyboard.LEFT || param1.keyCode == Keyboard.DOWN)
            {
               _loc2_ = -1;
            }
            else if(param1.keyCode == Keyboard.RIGHT || param1.keyCode == Keyboard.UP)
            {
               _loc2_ = 1;
            }
            if(param1.shiftKey)
            {
               _loc2_ = _loc2_ * 10;
            }
            this.selectedAmount = Math.min(Math.max(1,this.selectedAmount + _loc2_),this.m_ObjectAmount);
         }
      }
      
      public function get objectType() : AppearanceType
      {
         return this.m_ObjectType;
      }
      
      public function get selectedAmount() : int
      {
         return this.m_SelectedAmount;
      }
      
      override protected function createChildren() : void
      {
         var _loc1_:ShapeWrapper = null;
         if(!this.m_UIConstructed)
         {
            super.createChildren();
            _loc1_ = new ShapeWrapper();
            this.m_UIObjectInstance = new SimpleAppearanceRenderer();
            this.m_UIObjectInstance.appearance = this.m_ObjectInstance;
            _loc1_.addChild(this.m_UIObjectInstance);
            addChild(_loc1_);
            this.m_UIAmount = new CustomSlider();
            this.m_UIAmount.liveDragging = true;
            this.m_UIAmount.maximum = 100;
            this.m_UIAmount.minimum = 1;
            this.m_UIAmount.minWidth = 200;
            this.m_UIAmount.percentWidth = 100;
            this.m_UIAmount.showDataTip = false;
            this.m_UIAmount.snapInterval = 1;
            this.m_UIAmount.addEventListener(SliderEvent.CHANGE,this.onSliderChange);
            addChild(this.m_UIAmount);
            this.m_UIConstructed = true;
         }
      }
      
      public function invalidateObject() : void
      {
         this.m_ObjectInvalid = true;
         invalidateProperties();
      }
      
      override protected function commitProperties() : void
      {
         var _loc1_:AppearanceStorage = null;
         super.commitProperties();
         if(this.m_UncommittedObjectType)
         {
            _loc1_ = Tibia.s_GetAppearanceStorage();
            if(_loc1_ != null)
            {
               this.m_ObjectInstance = _loc1_.createObjectInstance(this.m_ObjectType.ID,this.m_ObjectAmount);
            }
            else
            {
               this.m_ObjectInstance = null;
            }
            this.m_UncommittedObjectType = false;
         }
         if(this.m_UncommittedObjectAmount)
         {
            if(this.m_ObjectInstance != null)
            {
               this.m_ObjectInstance.data = this.m_ObjectAmount;
            }
            this.m_UIAmount.minimum = 1;
            this.m_UIAmount.maximum = this.m_ObjectAmount;
            this.m_UIAmount.value = this.m_ObjectAmount;
            this.m_UIAmount.labels = [1,this.m_ObjectAmount];
            this.m_UncommittedObjectAmount = false;
         }
         if(this.m_UncommittedSelectedAmount)
         {
            if(this.m_ObjectInstance != null)
            {
               this.m_ObjectInstance.data = this.m_SelectedAmount;
            }
            this.m_UIAmount.value = this.m_SelectedAmount;
            this.m_UncommittedSelectedAmount = false;
         }
         if(this.m_ObjectInvalid)
         {
            this.m_UIObjectInstance.appearance = this.m_ObjectInstance;
            this.m_UIObjectInstance.draw();
            ShapeWrapper(this.m_UIObjectInstance.parent).invalidateSize();
            ShapeWrapper(this.m_UIObjectInstance.parent).invalidateDisplayList();
            this.m_ObjectInvalid = false;
         }
      }
      
      public function set selectedAmount(param1:int) : void
      {
         param1 = Math.max(0,Math.min(param1,this.m_ObjectAmount));
         if(this.m_SelectedAmount != param1)
         {
            this.m_SelectedAmount = param1;
            this.m_UncommittedSelectedAmount = true;
            this.invalidateObject();
            invalidateProperties();
         }
      }
      
      public function set objectAmount(param1:int) : void
      {
         if(this.m_ObjectAmount != param1)
         {
            this.m_ObjectAmount = param1;
            this.m_UncommittedObjectAmount = true;
            this.m_SelectedAmount = Math.min(Math.max(0,this.m_SelectedAmount),this.m_ObjectAmount);
            this.m_UncommittedSelectedAmount = true;
            this.invalidateObject();
            invalidateProperties();
         }
      }
      
      public function set objectType(param1:AppearanceType) : void
      {
         if(this.m_ObjectType != param1)
         {
            this.m_ObjectType = param1;
            this.m_UncommittedObjectType = true;
            this.m_ObjectAmount = 0;
            this.m_UncommittedObjectAmount = true;
            this.m_SelectedAmount = 0;
            this.m_UncommittedSelectedAmount = true;
            this.invalidateObject();
            invalidateProperties();
         }
      }
      
      protected function onMouseWheel(param1:MouseEvent) : void
      {
         if(param1.delta != 0)
         {
            this.selectedAmount = this.selectedAmount + -param1.delta / Math.abs(param1.delta) * (!!param1.shiftKey?10:1);
         }
      }
      
      public function get objectAmount() : int
      {
         return this.m_ObjectAmount;
      }
      
      protected function onSliderChange(param1:SliderEvent) : void
      {
         this.selectedAmount = int(this.m_UIAmount.value);
      }
   }
}
