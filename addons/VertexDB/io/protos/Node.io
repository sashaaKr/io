
VertexDB Node := Object clone do(
	
	// api
	//host ::= method(Settings host)
	//port ::= method(Settings port)

	
	path ::= "/"
		
	with := method(path,
		self clone setPath(path)
	)
	
	nodeAt := method(name,
		Node clone setPath(Path with(path, name))
	)
	
	asQueue := method(
		Queue with(self)
	)
	
	// reads
	// query

	queryRequest := method(
		QueryRequest clone setPath(self path)
	)
	
	keys := method(
		queryRequest setOp("keys") results
	)
	
	values := method(
		queryRequest setOp("values") results
	)
	
	pairs := method(
		queryRequest setOp("pairs") results
	)
	
	counts := method(
		queryRequest setOp("counts") results
	)
	
	object := method(
		queryRequest setOp("object") results
	)
	
	/*
	rm := method(
		queryRequest setOp("rm") setMethod("rm") results
	)
	*/
		
	read := method(key,
		ReadRequest clone setPath(path) setKey(key) results
	)

	size := method(
		SizeRequest clone setPath(path) results
	)
	
	rm := method(key,
		RmRequest clone setPath(path) setKey(key) results
		self
	)
		
	atWrite := method(key, value,
		Transaction current appendRequest(
			//WriteRequest clone setPath(path) setKey(key) setValue(value)
			w := WriteRequest clone 
			w path := path
			w key := key
			w value := value
			w
		)
		self
	)
	
	mkdir := method(
		Transaction current appendRequest(MkdirRequest clone setPath(path))
		self
	)
	
	linkToRequest := method(aPath,
		request\
			setAction("link")\
			addQuerySlots(list("fromPath", "toPath", "key"))\
			setPath(self path)\
			setToPath(aPath pathComponent)\
			setKey(aPath lastPathComponent)\
			setHttpMethod("post")
	)
	
	linkTo := method(aPath,
		Transaction current appendRequest(linkToRequest(aPath))
		self
	)
	
	moveKeyToNode := method(key, node,
		nodeAt(key) linkTo(node nodeAt(key))
		rm(key)
		self
	)
	
	//queues
	queuePopToRequest := method(aPath,
		request\
			setAction("queuePopTo")\
			addQuerySlots(list("path", "ttl", "whereKey", "whereValue"))\
			setPath(aPath)\
			setHttpMethod("post")
	)
	
	queuePopTo := method(aPath,
		Transaction current appendRequest(queuePopToRequest(aPath))
	)
	
	queueToNode := method(aNode,
		queuePopTo(aNode path)
	)
	
	queueExpireToRequest := method(aPath,
		request\
			setAction("queueExpireTo")\
			addQuerySlots(list("path"))\
			setPath(aPath)\
			setHttpMethod("post")
	)
	
	queueExpireTo := method(aPath,
		Transaction current appendRequest(queueExpireToRequest(aPath))
		self
	)
	
	queueExpireToNode := method(aNode,
		queueExpireTo(aNode path)
		self
	)

) 
