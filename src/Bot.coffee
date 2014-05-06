class Bot

    constructor: (world, scene) ->
        
        #@wtf = 123#"hoobilaaboobilaaa!"
        
        @lTrackInput = 0
        @rTrackInput = 0
        
        # Graphics
        
        @bodyGeom = new THREE.CubeGeometry( 1, 1, 1 )
        @bodyMat = new THREE.MeshBasicMaterial( { wireframe:true } )
        #@body = new THREE.Mesh( @bodyGeom, @bodyMat )
        @body = new Physijs.BoxMesh( @bodyGeom, @bodyMat, 1.0, { restitution: .2 } )
        
        #console.log @body.matrixAutoUpdate
        @body.matrixAutoUpdate = false
        #@body.geometry.dynamic = true
        
        @wheelRadius = 0.2
        @wheelWidth = 0.3
        
        @wheelLeftGeom = new THREE.CylinderGeometry( @wheelRadius, @wheelRadius, @wheelWidth , 32, 32, false )
        @wheelLeftMat = new THREE.MeshBasicMaterial({
            wireframe:true
        })
        @wheelLeft = new THREE.Mesh( @wheelLeftGeom, @wheelLeftMat )
        @wheelLeft.rotation.z = -Math.PI/2
        @wheelLeft.position.x = 1.0
        @wheelLeft.position.y = -0.5
        
        @wheelRightGeom = new THREE.CylinderGeometry( @wheelRadius, @wheelRadius, @wheelWidth, 32, 32, false )
        @wheelRightMat = new THREE.MeshBasicMaterial({
            wireframe:true
        })
        @wheelRight = new THREE.Mesh( @wheelRightGeom, @wheelRightMat )
        @wheelRight.rotation.z = -Math.PI/2
        @wheelRight.position.x = -1.0
        @wheelRight.position.y = -0.5
        #CylinderGeometry(radiusTop, radiusBottom, height, radiusSegments, heightSegments, openEnded)
        
        @body.add( @wheelLeft )
        @body.add( @wheelRight )
        
        #@axisHelper = new THREE.AxisHelper( 2 )
        #@body.add( @axisHelper )
        
        scene.add( @body )
        
        ###
        @body.addEventListener( 'collision', (( other_object, linear_velocity, angular_velocity ) -> 
            #console.log other_object
            scene.remove( other_object )
        ))
        ###
        
        #`this` is the mesh with the event listener
        #other_object is the object `this` collided with
        #linear_velocity and angular_velocity are Vector3 objects which represent the velocity of the collision
        

    update: ->
        #if (@lTrackInput isnt 0.0 and @rTrackInput isnt 0.0) then console.log "lTrack: " + @lTrackInput + ", rTrack: " + @rTrackInput
        
        #@body.position.z += (@lTrackInput + @rTrackInput) * 0.01
        
        rot = (-@lTrackInput + @rTrackInput) * 0.05
        d = (@lTrackInput + @rTrackInput) * 0.05
        
        #console.log "rot: " + rot + ", d: " + d
        
        
        #@body.matrix.translate( new THREE.Vector3( 0, 0, d ) )
        #@body.matrix.rotateY( rot )
        
        v = @body.localToWorld( new THREE.Vector3( 0, 0, 1.0 ) )
        v1 = v.sub( @body.position )
        v1.y = 0
        v1.normalize()
        v1.multiplyScalar( d )
        #console.log v1
            
        @body.position.add( v1 )
        @body.rotation.add( new THREE.Vector3( 0, rot, 0 ) )
        
        @body.__dirtyPosition = true
        @body.__dirtyRotation = true
        
        @body.updateMatrix()
        
        
        #Physics
        
        
        
        #Update position
        #origin = transform.getOrigin()
        #origin = new Ammo.btVector3( @body.position.x, @body.position.y, @body.position.z )
        #@block.position.x = origin.x()
        #@block.position.y = origin.y()
        #@block.position.z = origin.z()

        #Update rotation
        #rotation = transform.getRotation()
        #rotation = new Ammo.btQuaternion( @body.quaternion.x, @body.quaternion.y, @body.quaternion.z, @body.quaternion.w )
        #@block.quaternion.x = rotation.x()
        #@block.quaternion.y = rotation.y()
        #@block.quaternion.z = rotation.z()
        #@block.quaternion.w = rotation.w()
        
        #transform = new Ammo.btTransform( rotation, origin )
        #ms = @botRigidBody.getMotionState()
        
        
        
        #t1 = new Ammo.btTransform()
        #ms.getWorldTransform( t1 )
        #orig = t1.getOrigin()
        #console.log (orig.x() + ", " + orig.y() + ", " + orig.z())
        
        #ms.setWorldTransform( transform )
        #@botRigidBody.setMotionState( ms )
        
        #set motion state of rigid body
        
        #Ammo.destroy( origin )
        #Ammo.destroy( rotation )
        #Ammo.destroy( transform )
        
        
        
    setInput: (l, r) ->
        @lTrackInput = l
        @rTrackInput = r
        
window.Bot = Bot
        