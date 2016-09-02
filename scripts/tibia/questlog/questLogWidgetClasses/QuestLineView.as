package tibia.questlog.questLogWidgetClasses
{
   import mx.containers.VBox;
   import tibia.questlog.QuestLine;
   import tibia.questlog.QuestFlag;
   import mx.controls.Label;
   import shared.controls.CustomList;
   import mx.events.ListEvent;
   import mx.controls.TextArea;
   import mx.controls.List;
   
   public class QuestLineView extends VBox
   {
       
      
      protected var m_QuestLine:QuestLine = null;
      
      private var m_UncommittedQuestLine:Boolean = false;
      
      protected var m_UIFlagDescription:TextArea = null;
      
      protected var m_UIFlagList:List = null;
      
      protected var m_UILineName:Label;
      
      private var m_UncommittedQuestFlags:Boolean = false;
      
      protected var m_QuestFlags:Array = null;
      
      private var m_UIConstructed:Boolean = false;
      
      public function QuestLineView()
      {
         super();
      }
      
      public function get questFlags() : Array
      {
         return this.m_QuestFlags;
      }
      
      public function set questFlags(param1:Array) : void
      {
         if(this.m_QuestFlags != param1)
         {
            this.m_QuestFlags = param1;
            this.m_UncommittedQuestFlags = true;
            invalidateProperties();
         }
      }
      
      public function get questLine() : QuestLine
      {
         return this.m_QuestLine;
      }
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
         if(this.m_UncommittedQuestLine)
         {
            this.m_UILineName.text = this.m_QuestLine != null?this.m_QuestLine.name:null;
            this.m_UncommittedQuestLine = false;
         }
         if(this.m_UncommittedQuestFlags)
         {
            if(this.m_QuestFlags != null)
            {
               this.m_QuestFlags.sortOn("name");
            }
            this.m_UIFlagList.dataProvider = this.m_QuestFlags;
            this.m_UIFlagList.selectedIndex = -1;
            this.m_UIFlagDescription.text = null;
            this.m_UncommittedQuestFlags = false;
         }
      }
      
      public function get selectedQuestFlag() : QuestFlag
      {
         return this.m_UIFlagList != null?QuestFlag(this.m_UIFlagList.selectedItem):null;
      }
      
      override protected function createChildren() : void
      {
         if(!this.m_UIConstructed)
         {
            super.createChildren();
            this.m_UILineName = new Label();
            this.m_UILineName.percentHeight = NaN;
            this.m_UILineName.percentWidth = 100;
            addChild(this.m_UILineName);
            this.m_UIFlagList = new CustomList();
            this.m_UIFlagList.labelField = "name";
            this.m_UIFlagList.percentHeight = 50;
            this.m_UIFlagList.percentWidth = 100;
            this.m_UIFlagList.selectable = true;
            this.m_UIFlagList.addEventListener(ListEvent.CHANGE,this.onSelectedFlagChange);
            addChild(this.m_UIFlagList);
            this.m_UIFlagDescription = new TextArea();
            this.m_UIFlagDescription.editable = false;
            this.m_UIFlagDescription.percentHeight = 50;
            this.m_UIFlagDescription.percentWidth = 100;
            addChild(this.m_UIFlagDescription);
            this.m_UIConstructed = true;
         }
      }
      
      public function set selectedQuestFlag(param1:QuestFlag) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(this.m_UIFlagList != null)
         {
            _loc2_ = -1;
            if(this.m_QuestFlags != null && param1 != null)
            {
               _loc3_ = this.m_QuestFlags.length - 1;
               while(_loc3_ >= 0)
               {
                  if(QuestFlag(this.m_QuestFlags[_loc3_]).name == param1.name)
                  {
                     _loc2_ = _loc3_;
                     break;
                  }
                  _loc3_--;
               }
            }
            this.m_UIFlagList.selectedIndex = _loc2_;
         }
      }
      
      public function set questLine(param1:QuestLine) : void
      {
         if(this.m_QuestLine != param1)
         {
            this.m_QuestLine = param1;
            this.m_UncommittedQuestLine = true;
            invalidateProperties();
         }
      }
      
      protected function onSelectedFlagChange(param1:ListEvent) : void
      {
         var _loc2_:int = 0;
         if(param1 != null)
         {
            _loc2_ = this.m_UIFlagList.selectedIndex;
            if(this.m_QuestFlags != null && _loc2_ >= 0 && _loc2_ < this.m_QuestFlags.length)
            {
               this.m_UIFlagDescription.text = QuestFlag(this.m_QuestFlags[_loc2_]).description;
            }
         }
      }
   }
}
