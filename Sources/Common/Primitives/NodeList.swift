//
//  NodeList.swift
//  SlashKit
//
//  Created by Noah Emmet on 4/15/18.
//  Copyright © 2018 Sticks. All rights reserved.
//

import Foundation

public class ListNode<V> {
    public var root: Node<V>

    public init(root: Node<V>) {
        self.root = root
    }
//    public init() {
//        
//    }
}

public class Node<V> {
    public var value: V
    public var children: [Node<V>]
    public weak var parent: Node<V>?

    public init(_ value: V, parent: Node<V>? = nil, children: [Node<V>] = []) {
        self.value = value
        self.children = children
        self.parent = parent
    }
    
    public init(_ value: V, parent: Node<V>? = nil, children: ((Node<V>) -> [Node<V>])) {
        self.value = value
        self.children = []
        self.parent = parent 
        self.children = children(self)
    }
    
    public func iterateChildren(iterator: (Node<V>) -> Void) {
        iterator(self)
        for child in children {
            child.iterateChildren(iterator: iterator)
        }
    }
}
