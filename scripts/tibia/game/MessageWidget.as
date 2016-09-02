package tibia.game
{
   import mx.controls.Text;
   import mx.controls.TextArea;
   import mx.core.EdgeMetrics;
   import mx.containers.VBox;
   import mx.core.ScrollPolicy;
   
   public class MessageWidget extends PopUpBase
   {
       
      
      protected var m_UIMessage:Text = null;
      
      protected var m_UIMessageArea:TextArea = null;
      
      private var m_UIConstructed:Boolean = false;
      
      protected var m_Message:String = null;
      
      private var m_UncommittedMessage:Boolean = false;
      
      protected var m_UIMessageScrollBox:VBox = null;
      
      public function MessageWidget()
      {
         super();
      }
      
      public function set message(param1:String) : void
      {
         if(this.m_Message != param1)
         {
            this.m_Message = param1;
            this.m_UncommittedMessage = true;
            invalidateProperties();
         }
      }
      
      public function get message() : String
      {
         return this.m_Message;
      }
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
         if(this.m_UncommittedMessage)
         {
            this.m_UIMessage.htmlText = this.m_Message;
            this.m_UncommittedMessage = false;
         }
      }
      
      override protected function createChildren() : void
      {
         var _loc1_:EdgeMetrics = null;
         if(!this.m_UIConstructed)
         {
            super.createChildren();
            this.m_UIMessage = new Text();
            this.m_UIMessage.htmlText = this.m_Message;
            this.m_UIMessage.maxHeight = NaN;
            this.m_UIMessageScrollBox = new VBox();
            this.m_UIMessageScrollBox.horizontalScrollPolicy = ScrollPolicy.OFF;
            this.m_UIMessageScrollBox.verticalScrollPolicy = ScrollPolicy.AUTO;
            this.m_UIMessageScrollBox.addChild(this.m_UIMessage);
            _loc1_ = borderMetrics;
            this.m_UIMessageScrollBox.maxHeight = this.parent.height - _loc1_.top - _loc1_.bottom;
            this.m_UIMessageScrollBox.setStyle("paddingRight","20");
            this.m_UIMessage.maxWidth = this.parent.width - _loc1_.left - _loc1_.right - 20;
            addChild(this.m_UIMessageScrollBox);
            this.m_UIConstructed = true;
         }
      }
   }
}
