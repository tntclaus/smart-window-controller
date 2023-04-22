include <NopSCADlib/utils/core/core.scad>
//include <NopSCADlib/utils/core/core.scad>
include <lib/bead_chain_sprocket/bead_chain_sprockets.scad>


module motor_and_pcb() {
    translate([0,3.25,-5])
    color("silver")
    rotate([180,0,0])
    import("../kicad/smart_curtain_controller.stl");
}

TUBE_CONNECTOR_L = 50;
MOTOR_DIA = 25;
TUBE_DIA_OUTER = 38;
TUBE_DIA_INNER = TUBE_DIA_OUTER-1.2*2;

MATERIAL_DIA_OUTER = 56;

PCB_DIA = 48;

MOUNT_HOLES = [[18.5,3.5,0], [-18,-5,0]];
LDR_HOLES = [[-14,-11,0], [0,-18,0]];

module place_mount_holes() {
    for(hole = MOUNT_HOLES)
    translate(hole)
    children();
}

module place_ldr_holes() {
    for(hole = LDR_HOLES)
    translate(hole)
    children();
}

module material_tube(l = 400) {
    color("brown")
    difference() {
        cylinder(d = MATERIAL_DIA_OUTER, h = l-1);
        translate_z(-.1)
        cylinder(d = TUBE_DIA_OUTER+.2, h = l+2);
    }
}

module roller_tube(l = 400) {
    color("silver")
    difference() {
        cylinder(d = TUBE_DIA_OUTER, h = l);
        translate_z(-.1)
        cylinder(d = TUBE_DIA_INNER, h = l+.2);
    }
}

module controller_case_shape_sketch(s) {
    hull() {
        circle(d = s);
        translate([0,30,0])
        square([s,1], center = true);
    }
}

module controller_case_cover_stl() {
    stl("controller_case_cover");
    difference() {
        translate_z(.1)
        union() {
            cylinder(d = MOTOR_DIA + 3, h = 12);
            color("green")
            linear_extrude(1.5)
                controller_case_shape_sketch(PCB_DIA+3);
        }
        cylinder(d = MOTOR_DIA, h = 20);
        place_mount_holes()
            cylinder(d = 3, h = 20);
        place_ldr_holes()
            cylinder(d = 6, h = 20);
    }
}

module controller_case_base_stl() {
    stl("controller_case_base");
    difference() {
        translate_z(.1)
        union() {
            linear_extrude(1.5)
                controller_case_shape_sketch(PCB_DIA+3);
        }
        place_mount_holes()
        cylinder(d = 3, h = 20);
    }
}

module motor_tube_connector_stl() {
    stl("motor_tube_connector");

    color("white") {
        difference() {
            cylinder(d = TUBE_DIA_OUTER, h = TUBE_CONNECTOR_L - 1);
            translate_z(- .1)
            cylinder(d = TUBE_DIA_INNER, h = TUBE_CONNECTOR_L);
        }
        translate_z(TUBE_CONNECTOR_L - 1)
        difference() {
            hull() {
                cylinder(d = TUBE_DIA_OUTER, h = .1);
                translate_z(2)
                cylinder(d = TUBE_DIA_INNER, h = .1);
            }

            translate_z(- .1)
            hull() {
                cylinder(d = TUBE_DIA_INNER, h = .2);
                translate_z(2)
                cylinder(d = TUBE_DIA_INNER - 1.2 * 2, h = .25);
            }
        }

        translate_z(TUBE_CONNECTOR_L)
        difference() {
            cylinder(d = TUBE_DIA_INNER, h = 10);
            translate_z(- .1)
            difference() {
                cylinder(d = 4.3, h = 12);
                translate([- 2, 1.65, 0])
                    cube([4, 4, 12]);
            }
        }
    }
}

module controller_case() {
    controller_case_cover_stl();
    translate_z(-10)
    controller_case_base_stl();
}

module bead_chain_sprocket_top_stl() {
    bead_chain_sprocket_half(BEAD_CHAIN_4x2x28);
}

module bead_chain_sprocket_bottom_stl() {
    vflip()
    bead_chain_sprocket_half(BEAD_CHAIN_4x2x28);
}

module roller_curtain_assembly() {

    translate_z(-3.5){
        motor_and_pcb();
        controller_case();
    }
//    motor_tube_connector_stl();
    {
//        translate_z(TUBE_CONNECTOR_L)
//        roller_tube(l = 400-TUBE_CONNECTOR_L);
//        material_tube(l = 400);
    }
    translate_z(410){
        bead_chain_sprocket_top_stl();
        bead_chain_sprocket_bottom_stl();
    }
}

rotate([0,90,0])
roller_curtain_assembly();
