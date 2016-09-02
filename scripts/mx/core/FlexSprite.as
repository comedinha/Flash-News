package mx.core
{
   import flash.display.Sprite;
   import mx.utils.NameUtil;
   
   use namespace mx_internal;
   
   public class FlexSprite extends Sprite
   {
      
      mx_internal static const VERSION:String = "3.6.0.21751";
       
      
      public function FlexSprite()
      {
         super();
         try
         {
            name = NameUtil.createUniqueName(this);
            return;
         }
         catch(e:Error)
         {
            return;
         }
      }
      
      override public function toString() : String
      {
         return NameUtil.displayObjectToString(this);
      }
   }
}
