initPhysics = ->
        @collisionConfiguration = new Ammo.btDefaultCollisionConfiguration()
        @dispatcher = new Ammo.btCollisionDispatcher( @collisionConfiguration )
        @overlappingPairCache = new Ammo.btDbvtBroadphase()
        @solver = new Ammo.btSequentialImpulseConstraintSolver()
        @world = new Ammo.btDiscreteDynamicsWorld( @dispatcher, @overlappingPairCache, @solver, @collisionConfiguration )
        @world.setGravity(new Ammo.btVector3(0, -6.0, 0))
    
    
        groundTransform = new Ammo.btTransform()
        groundTransform.setIdentity()
        groundTransform.setOrigin(new Ammo.btVector3( 0, -6, 0 )) #Set initial position
 
        groundMass = 0#Mass of 0 means ground won't move from gravity or collisions
        motionState = new Ammo.btDefaultMotionState( groundTransform )
        groundShape = new Ammo.btBoxShape(new Ammo.btVector3( 5, 1, 5 ))
        localInertia = new Ammo.btVector3( 0, 0, 0 )
        rbInfo = new Ammo.btRigidBodyConstructionInfo( groundMass, motionState, groundShape, localInertia )
        groundAmmo = new Ammo.btRigidBody( rbInfo )
        @world.addRigidBody( groundAmmo )

        @boxes = []
    
        mass = 3 * 3 * 3 #Matches box dimensions for simplicity
        startTransform = new Ammo.btTransform()
        startTransform.setIdentity()
        startTransform.setOrigin(new Ammo.btVector3( 0.0, 10, 0.0)) #Set initial position
 
        localInertia = new Ammo.btVector3( 0, 0, 0 );
 
        boxShape = new Ammo.btBoxShape(new Ammo.btVector3( 0.5, 0.5, 0.5 ));
        boxShape.calculateLocalInertia( mass, localInertia );
 
        motionState = new Ammo.btDefaultMotionState( startTransform );
        rbInfo = new Ammo.btRigidBodyConstructionInfo( mass, motionState, boxShape, localInertia );
        boxAmmo = new Ammo.btRigidBody( rbInfo );
        @world.addRigidBody( boxAmmo );
    
        @boxes.push( boxAmmo ); #Keep track of this box
        
updatePhysics = (ms) ->
        #physics - to be put in update
        @world.stepSimulation( ms, 5 ); # Tells Ammo.js to apply physics for 1/60th of a second with a maximum of 5 steps
        @transform = new Ammo.btTransform()

        box = @boxes[0]
        box.getMotionState().getWorldTransform( transform )

        #Update position
        origin = transform.getOrigin()
        @cube.position.x = origin.x()
        @cube.position.y = origin.y()
        @cube.position.z = origin.z()

        #Update rotation
        rotation = transform.getRotation()
        @cube.quaternion.x = rotation.x()
        @cube.quaternion.y = rotation.y()
        @cube.quaternion.z = rotation.z()
        @cube.quaternion.w = rotation.w()