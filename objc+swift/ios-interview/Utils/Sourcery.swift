//
// Created by Michael Gray on 10/10/20.
// Copyright (c) 2020 Takeout Central. All rights reserved.
//

import Foundation

/// Marking a struct as implementing DataStruct generates an extension which
/// contains a 'copy(...)' function that works similar to the 'copy' function
/// in Kotlin data classes. 'copy(...)' returns a copy of the struct with
/// new data as specified by the named parameters passed to the function. Only
/// fields that you wish to modify need be passed in to the function, but they
/// must be passed in in the order defined in the function
///
/// A struct marked as DataStruct must also conform to Equatable
///
/// This is handy for keeping structs immutable while being able to easily
/// modify a copy
public protocol DataStruct: Equatable {}
