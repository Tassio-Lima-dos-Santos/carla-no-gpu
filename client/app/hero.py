import carla


class Hero(object):
    def __init__(self):
        self.world = None
        self.actor = None
        self.control = None

    def start(self, world):
        self.world = world
        self.actor = self.world.spawn_hero(blueprint_filter=world.args.filter)
        self.actor.set_autopilot(False, world.args.tm_port)

    def tick(self, throttle_n_steer, clock):
        pass

        # Uncomment and modify to control manually, disable autopilot too
        #
        ctrl = carla.VehicleControl()
        if throttle_n_steer[0] == 1:
            ctrl.reverse = False
            ctrl.throttle = 0.5
        elif throttle_n_steer[0] == -1:
            ctrl.reverse = True
            ctrl.throttle = 0.5
        if throttle_n_steer[1] == 1:
            ctrl.steer = 0.3
        elif throttle_n_steer[1] == -1:
            ctrl.steer = -0.3
        self.actor.apply_control(ctrl)

    def destroy(self):
        """Destroy the hero actor when class instance is destroyed"""
        if self.actor is not None:
            self.actor.destroy()
