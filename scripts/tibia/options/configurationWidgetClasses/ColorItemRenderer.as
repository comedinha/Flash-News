package tibia.options.configurationWidgetClasses
{
   import mx.core.UIComponent;
   import mx.controls.listClasses.IListItemRenderer;
   import tibia.chat.MessageMode;
   
   public class ColorItemRenderer extends UIComponent implements IListItemRenderer
   {
       
      
      private var m_Color:uint = 4.27825536E9;
      
      private var m_UncommittedColor:Boolean = false;
      
      private var m_UncommittedData:Boolean = false;
      
      private var m_Data:Object = null;
      
      public function ColorItemRenderer()
      {
         super();
      }
      
      private function get color() : uint
      {
         return this.m_Color;
      }
      
      private function set color(param1:uint) : void
      {
         if(this.m_Color != param1)
         {
            this.m_Color = param1;
            this.m_UncommittedColor = true;
            invalidateDisplayList();
            invalidateProperties();
         }
      }
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
         if(this.m_UncommittedColor)
         {
            this.m_UncommittedColor = false;
         }
         if(this.m_UncommittedData)
         {
            if(this.data >= 0 && this.data < MessageMode.MESSAGE_MODE_COLOURS.length)
            {
               this.color = MessageMode.MESSAGE_MODE_COLOURS[uint(this.data)];
            }
            this.m_UncommittedData = false;
         }
      }
      
      public function set data(param1:Object) : void
      {
         if(this.m_Data != param1)
         {
            this.m_Data = param1;
            this.m_UncommittedData = true;
            invalidateProperties();
         }
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         super.updateDisplayList(param1,param2);
         var _loc3_:Number = 0;
         if(getStyle("cornerRadius"))
         {
            _loc3_ = Number(getStyle("cornerRadius"));
         }
         graphics.clear();
         graphics.beginFill(16777215 & this.color,(this.color >>> 24) / 255);
         graphics.drawRoundRect(0,0,param1,param2,_loc3_);
         graphics.endFill();
      }
      
      public function get data() : Object
      {
         return this.m_Data;
      }
   }
}
