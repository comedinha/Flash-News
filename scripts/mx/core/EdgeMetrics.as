package mx.core
{
   use namespace mx_internal;
   
   public class EdgeMetrics
   {
      
      mx_internal static const VERSION:String = "3.6.0.21751";
      
      public static const EMPTY:EdgeMetrics = new EdgeMetrics(0,0,0,0);
       
      
      public var top:Number;
      
      public var left:Number;
      
      public var bottom:Number;
      
      public var right:Number;
      
      public function EdgeMetrics(param1:Number = 0, param2:Number = 0, param3:Number = 0, param4:Number = 0)
      {
         super();
         this.left = param1;
         this.top = param2;
         this.right = param3;
         this.bottom = param4;
      }
      
      public function clone() : EdgeMetrics
      {
         return new EdgeMetrics(left,top,right,bottom);
      }
   }
}
