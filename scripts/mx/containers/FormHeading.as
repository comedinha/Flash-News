package mx.containers
{
   import flash.events.Event;
   import mx.controls.Label;
   import mx.core.EdgeMetrics;
   import mx.core.UIComponent;
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   public class FormHeading extends UIComponent
   {
      
      mx_internal static const VERSION:String = "3.6.0.21751";
       
      
      private var labelObj:Label;
      
      private var _label:String = "";
      
      public function FormHeading()
      {
         super();
      }
      
      private function getLabelWidth() : Number
      {
         var _loc1_:Number = getStyle("labelWidth");
         if(_loc1_ == 0)
         {
            _loc1_ = NaN;
         }
         if(isNaN(_loc1_) && parent is Form)
         {
            _loc1_ = Form(parent).calculateLabelWidth();
         }
         if(isNaN(_loc1_))
         {
            _loc1_ = 0;
         }
         return _loc1_;
      }
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
         createLabel();
      }
      
      [Bindable("labelChanged")]
      public function get label() : String
      {
         return _label;
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:EdgeMetrics = null;
         super.updateDisplayList(param1,param2);
         if(labelObj)
         {
            _loc3_ = getStyle("indicatorGap");
            _loc4_ = getStyle("paddingTop");
            _loc5_ = width;
            labelObj.move(getLabelWidth() + _loc3_,_loc4_);
            if(parent && parent is Form)
            {
               _loc6_ = Form(parent).viewMetricsAndPadding;
               _loc5_ = parent.width - (getLabelWidth() + _loc3_ + _loc6_.left + _loc6_.right);
            }
            labelObj.setActualSize(_loc5_,height);
         }
      }
      
      public function set label(param1:String) : void
      {
         _label = param1;
         invalidateProperties();
         dispatchEvent(new Event("labelChanged"));
      }
      
      override protected function measure() : void
      {
         super.measure();
         var _loc1_:Number = 0;
         var _loc2_:Number = getStyle("paddingTop");
         if(labelObj)
         {
            if(isNaN(labelObj.measuredWidth))
            {
               labelObj.validateSize();
            }
            _loc1_ = labelObj.measuredWidth;
            _loc2_ = _loc2_ + labelObj.measuredHeight;
         }
         _loc1_ = _loc1_ + (getLabelWidth() + getStyle("indicatorGap"));
         measuredMinWidth = _loc1_;
         measuredMinHeight = _loc2_;
         measuredWidth = _loc1_;
         measuredHeight = _loc2_;
      }
      
      private function createLabel() : void
      {
         if(_label && _label.length > 0)
         {
            if(!labelObj)
            {
               labelObj = new Label();
               labelObj.styleName = this;
               addChild(labelObj);
            }
            if(labelObj.text != _label)
            {
               labelObj.text = _label;
               labelObj.validateSize();
               invalidateSize();
               invalidateDisplayList();
            }
         }
         if((_label == null || _label.length == 0) && labelObj)
         {
            removeChild(labelObj);
            labelObj = null;
            invalidateSize();
            invalidateDisplayList();
         }
      }
   }
}
