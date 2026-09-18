extends SceneTree
## Real physics regression: canonical primary strikes and authored recovery.
const SCENE=preload("res://scenes/fighter/fighter.tscn")
const IK=preload("res://scripts/fighter/contact_ik.gd")
const SURFACE=preload("res://scripts/fighter/skinned_surface.gd")
var total:=0
var failed:=0
var evidence:Array=[]
func _init()->void:call_deferred("run")
func check(ok:bool,message:String)->void:
 total+=1
 if not ok:
  failed+=1
  printerr("[FAIL] ",message)
func tick(count:=1)->void:
 for i in range(count):await physics_frame
func pair(id:String,inverse:=false)->Dictionary:
 var world:=Node3D.new();root.add_child(world)
 var a:Fighter=SCENE.instantiate();var b:Fighter=SCENE.instantiate()
 a.character_id=id;b.character_id="andy_ditch"
 a.player_index=2 if inverse else 1;b.player_index=1 if inverse else 2
 a.use_external_input=true;b.use_external_input=true
 a.position=Vector3(-.45,0,0);b.position=Vector3(.45,0,0)
 a.rotation.y=-PI/2;b.rotation.y=PI/2
 world.add_child(b if inverse else a);world.add_child(a if inverse else b)
 a.opponent=b;b.opponent=a
 return {"world":world,"a":a,"b":b}
func free_pair(ctx:Dictionary)->void:
 ctx.world.queue_free();await tick(2)
func run()->void:
 await tick(2)
 test_definitions()
 for id in ["tophiachu","cyraxx"]:
  for inverse in [false,true]:
   await test_clean(id,inverse,false)
   await test_clean(id,inverse,true)
  await test_invalid_targets(id)
  await test_recovery(id)
 await test_flurry_reversal()
 await test_flurry_miss()
 DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path("res://evidence"))
 var out:=FileAccess.open("res://evidence/authored-moves.json",FileAccess.WRITE)
 if out:out.store_string(JSON.stringify(evidence,"  "))
 print("AUTHORED MOVES: %d passed, %d failed, %d total"%[total-failed,failed,total])
 quit(1 if failed else 0)
func test_definitions()->void:
 for id in RosterData.get_all_ids():
  var d:=StrikeMoves.definition(id)
  var shares:=0.0;var last_end:=0.0;var unique:Dictionary={}
  for hit in d.hits:
   shares+=hit.share
   check(hit.start>=last_end and hit.end>hit.start and hit.end<=d.duration,"Ordered disjoint hit windows")
   check(not unique.has(hit.id),"Per-action hit identifiers unique")
   unique[hit.id]=true;last_end=hit.end
  check(absf(shares-1.)<.00001,"One total damage budget")
 check(StrikeMoves.display_name("cyraxx")=="Feedback Flurry","Canonical move name preserved")
 check(StrikeMoves.definition("cyraxx").hits.size()==3,"Three actual scheduled hits")
 check(StrikeMoves.definition("tophiachu").hits.size()==1,"One committed clothesline")
func test_clean(id:String,inverse:bool,block:bool)->void:
 var ctx:=pair(id,inverse);var a:Fighter=ctx.a;var b:Fighter=ctx.b
 await tick(3)
 if block:b.apply_command({"block":true});await tick(2)
 var hp:=b.vitality;var cost_start:=a.stamina;var events:Array=[]
 a.hit_landed.connect(func(_a,_b,dmg,blocked):events.append({"time":a.state_timer,"damage":dmg,"blocked":blocked}))
 a.apply_command({"strike":true})
 await tick(2)
 check(a.current_state==Fighter.State.STRIKING,"Input starts strike")
 check(is_equal_approx(a.stamina,cost_start-MatchRules.STRIKE_STAMINA_COST),"Pay stamina once for the whole strike")
 await tick(27)
 var definition:=StrikeMoves.definition(id)
 check(events.size()==definition.hits.size(),"Expected physical hit count: "+id)
 var budget:float=(30.+a.stat_power*6.)*(.25 if block else 1.)
 check(absf(hp-b.vitality-budget)<.001,"Damage unchanged across shares: "+id)
 var hype_budget:=0.0 if block else MatchRules.HYPE_GAIN_ON_HIT*(1.+a.stat_showmanship*.08)
 check(absf(a.hype-hype_budget)<.001,"No multi-hit Hype multiplication")
 check(a.current_state==Fighter.State.IDLE,"Recovery returns to idle")
 var after:=b.vitality;await tick(20)
 check(b.vitality==after,"No delayed duplicate hits")
 evidence.append({"id":id,"inverse":inverse,"block":block,"events":events,"damage":hp-b.vitality})
 await free_pair(ctx)
func test_invalid_targets(id:String)->void:
 var ctx:=pair(id);var a:Fighter=ctx.a;var b:Fighter=ctx.b
 await tick(2)
 for state in [Fighter.State.KNOCKED_DOWN,Fighter.State.PINNED,Fighter.State.DEFEATED]:
  b.current_state=state;b.state_timer=0;b.vitality=b.max_vitality
  a._start_strike();var hp:=b.vitality
  await tick(30)
  check(b.vitality==hp,"Standing strike excludes grounded/terminal target")
 b.current_state=Fighter.State.IDLE
 a.rotation.y=PI/2;a._start_strike();var hp:=b.vitality
 await tick(28)
 check(b.vitality==hp,"Backward target is not hit")
 b.position=Vector3(2.8,0,0);a.rotation.y=-PI/2;a._start_strike()
 await tick(28)
 check(b.vitality==hp,"Out-of-reach target is not hit")
 await free_pair(ctx)
func test_flurry_reversal()->void:
 var ctx:=pair("cyraxx");var a:Fighter=ctx.a;var b:Fighter=ctx.b
 await tick(2)
 var hits:Array=[];a.hit_landed.connect(func(_a,_b,damage,_blocked):hits.append(damage))
 a._start_strike()
 for frame in range(15):
  await tick()
  if hits.size()==1:break
 check(hits.size()==1,"Flurry first hit lands before counter")
 b.apply_command({"reversal":true})
 await tick(20)
 check(a.current_state==Fighter.State.KNOCKED_DOWN,"Mid-flurry reversal cancels remaining hits")
 check(hits.size()==1,"No third strike after reversal")
 await free_pair(ctx)
func test_flurry_miss()->void:
 var ctx:=pair("cyraxx");var a:Fighter=ctx.a;var b:Fighter=ctx.b
 await tick(2)
 var hits:Array=[];a.hit_landed.connect(func(_a,_b,damage,_blocked):hits.append(damage))
 b.position=Vector3(2.5,0,0);a._start_strike()
 await tick(13)
 b.position=Vector3(.45,0,0)
 await tick(17)
 check(hits.size()==2,"Missed first flurry window does not catch up")
 var amount:=0.0
 for value in hits:amount+=value
 check(absf(amount-54.0*.75)<.001,"Only connected hit shares do damage")
 await free_pair(ctx)
func test_recovery(id:String)->void:
 var metrics:Array=[]
 for enabled in [false,true]:
  var ctx:=pair(id);var a:Fighter=ctx.a
  ctx.b.position=Vector3(3,0,0)
  a.presentation.authored_motion_enabled=enabled
  await tick(3)
  a._set_state(Fighter.State.KNOCKED_DOWN);await tick(45)
  a._set_state(Fighter.State.GETTING_UP)
  var lift_sum:=0.;var max_lift:=0.;var max_foot_error:=0.;var points_count:=0;var root_before:=a.position
  var s:Skeleton3D=a.presentation.skeleton
  var lengths:Dictionary={}
  for bone in ["Forearm.L","Forearm.R","Hand.L","Hand.R","Shin.L","Shin.R","Foot.L","Foot.R"]:
   lengths[bone]=s.get_bone_pose_position(s.find_bone(bone)).length()
  for frame in range(38):
   await tick()
   var stage:Node=a.presentation.clearance
   lift_sum+=stage.correction.y;max_lift=maxf(max_lift,stage.correction.y)
   var m:Dictionary=SURFACE.measure(stage.surface.world_vertices());points_count+=m.vertices
   check(m.floor_penetration<.0001,"Recovery mesh above canvas")
   check(a.position.is_equal_approx(root_before),"Authored recovery never displaces gameplay root")
   for bone in lengths:
    check(absf(s.get_bone_pose_position(s.find_bone(bone)).length()-lengths[bone])<.00002,"Recovery limb translations unchanged")
   if enabled and frame>5 and frame<31:
    for d in a.presentation.polish.diagnostics:
     if d.kind=="getup_foot":max_foot_error=maxf(max_foot_error,d.error)
  check(a.current_state==Fighter.State.IDLE,"Gameplay recovery timing preserved")
  if enabled:check(max_foot_error<.035,"Loaded recovery ankles remain near support targets")
  var m:Dictionary={"enabled":enabled,"id":id,"mean_lift":lift_sum/38.,"max_lift":max_lift,"max_loaded_foot_error":max_foot_error,"audited_vertices":points_count}
  metrics.append(m);evidence.append(m)
  await free_pair(ctx)
 check(metrics[1].mean_lift<metrics[0].mean_lift*.50,"Authored recovery needs less than half the corrective lift")
