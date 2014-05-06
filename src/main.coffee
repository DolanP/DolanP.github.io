#= require Bot.coffee
#= require Block.coffee
#= require GA.coffee
#= require NN.coffee
#= require ReqAnimFrameShim.coffee

class SubSystem
    init: ->
    update: (ms) ->
  
class SubSystemThreeJs extends SubSystem
    init: ->
    update: (ms) ->
  
class SubSystemAmmoJs
    init: ->
    update: (ms) ->

    
#
do ->
    #nn = new NN()
    #nn.evaluate()
    #neuron = new Neuron()
    
    rafs = new ReqAnimFrameShim()
    Physijs.scripts.worker = 'Physijs/physijs_worker.js'
    Physijs.scripts.ammo = '../ammo.js/builds/ammo.fast.js'
    
    
    #nn = new NN()
    
    @width = 640
    @height = 480

    @azimuth = 0.0
    @altitude = Math.PI/4

    @kLeft = 37
    @kUp = 38
    @kRight = 39
    @kDown = 40
    

    @mouse = {x:undefined, y:undefined}

    @keys = []
    @keys[@kLeft] = false
    @keys[@kUp] = false
    @keys[@kRight] = false
    @keys[@kDown] = false
  
    $(document).ready( ->
        
            
    
    
    #keyCodeDown = keyDown.map( (x) -> x.keyCode )
    #keyCodeDown.log()
 
        #rafs = new ReqAnimFrameShim()
        init()
        
        
    )
    
    showInfo = (object) ->
        if (not @currentSelected?) || (@currentSelected isnt object) #if something new is selected
            @currentSelected = object
            #console.log @currentSelected
            
        #generate html
        #@currentSelectedDomElement = document.createElement("div")
        #@currentSelectedDomElement["id"] = "generatedInfoDiv"
            
        $("#forInfo").empty()
        str = "<div id=\"toAccordion\">"
        for property of object
            str += "<div class=\"group\"><h3>"+property+"</h3><div>"+property+"</div></div>"
        str += "</div>"
      
        #console.log str
        $("#generatedInfoDiv").append str
        # console.log ("str: " + str)
        #console.log $("#generatedInfoDiv")
        #console.log $("#forInfo")
        #$("#forInfo").append $("#generatedInfoDiv")
        $("#forInfo").append str
        #console.log $("#forInfo")
      
      
        $("#toAccordion").accordion({header: "> div > h3"}).sortable({
            axis: "y",
            handle: "h3",
            stop: ( event, ui ) ->
                #IE doesn't register the blur when sorting
                #so trigger focusout handlers to remove .ui-state-focus
                ui.item.children( "h3" ).triggerHandler( "focusout" )
        })
      
    
    initScene = ->
        @scene = new Physijs.Scene
        @scene.setGravity(new THREE.Vector3( 0, 0, 0 ))
        
        @camera = new THREE.PerspectiveCamera( 60, @width / @height, 0.1, 1000 )

        @renderer = new THREE.WebGLRenderer()
        @renderer.setSize( @width, @height )
        @renderer.setClearColor( {r:0.0,g:0.0,b:0.0}, 1.0 )

        @currentSelected = null
        @currentSelectedDomElement = null

        @renderer.shadowMapEnabled = true;
        @renderDivElement = document.createElement("div")
        #document.body.appendChild @renderDivElement
        @renderDivElement.appendChild @renderer.domElement
        #console.log($("#forCanvas"))
        $("#forCanvas").append @renderer.domElement

        @canvasMouseMoveStream = $(@renderer.domElement).asEventStream("mousemove")
        @canvasMouseMoveStream.onValue( (e) ->
            @mouse.x = (e.offsetX / @width) * 2 - 1
            @mouse.y = ((e.offsetY / @height) * 2 - 1) * -1
        )


        @geometry = new THREE.CubeGeometry(1,1,1)
        @material = new THREE.MeshPhongMaterial({
            ambient        : 0x444444,
            color		: 0x8844AA,
            shininess	: 300, 
            specular	: 0x33AA33,
            shading		: THREE.SmoothShading 
        })
        @cube = new THREE.Mesh( @geometry, @material )
        
        #@planeGeom = new THREE.PlaneGeometry( 10, 10, 20, 20 )
        xMin = -10.0
        xMax = 10.0
        zMin = 10.0
        zMax = -10.0
        
        func = (x,z) -> x*x + z*z
        uTransform = (u) -> ( u * (xMax - xMin) ) + xMin
        vTransform = (v) -> ( v * (zMax - zMin) ) + zMin
        
        parametricFunc = (u,v) ->
            x = uTransform u
            z = vTransform v
            y = func( x, z )
            new THREE.Vector3( x, y, z )
        
        #@planeGeom = new THREE.ParametricGeometry( parametricFunc, 20, 20 )
        @planeGeom = new THREE.PlaneGeometry(1000, 1000, 100, 100)
        
        #console.log @planeGeom
         
        
        @planeMat = new THREE.MeshPhongMaterial({
            ambient    	: 0x444444,
            color		: 0x554455,
            shininess	: 10, 
            specular	: 0x33AA33,
            shading		: THREE.SmoothShading 
        })
        
        ###@planeMat = new THREE.MeshBasicMaterial({
            wireframe:true
        })
        ###
        #console.log @planeMat
        @plane = new THREE.Mesh( @planeGeom, @planeMat )
        @plane.position.y = 0
        @plane.rotation.x = -Math.PI/2
        #@cube.castShadow = true;
        @plane.receiveShadow  = true;
        #@scene.add( @cube )
        
        @axisHelper = new THREE.AxisHelper( 10 )
        @scene.add( @axisHelper )
        
        #@scene.add( @plane )
        @myBot = new Bot(@world, @scene)
        #@scene.add( @myBot )
        #@myBot.addToScene( @scene )
        @myBot.body.position.y = 0.7
        @myBot.body.position.z = 5.0
        
        @camera.position.x = 0
        @camera.position.y = 15
        @camera.position.z = 0

        @camera.lookAt(@scene.position)
        #@camera.rotation.x -= (Math.PI / 4)

        @ambient = new THREE.AmbientLight( 0x777777 )
        @scene.add( @ambient )

        @light = new THREE.SpotLight( 0x4444cc )
        @light.position.set( 0, 10, 0 )
        @light.castShadow = true
        @light.target.position.set( 0, 0, 0 )
        @light.shadowCameraNear = 0.01
        #@light.shadowCameraNear = 500;
        @light.shadowCameraFar = 4000;
        @light.shadowCameraFov = 60;
        #@light.shadowCameraVisible = true
        @scene.add( @light )
    
        @projector = new THREE.Projector()
        
    initBlocks = ->
        #console.log "initBlocks()"
        @numBlocks = 200
        @blocks = []
        max = 10
        min = -10
        
        for i in [1 .. @numBlocks]
            r1 = (Math.random() * (max - min)) + min
            #r2 = (Math.random() * (max - min)) + min
            r3 = (Math.random() * (max - min)) + min
            
            block = new Block( new THREE.Vector3( r1, 0.7, r3 ), @world, @scene )
            @blocks.push( block )
            #if @scene? 
                #block.addToScene( @scene )
                #console.log r1+","+r3+",block: " + block + ", scene: " + @scene
        
    getMaxBestAndAvg = ->
        maxBest = 0
        maxAvg = 0
        for {best, avg} in @graphData
            if best > maxBest then maxBest = best
            if avg > maxAvg then maxAvg = avg
        [maxBest, maxAvg]
        
    initGA = ->
        @gaConfig = new GAConfig()

        @gaConfig.populationSize = 100
        @gaConfig.boundaries = [[-1000,1000],[-1000,1000]]
      
        @ga = new GeneticAlgorithm(@gaConfig)
      
        @ga.initialize()
      
        @simulatees = @ga.currentPopulation
      
        #console.log @ga.currentPopulation
        
    initInputStreams = ->
        keyDown = $(document).asEventStream("keydown")
        keyUp = $(document).asEventStream("keyup")
        keyDown.onValue( (x) -> @keys[x.keyCode] = true )
        keyUp.onValue( (x) -> @keys[x.keyCode] = false )
        
        botLeftTrackForwardsKeyDown = keyDown.filter( (x) -> true if (x.keyCode is 81) ).map(1.0)#.log() #q keyCode is 81
        botLeftTrackBackwardsKeyDown = keyDown.filter( (x) -> true if (x.keyCode is 65) ).map(-1.0)#.log() #a is 65
        botLeftTrackKeyUp = keyUp.filter( (x) -> x.keyCode is 81 or x.keyCode is 65 ).map(0.0)#.log()
        botLeftTrackInput = botLeftTrackForwardsKeyDown.merge(botLeftTrackBackwardsKeyDown).merge(botLeftTrackKeyUp).skipDuplicates().toProperty(0.0)#.log()
        
        botRightTrackForwardsKeyDown = keyDown.filter( (x) -> true if (x.keyCode is 87) ).map(1.0)#.log() #w is 87
        botRightTrackBackwardsKeyDown = keyDown.filter( (x) -> true if (x.keyCode is 83) ).map(-1.0)#.log() #s is 83
        botRightTrackKeyUp = keyUp.filter( (x) -> x.keyCode is 87 or x.keyCode is 83 ).map(0.0)#.log()
        botRightTrackInput = botRightTrackForwardsKeyDown.merge(botRightTrackBackwardsKeyDown).merge(botRightTrackKeyUp).skipDuplicates().toProperty(0.0)#.log()
        
        ###
        botLeftTrackInput.combine(botRightTrackInput, 
            (l, r) -> [l, r]
        ).log()
        ###
        
        botTracksInput = botLeftTrackInput.combine(botRightTrackInput, 
            (l, r) -> [l, r]
        )
        
        botTracksInput.onValue( ([l, r]) -> @myBot.setInput(l, r) if @myBot? )
  
    init = -> 
    
        initScene()
        #initGA()
        initBlocks()
        
        @myBot.body.addEventListener( 'collision', (( other_object, linear_velocity, angular_velocity ) -> 
            #console.log other_object.myTag
            #console.log other_object
            #console.log @wtf
            #scene.remove( other_object )
            max = 10
            min = -10
        
            block = other_object.myTag
            r1 = (Math.random() * (max - min)) + min
            #r2 = (Math.random() * (max - min)) + min
            r3 = (Math.random() * (max - min)) + min
            block.block.position.x = r1
            block.block.position.z = r3
            #block.block.geometry.verticesNeedUpdate = true
            block.block.__dirtyPosition = true;
            
            #console.log r1 + " "+  r3
            
            
        ))
        
        initInputStreams()
        
        chrmsm = (((Math.random() * 2.0) - 1.0) for num in [1 .. 60])
        
        nnConfig = new NNConfig([4, 10, 2], chrmsm)
        @nn = new NN(nnConfig)
        
    
        @updateBus = new Bacon.Bus()
        @updateBus.onValue( (ms) -> update ms )
        
        @updateBus.onValue( (ms) -> @myBot.update() )
        
        @generationResetTimer = @updateBus.scan(0.0, ((a, b) -> a + b))
        
        @botPerceptionStream = @updateBus.map( (ms) -> 
            v1 = getBotForwardVector @myBot
            v2 = getClosestBlockVector @myBot
            [v1, v2])
            
        @botPerceptionStreamForNn = @updateBus.map( (ms) -> 
            v1 = getBotForwardVector @myBot
            v2 = getClosestBlockVector @myBot
            [v1.x, v1.z, v2.x, v2.z])#.log()
            
        #@botPerceptionStreamForNn.map( (input) -> @nn.evaluate(input)).log()
        @nnStream = @botPerceptionStreamForNn.map( (input) -> @nn.evaluate(input))
        @nnStream.onValue( ([l, r]) -> @myBot.setInput(l, r) if @myBot? )
        @nnStream.onValue( @myBot.update() )
            
        @botPerceptionStream.onValue ( ([forwardVec, closestVec]) -> renderBotPerceptions(forwardVec, closestVec) )
    
        updateUpdateBus()
        
    updateCamera = ->
        
        @distance = 15
    
        @camera.position.y = @distance * (Math.sin @altitude)
        @camera.position.z = @distance * (Math.cos @altitude)

        

        #console.log(@mouse)
    @oldTime = new Date
  
    updateUpdateBus = ->
        @currentTime = new Date
        ms = @currentTime - @oldTime
        @oldTime = @currentTime
        @updateBus.push ms
    
        window.requestAnimationFrame(updateUpdateBus)
    
    evalFitness = (simulatee) ->
        simulatee[0]*simulatee[0] + simulatee[1]*simulatee[1]
    
    extractSimulatees = ->
        @simulatees = []
        @simulatees.push(chromosome) for chromosome in @ga.currentPopulation
        
    getBestFitness = (fitnesses) ->
        min = fitnesses[0]
        (min = fitness) if (fitness < min) for fitness in fitnesses
        min
        
    getAverageFitness = (fitnesses) ->
        total = 0
        (total += f) for f in fitnesses
        total / fitnesses.length
    
    updateGA = (ms) ->
        if not @totalTime? then @totalTime = 0.0
      
        @totalTime += ms
      
        if @totalTime > (10.0 * 1000)
            #collect fitnesses
            fitnesses = []
            fitnesses.push(evalFitness simulatee) for simulatee in @simulatees
        
            #update GA
            @ga.update fitnesses
            #console.log "update results: " + fitnesses
            bestFitness = getBestFitness fitnesses
            averageFitness = getAverageFitness fitnesses
            
            
            #updateGraphScene(bestFitness, averageFitness)
            
            #console.log ("Iteration " + @ga.currentIteration + ", Best: " + bestFitness + ", Average: " + averageFitness)
            #extract evolved population
            extractSimulatees()
        
            @totalTime = 0.0
            
    getBotForwardVector = (bot) ->
        v1 = bot.body.localToWorld( new THREE.Vector3( 0, 0, 1.0 ) )
        v2 = bot.body.position
        v3 = new THREE.Vector3().subVectors(v1, v2)
        v3
        
    getClosestBlockVector = (bot) ->
        closestBlock = @blocks[0]
        v = new THREE.Vector3().subVectors(bot.body.position, @blocks[0].block.position)
        minDist = v.lengthSq()
        for block in @blocks
            v = new THREE.Vector3().subVectors(bot.body.position, block.block.position)
            t = v.lengthSq()
            if t < minDist
                minDist = t
                closestBlock = block
                
        v1 = (new THREE.Vector3().subVectors(closestBlock.block.position, bot.body.position)).normalize()
        v1
    
    renderBotPerceptions = (forwardVec, closestVec) ->
        if not @line?
            geometry = new THREE.Geometry()
            
            geometry.vertices.push( @myBot.body.position )
            geometry.colors.push( new THREE.Color( 0xff0000 ), new THREE.Color( 0xff0000 ) )
            geometry.vertices.push( new THREE.Vector3().addVectors(@myBot.body.position, forwardVec) )
            #console.log "fv: " + forwardVec
            
            geometry.colors.push( new THREE.Color( 0xff0000 ), new THREE.Color( 0xff0000 ) )
            
            #geometry.computeBoundingSphere()
            @line = new THREE.Line( geometry )
            @scene.add (@line )
        else
            @line.geometry.vertices[0] = @myBot.body.position
            @line.geometry.vertices[1] = new THREE.Vector3().addVectors(@myBot.body.position, forwardVec)
            @line.geometry.verticesNeedUpdate = true
            
        if not @lineToClosestBlock?
            geometry = new THREE.Geometry()
            
            geometry.vertices.push( @myBot.body.position )
            geometry.colors.push( new THREE.Color( 0xff0000 ), new THREE.Color( 0xff0000 ) )
            
            geometry.vertices.push( new THREE.Vector3().addVectors(@myBot.body.position, closestVec) )
            #console.log "cv: " + closestVec
            
            geometry.colors.push( new THREE.Color( 0xff0000 ), new THREE.Color( 0xff0000 ) )
            
            #geometry.computeBoundingSphere()
            @lineToClosestBlock = new THREE.Line( geometry )
            @scene.add (@lineToClosestBlock)
        else
            @lineToClosestBlock.geometry.vertices[0] = @myBot.body.position
            @lineToClosestBlock.geometry.vertices[1] = new THREE.Vector3().addVectors(@myBot.body.position, closestVec)
            @lineToClosestBlock.geometry.verticesNeedUpdate = true

    update = (ms) ->
        @scene.simulate()
        @renderer.render(@scene, @camera)
    
    