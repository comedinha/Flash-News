package tibia.help
{
   import shared.utility.Vector3D;
   import tibia.container.BodyContainerView;
   import tibia.container.bodyContainerViewWigdetClasses.BodyContainerViewWidgetView;
   import tibia.container.containerViewWidgetClasses.ContainerViewWidgetView;
   import flash.geom.Rectangle;
   import flash.geom.Point;
   import tibia.worldmap.WorldMapWidget;
   import tibia.worldmap.widgetClasses.RendererImpl;
   import mx.core.UIComponent;
   import shared.controls.UIHyperlinksTextFieldHyperlinkInfo;
   import tibia.chat.chatWidgetClasses.ChannelMessageRenderer;
   
   public class GUIRectangle
   {
       
      
      private var m_Info:GUIRectangleInfo = null;
      
      private var m_RefreshRectangle:Boolean = true;
      
      private var m_CachedRectangle:Rectangle = null;
      
      public function GUIRectangle()
      {
         super();
      }
      
      public static function s_IsMapCoordinate(param1:Vector3D) : Boolean
      {
         return param1 != null && param1.x < 65535;
      }
      
      public static function s_FromKeyword(param1:String) : GUIRectangle
      {
         var _loc2_:GUIRectangle = new GUIRectangle();
         var _loc3_:KeywordInfo = new KeywordInfo();
         _loc3_.m_KeywordString = param1;
         _loc2_.m_Info = _loc3_;
         return _loc2_;
      }
      
      public static function s_FromUIComponent(param1:Class, param2:*) : GUIRectangle
      {
         var _loc3_:GUIRectangle = new GUIRectangle();
         var _loc4_:UIComponentInfo = new UIComponentInfo();
         _loc4_.m_Identifier = param1;
         _loc4_.m_SubIdentifier = param2;
         _loc3_.m_Info = _loc4_;
         return _loc3_;
      }
      
      public static function s_FromCoordinate(param1:Vector3D) : GUIRectangle
      {
         var _loc2_:GUIRectangle = new GUIRectangle();
         var _loc3_:CoordinateInfo = new CoordinateInfo();
         _loc3_.m_Coordinate = param1;
         _loc2_.m_Info = _loc3_;
         return _loc2_;
      }
      
      public static function s_GetCoordinateInfo(param1:Vector3D) : Object
      {
         var _loc2_:Object = new Object();
         if(param1 == null)
         {
            return _loc2_;
         }
         if(param1.x == 65535 && param1.y == 0)
         {
            _loc2_["identifier"] = BodyContainerView;
            _loc2_["subIdentifier"] = null;
         }
         else if(param1.x == 65535 && param1.y >= 1 && param1.y <= 10)
         {
            _loc2_["identifier"] = BodyContainerViewWidgetView;
            switch(param1.y)
            {
               case 1:
                  _loc2_["subIdentifier"] = BodyContainerView.HEAD;
                  break;
               case 2:
                  _loc2_["subIdentifier"] = BodyContainerView.NECK;
                  break;
               case 3:
                  _loc2_["subIdentifier"] = BodyContainerView.BACK;
                  break;
               case 4:
                  _loc2_["subIdentifier"] = BodyContainerView.TORSO;
                  break;
               case 5:
                  _loc2_["subIdentifier"] = BodyContainerView.RIGHT_HAND;
                  break;
               case 6:
                  _loc2_["subIdentifier"] = BodyContainerView.LEFT_HAND;
                  break;
               case 7:
                  _loc2_["subIdentifier"] = BodyContainerView.LEGS;
                  break;
               case 8:
                  _loc2_["subIdentifier"] = BodyContainerView.FEET;
                  break;
               case 9:
                  _loc2_["subIdentifier"] = BodyContainerView.FINGER;
                  break;
               case 10:
                  _loc2_["subIdentifier"] = BodyContainerView.HIP;
            }
         }
         else if(!(param1.x == 65535 && param1.y == 254))
         {
            if(param1.x == 65535 && param1.y >= 64)
            {
               _loc2_["identifier"] = ContainerViewWidgetView;
               _loc2_["subIdentifier"] = Object({
                  "id":param1.y - 64,
                  "slot":param1.z
               });
            }
            else if(s_IsMapCoordinate(param1))
            {
               _loc2_["coordinate"] = param1;
            }
         }
         return _loc2_;
      }
      
      public function refresh() : void
      {
         this.m_RefreshRectangle = true;
      }
      
      private function getMapRect(param1:Vector3D) : Rectangle
      {
         var _loc4_:Point = null;
         var _loc2_:RendererImpl = Tibia.s_GetUIEffectsManager().findUIElementByIdentifier(WorldMapWidget,RendererImpl) as RendererImpl;
         var _loc3_:Rectangle = null;
         if(_loc2_ != null)
         {
            _loc3_ = _loc2_.absoluteToRect(param1);
            _loc4_ = new Point(_loc3_.x,_loc3_.y);
            _loc4_ = _loc2_.localToGlobal(_loc4_);
            _loc3_.setTo(_loc4_.x,_loc4_.y,_loc3_.width,_loc3_.height);
         }
         return _loc3_;
      }
      
      public function get rectangle() : Rectangle
      {
         var _loc1_:CoordinateInfo = null;
         var _loc2_:Object = null;
         var _loc3_:UIComponentInfo = null;
         var _loc4_:KeywordInfo = null;
         if(this.m_RefreshRectangle)
         {
            this.m_RefreshRectangle = false;
            if(this.m_Info is CoordinateInfo)
            {
               _loc1_ = this.m_Info as CoordinateInfo;
               _loc2_ = s_GetCoordinateInfo(_loc1_.m_Coordinate);
               if("coordinate" in _loc2_)
               {
                  this.m_CachedRectangle = this.getMapRect(_loc2_["coordinate"] as Vector3D);
               }
               else if("identifier" in _loc2_)
               {
                  this.m_CachedRectangle = this.getUIComponentRect(_loc2_["identifier"] as Class,_loc2_["subIdentifier"]);
               }
            }
            else if(this.m_Info is UIComponentInfo)
            {
               _loc3_ = this.m_Info as UIComponentInfo;
               this.m_CachedRectangle = this.getUIComponentRect(_loc3_.m_Identifier,_loc3_.m_SubIdentifier);
            }
            else if(this.m_Info is KeywordInfo)
            {
               _loc4_ = this.m_Info as KeywordInfo;
               this.m_CachedRectangle = this.getKeywordRect(_loc4_.m_KeywordString);
            }
         }
         return this.m_CachedRectangle;
      }
      
      private function getUIComponentRect(param1:Class, param2:*) : Rectangle
      {
         var _loc5_:Point = null;
         var _loc3_:Rectangle = null;
         var _loc4_:UIComponent = Tibia.s_GetUIEffectsManager().findUIElementByIdentifier(param1,param2);
         if(_loc4_ != null)
         {
            _loc5_ = new Point(0,0);
            _loc5_ = _loc4_.localToGlobal(_loc5_);
            _loc3_ = new Rectangle(_loc5_.x,_loc5_.y,_loc4_.width,_loc4_.height);
         }
         return _loc3_;
      }
      
      public function get centerPoint() : Point
      {
         var _loc1_:Point = null;
         if(this.rectangle != null)
         {
            _loc1_ = this.rectangle.topLeft.clone();
            _loc1_.x = _loc1_.x + this.rectangle.width / 2;
            _loc1_.y = _loc1_.y + this.rectangle.height / 2;
            return _loc1_;
         }
         return null;
      }
      
      private function getKeywordRect(param1:String) : Rectangle
      {
         var _loc4_:UIHyperlinksTextFieldHyperlinkInfo = null;
         var _loc2_:Rectangle = null;
         var _loc3_:ChannelMessageRenderer = Tibia.s_GetUIEffectsManager().findUIElementByIdentifier(ChannelMessageRenderer,param1) as ChannelMessageRenderer;
         if(_loc3_ != null)
         {
            for each(_loc4_ in _loc3_.hyperlinkInfos)
            {
               if(_loc4_.hyperlinkText == param1)
               {
                  if(_loc4_.globalRectangles.length > 0)
                  {
                     _loc2_ = _loc4_.globalRectangles[0];
                  }
               }
            }
         }
         return _loc2_;
      }
   }
}

class UIComponentInfo extends GUIRectangleInfo
{
    
   
   public var m_Identifier:Class = null;
   
   public var m_SubIdentifier = null;
   
   function UIComponentInfo()
   {
      super();
   }
}

class KeywordInfo extends GUIRectangleInfo
{
    
   
   public var m_KeywordString:String = null;
   
   function KeywordInfo()
   {
      super();
   }
}

class GUIRectangleInfo
{
    
   
   function GUIRectangleInfo()
   {
      super();
   }
}

import shared.utility.Vector3D;

class CoordinateInfo extends GUIRectangleInfo
{
    
   
   public var m_Coordinate:Vector3D = null;
   
   function CoordinateInfo()
   {
      super();
   }
}
