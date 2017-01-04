package tibia.options.configurationWidgetClasses
{
   import flash.events.MouseEvent;
   import mx.controls.ComboBox;
   import mx.core.ClassFactory;
   import mx.core.EdgeMetrics;
   import mx.core.mx_internal;
   import tibia.chat.MessageMode;
   
   public class ColorComboBox extends ComboBox
   {
       
      
      private var m_UIColorRenderer:ColorItemRenderer = null;
      
      private var m_UncommittedSelectedItem:Boolean = false;
      
      public function ColorComboBox()
      {
         var _loc2_:uint = 0;
         super();
         var _loc1_:Array = [];
         for each(_loc2_ in MessageMode.MESSAGE_MODE_COLOURS)
         {
            _loc1_.push(_loc1_.length);
         }
         dataProvider = _loc1_;
         itemRenderer = new ClassFactory(ColorItemRenderer);
      }
      
      private function onMouseEvent(param1:MouseEvent) : void
      {
         if(mx_internal::downArrowButton != null)
         {
            mx_internal::downArrowButton.dispatchEvent(param1);
         }
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         super.updateDisplayList(param1,param2);
         var _loc3_:EdgeMetrics = borderMetrics;
         var _loc4_:Number = param1 - _loc3_.left - _loc3_.right;
         if(mx_internal::downArrowButton != null)
         {
            _loc4_ = _loc4_ - mx_internal::downArrowButton.getExplicitOrMeasuredWidth();
         }
         var _loc5_:Number = param2 - _loc3_.top - _loc3_.bottom;
         this.m_UIColorRenderer.data = selectedIndex;
         this.m_UIColorRenderer.move(_loc3_.left,_loc3_.top);
         this.m_UIColorRenderer.setActualSize(_loc4_,_loc5_);
         setChildIndex(this.m_UIColorRenderer,numChildren - 1);
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this.m_UIColorRenderer = new ColorItemRenderer();
         this.m_UIColorRenderer.setStyle("cornerRadius",5);
         this.m_UIColorRenderer.addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseEvent);
         this.m_UIColorRenderer.addEventListener(MouseEvent.MOUSE_UP,this.onMouseEvent);
         this.m_UIColorRenderer.addEventListener(MouseEvent.ROLL_OUT,this.onMouseEvent);
         this.m_UIColorRenderer.addEventListener(MouseEvent.ROLL_OVER,this.onMouseEvent);
         addChild(this.m_UIColorRenderer);
      }
   }
}
