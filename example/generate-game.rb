require './example_helper'
require 'pap/utils'

THREADS = (1..12)
PROBLEMS = [8, 32, 128, 512]
SCRIPTS = []

PROBLEMS.each do |pr|
  THREADS.each do |th|
    file = "#{pr}x#{pr}.txt"
    output = "#{pr}x#{pr}-#{th}.txt"
    command = "mpirun -n #{th} ./game-mpi inputs/#{file} results/#{output}"
    SCRIPTS << {
      :command => command,
      :name => "game-mpi-#{pr}-#{th}.sh"
    }
  end
end

options = {
  :template => PAP::Utils::Templates::MPI,
  :scripts => SCRIPTS,
  :folder => 'job_scripts',
  :home => '/home/pap14/pap14120/MPI/1',
  :ensure => ['results']
}

PAP::Utils::generate_scripts(options)
