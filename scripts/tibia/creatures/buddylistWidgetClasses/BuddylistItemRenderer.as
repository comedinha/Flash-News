package tibia.creatures.buddylistWidgetClasses
{
   import mx.core.UIComponent;
   import mx.controls.listClasses.IListItemRenderer;
   import mx.core.IDataRenderer;
   import mx.styles.CSSStyleDeclaration;
   import mx.styles.StyleManager;
   import shared.utility.TextFieldCache;
   import flash.geom.Matrix;
   import tibia.§creatures:ns_creature_internal§.s_NameCache;
   import tibia.§creatures:ns_creature_internal§.s_Trans;
   import flash.geom.Rectangle;
   import mx.core.EdgeMetrics;
   import tibia.creatures.buddylistClasses.BuddyIcon;
   import flash.display.Graphics;
   import tibia.creatures.buddylistClasses.Buddy;
   import mx.core.FlexShape;
   import flash.events.TimerEvent;
   import mx.events.PropertyChangeEvent;
   
   public class BuddylistItemRenderer extends UIComponent implements IListItemRenderer, IDataRenderer
   {
      
      static var s_NameCache:TextFieldCache = new TextFieldCache(192,TextFieldCache.DEFAULT_HEIGHT,200,true);
      
      static var s_Trans:Matrix = new Matrix(1,0,0,1);
      
      public static const HEIGHT_HINT:Number = 18;
      
      {
         s_InitialiseStyle();
      }
      
      protected var m_HaveTimer:Boolean = false;
      
      protected var m_UIName:FlexShape = null;
      
      protected var m_Buddy:Buddy = null;
      
      private var m_HaveTimerInvalid:Boolean = false;
      
      private var m_UIConstructed:Boolean = false;
      
      private var m_UncommittedBuddy:Boolean = false;
      
      protected var m_UIIcon:tibia.creatures.buddylistWidgetClasses.BuddyIconRenderer = null;
      
      public function BuddylistItemRenderer()
      {
         super();
      }
      
      private static function s_InitialiseStyle() : void
      {
         var Selector:String = "BuddylistItemRenderer";
         var Decl:CSSStyleDeclaration = StyleManager.getStyleDeclaration(Selector);
         if(Decl == null)
         {
            Decl = new CSSStyleDeclaration(Selector);
         }
         Decl.defaultFactory = function():void
         {
            this.paddingBottom = 0;
            this.paddingLeft = 0;
            this.paddingRight = 0;
            this.paddingTop = 0;
            this.horizontalGap = 2;
            this.verticalGap = 2;
            this.highlightTextColor = 16316664;
            this.offlineTextColor = 16277600;
            this.onlineTextColor = 6355040;
            this.pendingTextColor = 16753920;
         };
         StyleManager.setStyleDeclaration(Selector,Decl,true);
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         var _loc11_:uint = 0;
         var _loc12_:Rectangle = null;
         super.updateDisplayList(param1,param2);
         graphics.beginFill(65280,0);
         graphics.drawRect(0,0,param1,param2);
         graphics.endFill();
         var _loc3_:EdgeMetrics = this.viewMetricsAndPadding;
         var _loc4_:Number = getStyle("horizontalGap");
         var _loc5_:Number = getStyle("verticalGap");
         var _loc6_:Number = _loc3_.left;
         var _loc7_:Number = _loc3_.top;
         var _loc8_:Number = 0;
         var _loc9_:Number = 0;
         param2 = param2 - (_loc3_.top + _loc3_.bottom);
         param1 = param1 - (_loc3_.left + _loc3_.right);
         _loc9_ = this.m_UIIcon.getExplicitOrMeasuredHeight();
         _loc8_ = this.m_UIIcon.getExplicitOrMeasuredWidth();
         this.m_UIIcon.ID = this.m_Buddy != null?int(this.m_Buddy.icon):int(BuddyIcon.DEFAULT_ICON);
         this.m_UIIcon.move(_loc6_,_loc7_ + (param2 - _loc9_) / 2);
         this.m_UIIcon.setActualSize(_loc8_,_loc9_);
         _loc6_ = _loc6_ + (_loc8_ + _loc4_);
         var _loc10_:Graphics = this.m_UIName.graphics;
         _loc10_.clear();
         if(this.m_Buddy != null)
         {
            _loc9_ = s_NameCache.slotHeight;
            _loc8_ = param1 - _loc8_ - _loc4_;
            _loc11_ = 0;
            if(this.m_Buddy.highlight)
            {
               _loc11_ = getStyle("highlightTextColor");
            }
            else if(this.m_Buddy.status == Buddy.STATUS_ONLINE)
            {
               _loc11_ = getStyle("onlineTextColor");
            }
            else if(this.m_Buddy.status == Buddy.STATUS_OFFLINE)
            {
               _loc11_ = getStyle("offlineTextColor");
            }
            else if(this.m_Buddy.status == Buddy.STATUS_PENDING)
            {
               _loc11_ = getStyle("pendingTextColor");
            }
            _loc12_ = s_NameCache.getItem(this.m_Buddy.name + String(_loc11_),this.m_Buddy.name,_loc11_,_loc8_);
            if(_loc12_ != null)
            {
               s_Trans.tx = -_loc12_.x;
               s_Trans.ty = -_loc12_.y;
               _loc10_.beginBitmapFill(s_NameCache,s_Trans,false,false);
               _loc10_.drawRect(0,0,_loc12_.width,_loc12_.height);
               _loc10_.endFill();
            }
            this.m_UIName.x = _loc6_;
            this.m_UIName.y = _loc7_ + (param2 - _loc9_) / 2;
         }
      }
      
      public function invalidateTimer() : void
      {
         this.m_HaveTimerInvalid = true;
         invalidateProperties();
      }
      
      override protected function commitProperties() : void
      {
         var _loc1_:Boolean = false;
         if(this.m_UncommittedBuddy)
         {
            toolTip = this.m_Buddy != null?this.m_Buddy.description:null;
            this.m_UncommittedBuddy = false;
         }
         if(this.m_HaveTimerInvalid)
         {
            _loc1_ = this.m_Buddy != null && this.m_Buddy.highlight;
            if(_loc1_ && !this.m_HaveTimer)
            {
               Tibia.s_GetSecondaryTimer().addEventListener(TimerEvent.TIMER,this.onTimer);
            }
            if(!_loc1_ && this.m_HaveTimer)
            {
               Tibia.s_GetSecondaryTimer().removeEventListener(TimerEvent.TIMER,this.onTimer);
            }
            this.m_HaveTimer = _loc1_;
            this.m_HaveTimerInvalid = false;
         }
         super.commitProperties();
      }
      
      override protected function createChildren() : void
      {
         if(!this.m_UIConstructed)
         {
            super.createChildren();
            this.m_UIIcon = new tibia.creatures.buddylistWidgetClasses.BuddyIconRenderer();
            this.m_UIIcon.styleName = "noBackground";
            addChild(this.m_UIIcon);
            this.m_UIName = new FlexShape();
            addChild(this.m_UIName);
            this.m_UIConstructed = true;
         }
      }
      
      override protected function measure() : void
      {
         var _loc1_:EdgeMetrics = null;
         var _loc3_:Number = NaN;
         super.measure();
         _loc1_ = this.viewMetricsAndPadding;
         var _loc2_:Number = tibia.creatures.buddylistWidgetClasses.BuddyIconRenderer.ICON_WIDTH + getStyle("horizontalGap") + s_NameCache.slotWidth;
         _loc3_ = Math.max(tibia.creatures.buddylistWidgetClasses.BuddyIconRenderer.ICON_HEIGHT,s_NameCache.slotHeight);
         measuredMinWidth = measuredWidth = _loc1_.left + _loc2_ + _loc1_.right;
         measuredMinHeight = measuredHeight = _loc1_.top + _loc3_ + _loc1_.bottom;
      }
      
      protected function onTimer(param1:TimerEvent) : void
      {
         var _loc2_:Boolean = false;
         if(param1 != null)
         {
            _loc2_ = this.m_Buddy != null && this.m_Buddy.highlight;
            if(!_loc2_)
            {
               invalidateDisplayList();
               this.invalidateTimer();
            }
         }
      }
      
      public function set data(param1:Object) : void
      {
         if(this.m_Buddy != null)
         {
            this.m_Buddy.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onBuddyChange);
         }
         this.m_Buddy = param1 as Buddy;
         this.m_UncommittedBuddy = true;
         invalidateDisplayList();
         invalidateProperties();
         this.invalidateTimer();
         if(this.m_Buddy != null)
         {
            this.m_Buddy.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onBuddyChange);
         }
      }
      
      protected function onBuddyChange(param1:PropertyChangeEvent) : void
      {
         if(param1 != null)
         {
            switch(param1.property)
            {
               case "description":
                  toolTip = this.m_Buddy != null?this.m_Buddy.description:null;
                  break;
               case "icon":
               case "name":
                  invalidateDisplayList();
                  break;
               case "highlight":
               case "lastUpdate":
               case "online":
                  invalidateDisplayList();
                  this.invalidateTimer();
            }
         }
      }
      
      public function get viewMetricsAndPadding() : EdgeMetrics
      {
         return new EdgeMetrics(getStyle("paddingLeft"),getStyle("paddingTop"),getStyle("paddingRight"),getStyle("paddingBottom"));
      }
      
      public function get data() : Object
      {
         return this.m_Buddy;
      }
   }
}
