package tibia.controls
{
   import mx.core.UIComponent;
   import mx.core.IUIComponent;
   import mx.events.PropertyChangeEvent;
   import flash.display.DisplayObject;
   
   public class GridContainer extends UIComponent
   {
      
      protected static const CHILD_RIGHT:int = 3;
      
      protected static const CHILD_TOP:int = 0;
      
      protected static const CHILD_CENTER:int = 4;
      
      protected static const CHILD_LEFT:int = 2;
      
      protected static const CHILD_BOTTOM:int = 1;
       
      
      protected var m_Child:Vector.<IUIComponent> = null;
      
      public function GridContainer()
      {
         super();
         this.m_Child = new Vector.<IUIComponent>(5,true);
      }
      
      [Bindable(event="propertyChange")]
      public function set top(param1:IUIComponent) : void
      {
         var _loc2_:Object = this.top;
         if(_loc2_ !== param1)
         {
            this._115029top = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"top",_loc2_,param1));
         }
      }
      
      public function get top() : IUIComponent
      {
         return this.m_Child[CHILD_TOP];
      }
      
      private function getExplicitOrMeasuredMinHeight(param1:IUIComponent) : Number
      {
         var _loc2_:Number = 0;
         if(param1 != null)
         {
            _loc2_ = param1.explicitMinHeight;
            if(isNaN(_loc2_))
            {
               _loc2_ = param1.measuredMinHeight;
            }
            if(isNaN(_loc2_))
            {
               _loc2_ = 0;
            }
         }
         return _loc2_;
      }
      
      public function get left() : IUIComponent
      {
         return this.m_Child[CHILD_LEFT];
      }
      
      private function set _1383228885bottom(param1:IUIComponent) : void
      {
         this.setChild(CHILD_BOTTOM,param1);
      }
      
      private function set _108511772right(param1:IUIComponent) : void
      {
         this.setChild(CHILD_RIGHT,param1);
      }
      
      public function get bottom() : IUIComponent
      {
         return this.m_Child[CHILD_BOTTOM];
      }
      
      private function set _1364013995center(param1:IUIComponent) : void
      {
         this.setChild(CHILD_CENTER,param1);
      }
      
      private function set _115029top(param1:IUIComponent) : void
      {
         this.setChild(CHILD_TOP,param1);
      }
      
      [Bindable(event="propertyChange")]
      public function set left(param1:IUIComponent) : void
      {
         var _loc2_:Object = this.left;
         if(_loc2_ !== param1)
         {
            this._3317767left = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"left",_loc2_,param1));
         }
      }
      
      public function get center() : IUIComponent
      {
         return this.m_Child[CHILD_CENTER];
      }
      
      private function getExplicitOrMeasuredMinWidth(param1:IUIComponent) : Number
      {
         var _loc2_:Number = 0;
         if(param1 != null)
         {
            _loc2_ = param1.explicitMinWidth;
            if(isNaN(_loc2_))
            {
               _loc2_ = param1.measuredMinWidth;
            }
            if(isNaN(_loc2_))
            {
               _loc2_ = 0;
            }
         }
         return _loc2_;
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         super.updateDisplayList(param1,param2);
         var _loc3_:Number = 0;
         var _loc4_:Number = 0;
         var _loc5_:Number = 0;
         var _loc6_:Number = 0;
         var _loc7_:Number = param1;
         var _loc8_:Number = param2;
         if(this.m_Child[CHILD_TOP] != null && this.m_Child[CHILD_TOP].includeInLayout)
         {
            _loc4_ = Math.min(param2,this.m_Child[CHILD_TOP].getExplicitOrMeasuredHeight());
            _loc6_ = _loc4_;
            _loc8_ = _loc8_ - _loc4_;
            this.m_Child[CHILD_TOP].setActualSize(param1,_loc4_);
            this.m_Child[CHILD_TOP].move(0,0);
         }
         if(this.m_Child[CHILD_BOTTOM] != null && this.m_Child[CHILD_BOTTOM].includeInLayout)
         {
            _loc4_ = Math.min(param2,this.m_Child[CHILD_BOTTOM].getExplicitOrMeasuredHeight());
            _loc8_ = _loc8_ - _loc4_;
            this.m_Child[CHILD_BOTTOM].setActualSize(param1,_loc4_);
            this.m_Child[CHILD_BOTTOM].move(0,param2 - _loc4_);
         }
         if(this.m_Child[CHILD_LEFT] != null && this.m_Child[CHILD_LEFT].includeInLayout)
         {
            _loc3_ = Math.min(param1,this.m_Child[CHILD_LEFT].getExplicitOrMeasuredWidth());
            _loc5_ = _loc3_;
            _loc7_ = _loc7_ - _loc3_;
            this.m_Child[CHILD_LEFT].setActualSize(_loc3_,_loc8_);
            this.m_Child[CHILD_LEFT].move(0,_loc6_);
         }
         if(this.m_Child[CHILD_RIGHT] != null && this.m_Child[CHILD_RIGHT].includeInLayout)
         {
            _loc3_ = Math.min(param1,this.m_Child[CHILD_RIGHT].getExplicitOrMeasuredWidth());
            _loc7_ = _loc7_ - _loc3_;
            this.m_Child[CHILD_RIGHT].setActualSize(_loc3_,_loc8_);
            this.m_Child[CHILD_RIGHT].move(param1 - _loc3_,_loc6_);
         }
         if(this.m_Child[CHILD_CENTER] != null && this.m_Child[CHILD_CENTER].includeInLayout)
         {
            this.m_Child[CHILD_CENTER].setActualSize(_loc7_,_loc8_);
            this.m_Child[CHILD_CENTER].move(_loc5_,_loc6_);
         }
      }
      
      [Bindable(event="propertyChange")]
      public function set right(param1:IUIComponent) : void
      {
         var _loc2_:Object = this.right;
         if(_loc2_ !== param1)
         {
            this._108511772right = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"right",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function set center(param1:IUIComponent) : void
      {
         var _loc2_:Object = this.center;
         if(_loc2_ !== param1)
         {
            this._1364013995center = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"center",_loc2_,param1));
         }
      }
      
      protected function setChild(param1:int, param2:IUIComponent) : void
      {
         if(this.m_Child[param1] != null)
         {
            removeChild(this.m_Child[param1] as DisplayObject);
         }
         var _loc3_:int = this.m_Child.length - 1;
         while(_loc3_ >= 0)
         {
            if(this.m_Child[_loc3_] == param2)
            {
               this.m_Child[_loc3_] = null;
            }
            _loc3_--;
         }
         this.m_Child[param1] = param2;
         if(this.m_Child[param1] != null)
         {
            addChild(this.m_Child[param1] as DisplayObject);
         }
         invalidateDisplayList();
         invalidateSize();
      }
      
      private function set _3317767left(param1:IUIComponent) : void
      {
         this.setChild(CHILD_LEFT,param1);
      }
      
      public function get right() : IUIComponent
      {
         return this.m_Child[CHILD_RIGHT];
      }
      
      [Bindable(event="propertyChange")]
      public function set bottom(param1:IUIComponent) : void
      {
         var _loc2_:Object = this.bottom;
         if(_loc2_ !== param1)
         {
            this._1383228885bottom = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"bottom",_loc2_,param1));
         }
      }
      
      override protected function measure() : void
      {
         super.measure();
         var _loc1_:Number = 0;
         var _loc2_:Number = 0;
         var _loc3_:Number = 0;
         var _loc4_:Number = 0;
         if(this.m_Child[CHILD_LEFT] != null && this.m_Child[CHILD_LEFT].includeInLayout)
         {
            _loc1_ = _loc1_ + this.m_Child[CHILD_LEFT].getExplicitOrMeasuredWidth();
            _loc2_ = _loc2_ + this.getExplicitOrMeasuredMinWidth(this.m_Child[CHILD_LEFT]);
            _loc3_ = Math.max(_loc3_,this.m_Child[CHILD_LEFT].getExplicitOrMeasuredHeight());
            _loc4_ = Math.max(_loc4_,this.getExplicitOrMeasuredMinHeight(this.m_Child[CHILD_LEFT]));
         }
         if(this.m_Child[CHILD_CENTER] != null && this.m_Child[CHILD_CENTER].includeInLayout)
         {
            _loc1_ = _loc1_ + this.m_Child[CHILD_CENTER].getExplicitOrMeasuredWidth();
            _loc2_ = _loc2_ + this.getExplicitOrMeasuredMinWidth(this.m_Child[CHILD_CENTER]);
            _loc3_ = Math.max(_loc3_,this.m_Child[CHILD_CENTER].getExplicitOrMeasuredHeight());
            _loc4_ = Math.max(_loc4_,this.getExplicitOrMeasuredMinHeight(this.m_Child[CHILD_CENTER]));
         }
         if(this.m_Child[CHILD_RIGHT] != null && this.m_Child[CHILD_RIGHT].includeInLayout)
         {
            _loc1_ = _loc1_ + this.m_Child[CHILD_RIGHT].getExplicitOrMeasuredWidth();
            _loc2_ = _loc2_ + this.getExplicitOrMeasuredMinWidth(this.m_Child[CHILD_RIGHT]);
            _loc3_ = Math.max(_loc3_,this.m_Child[CHILD_RIGHT].getExplicitOrMeasuredHeight());
            _loc4_ = Math.max(_loc4_,this.getExplicitOrMeasuredMinHeight(this.m_Child[CHILD_RIGHT]));
         }
         if(this.m_Child[CHILD_BOTTOM] != null && this.m_Child[CHILD_BOTTOM].includeInLayout)
         {
            _loc1_ = Math.max(_loc1_,this.m_Child[CHILD_BOTTOM].getExplicitOrMeasuredWidth());
            _loc2_ = Math.max(_loc2_,this.getExplicitOrMeasuredMinWidth(this.m_Child[CHILD_BOTTOM]));
            _loc3_ = _loc3_ + this.m_Child[CHILD_BOTTOM].getExplicitOrMeasuredHeight();
            _loc4_ = _loc4_ + this.getExplicitOrMeasuredMinHeight(this.m_Child[CHILD_BOTTOM]);
         }
         if(this.m_Child[CHILD_TOP] != null && this.m_Child[CHILD_TOP].includeInLayout)
         {
            _loc1_ = Math.max(_loc1_,this.m_Child[CHILD_TOP].getExplicitOrMeasuredWidth());
            _loc2_ = Math.max(_loc2_,this.getExplicitOrMeasuredMinWidth(this.m_Child[CHILD_TOP]));
            _loc3_ = _loc3_ + this.m_Child[CHILD_TOP].getExplicitOrMeasuredHeight();
            _loc4_ = _loc4_ + this.getExplicitOrMeasuredMinHeight(this.m_Child[CHILD_TOP]);
         }
         measuredMinWidth = _loc2_;
         measuredWidth = _loc1_;
         measuredMinHeight = _loc4_;
         measuredHeight = _loc3_;
         explicitMinWidth = _loc2_;
         explicitMinHeight = _loc4_;
      }
   }
}
