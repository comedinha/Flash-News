package tibia.creatures.statusWidgetClasses
{
   import mx.containers.utilityClasses.BoxLayout;
   import mx.core.EdgeMetrics;
   
   public class ParallelStatusWidgetStyle extends BoxLayout
   {
      
      public static const DIRECTION_LEFT_TO_RIGHT:String = "lr";
      
      public static const DIRECTION_BOTTOM_TO_TOP:String = "bt";
      
      public static const DIRECTION_RIGHT_TO_LEFT:String = "rl";
      
      public static const DIRECTION_TOP_TO_BOTTOM:String = "tb";
      
      public static const DIRECTION_AUTO:String = "a";
       
      
      public function ParallelStatusWidgetStyle()
      {
         super();
      }
      
      override public function measure() : void
      {
         var _loc1_:EdgeMetrics = null;
         var _loc2_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc10_:BitmapProgressBar = null;
         _loc1_ = target.viewMetricsAndPadding;
         _loc2_ = 0;
         var _loc3_:Number = 0;
         _loc4_ = 0;
         _loc5_ = 0;
         var _loc6_:Number = target.getStyle("horizontalGap");
         var _loc7_:Number = target.getStyle("horizontalBigGap");
         var _loc8_:Number = target.getStyle("verticalGap");
         var _loc9_:Number = target.getStyle("verticalBigGap");
         _loc10_ = BitmapProgressBar(target.getChildByName("hitpoints"));
         var _loc11_:Number = _loc10_.getStyle("paddingBottom");
         var _loc12_:BitmapProgressBar = BitmapProgressBar(target.getChildByName("mana"));
         var _loc13_:SkillProgressBar = SkillProgressBar(target.getChildByName("skill"));
         var _loc14_:StateRenderer = StateRenderer(target.getChildByName("state"));
         _loc3_ = Math.max(_loc10_.measuredMinWidth,_loc12_.measuredMinWidth,_loc14_.measuredMinWidth) + _loc7_;
         _loc2_ = Math.max(_loc10_.getExplicitOrMeasuredWidth(),_loc12_.getExplicitOrMeasuredWidth(),_loc14_.getExplicitOrMeasuredWidth()) + _loc7_;
         _loc5_ = _loc10_.measuredMinHeight - _loc11_ + _loc12_.measuredMinHeight + _loc8_;
         Number(_loc14_.measuredMinHeight);
         _loc4_ = _loc10_.getExplicitOrMeasuredHeight() - _loc11_ + _loc12_.getExplicitOrMeasuredHeight() + _loc8_ + _loc14_.getExplicitOrMeasuredHeight();
         if(_loc13_.includeInLayout)
         {
            _loc3_ = Math.max(_loc3_,_loc13_.measuredMinWidth);
            _loc2_ = Math.max(_loc2_,_loc13_.getExplicitOrMeasuredWidth());
            _loc5_ = _loc5_ + (_loc13_.measuredMinHeight + _loc8_);
            _loc4_ = _loc4_ + (_loc13_.getExplicitOrMeasuredHeight() + _loc8_);
         }
         target.measuredMinWidth = _loc3_ + _loc1_.left + _loc1_.right;
         target.measuredWidth = _loc2_ + _loc1_.left + _loc1_.right;
         target.measuredMinHeight = _loc5_ + _loc1_.top + _loc1_.bottom;
         target.measuredHeight = _loc4_ + _loc1_.top + _loc1_.bottom;
      }
      
      override public function updateDisplayList(param1:Number, param2:Number) : void
      {
         var _loc12_:BitmapProgressBar = null;
         var _loc3_:EdgeMetrics = target.viewMetricsAndPadding;
         var _loc4_:Number = 0;
         var _loc5_:Number = 0;
         var _loc6_:Number = target.getStyle("horizontalGap");
         var _loc7_:Number = target.getStyle("horizontalBigGap");
         var _loc8_:Number = target.getStyle("verticalGap");
         var _loc9_:Number = target.getStyle("verticalBigGap");
         var _loc10_:Number = param1 - _loc3_.left - _loc3_.right;
         var _loc11_:Number = param2 - _loc3_.top - _loc3_.bottom;
         _loc12_ = BitmapProgressBar(target.getChildByName("hitpoints"));
         var _loc13_:Number = target.getStyle("hitpointsOffsetY");
         var _loc14_:Number = _loc12_.getStyle("paddingBottom");
         var _loc15_:BitmapProgressBar = BitmapProgressBar(target.getChildByName("mana"));
         var _loc16_:Number = target.getStyle("manaOffsetY");
         var _loc17_:SkillProgressBar = SkillProgressBar(target.getChildByName("skill"));
         var _loc18_:StateRenderer = StateRenderer(target.getChildByName("state"));
         var _loc19_:Number = _loc3_.top;
         var _loc20_:String = direction == DIRECTION_TOP_TO_BOTTOM?DIRECTION_RIGHT_TO_LEFT:DIRECTION_LEFT_TO_RIGHT;
         _loc5_ = _loc12_.getExplicitOrMeasuredHeight() - _loc14_;
         _loc12_.direction = _loc20_;
         _loc12_.move(_loc3_.left + _loc7_ / 2,_loc19_ + _loc13_);
         _loc12_.setActualSize(_loc10_ - _loc7_,_loc5_);
         _loc19_ = _loc19_ + (_loc13_ + _loc5_);
         _loc5_ = _loc15_.getExplicitOrMeasuredHeight();
         _loc15_.direction = _loc20_;
         _loc15_.move(_loc3_.left + _loc7_ / 2,_loc19_ + _loc16_);
         _loc15_.setActualSize(_loc10_ - _loc7_,_loc5_);
         _loc19_ = _loc19_ + (_loc16_ + _loc5_ + _loc8_);
         if(_loc17_.includeInLayout)
         {
            _loc5_ = _loc17_.getExplicitOrMeasuredHeight();
            _loc17_.progressDirection = _loc20_;
            _loc17_.move(_loc3_.left,_loc19_);
            _loc17_.setActualSize(_loc10_,_loc5_);
            _loc19_ = _loc19_ + (_loc5_ + _loc8_);
         }
         _loc5_ = _loc18_.getExplicitOrMeasuredHeight();
         _loc4_ = _loc18_.getExplicitOrMeasuredWidth();
         _loc18_.move(_loc3_.left + (_loc10_ - _loc4_) / 2,_loc19_);
         _loc18_.setActualSize(_loc4_,_loc5_);
      }
   }
}
