class NNConfig
    constructor: (layerSizes, chromosome) ->
        @layers = []
        prevLayerSize = layerSizes[0]
        for currentLayerSize in layerSizes[1..]
            currentLayer = []
            #for each neuron
            for i in [1 .. currentLayerSize]
                #currentLayer.push(new Neuron(chromosome[0 .. prevLayerSize]))
                #chromosome.splice(0, prevLayerSize)
                currentLayer.push(new Neuron(chromosome.splice(0, prevLayerSize)))
            @layers.push(currentLayer)
            prevLayerSize = currentLayerSize
                
            
        
class Neuron
    constructor: (weightsWithBias) ->
        @weights = weightsWithBias[0..(weightsWithBias.length-2)]
        @bias = weightsWithBias[weightsWithBias.length-1]
        
    evaluate: ( input ) ->
        i = 0
        sum = 0
        for weight in @weights
            sum += ( weight * input[i] )
            i++
        sum += @bias
        
        @activation(sum)
        
    activation: ( sum ) =>
        1.0 / ( 1.0 + Math.exp( -sum ) )
            

class NN
    constructor: ( nnConfig ) ->
        @nnConfig = nnConfig
        
    evaluate: ( input ) ->
        prevLayerValues = input
        #prevLayerLength = input.length
        currentLayerValues = []
        for layer in @nnConfig.layers
            for neuron in layer
                currentLayerValues.push(neuron.evaluate(prevLayerValues))
            prevLayerValues = currentLayerValues
            currentLayerValues = []
        
        prevLayerValues
        
    toChromosome : ->
        chromosome = []
        for layer in @nnConfig.layers
            for neuron in layer
                chromosome = chromosome.concat(neuron.weights)
                chromosome.push(neuron.bias)
        chromosome
                
window.NNConfig = NNConfig
window.NN = NN
            