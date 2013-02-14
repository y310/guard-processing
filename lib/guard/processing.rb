require 'guard'
require 'guard/guard'
require 'pathname'

module Guard
  class Processing < Guard
    def initialize(watchers = [], options = {})
      options = { :pid_dir => 'tmp/pids' }.merge(options)
      FileUtils.makedirs(options[:pid_dir])
      FileUtils.makedirs(options[:output])
      super
    end

    def run_on_changes(paths)
      paths.map {|path| Pathname.new(path) }.each do |path|
        dir = path.expand_path.dirname
        process = ProcessController.new(options[:pid_dir], path)
        process.run("processing-java --sketch=#{dir} --output=#{options[:output]} --run --force")
      end
    end

    class ProcessController
      def initialize(pid_dir, path)
        @pid_dir = pid_dir
        @path = path
      end

      def pid_file_path
        @pid_fiie_path ||= File.join(@pid_dir, @path.basename)
      end

      def pid
        if File.exists?(pid_file_path)
          File.read(pid_file_path).to_i
        end
      end

      def kill
        if pid
          begin
            Process.kill('KILL', -Process.getpgid(pid))
          rescue Errno::ESRCH
            # Process does not exist
          ensure
            File.delete(pid_file_path)
          end
        end
      end

      def save(pid)
        open(pid_file_path, 'w') {|f| f.print Process.getpgid(pid) }
      end

      def spawn(command)
        Process.spawn({}, command, :pgroup => true)
      end

      def run(command)
        kill
        pid = spawn(command)
        save(pid)
      end
    end
  end
end
