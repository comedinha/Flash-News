package tibia.game.contextMenuClasses
{
   import mx.core.UIComponent;
   import flash.display.DisplayObject;
   import shared.controls.ShapeWrapper;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import mx.core.EdgeMetrics;
   import mx.core.UITextField;
   import flash.events.ContextMenuEvent;
   
   public class TextItem extends UIComponent implements IContextMenuItem
   {
       
      
      private var m_ExplicitIconWidth:Number = NaN;
      
      private var m_IconWidth:Number = NaN;
      
      private var m_UncommittedCaption:Boolean = false;
      
      private var m_UICaption:UITextField = null;
      
      private var m_MouseOver:Boolean = false;
      
      private var m_UncommittedIcon:Boolean = false;
      
      private var m_Icon = null;
      
      private var m_Caption:String = null;
      
      private var m_MeasuredIconWidth:Number = NaN;
      
      private var m_UIIcon:UIComponent = null;
      
      public function TextItem()
      {
         super();
         addEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
         addEventListener(MouseEvent.CLICK,this.onMouseClick);
         addEventListener(MouseEvent.RIGHT_CLICK,this.onMouseClick);
         addEventListener(MouseEvent.ROLL_OUT,this.onMouseOver);
         addEventListener(MouseEvent.ROLL_OVER,this.onMouseOver);
      }
      
      public function set explicitIconWidth(param1:Number) : void
      {
         if(this.m_ExplicitIconWidth != param1)
         {
            this.m_ExplicitIconWidth = param1;
            invalidateSize();
         }
      }
      
      public function get explicitIconWidth() : Number
      {
         return this.m_ExplicitIconWidth;
      }
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
         if(this.m_UncommittedCaption)
         {
            this.m_UICaption.text = this.caption;
            this.m_UncommittedCaption = false;
         }
         if(this.m_UncommittedIcon)
         {
            if(this.m_UIIcon != null)
            {
               removeChild(this.m_UIIcon);
               this.m_UIIcon = null;
            }
            if(this.icon is UIComponent)
            {
               this.m_UIIcon = UIComponent(this.icon);
            }
            else if(this.icon is DisplayObject)
            {
               this.m_UIIcon = new ShapeWrapper();
               this.m_UIIcon.addChild(DisplayObject(this.icon));
            }
            if(this.m_UIIcon != null)
            {
               addChildAt(this.m_UIIcon,0);
            }
            this.m_UncommittedIcon = false;
         }
      }
      
      private function onRemovedFromStage(param1:Event) : void
      {
         removeEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
         removeEventListener(MouseEvent.CLICK,this.onMouseClick);
         removeEventListener(MouseEvent.RIGHT_CLICK,this.onMouseClick);
         removeEventListener(MouseEvent.ROLL_OUT,this.onMouseOver);
         removeEventListener(MouseEvent.ROLL_OVER,this.onMouseOver);
      }
      
      public function set caption(param1:String) : void
      {
         if(param1 != this.m_Caption)
         {
            this.m_Caption = param1;
            this.m_UncommittedCaption = true;
            invalidateProperties();
            invalidateSize();
         }
      }
      
      public function get iconWidth() : Number
      {
         return this.m_IconWidth;
      }
      
      public function set iconWidth(param1:Number) : void
      {
         if(this.explicitIconWidth != param1)
         {
            this.explicitIconWidth = param1;
            invalidateSize();
         }
         if(this.m_IconWidth != param1)
         {
            this.m_IconWidth = param1;
            invalidateDisplayList();
            invalidateSize();
         }
      }
      
      public function set measuredIconWidth(param1:Number) : void
      {
         this.m_MeasuredIconWidth = param1;
      }
      
      public function get viewMetrics() : EdgeMetrics
      {
         return new EdgeMetrics();
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this.m_UICaption = new UITextField();
         addChild(this.m_UICaption);
      }
      
      override protected function measure() : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         super.measure();
         var _loc1_:Number = !isNaN(this.m_UICaption.explicitMinWidth)?Number(this.m_UICaption.explicitMinWidth):Number(this.m_UICaption.measuredMinWidth);
         var _loc2_:Number = this.m_UICaption.getExplicitOrMeasuredWidth();
         _loc3_ = !isNaN(this.m_UICaption.explicitMinHeight)?Number(this.m_UICaption.explicitMinHeight):Number(this.m_UICaption.measuredMinHeight);
         _loc4_ = this.m_UICaption.getExplicitOrMeasuredHeight();
         if(this.m_UIIcon != null)
         {
            this.measuredIconWidth = this.m_UIIcon.getExplicitOrMeasuredWidth();
            _loc1_ = _loc1_ + (!isNaN(this.m_UIIcon.explicitMinWidth)?this.m_UIIcon.explicitMinWidth:this.m_UIIcon.measuredMinWidth);
            _loc2_ = _loc2_ + this.measuredIconWidth;
            _loc3_ = Math.max(_loc3_,!isNaN(this.m_UIIcon.explicitMinHeight)?Number(this.m_UIIcon.explicitMinHeight):Number(this.m_UIIcon.measuredMinHeight));
            _loc4_ = Math.max(_loc4_,this.m_UIIcon.getExplicitOrMeasuredHeight());
         }
         else
         {
            this.measuredIconWidth = 0;
         }
         var _loc5_:EdgeMetrics = this.viewMetricsAndPadding;
         measuredMinWidth = _loc5_.left + _loc1_ + _loc5_.right;
         measuredWidth = _loc5_.left + _loc2_ + _loc5_.right;
         measuredMinHeight = _loc5_.top + _loc3_ + _loc5_.bottom;
         measuredHeight = _loc5_.top + _loc4_ + _loc5_.bottom;
      }
      
      public function get caption() : String
      {
         return this.m_Caption;
      }
      
      private function onMouseClick(param1:MouseEvent) : void
      {
         var _loc2_:ContextMenuEvent = new ContextMenuEvent(ContextMenuEvent.MENU_ITEM_SELECT);
         _loc2_.mouseTarget = this;
         _loc2_.contextMenuOwner = owner;
         dispatchEvent(_loc2_);
      }
      
      public function get measuredIconWidth() : Number
      {
         return this.m_MeasuredIconWidth;
      }
      
      public function set icon(param1:*) : void
      {
         if(param1 != this.m_Icon)
         {
            this.m_Icon = param1;
            this.m_UncommittedIcon = true;
            invalidateProperties();
            invalidateSize();
         }
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         super.updateDisplayList(param1,param2);
         graphics.clear();
         if(this.m_MouseOver)
         {
            graphics.beginFill(getStyle("rollOverColor"),getStyle("rollOverAlpha"));
            graphics.drawRect(0,0,param1,param2);
            graphics.endFill();
            this.m_UICaption.setColor(getStyle("textRollOverColor"));
         }
         else
         {
            this.m_UICaption.setColor(getStyle("textColor"));
         }
         var _loc3_:EdgeMetrics = this.viewMetricsAndPadding;
         param1 = param1 - (_loc3_.left + _loc3_.right);
         param2 = param2 - (_loc3_.top + _loc3_.bottom);
         var _loc4_:Number = 0;
         var _loc5_:Number = _loc3_.left;
         var _loc6_:Number = 0;
         if(this.iconWidth > 0 && this.m_UIIcon != null)
         {
            _loc6_ = this.m_UIIcon.getExplicitOrMeasuredWidth();
            _loc4_ = this.m_UIIcon.getExplicitOrMeasuredHeight();
            this.m_UIIcon.move(_loc5_ + (this.iconWidth - _loc6_) / 2,_loc3_.top + (param2 - _loc4_) / 2);
            this.m_UIIcon.setActualSize(_loc6_,_loc4_);
         }
         if(this.iconWidth > 0)
         {
            _loc6_ = this.iconWidth + getStyle("horizontalGap");
            _loc5_ = _loc5_ + _loc6_;
            param1 = param1 - _loc6_;
         }
         _loc4_ = this.m_UICaption.getExplicitOrMeasuredHeight();
         this.m_UICaption.move(_loc5_,_loc3_.top + (param2 - _loc4_) / 2);
         this.m_UICaption.setActualSize(param1,_loc4_);
      }
      
      public function get viewMetricsAndPadding() : EdgeMetrics
      {
         var _loc1_:EdgeMetrics = this.viewMetrics.clone();
         _loc1_.bottom = _loc1_.bottom + getStyle("paddingBottom");
         _loc1_.left = _loc1_.left + getStyle("paddingLeft");
         _loc1_.right = _loc1_.right + getStyle("paddingRight");
         _loc1_.top = _loc1_.top + getStyle("paddingTop");
         return _loc1_;
      }
      
      public function get icon() : *
      {
         return this.m_Icon;
      }
      
      private function onMouseOver(param1:MouseEvent) : void
      {
         this.m_MouseOver = param1.type == MouseEvent.ROLL_OVER;
         invalidateDisplayList();
      }
   }
}
