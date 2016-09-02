package tibia.game
{
   import flash.events.Event;
   import flash.display.InteractiveObject;
   import mx.events.DragEvent;
   import shared.utility.Vector3D;
   import mx.core.DragSource;
   import flash.display.Stage;
   import flash.geom.Point;
   import tibia.input.gameaction.MoveActionImpl;
   import tibia.appearances.ObjectInstance;
   import flash.events.MouseEvent;
   import mx.core.UIComponent;
   import mx.managers.DragManager;
   import flash.display.DisplayObject;
   import mx.events.SandboxMouseEvent;
   import mx.controls.Image;
   import tibia.appearances.AppearanceType;
   import flash.geom.Rectangle;
   import tibia.appearances.widgetClasses.CachedSpriteInformation;
   import flash.display.BitmapData;
   import flash.display.Bitmap;
   import tibia.appearances.AppearanceInstance;
   import tibia.appearances.FrameGroup;
   
   public class ObjectDragImpl
   {
      
      protected static const DRAG_OPACITY:Number = 0.75;
      
      protected static const DRAG_TYPE_OBJECT:String = "object";
      
      protected static const DRAG_TYPE_CHANNEL:String = "channel";
      
      protected static const DRAG_TYPE_SPELL:String = "spell";
      
      protected static const DRAG_TYPE_STATUSWIDGET:String = "statusWidget";
      
      protected static const DRAG_TYPE_WIDGETBASE:String = "widgetBase";
      
      protected static const DRAG_TYPE_ACTION:String = "action";
       
      
      private var m_DragObject:ObjectInstance = null;
      
      private var m_DragPosition:int = -1;
      
      private var m_DragStart:Vector3D = null;
      
      public function ObjectDragImpl()
      {
         super();
      }
      
      private function onMouseUp(param1:Event) : void
      {
         this.removeDragInitListeners(InteractiveObject(param1.currentTarget));
      }
      
      protected function onDragDrop(param1:DragEvent) : void
      {
         var _loc3_:* = undefined;
         var _loc4_:Vector3D = null;
         var _loc5_:int = 0;
         var _loc2_:DragSource = null;
         if((_loc2_ = param1.dragSource) != null && _loc2_.hasFormat("dragType") && _loc2_.dataForFormat("dragType") == DRAG_TYPE_OBJECT && _loc2_.hasFormat("dragStart") && _loc2_.hasFormat("dragPosition") && _loc2_.hasFormat("dragObject"))
         {
            _loc3_ = param1.target;
            while(_loc3_ != null && !(_loc3_ is IMoveWidget) && !(_loc3_ is Stage))
            {
               _loc3_ = _loc3_.parent;
            }
            _loc4_ = null;
            if(_loc3_ != null && (_loc4_ = _loc3_.pointToAbsolute(new Point(param1.stageX,param1.stageY))) != null)
            {
               _loc5_ = 0;
               if(param1.shiftKey)
               {
                  _loc5_ = 1;
               }
               else if(param1.ctrlKey)
               {
                  _loc5_ = MoveActionImpl.MOVE_ASK;
               }
               else
               {
                  _loc5_ = MoveActionImpl.MOVE_ALL;
               }
               Tibia.s_GameActionFactory.createMoveAction(_loc2_.dataForFormat("dragStart") as Vector3D,_loc2_.dataForFormat("dragObject") as ObjectInstance,_loc2_.dataForFormat("dragPosition") as Number,_loc4_,_loc5_).perform();
            }
         }
      }
      
      public function removeDragComponent(param1:InteractiveObject) : void
      {
         if(param1 != null)
         {
            param1.removeEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
            param1.removeEventListener(DragEvent.DRAG_DROP,this.onDragDrop);
            param1.removeEventListener(DragEvent.DRAG_ENTER,this.onDragEnter);
         }
      }
      
      private function onMouseDown(param1:MouseEvent) : void
      {
         this.m_DragStart = null;
         this.m_DragPosition = -1;
         this.m_DragObject = null;
         this.removeDragInitListeners(InteractiveObject(param1.currentTarget));
         var _loc2_:* = param1.currentTarget;
         while(_loc2_ != null && !(_loc2_ is IMoveWidget) && !(_loc2_ is Stage))
         {
            _loc2_ = _loc2_.parent;
         }
         var _loc3_:Object = null;
         var _loc4_:ObjectInstance = null;
         var _loc5_:Vector3D = null;
         if(_loc2_ != null && (_loc3_ = _loc2_.getMoveObjectUnderPoint(new Point(param1.stageX,param1.stageY))) != null && (_loc4_ = _loc3_.object as ObjectInstance) != null && (_loc5_ = _loc3_.absolute as Vector3D) != null)
         {
            this.m_DragStart = _loc5_;
            this.m_DragPosition = int(_loc3_.position);
            this.m_DragObject = _loc4_;
            this.addDragInitListeners(InteractiveObject(param1.currentTarget));
         }
      }
      
      public function addDragComponent(param1:InteractiveObject) : void
      {
         if(param1 != null)
         {
            param1.addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
            param1.addEventListener(DragEvent.DRAG_DROP,this.onDragDrop);
            param1.addEventListener(DragEvent.DRAG_ENTER,this.onDragEnter);
         }
      }
      
      private function onDragEnter(param1:DragEvent) : void
      {
         var _loc2_:DragSource = null;
         if((_loc2_ = param1.dragSource) != null && _loc2_.hasFormat("dragType") && _loc2_.dataForFormat("dragType") == DRAG_TYPE_OBJECT && param1.target is UIComponent && !(param1.cancelable && param1.isDefaultPrevented()))
         {
            DragManager.acceptDragDrop(UIComponent(param1.currentTarget));
         }
      }
      
      private function removeDragInitListeners(param1:InteractiveObject) : void
      {
         var _loc2_:DisplayObject = null;
         if(param1 != null)
         {
            param1.removeEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMove);
            param1.removeEventListener(MouseEvent.MOUSE_UP,this.onMouseUp);
         }
         if(param1 is UIComponent)
         {
            _loc2_ = UIComponent(param1).systemManager.getSandboxRoot();
            _loc2_.removeEventListener(SandboxMouseEvent.MOUSE_UP_SOMEWHERE,this.onMouseUp);
         }
      }
      
      private function addDragInitListeners(param1:InteractiveObject) : void
      {
         var _loc2_:DisplayObject = null;
         if(param1 != null)
         {
            param1.addEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMove);
            param1.addEventListener(MouseEvent.MOUSE_UP,this.onMouseUp);
         }
         if(param1 is UIComponent)
         {
            _loc2_ = UIComponent(param1).systemManager.getSandboxRoot();
            _loc2_.addEventListener(SandboxMouseEvent.MOUSE_UP_SOMEWHERE,this.onMouseUp);
         }
      }
      
      private function onMouseMove(param1:MouseEvent) : void
      {
         var _loc2_:DragSource = null;
         var _loc3_:Image = null;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:AppearanceType = null;
         var _loc7_:Rectangle = null;
         var _loc8_:CachedSpriteInformation = null;
         var _loc9_:BitmapData = null;
         var _loc10_:Bitmap = null;
         if(this.m_DragStart != null && this.m_DragPosition != -1 && this.m_DragObject != null && param1.currentTarget is UIComponent)
         {
            _loc2_ = new DragSource();
            _loc2_.addData(DRAG_TYPE_OBJECT,"dragType");
            _loc2_.addData(this.m_DragStart,"dragStart");
            _loc2_.addData(this.m_DragPosition,"dragPosition");
            _loc2_.addData(this.m_DragObject,"dragObject");
            _loc3_ = new Image();
            _loc4_ = 0;
            _loc5_ = 0;
            _loc6_ = this.m_DragObject.type;
            if(_loc6_ != null && _loc6_.ID != AppearanceInstance.CREATURE && !_loc6_.isBank && !_loc6_.isClip && !_loc6_.isBottom && !_loc6_.isTop)
            {
               _loc7_ = new Rectangle();
               _loc8_ = this.m_DragObject.getSprite(-1,-1,-1,-1);
               _loc9_ = _loc8_.bitmapData;
               _loc7_.copyFrom(_loc8_.rectangle);
               _loc10_ = new Bitmap();
               if(_loc7_ != null && _loc9_ != null)
               {
                  _loc10_.bitmapData = new BitmapData(_loc7_.width,_loc7_.height);
                  _loc10_.bitmapData.copyPixels(_loc9_,_loc7_,new Point(0,0));
               }
               _loc3_.source = _loc10_;
               _loc4_ = _loc7_.width - _loc6_.FrameGroups[FrameGroup.FRAME_GROUP_DEFAULT].exactSize;
               _loc5_ = _loc7_.height - _loc6_.FrameGroups[FrameGroup.FRAME_GROUP_DEFAULT].exactSize;
            }
            this.m_DragStart = null;
            this.m_DragPosition = -1;
            this.m_DragObject = null;
            DragManager.doDrag(UIComponent(param1.currentTarget),_loc2_,param1,_loc3_,-UIComponent(param1.currentTarget).mouseX + _loc4_,-UIComponent(param1.currentTarget).mouseY + _loc5_,DRAG_OPACITY);
            this.removeDragInitListeners(InteractiveObject(param1.currentTarget));
         }
      }
   }
}
