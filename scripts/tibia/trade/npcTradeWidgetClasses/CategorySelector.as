package tibia.trade.npcTradeWidgetClasses
{
   import flash.events.MouseEvent;
   import mx.collections.ICollectionView;
   import mx.collections.IList;
   import mx.collections.Sort;
   import mx.collections.SortField;
   import mx.containers.Tile;
   import mx.core.ScrollPolicy;
   import mx.events.CollectionEvent;
   import mx.styles.CSSStyleDeclaration;
   import mx.styles.StyleManager;
   import tibia.appearances.AppearanceTypeRef;
   import tibia.appearances.widgetClasses.SkinnedAppearanceRenderer;
   import tibia.network.Communication;
   
   public class CategorySelector extends Tile
   {
      
      {
         s_InitializeStyle();
      }
      
      private var m_UncommittedDataProvider:Boolean = false;
      
      private var m_InvalidCategoryRenderers:Boolean = false;
      
      protected var m_Sort:Sort = null;
      
      protected var m_DataProvider:IList = null;
      
      public function CategorySelector()
      {
         super();
         horizontalScrollPolicy = ScrollPolicy.OFF;
         verticalScrollPolicy = ScrollPolicy.OFF;
         setStyle("horizontalAlign","center");
         setStyle("horizontalGap",0);
         setStyle("verticalGap",0);
         this.m_Sort = new Sort();
         this.m_Sort.fields = [new SortField("name",true,false,false)];
      }
      
      private static function s_InitializeStyle() : void
      {
         var Selector:String = ".defaultCategoryAppearanceRendererStyle";
         var Decl:CSSStyleDeclaration = StyleManager.getStyleDeclaration(Selector);
         if(Decl == null)
         {
            Decl = new CSSStyleDeclaration();
         }
         Decl.defaultFactory = function():void
         {
            this.backgroundSkin = null;
            this.disabledSkin = null;
            this.highlightSkin = null;
            this.paddingBottom = 1;
            this.paddingLeft = 1;
            this.paddingRight = 1;
            this.paddingTop = 1;
         };
         StyleManager.setStyleDeclaration(Selector,Decl,true);
         Selector = "CategorySelector";
         Decl = StyleManager.getStyleDeclaration(Selector);
         if(Decl == null)
         {
            Decl = new CSSStyleDeclaration();
         }
         Decl.defaultFactory = function():void
         {
            this.rendererStyle = "defaultCategoryAppearanceRendererStyle";
         };
         StyleManager.setStyleDeclaration(Selector,Decl,true);
      }
      
      protected function onDataProviderChange(param1:CollectionEvent) : void
      {
         if(param1 != null)
         {
            this.invalidateCategoryRenderers();
         }
      }
      
      protected function onCategoryClick(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Communication = null;
         if(param1 != null && this.m_DataProvider != null)
         {
            _loc2_ = getChildIndex(SkinnedAppearanceRenderer(param1.currentTarget));
            _loc3_ = this.dataProvider.getItemAt(_loc2_).id;
            _loc4_ = Tibia.s_GetCommunication();
            if(_loc4_ != null && _loc4_.isGameRunning)
            {
            }
         }
      }
      
      override protected function commitProperties() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Object = null;
         var _loc4_:SkinnedAppearanceRenderer = null;
         super.commitProperties();
         if(this.m_UncommittedDataProvider)
         {
            if(this.m_DataProvider is ICollectionView)
            {
               ICollectionView(this.m_DataProvider).sort = this.m_Sort;
               ICollectionView(this.m_DataProvider).refresh();
            }
            this.m_UncommittedDataProvider = false;
         }
         if(this.m_InvalidCategoryRenderers)
         {
            _loc1_ = 0;
            _loc2_ = 0;
            _loc3_ = null;
            _loc4_ = null;
            _loc1_ = numChildren - 1;
            while(_loc1_ >= 0)
            {
               _loc4_ = SkinnedAppearanceRenderer(removeChildAt(_loc1_));
               _loc4_.removeEventListener(MouseEvent.CLICK,this.onCategoryClick);
               _loc1_--;
            }
            if(this.dataProvider != null)
            {
               _loc1_ = 0;
               _loc2_ = this.dataProvider.length;
               while(_loc1_ < _loc2_)
               {
                  _loc3_ = this.dataProvider.getItemAt(_loc1_);
                  _loc4_ = new SkinnedAppearanceRenderer();
                  _loc4_.appearance = new AppearanceTypeRef(_loc3_.iconTypeID,_loc3_.iconTypeData);
                  _loc4_.styleName = getStyle("rendererStyle");
                  _loc4_.toolTip = _loc3_.name;
                  _loc4_.addEventListener(MouseEvent.CLICK,this.onCategoryClick);
                  addChild(_loc4_);
                  _loc1_++;
               }
            }
            this.m_InvalidCategoryRenderers = false;
         }
      }
      
      public function set dataProvider(param1:IList) : void
      {
         if(this.m_DataProvider != param1)
         {
            if(this.m_DataProvider != null)
            {
               this.m_DataProvider.removeEventListener(CollectionEvent.COLLECTION_CHANGE,this.onDataProviderChange);
            }
            this.m_DataProvider = param1;
            this.m_UncommittedDataProvider = true;
            this.invalidateCategoryRenderers();
            invalidateProperties();
            if(this.m_DataProvider != null)
            {
               this.m_DataProvider.addEventListener(CollectionEvent.COLLECTION_CHANGE,this.onDataProviderChange);
            }
         }
      }
      
      protected function invalidateCategoryRenderers() : void
      {
         this.m_InvalidCategoryRenderers = true;
         invalidateProperties();
      }
      
      public function get dataProvider() : IList
      {
         return this.m_DataProvider;
      }
   }
}
