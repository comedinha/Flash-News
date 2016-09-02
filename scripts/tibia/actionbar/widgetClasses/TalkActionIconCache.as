package tibia.actionbar.widgetClasses
{
   import shared.utility.TextFieldCache;
   import flash.geom.Matrix;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.filters.GlowFilter;
   import flash.filters.BitmapFilterQuality;
   
   public class TalkActionIconCache extends TextFieldCache
   {
      
      protected static var s_Matrix:Matrix = new Matrix(1,0,0,1,0,0);
       
      
      public function TalkActionIconCache(param1:Number, param2:Number, param3:uint, param4:Boolean)
      {
         super(param1,param2,param3,param4);
         m_TextField = new TextField();
         m_TextField.width = param1 + 4;
         m_TextField.height = param2 + 4;
         m_TextField.wordWrap = true;
         m_TextField.multiline = true;
         m_TextField.defaultTextFormat = new TextFormat("Verdana",11,0,true);
         m_TextField.filters = [new GlowFilter(0,1,2,2,4,BitmapFilterQuality.LOW,false,false)];
      }
      
      override protected function addItem(param1:Rectangle, param2:Array) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         if(param2 == null || param2.length < 1)
         {
            return;
         }
         if(param2.length > 1)
         {
            m_TextField.textColor = uint(param2[1]);
         }
         else
         {
            m_TextField.textColor = uint(m_TextField.defaultTextFormat.color);
         }
         var _loc3_:String = String(param2[0]);
         m_TextField.text = _loc3_;
         if(m_TextField.textWidth > slotWidth || m_TextField.textHeight > slotHeight)
         {
            _loc4_ = 0;
            _loc5_ = 0;
            _loc6_ = Number(m_TextField.defaultTextFormat.leading);
            _loc7_ = slotHeight + _loc6_;
            while(_loc5_ < m_TextField.numLines)
            {
               _loc7_ = _loc7_ - (m_TextField.getLineMetrics(_loc5_).height + _loc6_);
               if(_loc7_ < 0)
               {
                  break;
               }
               _loc4_ = _loc4_ + m_TextField.getLineLength(_loc5_);
               _loc5_++;
            }
            if(m_AddEllipsis)
            {
               m_TextField.text = _loc3_.substr(0,_loc4_ - 3) + "...";
            }
            else
            {
               m_TextField.text = _loc3_.substr(0,_loc4_);
            }
         }
         s_Matrix.tx = param1.x - 2;
         s_Matrix.ty = param1.y - 2;
         draw(m_TextField,s_Matrix,null,null,null,false);
      }
   }
}
