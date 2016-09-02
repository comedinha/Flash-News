package tibia.actionbar.widgetClasses
{
   import tibia.game.ContextMenuBase;
   import mx.core.IUIComponent;
   import tibia.appearances.AppearanceType;
   import tibia.input.IAction;
   import tibia.input.gameaction.UseAction;
   import tibia.actionbar.ConfigurationWidget;
   import tibia.input.staticaction.StaticActionList;
   import tibia.options.configurationWidgetClasses.HotkeyOptions;
   import tibia.actionbar.ActionBar;
   
   public class ActionButtonContextMenu extends ContextMenuBase
   {
       
      
      protected var m_SlotIndex:int = -1;
      
      protected var m_ActionBar:ActionBar = null;
      
      public function ActionButtonContextMenu(param1:ActionBar, param2:int)
      {
         super();
         if(param1 == null)
         {
            throw new ArgumentError("ActionButtonContextMenu.ActionButtonContextMenu: Invalid action bar.");
         }
         this.m_ActionBar = param1;
         if(param2 < 0 || param2 >= ActionBar.NUM_ACTIONS)
         {
            throw new ArgumentError("ActionButtonContextMenu.ActionButtonContextMenu: Invalid slot index.");
         }
         this.m_SlotIndex = param2;
      }
      
      override public function display(param1:IUIComponent, param2:Number, param3:Number) : void
      {
         var Type:AppearanceType = null;
         var a_Owner:IUIComponent = param1;
         var a_StageX:Number = param2;
         var a_StageY:Number = param3;
         var _Action:IAction = this.m_ActionBar.getAction(this.m_SlotIndex);
         var ShowEditAction:Boolean = true;
         if(_Action is UseAction)
         {
            Type = UseAction(_Action).type;
            ShowEditAction = Type == null || Type.isMultiUse || Type.isCloth;
         }
         if(ShowEditAction)
         {
            createTextItem(resourceManager.getString(ActionBarWidget.BUNDLE,"CTX_EDIT_ACTION"),function(param1:*):void
            {
               var _loc2_:ConfigurationWidget = new ConfigurationWidget();
               _loc2_.actionBar = m_ActionBar;
               _loc2_.slotIndex = m_SlotIndex;
               _loc2_.show();
            });
         }
         if(_Action != null)
         {
            createTextItem(resourceManager.getString(ActionBarWidget.BUNDLE,"CTX_CLEAR_ACTION"),function(param1:*):void
            {
               m_ActionBar.setAction(m_SlotIndex,null);
            });
         }
         createSeparatorItem();
         createTextItem(resourceManager.getString(ActionBarWidget.BUNDLE,"CTX_EDIT_HOTKEY"),function(param1:*):void
         {
            var a_Event:* = param1;
            var _Action:IAction = StaticActionList.getActionButtonTrigger(m_ActionBar.location,m_SlotIndex);
            var Dialog:ConfigurationWidget = new ConfigurationWidget();
            Dialog.selectedIndex = ConfigurationWidget.HOTKEY;
            callLater(function(param1:IAction, param2:ConfigurationWidget):void
            {
               var _loc3_:HotkeyOptions = param2.getEditor(ConfigurationWidget.HOTKEY) as HotkeyOptions;
               if(_loc3_ != null)
               {
                  _loc3_.action = param1;
                  _loc3_.beginEditBinding(param1);
               }
            },[_Action,Dialog]);
            Dialog.show();
         });
         super.display(a_Owner,a_StageX,a_StageY);
      }
   }
}
