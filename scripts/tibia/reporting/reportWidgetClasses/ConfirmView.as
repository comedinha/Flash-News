package tibia.reporting.reportWidgetClasses
{
   import tibia.reporting.reportType.Reason;
   import mx.controls.TextArea;
   import mx.containers.GridRow;
   import mx.containers.Grid;
   import tibia.reporting.reportType.Type;
   import tibia.chat.ChannelMessage;
   import shared.utility.StringHelper;
   import tibia.reporting.ReportWidget;
   import mx.core.UIComponent;
   import mx.containers.GridItem;
   import mx.controls.Label;
   import tibia.reporting.IReportable;
   
   public class ConfirmView extends ViewBase
   {
      
      private static const BUNDLE:String = "ReportWidget";
       
      
      private var m_UIReason:TextArea = null;
      
      private var m_UncommittedComment:Boolean = false;
      
      private var m_UIComment:TextArea = null;
      
      private var m_UncommittedTranslation:Boolean = false;
      
      private var m_UITranslation:TextArea = null;
      
      private var m_Comment:String = null;
      
      private var m_UIConstructed:Boolean = false;
      
      private var m_UncommittedReason:Boolean = false;
      
      private var m_Reason:Reason = null;
      
      private var m_Translation:String = null;
      
      public function ConfirmView(param1:uint, param2:IReportable)
      {
         super(param1,param2);
         switch(type)
         {
            case Type.REPORT_BOT:
               header = resourceManager.getString(BUNDLE,"BOT_PROGRESS_STEP_CONFIRM");
               break;
            case Type.REPORT_NAME:
               header = resourceManager.getString(BUNDLE,"NAME_PROGRESS_STEP_CONFIRM");
               break;
            case Type.REPORT_STATEMENT:
               header = resourceManager.getString(BUNDLE,"STATEMENT_PROGRESS_STEP_CONFIRM");
         }
      }
      
      public function get reason() : Reason
      {
         return this.m_Reason;
      }
      
      public function set reason(param1:Reason) : void
      {
         if(this.m_Reason != param1)
         {
            this.m_Reason = param1;
            this.m_UncommittedReason = true;
            invalidateProperties();
         }
      }
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
         if(this.m_UncommittedComment)
         {
            this.m_UIComment.text = this.m_Comment;
            this.m_UncommittedComment = false;
         }
         if(this.m_UncommittedReason)
         {
            this.m_UIReason.text = this.m_Reason != null?this.m_Reason.name:null;
            this.m_UncommittedComment = false;
         }
         if(this.m_UncommittedTranslation)
         {
            if(this.m_UITranslation != null)
            {
               this.m_UITranslation.text = this.m_Translation;
            }
            this.m_UncommittedTranslation = false;
         }
      }
      
      override protected function createChildren() : void
      {
         var _loc1_:GridRow = null;
         var _loc2_:Grid = null;
         var _loc3_:TextArea = null;
         var _loc4_:TextArea = null;
         if(!this.m_UIConstructed)
         {
            super.createChildren();
            _loc1_ = null;
            _loc2_ = new Grid();
            _loc2_.percentHeight = 100;
            _loc2_.percentWidth = 100;
            _loc2_.setStyle("horizontalGap",2);
            _loc2_.setStyle("verticalGap",2);
            _loc3_ = new TextArea();
            _loc3_.editable = false;
            _loc3_.height = 18;
            _loc3_.percentHeight = NaN;
            _loc3_.percentWidth = 100;
            _loc3_.text = reportable.characterName;
            _loc3_.width = NaN;
            _loc1_ = this.makeGridRow("LABEL_NAME",_loc3_);
            _loc1_.percentHeight = NaN;
            _loc1_.percentWidth = 100;
            _loc2_.addChild(_loc1_);
            this.m_UIReason = new TextArea();
            this.m_UIReason.editable = false;
            this.m_UIReason.height = 18;
            this.m_UIReason.percentHeight = NaN;
            this.m_UIReason.percentWidth = 100;
            this.m_UIReason.width = NaN;
            _loc1_ = this.makeGridRow("LABEL_REASON",this.m_UIReason);
            _loc1_.percentHeight = NaN;
            _loc1_.percentWidth = 100;
            _loc2_.addChild(_loc1_);
            if(type == Type.REPORT_STATEMENT && reportable is ChannelMessage)
            {
               _loc4_ = new TextArea();
               _loc4_.editable = false;
               _loc4_.percentHeight = 100;
               _loc4_.percentWidth = 100;
               _loc4_.text = ChannelMessage(reportable).reportableText;
               addChild(_loc4_);
               _loc1_ = this.makeGridRow("LABEL_STATEMENT",_loc4_);
               _loc1_.percentHeight = 100;
               _loc1_.percentWidth = 100;
               _loc2_.addChild(_loc1_);
            }
            if(type == Type.REPORT_NAME || type == Type.REPORT_STATEMENT)
            {
               this.m_UITranslation = new TextArea();
               this.m_UITranslation.editable = false;
               this.m_UITranslation.percentHeight = 100;
               this.m_UITranslation.percentWidth = 100;
               _loc1_ = this.makeGridRow("LABEL_TRANSLATION",this.m_UITranslation);
               _loc1_.percentHeight = 100;
               _loc1_.percentWidth = 100;
               _loc2_.addChild(_loc1_);
            }
            this.m_UIComment = new TextArea();
            this.m_UIComment.editable = false;
            this.m_UIComment.percentHeight = 100;
            this.m_UIComment.percentWidth = 100;
            _loc1_ = this.makeGridRow("LABEL_COMMENT",this.m_UIComment);
            _loc1_.percentHeight = 100;
            _loc1_.percentWidth = 100;
            _loc2_.addChild(_loc1_);
            addChild(_loc2_);
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
               throw new ArgumentError("ConfirmView.set translation: Invalid translation.");
            }
         }
         if(this.m_Translation != param1 || param1 == null)
         {
            this.m_Translation = param1;
            this.m_UncommittedTranslation = true;
            invalidateProperties();
         }
      }
      
      private function makeGridRow(param1:String, param2:UIComponent) : GridRow
      {
         var _loc3_:GridRow = new GridRow();
         var _loc4_:GridItem = new GridItem();
         var _loc5_:Label = new Label();
         _loc5_.percentHeight = NaN;
         _loc5_.percentWidth = 100;
         _loc5_.text = resourceManager.getString(BUNDLE,param1);
         _loc4_.addChild(_loc5_);
         _loc3_.addChild(_loc4_);
         _loc4_ = new GridItem();
         _loc4_.percentHeight = NaN;
         _loc4_.percentWidth = 100;
         _loc4_.addChild(param2);
         _loc3_.addChild(_loc4_);
         return _loc3_;
      }
      
      override public function get isDataValid() : Boolean
      {
         return true;
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
               throw new ArgumentError("ConfirmView.set comment: Invalid comment.");
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
