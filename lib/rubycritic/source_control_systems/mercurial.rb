module Rubycritic
  module SourceControlSystem

    class Mercurial < Base
      register_system

      def self.supported?
        `hg verify 2>&1` && $?.success?
      end

      def has_revision?
        head_reference && $?.success?
      end

      def head_reference
        current_revision = `hg identify --id --rev $(hg branch)`.chomp
        current_revision.chomp('+') #+ at the end indicates uncommitted changes
      end

      def travel_to_head
        raise StandardError.new("Configure your mercurial to support the shelve extension.") unless stash_capable
        stash_successful = stash_changes
        yield
      ensure
        travel_to_original_state if stash_successful
      end

      def revisions_count(path)
        `hg log #{path.shellescape} --template '1'`.size
      end

      def date_of_last_commit(path)
        `hg log #{path.shellescape} --template '{date|isodate}' --limit 1`.chomp
      end

      def self.to_s
        "Mercurial"
      end

      private

      def stash_changes
        `hg shelve --name rubycritic`
      end

      def travel_to_original_state
        `hg unshelve rubycritic`
      end

      def everything_committed?
        `hg status --quiet`.empty?
      end

      def stash_capable
        # Check hg shelve extension
        # Check if rubycritic shelve is empty/non-existent
      end

    end
  end
end
