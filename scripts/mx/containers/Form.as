package mx.containers
{
   import mx.core.Container;
   import mx.core.mx_internal;
   import mx.styles.StyleManager;
   import flash.display.DisplayObject;
   import mx.containers.utilityClasses.BoxLayout;
   import mx.core.IUIComponent;
   import mx.core.IInvalidating;
   import mx.controls.Label;
   
   use namespace mx_internal;
   
   public class Form extends Container
   {
      
      mx_internal static const VERSION:String = "3.6.0.21751";
      
      private static var classInitialized:Boolean = false;
       
      
      mx_internal var layoutObject:BoxLayout;
      
      private var measuredLabelWidth:Number;
      
      public function Form()
      {
         layoutObject = new BoxLayout();
         super();
         if(!classInitialized)
         {
            initializeClass();
            classInitialized = true;
         }
         showInAutomationHierarchy = true;
         mx_internal::layoutObject.target = this;
         mx_internal::layoutObject.direction = BoxDirection.VERTICAL;
      }
      
      private static function initializeClass() : void
      {
         StyleManager.registerInheritingStyle("labelWidth");
         StyleManager.registerSizeInvalidatingStyle("labelWidth");
         StyleManager.registerInheritingStyle("indicatorGap");
         StyleManager.registerSizeInvalidatingStyle("indicatorGap");
      }
      
      override public function addChild(param1:DisplayObject) : DisplayObject
      {
         invalidateLabelWidth();
         return super.addChild(param1);
      }
      
      override public function styleChanged(param1:String) : void
      {
         if(!param1 || param1 == "styleName" || StyleManager.isSizeInvalidatingStyle(param1))
         {
            invalidateLabelWidth();
         }
         super.styleChanged(param1);
      }
      
      override public function removeChildAt(param1:int) : DisplayObject
      {
         invalidateLabelWidth();
         return super.removeChildAt(param1);
      }
      
      function calculateLabelWidth() : Number
      {
         var _loc5_:DisplayObject = null;
         if(!isNaN(measuredLabelWidth))
         {
            return measuredLabelWidth;
         }
         var _loc1_:Number = 0;
         var _loc2_:Boolean = false;
         var _loc3_:int = numChildren;
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = getChildAt(_loc4_);
            if(_loc5_ is FormItem && FormItem(_loc5_).includeInLayout)
            {
               _loc1_ = Math.max(_loc1_,FormItem(_loc5_).getPreferredLabelWidth());
               _loc2_ = true;
            }
            _loc4_++;
         }
         if(_loc2_)
         {
            measuredLabelWidth = _loc1_;
         }
         return _loc1_;
      }
      
      function invalidateLabelWidth() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:IUIComponent = null;
         if(!isNaN(measuredLabelWidth) && initialized)
         {
            measuredLabelWidth = NaN;
            _loc1_ = numChildren;
            _loc2_ = 0;
            while(_loc2_ < _loc1_)
            {
               _loc3_ = IUIComponent(getChildAt(_loc2_));
               if(_loc3_ is IInvalidating)
               {
                  IInvalidating(_loc3_).invalidateSize();
               }
               _loc2_++;
            }
         }
      }
      
      [Bindable("updateComplete")]
      public function get maxLabelWidth() : Number
      {
         var _loc3_:DisplayObject = null;
         var _loc4_:Label = null;
         var _loc1_:int = numChildren;
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = getChildAt(_loc2_);
            if(_loc3_ is FormItem)
            {
               _loc4_ = FormItem(_loc3_).itemLabel;
               if(_loc4_)
               {
                  return _loc4_.width;
               }
            }
            _loc2_++;
         }
         return 0;
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         super.updateDisplayList(param1,param2);
         mx_internal::layoutObject.updateDisplayList(param1,param2);
      }
      
      override public function addChildAt(param1:DisplayObject, param2:int) : DisplayObject
      {
         invalidateLabelWidth();
         return super.addChildAt(param1,param2);
      }
      
      override protected function measure() : void
      {
         super.measure();
         mx_internal::layoutObject.measure();
         calculateLabelWidth();
      }
      
      override public function removeChild(param1:DisplayObject) : DisplayObject
      {
         invalidateLabelWidth();
         return super.removeChild(param1);
      }
   }
}
