package tibia.reporting
{
   import flash.display.DisplayObjectContainer;
   import flash.events.MouseEvent;
   import mx.containers.ViewStack;
   import mx.controls.Button;
   import mx.resources.ResourceManager;
   import shared.controls.CustomButton;
   import tibia.chat.ChatStorage;
   import tibia.chat.MessageMode;
   import tibia.game.PopUpBase;
   import tibia.network.Communication;
   import tibia.reporting.reportType.ReportableClone;
   import tibia.reporting.reportType.Type;
   import tibia.reporting.reportWidgetClasses.CommentView;
   import tibia.reporting.reportWidgetClasses.ConfirmView;
   import tibia.reporting.reportWidgetClasses.ReasonView;
   import tibia.worldmap.WorldMapStorage;
   
   public class ReportWidget extends PopUpBase
   {
      
      public static const MAX_COMMENT_LENGTH:int = 300;
      
      private static const EXTRA_BUTTON_FLAGS:Array = [{
         "data":EXTRA_BUTTON_PREVIOUS,
         "label":"BTN_PREVIOUS"
      },{
         "data":EXTRA_BUTTON_NEXT,
         "label":"BTN_NEXT"
      },{
         "data":EXTRA_BUTTON_SUBMIT,
         "label":"BTN_SUBMIT"
      }];
      
      private static const EXTRA_BUTTON_MASK:uint = EXTRA_BUTTON_NEXT | EXTRA_BUTTON_PREVIOUS | EXTRA_BUTTON_SUBMIT;
      
      private static const STEP_COMMENT:int = 1;
      
      public static const EXTRA_BUTTON_NEXT:int = 8388608;
      
      public static const EXTRA_BUTTON_PREVIOUS:int = 4194304;
      
      private static var s_ReportTimestamp:Number = NaN;
      
      private static const STEP_REASON:int = 0;
      
      public static const REPORT_ACKNOWLEDGEMENT_TIMEOUT:Number = 600 * 1000;
      
      private static const BUNDLE:String = "ReportWidget";
      
      private static const STEP_CONFIRM:int = 2;
      
      public static const MAX_TRANSLATION_LENGTH:int = 300;
      
      public static const EXTRA_BUTTON_SUBMIT:int = 2097152;
       
      
      private var m_Reportable:IReportable = null;
      
      private var m_UncommittedStep:Boolean = false;
      
      private var m_UIStepConfirm:ConfirmView = null;
      
      private var m_UISteps:ViewStack = null;
      
      private var m_UIStepComment:CommentView = null;
      
      private var m_UIConstructed:Boolean = false;
      
      private var m_UIStepReason:ReasonView = null;
      
      private var m_ExtraButtonFlags:uint = 0;
      
      private var m_Type:int = 0;
      
      private var m_UncommittedExtraButtonFlags:Boolean = false;
      
      private var m_Step:int = -1;
      
      public function ReportWidget(param1:uint, param2:IReportable)
      {
         super();
         if(param1 != Type.REPORT_BOT && param1 != Type.REPORT_NAME && param1 != Type.REPORT_STATEMENT)
         {
            throw new ArgumentError("ReportWidget.ReportWidget: Invalid report type.");
         }
         this.m_Type = param1;
         if(param2 == null)
         {
            throw new ArgumentError("ReportWidget.ReportWidget: Invalid report subject.");
         }
         if(!param2.isReportTypeAllowed(this.m_Type))
         {
            throw new ArgumentError("ReportWidget.ReportWidget: Report type is not supported.");
         }
         this.m_Reportable = ReportableClone.s_CloneReportable(param2);
         height = 500;
         width = 500;
         this.buttonFlags = PopUpBase.BUTTON_NONE;
         keyboardFlags = PopUpBase.KEY_ESCAPE;
         this.step = STEP_REASON;
         switch(this.m_Type)
         {
            case Type.REPORT_BOT:
               title = resourceManager.getString(BUNDLE,"BOT_TITLE");
               break;
            case Type.REPORT_NAME:
               title = resourceManager.getString(BUNDLE,"NAME_TITLE");
               break;
            case Type.REPORT_STATEMENT:
               title = resourceManager.getString(BUNDLE,"STATEMENT_TITLE");
         }
      }
      
      public static function s_ReportTimestampReset() : void
      {
         s_ReportTimestamp = NaN;
      }
      
      public static function s_ReportTimestampCheck() : Boolean
      {
         return isNaN(s_ReportTimestamp) || Tibia.s_FrameTibiaTimestamp - s_ReportTimestamp > REPORT_ACKNOWLEDGEMENT_TIMEOUT;
      }
      
      protected function onExtraButton(param1:MouseEvent) : void
      {
         if(param1 != null && param1.currentTarget is Button)
         {
            switch(Button(param1.currentTarget).data)
            {
               case EXTRA_BUTTON_NEXT:
                  if(this.m_Step == STEP_REASON && this.m_UIStepReason.isDataValid)
                  {
                     this.step = STEP_COMMENT;
                  }
                  else if(this.m_Step == STEP_COMMENT && this.m_UIStepComment.isDataValid)
                  {
                     this.step = STEP_CONFIRM;
                  }
                  break;
               case EXTRA_BUTTON_PREVIOUS:
                  if(this.m_Step == STEP_CONFIRM)
                  {
                     this.step = STEP_COMMENT;
                  }
                  else if(this.m_Step == STEP_COMMENT)
                  {
                     this.step = STEP_REASON;
                  }
                  break;
               case EXTRA_BUTTON_SUBMIT:
                  if(this.m_Step == STEP_CONFIRM && this.m_UIStepConfirm.isDataValid)
                  {
                     this.hide(true);
                  }
            }
         }
      }
      
      override public function hide(param1:Boolean = false) : void
      {
         var _loc3_:Communication = null;
         var _loc2_:int = footer.numChildren - 1;
         while(_loc2_ >= 0)
         {
            footer.getChildAt(_loc2_).removeEventListener(MouseEvent.CLICK,this.onExtraButton);
            _loc2_--;
         }
         if(param1)
         {
            _loc3_ = Tibia.s_GetCommunication();
            if(_loc3_ != null && _loc3_.isGameRunning)
            {
               switch(this.m_Type)
               {
                  case Type.REPORT_BOT:
                     _loc3_.sendBotCRULEVIOLATIONREPORT(this.m_UIStepReason.selectedReason.value,this.m_Reportable.characterName,this.m_UIStepComment.comment);
                     break;
                  case Type.REPORT_NAME:
                     _loc3_.sendNameCRULEVIOLATIONREPORT(this.m_UIStepReason.selectedReason.value,this.m_Reportable.characterName,this.m_UIStepComment.comment,this.m_UIStepComment.translation);
                     break;
                  case Type.REPORT_STATEMENT:
                     _loc3_.sendStatementCRULEVIOLATIONREPORT(this.m_UIStepReason.selectedReason.value,this.m_Reportable.characterName,this.m_UIStepComment.comment,this.m_UIStepComment.translation,this.m_Reportable.ID);
               }
               s_ReportTimestamp = Tibia.s_FrameTibiaTimestamp;
            }
         }
         super.hide(param1);
      }
      
      override protected function commitProperties() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Button = null;
         if(this.m_UncommittedStep)
         {
            switch(this.m_Step)
            {
               case STEP_REASON:
                  this.buttonFlags = EXTRA_BUTTON_NEXT | PopUpBase.BUTTON_CANCEL;
                  break;
               case STEP_COMMENT:
                  this.buttonFlags = EXTRA_BUTTON_NEXT | EXTRA_BUTTON_PREVIOUS | PopUpBase.BUTTON_CANCEL;
                  break;
               case STEP_CONFIRM:
                  this.buttonFlags = EXTRA_BUTTON_PREVIOUS | EXTRA_BUTTON_SUBMIT | PopUpBase.BUTTON_CANCEL;
                  this.m_UIStepConfirm.comment = this.m_UIStepComment.comment;
                  this.m_UIStepConfirm.reason = this.m_UIStepReason.selectedReason;
                  this.m_UIStepConfirm.translation = this.m_UIStepComment.translation;
            }
            this.m_UISteps.selectedIndex = this.m_Step;
            this.m_UncommittedStep = false;
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
      }
      
      public function get reportable() : IReportable
      {
         return this.m_Reportable;
      }
      
      protected function get step() : int
      {
         return this.m_Step;
      }
      
      override protected function createChildren() : void
      {
         if(!this.m_UIConstructed)
         {
            super.createChildren();
            this.m_UIStepReason = new ReasonView(this.m_Type,this.m_Reportable);
            this.m_UIStepReason.percentHeight = 100;
            this.m_UIStepReason.percentWidth = 100;
            this.m_UIStepComment = new CommentView(this.m_Type,this.m_Reportable);
            this.m_UIStepComment.percentHeight = 100;
            this.m_UIStepComment.percentWidth = 100;
            this.m_UIStepConfirm = new ConfirmView(this.m_Type,this.m_Reportable);
            this.m_UIStepConfirm.percentHeight = 100;
            this.m_UIStepConfirm.percentWidth = 100;
            this.m_UISteps = new ViewStack();
            this.m_UISteps.percentHeight = 100;
            this.m_UISteps.percentWidth = 100;
            this.m_UISteps.addChild(this.m_UIStepReason);
            this.m_UISteps.addChild(this.m_UIStepComment);
            this.m_UISteps.addChild(this.m_UIStepConfirm);
            addChild(this.m_UISteps);
            this.m_UIConstructed = true;
         }
      }
      
      override public function show() : void
      {
         var _loc1_:String = null;
         var _loc2_:ChatStorage = null;
         var _loc3_:WorldMapStorage = null;
         if(!s_ReportTimestampCheck())
         {
            _loc1_ = ResourceManager.getInstance().getString(BUNDLE,"ERROR_ACKNOWLEDGEMENT_PENDING");
            _loc2_ = Tibia.s_GetChatStorage();
            if(_loc2_ != null)
            {
               _loc2_.addChannelMessage(-1,-1,null,0,MessageMode.MESSAGE_REPORT,_loc1_);
            }
            _loc3_ = Tibia.s_GetWorldMapStorage();
            if(_loc3_ != null)
            {
               _loc3_.addOnscreenMessage(MessageMode.MESSAGE_REPORT,_loc1_);
            }
         }
         else
         {
            super.show();
         }
      }
      
      protected function set step(param1:int) : void
      {
         if(param1 != STEP_REASON && param1 != STEP_COMMENT && param1 != STEP_CONFIRM)
         {
            param1 = STEP_REASON;
         }
         if(this.m_Step != param1)
         {
            this.m_Step = param1;
            this.m_UncommittedStep = true;
            invalidateProperties();
            invalidateFocus();
         }
      }
      
      override protected function get focusRoot() : DisplayObjectContainer
      {
         return this.m_UISteps.selectedChild;
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
      
      public function get type() : int
      {
         return this.m_Type;
      }
   }
}
