use legion::*;

pub struct Game {
    width: u32,
    height: u32,
    paused_state: PausedState,
    world: World,
    schedule: Schedule,
    resources: Resources,
}

impl Game {
    pub fn new() -> Game {
        let mut world = World::default();
        let mut resources = Resources::default();

        resources.insert(Time {
            elapsed_seconds: 0.0,
        });

        // push a component tuple into the world to create an entity
        let _entity: Entity =
            world.push((Position { x: 0.0, y: 0.0 }, Velocity { dx: 0.0, dy: 0.0 }));

        // or extend via an IntoIterator of tuples to add many at once (this is faster)
        let _entities: &[Entity] = world.extend(vec![
            (Position { x: 0.0, y: 0.0 }, Velocity { dx: 0.0, dy: 0.0 }),
            (Position { x: 1.0, y: 1.0 }, Velocity { dx: 0.0, dy: 0.0 }),
            (Position { x: 2.0, y: 2.0 }, Velocity { dx: 0.0, dy: 0.0 }),
        ]);

        // construct a schedule (you should do this on init)
        let schedule = Schedule::builder()
            .add_system(update_positions_system())
            .build();

        Game {
            width: 800,
            height: 600,
            paused_state: PausedState::Playing,
            world: world,
            schedule: schedule,
            resources: resources,
        }
    }

    pub fn update(&mut self, delta: f32) {
        if let Some(mut time) = self.resources.get_mut::<Time>() {
            time.elapsed_seconds = delta;
        }
        // run our schedule (you should do this each update)
        self.schedule.execute(&mut self.world, &mut self.resources);
    }
}

// ----------------------------

#[derive(Copy, Clone)]
pub enum PausedState {
    Paused,
    Playing,
}

struct Time {
    elapsed_seconds: f32,
}

// a component is any type that is 'static, sized, send and sync
#[derive(Clone, Copy, Debug, PartialEq)]
struct Position {
    x: f32,
    y: f32,
}

#[derive(Clone, Copy, Debug, PartialEq)]
struct Velocity {
    dx: f32,
    dy: f32,
}

#[system(for_each)]
fn update_positions(pos: &mut Position, vel: &Velocity, #[resource] time: &Time) {
    println!("updating positions {}", time.elapsed_seconds);
    pos.x += vel.dx * time.elapsed_seconds;
    pos.y += vel.dy * time.elapsed_seconds;
}
