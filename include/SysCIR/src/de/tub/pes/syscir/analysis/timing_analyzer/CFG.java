package de.tub.pes.syscir.analysis.timing_analyzer;

import java.util.*;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import de.tub.pes.syscir.analysis.data_race_analyzer.AtomicBlock;

/**
 * A simple class simulating the concept of
 * a control flow graph.
 *
 * @author mario
 */
public class CFG<T> {
	
	private static Logger logger = LogManager.getLogger(TimingAnalyzer.class.getName());

	private final Class<T> classType;
	private Set<T> nodes; 

	// map node to successors
	private Map<T, Set<T>> successorEdges; 
	private Map<T, Set<T>> predecessorEdges; 

	private T root;

	public CFG(Class<T> classType) {
		this.classType = classType;
		root = null;
		nodes = new HashSet<T>();
		predecessorEdges = new HashMap<T, Set<T>>();
		successorEdges = new HashMap<T, Set<T>>();
	}

	public boolean addNode(T node) {
		boolean retVal = nodes.add(node);
		successorEdges.put(node, new HashSet<T>());
		predecessorEdges.put(node, new HashSet<T>());
		if (nodes.size() == 1) {
			root = node;
		}
		return retVal;
	}
	
	public boolean addEdges(T from, Set<T> toSet) {
		boolean retVal = true;
		for (T to : toSet) { 
			retVal &= addEdge(from, to); 
		}
		return retVal;
	}
	
	
	/**
	 * Adds the to-node to the from's children.
	 * Both nodes must already exist in the CFG.
	 * 
	 * @param from The parent node. Must already exist.
	 * @param to The child node. Is appended to existing children.
	 * 
	 * @return True if to is added as a new child node. 
	 * False if this edge already existed, or from or to node didn't exist.
	 */
	public boolean addEdge(T from, T to) {
		boolean retVal = true;
		// cfg must contain both nodes
		if ( (!nodes.contains(from)) || (!nodes.contains(to) )) {
			logger.error("add edge failed");
			return false;
		}
		if ( successorEdges.containsKey(from) ) {
			retVal &= successorEdges.get(from).add(to);
		}
		else {
			Set<T> successors = new HashSet<T>();
			successors.add(to);
			successorEdges.put(from, successors);
		}
	
		if ( predecessorEdges.containsKey(to) ) {
			retVal &= predecessorEdges.get(to).add(from);
		}
		else {
			Set<T> predecessors = new HashSet<T>();
			predecessors.add(from);
			predecessorEdges.put(to, predecessors);
		}
		return retVal;
	}

	/**
	 * Create a new node and append to the parent node.
	 * If the parent node is null but this is the first node
	 * of the graph, the new node is simply added and returned.
	 * 
	 * @param parent The node on which to append. Must already exist in the CFG. 
	 * 
	 * @return The new node. Null if no CTOR was found or 
	 * parent is not in the graph.
	 */
	public T appendNewNode(T parent) {
		T newNode = this.createNode();
		if (parent == null && newNode == root) {
			return newNode;
		}
		if (addEdge(parent, newNode)) {
			return newNode;
		}
		return null;
	}

	/**
	 * 
	 * @param node
	 * @return All successor nodes.
	 */
	public Set<T> getSuccessors(T node) {
		return successorEdges.get(node);
	}
	
	public Set<T> findParents(T node) {
		// deprecated, now we can use predecessors
		Set<T> parents = new HashSet<T>();
		for (T possibleParent : nodes) {
			if ( successorEdges.get(possibleParent).contains(node) ) {
				parents.add(possibleParent);
			}
		}
		return parents;
	}
	
	public Set<T> getPredecessors(T node) {
		return predecessorEdges.get(node);
	}
	
	/**
	 * 
	 * @param node
	 * @return The number of predecessor nodes
	 */
	public int getNumPredecessors(T node) {
		if (getPredecessors(node) != null) {
			return predecessorEdges.get(node).size();
		}
		return 0;
	}

	/**
	 * 
	 * @param node
	 * @return The number of successor nodes.
	 */
	public int getNumSuccessors(T node) {
		if (getSuccessors(node) != null) {
			return successorEdges.get(node).size();
		}
		return 0;
	}	
	
	/**
	 * Checks if there is at least one node which has this node and 
	 * at least one other node as children.
	 * 
	 * @param node The node to check.
	 * @return Whether there is a node with this and other children.
	 */
	public boolean hasSiblings(T node) {

		for (T possibleParent : nodes) {
			if ( successorEdges.get(possibleParent).contains(node) ) {
				if ( this.getSuccessors(possibleParent).size() > 1) {
					return true;
				}
			}
		}
		return false;
	}


	public String toString() {
		String retString = "CFG: nodes: ";
		nodes.toString();
		return retString;
	}

	public int getNumNodes() {
		return nodes.size();
	}

	public T getStartNode() {
		return root;
	}
	
	public Collection<T> getAllNodes() {
		return successorEdges.keySet();
	}

	public T createNode() {
		T newNode = null;
		try {
			newNode = classType.newInstance(); 
		} catch (InstantiationException e) {
			e.printStackTrace();
		} catch (IllegalAccessException e) {
			e.printStackTrace();
		}
		if ( this.addNode(newNode) ) {
			return newNode;
		}
		return null;
		
	}
};
