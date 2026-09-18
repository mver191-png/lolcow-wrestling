extends SceneTree
## Whole-match CPU smoke test through real controllers. No HP forcing, direct
## hit calls or forced escape values. Not a human usability/balance playtest.
var passed := 0
var failed := 0
var records: Array[Dictionary] = []
func _init() -> void: call_deferred("run")
func tick(n:=1) -> void:
    for i in range(n): await physics_frame
func check(ok:bool,message:String) -> void:
    if ok:passed+=1
    else:failed+=1;printerr("[FAIL] ",message)
func run() -> void:
    for spec in [["tophiachu","cyraxx",91707],["cyraxx","tophiachu",91708]]:
        seed(spec[2])
        MatchConfig.set_match(spec[0],spec[1],true,spec[2])
        var scene:Node3D=load("res://scenes/main.tscn").instantiate()
        var audio:=scene.get_node("AudioManager")
        scene.remove_child(audio);audio.free();AudioManager.instance=null
        root.add_child(scene)
        var a:Fighter=scene.get_node("Tophiachu")
        var b:Fighter=scene.get_node("Cyraxx")
        var manager:MatchManager=scene.get_node("MatchManager")
        var cpu:=CPUController.new();cpu.fighter=a;scene.add_child(cpu)
        var hits:Array[int]=[0];var pins:Array[int]=[0];var wins:Array=[]
        a.hit_landed.connect(func(_a,_b,_d,_blocked):hits[0]+=1)
        b.hit_landed.connect(func(_a,_b,_d,_blocked):hits[0]+=1)
        manager.match_ended.connect(func(winner,method):wins.append({"winner":winner.character_id,"method":method}))
        var pin_state:=false
        var frames:=0
        while frames<10800 and wins.is_empty():
            await tick();frames+=1
            if manager.current_state==MatchManager.MatchState.PIN_ATTEMPT and not pin_state:pins[0]+=1
            pin_state=manager.current_state==MatchManager.MatchState.PIN_ATTEMPT
            if frames%120==0:
                check(a.position.is_finite() and b.position.is_finite(),"Finite roots during CPU match")
                check(a.stamina>=0 and b.stamina>=0 and a.vitality>=0 and b.vitality>=0,"Resources remain nonnegative")
        check(wins.size()==1,"Natural terminal result within 180s: %s/%s"%[spec[0],spec[1]])
        check(hits[0]>0 and pins[0]>0,"Normal controllers produce strikes and pin attempts")
        await tick(100)
        check(wins.size()==1,"Whole-match result emitted once")
        var record={"a":spec[0],"b":spec[1],"seed":spec[2],"simulation_seconds":frames/60.0,"strike_hits":hits[0],"pin_attempts":pins[0],"results":wins,"hp_a":a.vitality,"hp_b":b.vitality}
        print("SOAK MATCH ",JSON.stringify(record));records.append(record)
        scene.queue_free();await tick(3)
    var file:=FileAccess.open("res://evidence/whole-matches.json",FileAccess.WRITE)
    file.store_string(JSON.stringify(records,"  "))
    print("WHOLE MATCHES: %d passed, %d failed"%[passed,failed])
    quit(1 if failed else 0)
