package
{
   import mx.resources.ResourceBundle;
   
   public class en_US$ImbuingWidget_properties extends ResourceBundle
   {
       
      
      public function en_US$ImbuingWidget_properties()
      {
         super("en_US","ImbuingWidget");
      }
      
      override protected function getContent() : Object
      {
         var _loc1_:Object = {
            "MESSAGE_CONFIRM_CLEARING_TEXT":"Do you wish to spend {0} gold coins to clear the imbuement \"{1}\" from your item?",
            "SUCCESS_RATE_VALUE":"{0}%",
            "REQUIRES_THESE_MATERIALS":"Requires the following astral sources:",
            "TOOLTIP_REMOVE_IMBUEMENT":"Your needs have changed? Click here to clear the imbuement from your item for a fee.",
            "TOOLTIP_IMBUEMENT_RESOURCE_AVAILABLE":"The imbuement you have selected requires {0}. Be warned! The astral sources will be used up whether the imbuement is successful or not.",
            "REMOVE_IMBUEMENT":"Remove imbuement:",
            "TOOLTIP_IMBUING_SLOT_AVAILABLE":"Use this slot to imbue your item. Depending on the item, you can have up to three different imbuements.",
            "TOOLTIP_PREMIUM_ONLY":"This level of imbuement can only be used with a Premium account. You can obtain Premium time from the Tibia Store by clicking on the button.",
            "TOOLTIP_APPLY_IMBUEMENT":"Click here to carry out the selected imbuement. This will consume the required astral sources and gold.",
            "SUCCESS_RATE":"Success Rate:",
            "TOOLTIP_PROTECTION_CHARM":"Bribe the fates! Click here to raise your chances to 100%. For guaranteed success - use gold.",
            "TOOLTIP_PREMIUM_AVAILABLE":"This is a premium-only imbuement. Items imbued with Premium imbuements can be used by all players, even those without Premium status.",
            "LBL_ITEM_INFORMATION":"Item Information",
            "TOOLTIP_IMBUEMENT_RESOURCE_UNAVAILABLE":"The imbuement requires {0}. Unfortunately you do not own the needed amount.",
            "LBL_IMBUE_EMPTY_SLOT":"Imbue Empty Slot",
            "TOOLTIP_REMAINING_TIME":"Shows the time the imbuement is still active for.",
            "TITLE":"Imbue Item",
            "MESSAGE_CONFIRM_IMBUING_TITLE":"Confirm Imbuing Attempt",
            "NO_IMBUEMENT_AVAILABLE":"Currently, there is no imbuement which can be put into this slot.",
            "TIME_REMAINING":"Time remaining:",
            "MESSAGE_CONFIRM_IMBUING_TEXT":"You are about to imbue your item with  \"{0}\".\nYour chance to succeed is {1}%.\nIt will consume the required astral sources and {2} gold coins.\nDo you wish to proceed?",
            "PREMIUM_IMBUEMENT_POSTFIX":" (premium)",
            "RESULTDIALOG_TITLE":"Info",
            "TOOLTIP_GOLD_BALANCE":"Cash: {0} gold\nBank: {1} gold ",
            "LBL_CLEAR_IMBUED_SLOT":"Clear Imbuement \"{0}\"",
            "TOOLTIP_IMBUING_SLOT_LOCKED":"Items can have up to three imbuement slots. This slot is not available for this item.",
            "PREMIUM_ONLY":"Premium only",
            "LBL_SLOTS_INFORMATION":"Select Slot:",
            "MESSAGE_CONFIRM_CLEARING_TITLE":"Confirm Clearing"
         };
         return _loc1_;
      }
   }
}
