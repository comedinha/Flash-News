package mx.containers.dividedBoxClasses
{
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import mx.containers.DividedBox;
   import mx.containers.DividerState;
   import mx.core.UIComponent;
   import mx.core.mx_internal;
   import mx.events.SandboxMouseEvent;
   
   use namespace mx_internal;
   
   public class BoxDivider extends UIComponent
   {
      
      mx_internal static const VERSION:String = "3.6.0.21751";
       
      
      private var isMouseOver:Boolean = false;
      
      private var _state:String = "up";
      
      private var knob:DisplayObject;
      
      public function BoxDivider()
      {
         super();
         addEventListener(MouseEvent.MOUSE_OVER,mouseOverHandler);
         addEventListener(MouseEvent.MOUSE_OUT,mouseOutHandler);
         addEventListener(MouseEvent.MOUSE_DOWN,mouseDownHandler);
      }
      
      mx_internal function set state(param1:String) : void
      {
         _state = param1;
         invalidateDisplayList();
      }
      
      override public function styleChanged(param1:String) : void
      {
         super.styleChanged(param1);
         if(!param1 || param1 == "dividerSkin" || param1 == "styleName")
         {
            if(knob)
            {
               removeChild(knob);
               knob = null;
            }
         }
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         var _loc3_:Number = NaN;
         var _loc7_:Class = null;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         if(isNaN(width) || isNaN(height))
         {
            return;
         }
         if(!parent)
         {
            return;
         }
         super.updateDisplayList(param1,param2);
         graphics.clear();
         graphics.beginFill(0,0);
         graphics.drawRect(0,0,width,height);
         graphics.endFill();
         var _loc4_:Number = 1;
         var _loc5_:Number = getStyle("dividerThickness");
         var _loc6_:Number = !!DividedBox(owner).isVertical()?Number(DividedBox(owner).getStyle("verticalGap")):Number(DividedBox(owner).getStyle("horizontalGap"));
         if(state != DividerState.DOWN)
         {
            if(_loc6_ >= 6)
            {
               if(!knob)
               {
                  _loc7_ = Class(getStyle("dividerSkin"));
                  if(_loc7_)
                  {
                     knob = new _loc7_();
                  }
                  if(knob)
                  {
                     addChild(knob);
                  }
               }
               if(knob)
               {
                  if(DividedBox(owner).isVertical())
                  {
                     knob.scaleX = 1;
                     knob.rotation = 0;
                  }
                  else
                  {
                     knob.scaleX = -1;
                     knob.rotation = -90;
                  }
                  knob.x = Math.round((width - knob.width) / 2);
                  knob.y = Math.round((height - knob.height) / 2);
               }
            }
            return;
         }
         _loc3_ = getStyle("dividerColor");
         _loc4_ = getStyle("dividerAlpha");
         graphics.beginFill(_loc3_,_loc4_);
         if(DividedBox(owner).isVertical())
         {
            _loc8_ = _loc5_;
            if(_loc8_ > _loc6_)
            {
               _loc8_ = _loc6_;
            }
            _loc9_ = (height - _loc8_) / 2;
            graphics.drawRect(0,_loc9_,width,_loc8_);
         }
         else
         {
            _loc10_ = _loc5_;
            if(_loc10_ > _loc6_)
            {
               _loc10_ = _loc6_;
            }
            _loc11_ = (width - _loc10_) / 2;
            graphics.drawRect(_loc11_,0,_loc10_,height);
         }
         graphics.endFill();
      }
      
      private function mouseOutHandler(param1:MouseEvent) : void
      {
         isMouseOver = false;
         if(!DividedBox(owner).activeDivider)
         {
            state = DividerState.UP;
            if(parent)
            {
               DividedBox(owner).restoreCursor();
            }
         }
      }
      
      private function mouseUpHandler(param1:Event) : void
      {
         if(!isMouseOver)
         {
            DividedBox(owner).restoreCursor();
         }
         state = DividerState.OVER;
         DividedBox(owner).stopDividerDrag(this,param1 as MouseEvent);
         var _loc2_:DisplayObject = systemManager.getSandboxRoot();
         _loc2_.removeEventListener(MouseEvent.MOUSE_UP,mouseUpHandler,true);
         _loc2_.removeEventListener(SandboxMouseEvent.MOUSE_UP_SOMEWHERE,mouseUpHandler);
      }
      
      override public function set x(param1:Number) : void
      {
         var _loc2_:Number = x;
         super.x = param1;
         if(!DividedBox(owner).isVertical())
         {
            DividedBox(owner).moveDivider(DividedBox(owner).getDividerIndex(this),param1 - _loc2_);
         }
      }
      
      mx_internal function get state() : String
      {
         return _state;
      }
      
      private function mouseOverHandler(param1:MouseEvent) : void
      {
         if(param1.buttonDown)
         {
            return;
         }
         isMouseOver = true;
         if(!DividedBox(owner).activeDivider)
         {
            state = DividerState.OVER;
            DividedBox(owner).changeCursor(this);
         }
      }
      
      override public function set y(param1:Number) : void
      {
         var _loc2_:Number = y;
         super.y = param1;
         if(DividedBox(owner).isVertical())
         {
            DividedBox(owner).moveDivider(DividedBox(owner).getDividerIndex(this),param1 - _loc2_);
         }
      }
      
      private function mouseDownHandler(param1:MouseEvent) : void
      {
         DividedBox(owner).changeCursor(this);
         DividedBox(owner).startDividerDrag(this,param1);
         var _loc2_:DisplayObject = systemManager.getSandboxRoot();
         _loc2_.addEventListener(MouseEvent.MOUSE_UP,mouseUpHandler,true);
         _loc2_.addEventListener(SandboxMouseEvent.MOUSE_UP_SOMEWHERE,mouseUpHandler);
      }
   }
}
