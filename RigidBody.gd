extends RigidBody
var target #Variable for current object Transform
var gravityCentre #Variable for gravity centre
var xVelocity
var zVelocity


func _ready():
	gravityCentre = get_node("../StaticBody").get_transform()
	zVelocity = 0
	xVelocity = 0
	pass

func _integrate_forces(state):
	target = state.transform
	#print(state.get_total_gravity()) #Information for testing
	state.transform = orthonormalizePlanetary(target,gravityCentre)
	if (Input.is_action_pressed("ui_up")):
		zVelocity += 0.1
	if (Input.is_action_just_released("ui_up")):
		zVelocity = 0
	if (Input.is_action_pressed("ui_down")):
		zVelocity -= 0.1
	if (Input.is_action_just_released("ui_down")):
		zVelocity = 0
	if (zVelocity > 1):
			zVelocity = 1	
	if (zVelocity < -1):
			zVelocity = -1
	if (Input.is_action_pressed("ui_left")):
		xVelocity += 0.1
	if (Input.is_action_just_released("ui_left")):
		xVelocity = 0
	if (Input.is_action_pressed("ui_right")):
		xVelocity -= 0.1
	if (Input.is_action_just_released("ui_right")):
		xVelocity = 0
	if (xVelocity > 1):
			xVelocity = 1	
	if (xVelocity < -1):
			xVelocity = -1
	state.set_linear_velocity((target.basis.x*xVelocity+target.basis.z*zVelocity)+state.get_total_gravity())
	pass

func orthonormalizePlanetary(t,p):
	var g #g is a gravity vector from current body to gravity centre
	var z #Z is forward direction as used at Unity3D 
	var crossGZ #crossed and normalized product from g and z acts like new X-axis
	var newZ #crossed and normalized product from new X-axis and gravity vector
	g = (t.origin - p.origin).normalized()
	z = (t.origin + t.basis.z).normalized() 
	crossGZ = g.cross(z).normalized()
	newZ = crossGZ.cross(g).normalized()
	return Transform(crossGZ,g,newZ,t.origin)