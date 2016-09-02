package shared.controls
{
   import mx.core.UITextField;
   import flash.geom.Point;
   import flash.events.Event;
   import flash.geom.Rectangle;
   import flash.text.TextFormat;
   
   public class UIHyperlinksTextField extends UITextField
   {
      
      private static var s_ZeroPoint:Point = new Point(0,0);
       
      
      private var m_UncommitedRectangles:Boolean = true;
      
      private var m_HyperlinkInfos:Vector.<shared.controls.UIHyperlinksTextFieldHyperlinkInfo> = null;
      
      private var m_OldPosition:Point;
      
      public function UIHyperlinksTextField()
      {
         this.m_OldPosition = new Point();
         super();
         addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
      }
      
      private function onUpdateHyperlinkInfos(param1:Event) : void
      {
         this.m_UncommitedRectangles = true;
      }
      
      private function onAddedToStage(param1:Event) : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         addEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
         addEventListener(Event.SCROLL,this.onUpdateHyperlinkInfos);
      }
      
      override public function invalidateDisplayList() : void
      {
         this.m_UncommitedRectangles = true;
         super.invalidateDisplayList();
      }
      
      public function get containsHyperlink() : Boolean
      {
         return this.hyperlinkInfos.length > 0;
      }
      
      override public function set htmlText(param1:String) : void
      {
         super.htmlText = param1;
         this.m_UncommitedRectangles = true;
      }
      
      private function addRectangle(param1:Rectangle, param2:shared.controls.UIHyperlinksTextFieldHyperlinkInfo) : void
      {
         param2.rectangles.push(param1.clone());
         var _loc3_:Point = localToGlobal(param1.topLeft);
         param2.globalRectangles.push(new Rectangle(_loc3_.x,_loc3_.y,param1.width,param1.height));
      }
      
      private function onRemovedFromStage(param1:Event) : void
      {
         removeEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
         removeEventListener(Event.SCROLL,this.onUpdateHyperlinkInfos);
         removeEventListener(Event.RESIZE,this.onUpdateHyperlinkInfos);
      }
      
      public function findHyperlinkInfo(param1:String) : shared.controls.UIHyperlinksTextFieldHyperlinkInfo
      {
         var _loc3_:shared.controls.UIHyperlinksTextFieldHyperlinkInfo = null;
         var _loc2_:Vector.<shared.controls.UIHyperlinksTextFieldHyperlinkInfo> = this.hyperlinkInfos;
         for each(_loc3_ in _loc2_)
         {
            if(_loc3_.hyperlinkText == param1)
            {
               return _loc3_;
            }
         }
         return null;
      }
      
      private function calculateHyperlinkInfos() : void
      {
         var _loc5_:TextFormat = null;
         var _loc6_:String = null;
         var _loc7_:Rectangle = null;
         this.m_HyperlinkInfos = new Vector.<shared.controls.UIHyperlinksTextFieldHyperlinkInfo>();
         var _loc1_:shared.controls.UIHyperlinksTextFieldHyperlinkInfo = null;
         var _loc2_:Rectangle = null;
         var _loc3_:String = this.text;
         var _loc4_:uint = 0;
         while(_loc4_ < _loc3_.length)
         {
            _loc5_ = getTextFormat(_loc4_);
            if(_loc5_.url != null && _loc5_.url.length != 0)
            {
               _loc6_ = _loc5_.url.substr(6);
               if(_loc1_ == null || _loc1_.hyperlinkText != _loc6_)
               {
                  _loc1_ = new shared.controls.UIHyperlinksTextFieldHyperlinkInfo(_loc6_);
                  this.m_HyperlinkInfos.push(_loc1_);
               }
               _loc7_ = getCharBoundaries(_loc4_);
               if(_loc2_ == null)
               {
                  _loc2_ = _loc7_;
               }
               else if(_loc2_.x + _loc2_.width == _loc7_.x)
               {
                  _loc2_.width = _loc2_.width + _loc7_.width;
                  _loc2_.height = Math.max(_loc2_.height,_loc7_.height);
               }
               else
               {
                  this.addRectangle(_loc2_,_loc1_);
                  _loc2_ = _loc7_;
               }
            }
            else
            {
               if(_loc2_ != null && _loc1_ != null)
               {
                  this.addRectangle(_loc2_,_loc1_);
                  _loc2_ = null;
               }
               _loc2_ = null;
               _loc1_ = null;
            }
            _loc4_++;
         }
      }
      
      public function get hyperlinkInfos() : Vector.<shared.controls.UIHyperlinksTextFieldHyperlinkInfo>
      {
         var _loc1_:Point = localToGlobal(s_ZeroPoint);
         if(this.m_UncommitedRectangles || _loc1_.equals(this.m_OldPosition) == false)
         {
            this.m_OldPosition = _loc1_;
            this.calculateHyperlinkInfos();
            this.m_UncommitedRectangles = false;
         }
         return this.m_HyperlinkInfos;
      }
   }
}
