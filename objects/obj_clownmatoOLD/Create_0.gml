event_perform_object(obj_clownmato, ev_create, 0);
instance_change(obj_clownmato, false);
exit;

depth = 0;
hsp = 0;
vsp = 0;
movespeed = 4;
grav = 0.5;
jumpspeed = 5;
grounded = false;
state = states.walk;
deadspr = spr_banditochicken_dead;
walkspr = spr_clownmato_fall;
stunspr = spr_banditochicken_stun;
stunbuffer = 0;
stuntouchbuffer = 0;
stunmax = 50;
image_speed = 0.35;
platformid = -4;
hsp_carry = 0;
vsp_carry = 0;
