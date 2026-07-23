# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2025 Kerrick Long <me@kerricklong.com>
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

require "rubocop/rake_task"
require "rubycritic/rake_task"
require "inch/rake"

RuboCop::RakeTask.new

# Run rubycritic in a shell to prevent it from exiting the rake process
task :rubycritic do
  sh "bundle exec rubycritic --no-browser app lib sig"
end

Inch::Rake::Suggest.new("doc:suggest", "app/**/*.rb", "lib/**/*.rb", "sig/**/*.rbs") do |suggest|
  suggest.args << ""
end

namespace :reuse do
  desc "Run the REUSE Tool to confirm REUSE compliance"
  task :lint do
    sh "reuse lint"
  end

  desc "Add SPDX headers to files missing them (per AGENTS.md standards)"
  task :fix do
    copyright = "Kerrick Design, LLC <me@kerricklong.com>"
    license = "LicenseRef-LICENSE"

    # reuse annotate has no comment style for ERB, so hand-write a non-rendering
    # <%# … -%> header (the trailing -%> trims the newline, so it adds no output).
    annotate_erb = lambda do |file|
      content = File.read(file)
      next if content.include?("SPDX-License-Identifier")

      # REUSE-IgnoreStart — the tags below are a template, not this file's own.
      File.write(file, <<~HEADER + content)
        <%#
        SPDX-FileCopyrightText: #{Time.now.year} #{copyright}
        SPDX-License-Identifier: #{license}
        -%>
      HEADER
      # REUSE-IgnoreEnd
    end

    # Every path REUSE reports as missing copyright and/or licensing information,
    # across both of its sub-lists (missing both; missing license only).
    puts "Checking for files missing REUSE headers..."
    output = `reuse lint 2>&1`
    in_missing = false
    missing = output.lines.filter_map do |line|
      in_missing = true if line.include?("# MISSING COPYRIGHT AND LICENSING INFORMATION")
      in_missing = false if line.include?("# SUMMARY")
      next unless in_missing

      path = line[/^\* (.+)$/, 1]
      path if path && File.exist?(path)
    end

    if missing.empty?
      puts "All files have REUSE headers!"
    else
      missing.each do |file|
        puts "  Annotating #{file}"
        case File.extname(file)
        when ".erb"
          annotate_erb.call(file)
        when ".rbs", ".jbuilder"
          # reuse does not recognise these extensions; force the #-comment style.
          sh "reuse annotate --style python --license #{license} --copyright '#{copyright}' --skip-existing '#{file}'", verbose: false
        else
          # reuse picks the comment style, and writes a .license sidecar for binaries.
          sh "reuse annotate --license #{license} --copyright '#{copyright}' --skip-existing '#{file}'", verbose: false
        end
      end
    end
  end

  desc "Normalize Ruby files: frozen_string_literal at top, SPDX in #--/#++ block"
  task :normalize_ruby do
    ruby_extensions = %w[rb rake gemspec].freeze
    ruby_files = Dir.glob("**/*.{#{ruby_extensions.join(',')}}")
      .reject { |f| f.start_with?("vendor/", "tmp/", ".") }

    fixed_count = 0
    ruby_files.each do |file|
      content = File.read(file)
      original = content.dup

      # Skip if no SPDX header
      next unless content.match?(/# SPDX-/)

      # Extract components
      frozen = content.match?(/^# frozen_string_literal: true/)
      spdx_match = content.match(/(# SPDX-FileCopyrightText:[^\n]+\n(?:#[^\n]*\n)*# SPDX-License-Identifier:[^\n]+\n)/m)
      next unless spdx_match

      spdx_block = spdx_match[1]

      # Remove existing frozen_string_literal and SPDX block (and any #--/#+++)
      cleaned = content
        .sub(/^# frozen_string_literal: true\n+/, "")
        .sub(/^#--\s*\n/, "")
        .sub(spdx_block, "")
        .sub(/^#\+\+\s*\n/, "")
        .sub(/\A\n+/, "") # Remove leading blank lines

      # Rebuild file in correct order: frozen, blank, #--, SPDX, #++, rest
      new_content = ""
      new_content += "# frozen_string_literal: true\n\n" if frozen
      new_content += "#--\n#{spdx_block}#++\n\n"
      new_content += cleaned.sub(/\A\n+/, "") # Ensure no double blank lines

      if new_content != original
        File.write(file, new_content)
        puts "  Normalized #{file}"
        fixed_count += 1
      end
    end

    puts fixed_count.zero? ? "All Ruby files properly normalized!" : "Fixed #{fixed_count} files."
  end
end
task(:reuse) { Rake::Task["reuse:lint"].invoke }

namespace :lint do
  task :safe_rdoc_coverage do
    sh "bundle exec rake rdoc:coverage"
  end

  task docs: %w[lint:safe_rdoc_coverage rubycritic reuse:lint]
  task code: %w[rubocop rubycritic]
  task licenses: %w[reuse:lint]
  task all: %w[docs code licenses]

  namespace :fix do
    desc "Auto-fix RuboCop offenses (most aggressive)"
    task :rubocop do
      sh "bundle exec rubocop --autocorrect-all"
    end

    desc "Add SPDX headers and normalize Ruby file structure"
    task reuse: %w[reuse:fix reuse:normalize_ruby]

    desc "Run all auto-fix tasks"
    task all: %w[lint:fix:rubocop lint:fix:reuse]
  end
end

desc "Run all lint auto-fix tasks"
task("lint:fix") { Rake::Task["lint:fix:all"].invoke }

# Aliases for convenience
task "rubocop:autocorrect_all" => "lint:fix:rubocop"

desc "Run all lint tasks"
task(:lint) { Rake::Task["lint:all"].invoke }
