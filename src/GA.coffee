randomB = (min, max) ->
    (Math.random() * (max - min)) + min

randomlySelectFromArray = (array) ->
    array[Math.floor(Math.random() * array.length)]

class GAConfig
    constructor: ->
        @hallOfFameSize = 0
        @populationSize = 0
        @chromosomeLength = 0
        @boundaries = null
        @maxIterations = 100
        
        #p and k are for tournament selection
        @pStart = 0.2
        @pEnd = 0.9
        
        #k is a percentage of population
        @kStart = 0.1
        @kEnd = 0.9
        
        @mutationRangeStart = 10.0
        @mutationRangeEnd = 0.1
        
        @mutationRateStart = 0.9
        @mutationRateEnd = 0.01
        
        @numParentsForCrossover = 2
        
        

class GeneticAlgorithm
    constructor: (gaConfig) ->
        #console.log "ga constructor"
        @gaConfig = gaConfig
        
    nothing: ->
        
    createChromosome: ->
        chromosome = new Array()
        if (@gaConfig.boundaries?)
            for [min, max] in @gaConfig.boundaries
                chromosome.push(randomB(min, max))
        else
            console.log "GA: createChromosome() failed, Boundaries should be defined"
        chromosome
        
    initialize: ->
        
        #create population 
        # requires population size, chromosome length, possibly element-wise boundaries
        @currentPopulation = new Array()
        @nothing() while @currentPopulation.push(@createChromosome()) < @gaConfig.populationSize
        
        @currentIteration = 0
        
    fromPercentage: (percentage, start, end) ->
        ((percentage * (end - start)) + start)
        
    update: (fitnesses) ->
        
        #adjust variables that change as evolution proceeds
        @percentProgress = @currentIteration / @gaConfig.maxIterations
        @p = @fromPercentage(@percentProgress, @gaConfig.pStart, @gaConfig.pEnd)
        @k = Math.floor(@fromPercentage(@percentProgress, @gaConfig.kStart, @gaConfig.kEnd) * @gaConfig.populationSize)
        
        @mRate = @fromPercentage(@percentProgress, @gaConfig.mutationRateStart, @gaConfig.mutationRateEnd)
        @mRange = @fromPercentage(@percentProgress, @gaConfig.mutationRangeStart, @gaConfig.mutationRangeEnd)
        
        oldPopulation = @currentPopulation
        @currentPopulation = new Array()
        
        while @currentPopulation.length < @gaConfig.populationSize
            #tournament selection to get parents for crossover
        
            parents = new Array()
            while parents.length < @gaConfig.numParentsForCrossover
                parents.push(@tournamentSelect(oldPopulation, fitnesses))
            #crossover
            children = @crossover(parents)
            #mutate offspring
            mutatedChildren = []
            mutatedChildren.push(@mutate child) for child in children
            #add to population
            @currentPopulation.push(mChild) for mChild in mutatedChildren
            
        if @currentIteration < @gaConfig.maxIterations then @currentIteration++
        
        @currentPopulation
        
    mutate: (child) ->
        #
        mutatedChild = []
        for gene in child
            p = Math.random()
            if p < @mRate
                mutatedChild.push (gene + randomB(-@mRange, @mRange))
            else
                mutatedChild.push gene
        mutatedChild
                
        
    crossover: (parents) ->
        crossoverPoint = Math.floor (randomB(0, parents[0].length))
        [parent0, parent1] = parents
        
        child0 = parent0
        if crossoverPoint < child0.length then child0[crossoverPoint .. (child0.length-1)] = parent1[crossoverPoint .. (child0.length-1)]
        
        child1 = parent1
        if crossoverPoint < child1.length then child1[crossoverPoint .. (child1.length-1)] = parent0[crossoverPoint .. (child1.length-1)]
        
        mutatedChildren = [child0, child1]
        
            
    tournamentSelect: (oldPopulation, fitnesses) ->
        
        tourn = []
        
        #randomly select chromosome with fitness and add to array
        #console.log "k: " + @k
        while tourn.length < @k
            #console.log "loop"
            randomIndex = Math.floor(Math.random() * oldPopulation.length)
            tourn.push([oldPopulation[randomIndex], fitnesses[randomIndex]])
            
        #sort the list based on fitness
        tourn.sort((a,b) -> (a[1] - b[1]))
        
        r = Math.random()
        
        p = @p
        i = 0
        while (r > p and (i < tourn.length - 1))
            i++
            p += (p * Math.pow((1-p),i))
            
        tourn[i][0]
            
        #randomlySelectFromArray(oldPopulation)
            
        
window.GAConfig = GAConfig
window.GeneticAlgorithm = GeneticAlgorithm
        