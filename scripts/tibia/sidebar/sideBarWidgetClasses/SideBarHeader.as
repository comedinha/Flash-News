package tibia.sidebar.sideBarWidgetClasses
{
   import mx.core.Container;
   import tibia.sidebar.Widget;
   import tibia.sidebar.SideBarSet;
   import flash.events.MouseEvent;
   import mx.controls.Button;
   import mx.events.PropertyChangeEvent;
   import shared.controls.CustomButton;
   import mx.core.EventPriority;
   import mx.core.mx_internal;
   import tibia.sidebar.SideBar;
   import mx.core.EdgeMetrics;
   import mx.core.IBorder;
   import mx.core.ScrollPolicy;
   
   public class SideBarHeader extends Container
   {
      
      protected static const DEFAULT_WIDGET_HEIGHT:Number = 200;
      
      protected static const DEFAULT_WIDGET_WIDTH:Number = 184;
      
      private static const BUNDLE:String = "SideBarHeader";
      
      private static const COMPONENT_DEFINITIONS:Array = [{
         "toolTip":"TIP_GENERAL",
         "type":Widget.TYPE_GENERALBUTTONS,
         "styleName":"buttonGeneralStyle",
         "left":6,
         "top":19
      },{
         "toolTip":"TIP_COMBAT",
         "type":Widget.TYPE_COMBATCONTROL,
         "styleName":"buttonCombatStyle",
         "left":18,
         "top":4
      },{
         "toolTip":"TIP_MINIMAP",
         "type":Widget.TYPE_MINIMAP,
         "styleName":"buttonMinimapStyle",
         "left":42,
         "top":19
      },{
         "toolTip":"TIP_CONTAINER",
         "type":Widget.TYPE_CONTAINER,
         "styleName":"buttonContainerStyle",
         "left":126,
         "top":4
      },{
         "toolTip":"TIP_BODY",
         "type":Widget.TYPE_BODY,
         "styleName":"buttonBodyStyle",
         "left":54,
         "top":4
      },{
         "toolTip":"TIP_BATTLELIST",
         "type":Widget.TYPE_BATTLELIST,
         "styleName":"buttonBattlelistStyle",
         "left":90,
         "top":4
      },{
         "toolTip":"TIP_BUDDYLIST",
         "type":Widget.TYPE_BUDDYLIST,
         "styleName":"buttonBuddylistStyle",
         "left":78,
         "top":19
      },{
         "toolTip":"TIP_TRADE",
         "type":Widget.TYPE_NPCTRADE,
         "styleName":"buttonTradeStyle",
         "left":114,
         "top":19
      },{
         "toolTip":"TIP_UNJUSTPOINTS",
         "type":Widget.TYPE_UNJUSTPOINTS,
         "styleName":"buttonUnjustPointsStyle",
         "left":148,
         "top":19
      }];
       
      
      private var m_UIFoldButton:Button = null;
      
      private var m_UncommittedLocation:Boolean = false;
      
      private var m_Location:int = -1;
      
      private var m_Fold:Boolean = false;
      
      private var m_UncommittedSideBarSet:Boolean = false;
      
      private var m_SideBarSet:SideBarSet = null;
      
      private var m_UncommittedFold:Boolean = false;
      
      public function SideBarHeader()
      {
         super();
         horizontalScrollPolicy = ScrollPolicy.OFF;
         verticalScrollPolicy = ScrollPolicy.OFF;
      }
      
      public function get fold() : Boolean
      {
         return this.m_Fold;
      }
      
      public function set fold(param1:Boolean) : void
      {
         if(this.m_Fold != param1)
         {
            this.m_Fold = param1;
            this.m_UncommittedFold = true;
            invalidateDisplayList();
            invalidateProperties();
            invalidateSize();
         }
      }
      
      public function get sideBarSet() : SideBarSet
      {
         return this.m_SideBarSet;
      }
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
         if(this.m_UncommittedLocation || this.m_UncommittedSideBarSet)
         {
            this.updateWidgetButtons();
            if(this.sideBar != null)
            {
               this.fold = this.sideBar.foldHeader;
            }
            this.m_UncommittedLocation = false;
            this.m_UncommittedSideBarSet = false;
         }
         if(this.m_UncommittedFold)
         {
            this.m_UIFoldButton.selected = this.fold;
            this.m_UncommittedFold = false;
         }
      }
      
      private function onWidgetButtonClick(param1:MouseEvent) : void
      {
         var _loc3_:int = 0;
         var _loc2_:Button = null;
         if(param1 != null && (_loc2_ = param1.currentTarget as Button) != null && this.sideBarSet != null)
         {
            param1.preventDefault();
            param1.stopImmediatePropagation();
            _loc3_ = int(_loc2_.data);
            if(!Widget.s_GetUnique(_loc3_))
            {
               this.sideBarSet.setDefaultLocation(_loc3_,this.location);
            }
            else if(this.sideBarSet.countWidgetType(_loc3_,this.location) > 0)
            {
               this.sideBarSet.hideWidgetType(_loc3_,this.location);
            }
            else
            {
               this.sideBarSet.showWidgetType(_loc3_,this.location,-1);
            }
         }
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         var _loc6_:Button = null;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Object = null;
         layoutChrome(param1,param2);
         var _loc3_:Number = 0;
         var _loc4_:Number = 0;
         var _loc5_:int = numChildren - 1;
         while(_loc5_ >= 0)
         {
            _loc6_ = getChildAt(_loc5_) as Button;
            if(_loc6_ != null)
            {
               _loc7_ = 0;
               _loc8_ = 0;
               for each(_loc9_ in COMPONENT_DEFINITIONS)
               {
                  if(_loc6_.data == _loc9_.type)
                  {
                     _loc7_ = _loc9_.left;
                     _loc8_ = _loc9_.top;
                     break;
                  }
               }
               _loc3_ = _loc6_.getExplicitOrMeasuredWidth();
               _loc4_ = _loc6_.getExplicitOrMeasuredHeight();
               _loc6_.move(_loc7_,_loc8_);
               _loc6_.setActualSize(_loc3_,_loc4_);
            }
            _loc5_--;
         }
         _loc3_ = this.m_UIFoldButton.getExplicitOrMeasuredWidth();
         _loc4_ = this.m_UIFoldButton.getExplicitOrMeasuredHeight();
         this.m_UIFoldButton.move(Math.round((param1 - _loc3_) / 2),param2 - _loc4_);
         this.m_UIFoldButton.setActualSize(_loc3_,_loc4_);
      }
      
      public function set sideBarSet(param1:SideBarSet) : void
      {
         if(this.m_SideBarSet != param1)
         {
            if(this.m_SideBarSet != null)
            {
               this.m_SideBarSet.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onSideBarSetChange);
            }
            this.m_SideBarSet = param1;
            this.m_UncommittedSideBarSet = true;
            invalidateProperties();
            if(this.m_SideBarSet != null)
            {
               this.m_SideBarSet.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onSideBarSetChange);
            }
         }
      }
      
      protected function updateWidgetButtons() : void
      {
         var _loc2_:Button = null;
         var _loc3_:int = 0;
         var _loc1_:int = numChildren - 1;
         while(_loc1_ >= 0)
         {
            _loc2_ = getChildAt(_loc1_) as Button;
            if(_loc2_ != null)
            {
               _loc3_ = int(_loc2_.data);
               if(this.sideBarSet == null)
               {
                  _loc2_.selected = false;
               }
               else if(!Widget.s_GetUnique(_loc3_))
               {
                  _loc2_.selected = this.sideBarSet.getDefaultLocation(_loc3_) == this.location;
               }
               else
               {
                  _loc2_.selected = this.sideBarSet.countWidgetType(_loc3_,this.location) > 0;
               }
            }
            _loc1_--;
         }
      }
      
      private function onSideBarSetChange(param1:PropertyChangeEvent) : void
      {
         if(param1.property == "defaultLocation" || param1.property == "sideBarInstanceOptions")
         {
            this.updateWidgetButtons();
            if(this.sideBar != null)
            {
               this.fold = this.sideBar.foldHeader;
            }
         }
      }
      
      private function onFoldButtonClick(param1:MouseEvent) : void
      {
         if(this.sideBar != null)
         {
            this.sideBar.foldHeader = !this.sideBar.foldHeader;
         }
      }
      
      override protected function createChildren() : void
      {
         var _loc1_:Object = null;
         var _loc2_:Button = null;
         super.createChildren();
         this.m_UIFoldButton = new CustomButton();
         this.m_UIFoldButton.selected = this.fold;
         this.m_UIFoldButton.styleName = getStyle("foldButtonStyleName");
         this.m_UIFoldButton.toggle = true;
         this.m_UIFoldButton.addEventListener(MouseEvent.CLICK,this.onFoldButtonClick);
         rawChildren.addChild(this.m_UIFoldButton);
         for each(_loc1_ in COMPONENT_DEFINITIONS)
         {
            _loc2_ = new CustomButton();
            _loc2_.data = _loc1_.type;
            _loc2_.styleName = getStyle(_loc1_.styleName);
            _loc2_.toggle = true;
            _loc2_.toolTip = resourceManager.getString(BUNDLE,_loc1_.toolTip);
            _loc2_.addEventListener(MouseEvent.CLICK,this.onWidgetButtonClick,false,EventPriority.DEFAULT + 1,false);
            addChild(_loc2_);
         }
      }
      
      override protected function measure() : void
      {
         var _loc2_:Number = NaN;
         var _loc1_:Number = 0;
         _loc2_ = 0;
         if(mx_internal::border != null)
         {
            if(!isNaN(mx_internal::border.measuredWidth))
            {
               _loc1_ = mx_internal::border.measuredWidth;
            }
            if(!isNaN(mx_internal::border.measuredHeight))
            {
               _loc2_ = mx_internal::border.measuredHeight;
            }
         }
         measuredMinWidth = measuredWidth = _loc1_;
         if(this.fold)
         {
            measuredMinHeight = measuredHeight = Math.max(viewMetrics.bottom,this.m_UIFoldButton.getExplicitOrMeasuredHeight());
         }
         else
         {
            measuredMinHeight = measuredHeight = _loc2_;
         }
      }
      
      public function set location(param1:int) : void
      {
         if(this.m_Location != param1)
         {
            this.m_Location = param1;
            this.m_UncommittedLocation = true;
            invalidateProperties();
         }
      }
      
      public function get location() : int
      {
         return this.m_Location;
      }
      
      protected function get sideBar() : SideBar
      {
         if(this.sideBarSet != null)
         {
            return this.sideBarSet.getSideBar(this.location);
         }
         return null;
      }
      
      override public function get borderMetrics() : EdgeMetrics
      {
         if(mx_internal::border is IBorder)
         {
            return IBorder(mx_internal::border).borderMetrics;
         }
         return super.borderMetrics;
      }
   }
}
