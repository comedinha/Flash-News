package mx.containers
{
   import flash.display.DisplayObject;
   import flash.events.FocusEvent;
   import flash.events.KeyboardEvent;
   import mx.controls.Button;
   import mx.controls.TabBar;
   import mx.core.Container;
   import mx.core.EdgeMetrics;
   import mx.core.FlexVersion;
   import mx.core.IFlexDisplayObject;
   import mx.core.IInvalidating;
   import mx.core.IProgrammaticSkin;
   import mx.core.IUIComponent;
   import mx.core.mx_internal;
   import mx.managers.IFocusManagerComponent;
   import mx.styles.StyleProxy;
   
   use namespace mx_internal;
   
   public class TabNavigator extends ViewStack implements IFocusManagerComponent
   {
      
      private static var _tabBarStyleFilters:Object = {
         "firstTabStyleName":"firstTabStyleName",
         "horizontalAlign":"horizontalAlign",
         "horizontalGap":"horizontalGap",
         "lastTabStyleName":"lastTabStyleName",
         "selectedTabTextStyleName":"selectedTabTextStyleName",
         "tabStyleName":"tabStyleName",
         "tabWidth":"tabWidth",
         "verticalAlign":"verticalAlign",
         "verticalGap":"verticalGap"
      };
      
      mx_internal static const VERSION:String = "3.6.0.21751";
      
      private static const MIN_TAB_WIDTH:Number = 30;
       
      
      protected var tabBar:TabBar;
      
      public function TabNavigator()
      {
         super();
         tabEnabled = true;
         historyManagementEnabled = true;
      }
      
      override protected function get contentHeight() : Number
      {
         var _loc1_:EdgeMetrics = viewMetricsAndPadding;
         var _loc2_:Number = _loc1_.top;
         var _loc3_:Number = _loc1_.bottom;
         if(isNaN(_loc2_))
         {
            _loc2_ = 0;
         }
         if(isNaN(_loc3_))
         {
            _loc3_ = 0;
         }
         return unscaledHeight - tabBarHeight - _loc2_ - _loc3_;
      }
      
      mx_internal function getTabBar() : TabBar
      {
         return tabBar;
      }
      
      override protected function layoutChrome(param1:Number, param2:Number) : void
      {
         var _loc3_:Number = NaN;
         super.layoutChrome(param1,param2);
         if(border)
         {
            _loc3_ = tabBarHeight;
            border.setActualSize(param1,param2 - _loc3_);
            border.move(0,_loc3_);
         }
      }
      
      private function get tabBarHeight() : Number
      {
         var _loc1_:Number = getStyle("tabHeight");
         if(isNaN(_loc1_))
         {
            _loc1_ = tabBar.getExplicitOrMeasuredHeight();
         }
         return _loc1_ - borderMetrics.top;
      }
      
      override protected function get contentY() : Number
      {
         var _loc1_:Number = getStyle("paddingTop");
         if(isNaN(_loc1_))
         {
            _loc1_ = 0;
         }
         return tabBarHeight + _loc1_;
      }
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
         if(tabBar && tabBar.dataProvider != this && numChildren > 0 && getChildAt(0))
         {
            tabBar.dataProvider = this;
         }
      }
      
      override protected function adjustFocusRect(param1:DisplayObject = null) : void
      {
         super.adjustFocusRect(param1);
         var _loc2_:IFlexDisplayObject = IFlexDisplayObject(getFocusObject());
         if(_loc2_)
         {
            _loc2_.setActualSize(_loc2_.width,_loc2_.height - tabBarHeight);
            _loc2_.move(_loc2_.x,_loc2_.y + tabBarHeight);
            if(_loc2_ is IInvalidating)
            {
               IInvalidating(_loc2_).validateNow();
            }
            else if(_loc2_ is IProgrammaticSkin)
            {
               IProgrammaticSkin(_loc2_).validateNow();
            }
         }
      }
      
      override protected function focusOutHandler(param1:FocusEvent) : void
      {
         super.focusOutHandler(param1);
         if(focusManager && param1.target == this)
         {
            focusManager.defaultButtonEnabled = true;
         }
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         if(!tabBar)
         {
            tabBar = new TabBar();
            tabBar.name = "tabBar";
            tabBar.focusEnabled = false;
            tabBar.styleName = new StyleProxy(this,tabBarStyleFilters);
            rawChildren.addChild(tabBar);
            if(FlexVersion.compatibilityVersion < FlexVersion.VERSION_3_0)
            {
               tabBar.setStyle("paddingTop",0);
               tabBar.setStyle("paddingBottom",0);
               tabBar.setStyle("borderStyle","none");
            }
         }
      }
      
      override public function get baselinePosition() : Number
      {
         var _loc4_:Container = null;
         if(FlexVersion.compatibilityVersion < FlexVersion.VERSION_3_0)
         {
            return super.baselinePosition;
         }
         if(!validateBaselinePosition())
         {
            return NaN;
         }
         var _loc1_:* = numChildren == 0;
         if(_loc1_)
         {
            _loc4_ = new Container();
            addChild(_loc4_);
            validateNow();
         }
         var _loc2_:Button = getTabAt(0);
         var _loc3_:Number = tabBar.y + _loc2_.y + _loc2_.baselinePosition;
         if(_loc1_)
         {
            removeChildAt(0);
            validateNow();
         }
         return _loc3_;
      }
      
      override protected function measure() : void
      {
         var _loc1_:Number = NaN;
         if(vsPreferredWidth && !resizeToContent)
         {
            measuredMinWidth = vsMinWidth;
            measuredMinHeight = vsMinHeight;
            measuredWidth = vsPreferredWidth;
            measuredHeight = vsPreferredHeight;
            return;
         }
         super.measure();
         _loc1_ = tabBarHeight;
         measuredMinHeight = measuredMinHeight + _loc1_;
         measuredHeight = measuredHeight + _loc1_;
         var _loc2_:Number = getStyle("tabWidth");
         if(isNaN(_loc2_))
         {
            _loc2_ = 0;
         }
         var _loc3_:Number = numChildren * Math.max(_loc2_,MIN_TAB_WIDTH);
         var _loc4_:EdgeMetrics = viewMetrics;
         _loc3_ = _loc3_ + (_loc4_.left + _loc4_.right);
         if(numChildren > 1)
         {
            _loc3_ = _loc3_ + getStyle("horizontalGap") * (numChildren - 1);
         }
         if(measuredWidth < _loc3_)
         {
            measuredWidth = _loc3_;
         }
         if(selectedChild && Container(selectedChild).numChildrenCreated == -1)
         {
            return;
         }
         if(numChildren == 0)
         {
            return;
         }
         vsMinWidth = measuredMinWidth;
         vsMinHeight = measuredMinHeight;
         vsPreferredWidth = measuredWidth;
         vsPreferredHeight = measuredHeight;
      }
      
      protected function get tabBarStyleFilters() : Object
      {
         return _tabBarStyleFilters;
      }
      
      override protected function keyDownHandler(param1:KeyboardEvent) : void
      {
         if(focusManager.getFocus() == this)
         {
            tabBar.dispatchEvent(param1);
         }
      }
      
      override protected function focusInHandler(param1:FocusEvent) : void
      {
         super.focusInHandler(param1);
         if(param1.target == this)
         {
            focusManager.defaultButtonEnabled = false;
         }
      }
      
      public function getTabAt(param1:int) : Button
      {
         return Button(tabBar.getChildAt(param1));
      }
      
      override public function drawFocus(param1:Boolean) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         super.drawFocus(param1);
         if(!parent)
         {
            return;
         }
         var _loc2_:DisplayObject = IUIComponent(parent).focusPane;
         if(param1 && !isEffectStarted)
         {
            if(_loc2_)
            {
               if(parent is Container)
               {
                  _loc3_ = Container(parent).rawChildren.numChildren;
                  _loc4_ = Container(parent).firstChildIndex;
                  Container(parent).rawChildren.setChildIndex(_loc2_,Math.max(0,_loc4_ == _loc3_?Number(_loc3_ - 1):Number(_loc4_)));
               }
               else
               {
                  parent.setChildIndex(_loc2_,0);
               }
            }
         }
         else if(_loc2_)
         {
            if(parent is Container)
            {
               Container(parent).rawChildren.setChildIndex(_loc2_,Container(parent).rawChildren.numChildren - 1);
            }
            else
            {
               parent.setChildIndex(_loc2_,parent.numChildren - 1);
            }
         }
         tabBar.drawFocus(param1);
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         super.updateDisplayList(param1,param2);
         var _loc3_:EdgeMetrics = borderMetrics;
         var _loc4_:EdgeMetrics = viewMetrics;
         var _loc5_:Number = param1 - _loc4_.left - _loc4_.right;
         var _loc6_:Number = tabBarHeight + _loc3_.top;
         var _loc7_:Number = tabBar.getExplicitOrMeasuredWidth();
         tabBar.setActualSize(Math.min(_loc5_,_loc7_),_loc6_);
         var _loc8_:Number = getStyle("tabOffset");
         switch(getStyle("horizontalAlign"))
         {
            case "left":
               tabBar.move(0 + _loc8_,tabBar.y);
               break;
            case "right":
               tabBar.move(param1 - tabBar.width + _loc8_,tabBar.y);
               break;
            case "center":
               tabBar.move((param1 - tabBar.width) / 2 + _loc8_,tabBar.y);
         }
      }
   }
}
