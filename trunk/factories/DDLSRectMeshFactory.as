package DDLS.factories
{
	import DDLS.data.DDLSConstants;
	import DDLS.data.DDLSConstraintSegment;
	import DDLS.data.DDLSConstraintShape;
	import DDLS.data.DDLSEdge;
	import DDLS.data.DDLSFace;
	import DDLS.data.DDLSMesh;
	import DDLS.data.DDLSVertex;

	public class DDLSRectMeshFactory
	{
		
		public static function buildRectangle(width:Number, height:Number):DDLSMesh
		{
			/*
			   TL
		 	----+-----+ TR
			\   |    /|
			\   |   / |
			\   |  /  |
			\   | /   |
			\   |/    |
			\   +-----+ BR
			\  BL     \
			\----------
			*/
			
			var vTL:DDLSVertex = new DDLSVertex();
			var vTR:DDLSVertex = new DDLSVertex();
			var vBR:DDLSVertex = new DDLSVertex();
			var vBL:DDLSVertex = new DDLSVertex();
			
			var eTL_TR:DDLSEdge = new DDLSEdge();
			var eTR_TL:DDLSEdge = new DDLSEdge();
			var eTR_BR:DDLSEdge = new DDLSEdge();
			var eBR_TR:DDLSEdge = new DDLSEdge();
			var eBR_BL:DDLSEdge = new DDLSEdge();
			var eBL_BR:DDLSEdge = new DDLSEdge();
			var eBL_TL:DDLSEdge = new DDLSEdge();
			var eTL_BL:DDLSEdge = new DDLSEdge();
			var eTR_BL:DDLSEdge = new DDLSEdge();
			var eBL_TR:DDLSEdge = new DDLSEdge();
			var eTL_BR:DDLSEdge = new DDLSEdge();
			var eBR_TL:DDLSEdge = new DDLSEdge();
			
			var fTL_BL_TR:DDLSFace = new DDLSFace();
			var fTR_BL_BR:DDLSFace = new DDLSFace();
			var fTL_BR_BL:DDLSFace = new DDLSFace();
			var fTL_TR_BR:DDLSFace = new DDLSFace();
			
			var boundShape:DDLSConstraintShape = new DDLSConstraintShape();
			var segTop:DDLSConstraintSegment = new DDLSConstraintSegment();
			var segRight:DDLSConstraintSegment = new DDLSConstraintSegment();
			var segBot:DDLSConstraintSegment = new DDLSConstraintSegment();
			var segLeft:DDLSConstraintSegment = new DDLSConstraintSegment();
			
			var mesh:DDLSMesh = new DDLSMesh(width, height);
			
			//
			
			var offset:Number = DDLSConstants.EPSILON*1000;
			vTL.pos.set(0 - offset, 0 - offset);
			vTR.pos.set(width + offset, 0 - offset);
			vBR.pos.set(width + offset, height + offset);
			vBL.pos.set(0 - offset, height + offset);
			
			vTL.setDatas(eTL_TR);
			vTR.setDatas(eTR_BR);
			vBR.setDatas(eBR_BL);
			vBL.setDatas(eBL_TL);
			
			eTL_TR.setDatas(vTL, eTR_TL, eTR_BR, fTL_TR_BR, true, true);
			eTR_TL.setDatas(vTR, eTL_TR, eTL_BL, fTL_BL_TR, true, true);
			eTR_BR.setDatas(vTR, eBR_TR, eBR_TL, fTL_TR_BR, true, true);
			eBR_TR.setDatas(vBR, eTR_BR, eTR_BL, fTR_BL_BR, true, true);
			eBR_BL.setDatas(vBR, eBL_BR, eBL_TL, fTL_BR_BL, true, true);
			eBL_BR.setDatas(vBL, eBR_BL, eBR_TR, fTR_BL_BR, true, true);
			eBL_TL.setDatas(vBL, eTL_BL, eTL_BR, fTL_BR_BL, true, true);
			eTL_BL.setDatas(vTL, eBL_TL, eBL_TR, fTL_BL_TR, true, true);
			eTR_BL.setDatas(vTR, eBL_TR, eBL_BR, fTR_BL_BR, true, false);// diagonal edge
			eBL_TR.setDatas(vBL, eTR_BL, eTR_TL, fTL_BL_TR, true, false);// diagonal edge
			eTL_BR.setDatas(vTL, eBR_TL, eBR_BL, fTL_BR_BL, false, false);// imaginary edge
			eBR_TL.setDatas(vBR, eTL_BR, eTL_TR, fTL_TR_BR, false, false);// imaginary edge
			
			fTL_BL_TR.setDatas(eBL_TR);
			fTR_BL_BR.setDatas(eTR_BL);
			fTL_BR_BL.setDatas(eBR_BL, false);
			fTL_TR_BR.setDatas(eTR_BR, false);
			
			// constraint relations datas
			vTL.fromConstraintSegments.push(segTop, segLeft);
			vTR.fromConstraintSegments.push(segTop, segRight);
			vBR.fromConstraintSegments.push(segRight, segBot);
			vBL.fromConstraintSegments.push(segBot, segLeft);
			
			eTL_TR.fromConstraintSegments.push(segTop);
			eTR_TL.fromConstraintSegments.push(segTop);
			eTR_BR.fromConstraintSegments.push(segRight);
			eBR_TR.fromConstraintSegments.push(segRight);
			eBR_BL.fromConstraintSegments.push(segBot);
			eBL_BR.fromConstraintSegments.push(segBot);
			eBL_TL.fromConstraintSegments.push(segLeft);
			eTL_BL.fromConstraintSegments.push(segLeft);
			
			segTop.edges.push(eTL_TR);
			segRight.edges.push(eTR_BR);
			segBot.edges.push(eBR_BL);
			segLeft.edges.push(eBL_TL);
			segTop.fromShape = boundShape;
			segRight.fromShape = boundShape;
			segBot.fromShape = boundShape;
			segLeft.fromShape = boundShape;
			boundShape.segments.push(segTop, segRight, segBot, segLeft);
			
			mesh.__vertices.push(vTL, vTR, vBR, vBL);
			mesh.__edges.push(eTL_TR, eTR_TL, eTR_BR, eBR_TR, eBR_BL, eBL_BR, eBL_TL, eTL_BL, eTR_BL, eBL_TR, eTL_BR, eBR_TL);
			mesh.__faces.push(fTL_BL_TR, fTR_BL_BR, fTL_BR_BL, fTL_TR_BR);
			mesh.__constraintShapes.push(boundShape);
			
			var securityRect:Vector.<Number> = new Vector.<Number>();
			securityRect.push(0, 0, width, 0);
			securityRect.push(width, 0, width, height);
			securityRect.push(width, height, 0, height);
			securityRect.push(0, height, 0, 0);
			mesh.clipping = false;
			mesh.insertConstraintShape(securityRect);
			mesh.clipping = true;
			
			return mesh;
		}
		
	}
}