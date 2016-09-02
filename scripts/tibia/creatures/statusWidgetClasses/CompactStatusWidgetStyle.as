package tibia.creatures.statusWidgetClasses
{
   import mx.containers.utilityClasses.BoxLayout;
   import mx.core.EdgeMetrics;
   
   public class CompactStatusWidgetStyle extends BoxLayout
   {
      
      public static const DIRECTION_LEFT_TO_RIGHT:String = "lr";
      
      public static const DIRECTION_BOTTOM_TO_TOP:String = "bt";
      
      public static const DIRECTION_RIGHT_TO_LEFT:String = "rl";
      
      public static const DIRECTION_TOP_TO_BOTTOM:String = "tb";
      
      public static const DIRECTION_AUTO:String = "a";
       
      
      public function CompactStatusWidgetStyle()
      {
         super();
      }
      
      override public function measure() : void
      {
         var _loc1_:EdgeMetrics = null;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc18_:Number = NaN;
         var _loc19_:Number = NaN;
         _loc1_ = target.viewMetricsAndPadding;
         var _loc2_:Number = 0;
         var _loc3_:Number = 0;
         _loc4_ = 0;
         _loc5_ = 0;
         var _loc6_:Number = target.getStyle("horizontalGap");
         var _loc7_:Number = target.getStyle("horizontalBigGap");
         var _loc8_:Number = target.getStyle("verticalGap");
         var _loc9_:Number = target.getStyle("verticalBigGap");
         var _loc10_:BitmapProgressBar = BitmapProgressBar(target.getChildByName("hitpoints"));
         var _loc11_:Number = target.getStyle("hitpointsOffsetX");
         var _loc12_:Number = target.getStyle("hitpointsOffsetY");
         var _loc13_:BitmapProgressBar = BitmapProgressBar(target.getChildByName("mana"));
         var _loc14_:Number = target.getStyle("manaOffsetX");
         var _loc15_:Number = target.getStyle("manaOffsetY");
         var _loc16_:SkillProgressBar = SkillProgressBar(target.getChildByName("skill"));
         var _loc17_:StateRenderer = StateRenderer(target.getChildByName("state"));
         _loc3_ = _loc10_.measuredMinWidth + _loc11_ + _loc7_ + _loc17_.measuredMinWidth + _loc7_ + _loc13_.measuredMinWidth + _loc14_;
         _loc2_ = _loc10_.getExplicitOrMeasuredWidth() + _loc11_ + _loc7_ + _loc17_.getExplicitOrMeasuredWidth() + _loc7_ + _loc13_.getExplicitOrMeasuredWidth() + _loc14_;
         _loc5_ = Math.max(_loc10_.measuredMinHeight + _loc12_,_loc17_.measuredMinHeight,_loc13_.measuredMinHeight + _loc15_);
         _loc4_ = Math.max(_loc10_.getExplicitOrMeasuredHeight() + _loc12_,_loc17_.getExplicitOrMeasuredHeight(),_loc13_.getExplicitOrMeasuredHeight() + _loc15_);
         if(_loc16_.includeInLayout)
         {
            _loc3_ = Math.max(_loc3_,_loc16_.measuredMinWidth);
            _loc2_ = Math.max(_loc2_,_loc16_.getExplicitOrMeasuredWidth());
            _loc5_ = _loc5_ + (_loc8_ + _loc16_.measuredMinHeight);
            _loc4_ = _loc4_ + (_loc8_ + _loc16_.getExplicitOrMeasuredHeight());
         }
         else
         {
            _loc18_ = target.getStyle("paddingBottom");
            _loc19_ = Math.max(_loc10_.getStyle("paddingBottom"),_loc13_.getStyle("paddingBottom"));
            _loc5_ = _loc5_ - (_loc18_ + _loc19_);
            _loc4_ = _loc4_ - (_loc18_ + _loc19_);
         }
         target.measuredMinWidth = _loc3_ + _loc1_.left + _loc1_.right;
         target.measuredWidth = _loc2_ + _loc1_.left + _loc1_.right;
         target.measuredMinHeight = _loc5_ + _loc1_.top + _loc1_.bottom;
         target.measuredHeight = _loc4_ + _loc1_.top + _loc1_.bottom;
      }
      
      override public function updateDisplayList(param1:Number, param2:Number) : void
      {
         var _loc11_:BitmapProgressBar = null;
         var _loc15_:BitmapProgressBar = null;
         var _loc3_:EdgeMetrics = target.borderMetrics;
         var _loc4_:EdgeMetrics = target.viewMetricsAndPadding;
         var _loc5_:Number = target.getStyle("horizontalGap");
         var _loc6_:Number = target.getStyle("horizontalBigGap");
         var _loc7_:Number = target.getStyle("verticalGap");
         var _loc8_:Number = target.getStyle("verticalBigGap");
         var _loc9_:Number = param1 - _loc4_.left - _loc4_.right;
         var _loc10_:Number = param2 - _loc4_.top - _loc4_.bottom;
         _loc11_ = BitmapProgressBar(target.getChildByName("hitpoints"));
         var _loc12_:Number = target.getStyle("hitpointsOffsetX");
         var _loc13_:Number = target.getStyle("hitpointsOffsetY");
         var _loc14_:Number = _loc11_.getStyle("paddingBottom");
         _loc15_ = BitmapProgressBar(target.getChildByName("mana"));
         var _loc16_:Number = target.getStyle("manaOffsetX");
         var _loc17_:Number = target.getStyle("manaOffsetY");
         var _loc18_:Number = _loc15_.getStyle("paddingBottom");
         var _loc19_:SkillProgressBar = SkillProgressBar(target.getChildByName("skill"));
         var _loc20_:StateRenderer = StateRenderer(target.getChildByName("state"));
         var _loc21_:Number = Math.max(_loc20_.getExplicitOrMeasuredWidth(),_loc20_.measuredMinWidth);
         var _loc22_:Number = Math.round((_loc9_ - _loc21_ - 2 * _loc6_) / 2);
         var _loc23_:Number = Math.max(_loc11_.getExplicitOrMeasuredHeight() + _loc13_ - _loc14_,_loc15_.getExplicitOrMeasuredHeight() + _loc17_ - _loc18_);
         var _loc24_:Number = 0;
         var _loc25_:Number = 0;
         var _loc26_:Number = 0;
         _loc25_ = _loc11_.getExplicitOrMeasuredHeight();
         if(!_loc19_.includeInLayout)
         {
            _loc25_ = _loc25_ - _loc14_;
         }
         _loc11_.direction = DIRECTION_LEFT_TO_RIGHT;
         _loc11_.move(_loc4_.left + _loc12_,_loc4_.top + _loc13_);
         _loc11_.setActualSize(_loc22_,_loc25_);
         _loc26_ = _loc25_ + _loc13_;
         _loc25_ = _loc15_.getExplicitOrMeasuredHeight();
         if(!_loc19_.includeInLayout)
         {
            _loc25_ = _loc25_ - _loc18_;
         }
         _loc15_.direction = DIRECTION_RIGHT_TO_LEFT;
         _loc15_.move(_loc4_.left + _loc9_ - _loc22_ + _loc16_,_loc4_.top + _loc17_);
         _loc15_.setActualSize(_loc22_,_loc25_);
         _loc26_ = _loc4_.top + Math.max(_loc26_,_loc25_ + _loc17_) + _loc7_;
         _loc25_ = _loc20_.getExplicitOrMeasuredHeight();
         _loc20_.move(_loc4_.left + _loc22_ + _loc6_,_loc4_.top + (_loc23_ - _loc25_) / 2);
         _loc20_.setActualSize(_loc21_,_loc25_);
         if(_loc19_.includeInLayout)
         {
            _loc25_ = _loc19_.getExplicitOrMeasuredHeight();
            _loc19_.progressDirection = direction == DIRECTION_TOP_TO_BOTTOM?DIRECTION_RIGHT_TO_LEFT:DIRECTION_LEFT_TO_RIGHT;
            _loc19_.move(_loc4_.left,_loc26_);
            _loc19_.setActualSize(_loc9_,_loc25_);
         }
      }
   }
}
