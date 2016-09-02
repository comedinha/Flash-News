package tibia.creatures.buddylistWidgetClasses
{
   import tibia.game.ContextMenuBase;
   import tibia.creatures.BuddylistWidget;
   import mx.core.IUIComponent;
   import tibia.creatures.EditBuddyWidget;
   import tibia.input.gameaction.BuddylistActionImpl;
   import tibia.creatures.buddylistClasses.Buddy;
   import tibia.input.gameaction.PrivateChatActionImpl;
   import shared.utility.closure;
   import tibia.reporting.reportType.Type;
   import tibia.reporting.ReportWidget;
   import flash.system.System;
   import tibia.creatures.BuddySet;
   
   public class BuddylistItemContextMenu extends ContextMenuBase
   {
      
      private static const BUNDLE:String = "BuddylistWidget";
      
      private static const SORT_MODE:Array = [{
         "value":BuddylistWidget.SORT_BY_NAME,
         "label":"CTX_SORT_NAME"
      },{
         "value":BuddylistWidget.SORT_BY_ICON,
         "label":"CTX_SORT_ICON"
      },{
         "value":BuddylistWidget.SORT_BY_STATUS,
         "label":"CTX_SORT_STATUS"
      }];
       
      
      private var m_Buddy:Buddy = null;
      
      private var m_BuddySet:BuddySet = null;
      
      public function BuddylistItemContextMenu(param1:BuddySet, param2:Buddy)
      {
         super();
         this.m_BuddySet = param1;
         if(this.m_BuddySet == null)
         {
            throw new ArgumentError("BuddylistItemContextMenu.BuddylistItemContextMenu: Invalid buddy set.");
         }
         this.m_Buddy = param2;
      }
      
      override public function display(param1:IUIComponent, param2:Number, param3:Number) : void
      {
         var _Widget:BuddylistWidget = null;
         var i:int = 0;
         var a_Owner:IUIComponent = param1;
         var a_StageX:Number = param2;
         var a_StageY:Number = param3;
         if(this.m_Buddy != null)
         {
            createTextItem(resourceManager.getString(BUNDLE,"CTX_EDIT_BUDDY",[this.m_Buddy.name]),function(param1:*):void
            {
               var _loc2_:EditBuddyWidget = new EditBuddyWidget();
               _loc2_.buddySet = m_BuddySet;
               _loc2_.buddy = m_Buddy;
               _loc2_.show();
            });
            createTextItem(resourceManager.getString(BUNDLE,"CTX_REMOVE_BUDDY",[this.m_Buddy.name]),function(param1:*):void
            {
               new BuddylistActionImpl(BuddylistActionImpl.REMOVE,m_Buddy.ID).perform();
            });
            createSeparatorItem();
         }
         if(this.m_Buddy != null && this.m_Buddy.status == Buddy.STATUS_ONLINE && this.m_Buddy.ID != Tibia.s_GetPlayer().ID)
         {
            createTextItem(resourceManager.getString(BUNDLE,"CTX_OPEN_MESSAGE_CHANNEL",[this.m_Buddy.name]),function(param1:*):void
            {
               new PrivateChatActionImpl(PrivateChatActionImpl.OPEN_MESSAGE_CHANNEL,PrivateChatActionImpl.CHAT_CHANNEL_NO_CHANNEL,m_Buddy.name).perform();
            });
            createSeparatorItem();
         }
         createTextItem(resourceManager.getString(BUNDLE,"CTX_ADD_BUDDY"),function(param1:*):void
         {
            new BuddylistActionImpl(BuddylistActionImpl.ADD_ASK_NAME,null).perform();
         });
         if(a_Owner is BuddylistWidgetView && BuddylistWidgetView(a_Owner).widgetInstance is BuddylistWidget)
         {
            _Widget = BuddylistWidget(BuddylistWidgetView(a_Owner).widgetInstance);
            i = 0;
            while(i < SORT_MODE.length)
            {
               if(_Widget.sortOrder != SORT_MODE[i].value)
               {
                  createTextItem(resourceManager.getString(BUNDLE,SORT_MODE[i].label),closure(null,function(param1:BuddylistWidget, param2:int, param3:*):void
                  {
                     param1.sortOrder = param2;
                  },_Widget,SORT_MODE[i].value));
               }
               i++;
            }
            createTextItem(resourceManager.getString(BUNDLE,!!_Widget.showOffline?"CTX_HIDE_OFFLINE":"CTX_SHOW_OFFLINE"),function(param1:*):void
            {
               _Widget.showOffline = !_Widget.showOffline;
            });
         }
         createSeparatorItem();
         if(this.m_Buddy != null && this.m_Buddy.isReportTypeAllowed(Type.REPORT_NAME))
         {
            createTextItem(resourceManager.getString(BUNDLE,"CTX_REPORT_NAME"),function(param1:*):void
            {
               new ReportWidget(Type.REPORT_NAME,m_Buddy).show();
            });
            createSeparatorItem();
         }
         if(this.m_Buddy != null)
         {
            createTextItem(resourceManager.getString(BUNDLE,"CTX_COPY_NAME"),function(param1:*):void
            {
               System.setClipboard(m_Buddy.name);
            });
            createSeparatorItem();
         }
         super.display(a_Owner,a_StageX,a_StageY);
      }
   }
}
