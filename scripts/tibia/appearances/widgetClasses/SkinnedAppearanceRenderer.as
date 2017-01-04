package tibia.appearances.widgetClasses
{
   import flash.display.DisplayObject;
   import mx.core.IFlexDisplayObject;
   import mx.core.UIComponent;
   import mx.styles.CSSStyleDeclaration;
   import mx.styles.StyleManager;
   import tibia.appearances.AppearanceInstance;
   import tibia.appearances.AppearanceStorage;
   import tibia.appearances.AppearanceType;
   import tibia.appearances.AppearanceTypeRef;
   
   public class SkinnedAppearanceRenderer extends UIComponent
   {
      
      {
         initializeStyle();
      }
      
      private var m_UncommittedHighlighted:Boolean = false;
      
      private var m_UISkinBackground:IFlexDisplayObject = null;
      
      private var m_UncommittedAppearance:Boolean = false;
      
      private var m_Appearance = null;
      
      private var m_UISkinDisabled:IFlexDisplayObject = null;
      
      private var m_Highlighted:Boolean = false;
      
      private var m_UIAppearance:SimpleAppearanceRenderer = null;
      
      private var m_UIConstructed:Boolean = false;
      
      private var m_UISkinHighlight:IFlexDisplayObject = null;
      
      public function SkinnedAppearanceRenderer()
      {
         super();
      }
      
      private static function initializeStyle() : void
      {
         var Selector:String = "SkinnedAppearanceRenderer";
         var Decl:CSSStyleDeclaration = StyleManager.getStyleDeclaration(Selector);
         if(Decl == null)
         {
            Decl = new CSSStyleDeclaration();
         }
         Decl.defaultFactory = function():void
         {
            this.backgroundImage = undefined;
            this.overlayDisabledImage = undefined;
            this.overlayHighlightImage = undefined;
            this.paddingBottom = 2;
            this.paddingLeft = 2;
            this.paddingRight = 2;
            this.paddingTop = 2;
         };
         StyleManager.setStyleDeclaration(Selector,Decl,true);
      }
      
      override public function styleChanged(param1:String) : void
      {
         switch(param1)
         {
            case "backgroundImage":
               this.m_UISkinBackground = this.updateSkin("backgroundImage");
               invalidateSize();
               break;
            case "overlayDisabledImage":
               this.m_UISkinDisabled = this.updateSkin("overlayDisabledImage");
               invalidateSize();
               break;
            case "overlayHighlightImage":
               this.m_UISkinHighlight = this.updateSkin("overlayHighlightImage");
               invalidateSize();
               break;
            default:
               super.styleChanged(param1);
         }
      }
      
      public function set appearance(param1:*) : void
      {
         if(this.m_Appearance != param1)
         {
            this.m_Appearance = param1;
            this.m_UncommittedAppearance = true;
            invalidateProperties();
         }
      }
      
      public function get highlighted() : Boolean
      {
         return this.m_Highlighted;
      }
      
      override protected function commitProperties() : void
      {
         var _loc1_:AppearanceStorage = null;
         var _loc2_:AppearanceType = null;
         var _loc3_:AppearanceTypeRef = null;
         super.commitProperties();
         if(this.m_UncommittedAppearance)
         {
            _loc1_ = Tibia.s_GetAppearanceStorage();
            if(this.m_Appearance is AppearanceInstance)
            {
               this.m_UIAppearance.appearance = AppearanceInstance(this.m_Appearance);
            }
            else if(this.m_Appearance is AppearanceType && _loc1_ != null)
            {
               _loc2_ = AppearanceType(this.m_Appearance);
               this.m_UIAppearance.appearance = _loc1_.createObjectInstance(_loc2_.ID,0);
            }
            else if(this.m_Appearance is AppearanceTypeRef && _loc1_ != null)
            {
               _loc3_ = AppearanceTypeRef(this.m_Appearance);
               this.m_UIAppearance.appearance = _loc1_.createObjectInstance(_loc3_.ID,_loc3_.data);
            }
            else
            {
               this.m_UIAppearance.appearance = null;
            }
            this.m_UncommittedAppearance = false;
         }
         if(this.m_UncommittedHighlighted)
         {
            this.m_UncommittedHighlighted = false;
         }
      }
      
      override protected function createChildren() : void
      {
         if(!this.m_UIConstructed)
         {
            super.createChildren();
            this.m_UIAppearance = new SimpleAppearanceRenderer();
            this.m_UIAppearance.overlay = false;
            addChild(this.m_UIAppearance);
            this.m_UISkinBackground = this.updateSkin("backgroundImage");
            this.m_UISkinDisabled = this.updateSkin("overlayDisabledImage");
            this.m_UISkinHighlight = this.updateSkin("overlayHighlightImage");
            this.m_UIConstructed = true;
         }
      }
      
      override protected function measure() : void
      {
         super.measure();
         var _loc1_:Number = 0;
         var _loc2_:Number = 0;
         if(this.m_UISkinBackground != null)
         {
            _loc1_ = this.m_UISkinBackground.width;
            _loc2_ = this.m_UISkinBackground.height;
         }
         else
         {
            _loc1_ = SimpleAppearanceRenderer.ICON_SIZE + getStyle("paddingLeft") + getStyle("paddingRight");
            _loc2_ = SimpleAppearanceRenderer.ICON_SIZE + getStyle("paddingTop") + getStyle("paddingBottom");
         }
         measuredWidth = measuredMinWidth = _loc1_;
         measuredHeight = measuredMinHeight = _loc2_;
      }
      
      public function get appearance() : *
      {
         return this.m_Appearance;
      }
      
      public function set highlighted(param1:Boolean) : void
      {
         if(this.m_Highlighted != param1)
         {
            this.m_Highlighted = param1;
            this.m_UncommittedHighlighted = true;
            invalidateDisplayList();
            invalidateProperties();
         }
      }
      
      private function updateSkin(param1:String) : IFlexDisplayObject
      {
         var _loc2_:DisplayObject = getChildByName(param1);
         if(_loc2_ != null)
         {
            removeChild(_loc2_);
            _loc2_ = null;
         }
         var _loc3_:Class = getStyle(param1) as Class;
         if(_loc3_ != null)
         {
            _loc2_ = DisplayObject(new _loc3_());
            _loc2_.name = param1;
            _loc2_.cacheAsBitmap = true;
            addChild(_loc2_);
         }
         return IFlexDisplayObject(_loc2_);
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         super.updateDisplayList(param1,param2);
         var _loc3_:int = 0;
         if(this.m_UISkinBackground != null)
         {
            this.m_UISkinBackground.x = (param1 - this.m_UISkinBackground.width) / 2;
            this.m_UISkinBackground.y = (param2 - this.m_UISkinBackground.height) / 2;
            this.m_UISkinBackground.visible = true;
            setChildIndex(DisplayObject(this.m_UISkinBackground),_loc3_++);
         }
         if(this.m_UIAppearance != null)
         {
            _loc4_ = measuredWidth - getStyle("paddingLeft") - getStyle("paddingRight");
            _loc5_ = measuredHeight - getStyle("paddingTop") - getStyle("paddingBottom");
            this.m_UIAppearance.size = Math.min(_loc4_,_loc5_);
            this.m_UIAppearance.x = getStyle("paddingLeft") + (_loc4_ - this.m_UIAppearance.size) / 2;
            this.m_UIAppearance.y = getStyle("paddingTop") + (_loc5_ - this.m_UIAppearance.size) / 2;
            this.m_UIAppearance.visible = true;
            setChildIndex(this.m_UIAppearance,_loc3_++);
         }
         if(this.m_UISkinDisabled != null)
         {
            this.m_UISkinDisabled.x = (param1 - this.m_UISkinDisabled.width) / 2;
            this.m_UISkinDisabled.y = (param2 - this.m_UISkinDisabled.height) / 2;
            this.m_UISkinDisabled.visible = !enabled;
            setChildIndex(DisplayObject(this.m_UISkinDisabled),_loc3_++);
         }
         if(this.m_UISkinHighlight != null)
         {
            this.m_UISkinHighlight.x = (param1 - this.m_UISkinHighlight.width) / 2;
            this.m_UISkinHighlight.y = (param2 - this.m_UISkinHighlight.height) / 2;
            this.m_UISkinHighlight.visible = this.highlighted;
            setChildIndex(DisplayObject(this.m_UISkinHighlight),_loc3_++);
         }
      }
   }
}
