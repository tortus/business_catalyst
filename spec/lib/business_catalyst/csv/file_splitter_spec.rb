require 'spec_helper'
require 'fileutils'

module BusinessCatalyst
  module CSV
    describe FileSplitter do
      subject {
        FileSplitter.new("test", :max_rows_per_file => 10, :header_row => ["Column 1"], :verbose => false, :logger => nil)
      }

      after(:each) do
        # cleanup any files generated

        begin
          subject.close
        rescue IOError
          # if it's already closed, awesome!
        end

        Dir.glob("test_*").each do |test_file|
          FileUtils.rm(test_file)
        end
      end

      def get_csv_writer_path(writer)
        if RUBY_VERSION =~ /\A1\.8/
          writer.send(:instance_variable_get, :@dev).path
        else
          writer.path
        end
      end

      describe "#start" do
        it "yields self" do
          expect {|b| subject.start(&b) }.to yield_control.once
        end
        it "opens a new file with the new row range appended" do
          subject.start do |splitter|
            expect(get_csv_writer_path(splitter.current_file)).to eq("test_1-10.csv")
          end
        end
      end

      describe "#start_row" do
        it "increments #current_row" do
          expect { subject.start_row }.to change(subject, :current_row).by(1)
        end
        it "increments #total_rows" do
          expect { subject.start_row }.to change(subject, :total_rows).by(1)
        end
        context "when current_row becomes greater than max_rows_per_file" do
          before do
            subject.max_rows_per_file = 10
            subject.send(:instance_variable_set, :@current_row, 10)
            subject.send(:instance_variable_set, :@total_rows, 10)
          end
          it "resets current_row to 1" do
            expect { subject.start_row }.to change(subject, :current_row).to(1)
          end
          it "closes #current_file" do
            file = double("File", :close => nil)
            subject.send(:instance_variable_set, :@current_file, file)
            subject.start_row
            expect(file).to have_received(:close)
          end
          it "opens a new file with the new row range appended" do
            subject.start_row
            expect(get_csv_writer_path(subject.current_file)).to eq("test_11-20.csv")
          end
          it "appends the new file name to #all_files" do
            subject.start_row
            expect(subject.all_files.last).to eq("test_11-20.csv")
          end
          it "prepends the header row to the new file" do
            subject.header_row = ["Column 1", "Column 2"]
            subject.start_row
            file = get_csv_writer_path(subject.current_file)
            subject.close
            line = File.open(file, 'r') do |f|
              f.readline
            end
            expect(line).to eq("Column 1,Column 2\n")
          end
          it "calls a block provided to #on_file_change" do
            it_works = false
            subject.on_file_change do
              it_works = true
            end
            subject.start_row
            expect(it_works).to eq(true)
          end
          it "calls a block provided to #on_file_change with itself, if block arity is 1 or more" do
            subject.on_file_change do |s|
              expect(s).to eq(subject)
            end
            subject.start_row
          end
        end
      end

    end
  end
end
