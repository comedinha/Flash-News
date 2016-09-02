package tibia.controls.dynamicTabBarClasses
{
   import mx.controls.tabBarClasses.Tab;
   import mx.styles.CSSStyleDeclaration;
   import mx.styles.StyleManager;
   import flash.events.MouseEvent;
   import mx.controls.Button;
   import tibia.controls.DynamicTabBar;
   import shared.controls.CustomButton;
   import flash.events.Event;
   
   public class DynamicTab extends Tab
   {
      
      {
         s_InitializeStyle();
      }
      
      protected var m_UICloseButton:Button = null;
      
      protected var m_IsEnabled:Boolean = false;
      
      private var m_UncommittedSelected:Boolean = false;
      
      protected var m_IsSelected:Boolean = false;
      
      protected var m_ClosePolicy:int;
      
      protected var m_IsRollOver:Boolean = false;
      
      private var m_UncommittedEnabled:Boolean = false;
      
      private var m_UncommittedClosePolicy:Boolean = false;
      
      private var m_UIConstructed:Boolean = false;
      
      public function DynamicTab()
      {
         this.m_ClosePolicy = DynamicTabBar.CLOSE_NEVER;
         super();
         mouseChildren = true;
         mouseEnabled = true;
      }
      
      private static function s_InitializeStyle() : void
      {
         var Selector:String = ".defaultCloseButtonStyle";
         var Decl:CSSStyleDeclaration = StyleManager.getStyleDeclaration(Selector);
         if(Decl == null)
         {
            Decl = new CSSStyleDeclaration();
         }
         Decl.defaultFactory = function():void
         {
            this.disabledSkin = null;
            this.downSkin = null;
            this.overSkin = null;
            this.upSkin = null;
         };
         StyleManager.setStyleDeclaration(Selector,Decl,false);
         Selector = "DynamicTab";
         Decl = StyleManager.getStyleDeclaration(Selector);
         if(Decl == null)
         {
            Decl = new CSSStyleDeclaration();
         }
         Decl.defaultFactory = function():void
         {
            this.closeButtonRight = 4;
            this.closeButtonStyle = "defaultCloseButtonStyle";
            this.closeButtonTop = 4;
         };
         StyleManager.setStyleDeclaration(Selector,Decl,true);
      }
      
      override protected function rollOutHandler(param1:MouseEvent) : void
      {
         if(param1 != null && enabled)
         {
            this.m_IsRollOver = false;
            super.rollOutHandler(param1);
         }
      }
      
      override public function set enabled(param1:Boolean) : void
      {
         if(enabled != param1)
         {
            super.enabled = param1;
            this.m_UncommittedEnabled = true;
            invalidateProperties();
         }
      }
      
      override public function styleChanged(param1:String) : void
      {
         switch(param1)
         {
            case "closeButtonStyle":
               this.m_UICloseButton.styleName = this.getStyle("closeButtonStyle");
               break;
            case "closeButtonRight":
            case "closeButtonTop":
               invalidateSize();
               invalidateDisplayList();
               break;
            case "defaultTextColor":
            case "selectedTextColor":
               this.updateTextColor();
               break;
            default:
               super.styleChanged(param1);
         }
      }
      
      public function get closePolicy() : int
      {
         return this.m_ClosePolicy;
      }
      
      public function set closePolicy(param1:int) : void
      {
         if(param1 != DynamicTabBar.CLOSE_ALWAYS && param1 != DynamicTabBar.CLOSE_NEVER && param1 != DynamicTabBar.CLOSE_ROLLOVER && param1 != DynamicTabBar.CLOSE_SELECTED)
         {
            param1 = DynamicTabBar.CLOSE_NEVER;
         }
         if(this.m_ClosePolicy != param1)
         {
            this.m_ClosePolicy = param1;
            this.m_UncommittedClosePolicy = true;
            invalidateDisplayList();
            invalidateProperties();
            invalidateSize();
         }
      }
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
         if(this.m_UncommittedClosePolicy)
         {
            this.m_UncommittedClosePolicy = false;
         }
         if(this.m_UncommittedEnabled && this.m_UICloseButton != null)
         {
            this.m_UICloseButton.enabled = enabled;
            this.m_UncommittedEnabled = false;
         }
         if(this.m_UncommittedSelected)
         {
            this.updateTextColor();
            this.m_UncommittedSelected = false;
         }
      }
      
      override protected function createChildren() : void
      {
         if(!this.m_UIConstructed)
         {
            super.createChildren();
            this.m_UICloseButton = new CustomButton();
            this.m_UICloseButton.enabled = enabled;
            this.m_UICloseButton.styleName = this.getStyle("closeButtonStyle");
            this.m_UICloseButton.addEventListener(MouseEvent.CLICK,this.onCloseButtonEvent);
            this.m_UICloseButton.addEventListener(MouseEvent.MOUSE_DOWN,this.onCloseButtonEvent);
            addChild(this.m_UICloseButton);
            this.updateTextColor();
            this.m_UIConstructed = true;
         }
      }
      
      override protected function measure() : void
      {
         var _loc1_:Number = NaN;
         super.measure();
         _loc1_ = this.m_UICloseButton.getExplicitOrMeasuredHeight() + this.getStyle("closeButtonTop");
         var _loc2_:Number = this.m_UICloseButton.getExplicitOrMeasuredWidth() + this.getStyle("closeButtonRight");
         if(this.m_ClosePolicy == DynamicTabBar.CLOSE_ALWAYS || this.m_ClosePolicy == DynamicTabBar.CLOSE_SELECTED)
         {
            measuredWidth = measuredWidth + _loc2_;
            measuredMinWidth = measuredMinWidth + _loc2_;
         }
         else if(this.m_ClosePolicy == DynamicTabBar.CLOSE_ROLLOVER)
         {
            measuredWidth = Math.max(measuredWidth,_loc2_);
            measuredMinWidth = Math.max(measuredMinWidth,_loc2_);
         }
         measuredHeight = Math.max(measuredHeight,_loc1_);
         measuredMinHeight = Math.max(measuredMinHeight,_loc1_);
      }
      
      override protected function clickHandler(param1:MouseEvent) : void
      {
         if(param1 != null && !enabled)
         {
            param1.stopPropagation();
            param1.stopImmediatePropagation();
         }
      }
      
      override protected function rollOverHandler(param1:MouseEvent) : void
      {
         if(param1 != null && enabled)
         {
            this.m_IsRollOver = true;
            super.rollOverHandler(param1);
         }
      }
      
      protected function onCloseButtonEvent(param1:MouseEvent) : void
      {
         var _loc2_:Event = null;
         if(param1 != null)
         {
            switch(param1.type)
            {
               case MouseEvent.CLICK:
                  if(enabled && this.closePolicy != DynamicTabBar.CLOSE_NEVER && (this.closePolicy != DynamicTabBar.CLOSE_SELECTED || selected) && (this.closePolicy != DynamicTabBar.CLOSE_ROLLOVER || this.m_IsRollOver) && this.m_IsEnabled == enabled && this.m_IsSelected == selected)
                  {
                     _loc2_ = new Event(Event.CLOSE,false,true);
                     dispatchEvent(_loc2_);
                     if(!_loc2_.cancelable || !_loc2_.isDefaultPrevented())
                     {
                        this.m_UICloseButton.removeEventListener(MouseEvent.CLICK,this.onCloseButtonEvent);
                        this.m_UICloseButton.removeEventListener(MouseEvent.MOUSE_DOWN,this.onCloseButtonEvent);
                     }
                  }
                  break;
               case MouseEvent.MOUSE_DOWN:
                  this.m_IsEnabled = enabled;
                  this.m_IsSelected = selected;
            }
         }
      }
      
      protected function updateTextColor() : void
      {
         var _loc1_:* = undefined;
         if(selected)
         {
            _loc1_ = this.getStyle("selectedTextColor");
         }
         else
         {
            _loc1_ = this.getStyle("defaultTextColor");
         }
         setStyle("color",_loc1_);
         setStyle("errorColor",_loc1_);
         setStyle("textRollOverColor",_loc1_);
         setStyle("textSelectedColor",_loc1_);
      }
      
      override public function set selected(param1:Boolean) : void
      {
         if(selected != param1)
         {
            super.selected = param1;
            this.m_UncommittedSelected = true;
            invalidateProperties();
         }
      }
      
      override public function getStyle(param1:String) : *
      {
         var _loc2_:Number = NaN;
         switch(param1)
         {
            case "paddingRight":
               _loc2_ = super.getStyle("paddingRight");
               if(this.m_ClosePolicy == DynamicTabBar.CLOSE_ALWAYS || this.m_ClosePolicy == DynamicTabBar.CLOSE_SELECTED)
               {
                  _loc2_ = _loc2_ + (this.m_UICloseButton.getExplicitOrMeasuredWidth() + this.getStyle("closeButtonRight"));
               }
               return _loc2_;
            default:
               return super.getStyle(param1);
         }
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         super.updateDisplayList(param1,param2);
         setChildIndex(this.m_UICloseButton,numChildren - 1);
         if(this.m_ClosePolicy == DynamicTabBar.CLOSE_ALWAYS || this.m_ClosePolicy == DynamicTabBar.CLOSE_SELECTED && selected || this.m_ClosePolicy == DynamicTabBar.CLOSE_ROLLOVER && this.m_IsRollOver)
         {
            _loc3_ = this.m_UICloseButton.getExplicitOrMeasuredWidth();
            _loc4_ = this.m_UICloseButton.getExplicitOrMeasuredHeight();
            _loc5_ = this.getStyle("closeButtonRight");
            _loc6_ = this.getStyle("closeButtonTop");
            this.m_UICloseButton.visible = true;
            this.m_UICloseButton.move(param1 - _loc3_ - _loc5_,_loc6_);
            this.m_UICloseButton.setActualSize(_loc3_,_loc4_);
         }
         else
         {
            this.m_UICloseButton.visible = false;
         }
      }
   }
}
