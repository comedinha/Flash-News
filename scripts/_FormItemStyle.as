package
{
   import mx.core.IFlexModuleFactory;
   import mx.styles.CSSStyleDeclaration;
   import mx.styles.StyleManager;
   
   public class _FormItemStyle
   {
      
      private static var _embed_css_Assets_swf_mx_containers_FormItem_Required_1757197398:Class = _FormItemStyle__embed_css_Assets_swf_mx_containers_FormItem_Required_1757197398;
       
      
      public function _FormItemStyle()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         var fbs:IFlexModuleFactory = param1;
         var style:CSSStyleDeclaration = StyleManager.getStyleDeclaration("FormItem");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration("FormItem",style,false);
         }
         if(style.defaultFactory == null)
         {
            style.defaultFactory = function():void
            {
               this.indicatorSkin = _embed_css_Assets_swf_mx_containers_FormItem_Required_1757197398;
            };
         }
      }
   }
}
