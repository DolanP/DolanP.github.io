class Block
    constructor: (pos, world, scene) ->
        @blockGeom = new THREE.CubeGeometry( 0.3, 0.3, 0.3 )
        @blockMat = new THREE.MeshBasicMaterial( { wireframe:true } )
        @block = new Physijs.BoxMesh( @blockGeom, @blockMat, 0.0, { restitution: .2 } )
        
        @block.position.copy( pos )
        
        @block.myTag = this
        
        scene.add( @block )

window.Block = Block