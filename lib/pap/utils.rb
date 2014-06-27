require 'pap/utils/version'
require 'fileutils'

module PAP
  module Utils
    module Templates
      MPI = <<'EOF'
#!/bin/bash

#@ wall_clock_limit = 00:20:00
#@ initialdir = .
#@ error = game_%j.err
#@ output = game_%j.out
#@ total_tasks = 1
#@ cpus_per_task = 12

# export EXTRAE_HOME=/apps/CEPBATOOLS/extrae/2.5.1/bullmpi/64
# export EXTRAE_CONFIG_FILE=./extrae.xml
# export LD_PRELOAD=${EXTRAE_HOME}/lib/libmpitrace.so  # C
# export LD_PRELOAD=${EXTRAE_HOME}/lib/libmpitracef.so  # Fortran

# Run the desired program
cd ${BENCHMARK_HOME}

${BENCHMARK_COMMAND}
EOF
      MPI_INS = <<'EOF'
#!/bin/bash

#@ wall_clock_limit = 00:20:00
#@ initialdir = .
#@ error = game_%j.err
#@ output = game_%j.out
#@ total_tasks = 1
#@ cpus_per_task = 12

export EXTRAE_HOME=/apps/CEPBATOOLS/extrae/2.5.1/bullmpi/64
export EXTRAE_CONFIG_FILE=./extrae.xml
export LD_PRELOAD=${EXTRAE_HOME}/lib/libmpitrace.so  # C
# export LD_PRELOAD=${EXTRAE_HOME}/lib/libmpitracef.so  # Fortran

# Run the desired program
cd ${BENCHMARK_HOME}

${BENCHMARK_COMMAND}
EOF
    end

    def self.generate_scripts(options = {})
      template = options.fetch(:template)
      scripts = options.fetch(:scripts)
      folder = options.fetch(:folder)
      home = options.fetch(:home)

      FileUtils.mkdir_p(folder)

      (options[:ensure] || []).each do |dir|
        FileUtils.mkdir_p(dir)
      end

      scripts.each do |scr|
        name = scr.fetch(:name)
        cmd = scr.fetch(:command)
        path = File.join(folder, name)

        final_template = template.gsub('${BENCHMARK_HOME}', home)
        final_template.gsub!('${BENCHMARK_COMMAND}', cmd)

        File.open(path, 'w') do |file|
          file.write(final_template)
        end
      end
    end
  end
end
