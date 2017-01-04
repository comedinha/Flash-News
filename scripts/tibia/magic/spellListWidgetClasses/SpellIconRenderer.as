package tibia.magic.spellListWidgetClasses
{
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.Graphics;
   import flash.geom.Matrix;
   import flash.geom.Rectangle;
   import mx.core.FlexShape;
   import mx.core.IFlexDisplayObject;
   import mx.core.UIComponent;
   import tibia.magic.Spell;
   
   public class SpellIconRenderer extends UIComponent
   {
      
      private static var s_Rectangle:Rectangle = new Rectangle();
      
      private static var s_Matrix:Matrix = new Matrix();
       
      
      private var m_Spell:Spell;
      
      private var m_Selected:Boolean = false;
      
      private var m_UISkinBackground:IFlexDisplayObject = null;
      
      private var m_UISkinUnavailable:IFlexDisplayObject = null;
      
      private var m_Available:Boolean = true;
      
      private var m_UIConstructed:Boolean = false;
      
      private var m_UISpellIcon:FlexShape = null;
      
      private var m_UISkinSelected:IFlexDisplayObject = null;
      
      public function SpellIconRenderer()
      {
         super();
      }
      
      override public function styleChanged(param1:String) : void
      {
         switch(param1)
         {
            case "backgroundImage":
               this.m_UISkinBackground = this.updateSkin("backgroundImage");
               invalidateDisplayList();
               invalidateSize();
               break;
            case "overlaySelectedImage":
               this.m_UISkinSelected = this.updateSkin("overlaySelectedImage");
               invalidateDisplayList();
               break;
            case "overlayUnavailableImage":
               this.m_UISkinUnavailable = this.updateSkin("overlayUnavailableImage");
               invalidateDisplayList();
               break;
            default:
               super.styleChanged(param1);
         }
      }
      
      public function get available() : Boolean
      {
         return this.m_Available;
      }
      
      public function set spell(param1:Spell) : void
      {
         if(this.m_Spell != param1)
         {
            this.m_Spell = param1;
            invalidateDisplayList();
         }
      }
      
      public function set available(param1:Boolean) : void
      {
         if(this.m_Available != param1)
         {
            this.m_Available = param1;
            invalidateDisplayList();
         }
      }
      
      public function get selected() : Boolean
      {
         return this.m_Selected;
      }
      
      override protected function measure() : void
      {
         super.measure();
         if(this.m_UISkinBackground != null)
         {
            measuredWidth = measuredMinWidth = this.m_UISkinBackground.width;
            measuredHeight = measuredMinHeight = this.m_UISkinBackground.height;
         }
         else
         {
            measuredWidth = measuredMinWidth = Spell.ICON_SIZE + getStyle("paddingLeft") + getStyle("paddingRight");
            measuredHeight = measuredMinHeight = Spell.ICON_SIZE + getStyle("paddingTop") + getStyle("paddingBottom");
         }
      }
      
      private function updateSkin(param1:String) : IFlexDisplayObject
      {
         var _loc2_:DisplayObject = getChildByName(param1);
         var _loc3_:int = -1;
         if(_loc2_ != null)
         {
            _loc3_ = getChildIndex(_loc2_);
            removeChild(_loc2_);
            _loc2_ = null;
         }
         var _loc4_:Class = getStyle(param1) as Class;
         if(_loc4_ != null)
         {
            _loc2_ = DisplayObject(new _loc4_());
            _loc2_.name = param1;
            _loc2_.cacheAsBitmap = true;
         }
         if(_loc2_ != null)
         {
            if(_loc3_ != -1)
            {
               addChildAt(_loc2_,_loc3_);
            }
            else
            {
               addChild(_loc2_);
            }
         }
         return IFlexDisplayObject(_loc2_);
      }
      
      public function get spell() : Spell
      {
         return this.m_Spell;
      }
      
      private function updateIcon() : void
      {
         var _loc1_:Graphics = this.m_UISpellIcon.graphics;
         _loc1_.clear();
         var _loc2_:BitmapData = null;
         if(this.spell != null && (_loc2_ = this.spell.getIcon(s_Rectangle)) != null)
         {
            s_Matrix.tx = -s_Rectangle.x;
            s_Matrix.ty = -s_Rectangle.y;
            _loc1_.beginBitmapFill(_loc2_,s_Matrix,false,false);
            _loc1_.drawRect(0,0,s_Rectangle.width,s_Rectangle.height);
            _loc1_.endFill();
         }
      }
      
      override protected function createChildren() : void
      {
         if(!this.m_UIConstructed)
         {
            super.createChildren();
            this.m_UISkinBackground = this.updateSkin("backgroundImage");
            this.m_UISpellIcon = new FlexShape();
            this.m_UISpellIcon.name = "spellIcon";
            addChild(this.m_UISpellIcon);
            this.m_UISkinUnavailable = this.updateSkin("overlayUnavailableImage");
            this.m_UISkinSelected = this.updateSkin("overlaySelectedImage");
            this.m_UIConstructed = true;
         }
      }
      
      public function set selected(param1:Boolean) : void
      {
         if(this.m_Selected != param1)
         {
            this.m_Selected = param1;
            invalidateDisplayList();
         }
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         super.updateDisplayList(param1,param2);
         var _loc3_:int = 0;
         if(this.m_UISkinBackground != null)
         {
            this.m_UISkinBackground.x = (param1 - this.m_UISkinBackground.width) / 2;
            this.m_UISkinBackground.y = (param2 - this.m_UISkinBackground.height) / 2;
            this.m_UISkinBackground.visible = true;
            setChildIndex(DisplayObject(this.m_UISkinBackground),_loc3_++);
         }
         if(this.m_UISpellIcon != null)
         {
            this.updateIcon();
            this.m_UISpellIcon.x = (param1 - this.m_UISpellIcon.width) / 2;
            this.m_UISpellIcon.y = (param2 - this.m_UISpellIcon.height) / 2;
            this.m_UISpellIcon.visible = true;
            setChildIndex(this.m_UISpellIcon,_loc3_++);
         }
         if(this.m_UISkinUnavailable != null)
         {
            this.m_UISkinUnavailable.x = (param1 - this.m_UISkinUnavailable.width) / 2;
            this.m_UISkinUnavailable.y = (param2 - this.m_UISkinUnavailable.height) / 2;
            this.m_UISkinUnavailable.visible = !this.available;
            setChildIndex(DisplayObject(this.m_UISkinUnavailable),_loc3_++);
         }
         if(this.m_UISkinSelected != null)
         {
            this.m_UISkinSelected.x = (param1 - this.m_UISkinSelected.width) / 2;
            this.m_UISkinSelected.y = (param2 - this.m_UISkinSelected.height) / 2;
            this.m_UISkinSelected.visible = this.selected;
            setChildIndex(DisplayObject(this.m_UISkinSelected),_loc3_++);
         }
      }
   }
}
