package tibia.reporting.reportWidgetClasses
{
   import mx.controls.Label;
   import tibia.reporting.reportType.Reason;
   import mx.controls.List;
   import mx.controls.TextArea;
   import shared.controls.CustomList;
   import mx.events.ListEvent;
   import tibia.reporting.IReportable;
   import tibia.reporting.reportType.Type;
   
   public class ReasonView extends ViewBase
   {
      
      private static const BUNDLE:String = "ReportWidget";
       
      
      private var m_UIReasonValidation:Label = null;
      
      private var m_UIReasons:List = null;
      
      private var m_UncommittedSelectedReason:Boolean = false;
      
      private var m_SelectedReason:Reason = null;
      
      private var m_UIDescription:TextArea = null;
      
      private var m_UIConstructed:Boolean = false;
      
      private var m_Reasons:Array = null;
      
      private var m_UncommittedReasons:Boolean = false;
      
      public function ReasonView(param1:uint, param2:IReportable)
      {
         super(param1,param2);
         switch(type)
         {
            case Type.REPORT_BOT:
               header = resourceManager.getString(BUNDLE,"BOT_PROGRESS_STEP_REASON");
               this.reasons = Type.REPORT_BOT_REASONS;
               break;
            case Type.REPORT_NAME:
               header = resourceManager.getString(BUNDLE,"NAME_PROGRESS_STEP_REASON");
               this.reasons = Type.REPORT_NAME_REASONS;
               break;
            case Type.REPORT_STATEMENT:
               header = resourceManager.getString(BUNDLE,"STATEMENT_PROGRESS_STEP_REASON");
               this.reasons = Type.REPORT_STATEMENT_REASONS;
         }
         this.selectedReason = null;
      }
      
      public function set selectedReason(param1:Reason) : void
      {
         var _loc3_:int = 0;
         var _loc2_:Boolean = false;
         if(param1 == null)
         {
            _loc2_ = true;
         }
         else if(this.m_Reasons != null)
         {
            _loc3_ = this.m_Reasons.length;
            while(_loc3_ >= 0)
            {
               if(this.m_Reasons[_loc3_] === param1)
               {
                  _loc2_ = true;
                  break;
               }
               _loc3_--;
            }
         }
         if(!_loc2_)
         {
            throw new ArgumentError("ReasonView.set selectedReason: Invalid reason.");
         }
         if(this.m_SelectedReason != param1 || param1 == null)
         {
            this.m_SelectedReason = param1;
            this.m_UncommittedSelectedReason = true;
            invalidateProperties();
         }
      }
      
      override public function get isDataValid() : Boolean
      {
         return this.m_SelectedReason != null;
      }
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
         if(this.m_UncommittedReasons)
         {
            this.m_UIReasons.dataProvider = this.m_Reasons;
            this.m_UIReasons.selectedItem = null;
            this.m_UncommittedReasons = false;
         }
         if(this.m_UncommittedSelectedReason)
         {
            this.m_UIReasons.selectedItem = this.m_SelectedReason;
            if(this.m_SelectedReason != null)
            {
               this.m_UIDescription.text = this.m_SelectedReason.description;
               this.m_UIReasonValidation.styleName = "validationFeedbackValid";
               this.m_UIReasonValidation.text = "";
            }
            else
            {
               this.m_UIDescription.text = "";
               this.m_UIReasonValidation.styleName = "validationFeedbackError";
               this.m_UIReasonValidation.text = resourceManager.getString(BUNDLE,"VALIDATION_SELECT_REASON");
            }
            this.m_UncommittedSelectedReason = false;
         }
      }
      
      protected function set reasons(param1:Array) : void
      {
         if(this.m_Reasons != param1)
         {
            this.m_Reasons = param1;
            this.m_UncommittedReasons = true;
            invalidateProperties();
            this.selectedReason = null;
         }
      }
      
      protected function get reasons() : Array
      {
         return this.m_Reasons;
      }
      
      override protected function createChildren() : void
      {
         if(!this.m_UIConstructed)
         {
            super.createChildren();
            this.m_UIReasons = new CustomList();
            this.m_UIReasons.height = 176;
            this.m_UIReasons.labelField = "name";
            this.m_UIReasons.percentHeight = NaN;
            this.m_UIReasons.percentWidth = 100;
            this.m_UIReasons.width = NaN;
            this.m_UIReasons.addEventListener(ListEvent.CHANGE,function(param1:ListEvent):void
            {
               selectedReason = Reason(m_UIReasons.selectedItem);
            });
            addChild(this.m_UIReasons);
            this.m_UIDescription = new TextArea();
            this.m_UIDescription.editable = false;
            this.m_UIDescription.percentHeight = 100;
            this.m_UIDescription.percentWidth = 100;
            this.m_UIDescription.styleName = "popUpTextComponent";
            addChild(this.m_UIDescription);
            this.m_UIReasonValidation = new Label();
            this.m_UIReasonValidation.percentHeight = NaN;
            this.m_UIReasonValidation.percentWidth = 100;
            this.m_UIReasonValidation.setStyle("textAlign","right");
            addChild(this.m_UIReasonValidation);
            this.m_UIConstructed = true;
         }
      }
      
      public function get selectedReason() : Reason
      {
         return this.m_SelectedReason;
      }
   }
}
