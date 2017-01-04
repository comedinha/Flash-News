package tibia.trade.npcTradeWidgetClasses
{
   import mx.core.IUIComponent;
   import shared.utility.closure;
   import tibia.appearances.AppearanceTypeRef;
   import tibia.game.ContextMenuBase;
   import tibia.input.gameaction.InspectNPCTradeActionImpl;
   import tibia.options.OptionsStorage;
   
   public class NPCTradeContextMenu extends ContextMenuBase
   {
      
      private static const BUNDLE:String = "NPCTradeWidget";
      
      private static const SORT_OPTIONS:Array = [{
         "value":ObjectRefSelectorBase.SORT_NAME,
         "label":"CTX_SORT_NAME"
      },{
         "value":ObjectRefSelectorBase.SORT_PRICE,
         "label":"CTX_SORT_PRICE"
      },{
         "value":ObjectRefSelectorBase.SORT_WEIGHT,
         "label":"CTX_SORT_WEIGHT"
      }];
       
      
      protected var m_TradeObjects:AppearanceTypeRef = null;
      
      protected var m_TradeMode:int = 0;
      
      protected var m_Options:OptionsStorage = null;
      
      public function NPCTradeContextMenu(param1:OptionsStorage, param2:int, param3:AppearanceTypeRef)
      {
         super();
         if(param1 == null)
         {
            throw new ArgumentError("NPCTradeContextMenu.NPCTradeContextMenu: Invalid options reference.");
         }
         this.m_Options = param1;
         if(param2 != NPCTradeWidgetView.MODE_BUY && param2 != NPCTradeWidgetView.MODE_SELL)
         {
            throw new ArgumentError("NPCTradeContextMenu.NPCTradeContextMenu: Invalid trade mode.");
         }
         this.m_TradeMode = param2;
         if(param1 == null)
         {
            throw new ArgumentError("NPCTradeContextMenu.NPCTradeContextMenu: Invalid trade object reference.");
         }
         this.m_TradeObjects = param3;
      }
      
      override public function display(param1:IUIComponent, param2:Number, param3:Number) : void
      {
         var a_Owner:IUIComponent = param1;
         var a_StageX:Number = param2;
         var a_StageY:Number = param3;
         if(this.m_TradeObjects != null)
         {
            createTextItem(resourceManager.getString(BUNDLE,"CTX_LOOK"),closure(null,function(param1:AppearanceTypeRef, param2:*):void
            {
               new InspectNPCTradeActionImpl(param1).perform();
            },this.m_TradeObjects));
            createSeparatorItem();
         }
         var i:int = 0;
         while(i < SORT_OPTIONS.length)
         {
            if(this.m_Options.npcTradeSort != SORT_OPTIONS[i].value)
            {
               createTextItem(resourceManager.getString(BUNDLE,SORT_OPTIONS[i].label),closure(null,function(param1:OptionsStorage, param2:int, param3:*):void
               {
                  param1.npcTradeSort = param2;
               },this.m_Options,SORT_OPTIONS[i].value));
            }
            i++;
         }
         createSeparatorItem();
         if(this.m_TradeMode == NPCTradeWidgetView.MODE_BUY)
         {
            createTextItem(resourceManager.getString(BUNDLE,!!this.m_Options.npcTradeBuyWithBackpacks?"CTX_BUY_WITHOUT_BACKPACKS":"CTX_BUY_WITH_BACKPACKS"),closure(null,function(param1:OptionsStorage, param2:*):void
            {
               param1.npcTradeBuyWithBackpacks = !param1.npcTradeBuyWithBackpacks;
            },this.m_Options));
            createTextItem(resourceManager.getString(BUNDLE,!!this.m_Options.npcTradeBuyIgnoreCapacity?"CTX_BUY_CONSIDER_CAPACITY":"CTX_BUY_IGNORE_CAPACITY"),closure(null,function(param1:OptionsStorage, param2:*):void
            {
               param1.npcTradeBuyIgnoreCapacity = !param1.npcTradeBuyIgnoreCapacity;
            },this.m_Options));
         }
         else
         {
            createTextItem(resourceManager.getString(BUNDLE,!!this.m_Options.npcTradeSellKeepEquipped?"CTX_SELL_SELL_EQUIPPED":"CTX_SELL_KEEP_EQUIPPED"),closure(null,function(param1:OptionsStorage, param2:*):void
            {
               param1.npcTradeSellKeepEquipped = !param1.npcTradeSellKeepEquipped;
            },this.m_Options));
         }
         super.display(a_Owner,a_StageX,a_StageY);
      }
   }
}
