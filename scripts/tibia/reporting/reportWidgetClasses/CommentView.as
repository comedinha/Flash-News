package tibia.reporting.reportWidgetClasses
{
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.TextEvent;
   import mx.controls.Label;
   import mx.controls.TextArea;
   import shared.utility.StringHelper;
   import tibia.chat.ChannelMessage;
   import tibia.input.PreventWhitespaceInput;
   import tibia.reporting.IReportable;
   import tibia.reporting.ReportWidget;
   import tibia.reporting.reportType.Type;
   
   public class CommentView extends ViewBase
   {
      
      private static const BUNDLE:String = "ReportWidget";
       
      
      private var m_UITranslationValidation:Label = null;
      
      private var m_UncommittedComment:Boolean = false;
      
      private var m_UIComment:TextArea = null;
      
      private var m_UncommittedTranslation:Boolean = false;
      
      private var m_UITranslation:TextArea = null;
      
      private var m_Comment:String = null;
      
      private var m_UIConstructed:Boolean = false;
      
      private var m_UICommentValidation:Label = null;
      
      private var m_Translation:String = null;
      
      public function CommentView(param1:uint, param2:IReportable)
      {
         super(param1,param2);
         switch(type)
         {
            case Type.REPORT_BOT:
               header = resourceManager.getString(BUNDLE,"BOT_PROGRESS_STEP_COMMENT",[reportable.characterName]);
               break;
            case Type.REPORT_NAME:
               header = resourceManager.getString(BUNDLE,"NAME_PROGRESS_STEP_COMMENT",[reportable.characterName]);
               break;
            case Type.REPORT_STATEMENT:
               header = resourceManager.getString(BUNDLE,"STATEMENT_PROGRESS_STEP_COMMENT");
         }
         this.comment = null;
         this.translation = null;
      }
      
      override protected function commitProperties() : void
      {
         var _loc1_:int = 0;
         super.commitProperties();
         _loc1_ = 0;
         if(this.m_UncommittedComment)
         {
            this.m_UIComment.text = this.m_Comment;
            if(this.m_Comment != null && this.m_Comment.length > 0)
            {
               _loc1_ = ReportWidget.MAX_COMMENT_LENGTH - this.m_Comment.length;
               this.m_UICommentValidation.styleName = "validationFeedbackValid";
               this.m_UICommentValidation.text = resourceManager.getString(BUNDLE,"VALIDATION_SPACE_REMAINING",[_loc1_]);
            }
            else
            {
               this.m_UICommentValidation.styleName = "validationFeedbackError";
               this.m_UICommentValidation.text = resourceManager.getString(BUNDLE,"VALIDATION_ENTER_COMMENT");
            }
            this.m_UncommittedComment = false;
         }
         if(this.m_UncommittedTranslation)
         {
            if(this.m_UITranslation != null && this.m_UITranslationValidation != null)
            {
               this.m_UITranslation.text = this.m_Translation;
               _loc1_ = ReportWidget.MAX_TRANSLATION_LENGTH - (this.m_Translation != null?this.m_Translation.length:0);
               this.m_UITranslationValidation.styleName = "validationFeedbackValid";
               this.m_UITranslationValidation.text = resourceManager.getString(BUNDLE,"VALIDATION_SPACE_REMAINING",[_loc1_]);
            }
            this.m_UncommittedTranslation = false;
         }
      }
      
      override protected function createChildren() : void
      {
         var _Label:Label = null;
         var ReportedStatement:TextArea = null;
         if(!this.m_UIConstructed)
         {
            super.createChildren();
            _Label = null;
            if(type == Type.REPORT_STATEMENT && reportable is ChannelMessage)
            {
               _Label = new Label();
               _Label.percentHeight = NaN;
               _Label.percentWidth = 100;
               _Label.text = resourceManager.getString(BUNDLE,"LABEL_STATEMENT");
               addChild(_Label);
               ReportedStatement = new TextArea();
               ReportedStatement.editable = false;
               ReportedStatement.percentHeight = 100;
               ReportedStatement.percentWidth = 100;
               ReportedStatement.text = ChannelMessage(reportable).reportableText;
               addChild(ReportedStatement);
            }
            if(type == Type.REPORT_NAME || type == Type.REPORT_STATEMENT)
            {
               _Label = new Label();
               _Label.percentHeight = NaN;
               _Label.percentWidth = 100;
               _Label.text = resourceManager.getString(BUNDLE,"PROMPT_TRANSLATION");
               addChild(_Label);
               this.m_UITranslation = new TextArea();
               this.m_UITranslation.maxChars = ReportWidget.MAX_TRANSLATION_LENGTH;
               this.m_UITranslation.percentHeight = 100;
               this.m_UITranslation.percentWidth = 100;
               this.m_UITranslation.addEventListener(Event.CHANGE,function(param1:Event):void
               {
                  translation = m_UITranslation.text;
               });
               this.m_UITranslation.addEventListener(KeyboardEvent.KEY_DOWN,PreventWhitespaceInput);
               this.m_UITranslation.addEventListener(TextEvent.TEXT_INPUT,PreventWhitespaceInput);
               addChild(this.m_UITranslation);
               this.m_UITranslationValidation = new Label();
               this.m_UITranslationValidation.percentHeight = NaN;
               this.m_UITranslationValidation.percentWidth = 100;
               this.m_UITranslationValidation.setStyle("paddingBottom",-2);
               this.m_UITranslationValidation.setStyle("paddingTop",-2);
               this.m_UITranslationValidation.setStyle("textAlign","right");
               addChild(this.m_UITranslationValidation);
            }
            _Label = new Label();
            _Label.percentHeight = NaN;
            _Label.percentWidth = 100;
            _Label.text = resourceManager.getString(BUNDLE,"PROMPT_COMMENT");
            addChild(_Label);
            this.m_UIComment = new TextArea();
            this.m_UIComment.maxChars = ReportWidget.MAX_COMMENT_LENGTH;
            this.m_UIComment.percentHeight = 100;
            this.m_UIComment.percentWidth = 100;
            this.m_UIComment.addEventListener(Event.CHANGE,function(param1:Event):void
            {
               comment = m_UIComment.text;
            });
            this.m_UIComment.addEventListener(KeyboardEvent.KEY_DOWN,PreventWhitespaceInput);
            this.m_UIComment.addEventListener(TextEvent.TEXT_INPUT,PreventWhitespaceInput);
            addChild(this.m_UIComment);
            this.m_UICommentValidation = new Label();
            this.m_UICommentValidation.percentHeight = NaN;
            this.m_UICommentValidation.percentWidth = 100;
            this.m_UICommentValidation.setStyle("paddingBottom",-2);
            this.m_UICommentValidation.setStyle("paddingTop",-2);
            this.m_UICommentValidation.setStyle("textAlign","right");
            addChild(this.m_UICommentValidation);
            this.m_UIConstructed = true;
         }
      }
      
      public function get comment() : String
      {
         return this.m_Comment;
      }
      
      public function set translation(param1:String) : void
      {
         if(param1 != null)
         {
            param1 = StringHelper.s_Trim(param1);
            if(param1.length > ReportWidget.MAX_TRANSLATION_LENGTH)
            {
               throw new ArgumentError("CommentView.set translation: Invalid translation.");
            }
         }
         if(this.m_Translation != param1 || param1 == null)
         {
            this.m_Translation = param1;
            this.m_UncommittedTranslation = true;
            invalidateProperties();
         }
      }
      
      override public function get isDataValid() : Boolean
      {
         return this.m_Comment != null && this.m_Comment.length > 0 && this.m_Comment.length <= ReportWidget.MAX_COMMENT_LENGTH;
      }
      
      public function get translation() : String
      {
         return this.m_Translation;
      }
      
      public function set comment(param1:String) : void
      {
         if(param1 != null)
         {
            param1 = StringHelper.s_Trim(param1);
            if(param1.length > ReportWidget.MAX_COMMENT_LENGTH)
            {
               throw new ArgumentError("CommentView.set comment: Invalid comment.");
            }
         }
         if(this.m_Comment != param1 || param1 == null)
         {
            this.m_Comment = param1;
            this.m_UncommittedComment = true;
            invalidateProperties();
         }
      }
   }
}
