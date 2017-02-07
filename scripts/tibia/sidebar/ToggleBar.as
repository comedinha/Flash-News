package tibia.sidebar
{
   import flash.display.DisplayObject;
   import flash.events.MouseEvent;
   import mx.controls.Button;
   import mx.core.EdgeMetrics;
   import mx.core.IBorder;
   import mx.core.IFlexDisplayObject;
   import mx.core.IInvalidating;
   import mx.core.UIComponent;
   import mx.events.PropertyChangeEvent;
   import mx.styles.CSSStyleDeclaration;
   import mx.styles.ISimpleStyleClient;
   import mx.styles.StyleManager;
   import shared.controls.CustomButton;
   import tibia.options.OptionsStorage;
   
   public class ToggleBar extends UIComponent
   {
      
      {
         s_InitializeStyle();
      }
      
      private var m_UIRawChildren:int = 0;
      
      private var m_UncommittedLocations:Boolean = false;
      
      private var m_UncommittedOptions:Boolean = false;
      
      protected var m_UIBorderStyle:Object = null;
      
      protected var m_Location:Array = null;
      
      protected var m_Options:OptionsStorage = null;
      
      private var m_UIConstructed:Boolean = false;
      
      protected var m_SideBarSet:SideBarSet = null;
      
      protected var m_UIButtons:Array = null;
      
      private var m_UncommittedSideBarSet:Boolean = false;
      
      protected var m_UIBorderInstance:IFlexDisplayObject = null;
      
      public function ToggleBar()
      {
         super();
      }
      
      private static function s_InitializeStyle() : void
      {
         var Style:CSSStyleDeclaration = StyleManager.getStyleDeclaration("ToggleBar");
         if(Style == null)
         {
            Style = new CSSStyleDeclaration();
         }
         Style.defaultFactory = function():void
         {
            this.borderSkin = undefined;
            this.verticalGap = 4;
            this.paddingLeft = 0;
            this.paddingRight = 0;
            this.paddingTop = 0;
            this.paddingBottom = 0;
         };
         StyleManager.setStyleDeclaration("ToggleBar",Style,true);
      }
      
      private function layoutChrome(param1:Number, param2:Number) : void
      {
         if(this.m_UIBorderInstance != null)
         {
            this.m_UIBorderInstance.move(0,0);
            this.m_UIBorderInstance.setActualSize(param1,param2);
         }
      }
      
      function get sideBarSet() : SideBarSet
      {
         return this.m_SideBarSet;
      }
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
         if(this.m_UncommittedOptions)
         {
            this.m_UncommittedOptions = false;
         }
         if(this.m_UncommittedSideBarSet)
         {
            this.updateToggleButtons();
            this.m_UncommittedSideBarSet = false;
         }
         if(this.m_UncommittedLocations)
         {
            this.updateToggleButtons();
            this.m_UncommittedLocations = false;
         }
      }
      
      private function updateToggleButtons() : void
      {
         var _loc3_:DisplayObject = null;
         var _loc4_:Button = null;
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         _loc1_ = numChildren - 1;
         while(_loc1_ >= this.m_UIRawChildren)
         {
            _loc3_ = removeChildAt(_loc1_);
            _loc3_.removeEventListener(MouseEvent.CLICK,this.onToggleButtonClick);
            _loc1_--;
         }
         if(this.m_Location != null)
         {
            _loc1_ = 0;
            _loc2_ = this.m_Location.length;
            while(_loc1_ < _loc2_)
            {
               _loc4_ = new CustomButton();
               _loc4_.data = this.m_Location[_loc1_];
               _loc4_.selected = this.m_SideBarSet != null && this.m_SideBarSet.getSideBar(this.m_Location[_loc1_]).visible;
               _loc4_.styleName = getStyle("toggleButtonStyle");
               _loc4_.toggle = true;
               _loc4_.addEventListener(MouseEvent.CLICK,this.onToggleButtonClick);
               addChild(_loc4_);
               _loc1_++;
            }
         }
      }
      
      function set sideBarSet(param1:SideBarSet) : void
      {
         if(this.m_SideBarSet != param1)
         {
            if(this.m_SideBarSet != null)
            {
               this.m_SideBarSet.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onSideBarSetPropertyChange);
            }
            this.m_SideBarSet = param1;
            if(this.m_SideBarSet != null)
            {
               this.m_SideBarSet.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onSideBarSetPropertyChange);
            }
            this.m_UncommittedSideBarSet = true;
            invalidateProperties();
         }
      }
      
      protected function onOptionsChange(param1:PropertyChangeEvent) : void
      {
         if(param1 != null)
         {
            switch(param1.property)
            {
               case "sideBarSet":
               case "*":
                  this.updateSideBarSet();
            }
         }
      }
      
      protected function onSideBarSetPropertyChange(param1:PropertyChangeEvent) : void
      {
         var _loc2_:SideBar = null;
         var _loc3_:int = 0;
         var _loc4_:Button = null;
         if(param1 != null)
         {
            switch(param1.property as String)
            {
               case "sideBarInstanceOptions":
                  _loc2_ = param1.source as SideBar;
                  if(_loc2_ != null)
                  {
                     _loc3_ = numChildren - 1;
                     while(_loc3_ >= 0)
                     {
                        _loc4_ = getChildAt(_loc3_) as Button;
                        if(_loc4_ != null && int(_loc4_.data) == _loc2_.location)
                        {
                           _loc4_.selected = _loc2_.visible;
                           break;
                        }
                        _loc3_--;
                     }
                  }
            }
         }
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         var _loc10_:UIComponent = null;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         super.updateDisplayList(param1,param2);
         this.layoutChrome(param1,param2);
         var _loc3_:Number = getStyle("verticalGap");
         var _loc4_:Number = getStyle("paddingLeft");
         var _loc5_:Number = getStyle("paddingTop");
         var _loc6_:Number = param2 - _loc5_ - getStyle("paddingBottom");
         var _loc7_:Number = param1 - _loc4_ - getStyle("paddingRight");
         _loc5_ = _loc5_ + (_loc6_ - measuredHeight) / 2;
         var _loc8_:int = this.m_UIRawChildren;
         var _loc9_:int = numChildren;
         while(_loc8_ < _loc9_)
         {
            _loc10_ = UIComponent(getChildAt(_loc8_));
            _loc11_ = _loc10_.getExplicitOrMeasuredWidth();
            _loc12_ = _loc10_.getExplicitOrMeasuredHeight();
            _loc10_.move(_loc4_ + (_loc7_ - _loc11_) / 2,_loc5_);
            _loc10_.setActualSize(_loc11_,_loc12_);
            _loc5_ = _loc5_ + (_loc12_ + _loc3_);
            _loc8_++;
         }
      }
      
      override protected function createChildren() : void
      {
         if(!this.m_UIConstructed)
         {
            super.createChildren();
            this.updateToggleButtons();
            this.m_UIConstructed = true;
         }
      }
      
      private function updateBorder() : void
      {
         var _loc1_:Class = getStyle("borderSkin") as Class;
         if(this.m_UIBorderStyle != _loc1_)
         {
            if(this.m_UIBorderInstance != null)
            {
               removeChildAt(0);
               this.m_UIRawChildren = 0;
            }
            this.m_UIBorderStyle = _loc1_;
            if(this.m_UIBorderStyle != null)
            {
               this.m_UIBorderInstance = IFlexDisplayObject(new this.m_UIBorderStyle());
               if(this.m_UIBorderInstance is ISimpleStyleClient)
               {
                  ISimpleStyleClient(this.m_UIBorderInstance).styleName = this;
               }
               if(this.m_UIBorderInstance is IInvalidating)
               {
                  IInvalidating(this.m_UIBorderInstance).validateNow();
               }
               addChildAt(DisplayObject(this.m_UIBorderInstance),0);
               this.m_UIRawChildren = 1;
            }
            else
            {
               this.m_UIBorderInstance = null;
            }
         }
      }
      
      public function get options() : OptionsStorage
      {
         return this.m_Options;
      }
      
      protected function onToggleButtonClick(param1:MouseEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:SideBar = null;
         var _loc2_:Button = null;
         if(param1 != null)
         {
            _loc2_ = param1.currentTarget as Button;
         }
         if(_loc2_ != null && this.m_SideBarSet != null)
         {
            _loc3_ = int(_loc2_.data);
            _loc4_ = this.m_SideBarSet.getSideBar(_loc3_);
            if(_loc4_ != null)
            {
               _loc4_.visible = !_loc4_.visible;
            }
         }
      }
      
      override protected function measure() : void
      {
         var _loc3_:Number = NaN;
         var _loc6_:UIComponent = null;
         super.measure();
         var _loc1_:Number = getStyle("verticalGap");
         var _loc2_:Number = 0;
         _loc3_ = -_loc1_;
         var _loc4_:int = numChildren - 1;
         while(_loc4_ >= this.m_UIRawChildren)
         {
            _loc6_ = UIComponent(getChildAt(_loc4_));
            _loc2_ = Math.max(_loc2_,_loc6_.getExplicitOrMeasuredWidth());
            _loc3_ = _loc3_ + (_loc6_.getExplicitOrMeasuredHeight() + _loc1_);
            _loc4_--;
         }
         _loc3_ = Math.max(0,_loc3_);
         this.updateBorder();
         var _loc5_:EdgeMetrics = EdgeMetrics.EMPTY;
         if(this.m_UIBorderInstance is IBorder)
         {
            _loc5_ = IBorder(this.m_UIBorderInstance).borderMetrics;
         }
         measuredWidth = measuredMinWidth = Math.max(_loc5_.left + _loc5_.right,getStyle("paddingLeft") + _loc2_ + getStyle("paddingRight"));
         measuredHeight = measuredMinHeight = Math.max(_loc5_.top + _loc5_.bottom,getStyle("paddingTop") + _loc3_ + getStyle("paddingBottom"));
      }
      
      public function set location(param1:Array) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(param1 != null)
         {
            _loc2_ = param1.length - 1;
            while(_loc2_ >= 0)
            {
               _loc3_ = int(param1[_loc2_]);
               if(!SideBarSet.s_CheckLocation(_loc3_))
               {
                  throw new ArgumentError("ToggleBar.set location: Invalid location ID.");
               }
               _loc2_--;
            }
         }
         if(this.m_Location != param1)
         {
            this.m_Location = param1;
            this.m_UncommittedLocations = true;
            invalidateProperties();
         }
      }
      
      private function updateSideBarSet() : void
      {
         if(this.m_Options != null)
         {
            this.sideBarSet = this.m_Options.getSideBarSet(SideBarSet.DEFAULT_SET);
         }
         else
         {
            this.sideBarSet = null;
         }
      }
      
      public function get location() : Array
      {
         return this.m_Location;
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
            this.updateSideBarSet();
         }
      }
   }
}
