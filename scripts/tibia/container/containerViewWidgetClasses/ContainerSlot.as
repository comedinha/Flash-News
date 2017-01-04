package tibia.container.containerViewWidgetClasses
{
   import flash.display.Bitmap;
   import flash.display.Graphics;
   import mx.core.UIComponent;
   import tibia.appearances.AppearanceInstance;
   import tibia.appearances.widgetClasses.SimpleAppearanceRenderer;
   
   public class ContainerSlot extends UIComponent
   {
      
      private static const DEFAULT_ICON_SIZE:int = 32;
       
      
      protected var m_UIAppearanceRenderer:SimpleAppearanceRenderer = null;
      
      protected var m_StyleBackgroundImage:Bitmap = null;
      
      private var m_UncommittedAppearance:Boolean = true;
      
      protected var m_Appearance:AppearanceInstance = null;
      
      protected var m_Position:int = 0;
      
      private var m_UncommittedPosition:Boolean = true;
      
      protected var m_StyleBackgroundValue:Object = null;
      
      private var m_InvalidStyle:Boolean = false;
      
      private var m_UIConstructed:Boolean = false;
      
      public function ContainerSlot()
      {
         super();
         this.invalidateStyle();
      }
      
      protected function validateStyle() : void
      {
         var _loc1_:Class = getStyle("backgroundImage") as Class;
         if(this.m_StyleBackgroundValue != _loc1_)
         {
            this.m_StyleBackgroundValue = _loc1_;
            this.m_StyleBackgroundImage = _loc1_ != null?Bitmap(new _loc1_()):null;
            invalidateDisplayList();
            invalidateSize();
         }
      }
      
      override public function styleChanged(param1:String) : void
      {
         switch(param1)
         {
            case "backgroundImage":
               this.invalidateStyle();
               break;
            default:
               super.styleChanged(param1);
         }
      }
      
      protected function layoutChrome(param1:Graphics, param2:Number, param3:Number) : void
      {
         param1.clear();
         if(this.m_StyleBackgroundImage != null)
         {
            param1.beginBitmapFill(this.m_StyleBackgroundImage.bitmapData,null,true,false);
         }
         else if(getStyle("backgroundColor") !== undefined)
         {
            param1.beginFill(getStyle("backgroundColor"),getStyle("backgroundAlpha"));
         }
         param1.drawRect(0,0,param2,param3);
         param1.endFill();
      }
      
      public function set appearance(param1:AppearanceInstance) : void
      {
         if(param1 != this.m_Appearance)
         {
            this.m_Appearance = param1;
            this.m_UncommittedAppearance = true;
            invalidateProperties();
         }
      }
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
         if(this.m_UncommittedAppearance)
         {
            this.m_UIAppearanceRenderer.appearance = this.m_Appearance;
            invalidateDisplayList();
            this.m_UncommittedAppearance = false;
         }
         if(this.m_UncommittedPosition)
         {
            invalidateDisplayList();
            this.m_UncommittedPosition = false;
         }
         if(this.m_InvalidStyle)
         {
            this.validateStyle();
            this.m_InvalidStyle = false;
         }
      }
      
      public function set position(param1:int) : void
      {
         if(param1 != this.m_Position)
         {
            this.m_Position = param1;
            this.m_UncommittedPosition = true;
            invalidateProperties();
         }
      }
      
      override protected function measure() : void
      {
         super.measure();
         this.validateStyle();
         if(this.m_StyleBackgroundImage != null)
         {
            measuredMinWidth = measuredWidth = this.m_StyleBackgroundImage.width;
            measuredMinHeight = measuredHeight = this.m_StyleBackgroundImage.height;
         }
         else
         {
            measuredMinWidth = measuredWidth = DEFAULT_ICON_SIZE + getStyle("paddingLeft") + getStyle("paddingRight");
            measuredMinHeight = measuredHeight = DEFAULT_ICON_SIZE + getStyle("paddingTop") + getStyle("paddingBottom");
         }
      }
      
      override protected function createChildren() : void
      {
         if(!this.m_UIConstructed)
         {
            super.createChildren();
            this.m_UIAppearanceRenderer = new SimpleAppearanceRenderer();
            this.m_UIAppearanceRenderer.overlay = true;
            this.m_UIAppearanceRenderer.size = DEFAULT_ICON_SIZE;
            this.m_UIAppearanceRenderer.smooth = false;
            addChild(this.m_UIAppearanceRenderer);
            this.m_UIConstructed = true;
         }
      }
      
      public function get position() : int
      {
         return this.m_Position;
      }
      
      public function get appearance() : AppearanceInstance
      {
         return this.m_Appearance;
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         this.validateStyle();
         this.layoutChrome(graphics,param1,param2);
         var _loc3_:Number = getStyle("paddingLeft");
         var _loc4_:Number = getStyle("paddingTop");
         var _loc5_:Number = param1 - _loc3_ - getStyle("paddingRight");
         var _loc6_:Number = param2 - _loc4_ - getStyle("paddingBottom");
         var _loc7_:Number = Math.min(_loc5_,_loc6_);
         this.m_UIAppearanceRenderer.x = _loc3_ + (_loc5_ - _loc7_) / 2;
         this.m_UIAppearanceRenderer.y = _loc4_ + (_loc6_ - _loc7_) / 2;
         this.m_UIAppearanceRenderer.size = _loc7_;
         this.m_UIAppearanceRenderer.draw();
      }
      
      protected function invalidateStyle() : void
      {
         this.m_InvalidStyle = true;
         invalidateProperties();
      }
   }
}
