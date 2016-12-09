package
{
   import mx.core.IFlexModuleFactory;
   import mx.styles.CSSStyleDeclaration;
   import mx.styles.StyleManager;
   
   public class _TreeStyle
   {
      
      private static var _embed_css_Assets_swf_TreeDisclosureOpen_1716239150:Class = _TreeStyle__embed_css_Assets_swf_TreeDisclosureOpen_1716239150;
      
      private static var _embed_css_Assets_swf_TreeFolderClosed_1449703875:Class = _TreeStyle__embed_css_Assets_swf_TreeFolderClosed_1449703875;
      
      private static var _embed_css_Assets_swf_TreeDisclosureClosed_1293217740:Class = _TreeStyle__embed_css_Assets_swf_TreeDisclosureClosed_1293217740;
      
      private static var _embed_css_Assets_swf_TreeNodeIcon_1351543526:Class = _TreeStyle__embed_css_Assets_swf_TreeNodeIcon_1351543526;
      
      private static var _embed_css_Assets_swf_TreeFolderOpen_1283315247:Class = _TreeStyle__embed_css_Assets_swf_TreeFolderOpen_1283315247;
       
      
      public function _TreeStyle()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         var fbs:IFlexModuleFactory = param1;
         var style:CSSStyleDeclaration = StyleManager.getStyleDeclaration("Tree");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration("Tree",style,false);
         }
         if(style.defaultFactory == null)
         {
            style.defaultFactory = function():void
            {
               this.folderClosedIcon = _embed_css_Assets_swf_TreeFolderClosed_1449703875;
               this.verticalAlign = "middle";
               this.disclosureOpenIcon = _embed_css_Assets_swf_TreeDisclosureOpen_1716239150;
               this.paddingRight = 0;
               this.folderOpenIcon = _embed_css_Assets_swf_TreeFolderOpen_1283315247;
               this.defaultLeafIcon = _embed_css_Assets_swf_TreeNodeIcon_1351543526;
               this.paddingLeft = 2;
               this.disclosureClosedIcon = _embed_css_Assets_swf_TreeDisclosureClosed_1293217740;
            };
         }
      }
   }
}
