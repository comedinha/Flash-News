package
{
   import mx.core.IFlexModuleFactory;
   import mx.styles.CSSStyleDeclaration;
   import mx.styles.StyleManager;
   import mx.skins.halo.BrokenImageBorderSkin;
   
   public class _SWFLoaderStyle
   {
      
      private static var _embed_css_Assets_swf___brokenImage_783978175:Class = _SWFLoaderStyle__embed_css_Assets_swf___brokenImage_783978175;
       
      
      public function _SWFLoaderStyle()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         var fbs:IFlexModuleFactory = param1;
         var style:CSSStyleDeclaration = StyleManager.getStyleDeclaration("SWFLoader");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration("SWFLoader",style,false);
         }
         if(style.defaultFactory == null)
         {
            style.defaultFactory = function():void
            {
               this.brokenImageBorderSkin = BrokenImageBorderSkin;
               this.brokenImageSkin = _embed_css_Assets_swf___brokenImage_783978175;
               this.borderStyle = "none";
            };
         }
      }
   }
}
