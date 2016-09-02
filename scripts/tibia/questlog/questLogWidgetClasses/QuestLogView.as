package tibia.questlog.questLogWidgetClasses
{
   import mx.containers.VBox;
   import shared.controls.CustomList;
   import mx.events.ListEvent;
   import tibia.questlog.QuestLine;
   import mx.controls.List;
   
   public class QuestLogView extends VBox
   {
      
      private static const BUNDLE:String = "QuestLogWidget";
       
      
      private var m_UncommittedQuestLines:Boolean = false;
      
      protected var m_QuestLines:Array = null;
      
      private var m_UIConstructed:Boolean = false;
      
      protected var m_UILines:List = null;
      
      public function QuestLogView()
      {
         super();
      }
      
      override protected function createChildren() : void
      {
         if(!this.m_UIConstructed)
         {
            super.createChildren();
            this.m_UILines = new CustomList();
            this.m_UILines.doubleClickEnabled = true;
            this.m_UILines.labelFunction = this.getQuestLineLabel;
            this.m_UILines.percentHeight = 100;
            this.m_UILines.percentWidth = 100;
            this.m_UILines.selectable = true;
            this.m_UILines.addEventListener(ListEvent.ITEM_DOUBLE_CLICK,this.onLineDoubleClick);
            addChild(this.m_UILines);
            this.m_UIConstructed = true;
         }
      }
      
      protected function onLineDoubleClick(param1:ListEvent) : void
      {
         if(param1 != null && (!param1.cancelable || !param1.isDefaultPrevented()))
         {
            dispatchEvent(param1.clone());
         }
      }
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
         if(this.m_UncommittedQuestLines)
         {
            if(this.m_QuestLines != null)
            {
               this.m_QuestLines.sortOn("name");
            }
            this.m_UILines.dataProvider = this.m_QuestLines;
            this.m_UILines.selectedIndex = -1;
            this.m_UncommittedQuestLines = false;
         }
      }
      
      private function getQuestLineLabel(param1:Object) : String
      {
         var _loc2_:QuestLine = param1 as QuestLine;
         if(_loc2_.completed)
         {
            return _loc2_.name + resourceManager.getString(BUNDLE,"QUEST_LINE_COMPLETED_TAG");
         }
         return _loc2_.name;
      }
      
      public function set selectedQuestLine(param1:QuestLine) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(this.m_UILines != null)
         {
            _loc2_ = -1;
            if(this.m_QuestLines != null && param1 != null)
            {
               _loc3_ = this.m_QuestLines.length - 1;
               while(_loc3_ >= 0)
               {
                  if(QuestLine(this.m_QuestLines[_loc3_]).ID == param1.ID)
                  {
                     _loc2_ = _loc3_;
                     break;
                  }
                  _loc3_--;
               }
            }
            this.m_UILines.selectedIndex = _loc2_;
         }
      }
      
      public function set questLines(param1:Array) : void
      {
         if(this.m_QuestLines != param1)
         {
            this.m_QuestLines = param1;
            this.m_UncommittedQuestLines = true;
            invalidateProperties();
         }
      }
      
      public function get selectedQuestLine() : QuestLine
      {
         return this.m_UILines != null?QuestLine(this.m_UILines.selectedItem):null;
      }
      
      public function get questLines() : Array
      {
         return this.m_QuestLines;
      }
   }
}
