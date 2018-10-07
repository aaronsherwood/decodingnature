// Child class constructor
class NoDeathSystem extends ParticleSystem{
  NoDeathSystem(PVector position) {
    super(position);
  }

  // Override the run method
  void run() {
    for (Particle p : particles) {
      p.applyWind();
      p.run();
      p.checkEdges();
    }
  }
}