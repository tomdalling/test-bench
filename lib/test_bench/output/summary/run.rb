module TestBench
  module Output
    module Summary
      module Run
        include Writer::Dependency
        extend Print

        def self.included(cls)
          cls.prepend(OutputMethods)
        end

        def file_count
          @file_count ||= 0
        end
        attr_writer :file_count

        def test_count
          @test_count ||= 0
        end
        attr_writer :test_count

        def pass_count
          @pass_count ||= 0
        end
        attr_writer :pass_count

        def skip_count
          @skip_count ||= 0
        end
        attr_writer :skip_count

        def failure_count
          @failure_count ||= 0
        end
        attr_writer :failure_count

        def error_count
          @error_count ||= 0
        end
        attr_writer :error_count

        def elapsed_time
          @elapsed_time ||= 0
        end
        attr_writer :elapsed_time

        def timer
          @timer ||= Timer::Substitute.build
        end
        attr_writer :timer

        module OutputMethods
          def enter_file(_)
            super

            timer.start
          end

          def exit_file(_, _)
            super

            elapsed_time = timer.stop

            self.elapsed_time += elapsed_time

            self.file_count += 1
          end

          def finish_test(_, result)
            super

            self.test_count += 1

            if result
              self.pass_count += 1
            else
              self.failure_count += 1
            end
          end

          def skip_test(_)
            super

            self.skip_count += 1
          end

          def error(_)
            super

            self.error_count += 1
          end

          def finish(_)
            super

            Print.(file_count: file_count, test_count: test_count, pass_count: pass_count, skip_count: skip_count, failure_count: failure_count, error_count: error_count, elapsed_time: elapsed_time, writer: writer)
          end
        end
      end
    end
  end
end
