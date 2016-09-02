package shared.controls
{
   import mx.core.UIComponent;
   import mx.core.FlexShape;
   import flash.display.DisplayObject;
   import mx.core.IFlexDisplayObject;
   import flash.display.Graphics;
   
   public class IconRendererBase extends UIComponent
   {
       
      
      protected var m_Highlight:Boolean = false;
      
      private var m_StyleBackground;
      
      protected var m_IconLimit:int = 0;
      
      protected var m_IconWidth:Number = 0;
      
      private var m_UncommittedHighlight:Boolean = false;
      
      private var m_UncommittedID:Boolean = true;
      
      protected var m_ID:int = 0;
      
      protected var m_UIHighlight:IFlexDisplayObject = null;
      
      protected var m_IconHeight:Number = 0;
      
      protected var m_UIBackground:IFlexDisplayObject = null;
      
      private var m_StyleHighlight;
      
      private var m_UIConstructed:Boolean = false;
      
      private var m_StyleInvalid:Boolean = true;
      
      protected var m_UIIcon:FlexShape = null;
      
      public function IconRendererBase(param1:Number, param2:Number, param3:int)
      {
         super();
         this.m_IconWidth = param1;
         this.m_IconHeight = param2;
         this.m_IconLimit = param3;
      }
      
      public function get iconHeight() : Number
      {
         return this.m_IconHeight;
      }
      
      override public function styleChanged(param1:String) : void
      {
         switch(param1)
         {
            case "backgroundSkin":
            case "highlightSkin":
               this.invalidateStyle();
               break;
            default:
               super.styleChanged(param1);
         }
      }
      
      public function invalidateStyle() : void
      {
         this.m_StyleInvalid = true;
         invalidateDisplayList();
         invalidateProperties();
      }
      
      override public function set styleName(param1:Object) : void
      {
         super.styleName = param1;
         this.invalidateStyle();
      }
      
      override protected function createChildren() : void
      {
         if(!this.m_UIConstructed)
         {
            super.createChildren();
            this.validateStyle();
            this.m_UIIcon = new FlexShape();
            addChild(this.m_UIIcon);
         }
      }
      
      public function validateStyle() : void
      {
         var _loc1_:* = undefined;
         if(this.m_StyleInvalid)
         {
            _loc1_ = getStyle("backgroundSkin");
            if(this.m_StyleBackground != _loc1_)
            {
               this.m_StyleBackground = _loc1_;
               if(this.m_UIBackground != null)
               {
                  removeChild(DisplayObject(this.m_UIBackground));
                  this.m_UIBackground = null;
               }
               if(_loc1_ is Class)
               {
                  this.m_UIBackground = IFlexDisplayObject(new Class(_loc1_)());
                  addChild(DisplayObject(this.m_UIBackground));
               }
            }
            _loc1_ = getStyle("highlightSkin");
            if(this.m_StyleHighlight != _loc1_)
            {
               this.m_StyleHighlight = _loc1_;
               if(this.m_UIHighlight != null)
               {
                  removeChild(DisplayObject(this.m_UIHighlight));
                  this.m_UIHighlight = null;
               }
               if(_loc1_ is Class)
               {
                  this.m_UIHighlight = IFlexDisplayObject(new Class(_loc1_)());
                  addChild(DisplayObject(this.m_UIHighlight));
               }
            }
            this.m_StyleInvalid = false;
         }
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         super.updateDisplayList(param1,param2);
         var _loc3_:int = 0;
         if(this.m_UIBackground != null)
         {
            this.m_UIBackground.move(0,0);
            this.m_UIBackground.setActualSize(param1,param2);
            setChildIndex(DisplayObject(this.m_UIBackground),_loc3_++);
         }
         if(this.m_UIIcon != null)
         {
            this.drawIcon(this.m_UIIcon.graphics);
            this.m_UIIcon.x = (param1 - this.m_IconWidth) / 2;
            this.m_UIIcon.y = (param2 - this.m_IconHeight) / 2;
            setChildIndex(this.m_UIIcon,_loc3_++);
         }
         if(this.m_UIHighlight != null)
         {
            this.m_UIHighlight.visible = this.m_Highlight;
            this.m_UIHighlight.move(0,0);
            this.m_UIHighlight.setActualSize(param1,param2);
            setChildIndex(DisplayObject(this.m_UIHighlight),_loc3_++);
         }
      }
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
         if(this.m_UncommittedID)
         {
            this.m_UncommittedID = false;
         }
         if(this.m_UncommittedHighlight)
         {
            this.m_UncommittedHighlight = false;
         }
         if(this.m_StyleInvalid)
         {
            this.validateStyle();
            this.m_StyleInvalid = false;
         }
      }
      
      public function get iconWidth() : Number
      {
         return this.m_IconWidth;
      }
      
      protected function drawIcon(param1:Graphics) : void
      {
      }
      
      override protected function measure() : void
      {
         super.measure();
         this.validateStyle();
         var _loc1_:Number = this.m_IconWidth;
         var _loc2_:Number = this.m_IconHeight;
         if(this.m_UIBackground != null)
         {
            _loc1_ = Math.max(_loc1_,this.m_UIBackground.measuredHeight);
            _loc2_ = Math.max(_loc1_,this.m_UIBackground.measuredWidth);
         }
         measuredMinHeight = measuredHeight = _loc1_;
         measuredMinWidth = measuredWidth = _loc2_;
      }
      
      public function get ID() : int
      {
         return this.m_ID;
      }
      
      public function set highlight(param1:Boolean) : void
      {
         if(this.m_Highlight != param1)
         {
            this.m_Highlight = param1;
            this.m_UncommittedHighlight = true;
            invalidateDisplayList();
            invalidateProperties();
         }
      }
      
      public function get highlight() : Boolean
      {
         return this.m_Highlight;
      }
      
      public function set ID(param1:int) : void
      {
         param1 = Math.max(0,Math.min(param1,this.m_IconLimit));
         if(this.m_ID != param1)
         {
            this.m_ID = param1;
            this.m_UncommittedID = true;
            invalidateDisplayList();
         }
      }
   }
}
