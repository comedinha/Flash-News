package tibia.minimap.editMarkWidgetClasses
{
   import mx.core.UIComponent;
   import mx.styles.CSSStyleDeclaration;
   import mx.styles.StyleManager;
   import mx.events.PropertyChangeEvent;
   import tibia.minimap.MiniMapStorage;
   import mx.events.PropertyChangeEventKind;
   import flash.events.MouseEvent;
   import flash.events.Event;
   
   public class MarkIconChooser extends UIComponent
   {
      
      {
         s_InitializeStyle();
      }
      
      private var m_UncommittedSelectedIcon:Boolean = false;
      
      protected var m_SelectedIcon:int = 0;
      
      protected var m_UIRenderer:Vector.<tibia.minimap.editMarkWidgetClasses.MarkIconRenderer> = null;
      
      public function MarkIconChooser()
      {
         super();
      }
      
      private static function s_InitializeStyle() : void
      {
         var Decl:CSSStyleDeclaration = StyleManager.getStyleDeclaration("MarkIconChooser");
         if(Decl == null)
         {
            Decl = new CSSStyleDeclaration();
         }
         Decl.defaultFactory = function():void
         {
            this.horizontalGap = 2;
            this.verticalGap = 2;
            this.paddingLeft = 0;
            this.paddingRight = 0;
            this.paddingTop = 0;
            this.paddingBottom = 0;
         };
         StyleManager.setStyleDeclaration("MarkIconChooser",Decl,true);
      }
      
      public function set selectedIcon(param1:int) : void
      {
         var _loc2_:int = 0;
         var _loc3_:PropertyChangeEvent = null;
         param1 = Math.max(-1,Math.min(param1,MiniMapStorage.MARK_ICON_COUNT - 1));
         if(this.m_SelectedIcon != param1)
         {
            _loc2_ = this.m_SelectedIcon;
            this.m_SelectedIcon = param1;
            this.m_UncommittedSelectedIcon = true;
            invalidateProperties();
            _loc3_ = new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE);
            _loc3_.kind = PropertyChangeEventKind.UPDATE;
            _loc3_.property = "selectedIcon";
            _loc3_.oldValue = _loc2_;
            _loc3_.newValue = this.m_SelectedIcon;
            dispatchEvent(_loc3_);
         }
      }
      
      override protected function commitProperties() : void
      {
         var _loc1_:int = 0;
         super.commitProperties();
         if(this.m_UncommittedSelectedIcon)
         {
            _loc1_ = this.m_UIRenderer.length - 1;
            while(_loc1_ >= 0)
            {
               this.m_UIRenderer[_loc1_].highlight = this.m_UIRenderer[_loc1_].ID == this.m_SelectedIcon;
               _loc1_--;
            }
            this.m_UncommittedSelectedIcon = false;
         }
      }
      
      public function get selectedIcon() : int
      {
         return this.m_SelectedIcon;
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         super.updateDisplayList(param1,param2);
         var _loc3_:Number = getStyle("paddingLeft");
         var _loc4_:Number = getStyle("paddingTop");
         var _loc5_:Number = getStyle("horizontalGap");
         var _loc6_:Number = getStyle("verticalGap");
         var _loc7_:Number = 0;
         var _loc8_:Number = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:tibia.minimap.editMarkWidgetClasses.MarkIconRenderer = null;
         _loc9_ = 0;
         _loc10_ = this.m_UIRenderer.length;
         while(_loc9_ < _loc10_)
         {
            _loc12_ = this.m_UIRenderer[_loc9_];
            _loc8_ = Math.max(_loc8_,_loc12_.getExplicitOrMeasuredHeight());
            _loc7_ = Math.max(_loc7_,_loc12_.getExplicitOrMeasuredWidth());
            _loc9_++;
         }
         _loc9_ = 0;
         _loc10_ = this.m_UIRenderer.length;
         _loc11_ = Math.round(_loc10_ / 2);
         while(_loc9_ < _loc10_)
         {
            _loc12_ = this.m_UIRenderer[_loc9_];
            _loc12_.move(_loc3_ + _loc9_ % _loc11_ * (_loc7_ + _loc5_),_loc4_ + Math.floor(_loc9_ / _loc11_) * (_loc8_ + _loc6_));
            _loc12_.setActualSize(_loc7_,_loc8_);
            _loc9_++;
         }
      }
      
      override protected function createChildren() : void
      {
         var _loc1_:int = 0;
         super.createChildren();
         if(this.m_UIRenderer == null)
         {
            this.m_UIRenderer = new Vector.<tibia.minimap.editMarkWidgetClasses.MarkIconRenderer>(MiniMapStorage.MARK_ICON_COUNT,true);
            _loc1_ = 0;
            while(_loc1_ < this.m_UIRenderer.length)
            {
               this.m_UIRenderer[_loc1_] = new tibia.minimap.editMarkWidgetClasses.MarkIconRenderer();
               this.m_UIRenderer[_loc1_].ID = _loc1_;
               this.m_UIRenderer[_loc1_].highlight = _loc1_ == this.m_SelectedIcon;
               this.m_UIRenderer[_loc1_].styleName = "withBackground";
               this.m_UIRenderer[_loc1_].addEventListener(MouseEvent.MOUSE_DOWN,this.onSelectionChange);
               addChild(this.m_UIRenderer[_loc1_]);
               _loc1_++;
            }
         }
      }
      
      protected function onSelectionChange(param1:Event) : void
      {
         if(param1 != null)
         {
            this.selectedIcon = MarkIconRenderer(param1.currentTarget).ID;
         }
      }
      
      override protected function measure() : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:tibia.minimap.editMarkWidgetClasses.MarkIconRenderer = null;
         super.measure();
         var _loc1_:Number = 0;
         _loc2_ = 0;
         if(this.m_UIRenderer.length > 1)
         {
            _loc3_ = this.m_UIRenderer.length - 1;
            while(_loc3_ >= 0)
            {
               _loc5_ = this.m_UIRenderer[_loc3_];
               _loc2_ = Math.max(_loc2_,_loc5_.getExplicitOrMeasuredHeight());
               _loc1_ = Math.max(_loc1_,_loc5_.getExplicitOrMeasuredWidth());
               _loc3_--;
            }
            _loc4_ = Math.ceil(this.m_UIRenderer.length / 2);
            _loc2_ = 2 * _loc2_ + getStyle("verticalGap");
            _loc1_ = _loc4_ * _loc1_ + (_loc4_ - 1) * getStyle("horizontalGap");
         }
         measuredMinWidth = measuredWidth = getStyle("paddingLeft") + _loc1_ + getStyle("paddingRight");
         measuredMinHeight = measuredHeight = getStyle("paddingTop") + _loc2_ + getStyle("paddingBottom");
      }
   }
}
