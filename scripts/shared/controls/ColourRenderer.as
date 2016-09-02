package shared.controls
{
   import mx.core.UIComponent;
   import flash.events.MouseEvent;
   import mx.core.EventPriority;
   
   public class ColourRenderer extends UIComponent
   {
       
      
      protected var m_Hover:Boolean = false;
      
      private var m_UncommittedSelected:Boolean = false;
      
      protected var m_Selected:Boolean = false;
      
      protected var m_Data = null;
      
      private var m_UncommittedARGB:Boolean = false;
      
      protected var m_ARGB:uint = 0;
      
      public function ColourRenderer()
      {
         super();
         addEventListener(MouseEvent.MOUSE_OVER,this.onMouseEvent,false,EventPriority.DEFAULT,true);
         addEventListener(MouseEvent.MOUSE_OUT,this.onMouseEvent,false,EventPriority.DEFAULT,true);
      }
      
      public function get selected() : Boolean
      {
         return this.m_Selected;
      }
      
      public function get ARGB() : uint
      {
         return this.m_ARGB;
      }
      
      public function set ARGB(param1:uint) : void
      {
         if(this.m_ARGB != param1)
         {
            this.m_ARGB = param1;
            this.m_UncommittedARGB = true;
            invalidateDisplayList();
            invalidateProperties();
         }
      }
      
      protected function onMouseEvent(param1:MouseEvent) : void
      {
         if(param1 != null)
         {
            switch(param1.type)
            {
               case MouseEvent.MOUSE_OVER:
                  this.m_Hover = true;
                  invalidateDisplayList();
                  break;
               case MouseEvent.MOUSE_OUT:
               default:
                  this.m_Hover = false;
                  invalidateDisplayList();
            }
         }
      }
      
      public function get data() : *
      {
         return this.m_Data;
      }
      
      public function set selected(param1:Boolean) : void
      {
         if(this.m_Selected != param1)
         {
            this.m_Selected = param1;
            this.m_UncommittedSelected = true;
            invalidateDisplayList();
            invalidateProperties();
         }
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         super.updateDisplayList(param1,param2);
         var _loc3_:Number = (this.m_ARGB >>> 24) / 255;
         var _loc4_:uint = this.m_ARGB & 16777215;
         var _loc5_:Number = getStyle("selectionAlpha");
         var _loc6_:uint = getStyle("selectionColor");
         graphics.clear();
         if(this.m_Selected || this.m_Hover)
         {
            graphics.beginFill(_loc4_,_loc3_ * 0.33);
            graphics.drawRect(0,0,param1,param2);
            graphics.beginFill(_loc4_,_loc3_);
            graphics.drawRect(2,2,param1 - 4,param2 - 4);
            graphics.beginFill(0,NaN);
            graphics.lineStyle(1,_loc6_,_loc5_);
            graphics.drawRect(0,0,param1 - 1,param2 - 1);
         }
         else
         {
            graphics.beginFill(_loc4_,_loc3_);
            graphics.drawRect(0,0,param1,param2);
         }
         graphics.endFill();
      }
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
         if(this.m_UncommittedARGB)
         {
            this.m_UncommittedARGB = false;
         }
         if(this.m_UncommittedSelected)
         {
            this.m_UncommittedSelected = false;
         }
      }
      
      public function set data(param1:*) : void
      {
         this.m_Data = param1;
      }
   }
}
