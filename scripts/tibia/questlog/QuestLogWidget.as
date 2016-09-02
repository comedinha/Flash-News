package tibia.questlog
{
   import tibia.game.PopUpBase;
   import flash.events.MouseEvent;
   import mx.controls.Button;
   import mx.events.CloseEvent;
   import tibia.questlog.questLogWidgetClasses.QuestLogView;
   import flash.events.Event;
   import tibia.network.Communication;
   import shared.controls.CustomButton;
   import mx.events.ListEvent;
   import tibia.questlog.questLogWidgetClasses.QuestLineView;
   import mx.containers.ViewStack;
   
   public class QuestLogWidget extends PopUpBase
   {
      
      private static const EXTRA_BUTTON_FLAGS:Array = [{
         "data":EXTRA_BUTTON_SHOW,
         "label":"BTN_SHOW"
      },{
         "data":EXTRA_BUTTON_CLOSE,
         "label":"BTN_CLOSE"
      }];
      
      private static const EXTRA_BUTTON_MASK:uint = EXTRA_BUTTON_CLOSE | EXTRA_BUTTON_SHOW;
      
      private static const BUNDLE:String = "QuestLogWidget";
      
      private static const STATE_QUEST_LOG:int = 0;
      
      public static const EXTRA_BUTTON_CLOSE:uint = 8388608;
      
      public static const EXTRA_BUTTON_SHOW:uint = 4194304;
      
      private static const STATE_QUEST_LINE:int = 1;
       
      
      private var m_UncommittedState:Boolean = false;
      
      private var m_UncommittedQuestFlags:Boolean = false;
      
      protected var m_UIQuestLogView:QuestLogView = null;
      
      protected var m_QuestFlags:Array = null;
      
      protected var m_UIViewStack:ViewStack = null;
      
      protected var m_State:int = -1;
      
      private var m_UncommittedQuestLines:Boolean = false;
      
      protected var m_QuestLines:Array = null;
      
      private var m_UIConstructed:Boolean = false;
      
      protected var m_UIQuestLineView:QuestLineView = null;
      
      private var m_UncommittedExtraButtonFlags:Boolean = false;
      
      protected var m_ExtraButtonFlags:uint = 0;
      
      public function QuestLogWidget()
      {
         super();
         height = 350;
         width = 350;
         this.buttonFlags = EXTRA_BUTTON_CLOSE | EXTRA_BUTTON_SHOW;
         keyboardFlags = PopUpBase.KEY_ESCAPE;
         this.state = STATE_QUEST_LOG;
      }
      
      public function set questLines(param1:Array) : void
      {
         if(this.m_QuestLines != param1)
         {
            this.m_QuestLines = param1;
            this.m_UncommittedQuestLines = true;
            invalidateProperties();
            this.state = STATE_QUEST_LOG;
         }
      }
      
      override public function hide(param1:Boolean = false) : void
      {
         var _loc2_:int = footer.numChildren - 1;
         while(_loc2_ >= 0)
         {
            footer.getChildAt(_loc2_).removeEventListener(MouseEvent.CLICK,this.onExtraButton);
            _loc2_--;
         }
         super.hide(param1);
      }
      
      protected function onExtraButton(param1:MouseEvent) : void
      {
         var _loc2_:Button = null;
         var _loc3_:CloseEvent = null;
         if(param1 != null)
         {
            _loc2_ = param1.currentTarget as Button;
            if(_loc2_ == null)
            {
               return;
            }
            switch(uint(_loc2_.data))
            {
               case EXTRA_BUTTON_CLOSE:
                  if(this.state == STATE_QUEST_LOG)
                  {
                     _loc3_ = new CloseEvent(CloseEvent.CLOSE,true,false);
                     _loc3_.detail = PopUpBase.BUTTON_CLOSE;
                     dispatchEvent(_loc3_);
                     if(!_loc3_.cancelable || !_loc3_.isDefaultPrevented())
                     {
                        this.hide(false);
                     }
                  }
                  else
                  {
                     this.state = STATE_QUEST_LOG;
                  }
                  break;
               case EXTRA_BUTTON_SHOW:
                  this.onQuestLineSelected(param1);
            }
         }
      }
      
      public function get questLines() : Array
      {
         return this.m_QuestLines;
      }
      
      public function set questFlags(param1:Array) : void
      {
         if(this.m_QuestFlags != param1)
         {
            this.m_QuestFlags = param1;
            this.m_UncommittedQuestFlags = true;
            invalidateProperties();
            this.state = STATE_QUEST_LINE;
         }
      }
      
      public function get questFlags() : Array
      {
         return this.m_QuestFlags;
      }
      
      protected function get state() : int
      {
         return this.m_State;
      }
      
      protected function onQuestLineSelected(param1:Event) : void
      {
         var _loc2_:Communication = null;
         if(param1 != null && this.m_UIQuestLogView.selectedQuestLine != null && this.state == STATE_QUEST_LOG)
         {
            _loc2_ = Tibia.s_GetCommunication();
            if(_loc2_ != null && _loc2_.isGameRunning)
            {
               _loc2_.sendCGETQUESTLINE(this.m_UIQuestLogView.selectedQuestLine.ID);
            }
         }
      }
      
      override protected function commitProperties() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Button = null;
         if(this.m_UncommittedState)
         {
            switch(this.m_State)
            {
               case STATE_QUEST_LINE:
                  this.buttonFlags = EXTRA_BUTTON_CLOSE;
                  title = resourceManager.getString(BUNDLE,"TITLE_QUEST_LINE");
                  this.m_UIViewStack.selectedIndex = 1;
                  this.m_UIQuestLineView.questLine = this.m_UIQuestLogView.selectedQuestLine;
                  this.m_UIQuestLineView.selectedQuestFlag = null;
                  break;
               case STATE_QUEST_LOG:
                  this.buttonFlags = EXTRA_BUTTON_CLOSE | EXTRA_BUTTON_SHOW;
                  title = resourceManager.getString(BUNDLE,"TITLE_QUEST_LOG");
                  this.m_UIViewStack.selectedIndex = 0;
                  this.m_UIQuestLogView.selectedQuestLine = null;
            }
            this.m_UncommittedState = false;
         }
         super.commitProperties();
         if(this.m_UncommittedExtraButtonFlags)
         {
            _loc1_ = 0;
            _loc2_ = 0;
            _loc3_ = null;
            _loc1_ = footer.numChildren - 1;
            while(_loc1_ >= 0)
            {
               _loc3_ = Button(footer.getChildAt(_loc1_));
               if((uint(_loc3_.data) & EXTRA_BUTTON_MASK) != 0)
               {
                  _loc3_.removeEventListener(MouseEvent.CLICK,this.onExtraButton);
                  footer.removeChildAt(_loc1_);
               }
               _loc1_--;
            }
            _loc1_ = 0;
            while(_loc1_ < EXTRA_BUTTON_FLAGS.length)
            {
               if((this.m_ExtraButtonFlags & EXTRA_BUTTON_FLAGS[_loc1_].data) != 0)
               {
                  _loc3_ = new CustomButton();
                  _loc3_.enabled = (this.m_ExtraButtonFlags & PopUpBase.DISABLE_BUTTONS) == 0;
                  _loc3_.label = resourceManager.getString(BUNDLE,EXTRA_BUTTON_FLAGS[_loc1_].label);
                  _loc3_.data = EXTRA_BUTTON_FLAGS[_loc1_].data;
                  _loc3_.addEventListener(MouseEvent.CLICK,this.onExtraButton);
                  footer.addChildAt(_loc3_,_loc2_);
                  _loc2_++;
               }
               _loc1_++;
            }
            this.m_UncommittedExtraButtonFlags = true;
         }
         if(this.m_UncommittedQuestLines)
         {
            this.m_UIQuestLogView.questLines = this.m_QuestLines;
            this.m_UIQuestLogView.selectedQuestLine = null;
            this.m_UncommittedQuestLines = false;
         }
         if(this.m_UncommittedQuestFlags)
         {
            this.m_UIQuestLineView.questFlags = this.m_QuestFlags;
            this.m_UIQuestLineView.selectedQuestFlag = null;
            this.m_UncommittedQuestFlags = false;
         }
      }
      
      override protected function createChildren() : void
      {
         if(!this.m_UIConstructed)
         {
            super.createChildren();
            this.m_UIQuestLogView = new QuestLogView();
            this.m_UIQuestLogView.percentHeight = 100;
            this.m_UIQuestLogView.percentWidth = 100;
            this.m_UIQuestLogView.addEventListener(ListEvent.ITEM_DOUBLE_CLICK,this.onQuestLineSelected);
            this.m_UIQuestLineView = new QuestLineView();
            this.m_UIQuestLineView.percentHeight = 100;
            this.m_UIQuestLineView.percentWidth = 100;
            this.m_UIViewStack = new ViewStack();
            this.m_UIViewStack.percentHeight = 100;
            this.m_UIViewStack.percentWidth = 100;
            this.m_UIViewStack.addChild(this.m_UIQuestLogView);
            this.m_UIViewStack.addChild(this.m_UIQuestLineView);
            addChild(this.m_UIViewStack);
            this.m_UIConstructed = true;
         }
      }
      
      protected function set state(param1:int) : void
      {
         if(param1 != STATE_QUEST_LINE && param1 != STATE_QUEST_LOG)
         {
            param1 = STATE_QUEST_LOG;
         }
         if(this.m_State != param1)
         {
            this.m_State = param1;
            this.m_UncommittedState = true;
            invalidateProperties();
         }
      }
      
      override public function set buttonFlags(param1:uint) : void
      {
         super.buttonFlags = param1;
         var _loc2_:uint = param1 & EXTRA_BUTTON_MASK;
         if(this.m_ExtraButtonFlags != _loc2_)
         {
            this.m_ExtraButtonFlags = _loc2_;
            this.m_UncommittedExtraButtonFlags = true;
            invalidateProperties();
         }
      }
      
      override public function get buttonFlags() : uint
      {
         return super.buttonFlags | this.m_ExtraButtonFlags;
      }
   }
}
