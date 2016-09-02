package shared.controls
{
   import flash.geom.Rectangle;
   
   public class UIHyperlinksTextFieldHyperlinkInfo
   {
       
      
      private var m_HyperlinkText:String = null;
      
      private var m_Rectangles:Vector.<Rectangle>;
      
      private var m_GlobalRectangles:Vector.<Rectangle>;
      
      public function UIHyperlinksTextFieldHyperlinkInfo(param1:String)
      {
         this.m_Rectangles = new Vector.<Rectangle>();
         this.m_GlobalRectangles = new Vector.<Rectangle>();
         super();
         this.m_HyperlinkText = param1;
      }
      
      public function get rectangles() : Vector.<Rectangle>
      {
         return this.m_Rectangles;
      }
      
      public function get globalRectangles() : Vector.<Rectangle>
      {
         return this.m_GlobalRectangles;
      }
      
      public function get hyperlinkText() : String
      {
         return this.m_HyperlinkText;
      }
      
      public function contains(param1:uint, param2:uint) : Boolean
      {
         var _loc3_:Rectangle = null;
         for each(_loc3_ in this.m_Rectangles)
         {
            if(_loc3_.contains(param1,param2))
            {
               return true;
            }
         }
         return false;
      }
   }
}
