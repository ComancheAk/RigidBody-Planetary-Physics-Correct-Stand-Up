extends RigidBody
var target #Variable for current object Transform
var gravityCentre #Variable for gravity centre


func _ready():
	gravityCentre = get_node("../StaticBody").get_transform()
	pass

func _integrate_forces(state):
	target = state.transform
	print(state.transform) #Information for testing
	state.transform = orthonormalizePlanetary(target,gravityCentre)
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