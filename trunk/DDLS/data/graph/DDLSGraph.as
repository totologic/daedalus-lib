package DDLS.data.graph
{
	public class DDLSGraph
	{
		
		private static var INC:int = 0;
		private var _id:int;
		
		private var _node:DDLSGraphNode;
		private var _edge:DDLSGraphEdge;
		
		public function DDLSGraph()
		{
			_id = INC;
			INC++;
		}

		public function get id():int
		{
			return _id;
		}
		
		public function dispose():void
		{
			while (_node)
				deleteNode(_node);
		}
		
		public function get edge():DDLSGraphEdge
		{
			return _edge;
		}
		
		public function get node():DDLSGraphNode
		{
			return _node;
		}
		
		public function insertNode():DDLSGraphNode
		{
			var node:DDLSGraphNode = new DDLSGraphNode();
			if (_node)
			{
				node.next = _node;
				_node.prev = node;
			}
			_node = node;
			
			return node;
		}
		
		public function deleteNode(node:DDLSGraphNode):void
		{
			while (node.outgoingEdge)
			{
				if (node.outgoingEdge.oppositeEdge)
					deleteEdge(node.outgoingEdge.oppositeEdge);
				deleteEdge(node.outgoingEdge);
			}
			
			var otherNode:DDLSGraphNode = _node;
			var incomingEdge:DDLSGraphEdge;
			while (otherNode)
			{
				incomingEdge = otherNode.successorNodes[node];
				if (incomingEdge)
					deleteEdge(incomingEdge);
				otherNode = otherNode.next;
			}
			
			if (_node == node)
			{
				if (node.next)
				{
					node.next.prev = null;
					_node = node.next;
				}
				else
				{
					_node = null;
				}
			}
			else
			{
				if (node.next)
				{
					node.prev.next = node.next;
					node.next.prev = node.prev;
				}
				else
				{
					node.prev.next = null;
				}
			}
			
			node.dispose();
		}
		
		public function insertEdge(fromNode:DDLSGraphNode, toNode:DDLSGraphNode):DDLSGraphEdge
		{
			if (fromNode.successorNodes[toNode])
				return null;
			
			var edge:DDLSGraphEdge = new DDLSGraphEdge();
			if (_edge)
			{
				_edge.prev = edge;
				edge.next = _edge;
			}
			_edge = edge;
			
			edge.sourceNode = fromNode;
			edge.destinationNode = toNode;
			fromNode.successorNodes[toNode] = edge;
			if (fromNode.outgoingEdge)
			{
				fromNode.outgoingEdge.rotPrevEdge = edge;
				edge.rotNextEdge = fromNode.outgoingEdge;
				fromNode.outgoingEdge = edge;
			}
			else
			{
				fromNode.outgoingEdge = edge;
			}
			
			var oppositeEdge:DDLSGraphEdge = toNode.successorNodes[fromNode];
			if (oppositeEdge)
			{
				edge.oppositeEdge = oppositeEdge;
				oppositeEdge.oppositeEdge = edge;
			}
			
			return edge;
		}
		
		public function deleteEdge(edge:DDLSGraphEdge):void
		{
			delete edge.sourceNode.successorNodes[edge.destinationNode];
			
			if (_edge == edge)
			{
				if (edge.next)
				{
					edge.next.prev = null;
					_edge = edge.next;
				}
				else
				{
					_edge = null;
				}
			}
			else
			{
				if (edge.next)
				{
					edge.prev.next = edge.next;
					edge.next.prev = edge.prev;
				}
				else
				{
					edge.prev.next = null;
				}
			}
			
			if (edge.sourceNode.outgoingEdge == edge)
			{
				if (edge.rotNextEdge)
				{
					edge.rotNextEdge.rotPrevEdge = null;
					edge.sourceNode.outgoingEdge = edge.rotNextEdge;
				}
				else
				{
					edge.sourceNode.outgoingEdge = null;
				}
			}
			else
			{
				if (edge.rotNextEdge)
				{
					edge.rotPrevEdge.rotNextEdge = edge.rotNextEdge;
					edge.rotNextEdge.rotPrevEdge = edge.rotPrevEdge;
				}
				else
				{
					edge.rotPrevEdge.rotNextEdge = null;
				}
			}
			
			edge.dispose();
		}
		
	}
}