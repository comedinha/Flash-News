package tibia.trade.npcTradeWidgetClasses
{
   import mx.controls.List;
   import mx.collections.IList;
   import mx.events.CollectionEvent;
   import mx.events.ListEvent;
   import flash.events.Event;
   import mx.events.ScrollEvent;
   import shared.controls.CustomList;
   import mx.core.ClassFactory;
   import mx.core.ScrollPolicy;
   import mx.events.FlexEvent;
   
   public class ListObjectRefSelector extends ObjectRefSelectorBase
   {
      
      private static const BUNDLE:String = "NPCTradeWidget";
       
      
      protected var m_UIList:List = null;
      
      private var m_UncommittedSelectedIndex:Boolean = false;
      
      private var m_UncommittedDataProvider:Boolean = false;
      
      private var m_LastVerticalScrollPosition:Number = -1;
      
      public function ListObjectRefSelector()
      {
         super();
      }
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
         if(this.m_UncommittedDataProvider)
         {
            if(this.m_UIList.dataProvider != null)
            {
               (this.m_UIList.dataProvider as IList).removeEventListener(CollectionEvent.COLLECTION_CHANGE,this.onCollectionChange);
            }
            this.m_UIList.dataProvider = dataProvider;
            (this.m_UIList.dataProvider as IList).addEventListener(CollectionEvent.COLLECTION_CHANGE,this.onCollectionChange);
            this.m_UIList.verticalScrollPosition = 0;
            this.m_LastVerticalScrollPosition = this.m_UIList.verticalScrollPosition;
            this.m_UncommittedDataProvider = false;
         }
         if(this.m_UncommittedSelectedIndex)
         {
            this.m_UIList.selectedIndex = selectedIndex;
            if(selectedIndex < 0)
            {
               this.m_UIList.verticalScrollPosition = 0;
            }
            this.m_UncommittedSelectedIndex = false;
         }
      }
      
      private function onListChange(param1:ListEvent) : void
      {
         this.selectedIndex = param1.rowIndex;
         this.m_LastVerticalScrollPosition = this.m_UIList.verticalScrollPosition;
      }
      
      override public function set selectedIndex(param1:int) : void
      {
         if(selectedIndex != param1)
         {
            super.selectedIndex = param1;
            this.m_UncommittedSelectedIndex = true;
            invalidateProperties();
         }
      }
      
      override public function get layout() : int
      {
         return ObjectRefSelectorBase.LAYOUT_LIST;
      }
      
      override public function set dataProvider(param1:IList) : void
      {
         if(dataProvider != param1)
         {
            super.dataProvider = param1;
            this.m_UncommittedDataProvider = true;
            invalidateProperties();
         }
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         super.updateDisplayList(param1,param2);
         this.m_UIList.setActualSize(param1,param2);
         this.m_UIList.move(0,0);
         this.m_UIList.visible = true;
      }
      
      private function onListScroll(param1:Event) : void
      {
         if(param1 is ScrollEvent)
         {
            this.m_LastVerticalScrollPosition = (param1 as ScrollEvent).position;
         }
         else
         {
            this.m_LastVerticalScrollPosition = this.m_UIList.verticalScrollPosition;
         }
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this.m_UIList = new CustomList();
         this.m_UIList.dataProvider = m_DataProvider;
         this.m_UIList.itemRenderer = new ClassFactory(ListObjectRefItemRenderer);
         this.m_UIList.percentHeight = 100;
         this.m_UIList.percentWidth = 100;
         this.m_UIList.styleName = this;
         this.m_UIList.verticalScrollPolicy = ScrollPolicy.ON;
         this.m_UIList.addEventListener(ListEvent.CHANGE,this.onListChange);
         this.m_UIList.addEventListener(ScrollEvent.SCROLL,this.onListScroll);
         this.m_UIList.addEventListener(FlexEvent.UPDATE_COMPLETE,this.onListScroll);
         addChild(this.m_UIList);
      }
      
      private function onCollectionChange(param1:CollectionEvent) : void
      {
         this.m_UIList.verticalScrollPosition = Math.min(Math.max(0,this.m_LastVerticalScrollPosition),this.m_UIList.maxVerticalScrollPosition);
      }
      
      override protected function measure() : void
      {
         super.measure();
         measuredWidth = this.m_UIList.measuredWidth;
         measuredMinWidth = this.m_UIList.measuredMinWidth;
         measuredHeight = this.m_UIList.measuredHeight;
         measuredMinHeight = this.m_UIList.measuredMinHeight;
      }
   }
}
