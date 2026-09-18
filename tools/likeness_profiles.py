"""Hand-authored visual studies of source-labelled public portraits.

Values are art controls in the existing rig's units, NOT measurements or inferred
biometrics. Reference photographs are never embedded, downloaded at runtime, or
redistributed. Unresolved slots are explicitly marked, not assigned a guessed face.
"""
from copy import deepcopy

STUDIES = {
    "tophiachu": dict(status="source_attributed_study", sources=[
        "https://knowyourmeme.com/memes/people/tophiachu-tiktok-lolcow",
        "https://tenor.com/view/tophia-tophiachu-28-smirk-devious-gif-11870591702852091627"],
        width=.191, height=.337, chin=1.519, jaw=.98, cheek=1.04, temple=.94, depth=.145,
        eye_spread=.070, eye_width=.029, eye_open=.0062, eye_level=.558, hood=.004,
        nose_width=.032, nose_projection=.037, nose_level=.405, bridge=.018,
        mouth_width=.061, lip=.0054, mouth_level=.235, brow=.006,
        hair="volume_curls", glasses="none", beard="none", band=True,
        skin=(.62,.47,.35), hair_color=(.075,.058,.045), gear=(.26,.25,.29), trim=(.34,.26,.30),
        iris=(.22,.14,.09), neck_fill=.98, shirt=True),
    "novaonline": dict(status="source_attributed_study", sources=[
        "https://knowyourmeme.com/memes/people/nova-online-tiktok-lolcow",
        "https://www.youtube.com/watch?v=ZGQoShXI2Ho"],
        width=.192, height=.350, chin=1.516, jaw=1.00, cheek=1.015, temple=.90, depth=.146,
        eye_spread=.066, eye_width=.029, eye_open=.007, eye_level=.570, hood=.0025,
        nose_width=.027, nose_projection=.043, nose_level=.420, bridge=.022,
        mouth_width=.049, lip=.0045, mouth_level=.258, brow=.0045,
        hair="parted_shoulder", glasses="rectangle", beard="chin_shadow", band=False,
        skin=(.82,.68,.60), hair_color=(.22,.15,.11), gear=(.22,.17,.32), trim=(.27,.23,.35),
        iris=(.26,.24,.19), neck_fill=1.0, shirt=True),
    "cyraxx": dict(status="source_attributed_study", sources=[
        "https://tenor.com/view/cyraxx-chance-wilkins-psyraxx-43-gif-7870491556437349690"],
        width=.151, height=.355, chin=1.523, jaw=.86, cheek=.93, temple=.96, depth=.134,
        eye_spread=.056, eye_width=.027, eye_open=.0068, eye_level=.576, hood=.003,
        nose_width=.023, nose_projection=.052, nose_level=.408, bridge=.026,
        mouth_width=.043, lip=.0027, mouth_level=.240, brow=.004,
        hair="balding_fringe", glasses="none", beard="long_beard", band=False,
        skin=(.79,.66,.55), hair_color=(.26,.20,.14), gear=(.095,.10,.10), trim=(.35,.32,.19),
        iris=(.28,.30,.25), neck_fill=.85, shirt=True),
    "candy_rooks": dict(status="source_attributed_study", sources=[
        "https://open.spotify.com/episode/1cdZ9Rc2SO3ukrnMlHwerB"],
        width=.192, height=.349, chin=1.516, jaw=.99, cheek=1.025, temple=.96, depth=.148,
        eye_spread=.069, eye_width=.030, eye_open=.0075, eye_level=.570, hood=.003,
        nose_width=.034, nose_projection=.032, nose_level=.416, bridge=.015,
        mouth_width=.058, lip=.0064, mouth_level=.257, brow=.0048,
        hair="short_coils", glasses="none", beard="none", band=False,
        skin=(.50,.34,.27), hair_color=(.065,.049,.039), gear=(.16,.12,.135), trim=(.27,.20,.23),
        iris=(.13,.095,.065), neck_fill=1.02, shirt=True),
    "andy_ditch": dict(status="source_attributed_study", sources=[
        "https://tenor.com/view/andrew-ditch-ditch-poopsquatch-andy-ditch-andy-gif-16852068161994619749"],
        width=.192, height=.356, chin=1.505, jaw=1.05, cheek=1.04, temple=.90, depth=.152,
        eye_spread=.069, eye_width=.029, eye_open=.0065, eye_level=.602, hood=.004,
        nose_width=.028, nose_projection=.047, nose_level=.436, bridge=.024,
        mouth_width=.050, lip=.0037, mouth_level=.278, brow=.0035,
        hair="close_bald", glasses="rectangle", beard="short_stubble", band=False,
        skin=(.81,.66,.60), hair_color=(.20,.145,.12), gear=(.67,.34,.13), trim=(.34,.25,.19),
        iris=(.26,.29,.27), neck_fill=1.05, shirt=True),
    "daniel_larson": dict(status="source_attributed_study", sources=[
        "https://knowyourmeme.com/photos/2345829-daniel-larson",
        "https://tenor.com/view/daniel-larson-danderson-daniellarson-daniel-larson-gif-14768455700226943549"],
        width=.148, height=.355, chin=1.519, jaw=.79, cheek=.96, temple=.91, depth=.131,
        eye_spread=.058, eye_width=.029, eye_open=.0071, eye_level=.594, hood=.0025,
        nose_width=.021, nose_projection=.073, nose_level=.398, bridge=.033,
        mouth_width=.047, lip=.0028, mouth_level=.245, brow=.004,
        hair="rough_crop", glasses="none", beard="light_stubble", band=False,
        skin=(.76,.56,.44), hair_color=(.19,.125,.085), gear=(.12,.29,.52), trim=(.40,.28,.19),
        iris=(.28,.43,.48), neck_fill=.85, shirt=True),
    "referee_cobra": dict(status="source_attributed_study", sources=[
        "https://www.indy100.com/news/kingcobrajfs-youtuber-musician-cause-of-death-investigation-explained"],
        width=.162, height=.365, chin=1.512, jaw=.85, cheek=.96, temple=.91, depth=.139,
        eye_spread=.061, eye_width=.029, eye_open=.0071, eye_level=.590, hood=.003,
        nose_width=.022, nose_projection=.053, nose_level=.414, bridge=.027,
        mouth_width=.047, lip=.0035, mouth_level=.255, brow=.0045,
        hair="receding_long", glasses="wire_oval", beard="goatee", band=False,
        skin=(.78,.65,.57), hair_color=(.14,.10,.075), gear=(.75,.76,.75), trim=(.08,.085,.09),
        iris=(.26,.29,.25), neck_fill=.90, shirt=True),
    # Search results for these slots were generic logos or an ambiguous two-person
    # interview thumbnail. They are not sufficient for a claimed likeness change.
    "jupiter_the_hybrid": dict(status="needs_unambiguous_reference", sources=[], reason="Interview thumbnail contains multiple people; individual attribution not established."),
    "anacondasin": dict(status="needs_unambiguous_reference", sources=[], reason="Available channel/profile images are generic logos or missing-photo placeholders."),
}

def apply_visual_profiles(profiles):
    """Override palettes only; no collision, scale or skeletal proportions change."""
    result=deepcopy(profiles)
    for key,p in result.items():
        study=STUDIES[key]
        if study['status'] != 'source_attributed_study':continue
        for field in ['skin','hair_color','gear','trim']:
            p[field]=study[field]
    return result
