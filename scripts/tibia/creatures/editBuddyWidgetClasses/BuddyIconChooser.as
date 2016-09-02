package tibia.creatures.editBuddyWidgetClasses
{
   import mx.containers.HBox;
   import mx.styles.CSSStyleDeclaration;
   import mx.styles.StyleManager;
   import tibia.creatures.buddylistClasses.BuddyIcon;
   import tibia.creatures.buddylistWidgetClasses.BuddyIconRenderer;
   import flash.events.MouseEvent;
   import flash.events.Event;
   import mx.core.ScrollPolicy;
   
   public class BuddyIconChooser extends HBox
   {
      
      {
         s_InitialiseStyle();
      }
      
      private var m_UncommittedDataProvider:Boolean = false;
      
      protected var m_SelectedIndex:int = -1;
      
      private var m_UncommittedSelectedIndex:Boolean = false;
      
      protected var m_DataProvider:Vector.<BuddyIcon> = null;
      
      public function BuddyIconChooser()
      {
         super();
         horizontalScrollPolicy = ScrollPolicy.OFF;
         verticalScrollPolicy = ScrollPolicy.OFF;
      }
      
      private static function s_InitialiseStyle() : void
      {
         var Selector:String = "BuddyIconChooser";
         var Decl:CSSStyleDeclaration = StyleManager.getStyleDeclaration(Selector);
         if(Decl == null)
         {
            Decl = new CSSStyleDeclaration(Selector);
         }
         Decl.defaultFactory = function():void
         {
            this.horizontalGap = 2;
            this.verticalGap = 2;
            this.paddingBottom = 0;
            this.paddingLeft = 0;
            this.paddingRight = 0;
            this.paddingTop = 0;
         };
         StyleManager.setStyleDeclaration(Selector,Decl,true);
      }
      
      public function set selectedIndex(param1:int) : void
      {
         if(this.m_DataProvider != null)
         {
            param1 = Math.max(0,Math.min(param1,this.m_DataProvider.length - 1));
         }
         else
         {
            param1 = -1;
         }
         if(this.m_SelectedIndex != param1)
         {
            this.m_SelectedIndex = param1;
            this.m_UncommittedSelectedIndex = true;
            invalidateProperties();
         }
      }
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:BuddyIconRenderer = null;
         if(this.m_UncommittedDataProvider)
         {
            _loc1_ = numChildren - 1;
            while(_loc1_ >= 0)
            {
               _loc3_ = BuddyIconRenderer(removeChildAt(_loc1_));
               _loc3_.removeEventListener(MouseEvent.MOUSE_DOWN,this.onSelectionChange);
               _loc1_--;
            }
            if(this.m_DataProvider != null)
            {
               _loc1_ = 0;
               _loc2_ = this.m_DataProvider.length;
               while(_loc1_ < _loc2_)
               {
                  _loc3_ = BuddyIconRenderer(addChild(new BuddyIconRenderer()));
                  _loc3_.ID = this.m_DataProvider[_loc1_].ID;
                  _loc3_.styleName = "withBackground";
                  _loc3_.addEventListener(MouseEvent.MOUSE_DOWN,this.onSelectionChange);
                  _loc1_++;
               }
            }
            this.m_UncommittedDataProvider = false;
         }
         if(this.m_UncommittedSelectedIndex)
         {
            _loc1_ = numChildren - 1;
            while(_loc1_ >= 0)
            {
               _loc3_ = BuddyIconRenderer(getChildAt(_loc1_));
               _loc3_.highlight = this.m_SelectedIndex == _loc1_;
               _loc1_--;
            }
            this.m_UncommittedSelectedIndex = false;
         }
      }
      
      protected function onSelectionChange(param1:Event) : void
      {
         if(param1 != null)
         {
            this.selectedID = BuddyIconRenderer(param1.currentTarget).ID;
         }
      }
      
      public function set dataProvider(param1:Vector.<BuddyIcon>) : void
      {
         this.m_DataProvider = param1;
         this.m_UncommittedDataProvider = true;
         invalidateProperties();
         this.selectedIndex = this.m_DataProvider != null?0:-1;
      }
      
      public function get selectedIndex() : int
      {
         return this.m_SelectedIndex;
      }
      
      public function set selectedID(param1:int) : void
      {
         var _loc2_:int = -1;
         if(this.m_DataProvider != null)
         {
            _loc2_ = this.m_DataProvider.length - 1;
            while(_loc2_ >= 0)
            {
               if(this.m_DataProvider[_loc2_].ID == param1)
               {
                  break;
               }
               _loc2_--;
            }
         }
         this.selectedIndex = _loc2_;
      }
      
      public function get dataProvider() : Vector.<BuddyIcon>
      {
         return this.m_DataProvider;
      }
      
      public function get selectedID() : int
      {
         if(this.m_SelectedIndex > -1)
         {
            return this.m_DataProvider[this.m_SelectedIndex].ID;
         }
         return BuddyIcon.DEFAULT_ICON;
      }
   }
}
