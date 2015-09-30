import Foundation

infix operator ~>> { associativity left }

extension CacheLevel {
  
  /**
  Adds a post-processing step to the get results of this CacheLevel
  
  :param: transformer The OneWayTransformer that will be applied to every successful result of the method get called on the cache level. The transformer has to return the same type of the input type, and the transformation won't be applied when setting values on the cache level.
  
  :returns: A transformed CacheLevel that incorporates the post-processing step
  
  :discussion: As usual, if the transformation fails, the get request will also fail
  */
  public func postProcess<A: OneWayTransformer where OutputType == A.TypeIn, A.TypeIn == A.TypeOut>(transformer: A) -> BasicCache<KeyType, OutputType> {
    return BasicCache(
      getClosure: { key in
        return self.get(key).mutate(transformer)
      },
      setClosure: self.set,
      clearClosure: self.clear,
      memoryClosure: self.onMemoryWarning
    )
  }
  
  /**
  Adds a post-processing step to the get results of this CacheLevel
  
  :param: transformerClosure The transformation closure that will be applied to every successful result of the method get called on the cache level. The closure has to return the same type of the input type, and the transformation won't be applied when setting values on the cache level.
  
  :returns: A transformed CacheLevel that incorporates the post-processing step
  
  :discussion: As usual, if the transformation fails, the get request will also fail
  */
  public func postProcess(transformerClosure: OutputType -> OutputType?) -> BasicCache<KeyType, OutputType> {
    return self.postProcess(wrapClosureIntoOneWayTransformer(transformerClosure))
  }
}

/**
Adds a post-processing step to the get results of a fetch closure

:param: fetchClosure The fetch closure you want to decorate
:param: transformer The OneWayTransformer that will be applied to every successful result of the fetch closure. The transformer has to return the same type of the input type

:returns: A CacheLevel that incorporates the post-processing step

:discussion: As usual, if the transformation fails, the get request will also fail
*/
public func postProcess<A, B: OneWayTransformer where B.TypeIn == B.TypeOut>(fetchClosure: (key: A) -> CacheRequest<B.TypeIn>, transformer: B) -> BasicCache<A, B.TypeOut> {
  return wrapClosureIntoCacheLevel(fetchClosure).postProcess(transformer)
}

/**
Adds a post-processing step to the get results of a fetch closure

:param: fetchClosure The fetch closure you want to decorate
:param: transformerClosure The transformation closure that will be applied to every successful result of the fetch closure. The transformation closure has to return the same type of the input type

:returns: A CacheLevel that incorporates the post-processing step

:discussion: As usual, if the transformation fails, the get request will also fail
*/
public func postProcess<A, B>(fetchClosure: (key: A) -> CacheRequest<B>, transformerClosure: B -> B?) -> BasicCache<A, B> {
  return wrapClosureIntoCacheLevel(fetchClosure).postProcess(wrapClosureIntoOneWayTransformer(transformerClosure))
}

/**
Adds a post-processing step to the get results of a CacheLevel

:param: cache The CacheLevel you want to decorate
:param: transformer The OneWayTransformer that will be applied to every successful result of the CacheLevel. The transformer has to return the same type of the input type, and the transformation won't be applied when setting values on the cache level.

:returns: A transformed CacheLevel that incorporates the post-processing step

:discussion: As usual, if the transformation fails, the get request will also fail
*/
public func postProcess<A: CacheLevel, B: OneWayTransformer where A.OutputType == B.TypeIn, B.TypeIn == B.TypeOut>(cache: A, transformer: B) -> BasicCache<A.KeyType, A.OutputType> {
  return cache.postProcess(transformer)
}

/**
Adds a post-processing step to the get results of a CacheLevel

:param: cache The CacheLevel you want to decorate
:param: transformerClosure The transformation closure that will be applied to every successful result of the method get called on the cache level. The closure has to return the same type of the input type, and the transformation won't be applied when setting values on the cache level.

:returns: A transformed CacheLevel that incorporates the post-processing step

:discussion: As usual, if the transformation fails, the get request will also fail
*/
public func postProcess<A: CacheLevel>(cache: A, transformerClosure: A.OutputType -> A.OutputType?) -> BasicCache<A.KeyType, A.OutputType> {
  return cache.postProcess(wrapClosureIntoOneWayTransformer(transformerClosure))
}

/**
Adds a post-processing step to the get results of a fetch closure

:param: fetchClosure The fetch closure you want to decorate
:param: transformer The OneWayTransformer that will be applied to every successful result of the fetch closure. The transformer has to return the same type of the input type

:returns: A CacheLevel that incorporates the post-processing step

:discussion: As usual, if the transformation fails, the get request will also fail
*/
public func ~>><A, B: OneWayTransformer where B.TypeIn == B.TypeOut>(fetchClosure: (key: A) -> CacheRequest<B.TypeIn>, transformer: B) -> BasicCache<A, B.TypeOut> {
  return postProcess(fetchClosure, transformer: transformer)
}

/**
Adds a post-processing step to the get results of a fetch closure

:param: fetchClosure The fetch closure you want to decorate
:param: transformerClosure The transformation closure that will be applied to every successful result of the fetch closure. The transformation closure has to return the same type of the input type

:returns: A CacheLevel that incorporates the post-processing step

:discussion: As usual, if the transformation fails, the get request will also fail
*/
public func ~>><A, B>(fetchClosure: (key: A) -> CacheRequest<B>, transformerClosure: B -> B?) -> BasicCache<A, B> {
  return postProcess(fetchClosure, transformerClosure: transformerClosure)
}

/**
Adds a post-processing step to the get results of a CacheLevel

:param: cache The CacheLevel you want to decorate
:param: transformer The OneWayTransformer that will be applied to every successful result of the CacheLevel. The transformer has to return the same type of the input type, and the transformation won't be applied when setting values on the cache level.

:returns: A transformed CacheLevel that incorporates the post-processing step

:discussion: As usual, if the transformation fails, the get request will also fail
*/
public func ~>><A: CacheLevel, B: OneWayTransformer where A.OutputType == B.TypeIn, B.TypeIn == B.TypeOut>(cache: A, transformer: B) -> BasicCache<A.KeyType, A.OutputType> {
  return postProcess(cache, transformer: transformer)
}

/**
Adds a post-processing step to the get results of a CacheLevel

:param: cache The CacheLevel you want to decorate
:param: transformerClosure The transformation closure that will be applied to every successful result of the method get called on the cache level. The closure has to return the same type of the input type, and the transformation won't be applied when setting values on the cache level.

:returns: A transformed CacheLevel that incorporates the post-processing step

:discussion: As usual, if the transformation fails, the get request will also fail
*/
public func ~>><A: CacheLevel>(cache: A, transformerClosure: A.OutputType -> A.OutputType?) -> BasicCache<A.KeyType, A.OutputType> {
  return postProcess(cache, transformerClosure: transformerClosure)
}