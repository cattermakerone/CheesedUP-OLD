hsp = 0;
vsp = 0;
hsp_carry = 0;
vsp_carry = 0;
platformid = -4;
grav = 0.5;
grounded = false;
event_inherited();
monsterid = 2;
spr_dead = spr_monstertomato_dead;
spr_intro = spr_puppet_intro;
spr_introidle = spr_puppet_introidle;
state = states.robotidle;
inactivebuffer = 900;
snd = sound_create_instance("event:/sfx/monsters/puppetfly");
xs = room_width / 2;
yy = -100;
substate = states.fall;
backgroundID = -4;