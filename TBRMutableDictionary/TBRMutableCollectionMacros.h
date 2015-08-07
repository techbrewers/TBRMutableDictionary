//
//  TBRMutableCollectionMacros.h
//  TBRMutableDictionary
//
//  Created by Luciano Marisi on 07/08/2015.
//  Copyright (c) 2015 TechBrewers LTD. All rights reserved.
//

#ifndef TBRMutableDictionary_TBRMutableCollectionMacros_h
#define TBRMutableDictionary_TBRMutableCollectionMacros_h

#define dispatch_sync_with_return_type(type, synchronousQueue, returningBlock) \
  __block type typedVariable;\
  dispatch_sync(synchronousQueue, ^{\
    typedVariable = returningBlock();\
  });\
  return typedVariable;\

#endif
