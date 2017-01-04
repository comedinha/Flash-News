package
{
   import mx.core.IFlexModuleFactory;
   import mx.skins.halo.DataGridColumnDropIndicator;
   import mx.skins.halo.DataGridColumnResizeSkin;
   import mx.skins.halo.DataGridHeaderBackgroundSkin;
   import mx.skins.halo.DataGridHeaderSeparator;
   import mx.skins.halo.DataGridSortArrow;
   import mx.styles.CSSStyleDeclaration;
   import mx.styles.StyleManager;
   
   public class _DataGridStyle
   {
      
      private static var _embed_css_Assets_swf_cursorStretch_2132883076:Class = _DataGridStyle__embed_css_Assets_swf_cursorStretch_2132883076;
       
      
      public function _DataGridStyle()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         var fbs:IFlexModuleFactory = param1;
         var style:CSSStyleDeclaration = StyleManager.getStyleDeclaration("DataGrid");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration("DataGrid",style,false);
         }
         if(style.defaultFactory == null)
         {
            style.defaultFactory = function():void
            {
               this.headerDragProxyStyleName = "headerDragProxyStyle";
               this.alternatingItemColors = [16250871,16777215];
               this.sortArrowSkin = DataGridSortArrow;
               this.verticalGridLineColor = 13421772;
               this.headerColors = [16777215,15132390];
               this.headerStyleName = "dataGridStyles";
               this.columnDropIndicatorSkin = DataGridColumnDropIndicator;
               this.headerSeparatorSkin = DataGridHeaderSeparator;
               this.stretchCursor = _embed_css_Assets_swf_cursorStretch_2132883076;
               this.columnResizeSkin = DataGridColumnResizeSkin;
               this.headerBackgroundSkin = DataGridHeaderBackgroundSkin;
            };
         }
      }
   }
}
